# select_ansible.sh

Select ansible configuration among those in `.envrc.ini`.

## Synopsis


./select_ansible.sh

## Description


THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.

This script allow to change easily which ansible project variable are
loaded when loading the directory environment. It is based on the
configurations of ansible module in `.envrc.ini`.



## get_project_config_name()

 **Get ansible configuration name in `.envrc.ini`.**
 
 Parse `.envrc.ini` file to extract ansible configuration name.

 **Globals**

 - `DIRENV_ROOT`
 - `ANSIBLE_CONFIG_NAMES`

## show_question()

 **Show user an TUI description of the the possible ansible configuration.**
 
 From variable `ANSIBLE_CONFIG_NAMES`, build the string which will then
 prompt the user a question with the name of ansible configuration.

 **Globals**

 - `ANSIBLE_CONFIG_NAMES`

 **Output**

 - String with the available ansible configuration name.

## show_error()

 **Show an error message to the user if options is not valid.**
 

 **Globals**

 - `ANSIBLE_CONFIG_NAMES`

 **Output**

 -    Error message to tell the user that choosen option is wrong.

## show_reload_info()

 **Show an information message to tell the user to reload directory environment.**
 


 **Output**

 - Information message telling the user to reload directory environment.

## ask_user_os_config()

 **Ask user which ansible configuration to choose**
 
 Call `show_question` method to ask the user ansible configuration to choose.
 Then read an parse user answer. If answer is valid, save ansible
 configuration name in `${DIRENV_TEMP_FOLDER}`/ansible.envrc. Else prompt an
 error.

 **Globals**

 - `ANSIBLE_CONFIG_NAMES`
 - `DIRENV_TEMP_FOLDER`

## main()

 **Main method to ask user which ansible configuration to use**
 
 First get ansible configuration name from `.envrc.ini` file, then ask user
 which configuration to choose. Depending on the answer, show corresponding
 informations message.
