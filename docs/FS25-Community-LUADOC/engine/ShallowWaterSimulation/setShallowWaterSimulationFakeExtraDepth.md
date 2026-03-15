### setShallowWaterSimulationFakeExtraDepth

**Description**

> Sets a fake height that is added to the terrain height below the water rest level. This makes the water deeper than it
> really is, which causes waves to move faster and be deeper. For visual tuning purposes.

**Definition**

> setShallowWaterSimulationFakeExtraDepth(entityId shallowWaterSimulation, float height)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation            |
|----------|------------------------|-----------------------------------------------|
| float    | height                 | fake height to add below the water rest level |