#!/usr/bin/env bash
# """Activate the direnv management module
#
# DESCRIPTION:
#   **Only work when loaded using [`direnv`](https://direnv.net).**
#
#   Export variable to define the verbosity of the directory environment when
#   loading it and source parent directory environment.
#
#   Parameters in `.envrc.ini` are:
#
#   | Name                   | Description                                                                                        |
#   | :--------------------- | :------------------------------------------------------------------------------------------------- |
#   | `DIRENV_DEBUG_LEVEL`   | Select the level of verbosity                                                                      |
#   | `source_up`            | If set to `true` (default: `false`), load parent directory environment when loaded using `direnv`  |
#
#   ## Parameters
#
#   ### `DIRENV_DEBUG_LEVEL`
#
#   Export `DIRENV_DEBUG_LEVEL` if defined by the user. `DIRENV_DEBUG_LEVEL` can
#   have following values in severity order:
#
#     - `DEBUG`
#     - `INFO`
#     - `WARNING`
#     - `ERROR` (default)
#
#   Depending on the value set, will show log corresponding to this value and
#   values above. For instance, if value is set to `INFO`, log with `DEBUG`
#   severity while others log will be printed.
#
#   ### `source_up`
#
#   If directory environment activated using `direnv` and user specify to, i.e.
#   set `source_up=true`, source parent directory environment
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Direnv management module
#   # ------------------------------------------------------------------------------
#   # Simple module to load parent direnv configuration. Only work when using
#   # `direnv`
#   [direnv_management]
#   # When activated using `direnv`, tell `direnv to load parent directory
#   # environment
#   source_up=false
#   # Set the output log to `DEBUG`, `INFO`, `WARNING` or `ERROR` (default)
#   DIRENV_DEBUG_LEVEL="DEBUG"
#   ```
#
# """


direnv_management()
{
  # """Activate the direnv management module
  #
  # Export `DIRENV_DEBUG_LEVEL` if defined by the user.
  #
  # If directory environment activated using `direnv` and user specify to,
  # source parent directory environment
  #
  # Globals:
  #   DIRENV_DEBUG_LEVEL
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

  # shellcheck disable=SC2154
  #   - SC2514: var is referenced but not assigned
  if [[ -n "${direnv_management[DIRENV_DEBUG_LEVEL]}" ]]
  then
    export DIRENV_DEBUG_LEVEL="${direnv_management[DIRENV_DEBUG_LEVEL]}"
  fi

  if [[ "${IS_DIRENV}" == "true" ]] \
     && [[ "${direnv_management[source_up]}" == "true" ]]
  then
    source_up
  fi
}

deactivate_direnv_management()
{
  # """Deactivate the direnv management module
  #
  # Unset `DIRENV_DEBUG_LEVEL`
  #
  # Globals:
  #   DIRENV_DEBUG_LEVEL
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
  unset DIRENV_DEBUG_LEVEL
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------