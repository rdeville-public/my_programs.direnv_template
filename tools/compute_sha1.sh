#!/usr/bin/env bash
# """Recursively compute SHA1 sum of a list of files and folders
#
# SYNOPSIS:
#   ./compute_sha1.sh
#
# DESCRIPTION:
#   The script will compute SHA1 sum of every required files for directory
#   environment and store these SHA1 into the corresponding file in `.sha1`
#   folder with the same architecture.
#
# """

# List of files and folder
NODES=(
  ".envrc"
  "activate_direnv"
  "deactivate_direnv"
  "lib"
  "src"
  "modules"
  "templates"
)

DIRENV_ROOT="$(git rev-parse --show-toplevel)"
DIRENV_DEBUG_LEVEL="INFO"
# Output folder
DIRENV_SHA1="${DIRENV_ROOT}/.sha1"

compute_sha1()
{
  # """Main recursive method that compute SHA1 of files and folder
  #
  # Check if the nodes is a folder or a file.
  # If it is a file, compute its SHA1 sum and store it in `.sha1` folder.
  # If it is a folder, store the folder in a temporary array to be passed
  # recursively to this method.
  #
  # Globals:
  #   DIRENV_ROOT
  #   DIRENV_SHA1
  #
  # Arguments:
  #   $@: (optional) string, list of files and folders
  #
  # Output:
  #   Log informations
  #
  # Returns:
  #   None
  #
  # """

  local tmp_nodes=()
  local file_from
  local file_sha1

  for i_node in "$@"
  do
    file_from="${DIRENV_ROOT}/${i_node}"
    file_sha1="${DIRENV_SHA1}/${i_node}.sha1"

    if [[ -f "${file_from}" ]] && ! [[ "${file_from}" =~ __pycache__ ]]
    then
      direnv_log "INFO" "Computing sha1 of **${i_node}**."
      sha1sum "${file_from}" | cut -d " " -f 1 > "${file_sha1}"
    elif [[ -d "${file_from}" ]]
    then
      mkdir -p "${DIRENV_SHA1}/${i_node}"
      for i_subnode in "${file_from}"/*
      do
        # Remove every occurrences of `${DIRENV_ROOT}`
        i_subnode="${i_subnode//${DIRENV_ROOT}\//}"
        tmp_nodes+=("${i_subnode}")
      done
    fi
  done

  if [[ -n "${tmp_nodes[*]}" ]]
  then
    compute_sha1 "${tmp_nodes[@]}"
  fi
}

main()
{
  # """Ensure directory environment is activated an run SHA1 sum computation
  #
  # Globals:
  #   DIRENV_ROOT
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Error informations
  #
  # Returns:
  #   1 if directory environment is not activated
  #   0 if everything went right
  #
  # """

  # Store coloring output prefix
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_error="\e[0;31m"   # red fg

  # Sourcing directory environment libraries scripts
  for i_lib in "${DIRENV_ROOT}"/lib/*.sh
  do
    # shellcheck source=./lib/direnv_log.sh
    source "${i_lib}"
  done

  # Ensure `.sha1` directory exists
  if ! [[ -d "${DIRENV_SHA1}" ]]
  then
    mkdir -p "${DIRENV_SHA1}"
  fi
  compute_sha1 "${NODES[@]}"
}

main

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------