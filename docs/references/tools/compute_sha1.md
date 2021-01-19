# compute_sha1.sh

Recursively compute SHA1 sum of a list of files and folders

## Synopsis

./compute_sha1.sh

## Description

THIS SCRIPT WILL ONLY WORK IF DIRECTORY ENVIRONMENT IS ACTIVATED !

The script will compute SHA1 sum of every required files for directory
environment and store these SHA1 into the corresponding file in `.sha1`
folder with the same architecture.



## main()

 **Ensure directory environment is activated an run SHA1 sum computation**
 

 **Globals**

 - `DIRENV_ROOT`

 **Output**

 - Error informations

 **Returns**

 - 1 if directory environment is not activated
 - 0 if everything went right
