### setShallowWaterSimulationGroundHeightTextureFromTerrain

**Description**

> Manually sets ground height texture from a terrain transform group. The terrain transform group has to remain alive
> for the time the Shallow Water Simulation is alive.
> When the simulation has a terrain-based ground height texture, the simulation fetches the terrain height correctly
> based on the world position set from shallowWaterSimulationSetWorldPosition
> as well as the physical grid size set when the simulation was created.

**Definition**

> setShallowWaterSimulationGroundHeightTextureFromTerrain(entityId shallowWaterSimulation, integer
> terrainTransformGroup)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation                |
|----------|------------------------|---------------------------------------------------|
| integer  | terrainTransformGroup  | transform group/id to get the height texture from |