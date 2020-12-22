#!/bin/bash
# ---------------------------------------------------------------------------
# NAME:
#   set_os_env    Easily choose openstack project to work on.
#
# DESCRIPTION:
#     This script allow to change easily which openstack project variable are
#     loaded when loading the directory environment.
#     It requires that associative array 'os_projects' stored in file
#     .direnv/bin/vars/openstack_projects.sh must be defined !
#     If requirement are not fulfilled print and error and exit.
#     Else, store activated OpenStack project in file .direnv/.openstack.envrc.
#

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

# Determine the absolute script location
OS_CONFIG_NAMES=()
# Ensure user setup its openstack project.
get_project_config_name()
{
  while read -r openstack_config_name
  do
    openstack_config_name="${openstack_config_name//\]/}"
    openstack_config_name="${openstack_config_name//\[/}"
    openstack_config_name=$( echo "${openstack_config_name}" | cut -d ":" -f 2 )
    OS_CONFIG_NAMES+=( "${openstack_config_name}" )
  done <<< "$( grep "openstack:" "${DIRENV_ROOT}/.envrc.ini" )"
}


show_question()
{
  local string="\
Please select the OpenStack project you want to work on:\n"
  for openstack_config_name in "${OS_CONFIG_NAMES[@]}"
  do
    if [[ ${idx} -eq 1 ]]
    then
      string+="  ${idx}) ${openstack_config_name} ${e_bold}[Default]${e_normal}\n"
    else
      string+="  ${idx}) ${openstack_config_name}\n"
    fi
    idx=$(( idx + 1 ))
  done
  string+="Please enter a value ${e_info}${e_bold}between 1 and $(( idx - 1 ))${e_normal} "
  string+="or press ${e_error}Ctrl+C${e_normal} to cancel."
  echo -e "${string}"
}


show_error()
{
  echo -e "${e_error}\
================================================================================
[ERROR] Please choose amoung valid option, i.e. ${e_info}${e_bold}between 1 and $(( ${#OS_CONFIG_NAMES[@]} - 1 ))${e_normal}${e_error}
[ERROR] or press ${e_bold}Ctrl+C${e_normal}${e_error} to cancel.
================================================================================
${e_normal}"
}


show_reload_info()
{
  echo -e "${e_info}\
[INFO] You may need to reload the working environment for the change to take effects.
[INFO]   - Either manually : ${e_bold}'source .direnv/bin/activate_direnv'.${e_normal}${e_info}
[INFO]   - Either with direnv : ${e_bold}'direnv allow'.${e_normal}${e_info}
[INFO] Check the value of variable OS_PROJECT_NAME to be sure.${e_normal}"

}


ask_user_os_config()
{
  idx=1
  show_question
  read -r answer
  # Automatically assign value 1 if user does not enter any value.
  if [[ ${answer:=1} =~ ^-?[0-9]+$ ]] && [[ ${answer:=1} -lt ${idx} ]]
  then
    # If user answered a valid option, find the project to use
    idx=1
    for openstack_config_name in "${OS_CONFIG_NAMES[@]}"
    do
      if [[ ${idx} -ne ${answer} ]]
      then
        idx=$(( idx + 1 ))
      else
        echo "${openstack_config_name}" > "${DIRENV_TEMP_FOLDER}/openstack.envrc"
        break
      fi
    done
  else
    show_error
    answer=0
  fi
}


main()
{
  # COLORING ECHO OUTPUT
  # ---------------------------------------------------------------------------
  # Some exported variable I sometimes use in my script to echo informations in
  # colors. Base on only 8 colors to ensure portability of color when in tty
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_bold="\e[1m"       # bold
  local e_info="\e[0;32m"    # green fg
  local e_error="\e[0;31m"   # red fg
  get_project_config_name
  # Initialize stop condition
  answer=0
  # Ask the user
  while [[ ${answer} -eq 0 ]]
  do
    ask_user_os_config
  done
  show_reload_info
}

main


# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: ts=2: sw=2: sts=2
# ------------------------------------------------------------------------------
