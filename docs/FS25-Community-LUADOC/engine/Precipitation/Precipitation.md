### setRainActiveDropsMultiplier

**Description**

> Sets multiplier from 0.0 to 1.0 based on the maximum drops (setMaxRainDropsMultiplier) for the current number of
> simulated rain drops (and splashes).
> The actual amount of rain drops fall are then this multiplier times max rain drops multiplier times the default engine
> amount of maximum rain drops (16384 drops).

**Definition**

> setRainActiveDropsMultiplier(entityId precipitationEntity, float rain)

**Arguments**

| entityId | precipitationEntity | precipitationEntity |
|----------|---------------------|---------------------|
| float    | rain                | drop multiplier     |