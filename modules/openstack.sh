#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

# OPENSTACK RELATED VARIABLES
# ------------------------------------------------------------------------------
# Check if the OpenStack project is defined in .direnv/.openstack.envrc.
# If the file does not exists, run the script .direnv/bin/set_os_env which will
# ask the user which OpenStack project to use.
# YOU NEED TO REGISTER OPENSTACK PROJECT YOU WANT TO USE IN
# .direnv/vars/openstack_projects.sh for the script .direnv/bin/set_os_env to be
# able to work.

install_openstack_script()
{
  if ! [ -e "${DIRENV_BIN_FOLDER}/select_openstack" ]
  then
    ln -s "${DIRENV_SRC_FOLDER}/select_openstack.sh" "${DIRENV_BIN_FOLDER}/select_openstack"
  fi
}

remove_openstack_script()
{
  if [ -e "${DIRENV_BIN_FOLDER}/select_openstack" ]
  then
    rm -f "${DIRENV_BIN_FOLDER}/select_openstack"
  fi
}

save_default_openstack_config()
{
  local openstack_project_file="${DIRENV_TEMP_FOLDER}/openstack.envrc"
  local openstack_default_project=$1

  if [ -n "${openstack_default_project}" ]
  then
    if ! [ -f "${openstack_project_file}" ]
    then
      echo "${openstack_default_project}" >> "${openstack_project_file}"
    fi
  fi
  cat "${openstack_project_file}"
}

eval_openstack_var()
{
  local error="false"
  local i_var_name
  local i_var_name_upper
  local i_var_value

  for i_var_name in "os_auth_url" "os_user_domain_name" "os_username" \
                    "os_password" "os_region_name" "os_interface" \
                    "os_identity_api_version" "os_project_id" "os_project_name"
  do
    i_var_name_upper="$(echo ${i_var_name} | tr '[:lower:]' '[:upper:]' )"
    # shellcheck disable=SC2154
    #   - SC2154: Variable is referenced but not assigned
    i_var_value="${openstack[${openstack_default_project},${i_var_name_upper}]}"
    if [[ -z "${i_var_value}" ]]
    then
      direnv_log "ERROR" "Variable \`${i_var_name_upper}\` should be set in .envrc.ini."
      error="true"
    fi
    # shellcheck disable=SC2116
    #   - SC2116: Useless echo ?
    eval "$(echo "${i_var_name}=\"${i_var_value}\"")"
  done
  if [ "${error}" = "true" ]
  then
    return 1
  fi
}

# shellcheck disable=SC2154
#   - SC2154: Variable is referenced but not assigned
openstack()
{
  local openstack_default_project="${openstack[default]}"

  install_openstack_script
  openstack_default_project=$(save_default_openstack_config "${openstack_default_project}")
  eval_openstack_var || return 1

  # Setup general OpenStack variables, usually in openrch.sh file.
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
  unset OS_PROJECT_ID
  unset OS_PROJECT_NAME
  unset OS_AUTH_URL
  unset OS_USER_DOMAIN_NAME
  unset OS_USERNAME
  unset OS_PASSWORD
  unset OS_REGION_NAME
  unset OS_INTERFACE
  unset OS_IDENTITY_API_VERSION
  remove_openstack_script
}
