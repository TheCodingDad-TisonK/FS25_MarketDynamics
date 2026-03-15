### setRainWeatherType

**Description**

> Sets rain weather type to one of DEFAULT, RAIN, HAIL, SNOW (RainSimWeatherType enum) in order to modify specific
> behaviours according to the type. Only rain and hail will spawn splashes on top of water for example.

**Definition**

> setRainWeatherType(entityId precipitationGeometry, integer weatherType)

**Arguments**

| entityId | precipitationGeometry |                                |
|----------|-----------------------|--------------------------------|
| integer  | weatherType           | (from RainSimWeatherType enum) |