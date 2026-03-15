### createWheelShape

**Description**

> Create wheel shape

**Definition**

> createWheelShape(entityId transformId, float positionX, float positionY, float positionZ, float radius, float
> suspensionTravel, float spring, float damperCompressionLowSpeed, float damperCompressionHighSpeed, float
> damperCompressionLowSpeedThreshold, float damperRelaxationLowSpeed, float damperRelaxationHighSpeed, float
> damperRelaxationLowSpeedThreshold, float mass, integer collisionGroup, integer collisionMask, integer wheelShapeIndex)

**Arguments**

| entityId | transformId                        | transformId                                     |
|----------|------------------------------------|-------------------------------------------------|
| float    | positionX                          | positionX                                       |
| float    | positionY                          | positionY                                       |
| float    | positionZ                          | positionZ                                       |
| float    | radius                             | radius                                          |
| float    | suspensionTravel                   | suspensionTravel                                |
| float    | spring                             | spring                                          |
| float    | damperCompressionLowSpeed          | damperCompressionLowSpeed                       |
| float    | damperCompressionHighSpeed         | damperCompressionHighSpeed                      |
| float    | damperCompressionLowSpeedThreshold | damperCompressionLowSpeedThreshold              |
| float    | damperRelaxationLowSpeed           | damperRelaxationLowSpeed                        |
| float    | damperRelaxationHighSpeed          | damperRelaxationHighSpeed                       |
| float    | damperRelaxationLowSpeedThreshold  | damperRelaxationLowSpeedThreshold               |
| float    | mass                               | mass                                            |
| integer  | collisionGroup                     | collisionGroup                                  |
| integer  | collisionMask                      | collisionMask                                   |
| integer  | wheelShapeIndex                    | wheelShapeIndex (if 0, will create a new wheel) |

**Return Values**

| integer | wheelShapeIndex | wheelShapeIndex |
|---------|-----------------|-----------------|