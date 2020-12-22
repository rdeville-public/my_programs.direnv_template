#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039:In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead


parse_ini_file()
{
  parse_ini_section()
  {
    local line="$1"
    local module_name

    module_name="$(echo "${line}" | sed -e "s/\[//g" -e "s/\]//g" -e "s/ /_/g")"
    direnv_modules+=("${module_name}")
  }

  parse_ini_value()
  {
    local line="$1"
    local last_module_name="$2"
    local key
    local value
    local var_access

    line=${line// =/=} # Remove space before =
    line=${line//= /=} # Remove space after =
    key=$(echo "${line}" | cut -d "=" -f 1)
    value=$(echo "${line}" | cut -d "=" -f 2)
    if echo "${value}" | grep -q "cmd:"
    then
      # shellcheck  disable=SC2001
    #   - SC2001:Replace with bash substitution
      cmd=$( echo "${value}" | sed "s/cmd://g" )
      value=$( eval "${cmd}" )
    fi
    if echo "${last_module_name}" | grep -q ":"
    then
      key="$(echo "${last_module_name}" | cut -d ":" -f 2),${key}"
      last_module_name=$(echo "${last_module_name}" | cut -d ":" -f 1 )
    fi
    var_access="echo \"\${${last_module_name}[${key}]}\""
    # shellcheck disable=SC2116
    #   - SC2116: Useless echo ?
    curr_var_value="$(eval "$( echo "${var_access}" )" )"
    if [[ -n "${curr_var_value}" ]]
    then
      value="${curr_var_value}${DIRENV_INI_SEP}${value}"
    fi
    # shellcheck disable=SC2116
    #   - SC2116: Useless echo ?
    eval "$(echo "${last_module_name}[${key}]=\"${value}\"")"
  }

  parse_ini_line()
  {
    local line="$1"
    local last_module_name="$2"

    if echo "${line}" | grep -q -E "^\[.*\]"
    then
      parse_ini_section "${line}"
    elif echo "${line}" | grep -q "="
    then
      parse_ini_value "${line}" "${last_module_name}"
    fi
  }

  local filename="$1"
  local last_module_size=0
  local last_module_name=""

  while read -r line
  do
    if ! [[ "${line}" =~ ^# ]] && [[ -n "${line}" ]]
    then
      parse_ini_line "${line}" "${last_module_name}"
      if [[ "${#direnv_modules[@]}" -ne "${last_module_size}" ]]
      then
        last_module_size=${#direnv_modules[@]}
        last_module_name=${direnv_modules[-1]}
        declare -A -g "$(echo "${last_module_name}" | cut -d ":" -f 1)"
      fi
    fi
  done <<< "$(cat "${filename}")"
}

