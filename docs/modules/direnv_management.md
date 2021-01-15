# direnv_management


## Description
**Only work when loaded using [`direnv`](https://direnv.net).**

Export variable to define the verbosity of the directory environment when
loading it and source parent directory environment.

Parameters in `.envrc.ini` are:

| Name                   | Description                                                                                        |
| :--------------------- | :------------------------------------------------------------------------------------------------- |
| `DIRENV_DEBUG_LEVEL`   | Select the level of verbosity                                                                      |
| `source_up`            | If set to `true` (default: `false`), load parent directory environment when loaded using `direnv`  |

## Parameters

### `DIRENV_DEBUG_LEVEL`

Export `DIRENV_DEBUG_LEVEL` if defined by the user. `DIRENV_DEBUG_LEVEL` can
have following values in severity order:

- `DEBUG`
- `INFO`
- `WARNING`
- `ERROR` (default)

Depending on the value set, will show log corresponding to this value and
values above. For instance, if value is set to `INFO`, log with `DEBUG`
severity while others log will be printed.

### `source_up`

If directory environment activated using `direnv` and user specify to, i.e.
set `source_up=true`, source parent directory environment

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Direnv management module
# ------------------------------------------------------------------------------
# Simple module to load parent direnv configuration. Only work when using
# `direnv`
[direnv_management]
# When activated using `direnv`, tell `direnv to load parent directory
# environment
source_up=false
# Set the output log to `DEBUG`, `INFO`, `WARNING` or `ERROR` (default)
DIRENV_DEBUG_LEVEL="DEBUG"
```
