#!/usr/bin/env bash
# """Generate mkdocs documentation for each modules
#
# SYNOPSIS:
#
#   ./generate_module_docs.sh
#
# DESCRIPTION:
#
#   THIS SCRIPTS REQUIRES DIRECTORY ENVIRONMENT TO BE ACTIVATED.
#
#   For each script in modules folder, extract docstring describing the module
#   usage and write corresponding documentation to `docs/modules/` folder.
#
# """

# Output folder
DIRENV_MODULE_FOLDER="${DIRENV_ROOT}/modules"

generate_doc()
{
  # """Extract modules docstring and write corresponding documentation
  #
  #   For each script in modules folder, extract docstring describing the module
  #   usage and write corresponding documentation to `docs/modules/` folder.
  #
  # Globals:
  #   DIRENV_MODULE_FOLDER
  #   DIRENV_ROOT
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

  local line_from
  local line_to
  local i_line
  local i_node
  local module_name
  local doc_content
  local output_file
  local module_index="${DIRENV_ROOT}/docs/modules/index.md"

  cat <<EOM > "${module_index}"
# Modules

Modules are part of \`direnv_template\` which run tasks related to a specific
environment, for instance module \`ansible\` will only execute task related to
\`ansible\`, etc.

## List of exisitng modules

<center>

| Module Name | Description |
| :---------- | :---------- |
EOM


  for i_node in "${DIRENV_MODULE_FOLDER}"/*.sh
  do
    while read -r i_line
    do
      if [[ -z "${line_from}" ]]
      then
        line_from=${i_line}
      elif [[ -z "${line_to}" ]]
      then
        line_to=${i_line}
      fi
    done <<< "$(grep -n -e "^# \"\"\"" "${i_node}" | cut -d ":" -f 1)"
    module_name=${i_node##${DIRENV_MODULE_FOLDER}\/}
    module_name=${module_name%%.sh}

    if [[ -z "${line_from}" ]] || [[ -z "${line_to}" ]]
    then
      direnv_log "ERROR" "Incomplete documentation for module ${module_name}"
    else
      output_file="${DIRENV_ROOT}/docs/modules/${module_name}.md"
      doc_content="$(sed -n "${line_from},${line_to}"p "${i_node}")"

      # Extract module documentation
      doc_content="$(sed -n -e "/^# \"\"\".*/,/^# \"\"\"/"p "${i_node}" \
                    | sed -e "s/^# \"\"\"//g" \
                          -e "s/^# //g" \
                          -e "s/^  //g" \
                          -e "s/^#$//g" \
                          -e "s/DESCRIPTION[:]/## Description\n/g" \
                          -e "s/COMMANDS[:]/## Commands\n/g" \
                          -e "s/OPTIONS[:]/## Options\n/g" \
                          -e "s/SYNOPSIS[:]/## Synopsis\n/g" \
      )"
      doc_header=$(echo "${doc_content}" | head -n 1)
      echo "# ${module_name}" > "${output_file}"
      echo "${doc_content}" >> "${output_file}"
      echo "| [${module_name}](${module_name}.md) | ${doc_header} |" >> "${module_index}"
    fi
    line_from=""
    line_to=""
  done

  cat <<EOM >> "${module_index}"

</center>
EOM
}

main()
{
  # """Main method starting the generation of `.envrc.template.ini`
  #
  # Ensure directory environment is loaded, then load libraries scripts and
  # finally generate the modules documentations
  #
  # Globals:
  #   DIRENV_ROOT
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

  # Store coloring output prefix
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_error="\e[0;31m"   # red fg

  # Ensure directory environment is activated
  if [[ -z "${DIRENV_ROOT}" ]]
  then
    # Not using direnv_log as directory environment is not loaded yet
    echo -e "${e_error}[ERROR] Direnv must be activated to use this script.${e_normal}"
    return 1
  fi

  # Sourcing directory environment libraries scripts
  for i_lib in "${DIRENV_ROOT}"/lib/*.sh
  do
    # shellcheck source=./lib/direnv_log.sh
    source "${i_lib}"
  done

  generate_doc
}

main

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
