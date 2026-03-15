### setShapeBones

**Description**

> Set the bones of the shape given the new root node. The hierarchy of the new bones must be mostly the same as for the
> currently set bones. Additional children after the used bones are allowed. Bones are matched by node indices and not
> by
> name.
> The new root newRootBoneId must match with oldRootBoneId or the currently assigned root (lowest common root node of
> all bones) if oldRootBoneId is 0.

**Definition**

> setShapeBones(entityId shapeId, entityId newRootBoneId, entityId oldRootBoneId, boolean? keepBindPoses)

**Arguments**

| entityId | shapeId       | shapeId                                                                                                                      |
|----------|---------------|------------------------------------------------------------------------------------------------------------------------------|
| entityId | newRootBoneId | The roof the new skeleton                                                                                                    |
| entityId | oldRootBoneId | The root of the currently assigned skeleton. If 0, the lowest common root node of the currently assigned bones is used       |
| boolean? | keepBindPoses | If true, the bind poses of the current bones are kept, otherwise the new bones are assumed to be in the bind pose [optional] |

**Return Values**

| boolean | success |
|---------|---------|