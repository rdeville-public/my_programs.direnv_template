#!/us/bin/env bash
# """Load configuration file `.envrc.ini` and store values in associative arrays
#
# DESCRIPTION:
#   THIS SCRIPT SHOULD BE USED AS LIBRARY SCRIPT
#
#   Best use is to source this file to define `parse_ini_file` method.
#
#   Parse line by line a simple `.ini` file, for each section, create an
#   associative array per section which store key and value of the `.ini` file.
#
# """


parse_ini_file()
{
  # """Parse a simple `.ini` file and stre values in associative arrays.
  #
  # Parse line by line a `.ini` file, if a section tag is encountered, create an
  # associative array from the name of the section and store each key, value
  # pair in this associative array.
  #
  # For instances:
  #
  # ```dosini
  # [section_name]
  # # Comment
  # key_1 = foo
  # key_2 = bar
  # ```
  #
  # Will result on the creation of the bash associative array `${section_name}`
  # with two key,value pair accessible as shown below:
  #
  # ```bash
  # echo ${section_name[key_1]}
  # # Will echo foo
  # echo ${section_name[key_2]}
  # # Will echo bar
  # ```
  #
  # Globals:
  #   DIRENV_INI_SEP
  #
  # Arguments:
  #   $0 string, path to the `.ini` config file to parse
  #
  # Output:
  #   None
  #
  # Returns:
  #   None
  #
  # """

  parse_ini_section()
  {
    # """Parse a simple `.ini` file and stre values in associative arrays.
    #
    # Parse line by line a `.ini` file, if a section tag is encountered, create an
    # associative array from the name of the section and store each key, value
    # pair in this associative array.
    # Space ` ` in section name will be replaced by underscore `_`.
    #
    # For instances:
    #
    # ```dosini
    # [section name]
    # # Comment
    # key_1 = foo
    # key_2 = bar
    # ```
    #
    # Will result on the creation of the bash associative array `${section_name}`
    # with two key,value pair accessible as shown below:
    #
    # ```bash
    # echo ${section_name[key_1]}
    # # Will echo foo
    # echo ${section_name[key_2]}
    # # Will echo bar
    # ```
    #
    # Globals:
    #   DIRENV_INI_SEP
    #
    # Arguments:
    #   $0 string, path to the `.ini` config file to parse
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """

    local line="$1"
    local module_name

    module_name="$(echo "${line}" | sed -e "s/\[//g" -e "s/\]//g" -e "s/ /_/g")"
    direnv_modules+=("${module_name}")
  }

  parse_ini_value()
  {
    # """Parse line key, value provided as argument from an `.ini` file
    #
    # Parse a single line provided as first argument from an `.ini`, i.e. of the
    # following form:
    #
    # ```dosini
    # # This is a comment
    # key=value
    # key =value
    # key= value
    # key = value
    # ```
    #
    # Others form are not supported !
    # Once the line is parse, if value start with `cmd:`, this means that value
    # is obtain from a command provided, execute the command to have the value.
    # store the pair key, value into the associative
    # array corresponding to the section provided as second argument.
    #
    # If there already exist an entry for the key in the associative array, the
    # new value will be concatenate with the old value using `${DIRENV_INI_SEP}`
    # as separator to be able to easily split the string later in the
    # corresponding module.
    #
    # Globals:
    #   DIRENV_INI_SEP
    #
    # Arguments:
    #   $1 string, line to part
    #   $2 string, name of the module where key, value will be stored
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """
    local line="$1"
    local last_module_name="$2"
    local key
    local value
    local var_access

    # Remove space before `=`
    line=${line// =/=}
    # Remove space after `=`
    line=${line//= /=}
    # Remove everything after the first =
    key="${line%=*}"
    # Remove everything before the first =
    value="${line#*=}"

    if [[ "${value}" =~ ^cmd: ]]
    then
      # Remove first string `cmd:` from the value
      cmd=${value/cmd:/}
      value=$( eval "${cmd}" )
    fi

    if [[ "${last_module_name}" =~ : ]]
    then
      # Remove everything after the ":" in the module name, usefull for storing
      # multiple configuration for a single section, like for openstack module
      # and generate key based on the module configuration
      key="${last_module_name#*:},${key}"
      last_module_name="${last_module_name%:*}"
    fi

    # Check if pair key, val does not already exists
    var_access="echo \"\${${last_module_name}[${key}]}\""
    # shellcheck disable=SC2116
    #   - SC2116: Useless echo ?
    curr_var_value="$(eval "$( echo "${var_access}" )" )"
    if [[ -n "${curr_var_value}" ]]
    then
      value="${curr_var_value}${DIRENV_INI_SEP}${value}"
    fi

    # Store the pair key, value into the corresponding associative array.
    # shellcheck disable=SC2116
    #   - SC2116: Useless echo ?
    eval "$(echo "${last_module_name}[${key}]=\"${value}\"")"
  }

  parse_ini_line()
  {
    # """Determine if a line define a section or a pair key, value
    #
    # Determine if line provided as argument define a section, then call method
    # `parse_ini_section`, else if line determine a pair key, value, call method
    # `parse_ini_value`.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   $1 string, line to parse
    #   $2 string, name of the last section (i.e. module) parsed
    #
    # Output:
    #   None
    #
    # Returns:
    #   None
    #
    # """
    local line="$1"
    local last_module_name="$2"
    local regexp="^\[.*\]"

    if [[ "${line}" =~ ${regexp} ]]
    then
      parse_ini_section "${line}"
    elif [[ "${line}" =~ [a-zA_Z0_9_]*= ]]
    then
      parse_ini_value "${line}" "${last_module_name}"
    fi
  }

  # Content of the main method
  local filename="$1"
  local last_module_size=0
  local last_module_name=""

  while read -r line
  do
    # If line is not empty and is not a comment
    if ! [[ "${line}" =~ ^# ]] && [[ -n "${line}" ]]
    then
      parse_ini_line "${line}" "${last_module_name}"

      # If last parsed line define a new module, create corresponding
      # associative array
      if [[ "${#direnv_modules[@]}" -ne "${last_module_size}" ]]
      then
        last_module_size=${#direnv_modules[@]}
        last_module_name=${direnv_modules[-1]}
        # Remove everythin after the first `:`
        declare -A -g "${last_module_name%:*}"
      fi
    fi
  done <<< "$(cat "${filename}")"
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
