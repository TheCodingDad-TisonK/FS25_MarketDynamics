### drawDebugArrow

**Description**

> Render an arrow. Only use for debug rendering

**Definition**

> drawDebugArrow(float x, float y, float z, float dirX, float dirY, float dirZ, float tangX, float tangY, float tangZ,
> float r, float g, float b, boolean? solid)

**Arguments**

| float    | x     | x                                                                                                                           |
|----------|-------|-----------------------------------------------------------------------------------------------------------------------------|
| float    | y     | y                                                                                                                           |
| float    | z     | z                                                                                                                           |
| float    | dirX  | dirX                                                                                                                        |
| float    | dirY  | dirY                                                                                                                        |
| float    | dirZ  | dirZ                                                                                                                        |
| float    | tangX | tangX                                                                                                                       |
| float    | tangY | tangY                                                                                                                       |
| float    | tangZ | tangZ                                                                                                                       |
| float    | r     | r                                                                                                                           |
| float    | g     | g                                                                                                                           |
| float    | b     | b                                                                                                                           |
| boolean? | solid | [optional] true: depth is checked and point can be hidden behind other meshes; false: always rendered on top (default=true) |