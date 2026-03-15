### createPlaneShapeFrom2DContour

**Description**

> Create plane shape from 2D contour

**Definition**

> createPlaneShapeFrom2DContour(string name, floatArray contour2DWorldPositions, boolean? createRigidBody)

**Arguments**

| string     | name                    | name of the shape entity                                                   |
|------------|-------------------------|----------------------------------------------------------------------------|
| floatArray | contour2DWorldPositions | format {x1,z1, x2,z2, x3,z3, ...}, minimum of 6 values (3 points) required |
| boolean?   | createRigidBody         | [optional] defaults to false                                               |

**Return Values**

| entityId | shape |
|----------|-------|