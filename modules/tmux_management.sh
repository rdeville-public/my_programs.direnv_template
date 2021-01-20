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
#   | `command`      | Command to be executed when starting the tmux session |
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
#   ### `command`
#
#   Command to be executed when starting the session, like `vim` to open vim or
#   `task list projects:direnv_template` to print task from taskwarrior and
#   bugwarrior with project `direnv_template, etc.`
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
#   # Override default tmux session name
#   session_name=direnv_template
#   # Command to execute when starting the tmux session
#   command=task list project:direnv_template
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

  local tmux_session=${tmux[session_name]:-$(basename "${DIRENV_ROOT}")}
  local tmux_start_command=${tmux[command]:-""}

  # Replace `.` by `_` in tmux session name
  tmux_sesion=${tmux_session//\./_}

  # Check if tmux session already exists
  if ! tmux list-sessions &> /dev/null || ! tmux list-sessions | grep -q -E "^${tmux_session}"
  then
    if [[ -n "${tmux_start_command}" ]]
    then
      tmux new-session -d -s "${tmux_session}" "${start_command}"
    else
      tmux new-session -d -s "${tmux_session}"
    fi
  fi

  # Check if inside a tmux session
  if [[ -z "${TMUX}" ]]
  then
    tmux attach-session -t "${tmux_session}"
  fi
}
