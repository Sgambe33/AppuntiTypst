#!/usr/bin/env python3
"""
unused_images_in_typ.py

Find images located in "images/" folders that sit next to .typ files but are NOT
referenced by any .typ file via image("relative/path", ...).

New: add --delete to remove unused images. Use --yes to skip confirmation.

Usage:
    python unused_images_in_typ.py /path/to/root
    python unused_images_in_typ.py /path/to/root --delete
    python unused_images_in_typ.py /path/to/root --delete --yes
    python unused_images_in_typ.py /path/to/root --json
"""
import argparse
import re
import sys
import json
from pathlib import Path
from collections import defaultdict

# Regex to capture image("path", ...). Accepts single or double quotes, multiline.
IMAGE_RE = re.compile(
    r'image\s*\(\s*(["\'])(?P<path>.*?)\1\s*(?:,(?P<args>.*?))?\)',
    re.IGNORECASE | re.DOTALL
)

# Default image extensions to consider when trying to match references without extension
DEFAULT_IMG_EXTS = [".png", ".jpg", ".jpeg", ".gif", ".svg", ".bmp", ".tif", ".tiff", ".webp"]


def find_typ_files(root: Path):
    yield from root.rglob("*.typ")


def extract_image_paths_from_typ(typ_path: Path):
    """
    Yields raw path strings extracted from image("...") occurrences in the typ file.
    """
    try:
        text = typ_path.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(f"Warning: couldn't read {typ_path}: {e}", file=sys.stderr)
        return

    for m in IMAGE_RE.finditer(text):
        raw = m.group("path").strip()
        if not raw:
            continue
        yield raw


def resolve_reference(raw_path: str, typ_dir: Path):
    """
    Resolve a raw referenced path relative to the typ file directory when possible.
    Returns a Path object (not guaranteed to exist) resolved (absolute).
    If raw_path is an absolute path, we use it directly.
    If it's a URL (http/https), returns None (we ignore URLs).
    """
    l = raw_path.strip()
    if l.lower().startswith(("http://", "https://")):
        return None
    p = Path(l)
    try:
        if p.is_absolute():
            return p.resolve(strict=False)
        else:
            return (typ_dir / p).resolve(strict=False)
    except Exception:
        # Fallback to joining without resolving
        return (typ_dir / p).absolute()


def collect_images_dirs_from_typs(typ_paths):
    """
    For each typ file, if <typ_dir>/images exists, collect all files under it (recursively).
    Returns:
       images_by_dir: dict(images_dir_path -> set(file Paths (resolved)))
    """
    images_by_dir = {}
    for typ in typ_paths:
        images_dir = (typ.parent / "images")
        if images_dir.exists() and images_dir.is_dir():
            # collect recursively
            files = set()
            for f in images_dir.rglob("*"):
                if f.is_file():
                    try:
                        files.add(f.resolve(strict=False))
                    except Exception:
                        files.add(f.absolute())
            images_by_dir[images_dir.resolve(strict=False)] = files
    return images_by_dir


def confirm_prompt(prompt_text: str) -> bool:
    """
    Ask the user to confirm. Returns True only for explicit 'y' or 'yes'.
    """
    try:
        resp = input(prompt_text + " [y/N]: ").strip().lower()
    except EOFError:
        return False
    return resp in ("y", "yes")


