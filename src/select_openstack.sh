#!/bin/bash
# """Select openstack configuration among those in `.envrc.ini`.
#
# SYNOPSIS:
#
#   ./select_openstack.sh
#
# DESCRIPTION:
#
#   THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.
#
#   This script allow to change easily which openstack project variable are
#   loaded when loading the directory environment. It is based on the
#   configurations of openstack module in `.envrc.ini`.
#
# """

# Array storing openstack configuration names
OPENSTACK_CONFIG_NAMES=()

# Ensure user setup its openstack project.
get_project_config_name()
{
  # """Get openstack configuration name in `.envrc.ini`.
  #
  # Parse `.envrc.ini` file to extract openstack configuration name.
  #
  # Globals:
  #   DIRENV_ROOT
  #   OPENSTACK_CONFIG_NAMES
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

  while read -r openstack_config_name
  do
    openstack_config_name="${openstack_config_name//\]/}"
    openstack_config_name="${openstack_config_name//\[/}"
    openstack_config_name=$( echo "${openstack_config_name}" | cut -d ":" -f 2 )
    OPENSTACK_CONFIG_NAMES+=( "${openstack_config_name}" )
  done <<< "$( grep "openstack:" "${DIRENV_ROOT}/.envrc.ini" )"
}


show_question()
{
  # """Show user an TUI description of the the possible openstack configuration.
  #
  # From variable `OPENSTACK_CONFIG_NAMES`, build the string which will then
  # prompt the user a question with the name of openstack configuration.
  #
  # Globals:
  #   OPENSTACK_CONFIG_NAMES
  #
  # Arguments:
  #   None
  #
  # Output:
  #   String with the available openstack configuration name.
  #
  # Returns:
  #   None
  #
  # """

  local string="\
Please select the OpenStack project you want to work on:\n"
  for openstack_config_name in "${OPENSTACK_CONFIG_NAMES[@]}"
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
  # """Show an error message to the user if options is not valid.
  #
  # Globals:
  #   OPENSTACK_CONFIG_NAMES
  #
  # Arguments:
  #   None
  #
  # Output:
  #  Error message to tell the user that choosen option is wrong.
  #
  # Returns:
  #   None
  #
  # """

  echo -e "${e_error}\
================================================================================
[ERROR] Please choose amoung valid option, i.e. ${e_info}${e_bold}between 1 and $(( ${#OS_CONFIG_NAMES[@]} - 1 ))${e_normal}${e_error}
[ERROR] or press ${e_bold}Ctrl+C${e_normal}${e_error} to cancel.
================================================================================
${e_normal}"
}


show_reload_info()
{
  # """Show an information message to tell the user to reload directory environment.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Information message telling the user to reload directory environment.
  #
  # Returns:
  #   None
  #
  # """

  echo -e "${e_info}\
[INFO] You may need to reload the working environment for the change to take effects.
[INFO]   - Either manually : ${e_bold}'source .direnv/bin/activate_direnv'.${e_normal}${e_info}
[INFO]   - Either with direnv : ${e_bold}'direnv allow'.${e_normal}${e_info}
[INFO] Check the value of variable OS_PROJECT_NAME to be sure.${e_normal}"

}


ask_user_os_config()
{
  # """Ask user which openstack configuration to choose
  #
  # Call `show_question` method to ask the user openstack configuration to choose.
  # Then read an parse user answer. If answer is valid, save openstack
  # configuration name in `${DIRENV_TEMP_FOLDER}`/openstack.envrc. Else prompt an
  # error.
  #
  # Globals:
  #   OPENSTACK_CONFIG_NAMES
  #   DIRENV_TEMP_FOLDER
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

  idx=1
  show_question
  read -r answer
  # Automatically assign value 1 if user does not enter any value.
  if [[ ${answer:=1} =~ ^-?[0-9]+$ ]] && [[ ${answer:=1} -lt ${idx} ]]
  then
    # If user answered a valid option, find the project to use
    idx=1
    for openstack_config_name in "${OPENSTACK_CONFIG_NAMES[@]}"
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
  # """Main method to ask user which openstack configuration to use
  #
  # First get openstack configuration name from `.envrc.ini` file, then ask user
  # which configuration to choose. Depending on the answer, show corresponding
  # informations message.
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
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
