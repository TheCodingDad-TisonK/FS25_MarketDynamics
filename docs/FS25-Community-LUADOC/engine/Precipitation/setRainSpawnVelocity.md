### setRainSpawnVelocity

**Description**

> Set spawn velocity of rain drops. The horizontal (x and z) components can be further modified during simulation by the
> wind force and turbulence.

**Definition**

> setRainSpawnVelocity(entityId precipitationEntity, float velocityX, float velocityY, float velocityZ)

**Arguments**

| entityId | precipitationEntity | precipitationEntity                                     |
|----------|---------------------|---------------------------------------------------------|
| float    | velocityX           | x ('right') component of spawn velocity of rain drops   |
| float    | velocityY           | y ('up') component of spawn velocity of rain drops      |
| float    | velocityZ           | z ('forward') component of spawn velocity of rain drops |