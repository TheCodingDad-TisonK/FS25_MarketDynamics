## ExtendedCombine

**Description**

> Specialization to toggle minimap zoom while on field

**Functions**

- [onDelete](#ondelete)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [setLastYieldValues](#setlastyieldvalues)
- [updateMinimapActiveState](#updateminimapactivestate)

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function ExtendedCombine:onDelete()
    local spec = self [ ExtendedCombine.SPEC_TABLE_NAME]
    if spec.hudExtension ~ = nil then
        spec.hudExtension:delete()
    end
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function ExtendedCombine:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self [ ExtendedCombine.SPEC_TABLE_NAME]

        if streamReadBool(streamId) then
            spec.lastYieldWeight = streamReadUIntN(streamId, ExtendedCombine.YIELD_NUM_BITS) / 10
            spec.lastYieldPercentage = streamReadUIntN(streamId, ExtendedCombine.YIELD_PCT_NUM_BITS)
            spec.lastYieldPotential = streamReadUIntN(streamId, ExtendedCombine.YIELD_PCT_NUM_BITS)
        end
    end
end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |

**Code**

```lua
function ExtendedCombine:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        if isActiveForInputIgnoreSelection then
            ExtendedCombine.updateMinimapActiveState( self )
        else
                ExtendedCombine.updateMinimapActiveState( self , false )
            end
        end
    end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function ExtendedCombine:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ ExtendedCombine.SPEC_TABLE_NAME]
    if self.isActiveForInputIgnoreSelectionIgnoreAI then
        if spec.hudExtension ~ = nil then
            local hud = g_currentMission.hud
            hud:addHelpExtension(spec.hudExtension)
        end
    end
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function ExtendedCombine:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        if self.isActiveForInputIgnoreSelectionIgnoreAI then
            ExtendedCombine.updateMinimapActiveState( self )
        end
    end
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function ExtendedCombine:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self [ ExtendedCombine.SPEC_TABLE_NAME]

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.usageValuesDirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, math.min( math.floor(spec.lastYieldWeight * 10 ), ExtendedCombine.YIELD_MAX_VALUE), ExtendedCombine.YIELD_NUM_BITS)
            streamWriteUIntN(streamId, math.min( math.floor(spec.lastYieldPercentage), ExtendedCombine.YIELD_PCT_MAX_VALUE), ExtendedCombine.YIELD_PCT_NUM_BITS)
            streamWriteUIntN(streamId, math.min( math.floor(spec.lastYieldPotential), ExtendedCombine.YIELD_PCT_MAX_VALUE), ExtendedCombine.YIELD_PCT_NUM_BITS)
        end
    end
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function ExtendedCombine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Combine , specializations)
    and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### setLastYieldValues

**Description**

**Definition**

> setLastYieldValues()

**Arguments**

| any | lastYieldWeight     |
|-----|---------------------|
| any | lastYieldPercentage |
| any | lastYieldPotential  |

**Code**

```lua
function ExtendedCombine:setLastYieldValues(lastYieldWeight, lastYieldPercentage, lastYieldPotential)
    local spec = self [ ExtendedCombine.SPEC_TABLE_NAME]
    if lastYieldWeight ~ = spec.lastYieldWeight or lastYieldPercentage ~ = spec.lastYieldPercentage or lastYieldPotential ~ = spec.lastYieldPotential then
        spec.lastYieldWeight = lastYieldWeight
        spec.lastYieldPercentage = lastYieldPercentage
        spec.lastYieldPotential = lastYieldPotential

        self:raiseDirtyFlags(spec.usageValuesDirtyFlag)
    end
end

```

### updateMinimapActiveState

**Description**

**Definition**

> updateMinimapActiveState()

**Arguments**

| any | self        |
|-----|-------------|
| any | forcedState |

**Code**

```lua
function ExtendedCombine.updateMinimapActiveState( self , forcedState)
    local yieldMap = self:getPFYieldMap()
    if yieldMap ~ = nil then

        local isActive = forcedState
        if isActive = = nil then
            local _, _, _, isOnField, mission = self:getPFStatisticInfo()
            isActive = isOnField and self.spec_combine.numAttachedCutters > 0 and mission = = nil
        end

        yieldMap:setRequireMinimapDisplay(isActive, self , self:getIsSelected())
    end
end

```