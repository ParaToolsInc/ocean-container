#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

is_set() {
  ! [[ -z "${!1+x}" ]];
}

cmd() {
  if is_set cmd_prefix ; then
    echo -e "${GREEN}${cmd_prefix} $@ ${NC}"
  else
    echo -e "${GREEN}+ $@ ${NC}"
  fi
  eval "$@"
}

_msg() {
  if is_set cmd_prefix ; then
    echo -e "${GREEN}${cmd_prefix} $@ ${NC}"
  else
    echo -e "${GREEN}+ $@ ${NC}"
  fi
}

_err() {
  echo -e "${RED}$@${NC}"
}

_err_cat() {
  echo -e "${RED}"
  cat $1
  echo -e "${NC}"
}

require_env() {
  if ! is_set $1 ; then
    _err error: required environment variable is not set: $1
    exit 1
  fi
}
