### raycastAllVector

**Description**

> Raycast rigid body objects synchronously
> Callbacks will be performed before the function returns
> If the callback function returns true any possible following callbacks will be omitted

**Definition**

> raycastAllVector(vector origin, vector direction, float maxDistance, string callbackFunctionName, object?
> callbackTargetObject, integer? collisionMask)

**Arguments**

| vector   | origin               |                                                                                                                         |
|----------|----------------------|-------------------------------------------------------------------------------------------------------------------------|
| vector   | direction            |                                                                                                                         |
| float    | maxDistance          |                                                                                                                         |
| string   | callbackFunctionName | raycastAllCallback(actorId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast) -> boolean continueReporting |
| object?  | callbackTargetObject | [optional]                                                                                                              |
| integer? | collisionMask        | [optional]                                                                                                              |

**Return Values**

| integer | numShapes | number of hit shapes, equal to number of performed callbacks |
|---------|-----------|--------------------------------------------------------------|