#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

# PACKER RELATED VARIABLES
# ------------------------------------------------------------------------------
# Setup packer log files depending on projet (i.e. environment)
packer()
{
  export PACKER_LOG=${packer[PACKER_LOG]:-1}
  export PACKER_LOG_PATH="${packer[PACKER_LOG_PATH]}:-${DIRENV_LOG_FOLDER}/packer.log"
}

deactivate_packer()
{
  unset PACKER_LOG
  unset PACKER_LOG_PATH
}
# ANSIBLE RELATED VARIABLES
