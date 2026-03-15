## Drivable

**Description**

> Specialization for cruise control, steering wheel; required Enterable and Motorized specialization

**Functions**

- [actionEventAccelerate](#actioneventaccelerate)
- [actionEventBrake](#actioneventbrake)
- [actionEventCruiseControlState](#actioneventcruisecontrolstate)
- [actionEventCruiseControlValue](#actioneventcruisecontrolvalue)
- [actionEventSteer](#actioneventsteer)
- [brakeToStop](#braketostop)
- [getAccelerationAxis](#getaccelerationaxis)
- [getAcDecelerationAxis](#getacdecelerationaxis)
- [getAxisForward](#getaxisforward)
- [getCruiseControlAxis](#getcruisecontrolaxis)
- [getCruiseControlDisplayInfo](#getcruisecontroldisplayinfo)
- [getCruiseControlMaxSpeed](#getcruisecontrolmaxspeed)
- [getCruiseControlSpeed](#getcruisecontrolspeed)
- [getCruiseControlState](#getcruisecontrolstate)
- [getDashboardCombinedPedalLeft](#getdashboardcombinedpedalleft)
- [getDashboardCombinedPedalRight](#getdashboardcombinedpedalright)
- [getDashboardSteeringAxis](#getdashboardsteeringaxis)
- [getDecelerationAxis](#getdecelerationaxis)
- [getDrivingDirection](#getdrivingdirection)
- [getIsDrivingBackward](#getisdrivingbackward)
- [getIsDrivingForward](#getisdrivingforward)
- [getIsManualDirectionChangeAllowed](#getismanualdirectionchangeallowed)
- [getIsPlayerVehicleControlAllowed](#getisplayervehiclecontrolallowed)
- [getIsVehicleControlledByPlayer](#getisvehiclecontrolledbyplayer)
- [getMapHotspotRotation](#getmaphotspotrotation)
- [getReverserDirection](#getreverserdirection)
- [getSteeringDirection](#getsteeringdirection)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterDashboardValueTypes](#onregisterdashboardvaluetypes)
- [onSetBroken](#onsetbroken)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerPlayerVehicleControlAllowedFunction](#registerplayervehiclecontrolallowedfunction)
- [saveToXMLFile](#savetoxmlfile)
- [setAccelerationPedalInput](#setaccelerationpedalinput)
- [setBrakePedalInput](#setbrakepedalinput)
- [setCruiseControlMaxSpeed](#setcruisecontrolmaxspeed)
- [setCruiseControlState](#setcruisecontrolstate)
- [setReverserDirection](#setreverserdirection)
- [setSteeringInput](#setsteeringinput)
- [setTargetSpeedAndDirection](#settargetspeedanddirection)
- [setTransmissionDirection](#settransmissiondirection)
- [stopMotor](#stopmotor)
- [updateSteeringAngle](#updatesteeringangle)
- [updateSteeringWheel](#updatesteeringwheel)
- [updateVehiclePhysics](#updatevehiclephysics)

### actionEventAccelerate

**Description**

**Definition**

> actionEventAccelerate()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Drivable.actionEventAccelerate( self , actionName, inputValue, callbackState, isAnalog)
    if inputValue ~ = 0 then
        -- we show the warning, but still allow brake input while the engine is off
            -- Drivable:updateVehiclePhysics will correctly block the right input if engine is turned off
                local isPowered, isPoweredWarning = self:getIsPowered()
                if not isPowered and isPoweredWarning ~ = nil then
                    g_currentMission:showBlinkingWarning(isPoweredWarning, 2000 )
                end

                local isAllowed, warning = self:getIsPlayerVehicleControlAllowed()
                if isAllowed then
                    self:setAccelerationPedalInput(inputValue)
                elseif warning ~ = nil then
                        g_currentMission:showBlinkingWarning(warning, 2000 )
                    end
                end
            end

```

### actionEventBrake

**Description**

**Definition**

> actionEventBrake()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Drivable.actionEventBrake( self , actionName, inputValue, callbackState, isAnalog)
    if inputValue ~ = 0 then
        -- we show the warning, but still allow brake input while the engine is off
            -- Drivable:updateVehiclePhysics will correctly block the right input if engine is turned off
                local isPowered, isPoweredWarning = self:getIsPowered()
                if not isPowered and isPoweredWarning ~ = nil then
                    g_currentMission:showBlinkingWarning(isPoweredWarning, 2000 )
                end

                local isAllowed, warning = self:getIsPlayerVehicleControlAllowed()
                if isAllowed then
                    self:setBrakePedalInput(inputValue)
                elseif warning ~ = nil then
                        g_currentMission:showBlinkingWarning(warning, 2000 )
                    end
                end
            end

```

### actionEventCruiseControlState

**Description**

**Definition**

> actionEventCruiseControlState()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Drivable.actionEventCruiseControlState( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_drivable
    local isAllowed, warning = self:getIsPlayerVehicleControlAllowed()
    if isAllowed then
        spec.lastInputValues.cruiseControlState = 1
    elseif warning ~ = nil then
            g_currentMission:showBlinkingWarning(warning, 2000 )
        end
    end

```

### actionEventCruiseControlValue

**Description**

**Definition**

> actionEventCruiseControlValue()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Drivable.actionEventCruiseControlValue( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_drivable
    spec.lastInputValues.cruiseControlValue = inputValue
end

```

### actionEventSteer

**Description**

**Definition**

> actionEventSteer()

**Arguments**

| any | self           |
|-----|----------------|
| any | actionName     |
| any | inputValue     |
| any | callbackState  |
| any | isAnalog       |
| any | isMouse        |
| any | deviceCategory |
| any | binding        |

**Code**

```lua
function Drivable.actionEventSteer( self , actionName, inputValue, callbackState, isAnalog, isMouse, deviceCategory, binding)
    local spec = self.spec_drivable
    if not spec.forceFeedback.isActive then
        local isSupported, device, axisIndex = g_inputBinding:getBindingForceFeedbackInfo(binding)
        spec.forceFeedback.isActive = isSupported
        spec.forceFeedback.device = device
        spec.forceFeedback.binding = binding
        spec.forceFeedback.axisIndex = axisIndex

        if isSupported then
            device:setForceFeedback(axisIndex, 0 , inputValue)
        end
    else
            if binding ~ = spec.forceFeedback.binding then
                local isSupported, _, _ = g_inputBinding:getBindingForceFeedbackInfo(binding)
                if not isSupported then
                    spec.forceFeedback.isActive = false
                    spec.forceFeedback.device = nil
                    spec.forceFeedback.binding = nil
                    spec.forceFeedback.axisIndex = 0
                end
            end
        end

        if inputValue ~ = 0 then
            local isAllowed, warning = self:getIsPlayerVehicleControlAllowed()
            if isAllowed then
                self:setSteeringInput(inputValue, isAnalog, deviceCategory)
            elseif warning ~ = nil then
                    g_currentMission:showBlinkingWarning(warning, 2000 )
                end
            end
        end

```

### brakeToStop

**Description**

**Definition**

> brakeToStop()

**Code**

```lua
function Drivable:brakeToStop()
    local spec = self.spec_drivable
    spec.brakeToStop = true
end

```

### getAccelerationAxis

**Description**

**Definition**

> getAccelerationAxis()

**Code**

```lua
function Drivable:getAccelerationAxis()
    local dir = self.movingDirection > - 1 and 1 or - 1
    return math.max( self.spec_drivable.axisForward * dir * self:getReverserDirection(), 0 )
end

```

### getAcDecelerationAxis

**Description**

**Definition**

> getAcDecelerationAxis()

**Code**

```lua
function Drivable:getAcDecelerationAxis()
    return self.spec_drivable.axisForward * self:getReverserDirection()
end

```

### getAxisForward

**Description**

**Definition**

> getAxisForward()

**Code**

```lua
function Drivable:getAxisForward()
    return self.spec_drivable.axisForward
end

```

### getCruiseControlAxis

**Description**

**Definition**

> getCruiseControlAxis()

**Code**

```lua
function Drivable:getCruiseControlAxis()
    return self.spec_drivable.cruiseControl.state ~ = Drivable.CRUISECONTROL_STATE_OFF and 1 or 0
end

```

### getCruiseControlDisplayInfo

**Description**

> Returns info to display in speed meter HUD

**Definition**

> getCruiseControlDisplayInfo()

**Return Values**

| any | cruiseControlSpeed | current cruise control speed |
|-----|--------------------|------------------------------|
| any | isActive           | is cruise control active     |

**Code**

```lua
function Drivable:getCruiseControlDisplayInfo()
    local cruiseControlSpeed
    local isActive = true

    local cruiseControl = self.spec_drivable.cruiseControl
    if self:getReverserDirection() < 0 then
        cruiseControlSpeed = cruiseControl.speedReverse
    else
            cruiseControlSpeed = cruiseControl.speed
        end

        if cruiseControl.state = = Drivable.CRUISECONTROL_STATE_FULL then
            cruiseControlSpeed = cruiseControl.maxSpeed
        elseif cruiseControl.state = = Drivable.CRUISECONTROL_STATE_OFF then
                isActive = false
            end

            if self:getDrivingDirection() < 0 then
                if self:getReverserDirection() < 0 then
                    cruiseControlSpeed = cruiseControl.speed
                else
                        cruiseControlSpeed = cruiseControl.speedReverse
                    end
                end

                return cruiseControlSpeed, isActive
            end

```

### getCruiseControlMaxSpeed

**Description**

**Definition**

> getCruiseControlMaxSpeed()

**Code**

```lua
function Drivable:getCruiseControlMaxSpeed()
    return self.spec_drivable.cruiseControl.maxSpeed
end

```

### getCruiseControlSpeed

**Description**

**Definition**

> getCruiseControlSpeed()

**Code**

```lua
function Drivable:getCruiseControlSpeed()
    local spec = self.spec_drivable
    if spec.cruiseControl.state = = Drivable.CRUISECONTROL_STATE_FULL then
        return spec.cruiseControl.maxSpeed
    end

    return spec.cruiseControl.speed
end

```

### getCruiseControlState

**Description**

**Definition**

> getCruiseControlState()

**Code**

```lua
function Drivable:getCruiseControlState()
    return self.spec_drivable.cruiseControl.state
end

```

### getDashboardCombinedPedalLeft

**Description**

**Definition**

> getDashboardCombinedPedalLeft()

**Code**

```lua
function Drivable:getDashboardCombinedPedalLeft()
    local value = self:getAcDecelerationAxis()

    local spec = self.spec_drivable
    if spec.idleTurningAllowed and spec.idleTurningActive then
        return value * spec.idleTurningDirection
    end

    value = math.clamp(value - self:getDashboardSteeringAxis(), - 1 , 1 )

    return value
end

```

### getDashboardCombinedPedalRight

**Description**

**Definition**

> getDashboardCombinedPedalRight()

**Code**

```lua
function Drivable:getDashboardCombinedPedalRight()
    local value = self:getAcDecelerationAxis()

    local spec = self.spec_drivable
    if spec.idleTurningAllowed and spec.idleTurningActive then
        return - value * spec.idleTurningDirection
    end

    value = math.clamp(value + self:getDashboardSteeringAxis(), - 1 , 1 )

    return value
end

```

### getDashboardSteeringAxis

**Description**

**Definition**

> getDashboardSteeringAxis()

**Code**

```lua
function Drivable:getDashboardSteeringAxis()
    local spec = self.spec_drivable
    if spec.idleTurningAllowed then
        if spec.idleTurningActive then
            if not spec.idleTurningUpdateSteeringWheel then
                return 0
            else
                    return self.rotatedTime / self.maxRotTime * self:getReverserDirection() * spec.idleTurningDirection * spec.axisForward
                end
            end
        end

        return self.rotatedTime / self.maxRotTime * self:getReverserDirection()
    end

```

### getDecelerationAxis

**Description**

**Definition**

> getDecelerationAxis()

**Code**

```lua
function Drivable:getDecelerationAxis()
    -- if moving backward and accelrating forward the threshold for the brake pedal is at 7.2km/h to avoid quick brake and gas pedal switches
        if self.lastSpeedReal > 0.0001 and( self.movingDirection = = math.sign( self.spec_drivable.axisForward) or self.lastSpeedReal > 0.002 ) then
            return math.abs( math.min( self.spec_drivable.axisForward * self.movingDirection * self:getReverserDirection(), 0 ))
        end

        return 0
    end

```

### getDrivingDirection

**Description**

**Definition**

> getDrivingDirection()

**Code**

```lua
function Drivable:getDrivingDirection()
    local lastSpeed = self:getLastSpeed()
    if lastSpeed < 0.2 then
        return 0
    end

    if lastSpeed < 1.5 then
        -- if we are not pressing any button the speed change could be caused by outer influences
            if self.spec_drivable.axisForward = = 0 then
                return 0
            end
        end

        return self.movingDirection * self:getReverserDirection()
    end

```

### getIsDrivingBackward

**Description**

**Definition**

> getIsDrivingBackward()

**Code**

```lua
function Drivable:getIsDrivingBackward()
    return self:getDrivingDirection() < 0
end

```

### getIsDrivingForward

**Description**

**Definition**

> getIsDrivingForward()

**Code**

```lua
function Drivable:getIsDrivingForward()
    return self:getDrivingDirection() > = 0
end

```

### getIsManualDirectionChangeAllowed

**Description**

**Definition**

> getIsManualDirectionChangeAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Drivable:getIsManualDirectionChangeAllowed(superFunc)
    local spec = self.spec_drivable
    if spec.idleTurningAllowed and spec.idleTurningActive then
        return false
    end

    return superFunc( self )
end

```

### getIsPlayerVehicleControlAllowed

**Description**

> Returns if the vehicle can be controlled by the player + a warning to display if not

**Definition**

> getIsPlayerVehicleControlAllowed()

**Return Values**

| any | isAllowed | control is allowed      |
|-----|-----------|-------------------------|
| any | warning   | warning text to display |

**Code**

```lua
function Drivable:getIsPlayerVehicleControlAllowed()
    local spec = self.spec_drivable
    if spec.hasPlayerControlAllowedFunctions then
        for objectId, func in pairs(spec.playerControlAllowedFunctions) do
            local vehicle = NetworkUtil.getObject(objectId)
            if vehicle ~ = nil and vehicle.rootVehicle = = self then
                local isAllowed, warning = func(vehicle)
                if not isAllowed then
                    return isAllowed, warning
                end
            else
                    spec.playerControlAllowedFunctions[objectId] = nil
                    spec.hasPlayerControlAllowedFunctions = table.size(spec.playerControlAllowedFunctions) > 0
                end
            end
        end

        return true , nil
    end

```

### getIsVehicleControlledByPlayer

**Description**

**Definition**

> getIsVehicleControlledByPlayer()

**Code**

```lua
function Drivable:getIsVehicleControlledByPlayer()
    return true
end

```

### getMapHotspotRotation

**Description**

**Definition**

> getMapHotspotRotation()

**Arguments**

| any | superFunc       |
|-----|-----------------|
| any | isPlayerHotspot |

**Code**

```lua
function Drivable:getMapHotspotRotation(superFunc, isPlayerHotspot)
    if self:getReverserDirection() < 0 then
        return superFunc( self , isPlayerHotspot) + math.pi
    end

    return superFunc( self , isPlayerHotspot)
end

```

### getReverserDirection

**Description**

**Definition**

> getReverserDirection()

**Code**

```lua
function Drivable:getReverserDirection()
    return self.spec_drivable.reverserDirection
end

```

### getSteeringDirection

**Description**

**Definition**

> getSteeringDirection()

**Code**

```lua
function Drivable:getSteeringDirection()
    return self.spec_drivable.steeringDirection
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Drivable.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Drivable" )

    schema:register(XMLValueType.INT, "vehicle.drivable#reverserDirection" , "Default state of reverser direction(when set to -1 the driving direction is inverted)" , 1 )
    schema:register(XMLValueType.INT, "vehicle.drivable#steeringDirection" , "Default state of steering direction(when set to -1 the steering direction is inverted)" , 1 )

    schema:register(XMLValueType.FLOAT, "vehicle.drivable.speedRotScale#scale" , "Speed dependent steering speed scale" , 80 )
    schema:register(XMLValueType.FLOAT, "vehicle.drivable.speedRotScale#offset" , "Speed dependent steering speed offset" , 0.7 )

    schema:register(XMLValueType.FLOAT, "vehicle.drivable.cruiseControl#maxSpeed" , "Max.cruise control speed" , "Max.vehicle speed" )
    schema:register(XMLValueType.FLOAT, "vehicle.drivable.cruiseControl#minSpeed" , "Min.cruise control speed" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.drivable.cruiseControl#maxSpeedReverse" , "Max.cruise control speed in reverse" , "Max.value reverse speed" )
    schema:register(XMLValueType.BOOL, "vehicle.drivable.cruiseControl#enabled" , "Cruise control enabled" , true )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.drivable.steeringWheel#node" , "Steering wheel node" )
    schema:register(XMLValueType.ANGLE, "vehicle.drivable.steeringWheel#indoorRotation" , "Steering wheel indoor rotation" , 0 )
    schema:register(XMLValueType.ANGLE, "vehicle.drivable.steeringWheel#outdoorRotation" , "Steering wheel outdoor rotation" , 0 )

    schema:register(XMLValueType.BOOL, "vehicle.drivable.idleTurning#allowed" , "When vehicle is not moving and steering keys are pressed turns on the same spot" , false )
    schema:register(XMLValueType.BOOL, "vehicle.drivable.idleTurning#updateSteeringWheel" , "Update steering wheel" , true )
    schema:register(XMLValueType.BOOL, "vehicle.drivable.idleTurning#lockDirection" , "Defines if the direction is locked until player accelerates again" , true )
        schema:register(XMLValueType.INT, "vehicle.drivable.idleTurning#direction" , "Driving direction [-1, 1]" , 1 )
        schema:register(XMLValueType.FLOAT, "vehicle.drivable.idleTurning#maxSpeed" , "Max.speed while turning" , 10 )
            schema:register(XMLValueType.FLOAT, "vehicle.drivable.idleTurning#steeringFactor" , "Steering speed factor" , 100 )
            schema:register(XMLValueType.NODE_INDEX, "vehicle.drivable.idleTurning.wheel(?)#node" , "Wheel node to change" )
            schema:register(XMLValueType.ANGLE, "vehicle.drivable.idleTurning.wheel(?)#steeringAngle" , "Steering angle while idle turning" )
                schema:register(XMLValueType.BOOL, "vehicle.drivable.idleTurning.wheel(?)#inverted" , "Acceleration is inverted" , false )

                Dashboard.registerDashboardXMLPaths(schema, "vehicle.drivable.dashboards" , { "cruiseControl" , "cruiseControlReverse" , "directionForward" , "directionBackward" , "movingDirection" , "cruiseControlActive" , "accelerationAxis" , "decelerationAxis" , "ac_decelerationAxis" , "steeringAngle" , "combinedPedalLeft" , "combinedPedalRight" , "odometerMilage" } )
                SoundManager.registerSampleXMLPaths(schema, "vehicle.drivable.sounds" , "waterSplash" )

                schema:setXMLSpecializationType()

                local schemaSavegame = Vehicle.xmlSchemaSavegame
                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).drivable#cruiseControl" , "Current cruise control speed" )
                schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).drivable#cruiseControlReverse" , "Current cruise control speed reverse" )
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).drivable#odometerMilage" , "Current odometer milage(km)" , 0 )
            end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Drivable:onDelete()
    local spec = self.spec_drivable
    g_soundManager:deleteSamples(spec.samples)

    if spec.hudExtension ~ = nil then
        spec.hudExtension:delete()
    end
end

```

### onLeaveVehicle

**Description**

**Definition**

> onLeaveVehicle()

**Arguments**

| any | wasEntered |
|-----|------------|

**Code**

```lua
function Drivable:onLeaveVehicle(wasEntered)
    self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF, true )

    if self.brake ~ = nil then
        self:brake( 1 )
    end

    if wasEntered then
        local spec = self.spec_drivable
        local forceFeedback = spec.forceFeedback
        if forceFeedback.isActive then
            forceFeedback.device:setForceFeedback(forceFeedback.axisIndex, 0 , 0 )
            forceFeedback.isActive = false
            forceFeedback.device = nil
        end
    end
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
function Drivable:onLoad(savegame)
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.steering#index" , "vehicle.drivable.steeringWheel#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.steering#node" , "vehicle.drivable.steeringWheel#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cruiseControl" , "vehicle.drivable.cruiseControl" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.indoorHud.cruiseControl" , "vehicle.drivable.dashboards.dashboard with valueType 'cruiseControl'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.showChangeToolSelectionHelp" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.maxRotatedTimeSpeed#value" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.speedRotScale#scale" , "vehicle.drivable.speedRotScale#scale" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.speedRotScale#offset" , "vehicle.drivable.speedRotScale#offset" ) --FS17 to FS19

    local spec = self.spec_drivable

    spec.showToolSelectionHud = true

    spec.doHandbrake = false
    spec.doHandbrakeSend = false
    spec.reverserDirection = self.xmlFile:getValue( "vehicle.drivable#reverserDirection" , 1 )
    spec.steeringDirection = self.xmlFile:getValue( "vehicle.drivable#steeringDirection" , 1 )

    -- attributes set by action events
    spec.lastInputValues = { }
    spec.lastInputValues.axisAccelerate = 0
    spec.lastInputValues.axisBrake = 0
    spec.lastInputValues.axisSteer = 0
    spec.lastInputValues.axisSteerIsAnalog = false
    spec.lastInputValues.axisSteerDeviceCategory = InputDevice.CATEGORY.UNKNOWN
    spec.lastInputValues.cruiseControlValue = 0
    spec.lastInputValues.cruiseControlState = 0

    -- 'final' attrbutes calculated
    spec.axisForward = 0
    spec.axisForwardSend = 0

    spec.axisSide = 0
    spec.axisSideSend = 0
    spec.axisSideLast = 0

    spec.lastIsControlled = false

    spec.speedRotScale = self.xmlFile:getValue( "vehicle.drivable.speedRotScale#scale" , 80 )
    spec.speedRotScaleOffset = self.xmlFile:getValue( "vehicle.drivable.speedRotScale#offset" , 0.7 )

    local motor = self:getMotor()
    spec.cruiseControl = { }
    spec.cruiseControl.maxSpeed = self.xmlFile:getValue( "vehicle.drivable.cruiseControl#maxSpeed" , MathUtil.round(motor:getMaximumForwardSpeed() * 3.6 ))
    spec.cruiseControl.minSpeed = self.xmlFile:getValue( "vehicle.drivable.cruiseControl#minSpeed" , math.min( 1 , spec.cruiseControl.maxSpeed))
    spec.cruiseControl.speed = spec.cruiseControl.maxSpeed
    spec.cruiseControl.maxSpeedReverse = self.xmlFile:getValue( "vehicle.drivable.cruiseControl#maxSpeedReverse" , MathUtil.round(motor:getMaximumBackwardSpeed() * 3.6 ))
    spec.cruiseControl.speedReverse = spec.cruiseControl.maxSpeedReverse
    spec.cruiseControl.isActive = self.xmlFile:getValue( "vehicle.drivable.cruiseControl#enabled" , true )
    spec.cruiseControl.state = Drivable.CRUISECONTROL_STATE_OFF
    spec.cruiseControl.topSpeedTime = 1000
    spec.cruiseControl.changeDelay = 250
    spec.cruiseControl.changeCurrentDelay = 0
    spec.cruiseControl.changeMultiplier = 1
    spec.cruiseControl.transmissionDirection = 1
    spec.cruiseControl.speedSent = spec.cruiseControl.speed
    spec.cruiseControl.speedReverseSent = spec.cruiseControl.speedReverse

    local node = self.xmlFile:getValue( "vehicle.drivable.steeringWheel#node" , nil , self.components, self.i3dMappings)
    if node ~ = nil then
        spec.steeringWheel = { }
        spec.steeringWheel.node = node
        local _,ry,_ = getRotation(spec.steeringWheel.node)
        spec.steeringWheel.lastRotation = ry
        spec.steeringWheel.indoorRotation = self.xmlFile:getValue( "vehicle.drivable.steeringWheel#indoorRotation" , 0 )
        spec.steeringWheel.outdoorRotation = self.xmlFile:getValue( "vehicle.drivable.steeringWheel#outdoorRotation" , 0 )
    end

    spec.idleTurningAllowed = self.xmlFile:getValue( "vehicle.drivable.idleTurning#allowed" , false )
    spec.idleTurningUpdateSteeringWheel = self.xmlFile:getValue( "vehicle.drivable.idleTurning#updateSteeringWheel" , true )
    spec.idleTurningLockDirection = self.xmlFile:getValue( "vehicle.drivable.idleTurning#lockDirection" , true )
    spec.idleTurningDrivingDirection = self.xmlFile:getValue( "vehicle.drivable.idleTurning#direction" , 1 )
    spec.idleTurningMaxSpeed = self.xmlFile:getValue( "vehicle.drivable.idleTurning#maxSpeed" , 10 )
    spec.idleTurningSteeringFactor = self.xmlFile:getValue( "vehicle.drivable.idleTurning#steeringFactor" , 100 )

    spec.idleTurningWheels = { }
    self.xmlFile:iterate( "vehicle.drivable.idleTurning.wheel" , function (index, key)
        local wheelNode = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if wheelNode ~ = nil then
            local entry = { }
            entry.wheelNode = wheelNode
            entry.steeringAngle = self.xmlFile:getValue(key .. "#steeringAngle" , 0 )
            entry.inverted = self.xmlFile:getValue(key .. "#inverted" , false )

            table.insert(spec.idleTurningWheels, entry)
        end
    end )

    spec.idleTurningActive = false
    spec.idleTurningActiveSend = false
    spec.idleTurningDirection = 0

    self.customSteeringAngleFunction = self.customSteeringAngleFunction or #spec.idleTurningWheels > 0

    spec.forceFeedback = { }
    spec.forceFeedback.isActive = false
    spec.forceFeedback.device = nil
    spec.forceFeedback.binding = nil
    spec.forceFeedback.axisIndex = 0
    spec.forceFeedback.intensity = g_gameSettings:getValue(GameSettings.SETTING.FORCE_FEEDBACK)

    spec.playerControlAllowedFunctions = { }
    spec.hasPlayerControlAllowedFunctions = false

    spec.initialWheelPhysicsUpdate = true

    spec.odometerMilage = 0

    if self.isClient then
        spec.samples = { }
        spec.samples.waterSplash = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.drivable.sounds" , "waterSplash" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
        if self.isClient and g_isDevelopmentVersion and not GS_IS_MOBILE_VERSION then
            if spec.samples.waterSplash = = nil then
                Logging.xmlDevWarning( self.xmlFile, "Missing drivable waterSplash sound" )
            end
        end
    end

    if savegame ~ = nil then
        local maxSpeed = savegame.xmlFile:getValue(savegame.key .. ".drivable#cruiseControl" )
        local maxSpeedReverse = savegame.xmlFile:getValue(savegame.key .. ".drivable#cruiseControlReverse" )
        self:setCruiseControlMaxSpeed(maxSpeed, maxSpeedReverse)

        spec.odometerMilage = savegame.xmlFile:getValue(savegame.key .. ".drivable#odometerMilage" , spec.odometerMilage)
    end

    spec.hudExtension = CruiseControlHUDExtension.new( self )

    spec.dirtyFlag = self:getNextDirtyFlag()
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
function Drivable:onReadStream(streamId, connection)
    local spec = self.spec_drivable

    if spec.cruiseControl.isActive then
        self:setCruiseControlState(streamReadUIntN(streamId, 2 ), true )
        local speed = streamReadUInt8(streamId)
        local speedReverse = streamReadUInt8(streamId)
        self:setCruiseControlMaxSpeed(speed, speedReverse)
        spec.cruiseControl.speedSent = speed
        spec.cruiseControl.speedReverseSent = speedReverse

        spec.odometerMilage = streamReadFloat32(streamId)
    end
end

```

### onReadUpdateStream

**Description**

> Called on on update

**Definition**

> onReadUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function Drivable:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_drivable

    if streamReadBool(streamId) then
        spec.axisForward = streamReadUIntN(streamId, 10 ) / 1023 * 2 - 1
        if math.abs(spec.axisForward) < 0.00099 then
            spec.axisForward = 0 -- set to 0 to avoid noise caused by compression
        end

        spec.axisSide = streamReadUIntN(streamId, 10 ) / 1023 * 2 - 1
        if math.abs(spec.axisSide) < 0.00099 then
            spec.axisSide = 0 -- set to 0 to avoid noise caused by compression
        end

        spec.doHandbrake = streamReadBool(streamId)
        spec.idleTurningActive = streamReadBool(streamId)
    end
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
function Drivable:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_drivable

        spec.toggleCruiseControlEvent = nil
        self:clearActionEventsTable(spec.actionEvents)

        local entered = true
        if self.getIsEntered ~ = nil then
            entered = self:getIsEntered()
        end

        local _, actionEventId

        if self:getIsActiveForInput( true , true ) and entered then
            if not self:getIsAIActive() then
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_ACCELERATE_VEHICLE, self , Drivable.actionEventAccelerate, false , false , true , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_BRAKE_VEHICLE, self , Drivable.actionEventBrake, false , false , true , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.AXIS_MOVE_SIDE_VEHICLE, self , Drivable.actionEventSteer, false , false , true , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_steer" ))

                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_CRUISE_CONTROL, self , Drivable.actionEventCruiseControlState, false , true , true , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)
                spec.toggleCruiseControlEvent = actionEventId
            end

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_CRUISE_CONTROL, self , Drivable.actionEventCruiseControlValue, false , true , true , true , nil )
            g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_changeCruiseControlLevel" ))
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)
        end
    end
end

```

### onRegisterDashboardValueTypes

**Description**

> Called on post load to register dashboard value types

**Definition**

> onRegisterDashboardValueTypes()

**Code**

```lua
function Drivable:onRegisterDashboardValueTypes()
    local spec = self.spec_drivable

    local cruiseControl = DashboardValueType.new( "drivable" , "cruiseControl" )
    cruiseControl:setValue(spec.cruiseControl, "speed" )
    self:registerDashboardValueType(cruiseControl)

    local cruiseControlReverse = DashboardValueType.new( "drivable" , "cruiseControlReverse" )
    cruiseControlReverse:setValue(spec.cruiseControl, "speedReverse" )
    self:registerDashboardValueType(cruiseControlReverse)

    local cruiseControlActive = DashboardValueType.new( "drivable" , "cruiseControlActive" )
    cruiseControlActive:setValue(spec.cruiseControl, "state" )
    cruiseControlActive:setValueCompare( Drivable.CRUISECONTROL_STATE_ACTIVE, Drivable.CRUISECONTROL_STATE_FULL)
    self:registerDashboardValueType(cruiseControlActive)

    local directionForward = DashboardValueType.new( "drivable" , "directionForward" )
    directionForward:setValue( self , "getIsDrivingForward" )
    self:registerDashboardValueType(directionForward)

    local directionBackward = DashboardValueType.new( "drivable" , "directionBackward" )
    directionBackward:setValue( self , "getIsDrivingBackward" )
    self:registerDashboardValueType(directionBackward)

    local movingDirection = DashboardValueType.new( "drivable" , "movingDirection" )
    movingDirection:setValue( self , "getDrivingDirection" )
    movingDirection:setRange( - 1 , 1 )
    self:registerDashboardValueType(movingDirection)

    local accelerationAxis = DashboardValueType.new( "drivable" , "accelerationAxis" )
    accelerationAxis:setValue( self , "getAccelerationAxis" )
    self:registerDashboardValueType(accelerationAxis)

    local decelerationAxis = DashboardValueType.new( "drivable" , "decelerationAxis" )
    decelerationAxis:setValue( self , "getDecelerationAxis" )
    self:registerDashboardValueType(decelerationAxis)

    local ac_decelerationAxis = DashboardValueType.new( "drivable" , "ac_decelerationAxis" )
    ac_decelerationAxis:setValue( self , "getAcDecelerationAxis" )
    self:registerDashboardValueType(ac_decelerationAxis)

    local steeringAngle = DashboardValueType.new( "drivable" , "steeringAngle" )
    steeringAngle:setValue( self , "getDashboardSteeringAxis" )
    steeringAngle:setRange( - 1 , 1 )
    self:registerDashboardValueType(steeringAngle)

    local combinedPedalLeft = DashboardValueType.new( "drivable" , "combinedPedalLeft" )
    combinedPedalLeft:setValue( self , Drivable.getDashboardCombinedPedalLeft)
    combinedPedalLeft:setRange( - 1 , 1 )
    self:registerDashboardValueType(combinedPedalLeft)

    local combinedPedalRight = DashboardValueType.new( "drivable" , "combinedPedalRight" )
    combinedPedalRight:setValue( self , Drivable.getDashboardCombinedPedalRight)
    combinedPedalRight:setRange( - 1 , 1 )
    self:registerDashboardValueType(combinedPedalRight)

    local odometerMilage = DashboardValueType.new( "drivable" , "odometerMilage" )
    odometerMilage:setValue(spec, "odometerMilage" )
    self:registerDashboardValueType(odometerMilage)
end

```

### onSetBroken

**Description**

**Definition**

> onSetBroken()

**Code**

```lua
function Drivable:onSetBroken()
    if self.isClient then
        local spec = self.spec_drivable
        g_soundManager:playSample(spec.samples.waterSplash)
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Drivable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_drivable

    -- update inputs on client side for basic controls
        if self.isClient then
            if self.getIsEntered ~ = nil and self:getIsEntered() then
                if self.isActiveForInputIgnoreSelectionIgnoreAI then
                    if self:getIsVehicleControlledByPlayer() then
                        local lastSpeed = self:getLastSpeed()
                        spec.doHandbrake = false

                        -- gas and brake pedal
                        local axisForward = math.clamp((spec.lastInputValues.axisAccelerate - spec.lastInputValues.axisBrake), - 1 , 1 )
                        spec.axisForward = axisForward

                        -- brake until we reach 1 km/h if brakeToStop is active
                            if spec.brakeToStop then
                                spec.lastInputValues.targetSpeed = 0.51
                                spec.lastInputValues.targetDirection = 1

                                if lastSpeed < 1 then
                                    spec.brakeToStop = false

                                    spec.lastInputValues.targetSpeed = nil
                                    spec.lastInputValues.targetDirection = nil
                                end
                            end

                            -- axis forward calculated by current target speed
                            if spec.lastInputValues.targetSpeed ~ = nil then
                                local currentSpeed = lastSpeed * self.movingDirection * self:getReverserDirection()
                                local targetSpeed = spec.lastInputValues.targetSpeed * spec.lastInputValues.targetDirection

                                local speedDifference = targetSpeed - currentSpeed
                                if math.abs(speedDifference) > 0.1 and math.abs(targetSpeed) > 0.5 then
                                    spec.axisForward = math.clamp( math.pow( math.abs(speedDifference), 1.5 ) * math.sign(speedDifference), - 1 , 1 )
                                end
                            end

                            -- steering
                            if self:getIsPowered() then
                                local speedFactor = 1.0
                                local sensitivitySetting = g_gameSettings:getValue(GameSettings.SETTING.STEERING_SENSITIVITY)

                                local axisSteer = spec.lastInputValues.axisSteer

                                if spec.lastInputValues.axisSteerIsAnalog then
                                    local isArticulatedSteering = self.spec_articulatedAxis ~ = nil and self.spec_articulatedAxis.componentJoint ~ = nil
                                    if isArticulatedSteering then
                                        speedFactor = 1.5
                                    else
                                            speedFactor = 2.5
                                        end

                                        if GS_IS_MOBILE_VERSION then
                                            -- Fixed speed factor on mobile, and instead control non-linearity with sensitivity slider
                                            --speedFactor = speedFactor * math.min(1.0/(self.lastSpeed*spec.speedRotScale+spec.speedRotScaleOffset), 1)

                                            speedFactor = speedFactor * 1.5
                                            if axisSteer = = 0 then
                                                speedFactor = speedFactor * g_gameSettings:getValue(GameSettings.SETTING.STEERING_BACK_SPEED) / 10
                                            end

                                            axisSteer = math.pow( math.abs(axisSteer), 1.0 / sensitivitySetting) * (axisSteer > = 0 and 1 or - 1 )
                                        else
                                                -- only use steering speed for gamepads
                                                    if spec.lastInputValues.axisSteerDeviceCategory = = InputDevice.CATEGORY.GAMEPAD then
                                                        speedFactor = math.min( 1.0 / ( self.lastSpeed * spec.speedRotScale + spec.speedRotScaleOffset), 1 )
                                                        speedFactor = (speedFactor * speedFactor) * sensitivitySetting * 1.75
                                                    end
                                                end

                                                local forceFeedback = spec.forceFeedback
                                                if forceFeedback.isActive then
                                                    if forceFeedback.intensity > 0 then
                                                        local angleFactor = math.abs(axisSteer)
                                                        local speedForceFactor = math.max( math.min((lastSpeed - 2 ) / 15 , 1 ), 0 )
                                                        local targetState = axisSteer - ( 0.2 * speedForceFactor) * math.sign(axisSteer)
                                                        local force = math.max( math.abs(targetState) * 0.4 , 0.25 ) * speedForceFactor * angleFactor * 2 * forceFeedback.intensity
                                                        forceFeedback.device:setForceFeedback(forceFeedback.axisIndex, force, targetState)
                                                    else
                                                            forceFeedback.device:setForceFeedback(forceFeedback.axisIndex, 0 , axisSteer)
                                                        end
                                                    end
                                                else
                                                        -- True if the vehicle is steered one direction, but the player wants to steer it to the other direction.
                                                            local isSteeringBack = spec.lastInputValues.axisSteer ~ = 0 and math.sign(spec.lastInputValues.axisSteer) ~ = math.sign(spec.axisSide)

                                                            if spec.lastInputValues.axisSteer = = 0 or isSteeringBack then
                                                                local rotateBackSpeedSetting = g_gameSettings:getValue(GameSettings.SETTING.STEERING_BACK_SPEED) / 10

                                                                -- if the setting is '1' we use the same speed as we use for steering
                                                                    -- if the setting is smaller '1' we reduce the steering angle depending on the driving speed
                                                                        if not isSteeringBack and rotateBackSpeedSetting < 1 and self.speedDependentRotateBack then
                                                                            local speed = math.max(lastSpeed - 0.5 , 0 ) / 36
                                                                            local setting = rotateBackSpeedSetting / 0.5
                                                                            speedFactor = speedFactor * math.min(speed * setting, 1 )
                                                                        end

                                                                        speedFactor = speedFactor * ( self.autoRotateBackSpeed or 1 ) / 1.5
                                                                    else
                                                                            speedFactor = math.min( 1.0 / ( self.lastSpeed * spec.speedRotScale + spec.speedRotScaleOffset), 1 )
                                                                            speedFactor = speedFactor * sensitivitySetting
                                                                        end
                                                                    end

                                                                    -- idle turning
                                                                    if spec.idleTurningAllowed then
                                                                        if axisForward = = 0 and math.abs(axisSteer) > 0.05 and lastSpeed < 1 then
                                                                            if not spec.idleTurningActive then
                                                                                spec.idleTurningActive = true
                                                                                spec.idleTurningDirection = math.sign(axisSteer) * spec.idleTurningDrivingDirection
                                                                            end
                                                                        end

                                                                        if axisForward ~ = 0 then
                                                                            if spec.idleTurningActive then
                                                                                spec.idleTurningActive = false

                                                                                if axisSteer > 0 then
                                                                                    self.rotatedTime = self.minRotTime
                                                                                    spec.axisSide = 1
                                                                                elseif axisSteer < 0 then
                                                                                        self.rotatedTime = self.maxRotTime
                                                                                        spec.axisSide = - 1
                                                                                    end
                                                                                end
                                                                            end

                                                                            if spec.idleTurningActive then
                                                                                if not spec.idleTurningLockDirection then
                                                                                    spec.idleTurningDirection = spec.idleTurningDrivingDirection

                                                                                    if axisSteer = = 0 then
                                                                                        spec.idleTurningActive = false
                                                                                        spec.axisSide = 0
                                                                                    end
                                                                                end
                                                                            end

                                                                            if spec.idleTurningActive then
                                                                                spec.axisForward = spec.idleTurningDirection * math.sign(axisSteer)

                                                                                axisSteer = math.abs(axisSteer) * spec.idleTurningDirection
                                                                                speedFactor = speedFactor * spec.idleTurningSteeringFactor
                                                                            end
                                                                        end

                                                                        local steeringDuration = ( self.wheelSteeringDuration or 1 ) * 1000
                                                                        local rotDelta = (dt / steeringDuration) * speedFactor

                                                                        if axisSteer > spec.axisSide then
                                                                            spec.axisSide = math.min(axisSteer, spec.axisSide + rotDelta)
                                                                        elseif axisSteer < spec.axisSide then
                                                                                spec.axisSide = math.max(axisSteer, spec.axisSide - rotDelta)
                                                                            end
                                                                        end
                                                                    else
                                                                            spec.axisForward = 0
                                                                            spec.idleTurningActive = false
                                                                            if self.rotatedTime < 0 then
                                                                                spec.axisSide = self.rotatedTime / - self.maxRotTime / self:getSteeringDirection()
                                                                            else
                                                                                    spec.axisSide = self.rotatedTime / self.minRotTime / self:getSteeringDirection()
                                                                                end
                                                                            end
                                                                        else
                                                                                spec.doHandbrake = true
                                                                                spec.axisForward = 0
                                                                                spec.idleTurningActive = false
                                                                            end

                                                                            -- prepare for next frame
                                                                                spec.lastInputValues.axisAccelerate = 0
                                                                                spec.lastInputValues.axisBrake = 0
                                                                                spec.lastInputValues.axisSteer = 0

                                                                                -- prepare network update
                                                                                if spec.axisForward ~ = spec.axisForwardSend or spec.axisSide ~ = spec.axisSideSend or spec.doHandbrake ~ = spec.doHandbrakeSend or spec.idleTurningActiveSend ~ = spec.idleTurningActive then
                                                                                    spec.axisForwardSend = spec.axisForward
                                                                                    spec.axisSideSend = spec.axisSide
                                                                                    spec.doHandbrakeSend = spec.doHandbrake
                                                                                    spec.idleTurningActiveSend = spec.idleTurningActive
                                                                                    self:raiseDirtyFlags(spec.dirtyFlag)
                                                                                end
                                                                            end
                                                                        end

                                                                        -- update inputs on client side for cruise control
                                                                            if self.isClient then
                                                                                if self.getIsEntered ~ = nil and self:getIsEntered() then
                                                                                    -- cruise control state
                                                                                    local inputValue = spec.lastInputValues.cruiseControlState
                                                                                    spec.lastInputValues.cruiseControlState = 0

                                                                                    if inputValue = = 1 then
                                                                                        if spec.cruiseControl.topSpeedTime = = Drivable.CRUISECONTROL_FULL_TOGGLE_TIME then
                                                                                            if spec.cruiseControl.state = = Drivable.CRUISECONTROL_STATE_OFF then
                                                                                                self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_ACTIVE)
                                                                                            else
                                                                                                    self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF)
                                                                                                end
                                                                                            end

                                                                                            if spec.cruiseControl.topSpeedTime > 0 then
                                                                                                spec.cruiseControl.topSpeedTime = spec.cruiseControl.topSpeedTime - dt
                                                                                                if spec.cruiseControl.topSpeedTime < 0 then
                                                                                                    self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_FULL)
                                                                                                end
                                                                                            end
                                                                                        else
                                                                                                spec.cruiseControl.topSpeedTime = Drivable.CRUISECONTROL_FULL_TOGGLE_TIME
                                                                                            end

                                                                                            -- cruise control value
                                                                                            local lastCruiseControlValue = spec.lastInputValues.cruiseControlValue
                                                                                            spec.lastInputValues.cruiseControlValue = 0

                                                                                            if lastCruiseControlValue ~ = 0 then
                                                                                                spec.cruiseControl.changeCurrentDelay = spec.cruiseControl.changeCurrentDelay - (dt * spec.cruiseControl.changeMultiplier)
                                                                                                spec.cruiseControl.changeMultiplier = math.min(spec.cruiseControl.changeMultiplier + (dt * 0.003 ), 10 )

                                                                                                if spec.cruiseControl.changeCurrentDelay < 0 then
                                                                                                    spec.cruiseControl.changeCurrentDelay = spec.cruiseControl.changeDelay

                                                                                                    local dir = math.sign(lastCruiseControlValue)

                                                                                                    local speed, speedReverse = spec.cruiseControl.speed, spec.cruiseControl.speedReverse
                                                                                                    local useReverseSpeed = self:getDrivingDirection() < 0
                                                                                                    if self:getReverserDirection() < 0 then
                                                                                                        useReverseSpeed = not useReverseSpeed
                                                                                                    end

                                                                                                    if useReverseSpeed then
                                                                                                        speedReverse = speedReverse + dir
                                                                                                    else
                                                                                                            speed = speed + dir
                                                                                                        end

                                                                                                        self:setCruiseControlMaxSpeed(speed, speedReverse)

                                                                                                        if spec.cruiseControl.speed ~ = spec.cruiseControl.speedSent or spec.cruiseControl.speedReverse ~ = spec.cruiseControl.speedReverseSent then
                                                                                                            if g_server ~ = nil then
                                                                                                                g_server:broadcastEvent( SetCruiseControlSpeedEvent.new( self , spec.cruiseControl.speed, spec.cruiseControl.speedReverse), nil , nil , self )
                                                                                                            else
                                                                                                                    g_client:getServerConnection():sendEvent( SetCruiseControlSpeedEvent.new( self , spec.cruiseControl.speed, spec.cruiseControl.speedReverse))
                                                                                                                end
                                                                                                                spec.cruiseControl.speedSent = spec.cruiseControl.speed
                                                                                                                spec.cruiseControl.speedReverseSent = spec.cruiseControl.speedReverse
                                                                                                            end
                                                                                                        end
                                                                                                    else
                                                                                                            spec.cruiseControl.changeCurrentDelay = 0
                                                                                                            spec.cruiseControl.changeMultiplier = 1
                                                                                                        end

                                                                                                    end
                                                                                                end

                                                                                                local isControlled = self.getIsControlled ~ = nil and self:getIsControlled()

                                                                                                -- update vehicle physics on server side
                                                                                                if self:getIsVehicleControlledByPlayer() then
                                                                                                    if self.isServer then
                                                                                                        if isControlled then
                                                                                                            local cruiseControlSpeed = math.huge
                                                                                                            if spec.cruiseControl.state = = Drivable.CRUISECONTROL_STATE_ACTIVE then
                                                                                                                if self:getReverserDirection() < 0 then
                                                                                                                    cruiseControlSpeed = spec.cruiseControl.speedReverse
                                                                                                                else
                                                                                                                        cruiseControlSpeed = spec.cruiseControl.speed
                                                                                                                    end
                                                                                                                end
                                                                                                                if self:getDrivingDirection() < 0 then
                                                                                                                    if self:getReverserDirection() < 0 then
                                                                                                                        cruiseControlSpeed = math.min(cruiseControlSpeed, spec.cruiseControl.speed)
                                                                                                                    else
                                                                                                                            cruiseControlSpeed = math.min(cruiseControlSpeed, spec.cruiseControl.speedReverse)
                                                                                                                        end
                                                                                                                    end

                                                                                                                    -- while cruise control is active we interpolate between the speed while changing them
                                                                                                                        -- this reduces the peak motor load while this change happens
                                                                                                                            if cruiseControlSpeed ~ = math.huge then
                                                                                                                                spec.cruiseControl.speedInterpolated = spec.cruiseControl.speedInterpolated or cruiseControlSpeed
                                                                                                                                if cruiseControlSpeed ~ = spec.cruiseControl.speedInterpolated then
                                                                                                                                    local diff = cruiseControlSpeed - spec.cruiseControl.speedInterpolated
                                                                                                                                    local dir = math.sign(diff)
                                                                                                                                    local limit = dir = = 1 and math.min or math.max
                                                                                                                                    spec.cruiseControl.speedInterpolated = limit(spec.cruiseControl.speedInterpolated + dt * 0.0025 * math.max( 1 , math.abs(diff)) * dir, cruiseControlSpeed)
                                                                                                                                    cruiseControlSpeed = spec.cruiseControl.speedInterpolated
                                                                                                                                end
                                                                                                                            else
                                                                                                                                    spec.cruiseControl.speedInterpolated = nil
                                                                                                                                end

                                                                                                                                local maxSpeed, _ = self:getSpeedLimit( true )
                                                                                                                                maxSpeed = math.min(maxSpeed, cruiseControlSpeed)

                                                                                                                                if spec.idleTurningAllowed then
                                                                                                                                    if spec.idleTurningActive then
                                                                                                                                        maxSpeed = math.min(maxSpeed, spec.idleTurningMaxSpeed)
                                                                                                                                    end
                                                                                                                                end

                                                                                                                                self:getMotor():setSpeedLimit(maxSpeed)

                                                                                                                                self:updateVehiclePhysics(spec.axisForward, spec.axisSide, spec.doHandbrake, dt)
                                                                                                                            else
                                                                                                                                    if spec.lastIsControlled then
                                                                                                                                        SpecializationUtil.raiseEvent( self , "onVehiclePhysicsUpdate" , 0 , 0 , true , 0 )
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end

                                                                                                                        -- just a visual update of the steering wheel
                                                                                                                        if self.isClient and isControlled then
                                                                                                                            local allowed = true
                                                                                                                            if spec.idleTurningAllowed then
                                                                                                                                if spec.idleTurningActive and not spec.idleTurningUpdateSteeringWheel then
                                                                                                                                    allowed = false
                                                                                                                                end
                                                                                                                            end

                                                                                                                            if allowed then
                                                                                                                                self:updateSteeringWheel(spec.steeringWheel, dt, 1 )
                                                                                                                            end
                                                                                                                        end

                                                                                                                        spec.lastIsControlled = isControlled

                                                                                                                        -- steering based on mobile device orientation
                                                                                                                        if self:getIsActiveForInput( true ) then
                                                                                                                            local inputHelpMode = g_inputBinding:getInputHelpMode()
                                                                                                                            if inputHelpMode ~ = GS_INPUT_HELP_MODE_GAMEPAD or GS_PLATFORM_SWITCH then
                                                                                                                                if g_gameSettings:getValue(GameSettings.SETTING.GYROSCOPE_STEERING) then
                                                                                                                                    local dx, dy, dz = getGravityDirection()
                                                                                                                                    local steeringValue = MathUtil.getSteeringAngleFromDeviceGravity(dx, dy, dz)

                                                                                                                                    --renderText(0.5, 0.7, 0.016, string.format("Gravity: %.4f, %.4f, %.4f -> %.4f", dx, dy, dz, steeringValue))

                                                                                                                                    self:setSteeringInput(steeringValue, true , InputDevice.CATEGORY.WHEEL)
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end

                                                                                                                        spec.odometerMilage = spec.odometerMilage + self.lastMovedDistance * 0.001
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
function Drivable:onWriteStream(streamId, connection)
    local spec = self.spec_drivable

    if spec.cruiseControl.isActive then
        streamWriteUIntN(streamId, spec.cruiseControl.state, 2 )
        streamWriteUInt8(streamId, spec.cruiseControl.speed)
        streamWriteUInt8(streamId, spec.cruiseControl.speedReverse)

        streamWriteFloat32(streamId, spec.odometerMilage)
    end
end

```

### onWriteUpdateStream

**Description**

> Called on on update

**Definition**

> onWriteUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function Drivable:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_drivable

    if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
        local axisForward = math.clamp(spec.axisForward + 1 , 0 , 2 ) / 2 * 1023
        streamWriteUIntN(streamId, axisForward, 10 )

        local axisSide = math.clamp(spec.axisSide + 1 , 0 , 2 ) / 2 * 1023
        streamWriteUIntN(streamId, axisSide, 10 )

        streamWriteBool(streamId, spec.doHandbrake)
        streamWriteBool(streamId, spec.idleTurningActive)
    end
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
function Drivable.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Enterable , specializations) and SpecializationUtil.hasSpecialization( Motorized , specializations)
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
function Drivable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterDashboardValueTypes" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , Drivable )
    SpecializationUtil.registerEventListener(vehicleType, "onSetBroken" , Drivable )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function Drivable.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onVehiclePhysicsUpdate" )
    SpecializationUtil.registerEvent(vehicleType, "onCruiseControlSpeedChanged" )
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
function Drivable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "updateSteeringWheel" , Drivable.updateSteeringWheel)
    SpecializationUtil.registerFunction(vehicleType, "setCruiseControlState" , Drivable.setCruiseControlState)
    SpecializationUtil.registerFunction(vehicleType, "setCruiseControlMaxSpeed" , Drivable.setCruiseControlMaxSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getCruiseControlState" , Drivable.getCruiseControlState)
    SpecializationUtil.registerFunction(vehicleType, "getCruiseControlSpeed" , Drivable.getCruiseControlSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getCruiseControlMaxSpeed" , Drivable.getCruiseControlMaxSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getCruiseControlDisplayInfo" , Drivable.getCruiseControlDisplayInfo)
    SpecializationUtil.registerFunction(vehicleType, "getAxisForward" , Drivable.getAxisForward)
    SpecializationUtil.registerFunction(vehicleType, "getAccelerationAxis" , Drivable.getAccelerationAxis)
    SpecializationUtil.registerFunction(vehicleType, "getDecelerationAxis" , Drivable.getDecelerationAxis)
    SpecializationUtil.registerFunction(vehicleType, "getCruiseControlAxis" , Drivable.getCruiseControlAxis)
    SpecializationUtil.registerFunction(vehicleType, "getAcDecelerationAxis" , Drivable.getAcDecelerationAxis)
    SpecializationUtil.registerFunction(vehicleType, "getDashboardSteeringAxis" , Drivable.getDashboardSteeringAxis)
    SpecializationUtil.registerFunction(vehicleType, "setReverserDirection" , Drivable.setReverserDirection)
    SpecializationUtil.registerFunction(vehicleType, "getReverserDirection" , Drivable.getReverserDirection)
    SpecializationUtil.registerFunction(vehicleType, "getSteeringDirection" , Drivable.getSteeringDirection)
    SpecializationUtil.registerFunction(vehicleType, "getIsDrivingForward" , Drivable.getIsDrivingForward)
    SpecializationUtil.registerFunction(vehicleType, "getIsDrivingBackward" , Drivable.getIsDrivingBackward)
    SpecializationUtil.registerFunction(vehicleType, "getDrivingDirection" , Drivable.getDrivingDirection)
    SpecializationUtil.registerFunction(vehicleType, "getIsVehicleControlledByPlayer" , Drivable.getIsVehicleControlledByPlayer)
    SpecializationUtil.registerFunction(vehicleType, "getIsPlayerVehicleControlAllowed" , Drivable.getIsPlayerVehicleControlAllowed)
    SpecializationUtil.registerFunction(vehicleType, "registerPlayerVehicleControlAllowedFunction" , Drivable.registerPlayerVehicleControlAllowedFunction)
    SpecializationUtil.registerFunction(vehicleType, "updateVehiclePhysics" , Drivable.updateVehiclePhysics)
    SpecializationUtil.registerFunction(vehicleType, "setAccelerationPedalInput" , Drivable.setAccelerationPedalInput)
    SpecializationUtil.registerFunction(vehicleType, "setBrakePedalInput" , Drivable.setBrakePedalInput)
    SpecializationUtil.registerFunction(vehicleType, "setTargetSpeedAndDirection" , Drivable.setTargetSpeedAndDirection)
    SpecializationUtil.registerFunction(vehicleType, "setSteeringInput" , Drivable.setSteeringInput)
    SpecializationUtil.registerFunction(vehicleType, "brakeToStop" , Drivable.brakeToStop)
    SpecializationUtil.registerFunction(vehicleType, "updateSteeringAngle" , Drivable.updateSteeringAngle)
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
function Drivable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsManualDirectionChangeAllowed" , Drivable.getIsManualDirectionChangeAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getMapHotspotRotation" , Drivable.getMapHotspotRotation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setTransmissionDirection" , Drivable.setTransmissionDirection)
end

```

### registerPlayerVehicleControlAllowedFunction

**Description**

> Registers function to be check when player tries to control the vehicle

**Definition**

> registerPlayerVehicleControlAllowedFunction(table vehicle, function func)

**Arguments**

| table    | vehicle | vehicle object         |
|----------|---------|------------------------|
| function | func    | function to be checked |

**Code**

```lua
function Drivable:registerPlayerVehicleControlAllowedFunction(vehicle, func)
    local objectId = NetworkUtil.getObjectId(vehicle)
    if objectId ~ = nil and func ~ = nil then
        local spec = self.spec_drivable
        spec.playerControlAllowedFunctions[objectId] = func
        spec.hasPlayerControlAllowedFunctions = table.size(spec.playerControlAllowedFunctions) > 0
    end
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
function Drivable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_drivable
    xmlFile:setValue(key .. "#cruiseControl" , spec.cruiseControl.speed)
    xmlFile:setValue(key .. "#cruiseControlReverse" , spec.cruiseControl.speedReverse)
    xmlFile:setValue(key .. "#odometerMilage" , spec.odometerMilage)
end

```

### setAccelerationPedalInput

**Description**

**Definition**

> setAccelerationPedalInput()

**Arguments**

| any | inputValue |
|-----|------------|

**Code**

```lua
function Drivable:setAccelerationPedalInput(inputValue)
    local spec = self.spec_drivable
    spec.lastInputValues.axisAccelerate = math.clamp(inputValue, 0 , 1 )

    if spec.lastInputValues.targetSpeed ~ = nil then
        spec.lastInputValues.targetSpeed = nil
        spec.lastInputValues.targetDirection = nil
    end
end

```

### setBrakePedalInput

**Description**

**Definition**

> setBrakePedalInput()

**Arguments**

| any | inputValue |
|-----|------------|

**Code**

```lua
function Drivable:setBrakePedalInput(inputValue)
    local spec = self.spec_drivable
    spec.lastInputValues.axisBrake = math.clamp(inputValue, 0 , 1 )

    if spec.lastInputValues.targetSpeed ~ = nil then
        spec.lastInputValues.targetSpeed = nil
        spec.lastInputValues.targetDirection = nil
    end
end

```

### setCruiseControlMaxSpeed

**Description**

> Sets cruise control max speed

**Definition**

> setCruiseControlMaxSpeed(float speed, float speedReverse)

**Arguments**

| float | speed        | new max speed         |
|-------|--------------|-----------------------|
| float | speedReverse | new max reverse speed |

**Code**

```lua
function Drivable:setCruiseControlMaxSpeed(speed, speedReverse)
    local spec = self.spec_drivable

    if speed ~ = nil then
        speed = math.clamp(speed, spec.cruiseControl.minSpeed, spec.cruiseControl.maxSpeed)
        if spec.cruiseControl.speed ~ = speed then
            spec.cruiseControl.speed = speed
            if spec.cruiseControl.state = = Drivable.CRUISECONTROL_STATE_FULL then
                spec.cruiseControl.state = Drivable.CRUISECONTROL_STATE_ACTIVE
            end
        end

        if speedReverse ~ = nil then
            speedReverse = math.clamp(speedReverse, spec.cruiseControl.minSpeed, spec.cruiseControl.maxSpeedReverse)
            spec.cruiseControl.speedReverse = speedReverse
        end

        if spec.cruiseControl.state ~ = Drivable.CRUISECONTROL_STATE_OFF then
            if spec.cruiseControl.state = = Drivable.CRUISECONTROL_STATE_ACTIVE then
                local speedLimit,_ = self:getSpeedLimit( true )
                speedLimit = math.min(speedLimit, spec.cruiseControl.speed)
                self:getMotor():setSpeedLimit(speedLimit)
            else
                    self:getMotor():setSpeedLimit( math.huge)
                end
            end

            if self:getDrivingDirection() < 0 then
                local speedLimit,_ = self:getSpeedLimit( true )
                speedLimit = math.min(speedLimit, spec.cruiseControl.speedReverse)
                self:getMotor():setSpeedLimit(speedLimit)
            end

            SpecializationUtil.raiseEvent( self , "onCruiseControlSpeedChanged" , speed, speedReverse)
        end
    end

```

### setCruiseControlState

**Description**

> Changes cruise control state

**Definition**

> setCruiseControlState(integer state, boolean noEventSend)

**Arguments**

| integer | state       | new state     |
|---------|-------------|---------------|
| boolean | noEventSend | no event send |

**Code**

```lua
function Drivable:setCruiseControlState(state, noEventSend)
    local spec = self.spec_drivable
    if spec.cruiseControl ~ = nil and spec.cruiseControl.state ~ = state then
        spec.cruiseControl.state = state
        if noEventSend = = nil or not noEventSend then
            if not self.isServer then
                g_client:getServerConnection():sendEvent( SetCruiseControlStateEvent.new( self , state))
            else
                    local ownerConnection = self:getOwnerConnection()
                    if ownerConnection ~ = nil then
                        ownerConnection:sendEvent( SetCruiseControlStateEvent.new( self , state))
                    end
                end
            end

            if spec.toggleCruiseControlEvent ~ = nil then
                local text
                if state ~ = Drivable.CRUISECONTROL_STATE_ACTIVE then
                    text = g_i18n:getText( "action_activateCruiseControl" )
                else
                        text = g_i18n:getText( "action_deactivateCruiseControl" )
                    end
                    g_inputBinding:setActionEventText(spec.toggleCruiseControlEvent, text)
                end
            end
        end

```

### setReverserDirection

**Description**

**Definition**

> setReverserDirection()

**Arguments**

| any | reverserDirection |
|-----|-------------------|

**Code**

```lua
function Drivable:setReverserDirection(reverserDirection)
    self.spec_drivable.reverserDirection = reverserDirection
end

```

### setSteeringInput

**Description**

**Definition**

> setSteeringInput()

**Arguments**

| any | inputValue     |
|-----|----------------|
| any | isAnalog       |
| any | deviceCategory |

**Code**

```lua
function Drivable:setSteeringInput(inputValue, isAnalog, deviceCategory)
    local spec = self.spec_drivable
    spec.lastInputValues.axisSteer = inputValue
    if inputValue ~ = 0 then
        spec.lastInputValues.axisSteerIsAnalog = isAnalog
        spec.lastInputValues.axisSteerDeviceCategory = deviceCategory
    end
end

```

### setTargetSpeedAndDirection

**Description**

**Definition**

> setTargetSpeedAndDirection()

**Arguments**

| any | speed     |
|-----|-----------|
| any | direction |

**Code**

```lua
function Drivable:setTargetSpeedAndDirection(speed, direction)
    local spec = self.spec_drivable
    if direction > 0 then
        speed = speed * self:getMotor():getMaximumForwardSpeed() * 3.6
    elseif direction < 0 then
            speed = speed * self:getMotor():getMaximumBackwardSpeed() * 3.6
        end

        spec.lastInputValues.targetSpeed = speed
        spec.lastInputValues.targetDirection = direction
    end

```

### setTransmissionDirection

**Description**

> Switches the gear ratios by the given direction

**Definition**

> setTransmissionDirection(integer direction, )

**Arguments**

| integer | direction | direction |
|---------|-----------|-----------|
| any     | direction |           |

**Code**

```lua
function Drivable:setTransmissionDirection(superFunc, direction)
    superFunc( self , direction)

    local spec = self.spec_drivable
    if direction ~ = spec.cruiseControl.transmissionDirection then

        spec.cruiseControl.maxSpeed, spec.cruiseControl.maxSpeedReverse = spec.cruiseControl.maxSpeedReverse, spec.cruiseControl.maxSpeed
        self:setCruiseControlMaxSpeed(spec.cruiseControl.speedReverse, spec.cruiseControl.speed)

        spec.cruiseControl.transmissionDirection = direction
    end
end

```

### stopMotor

**Description**

> Called on motor stop

**Definition**

> stopMotor(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function Drivable:stopMotor(noEventSend)
    self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF, true )
end

```

### updateSteeringAngle

**Description**

**Definition**

> updateSteeringAngle()

**Arguments**

| any | wheel         |
|-----|---------------|
| any | dt            |
| any | steeringAngle |

**Code**

```lua
function Drivable:updateSteeringAngle(wheel, dt, steeringAngle)
    local spec = self.spec_drivable
    if spec.idleTurningAllowed then
        for i = 1 , #spec.idleTurningWheels do
            local wheelData = spec.idleTurningWheels[i]
            if wheel.repr = = wheelData.wheelNode or wheel.driveNode = = wheelData.wheelNode then
                local idleTurnAngle = wheelData.steeringAngle
                if wheelData.inverted then
                    idleTurnAngle = wheelData.steeringAngle + math.pi
                end

                return spec.idleTurningActive and idleTurnAngle or steeringAngle
            end
        end
    end

    return steeringAngle
end

```

### updateSteeringWheel

**Description**

**Definition**

> updateSteeringWheel()

**Arguments**

| any | steeringWheel |
|-----|---------------|
| any | dt            |
| any | direction     |

**Code**

```lua
function Drivable:updateSteeringWheel(steeringWheel, dt, direction)
    if steeringWheel ~ = nil then
        local maxRotation = steeringWheel.outdoorRotation
        if g_localPlayer:getCurrentVehicle() = = self then
            if self.getActiveCamera ~ = nil then
                local activeCamera = self:getActiveCamera()
                if activeCamera ~ = nil and activeCamera.isInside and not activeCamera.isPassengerCamera then
                    maxRotation = steeringWheel.indoorRotation
                end
            end
        end

        local rotation = self.rotatedTime * maxRotation

        if steeringWheel.lastRotation ~ = rotation then
            steeringWheel.lastRotation = rotation

            setRotation(steeringWheel.node, 0 , rotation * direction, 0 )

            if self.getVehicleCharacter ~ = nil then
                local vehicleCharacter = self:getVehicleCharacter()
                if vehicleCharacter ~ = nil then
                    if vehicleCharacter:getAllowCharacterUpdate() then
                        vehicleCharacter:setDirty( true )
                    end
                end
            end
        end
    end
end

```

### updateVehiclePhysics

**Description**

> Update vehicle physics

**Definition**

> updateVehiclePhysics(float axisForward, boolean axisForwardIsAnalog, float axisSide, boolean axisSideIsAnalog, boolean
> doHandbrake, float dt)

**Arguments**

| float   | axisForward         | axis forward value         |
|---------|---------------------|----------------------------|
| boolean | axisForwardIsAnalog | forward axis is analog     |
| float   | axisSide            | side axis                  |
| boolean | axisSideIsAnalog    | side axis is analog        |
| boolean | doHandbrake         | do handbrake               |
| float   | dt                  | time since lsat call in ms |

**Code**

```lua
function Drivable:updateVehiclePhysics(axisForward, axisSide, doHandbrake, dt)
    local spec = self.spec_drivable

    axisSide = self:getSteeringDirection() * axisSide

    local acceleration = 0

    if self:getIsMotorStarted() then
        acceleration = axisForward
        if math.abs(acceleration) > 0 then
            self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF)
        end
        if spec.cruiseControl.state ~ = Drivable.CRUISECONTROL_STATE_OFF then
            acceleration = 1
        end
    else
            -- allow braking while the engine is turned off
                if self:getIsManualDirectionChangeActive() then
                    if axisForward < 0 then
                        acceleration = axisForward
                    end
                else
                        if self.movingDirection ~ = 0 and math.sign(axisForward) ~ = self.movingDirection then
                            acceleration = axisForward
                        end
                    end
                end

                if not self:getCanMotorRun() then
                    acceleration = math.min(acceleration, 0 )

                    if self:getIsMotorStarted() then
                        self:stopMotor()
                    end
                end

                -- only update steering if a player is in the vehicle
                    if self.getIsControlled ~ = nil and self:getIsControlled() then
                        local targetRotatedTime = 0
                        if self.maxRotTime ~ = nil and self.minRotTime ~ = nil then
                            if axisSide < 0 then
                                -- 0 to maxRotTime
                                targetRotatedTime = math.min( - self.maxRotTime * axisSide, self.maxRotTime)
                            else
                                    -- 0 to minRotTime
                                    targetRotatedTime = math.max( self.minRotTime * axisSide, self.minRotTime)
                                end
                            end

                            self.rotatedTime = targetRotatedTime
                        end

                        if self.finishedFirstUpdate then
                            if self.spec_wheels ~ = nil and # self.spec_wheels.wheels > 0 then
                                -- initial update of wheel physics to skip interpolation of brake pedal -> so we directly got full brakes when on slopes
                                local updateDt = dt
                                if spec.initialWheelPhysicsUpdate then
                                    updateDt = 99999
                                    spec.initialWheelPhysicsUpdate = false
                                end

                                WheelsUtil.updateWheelsPhysics( self , updateDt, self.lastSpeedReal * self.movingDirection, acceleration, doHandbrake, g_currentMission.missionInfo.stopAndGoBraking)
                            end
                        end

                        return acceleration
                    end

```