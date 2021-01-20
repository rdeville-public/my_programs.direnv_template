# Tutorials

If you want to contribute to the project, you are welcome. Please refer first to
the [Developers Guide][developers_guide].

Once done, you can check following tutorials as starting point:

  - [Add direnv module][add_direnv_module]
  - [Update documentation][update_documentation]
  - [Update CI][update_ci]

!!! remark
    Last two tutorials are for the main repo hosting all of my project
    documentations (i.e. [`{{ main_doc.repo_name }}`][main_docs_repo]). All of my
    project use the same documentation and CI process. So do not forget to adapt
    the URL of the repo.

[developers_guide]: {{ main_doc.online_url }}dev_guides/
[add_direnv_module]: add_direnv_module.md
[update_documentation]: {{ main_doc.online_url }}dev_guides/tutorials/update_documentation.html
[update_ci]: {{ main_doc.online_url}}dev_guides/tutorials/update_ci.html
[main_docs_repo]: {{ git_platform.url }}{{ main_doc.repo_path_with_namespace }}