### setRainMaxDropsMultiplier

**Description**

> Sets multiplier (can be larger than 1.0) for the maximum number of supported rain drops, based on the default engine
> limit (16384 drops). This is an upper limit and sets up GPU buffers (etc.) to fit the corresponding amount of rain
> drops
> and as such should only be used to set up the max rain drop count at the start of the application or when settings
> change.

**Definition**

> setRainMaxDropsMultiplier(entityId precipitationEntity, float max)

**Arguments**

| entityId | precipitationEntity | precipitationEntity   |
|----------|---------------------|-----------------------|
| float    | max                 | rain drops multiplier |