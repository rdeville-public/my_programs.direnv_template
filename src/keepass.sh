#!/bin/bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

load_keepass_info(){
    local action=$1
    local inbase_key=$2
    local info=$3
    local cmd=""

    if [[ -z ${KEEPASS_KEYFILE} ]]
    then
      echo "ERROR - Variable KEEPASS_KEYFILE must be set to continue !"
      return 1
    elif ! [[ -f "${KEEPASS_KEYFILE}" ]]
    then
      echo "ERROR - Files ${KEEPASS_KEYFILE}  must exists to continue !"
      return 2
    elif ! [[ -f "${KEEPASS_DB}" ]]
    then
      echo "ERROR - Files ${KEEPASS_DB}  must exists to continue !"
      return 3
    else
      cmd="keepassxc-cli ${action} --no-password -k \"${KEEPASS_KEYFILE}\" "
      if [[ ${action} == show ]]
      then
          if [[ -n "${info}" ]]
          then
              cmd+="-a \"${info}\" "
          else
              cmd+="-a Password "
          fi
      fi
      cmd+="\"${KEEPASS_DB}\" \"${inbase_key}\""
      val=$(eval "${cmd}")
      if [[ -z "${val}" ]]
      then
        return 4
      fi
    fi
    echo "${val}"
    return 0
}

load_keepass_info "$@"
exit $?
