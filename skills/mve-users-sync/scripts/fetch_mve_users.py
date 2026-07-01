#!/usr/bin/env python3
import argparse
import base64
import csv
import json
import re
import ssl
import sys
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

try:
    import psycopg
    from psycopg.rows import dict_row
except ImportError as exc:
    raise SystemExit(
        "Missing psycopg. Run with: rtk uv run --with pyyaml --with 'psycopg[binary]' python ..."
    ) from exc

try:
    import yaml
except ImportError as exc:
    raise SystemExit(
        "Missing PyYAML. Run with: rtk uv run --with pyyaml --with 'psycopg[binary]' python ..."
    ) from exc


def find_repo_root() -> Path:
    for parent in Path(__file__).resolve().parents:
        if (parent / "AGENTS.md").exists() and (parent / "registry").is_dir():
            return parent
    raise RuntimeError("Cannot find repository root from script location")


REPO_ROOT = find_repo_root()
DB_CONFIG_PATH = (
    REPO_ROOT
    / "registry/keystore/projects/itec-denwa/infra/shared/database-connections.yaml"
)
MVE_AUTH_CONFIG_PATH = (
    REPO_ROOT
    / "registry/keystore/projects/itec-denwa/infra/staging/application.properties"
)

ENVIRONMENTS = {
    "dev": {
        "config_key": "dev",
        "local_port": 15432,
        "database": "denwa_dev",
    },
    "prd": {
        "config_key": "prd",
        "local_port": 25432,
        "database": "denwa_prd",
    },
}


def load_properties(path: Path) -> dict[str, str]:
    properties = {}
    with path.open("r", encoding="utf-8") as file:
        for raw_line in file:
            line = raw_line.strip()
            if not line or line.startswith("#") or line.startswith("!"):
                continue
            if "=" not in line:
                continue
            key, value = line.split("=", 1)
            properties[key.strip()] = value.strip()
    return properties


