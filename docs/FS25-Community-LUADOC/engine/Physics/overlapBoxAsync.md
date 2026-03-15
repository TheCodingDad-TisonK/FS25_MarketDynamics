### overlapBoxAsync

**Description**

> Overlap box rigid body objects asynchronously
> If the callback function returns true any possible following callbacks will be omitted
> Note that a "dynamic" object is considered to be any object which is not static or kinematic
> Note that supplying false values to all of includeDynamics, includeKinematics and includeStatics will set them all to
> true

**Definition**

> overlapBoxAsync(float x, float y, float z, float rx, float ry, float rz, float ex, float ey, float ez, string
> callbackFunctionName, object? callbackTargetObject, integer? collisionMask, boolean? includeDynamics, boolean?
> includeKinematics, boolean? includeStatics, boolean? exactTest)

**Arguments**

| float    | x                    | x                                                                                                                                                                                |
|----------|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| float    | y                    | y                                                                                                                                                                                |
| float    | z                    | z                                                                                                                                                                                |
| float    | rx                   | rx                                                                                                                                                                               |
| float    | ry                   | ry                                                                                                                                                                               |
| float    | rz                   | rz                                                                                                                                                                               |
| float    | ex                   | ex                                                                                                                                                                               |
| float    | ey                   | ey                                                                                                                                                                               |
| float    | ez                   | ez                                                                                                                                                                               |
| string   | callbackFunctionName | overlapBoxAsyncCallback(nodeId, subShapeIndex, isLast) -> boolean continueReporting                                                                                              |
| object?  | callbackTargetObject | targetObject [optional]                                                                                                                                                          |
| integer? | collisionMask        | collisionMask [optional, default=ALL_BITS]                                                                                                                                       |
| boolean? | includeDynamics      | includeDynamics [optional, default=true]                                                                                                                                         |
| boolean? | includeKinematics    | includeKinematics [optional, default=true]                                                                                                                                       |
| boolean? | includeStatics       | includeStatics  [optional, default=true]                                                                                                                                         |
| boolean? | exactTest            | When true, the overlap uses the precise shape geometry (more accurate but slower). When false, the overlap uses the shapes AABB (faster but not exact) [optional, default=false] |