def main():
    p = argparse.ArgumentParser(description="Find unused images/ files relative to .typ files")
    p.add_argument("root", nargs="?", default=".", help="Root directory to search (default: current dir)")
    p.add_argument("--json", action="store_true", help="Output JSON")
    p.add_argument("--exts", default=",".join(DEFAULT_IMG_EXTS),
                   help="Comma-separated extra image extensions to consider (default common ones)")
    p.add_argument("--delete", action="store_true", help="Delete unused image files found (requires confirmation unless --yes provided)")
    p.add_argument("--yes", action="store_true", help="Skip confirmation prompt when --delete is used (dangerous)")
    args = p.parse_args()

    root = Path(args.root).expanduser().resolve()
    if not root.exists():
        print(f"Root path not found: {root}", file=sys.stderr)
        sys.exit(2)

    extra_exts = [e if e.startswith(".") else f".{e}" for e in args.exts.split(",") if e.strip()]
    img_exts = list(dict.fromkeys([ext.lower() for ext in extra_exts]))  # dedupe, keep order

    # 1) Find all .typ files
    typ_files = list(find_typ_files(root))

    if not typ_files:
        print("No .typ files found under the root.", file=sys.stderr)
        sys.exit(1)

    # 2) For each typ file: extract referenced image paths and resolve them
    referenced_paths_resolved = set()   # Path objects
    referenced_path_strings = []        # keep raw strings for possible stem-matching
    for typ in typ_files:
        for raw in extract_image_paths_from_typ(typ):
            referenced_path_strings.append((typ, raw))
            resolved = resolve_reference(raw, typ.parent)
            if resolved is None:
                # skip URLs
                continue
            # Add resolved path (normalized) to set
            try:
                referenced_paths_resolved.add(resolved.resolve(strict=False))
            except Exception:
                referenced_paths_resolved.add(resolved.absolute())

    # 3) Collect all images/ folders that are siblings of typ files (images next to typ)
    images_by_dir = collect_images_dirs_from_typs(typ_files)
    if not images_by_dir:
        print("No images/ directories found next to any .typ file.", file=sys.stderr)
        sys.exit(0)

    # Build additional helper maps: stem -> set(paths) for images under those images/ dirs
    stem_to_paths = defaultdict(set)
    name_to_paths = defaultdict(set)
    all_image_files = set()
    for images_dir, files in images_by_dir.items():
        for f in files:
            all_image_files.add(f)
            stem_to_paths[f.stem].add(f)
            name_to_paths[f.name].add(f)

    # 4) Determine which images are referenced
    used_images = set()

    # 4a) Direct path match
    # If a referenced resolved path matches exactly an image file path => used
    for r in referenced_paths_resolved:
        # direct match
        if r in all_image_files:
            used_images.add(r)
            continue
        # If r points inside one of the images dirs as a file (but maybe path normalization differs)
        for img in all_image_files:
            try:
                if r.samefile(img):
                    used_images.add(img)
                    break
            except Exception:
                # samefile may fail if paths don't exist; ignore
                pass

    # 4b) If reference had no extension, try matching by stem within the images/ files
    for typ, raw in referenced_path_strings:
        p = Path(raw)
        if p.suffix:  # has extension; already covered in direct matches
            continue
        # raw had no extension - try to resolve relative to typ dir and check stem matches
        raw_resolved = resolve_reference(raw, typ.parent)
        if raw_resolved is None:
            continue
        # If the parent resolved path points to an images dir, restrict to those files under it
        parent_dir = raw_resolved.parent.resolve(strict=False)
        # 1) prefer to match files in that parent dir with same stem
        matching_candidates = []
        if parent_dir in images_by_dir:
            # look for files in that images_dir that have same stem
            matching_candidates = [f for f in images_by_dir[parent_dir] if f.stem == raw_resolved.stem]
        else:
            # fall back to global stem map
            matching_candidates = list(stem_to_paths.get(raw_resolved.stem, []))
        for cand in matching_candidates:
            used_images.add(cand)

    # 5) Produce list of unused images per images_dir
    results = {}
    total_unused = 0
    unused_files_all = []
    for images_dir, files in images_by_dir.items():
        unused = sorted([f for f in files if f not in used_images])
        results[str(images_dir)] = [str(p) for p in unused]
        total_unused += len(unused)
        unused_files_all.extend(unused)

    # 6) Print or output results
    if args.json and not args.delete:
        out = {
            "root": str(root),
            "total_typ_files": len(typ_files),
            "total_images_dirs": len(images_by_dir),
            "total_images_found": len(all_image_files),
            "total_unused_images": total_unused,
            "unused_by_images_dir": results
        }
        print(json.dumps(out, ensure_ascii=False, indent=2))
    else:
        print(f"Scanned root: {root}")
        print(f"Found {len(typ_files)} .typ files, {len(images_by_dir)} images/ directories, {len(all_image_files)} image files in total.")
        print(f"Total unused images: {total_unused}\n")
        for images_dir, unused_list in results.items():
            print(f"images dir: {images_dir}")
            if not unused_list:
                print("  (all images used)")
            else:
                for u in unused_list:
                    # print path relative to images dir for readability when possible
                    try:
                        rel = Path(u).relative_to(Path(images_dir))
                        print(f"  - {rel}    ({u})")
                    except Exception:
                        print(f"  - {u}")
            print()

    # 7) Deletion (if requested)
    if args.delete:
        if total_unused == 0:
            print("No unused images to delete.")
            return

        # If --yes was not provided, ask for interactive confirmation
        if not args.yes:
            print("WARNING: about to permanently delete the files listed above (only files inside the 'images/' directories detected).")
            ok = confirm_prompt("Do you want to proceed with deletion?")
            if not ok:
                print("Deletion cancelled by user.")
                return
        else:
            # --yes used
            print("Proceeding with deletion without confirmation (--yes).")

        deleted = []
        failed = []
        for f in unused_files_all:
            try:
                # Double-check that file is inside one of the collected images/ dirs to avoid accidental deletes.
                inside_images_dir = False
                for images_dir in images_by_dir.keys():
                    try:
                        if Path(f).resolve(strict=False).is_relative_to(images_dir):
                            inside_images_dir = True
                            break
                    except Exception:
                        # Python <3.9 Path.is_relative_to doesn't exist or resolve issues; fallback:
                        try:
                            Path(f).resolve(strict=False).relative_to(images_dir)
                            inside_images_dir = True
                            break
                        except Exception:
                            pass
                if not inside_images_dir:
                    failed.append((str(f), "Not inside an images/ directory (safety)"))
                    continue

                Path(f).unlink()  # may raise
                deleted.append(str(f))
            except Exception as e:
                failed.append((str(f), str(e)))

        # Summarize deletion result (JSON if requested)
        if args.json:
            out = {
                "deleted_count": len(deleted),
                "deleted": deleted,
                "failed_count": len(failed),
                "failed": failed
            }
            print(json.dumps(out, ensure_ascii=False, indent=2))
        else:
            print(f"\nDeletion complete. Deleted {len(deleted)} files.")
            if deleted:
                for d in deleted:
                    print(f"  - {d}")
            if failed:
                print(f"\nFailed to delete {len(failed)} files:")
                for f, reason in failed:
                    print(f"  - {f}  ({reason})")

    # exit normally
    return


if __name__ == "__main__":
    main()
