#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

GIT_DOMAIN="framagit.org"
GIT_NAMESPACE="rdeville.public/my_programs"
GIT_REPO_NAME="direnv_template.git"
HTTPS_GIT_URL="https://${GIT_DOMAIN}/${GIT_NAMESPACE}/${GIT_REPO_NAME}"
SSH_GIT_URL="git@${GIT_DOMAIN}:${GIT_NAMESPACE}/${GIT_REPO_NAME}"
CLONE_METHOD="https"
UPGRADE="false"
DIRENV_ROOT="${PWD}"
DIRENV_TMP="${DIRENV_ROOT}/.direnv/tmp"
DIRENV_OLD="${DIRENV_ROOT}/.direnv/old"
DIRENV_CLONE_ROOT="${DIRENV_TMP}/direnv_template"
TO_UPGRADE=(
  ".envrc"
  ".sha1"
  "activate_direnv"
  "deactivate_direnv"
  "bin"
  "lib"
  "modules"
  "src"
  "templates"
)

check_git()
{
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  local e_error="\e[0;31m"   # red fg
  if ! command -v git > /dev/null 2>&1
  then
    echo -e "${e_error}[ERROR] ${e_bold}git${e_normal}${e_error} must be install.${e_normal}"
    echo -e "${e_error}[ERROR] Please install ${e_bold}git${e_normal}${e_error} first.${e_normal}"
    return 1
  fi
}

clone_direnv_repo()
{
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  local e_info="\e[0;32m"    # green fg
  echo -e "${e_info}[INFO] Cloning direnv_template repo to ${DIRENV_TMP}/direnv_template.${e_normal}"
  mkdir -p "${DIRENV_TMP}"
  if [[ "${CLONE_METHOD}" == "ssh" ]]
  then
    git clone "${SSH_GIT_URL}" "${DIRENV_CLONE_ROOT}" &> /dev/null 2>&1 || return 1
  else
    git clone "${HTTPS_GIT_URL}" "${DIRENV_CLONE_ROOT}" &> /dev/null 2>&1 || return 1
  fi
}

upgrade_file()
{
  local i_node="$1"
  local file_from
  local file_from_sha1
  local file_to
  local file_to_sha1
  local bak_date=$(date "+%Y-%m-%d-%H-%M")

  file_from="${DIRENV_CLONE_ROOT}/${i_node}"
  if [ "${i_node}" = ".envrc" ]
  then
    file_to="${DIRENV_ROOT}/${i_node}"
  else
    file_to="${DIRENV_ROOT}/.direnv/${i_node}"
  fi


  file_from_sha1=$(sha1sum "${file_from}" | cut -d " " -f 1 )
  file_to_sha1=$(sha1sum "${file_to}" | cut -d " " -f 1 )
  file_bak="${DIRENV_OLD}/${i_node}.${bak_date}"

  if [ "${file_from_sha1}" != "${file_to_sha1}" ]
  then
    direnv_direnv_log "INFO" "New version of ${i_node}"
    direnv_direnv_log "INFO" "Old version will be put in .direnv/old/${i_node}.${bak_date}"
    if ! [ -d "$(dirname "${file_bak}")" ]
    then
      mkdir -p "$(dirname "${file_bak}")"
    fi
    mv "${file_to}" "${file_bak}"
    mv "${file_from}" "${file_to}"
  fi
}

upgrade_direnv()
{
  local tmp_nodes=()
  local file_from
  local file_to

  for i_node in "$@"
  do
    file_from="${DIRENV_CLONE_ROOT}/${i_node}"
    if [ -f "${file_from}" ]
    then
      upgrade_file "${i_node}"
    elif [ -d "${file_from}" ]
    then
      for i_subnode in "${file_from}"/* "${file_from}"/.*
      do
        if echo ${i_subnode} | grep -q -E "\.$"
        then
          i_subnode=$(echo "${i_subnode}" | sed -e "s|${DIRENV_CLONE_ROOT}/||g")
          tmp_nodes+=("${i_subnode}")
        fi
      done
    fi
  done
  if [ -n "${tmp_nodes[*]}" ]
  then
    upgrade_direnv "${tmp_nodes[@]}"
  fi
}

main()
{
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  local e_warning="\e[0;33m"   # red fg
  SHELL=bash
  check_git || return 1
  for i_arg in "${@}"
  do
    case "${i_arg}" in
      --ssh|-s)
        CLONE_METHOD="ssh"
        ;;
      --upgrade|-u)
        UPGRADE="crue"
    esac
  done
  if ! clone_direnv_repo
  then
    echo -e "${e_warning}[WARNING] An error occurs when trying to get the last version of direnv_template."
#    return 1
  fi
  for i_lib in "${DIRENV_CLONE_ROOT}"/lib/*.sh
  do
    source "${i_lib}"
  done
  if [ "${UPGRADE}" = "false" ]
  then
    direnv_direnv_log "INFO" "Checking files to upgrades"
    upgrade_direnv "${TO_UPGRADE[@]}"
  fi
  direnv_direnv_log "INFO" "Removing temporary cloned files"
  rm -rf "${DIRENV_CLONE_ROOT}"
}

main "${@}" || exit 1

