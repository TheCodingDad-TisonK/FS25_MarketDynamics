## AbstractMission

**Parent**

> [Object](?version=script&category=&class=)

**Functions**

- [calculateReimbursement](#calculatereimbursement)
- [calculateStealingCost](#calculatestealingcost)
- [canRun](#canrun)
- [delete](#delete)
- [dismiss](#dismiss)
- [farmDestroyed](#farmdestroyed)
- [finish](#finish)
- [finishedPreparing](#finishedpreparing)
- [getActualReward](#getactualreward)
- [getActualStealingCosts](#getactualstealingcosts)
- [getActualVehicleCosts](#getactualvehiclecosts)
- [getCompletion](#getcompletion)
- [getDescription](#getdescription)
- [getDetails](#getdetails)
- [getExtraProgressText](#getextraprogresstext)
- [getFinishedDetails](#getfinisheddetails)
- [getInfo](#getinfo)
- [getIsFinished](#getisfinished)
- [getIsInProgress](#getisinprogress)
- [getIsPrepared](#getisprepared)
- [getIsReadyToStart](#getisreadytostart)
- [getIsRunning](#getisrunning)
- [getIsWorkAllowed](#getisworkallowed)
- [getLocation](#getlocation)
- [getMapHotspots](#getmaphotspots)
- [getMinutesLeft](#getminutesleft)
- [getMissionTypeName](#getmissiontypename)
- [getNPC](#getnpc)
- [getReimbursement](#getreimbursement)
- [getReward](#getreward)
- [getStealingCosts](#getstealingcosts)
- [getTitle](#gettitle)
- [getTotalReward](#gettotalreward)
- [getUniqueId](#getuniqueid)
- [getVariant](#getvariant)
- [getVehicleCosts](#getvehiclecosts)
- [getVehicleGroup](#getvehiclegroup)
- [getVehicleGroupFromIdentifier](#getvehiclegroupfromidentifier)
- [getVehicleSize](#getvehiclesize)
- [getVehicleVariant](#getvehiclevariant)
- [getWasRunning](#getwasrunning)
- [getWasStarted](#getwasstarted)
- [getWorldPosition](#getworldposition)
- [hasLeasableVehicles](#hasleasablevehicles)
- [init](#init)
- [isSpawnSpaceAvailable](#isspawnspaceavailable)
- [isTimedOut](#istimedout)
- [loadFromXMLFile](#loadfromxmlfile)
- [loadMapData](#loadmapdata)
- [new](#new)
- [onSavegameLoaded](#onsavegameloaded)
- [onSpawnedVehicle](#onspawnedvehicle)
- [onVehicleReset](#onvehiclereset)
- [prepare](#prepare)
- [reactivate](#reactivate)
- [readStream](#readstream)
- [readUpdateStream](#readupdatestream)
- [removeAccess](#removeaccess)
- [saveToXMLFile](#savetoxmlfile)
- [setDefaultEndDate](#setdefaultenddate)
- [setEndDate](#setenddate)
- [setEndDateByOffset](#setenddatebyoffset)
- [setUniqueId](#setuniqueid)
- [spawnVehicle](#spawnvehicle)
- [spawnVehicles](#spawnvehicles)
- [start](#start)
- [started](#started)
- [tryGenerateMission](#trygeneratemission)
- [unloadMapData](#unloadmapdata)
- [update](#update)
- [updateTick](#updatetick)
- [validate](#validate)
- [writeStream](#writestream)
- [writeUpdateStream](#writeupdatestream)

### calculateReimbursement

**Description**

**Definition**

> calculateReimbursement()

**Code**

```lua
function AbstractMission:calculateReimbursement()
end

```

### calculateStealingCost

**Description**

> Calculate the cost of 'stealing' (a penalty after completion of the mission)

**Definition**

> calculateStealingCost()

**Code**

```lua
function AbstractMission:calculateStealingCost()
    return 0
end

```

### canRun

**Description**

**Definition**

> canRun()

**Code**

```lua
function AbstractMission.canRun()
end

```

### delete

**Description**

> Delete the mission

**Definition**

> delete()

**Code**

```lua
function AbstractMission:delete()
    AbstractMission:superClass().delete( self )

    self:removeAccess()

    g_messageCenter:unsubscribeAll( self )

    g_missionManager:removeMission( self )
    g_messageCenter:publish(MessageType.MISSION_DELETED, self )

    local data = g_missionManager:getMissionTypeDataByName( self:getMissionTypeName())
    -- data can be nil at game shutdown
    if data ~ = nil then
        data.numInstances = math.max(data.numInstances - 1 , 0 )
    end
end

```

### dismiss

**Description**

> Dismiss mission from board. Called when mission moves from FINISH to deleted.

**Definition**

> dismiss()

**Code**

```lua
function AbstractMission:dismiss()
    if self.status ~ = MissionStatus.DISMISSED then
        self:setStatus(MissionStatus.DISMISSED)

        if self.finishState = = MissionFinishState.SUCCESS then
            self:removeAccess()
        end

        if self.isServer then
            local change = self:getTotalReward()

            if change ~ = 0 then
                local mission = g_currentMission
                mission:addMoney(change, self.farmId, MoneyType.MISSIONS, true , true )
            end
        end
    end
end

```

### farmDestroyed

**Description**

> Event when a farm got destroyed (mission will cancel)

**Definition**

> farmDestroyed()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function AbstractMission:farmDestroyed(farmId)
    if farmId = = self.farmId then
        g_missionManager:markMissionForDeletion( self )
    end
end

```

### finish

**Description**

> Finish mission (state to finished) with given finishState

**Definition**

> finish()

**Arguments**

| any | finishState |
|-----|-------------|

**Code**

```lua
function AbstractMission:finish(finishState)
    self:setStatus(MissionStatus.FINISHED)
    self.finishState = finishState

    if finishState ~ = MissionFinishState.SUCCESS then
        self:removeAccess()
    end

    local mission = g_currentMission
    if mission:getIsServer() then
        if finishState = = MissionFinishState.SUCCESS then
            g_farmManager:getFarmById( self.farmId).stats:updateMissionDone()
        end

        self.stealingCost = self:calculateStealingCost()
        g_server:broadcastEvent(MissionFinishedEvent.new( self , finishState, self.stealingCost))
    end

    mission.hud:removeSideNotificationProgressBar( self.progressBar)

    g_messageCenter:publish(MissionFinishedEvent, self , finishState)
end

```

### finishedPreparing

**Description**

**Definition**

> finishedPreparing()

**Code**

```lua
function AbstractMission:finishedPreparing()
    self:setStatus(MissionStatus.RUNNING)
end

```

### getActualReward

**Description**

**Definition**

> getActualReward()

**Code**

```lua
function AbstractMission:getActualReward()
    if self.finishState = = MissionFinishState.SUCCESS then
        return self:getReward()
    end

    return 0
end

```

### getActualStealingCosts

**Description**

**Definition**

> getActualStealingCosts()

**Code**

```lua
function AbstractMission:getActualStealingCosts()
    return self:getStealingCosts()
end

```

### getActualVehicleCosts

**Description**

**Definition**

> getActualVehicleCosts()

**Code**

```lua
function AbstractMission:getActualVehicleCosts()
    if self.spawnedVehicles then
        return self:getVehicleCosts()
    end

    return 0
end

```

### getCompletion

**Description**

> Get the completion percentage. When 1.0, mission succeeds and finishes.

**Definition**

> getCompletion()

**Code**

```lua
function AbstractMission:getCompletion()
    return 0.0
end

```

### getDescription

**Description**

**Definition**

> getDescription()

**Code**

```lua
function AbstractMission:getDescription()
    return self.description
end

```

### getDetails

**Description**

**Definition**

> getDetails()

**Code**

```lua
function AbstractMission:getDetails()
    local details = { }

    if not self:getWasStarted() or self.spawnedVehicles then
        table.insert(details, { title = g_i18n:getText( "contract_vehicleCosts" ), value = g_i18n:formatMoney( self:getVehicleCosts(), 0 , true , true ) } )
    end

    return details
end

```

### getExtraProgressText

**Description**

> Get an extra text shown with the progress bar

**Definition**

> getExtraProgressText()

**Code**

```lua
function AbstractMission:getExtraProgressText()
    return ""
end

```

### getFinishedDetails

**Description**

**Definition**

> getFinishedDetails()

**Code**

```lua
function AbstractMission:getFinishedDetails()
    local details = { }
    table.insert(details, { title = g_i18n:getText( "contract_reward" ), value = g_i18n:formatMoney( self:getActualReward(), 0 , true , true ) } )
    table.insert(details, { title = g_i18n:getText( "contract_reimbursement" ), value = g_i18n:formatMoney( self:getReimbursement(), 0 , true , true ) } )
    table.insert(details, { title = g_i18n:getText( "contract_vehicleCosts" ), value = g_i18n:formatMoney( - self:getActualVehicleCosts(), 0 , true , true ) } )
    table.insert(details, { title = g_i18n:getText( "contract_stealing" ), value = g_i18n:formatMoney( - self:getActualStealingCosts(), 0 , true , true ) } )

    return details
end

```

### getInfo

**Description**

**Definition**

> getInfo()

**Code**

```lua
function AbstractMission:getInfo()
    return self.info
end

```

### getIsFinished

**Description**

**Definition**

> getIsFinished()

**Code**

```lua
function AbstractMission:getIsFinished()
    return self.status = = MissionStatus.FINISHED
end

```

### getIsInProgress

**Description**

**Definition**

> getIsInProgress()

**Code**

```lua
function AbstractMission:getIsInProgress()
    return self.status = = MissionStatus.PREPARING or self.status = = MissionStatus.RUNNING
end

```

### getIsPrepared

**Description**

**Definition**

> getIsPrepared()

**Code**

```lua
function AbstractMission:getIsPrepared()
    if not self.spawnedVehicles then
        return true
    end

    return # self.vehiclesToLoad = = # self.vehicles
end

```

### getIsReadyToStart

**Description**

**Definition**

> getIsReadyToStart()

**Code**

```lua
function AbstractMission:getIsReadyToStart()
    return self.status = = MissionStatus.CREATED
end

```

### getIsRunning

**Description**

**Definition**

> getIsRunning()

**Code**

```lua
function AbstractMission:getIsRunning()
    return self.status = = MissionStatus.RUNNING
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
function AbstractMission:getIsWorkAllowed(farmId, x, z, workAreaType, vehicle)
    return true
end

```

### getLocation

**Description**

**Definition**

> getLocation()

**Code**

```lua
function AbstractMission:getLocation()
    return ""
end

```

### getMapHotspots

**Description**

**Definition**

> getMapHotspots()

**Code**

```lua
function AbstractMission:getMapHotspots()
    return nil
end

```

### getMinutesLeft

**Description**

**Definition**

> getMinutesLeft()

**Code**

```lua
function AbstractMission:getMinutesLeft()
    local endDate = self.endDate
    if endDate = = nil then
        return nil
    end

    local mission = g_currentMission
    local environment = mission.environment
    local currentMonotonicDay = environment.currentMonotonicDay
    local dayTime = environment.dayTime
    local totalDayTime = 24 * 60 * 60 * 1000

    local endDay = endDate.endDay
    local endDayTime = endDate.endDayTime

    local dayTimeDelta = 0
    if endDayTime > dayTime then
        dayTimeDelta = endDayTime - dayTime
    elseif currentMonotonicDay < endDay then
            dayTimeDelta = dayTime + (totalDayTime - endDayTime)
            currentMonotonicDay = currentMonotonicDay + 1
        end

        dayTimeDelta = dayTimeDelta + (endDay - currentMonotonicDay) * totalDayTime

        local minutesLeft = dayTimeDelta / ( 1000 * 60 )

        return minutesLeft
    end

```

### getMissionTypeName

**Description**

**Definition**

> getMissionTypeName()

**Code**

```lua
function AbstractMission:getMissionTypeName()
    return nil
end

```

### getNPC

**Description**

> Get the NPC for the mission

**Definition**

> getNPC()

**Code**

```lua
function AbstractMission:getNPC()
    return nil
end

```

### getReimbursement

**Description**

**Definition**

> getReimbursement()

**Code**

```lua
function AbstractMission:getReimbursement()
    return self.reimbursement
end

```

### getReward

**Description**

**Definition**

> getReward()

**Code**

```lua
function AbstractMission:getReward()
    return 0
end

```

### getStealingCosts

**Description**

**Definition**

> getStealingCosts()

**Code**

```lua
function AbstractMission:getStealingCosts()
    return 0
end

```

### getTitle

**Description**

**Definition**

> getTitle()

**Code**

```lua
function AbstractMission:getTitle()
    return self.title
end

```

### getTotalReward

**Description**

**Definition**

> getTotalReward()

**Code**

```lua
function AbstractMission:getTotalReward()
    local reward = self:getActualReward()
    local vehicleCosts = self:getActualVehicleCosts()
    local stealingCosts = self:getActualStealingCosts()
    local reimbursement = self:getReimbursement()

    return reward - vehicleCosts - stealingCosts + reimbursement
end

```

### getUniqueId

**Description**

> Gets this mission's unique id.

**Definition**

> getUniqueId()

**Return Values**

| any | uniqueId | This mission's unique id. |
|-----|----------|---------------------------|

**Code**

```lua
function AbstractMission:getUniqueId()
    return self.uniqueId
end

```

### getVariant

**Description**

**Definition**

> getVariant()

**Code**

```lua
function AbstractMission:getVariant()
    return nil
end

```

### getVehicleCosts

**Description**

**Definition**

> getVehicleCosts()

**Code**

```lua
function AbstractMission:getVehicleCosts()
    if self.vehiclesToLoad = = nil then
        return 0
    end

    local numVehicles = # self.vehiclesToLoad
    local mission = g_currentMission
    local difficultyMultiplier = 0.7 + 0.3 * mission.missionInfo.economicDifficulty
    local vehicleCosts = numVehicles * AbstractMission.VEHICLE_USE_COST

    return vehicleCosts * difficultyMultiplier
end

```

### getVehicleGroup

**Description**

> Get a list of vehicles

**Definition**

> getVehicleGroup()

**Return Values**

| any | vehicles               | List of vehicles. Each element is a vehicle xml path. Or nil |
|-----|------------------------|--------------------------------------------------------------|
| any | vehicleGroupIdentifier |                                                              |

**Code**

```lua
function AbstractMission:getVehicleGroup()
    return g_missionManager:getRandomVehicleGroup( self:getMissionTypeName(), self:getVehicleSize(), self:getVehicleVariant())
end

```

### getVehicleGroupFromIdentifier

**Description**

> Get a group of borred vehicles given the group identifier.

**Definition**

> getVehicleGroupFromIdentifier()

**Arguments**

| any | identifier |
|-----|------------|

**Code**

```lua
function AbstractMission:getVehicleGroupFromIdentifier(identifier)
    return g_missionManager:getVehicleGroupFromIdentifier( self.type.name, self:getVehicleSize(), identifier)
end

```

### getVehicleSize

**Description**

**Definition**

> getVehicleSize()

**Code**

```lua
function AbstractMission:getVehicleSize()
    return "small"
end

```

### getVehicleVariant

**Description**

> Get variant of the vehicle needed.

**Definition**

> getVehicleVariant(string? variant)

**Arguments**

| string? | variant | variant name or nil for no filter |
|---------|---------|-----------------------------------|

**Code**

```lua
function AbstractMission:getVehicleVariant()
    return nil
end

```

### getWasRunning

**Description**

**Definition**

> getWasRunning()

**Code**

```lua
function AbstractMission:getWasRunning()
    return self.status = = MissionStatus.RUNNING or self.status = = MissionStatus.FINISHED or self.status = = MissionStatus.DISMISSED
end

```

### getWasStarted

**Description**

**Definition**

> getWasStarted()

**Code**

```lua
function AbstractMission:getWasStarted()
    return self.status ~ = MissionStatus.CREATED
end

```

### getWorldPosition

**Description**

**Definition**

> getWorldPosition()

**Code**

```lua
function AbstractMission:getWorldPosition()
    return 0 , 0
end

```

### hasLeasableVehicles

**Description**

> Whether the missions upports borrowed vehicles

**Definition**

> hasLeasableVehicles()

**Code**

```lua
function AbstractMission:hasLeasableVehicles()
    return self.vehiclesToLoad ~ = nil
end

```

### init

**Description**

> Initialize the mission. Subclass to add mission-based tasks.

**Definition**

> init()

**Code**

```lua
function AbstractMission:init()

    self.vehiclesToLoad, self.vehicleGroupIdentifier = self:getVehicleGroup()

    return true
end

```

### isSpawnSpaceAvailable

**Description**

> Check if enough space is available at spawn to spawn all vehicles

**Definition**

> isSpawnSpaceAvailable()

**Code**

```lua
function AbstractMission:isSpawnSpaceAvailable()
    local result = true

    local mission = g_currentMission
    local places = mission.storeSpawnPlaces
    local usedPlaces = mission.usedStorePlaces

    local placesFilled = { }

    for _, v in ipairs( self.vehiclesToLoad) do
        local storeItem = g_storeManager:getItemByXMLFilename(v.filename)
        local size = StoreItemUtil.getSizeValues(v.filename, "vehicle" , storeItem.rotation, v.configurations)

        size.width = math.max(size.width, VehicleLoadingData.MIN_SPAWN_PLACE_WIDTH)
        size.length = math.max(size.length, VehicleLoadingData.MIN_SPAWN_PLACE_LENGTH)
        size.height = math.max(size.height, VehicleLoadingData.MIN_SPAWN_PLACE_HEIGHT)

        size.width = size.width + VehicleLoadingData.SPAWN_WIDTH_OFFSET

        local x, _, _, place, width, _ = PlacementUtil.getPlace(places, size, usedPlaces)

        if x = = nil then
            result = false
            break
        end

        PlacementUtil.markPlaceUsed(usedPlaces, place, width)
        table.insert(placesFilled, place)
    end

    for _, place in ipairs(placesFilled) do
        PlacementUtil.unmarkPlaceUsed(usedPlaces, place)
    end

    return result
end

```

### isTimedOut

**Description**

**Definition**

> isTimedOut()

**Code**

```lua
function AbstractMission:isTimedOut()
    local minutesLeft = self:getMinutesLeft()
    if minutesLeft = = nil then
        return false
    end

    return minutesLeft < = 0
end

```

### loadFromXMLFile

**Description**

> Load a mission from the savegame. Subclass to add custom properties.

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AbstractMission:loadFromXMLFile(xmlFile, key)
    self.activeMissionId = xmlFile:getValue(key .. "#activeId" ) -- can be nil

    self.status = MissionStatus.loadFromXMLFile(xmlFile, key .. "#status" )
    if self.status = = nil then
        Logging.xmlError(xmlFile, "Invalid mission status for '%s'" , key)
            return false
        end

        self.finishState = MissionFinishState.loadFromXMLFile(xmlFile, key .. "#finishState" ) or MissionFinishState.NONE

        local uniqueId = xmlFile:getValue(key .. "#uniqueId" , nil )
        if uniqueId ~ = nil then
            self:setUniqueId(uniqueId)
        end

        self.farmId = xmlFile:getValue(key .. "#farmId" )
        self.reward = xmlFile:getValue(key .. ".info#reward" ) or self.reward
        self.reimbursement = xmlFile:getValue(key .. ".info#reimbursement" ) or self.reimbursement
        self.completion = xmlFile:getValue(key .. ".info#completion" ) or self.completion
        self.stealingCost = xmlFile:getValue(key .. ".info#stealingCost" )

        local endDay = xmlFile:getValue(key .. ".endDate#endDay" )
        local endDayTime = xmlFile:getValue(key .. ".endDate#endDayTime" )
        if endDay ~ = nil and endDayTime ~ = nil then
            self:setEndDate(endDay, endDayTime)
        end

        local vehicleGroup, _
        self.spawnedVehicles = xmlFile:getValue(key .. ".vehicles#spawned" , self.spawnedVehicles)
        self.vehicleGroupIdentifier = xmlFile:getValue(key .. ".vehicles#group" )
        self.vehiclesToLoad, _, _, vehicleGroup = self:getVehicleGroupFromIdentifier( self.vehicleGroupIdentifier)

        local vehicleVariant = self:getVehicleVariant()
        if vehicleVariant ~ = nil and vehicleGroup ~ = nil and vehicleGroup.variant ~ = vehicleVariant then
            Logging.xmlWarning(xmlFile, "Loading vehicle group identifier does not match mission variant anymore.Skipping mission '%s'" , key)
            return false
        end

        if self.vehiclesToLoad = = nil then
            self.vehiclesToLoad, self.vehicleGroupIdentifier = self:getVehicleGroup()

            if self.vehiclesToLoad = = nil then
                Logging.xmlWarning(xmlFile, "Loading vehicle group failed.Skipping mission '%s'" , key)
                return false
            end
        end

        if self.spawnedVehicles and self.status ~ = MissionStatus.FINISHED and self.status ~ = MissionStatus.DISMISSED then
            self.tryToAddMissingVehicles = true
        end

        for _, vehicleKey in xmlFile:iterator(key .. ".vehicles.vehicle" ) do
            local vehicleUniqueId = xmlFile:getValue(vehicleKey .. "#uniqueId" )
            if self.pendingVehicleUniqueIds = = nil then
                self.pendingVehicleUniqueIds = { }
            end
            table.insert( self.pendingVehicleUniqueIds, vehicleUniqueId)
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
| any | baseDirectory |

**Code**

```lua
function AbstractMission.loadMapData(xmlFile, baseDirectory)
end

```

### new

**Description**

> Create a new mission

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
function AbstractMission.new(isServer, isClient, title, description, customMt)
    local self = Object.new(isServer, isClient, customMt or AbstractMission _mt)

    self.title = title
    self.progressTitle = title
    self.description = description
    self.status = MissionStatus.CREATED
    self.finishState = MissionFinishState.NONE
    self.reward = 0
    self.reimbursement = 0
    self.completion = 0
    self.vehicles = { }
    self.info = { }
    self.pendingVehicleLoadingData = { }
    self.spawnedVehicles = false

    -- The unique id of mission used to reference it from elsewhere.
    self.uniqueId = nil

    self.missionDirtyFlag = self:getNextDirtyFlag()

    g_messageCenter:subscribe(MessageType.FARM_DELETED, self.farmDestroyed, self )
    g_messageCenter:subscribe(MessageType.SAVEGAME_LOADED, self.onSavegameLoaded, self , nil , false )

    local data = g_missionManager:getMissionTypeDataByName( self:getMissionTypeName())
    data.numInstances = data.numInstances + 1

    return self
end

```

### onSavegameLoaded

**Description**

**Definition**

> onSavegameLoaded()

**Code**

```lua
function AbstractMission:onSavegameLoaded()
    if self:getWasStarted() then
        self:reactivate()
    end
end

```

### onSpawnedVehicle

**Description**

**Definition**

> onSpawnedVehicle()

**Arguments**

| any | vehicles         |
|-----|------------------|
| any | vehicleLoadState |
| any | loadingInfo      |

**Code**

```lua
function AbstractMission:onSpawnedVehicle(vehicles, vehicleLoadState, loadingInfo)
    table.removeElement( self.pendingVehicleLoadingData, loadingInfo.loadingData)

    if self.failedToLoadVehicles then
        for _, vehicle in ipairs(vehicles) do
            vehicle:delete()
        end

        return
    end

    if vehicleLoadState = = VehicleLoadingState.OK then
        for _, vehicle in ipairs(vehicles) do
            -- Vehicles are borrowed.Make them look used.
            vehicle:addWearAmount( math.random() * 0.3 + 0.1 )
            vehicle:setOperatingTime( 1000 * 60 * 60 * ( math.random() * 40 + 30 ))

            table.insert( self.vehicles, vehicle)
        end
    else
            -- mark mission as failed because of vehicles
            self.failedToLoadVehicles = true

            for _, vehicle in ipairs(vehicles) do
                vehicle:delete()
            end

            -- cancel all pending loadings
            for _, loadingData in ipairs( self.pendingVehicleLoadingData) do
                loadingData:cancelLoading()
            end
            table.clear( self.pendingVehicleLoadingData)

            -- remove the vehicle from mission vehicles
            table.clear( self.vehiclesToLoad)

            self.spawnedVehicles = false

            -- remove all already loaded vehicles
            for _, vehicle in ipairs( self.vehicles) do
                vehicle:delete()
            end
            table.clear( self.vehicles)
        end
    end

```

### onVehicleReset

**Description**

**Definition**

> onVehicleReset()

**Arguments**

| any | oldVehicle |
|-----|------------|
| any | newVehicle |

**Code**

```lua
function AbstractMission:onVehicleReset(oldVehicle, newVehicle)
    if self.isServer then
        local wasMissionVehicle = table.removeElement( self.vehicles, oldVehicle)
        if wasMissionVehicle then
            table.addElement( self.vehicles, newVehicle)
        end
    end
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
function AbstractMission:prepare(spawnVehicles)
    self:setStatus(MissionStatus.PREPARING)

    if self.isServer and spawnVehicles and self.vehiclesToLoad ~ = nil then
        self:spawnVehicles()
        g_messageCenter:subscribe(MessageType.VEHICLE_RESET, self.onVehicleReset, self )
    end
end

```

### reactivate

**Description**

**Definition**

> reactivate()

**Code**

```lua
function AbstractMission:reactivate()
    if self.spawnedVehicles then
        g_messageCenter:subscribe(MessageType.VEHICLE_RESET, self.onVehicleReset, self )
    end
end

```

### readStream

**Description**

> Read the mission from a stream

**Definition**

> readStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AbstractMission:readStream(streamId, connection)
    AbstractMission:superClass().readStream( self , streamId, connection)

    self.type = g_missionManager:getMissionTypeById(streamReadUInt8(streamId))
    self.reward = streamReadFloat32(streamId)
    self.reimbursement = streamReadFloat32(streamId)
    self.status = MissionStatus.readStream(streamId)
    self.spawnedVehicles = streamReadBool(streamId)

    self.vehicleGroupIdentifier = streamReadInt32(streamId)
    self.vehiclesToLoad = self:getVehicleGroupFromIdentifier( self.vehicleGroupIdentifier)

    if self:getWasStarted() then
        self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    end

    if self.status = = MissionStatus.RUNNING or self.status = = MissionStatus.PREPARING then
        self.activeMissionId = streamReadInt32(streamId)
    elseif self.status = = MissionStatus.FINISHED then
            self.stealingCost = streamReadFloat32(streamId)
            self.finishState = MissionFinishState.readStream(streamId)
        end

        if streamReadBool(streamId) then
            local endDay = streamReadInt32(streamId)
            local endDayTime = streamReadFloat32(streamId)
            self:setEndDate(endDay, endDayTime)
        end

        g_missionManager:assignGenerationTime( self )
        table.insert(g_missionManager.missions, self )

        -- Publish in next frame, so the overrides are handled too
        g_messageCenter:publishDelayed(MessageType.MISSION_GENERATED, self )
    end

```

### readUpdateStream

**Description**

> Read live updates.

**Definition**

> readUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function AbstractMission:readUpdateStream(streamId, timestamp, connection)
    local status = MissionStatus.readStream(streamId)
    self:setStatus( status )

    self.completion = streamReadFloat32(streamId)
end

```

### removeAccess

**Description**

> Remove access from the vehicles

**Definition**

> removeAccess()

**Code**

```lua
function AbstractMission:removeAccess()
    if self.isServer then
        self:calculateReimbursement()

        for _, vehicle in ipairs( self.vehicles) do
            if not vehicle:getIsBeingDeleted() then
                vehicle:delete()
            end
        end
        self.vehicles = { }
    end
end

```

### saveToXMLFile

**Description**

> Save the mission to the savegame. Subclass to add custom properties.

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AbstractMission:saveToXMLFile(xmlFile, key)

    xmlFile:setValue(key .. "#uniqueId" , self.uniqueId)
    MissionStatus.saveToXMLFile(xmlFile, key .. "#status" , self.status )
    MissionFinishState.saveToXMLFile(xmlFile, key .. "#finishState" , self.finishState)
    if self.farmId ~ = nil then
        xmlFile:setValue(key .. "#farmId" , self.farmId)
    end
    if self.activeMissionId ~ = nil then
        xmlFile:setValue(key .. "#activeId" , self.activeMissionId)
    end

    xmlFile:setValue(key .. ".info#reward" , self.reward)
    xmlFile:setValue(key .. ".info#reimbursement" , self.reimbursement)
    xmlFile:setValue(key .. ".info#completion" , self.completion)

    if self.stealingCost ~ = nil then
        xmlFile:setValue(key .. ".info#stealingCost" , self.stealingCost)
    end

    xmlFile:setValue(key .. ".vehicles#spawned" , self.spawnedVehicles)
    xmlFile:setValue(key .. ".vehicles#group" , self.vehicleGroupIdentifier)
    for k, vehicle in ipairs( self.vehicles) do
        xmlFile:setValue( string.format(key .. ".vehicles.vehicle(%d)#uniqueId" , k - 1 ), vehicle.uniqueId)
    end

    if self.endDate ~ = nil then
        xmlFile:setValue(key .. ".endDate#endDay" , self.endDate.endDay)
        xmlFile:setValue(key .. ".endDate#endDayTime" , self.endDate.endDayTime)
    end
end

```

### setDefaultEndDate

**Description**

**Definition**

> setDefaultEndDate()

**Code**

```lua
function AbstractMission:setDefaultEndDate()
    local mission = g_currentMission
    local environment = mission.environment
    local currentMonotonicDay = environment.currentMonotonicDay
    local daysPerPeriod = environment.daysPerPeriod
    local dayInPeriod = environment:getDayInPeriodFromDay(currentMonotonicDay)

    local endDay = currentMonotonicDay + (daysPerPeriod - dayInPeriod)
    local endDayTime = 24 * 60 * 60 * 1000 - 1

    self:setEndDate(endDay, endDayTime)
end

```

### setEndDate

**Description**

**Definition**

> setEndDate()

**Arguments**

| any | endDay     |
|-----|------------|
| any | endDayTime |

**Code**

```lua
function AbstractMission:setEndDate(endDay, endDayTime)
    self.endDate = {
endDay = endDay,
endDayTime = endDayTime
}
end

```

### setEndDateByOffset

**Description**

**Definition**

> setEndDateByOffset()

**Arguments**

| any | dayTimeOffset |
|-----|---------------|

**Code**

```lua
function AbstractMission:setEndDateByOffset(dayTimeOffset)
    local mission = g_currentMission
    local environment = mission.environment
    local currentMonotonicDay = environment.currentMonotonicDay
    local endDay, endDayTime = environment:getDayAndDayTime(dayTimeOffset, currentMonotonicDay)

    self:setEndDate(endDay, endDayTime)
end

```

### setUniqueId

**Description**

> Sets this mission's unique id. Note that a mission's id should not be changed once it has been first set.

**Definition**

> setUniqueId(string uniqueId)

**Arguments**

| string | uniqueId | The unique id to use. |
|--------|----------|-----------------------|

**Code**

```lua
function AbstractMission:setUniqueId(uniqueId)
    --#debug Assert.isType(uniqueId, "string", "Mission unique id must be a string!")
    --#debug Assert.isNil(self.uniqueId, "Should not change a missions's unique id!")
    self.uniqueId = uniqueId
end

```

### spawnVehicle

**Description**

**Definition**

> spawnVehicle()

**Arguments**

| any | info |
|-----|------|

**Code**

```lua
function AbstractMission:spawnVehicle(info)
    local data = VehicleLoadingData.new()
    data:setFilename(info.filename)
    if data.isValid then
        if info.configurations ~ = nil then
            data:setConfigurations(info.configurations)
        end

        local mission = g_currentMission
        data:setLoadingPlace(mission.storeSpawnPlaces, mission.usedStorePlaces)
        data:setPropertyState(VehiclePropertyState.MISSION)
        data:setOwnerFarmId( self.farmId)

        table.insert( self.pendingVehicleLoadingData, data)

        local loadingInfo = { loadingData = data, vehicleInfo = info }
        data:load( self.onSpawnedVehicle, self , loadingInfo)
    end
end

```

### spawnVehicles

**Description**

**Definition**

> spawnVehicles()

**Code**

```lua
function AbstractMission:spawnVehicles()
    for _, info in ipairs( self.vehiclesToLoad) do
        self:spawnVehicle(info)
    end

    self.spawnedVehicles = # self.vehiclesToLoad > 0
end

```

### start

**Description**

> Start mission (state to started, active)

**Definition**

> start()

**Arguments**

| any | spawnVehicles |
|-----|---------------|

**Code**

```lua
function AbstractMission:start(spawnVehicles)
    self:prepare(spawnVehicles)

    -- Start being active
    self:raiseActive()

    g_server:broadcastEvent(MissionStartedEvent.new( self ))

    return true
end

```

### started

**Description**

> Mission has started

**Definition**

> started()

**Code**

```lua
function AbstractMission:started()
end

```

### tryGenerateMission

**Description**

**Definition**

> tryGenerateMission()

**Code**

```lua
function AbstractMission.tryGenerateMission()
end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function AbstractMission.unloadMapData()
end

```

### update

**Description**

> Update

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AbstractMission:update(dt)
    local mission = g_currentMission
    if self.pendingVehicleUniqueIds ~ = nil then
        for i = # self.pendingVehicleUniqueIds, 1 , - 1 do
            local uniqueId = self.pendingVehicleUniqueIds[i]
            local vehicle = mission.vehicleSystem:getVehicleByUniqueId(uniqueId)
            if vehicle ~ = nil then
                table.remove( self.pendingVehicleUniqueIds, i)
                table.insert( self.vehicles, vehicle)
            end
        end

        if # self.pendingVehicleUniqueIds = = 0 then
            self.pendingVehicleUniqueIds = nil
        end
    end

    -- wait until readding is done
    if self.tryToAddMissingVehicles and self.pendingVehicleUniqueIds = = nil then
        if # self.vehicles ~ = # self.vehiclesToLoad then
            for _, info in ipairs( self.vehiclesToLoad) do
                local found = false
                for _, vehicle in ipairs( self.vehicles) do
                    if info.filename = = vehicle.configFileName then
                        found = true
                        break
                    end
                end

                if not found then
                    self:spawnVehicle(info)
                end
            end
        end

        self.tryToAddMissingVehicles = false
    end

    if self.isServer then
        if self.status = = MissionStatus.PREPARING then
            if self:getIsPrepared() then
                self:finishedPreparing()
            end

            if self.failedToLoadVehicles and # self.pendingVehicleLoadingData = = 0 then
                self:finish(MissionFinishState.FAILED)
            end
        end
    end

    if self.status = = MissionStatus.RUNNING then
        if self.isServer then
            if self:isTimedOut() then
                self:finish(MissionFinishState.TIMED_OUT)
            elseif not self:validate() then
                    self:finish(MissionFinishState.FAILED)
                end
            end
        end

        if self.status = = MissionStatus.RUNNING or self.status = = MissionStatus.FINISHED then
            if g_localPlayer ~ = nil and g_localPlayer.farmId = = self.farmId then
                if self.progressBar = = nil then
                    self.progressBar = mission.hud:addSideNotificationProgressBar(g_i18n:getText( "contract_title" ), self.progressTitle, self.completion)
                end

                self.progressBar.progress = self.completion

                mission.hud:markSideNotificationProgressBarForDrawing( self.progressBar)
            end
        end

        if self.status = = MissionStatus.RUNNING or self.status = = MissionStatus.PREPARING then
            self:raiseActive()
        end
    end

```

### updateTick

**Description**

> Update tick

**Definition**

> updateTick()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AbstractMission:updateTick(dt)
    if self.isServer and self.status = = MissionStatus.RUNNING then
        local mission = g_currentMission
        if self.lastCompletion = = nil then
            self.lastCompletion = mission.time
        elseif self.lastCompletion < mission.time - 2500 then
                self.completion = self:getCompletion()

                -- 99.5% is displayed as 100%.Adds another margin of error.If it shows 100% it should complete always because of proper user feedback
                if self.completion > = 0.995 then
                    self:finish(MissionFinishState.SUCCESS)
                end
            end

            if self.lastCompletion ~ = self.completion then
                self:raiseDirtyFlags( self.missionDirtyFlag)
            end
        end
    end

```

### validate

**Description**

> Validate that the mission is still able to run. If false, it is deleted by the mission manager

**Definition**

> validate()

**Arguments**

| any | event |
|-----|-------|

**Code**

```lua
function AbstractMission:validate(event)
    local isTimedOut = self:isTimedOut()
    return not isTimedOut
end

```

### writeStream

**Description**

> Write the mission to a stream

**Definition**

> writeStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AbstractMission:writeStream(streamId, connection)
    AbstractMission:superClass().writeStream( self , streamId, connection)

    streamWriteUInt8(streamId, self.type.typeId)
    streamWriteFloat32(streamId, self.reward)
    streamWriteFloat32(streamId, self.reimbursement)
    MissionStatus.writeStream(streamId, self.status )
    streamWriteBool(streamId, self.spawnedVehicles)
    streamWriteInt32(streamId, self.vehicleGroupIdentifier)

    if self:getWasStarted() then
        streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    end

    -- if self.isRegistered then
        if self.status = = MissionStatus.RUNNING or self.status = = MissionStatus.PREPARING then
            -- is an active mission
            streamWriteInt32(streamId, self.activeMissionId)
        elseif self.status = = MissionStatus.FINISHED then
                streamWriteFloat32(streamId, self.stealingCost or 0 )
                MissionFinishState.writeStream(streamId, self.finishState)
            end

            if streamWriteBool(streamId, self.endDate ~ = nil ) then
                streamWriteInt32(streamId, self.endDate.endDay)
                streamWriteFloat32(streamId, self.endDate.endDayTime)
            end
        end

```

### writeUpdateStream

**Description**

> Write live updates. THis includes the mission status and completion

**Definition**

> writeUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function AbstractMission:writeUpdateStream(streamId, connection, dirtyMask)
    MissionStatus.writeStream(streamId, self.status )
    streamWriteFloat32(streamId, self.completion)
end

```