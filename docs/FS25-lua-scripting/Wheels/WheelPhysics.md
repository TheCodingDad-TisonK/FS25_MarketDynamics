## WheelPhysics

**Description**

> Stores physics data and functions to update the physic wheel

**Functions**

- [addToPhysics](#addtophysics)
- [clientUpdate](#clientupdate)
- [finalize](#finalize)
- [getGroundAttributes](#getgroundattributes)
- [getIsOnField](#getisonfield)
- [getSurfaceSoundAttributes](#getsurfacesoundattributes)
- [getTireLoad](#gettireload)
- [getVisualInfo](#getvisualinfo)
- [loadAdditionalWheel](#loadadditionalwheel)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [postLoad](#postload)
- [postUpdate](#postupdate)
- [readStream](#readstream)
- [registerAdditionalWheelXMLPaths](#registeradditionalwheelxmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [removeFromPhysics](#removefromphysics)
- [serverUpdate](#serverupdate)
- [setDisplacementAllowed](#setdisplacementallowed)
- [setDisplacementCollisionEnabled](#setdisplacementcollisionenabled)
- [setSteeringValues](#setsteeringvalues)
- [setSuspensionMultipliers](#setsuspensionmultipliers)
- [setTorqueDirection](#settorquedirection)
- [setWheelShapeWidth](#setwheelshapewidth)
- [updateBase](#updatebase)
- [updateContact](#updatecontact)
- [updateContactClient](#updatecontactclient)
- [updateFriction](#updatefriction)
- [updateInterpolation](#updateinterpolation)
- [updateNetInfo](#updatenetinfo)
- [updatePhysics](#updatephysics)
- [updateShapePosition](#updateshapeposition)
- [updateSink](#updatesink)
- [updateSteeringAngle](#updatesteeringangle)
- [updateTick](#updatetick)
- [updateTireFriction](#updatetirefriction)
- [updateXDriveSpeed](#updatexdrivespeed)
- [waterRaycastCallback](#waterraycastcallback)
- [writeStream](#writestream)

### addToPhysics

**Description**

**Definition**

> addToPhysics()

**Arguments**

| any | brakeForce |
|-----|------------|

**Code**

```lua
function WheelPhysics:addToPhysics(brakeForce)
    self.netInfo.xDriveLastRaw = 0
    self.updateWheel = false

    self:updateBase()
    self:updateTireFriction()

    self:updatePhysics(brakeForce, 0 )
end

```

### clientUpdate

**Description**

**Definition**

> clientUpdate()

**Arguments**

| any | dt                 |
|-----|--------------------|
| any | currentUpdateIndex |
| any | groundWetness      |

**Code**

```lua
function WheelPhysics:clientUpdate(dt, currentUpdateIndex, groundWetness)
    if self.vehicle.isActive then
        if currentUpdateIndex = = self.wheel.updateIndex then
            self:updateContactClient()
        end
    end
end

```

### finalize

**Description**

**Definition**

> finalize()

**Code**

```lua
function WheelPhysics:finalize()
    local positionY = self.positionY + self.deltaY
    self.netInfo = { }
    self.netInfo.xDrive = 0
    self.netInfo.xDriveDiff = 0 -- radian per ms
    self.netInfo.xDriveSpeed = 0 -- radian per second
    self.netInfo.xDriveLastRaw = 0
    self.netInfo.x = self.positionX
    self.netInfo.y = positionY
    self.netInfo.z = self.positionZ
    self.netInfo.suspensionLength = self.deltaY

    self.netInfo.lastSpeedSmoothed = 0 -- wheel speed in m/sec
    self.netInfo.slip = 0 -- wheel slip(0 = no slip, 1 = full slip)

    -- The suspension elongates by 20% of the specified susp travel
    self.netInfo.sync = { yMin = - 5 , yRange = 10 }
    self.netInfo.yMin = positionY - 1.2 * self.suspTravel

    local vehicleNode = self.vehicle.vehicleNodes[ self.wheel.node]
    if vehicleNode ~ = nil and vehicleNode.component ~ = nil and vehicleNode.component.motorized = = nil then
        vehicleNode.component.motorized = true
    end

    local additionalMass = self.wheel:getMass() - self.baseMass
    self.restLoad = self.restLoad + additionalMass

    self.maxLatStiffness = self.maxLatStiffness * self.restLoad
    self.maxLatStiffnessLoad = self.maxLatStiffnessLoad * self.restLoad

    self.networkInterpolators = { }
    self.networkInterpolators.xDriveDiff = InterpolatorValue.new( 0 )
    self.networkInterpolators.position = InterpolatorPosition.new( self.netInfo.x, self.netInfo.y, self.netInfo.z)
    self.networkInterpolators.suspensionLength = InterpolatorValue.new( self.netInfo.suspensionLength)
end

```

### getGroundAttributes

**Description**

**Definition**

> getGroundAttributes()

**Code**

```lua
function WheelPhysics:getGroundAttributes()
    return self.trackColor[ 1 ], self.trackColor[ 2 ], self.trackColor[ 3 ], self.groundDepth, self.lastTerrainAttribute, math.max( self.trackAlpha, self.dirtAmount), self.colorBlendWithTerrain
end

```

### getIsOnField

**Description**

**Definition**

> getIsOnField()

**Code**

```lua
function WheelPhysics:getIsOnField()
    local isOnField = self.hasSnowContact
    if self.densityType ~ = FieldGroundType.NONE and self.densityType ~ = FieldGroundType.GRASS and self.densityType ~ = FieldGroundType.GRASS_CUT then
        isOnField = true
    end

    return isOnField
end

```

### getSurfaceSoundAttributes

**Description**

**Definition**

> getSurfaceSoundAttributes()

**Code**

```lua
function WheelPhysics:getSurfaceSoundAttributes()
    if self.contact = = WheelContactType.GROUND then
        if self.hasWaterContact then
            return "shallowWater" , nil
        elseif self.densityType ~ = FieldGroundType.NONE then
                return "field" , nil
            else
                    return nil , self.lastTerrainAttribute
                end
            elseif self.contact = = WheelContactType.GROUND_HEIGHT then
                    if self.hasSnowContact then
                        return "snow" , nil
                    end
                elseif self.contact = = WheelContactType.OBJECT then
                        return "asphalt" , nil
                    end

                    return nil , nil
                end

```

### getTireLoad

**Description**

**Definition**

> getTireLoad()

**Code**

```lua
function WheelPhysics:getTireLoad()
    if self.wheelShapeCreated then
        local gravity = 9.81

        local tireLoad = getWheelShapeContactForce( self.wheel.node, self.wheelShape)
        if tireLoad ~ = nil then
            local nx, ny, nz = getWheelShapeContactNormal( self.wheel.node, self.wheelShape)
            local dx, dy, dz = localDirectionToWorld( self.wheel.node, self.directionX, self.directionY, self.directionZ)
            tireLoad = - tireLoad * MathUtil.dotProduct(dx, dy, dz, nx, ny, nz)

            return(tireLoad + math.max(ny * gravity, 0.0 ) * self.wheel:getMass()) / gravity
        end
    end

    return 0
end

```

### getVisualInfo

**Description**

**Definition**

> getVisualInfo()

**Code**

```lua
function WheelPhysics:getVisualInfo()
    local steeringAngle = 0
    if self.showSteeringAngle ~ = false then
        steeringAngle = self.steeringAngle * self.steeringAngleFactorInv
    end

    return self.netInfo.x, self.netInfo.y, self.netInfo.z, self.netInfo.xDrive, self.netInfo.suspensionLength - self.deltaYOriginal, steeringAngle
end

```

### loadAdditionalWheel

**Description**

**Definition**

> loadAdditionalWheel()

**Arguments**

| any | xmlObject |
|-----|-----------|

**Code**

```lua
function WheelPhysics:loadAdditionalWheel(xmlObject)
    self.mass = self.mass + xmlObject:getValue( ".physics#mass" , 0 )

    self.maxLatStiffness = self.maxLatStiffness + xmlObject:getValue( ".physics#maxLatStiffness" , 0 )
    self.maxLongStiffness = self.maxLongStiffness + xmlObject:getValue( ".physics#maxLongStiffness" , 0 )
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlObject |
|-----|-----------|

**Code**

```lua
function WheelPhysics:loadFromXML(xmlObject)
    self.radius = xmlObject:getValue( ".physics#radius" )
    if self.radius = = nil then
        xmlObject:xmlWarning( ".physics#radius" , "No radius defined for wheel! Using default value of 0.5!" )
            self.radius = 0.5
        end
        self.radiusOriginal = self.radius

        self.width = xmlObject:getValue( ".physics#width" )
        if self.width = = nil then
            xmlObject:xmlWarning( ".physics#width" , "No width defined for wheel! Using default value of 0.5!" )
                self.width = 0.5
            end

            self.wheelShapeWidth = self.width
            self.wheelShapeWidthOffset = 0

            self.mass = xmlObject:getValue( ".physics#mass" , 0.1 )
            self.baseMass = self.mass

            self.restLoad = xmlObject:getValue( ".physics#restLoad" , 1 ) -- [t]
            self.frictionScale = xmlObject:getValue( ".physics#frictionScale" , 1 )
            if self.frictionScale < = 0 then
                self.frictionScale = 0.01
                xmlObject:xmlWarning( ".physics#frictionScale" , "Wheel 'frictionScale' set to '0'.This is not allowed!" )
            end

            self.maxLongStiffness = xmlObject:getValue( ".physics#maxLongStiffness" , 30 ) -- [t / rad]
            self.maxLatStiffness = xmlObject:getValue( ".physics#maxLatStiffness" , 40 ) -- xml is ratio to restLoad [1/rad], final value is [t / rad]
            self.maxLatStiffnessLoad = xmlObject:getValue( ".physics#maxLatStiffnessLoad" , 2 ) -- xml is ratio to restLoad, final value is [t]

            self.xOffset = xmlObject:getValue( ".physics#xOffset" , 0.0 )
            self.yOffset = xmlObject:getValue( ".physics#yOffset" , 0.0 )
            self.zOffset = xmlObject:getValue( ".physics#zOffset" , 0.0 )
            self.useReprOffset = xmlObject:getValue( ".physics#useReprOffset" , false )
            if self.xOffset ~ = 0 or self.yOffset ~ = 0 or self.zOffset ~ = 0 then
                -- move drivenode in y direction.Use convert yOffset from driveNode local space to driveNodeParent local space to translate according to directions
                if self.useReprOffset then
                    setTranslation( self.wheel.repr, localToLocal( self.wheel.repr, getParent( self.wheel.repr), self.wheel.isLeft and self.xOffset or - self.xOffset, self.yOffset, self.zOffset))
                else
                        setTranslation( self.wheel.driveNode, localToLocal( self.wheel.driveNode, getParent( self.wheel.driveNode), self.wheel.isLeft and self.xOffset or - self.xOffset, self.yOffset, self.zOffset))
                    end
                end

                self.showSteeringAngle = xmlObject:getValue( ".physics#showSteeringAngle" )
                self.steeringAngleFactor = xmlObject:getValue( ".physics#steeringAngleFactor" , self.steeringAngleFactor or 1 )
                self.steeringAngleFactorInv = 1 / self.steeringAngleFactor
                self.suspTravel = xmlObject:getValue( ".physics#suspTravel" , 0.01 )
                local initialCompression = xmlObject:getValue( ".physics#initialCompression" )
                if initialCompression ~ = nil then
                    self.deltaY = ( 1 - initialCompression * 0.01 ) * self.suspTravel
                else
                        self.deltaY = xmlObject:getValue( ".physics#deltaY" , 0.0 )
                    end
                    self.deltaYOriginal = self.deltaY
                    self.spring = xmlObject:getValue( ".physics#spring" , 0 ) * Vehicle.SPRING_SCALE

                    self.brakeFactor = xmlObject:getValue( ".physics#brakeFactor" , 1 )
                    self.autoHoldBrakeFactor = xmlObject:getValue( ".physics#autoHoldBrakeFactor" , self.brakeFactor)

                    self.dampingMultiplier = 1
                    self.springMultiplier = 1

                    self.damperCompressionLowSpeed = xmlObject:getValue( ".physics#damperCompressionLowSpeed" )
                    self.damperRelaxationLowSpeed = xmlObject:getValue( ".physics#damperRelaxationLowSpeed" )
                    if self.damperRelaxationLowSpeed = = nil then
                        self.damperRelaxationLowSpeed = xmlObject:getValue( ".physics#damper" , self.damperCompressionLowSpeed or 0 )
                    end
                    -- by default, the high speed relaxation damper is set to 90% of the low speed relaxation damper
                    self.damperRelaxationHighSpeed = xmlObject:getValue( ".physics#damperRelaxationHighSpeed" , self.damperRelaxationLowSpeed * 0.7 )

                    -- by default, we set the low speed compression damper to 90% of the low speed relaxation damper
                    if self.damperCompressionLowSpeed = = nil then
                        self.damperCompressionLowSpeed = self.damperRelaxationLowSpeed * 0.9
                    end
                    -- by default, the high speed compression damper is set to 20% of the low speed compression damper
                    self.damperCompressionHighSpeed = xmlObject:getValue( ".physics#damperCompressionHighSpeed" , self.damperCompressionLowSpeed * 0.2 )
                    self.damperCompressionLowSpeedThreshold = xmlObject:getValue( ".physics#damperCompressionLowSpeedThreshold" , 0.1016 ) -- default 4 inch / s
                    self.damperRelaxationLowSpeedThreshold = xmlObject:getValue( ".physics#damperRelaxationLowSpeedThreshold" , 0.1524 ) -- default 6 inch / s

                    self.forcePointRatio = xmlObject:getValue( ".physics#forcePointRatio" , 0 )
                    if self.forcePointRatio < 0 or self.forcePointRatio > 1 then
                        xmlObject:xmlWarning( ".physics#forcePointRatio" , "Invalid value for 'forcePointRatio'.Must be between 0 and 1.Defaulting to 0!" )
                            self.forcePointRatio = 0
                        end

                        self.driveMode = xmlObject:getValue( ".physics#driveMode" , 0 )

                        self.isSynchronized = xmlObject:getValue( ".physics#isSynchronized" , true )
                        self.tipOcclusionAreaGroupId = xmlObject:getValue( ".physics#tipOcclusionAreaGroupId" )

                        self.useReprDirection = xmlObject:getValue( ".physics#useReprDirection" , false )
                        self.useDriveNodeDirection = xmlObject:getValue( ".physics#useDriveNodeDirection" , false )

                        self.rotationDamping = xmlObject:getValue( ".physics#rotationDamping" , self.mass * 0.035 )

                        local tireTypeName = xmlObject:getValue( ".physics#tireType" , "mud" )
                        self.tireType = WheelsUtil.getTireType(tireTypeName)
                        if self.tireType = = nil then
                            xmlObject:xmlWarning( ".physics#tireType" , "Failed to find tire type '%s'.Defaulting to 'mud'!" , tireTypeName)
                            self.tireType = WheelsUtil.getTireType( "mud" )
                        end

                        self.fieldDirtMultiplier = xmlObject:getValue( ".physics#fieldDirtMultiplier" , 75 )
                        self.streetDirtMultiplier = xmlObject:getValue( ".physics#streetDirtMultiplier" , - 150 )
                        self.waterWetnessFactor = xmlObject:getValue( ".physics#waterWetnessFactor" , 20 )
                        self.minDirtPercentage = xmlObject:getValue( ".physics#minDirtPercentage" , 0.35 )
                        self.maxDirtOffset = xmlObject:getValue( ".physics#maxDirtOffset" , 0.5 )
                        self.dirtColorChangeSpeed = 1 / (xmlObject:getValue( ".physics#dirtColorChangeSpeed" , 20 ) * 1000 )

                        self.versatileYRot = xmlObject:getValue( ".physics#versatileYRot" , false )
                        self.forceVersatility = xmlObject:getValue( ".physics#forceVersatility" , false )
                        self.supportsWheelSink = xmlObject:getValue( ".physics#supportsWheelSink" , true ) and self.vehicle.isServer

                        -- old wheel sink attribute from fs22 define if the wheel deforms the displacement or not
                            if not Platform.gameplay.wheelTerrainDisplacement or not self.supportsWheelSink then
                                self.collisionMask = bit32.band( WheelPhysics.COLLISION_MASK, bit32.bnot(CollisionFlag.TERRAIN_DISPLACEMENT)) -- remove TERRAIN_DISPLACEMENT from mask
                            end

                            self.extraSinkSupported = xmlObject:getValue( ".physics.extraSink#supported" , false )
                            self.extraSinkMaxValue = xmlObject:getValue( ".physics.extraSink#maxValue" , self.radius * 0.2 )

                            self.rotSpeed = xmlObject:getValue( ".physics#rotSpeed" , 0 )
                            self.rotSpeedNeg = xmlObject:getValue( ".physics#rotSpeedNeg" , 0 )
                            self.rotMax = xmlObject:getValue( ".physics#rotMax" , 0 )
                            self.rotMin = xmlObject:getValue( ".physics#rotMin" , 0 )

                            self.invertRotLimit = xmlObject:getValue( ".physics#invertRotLimit" , false )
                            self.rotSpeedLimit = xmlObject:getValue( ".physics#rotSpeedLimit" )

                            local maxInnerSpacing = xmlObject:getValue( ".physics#maxInnerSpacing" )
                            if maxInnerSpacing ~ = nil then
                                local offset = ( self.width * 0.5 ) - maxInnerSpacing
                                if offset > 0 then
                                    local x, y, z = localToLocal( self.wheel.driveNode, getParent( self.wheel.driveNode), self.wheel.isLeft and offset or - offset, 0 , 0 )
                                    setTranslation( self.wheel.driveNode, x, y, z)
                                end
                            end

                            self.positionX, self.positionY, self.positionZ = localToLocal( self.wheel.driveNode, self.wheel.node, 0 , 0 , 0 )

                            if self.useReprDirection then
                                self.directionX, self.directionY, self.directionZ = localDirectionToLocal( self.wheel.repr, self.wheel.node, 0 , - 1 , 0 )
                                self.axleX, self.axleY, self.axleZ = localDirectionToLocal( self.wheel.repr, self.wheel.node, 1 , 0 , 0 )
                            elseif self.useDriveNodeDirection then
                                    self.directionX, self.directionY, self.directionZ = localDirectionToLocal( self.wheel.driveNodeDirectionNode, self.wheel.node, 0 , - 1 , 0 )
                                    self.axleX, self.axleY, self.axleZ = localDirectionToLocal( self.wheel.driveNodeDirectionNode, self.wheel.node, 1 , 0 , 0 )
                                else
                                        self.directionX, self.directionY, self.directionZ = 0 , - 1 , 0
                                        self.axleX, self.axleY, self.axleZ = 1 , 0 , 0
                                    end

                                    self.steeringCenterOffsetX, self.steeringCenterOffsetY, self.steeringCenterOffsetZ = 0 , 0 , 0
                                    if self.wheel.repr ~ = self.wheel.driveNode then
                                        self.steeringCenterOffsetX, self.steeringCenterOffsetY, self.steeringCenterOffsetZ = localToLocal( self.wheel.driveNode, self.wheel.repr, 0 , 0 , 0 )
                                        self.steeringCenterOffsetX = - self.steeringCenterOffsetX
                                        self.steeringCenterOffsetY = - self.steeringCenterOffsetY
                                        self.steeringCenterOffsetZ = - self.steeringCenterOffsetZ
                                    end

                                    return true
                                end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | wheel |
|-----|-------|

**Code**

```lua
function WheelPhysics.new(wheel)
    local self = setmetatable( { } , { __index = WheelPhysics } )

    self.wheel = wheel
    self.vehicle = wheel.vehicle

    self.wheelShape = 0
    self.wheelShapeCreationFrameIndex = math.huge
    self.wheelShapeCreated = false

    self.torque = 0
    self.torqueDirection = 1

    self.dirtAmount = 0
    self.trackAlpha = 0
    self.groundColor = { 0 , 0 , 0 }
    self.fieldGroundColor = { 0 , 0 , 0 }
    self.trackColor = { 0 , 0 , 0 }
    self.groundDepth = 0
    self.colorBlendWithTerrain = 1
    self.lastTerrainAttribute = 0

    self.contact = WheelContactType.NONE
    self.hasWaterContact = false
    self.hasSnowContact = false
    self.snowScale = 0
    self.lastSnowScale = 0
    self.steeringAngle = 0
    self.hasGroundContact = false
    self.lastContactObjectAllowsTireTracks = true
    self.densityBits = 0
    self.densityType = FieldGroundType.NONE

    self.displacementScale = 1
    self.displacementAllowed = true
    self.displacementCollisionEnabled = true

    self.sink = 0
    self.sinkTarget = 0

    self.hasSoilContact = false

    self.tireGroundFrictionCoeff = 1.0 -- This will be changed dynamically based on the tire-ground pair

    return self
end

```

### postLoad

**Description**

**Definition**

> postLoad()

**Code**

```lua
function WheelPhysics:postLoad()
end

```

### postUpdate

**Description**

**Definition**

> postUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function WheelPhysics:postUpdate(dt)
    if self.isPositionDirty then
        self:updateBase()
    end

    if self.isFrictionDirty then
        self:updateTireFriction()
    end
end

```

### readStream

**Description**

**Definition**

> readStream()

**Arguments**

| any | streamId            |
|-----|---------------------|
| any | updateInterpolation |

**Code**

```lua
function WheelPhysics:readStream(streamId, updateInterpolation)
    local xDriveDirection = streamReadBool(streamId) and 1 or - 1
    local xDriveDiff = streamReadUIntN(streamId, WheelPhysics.X_DRIVE_NUM_BITS)
    xDriveDiff = xDriveDiff / WheelPhysics.X_DRIVE_MAX_VALUE
    xDriveDiff = 1 - (( 1 - xDriveDiff) ^ ( 1 / 4 ))
    xDriveDiff = xDriveDiff * WheelPhysics.X_DRIVE_MAX_REAL_VALUE * xDriveDirection
    if updateInterpolation then
        self.networkInterpolators.xDriveDiff:setValue(xDriveDiff)
    else
            self.networkInterpolators.xDriveDiff:setTargetValue(xDriveDiff)
        end

        local y = streamReadUIntN(streamId, 8 )
        y = y / 255 * self.netInfo.sync.yRange + self.netInfo.sync.yMin
        if updateInterpolation then
            self.netInfo.y = y
            self.networkInterpolators.position:setPosition( self.netInfo.x, y, self.netInfo.z)
        else
                self.networkInterpolators.position:setTargetPosition( self.netInfo.x, y, self.netInfo.z)
            end

            local suspLength = streamReadUIntN(streamId, 7 )
            if updateInterpolation then
                self.netInfo.suspensionLength = suspLength / 100
                self.networkInterpolators.suspensionLength:setValue(suspLength / 100 )
            else
                    self.networkInterpolators.suspensionLength:setTargetValue(suspLength / 100 )
                end

                if self.wheel.syncContactState then
                    self.contact = streamReadUIntN(streamId, 2 ) + 1
                    self.lastContactObjectAllowsTireTracks = streamReadBool(streamId)
                end

                if self.versatileYRot then
                    local yRot = streamReadUIntN(streamId, 9 )
                    self.steeringAngle = yRot / 511 * math.pi * 2
                end
            end

```

### registerAdditionalWheelXMLPaths

**Description**

**Definition**

> registerAdditionalWheelXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function WheelPhysics.registerAdditionalWheelXMLPaths(schema, key)
    schema:register(XMLValueType.FLOAT, key .. ".physics#mass" , "Wheel mass(to.)" , 0 )
    schema:register(XMLValueType.FLOAT, key .. ".physics#maxLongStiffness" , "Max.longitude stiffness" )
    schema:register(XMLValueType.FLOAT, key .. ".physics#maxLatStiffness" , "Max.latitude stiffness" )
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function WheelPhysics.registerXMLPaths(schema, key)
    schema:register(XMLValueType.FLOAT, key .. ".physics#xOffset" , "Moves the default position of the drive node on the X axis" , 0 )
    schema:register(XMLValueType.FLOAT, key .. ".physics#yOffset" , "Moves the default position of the drive node on the Y axis" , 0 )
    schema:register(XMLValueType.FLOAT, key .. ".physics#zOffset" , "Moves the default position of the drive node on the Z axis" , 0 )
    schema:register(XMLValueType.BOOL, key .. ".physics#useReprOffset" , "Defines if the x/y/z offset attribute is applied to the repr or driveNode" , false )
        schema:register(XMLValueType.BOOL, key .. ".physics#showSteeringAngle" , "Show steering angle" , true )
        schema:register(XMLValueType.FLOAT, key .. ".physics#steeringAngleFactor" , "Scale factor for physics steering angle to steer more than the visuals show" , 1 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#suspTravel" , "Suspension travel" , 0.01 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#initialCompression" , "Initial compression value" )
            schema:register(XMLValueType.FLOAT, key .. ".physics#deltaY" , "Delta Y" , 0 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#spring" , "Spring" , 0 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#brakeFactor" , "Brake factor" , 1 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#autoHoldBrakeFactor" , "Auto hold brake factor" , "brakeFactor" )

            schema:register(XMLValueType.FLOAT, key .. ".physics#damper" , "Damper" , 0 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#damperCompressionLowSpeed" , "Damper compression on low speeds" )
            schema:register(XMLValueType.FLOAT, key .. ".physics#damperCompressionHighSpeed" , "Damper compression on high speeds" )
            schema:register(XMLValueType.FLOAT, key .. ".physics#damperCompressionLowSpeedThreshold" , "Damper compression on low speeds threshold" , 0.1016 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#damperRelaxationLowSpeed" , "Damper relaxation on low speeds" )
            schema:register(XMLValueType.FLOAT, key .. ".physics#damperRelaxationHighSpeed" , "Damper relaxation on high speeds" )
            schema:register(XMLValueType.FLOAT, key .. ".physics#damperRelaxationLowSpeedThreshold" , "Damper relaxation on low speeds threshold" , 0.1524 )

            schema:register(XMLValueType.FLOAT, key .. ".physics#forcePointRatio" , "Force point ratio" , 0 )
            schema:register(XMLValueType.INT, key .. ".physics#driveMode" , "Drive mode" , 0 )

            schema:register(XMLValueType.BOOL, key .. ".physics#isSynchronized" , "Wheel is synchronized in multiplayer" , true )
            schema:register(XMLValueType.INT, key .. ".physics#tipOcclusionAreaGroupId" , "Tip occlusion area group id" )

            schema:register(XMLValueType.BOOL, key .. ".physics#useReprDirection" , "Use repr direction instead of component direction" , false )
            schema:register(XMLValueType.BOOL, key .. ".physics#useDriveNodeDirection" , "Use drive node direction instead of component direction" , false )

            schema:register(XMLValueType.FLOAT, key .. ".physics#mass" , "Wheel mass(to.)" , 0.1 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#radius" , "Wheel radius" , 0.5 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#width" , "Wheel width" , 0.6 )

            schema:register(XMLValueType.FLOAT, key .. ".physics#visualOffset" , "Radius offset of visual wheel in percentage(0-1).Not used on the game." )

            schema:register(XMLValueType.FLOAT, key .. ".physics#widthOffset" , "Wheel width offset" , 0 )
            schema:register(XMLValueType.FLOAT, key .. ".physics#restLoad" , "Wheel load while resting" , 1.0 )
                schema:register(XMLValueType.FLOAT, key .. ".physics#maxLongStiffness" , "Max.longitude stiffness" )
                schema:register(XMLValueType.FLOAT, key .. ".physics#maxLatStiffness" , "Max.latitude stiffness" )
                schema:register(XMLValueType.FLOAT, key .. ".physics#maxLatStiffnessLoad" , "Max.latitude stiffness load" )
                schema:register(XMLValueType.FLOAT, key .. ".physics#frictionScale" , "Wheel friction scale" , 1.0 )
                schema:register(XMLValueType.FLOAT, key .. ".physics#rotationDamping" , "Rotation damping " , "mass * 0.035" )
                schema:register(XMLValueType.STRING, key .. ".physics#tireType" , "Tire type(mud, offRoad, street, crawler)" )

                schema:register(XMLValueType.FLOAT, key .. ".physics#fieldDirtMultiplier" , "Field dirt multiplier" , 75 )
                schema:register(XMLValueType.FLOAT, key .. ".physics#streetDirtMultiplier" , "Street dirt multiplier" , - 150 )
                schema:register(XMLValueType.FLOAT, key .. ".physics#waterWetnessFactor" , "Factor for wheel wetness while driving in water" , 20 )
                    schema:register(XMLValueType.FLOAT, key .. ".physics#minDirtPercentage" , "Min.dirt scale while cleaning on street drive" , 0.35 )
                        schema:register(XMLValueType.FLOAT, key .. ".physics#maxDirtOffset" , "Max.dirt amount offset to global dirt node" , 0.5 )
                        schema:register(XMLValueType.FLOAT, key .. ".physics#dirtColorChangeSpeed" , "Defines speed to change the dirt color(sec)" , 20 )

                        schema:register(XMLValueType.BOOL, key .. ".physics#versatileYRot" , "Do versatile Y rotation" , false )
                        schema:register(XMLValueType.BOOL, key .. ".physics#forceVersatility" , "Force versatility, also if no ground contact" , false )
                            schema:register(XMLValueType.BOOL, key .. ".physics#supportsWheelSink" , "The wheel is allowed to deform the terrain displacement collision and 'sink' into the terrain" , true )

                            schema:register(XMLValueType.BOOL, key .. ".physics.extraSink#supported" , "Additional sinking into the terrain independent of the adjustment of the terrain displacement. (FS22 in prior style)" , false )
                            schema:register(XMLValueType.FLOAT, key .. ".physics.extraSink#maxValue" , "Max.sink value in meter" , "20% of the wheel radius" )

                            schema:register(XMLValueType.ANGLE, key .. ".physics#rotSpeed" , "Rotation speed" )
                            schema:register(XMLValueType.ANGLE, key .. ".physics#rotSpeedNeg" , "Rotation speed in negative direction" )
                            schema:register(XMLValueType.ANGLE, key .. ".physics#rotMax" , "Max.rotation" )
                            schema:register(XMLValueType.ANGLE, key .. ".physics#rotMin" , "Min.rotation" )

                            schema:register(XMLValueType.BOOL, key .. ".physics#invertRotLimit" , "Invert the rotation limits" )
                            schema:register(XMLValueType.FLOAT, key .. ".physics#rotSpeedLimit" , "Rotation speed limit" )

                            schema:register(XMLValueType.FLOAT, key .. ".physics#maxInnerSpacing" , "Defines a maximum spacing to the inside which is now allowed to be exceeded by the tire, if so, the tire will be moved out automatically" )
                            end

```

### removeFromPhysics

**Description**

**Definition**

> removeFromPhysics()

**Code**

```lua
function WheelPhysics:removeFromPhysics()
    self.wheelShape = 0
    self.wheelShapeCreationFrameIndex = math.huge
    self.wheelShapeCreated = false
end

```

### serverUpdate

**Description**

**Definition**

> serverUpdate()

**Arguments**

| any | dt                 |
|-----|--------------------|
| any | currentUpdateIndex |
| any | groundWetness      |

**Code**

```lua
function WheelPhysics:serverUpdate(dt, currentUpdateIndex, groundWetness)
    if self.vehicle.isActive then
        if currentUpdateIndex = = self.wheel.updateIndex then
            self:updateContact()
        end

        if self.extraSinkSupported then
            self:updateSink(dt, groundWetness)
        end

        if self.vehicle.isServer then
            self:updateFriction(dt, groundWetness)
        end

        local brakeForce = 0
        if self.wheel.brakePedal > 0 then
            brakeForce = self.vehicle:getBrakeForce() * self.wheel.brakePedal
        end

        self:updatePhysics(brakeForce)
        self:updateSteeringAngle(dt)
    end

    self:updateNetInfo(dt)
end

```

### setDisplacementAllowed

**Description**

**Definition**

> setDisplacementAllowed()

**Arguments**

| any | displacementAllowed |
|-----|---------------------|

**Code**

```lua
function WheelPhysics:setDisplacementAllowed(displacementAllowed)
    self.displacementAllowed = displacementAllowed

    if self.vehicle.isServer and self.vehicle.isAddedToPhysics then
        setWheelShapeTerrainDisplacement( self.wheel.node, self.wheelShape, self.displacementAllowed and self.displacementScale or 0 )
    end
end

```

### setDisplacementCollisionEnabled

**Description**

**Definition**

> setDisplacementCollisionEnabled()

**Arguments**

| any | displacementCollisionEnabled |
|-----|------------------------------|

**Code**

```lua
function WheelPhysics:setDisplacementCollisionEnabled(displacementCollisionEnabled)
    self.displacementCollisionEnabled = displacementCollisionEnabled

    local oldCollisionMask = self.collisionMask
    if not Platform.gameplay.wheelTerrainDisplacement or not self.supportsWheelSink or not self.displacementCollisionEnabled then
        self.collisionMask = bit32.band( WheelPhysics.COLLISION_MASK, bit32.bnot(CollisionFlag.TERRAIN_DISPLACEMENT)) -- remove TERRAIN_DISPLACEMENT from mask
    else
            self.collisionMask = nil
        end

        if self.collisionMask ~ = oldCollisionMask then
            self:updateBase()
        end
    end

```

### setSteeringValues

**Description**

**Definition**

> setSteeringValues()

**Arguments**

| any | rotMin      |
|-----|-------------|
| any | rotMax      |
| any | rotSpeed    |
| any | rotSpeedNeg |
| any | inverted    |

**Code**

```lua
function WheelPhysics:setSteeringValues(rotMin, rotMax, rotSpeed, rotSpeedNeg, inverted)
    self.rotMin = rotMin
    self.rotMax = rotMax

    if self.invertRotLimit then
        inverted = not inverted
    end

    if inverted then
        rotSpeed, rotSpeedNeg = - rotSpeedNeg, - rotSpeed
    end

    self.rotSpeed = rotSpeed
    self.rotSpeedNeg = rotSpeedNeg
end

```

### setSuspensionMultipliers

**Description**

**Definition**

> setSuspensionMultipliers()

**Arguments**

| any | springMultiplier  |
|-----|-------------------|
| any | dampingMultiplier |

**Code**

```lua
function WheelPhysics:setSuspensionMultipliers(springMultiplier, dampingMultiplier)
    self.springMultiplier = springMultiplier or 1
    self.dampingMultiplier = dampingMultiplier or 1

    self.isPositionDirty = true
end

```

### setTorqueDirection

**Description**

**Definition**

> setTorqueDirection()

**Arguments**

| any | torqueDirection |
|-----|-----------------|

**Code**

```lua
function WheelPhysics:setTorqueDirection(torqueDirection)
    torqueDirection = torqueDirection > = 0 and 1 or - 1
    if torqueDirection ~ = self.torqueDirection then
        self.torqueDirection = torqueDirection
        self:updateBase()
    end
end

```

### setWheelShapeWidth

**Description**

**Definition**

> setWheelShapeWidth()

**Arguments**

| any | width  |
|-----|--------|
| any | offset |

**Code**

```lua
function WheelPhysics:setWheelShapeWidth(width, offset)
    self.wheelShapeWidth, self.wheelShapeWidthOffset = width or self.wheelShapeWidth, offset or self.wheelShapeWidthOffset

    self.isPositionDirty = true
end

```

### updateBase

**Description**

**Definition**

> updateBase()

**Code**

```lua
function WheelPhysics:updateBase()
    if self.vehicle.isServer and self.vehicle.isAddedToPhysics then
        local positionX, positionY, positionZ = self.positionX - self.directionX * self.deltaY, self.positionY - self.directionY * self.deltaY, self.positionZ - self.directionZ * self.deltaY

        --#debug if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
            --#debug local x1, y1, z1 = localToWorld(self.wheel.node, self.positionX, self.positionY, self.positionZ)
            --#debug local x2, y2, z2 = localToWorld(self.wheel.node, positionX, positionY, positionZ)
            --#debug drawDebugLine(x1, y1, z1, 1, 0, 0, x2, y2, z2, 0, 1, 0, false)
            --#debug end

            if self.wheelShape = = 0 then
                self.wheelShapeCreationFrameIndex = g_updateLoopIndex
                self.wheelShapeCreated = false
            end

            local spring = self.spring * self.springMultiplier
            local damperCompressionLowSpeed = self.damperCompressionLowSpeed * self.dampingMultiplier
            local damperCompressionHighSpeed = self.damperCompressionHighSpeed * self.dampingMultiplier
            local damperRelaxationLowSpeed = self.damperRelaxationLowSpeed * self.dampingMultiplier
            local damperRelaxationHighSpeed = self.damperRelaxationHighSpeed * self.dampingMultiplier

            local collisionGroup = WheelPhysics.COLLISION_GROUP
            local collisionMask = self.collisionMask or WheelPhysics.COLLISION_MASK
            self.wheelShape = createWheelShape( self.wheel.node, positionX, positionY, positionZ, self.radius, self.suspTravel, spring, damperCompressionLowSpeed, damperCompressionHighSpeed, self.damperCompressionLowSpeedThreshold, damperRelaxationLowSpeed, damperRelaxationHighSpeed, self.damperRelaxationLowSpeedThreshold, self.wheel:getMass(), collisionGroup, collisionMask, self.wheelShape)

            local forcePointY = positionY - self.radius * self.forcePointRatio
            local steeringX, steeringY, steeringZ = localToLocal(getParent( self.wheel.repr), self.wheel.node, self.wheel.startPositionX, self.wheel.startPositionY + self.deltaY, self.wheel.startPositionZ)
            setWheelShapeForcePoint( self.wheel.node, self.wheelShape, self.positionX, forcePointY, positionZ)
            setWheelShapeSteeringCenter( self.wheel.node, self.wheelShape, steeringX, steeringY, steeringZ)

            local direction = self.torqueDirection
            setWheelShapeDirection( self.wheel.node, self.wheelShape, self.directionX, self.directionY, self.directionZ, self.axleX * direction, self.axleY * direction, self.axleZ * direction)
            setWheelShapeWidth( self.wheel.node, self.wheelShape, self.wheelShapeWidth, self.wheelShapeWidthOffset)

            setWheelShapeTerrainDisplacement( self.wheel.node, self.wheelShape, self.displacementAllowed and self.displacementScale or 0 )

            self.isPositionDirty = false
        end
    end

```

### updateContact

**Description**

**Definition**

> updateContact()

**Code**

```lua
function WheelPhysics:updateContact()
    -- using netinfo because of tire deformation
    local nx, ny, nz = self.netInfo.x, self.netInfo.y, self.netInfo.z

    local cx, cy, cz = localToWorld( self.wheel.node, nx, ny, nz)
    raycastClosestAsync(cx, cy, cz, 0 , - 1 , 0 , self.radius + 0.25 , "waterRaycastCallback" , self , CollisionFlag.WATER)

    local wx, wy, wz = localToWorld( self.wheel.node, nx, ny - self.radius, nz)

    local mission = g_currentMission
    if g_updateLoopIndex - self.wheelShapeCreationFrameIndex > 2 then
        self.wheelShapeCreated = true

        local contactX, contactY, contactZ, _ = getWheelShapeContactPoint( self.wheel.node, self.wheelShape)
        self.hasGroundContact = contactX ~ = nil
        if self.hasGroundContact then
            self.lastContactX, self.lastContactY, self.lastContactZ = contactX, contactY, contactZ
        end

        --wheelSpeed = getWheelShapeAxleSpeed(self.wheel.node, self.wheelShape)
        local contactObject, _ = getWheelShapeContactObject( self.wheel.node, self.wheelShape)
        if contactObject ~ = 0 then
            local heightTypeIndex = getDensityMapHeightTypeAtWorldPos(g_densityMapHeightManager.terrainDetailHeightUpdater, wx, wy, wz, 0 )
            if heightTypeIndex ~ = 0 then
                self.contact = WheelContactType.GROUND_HEIGHT
                self.lastContactObjectAllowsTireTracks = true
            elseif contactObject = = g_terrainNode then
                    self.contact = WheelContactType.GROUND
                    self.lastContactObjectAllowsTireTracks = true
                elseif self.hasGroundContact then
                        self.contact = WheelContactType.OBJECT
                        self.lastContactObjectAllowsTireTracks = entityExists(contactObject) and getRigidBodyType(contactObject) = = RigidBodyType.STATIC and getUserAttribute(contactObject, "noTireTracks" ) ~ = true
                    else
                            self.contact = WheelContactType.NONE
                            self.lastContactObjectAllowsTireTracks = false
                        end
                    else
                            self.contact = WheelContactType.NONE
                            self.lastContactObjectAllowsTireTracks = false
                        end
                    end

                    if self.contact = = WheelContactType.GROUND then
                        local groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)
                        self.densityBits = getDensityAtWorldPos(groundTypeMapId, wx, wy, wz)
                        local densityType = bit32.band(bit32.rshift( self.densityBits, groundTypeFirstChannel), 2 ^ groundTypeNumChannels - 1 )
                        self.densityType = FieldGroundType.getTypeByValue(densityType)
                    else
                            self.densityBits = 0
                            self.densityType = FieldGroundType.NONE
                        end

                        if self.contact = = WheelContactType.GROUND_HEIGHT then
                            local densityHeightBits = getDensityAtWorldPos(mission.terrainDetailHeightId, wx, wy, wz)
                            local numChannels = g_densityMapHeightManager.heightTypeNumChannels
                            local heightType = bit32.band(densityHeightBits, 2 ^ numChannels - 1 )
                            self.hasSnowContact = heightType = = mission.snowSystem.snowHeightTypeIndex
                        else
                                self.hasSnowContact = false
                            end
                        end

```

### updateContactClient

**Description**

**Definition**

> updateContactClient()

**Code**

```lua
function WheelPhysics:updateContactClient()
    local mission = g_currentMission

    local nx, ny, nz = self.netInfo.x, self.netInfo.y, self.netInfo.z
    local wx, wy, wz = localToWorld( self.wheel.node, nx, ny - self.radius, nz)

    if self.contact = = WheelContactType.GROUND then
        local groundTypeMapId, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)
        self.densityBits = getDensityAtWorldPos(groundTypeMapId, wx, wy, wz)
        local densityType = bit32.band(bit32.rshift( self.densityBits, groundTypeFirstChannel), 2 ^ groundTypeNumChannels - 1 )
        self.densityType = FieldGroundType.getTypeByValue(densityType)
    else
            self.densityBits = 0
            self.densityType = FieldGroundType.NONE
        end

        if self.contact = = WheelContactType.GROUND_HEIGHT then
            local densityHeightBits = getDensityAtWorldPos(mission.terrainDetailHeightId, wx, wy, wz)
            local numChannels = g_densityMapHeightManager.heightTypeNumChannels
            local heightType = bit32.band(densityHeightBits, 2 ^ numChannels - 1 )
            self.hasSnowContact = heightType = = mission.snowSystem.snowHeightTypeIndex
        else
                self.hasSnowContact = false
            end
        end

```

### updateFriction

**Description**

**Definition**

> updateFriction()

**Arguments**

| any | dt            |
|-----|---------------|
| any | groundWetness |

**Code**

```lua
function WheelPhysics:updateFriction(dt, groundWetness)
    local isOnField = self.densityType ~ = FieldGroundType.NONE

    local snowScale = 0
    if self.hasSnowContact then
        groundWetness = 0
        snowScale = 1
    end

    local groundType = WheelsUtil.getGroundType(isOnField, self.contact ~ = WheelContactType.GROUND, self.groundDepth)
    local coeff = WheelsUtil.getTireFriction( self.tireType, groundType, groundWetness, snowScale)
    if self.vehicle:getLastSpeed() > 0.2 then
        if coeff ~ = self.tireGroundFrictionCoeff then
            self.tireGroundFrictionCoeff = coeff
            self.isFrictionDirty = true
        end
    end
end

```

### updateInterpolation

**Description**

**Definition**

> updateInterpolation()

**Arguments**

| any | dt                 |
|-----|--------------------|
| any | interpolationAlpha |

**Code**

```lua
function WheelPhysics:updateInterpolation(dt, interpolationAlpha)
    --#profile RemoteProfiler.zoneBeginN("updateInterpolation")
    self.netInfo.x, self.netInfo.y, self.netInfo.z = self.networkInterpolators.position:getInterpolatedValues(interpolationAlpha)
    self.netInfo.suspensionLength = self.networkInterpolators.suspensionLength:getInterpolatedValue(interpolationAlpha)

    local xDriveDiff = self.networkInterpolators.xDriveDiff:getInterpolatedValue(interpolationAlpha)
    self.netInfo.xDrive = ( self.netInfo.xDrive + xDriveDiff * dt) % ( 2 * math.pi)
    --#profile RemoteProfiler.zoneEnd()

    self:updateXDriveSpeed(dt)
    self:updateSteeringAngle(dt)
end

```

### updateNetInfo

**Description**

**Definition**

> updateNetInfo()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function WheelPhysics:updateNetInfo(dt)
    if self.updateWheel then
        local x, y, z, xDrive, suspensionLength = getWheelShapePosition( self.wheel.node, self.wheelShape)

        if self.torqueDirection < 0 then
            self.netInfo.xDrive = self.netInfo.xDrive - (xDrive - self.netInfo.xDriveLastRaw)
        else
                self.netInfo.xDrive = self.netInfo.xDrive + (xDrive - self.netInfo.xDriveLastRaw)
            end
            self.netInfo.xDriveLastRaw = xDrive

            if self.dirtyFlag ~ = nil and( self.netInfo.x ~ = x or self.netInfo.z ~ = z) then
                self.vehicle:raiseDirtyFlags( self.dirtyFlag)
            end

            --fill netinfo(on server)
            self.netInfo.x = x
            self.netInfo.y = y
            self.netInfo.z = z
            self.netInfo.suspensionLength = suspensionLength

            self.netInfo.xDriveDiff = 0
            self:updateXDriveSpeed( math.max(g_physicsDtNonInterpolated, 0.001 ))
        else
                self.updateWheel = true
            end
        end

```

### updatePhysics

**Description**

**Definition**

> updatePhysics()

**Arguments**

| any | brakeForce |
|-----|------------|
| any | torque     |

**Code**

```lua
function WheelPhysics:updatePhysics(brakeForce, torque)
    if self.vehicle.isServer and self.vehicle.isAddedToPhysics then
        setWheelShapeProps( self.wheel.node, self.wheelShape, torque or self.torque, (brakeForce or 0 ) * self.brakeFactor, self.steeringAngle, self.rotationDamping)
        setWheelShapeAutoHoldBrakeForce( self.wheel.node, self.wheelShape, (brakeForce or 0 ) * self.autoHoldBrakeFactor)
    end
end

```

### updateShapePosition

**Description**

**Definition**

> updateShapePosition()

**Code**

```lua
function WheelPhysics:updateShapePosition()
    self.positionX, self.positionY, self.positionZ = localToLocal(getParent( self.wheel.repr), self.wheel.node, self.wheel.startPositionX - self.steeringCenterOffsetX, self.wheel.startPositionY - self.steeringCenterOffsetY, self.wheel.startPositionZ - self.steeringCenterOffsetZ)
    if self.useReprDirection then
        self.directionX, self.directionY, self.directionZ = localDirectionToLocal( self.wheel.repr, self.wheel.node, 0 , - 1 , 0 )
        self.axleX, self.axleY, self.axleZ = localDirectionToLocal( self.wheel.repr, self.wheel.node, 1 , 0 , 0 )
    elseif self.useDriveNodeDirection then
            self.directionX, self.directionY, self.directionZ = localDirectionToLocal( self.wheel.driveNodeDirectionNode, self.wheel.node, 0 , - 1 , 0 )
            self.axleX, self.axleY, self.axleZ = localDirectionToLocal( self.wheel.driveNodeDirectionNode, self.wheel.node, 1 , 0 , 0 )
        end

        -- update the wheel base in the post update to have only one per frame
        -- in case a wheel is updated from multiple movingTools/Parts
        -- additionally this ensures that the vehicle is added to the physics
        self.isPositionDirty = true
    end

```

### updateSink

**Description**

**Definition**

> updateSink()

**Arguments**

| any | dt            |
|-----|---------------|
| any | groundWetness |

**Code**

```lua
function WheelPhysics:updateSink(dt, groundWetness)
    if self.wheelShape ~ = 0 then
        local sinkTarget = self.sinkTarget
        local lastSpeed = self.vehicle:getLastSpeed()
        local interpolationFactor = 1

        if self.contact ~ = WheelContactType.NONE and lastSpeed > 0.3 then
            sinkTarget = WheelPhysics.MAX_SINK[ self.densityType] or 0

            -- if we are in water and we already sink, we increase the sink
                if self.hasWaterContact and sinkTarget ~ = 0 then
                    sinkTarget = math.max(sinkTarget, WheelPhysics.WATER_SINK)
                end

                sinkTarget = math.min(sinkTarget, self.extraSinkMaxValue)
            elseif self.contact = = WheelContactType.NONE then
                    sinkTarget = 0
                    lastSpeed = 10
                    interpolationFactor = 0.075 -- smoother interpolation back to normal radius in case we directly sink again after having ground contact -> this avoid jittering
                end

                if self.sinkTarget < sinkTarget then
                    self.sinkTarget = math.min(sinkTarget, self.sinkTarget + ( 0.05 * math.min( 30 , math.max( 0 , lastSpeed - 0.2 )) * (dt / 1000 ) * interpolationFactor))
                elseif self.sinkTarget > sinkTarget then
                        self.sinkTarget = math.max(sinkTarget, self.sinkTarget - ( 0.05 * math.min( 30 , math.max( 0 , lastSpeed - 0.2 )) * (dt / 1000 ) * interpolationFactor))
                    end

                    if math.abs( self.sink - self.sinkTarget) > 0.001 then
                        self.sink = self.sinkTarget

                        local deltaY = self.deltaYOriginal + self.sink
                        if deltaY ~ = self.deltaY then
                            self.deltaY = deltaY

                            self.isPositionDirty = true
                        end
                    end
                end
            end

```

### updateSteeringAngle

**Description**

**Definition**

> updateSteeringAngle()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function WheelPhysics:updateSteeringAngle(dt)
    --#profile RemoteProfiler.zoneBeginN("updateSteeringAngle")
    local steeringAngle = self.steeringAngle
    local rotatedTime = self.vehicle.rotatedTime

    if self.wheel.steering.steeringAxleScale ~ = nil and self.wheel.steering.steeringAxleScale ~ = 0 then
        local steeringAxleAngle = 0
        if self.vehicle.spec_attachable ~ = nil then
            steeringAxleAngle = self.vehicle.spec_attachable.steeringAxleAngle
        end
        steeringAngle = math.clamp(steeringAxleAngle * self.wheel.steering.steeringAxleScale, self.wheel.steering.steeringAxleRotMin, self.wheel.steering.steeringAxleRotMax)
    elseif self.versatileYRot and self.vehicle:getIsVersatileYRotActive( self.wheel) then
            if self.vehicle.isServer then
                if self.forceVersatility or self.hasGroundContact then
                    steeringAngle = Utils.getVersatileRotation( self.wheel.repr, self.wheel.node, dt, self.positionX, self.positionY, self.positionZ, self.steeringAngle, self.rotMin, self.rotMax)
                end
            end
        elseif ( self.rotSpeed ~ = 0 and self.rotMax ~ = nil and self.rotMin ~ = nil ) or self.wheel.forceSteeringAngleUpdate then
                if rotatedTime > 0 or self.rotSpeedNeg = = nil then
                    steeringAngle = rotatedTime * self.rotSpeed
                else
                        steeringAngle = rotatedTime * self.rotSpeedNeg
                    end
                    if steeringAngle > self.rotMax then
                        steeringAngle = self.rotMax
                    elseif steeringAngle < self.rotMin then
                            steeringAngle = self.rotMin
                        end
                        if self.vehicle.customSteeringAngleFunction then

                            --#profile RemoteProfiler.zoneBeginN("updateSteeringAngle-vehicle")
                            steeringAngle = self.vehicle:updateSteeringAngle( self.wheel, dt, steeringAngle)
                            --#profile RemoteProfiler.zoneEnd()
                        end
                    end

                    self.steeringAngle = steeringAngle
                    --#profile RemoteProfiler.zoneEnd()
                end

```

### updateTick

**Description**

**Definition**

> updateTick()

**Arguments**

| any | dt                    |
|-----|-----------------------|
| any | groundWetness         |
| any | currentUpdateDistance |

**Code**

```lua
function WheelPhysics:updateTick(dt, groundWetness, currentUpdateDistance)
    if self.rotSpeedLimit ~ = nil then
        local dir = - 1
        if self:getLastSpeed() < = self.rotSpeedLimit then
            dir = 1
        end

        self.currentRotSpeedAlpha = math.clamp( self.currentRotSpeedAlpha + dir * (dt / 1000 ), 0 , 1 )
        self.rotSpeed = self.rotSpeedDefault * self.currentRotSpeedAlpha
        self.rotSpeedNeg = self.rotSpeedNegDefault * self.currentRotSpeedAlpha
    end

    if currentUpdateDistance < TireTracks.MAX_CREATION_DISTANCE or currentUpdateDistance < WheelEffects.MAX_UPDATE_DISTANCE then
        self.hasSoilContact = false

        -- update color
        local wx, wy, wz = getWorldTranslation( self.wheel.driveNode)
        local targetDirtAmount, targetAlpha = 0 , 0
        if self.contact = = WheelContactType.GROUND then
            local isOnField = self.densityType ~ = FieldGroundType.NONE
            local colorBlendWithTerrain = 1

            local r, g, b, depth, t
            if isOnField then
                r, g, b, depth = g_currentMission.fieldGroundSystem:getFieldGroundTyreTrackColor( self.densityBits)
                t = 1 -- 1 is the materialId for dirt

                    targetDirtAmount = 1
                    if self.densityType = = FieldGroundType.GRASS then
                        targetDirtAmount = 0.7
                    elseif self.densityType = = FieldGroundType.GRASS_CUT then
                            targetDirtAmount = 0.6
                        else
                                self.hasSoilContact = true
                            end
                            self.fieldGroundColor[ 1 ] = r
                            self.fieldGroundColor[ 2 ] = g
                            self.fieldGroundColor[ 3 ] = b

                            colorBlendWithTerrain = 0.75
                        else
                                r, g, b, depth, t = getTerrainAttributesAtWorldPos(g_terrainNode, wx, wy, wz, true , true , true , true , false )
                                self.groundColor[ 1 ] = r
                                self.groundColor[ 2 ] = g
                                self.groundColor[ 3 ] = b

                                if depth > 0 then
                                    targetAlpha = 0.5
                                end
                            end

                            self.groundDepth = depth
                            self.colorBlendWithTerrain = colorBlendWithTerrain
                            self.lastTerrainAttribute = t
                        elseif self.contact = = WheelContactType.GROUND_HEIGHT then
                                self.groundDepth = 1
                                targetAlpha = 1
                                self.colorBlendWithTerrain = 0
                            elseif self.contact = = WheelContactType.OBJECT then
                                    -- no depth to tyre tracks on road etc.
                                    self.groundDepth = 0
                                end

                                if targetDirtAmount ~ = self.dirtAmount then
                                    if targetDirtAmount < self.dirtAmount then
                                        local maxTrackLength = 30 * ( 1 + groundWetness)
                                        local speedFactor = math.min( self.vehicle:getLastSpeed(), 20 ) / 20
                                        maxTrackLength = maxTrackLength * ( 2 - speedFactor)
                                        self.dirtAmount = math.max( self.dirtAmount - self.vehicle.lastMovedDistance / maxTrackLength, targetDirtAmount)
                                    else
                                            self.dirtAmount = math.min( self.dirtAmount + self.vehicle.lastMovedDistance, targetDirtAmount)
                                        end
                                    end

                                    -- fade over 0.5m
                                    if targetAlpha ~ = self.trackAlpha then
                                        if targetAlpha > self.trackAlpha then
                                            self.trackAlpha = math.min( self.trackAlpha + self.vehicle.lastMovedDistance * 2 , targetAlpha)
                                        else
                                                self.trackAlpha = math.max( self.trackAlpha - self.vehicle.lastMovedDistance * 2 , targetAlpha)
                                            end
                                        end

                                        if self.groundDepth > 0 then
                                            for i = 1 , 3 do
                                                self.trackColor[i] = self.fieldGroundColor[i] * self.dirtAmount + self.groundColor[i] * ( 1 - self.dirtAmount)
                                            end
                                        else
                                                for i = 1 , 3 do
                                                    self.trackColor[i] = self.fieldGroundColor[i]
                                                end
                                            end
                                        end
                                    end

```

### updateTireFriction

**Description**

**Definition**

> updateTireFriction()

**Code**

```lua
function WheelPhysics:updateTireFriction()
    if self.vehicle.isServer and self.vehicle.isAddedToPhysics then
        setWheelShapeTireFriction( self.wheel.node, self.wheelShape, self.maxLongStiffness, self.maxLatStiffness, self.maxLatStiffnessLoad, self.frictionScale * self.tireGroundFrictionCoeff)
        self.isFrictionDirty = false
    end
end

```

### updateXDriveSpeed

**Description**

**Definition**

> updateXDriveSpeed()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function WheelPhysics:updateXDriveSpeed(dt)
    --#profile RemoteProfiler.zoneBeginN("updateXDriveSpeed")
    local xDrive = self.netInfo.xDrive

    -- calculate xDriveSpeed
    if self.netInfo.xDriveBefore = = nil then
        self.netInfo.xDriveBefore = xDrive
    end

    local xDriveDiff = xDrive - self.netInfo.xDriveBefore
    if xDriveDiff > math.pi then
        self.netInfo.xDriveBefore = self.netInfo.xDriveBefore + ( 2 * math.pi)
    elseif xDriveDiff < - math.pi then
            self.netInfo.xDriveBefore = self.netInfo.xDriveBefore - ( 2 * math.pi)
        end
        self.netInfo.xDriveDiff = (xDrive - self.netInfo.xDriveBefore) / dt
        self.netInfo.xDriveSpeed = self.netInfo.xDriveDiff * 1000
        self.netInfo.xDriveBefore = xDrive

        local speed = MathUtil.rpmToMps( self.netInfo.xDriveSpeed / 6.283185 * 60 , self.radius)
        self.netInfo.lastSpeedSmoothed = self.netInfo.lastSpeedSmoothed * 0.9 + speed * 0.1
        self.netInfo.slip = math.clamp( self.netInfo.lastSpeedSmoothed / math.max( self.vehicle.lastSpeedSmoothed, 0.00000001 ), 1 , 2 ) - 1
        --#profile RemoteProfiler.zoneEnd()
    end

```

### waterRaycastCallback

**Description**

**Definition**

> waterRaycastCallback()

**Arguments**

| any | actorId       |
|-----|---------------|
| any | x             |
| any | y             |
| any | z             |
| any | distance      |
| any | nx            |
| any | ny            |
| any | nz            |
| any | subShapeIndex |
| any | shapeId       |
| any | isLast        |
| any | ...           |

**Code**

```lua
function WheelPhysics:waterRaycastCallback(actorId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast, .. .)
    if actorId ~ = 0 then
        local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)
        self.hasWaterContact = y > terrainHeight
    elseif isLast then
            self.hasWaterContact = false
        end
    end

```

### writeStream

**Description**

**Definition**

> writeStream()

**Arguments**

| any | streamId |
|-----|----------|

**Code**

```lua
function WheelPhysics:writeStream(streamId)
    local xDriveDiff = math.clamp( math.abs( self.netInfo.xDriveDiff) / WheelPhysics.X_DRIVE_MAX_REAL_VALUE, 0 , 1 )
    streamWriteBool(streamId, self.netInfo.xDriveDiff > = 0 )
    xDriveDiff = 1 - (( 1 - xDriveDiff) ^ 4 )
    streamWriteUIntN(streamId, xDriveDiff * WheelPhysics.X_DRIVE_MAX_VALUE, WheelPhysics.X_DRIVE_NUM_BITS)

    streamWriteUIntN(streamId, math.clamp( math.floor(( self.netInfo.y - self.netInfo.sync.yMin) / self.netInfo.sync.yRange * 255 ), 0 , 255 ), 8 )

    streamWriteUIntN(streamId, math.clamp( self.netInfo.suspensionLength * 100 , 0 , 128 ), 7 )

    if self.wheel.syncContactState then
        streamWriteUIntN(streamId, self.contact - 1 , 2 )
        streamWriteBool(streamId, self.lastContactObjectAllowsTireTracks)
    end

    if self.versatileYRot then
        local yRot = self.steeringAngle % ( math.pi * 2 )
        streamWriteUIntN(streamId, math.clamp( math.floor(yRot / ( math.pi * 2 ) * 511 ), 0 , 511 ), 9 )
    end
end

```