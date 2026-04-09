#!/usr/bin/env python3
"""
image-shrink: 递归扫描图片目录，扁平化压缩为 .avif，支持稳定去重与增量更新。
底层压缩引擎已替换为 pyvips 原生 API。
"""
import sys
import os
from pathlib import Path

try:
    import pyvips
except ImportError:
    print("Error: 请先安装 pyvips 库: pip install pyvips")
    print("提示: 还需确保系统已安装 libvips 开发库 (如 apt install libvips-dev / brew install vips)")
    sys.exit(1)

def main():
    # ================= 1️⃣ 参数校验 =================
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <SOURCE_DIR> <TARGET_DIR>")
        sys.exit(1)

    source_dir = Path(sys.argv[1]).resolve()
    target_dir = Path(sys.argv[2]).resolve()

    if not source_dir.is_dir():
        print(f"Error: SOURCE_DIR does not exist or is not a directory: {source_dir}")
        sys.exit(1)

    target_dir.mkdir(parents=True, exist_ok=True)

    # ================= 2️⃣ 初始化运行状态 =================
    IMG_EXTS = {'.png', '.jpg', '.jpeg', '.webp', '.bmp', '.tiff', '.tif'}
    processed_basenames = set()
    conflict_paths = []
    
    stats = {
        'total': 0,
        'compressed': 0,
        'skipped': 0,
        'conflicts': 0
    }

    # ================= 3️⃣ 扫描文件（稳定顺序） =================
    raw_files = []
    for root, _, files in os.walk(source_dir):
        for fname in files:
            p = Path(root) / fname
            if p.suffix.lower() in IMG_EXTS:
                raw_files.append(p)

    # 核心原则1：固定处理顺序 (等价于 find | sort)
    raw_files.sort(key=lambda p: str(p.relative_to(source_dir)))
    stats['total'] = len(raw_files)

    # ================= 4️⃣ 逐文件处理 =================
    for src_path in raw_files:
        rel_path = src_path.relative_to(source_dir)
        basename = src_path.stem  # 核心原则2：仅用 basename 作为唯一标识
        target_path = target_dir / f"{basename}.avif"

        # 🛑 冲突检测（强约束）
        if basename in processed_basenames:
            stats['conflicts'] += 1
            conflict_paths.append(str(rel_path))
            continue  # 不参与压缩、不参与时间比较、直接跳过

        processed_basenames.add(basename)

        # ⏱️ 增量判断
        need_compress = False
        if not target_path.exists():
            need_compress = True
        else:
            if src_path.stat().st_mtime > target_path.stat().st_mtime:
                need_compress = True

        # 🗜️ 执行压缩（使用 pyvips 原生 API）
        if need_compress:
            try:
                # 1. 缩略图处理 (等价于: vips thumbnail ... 960 --size down --linear)
                img = pyvips.Image.thumbnail(
                    str(src_path),
                    960,
                    size="down",
                    linear=True
                )
                # 2. 保存为 AVIF (等价于: TARGET.avif[Q=80,strip])
                img.write_to_file(
                    str(target_path),
                    Q=80,
                    strip=True
                )
                stats['compressed'] += 1
            except Exception as e:
                print(f"Warning: pyvips 压缩失败 {rel_path}: {e}", file=sys.stderr)
        else:
            stats['skipped'] += 1

    # ================= 5️⃣ 输出结果 =================
    print(f"扫描文件总数: {stats['total']}")
    print(f"实际压缩数量: {stats['compressed']}")
    print(f"跳过（未更新）数量: {stats['skipped']}")
    print(f"冲突数量: {stats['conflicts']} files")

    if stats['conflicts'] > 0:
        print(f"\nConflicts: {stats['conflicts']} files")
        print("Examples:")
        for cp in conflict_paths:
            print(f"* {cp}")

if __name__ == "__main__":
    main()
