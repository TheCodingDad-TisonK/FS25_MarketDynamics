## AIJobConveyor

**Parent**

> [AIJob](?version=script&category=54&class=542)

**Functions**

- [applyCurrentState](#applycurrentstate)
- [getIsAvailableForVehicle](#getisavailableforvehicle)
- [getIsStartable](#getisstartable)
- [getIsStartErrorText](#getisstarterrortext)
- [getPricePerMs](#getpriceperms)
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
function AIJobConveyor:applyCurrentState(vehicle, mission, farmId, isDirectStart)
    AIJobConveyor:superClass().applyCurrentState( self , vehicle, mission, farmId, isDirectStart)

    self.vehicleParameter:setVehicle(vehicle)
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
function AIJobConveyor:getIsAvailableForVehicle(vehicle)
    return vehicle.spec_aiConveyorBelt ~ = nil and vehicle:getCanStartAIVehicle() and vehicle:getIsAIJobSupported(ClassUtil.getClassNameByObject( self ))
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
function AIJobConveyor:getIsStartable(connection)
    if g_currentMission.aiSystem:getAILimitedReached() then
        return false , AIJobConveyor.START_ERROR_LIMIT_REACHED
    end

    local vehicle = self.vehicleParameter:getVehicle()
    if vehicle = = nil then
        return false , AIJobConveyor.START_ERROR_VEHICLE_DELETED
    end

    if not g_currentMission:getHasPlayerPermission( "hireAssistant" , connection, vehicle:getOwnerFarmId()) then
        return false , AIJobConveyor.START_ERROR_NO_PERMISSION
    end

    if vehicle:getIsInUse(connection) then
        return false , AIJobConveyor.START_ERROR_VEHICLE_IN_USE
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
function AIJobConveyor.getIsStartErrorText(state)
    if state = = AIJobConveyor.START_ERROR_LIMIT_REACHED then
        return g_i18n:getText( "ai_startStateLimitReached" )
    elseif state = = AIJobConveyor.START_ERROR_VEHICLE_DELETED then
            return g_i18n:getText( "ai_startStateVehicleDeleted" )
        elseif state = = AIJobConveyor.START_ERROR_NO_PERMISSION then
                return g_i18n:getText( "ai_startStateNoPermission" )
            elseif state = = AIJobConveyor.START_ERROR_VEHICLE_IN_USE then
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
function AIJobConveyor:getPricePerMs()
    return 0.00005
end

```

### getTitle

**Description**

**Definition**

> getTitle()

**Code**

```lua
function AIJobConveyor:getTitle()
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
function AIJobConveyor.new(isServer, customMt)
    local self = AIJob.new(isServer, customMt or AIJobConveyor _mt)

    self.conveyorTask = AITaskConveyor.new(isServer, self )

    self:addTask( self.conveyorTask)

    self.vehicleParameter = AIParameterVehicle.new()

    self:addNamedParameter( "vehicle" , self.vehicleParameter)

    local vehicleGroup = AIParameterGroup.new(g_i18n:getText( "ai_parameterGroupTitleVehicle" ))
    vehicleGroup:addParameter( self.vehicleParameter)

    table.insert( self.groupedParameters, vehicleGroup)

    return self
end

```

### setValues

**Description**

**Definition**

> setValues()

**Code**

```lua
function AIJobConveyor:setValues()
    self:resetTasks()

    self.conveyorTask:setVehicle( self.vehicleParameter:getVehicle())
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
function AIJobConveyor:start(farmId)
    AIJobConveyor:superClass().start( self , farmId)

    -- Client start notification will be done by vehicle
    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
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
function AIJobConveyor:stop(aiMessage)
    -- Client stop notifcation will be done by vehicle
    if self.isServer then
        local vehicle = self.vehicleParameter:getVehicle()
        vehicle:aiJobFinished()
    end

    AIJobConveyor:superClass().stop( self , aiMessage)
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
function AIJobConveyor:validate(farmId)
    self:setParameterValid( true )

    local isValid, errorMessage = self.vehicleParameter:validate( false )
    if not isValid then
        self.vehicleParameter:setIsValid( false )
    end

    return isValid, errorMessage
end

```