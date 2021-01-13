#!/usr/bin/env bash
# """Generate mkdocs source code references documentation for bash scripts
#
# SYNOPSIS:
#   ./generate_source_docs.sh [options]
#
# DESCRIPTION:
#   THIS SCRIPT WILL ONLY WORK IF DIRECTORY ENVIRONMENT IS ACTIVATED !
#
#   From the list of nodes stored in `${NODE_LIST[@]}` array in the script,
#   parse every scripts in nodes and folder nodes to generate their
#   corresponding references source code documentation for mkdocs and output this
#   documentation in their corresponding file in the `docs` folder.
#
# OPTIONS:
#
#   - `-d,--dry-run`<br>
#     Specify the generation of the documentation is only for test purpose.
#
# """

# Input folder/script
NODE_LIST=(
  ".envrc"
  "activate_direnv"
  "deactivate_direnv"
  "lib"
  "src"
  "modules"
  "tools"
)

DRY_RUN="false"

parse_main_doc()
{
  # """Process the content of the main part of the docstring
  #
  # Render the mkdocs documentation of the main part of the docstring.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the main parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${main_doc}" ]]
  then
    while IFS= read -r i_line
    do
      echo "${quote_indent} ${i_line/${space_indent}}"
    done <<< "$(echo -e "${main_doc}")"
    echo "${quote_indent}"
  fi
}

parse_globals_doc()
{
  # """Process the content of the globals part of the docstring
  #
  # If `Globals` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the globals parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${globals_doc}" ]] && ! [[ "${globals_doc}" =~ "None" ]]
  then
    echo -e "${quote_indent} **Globals**"
    echo "${quote_indent}"
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    while IFS= read -r i_line
    do
      # If line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        echo "${quote_indent} - \`${i_line/${space_indent}}\`"
      fi
    done <<< "$(echo -e "${globals_doc}")"
  fi
  echo "${quote_indent}"
}

parse_arguments_doc()
{

  # """Process the content of the arguments part of the docstring
  #
  # If `Arguments` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the arguments parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  local argument
  local description
  local line_content

  if [[ -n "${arguments_doc}" ]] && ! [[ "${arguments_doc}" =~ "None" ]]
  then
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    echo "${quote_indent} **Arguments**"
    echo "${quote_indent}"
    echo "${quote_indent} | Arguments | Description |"
    echo "${quote_indent} | :-------- | :---------- |"
    while IFS= read -r i_line
    do
      # If line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        line_content="${i_line/${space_indent}}"
        argument="\`${line_content%%:*}\`"
        description="${line_content##*:}"
        echo -e "${quote_indent} | ${argument} | ${description} |"
      fi
    done <<< "$(echo -e "${arguments_doc}")"
    echo "${quote_indent}"
  fi
}

parse_output_doc()
{
  # """Process the content of the output part of the docstring
  #
  # If `Output` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the return parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${output_doc}" ]] && ! [[ "${output_doc}" =~ "None" ]]
  then
    echo -e "${quote_indent} **Output**"
    echo "${quote_indent}"
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    while IFS= read -r i_line
    do
      # If current line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        echo "${quote_indent} - ${i_line/${space_indent}}"
      fi
    done <<< "$(echo -e "${output_doc}")"
    echo "${quote_indent}"
  fi
}

parse_returns_doc()
{
  # """Process the content of the return part of the docstring
  #
  # If `Returns` part of the docstring is not `None`, render the mkdocs
  # documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Rendered content of the return parts of the docstring on stdout
  #
  # Returns:
  #   None
  #
  # """

  if [[ -n "${returns_doc}" ]] && ! [[ "${returns_doc}" =~ "None" ]]
  then
    echo "${quote_indent} **Returns**"
    echo "${quote_indent}"
    # `IFS=` here is local to the loop and make the read do not hide leading
    # space to keep indentation of the current line.
    while IFS= read -r i_line
    do
      # If current line is not empty
      if [[ -n "${i_line}" ]] && ! [[ "${i_line}" =~ ^[[:space:]]*$ ]]
      then
        echo -e "${quote_indent} - ${i_line/${space_indent}}"
      fi
    done <<< "$(echo -e "${returns_doc}")"
    echo "${quote_indent}"
  fi
}

