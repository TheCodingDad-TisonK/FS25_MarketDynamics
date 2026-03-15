### shallowWaterSimulationPaintVelocityRect

**Description**

> Adds velocity into the simulation in the shape of a rectangle.

**Definition**

> shallowWaterSimulationPaintVelocityRect(entityId shallowWaterSimulation, float x, float y, float width, float height,
> float velocityX, float velocityY, float? paintHeight)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                                                                                     |
|----------|------------------------|------------------------------------------------------------------------------------------------------------------------|
| float    | x                      | x position of the rectangle center (world coordinates)                                                                 |
| float    | y                      | y position of the rectangle center (world coordinates)                                                                 |
| float    | width                  | width of the rectangle (world size)                                                                                    |
| float    | height                 | height of the rectangle (world size)                                                                                   |
| float    | velocityX              | value to be added to the x component of velocity                                                                       |
| float    | velocityY              | value to be added to the y component of velocity                                                                       |
| float?   | paintHeight            | [optional] height that the paint should happen at. will only be painted if waterHeight in that location >= paintHeight |