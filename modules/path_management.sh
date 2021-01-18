#!/usr/bin/env bash
# """Update `PATH` variable with user defined folder
#
# DESCRIPTION:
#   Update `PATH` variable to include either `.direnv/bin` and/or user defined
#   folders.
#
#   User can specify multiple folder to include to the `PATH` by specifying a
#   valid `PATH` syntax, for instance
#   `new_path="${DIRENV_ROOT}/path/to/bin:${DIRENV_ROOT}/another/path/to/bin"` in
#   `.envrc.ini`
#
#   Export _DIRENV_OLD_PATH to store the `PATH` before being updated to be able
#   to restore it later.
#
#   Parameters in `.envrc.ini` are:
#
#   <center>
#
#   | Name                 | Description                                                |
#   | :--------------------| :--------------------------------------------------------- |
#   | `add_direnv_to_path` | Boolean to tell if `.direnv/bin` should be added to `PATH` |
#   | `new_path`           | Path to folders to be added to `PATH`                      |
#
#   </center>
#
#   ## Parameters
#
#   ### `add_direnv_to_path`
#
#   Boolean, if set to `true` (default), folder `.direnv/bin` will be added to
#   `PATH`. It is strongly recommended to let this value to true to be able to
#   use some provided script from other modules such as `keepass` or `openstack`
#   modules.
#
#   ### `new_path`
#
#   Absolute path to folder containing executable that should be added to
#   `PATH`. Can be used multiple times to include multiple folders. Value can
#   use contraction such as `~`, `${HOME}` or `${DIRENV_ROOT}`.
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Path management module
#   # ------------------------------------------------------------------------------
#   # Update the variable `PATH`
#   [path_management]
#   # Add .direnv/bin to variable `PATH`
#   add_direnv_to_path=true
#   # Add specified path to the variable `PATH`
#   new_path=${DIRENV_ROOT}/path/to/be/added:${DIRENV_ROOT}/another/bin
#   ```
#
# """

path_management()
{
  # """Update `PATH` to include new folders
  #
  #   Update `PATH` variable to include either `.direnv/bin` and/or user defined
  #   folders.
  #
  # Globals:
  #   PATH
  #   _OLD_VIRTUAL_PATH
  #   _DIRENV_OLD_PATH
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

  local add_direnv_to_path=${path_management[add_direnv_to_path]:-"true"}
  local new_path=${path_management[new_path]:-""}
  local old_path=""

  # If python module loaded previously with virtual environment, gather old_path
  if [[ -n "${_OLD_VIRTUAL_PATH}" ]]
  then
      old_path=${_OLD_VIRTUAL_PATH}
  fi

  # Add `.direnv/bin` to `PATH`
  if [[ "${add_direnv_to_path}" == "true" ]]
  then
    if [[ -z "${old_path}" ]]
    then
      old_path=${PATH}
    fi
    export PATH="${DIRENV_ROOT}/.direnv/bin:${PATH}"
  fi

  # Add user defined path
  if [[ -n "${new_path}" ]]
  then
    if [[ -z "${old_path}" ]]
    then
      old_path=${PATH}
    fi
    export PATH="${new_path}:${PATH}"
  fi

  # Export `PATH` from its previous state.
  if [[ -n "${old_path}" ]]
  then
    export _DIRENV_OLD_PATH="${old_path}"
  fi
}


deactivate_path_management()
{
  # """Restore `PATH` to exclude new folders
  #
  # Restore `PATH` variable to its previous state and unset variables storing
  # old `PATH`
  #
  # Globals:
  #   PATH
  #   _OLD_VIRTUAL_PATH
  #   _DIRENV_OLD_PATH
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

  local old_path

  # If python module not already unloaded, gather its old path value
  if [[ -n "${_OLD_VIRTUAL_PATH}" ]]
  then
    old_path=${_OLD_VIRTUAL_PATH}
  else
    old_path=${_DIRENV_OLD_PATH}
  fi

  export PATH=${old_path}
  unset _DIRENV_OLD_PATH
}




