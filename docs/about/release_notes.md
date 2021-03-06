# Release notes

## v1.1

### v1.1.6

Multiple bugfixes:

  - Load tmuxinator only if there is `tmuxinator_*=` variable in `.envrc.ini`.
  - Add nerd-font tmuxinator template.
  - Update tmux session management if not using tmuxinator.
  - Fix issues in upgrade_direnv scripts where SHA1 of file was computed for non
    existing file leading to error message printed to stderr.
  - Update SHA1 of modified files.

### v1.1.5

Fix upgrade_direnv.sh script to create dest directory first for new files.
Update SHA1 of modified files.

### v1.1.4

Fix bug in setup.sh and upgrade_direnv.sh scripts to avoid cloning twice the
repo when upgrading using setup.sh script.
Update SHA1 of modified files.

### v1.1.3

Fix bug in setup.sh with upgrading not working due to typo.
Fix bug in upgrade_direnv.sh do not show error when moving files

### v1.1.2

Fix bug in setup.sh with upgrading not working due to not cloning git repo.
Update SHA1 of modified files

### v1.1.1

Fix shellcheck warnings

### v1.1.0

Upgrade documentation to use
[mkdocs_template](https://framagit.org/rdeville.public/my_programs/mkdocs_template).

Add [tmuxinator](https://github.com/tmuxinator/tmuxinator) support to the module
`tmux_management`.

Update/generate documentation accordingly.

## v1.0

??? info "Releases >=1.0.0"

    ### v1.0.10

    Minor update:

      - Update all python dependencies in requirements files
      - Update repo description in `_data/direnv_template.yaml`
      - Update docs/index.md to use this description
      - Update forgotten SHA1 sum

    ### v1.0.9

    Fix shellcheck warning on tmux_management

    ### v1.0.8

    Drop support of `command` parameter for the `tmux_management` module as it did
    not work as expected (i.e. command is not executed, it is just sent to the
    session).

    Update `tmux_management` module docstring and generate new documentation
    accordingly.

    ### v1.0.7

    Fix link to repo online documentation in the README.md which pointed to a wrong
    page.

    Fix tmux_management module which did not uses variable of the `.envrc.ini` file
    as described in the module docstring.

    ### v1.0.6

    Fix regex in `setup.sh` and `upgrade_direnv.sh` to not include `*/.` and `*/..`
    entry in `for` loop

    ### v1.0.5

    Update license badge on README.md

    ### v1.0.4

    Write forgotten release note for v1.0.3.

    ### v1.0.3

    Update build status link in README.md.

    ### v1.0.2

    Fix rendering issues when integrated in main documentation on
    [`{{ site_base_url }}{{ direnv_template.url_slug_with_namespace }}`][repo_doc_url].

    Fix issues related to `source_up` which overlapped `DIRENV_ROOT`. Now
    `source_up` is done as soon as possible avoiding overlapping of direnv variable
    of parent environment.

    Update `tools/compute_sha1.sh` to be run without activated directory environment
    and always printing logs.

    [repo_doc_url]: {{ site_base_url }}{{ direnv_template.url_slug_with_namespace }}

    ### v1.0.1

    Hotfix on `setup.sh` which causes installation to failed and not printing any
    log output.

    ### v1.0.0

    First release of the project with:

      - Setup and upgrade scripts
      - Support of `bash` and `zsh`
      - Multiple modules supported
        - Ansible
        - Direnv management
        - folders
        - Go Management
        - Keepass
        - Kubernetes
        - Molecule
        - Openstack
        - Packer
        - Path Management
        - Python Management
        - Tmux Management
        - Vimrc Local
      - Security ensure required files have not been modified
      - Online documentation integrated with the main documentation at
       [docs.romaindeville.fr](https://docs.romaindeville.fr)
      - Minimal CI to ensure code is well formatted, documented and to build and
        deploy the documentation

## v0.0

??? info "Release >=0.0.0"

    ### v0.1.0

    First release of the **Direnv Template** repo with scripts examples and
    documentation.
