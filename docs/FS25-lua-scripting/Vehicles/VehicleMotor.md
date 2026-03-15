## VehicleMotor

**Description**

> Class for vehicle motors

**Functions**

- [applyTargetGear](#applytargetgear)
- [calculatePhysicalMaximumBackwardSpeed](#calculatephysicalmaximumbackwardspeed)
- [calculatePhysicalMaximumForwardSpeed](#calculatephysicalmaximumforwardspeed)
- [calculatePhysicalMaximumSpeed](#calculatephysicalmaximumspeed)
- [changeDirection](#changedirection)
- [delete](#delete)
- [findGearChangeTargetGearPrediction](#findgearchangetargetgearprediction)
- [getAccelerationLimit](#getaccelerationlimit)
- [getBestGear](#getbestgear)
- [getBestGearRatio](#getbestgearratio)
- [getBestStartGear](#getbeststartgear)
- [getBrakeForce](#getbrakeforce)
- [getCanMotorRun](#getcanmotorrun)
- [getClutchPedal](#getclutchpedal)
- [getClutchRotSpeed](#getclutchrotspeed)
- [getClutchRpm](#getclutchrpm)
- [getCurMaxRpm](#getcurmaxrpm)
- [getDampingRateFullThrottle](#getdampingratefullthrottle)
- [getDampingRateZeroThrottleClutchDisengaged](#getdampingratezerothrottleclutchdisengaged)
- [getDampingRateZeroThrottleClutchEngaged](#getdampingratezerothrottleclutchengaged)
- [getDrivingDirection](#getdrivingdirection)
- [getEqualizedMotorRpm](#getequalizedmotorrpm)
- [getGearGroupToDisplay](#getgeargrouptodisplay)
- [getGearInfoToDisplay](#getgearinfotodisplay)
- [getGearRatio](#getgearratio)
- [getGearRatioMultiplier](#getgearratiomultiplier)
- [getGearToDisplay](#getgeartodisplay)
- [getIsGearChangeAllowed](#getisgearchangeallowed)
- [getIsGearGroupChangeAllowed](#getisgeargroupchangeallowed)
- [getIsInNeutral](#getisinneutral)
- [getLastModulatedMotorRpm](#getlastmodulatedmotorrpm)
- [getLastMotorRpm](#getlastmotorrpm)
- [getLastRealMotorRpm](#getlastrealmotorrpm)
- [getManualClutchPedal](#getmanualclutchpedal)
- [getMaxClutchTorque](#getmaxclutchtorque)
- [getMaximumBackwardSpeed](#getmaximumbackwardspeed)
- [getMaximumForwardSpeed](#getmaximumforwardspeed)
- [getMaxRpm](#getmaxrpm)
- [getMinMaxGearRatio](#getminmaxgearratio)
- [getMinRpm](#getminrpm)
- [getMotorAppliedTorque](#getmotorappliedtorque)
- [getMotorAvailableTorque](#getmotoravailabletorque)
- [getMotorExternalTorque](#getmotorexternaltorque)
- [getMotorRotationAccelerationLimit](#getmotorrotationaccelerationlimit)
- [getMotorRotSpeed](#getmotorrotspeed)
- [getNonClampedMotorRpm](#getnonclampedmotorrpm)
- [getPeakTorque](#getpeaktorque)
- [getPtoMotorRpmRatio](#getptomotorrpmratio)
- [getRequiredMotorRpmRange](#getrequiredmotorrpmrange)
- [getRequiredRpmAtSpeedLimit](#getrequiredrpmatspeedlimit)
- [getRotInertia](#getrotinertia)
- [getSmoothedClutchPedal](#getsmoothedclutchpedal)
- [getSmoothLoadPercentage](#getsmoothloadpercentage)
- [getSpeedLimit](#getspeedlimit)
- [getStartInGearFactor](#getstartingearfactor)
- [getTorque](#gettorque)
- [getTorqueAndSpeedValues](#gettorqueandspeedvalues)
- [getTorqueCurve](#gettorquecurve)
- [getTorqueCurveValue](#gettorquecurvevalue)
- [getUseAutomaticGearShifting](#getuseautomaticgearshifting)
- [getUseAutomaticGroupShifting](#getuseautomaticgroupshifting)
- [new](#new)
- [onManualClutchChanged](#onmanualclutchchanged)
- [postLoad](#postload)
- [readGearDataFromStream](#readgeardatafromstream)
- [selectGear](#selectgear)
- [selectGroup](#selectgroup)
- [setAccelerationLimit](#setaccelerationlimit)
- [setAutoGearChangeTime](#setautogearchangetime)
- [setDampingRateScale](#setdampingratescale)
- [setDirectionChange](#setdirectionchange)
- [setDirectionChangeMode](#setdirectionchangemode)
- [setEqualizedMotorRpm](#setequalizedmotorrpm)
- [setExternalTorqueVirtualMultiplicator](#setexternaltorquevirtualmultiplicator)
- [setGear](#setgear)
- [setGearChangeTime](#setgearchangetime)
- [setGearGroup](#setgeargroup)
- [setGearGroups](#setgeargroups)
- [setGearShiftMode](#setgearshiftmode)
- [setLastRpm](#setlastrpm)
- [setLowBrakeForce](#setlowbrakeforce)
- [setManualShift](#setmanualshift)
- [setMotorRotationAccelerationLimit](#setmotorrotationaccelerationlimit)
- [setRotInertia](#setrotinertia)
- [setRpmLimit](#setrpmlimit)
- [setSpeedLimit](#setspeedlimit)
- [setStartGearThreshold](#setstartgearthreshold)
- [setTransmissionDirection](#settransmissiondirection)
- [shiftGear](#shiftgear)
- [shiftGroup](#shiftgroup)
- [update](#update)
- [updateGear](#updategear)
- [updateSmoothLoadPercentage](#updatesmoothloadpercentage)
- [updateStartGearValues](#updatestartgearvalues)
- [writeGearDataToStream](#writegeardatatostream)

### applyTargetGear

**Description**

> Apply target gear

**Definition**

> applyTargetGear()

**Code**

```lua
function VehicleMotor:applyTargetGear()
    local gearRatioMultiplier = self:getGearRatioMultiplier()
    self.gear = self.targetGear

    if self.gearShiftMode ~ = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        if self.currentGears[ self.gear] ~ = nil then
            self.minGearRatio = self.currentGears[ self.gear].ratio * gearRatioMultiplier
            self.maxGearRatio = self.minGearRatio
        else
                self.minGearRatio = 0
                self.maxGearRatio = 0
            end
        end

        self.gearChangeTime = self.gearChangeTimeOrig

        local directionMultiplier = self.directionChangeUseGear and self.currentDirection or 1
        SpecializationUtil.raiseEvent( self.vehicle, "onGearChanged" , self.gear * directionMultiplier, self.targetGear * directionMultiplier, 0 , self.previousGear)
    end

```

### calculatePhysicalMaximumBackwardSpeed

**Description**

> Returns physical maximum backward speed

**Definition**

> calculatePhysicalMaximumBackwardSpeed()

**Return Values**

| any | physicalMaxBackwardSpeed | physical maximum backward speed |
|-----|--------------------------|---------------------------------|

**Code**

```lua
function VehicleMotor:calculatePhysicalMaximumBackwardSpeed()
    return VehicleMotor.calculatePhysicalMaximumSpeed( self.minBackwardGearRatio, self.backwardGears or self.forwardGears, self.maxRpm)
end

```

### calculatePhysicalMaximumForwardSpeed

**Description**

> Returns physical maximum forward speed

**Definition**

> calculatePhysicalMaximumForwardSpeed()

**Return Values**

| any | physicalMaxForwardSpeed | physical maximum forward speed |
|-----|-------------------------|--------------------------------|

**Code**

```lua
function VehicleMotor:calculatePhysicalMaximumForwardSpeed()
    return VehicleMotor.calculatePhysicalMaximumSpeed( self.minForwardGearRatio, self.forwardGears, self.maxRpm)
end

```

### calculatePhysicalMaximumSpeed

**Description**

> Returns physical maximum speed

**Definition**

> calculatePhysicalMaximumSpeed(float minGearRatio, table gears, integer maxRpm)

**Arguments**

| float   | minGearRatio | min gear ratio |
|---------|--------------|----------------|
| table   | gears        | gears          |
| integer | maxRpm       | max rpm        |

**Return Values**

| integer | physicalMaxSpeed | physical maximum speed |
|---------|------------------|------------------------|

**Code**

```lua
function VehicleMotor.calculatePhysicalMaximumSpeed(minGearRatio, gears, maxRpm)
    local minRatio
    if minGearRatio ~ = nil then
        minRatio = minGearRatio
    elseif gears ~ = nil then
            minRatio = math.huge
            for _, gear in pairs(gears) do
                minRatio = math.min(minRatio, gear.ratio)
            end
        else
                printCallstack()
                return 0
            end

            return maxRpm * math.pi / ( 30 * minRatio)
        end

```

### changeDirection

**Description**

**Definition**

> changeDirection()

**Arguments**

| any | direction |
|-----|-----------|
| any | force     |

**Code**

```lua
function VehicleMotor:changeDirection(direction, force)
    local targetDirection
    if direction = = nil then
        targetDirection = - self.currentDirection
    else
            targetDirection = direction
        end

        if self.backwardGears = = nil and self.forwardGears = = nil then
            self.currentDirection = targetDirection
            SpecializationUtil.raiseEvent( self.vehicle, "onGearDirectionChanged" , self.currentDirection)
            return
        end

        local changeAllowed = ( self.directionChangeUseGroup and not self.gearGroupChangedIsLocked)
        or( self.directionChangeUseGear and not self.gearChangedIsLocked)
        or( not self.directionChangeUseGear and not self.directionChangeUseGroup)
        if changeAllowed then
            if targetDirection ~ = self.currentDirection or force then
                self.currentDirection = targetDirection

                if self.directionChangeTime > 0 then
                    self.directionChangeTimer = self.directionChangeTime
                    self.gear = 0
                    self.minGearRatio = 0
                    self.maxGearRatio = 0
                end

                local oldGearGroupIndex = self.activeGearGroupIndex
                if self.currentDirection < 0 then
                    if self.directionChangeUseGear then
                        self.directionLastGear = self.targetGear
                        if not self:getUseAutomaticGearShifting() or not self.lastManualShifterActive then
                            self.targetGear = self.directionChangeGearIndex
                        end

                        self.currentGears = self.backwardGears or self.forwardGears
                    elseif self.directionChangeUseGroup then
                            self.directionLastGroup = self.activeGearGroupIndex
                            self.activeGearGroupIndex = self.directionChangeGroupIndex
                        end
                    else
                            if self.directionChangeUseGear then
                                if not self:getUseAutomaticGearShifting() or not self.lastManualShifterActive then
                                    if self.directionLastGear > 0 then
                                        self.targetGear = not self:getUseAutomaticGearShifting() and self.directionLastGear or self.defaultForwardGear
                                    else
                                            self.targetGear = self.defaultForwardGear
                                        end
                                    end

                                    self.currentGears = self.forwardGears
                                elseif self.directionChangeUseGroup then
                                        if self.directionLastGroup > 0 then
                                            self.activeGearGroupIndex = self.directionLastGroup
                                        else
                                                self.activeGearGroupIndex = self.defaultGearGroup
                                            end
                                        end
                                    end

                                    SpecializationUtil.raiseEvent( self.vehicle, "onGearDirectionChanged" , self.currentDirection)

                                    local directionMultiplier = self.directionChangeUseGear and self.currentDirection or 1
                                    SpecializationUtil.raiseEvent( self.vehicle, "onGearChanged" , self.gear * directionMultiplier, self.targetGear * directionMultiplier, self.directionChangeTime, self.previousGear)

                                    if self.activeGearGroupIndex ~ = oldGearGroupIndex then
                                        SpecializationUtil.raiseEvent( self.vehicle, "onGearGroupChanged" , self.activeGearGroupIndex, self.directionChangeTime)
                                    end

                                    if self.directionChangeTime = = 0 then
                                        self:applyTargetGear()
                                    end
                                end
                            end
                        end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function VehicleMotor:delete()
    g_messageCenter:unsubscribeAll( self )
end

```

### findGearChangeTargetGearPrediction

**Description**

**Definition**

> findGearChangeTargetGearPrediction()

**Arguments**

| any | curGear          |
|-----|------------------|
| any | gears            |
| any | gearSign         |
| any | gearChangeTimer  |
| any | acceleratorPedal |
| any | dt               |

**Code**

```lua
function VehicleMotor:findGearChangeTargetGearPrediction(curGear, gears, gearSign, gearChangeTimer, acceleratorPedal, dt)
    local newGear = curGear
    local gearRatioMultiplier = self:getGearRatioMultiplier()

    local minAllowedRpm, maxAllowedRpm = self.minRpm, self.maxRpm
    --print(string.format("rpmRange [%.2f %.2f]", minAllowedRpm, maxAllowedRpm))
    local gearRatio = math.abs(gears[curGear].ratio * gearRatioMultiplier)

    local differentialRotSpeed = math.max( self.differentialRotSpeed * gearSign, 0.0001 )
    local differentialRpm = differentialRotSpeed * 30 / math.pi
    local clutchRpm = differentialRpm * gearRatio
    --log("differentialRpm", differentialRpm, "gearRatio", gearRatio, "clutchRpm", clutchRpm, "gearSign", gearSign, "self.differentialRotSpeed", self.differentialRotSpeed)

    -- 1.Predict the velocity of the vehicle after the gear change
    local diffSpeedAfterChange
    if math.abs(acceleratorPedal) < 0.0001 then
        -- Assume that we will continue decelerating with 80% of the current deceleration
        local brakeAcc = math.min( self.differentialRotAccelerationSmoothed * gearSign * 0.8 , 0 )
        diffSpeedAfterChange = math.max(differentialRotSpeed + brakeAcc * self.gearChangeTime * 0.001 , 0 )
        --print(string.format("brake expectedAcc: %.3f realAcc %.3f %.3f max: %.2f gr: %.2f speed: %.2f", brakeAcc, self.vehicle.lastSpeedAcceleration*1000*1000, self.differentialRotAccelerationSmoothed, maxExpectedAcc, gearRatio, self.vehicle.lastSpeedReal*1000))
    else
            -- Ignore wheels mass as it is usually negligible and the calculation below is not correct when the differential acceleration is not uniformely distributed
            --[[local neededWheelsInertiaTorque = 0
            local specWheels = self.vehicle.spec_wheels
            for _, wheel in pairs(specWheels.wheels) do
                local invRotInterita = 2.0 / (wheel.mass*wheel.radius * wheel.radius)
                neededWheelsInertiaTorque = neededWheelsInertiaTorque + invRotInterita * self.differentialRotAcceleration * wheel.radius
            end
            neededWheelsInertiaTorque = neededWheelsInertiaTorque / (gearRatio*gearRatio)]]

            local lastMotorRotSpeed = self.motorRotSpeed - self.motorRotAcceleration * (g_physicsDtLastValidNonInterpolated * 0.001 )
            local lastDampedMotorRotSpeed = lastMotorRotSpeed / ( 1.0 + self.dampingRateFullThrottle / self.rotInertia * g_physicsDtLastValidNonInterpolated * 0.001 )

            local neededInertiaTorque = ( self.motorRotSpeed - lastDampedMotorRotSpeed) / (g_physicsDtLastValidNonInterpolated * 0.001 ) * self.rotInertia

            local lastMotorTorque = ( self.motorAppliedTorque - self.motorExternalTorque - neededInertiaTorque)

            --print(string.format("load: %.3f expected torque: %.3f neededPtoTorque %.3f neededInertiaTorque %.4f", self.motorAppliedTorque, self.motorAvailableTorque, self.motorExternalTorque, neededInertiaTorque))

            local totalMass = self.vehicle:getTotalMass()
            local expectedAcc = lastMotorTorque * gearRatio / totalMass -- differential rad/s^2

            -- The the difference in acceleration is due to gravity and thus will pull back the vehicle when changing gears and some other reasons(non-accounted mass(e.g.trees), collisions, wheel damping, wheel mass, .. .)
            -- Use a fixed factor of 90% to separate the effect of the gravity
            local uncalculatedAccFactor = 0.9
            local gravityAcc = math.max(expectedAcc * uncalculatedAccFactor - math.max( self.differentialRotAccelerationSmoothed * gearSign, 0 ), 0 )

            --print(string.format("expectedAcc: %.3f realAcc: %.3f %.3f gravityAcc: %.3f gr: %.2f mass %.1f speed: %.3f dt %.2fms", expectedAcc, self.vehicle.lastSpeedAcceleration*1000*1000, self.differentialRotAcceleration, gravityAcc, gearRatio, totalMass, self.vehicle.lastSpeedReal*1000, g_physicsDtLastValidNonInterpolated))

            diffSpeedAfterChange = math.max(differentialRotSpeed - gravityAcc * self.gearChangeTime * 0.001 , 0 )

            --log("differentialRotSpeed", differentialRotSpeed, "gravityAcc", gravityAcc, "expectedAcc", expectedAcc, "self.differentialRotAccelerationSmoothed", self.differentialRotAccelerationSmoothed, "gearRatio", gearRatio, "lastMotorTorque", lastMotorTorque, "neededInertiaTorque", neededInertiaTorque, "lastDampedMotorRotSpeed", lastDampedMotorRotSpeed, "lastMotorRotSpeed", lastMotorRotSpeed)
        end

        -- 2.Find the gear that gives the maximum power in the valid rpm range after the gear change
        -- If none is valid, store the gear that will get closest to the valid rpm range

        -- TODO allow some clutch slippage to extend the possible rpm range(e.g.when accelerating and switching from gear 1 to gear 2)

        local maxPower = 0
        local maxPowerGear = 0
        for gear = 1 , #gears do
            local rpm
            if gear = = curGear then
                rpm = clutchRpm
            else
                    rpm = diffSpeedAfterChange * math.abs(gears[gear].ratio * gearRatioMultiplier) * 30 / math.pi
                end

                -- if we could start in this gear we allow changes, no matter of rpm and power
                    local startInGearFactor = self:getStartInGearFactor(gears[gear].ratio * gearRatioMultiplier)
                    local minRpmFactor = 1
                    if startInGearFactor < self.startGearThreshold then
                        minRpmFactor = 0
                    end

                    -- current gear is always allowed since clutchRpm could be slightly higher or lower then the limits due to float 32
                    if (rpm < = maxAllowedRpm and rpm > = minAllowedRpm * minRpmFactor) or gear = = curGear then
                        local power = self:getTorqueCurveValue(rpm) * rpm
                        --print(string.format(" power %.2f @ %.d %d", power, gear, rpm))
                        if power > = maxPower then
                            maxPower = power
                            maxPowerGear = gear
                        end
                    end
                end

                --local curPower = self:getTorqueCurveValue(clutchRpm) * clutchRpm
                --print(string.format("power %.2f @ %d rpms: %.2f %.2f diffSpeedAfterChange: %.10f drpm: %.2f", curPower, curGear, clutchRpm, diffSpeedAfterChange * gearRatio * 30 / math.pi, diffSpeedAfterChange, self.differentialRotAccelerationSmoothed * gearRatio * 30 / math.pi))

                local neededPowerPct = 0.5

                -- 3.Find the gear with the best tradeoff(lots of power with low rpm)
                -- Or use the the gear will get closest to the valid rpm range if none of the gears are good
                    if maxPowerGear ~ = 0 then
                        local bestTradeoff = 0

                        for gear = #gears, 1 , - 1 do
                            local validGear = false
                            local nextRpm
                            if gear = = curGear then
                                nextRpm = clutchRpm
                            else
                                    nextRpm = diffSpeedAfterChange * math.abs(gears[gear].ratio * gearRatioMultiplier) * 30 / math.pi
                                end

                                -- if we could start in this gear we allow changes, no matter of rpm and power
                                    local startInGearFactor = self:getStartInGearFactor(gears[gear].ratio * gearRatioMultiplier)
                                    local minRpmFactor = 1
                                    local neededPowerPctGear = neededPowerPct
                                    if startInGearFactor < self.startGearThreshold then
                                        neededPowerPctGear = 0
                                        minRpmFactor = 0
                                    end

                                    if nextRpm < = maxAllowedRpm and nextRpm > = minAllowedRpm * minRpmFactor or gear = = curGear then
                                        local nextPower = self:getTorqueCurveValue(nextRpm) * nextRpm

                                        -- Choose the gear if it gets close enough to the max power
                                            if nextPower > = maxPower * neededPowerPctGear or gear = = curGear then
                                                local powerFactor = (nextPower - maxPower * neededPowerPctGear) / (maxPower * ( 1 - neededPowerPctGear)) -- 0 when at 60% of maxPower, 1 when at maxPower
                                                local curSpeedRpm = differentialRpm * math.abs(gears[gear].ratio * gearRatioMultiplier)
                                                local rpmFactor = math.clamp((maxAllowedRpm - curSpeedRpm) / math.max(maxAllowedRpm - minAllowedRpm, 0.001 ), 0 , 2 )
                                                if rpmFactor > 1 then
                                                    rpmFactor = 1 - (rpmFactor - 1 ) * 4
                                                end

                                                local gearChangeFactor
                                                if gear = = curGear then
                                                    gearChangeFactor = 1
                                                else
                                                        gearChangeFactor = math.min( - gearChangeTimer / 2000 , 0.9 ) -- the longer we wait, the less penality we add for gear changes
                                                        end

                                                        local rpmPreferenceFactor = 0
                                                        -- when shifting down the lower gear should have a higher rpm, otherwise we penalize it with -1
                                                        if gear < curGear then
                                                            rpmPreferenceFactor = math.clamp((nextRpm - clutchRpm) / 250 , - 1 , 0 )
                                                        end

                                                        -- when starting with a preselected/higher gear we force to use it as long as the factor is still valid
                                                        if gear < self.bestGearSelected then
                                                            local factor = self:getStartInGearFactor(gearRatio)
                                                            if factor < self.startGearThreshold then
                                                                gearChangeFactor = - 4
                                                            end
                                                        end

                                                        -- prefer middle rpm range instead of upper and lower 20% of range
                                                        rpmPreferenceFactor = rpmPreferenceFactor - ( 1 - math.min( math.sin(rpmFactor * math.pi) * 5 , 2 )) * 0.7

                                                        -- if multiple gears are able to stay in the prefered rpm range, we always prefer the gear we are in until it's getting out of the range
                                                            -- this prevents to much shifting when we have a lot of gears with small ratio steps
                                                            -- only apply if rpmPreferenceFactor is postive so we do not negative influence the current gear
                                                                if gear = = curGear and rpmPreferenceFactor > 0 then
                                                                    rpmPreferenceFactor = rpmPreferenceFactor * 1.5
                                                                end

                                                                if math.abs(acceleratorPedal) < 0.0001 then
                                                                    rpmFactor = 1 - rpmFactor -- choose a high rpm when decelerating
                                                                else
                                                                        rpmFactor = rpmFactor * 2
                                                                    end

                                                                    -- when just rolling allow downshifting to use motor brake when below 25% of rpm range
                                                                    -- so we avoid hitting always the highest rpm on the lower gear(would be better for motor break, but sounds stupid)
                                                                        if math.abs(acceleratorPedal) < 0.0001 then
                                                                            if (clutchRpm - minRpmFactor) / (maxAllowedRpm - minRpmFactor) > 0.25 then
                                                                                if gear < curGear then
                                                                                    powerFactor = 0
                                                                                    rpmFactor = 0
                                                                                elseif gear = = curGear then
                                                                                        powerFactor = 1
                                                                                        rpmFactor = 1
                                                                                    end
                                                                                end
                                                                            end

                                                                            -- if we could start in the gear we don't care about the power and rpm preference
                                                                                -- only apply to higher gears, so we won't accidentally rate lower gears higher than current gear if current gear is in higher rpms
                                                                                    if gear > curGear then
                                                                                        if startInGearFactor < self.startGearThreshold then
                                                                                            powerFactor = 1
                                                                                            rpmPreferenceFactor = 1
                                                                                        end
                                                                                    end

                                                                                    local tradeoff = powerFactor + rpmFactor + gearChangeFactor + rpmPreferenceFactor

                                                                                    if tradeoff > = bestTradeoff then
                                                                                        bestTradeoff = tradeoff
                                                                                        newGear = gear
                                                                                        -- print(string.format("better tradeoff %.2f with %d power: %.2f vs %.2f @ %d rpm %.2f/%.2f vs %.2f factors: %.2f %.2f %.2f %.2f", tradeoff, gear, nextPower, maxPower, maxPowerGear, nextRpm, curSpeedRpm, clutchRpm, powerFactor, rpmFactor, gearChangeFactor, rpmPreferenceFactor))
                                                                                        --else
                                                                                            -- print(string.format("worse tradeoff %.2f with %d power: %.2f vs %.2f @ %d rpm %.2f/%.2f vs %.2f factors: %.2f %.2f %.2f %.2f", tradeoff, gear, nextPower, maxPower, maxPowerGear, nextRpm, curSpeedRpm, clutchRpm, powerFactor, rpmFactor, gearChangeFactor, rpmPreferenceFactor))
                                                                                        end

                                                                                        if VehicleDebug.state = = VehicleDebug.DEBUG_TRANSMISSION then
                                                                                            gears[gear].lastTradeoff = tradeoff
                                                                                            gears[gear].lastDiffSpeedAfterChange = gear = = curGear and diffSpeedAfterChange or nil
                                                                                            gears[gear].lastPowerFactor = powerFactor
                                                                                            gears[gear].lastRpmFactor = rpmFactor
                                                                                            gears[gear].lastGearChangeFactor = gearChangeFactor
                                                                                            gears[gear].lastRpmPreferenceFactor = rpmPreferenceFactor
                                                                                            gears[gear].lastNextPower = nextPower
                                                                                            gears[gear].nextPowerValid = true
                                                                                            gears[gear].lastNextRpm = nextRpm
                                                                                            gears[gear].nextRpmValid = true
                                                                                            gears[gear].lastMaxPower = maxPower
                                                                                            gears[gear].lastHasPower = true
                                                                                        end

                                                                                        validGear = true
                                                                                    else
                                                                                            if VehicleDebug.state = = VehicleDebug.DEBUG_TRANSMISSION then
                                                                                                gears[gear].lastNextPower = nextPower
                                                                                            end
                                                                                        end
                                                                                    end

                                                                                    if not validGear then
                                                                                        if VehicleDebug.state = = VehicleDebug.DEBUG_TRANSMISSION then
                                                                                            gears[gear].lastTradeoff = 0
                                                                                            gears[gear].lastPowerFactor = 0
                                                                                            gears[gear].lastRpmFactor = 0
                                                                                            gears[gear].lastGearChangeFactor = 0
                                                                                            gears[gear].lastRpmPreferenceFactor = 0
                                                                                            gears[gear].lastDiffSpeedAfterChange = gear = = curGear and diffSpeedAfterChange or nil
                                                                                            gears[gear].lastNextRpm = nextRpm
                                                                                            gears[gear].nextRpmValid = nextRpm < = maxAllowedRpm and nextRpm > = minAllowedRpm * minRpmFactor
                                                                                            gears[gear].nextPowerValid = false
                                                                                            gears[gear].lastMaxPower = maxPower
                                                                                            gears[gear].lastHasPower = false
                                                                                        end
                                                                                    end
                                                                                end
                                                                            else
                                                                                    local minDiffGear = 0
                                                                                    local minDiff = math.huge
                                                                                    for gear = 1 ,#gears do
                                                                                        local rpm = diffSpeedAfterChange * math.abs(gears[gear].ratio * gearRatioMultiplier) * 30 / math.pi
                                                                                        local diff = math.max(rpm - maxAllowedRpm, minAllowedRpm - rpm)
                                                                                        if diff < minDiff then
                                                                                            --print(string.format("better min diff gear: %d diff: %.2f rpm: %.2f" , gear, diff, rpm))
                                                                                            minDiff = diff
                                                                                            minDiffGear = gear
                                                                                        end
                                                                                    end
                                                                                    newGear = minDiffGear
                                                                                end

                                                                                return newGear
                                                                            end

```

### getAccelerationLimit

**Description**

**Definition**

> getAccelerationLimit()

**Code**

```lua
function VehicleMotor:getAccelerationLimit()
    return self.accelerationLimit
end

```

### getBestGear

**Description**

> Returns best gear

**Definition**

> getBestGear(float acceleration, float wheelSpeedRpm, float accSafeMotorRpm, float requiredMotorPower, float
> requiredMotorRpm)

**Arguments**

| float | acceleration       | acceleration          |
|-------|--------------------|-----------------------|
| float | wheelSpeedRpm      | wheel speed rpm       |
| float | accSafeMotorRpm    | acc save motor rpm    |
| float | requiredMotorPower | required wheel torque |
| float | requiredMotorRpm   | required motor rpm    |

**Return Values**

| float | bestGear  | best gear  |
|-------|-----------|------------|
| float | gearRatio | gear ratio |

**Code**

```lua
function VehicleMotor:getBestGear(acceleration, wheelSpeedRpm, accSafeMotorRpm, requiredMotorPower, requiredMotorRpm)
    if math.abs(acceleration) < 0.001 then
        acceleration = 1
        if wheelSpeedRpm < 0 then
            acceleration = - 1
        end
    end
    if acceleration > 0 then
        if self.minForwardGearRatio ~ = nil then
            wheelSpeedRpm = math.max(wheelSpeedRpm, 0 )
            local bestGearRatio = self:getBestGearRatio(wheelSpeedRpm, self.minForwardGearRatio, self.maxForwardGearRatio, accSafeMotorRpm, requiredMotorPower, requiredMotorRpm)
            return 1 , bestGearRatio
        else
                return 1 , self.forwardGears[ 1 ].ratio
            end
        else
                if self.minBackwardGearRatio ~ = nil then
                    wheelSpeedRpm = math.max( - wheelSpeedRpm, 0 )
                    local bestGearRatio = self:getBestGearRatio(wheelSpeedRpm, self.minBackwardGearRatio, self.maxBackwardGearRatio, accSafeMotorRpm, requiredMotorPower, requiredMotorRpm)
                    return - 1 , - bestGearRatio
                else
                        if self.backwardGears ~ = nil then
                            return - 1 , - self.backwardGears[ 1 ].ratio
                        else
                                return 1 , self.forwardGears[ 1 ].ratio
                            end
                        end
                    end
                end

```

### getBestGearRatio

**Description**

> Returns best gear ratio

**Definition**

> getBestGearRatio(float wheelSpeedRpm, float minRatio, float maxRatio, float accSafeMotorRpm, float requiredMotorPower,
> float requiredMotorRpm)

**Arguments**

| float | wheelSpeedRpm      | wheel speed rpm                                                                        |
|-------|--------------------|----------------------------------------------------------------------------------------|
| float | minRatio           | min ratio                                                                              |
| float | maxRatio           | max ratio                                                                              |
| float | accSafeMotorRpm    | acc save motor rpm                                                                     |
| float | requiredMotorPower | the required motor power [kW] (can be bigger than what the motor can actually achieve) |
| float | requiredMotorRpm   | fixed motor rpm to be used (if not 0)                                                  |

**Return Values**

| float | bestGearRatio | best gear ratio |
|-------|---------------|-----------------|

**Code**

```lua
function VehicleMotor:getBestGearRatio(wheelSpeedRpm, minRatio, maxRatio, accSafeMotorRpm, requiredMotorPower, requiredMotorRpm)

    if requiredMotorRpm ~ = 0 then
        local gearRatio = math.max(requiredMotorRpm - accSafeMotorRpm, requiredMotorRpm * 0.8 ) / math.max(wheelSpeedRpm, 0.001 )
        gearRatio = math.clamp(gearRatio, minRatio, maxRatio)
        return gearRatio
    end

    -- Use a minimum wheel rpm to avoid that gearRatio is ignored
    wheelSpeedRpm = math.max(wheelSpeedRpm, 0.0001 )

    local bestMotorPower = 0
    local bestGearRatio = minRatio
    --local bestRPM = 0
    -- TODO make this more efficient
    for gearRatio = minRatio, maxRatio, 0.5 do
        local motorRpm = wheelSpeedRpm * gearRatio
        if motorRpm > self.maxRpm - accSafeMotorRpm then
            break
        end
        local motorPower = self:getTorqueCurveValue( math.max(motorRpm, self.minRpm)) * motorRpm * math.pi / 30
        if motorPower > bestMotorPower then
            bestMotorPower = motorPower
            bestGearRatio = gearRatio
            --bestRPM = motorRpm
        end

        if motorPower > = requiredMotorPower then
            break
        end
    end
    --print(string.format("Selected best gear: %f, %.2fkW rpm %.2f wheel %.2f", bestGearRatio, bestMotorPower, bestRPM, wheelSpeedRpm,))

    return bestGearRatio
end

```

### getBestStartGear

**Description**

> Returns the highest gear possible to start

**Definition**

> getBestStartGear(table gears)

**Arguments**

| table | gears | gears |
|-------|-------|-------|

**Return Values**

| table | bestGear | best gear to start |
|-------|----------|--------------------|

**Code**

```lua
function VehicleMotor:getBestStartGear(gears)
    local directionMultiplier = self.directionChangeUseGroup and 1 or self.currentDirection

    -- search for the first gear that is below our start gear threshold
        -- we start at the highest gear and go downwards
        -- if we don't find any gear below the threshold we return the lowest gear

            local minFactor = math.huge
            local minFactorGear, minFactorGroup = 1 , 1

            local maxFactor = 0
            local maxFactorGear, maxFactorGroup = 1 , 1 -- use min gear in min group as default return value
            if self.gearGroups ~ = nil then
                if self:getUseAutomaticGroupShifting() then
                    local start, limit, step = # self.gearGroups, 1 , - 1
                    if self.currentDirection < 0 then
                        start, limit, step = 1 , # self.gearGroups, 1
                    end

                    for j = start, limit, step do
                        local groupRatio = self.gearGroups[j].ratio * directionMultiplier
                        if math.sign(groupRatio) = = self.currentDirection or not self.directionChangeUseGroup then
                            for i = #gears, 1 , - 1 do
                                local factor = self:getStartInGearFactor(gears[i].ratio * groupRatio)
                                if factor < self.startGearThreshold and maxFactor = = 0 then
                                    maxFactor = factor
                                    maxFactorGear = i
                                    maxFactorGroup = j
                                end

                                if factor < minFactor then
                                    minFactor = factor
                                    minFactorGear = i
                                    minFactorGroup = j
                                end
                            end
                        end
                    end
                end
            else
                    local gearRatioMultiplier = self:getGearRatioMultiplier()
                    for i = #gears, 1 , - 1 do
                        local factor = self:getStartInGearFactor(gears[i].ratio * gearRatioMultiplier)
                        if factor < self.startGearThreshold and maxFactor = = 0 then
                            maxFactor = factor
                            maxFactorGear = i
                        end

                        if factor < minFactor then
                            minFactor = factor
                            minFactorGear = i
                        end
                    end
                end

                -- return the gear with the lowest factor if we don't find any gear below self.startGearThreshold
                    if maxFactor = = 0 then
                        return minFactorGear, minFactorGroup
                    end

                    return maxFactorGear, maxFactorGroup
                end

```

### getBrakeForce

**Description**

> Returns brake force

**Definition**

> getBrakeForce()

**Return Values**

| table | brakeForce | brake force |
|-------|------------|-------------|

**Code**

```lua
function VehicleMotor:getBrakeForce()
    return self.brakeForce
end

```

### getCanMotorRun

**Description**

**Definition**

> getCanMotorRun()

**Code**

```lua
function VehicleMotor:getCanMotorRun()
    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        if not self.vehicle:getIsMotorStarted() then
            if self.backwardGears or self.forwardGears then
                if self.manualClutchValue = = 0 and self.maxGearRatio ~ = 0 then
                    local factor = 1
                    local motorRpm = self:getNonClampedMotorRpm()
                    if motorRpm > 0 then
                        factor = ( self:getClutchRpm() + 50 ) / motorRpm
                    end

                    if factor < 0.2 then
                        return false , VehicleMotor.REASON_CLUTCH_NOT_ENGAGED
                    end
                end
            end
        end
    end

    return true
end

```

### getClutchPedal

**Description**

> Returns clutch pedal state

**Definition**

> getClutchPedal()

**Return Values**

| table | state | state [0-1] |
|-------|-------|-------------|

**Code**

```lua
function VehicleMotor:getClutchPedal()
    if not self.vehicle.isServer or self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        return self.manualClutchValue
    end

    local clutchRpm = self:getNonClampedMotorRpm()
    if clutchRpm = = 0 then
        return 0
    end

    return 1 - math.max( math.min(( self:getClutchRotSpeed() * 30 / math.pi + 50 ) / clutchRpm, 1 ), 0 ) -- have 50 rpm tolerance
end

```

### getClutchRotSpeed

**Description**

> Returns clutch rot speed

**Definition**

> getClutchRotSpeed()

**Return Values**

| table | rotSpeed | rot speed |
|-------|----------|-----------|

**Code**

```lua
function VehicleMotor:getClutchRotSpeed()
    return self.differentialRotSpeed * self.gearRatio
end

```

### getClutchRpm

**Description**

> Returns clutch rpm

**Definition**

> getClutchRpm()

**Return Values**

| table | clutchRpm | clutch rpm |
|-------|-----------|------------|

**Code**

```lua
function VehicleMotor:getClutchRpm()
    return self.differentialRotSpeed * self.gearRatio * 30 / math.pi
end

```

### getCurMaxRpm

**Description**

> Returns current max rpm

**Definition**

> getCurMaxRpm()

**Return Values**

| table | maxRpm | current max rpm |
|-------|--------|-----------------|

**Code**

```lua
function VehicleMotor:getCurMaxRpm()
    local maxRpm = self.maxRpm

    local gearRatio = self:getGearRatio()
    if gearRatio ~ = 0 then
        --local speedLimit = self.speedLimit * 0.277778
        local speedLimit = math.min( self.speedLimit, math.max( self.speedLimitAcc, self.vehicle.lastSpeedReal * 3600 )) * 0.277778
        if gearRatio > 0 then
            speedLimit = math.min(speedLimit, self.maxForwardSpeed)
        else
                speedLimit = math.min(speedLimit, self.maxBackwardSpeed)
            end

            maxRpm = math.min(maxRpm, speedLimit * 30 / math.pi * math.abs(gearRatio))
        end

        maxRpm = math.min(maxRpm, self.rpmLimit)
        return maxRpm
    end

```

### getDampingRateFullThrottle

**Description**

> Returns the damping rate of the motor if the acceleration pedal is 1

**Definition**

> getDampingRateFullThrottle()

**Return Values**

| table | dampingRate | damping rate [t m^2 s^-1] |
|-------|-------------|---------------------------|

**Code**

```lua
function VehicleMotor:getDampingRateFullThrottle()
    return self.dampingRateFullThrottle
end

```

### getDampingRateZeroThrottleClutchDisengaged

**Description**

> Returns the damping rate of the motor if the acceleration pedal is 0 and the clutch is disengaged

**Definition**

> getDampingRateZeroThrottleClutchDisengaged()

**Return Values**

| table | dampingRate | damping rate [t m^2 s^-1] |
|-------|-------------|---------------------------|

**Code**

```lua
function VehicleMotor:getDampingRateZeroThrottleClutchDisengaged()
    return self.dampingRateZeroThrottleClutchDisengaged
end

```

### getDampingRateZeroThrottleClutchEngaged

**Description**

> Returns the damping rate of the motor if the acceleration pedal is 0 and the clutch is engaged

**Definition**

> getDampingRateZeroThrottleClutchEngaged()

**Return Values**

| table | dampingRate | damping rate [t m^2 s^-1] |
|-------|-------------|---------------------------|

**Code**

```lua
function VehicleMotor:getDampingRateZeroThrottleClutchEngaged()
    return self.dampingRateZeroThrottleClutchEngaged
end

```

### getDrivingDirection

**Description**

> Returns the current driving direction or preselected direction

**Definition**

> getDrivingDirection()

**Code**

```lua
function VehicleMotor:getDrivingDirection()
    if self.directionChangeMode = = VehicleMotor.DIRECTION_CHANGE_MODE_MANUAL or self.gearShiftMode ~ = VehicleMotor.SHIFT_MODE_AUTOMATIC or( self.backwardGears or self.forwardGears) then
        return self.currentDirection * self.transmissionDirection
    else
            if self.vehicle:getLastSpeed() > 0.95 then
                return self.vehicle.movingDirection * self.transmissionDirection
            end
        end

        return 0
    end

```

### getEqualizedMotorRpm

**Description**

> Returns equalized motor rpm

**Definition**

> getEqualizedMotorRpm()

**Return Values**

| table | equalizedMotorRpm | equalized motor rpm |
|-------|-------------------|---------------------|

**Code**

```lua
function VehicleMotor:getEqualizedMotorRpm()
    return self.equalizedMotorRpm
end

```

### getGearGroupToDisplay

**Description**

> Returns the current gear group

**Definition**

> getGearGroupToDisplay()

**Arguments**

| any | isDashboard |
|-----|-------------|

**Return Values**

| any | group           | group           |
|-----|-----------------|-----------------|
| any | groupsAvailable | groupsAvailable |

**Code**

```lua
function VehicleMotor:getGearGroupToDisplay(isDashboard)
    local gearGroupName, available = "N" , false
    if self.backwardGears or self.forwardGears then
        if self.gearGroups ~ = nil then
            if self.activeGearGroupIndex > 0 then
                local gearGroup = self.gearGroups[ self.activeGearGroupIndex]
                if gearGroup ~ = nil then
                    if isDashboard then
                        gearGroupName = gearGroup.dashboardName or gearGroup.name
                    else
                            gearGroupName = gearGroup.name
                        end
                    end
                end

                available = true
            end
        end

        return gearGroupName, available
    end

```

### getGearInfoToDisplay

**Description**

> Returns the current gear information to display

**Definition**

> getGearInfoToDisplay()

**Return Values**

| any | gear             | gear                           |
|-----|------------------|--------------------------------|
| any | available        | gears are available            |
| any | isAutomatic      | is variable transmission       |
| any | prevGearName     | previous gear name             |
| any | nextGearName     | next gear name                 |
| any | prevPrevGearName | second previous gear name      |
| any | nextNextGearName | second next gear name          |
| any | isGearChanging   | is currently changing the gear |

**Code**

```lua
function VehicleMotor:getGearInfoToDisplay()
    local gearName, available = "N" , false
    local prevGearName, nextGearName
    local prevPrevGearName, nextNextGearName
    local isAutomatic = false
    local isGearChanging = false

    if self.backwardGears or self.forwardGears then
        if self.targetGear > 0 then
            local gear = self.currentGears[ self.targetGear]
            if gear ~ = nil then
                local displayDirection = self.currentDirection
                local gearNameDirection = self.currentGears = = self.forwardGears and self.currentDirection or 1

                gearName = gearNameDirection = = 1 and gear.name or gear.reverseName

                local prevGear = self.currentGears[ self.targetGear + 1 * - displayDirection]
                if prevGear ~ = nil then
                    prevGearName = gearNameDirection = = 1 and prevGear.name or prevGear.reverseName

                    prevGear = self.currentGears[ self.targetGear + 2 * - displayDirection]
                    if prevGear ~ = nil then
                        prevPrevGearName = gearNameDirection = = 1 and prevGear.name or prevGear.reverseName
                    end
                end

                local nextGear = self.currentGears[ self.targetGear + 1 * displayDirection]
                if nextGear ~ = nil then
                    nextGearName = gearNameDirection = = 1 and nextGear.name or nextGear.reverseName

                    nextGear = self.currentGears[ self.targetGear + 2 * displayDirection]
                    if nextGear ~ = nil then
                        nextNextGearName = gearNameDirection = = 1 and nextGear.name or nextGear.reverseName
                    end
                end

                if self.gear ~ = self.targetGear then
                    isGearChanging = true
                end
            end
        end

        available = true
    else
            local direction = self:getDrivingDirection()
            if direction > 0 then
                gearName = "D"
                prevGearName = "N"
            elseif direction < 0 then
                    gearName = "R"
                    nextGearName = "N"
                else
                        nextGearName = "D"
                        prevGearName = "R"
                    end

                    isAutomatic = true
                end

                return gearName, available, isAutomatic, prevGearName, nextGearName, prevPrevGearName, nextNextGearName, isGearChanging
            end

```

### getGearRatio

**Description**

**Definition**

> getGearRatio()

**Code**

```lua
function VehicleMotor:getGearRatio()
    return self.gearRatio
end

```

### getGearRatioMultiplier

**Description**

> Returns ratio from current selected gear group or 1 if non is defined

**Definition**

> getGearRatioMultiplier()

**Return Values**

| any | ratio | ratio |
|-----|-------|-------|

**Code**

```lua
function VehicleMotor:getGearRatioMultiplier()
    local multiplier = self.directionChangeUseGroup and 1 or self.currentDirection
    if self.gearGroups ~ = nil then
        if self.activeGearGroupIndex = = 0 then
            return 0
        end

        local group = self.gearGroups[ self.activeGearGroupIndex]
        if group ~ = nil then
            return group.ratio * multiplier
        end
    end

    return multiplier
end

```

### getGearToDisplay

**Description**

> Returns the current gear as string

**Definition**

> getGearToDisplay()

**Arguments**

| any | isDashboard |
|-----|-------------|

**Return Values**

| any | gear | gear |
|-----|------|------|

**Code**

```lua
function VehicleMotor:getGearToDisplay(isDashboard)
    local gearName = "N"

    if self.backwardGears or self.forwardGears then
        if self.targetGear > 0 then
            local gear = self.currentGears[ self.targetGear]
            if gear ~ = nil then
                local gearNameDirection = self.currentGears = = self.forwardGears and self.currentDirection or 1

                if isDashboard then
                    gearName = gearNameDirection = = 1 and(gear.dashboardName or gear.name) or(gear.dashboardReverseName or gear.reverseName)
                else
                        gearName = gearNameDirection = = 1 and gear.name or gear.reverseName
                    end
                end
            end
        else
                local direction = self:getDrivingDirection()
                if direction > 0 then
                    gearName = "D"
                elseif direction < 0 then
                        gearName = "R"
                    end
                end

                return gearName
            end

```

### getIsGearChangeAllowed

**Description**

> Returns is shifting is allowed due to clutch pedal state

**Definition**

> getIsGearChangeAllowed()

**Return Values**

| any | allowed | allowed |
|-----|---------|---------|

**Code**

```lua
function VehicleMotor:getIsGearChangeAllowed()
    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        if self.gearType ~ = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT then
            return self.manualClutchValue > 0.5
        end
    end

    return true
end

```

### getIsGearGroupChangeAllowed

**Description**

> Returns is shifting is allowed due to clutch pedal state

**Definition**

> getIsGearGroupChangeAllowed()

**Return Values**

| any | allowed | allowed |
|-----|---------|---------|

**Code**

```lua
function VehicleMotor:getIsGearGroupChangeAllowed()
    if self.gearGroups = = nil then
        return false
    end

    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        if self.groupType ~ = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT then
            return self.manualClutchValue > 0.5
        end
    end

    return true
end

```

### getIsInNeutral

**Description**

**Definition**

> getIsInNeutral()

**Code**

```lua
function VehicleMotor:getIsInNeutral()
    if self.backwardGears or self.forwardGears then
        if self.gear = = 0 and self.targetGear = = 0 then
            return true
        end
    end

    return false
end

```

### getLastModulatedMotorRpm

**Description**

> Returns last motor rpm modulated

**Definition**

> getLastModulatedMotorRpm()

**Return Values**

| any | lastModulatedMotorRpm | last modulated motor rpm |
|-----|-----------------------|--------------------------|

**Code**

```lua
function VehicleMotor:getLastModulatedMotorRpm()
    local modulationIntensity = math.clamp(( self.smoothedLoadPercentage - MODULATION_RPM_MIN_REF_LOAD) / (MODULATION_RPM_MAX_REF_LOAD - MODULATION_RPM_MIN_REF_LOAD), MODULATION_RPM_MIN_INTENSITY, 1 )
    local modulationOffset = self.lastModulationPercentage * (MODULATION_RPM_MAX_OFFSET * modulationIntensity) * self.constantRpmCharge

    -- apply only if clutch is released since with slipping clutch the rpm is already decreased
        local loadChangeChargeDrop = 0
        if self:getClutchPedal() < 0.1 and self.minGearRatio > 0 then
            local rpmRange = self.maxRpm - self.minRpm
            local dropScale = ( self.lastMotorRpm - self.minRpm) / rpmRange * 0.5
            loadChangeChargeDrop = self.loadPercentageChangeCharge * rpmRange * dropScale
        else
                self.loadPercentageChangeCharge = 0
            end

            if self.lastMotorRpm = = 0 then
                return 0
            end

            return self.lastMotorRpm + modulationOffset - loadChangeChargeDrop
        end

```

### getLastMotorRpm

**Description**

> Returns last motor rpm damped

**Definition**

> getLastMotorRpm()

**Return Values**

| any | lastMotorRpm | last motor rpm |
|-----|--------------|----------------|

**Code**

```lua
function VehicleMotor:getLastMotorRpm()
    return self.lastMotorRpm
end

```

### getLastRealMotorRpm

**Description**

> Returns last motor rpm real

**Definition**

> getLastRealMotorRpm()

**Return Values**

| any | lastMotorRpm | last motor rpm |
|-----|--------------|----------------|

**Code**

```lua
function VehicleMotor:getLastRealMotorRpm()
    return self.lastRealMotorRpm
end

```

### getManualClutchPedal

**Description**

> Returns manual clutch pedal state

**Definition**

> getManualClutchPedal()

**Return Values**

| any | state | state [0-1] |
|-----|-------|-------------|

**Code**

```lua
function VehicleMotor:getManualClutchPedal()
    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        return self.manualClutchValue
    end

    return 0
end

```

### getMaxClutchTorque

**Description**

> Returns max clutch torque

**Definition**

> getMaxClutchTorque()

**Return Values**

| any | maxClutchTorque | max clutch torque |
|-----|-----------------|-------------------|

**Code**

```lua
function VehicleMotor:getMaxClutchTorque()
    return self.maxClutchTorque
end

```

### getMaximumBackwardSpeed

**Description**

> Returns maximum backward speed

**Definition**

> getMaximumBackwardSpeed()

**Return Values**

| any | maxBackwardSpeed | maximum backward speed |
|-----|------------------|------------------------|

**Code**

```lua
function VehicleMotor:getMaximumBackwardSpeed()
    return self.maxBackwardSpeed
end

```

### getMaximumForwardSpeed

**Description**

> Returns maximum forward speed

**Definition**

> getMaximumForwardSpeed()

**Return Values**

| any | maxForwardSpeed | maximum forward speed |
|-----|-----------------|-----------------------|

**Code**

```lua
function VehicleMotor:getMaximumForwardSpeed()
    return self.maxForwardSpeed
end

```

### getMaxRpm

**Description**

> Returns max rpm

**Definition**

> getMaxRpm()

**Return Values**

| any | maxRpm | max rpm |
|-----|--------|---------|

**Code**

```lua
function VehicleMotor:getMaxRpm()
    return self.maxRpm
end

```

### getMinMaxGearRatio

**Description**

> Returns currently selected minimum and maximum gear ratio
> Gear ratios for driving backwards are negative. Min/max always refers to the absolute value
> For regular gear box transmission, the minimum and maximum gear ratios are identical

**Definition**

> getMinMaxGearRatio()

**Return Values**

| any | minGearRatio | minimum gear ratio |
|-----|--------------|--------------------|
| any | maxGearRatio | maximum gear ratio |

**Code**

```lua
function VehicleMotor:getMinMaxGearRatio()
    local minRatio = self.minGearRatio
    local maxRatio = self.maxGearRatio

    if self.minGearRatio ~ = 0 or self.maxGearRatio ~ = 0 then
        if self.clutchSlippingTimer = = self.clutchSlippingTime then
            -- use high max gear ratio for smooth acceleration since we are not in a speed where we can fully engage the gear
                maxRatio = math.max( 350 , self.maxGearRatio) * math.sign( self.maxGearRatio)
            elseif self.clutchSlippingTimer > 0 then
                    -- after we reached 75% of the min.needed differential speed we slowly fade into the target gear ratio
                    minRatio = MathUtil.lerp(minRatio, self.clutchSlippingGearRatio, self.clutchSlippingTimer / self.clutchSlippingTime)
                    maxRatio = MathUtil.lerp(maxRatio, self.clutchSlippingGearRatio, self.clutchSlippingTimer / self.clutchSlippingTime)
                end
            end

            return minRatio, maxRatio
        end

```

### getMinRpm

**Description**

> Returns min rpm

**Definition**

> getMinRpm()

**Return Values**

| any | minRpm | min rpm |
|-----|--------|---------|

**Code**

```lua
function VehicleMotor:getMinRpm()
    return self.minRpm
end

```

### getMotorAppliedTorque

**Description**

> Returns the last applied torque to the motor

**Definition**

> getMotorAppliedTorque()

**Return Values**

| any | appliedTorque | torque [kN] |
|-----|---------------|-------------|

**Code**

```lua
function VehicleMotor:getMotorAppliedTorque()
    return self.motorAppliedTorque
end

```

### getMotorAvailableTorque

**Description**

> Returns the last total available motor torque

**Definition**

> getMotorAvailableTorque()

**Return Values**

| any | torque | external torque [kN] |
|-----|--------|----------------------|

**Code**

```lua
function VehicleMotor:getMotorAvailableTorque()
    return self.motorAvailableTorque
end

```

### getMotorExternalTorque

**Description**

> Returns the last applied external torque (torque used by external power consumers like the PTO)

**Definition**

> getMotorExternalTorque()

**Return Values**

| any | externalTorque | external torque [kN] |
|-----|----------------|----------------------|

**Code**

```lua
function VehicleMotor:getMotorExternalTorque()
    return self.motorExternalTorque
end

```

### getMotorRotationAccelerationLimit

**Description**

**Definition**

> getMotorRotationAccelerationLimit()

**Code**

```lua
function VehicleMotor:getMotorRotationAccelerationLimit()
    return self.motorRotationAccelerationLimit
end

```

### getMotorRotSpeed

**Description**

> Returns motor rot speed

**Definition**

> getMotorRotSpeed()

**Return Values**

| any | rotSpeed | rot speed |
|-----|----------|-----------|

**Code**

```lua
function VehicleMotor:getMotorRotSpeed()
    return self.motorRotSpeed
end

```

### getNonClampedMotorRpm

**Description**

> Returns non clamped motor rpm

**Definition**

> getNonClampedMotorRpm()

**Return Values**

| any | nonClampedMotorRpm | non clamped motor rpm |
|-----|--------------------|-----------------------|

**Code**

```lua
function VehicleMotor:getNonClampedMotorRpm()
    return self.motorRotSpeed * 30 / math.pi
end

```

### getPeakTorque

**Description**

> Returns max torque

**Definition**

> getPeakTorque()

**Return Values**

| any | maxMotorTorque | max motor torque |
|-----|----------------|------------------|

**Code**

```lua
function VehicleMotor:getPeakTorque()
    return self.peakMotorTorque
end

```

### getPtoMotorRpmRatio

**Description**

> Returns pto motor rpm ratio

**Definition**

> getPtoMotorRpmRatio()

**Return Values**

| any | ptoMotorRpmRatio | pto motor rpm ratio |
|-----|------------------|---------------------|

**Code**

```lua
function VehicleMotor:getPtoMotorRpmRatio()
    return self.ptoMotorRpmRatio
end

```

### getRequiredMotorRpmRange

**Description**

> Returns the currently required motor rpm range (e.g. defined by the activated pto)

**Definition**

> getRequiredMotorRpmRange()

**Return Values**

| any | minRequiredRpm | min required rpm |
|-----|----------------|------------------|
| any | minRequiredRpm | max required rpm |

**Code**

```lua
function VehicleMotor:getRequiredMotorRpmRange()
    local motorPtoRpm = math.min( PowerConsumer.getMaxPtoRpm( self.vehicle) * self.ptoMotorRpmRatio, self.maxRpm)
    if motorPtoRpm ~ = 0 then
        return motorPtoRpm, self.maxRpm
    end
    return self.minRpm, self.maxRpm
end

```

### getRequiredRpmAtSpeedLimit

**Description**

> Returns the rpm while driving with this gear ratio

**Definition**

> getRequiredRpmAtSpeedLimit(float ratio)

**Arguments**

| float | ratio | gear ratio to check |
|-------|-------|---------------------|

**Return Values**

| float | rpm | rpm |
|-------|-----|-----|

**Code**

```lua
function VehicleMotor:getRequiredRpmAtSpeedLimit(ratio)
    -- use vehicle speed limit(normally from working tool) and cruise control speed, not motor speed limit to avoid issues with ai since the ai is permanently controlling the motor speed limit on headlands
    -- this leads to permanent gear shifts and wrong starting gears
    local speedLimit = math.min( self.vehicle:getSpeedLimit( true ), math.max( self.speedLimitAcc, self.vehicle.lastSpeedReal * 3600 ))
    if self.vehicle:getCruiseControlState() = = Drivable.CRUISECONTROL_STATE_ACTIVE then
        speedLimit = math.min(speedLimit, self.vehicle:getCruiseControlSpeed())
    end

    speedLimit = ratio > 0 and math.min(speedLimit, self.maxForwardSpeed * 3.6 ) or math.min(speedLimit, self.maxBackwardSpeed * 3.6 )
    return speedLimit / 3.6 * 30 / math.pi * math.abs(ratio)
end

```

### getRotInertia

**Description**

> Returns rotation inertia

**Definition**

> getRotInertia()

**Return Values**

| float | rotInertia | rotation inertia |
|-------|------------|------------------|

**Code**

```lua
function VehicleMotor:getRotInertia()
    return self.rotInertia
end

```

### getSmoothedClutchPedal

**Description**

> Returns smoothed clutch pedal state

**Definition**

> getSmoothedClutchPedal()

**Return Values**

| float | state | state [0-1] |
|-------|-------|-------------|

**Code**

```lua
function VehicleMotor:getSmoothedClutchPedal()
    return self.lastSmoothedClutchPedal
end

```

### getSmoothLoadPercentage

**Description**

> Returns the last smoothed load percentage

**Definition**

> getSmoothLoadPercentage()

**Return Values**

| float | load | load [0-1] |
|-------|------|------------|

**Code**

```lua
function VehicleMotor:getSmoothLoadPercentage()
    local modulationIntensity = math.clamp(( self.smoothedLoadPercentage - MODULATION_LOAD_MIN_REF_LOAD) / (MODULATION_LOAD_MAX_REF_LOAD - MODULATION_LOAD_MIN_REF_LOAD), MODULATION_LOAD_MIN_INTENSITY, 1 )
    return self.smoothedLoadPercentage - self.lastModulationPercentage * (MODULATION_LOAD_MAX_OFFSET * modulationIntensity)
end

```

### getSpeedLimit

**Description**

**Definition**

> getSpeedLimit()

**Code**

```lua
function VehicleMotor:getSpeedLimit()
    return self.speedLimit
end

```

### getStartInGearFactor

**Description**

> Returns factor which defines if the vehicle can start with the given gear ratio

**Definition**

> getStartInGearFactor(float ratio)

**Arguments**

| float | ratio | gear ratio to check |
|-------|-------|---------------------|

**Return Values**

| float | startFactor | start factor |
|-------|-------------|--------------|

**Code**

```lua
function VehicleMotor:getStartInGearFactor(ratio)
    -- if we cannot run the gear with at least 25% rpm with the current speed limit we skip it
        if self:getRequiredRpmAtSpeedLimit(ratio) < self.minRpm + ( self.maxRpm - self.minRpm) * 0.25 then
            return math.huge
        end

        local slope = self.startGearValues.slope
        if ratio < 0 then
            slope = - slope
        end

        local slopePowerFactor = (( self.startGearValues.availablePower / 100 - 1 ) / 2 ) ^ 2 * 2 + 1
        local slopeFactor = 1 + math.max(slope, 0 ) / (slopePowerFactor * 0.06981 ) -- 4 degrees
        return self.startGearValues.massFactor * slopeFactor / ( math.abs(ratio) / 300 )
    end

```

### getTorque

**Description**

> Returns torque of the motor at the current rpm with the given accelerator pedal

**Definition**

> getTorque(float acceleration)

**Arguments**

| float | acceleration | acceleration |
|-------|--------------|--------------|

**Return Values**

| float | torque | torque |
|-------|--------|--------|

**Code**

```lua
function VehicleMotor:getTorque(acceleration)
    -- Note:the torque curve is undefined outside the min/max rpm range.Clamping makes the curve flat at the outside range
    local torque = self:getTorqueCurveValue( math.clamp( self.motorRotSpeed * 30 / math.pi, self.minRpm, self.maxRpm))
    torque = torque * math.abs(acceleration)
    return torque
end

```

### getTorqueAndSpeedValues

**Description**

**Definition**

> getTorqueAndSpeedValues()

**Code**

```lua
function VehicleMotor:getTorqueAndSpeedValues()
    local rotationSpeeds = { }
    local torques = { }
    for _,v in ipairs( self:getTorqueCurve().keyframes) do
        table.insert(rotationSpeeds, v.time * math.pi / 30 )
        table.insert(torques, self:getTorqueCurveValue(v.time ))
    end

    return torques, rotationSpeeds
end

```

### getTorqueCurve

**Description**

> Returns torque curve

**Definition**

> getTorqueCurve()

**Return Values**

| float | torqueCurve | torque curve |
|-------|-------------|--------------|

**Code**

```lua
function VehicleMotor:getTorqueCurve()
    return self.torqueCurve
end

```

### getTorqueCurveValue

**Description**

> Returns torque of the motor at the given rpm

**Definition**

> getTorqueCurveValue(float rpm)

**Arguments**

| float | rpm | rpm |
|-------|-----|-----|

**Return Values**

| float | torque | torque |
|-------|--------|--------|

**Code**

```lua
function VehicleMotor:getTorqueCurveValue(rpm)
    local damage = 1 - ( self.vehicle:getVehicleDamage() * VehicleMotor.DAMAGE_TORQUE_REDUCTION)
    return self:getTorqueCurve():get(rpm) * damage
end

```

### getUseAutomaticGearShifting

**Description**

**Definition**

> getUseAutomaticGearShifting()

**Code**

```lua
function VehicleMotor:getUseAutomaticGearShifting()
    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_AUTOMATIC then
        return true
    end

    if not self.manualShiftGears then
        return true
    end

    return false
end

```

### getUseAutomaticGroupShifting

**Description**

**Definition**

> getUseAutomaticGroupShifting()

**Code**

```lua
function VehicleMotor:getUseAutomaticGroupShifting()
    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_AUTOMATIC then
        return true
    end

    if not self.manualShiftGroups then
        return true
    end

    return false
end

```

### new

**Description**

> Creating new motor

**Definition**

> new(integer minRpm, integer maxRpm, float maxForwardSpeed, float maxBackwardSpeed, table torqueCurve, float
> brakeForce, float forwardGears, float backwardGears, float minForwardGearRatio, float maxForwardGearRatio, float
> minBackwardGearRatio, float maxBackwardGearRatio, integer ptoMotorRpmRatio, , )

**Arguments**

| integer | minRpm               | min rpm                                                                 |
|---------|----------------------|-------------------------------------------------------------------------|
| integer | maxRpm               | max rpm                                                                 |
| float   | maxForwardSpeed      | max forward speed                                                       |
| float   | maxBackwardSpeed     | max backward speed                                                      |
| table   | torqueCurve          | torque curve (AnimCurve)                                                |
| float   | brakeForce           | brake force                                                             |
| float   | forwardGears         | list of gear ratios to use when driving forwards (in decreasing order)  |
| float   | backwardGears        | list of gear ratios to use when driving backwards (in decreasing order) |
| float   | minForwardGearRatio  | min forward gear ratio                                                  |
| float   | maxForwardGearRatio  | max forward gear ratio                                                  |
| float   | minBackwardGearRatio | min backward gear ratio                                                 |
| float   | maxBackwardGearRatio | max backward gear ratio                                                 |
| integer | ptoMotorRpmRatio     | pto motor rpm ratio                                                     |
| any     | ptoMotorRpmRatio     |                                                                         |
| any     | minSpeed             |                                                                         |

**Return Values**

| any | motorInstance | motor instance |
|-----|---------------|----------------|

**Code**

```lua
function VehicleMotor.new(vehicle, minRpm, maxRpm, maxForwardSpeed, maxBackwardSpeed, torqueCurve, brakeForce, forwardGears, backwardGears, minForwardGearRatio, maxForwardGearRatio, minBackwardGearRatio, maxBackwardGearRatio, ptoMotorRpmRatio, minSpeed)

    local self = setmetatable( { } , VehicleMotor _mt)

    self.vehicle = vehicle
    self.minRpm = minRpm
    self.maxRpm = maxRpm
    self.minSpeed = minSpeed
    self.maxForwardSpeed = maxForwardSpeed -- speed in m/s
    self.maxBackwardSpeed = maxBackwardSpeed

    self.maxClutchTorque = 5 -- amount of torque that can be transferred from motor to clutch/wheels [t m s^-2]

    self.torqueCurve = torqueCurve
    self.brakeForce = brakeForce

    self.lastAcceleratorPedal = 0
    self.idleGearChangeTimer = 0 -- if this timer reaches 0 the automatic gear change while not moving is allowed
        self.doSecondBestGearSelection = 0

        self.gear = 0
        self.bestGearSelected = 0
        self.minGearRatio = 0
        self.maxGearRatio = 0
        self.allowGearChangeTimer = 0
        self.allowGearChangeDirection = 0

        self.forwardGears = forwardGears
        self.backwardGears = backwardGears
        self.currentGears = self.forwardGears
        self.minForwardGearRatio = minForwardGearRatio
        self.maxForwardGearRatio = maxForwardGearRatio
        self.minBackwardGearRatio = minBackwardGearRatio
        self.maxBackwardGearRatio = maxBackwardGearRatio

        self.transmissionDirection = 1

        self.maxClutchSpeedDifference = 0
        self.defaultForwardGear = 1
        if self.forwardGears ~ = nil then
            for i = 1 , # self.forwardGears do
                self.maxClutchSpeedDifference = math.max( self.maxClutchSpeedDifference, self.minRpm / self.forwardGears[i].ratio * math.pi / 30 )
                if self.forwardGears[i].default then
                    self.defaultForwardGear = i
                end
            end
        end

        self.defaultBackwardGear = 1
        if self.backwardGears ~ = nil then
            for i = 1 , # self.backwardGears do
                self.maxClutchSpeedDifference = math.max( self.maxClutchSpeedDifference, self.minRpm / self.backwardGears[i].ratio * math.pi / 30 )
                if self.backwardGears[i].default then
                    self.defaultBackwardGear = i
                end
            end
        end

        self.gearType = VehicleMotor.TRANSMISSION_TYPE.DEFAULT
        self.groupType = VehicleMotor.TRANSMISSION_TYPE.DEFAULT

        self.manualTargetGear = nil
        self.targetGear = 0
        self.previousGear = 0
        self.gearChangeTimer = - 1
        self.gearChangeTime = 250
        self.gearChangeTimeOrig = self.gearChangeTime
        self.autoGearChangeTimer = - 1
        self.autoGearChangeTime = 1000
        self.manualClutchValue = 0
        self.stallTimer = 0
        self.lastGearChangeTime = 0
        self.gearChangeTimeAutoReductionTime = 500
        self.gearChangeTimeAutoReductionTimer = 0

        self.lastManualShifterActive = false

        self.clutchSlippingTime = 1000
        self.clutchSlippingTimer = 0
        self.clutchSlippingGearRatio = 0

        self.groupChangeTime = 500
        self.groupChangeTimer = 0
        self.gearGroupUpShiftTime = 3000
        self.gearGroupUpShiftTimer = 0

        self.currentDirection = 1 -- current used gear direction
        self.directionChangeTimer = 0
        self.directionChangeTime = 500
        self.directionChangeUseGear = false -- use a backward gear for direction change buttons
            self.directionChangeGearIndex = 1 -- backward gear to activate if direction changes
                self.directionLastGear = - 1 -- last forward gear, activated if direction is changed again
                    self.directionChangeUseGroup = false -- use a group for direction change buttons
                        self.directionChangeGroupIndex = 1 -- group to activate if direction changes
                            self.directionLastGroup = - 1 -- last selected group, acitvated if direction changes again
                                self.directionChangeUseInverse = true -- if true the forward gears are just inverted for driving backwards

                                    self.gearChangedIsLocked = false
                                    self.gearGroupChangedIsLocked = false

                                    self.startGearValues = {
                                    slope = 0 ,
                                    mass = 0 ,
                                    lastMass = 0 ,
                                    maxForce = 0 ,
                                    massDirectionDifferenceXZ = 0 ,
                                    massDirectionDifferenceY = 0 ,
                                    massDirectionFactor = 0 ,
                                    availablePower = 0 ,
                                    massFactor = 0
                                    }

                                    self.startGearThreshold = VehicleMotor.GEAR_START_THRESHOLD

                                    self.lastSmoothedClutchPedal = 0

                                    self.lastRealMotorRpm = 0
                                    self.lastMotorRpm = 0

                                    self.lastModulationPercentage = 0
                                    self.lastModulationTimer = 0

                                    self.rawLoadPercentage = 0
                                    self.rawLoadPercentageBuffer = 0
                                    self.rawLoadPercentageBufferIndex = 0
                                    self.smoothedLoadPercentage = 0
                                    self.loadPercentageChangeCharge = 0

                                    self.accelerationLimitLoadScale = 1
                                    self.accelerationLimitLoadScaleTimer = 0
                                    self.accelerationLimitLoadScaleDelay = 2000 -- after running this time at max acceleration we decrease the motor load slowly again

                                    self.constantRpmCharge = 0
                                    self.constantAccelerationCharge = 0

                                    self.lastTurboScale = 0
                                    self.blowOffValveState = 0

                                    self.overSpeedTimer = 0

                                    self.rpmLimit = math.huge
                                    self.speedLimit = math.huge -- Speed limit in km/h
                                    self.speedLimitAcc = math.huge

                                    self.accelerationLimit = 2 -- m s^-2

                                    self.motorRotationAccelerationLimit = (maxRpm - minRpm) * math.pi / 30 / 2 -- rad s^-2 default accelerate from min rpm to max rpm in 2 sec

                                    self.equalizedMotorRpm = 0

                                    self.requiredMotorPower = 0

                                    if self.maxForwardSpeed = = nil then
                                        self.maxForwardSpeed = self:calculatePhysicalMaximumForwardSpeed()
                                    end
                                    if self.maxBackwardSpeed = = nil then
                                        self.maxBackwardSpeed = self:calculatePhysicalMaximumBackwardSpeed()
                                    end

                                    -- saving the original values to be able to inverse them
                                    self.maxForwardSpeedOrigin = self.maxForwardSpeed
                                    self.maxBackwardSpeedOrigin = self.maxBackwardSpeed
                                    self.minForwardGearRatioOrigin = self.minForwardGearRatio
                                    self.maxForwardGearRatioOrigin = self.maxForwardGearRatio
                                    self.minBackwardGearRatioOrigin = self.minBackwardGearRatio
                                    self.maxBackwardGearRatioOrigin = self.maxBackwardGearRatio

                                    self.peakMotorTorque = self.torqueCurve:getMaximum()

                                    -- Calculate peak power.Assume we have a linear interpolation on the torque values
                                    -- For each segment, find the maximum power(D[torque(x, i) * x] = = 0) and take the maximum segment
                                    -- D[ ((x-x0) / (x1-x0) (y1-y0) + y0) x] = = 0
                                    -- -> (x1 y0 - x0 y1) / (2(y0 - y1)) if y0 ! = y1
                                        self.peakMotorPower = 0
                                        self.peakMotorPowerRotSpeed = 0
                                        local numKeyFrames = # self.torqueCurve.keyframes
                                        if numKeyFrames > = 2 then
                                            for i = 2 ,numKeyFrames do
                                                local v0 = self.torqueCurve.keyframes[i - 1 ]
                                                local v1 = self.torqueCurve.keyframes[i]
                                                local torque0 = self.torqueCurve:getFromKeyframes(v0, v0, i - 1 , i - 1 , 0 )
                                                local torque1 = self.torqueCurve:getFromKeyframes(v1, v1, i, i, 0 )
                                                local rpm, torque
                                                if math.abs(torque0 - torque1) > 0.0001 then
                                                    rpm = (v1.time * torque0 - v0.time * torque1) / ( 2.0 * (torque0 - torque1))
                                                    rpm = math.min( math.max(rpm, v0.time ), v1.time )
                                                    torque = self.torqueCurve:getFromKeyframes(v0, v1, i - 1 , i, (v1.time - rpm) / (v1.time - v0.time ))
                                                else
                                                        rpm = v0.time
                                                        torque = torque0
                                                    end
                                                    local power = torque * rpm
                                                    if power > self.peakMotorPower then
                                                        self.peakMotorPower = power
                                                        self.peakMotorPowerRotSpeed = rpm
                                                    end
                                                end
                                                -- Convert from rpm to rad/s
                                                self.peakMotorPower = self.peakMotorPower * math.pi / 30
                                                self.peakMotorPowerRotSpeed = self.peakMotorPowerRotSpeed * math.pi / 30
                                            else
                                                    local v = self.torqueCurve.keyframes[ 1 ]
                                                    local rotSpeed = v.time * math.pi / 30
                                                    local torque = self.torqueCurve:getFromKeyframes(v, v, 1 , 1 , 0 )
                                                    self.peakMotorPower = rotSpeed * torque
                                                    self.peakMotorPowerRotSpeed = rotSpeed
                                                end

                                                self.ptoMotorRpmRatio = ptoMotorRpmRatio

                                                self.rotInertia = self.peakMotorTorque / 600 -- Rotational inertia of the motor, mostly defined by the flywheel [t m^2]
                                                self.dampingRateFullThrottle = VehicleMotor.DEFAULT_DAMPING_RATE_FULL_THROTTLE -- Damping rate of the motor if the acceleration pedal is 1 [t m^2 s^-1]
                                                    self.dampingRateZeroThrottleClutchEngaged = VehicleMotor.DEFAULT_DAMPING_RATE_ZERO_THROTTLE_CLUTCH_EN -- Damping rate of the motor if the acceleration pedal is 0 and the clutch is engaged [t m^2 s^-1]
                                                        self.dampingRateZeroThrottleClutchDisengaged = VehicleMotor.DEFAULT_DAMPING_RATE_ZERO_THROTTLE_CLUTCH_DIS -- Damping rate of the motor if the acceleration pedal is 0 and the clutch is disengaged [t m^2 s^-1]

                                                            -- Motor properties as read from the physics engine
                                                            self.gearRatio = 0
                                                            self.motorRotSpeed = 0 -- motor rotation speed [rad/s]
                                                            self.motorRotSpeedClutchEngaged = 0 -- additional rotation speed when clutch is engaged
                                                            self.motorRotAcceleration = 0 -- motor rotation acceleration [rad/s^2]
                                                            self.motorRotAccelerationSmoothed = 0 -- motor rotation acceleration smoothed [rad/s^2]

                                                            self.motorAvailableTorque, self.lastMotorAvailableTorque = 0 , 0 -- torque that was available to the physics simulation [kN = = t m/s^2]
                                                            self.motorAppliedTorque, self.lastMotorAppliedTorque = 0 , 0 -- torque that was applied(< = available), can be smaller when acceleration/speed is limited [kN = = t m/s^2]
                                                            self.motorExternalTorque, self.lastMotorExternalTorque = 0 , 0 -- torque that was removed from the motor and was not applied to the wheels(e.g.PTO) [kN = = t m/s^2]

                                                            -- externalTorqueVirtualMultiplicator:is used to have virtually more motor load due to external torque(pto) but still reduce the motor by the same external torque
                                                            -- like this we can increase the motor load without cutting the motor to hard so we cannot accelerate anymore
                                                            self.externalTorqueVirtualMultiplicator = 1

                                                            self.differentialRotSpeed = 0 -- rotation speed of the main differential [rad/s]
                                                            self.differentialRotAcceleration = 0 -- rotation accleration of the main differential [rad/s^2]
                                                            self.differentialRotAccelerationSmoothed = 0 -- smoothed rotation accleration of the main differential [rad/s^2]

                                                            self.differentialRotAccelerationIndex = 1
                                                            self.differentialRotAccelerationSamples = { }
                                                            for _ = 1 , 10 do
                                                                table.insert( self.differentialRotAccelerationSamples, 0 )
                                                            end

                                                            self.lastDifference = 0

                                                            self.directionChangeMode = g_gameSettings:getValue(GameSettings.SETTING.DIRECTION_CHANGE_MODE)
                                                            self.gearShiftMode = g_gameSettings:getValue(GameSettings.SETTING.GEAR_SHIFT_MODE)

                                                            return self
                                                        end

```

### onManualClutchChanged

**Description**

> Called when manual clutch value changes

**Definition**

> onManualClutchChanged(float value)

**Arguments**

| float | value | value |
|-------|-------|-------|

**Code**

```lua
function VehicleMotor:onManualClutchChanged(clutchValue)
    self.manualClutchValue = clutchValue
end

```

### postLoad

**Description**

> Post load motor

**Definition**

> postLoad(table savegame)

**Arguments**

| table | savegame | savegame information |
|-------|----------|----------------------|

**Code**

```lua
function VehicleMotor:postLoad(savegame)
    if self.gearGroups ~ = nil then
        SpecializationUtil.raiseEvent( self.vehicle, "onGearGroupChanged" , self.activeGearGroupIndex, 0 )
    end
end

```

### readGearDataFromStream

**Description**

> Reads current gear data from stream

**Definition**

> readGearDataFromStream()

**Arguments**

| any | streamId |
|-----|----------|

**Code**

```lua
function VehicleMotor:readGearDataFromStream(streamId)
    self.currentDirection = streamReadUIntN(streamId, 2 ) - 1

    if streamReadBool(streamId) then
        local gear = streamReadUIntN(streamId, 6 )
        local changingGear = streamReadBool(streamId)

        if streamReadBool(streamId) then
            self.currentGears = self.forwardGears
        else
                self.currentGears = self.backwardGears
            end

            local activeGearGroupIndex
            if self.gearGroups ~ = nil then
                activeGearGroupIndex = streamReadUIntN(streamId, 5 )
            end

            if gear ~ = self.gear then
                if changingGear and self.gear ~ = 0 then
                    self.lastGearChangeTime = g_ time
                end

                self.previousGear = self.gear
                self.gear = changingGear and 0 or gear
                self.targetGear = gear

                local directionMultiplier = self.directionChangeUseGear and self.currentDirection or 1
                SpecializationUtil.raiseEvent( self.vehicle, "onGearChanged" , self.gear * directionMultiplier, self.targetGear * directionMultiplier, 0 , self.previousGear)
            end

            if activeGearGroupIndex ~ = self.activeGearGroupIndex then
                self.activeGearGroupIndex = activeGearGroupIndex
                SpecializationUtil.raiseEvent( self.vehicle, "onGearGroupChanged" , self.activeGearGroupIndex, self.groupType = = VehicleMotor.TRANSMISSION_TYPE.DEFAULT and self.groupChangeTime or 0 )
            end
        end
    end

```

### selectGear

**Description**

**Definition**

> selectGear()

**Arguments**

| any | gearIndex  |
|-----|------------|
| any | activation |

**Code**

```lua
function VehicleMotor:selectGear(gearIndex, activation)
    if activation then
        if self.gear ~ = gearIndex then
            if self:getIsGearChangeAllowed() then
                if self.currentGears[gearIndex] ~ = nil then
                    self:setGear(gearIndex, true )
                    self.lastManualShifterActive = true
                end
            else
                    SpecializationUtil.raiseEvent( self.vehicle, "onClutchCreaking" , false , false , gearIndex)
                end
            end
        else
                -- go into neutral state if any gear input action is released
                    self:setGear( 0 , false )
                    self.lastManualShifterActive = true
                end
            end

```

### selectGroup

**Description**

**Definition**

> selectGroup()

**Arguments**

| any | groupIndex |
|-----|------------|
| any | activation |

**Code**

```lua
function VehicleMotor:selectGroup(groupIndex, activation)
    if activation then
        if self:getIsGearGroupChangeAllowed() then
            if self.gearGroups ~ = nil then
                if self.gearGroups[groupIndex] ~ = nil then
                    self:setGearGroup(groupIndex, true )
                end
            end
        else
                if self.activeGearGroupIndex ~ = groupIndex then
                    SpecializationUtil.raiseEvent( self.vehicle, "onClutchCreaking" , false , true , nil , groupIndex)
                end
            end
        else
                -- go into neutral state if any group input action is released
                    self:setGearGroup( 0 , false )
                end
            end

```

### setAccelerationLimit

**Description**

**Definition**

> setAccelerationLimit()

**Arguments**

| any | accelerationLimit |
|-----|-------------------|

**Code**

```lua
function VehicleMotor:setAccelerationLimit(accelerationLimit)
    self.accelerationLimit = accelerationLimit
end

```

### setAutoGearChangeTime

**Description**

> Sets the time that needs to pass since the last gear change until an automatic gear change is allowed

**Definition**

> setAutoGearChangeTime(float autoGearChangeTime)

**Arguments**

| float | autoGearChangeTime | automatic gear change time [ms] |
|-------|--------------------|---------------------------------|

**Code**

```lua
function VehicleMotor:setAutoGearChangeTime(autoGearChangeTime)
    self.autoGearChangeTime = autoGearChangeTime
    self.autoGearChangeTimer = math.min( self.autoGearChangeTimer, autoGearChangeTime)
end

```

### setDampingRateScale

**Description**

> Scales all damping rate values with this factor

**Definition**

> setDampingRateScale(float dampingRateScale)

**Arguments**

| float | dampingRateScale | scale of damping rate [0-1] |
|-------|------------------|-----------------------------|

**Code**

```lua
function VehicleMotor:setDampingRateScale(dampingRateScale)
    self.dampingRateFullThrottle = VehicleMotor.DEFAULT_DAMPING_RATE_FULL_THROTTLE * dampingRateScale
    self.dampingRateZeroThrottleClutchEngaged = VehicleMotor.DEFAULT_DAMPING_RATE_ZERO_THROTTLE_CLUTCH_EN * dampingRateScale
    self.dampingRateZeroThrottleClutchDisengaged = VehicleMotor.DEFAULT_DAMPING_RATE_ZERO_THROTTLE_CLUTCH_DIS * dampingRateScale
end

```

### setDirectionChange

**Description**

> Set power shift stages

**Definition**

> setDirectionChange(table gearGroups, , , , )

**Arguments**

| table | gearGroups                | gearGroups |
|-------|---------------------------|------------|
| any   | directionChangeGearIndex  |            |
| any   | directionChangeUseGroup   |            |
| any   | directionChangeGroupIndex |            |
| any   | directionChangeTime       |            |

**Code**

```lua
function VehicleMotor:setDirectionChange(directionChangeUseGear, directionChangeGearIndex, directionChangeUseGroup, directionChangeGroupIndex, directionChangeTime)
    self.directionChangeUseGear = directionChangeUseGear
    self.directionChangeGearIndex = directionChangeGearIndex
    self.directionChangeUseGroup = directionChangeUseGroup
    self.directionChangeGroupIndex = directionChangeGroupIndex
    self.directionChangeTime = directionChangeTime
    self.directionChangeUseInverse = not directionChangeUseGear and not directionChangeUseGroup
end

```

### setDirectionChangeMode

**Description**

**Definition**

> setDirectionChangeMode()

**Arguments**

| any | directionChangeMode |
|-----|---------------------|

**Code**

```lua
function VehicleMotor:setDirectionChangeMode(directionChangeMode)
    self.directionChangeMode = directionChangeMode
end

```

### setEqualizedMotorRpm

**Description**

> Sets equalized motor rpm

**Definition**

> setEqualizedMotorRpm(float equalizedMotorRpm)

**Arguments**

| float | equalizedMotorRpm | equalized motor rpm |
|-------|-------------------|---------------------|

**Code**

```lua
function VehicleMotor:setEqualizedMotorRpm(rpm)
    self.equalizedMotorRpm = rpm
    self:setLastRpm(rpm)
end

```

### setExternalTorqueVirtualMultiplicator

**Description**

> Sets the virtual external torque multiplicator

**Definition**

> setExternalTorqueVirtualMultiplicator()

**Arguments**

| any | externalTorqueVirtualMultiplicator |
|-----|------------------------------------|

**Return Values**

| any | externalTorqueVirtualMultiplicator | virtual external torque multiplicator |
|-----|------------------------------------|---------------------------------------|

**Code**

```lua
function VehicleMotor:setExternalTorqueVirtualMultiplicator(externalTorqueVirtualMultiplicator)
    self.externalTorqueVirtualMultiplicator = externalTorqueVirtualMultiplicator or 1
end

```

### setGear

**Description**

**Definition**

> setGear()

**Arguments**

| any | gearIndex |
|-----|-----------|
| any | isLocked  |

**Code**

```lua
function VehicleMotor:setGear(gearIndex, isLocked)
    if gearIndex ~ = self.targetGear then
        if self.gearChangeTime = = 0 and self.targetGear > gearIndex then
            self.loadPercentageChangeCharge = 1
        end

        if self.gearShiftMode ~ = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
            self.targetGear = gearIndex
            self.previousGear = self.gear
            self.gear = 0
            self.minGearRatio = 0
            self.maxGearRatio = 0
            self.autoGearChangeTimer = self.autoGearChangeTime
            self.gearChangeTimer = self.gearChangeTime
        else
                self.targetGear = gearIndex
                self.previousGear = self.gear
                self.gear = gearIndex
            end

            self.lastGearChangeTime = g_ time

            local directionMultiplier = self.directionChangeUseGear and self.currentDirection or 1
            SpecializationUtil.raiseEvent( self.vehicle, "onGearChanged" , self.gear * directionMultiplier, self.targetGear * directionMultiplier, self.gearChangeTime, self.previousGear)
        end
    end

```

### setGearChangeTime

**Description**

> Sets the time it takes change gears

**Definition**

> setGearChangeTime(float gearChangeTime)

**Arguments**

| float | gearChangeTime | gear change time [ms] |
|-------|----------------|-----------------------|

**Code**

```lua
function VehicleMotor:setGearChangeTime(gearChangeTime)
    self.gearChangeTime = gearChangeTime
    self.gearChangeTimeOrig = gearChangeTime
    self.gearChangeTimer = math.min( self.gearChangeTimer, gearChangeTime)

    self.gearType = gearChangeTime = = 0 and VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT or VehicleMotor.TRANSMISSION_TYPE.DEFAULT
end

```

### setGearGroup

**Description**

**Definition**

> setGearGroup()

**Arguments**

| any | groupIndex |
|-----|------------|
| any | isLocked   |

**Code**

```lua
function VehicleMotor:setGearGroup(groupIndex, isLocked)
    local lastActiveGearGroupIndex = self.activeGearGroupIndex
    self.activeGearGroupIndex = groupIndex
    self.gearGroupChangedIsLocked = isLocked

    if self.activeGearGroupIndex ~ = lastActiveGearGroupIndex then
        if self.groupType = = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT and self.activeGearGroupIndex > lastActiveGearGroupIndex then
            self.loadPercentageChangeCharge = 1
        end

        if self.directionChangeUseGroup then
            if self.activeGearGroupIndex > 0 then
                local group = self.gearGroups[ self.activeGearGroupIndex]
                self.currentDirection = math.sign(group.ratio)
            else
                    self.currentDirection = 1
                end
            end

            if self.gearShiftMode ~ = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
                if self.groupType = = VehicleMotor.TRANSMISSION_TYPE.DEFAULT then
                    self.groupChangeTimer = self.groupChangeTime
                    self.gear = 0
                    self.minGearRatio = 0
                    self.maxGearRatio = 0
                elseif self.groupType = = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT then
                        self:applyTargetGear()
                    end
                end

                SpecializationUtil.raiseEvent( self.vehicle, "onGearGroupChanged" , self.activeGearGroupIndex, self.groupType = = VehicleMotor.TRANSMISSION_TYPE.DEFAULT and self.groupChangeTime or 0 )
            end
        end

```

### setGearGroups

**Description**

> Set power shift stages

**Definition**

> setGearGroups(table gearGroups, , )

**Arguments**

| table | gearGroups      | gearGroups |
|-------|-----------------|------------|
| any   | groupType       |            |
| any   | groupChangeTime |            |

**Code**

```lua
function VehicleMotor:setGearGroups(gearGroups, groupType, groupChangeTime)
    self.gearGroups = gearGroups
    self.groupType = VehicleMotor.TRANSMISSION_TYPE[ string.upper(groupType)] or VehicleMotor.TRANSMISSION_TYPE.DEFAULT
    self.groupChangeTime = groupChangeTime

    if gearGroups ~ = nil then
        self.numGearGroups = #gearGroups
        self.defaultGearGroup = 1

        -- use first forward gear group
        for i = 1 , self.numGearGroups do
            if self.gearGroups[i].ratio > 0 then
                self.defaultGearGroup = i
                break
            end
        end

        -- use group with default attribute set
        for i = 1 , self.numGearGroups do
            if self.gearGroups[i].isDefault then
                self.defaultGearGroup = i
                break
            end
        end

        self.activeGearGroupIndex = self.defaultGearGroup
    end
end

```

### setGearShiftMode

**Description**

**Definition**

> setGearShiftMode()

**Arguments**

| any | gearShiftMode |
|-----|---------------|

**Code**

```lua
function VehicleMotor:setGearShiftMode(gearShiftMode)
    self.gearShiftMode = gearShiftMode

    -- use default manual gear shift mode as we don't have a manual clutch on this transmission
    if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
        if self.gearType = = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT then
            self.gearShiftMode = VehicleMotor.SHIFT_MODE_MANUAL
        end
    end
end

```

### setLastRpm

**Description**

> Sets last motor rpm

**Definition**

> setLastRpm(float lastRpm)

**Arguments**

| float | lastRpm | new last motor rpm |
|-------|---------|--------------------|

**Code**

```lua
function VehicleMotor:setLastRpm(lastRpm)
    local oldMotorRpm = self.lastMotorRpm

    self.lastRealMotorRpm = lastRpm

    local interpolationSpeed = 0.05

    -- fast rpm drop for power shift transmissions to have a clear audible drop
        if self.gearType = = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT and(g_ time - self.lastGearChangeTime) < 200 then
            interpolationSpeed = 0.2
        end

        self.lastMotorRpm = self.lastMotorRpm * ( 1 - interpolationSpeed) + self.lastRealMotorRpm * interpolationSpeed

        -- calculate turbo speed scale depending on rpm and motor load
        local rpmPercentage = ( self.lastMotorRpm - math.max( self.lastPtoRpm or self.minRpm, self.minRpm)) / ( self.maxRpm - self.minRpm)
        local targetTurboRpm = rpmPercentage * self:getSmoothLoadPercentage()
        self.lastTurboScale = self.lastTurboScale * 0.95 + targetTurboRpm * 0.05

        local blowOffValveState = self.blowOffValveState
        if self.lastAcceleratorPedal = = 0 or( self.minGearRatio = = 0 and self.autoGearChangeTime > 0 ) then
            self.blowOffValveState = self.lastTurboScale
        else
                self.blowOffValveState = 0
            end

            if ( self.blowOffValveState > 0 ) ~ = (blowOffValveState > 0 ) then
                SpecializationUtil.raiseEvent( self.vehicle, "onMotorBlowOffValveChanged" , self.blowOffValveState)
            end

            self.constantRpmCharge = 1 - math.min( math.abs( self.lastMotorRpm - oldMotorRpm) * 0.15 , 1 )
        end

```

### setLowBrakeForce

**Description**

> Set low brake force

**Definition**

> setLowBrakeForce(float lowBrakeForceScale, float lowBrakeForceSpeedLimit)

**Arguments**

| float | lowBrakeForceScale      | low brake force scale       |
|-------|-------------------------|-----------------------------|
| float | lowBrakeForceSpeedLimit | low brake force speed limit |

**Code**

```lua
function VehicleMotor:setLowBrakeForce(lowBrakeForceScale, lowBrakeForceSpeedLimit)
    self.lowBrakeForceScale = lowBrakeForceScale
    self.lowBrakeForceSpeedLimit = lowBrakeForceSpeedLimit
end

```

### setManualShift

**Description**

> Sets the manual shift settings

**Definition**

> setManualShift(boolean gears, boolean groups)

**Arguments**

| boolean | gears  | gears can be shifted manually  |
|---------|--------|--------------------------------|
| boolean | groups | groups can be shifted manually |

**Code**

```lua
function VehicleMotor:setManualShift(manualShiftGears, manualShiftGroups)
    self.manualShiftGears = manualShiftGears
    self.manualShiftGroups = manualShiftGroups
end

```

### setMotorRotationAccelerationLimit

**Description**

**Definition**

> setMotorRotationAccelerationLimit()

**Arguments**

| any | limit |
|-----|-------|

**Code**

```lua
function VehicleMotor:setMotorRotationAccelerationLimit(limit)
    self.motorRotationAccelerationLimit = limit
end

```

### setRotInertia

**Description**

> Sets rotation inertia

**Definition**

> setRotInertia(float rotInertia)

**Arguments**

| float | rotInertia | rotation inertia |
|-------|------------|------------------|

**Code**

```lua
function VehicleMotor:setRotInertia(rotInertia)
    self.rotInertia = rotInertia
end

```

### setRpmLimit

**Description**

> Sets rpm limit

**Definition**

> setRpmLimit(float limit)

**Arguments**

| float | limit | new limit |
|-------|-------|-----------|

**Code**

```lua
function VehicleMotor:setRpmLimit(rpmLimit)
    self.rpmLimit = rpmLimit
end

```

### setSpeedLimit

**Description**

> Sets speed limit

**Definition**

> setSpeedLimit(float limit)

**Arguments**

| float | limit | new limit |
|-------|-------|-----------|

**Code**

```lua
function VehicleMotor:setSpeedLimit(limit)
    self.speedLimit = math.max(limit, self.minSpeed)
end

```

### setStartGearThreshold

**Description**

> Sets custom start gear threshold

**Definition**

> setStartGearThreshold(float lowBrakeForceScale, float lowBrakeForceSpeedLimit)

**Arguments**

| float | lowBrakeForceScale      | low brake force scale       |
|-------|-------------------------|-----------------------------|
| float | lowBrakeForceSpeedLimit | low brake force speed limit |

**Code**

```lua
function VehicleMotor:setStartGearThreshold(startGearThreshold)
    self.startGearThreshold = startGearThreshold
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
function VehicleMotor:setTransmissionDirection(direction)
    if direction > 0 then
        self.maxForwardSpeed = self.maxForwardSpeedOrigin
        self.maxBackwardSpeed = self.maxBackwardSpeedOrigin
        self.minForwardGearRatio = self.minForwardGearRatioOrigin
        self.maxForwardGearRatio = self.maxForwardGearRatioOrigin
        self.minBackwardGearRatio = self.minBackwardGearRatioOrigin
        self.maxBackwardGearRatio = self.maxBackwardGearRatioOrigin
    else
            self.maxForwardSpeed = self.maxBackwardSpeedOrigin
            self.maxBackwardSpeed = self.maxForwardSpeedOrigin
            self.minForwardGearRatio = self.minBackwardGearRatioOrigin
            self.maxForwardGearRatio = self.maxBackwardGearRatioOrigin
            self.minBackwardGearRatio = self.minForwardGearRatioOrigin
            self.maxBackwardGearRatio = self.maxForwardGearRatioOrigin
        end

        self.transmissionDirection = direction
    end

```

### shiftGear

**Description**

**Definition**

> shiftGear()

**Arguments**

| any | up |
|-----|----|

**Code**

```lua
function VehicleMotor:shiftGear(up)
    if not self.gearChangedIsLocked then
        if self:getIsGearChangeAllowed() then
            local newGear
            if up then
                newGear = self.targetGear + 1 * self.currentDirection
            else
                    newGear = self.targetGear - 1 * self.currentDirection
                end

                if self.currentDirection > 0 or self.backwardGears = = nil then
                    if newGear > # self.forwardGears then
                        newGear = # self.forwardGears
                    end
                elseif self.currentDirection < 0 or self.backwardGears ~ = nil then
                        if newGear > # self.backwardGears then
                            newGear = # self.backwardGears
                        end
                    end

                    if newGear ~ = self.targetGear then
                        if self.currentDirection > 0 then
                            if newGear < 0 then
                                self:changeDirection( - 1 )
                                newGear = 1
                            end
                        else
                                if newGear < 0 then
                                    self:changeDirection( 1 )
                                    newGear = 1
                                end
                            end

                            self:setGear(newGear)
                            self.lastManualShifterActive = false
                        end
                    else
                            SpecializationUtil.raiseEvent( self.vehicle, "onClutchCreaking" , true , false )
                        end
                    end
                end

```

### shiftGroup

**Description**

**Definition**

> shiftGroup()

**Arguments**

| any | up |
|-----|----|

**Code**

```lua
function VehicleMotor:shiftGroup(up)
    if not self.gearGroupChangedIsLocked then
        if self:getIsGearGroupChangeAllowed() then
            if self.gearGroups ~ = nil then
                local newGearGroupIndex
                if up then
                    newGearGroupIndex = self.activeGearGroupIndex + 1
                else
                        newGearGroupIndex = self.activeGearGroupIndex - 1
                    end

                    self:setGearGroup( math.clamp(newGearGroupIndex, 1 , self.numGearGroups))
                end
            else
                    SpecializationUtil.raiseEvent( self.vehicle, "onClutchCreaking" , true , true )
                end
            end
        end

```

### update

**Description**

> Update the state of the motor (sync with physics simulation)

**Definition**

> update(float dt)

**Arguments**

| float | dt | time since last call in ms |
|-------|----|----------------------------|

**Code**

```lua
function VehicleMotor:update(dt)
    local vehicle = self.vehicle
    if next(vehicle.spec_motorized.differentials) ~ = nil and vehicle.spec_motorized.motorizedNode ~ = nil then
        local lastMotorRotSpeed = self.motorRotSpeed
        local lastDiffRotSpeed = self.differentialRotSpeed
        self.motorRotSpeed, self.differentialRotSpeed, self.gearRatio = getMotorRotationSpeed(vehicle.spec_motorized.motorizedNode)

        if self.gearShiftMode ~ = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
            -- dynamically adjust the max gear ratio while starting in a gear and have not reached the min.differential speed
                -- this simulates clutch slipping and allows a smooth acceleration
                if ( self.backwardGears or self.forwardGears) and self.gearRatio ~ = 0 and self.maxGearRatio ~ = 0 then
                    if self.lastAcceleratorPedal ~ = 0 then
                        local minDifferentialSpeed = self.minRpm / math.abs( self.maxGearRatio) * math.pi / 30
                        if math.abs( self.differentialRotSpeed) < minDifferentialSpeed * 0.75 then
                            self.clutchSlippingTimer = self.clutchSlippingTime
                            self.clutchSlippingGearRatio = self.gearRatio
                        else
                                self.clutchSlippingTimer = math.max( self.clutchSlippingTimer - dt, 0 )
                            end
                        end
                    end
                end

                if not self:getUseAutomaticGearShifting() then
                    local accelerationPedal = self.lastAcceleratorPedal * self.currentDirection

                    -- calculate additional rpm if clutch is engaged and user is pressing the accelerator pedal
                        local clutchValue = 0
                        if ( self.minGearRatio = = 0 and self.maxGearRatio = = 0 ) or self.manualClutchValue > 0.1 then
                            clutchValue = 1
                        end
                        local direction = clutchValue * accelerationPedal
                        if direction = = 0 then
                            direction = - 1
                        end

                        local accelerationSpeed = direction > 0 and( self.motorRotationAccelerationLimit * 0.02 ) or self.dampingRateZeroThrottleClutchEngaged * 30 * math.pi
                        local minRotSpeed = self.minRpm * math.pi / 30
                        local maxRotSpeed = self.maxRpm * math.pi / 30
                        self.motorRotSpeedClutchEngaged = math.min( math.max( self.motorRotSpeedClutchEngaged + direction * accelerationSpeed * dt, minRotSpeed), minRotSpeed + (maxRotSpeed - minRotSpeed) * accelerationPedal)
                        self.motorRotSpeed = math.max( self.motorRotSpeed, self.motorRotSpeedClutchEngaged)
                    end

                    if g_physicsDtNonInterpolated > 0.0 and not getIsSleeping(vehicle.rootNode) then
                        self.lastMotorAvailableTorque, self.lastMotorAppliedTorque, self.lastMotorExternalTorque = getMotorTorque(vehicle.spec_motorized.motorizedNode)
                    end

                    self.motorAvailableTorque, self.motorAppliedTorque, self.motorExternalTorque = self.lastMotorAvailableTorque, self.lastMotorAppliedTorque, self.lastMotorExternalTorque

                    -- apply virtual pto torque factor
                    self.motorAppliedTorque = self.motorAppliedTorque - self.motorExternalTorque
                    self.motorExternalTorque = math.min( self.motorExternalTorque * self.externalTorqueVirtualMultiplicator, self.motorAvailableTorque - self.motorAppliedTorque)
                    self.motorAppliedTorque = self.motorAppliedTorque + self.motorExternalTorque

                    local motorRotAcceleration, differentialRotAcceleration = 0 , 0
                    if g_physicsDtNonInterpolated > 0 then
                        motorRotAcceleration = ( self.motorRotSpeed - lastMotorRotSpeed) / (g_physicsDtNonInterpolated * 0.001 )
                        differentialRotAcceleration = ( self.differentialRotSpeed - lastDiffRotSpeed) / (g_physicsDtNonInterpolated * 0.001 )
                    end

                    self.motorRotAcceleration = motorRotAcceleration
                    self.motorRotAccelerationSmoothed = 0.8 * self.motorRotAccelerationSmoothed + 0.2 * motorRotAcceleration

                    self.differentialRotAcceleration = differentialRotAcceleration
                    self.differentialRotAccelerationSmoothed = 0.8 * self.differentialRotAccelerationSmoothed + 0.2 * differentialRotAcceleration

                    self.requiredMotorPower = math.huge
                else
                        local _, gearRatio = self:getMinMaxGearRatio()
                        self.differentialRotSpeed = WheelsUtil.computeDifferentialRotSpeedNonMotor(vehicle)
                        self.motorRotSpeed = math.max( math.abs( self.differentialRotSpeed * gearRatio), 0 )
                        self.gearRatio = gearRatio
                    end

                    -- the clamped motor rpm always is higher-equal than the required rpm by the pto
                    --local ptoRpm = math.min(PowerConsumer.getMaxPtoRpm(self.vehicle)*self.ptoMotorRpmRatio, self.maxRpm)
                    -- smoothing for raise/fall of ptoRpm
                        if self.lastPtoRpm = = nil then
                            self.lastPtoRpm = self.minRpm
                        end
                        local ptoRpm = PowerConsumer.getMaxPtoRpm( self.vehicle) * self.ptoMotorRpmRatio
                        if ptoRpm > self.lastPtoRpm then
                            self.lastPtoRpm = math.min(ptoRpm, self.lastPtoRpm + self.maxRpm * dt / 2000 )
                        elseif ptoRpm < self.lastPtoRpm then
                                self.lastPtoRpm = math.max( self.minRpm, self.lastPtoRpm - self.maxRpm * dt / 1000 )
                            end

                            -- client will recieve this value from the server
                            if self.vehicle.isServer then
                                local clampedMotorRpm = math.max( self.motorRotSpeed * 30 / math.pi, math.min( self.lastPtoRpm, self.maxRpm), self.minRpm)
                                self:setLastRpm(clampedMotorRpm)

                                self.equalizedMotorRpm = clampedMotorRpm

                                local rawLoadPercentage = self:getMotorAppliedTorque() / math.max( self:getMotorAvailableTorque(), 0.0001 )
                                self.rawLoadPercentageBuffer = self.rawLoadPercentageBuffer + rawLoadPercentage
                                self.rawLoadPercentageBufferIndex = self.rawLoadPercentageBufferIndex + 1
                                if self.rawLoadPercentageBufferIndex > = 2 then
                                    self.rawLoadPercentage = self.rawLoadPercentageBuffer / 2
                                    self.rawLoadPercentageBuffer = 0
                                    self.rawLoadPercentageBufferIndex = 0
                                end

                                if self.rawLoadPercentage < 0.01 and self.lastAcceleratorPedal < 0.2
                                    and not(( self.backwardGears or self.forwardGears) and self.gear = = 0 and self.targetGear ~ = 0 ) then
                                    -- while rolling but not currently changing gears
                                        self.rawLoadPercentage = - 1
                                    else
                                            -- normal driving load is at 0 while motor is at idle load to keep it running and at 1 while it's at max load
                                                local idleLoadPct = 0.05 -- TODO change to real idle percentage
                                                self.rawLoadPercentage = ( self.rawLoadPercentage - idleLoadPct) / ( 1 - idleLoadPct)
                                            end

                                            local accelerationPercentage = math.min(( self.vehicle.lastSpeedAcceleration * 1000 * 1000 * self.vehicle.movingDirection) / self.accelerationLimit, 1 )
                                            if accelerationPercentage < 0.95 and self.lastAcceleratorPedal > 0.2 then
                                                self.accelerationLimitLoadScale = 1
                                                self.accelerationLimitLoadScaleTimer = self.accelerationLimitLoadScaleDelay
                                            else
                                                    if self.accelerationLimitLoadScaleTimer > 0 then
                                                        self.accelerationLimitLoadScaleTimer = self.accelerationLimitLoadScaleTimer - dt

                                                        local alpha = math.max( self.accelerationLimitLoadScaleTimer / self.accelerationLimitLoadScaleDelay, 0 )
                                                        self.accelerationLimitLoadScale = math.sin(( 1 - alpha) * 3.14 ) * 0.85
                                                    end
                                                end

                                                if accelerationPercentage > 0 then
                                                    self.rawLoadPercentage = math.max( self.rawLoadPercentage, accelerationPercentage * self.accelerationLimitLoadScale)
                                                end

                                                -- while we are not accelerating the constantAccelerationCharge is at 1, so the max.raw load from the engine is used.If we are accelerating we use only 80% of the load
                                                    self.constantAccelerationCharge = 1 - math.min(( math.abs( self.vehicle.lastSpeedAcceleration) * 1000 * 1000 ) / self.accelerationLimit, 1 )
                                                    if self.rawLoadPercentage > 0 then
                                                        self.rawLoadPercentage = self.rawLoadPercentage * MAX_ACCELERATION_LOAD + self.rawLoadPercentage * ( 1 - MAX_ACCELERATION_LOAD) * self.constantAccelerationCharge
                                                    end

                                                    if self.backwardGears or self.forwardGears then
                                                        if self:getUseAutomaticGearShifting() then
                                                            -- if we are in automatic mode and we are stuck in one gear for a while we try to reduce the shifting time
                                                                -- like this are are not loosing too much speed while shifting and more gears are an option
                                                                    -- especially helpfull if we picked the wrong gear in field work
                                                                        if self.constantRpmCharge > 0.99 then
                                                                            if self.maxRpm - clampedMotorRpm < 50 then
                                                                                self.gearChangeTimeAutoReductionTimer = math.min( self.gearChangeTimeAutoReductionTimer + dt, self.gearChangeTimeAutoReductionTime)
                                                                                self.gearChangeTime = self.gearChangeTimeOrig * ( 1 - self.gearChangeTimeAutoReductionTimer / self.gearChangeTimeAutoReductionTime)
                                                                            else
                                                                                    self.gearChangeTimeAutoReductionTimer = 0
                                                                                    self.gearChangeTime = self.gearChangeTimeOrig
                                                                                end
                                                                            else
                                                                                    self.gearChangeTimeAutoReductionTimer = 0
                                                                                    self.gearChangeTime = self.gearChangeTimeOrig
                                                                                end
                                                                            end
                                                                        end
                                                                    end

                                                                    self:updateSmoothLoadPercentage(dt, self.rawLoadPercentage)

                                                                    self.idleGearChangeTimer = math.max( self.idleGearChangeTimer - dt, 0 )

                                                                    if self.forwardGears or self.backwardGears then
                                                                        self:updateStartGearValues(dt)

                                                                        local clutchPedal = self:getClutchPedal()
                                                                        self.lastSmoothedClutchPedal = self.lastSmoothedClutchPedal * 0.9 + clutchPedal * 0.1
                                                                    end

                                                                    self.lastModulationTimer = self.lastModulationTimer + dt * MODULATION_SPEED
                                                                    self.lastModulationPercentage = math.sin( self.lastModulationTimer) * math.sin(( self.lastModulationTimer + 2 ) * 0.3 ) * 0.8 + math.cos( self.lastModulationTimer * 5 ) * 0.2
                                                                end

```

### updateGear

**Description**

> Update gear

**Definition**

> updateGear(float acceleratorPedal, , )

**Arguments**

| float | acceleratorPedal | acceleratorPedal |
|-------|------------------|------------------|
| any   | brakePedal       |                  |
| any   | dt               |                  |

**Return Values**

| any | adjustedAcceleratorPedal | the adjusted accelerator pedal for the current gear situation (e.g. 0 while switching gears) |
|-----|--------------------------|----------------------------------------------------------------------------------------------|

**Code**

```lua
function VehicleMotor:updateGear(acceleratorPedal, brakePedal, dt)
    self.lastAcceleratorPedal = acceleratorPedal
    local adjAcceleratorPedal = acceleratorPedal
    if self.gearChangeTimer > = 0 then
        self.gearChangeTimer = self.gearChangeTimer - dt
        if self.gearChangeTimer < 0 then
            if self.targetGear ~ = 0 then
                self.allowGearChangeTimer = 3000
                self.allowGearChangeDirection = math.sign( self.targetGear - self.previousGear)

                self:applyTargetGear()
            end
        end
        adjAcceleratorPedal = 0
    elseif self.groupChangeTimer > 0 or self.directionChangeTimer > 0 then
            self.groupChangeTimer = self.groupChangeTimer - dt
            self.directionChangeTimer = self.directionChangeTimer - dt
            if self.groupChangeTimer < 0 and self.directionChangeTimer < 0 then
                self:applyTargetGear()
            end
        else
                local gearSign = 0
                if acceleratorPedal > 0 then
                    if self.minForwardGearRatio ~ = nil then
                        self.minGearRatio = self.minForwardGearRatio
                        self.maxGearRatio = self.maxForwardGearRatio
                    else
                            gearSign = 1
                        end
                    elseif acceleratorPedal < 0 then
                            if self.minBackwardGearRatio ~ = nil then
                                self.minGearRatio = - self.minBackwardGearRatio
                                self.maxGearRatio = - self.maxBackwardGearRatio
                            else
                                    gearSign = - 1
                                end
                            else
                                    if self.maxGearRatio > 0 then
                                        if self.minForwardGearRatio = = nil then
                                            gearSign = 1
                                        end
                                    elseif self.maxGearRatio < 0 then
                                            if self.minBackwardGearRatio = = nil then
                                                gearSign = - 1
                                            end
                                        end
                                    end

                                    local newGear = self.gear
                                    local forceGearChange = false

                                    -- skip gear change timer when we apply the new gear already after the directionChangeTime
                                    local skipGearChangeTimer = false
                                    if self.backwardGears or self.forwardGears then
                                        if self:getUseAutomaticGearShifting() then
                                            self.autoGearChangeTimer = self.autoGearChangeTimer - dt

                                            -- the users action to accelerate will always allow shfting
                                            -- this is just to avoid shifting while vehicle is not moving, but shfting conditions change(attaching tool, lowering/lifting tool etc.)
                                                if self.vehicle:getIsAutomaticShiftingAllowed() or acceleratorPedal ~ = 0 then
                                                    -- slower than 1,08km/h
                                                    if math.abs( self.vehicle.lastSpeed) < 0.0003 then
                                                        local directionChanged = false
                                                        local trySelectBestGear = false
                                                        local allowGearOverwritting = false
                                                        if gearSign < 0 and( self.currentDirection = = 1 or self.gear = = 0 ) then
                                                            self:changeDirection( - 1 , true )
                                                            directionChanged = true
                                                            skipGearChangeTimer = self.directionChangeTime > 0
                                                        elseif gearSign > 0 and( self.currentDirection = = - 1 or self.gear = = 0 ) then
                                                                self:changeDirection( 1 , true )
                                                                directionChanged = true
                                                                skipGearChangeTimer = self.directionChangeTime > 0
                                                            elseif self.lastAcceleratorPedal = = 0 and self.idleGearChangeTimer < = 0 then
                                                                    trySelectBestGear = true
                                                                    self.doSecondBestGearSelection = 3
                                                                elseif self.doSecondBestGearSelection > 0 and self.lastAcceleratorPedal ~ = 0 then
                                                                        self.doSecondBestGearSelection = self.doSecondBestGearSelection - 1
                                                                        if self.doSecondBestGearSelection = = 0 then
                                                                            -- do another try for the best gear directly after acceleration started
                                                                                -- the selected gear may not be correct due to an active speed limit(when accelerating with cruise control)
                                                                                trySelectBestGear = true
                                                                                allowGearOverwritting = true
                                                                            end
                                                                        end

                                                                        if directionChanged then
                                                                            if self.targetGear ~ = self.gear then
                                                                                newGear = self.targetGear
                                                                            end

                                                                            trySelectBestGear = true
                                                                        end

                                                                        if trySelectBestGear then
                                                                            local bestGear, maxFactorGroup = self:getBestStartGear( self.currentGears)
                                                                            if bestGear ~ = self.gear or bestGear ~ = self.bestGearSelected then
                                                                                newGear = bestGear

                                                                                if bestGear > 1 or allowGearOverwritting then
                                                                                    self.bestGearSelected = bestGear
                                                                                    self.allowGearChangeTimer = 0
                                                                                end
                                                                            end

                                                                            if self:getUseAutomaticGroupShifting() then
                                                                                if maxFactorGroup ~ = nil and maxFactorGroup ~ = self.activeGearGroupIndex then
                                                                                    self:setGearGroup(maxFactorGroup)
                                                                                end
                                                                            end
                                                                        end
                                                                    else
                                                                            if self.gear ~ = 0 then
                                                                                if self.autoGearChangeTimer < = 0 then
                                                                                    if math.sign(acceleratorPedal) ~ = math.sign( self.currentDirection) then
                                                                                        acceleratorPedal = 0
                                                                                    end
                                                                                    newGear = self:findGearChangeTargetGearPrediction( self.gear, self.currentGears, self.currentDirection, self.autoGearChangeTimer, acceleratorPedal, dt)

                                                                                    if self:getUseAutomaticGroupShifting() then
                                                                                        if self.gearGroups ~ = nil then
                                                                                            -- if we are in the highest gear and the maximum rpm range(50rpm threshold) we shift one group up
                                                                                                if self.activeGearGroupIndex < # self.gearGroups then
                                                                                                    if math.abs( math.min( self:getLastRealMotorRpm(), self.maxRpm) - self.maxRpm) < 50 then
                                                                                                        if self.gear = = # self.currentGears then
                                                                                                            -- if in the highest gear we immediately shift up
                                                                                                                local nextRatio = self.gearGroups[ self.activeGearGroupIndex + 1 ].ratio
                                                                                                                if math.sign( self.gearGroups[ self.activeGearGroupIndex].ratio) = = math.sign(nextRatio) then
                                                                                                                    self:shiftGroup( true )

                                                                                                                    -- search for the best gear in the new group and force the selection of this gear after the group shift
                                                                                                                        newGear = self:findGearChangeTargetGearPrediction( self.targetGear, self.currentGears, self.currentDirection, self.autoGearChangeTimer, acceleratorPedal, dt)
                                                                                                                        forceGearChange = true
                                                                                                                    end
                                                                                                                elseif self.groupType = = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT then
                                                                                                                        -- if we are stuck in a gear we wait a few seconds and then shift up
                                                                                                                            -- this only applies for power shift groups since we expect a normal group shift with clutch is also not possible like the gear shift
                                                                                                                                if math.sign( self.gearGroups[ self.activeGearGroupIndex].ratio) = = math.sign( self.gearGroups[ self.activeGearGroupIndex + 1 ].ratio) then
                                                                                                                                    self.gearGroupUpShiftTimer = self.gearGroupUpShiftTimer + dt
                                                                                                                                    if self.gearGroupUpShiftTimer > self.gearGroupUpShiftTime then
                                                                                                                                        self.gearGroupUpShiftTimer = 0
                                                                                                                                        self:shiftGroup( true )
                                                                                                                                    end
                                                                                                                                else
                                                                                                                                        self.gearGroupUpShiftTimer = 0
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            else
                                                                                                                                    self.gearGroupUpShiftTimer = 0
                                                                                                                                end
                                                                                                                            else
                                                                                                                                    self.gearGroupUpShiftTimer = 0
                                                                                                                                end

                                                                                                                                -- in case we are in the first gear and below 25% of the rpm and in the group we are we would not have any gear to start we shift a group down
                                                                                                                                if self.gear = = 1 then
                                                                                                                                    if self.lastRealMotorRpm < self.minRpm + ( self.maxRpm - self.minRpm) * 0.25 then
                                                                                                                                        local _, maxFactorGroup = self:getBestStartGear( self.currentGears)
                                                                                                                                        if maxFactorGroup < self.activeGearGroupIndex then
                                                                                                                                            if math.sign( self.gearGroups[maxFactorGroup].ratio) = = math.sign( self.gearGroups[ self.activeGearGroupIndex].ratio) then
                                                                                                                                                self:setGearGroup(maxFactorGroup)
                                                                                                                                            end
                                                                                                                                        end
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end
                                                                                                                    end
                                                                                                                    newGear = math.min( math.max(newGear, 1 ), # self.currentGears)
                                                                                                                end
                                                                                                            end

                                                                                                            -- prevent transmission from downshifting when it just upshifted.So at least try the new gear for 3sec, maybe we get the rpm higher
                                                                                                                self.allowGearChangeTimer = self.allowGearChangeTimer - dt
                                                                                                                if self.allowGearChangeTimer > 0 and acceleratorPedal * self.currentDirection > 0 then
                                                                                                                    if newGear < self.gear then
                                                                                                                        if self.allowGearChangeDirection ~ = math.sign(newGear - self.gear) then
                                                                                                                            newGear = self.gear
                                                                                                                        end
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                    if newGear ~ = self.gear or forceGearChange then
                                                                                                        if newGear ~ = self.bestGearSelected then
                                                                                                            self.bestGearSelected = - 1
                                                                                                        end

                                                                                                        self.targetGear = newGear
                                                                                                        self.previousGear = self.gear
                                                                                                        self.gear = 0
                                                                                                        self.minGearRatio = 0
                                                                                                        self.maxGearRatio = 0

                                                                                                        if not skipGearChangeTimer then
                                                                                                            self.autoGearChangeTimer = self.autoGearChangeTime
                                                                                                            self.gearChangeTimer = self.gearChangeTime
                                                                                                        end

                                                                                                        self.lastGearChangeTime = g_ time
                                                                                                        adjAcceleratorPedal = 0

                                                                                                        local directionMultiplier = self.directionChangeUseGear and self.currentDirection or 1
                                                                                                        SpecializationUtil.raiseEvent( self.vehicle, "onGearChanged" , self.gear * directionMultiplier, self.targetGear * directionMultiplier, self.gearChangeTimer, self.previousGear)

                                                                                                        if self.gearChangeTimer = = 0 then
                                                                                                            self.gearChangeTimer = - 1
                                                                                                            self.allowGearChangeTimer = 3000
                                                                                                            self.allowGearChangeDirection = math.sign( self.targetGear - self.previousGear)

                                                                                                            self:applyTargetGear()
                                                                                                        end
                                                                                                    end
                                                                                                end

                                                                                                if self.gearShiftMode = = VehicleMotor.SHIFT_MODE_MANUAL_CLUTCH then
                                                                                                    if self.backwardGears or self.forwardGears then
                                                                                                        local curRatio, tarRatio
                                                                                                        if self.currentGears[ self.gear] ~ = nil then
                                                                                                            tarRatio = self.currentGears[ self.gear].ratio * self:getGearRatioMultiplier()

                                                                                                            local differentialRotSpeed = math.max( math.abs( self.differentialRotSpeed), 0.0001 )
                                                                                                            curRatio = math.min( self.motorRotSpeed / differentialRotSpeed, 5000 )
                                                                                                        end

                                                                                                        local ratio = 0
                                                                                                        if tarRatio ~ = nil then
                                                                                                            ratio = MathUtil.lerp( math.abs(tarRatio), math.abs(curRatio), math.min( self.manualClutchValue, 0.9 ) / 0.9 * 0.5 ) * math.sign(tarRatio)
                                                                                                        end
                                                                                                        self.minGearRatio, self.maxGearRatio = ratio, ratio

                                                                                                        if self.manualClutchValue = = 0 and self.maxGearRatio ~ = 0 then
                                                                                                            local factor = 1
                                                                                                            local motorRpm = self:getNonClampedMotorRpm()
                                                                                                            if motorRpm > 0 then
                                                                                                                factor = ( self:getClutchRpm() + 50 ) / motorRpm
                                                                                                            end

                                                                                                            if factor < 0.2 then
                                                                                                                self.stallTimer = self.stallTimer + dt

                                                                                                                if self.stallTimer > 500 then
                                                                                                                    self.vehicle:stopMotor()
                                                                                                                    self.stallTimer = 0
                                                                                                                end
                                                                                                            else
                                                                                                                    self.stallTimer = 0
                                                                                                                end
                                                                                                            else
                                                                                                                    self.stallTimer = 0
                                                                                                                end
                                                                                                            end
                                                                                                        end

                                                                                                        if self:getUseAutomaticGearShifting() then
                                                                                                            if math.abs( self.vehicle.lastSpeed) > 0.0003 then
                                                                                                                if self.backwardGears or self.forwardGears then
                                                                                                                    if ( self.currentDirection > 0 and adjAcceleratorPedal < 0 ) -- driving forwards and braking
                                                                                                                        or( self.currentDirection < 0 and adjAcceleratorPedal > 0 ) then -- driving backwards and braking
                                                                                                                        adjAcceleratorPedal = 0
                                                                                                                        brakePedal = 1
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end

                                                                                                        return adjAcceleratorPedal, brakePedal
                                                                                                    end

```

### updateSmoothLoadPercentage

**Description**

> Update smoothed motor load percentage

**Definition**

> updateSmoothLoadPercentage(float dt, float rawLoadPercentage)

**Arguments**

| float | dt                | time since last update         |
|-------|-------------------|--------------------------------|
| float | rawLoadPercentage | raw load percentage from motor |

**Code**

```lua
function VehicleMotor:updateSmoothLoadPercentage(dt, rawLoadPercentage)
    local lastSmoothedLoad = self.smoothedLoadPercentage

    local maxSpeed = self:getMaximumForwardSpeed() * 3.6
    if self.vehicle.movingDirection < 0 then
        maxSpeed = self:getMaximumBackwardSpeed() * 3.6
    end

    local speedPercentage = math.max( math.min( self.vehicle:getLastSpeed() / maxSpeed, 1 ), 0 )

    -- adjustment factor is 0.65 at min speed and 0.05 at max speed(so we counteract fast acceleration changes at max speed)
    local factor = 0.05 + ( 1 - speedPercentage) * 0.3
    if rawLoadPercentage < self.smoothedLoadPercentage then
        if self.gearType ~ = VehicleMotor.TRANSMISSION_TYPE.POWERSHIFT or(g_ time - self.lastGearChangeTime) > 200 then
            factor = factor * 0.2

            -- rapid load drop while clutch is engaged
                if self:getClutchPedal() > 0.75 then
                    factor = factor * 5
                end

                -- if we are decelerating we want to have -1 load immediately
                    if rawLoadPercentage < 0 then
                        factor = factor * 2.5
                    end
                else
                        -- while power shifting we reduce the load drop to have almost no load difference, only rpm difference
                            factor = factor * 0.05
                        end
                    end
                    local invFactor = 1 - factor

                    self.smoothedLoadPercentage = invFactor * self.smoothedLoadPercentage + factor * rawLoadPercentage

                    -- load change charge that is increased while the load increases really fast and fades out afterwards
                        -- used to drop the motor rpm
                        local difference = math.max( self.smoothedLoadPercentage - lastSmoothedLoad, 0 )
                        self.loadPercentageChangeCharge = self.loadPercentageChangeCharge + difference
                        self.loadPercentageChangeCharge = math.min( math.max( self.loadPercentageChangeCharge - dt * 0.0005 , 0 ), 1 )
                    end

```

### updateStartGearValues

**Description**

> Update the gear start parameters

**Definition**

> updateStartGearValues(table gears)

**Arguments**

| table | gears | gears |
|-------|-------|-------|

**Return Values**

| table | bestGear | best gear to start |
|-------|----------|--------------------|

**Code**

```lua
function VehicleMotor:updateStartGearValues(dt)
    local totalMass = self.vehicle:getTotalMass()
    local totalMassOnGround = 0 -- total mass of vehicles with wheels, excluding self.vehicle
    local vehicleMass = self.vehicle:getTotalMass( true )

    -- if the mass changes faster than 10kg/sec
        if math.abs(totalMass - self.startGearValues.lastMass) > 0.00001 * dt then
            self.startGearValues.lastMass = totalMass
            self.idleGearChangeTimer = 500 -- block gear changing while mass is changing(e.g.while vehicle is filling)
            end

            -- get maxForce sum of all tools attached and calculate the mass of all wheeled tools
            local maxForce = 0
            local vehicles = self.vehicle:getChildVehicles()
            for _, vehicle in ipairs(vehicles) do
                if vehicle ~ = self.vehicle then
                    if vehicle.spec_powerConsumer ~ = nil then
                        if vehicle.spec_powerConsumer.maxForce ~ = nil then
                            local multiplier = vehicle:getPowerMultiplier()
                            if multiplier ~ = 0 then
                                maxForce = maxForce + vehicle.spec_powerConsumer.maxForce
                            end
                        end
                    end

                    if vehicle.spec_leveler ~ = nil then
                        maxForce = maxForce + math.abs(vehicle.spec_leveler.lastForce)
                    end

                    if vehicle.spec_wheels ~ = nil then
                        if #vehicle.spec_wheels.wheels > 0 then
                            totalMassOnGround = totalMassOnGround + vehicle:getTotalMass( true )
                        end
                    end
                end
            end

            -- get average center of mass and direction of all attachments that got wheels and
            local comX, comY, comZ = 0 , 0 , 0
            local dirX, dirY, dirZ = 0 , 0 , 0
            for _, vehicle in ipairs(vehicles) do
                if vehicle ~ = self.vehicle then
                    if vehicle.spec_wheels ~ = nil then
                        if #vehicle.spec_wheels.wheels > 0 then
                            local objectMass = vehicle:getTotalMass( true )
                            local percentage = objectMass / totalMassOnGround
                            local cx, cy, cz = vehicle:getOverallCenterOfMass()
                            comX, comY, comZ = comX + cx * percentage, comY + cy * percentage, comZ + cz * percentage

                            local iDirX, iDirY, iDirZ = vehicle:getVehicleWorldDirection()
                            dirX, dirY, dirZ = dirX + iDirX * percentage, dirY + iDirY * percentage, dirZ + iDirZ * percentage
                        end
                    end
                end
            end

            local vdx, vdy, vdz = self.vehicle:getVehicleWorldDirection()

            if VehicleDebug.state = = VehicleDebug.DEBUG_TRANSMISSION then
                local vX, vY, vZ = getWorldTranslation( self.vehicle.components[ 1 ].node)
                DebugGizmo.renderAtPosition(comX, comY, comZ, dirX, dirY, dirZ, 0 , 1 , 0 , "TOOLS DIR" )
                DebugGizmo.renderAtPosition(vX, vY, vZ, vdx, vdy, vdz, 0 , 1 , 0 , "VEHICLE DIR" )
            end

            -- increase the calculated mass depending in which angle the tools are to the motorized vehicle
            -- X&Z difference normal influence and the Y difference has a higher(factor 6.6) influence
            local diffXZ, diffY = 0 , 0
            if dirX ~ = 0 or dirY ~ = 0 or dirZ ~ = 0 then
                diffXZ = math.max( math.abs(dirX - vdx), math.abs(dirZ - vdz))

                -- only use positive direction offset if trailer is "below" the tractor
                    diffY = math.max(dirY - vdy, 0 )
                end

                -- full direction mass incluence is only used while additional weight is 5 tons
                    -- so for really light tools it has more or less no impact since the tractor can also easily pull them out of there position
                        local massDirectionInfluenceFactor = math.min((totalMass - vehicleMass) / 5 , 1 )

                        self.startGearValues.massDirectionDifferenceXZ = diffXZ
                        self.startGearValues.massDirectionDifferenceY = diffY
                        self.startGearValues.massDirectionFactor = ( 1 + diffXZ * massDirectionInfluenceFactor) * ( 1 + (diffY / 0.15 ) * massDirectionInfluenceFactor)

                        -- we use directly the PowerConsumer functions since the external torque is 0 while the clutch is engaged
                            local neededPtoTorque = PowerConsumer.getTotalConsumedPtoTorque( self.vehicle, nil , nil , true ) / self:getPtoMotorRpmRatio()
                            local ptoPower = self.peakMotorPowerRotSpeed * neededPtoTorque
                            self.startGearValues.availablePower = self.peakMotorPower - ptoPower

                            -- if we have a tool force active we increase it while the pto consumes power
                                local maxForcePowerFactor = 1 + (ptoPower / self.peakMotorPower) * 0.75

                                -- max force is influencing the mass to tow by factor 2 in tons
                                local mass = (totalMass + (maxForce * maxForcePowerFactor)) / vehicleMass
                                mass = ((mass - 1 ) * 0.5 + 1 ) * vehicleMass

                                self.startGearValues.maxForce = maxForce
                                self.startGearValues.mass = mass
                                self.startGearValues.slope = self.vehicle:getVehicleWorldXRot()

                                self.startGearValues.massFactor = ( self.startGearValues.mass * self.startGearValues.massDirectionFactor) / ((( self.startGearValues.availablePower / 100 - 1 ) * 50 + 100 ) * 0.4 )
                            end

```

### writeGearDataToStream

**Description**

> Writes current gear data to stream

**Definition**

> writeGearDataToStream()

**Arguments**

| any | streamId |
|-----|----------|

**Code**

```lua
function VehicleMotor:writeGearDataToStream(streamId)
    streamWriteUIntN(streamId, math.sign( self.currentDirection) + 1 , 2 )

    if streamWriteBool(streamId, self.backwardGears ~ = nil or self.forwardGears ~ = nil ) then
        streamWriteUIntN(streamId, self.targetGear, 6 )
        streamWriteBool(streamId, self.targetGear ~ = self.gear)
        streamWriteBool(streamId, self.currentGears = = self.forwardGears)

        if self.gearGroups ~ = nil then
            streamWriteUIntN(streamId, self.activeGearGroupIndex, 5 )
        end
    end
end

```