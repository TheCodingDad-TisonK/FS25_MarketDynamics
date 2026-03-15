### overlapCylinderAsyncVector

**Description**

> Overlap cylinder rigid body objects asynchronously
> If the callback function returns true any possible following callbacks will be omitted
> Note that a "dynamic" object is considered to be any object which is not static or kinematic
> Note that supplying false values to all of includeDynamics, includeKinematics and includeStatics will set them all to
> true

**Definition**

> overlapCylinderAsyncVector(vector center, float radius, float height, integer axis, string callbackFunctionName,
> object? callbackTargetObject, integer? collisionMask, boolean? includeDynamics, boolean? includeKinematics, boolean?
> includeStatics, boolean? exactTest)

**Arguments**

| vector   | center               |                                                                                                                                                                                  |
|----------|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| float    | radius               |                                                                                                                                                                                  |
| float    | height               |                                                                                                                                                                                  |
| integer  | axis                 | one of enum Axis                                                                                                                                                                 |
| string   | callbackFunctionName | overlapCylinderAsyncCallback(nodeId, subShapeIndex, isLast) -> boolean continueReporting                                                                                         |
| object?  | callbackTargetObject | [optional]                                                                                                                                                                       |
| integer? | collisionMask        | collisionMask [optional, default=ALL_BITS]                                                                                                                                       |
| boolean? | includeDynamics      | includeDynamics [optional, default=true]                                                                                                                                         |
| boolean? | includeKinematics    | includeKinematics [optional, default=true]                                                                                                                                       |
| boolean? | includeStatics       | includeStatics  [optional, default=true]                                                                                                                                         |
| boolean? | exactTest            | When true, the overlap uses the precise shape geometry (more accurate but slower). When false, the overlap uses the shapes AABB (faster but not exact) [optional, default=false] |