## Locomotive

**Description**

> Specialization for locomotives (railroad vehicle)

**Functions**

- [alignToSplineTime](#aligntosplinetime)
- [getAreSurfaceSoundsActive](#getaresurfacesoundsactive)
- [getBrakeAcceleration](#getbrakeacceleration)
- [getCanBeReset](#getcanbereset)
- [getDistanceToRequestedPosition](#getdistancetorequestedposition)
- [getDownhillForce](#getdownhillforce)
- [getFullName](#getfullname)
- [getIsEnterable](#getisenterable)
- [getIsMapHotspotVisible](#getismaphotspotvisible)
- [getIsMotorStarted](#getismotorstarted)
- [getIsReadyForAutomatedTrainTravel](#getisreadyforautomatedtraintravel)
- [getLocomotiveSpeed](#getlocomotivespeed)
- [getMapHotspotPosition](#getmaphotspotposition)
- [getMotorRpmReal](#getmotorrpmreal)
- [getStopMotorOnLeave](#getstopmotoronleave)
- [getTraveledDistanceStatsActive](#gettraveleddistancestatsactive)
- [initSpecialization](#initspecialization)
- [notifyPlayerFarmChanged](#notifyplayerfarmchanged)
- [onDelete](#ondelete)
- [onEnterVehicle](#onentervehicle)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setLocomotiveState](#setlocomotivestate)
- [setRequestedSplinePosition](#setrequestedsplineposition)
- [setTrainSystem](#settrainsystem)
- [startAutomatedTrainTravel](#startautomatedtraintravel)
- [updateVehiclePhysics](#updatevehiclephysics)

### alignToSplineTime

**Description**

**Definition**

> alignToSplineTime()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | spline    |
| any | yOffset   |
| any | tFront    |

**Code**

```lua
function Locomotive:alignToSplineTime(superFunc, spline, yOffset, tFront)
    local retValue = superFunc( self , spline, yOffset, tFront)

    if retValue ~ = nil then
        local spec = self.spec_locomotive
        if spec.powerArm ~ = nil and spec.electricitySpline ~ = nil then
            local x, y, z = getWorldTranslation(spec.powerArm)
            local cx, cy, cz = getWorldTranslation(g_cameraManager:getActiveCamera())
            if MathUtil.vector3Length(x - cx, y - cy, z - cz) < 50 then
                local _
                retValue = SplineUtil.getValidSplineTime(retValue)
                x, y, z, _ = getLocalClosestSplinePosition(spec.electricitySpline, retValue, spec.electricitySplineSearchTime, x, y, z, 0.01 )

                _, y, _ = worldToLocal(getParent(spec.powerArm), x, y, z)
                x, _, z = getTranslation(spec.powerArm)
                setTranslation(spec.powerArm, x, y, z)
                if spec.powerArm ~ = nil then
                    self:setMovingToolDirty(spec.powerArm)
                end

                -- local x, y, z = getSplinePosition(spec.electricitySpline, newTime)
                -- local dx, dy, dz = getSplineDirection(spec.electricitySpline, newTime)
                -- log(string.format("%.4f %.4f %.4f %.4f", retValue, electricityTime, dif, newTime))
                -- DebugGizmo.renderAtPosition(x, y, z, dx, dy, dz, 0, 1, 0, "E " .. tFront .. " " .. electricityTime .. " " .. newTime)
            end
        end
    end

    if not self.isServer then
        self:updateMapHotspot()
    end

    return retValue
end

```

### getAreSurfaceSoundsActive

**Description**

**Definition**

> getAreSurfaceSoundsActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getAreSurfaceSoundsActive(superFunc)
    return self:getLastSpeed() > 0.1
end

```

### getBrakeAcceleration

**Description**

**Definition**

> getBrakeAcceleration()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Locomotive.getBrakeAcceleration( self )
    local spec = self.spec_locomotive
    local downhillForce = self:getDownhillForce()
    local maxBrakeForce = self.serverMass * 9.81 * 0.18
    local brakeForce

    if math.abs(spec.speed) < 0.3 or not self:getIsControlled() then
        brakeForce = maxBrakeForce
    else
            brakeForce = maxBrakeForce * 0.05
        end

        local sign = 1
        -- do it explicit with if because math.sign returns 0 for zero speed
            if spec.speed < 0 then
                sign = - 1
            end

            brakeForce = brakeForce * sign

            local brakeForceSum = - brakeForce - downhillForce
            if math.abs(brakeForceSum) < 0.0001 then
                -- if brake force is near zero we take only 95% of the downhillForce into account.Braking should always be possible ingame
                    brakeForceSum = - brakeForce - downhillForce * 0.95
                end

                return( 1 / self.serverMass) * brakeForceSum
            end

```

### getCanBeReset

**Description**

**Definition**

> getCanBeReset()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getCanBeReset(superFunc)
    return false
end

```

### getDistanceToRequestedPosition

**Description**

**Definition**

> getDistanceToRequestedPosition()

**Code**

```lua
function Locomotive:getDistanceToRequestedPosition()
    local spec = self.spec_locomotive
    if spec.state = = Locomotive.STATE_REQUESTED_POSITION_BRAKING or spec.state = = Locomotive.STATE_REQUESTED_POSITION then
        local currentPosition = self:getCurrentSplinePosition()
        local requestedPosition = spec.requestedSplinePosition % 1

        local distanceToGo = math.abs(requestedPosition - currentPosition)
        if spec.state = = Locomotive.STATE_REQUESTED_POSITION_BRAKING and distanceToGo > 0.5 then
            -- if we brake a bit late and go over the requested position
                return 0
            end

            return distanceToGo * self.trainSystem:getSplineLength()
        end

        return 0
    end

```

### getDownhillForce

**Description**

**Definition**

> getDownhillForce()

**Code**

```lua
function Locomotive:getDownhillForce()
    local dirX, dirY, dirZ = localDirectionToWorld( self.rootNode, 0 , 0 , 1 )
    local angleX = math.acos(dirY / MathUtil.vector3Length(dirX, dirY, dirZ)) - 0.5 * math.pi

    return self.serverMass * 9.81 * math.sin( - angleX)
end

```

### getFullName

**Description**

**Definition**

> getFullName()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getFullName(superFunc)
    local storeItem = g_storeManager:getItemByXMLFilename( self.configFileName)
    return storeItem.name
end

```

### getIsEnterable

**Description**

**Definition**

> getIsEnterable()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getIsEnterable(superFunc)
    if not superFunc( self ) then
        return false
    end

    if self.trainSystem ~ = nil and not self.trainSystem:getIsTrainInDriveableRange() then
        return false
    end

    local spec = self.spec_locomotive
    return spec.state = = Locomotive.STATE_MANUAL_TRAVEL_ACTIVE or spec.state = = Locomotive.STATE_MANUAL_TRAVEL_INACTIVE
end

```

### getIsMapHotspotVisible

**Description**

**Definition**

> getIsMapHotspotVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getIsMapHotspotVisible(superFunc)
    if not superFunc( self ) then
        return false
    end

    if self.trainSystem ~ = nil and not self.trainSystem:getIsTrainInDriveableRange() then
        return false
    end

    local x, _, z = getWorldTranslation( self.rootNode)
    if math.abs(x) > g_currentMission.terrainSize * 0.5 or math.abs(z) > g_currentMission.terrainSize * 0.5 then
        return false
    end

    return true
end

```

### getIsMotorStarted

**Description**

**Definition**

> getIsMotorStarted()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getIsMotorStarted(superFunc)
    local spec = self.spec_locomotive
    return superFunc( self )
    or spec.state = = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE
    or spec.state = = Locomotive.STATE_REQUESTED_POSITION
    or spec.state = = Locomotive.STATE_REQUESTED_POSITION_BRAKING
end

```

### getIsReadyForAutomatedTrainTravel

**Description**

**Definition**

> getIsReadyForAutomatedTrainTravel()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getIsReadyForAutomatedTrainTravel(superFunc)
    if self:getIsControlled() then
        return false
    end

    return superFunc( self )
end

```

### getLocomotiveSpeed

**Description**

**Definition**

> getLocomotiveSpeed()

**Code**

```lua
function Locomotive:getLocomotiveSpeed()
    return self.spec_locomotive.speed
end

```

### getMapHotspotPosition

**Description**

**Definition**

> getMapHotspotPosition()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getMapHotspotPosition(superFunc)
    if self.trainSystem = = nil then
        return 0 , 0 , 0
    end

    return self.trainSystem:getTrainPosition()
end

```

### getMotorRpmReal

**Description**

**Definition**

> getMotorRpmReal()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getMotorRpmReal(superFunc)
    return self.spec_locomotive.lastVirtualRpm
end

```

### getStopMotorOnLeave

**Description**

**Definition**

> getStopMotorOnLeave()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getStopMotorOnLeave(superFunc)
    return self.spec_locomotive.state = = Locomotive.STATE_MANUAL_TRAVEL_ACTIVE or self.spec_locomotive.state = = Locomotive.STATE_MANUAL_TRAVEL_INACTIVE
end

```

### getTraveledDistanceStatsActive

**Description**

**Definition**

> getTraveledDistanceStatsActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Locomotive:getTraveledDistanceStatsActive(superFunc)
    local spec = self.spec_locomotive
    return spec.state = = Locomotive.STATE_MANUAL_TRAVEL_ACTIVE
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Locomotive.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Locomotive" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.locomotive.powerArm#node" , "Power arm node" )

    schema:setXMLSpecializationType()
end

```

### notifyPlayerFarmChanged

**Description**

**Definition**

> notifyPlayerFarmChanged()

**Code**

```lua
function Locomotive:notifyPlayerFarmChanged()
    if self.trainSystem ~ = nil then
        self:setIsTabbable( self.trainSystem.isRented and g_localPlayer.farmId = = self.trainSystem.rentFarmId)
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function Locomotive:onDelete()
    g_messageCenter:unsubscribeAll( self )
end

```

### onEnterVehicle

**Description**

**Definition**

> onEnterVehicle()

**Code**

```lua
function Locomotive:onEnterVehicle()
    local spec = self.spec_locomotive
    spec.requestedSplinePosition = nil
    spec.automaticTravelStartTime = nil

    if not g_currentMission.missionInfo.automaticMotorStartEnabled then
        if spec.state = = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE or spec.state = = Locomotive.STATE_REQUESTED_POSITION or spec.state = = Locomotive.STATE_REQUESTED_POSITION_BRAKING then
            self:startMotor( true )
        end
    end

    self:setLocomotiveState( Locomotive.STATE_MANUAL_TRAVEL_ACTIVE)
end

```

### onLeaveVehicle

**Description**

**Definition**

> onLeaveVehicle()

**Code**

```lua
function Locomotive:onLeaveVehicle()
    local spec = self.spec_locomotive
    if spec.state ~ = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE then
        if self:getIsReadyForAutomatedTrainTravel() then
            spec.automaticTravelStartTime = g_ time + Locomotive.AUTOMATIC_DRIVE_DELAY
        end

        self:setLocomotiveState( Locomotive.STATE_MANUAL_TRAVEL_INACTIVE)
        self:raiseActive()

        spec.requestedSplinePosition = nil
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
function Locomotive:onLoad(savegame)
    local spec = self.spec_locomotive

    self.serverMass = 1 -- set serverMass ~ = 0 to prevent dib by zero issues after load

    spec.powerArm = self.xmlFile:getValue( "vehicle.locomotive.powerArm#node" , nil , self.components, self.i3dMappings)
    spec.electricitySpline = nil

    spec.lastVirtualRpm = self:getMotor():getMinRpm()
    spec.speed = 0
    spec.lastAcceleration = 0
    spec.nextMovingDirection = 0
    spec.sellingDirection = 1

    spec.startBrakeDistance = 0
    spec.startBrakeSpeed = 0

    self:setLocomotiveState( Locomotive.STATE_NONE)

    spec.motor = self:getMotor()

    spec.doStartCheck = true

    g_messageCenter:subscribe(MessageType.PLAYER_FARM_CHANGED, self.notifyPlayerFarmChanged, self )
    g_messageCenter:subscribe(MessageType.PLAYER_CREATED, self.notifyPlayerFarmChanged, self )
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
function Locomotive:onReadStream(streamId, connection)
    self.spec_locomotive.state = streamReadUIntN(streamId, Locomotive.NUM_BITS_STATE)
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
function Locomotive:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_locomotive

    if spec.doStartCheck then
        if self.trainSystem ~ = nil then
            if not self.trainSystem:getIsRented() then
                self:startAutomatedTrainTravel()
            else
                    self:setLocomotiveState( Locomotive.STATE_MANUAL_TRAVEL_ACTIVE)
                end

                self:raiseActive()
                spec.doStartCheck = false
            end
        end

        -- update motor as long as locomotive is still moving but no player has entered
        if self.isServer then
            if spec.state = = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE then
                self:raiseActive()
                self:updateVehiclePhysics( 1 , 0 , 0 , dt)
                SpecializationUtil.raiseEvent( self , "onAutomatedTrainTravelActive" , dt)
            elseif spec.state = = Locomotive.STATE_REQUESTED_POSITION then
                    if spec.requestedSplinePosition ~ = nil then
                        local splineLength = self.trainSystem:getSplineLength()
                        local currentPosition = self:getCurrentSplinePosition() % 1
                        local requestedPosition = spec.requestedSplinePosition % 1

                        local targetDirection = math.sign(requestedPosition - currentPosition)
                        local brakeAcceleration = Locomotive.getBrakeAcceleration( self )
                        local brakeDistance = math.abs((spec.speed ^ 2 ) / ( 2 * brakeAcceleration))
                        local brakePoint = (requestedPosition - (brakeDistance / splineLength) * targetDirection) % 1
                        local pendingDirectionChange = not(targetDirection = = self.movingDirection or self.movingDirection = = 0 )
                        if not pendingDirectionChange and((targetDirection > = 0 and(currentPosition > brakePoint and currentPosition < brakePoint + 0.5 ))
                            or(targetDirection < 0 and(currentPosition < brakePoint and currentPosition > brakePoint - 0.5 ))) then
                            self:setLocomotiveState( Locomotive.STATE_REQUESTED_POSITION_BRAKING)

                            spec.startBrakeDistance = brakeDistance
                            spec.startBrakeSpeed = spec.speed
                        else
                                self:updateVehiclePhysics(targetDirection, 0 , 0 , dt)
                            end
                            self:raiseActive()
                        end
                    elseif spec.state = = Locomotive.STATE_REQUESTED_POSITION_BRAKING then
                            -- if we detect that we could stop way earlier(e.g.due to changing slope) we release the brake again
                                local brakeAcceleration = Locomotive.getBrakeAcceleration( self )
                                local brakeDistance = math.abs((spec.startBrakeSpeed ^ 2 ) / ( 2 * brakeAcceleration))
                                if brakeDistance < spec.startBrakeDistance - 10 then
                                    self:setLocomotiveState( Locomotive.STATE_REQUESTED_POSITION)
                                end

                                if self.movingDirection > 0 then
                                    self:updateVehiclePhysics( - 1 , 0 , 0 , dt)
                                else
                                        self:updateVehiclePhysics( 1 , 0 , 0 , dt)
                                    end

                                    self:raiseActive()
                                    if spec.speed = = 0 then
                                        self:setLocomotiveState( Locomotive.STATE_MANUAL_TRAVEL_ACTIVE)

                                        self:stopMotor()
                                    end
                                elseif spec.state = = Locomotive.STATE_MANUAL_TRAVEL_INACTIVE then
                                        if self.movingDirection > 0 then
                                            self:updateVehiclePhysics( - 1 , 0 , 0 , dt)
                                        elseif self.movingDirection < 0 then
                                                self:updateVehiclePhysics( 1 , 0 , 0 , dt)
                                            end
                                            self:raiseActive()
                                        end
                                    else
                                            if spec.state = = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE
                                                or spec.state = = Locomotive.STATE_REQUESTED_POSITION
                                                or spec.state = = Locomotive.STATE_REQUESTED_POSITION_BRAKING then
                                                self:raiseActive()
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
function Locomotive:onWriteStream(streamId, connection)
    streamWriteUIntN(streamId, self.spec_locomotive.state, Locomotive.NUM_BITS_STATE)
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
function Locomotive.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( SplineVehicle , specializations) and SpecializationUtil.hasSpecialization( Drivable , specializations)
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
function Locomotive.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Locomotive )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Locomotive )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Locomotive )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Locomotive )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Locomotive )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , Locomotive )
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle" , Locomotive )
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
function Locomotive.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onAutomatedTrainTravelActive" )
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
function Locomotive.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getDownhillForce" , Locomotive.getDownhillForce)
    SpecializationUtil.registerFunction(vehicleType, "getLocomotiveSpeed" , Locomotive.getLocomotiveSpeed)
    SpecializationUtil.registerFunction(vehicleType, "setRequestedSplinePosition" , Locomotive.setRequestedSplinePosition)
    SpecializationUtil.registerFunction(vehicleType, "getDistanceToRequestedPosition" , Locomotive.getDistanceToRequestedPosition)
    SpecializationUtil.registerFunction(vehicleType, "setLocomotiveState" , Locomotive.setLocomotiveState)
    SpecializationUtil.registerFunction(vehicleType, "startAutomatedTrainTravel" , Locomotive.startAutomatedTrainTravel)
    SpecializationUtil.registerFunction(vehicleType, "notifyPlayerFarmChanged" , Locomotive.notifyPlayerFarmChanged)
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
function Locomotive.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMotorStarted" , Locomotive.getIsMotorStarted)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateVehiclePhysics" , Locomotive.updateVehiclePhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsReadyForAutomatedTrainTravel" , Locomotive.getIsReadyForAutomatedTrainTravel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "alignToSplineTime" , Locomotive.alignToSplineTime)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setTrainSystem" , Locomotive.setTrainSystem)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFullName" , Locomotive.getFullName)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreSurfaceSoundsActive" , Locomotive.getAreSurfaceSoundsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getTraveledDistanceStatsActive" , Locomotive.getTraveledDistanceStatsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsEnterable" , Locomotive.getIsEnterable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMapHotspotVisible" , Locomotive.getIsMapHotspotVisible)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeReset" , Locomotive.getCanBeReset)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getStopMotorOnLeave" , Locomotive.getStopMotorOnLeave)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getMapHotspotPosition" , Locomotive.getMapHotspotPosition)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getMotorRpmReal" , Locomotive.getMotorRpmReal)
end

```

### setLocomotiveState

**Description**

**Definition**

> setLocomotiveState()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Locomotive:setLocomotiveState(state, noEventSend)
    local spec = self.spec_locomotive
    spec.state = state

    if state = = Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE then
        if self.setRandomVehicleCharacter ~ = nil then
            self:setRandomVehicleCharacter()
        end
    elseif state = = Locomotive.STATE_MANUAL_TRAVEL_ACTIVE then
            self:restoreVehicleCharacter()
        end

        if g_server ~ = nil and not noEventSend then
            g_server:broadcastEvent( LocomotiveStateEvent.new( self , state), nil , nil , self )
        end

        self:raiseActive()
    end

```

### setRequestedSplinePosition

**Description**

**Definition**

> setRequestedSplinePosition()

**Arguments**

| any | splinePosition |
|-----|----------------|
| any | noEventSend    |

**Code**

```lua
function Locomotive:setRequestedSplinePosition(splinePosition, noEventSend)
    local spec = self.spec_locomotive
    spec.requestedSplinePosition = splinePosition
    self:setLocomotiveState( Locomotive.STATE_REQUESTED_POSITION, true )

    local currentPosition = self:getCurrentSplinePosition()
    local requestedPosition = spec.requestedSplinePosition
    if currentPosition > spec.requestedSplinePosition then
        if math.abs(currentPosition - (requestedPosition + 1 )) < math.abs(currentPosition - requestedPosition) then
            spec.requestedSplinePosition = requestedPosition + 1
        end
    end

    if self.isServer then
        self:startMotor()
    end
end

```

### setTrainSystem

**Description**

**Definition**

> setTrainSystem()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | trainSystem |

**Code**

```lua
function Locomotive:setTrainSystem(superFunc, trainSystem)
    superFunc( self , trainSystem)

    local spec = self.spec_locomotive
    if spec.powerArm ~ = nil then
        local spline = trainSystem:getElectricitySpline()
        if spline ~ = nil then
            local electricitySplineLength = trainSystem:getElectricitySplineLength()
            local splineLength = trainSystem:getSplineLength()
            spec.splineDiff = math.abs(electricitySplineLength - splineLength)
            spec.electricitySplineSearchTime = spec.splineDiff * 5 / electricitySplineLength
            spec.electricitySpline = spline
        end
    end
end

```

### startAutomatedTrainTravel

**Description**

**Definition**

> startAutomatedTrainTravel()

**Code**

```lua
function Locomotive:startAutomatedTrainTravel()
    self:setLocomotiveState( Locomotive.STATE_AUTOMATIC_TRAVEL_ACTIVE)
    self:startMotor()
end

```

### updateVehiclePhysics

**Description**

**Definition**

> updateVehiclePhysics()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | axisForward |
| any | axisSide    |
| any | doHandbrake |
| any | dt          |

**Code**

```lua
function Locomotive:updateVehiclePhysics(superFunc, axisForward, axisSide, doHandbrake, dt)
    local spec = self.spec_locomotive
    local specDrivable = self.spec_drivable

    axisForward = axisForward * spec.sellingDirection

    local acceleration = superFunc( self , axisForward, axisSide, doHandbrake, dt)

    local interpDt = g_physicsDt
    if g_server = = nil then
        -- on clients, we interpolate the vehicles with g_physicsDtUnclamped, thus we need to use the same for camera interpolation
            interpDt = g_physicsDtUnclamped
        end

        -- assuming:
        -- totalMass:mass,
        -- P(v):tractive effort of locomotive
        -- Q(v):drag of train(dismissed)
        -- B:brake force
        -- g:gravity
        -- alpha:inclination angle
        --
        -- totalMass*a = P(v) - Q(v) - B - totalMass*g*sin(alpha)
        -- a = 1/totalMass * [ (P(v) - Q(v) - B - totalMass*g*sin(alpha) ]

        local tractiveEffort = 300000
        local maxBrakeForce = self.serverMass * 9.81 * 0.18
        local downhillForce = self:getDownhillForce()
        tractiveEffort = math.min(tractiveEffort, maxBrakeForce)

        if self:getIsMotorStarted() then
            local reverserDirection = specDrivable = = nil and 1 or specDrivable.reverserDirection
            if self:getCruiseControlState() ~ = Drivable.CRUISECONTROL_STATE_OFF then
                local cruiseControlSpeed = self:getCruiseControlSpeed() / 3.6
                if spec.speed < reverserDirection * cruiseControlSpeed then
                    acceleration = 1
                elseif spec.speed > reverserDirection * cruiseControlSpeed then
                        acceleration = - 1
                    end
                end
            else
                    tractiveEffort = maxBrakeForce
                end

                if math.abs(acceleration) < 0.001 then
                    local a = Locomotive.getBrakeAcceleration( self )

                    if spec.speed > 0 then
                        spec.speed = math.max( 0 , spec.speed + a * dt / 1000 )
                    elseif spec.speed < 0 then
                            spec.speed = math.min( 0 , spec.speed + a * dt / 1000 )
                        else
                                -- move train if track is too steep ???
                                    if maxBrakeForce < math.abs(downhillForce) then
                                        spec.speed = spec.speed + a * dt / 1000
                                    end
                                end

                                if spec.speed = = 0 then
                                    spec.hasStopped = true
                                else
                                        spec.hasStopped = false
                                    end
                                else
                                        if math.abs(spec.speed) > 0.1 then
                                            spec.hasStopped = false
                                        elseif math.abs(spec.speed) = = 0 then
                                                spec.hasStopped = true
                                            end
                                            if spec.hasStopped = = nil or(spec.hasStopped and math.abs(acceleration) > 0.01 ) then
                                                spec.nextMovingDirection = math.sign(acceleration)
                                            end

                                            local a = 0
                                            local brakeForce
                                            if spec.nextMovingDirection = = nil or(spec.nextMovingDirection * acceleration) > 0 then
                                                tractiveEffort = acceleration * tractiveEffort
                                                brakeForce = 0
                                                a = ( 1 / self.serverMass) * ( tractiveEffort - brakeForce - downhillForce )
                                            else
                                                    tractiveEffort = 0
                                                    brakeForce = math.sign(spec.speed) * math.abs(acceleration) * maxBrakeForce
                                                    if math.abs(spec.speed) < 0.1 then
                                                        spec.speed = 0
                                                    else
                                                            a = ( 1 / self.serverMass) * ( tractiveEffort - brakeForce - downhillForce )
                                                        end
                                                    end

                                                    spec.speed = spec.speed + a * interpDt / 1000
                                                end

                                                local motor = spec.motor
                                                if spec.speed > 0 then
                                                    spec.speed = math.min(spec.speed, motor.maxForwardSpeed)
                                                elseif spec.speed < 0 then
                                                        spec.speed = math.max(spec.speed, - motor.maxBackwardSpeed)
                                                    end

                                                    local minRpm = motor.minRpm
                                                    local maxRpm = motor.maxRpm
                                                    -- fake rpm for indoorHud
                                                        if spec.lastAcceleration * spec.nextMovingDirection > 0 then
                                                            spec.lastVirtualRpm = math.min(maxRpm, spec.lastVirtualRpm + ( 0.0005 * dt * (maxRpm - minRpm)))
                                                        else
                                                                spec.lastVirtualRpm = math.max(minRpm, spec.lastVirtualRpm - ( 0.001 * dt * (maxRpm - minRpm)))
                                                            end

                                                            motor:setEqualizedMotorRpm(spec.lastVirtualRpm)

                                                            spec.lastAcceleration = acceleration
                                                        end

```