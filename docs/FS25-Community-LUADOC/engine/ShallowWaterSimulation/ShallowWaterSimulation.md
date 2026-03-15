### createShallowWaterSimulation

**Description**

> Creates a shallow water simulation

**Definition**

> createShallowWaterSimulation(string name, integer gridWidth, integer gridHeight, float physicalWidth, float
> physicalHeight, boolean? useHeightDisplacement)

**Arguments**

| string   | name                  | name                                                                                                                                                                                                                                    |
|----------|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| integer  | gridWidth             | Number of simulation grid cells in the x direction                                                                                                                                                                                      |
| integer  | gridHeight            | Number of simulation grid cells in the y direction                                                                                                                                                                                      |
| float    | physicalWidth         | Physical (world) width of the whole grid                                                                                                                                                                                                |
| float    | physicalHeight        | Physical (world) height/length of the whole grid                                                                                                                                                                                        |
| boolean? | useHeightDisplacement | [optional] Determines whether the simulation will make use of the height displacement of the water surface for rendering. Setting this to false assumes the output will only be used to modify water surface normals. Defaults to false |

**Return Values**

| entityId | shallowWaterSimulationId | ID of the created simulation |
|----------|--------------------------|------------------------------|