#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

NODES=(
  ".envrc"
  "activate_direnv"
  "deactivate_direnv"
  "lib"
  "src"
  "modules"
  "templates"
)

DIRENV_SHA1="${DIRENV_ROOT}/.sha1"

compute_sha1()
{
  local tmp_nodes=()
  local file_from
  local file_sha1

  for i_node in "$@"
  do
    file_from="${DIRENV_ROOT}/${i_node}"
    file_sha1="${DIRENV_SHA1}/${i_node}.sha1"

    if [ -f "${file_from}" ]
    then
      direnv_log "INFO" "Computing sha1 of ${i_node}"
      sha1sum "${file_from}" | cut -d " " -f 1 > "${file_sha1}"
    elif [ -d "${file_from}" ]
    then
      mkdir -p "${DIRENV_SHA1}/${i_node}"
      for i_subnode in "${file_from}"/*
      do
        i_subnode=$(echo "${i_subnode}" | sed -e "s|${DIRENV_ROOT}/||g")
        tmp_nodes+=("${i_subnode}")
      done
    fi
  done
  if [ -n "${tmp_nodes[*]}" ]
  then
    compute_sha1 "${tmp_nodes[@]}"
  fi
}



main()
{
  SHELL=bash
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_error="\e[0;31m"   # red fg
  if [ -z "${DIRENV_ROOT}" ]
  then
    echo -e "${e_error}[ERROR] Direnv must be activated to use this script.${e_normal}"
    return 1
  fi
  for i_lib in "${DIRENV_ROOT}"/lib/*.sh
  do
    source "${i_lib}"
  done
  if ! [ -d "${DIRENV_SHA1}" ]
  then
    mkdir -p "${DIRENV_SHA1}"
  fi
  compute_sha1 "${NODES[@]}"
}

main || return 1