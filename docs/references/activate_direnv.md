# activate_direnv

Activate the directory environment

## Synopsis

source /path/to/activate_direnv

## Description

This script can be :

  - Sourced manually, like for python virtual environment, with the
    following command:
    ```
    source /path/to/.direnv/activate_direnv
    ```

  - Sourced automatically by `direnv` using file `.envrc`, see thee
    description in the header of file `.envrc`.

Script will parse the file `.envrc.ini`, build associative arrays for each
modules described in this file and load corresponding modules.

Finally, script will unset every temporary variable and methods that are not
required once directory environment is loaded to avoid spoiling shell
environment.



## activate_direnv()

 **Activate directory environment by loading modules**
 
 Check if script is called manuall or using `direnv`, set global variables
 related to directory environment folder (such as `DIRENV_ROOT`.)
 
 Call the script `lib/parse_ini_file.sh` to parse the file `.envrc.ini` to
 build associative arrays.
 
 From these associative arrays, ensure that module have not been modified, if
 modules have been modified, warn the user and safely exit. Else load
 corresponding modules.
 
 Finally, unset variables and methods not required once directory environment
 is loaded to avoid spoiling the user shell.


 **Output**

 - Log informations

 **Returns**

 - 0 if directory environment is correctly loaded
 - 1 if something when wrong during loading directory environment

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
> 
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
> 
>   - Unset methods and variables defined by modules
>   - Unset methods defined by library scripts
>
> **Globals**
>
> - `IS_DIRENV`
> - `DIRENV_ROOT`
> - `DIRENV_LOG_FOLDER`
> - `DIRENV_LIB_FOLDER`
> - `DIRENV_SRC_FOLDER`
> - `DIRENV_BIN_FOLDER`
> - `DIRENV_SHA1_FOLDER`
> - `DIRENV_TEMP_FOLDER`
> - `DIRENV_MODULE_FOLDER`
> - `DIRENV_CONFIG_PATH`
> - `DIRENV_INI_SEP`
>
>

### install_upgrade_script()

> **Setup script to upgrade direnv config**
> 
> Create a symlink from the source file `src/upgrade_direnv.sh` to the `bin`
> folder to make the script accessible from the PATH if the symlink does not
> already exists.
>
> **Globals**
>
> - `DIRENV_SRC_FOLDER`
> - `DIRENV_BIN_FOLDER`
>
> **Output**
>
> - Log message to inform user of the installation of the script
>
>

### check_if_direnv()

> **If this script is not called by `direnv`, deactivate_direnv method**
> 
> Check from which binary is called the script, if script is called
> manually, i.e. using `source activate_direnv`; source the file
> `deactivate_direnv` if SHA1 is valid to set the corresponding method to
> allow user to manually deactivate directory environment.
>
> **Globals**
>
> - `DIRENV_ROOT`
>
> **Returns**
>
> - 0 if SHA1 of deactivate_direnv is valid and method is set
> - 1 if SHA1 of deactivate_direnv is not valid
>
>

### set_direnv()

> **Set required global variables**
> 
> Check from which binary is called the script, depending on the way, set
> global variables that will be used by directory environment scripts if
> main scripts (i.e. `.envrc` and `activate_direnv`) have valid SH1.
>
> **Globals**
>
> - `IS_DIRENV`
> - `DIRENV_ROOT`
> - `DIRENV_LOG_FOLDER`
> - `DIRENV_LIB_FOLDER`
> - `DIRENV_SRC_FOLDER`
> - `DIRENV_BIN_FOLDER`
> - `DIRENV_SHA1_FOLDER`
> - `DIRENV_TEMP_FOLDER`
> - `DIRENV_MODULE_FOLDER`
> - `DIRENV_CONFIG_PATH`
> - `DIRENV_INI_SEP`
>
> **Returns**
>
> - 0 if SHA1 of scripts are valid
> - 1 if SHA1 of scripts are not valid
>
>

### load_module()

> **Load specific module**
> 
> Check if module script exists, if not, print an error. Else, check if
> SHA1 of module script is valid, if not, print an error.
> If everything is correct, load the module.
>
> **Globals**
>
> - `DIRENV_TEMP_FOLDER`
> - `DIRENV_MODULE_FOLDER`
> - `DIRENV_CONFIG_PATH`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, name of the module from `.envrc.ini` |
>
> **Output**
>
> - Log message if something went wrong
>
> **Returns**
>
> - 0 if module is correctly loaded
> - 1 if module can not be loaded
>
>

### load_config_file()

> **Load the configuration file**
> 
> Ensure the configuration file `.envrc.ini` exists. If not print and error
> and exit. Else ensure that `.envrc.ini has not been modified, if
> `.envrc.ini` has been modified, print an error and exit.
> If everything is right, parse the configuration file `.envrc.ini`
>
> **Globals**
>
> - `DIRENV_SHA1_FOLDER`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, path to the configuration file |
>
> **Output**
>
> - Error message if something went wrong
>
> **Returns**
>
> - 0 if the configuration file has been loaded.
> - 1 if there is an error with the configuration file.
>
>

### deactivate_modules()

> **Deactivate already module**
> 
> Methods called when initialization of directory environment went wrong.
> For each already loaded modules, i.e. modules listed in
> ${DIRENV_TEMP_FOLDER}/.loaded_modules, call the deactivate method of the
> module.
> Finally, remove the file ${DIRENV_TEMP_FOLDER}/.loaded_modules.
>
> **Globals**
>
> - `DIRENV_MODULE_FOLDER`
> - `DIRENV_TEMP_FOLDER`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, name of the module from `.envrc.ini` |
>
> **Output**
>
> - Log message if something went wrong
>
> **Returns**
>
> - 0 if module is correctly loaded
> - 1 if module can not be loaded
>
>

### safe_exit()

> **Safely exit the activation of directory environment in case of error**
> 
> Safely exit the activate of the directory environment if something went
> wrong during the initilization. This is done by deactivating modules, then
> unset all methods and variables.
>
>
> **Output**
>
> - Log message telling user an error occurs
>
> **Returns**
>
> - 1 in any case to indicate an error occurs
>
>
