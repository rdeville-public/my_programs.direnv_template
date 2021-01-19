# select_openstack.sh

Select openstack configuration among those in `.envrc.ini`.

## Synopsis


./select_openstack.sh

## Description


THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.

This script allow to change easily which openstack project variable are
loaded when loading the directory environment. It is based on the
configurations of openstack module in `.envrc.ini`.



## get_project_config_name()

 **Get openstack configuration name in `.envrc.ini`.**
 
 Parse `.envrc.ini` file to extract openstack configuration name.

 **Globals**

 - `DIRENV_ROOT`
 - `OPENSTACK_CONFIG_NAMES`

## show_question()

 **Show user an TUI description of the the possible openstack configuration.**
 
 From variable `OPENSTACK_CONFIG_NAMES`, build the string which will then
 prompt the user a question with the name of openstack configuration.

 **Globals**

 - `OPENSTACK_CONFIG_NAMES`

 **Output**

 - String with the available openstack configuration name.

## show_error()

 **Show an error message to the user if options is not valid.**
 

 **Globals**

 - `OPENSTACK_CONFIG_NAMES`

 **Output**

 -    Error message to tell the user that choosen option is wrong.

## show_reload_info()

 **Show an information message to tell the user to reload directory environment.**
 


 **Output**

 - Information message telling the user to reload directory environment.

## ask_user_os_config()

 **Ask user which openstack configuration to choose**
 
 Call `show_question` method to ask the user openstack configuration to choose.
 Then read an parse user answer. If answer is valid, save openstack
 configuration name in `${DIRENV_TEMP_FOLDER}`/openstack.envrc. Else prompt an
 error.

 **Globals**

 - `OPENSTACK_CONFIG_NAMES`
 - `DIRENV_TEMP_FOLDER`

## main()

 **Main method to ask user which openstack configuration to use**
 
 First get openstack configuration name from `.envrc.ini` file, then ask user
 which configuration to choose. Depending on the answer, show corresponding
 informations message.
