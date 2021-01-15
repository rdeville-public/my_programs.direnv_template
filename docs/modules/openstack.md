# openstack


## Description
Export variables `OS_*` required to be able to connect to openstack via
python openstack client.

`OS_*` variables are obtains with the `openrc.sh` file you can get from your
openstack instance.

Also setup a script to easily manage multiple openstack project within the
same directory. This is done directly in the `.envrc.ini` file using
`[openstack]` section to define the default project (used only during the
initialisation of the directory environment) then using
`[openstack:project_name]` section to configure per project openstack
variable.

The setup of the script is a symlink from `.direnv/src/select_openstack.sh`
to `.direnv/bin/select_openstack` allowing you to use command
`select_openstack`. This command will ask you which project you want to
activate.

If you want to hide some values in `.envrc.ini`, such as `OS_PASSWORD`, you
can start the value of this variable to `cmd:` followed by a command which
echo the content of the password. For instance `cmd:cat file_storing_os_password`

REMARK: There is not default value set for any `OS_*` variable.

Parameters in `.envrc.ini` are:

| Name                       | Description                                     |
| :------------------------- | :---------------------------------------------- |
| `default`                  | Name of the default openstack project           |
| `OS_AUTH_URL`              | Value of `OS_AUTH_URL` in openrc.sh             |
| `OS_PROJECT_ID`            | Value of `OS_PROJECT_ID` in openrc.sh           |
| `OS_PROJECT_NAME`          | Value of `OS_PROJECT_NAME` in openrc.sh         |
| `OS_INTERFACE`             | Value of `OS_INTERFACE` in openrc.sh            |
| `OS_REGION_NAME`           | Value of `OS_REGION_NAME` in openrc.sh          |
| `OS_IDENTITY_API_VERSION`  | Value of `OS_IDENTITY_API_VERSION` in openrc.sh |
| `OS_USER_DOMAIN_NAME`      | Value of `OS_USER_DOMAIN_NAME` in openrc.sh     |
| `OS_USERNAME`              | Value of `OS_USERNAME` in openrc.sh             |
| `OS_PASSWORD`              | Password to connect to the openstack` instance  |

## Parameters

###  `default`

Name of the default openstack project used during the first initialisation
of the directory environment. The current configured project will be saved
into `.direnv/tmp/openstack.envrc`. When updating current project, using
script `select_openstack`, value of `.direnv/tmp/openstack.envrc` will be
updated.

### `OS_AUTH_URL`

Value of openstack variable OS_AUTH_URL in openrc.sh. Usually, the HTTPS URL
of your openstack instance.

### `OS_PROJECT_ID`

Value of openstack variable OS_PROJECT_ID in openrc.sh Usually a hash
composed of alpha numerical characters.

### `OS_PROJECT_NAME`

Value of openstack variable OS_PROJECT_NAME in openrc.sh.

### `OS_INTERFACE`

Value of openstack variable OS_INTERFACE in openrc.sh.

### `OS_REGION_NAME`

Value of openstack variable OS_REGION_NAME in openrc.sh.

### `OS_IDENTITY_API_VERSION`

Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh.

### `OS_USER_DOMAIN_NAME`

Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh.

### `OS_USERNAME`

Value of openstack variable OS_USERNAME in openrc.sh.

### `OS_PASSWORD`

Password to connect to the openstack instance.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
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
# specified after `¢md:`. In the example below, parser will execute command
# `echo "foo"`, so value of OS_PASSWORD will be `foo`
OS_PASSWORD=cmd:echo "foo"
# Value of openstack variable OS_INTERFACE in openrc.sh
OS_INTERFACE=interface
# Value of openstack variable OS_REGION_NAME in openrc.sh
OS_REGION_NAME=region_name
# Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh
OS_IDENTITY_API_VERSION=3
# Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh
OS_USER_DOMAIN_NAME=domain_name

# Configuration for each openstack project
[openstack:project_config_name_2]
# Value of openstack variable OS_AUTH_URL in openrc.sh
OS_AUTH_URL=https://test.com
# Value of openstack variable OS_PROJECT_ID in openrc.sh
OS_PROJECT_ID=4321
# Value of openstack variable OS_PROJECT_NAME in openrc.sh
OS_PROJECT_NAME=project_name_2
# Value of openstack variable OS_USERNAME in openrc.sh
OS_USERNAME=username
# Value of openstack variable OS_PASSWORD in openrc.sh, to avoid setup a value
# in clear text, as for any other value in this ini file, start the value with
# `cmd:` to tell the parser that value will be obtain by executing the command
# specified after `¢md:`. In the example below, parser will execute command
# `echo "bar"`, so value of OS_PASSWORD will be `bar`
OS_PASSWORD=cmd:echo "bar"
# Value of openstack variable OS_INTERFACE in openrc.sh
OS_INTERFACE=interface
# Value of openstack variable OS_REGION_NAME in openrc.sh
OS_REGION_NAME=region_name
# Value of openstack variable OS_IDENTITY_API_VERSION in openrc.sh
OS_IDENTITY_API_VERSION=3
# Value of openstack variable OS_USER_DOMAIN_NAME in openrc.sh
OS_USER_DOMAIN_NAME=domain_name
```
