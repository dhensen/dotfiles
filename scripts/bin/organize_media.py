#!/usr/bin/env python3
"""
organize_media.py

Rearrange media files whose names encode a timestamp into a
<year>/<month>/ hierarchy.  Two filename patterns are understood:

1. Canonical:  YYYYMMDD_HHMMSS.ext        → 20150903_152605.jpg
2. Android    : YYYY-MM-DD HH.MM.SS.ext   → 2018-08-21 12.21.38.mp4

Usage
-----
# in-place:
organize_media.py /path/to/CameraRoll

# source → destination:
organize_media.py /path/to/camera_uploads /path/to/structured
"""

from __future__ import annotations

import argparse
import logging
import os
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

# ── configurable bits ────────────────────────────────────────────────────── #

ALLOWED_EXTS = {
    ".jpg",
    ".jpeg",
    ".png",
    ".gif",
    ".heic",
    ".mp4",
    ".mov",
    ".avi",
    ".mkv",
    ".wmv",
}

# Two patterns, same group name “date” so downstream code stays simple
NAME_RES = [
    re.compile(r"^(?P<date>\d{8})_\d{6}.*$", re.IGNORECASE),
    re.compile(r"^(?P<date>\d{4}-\d{2}-\d{2})\s+\d{2}\.\d{2}\.\d{2}.*$", re.IGNORECASE),
    re.compile(r"^(VID|VIDEOPLAYER)-(?P<date>\d{8})-.*$", re.IGNORECASE),
    re.compile(r"^IMG_(?P<date>\d{8})_\d{6}.*$", re.IGNORECASE),
    re.compile(r"VID_(?P<date>\d{8})_\d{6}\..*$", re.IGNORECASE),
]

# ── helpers ──────────────────────────────────────────────────────────────── #


def is_media_file(path: Path) -> bool:
    return path.suffix.lower() in ALLOWED_EXTS


def planned_destination(dest_root: Path, filename: str) -> Path | None:
    """
    Return DEST/<year>/<month>/<filename>, or None if the name
    matches neither recognised pattern.
    """
    for rx in NAME_RES:
        m = rx.match(filename)
        if not m:
            continue

        date_part = m.group("date")  # '20150903'  or '2018-08-21'
        if "-" in date_part:  # second pattern
            year, month, _ = date_part.split("-")
        else:  # first pattern
            year, month = date_part[:4], date_part[4:6]

        return dest_root / year / month / filename

    return None


def move_with_collision_handling(src: Path, dest: Path) -> None:
    """Move *src* to *dest*, appending '__n' on collisions."""
    if src.resolve() == dest.resolve():
        logging.info("Already in place: %s", src)
        return

    dest.parent.mkdir(parents=True, exist_ok=True)

    candidate = dest
    counter = 1
    while candidate.exists():
        candidate = dest.with_name(f"{dest.stem}__{counter}{dest.suffix}")
        counter += 1

    shutil.move(str(src), str(candidate))
    logging.info("Moved %s -> %s", src, candidate)


def organize(src_root: Path, dest_root: Path) -> None:
    """Walk *src_root* and move matching files into *dest_root*."""
    dest_root_resolved = dest_root.resolve()

    for dirpath, _dirnames, filenames in os.walk(src_root):
        here = Path(dirpath).resolve()

        # Skip destination subtree if it lives inside source
        if dest_root_resolved == here or dest_root_resolved in here.parents:
            continue

        for fname in filenames:
            src = here / fname

            if not is_media_file(src):
                logging.info("Skipped (extension): %s", src)
                continue

            dest = planned_destination(dest_root, fname)
            if dest is None:
                logging.info("Skipped (pattern): %s", src)
                continue

            try:
                move_with_collision_handling(src, dest)
            except Exception as exc:
                logging.exception("ERROR moving %s → %s: %s", src, dest, exc)


# ── CLI entry point ─────────────────────────────────────────────────────── #


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Organise photos/videos into <year>/<month>/ "
        "folders based on filename timestamps."
    )
    p.add_argument("source", help="Directory to scan recursively for media files")
    p.add_argument(
        "destination",
        nargs="?",
        help="Where organised folders are created (defaults to SOURCE)",
    )
    return p.parse_args()


def main() -> None:
    args = parse_args()

    src_root = Path(args.source).expanduser().resolve()
    if not src_root.is_dir():
        sys.exit(f"Error: {src_root} is not a directory")

    dest_root = (
        Path(args.destination).expanduser().resolve() if args.destination else src_root
    )

    log_file = dest_root / "organize_media.log"
    log_file.parent.mkdir(parents=True, exist_ok=True)

    logging.basicConfig(
        filename=log_file,
        filemode="a",  # explicit append mode
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        encoding="utf-8",
    )

    logging.info("=== Run started ===")
    logging.info("Source      : %s", src_root)
    logging.info("Destination : %s", dest_root)
    logging.info("Allowed ext : %s", ", ".join(sorted(ALLOWED_EXTS)))
    logging.info("Patterns    : %s", " | ".join(rx.pattern for rx in NAME_RES))

    start = datetime.now()
    organize(src_root, dest_root)
    logging.info("Finished in %s", datetime.now() - start)
    print(f"Done. Log written to {log_file}")


if __name__ == "__main__":
    main()
