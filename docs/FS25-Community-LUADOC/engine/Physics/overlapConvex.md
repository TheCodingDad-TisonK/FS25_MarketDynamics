### overlapConvex

**Description**

> Overlap rigid body objects with an arbitrary convex mesh synchronously/blocking
> Callbacks will be performed before the function returns
> If the callback function returns true any possible following callbacks will be omitted, and no more work is done
> Note that a "dynamic" object is considered to be any object which is not static or kinematic
> Note that supplying false values to all of includeDynamics, includeKinematics and includeStatics will set them all to
> true

**Definition**

> overlapConvex(entityId shapeId, string callbackFunctionName, object? callbackTargetObject, integer? collisionMask,
> boolean? includeDynamics, boolean? includeKinematics, boolean? includeStatics, boolean? exactTest)

**Arguments**

| entityId | shapeId              | convex shape to use for overlap, has to have 'CPU Mesh' flag set                                         |
|----------|----------------------|----------------------------------------------------------------------------------------------------------|
| string   | callbackFunctionName | overlapConvexCallback(nodeId, subShapeIndex) -> boolean continueChecking                                 |
| object?  | callbackTargetObject | targetObject [optional]                                                                                  |
| integer? | collisionMask        | collisionMask [optional, default=ALL_BITS]                                                               |
| boolean? | includeDynamics      | includeDynamics [optional, default=true]                                                                 |
| boolean? | includeKinematics    | includeKinematics [optional, default=true]                                                               |
| boolean? | includeStatics       | includeStatics  [optional, default=true]                                                                 |
| boolean? | exactTest            | exactTest [optional, default=false] (Non-exact is not implemented yet and it will always use exact test) |

**Return Values**

| integer | numShapes | number of hit shapes, equal to number of performed callbacks |
|---------|-----------|--------------------------------------------------------------|