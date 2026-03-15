### getLocalClosestSplinePositionVector

**Description**

> Get closest world space position and time on spline to given world space position

**Definition**

> getLocalClosestSplinePositionVector(integer shapeId, float time, float timeRange, vector world, float eps)

**Arguments**

| integer | shapeId   |                                                                          |
|---------|-----------|--------------------------------------------------------------------------|
| float   | time      |                                                                          |
| float   | timeRange | (searches in -/+ 0.5*range)                                              |
| vector  | world     |                                                                          |
| float   | eps       | epsilon value in meters used for matching precision. Minimum value 0.001 |

**Return Values**

| vector | world |
|--------|-------|
| float  | time  |