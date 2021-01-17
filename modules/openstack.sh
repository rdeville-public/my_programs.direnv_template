#!/usr/bin/env bash
# """Export openstack variables for python openstackclient
#
# DESCRIPTION:
#   Export variables `OS_*` required to be able to connect to openstack via
#   python openstack client.
#
#   `OS_*` variables are obtains with the `openrc.sh` file you can get from your
#   openstack instance.
#
#   Also setup a script to easily manage multiple openstack project within the
#   same directory. This is done directly in the `.envrc.ini` file using
#   `[openstack]` section to define the default project (used only during the
#   initialisation of the directory environment) then using
#   `[openstack:project_name]` section to configure per project openstack
#   variable.
#
#   The setup of the script is a symlink from `.direnv/src/select_openstack.sh`
#   to `.direnv/bin/select_openstack` allowing you to use command
#   `select_openstack`. This command will ask you which project you want to
#   activate.
#
#   If you want to hide some values in `.envrc.ini`, such as `OS_PASSWORD`, you
#   can start the value of this variable to `cmd:` followed by a command which
#   echo the content of the password. For instance `cmd:cat file_storing_os_password`
#
#   REMARK: There is not default value set for any `OS_*` variable.
#
#   Parameters in `.envrc.ini` are:
#
#   <center>
#
#   | Name                       | Description                                     |
#   | :------------------------- | :---------------------------------------------- |
#   | `default`                  | Name of the default openstack project           |
#   | `OS_AUTH_URL`              | Value of `OS_AUTH_URL` in openrc.sh             |
#   | `OS_PROJECT_ID`            | Value of `OS_PROJECT_ID` in openrc.sh           |
#   | `OS_PROJECT_NAME`          | Value of `OS_PROJECT_NAME` in openrc.sh         |
#   | `OS_INTERFACE`             | Value of `OS_INTERFACE` in openrc.sh            |
#   | `OS_REGION_NAME`           | Value of `OS_REGION_NAME` in openrc.sh          |
#   | `OS_IDENTITY_API_VERSION`  | Value of `OS_IDENTITY_API_VERSION` in openrc.sh |
#   | `OS_USER_DOMAIN_NAME`      | Value of `OS_USER_DOMAIN_NAME` in openrc.sh     |
#   | `OS_USERNAME`              | Value of `OS_USERNAME` in openrc.sh             |
#   | `OS_PASSWORD`              | Password to connect to the openstack` instance  |
#
#   </center>
#
#   ## Parameters
#
#   ###  `default`
#
#   Name of the default openstack project used during the first initialisation
#   of the directory environment. The current configured project will be saved
#   into `.direnv/tmp/openstack.envrc`. When updating current project, using
#   script `select_openstack`, value of `.direnv/tmp/openstack.envrc` will be
#   updated.
#
#   ### `OS_AUTH_URL`
#
#   Value of openstack variable OS_AUTH_URL in openrc.sh. Usually, the HTTPS URL
#   of your openstack instance.
#
#   ### `OS_PROJECT_ID`
#
#   Value of openstack variable OS_PROJECT_ID in openrc.sh Usually a hash
#   composed of alpha numerical characters.
#
#   ### `OS_PROJECT_NAME`
#
#   Value of openstack variable OS_PROJECT_NAME in openrc.sh.
#
#   ### `OS_INTERFACE`
#
#   Value of openstack variable OS_INTERFACE in openrc.sh.
#
#   ### `OS_REGION_NAME`
#
#   Value of openstack variable OS_REGION_NAME in openrc.sh.
#
#   ### `OS_IDENTITY_API_VERSION`
#
#   Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh.
#
#   ### `OS_USER_DOMAIN_NAME`
#
#   Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh.
#
#   ### `OS_USERNAME`
#
#   Value of openstack variable OS_USERNAME in openrc.sh.
#
#   ### `OS_PASSWORD`
#
#   Password to connect to the openstack instance.
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Openstack module
#   # ------------------------------------------------------------------------------
#   # Manage openstack environment variable. Main section [openstack] have only one
#   # parameter `default` to define default openstack project configuration name.
#   # Use section of the form [openstack:project_config_name_1] to define variable
#   # per project configuration name.
#   # **REMARK**: VALUE OF `default` MUST BE THE SAME VALUE OF A SUBSECTION AS SHOWN
#   # BELOW:
#   # ```
#   # [openstack]
#   # default=project_config_name_1
#   #
#   # [openstack:project_config_name_1]
#   # OS_AUTH_URL=https://test.com
#   # ...
#   # ```
#   [openstack]
#   # Default project configuration name when activating the direnv for the first
#   # time
#   # NO DEFAULT VALUE
#   default=project_config_name_1

