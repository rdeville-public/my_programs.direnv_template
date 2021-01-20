# Setup directory environment

## Install

First thing to do is install required source code into your current folder.

In order to do so, first check the content of the setup script, this
can be done with the following command:

```bash
# First download setup script in a temporary folder
curl -sSL {{ git_platform.url }}{{ git_platform.main_namespace }}my_programs/direnv_template/-/raw/master/setup.sh \
  > /tmp/setup_direnv.sh
# Then review this script with your favorite editor, `vim` here as example
vim /tmp/setup_direnv.sh
```

Once you understand what the script do, you can execute it **from the folder in
which you want to setup a directory environment**. From here, you have two
possibilities:

  - You have downloaded the script somewhere in your computer

```bash
# First make it executable
chmod +x /tmp/setup_direnv.sh
# Then simply execute it
/tmp/setup_direnv.sh
```

  - You did not downloaded the script or you are lazy and do not want to make it
    executable

```bash
# You can setup directory environment in one command
curl -sSL {{ git_platform.url }}{{ git_platform.main_namespace }}my_programs/direnv_template/-/raw/master/setup.sh | bash -
```

This will create a folder `.direnv` and the file `.envrc·` in the current
directory if they do not exists.

!!! warning "Directory already containing `.direnv` or `.envrc`"
    If you execute previous command in a folder already containing a directory
    `.direnv` or a file `.envrc`, you will see following output:

    ```text
    [WARNING] This folder seems to already be set to use direnv.
    [WARNING] Continuing might result in the loss of your configuration
    [WARNING] If you want to upgrade your configuration use the option `--upgrade|-u`
    ```

    From this point, you have to possibilites:

      - Upgrade your current directory environment using the setup
        script:

        ```bash
        curl -sSL {{ git_platform.url }}{{ git_platform.main_namespace }}my_programs/direnv_template/-/raw/master/setup.sh | bash -s -- --ugrade
        ```

      - Assuming you already have configured your directory environment (see
        section [Configure][configure]):
        - [Activate your directory environment](#activate)
        - Then [Upgrade directory environment source code](#upgrade)


Assuming you are in a `git` managed directory, you might want to version this
base scripts to make the directory environment linked to your repo:

```bash
# Add directory environment scripts to your git repo
git add .direnv .envrc
# Commit these scripts
git commit
```

[configure]: #configure

## Configure

Now that base scripts are installed, you will need to configure which process
you want to automate. This will be done with a file `.envrc.ini` that must need
to be place next to `.envrc` file.

A example of such file with all modules is provided when installing directory
environment. You can simply copy/paste it with the following command:

```bash
# Copy the example of `.envrc.ini` provided
cp .direnv/templates/envrc.template.ini .envrc.ini
```

Then, you **must update values in `.envrc.ini`**. Indeed, most values in the
example file are simply dummy values. In order to properly configure your
`.envrc.ini`, first check [available modules][modules] to know which value to
set for each module.

Some last important things that can be usefull when setting up values.

  - For each modules, they have list of variable you can set. Variables in
    UPPERCASE are variable that are exported by the module, i.e. these variables
    will be accessible with `echo ${VAR_NAME}` or will be show when using `env`
    command, once the directory environment is activated. Variables in lowercase
    are not exported and are only used by the module.

    ??? example "Example of UPPERCASE and lowercase variable in `.envrc.ini`"

        From below example, variable `ANSIBLE_CONFIG` will be exported (use by
        ansible) while variable `inventory` will not be exported but will be
        used by module `ansible` when generating the `ansible.cfg` file.

        ```dosini
        # Ansible module
        # ------------------------------------------------------------------------------
        # Set ansible environment variable
        [ansible]
        # Choose the default configuration for the first initialisation
        default_config="config_name_1"

        [ansible:config_name_1]
        # Set the path to ansible configuration file. If this file does not exists, it
        # will be created from template in .direnv/templates/ansible.cfg.template
        ANSIBLE_CONFIG="${DIRENV_ROOT}/${OS_PROJECT_NAME}.ansible.cfg"
        # Path to inventory file or folder
        inventory="${DIRENV_ROOT}/inventory"
        ```

  - If you plan to also version your `.envrc.ini` or simply if you do not want
    to store some information (like passwords) in plain text, every values in
    your `.envrc.ini` can be set to catch output of specific command. In order
    to do so, you must start the value with `cmd: ` followed by the command that
    output the value you want to set.

    ??? example "Use of `cmd:` in `.envrc.ini`"
        Below is a short example to setup a value obtain from a command.
        ```dosini
        # Assuming you store the value in the file /tmp/my_password
        password=cmd: cat /tmp/my_password
        # When `.envrc.ini` will be parsed, the value of password will be
        # computed within the module. This allow to avoid storing password in
        # plain text in `.envrc.ini`
        ```

  - Modules are loaded in the order provided in the `.envrc.ini`. Below are some
    example.

    ??? example "Load module `direnv_management` first then load the module `ansible`"

        ```dosini
        # Direnv module
        # ------------------------------------------------------------------------
        [direnv_mangement]
        ...

        # Ansible module
        # ------------------------------------------------------------------------
        [ansible]
        ...
        ```


    ??? example "Load module `ansible` first then load the module `direnv_management`"

        ```dosini
        # Ansible module
        # ------------------------------------------------------------------------
        [ansible]
        ...

        # Direnv module
        # ------------------------------------------------------------------------
        [direnv_mangement]
        ...
        ```

    This can be seen as not usefull, but read the next point.

  - Values in `.envrc.ini` can use variables exported from previously loaded
    module. In order to do so, variables **must** be called with the following
    syntax `${VAR_NAME}`. This also apply to the variable `${DIRENV_ROOT}` which
    specify the absolute path to the directory which host the directory
    environment scripts.

    ??? example "Use of exported variables from previously loaded module"

        In the below example, module `openstack` is loaded first, so variable
        `OS_PROJECT_NAME` is exported once the module is loaded. Which is then
        accessible by module `ansible`.

        !!! important
            If module `openstack` is below module `ansible` in ``.envrc.ini`,
            then this **will not work**.

        ```dosini
        # Openstack module
        # ------------------------------------------------------------------------------
        # Manage openstack environment variable. Main section [openstack] have only one
        # parameter `default` to define default openstack project configuration name.
        # Use section of the form [openstack:project_config_name_1] to define variable
        # per project configuration name.
        # **REMARK**: VALUE OF `default` MUST BE THE SAME VALUE OF A SUBSECTION AS SHOWN
        # BELOW:
        # ```
        # [openstack]
        # default=project_config_name_1
        #
        # [openstack:project_config_name_1]
        # OS_AUTH_URL=https://test.com
        # ...
        # ```
        [openstack]
        # Default project configuration name when activating the direnv for the first
        # time
        # NO DEFAULT VALUE
        default=project_config_name_1

        # Configuration for each openstack project
        [openstack:project_config_name_1]
        # Value of openstack variable OS_AUTH_URL in openrc.sh
        OS_AUTH_URL=https://test.com
        # Value of openstack variable OS_PROJECT_ID in openrc.sh
        OS_PROJECT_ID=1234
        # Value of openstack variable OS_PROJECT_NAME in openrc.sh
        OS_PROJECT_NAME=project_name_1
        # Value of openstack variable OS_USERNAME in openrc.sh
        OS_USERNAME=username
        # Value of openstack variable OS_PASSWORD in openrc.sh, to avoid setup a value
        # in clear text, as for any other value in this ini file, start the value with
        # `cmd:` to tell the parser that value will be obtain by executing the command
        # specified after `¢md:`. In the example below, parser will execute command `echo
        # "foo", so value of OS_PASSWORD will be `foo`
        OS_PASSWORD=cmd:echo "foo"
        # Value of openstack variable OS_INTERFACE in openrc.sh
        OS_INTERFACE=interface
        # Value of openstack variable OS_REGION_NAME in openrc.sh
        OS_REGION_NAME=region_name
        # Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh
        OS_IDENTITY_API_VERSION=3
        # Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh
        OS_USER_DOMAIN_NAME=domain_name

        # Ansible module
        # ------------------------------------------------------------------------------
        # Set ansible environment variable
        [ansible]
        # Choose the default configuration for the first initialisation
        default_config="config_name_1"

        [ansible:config_name_1]
        # Set the path to ansible configuration file. If this file does not exists, it
        # will be created from template in .direnv/templates/ansible.cfg.template
        ANSIBLE_CONFIG="${DIRENV_ROOT}/${OS_PROJECT_NAME}.ansible.cfg"
        # Path to inventory file or folder
        inventory="${DIRENV_ROOT}/inventory"
        ```


## Activate

Once you have finished setting your `.envrc.ini` configuration file, you can now
activate your directory environment. The activation process will parse the
content of your `.envrc.ini` file and will load modules accordingly.

To activate your directory environment, you have two possibilities:

  - Acitvate it manually
  - Automate activation using [`direnv`][direnv]

Depending on the value of variable
[`DIRENV_DEBUG_LEVEL`][direnv_management_debug_level] for module
[`direnv_management`][direnv_management_module], log output might change when
activating directory environment, either manually or automatically.

If `DIRENV_DEBUG_LEVEL` is set to `DEBUG` or `INFO`, you will have following
output when activating directory environment:

```text
[INFO] Loading module module_name.
```

[direnv_management_debug_level]: modules/direnv_management.md#direnv_debug_level
[direnv_management_module]: modules/direnv_management.md

### Manual activation

!!! note "Not recommend way to activate directory environment"
    Manual activation of directory environment is not recommend. Exported
    variables and scripts added to the `PATH` when activating the directory
    environment will be available even outside of the working directory. Until
    you manually deactivate the directory environment (see section
    [Deactivate][deactivate]).

    This may create conflict with other working environment. We strongly
    recommend the automatic activation using [`direnv`][direnv]. Indeed, with
    [`direnv`][direnv], the directory environment will automatically be
    deactivated when leaving the working directory.

To activate the directory environment manually, you simply need to source
`.direnv/activate_direnv` file:

```bash
# Activate manuall directory environment
source .direnv/activate_direnv
```

If something went wrong, you will see output like:

```text
[ERROR] Error message to explain what happen.
```

In this case, please refers to section [Error during
activation][error_activation] below.

[deactivate]: #deactivate

### Automatic activation

If you are a [`direnv`][direnv] user, you might want to automate activation of
the directory environment (which is exactly [`direnv`][direnv] purpose. In order
to do so, when setting up the directory environment a file `.envrc` has be put
in the directory. So, you might have seen the following message:

```text
direnv: error /path/to/.envrc is blocked. Run `direnv allow` to approve its content.
```

So to automate the activation of the directory environment, you just need to
type the following command:

```bash
direnv allow
```

If something went wrong, you will see output like:

```text
[ERROR] Error message to explain what happen.
```

In this case, please refers to section [Error during
activation][error_activation] below.

### Error during activation

During the activation of the directory environment, you might see output message
starting with `[ERROR]` (indepently of the value of variable
`DIRENV_DEBUG_LEVEL`).

Normally, you might see three types of error:

  - Module does not exists

    ```text
    [ERROR] Module module_name does not exists !
    [ERROR] Please review file /path/to/.envrc.ini to remove or comment it.
    ```
    This menas that you setup a wrong section module, i.e. `[module_name]` in
    your `.envrc.ini` file. Please review your `.envrc.ini` file, this might
    come from a typo error. Moreover, see [available modules][modules] to know
    which modules is available.

  - SHA1 error of a specific module

    ```text
    [ERROR] SHA1 of file `.direnv/modules/module_name.sh`  does not correspond to `.direnv/.sha1/modules/module_name.sh.sha1`.
    [ERROR] An error occurs while loading direnv
    ```

    This means that the module specified has been modify. This is a security
    feature.

    Normally, [`direnv`][direnv] provide a security when file `.envrc`
    has been modify to avoid execution of malicious code. But usage of this
    project make no use of this security. As you can activate directory
    environment manually or if you are using [`direnv`][direnv] you never need
    to update `.envrc`, so once allowed, [`direnv`][direnv] will not know it it
    will execute malicious code.

    To tackle this issues, every files used by this
    project is provided with its SHA1 sum. So, when activating directory
    environment first things done is to ensure that these files as not been
    modified and so, avoid execution of malicious code.

    If you modify one of these files volontarily, you will need to update the
    corresponding SHA1 sum of the files you modified. To do so, please refer to
    the tutorial [Add direnv module][add_direnv_module]. And, even better, if
    you modify a files, this probably means that project currently lack a
    feature. Do not hesitate to contribute and submit a merge request to let the
    community make profit of your enhancement. In order to do so, please refers
    to the [Developers Guide][developers_guide]

  - SHA1 error of `.envrc.ini`

    ```text
    [ERROR] SHA1 of file `.envrc.ini`  does not correspond to `.direnv/.sha1/.envrc.ini.sha1`.
    [ERROR] If you modify /path/to/.envrc.ini.
    [ERROR] Please remove /path/to/.direnv/.sha1/.envrc.ini.sha1.
    [ERROR] And reactivate direnv.
    ```

    This means your `.envrc.ini` has been modified, probably by you. But if it
    is not the case, this project avoid malicious modification of your
    `.envrc.ini`.

    Indeed, as for files provided with this project, there is a protection
    mechanism. This project require a SHA1 sum of your `.envrc.ini`. This SHA1
    sum is stored in `.direnv/.sha1/.envrc.ini.sha1`.

    If this file does not exist, then the SHA1 sum of your `.envrc.ini` file
    will be computed and stored in `.direnv/.sha1/.envrc.ini.sha1`.

    If this file exists, then each time you will activate your directory
    environment, the SHA1 sum of your `.envrc.ini` will be checked against the
    value stored in `.direnv/.sha1/.envrc.ini.sha1`.

    If the value differs, then you will see this error. In this case, review the
    content of your `.envrc.ini`. If something seems wrong, then correct it in
    your `.envrc.ini`, else, if everything seems right for you, then you can
    simply delete `.direnv/.sha/.envrc.ini.sha1` and finally, you can activate
    your directory environment again.

[add_direnv_module]: tutorials/add_direnv_module.md
[error_activation]: #error-during-activation
[developers_guide]: {{ main_doc.online_url }}dev_guides/

## Upgrade

One of the main purpose of this project is to homogenize directory environment
to avoid copy/paste same scripts but with very little adjustments.

In order to do so, the project provide a script to automate the upgrade. The
script is installed the first time you activate your directory environment in
`.direnv/bin/upgrade_direnv`. Then, if you do not set variable
`add_direnv_to_path` to `false` for the `direnv_management` module (default is
`true`). Folder `.direnv/bin` is added to your `PATH`, making the script
available from the command line.

The script will clone the last release of the `direnv_template` project in
`.direnv/tmp/direnv_project`. Then will check which files are differents from
those already installed. If they differs, it means that there exist a new
version for the script. The script will then make a backup of the existing file
next to its previous location, before installing the new version.

Finally, to upgrade the your directory environment, you simply need to activate
the directory environment (see above section [Activate][activate]). Then simply
call the `upgrade_direnv` script:

```bash
# Upgrade your directory environment with last version of scripts
upgrade_direnv [options]
```

Available options for the scripts are:

  - `-s,--ssh`: Tell the script to clone the latest `direnv_template` using SSH.
  - `-h,--help`: Print the usage of the script

Normally, you should see output informing you which files are being upgraded.

[activate]: #activate

## Deactivate

To deactivate your directory environment, this will depend on the way you
activate it.

  - If you activate it using `direnv`, you have nothing to do. The directory
    environment will automatically be deactivated when leaving the directory.

  - If you activate it manually, when activating it, a new command is available
    `deactivate_direnv` (similarly to python `deactviate`). So to deactivate
    your directory environment you simply have to type the following command
    wherever you are:

    ```bash
    # From wherevere you are in your computer
    deactivate_direnv
    ```


<!-- Link URL used in multiple section -->
[direnv]: https://direnv.net
[modules]: modules/index.md
