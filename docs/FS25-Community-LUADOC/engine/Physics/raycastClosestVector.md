### raycastClosestVector

**Description**

> Raycast closest rigid body object synchronously/blocking
> Callbacks will be performed before the function returns
> If the callback function returns true any possible following callbacks will be omitted

**Definition**

> raycastClosestVector(vector origin, vector direction, float maxDistance, string callbackFunctionName, object?
> callbackTargetObject, integer? collisionMask)

**Arguments**

| vector   | origin               |                                                                                                                         |
|----------|----------------------|-------------------------------------------------------------------------------------------------------------------------|
| vector   | direction            |                                                                                                                         |
| float    | maxDistance          |                                                                                                                         |
| string   | callbackFunctionName | raycastClosestCallback (nodeId, x,y,z, distance, nx,ny,nz, subShapeIndex, shapeId, isLast) -> boolean continueReporting |
| object?  | callbackTargetObject | [optional]                                                                                                              |
| integer? | collisionMask        | collisionMask [optional, default=ALL_BITS]                                                                              |

**Return Values**

| integer | numShapes | number of hit shapes, equal to number of performed callbacks |
|---------|-----------|--------------------------------------------------------------|