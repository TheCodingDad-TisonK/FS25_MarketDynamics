### raycastAllAsync

**Description**

> Raycast rigid body objects asynchronously
> If the callback function returns true any possible following callbacks will be omitted

**Definition**

> raycastAllAsync(float x, float y, float z, float nx, float ny, float nz, float maxDistance, string
> callbackFunctionName, object? callbackTargetObject, integer? collisionMask)

**Arguments**

| float    | x                    | x                                                                                                                             |
|----------|----------------------|-------------------------------------------------------------------------------------------------------------------------------|
| float    | y                    | y                                                                                                                             |
| float    | z                    | z                                                                                                                             |
| float    | nx                   | nx                                                                                                                            |
| float    | ny                   | ny                                                                                                                            |
| float    | nz                   | nz                                                                                                                            |
| float    | maxDistance          | maxDistance                                                                                                                   |
| string   | callbackFunctionName | raycastAllAsyncCallback (actorId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast) -> boolean continueReporting |
| object?  | callbackTargetObject | targetObject [optional]                                                                                                       |
| integer? | collisionMask        | collisionMask [optional]                                                                                                      |