## SpeedRotatingParts

**Description**

> Specialization for vehicle with (non-wheel) parts rotating or scrolling dependent on its driving speed

**Functions**

- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getSpeedRotatingPartDirection](#getspeedrotatingpartdirection)
- [initSpecialization](#initspecialization)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateSpeedRotatingPart](#updatespeedrotatingpart)
- [validateWashableNode](#validatewashablenode)

### getIsSpeedRotatingPartActive

**Description**

> Returns true if speed rotating part is active

**Definition**

> getIsSpeedRotatingPartActive(table speedRotatingPart)

**Arguments**

| table | speedRotatingPart | speedRotatingPart |
|-------|-------------------|-------------------|

**Return Values**

| table | isActive | speed rotating part is active |
|-------|----------|-------------------------------|

**Code**

```lua
function SpeedRotatingParts:getIsSpeedRotatingPartActive(speedRotatingPart)
    if speedRotatingPart.onlyActiveWhenLowered then
        if self.getIsLowered ~ = nil and not self:getIsLowered() then
            return false
        else
                return true
            end
        end

        return true
    end

```

### getSpeedRotatingPartDirection

**Description**

> Return direction of speed rotating part

**Definition**

> getSpeedRotatingPartDirection(table speedRotatingPart)

**Arguments**

| table | speedRotatingPart | speed rotating part |
|-------|-------------------|---------------------|

**Return Values**

| table | direction | direction |
|-------|-----------|-----------|

**Code**

```lua
function SpeedRotatingParts:getSpeedRotatingPartDirection(speedRotatingPart)
    return 1
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function SpeedRotatingParts.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "SpeedRotatingParts" )

    schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#node" , "Speed rotating part node" )
    schema:register(XMLValueType.NODE_INDICES, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#nodes" , "Speed rotating part nodes(first node will be used as main repr node and the others just copy the rotation values)" )
    schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#shaderNode" , "Speed rotating part shader node" )
    schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#useRotation" , "Use shader rotation" , true )
    schema:register(XMLValueType.VECTOR_ 2 , SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#scrollScale" , "Shader scroll speed" )
    schema:register(XMLValueType.INT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#shaderComponent" , "Shader parameter component to control" , "Default based on available shader attributes" )
    schema:register(XMLValueType.VECTOR_N, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#shaderComponentSpeeds" , "Speed factor for different shader components(usable with 'vtxRotate' shader variation)" )
        schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#scrollLength" , "Shader scroll length" )
        schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#driveNode" , "Drive node to apply x drive" , "speedRotatingPart#node" )
        schema:register(XMLValueType.INT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#refComponentIndex" , "Reference component index" )
        schema:register(XMLValueType.INT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#wheelIndex" , "Reference wheel index" )
        schema:register(XMLValueType.NODE_INDICES, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#wheelNodes" , "List of reference wheel nodes(repr or drive node).The average speed of the wheels WITH ground contact is used." )
        schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#hasConfigWheels" , "Defined wheels are part of configurations, so no warning is displayed while they are not found." , false )

            schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#dirRefNode" , "Direction reference node" )
            schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#dirFrameNode" , "Direction reference frame" )

            schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#alignDirection" , "Align direction" , false )
            schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#applySteeringAngle" , "Apply steering angle" , false )
            schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#useWheelReprTranslation" , "Apply wheel repr translation" , true )
            schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#updateXDrive" , "Update X drive" , true )
            schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#versatileYRot" , "Versatile Y rot" , false )

            schema:register(XMLValueType.ANGLE, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#minYRot" , "Min.Y rotation" )
            schema:register(XMLValueType.ANGLE, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#maxYRot" , "Max.Y rotation" )

            schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#wheelScale" , "Wheel scale" )
            schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#radius" , "Radius" , 1 )

            schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#onlyActiveWhenLowered" , "Only active if lowered" , false )
                schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#stopIfNotActive" , "Stop if not active" , false )
                    schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#fadeOutTime" , "Fade out time" , 3 )
                    schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#activationSpeed" , "Min.speed for activation" , 1 )
                        schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#speedReferenceNode" , "Speed reference node" )

                        schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#hasTireTracks" , "Has Tire Tracks" , false )
                        schema:register(XMLValueType.INT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#tireTrackAtlasIndex" , "Index on tire track atlas" , 0 )
                        schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#tireTrackWidth" , "Width of tire tracks" , 0.5 )
                        schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#tireTrackInverted" , "Tire track texture inverted" , false )
                        schema:register(XMLValueType.NODE_INDEX, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#tireTrackWheelNode" , "Reference wheel for the tire tracks(radius, ground contact, etc)" )

                            schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#maxUpdateDistance" , "Max.distance from current camera to vehicle to update part" , SpeedRotatingParts.DEFAULT_MAX_UPDATE_DISTANCE)

                            schema:setXMLSpecializationType()
                        end

```

### loadSpeedRotatingPartFromXML

**Description**

> Loads speed rotating parts from xml

**Definition**

> loadSpeedRotatingPartFromXML(table speedRotatingPart, XMLFile xmlFile, string key)

**Arguments**

| table   | speedRotatingPart | speedRotatingPart |
|---------|-------------------|-------------------|
| XMLFile | xmlFile           | XMLFile instance  |
| string  | key               | key               |

**Return Values**

| string | success | success |
|--------|---------|---------|

**Code**

```lua
function SpeedRotatingParts:loadSpeedRotatingPartFromXML(speedRotatingPart, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#vtxPositionArrayFilename" , "Array should be assigned properly inside i3d." ) -- FS22 to FS25

    speedRotatingPart.reprNodes = xmlFile:getValue(key .. "#nodes" , nil , self.components, self.i3dMappings, true )

    speedRotatingPart.repr = xmlFile:getValue(key .. "#node" , speedRotatingPart.reprNodes[ 1 ], self.components, self.i3dMappings)
    speedRotatingPart.shaderNode = xmlFile:getValue(key .. "#shaderNode" , nil , self.components, self.i3dMappings)

    if #speedRotatingPart.reprNodes > 0 then
        if speedRotatingPart.reprNodes[ 1 ] = = speedRotatingPart.repr then
            table.remove(speedRotatingPart.reprNodes, 1 )
        end
    end

    speedRotatingPart.shaderParameterName = "offsetUV"
    speedRotatingPart.shaderParameterPrevName = nil
    speedRotatingPart.shaderParameterComponent = 3
    speedRotatingPart.shaderParameterSpeedScale = 1
    speedRotatingPart.shaderParameterValues = { 0 , 0 , 0 , 0 }
    if speedRotatingPart.shaderNode ~ = nil then
        speedRotatingPart.useShaderRotation = xmlFile:getValue(key .. "#useRotation" , true )
        speedRotatingPart.scrollScale = xmlFile:getValue(key .. "#scrollScale" , "1 0" , true )
        speedRotatingPart.scrollLength = xmlFile:getValue(key .. "#scrollLength" )

        if getHasShaderParameter(speedRotatingPart.shaderNode, "rotationAngle" ) then
            speedRotatingPart.shaderParameterName = "rotationAngle"
            speedRotatingPart.shaderParameterPrevName = "prevRotationAngle"
            speedRotatingPart.shaderParameterComponent = 1
            speedRotatingPart.shaderParameterSpeedScale = - 1
        end

        if getHasShaderParameter(speedRotatingPart.shaderNode, "scrollPos" ) then
            speedRotatingPart.shaderParameterName = "scrollPos"
            speedRotatingPart.shaderParameterPrevName = "prevScrollPos"
            speedRotatingPart.shaderParameterComponent = 1
            speedRotatingPart.shaderParameterSpeedScale = 1
        end

        speedRotatingPart.shaderParameterComponent = xmlFile:getValue(key .. "#shaderComponent" , speedRotatingPart.shaderParameterComponent)

        speedRotatingPart.shaderComponentSpeeds = xmlFile:getValue(key .. "#shaderComponentSpeeds" , nil , true )
    end

    if speedRotatingPart.repr = = nil and speedRotatingPart.shaderNode = = nil then
        Logging.xmlWarning( self.xmlFile, "Invalid speedRotationPart node '%s' in '%s'" , tostring(getXMLString(xmlFile.handle, key .. "#node" ) or getXMLString(xmlFile.handle, key .. "#shaderNode" )), key)
        return false
    end
    speedRotatingPart.driveNode = xmlFile:getValue(key .. "#driveNode" , speedRotatingPart.repr, self.components, self.i3dMappings)

    local componentIndex = xmlFile:getValue(key .. "#refComponentIndex" )
    if componentIndex ~ = nil and self.components[componentIndex] ~ = nil then
        speedRotatingPart.componentNode = self.components[componentIndex].node
    else
            local node = Utils.getNoNil(speedRotatingPart.driveNode, speedRotatingPart.shaderNode)
            speedRotatingPart.componentNode = self:getParentComponent(node)
        end

        speedRotatingPart.xDrive = 0
        local wheelIndex = xmlFile:getValue(key .. "#wheelIndex" )
        local wheelNodes = xmlFile:getValue(key .. "#wheelNodes" , nil , self.components, self.i3dMappings, true )
        if wheelIndex ~ = nil or #wheelNodes > 0 then
            if self.getWheels = = nil then
                Logging.xmlWarning( self.xmlFile, "wheelIndex for speedRotatingPart '%s' given, but no wheels loaded/defined" , key)
                else
                        local wheels = { }
                        if wheelIndex ~ = nil then
                            local wheel = self:getWheelFromWheelIndex(wheelIndex)
                            if wheel ~ = nil then
                                table.insert(wheels, wheel)
                            else
                                    if not xmlFile:getValue(key .. "#hasConfigWheels" , false ) then
                                        Logging.xmlWarning( self.xmlFile, "Invalid wheel index '%s' for speedRotatingPart '%s'" , wheelIndex, key)
                                        end
                                    end
                                end

                                if #wheelNodes > 0 then
                                    for _, wheelNode in ipairs(wheelNodes) do
                                        local wheel = self:getWheelByWheelNode(wheelNode)
                                        if wheel ~ = nil then
                                            table.insert(wheels, wheel)
                                        else
                                                if not xmlFile:getValue(key .. "#hasConfigWheels" , false ) then
                                                    Logging.xmlWarning( self.xmlFile, "Invalid wheel node '%s' for speedRotatingPart '%s'" , getName(wheelNode), key)
                                                    end
                                                end
                                            end
                                        end

                                        if #wheels = = 0 then
                                            return false
                                        end

                                        for _, wheel in ipairs(wheels) do
                                            wheel.syncContactState = true

                                            if not wheel.physics.isSynchronized then
                                                Logging.xmlWarning( self.xmlFile, "Referenced wheel '%s' for speedRotatingPart '%s' is not synchronized in multiplayer" , getName(wheel.repr), key)
                                                end
                                            end

                                            speedRotatingPart.wheels = wheels
                                            speedRotatingPart.lastWheelXRot = { }
                                        end
                                    end

                                    speedRotatingPart.hasTireTracks = xmlFile:getValue(key .. "#hasTireTracks" , false )
                                    speedRotatingPart.tireTrackAtlasIndex = xmlFile:getValue(key .. "#tireTrackAtlasIndex" , 0 )
                                    speedRotatingPart.tireTrackWidth = xmlFile:getValue(key .. "#tireTrackWidth" , 0.5 )
                                    speedRotatingPart.tireTrackInverted = xmlFile:getValue(key .. "#tireTrackInverted" , false )
                                    speedRotatingPart.tireTrackWheelNode = xmlFile:getValue(key .. "#tireTrackWheelNode" , nil , self.components, self.i3dMappings)
                                    if speedRotatingPart.hasTireTracks and Platform.gameplay.wheelTireTracks then
                                        local activeFunc = function ()
                                            return self:getIsSpeedRotatingPartActive(speedRotatingPart)
                                        end

                                        local wheel
                                        if speedRotatingPart.wheels ~ = nil then
                                            wheel = speedRotatingPart.wheels[ 1 ]
                                        elseif speedRotatingPart.tireTrackWheelNode ~ = nil then
                                                wheel = self:getWheelByWheelNode(speedRotatingPart.tireTrackWheelNode)
                                            else
                                                    Logging.xmlWarning( self.xmlFile, "Tire tracks for speedRotationPart '%s' defined, but no wheels or tireTrackWheelNode given" , key)
                                                        return false
                                                    end

                                                    speedRotatingPart.tireTrackNodeIndex = self:addTireTrackNode(wheel, speedRotatingPart.componentNode, speedRotatingPart.driveNode, speedRotatingPart.tireTrackAtlasIndex, speedRotatingPart.tireTrackWidth, wheel.physics.radius, speedRotatingPart.tireTrackInverted, activeFunc)
                                                end

                                                speedRotatingPart.dirRefNode = xmlFile:getValue(key .. "#dirRefNode" , nil , self.components, self.i3dMappings)
                                                speedRotatingPart.dirFrameNode = xmlFile:getValue(key .. "#dirFrameNode" , nil , self.components, self.i3dMappings)
                                                speedRotatingPart.alignDirection = xmlFile:getValue(key .. "#alignDirection" , false )
                                                speedRotatingPart.applySteeringAngle = xmlFile:getValue(key .. "#applySteeringAngle" , false )
                                                speedRotatingPart.useWheelReprTranslation = xmlFile:getValue(key .. "#useWheelReprTranslation" , true )
                                                speedRotatingPart.updateXDrive = xmlFile:getValue(key .. "#updateXDrive" , true )

                                                speedRotatingPart.versatileYRot = xmlFile:getValue(key .. "#versatileYRot" , false )
                                                if speedRotatingPart.versatileYRot and speedRotatingPart.repr = = nil then
                                                    Logging.xmlWarning( self.xmlFile, "Versatile speedRotationPart '%s' does not support shaderNodes" , key)
                                                    return false
                                                end

                                                speedRotatingPart.minYRot = xmlFile:getValue(key .. "#minYRot" )
                                                speedRotatingPart.maxYRot = xmlFile:getValue(key .. "#maxYRot" )
                                                speedRotatingPart.steeringAngle = 0
                                                speedRotatingPart.steeringAngleSent = 0

                                                speedRotatingPart.speedReferenceNode = xmlFile:getValue(key .. "#speedReferenceNode" , nil , self.components, self.i3dMappings)
                                                if speedRotatingPart.speedReferenceNode ~ = nil and speedRotatingPart.speedReferenceNode = = speedRotatingPart.driveNode then
                                                    Logging.xmlWarning( self.xmlFile, "Ignoring speedRotationPart '%s' because speedReferenceNode is identical with driveNode.Need to be different!" , key)
                                                    return false
                                                end

                                                speedRotatingPart.wheelScale = xmlFile:getValue(key .. "#wheelScale" )
                                                if speedRotatingPart.wheelScale = = nil then
                                                    local baseRadius = 1.0
                                                    local radius = 1.0
                                                    if speedRotatingPart.wheels ~ = nil and speedRotatingPart.speedReferenceNode = = nil then
                                                        baseRadius = speedRotatingPart.wheels[ 1 ].physics.radius
                                                        radius = speedRotatingPart.wheels[ 1 ].physics.radius
                                                    end
                                                    speedRotatingPart.wheelScale = baseRadius / xmlFile:getValue(key .. "#radius" , radius)
                                                end

                                                speedRotatingPart.wheelScaleBackup = speedRotatingPart.wheelScale

                                                speedRotatingPart.onlyActiveWhenLowered = xmlFile:getValue(key .. "#onlyActiveWhenLowered" , false )
                                                speedRotatingPart.stopIfNotActive = xmlFile:getValue(key .. "#stopIfNotActive" , false )
                                                speedRotatingPart.fadeOutTime = xmlFile:getValue(key .. "#fadeOutTime" , 3 ) * 1000
                                                speedRotatingPart.activationSpeed = xmlFile:getValue(key .. "#activationSpeed" , 1 )

                                                speedRotatingPart.lastSpeed = 0
                                                speedRotatingPart.lastDir = 1

                                                speedRotatingPart.maxUpdateDistance = xmlFile:getValue(key .. "#maxUpdateDistance" , SpeedRotatingParts.DEFAULT_MAX_UPDATE_DISTANCE)

                                                -- always update to sync the correct angle to the clients
                                                if self.isServer and speedRotatingPart.versatileYRot then
                                                    speedRotatingPart.maxUpdateDistance = math.huge
                                                end

                                                return true
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
function SpeedRotatingParts:onLoad(savegame)
    local spec = self.spec_speedRotatingParts

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.speedRotatingParts.speedRotatingPart(0)#index" , "vehicle.speedRotatingParts.speedRotatingPart(0)#node" ) -- FS17

    local maxUpdateDistance
    spec.individualUpdateDistance = false
    spec.speedRotatingParts = { }

    for _, baseName in self.xmlFile:iterator( "vehicle.speedRotatingParts.speedRotatingPart" ) do
        local speedRotatingPart = { }
        if self:loadSpeedRotatingPartFromXML(speedRotatingPart, self.xmlFile, baseName) then
            table.insert(spec.speedRotatingParts, speedRotatingPart)

            if maxUpdateDistance ~ = nil and maxUpdateDistance ~ = speedRotatingPart.maxUpdateDistance then
                spec.individualUpdateDistance = true
            end
            maxUpdateDistance = speedRotatingPart.maxUpdateDistance
        else
                if speedRotatingPart.tireTrackNodeIndex ~ = nil then
                    self:removeTireTrackNode(speedRotatingPart.tireTrackNodeIndex)
                end
            end
        end

        spec.maxUpdateDistance = maxUpdateDistance or SpeedRotatingParts.DEFAULT_MAX_UPDATE_DISTANCE

        spec.dirtyFlag = self:getNextDirtyFlag()

        if #spec.speedRotatingParts = = 0 then
            SpecializationUtil.removeEventListener( self , "onReadStream" , SpeedRotatingParts )
            SpecializationUtil.removeEventListener( self , "onWriteStream" , SpeedRotatingParts )
            SpecializationUtil.removeEventListener( self , "onReadUpdateStream" , SpeedRotatingParts )
            SpecializationUtil.removeEventListener( self , "onWriteUpdateStream" , SpeedRotatingParts )
            SpecializationUtil.removeEventListener( self , "onUpdate" , SpeedRotatingParts )
            SpecializationUtil.removeEventListener( self , "onUpdateTick" , SpeedRotatingParts )
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
function SpeedRotatingParts:onReadStream(streamId, connection)
    local spec = self.spec_speedRotatingParts
    for i = 1 , #spec.speedRotatingParts do
        local speedRotatingPart = spec.speedRotatingParts[i]
        if speedRotatingPart.versatileYRot then
            local yRot = streamReadUIntN(streamId, 9 )
            speedRotatingPart.steeringAngle = yRot / 511 * math.pi * 2
        end
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
function SpeedRotatingParts:onReadUpdateStream(streamId, timestamp, connection)
    if connection.isServer then
        local hasUpdate = streamReadBool(streamId)
        if hasUpdate then
            local spec = self.spec_speedRotatingParts
            for i = 1 , #spec.speedRotatingParts do
                local speedRotatingPart = spec.speedRotatingParts[i]
                if speedRotatingPart.versatileYRot then
                    local yRot = streamReadUIntN(streamId, 9 )
                    speedRotatingPart.steeringAngle = yRot / 511 * math.pi * 2
                end
            end
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
function SpeedRotatingParts:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_speedRotatingParts

    if spec.individualUpdateDistance or self.currentUpdateDistance < spec.maxUpdateDistance then
        for i = 1 , #spec.speedRotatingParts do
            local speedRotatingPart = spec.speedRotatingParts[i]
            if not spec.individualUpdateDistance or self.currentUpdateDistance < speedRotatingPart.maxUpdateDistance then
                if speedRotatingPart.isActive or(speedRotatingPart.lastSpeed ~ = 0 and not speedRotatingPart.stopIfNotActive) then
                    self:updateSpeedRotatingPart(speedRotatingPart, dt, speedRotatingPart.isActive)
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
function SpeedRotatingParts:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_speedRotatingParts

    if spec.individualUpdateDistance or self.currentUpdateDistance < spec.maxUpdateDistance then
        for i = 1 , #spec.speedRotatingParts do
            local speedRotatingPart = spec.speedRotatingParts[i]
            if not spec.individualUpdateDistance or self.currentUpdateDistance < speedRotatingPart.maxUpdateDistance then
                speedRotatingPart.isActive = self:getIsSpeedRotatingPartActive(speedRotatingPart)
            end
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
function SpeedRotatingParts:onWriteStream(streamId, connection)
    local spec = self.spec_speedRotatingParts
    for i = 1 , #spec.speedRotatingParts do
        local speedRotatingPart = spec.speedRotatingParts[i]
        if speedRotatingPart.versatileYRot then
            local yRot = speedRotatingPart.steeringAngle % ( math.pi * 2 )
            streamWriteUIntN(streamId, math.clamp( math.floor(yRot / ( math.pi * 2 ) * 511 ), 0 , 511 ), 9 )
        end
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
function SpeedRotatingParts:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection.isServer then
        local spec = self.spec_speedRotatingParts
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            for i = 1 , #spec.speedRotatingParts do
                local speedRotatingPart = spec.speedRotatingParts[i]
                if speedRotatingPart.versatileYRot then
                    local yRot = speedRotatingPart.steeringAngle % ( math.pi * 2 )
                    streamWriteUIntN(streamId, math.clamp( math.floor(yRot / ( math.pi * 2 ) * 511 ), 0 , 511 ), 9 )
                end
            end
        end
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
function SpeedRotatingParts.prerequisitesPresent(specializations)
    return true
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
function SpeedRotatingParts.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , SpeedRotatingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , SpeedRotatingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , SpeedRotatingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , SpeedRotatingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , SpeedRotatingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , SpeedRotatingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , SpeedRotatingParts )
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
function SpeedRotatingParts.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadSpeedRotatingPartFromXML" , SpeedRotatingParts.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsSpeedRotatingPartActive" , SpeedRotatingParts.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerFunction(vehicleType, "getSpeedRotatingPartDirection" , SpeedRotatingParts.getSpeedRotatingPartDirection)
    SpecializationUtil.registerFunction(vehicleType, "updateSpeedRotatingPart" , SpeedRotatingParts.updateSpeedRotatingPart)
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
function SpeedRotatingParts.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "validateWashableNode" , SpeedRotatingParts.validateWashableNode)
end

```

### updateSpeedRotatingPart

**Description**

**Definition**

> updateSpeedRotatingPart()

**Arguments**

| any | speedRotatingPart |
|-----|-------------------|
| any | dt                |
| any | isPartActive      |

**Code**

```lua
function SpeedRotatingParts:updateSpeedRotatingPart(speedRotatingPart, dt, isPartActive)
    local spec = self.spec_speedRotatingParts
    local speed = speedRotatingPart.lastSpeed
    local dir = speedRotatingPart.lastDir

    -- use angle from the repr node since the repr node could be rotated by another spec
    if speedRotatingPart.repr ~ = nil then
        if self.isServer or not speedRotatingPart.versatileYRot then
            local _
            _, speedRotatingPart.steeringAngle, _ = getRotation(speedRotatingPart.repr)
        end
    end

    if isPartActive then
        if speedRotatingPart.speedReferenceNode ~ = nil then
            local newX, newY, newZ = getWorldTranslation(speedRotatingPart.speedReferenceNode)
            if speedRotatingPart.lastPosition = = nil then
                speedRotatingPart.lastPosition = { newX, newY, newZ }
            end

            local dx, dy, dz = worldDirectionToLocal(speedRotatingPart.speedReferenceNode, newX - speedRotatingPart.lastPosition[ 1 ], newY - speedRotatingPart.lastPosition[ 2 ], newZ - speedRotatingPart.lastPosition[ 3 ])
            speed = MathUtil.vector3Length(dx, dy, dz)

            if dz > 0.001 then
                dir = 1
            elseif dz < - 0.001 then
                    dir = - 1
                else
                        dir = 0
                    end

                    speedRotatingPart.lastPosition[ 1 ], speedRotatingPart.lastPosition[ 2 ], speedRotatingPart.lastPosition[ 3 ] = newX, newY, newZ
                elseif speedRotatingPart.wheels ~ = nil then
                        local speedSum, numWheels = 0 , 0
                        dir = 0
                        for i, wheel in ipairs(speedRotatingPart.wheels) do
                            if speedRotatingPart.lastWheelXRot[i] = = nil then
                                speedRotatingPart.lastWheelXRot[i] = wheel.physics.netInfo.xDrive
                            end

                            if wheel.physics.contact ~ = WheelContactType.NONE or #speedRotatingPart.wheels = = 1 then
                                local rotDiff = wheel.physics.netInfo.xDrive - speedRotatingPart.lastWheelXRot[i]
                                if rotDiff > math.pi then
                                    rotDiff = rotDiff - ( 2 * math.pi)
                                elseif rotDiff < - math.pi then
                                        rotDiff = rotDiff + ( 2 * math.pi)
                                    end

                                    speedSum = speedSum + math.abs(rotDiff)
                                    if math.sign(rotDiff) ~ = 0 then
                                        dir = math.sign(rotDiff)
                                    end

                                    numWheels = numWheels + 1
                                end

                                speedRotatingPart.lastWheelXRot[i] = wheel.physics.netInfo.xDrive
                            end

                            if numWheels > 0 then
                                speed = speedSum / numWheels
                            else
                                    speed = 0
                                end

                                if not speedRotatingPart.versatileYRot then
                                    local _
                                    _, speedRotatingPart.steeringAngle, _ = getRotation(speedRotatingPart.wheels[ 1 ].repr)
                                end
                            else
                                    speed = self.lastSpeedReal * dt
                                    dir = self.movingDirection
                                end
                                speedRotatingPart.brakeForce = speed * dt / speedRotatingPart.fadeOutTime
                            else
                                    speed = math.max(speed - speedRotatingPart.brakeForce, 0 )

                                    if speedRotatingPart.wheels ~ = nil then
                                        for wheelIndex, _ in pairs(speedRotatingPart.lastWheelXRot) do
                                            speedRotatingPart.lastWheelXRot[wheelIndex] = nil
                                        end
                                    end
                                end

                                speedRotatingPart.lastSpeed = speed
                                speedRotatingPart.lastDir = dir
                                if speedRotatingPart.updateXDrive then
                                    speedRotatingPart.xDrive = (speedRotatingPart.xDrive + speed * dir * self:getSpeedRotatingPartDirection(speedRotatingPart) * speedRotatingPart.wheelScale) % ( 2 * math.pi)
                                end

                                if speedRotatingPart.versatileYRot then
                                    if speed > 0.0017 then -- 0.1deg threshold cause float accuracy
                                        if self.isServer and self:getLastSpeed( true ) > speedRotatingPart.activationSpeed then
                                            local posX, posY, posZ = localToLocal(speedRotatingPart.repr, speedRotatingPart.componentNode, 0 , 0 , 0 )
                                            speedRotatingPart.steeringAngle = Utils.getVersatileRotation(speedRotatingPart.repr, speedRotatingPart.componentNode, dt, posX, posY, posZ, speedRotatingPart.steeringAngle, speedRotatingPart.minYRot, speedRotatingPart.maxYRot)

                                            local steeringAngleSent = math.floor((speedRotatingPart.steeringAngle % ( math.pi * 2 )) / ( math.pi * 2 ) * 511 )
                                            if steeringAngleSent ~ = speedRotatingPart.steeringAngleSent then
                                                speedRotatingPart.steeringAngleSent = steeringAngleSent
                                                self:raiseDirtyFlags(spec.dirtyFlag)
                                            end
                                        end
                                    end
                                else
                                        if speedRotatingPart.componentNode ~ = nil and speedRotatingPart.dirRefNode ~ = nil and not speedRotatingPart.alignDirection then
                                            speedRotatingPart.steeringAngle = Utils.getYRotationBetweenNodes(speedRotatingPart.componentNode, speedRotatingPart.dirRefNode)
                                            local _,yTrans,_ = localToLocal(speedRotatingPart.driveNode, speedRotatingPart.wheels[ 1 ].driveNode, 0 , 0 , 0 )
                                            setTranslation(speedRotatingPart.driveNode, 0 , yTrans, 0 )
                                        end

                                        if speedRotatingPart.dirRefNode ~ = nil and speedRotatingPart.alignDirection then
                                            local upX, upY, upZ = localDirectionToWorld(speedRotatingPart.dirFrameNode, 0 , 1 , 0 )
                                            local dirX, dirY, dirZ = localDirectionToWorld(speedRotatingPart.dirRefNode, 0 , 0 , 1 )
                                            I3DUtil.setWorldDirection(speedRotatingPart.repr, dirX, dirY, dirZ, upX, upY, upZ, 2 )
                                            if speedRotatingPart.wheels ~ = nil and speedRotatingPart.useWheelReprTranslation then
                                                local _,yTrans,_ = localToLocal(speedRotatingPart.wheels[ 1 ].driveNode, getParent(speedRotatingPart.repr), 0 , 0 , 0 )
                                                setTranslation(speedRotatingPart.repr, 0 , yTrans, 0 )
                                            end
                                        end
                                    end

                                    if speedRotatingPart.driveNode ~ = nil then
                                        if speedRotatingPart.repr = = speedRotatingPart.driveNode then
                                            local steeringAngle = speedRotatingPart.steeringAngle
                                            if not speedRotatingPart.applySteeringAngle then
                                                steeringAngle = 0
                                            end

                                            setRotation(speedRotatingPart.repr, speedRotatingPart.xDrive, steeringAngle, 0 )

                                            for _, repr in ipairs(speedRotatingPart.reprNodes) do
                                                setRotation(repr, speedRotatingPart.xDrive, steeringAngle, 0 )
                                            end
                                        else
                                                if not speedRotatingPart.alignDirection and(speedRotatingPart.versatileYRot or speedRotatingPart.applySteeringAngle) then
                                                    setRotation(speedRotatingPart.repr, 0 , speedRotatingPart.steeringAngle, 0 )

                                                    for _, repr in ipairs(speedRotatingPart.reprNodes) do
                                                        setRotation(repr, 0 , speedRotatingPart.steeringAngle, 0 )
                                                    end
                                                end
                                                setRotation(speedRotatingPart.driveNode, speedRotatingPart.xDrive, 0 , 0 )
                                            end
                                        end

                                        if speedRotatingPart.shaderNode ~ = nil then
                                            if speedRotatingPart.useShaderRotation then
                                                local values = speedRotatingPart.shaderParameterValues

                                                if speedRotatingPart.shaderComponentSpeeds ~ = nil then
                                                    for index, speedScale in ipairs(speedRotatingPart.shaderComponentSpeeds) do
                                                        if speedRotatingPart.scrollLength ~ = nil then
                                                            values[index] = (speedRotatingPart.xDrive * speedRotatingPart.shaderParameterSpeedScale * speedScale) % speedRotatingPart.scrollLength
                                                        else
                                                                values[index] = (speedRotatingPart.xDrive * speedRotatingPart.shaderParameterSpeedScale * speedScale)
                                                            end
                                                        end
                                                    else
                                                            if speedRotatingPart.scrollLength ~ = nil then
                                                                values[speedRotatingPart.shaderParameterComponent] = (speedRotatingPart.xDrive * speedRotatingPart.shaderParameterSpeedScale) % speedRotatingPart.scrollLength
                                                            else
                                                                    values[speedRotatingPart.shaderParameterComponent] = (speedRotatingPart.xDrive * speedRotatingPart.shaderParameterSpeedScale)
                                                                end
                                                            end

                                                            if speedRotatingPart.shaderParameterPrevName ~ = nil then
                                                                g_animationManager:setPrevShaderParameter(speedRotatingPart.shaderNode, speedRotatingPart.shaderParameterName, values[ 1 ], values[ 2 ], values[ 3 ], values[ 4 ], false , speedRotatingPart.shaderParameterPrevName)
                                                            else
                                                                    setShaderParameter(speedRotatingPart.shaderNode, speedRotatingPart.shaderParameterName, values[ 1 ], values[ 2 ], values[ 3 ], values[ 4 ], false )
                                                                end
                                                            else
                                                                    local pos = (speedRotatingPart.xDrive % math.pi) / ( 2 * math.pi) -- normalize rotation
                                                                    setShaderParameter(speedRotatingPart.shaderNode, "offsetUV" , pos * speedRotatingPart.scrollScale[ 1 ], pos * speedRotatingPart.scrollScale[ 2 ], 0 , 0 , false )
                                                                end
                                                            end
                                                        end

```

### validateWashableNode

**Description**

**Definition**

> validateWashableNode()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function SpeedRotatingParts:validateWashableNode(superFunc, node)
    local spec = self.spec_speedRotatingParts
    for _, speedRotatingPart in pairs(spec.speedRotatingParts) do
        if speedRotatingPart.wheels ~ = nil then
            local speedRotatingPartsNodes = { }

            if speedRotatingPart.repr ~ = nil then
                I3DUtil.getNodesByShaderParam(speedRotatingPart.repr, "scratches_dirt_snow_wetness" , speedRotatingPartsNodes)
            end

            for _, repr in ipairs(speedRotatingPart.reprNodes) do
                I3DUtil.getNodesByShaderParam(repr, "scratches_dirt_snow_wetness" , speedRotatingPartsNodes)
            end

            if speedRotatingPart.shaderNode ~ = nil then
                I3DUtil.getNodesByShaderParam(speedRotatingPart.shaderNode, "scratches_dirt_snow_wetness" , speedRotatingPartsNodes)
            end

            if speedRotatingPart.driveNode ~ = nil then
                I3DUtil.getNodesByShaderParam(speedRotatingPart.driveNode, "scratches_dirt_snow_wetness" , speedRotatingPartsNodes)
            end

            if speedRotatingPartsNodes[node] ~ = nil then
                local nodeData = { }
                nodeData.wheel = speedRotatingPart.wheels[ 1 ]
                nodeData.fieldDirtMultiplier = nodeData.wheel.physics.fieldDirtMultiplier
                nodeData.streetDirtMultiplier = nodeData.wheel.physics.streetDirtMultiplier
                nodeData.waterWetnessFactor = nodeData.wheel.physics.waterWetnessFactor
                nodeData.minDirtPercentage = nodeData.wheel.physics.minDirtPercentage
                nodeData.maxDirtOffset = nodeData.wheel.physics.maxDirtOffset
                nodeData.dirtColorChangeSpeed = nodeData.wheel.physics.dirtColorChangeSpeed
                nodeData.isSnowNode = true

                return false , self.updateWheelDirtAmount, nodeData.wheel, nodeData
            end
        end
    end

    return superFunc( self , node)
end

```