## LadderTrigger

**Functions**

- [delete](#delete)
- [new](#new)
- [onCreate](#oncreate)
- [triggerCallback](#triggercallback)

### delete

**Description**

> Deleting ladder trigger

**Definition**

> delete()

**Code**

```lua
function LadderTrigger:delete()
    if self.triggerId ~ = nil then
        removeTrigger( self.triggerId)
    end
end

```

### new

**Description**

> Creating ladder trigger object

**Definition**

> new(integer node)

**Arguments**

| integer | node | trigger node id |
|---------|------|-----------------|

**Return Values**

| integer | instance | instance of object |
|---------|----------|--------------------|

**Code**

```lua
function LadderTrigger.new(node)
    local self = setmetatable( { } , LadderTrigger _mt)

    if g_currentMission:getIsClient() then
        self.triggerId = node

        if not CollisionFlag.getHasMaskFlagSet(node, CollisionFlag.PLAYER) then
            Logging.warning( "Missing collision mask bit '%d'.Please add this bit to ladder trigger node '%s'" , CollisionFlag.getBit(CollisionFlag.PLAYER), I3DUtil.getNodePath(node))
        end

        addTrigger(node, "triggerCallback" , self )
    end

    return self
end

```

### onCreate

**Description**

> On create ladder trigger

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | trigger node id |
|---------|----|-----------------|

**Code**

```lua
function LadderTrigger:onCreate(id)
    g_currentMission:addNonUpdateable( LadderTrigger.new(id))
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
function LadderTrigger:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if onEnter or onLeave then
        if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
            if onEnter then
                g_localPlayer.mover:setIsOnLadder( true )
            else
                    g_localPlayer.mover:setIsOnLadder( false )
                end
            end
        end
    end

```