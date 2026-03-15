### createSplineFromEditPoints

**Description**

> Creates a new spline entity from the given edit points.

**Definition**

> createSplineFromEditPoints(entityId parentId, floatArray editPoints, boolean? makeLinearSpline, boolean? isClosed)

**Arguments**

| entityId   | parentId         | The id of the entity which should be the parent of the newly created spline.                                                                                                                                                         |
|------------|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| floatArray | editPoints       | A list of edit point coordinates. Each edit point is defined by three consecutive coordinates (x, y, z). The number of supplied coordinates must be divisible by three. At least two edit points (six coordinates) must be supplied. |
| boolean?   | makeLinearSpline | If true, the newly created spline is of linear type. Otherwise its of cubic type. [optional, default=false]                                                                                                                          |
| boolean?   | isClosed         | If true, the newly created spline is closed. Otherwise its open. [optional, default=false]                                                                                                                                           |

**Return Values**

| entityId | objectId | The id of the newly created spline entity. |
|----------|----------|--------------------------------------------|