## AbstractFieldMission

**Parent**

> [AbstractMission](?version=script&category=35&class=409)

**Functions**

- [addHotspots](#addhotspots)
- [addToMissionMap](#addtomissionmap)
- [createMapHotspot](#createmaphotspot)
- [createModifier](#createmodifier)
- [delete](#delete)
- [dismiss](#dismiss)
- [finish](#finish)
- [finishField](#finishfield)
- [getCompletion](#getcompletion)
- [getDetails](#getdetails)
- [getFarmlandId](#getfarmlandid)
- [getField](#getfield)
- [getFieldCompletion](#getfieldcompletion)
- [getFieldFinishTask](#getfieldfinishtask)
- [getFieldPreparingTask](#getfieldpreparingtask)
- [getIsPrepared](#getisprepared)
- [getIsWorkAllowed](#getisworkallowed)
- [getLocation](#getlocation)
- [getMapHotspots](#getmaphotspots)
- [getNPC](#getnpc)
- [getPartitionCompletion](#getpartitioncompletion)
- [getReward](#getreward)
- [getRewardPerHa](#getrewardperha)
- [getVehicleSize](#getvehiclesize)
- [getWorldPosition](#getworldposition)
- [init](#init)
- [initializeModifier](#initializemodifier)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [prepare](#prepare)
- [prepareField](#preparefield)
- [reactivate](#reactivate)
- [readStream](#readstream)
- [removeAccess](#removeaccess)
- [removeFromMissionMap](#removefrommissionmap)
- [removeHotspot](#removehotspot)
- [saveToXMLFile](#savetoxmlfile)
- [setField](#setfield)
- [setPartitionRegion](#setpartitionregion)
- [start](#start)
- [started](#started)
- [update](#update)
- [updateMissionMap](#updatemissionmap)
- [validate](#validate)
- [writeStream](#writestream)

### addHotspots

**Description**

**Definition**

> addHotspots()

**Code**

```lua
function AbstractFieldMission:addHotspots()
    if self.mapHotspot ~ = nil then
        self.isHotspotAdded = true
        g_currentMission:addMapHotspot( self.mapHotspot)
    end
end

```

### addToMissionMap

**Description**

> Create BitVector indicating whether the point is in the field of the mission
> Used to find a mission given (x, z)

**Definition**

> addToMissionMap()

**Code**

```lua
function AbstractFieldMission:addToMissionMap()
    if not self.isInMissionMap then
        self:updateMissionMap( self.activeMissionId)
        self.isInMissionMap = true
    end
end

```

### createMapHotspot

**Description**

**Definition**

> createMapHotspot()

**Code**

```lua
function AbstractFieldMission:createMapHotspot()
    if self.mapHotspot = = nil then
        self.mapHotspot = AbstractFieldMissionHotspot.new()
    end
    self.mapHotspot:setField( self.field)

    self.mapHotspots = {
    self.mapHotspot
    }
end

```

### createModifier

**Description**

**Definition**

> createModifier()

**Code**

```lua
function AbstractFieldMission:createModifier()
end

```

### delete

**Description**

> Delete mission

**Definition**

> delete()

**Code**

```lua
function AbstractFieldMission:delete()
    self:removeFromMissionMap()

    self:removeHotspot()

    if self.mapHotspot ~ = nil then
        self.mapHotspot:delete()
        self.mapHotspot = nil
    end

    self.mapHotspots = nil

    if self.field ~ = nil then
        self.field:setMission( nil )
        g_fieldManager:onFieldMissionDeleted()
    end

    AbstractFieldMission:superClass().delete( self )
end

```

### dismiss

**Description**

> Dismiss mission from board. Called when mission moves from FINISH to deleted.

**Definition**

> dismiss()

**Code**

```lua
function AbstractFieldMission:dismiss()
    self:finishField()
    AbstractFieldMission:superClass().dismiss( self )
end

```

### finish

**Description**

> Mission was finished with or without finishState

**Definition**

> finish()

**Arguments**

| any | finishState |
|-----|-------------|

**Code**

```lua
function AbstractFieldMission:finish(finishState)
    AbstractFieldMission:superClass().finish( self , finishState)

    self:removeHotspot()

    local mission = g_currentMission
    if mission:getFarmId() = = self.farmId then
        if finishState = = MissionFinishState.SUCCESS then
            mission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_OK, string.format(g_i18n:getText( "contract_field_finished" ), self.field:getId()))
        elseif finishState = = MissionFinishState.FAILED then
                mission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText( "contract_field_failed" ), self.field:getId()))
            elseif finishState = = MissionFinishState.TIMED_OUT then
                    mission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText( "contract_field_timedOut" ), self.field:getId()))
                end
            end
        end

```

### finishField

**Description**

**Definition**

> finishField()

**Code**

```lua
function AbstractFieldMission:finishField()
    if self.isServer then
        local task = self:getFieldFinishTask()
        if task ~ = nil then
            task:setField( self.field)
            g_fieldManager:addFieldUpdateTask(task)
        end
    end
end

```

### getCompletion

**Description**

> Get current completion.

**Definition**

> getCompletion()

**Code**

```lua
function AbstractFieldMission:getCompletion()
    local fieldCompletion = self:getFieldCompletion()

    return fieldCompletion / AbstractMission.SUCCESS_FACTOR
end

```

### getDetails

**Description**

**Definition**

> getDetails()

**Code**

```lua
function AbstractFieldMission:getDetails()
    local details = AbstractFieldMission:superClass().getDetails( self )

    table.insert(details, { title = g_i18n:getText( "contract_details_field" ), value = self.field:getName() } )
    table.insert(details, { title = g_i18n:getText( "contract_details_fieldSize" ), value = g_i18n:formatArea( self.field:getAreaHa(), 2 ) } )

    return details
end

```

### getFarmlandId

**Description**

**Definition**

> getFarmlandId()

**Code**

```lua
function AbstractFieldMission:getFarmlandId()
    local field = self.field
    if field ~ = nil then
        return field:getId()
    end

    return nil
end

```

### getField

**Description**

**Definition**

> getField()

**Code**

```lua
function AbstractFieldMission:getField()
    return self.field
end

```

### getFieldCompletion

**Description**

> Calculate field completion in an optimized way, split over multiple updates

**Definition**

> getFieldCompletion()

**Code**

```lua
function AbstractFieldMission:getFieldCompletion()
    if not self.isFieldCompletionInitialized then
        self:initializeModifier()
        self.isFieldCompletionInitialized = true
    end

    if self.currentPartitionCompletionIndex = = nil then
        self.currentPartitionCompletionIndex = 1
    end

    local sumPixels, area, totalArea = self:getPartitionCompletion( self.currentPartitionCompletionIndex)
    if area ~ = nil then
        local partition = self.completionPartitions[ self.currentPartitionCompletionIndex]
        partition.wasCalculated = true
        partition.sumPixels = sumPixels
        partition.area = area
        partition.totalArea = totalArea
    end

    self:updateFieldPercentageDone(totalArea)

    self.currentPartitionCompletionIndex = self.currentPartitionCompletionIndex + 1
    if self.currentPartitionCompletionIndex > # self.completionPartitions then
        self.currentPartitionCompletionIndex = 1
    end

    return self.fieldPercentageDone
end

```

### getFieldFinishTask

**Description**

**Definition**

> getFieldFinishTask()

**Code**

```lua
function AbstractFieldMission:getFieldFinishTask()
    local fieldState = self.field:getFieldState()
    if fieldState.isValid then
        return fieldState:createFieldUpdateTask()
    end

    return nil
end

```

### getFieldPreparingTask

**Description**

**Definition**

> getFieldPreparingTask()

**Code**

```lua
function AbstractFieldMission:getFieldPreparingTask()
    local fieldState = self.field:getFieldState()
    if not fieldState.isValid then
        return
    end

    local fieldPreparingTask = fieldState:createFieldUpdateTask()
    fieldPreparingTask:clearHeight()
    fieldPreparingTask:setField( self.field)

    return fieldPreparingTask
end

```

### getIsPrepared

**Description**

**Definition**

> getIsPrepared()

**Code**

```lua
function AbstractFieldMission:getIsPrepared()
    if not AbstractFieldMission:superClass().getIsPrepared( self ) then
        return false
    end

    if self.fieldPreparingTask = = nil then
        return true
    end

    return self.fieldPreparingTask:getIsFinished()
end

```

### getIsWorkAllowed

**Description**

**Definition**

> getIsWorkAllowed()

**Arguments**

| any | farmId       |
|-----|--------------|
| any | x            |
| any | z            |
| any | workAreaType |
| any | vehicle      |

**Code**

```lua
function AbstractFieldMission:getIsWorkAllowed(farmId, x, z, workAreaType, vehicle)
    return self:getIsRunning() and(workAreaType = = nil or self.workAreaTypes[workAreaType])
end

```

### getLocation

**Description**

**Definition**

> getLocation()

**Code**

```lua
function AbstractFieldMission:getLocation()
    local name = self.field:getName()
    return string.format(g_i18n:getText( "contract_farmland" ), name)
end

```

### getMapHotspots

**Description**

**Definition**

> getMapHotspots()

**Code**

```lua
function AbstractFieldMission:getMapHotspots()
    return self.mapHotspots
end

```

### getNPC

**Description**

> Get the NPC giving this mission

**Definition**

> getNPC()

**Code**

```lua
function AbstractFieldMission:getNPC()
    return self.field.farmland:getNPC()
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
function AbstractFieldMission:getPartitionCompletion(partitionIndex)
    self:setPartitionRegion(partitionIndex)

    if self.completionModifier ~ = nil then
        local sumPixels, area, totalArea = self.completionModifier:executeGet( self.completionFilter)

        return sumPixels, area, totalArea
    end

    return 0 , 0 , 0
end

```

### getReward

**Description**

**Definition**

> getReward()

**Code**

```lua
function AbstractFieldMission:getReward()
    local mission = g_currentMission
    -- Less on harder modes.1.2, 1.1, 1.0
    local difficultyMultiplier = 1.3 - 0.1 * mission.missionInfo.economicDifficulty
    local area = self.field:getAreaHa()

    local base = AbstractFieldMission:superClass().getReward( self )
    local rewardPerHa = self:getRewardPerHa()
    local reward = rewardPerHa * area

    return base + reward * difficultyMultiplier
end

```

### getRewardPerHa

**Description**

**Definition**

> getRewardPerHa()

**Code**

```lua
function AbstractFieldMission:getRewardPerHa()
    return 1
end

```

### getVehicleSize

**Description**

> Get a categorized field size for leased vehicle groups.

**Definition**

> getVehicleSize()

**Code**

```lua
function AbstractFieldMission:getVehicleSize()
    local areaHa = self.field:getAreaHa()
    local fieldSize = "small"
    if areaHa > AbstractFieldMission.FIELD_SIZE_LARGE then
        fieldSize = "large"
    elseif areaHa > AbstractFieldMission.FIELD_SIZE_MEDIUM then
            fieldSize = "medium"
        end

        return fieldSize
    end

```

### getWorldPosition

**Description**

**Definition**

> getWorldPosition()

**Code**

```lua
function AbstractFieldMission:getWorldPosition()
    return self.field:getIndicatorPosition()
end

```

### init

**Description**

**Definition**

> init()

**Arguments**

| any | field |
|-----|-------|

**Code**

```lua
function AbstractFieldMission:init(field)
    self:setField(field)
    return AbstractFieldMission:superClass().init( self )
end

```

### initializeModifier

**Description**

**Definition**

> initializeModifier()

**Code**

```lua
function AbstractFieldMission:initializeModifier()
    if self.completionModifier ~ = nil then
        local densityMapPolygon = self.field:getDensityMapPolygon()
        densityMapPolygon:applyToModifier( self.completionModifier)

        self.completionPartitions = { }
        local numPartitions = 1
        local minZ, maxZ = self.completionModifier:getPolygonMinMaxZ()
        if minZ ~ = nil then
            local sizeSqm = MathUtil.haToSqm( self.field:getAreaHa())
            numPartitions = math.ceil(sizeSqm / AbstractFieldMission.SQM_PER_PARTITION)

            local currentMinZ, currentMaxZ
            local regionPerPartition = (maxZ - minZ) / numPartitions
            for i = 1 , numPartitions do
                if currentMinZ = = nil then
                    currentMinZ = minZ
                else
                        currentMinZ = currentMaxZ
                    end

                    currentMaxZ = math.ceil(currentMinZ + regionPerPartition)

                    local partition = {
                    wasCalculated = false ,
                    percentageDone = 0 ,
                    sumPixels = 0 ,
                    area = 0 ,
                    totalArea = 0 ,
                    minZ = currentMinZ,
                    maxZ = math.min(currentMaxZ, maxZ)
                    }

                    table.insert( self.completionPartitions, partition)

                    if currentMinZ = = nil or currentMaxZ > = maxZ then
                        break
                    end
                end
            else
                    local partition = {
                    wasCalculated = false ,
                    percentageDone = 0 ,
                    sumPixels = 0 ,
                    area = 0 ,
                    totalArea = 0
                    }

                    table.insert( self.completionPartitions, partition)
                end
            end
        end

```

### loadFromXMLFile

**Description**

> Load mission from savegame

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AbstractFieldMission:loadFromXMLFile(xmlFile, key)
    local fieldId = xmlFile:getValue(key .. ".field#id" )
    local field = g_fieldManager:getFieldById(fieldId)

    if field = = nil then
        Logging.xmlWarning(xmlFile, "Mission '%s' field '%s' is not available." , key, fieldId)
        return false
    end

    self:setField(field)

    if not AbstractFieldMission:superClass().loadFromXMLFile( self , xmlFile, key) then
        return false
    end

    local fieldPreparingTaskKey = key .. ".field.preparingTask"
    if xmlFile:hasProperty(fieldPreparingTaskKey) then
        local className = xmlFile:getValue(fieldPreparingTaskKey .. "#className" , "FieldUpdateTask" )
        local class = ClassUtil.getClassObject(className)
        if class ~ = nil then
            local fieldPreparingTask = class.new()
            if fieldPreparingTask:loadFromXMLFile(xmlFile, fieldPreparingTaskKey) then
                fieldPreparingTask:setNeedsSaving( false )
                fieldPreparingTask:enqueue()
                self.fieldPreparingTask = fieldPreparingTask
            end
        else
                Logging.xmlWarning(xmlFile, "Class '%s' not defined for update task '%s'" , className, fieldPreparingTaskKey)
                end
            end

            if self.status = = MissionStatus.PREPARING or self.status = = MissionStatus.RUNNING then
                self:addToMissionMap()
            end

            return true
        end

```

### new

**Description**

> Create new mission

**Definition**

> new()

**Arguments**

| any | isServer    |
|-----|-------------|
| any | isClient    |
| any | title       |
| any | description |
| any | customMt    |

**Code**

```lua
function AbstractFieldMission.new(isServer, isClient, title, description, customMt)
    local self = AbstractMission.new(isServer, isClient, title, description, customMt or AbstractFieldMission _mt)

    self.workAreaTypes = { }
    self.moneyMultiplier = 1.0
    self.isInMissionMap = false
    self.fieldPercentageDone = 0.0

    self.completionModifier = nil
    self.completionFilter = nil

    self.isHotspotAdded = false
    self.mapHotspot = nil

    return self
end

```

### prepare

**Description**

**Definition**

> prepare()

**Arguments**

| any | spawnVehicles |
|-----|---------------|

**Code**

```lua
function AbstractFieldMission:prepare(spawnVehicles)
    AbstractFieldMission:superClass().prepare( self , spawnVehicles)

    self:prepareField()
    self:createModifier()
end

```

### prepareField

**Description**

**Definition**

> prepareField()

**Code**

```lua
function AbstractFieldMission:prepareField()
    if self.isServer then
        self.fieldPreparingTask = self:getFieldPreparingTask()
        if self.fieldPreparingTask ~ = nil then
            self.fieldPreparingTask:setNeedsSaving( false )
            g_fieldManager:addFieldUpdateTask( self.fieldPreparingTask)
        end
    end
end

```

### reactivate

**Description**

**Definition**

> reactivate()

**Code**

```lua
function AbstractFieldMission:reactivate()
    self:createModifier()

    AbstractFieldMission:superClass().reactivate( self )
end

```

### readStream

**Description**

**Definition**

> readStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AbstractFieldMission:readStream(streamId, connection)
    local fieldId = streamReadInt32(streamId)
    local field = g_fieldManager:getFieldById(fieldId)

    self:setField(field)

    AbstractFieldMission:superClass().readStream( self , streamId, connection)

    if self.status = = MissionStatus.PREPARING or self.status = = MissionStatus.RUNNING then
        self:addToMissionMap()
    end
end

```

### removeAccess

**Description**

> Remove access from the field

**Definition**

> removeAccess()

**Code**

```lua
function AbstractFieldMission:removeAccess()
    self:removeFromMissionMap()
    AbstractFieldMission:superClass().removeAccess( self )
end

```

### removeFromMissionMap

**Description**

**Definition**

> removeFromMissionMap()

**Code**

```lua
function AbstractFieldMission:removeFromMissionMap()
    if self.isInMissionMap then
        self:updateMissionMap( 0 )
        self.isInMissionMap = false
    end
end

```

### removeHotspot

**Description**

**Definition**

> removeHotspot()

**Code**

```lua
function AbstractFieldMission:removeHotspot()
    if self.mapHotspot ~ = nil then
        g_currentMission:removeMapHotspot( self.mapHotspot)
        self.isHotspotAdded = false
    end
end

```

### saveToXMLFile

**Description**

> Save mission

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AbstractFieldMission:saveToXMLFile(xmlFile, key)
    AbstractFieldMission:superClass().saveToXMLFile( self , xmlFile, key)
    xmlFile:setValue(key .. ".field#id" , self.field:getId())

    if self.status = = MissionStatus.PREPARING and self.fieldPreparingTask ~ = nil and self.fieldPreparingTask:getIsFinished() then
        local taskKey = key .. ".field.preparingTask"
        xmlFile:setValue(taskKey .. "#className" , ClassUtil.getClassNameByObject( self.fieldPreparingTask))
        self.fieldPreparingTask:saveToXMLFile(xmlFile, taskKey)
    end
end

```

### setField

**Description**

**Definition**

> setField()

**Arguments**

| any | field |
|-----|-------|

**Code**

```lua
function AbstractFieldMission:setField(field)
    self.field = field
    field:setMission( self )

    local fieldId = field:getId()
    if fieldId ~ = nil then
        self.progressTitle = string.format( "%s(%s %d)" , self.title, g_i18n:getText( "contract_details_field" ), fieldId)
    end

    g_fieldManager:onFieldMissionStarted()

    self:createMapHotspot()
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
function AbstractFieldMission:setPartitionRegion(partitionIndex)
    if self.completionPartitions = = nil or # self.completionPartitions = = 1 then
        return
    end

    if self.completionModifier ~ = nil then
        local partition = self.completionPartitions[partitionIndex]
        self.completionModifier:setPolygonClipRegion(partition.minZ, partition.maxZ)
    end
end

```

### start

**Description**

> Start the mission with or without borrowed vehicles

**Definition**

> start()

**Arguments**

| any | spawnVehicles |
|-----|---------------|

**Code**

```lua
function AbstractFieldMission:start(spawnVehicles)
    if not AbstractFieldMission:superClass().start( self , spawnVehicles) then
        return false
    end

    self:addToMissionMap()

    return true
end

```

### started

**Description**

**Definition**

> started()

**Code**

```lua
function AbstractFieldMission:started()
    self:addToMissionMap()
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AbstractFieldMission:update(dt)
    AbstractFieldMission:superClass().update( self , dt)

    if self.status = = MissionStatus.RUNNING and g_localPlayer ~ = nil and g_localPlayer.farmId = = self.farmId and not self.isHotspotAdded then
        self:addHotspots()
    end
end

```

### updateMissionMap

**Description**

**Definition**

> updateMissionMap()

**Arguments**

| any | missionId |
|-----|-----------|

**Code**

```lua
function AbstractFieldMission:updateMissionMap(missionId)
    local polygon = self.field:getDensityMapPolygon()
    g_missionManager:setMissionMapActiveMissionId(polygon, missionId)
end

```

### validate

**Description**

**Definition**

> validate()

**Code**

```lua
function AbstractFieldMission:validate()
    if not AbstractFieldMission:superClass().validate( self ) then
        return false
    end

    if self.field = = nil then
        return false
    end

    return not self.field:getHasOwner()
end

```

### writeStream

**Description**

**Definition**

> writeStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AbstractFieldMission:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.field:getId())

    AbstractFieldMission:superClass().writeStream( self , streamId, connection)
end

```