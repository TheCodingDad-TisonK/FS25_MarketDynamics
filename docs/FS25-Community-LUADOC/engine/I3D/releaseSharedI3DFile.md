### releaseSharedI3DFile

**Description**

> Reduces the ref count of the given shared i3d. Must be called for every successful loadSharedI3DFile and
> streamSharedI3DFile call to avoid memory leaks.

**Definition**

> releaseSharedI3DFile(integer requestId, boolean? warnIfInvalid)

**Arguments**

| integer  | requestId     | stream I3D request ID                                                      |
|----------|---------------|----------------------------------------------------------------------------|
| boolean? | warnIfInvalid | [optional] print a warning if the request ID is invalid, defaults to false |