## PrecisionFarmingStatistic

**Description**

> Specialization to save is on field state and current farmland id on a central spot

**Functions**

- [getPFStatisticInfo](#getpfstatisticinfo)
- [getPFYieldMap](#getpfyieldmap)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [updatePFStatistic](#updatepfstatistic)

### getPFStatisticInfo

**Description**

**Definition**

> getPFStatisticInfo()

**Code**

```lua
function PrecisionFarmingStatistic:getPFStatisticInfo()
    local spec = self [ PrecisionFarmingStatistic.SPEC_TABLE_NAME]
    return spec.farmlandStatistics, spec.isOnField, spec.farmlandId, spec.isOnFieldSmoothed, spec.mission
end

```

### getPFYieldMap

**Description**

**Definition**

> getPFYieldMap()

**Code**

```lua
function PrecisionFarmingStatistic:getPFYieldMap()
    local spec = self [ PrecisionFarmingStatistic.SPEC_TABLE_NAME]
    return spec.yieldMap
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
function PrecisionFarmingStatistic:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ PrecisionFarmingStatistic.SPEC_TABLE_NAME]

    spec.lastUpdateDistance = spec.lastUpdateDistance + self.lastMovedDistance
    if spec.lastUpdateDistance > spec.updateDistance or spec.farmlandId = = 0 then
        spec.lastUpdateDistance = 0
        local x, _, z = getWorldTranslation( self.rootNode)
        spec.farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(x, z)

        if spec.farmlandId ~ = 0 then
            local landOwner = g_farmlandManager:getFarmlandOwner(spec.farmlandId)
            spec.farmlandAccess = (landOwner ~ = 0 and g_currentMission.accessHandler:canFarmAccessOtherId( self:getActiveFarm(), landOwner))
        else
                spec.farmlandAccess = false
            end

            spec.mission = g_missionManager:getMissionAtWorldPosition(x, z)

            local isOnField = self.isOnField
            if isOnField ~ = spec.isOnField then
                if isOnField then
                    spec.isOnFieldSmoothed = true
                else
                        spec.isOnFieldLastPos[ 1 ] = x
                        spec.isOnFieldLastPos[ 2 ] = z
                    end
                end

                if spec.isOnFieldSmoothed ~ = isOnField then
                    local distance = MathUtil.vector2Length(x - spec.isOnFieldLastPos[ 1 ], z - spec.isOnFieldLastPos[ 2 ])
                    if distance > 20 then
                        spec.isOnFieldSmoothed = isOnField
                    end
                end

                spec.isOnField = isOnField
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
function PrecisionFarmingStatistic.prerequisitesPresent(specializations)
    return true
end

```

### updatePFStatistic

**Description**

**Definition**

> updatePFStatistic()

**Arguments**

| any | name  |
|-----|-------|
| any | value |

**Code**

```lua
function PrecisionFarmingStatistic:updatePFStatistic(name, value)
    local spec = self [ PrecisionFarmingStatistic.SPEC_TABLE_NAME]
    if spec.farmlandStatistics ~ = nil then
        if (spec.farmlandId ~ = nil and spec.farmlandAccess) and spec.mission = = nil then
            spec.farmlandStatistics:updateStatistic(spec.farmlandId, name, value)
        end
    end
end

```