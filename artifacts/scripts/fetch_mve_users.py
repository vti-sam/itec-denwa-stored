#!/usr/bin/env python3
import argparse
import base64
import os
import re
import ssl
import sys
import urllib.request
from pathlib import Path


def find_properties_file() -> Path:
    # Vị trí mặc định tương đối từ vị trí script:
    # project-store/artifacts/scripts/fetch_mve_users.py -> registry/keystore/projects/itec-denwa/infra/staging/application.properties
    script_dir = Path(__file__).resolve().parent
    default_path = (
        script_dir
        / "../../../registry/keystore/projects/itec-denwa/infra/staging/application.properties"
    )
    if default_path.exists():
        return default_path.resolve()

    # Tìm kiếm từ workspace root
    workspace_root = script_dir.parents[2]
    alt_path = (
        workspace_root
        / "itec-denwa/registry/keystore/projects/itec-denwa/infra/staging/application.properties"
    )
    if alt_path.exists():
        return alt_path.resolve()

    raise FileNotFoundError(
        "Không tìm thấy file application.properties tại các đường dẫn mặc định."
    )


def load_properties(path: Path) -> dict:
    properties = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or line.startswith("!"):
                continue
            if "=" in line:
                key, val = line.split("=", 1)
                properties[key.strip()] = val.strip()
    return properties


def fetch_mve_config(url: str, username: str, password: str) -> str:
    # Bỏ qua xác thực SSL nếu cần
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    req = urllib.request.Request(url)

    # Thêm Basic Auth Header
    auth_str = f"{username}:{password}"
    auth_b64 = base64.b64encode(auth_str.encode("utf-8")).decode("utf-8")
    req.add_header("Authorization", f"Basic {auth_b64}")

    try:
        with urllib.request.urlopen(req, context=ctx, timeout=10) as response:
            return response.read().decode("utf-8")
    except Exception as e:
        print(f"Lỗi khi kết nối tới MVE API: {e}", file=sys.stderr)
        sys.exit(1)


def parse_sbc_users(ini_content: str) -> list:
    lines = ini_content.splitlines()
    in_table = False
    users = []

    for line in lines:
        line = line.strip()
        if line == "[ SBCUserInfoTable ]":
            in_table = True
            continue
        if line == r"[ \SBCUserInfoTable ]":
            in_table = False
            continue

        if in_table and line.startswith("SBCUserInfoTable"):
            # Ví dụ: SBCUserInfoTable 8 = "50411005", "50411005", "$1$9r2ezsOy3KzamMhadw==", "IPG_TEST1";
            parts = line.split("=", 1)
            if len(parts) == 2:
                val_part = parts[1].strip().rstrip(";")
                matches = re.findall(r'"([^"]*)"', val_part)
                if len(matches) >= 4:
                    users.append(
                        {
                            "username": matches[0],
                            "authname": matches[1],
                            "password_hash": matches[2],
                            "ip_group": matches[3],
                        }
                    )
    return users


def print_table(users: list):
    if not users:
        print("Không tìm thấy người dùng nào.")
        return

    # Xác định độ rộng các cột
    col_widths = {
        "username": max(len(u["username"]) for u in users) + 2,
        "authname": max(len(u["authname"]) for u in users) + 2,
        "password_hash": max(len(u["password_hash"]) for u in users) + 2,
        "ip_group": max(len(u["ip_group"]) for u in users) + 2,
    }

    # Đảm bảo độ rộng tối thiểu bằng độ dài tiêu đề
    col_widths["username"] = max(col_widths["username"], 12)
    col_widths["authname"] = max(col_widths["authname"], 12)
    col_widths["password_hash"] = max(col_widths["password_hash"], 32)
    col_widths["ip_group"] = max(col_widths["ip_group"], 15)

    # In tiêu đề
    header = f"{'UserName'.ljust(col_widths['username'])} | {'AuthName'.ljust(col_widths['authname'])} | {'Password Hash'.ljust(col_widths['password_hash'])} | {'IP Group'.ljust(col_widths['ip_group'])}"
    print(header)
    print("-" * len(header))

    # In các dòng dữ liệu
    for u in users:
        row = f"{u['username'].ljust(col_widths['username'])} | {u['authname'].ljust(col_widths['authname'])} | {u['password_hash'].ljust(col_widths['password_hash'])} | {u['ip_group'].ljust(col_widths['ip_group'])}"
        print(row)


def main():
    parser = argparse.ArgumentParser(
        description="Script lấy và hiển thị danh sách SBC Users từ MVE server."
    )
    parser.add_argument(
        "--config", type=Path, help="Đường dẫn tới file application.properties"
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Đường dẫn file để xuất dữ liệu (hỗ trợ .json hoặc .csv)",
    )
    args = parser.parse_args()

    try:
        config_path = args.config or find_properties_file()
        print(f"Đang sử dụng cấu hình từ: {config_path}")
        properties = load_properties(config_path)
    except Exception as e:
        print(f"Lỗi đọc cấu hình: {e}", file=sys.stderr)
        sys.exit(1)

    # Lấy các tham số cấu hình MVE
    url = properties.get("mve.file.ini")
    username = properties.get("mve.username")
    password = properties.get("mve.password")

    if not all([url, username, password]):
        print(
            "Lỗi: Thiếu cấu hình mve.file.ini, mve.username hoặc mve.password trong file cấu hình.",
            file=sys.stderr,
        )
        sys.exit(1)

    print(f"Đang kết nối tới MVE Server: {url}...")
    ini_content = fetch_mve_config(url, username, password)

    print("Đang phân tích cấu hình người dùng...")
    users = parse_sbc_users(ini_content)

    print(f"\nTìm thấy {len(users)} người dùng SIP:\n")
    print_table(users)

    if args.output:
        out_path: Path = args.output
        if out_path.suffix.lower() == ".json":
            import json

            with open(out_path, "w", encoding="utf-8") as f:
                json.dump(users, f, ensure_ascii=False, indent=2)
            print(f"\nĐã xuất dữ liệu ra file JSON: {out_path}")
        elif out_path.suffix.lower() == ".csv":
            import csv

            with open(out_path, "w", encoding="utf-8", newline="") as f:
                writer = csv.writer(f)
                writer.writerow(
                    ["UserName", "AuthName", "Password Hash", "IP Group"]
                )
                for u in users:
                    writer.writerow(
                        [
                            u["username"],
                            u["authname"],
                            u["password_hash"],
                            u["ip_group"],
                        ]
                    )
            print(f"\nĐã xuất dữ liệu ra file CSV: {out_path}")
        else:
            print(
                f"\nĐịnh dạng file đầu ra {out_path.suffix} không được hỗ trợ. Chỉ hỗ trợ .json hoặc .csv"
            )


if __name__ == "__main__":
    main()
