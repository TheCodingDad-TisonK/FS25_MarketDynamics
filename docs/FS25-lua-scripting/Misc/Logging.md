## Logging

**Description**

> This class handles all logging

**Functions**

- [error](#error)
- [fatal](#fatal)
- [i3dError](#i3derror)
- [i3dInfo](#i3dinfo)
- [i3dWarning](#i3dwarning)
- [info](#info)
- [warning](#warning)
- [xmlError](#xmlerror)
- [xmlInfo](#xmlinfo)
- [xmlWarning](#xmlwarning)

### error

**Description**

> Prints an error to console and logfile, prepends 'Error:'

**Definition**

> error(string errorMessage, any ...)

**Arguments**

| string | errorMessage | the warning message. Can contain string-format placeholders               |
|--------|--------------|---------------------------------------------------------------------------|
| any    | ...          | variable number of parameters. Depends on placeholders in warning message |

### fatal

**Description**

> Prints an fatal error to console and logfile and stops the game. To be used for unrecoverable errors only

**Definition**

> fatal(string fatalMessage, any ...)

**Arguments**

| string | fatalMessage | the error message. Can contain string-format placeholders               |
|--------|--------------|-------------------------------------------------------------------------|
| any    | ...          | variable number of parameters. Depends on placeholders in fatal message |

### i3dError

**Description**

> Prints an i3d node error to console and logfile, prepends 'Error ( ()):'

**Definition**

> i3dError(entityId node, string errorMessage, any ...)

**Arguments**

| entityId | node         | i3d node entityId to include in the output                              |
|----------|--------------|-------------------------------------------------------------------------|
| string   | errorMessage | the error message. Can contain string-format placeholders               |
| any      | ...          | variable number of parameters. Depends on placeholders in error message |

### i3dInfo

**Description**

> Prints an i3d node info to console and logfile, prepends 'Info ( ()):'

**Definition**

> i3dInfo(entityId node, string infoMessage, any ...)

**Arguments**

| entityId | node        | i3d node entityId to include in the output                                |
|----------|-------------|---------------------------------------------------------------------------|
| string   | infoMessage | the warning message. Can contain string-format placeholders               |
| any      | ...         | variable number of parameters. Depends on placeholders in warning message |

### i3dWarning

**Description**

> Prints an i3d node warning to console and logfile, prepends 'Warning ( ()):'

**Definition**

> i3dWarning(entityId node, string warningMessage, any ...)

**Arguments**

| entityId | node           | i3d node entityId to include in the output                                |
|----------|----------------|---------------------------------------------------------------------------|
| string   | warningMessage | the warning message. Can contain string-format placeholders               |
| any      | ...            | variable number of parameters. Depends on placeholders in warning message |

### info

**Description**

> Prints an info to console and logfile, prepends 'Info:'

**Definition**

> info(string infoMessage, any ...)

**Arguments**

| string | infoMessage | the warning message. Can contain string-format placeholders               |
|--------|-------------|---------------------------------------------------------------------------|
| any    | ...         | variable number of parameters. Depends on placeholders in warning message |

### warning

**Description**

> Prints a warning to console and logfile, prepends 'Warning:'

**Definition**

> warning(string warningMessage, any ...)

**Arguments**

| string | warningMessage | the warning message. Can contain string-format placeholders               |
|--------|----------------|---------------------------------------------------------------------------|
| any    | ...            | variable number of parameters. Depends on placeholders in warning message |

### xmlError

**Description**

> Prints a xml error to console and logfile, prepends 'Error ():'

**Definition**

> xmlError(table|integer|string xmlFile, string errorMessage, any ...)

**Arguments**

| table  | integer      | string                                                                  | xmlFile | xml file object or xml handle |
|--------|--------------|-------------------------------------------------------------------------|---------|-------------------------------|
| string | errorMessage | the error message. Can contain string-format placeholders               |         |                               |
| any    | ...          | variable number of parameters. Depends on placeholders in error message |         |                               |

### xmlInfo

**Description**

> Prints a xml info to console and logfile, prepends 'Info ():'

**Definition**

> xmlInfo(table|integer|string xmlFile, string infoMessage, any ...)

**Arguments**

| table  | integer     | string                                                                    | xmlFile | xml file object or xml handle |
|--------|-------------|---------------------------------------------------------------------------|---------|-------------------------------|
| string | infoMessage | the warning message. Can contain string-format placeholders               |         |                               |
| any    | ...         | variable number of parameters. Depends on placeholders in warning message |         |                               |

### xmlWarning

**Description**

> Prints a xml warning to console and logfile, prepends 'Warning ():'

**Definition**

> xmlWarning(table|integer|string xmlFile, string warningMessage, any ...)

**Arguments**

| table  | integer        | string                                                                    | xmlFile | xml file object or xml handle |
|--------|----------------|---------------------------------------------------------------------------|---------|-------------------------------|
| string | warningMessage | the warning message. Can contain string-format placeholders               |         |                               |
| any    | ...            | variable number of parameters. Depends on placeholders in warning message |         |                               |