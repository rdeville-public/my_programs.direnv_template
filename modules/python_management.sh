#!/usr/bin/env bash
# """Setup a complete python virtual environment
#
# DESCRIPTION:
#   Ensure that python required version is installed. If yes, ensure that `pip3`
#   is installed too. If yes, create and activate a python virtual environment,
#   install basic python module `wheel` and `pip-tools`. Then depending on the
#   value `requirements_type` check if corresponding requirements files are
#   provided, if there is no requirements file with pinned version compile a
#   pinned version of the requirements. Finally install python requirements.
#
#   If everything above as already been done in a previous activation of the
#   directory environment, simply activate the python virtual environment.
#
#   If anything goes wrong, like wrong python version, `pip3` not installed,
#   etc., print an error
#
#   Parameters in `.envrc.ini` are:
#
#   <center>
#
#   | Name                | Description                                               |
#   | :------------------ | :-------------------------------------------------------- |
#   | `python_version`    | Minimum main python version to be installed (default `3`) |
#   | `python_release`    | Minimum Python release to be installed (default `8`)      |
#   | `python_patch`      | Minimum Python patch to be installed (default `0`)        |
#   | `requirements_type` | Type of requirements to be installed (default `dev`)      |
#
#   </center>
#
#   ## Parameters
#
#   ### `python_version`
#
#   Main minimum python version required to be installed. For instance, if
#   `python v3.8.10` is required, main python version is `3`.
#
#   ### `python_release`
#
#   Minimum python release required to be installed. For instance, if
#   `python v3.8.10` is required, python release is `8`.
#
#   ### `python_patch`
#
#   Minimum python patch required to be installed. For instance, if
#   `python v3.8.10` is required, python patch is `10`.
#
#   ### `requirements_type`
#
#   Define which `requirement.*.in` and `requirement.*.txt` to be processed.
#   Possible values are:
#
#   - `dev` (default), will process following files:
#       - `requirements.dev.in`: Contain unpinned python dependencies used for
#         development purpose.
#       - `requirements.dev.txt`: Contain pinned python dependencies used for
#         development purpose.
#       - `requirements.docs.in`: Contain unpinned python dependencies used for
#         documentation purpose.
#       - `requirements.docs.txt`: Contain pinned python dependencies used for
#         documentation purpose.
#       - `requirements.prod.in`: Contain unpinned python dependencies used for
#         production purpose.
#       - `requirements.prod.txt`: Contain pinned python dependencies used for
#         production purpose.
#   - `docs` (default), will process following files:
#       - `requirements.docs.in`: Contain unpinned python dependencies used for
#         documentation purpose.
#       - `requirements.docs.txt`: Contain pinned python dependencies used for
#         documentation purpose.
#   - `prod`, will process following files:
#       - `requirements.prod.in`: Contain unpinned python dependencies used for
#         production purpose.
#       - `requirements.prod.txt`: Contain pinned python dependencies used for
#         production purpose.
#
#   ## `.envrc.ini` example
#
#   Corresponding entry in `.envrc.ini.template` are:
#
#   ```ini
#   # Python management module
#   # ------------------------------------------------------------------------------
#   # Manage python virtual environment and ensure python binaries
#   [python_management]
#   # Main python version, to ensure python binaries installed have right version
#   # If not set, default is 3
#   python_version=3
#   # Main python release, to ensure python binaries installed have right release
#   # If not set, default is 8
#   python_release=8
#   # Main python patch, to ensure python binaries installed have right patch
#   # If not set, default is 0
#   python_patch=0
#   # Specify which requirements to install, either :
#   #   - `prod`: Only install requirements.prod.txt
#   #   - `docs`: Only install requirements.docs.txt
#   #   - `dev`: Install all requirements.*.txt
#   # Default is dev
#   requirements_type=dev
#   ```
#
# """


