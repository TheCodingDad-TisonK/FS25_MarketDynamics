## StonePickMission

**Parent**

> [AbstractFieldMission](?version=script&category=35&class=413)

**Functions**

- [canRun](#canrun)
- [createModifier](#createmodifier)
- [getFieldFinishTask](#getfieldfinishtask)
- [getFieldPreparingTask](#getfieldpreparingtask)
- [getMissionTypeName](#getmissiontypename)
- [getPartitionCompletion](#getpartitioncompletion)
- [getRewardPerHa](#getrewardperha)
- [initializeModifier](#initializemodifier)
- [isAvailableForField](#isavailableforfield)
- [loadMapData](#loadmapdata)
- [new](#new)
- [setPartitionRegion](#setpartitionregion)
- [tryGenerateMission](#trygeneratemission)
- [validate](#validate)

### canRun

**Description**

**Definition**

> canRun()

**Code**

```lua
function StonePickMission.canRun()
    local data = g_missionManager:getMissionTypeDataByName( StonePickMission.NAME)

    if data.numInstances > = data.maxNumInstances then
        return false
    end

    return true
end

```

### createModifier

**Description**

**Definition**

> createModifier()

**Code**

```lua
function StonePickMission:createModifier()
    local mission = g_currentMission
    local mapId, firstChannel, numChannels = mission.stoneSystem:getDensityMapData()

    -- local maskValue = mission.stoneSystem:getMaskValue()
    local _, maxValue = g_currentMission.stoneSystem:getMinMaxValues()

    self.completionModifier = DensityMapModifier.new(mapId, firstChannel, numChannels, g_terrainNode)
    self.completionModifierUnmasked = DensityMapModifier.new(mapId, firstChannel, numChannels, g_terrainNode)

    self.completionFilter = DensityMapFilter.new( self.completionModifier)
    self.completionFilter:setValueCompareParams(DensityValueCompareType.NOTEQUAL, maxValue)
    self.completionFilterMasked = DensityMapFilter.new( self.completionModifier)
    self.completionFilterMasked:setValueCompareParams(DensityValueCompareType.GREATER, 0 )

    self.completionFilterUnmasked = DensityMapFilter.new( self.completionModifier)
    self.completionFilterUnmasked:setValueCompareParams(DensityValueCompareType.EQUAL, 0 )
end

```

### getFieldFinishTask

**Description**

**Definition**

> getFieldFinishTask()

**Code**

```lua
function StonePickMission:getFieldFinishTask()
    if self.isServer then
        local fieldState = self.field:getFieldState()
        fieldState.stoneLevel = 0
        fieldState.groundType = FieldGroundType.CULTIVATED
    end

    return StonePickMission:superClass().getFieldFinishTask( self )
end

```

### getFieldPreparingTask

**Description**

**Definition**

> getFieldPreparingTask()

**Code**

```lua
function StonePickMission:getFieldPreparingTask()
    if self.isServer then
        local fieldState = self.field:getFieldState()
        fieldState.stoneLevel = self.stoneValue
    end

    return StonePickMission:superClass().getFieldPreparingTask( self )
end

```

### getMissionTypeName

**Description**

**Definition**

> getMissionTypeName()

**Code**

```lua
function StonePickMission:getMissionTypeName()
    return StonePickMission.NAME
end

```

### getPartitionCompletion

**Description**

**Definition**

> getPartitionCompletion()

**Arguments**

| any | partitionIndex |
|-----|----------------|

**Code**

```lua
function StonePickMission:getPartitionCompletion(partitionIndex)
    self:setPartitionRegion(partitionIndex)

    if self.completionModifier ~ = nil then
        local sumPixels, area, totalArea = self.completionModifier:executeGet( self.completionFilter, self.completionFilterMasked)

        local _, unmaskedArea, _ = self.completionModifierUnmasked:executeGet( self.completionFilterUnmasked)

        totalArea = totalArea - unmaskedArea

        return sumPixels, area, totalArea
    end

    return 0 , 0 , 0
end

```

### getRewardPerHa

**Description**

**Definition**

> getRewardPerHa()

**Code**

```lua
function StonePickMission:getRewardPerHa()
    local data = g_missionManager:getMissionTypeDataByName( StonePickMission.NAME)
    return data.rewardPerHa
end

```

### initializeModifier

**Description**

**Definition**

> initializeModifier()

**Code**

```lua
function StonePickMission:initializeModifier()
    StonePickMission:superClass().initializeModifier( self )

    if self.completionModifierUnmasked ~ = nil then
        local densityMapPolygon = self.field:getDensityMapPolygon()
        densityMapPolygon:applyToModifier( self.completionModifierUnmasked)
    end
end

```

### isAvailableForField

**Description**

**Definition**

> isAvailableForField()

**Arguments**

| any | field   |
|-----|---------|
| any | mission |

**Code**

```lua
function StonePickMission.isAvailableForField(field, mission)
    if mission = = nil then
        local fieldState = field:getFieldState()
        if not fieldState.isValid then
            return false
        end

        local fruitTypeIndex = fieldState.fruitTypeIndex
        if fruitTypeIndex ~ = FruitType.UNKNOWN then
            return false
        end

        local groundType = fieldState.groundType
        if groundType ~ = FieldGroundType.PLOWED then
            return false
        end
    end

    local environment = g_currentMission.environment
    if environment ~ = nil and environment.currentSeason = = Season.WINTER then
        return false
    end

    return true
end

```

### loadMapData

**Description**

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | key           |
| any | baseDirectory |

**Code**

```lua
function StonePickMission.loadMapData(xmlFile, key, baseDirectory)
    local data = g_missionManager:getMissionTypeDataByName( StonePickMission.NAME)
    data.rewardPerHa = xmlFile:getFloat(key .. "#rewardPerHa" , 2200 )

    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | isServer |
|-----|----------|
| any | isClient |
| any | customMt |

**Code**

```lua
function StonePickMission.new(isServer, isClient, customMt)
    local title = g_i18n:getText( "contract_field_stonePick_title" )
    local description = g_i18n:getText( "contract_field_stonePick_description" )

    local self = AbstractFieldMission.new(isServer, isClient, title, description, customMt or StonePickMission _mt)

    self.workAreaTypes = {
    [WorkAreaType.STONEPICKER] = true
    }

    self.stoneValue = 3
    self.spawnedPixels = 0

    return self
end

```

### setPartitionRegion

**Description**

**Definition**

> setPartitionRegion()

**Arguments**

| any | partitionIndex |
|-----|----------------|

**Code**

```lua
function StonePickMission:setPartitionRegion(partitionIndex)
    StonePickMission:superClass().setPartitionRegion( self , partitionIndex)

    if # self.completionPartitions = = 1 then
        return
    end

    if self.completionModifierUnmasked ~ = nil then
        local partition = self.completionPartitions[partitionIndex]
        self.completionModifierUnmasked:setPolygonClipRegion(partition.minZ, partition.maxZ)
    end
end

```

### tryGenerateMission

**Description**

**Definition**

> tryGenerateMission()

**Code**

```lua
function StonePickMission.tryGenerateMission()
    if StonePickMission.canRun() then
        local field = g_fieldManager:getFieldForMission()
        if field = = nil then
            return
        end

        if field.currentMission ~ = nil then
            return
        end

        if not StonePickMission.isAvailableForField(field, nil ) then
            return
        end

        -- Create an instance
        local mission = StonePickMission.new( true , g_client ~ = nil )
        if mission:init(field) then
            mission:setDefaultEndDate()
            return mission
        else
                mission:delete()
            end
        end

        return nil
    end

```

### validate

**Description**

**Definition**

> validate()

**Arguments**

| any | event |
|-----|-------|

**Code**

```lua
function StonePickMission:validate(event)
    if not StonePickMission:superClass().validate( self , event) then
        return false
    end

    if not self:getIsFinished() then
        if not StonePickMission.isAvailableForField( self.field, self ) then
            return false
        end
    end

    return true
end

```