# ansible.sh

Setup ansible configuration file and tree architecture

## Description

From file `.direnv/templates/ansible.template.cfg` and provided variables in
`.envrc.ini` create `ansible.cfg` file which defines some configuration
override. User can also specify multiple ansible configuration, like
`prod` and `dev`.

Install the script `select_ansible.sh` to easily switch ansible
configuration to use. This is done directly in the `.envrc.ini` file using
`[ansible]` section to define the default project (used only during the
initialisation of the directory environment) then using
`[ansible:config_name]` section to configure per project ansible
configuration.

The setup of the script is a symlink from `.direnv/src/select_ansible.sh`
to `.direnv/bin/select_ansible` allowing you to use command
`select_ansible`. This command will ask you which project you want to
activate.

Also setup a script `clone_ansible_roles.py` from .direnv/src to .direnv/bin
to clone roles and collection from an ansible galaxy requirements file using
git.


Parameters in `.envrc.ini` are:

<center>

| Name             | Description                               |
| :--------------- | :---------------------------------------- |
| `default`        | Name of the default ansible configuration |
| `ANSIBLE_CONFIG` | Path to the `ansible.cfg file`            |
| `inventory`      | (optional) Path to the inventory          |

</center>


## Parameters

### `default`

Name of the default ansible configuration used during the first
initialisation of the directory environment. The current configuration
will be saved into `.direnv/tmp/ansible.envrc`. When updating current
ansible configuration, using script `select_ansible`, value of
`.direnv/tmp/ansible.envrc` will be updated.


### `ANSIBLE_CONFIG`

Path to the where the `ansible.cfg` and name of it. Variable also exported
to tell ansible which configuration to use. For instance
`ANSIBLE_CONFIG="${DIRENV_ROOT}/${OS_PROJECT_NAME}.ansible.cfg` will make
the module to create a file "${DIRENV_ROOT}/${OS_PROJECT_NAME}.ansible.cfg"
from the template. So when usin ansible, this file will be used.

**REMARK**: In the example above, path to `ANSIBLE_CONFIG` use variables
from other modules, be sure these module are loaded before ansible module,
otherwise this will not work.

**REMARK**: In the example above, path to `ANSIBLE_CONFIG` uses variables
from other modules, which may implicitly create multiple ansible
configuration. For instance, if you have defined multiple openstack project,
this may create two multiple ansible configuration, one per openstack
project when you update current openstack project.

### `inventory`

Path to where the inventory will be stored. This variable will be used
during the generation of `ansible.cfg` file.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Ansible module
# ------------------------------------------------------------------------------
# Set ansible environment variable
[ansible]
# Choose the default configuration for the first initialisation
default_config="config_name_1"

[ansible:config_name_1]
# Set the path to ansible configuration file. If this file does not exists, it
# will be created from template in .direnv/templates/ansible.cfg.template
ANSIBLE_CONFIG="/path/to/ansible.cfg"
# Path to inventory file or folder
inventory="${DIRENV_ROOT}/inventory"
```



## ansible()

 **Export variables for ansible module and generate configuration file**
 
 Generate and `ansible.cfg` file from `.envrc.ini` which defines some
 configuration override.
 
 Install usefull script in `.direnv/bin` to easy management of galaxy
 collection and roles and changement of ansible context.

 **Globals**

 - `ANSIBLE_CONFIG`

 **Returns**

 - 1 if some ansible required variables are not defined
 - 0 if the module is correctly loaded

### install_ansible_script()

> **Install ansible script to select the current ansible config**
> 
> Install following symlink:
> 
>   - `.direnv/src/select_ansible.sh` to `.direnv/bin/select_ansible`
>   - `.direnv/src/clone_ansible_roles.py` to `.direnv/bin/clone_ansible_roles`
>
> **Globals**
>
> - `DIRENV_BIN_FOLDER`
> - `DIRENV_SRC_FOLDER`
>
>

### save_default_ansible_config()

> **Save the default ansible configuration name during first init**
> 
> If default ansible project is defined in `.envrc.ini`, save the name of
> this configuration into `.direnv/tmp/ansible.envrc`.
>
> **Globals**
>
> - `DIRENV_TEMP_FOLDER`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, name of the default ansible project |
>
> **Output**
>
> - Name of the current ansible configuration
>
>

### eval_ansible_var()

> **Ensure required ansible variables are defined**
> 
> For every ansible variables required, ensure their values are set.
> 
> REMARK: This method does not test their validity.
>
>
> **Output**
>
> - Error information if a variable is not defined.
>
> **Returns**
>
> - 1 if at least one variable is not defined
> - 0 if every variables are defined
>
>

## deactivate_ansible()

 **Unset exported variables for ansible module**
 

 **Globals**

 - `ANSIBLE_CONFIG`
