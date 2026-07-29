#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"
cd "$TARGET_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Directory '$TARGET_DIR' is not a git repository." >&2
    exit 1
fi

git ls-files --cached --others --exclude-standard | while read -r file; do
    [ -f "$file" ] || continue
    echo "~~~ $file"
    if grep -qI "^" "$file" 2>/dev/null; then
        cat "$file"
    else
        echo "BINARY"
    fi
    echo '~~~'
done
