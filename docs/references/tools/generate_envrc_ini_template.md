# generate_envrc_ini_template.sh

Generate template of `.envrc.ini` file from module documentation

## Synopsis


./generate_envrc_ini_template.sh

## Description


THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.

For each module scripts in modules folder, extract `.envrc.ini` example in
the module docstring and generate file `templates/envrc.template.ini`.



## generate_envrc_ini()

 **Extract `.envrc.ini` example of each module and write it in `templates/envrc.template.ini`.**
 
   For each module scripts in modules folder, extract `.envrc.ini` example in
   the module docstring and generate file `templates/envrc.template.ini`.

 **Globals**

 - `DIRENV_ROOT`

## main()

 **Main method starting the generation of `.envrc.template.ini`**
 
 Ensure directory environment is loaded, then load libraries scripts and
 finally generate the `.envrc.template.ini`.

 **Globals**

 - `DIRENV_ROOT`
