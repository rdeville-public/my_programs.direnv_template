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
#   | Name                                | Description                                                                                                                                 |
#   | :-------------                      | :----------------------------------------------------                                                                                       |
#   | `session_name`                      | Name of the tmux session                                                                                                                    |
#   | `tmuxinator_on_project_start`       | (OPTIONAL) Runs on project start, always                                                                                                    |
#   | `tmuxinator_on_project_first_start` | Run on project start, the first time                                                                                                        |
#   | `tmuxinator_on_project_restart`     | (OPTIONAL) Run on project start, after the first time                                                                                       |
#   | `tmuxinator_on_project_exit`        | (OPTIONAL) Run on project exit ( detaching from tmux session )                                                                              |
#   | `tmuxinator_on_project_stop`        | (OPTIONAL) Run on project stop                                                                                                              |
#   | `tmuxinator_pre_window=command`     | (OPTIONAL) Runs in each window and pane before window/pane specific commands                                                                |
#   | `tmuxinator_tmux_options`           | (OPTIONAL) Pass command line options to tmux.                                                                                               |
#   | `tmuxinator_tmux_command`           | (OPTIONAL) Change the command to call tmux.                                                                                                 |
#   | `tmuxinator_startup_window`         | (OPTIONAL) Specifies (by name or index) which window will be selected on project startup. If not set, the first window is used.             |
#   | `tmuxinator_startup_pane`           | (OPTIONAL) Specifies (by index) which pane of the specified window will be selected on project startup. If not set, the first pane is used. |
#   | `tmuxinator_attach`                 | (OPTIONAL) Controls whether the tmux session should be attached to automatically.                                                           |
#   | `tmuxinator_templates`              | (OPTIONAL) Template to setup tmux windows as well as some predefined tmuxinator options                                                     |
#
#   </center>
#
#   ## Parameters
#
#   ### `session_name`
#
#   Name of the tmux session, i.e. name that will be shown when using the
#   command `tmux list-sessions`. If not set, the session name will be the
#   directory name.
#
#   ### `tmuxinator_on_project_start`
#
#   (OPTIONAL)
#
#   Set the configuration `on_project_start` of `.tmuxinator.yaml`. This set the
#   command runs on project start, always.
#
#   ### `tmuxinator_on_project_first_start`
#
#   (OPTIONAL)
#
#   Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
#   command runs on project start, the first time.
#
#   ### `tmuxinator_on_project_restart`
#
#   (OPTIONAL)
#
#   Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
#   command runs on project start, after the first time.
#
#   ### `tmuxinator_on_project_exit`
#
#   (OPTIONAL)
#
#   Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
#   command run on project exit (detaching from tmux session).
#
#   ### `tmuxinator_on_project_stop`
#
#   (OPTIONAL)
#
#   Set the configuration `on_project_restart` of `.tmuxinator.yaml`. This set the
#   command run on project stop.
#
#   ### `tmuxinator_pre_window=command`
#
#   (OPTIONAL)
#
#   Set the configuration `pre_window` of `.tmuxinator.yaml`. This set the
#   command runs in each window and pane before window/pane specific commands.
#   Useful for setting up interpreter versions.
#
#   ### `tmuxinator_tmux_options`
#
#   (OPTIONAL)
#
#   Set the configuration `tmux_options` of `.tmuxinator.yaml`. This set the
#   option to pass to the tmux command. Useful for specifying a different
#   tmux.conf.
#
#   ### `tmuxinator_tmux_command`
#
#   (OPTIONAL)
#
#   Set the configuration `tmux_command` of `.tmuxinator.yaml`. This set the
#   command called to run tmux. This can be used by derivatives/wrappers
#   like byobu.
#
#   Change the command to call tmux.
#
#   ### `tmuxinator_startup_window`
#
#   Set the configuration `startup_window` of `.tmuxinator.yaml`. This
#   specifies (by name or index) which window will be selected on project
#   startup. If not set, the first window is used.
#
#   ### `tmuxinator_startup_pane`
#
#   Set the configuration `startup_pane` of `.tmuxinator.yaml`. This
#   specifies (by index) which pane of the specified window will be selected on
#   project startup. If not set, the first pane is used. #
#
#   ### `tmuxinator_attach`
#
#   Set the configuration `attach` of `.tmuxinator.yaml`. This controls whether the
#   tmux session should be attached to automatically.
#
#   ### `tmuxinator_templates`
#
#   Automatically set `windows` key of the `.tmuxinator.yaml` file as well as some
#   other keys. Available templates are folders in
#   `${DIRENV_ROOT}/templates/tmuxinator`. Content of key `windows` is
#   `${DIRENV_ROOT}/templates/tmuxinator/${tmuxinator_templates}/windows.yaml`
#   and content of other keys which have configuration updated are in
#  `${DIRENV_ROOT}/templates/tmuxinator/${tmuxinator_templates}/${config_key}.sh`
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
#   # Setting individual tmuxinator configuration
#   # Runs on project start, always
#   tmuxinator_on_project_start=command
#   # Run on project start, the first time
#   tmuxinator_on_project_first_start=command
#   # Run on project start, after the first time
#   tmuxinator_on_project_restart=command
#   # Run on project exit (detaching from tmux session)
#   tmuxinator_on_project_exit=command
#   # Run on project stop
#   tmuxinator_on_project_stop=command
#   # Runs in each window and pane before window/pane specific commands.
#   # Useful for setting up interpreter versions.
#   tmuxinator_pre_window=command
#   # Pass command line options to tmux. Useful for specifying a different
#   # tmux.conf.
#   tmuxinator_tmux_options=option
#   # Change the command to call tmux. This can be used by derivatives/wrappers
#   # like byobu.
#   tmuxinator_tmux_command=byobu
#   # Specifies (by name or index) which window will be selected on project startup.
#   # If not set, the first window is used.
#   tmuxinator_startup_window=window_name
#   # Specifies (by index) which pane of the specified window will be selected on
#   # project startup. If not set, the first pane is used.
#   tmuxinator_startup_pane=pane
#   # Controls whether the tmux session should be attached to automatically.
#   # Defaults to true.
#   tmuxinator_attach=true
#   # Template to setup tmux windows as well as some predefined tmuxinator
#   # options
#   tmuxinator_templates=template_1
#   tmuxinator_templates=template_2
#   ```
#
# """

