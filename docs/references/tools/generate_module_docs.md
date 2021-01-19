# generate_module_docs.sh

Generate mkdocs documentation for each modules

## Synopsis


./generate_module_docs.sh

## Description


THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.

For each script in modules folder, extract docstring describing the module
usage and write corresponding documentation to `docs/modules/` folder.



## generate_doc()

 **Extract modules docstring and write corresponding documentation**
 
   For each script in modules folder, extract docstring describing the module
   usage and write corresponding documentation to `docs/modules/` folder.

 **Globals**

 - `DIRENV_MODULE_FOLDER`
 - `DIRENV_ROOT`

## main()

 **Main method starting the generation of `.envrc.template.ini`**
 
 Ensure directory environment is loaded, then load libraries scripts and
 finally generate the modules documentations

 **Globals**

 - `DIRENV_ROOT`
