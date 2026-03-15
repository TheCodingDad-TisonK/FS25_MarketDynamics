### raycastAllAsyncVector

**Description**

> Raycast rigid body objects asynchronously
> If the callback function returns true any possible following callbacks will be omitted

**Definition**

> raycastAllAsyncVector(vector origin, vector direction, float maxDistance, string callbackFunctionName, object?
> callbackTargetObject, integer? collisionMask)

**Arguments**

| vector   | origin               |                                                                                                                               |
|----------|----------------------|-------------------------------------------------------------------------------------------------------------------------------|
| vector   | direction            |                                                                                                                               |
| float    | maxDistance          |                                                                                                                               |
| string   | callbackFunctionName | raycastAllAsyncCallback (actorId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast) -> boolean continueReporting |
| object?  | callbackTargetObject | [optional]                                                                                                                    |
| integer? | collisionMask        | [optional]                                                                                                                    |