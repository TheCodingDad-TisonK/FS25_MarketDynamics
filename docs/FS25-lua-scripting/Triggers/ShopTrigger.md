## ShopTrigger

**Description**

> Class for shop triggers to open shop gui

**Functions**

- [delete](#delete)
- [new](#new)
- [onCreate](#oncreate)
- [onTriggerVisibilityChanged](#ontriggervisibilitychanged)
- [openShop](#openshop)
- [playerFarmChanged](#playerfarmchanged)
- [triggerCallback](#triggercallback)
- [updateIconVisibility](#updateiconvisibility)

### delete

**Description**

> Deleting shop trigger

**Definition**

> delete()

**Code**

```lua
function ShopTrigger:delete()
    g_messageCenter:unsubscribeAll( self )
    if self.triggerId ~ = nil then
        removeTrigger( self.triggerId)
    end
    self.shopSymbol = nil
    g_currentMission.activatableObjectsSystem:removeActivatable( self.activatable)
end

```

### new

**Description**

> Creating shop trigger object

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
function ShopTrigger.new(node)
    local self = setmetatable( { } , ShopTrigger _mt)

    if g_currentMission:getIsClient() then
        self.triggerId = node

        if not CollisionFlag.getHasMaskFlagSet(node, CollisionFlag.PLAYER) then
            Logging.warning( "Missing collision mask bit '%d'.Please add this bit to shop trigger node '%s'" , CollisionFlag.getBit(CollisionFlag.PLAYER), I3DUtil.getNodePath(node))
        end

        addTrigger(node, "triggerCallback" , self )
    end

    self.shopSymbol = getChildAt(node, 0 )
    self.shopPlayerSpawn = getChildAt(node, 1 )
    self.isEnabled = true

    g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.playerFarmChanged, self )
    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.SHOW_TRIGGER_MARKER], self.onTriggerVisibilityChanged, self )

    self:updateIconVisibility()

    self.activatable = ShopTriggerActivatable.new( self )

    return self
end

```

### onCreate

**Description**

> On create shop trigger

**Definition**

> onCreate(integer id)

**Arguments**

| integer | id | trigger node id |
|---------|----|-----------------|

**Code**

```lua
function ShopTrigger:onCreate(id)
    g_currentMission:addNonUpdateable( ShopTrigger.new(id))
end

```

### onTriggerVisibilityChanged

**Description**

**Definition**

> onTriggerVisibilityChanged()

**Code**

```lua
function ShopTrigger:onTriggerVisibilityChanged()
    self:updateIconVisibility()
end

```

### openShop

**Description**

> Called on activate object

**Definition**

> openShop()

**Code**

```lua
function ShopTrigger:openShop()
    if g_guidedTourManager:getIsTourRunning() then
        InfoDialog.show(g_i18n:getText( "guidedTour_feature_deactivated" ))
        return
    end

    g_gui:changeScreen( nil , ShopMenu)

    local x,y,z = getWorldTranslation( self.shopPlayerSpawn)
    local dx, _, dz = localDirectionToWorld( self.shopPlayerSpawn, 0 , 0 , - 1 )
    g_localPlayer:teleportTo(x, y, z)
    g_localPlayer:setMovementYaw( MathUtil.getYRotationFromDirection(dx, dz))
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
function ShopTrigger:playerFarmChanged(player)
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
function ShopTrigger:triggerCallback(triggerId, otherId, onEnter, onLeave, onStay)
    if self.isEnabled and g_currentMission.missionInfo:isa(FSCareerMissionInfo) then
        if onEnter or onLeave then
            if g_localPlayer ~ = nil and otherId = = g_localPlayer.rootNode then
                if onEnter then
                    if Platform.gameplay.autoActivateTrigger and self.activatable:getIsActivatable() then
                        self.activatable:run()
                        return
                    end
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
function ShopTrigger:updateIconVisibility()
    if self.shopSymbol ~ = nil then
        local isAvailable = self.isEnabled and g_currentMission.missionInfo:isa(FSCareerMissionInfo)
        local farmId = g_currentMission:getFarmId()
        local visibleForFarm = farmId ~ = FarmManager.SPECTATOR_FARM_ID
        local settingVisible = g_gameSettings:getValue(GameSettings.SETTING.SHOW_TRIGGER_MARKER)

        setVisibility( self.shopSymbol, isAvailable and visibleForFarm and settingVisible)
    end
end

```