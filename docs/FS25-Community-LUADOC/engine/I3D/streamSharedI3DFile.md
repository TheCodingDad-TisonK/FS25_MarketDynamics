### streamSharedI3DFile

**Description**

> Stream shared I3D file. Can call the callback in the same callstack when the file is already loaded

**Definition**

> streamSharedI3DFile(string filename, string? callbackFunctionName, object? callbackTarget, object? arguments, boolean?
> addPhysics, boolean? callOnCreate, boolean? verbose)

**Arguments**

| string   | filename             | filename                                                                   |
|----------|----------------------|----------------------------------------------------------------------------|
| string?  | callbackFunctionName | callback(nodeId, LoadI3DFailedReason.* failedReason, arguments) [optional] |
| object?  | callbackTarget       | target [optional]                                                          |
| object?  | arguments            | arguments to return in callback function [optional]                        |
| boolean? | addPhysics           | addPhysics [optional]                                                      |
| boolean? | callOnCreate         | callOnCreate [optional]                                                    |
| boolean? | verbose              | verbose [optional]                                                         |

**Return Values**

| integer | requestId | request id for streaming, used to cancel the stream request |
|---------|-----------|-------------------------------------------------------------|