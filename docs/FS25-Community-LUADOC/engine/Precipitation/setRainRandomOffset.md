### setRainRandomOffset

**Description**

> The rain simulation draws random numbers between 0 and 1 for various purposes (such as determining rain drop position
> when it spawns, etc.).
> Since the simulation is deterministic, usually two rain systems spawned at the same time will give particles exactly
> in the same locations, which can
> be undesirable when e.g. blending between two rain system states. This function allows to set a random offset (between
> 0 and 1) that is added whenever
> a random number is rolled, resulting in the same drops in two different rain systems to have different positions,
> velocities and such.
> By default each loaded rain system will already have a randomly generated random offset. But you can set it explicitly
> here.

**Definition**

> setRainRandomOffset(entityId precipitationEntity, float randomOffset)

**Arguments**

| entityId | precipitationEntity | precipitationEntity |
|----------|---------------------|---------------------|
| float    | randomOffset        | random offset       |