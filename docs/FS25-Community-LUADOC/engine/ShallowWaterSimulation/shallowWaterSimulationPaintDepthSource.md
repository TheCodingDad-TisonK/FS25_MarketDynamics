### shallowWaterSimulationPaintDepthSource

**Description**

> Paints a custom depth source into the simulation. Depth sources make it so the depth in that area can never go below
> the specified value, acting like a source that pours out water until the surrounding area is filled to that level.

**Definition**

> shallowWaterSimulationPaintDepthSource(entityId shallowWaterSimulation, integer sourceIndex, float x, float y, float
> width, float height, float angle, float depth)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                                |
|----------|------------------------|-------------------------------------------------------------------|
| integer  | sourceIndex            | index of the source, starting at 0, up to 16 (currently)          |
| float    | x                      | x position of the rectangle center (world coordinates)            |
| float    | y                      | y position of the rectangle center (world coordinates)            |
| float    | width                  | width of the rectangle (world size)                               |
| float    | height                 | height of the rectangle (world size)                              |
| float    | angle                  | rotation angle of the rectangle (counter-clock wise, in radians). |
| float    | depth                  | depth of the water source                                         |