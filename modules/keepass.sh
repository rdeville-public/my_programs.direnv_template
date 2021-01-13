#!/usr/bin/env bash
# """Setup keepass wrapper script and variable to ease use of keepassxc-cli
#
# DESCRIPTION:
#   Install a symlink from `.direnv/src/keepass.sh` to `.direnv/bin/keepass` to
#   be able to use script wrapper as keepass command. Also export some required
#   variable used by the script. Finally ensure that exported variables are
#   valid, i.e. the keepass database can be unlocked using keepass keyfile.
#
#   REMARK: Keepass script require a keepass database that is unlocked by a
#   file, not by a password !
#
#   Parameters in `.envrc.ini` are:
#
#   | Name               | Description                                                                                             |
#   | :----------------- | :------------------------------------------------------------------------------------------------------ |
#   | `KEEPASS_DB`       | Absolute path to a keepassxc database                                                                   |
#   | `KEEPASS_KEYFILE`  | Absolute path to a file to unlock keepassxc database                                                    |
#   | `KEEPASS_NAME`     | (optional) Explicit name for the database, like `perso`, `pro`, etc., which can be used in your prompt  |
#
#   ## Parameters
#
#   ### `KEEPASS_DB`
#
#   Absolute path to a keepassxc database, you can use `~`, `${HOME}` or even
#   `${DIRENV_ROOT} to define path relatively. The database cannot be unlocked
#   with password when using script `keepass.sh`, be sure to configure it to be
#   unlocked using file.
#
#   ### `KEEPASS_KEYFILE`
#
#   Absolute path to the file that unlock the keepass database defined in
#   `KEEPASS_DB`.
#
#   ### `KEEPASS_NAME`
#
#   An explicit name, like `perso`, `pro`, etc. Useless for script `keepass.sh`.
#   It is export only to be used in your prompt (like in `PS1`). If not set,
#   value of this variable will be the filename of the `KEEPASS_DB`.

#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Keepass module
#   # ------------------------------------------------------------------------------
#   # Set keepassxc environment variable to be able to use the keepassxc-cli wrapper
#   # provided in `.direnv/src/keepass.sh`.
#   [keepass]
#   # Specify the path to the keypass database
#   KEEPASS_DB=/path/to/keepass.db
#   # Specify the path to the keyfile unlocking the keepass database
#   KEEPASS_KEYFILE=/another/path/to/keyfile
#   # Specify an explicit name in an environment variable to be able to use it in
#   # your shell prompt.
#   KEEPASS_NAME=Perso
#   ```
#
# """

keepass()
{
  # """Install keepass wrapper and export keepass variable required for wrapper
  #
  # Install a symlink from `.direnv/src/keepass.sh` to `.direnv/bin/keepass` to
  # be able to use script wrapper as keepass command. Also export some required
  # variable used by the script. Finally ensure that exported variables are
  # valid, i.e. the keepass database can be unlocked using keepass keyfile.
  #
  # Globals:
  #   KEEPASS_DB
  #   KEEPASS_KEYFILE
  #   KEEPASS_NAME
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Log information
  #
  # Returns:
  #   1 if required variables are not set or if database can not be unlocked
  #   0 if everything is right and database can be unlocked
  #
  # """

  install_keepass_script()
  {
    # """Install keepass wrapper script
    #
    # Install a symlink from `.direnv/src/keepass.sh` to `.direnv/bin/keepass`
    # to be able to use script wrapper as keepass command.
    #
    # Globals:
    #   DIRENV_BIN_FOLDER
    #   DIRENV_SRC_FOLDER
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

    if ! [[ -e "${DIRENV_BIN_FOLDER}/keepass" ]]
    then
      ln -s "${DIRENV_SRC_FOLDER}/keepass.sh" "${DIRENV_BIN_FOLDER}/keepass"
    fi
  }

  check_variable()
  {
    # """Ensure variables are defined
    #
    # Ensure the value provided as second argument is not null. First argument
    # is the name of the variable associated with the value.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   $1: string, name of the variable to check
    #   $2: string, value of the variable to check
    #
    # Output:
    #   Error log when variable value is not set
    #
    # Returns:
    #   1 if variable value is not set
    #   0 if variable value is set
    #
    # """

    local var_name=$1
    local var_value=$2
    if [[ -z "${var_value}" ]]
    then
      direnv_log "ERROR" "Variable **\`${var_name}\`** should be set in .envrc.ini. "
      return 1
    fi
  }

  check_file()
  {
    # """Ensure file defined by variable exists
    #
    # Ensure the value provided as second argument is a file that exists. First
    # argument is the name of the variable associated with the file path.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   $1: string, name of the variable which hold the path to a file
    #   $2: string, path of the file that must exists
    #
    # Output:
    #   Error log when file does not exists
    #
    # Returns:
    #   1 if file does not exists
    #   0 if file does exists
    #
    # """

    local var_name=$1
    local var_value=$2
    if ! [[ -f "${var_value}" ]]
    then
      direnv_log "ERROR" "File defined by variable **\`${var_name}\`** does not exists."
      return 1
    fi
  }

  # shellcheck disable=SC2154
  #   - SC2514: keepass is referenced but not assigned
  local keepass_db=${keepass[KEEPASS_DB]}
  local keepass_keyfile=${keepass[KEEPASS_KEYFILE]}
  local keepass_name=${keepass[KEEPASS_NAME]:-${keepass_db}}

  # shellcheck disable=SC2089
  #   - SC2089: Quotes\Backslash will be treated litteraly
  local keepass_test_cmd="keepassxc-cli \
    ls --no-password -k \"${keepass_keyfile}\" \"${keepass_db}\""
  local error="false"
  local export_var_name
  local export_var_value

  # Ensure keepassxc-cli is installed
  if ! command -v keepassxc-cli > /dev/null 2>&1
  then
    direnv_log "ERROR" "Command **\`keepassxc-cli\`** does not exists."
    direnv_log "ERROR" "Please refer to your OS distribution to install keepassxc-cli"
    return 1
  fi

  # Ensure every required variable are defined
  for i_var in "keepass_db" "keepass_keyfile"
  do
    export_var_name="$(echo "${i_var}" | tr '[:lower:]' '[:upper:]')"
    # shellcheck disable=SC2116
    #   - SC2116: Useless echo ?
    export_var_value="$(eval "$(echo "echo \"\${${i_var}}\"" )" )"
    check_variable "${export_var_name}" "${export_var_value}" \
      && check_file "${export_var_name}" "${export_var_value}" \
      || error="true"
  done
  if [[ "${error}" == "true" ]]
  then
    return 1
  fi

  # Ensure variables are correct and allow to unlock the database
  if ! eval "${keepass_test_cmd}" > /dev/null 2>&1
  then
    direnv_log "ERROR" "Unable to open the keepass DB with provided **KEEPASS variables**!"
    return 1
  fi

  # Export variable
  export KEEPASS_DB=${keepass_db}
  export KEEPASS_KEYFILE=${keepass_keyfile}
  export KEEPASS_NAME=${keepass_name}
  install_keepass_script
}


deactivate_keepass()
{
  # """Unset exported variables for keepass module
  #
  # Unset `KEEPASS_*` variable previously exported.
  #
  # Globals:
  #   KEEPASS_DB
  #   KEEPASS_KEYFILE
  #   KEEPASS_NAME
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

  unset KEEPASS_DB
  unset KEEPASS_NAME
  unset KEEPASS_KEYFILE
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
