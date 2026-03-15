## LoanTrigger

**Description**

> Class for loan triggers

**Functions**

- [delete](#delete)
- [new](#new)
- [onCreate](#oncreate)
- [openFinanceMenu](#openfinancemenu)
- [playerFarmChanged](#playerfarmchanged)
- [triggerCallback](#triggercallback)
- [updateIconVisibility](#updateiconvisibility)

### delete

**Description**

> Delete loan trigger

**Definition**

> delete()

**Code**

```lua
function LoanTrigger:delete()
    g_messageCenter:unsubscribeAll( self )

    if self.triggerId ~ = nil then
        removeTrigger( self.triggerId)
    end
    self.loanSymbol = nil
    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
end

```

### new

**Description**

> Create loan trigger object

**Definition**

> new(integer name)

**Arguments**

| integer | name | id of trigger node |
|---------|------|--------------------|

**Return Values**

| integer | instance | instance |
|---------|----------|----------|

**Code**

```lua
function LoanTrigger.new(name)
    local self = setmetatable( { } , LoanTrigger _mt)

    if g_currentMission:getIsClient() then
        self.triggerId = name
        addTrigger(name, "triggerCallback" , self )
    end

    self.loanSymbol = getChildAt(name, 0 )

    self.activatable = LoanTriggerActivatable.new( self )

    self.isEnabled = true

    g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.playerFarmChanged, self )

    self:updateIconVisibility()

    return self
end

```

### onCreate

**Description**

> On create loan trigger

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | id of trigger node |
|---------|----|--------------------|

**Code**

```lua
function LoanTrigger:onCreate(id)
    g_currentMission:addNonUpdateable( LoanTrigger.new(id))
end

```

### openFinanceMenu

**Description**

> Called on activate object

**Definition**

> openFinanceMenu()

**Code**

```lua
function LoanTrigger:openFinanceMenu()
    g_gui:showGui( "InGameMenu" )
    g_messageCenter:publish(MessageType.GUI_INGAME_OPEN_FINANCES_SCREEN)
end

```

### playerFarmChanged

**Description**

**Definition**

> playerFarmChanged()

**Arguments**

| any | player |
|-----|--------|

**Code**

```lua
function LoanTrigger:playerFarmChanged(player)
    if player = = g_localPlayer then
        self:updateIconVisibility()
    end
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
function LoanTrigger:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if self.isEnabled and g_currentMission.missionInfo:isa(FSCareerMissionInfo) then
        if onEnter or onLeave then
            if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
                if onEnter then
                    g_currentMission.activatableObjectsSystem:addActivatable( self.activatable)
                else
                        g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
                    end
                end
            end
        end
    end

```

### updateIconVisibility

**Description**

> Turn the icon on or off depending on the current game and the players farm

**Definition**

> updateIconVisibility()

**Code**

```lua
function LoanTrigger:updateIconVisibility()
    if self.loanSymbol ~ = nil then
        local isAvailable = self.isEnabled and g_currentMission.missionInfo:isa(FSCareerMissionInfo)
        local farmId = g_currentMission:getFarmId()
        local visibleForFarm = farmId ~ = FarmManager.SPECTATOR_FARM_ID

        setVisibility( self.loanSymbol, isAvailable and visibleForFarm)
    end
end

```