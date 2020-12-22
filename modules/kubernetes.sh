#!/usr/bin/env bash

# SHELLCHECK
# ---------------------------------------------------------------------------
# Globally disable some shellcheck errors, warnings or remarks.
# shellcheck disable=SC1090,SC2155,SC2039,SC2001
#   - SC1090: Can't follow non-constant source. Use a directive to specify location.
#   - SC2155: Declare and assign separately to avoid masking return values.
#   - SC2039: In POSIX sh, array references are undefined
#   - SC2001: See if you can use ${variable//search/replace} instead


# KUBERNETES RELATED VARIABLES
# ------------------------------------------------------------------------------
kubernetes()
{
  # Search in the current inventories of the current OS_PROJECT_NAME if there is a
  # kube_config file. If so, take the first result.
  export KUBECONFIG=${kubernetes[KUBECONFIG]:-$(find "${DIRENV_ROOT}/" -iname "kube_config*" | head -1)}
  # This variable is only usefull if your prompt is setup to use it, for
  # instance to print a kubernetes environment.
  export KUBE_ENV=1

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # REMARK !!
  # If you want to always use the same kube_config file, you can comment above
  # line and directly setup variable as show below as example:
  # Setup kubernetes configuration file depending on project (i.e. environment)
  # export KUBECONFIG="${DIRENV_ROOT}/inventories/${OS_PROJECT_NAME}/group_vars/group_hostname/kube_config.yaml"
  # export KUBE_ENV=1

}

deactivate_kubernetes()
{
  unset KUBECONFIG
  unset KUBE_ENV
}
