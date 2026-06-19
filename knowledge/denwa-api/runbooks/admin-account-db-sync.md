---
title: Runbook đồng bộ account quản trị DEV, STG và PRD
project: itec-denwa
type: runbook
status: confirmed
verified_at: 2026-06-19
stale_after: 2026-09-19
source:
  - Live DEV, STG and PRD database verification on 2026-06-19
  - project-store/knowledge/denwa-api/architecture/auth-role-model.md
  - registry/keystore/projects/itec-denwa/infra/shared/database-connections.yaml
  - ECS task definition denwa-backend-stg:164
tags:
  - database
  - admin
  - account
  - authentication
  - dev
  - stg
  - prd
---

# Runbook đồng bộ account quản trị DEV, STG và PRD

## Mục đích

Runbook này dùng để tạo mới hoặc reset đồng nhất sáu account quản trị trên DEV, STG và PRD mà không cần phân tích lại schema, role hoặc luồng đăng nhập.

Script:

- Audit read-only trước khi thay đổi.
- Tạo mới hoặc reset sáu master account.
- Tự sửa role master về giá trị đã chốt.
- Tạo mapping `master / account_type=0` nếu thiếu.
- Reset Okada tenant user role `2` nếu account này tồn tại trong tenant `111`.
- Xóa refresh token và reset bộ đếm đăng nhập lỗi.
- Kiểm tra BCrypt, role và mapping trong transaction trước khi commit.
- Dừng ngay nếu kết nối nhầm database, có nhiều master account active cùng login hoặc có nhiều Okada tenant user active.

Script không sửa IP whitelist. Whitelist là cấu hình backend theo role và phải được kiểm tra/deploy riêng.

## Mô hình account đã chốt

| Key | Login | Tên | Context | Role |
|---|---|---|---|---:|
| `katayama` | `katayama-ta@itec.hankyu-hanshin.co.jp` | 片山　剛 | Master Web | `0` |
| `higashitani` | `higashitani-hd@itec.hankyu-hanshin.co.jp` | 東谷　英樹 | Master Web | `0` |
| `okada` | `okd-biz@okadadenki.co.jp` | 岡田電機 | Master Web MVE | `3` |
| `admin01` | `pcall.admin01@gmail.com` | システム管理01 | Master Web | `0` |
| `admin02` | `pcall.admin02@gmail.com` | システム管理02 | Master Web | `0` |
| `admin03` | `pcall.admin03@gmail.com` | システム管理03 | Master Web | `0` |

Okada có thể đồng thời tồn tại ở hai context:

- `master_schema.admin`, role `3`: MVE admin trên Web.
- `"111_schema".users`, role `2`: mobile user của tenant `111`.

Không đổi Okada tenant user từ role `2` sang role `3`.

Mật khẩu của ba account `pcall.admin` đã chốt dùng ký tự đầu `P` viết hoa. Không ghi plaintext password vào knowledge, source, log hoặc command history.

## Mapping môi trường

| Môi trường | Database runtime | RDS | Local tunnel port | Config credential |
|---|---|---|---:|---|
| DEV | `denwa_dev` | `denwa-dev-database` | `15432` | `databases.dev` |
| STG | `denwa_stg` | `denwa-prd-database` | `35432` | `databases.prd` |
| PRD | `denwa_prd` | `denwa-prd-database` | `25432` | `databases.prd` |

Lưu ý: runtime STG đã được verify ngày 2026-06-19 là database `denwa_stg` trên RDS PRD. Không dùng endpoint `denwa-stg-database` cũ còn sót trong file properties local.

## Chuẩn bị SSH tunnel

Chạy từ repo root.

### DEV

```bash
rtk ssh \
  -i registry/keystore/projects/itec-denwa/infra/shared/ec2-keypair-denwa-vti.pem \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -f -N \
  -L 15432:denwa-dev-database.ch44weeyqqnw.ap-northeast-1.rds.amazonaws.com:5432 \
  ubuntu@13.231.207.171
```

### STG

```bash
rtk ssh \
  -i registry/keystore/projects/itec-denwa/infra/shared/ec2-keypair-denwa-vti.pem \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -f -N \
  -L 35432:denwa-prd-database.ch44weeyqqnw.ap-northeast-1.rds.amazonaws.com:5432 \
  ubuntu@13.231.207.171
```

### PRD

```bash
rtk ssh \
  -i registry/keystore/projects/itec-denwa/infra/shared/ec2-keypair-denwa-vti.pem \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -f -N \
  -L 25432:denwa-prd-database.ch44weeyqqnw.ap-northeast-1.rds.amazonaws.com:5432 \
  ubuntu@13.231.207.171
```

## Script dùng chung

Lưu block sau thành `scratch/admin_account_db_sync.py`. Không thêm password vào file.

