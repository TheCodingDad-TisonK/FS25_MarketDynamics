### setShallowWaterSimulationWorldPosition

**Description**

> Sets (2D) world position of the simulation (x and z coordinates). If a height map from a terrain transform group was
> assigned to the simulation, changing the world position
> also automatically updates the simulations positioning relative to the terrain height map and translates the
> simulation contents when the simulation moves.
> This function automatically snaps the given position to multiples of the grids cell size, and returns the actual
> position used internally.

**Definition**

> setShallowWaterSimulationWorldPosition(entityId shallowWaterSimulation, float x, float z)

**Arguments**

| entityId | shallowWaterSimulation | id of the shallow water simulation         |
|----------|------------------------|--------------------------------------------|
| float    | x                      | x world space coordinate of the simulation |
| float    | z                      | z world space coordinate of the simulation |

**Return Values**

| float | ax | actual internal position x |
|-------|----|----------------------------|
| float | az | actual internal position z |