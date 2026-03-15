## ExtendedMower

**Description**

> Specialization to toggle minimap zoom while on field

**Functions**

- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [processMowerArea](#processmowerarea)
- [updateMinimapActiveState](#updateminimapactivestate)

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
function ExtendedMower:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        if isActiveForInputIgnoreSelection then
            ExtendedMower.updateMinimapActiveState( self )
        else
                ExtendedMower.updateMinimapActiveState( self , false )
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
function ExtendedMower:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        if self.isActiveForInputIgnoreSelectionIgnoreAI then
            ExtendedMower.updateMinimapActiveState( self )
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
function ExtendedMower.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Mower , specializations)
    and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### processMowerArea

**Description**

**Definition**

> processMowerArea()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | dt        |

**Code**

```lua
function ExtendedMower:processMowerArea(superFunc, workArea, dt)
    if not self.isServer and self.currentUpdateDistance > Mower.CLIENT_DM_UPDATE_RADIUS then
        return superFunc( self , workArea, dt)
    end

    if g_precisionFarming ~ = nil then
        g_precisionFarming.harvestExtension:preProcessMowerArea( self , workArea, dt)
    end

    local lastChangedArea, lastTotalArea = superFunc( self , workArea, dt)

    if g_precisionFarming ~ = nil then
        g_precisionFarming.harvestExtension:postProcessMowerArea( self , workArea, dt, lastChangedArea)
    end

    return lastChangedArea, lastTotalArea
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
function ExtendedMower.updateMinimapActiveState( self , forcedState)
    local yieldMap = self:getPFYieldMap()

    local isActive = forcedState
    if isActive = = nil then
        local _, _, _, isOnField = self:getPFStatisticInfo()
        isActive = isOnField
    end

    yieldMap:setRequireMinimapDisplay(isActive, self , self:getIsSelected())
end

```