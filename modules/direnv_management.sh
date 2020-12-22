#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

direnv_management()
{
  # shellcheck disable=SC2154
  #   - SC2514: keepass is referenced but not assigned
  if [ -n "${direnv_management[DIRENV_DEBUG_LEVEL]}" ]
  then
    export DIRENV_DEBUG_LEVEL="${direnv_management[DIRENV_DEBUG_LEVEL]}"
  fi

  direnv_log "INFO" "Loading module direnv_managment"

  if [ "${IS_DIRENV}" = "true" ] && [ "${direnv_management[source_up]}" = "true" ]
  then
    source_up
  fi
}