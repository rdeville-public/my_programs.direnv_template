#!/us/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039:In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead

load_config_file()
{
  local config_file_path="${DIRENV_CONFIG_PATH}"
  local config_file_sha1="${DIRENV_SHA1_FOLDER}/$(basename "${config_file_path}").sha1"

  if ! [[ -f "${config_file_path}" ]]
  then
    direnv_log "ERROR" "File ${config_file_path} does not exists."
  else
    if ! [ -f "${config_file_sha1}" ]
    then
      sha1sum "${config_file_path}" | cut -d " " -f 1 > "${config_file_sha1}"
    else
      if ! check_sha1 "${config_file_path}"
      then
        direnv_log "ERROR" "If you modify ${config_file_path}"
        direnv_log "ERROR" "Please remove ${config_file_sha1}"
        direnv_log "ERROR" "And reactivate direnv."
        return 1
      fi
    fi
    parse_ini_file "${config_file_path}"
  fi
}

