### addTrigger

**Description**

> Add trigger to a rigid body shape

**Definition**

> addTrigger(entityId triggerNodeId, string callbackFunctionName, object? callbackTarget, boolean? reportOnStay, object?
> callbackFunction)

**Arguments**

| entityId | triggerNodeId        |                                                                                                                                                |
|----------|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| string   | callbackFunctionName | callback(entityId triggerId, entityId otherId, boolean onEnter, boolean onLeave, boolean onStay, entityId otherShapeId, integer subShapeIndex) |
| object?  | callbackTarget       | target object [optional]                                                                                                                       |
| boolean? | reportOnStay         | if true, the callback function is called every frame while an object is inside [optional, default=false]                                       |
| object?  | callbackFunction     | a function object that is called. If nil, callback is called by the 'callbackFunctionName' and 'callbackTarget' [optional, default=nil]        |

**Return Values**

| integer | callbackId |
|---------|------------|