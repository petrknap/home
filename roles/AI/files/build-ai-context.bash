#!/usr/bin/env bash
set -euo pipefail

(
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Directory '$PWD' is not a git repository." >&2
    exit 1
  fi

  cd "$(git rev-parse --show-toplevel)"  # switch to repository root
  REPOSITORY_PATH=":/${1:-}"

  echo "This document contains the relevant files from the repository and diff describing new feature."
  echo ""
  echo ""
  echo "# Relevant Files"
  git ls-files --cached --others --exclude-standard -- "$REPOSITORY_PATH" | while read -r FILE; do
    [ -f "$FILE" ] || continue  # skip directories
    EXT="${FILE##*.}"
    [ "$EXT" = "$FILE" ] && EXT=""
    echo ""
    echo "~~~$EXT $FILE"
    if grep -qI "^" "$FILE" 2>/dev/null; then  # skip binaries
      cat "$FILE" | sed 's/~~~/```/g'
      if [ -n "$(tail -c 1 "$FILE")" ]; then  # line-break for files without new line at the end
        echo ""
      fi
    fi
    echo '~~~'
  done
  echo ""
  echo ""
  echo "# Feature Diff"
  echo ""
  echo "~~~diff"
  (git diff main 2>/dev/null || git diff master 2>/dev/null || true) | sed 's/~~~/```/g'
  echo "~~~"

)  # end of PWD protection