#   # Configuration for each openstack project
#   [openstack:project_config_name_1]
#   # Value of openstack variable OS_AUTH_URL in openrc.sh
#   OS_AUTH_URL=https://test.com
#   # Value of openstack variable OS_PROJECT_ID in openrc.sh
#   OS_PROJECT_ID=1234
#   # Value of openstack variable OS_PROJECT_NAME in openrc.sh
#   OS_PROJECT_NAME=project_name_1
#   # Value of openstack variable OS_USERNAME in openrc.sh
#   OS_USERNAME=username
#   # Value of openstack variable OS_PASSWORD in openrc.sh, to avoid setup a value
#   # in clear text, as for any other value in this ini file, start the value with
#   # `cmd:` to tell the parser that value will be obtain by executing the command
#   # specified after `¢md:`. In the example below, parser will execute command
#   # `echo "foo"`, so value of OS_PASSWORD will be `foo`
#   OS_PASSWORD=cmd:echo "foo"
#   # Value of openstack variable OS_INTERFACE in openrc.sh
#   OS_INTERFACE=interface
#   # Value of openstack variable OS_REGION_NAME in openrc.sh
#   OS_REGION_NAME=region_name
#   # Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh
#   OS_IDENTITY_API_VERSION=3
#   # Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh
#   OS_USER_DOMAIN_NAME=domain_name

#   # Configuration for each openstack project
#   [openstack:project_config_name_2]
#   # Value of openstack variable OS_AUTH_URL in openrc.sh
#   OS_AUTH_URL=https://test.com
#   # Value of openstack variable OS_PROJECT_ID in openrc.sh
#   OS_PROJECT_ID=4321
#   # Value of openstack variable OS_PROJECT_NAME in openrc.sh
#   OS_PROJECT_NAME=project_name_2
#   # Value of openstack variable OS_USERNAME in openrc.sh
#   OS_USERNAME=username
#   # Value of openstack variable OS_PASSWORD in openrc.sh, to avoid setup a value
#   # in clear text, as for any other value in this ini file, start the value with
#   # `cmd:` to tell the parser that value will be obtain by executing the command
#   # specified after `¢md:`. In the example below, parser will execute command
#   # `echo "bar"`, so value of OS_PASSWORD will be `bar`
#   OS_PASSWORD=cmd:echo "bar"
#   # Value of openstack variable OS_INTERFACE in openrc.sh
#   OS_INTERFACE=interface
#   # Value of openstack variable OS_REGION_NAME in openrc.sh
#   OS_REGION_NAME=region_name
#   # Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh
#   OS_IDENTITY_API_VERSION=3
#   # Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh
#   OS_USER_DOMAIN_NAME=domain_name
#   ```
#
# """

