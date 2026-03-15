### setShaderParameter

**Description**

> Set shader parameter

**Definition**

> setShaderParameter(entityId shapeId, string parameterName, float? x, float? y, float? z, float? w, boolean? shared,
> integer? materialIndex)

**Arguments**

| entityId | shapeId       | shapeId                                                                           |
|----------|---------------|-----------------------------------------------------------------------------------|
| string   | parameterName | parameterName                                                                     |
| float?   | x             | [optional, default=currentValue]                                                  |
| float?   | y             | [optional, default=currentValue]                                                  |
| float?   | z             | [optional, default=currentValue]                                                  |
| float?   | w             | [optional, default=currentValue]                                                  |
| boolean? | shared        | [optional, default=true]                                                          |
| integer? | materialIndex | material index or a negative value to set to all materials [optional, default=-1] |