## BeehiveSystem

**Functions**

- [addBeehive](#addbeehive)
- [addBeehivePalletSpawner](#addbeehivepalletspawner)
- [consoleCommandBeehiveDebug](#consolecommandbeehivedebug)
- [delete](#delete)
- [getBeehiveInfluenceFactorAt](#getbeehiveinfluencefactorat)
- [getBeehives](#getbeehives)
- [getFarmBeehivePalletSpawner](#getfarmbeehivepalletspawner)
- [getFarmHasBeehive](#getfarmhasbeehive)
- [new](#new)
- [onHourChanged](#onhourchanged)
- [removeBeehive](#removebeehive)
- [removeBeehivePalletSpawner](#removebeehivepalletspawner)
- [showNoSpawnerWarning](#shownospawnerwarning)
- [update](#update)
- [updateBeehivesOutput](#updatebeehivesoutput)
- [updateBeehivesState](#updatebeehivesstate)
- [updateState](#updatestate)

### addBeehive

**Description**

**Definition**

> addBeehive()

**Arguments**

| any | beehiveToAdd |
|-----|--------------|

**Code**

```lua
function BeehiveSystem:addBeehive(beehiveToAdd)
    if # self.beehivesSortedRadius = = 0 then -- first beehive is added, subscribe to events
        self:updateState()

        g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.onHourChanged, self )
        g_messageCenter:subscribe(MessageType.DAY_NIGHT_CHANGED, self.updateBeehivesState, self )
    end

    table.insert( self.beehivesSortedRadius, beehiveToAdd)

    if self.mission.isMissionStarted then
        self:showNoSpawnerWarning(beehiveToAdd)
    end

    -- make sure beehives with biggest radii are at the start of the list, so that iteration for crop yield bonus exits earlier
        table.sort( self.beehivesSortedRadius, function (a, b) return a.spec_beehive.actionRadius > b.spec_beehive.actionRadius end )
    end

```

### addBeehivePalletSpawner

**Description**

**Definition**

> addBeehivePalletSpawner()

**Arguments**

| any | beehivePalletSpawner |
|-----|----------------------|

**Code**

```lua
function BeehiveSystem:addBeehivePalletSpawner(beehivePalletSpawner)
    table.addElement( self.beehivePalletSpawners, beehivePalletSpawner)

    self:updateBeehivesOutput(beehivePalletSpawner:getOwnerFarmId())
end

```

### consoleCommandBeehiveDebug

**Description**

**Definition**

> consoleCommandBeehiveDebug()

**Code**

```lua
function BeehiveSystem:consoleCommandBeehiveDebug()
    BeehiveSystem.DEBUG_ENABLED = not BeehiveSystem.DEBUG_ENABLED
    return "BeehiveSystem.DEBUG_ENABLED = " .. tostring( BeehiveSystem.DEBUG_ENABLED)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function BeehiveSystem:delete()
    removeConsoleCommand( "gsBeehiveDebug" )
end

```

### getBeehiveInfluenceFactorAt

**Description**

> Returns factor between 0..1 based on presence of beehives relative to given world position
> independent of farm

**Definition**

> getBeehiveInfluenceFactorAt()

**Arguments**

| any | wx |
|-----|----|
| any | wz |

**Code**

```lua
function BeehiveSystem:getBeehiveInfluenceFactorAt(wx, wz)
    local beehiveInfluenceFactor = 0

    for i = 1 , # self.beehivesSortedRadius do
        local beehive = self.beehivesSortedRadius[i]

        -- accumulate influence of all behives
        beehiveInfluenceFactor = beehiveInfluenceFactor + beehive:getBeehiveInfluenceFactor(wx, wz)
        if beehiveInfluenceFactor > = 1 then
            break -- stop if factor reached max of 1
            end
        end
        --#debug if BeehiveSystem.DEBUG_ENABLED then
            --#debug local wy = getTerrainHeightAtWorldPos(g_terrainNode, wx, 0, wz)
            --#debug Utils.renderTextAtWorldPosition(wx, wy, wz, string.format("beehiveInfluenceFactor %.3f", math.min(beehiveInfluenceFactor, 1)), getCorrectTextSize(0.016), 0)
            --#debug end
            return math.min(beehiveInfluenceFactor, 1 )
        end

```

### getBeehives

**Description**

**Definition**

> getBeehives()

**Code**

```lua
function BeehiveSystem:getBeehives()
    return self.beehivesSortedRadius
end

```

### getFarmBeehivePalletSpawner

**Description**

**Definition**

> getFarmBeehivePalletSpawner()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function BeehiveSystem:getFarmBeehivePalletSpawner(farmId)
    for _, beehivePalletSpawner in ipairs( self.beehivePalletSpawners) do
        if beehivePalletSpawner:getOwnerFarmId() = = farmId then
            return beehivePalletSpawner
        end
    end
    return nil
end

```

### getFarmHasBeehive

**Description**

**Definition**

> getFarmHasBeehive()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function BeehiveSystem:getFarmHasBeehive(farmId)
    for _, beehive in ipairs( self.beehivesSortedRadius) do
        if beehive:getOwnerFarmId() = = farmId then
            return true
        end
    end

    return false
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | mission  |
|-----|----------|
| any | customMt |

**Code**

```lua
function BeehiveSystem.new(mission, customMt)
    local self = setmetatable( { } , customMt or BeehiveSystem _mt)

    self.mission = mission

    self.beehives = { }
    self.beehivesSortedRadius = { }
    self.beehivePalletSpawners = { }

    self.isFxActive = false
    self.isProductionActive = false

    if self.mission:getIsServer() then
        if g_addTestCommands then
            addConsoleCommand( "gsBeehiveDebug" , "Toggles beehive debug mode" , "consoleCommandBeehiveDebug" , self )
        end
    end

    self.updateCooldown = BeehiveSystem.COOLDOWN_DURATION
    self.currentSpawnerUpdateIndex = 0

    self.lastTimeNoSpawnerWarningDisplayed = 0
    return self
end

```

### onHourChanged

**Description**

**Definition**

> onHourChanged()

**Code**

```lua
function BeehiveSystem:onHourChanged()
    self:updateBeehivesOutput()
    self:updateBeehivesState()
end

```

### removeBeehive

**Description**

**Definition**

> removeBeehive()

**Arguments**

| any | beehive |
|-----|---------|

**Code**

```lua
function BeehiveSystem:removeBeehive(beehive)
    table.removeElement( self.beehivesSortedRadius, beehive)

    if # self.beehivesSortedRadius = = 0 then
        -- last beehive was removed, unsubscribe from events
        g_messageCenter:unsubscribe(MessageType.HOUR_CHANGED, self )
        g_messageCenter:unsubscribe(MessageType.DAY_NIGHT_CHANGED, self )
    end
end

```

### removeBeehivePalletSpawner

**Description**

**Definition**

> removeBeehivePalletSpawner()

**Arguments**

| any | beehivePalletSpawner |
|-----|----------------------|

**Code**

```lua
function BeehiveSystem:removeBeehivePalletSpawner(beehivePalletSpawner)
    table.removeElement( self.beehivePalletSpawners, beehivePalletSpawner)

    self:showNoSpawnerWarning(beehivePalletSpawner)
end

```

### showNoSpawnerWarning

**Description**

> show notification if no spawner is left for the farm

**Definition**

> showNoSpawnerWarning()

**Arguments**

| any | placeable |
|-----|-----------|

**Code**

```lua
function BeehiveSystem:showNoSpawnerWarning(placeable)
    if self.mission:getIsClient() and(g_ time - self.lastTimeNoSpawnerWarningDisplayed) > 5000 then
        local placeableFarmId = placeable:getOwnerFarmId()
        local farmId = self.mission:getFarmId()
        if self:getFarmHasBeehive(farmId) and farmId = = placeableFarmId and self:getFarmBeehivePalletSpawner(farmId) = = nil then
            local text = g_i18n:getText( "ingameNotification_noPalletLocationAvailable" ) .. string.format( " (%s)" , g_i18n:getText( "category_beeHives" ))
            self.mission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, text)
            self.lastTimeNoSpawnerWarningDisplayed = g_ time
        end
    end
end

```

### update

**Description**

**Definition**

> update()

**Code**

```lua
function BeehiveSystem:update()
    if # self.beehivePalletSpawners = = 0 or not self.mission:getIsServer() then
        return
    end

    if self.updateCooldown < = 0 then
        local beehiveSpawner = self.beehivePalletSpawners[ self.currentSpawnerUpdateIndex]
        if beehiveSpawner ~ = nil then
            beehiveSpawner:updatePallets()
            self.currentSpawnerUpdateIndex = self.currentSpawnerUpdateIndex + 1
        else
                self.currentSpawnerUpdateIndex = 1
                self.updateCooldown = BeehiveSystem.COOLDOWN_DURATION
            end
        else
                self.updateCooldown = self.updateCooldown - 1
            end
        end

```

### updateBeehivesOutput

**Description**

> collects honey from all behives and spawns pallets at triggers

**Definition**

> updateBeehivesOutput(integer? farmId)

**Arguments**

| integer? | farmId | optional filter for farm id |
|----------|--------|-----------------------------|

**Code**

```lua
function BeehiveSystem:updateBeehivesOutput(farmId)
    if self.mission:getIsServer() then
        for i = 1 , # self.beehivesSortedRadius do
            local beehive = self.beehivesSortedRadius[i]
            local beehiveOwner = beehive:getOwnerFarmId()
            if farmId = = nil or(farmId = = beehiveOwner) then -- optional filter
                local palletSpawner = self:getFarmBeehivePalletSpawner(beehiveOwner)
                if palletSpawner ~ = nil then
                    local honeyAmount = beehive:getHoneyAmountToSpawn()
                    if honeyAmount > 0 then
                        palletSpawner:addFillLevel(honeyAmount) -- accumulate fillLevel of all beehives first, update spawners once at the end
                    end
                end
            end
        end
    end
end

```

### updateBeehivesState

**Description**

> updates beehive fx and production state

**Definition**

> updateBeehivesState()

**Code**

```lua
function BeehiveSystem:updateBeehivesState()
    self:updateState()

    for i = 1 , # self.beehivesSortedRadius do
        self.beehivesSortedRadius[i]:updateBeehiveState()
    end
end

```

### updateState

**Description**

> updates internal state used by beehives

**Definition**

> updateState()

**Code**

```lua
function BeehiveSystem:updateState()
    local environment = g_currentMission.environment
    self.isFxActive = true
    self.isProductionActive = environment.currentSeason ~ = Season.WINTER

    if not environment.isSunOn or environment.weather:getIsRaining() or not self.isProductionActive then
        self.isFxActive = false
    end
end

```