### createNoteNode

**Description**

> Create note node

**Definition**

> createNoteNode(entityId? parentId, string? text, float? colorR, float? colorG, float? colorB, boolean? fixedSize)

**Arguments**

| entityId? | parentId  | Parent ID [optional] otherwise linked to rootNode |
|-----------|-----------|---------------------------------------------------|
| string?   | text      | Text [optional]                                   |
| float?    | colorR    | R component of note color [optional, 0-1]         |
| float?    | colorG    | G component of note color [optional, 0-1]         |
| float?    | colorB    | B component of note color [optional, 0-1]         |
| boolean?  | fixedSize | Fixed size on screen [optional]                   |

**Return Values**

| entityId | noteNodeId |
|----------|------------|