parse_method_doc_line()
{
  # """Process current line of the method documentation
  #
  # For the current line of the method docstring (value of `${i_line}` sets in
  # the parent method), add its content to the variable storing part of the
  # documentation to later be processed.
  #
  # Globals:
  #   DIRENV_ROOT
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Render content of the header of the docstring on stdout
  #   Warning log if optional part of the docstring are missing on stderr
  #   Error log if required part of the docstring are missing on stderr
  #
  # Returns:
  #   1 if required part of the docstring are missing
  #
  # """

  # If parsing first line of the docstring, i.e. the header
  if [[ "${part}" == "header" ]]
  then
    if ! [[ "${i_line}" =~ \"+[A-Za-z] ]]
    then
      direnv_log "ERROR" "Mehod **${method_name}** in" \
        "**${i_node//${DIRENV_ROOT}\/}** does not have **header** description."
      return 1
    else
      echo "${quote_indent} **${i_line//${header_regexp_delete}}**"
    fi
    part="main"
  # If current line define a new part (except `main`)
  elif [[ "${i_line}" =~ (Globals|Arguments|Output|Returns): ]]
  then
    # Get the name of the variable storing the current part of the docstring
    var_subst="$( echo ${part} | tr '[:upper:]' '[:lower:]')_doc"

    # Handling of zsh for variable substitution
    if [[ -n "${ZSH_VERSION}" ]]
    then
      part_content="${(P)var_subst}"
    else
      part_content="${!var_subst}"
    fi

    # If part content is empty or made of only empty lines
    if [[ -z "${part_content}" ]] || [[ -z "$(echo -e "${part_content}")" ]]
    then
      if [[ "${part}" == "main" ]]
      then
        direnv_log "WARNING" \
          "Method **${method_name}** in **${i_node//${DIRENV_ROOT}\/}**" \
          "does not have **${part}** description."
      else
        direnv_log "ERROR" \
          "Method **${method_name}** in **${i_node//${DIRENV_ROOT}\/}**" \
          "does not have **${part}** description."
        return 1
      fi
    fi

    # Normally, when changing part, comment of part should have two more space
    # than the main part of the docstring.
    if [[ "${part}" == "main" ]]
    then
      space_indent+="  "
    fi

    # Update the current part name
    part=$(echo "${i_line}" | sed -e "s/^ *//g" -e "s/:$//g")
  else
    # Add line to the variable corresponding to the currently parsed docstring
    # part.
    case "${part}" in
      main)
        main_doc+="${i_line/${space_indent}}\n"
        ;;
      Globals)
        globals_doc+="${i_line}\n"
        ;;
      Arguments)
        arguments_doc+="${i_line}\n"
        ;;
      Output)
        output_doc+="${i_line}\n"
        ;;
      Returns)
        returns_doc+="${i_line}\n"
        ;;
    esac
  fi
}