_tmux_management_generate_tmuxinator_config()
{
  # """Generate and write the full content of file `.tmuxinator.yaml`
  #
  # Write content of `.tmuxinator.yaml` from `tmuxinator_config` variables set
  # previously.
  #
  # Globals:
  #   DIRENV_ROOT
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

  cat <<EOM > "${DIRENV_ROOT}/.tmuxinator.yml"
# Main config
# -----------------------------------------------------------------------------

# Name of the project
name: ${tmux_session}

# Path of the project
# root: ./

# Project hooks
# -----------------------------------------------------------------------------

# Runs on project start, always
${tmuxinator_config[on_project_start]}

# Run on project start, the first time
${tmuxinator_config[on_project_first_start]}

# Run on project start, after the first time
${tmuxinator_config[on_project_restart]}

# Run on project exit ( detaching from tmux session )
${tmuxinator_config[on_project_exit]}

# Run on project stop
${tmuxinator_config[on_project_stop]}

# Runs in each window and pane before window/pane specific commands.
# Useful for setting up interpreter versions.
${tmuxinator_config[pre_window]}

# Pass command line options to tmux. Useful for specifying a different
# tmux.conf.
${tmuxinator_config[tmux_options]}

# Change the command to call tmux.  This can be used by derivatives/wrappers
# like byobu.
${tmuxinator_config[tmux_command]}

# Specifies (by name or index) which window will be selected on project startup.
# If not set, the first window is used.
${tmuxinator_config[startup_window]}

# Specifies (by index) which pane of the specified window will be selected on
# project startup. If not set, the first pane is used.
${tmuxinator_config[startup_pane]}

# Controls whether the tmux session should be attached to automatically.
# Defaults to true.
${tmuxinator_config[attach]}

${tmuxinator_config[windows]}
EOM
}

