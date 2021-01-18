# Modules

Modules are part of `direnv_template` which run tasks related to a specific
environment, for instance module `ansible` will only execute task related to
`ansible`, etc.

## List of exisitng modules

<center>

| Module Name | Description |
| :---------- | :---------- |
| [ansible](ansible.md) | Setup ansible configuration file and tree architecture |
| [direnv_management](direnv_management.md) | Activate the direnv management module |
| [folders](folders.md) | Ensure specified folder exists, if not create them. |
| [go_management](go_management.md) | Export GO variables to install go modules locally |
| [keepass](keepass.md) | Setup keepass wrapper script and variable to ease use of keepassxc-cli |
| [kubernetes](kubernetes.md) | Export kubernetes variables |
| [molecule](molecule.md) | Export molecule variables |
| [openstack](openstack.md) | Export openstack variables for python openstackclient |
| [packer](packer.md) | Export packer variables |
| [path_management](path_management.md) | Update `PATH` variable with user defined folder |
| [python_management](python_management.md) | Setup a complete python virtual environment |
| [tmux_management](tmux_management.md) | Start and attach a tmux session |
| [vimrc_local](vimrc_local.md) | Setup a `.vimrc.local` file at the root of the directory |

</center>
