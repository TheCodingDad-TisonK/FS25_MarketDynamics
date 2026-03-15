### getStreamI3DFileProgressInfo

**Description**

> Get streaming I3D file progress information

**Definition**

> getStreamI3DFileProgressInfo(integer requestId)

**Arguments**

| integer | requestId | request id from streamI3DFile |
|---------|-----------|-------------------------------|

**Return Values**

| string | progress             | a string describing the progress                                                               |
|--------|----------------------|------------------------------------------------------------------------------------------------|
| float  | elapsedTime          | the elapsed time in seconds since the request was made                                         |
| string | filename             | the filename being loaded, or else ""                                                          |
| string | callbackFunctionName | the Lua callback name, or else the name of the C++ class that handles the callback, or else "" |
| object | callbackTarget       | the Lua callback target, or nil                                                                |
| object | args                 | the Lua callback arguments, or nil                                                             |