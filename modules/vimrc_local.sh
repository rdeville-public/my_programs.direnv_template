#!/usr/bin/env bash
# """Setup a `.vimrc.local` file at the root of the directory
#
# DESCRIPTION:
#
#   From file `.direnv/templates/vimrc.template.local` and provided variables in
#   `.envrc.ini` create `.vimrc.local` file which defines some configuration
#   vim configuration local to the repo.
#
#   !!! important
#       To be able to use this module you will need to add following lines in
#       your `.vimrc`:
#
#       ```vim
#       if filereadable(".vimrc.local")
#         source .vimrc.local
#       endif
#       ```
#
#   !!! important
#       This module also requires you to install some vim plugins with your
#       favorite vim plugins manager:
#
#       - [vim-glissues](https://github.com/sirjofri/vim-glissues)<br>
#         Vim gitlab issues.
#
#   Parameters in `.envrc.ini` are:
#
# | Name                    | Description                                                                         |
# | :---------------------- | :---------------------------------------------------------------------------------- |
# | `vim_gitlab_token`      | Gitlab API access token                                                             |
# | `vim_gitlab_server`     | URL to your gitlab server                                                           |
# | `vim_gitlab_project_id` | ID of your project in your gitlab server                                            |
# | `vim_gitlab_alter`      | (optional) Should the plugin send altering requests to the server? (default `true`) |
# | `vim_gitlab_debug`      | (optional) Print debug message (default `false`)                                    |
#
#
#   ## Parameters
#
#   ### `vim_gitlab_token`
#
#   The API access token with at least `read_only` access to be able to access
#   issues from all projects and groups. To avoid showing its value in your
#   `.envrc.ini`, as for all value, you can use `cmd:` prefix to specify a
#   command to retrieve the API token.
#
#   ### `vim_gitlab_server`
#
#   The URL of your gitlab server of the form `http(s)://domain.tld`.
#
#   ### `vim_gitlab_project_id`
#
#   The ID of your project in your gitlab server. Normally, `vim-glissues`
#   plugin should be able to determine it automatically, but I encountered
#   issues with this. So it is better to set it manuall.
#
#   ### `vim_gitlab_alter`
#
#   Boolean, default `true`, to tell if the `vim-glissues` plugin should alter
#   requests to the server.
#
#   ### `vim_gitlab_debug`
#
#   Boolean, default `false`, to tell if the `vim-glissues` plugin should print
#   debug information.
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # vimrc_local module
#   # ------------------------------------------------------------------------------
#   # Write a `.vimrc.local` file at the root of the directory
#   [vimrc_local]
#   # Gitlab API access token
#   vim_gitlab_token=cmd: cat my_file_with_api_token
#   # URL to your gitlab server
#   vim_gitlab_server=https://my.gitlab.tld
#   # ID of your project in your gitlab server
#   vim_gitlab_project_id=12345
#   # (optional) Should the plugin send altering requests to the server? (default `true`)
#   vim_gitlab_alter=true
#   # (optional) Print debug message (default `false`)
#   vim_gitlab_debug=false
#   ```
#
# """

vimrc_local()
{
  # """Generate `.vimrc.local` file
  #
  # Generate a `.vimrc.local` file from `.envrc.ini` which defines some
  # local vim configuration.
  #
  # Globals:
  #   DIRENV_ROOT
  #   DIRENV_TEMPLATE_FOLDER
  #
  # Arguments:
  #   None
  #
  # Output:
  #   None
  #
  # Returns:
  #   1 if some vimrc_local required variables are not defined
  #   0 if the module is correctly loaded
  #
  # """

  eval_vimrc_local_var()
  {
    # """Ensure required vimrc_local variables are defined
    #
    # For every vimrc_local variables required, ensure their values are set.
    #
    # REMARK: This method does not test their validity.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Error information if a variable is not defined.
    #
    # Returns:
    #   1 if at least one variable is not defined
    #   0 if every variables are defined
    #
    # """
    local error="false"
    local i_var_name
    local i_var_value

    for i_var_name in "vim_gitlab_token" "vim_gitlab_server" \
                      "vim_gitlab_project_id"
    do
      # shellcheck disable=SC2154
      #   - SC2154: Variable is referenced but not assigned
      i_var_value="${vimrc_local[${i_var_name}]}"

      if [[ -z "${i_var_value}" ]]
      then
        direnv_log "ERROR" "Variable \`${i_var_name}\` should be set in .envrc.ini."
        error="true"
      fi
      # shellcheck disable=SC2116
      #   - SC2116: Useless echo ?
      eval "$(echo "${i_var_name}=\"${i_var_value}\"")"
    done

    if [[ "${error}" == "true" ]]
    then
      return 1
    fi
  }


  local vim_gitlab_token="${vimrc_local[vim_gitlab_token]}"
  local vim_gitlab_server="${vimrc_local[vim_gitlab_server]}"
  local vim_gitlab_project_id="${vimrc_local[vim_gitlab_project_id]}"
  local vim_gitlab_alter="${vimrc_local[vim_gitlab_alter]:=true}"
  local vim_gitlab_debug="${vimrc_local[vim_gitlab_debug]:=false}"
  local template_file="${DIRENV_TEMPLATE_FOLDER}/vimrc.template.local"
  local output_file="${DIRENV_ROOT}/.vimrc.local"

  eval_vimrc_local_var

  # Ensure that .vimrc.local configuration files exists, if not initialize it from
  # template and inform the user.
  if ! [[ -f "${output_file}" ]]
  then
    direnv_log "INFO" \
      "Creation of file **${output_file//${DIRENV_ROOT}\/}**."
    direnv_log "INFO" \
      "This file will be based on **${template_file//${DIRENV_ROOT}\/}**."

    sed -e "s|<TPL:VIM_GITLAB_TOKEN>|${vim_gitlab_token}|g" \
        -e "s|<TPL:VIM_GITLAB_SERVER>|${vim_gitlab_server}|g" \
        -e "s|<TPL:VIM_GITLAB_PROJECT_ID>|${vim_gitlab_project_id}|g" \
        -e "s|<TPL:VIM_GITLAB_ALTER>|${vim_gitlab_alter}|g" \
        -e "s|<TPL:VIM_GITLAB_DEBUG>|${vim_gitlab_debug}|g" \
        "${template_file}" > "${output_file}"
  fi
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
