### overlapBoxVector

**Description**

> Overlap box rigid body objects synchronously/blocking
> Callbacks will be performed before the function returns
> If the callback function returns true any possible following callbacks will be omitted, and no more work is done
> Note that a "dynamic" object is considered to be any object which is not static or kinematic
> Note that supplying false values to all of includeDynamics, includeKinematics and includeStatics will set them all to
> true

**Definition**

> overlapBoxVector(vector center, vector rotation, vector halfExtents, string callbackFunctionName, object?
> callbackTargetObject, integer? collisionMask, boolean? includeDynamics, boolean? includeKinematics, boolean?
> includeStatics, boolean? exactTest)

**Arguments**

| vector   | center               |                                                                                                                                                                                  |
|----------|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| vector   | rotation             |                                                                                                                                                                                  |
| vector   | halfExtents          |                                                                                                                                                                                  |
| string   | callbackFunctionName | overlapBoxCallback(nodeId, subShapeIndex) -> boolean continueChecking                                                                                                            |
| object?  | callbackTargetObject | [optional]                                                                                                                                                                       |
| integer? | collisionMask        | collisionMask [optional, default=ALL_BITS]                                                                                                                                       |
| boolean? | includeDynamics      | includeDynamics [optional, default=true]                                                                                                                                         |
| boolean? | includeKinematics    | includeKinematics [optional, default=true]                                                                                                                                       |
| boolean? | includeStatics       | includeStatics  [optional, default=true]                                                                                                                                         |
| boolean? | exactTest            | When true, the overlap uses the precise shape geometry (more accurate but slower). When false, the overlap uses the shapes AABB (faster but not exact) [optional, default=false] |

**Return Values**

| integer | numShapes | number of hit shapes, equal to number of performed callbacks |
|---------|-----------|--------------------------------------------------------------|