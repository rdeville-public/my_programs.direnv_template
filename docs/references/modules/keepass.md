# keepass.sh

Setup keepass wrapper script and variable to ease use of keepassxc-cli

## Description

Install a symlink from `.direnv/src/keepass.sh` to `.direnv/bin/keepass` to
be able to use script wrapper as keepass command. Also export some required
variable used by the script. Finally ensure that exported variables are
valid, i.e. the keepass database can be unlocked using keepass keyfile.

REMARK: Keepass script require a keepass database that is unlocked by a
file, not by a password !

Parameters in `.envrc.ini` are:

<center>

| Name               | Description                                                                                             |
| :----------------- | :------------------------------------------------------------------------------------------------------ |
| `KEEPASS_DB`       | Absolute path to a keepassxc database                                                                   |
| `KEEPASS_KEYFILE`  | Absolute path to a file to unlock keepassxc database                                                    |
| `KEEPASS_NAME`     | (optional) Explicit name for the database, like `perso`, `pro`, etc., which can be used in your prompt  |

</center>

## Parameters

### `KEEPASS_DB`

Absolute path to a keepassxc database, you can use `~`, `${HOME}` or even
`${DIRENV_ROOT}` to define path relatively. The database cannot be unlocked
with password when using script `keepass.sh`, be sure to configure it to be
unlocked using file.

### `KEEPASS_KEYFILE`

Absolute path to the file that unlock the keepass database defined in
`KEEPASS_DB`.

### `KEEPASS_NAME`

An explicit name, like `perso`, `pro`, etc. Useless for script `keepass.sh`.
It is export only to be used in your prompt (like in `PS1`). If not set,
value of this variable will be the filename of the `KEEPASS_DB`.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Keepass module
# ------------------------------------------------------------------------------
# Set keepassxc environment variable to be able to use the keepassxc-cli wrapper
# provided in `.direnv/src/keepass.sh`.
[keepass]
# Specify the path to the keypass database
KEEPASS_DB=/path/to/keepass.db
# Specify the path to the keyfile unlocking the keepass database
KEEPASS_KEYFILE=/another/path/to/keyfile
# Specify an explicit name in an environment variable to be able to use it in
# your shell prompt.
KEEPASS_NAME=Perso
```



## keepass()

 **Install keepass wrapper and export keepass variable required for wrapper**
 
 Install a symlink from `.direnv/src/keepass.sh` to `.direnv/bin/keepass` to
 be able to use script wrapper as keepass command. Also export some required
 variable used by the script. Finally ensure that exported variables are
 valid, i.e. the keepass database can be unlocked using keepass keyfile.

 **Globals**

 - `KEEPASS_DB`
 - `KEEPASS_KEYFILE`
 - `KEEPASS_NAME`

 **Output**

 - Log information

 **Returns**

 - 1 if required variables are not set or if database can not be unlocked
 - 0 if everything is right and database can be unlocked

### install_keepass_script()

> **Install keepass wrapper script**
> 
> Install a symlink from `.direnv/src/keepass.sh` to `.direnv/bin/keepass`
> to be able to use script wrapper as keepass command.
>
> **Globals**
>
> - `DIRENV_BIN_FOLDER`
> - `DIRENV_SRC_FOLDER`
>
>

### check_variable()

> **Ensure variables are defined**
> 
> Ensure the value provided as second argument is not null. First argument
> is the name of the variable associated with the value.
>
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, name of the variable to check |
> | `$2` |  string, value of the variable to check |
>
> **Output**
>
> - Error log when variable value is not set
>
> **Returns**
>
> - 1 if variable value is not set
> - 0 if variable value is set
>
>

### check_file()

> **Ensure file defined by variable exists**
> 
> Ensure the value provided as second argument is a file that exists. First
> argument is the name of the variable associated with the file path.
>
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, name of the variable which hold the path to a file |
> | `$2` |  string, path of the file that must exists |
>
> **Output**
>
> - Error log when file does not exists
>
> **Returns**
>
> - 1 if file does not exists
> - 0 if file does exists
>
>

## deactivate_keepass()

 **Unset exported variables for keepass module**
 
 Unset `KEEPASS_*` variable previously exported.

 **Globals**

 - `KEEPASS_DB`
 - `KEEPASS_KEYFILE`
 - `KEEPASS_NAME`
