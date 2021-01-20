#!/usr/bin/env bash
# """Start and attach a tmux session
#
# DESCRIPTION:
#   Automatically create a tmux session if session does not exists yet. Session
#   name can be user defined or automatically set to the name of the directory.
#
#   Once tmux session is created or if already existing, attach terminal to the
#   tmux session.
#
#   User can also define a command to be executed when starting the session.
#
#   Parameters in `.envrc.ini` are:
#
#   <center>
#
#   | Name           | Description                                           |
#   | :------------- | :---------------------------------------------------- |
#   | `session_name` | Name of the tmux session                              |
#
#   </center>
#
#   ## Parameters
#
#   ### `session_name`
#
#   Name of the tmux session, i.e. name that will be shown when using the
#   command `tmux list-sessions`. If not set, the session name will be the directory
#   name.
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Tmux module
#   # ------------------------------------------------------------------------------
#   # Create and/or attach session which name is the directory folder
#   [tmux_management]
#   # Override default (folder name) tmux session name
#   session_name=direnv_template
#   ```
#
# """


tmux_management()
{
  # """Automatically create and/or attach a tmux session
  #
  # Automatically create a tmux session if session does not exists yet. Session
  # name can be user defined or automatically set to the name of the directory.
  #
  # Once tmux session is created or if already existing, attach terminal to the
  # tmux session.
  #
  # User can also define a command to be executed when starting the session.
  #
  # Globals:
  #   None
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

  local tmux_session=${tmux_management[session_name]:-$(basename "${DIRENV_ROOT}")}
  # Replace `.` by `_` in tmux session name
  tmux_session=${tmux_session//\./_}

  # Check if tmux session already exists
  if ! tmux list-sessions &> /dev/null || ! tmux list-sessions | grep -q -E "^${tmux_session}"
  then
    tmux new-session -d -s "${tmux_session}"
  fi

  # Check if inside a tmux session
  if [[ -z "${TMUX}" ]]
  then
    tmux attach-session -t "${tmux_session}"
  fi
}
