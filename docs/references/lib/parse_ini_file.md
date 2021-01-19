# parse_ini_file.sh

Load configuration file `.envrc.ini` and store values in associative arrays

## Description

THIS SCRIPT SHOULD BE USED AS LIBRARY SCRIPT

Best use is to source this file to define `parse_ini_file` method.

Parse line by line a simple `.ini` file, for each section, create an
associative array per section which store key and value of the `.ini` file.



## parse_ini_file()

 **Parse a simple `.ini` file and stre values in associative arrays.**
 
 Parse line by line a `.ini` file, if a section tag is encountered, create an
 associative array from the name of the section and store each key, value
 pair in this associative array.
 
 For instances:
 
 ```ini
 [section_name]
 # Comment
 key_1 = foo
 key_2 = bar
 ```
 
 Will result on the creation of the bash associative array `${section_name}`
 with two key,value pair accessible as shown below:
 
 ```bash
 echo ${section_name[key_1]}
 Will echo foo
 echo ${section_name[key_2]}
 Will echo bar
 ```

 **Globals**

 - `DIRENV_INI_SEP`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$0` |  string, path to the `.ini` config file to parse |

### parse_ini_section()

> **Parse a simple `.ini` file and stre values in associative arrays.**
> 
> Parse line by line a `.ini` file, if a section tag is encountered, create an
> associative array from the name of the section and store each key, value
> pair in this associative array.
> Space ` ` in section name will be replaced by underscore `_`.
> 
> For instances:
> 
> ```ini
> [section name]
> # Comment
> key_1 = foo
> key_2 = bar
> ```
> 
> Will result on the creation of the bash associative array `${section_name}`
> with two key,value pair accessible as shown below:
> 
> ```bash
> echo ${section_name[key_1]}
> # Will echo foo
> echo ${section_name[key_2]}
> # Will echo bar
> ```
>
> **Globals**
>
> - `DIRENV_INI_SEP`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$0` |  string, path to the `.ini` config file to parse |
>
>

### parse_ini_value()

> **Parse line key, value provided as argument from an `.ini` file**
> 
> Parse a single line provided as first argument from an `.ini`, i.e. of the
> following form:
> 
> ```ini
> # This is a comment
> key=value
> key =value
> key= value
> key = value
> ```
> 
> Others form are not supported !
> Once the line is parse, if value start with `cmd:`, this means that value
> is obtain from a command provided, execute the command to have the value.
> store the pair key, value into the associative
> array corresponding to the section provided as second argument.
> 
> If there already exist an entry for the key in the associative array, the
> new value will be concatenate with the old value using `${DIRENV_INI_SEP}`
> as separator to be able to easily split the string later in the
> corresponding module.
>
> **Globals**
>
> - `DIRENV_INI_SEP`
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, line to parse |
> | `$2` |  string, name of the module where key, value will be stored |
>
>

### parse_ini_line()

> **Determine if a line define a section or a pair key, value**
> 
> Determine if line provided as argument define a section, then call method
> `parse_ini_section`, else if line determine a pair key, value, call method
> `parse_ini_value`.
>
>
> **Arguments**
>
> | Arguments | Description |
> | :-------- | :---------- |
> | `$1` |  string, line to parse |
> | `$2` |  string, name of the last section (i.e. module) parsed |
>
>
