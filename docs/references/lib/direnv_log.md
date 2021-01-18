# direnv_log.sh

Print debug message in colors depending on message severity on stderr

## Description

THIS SCRIPT SHOULD BE USED AS LIBRARY SCRIPT

Best use is to source this file to define `direnv_log` method. Print log
depending on message severity, such as:

  - `DEBUG` print in the fifth color of the terminal (usually magenta)
  - `INFO` print in the second color of the terminal (usually green)
  - `WARNING` print in the third color of the terminal (usually yellow)
  - `ERROR` print in the third color of the terminal (usually red)



## direnv_log()

 **Print debug message in colors depending on message severity on stderr**
 
 Echo colored log depending on user provided message severity. Message
 severity are associated to following color output:
 
   - `DEBUG` print in the fifth colors of the terminal (usually magenta)
   - `INFO` print in the second colors of the terminal (usually green)
   - `WARNING` print in the third colors of the terminal (usually yellow)
   - `ERROR` print in the third colors of the terminal (usually red)
 
 If no message severity is provided, severity will automatically be set to
 INFO.

 **Globals**

 - `ZSH_VERSION`

 **Arguments**

 | Arguments | Description |
 | :-------- | :---------- |
 | `$1` |  string, message severity or message content |
 | `$@` |  string, message content |

 **Output**

 - Log informations colored
