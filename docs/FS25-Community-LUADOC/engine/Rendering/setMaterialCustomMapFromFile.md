### setMaterialCustomMapFromFile

**Description**

**Definition**

> setMaterialCustomMapFromFile(entityId materialId, string name, string filename, boolean? textueWrap, boolean? isSRGB,
> boolean? sharedEdit)

**Arguments**

| entityId | materialId |                                                              |
|----------|------------|--------------------------------------------------------------|
| string   | name       |                                                              |
| string   | filename   |                                                              |
| boolean? | textueWrap | [optional, default defined by custom shader; ignored anyway] |
| boolean? | isSRGB     | [optional, default defined by custom shader]                 |
| boolean? | sharedEdit | [optional, default=true]                                     |

**Return Values**

| entityId | newMaterialId | material id of new material (same as materialId with shared edit mode) |
|----------|---------------|------------------------------------------------------------------------|