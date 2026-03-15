### setTerrainFillVisualHeight

**Description**

> Set fill level mapping for a type (NB: finalizeTerrainFillLayers must be called afterwards)

**Definition**

> setTerrainFillVisualHeight(entityId fillDataPlaneId, integer fillType, integer firstFillLevel, float
> firstMappedFillLevel, integer? lastFillLevel, float? lastMappedFillLevel)

**Arguments**

| entityId | fillDataPlaneId      | fillDataPlaneId                                             |
|----------|----------------------|-------------------------------------------------------------|
| integer  | fillType             | fillType                                                    |
| integer  | firstFillLevel       | first fill level to adjust                                  |
| float    | firstMappedFillLevel | mapped fill level corresponding to firstFillLevel           |
| integer? | lastFillLevel        | last fill level to adjust [optional]                        |
| float?   | lastMappedFillLevel  | mapped fill level corresponding to lastFillLevel [optional] |