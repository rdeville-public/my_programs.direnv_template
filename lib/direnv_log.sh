#!/usr/bin/env bash
# """Print debug message in colors depending on message severity
#
# DESCRIPTION:
#   THIS SCRIPT SHOULD BE USED AS LIBRARY SCRIPT
#
#   Best use is to source this file to define `direnv_log` method. Print log
#   depending on message severity, such as:
#
#     - DEBUG severity print in the fifth colors of the terminal (usually magenta)
#     - INFO severity print in the second colors of the terminal (usually green)
#     - WARNING severity print in the third colors of the terminal (usually yellow)
#     - ERROR severity print in the third colors of the terminal (usually red)
#
# """

# shellcheck disable=SC2034
#   - SC2034: var appears unused, Verify use (or export if used externally)
direnv_log()
{
  # """Print debug message in colors depending on message severity
  #
  # Echo colored log depending on user provided message severity. Message
  # severity are associated to following color output:
  #
  #   - DEBUG severity print in the fifth colors of the terminal (usually magenta)
  #   - INFO severity print in the second colors of the terminal (usually green)
  #   - WARNING severity print in the third colors of the terminal (usually yellow)
  #   - ERROR severity print in the third colors of the terminal (usually red)
  #
  # If no message severity is provided, severity will automatically be set to
  # INFO.
  #
  # Globals:
  #   ZSH_VERSION
  #
  # Arguments:
  #   $1 string, message severity or message content
  #   $@ string, message content
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
  local e_debug="\e[0;35m"   # Fifth term color (usually magenta fg)
  local e_info="\e[0;32m"    # Second term color (usually green fg)
  local e_warning="\e[0;33m" # Third term color (usually yellow fg)
  local e_error="\e[0;31m"   # First term color (usually red fg)

  # Store preformated colored prefix for log message
  local error="${e_bold}${e_error}[ERROR]${e_normal}${e_error}"
  local warning="${e_bold}${e_warning}[WARNING]${e_normal}${e_warning}"
  local info="${e_bold}${e_info}[INFO]${e_normal}${e_info}"
  local debug="${e_bold}${e_debug}[DEBUG]${e_normal}${e_debug}"

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
  else
    prefix="${info}"
  fi

  # Concat all remaining arguments in the message content.
  msg="${prefix} $* ${e_normal}"

  if [[ "${msg_severity}" = "error" ]]
  then
    echo -e "${msg}"
  elif [[ -n "${DIRENV_DEBUG_LEVEL}" ]]
  then
    case ${DIRENV_DEBUG_LEVEL} in
      DEBUG)
        echo "${msg_severity}" | grep -q -E "(debug|info|warning|error)" && echo -e "${msg}"
        ;;
      INFO)
        echo "${msg_severity}" | grep -q -E "(info|warning|error)" && echo -e "${msg}"
        ;;
      WARNING)
        echo "${msg_severity}" | grep -q -E "(warning|error)" && echo -e "${msg}"
        ;;
    esac
  fi
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
