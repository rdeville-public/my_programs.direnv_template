# deactivate_direnv

Deactivate the directory environment

## Synopsis

deactivate_direnv

## Description

THIS SCRIPT CAN ONLY BE USED WHEN DIRECTORY ENVIRONMENT IS LOADED MANUALLY

For each loaded modules, it will call the corresponding deactivation
methods, then it will unset every `DIRENV_*` variables and unset every
methods set during the activatation of the directory environment as well as
methods used by this script.



## deactivate_direnv()

 **Deactivate directory environment**
 
   For each loaded modules, it will call the corresponding deactivation
   methods, then it will unset every `DIRENV_*` variables and unset every
   methods set during the activatation of the directory environment as well as
   methods used by this script.

 **Globals**

 - `DIRENV_ROOT`
 - `DIRENV_LIB_FOLDER`
 - `DIRENV_TEMP_FOLDER`
 - `DIRENV_MODULE_FOLDER`

 **Output**

 - Log informations

### deactivate_modules()

> **Deactivate already module**
> 
> For each already loaded modules, i.e. modules listed in
> ${DIRENV_TEMP_FOLDER}/.loaded_modules, call the deactivate method of the
> module.
>
> **Globals**
>
> - `DIRENV_MODULE_FOLDER`
> - `DIRENV_TEMP_FOLDER`
>
> **Output**
>
> - Log message to inform the user
>
>

### get_methods_list()

> **Parse file passed as argument to export list of methods**
> 
> Parse a file and return the list of "first-level" methods, i.e. methods
> which name is not idented. For instance, this metod is not a "first-level"
> method.
>
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, path to the file to parse |
>
> **Output**
>
> - Multiline string with all the "first-level" methods, one per line
>
> **Returns**
>
> - 0 if file has "first-level" methods
> - 1 if file does not have "first-level" methods
>
>

### unset_methods()

> **Unset methods if defined from list of methods provided as arguments**
> 
>
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  multiline string, list of methods to unset, one method per line |
>
> **Returns**
>
> - 0 if file has "first-level" methods
> - 1 if file does not have "first-level" methods
>
>

### unset_modules()

> **Unset modules from list of already loaded modules**
> 
> The process to unset modules is compose of two part:
>   - Unset methods defined in the module
>   - Unset associative array related to this module
>
> **Globals**
>
> - `DIRENV_TEMP_FOLDER`
> - `DIRENV_MODULE_FOLDER`
>
>

### unset_all_methods_and_vars()

> **Unset all methods and variables set to load directory environment**
> 
> The process to unset all methods and variables is composed of two part:
>   - Unset methods and variables defined by modules
>   - Unset methods defined by library scripts
>
> **Globals**
>
> - `DIRENV_ROOT`
> - `DIRENV_LIB_FOLDER`
> - `DIRENV_TEMP_FOLDER`
> - `DIRENV_MODULE_FOLDER`
> - `DIRENV_CONFIG_PATH`
> - `DIRENV_INI_SEP`
>
>
