#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead


# FOLDER CREATION
# ------------------------------------------------------------------------------
# Ensure that folders exist per OpenStack projects. If they do not exists,
# create them and inform the user.
# Setup ansible directories which need to exists
folders()
{
  local directories=()
  local i_folder
  local i_directory
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold

  # shellcheck disable=SC21
  #   - SC1090: Can't follow non-constant source. Use a directive to specify location.
  if echo "${folders[new]}" | grep -q "${DIRENV_INI_SEP}"
  then
    folders[new]=$( echo "${folders[new]}" | sed "s/${DIRENV_INI_SEP}/\n/g" )
    for i_directory in ${folders[new]}
    do
      directories+=("${i_directory}")
    done
  else
    directories+=("${folders[new]}")
  fi
  for i_folder in "${directories[@]}"
  do
    i_folder="${DIRENV_ROOT}/${i_folder}"
    if ! [[ -d "${i_folder}" ]]
    then
      direnv_log "INFO" "Creation of folder ${e_bold}${i_folder//${DIRENV_ROOT}\//}${e_normal}."
      mkdir -p "${i_folder}"
    fi
  done
}


