## AIJobGoTo

**Parent**

> [AIJob](?version=script&category=54&class=545)

**Functions**

- [applyCurrentState](#applycurrentstate)
- [getDescription](#getdescription)
- [getIsAvailableForVehicle](#getisavailableforvehicle)
- [getIsStartable](#getisstartable)
- [getIsStartErrorText](#getisstarterrortext)
- [getTarget](#gettarget)
- [getTitle](#gettitle)
- [new](#new)
- [setValues](#setvalues)
- [start](#start)
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
function AIJobGoTo:applyCurrentState(vehicle, mission, farmId, isDirectStart)
    AIJobGoTo:superClass().applyCurrentState( self , vehicle, mission, farmId, isDirectStart)

    self.vehicleParameter:setVehicle(vehicle)

    local x, z, angle, _
    if vehicle.getLastJob ~ = nil then
        local lastJob = vehicle:getLastJob()
        if not isDirectStart and lastJob ~ = nil and lastJob:isa( AIJobGoTo ) then
            x, z = lastJob.positionAngleParameter:getPosition()
            angle = lastJob.positionAngleParameter:getAngle()
        end
    end

    self.positionAngleParameter:setSnappingAngle( 0 )

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
function AIJobGoTo:getDescription()
    local desc = AIJobGoTo:superClass().getDescription( self )

    local nextTask = self:getTaskByIndex( self.currentTaskIndex)
    if nextTask = = self.driveToTask then
        desc = desc .. " - " .. g_i18n:getText( "ai_taskDescriptionDriveToTarget" )
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
function AIJobGoTo:getIsAvailableForVehicle(vehicle)
    if vehicle.createAgent = = nil or vehicle.setAITarget = = nil or not vehicle:getCanStartAIVehicle() then
        return false
    end

    if not vehicle:getIsAIJobSupported(ClassUtil.getClassNameByObject( self )) then
        return false
    end

    return true
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
function AIJobGoTo:getIsStartable(connection)
    if g_currentMission.aiSystem:getAILimitedReached() then
        return false , AIJobGoTo.START_ERROR_LIMIT_REACHED
    end

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIJobGoTo.START_ERROR_VEHICLE_DELETED
    end

    if not g_currentMission:getHasPlayerPermission( "hireAssistant" , connection, vehicle:getOwnerFarmId()) then
        return false , AIJobGoTo.START_ERROR_NO_PERMISSION
    end

    if vehicle:getIsInUse(connection) then
        return false , AIJobGoTo.START_ERROR_VEHICLE_IN_USE
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
function AIJobGoTo.getIsStartErrorText(state)
    if state = = AIJobGoTo.START_ERROR_LIMIT_REACHED then
        return g_i18n:getText( "ai_startStateLimitReached" )
    elseif state = = AIJobGoTo.START_ERROR_VEHICLE_DELETED then
            return g_i18n:getText( "ai_startStateVehicleDeleted" )
        elseif state = = AIJobGoTo.START_ERROR_NO_PERMISSION then
                return g_i18n:getText( "ai_startStateNoPermission" )
            elseif state = = AIJobGoTo.START_ERROR_VEHICLE_IN_USE then
                    return g_i18n:getText( "ai_startStateVehicleInUse" )
                end

                return g_i18n:getText( "ai_startStateSuccess" )
            end

```

### getTarget

**Description**

**Definition**

> getTarget()

**Code**

```lua
function AIJobGoTo:getTarget()
    local angle = nil
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
function AIJobGoTo:getTitle()
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
function AIJobGoTo.new(isServer, customMt)
    local self = AIJob.new(isServer, customMt or AIJobGoTo _mt)

    self.driveToTask = AITaskDriveTo.new(isServer, self )
    self:addTask( self.driveToTask)

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

### setValues

**Description**

**Definition**

> setValues()

**Code**

```lua
function AIJobGoTo:setValues()
    self:resetTasks()

    self.driveToTask:setVehicle( self.vehicleParameter:getVehicle())

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
function AIJobGoTo:start(farmId)
    AIJobGoTo:superClass().start( self , farmId)

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle ~ = nil then
        if self.isServer then
            vehicle:createAgent( self.helperIndex)
        end
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
function AIJobGoTo:stop(aiMessage)

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle ~ = nil then
        if self.isServer then
            vehicle:deleteAgent()
        end
        vehicle:aiJobFinished()
    end

    AIJobGoTo:superClass().stop( self , aiMessage)
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
function AIJobGoTo:validate(farmId)
    self:setParameterValid( true )

    local isVehicleValid, errorMessageVehicle = self.vehicleParameter:validate()
    if not isVehicleValid then
        self.vehicleParameter:setIsValid( false )
    end

    local isPositionValid, errorMessagePosition = self.positionAngleParameter:validate()
    if not isPositionValid then
        self.positionAngleParameter:setIsValid( false )
    end

    local isValid = isVehicleValid and isPositionValid
    local errorMessage = errorMessageVehicle or errorMessagePosition

    return isValid, errorMessage
end

```