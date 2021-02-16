#!/usr/bin/env bash
# """Upgrade current `.direnv` folder to the last release.
#
# SYNOPSIS:
#
#   ./upgrade_direnv.sh [options]
#
# DESCRIPTION:
#
#   SCRIPT WILL ONLY WORK WHEN DIRECTORY ENVIRONMENT IS ACTIVATED
#
#   Clone last release of `direnv_template` into `.direnv/tmp/direnv_template`.
#   Copy every files listed in variable `TO_UPGRADE` into their corresponding
#   folder in `.direnv`. Backup old version next to their new version (in case
#   something went wrong for the user.
#   Finally, delete clonned repo.
#
# OPTIONS:
#
#   Available options to pass to the script are:
#
#   - `-s,--ssh`<br>
#     Force cloning method to use SSH protocole
#
# """

# Global variable to help storing information
GIT_DOMAIN="framagit.org"
GIT_NAMESPACE="rdeville.public/my_programs"
GIT_REPO_NAME="direnv_template.git"
HTTPS_GIT_URL="https://${GIT_DOMAIN}/${GIT_NAMESPACE}/${GIT_REPO_NAME}"
SSH_GIT_URL="git@${GIT_DOMAIN}:${GIT_NAMESPACE}/${GIT_REPO_NAME}"
CLONE_METHOD="https"
DIRENV_ROOT="${PWD}"
DIRENV_TMP="${DIRENV_ROOT}/.direnv/tmp"
DIRENV_OLD="${DIRENV_ROOT}/.direnv/old"
DIRENV_CLONE_ROOT="${DIRENV_TMP}/direnv_template"
# List of node (files and folders) to upgrade to last release
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
  # """Ensure `git` is installed.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Error message if `git` is not installed.
  #
  # Returns:
  #   1 if `git` is not installed
  #
  # """

  if ! command -v git > /dev/null 2>&1
  then
    echo -e "${e_error}[ERROR]" \
      "${e_bold}git${e_normal}${e_error} must be install.${e_normal}"
    echo -e "${e_error}[ERROR]" \
      "Please install ${e_bold}git${e_normal}${e_error} first.${e_normal}"
    return 1
  fi
}

clone_direnv_repo()
{
  # """Clone the latest version of `direnv_template` release to `.direnv/tmp/direnv_template`.
  #
  # Globals:
  #   DIRENV_TMP
  #   DIRENV_CLONE_ROOT
  #   CLONE_METHOD
  #   SSH_GIT_URL
  #   HTTPS_GIT_URL
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Information message to tell the user repos will be clonned.
  #
  # Returns:
  #   1 if there is errro while cloning the repo.
  #
  # """

  echo -e "${e_info}[INFO]" \
    "Cloning direnv_template repo to ${e_bold}${DIRENV_TMP}/direnv_template.${e_normal}"

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
  # """Compute SHA1 of old and new file and upgrade file if needed
  #
  # Compute SHA1 of old and new file. If they differs, which means new file
  # differs from the old one, backup the old file and replace it with the new
  # file.
  #
  # Globals:
  #   DIRENV_OLD
  #   DIRENV_ROOT
  #   DIRENV_CLONE_ROOT
  #
  # Arguments:
  #   $1: string, path of file to upgrade
  #
  # Output:
  #   Information message if new file replace an old one
  #
  # Returns:
  #   None
  #
  # """

  local i_node="$1"
  local file_from
  local file_from_sha1
  local file_to
  local file_to_sha1
  local bak_date

  bak_date=$(date "+%Y-%m-%d-%H-%M")
  file_from="${DIRENV_CLONE_ROOT}/${i_node}"

  if [[ "${i_node}" == ".envrc" ]]
  then
    file_to="${DIRENV_ROOT}/${i_node}"
  else
    file_to="${DIRENV_ROOT}/.direnv/${i_node}"
  fi

  file_from_sha1=$(sha1sum "${file_from}" | cut -d " " -f 1 )
  file_to_sha1=$(sha1sum "${file_to}" | cut -d " " -f 1 )
  file_bak="${DIRENV_OLD}/${i_node}.${bak_date}"

  if ! [[ -f "${file_to}" ]]
  then
    direnv_log "INFO" "Installing new file ${i_node}."
    mv "${file_from}" "${file_to}"
  elif [[ "${file_from_sha1}" != "${file_to_sha1}" ]]
  then
    direnv_log "INFO" "New version of ${i_node}"
    direnv_log "INFO" "Old version will be put in .direnv/old/${i_node}.${bak_date}"
    if ! [[ -d "$(dirname "${file_bak}")" ]]
    then
      mkdir -p "$(dirname "${file_bak}")"
    fi
    mv "${file_to}" "${file_bak}"
    mv "${file_from}" "${file_to}"
  fi
}

