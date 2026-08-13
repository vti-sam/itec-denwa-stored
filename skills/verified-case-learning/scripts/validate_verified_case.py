# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "pyyaml==6.0.3",
# ]
# ///
"""Validate a verified-case Markdown file deterministically."""

from __future__ import annotations

import argparse
import re
import sys
from datetime import date
from pathlib import Path

import yaml


REQUIRED_FIELDS = {
    "title", "project", "type", "status", "source", "tags", "scope",
    "updated_at", "case_id", "verified_at",
}
REQUIRED_SECTIONS = (
    "Câu hỏi thực tế", "Intent và phạm vi", "Entity và identifier",
    "Kết luận đã xác minh", "Evidence", "Cách trả lời phù hợp",
    "Không được kết luận", "Điều kiện áp dụng",
)
SIGNAL_PREFIXES = ("feedback:", "conversation:", "history:", "llm:")
PLACEHOLDER_RE = re.compile(r"<[^>\n]+>|\bTODO\b|\bTBD\b", re.IGNORECASE)
CASE_ID_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def split_frontmatter(text: str) -> tuple[dict[str, object], str]:
    if not text.startswith("---\n"):
        raise ValueError("file phải bắt đầu bằng YAML frontmatter")
    closing = text.find("\n---\n", 4)
    if closing < 0:
        raise ValueError("frontmatter thiếu delimiter đóng")
    loaded = yaml.safe_load(text[4:closing])
    if not isinstance(loaded, dict):
        raise ValueError("frontmatter phải là YAML mapping")
    return loaded, text[closing + 5:]


def find_workspace_root(path: Path) -> Path | None:
    for parent in (path.parent, *path.parents):
        if (parent / "project-store").is_dir() and (parent / "AGENTS.md").is_file():
            return parent
    return None


def validate(path: Path) -> list[str]:
    errors: list[str] = []
    try:
        metadata, body = split_frontmatter(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, ValueError, yaml.YAMLError) as exc:
        return [str(exc)]

    missing = sorted(REQUIRED_FIELDS - metadata.keys())
    if missing:
        errors.append(f"thiếu frontmatter field: {', '.join(missing)}")
    for field, expected in (("type", "analysis"), ("scope", "durable")):
        if metadata.get(field) != expected:
            errors.append(f"{field} phải là {expected}")
    if metadata.get("status") not in {"active", "superseded", "archived"}:
        errors.append("status phải là active, superseded hoặc archived")

    case_id = str(metadata.get("case_id", ""))
    if not CASE_ID_RE.fullmatch(case_id):
        errors.append("case_id phải là ASCII kebab-case")
    if path.stem != case_id:
        errors.append("basename phải trùng case_id")

    for field in ("updated_at", "verified_at"):
        value = metadata.get(field)
        normalized = value.isoformat() if isinstance(value, date) else str(value)
        try:
            valid_date = bool(DATE_RE.fullmatch(normalized)) and bool(date.fromisoformat(normalized))
        except ValueError:
            valid_date = False
        if not valid_date:
            errors.append(f"{field} phải là ngày YYYY-MM-DD hợp lệ")

    tags = metadata.get("tags")
    if not isinstance(tags, list) or "verified-case" not in tags:
        errors.append("tags phải là list và chứa verified-case")

    sources = metadata.get("source")
    if not isinstance(sources, list) or not sources:
        errors.append("source phải là list không rỗng")
        direct_sources: list[str] = []
    else:
        if not all(isinstance(item, str) for item in sources):
            errors.append("mọi source entry phải là string")
        direct_sources = [
            item.strip() for item in sources
            if isinstance(item, str)
            and item.strip()
            and not item.strip().lower().startswith(SIGNAL_PREFIXES)
        ]
        if not direct_sources:
            errors.append("source cần ít nhất một project evidence ngoài raw signal")

    workspace_root = find_workspace_root(path.resolve())
    if workspace_root:
        for source in direct_sources:
            candidate = re.sub(r":\d+(?::\d+)?$", "", source.split("#", 1)[0].strip())
            if candidate.startswith(("project-store/", "sources/")) and not (workspace_root / candidate).exists():
                errors.append(f"source path không tồn tại: {candidate}")

    suffix = (Path("project-store/knowledge/verified-cases") / path.name).as_posix()
    if not path.resolve().as_posix().endswith(suffix):
        errors.append("file phải nằm trong project-store/knowledge/verified-cases/")

    title_match = re.search(r"^# (.+?)\s*$", body, re.MULTILINE)
    if not title_match:
        errors.append("thiếu H1 title")
    elif title_match.group(1).strip() != str(metadata.get("title", "")).strip():
        errors.append("H1 title phải trùng frontmatter title")

    headings = list(re.finditer(r"^## (.+?)\s*$", body, re.MULTILINE))
    sections: dict[str, str] = {}
    for index, match in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(body)
        name = match.group(1)
        if name in sections:
            errors.append(f"section bị lặp: {name}")
        sections[name] = body[match.end():end].strip()
    for name in REQUIRED_SECTIONS:
        content = sections.get(name, "")
        if not content:
            errors.append(f"section thiếu hoặc rỗng: {name}")
        elif len(content) > 1200:
            errors.append(f"section vượt 1200 ký tự: {name}")
    if PLACEHOLDER_RE.search(body):
        errors.append("body còn TODO/TBD/placeholder")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="+", type=Path)
    args = parser.parse_args()
    failed = False
    for path in args.files:
        errors = validate(path)
        if errors:
            failed = True
            print(f"FAIL {path}")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"PASS {path}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
