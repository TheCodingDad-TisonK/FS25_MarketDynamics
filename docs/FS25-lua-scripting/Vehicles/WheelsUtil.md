## WheelsUtil

**Description**

> Wheels util
> Util class to manage wheels of a vehicle

**Functions**

- [computeDifferentialRotSpeedNonMotor](#computedifferentialrotspeednonmotor)
- [getGroundType](#getgroundtype)
- [getSmoothedAcceleratorAndBrakePedals](#getsmoothedacceleratorandbrakepedals)
- [getTireFriction](#gettirefriction)
- [getTireType](#gettiretype)
- [getTireTypeName](#gettiretypename)
- [registerTireType](#registertiretype)
- [unregisterTireType](#unregistertiretype)
- [updateWheelsPhysics](#updatewheelsphysics)

### computeDifferentialRotSpeedNonMotor

**Description**

> Compute differential rot speed from properties of vehicle other than the motor, e.g. rot speed of wheels or linear
> speed of vehicle

**Definition**

> computeDifferentialRotSpeedNonMotor()

**Arguments**

| any | self |
|-----|------|

**Return Values**

| any | diffRotSpeed | rot speed [rad/sec] |
|-----|--------------|---------------------|

**Code**

```lua
function WheelsUtil.computeDifferentialRotSpeedNonMotor( self )
    if self.isServer and self.spec_wheels ~ = nil and # self.spec_wheels.wheels ~ = 0 then
        local wheelSpeed = 0
        local numWheels = 0
        for _, wheel in pairs( self.spec_wheels.wheels) do
            local axleSpeed = getWheelShapeAxleSpeed(wheel.node, wheel.physics.wheelShape) -- rad/sec
            if wheel.physics.hasGroundContact then
                wheelSpeed = wheelSpeed + axleSpeed * wheel.physics.radius
                numWheels = numWheels + 1
            end
        end

        if numWheels > 0 then
            return wheelSpeed / numWheels
        end
        return 0
    else
            -- v = w*r = > w = v/r
            -- differentials have embeded gear so that r can be considered 1
            return self.lastSpeedReal * 1000
        end
    end

```

### getGroundType

**Description**

> Get ground type

**Definition**

> getGroundType(boolean isField, boolean isRoad, float depth)

**Arguments**

| boolean | isField | is on field      |
|---------|---------|------------------|
| boolean | isRoad  | is on road       |
| float   | depth   | depth of terrain |

**Return Values**

| float | groundType | ground type |
|-------|------------|-------------|

**Code**

```lua
function WheelsUtil.getGroundType(isField, isRoad, depth)
    -- terrain softness:
    -- [ 0, 0.1]:road
    -- [0.1, 0.8]:hard terrain
    -- [0.8, 1 ]:soft terrain
    if isField then
        return WheelsUtil.GROUND_FIELD
    elseif isRoad or depth < 0.1 then
            return WheelsUtil.GROUND_ROAD
        else
                if depth > 0.8 then
                    return WheelsUtil.GROUND_SOFT_TERRAIN
                else
                        return WheelsUtil.GROUND_HARD_TERRAIN
                    end
                end
            end

```

### getSmoothedAcceleratorAndBrakePedals

**Description**

**Definition**

> getSmoothedAcceleratorAndBrakePedals()

**Arguments**

| any | self             |
|-----|------------------|
| any | acceleratorPedal |
| any | brakePedal       |
| any | dt               |

**Code**

```lua
function WheelsUtil.getSmoothedAcceleratorAndBrakePedals( self , acceleratorPedal, brakePedal, dt)

    if self.wheelsUtilSmoothedAcceleratorPedal = = nil then
        self.wheelsUtilSmoothedAcceleratorPedal = 0
    end

    local appliedAcc = 0
    if acceleratorPedal > 0 then
        if acceleratorPedal > self.wheelsUtilSmoothedAcceleratorPedal then
            appliedAcc = math.min( math.max( self.wheelsUtilSmoothedAcceleratorPedal + SMOOTHING_SPEED_SCALE * dt, SMOOTHING_SPEED_SCALE), acceleratorPedal)
        else
                appliedAcc = acceleratorPedal
            end
            self.wheelsUtilSmoothedAcceleratorPedal = appliedAcc
        elseif acceleratorPedal < 0 then
                if acceleratorPedal < self.wheelsUtilSmoothedAcceleratorPedal then
                    appliedAcc = math.max( math.min( self.wheelsUtilSmoothedAcceleratorPedal - SMOOTHING_SPEED_SCALE * dt, - SMOOTHING_SPEED_SCALE), acceleratorPedal)
                else
                        appliedAcc = acceleratorPedal
                    end
                    self.wheelsUtilSmoothedAcceleratorPedal = appliedAcc
                else
                        -- Decrease smoothed acceleration towards 0 with different speeds based on if we are braking
                            local decSpeed = 0.0005 + 0.001 * brakePedal -- scale between 2sec and 0.66s(full brake)
                            if self.wheelsUtilSmoothedAcceleratorPedal > 0 then
                                self.wheelsUtilSmoothedAcceleratorPedal = math.max( self.wheelsUtilSmoothedAcceleratorPedal - decSpeed * dt, 0 )
                            else
                                    self.wheelsUtilSmoothedAcceleratorPedal = math.min( self.wheelsUtilSmoothedAcceleratorPedal + decSpeed * dt, 0 )
                                end
                            end

                            if self.wheelsUtilSmoothedBrakePedal = = nil then
                                self.wheelsUtilSmoothedBrakePedal = 0
                            end

                            local appliedBrake = 0
                            if brakePedal > 0 then
                                if brakePedal > self.wheelsUtilSmoothedBrakePedal then
                                    appliedBrake = math.min( self.wheelsUtilSmoothedBrakePedal + 0.0025 * dt, brakePedal) -- full brake in 0.4sec
                                else
                                        appliedBrake = brakePedal
                                    end
                                    self.wheelsUtilSmoothedBrakePedal = appliedBrake
                                else
                                        -- Decrease smoothed brake towards 0 with different speeds based on if we are accelerating
                                            local decSpeed = 0.0005 + 0.001 * acceleratorPedal -- scale between 2sec and 0.66s(full acceleration)
                                            self.wheelsUtilSmoothedBrakePedal = math.max( self.wheelsUtilSmoothedBrakePedal - decSpeed * dt, 0 )
                                        end

                                        --print(string.format("input: %.2f %.2f applied: %.2f %.2f", acceleratorPedal, brakePedal, appliedAcc, appliedBrake))

                                        return appliedAcc, appliedBrake
                                    end

```

### getTireFriction

**Description**

> Returns tire friction

**Definition**

> getTireFriction(integer tireType, integer groundType, float wetScale, )

**Arguments**

| integer | tireType   | tire type index   |
|---------|------------|-------------------|
| integer | groundType | ground type index |
| float   | wetScale   | wet scale         |
| any     | snowScale  |                   |

**Return Values**

| any | tireFriction | tire friction |
|-----|--------------|---------------|

**Code**

```lua
function WheelsUtil.getTireFriction(tireType, groundType, wetScale, snowScale)
    if wetScale = = nil then
        wetScale = 0
    end
    local coeff = WheelsUtil.tireTypes[tireType].frictionCoeffs[groundType]
    local coeffWet = WheelsUtil.tireTypes[tireType].frictionCoeffsWet[groundType]
    local coeffSnow = WheelsUtil.tireTypes[tireType].frictionCoeffsSnow[groundType]
    return coeff + (coeffWet - coeff) * wetScale + (coeffSnow - coeff) * snowScale
end

```

### getTireType

**Description**

> Returns tire type index

**Definition**

> getTireType(string name)

**Arguments**

| string | name | name of tire type |
|--------|------|-------------------|

**Return Values**

| string | i | index of tire type |
|--------|---|--------------------|

**Code**

```lua
function WheelsUtil.getTireType(name)
    name = string.upper(name)
    for i, t in pairs( WheelsUtil.tireTypes) do
        if t.name = = name then
            return i
        end
    end
    return nil
end

```

### getTireTypeName

**Description**

> Returns tire type name by index

**Definition**

> getTireTypeName(integer i)

**Arguments**

| integer | i | index of tire type |
|---------|---|--------------------|

**Return Values**

| integer | name | name of tire type |
|---------|------|-------------------|

**Code**

```lua
function WheelsUtil.getTireTypeName(index)
    if WheelsUtil.tireTypes[index] ~ = nil then
        return WheelsUtil.tireTypes[index].name
    end

    return "unknown"
end

```

### registerTireType

**Description**

> Register new tire type

**Definition**

> registerTireType(string name, table frictionCoeffs, table frictionCoeffsWer, )

**Arguments**

| string | name               | name of new tire type |
|--------|--------------------|-----------------------|
| table  | frictionCoeffs     | friction coeffs       |
| table  | frictionCoeffsWer  | friction coeffs wet   |
| any    | frictionCoeffsSnow |                       |

**Code**

```lua
function WheelsUtil.registerTireType(name, frictionCoeffs, frictionCoeffsWet, frictionCoeffsSnow)
    name = string.upper(name)
    if WheelsUtil.getTireType(name) ~ = nil then
        printWarning( "Warning:Tire type '" .. name .. "' already registered, ignoring this definition" )
        return
    end

    local function getNoNilCoeffs(frictionCoeffs)
        local localCoeffs = { }
        if frictionCoeffs[ 1 ] = = nil then
            localCoeffs[ 1 ] = 1.15
            for i = 2 , WheelsUtil.NUM_GROUNDS do
                if frictionCoeffs[i] ~ = nil then
                    localCoeffs[ 1 ] = frictionCoeffs[i]
                    break
                end
            end
        else
                localCoeffs[ 1 ] = frictionCoeffs[ 1 ]
            end
            for i = 2 , WheelsUtil.NUM_GROUNDS do
                localCoeffs[i] = frictionCoeffs[i] or frictionCoeffs[i - 1 ]
            end
            return localCoeffs
        end

        local tireType = { }
        tireType.name = name
        tireType.frictionCoeffs = getNoNilCoeffs(frictionCoeffs)
        tireType.frictionCoeffsWet = getNoNilCoeffs(frictionCoeffsWet or frictionCoeffs)
        tireType.frictionCoeffsSnow = getNoNilCoeffs(frictionCoeffsSnow or tireType.frictionCoeffsWet)
        table.insert( WheelsUtil.tireTypes, tireType)
    end

```

### unregisterTireType

**Description**

> Remove a tire type

**Definition**

> unregisterTireType()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function WheelsUtil.unregisterTireType(name)
    name = string.upper(name)
    for i, tireType in ipairs( WheelsUtil.tireTypes) do
        if tireType.name = = name then
            table.remove( WheelsUtil.tireTypes, i)
            break
        end
    end
end

```

### updateWheelsPhysics

**Description**

> Updates wheel physics

**Definition**

> updateWheelsPhysics(float dt, float currentSpeed, float acceleration, boolean doHandbrake, boolean stopAndGoBraking, )

**Arguments**

| float   | dt               | time since last call in ms                                                       |
|---------|------------------|----------------------------------------------------------------------------------|
| float   | currentSpeed     | signed current speed (m/ms)                                                      |
| float   | acceleration     | target acceleration [-1,1]                                                       |
| boolean | doHandbrake      | do handbrake                                                                     |
| boolean | stopAndGoBraking | if false, the acceleration needs to be 0 before a change of direction is allowed |
| any     | stopAndGoBraking |                                                                                  |

**Code**

```lua
function WheelsUtil.updateWheelsPhysics( self , dt, currentSpeed, acceleration, doHandbrake, stopAndGoBraking)
    --print("function WheelsUtil.updateWheelsPhysics(" .. tostring(self) .. ", " .. tostring(dt) .. ", " .. tostring(currentSpeed) .. ", " .. tostring(acceleration) .. ", " .. tostring(doHandbrake) .. ", " .. tostring(stopAndGoBraking))

        local acceleratorPedal = 0
        local brakePedal = 0

        local reverserDirection = 1
        if self.spec_drivable ~ = nil then
            reverserDirection = self.spec_drivable.reverserDirection
        end

        local motor = self.spec_motorized.motor
        local isManualTransmission = motor.backwardGears ~ = nil or motor.forwardGears ~ = nil
        local useManualDirectionChange = self:getIsManualDirectionChangeActive()
        if useManualDirectionChange then
            acceleration = acceleration * motor.currentDirection
        else
                acceleration = acceleration * reverserDirection
            end

            local absCurrentSpeed = math.abs(currentSpeed)
            local accSign = math.sign(acceleration)

            self.nextMovingDirection = self.nextMovingDirection or 0
            self.nextMovingDirectionTimer = self.nextMovingDirectionTimer or 0

            local automaticBrake = false
            if math.abs(acceleration) < 0.001 then
                automaticBrake = true

                -- Non-stop&go only allows change of direction if the vehicle speed is smaller than 1km/h or the direction has already changed(e.g.because the brakes are not hard enough)
                    if stopAndGoBraking or currentSpeed * self.nextMovingDirection < 0.0003 then
                        self.nextMovingDirection = 0
                    end
                else
                        -- Disable the known moving direction if the vehicle is driving more than 5km/h(0.0014 * 3600 = 5.04km/h) in the opposite direction
                            if self.nextMovingDirection * currentSpeed < - 0.0014 then
                                self.nextMovingDirection = 0
                            end

                            -- Continue accelerating if we want to go in the same direction
                                -- or if the vehicle is only moving slowly in the wrong direction(0.0003 * 3600 = 1.08 km/h) and we are allowed to change direction
                                    if accSign = = self.nextMovingDirection or(currentSpeed * accSign > - 0.0003 and(stopAndGoBraking or self.nextMovingDirection = = 0 )) then
                                        self.nextMovingDirectionTimer = math.max( self.nextMovingDirectionTimer - dt, 0 )
                                        if self.nextMovingDirectionTimer = = 0 then
                                            acceleratorPedal = acceleration
                                            brakePedal = 0
                                            self.nextMovingDirection = accSign
                                        else
                                                acceleratorPedal = 0
                                                brakePedal = math.abs(acceleration)
                                            end
                                        else
                                                acceleratorPedal = 0
                                                brakePedal = math.abs(acceleration)
                                                if stopAndGoBraking then
                                                    self.nextMovingDirectionTimer = 100
                                                end
                                            end
                                        end

                                        if useManualDirectionChange then
                                            if acceleratorPedal ~ = 0 and math.sign(acceleratorPedal) ~ = motor.currentDirection then
                                                brakePedal = math.abs(acceleratorPedal)
                                                acceleratorPedal = 0
                                            end
                                        end

                                        if automaticBrake then
                                            acceleratorPedal = 0
                                        end

                                        acceleratorPedal, brakePedal = motor:updateGear(acceleratorPedal, brakePedal, dt)

                                        if motor.gear = = 0 and motor.targetGear ~ = 0 then
                                            -- brake automatically if the vehicle is rolling backwards while shifting
                                                if currentSpeed * math.sign(motor.targetGear) < 0 and absCurrentSpeed < motor.lowBrakeForceSpeedLimit then
                                                    automaticBrake = true
                                                end
                                            end

                                            if motor.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
                                                if isManualTransmission then
                                                    automaticBrake = false
                                                end
                                            end

                                            if accSign ~ = 0 then
                                                if motor.lowBrakeForceLocked then
                                                    motor.lowBrakeForceLocked = false
                                                end
                                            end

                                            if automaticBrake then
                                                local isSlow = absCurrentSpeed < motor.lowBrakeForceSpeedLimit
                                                local isArticulatedSteering = self.spec_articulatedAxis ~ = nil and self.spec_articulatedAxis.componentJoint ~ = nil and math.abs( self.rotatedTime) > 0.01

                                                if (isSlow or doHandbrake) and not isArticulatedSteering or motor.lowBrakeForceLocked then
                                                    brakePedal = 1

                                                    -- if we once locked the low brake force, we keep it locked until the player provides input
                                                        if not motor.lowBrakeForceLocked and accSign = = 0 then
                                                            motor.lowBrakeForceLocked = true
                                                        end
                                                    else
                                                            -- interpolate between lowBrakeForce and 1 if speed is below 3.6 km/h
                                                                local factor = math.min(absCurrentSpeed / 0.001 , 1 )
                                                                brakePedal = MathUtil.lerp( 1 , motor.lowBrakeForceScale, factor)
                                                            end
                                                        end

                                                        SpecializationUtil.raiseEvent( self , "onVehiclePhysicsUpdate" , acceleratorPedal, brakePedal, automaticBrake, currentSpeed)

                                                        acceleratorPedal, brakePedal = WheelsUtil.getSmoothedAcceleratorAndBrakePedals( self , acceleratorPedal, brakePedal, dt)

                                                        local maxSpeed = motor:getMaximumForwardSpeed() * 3.6
                                                        if self.movingDirection < 0 then
                                                            maxSpeed = motor:getMaximumBackwardSpeed() * 3.6
                                                        end

                                                        --active braking if over the speed limit
                                                            local overSpeedLimit = self:getLastSpeed() - math.min(motor:getSpeedLimit(), maxSpeed)
                                                            if overSpeedLimit > 0 then
                                                                if overSpeedLimit > 0.3 then
                                                                    motor.overSpeedTimer = math.min(motor.overSpeedTimer + dt, 2000 )
                                                                else
                                                                        motor.overSpeedTimer = math.max(motor.overSpeedTimer - dt, 0 )
                                                                    end

                                                                    -- the longer we exceed the speed limit by min.0.3km/h, the harder we brake
                                                                    -- so we have a smooth braking when the speed limit changes and a harder brake when driving downhill with a full trailer
                                                                    local factor = 0.5 + (motor.overSpeedTimer / 2000 * 1 )

                                                                    brakePedal = math.max( math.min( math.pow(overSpeedLimit * factor, 2 ), 1 ), brakePedal)
                                                                    acceleratorPedal = 0.2 * math.max( 1 - overSpeedLimit / 0.2 , 0 ) * acceleratorPedal -- fadeout the accelerator pedal over 0.2km/h, but immediately reduce to 20% (don't set to 0 directly so that the physics engine can still compensate if the brakes are too hard)
                                                                    else
                                                                            acceleratorPedal = acceleratorPedal * math.min( math.abs(overSpeedLimit) / 0.3 + 0.2 , 1 )
                                                                            motor.overSpeedTimer = 0
                                                                        end

                                                                        if next( self.spec_motorized.differentials) ~ = nil and self.spec_motorized.motorizedNode ~ = nil then

                                                                            local absAcceleratorPedal = math.abs(acceleratorPedal)
                                                                            local minGearRatio, maxGearRatio = motor:getMinMaxGearRatio()

                                                                            if maxGearRatio > = 0 then
                                                                                maxSpeed = motor:getMaximumForwardSpeed()
                                                                            else
                                                                                    maxSpeed = motor:getMaximumBackwardSpeed()
                                                                                end

                                                                                local acceleratorPedalControlsSpeed = false
                                                                                if acceleratorPedalControlsSpeed then
                                                                                    maxSpeed = maxSpeed * absAcceleratorPedal
                                                                                    if absAcceleratorPedal > 0.001 then
                                                                                        absAcceleratorPedal = 1
                                                                                    end
                                                                                end
                                                                                maxSpeed = math.min(maxSpeed, motor:getSpeedLimit() / 3.6 )
                                                                                local maxAcceleration = motor:getAccelerationLimit()
                                                                                local maxMotorRotAcceleration = motor:getMotorRotationAccelerationLimit()
                                                                                local minMotorRpm, maxMotorRpm = motor:getRequiredMotorRpmRange()

                                                                                local neededPtoTorque, ptoTorqueVirtualMultiplicator = PowerConsumer.getTotalConsumedPtoTorque( self )
                                                                                neededPtoTorque = neededPtoTorque / motor:getPtoMotorRpmRatio()
                                                                                local neutralActive = (minGearRatio = = 0 and maxGearRatio = = 0 ) or motor:getManualClutchPedal() > 0.90

                                                                                motor:setExternalTorqueVirtualMultiplicator(ptoTorqueVirtualMultiplicator)

                                                                                --print(string.format("set vehicle props:accPed = %.1f speed = %.1f gearRatio = [%.1f %.1f] rpm = [%.1f %.1f], ptoTorque = [%.1f]", absAcceleratorPedal, maxSpeed, minGearRatio, maxGearRatio, minMotorRpm, maxMotorRpm, neededPtoTorque))
                                                                                if not neutralActive then
                                                                                    self:controlVehicle(absAcceleratorPedal, maxSpeed, maxAcceleration, minMotorRpm * math.pi / 30 , maxMotorRpm * math.pi / 30 , maxMotorRotAcceleration, minGearRatio, maxGearRatio, motor:getMaxClutchTorque(), neededPtoTorque)
                                                                                else
                                                                                        self:controlVehicle( 0.0 , 0.0 , 0.0 , 0.0 , math.huge, 0.0 , 0.0 , 0.0 , 0.0 , 0.0 )

                                                                                        -- slightly break while using manual + clutch and in neutral position
                                                                                            -- to simulate a bit of rolling resistance
                                                                                            brakePedal = math.max(brakePedal, 0.03 )
                                                                                        end
                                                                                    end

                                                                                    self:brake(brakePedal)
                                                                                end

```