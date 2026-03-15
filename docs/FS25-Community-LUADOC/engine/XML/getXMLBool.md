### getXMLBool

**Description**

> Get XML file boolean value. Returns true if node value is 'true', false if node value is 'false' (both case
> insensitive), nil otherwise

**Definition**

> getXMLBool(entityId xmlId, string nodePath)

**Arguments**

| entityId | xmlId    | xmlId                            |
|----------|----------|----------------------------------|
| string   | nodePath | path to XML element or attribute |

**Return Values**

| boolean | value | value, nil if node does not match 'true' or 'false' |
|---------|-------|-----------------------------------------------------|