```python
import argparse
import getpass
import json
import uuid

import bcrypt
import psycopg
import yaml


CONFIG_PATH = (
    "registry/keystore/projects/itec-denwa/"
    "infra/shared/database-connections.yaml"
)

ENVIRONMENTS = {
    "dev": {
        "config_key": "dev",
        "port": 15432,
        "database": "denwa_dev",
    },
    "stg": {
        "config_key": "prd",
        "port": 35432,
        "database": "denwa_stg",
    },
    "prd": {
        "config_key": "prd",
        "port": 25432,
        "database": "denwa_prd",
    },
}

ACCOUNTS = {
    "katayama": (
        "katayama-ta@itec.hankyu-hanshin.co.jp",
        "片山　剛",
        "0",
    ),
    "higashitani": (
        "higashitani-hd@itec.hankyu-hanshin.co.jp",
        "東谷　英樹",
        "0",
    ),
    "okada": (
        "okd-biz@okadadenki.co.jp",
        "岡田電機",
        "3",
    ),
    "admin01": (
        "pcall.admin01@gmail.com",
        "システム管理01",
        "0",
    ),
    "admin02": (
        "pcall.admin02@gmail.com",
        "システム管理02",
        "0",
    ),
    "admin03": (
        "pcall.admin03@gmail.com",
        "システム管理03",
        "0",
    ),
}


def get_connection_args(environment):
    target = ENVIRONMENTS[environment]
    with open(CONFIG_PATH, encoding="utf-8") as file:
        databases = yaml.safe_load(file)["databases"]
    credential = databases[target["config_key"]]
    return {
        "host": "127.0.0.1",
        "port": target["port"],
        "dbname": target["database"],
        "user": credential["username"],
        "password": credential["password"],
        "connect_timeout": 10,
    }


def verify_database(cursor, environment):
    cursor.execute("SELECT current_database()")
    actual = cursor.fetchone()[0]
    expected = ENVIRONMENTS[environment]["database"]
    if actual != expected:
        raise RuntimeError(
            f"Wrong database: expected={expected}, actual={actual}"
        )
    return actual


def audit(environment):
    result = {
        "environment": environment,
        "database": None,
        "master_accounts": {},
        "okada_tenant_user": {},
    }
    with psycopg.connect(
        **get_connection_args(environment)
    ) as connection:
        connection.read_only = True
        with connection.cursor() as cursor:
            cursor.execute("SET statement_timeout = '15s'")
            result["database"] = verify_database(cursor, environment)

            for key, (login, _, expected_role) in ACCOUNTS.items():
                cursor.execute(
                    """
                    SELECT role
                    FROM master_schema.admin
                    WHERE admin_name = %s
                      AND delete_flag = '0'
                    """,
                    (login,),
                )
                rows = cursor.fetchall()
                cursor.execute(
                    """
                    SELECT COUNT(*)
                    FROM master_schema.account_mapping
                    WHERE user_name = %s
                      AND tenant_id = 'master'
                      AND account_type = '0'
                    """,
                    (login,),
                )
                result["master_accounts"][key] = {
                    "active_rows": len(rows),
                    "role": rows[0][0] if len(rows) == 1 else None,
                    "expected_role": expected_role,
                    "mapping_count": cursor.fetchone()[0],
                }

            cursor.execute(
                """
                SELECT role
                FROM "111_schema".users
                WHERE user_name = %s
                  AND delete_flag = '0'
                  AND user_status = '3'
                """,
                (ACCOUNTS["okada"][0],),
            )
            rows = cursor.fetchall()
            result["okada_tenant_user"] = {
                "active_rows": len(rows),
                "role": rows[0][0] if len(rows) == 1 else None,
            }

    print(json.dumps(result, ensure_ascii=False, indent=2))


def apply(environment):
    passwords = {
        key: getpass.getpass(f"{key} password: ")
        for key in ACCOUNTS
    }
    if any(not password for password in passwords.values()):
        raise RuntimeError("Password must not be empty")

    encoded = {
        key: bcrypt.hashpw(
            password.encode(),
            bcrypt.gensalt(),
        ).decode()
        for key, password in passwords.items()
    }
    result = {
        "status": "pending",
        "environment": environment,
        "database": None,
        "master_actions": [],
        "okada_tenant_user": "not_found",
    }

    with psycopg.connect(
        **get_connection_args(environment)
    ) as connection:
        with connection.transaction():
            with connection.cursor() as cursor:
                cursor.execute("SET LOCAL statement_timeout = '30s'")
                cursor.execute("SET LOCAL lock_timeout = '10s'")
                result["database"] = verify_database(
                    cursor,
                    environment,
                )

                for key, (
                    login,
                    full_name,
                    expected_role,
                ) in ACCOUNTS.items():
                    cursor.execute(
                        """
                        SELECT admin_uuid, role
                        FROM master_schema.admin
                        WHERE admin_name = %s
                          AND delete_flag = '0'
                        FOR UPDATE
                        """,
                        (login,),
                    )
                    rows = cursor.fetchall()
                    if len(rows) > 1:
                        raise RuntimeError(
                            f"Multiple active admins: {login}"
                        )

                    if rows:
                        previous_role = rows[0][1]
                        cursor.execute(
                            """
                            UPDATE master_schema.admin
                            SET admin_password = %s,
                                admin_full_name = %s,
                                admin_full_name_kana = %s,
                                role = %s,
                                login_failure_count = 0,
                                reset_password_failure_count = 0,
                                lock_reset_password_time = NULL,
                                refresh_token = NULL,
                                refresh_token_expiry_time = NULL,
                                last_modified_by = admin_uuid,
                                last_modified_date = CURRENT_TIMESTAMP,
                                version_no =
                                    COALESCE(version_no, 0) + 1
                            WHERE admin_uuid = %s
                            """,
                            (
                                encoded[key],
                                full_name,
                                full_name,
                                expected_role,
                                rows[0][0],
                            ),
                        )
                        action = (
                            "reset_and_role_corrected"
                            if previous_role != expected_role
                            else "reset"
                        )
                    else:
                        admin_uuid = str(uuid.uuid4())
                        cursor.execute(
                            """
                            INSERT INTO master_schema.admin (
                                admin_uuid,
                                admin_name,
                                admin_password,
                                admin_full_name,
                                admin_full_name_kana,
                                role,
                                last_login_time,
                                admin_tel,
                                refresh_token,
                                refresh_token_expiry_time,
                                login_failure_count,
                                created_by,
                                created_date,
                                last_modified_by,
                                last_modified_date,
                                delete_flag,
                                version_no,
                                lock_reset_password_time,
                                reset_password_failure_count
                            ) VALUES (
                                %s, %s, %s, %s, %s, %s,
                                NULL, '0', NULL, NULL, 0,
                                %s, CURRENT_TIMESTAMP,
                                %s, CURRENT_TIMESTAMP,
                                '0', 1, NULL, 0
                            )
                            """,
                            (
                                admin_uuid,
                                login,
                                encoded[key],
                                full_name,
                                full_name,
                                expected_role,
                                admin_uuid,
                                admin_uuid,
                            ),
                        )
                        action = "created"

                    cursor.execute(
                        """
                        INSERT INTO master_schema.account_mapping (
                            user_name,
                            tenant_id,
                            account_type
                        )
                        VALUES (%s, 'master', '0')
                        ON CONFLICT (
                            user_name,
                            tenant_id,
                            account_type
                        ) DO NOTHING
                        """,
                        (login,),
                    )
                    result["master_actions"].append(
                        {
                            "login": login,
                            "action": action,
                            "role": expected_role,
                        }
                    )

                cursor.execute(
                    """
                    SELECT user_uuid, role
                    FROM "111_schema".users
                    WHERE user_name = %s
                      AND delete_flag = '0'
                      AND user_status = '3'
                    FOR UPDATE
                    """,
                    (ACCOUNTS["okada"][0],),
                )
                okada_users = cursor.fetchall()
                if len(okada_users) > 1:
                    raise RuntimeError(
                        "Multiple active Okada tenant users"
                    )
                if okada_users:
                    if okada_users[0][1] != "2":
                        raise RuntimeError(
                            "Unexpected Okada tenant-user role: "
                            f"{okada_users[0][1]}"
                        )
                    cursor.execute(
                        """
                        UPDATE "111_schema".users
                        SET user_password = %s,
                            login_failure_count = 0,
                            reset_password_failure_count = 0,
                            lock_reset_password_time =
                                CURRENT_TIMESTAMP,
                            refresh_token = NULL,
                            refresh_token_expiry_time = NULL,
                            last_modified_by = user_uuid,
                            last_modified_date =
                                CURRENT_TIMESTAMP,
                            version_no =
                                COALESCE(version_no, 0) + 1
                        WHERE user_uuid = %s
                        """,
                        (
                            encoded["okada"],
                            okada_users[0][0],
                        ),
                    )
                    result["okada_tenant_user"] = "reset"

                for key, (
                    login,
                    _,
                    expected_role,
                ) in ACCOUNTS.items():
                    cursor.execute(
                        """
                        SELECT admin_password, role
                        FROM master_schema.admin
                        WHERE admin_name = %s
                          AND delete_flag = '0'
                        """,
                        (login,),
                    )
                    rows = cursor.fetchall()
                    cursor.execute(
                        """
                        SELECT COUNT(*)
                        FROM master_schema.account_mapping
                        WHERE user_name = %s
                          AND tenant_id = 'master'
                          AND account_type = '0'
                        """,
                        (login,),
                    )
                    mapping_count = cursor.fetchone()[0]
                    verified = (
                        len(rows) == 1
                        and rows[0][1] == expected_role
                        and bcrypt.checkpw(
                            passwords[key].encode(),
                            rows[0][0].encode(),
                        )
                        and mapping_count == 1
                    )
                    if not verified:
                        raise RuntimeError(
                            f"Verification failed: {login}"
                        )

                    if key.startswith("admin"):
                        lowercase_variant = (
                            "p" + passwords[key][1:]
                        )
                        if bcrypt.checkpw(
                            lowercase_variant.encode(),
                            rows[0][0].encode(),
                        ):
                            raise RuntimeError(
                                "Lowercase password matched: "
                                f"{login}"
                            )

                if okada_users:
                    cursor.execute(
                        """
                        SELECT user_password
                        FROM "111_schema".users
                        WHERE user_uuid = %s
                        """,
                        (okada_users[0][0],),
                    )
                    if not bcrypt.checkpw(
                        passwords["okada"].encode(),
                        cursor.fetchone()[0].encode(),
                    ):
                        raise RuntimeError(
                            "Okada tenant-user verification failed"
                        )

    result["status"] = "committed"
    print(json.dumps(result, ensure_ascii=False, indent=2))


parser = argparse.ArgumentParser()
parser.add_argument(
    "--env",
    required=True,
    choices=ENVIRONMENTS,
)
parser.add_argument("--audit", action="store_true")
args = parser.parse_args()

if args.audit:
    audit(args.env)
else:
    apply(args.env)
```

