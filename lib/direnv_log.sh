#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2034,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039:In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

direnv_log()
{
  # Print colored log depending on provided parameter
  # PARAM:
  #   * $1: String, log level (DEBUG, INFO, WARN, ERROR) or message to print
  #     $2: String, message to print if log level is specified

  # COLORING ECHO OUTPUT
  # ---------------------------------------------------------------------------
  # Some exported variable I sometimes use in my script to echo informations in
  # colors. Base on only 8 colors to ensure portability of color when in tty
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  local e_dim="\e[2m"        # dim
  local e_italic="\e[3m"     # italic
  local e_underline="\e[4m"  # underline
  local e_debug="\e[0;35m"   # magenta fg
  local e_info="\e[0;32m"    # green fg
  local e_warning="\e[0;33m" # yellow fg
  local e_error="\e[0;31m"   # red fg
  # store preformated colored prefix for log message
  local error="${e_bold}${e_error}[ERROR]${e_normal}${e_error}"
  local warning="${e_bold}${e_warning}[WARNING]${e_normal}${e_warning}"
  local info="${e_bold}${e_info}[INFO]${e_normal}${e_info}"
  local debug="${e_bold}${e_debug}[DEBUG]${e_normal}${e_debug}"
  local msg_severity=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  local msg

  if [[ "${msg_severity}" =~ ^(error|time|warning|info|debug)$ ]]
  then
    shift
    case ${SHELL} in
      (*bash)
        prefix="${!msg_severity}"
        ;;
      (*zsh)
        prefix="${(P)msg_severity}"
        ;;
    esac
  else
    prefix="${info}"
  fi
  # Fill content of prefix with the content of the variable which name is the
  # message severity (depending on the shell type)
  msg="${prefix} $* ${e_normal}"

  if [ "${msg_severity}" = "error" ]
  then
    echo -e "${msg}"
  elif [ -n "${DIRENV_DEBUG_LEVEL}" ]
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

