### setRainBounceRandomFactor

**Description**

> When precipitation particles bounce, they reflect from the surface normal. But the direction of the normal is rotated
> randomly a little bit to give variation. The random factor here determines how random this can be. At 0.0f the
> reflection vector will always be exactly the normal. At a very high value,
> (like 10000) the vector can become almost parallel to the ground. Default value is 1.0 (makes it so it can rotate to
> around 45 degrees to the side).

**Definition**

> setRainBounceRandomFactor(entityId precipitationEntity, float randomfactor)

**Arguments**

| entityId | precipitationEntity | precipitationEntity                    |
|----------|---------------------|----------------------------------------|
| float    | randomfactor        | random factor for bounce randomization |