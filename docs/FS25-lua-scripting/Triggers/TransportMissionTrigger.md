## TransportMissionTrigger

**Description**

> Class for transport mission triggers

**Functions**

- [delete](#delete)
- [new](#new)
- [onCreate](#oncreate)
- [triggerCallback](#triggercallback)

### delete

**Description**

> Deleting shop trigger

**Definition**

> delete()

**Code**

```lua
function TransportMissionTrigger:delete()
    removeTrigger( self.triggerId)

    g_missionManager:removeTransportMissionTrigger( self )
end

```

### new

**Description**

> Creating mission trigger object

**Definition**

> new(integer name)

**Arguments**

| integer | name | trigger node id |
|---------|------|-----------------|

**Return Values**

| integer | instance | instance of object |
|---------|----------|--------------------|

**Code**

```lua
function TransportMissionTrigger.new(id)
    local self = setmetatable( { } , TransportMissionTrigger _mt)

    self.triggerId = id
    self.index = getUserAttribute( self.triggerId, "index" )

    addTrigger(id, "triggerCallback" , self )

    self.isEnabled = true

    g_missionManager:addTransportMissionTrigger( self )

    -- Hide until needed
    self:setMission( nil )

    return self
end

```

### onCreate

**Description**

> On create mission trigger

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | trigger node id |
|---------|----|-----------------|

**Code**

```lua
function TransportMissionTrigger:onCreate(id)
    g_currentMission:addNonUpdateable( TransportMissionTrigger.new(id))
end

```

### triggerCallback

**Description**

> Trigger callback

**Definition**

> triggerCallback(integer triggerId, integer otherId, boolean onEnter, boolean onLeave, boolean onStay)

**Arguments**

| integer | triggerId | id of trigger |
|---------|-----------|---------------|
| integer | otherId   | id of actor   |
| boolean | onEnter   | on enter      |
| boolean | onLeave   | on leave      |
| boolean | onStay    | on stay       |

**Code**

```lua
function TransportMissionTrigger:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if self.isEnabled and self.mission ~ = nil then
        if onEnter then
            self.mission:objectEnteredTrigger( self , otherId)
        elseif onLeave then
                self.mission:objectLeftTrigger( self , otherId)
            end
        end
    end

```