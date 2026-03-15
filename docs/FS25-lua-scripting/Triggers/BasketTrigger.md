## BasketTrigger

**Description**

> Class for basket triggers

**Functions**

- [delete](#delete)
- [load](#load)
- [new](#new)
- [onCreate](#oncreate)
- [triggerCallback](#triggercallback)

### delete

**Description**

> Delete basket trigger

**Definition**

> delete()

**Code**

```lua
function BasketTrigger:delete()
    removeTrigger( self.triggerId)
end

```

### load

**Description**

> Load basket trigger

**Definition**

> load(integer nodeId)

**Arguments**

| integer | nodeId | id of node |
|---------|--------|------------|

**Return Values**

| integer | success | success |
|---------|---------|---------|

**Code**

```lua
function BasketTrigger:load(nodeId)
    self.nodeId = nodeId

    self.triggerId = I3DUtil.indexToObject(nodeId, getUserAttribute(nodeId, "triggerIndex" ))
    if self.triggerId = = nil then
        self.triggerId = nodeId
    end
    addTrigger( self.triggerId, "triggerCallback" , self )

    self.triggerObjects = { }

    self.isEnabled = true

    return true
end

```

### new

**Description**

> Creating basket trigger object

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt | custom metatable (optional) |
|--------|----------|-----------------------------|

**Return Values**

| table? | instance | instance of basket trigger object |
|--------|----------|-----------------------------------|

**Code**

```lua
function BasketTrigger.new(customMt)
    local self = setmetatable( { } , customMt or BasketTrigger _mt)

    self.triggerId = 0
    self.nodeId = 0

    return self
end

```

### onCreate

**Description**

> On create basket trigger

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | id of trigger node |
|---------|----|--------------------|

**Code**

```lua
function BasketTrigger:onCreate(id)
    local trigger = BasketTrigger.new()
    if trigger:load(id) then
        g_currentMission:addNonUpdateable(trigger)
    else
            trigger:delete()
        end
    end

```

### triggerCallback

**Description**

> Trigger callback

**Definition**

> triggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay, )

**Arguments**

| integer | triggerId    | id of trigger |
|---------|--------------|---------------|
| integer | otherId      | id of actor   |
| boolean | onEnter      | on enter      |
| boolean | onLeave      | on leave      |
| boolean | onStay       | on stay       |
| any     | otherShapeId |               |

**Code**

```lua
function BasketTrigger:triggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    if self.isEnabled then

        if onEnter then
            local object = g_currentMission:getNodeObject(otherActorId)
            if object.thrownFromPosition ~ = nil then
                self.triggerObjects[otherActorId] = true
            end

        elseif onLeave then
                if self.triggerObjects[otherActorId] then
                    self.triggerObjects[otherActorId] = false

                    -- local object = g_currentMission:getNodeObject(otherActorId)
                    -- local x,y,z = worldToLocal(self.triggerId, object.thrownFromPosition[1],object.thrownFromPosition[2],object.thrownFromPosition[3])
                    -- local dist = MathUtil.vector3Length(x,y,z)
                end
            end
        end
    end

```