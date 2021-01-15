# tmux_management
Start and attach a tmux session

## Description

Automatically create a tmux session if session does not exists yet. Session
name can be user defined or automatically set to the name of the directory.

Once tmux session is created or if already existing, attach terminal to the
tmux session.

User can also define a command to be executed when starting the session.

Parameters in `.envrc.ini` are:

| Name           | Description                                           |
| :------------- | :---------------------------------------------------- |
| `session_name` | Name of the tmux session                              |
| `command`      | Command to be executed when starting the tmux session |

## Parameters

### `session_name`

Name of the tmux session, i.e. name that will be shown when using the
command `tmux list-sessions`. If not set, the session name will be the directory
name.

### `command`

Command to be executed when starting the session, like `vim` to open vim or
`task list projects:direnv_template` to print task from taskwarrior and
bugwarrior with project `direnv_template, etc.`

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Tmux module
# ------------------------------------------------------------------------------
# Create and/or attach session which name is the directory folder
[tmux_management]
# Override default tmux session name
session_name=direnv_template
# Command to execute when starting the tmux session
command=task list project:direnv_template
```
