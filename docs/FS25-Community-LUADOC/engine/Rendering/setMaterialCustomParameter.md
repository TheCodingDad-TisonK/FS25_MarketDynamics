### setMaterialCustomParameter

**Description**

> Set the custom parameter values of a material

**Definition**

> setMaterialCustomParameter(entityId materialId, string name, float x, float y, float z, float w, boolean? sharedEdit)

**Arguments**

| entityId | materialId |                          |
|----------|------------|--------------------------|
| string   | name       |                          |
| float    | x          |                          |
| float    | y          |                          |
| float    | z          |                          |
| float    | w          |                          |
| boolean? | sharedEdit | [optional, default=true] |

**Return Values**

| entityId | newMaterialId | material id of new material (same as materialId with shared edit mode) |
|----------|---------------|------------------------------------------------------------------------|