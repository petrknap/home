#!/usr/bin/env bash

SZN_HOME="${HOME}/Seznam.cz"
SZN_DOCKER_IMAGE="docker.ops.iszn.cz/sklik-stats-dev/skdevhad-client"
SZN_DOCKER_HOME="${SZN_HOME}/${SZN_DOCKER_IMAGE}/${PWD}"

alias szn-docker='mkdir --parent "${SZN_DOCKER_HOME}"; touch "${SZN_DOCKER_HOME}/.bash_history" && docker run -w "/mnt/pwd" -v "${PWD}:/mnt/pwd" -v "${SZN_DOCKER_HOME}/.bash_history:/root/.bash_history" --rm -ti ${SZN_DOCKER_IMAGE}:latest'
