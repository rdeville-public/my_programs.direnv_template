#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

# Keepass related variables
# ------------------------------------------------------------------------------
# Location of database
install_keepass_script()
{
  if ! [[ -e "${DIRENV_BIN_FOLDER}/keepass" ]]
  then
    ln -s "${DIRENV_SRC_FOLDER}/keepass.sh" "${DIRENV_BIN_FOLDER}/keepass"
  fi
}

remove_keepass_script()
{
  if [[ -e "${DIRENV_BIN_FOLDER}/keepass" ]]
  then
    rm -f "${DIRENV_BIN_FOLDER}/keepass"
  fi
}

check_variable()
{
  local var_name=$1
  local var_value=$2
  if [ -z "${var_value}" ]
  then
    direnv_log "ERROR" "Variable \`${var_name}\` should be set in .envrc.ini. "
    return 1
  fi
}


check_file()
{
  local var_name=$1
  local var_value=$2
  if ! [ -f "${var_value}" ]
  then
    direnv_log "ERROR" "File defined by variable \`${var_name}\` does not exists."
    return 1
  fi
}


keepass()
{
  # shellcheck disable=SC2154
  #   - SC2514: keepass is referenced but not assigned
  local keepass_db=${keepass[KEEPASS_DB]}
  local keepass_keyfile=${keepass[KEEPASS_KEYFILE]}
  local keepass_name=${keepass[KEEPASS_NAME]:-${keepass_db}}
  # shellcheck disable=SC2089
  #   - SC2089: Quotes\Backslash will be treated litteraly
  local keepass_test_cmd="keepassxc-cli ls --no-password -k \"${keepass_keyfile}\" \"${keepass_db}\""
  local error="false"
  local export_var_name
  local export_var_value

  # Ensure path to file unlocking pagoda keepass db is define and valid
  if ! command -v keepassxc-cli > /dev/null 2>&1
  then
    direnv_log "ERROR" "Command \`keepassxc-cli\` does not exists."
    direnv_log "ERROR" "Please refer to your OS distribution to install keepassxc-cli"
    return 1
  fi
  for i_var in "keepass_db" "keepass_keyfile"
  do
    export_var_name="$(echo "${i_var}" | tr '[:lower:]' '[:upper:]')"
    # shellcheck disable=SC2116
    #   - SC2116: Useless ech o ?
    export_var_value="$(eval "$(echo "echo \"\${${i_var}}\"" )" )"
    check_variable "${export_var_name}" "${export_var_value}" && check_file "${export_var_name}" "${export_var_value}" || error="true"
  done
  if [[ "${error}" = "true" ]]
  then
    return 1
  fi
  if ! eval "${keepass_test_cmd}" > /dev/null 2>&1
  then
    direnv_log "ERROR" "Unable to open the keepass DB with provided KEEPASS variables!"
    return 1
  fi
  export KEEPASS_DB=${keepass_db}
  export KEEPASS_KEYFILE=${keepass_keyfile}
  export KEEPASS_NAME=${keepass_name}
  install_keepass_script
}


deactivate_keepass()
{
  unset KEEPASS_DB
  unset KEEPASS_NAME
  unset KEEPASS_KEYFILE
  remove_keepass_script
}
