### createWheelShapeVector

**Description**

> Create wheel shape

**Definition**

> createWheelShapeVector(entityId transformId, vector position, float radius, float suspensionTravel, float spring,
> float damperCompressionLowSpeed, float damperCompressionHighSpeed, float damperCompressionLowSpeedThreshold, float
> damperRelaxationLowSpeed, float damperRelaxationHighSpeed, float damperRelaxationLowSpeedThreshold, float mass,
> integer
> collisionGroup, integer collisionMask, integer wheelShapeIndex)

**Arguments**

| entityId | transformId                        | transformId                                     |
|----------|------------------------------------|-------------------------------------------------|
| vector   | position                           |                                                 |
| float    | radius                             |                                                 |
| float    | suspensionTravel                   |                                                 |
| float    | spring                             |                                                 |
| float    | damperCompressionLowSpeed          |                                                 |
| float    | damperCompressionHighSpeed         |                                                 |
| float    | damperCompressionLowSpeedThreshold |                                                 |
| float    | damperRelaxationLowSpeed           |                                                 |
| float    | damperRelaxationHighSpeed          |                                                 |
| float    | damperRelaxationLowSpeedThreshold  |                                                 |
| float    | mass                               |                                                 |
| integer  | collisionGroup                     |                                                 |
| integer  | collisionMask                      |                                                 |
| integer  | wheelShapeIndex                    | wheelShapeIndex (if 0, will create a new wheel) |

**Return Values**

| integer | wheelShapeIndex |
|---------|-----------------|