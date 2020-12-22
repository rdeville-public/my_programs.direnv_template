#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

check_python_var()
{
  local i_var_name
  local i_var_value

  for i_var_name in "python_version" "python_release" "python_patch"
  do
    # shellcheck disable=SC2116,SC1083
    #   - SC2116: Useless echo ?
    #   - SC1083: This { is leteral
    i_var_value="$(eval "$(echo "echo "\${${i_var_name}}"")")"
    if ! [[ "${i_var_value}" =~ ^[0-9]+$ ]]
    then
      direnv_log "ERROR" "Variable \`${i_var_name}\` should be an integer."
      error="true"
    fi
  done
  if [[ "${error}" = "true" ]]
  then
    return 1
  fi
}

check_python_version()
{

  # Python version of the form X.Y
  local python_main_version="${python_version}.${python_release}"
  # Python version of the form X.Y.2
  local python_full_version="${python_main_version}.${python_patch}"
  # Python version of the form XYZ
  local python_int_version="${python_full_version//./}"
  # PYTHON EXECUTABLE MANAGEMENT
  # ------------------------------------------------------------------------------
  # Ensure python is installed with the right version
  if ! [[ -f "${DIRENV_ROOT}/.direnv/.python_verion.ok" ]]
  then
    if (! command -v python3 &> /dev/null \
      || [[ "$(python3 --version | cut -d " " -f 2 | sed "s/\.//g")" -lt "${python_int_version}" ]])
    then
      direnv_log "ERROR" "Required python version ${python_full_version} is not installed."
      direnv_log "ERROR" "Please refer to your distribution documentation."
      return 1
    elif (! command -v pip3 &> /dev/null \
          || ! pip3 --version | grep -q "${python_main_version}")
    then
      direnv_log "ERROR" "Required pip version using python version ${python_version} is not installed."
      direnv_log "ERROR" "Please refer to your distribution documentation to install pip3 using python ${python_version}."
      return 1
    else
      touch "${DIRENV_ROOT}/.direnv/.python_version.ok"
    fi
  fi
}

compute_pinned_dependencies()
{
  local type_requirements=$1
  local unpin_requirements="${DIRENV_ROOT}/requirements.${type_requirements}.in"
  local pinned_requirements="${DIRENV_ROOT}/requirements.${type_requirements}.txt"

  if ! [ -f "${unpin_requirements}" ]
  then
    direnv_log "WARNING" "File ${unpin_requirements} does not exists !"
    direnv_log "WARNING" "No pinned version of this requirements will be generated."
  elif ! [ -f "${pinned_requirements}" ] && [ -f "${unpin_requirements}" ]
  then
    direnv_log "INFO" "Generation of the python ${type_requirements} requirements with pinned version."
    pip-compile "${unpin_requirements}" >> "${DIRENV_LOG_FOLDER}/module.python_management.log" 2>&1
  fi
}


install_pinned_dependencies()
{
  local type_requirements=$1
  local pin_requirements="${DIRENV_ROOT}/requirements.${type_requirements}.txt"
  if [ -f "${pin_requirements}" ]
  then
    direnv_log "INFO" "Installing python dependencies for ${type_requirements}."
    pip install -r "${pin_requirements}" >> "${DIRENV_LOG_FOLDER}/module.python_management.log" 2>&1
  fi
}

build_virtual_env()
{
  local venv_dir="$1"
  # Setup python virtual environment if it does not already exists.
  local requirements_type=()
  # Get parent dir where python virtual environment will be stored.
  mkdir -p "${venv_dir%/*}"
  # Create python virtual environment.
  python3 -m venv "${venv_dir}"
  # Activate virtualenv before installing dependencies.
  source "${venv_dir}/bin/activate"
  # Install setuptools, wheel and pip-tools as first dependencies.
  direnv_log "INFO" "Installing minimum python virtual environment dependencies."
  pip install wheel pip-tools >> "${DIRENV_LOG_FOLDER}/module.python_management.log" 2>&1
  # shellcheck disable=SC2154
  #   - SC2514: python_management is referenced but not assigned
  if [ "${python_management[requirements_type]}" = "docs" ]
  then
    requirements_type=("docs")
  elif [ "${python_management[requirements_type]}" = "prod" ]
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

python_management()
{
  # Ensure user required python version are installed and setup python virtual
  # environment.
  # NO PARAM
  #    * BUT, variables `python_version`, `python_release` and `python_patch`
  #      must be set in the main method of the script

  # PYTHON VERSION
  # ------------------------------------------------------------------------------
  # Check required python version variables are sets
  local error="false"
  local python_version=${python_management[python_version]:-3}
  local python_release=${python_management[python_release]:-8}
  local python_patch=${python_management[python_patch]:-0}
  # Setup variable local to this file to compute python virtual environment.
  local dir_name=$(basename "${DIRENV_ROOT}")
  # Directory where the virtual environment folder will be.
  local venv_dir="${DIRENV_ROOT}/.direnv/python_venv/${dir_name}"

  check_python_var || return 1
  check_python_version || return 1

  if ! [[ -d "${venv_dir}" ]]
  then
    build_virtual_env "${venv_dir}"
  else
    source "${venv_dir}/bin/activate"
  fi
  if [[ -n ${_DIRENV_OLD_PATH} ]]
  then
    export _OLD_VIRTUAL_PATH=${_DIRENV_OLD_PATH}
  fi
}

deactivate_python_management()
{
  if command -v deactivate &> /dev/null
  then
    deactivate
  fi
}
