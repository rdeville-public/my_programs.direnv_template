#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead


install_ansible_script()
{
  if ! [ -e "${DIRENV_BIN_FOLDER}/clone_ansible_roles" ]
  then
    ln -s "${DIRENV_SRC_FOLDER}/clone_ansible_roles.py" "${DIRENV_BIN_FOLDER}/clone_ansible_roles"
  fi
}

remove_ansible_script()
{
  if [ -e "${DIRENV_BIN_FOLDER}/clone_ansible_roles" ]
  then
    rm -f "${DIRENV_BIN_FOLDER}/clone_ansible_roles"
  fi
}


ansible()
{
  # shellcheck disable=SC2154
  #   - SC2514: keepass is referenced but not assigned
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  # ANSIBLE RELATED VARIABLES
  # ------------------------------------------------------------------------------
  # Setup ansible configuration file depending on project (i.e. environment)
  export ANSIBLE_CONFIG="${ansible[ANSIBLE_CONFIG]:-${DIRENV_ROOT}/ansible.cfg}"
  # Ensure that ansible configuration files exists, if not initialize it from
  # template and inform the user.
  if ! [ -f "${ANSIBLE_CONFIG}" ]
  then
    direnv_log "INFO" "Creation of file ${e_bold}${ANSIBLE_CONFIG}${e_normal}."
    direnv_log "INFO" "This file will be based on ${e_bold}${DIRENV_TEMPLATE_DIR}/ansible.cfg.tpl${e_normal}."
    echo "TODO"
    #sed -e "s|<TPL:OS_PROJECT_NAME>|${OS_PROJECT_NAME}|g" \
    #  "${DIRENV_ROOT}/.direnv/bin/templates/ansible.template.cfg" > "${ANSIBLE_CONFIG}"
  fi
  install_ansible_script
}

deactivate_ansible()
{
  unset ANSIBLE_CONFIG
  remove_ansible_script
}
