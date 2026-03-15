## AIConveyorBelt

**Description**

> Specialization for extending conveyor belts with AI functionality

**Functions**

- [actionEventChangeAngle](#actioneventchangeangle)
- [getAINeedsTrafficCollisionBox](#getaineedstrafficcollisionbox)
- [getCanBeSelected](#getcanbeselected)
- [getCanStartAIVehicle](#getcanstartaivehicle)
- [getCanStartFieldWork](#getcanstartfieldwork)
- [getDirectionAndSpeedToTargetAngle](#getdirectionandspeedtotargetangle)
- [getHasStartableAIJob](#gethasstartableaijob)
- [getStartableAIJob](#getstartableaijob)
- [initSpecialization](#initspecialization)
- [onAIFieldWorkerStart](#onaifieldworkerstart)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setAIConveyorBeltAngle](#setaiconveyorbeltangle)

### actionEventChangeAngle

**Description**

**Definition**

> actionEventChangeAngle()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function AIConveyorBelt.actionEventChangeAngle( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_aiConveyorBelt
    local newAngle = spec.currentAngle + spec.stepSize
    if newAngle > spec.maxAngle then
        newAngle = spec.minAngle
    end

    self:setAIConveyorBeltAngle(newAngle)
end

```

### getAINeedsTrafficCollisionBox

**Description**

**Definition**

> getAINeedsTrafficCollisionBox()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIConveyorBelt:getAINeedsTrafficCollisionBox(superFunc)
    return false
end

```

### getCanBeSelected

**Description**

**Definition**

> getCanBeSelected()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIConveyorBelt:getCanBeSelected(superFunc)
    return true
end

```

### getCanStartAIVehicle

**Description**

**Definition**

> getCanStartAIVehicle()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIConveyorBelt:getCanStartAIVehicle(superFunc)
    if not superFunc( self ) then
        return false
    end

    return self.spec_aiConveyorBelt.isAllowed
end

```

### getCanStartFieldWork

**Description**

**Definition**

> getCanStartFieldWork()

**Code**

```lua
function AIConveyorBelt:getCanStartFieldWork()
    return self:getCanStartAIVehicle()
end

```

### getDirectionAndSpeedToTargetAngle

**Description**

**Definition**

> getDirectionAndSpeedToTargetAngle()

**Arguments**

| any | direction |
|-----|-----------|
| any | minAngle  |
| any | maxAngle  |

**Code**

```lua
function AIConveyorBelt:getDirectionAndSpeedToTargetAngle(direction, minAngle, maxAngle)
    local dx, _, dz = localDirectionToWorld( self.components[ 1 ].node, 0 , 0 , 1 )
    local yRot = MathUtil.getYRotationFromDirection(dx, dz)

    local angleDifference
    if direction > 0 then
        if yRot > maxAngle then
            return - 1 , 0
        end
        angleDifference = maxAngle - yRot
    elseif direction < 0 then
            if yRot < minAngle then
                return 1 , 0
            end
            angleDifference = yRot - minAngle
        else
                angleDifference = 0
            end

            local speed = math.clamp( math.deg(angleDifference) / 2.5 , 0.1 , 1 ) * direction

            return direction, speed
        end

```

### getHasStartableAIJob

**Description**

**Definition**

> getHasStartableAIJob()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIConveyorBelt:getHasStartableAIJob(superFunc)
    return true
end

```

### getStartableAIJob

**Description**

**Definition**

> getStartableAIJob()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function AIConveyorBelt:getStartableAIJob(superFunc)

    if self:getCanStartFieldWork() then
        local spec = self.spec_aiConveyorBelt
        local conveyorJob = spec.conveyorJob
        conveyorJob:applyCurrentState( self , g_currentMission, g_localPlayer.farmId, false )
        conveyorJob:setValues()
        local success = conveyorJob:validate( false )
        if success then
            return conveyorJob
        end
    end

    return nil
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function AIConveyorBelt.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "AIConveyorBelt" )

    schema:register(XMLValueType.FLOAT, "vehicle.ai.conveyorBelt#minAngle" , "Min angle" , 5 )
    schema:register(XMLValueType.FLOAT, "vehicle.ai.conveyorBelt#maxAngle" , "Max angle" , 45 )
    schema:register(XMLValueType.FLOAT, "vehicle.ai.conveyorBelt#stepSize" , "Step size" , 5 )
    schema:register(XMLValueType.FLOAT, "vehicle.ai.conveyorBelt#speed" , "Speed" , 1 )
    schema:register(XMLValueType.INT, "vehicle.ai.conveyorBelt#direction" , "Direction" , - 1 )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).aiConveyorBelt#currentAngle" , "Current angle" , 45 )
end

```

### onAIFieldWorkerStart

**Description**

**Definition**

> onAIFieldWorkerStart()

**Code**

```lua
function AIConveyorBelt:onAIFieldWorkerStart()
    local spec = self.spec_aiConveyorBelt

    local dx, _, dz = localDirectionToWorld( self.components[ 1 ].node, 0 , 0 , 1 )
    local yRot = MathUtil.getYRotationFromDirection(dx, dz)

    spec.minTargetWorldYRot = yRot - math.rad(spec.currentAngle) / 2
    spec.maxTargetWorldYRot = yRot + math.rad(spec.currentAngle) / 2
    spec.currentDirection = 1
end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function AIConveyorBelt:onLoad(savegame)
    local spec = self.spec_aiConveyorBelt

    spec.isAllowed = self.xmlFile:hasProperty( "vehicle.ai.conveyorBelt" )

    spec.minAngle = self.xmlFile:getValue( "vehicle.ai.conveyorBelt#minAngle" , 5 )
    spec.maxAngle = self.xmlFile:getValue( "vehicle.ai.conveyorBelt#maxAngle" , 45 )
    spec.stepSize = self.xmlFile:getValue( "vehicle.ai.conveyorBelt#stepSize" , 5 )
    spec.currentAngle = spec.maxAngle

    spec.minTargetWorldYRot = 0
    spec.maxTargetWorldYRot = 0
    spec.currentDirection = 0
    spec.currentSpeed = 0

    spec.conveyorJob = g_currentMission.aiJobTypeManager:createJob(AIJobType.CONVEYOR)

    spec.speed = self.xmlFile:getValue( "vehicle.ai.conveyorBelt#speed" , 1 )
    spec.direction = self.xmlFile:getValue( "vehicle.ai.conveyorBelt#direction" , - 1 )

    if not self.isServer then
        SpecializationUtil.removeEventListener( self , "onUpdate" , AIConveyorBelt )
    end
    if not self.isClient then
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , AIConveyorBelt )
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function AIConveyorBelt:onPostLoad(savegame)
    local spec = self.spec_aiConveyorBelt
    if savegame ~ = nil and not savegame.resetVehicles then
        spec.currentAngle = savegame.xmlFile:getValue(savegame.key .. ".aiConveyorBelt#currentAngle" , spec.currentAngle)
    end
end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function AIConveyorBelt:onReadStream(streamId, connection)
    self:setAIConveyorBeltAngle(streamReadInt8(streamId), true )
end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |

**Code**

```lua
function AIConveyorBelt:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_aiConveyorBelt
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection and spec.isAllowed then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA3, self , AIConveyorBelt.actionEventChangeAngle, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
        end
    end
end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function AIConveyorBelt:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self:getIsAIActive() then
        local spec = self.spec_aiConveyorBelt
        spec.currentDirection, spec.currentSpeed = self:getDirectionAndSpeedToTargetAngle(spec.currentDirection, spec.minTargetWorldYRot, spec.maxTargetWorldYRot)

        self:getMotor():setSpeedLimit( math.abs(spec.currentSpeed * spec.speed))
        WheelsUtil.updateWheelsPhysics( self , dt, spec.currentSpeed * spec.speed * spec.direction, spec.currentDirection * spec.direction, false , true )
    end
end

```

### onUpdateTick

**Description**

> Called on updateTick

**Definition**

> onUpdateTick(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function AIConveyorBelt:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_aiConveyorBelt
    local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
    if actionEvent ~ = nil then
        g_inputBinding:setActionEventActive(actionEvent.actionEventId, isActiveForInputIgnoreSelection)
        if isActiveForInputIgnoreSelection then
            g_inputBinding:setActionEventText(actionEvent.actionEventId, string.format(g_i18n:getText( "action_conveyorBeltChangeAngle" ), string.format( "%.0f" , spec.currentAngle)))
        end
    end
end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function AIConveyorBelt:onWriteStream(streamId, connection)
    streamWriteInt8(streamId, self.spec_aiConveyorBelt.currentAngle)
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
function AIConveyorBelt.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AIFieldWorker , specializations) and SpecializationUtil.hasSpecialization( Motorized , specializations)
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIConveyorBelt.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldWorkerStart" , AIConveyorBelt )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , AIConveyorBelt )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIConveyorBelt.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "setAIConveyorBeltAngle" , AIConveyorBelt.setAIConveyorBeltAngle)
    SpecializationUtil.registerFunction(vehicleType, "getDirectionAndSpeedToTargetAngle" , AIConveyorBelt.getDirectionAndSpeedToTargetAngle)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function AIConveyorBelt.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getStartableAIJob" , AIConveyorBelt.getStartableAIJob)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getHasStartableAIJob" , AIConveyorBelt.getHasStartableAIJob)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanStartFieldWork" , AIConveyorBelt.getCanStartFieldWork)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanStartAIVehicle" , AIConveyorBelt.getCanStartAIVehicle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , AIConveyorBelt.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAINeedsTrafficCollisionBox" , AIConveyorBelt.getAINeedsTrafficCollisionBox)
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function AIConveyorBelt:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_aiConveyorBelt
    xmlFile:setValue(key .. "#currentAngle" , spec.currentAngle)
end

```

### setAIConveyorBeltAngle

**Description**

**Definition**

> setAIConveyorBeltAngle()

**Arguments**

| any | angle       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function AIConveyorBelt:setAIConveyorBeltAngle(angle, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( AIConveyorBeltSetAngleEvent.new( self , angle), nil , nil , self )
        else
                g_client:getServerConnection():sendEvent( AIConveyorBeltSetAngleEvent.new( self , angle))
            end
        end

        self.spec_aiConveyorBelt.currentAngle = angle
    end

```