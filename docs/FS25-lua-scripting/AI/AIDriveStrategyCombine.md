## AIDriveStrategyCombine

**Description**

> drive strategy to
> - stop vehicle if grain tank of combine is full
> - open/close pipe
    > Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.

**Parent**

> [AIDriveStrategy](?version=script&category=4&class=148)

**Functions**

- [getDriveData](#getdrivedata)
- [new](#new)
- [setAIVehicle](#setaivehicle)
- [update](#update)
- [updateDriving](#updatedriving)

### getDriveData

**Description**

**Definition**

> getDriveData()

**Arguments**

| any | dt |
|-----|----|
| any | vX |
| any | vY |
| any | vZ |

**Code**

```lua
function AIDriveStrategyCombine:getDriveData(dt, vX,vY,vZ)
    local rootVehicle = self.vehicle.rootVehicle
    local isTurning = rootVehicle.getAIFieldWorkerIsTurning ~ = nil and rootVehicle:getAIFieldWorkerIsTurning()
    local isCornerCutOutActive = rootVehicle.getAIFieldWorkerIsCornerCutOutActive ~ = nil and rootVehicle:getAIFieldWorkerIsCornerCutOutActive()

    local allowedToDrive = true
    local waitForStraw = false
    local maxSpeed = math.huge

    for _, combine in pairs( self.combines) do
        if combine.spec_pipe ~ = nil then
            local trailerInTrigger = false
            local invalidTrailerInTrigger = false
            local fillLevel = 0
            local capacity = 0

            local dischargeNode = combine:getCurrentDischargeNode()
            if dischargeNode ~ = nil then
                fillLevel = combine:getFillUnitFillLevel(dischargeNode.fillUnitIndex)
                capacity = combine:getFillUnitCapacity(dischargeNode.fillUnitIndex)
            end

            local trailer = NetworkUtil.getObject(combine.spec_pipe.nearestObjectInTriggers.objectId)
            if trailer ~ = nil then
                trailerInTrigger = true
            end

            if combine.spec_pipe.nearestObjectInTriggerIgnoreFillLevel then
                invalidTrailerInTrigger = true
            end

            local currentPipeTargetState = combine.spec_pipe.targetState
            local currentPipeState = combine.spec_pipe.currentState
            local turnOnAllowedStates = combine.spec_pipe.turnOnAllowedStates
            if next(turnOnAllowedStates) = = nil then
                turnOnAllowedStates = nil
            end

            if capacity = = math.huge then
                -- forage harvesters
                if currentPipeTargetState ~ = 2 then
                    combine:setPipeState( 2 )
                end

                if not isTurning and not isCornerCutOutActive then
                    local targetObject, _ = combine:getDischargeTargetObject(dischargeNode)
                    allowedToDrive = trailerInTrigger and targetObject ~ = nil

                    if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                        if not trailerInTrigger then
                            self.vehicle:addAIDebugText( "COMBINE -> Waiting for trailer enter the trigger" )
                            elseif trailerInTrigger and targetObject = = nil then
                                    self.vehicle:addAIDebugText( "COMBINE -> Waiting for pipe hitting the trailer" )
                                    end
                                end
                            end
                        else
                                -- combine harvesters
                                local pipeState = currentPipeTargetState

                                if fillLevel > ( 0.8 * capacity) then
                                    if not self.beaconLightsActive then
                                        self.vehicle:setAIMapHotspotBlinking( true )
                                        self.vehicle:setBeaconLightsVisibility( true )
                                        self.beaconLightsActive = true
                                    end

                                    if not self.notificationGrainTankWarningShown and self.vehicle:getOwnerFarmId() = = g_localPlayer.farmId then
                                        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText( "ai_messageErrorTankIsNearlyFull" ), self.vehicle:getCurrentHelper().name) )
                                        self.notificationGrainTankWarningShown = true
                                    end
                                else
                                        if self.beaconLightsActive then
                                            self.vehicle:setAIMapHotspotBlinking( false )
                                            self.vehicle:setBeaconLightsVisibility( false )
                                            self.beaconLightsActive = false
                                        end

                                        self.notificationGrainTankWarningShown = false
                                    end

                                    if fillLevel = = capacity then
                                        pipeState = 2
                                        self.wasCompletelyFull = true
                                        if not self.notificationFullGrainTankShown and self.vehicle:getOwnerFarmId() = = g_localPlayer.farmId then
                                            g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, string.format(g_i18n:getText( "ai_messageErrorTankIsFull" ), self.vehicle:getCurrentHelper().name) )
                                            self.notificationFullGrainTankShown = true
                                        end
                                    else
                                            self.notificationFullGrainTankShown = false
                                        end

                                        if trailerInTrigger then
                                            -- if we have to turn off while lifting the pipe, we only lift if we have something loaded
                                                if turnOnAllowedStates ~ = nil and turnOnAllowedStates[ 2 ] ~ = true then
                                                    if fillLevel > 0.1 then
                                                        pipeState = 2
                                                    end
                                                else
                                                        pipeState = 2
                                                    end
                                                end

                                                if not trailerInTrigger then
                                                    if fillLevel < capacity * 0.8 then
                                                        self.wasCompletelyFull = false

                                                        if not combine:getIsTurnedOn() and combine:getCanBeTurnedOn() then
                                                            combine:aiImplementStartLine()
                                                            for i, implement in ipairs( self.vehicle:getAttachedAIImplements()) do
                                                                implement.object:aiImplementStartLine()
                                                            end
                                                        end
                                                    end
                                                end

                                                if ( not trailerInTrigger and not invalidTrailerInTrigger) and fillLevel < capacity then
                                                    pipeState = 1
                                                end

                                                if fillLevel < 0.1 then
                                                    if not combine.spec_pipe.aiFoldedPipeUsesTrailerSpace then
                                                        if not trailerInTrigger and not invalidTrailerInTrigger then
                                                            pipeState = 1
                                                        end

                                                        if not combine:getIsTurnedOn() and combine:getCanBeTurnedOn() then
                                                            combine:aiImplementStartLine()
                                                            for i, implement in ipairs( self.vehicle:getAttachedAIImplements()) do
                                                                implement.object:aiImplementStartLine()
                                                            end
                                                        end
                                                    end

                                                    self.wasCompletelyFull = false
                                                end

                                                if currentPipeTargetState ~ = pipeState then
                                                    combine:setPipeState(pipeState)
                                                end

                                                allowedToDrive = fillLevel < capacity

                                                if turnOnAllowedStates ~ = nil and turnOnAllowedStates[currentPipeState] ~ = true then
                                                    allowedToDrive = false
                                                    if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                        self.vehicle:addAIDebugText( "COMBINE -> Stopping AI because we cannot overload while harvesting" )
                                                        end
                                                    end

                                                    if pipeState = = 2 and self.wasCompletelyFull then
                                                        allowedToDrive = false
                                                        if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                            self.vehicle:addAIDebugText( "COMBINE -> Waiting for trailer to unload" )
                                                            end
                                                        end

                                                        local freeFillLevel = capacity - fillLevel
                                                        if freeFillLevel < self.slowDownFillLevel then
                                                            -- we want to drive at least 2 km/h to avoid combine stops too early
                                                            maxSpeed = 2 + (freeFillLevel / self.slowDownFillLevel) * self.slowDownStartSpeed

                                                            if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                                self.vehicle:addAIDebugText( string.format( "COMBINE -> Slow down because nearly full: %.2f" , maxSpeed))
                                                            end
                                                        end
                                                    end

                                                    if isTurning and trailerInTrigger and capacity ~ = math.huge then
                                                        if combine:getCanDischargeToObject(dischargeNode) then
                                                            local spec_combine = combine.spec_combine

                                                            -- also include the delay buffer slots, so we fully empty the vehicle while a trailer is in range
                                                                if spec_combine.loadingDelay > 0 then
                                                                    for i = 1 , #spec_combine.loadingDelaySlots do
                                                                        local slot = spec_combine.loadingDelaySlots[i]
                                                                        if slot.valid then
                                                                            fillLevel = fillLevel + slot.fillLevelDelta
                                                                        end
                                                                    end
                                                                end

                                                                if fillLevel > 0 then
                                                                    allowedToDrive = false
                                                                end

                                                                if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                                    if not allowedToDrive then
                                                                        self.vehicle:addAIDebugText( "COMBINE -> Unload to trailer on headland" )
                                                                    end
                                                                end
                                                            end
                                                        end

                                                        if not trailerInTrigger then
                                                            if combine.spec_combine.isSwathActive then
                                                                if combine.spec_combine.strawPSenabled then
                                                                    waitForStraw = true
                                                                end
                                                            end
                                                        end
                                                    else
                                                            local fillLevel = combine:getFillUnitFillLevel(combine.spec_combine.fillUnitIndex)
                                                            if fillLevel < 0.1 then
                                                                if not combine:getIsTurnedOn() and combine:getCanBeTurnedOn() then
                                                                    combine:aiImplementStartLine()
                                                                    for i, implement in ipairs( self.vehicle:getAttachedAIImplements()) do
                                                                        implement.object:aiImplementStartLine()
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end

                                                    if isTurning and waitForStraw then
                                                        if not self.waitForStrawModeActive then
                                                            self.waitForStrawModeActive = true
                                                            self.waitForStrawModeStartPosition[ 1 ], self.waitForStrawModeStartPosition[ 2 ] = vX, vZ
                                                        end

                                                        if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                            self.vehicle:addAIDebugText( "COMBINE -> Waiting for straw to drop" )
                                                            end

                                                            local x, _, z = localToWorld( self.vehicle:getAIDirectionNode(), 0 , 0 , - 10 )
                                                            local dist = MathUtil.vector2Length(vX - x, vZ - z)
                                                            return x, z, false , 6 , dist
                                                        else
                                                                if self.waitForStrawModeActive then
                                                                    self.waitForStrawModeActive = false
                                                                    self.waitForStrawModeReturnToStart = true
                                                                    self.waitForStrawModeLastPosition[ 1 ], self.waitForStrawModeLastPosition[ 2 ] = vX, vZ
                                                                    self.waitForStrawModeReturnToStartDistance = MathUtil.vector2Length(vX - self.waitForStrawModeStartPosition[ 1 ], vZ - self.waitForStrawModeStartPosition[ 2 ])
                                                                end

                                                                if self.waitForStrawModeReturnToStart then
                                                                    local movedDistance = MathUtil.vector2Length(vX - self.waitForStrawModeLastPosition[ 1 ], vZ - self.waitForStrawModeLastPosition[ 2 ])
                                                                    self.waitForStrawModeLastPosition[ 1 ], self.waitForStrawModeLastPosition[ 2 ] = vX, vZ

                                                                    self.waitForStrawModeReturnToStartDistance = self.waitForStrawModeReturnToStartDistance - movedDistance
                                                                    if self.waitForStrawModeReturnToStartDistance < 0 then
                                                                        self.waitForStrawModeReturnToStart = false
                                                                    else
                                                                            if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                                                                                self.vehicle:addAIDebugText( string.format( "COMBINE -> Returning to turn start position(%.1fm)" , self.waitForStrawModeReturnToStartDistance))
                                                                            end

                                                                            local x, z = self.waitForStrawModeStartPosition[ 1 ], self.waitForStrawModeStartPosition[ 2 ]
                                                                            local dist = MathUtil.vector2Length(vX - x, vZ - z)

                                                                            return x, z, true , 10 , dist
                                                                        end
                                                                    end

                                                                    if not allowedToDrive then
                                                                        return 0 , 1 , true , 0 , math.huge
                                                                    else
                                                                            return nil , nil , nil , maxSpeed, nil
                                                                        end
                                                                    end
                                                                end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | reconstructionData |
|-----|--------------------|
| any | customMt           |

**Code**

```lua
function AIDriveStrategyCombine.new(reconstructionData, customMt)
    local self = AIDriveStrategy.new(reconstructionData, customMt or AIDriveStrategyCombine _mt)

    self.combines = { }

    self.notificationFullGrainTankShown = false
    self.notificationGrainTankWarningShown = false

    self.beaconLightsActive = false

    self.slowDownFillLevel = 200
    self.slowDownStartSpeed = 20

    self.forageHarvesterFoundTimer = 0

    self.waitForStrawModeActive = false
    self.waitForStrawModeStartPosition = { 0 , 0 }
    self.waitForStrawModeLastPosition = { 0 , 0 }
    self.waitForStrawModeReturnToStart = false
    self.waitForStrawModeReturnToStartDistance = 0

    return self
end

```

### setAIVehicle

**Description**

**Definition**

> setAIVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AIDriveStrategyCombine:setAIVehicle(vehicle)
    AIDriveStrategyCombine:superClass().setAIVehicle( self , vehicle)

    for _, childVehicle in pairs( self.vehicle.rootVehicle.childVehicles) do
        if SpecializationUtil.hasSpecialization( Combine , childVehicle.specializations) then
            table.insert( self.combines, childVehicle)
        end
    end
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
function AIDriveStrategyCombine:update(dt)
    for _, combine in pairs( self.combines) do
        if combine.spec_pipe ~ = nil then
            local capacity = 0

            local dischargeNode = combine:getCurrentDischargeNode()
            if dischargeNode ~ = nil then
                capacity = combine:getFillUnitCapacity(dischargeNode.fillUnitIndex)
            end

            if capacity = = math.huge then
                local rootVehicle = self.vehicle.rootVehicle
                if rootVehicle.getAIFieldWorkerIsTurning ~ = nil and not rootVehicle:getAIFieldWorkerIsTurning() then
                    local trailer = NetworkUtil.getObject(combine.spec_pipe.nearestObjectInTriggers.objectId)
                    if trailer ~ = nil then
                        local trailerFillUnitIndex = combine.spec_pipe.nearestObjectInTriggers.fillUnitIndex
                        local fillType = combine:getDischargeFillType(dischargeNode)
                        if fillType = = FillType.UNKNOWN then
                            -- if nothing is in combine fillUnit we just check if we're targetting the trailer with the trailers first fill type or the current fill type if something is loaded
                                fillType = trailer:getFillUnitFillType(trailerFillUnitIndex)
                                if fillType = = FillType.UNKNOWN then
                                    fillType = trailer:getFillUnitFirstSupportedFillType(trailerFillUnitIndex)
                                end
                                combine:setForcedFillTypeIndex(fillType)
                            else
                                    -- otherwise we check if the fill type of the combine is supported on the trailer
                                        combine:setForcedFillTypeIndex( nil )
                                    end
                                end
                            end
                        end
                    end
                end
            end

```

### updateDriving

**Description**

**Definition**

> updateDriving()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function AIDriveStrategyCombine:updateDriving(dt)
end

```