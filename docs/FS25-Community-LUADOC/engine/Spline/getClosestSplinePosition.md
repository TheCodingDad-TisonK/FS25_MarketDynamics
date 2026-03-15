### getClosestSplinePosition

**Description**

> Get closest world space position and time on spline to given world space position

**Definition**

> getClosestSplinePosition(integer shapeId, float worldX, float worldY, float worldZ, float eps)

**Arguments**

| integer | shapeId |                              |
|---------|---------|------------------------------|
| float   | worldX  |                              |
| float   | worldY  |                              |
| float   | worldZ  |                              |
| float   | eps     | acceptable world space error |

**Return Values**

| float | worldX |
|-------|--------|
| float | worldY |
| float | worldZ |
| float | time   |