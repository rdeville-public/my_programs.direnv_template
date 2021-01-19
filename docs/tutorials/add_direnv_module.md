# Add direnv module

In this tutorial, we will see how to create a new module for the `direnv
template` project. The present tutorial will give you main steps to create a
module which are:

  * [Initialize the working branch](#initialize-the-working-branch)
  * [Module documentation](#module-documentation)
  * [Module activation](#module-activation)
  * [Module deactivation](#module-deactivation)
  * [Running tests](#running-tests)
  * [Render documentation](#render-documentation)
  * [Propose a merge request](#propose-a-merge-request)

!!! important

    This tutorial will assume you work on a fork of the repo
    [{{ git_platform.name }}-{{ git_platform.repo_name }}][repo_url]. It is not
    recommended to work directly on a `.direnv` folder from one of your
    directory in which you setup directory environment.

For all the following tutorial, we will assume the module name we want to add is
`tuto_module`. Do not forget to change this for your module name.

!!! important

    Do not choose a module name which have the same of an existing binary (for
    instance, do not choose `python` as module name), as this may create
    conflict which the binary. In this case prefer to choose another name like
    `python_management`.


## Setup the working environment

First thing to do is to setup a working environment. In order to do so, you have
two possibilities:

  - Using [`direnv_template`][repo_url] (yes, this project within it) to
    automate the setup of the development environment. This approach will not be
    covered in this tutorial.

  - Setup working environment manually.

First, you will need following dependencies:

  - python >= 3.8
  - pip3

Please refer to your OS distribution to install these requirements.

```bash
# Assuming you are at the root of the project.
# Initialize python virtual environment.
python3 -m venv .env
# This will create a folder `.env`
# Now activate the virtual environment
source .env/bin/activate
# Install python production requirements (dependencies for python scripts in `src`)
pip3 install -r requirements.prod.txt
# Install python documentation requirements (to build the documentation)
pip3 install -r requirements.docs.txt
# Install python development requirements (to run the test)
pip3 install -r requirements.dev.txt
```

And that is all, you are now ready to work to develop your new module.

## Initialize the working branch

First thing to do is to create a branch to work on the new module.

```bash
# Assuming you are at the root of the repo
git checkout -b feature-tuto_module
```

Then, create the script that will hold the module method.

```bash
# Assuming you are at the root of the repo
touch modules/tuto_module.sh
```

## Module main methods

A module **MUST** contain at least two methods which name are:

  - `tuto_module()`
  - `deactivate_tuto_module()`

Below is an example of what you should get before starting the development:

??? example
    ```bash
    #!/usr/bin/env bash

    tuto_module()
    {
    }

    deactivate_tuto_module()
    {
    }

    # ------------------------------------------------------------------------------
    # VIM MODELINE
    # vim: ft=bash: foldmethod=indent
    # ------------------------------------------------------------------------------
    ```

### Module activation

Now, first thing to do is to implement the content of the activation process of
the module, i.e. the content of the method `tuto_module()`.

In our example, our module will simply ensure that some variables are defined in
the `.envrc.ini` file and export some of them.

First thing to know is that the `parse_ini_file.sh` library script will
automatically create arrays based on section names a variables. For instances:

??? example
    ```dosini
    [tuto_module]
    EXPORT_VAR_1=foo
    EXPORT_VAR_2=fooz
    module_var_1=bar
    module_var_2=baz
    ```

When parsed, this will create a bash associative which name is `tuto_module`
with four entry. In other term, it like if the bash array was initialized with
the following code:

??? example
    ```bash
    declare -a tuto_module
    tuto_module[EXPORT_VAR_1]=foo
    tuto_module[EXPORT_VAR_2]=fooz
    tuto_module[module_var_1]=bar
    tuto_module[module_var_2]=baz
    ```

So you can easily access these value in your module script, for instance, if you
want to store them:

??? example
    ```bash
    tuto_module()
    {
      local export_var_1=${tuto_module[EXPORT_VAR_1]}
      local export_var_2=${tuto_module[EXPORT_VAR_2]}
      local module_var_1=${tuto_module[module_var_1]}
      local module_var_1=${tuto_module[module_var_1]}
    }
    ```

Now let us assume you want to provided default value for `module_var_*` but you
want to ensure that `EXPORT_VAR_*` are set by the user.

??? example
    ```bash
    tuto_module()
    {
      eval_tuto_module_var()
      {
        local i_var_name
        local i_var_value

        for i_var_name in "EXPORT_VAR_1" "EXPORT_VAR_2"
        do
          i_var_value="${tuto_module[${i_var_name}]}"

          if [[ -z "${i_var_value}" ]]
          then
            direnv_log "ERROR" "Variable \`${i_var_name}\` should be set in .envrc.ini."
            error="true"
          fi
          eval "$(echo "${i_var_name}=\"${i_var_value}\"")"
        done

        if [[ "${error}" == "true" ]]
        then
          return 1
        fi
      }

      local export_var_1
      local export_var_2
      local module_var_1
      local module_var_1

      # Ensure variable are defined in user `.envrc.ini`
      eval_tuto_module_var || return 1

      # Assign values
      export_var_1=${tuto_module[EXPORT_VAR_1]}
      export_var_2=${tuto_module[EXPORT_VAR_2]}
      # Assigne default values if not defined in user `.envrc.ini`
      module_var_1=${tuto_module[module_var_1]:-default_value_1}
      module_var_1=${tuto_module[module_var_1]:-default_value_2}
    }
    ```

Finally, let us write the module process. In our example it will be really
simple. We will `echo` the `module_var_*` and we will export `EXPORT_VAR_*`.

??? example
    ```bash
    tuto_module()
    {
      eval_tuto_module_var()
      {
        local i_var_name
        local i_var_value

        for i_var_name in "EXPORT_VAR_1" "EXPORT_VAR_2"
        do
          i_var_value="${tuto_module[${i_var_name}]}"

          if [[ -z "${i_var_value}" ]]
          then
            direnv_log "ERROR" "Variable \`${i_var_name}\` should be set in .envrc.ini."
            error="true"
          fi
          eval "$(echo "${i_var_name}=\"${i_var_value}\"")"
        done

        if [[ "${error}" == "true" ]]
        then
          return 1
        fi
      }

      local export_var_1
      local export_var_2
      local module_var_1
      local module_var_1

      # Ensure variable are defined in user `.envrc.ini`
      eval_tuto_module_var || return 1

      # Assign values
      export_var_1=${tuto_module[EXPORT_VAR_1]}
      export_var_2=${tuto_module[EXPORT_VAR_2]}
      # Assigne default values if not defined in user `.envrc.ini`
      module_var_1=${tuto_module[module_var_1]:-default_value_1}
      module_var_1=${tuto_module[module_var_1]:-default_value_2}

      echo "${module_var_1}"
      echo "${module_var_2}"

      export EXPORT_VAR_1=${export_var_1}
      export EXPORT_VAR_2=${export_var_2}
    }
    ```

Of course, you can do much more in your module. See for instance code of
[python_management][python_management_module] module which:

  - Create a python virtual environment if it does not exists
  - Activate python virtual environment
  - Compile requirements depending on user configuration in `.envrc.ini` to pin
    requirements if not already done
  - Install requirements in the python virtual environment


### Module deactivation

Second thing to do is to provide a deactivation method. This method will only be
needed for user that activate directory environment manually.

Usually this method will only unset exported variables, but sometimes you might
need to do more (see again [python_management][python_management_module]).

In our example, we will only need to unset exported variables:

??? example
    ```bash
    deactivate_tuto_module()
    {
      unset EXPORT_VAR_1
      unset EXPORT_VAR_2
    }
    ```

## Write documentation

Next thing to do is to provide documentation for your module and for your
method. First refers to the section [Comment][shellguide_comment] in the [Shell
Style Guide][shellguide].

[shellguide_comment]: https://docs.romaindeville.fr/dev_guides/style_guides/shellguide.html#comments

### Main module documentation

First thing to do is to write the main module documentation as describe [File
Header][shellguide_file_header] in the [Shell Style Guide][shellguide]. This
module documentation will be automatically parsed later with tools scripts to
render the online documentation. So do not hesitate to write it in Markdown
format for the `DESCRIPTION` content.

Moreover, you **MUST** provide `.envrc.ini` example in the module documentation.
This example will be used to generate the `.envrc.template.ini`

Below is an example of such documentation apply to our  `tuto_module`:

??? example

    === "Bash"

        ```bash
        #!/usr/bin/env bash
        # """One liner describing module behaviour.
        #
        # DESCRIPTION:
        #   Echo variables `module_var_1` and `module_var_2`.
        #   Export variables `EXPORT_VAR_1` and `EXPORT_VAR_2`.
        #
        #   Parameters in `.envrc.ini` are:
        #
        #   <center>
        #
        #   | Name            | Description                                                                   |
        #   | :-------------- | :---------------------------------------------------------------------------- |
        #   | `EXPORT_VAR_1`  | Short description of the variable usage                                       |
        #   | `EXPORT_VAR_2`  | Short description of the variable usage                                       |
        #   | `module_var_1`  | (optional)Short description of the variable usage (default `default_value_1`) |
        #   | `module_var_2`  | (optional)Short description of the variable usage (default `default_value_2`) |
        #
        #   </center>
        #
        #   ## Parameters
        #
        #   ### `EXPORT_VAR_1`
        #
        #   Long description explaining the usage of the variable.
        #
        #   ### `EXPORT_VAR_2`
        #
        #   Long description explaining the usage of the variable.
        #
        #   ### `module_var_1`
        #
        #   Long description explaining the usage of the variable. Default value is
        #   `default_value_1`.
        #
        #   ### `module_var_2`
        #
        #   Long description explaining the usage of the variable. Default value is
        #   `default_value_2`.
        #
        #   ## `.envrc.ini` example
        #
        #   Corresponding entry in `.envrc.ini.template` are:
        #
        #   ```ini
        #   # tuto_module module
        #   # ------------------------------------------------------------------------------
        #   # Set variable for the tutorial
        #   [tuto_module]
        #   # Short description of the variable usage
        #   EXPORT_VAR_1=foo
        #   # Short description of the variable usage
        #   EXPORT_VAR_2=foz
        #   # Short description of the variable usage
        #   module_var_1=bar
        #   # Short description of the variable usage
        #   module_var_2=baz
        #   ```
        #
        # """
        ```

    === "Rendering"

        <!-- Using HTML balise directly to avoid mkdocs adding content to TOC -->
        One liner describing module behaviour.

        <h2> Description </h2>

        Echo variables `module_var_1` and `module_var_2`.

        Export variables `EXPORT_VAR_1` and `EXPORT_VAR_2`.

        Parameters in `.envrc.ini` are:

        <center>

        | Name            | Description                                                                   |
        | :-------------- | :---------------------------------------------------------------------------- |
        | `EXPORT_VAR_1`  | Short description of the variable usage                                       |
        | `EXPORT_VAR_2`  | Short description of the variable usage                                       |
        | `module_var_1`  | (optional)Short description of the variable usage (default `default_value_1`) |
        | `module_var_2`  | (optional)Short description of the variable usage (default `default_value_2`) |

        </center>

        <h2> Parameters </h2>

        <h3> `EXPORT_VAR_1` </h3>

        Long description explaining the usage of the variable.

        <h3> `EXPORT_VAR_2` </h3>

        Long description explaining the usage of the variable.

        <h3> `module_var_1` </h3>

        Long description explaining the usage of the variable. Default value is
        `default_value_1`.

        <h3> `module_var_2` </h3>

        Long description explaining the usage of the variable. Default value is
        `default_value_2`.

        <h2> `.envrc.ini` example </h2>

        Corresponding entry in `.envrc.ini.template` are:

        ```ini
        Tuto_module module
        ------------------------------------------------------------------------------
        Set variable for the tutorial
        [tuto_module]
        Short description of the variable usage
        EXPORT_VAR_1=foo
        Short description of the variable usage
        EXPORT_VAR_2=foz
        Short description of the variable usage
        module_var_1=bar
        Short description of the variable usage
        module_var_2=baz
        ```

[shellguide_file_header]: https://docs.romaindeville.fr/dev_guides/style_guides/shellguide.html#file-header

### Method documentation

Now that our module has its main documentation, you **MUST** add "docstring" to
every functions in your script in the format described in section [Function
Comment][shellguide_function_comment] in [Shell Style Guide][shellguide].

Below are simple example for our `tuto_module`:

??? Example

    ??? Example "Method `tuto_module()`"

        === "Bash"
            ```bash
            tuto_module()
            {
              # """Echo variables value to stdout and export other variables
              #
              # Ensure that required variables `EXPORT_VAR_*` are defined. If
              # not exit with an error. Else, echo variable `module_var_*` and
              # export `EXPORT_VAR_*`
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
              #   1 if some tuto_module required variables are not defined
              #   0 if the module is correctly loaded
              #
              # """
              ...
            }
            ```
        === "Rendering"

            <h2> tuto_module() </h2>

            **Echo variables value to stdout and export other variables**

            Ensure that required variables `EXPORT_VAR_*` are defined. If
            not exit with an error. Else, echo variable `module_var_*` and
            export `EXPORT_VAR_*`

            **Returns**

              - 1 if some tuto_module required variables are not defined
              - 0 if the module is correctly loaded


    ??? Example "Method `eval_tuto_module_var()`"

        === "Bash"
            ```bash
            eval_tuto_module_var()
            {
              # """Ensure required variable for tuto_module to be defined in `.envrc.ini`
              #
              # Ensure that required variables `EXPORT_VAR_*` are defined in
              # `.envrc.ini`. If not, exit with and error.
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
              #   1 if some tuto_module required variables are not defined
              #   0 if the module is correctly loaded
              #
              # """
              ...
            }
            ```

        === "Rendering"

            <h3> eval_tuto_module_var() </h3>

            > **Ensure required variable for tuto_module to be defined in `.envrc.ini`**
            >
            > Ensure that required variables `EXPORT_VAR_*` are defined in
            > `.envrc.ini`. If not, exit with and error.
            >
            > **Returns**
            >
            >  - 1 if some tuto_module required variables are not defined
            >  - 0 if the module is correctly loaded

    ??? Example "Method `deactivate_tuto_module()`"

        === "Bash"
            ```bash
            deactivate_tuto_module()
            {
              # """Unset exported variable `EXPORT_VAR_*`
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
              ...
            }
            ```

        === "Rendering"
            <h2> deactivate_tuto_module() </h2>

             **Unset exported variable `EXPORT_VAR_*`**


!!! Note

    You might want to add other script in other language for your module. For
    instance see script [`keepass.sh`][keepass_sh] or
    [`clone_ansible_role.py`][clone_ansible_role.py]. Depending on the language
    of the script, please follow corresponding [Guide Style][guide_style].

[shellguide_function_comment]: https://docs.romaindeville.fr/dev_guides/style_guides/shellguide.html#function-comments
[shellguide]: https://docs.romaindeville.fr/dev_guides/style_guides/shellguide.html
[keepass_sh]: ../references/src/keepass.md
[clone_ansible_role]: ../references/src/clone_ansible_roles.md

## Render documentation

Once done, you can run script to almost automatically render the documentation.
In order to do so, you simply need two scripts:

```bash
# Assuming you are at the root of the repo
# Render module documentation
./tools/generate_module_docs.sh
# Render source code documentation
./tools/generate_source_docs.sh
```

This will automatically create `docs/modules/tuto_module.md` and a set of
markdown files in `docs/references/modules` (and `docs/references/src/` if you
create files in `src` folder).

Finally, you will need to add these new files into the `nav` key in
`mkdocs.yml` **and** in `mkdocs.local.yml`.

**Remark**: Modules and references source code in the `nav` are sorted
alphabetically, please add your entry accordingly.

## Running tests

Once you have finish, you **MUST** ensure that your code is documentated and the
documentation is build properly. In order to do so, if you already [setup your
working environment][setup_working_environment] you simply have to run
[tox][tox].

```bash
# Run all the test
tox
# Now be patient, test can take some times.
```

Last command will create "sub-virtual environments" within `.tox` folder. Then
it will run test that:

  - Ensure bash script are well formatted
  - Ensure bash script are documented and test them if any test are provided
  - Ensure python script are well formatted and test them if any test are provided
  - Ensure that documentation can be built locally and for the main
    documentation website

[tox]: https://tox.readthedocs.io/
[setup_working_environment]: #setup-the-working-environment

## Propose a merge request

If you are happy with your module, you can propose a merge to the main repo
[{{ git_platform.name }}-{{ git_platform.repo_name }}][repo_url]. Please refer
to [Developers Guidelines][developers_guidelines] as references to propose your
merge request.

[developers_guidelines]: https://docs.romaindeville.fr/dev_guides/developer_guidelines.html

<!-- Link to URL used in multiple sections -->
[python_management_module]: ../modules/python_management.md
[repo_url]: {{ git_platform.url }}{{ git_platform.main_namespace }}{{ git_platform.repo_path_url }}