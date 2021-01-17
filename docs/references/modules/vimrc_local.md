# vimrc_local.sh

Setup a `.vimrc.local` file at the root of the directory

## Description


From file `.direnv/templates/vimrc.template.local` and provided variables in
`.envrc.ini` create `.vimrc.local` file which defines some configuration
vim configuration local to the repo.

!!! important
    To be able to use this module you will need to add following lines in
    your `.vimrc`:

    ```vim
    if filereadable(".vimrc.local")
      source .vimrc.local
    endif
    ```

!!! important
    This module also requires you to install some vim plugins with your
    favorite vim plugins manager:

    - [vim-glissues](https://github.com/sirjofri/vim-glissues)<br>
      Vim gitlab issues.

Parameters in `.envrc.ini` are:

<center>

| Name                    | Description                                                                         |
| :---------------------- | :---------------------------------------------------------------------------------- |
| `vim_gitlab_token`      | Gitlab API access token                                                             |
| `vim_gitlab_server`     | URL to your gitlab server                                                           |
| `vim_gitlab_project_id` | ID of your project in your gitlab server                                            |
| `vim_gitlab_alter`      | (optional) Should the plugin send altering requests to the server? (default `true`) |
| `vim_gitlab_debug`      | (optional) Print debug message (default `false`)                                    |

</center>


## Parameters

### `vim_gitlab_token`

The API access token with at least `read_only` access to be able to access
issues from all projects and groups. To avoid showing its value in your
`.envrc.ini`, as for all value, you can use `cmd:` prefix to specify a
command to retrieve the API token.

### `vim_gitlab_server`

The URL of your gitlab server of the form `http(s)://domain.tld`.

### `vim_gitlab_project_id`

The ID of your project in your gitlab server. Normally, `vim-glissues`
plugin should be able to determine it automatically, but I encountered
issues with this. So it is better to set it manuall.

### `vim_gitlab_alter`

Boolean, default `true`, to tell if the `vim-glissues` plugin should alter
requests to the server.

### `vim_gitlab_debug`

Boolean, default `false`, to tell if the `vim-glissues` plugin should print
debug information.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# vimrc_local module
# ------------------------------------------------------------------------------
# Write a `.vimrc.local` file at the root of the directory
[vimrc_local]
# Gitlab API access token
vim_gitlab_token=cmd: cat my_file_with_api_token
# URL to your gitlab server
vim_gitlab_server=https://my.gitlab.tld
# ID of your project in your gitlab server
vim_gitlab_project_id=12345
# (optional) Should the plugin send altering requests to the server? (default `true`)
vim_gitlab_alter=true
# (optional) Print debug message (default `false`)
vim_gitlab_debug=false
```



## vimrc_local()

 **Generate `.vimrc.local` file**
 
 Generate a `.vimrc.local` file from `.envrc.ini` which defines some
 local vim configuration.

 **Globals**

 - `DIRENV_ROOT`
 - `DIRENV_TEMPLATE_FOLDER`

 **Returns**

 - 1 if some vimrc_local required variables are not defined
 - 0 if the module is correctly loaded

### eval_vimrc_local_var()

> **Ensure required vimrc_local variables are defined**
> 
> For every vimrc_local variables required, ensure their values are set.
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
