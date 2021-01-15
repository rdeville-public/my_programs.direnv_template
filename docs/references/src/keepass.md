# keepass.sh

`Keepassxc-cli` wrapper to ease the of CLI for database unlocked with key file.

## Synopsis


keepass.sh command [options]

## Description


THIS WRAPPER REQUIRES ENVIRONMENT VARIABLE `KEEPASS_DB` AND
`KEEPASS_KEYFILE` TO BE SET. IT IS RECOMMENDED TO USE IT WITH
[DIRENV](https://direnv.net).

The wrapper allow to use most `keepassxc-cli` command without requiring to
provide the `--no-password`, `--key-file <path>` or the keepass database
path as these information are stored with environment variables:

| Variables         | Description                                                    |
| :---------------: | :------------------------------------------------------------- |
| `KEEPASS_DB`      | Path to a keepass database, that must be unlocked by a keyfile |
| `KEEPASS_KEYFILE` | Path to a keyfile unlocking the keepass database               |


`keepassxc-cli` is the command line interface for the KeePassXC password
manager. It provides the abil‐ ity to query and modify the entries of a
KeePass database, directly from the command line.

## Commands


- `add [options] <entry>`<br>
  Adds a new entry to a database. A password can be generated (-g option),
  or a  prompt  can  be displayed  to  input  the password (-p option).  The
  same password generation options as docu‐ mented for the generate command
  can be used when the -g option is set.

- `analyze [options]`<br>
  Analyzes passwords in a database for weaknesses.

- `clip [options] <entry> [timeout]`<br>
  Copies the password or the current TOTP (-t option) of a database entry to
  the  clipboard.  If multiple entries with the same name exist in different
  groups, only the password for the first one is going to be copied. For
  copying the password of an entry in a specific group, the group path to
  the entry should be specified as well, instead of just the name.
  Optionally, a timeout in seconds can be specified to automatically clear
  the clipboard.

- `diceware [options]`<br>
  Generates a random diceware passphrase.

- `edit [options] <entry>`<br>
  Edits a database entry. A password can be generated (-g option), or a
  prompt can be  displayed to input the password (-p option).  The same
  password generation options as documented for the generate command can be
  used when the -g option is set.

- `estimate [options] [password]`<br>
  Estimates the entropy of a password. The password to estimate can be
  provided as a  positional argument, or using the standard input.

- `export [options]`<br>
  Exports the content of a database to standard output in the specified
  format (defaults to XML).

- `generate [options]`<br>
  Generates a random password.

- `help [command]`<br>
  Displays a list of available commands, or detailed information about the
  specified command.

- `import [options] <xml>`<br>
  Imports the contents of an XML database to the target database.

- `locate [options] <term>`<br>
  Locates all the entries that match a specific search term in a database.

- `ls [options] [group]`<br>
  Lists the contents of a group in a database. If no group is specified, it
  will default to  the root group.

- `mkdir [options] <group>`<br>
  Adds a new group to a database.

- `mv [options] <entry> <group>`<br>
  Moves an entry to a new group.

- `rm [options] <entry>`<br>
  Removes  an  entry from a database. If the database has a recycle bin, the
  entry will be moved there. If the entry is already in the recycle bin, it
  will be removed permanently.

- `rmdir [options] <group>`<br>
  Removes a group from a database. If the database has a recycle bin, the
  group  will  be  moved there. If the group is already in the recycle bin,
  it will be removed permanently.

- `show [options] <entry>`<br>
  Shows the title, username, password, URL and notes of a database entry.
  Can also show the cur‐ rent TOTP. Regarding the occurrence of multiple
  entries  with  the  same  name  in  different groups, everything stated in
  the clip command section also applies here.

## Options

### General options

 - `--debug-info`<br>
   Displays debugging information.

 - `-k, --key-file <path>`<br>
   Specifies  a  path to a key file for unlocking the database. In a merge
   operation this option, is used to specify the key file path for the first
   database.

 - `--no-password`<br>
   Deactivates the password key for the database.

 - `-y, --yubikey <slot>`<br>
   Specifies a yubikey slot for unlocking the database. In a merge operation
   this option is  used to specify the yubikey slot for the first database.

 - `-q, --quiet <path>`<br>
   Silences password prompt and other secondary outputs.

 - `-h, --help`<br>
   Displays help information.

 - `-v, --version`<br>
   Displays the program version.

### Merge options

 - `-d, --dry-run <path>`<br>
   Prints the changes detected by the merge operation without making any
   changes to the database.

 - `-f, --key-file-from <path>`<br>
   Sets the path of the key file for the second database.

 - `--no-password-from`<br>
   Deactivates password key for the database to merge from.

 - `--yubikey-from <slot>`<br>
   Yubikey slot for the second database.

 - `-s, --same-credentials`<br>
   Uses the same credentials for unlocking both databases.

### Add and edit options

 The  same password generation options as documented for the generate command
 can be used with those 2 commands when the -g option is set.

 - `-u, --username <username>`<br>
   Specifies the username of the entry.

 - `--url <url>`<br>
   Specifies the URL of the entry.

 - `-p, --password-prompt`<br>
   Uses a password prompt for the entry's password.

 - `-g, --generate`<br>
   Generates a new password for the entry.

### Edit options

 - `-t, --title <title>`<br>
   Specifies the title of the entry.

### Estimate options

 - `-a, --advanced`<br>
   Performs advanced analysis on the password.

### Analyze options

 - `-H, --hibp <filename>`<br>
   Checks if any passwords have been publicly leaked, by comparing  against
   the  given  list  of password  SHA-1  hashes, which must be in "Have I
   Been Pwned" format. Such files are available from
   https://haveibeenpwned.com/Passwords; note that they are large,  and  so
   this  operation typically takes some time (minutes up to an hour or so).

### Clip options

 - `-t, --totp`<br>
   Copies  the  current TOTP instead of current password to clipboard. Will
   report an error if no TOTP is configured for the entry.

### Show options

 - `-a, --attributes <attribute>...`<br>
   Shows the named attributes. This option can be specified more than once,
   with  each  attribute shown one-per-line in the given order. If no
   attributes are specified and -t is not specified, a summary of the default
   attributes is given.

 - `-t, --totp`<br>
   Also shows the current TOTP, reporting an error if no TOTP is configured
   for the entry.

### Diceware options

 - `-W, --words <count>`<br>
   Sets the desired number of words for the generated passphrase. [Default: 7]

 - `-w, --word-list <path>`<br>
   Sets the Path of the wordlist for the diceware generator. The wordlist
   must have > 1000 words, otherwise the program will fail. If the wordlist
   has < 4000 words a warning will be printed to STDERR.

### Export options

 - `-f, --format`<br>
   Format to use when exporting. Available choices are xml or csv. Defaults to xml.

### List options

 - `-R, --recursive`<br>
   Recursively lists the elements of the group.

 - `-f, --flatten`<br>
   Flattens the output to single lines. When this option is  enabled,
   subgroups  and  subentries will be displayed with a relative group path
   instead of indentation.

### Generate options

 - `-L, --length <length>`<br>
   Sets the desired length for the generated password. [Default: 16]

 - `-l --lower`<br>
   Uses lowercase characters for the generated password. [Default: Enabled]

 - `-U --upper`<br>
   Uses uppercase characters for the generated password. [Default: Enabled]

 - `-n --numeric`<br>
   Uses numbers characters for the generated password. [Default: Enabled]

 - `-s --special`<br>
   Uses special characters for the generated password. [Default: Disabled]

 - `-e --extended`<br>
   Uses extended ASCII characters for the generated password. [Default:
   Disabled]

 - `-x --exclude <chars>`<br>
   Comma-separated list of characters to exclude from the generated password.
   None is excluded by default.

 - `--exclude-similar`<br>
   Exclude similar looking characters. [Default: Disabled]

 - `--every-group`<br>
   Include characters from every selected group. [Default: Disabled]



## main()

 **main method doing the wrapper around keepassxc-cli**
 

 **Globals**

 - `KEEPASS_DB`
 - `KEEPASS_KEYFILE`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$1 string, command to pass to `keepassxc-cli`` | $1 string, command to pass to `keepassxc-cli` |
 | `$@ string, list of options to pass to `keepassxc-cli`` | $@ string, list of options to pass to `keepassxc-cli` |

 **Returns**

 - 1 If variable `KEEPASS_KEYFILE` or `KEEPASS_DB` is not set
 - 2 If file corresponding to variable `KEEPASS_KEYFILE` or `KEEPASS_DB` does not exists
 - 3 If user command is not supported by the wrapper
 - 4 If Command output is empty

### keepass_log()

> **Print debug message in colors depending on message severity on stderr**
> 
> Echo colored log depending on user provided message severity. Message
> severity are associated to following color output:
> 
>   - `DEBUG` print in the fifth colors of the terminal (usually magenta)
>   - `INFO` print in the second colors of the terminal (usually green)
>   - `WARNING` print in the third colors of the terminal (usually yellow)
>   - `ERROR` print in the third colors of the terminal (usually red)
>
> **Globals**
>
> - `ZSH_VERSION`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, message severity |
> | `$@` |  string, message content |
>
> **Output**
>
> - Log informations colored
>
