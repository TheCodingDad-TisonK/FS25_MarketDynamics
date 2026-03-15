### addFoliageTypeFromXML

**Description**

> Load a new foliage type from an XML file, creating a new multilayer if a new density map is used

**Definition**

> addFoliageTypeFromXML(entityId terrainNode, entityId foliageDataPlaneId, string name, string xmlFilename)

**Arguments**

| entityId | terrainNode        |                                                                                              |
|----------|--------------------|----------------------------------------------------------------------------------------------|
| entityId | foliageDataPlaneId | id for density map to use for the foliage layer, or a dataplane that shares this density map |
| string   | name               | name of new layer                                                                            |
| string   | xmlFilename        | XML filename containing the layer definition                                                 |

**Return Values**

| entityId | densityMapTypeId | the type ID the density map will use for this layer, or 0 if the call failed |
|----------|------------------|------------------------------------------------------------------------------|