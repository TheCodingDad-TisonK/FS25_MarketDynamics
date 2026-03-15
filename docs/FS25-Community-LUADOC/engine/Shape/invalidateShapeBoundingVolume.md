### invalidateShapeBoundingVolume

**Description**

> Makes sure the bounding volume of the shape is up to date with the geometry bounding volume.
> This needs to be called after changing the bounding volume of the geometry if the bounding volume of the shape is not
> invalidated otherwise (e.g. by moving)

**Definition**

> invalidateShapeBoundingVolume(entityId shapeId)

**Arguments**

| entityId | shapeId |
|----------|---------|