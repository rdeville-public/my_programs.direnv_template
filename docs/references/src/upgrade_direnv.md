# upgrade_direnv.sh

Upgrade current `.direnv` folder to the last release.

## Synopsis


./upgrade_direnv.sh [options]

## Description


SCRIPT WILL ONLY WORK WHEN DIRECTORY ENVIRONMENT IS ACTIVATED

Clone last release of `direnv_template` into `.direnv/tmp/direnv_template`.
Copy every files listed in variable `TO_UPGRADE` into their corresponding
folder in `.direnv`. Backup old version next to their new version (in case
something went wrong for the user.
Finally, delete clonned repo.

## Options


Available options to pass to the script are:

- `-s,--ssh`<br>
  Force cloning method to use SSH protocole



## check_git()

 **Ensure `git` is installed.**
 


 **Output**

 - Error message if `git` is not installed.

 **Returns**

 - 1 if `git` is not installed

## clone_direnv_repo()

 **Clone the latest version of `direnv_template` release to `.direnv/tmp/direnv_template`.**
 

 **Globals**

 - `DIRENV_TMP`
 - `DIRENV_CLONE_ROOT`
 - `CLONE_METHOD`
 - `SSH_GIT_URL`
 - `HTTPS_GIT_URL`

 **Output**

 - Information message to tell the user repos will be clonned.

 **Returns**

 - 1 if there is errro while cloning the repo.

## upgrade_file()

 **Compute SHA1 of old and new file and upgrade file if needed**
 
 Compute SHA1 of old and new file. If they differs, which means new file
 differs from the old one, backup the old file and replace it with the new
 file.

 **Globals**

 - `DIRENV_OLD`
 - `DIRENV_ROOT`
 - `DIRENV_CLONE_ROOT`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$1` |  string, path of file to upgrade |

 **Output**

 - Information message if new file replace an old one

## upgrade_direnv()

 **Method which recursively upgrade every old file to new one if needed**
 
 For every nodes (files and folders), if node is a folder, add list of files
 within this folders into a temporary array which is then passed recursively
 to this method.
 If node is a file, call `upgrade_file` method to upgrade this file if
 needed.

 **Globals**

 - `DIRENV_CLONE_ROOT`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$@` |  bash array, list of files and folder to upgrade |

## main()

 **Main method that run the upgrade direnv process.**
 
 Ensure git is installed, if git is installed, clone the latest release of
 direnv_template and upgrade old files to their latest release version while
 making a backup of the old file.

 **Globals**

 - `DIRENV_CLONE_ROOT`
 - `TO_UPGRADE`
 - `CLONE_METHOD`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$@` |  Possible options that can be passed to the script, see script docstring. |

 **Output**

 - Error message if clone of `direnv_template` went wrong.
 - Information message to inform user of the advancement of the process.

 **Returns**

 - 1 if something went wrong during upgrade process.
 - 0 if everything went right.
