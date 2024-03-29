#!/usr/bin/env bash
set -e

REMOTE_SOURCE="${1}"
REMOTE_PORT="${2}"
TARGET="${3}"
EXCLUDES="${4}"
ARGUMENTS="${5}"
BACKUP_ID="${6}"

LAST_FINAL_DIR="${TARGET}/LAST"
LAST_WORKING_DIR="${LAST_FINAL_DIR}.tmp"
CURRENT_DIR="$(date +'%Y-%m-%d_%H-%M')"
FINAL_DIR="${TARGET}/${CURRENT_DIR}"
WORKING_DIR="${FINAL_DIR}.tmp"
LOG_FILE="${FINAL_DIR}.log"
EXCLUDE_LIST="${TARGET}/excludes.txt"
RSYNC=" \
rsync --exclude-from=\"${EXCLUDE_LIST}\" \
      --rsh=\"ssh -o ServerAliveInterval=60 -p ${REMOTE_PORT}\" \
      --archive \
      --human-readable \
      --progress \
      --compress \
      ${ARGUMENTS} \
"

echo "${EXCLUDES}" > "${EXCLUDE_LIST}"

if [[ -e "${LAST_WORKING_DIR}" ]]; then (
    echo "Linking files from last working dir..." >> "${LOG_FILE}"
    bash -c "${RSYNC} --link-dest=\"${LAST_WORKING_DIR}/\" \"${LAST_WORKING_DIR}/\" \"${WORKING_DIR}\" >> \"${LOG_FILE}\" 2>&1"
); fi

if [[ ! -e "${LAST_FINAL_DIR}" ]]; then (
    ln -s /tmp "${LAST_FINAL_DIR}"
); fi

bash -c " \
   echo \"Running backup...\" >> \"${LOG_FILE}\" \
&& ${RSYNC} --link-dest=\"${LAST_FINAL_DIR}/\" \"${REMOTE_SOURCE}\" \"${WORKING_DIR}\" >> \"${LOG_FILE}\" 2>&1 \
&& mv \"${WORKING_DIR}\" \"${FINAL_DIR}\" \
&& ( \
    rm \"${LAST_FINAL_DIR}\"; \
    ln -s \"${FINAL_DIR}\" \"${LAST_FINAL_DIR}\"; \
    rm \"${LAST_WORKING_DIR}\"; \
    if [[ \"${BACKUP_ID}\" != \"\" ]]; then wget -O- \"https://backup.petrknap.cz/touch.php?id=${BACKUP_ID}\"; fi \
) \
|| ( \
    rm \"${LAST_WORKING_DIR}\"; \
    ln -s \"${WORKING_DIR}\" \"${LAST_WORKING_DIR}\"; \
) \
"
