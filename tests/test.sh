#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTAINER_IMAGE=${IMAGE:-"patrickjahns/ansible-later-action"}
CONTAINER_SHA=${1:-"latest"}
RESULT=0

# Colors
end="\033[0m"
green="\033[0;32m"
redb="\033[30;41m"


print_default() {
  echo -e "${end}${1}"
}

print_success() {
  echo -e "${green}${1}${end}"
}

print_error() {
  echo -e "${redb}${1}${end}"
}

print_start() {
  print_default "SCENARIO: "
  print_default "${1}"
  print_default "----------------------------------------------------------"
}

print_end() {
  print_default "----------------------------------------------------------"
}
print_nl() {
  echo ""
}

test_container_exits_sucessfully () {
    print_start "Test container exits with 0 if no linting errors are found"
    docker run -e GITHUB_WORKSPACE=/test \
               -v $SCRIPT_DIR/playbook.yml:/test/playbook.yml:ro \
               --rm ${CONTAINER_IMAGE}:${CONTAINER_SHA}
    retVal=$?
    print_end
    if [[ ${retVal} -ne 0 ]]; then
      print_error "FAILURE"
      RESULT=1
    else
      print_success "SUCCESS"
    fi
    print_nl
}

test_container_exits_with_failure () {
    print_start "Test container exits with !=0 if linting errors are found"
    docker run -e GITHUB_WORKSPACE=/test \
               -v $SCRIPT_DIR/broken-playbook.yml:/test/playbook.yml:ro \
               --rm ${CONTAINER_IMAGE}:${CONTAINER_SHA}
    retVal=$?
    print_end
    if [[ ${retVal} -eq 0 ]]; then
      print_error "FAILURE"
      RESULT=1
    else
      print_success "SUCCESS"
    fi
    print_nl
}

test_custom_config() {
    print_start "Test passing a custom config works"
    docker run -e GITHUB_WORKSPACE=/test \
               -e INPUT_CONFIG=custom-config.yml \
               -v $SCRIPT_DIR/broken-playbook.yml:/test/playbook.yml:ro \
               -v $SCRIPT_DIR/custom-config.yml:/test/custom-config.yml:ro \
               --rm ${CONTAINER_IMAGE}:${CONTAINER_SHA}
    retVal=$?
    print_end
    if [[ ${retVal} -ne 0 ]]; then
      print_error "FAILURE"
      RESULT=1
    else
      print_success "SUCCESS"
    fi
    print_nl
}

test_error_when_custom_config_not_found() {
    print_start "Test container exits with error when custom config not found"
    docker run -e GITHUB_WORKSPACE=/test \
               -e INPUT_CONFIG=custom-config.yml \
               -v $SCRIPT_DIR/broken-playbook.yml:/test/playbook.yml:ro \
               --rm ${CONTAINER_IMAGE}:${CONTAINER_SHA}
    retVal=$?
    print_end
    if [[ ${retVal} -ne 1 ]]; then
      print_error "FAILURE"
      RESULT=1
    else
      print_success "SUCCESS"
    fi
    print_nl
}

main() {
    print_default "Starting test suite .."
    pushd $SCRIPT_DIR > /dev/null
        test_container_exits_sucessfully
        test_container_exits_with_failure
        test_custom_config
        test_error_when_custom_config_not_found
    popd > /dev/null
    if [[ ${RESULT} -ne 0 ]]; then
      print_error "FAILURE"
    else
      print_success "SUCCESS"
    fi
    exit ${RESULT}
}

main