#!/usr/bin/env python3
"""校验 WikiSpace 的 PermanentNotes .tid：必备字段、时间戳、枚举、内部链接。

用法: python3 check_note.py <note.tid> [tiddlers 目录]
退出码 1 表示有硬错误；只有警告时为 0。
"""
import re
import sys
from pathlib import Path

REQUIRED = ("created", "modified", "tags", "title", "type")
ENUMS = {
    "progress": {"Pending", "Building", "Completed", "Paused", "Archived",
                 "Capturing", "Processing", "Reading", "Researching"},
    "rating": {"Plain", "Valuable", "Personal", "Promising", "Doubtful", "Brilliant"},
    "visibility": {"Public", "Private"},
}
DYNAMIC = ("http://", "https://", "$(", "<$")


def parse(path):
    head, sep, body = path.read_text(encoding="utf-8").partition("\n\n")
    fields = {}
    for line in head.splitlines():
        key, colon, value = line.partition(": ")
        if colon:
            fields[key.strip()] = value.strip()
    return fields, body if sep else ""


def known_titles(tiddlers):
    found = set()
    for pattern in ("**/*.tid", "**/*.meta"):
        for f in tiddlers.glob(pattern):
            for line in f.read_text(encoding="utf-8", errors="ignore").splitlines():
                if line.startswith("title: "):
                    found.add(line[7:].strip())
                    break
    return found


def strip_code(body):
    """链接检查跳过代码块，避免把示例里的 [[...]] 当成真链接。"""
    kept, fenced = [], False
    for line in body.splitlines():
        if line.strip().startswith("```"):
            fenced = not fenced
            continue
        if not fenced:
            kept.append(line)
    return "\n".join(kept)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    path = Path(sys.argv[1])
    tiddlers = Path(sys.argv[2]) if len(sys.argv) > 2 else path.parent
    fields, body = parse(path)
    errors, warns = [], []

    for key in REQUIRED:
        if not fields.get(key):
            errors.append(f"缺少字段 {key}")
    for key in ("created", "modified"):
        value = fields.get(key, "")
        if value and not re.fullmatch(r"\d{17}", value):
            errors.append(f"{key} 不是 17 位时间戳: {value}")
    if fields.get("type") and fields["type"] != "text/vnd.tiddlywiki":
        errors.append(f"type 应为 text/vnd.tiddlywiki: {fields['type']}")
    if "PermanentNotes" not in fields.get("tags", "").split():
        errors.append("tags 缺少 PermanentNotes")
    for key, allowed in ENUMS.items():
        value = fields.get(key)
        if value and value not in allowed:
            warns.append(f"{key}={value} 不在常用值内，确认仓库现状")

    known = known_titles(tiddlers) | {fields.get("title", "")}
    for link in re.findall(r"\[\[([^\]]+)\]\]", strip_code(body)):
        parts = [p.strip() for p in link.split("|")]
        if any(p in known for p in parts) or any(p.startswith(DYNAMIC) for p in parts):
            continue
        warns.append(f"链接目标不存在: {' | '.join(parts)}")

    for warn in warns:
        print(f"warn: {warn}")
    for error in errors:
        print(f"error: {error}")
    if not errors and not warns:
        print("OK")
    sys.exit(1 if errors else 0)


main()