upgrade_direnv()
{
  # """Method which recursively upgrade every old file to new one if needed
  #
  # For every nodes (files and folders), if node is a folder, add list of files
  # within this folders into a temporary array which is then passed recursively
  # to this method.
  # If node is a file, call `upgrade_file` method to upgrade this file if
  # needed.
  #
  # Globals:
  #   DIRENV_CLONE_ROOT
  #
  # Arguments:
  #   $@: bash array, list of files and folder to upgrade
  #
  # Output:
  #   None
  #
  # Returns:
  #   None
  #
  # """

  local tmp_nodes=()
  local file_from
  local file_to

  for i_node in "$@"
  do
    file_from="${DIRENV_CLONE_ROOT}/${i_node}"
    # If `${i_node}` is a file, upgrade it if needed
    if [[ -f "${file_from}" ]]
    then
      upgrade_file "${i_node}"
    # If `${i_node}` is a folder, add its content to the list of files to
    # update.
    elif [[ -d "${file_from}" ]]
    then
      for i_subnode in "${file_from}"/* "${file_from}"/.*
      do
        if ! [[ "${i_subnode}" =~ ^${file_from}\/[\.]+$ ]]
        then
          i_subnode="${i_subnode//${DIRENV_CLONE_ROOT}\/}"
          tmp_nodes+=("${i_subnode}")
        fi
      done
    fi
  done

  # If there is subfile to upgrade, call this method recursively
  if [[ -n "${tmp_nodes[*]}" ]]
  then
    upgrade_direnv "${tmp_nodes[@]}"
  fi
}

main()
{
  # """Main method that run the upgrade direnv process.
  #
  # Ensure git is installed, if git is installed, clone the latest release of
  # direnv_template and upgrade old files to their latest release version while
  # making a backup of the old file.
  #
  # Globals:
  #   DIRENV_CLONE_ROOT
  #   TO_UPGRADE
  #   CLONE_METHOD
  #
  # Arguments:
  #   $@: Possible options that can be passed to the script, see script docstring.
  #
  # Output:
  #   Error message if clone of `direnv_template` went wrong.
  #   Information message to inform user of the advancement of the process.
  #
  # Returns:
  #   1 if something went wrong during upgrade process.
  #   0 if everything went right.
  #
  # """

  # Color prefix storage
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  local e_warning="\e[0;33m"   # red fg

  # Ensure git is installed
  check_git || return 1

  # Set git clone method
  for i_arg in "${@}"
  do
    case "${i_arg}" in
      --ssh|-s)
        CLONE_METHOD="ssh"
        ;;
    esac
  done

  # Trying to clone `direnv_template` repo if not already cloned
  if ! [[ -d ${DIRENV_CLONE_ROOT} ]] && ! clone_direnv_repo
  then
    echo -e "${e_warning}[WARNING] An error occurs when trying to get the last version of direnv_template."
    return 1
  fi

  # Sourcing latest release libraries scripts
  for i_lib in "${DIRENV_CLONE_ROOT}"/lib/*.sh
  do
    # shellcheck source=./lib/direnv_log.sh
    source "${i_lib}"
  done

  # Upgrade files to newest version
  direnv_log "INFO" "Checking files to upgrades"
  upgrade_direnv "${TO_UPGRADE[@]}"

  direnv_log "INFO" "Removing temporary cloned files"
  rm -rf "${DIRENV_CLONE_ROOT}"
}

main "${@}"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
