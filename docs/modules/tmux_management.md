# tmux_management
Start and attach a tmux session

## Description

Automatically create a tmux session if session does not exists yet. Session
name can be user defined or automatically set to the name of the directory.

Once tmux session is created or if already existing, attach terminal to the
tmux session.

User can also define a command to be executed when starting the session.

Parameters in `.envrc.ini` are:

<center>

| Name                                | Description                                                                                                                      |
| :-------------                      | :----------------------------------------------------                                                                            |
| `session_name`                      | Name of the tmux session                                                                                                         |
| `tmuxinator_on_project_start`       | (OPTIONAL) Runs on project start, always                                                                                                    |
| `tmuxinator_on_project_first_start` | Run on project start, the first time                                                                                             |
| `tmuxinator_on_project_restart`     | (OPTIONAL) Run on project start, after the first time                                                                                       |
| `tmuxinator_on_project_exit`        | (OPTIONAL) Run on project exit ( detaching from tmux session )                                                                              |
| `tmuxinator_on_project_stop`        | (OPTIONAL) Run on project stop                                                                                                              |
| `tmuxinator_pre_window=command`     | (OPTIONAL) Runs in each window and pane before window/pane specific commands                                                                |
| `tmuxinator_tmux_options`           | (OPTIONAL) Pass command line options to tmux.                                                                                               |
| `tmuxinator_tmux_command`           | (OPTIONAL) Change the command to call tmux.                                                                                                 |
| `tmuxinator_startup_window`         | (OPTIONAL) Specifies (by name or index) which window will be selected on project startup. If not set, the first window is used.             |
| `tmuxinator_startup_pane`           | (OPTIONAL) Specifies (by index) which pane of the specified window will be selected on project startup. If not set, the first pane is used. |
| `tmuxinator_attach`                 | (OPTIONAL) Controls whether the tmux session should be attached to automatically.                                                           |
| `tmuxinator_templates`              | (OPTIONAL) Template to setup tmux windows as well as some predefined tmuxinator options                                                     |

</center>

## Parameters

### `session_name`

Name of the tmux session, i.e. name that will be shown when using the
command `tmux list-sessions`. If not set, the session name will be the
directory name.

### `tmuxinator_on_project_start`

(OPTIONAL)

Set the configuration `on_project_start` of `.tmuxinator.yaml`. This set the
command runs on project start, always.

### `tmuxinator_on_project_first_start`

(OPTIONAL)

Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
command runs on project start, the first time.

### `tmuxinator_on_project_restart`

(OPTIONAL)

Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
command runs on project start, after the first time.

### `tmuxinator_on_project_exit`

(OPTIONAL)

Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
command run on project exit (detaching from tmux session).

### `tmuxinator_on_project_stop`

(OPTIONAL)

Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
command run on project stop.

### `tmuxinator_pre_window=command`

(OPTIONAL)

Set the configuration `pre_window` of `.tmuxinator.yaml`. This set the
command runs in each window and pane before window/pane specific commands.
Useful for setting up interpreter versions.

### `tmuxinator_tmux_options`

(OPTIONAL)

Set the configuration `tmux_options` of `.tmuxinator.yaml`. This set the
option to pass to the tmux command. Useful for specifying a different
tmux.conf.

### `tmuxinator_tmux_command`

(OPTIONAL)

Set the configuration `tmux_command` of `.tmuxinator.yaml`. This set the
command called to run tmux. This can be used by derivatives/wrappers
like byobu.

Change the command to call tmux.

### `tmuxinator_startup_window`

Set the configuration `startup_window` of `.tmuxinator.yaml`. This
specifies (by name or index) which window will be selected on project
startup. If not set, the first window is used.

### `tmuxinator_startup_pane`

Set the configuration `startup_pane` of `.tmuxinator.yaml`. This
specifies (by index) which pane of the specified window will be selected on
project startup. If not set, the first pane is used. #

### `tmuxinator_attach`

Set the configuration `attach` of `.tmuxinator.yaml`. This controls whether the
tmux session should be attached to automatically.

### `tmuxinator_templates`

Automatically set `windows` key of the `.tmuxinator.yaml` file as well as some
other keys. Available templates are folders in
`${DIRENV_ROOT}/templates/tmuxinator`. Content of key `windows` is
`${DIRENV_ROOT}/templates/tmuxinator/${tmuxinator_templates}/windows.yaml`
and content of other keys which have configuration updated are in
 `${DIRENV_ROOT}/templates/tmuxinator/${tmuxinator_templates}/${config_key}.sh`

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Tmux module
# ------------------------------------------------------------------------------
# Create and/or attach session which name is the directory folder
[tmux_management]
# Override default (folder name) tmux session name
session_name=direnv_template
# Setting individual tmuxinator configuration
# Runs on project start, always
tmuxinator_on_project_start=command
# Run on project start, the first time
tmuxinator_on_project_first_start=command
# Run on project start, after the first time
tmuxinator_on_project_restart=command
# Run on project exit (detaching from tmux session)
tmuxinator_on_project_exit=command
# Run on project stop
tmuxinator_on_project_stop=command
# Runs in each window and pane before window/pane specific commands.
# Useful for setting up interpreter versions.
tmuxinator_pre_window=command
# Pass command line options to tmux. Useful for specifying a different
# tmux.conf.
tmuxinator_tmux_options=option
# Change the command to call tmux. This can be used by derivatives/wrappers
# like byobu.
tmuxinator_tmux_command=byobu
# Specifies (by name or index) which window will be selected on project startup.
# If not set, the first window is used.
tmuxinator_startup_window=window_name
# Specifies (by index) which pane of the specified window will be selected on
# project startup. If not set, the first pane is used.
tmuxinator_startup_pane=pane
# Controls whether the tmux session should be attached to automatically.
# Defaults to true.
tmuxinator_attach=true
# Template to setup tmux windows as well as some predefined tmuxinator
# options
tmuxinator_templates=template_1
tmuxinator_templates=template_2
```
