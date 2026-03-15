### shallowWaterSimulationPaintDepthRect

**Description**

> Adds depth into the simulation in the shape of a rectangle

**Definition**

> shallowWaterSimulationPaintDepthRect(entityId shallowWaterSimulation, float x, float y, float width, float height,
> float value, float? paintHeight)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                                                                                     |
|----------|------------------------|------------------------------------------------------------------------------------------------------------------------|
| float    | x                      | x position of the rectangle center (world coordinates)                                                                 |
| float    | y                      | y position of the rectangle center (world coordinates)                                                                 |
| float    | width                  | width of the rectangle (world size)                                                                                    |
| float    | height                 | height of the rectangle (world size)                                                                                   |
| float    | value                  | to be added to depth (can be negative for removing water)                                                              |
| float?   | paintHeight            | [optional] height that the paint should happen at. will only be painted if waterHeight in that location >= paintHeight |