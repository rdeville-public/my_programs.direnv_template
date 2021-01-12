#!/usr/bin/env bash
# """Ensure specified folder exists, if not create them.
#
# DESCRIPTION:
#   Ensure list of specified folders provided by the user exists. If not, then
#   create these folders.
#
#   Parameters in `.envrc.ini` are:
#
#   | Name       | Description                                                    |
#   | :--------- | :------------------------------------------------------------- |
#   | `new`      | Path of the folder that must exists relative to `DIRENV_ROOT`  |
#
#   ## Parameters
#
#   ### `new`
#
#   Path, relative to `DIRENV_ROOT` that must exists. Can be used multiple time
#   to specify multiple folders to create. If parent directory does not exists
#   it will be created.
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Folder module
#   # ------------------------------------------------------------------------------
#   # Ensure new folders exists
#   [folders]
#   # Specify folders which must exist, if not they will be created. Path
#   # relative to `DIRENV_ROOT`.
#   new=tmp/folder_1
#   new=tmp/folder_2
#   ```
#
# """

folders()
{
  # """Ensure list of folder exists
  #
  # From every folders listed in `${folder[new]}` ensure folders exist. If not,
  # they will be created with their parent directory relative to `DIRENV_ROOT`.
  #
  # Globals:
  #   DIRENV_INI_SEP
  #   DIRENV_ROOT
  #   ZSH_VERSION
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Log information when creating a folder
  #
  # Returns:
  #   None
  #
  # """

  local directories=()
  local i_folder

  # shellcheck disable=SC2154
  #   - SC2154: var is refenced but not assigned
  if [[ "${folders[new]}" =~ ${DIRENV_INI_SEP} ]]
  then
    # Split string `${folder[new]}` into an array.
    # Handle zsh
    if [[ -n "${ZSH_VERSION}" ]]
    then
      IFS="${DIRENV_INI_SEP}" read -r -A directories <<< "${folders[new]}"
    else
      IFS="${DIRENV_INI_SEP}" read -r -a directories <<< "${folders[new]}"
    fi
  else
    directories+=("${folders[new]}")
  fi

  for i_folder in "${directories[@]}"
  do
    i_folder="${DIRENV_ROOT}/${i_folder}"
    if ! [[ -d "${i_folder}" ]]
    then
      direnv_log "INFO" "Creation of folder **${i_folder//${DIRENV_ROOT}\//}**."
      mkdir -p "${i_folder}"
    fi
  done
}


