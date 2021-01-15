# go


## Description
Export `GOPATH` to directory environment to install GO modules locally to
the directory environment if not defined by the user in `.envrc.ini`. Also
created `pkg`, `src` and `bin`. Make every binary already installed in the
`GOPATH` acessible from the command line by creating a symlinks to
`.direnv/bin/` for each of them.

TODO @rdeville: Write go module management

Parameters in `.envrc.ini` are:

TODO @rdeville: Write go module management in below array

| Name     | Description                                                               |
| :------- | :------------------------------------------------------------------------ |
| `GOPATH` | (optional) Absolute path to the go directory, default is `.direnv/tmp/go` |


## Parameters

### `GOPATH`

Absolute path where the go directory will be created. Default is set to
`${DIRENV_ROOT}/.direnv/tmp/go. User can use path contraction like `~`,
`${HOME}` or ``${DIRENV_ROOT}``

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Go management module
# ------------------------------------------------------------------------------
# Update GOPATH to install go modules locally
[go_management]
# Specify the path to the go directory
GOPATH="${DIRENV_ROOT}/.direnv/tmp/go"
```
