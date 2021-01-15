# packer
Export packer variables

## Description

Export variable `PACKER_LOG` and `PACKER_LOG_PATH` to tell packer to print
log and where to print them.

Parameters in `.envrc.ini` are:

| Name             | Description                                         |
| :--------------- | :-------------------------------------------------- |
| `PACKER_LOG`     | Either 0 or 1 (default) to tell packer to print log |
| `PACKER_LOG_PATH | Absolute path to the file where log will be printed |

## Parameters

### `PACKER_LOG`

Either 0 or 1 (default). If set to 1, tell packer to print log. If set to 0,
tell packer to not print log, in this case, `PACKER_LOG_PATH` is useless.

### `PACKER_LOG_PATH`

Absolute path to where packer log will be stored. Value can use contraction
such as `~`, `${HOME}` or `${DIRENV_ROOT}`.

If this value is not set in `.envrc.ini`, default is set to
`.direnv/log/packer.log`

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Packer module
# ------------------------------------------------------------------------------
# Set packer environment variable
[packer]
# Activate packer log
PACKER_LOG=1
# Set where packer log will be outputed
PACKER_LOG_PATH=path/to/packer.log
```
