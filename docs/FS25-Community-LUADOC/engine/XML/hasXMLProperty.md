### hasXMLProperty

**Description**

> Returns if an XML element or attribute at given path is present.

**Definition**

> hasXMLProperty(entityId xmlId, string nodePath)

**Arguments**

| entityId | xmlId    | xmlId                            |
|----------|----------|----------------------------------|
| string   | nodePath | path to XML element or attribute |

**Return Values**

| boolean | hasElementOrAttribute     | true if the given nodePath exists                                                                                                           |
|---------|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| boolean | hasAttributeParentElement | true, if the given the attribute's parent element exists (can be true even if hasElementOrAttribute is false e.g. attribute does not exist) |