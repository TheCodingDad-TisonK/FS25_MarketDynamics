### getSharedI3DFileRefCount

**Description**

> Gets the number references a shared I3D file has

**Definition**

> getSharedI3DFileRefCount(string filename)

**Arguments**

| string | filename |
|--------|----------|

**Return Values**

| integer | refCount | Number of references for the shared i3d. Smaller than 0 if file is not loaded or loading. Can be 0 when the file is still loaded (e.g. due to a releaseSharedI3DFile call with autoDelete = false). |
|---------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|