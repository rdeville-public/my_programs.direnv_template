<div align="center" style="text-align: center;">

  <!-- Project Title -->
  <a href="https://framagit.org/rdeville.public/my_programs/direnv_template/">
    <img src="./docs/assets/img/direnv_template_logo.png" width="100px">
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

[localhost]: https://localhost:8000

<!-- Links used multiple times in multiple sections -->
[direnv_template_online_doc]: https://docs.romaindeville.fr/my_dotfiles/direnv_template/index.html
<!-- vim-markdown-toc GitLab -->

<!-- vim-markdown-toc -->