generate_method_docs()
{
  # """Generate mkdocs documentation from a method docstring
  #
  # For the method name with its docstring passed as first argument, parse it
  # content and add it to the script documentation.
  #
  # Globals:
  #   None
  #
  # Arguments:
  #   $1: string, method name with its docstring
  #
  # Output:
  #   Rendered documentation on stdout
  #   Error log if required part of the docstring are missing on stderr
  #
  # Returns:
  #   1 if required part of the docstring are missing
  #
  # """

  # Content of the docstring
  local method_doc="$1"

  # First part of the docstring
  local header_regexp_delete=' *"""'
  local method_name
  local method_full_desc

  # Variable storing subpart of the docstring
  local part="header"
  local part_content=""
  local var_subst=""

  # Variable storing documentation of each part of the docstring
  local main_doc=""
  local globals_doc=""
  local arguments_doc=""
  local output_doc=""
  local returns_doc=""

  # Default markdown title depth
  local toc_depth="##"

  # Extract the method name
  method_name="$(grep -E ".*\(\)$" <<<"${method_doc}" | sed "s/^ *//g")"

  # Extract only the docstring without the comment prefix `#`
  # shellcheck disable=SC2026
  # - SC2026: This word (`p`) is outside of quotes
  method_full_desc=$(echo "${method_doc}" \
    | sed -n -e '/# """.*/,/# """/'p \
    | sed -e 's/# //g' \
          -e 's/"""$//g' \
          -e 's/#$//g' \
  )

  # Compute TOC depth of the method
  if [[ "${nb_indent}" -ne 0 ]]
  then
    toc_depth+="$(printf "%$(( nb_indent ))s" '#')"
  fi

  # Output title of the method name with its depth
  echo -e "\n\n${toc_depth} ${method_name}\n"

  # Normally, indentation of docstring should be two more space that method
  # indentation.
  space_indent+="  "

  # `IFS=` here is local to the loop and make the read do not hide leading space
  # to keep indentation of the current line.
  # shellcheck disable=SC2116
  # - SC2116: Useless echo ?
  while IFS= read -r i_line
  do
    parse_method_doc_line
  done <<<"$(echo "${method_full_desc}")"

  # Remove indentation correction
  space_indent=${space_indent:-4}

  # Process the aggregated documentation per parts
  parse_main_doc
  parse_globals_doc
  parse_arguments_doc
  parse_output_doc
  parse_returns_doc
}

