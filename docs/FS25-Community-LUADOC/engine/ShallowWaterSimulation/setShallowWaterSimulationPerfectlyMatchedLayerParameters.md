### setShallowWaterSimulationPerfectlyMatchedLayerParameters

**Description**

> Sets various parameters used for the perfectly matched layers algorithm

**Definition**

> setShallowWaterSimulationPerfectlyMatchedLayerParameters(entityId shallowWaterSimulation, float dampeningFactor, float
> lambdaUpdateFactor, float lambdaDecay, integer borderSize, boolean isCubicScaling, boolean leftBorder, boolean
> rightBorder, boolean bottomBorder, boolean topBorder)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                                                                                                                      |
|----------|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| float    | dampeningFactor        | controls how quickly and how strongly into the dampening region stuff is dampened.                                                                      |
| float    | lambdaUpdateFactor     | controls how quickly the dampening field changes over time. smaller values make the simulation more stable but may cause the dampening effect to worsen |
| float    | lambdaDecay            | controls how quickly the dampening field decays per simulation iteration (e.g. 0.9 -> dampening field strength reduce to 90% after one iteration)       |
| integer  | borderSize             | size of the dampening region in grid cells                                                                                                              |
| boolean  | isCubicScaling         | determines whether the dampening increases cubically from the start of the dampening border (false means it scales quadratically).                      |
| boolean  | leftBorder             | sets whether PML boundary condition is active for the left border of the simulation                                                                     |
| boolean  | rightBorder            | sets whether PML boundary condition is active for the right border of the simulation                                                                    |
| boolean  | bottomBorder           | sets whether PML boundary condition is active for the bottom border of the simulation                                                                   |
| boolean  | topBorder              | sets whether PML boundary condition is active for the top border of the simulation                                                                      |