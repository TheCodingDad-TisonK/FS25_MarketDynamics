### shallowWaterSimulationPaintDepthCircle

**Description**

> Adds depth into the simulation in the shape of a circle

**Definition**

> shallowWaterSimulationPaintDepthCircle(entityId shallowWaterSimulation, float x, float y, float radius, float value,
> float? paintHeight)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                                                                                     |
|----------|------------------------|------------------------------------------------------------------------------------------------------------------------|
| float    | x                      | x position of the circle center (world coordinates)                                                                    |
| float    | y                      | y position of the circle center (world coordinates)                                                                    |
| float    | radius                 | radius of the circle (world size)                                                                                      |
| float    | value                  | to be added to depth (can be negative for removing water)                                                              |
| float?   | paintHeight            | [optional] height that the paint should happen at. will only be painted if waterHeight in that location >= paintHeight |