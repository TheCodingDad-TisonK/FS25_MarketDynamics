## AIJobLoadAndDeliver

**Description**

> AIJobDeliver

**Parent**

> [AIJob](?version=script&category=54&class=546)

**Functions**

- [applyCurrentState](#applycurrentstate)
- [canContinueWork](#cancontinuework)
- [getDescription](#getdescription)
- [getIsAvailableForVehicle](#getisavailableforvehicle)
- [getIsLooping](#getislooping)
- [getIsStartable](#getisstartable)
- [getIsStartErrorText](#getisstarterrortext)
- [getNextTaskIndex](#getnexttaskindex)
- [getStartTaskIndex](#getstarttaskindex)
- [getTitle](#gettitle)
- [new](#new)
- [onParameterValueChanged](#onparametervaluechanged)
- [setValues](#setvalues)
- [start](#start)
- [startTask](#starttask)
- [stop](#stop)
- [updateFillTypes](#updatefilltypes)
- [validate](#validate)

### applyCurrentState

**Description**

**Definition**

> applyCurrentState()

**Arguments**

| any | vehicle       |
|-----|---------------|
| any | mission       |
| any | farmId        |
| any | isDirectStart |

**Code**

```lua
function AIJobLoadAndDeliver:applyCurrentState(vehicle, mission, farmId, isDirectStart)
    AIJobLoadAndDeliver:superClass().applyCurrentState( self , vehicle, mission, farmId, isDirectStart)

    self.vehicleParameter:setVehicle(vehicle)
    self.loopingParameter:setIsLooping( true )

    if vehicle.getLastJob ~ = nil then
        local lastJob = vehicle:getLastJob()
        if lastJob ~ = nil and lastJob:isa( AIJobLoadAndDeliver ) then
            self.unloadingStationParameter:setUnloadingStation(lastJob.unloadingStationParameter:getUnloadingStation())
            self.loadingStationParameter:setLoadingStation(lastJob.loadingStationParameter:getLoadingStation())
            self.loopingParameter:setIsLooping(lastJob.loopingParameter:getIsLooping())
        end
    end

    local unloadingStations = { }
    for _, unloadingStation in pairs(g_currentMission.storageSystem:getUnloadingStations()) do
        if g_currentMission.accessHandler:canPlayerAccess(unloadingStation) and unloadingStation:isa( UnloadingStation ) then
            local fillTypes = unloadingStation:getAISupportedFillTypes()
            if next(fillTypes) ~ = nil then
                table.insert(unloadingStations, unloadingStation)
            end
        end
    end
    table.sort(unloadingStations, function (a, b) return a:getName() < b:getName() end )
    self.unloadingStationParameter:setValidUnloadingStations(unloadingStations)

    local loadingStations = { }
    for _, loadingStation in pairs(g_currentMission.storageSystem:getLoadingStations()) do
        if g_currentMission.accessHandler:canPlayerAccess(loadingStation) then
            local fillTypes = loadingStation:getAISupportedFillTypes()
            if next(fillTypes) ~ = nil then
                table.insert(loadingStations, loadingStation)
            end
        end
    end
    table.sort(loadingStations, function (a, b) return a:getName() < b:getName() end )
    self.loadingStationParameter:setValidLoadingStations(loadingStations)

    local loadingStation = self.loadingStationParameter:getLoadingStation()
    self:updateFillTypes(loadingStation)
end

```

### canContinueWork

**Description**

**Definition**

> canContinueWork()

**Code**

```lua
function AIJobLoadAndDeliver:canContinueWork()
    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIMessageErrorVehicleDeleted.new()
    end

    local loadingStation = self.loadingStationParameter:getLoadingStation()
    if loadingStation = = nil then
        return false , AIMessageErrorLoadingStationDeleted.new()
    end

    local unloadingStation = self.unloadingStationParameter:getUnloadingStation()
    if unloadingStation = = nil then
        return false , AIMessageErrorUnloadingStationDeleted.new()
    end

    local fillTypeIndex = self.fillTypeParameter:getFillTypeIndex()
    if unloadingStation:getFreeCapacity(fillTypeIndex, self.startedFarmId) < = 0 then
        return false , AIMessageErrorUnloadingStationFull.new()
    end

    if self.currentTaskIndex = = self.loadingTask.taskIndex then
        if loadingStation:getFillLevel(fillTypeIndex, self.startedFarmId) < = 0 then
            local isEmpty = true
            for _, loadingNodeInfo in ipairs( self.loadingNodeInfos) do
                local loadingVehicle = loadingNodeInfo.vehicle
                local fillUnitIndex = loadingNodeInfo.fillUnitIndex
                if loadingVehicle:getFillUnitFillLevel(fillUnitIndex) > 0 and loadingVehicle:getFillUnitFillType(fillUnitIndex) = = fillTypeIndex then
                    isEmpty = false
                    break
                end
            end

            if isEmpty then
                return false , AIMessageSuccessSiloEmpty.new()
            end
        end
    end

    return true , nil
end

```

### getDescription

**Description**

**Definition**

> getDescription()

**Code**

```lua
function AIJobLoadAndDeliver:getDescription()
    local desc = AIJobLoadAndDeliver:superClass().getDescription( self )

    local nextTask = self:getTaskByIndex( self.currentTaskIndex)
    if nextTask = = self.driveToLoadingTask then
        desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionDriveToLoadingStation" )
    elseif nextTask = = self.loadingTask then
            desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionLoading" )
        elseif nextTask = = self.driveToUnloadingTask then
                desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionDriveToUnloadingStation" )
            elseif nextTask = = self.dischargeTask then
                    desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionUnloading" )
                end

                return desc
            end

```

### getIsAvailableForVehicle

**Description**

**Definition**

> getIsAvailableForVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AIJobLoadAndDeliver:getIsAvailableForVehicle(vehicle)
    if vehicle.createAgent = = nil or vehicle.setAITarget = = nil or not vehicle:getCanStartAIVehicle() then
        return false
    end

    if not vehicle:getIsAIJobSupported(ClassUtil.getClassNameByObject( self )) then
        return false
    end

    local vehicles = vehicle:getChildVehicles()
    for _, childVehicle in ipairs(vehicles) do
        if childVehicle.getAIDischargeNodes ~ = nil then
            local nodes = childVehicle:getAIDischargeNodes()
            if next(nodes) ~ = nil then
                return true
            end
        end
    end

    local foundDischargeNodes = false
    if vehicle.getAIDischargeNodes ~ = nil then
        local nodes = vehicle:getAIDischargeNodes()
        if next(nodes) ~ = nil then
            foundDischargeNodes = true
        end
    end

    if not foundDischargeNodes then
        vehicles = vehicle:getChildVehicles()
        for _, childVehicle in ipairs(vehicles) do
            if childVehicle.getAIDischargeNodes ~ = nil then
                local nodes = childVehicle:getAIDischargeNodes()
                if next(nodes) ~ = nil then
                    foundDischargeNodes = true
                    break
                end
            end
        end
    end

    if not foundDischargeNodes then
        return false
    end

    local foundLoadingNodes = false
    if vehicle.getAIFillUnits ~ = nil then
        local fillUnits = vehicle:getAIFillUnits()
        if next(fillUnits) ~ = nil then
            foundLoadingNodes = true
        end
    end

    if not foundLoadingNodes then
        vehicles = vehicle:getChildVehicles()
        for _, childVehicle in ipairs(vehicles) do
            if childVehicle.getAIFillUnits ~ = nil then
                local fillUnits = childVehicle:getAIFillUnits()
                if next(fillUnits) ~ = nil then
                    foundLoadingNodes = true
                    break
                end
            end
        end
    end

    if not foundLoadingNodes then
        return false
    end

    return true
end

```

### getIsLooping

**Description**

**Definition**

> getIsLooping()

**Code**

```lua
function AIJobLoadAndDeliver:getIsLooping()
    return self.loopingParameter:getIsLooping()
end

```

### getIsStartable

**Description**

**Definition**

> getIsStartable()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function AIJobLoadAndDeliver:getIsStartable(connection)
    if g_currentMission.aiSystem:getAILimitedReached() then
        return false , AIJobLoadAndDeliver.START_ERROR_LIMIT_REACHED
    end

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIJobLoadAndDeliver.START_ERROR_VEHICLE_DELETED
    end

    if not g_currentMission:getHasPlayerPermission( "hireAssistant" , connection, vehicle:getOwnerFarmId()) then
        return false , AIJobLoadAndDeliver.START_ERROR_NO_PERMISSION
    end

    if vehicle:getIsInUse(connection) then
        return false , AIJobLoadAndDeliver.START_ERROR_VEHICLE_IN_USE
    end

    return true , AIJob.START_SUCCESS
end

```

### getIsStartErrorText

**Description**

**Definition**

> getIsStartErrorText()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function AIJobLoadAndDeliver.getIsStartErrorText(state)
    if state = = AIJobLoadAndDeliver.START_ERROR_LIMIT_REACHED then
        return g_i18n:getText( "ai_startStateLimitReached" )
    elseif state = = AIJobLoadAndDeliver.START_ERROR_VEHICLE_DELETED then
            return g_i18n:getText( "ai_startStateVehicleDeleted" )
        elseif state = = AIJobLoadAndDeliver.START_ERROR_NO_PERMISSION then
                return g_i18n:getText( "ai_startStateNoPermission" )
            elseif state = = AIJobLoadAndDeliver.START_ERROR_VEHICLE_IN_USE then
                    return g_i18n:getText( "ai_startStateVehicleInUse" )
                end

                return g_i18n:getText( "ai_startStateSuccess" )
            end

```

### getNextTaskIndex

**Description**

**Definition**

> getNextTaskIndex()

**Arguments**

| any | isSkipTask |
|-----|------------|

**Code**

```lua
function AIJobLoadAndDeliver:getNextTaskIndex(isSkipTask)
    if self.currentTaskIndex = = self.driveToLoadingTask.taskIndex or self.currentTaskIndex = = self.loadingTask.taskIndex then
        -- check if there are more loadingNodes that need loading
            for _, loadingNodeInfo in ipairs( self.loadingNodeInfos) do
                if loadingNodeInfo.isDirty then
                    local vehicle = loadingNodeInfo.vehicle
                    local fillUnitIndex = loadingNodeInfo.fillUnitIndex
                    if vehicle:getFillUnitFillLevel(fillUnitIndex) = = 0 then
                        self.loadingTask:setFillUnit(vehicle, fillUnitIndex, loadingNodeInfo.offsetZ)
                        loadingNodeInfo.isDirty = false
                        --#debug log("drive to loading next fillunit")
                        return self.loadingTask.taskIndex
                    end

                    loadingNodeInfo.isDirty = false
                end
            end

        elseif self.currentTaskIndex = = self.driveToUnloadingTask.taskIndex or self.currentTaskIndex = = self.dischargeTask.taskIndex then
                local fillTypeIndex = self.fillTypeParameter:getFillTypeIndex()
                for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
                    if dischargeNodeInfo.isDirty then
                        local vehicle = dischargeNodeInfo.vehicle
                        local fillUnitIndex = dischargeNodeInfo.dischargeNode.fillUnitIndex
                        if vehicle:getFillUnitFillLevel(fillUnitIndex) > 1 and vehicle:getFillUnitFillType(fillUnitIndex) = = fillTypeIndex then
                            self.dischargeTask:setDischargeNode(vehicle, dischargeNodeInfo.dischargeNode, dischargeNodeInfo.offsetZ)
                            dischargeNodeInfo.isDirty = false
                            --#debug log("drive to discharge next trailer")
                            return self.dischargeTask.taskIndex
                        end

                        dischargeNodeInfo.isDirty = false
                    end
                end
            end

            local nextTaskIndex = AIJobLoadAndDeliver:superClass().getNextTaskIndex( self , isSkipTask)
            --#debug log("AIJobLoadAndDeliver:getNextTaskIndex(): ", self.currentTaskIndex, "->", nextTaskIndex)
            return nextTaskIndex
        end

```

### getStartTaskIndex

**Description**

**Definition**

> getStartTaskIndex()

**Code**

```lua
function AIJobLoadAndDeliver:getStartTaskIndex()
    local hasOneEmptyFillUnit = false
    for _, loadingNodeInfo in ipairs( self.loadingNodeInfos) do
        local vehicle = loadingNodeInfo.vehicle
        local fillUnitIndex = loadingNodeInfo.fillUnitIndex
        if vehicle:getFillUnitFillLevel(fillUnitIndex) = = 0 then
            hasOneEmptyFillUnit = true
            break
        end
    end

    if not hasOneEmptyFillUnit then
        return self.driveToUnloadingTask.taskIndex
    end

    return self.driveToLoadingTask.taskIndex
end

```

### getTitle

**Description**

**Definition**

> getTitle()

**Code**

```lua
function AIJobLoadAndDeliver:getTitle()
    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle ~ = nil then
        return vehicle:getName()
    end

    return ""
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | isServer |
|-----|----------|
| any | customMt |

**Code**

```lua
function AIJobLoadAndDeliver.new(isServer, customMt)
    local self = AIJob.new(isServer, customMt or AIJobLoadAndDeliver _mt)

    self.dischargeNodeInfos = { }
    self.loadingNodeInfos = { }

    self.driveToLoadingTask = AITaskDriveTo.new(isServer, self )
    self.loadingTask = AITaskLoading.new(isServer, self )
    self.driveToUnloadingTask = AITaskDriveTo.new(isServer, self )
    self.dischargeTask = AITaskDischarge.new(isServer, self )

    self:addTask( self.driveToLoadingTask)
    self:addTask( self.loadingTask)
    self:addTask( self.driveToUnloadingTask)
    self:addTask( self.dischargeTask)

    self.vehicleParameter = AIParameterVehicle.new()
    self.unloadingStationParameter = AIParameterUnloadingStation.new()
    self.loadingStationParameter = AIParameterLoadingStation.new()
    self.fillTypeParameter = AIParameterFillType.new()
    self.loopingParameter = AIParameterLooping.new()

    self:addNamedParameter( "vehicle" , self.vehicleParameter)
    self:addNamedParameter( "loadingStation" , self.loadingStationParameter)
    self:addNamedParameter( "fillType" , self.fillTypeParameter)
    self:addNamedParameter( "unloadingStation" , self.unloadingStationParameter)
    self:addNamedParameter( "looping" , self.loopingParameter)

    local vehicleGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleVehicle" ))
    vehicleGroup:addParameter( self.vehicleParameter)

    local loadTargetGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleLoadingStation" ))
    loadTargetGroup:addParameter( self.loadingStationParameter)
    loadTargetGroup:addParameter( self.fillTypeParameter)

    local unloadTargetGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleUnloadingStation" ))
    unloadTargetGroup:addParameter( self.unloadingStationParameter)

    local loopingGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleLooping" ))
    loopingGroup:addParameter( self.loopingParameter)

    table.insert( self.groupedParameters, vehicleGroup)
    table.insert( self.groupedParameters, loadTargetGroup)
    table.insert( self.groupedParameters, unloadTargetGroup)
    table.insert( self.groupedParameters, loopingGroup)

    return self
end

```

### onParameterValueChanged

**Description**

**Definition**

> onParameterValueChanged()

**Arguments**

| any | parameter |
|-----|-----------|

**Code**

```lua
function AIJobLoadAndDeliver:onParameterValueChanged(parameter)
    if parameter = = self.loadingStationParameter then
        local loadingStation = self.loadingStationParameter:getLoadingStation()
        self:updateFillTypes(loadingStation)
    end
end

```

### setValues

**Description**

**Definition**

> setValues()

**Code**

```lua
function AIJobLoadAndDeliver:setValues()
    self:resetTasks()

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return
    end
    local loadingStation = self.loadingStationParameter:getLoadingStation()
    if loadingStation = = nil then
        return
    end
    local unloadingStation = self.unloadingStationParameter:getUnloadingStation()
    if unloadingStation = = nil then
        return
    end
    local fillTypeIndex = self.fillTypeParameter:getFillTypeIndex()

    self.loadingTask:setVehicle(vehicle)
    self.driveToUnloadingTask:setVehicle(vehicle)
    self.driveToLoadingTask:setVehicle(vehicle)
    self.dischargeTask:setVehicle(vehicle)

    self.loadingNodeInfos = { }
    self.dischargeNodeInfos = { }

    if vehicle.getAIFillUnits ~ = nil then
        for _, fillUnit in ipairs(vehicle:getAIFillUnits()) do
            local fillUnitIndex = fillUnit.fillUnitIndex
            local _, _, z = vehicle:getAILoadingNodeZAlignedOffset(fillUnitIndex, vehicle)
            table.insert( self.loadingNodeInfos, { vehicle = vehicle, fillUnitIndex = fillUnitIndex, offsetZ = z, isDirty = true } )
        end
    end

    if vehicle.getAIDischargeNodes ~ = nil then
        for _, dischargeNode in ipairs(vehicle:getAIDischargeNodes()) do
            local _, _, z = vehicle:getAIDischargeNodeZAlignedOffset(dischargeNode, vehicle)
            table.insert( self.dischargeNodeInfos, { vehicle = vehicle, dischargeNode = dischargeNode, offsetZ = z, isDirty = true } )
        end
    end

    local childVehicles = vehicle:getChildVehicles()
    for _, childVehicle in ipairs(childVehicles) do
        if childVehicle.getAIDischargeNodes ~ = nil then
            for _, dischargeNode in ipairs(childVehicle:getAIDischargeNodes()) do
                local _, _, z = childVehicle:getAIDischargeNodeZAlignedOffset(dischargeNode, vehicle)
                table.insert( self.dischargeNodeInfos, { vehicle = childVehicle, dischargeNode = dischargeNode, offsetZ = z, isDirty = true } )
            end
        end

        if childVehicle.getAIFillUnits ~ = nil then
            for _, fillUnit in ipairs(childVehicle:getAIFillUnits()) do
                local fillUnitIndex = fillUnit.fillUnitIndex
                local _, _, z = childVehicle:getAILoadingNodeZAlignedOffset(fillUnitIndex, vehicle)
                table.insert( self.loadingNodeInfos, { vehicle = childVehicle, fillUnitIndex = fillUnitIndex, offsetZ = z, isDirty = true } )
            end
        end
    end

    table.sort( self.dischargeNodeInfos, function (a, b)
        return a.offsetZ > b.offsetZ
    end )

    table.sort( self.loadingNodeInfos, function (a, b)
        return a.offsetZ > b.offsetZ
    end )

    local maxDischargeOffset = 0
    if # self.dischargeNodeInfos > 0 then
        maxDischargeOffset = self.dischargeNodeInfos[# self.dischargeNodeInfos].offsetZ
    end
    self.driveToUnloadingTask:setTargetOffset( - maxDischargeOffset)

    local maxLoadingOffset = 0
    if # self.loadingNodeInfos > 0 then
        maxLoadingOffset = self.loadingNodeInfos[# self.loadingNodeInfos].offsetZ
    end
    self.driveToLoadingTask:setTargetOffset( - maxLoadingOffset)

    if fillTypeIndex ~ = nil then
        if loadingStation ~ = nil then
            local x, z, dirX, dirZ, trigger = loadingStation:getAITargetPositionAndDirection(fillTypeIndex)
            if trigger ~ = nil then
                self.driveToLoadingTask:setTargetPosition(x, z)
                self.driveToLoadingTask:setTargetDirection(dirX, dirZ)
                self.loadingTask:setLoadTrigger(trigger)
            end
        end
        if unloadingStation ~ = nil then
            local x, z, dirX, dirZ, trigger = unloadingStation:getAITargetPositionAndDirection(fillTypeIndex)
            if trigger ~ = nil then
                self.driveToUnloadingTask:setTargetPosition(x, z)
                self.driveToUnloadingTask:setTargetDirection(dirX, dirZ)
                self.dischargeTask:setUnloadTrigger(trigger)
            end
        end

        self.loadingTask:setFillType(fillTypeIndex)
    end
end

```

### start

**Description**

**Definition**

> start()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function AIJobLoadAndDeliver:start(farmId)
    -- Client start notification will be done by vehicle
    AIJobLoadAndDeliver:superClass().start( self , farmId)

    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
        vehicle:createAgent( self.helperIndex)
        vehicle:aiJobStarted( self , self.helperIndex, farmId)
    end
end

```

### startTask

**Description**

**Definition**

> startTask()

**Arguments**

| any | task |
|-----|------|

**Code**

```lua
function AIJobLoadAndDeliver:startTask(task)
    if task = = self.driveToLoadingTask then
        -- mark all discharge infos as isDirty
        for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
            dischargeNodeInfo.isDirty = true
        end
    elseif task = = self.driveToUnloadingTask then
            -- mark all fillunit infos as isDirty
            for _, loadingNodeInfo in ipairs( self.loadingNodeInfos) do
                loadingNodeInfo.isDirty = true
            end
        end

        AIJobLoadAndDeliver:superClass().startTask( self , task)
    end

```

### stop

**Description**

**Definition**

> stop()

**Arguments**

| any | aiMessage |
|-----|-----------|

**Code**

```lua
function AIJobLoadAndDeliver:stop(aiMessage)
    -- Client stop notifcation will be done by vehicle
    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
        vehicle:deleteAgent()
        vehicle:aiJobFinished()
    end

    AIJobLoadAndDeliver:superClass().stop( self , aiMessage)

    self.loadingNodeInfos = { }
    self.dischargeNodeInfos = { }
end

```

### updateFillTypes

**Description**

**Definition**

> updateFillTypes()

**Arguments**

| any | loadingStation |
|-----|----------------|

**Code**

```lua
function AIJobLoadAndDeliver:updateFillTypes(loadingStation)
    local fillTypes = { }

    if loadingStation ~ = nil then
        for fillTypeIndex, _ in pairs(loadingStation:getAISupportedFillTypes()) do
            fillTypes[fillTypeIndex] = loadingStation:getFillLevel(fillTypeIndex, g_localPlayer.farmId)
        end
    end

    self.fillTypeParameter:setValidFillTypes(fillTypes)
end

```

### validate

**Description**

**Definition**

> validate()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function AIJobLoadAndDeliver:validate(farmId)
    self:setParameterValid( true )

    local isVehicleValid, vehicleErrorMessage = self.vehicleParameter:validate()
    if isVehicleValid then
        if # self.dischargeNodeInfos = = 0 then
            isVehicleValid = false
            vehicleErrorMessage = g_i18n:getText( "ai_validationErrorNoAIDischargeNodesFound" )
        elseif # self.loadingNodeInfos = = 0 then
                isVehicleValid = false
                vehicleErrorMessage = g_i18n:getText( "ai_validationErrorNoAILoadingNodesFound" )
            end
        end
        if not isVehicleValid then
            self.vehicleParameter:setIsValid( false )
        end

        local isFillTypeValid, fillTypeErrorMessage = self.fillTypeParameter:validate()
        if not isFillTypeValid then
            self.fillTypeParameter:setIsValid( false )
        end

        local fillTypeIndex = self.fillTypeParameter:getFillTypeIndex()

        local isLoadingStationValid, loadingStationErrorMessage = self.loadingStationParameter:validate(fillTypeIndex, farmId)
        if not isLoadingStationValid then
            self.loadingStationParameter:setIsValid( false )
        end

        local isUnloadingStationValid, unloadingStationErrorMessage = self.unloadingStationParameter:validate(fillTypeIndex, farmId)
        if not isUnloadingStationValid then
            self.unloadingStationParameter:setIsValid( false )
        end

        local isValid = isVehicleValid and isFillTypeValid and isLoadingStationValid and isUnloadingStationValid
        local errorMessage = vehicleErrorMessage or fillTypeErrorMessage or loadingStationErrorMessage or unloadingStationErrorMessage

        return isValid, errorMessage
    end

```