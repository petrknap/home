#!/usr/bin/env bash

set -e

TARGET="${1}"

clean_backup() {
    TARGET="${1}"
    YEAR="${2:0:4}"
    shift
    FIND_REMOVE="find ${TARGET} -maxdepth 1 -name ${YEAR}-*_*"
    FIND_KEEP="find ${TARGET} -maxdepth 1"
    for DATE in "${@}"
    do
        FIND_REMOVE="${FIND_REMOVE} -not -name ${DATE}_*"
        FIND_KEEP="${FIND_KEEP} -name ${DATE}_*"
    done
    if [[ $(${FIND_REMOVE} | wc -l) -gt 0 ]]
    then
        echo -e "\nPress [Enter] to clean backups based on this search:\n\t${FIND_REMOVE}" 1>&2
        read -r
        if [[ $(${FIND_KEEP} | wc -l) -eq 0 ]]
        then
            echo -e "\nWARNING: There would be no backup left, press [Enter] to continue, based on this search:\n\t${FIND_KEEP}" 1>&2
            read -r
        fi
        ${FIND_REMOVE} -exec rm -rfv {} \;
    fi
}

for I in {10..4}
do
    clean_backup "${TARGET}" "$(date -d "now - ${I} years - 3 months" +%Y)-01-"{"01","02","03"}
done
clean_backup "${TARGET}" "$(date -d "now - 3 years - 3 months" +%Y)-"{"01","07"}"-"{"01","02","03"}
clean_backup "${TARGET}" "$(date -d "now - 2 years - 3 months" +%Y)-"{"01","04","07","10"}"-"{"01","02","03"}
clean_backup "${TARGET}" "$(date -d "now - 1 years - 3 months" +%Y)-*-"{"01","02","03"}