# shellcheck disable=SC2154
#   - SC2154: Variable is referenced but not assigned
openstack()
{
  # """Export variables for openstack module
  #
  # Export every `OS_*` variables required to communicate with your openstack
  # instance. Also setup a symlink from `.direnv/src/select_openstack.sh` to
  # `.direnv/bin/select_openstack` to make script select_openstack available as
  # a command
  #
  # Value of `OS_*` will depend on the current project set in
  # `.direnv/tmp/openstack.envrc` which can be updated manually or using command
  # `select_openstack`
  #
  # Globals:
  #   OS_PROJECT_ID
  #   OS_PROJECT_NAME
  #   OS_AUTH_URL
  #   OS_USER_DOMAIN_NAME
  #   OS_USERNAME
  #   OS_PASSWORD
  #   OS_REGION_NAME
  #   OS_INTERFACE
  #   OS_IDENTITY_API_VERSION
  #
  # Arguments:
  #   None
  #
  # Output:
  #   None
  #
  # Returns:
  #   1 if some openstack required variables are not defined
  #   0 if the module is correctly loaded
  #
  # """

  install_openstack_script()
  {
    # """Install openstack script to select the current project
    #
    # Install a symlink from `.direnv/src/select_openstack.sh` to
    # `.direnv/bin/select_openstack` to be able to use script to easily change
    # current openstack project and so update the `OS_*` exported variables.
    #
    # Globals:
    #   DIRENV_BIN_FOLDER
    #   DIRENV_SRC_FOLDER
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

    if ! [[ -e "${DIRENV_BIN_FOLDER}/select_openstack" ]]
    then
      ln -s "${DIRENV_SRC_FOLDER}/select_openstack.sh" "${DIRENV_BIN_FOLDER}/select_openstack"
    fi
  }

  save_default_openstack_config()
  {
    # """Save the default openstack configuration name during first init
    #
    # If default openstack project is defined in `.envrc.ini`, save the name of
    # this configuration into `.direnv/tmp/openstack.envrc`.
    #
    # Globals:
    #   DIRENV_TEMP_FOLDER
    #
    # Arguments:
    #   $1: string, name of the default openstack project
    #
    # Output:
    #   Name of the current openstack project
    #
    # Returns:
    #   None
    #
    # """

    local openstack_project_file="${DIRENV_TEMP_FOLDER}/openstack.envrc"
    local openstack_default_project=$1

    if [[ -n "${openstack_default_project}" ]]
    then
      if ! [[ -f "${openstack_project_file}" ]]
      then
        echo "${openstack_default_project}" >> "${openstack_project_file}"
      fi
    fi
    cat "${openstack_project_file}"
  }

  eval_openstack_var()
  {
    # """Ensure required openstack variables are defined
    #
    # For every `OS_*` variables required, ensure their values are set.
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
    local i_var_name_upper
    local i_var_value

    for i_var_name in "os_auth_url" "os_user_domain_name" "os_username" \
                      "os_password" "os_region_name" "os_interface" \
                      "os_identity_api_version" "os_project_id" "os_project_name"
    do
      # Not using ${var,,} or ${var^^} to ensure ZSH compatibility
      i_var_name_upper="$(echo ${i_var_name} | tr '[:lower:]' '[:upper:]' )"
      # shellcheck disable=SC2154
      #   - SC2154: Variable is referenced but not assigned
      i_var_value="${openstack[${default_project},${i_var_name_upper}]}"

      if [[ -z "${i_var_value}" ]]
      then
        direnv_log "ERROR" "Variable \`${i_var_name_upper}\` should be set in .envrc.ini."
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

  local default_project="${openstack[default]}"

  install_openstack_script
  default_project=$(save_default_openstack_config "${default_project}")
  eval_openstack_var || return 1

  # Export openstack variables
  export OS_PROJECT_ID=${os_project_id}
  export OS_PROJECT_NAME=${os_project_name}
  export OS_AUTH_URL=${os_auth_url}
  export OS_USER_DOMAIN_NAME=${os_user_domain_name}
  export OS_USERNAME=${os_username}
  export OS_PASSWORD=${os_password}
  export OS_REGION_NAME=${os_region_name}
  export OS_INTERFACE=${os_interface}
  export OS_IDENTITY_API_VERSION=${os_identity_api_version}
}


deactivate_openstack()
{
  # """Unset exported variables for openstack module
  #
  # Unset every `OS_*` variables previously exported.
  #
  # Globals:
  #   OS_PROJECT_ID
  #   OS_PROJECT_NAME
  #   OS_AUTH_URL
  #   OS_USER_DOMAIN_NAME
  #   OS_USERNAME
  #   OS_PASSWORD
  #   OS_REGION_NAME
  #   OS_INTERFACE
  #   OS_IDENTITY_API_VERSION
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

  unset OS_PROJECT_ID
  unset OS_PROJECT_NAME
  unset OS_AUTH_URL
  unset OS_USER_DOMAIN_NAME
  unset OS_USERNAME
  unset OS_PASSWORD
  unset OS_REGION_NAME
  unset OS_INTERFACE
  unset OS_IDENTITY_API_VERSION
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
