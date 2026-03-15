### setRainTurbulenceParameters

**Description**

> Set parameters for rain turbulence. Rain turbulence randomly accelerates rain drops according to some noise that
> varies over time.

**Definition**

> setRainTurbulenceParameters(entityId precipitationEntity, float turbulence, float timeScale, float pulsePeriod, float
> frequency)

**Arguments**

| entityId | precipitationEntity | precipitationEntity                                                                                                                                      |
|----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| float    | turbulence          | Determines how strong the turbulence is. Default 10.0                                                                                                    |
| float    | timeScale           | Turbulence varies over time. This speeds up or slows down that process.                                                                                  |
| float    | pulsePeriod         | Turbulence ebbs and flows in terms of its strength. This is the duration / period of that pulsing.                                                       |
| float    | frequency           | Spatial frequency of the turbulence (how fast the turbulence changes in space. Lower it to have a larger space affected by the same kind of turbulence). |