## PlowMission

**Parent**

> [AbstractFieldMission](?version=script&category=35&class=411)

**Functions**

- [canRun](#canrun)
- [createModifier](#createmodifier)
- [getFieldFinishTask](#getfieldfinishtask)
- [getMissionTypeName](#getmissiontypename)
- [getRewardPerHa](#getrewardperha)
- [isAvailableForField](#isavailableforfield)
- [loadMapData](#loadmapdata)
- [new](#new)
- [tryGenerateMission](#trygeneratemission)
- [validate](#validate)

### canRun

**Description**

**Definition**

> canRun()

**Code**

```lua
function PlowMission.canRun()
    local data = g_missionManager:getMissionTypeDataByName( PlowMission.NAME)

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
function PlowMission:createModifier()
    local mission = g_currentMission
    local groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)
    local plowValue = FieldGroundType.getValueByType(FieldGroundType.PLOWED)

    self.completionModifier = DensityMapModifier.new(groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels, g_terrainNode)
    self.completionFilter = DensityMapFilter.new( self.completionModifier)
    self.completionFilter:setValueCompareParams(DensityValueCompareType.EQUAL, plowValue)
end

```

### getFieldFinishTask

**Description**

**Definition**

> getFieldFinishTask()

**Code**

```lua
function PlowMission:getFieldFinishTask()
    local fieldState = self.field:getFieldState()
    fieldState.fruitTypeIndex = FruitType.UNKNOWN
    fieldState.groundType = FieldGroundType.PLOWED

    return PlowMission:superClass().getFieldFinishTask( self )
end

```

### getMissionTypeName

**Description**

**Definition**

> getMissionTypeName()

**Code**

```lua
function PlowMission:getMissionTypeName()
    return PlowMission.NAME
end

```

### getRewardPerHa

**Description**

**Definition**

> getRewardPerHa()

**Code**

```lua
function PlowMission:getRewardPerHa()
    local data = g_missionManager:getMissionTypeDataByName( PlowMission.NAME)
    return data.rewardPerHa
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
function PlowMission.isAvailableForField(field, mission)
    if mission = = nil then
        local fieldState = field:getFieldState()
        if not fieldState.isValid then
            return false
        end

        if field.grassMissionOnly then
            return false
        end

        local maxLevel = g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.PLOW_LEVEL)
        if fieldState.plowLevel > = maxLevel then
            return false
        end

        local fruitTypeIndex = fieldState.fruitTypeIndex
        if fruitTypeIndex = = FruitType.UNKNOWN then
            return false
        end

        local growthState = fieldState.growthState
        local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
        if fruitTypeDesc:getIsCatchCrop() and growthState < = 1 then
            return false
        end

        if not fruitTypeDesc:getIsCut(growthState) and not fruitTypeDesc:getIsWithered(growthState) then
            return false
        end
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
function PlowMission.loadMapData(xmlFile, key, baseDirectory)
    local data = g_missionManager:getMissionTypeDataByName( PlowMission.NAME)
    data.rewardPerHa = xmlFile:getFloat(key .. "#rewardPerHa" , 2800 )

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
function PlowMission.new(isServer, isClient, customMt)
    local title = g_i18n:getText( "contract_field_plow_title" )
    local description = g_i18n:getText( "contract_field_plow_description" )

    local self = AbstractFieldMission.new(isServer, isClient, title, description, customMt or PlowMission _mt)

    self.workAreaTypes = {
    [WorkAreaType.PLOW] = true
    }

    return self
end

```

### tryGenerateMission

**Description**

**Definition**

> tryGenerateMission()

**Code**

```lua
function PlowMission.tryGenerateMission()
    if PlowMission.canRun() then
        local field = g_fieldManager:getFieldForMission()
        if field = = nil then
            return
        end

        if field.currentMission ~ = nil then
            return
        end

        if not PlowMission.isAvailableForField(field, nil ) then
            return
        end

        -- Create an instance
        local mission = PlowMission.new( true , g_client ~ = nil )
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
function PlowMission:validate(event)
    if not PlowMission:superClass().validate( self , event) then
        return false
    end

    if not self:getIsFinished() then
        if not PlowMission.isAvailableForField( self.field, self ) then
            return false
        end
    end

    return true
end

```