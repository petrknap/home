#!/usr/bin/env bash
set -e
DIR="$(realpath "${BASH_SOURCE%/*}")"

ACCESSED_URI="${1}"
ACCESSED_AT="${2}"

cat "${DIR}"/logs/access_log.*.log | grep "${ACCESSED_URI}" | grep "${ACCESSED_AT}" | cat -n