## Lệnh thực thi

Luôn audit trước:

```bash
rtk uv run \
  --with 'psycopg[binary]' \
  --with bcrypt \
  --with pyyaml \
  python scratch/admin_account_db_sync.py \
  --env dev \
  --audit
```

Thay `dev` bằng `stg` hoặc `prd` theo môi trường cần thao tác.

Sau khi xác nhận audit đúng database và trạng thái account, chạy apply:

```bash
rtk uv run \
  --with 'psycopg[binary]' \
  --with bcrypt \
  --with pyyaml \
  python scratch/admin_account_db_sync.py \
  --env dev
```

Nhập sáu password theo prompt ẩn. Với `admin01`, `admin02`, `admin03`, xác nhận ký tự đầu là `P` viết hoa.

Sau khi script báo `"status": "committed"`, chạy lại lệnh `--audit`. Kết quả đúng phải có:

- `database` đúng với bảng mapping môi trường.
- Sáu master account đều có `active_rows=1`.
- Katayama, Higashitani và ba `pcall.admin` có role `0`.
- Okada master có role `3`.
- Mỗi master account có `mapping_count=1`.
- Okada tenant user, nếu tồn tại, có role `2`.

## Đóng tunnel

```bash
rtk pkill -f \
  '15432:denwa-dev-database.ch44weeyqqnw.ap-northeast-1.rds.amazonaws.com:5432'

rtk pkill -f \
  '35432:denwa-prd-database.ch44weeyqqnw.ap-northeast-1.rds.amazonaws.com:5432'

rtk pkill -f \
  '25432:denwa-prd-database.ch44weeyqqnw.ap-northeast-1.rds.amazonaws.com:5432'
```

Chỉ chạy lệnh tương ứng với tunnel đã mở.

## IP whitelist

DB không lưu quan hệ IP–account.

- System admin role `0`: `ip.whitelist.system.admin`.
- MVE admin role `3`: `ip.whitelist.mve.admin`.

Nếu IP chưa có, phải sửa config đúng môi trường, push branch tương ứng và để pipeline deploy backend. Không coi việc update DB là đã hoàn tất whitelist.

## Lịch sử triển khai

| Ngày | Môi trường | Kết quả |
|---|---|---|
| 2026-06-19 | PRD | Reset account cũ, tạo ba `pcall.admin`, tạo/sửa Okada MVE admin role `3`, reset Okada tenant user role `2`, verify BCrypt và mapping thành công. |
| 2026-06-19 | DEV | Đồng bộ cùng mô hình PRD, reset account cũ, tạo ba `pcall.admin`, verify role, BCrypt và mapping thành công. |
| 2026-06-19 | STG | Runtime xác nhận dùng `denwa_stg` trên RDS PRD; reset ba account cũ, tạo ba `pcall.admin`, reset Okada tenant user và verify thành công. |

## Tài liệu liên quan

- [Mô hình role và lưu trữ account](../architecture/auth-role-model.md)