generate_doc()
{
  # """Generate mkdocs documentation of the current node
  #
  # For the current node (value of `${i_node}` set in parent method), extract
  # the main script documentation, then extract every method name and for every
  # method name, call the method to parse their documentation.
  # Finally, print the generate documentation in it corresponding file in `docs`
  # folder.
  #
  # Globals:
  #   DIRENV_ROOT
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Error log if script does not have main documentation
  #
  # Returns:
  #   1 if script does not have main documentation
  #
  # """

  local output_file=${i_node}
  local space_indent
  local quote_indent
  local nb_indent
  local script_doc
  local full_doc

  # Handle files starting with `.` like `.envrc`
  if [[ "${i_node}" =~ ^\. ]]
  then
    output_file="${i_node/.}"
  fi
  output_file="${DIRENV_ROOT}/docs/references/${output_file//.sh}.md"

  # Extract module documentation
  script_doc="$(sed -n -e "/^# \"\"\".*/,/^# \"\"\"/"p "${i_node}" \
                | sed -e "s/^# \"\"\"//g" \
                      -e "s/^# //g" \
                      -e "s/^  //g" \
                      -e "s/^#$//g" \
                      -e "s/DESCRIPTION[:]/## Description\n/g" \
                      -e "s/COMMANDS[:]/## Commands\n/g" \
                      -e "s/OPTIONS[:]/## Options\n/g" \
                      -e "s/SYNOPSIS[:]/## Synopsis\n/g" \
  )"

  if [[ -z ${script_doc} ]]
  then
    direnv_log "ERROR" "Script **${i_node}** does not have documentation."
    return 1
  fi

  # Build directory in documentation folder respecting the tree structure of the
  # `i_node` currently parsed.
  if [[ "${DRY_RUN}" == "false" ]]
  then
    mkdir -p "${DIRENV_ROOT}/docs/references/$(dirname "${i_node}")"
  fi

  # Start building the complete documentation
  full_doc="# $(basename "${i_node}")\n\n"
  full_doc+="${script_doc}\n\n"

  # For every method_name, `IFS=` here is local to the loop and make the read
  # do not hide leading space to keep indentation of the current method name.
  while IFS= read -r i_method_name
  do
    # Determine the number of space indentation
    space_indent=${i_method_name%%[a-z]*}
    nb_indent=$(( ${#space_indent} / 2 ))
    if [[ "${nb_indent}" -ne 0 ]]
    then
      quote_indent="$(printf "%${nb_indent}s" ">")"
    fi
    method_content=$(sed -n -e "/${i_method_name}/,/# \"\"\"$/"p "${i_node}")
    full_doc+="$(generate_method_docs "${method_content}")"
  done <<<"$(grep -E '[a-zA-Z_]\(\)' "${i_node}")"

  if [[ "${DRY_RUN}" == "false" ]]
  then
    echo -e "${full_doc}" > "${output_file}"
  fi
}

build_doc()
{
  # """Recursive method that call the documentation builder for every file
  #
  # For every node provided as arguments, if node is a file, then process its
  # documentation build. Else, if node is a folder, add all `*.sh` file in this
  # folder to a temporary array which later is passed recursively as arguments to
  # this method.
  #
  # Globals:
  #   DIRENV_ROOT
  #
  # Arguments:
  #   $1: Bash array, List of node (files or folder) which documentation should be built.
  #
  # Output:
  #   Information log to tell which node is currently computed.
  #   Warning log to when node does not exist.
  #
  # Returns:
  #   None
  #
  # """
  local abs_path
  local i_node
  local tmp_nodes=()

  for i_node in "$@"
  do
    # Build absolute path of the node
    abs_path="${DIRENV_ROOT}/${i_node}"

    if [[ -f "${abs_path}" ]]
    then
      direnv_log "INFO" "Computing documentation of **${i_node}**."
      generate_doc || error="true"
    elif [[ -d "${abs_path}" ]]
    then
      for i_subnode in "${abs_path}"/*.sh
      do
        # Handle folder where there is not `*.sh` file
        if [[ "${i_subnode}" != "${abs_path}/*.sh" ]]
        then
          # Remove every occurrences of `${DIRENV_ROOT}`
          i_subnode="${i_subnode//${DIRENV_ROOT}\//}"
          tmp_nodes+=("${i_subnode}")
        fi
      done
    else
      direnv_log "WARNING" "Node **${i_node}** does not exists !"
    fi
  done

  # Call this method for subnode
  if [[ -n "${tmp_nodes[*]}" ]]
  then
    build_doc "${tmp_nodes[@]}" || error="true"
  fi

  if [[ "${error}" == "true" ]]
  then
    return 1
  fi
  return 0
}

main()
{
  # """Main method that build source documentat for every files
  #
  # First ensure that directory environment is activated first, then load
  # libraries script and finally call the building doc methods.
  #
  # Globals:
  #   DIRENV_ROOT
  #   NODE_LIST
  #
  # Arguments:
  #   None
  #
  # Output:
  #   Error log if directory environment is not activated yet
  #
  # Returns:
  #   1 if directory environment is not activated yet
  #
  # """

  # Store coloring output prefix
  local e_normal="\e[0m"     # normal (white fg & transparent bg)
  local e_error="\e[0;31m"   # red fg

  # Ensure directory environment is activated
  if [[ -z "${DIRENV_ROOT}" ]]
  then
    # Not using direnv_log as libraries scripts are not loaded yet.
    echo -e "${e_error}[ERROR] Direnv must be activated to use this script.${e_normal}" 1>&2
    return 1
  fi

  while [[ $# -gt 0 ]]
  do
    case $1 in
      -d|--dry-run)
        DRY_RUN="true"
        shift
        ;;
    esac
  done

  # Sourcing directory environment libraries scripts
  for i_lib in "${DIRENV_ROOT}"/lib/*.sh
  do
    # shellcheck source=./lib/direnv_log.sh
    source "${i_lib}"
  done

  build_doc "${NODE_LIST[@]}" || return 1
}

main "$@"

# ------------------------------------------------------------------------------
# VIM MODELINE
# vim: ft=bash: foldmethod=indent
# ------------------------------------------------------------------------------
