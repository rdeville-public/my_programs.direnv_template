#!/usr/bin/env bash
# """Simply setup directory environment for the current folder
#
# SYNOPSIS:
#   ./setup.sh [-u|--upgrade] [-s|--ssh]
#
# DESCRIPTION:
#   This script will install/upgrade set of scripts to created a directory
#   environment for the current folder. If directory is already configure to use
#   directory environment and user does not provide `-u|--upgrade` options, an
#   error will be shown and nothing will be done.
#
#   Available options are:
#
#     -u,--upgrade: Upgrade the current directory scripts to manage directory
#                   environment.
#
#     -s,--ssh:     Specify setup to use SSH to clone direnv_template git repo.
#
# """


# Set constant variables
GIT_DOMAIN="framagit.org"
GIT_NAMESPACE="rdeville.public/my_programs"
GIT_REPO_NAME="direnv_template.git"
HTTPS_GIT_URL="https://${GIT_DOMAIN}/${GIT_NAMESPACE}/${GIT_REPO_NAME}"
SSH_GIT_URL="git@${GIT_DOMAIN}:${GIT_NAMESPACE}/${GIT_REPO_NAME}"
CLONE_METHOD="https"
UPGRADE="false"
DIRENV_ROOT="${PWD}"
DIRENV_TMP="${DIRENV_ROOT}/.direnv/tmp"
DIRENV_DEBUG_LEVEL="INFO"
DIRENV_CLONE_ROOT="${DIRENV_TMP}/direnv_template"
TO_INSTALL=(
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


main()
{
  # """Setup folder to be able to use directory environment mechanism
  #
  # Check if git is installed. Then check that folder is not already set to use
  # directory environment mechanism.
  #
  # If directory already set to use directory environment, then check if user
  # explicitly tell to upgrade and upgrade, otherwise, print a warning and exit.
  #
  # If directory not already set to use directory environment, clone
  # direnv_template repo to a temporary folder, copy relevant scripts to set
  # the folder to use directory environment and remove cloned direnv_template
  # repo.
  #
  # Globals:
  #   HTTPS_GIT_URL
  #   SSH_GIT_URL
  #   CLONE_METHOD
  #   UPGRADE
  #   DIRENV_ROOT
  #   DIRENV_TMP
  #   DIRENV_CLONE_ROOT
  #   TO_INSTALL
  #
  # Arguments:
  #   -u|--upgrade
  #   -s|--ssh
  #
  # Output:
  #   Log informations
  #
  # Returns:
  #   0 if directory is set to use directory environment
  #   1 if something when wrong during the setup of directory environment
  #
  # """

  check_git()
  {
    # """Ensure command `git` exists
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Error message if commang `git` does not exists
    #
    # Returns:
    #   0 if `git` command exists
    #   1 if `git` command does not exist
    #
    # """

    if ! command -v git > /dev/null 2>&1
    then
      echo -e "${e_error}\
[ERROR] ${e_bold}git${e_normal}${e_error} must be install.${e_normal}${e_error}\
[ERROR] Please install ${e_bold}git${e_normal}${e_error} first.${e_normal}"
      return 1
    fi
  }

  clone_direnv_repo()
  {
    # """Clone repo direnv_template to a temporary folder
    #
    # Clone the repo direnv_template to a temporary folder using HTTPS or SSH
    # depending on the user provided parameter, i.e. use of option `-s|-ssh` or
    # not.
    #
    # Globals:
    #   CLONE_METHOD
    #   DIRENV_CLONE_ROOT
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Log messages
    #
    # Returns:
    #   0 if clone of repo went right
    #   1 if clone of repo went wrong
    #
    # """

    echo -e "${e_info}\
[INFO] Cloning direnv_template repo to ${e_bold}${DIRENV_TMP}/direnv_template.${e_normal}"
    mkdir -p "${DIRENV_TMP}"

    if [[ "${CLONE_METHOD}" == "ssh" ]]
    then
      git clone "${SSH_GIT_URL}" "${DIRENV_CLONE_ROOT}" || return 1
    else
      git clone "${HTTPS_GIT_URL}" "${DIRENV_CLONE_ROOT}" || return 1
    fi
  }

  check_upgrade()
  {
    # """Check if user specify to upgrade folder directory environment
    #
    # Check if user specify to upgrade folder directory environment, i.e. folder
    # .direnv and script .envrc by the use of option `-u|--upgrade`. If not,
    # print a warning else, upgrade directory environment scripts.
    #
    # Globals:
    #   UPGRADE
    #   DIRENV_CLONE_ROOT
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Warning messages
    #
    # Returns:
    #   0 if upgrade went right
    #   1 if user did not specify to upgrade or if upgrade went wrong
    #
    # """


    # If folder seems to already be set to use direnv but user did not specify
    # to upgrade
    if [[ "$UPGRADE" == "false" ]]
    then
      echo -e "${e_warning}\
[WARNING] This folder seems to already be set to use direnv.
[WARNING] Continuing might result in the loss of your configuration.
[WARNING] If you want to upgrade your configuration use the option \`--upgrade|-u\`.\
${e_normal}"
      return 1
    # If folder seems to already be set to use direnv and user not specify to
    # upgrade
    elif [[ "$UPGRADE" == "true" ]]
    then
      "${DIRENV_CLONE_ROOT}"/src/upgrade_direnv.sh || return 1
    fi
  }


  setup_file()
  {
    # """Install new version of script from direnv_template temporary repo
    #
    # Simply install file provided as argument from the direnv_template
    # temporary repo to the right place in the folder currently setup to use
    # directory environment.
    #
    # Globals:
    #   DIRENV_ROOT
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Log messages
    #
    # Returns:
    #   None
    #
    # """

    local file_from="$1"
    local file_to

    if [[ "${i_node}" == ".envrc" ]]
    then
      file_to="${DIRENV_ROOT}/${i_node}"
    else
      file_to="${DIRENV_ROOT}/.direnv/${i_node}"
    fi
    direnv_log "INFO" "Installing file ${i_node}"
    mv "${file_from}" "${file_to}"
  }


  setup_direnv()
  {
    # """Recursively install new version of script from direnv_template temporary repo
    #
    # From the list of defined files and folders, recursively copy all files to
    # their right location from the temporary clone repo to the `.direnv` folder
    # except for `.envrc` which is place at the root of the folder that will be
    # setup to use directory environment.
    #
    # Globals:
    #   DIRENV_ROOT
    #   DIRENV_CLONE_ROOT
    #
    # Arguments:
    #   None
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
    local i_node
    local i_subnode

    for i_node in "$@"
    do
      file_from="${DIRENV_CLONE_ROOT}/${i_node}"
      if [[ -f "${file_from}" ]]
      then
        setup_file "${file_from}"
      elif [[ -d "${file_from}" ]]
      then
        mkdir -p "${DIRENV_ROOT}/.direnv/${i_node}"
        for i_subnode in "${file_from}"/* "${file_from}"/.*
        do
          if ! [[ "${i_subnode}" =~ ^${file_from}\/[\.]+$ ]]
          then
            # Remove everything before the last occurence of ${DIRENV_CLONE_ROOT}
            i_subnode=${i_subnode##*${DIRENV_CLONE_ROOT}\/}
            tmp_nodes+=("${i_subnode}")
          fi
        done
      fi
    done

    if [[ -n "${tmp_nodes[*]}" ]]
    then
      setup_direnv "${tmp_nodes[@]}"
    fi
  }

  # Set color prefix
  local e_normal="\e[0m"      # normal (white fg & transparent bg)
  local e_bold="\e[1m"        # bold
  local e_warning="\e[0;33m"  # yellow fg
  local e_error="\e[0;31m"    # red fg
  local e_info="\e[0;32m"     # green fg

  local i_arg
  local i_lib

  # Ensure git is installed
  check_git || return 1

  # Parse arguments
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

  if [[ -d "${DIRENV_ROOT}/.direnv" ]] || [[ -f "${DIRENV}/.envrc " ]]
  then
    # Check if user specify want to upgrade
    check_upgrade
  else
    # Clone last version of direnv_template to .direnv/tmp folder
    if ! clone_direnv_repo
    then
      echo -e "${e_warning}\
[WARNING] An error occurs when trying to get the last version of direnv_template.\
${e_normal}"
      return 1
    fi

    # Source last version of direnv_template library scripts
    for i_lib in "${DIRENV_CLONE_ROOT}"/lib/*.sh
    do
      # shellcheck source=./lib/direnv_log.sh
      source "${i_lib}"
    done

    # Install direnv_template
    setup_direnv "${TO_INSTALL[@]}"
  fi

  direnv_log "INFO" "Removing temporary cloned files"
  rm -rf "${DIRENV_CLONE_ROOT}"
}

main "${@}"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------