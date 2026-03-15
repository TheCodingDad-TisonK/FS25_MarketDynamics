### setShapeGeometryBoundingSphere

**Description**

> Set the bounding sphere of the shape's geometry.
> Warning: This does not update the bounding volumes of other shapes using this geometry. Those are only updated if they
> are invalided, e.g. by moving the shape or calling invalidShapeBoundingVolume

**Definition**

> setShapeGeometryBoundingSphere(entityId shapeId, float localPosX, float localPosY, float localPosZ, float radius)

**Arguments**

| entityId | shapeId   |
|----------|-----------|
| float    | localPosX |
| float    | localPosY |
| float    | localPosZ |
| float    | radius    |