_tmux_management_generate_tmuxinator_windows()
{
  # """Generate content of key `windows` in `.tmuxinator.yaml`
  #
  # From config key `tmuxinator_templates` in `.envrc.ini`, generate the content
  # of the key `windows` that will be put in `.tmuxinator.yaml`
  #
  # Globals:
  #   ZSH_VERSION
  #   DIRENV_INI_SEP
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Content of the key `windows`
  #
  # Returns:
  #   None
  #
  # """

  local key="windows"
  local tmuxinator_templates_array
  local content=""

  # shellcheck disable=SC2154
  #   - SC2154: Variable is referenced but not assigned
  if [[ -n "${tmux_management[tmuxinator_templates]}" ]]
  then
    if [[ -n "${ZSH_VERSION}" ]]
    then
      IFS="${DIRENV_INI_SEP}" read -r -A tmuxinator_templates_array \
        <<< "${tmux_management[tmuxinator_templates]}"
    else
      IFS="${DIRENV_INI_SEP}" read -r -a tmuxinator_templates_array \
        <<< "${tmux_management[tmuxinator_templates]}"
    fi
  fi
  if [[ ${#tmuxinator_templates_array[@]} -gt 0 ]]
  then
    for i_template in "${tmuxinator_templates_array[@]}"
    do
      tmuxinator_templates_folder="${DIRENV_TEMPLATE_FOLDER}/tmuxinator/${i_template}"
      tmuxinator_templates_file="${tmuxinator_templates_folder}/${key}.yaml"
      if ! [[ -d "${tmuxinator_templates_folder}" ]]
      then
        direnv_log "ERROR" "Template \`${i_template}\` does not exists."
        error="true"
      elif [[ -f "${tmuxinator_templates_file}" ]]
      then
        content+="$(cat "${tmuxinator_templates_file}")\n"
      fi
    done
    if [[ -z "${content}" ]]
    then
      content="# ${key}: command"
    else
      content="${key}: \n${content}"
    fi
  else
    content="# ${key}: "
  fi
  echo -e "${content}"
}

_tmux_management_generate_tmuxinator_singleline_keys()
{
  # """Generate content of option which value can only be a single line
  #
  # From provided `key` as first parameter, generate the content of the
  # corresponding `key` that will be written in `.tmuxinator.yaml`.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   $1: string, name of the key that will be set in `.tmuxinator.yaml`
  #
  # Output:
  #   The content of the `key that will be written in `.tmuxinator.yaml`
  #
  # Returns:
  #   None
  #
  # """

  local error="false"
  local key="$1"
  local array_key="tmuxinator_${key}"
  local tmuxinator_config
  local content

  if [[ -n "${tmux_management[${array_key}]}" ]]
  then
    echo "${key}: ${tmux_management[${array_key}]}"
  else
    echo "# ${key}: "
  fi
}

_tmux_management_generate_tmuxinator_multiline_keys()
{

  # """Generate content of option which value can be a multiline
  #
  # From provided `key` as first parameter, generate the content of the
  # corresponding `key` that will be written in `.tmuxinator.yaml`.
  #
  # Globals:
  #   ZSH_VERSION
  #   DIRENV_INI_SEP
  #
  # Arguments:
  #   $1: string, name of the key that will be set in `.tmuxinator.yaml`
  #
  # Output:
  #   The content of the `key that will be written in `.tmuxinator.yaml`
  #
  # Returns:
  #   1 if an error occurs, i.e. templates does not exists
  #   0 if everything went right
  #
  # """

  local error="false"
  local key="$1"
  local array_key="tmuxinator_${key}"
  local tmuxinator_on_project_key_array
  local tmuxinator_templates_array
  local tmuxinator_templates_file
  local tmuxinator_templates_folder
  local content

  if [[ -n "${tmux_management[${array_key}]}" ]]
  then
    if [[ -n "${ZSH_VERSION}" ]]
    then
      IFS="${DIRENV_INI_SEP}" read -r -A tmuxinator_on_project_key_array \
        <<< "${tmux_management[${array_key}]}"
    else
      IFS="${DIRENV_INI_SEP}" read -r -a tmuxinator_on_project_key_array \
        <<< "${tmux_management[${array_key}]}"
    fi
    if [[ ${#tmuxinator_on_project_key_array[@]} -gt 1 ]]
    then
      for i_cmd in "${tmuxinator_on_project_key_array[@]}"
      do
        content+="  ${i_cmd}\n"
      done
    else
      content="${key}: ${tmuxinator_on_project_key_array[*]}"
    fi
  fi

  if [[ -n "${tmux_management[tmuxinator_templates]}" ]]
  then
    if [[ -n "${ZSH_VERSION}" ]]
    then
      IFS="${DIRENV_INI_SEP}" read -r -A tmuxinator_templates_array \
        <<< "${tmux_management[tmuxinator_templates]}"
    else
      IFS="${DIRENV_INI_SEP}" read -r -a tmuxinator_templates_array \
        <<< "${tmux_management[tmuxinator_templates]}"
    fi
    if [[ ${#tmuxinator_templates_array[@]} -gt 0 ]]
    then
      for i_template in "${tmuxinator_templates_array[@]}"
      do
        tmuxinator_templates_folder="${DIRENV_TEMPLATE_FOLDER}/tmuxinator/${i_template}"
        tmuxinator_templates_file="${tmuxinator_templates_folder}/${key}.sh"
        if ! [[ -d "${tmuxinator_templates_folder}" ]]
        then
          direnv_log "ERROR" "Template \`${i_template}\` does not exists."
          error="true"
        elif [[ -f "${tmuxinator_templates_file}" ]]
        then
          content+="$(cat "${tmuxinator_templates_file}")"
        fi
      done
    fi
  fi

  if [[ -z "${content}" ]]
  then
    content="# ${key}: command"
  else
    content="${key}: >-\n${content}"
  fi
  echo -e "${content}"

  if [[ "${error}" == "true" ]]
  then
    return 1
  fi
  return 0
}

_tmux_management_generate_tmuxinator()
{
  # """Generate .tmuxinator.yml from template
  #
  # If `.tmuxinatory.yml` file does not exists and depending on provided
  # `tmuxinator_*` variables in .envrc.ini generate `.tmuxinator.yml` file
  # at the root of the direnv repo.
  # Once file exist, load tmuxinator config
  #
  # Globals:
  #   DIRENV_ROOT
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

  local tmuxinator_config
  declare -A tmuxinator_config

  if ! [[ -f "${DIRENV_ROOT}/.tmuxinator.yml" ]]
  then
    for i_config in on_project_start \
                    on_project_first_start \
                    on_project_restart \
                    on_project_exit \
                    on_project_stop \
                    pre_window
    do
      tmuxinator_config[${i_config}]=$(\
        _tmux_management_generate_tmuxinator_multiline_keys "${i_config}"\
        ) || return 1
    done
    for i_config in tmux_options \
                    tmux_command \
                    startup_window \
                    startup_pane \
                    attach
    do
      tmuxinator_config[${i_config}]=$(\
        _tmux_management_generate_tmuxinator_singleline_keys "${i_config}"\
        ) || return 1
    done
    tmuxinator_config[windows]=$(\
      _tmux_management_generate_tmuxinator_windows \
      ) || return 1
    _tmux_management_generate_tmuxinator_config
  fi
}

tmux_management()
{
  # """Automatically create and/or attach a tmux session, may be done using tmuxinator
  #
  # Automatically create a tmux session if session does not exists yet. Session
  # name can be user defined or automatically set to the name of the directory.
  # If user provided tmuxinator configuration, generate `.tmuxinator.yaml` file
  # at `${DIRENV_ROOT}` based on user defined configuration in `.envrc.ini`.
  #
  # Once tmux session is created or if already existing, attach terminal to the
  # tmux session.
  #
  # Globals:
  #   DIRENV_ROOT
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

  if command -v tmuxinator &> /dev/null \
     && grep -q -e "^tmuxinator_.*=" ${DIRENV_ROOT}/.envrc.ini
  then
    _tmux_management_generate_tmuxinator || return 1
    tmuxinator start
  else
    # Check if tmux session already exists
    if ! tmux list-sessions &> /dev/null || ! tmux list-sessions | grep -q -E "^${tmux_session}:"
    then
      tmux new-session -d -s "${tmux_session}"
    fi
    # Check if inside a tmux session
    if [[ -n "${TMUX}" ]]
    then
      tmux switch-client -t "${tmux_session}"
    else
      tmux attach -t "${tmux_session}"
    fi
  fi
}
