### setRainDistributionPower

**Description**

> If rainDistributionPower is not 1.0, then rain is not evenly distributed throughout the world but instead
> some more rain drops spawn closer to the camera and then decrease in number as you get further from the camera.
> Essentially makes it so the rain looks more
> dense than it really is while rendering and simulating a reduced amount of rain drops.
> Values larger than 1.0 will progressively shift more rain drops spawns closer to the mostConcentratedRainDistance (see
> setMostConcentratedRainDistance). Values smaller than 1.0
> have the opposite effect and are not intended to be used.

**Definition**

> setRainDistributionPower(entityId precipitationEntity, float mostConcentratedRainDistance)

**Arguments**

| entityId | precipitationEntity          | precipitationEntity                                                  |
|----------|------------------------------|----------------------------------------------------------------------|
| float    | mostConcentratedRainDistance | Distance from the camera where the distribution is most concentrated |