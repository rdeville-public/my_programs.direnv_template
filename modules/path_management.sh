#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

path_management()
{
  # Update path to be able to use script that could be in .direnv/bin folder and
  # set some usefull direnv variables
  # NO PARAM

  local add_direnv_to_path=${path_management[add_direnv_to_path]:-"true"}
  local new_path=${path_management[new_path]:-""}
  local old_path=""

  if [ -n "${_OLD_VIRTUAL_PATH}" ]
  then
      old_path=${_OLD_VIRTUAL_PATH}
  fi
  if [ "${add_direnv_to_path}" = "true" ]
  then
    if [ -z "${old_path}" ]
    then
      old_path=${PATH}
    fi
    export PATH="${DIRENV_ROOT}/.direnv/bin:${PATH}"
  fi
  if [ -n "${new_path}" ]
  then
    if [ -z "${old_path}" ]
    then
      old_path=${PATH}
    fi
    export PATH="${new_path}:${PATH}"
  fi
  if [ -n "${old_path}" ]
  then
    export _DIRENV_OLD_PATH="${old_path}"
  fi
}


deactivate_path_management()
{
  local old_path
  if [ -n "${_OLD_VIRTUAL_PATH}" ]
  then
    old_path=${_OLD_VIRTUAL_PATH}
  else
    old_path=${_DIRENV_OLD_PATH}
  fi
  export PATH=${old_path}
  unset _DIRENV_OLD_PATH
}