def load_database_config(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as file:
        return yaml.safe_load(file)["databases"]


def get_connection_args(environment: str, db_config: dict) -> dict:
    target = ENVIRONMENTS[environment]
    credential = db_config[target["config_key"]]
    return {
        "host": "127.0.0.1",
        "port": target["local_port"],
        "dbname": target["database"],
        "user": credential["username"],
        "password": credential["password"],
        "connect_timeout": 10,
    }


def read_mve_target(environment: str, db_config: dict) -> dict:
    target = ENVIRONMENTS[environment]
    with psycopg.connect(
        **get_connection_args(environment, db_config),
        row_factory=dict_row,
    ) as connection:
        connection.read_only = True
        with connection.cursor() as cursor:
            cursor.execute("SET statement_timeout = '20s'")
            cursor.execute("SELECT current_database() AS database")
            database = cursor.fetchone()["database"]
            if database != target["database"]:
                raise RuntimeError(
                    f"Wrong database for {environment}: expected={target['database']}, actual={database}"
                )

            cursor.execute(
                """
                SELECT ip_address, domain, port_udp, port_tls, version_no
                FROM master_schema.system_settings
                WHERE delete_flag = B'0'
                ORDER BY version_no DESC
                LIMIT 1
                """
            )
            row = cursor.fetchone()
            if row is None:
                raise RuntimeError(f"No active system_settings row for {environment}")

    result = dict(row)
    result["database"] = database
    result["ini_url"] = f"https://{result['domain']}/api/v1/files/ini"
    return result


def fetch_mve_ini(url: str, username: str, password: str, timeout: int, verify_tls: bool) -> str:
    context = ssl.create_default_context()
    if not verify_tls:
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE

    request = urllib.request.Request(url)
    token = base64.b64encode(f"{username}:{password}".encode("utf-8")).decode("ascii")
    request.add_header("Authorization", f"Basic {token}")

    with urllib.request.urlopen(request, context=context, timeout=timeout) as response:
        return response.read().decode("utf-8")


def parse_sbc_users(ini_content: str) -> list[dict[str, str]]:
    users = []
    in_table = False

    for raw_line in ini_content.splitlines():
        line = raw_line.strip()
        if line == "[ SBCUserInfoTable ]":
            in_table = True
            continue
        if line == r"[ \SBCUserInfoTable ]":
            in_table = False
            continue
        if not in_table or not line.startswith("SBCUserInfoTable"):
            continue

        parts = line.split("=", 1)
        if len(parts) != 2:
            continue
        values = re.findall(r'"([^"]*)"', parts[1].strip().rstrip(";"))
        if len(values) < 4:
            continue
        users.append(
            {
                "username": values[0],
                "authname": values[1],
                "password_hash": values[2],
                "ip_group": values[3],
            }
        )

    return sorted(users, key=lambda user: (user["ip_group"], user["username"]))


def public_users(users: list[dict[str, str]], include_password_hash: bool) -> list[dict[str, str]]:
    fields = ["username", "authname", "ip_group"]
    if include_password_hash:
        fields.insert(2, "password_hash")
    return [{field: user[field] for field in fields} for user in users]


def fetch_environment(
    environment: str,
    db_config: dict,
    mve_username: str,
    mve_password: str,
    timeout: int,
    verify_tls: bool,
    include_password_hash: bool,
) -> dict:
    target = read_mve_target(environment, db_config)
    ini_content = fetch_mve_ini(
        target["ini_url"],
        mve_username,
        mve_password,
        timeout,
        verify_tls,
    )
    users = parse_sbc_users(ini_content)
    return {
        "environment": environment,
        "database": target["database"],
        "mve_target": {
            "ip_address": target["ip_address"],
            "domain": target["domain"],
            "port_udp": target["port_udp"],
            "port_tls": target["port_tls"],
            "version_no": target["version_no"],
            "ini_url": target["ini_url"],
        },
        "count": len(users),
        "users": public_users(users, include_password_hash),
    }


def render_text(results: dict[str, dict]) -> str:
    sections = []
    for environment, result in results.items():
        if "error" in result:
            sections.append(f"{environment.upper()}\nERROR: {result['error']}")
            continue

        target = result["mve_target"]
        lines = [
            environment.upper(),
            f"DB: {result['database']}",
            f"MVE target: {target['domain']} ({target['ip_address']})",
            f"INI URL: {target['ini_url']}",
            f"Users: {result['count']}",
            "",
        ]
        grouped: dict[str, list[str]] = {}
        for user in result["users"]:
            grouped.setdefault(user["ip_group"], []).append(user["username"])
        for ip_group in sorted(grouped):
            lines.append(f"{ip_group}:")
            lines.append(", ".join(grouped[ip_group]))
            lines.append("")
        sections.append("\n".join(lines).rstrip())
    return "\n\n".join(sections)


def write_csv(results: dict[str, dict], output_path: Path | None) -> None:
    fieldnames = ["environment", "username", "authname", "ip_group"]
    handle = output_path.open("w", encoding="utf-8", newline="") if output_path else sys.stdout
    close_handle = output_path is not None
    try:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for environment, result in results.items():
            if "error" in result:
                continue
            for user in result["users"]:
                writer.writerow({"environment": environment, **user})
    finally:
        if close_handle:
            handle.close()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fetch itec-denwa DEV/PRD MVE SIP users from DB-discovered MVE targets."
    )
    parser.add_argument("--env", choices=["dev", "prd", "all"], default="all")
    parser.add_argument("--format", choices=["text", "json", "csv"], default="text")
    parser.add_argument("--output", type=Path, help="Write output to a file")
    parser.add_argument("--db-config", type=Path, default=DB_CONFIG_PATH)
    parser.add_argument("--auth-config", type=Path, default=MVE_AUTH_CONFIG_PATH)
    parser.add_argument("--timeout", type=int, default=20)
    parser.add_argument(
        "--verify-tls",
        action="store_true",
        help="Verify MVE TLS certificates. Default mirrors legacy project script and skips verification.",
    )
    parser.add_argument(
        "--include-password-hash",
        action="store_true",
        help="Include MVE password_hash in output. Sensitive; do not use for normal reports.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    environments = ["dev", "prd"] if args.env == "all" else [args.env]

    db_config = load_database_config(args.db_config)
    auth_config = load_properties(args.auth_config)
    mve_username = auth_config.get("mve.username")
    mve_password = auth_config.get("mve.password")
    if not mve_username or not mve_password:
        raise SystemExit("Missing mve.username or mve.password in auth config")

    results = {
        "_fetched_at": datetime.now(timezone.utc).isoformat(),
        "_source": {
            "db_config": str(args.db_config),
            "auth_config": str(args.auth_config),
            "passwords_printed": False,
        },
    }
    had_error = False
    for environment in environments:
        try:
            results[environment] = fetch_environment(
                environment,
                db_config,
                mve_username,
                mve_password,
                args.timeout,
                args.verify_tls,
                args.include_password_hash,
            )
        except Exception as exc:
            had_error = True
            results[environment] = {"environment": environment, "error": f"{type(exc).__name__}: {exc}"}

    env_results = {key: value for key, value in results.items() if not key.startswith("_")}
    if args.format == "json":
        payload = json.dumps(results, ensure_ascii=False, indent=2, default=str)
        if args.output:
            args.output.write_text(payload + "\n", encoding="utf-8")
        else:
            print(payload)
    elif args.format == "csv":
        write_csv(env_results, args.output)
        if had_error:
            print("One or more environments failed; see JSON/text output for error detail.", file=sys.stderr)
    else:
        payload = render_text(env_results)
        if args.output:
            args.output.write_text(payload + "\n", encoding="utf-8")
        else:
            print(payload)

    return 1 if had_error else 0


if __name__ == "__main__":
    raise SystemExit(main())
