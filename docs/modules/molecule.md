# molecule
Export molecule variables

## Description

Export variable `MOLECULE_NO_LOG` to tell molecule to show logs even if
molecule log should be hidden.

Parameters in `.envrc.ini` are:

| Name               | Description                                        |
| :----------------- | :------------------------------------------------- |
| `MOLECULE_NO_LOG`  | Boolean for molecule to show log (default `false`) |

## Parameters

### `MOLECULE_NO_LOG`

Force molecule to show logs from internal molecule playbooks, even when they
have no log set to `true`. See on
[Stackoverflow](https://stackoverflow.com/questions/58917757/how-to-set-no-log-true-for-molecule-internal-playbook-tasks)

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Molecule module
# ------------------------------------------------------------------------------
# Set molecule environment variable
[molecule]
# Explicitly tell molecule to show all log
MOLECULE_NO_LOG=1
```
