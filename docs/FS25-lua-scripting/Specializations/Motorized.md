## Motorized

**Description**

> Specialization for all vehicles with motors/engines. Simulates engine, transmission/gears, fuel usage, air brakes

**Functions**

- [actionEventClutch](#actioneventclutch)
- [actionEventDirectionChange](#actioneventdirectionchange)
- [actionEventSelectGear](#actioneventselectgear)
- [actionEventSelectGroup](#actioneventselectgroup)
- [actionEventSetMotorStateIgnition](#actioneventsetmotorstateignition)
- [actionEventSetMotorStateOff](#actioneventsetmotorstateoff)
- [actionEventSetMotorStateOn](#actioneventsetmotorstateon)
- [actionEventShiftGear](#actioneventshiftgear)
- [actionEventShiftGroup](#actioneventshiftgroup)
- [actionEventToggleMotorState](#actioneventtogglemotorstate)
- [addToPhysics](#addtophysics)
- [controlVehicle](#controlvehicle)
- [generateShiftAnimation](#generateshiftanimation)
- [getAirConsumerUsage](#getairconsumerusage)
- [getBrakeForce](#getbrakeforce)
- [getCanBeSelected](#getcanbeselected)
- [getCanMotorRun](#getcanmotorrun)
- [getConsumerFillUnitIndex](#getconsumerfillunitindex)
- [getDeactivateLightsOnLeave](#getdeactivatelightsonleave)
- [getDeactivateOnLeave](#getdeactivateonleave)
- [getDirectionChangeMode](#getdirectionchangemode)
- [getGearInfoToDisplay](#getgearinfotodisplay)
- [getGearShiftMode](#getgearshiftmode)
- [getIsActiveForInteriorLights](#getisactiveforinteriorlights)
- [getIsActiveForWipers](#getisactiveforwipers)
- [getIsDashboardGroupActive](#getisdashboardgroupactive)
- [getIsManualDirectionChangeActive](#getismanualdirectionchangeactive)
- [getIsManualDirectionChangeAllowed](#getismanualdirectionchangeallowed)
- [getIsMotorInNeutral](#getismotorinneutral)
- [getIsMotorStarted](#getismotorstarted)
- [getIsOperating](#getisoperating)
- [getIsPowered](#getispowered)
- [getMotor](#getmotor)
- [getMotorBlowOffValveState](#getmotorblowoffvalvestate)
- [getMotorBrakeTime](#getmotorbraketime)
- [getMotorDifferentialSpeed](#getmotordifferentialspeed)
- [getMotorLoadPercentage](#getmotorloadpercentage)
- [getMotorNotAllowedWarning](#getmotornotallowedwarning)
- [getMotorRpmPercentage](#getmotorrpmpercentage)
- [getMotorRpmReal](#getmotorrpmreal)
- [getMotorStartTime](#getmotorstarttime)
- [getMotorType](#getmotortype)
- [getName](#getname)
- [getSpecValueFuel](#getspecvaluefuel)
- [getSpecValueFuelDiesel](#getspecvaluefueldiesel)
- [getSpecValueFuelElectricCharge](#getspecvaluefuelelectriccharge)
- [getSpecValueFuelMethane](#getspecvaluefuelmethane)
- [getSpecValueMaxSpeed](#getspecvaluemaxspeed)
- [getSpecValuePower](#getspecvaluepower)
- [getSpecValueTransmission](#getspecvaluetransmission)
- [getStopMotorOnLeave](#getstopmotoronleave)
- [getTraveledDistanceStatsActive](#gettraveleddistancestatsactive)
- [getUsageCausesDamage](#getusagecausesdamage)
- [initSpecialization](#initspecialization)
- [loadConsumerConfiguration](#loadconsumerconfiguration)
- [loadDashboardGroupFromXML](#loaddashboardgroupfromxml)
- [loadDifferentials](#loaddifferentials)
- [loadExhaustEffects](#loadexhausteffects)
- [loadGearGroups](#loadgeargroups)
- [loadGears](#loadgears)
- [loadMotor](#loadmotor)
- [loadSounds](#loadsounds)
- [loadSpecValueFuel](#loadspecvaluefuel)
- [loadSpecValueMaxSpeed](#loadspecvaluemaxspeed)
- [loadSpecValuePower](#loadspecvaluepower)
- [loadSpecValueTransmission](#loadspecvaluetransmission)
- [onAIJobFinished](#onaijobfinished)
- [onAIJobStarted](#onaijobstarted)
- [onClutchCreaking](#onclutchcreaking)
- [onDelete](#ondelete)
- [onExhaustEffectI3DLoaded](#onexhausteffecti3dloaded)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onGearChanged](#ongearchanged)
- [onGearDirectionChanged](#ongeardirectionchanged)
- [onGearGroupChanged](#ongeargroupchanged)
- [onLoad](#onload)
- [onMotorBlowOffValveChanged](#onmotorblowoffvalvechanged)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterDashboardValueTypes](#onregisterdashboardvaluetypes)
- [onReverseDirectionChanged](#onreversedirectionchanged)
- [onSetBroken](#onsetbroken)
- [onStateChange](#onstatechange)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onVehicleSettingChanged](#onvehiclesettingchanged)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerConsumerXMLPaths](#registerconsumerxmlpaths)
- [registerDifferentialXMLPaths](#registerdifferentialxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerMotorXMLPaths](#registermotorxmlpaths)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSoundXMLPaths](#registersoundxmlpaths)
- [removeFromPhysics](#removefromphysics)
- [setGearLeversState](#setgearleversstate)
- [setTransmissionDirection](#settransmissiondirection)
- [startMotor](#startmotor)
- [stopMotor](#stopmotor)
- [stopVehicle](#stopvehicle)
- [tryStartMotor](#trystartmotor)
- [updateActionEvents](#updateactionevents)
- [updateConsumers](#updateconsumers)
- [updateMotorProperties](#updatemotorproperties)
- [updateMotorTemperature](#updatemotortemperature)

### actionEventClutch

**Description**

**Definition**

> actionEventClutch()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventClutch( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_motorized
    spec.clutchState = inputValue

    if self.isServer then
        spec.motor:onManualClutchChanged(spec.clutchState)

        if inputValue > 0 then
            self:raiseActive()
        end
    else
            self:raiseDirtyFlags(spec.inputDirtyFlag)
        end
    end

```

### actionEventDirectionChange

**Description**

**Definition**

> actionEventDirectionChange()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventDirectionChange( self , actionName, inputValue, callbackState, isAnalog)
    if actionName = = InputAction.DIRECTION_CHANGE_POS then
        MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_DIRECTION_CHANGE_POS)
    elseif actionName = = InputAction.DIRECTION_CHANGE_NEG then
            MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_DIRECTION_CHANGE_NEG)
        else
                MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_DIRECTION_CHANGE)
            end
        end

```

### actionEventSelectGear

**Description**

**Definition**

> actionEventSelectGear()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventSelectGear( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_motorized
    local gears = spec.motor.currentGears
    if gears ~ = nil then
        for i = 1 , #gears do
            local gear = gears[i]
            if gear.inputAction = = InputAction[actionName] then
                MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SELECT_GEAR, inputValue = = 1 and i or 0 )
                return
            end
        end
    end

    return MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SELECT_GEAR, inputValue = = 1 and callbackState or 0 )
end

```

### actionEventSelectGroup

**Description**

**Definition**

> actionEventSelectGroup()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventSelectGroup( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_motorized
    local groups = spec.motor.gearGroups
    if groups ~ = nil then
        for i = 1 , #groups do
            local group = groups[i]
            if group.inputAction = = InputAction[actionName] then
                MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SELECT_GROUP, inputValue = = 1 and i or 0 )
                return
            end
        end
    end

    return MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SELECT_GROUP, inputValue = = 1 and callbackState or 0 )
end

```

### actionEventSetMotorStateIgnition

**Description**

**Definition**

> actionEventSetMotorStateIgnition()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventSetMotorStateIgnition( self , actionName, inputValue, callbackState, isAnalog)
    if not self:getIsAIActive() then
        local motorState = self:getMotorState()
        if motorState = = MotorState.OFF then
            self:setMotorState(MotorState.IGNITION)
        end
    end
end

```

### actionEventSetMotorStateOff

**Description**

**Definition**

> actionEventSetMotorStateOff()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventSetMotorStateOff( self , actionName, inputValue, callbackState, isAnalog)
    if not self:getIsAIActive() then
        local motorState = self:getMotorState()
        if motorState ~ = MotorState.OFF then
            self:stopMotor()
        end
    end
end

```

### actionEventSetMotorStateOn

**Description**

**Definition**

> actionEventSetMotorStateOn()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventSetMotorStateOn( self , actionName, inputValue, callbackState, isAnalog)
    if not self:getIsAIActive() then
        local motorState = self:getMotorState()
        if motorState = = MotorState.OFF or motorState = = MotorState.IGNITION then
            if self:getCanMotorRun() then
                self:startMotor()
            else
                    local warning = self:getMotorNotAllowedWarning()
                    if warning ~ = nil then
                        g_currentMission:showBlinkingWarning(warning, 2000 )
                    end
                end
            end
        end
    end

```

### actionEventShiftGear

**Description**

**Definition**

> actionEventShiftGear()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventShiftGear( self , actionName, inputValue, callbackState, isAnalog)
    if actionName = = InputAction.SHIFT_GEAR_UP then
        MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SHIFT_UP)
    else
            MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SHIFT_DOWN)
        end
    end

```

### actionEventShiftGroup

**Description**

**Definition**

> actionEventShiftGroup()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventShiftGroup( self , actionName, inputValue, callbackState, isAnalog)
    if actionName = = InputAction.SHIFT_GROUP_UP then
        MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SHIFT_GROUP_UP)
    else
            MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_SHIFT_GROUP_DOWN)
        end
    end

```

### actionEventToggleMotorState

**Description**

**Definition**

> actionEventToggleMotorState()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Motorized.actionEventToggleMotorState( self , actionName, inputValue, callbackState, isAnalog)
    if not self:getIsAIActive() then
        local motorState = self:getMotorState()
        if motorState = = MotorState.STARTING or motorState = = MotorState.ON then
            self:stopMotor()
        else
                if self:getCanMotorRun() then
                    self:startMotor()
                else
                        local warning = self:getMotorNotAllowedWarning()
                        if warning ~ = nil then
                            g_currentMission:showBlinkingWarning(warning, 2000 )
                        end
                    end
                end
            end
        end

```

### addToPhysics

**Description**

> Add to physics

**Definition**

> addToPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Motorized:addToPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    if self.isServer then
        local spec = self.spec_motorized

        if spec.motorizedNode ~ = nil then
            if next(spec.differentials) ~ = nil then

                for _, differential in pairs(spec.differentials) do
                    local diffIndex1 = differential.diffIndex1
                    local diffIndex2 = differential.diffIndex2

                    if differential.diffIndex1IsWheel then
                        diffIndex1 = self:getWheelFromWheelIndex(diffIndex1).physics.wheelShape
                    end
                    if differential.diffIndex2IsWheel then
                        diffIndex2 = self:getWheelFromWheelIndex(diffIndex2).physics.wheelShape
                    end

                    addDifferential( spec.motorizedNode,
                    diffIndex1,
                    differential.diffIndex1IsWheel,
                    diffIndex2,
                    differential.diffIndex2IsWheel,
                    differential.torqueRatio,
                    differential.maxSpeedRatio )
                end

                self:updateMotorProperties()

                self:controlVehicle( 0.0 , 0.0 , 0.0 , 0.0 , math.huge, 0.0 , 0.0 , 0.0 , 0.0 , 0.0 )
            end
        end
    end

    return true
end

```

### controlVehicle

**Description**

> Update the motor properties based on script motor state

**Definition**

> controlVehicle()

**Arguments**

| any | acceleratorPedal        |
|-----|-------------------------|
| any | maxSpeed                |
| any | maxAcceleration         |
| any | minMotorRotSpeed        |
| any | maxMotorRotSpeed        |
| any | maxMotorRotAcceleration |
| any | minGearRatio            |
| any | maxGearRatio            |
| any | maxClutchTorque         |
| any | neededPtoTorque         |

**Code**

```lua
function Motorized:controlVehicle(acceleratorPedal, maxSpeed, maxAcceleration, minMotorRotSpeed, maxMotorRotSpeed, maxMotorRotAcceleration, minGearRatio, maxGearRatio, maxClutchTorque, neededPtoTorque)
    local spec = self.spec_motorized

    controlVehicle(spec.motorizedNode, acceleratorPedal, maxSpeed, maxAcceleration, minMotorRotSpeed, maxMotorRotSpeed, maxMotorRotAcceleration, minGearRatio, maxGearRatio, maxClutchTorque, neededPtoTorque)

    -- wake up the physics if the value change while the motorized node is sleeping to force an update
        local lastParameters = spec.lastControlParameters
        if getIsSleeping(spec.motorizedNode) then
            if acceleratorPedal ~ = lastParameters.acceleratorPedal
                or maxSpeed ~ = lastParameters.maxSpeed
                or maxAcceleration ~ = lastParameters.maxAcceleration
                or minMotorRotSpeed ~ = lastParameters.minMotorRotSpeed
                or maxMotorRotSpeed ~ = lastParameters.maxMotorRotSpeed
                or maxMotorRotAcceleration ~ = lastParameters.maxMotorRotAcceleration
                or minGearRatio ~ = lastParameters.minGearRatio
                or maxGearRatio ~ = lastParameters.maxGearRatio
                or maxClutchTorque ~ = lastParameters.maxClutchTorque
                or neededPtoTorque ~ = lastParameters.neededPtoTorque then
                I3DUtil.wakeUpObject(spec.motorizedNode)
            end
        end

        lastParameters.acceleratorPedal = acceleratorPedal
        lastParameters.maxSpeed = maxSpeed
        lastParameters.maxAcceleration = maxAcceleration
        lastParameters.minMotorRotSpeed = minMotorRotSpeed
        lastParameters.maxMotorRotSpeed = maxMotorRotSpeed
        lastParameters.maxMotorRotAcceleration = maxMotorRotAcceleration
        lastParameters.minGearRatio = minGearRatio
        lastParameters.maxGearRatio = maxGearRatio
        lastParameters.maxClutchTorque = maxClutchTorque
        lastParameters.neededPtoTorque = neededPtoTorque
    end

```

### generateShiftAnimation

**Description**

**Definition**

> generateShiftAnimation()

**Arguments**

| any | gearLever       |
|-----|-----------------|
| any | state           |
| any | time            |
| any | isResetPosition |

**Code**

```lua
function Motorized:generateShiftAnimation(gearLever, state, time , isResetPosition)
    local gearLeverInterpolator = { }
    gearLeverInterpolator.interpolations = { }

    state.curRotation[ 1 ], state.curRotation[ 2 ], state.curRotation[ 3 ] = getRotation(gearLever.node)

    -- check if the current rotation is already the target rotation
        local requiresChange = false
        for axis = 1 , 3 do
            if math.abs(state.curRotation[axis] - state.rotation[axis]) > 0.00001 then
                requiresChange = true
                break
            end
        end

        -- check if the current target direction is already the target direction
            local alreadyMovingToTarget = true
            for axis = 1 , 3 do
                if math.abs(gearLever.curTarget[axis] - state.rotation[axis]) > 0.00001 then
                    alreadyMovingToTarget = false
                    break
                end
            end

            if not requiresChange or alreadyMovingToTarget then
                return false
            end

            gearLever.curTarget[ 1 ], gearLever.curTarget[ 2 ], gearLever.curTarget[ 3 ] = state.curRotation[ 1 ], state.curRotation[ 2 ], state.curRotation[ 3 ]

            local requiresMoveToCenter = false
            if gearLever.centerAxis ~ = nil then
                local curCenter = state.curRotation[gearLever.centerAxis]
                local tarCenter = state.rotation[gearLever.centerAxis]
                requiresMoveToCenter = math.abs(curCenter - tarCenter) > 0.00001
            end

            -- move to center on non center axis
            if requiresMoveToCenter then
                for axis = 1 , 3 do
                    if axis ~ = gearLever.centerAxis then
                        local cur = state.curRotation[axis]
                        local tar = state.rotation[axis]
                        if gearLever.centerAxis ~ = nil then
                            tar = 0
                        end

                        local allowed = math.abs(cur - tar) > 0.00001
                        local goToCenter = false
                        if gearLever.centerAxis ~ = nil and not allowed then
                            allowed = state.useRotation[axis] and math.abs(state.curRotation[gearLever.centerAxis] - state.rotation[gearLever.centerAxis]) > 0.00001
                            goToCenter = allowed
                        end

                        if allowed then
                            table.insert(gearLeverInterpolator.interpolations, { axis = axis, cur = cur, tar = (goToCenter and 0 or tar) } )
                            gearLever.curTarget[axis] = tar
                        end
                    end
                end
            end

            if gearLever.centerAxis ~ = nil then
                -- align center axis to new state
                if requiresMoveToCenter then
                    local curCenter = state.curRotation[gearLever.centerAxis]
                    local tarCenter = state.rotation[gearLever.centerAxis]
                    table.insert(gearLeverInterpolator.interpolations, { axis = gearLever.centerAxis, cur = curCenter, tar = tarCenter } )
                    gearLever.curTarget[gearLever.centerAxis] = tarCenter
                end

                -- move non center axis to final position
                for axis = 1 , 3 do
                    if axis ~ = gearLever.centerAxis then
                        local cur = state.curRotation[axis]
                        local tar = state.rotation[axis]
                        local allowed = math.abs(cur - tar) > 0.00001
                        if gearLever.centerAxis ~ = nil and not allowed then
                            allowed = state.useRotation[axis] and math.abs(state.curRotation[gearLever.centerAxis] - state.rotation[gearLever.centerAxis]) > 0.00001
                        end

                        if allowed then
                            table.insert(gearLeverInterpolator.interpolations, { axis = axis, cur = requiresMoveToCenter and 0 or cur, tar = tar } )
                            gearLever.curTarget[axis] = tar
                        end
                    end
                end
            end

            for intState, _ in pairs( self.spec_motorized.activeGearLeverInterpolators) do
                if intState.gearLever = = state.gearLever then
                    self.spec_motorized.activeGearLeverInterpolators[intState] = nil
                end
            end

            if self.spec_motorized.activeGearLeverInterpolators[state] = = nil then
                local numInterpolations = #gearLeverInterpolator.interpolations
                if numInterpolations > 0 then
                    local timePerInterpolation = math.max(gearLever.changeTime, 0.001 ) / numInterpolations

                    for ii = 1 , numInterpolations do
                        local interpolation = gearLeverInterpolator.interpolations[ii]
                        interpolation.speed = (interpolation.tar - interpolation.cur) / timePerInterpolation
                    end

                    gearLeverInterpolator.currentInterpolation = 1
                    gearLeverInterpolator.isResetPosition = (isResetPosition = = nil or isResetPosition = = true )
                    gearLeverInterpolator.handsOnDelay = gearLever.handsOnDelay
                    gearLeverInterpolator.isGear = state.gear ~ = nil
                    self.spec_motorized.activeGearLeverInterpolators[state] = gearLeverInterpolator
                end
            end

            return true
        end

```

### getAirConsumerUsage

**Description**

**Definition**

> getAirConsumerUsage()

**Code**

```lua
function Motorized:getAirConsumerUsage()
    local spec = self.spec_motorized
    local consumer = spec.consumersByFillTypeName[ "AIR" ]
    return(consumer and consumer.usage) or 0
end

```

### getBrakeForce

**Description**

**Definition**

> getBrakeForce()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:getBrakeForce(superFunc)
    local brakeForce = superFunc( self )

    local motorBrakeForce

    local spec = self.spec_motorized
    if spec.maxBrakeForceMass > 0 then
        local mass = self:getTotalMass( not spec.maxBrakeForceMassIncludeAttachables)
        local percentage = math.min( math.max((mass - self.defaultMass) / (spec.maxBrakeForceMass - self.defaultMass), 0 ), 1 )
        motorBrakeForce = math.max( MathUtil.lerp(spec.minBrakeForce, spec.maxBrakeForce, percentage), brakeForce)
    else
            motorBrakeForce = self.spec_motorized.motor:getBrakeForce()
        end

        return math.max(brakeForce, motorBrakeForce)
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
function Motorized:getCanBeSelected(superFunc)
    local missionInfo = g_currentMission.missionInfo
    -- if automatic motor start is disabled we need to choose which vehicle we need to turn on/off
        if not missionInfo.automaticMotorStartEnabled then
            local vehicles = self.rootVehicle:getChildVehicles()
            for _, vehicle in pairs(vehicles) do
                if vehicle.spec_motorized ~ = nil then
                    return true
                end
            end
        end

        return superFunc( self )
    end

```

### getCanMotorRun

**Description**

**Definition**

> getCanMotorRun()

**Code**

```lua
function Motorized:getCanMotorRun()
    local spec = self.spec_motorized

    for _, fillUnitIndex in ipairs(spec.propellantFillUnitIndices) do
        if self:getFillUnitFillLevel(fillUnitIndex) = = 0 then
            return false
        end
    end

    if not spec.motor:getCanMotorRun() then
        return false
    end

    return true
end

```

### getConsumerFillUnitIndex

**Description**

**Definition**

> getConsumerFillUnitIndex()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|

**Code**

```lua
function Motorized:getConsumerFillUnitIndex(fillTypeIndex)
    local spec = self.spec_motorized
    local consumer = spec.consumersByFillType[fillTypeIndex]
    if consumer ~ = nil then
        return consumer.fillUnitIndex
    end

    return nil
end

```

### getDeactivateLightsOnLeave

**Description**

> Returns if vehicle deactivates lights on leave

**Definition**

> getDeactivateLightsOnLeave()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | deactivate | vehicle deactivates on leave |
|-----|------------|------------------------------|

**Code**

```lua
function Motorized:getDeactivateLightsOnLeave(superFunc)
    local missionInfo = g_currentMission.missionInfo
    return superFunc( self ) and missionInfo.automaticMotorStartEnabled and not self:getRequiresPower()
end

```

### getDeactivateOnLeave

**Description**

> Returns if vehicle deactivates on leave

**Definition**

> getDeactivateOnLeave()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | deactivate | vehicle deactivates on leave |
|-----|------------|------------------------------|

**Code**

```lua
function Motorized:getDeactivateOnLeave(superFunc)
    local missionInfo = g_currentMission.missionInfo
    return superFunc( self ) and missionInfo.automaticMotorStartEnabled
end

```

### getDirectionChangeMode

**Description**

> Returns current direction change mode for vehicle

**Definition**

> getDirectionChangeMode()

**Return Values**

| any | direction | change mode [1: auto, 2: manual] |
|-----|-----------|----------------------------------|

**Code**

```lua
function Motorized:getDirectionChangeMode()
    return self.spec_motorized.directionChangeMode
end

```

### getGearInfoToDisplay

**Description**

> Returns gear information to display

**Definition**

> getGearInfoToDisplay()

**Return Values**

| any | gear      | gear name to display       |
|-----|-----------|----------------------------|
| any | gearGroup | gear group name to display |

**Code**

```lua
function Motorized:getGearInfoToDisplay()
    local gear, gearGroup, gearsAvailable, groupsAvailable
    local isAutomatic, prevGearName, nextGearName, prevPrevGearName, nextNextGearName, isGearChanging
    local showNeutralWarning = false

    local motor = self.spec_motorized.motor
    if motor ~ = nil then
        gear, gearsAvailable, isAutomatic, prevGearName, nextGearName, prevPrevGearName, nextNextGearName, isGearChanging = motor:getGearInfoToDisplay()

        gearGroup, groupsAvailable = motor:getGearGroupToDisplay()
        if not groupsAvailable then
            gearGroup = nil
        end

        if self.getAcDecelerationAxis ~ = nil then
            if math.abs( self:getAcDecelerationAxis()) > 0 then
                showNeutralWarning = self:getIsMotorInNeutral()
            end
        end
    end

    return gear, gearGroup, gearsAvailable, isAutomatic, prevGearName, nextGearName, prevPrevGearName, nextNextGearName, isGearChanging, showNeutralWarning
end

```

### getGearShiftMode

**Description**

> Returns current gear shift mode for vehicle

**Definition**

> getGearShiftMode()

**Return Values**

| any | gear | shift mode [1: auto, 2: manual, 3: manual with clutch] |
|-----|------|--------------------------------------------------------|

**Code**

```lua
function Motorized:getGearShiftMode()
    return self.spec_motorized.gearShiftMode
end

```

### getIsActiveForInteriorLights

**Description**

**Definition**

> getIsActiveForInteriorLights()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:getIsActiveForInteriorLights(superFunc)
    local state = self:getMotorState()
    if state = = MotorState.IGNITION or state = = MotorState.STARTING or state = = MotorState.ON then
        return true
    end

    return superFunc( self )
end

```

### getIsActiveForWipers

**Description**

**Definition**

> getIsActiveForWipers()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:getIsActiveForWipers(superFunc)
    local state = self:getMotorState()
    if state = = MotorState.OFF then
        return false
    end

    return superFunc( self )
end

```

### getIsDashboardGroupActive

**Description**

**Definition**

> getIsDashboardGroupActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | group     |

**Code**

```lua
function Motorized:getIsDashboardGroupActive(superFunc, group)
    local motorState = self:getMotorState()

    -- while running and starting
        if group.isMotorRunning and group.isMotorStarting then
            if motorState ~ = MotorState.STARTING and motorState ~ = MotorState.ON then
                return false
            end
        end

        -- only while starting
            if group.isMotorStarting and not group.isMotorRunning then
                if motorState ~ = MotorState.STARTING then
                    return false
                end
            end

            -- only while running
                if group.isMotorRunning and not group.isMotorStarting then
                    if motorState ~ = MotorState.ON then
                        return false
                    end
                end

                if group.electronicsStarting and group.electronicsRunning then
                    if self.spec_motorized.motorStateIgnitionTime = = 0 then
                        return false
                    end
                elseif group.electronicsStarting then
                        local spec = self.spec_motorized
                        if spec.motorStateIgnitionTime = = 0 or g_currentMission.time - spec.motorStateIgnitionTime > group.electronicsStartingTime then
                            return false
                        end
                    elseif group.electronicsRunning then
                            local spec = self.spec_motorized
                            if spec.motorStateIgnitionTime = = 0 or g_currentMission.time - spec.motorStateIgnitionTime < group.electronicsStartingTime then
                                return false
                            end
                        end

                        return superFunc( self , group)
                    end

```

### getIsManualDirectionChangeActive

**Description**

> Returns if the manual direction change is currently active

**Definition**

> getIsManualDirectionChangeActive()

**Return Values**

| any | isActive | isActive |
|-----|----------|----------|

**Code**

```lua
function Motorized:getIsManualDirectionChangeActive()
    local motor = self.spec_motorized.motor
    local isManualTransmission = motor.backwardGears ~ = nil or motor.forwardGears ~ = nil
    local useManualDirectionChange = (isManualTransmission and motor.gearShiftMode ~ = VehicleMotor.SHIFT_MODE_AUTOMATIC)
    or motor.directionChangeMode = = VehicleMotor.DIRECTION_CHANGE_MODE_MANUAL

    return useManualDirectionChange and self:getIsManualDirectionChangeAllowed()
end

```

### getIsManualDirectionChangeAllowed

**Description**

> Returns if the manual direction change is currently allowed

**Definition**

> getIsManualDirectionChangeAllowed()

**Return Values**

| any | isAllowed | isAllowed |
|-----|-----------|-----------|

**Code**

```lua
function Motorized:getIsManualDirectionChangeAllowed()
    return not self:getIsAIActive()
end

```

### getIsMotorInNeutral

**Description**

> Returns if motor is in neutral state

**Definition**

> getIsMotorInNeutral()

**Return Values**

| any | isNeutral | is neutral |
|-----|-----------|------------|

**Code**

```lua
function Motorized:getIsMotorInNeutral()
    return self.spec_motorized.motor:getIsInNeutral()
end

```

### getIsMotorStarted

**Description**

> Returns if motor is started

**Definition**

> getIsMotorStarted()

**Return Values**

| any | if | motor is started |
|-----|----|------------------|

**Code**

```lua
function Motorized:getIsMotorStarted()
    return self.spec_motorized.motorState = = MotorState.ON
end

```

### getIsOperating

**Description**

> Returns if vehicle is operating

**Definition**

> getIsOperating()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | isOperating | is operating |
|-----|-------------|--------------|

**Code**

```lua
function Motorized:getIsOperating(superFunc)
    local motorState = self:getMotorState()
    return superFunc( self ) or motorState = = MotorState.ON
end

```

### getIsPowered

**Description**

**Definition**

> getIsPowered()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:getIsPowered(superFunc)
    local ret = superFunc( self )
    if ret then
        local motorState = self:getMotorState()
        if motorState ~ = MotorState.STARTING and motorState ~ = MotorState.ON then
            local vehicles = self.rootVehicle:getChildVehicles()
            for _, vehicle in pairs(vehicles) do
                if vehicle ~ = self then
                    if vehicle.getMotorState ~ = nil then
                        local vehicleMotorState = vehicle:getMotorState()
                        if vehicleMotorState = = MotorState.STARTING or vehicleMotorState = = MotorState.ON then
                            return true
                        end
                    end
                end
            end

            if self:getCanMotorRun() then
                return false , g_i18n:getText( "warning_motorNotStarted" )
            else
                    return false , self:getMotorNotAllowedWarning()
                end
            end
        end

        return ret
    end

```

### getMotor

**Description**

**Definition**

> getMotor()

**Code**

```lua
function Motorized:getMotor()
    return self.spec_motorized.motor
end

```

### getMotorBlowOffValveState

**Description**

**Definition**

> getMotorBlowOffValveState()

**Code**

```lua
function Motorized:getMotorBlowOffValveState()
    return self.spec_motorized.blowOffValveState
end

```

### getMotorBrakeTime

**Description**

**Definition**

> getMotorBrakeTime()

**Code**

```lua
function Motorized:getMotorBrakeTime()
    local sample = self.spec_motorized.samples.compressedAir
    if sample ~ = nil then
        return sample.lastBrakeTime / 1000
    end

    return 0
end

```

### getMotorDifferentialSpeed

**Description**

**Definition**

> getMotorDifferentialSpeed()

**Code**

```lua
function Motorized:getMotorDifferentialSpeed()
    if self.spec_motorized = = nil then
        Logging.error( "Sound modifier 'DIFFERENTIAL_SPEED' used on non motorized vehicle '%s'" , self.configFileName)
        return 0
    end
    return math.abs( self.spec_motorized.motor.differentialRotSpeed * 3.6 )
end

```

### getMotorLoadPercentage

**Description**

**Definition**

> getMotorLoadPercentage()

**Code**

```lua
function Motorized:getMotorLoadPercentage()
    return self.spec_motorized.smoothedLoadPercentage
end

```

### getMotorNotAllowedWarning

**Description**

**Definition**

> getMotorNotAllowedWarning()

**Code**

```lua
function Motorized:getMotorNotAllowedWarning()
    local spec = self.spec_motorized

    for _, fillUnit in pairs(spec.propellantFillUnitIndices) do
        if self:getFillUnitFillLevel(fillUnit) = = 0 then
            return spec.consumersEmptyWarning
        end
    end

    local canMotorRun, reason = spec.motor:getCanMotorRun()
    if not canMotorRun then
        if reason = = VehicleMotor.REASON_CLUTCH_NOT_ENGAGED then
            return spec.clutchNoEngagedWarning
        end
    end

    return nil
end

```

### getMotorRpmPercentage

**Description**

**Definition**

> getMotorRpmPercentage()

**Code**

```lua
function Motorized:getMotorRpmPercentage()
    local motor = self.spec_motorized.motor
    return(motor:getLastModulatedMotorRpm() - motor:getMinRpm()) / (motor:getMaxRpm() - motor:getMinRpm())
end

```

### getMotorRpmReal

**Description**

**Definition**

> getMotorRpmReal()

**Code**

```lua
function Motorized:getMotorRpmReal()
    return self.spec_motorized.motor:getLastModulatedMotorRpm()
end

```

### getMotorStartTime

**Description**

**Definition**

> getMotorStartTime()

**Code**

```lua
function Motorized:getMotorStartTime()
    return self.spec_motorized.motorStartTime
end

```

### getMotorType

**Description**

**Definition**

> getMotorType()

**Code**

```lua
function Motorized:getMotorType()
    return self.spec_motorized.motorType
end

```

### getName

**Description**

**Definition**

> getName()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:getName(superFunc)
    if self.spec_motorized.vehicleName ~ = nil then
        return self.spec_motorized.vehicleName
    end

    return superFunc( self )
end

```

### getSpecValueFuel

**Description**

**Definition**

> getSpecValueFuel()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | fillTypeFilter |
| any | returnValue    |

**Code**

```lua
function Motorized.getSpecValueFuel(storeItem, realItem, configurations, fillTypeFilter, returnValue)
    local consumerIndex = 1
    if realItem ~ = nil and storeItem.configurations ~ = nil and realItem.configurations[ "motor" ] ~ = nil and storeItem.configurations[ "motor" ] ~ = nil then
        local motorConfigId = realItem.configurations[ "motor" ]
        consumerIndex = Utils.getNoNil(storeItem.configurations[ "motor" ][motorConfigId].consumerConfigurationIndex, consumerIndex)
    elseif configurations ~ = nil then
            local motorConfigId = configurations[ "motor" ]
            if motorConfigId ~ = nil then
                consumerIndex = Utils.getNoNil(storeItem.configurations[ "motor" ][motorConfigId].consumerConfigurationIndex, consumerIndex)
            end
        end

        local fuel, def, electricCharge, methane

        local fuelFillUnitIndex, defFillUnitIndex, electricFillUnitIndex, methaneFillUnitIndex = 0 , 0 , 0 , 0

        --#debug if storeItem.specs.fuel = = nil then printCallstack() end

        local consumerConfiguration = storeItem.specs.fuel and storeItem.specs.fuel.consumers[consumerIndex]
        if consumerConfiguration ~ = nil then
            for _, unitConsumers in ipairs(consumerConfiguration) do
                local fillType = g_fillTypeManager:getFillTypeIndexByName(unitConsumers.fillType)

                if fillTypeFilter = = nil or fillType = = fillTypeFilter then
                    if fillType = = FillType.DIESEL then
                        fuelFillUnitIndex = unitConsumers.fillUnitIndex
                        fuel = unitConsumers.capacity

                        if fillType = = FillType.DEF then
                            defFillUnitIndex = unitConsumers.fillUnitIndex
                            def = unitConsumers.capacity
                        end
                    elseif fillType = = FillType.DEF then
                            defFillUnitIndex = unitConsumers.fillUnitIndex
                            def = unitConsumers.capacity
                        elseif fillType = = FillType.ELECTRICCHARGE then
                                electricFillUnitIndex = unitConsumers.fillUnitIndex
                                electricCharge = unitConsumers.capacity
                            elseif fillType = = FillType.METHANE then
                                    methaneFillUnitIndex = unitConsumers.fillUnitIndex
                                    methane = unitConsumers.capacity
                                end
                            end
                        end
                    end

                    local fuelConfigIndex = 1
                    if realItem ~ = nil and storeItem.configurations ~ = nil and realItem.configurations[ "fillUnit" ] ~ = nil and storeItem.configurations[ "fillUnit" ] ~ = nil then
                        fuelConfigIndex = realItem.configurations[ "fillUnit" ]
                    end

                    if storeItem.specs.fuel and storeItem.specs.fuel.fillUnits[fuelConfigIndex] ~ = nil then
                        if realItem ~ = nil and realItem.getFillUnitCapacity ~ = nil then
                            if fuelFillUnitIndex ~ = 0 then
                                fuel = realItem:getFillUnitCapacity(fuelFillUnitIndex)
                            end

                            if defFillUnitIndex ~ = 0 then
                                def = realItem:getFillUnitCapacity(defFillUnitIndex)
                            end

                            if electricFillUnitIndex ~ = 0 then
                                electricCharge = realItem:getFillUnitCapacity(electricFillUnitIndex)
                            end

                            if methaneFillUnitIndex ~ = 0 then
                                methane = realItem:getFillUnitCapacity(methaneFillUnitIndex)
                            end
                        else
                                local fuelFillUnit = storeItem.specs.fuel.fillUnits[fuelConfigIndex][fuelFillUnitIndex]
                                if fuelFillUnit ~ = nil and fuel = = nil then
                                    fuel = math.max(fuelFillUnit.capacity, fuel or 0 )
                                end

                                local defFillUnit = storeItem.specs.fuel.fillUnits[fuelConfigIndex][defFillUnitIndex]
                                if defFillUnit ~ = nil and def = = nil then
                                    def = math.max(defFillUnit.capacity, def or 0 )
                                end

                                local electricFillUnit = storeItem.specs.fuel.fillUnits[fuelConfigIndex][electricFillUnitIndex]
                                if electricFillUnit ~ = nil and electricCharge = = nil then
                                    electricCharge = math.max(electricFillUnit.capacity, electricCharge or 0 )
                                end

                                local methaneFillUnit = storeItem.specs.fuel.fillUnits[fuelConfigIndex][methaneFillUnitIndex]
                                if methaneFillUnit ~ = nil and methane = = nil then
                                    methane = math.max(methaneFillUnit.capacity, methane or 0 )
                                end
                            end
                        end

                        if returnValue then
                            if fillTypeFilter = = FillType.DIESEL or fillTypeFilter = = nil then
                                return fuel
                            elseif fillTypeFilter = = FillType.DEF then
                                    return def
                                elseif fillTypeFilter = = FillType.ELECTRICCHARGE then
                                        return electricCharge
                                    elseif fillTypeFilter = = FillType.METHANE then
                                            return methane
                                        else
                                                return 0
                                            end
                                        end

                                        if fuel ~ = nil then
                                            if def ~ = nil and def > 0 then
                                                return string.format(g_i18n:getText( "shop_fuelDefValue" ), fuel, g_i18n:getText( "unit_literShort" ), def, g_i18n:getText( "unit_literShort" ), g_i18n:getText( "fillType_def_short" ))
                                            else
                                                    return string.format(g_i18n:getText( "shop_fuelValue" ), fuel, g_i18n:getText( "unit_literShort" ))
                                                end
                                            elseif electricCharge ~ = nil then
                                                    return string.format(g_i18n:getText( "shop_fuelValue" ), electricCharge, g_i18n:getText( "unit_kw" ))
                                                elseif methane ~ = nil then
                                                        return string.format(g_i18n:getText( "shop_fuelValue" ), methane, g_i18n:getText( "unit_kg" ))
                                                    end

                                                    return nil
                                                end

```

### getSpecValueFuelDiesel

**Description**

**Definition**

> getSpecValueFuelDiesel()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |

**Code**

```lua
function Motorized.getSpecValueFuelDiesel(storeItem, realItem, configurations)
    return Motorized.getSpecValueFuel(storeItem, realItem, configurations, FillType.DIESEL)
end

```

### getSpecValueFuelElectricCharge

**Description**

**Definition**

> getSpecValueFuelElectricCharge()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |

**Code**

```lua
function Motorized.getSpecValueFuelElectricCharge(storeItem, realItem, configurations)
    return Motorized.getSpecValueFuel(storeItem, realItem, configurations, FillType.ELECTRICCHARGE)
end

```

### getSpecValueFuelMethane

**Description**

**Definition**

> getSpecValueFuelMethane()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |

**Code**

```lua
function Motorized.getSpecValueFuelMethane(storeItem, realItem, configurations)
    return Motorized.getSpecValueFuel(storeItem, realItem, configurations, FillType.METHANE)
end

```

### getSpecValueMaxSpeed

**Description**

**Definition**

> getSpecValueMaxSpeed()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Motorized.getSpecValueMaxSpeed(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    local maxSpeed = nil

    if realItem ~ = nil and storeItem.configurations ~ = nil then
        if realItem.configurations[ "motor" ] ~ = nil and storeItem.configurations[ "motor" ] ~ = nil then
            local configId = realItem.configurations[ "motor" ]
            maxSpeed = Utils.getNoNil(storeItem.configurations[ "motor" ][configId].maxSpeed, maxSpeed)
        end

        if realItem.configurations[ "wheel" ] ~ = nil and storeItem.configurations[ "wheel" ] ~ = nil then
            local configId = realItem.configurations[ "wheel" ]
            maxSpeed = Utils.getNoNil(storeItem.configurations[ "wheel" ][configId].maxForwardSpeedShop, maxSpeed)
        end
    end

    if maxSpeed = = nil then
        maxSpeed = storeItem.specs.maxSpeed
    end

    if maxSpeed ~ = nil then
        if returnValues then
            return MathUtil.round(maxSpeed)
        else
                return string.format(g_i18n:getText( "shop_maxSpeed" ), string.format( "%1d" , g_i18n:getSpeed(maxSpeed)), g_i18n:getSpeedMeasuringUnit())
            end
        end

        return nil
    end

```

### getSpecValuePower

**Description**

**Definition**

> getSpecValuePower()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Motorized.getSpecValuePower(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    local minPower = nil
    local maxPower = nil
    if realItem ~ = nil and storeItem.configurations ~ = nil and realItem.configurations[ "motor" ] ~ = nil and storeItem.configurations[ "motor" ] ~ = nil then
        local configId = realItem.configurations[ "motor" ]
        minPower = storeItem.configurations[ "motor" ][configId].power
        maxPower = minPower
    elseif realItem = = nil and storeItem.configurations ~ = nil and storeItem.configurations[ "motor" ] ~ = nil then
            for _, configItem in ipairs(storeItem.configurations[ "motor" ]) do
                if configItem.isSelectable and configItem.power ~ = nil then
                    minPower = math.min(minPower or math.huge, configItem.power)
                    maxPower = math.max(maxPower or 0 , configItem.power)
                end
            end
        end

        if minPower = = nil then
            minPower = storeItem.specs.power
            maxPower = minPower
        end

        if minPower ~ = nil then
            if returnValues = = nil or returnValues = = false then
                if minPower ~ = maxPower then
                    return string.format(g_i18n:getText( "shop_maxPowerValueRange" ), MathUtil.round(minPower), MathUtil.round(maxPower))
                else
                        return string.format(g_i18n:getText( "shop_maxPowerValueSingle" ), MathUtil.round(minPower))
                    end
                else
                        return MathUtil.round(minPower), MathUtil.round(maxPower)
                    end
                end

                return nil
            end

```

### getSpecValueTransmission

**Description**

**Definition**

> getSpecValueTransmission()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function Motorized.getSpecValueTransmission(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    local name
    if realItem ~ = nil and storeItem.configurations ~ = nil and realItem.configurations[ "motor" ] ~ = nil and storeItem.configurations[ "motor" ] ~ = nil then
        name = storeItem.specs.transmission[realItem.configurations[ "motor" ]]
        if name = = nil then
            name = storeItem.specs.transmission[ 1 ]
        end
    else
            name = storeItem.specs.transmission[ 1 ]
        end

        return name
    end

```

### getStopMotorOnLeave

**Description**

**Definition**

> getStopMotorOnLeave()

**Code**

```lua
function Motorized:getStopMotorOnLeave()
    return self.spec_motorized.stopMotorOnLeave and not self:getRequiresPower()
end

```

### getTraveledDistanceStatsActive

**Description**

**Definition**

> getTraveledDistanceStatsActive()

**Code**

```lua
function Motorized:getTraveledDistanceStatsActive()
    return true
end

```

### getUsageCausesDamage

**Description**

**Definition**

> getUsageCausesDamage()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:getUsageCausesDamage(superFunc)
    local motorState = self:getMotorState()
    if motorState ~ = MotorState.STARTING and motorState ~ = MotorState.ON then
        return false
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Motorized.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "motor" , g_i18n:getText( "configuration_motorSetup" ), "motorized" , VehicleConfigurationItemMotor , nil , nil , nil , 1 )

    g_storeManager:addSpecType( "fuel" , "shopListAttributeIconFuel" , Motorized.loadSpecValueFuel, Motorized.getSpecValueFuelDiesel, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "electricCharge" , "shopListAttributeIconElectricCharge" , Motorized.loadSpecValueFuel, Motorized.getSpecValueFuelElectricCharge, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "methane" , "shopListAttributeIconMethane" , Motorized.loadSpecValueFuel, Motorized.getSpecValueFuelMethane, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "maxSpeed" , "shopListAttributeIconMaxSpeed" , Motorized.loadSpecValueMaxSpeed, Motorized.getSpecValueMaxSpeed, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "power" , "shopListAttributeIconPower" , Motorized.loadSpecValuePower, Motorized.getSpecValuePower, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "powerConfig" , "shopListAttributeIconPower" , Motorized.loadSpecValuePowerConfig, Motorized.getSpecValuePowerConfig, StoreSpecies.VEHICLE) -- used for export only
        g_storeManager:addSpecType( "transmission" , "shopListAttributeIconTransmission" , Motorized.loadSpecValueTransmission, Motorized.getSpecValueTransmission, StoreSpecies.VEHICLE)

        local schema = Vehicle.xmlSchema
        schema:setXMLSpecializationType( "Motorized" )

        Motorized.registerDifferentialXMLPaths(schema, "vehicle.motorized.differentialConfigurations.differentialConfiguration(?)" )
        Motorized.registerDifferentialXMLPaths(schema, "vehicle.motorized.differentials" )

        Motorized.registerMotorXMLPaths(schema, "vehicle.motorized.motorConfigurations.motorConfiguration(?)" )

        Motorized.registerConsumerXMLPaths(schema, "vehicle.motorized.consumerConfigurations.consumerConfiguration(?)" )
        Motorized.registerConsumerXMLPaths(schema, "vehicle.motorized.consumers" )

        Motorized.registerSoundXMLPaths(schema, "vehicle.motorized.sounds" )
        Motorized.registerSoundXMLPaths(schema, "vehicle.motorized.motorConfigurations.motorConfiguration(?).sounds" )

        schema:register(XMLValueType.FLOAT, "vehicle.motorized.reverseDriveSound#threshold" , "Reverse drive sound turn on speed threshold" , 4 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.brakeCompressor#capacity" , "Brake compressor capacity" , 6 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.brakeCompressor#refillFillLevel" , "Brake compressor refill threshold" , "half of capacity" )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.brakeCompressor#fillSpeed" , "Brake compressor fill speed" , 0.6 )

        ParticleUtil.registerParticleXMLPaths(schema, "vehicle.motorized.exhaustParticleSystems" , "exhaustParticleSystem(?)" )

        schema:register(XMLValueType.FLOAT, "vehicle.motorized.exhaustParticleSystems#minScale" , "Min.scale" , 0.5 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.exhaustParticleSystems#maxScale" , "Max.scale" , 1 )

        schema:register(XMLValueType.NODE_INDEX, "vehicle.motorized.exhaustFlap(?)#node" , "Exhaust Flap Node" )
        schema:register(XMLValueType.ANGLE, "vehicle.motorized.exhaustFlap(?)#maxRot" , "Max.rotation" , 0 )
        schema:register(XMLValueType.INT, "vehicle.motorized.exhaustFlap(?)#rotationAxis" , "Rotation Axis" , 1 )

        schema:register(XMLValueType.NODE_INDEX, "vehicle.motorized.exhaustEffects.exhaustEffect(?)#node" , "Effect link node" )
        schema:register(XMLValueType.STRING, "vehicle.motorized.exhaustEffects.exhaustEffect(?)#filename" , "Effect i3d filename" )

        schema:register(XMLValueType.VECTOR_ 4 , "vehicle.motorized.exhaustEffects.exhaustEffect(?)#minRpmColor" , "Min.rpm color" , "0 0 0 1" )
        schema:register(XMLValueType.VECTOR_ 4 , "vehicle.motorized.exhaustEffects.exhaustEffect(?)#maxRpmColor" , "Max.rpm color" , "0.0384 0.0359 0.0627 2.0" )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.exhaustEffects.exhaustEffect(?)#minRpmScale" , "Min.rpm scale" , 0.25 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.exhaustEffects.exhaustEffect(?)#maxRpmScale" , "Max.rpm scale" , 0.95 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.exhaustEffects.exhaustEffect(?)#upFactor" , "Defines how far the effect goes up in the air in meter" , 0.75 )

        EffectManager.registerEffectXMLPaths(schema, "vehicle.motorized.effects" )

        schema:register(XMLValueType.FLOAT, "vehicle.motorized.motorStartDuration" , "Motor start duration" , "Duration motor takes to start.After this time player can start to drive" )

        schema:register(XMLValueType.FLOAT, "vehicle.motorized.brakeForce#force" , "Brake force when vehicle is empty" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.brakeForce#maxForce" , "Brake force when vehicle reached mass of #maxForceMass" , 0 )
        schema:register(XMLValueType.FLOAT, "vehicle.motorized.brakeForce#maxForceMass" , "When this mass is reached the vehicle will brake with #maxForce" , 0 )
        schema:register(XMLValueType.BOOL, "vehicle.motorized.brakeForce#includeAttachables" , "Defines if the mass of the attached vehicles is included in the calculations" , false )

            schema:register(XMLValueType.L10N_STRING, "vehicle.motorized#clutchNoEngagedWarning" , "Warning to be displayed if try to start the engine but clutch not engaged" , "warning_motorClutchNoEngaged" )
                schema:register(XMLValueType.L10N_STRING, "vehicle.motorized#clutchCrackingGearWarning" , "Warning to be display if user tries to select a gear without pressing clutch pedal" , "action_clutchCrackingGear" )
                    schema:register(XMLValueType.L10N_STRING, "vehicle.motorized#clutchCrackingGroupWarning" , "Warning to be display if user tries to select a gear without pressing clutch pedal" , "action_clutchCrackingGroup" )

                        schema:register(XMLValueType.L10N_STRING, "vehicle.motorized#turnOnText" , "Motor start text" , "action_startMotor" )
                        schema:register(XMLValueType.L10N_STRING, "vehicle.motorized#turnOffText" , "Motor stop text" , "action_stopMotor" )

                        schema:register(XMLValueType.NODE_INDEX, "vehicle.motorized.gearLevers.gearLever(?)#node" , "Gear lever node" )
                        schema:register(XMLValueType.INT, "vehicle.motorized.gearLevers.gearLever(?)#centerAxis" , "Axis of center bay" )
                        schema:register(XMLValueType.TIME, "vehicle.motorized.gearLevers.gearLever(?)#changeTime" , "Time to move lever from one state to another" , 0.5 )
                        schema:register(XMLValueType.TIME, "vehicle.motorized.gearLevers.gearLever(?)#handsOnDelay" , "The animation is delayed by this time to have time to put the hand on the lever" , 0 )
                        schema:register(XMLValueType.INT, "vehicle.motorized.gearLevers.gearLever(?).state(?)#gear" , "Gear index" )
                        schema:register(XMLValueType.INT, "vehicle.motorized.gearLevers.gearLever(?).state(?)#group" , "Group index" )
                        schema:register(XMLValueType.ANGLE, "vehicle.motorized.gearLevers.gearLever(?).state(?)#xRot" , "X rotation" )
                        schema:register(XMLValueType.ANGLE, "vehicle.motorized.gearLevers.gearLever(?).state(?)#yRot" , "Y rotation" )
                        schema:register(XMLValueType.ANGLE, "vehicle.motorized.gearLevers.gearLever(?).state(?)#zRot" , "Z rotation" )

                        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.power" , "Power" )
                        schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.maxSpeed" , "Max speed" )

                        schema:register(XMLValueType.STRING, "vehicle.motorized#statsType" , "Statistic type" , "tractor" )

                        schema:register(XMLValueType.BOOL, "vehicle.motorized#forceSpeedHudDisplay" , "Force usage of vehicle speed display in hud independent of setting" , false )
                        schema:register(XMLValueType.BOOL, "vehicle.motorized#forceRpmHudDisplay" , "Force usage of motor speed display in hud independent of setting" , false )

                        local valueTypes = {
                        "rpm" , "load" , "speed" , "speedDir" , "fuelUsage" , "motorTemperature" , "motorTemperatureWarning" , "clutchPedal" , "gear" , "gearGroup" , "gearIndex" , "gearGroupIndex" , "gearShiftUp" , "gearShiftDown" , "gearShiftUpDown" ,
                        "movingDirection" , "directionForward" , "directionForwardExclusive" , "directionBackward" , "directionNeutral" , "movingDirectionLetter" , "ignitionState" , "battery"
                        }
                        Dashboard.registerDashboardXMLPaths(schema, "vehicle.motorized.dashboards" , valueTypes)

                        AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.motorized.animationNodes" )

                        schema:register(XMLValueType.BOOL, Dashboard.GROUP_XML_KEY .. "#isMotorStarting" , "Is motor starting" )
                        schema:register(XMLValueType.BOOL, Dashboard.GROUP_XML_KEY .. "#isMotorRunning" , "Is motor running" )

                        schema:register(XMLValueType.BOOL, Dashboard.GROUP_XML_KEY .. "#electronicsStarting" , "Electrical components starting(depending on defined 'electronicsStartingTime')" , false )
                        schema:register(XMLValueType.TIME, Dashboard.GROUP_XML_KEY .. "#electronicsStartingTime" , "Starting time of electric components" , 2 )
                        schema:register(XMLValueType.BOOL, Dashboard.GROUP_XML_KEY .. "#electronicsRunning" , "Electrical components are started and running(depending on defined 'electronicsStartingTime')" , false )

                        schema:setXMLSpecializationType()
                    end

```

### loadConsumerConfiguration

**Description**

**Definition**

> loadConsumerConfiguration()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | consumerIndex |

**Code**

```lua
function Motorized:loadConsumerConfiguration(xmlFile, consumerIndex)
    local key = string.format( "vehicle.motorized.consumerConfigurations.consumerConfiguration(%d)" , consumerIndex - 1 )

    local spec = self.spec_motorized

    local fallbackConfigKey = "vehicle.motorized.consumers"

    spec.consumersEmptyWarning = self.xmlFile:getValue(key .. "#consumersEmptyWarning" , "warning_motorFuelEmpty" , self.customEnvironment)

    spec.consumers = { }
    spec.consumersByFillTypeName = { }
    spec.consumersByFillType = { }

    if not xmlFile:hasProperty(key) then
        return
    end

    local i = 0
    while true do
        local consumerKey = string.format( ".consumer(%d)" , i)
        if not xmlFile:hasProperty(key .. consumerKey) then
            break
        end
        local consumer = { }
        consumer.fillUnitIndex = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#fillUnitIndex" , 1 , fallbackConfigKey)

        local fillTypeName = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#fillType" , "consumer" , fallbackConfigKey)
        consumer.fillType = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)

        consumer.capacity = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#capacity" , nil , fallbackConfigKey)

        local fillUnit = self:getFillUnitByIndex(consumer.fillUnitIndex)
        if fillUnit ~ = nil then
            if fillUnit.supportedFillTypes[consumer.fillType] = = nil then
                fillUnit.supportedFillTypes = { }
                fillUnit.supportedFillTypes[consumer.fillType] = true
            end

            fillUnit.capacity = consumer.capacity or fillUnit.capacity

            if consumer.fillType = = FillType.DIESEL
                or consumer.fillType = = FillType.ELECTRICCHARGE
                or consumer.fillType = = FillType.METHANE then
                if fillUnit.exactFillRootNode = = nil then
                    Logging.xmlWarning( self.xmlFile, "Missing exactFillRootNode for fuel fill unit(%d)." , consumer.fillUnitIndex)
                    end
                end

                --fill fillUnit on start
                fillUnit.startFillLevel = fillUnit.capacity
                fillUnit.startFillTypeIndex = consumer.fillType

                fillUnit.ignoreFillLimit = true

                local usage = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#usage" , 1.0 , fallbackConfigKey)
                consumer.permanentConsumption = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#permanentConsumption" , true , fallbackConfigKey)
                if consumer.permanentConsumption then
                    consumer.usage = usage / ( 60 * 60 * 1000 ) -- from l/h to l/ms
                else
                        consumer.usage = usage
                    end
                    consumer.refillLitersPerSecond = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#refillLitersPerSecond" , 0 , fallbackConfigKey)
                    consumer.refillCapacityPercentage = ConfigurationUtil.getConfigurationValue(xmlFile, key, consumerKey, "#refillCapacityPercentage" , 0 , fallbackConfigKey)

                    consumer.fillLevelToChange = 0

                    table.insert(spec.consumers, consumer)
                    spec.consumersByFillTypeName[ string.upper(fillTypeName)] = consumer
                    spec.consumersByFillType[consumer.fillType] = consumer
                else
                        Logging.xmlWarning( self.xmlFile, "Unknown fillUnit '%d' for consumer '%s'" , consumer.fillUnitIndex, key .. consumerKey)
                        end
                        i = i + 1
                    end
                end

```

### loadDashboardGroupFromXML

**Description**

**Definition**

> loadDashboardGroupFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | group     |

**Code**

```lua
function Motorized:loadDashboardGroupFromXML(superFunc, xmlFile, key, group)
    if not superFunc( self , xmlFile, key, group) then
        return false
    end

    group.isMotorStarting = xmlFile:getValue(key .. "#isMotorStarting" )
    group.isMotorRunning = xmlFile:getValue(key .. "#isMotorRunning" )

    group.electronicsStarting = xmlFile:getValue(key .. "#electronicsStarting" , false )
    group.electronicsStartingTime = xmlFile:getValue(key .. "#electronicsStartingTime" , 2 )
    group.electronicsRunning = xmlFile:getValue(key .. "#electronicsRunning" , false )

    return true
end

```

### loadDifferentials

**Description**

> Load differentials from xml

**Definition**

> loadDifferentials(XMLFile xmlFile, integer configDifferentialIndex)

**Arguments**

| XMLFile | xmlFile                 | XMLFile instance             |
|---------|-------------------------|------------------------------|
| integer | configDifferentialIndex | index of differential config |

**Code**

```lua
function Motorized:loadDifferentials(xmlFile, configDifferentialIndex)
    local key,_ = ConfigurationUtil.getXMLConfigurationKey(xmlFile, configDifferentialIndex, "vehicle.motorized.differentialConfigurations.differentialConfiguration" , "vehicle.motorized.differentials" , "differentials" )

    local spec = self.spec_motorized

    spec.differentials = { }
    if self.isServer and spec.motorizedNode ~ = nil then
        xmlFile:iterate(key .. ".differentials.differential" , function (_, differentialKey)
            local torqueRatio = xmlFile:getValue(differentialKey .. "#torqueRatio" , 0.5 )
            local maxSpeedRatio = xmlFile:getValue(differentialKey .. "#maxSpeedRatio" , 1.3 )

            local indices = { - 1 , - 1 }
            local indexIsWheel = { false , false }
            for j = 1 , 2 do
                local wheelIndex = xmlFile:getValue(differentialKey .. string.format( "#wheelIndex%d" , j))
                if wheelIndex ~ = nil then
                    if self:getWheelFromWheelIndex(wheelIndex) ~ = nil then
                        indices[j] = wheelIndex
                        indexIsWheel[j] = true
                    else
                            Logging.xmlWarning( self.xmlFile, "Unable to find wheelIndex '%d' for differential '%s' (Indices start at 1)" , wheelIndex, differentialKey)
                            end
                        else
                                local diffIndex = xmlFile:getValue(differentialKey .. string.format( "#differentialIndex%d" , j))
                                if diffIndex ~ = nil then
                                    indices[j] = diffIndex - 1
                                    indexIsWheel[j] = false

                                    if diffIndex = = 0 then
                                        Logging.xmlWarning( self.xmlFile, "Unable to find differentialIndex '0' for differential '%s' (Indices start at 1)" , differentialKey)
                                        end
                                    end
                                end
                            end

                            if indices[ 1 ] ~ = - 1 and indices[ 2 ] ~ = - 1 then
                                table.insert(spec.differentials, {
                                torqueRatio = torqueRatio,
                                maxSpeedRatio = maxSpeedRatio,
                                diffIndex1 = indices[ 1 ],
                                diffIndex1IsWheel = indexIsWheel[ 1 ],
                                diffIndex2 = indices[ 2 ],
                                diffIndex2IsWheel = indexIsWheel[ 2 ] } )
                            end
                        end )

                        if #spec.differentials = = 0 then
                            Logging.xmlWarning( self.xmlFile, "No differentials defined" )
                        end
                    end
                end

```

### loadExhaustEffects

**Description**

> Loading of exhaust effects from xml file

**Definition**

> loadExhaustEffects(XMLFile xmlFile, table exhaustEffects)

**Arguments**

| XMLFile | xmlFile        | XMLFile instance            |
|---------|----------------|-----------------------------|
| table   | exhaustEffects | table to ass exhaustEffects |

**Code**

```lua
function Motorized:loadExhaustEffects(xmlFile)
    local spec = self.spec_motorized

    local minScale = xmlFile:getValue( "vehicle.motorized.exhaustParticleSystems#minScale" , 0.5 )
    local maxScale = xmlFile:getValue( "vehicle.motorized.exhaustParticleSystems#maxScale" , 1 )

    spec.exhaustParticleSystems = { }
    local i = 0
    while true do
        local baseKey = string.format( "vehicle.motorized.exhaustParticleSystems.exhaustParticleSystem(%d)" , i)
        if not xmlFile:hasProperty(baseKey) then
            break
        end

        local particleSystem = { }
        ParticleUtil.loadParticleSystem(xmlFile, particleSystem, baseKey, self.components, false , nil , self.baseDirectory)
        particleSystem.minScale = minScale
        particleSystem.maxScale = maxScale

        table.insert(spec.exhaustParticleSystems, particleSystem)

        i = i + 1
    end

    if #spec.exhaustParticleSystems = = 0 then
        spec.exhaustParticleSystems = nil
    end

    XMLUtil.checkDeprecatedXMLElements(xmlFile, "vehicle.motorized.exhaustFlap#index" , "vehicle.motorized.exhaustFlap#node" ) --FS17 to FS19

    spec.exhaustFlaps = { }
    for _, key in self.xmlFile:iterator( "vehicle.motorized.exhaustFlap" ) do
        local exhaustFlap = { }
        exhaustFlap.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if exhaustFlap.node ~ = nil then
            exhaustFlap.maxRot = xmlFile:getValue(key .. "#maxRot" , 0 )
            exhaustFlap.rotationAxis = xmlFile:getValue(key .. "#rotationAxis" , 1 )

            table.insert(spec.exhaustFlaps, exhaustFlap)
        end
    end

    spec.exhaustEffects = { }
    spec.sharedLoadRequestIds = { }
    xmlFile:iterate( "vehicle.motorized.exhaustEffects.exhaustEffect" , function (index, key)
        XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

        local linkNode = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        local filename = xmlFile:getValue(key .. "#filename" )
        if filename ~ = nil and linkNode ~ = nil then
            filename = Utils.getFilename(filename, self.baseDirectory)
            local arguments = {
            xmlFile = xmlFile,
            key = key,
            linkNode = linkNode,
            filename = filename
            }
            local sharedLoadRequestId = self:loadSubSharedI3DFile(filename, false , false , self.onExhaustEffectI3DLoaded, self , arguments)
            table.insert(spec.sharedLoadRequestIds, sharedLoadRequestId)
        end
    end )

    spec.exhaustEffectMaxSteeringSpeed = 0.001

    spec.effects = g_effectManager:loadEffect(xmlFile, "vehicle.motorized.effects" , self.components, self , self.i3dMappings)
    g_effectManager:setEffectTypeInfo(spec.effects, FillType.UNKNOWN)
end

```

### loadGearGroups

**Description**

**Definition**

> loadGearGroups()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | key         |
| any | motorMaxRpm |
| any | axleRatio   |

**Code**

```lua
function Motorized:loadGearGroups(xmlFile, key, motorMaxRpm, axleRatio)
    local groups = { }
    local i = 0
    while true do
        local groupKey = string.format(key .. ".group(%d)" , i)
        if not xmlFile:hasProperty(groupKey) then
            break
        end

        local ratio = xmlFile:getValue(groupKey .. "#ratio" )
        if ratio ~ = nil then
            local groupEntry = { }
            groupEntry.ratio = 1 / ratio
            groupEntry.isDefault = xmlFile:getValue(groupKey .. "#isDefault" , false )
            groupEntry.name = xmlFile:getValue(groupKey .. "#name" , tostring(i + 1 ))
            groupEntry.dashboardName = xmlFile:getValue(groupKey .. "#dashboardName" )

            groupEntry.actionName = xmlFile:getValue(groupKey .. "#actionName" )
            if (i < 4 or groupEntry.actionName ~ = nil ) and groupEntry.actionName ~ = "-" then
                groupEntry.actionName = groupEntry.actionName or string.format( "SHIFT_GROUP_SELECT_%d" , i + 1 )
                groupEntry.inputAction = InputAction[groupEntry.actionName]
                if groupEntry.inputAction = = nil then
                    Logging.xmlWarning(xmlFile, "Invalid actionName '%s' found for gear group '%s'" , groupEntry.actionName, groupKey)
                        groupEntry.inputAction = InputAction[ string.format( "SHIFT_GROUP_SELECT_%d" , i + 1 )]
                    end
                end

                table.insert(groups, groupEntry)
            end

            i = i + 1
        end

        if #groups > 0 then
            if #groups > 4 then
                for j, groupEntry in pairs(groups) do
                    if groupEntry.actionName = = nil then
                        Logging.xmlDevWarning(xmlFile, "More than 4 gear groups defined, but manual assignment of actionName missing for gearGroup %d. (Use '-' to skip a group)" , j)
                        end
                    end
                end

                table.sort(groups, Motorized.sortGears)

                return groups
            end

            return nil
        end

```

### loadGears

**Description**

**Definition**

> loadGears()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | gearName    |
| any | key         |
| any | motorMaxRpm |
| any | axleRatio   |
| any | direction   |

**Code**

```lua
function Motorized:loadGears(xmlFile, gearName, key, motorMaxRpm, axleRatio, direction)
    local gears = { }
    local gearI = 0
    while true do
        local gearKey = string.format(key .. ".%s(%d)" , gearName, gearI)
        if not xmlFile:hasProperty(gearKey) then
            break
        end

        local gearRatio = xmlFile:getValue(gearKey .. "#gearRatio" )
        local maxSpeed = xmlFile:getValue(gearKey .. "#maxSpeed" )

        if maxSpeed ~ = nil then
            gearRatio = (motorMaxRpm * math.pi) / (maxSpeed / 3.6 * 30 )
        end

        if gearRatio ~ = nil then
            local gearEntry = { }
            gearEntry.ratio = gearRatio * axleRatio
            gearEntry.default = xmlFile:getValue(gearKey .. "#defaultGear" , false )
            gearEntry.name = xmlFile:getValue(gearKey .. "#name" , tostring((gearI + 1 ) * direction))
            gearEntry.reverseName = xmlFile:getValue(gearKey .. "#reverseName" , tostring((gearI + 1 ) * direction * - 1 ))

            gearEntry.dashboardName = xmlFile:getValue(gearKey .. "#dashboardName" )
            gearEntry.dashboardReverseName = xmlFile:getValue(gearKey .. "#dashboardReverseName" )

            gearEntry.actionName = xmlFile:getValue(gearKey .. "#actionName" )
            if (gearI < 8 or gearEntry.actionName ~ = nil ) and gearEntry.actionName ~ = "-" then
                gearEntry.actionName = gearEntry.actionName or string.format( "SHIFT_GEAR_SELECT_%d" , gearI + 1 )

                gearEntry.inputAction = InputAction[gearEntry.actionName]
                if gearEntry.inputAction = = nil then
                    Logging.xmlWarning(xmlFile, "Invalid actionName '%s' found for gear '%s'" , gearEntry.actionName, gearKey)
                        gearEntry.inputAction = InputAction[ string.format( "SHIFT_GEAR_SELECT_%d" , gearI + 1 )]
                    end
                end

                table.insert(gears, gearEntry)
            end

            gearI = gearI + 1
        end

        if #gears > 0 then
            if #gears > 8 then
                for j, gearEntry in pairs(gears) do
                    if gearEntry.actionName = = nil then
                        Logging.xmlDevWarning(xmlFile, "More than 8 gears defined, but manual assignment of actionName missing for gear %d. (Use '-' to skip a gear)" , j)
                        end
                    end
                end

                table.sort(gears, Motorized.sortGears)

                return gears
            end

            return nil
        end

```

### loadMotor

**Description**

> Load motor from xml file

**Definition**

> loadMotor(XMLFile xmlFile, integer motorId)

**Arguments**

| XMLFile | xmlFile | XMLFile instance             |
|---------|---------|------------------------------|
| integer | motorId | index of motor configuration |

**Code**

```lua
function Motorized:loadMotor(xmlFile, motorId)
    local key
    -- Sets motorId to default 1 if motor cannot be found.
        key, motorId = ConfigurationUtil.getXMLConfigurationKey(xmlFile, motorId, "vehicle.motorized.motorConfigurations.motorConfiguration" , "vehicle.motorized" , "motor" )

        local spec = self.spec_motorized

        local fallbackConfigKey = "vehicle.motorized.motorConfigurations.motorConfiguration(0)"

        -- load the name from the xml file again, as it might have changed compared to storeData(e.g.xml overwrites)
        local vehicleName = xmlFile:getValue(key .. "#name" , nil , self.customEnvironment, false )
        local params = xmlFile:getValue(key .. "#params" )
        if vehicleName ~ = nil and params ~ = nil then
            vehicleName = g_i18n:insertTextParams(vehicleName, params, self.customEnvironment, xmlFile)
        end
        spec.vehicleName = xmlFile:getValue(key .. "#vehicleName" , vehicleName, self.customEnvironment, false )

        spec.motorType = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#type" , "vehicle" , fallbackConfigKey)
        spec.motorStartAnimation = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#startAnimationName" , "vehicle" , fallbackConfigKey)

        spec.consumerConfigurationIndex = ConfigurationUtil.getConfigurationValue(xmlFile, key, "#consumerConfigurationIndex" , "" , 1 , fallbackConfigKey)

        local motorMinRpm = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#minRpm" , 1000 , fallbackConfigKey)
        local motorMaxRpm = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#maxRpm" , 1800 , fallbackConfigKey)
        local minSpeed = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#minSpeed" , 1 , fallbackConfigKey)
        local maxForwardSpeed = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#maxForwardSpeed" , nil , fallbackConfigKey)
        local maxBackwardSpeed = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#maxBackwardSpeed" , nil , fallbackConfigKey)
        if maxForwardSpeed ~ = nil then
            maxForwardSpeed = maxForwardSpeed / 3.6
        end
        if maxBackwardSpeed ~ = nil then
            maxBackwardSpeed = maxBackwardSpeed / 3.6
        end

        local spec_wheels = self.spec_wheels
        if spec_wheels ~ = nil and spec_wheels.configItem ~ = nil then
            if spec_wheels.configItem.maxForwardSpeed ~ = nil then
                maxForwardSpeed = spec_wheels.configItem.maxForwardSpeed / 3.6
            end
        end

        local accelerationLimit = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#accelerationLimit" , 2.0 , fallbackConfigKey) -- m/s^2

        local brakeForce = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#brakeForce" , 10 , fallbackConfigKey) * 2
        local lowBrakeForceScale = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#lowBrakeForceScale" , 0.5 , fallbackConfigKey)
        local lowBrakeForceSpeedLimit = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#lowBrakeForceSpeedLimit" , 1 , fallbackConfigKey) / 3600
        local torqueScale = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#torqueScale" , 1 , fallbackConfigKey)
        local ptoMotorRpmRatio = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#ptoMotorRpmRatio" , 4 , fallbackConfigKey)

        -- transmission settings can only be fully overwritten, not only single attributes
        local transmissionKey = key .. ".transmission"
        if not xmlFile:hasProperty(transmissionKey) then
            transmissionKey = fallbackConfigKey .. ".transmission"
        end

        local minForwardGearRatio = xmlFile:getValue(transmissionKey .. "#minForwardGearRatio" )
        local maxForwardGearRatio = xmlFile:getValue(transmissionKey .. "#maxForwardGearRatio" )
        local minBackwardGearRatio = xmlFile:getValue(transmissionKey .. "#minBackwardGearRatio" )
        local maxBackwardGearRatio = xmlFile:getValue(transmissionKey .. "#maxBackwardGearRatio" )
        local gearChangeTime = xmlFile:getValue(transmissionKey .. "#gearChangeTime" )
        local autoGearChangeTime = xmlFile:getValue(transmissionKey .. "#autoGearChangeTime" )
        local axleRatio = xmlFile:getValue(transmissionKey .. "#axleRatio" , 1.0 )
        local startGearThreshold = xmlFile:getValue(transmissionKey .. "#startGearThreshold" , VehicleMotor.GEAR_START_THRESHOLD)

        if maxForwardGearRatio = = nil or minForwardGearRatio = = nil then
            minForwardGearRatio = nil
            maxForwardGearRatio = nil
        else
                minForwardGearRatio = minForwardGearRatio * axleRatio
                maxForwardGearRatio = maxForwardGearRatio * axleRatio
            end
            if minBackwardGearRatio = = nil or maxBackwardGearRatio = = nil then
                minBackwardGearRatio = nil
                maxBackwardGearRatio = nil
            else
                    minBackwardGearRatio = minBackwardGearRatio * axleRatio
                    maxBackwardGearRatio = maxBackwardGearRatio * axleRatio
                end

                -- Read forward gear ratios
                local forwardGears
                if minForwardGearRatio = = nil then
                    forwardGears = self:loadGears(xmlFile, "forwardGear" , transmissionKey, motorMaxRpm, axleRatio, 1 )
                    if forwardGears = = nil then
                        printWarning( "Warning:Missing forward gear ratios for motor in '" .. self.configFileName .. "'!" )
                            forwardGears = { { ratio = 1 , default = false } }
                        end
                    end
                    -- Read backward gear ratios
                    local backwardGears
                    if minBackwardGearRatio = = nil then
                        backwardGears = self:loadGears(xmlFile, "backwardGear" , transmissionKey, motorMaxRpm, axleRatio, - 1 )
                    end

                    local gearGroups = self:loadGearGroups(xmlFile, transmissionKey .. ".groups" , motorMaxRpm, axleRatio)
                    local groupsType = xmlFile:getValue(transmissionKey .. ".groups#type" , "default" )
                    local groupChangeTime = xmlFile:getValue(transmissionKey .. ".groups#changeTime" , 0.5 )

                    local directionChangeUseGear = xmlFile:getValue(transmissionKey .. ".directionChange#useGear" , false )
                    local directionChangeGearIndex = xmlFile:getValue(transmissionKey .. ".directionChange#reverseGearIndex" , 1 )
                    local directionChangeUseGroup = xmlFile:getValue(transmissionKey .. ".directionChange#useGroup" , false )
                    local directionChangeGroupIndex = xmlFile:getValue(transmissionKey .. ".directionChange#reverseGroupIndex" , 1 )
                    local directionChangeTime = xmlFile:getValue(transmissionKey .. ".directionChange#changeTime" , 0.5 )

                    local manualShiftGears = xmlFile:getValue(transmissionKey .. ".manualShift#gears" , true )
                    local manualShiftGroups = xmlFile:getValue(transmissionKey .. ".manualShift#groups" , true )

                    --local maxTorque = 0
                    local torqueCurve = AnimCurve.new(linearInterpolator1)
                    local torqueI = 0
                    local torqueBase = fallbackConfigKey .. ".motor.torque"
                    if key ~ = nil and xmlFile:hasProperty(key .. ".motor.torque(0)" ) then -- using selected motor configuration
                        torqueBase = key .. ".motor.torque"
                    end

                    while true do
                        local torqueKey = string.format(torqueBase .. "(%d)" , torqueI)
                        local normRpm = xmlFile:getValue(torqueKey .. "#normRpm" )
                        local rpm
                        if normRpm = = nil then
                            rpm = xmlFile:getValue(torqueKey .. "#rpm" )
                        else
                                rpm = normRpm * motorMaxRpm
                            end
                            local torque = xmlFile:getValue(torqueKey .. "#torque" )
                            if torque = = nil or rpm = = nil then
                                break
                            end
                            torqueCurve:addKeyframe( { torque * torqueScale, time = rpm } )
                            torqueI = torqueI + 1
                        end

                        spec.motor = VehicleMotor.new( self , motorMinRpm, motorMaxRpm, maxForwardSpeed, maxBackwardSpeed, torqueCurve, brakeForce, forwardGears, backwardGears, minForwardGearRatio, maxForwardGearRatio, minBackwardGearRatio, maxBackwardGearRatio, ptoMotorRpmRatio, minSpeed)
                        spec.motor:setGearGroups(gearGroups, groupsType, groupChangeTime)
                        spec.motor:setDirectionChange(directionChangeUseGear, directionChangeGearIndex, directionChangeUseGroup, directionChangeGroupIndex, directionChangeTime)
                        spec.motor:setManualShift(manualShiftGears, manualShiftGroups)
                        spec.motor:setStartGearThreshold(startGearThreshold)

                        local rotInertia = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#rotInertia" , spec.motor:getRotInertia(), fallbackConfigKey)
                        local dampingRateScale = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#dampingRateScale" , 1 , fallbackConfigKey)
                        spec.motor:setRotInertia(rotInertia)
                        spec.motor:setDampingRateScale(dampingRateScale)
                        spec.motor:setLowBrakeForce(lowBrakeForceScale, lowBrakeForceSpeedLimit)
                        spec.motor:setAccelerationLimit(accelerationLimit)

                        local motorRotationAccelerationLimit = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor" , "#rpmSpeedLimit" , nil , fallbackConfigKey) -- xml:rpm/s -> converted to rad/s^2
                        if motorRotationAccelerationLimit ~ = nil then
                            motorRotationAccelerationLimit = motorRotationAccelerationLimit * math.pi / 30
                            spec.motor:setMotorRotationAccelerationLimit(motorRotationAccelerationLimit)
                        end

                        if gearChangeTime ~ = nil then
                            spec.motor:setGearChangeTime(gearChangeTime)
                        end
                        if autoGearChangeTime ~ = nil then
                            spec.motor:setAutoGearChangeTime(autoGearChangeTime)
                        end
                    end

```

### loadSounds

**Description**

> Load sounds from xml file

**Definition**

> loadSounds(XMLFile xmlFile, )

**Arguments**

| XMLFile | xmlFile    | XMLFile instance |
|---------|------------|------------------|
| any     | baseString |                  |

**Code**

```lua
function Motorized:loadSounds(xmlFile, baseString)
    if self.isClient then
        local spec = self.spec_motorized

        spec.samples = spec.samples or { }

        spec.samples.motorStart = g_soundManager:loadSampleFromXML(xmlFile, baseString, "motorStart" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.motorStart
        spec.samples.motorStop = g_soundManager:loadSampleFromXML(xmlFile, baseString, "motorStop" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.motorStop
        spec.samples.clutchCracking = g_soundManager:loadSampleFromXML(xmlFile, baseString, "clutchCracking" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.clutchCracking
        spec.samples.gearEngaged = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearEngaged" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearEngaged
        spec.samples.gearDisengaged = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearDisengaged" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearDisengaged
        spec.samples.gearGroupChange = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearGroupChange" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearGroupChange
        spec.samples.gearLeverStart = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearLeverStart" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearLeverStart
        spec.samples.gearLeverEnd = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearLeverEnd" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearLeverEnd
        spec.samples.gearGroupLeverStart = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearGroupLeverStart" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearGroupLeverStart
        spec.samples.gearGroupLeverEnd = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearGroupLeverEnd" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearGroupLeverEnd
        spec.samples.gearRangeChange = g_soundManager:loadSampleFromXML(xmlFile, baseString, "gearRangeChange" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.gearRangeChange
        spec.samples.blowOffValve = g_soundManager:loadSampleFromXML(xmlFile, baseString, "blowOffValve" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.blowOffValve
        spec.samples.retarder = g_soundManager:loadSampleFromXML(xmlFile, baseString, "retarder" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.retarder

        spec.gearboxSamples = g_soundManager:loadSamplesFromXML(xmlFile, baseString, "gearbox" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self , spec.gearboxSamples)
        spec.motorSamples = g_soundManager:loadSamplesFromXML(xmlFile, baseString, "motor" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self , spec.motorSamples)

        spec.samples.airCompressorStart = g_soundManager:loadSampleFromXML(xmlFile, baseString, "airCompressorStart" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.airCompressorStart
        spec.samples.airCompressorStop = g_soundManager:loadSampleFromXML(xmlFile, baseString, "airCompressorStop" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.airCompressorStop
        spec.samples.airCompressorRun = g_soundManager:loadSampleFromXML(xmlFile, baseString, "airCompressorRun" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.airCompressorRun

        spec.samples.compressedAir = g_soundManager:loadSampleFromXML(xmlFile, baseString, "compressedAir" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.compressedAir
        if spec.samples.compressedAir ~ = nil then
            spec.samples.compressedAir.brakeTime = 0
            spec.samples.compressedAir.lastBrakeTime = 0
        end

        spec.samples.airRelease = g_soundManager:loadSampleFromXML(xmlFile, baseString, "airRelease" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.airRelease

        spec.samples.reverseDrive = g_soundManager:loadSampleFromXML(xmlFile, baseString, "reverseDrive" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.reverseDrive
        spec.reverseDriveThreshold = xmlFile:getValue( "vehicle.motorized.reverseDriveSound#threshold" , 4 )

        spec.brakeCompressor = { }
        spec.brakeCompressor.capacity = xmlFile:getValue( "vehicle.motorized.brakeCompressor#capacity" , 6 )
        spec.brakeCompressor.refillFilllevel = math.min(spec.brakeCompressor.capacity, xmlFile:getValue( "vehicle.motorized.brakeCompressor#refillFillLevel" , spec.brakeCompressor.capacity / 2 ))
        spec.brakeCompressor.fillSpeed = xmlFile:getValue( "vehicle.motorized.brakeCompressor#fillSpeed" , 0.6 ) / 1000
        spec.brakeCompressor.fillLevel = 0
        spec.brakeCompressor.doFill = true

        spec.isBrakeSamplePlaying = false
        spec.samples.brake = g_soundManager:loadSampleFromXML(xmlFile, baseString, "brake" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self ) or spec.samples.brake

        spec.compressionSoundTime = 0
    end
end

```

### loadSpecValueFuel

**Description**

**Definition**

> loadSpecValueFuel()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Motorized.loadSpecValueFuel(xmlFile, customEnvironment, baseDir)
    local rootName = xmlFile:getRootName()

    local fillUnits = { }

    local i = 0
    while true do
        local configKey = string.format(rootName .. ".fillUnit.fillUnitConfigurations.fillUnitConfiguration(%d)" , i)
        if not xmlFile:hasProperty(configKey) then
            break
        end

        local configFillUnits = { }

        local j = 0
        while true do
            local fillUnitKey = string.format(configKey .. ".fillUnits.fillUnit(%d)" , j)
            if not xmlFile:hasProperty(fillUnitKey) then
                break
            end

            local fillTypes = xmlFile:getValue(fillUnitKey .. "#fillTypes" )
            local capacity = xmlFile:getValue(fillUnitKey .. "#capacity" )

            table.insert(configFillUnits, { fillTypes = fillTypes, capacity = capacity } )
            j = j + 1
        end

        table.insert(fillUnits, configFillUnits)

        i = i + 1
    end

    local consumers = { }

    i = 0
    while true do
        local key = string.format(rootName .. ".motorized.consumerConfigurations.consumerConfiguration(%d)" , i)
        if not xmlFile:hasProperty(key) then
            break
        end

        local consumer = { }

        local j = 0
        while true do
            local consumerKey = string.format(key .. ".consumer(%d)" , j)
            if not xmlFile:hasProperty(consumerKey) then
                break
            end

            local fillType = xmlFile:getValue(consumerKey .. "#fillType" )
            local fillUnitIndex = xmlFile:getValue(consumerKey .. "#fillUnitIndex" )
            local capacity = xmlFile:getValue(consumerKey .. "#capacity" )

            table.insert(consumer, { fillType = fillType, fillUnitIndex = fillUnitIndex, capacity = capacity } )

            j = j + 1
        end

        table.insert(consumers, consumer)

        i = i + 1
    end

    return { fillUnits = fillUnits, consumers = consumers }
end

```

### loadSpecValueMaxSpeed

**Description**

**Definition**

> loadSpecValueMaxSpeed()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Motorized.loadSpecValueMaxSpeed(xmlFile, customEnvironment, baseDir)
    local motorKey = nil
    if xmlFile:hasProperty( "vehicle.motorized.motorConfigurations.motorConfiguration(0)" ) then
        motorKey = "vehicle.motorized.motorConfigurations.motorConfiguration(0)"
    elseif xmlFile:hasProperty( "vehicle.motor" ) then
            motorKey = "vehicle"
        end
        if motorKey ~ = nil then
            local maxRpm = xmlFile:getValue(motorKey .. ".motor#maxRpm" , 1800 )
            local minForwardGearRatio = xmlFile:getValue(motorKey .. ".transmission#minForwardGearRatio" , nil )

            local axleRatio = xmlFile:getValue(motorKey .. ".transmission#axleRatio" , 1.0 )
            local forwardGears = Motorized.loadGears( nil , xmlFile, "forwardGear" , motorKey .. ".transmission" , maxRpm, axleRatio, 1 )

            if minForwardGearRatio = = nil and forwardGears = = nil then
                Logging.xmlWarning(xmlFile, "No gear ratios defined for transmission" )
                end

                local calculatedMaxSpeed = math.ceil( VehicleMotor.calculatePhysicalMaximumSpeed(minForwardGearRatio, forwardGears, maxRpm) * 3.6 )

                local storeDataMaxSpeed = xmlFile:getValue( "vehicle.storeData.specs.maxSpeed" )
                local maxSpeed = xmlFile:getValue( "vehicle.motorized.motorConfigurations.motorConfiguration(0)#maxSpeed" )
                local maxForwardSpeed = xmlFile:getValue(motorKey .. ".motor#maxForwardSpeed" )

                if storeDataMaxSpeed ~ = nil then
                    return storeDataMaxSpeed
                elseif maxSpeed ~ = nil then
                        return maxSpeed
                    elseif maxForwardSpeed ~ = nil then
                            return math.min(maxForwardSpeed, calculatedMaxSpeed)
                        else
                                return calculatedMaxSpeed
                            end
                        end
                        return nil
                    end

```

### loadSpecValuePower

**Description**

**Definition**

> loadSpecValuePower()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Motorized.loadSpecValuePower(xmlFile, customEnvironment, baseDir)
    return xmlFile:getValue( "vehicle.storeData.specs.power" )
end

```

### loadSpecValueTransmission

**Description**

**Definition**

> loadSpecValueTransmission()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Motorized.loadSpecValueTransmission(xmlFile, customEnvironment, baseDir)
    local nameByConfigIndex = { }
    xmlFile:iterate( "vehicle.motorized.motorConfigurations.motorConfiguration" , function (index, key)
        nameByConfigIndex[index] = xmlFile:getValue(key .. ".transmission#name" , nil , customEnvironment, false )
        local param = xmlFile:getValue(key .. ".transmission#param" )
        if param ~ = nil then
            param = g_i18n:convertText(param, customEnvironment)
            nameByConfigIndex[index] = string.format(nameByConfigIndex[index], param)
        end
    end )

    return nameByConfigIndex
end

```

### onAIJobFinished

**Description**

**Definition**

> onAIJobFinished()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function Motorized:onAIJobFinished(job)
    -- only stop motor if no player is inside
        if self.getIsControlled = = nil or not self:getIsControlled() then
            self:stopMotor( true )
        end

        local spec = self.spec_motorized
        if spec.motor ~ = nil then
            spec.motor:setGearShiftMode(spec.gearShiftMode)
        end
    end

```

### onAIJobStarted

**Description**

**Definition**

> onAIJobStarted()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function Motorized:onAIJobStarted(job)
    local spec = self.spec_motorized
    self:startMotor( true )

    if spec.motor ~ = nil then
        spec.motor:setGearShiftMode( VehicleMotor.SHIFT_MODE_AUTOMATIC)
    end
end

```

### onClutchCreaking

**Description**

**Definition**

> onClutchCreaking()

**Arguments**

| any | isEvent           |
|-----|-------------------|
| any | groupTransmission |
| any | gearIndex         |
| any | groupIndex        |

**Code**

```lua
function Motorized:onClutchCreaking(isEvent, groupTransmission, gearIndex, groupIndex)
    local spec = self.spec_motorized

    if self:getIsActiveForInput( true ) then
        if groupTransmission then
            g_currentMission:showBlinkingWarning(spec.clutchCrackingGroupWarning, 2000 )
        else
                g_currentMission:showBlinkingWarning(spec.clutchCrackingGearWarning, 2000 )
            end
        end

        if not g_soundManager:getIsSamplePlaying(spec.samples.clutchCracking) then
            g_soundManager:playSample(spec.samples.clutchCracking)
        end

        if gearIndex ~ = nil then
            self:setGearLeversState(gearIndex, nil , 500 , false )
            spec.clutchCrackingGearIndex = gearIndex
        end

        if groupIndex ~ = nil then
            self:setGearLeversState( nil , groupIndex, 500 , false )
            spec.clutchCrackingGroupIndex = groupIndex
        end

        spec.clutchCrackingTimeOut = g_ time + (isEvent and 750 or 100 )

        if g_server ~ = nil then
            g_server:broadcastEvent( MotorClutchCreakingEvent.new( self , isEvent, groupTransmission, gearIndex, groupIndex), nil , nil , self )
        end
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function Motorized:onDelete()
    local spec = self.spec_motorized

    if spec.motor ~ = nil then
        spec.motor:delete()
    end

    if spec.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs(spec.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        spec.sharedLoadRequestIds = nil
    end

    ParticleUtil.deleteParticleSystems(spec.exhaustParticleSystems)
    g_soundManager:deleteSamples(spec.samples)
    g_soundManager:deleteSamples(spec.motorSamples)
    g_soundManager:deleteSamples(spec.gearboxSamples)
    g_animationManager:deleteAnimations(spec.animationNodes)

    if spec.effects ~ = nil then
        g_effectManager:deleteEffects(spec.effects)
    end
end

```

### onExhaustEffectI3DLoaded

**Description**

**Definition**

> onExhaustEffectI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function Motorized:onExhaustEffectI3DLoaded(i3dNode, failedReason, args)
    local spec = self.spec_motorized

    if i3dNode ~ = 0 then
        local node = getChildAt(i3dNode, 0 )
        if getHasShaderParameter(node, "param" ) then
            local xmlFile = args.xmlFile
            local key = args.key
            local effect = { }
            effect.effectNode = node
            effect.node = args.linkNode
            effect.filename = args.filename
            link(effect.node, effect.effectNode)
            setVisibility(effect.effectNode, false )
            delete(i3dNode)

            effect.minRpmColor = xmlFile:getValue(key .. "#minRpmColor" , "0 0 0 1" , true )
            effect.maxRpmColor = xmlFile:getValue(key .. "#maxRpmColor" , "0.0384 0.0359 0.0627 2.0" , true )
            effect.minRpmScale = xmlFile:getValue(key .. "#minRpmScale" , 0.25 )
            effect.maxRpmScale = xmlFile:getValue(key .. "#maxRpmScale" , 0.95 )

            effect.upFactor = xmlFile:getValue(key .. "#upFactor" , 0.75 )

            effect.lastPosition = nil

            effect.xRot = 0
            effect.zRot = 0

            table.insert(spec.exhaustEffects, effect)
        end
    end
end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillType         |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function Motorized:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    -- refill def if diesel is refilled
        if fillLevelDelta > 0 and fillType = = FillType.DIESEL then
            local factor = self:getFillUnitFillLevel(fillUnitIndex) / self:getFillUnitCapacity(fillUnitIndex)
            local defFillUnitIndex = self:getConsumerFillUnitIndex(FillType.DEF)
            if defFillUnitIndex ~ = nil then
                local delta = ( self:getFillUnitCapacity(defFillUnitIndex) * factor) - self:getFillUnitFillLevel(defFillUnitIndex)
                self:addFillUnitFillLevel( self:getOwnerFarmId(), defFillUnitIndex, delta, FillType.DEF, ToolType.UNDEFINED, nil )
            end
        end
    end

```

### onGearChanged

**Description**

**Definition**

> onGearChanged()

**Arguments**

| any | gear         |
|-----|--------------|
| any | targetGear   |
| any | changeTime   |
| any | previousGear |

**Code**

```lua
function Motorized:onGearChanged(gear, targetGear, changeTime, previousGear)
    self:setGearLeversState(targetGear, nil , changeTime)

    local spec = self.spec_motorized
    if self.isClient then
        if gear = = 0 then
            if not g_soundManager:getIsSamplePlaying(spec.samples.gearDisengaged) then
                g_soundManager:playSample(spec.samples.gearDisengaged)
            end
        else
                if not g_soundManager:getIsSamplePlaying(spec.samples.gearEngaged) then
                    g_soundManager:playSample(spec.samples.gearEngaged)
                end

                if previousGear ~ = 0 and spec.motor.currentGears ~ = nil then
                    local numGears = #spec.motor.currentGears
                    local lowRangeMax = math.ceil(numGears * 0.5 )

                    if (previousGear < = lowRangeMax and gear > lowRangeMax) or(gear < = lowRangeMax and previousGear > lowRangeMax) then
                        if not g_soundManager:getIsSamplePlaying(spec.samples.gearRangeChange) then
                            g_soundManager:playSample(spec.samples.gearRangeChange)
                        end
                    end
                end
            end
        end

        if self.isServer then
            self:raiseDirtyFlags(spec.dirtyFlag)
        end

        if self.isClient then
            if self.updateDashboardValueType ~ = nil then
                self:updateDashboardValueType( "motorized.gear" )
                self:updateDashboardValueType( "motorized.gearIndex" )
            end
        end
    end

```

### onGearDirectionChanged

**Description**

**Definition**

> onGearDirectionChanged()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function Motorized:onGearDirectionChanged(direction)
    if self.isServer then
        self:raiseDirtyFlags( self.spec_motorized.dirtyFlag)
    end

    if self.isClient then
        if self.updateDashboardValueType ~ = nil then
            self:updateDashboardValueType( "motorized.gear" )
            self:updateDashboardValueType( "motorized.gearIndex" )
        end
    end
end

```

### onGearGroupChanged

**Description**

**Definition**

> onGearGroupChanged()

**Arguments**

| any | targetGroup |
|-----|-------------|
| any | changeTime  |

**Code**

```lua
function Motorized:onGearGroupChanged(targetGroup, changeTime)
    self:setGearLeversState( nil , targetGroup, changeTime)

    local spec = self.spec_motorized
    if self.isClient then
        if not g_soundManager:getIsSamplePlaying(spec.samples.gearGroupChange) then
            g_soundManager:playSample(spec.samples.gearGroupChange)
        end
    end

    if self.isServer then
        self:raiseDirtyFlags(spec.dirtyFlag)
    end

    if self.isClient then
        if self.updateDashboardValueType ~ = nil then
            self:updateDashboardValueType( "motorized.gearGroup" )
            self:updateDashboardValueType( "motorized.gearGroupIndex" )
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
function Motorized:onLoad(savegame)
    local spec = self.spec_motorized

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.motor.animationNodes.animationNode" , "motor" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.differentialConfigurations" , "vehicle.motorized.differentialConfigurations" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.motorConfigurations" , "vehicle.motorized.motorConfigurations" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.maximalAirConsumptionPerFullStop" , "vehicle.motorized.consumerConfigurations.consumerConfiguration.consumer(with fill type 'air')#usage(is now in usage per second at full brake power)" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.indoorHud.rpm" , "vehicle.motorized.dashboards.dashboard with valueType 'rpm'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.indoorHud.speed" , "vehicle.motorized.dashboards.dashboard with valueType 'speed'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.indoorHud.fuelUsage" , "vehicle.motorized.dashboards.dashboard with valueType 'fuelUsage'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.indoorHud.fuel" , "fillUnit.dashboard with valueType 'fillLevel'" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.motor" , "vehicle.motorized.motorConfigurations.motorConfiguration(?).motor" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.transmission" , "vehicle.motorized.motorConfigurations.motorConfiguration(?).transmission" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.fuelCapacity" , "vehicle.motorized.consumerConfigurations.consumerConfiguration.consumer#capacity" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.motorized.motorConfigurations.motorConfiguration(?).fuelCapacity" , "vehicle.motorized.consumerConfigurations.consumerConfiguration.consumer#capacity" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle#consumerConfigurationIndex" , "vehicle.motorized.motorConfigurations.motorConfiguration(?)#consumerConfigurationIndex'" ) --FS19 to FS22

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.motorized.exhaustParticleSystems#count" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.motorized.exhaustParticleSystems.exhaustParticleSystem1" , "vehicle.motorized.exhaustParticleSystems.exhaustParticleSystem" ) --FS19 to FS22

    spec.motorizedNode = nil
    for _, component in pairs( self.components) do
        if component.motorized then
            spec.motorizedNode = component.node
            break
        end
    end

    spec.directionChangeMode = VehicleMotor.DIRECTION_CHANGE_MODE_AUTOMATIC
    spec.gearShiftMode = VehicleMotor.SHIFT_MODE_AUTOMATIC

    local configKey = string.format( "vehicle.motorized.motorConfigurations.motorConfiguration(%d)" , self.configurations[ "motor" ] - 1 )

    self:loadDifferentials( self.xmlFile, self.differentialIndex)
    self:loadMotor( self.xmlFile, self.configurations[ "motor" ])

    self:loadSounds( self.xmlFile, "vehicle.motorized.sounds" )
    if self.xmlFile:hasProperty(configKey) then
        self:loadSounds( self.xmlFile, configKey .. ".sounds" )
    end

    self:loadConsumerConfiguration( self.xmlFile, spec.consumerConfigurationIndex)

    if self.isClient then
        self:loadExhaustEffects( self.xmlFile)
    end

    spec.gearLevers = { }
    spec.activeGearLeverInterpolators = { }
    self.xmlFile:iterate( "vehicle.motorized.gearLevers.gearLever" , function (index, key)
        local entry = { }
        entry.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if entry.node ~ = nil then
            entry.centerAxis = self.xmlFile:getValue(key .. "#centerAxis" )

            entry.changeTime = self.xmlFile:getValue(key .. "#changeTime" , 500 )
            entry.handsOnDelay = self.xmlFile:getValue(key .. "#handsOnDelay" , 0 )

            entry.curTarget = { getRotation(entry.node) }

            entry.states = { }
            self.xmlFile:iterate(key .. ".state" , function (stateIndex, stateKey)
                local state = { }

                state.gear = self.xmlFile:getValue(stateKey .. "#gear" )
                state.group = self.xmlFile:getValue(stateKey .. "#group" )

                if state.gear ~ = nil or state.group ~ = nil then
                    state.node = entry.node
                    state.gearLever = entry

                    local x, y, z = getRotation(entry.node)
                    local xRot = self.xmlFile:getValue(stateKey .. "#xRot" , x)
                    local yRot = self.xmlFile:getValue(stateKey .. "#yRot" , y)
                    local zRot = self.xmlFile:getValue(stateKey .. "#zRot" , z)

                    state.rotation = { xRot, yRot, zRot }
                    state.useRotation = { self.xmlFile:getValue(stateKey .. "#xRot" ) ~ = nil ,
                    self.xmlFile:getValue(stateKey .. "#yRot" ) ~ = nil ,
                    self.xmlFile:getValue(stateKey .. "#zRot" ) ~ = nil }
                    state.curRotation = { xRot, yRot, zRot }

                    table.insert(entry.states, state)
                else
                        Logging.xmlWarning( self.xmlFile, "Unable to load gear lever state.Missing gear or group! '%s'" , stateKey)
                    end
                end )

                table.insert(spec.gearLevers, entry)
            else
                    Logging.xmlWarning( self.xmlFile, "Unable to load gear lever.Missing node! '%s'" , key)
                end
            end )

            spec.stopMotorOnLeave = true

            spec.motorStartDuration = 0
            if spec.samples ~ = nil and spec.samples.motorStart ~ = nil then
                spec.motorStartDuration = spec.samples.motorStart.duration
            end

            if spec.motorSamples ~ = nil then
                local maxDuration = 0
                for _, sample in ipairs(spec.motorSamples) do
                    maxDuration = math.max(maxDuration, g_soundManager:getSampleLoopSynthesisStartDuration(sample))
                end
                if maxDuration ~ = 0 then
                    spec.motorStartDuration = maxDuration
                end
            end

            --getSampleLoopSynthesisStartDuration
            spec.motorStartDuration = self.xmlFile:getValue( "vehicle.motorized.motorStartDuration" , spec.motorStartDuration) or 0
            if self.xmlFile:hasProperty(configKey) then
                spec.motorStartDuration = self.xmlFile:getValue(configKey .. ".motorStartDuration" , spec.motorStartDuration)
            end

            spec.minBrakeForce = self.xmlFile:getValue( "vehicle.motorized.brakeForce#force" , 0 ) * 2
            spec.maxBrakeForce = self.xmlFile:getValue( "vehicle.motorized.brakeForce#maxForce" , 0 ) * 2
            spec.maxBrakeForceMass = self.xmlFile:getValue( "vehicle.motorized.brakeForce#maxForceMass" , 0 ) / 1000
            spec.maxBrakeForceMassIncludeAttachables = self.xmlFile:getValue( "vehicle.motorized.brakeForce#includeAttachables" , false )

            spec.clutchNoEngagedWarning = self.xmlFile:getValue( "vehicle.motorized#clutchNoEngagedWarning" , "warning_motorClutchNoEngaged" , self.customEnvironment)
            spec.clutchCrackingGearWarning = self.xmlFile:getValue( "vehicle.motorized#clutchCrackingGearWarning" , "action_clutchCrackingGear" , self.customEnvironment)
            spec.clutchCrackingGroupWarning = self.xmlFile:getValue( "vehicle.motorized#clutchCrackingGroupWarning" , "action_clutchCrackingGroup" , self.customEnvironment)

            spec.turnOnText = self.xmlFile:getValue( "vehicle.motorized#turnOnText" , "action_startMotor" , self.customEnvironment)
            spec.turnOffText = self.xmlFile:getValue( "vehicle.motorized#turnOffText" , "action_stopMotor" , self.customEnvironment)

            spec.speedDisplayScale = 1
            spec.motorStartTime = 0
            spec.actualLoadPercentage = 0
            spec.smoothedLoadPercentage = 0
            spec.maxDecelerationDuringBrake = 0
            spec.blowOffValveState = 0

            spec.lastControlParameters = {
            acceleratorPedal = nil ,
            maxSpeed = nil ,
            maxAcceleration = nil ,
            minMotorRotSpeed = nil ,
            maxMotorRotSpeed = nil ,
            maxMotorRotAcceleration = nil ,
            minGearRatio = nil ,
            maxGearRatio = nil ,
            maxClutchTorque = nil ,
            neededPtoTorque = nil ,
            }

            spec.clutchCrackingTimeOut = math.huge
            spec.clutchState = 0
            spec.clutchStateSent = 0

            spec.motorState = MotorState.OFF
            spec.motorStopTimerDuration = g_gameSettings:getValue(GameSettings.SETTING.MOTOR_STOP_TIMER_DURATION)
            spec.motorStopTimer = spec.motorStopTimerDuration
            spec.motorNotRequiredTimer = 0
            spec.motorStateIgnitionTime = 0

            spec.motorTemperature = { }
            spec.motorTemperature.value = 20
            spec.motorTemperature.valueSend = 20
            spec.motorTemperature.valueMax = 120
            spec.motorTemperature.valueMin = 20
            spec.motorTemperature.heatingPerMS = 1.5 / 1000 -- delta °C per ms, at full load
            spec.motorTemperature.coolingByWindPerMS = 1.00 / 1000

            spec.motorFan = { }
            spec.motorFan.enabled = false
            spec.motorFan.enableTemperature = 95
            spec.motorFan.disableTemperature = 85
            spec.motorFan.coolingPerMS = 3.0 / 1000

            spec.lastFuelUsage = 0
            spec.lastFuelUsageDisplay = 0
            spec.lastFuelUsageDisplayTime = 0
            spec.fuelUsageBuffer = ValueBuffer.new( 250 )
            spec.lastDefUsage = 0
            spec.lastAirUsage = 0
            spec.lastVehicleDamage = 0

            spec.forceSpeedHudDisplay = self.xmlFile:getValue( "vehicle.motorized#forceSpeedHudDisplay" , false )
            spec.forceRpmHudDisplay = self.xmlFile:getValue( "vehicle.motorized#forceRpmHudDisplay" , false )

            spec.statsType = string.lower( self.xmlFile:getValue( "vehicle.motorized#statsType" , "tractor" ))
            if spec.statsType ~ = "tractor" and spec.statsType ~ = "car" and spec.statsType ~ = "truck" then
                spec.statsType = "tractor"
            end

            spec.statsTypeDistance = spec.statsType .. "Distance"

            spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.motorized.animationNodes" , self.components, self , self.i3dMappings)

            spec.traveledDistanceBuffer = 0

            spec.dirtyFlag = self:getNextDirtyFlag()
            spec.inputDirtyFlag = self:getNextDirtyFlag()

            self:registerVehicleSetting(GameSettings.SETTING.DIRECTION_CHANGE_MODE, false )
            self:registerVehicleSetting(GameSettings.SETTING.GEAR_SHIFT_MODE, false )
        end

```

### onMotorBlowOffValveChanged

**Description**

**Definition**

> onMotorBlowOffValveChanged()

**Arguments**

| any | blowOffValveState |
|-----|-------------------|

**Code**

```lua
function Motorized:onMotorBlowOffValveChanged(blowOffValveState)
    local spec = self.spec_motorized

    if blowOffValveState > 0 then
        spec.blowOffValveState = blowOffValveState

        if not g_soundManager:getIsSamplePlaying(spec.samples.blowOffValve) then
            g_soundManager:playSample(spec.samples.blowOffValve)
        end
    else
            if g_soundManager:getIsSamplePlaying(spec.samples.blowOffValve) then
                g_soundManager:stopSample(spec.samples.blowOffValve)
            end
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
function Motorized:onPostLoad(savegame)
    local spec = self.spec_motorized
    if self.isServer then
        -- refill the consumers
        local moneyChange = 0
        for _, consumer in pairs(spec.consumersByFillTypeName) do
            local fillLevel = self:getFillUnitFillLevel(consumer.fillUnitIndex)
            local minFillLevel = self:getFillUnitCapacity(consumer.fillUnitIndex) * 0.1
            if fillLevel < minFillLevel then
                local fillLevelToFill = minFillLevel - fillLevel
                self:addFillUnitFillLevel( self:getOwnerFarmId(), consumer.fillUnitIndex, fillLevelToFill, consumer.fillType, ToolType.UNDEFINED)

                local costs = fillLevelToFill * g_currentMission.economyManager:getCostPerLiter(consumer.fillType) * 2.0
                g_farmManager:updateFarmStats( self:getOwnerFarmId(), "expenses" , costs)
                g_currentMission:addMoney( - costs, self:getOwnerFarmId(), MoneyType.PURCHASE_FUEL, false , false )
                moneyChange = moneyChange + costs
            end
        end

        if moneyChange > 0 then
            g_currentMission:addMoneyChange( - moneyChange, self:getOwnerFarmId(), MoneyType.PURCHASE_FUEL, true )
        end
    end

    -- fill units required to be filled for the engine to run
        spec.propellantFillUnitIndices = { }
        for _, fillType in pairs( { FillType.DIESEL, FillType.DEF, FillType.ELECTRICCHARGE, FillType.METHANE } ) do
            local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
            if spec.consumersByFillTypeName[fillTypeName] ~ = nil then
                table.insert(spec.propellantFillUnitIndices, spec.consumersByFillTypeName[fillTypeName].fillUnitIndex)
            end
        end

        if spec.motor ~ = nil then
            spec.motor:postLoad(savegame)
        end
    end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Motorized:onReadStream(streamId, connection)
    local motorState = MotorState.readStream(streamId)
    self:setMotorState(motorState, true )
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function Motorized:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_motorized
    if connection.isServer then
        if streamReadBool(streamId) then
            local rpm = streamReadUIntN(streamId, 11 ) / 2047
            local rpmRange = spec.motor:getMaxRpm() - spec.motor:getMinRpm()
            spec.motor:setEqualizedMotorRpm( (rpm * rpmRange) + spec.motor:getMinRpm() )

            local loadPercentage = streamReadUIntN(streamId, 7 )
            spec.motor.rawLoadPercentage = loadPercentage / 127

            spec.brakeCompressor.doFill = streamReadBool(streamId)

            local clutchState = streamReadUIntN(streamId, 5 )
            spec.motor:onManualClutchChanged(clutchState / 31 )
        end

        if streamReadBool(streamId) then
            spec.motor:readGearDataFromStream(streamId)
        end
    else
            if streamReadBool(streamId) then
                if streamReadBool(streamId) then
                    spec.clutchState = streamReadUIntN(streamId, 7 ) / 127

                    spec.motor:onManualClutchChanged(spec.clutchState)

                    if spec.clutchState > 0 then
                        self:raiseActive()
                    end
                end
            end
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
function Motorized:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_motorized
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_MOTOR_STATE, self , Motorized.actionEventToggleMotorState, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
            g_inputBinding:setActionEventText(actionEventId, spec.turnOnText)

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.MOTOR_STATE_IGNITION, self , Motorized.actionEventSetMotorStateIgnition, false , true , false , true , nil )
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.MOTOR_STATE_ON, self , Motorized.actionEventSetMotorStateOn, false , true , false , true , nil )
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )

            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.MOTOR_STATE_OFF, self , Motorized.actionEventSetMotorStateOff, false , true , false , true , nil )
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )

            if spec.motor.minForwardGearRatio = = nil or spec.motor.minBackwardGearRatio = = nil then
                if self:getGearShiftMode() ~ = VehicleMotor.SHIFT_MODE_AUTOMATIC or not GS_IS_CONSOLE_VERSION then
                    if spec.motor.manualShiftGears then
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_UP, self , Motorized.actionEventShiftGear, false , true , false , true , nil )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_DOWN, self , Motorized.actionEventShiftGear, false , true , false , true , nil )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )

                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 1 , self , Motorized.actionEventSelectGear, true , true , false , true , 1 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 2 , self , Motorized.actionEventSelectGear, true , true , false , true , 2 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 3 , self , Motorized.actionEventSelectGear, true , true , false , true , 3 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 4 , self , Motorized.actionEventSelectGear, true , true , false , true , 4 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 5 , self , Motorized.actionEventSelectGear, true , true , false , true , 5 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 6 , self , Motorized.actionEventSelectGear, true , true , false , true , 6 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 7 , self , Motorized.actionEventSelectGear, true , true , false , true , 7 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GEAR_SELECT_ 8 , self , Motorized.actionEventSelectGear, true , true , false , true , 8 )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                    end

                    if spec.motor.manualShiftGroups then
                        if spec.motor.gearGroups ~ = nil then
                            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GROUP_UP, self , Motorized.actionEventShiftGroup, false , true , false , true , nil )
                            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GROUP_DOWN, self , Motorized.actionEventShiftGroup, false , true , false , true , nil )
                            g_inputBinding:setActionEventTextVisibility(actionEventId, false )

                            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GROUP_SELECT_ 1 , self , Motorized.actionEventSelectGroup, true , true , false , true , 1 )
                            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GROUP_SELECT_ 2 , self , Motorized.actionEventSelectGroup, true , true , false , true , 2 )
                            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GROUP_SELECT_ 3 , self , Motorized.actionEventSelectGroup, true , true , false , true , 3 )
                            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.SHIFT_GROUP_SELECT_ 4 , self , Motorized.actionEventSelectGroup, true , true , false , true , 4 )
                            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        end
                    end

                    _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.AXIS_CLUTCH_VEHICLE, self , Motorized.actionEventClutch, false , false , true , true , nil )
                    g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                end
            end

            if self:getDirectionChangeMode() = = VehicleMotor.DIRECTION_CHANGE_MODE_MANUAL or self:getGearShiftMode() ~ = VehicleMotor.SHIFT_MODE_AUTOMATIC then
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.DIRECTION_CHANGE, self , Motorized.actionEventDirectionChange, false , true , false , true , nil , nil , true )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.DIRECTION_CHANGE_POS, self , Motorized.actionEventDirectionChange, false , true , false , true , nil , nil , true )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.DIRECTION_CHANGE_NEG, self , Motorized.actionEventDirectionChange, false , true , false , true , nil , nil , true )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
            end

            Motorized.updateActionEvents( self )
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
function Motorized:onRegisterDashboardValueTypes()
    local spec = self.spec_motorized

    local rpm = DashboardValueType.new( "motorized" , "rpm" )
    rpm:setValue( self , "getMotorRpmReal" )
    rpm:setRange( 0 , spec.motor:getMaxRpm())
    rpm:setInterpolationSpeed( function (_, dashboard)
        return spec.motor:getMaxRpm() * 0.001
    end )
    self:registerDashboardValueType(rpm)

    local load = DashboardValueType.new( "motorized" , "load" )
    load:setValue(spec.motor, "getSmoothLoadPercentage" )
    load:setRange( 0 , 100 )
    load:setInterpolationSpeed( 100 * 0.001 )
    load:setValueFactor( 100 )
    self:registerDashboardValueType(load)

    local speed = DashboardValueType.new( "motorized" , "speed" )
    speed:setValue( self , "getLastSpeed" )
    speed:setRange( 0 , spec.motor:getMaximumForwardSpeed() * 3.6 )
    speed:setInterpolationSpeed( function (_, dashboard)
        return self:getLastSpeed() * 0.001
    end )
    self:registerDashboardValueType(speed)

    local speedDir = DashboardValueType.new( "motorized" , "speedDir" )
    speedDir:setValue( self , function () return self:getLastSpeed() * spec.motor:getDrivingDirection() end )
    speedDir:setRange( - spec.motor:getMaximumBackwardSpeed() * 3.6 , spec.motor:getMaximumForwardSpeed() * 3.6 )
    speedDir:setInterpolationSpeed( function (_, dashboard)
        return spec.motor:getMaximumForwardSpeed() * 3.6 * 0.001
    end )
    speedDir:setCenter( 0 )
    self:registerDashboardValueType(speedDir)

    local fuelUsage = DashboardValueType.new( "motorized" , "fuelUsage" )
    fuelUsage:setValue(spec, "lastFuelUsageDisplay" )
    self:registerDashboardValueType(fuelUsage)

    local motorTemperature = DashboardValueType.new( "motorized" , "motorTemperature" )
    motorTemperature:setValue(spec.motorTemperature, "value" )
    motorTemperature:setRange( "valueMin" , "valueMax" )
    motorTemperature:setInterpolationSpeed( function (motorTemperature, dashboard)
        return(motorTemperature.valueMax - motorTemperature.valueMin) * 0.001
    end )
    self:registerDashboardValueType(motorTemperature)

    local motorTemperatureWarning = DashboardValueType.new( "motorized" , "motorTemperatureWarning" )
    motorTemperatureWarning:setValue(spec.motorTemperature, function (_, dashboard)
        local motorTemperature = spec.motorTemperature.value
        return motorTemperature > dashboard.warningThresholdMin and motorTemperature < dashboard.warningThresholdMax
    end )
    motorTemperatureWarning:setAdditionalFunctions( Dashboard.warningAttributes)
    self:registerDashboardValueType(motorTemperatureWarning)

    local clutchPedal = DashboardValueType.new( "motorized" , "clutchPedal" )
    clutchPedal:setValue(spec.motor, "getSmoothedClutchPedal" )
    clutchPedal:setRange( 0 , 1 )
    self:registerDashboardValueType(clutchPedal)

    local gear = DashboardValueType.new( "motorized" , "gear" )
    gear:setValue(spec.motor, function ()
        return spec.motor:getGearToDisplay( true )
    end )
    gear:setRange( 0 , math.huge)
    gear:setPollUpdate(spec.motor.forwardGears = = nil ) -- only poll if we have no gears(CVT D/N/R)
        self:registerDashboardValueType(gear)

        local gearGroup = DashboardValueType.new( "motorized" , "gearGroup" )
        gearGroup:setValue(spec.motor, function ()
            return spec.motor:getGearGroupToDisplay( true )
        end )
        gearGroup:setRange( 0 , math.huge)
        gearGroup:setPollUpdate( false )
        self:registerDashboardValueType(gearGroup)

        local gearIndex = DashboardValueType.new( "motorized" , "gearIndex" )
        gearIndex:setValue(spec.motor, function ()
            return spec.motor.targetGear
        end )
        gearIndex:setRange( 0 , math.huge)
        gearIndex:setPollUpdate( false )
        self:registerDashboardValueType(gearIndex)

        local gearGroupIndex = DashboardValueType.new( "motorized" , "gearGroupIndex" )
        gearGroupIndex:setValue(spec.motor, function ()
            return spec.motor.activeGearGroupIndex
        end )
        gearGroupIndex:setRange( 0 , math.huge)
        gearGroupIndex:setPollUpdate( false )
        self:registerDashboardValueType(gearGroupIndex)

        local gearShiftUp = DashboardValueType.new( "motorized" , "gearShiftUp" )
        gearShiftUp:setValue(spec.motor, function (motor)
            return(g_ time - motor.lastGearChangeTime) < 200 and motor.targetGear > motor.previousGear
        end )
        self:registerDashboardValueType(gearShiftUp)

        local gearShiftDown = DashboardValueType.new( "motorized" , "gearShiftDown" )
        gearShiftDown:setValue(spec.motor, function (motor)
            return(g_ time - motor.lastGearChangeTime) < 200 and motor.targetGear < motor.previousGear
        end )
        self:registerDashboardValueType(gearShiftDown)

        local gearShiftUpDown = DashboardValueType.new( "motorized" , "gearShiftUpDown" )
        gearShiftUpDown:setValue(spec.motor, function (motor)
            if (g_ time - motor.lastGearChangeTime) < 200 then
                return math.sign(motor.targetGear - motor.previousGear)
            end

            return 0
        end )
        gearShiftUpDown:setRange( - 1 , 1 )
        self:registerDashboardValueType(gearShiftUpDown)

        local movingDirection = DashboardValueType.new( "motorized" , "movingDirection" )
        movingDirection:setValue(spec.motor, "getDrivingDirection" )
        movingDirection:setRange( - 1 , 1 )
        self:registerDashboardValueType(movingDirection)

        local directionForward = DashboardValueType.new( "motorized" , "directionForward" )
        directionForward:setValue(spec.motor, function (motor) return motor:getDrivingDirection() > = 0 end )
        self:registerDashboardValueType(directionForward)

        local directionForwardExclusive = DashboardValueType.new( "motorized" , "directionForwardExclusive" )
        directionForwardExclusive:setValue(spec.motor, function (motor) return motor:getDrivingDirection() > 0 end )
        self:registerDashboardValueType(directionForwardExclusive)

        local directionBackward = DashboardValueType.new( "motorized" , "directionBackward" )
        directionBackward:setValue(spec.motor, function (motor) return motor:getDrivingDirection() < 0 end )
        self:registerDashboardValueType(directionBackward)

        local directionNeutral = DashboardValueType.new( "motorized" , "directionNeutral" )
        directionNeutral:setValue(spec.motor, function (motor) return motor:getDrivingDirection() = = 0 end )
        self:registerDashboardValueType(directionNeutral)

        local movingDirectionLetter = DashboardValueType.new( "motorized" , "movingDirectionLetter" )
        movingDirectionLetter:setValue(spec.motor, function (motor) return motor:getDrivingDirection() = = 1 and "F" or(motor:getDrivingDirection() = = - 1 and "R" or "N" ) end )
        self:registerDashboardValueType(movingDirectionLetter)

        local ignitionState = DashboardValueType.new( "motorized" , "ignitionState" )
        ignitionState:setValue( self , function ()
            if g_ignitionLockManager:getIsAvailable() then
                local ignitionState = g_ignitionLockManager:getState()
                if ignitionState = = IgnitionLockState.OFF then
                    return 0
                elseif ignitionState = = IgnitionLockState.IGNITION then
                        return 2
                    elseif ignitionState = = IgnitionLockState.START then
                            return 1
                        end
                    else
                            local motorState = self:getMotorState()
                            if motorState = = MotorState.ON then
                                return 2
                            elseif motorState = = MotorState.STARTING then
                                    return 1
                                else
                                        return 0
                                    end
                                end
                            end )
                            ignitionState:setRange( 0 , 2 )
                            self:registerDashboardValueType(ignitionState)

                            local battery = DashboardValueType.new( "motorized" , "battery" )
                            battery:setValue( self , 12 + ( math.random() * 0.5 - 0.15 ))
                            battery:setRange( 0 , 15 )
                            battery:setInterpolationSpeed( 15 * 0.001 )
                            self:registerDashboardValueType(battery)
                        end

```

### onReverseDirectionChanged

**Description**

**Definition**

> onReverseDirectionChanged()

**Code**

```lua
function Motorized:onReverseDirectionChanged()
    if self:getDirectionChangeMode() = = VehicleMotor.DIRECTION_CHANGE_MODE_MANUAL then
        MotorGearShiftEvent.sendToServer( self , MotorGearShiftEvent.TYPE_DIRECTION_CHANGE)
    end
end

```

### onSetBroken

**Description**

**Definition**

> onSetBroken()

**Code**

```lua
function Motorized:onSetBroken()
    self:stopMotor( true )
end

```

### onStateChange

**Description**

**Definition**

> onStateChange()

**Arguments**

| any | state         |
|-----|---------------|
| any | vehicle       |
| any | isControlling |

**Code**

```lua
function Motorized:onStateChange(state, vehicle, isControlling)
    local missionInfo = g_currentMission.missionInfo
    if state = = VehicleStateChange.ENTER_VEHICLE then
        if missionInfo.automaticMotorStartEnabled then
            if not g_ignitionLockManager:getIsAvailable() then
                if self:getCanMotorRun() then
                    self:startMotor( true )
                end
            end
        end
    elseif state = = VehicleStateChange.LEAVE_VEHICLE then
            if self:getStopMotorOnLeave() and missionInfo.automaticMotorStartEnabled then
                self:stopMotor( true )
            end

            self:stopVehicle()
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
function Motorized:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_motorized

    local accInput = 0
    if self.getAxisForward ~ = nil then
        accInput = self:getAxisForward()
    end

    local motorState = self:getMotorState()
    if motorState = = MotorState.STARTING or motorState = = MotorState.ON then
        if self.isServer then
            if motorState = = MotorState.STARTING then
                if spec.motorStartTime < g_currentMission.time then
                    self:setMotorState(MotorState.ON)
                end
            end
        end

        --#profile RemoteProfiler.zoneBeginN("updateMotor")
        spec.motor:update(dt)
        --#profile RemoteProfiler.zoneEnd()

        -- client receives this information from server
        if self.isServer then
            spec.actualLoadPercentage = math.clamp(spec.motor.rawLoadPercentage, 0 , 1 )
        end

        spec.smoothedLoadPercentage = spec.motor:getSmoothLoadPercentage()

        if self.getCruiseControlState ~ = nil then
            if self:getCruiseControlState() ~ = Drivable.CRUISECONTROL_STATE_OFF then
                accInput = 1
            end
        end

        if self.isServer then
            --#profile RemoteProfiler.zoneBeginN("updateConsumers")
            self:updateConsumers(dt, accInput)
            --#profile RemoteProfiler.zoneEnd()

            -- update motor properties on damage change to update the torque reduction
            local damage = self:getVehicleDamage()
            if math.abs(damage - spec.lastVehicleDamage) > 0.05 then
                self:updateMotorProperties()
                spec.lastVehicleDamage = self:getVehicleDamage()
            end
        end

        if self.isClient then
            --#profile RemoteProfiler.zoneBeginN("updateLoopSynthesisParameters")
            -- update sounds
            local samples = spec.samples
            local rpm, minRpm, maxRpm = self:getMotorRpmReal(), spec.motor.minRpm, spec.motor.maxRpm
            local rpmPercentage = math.max( math.min((rpm - minRpm) / (maxRpm - minRpm), 1 ), 0 )
            local loadPercentage = math.max( math.min( self:getMotorLoadPercentage(), 1 ), - 1 )
            g_soundManager:setSamplesLoopSynthesisParameters(spec.motorSamples, rpmPercentage, loadPercentage)
            --#profile RemoteProfiler.zoneEnd()

            --#profile RemoteProfiler.zoneBeginN("updateSounds")
            if g_soundManager:getIsSamplePlaying(spec.motorSamples[ 1 ]) then
                -- air compressor fill sound
                if samples.airCompressorRun ~ = nil then
                    if spec.consumersByFillTypeName ~ = nil and spec.consumersByFillTypeName[ "AIR" ] ~ = nil then
                        local consumer = spec.consumersByFillTypeName[ "AIR" ]

                        if not consumer.doRefill then
                            if g_soundManager:getIsSamplePlaying(samples.airCompressorRun) then
                                g_soundManager:stopSample(samples.airCompressorRun)
                                g_soundManager:playSample(samples.airCompressorStop)
                            end
                        else
                                if not g_soundManager:getIsSamplePlaying(samples.airCompressorRun) then
                                    if samples.airCompressorStart ~ = nil then
                                        if not g_soundManager:getIsSamplePlaying(samples.airCompressorStart) and spec.brakeCompressor.playSampleRunTime = = nil then
                                            g_soundManager:playSample(samples.airCompressorStart)
                                            spec.brakeCompressor.playSampleRunTime = g_currentMission.time + samples.airCompressorStart.duration
                                        end
                                        if not g_soundManager:getIsSamplePlaying(samples.airCompressorStart) then
                                            spec.brakeCompressor.playSampleRunTime = nil
                                            g_soundManager:stopSample(samples.airCompressorStart)
                                            g_soundManager:playSample(samples.airCompressorRun)
                                        end
                                    else
                                            g_soundManager:playSample(samples.airCompressorRun)
                                        end
                                    end
                                end
                            end
                        end

                        -- random zsch sound
                        if spec.compressionSoundTime < = g_currentMission.time then
                            g_soundManager:playSample(samples.airRelease)
                            spec.compressionSoundTime = g_currentMission.time + math.random( 10000 , 40000 )
                        end

                        local isBraking = self:getDecelerationAxis() > 0 and self:getLastSpeed() > 1

                        -- brake zsch sound
                        if samples.compressedAir ~ = nil then
                            if isBraking then
                                samples.compressedAir.brakeTime = samples.compressedAir.brakeTime + dt
                            else
                                    if samples.compressedAir.brakeTime > 0 then
                                        samples.compressedAir.lastBrakeTime = samples.compressedAir.brakeTime
                                        samples.compressedAir.brakeTime = 0

                                        g_soundManager:playSample(samples.compressedAir)
                                    end
                                end
                            end

                            --brake sound
                            if samples.brake ~ = nil then
                                if isBraking then
                                    if not spec.isBrakeSamplePlaying then
                                        g_soundManager:playSample(samples.brake)
                                        spec.isBrakeSamplePlaying = true
                                    end
                                else
                                        if spec.isBrakeSamplePlaying then
                                            g_soundManager:stopSample(samples.brake)
                                            spec.isBrakeSamplePlaying = false
                                        end
                                    end
                                end

                                -- reverse driving beep
                                if samples.reverseDrive ~ = nil then
                                    local reverserDirection = self.getReverserDirection = = nil and 1 or self:getReverserDirection()
                                    local isReverseDriving = self:getLastSpeed() > spec.reverseDriveThreshold and self.movingDirection ~ = reverserDirection
                                    if not g_soundManager:getIsSamplePlaying(samples.reverseDrive) and isReverseDriving then
                                        g_soundManager:playSample(samples.reverseDrive)
                                    elseif not isReverseDriving then
                                            g_soundManager:stopSample(samples.reverseDrive)
                                        end
                                    end
                                end
                                --#profile RemoteProfiler.zoneEnd()

                                --#profile RemoteProfiler.zoneBeginN("updateLevers")
                                for state, gearLeverInterpolator in pairs(spec.activeGearLeverInterpolators) do
                                    local currentInterpolation = gearLeverInterpolator.interpolations[gearLeverInterpolator.currentInterpolation]
                                    if currentInterpolation ~ = nil then
                                        if gearLeverInterpolator.handsOnDelay > 0 then
                                            gearLeverInterpolator.handsOnDelay = gearLeverInterpolator.handsOnDelay - dt

                                            if gearLeverInterpolator.handsOnDelay < = 0 then
                                                local sample = gearLeverInterpolator.isGear and spec.samples.gearLeverStart or spec.samples.gearGroupLeverStart
                                                if not g_soundManager:getIsSamplePlaying(sample) then
                                                    g_soundManager:playSample(sample)
                                                end
                                            end

                                            if self.setCharacterTargetNodeStateDirty ~ = nil then
                                                self:setCharacterTargetNodeStateDirty(state.node, true )
                                            end
                                        else
                                                state.curRotation[ 1 ], state.curRotation[ 2 ], state.curRotation[ 3 ] = getRotation(state.node)
                                                local limit = math.min
                                                if currentInterpolation.speed < 0 then
                                                    limit = math.max
                                                end

                                                state.curRotation[currentInterpolation.axis] = limit(state.curRotation[currentInterpolation.axis] + currentInterpolation.speed * dt, currentInterpolation.tar)
                                                setRotation(state.node, state.curRotation[ 1 ], state.curRotation[ 2 ], state.curRotation[ 3 ])

                                                if state.curRotation[currentInterpolation.axis] = = currentInterpolation.tar then
                                                    gearLeverInterpolator.currentInterpolation = gearLeverInterpolator.currentInterpolation + 1
                                                    if gearLeverInterpolator.currentInterpolation > #gearLeverInterpolator.interpolations then
                                                        spec.activeGearLeverInterpolators[state] = nil

                                                        if gearLeverInterpolator.isResetPosition then
                                                            if self.resetCharacterTargetNodeStateDefaults ~ = nil then
                                                                self:resetCharacterTargetNodeStateDefaults(state.node)
                                                            end
                                                        end

                                                        local sample = gearLeverInterpolator.isGear and spec.samples.gearLeverEnd or spec.samples.gearGroupLeverEnd
                                                        if not g_soundManager:getIsSamplePlaying(sample) then
                                                            g_soundManager:playSample(sample)
                                                        end
                                                    end
                                                end

                                                if self.setCharacterTargetNodeStateDirty ~ = nil then
                                                    self:setCharacterTargetNodeStateDirty(state.node)
                                                end
                                            end
                                        else
                                                spec.activeGearLeverInterpolators[state] = nil
                                            end
                                        end
                                        --#profile RemoteProfiler.zoneEnd()
                                    end

                                    if self.isServer then
                                        if not self:getIsAIActive() and self:getTraveledDistanceStatsActive() then
                                            if self.lastMovedDistance > 0.001 then
                                                spec.traveledDistanceBuffer = spec.traveledDistanceBuffer + self.lastMovedDistance
                                                if spec.traveledDistanceBuffer > 10 then
                                                    local farmId = self:getOwnerFarmId()
                                                    local distance = spec.traveledDistanceBuffer * 0.001
                                                    g_farmManager:updateFarmStats(farmId, "traveledDistance" , distance)
                                                    g_farmManager:updateFarmStats(farmId, spec.statsTypeDistance, distance)
                                                    spec.traveledDistanceBuffer = 0
                                                end
                                            end
                                        end
                                    end
                                end
                            end

```

### onUpdateTick

**Description**

> Called on update tick

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
function Motorized:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_motorized

    local missionInfo = g_currentMission.missionInfo
    local automaticMotorStartEnabled = missionInfo.automaticMotorStartEnabled

    if self.isServer then
        -- force stop of motor if player is far away from vehicle for a certain amount of time
            if not automaticMotorStartEnabled then
                local motorState = self:getMotorState()
                if (motorState = = MotorState.STARTING or motorState = = MotorState.ON) and not self:getIsAIActive() then

                    local isEntered = self.getIsEntered ~ = nil and self:getIsEntered()
                    local isControlled = self.getIsControlled ~ = nil and self:getIsControlled()

                    if not isEntered and not isControlled then

                        local isPlayerInRange = false

                        for _, player in pairs(g_currentMission.playerSystem.players) do
                            if player.isControlled then
                                local distance = calcDistanceFrom( self.rootNode, player.rootNode)
                                if distance < 250 then
                                    isPlayerInRange = true
                                    break
                                end
                            end
                        end
                        if not isPlayerInRange then
                            for _, enterable in pairs(g_currentMission.vehicleSystem.enterables) do
                                if enterable:getIsInUse( nil ) then
                                    local distance = calcDistanceFrom( self.rootNode, enterable.rootNode)
                                    if distance < 250 then
                                        isPlayerInRange = true
                                        break
                                    end
                                end
                            end
                        end

                        if isPlayerInRange then
                            spec.motorStopTimer = spec.motorStopTimerDuration
                        else
                                spec.motorStopTimer = spec.motorStopTimer - dt
                                if spec.motorStopTimer < = 0 then
                                    self:stopMotor()
                                end
                            end

                        end
                    end
                end

                local motorState = self:getMotorState()
                if motorState = = MotorState.STARTING or motorState = = MotorState.ON then
                    self:updateMotorTemperature(dt)
                end

                if automaticMotorStartEnabled then
                    if motorState = = MotorState.OFF or motorState = = MotorState.IGNITION then
                        -- while the ignition lock is connected it is required to be used for turn on
                            if not g_ignitionLockManager:getIsAvailable() then
                                --start motor if fuel was empty and got filled
                                    --also starts the motor again when we toggle the automatic motor start option
                                    if ( self.getIsControlled ~ = nil and self:getIsControlled())
                                        or( self.getIsEnteredForInput ~ = nil and self:getIsEnteredForInput()) then
                                        if self:getCanMotorRun() then
                                            self:startMotor( true )
                                        end
                                    end

                                    -- start the motor when power is required but no one is entered
                                    if self:getRequiresPower() then
                                        if self:getCanMotorRun() then
                                            self:startMotor( true )
                                        end
                                    end
                                end
                            else
                                    if ( self.getIsControlled ~ = nil and not self:getIsControlled())
                                        and( self.getIsEnteredForInput ~ = nil and not self:getIsEnteredForInput()) then
                                        -- turn motor off again if it's not required to keep it running
                                            if self:getStopMotorOnLeave() then
                                                spec.motorNotRequiredTimer = spec.motorNotRequiredTimer + dt
                                                if spec.motorNotRequiredTimer > 250 then
                                                    self:stopMotor( true )
                                                end
                                            end

                                            -- keep vehicle active as long as to motor is running
                                            -- so we can turn it off while it's not required anymore
                                                self:raiseActive()
                                            end
                                        end
                                    end
                                end

                                if self.isClient then
                                    local motorState = self:getMotorState()
                                    if motorState = = MotorState.STARTING or motorState = = MotorState.ON then
                                        local rpmScale = self:getMotorRpmReal() / spec.motor:getMaxRpm()

                                        if spec.exhaustParticleSystems ~ = nil then
                                            for _, ps in pairs(spec.exhaustParticleSystems) do
                                                local scale = MathUtil.lerp(spec.exhaustParticleSystems.minScale, spec.exhaustParticleSystems.maxScale, rpmScale)
                                                ParticleUtil.setEmitCountScale(spec.exhaustParticleSystems, scale)
                                                ParticleUtil.setParticleLifespan(ps, ps.originalLifespan * scale)
                                            end
                                        end

                                        for _, exhaustFlap in ipairs(spec.exhaustFlaps) do
                                            local minRandom = - 0.1
                                            local maxRandom = 0.1
                                            local state = math.clamp( MathUtil.lerp(minRandom, maxRandom, math.random()) + rpmScale, 0 , 1 )
                                            local angle = state * exhaustFlap.maxRot

                                            if exhaustFlap.rotationAxis = = 1 then
                                                setRotation(exhaustFlap.node, angle, 0 , 0 )
                                            elseif exhaustFlap.rotationAxis = = 2 then
                                                    setRotation(exhaustFlap.node, 0 , angle, 0 )
                                                else
                                                        setRotation(exhaustFlap.node, 0 , 0 , angle)
                                                    end
                                                end

                                                if spec.effects ~ = nil then
                                                    g_effectManager:setDensity(spec.effects, rpmScale)
                                                end

                                                if spec.exhaustEffects ~ = nil then
                                                    for _, effect in pairs(spec.exhaustEffects) do
                                                        local posX, posY, posZ = localToWorld(effect.effectNode, 0 , 0.5 , 0 )
                                                        if effect.lastPosition = = nil then
                                                            effect.lastPosition = { posX, posY, posZ }
                                                        end

                                                        local vx = (posX - effect.lastPosition[ 1 ]) * 10
                                                        local vy = (posY - effect.lastPosition[ 2 ]) * 10
                                                        local vz = (posZ - effect.lastPosition[ 3 ]) * 10

                                                        local ex, ey, ez = localToWorld(effect.effectNode, 0 , 1 , 0 )
                                                        vx, vy, vz = ex - vx, ey - vy + effect.upFactor, ez - vz

                                                        local lx, ly, lz = worldToLocal(effect.effectNode, vx, vy, vz)

                                                        local distance = MathUtil.vector2Length(lx, lz)
                                                        if distance > 0 then
                                                            lx, lz = MathUtil.vector2Normalize(lx, lz)
                                                        end

                                                        ly = math.abs( math.max(ly, 0.01 ))

                                                        local xFactor = math.atan(distance / ly) * ( 1.2 + 2 * ly)
                                                        local yFactor = math.atan(distance / ly) * ( 1.2 + 2 * ly)

                                                        local xRot = math.atan(lz / ly) * xFactor
                                                        local zRot = - math.atan(lx / ly) * yFactor

                                                        effect.xRot = effect.xRot * 0.95 + xRot * 0.05
                                                        effect.zRot = effect.zRot * 0.95 + zRot * 0.05

                                                        local scale = MathUtil.lerp(effect.minRpmScale, effect.maxRpmScale, rpmScale)

                                                        setShaderParameter(effect.effectNode, "param" , effect.xRot, effect.zRot, 0 , scale, false )

                                                        local r = MathUtil.lerp(effect.minRpmColor[ 1 ], effect.maxRpmColor[ 1 ], rpmScale)
                                                        local g = MathUtil.lerp(effect.minRpmColor[ 2 ], effect.maxRpmColor[ 2 ], rpmScale)
                                                        local b = MathUtil.lerp(effect.minRpmColor[ 3 ], effect.maxRpmColor[ 3 ], rpmScale)
                                                        local a = MathUtil.lerp(effect.minRpmColor[ 4 ], effect.maxRpmColor[ 4 ], rpmScale)
                                                        setShaderParameter(effect.effectNode, "exhaustColor" , r, g, b, a, false )

                                                        effect.lastPosition[ 1 ] = posX
                                                        effect.lastPosition[ 2 ] = posY
                                                        effect.lastPosition[ 3 ] = posZ
                                                    end
                                                end

                                                spec.lastFuelUsageDisplayTime = spec.lastFuelUsageDisplayTime + dt
                                                if spec.lastFuelUsageDisplayTime > 250 then
                                                    spec.lastFuelUsageDisplayTime = 0
                                                    spec.lastFuelUsageDisplay = spec.fuelUsageBuffer:getAverage()
                                                end

                                                spec.fuelUsageBuffer:add(spec.lastFuelUsage)
                                            end

                                            if spec.clutchCrackingTimeOut < g_ time then
                                                if g_soundManager:getIsSamplePlaying(spec.samples.clutchCracking) then
                                                    g_soundManager:stopSample(spec.samples.clutchCracking)
                                                end

                                                if spec.clutchCrackingGearIndex ~ = nil then
                                                    self:setGearLeversState( 0 , nil , 500 )
                                                end

                                                if spec.clutchCrackingGroupIndex ~ = nil then
                                                    self:setGearLeversState( nil , 0 , 500 )
                                                end

                                                spec.clutchCrackingTimeOut = math.huge
                                            end

                                            -- display permanent fuel empty warning if automatic motor start is enabled
                                                if isActiveForInputIgnoreSelection then
                                                    if automaticMotorStartEnabled then
                                                        if not self:getCanMotorRun() then
                                                            local warning = self:getMotorNotAllowedWarning()
                                                            if warning ~ = nil then
                                                                g_currentMission:showBlinkingWarning(warning, 2000 )
                                                            end
                                                        end
                                                    end

                                                    if g_ignitionLockManager:getIsAvailable() then
                                                        if not self:getIsAIActive() then
                                                            local ignitionState = g_ignitionLockManager:getState()
                                                            -- get the current state
                                                            motorState = self:getMotorState()

                                                            if ignitionState = = IgnitionLockState.OFF then
                                                                -- if ignition lock is off also turn the motor if it was in a differnt state
                                                                    if motorState ~ = MotorState.OFF then
                                                                        self:setMotorState(MotorState.OFF)
                                                                    end
                                                                elseif ignitionState = = IgnitionLockState.IGNITION then
                                                                        -- ignition lock is in ignition state only change the motor state if it is off
                                                                            -- in reallife the motor state also does not change if the lock snaps back from start to ignition state
                                                                                if motorState = = MotorState.OFF then
                                                                                    self:setMotorState(MotorState.IGNITION)
                                                                                end
                                                                            elseif ignitionState = = IgnitionLockState.START then
                                                                                    -- if motor was off or in ignition start it now
                                                                                        if motorState ~ = MotorState.STARTING and motorState ~ = MotorState.ON then
                                                                                            if self:getCanMotorRun() then
                                                                                                self:setMotorState(MotorState.STARTING)
                                                                                            else
                                                                                                    local warning = self:getMotorNotAllowedWarning()
                                                                                                    if warning ~ = nil then
                                                                                                        g_currentMission:showBlinkingWarning(warning, 2000 )
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end

                                                                                Motorized.updateActionEvents( self )
                                                                            end
                                                                        end
                                                                    end

```

### onVehicleSettingChanged

**Description**

**Definition**

> onVehicleSettingChanged()

**Arguments**

| any | gameSettingId |
|-----|---------------|
| any | state         |

**Code**

```lua
function Motorized:onVehicleSettingChanged(gameSettingId, state)
    local spec = self.spec_motorized
    local motor = spec.motor

    if gameSettingId = = GameSettings.SETTING.DIRECTION_CHANGE_MODE then
        spec.directionChangeMode = state
        if motor ~ = nil then
            motor:setDirectionChangeMode(state)

            self:requestActionEventUpdate()
        end
    end

    if gameSettingId = = GameSettings.SETTING.GEAR_SHIFT_MODE then
        spec.gearShiftMode = state
        if not self:getIsAIActive() then
            if motor ~ = nil then
                motor:setGearShiftMode(state)

                self:requestActionEventUpdate()
            end
        end
    end
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Motorized:onWriteStream(streamId, connection)
    MotorState.writeStream(streamId, self.spec_motorized.motorState)
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function Motorized:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_motorized
    if not connection.isServer then
        local motorState = self:getMotorState()
        if streamWriteBool(streamId, motorState = = MotorState.STARTING or motorState = = MotorState.ON) then
            local rpmRange = spec.motor:getMaxRpm() - spec.motor:getMinRpm()
            local rpm = math.clamp((spec.motor:getEqualizedMotorRpm() - spec.motor:getMinRpm()) / rpmRange, 0 , 1 )

            rpm = math.floor(rpm * 2047 )
            streamWriteUIntN(streamId, rpm, 11 )
            streamWriteUIntN(streamId, 127 * spec.actualLoadPercentage, 7 )
            streamWriteBool(streamId, spec.brakeCompressor.doFill)
            streamWriteUIntN(streamId, 31 * spec.motor:getClutchPedal(), 5 )
        end

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            spec.motor:writeGearDataToStream(streamId)
        end
    else
            if streamWriteBool(streamId, bit32.band(dirtyMask, spec.inputDirtyFlag) ~ = 0 ) then
                if streamWriteBool(streamId, spec.clutchState ~ = spec.clutchStateSent) then
                    streamWriteUIntN(streamId, 127 * spec.clutchState, 7 )
                    spec.clutchStateSent = spec.clutchState
                end
            end
        end
    end

```

### prerequisitesPresent

**Description**

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function Motorized.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and SpecializationUtil.hasSpecialization( VehicleSettings , specializations)
end

```

### registerConsumerXMLPaths

**Description**

**Definition**

> registerConsumerXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | baseKey |

**Code**

```lua
function Motorized.registerConsumerXMLPaths(schema, baseKey)
    schema:register(XMLValueType.L10N_STRING, baseKey .. "#consumersEmptyWarning" , "Consumers empty warning" , "warning_motorFuelEmpty" )
    schema:register(XMLValueType.INT, baseKey .. ".consumer(?)#fillUnitIndex" , "Fill unit index" , 1 )
    schema:register(XMLValueType.STRING, baseKey .. ".consumer(?)#fillType" , "Fill type name" )
    schema:register(XMLValueType.FLOAT, baseKey .. ".consumer(?)#usage" , "Usage in l/h" , 1 )
    schema:register(XMLValueType.BOOL, baseKey .. ".consumer(?)#permanentConsumption" , "Do permanent consumption" , 1 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".consumer(?)#refillLitersPerSecond" , "Refill liters per second" , 0 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".consumer(?)#refillCapacityPercentage" , "Refill capacity percentage" , 0 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".consumer(?)#capacity" , "If defined the capacity of the fillUnit fill be overwritten with this value" )
end

```

### registerDifferentialXMLPaths

**Description**

**Definition**

> registerDifferentialXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | baseKey |

**Code**

```lua
function Motorized.registerDifferentialXMLPaths(schema, baseKey)
    schema:register(XMLValueType.FLOAT, baseKey .. ".differentials.differential(?)#torqueRatio" , "Torque ratio" , 0.5 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".differentials.differential(?)#maxSpeedRatio" , "Max.speed ratio" , 1.3 )

    schema:register(XMLValueType.INT, baseKey .. ".differentials.differential(?)#wheelIndex1" , "Wheel index 1" )
    schema:register(XMLValueType.INT, baseKey .. ".differentials.differential(?)#wheelIndex2" , "Wheel index 2" )
    schema:register(XMLValueType.INT, baseKey .. ".differentials.differential(?)#differentialIndex1" , "Differential index 1" )
    schema:register(XMLValueType.INT, baseKey .. ".differentials.differential(?)#differentialIndex2" , "Differential index 2" )
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
function Motorized.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterDashboardValueTypes" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onSetBroken" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onGearDirectionChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onGearChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onGearGroupChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onMotorBlowOffValveChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onClutchCreaking" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onReverseDirectionChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onVehicleSettingChanged" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onAIJobStarted" , Motorized )
    SpecializationUtil.registerEventListener(vehicleType, "onAIJobFinished" , Motorized )
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
function Motorized.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onStartMotor" )
    SpecializationUtil.registerEvent(vehicleType, "onStopMotor" )
    SpecializationUtil.registerEvent(vehicleType, "onGearDirectionChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onGearChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onGearGroupChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onMotorBlowOffValveChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onClutchCreaking" )
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
function Motorized.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadDifferentials" , Motorized.loadDifferentials)
    SpecializationUtil.registerFunction(vehicleType, "loadMotor" , Motorized.loadMotor)
    SpecializationUtil.registerFunction(vehicleType, "loadGears" , Motorized.loadGears)
    SpecializationUtil.registerFunction(vehicleType, "loadGearGroups" , Motorized.loadGearGroups)
    SpecializationUtil.registerFunction(vehicleType, "loadExhaustEffects" , Motorized.loadExhaustEffects)
    SpecializationUtil.registerFunction(vehicleType, "onExhaustEffectI3DLoaded" , Motorized.onExhaustEffectI3DLoaded)
    SpecializationUtil.registerFunction(vehicleType, "loadSounds" , Motorized.loadSounds)
    SpecializationUtil.registerFunction(vehicleType, "loadConsumerConfiguration" , Motorized.loadConsumerConfiguration)
    SpecializationUtil.registerFunction(vehicleType, "setMotorState" , Motorized.setMotorState)
    SpecializationUtil.registerFunction(vehicleType, "getMotorState" , Motorized.getMotorState)
    SpecializationUtil.registerFunction(vehicleType, "getIsMotorStarted" , Motorized.getIsMotorStarted)
    SpecializationUtil.registerFunction(vehicleType, "getIsMotorInNeutral" , Motorized.getIsMotorInNeutral)
    SpecializationUtil.registerFunction(vehicleType, "getCanMotorRun" , Motorized.getCanMotorRun)
    SpecializationUtil.registerFunction(vehicleType, "getStopMotorOnLeave" , Motorized.getStopMotorOnLeave)
    SpecializationUtil.registerFunction(vehicleType, "getMotorNotAllowedWarning" , Motorized.getMotorNotAllowedWarning)
    SpecializationUtil.registerFunction(vehicleType, "startMotor" , Motorized.startMotor)
    SpecializationUtil.registerFunction(vehicleType, "stopMotor" , Motorized.stopMotor)
    SpecializationUtil.registerFunction(vehicleType, "updateMotorProperties" , Motorized.updateMotorProperties)
    SpecializationUtil.registerFunction(vehicleType, "controlVehicle" , Motorized.controlVehicle)
    SpecializationUtil.registerFunction(vehicleType, "updateConsumers" , Motorized.updateConsumers)
    SpecializationUtil.registerFunction(vehicleType, "updateMotorTemperature" , Motorized.updateMotorTemperature)
    SpecializationUtil.registerFunction(vehicleType, "getMotor" , Motorized.getMotor)
    SpecializationUtil.registerFunction(vehicleType, "getMotorStartTime" , Motorized.getMotorStartTime)
    SpecializationUtil.registerFunction(vehicleType, "getMotorType" , Motorized.getMotorType)
    SpecializationUtil.registerFunction(vehicleType, "getMotorRpmPercentage" , Motorized.getMotorRpmPercentage)
    SpecializationUtil.registerFunction(vehicleType, "getMotorRpmReal" , Motorized.getMotorRpmReal)
    SpecializationUtil.registerFunction(vehicleType, "getMotorLoadPercentage" , Motorized.getMotorLoadPercentage)
    SpecializationUtil.registerFunction(vehicleType, "getMotorBlowOffValveState" , Motorized.getMotorBlowOffValveState)
    SpecializationUtil.registerFunction(vehicleType, "getMotorDifferentialSpeed" , Motorized.getMotorDifferentialSpeed)
    SpecializationUtil.registerFunction(vehicleType, "getConsumerFillUnitIndex" , Motorized.getConsumerFillUnitIndex)
    SpecializationUtil.registerFunction(vehicleType, "getAirConsumerUsage" , Motorized.getAirConsumerUsage)
    SpecializationUtil.registerFunction(vehicleType, "getTraveledDistanceStatsActive" , Motorized.getTraveledDistanceStatsActive)
    SpecializationUtil.registerFunction(vehicleType, "setGearLeversState" , Motorized.setGearLeversState)
    SpecializationUtil.registerFunction(vehicleType, "generateShiftAnimation" , Motorized.generateShiftAnimation)
    SpecializationUtil.registerFunction(vehicleType, "getGearInfoToDisplay" , Motorized.getGearInfoToDisplay)
    SpecializationUtil.registerFunction(vehicleType, "setTransmissionDirection" , Motorized.setTransmissionDirection)
    SpecializationUtil.registerFunction(vehicleType, "getDirectionChangeMode" , Motorized.getDirectionChangeMode)
    SpecializationUtil.registerFunction(vehicleType, "getIsManualDirectionChangeAllowed" , Motorized.getIsManualDirectionChangeAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getIsManualDirectionChangeActive" , Motorized.getIsManualDirectionChangeActive)
    SpecializationUtil.registerFunction(vehicleType, "getGearShiftMode" , Motorized.getGearShiftMode)
    SpecializationUtil.registerFunction(vehicleType, "stopVehicle" , Motorized.stopVehicle)
end

```

### registerMotorXMLPaths

**Description**

**Definition**

> registerMotorXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | baseKey |

**Code**

```lua
function Motorized.registerMotorXMLPaths(schema, baseKey)
    schema:register(XMLValueType.STRING, baseKey .. ".motor#type" , "Motor type" , "vehicle" )
    schema:register(XMLValueType.STRING, baseKey .. ".motor#startAnimationName" , "Motor start animation" , "vehicle" )

    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#minRpm" , "Min.RPM" , 1000 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#maxRpm" , "Max.RPM" , 1800 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#minSpeed" , "Min.driving speed" , 1 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#maxForwardSpeed" , "Max.forward speed" )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#maxBackwardSpeed" , "Max.backward speed" )

    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#accelerationLimit" , "Acceleration limit" , 2.0 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#brakeForce" , "Brake force" , 10 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#lowBrakeForceScale" , "Low brake force scale" , 0.5 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#lowBrakeForceSpeedLimit" , "Low brake force speed limit(below this speed the lowBrakeForceScale is activated)" , 1 )
    schema:register(XMLValueType.FLOAT, baseKey .. ".motor#torqueScale" , "Scale factor for torque curve" , 1 )
        schema:register(XMLValueType.FLOAT, baseKey .. ".motor#ptoMotorRpmRatio" , "PTO to motor rpm ratio" , 4 )

        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission#minForwardGearRatio" , "Min.forward gear ratio" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission#maxForwardGearRatio" , "Max.forward gear ratio" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission#minBackwardGearRatio" , "Min.backward gear ratio" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission#maxBackwardGearRatio" , "Max.backward gear ratio" )
        schema:register(XMLValueType.TIME, baseKey .. ".transmission#gearChangeTime" , "Gear change time" )
        schema:register(XMLValueType.TIME, baseKey .. ".transmission#autoGearChangeTime" , "Auto gear change time" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission#axleRatio" , "Axle ratio" , 1 )
        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission#startGearThreshold" , "Adjusts which gear is used as start gear" , VehicleMotor.GEAR_START_THRESHOLD)

        schema:register(XMLValueType.FLOAT, baseKey .. ".motor.torque(?)#normRpm" , "Norm RPM(0-1)" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".motor.torque(?)#rpm" , "RPM" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".motor.torque(?)#torque" , "Torque" )

        schema:register(XMLValueType.FLOAT, baseKey .. ".motor#rotInertia" , "Rotation inertia" , "Peak.motor torque / 600" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".motor#dampingRateScale" , "Scales motor damping rate" , 1 )

        schema:register(XMLValueType.FLOAT, baseKey .. ".motor#rpmSpeedLimit" , "Motor rotation acceleration limit" )

        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission.forwardGear(?)#gearRatio" , "Gear ratio" )
        schema:register(XMLValueType.FLOAT, baseKey .. ".transmission.forwardGear(?)#maxSpeed" , "Gear ratio" )
        schema:register(XMLValueType.BOOL, baseKey .. ".transmission.forwardGear(?)#defaultGear" , "Gear ratio" )
        schema:register(XMLValueType.STRING, baseKey .. ".transmission.forwardGear(?)#name" , "Gear name to display" )
        schema:register(XMLValueType.STRING, baseKey .. ".transmission.forwardGear(?)#reverseName" , "Gear name to display(if reverse direction is active)" )
            schema:register(XMLValueType.STRING, baseKey .. ".transmission.forwardGear(?)#dashboardName" , "Gear name to display in dashboard" )
            schema:register(XMLValueType.STRING, baseKey .. ".transmission.forwardGear(?)#dashboardReverseName" , "Gear name to display in dashboard(if reverse direction is active)" )
                schema:register(XMLValueType.STRING, baseKey .. ".transmission.forwardGear(?)#actionName" , "Input Action to select this gear" , "SHIFT_GEAR_SELECT_X" )
                schema:register(XMLValueType.FLOAT, baseKey .. ".transmission.backwardGear(?)#gearRatio" , "Gear ratio" )
                schema:register(XMLValueType.FLOAT, baseKey .. ".transmission.backwardGear(?)#maxSpeed" , "Gear ratio" )
                schema:register(XMLValueType.BOOL, baseKey .. ".transmission.backwardGear(?)#defaultGear" , "Gear ratio" )
                schema:register(XMLValueType.STRING, baseKey .. ".transmission.backwardGear(?)#name" , "Gear name to display" )
                schema:register(XMLValueType.STRING, baseKey .. ".transmission.backwardGear(?)#reverseName" , "Gear name to display(if reverse direction is active)" )
                    schema:register(XMLValueType.STRING, baseKey .. ".transmission.backwardGear(?)#dashboardName" , "Gear name to display in dashboard" )
                    schema:register(XMLValueType.STRING, baseKey .. ".transmission.backwardGear(?)#dashboardReverseName" , "Gear name to display in dashboard(if reverse direction is active)" )
                        schema:register(XMLValueType.STRING, baseKey .. ".transmission.backwardGear(?)#actionName" , "Input Action to select this gear" , "SHIFT_GEAR_SELECT_X" )

                        schema:register(XMLValueType.STRING, baseKey .. ".transmission.groups#type" , "Type of groups(powershift/default)" , "default" )
                        schema:register(XMLValueType.TIME, baseKey .. ".transmission.groups#changeTime" , "Change time if default type" , 0.5 )
                            schema:register(XMLValueType.FLOAT, baseKey .. ".transmission.groups.group(?)#ratio" , "Ratio while stage active" )
                                schema:register(XMLValueType.BOOL, baseKey .. ".transmission.groups.group(?)#isDefault" , "Is default stage" , false )
                                schema:register(XMLValueType.STRING, baseKey .. ".transmission.groups.group(?)#name" , "Gear name to display" )
                                schema:register(XMLValueType.STRING, baseKey .. ".transmission.groups.group(?)#dashboardName" , "Gear name to display in dashboard" )
                                schema:register(XMLValueType.STRING, baseKey .. ".transmission.groups.group(?)#actionName" , "Input Action to select this group" , "SHIFT_GROUP_SELECT_X" )

                                schema:register(XMLValueType.BOOL, baseKey .. ".transmission.directionChange#useGroup" , "Use group as reverse change" , false )
                                schema:register(XMLValueType.INT, baseKey .. ".transmission.directionChange#reverseGroupIndex" , "Group will be activated while direction is changed" , 1 )
                                    schema:register(XMLValueType.BOOL, baseKey .. ".transmission.directionChange#useGear" , "Use gear as reverse change" , false )
                                    schema:register(XMLValueType.INT, baseKey .. ".transmission.directionChange#reverseGearIndex" , "Gear will be activated while direction is changed" , 1 )
                                        schema:register(XMLValueType.TIME, baseKey .. ".transmission.directionChange#changeTime" , "Direction change time" , 0.5 )

                                        schema:register(XMLValueType.BOOL, baseKey .. ".transmission.manualShift#gears" , "Defines if gears can be shifted manually" , true )
                                            schema:register(XMLValueType.BOOL, baseKey .. ".transmission.manualShift#groups" , "Defines if groups can be shifted manually" , true )

                                                schema:register(XMLValueType.L10N_STRING, baseKey .. ".transmission#name" , "Name of transmission to display in the shop" )
                                                schema:register(XMLValueType.STRING, baseKey .. ".transmission#param" , "Parameter to insert in transmission name" )

                                                schema:register(XMLValueType.FLOAT, baseKey .. ".motorStartDuration" , "Motor start duration" , "Duration motor takes to start.After this time player can start to drive" )
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
function Motorized.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getBrakeForce" , Motorized.getBrakeForce)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , Motorized.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , Motorized.removeFromPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsOperating" , Motorized.getIsOperating)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDeactivateOnLeave" , Motorized.getDeactivateOnLeave)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDeactivateLightsOnLeave" , Motorized.getDeactivateLightsOnLeave)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadDashboardGroupFromXML" , Motorized.loadDashboardGroupFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsDashboardGroupActive" , Motorized.getIsDashboardGroupActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsActiveForInteriorLights" , Motorized.getIsActiveForInteriorLights)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsActiveForWipers" , Motorized.getIsActiveForWipers)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getUsageCausesDamage" , Motorized.getUsageCausesDamage)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getName" , Motorized.getName)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Motorized.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsPowered" , Motorized.getIsPowered)
end

```

### registerSoundXMLPaths

**Description**

**Definition**

> registerSoundXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | baseKey |

**Code**

```lua
function Motorized.registerSoundXMLPaths(schema, baseKey)
    SoundManager.registerSampleXMLPaths(schema, baseKey, "motorStart" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "motorStop" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearbox(?)" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "clutchCracking" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearEngaged" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearDisengaged" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearLeverStart" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearLeverEnd" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearGroupLeverStart" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearGroupLeverEnd" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearRangeChange" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "gearGroupChange" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "blowOffValve" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "retarder" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "motor(?)" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "airCompressorStart" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "airCompressorStop" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "airCompressorRun" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "compressedAir" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "airRelease" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "reverseDrive" )
    SoundManager.registerSampleXMLPaths(schema, baseKey, "brake" )
end

```

### removeFromPhysics

**Description**

**Definition**

> removeFromPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Motorized:removeFromPhysics(superFunc)
    if self.isServer then
        local spec = self.spec_motorized

        if spec.motorizedNode ~ = nil then
            if next(spec.differentials) ~ = nil then
                removeAllDifferentials(spec.motorizedNode)
            end
        end
    end

    if not superFunc( self ) then
        return false
    end

    return true
end

```

### setGearLeversState

**Description**

**Definition**

> setGearLeversState()

**Arguments**

| any | gear            |
|-----|-----------------|
| any | group           |
| any | time            |
| any | isResetPosition |

**Code**

```lua
function Motorized:setGearLeversState(gear, group, time , isResetPosition)
    local spec = self.spec_motorized
    for i = 1 , #spec.gearLevers do
        local gearLever = spec.gearLevers[i]
        for j = 1 , #gearLever.states do
            local state = gearLever.states[j]
            if (state.gear ~ = nil and state.gear = = gear) or(state.group ~ = nil and state.group = = group) then
                self:generateShiftAnimation(gearLever, state, time , isResetPosition)
            end
        end
    end
end

```

### setTransmissionDirection

**Description**

> Switches the gear ratios by the given direction

**Definition**

> setTransmissionDirection(integer direction)

**Arguments**

| integer | direction | direction |
|---------|-----------|-----------|

**Code**

```lua
function Motorized:setTransmissionDirection(direction)
    local motor = self.spec_motorized.motor
    if motor ~ = nil then
        motor:setTransmissionDirection(direction)
    end
end

```

### startMotor

**Description**

> Start motor

**Definition**

> startMotor(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function Motorized:startMotor(noEventSend)
    local motorState = self:getMotorState()
    if motorState = = MotorState.OFF or motorState = = MotorState.IGNITION then
        MotorSetTurnedOnEvent.sendEvent( self , true , noEventSend)
        self:setMotorState(MotorState.STARTING, true )
    end
end

```

### stopMotor

**Description**

> Stop motor

**Definition**

> stopMotor(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function Motorized:stopMotor(noEventSend)
    local motorState = self:getMotorState()
    if motorState = = MotorState.ON or motorState = = MotorState.STARTING then
        MotorSetTurnedOnEvent.sendEvent( self , false , noEventSend)
        self:setMotorState(MotorState.OFF, true )
    end
end

```

### stopVehicle

**Description**

**Definition**

> stopVehicle()

**Code**

```lua
function Motorized:stopVehicle()
    if self.isServer then
        local spec = self.spec_motorized
        if spec.motorizedNode ~ = nil then
            self:controlVehicle( 0.0 , 0.0 , 0.0 , 0.0 , math.huge, 0.0 , 0.0 , 0.0 , 0.0 , 0.0 )
        end
    end
end

```

### tryStartMotor

**Description**

> Tries to start any motor in the currently attached vehicle chain

**Definition**

> tryStartMotor(table vehicle)

**Arguments**

| table | vehicle | any vehicle of the chain |
|-------|---------|--------------------------|

**Code**

```lua
function Motorized.tryStartMotor(vehicle)
    for i = 1 , #vehicle.rootVehicle.childVehicles do
        local otherVehicle = vehicle.rootVehicle.childVehicles[i]

        if otherVehicle.getCanMotorRun ~ = nil and otherVehicle:getCanMotorRun() then
            otherVehicle:startMotor()
        end
    end
end

```

### updateActionEvents

**Description**

**Definition**

> updateActionEvents()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Motorized.updateActionEvents( self )
    -- hide / show start motor input action if setting is changed on the fly
        local missionInfo = g_currentMission.missionInfo
        local automaticMotorStartEnabled = missionInfo.automaticMotorStartEnabled
        local spec = self.spec_motorized
        local actionEvent = spec.actionEvents[InputAction.TOGGLE_MOTOR_STATE]
        if actionEvent ~ = nil then
            if not automaticMotorStartEnabled then
                local text

                g_inputBinding:setActionEventActive(actionEvent.actionEventId, true )
                local motorState = self:getMotorState()
                if motorState = = MotorState.STARTING or motorState = = MotorState.ON then
                    g_inputBinding:setActionEventTextPriority(actionEvent.actionEventId, GS_PRIO_VERY_LOW)
                    text = spec.turnOffText
                else
                        g_inputBinding:setActionEventTextPriority(actionEvent.actionEventId, GS_PRIO_VERY_HIGH)
                        text = spec.turnOnText
                    end

                    g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
                else
                        g_inputBinding:setActionEventActive(actionEvent.actionEventId, false )
                    end
                end

                actionEvent = spec.actionEvents[InputAction.MOTOR_STATE_IGNITION]
                if actionEvent ~ = nil then
                    g_inputBinding:setActionEventActive(actionEvent.actionEventId, not automaticMotorStartEnabled)
                end
                actionEvent = spec.actionEvents[InputAction.MOTOR_STATE_ON]
                if actionEvent ~ = nil then
                    g_inputBinding:setActionEventActive(actionEvent.actionEventId, not automaticMotorStartEnabled)
                end
                actionEvent = spec.actionEvents[InputAction.MOTOR_STATE_OFF]
                if actionEvent ~ = nil then
                    g_inputBinding:setActionEventActive(actionEvent.actionEventId, not automaticMotorStartEnabled)
                end
            end

```

### updateConsumers

**Description**

**Definition**

> updateConsumers()

**Arguments**

| any | dt       |
|-----|----------|
| any | accInput |

**Code**

```lua
function Motorized:updateConsumers(dt, accInput)
    local spec = self.spec_motorized

    local idleFactor = 0.5
    local rpmPercentage = (spec.motor.lastMotorRpm - spec.motor.minRpm) / (spec.motor.maxRpm - spec.motor.minRpm)
    local rpmFactor = idleFactor + rpmPercentage * ( 1 - idleFactor)
    local loadFactor = math.max(spec.smoothedLoadPercentage * rpmPercentage, 0 )
    local motorFactor = 0.5 * ( ( 0.2 * rpmFactor) + ( 1.8 * loadFactor) )

    local missionInfo = g_currentMission.missionInfo
    local fuelUsage = missionInfo.fuelUsage
    local usageFactor = 1.5 -- medium
    if fuelUsage = = 1 then
        usageFactor = 1.0 -- low
    elseif fuelUsage = = 3 then
            usageFactor = 2.5 -- high
        end

        local damage = self:getVehicleDamage()
        if damage > 0 then
            usageFactor = usageFactor * ( 1 + damage * Motorized.DAMAGED_USAGE_INCREASE)
        end

        -- update permanent consumers
        for _,consumer in pairs(spec.consumers) do
            if consumer.permanentConsumption and consumer.usage > 0 then
                local used = usageFactor * motorFactor * consumer.usage * dt
                if used ~ = 0 then
                    consumer.fillLevelToChange = consumer.fillLevelToChange + used
                    if math.abs(consumer.fillLevelToChange) > 1 then
                        used = consumer.fillLevelToChange
                        consumer.fillLevelToChange = 0

                        local fillType = self:getFillUnitLastValidFillType(consumer.fillUnitIndex)

                        g_farmManager:updateFarmStats( self:getOwnerFarmId(), "fuelUsage" , used)

                        if self:getIsAIActive() then
                            if fillType = = FillType.DIESEL or fillType = = FillType.DEF then
                                if missionInfo.helperBuyFuel then
                                    if fillType = = FillType.DIESEL then
                                        local price = used * g_currentMission.economyManager:getCostPerLiter(fillType) * 1.5
                                        g_farmManager:updateFarmStats( self:getOwnerFarmId(), "expenses" , price)

                                        g_currentMission:addMoney( - price, self:getOwnerFarmId(), MoneyType.PURCHASE_FUEL, true )
                                    end

                                    used = 0
                                end
                            end
                        end

                        if fillType = = consumer.fillType then
                            self:addFillUnitFillLevel( self:getOwnerFarmId(), consumer.fillUnitIndex, - used, fillType, ToolType.UNDEFINED)
                        end
                    end

                    if consumer.fillType = = FillType.DIESEL or consumer.fillType = = FillType.ELECTRICCHARGE or consumer.fillType = = FillType.METHANE then
                        spec.lastFuelUsage = used / dt * 1000 * 60 * 60 -- per hour
                    elseif consumer.fillType = = FillType.DEF then
                            spec.lastDefUsage = used / dt * 1000 * 60 * 60 -- per hour
                        end
                    end
                end
            end

            -- update air consuming
            if spec.consumersByFillTypeName[ "AIR" ] ~ = nil then
                local consumer = spec.consumersByFillTypeName[ "AIR" ]
                local fillType = self:getFillUnitLastValidFillType(consumer.fillUnitIndex)
                if fillType = = consumer.fillType then
                    local usage = 0

                    -- consume air on brake
                    local direction = self.movingDirection * self:getReverserDirection()
                    local forwardBrake = direction > 0 and accInput < 0
                    local backwardBrake = direction < 0 and accInput > 0
                    local brakeIsPressed = self:getLastSpeed() > 1.0 and(forwardBrake or backwardBrake)
                    if brakeIsPressed then
                        local delta = math.abs(accInput) * dt * self:getAirConsumerUsage() / 1000
                        self:addFillUnitFillLevel( self:getOwnerFarmId(), consumer.fillUnitIndex, - delta, consumer.fillType, ToolType.UNDEFINED)

                        usage = delta / dt * 1000 -- per sec
                    end

                    --refill air fill unit if it is below given level
                        local fillLevelPercentage = self:getFillUnitFillLevelPercentage(consumer.fillUnitIndex)
                        if fillLevelPercentage < consumer.refillCapacityPercentage then
                            consumer.doRefill = true
                        elseif fillLevelPercentage = = 1 then
                                consumer.doRefill = false
                            end

                            if consumer.doRefill then
                                local delta = consumer.refillLitersPerSecond / 1000 * dt
                                self:addFillUnitFillLevel( self:getOwnerFarmId(), consumer.fillUnitIndex, delta, consumer.fillType, ToolType.UNDEFINED)

                                usage = - delta / dt * 1000 -- per sec
                            end

                            spec.lastAirUsage = usage
                        end
                    end
                end

```

### updateMotorProperties

**Description**

> Update the motor properties based on script motor state

**Definition**

> updateMotorProperties()

**Code**

```lua
function Motorized:updateMotorProperties()
    local spec = self.spec_motorized
    local motor = spec.motor
    local torques, rotationSpeeds = motor:getTorqueAndSpeedValues()

    setMotorProperties(spec.motorizedNode, motor:getMinRpm() * math.pi / 30 , motor:getMaxRpm() * math.pi / 30 , motor:getRotInertia(), motor:getDampingRateFullThrottle(), motor:getDampingRateZeroThrottleClutchEngaged(), motor:getDampingRateZeroThrottleClutchDisengaged(), rotationSpeeds, torques)
end

```

### updateMotorTemperature

**Description**

**Definition**

> updateMotorTemperature()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Motorized:updateMotorTemperature(dt)
    local spec = self.spec_motorized

    local delta = spec.motorTemperature.heatingPerMS * dt
    local factor = ( 1 + 4 * spec.actualLoadPercentage) / 5
    delta = delta * (factor + self:getMotorRpmPercentage())
    spec.motorTemperature.value = math.min(spec.motorTemperature.valueMax, spec.motorTemperature.value + delta)

    -- cooling due to wind
    delta = spec.motorTemperature.coolingByWindPerMS * dt
    local speedFactor = math.pow( math.min( 1.0 , self:getLastSpeed() / 30 ), 2 )
    spec.motorTemperature.value = math.max(spec.motorTemperature.valueMin, spec.motorTemperature.value - (speedFactor * delta))

    -- cooling per fan
    if spec.motorTemperature.value > spec.motorFan.enableTemperature then
        spec.motorFan.enabled = true
    end
    if spec.motorFan.enabled then
        if spec.motorTemperature.value < spec.motorFan.disableTemperature then
            spec.motorFan.enabled = false
        end
    end
    if spec.motorFan.enabled then
        delta = spec.motorFan.coolingPerMS * dt
        spec.motorTemperature.value = math.max(spec.motorTemperature.valueMin, spec.motorTemperature.value - delta)
    end
end

```