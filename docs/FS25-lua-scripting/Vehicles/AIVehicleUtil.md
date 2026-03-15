## AIVehicleUtil

**Description**

> Util class for various ai vehicle functions

**Functions**

- [driveAlongCurvature](#drivealongcurvature)
- [driveInDirection](#driveindirection)
- [driveToPoint](#drivetopoint)
- [getAIAreaOfVehicle](#getaiareaofvehicle)
- [getAIDensityHeightArea](#getaidensityheightarea)
- [getAIFruitArea](#getaifruitarea)
- [getAIToolReverserDirectionNode](#getaitoolreverserdirectionnode)
- [getAreaDimensions](#getareadimensions)
- [getAttachedImplementsAllowTurnBackward](#getattachedimplementsallowturnbackward)
- [getAttachedImplementsBlockTurnBackward](#getattachedimplementsblockturnbackward)
- [getAttachedImplementsMaxTurnRadius](#getattachedimplementsmaxturnradius)
- [getAverageDriveDirection](#getaveragedrivedirection)
- [getDriveDirection](#getdrivedirection)
- [getIsAreaOwned](#getisareaowned)
- [getMaxToolRadius](#getmaxtoolradius)
- [getValidityOfTurnDirections](#getvalidityofturndirections)
- [updateInvertLeftRightMarkers](#updateinvertleftrightmarkers)

### driveAlongCurvature

**Description**

**Definition**

> driveAlongCurvature()

**Arguments**

| any | self         |
|-----|--------------|
| any | dt           |
| any | curvature    |
| any | maxSpeed     |
| any | acceleration |

**Code**

```lua
function AIVehicleUtil.driveAlongCurvature( self , dt, curvature, maxSpeed, acceleration)
    local targetRotTime = self:getSteeringRotTimeByCurvature(curvature) * self:getSteeringDirection()
    maxSpeed = maxSpeed or math.huge

    -- if targetRotTime > self.rotatedTime then
        -- self.rotatedTime = math.min(self.rotatedTime + dt*self:getAISteeringSpeed(), targetRotTime)
        -- else
            -- self.rotatedTime = math.max(self.rotatedTime - dt*self:getAISteeringSpeed(), targetRotTime)
            -- end

            self.rotatedTime = - targetRotTime

            if self.finishedFirstUpdate then
                local acc = acceleration
                if maxSpeed > 0 then
                    if self:getCruiseControlState() ~ = Drivable.CRUISECONTROL_STATE_ACTIVE then
                        self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_ACTIVE)
                    end
                else
                        acc = 0
                    end

                    self:getMotor():setSpeedLimit(maxSpeed)

                    WheelsUtil.updateWheelsPhysics( self , dt, self.lastSpeedReal * self.movingDirection, acc, maxSpeed > 0 , true )
                end
            end

```

### driveInDirection

**Description**

> Drive in given direction

**Definition**

> driveInDirection(table self, float dt, float steeringAngleLimit, float acceleration, float slowAcceleration, float
> slowAngleLimit, boolean allowedToDrive, boolean moveForwards, float lx, float lz, float maxSpeed, float
> slowDownFactor)

**Arguments**

| table   | self               | object of vehicle          |
|---------|--------------------|----------------------------|
| float   | dt                 | time since last call in ms |
| float   | steeringAngleLimit | limit for steering angle   |
| float   | acceleration       | acceleration               |
| float   | slowAcceleration   | slow acceleration          |
| float   | slowAngleLimit     | limit of slow angle        |
| boolean | allowedToDrive     | allow to drive             |
| boolean | moveForwards       | move forwards              |
| float   | lx                 | x direction                |
| float   | lz                 | z direction                |
| float   | maxSpeed           | max speed                  |
| float   | slowDownFactor     | slow down factor           |

**Code**

```lua
function AIVehicleUtil.driveInDirection( self , dt, steeringAngleLimit, acceleration, slowAcceleration, slowAngleLimit, allowedToDrive, moveForwards, lx, lz, maxSpeed, slowDownFactor)

    local angle = 0
    if lx ~ = nil and lz ~ = nil then
        local dot = lz
        angle = math.deg( math.acos(dot))
        if angle < 0 then
            angle = angle + 180
        end

        local turnLeft = lx > 0.00001
        if not moveForwards then
            turnLeft = not turnLeft
        end

        local targetRotTime
        if turnLeft then
            --rotate to the left
            targetRotTime = self.maxRotTime * math.min(angle / steeringAngleLimit, 1 )
        else
                --rotate to the right
                targetRotTime = self.minRotTime * math.min(angle / steeringAngleLimit, 1 )
            end

            if targetRotTime > self.rotatedTime then
                self.rotatedTime = math.min( self.rotatedTime + dt * self:getAISteeringSpeed(), targetRotTime)
            else
                    self.rotatedTime = math.max( self.rotatedTime - dt * self:getAISteeringSpeed(), targetRotTime)
                end
            end

            if self.finishedFirstUpdate then
                local acc = acceleration
                if maxSpeed ~ = nil and maxSpeed ~ = 0 then
                    if math.abs(angle) > = slowAngleLimit then
                        maxSpeed = maxSpeed * slowDownFactor
                    end
                    self.motor:setSpeedLimit(maxSpeed)

                    if self.cruiseControl.state ~ = Drivable.CRUISECONTROL_STATE_ACTIVE then
                        self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_ACTIVE)
                    end
                else
                        if math.abs(angle) > = slowAngleLimit then
                            acc = slowAcceleration
                        end
                    end
                    if not allowedToDrive then
                        acc = 0
                    end
                    if not moveForwards then
                        acc = - acc
                    end
                    WheelsUtil.updateWheelsPhysics( self , dt, self.lastSpeedReal * self.movingDirection, acc, not allowedToDrive, true )
                end
            end

```

### driveToPoint

**Description**

> Drive vehicle to given point

**Definition**

> driveToPoint(table self, float dt, float acceleration, boolean allowedToDrive, boolean moveForwards, float tX, float
> tZ, float maxSpeed, boolean? doNotSteer)

**Arguments**

| table    | self           | object of vehicle to move    |
|----------|----------------|------------------------------|
| float    | dt             | time since last call in ms   |
| float    | acceleration   | acceleration                 |
| boolean  | allowedToDrive | allowed to drive             |
| boolean  | moveForwards   | move forwards                |
| float    | tX             | local space x position       |
| float    | tZ             | local space y position       |
| float    | maxSpeed       | speed limit                  |
| boolean? | doNotSteer     | do not steer, default: false |

**Code**

```lua
function AIVehicleUtil.driveToPoint( self , dt, acceleration, allowedToDrive, moveForwards, tX, tZ, maxSpeed, doNotSteer)
    if self.finishedFirstUpdate then

        if allowedToDrive then

            local tX_ 2 = tX * 0.5
            local tZ_ 2 = tZ * 0.5

            local d1X, d1Z = tZ_ 2 , - tX_ 2
            if tX > 0 then
                d1X, d1Z = - tZ_ 2 , tX_ 2
            end

            local hit,_,f2 = MathUtil.getLineLineIntersection2D(tX_ 2 ,tZ_ 2 , d1X,d1Z, 0 , 0 , tX, 0 )

            if doNotSteer = = nil or not doNotSteer then
                local rotTime = 0
                if hit and math.abs(f2) < 100000 then
                    local radius = tX * f2
                    rotTime = self:getSteeringRotTimeByCurvature( 1 / radius)

                    if self:getReverserDirection() < 0 then
                        rotTime = - rotTime
                    end

                    --rotTime = self.wheelSteeringDuration * ( math.atan(1/radius) / math.atan(1/self.maxTurningRadius) )
                end

                local targetRotTime
                if rotTime > = 0 then
                    targetRotTime = math.min(rotTime, self.maxRotTime)
                else
                        targetRotTime = math.max(rotTime, self.minRotTime)
                    end

                    if targetRotTime > self.rotatedTime then
                        self.rotatedTime = math.min( self.rotatedTime + dt * self:getAISteeringSpeed(), targetRotTime)
                    else
                            self.rotatedTime = math.max( self.rotatedTime - dt * self:getAISteeringSpeed(), targetRotTime)
                        end

                        -- adjust maxSpeed
                        local steerDiff = targetRotTime - self.rotatedTime
                        local fac = math.abs(steerDiff) / math.max( self.maxRotTime, - self.minRotTime)
                        local speedReduction = 1.0 - math.pow(fac, 0.25 )

                        -- if the speed is decreased to less than 1 km/h we do not accelrate anymore
                            if maxSpeed * speedReduction < 1 then
                                acceleration = 0
                                speedReduction = 1 / maxSpeed
                            end

                            maxSpeed = maxSpeed * speedReduction
                        end
                    end

                    self:getMotor():setSpeedLimit( math.min(maxSpeed, self:getCruiseControlSpeed()))
                    if self:getCruiseControlState() ~ = Drivable.CRUISECONTROL_STATE_ACTIVE then
                        self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_ACTIVE)
                    end

                    if not allowedToDrive then
                        acceleration = 0
                    end
                    if not moveForwards then
                        acceleration = - acceleration
                    end

                    WheelsUtil.updateWheelsPhysics( self , dt, self.lastSpeedReal * self.movingDirection, acceleration, not allowedToDrive, true )

                end
            end

```

### getAIAreaOfVehicle

**Description**

> Returns amount of fruit to work for ai vehicle is in given area

**Definition**

> getAIAreaOfVehicle(table vehicle, float startWorldX, float startWorldZ, float widthWorldX, float widthWorldZ, float
> heightWorldX, float heightWorldZ)

**Arguments**

| table | vehicle      | vehicle        |
|-------|--------------|----------------|
| float | startWorldX  | start world x  |
| float | startWorldZ  | start world z  |
| float | widthWorldX  | width world x  |
| float | widthWorldZ  | width world z  |
| float | heightWorldX | height world x |
| float | heightWorldZ | height world z |

**Return Values**

| float | area      | area found         |
|-------|-----------|--------------------|
| float | totalArea | total area checked |

**Code**

```lua
function AIVehicleUtil.getAIAreaOfVehicle(vehicle, startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
    local useDensityHeightMap = #vehicle:getAIDensityHeightTypeRequirements() > 0

    if not useDensityHeightMap then
        local query, isValid = vehicle:getFieldCropsQuery()
        if isValid then
            return AIVehicleUtil.getAIFruitArea(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ, query)
        else
                return 0 , 0
            end
        else
                local densityHeightTypeRequirements = vehicle:getAIDensityHeightTypeRequirements()
                return AIVehicleUtil.getAIDensityHeightArea(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ, densityHeightTypeRequirements)
            end
        end

```

### getAIDensityHeightArea

**Description**

> Returns amount of density height to work is in given area

**Definition**

> getAIDensityHeightArea(float startWorldX, float startWorldZ, float widthWorldX, float widthWorldZ, float heightWorldX,
> float heightWorldZ, table fruitRequirements, boolean densityHeightTypeRequirements)

**Arguments**

| float   | startWorldX                   | start world x                            |
|---------|-------------------------------|------------------------------------------|
| float   | startWorldZ                   | start world z                            |
| float   | widthWorldX                   | width world x                            |
| float   | widthWorldZ                   | width world z                            |
| float   | heightWorldX                  | height world x                           |
| float   | heightWorldZ                  | height world z                           |
| table   | fruitRequirements             | table with all required fruit types      |
| boolean | densityHeightTypeRequirements | use density height types as requirements |

**Return Values**

| boolean | area      | area found         |
|---------|-----------|--------------------|
| boolean | totalArea | total area checked |

**Code**

```lua
function AIVehicleUtil.getAIDensityHeightArea(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ, densityHeightTypeRequirements)
    -- first check if we are on a field
        local _, detailArea, _ = FSDensityMapUtil.getFieldDensity(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
        if detailArea = = 0 then
            return 0 , 0
        end

        local retArea, retTotalArea = 0 , 0
        for _, densityHeightTypeRequirement in pairs(densityHeightTypeRequirements) do
            if densityHeightTypeRequirement.fillType ~ = FillType.UNKNOWN then
                local _, area, totalArea = DensityMapHeightUtil.getFillLevelAtArea(densityHeightTypeRequirement.fillType, startWorldX,startWorldZ, widthWorldX,widthWorldZ, heightWorldX,heightWorldZ)
                retArea, retTotalArea = retArea + area, totalArea
            end
        end

        return retArea, retTotalArea
    end

```

### getAIFruitArea

**Description**

> Returns amount of fruit to work is in given area

**Definition**

> getAIFruitArea(float startWorldX, float startWorldZ, float widthWorldX, float widthWorldZ, float heightWorldX, float
> heightWorldZ, table query)

**Arguments**

| float | startWorldX  | start world x                |
|-------|--------------|------------------------------|
| float | startWorldZ  | start world z                |
| float | widthWorldX  | width world x                |
| float | widthWorldZ  | width world z                |
| float | heightWorldX | height world x               |
| float | heightWorldZ | height world z               |
| table | query        | field crops query of vehicle |

**Return Values**

| table | area      | area found         |
|-------|-----------|--------------------|
| table | totalArea | total area checked |

**Code**

```lua
function AIVehicleUtil.getAIFruitArea(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ, query)
    local x,z, widthX,widthZ, heightX,heightZ = MathUtil.getXZWidthAndHeight(startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
    return query:getParallelogram(x,z, widthX,widthZ, heightX,heightZ, false )
end

```

### getAIToolReverserDirectionNode

**Description**

> Returns reverser direction node of attached ai tool

**Definition**

> getAIToolReverserDirectionNode(table vehicle)

**Arguments**

| table | vehicle | vehicle to check |
|-------|---------|------------------|

**Return Values**

| table | aiToolReverserDirectionNode | reverser direction node of ai tool |
|-------|-----------------------------|------------------------------------|

**Code**

```lua
function AIVehicleUtil.getAIToolReverserDirectionNode(vehicle)
    for _, implement in pairs(vehicle:getAttachedImplements()) do
        if implement.object ~ = nil and implement.object.getAIToolReverserDirectionNode ~ = nil then
            local reverserNode = implement.object:getAIToolReverserDirectionNode()

            local attachedReverserNode = AIVehicleUtil.getAIToolReverserDirectionNode(implement.object)
            reverserNode = reverserNode or attachedReverserNode

            if reverserNode ~ = nil then
                return reverserNode
            end
        end
    end

    return nil
end

```

### getAreaDimensions

**Description**

**Definition**

> getAreaDimensions()

**Arguments**

| any | directionX    |
|-----|---------------|
| any | directionZ    |
| any | leftNode      |
| any | rightNode     |
| any | xOffset       |
| any | zOffset       |
| any | areaSize      |
| any | invertXOffset |

**Code**

```lua
function AIVehicleUtil.getAreaDimensions(directionX, directionZ, leftNode, rightNode, xOffset, zOffset, areaSize, invertXOffset)
    local xOffsetLeft, xOffsetRight = xOffset, xOffset
    if invertXOffset = = nil or invertXOffset then
        xOffsetLeft = - xOffsetLeft
    end
    local lX, _, lZ = localToWorld(leftNode, xOffsetLeft, 0 , zOffset)
    local rX, _, rZ = localToWorld(rightNode, xOffsetRight, 0 , zOffset)

    local sX = lX - ( 0.5 * directionX)
    local sZ = lZ - ( 0.5 * directionZ)
    local wX = rX - ( 0.5 * directionX)
    local wZ = rZ - ( 0.5 * directionZ)
    local hX = lX + (areaSize * directionX)
    local hZ = lZ + (areaSize * directionZ)

    return sX, sZ, wX, wZ, hX, hZ
end

```

### getAttachedImplementsAllowTurnBackward

**Description**

> Returns if trailer or trailer low is attached

**Definition**

> getAttachedImplementsAllowTurnBackward(table vehicle)

**Arguments**

| table | vehicle | vehicle to check |
|-------|---------|------------------|

**Return Values**

| table | isAttached | is attached |
|-------|------------|-------------|

**Code**

```lua
function AIVehicleUtil.getAttachedImplementsAllowTurnBackward(vehicle)
    if vehicle.getAIAllowTurnBackward ~ = nil then
        if not vehicle:getAIAllowTurnBackward() then
            return false
        end
    end

    if vehicle.getAttachedImplements ~ = nil then
        for _, implement in pairs(vehicle:getAttachedImplements()) do
            local object = implement.object
            if object ~ = nil then
                if object.getAIAllowTurnBackward ~ = nil then
                    if not object:getAIAllowTurnBackward() then
                        return false
                    end
                end

                if not AIVehicleUtil.getAttachedImplementsAllowTurnBackward(object) then
                    return false
                end
            end
        end
    end

    return true
end

```

### getAttachedImplementsBlockTurnBackward

**Description**

> Returns if one of the attached implements blocks reverse driving

**Definition**

> getAttachedImplementsBlockTurnBackward(table vehicle)

**Arguments**

| table | vehicle | vehicle to check |
|-------|---------|------------------|

**Return Values**

| table | doesBlock | implement does block |
|-------|-----------|----------------------|

**Code**

```lua
function AIVehicleUtil.getAttachedImplementsBlockTurnBackward(vehicle)
    if vehicle.getAIBlockTurnBackward ~ = nil then
        if vehicle:getAIBlockTurnBackward() then
            return true
        end
    end

    if vehicle.getAttachedImplements ~ = nil then
        for _, implement in pairs(vehicle:getAttachedImplements()) do
            local object = implement.object
            if object ~ = nil then
                if object.getAIBlockTurnBackward ~ = nil then
                    if object:getAIBlockTurnBackward() then
                        return true
                    end
                end

                if AIVehicleUtil.getAttachedImplementsBlockTurnBackward(object) then
                    return true
                end
            end
        end
    end

    return false
end

```

### getAttachedImplementsMaxTurnRadius

**Description**

**Definition**

> getAttachedImplementsMaxTurnRadius()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AIVehicleUtil.getAttachedImplementsMaxTurnRadius(vehicle)
    local maxRadius = - 1
    if vehicle.getAttachedImplements ~ = nil then
        for _, implement in pairs(vehicle:getAttachedImplements()) do
            local object = implement.object
            if object ~ = nil then
                if object.getAITurnRadiusLimitation ~ = nil then
                    local radius = object:getAITurnRadiusLimitation()
                    if radius ~ = nil and radius > maxRadius then
                        maxRadius = radius
                    end
                end

                local radius = AIVehicleUtil.getAttachedImplementsMaxTurnRadius(object)
                if radius > maxRadius then
                    maxRadius = radius
                end
            end
        end
    end

    return maxRadius
end

```

### getAverageDriveDirection

**Description**

> Returns average drive direction between 2 given vectors

**Definition**

> getAverageDriveDirection(integer refNode, float x, float y, float z, float x2, float y2, float z2)

**Arguments**

| integer | refNode | id of ref node |
|---------|---------|----------------|
| float   | x       | world x 1      |
| float   | y       | world y 1      |
| float   | z       | world z 1      |
| float   | x2      | world x 2      |
| float   | y2      | world y 2      |
| float   | z2      | world z 2      |

**Return Values**

| float | lx | average x direction |
|-------|----|---------------------|
| float | lz | average z direction |

**Code**

```lua
function AIVehicleUtil.getAverageDriveDirection(refNode, x, y, z, x2, y2, z2)
    local lx, _, lz = worldToLocal(refNode, (x + x2) * 0.5 , (y + y2) * 0.5 , (z + z2) * 0.5 )

    local length = MathUtil.vector2Length(lx, lz)
    if length > 0.00001 then
        lx = lx / length
        lz = lz / length
    end
    return lx, lz, length
end

```

### getDriveDirection

**Description**

> Returns drive direction

**Definition**

> getDriveDirection(integer refNode, float x, float y, float z)

**Arguments**

| integer | refNode | id of ref node |
|---------|---------|----------------|
| float   | x       | world x        |
| float   | y       | world y        |
| float   | z       | world z        |

**Return Values**

| float | lx | x direction |
|-------|----|-------------|
| float | lz | z direction |

**Code**

```lua
function AIVehicleUtil.getDriveDirection(refNode, x, y, z)
    local lx, _, lz = worldToLocal(refNode, x, y, z)

    local length = MathUtil.vector2Length(lx, lz)
    if length > 0.00001 then
        length = 1 / length
        lx = lx * length
        lz = lz * length
    end
    return lx, lz
end

```

### getIsAreaOwned

**Description**

**Definition**

> getIsAreaOwned()

**Arguments**

| any | vehicle |
|-----|---------|
| any | sX      |
| any | sZ      |
| any | wX      |
| any | wZ      |
| any | hX      |
| any | hZ      |

**Code**

```lua
function AIVehicleUtil.getIsAreaOwned(vehicle, sX, sZ, wX, wZ, hX, hZ)
    local farmId = vehicle:getAIJobFarmId()
    local centerX, centerZ = (sX + wX) * 0.5 , (sZ + wZ) * 0.5
    if g_farmlandManager:getIsOwnedByFarmAtWorldPosition(farmId, centerX, centerZ) then
        return true
    end

    if g_missionManager:getIsMissionWorkAllowed(farmId, centerX, centerZ, nil , vehicle) then
        return true
    end

    return false
end

```

### getMaxToolRadius

**Description**

> Returns max tool turn radius

**Definition**

> getMaxToolRadius(table implement)

**Arguments**

| table | implement | implement to check |
|-------|-----------|--------------------|

**Return Values**

| table | maxTurnRadius | max turn radius |
|-------|---------------|-----------------|

**Code**

```lua
function AIVehicleUtil.getMaxToolRadius(implement)
    local radius = 0

    local _, rotationNode, wheels, rotLimitFactor = implement.object:getAITurnRadiusLimitation()

    -- collect the max manual defined turn radius of all vehicles, not only valid ai implements
    local rootVehicle = implement.object.rootVehicle
    local retRadius = AIVehicleUtil.getAttachedImplementsMaxTurnRadius(rootVehicle)

    if retRadius ~ = - 1 then
        radius = retRadius
    end

    if rotationNode then
        local activeInputAttacherJoint = implement.object:getActiveInputAttacherJoint()
        local refNode = rotationNode

        -- If the refNode is any attacher joint, we always use the currently used attacher joint
        for _, inputAttacherJoint in pairs(implement.object:getInputAttacherJoints()) do
            if refNode = = inputAttacherJoint.node then
                refNode = activeInputAttacherJoint.node
                break
            end
        end

        local rx,_,rz = localToLocal(refNode, implement.object.components[ 1 ].node, 0 , 0 , 0 )

        for _, wheel in pairs(wheels) do
            local nx,_,nz = localToLocal(wheel.repr, implement.object.components[ 1 ].node, 0 , 0 , 0 )

            local x,z = nx - rx, nz - rz
            local cx,cz = 0 , 0

            -- get max rotation
            local rotMax
            if refNode = = activeInputAttacherJoint.node then
                local attacherVehicle = implement.object:getAttacherVehicle()
                local jointDesc = attacherVehicle:getAttacherJointDescFromObject(implement.object)
                rotMax = math.max(jointDesc.upperRotLimit[ 2 ], jointDesc.lowerRotLimit[ 2 ]) * activeInputAttacherJoint.lowerRotLimitScale[ 2 ]
            else
                    for _,compJoint in pairs(implement.object.componentJoints) do
                        if refNode = = compJoint.jointNode then
                            -- assume that the axis with max.limit is our Y axis
                            -- depending on the joint setup this can be the Y or Z axis
                            for i = 1 , 3 do
                                rotMax = math.max(rotMax or 0 , compJoint.rotLimit[i])
                            end

                            break
                        end
                    end
                end

                if rotMax ~ = nil then
                    rotMax = rotMax * rotLimitFactor

                    -- calc turning radius
                    local x1 = x * math.cos(rotMax) - z * math.sin(rotMax)
                    local z1 = x * math.sin(rotMax) + z * math.cos(rotMax)

                    local dx = - z1
                    local dz = x1
                    if wheel.steering.steeringAxleScale ~ = 0 and wheel.steering.steeringAxleRotMax ~ = 0 then
                        local tmpx, tmpz = dx, dz
                        dx = tmpx * math.cos(wheel.steering.steeringAxleRotMax) - tmpz * math.sin(wheel.steering.steeringAxleRotMax)
                        dz = tmpx * math.sin(wheel.steering.steeringAxleRotMax) + tmpz * math.cos(wheel.steering.steeringAxleRotMax)
                    end

                    local hit,f1,_ = MathUtil.getLineLineIntersection2D(cx,cz, 1 , 0 , x1,z1, dx,dz)
                    if hit then
                        radius = math.max(radius, math.abs(f1))
                    end
                else
                        Logging.warning( "AI rotation node '%s' could not be found as component joint or attacher joint on '%s'" , getName(refNode), implement.object.configFileName)
                    end
                end
            end

            return radius
        end

```

### getValidityOfTurnDirections

**Description**

> Checks fruits on left and right side of vehicle to decide the turn direction

**Definition**

> getValidityOfTurnDirections(table vehicle, float checkFrontDistance, table turnData)

**Arguments**

| table | vehicle            | vehicle to check                      |
|-------|--------------------|---------------------------------------|
| float | checkFrontDistance | distance to check in front of vehicle |
| table | turnData           | properties for turning                |

**Return Values**

| table | leftAreaPercentage  | left area percentage  |
|-------|---------------------|-----------------------|
| table | rightAreaPercentage | right area percentage |

**Code**

```lua
function AIVehicleUtil.getValidityOfTurnDirections(vehicle, turnData)
    -- let's check the area at/around the marker which is farest behind of vehicle
    local directionNode = vehicle:getAIDirectionNode()
    local attachedAIImplements = vehicle:getAttachedAIImplements()
    local checkFrontDistance = 5

    local leftAreaPercentage = 0
    local rightAreaPercentage = 0

    local minZ = math.huge
    local maxZ = - math.huge
    for _,implement in pairs(attachedAIImplements) do
        local leftMarker, rightMarker, backMarker = implement.object:getAIMarkers()

        local _,_,zl = localToLocal(leftMarker, directionNode, 0 , 0 , 0 )
        local _,_,zr = localToLocal(rightMarker, directionNode, 0 , 0 , 0 )
        local _,_,zb = localToLocal(backMarker, directionNode, 0 , 0 , 0 )

        minZ = math.min(minZ, zl, zr, zb)
        maxZ = math.max(maxZ, zl, zr, zb)
    end

    local sideDistance
    if turnData = = nil then
        local minAreaWidth = math.huge
        for _,implement in pairs(attachedAIImplements) do
            local leftMarker, rightMarker, _ = implement.object:getAIMarkers()

            local lx, _, _ = localToLocal(leftMarker, directionNode, 0 , 0 , 0 )
            local rx, _, _ = localToLocal(rightMarker, directionNode, 0 , 0 , 0 )
            minAreaWidth = math.min(minAreaWidth, math.abs(lx - rx))
        end
        sideDistance = minAreaWidth
    else
            sideDistance = math.abs(turnData.sideOffsetRight - turnData.sideOffsetLeft)
        end

        local dx, dz = vehicle.aiDriveDirection[ 1 ], vehicle.aiDriveDirection[ 2 ]
        local sx, sz = - dz, dx

        for _,implement in pairs(attachedAIImplements) do
            local leftMarker, rightMarker, _ = implement.object:getAIMarkers()

            local lx, ly, lz = localToLocal(leftMarker, directionNode, 0 , 0 , 0 )
            local rx, ry, rz = localToLocal(rightMarker, directionNode, 0 , 0 , 0 )

            local width = math.abs(lx - rx)
            local length = checkFrontDistance + (maxZ - minZ) + math.max(sideDistance * 1.3 + 2 , checkFrontDistance) -- 1.3~tan(53) allows detecting back along a field side with angle 53(and 2m extra compensates for some variances, or higher angles with small tools)

                lx, _, lz = localToWorld(directionNode, lx,ly,maxZ + checkFrontDistance)
                rx, _, rz = localToWorld(directionNode, rx,ry,maxZ + checkFrontDistance)

                local lSX = lx
                local lSZ = lz
                local lWX = lSX - sx * width
                local lWZ = lSZ - sz * width
                local lHX = lSX - dx * length
                local lHZ = lSZ - dz * length

                local rSX = rx
                local rSZ = rz
                local rWX = rSX + sx * width
                local rWZ = rSZ + sz * width
                local rHX = rSX - dx * length
                local rHZ = rSZ - dz * length

                local lArea, lTotal = AIVehicleUtil.getAIAreaOfVehicle(implement.object, lSX,lSZ, lWX,lWZ, lHX,lHZ)
                local rArea, rTotal = AIVehicleUtil.getAIAreaOfVehicle(implement.object, rSX,rSZ, rWX,rWZ, rHX,rHZ)

                if lTotal > 0 then
                    leftAreaPercentage = leftAreaPercentage + (lArea / lTotal)
                end
                if rTotal > 0 then
                    rightAreaPercentage = rightAreaPercentage + (rArea / rTotal)
                end

                -- just visual debuging
                if VehicleDebug.state = = VehicleDebug.DEBUG_AI then
                    local lSY = getTerrainHeightAtWorldPos(g_terrainNode, lSX, 0 ,lSZ) + 2
                    local lWY = getTerrainHeightAtWorldPos(g_terrainNode, lWX, 0 ,lWZ) + 2
                    local lHY = getTerrainHeightAtWorldPos(g_terrainNode, lHX, 0 ,lHZ) + 2
                    local rSY = getTerrainHeightAtWorldPos(g_terrainNode, rSX, 0 ,rSZ) + 2
                    local rWY = getTerrainHeightAtWorldPos(g_terrainNode, rWX, 0 ,rWZ) + 2
                    local rHY = getTerrainHeightAtWorldPos(g_terrainNode, rHX, 0 ,rHZ) + 2

                    vehicle:addAIDebugLine( { lSX,lSY,lSZ } , { lWX,lWY,lWZ } , { 0.5 , 0.5 , 0.5 } )
                    vehicle:addAIDebugLine( { lSX,lSY,lSZ } , { lHX,lHY,lHZ } , { 0.5 , 0.5 , 0.5 } )
                    vehicle:addAIDebugLine( { rSX,rSY,rSZ } , { rWX,rWY,rWZ } , { 0.5 , 0.5 , 0.5 } )
                    vehicle:addAIDebugLine( { rSX,rSY,rSZ } , { rHX,rHY,rHZ } , { 0.5 , 0.5 , 0.5 } )
                end
            end

            leftAreaPercentage = leftAreaPercentage / #attachedAIImplements
            rightAreaPercentage = rightAreaPercentage / #attachedAIImplements

            return leftAreaPercentage, rightAreaPercentage
        end

```

### updateInvertLeftRightMarkers

**Description**

> Update invertation of ai left and right markers on vehicle

**Definition**

> updateInvertLeftRightMarkers(table rootAttacherVehicle, table vehicle)

**Arguments**

| table | rootAttacherVehicle | root attacher vehicle |
|-------|---------------------|-----------------------|
| table | vehicle             | vehicle               |

**Code**

```lua
function AIVehicleUtil.updateInvertLeftRightMarkers(rootAttacherVehicle, vehicle)
    if vehicle.getAIMarkers ~ = nil then
        local leftMarker, rightMarker, _ = vehicle:getAIMarkers()
        if leftMarker ~ = nil and rightMarker ~ = nil then
            local lX, _, _ = localToLocal(leftMarker, rootAttacherVehicle:getAIDirectionNode(), 0 , 0 , 0 )
            local rX, _, _ = localToLocal(rightMarker, rootAttacherVehicle:getAIDirectionNode(), 0 , 0 , 0 )

            if rX > lX then
                vehicle:setAIMarkersInverted()
            end
        end
    end
end

```