python_management()
{
  # """Setup a complete python virtual environment
  #
  # Ensure that python required version is installed. If yes, ensure that `pip3`
  # is installed too. If yes, create and activate a python virtual environment,
  # install basic python module `wheel` and `pip-tools`. Then depending on the
  # value `requirements_type` check if corresponding requirements files are
  # provided, if there is no requirements file with pinned version compile a
  # pinned version of the requirements. Finally install python requirements.
  #
  # If everything above as already been done in a previous activation of the
  # directory environment, simply activate the python virtual environment.
  #
  # If anything goes wrong, like wrong python version, `pip3` not installed,
  # etc., print an error
  #
  # Globals:
  #   DIRENV_ROOT
  #   _DIRENV_OLD_PATH
  #   _OLD_VIRTUAL_PATH
  #
  # Arguments:
  #   None
  #
  # Output:
  #   None
  #
  # Returns:
  #   1 if something went wrong when building python virtual environment
  #   0 if everything went right and python virtual environment is activated
  #
  # """

  check_python_var()
  {
    # """Ensure that required variables in `.envrc.ini` are valid
    #
    # Ensure that required variables in `.envrc.ini` are valid, i.e. if they are
    # sets, ensure they are integers.
    #
    # Globals:
    #   None
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Error informations
    #
    # Returns:
    #   1 if python veriables in `.envrc.ini` are not integers
    #   0 if python veriables in `.envrc.ini` are integers
    #
    # """

    local error="false"
    local i_var_name
    local i_var_value

    for i_var_name in "python_major" "python_minor" "python_patch"
    do

      # Handle ZSH for variable substitution
      if [[ -n "${ZSH_VERSION}" ]]
      then
        i_var_value="${(P)i_var_name}"
      else
        i_var_value="${!i_var_name}"
      fi

      # Value is not an integer
      if ! [[ "${i_var_value}" =~ ^[0-9]+$ ]]
      then
        direnv_log "ERROR" "Variable **\`${i_var_name}\`** should be an integer."
        error="true"
      fi
    done

    if [[ "${error}" == "true" ]]
    then
      return 1
    fi
  }

  check_python_version()
  {
    # """Ensure installed python meet the minimum version requirements
    #
    # Globals:
    #   DIRENV_ROOT
    #
    # Arguments:
    #   None
    #
    # Output:
    #   Error informations
    #
    # Returns:
    #   1 if python minimum version are not met
    #   0 if python minimum version are met
    #
    # """

    # Python version of the form X.Y
    local python_main_version="${python_major}.${python_minor}"
    # Python version of the form X.Y.Z
    local python_full_version="${python_main_version}.${python_patch}"
    # Python version of the form XYZZ
    local python_int_version

    local installed_python_int_version

    python_int_version="${python_major}${python_minor}$(printf "%02d" "${python_patch}")"

    # Ensure python is installed with the right version
    if ! [[ -f "${DIRENV_ROOT}/.direnv/.python_verion.ok" ]]
    then

      # Ensure python is installed
      if ! command -v python3 &> /dev/null
      then
        direnv_log "ERROR" "Required python to be installed with version **${python_full_version}**."
        direnv_log "ERROR" "Please refer to your distribution documentation."
        return 1
      fi

      # Catch python major
      installed_python_int_version=$(python3 -V 2>&1 \
        | grep -Po '(?<=Python )(.+)' | cut -d "." -f 1)
      # Catch python minor
      installed_python_int_version+=$(python3 -V 2>&1 \
        | grep -Po '(?<=Python )(.+)' | cut -d "." -f 2)
      # Catch python patch
      installed_python_int_version+=$(printf "%02d" "$(python3 -V 2>&1 \
        | grep -Po '(?<=Python )(.+)' | cut -d "." -f 3)")

      if [[ "${installed_python_int_version}" -lt "${python_int_version}" ]]
      then
        direnv_log "ERROR" "Requires python version **${python_full_version}**."
        direnv_log "ERROR" "Please refer to your distribution documentation."
        return 1
      elif (! command -v pip3 &> /dev/null \
            || ! pip3 --version | grep -q "${python_main_version}")
      then
        direnv_log "ERROR" "Required pip version using python version **${python_main_version}** is not installed."
        direnv_log "ERROR" "Please refer to your distribution documentation to install pip3 using python **${python_main_version}**."
        return 1
      else
        touch "${DIRENV_ROOT}/.direnv/.python_version.ok"
      fi
    fi
  }

  compute_pinned_dependencies()
  {
    # """Compute pinned version of python dependencies
    #
    # From a given type of requirements, check if corresponding
    # `requirements.*.in` file with unpinned python dependencies exits. If not,
    # do nothing. If file exists, check if corresponding file
    # `requirements.*.txt*` with pinned python dependencies exists, if not,
    # compute it.
    #
    # Globals:
    #   DIRENV_ROOT
    #
    # Arguments:
    #   $1: string, requirements type among "docs", "dev" and "prod"
    #
    # Output:
    #   Warning informations if unpinned requirements file does not exists
    #   Log informations when computing pinned requirements file
    #
    # Returns:
    #   None
    #
    # """

    local type_requirements=$1
    local unpin_requirements="${DIRENV_ROOT}/requirements.${type_requirements}.in"
    local pinned_requirements="${DIRENV_ROOT}/requirements.${type_requirements}.txt"

    if ! [[ -f "${unpin_requirements}" ]]
    then
      direnv_log "WARNING" "File **${unpin_requirements}** does not exists !"
      direnv_log "WARNING" "No pinned version of this requirements will be generated."
    elif ! [[ -f "${pinned_requirements}" ]] && [[ -f "${unpin_requirements}" ]]
    then
      direnv_log "INFO" "Generation of the python ${type_requirements} requirements with pinned version."
      pip-compile "${unpin_requirements}" >> "${DIRENV_LOG_FOLDER}/module.python_management.log" 2>&1
    fi
  }

  install_pinned_dependencies()
  {
    # """Install pinned version of python dependencies
    #
    # From a given type of requirements, check if corresponding
    # `requirements.*.txt` file with pinned python dependencies exits. If not,
    # do nothing. If file exists, install python dependencies.
    #
    # Globals:
    #   DIRENV_LOG_FOLDER
    #
    # Arguments:
    #   $1: string, requirements type among "docs", "dev" and "prod"
    #
    # Output:
    #   Log informations about dependencies installation in `.direnv/log/python_management.log`
    #
    # Returns:
    #   None
    #
    # """

    local type_requirements=$1
    local pin_requirements="${DIRENV_ROOT}/requirements.${type_requirements}.txt"

    if [[ -f "${pin_requirements}" ]]
    then
      direnv_log "INFO" "Installing python dependencies for ${type_requirements}."
      pip install -r "${pin_requirements}" >> "${DIRENV_LOG_FOLDER}/module.python_management.log" 2>&1
    fi
  }

  build_virtual_env()
  {
    # """Setup python virtual environment and install dependencies
    #
    # Create folder that will store python virtual environment in
    # `.direnv/python_venv`. If python virtual environment folder does not
    # exists create the python virtual environment. Install basic minimum
    # packages `wheel` and `pip-tools`. Then depending on requirements type set
    # in `.envrc.ini`, install python dependencies.
    #
    # Globals:
    #   DIRENV_LOG_FOLDER
    #
    # Arguments:
    #   $1: string, path to the python virtual environment directory
    #
    # Output:
    #   Log informations about dependencies installation in `.direnv/log/python_management.log`
    #
    # Returns:
    #   1 if something went wrong like wrong python version, etc.
    #   0 if everything went right
    #
    # """

    local venv_dir="$1"
    local requirements_type=()

    # Create parent dir where python virtual environment will be stored.
    mkdir -p "${venv_dir%/*}"
    # Create python virtual environment.
    python3 -m venv "${venv_dir}"
    # Activate virtualenv before installing dependencies.
    # shellcheck disable=SC1090
    # - SC1090: Can't follow non-constant source.
    source "${venv_dir}/bin/activate"
    # Install `wheel` and `pip-tools` as first dependencies.
    direnv_log "INFO" "Installing minimum python virtual environment dependencies."
    pip install wheel pip-tools >> "${DIRENV_LOG_FOLDER}/module.python_management.log" 2>&1

    # shellcheck disable=SC2154
    #   - SC2514: python_management is referenced but not assigned
    if [[ "${python_management[requirements_type]}" == "docs" ]]
    then
      requirements_type=("docs")
    elif [[ "${python_management[requirements_type]}" == "prod" ]]
    then
      requirements_type=("prod")
    else
      requirements_type=("docs" "dev" "prod")
    fi

    for i_requirements_type in "${requirements_type[@]}"
    do
      compute_pinned_dependencies "${i_requirements_type}"
      install_pinned_dependencies "${i_requirements_type}"
    done
  }

  # Get python version if set in `.envrc.ini`
  local python_major=${python_management[python_major]:-3}
  local python_minor=${python_management[python_minor]:-8}
  local python_patch=${python_management[python_patch]:-0}
  # Setup variable local to `DIRENV_ROOT` to compute python virtual environment.
  local dir_name
  dir_name=$(basename "${DIRENV_ROOT}")

  # Directory where the virtual environment folder will be.
  local venv_dir="${DIRENV_ROOT}/.direnv/python_venv/${dir_name}"


  check_python_var || return 1
  check_python_version || return 1

  # Build or activate python virtual environment
  if ! [[ -d "${venv_dir}" ]]
  then
    build_virtual_env "${venv_dir}"
  else
    # shellcheck disable=SC1090
    # - SC1090: Can't follow non-constant source.
    source "${venv_dir}/bin/activate"
  fi

  # If `direnv_management` module is loaded before python management, override
  # `_OLD_VIRTUAL_PATH`
  if [[ -n ${_DIRENV_OLD_PATH} ]]
  then
    export _OLD_VIRTUAL_PATH=${_DIRENV_OLD_PATH}
  fi
}

deactivate_python_management()
{
  # """Deactivate python virtual environment
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

  # If deactivate command exists, meaning we can deactivate python virtual
  # environment, then deactivate it.
  if command -v deactivate &> /dev/null
  then
    deactivate
  fi
}

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
