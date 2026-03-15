### getLocalClosestSplinePosition

**Description**

> Get closest world space position and time on spline to given world space position

**Definition**

> getLocalClosestSplinePosition(integer shapeId, float time, float timeRange, float worldX, float worldY, float worldZ,
> float eps)

**Arguments**

| integer | shapeId   | shapeId                                                                  |
|---------|-----------|--------------------------------------------------------------------------|
| float   | time      |                                                                          |
| float   | timeRange | (searches in -/+ 0.5*range)                                              |
| float   | worldX    |                                                                          |
| float   | worldY    |                                                                          |
| float   | worldZ    |                                                                          |
| float   | eps       | epsilon value in meters used for matching precision. Minimum value 0.001 |

**Return Values**

| float | worldX |
|-------|--------|
| float | worldY |
| float | worldZ |
| float | time   |