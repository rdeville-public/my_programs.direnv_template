# Tutorials

If you want to contribute to the project, you are welcome. Please refer first to
the [Developers Guidelines][developers_guideline][^1].

Once done, you can check following tutorials as starting point:

  - [Add direnv module][add_direnv_module]
  - [Update documentation][update_documentation]
  - [Update CI][update_ci]

!!! remark
    Last two tutorials are for the main repo hosting all of my project
    documentations (i.e. [`{{ main_doc.name }}`][main_docs_repo]). All of my
    project use the same documentation and CI process. So do not forget to adapt
    the URL of the repo.

[^1]: If not available, please render main online documentation as described in
  [{{ git_platform.name }}-{{ main_doc.name}}][main_docs_repo]

[developers_guideline]: {{ main_doc.online_url }}dev_guides/contributing.html
[add_direnv_module]: add_direnv_module.md
[update_documentation]: {{ main_doc.online_url }}dev_guides/tutorials/update_documentation.html
[update_ci]: {{ main_doc.online_url}}dev_guides/tutorials/update_ci.html
[main_docs_repo]: {{ main_doc.repo_url }}