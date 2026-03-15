## AIJobFieldWork

**Parent**

> [AIJob](?version=script&category=54&class=544)

**Functions**

- [applyCurrentState](#applycurrentstate)
- [getDescription](#getdescription)
- [getIsAvailableForVehicle](#getisavailableforvehicle)
- [getIsStartable](#getisstartable)
- [getIsStartErrorText](#getisstarterrortext)
- [getPricePerMs](#getpriceperms)
- [getStartTaskIndex](#getstarttaskindex)
- [getTarget](#gettarget)
- [getTitle](#gettitle)
- [new](#new)
- [readStream](#readstream)
- [setValues](#setvalues)
- [start](#start)
- [stop](#stop)
- [validate](#validate)
- [writeStream](#writestream)

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
function AIJobFieldWork:applyCurrentState(vehicle, mission, farmId, isDirectStart)
    AIJobFieldWork:superClass().applyCurrentState( self , vehicle, mission, farmId, isDirectStart)

    self.vehicleParameter:setVehicle(vehicle)

    local x, z, angle, _
    if vehicle.getLastJob ~ = nil then
        local lastJob = vehicle:getLastJob()
        if not isDirectStart and lastJob ~ = nil and lastJob:isa( AIJobFieldWork ) then
            x, z = lastJob.positionAngleParameter:getPosition()
            angle = lastJob.positionAngleParameter:getAngle()
        end
    end

    local snappingAngle = vehicle:getDirectionSnapAngle()
    local terrainAngle = math.pi / math.max(g_currentMission.fieldGroundSystem:getGroundAngleMaxValue() + 1 , 4 ) -- snap at least in 45deg angles
    snappingAngle = math.max(snappingAngle, terrainAngle)
    self.positionAngleParameter:setSnappingAngle(snappingAngle)

    if x = = nil or z = = nil then
        x, _, z = getWorldTranslation(vehicle.rootNode)
    end
    if angle = = nil then
        local dirX, _, dirZ = localDirectionToWorld(vehicle.rootNode, 0 , 0 , 1 )
        angle = MathUtil.getYRotationFromDirection(dirX, dirZ)
    end

    self.positionAngleParameter:setPosition(x, z)
    self.positionAngleParameter:setAngle(angle)
end

```

### getDescription

**Description**

**Definition**

> getDescription()

**Code**

```lua
function AIJobFieldWork:getDescription()
    local desc = AIJobFieldWork:superClass().getDescription( self )

    local nextTask = self:getTaskByIndex( self.currentTaskIndex)
    if nextTask = = self.driveToTask then
        desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionDriveToField" )
    elseif nextTask = = self.fieldWorkTask then
            desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionFieldWork" )
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
function AIJobFieldWork:getIsAvailableForVehicle(vehicle)
    return vehicle.getCanStartFieldWork and vehicle:getCanStartFieldWork() and vehicle:getIsAIJobSupported(ClassUtil.getClassNameByObject( self ))
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
function AIJobFieldWork:getIsStartable(connection)
    if g_currentMission.aiSystem:getAILimitedReached() then
        return false , AIJobFieldWork.START_ERROR_LIMIT_REACHED
    end

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIJobFieldWork.START_ERROR_VEHICLE_DELETED
    end

    if not g_currentMission:getHasPlayerPermission( "hireAssistant" , connection, vehicle:getOwnerFarmId()) then
        return false , AIJobFieldWork.START_ERROR_NO_PERMISSION
    end

    if vehicle:getIsInUse(connection) then
        return false , AIJobFieldWork.START_ERROR_VEHICLE_IN_USE
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
function AIJobFieldWork.getIsStartErrorText(state)
    if state = = AIJobFieldWork.START_ERROR_LIMIT_REACHED then
        return g_i18n:getText( "ai_startStateLimitReached" )
    elseif state = = AIJobFieldWork.START_ERROR_VEHICLE_DELETED then
            return g_i18n:getText( "ai_startStateVehicleDeleted" )
        elseif state = = AIJobFieldWork.START_ERROR_NO_PERMISSION then
                return g_i18n:getText( "ai_startStateNoPermission" )
            elseif state = = AIJobFieldWork.START_ERROR_VEHICLE_IN_USE then
                    return g_i18n:getText( "ai_startStateVehicleInUse" )
                end

                return g_i18n:getText( "ai_startStateSuccess" )
            end

```

### getPricePerMs

**Description**

**Definition**

> getPricePerMs()

**Code**

```lua
function AIJobFieldWork:getPricePerMs()
    return 0.0005
end

```

### getStartTaskIndex

**Description**

**Definition**

> getStartTaskIndex()

**Code**

```lua
function AIJobFieldWork:getStartTaskIndex()
    if self.isDirectStart then
        return 2
    end

    -- check if already at target position
        local vehicle = self.vehicleParameter:getVehicle()
        local x, _, z = getWorldTranslation(vehicle.rootNode)
        local tx, tz = self.positionAngleParameter:getPosition()
        local targetReached = MathUtil.vector2Length(x - tx, z - tz) < 3
        if targetReached then
            return 2
        end

        return 1
    end

```

### getTarget

**Description**

**Definition**

> getTarget()

**Code**

```lua
function AIJobFieldWork:getTarget()
    local angle = 0
    if self.driveToTask.dirX ~ = nil then
        angle = MathUtil.getYRotationFromDirection( self.driveToTask.dirX, self.driveToTask.dirZ)
    end

    return self.driveToTask.x, self.driveToTask.z, angle
end

```

### getTitle

**Description**

**Definition**

> getTitle()

**Code**

```lua
function AIJobFieldWork:getTitle()
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
function AIJobFieldWork.new(isServer, customMt)
    local self = AIJob.new(isServer, customMt or AIJobFieldWork _mt)

    self.driveToTask = AITaskDriveTo.new(isServer, self )
    self.fieldWorkTask = AITaskFieldWork.new(isServer, self )

    self:addTask( self.driveToTask)
    self:addTask( self.fieldWorkTask)

    self.isDirectStart = false

    self.vehicleParameter = AIParameterVehicle.new()
    self.positionAngleParameter = AIParameterPositionAngle.new( math.rad( 0 ))

    self:addNamedParameter( "vehicle" , self.vehicleParameter)
    self:addNamedParameter( "positionAngle" , self.positionAngleParameter)

    local vehicleGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleVehicle" ))
    vehicleGroup:addParameter( self.vehicleParameter)

    local positionGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitlePosition" ))
    positionGroup:addParameter( self.positionAngleParameter)

    table.insert( self.groupedParameters, vehicleGroup)
    table.insert( self.groupedParameters, positionGroup)

    return self
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
function AIJobFieldWork:readStream(streamId, connection)
    AIJobFieldWork:superClass().readStream( self , streamId, connection)

    if streamReadBool(streamId) then
        self.pendingData = AIModeSelection.readAIModeSettingsFromStream(streamId, connection)
        self.pendingVehicle = true
    end
end

```

### setValues

**Description**

**Definition**

> setValues()

**Code**

```lua
function AIJobFieldWork:setValues()
    self:resetTasks()

    local vehicle = self.vehicleParameter:getVehicle()
    self.driveToTask:setVehicle(vehicle)
    self.fieldWorkTask:setVehicle(vehicle)

    local angle = self.positionAngleParameter:getAngle()
    local x, z = self.positionAngleParameter:getPosition()
    local dirX, dirZ = MathUtil.getDirectionFromYRotation(angle)
    self.driveToTask:setTargetDirection(dirX, dirZ)
    self.driveToTask:setTargetPosition(x, z)
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
function AIJobFieldWork:start(farmId)
    AIJobFieldWork:superClass().start( self , farmId)

    -- Client start notification will be done by vehicle
    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
        vehicle:createAgent( self.helperIndex)
        vehicle:aiJobStarted( self , self.helperIndex, farmId)
    end
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
function AIJobFieldWork:stop(aiMessage)
    -- Client stop notifcation will be done by vehicle
    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
        vehicle:deleteAgent()
        vehicle:aiJobFinished()
    end
    AIJobFieldWork:superClass().stop( self , aiMessage)
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
function AIJobFieldWork:validate(farmId)
    self:setParameterValid( true )

    local isValid, errorMessage = self.vehicleParameter:validate()
    if not isValid then
        self.vehicleParameter:setIsValid( false )
    end

    return isValid, errorMessage
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
function AIJobFieldWork:writeStream(streamId, connection)
    AIJobFieldWork:superClass().writeStream( self , streamId, connection)

    local vehicle = self.vehicleParameter:getVehicle()
    if streamWriteBool(streamId, vehicle ~ = nil ) then
        vehicle:writeAIModeSettingsToStream(streamId, connection)
    end
end

```