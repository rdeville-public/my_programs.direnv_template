#!/usr/bin/env bash
# """Select ansible configuration among those in `.envrc.ini`.
#
# SYNOPSIS:
#
#   ./select_ansible.sh
#
# DESCRIPTION:
#
#   THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.
#
#   This script allow to change easily which ansible project variable are
#   loaded when loading the directory environment. It is based on the
#   configurations of ansible module in `.envrc.ini`.
#
# """

# Array storing ansible configuration names
ANSIBLE_CONFIG_NAMES=()

get_project_config_name()
{
  # """Get ansible configuration name in `.envrc.ini`.
  #
  # Parse `.envrc.ini` file to extract ansible configuration name.
  #
  # Globals:
  #   DIRENV_ROOT
  #   ANSIBLE_CONFIG_NAMES
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

  while read -r ansible_config_name
  do
    # Remove brackest and extract configuration name
    ansible_config_name="${ansible_config_name//\]/}"
    ansible_config_name="${ansible_config_name//\[/}"
    ansible_config_name=$( echo "${ansible_config_name}" | cut -d ":" -f 2 )
    ANSIBLE_CONFIG_NAMES+=( "${ansible_config_name}" )
  done <<< "$( grep "ansible:" "${DIRENV_ROOT}/.envrc.ini" )"
}


show_question()
{
  # """Show user an TUI description of the the possible ansible configuration.
  #
  # From variable `ANSIBLE_CONFIG_NAMES`, build the string which will then
  # prompt the user a question with the name of ansible configuration.
  #
  # Globals:
  #   ANSIBLE_CONFIG_NAMES
  #
  # Arguments:
  #   None
  #
  # Output:
  #   String with the available ansible configuration name.
  #
  # Returns:
  #   None
  #
  # """

  local string="\
Please select the ansible project you want to work on:\n"

  for ansible_config_name in "${ANSIBLE_CONFIG_NAMES[@]}"
  do
    if [[ ${idx} -eq 1 ]]
    then
      string+="  ${idx}) ${ansible_config_name} ${e_bold}[Default]${e_normal}\n"
    else
      string+="  ${idx}) ${ansible_config_name}\n"
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
  #   ANSIBLE_CONFIG_NAMES
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
[ERROR] Please choose amoung valid option, i.e. ${e_info}${e_bold}between 1 and $(( ${#ANSIBLE_CONFIG_NAMES[@]} - 1 ))${e_normal}${e_error}
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
[INFO] Check the value of variable ANSIBLE_CONFIG_NAMES to be sure.${e_normal}"

}


ask_user_os_config()
{
  # """Ask user which ansible configuration to choose
  #
  # Call `show_question` method to ask the user ansible configuration to choose.
  # Then read an parse user answer. If answer is valid, save ansible
  # configuration name in `${DIRENV_TEMP_FOLDER}`/ansible.envrc. Else prompt an
  # error.
  #
  # Globals:
  #   ANSIBLE_CONFIG_NAMES
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
  if [[ ${answer:=1} =~ ^-?[0-9]+$ ]] \
    && [[ ${answer:=1} -lt ${#ANSIBLE_CONFIG_NAMES[@]} ]]
  then
    # If user answered a valid option, find the project to use
    idx=1
    for ansible_config_name in "${ANSIBLE_CONFIG_NAMES[@]}"
    do
      if [[ ${idx} -ne ${answer} ]]
      then
        idx=$(( idx + 1 ))
      else
        echo "${ansible_config_name}" > "${DIRENV_TEMP_FOLDER}/ansible.envrc"
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
  # """Main method to ask user which ansible configuration to use
  #
  # First get ansible configuration name from `.envrc.ini` file, then ask user
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
