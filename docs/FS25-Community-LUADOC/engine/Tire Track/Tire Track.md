### addTrackPoint

**Description**

> Adds a tire track position

**Definition**

> addTrackPoint(entityId tyreTrackSystem, integer trackId, float x, float y, float z, float ux, float uy, float uz,
> float r, float g, float b, float a, float bumpiness, float dTheta, boolean terrainOnly, float colorBlendWithTerrain)

**Arguments**

| entityId | tyreTrackSystem       | tyreTrackSystem                                                                                     |
|----------|-----------------------|-----------------------------------------------------------------------------------------------------|
| integer  | trackId               | trackId                                                                                             |
| float    | x                     | x coordinate                                                                                        |
| float    | y                     | y coordinate                                                                                        |
| float    | z                     | z coordinate                                                                                        |
| float    | ux                    | up direction x                                                                                      |
| float    | uy                    | up direction y                                                                                      |
| float    | uz                    | up direction z                                                                                      |
| float    | r                     | red                                                                                                 |
| float    | g                     | green                                                                                               |
| float    | b                     | blue                                                                                                |
| float    | a                     | alpha                                                                                               |
| float    | bumpiness             |                                                                                                     |
| float    | dTheta                | wheel dTheta/dT (used to determine forward/backward motion of wheel)                                |
| boolean  | terrainOnly           | omit from geometry (only render on terrain)                                                         |
| float    | colorBlendWithTerrain | defines how the color should be blended with the terrain (0:100% terrain color, 1:0% terrain color) |