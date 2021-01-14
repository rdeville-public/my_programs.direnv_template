<div align="center" style="text-align: center;">

  <!-- Project Title -->
  <a href="https://framagit.org/rdeville.public/my_programs/direnv_template/">
    <img src="docs/assets/img/direnv_template_logo.png" width="100px">
    <h1>Direnv Template</h1>
  </a>

  <!-- Project Badges -->
  [![License][license_badge]][license]
  [![Build Status][build_status_badge]][build_status]

--------------------------------------------------------------------------------

Project to manage Directory Environment (either manually or using
[`direnv`][direnv]) uniformly for all my projects.

--------------------------------------------------------------------------------

  <b>
IMPORTANT !

Main repo is on [ Framagit][repo_url].<br>
On other online git platforms, they are just mirror of the main repo.<br>
Any issues, pull/merge requests, etc., might not be considered on those other
platforms.
  </b>
</div>

--------------------------------------------------------------------------------

[repo_url]: https://framagit.org/rdeville.public/my_programs/direnv_template
[license_badge]: https://img.shields.io/badge/Licence-GPLv3-informational?style=flat-square&logo=appveyor
[license]: LICENSE
[build_status_badge]: https://gitlab.liris.cnrs.fr/pagoda/tools/direnv_template/badges/master/pipeline.svg?style=flat-square&logo=appveyor
[build_status]: https://gitlab.liris.cnrs.fr/pagoda/tools/direnv_template/commits/master

## Table of Content

* [Introduction](#introduction)
* [Render documentation locally](#render-documentation-locally)

## Introduction

This repo aims to help managing directory environment uniformly accross multiple
project. Management of directory environment (i.e. activation and deactivation)
can be done manually or using [`direnv`][direnv].

**What is a directory environment ?**

What we call a directory environment is a set of environment variables, binary,
scripts, etc., that should only be configured when working on a specific
project (i.e. in a specific folder and its subfolder).

For instance, if you use python virtualenv and OpenStack. Usually, when
starting to work, you often may enter the following command:

```bash
  # Load OpenStack project variable
  source openrc.sh
  # Activate python virtual environment
  source .venv/bin/activate
```

This will setup OpenStack related variable and Python Virtual environment
related variable as well as the method `deactivate` to deactivate the python
virtual environment.

Both of these are directory related process, usually you do not want these values
to be set when on another directory.

So to conclude this description, basically this repo will help you to setup your
directory to:
  - Automate these command to setup environment variable and methods when
    entering directories in which you want these varaible set
  - Automate unsetting these variables and methods when leaving the directory.

This can be achieve manually (by sourcing the right file) or by using
[direnv][direnv]. [`direnv`][direnv] is an extension for your shell. It augments
existing shells with a new feature that can load and unload environment
variables depending on the current directory.

In other terms, if a script `.envrc` is present in a folder and allowed for
`direnv`, it will automatically be executed when entering the folder. When
leaving the folder any exported variables will be automatically unloaded.

The complete description of this repos, as well as many more information such as
use of modules, description of the configuration file, etc., is available on a
dedicated website, see [Direnv Template Online
Documentation][direnv_template_online_doc].

If [Direnv Template Online Documentation][direnv_template_online_doc] is not
accessible, you can render the online documentation locally on your computer,
see section [Render documentation locally](#render-documentation-locally)

**Why this repo since there is [direnv][direnv] ?**

Since some times now, I use [direnv][direnv] to manage my directory environment.
Nevertheless, I was tired to always rewrite or copy/paste the same base scripts,
then adapt them for each of my working directory. This repo is here to help
managing the directory environment script in a homogeneous manner. Now, I do not
need to rewrite or copy/paste the base scripts. All of my repos have the same
scripts (i.e. modules) and I configure them using a `.envrc.ini` file.

[direnv]: https://direnv.net

## Render documentation locally

**IMPORTANT !!**

If, for any reason, the link to the [Direnv Template Online
Documentation][direnv_template_online_doc] is broken, you can generate this
documention locally on your computer (since the documentation is jointly stored
within the repository).

To do so, you will need the following requirements:

  - Python >= 3.8
  - Pip3 with Python >= 3.8

First setup a temporary python virtual environment and activate it:

```bash
# Create the temporary virtual environment
python3 -m venv .temporary_venv
# Activate it
source .temporary_venv/bin/activate
```
Now, install required dependencies to render the documentation using mkdocs in
the python virtual environment:

```bash
pip3 install -r requirements.docs.txt
```

Now you can easily render the documentation using [mkdocs][mkdocs] through the
usage of the following command (some logs will be outputed to stdout):

```bash
# Assuming you are at the root of the repo
mkdocs serve -f mkdocs.local.yml
```

You can now browse the full documentation by visiting
[http://localhost:8000][localhost].

[mkdocs]: https://www.mkdocs.org/
[localhost]: https://localhost:8000

<!-- Links used multiple times in multiple sections -->
[direnv_template_online_doc]: https://docs.romaindeville.fr/my_dotfiles/direnv_template/index.html
