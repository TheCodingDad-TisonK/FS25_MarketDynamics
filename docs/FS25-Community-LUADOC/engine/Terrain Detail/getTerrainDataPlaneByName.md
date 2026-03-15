### getTerrainDataPlaneByName

**Description**

> Get terrain data plane by name

**Definition**

> getTerrainDataPlaneByName(entityId terrainId, string detailName)

**Arguments**

| entityId | terrainId  | terrainId  |
|----------|------------|------------|
| string   | detailName | detailName |

**Return Values**

| integer | detailId | detailId                                                                                                                     |
|---------|----------|------------------------------------------------------------------------------------------------------------------------------|
| integer | typeId   | Density Map type index for this detail (may be shared with others e.g. "potato" and "potato_haulm" have the same type index) |