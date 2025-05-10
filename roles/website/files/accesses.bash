#!/usr/bin/env bash
set -e

ACCESSED_URI="${1}"
ACCESSED_AT="${2}"

docker logs letsencrypt-nginx-reverse-proxy 2>&1 | grep "${ACCESSED_URI}" | grep "${ACCESSED_AT}" | cat -n
