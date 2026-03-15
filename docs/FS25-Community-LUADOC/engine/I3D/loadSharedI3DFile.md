### loadSharedI3DFile

**Description**

> Load shared I3D file. If another shared stream request is still pending for the same i3d, the call blocks until this
> request is finished

**Definition**

> loadSharedI3DFile(string filename, boolean? addPhysics, boolean? callOnCreate, boolean? verbose)

**Arguments**

| string   | filename     | filename                |
|----------|--------------|-------------------------|
| boolean? | addPhysics   | addPhysics [optional]   |
| boolean? | callOnCreate | callOnCreate [optional] |
| boolean? | verbose      | verbose [optional]      |

**Return Values**

| integer | rootNodeId   | rootNodeId               |
|---------|--------------|--------------------------|
| integer | requestId    | shared I3D request ID    |
| integer | failedReason | LoadI3DFailedReason code |