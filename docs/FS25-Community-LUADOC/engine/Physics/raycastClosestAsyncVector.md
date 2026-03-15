### raycastClosestAsyncVector

**Description**

> Raycast closest rigid body object asynchronously
> If the callback function returns true any possible following callbacks will be omitted

**Definition**

> raycastClosestAsyncVector(vector origin, vector direction, float maxDistance, string callbackFunctionName, object?
> callbackTargetObject, integer? collisionMask)

**Arguments**

| vector   | origin               |                                                                                                                      |
|----------|----------------------|----------------------------------------------------------------------------------------------------------------------|
| vector   | direction            |                                                                                                                      |
| float    | maxDistance          |                                                                                                                      |
| string   | callbackFunctionName | raycastClosestAsync(actorId, x,y,z, distance, nx,ny,nz, subShapeIndex, shapeId, isLast) -> boolean continueReporting |
| object?  | callbackTargetObject | [optional]                                                                                                           |
| integer? | collisionMask        | collisionMask [optional, default=ALL_BITS]                                                                           |