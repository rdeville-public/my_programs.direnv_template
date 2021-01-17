# ansible
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
