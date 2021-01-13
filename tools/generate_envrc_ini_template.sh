#!/usr/bin/env bash
# """Generate template of `.envrc.ini` file from module documentation
#
# SYNOPSIS:
#
#   ./generate_envrc_ini_template.sh
#
# DESCRIPTION:
#
#   THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.
#
#   For each module scripts in modules folder, extract `.envrc.ini` example in
#   the module docstring and generate file `templates/envrc.template.ini`.
#
# """

generate_envrc_ini()
{
  # """Extract `.envrc.ini` example of each module and write it in `templates/envrc.template.ini`.
  #
  #   For each module scripts in modules folder, extract `.envrc.ini` example in
  #   the module docstring and generate file `templates/envrc.template.ini`.
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

  local output_file=${DIRENV_ROOT}/templates/envrc.template.ini

  cat <<EOM > "${output_file}"
# DIRENV MODULE CONFIGURATION
# ==============================================================================
# DESCRIPTION:
#   Configuration file parsed during activation of direnv (either using \`direnv\`
#   or when sourcing \`.direnv/activate_direnv\`)'

EOM

  for i_module in "${DIRENV_ROOT}"/modules/*.sh
  do
    direnv_log "INFO" \
      "Computing \`.envrc.ini\` template for module **$(basename "${i_module}")**."
    # shellcheck disable=SC2016,SC2026
    # - SC2016: Expression don't expand in single quotes
    # - SC2026: This word (`p`) is outside of quotes
    sed -n -e '/^#   ```ini/,/^#   ```/'p "${i_module}" \
      | sed -e 's/#   //' -e '/^```/d' >> "${output_file}"
    echo "" >> "${output_file}"
  done

  cat <<EOM >> "${output_file}"
# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=dosini
# ------------------------------------------------------------------------------
EOM
}

main()
{
  # """Main method starting the generation of `.envrc.template.ini`
  #
  # Ensure directory environment is loaded, then load libraries scripts and
  # finally generate the `.envrc.template.ini`.
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

  # Store coloring output prefix
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_error="\e[0;31m"   # red fg

  # Ensure directory environment is activated
  if [[ -z "${DIRENV_ROOT}" ]]
  then
    # Not using direnv_log as directory environment is not loaded yet
    echo -e "${e_error}[ERROR] Direnv must be activated to use this script.${e_normal}"
    return 1
  fi

  # Sourcing directory environment libraries scripts
  for i_lib in "${DIRENV_ROOT}"/lib/*.sh
  do
    # shellcheck source=./lib/direnv_log.sh
    source "${i_lib}"
  done

  generate_envrc_ini
}

main

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
