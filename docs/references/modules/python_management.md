# python_management.sh

Setup a complete python virtual environment

## Description

Ensure that python required version is installed. If yes, ensure that `pip3`
is installed too. If yes, create and activate a python virtual environment,
install basic python module `wheel` and `pip-tools`. Then depending on the
value `requirements_type` check if corresponding requirements files are
provided, if there is no requirements file with pinned version compile a
pinned version of the requirements. Finally install python requirements.

If everything above as already been done in a previous activation of the
directory environment, simply activate the python virtual environment.

If anything goes wrong, like wrong python version, `pip3` not installed,
etc., print an error

Parameters in `.envrc.ini` are:

<center>

| Name                | Description                                               |
| :------------------ | :-------------------------------------------------------- |
| `python_version`    | Minimum main python version to be installed (default `3`) |
| `python_release`    | Minimum Python release to be installed (default `8`)      |
| `python_patch`      | Minimum Python patch to be installed (default `0`)        |
| `requirements_type` | Type of requirements to be installed (default `dev`)      |

</center>

## Parameters

### `python_version`

Main minimum python version required to be installed. For instance, if
`python v3.8.10` is required, main python version is `3`.

### `python_release`

Minimum python release required to be installed. For instance, if
`python v3.8.10` is required, python release is `8`.

### `python_patch`

Minimum python patch required to be installed. For instance, if
`python v3.8.10` is required, python patch is `10`.

### `requirements_type`

Define which `requirement.*.in` and `requirement.*.txt` to be processed.
Possible values are:

- `dev` (default), will process following files:
    - `requirements.dev.*`: Contain unpinned (.in) and pinned (.txt) python
      dependencies used for development purpose.
    - `requirements.docs.*`: Contain unpinned (.in) and pinned (.txt) python
      dependencies used for documentation purpose.
    - `requirements.prod.*`: Contain unpinned (.in) and pinned (.txt) python
      dependencies used for production purpose.
- `docs` (default), will process following files:
    - `requirements.docs.*`: Contain unpinned (.in) and pinned (.txt) python
      dependencies used for documentation purpose.
- `prod`, will process following files:
    - `requirements.prod.*`: Contain unpinned (.in) and pinned (.txt) python
      dependencies used for production purpose.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Python management module
# ------------------------------------------------------------------------------
# Manage python virtual environment and ensure python binaries
[python_management]
# Main python version, to ensure python binaries installed have right version
# If not set, default is 3
python_version=3
# Main python release, to ensure python binaries installed have right release
# If not set, default is 8
python_release=8
# Main python patch, to ensure python binaries installed have right patch
# If not set, default is 0
python_patch=0
# Specify which requirements to install, either :
#   - `prod`: Only install requirements.prod.txt
#   - `docs`: Only install requirements.docs.txt
#   - `dev`: Install all requirements.*.txt
# Default is dev
requirements_type=dev
```



## python_management()

 **Setup a complete python virtual environment**
 
 Ensure that python required version is installed. If yes, ensure that `pip3`
 is installed too. If yes, create and activate a python virtual environment,
 install basic python module `wheel` and `pip-tools`. Then depending on the
 value `requirements_type` check if corresponding requirements files are
 provided, if there is no requirements file with pinned version compile a
 pinned version of the requirements. Finally install python requirements.
 
 If everything above as already been done in a previous activation of the
 directory environment, simply activate the python virtual environment.
 
 If anything goes wrong, like wrong python version, `pip3` not installed,
 etc., print an error

 **Globals**

 - `DIRENV_ROOT`
 - `_DIRENV_OLD_PATH`
 - `_OLD_VIRTUAL_PATH`

 **Returns**

 - 1 if something went wrong when building python virtual environment
 - 0 if everything went right and python virtual environment is activated

### check_python_var()

> **Ensure that required variables in `.envrc.ini` are valid**
> 
> Ensure that required variables in `.envrc.ini` are valid, i.e. if they are
> sets, ensure they are integers.
>
>
> **Output**
>
> - Error informations
>
> **Returns**
>
> - 1 if python veriables in `.envrc.ini` are not integers
> - 0 if python veriables in `.envrc.ini` are integers
>
>

### check_python_version()

> **Ensure installed python meet the minimum version requirements**
> 
>
> **Globals**
>
> - `DIRENV_ROOT`
>
> **Output**
>
> - Error informations
>
> **Returns**
>
> - 1 if python minimum version are not met
> - 0 if python minimum version are met
>
>

### compute_pinned_dependencies()

> **Compute pinned version of python dependencies**
> 
> From a given type of requirements, check if corresponding
> `requirements.*.in` file with unpinned python dependencies exits. If not,
> do nothing. If file exists, check if corresponding file
> `requirements.*.txt*` with pinned python dependencies exists, if not,
> compute it.
>
> **Globals**
>
> - `DIRENV_ROOT`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, requirements type among "docs", "dev" and "prod" |
>
> **Output**
>
> - Warning informations if unpinned requirements file does not exists
> - Log informations when computing pinned requirements file
>
>

### install_pinned_dependencies()

> **Install pinned version of python dependencies**
> 
> From a given type of requirements, check if corresponding
> `requirements.*.txt` file with pinned python dependencies exits. If not,
> do nothing. If file exists, install python dependencies.
>
> **Globals**
>
> - `DIRENV_LOG_FOLDER`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, requirements type among "docs", "dev" and "prod" |
>
> **Output**
>
> - Log informations about dependencies installation in `.direnv/log/python_management.log`
>
>

### build_virtual_env()

> **Setup python virtual environment and install dependencies**
> 
> Create folder that will store python virtual environment in
> `.direnv/python_venv`. If python virtual environment folder does not
> exists create the python virtual environment. Install basic minimum
> packages `wheel` and `pip-tools`. Then depending on requirements type set
> in `.envrc.ini`, install python dependencies.
>
> **Globals**
>
> - `DIRENV_LOG_FOLDER`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, path to the python virtual environment directory |
>
> **Output**
>
> - Log informations about dependencies installation in `.direnv/log/python_management.log`
>
> **Returns**
>
> - 1 if something went wrong like wrong python version, etc.
> - 0 if everything went right
>
>

## deactivate_python_management()

 **Deactivate python virtual environment**
 
