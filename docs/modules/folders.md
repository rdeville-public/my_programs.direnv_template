# folders


## Description
Ensure list of specified folders provided by the user exists. If not, then
create these folders.

Parameters in `.envrc.ini` are:

| Name       | Description                                                    |
| :--------- | :------------------------------------------------------------- |
| `new`      | Path of the folder that must exists relative to `DIRENV_ROOT`  |

## Parameters

### `new`

Path, relative to `DIRENV_ROOT` that must exists. Can be used multiple time
to specify multiple folders to create. If parent directory does not exists
it will be created.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Folder module
# ------------------------------------------------------------------------------
# Ensure new folders exists
[folders]
# Specify folders which must exist, if not they will be created. Path
# relative to `DIRENV_ROOT`.
new=tmp/folder_1
new=tmp/folder_2
```
