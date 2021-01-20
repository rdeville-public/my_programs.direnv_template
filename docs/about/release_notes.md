# Release notes

## v1.0.4

Write forgotten release note for v1.0.3.

## v1.0.3

Update build status link in README.md.

## v1.0.2

Fix rendering issues when integrated in main documentation on
[`docs.romaindeville.fr/my_programs/direnv_template`][repo_doc_url].

Fix issues related to `source_up` which overlapped `DIRENV_ROOT`. Now
`source_up` is done as soon as possible avoiding overlapping of direnv variable
of parent environment.

Update `tools/compute_sha1.sh` to be run without activated directory environment
and always printing logs.

[repo_doc_url]: {{ main_doc.online_url }}{{ direnv_template.repo_path_with_namespace }}

## v1.0.1

Hotfix on `setup.sh` which causes installation to failed and not printing any
log output.

## v1.0.0

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

## v0.1.0

First release of the **Direnv Template** repo with scripts examples and
documentation.
