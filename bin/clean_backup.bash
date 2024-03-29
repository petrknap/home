#!/usr/bin/env bash

set -e

TARGET="${1}"

clean_backup() {
    TARGET="${1}"
    YEAR="${2:0:4}"
    shift
    FIND="find ${TARGET} -maxdepth 1 -name ${YEAR}-*_*"
    for DATE in "${@}"
    do
        FIND="${FIND} -not -name ${DATE}_*"
    done
    if [[ $(${FIND} | wc -l) -gt 0 ]]
    then
        echo -e "\nPress [Enter] to clean backups based on this search:\n\t${FIND}" 1>&2
        read -r
        ${FIND} -exec rm -rfv {} \;
    fi
}

for I in {10..4}
do
    clean_backup "${TARGET}" "$(date -d "now - ${I} years - 3 months" +%Y)-01-"{"01","02","03"}
done
clean_backup "${TARGET}" "$(date -d "now - 3 years - 3 months" +%Y)-"{"01","07"}"-"{"01","02","03"}
clean_backup "${TARGET}" "$(date -d "now - 2 years - 3 months" +%Y)-"{"01","04","07","10"}"-"{"01","02","03"}
clean_backup "${TARGET}" "$(date -d "now - 1 years - 3 months" +%Y)-*-"{"01","02","03"}
