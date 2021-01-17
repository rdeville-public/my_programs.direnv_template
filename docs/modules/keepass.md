# keepass
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
`${DIRENV_ROOT} to define path relatively. The database cannot be unlocked
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
