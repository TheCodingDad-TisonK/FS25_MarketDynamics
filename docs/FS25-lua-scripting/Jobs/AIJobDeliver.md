## AIJobDeliver

**Parent**

> [AIJob](?version=script&category=54&class=543)

**Functions**

- [applyCurrentState](#applycurrentstate)
- [canContinueWork](#cancontinuework)
- [getCanSkipTask](#getcanskiptask)
- [getDescription](#getdescription)
- [getHasLoadedValidFillType](#gethasloadedvalidfilltype)
- [getIsAvailableForVehicle](#getisavailableforvehicle)
- [getIsLooping](#getislooping)
- [getIsStartable](#getisstartable)
- [getIsStartErrorText](#getisstarterrortext)
- [getNextTaskIndex](#getnexttaskindex)
- [getStartTaskIndex](#getstarttaskindex)
- [getTitle](#gettitle)
- [new](#new)
- [setValues](#setvalues)
- [skipCurrentTask](#skipcurrenttask)
- [start](#start)
- [startTask](#starttask)
- [stop](#stop)
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
function AIJobDeliver:applyCurrentState(vehicle, mission, farmId, isDirectStart)
    AIJobDeliver:superClass().applyCurrentState( self , vehicle, mission, farmId, isDirectStart)

    self.vehicleParameter:setVehicle(vehicle)
    self.loopingParameter:setIsLooping( true )

    local x, z, angle, _
    if vehicle.getLastJob ~ = nil then
        local lastJob = vehicle:getLastJob()
        if lastJob ~ = nil and lastJob:isa( AIJobDeliver ) then
            self.unloadingStationParameter:setUnloadingStation(lastJob.unloadingStationParameter:getUnloadingStation())
            self.loopingParameter:setIsLooping(lastJob.loopingParameter:getIsLooping())
            x, z = lastJob.positionAngleParameter:getPosition()
            angle = lastJob.positionAngleParameter:getAngle()
        end
    end

    if x = = nil or z = = nil then
        x, _, z = getWorldTranslation(vehicle.rootNode)
    end
    if angle = = nil then
        local dirX, _, dirZ = localDirectionToWorld(vehicle.rootNode, 0 , 0 , 1 )
        angle = MathUtil.getYRotationFromDirection(dirX, dirZ)
    end

    self.positionAngleParameter:setPosition(x, z)
    self.positionAngleParameter:setAngle(angle)

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
end

```

### canContinueWork

**Description**

**Definition**

> canContinueWork()

**Code**

```lua
function AIJobDeliver:canContinueWork()
    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIMessageErrorVehicleDeleted.new()
    end

    local unloadingStation = self.unloadingStationParameter:getUnloadingStation()
    if unloadingStation = = nil then
        return false , AIMessageErrorUnloadingStationDeleted.new()
    end

    -- check if unloading station is full
        if self.currentTaskIndex = = self.waitForFillingTask.taskIndex then
            local hasSpace = false

            for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
                local dischargeVehicle = dischargeNodeInfo.vehicle
                local fillUnitIndex = dischargeNodeInfo.dischargeNode.fillUnitIndex
                if dischargeVehicle:getFillUnitFillLevel(fillUnitIndex) > 1 then
                    local fillTypeIndex = dischargeVehicle:getFillUnitFillType(fillUnitIndex)
                    if unloadingStation:getFreeCapacity(fillTypeIndex, self.startedFarmId) > 0 then
                        hasSpace = true
                        break
                    end
                end
            end

            if not hasSpace then
                return false , AIMessageErrorUnloadingStationFull.new()
            end
        end

        return true , nil
    end

```

### getCanSkipTask

**Description**

**Definition**

> getCanSkipTask()

**Code**

```lua
function AIJobDeliver:getCanSkipTask()
    if self.currentTaskIndex = = self.waitForFillingTask.taskIndex and not self.waitForFillingTask.isFinished then
        if self:getHasLoadedValidFillType() then
            return true
        end
    end

    return false
end

```

### getDescription

**Description**

**Definition**

> getDescription()

**Code**

```lua
function AIJobDeliver:getDescription()
    local desc = AIJobDeliver:superClass().getDescription( self )

    local nextTask = self:getTaskByIndex( self.currentTaskIndex)
    if nextTask = = self.driveToLoadingTask then
        desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionDriveToLoadingStation" )
    elseif nextTask = = self.waitForFillingTask then
            desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionWaitForFilling" )
        elseif nextTask = = self.driveToUnloadingTask then
                desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionDriveToUnloadingStation" )
            elseif nextTask = = self.dischargeTask then
                    desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionUnloading" )
                end

                return desc
            end

```

### getHasLoadedValidFillType

**Description**

**Definition**

> getHasLoadedValidFillType()

**Code**

```lua
function AIJobDeliver:getHasLoadedValidFillType()
    local unloadingStation = self.unloadingStationParameter:getUnloadingStation()

    for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
        local vehicle = dischargeNodeInfo.vehicle
        local fillUnitIndex = dischargeNodeInfo.dischargeNode.fillUnitIndex
        if vehicle:getFillUnitFillLevel(fillUnitIndex) > 1 then
            local fillType = vehicle:getFillUnitFillType(fillUnitIndex)
            if unloadingStation:getIsFillTypeAISupported(fillType) then
                return true
            end
        end
    end

    return false
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
function AIJobDeliver:getIsAvailableForVehicle(vehicle)
    if vehicle.createAgent = = nil or vehicle.setAITarget = = nil or not vehicle:getCanStartAIVehicle() then
        return false
    end

    if not vehicle:getIsAIJobSupported(ClassUtil.getClassNameByObject( self )) then
        return false
    end

    if vehicle.getAIDischargeNodes ~ = nil then
        local nodes = vehicle:getAIDischargeNodes()
        if next(nodes) ~ = nil then
            return true
        end
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

    return false
end

```

### getIsLooping

**Description**

**Definition**

> getIsLooping()

**Code**

```lua
function AIJobDeliver:getIsLooping()
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
function AIJobDeliver:getIsStartable(connection)
    if g_currentMission.aiSystem:getAILimitedReached() then
        return false , AIJobDeliver.START_ERROR_LIMIT_REACHED
    end

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIJobDeliver.START_ERROR_VEHICLE_DELETED
    end

    if not g_currentMission:getHasPlayerPermission( "hireAssistant" , connection, vehicle:getOwnerFarmId()) then
        return false , AIJobDeliver.START_ERROR_NO_PERMISSION
    end

    if vehicle:getIsInUse(connection) then
        return false , AIJobDeliver.START_ERROR_VEHICLE_IN_USE
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
function AIJobDeliver.getIsStartErrorText(state)
    if state = = AIJobDeliver.START_ERROR_LIMIT_REACHED then
        return g_i18n:getText( "ai_startStateLimitReached" )
    elseif state = = AIJobDeliver.START_ERROR_VEHICLE_DELETED then
            return g_i18n:getText( "ai_startStateVehicleDeleted" )
        elseif state = = AIJobDeliver.START_ERROR_NO_PERMISSION then
                return g_i18n:getText( "ai_startStateNoPermission" )
            elseif state = = AIJobDeliver.START_ERROR_VEHICLE_IN_USE then
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
function AIJobDeliver:getNextTaskIndex(isSkipTask)
    if self.currentTaskIndex = = self.waitForFillingTask.taskIndex or self.currentTaskIndex = = self.dischargeTask.taskIndex then
        local lastUnloadTrigger
        if self.currentTaskIndex = = self.dischargeTask.taskIndex then
            lastUnloadTrigger = self.dischargeTask.unloadTrigger
        end

        -- check if there are more dischargeNodes that need discharge to the last unloadtrigger
            local nextFillType = nil
            local nextDischargeNodeInfo = nil
            local unloadingStation = self.unloadingStationParameter:getUnloadingStation()
            for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
                if dischargeNodeInfo.dirty then
                    local vehicle = dischargeNodeInfo.vehicle
                    local fillUnitIndex = dischargeNodeInfo.dischargeNode.fillUnitIndex
                    if vehicle:getFillUnitFillLevel(fillUnitIndex) > 1 then
                        local currentFillType = vehicle:getFillUnitFillType(fillUnitIndex)
                        if lastUnloadTrigger ~ = nil and lastUnloadTrigger:getIsFillTypeSupported(currentFillType) then
                            self.dischargeTask:setDischargeNode(vehicle, dischargeNodeInfo.dischargeNode, dischargeNodeInfo.offsetZ)
                            dischargeNodeInfo.dirty = false
                            --#debug log("drive to discharge next trailer")
                            return self.currentTaskIndex

                        elseif nextFillType = = nil then
                                local _, _, _, _, trigger = unloadingStation:getAITargetPositionAndDirection(currentFillType)
                                if trigger ~ = nil then
                                    nextFillType = currentFillType
                                    nextDischargeNodeInfo = dischargeNodeInfo
                                else
                                        -- unloading station does not support fill type.mark node as handled
                                        dischargeNodeInfo.dirty = false
                                    end
                                end
                            end
                        end
                    end

                    if nextFillType ~ = nil then
                        --#debug log("Next index drive to uinloading", g_fillTypeManager:getFillTypeNameByIndex(nextFillType))
                        local x, z, dirX, dirZ, trigger = unloadingStation:getAITargetPositionAndDirection(nextFillType)
                        self.driveToUnloadingTask:setTargetPosition(x, z)
                        self.driveToUnloadingTask:setTargetDirection(dirX, dirZ)
                        self.dischargeTask:setUnloadTrigger(trigger)
                        self.dischargeTask:setDischargeNode(nextDischargeNodeInfo.vehicle, nextDischargeNodeInfo.dischargeNode, nextDischargeNodeInfo.offsetZ)
                        nextDischargeNodeInfo.dirty = false

                        return self.driveToUnloadingTask.taskIndex
                    end
                end

                local nextTaskIndex = AIJobDeliver:superClass().getNextTaskIndex( self , isSkipTask)
                --#debug log("Other: ", self.currentTaskIndex, "->", nextTaskIndex)
                return nextTaskIndex
            end

```

### getStartTaskIndex

**Description**

**Definition**

> getStartTaskIndex()

**Code**

```lua
function AIJobDeliver:getStartTaskIndex()
    local hasOneEmptyFillUnit = false
    for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
        local vehicle = dischargeNodeInfo.vehicle
        local fillUnitIndex = dischargeNodeInfo.dischargeNode.fillUnitIndex
        if vehicle:getFillUnitFillLevel(fillUnitIndex) = = 0 then
            hasOneEmptyFillUnit = true
            break
        end
    end

    -- check if already at target position
        local vehicle = self.vehicleParameter:getVehicle()
        local x, _, z = getWorldTranslation(vehicle.rootNode)
        local tx, tz = self.positionAngleParameter:getPosition()
        local targetReached = math.abs(x - tx) < 1 and math.abs(z - tz) < 1
        if targetReached then
            if not hasOneEmptyFillUnit then
                self.waitForFillingTask:skip()
            end
            return self.waitForFillingTask.taskIndex
        end

        if not hasOneEmptyFillUnit then
            self.driveToLoadingTask:skip()
            self.waitForFillingTask:skip()
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
function AIJobDeliver:getTitle()
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
function AIJobDeliver.new(isServer, customMt)
    local self = AIJob.new(isServer, customMt or AIJobDeliver _mt)

    self.dischargeNodeInfos = { }

    self.driveToLoadingTask = AITaskDriveTo.new(isServer, self )
    self.waitForFillingTask = AITaskWaitForFilling.new(isServer, self )
    self.driveToUnloadingTask = AITaskDriveTo.new(isServer, self )
    self.dischargeTask = AITaskDischarge.new(isServer, self )

    self:addTask( self.driveToLoadingTask)
    self:addTask( self.waitForFillingTask)
    self:addTask( self.driveToUnloadingTask)
    self:addTask( self.dischargeTask)

    self.vehicleParameter = AIParameterVehicle.new()
    self.unloadingStationParameter = AIParameterUnloadingStation.new()
    self.loopingParameter = AIParameterLooping.new()
    self.positionAngleParameter = AIParameterPositionAngle.new( math.rad( 5 ))

    self:addNamedParameter( "vehicle" , self.vehicleParameter)
    self:addNamedParameter( "unloadingStation" , self.unloadingStationParameter)
    self:addNamedParameter( "looping" , self.loopingParameter)
    self:addNamedParameter( "positionAngle" , self.positionAngleParameter)

    local vehicleGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleVehicle" ))
    vehicleGroup:addParameter( self.vehicleParameter)

    local unloadTargetGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleUnloadingStation" ))
    unloadTargetGroup:addParameter( self.unloadingStationParameter)

    local positionGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleLoadingPosition" ))
    positionGroup:addParameter( self.positionAngleParameter)

    local loopingGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleLooping" ))
    loopingGroup:addParameter( self.loopingParameter)

    table.insert( self.groupedParameters, vehicleGroup)
    table.insert( self.groupedParameters, unloadTargetGroup)
    table.insert( self.groupedParameters, positionGroup)
    table.insert( self.groupedParameters, loopingGroup)

    return self
end

```

### setValues

**Description**

**Definition**

> setValues()

**Code**

```lua
function AIJobDeliver:setValues()
    self:resetTasks()

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return
    end
    local unloadingStation = self.unloadingStationParameter:getUnloadingStation()
    if unloadingStation = = nil then
        return
    end

    self.driveToUnloadingTask:setVehicle(vehicle)
    self.driveToLoadingTask:setVehicle(vehicle)
    self.dischargeTask:setVehicle(vehicle)
    self.waitForFillingTask:setVehicle(vehicle)

    self.dischargeNodeInfos = { }

    -- apply allowed fill types based on unloading trigger
    for fillType, _ in pairs(unloadingStation:getAISupportedFillTypes()) do
        self.waitForFillingTask:addAllowedFillType(fillType)
    end

    if vehicle.getAIDischargeNodes ~ = nil then
        for _, dischargeNode in ipairs(vehicle:getAIDischargeNodes()) do

            local _, _, z = vehicle:getAIDischargeNodeZAlignedOffset(dischargeNode, vehicle)
            table.insert( self.dischargeNodeInfos, { vehicle = vehicle, dischargeNode = dischargeNode, offsetZ = z, dirty = true } )
        end
    end

    local childVehicles = vehicle:getChildVehicles()
    for _, childVehicle in ipairs(childVehicles) do
        if childVehicle.getAIDischargeNodes ~ = nil then
            for _, dischargeNode in ipairs(childVehicle:getAIDischargeNodes()) do
                local _, _, z = childVehicle:getAIDischargeNodeZAlignedOffset(dischargeNode, vehicle)
                table.insert( self.dischargeNodeInfos, { vehicle = childVehicle, dischargeNode = dischargeNode, offsetZ = z, dirty = true } )
            end
        end
    end

    if # self.dischargeNodeInfos = = 0 then
        return
    end

    table.sort( self.dischargeNodeInfos, function (a, b)
        return a.offsetZ > b.offsetZ
    end )

    for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
        self.waitForFillingTask:addFillUnits(dischargeNodeInfo.vehicle, dischargeNodeInfo.dischargeNode.fillUnitIndex)
    end

    local maxOffset = self.dischargeNodeInfos[# self.dischargeNodeInfos].offsetZ
    self.driveToLoadingTask:setTargetOffset( - maxOffset)
    self.driveToUnloadingTask:setTargetOffset( - maxOffset)

    local x, z = self.positionAngleParameter:getPosition()
    if x ~ = nil then
        self.driveToLoadingTask:setTargetPosition(x, z)
    end
    local xDir, zDir = self.positionAngleParameter:getDirection()
    if xDir ~ = nil then
        self.driveToLoadingTask:setTargetDirection(xDir, zDir)
    end
end

```

### skipCurrentTask

**Description**

**Definition**

> skipCurrentTask()

**Code**

```lua
function AIJobDeliver:skipCurrentTask()
    if self.currentTaskIndex = = self.waitForFillingTask.taskIndex then
        self.waitForFillingTask:skip()
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
function AIJobDeliver:start(farmId)
    -- Client start notification will be done by vehicle
    AIJobDeliver:superClass().start( self , farmId)

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
function AIJobDeliver:startTask(task)
    -- mark all discharge infos as dirty
    if task = = self.waitForFillingTask then
        for _, dischargeNodeInfo in ipairs( self.dischargeNodeInfos) do
            dischargeNodeInfo.dirty = true
        end
    end

    AIJobDeliver:superClass().startTask( self , task)
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
function AIJobDeliver:stop(aiMessage)
    -- Client stop notifcation will be done by vehicle
    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
        vehicle:deleteAgent()
        vehicle:aiJobFinished()
    end

    AIJobDeliver:superClass().stop( self , aiMessage)

    self.dischargeNodeInfos = { }
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
function AIJobDeliver:validate(farmId)
    self:setParameterValid( true )

    local isVehicleValid, vehicleErrorMessage = self.vehicleParameter:validate()
    if isVehicleValid then
        if # self.dischargeNodeInfos = = 0 then
            isVehicleValid = false
            vehicleErrorMessage = g_i18n:getText( "ai_validationErrorNoAIDischargeNodesFound" )
        end
    end
    if not isVehicleValid then
        self.vehicleParameter:setIsValid( false )
    end

    local isUnloadingStationValid, unloadingStationErrorMessage = self.unloadingStationParameter:validate()
    if not isUnloadingStationValid then
        self.unloadingStationParameter:setIsValid( false )
    end

    local isPositionValid, positionErrorMessage = self.positionAngleParameter:validate()
    if not isPositionValid then
        positionErrorMessage = g_i18n:getText( "ai_validationErrorNoLoadingPoint" )
        self.positionAngleParameter:setIsValid( false )
    end

    local isValid = isVehicleValid and isUnloadingStationValid and isPositionValid
    local errorMessage = vehicleErrorMessage or unloadingStationErrorMessage or positionErrorMessage

    return isValid, errorMessage
end

```