#!/usr/bin/env bash
# """Export packer variables
#
# DESCRIPTION:
#   Export variable `PACKER_LOG` and `PACKER_LOG_PATH` to tell packer to print
#   log and where to print them.
#
#   Parameters in `.envrc.ini` are:
#
#   <center>
#
#   | Name             | Description                                         |
#   | :--------------- | :-------------------------------------------------- |
#   | `PACKER_LOG`     | Either 0 or 1 (default) to tell packer to print log |
#   | `PACKER_LOG_PATH | Absolute path to the file where log will be printed |
#
#   </center>
#
#   ## Parameters
#
#   ### `PACKER_LOG`
#
#   Either 0 or 1 (default). If set to 1, tell packer to print log. If set to 0,
#   tell packer to not print log, in this case, `PACKER_LOG_PATH` is useless.
#
#   ### `PACKER_LOG_PATH`
#
#   Absolute path to where packer log will be stored. Value can use contraction
#   such as `~`, `${HOME}` or `${DIRENV_ROOT}`.
#
#   If this value is not set in `.envrc.ini`, default is set to
#   `.direnv/log/packer.log`
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Packer module
#   # ------------------------------------------------------------------------------
#   # Set packer environment variable
#   [packer]
#   # Activate packer log
#   PACKER_LOG=1
#   # Set where packer log will be outputed
#   PACKER_LOG_PATH=path/to/packer.log
#   ```
#
# """


packer()
{
  # """Export variables for packer
  #
  # Export variable `PACKER_LOG` and `PACKER_LOG_PATH` to tell packer to print
  # log and where.
  #
  # Globals:
  #   PACKER_LOG
  #   PACKER_LOG_PATH
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

  export PACKER_LOG=${packer[PACKER_LOG]:-1}
  export PACKER_LOG_PATH="${packer[PACKER_LOG_PATH]}:-${DIRENV_LOG_FOLDER}/packer.log"
}

deactivate_packer()
{
  # """Unset exported variables for packer
  #
  # Unset variables `PACKER_LOG` and `PACKER_LOG_PATH` previsouly exported for
  # packer
  #
  # Globals:
  #   PACKER_LOG
  #   PACKER_LOG_PATH
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

  unset PACKER_LOG
  unset PACKER_LOG_PATH
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
