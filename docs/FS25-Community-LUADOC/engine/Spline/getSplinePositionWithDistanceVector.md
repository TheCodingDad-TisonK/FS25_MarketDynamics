### getSplinePositionWithDistanceVector

**Description**

> Get world space position and time on spline that has the given world space distance to the position on the spline at
> the given time

**Definition**

> getSplinePositionWithDistanceVector(integer shapeId, float time, float distance, boolean positiveTimeOffset, float
> eps)

**Arguments**

| integer | shapeId            |                                                                          |
|---------|--------------------|--------------------------------------------------------------------------|
| float   | time               |                                                                          |
| float   | distance           |                                                                          |
| boolean | positiveTimeOffset | search in positive or negative direction of t                            |
| float   | eps                | epsilon value in meters used for matching precision. Minimum value 0.001 |

**Return Values**

| vector | world |
|--------|-------|
| float  | time  |