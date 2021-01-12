#!/usr/bin/env bash
# """Print debug message in colors depending on message severity on stderr
#
# DESCRIPTION:
#   THIS SCRIPT SHOULD BE USED AS LIBRARY SCRIPT
#
#   Best use is to source this file to define `direnv_log` method. Print log
#   depending on message severity, such as:
#
#     - `DEBUG` print in the fifth color of the terminal (usually magenta)
#     - `INFO` print in the second color of the terminal (usually green)
#     - `WARNING` print in the third color of the terminal (usually yellow)
#     - `ERROR` print in the third color of the terminal (usually red)
#
# """

# shellcheck disable=SC2034
#   - SC2034: var appears unused, Verify use (or export if used externally)
direnv_log()
{
  # """Print debug message in colors depending on message severity on stderr
  #
  # Echo colored log depending on user provided message severity. Message
  # severity are associated to following color output:
  #
  #   - `DEBUG` print in the fifth colors of the terminal (usually magenta)
  #   - `INFO` print in the second colors of the terminal (usually green)
  #   - `WARNING` print in the third colors of the terminal (usually yellow)
  #   - `ERROR` print in the third colors of the terminal (usually red)
  #
  # If no message severity is provided, severity will automatically be set to
  # INFO.
  #
  # Globals:
  #   ZSH_VERSION
  #
  # Arguments:
  #   $1: string, message severity or message content
  #   $@: string, message content
  #
  # Output:
  #   Log informations colored
  #
  # Returns:
  #   None
  #
  # """

  # Store color prefixes in variable to ease their use.
  # Base on only 8 colors to ensure portability of color when in tty
  local e_normal="\e[0m"     # Normal (usually white fg & transparent bg)
  local e_bold="\e[1m"       # Bold
  local e_underline="\e[4m"  # Underline
  local e_debug="\e[0;35m"   # Fifth term color (usually magenta fg)
  local e_info="\e[0;32m"    # Second term color (usually green fg)
  local e_warning="\e[0;33m" # Third term color (usually yellow fg)
  local e_error="\e[0;31m"   # First term color (usually red fg)

  # Store preformated colored prefix for log message
  local error="${e_bold}${e_error}[ERROR]${e_normal}${e_error}"
  local warning="${e_bold}${e_warning}[WARNING]${e_normal}${e_warning}"
  local info="${e_bold}${e_info}[INFO]${e_normal}${e_info}"
  local debug="${e_bold}${e_debug}[DEBUG]${e_normal}${e_debug}"

  local color_output="e_error"
  local msg_severity
  local msg

  # Not using ${1^^} to ensure portability when using ZSH
  msg_severity=$(echo "$1" | tr '[:upper:]' '[:lower:]')

  if [[ "${msg_severity}" =~ ^(error|time|warning|info|debug)$ ]]
  then
    # Shift arguments by one such that $@ start from the second arguments
    shift
    # Place the content of variable which name is defined by ${msg_severity}
    # For instance, if `msg_severity` is INFO, then `prefix` will have the same
    # value as variable `info`.
    if [[ -n "${ZSH_VERSION}" ]]
    then
      prefix="${(P)msg_severity}"
    else
      prefix="${!msg_severity}"
    fi
    color_output="e_${msg_severity}"
  else
    prefix="${info}"
  fi

  if [[ -n "${ZSH_VERSION}" ]]
  then
    color_output="${(P)color_output}"
  else
    color_output="${!color_output}"
  fi

  # Concat all remaining arguments in the message content and apply markdown
  # like syntax.
  msg_content=$(echo "$*" | sed -e "s/ \*\*/ \\${e_bold}/g" \
                              -e "s/\*\*\./\\${e_normal}\\${color_output}./g" \
                              -e "s/\*\* /\\${e_normal}\\${color_output} /g" \
                              -e "s/ \_\_/ \\${e_underline}/g" \
                              -e "s/\_\_\./\\${e_normal}\\${color_output}./g" \
                              -e "s/\_\_ /\\${e_normal}\\${color_output} /g")
  msg="${prefix} ${msg_content}${e_normal}"

  # Print message or not depending on message severity and DIRENV_DEBUG_LEVEL
  if [[ -z "${DIRENV_DEBUG_LEVEL}" ]] && [[ "${msg_severity}" == "error" ]]
  then
    echo -e "${msg}" 1>&2
  elif [[ -n "${DIRENV_DEBUG_LEVEL}" ]]
  then
    case ${DIRENV_DEBUG_LEVEL} in
      DEBUG)
        echo "${msg_severity}" \
          | grep -q -E "(debug|info|warning|error)" && echo -e "${msg}" 1>&2
        ;;
      INFO)
        echo "${msg_severity}" \
          | grep -q -E "(info|warning|error)" && echo -e "${msg}" 1>&2
        ;;
      WARNING)
        echo "${msg_severity}" \
          | grep -q -E "(warning|error)" && echo -e "${msg}" 1>&2
        ;;
      ERROR)
        echo "${msg_severity}" \
          | grep -q -E "error" && echo -e "${msg}" 1>&2
        ;;
    esac
  fi
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
