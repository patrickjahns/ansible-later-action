#!/bin/bash
set -eo pipefail

pushd "$GITHUB_WORKSPACE"

declare -x INPUT_PATH
declare -x INPUT_CONFIG
if [ -n "${INPUT_CONFIG}" ]; then
  if [ ! -f "${INPUT_CONFIG}" ]; then
    echo "error: config file ${INPUT_CONFIG} not found"
    exit 0
  fi
  INPUT_CONFIG=" -c ${INPUT_CONFIG}"
fi



ansible-later --version
ansible-later ${INPUT_CONFIG} ${INPUT_PATH}