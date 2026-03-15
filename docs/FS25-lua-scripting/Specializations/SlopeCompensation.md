## SlopeCompensation

**Description**

> Specialization for automatic slope compensation in vehicles based on the angle between two wheel nodes or a reference
> node angle (world space)

**Functions**

- [getSlopeCompensationAngle](#getslopecompensationangle)
- [getSlopeCompensationAngleScale](#getslopecompensationanglescale)
- [initSpecialization](#initspecialization)
- [loadSlopeCompensationNodeFromXML](#loadslopecompensationnodefromxml)
- [loadSlopeCompensationWheels](#loadslopecompensationwheels)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onRegisterAnimationValueTypes](#onregisteranimationvaluetypes)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setSlopeCompensationNodeAngle](#setslopecompensationnodeangle)
- [updateDebugValues](#updatedebugvalues)

### getSlopeCompensationAngle

**Description**

**Definition**

> getSlopeCompensationAngle()

**Arguments**

| any | compensationNode |
|-----|------------------|

**Code**

```lua
function SlopeCompensation:getSlopeCompensationAngle(compensationNode)
    return compensationNode.detectedAngle
end

```

### getSlopeCompensationAngleScale

**Description**

**Definition**

> getSlopeCompensationAngleScale()

**Arguments**

| any | compensationNode |
|-----|------------------|

**Code**

```lua
function SlopeCompensation:getSlopeCompensationAngleScale(compensationNode)
    return 1
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function SlopeCompensation.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "slopeCompensation" , g_i18n:getText( "shop_configuration" ), "slopeCompensation" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "SlopeCompensation" )

    SlopeCompensation.registerXMLPaths(schema, "vehicle.slopeCompensation" )
    SlopeCompensation.registerXMLPaths(schema, "vehicle.slopeCompensation.slopeCompensationConfigurations.slopeCompensationConfiguration(?)" )

    schema:addDelayedRegistrationFunc( "AnimatedVehicle:part" , function (cSchema, cKey)
        cSchema:register(XMLValueType.INT, cKey .. "#slopeCompensationNodeIndex" , "Index in the XML of the slope compensation node" )
        cSchema:register(XMLValueType.FLOAT, cKey .. "#startSlopeCompensationLevel" , "Start slope compensation level" )
        cSchema:register(XMLValueType.FLOAT, cKey .. "#endSlopeCompensationLevel" , "End slope compensation level" )
    end )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.ANGLE, "vehicles.vehicle(?).slopeCompensation.compensationNode(?)#lastAngle" , "Last angle of compensation node" )
end

```

### loadSlopeCompensationNodeFromXML

**Description**

**Definition**

> loadSlopeCompensationNodeFromXML()

**Arguments**

| any | compensationNode |
|-----|------------------|
| any | xmlFile          |
| any | key              |

**Code**

```lua
function SlopeCompensation:loadSlopeCompensationNodeFromXML(compensationNode, xmlFile, key)
    compensationNode.useWheelReference = false
    compensationNode.raycastDistance = 0
    compensationNode.lastDistance1 = 0
    compensationNode.lastDistance2 = 0

    local success1, wheelNodes1, maxRadius1 = self:loadSlopeCompensationWheels(xmlFile, key, "wheel1" , "wheelNode1" , "wheelNodes1" )
    local success2, wheelNodes2, maxRadius2 = self:loadSlopeCompensationWheels(xmlFile, key, "wheel2" , "wheelNode2" , "wheelNodes2" )
    if success1 and success2 then
        compensationNode.wheelNodes1 = wheelNodes1
        compensationNode.wheelNodes2 = wheelNodes2

        compensationNode.hitPosition1 = { 0 , 0 , 0 }
        compensationNode.hitPosition1Valid = false

        compensationNode.detectionCallback1 = function (_, hitObjectId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast)
            if hitObjectId ~ = 0 then
                if getRigidBodyType(hitObjectId) ~ = RigidBodyType.STATIC then
                    return true
                end

                compensationNode.hitPosition1[ 1 ], compensationNode.hitPosition1[ 2 ], compensationNode.hitPosition1[ 3 ] = x, y, z
                compensationNode.hitPosition1Valid = true
            end

            return false
        end

        compensationNode.detectionCallback2 = function (_, hitObjectId, x2, y2, z2, distance, nx, ny, nz, subShapeIndex, shapeId, isLast)
            if hitObjectId ~ = 0 then
                if getRigidBodyType(hitObjectId) ~ = RigidBodyType.STATIC then
                    return true
                end

                if compensationNode.hitPosition1Valid then
                    local x1, y1, z1 = compensationNode.hitPosition1[ 1 ], compensationNode.hitPosition1[ 2 ], compensationNode.hitPosition1[ 3 ]
                    local h = y1 - y2
                    local l = MathUtil.vector2Length(x1 - x2, z1 - z2)

                    if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
                        drawDebugLine(x1, y1, z1, 1 , 1 , 0 , x2, y2, z2, 1 , 1 , 0 , false )
                        Utils.renderTextAtWorldPosition((x1 + x2) * 0.5 , (y1 + y2) * 0.5 , (z1 + z2) * 0.5 , string.format( "Angle: %.2f°" , math.deg( math.tan(h / l))), 0.01 )
                    end

                    compensationNode.detectedAngle = math.tan(h / l)
                    return false
                end
            end

            if isLast then
                compensationNode.detectedAngle = 0
            end

            return false
        end

        compensationNode.raycastDistance = math.max(maxRadius1 + 1 , maxRadius2 + 1 )
        compensationNode.useWheelReference = true
    end

    compensationNode.referenceNode = self.xmlFile:getValue(key .. "#referenceNode" , nil , self.components, self.i3dMappings)
    compensationNode.referenceAxis = self.xmlFile:getValue(key .. "#referenceAxis" , 1 )

    compensationNode.rotationNode = self.xmlFile:getValue(key .. "#rotationNode" , nil , self.components, self.i3dMappings)
    compensationNode.rotationAxis = self.xmlFile:getValue(key .. "#rotationAxis" , 1 )
    if compensationNode.rotationNode ~ = nil then
        compensationNode.rotationNodeRotation = { getRotation(compensationNode.rotationNode) }
    end

    compensationNode.maxAngle = self.xmlFile:getValue(key .. "#maxAngle" , 5 )
    compensationNode.minAngle = self.xmlFile:getValue(key .. "#minAngle" , - math.deg(compensationNode.maxAngle))

    compensationNode.speed = self.xmlFile:getValue(key .. "#speed" , 5 ) / 1000
    compensationNode.inverted = self.xmlFile:getValue(key .. "#inverted" , false )

    if compensationNode.minAngle > compensationNode.maxAngle then
        compensationNode.minAngle, compensationNode.maxAngle = compensationNode.maxAngle, compensationNode.minAngle
        compensationNode.inverted = true
    end

    compensationNode.targetAngle = 0
    compensationNode.lastAngle = 0
    compensationNode.detectedAngle = 0

    compensationNode.animationName = self.xmlFile:getValue(key .. "#animationName" )

    compensationNode.inActiveHeight = xmlFile:getValue(key .. "#inActiveHeight" , 0 )
    compensationNode.initialHeightOffset = 1 - math.clamp(xmlFile:getValue(key .. "#initialHeight" , 1 ), 0 , 1 )

    compensationNode.compensationLevel = 1

    compensationNode.animationParts = { }
    for _, partKey in xmlFile:iterator(key .. ".animationPart" ) do
        local animationPart = { }
        animationPart.node = xmlFile:getValue(partKey .. "#node" , nil , self.components, self.i3dMappings)
        if animationPart.node ~ = nil then
            animationPart.isLeft = xmlFile:getValue(partKey .. "#isLeft" , false )

            animationPart.rotMin = xmlFile:getValue(partKey .. "#rotMin" , nil , true )
            animationPart.rotMax = xmlFile:getValue(partKey .. "#rotMax" , nil , true )

            animationPart.transMin = xmlFile:getValue(partKey .. "#transMin" , nil , true )
            animationPart.transMax = xmlFile:getValue(partKey .. "#transMax" , nil , true )

            if (animationPart.rotMin ~ = nil and animationPart.rotMax ~ = nil )
                or(animationPart.transMin ~ = nil and animationPart.transMax ~ = nil ) then
                animationPart.lastAlpha = - 1

                table.insert(compensationNode.animationParts, animationPart)
            else
                    Logging.xmlWarning(xmlFile, "Failed to load slope compensation animation part '%s'.Missing values." , partKey)
                end
            else
                    Logging.xmlWarning(xmlFile, "Failed to load slope compensation animation part '%s'.Missing node." , partKey)
                end
            end

            return true
        end

```

### loadSlopeCompensationWheels

**Description**

**Definition**

> loadSlopeCompensationWheels()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | key       |
| any | indexName |
| any | nodeName  |
| any | nodesName |

**Code**

```lua
function SlopeCompensation:loadSlopeCompensationWheels(xmlFile, key, indexName, nodeName, nodesName)
    local maxRadius = 0
    local wheelNodes = { }

    local wheelIndex = self.xmlFile:getValue(key .. "#" .. indexName)
    if wheelIndex ~ = nil then
        local wheel = self:getWheelFromWheelIndex(wheelIndex)
        if wheel ~ = nil then
            maxRadius = math.max(maxRadius, wheel.physics.radius)
            table.insert(wheelNodes, wheel.driveNode)
        else
                Logging.xmlWarning( self.xmlFile, "Unable to find wheel index '%d' for compensation node '%s'" , wheelIndex, key)
                    return false
                end
            end

            local wheelNode = self.xmlFile:getValue(key .. "#" .. nodeName, nil , self.components, self.i3dMappings)
            if wheelNode ~ = nil then
                local wheel = self:getWheelByWheelNode(wheelNode)
                if wheel ~ = nil then
                    maxRadius = math.max(maxRadius, wheel.physics.radius)
                    table.insert(wheelNodes, wheel.driveNode)
                else
                        Logging.xmlWarning( self.xmlFile, "Unable to find wheel for node '%s' for compensation node '%s'" , getName(wheelNode), key)
                            return false
                        end
                    end

                    local nodes = self.xmlFile:getValue(key .. "#" .. nodesName, nil , self.components, self.i3dMappings, true )
                    if nodes ~ = nil then
                        for _, node in ipairs(nodes) do
                            local wheel = self:getWheelByWheelNode(node)
                            if wheel ~ = nil then
                                maxRadius = math.max(maxRadius, wheel.physics.radius)
                                table.insert(wheelNodes, wheel.driveNode)
                            else
                                    Logging.xmlWarning( self.xmlFile, "Unable to find wheel for node '%s' for compensation node '%s'" , getName(node), key)
                                        return false
                                    end
                                end
                            end

                            if #wheelNodes = = 0 then
                                return false
                            end

                            return true , wheelNodes, maxRadius
                        end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function SlopeCompensation:onLoad(savegame)
    local spec = self.spec_slopeCompensation

    spec.threshold = self.xmlFile:getValue( "vehicle.slopeCompensation#threshold" , 0.002 )
    spec.highUpdateFrequency = self.xmlFile:getValue( "vehicle.slopeCompensation#highUpdateFrequency" , false )

    spec.lastRaycastDistance = 0
    spec.compensationNodes = { }
    for _, key in self.xmlFile:iterator( "vehicle.slopeCompensation.compensationNode" ) do
        local compensationNode = { }
        if self:loadSlopeCompensationNodeFromXML(compensationNode, self.xmlFile, key) then
            table.insert(spec.compensationNodes, compensationNode)
        end
    end

    local configurationId = self.configurations[ "slopeCompensation" ] or 1
    local configKey = string.format( "vehicle.slopeCompensation.slopeCompensationConfigurations.slopeCompensationConfiguration(%d)" , configurationId - 1 )

    if self.xmlFile:hasProperty(configKey) then
        for _, key in self.xmlFile:iterator(configKey .. ".compensationNode" ) do
            local compensationNode = { }
            if self:loadSlopeCompensationNodeFromXML(compensationNode, self.xmlFile, key) then
                table.insert(spec.compensationNodes, compensationNode)
            end
        end

        spec.threshold = self.xmlFile:getValue(configKey .. "#threshold" , spec.threshold)
        spec.highUpdateFrequency = self.xmlFile:getValue(configKey .. "#highUpdateFrequency" , spec.highUpdateFrequency)
    end

    if #spec.compensationNodes = = 0 then
        SpecializationUtil.removeEventListener( self , "onLoadFinished" , SlopeCompensation )
        SpecializationUtil.removeEventListener( self , "onUpdate" , SlopeCompensation )
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , SlopeCompensation )
    else
            if spec.highUpdateFrequency then
                SpecializationUtil.removeEventListener( self , "onUpdateTick" , SlopeCompensation )
            else
                    SpecializationUtil.removeEventListener( self , "onUpdate" , SlopeCompensation )
                end
            end
        end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function SlopeCompensation:onLoadFinished(savegame)
    local spec = self.spec_slopeCompensation

    for _, compensationNode in ipairs(spec.compensationNodes) do
        if compensationNode.animationName ~ = nil then
            local updateAnimation = self:getSlopeCompensationAngleScale(compensationNode) > 0
            self:setAnimationTime(compensationNode.animationName, 0 , updateAnimation)
            self:setAnimationTime(compensationNode.animationName, 1 , updateAnimation)
            self:setAnimationTime(compensationNode.animationName, 0.5 , updateAnimation)
        end
    end

    if savegame ~ = nil then
        for j, compensationNode in ipairs(spec.compensationNodes) do
            local lastAngle = savegame.xmlFile:getValue( string.format( "%s.slopeCompensation.compensationNode(%d)#lastAngle" , savegame.key, j - 1 ), 0 )
            self:setSlopeCompensationNodeAngle(compensationNode, lastAngle)
        end
    else
            for j, compensationNode in ipairs(spec.compensationNodes) do
                self:setSlopeCompensationNodeAngle(compensationNode, 0 )
            end
        end
    end

```

### onRegisterAnimationValueTypes

**Description**

> Called on pre load to register animation value types

**Definition**

> onRegisterAnimationValueTypes()

**Code**

```lua
function SlopeCompensation:onRegisterAnimationValueTypes()
    self:registerAnimationValueType( "slopeCompensationLevel" , "startSlopeCompensationLevel" , "endSlopeCompensationLevel" , false , AnimationValueFloat ,
    function (value, xmlFile, xmlKey)
        value.slopeCompensationNodeIndex = xmlFile:getValue(xmlKey .. "#slopeCompensationNodeIndex" )
        if value.slopeCompensationNodeIndex ~ = nil then
            value:setWarningInformation( "index: " .. tostring(value.slopeCompensationNodeIndex))
            value:addCompareParameters( "slopeCompensationNodeIndex" )

            return true
        end

        return false
    end ,

    function (value)
        if value.slopeCompensationNode = = nil then
            local spec = value.vehicle.spec_slopeCompensation
            local slopeCompensationNode = spec.compensationNodes[value.slopeCompensationNodeIndex]
            if slopeCompensationNode = = nil then
                Logging.xmlWarning(value.xmlFile, "Could not update slope compensation node level.No slope compensation node with index %d found!" , value.slopeCompensationNodeIndex)
                value.startValue = nil
                return 0
            end

            value.slopeCompensationNode = slopeCompensationNode
        end

        return value.slopeCompensationNode.compensationLevel
    end ,

    function (value, compensationLevel)
        if value.slopeCompensationNode ~ = nil then
            value.slopeCompensationNode.compensationLevel = compensationLevel

            self:setSlopeCompensationNodeAngle(value.slopeCompensationNode, value.slopeCompensationNode.lastAngle)
        end
    end )
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
function SlopeCompensation:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_slopeCompensation

    for _, compensationNode in ipairs(spec.compensationNodes) do
        local angle = math.clamp(compensationNode.detectedAngle, compensationNode.minAngle, compensationNode.maxAngle) * self:getSlopeCompensationAngleScale(compensationNode)
        if compensationNode.inverted then
            angle = - angle
        end

        local difference = math.abs(compensationNode.targetAngle - angle)
        if difference > spec.threshold then
            compensationNode.targetAngle = angle
        end

        local dir = math.sign(compensationNode.targetAngle - compensationNode.lastAngle)
        local limit = dir > 0 and math.min or math.max

        local speedScale = math.min( math.max( math.abs(compensationNode.lastAngle - angle) / (compensationNode.speed * 1000 ), 0.2 ), 1 )
        local newAngle = limit(compensationNode.lastAngle + compensationNode.speed * dt * dir * speedScale, compensationNode.targetAngle)
        if newAngle ~ = compensationNode.lastAngle then
            self:setSlopeCompensationNodeAngle(compensationNode, newAngle)
        end

        self:updateSlopeCompensationAngle(compensationNode)
    end
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function SlopeCompensation:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    SlopeCompensation.onUpdate( self , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
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
function SlopeCompensation.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Wheels , specializations)
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
function SlopeCompensation.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , SlopeCompensation )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , SlopeCompensation )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , SlopeCompensation )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , SlopeCompensation )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterAnimationValueTypes" , SlopeCompensation )
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
function SlopeCompensation.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadSlopeCompensationWheels" , SlopeCompensation.loadSlopeCompensationWheels)
    SpecializationUtil.registerFunction(vehicleType, "loadSlopeCompensationNodeFromXML" , SlopeCompensation.loadSlopeCompensationNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getSlopeCompensationAngle" , SlopeCompensation.getSlopeCompensationAngle)
    SpecializationUtil.registerFunction(vehicleType, "getSlopeCompensationAngleScale" , SlopeCompensation.getSlopeCompensationAngleScale)
    SpecializationUtil.registerFunction(vehicleType, "updateSlopeCompensationAngle" , SlopeCompensation.updateSlopeCompensationAngle)
    SpecializationUtil.registerFunction(vehicleType, "setSlopeCompensationNodeAngle" , SlopeCompensation.setSlopeCompensationNodeAngle)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function SlopeCompensation.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.ANGLE, basePath .. "#threshold" , "Update threshold for animation" , 0.1 )
        schema:register(XMLValueType.BOOL, basePath .. "#highUpdateFrequency" , "Defines if the angle is updated every frame or every seconds frame" , false )

            local compensationNodePath = basePath .. ".compensationNode(?)"

            schema:addDelayedRegistrationPath(compensationNodePath, "SlopeCompensation:compensationNode" )

            schema:register(XMLValueType.INT, compensationNodePath .. "#wheel1" , "Wheel index 1" )
            schema:register(XMLValueType.INT, compensationNodePath .. "#wheel2" , "Wheel index 2" )
            schema:register(XMLValueType.NODE_INDEX, compensationNodePath .. "#wheelNode1" , "Wheel node 1" )
            schema:register(XMLValueType.NODE_INDEX, compensationNodePath .. "#wheelNode2" , "Wheel node 2" )
            schema:register(XMLValueType.NODE_INDICES, compensationNodePath .. "#wheelNodes1" , "List of wheel nodes 1(center of all nodes will be used for detection)" )
                schema:register(XMLValueType.NODE_INDICES, compensationNodePath .. "#wheelNodes2" , "List of wheel nodes 2(center of all nodes will be used for detection)" )

                    schema:register(XMLValueType.ANGLE, compensationNodePath .. "#maxAngle" , "Max.angle" , 5 )
                    schema:register(XMLValueType.ANGLE, compensationNodePath .. "#minAngle" , "Min.angle" , "Negative #maxAngle" )
                    schema:register(XMLValueType.ANGLE, compensationNodePath .. "#speed" , "Move speed(degree/sec)" , 5 )
                    schema:register(XMLValueType.BOOL, compensationNodePath .. "#inverted" , "Inverted rotation" , false )
                    schema:register(XMLValueType.FLOAT, compensationNodePath .. "#inActiveHeight" , "Height while the compensation node is not active" , 0 )
                        schema:register(XMLValueType.FLOAT, compensationNodePath .. "#initialHeight" , "Height while the componensation node is active and the vehicle is fully leveled" , 1 )

                            schema:register(XMLValueType.STRING, compensationNodePath .. "#animationName" , "Animation name" )

                            schema:register(XMLValueType.NODE_INDEX, compensationNodePath .. "#referenceNode" , "Node that is used to detect the current angle" )
                            schema:register(XMLValueType.INT, compensationNodePath .. "#referenceAxis" , "Reference angle detection axis" , 1 )

                            schema:register(XMLValueType.NODE_INDEX, compensationNodePath .. "#rotationNode" , "Node that is rotated based on the slope angle" )
                            schema:register(XMLValueType.INT, compensationNodePath .. "#rotationAxis" , "Rotation axis on which the rotationNode is rotated" , 1 )

                            schema:register(XMLValueType.NODE_INDEX, compensationNodePath .. ".animationPart(?)#node" , "Node that is adjusted" )
                            schema:register(XMLValueType.BOOL, compensationNodePath .. ".animationPart(?)#isLeft" , "Is left or right side node" )
                            schema:register(XMLValueType.VECTOR_ROT, compensationNodePath .. ".animationPart(?)#rotMin" , "Min.rotation" )
                            schema:register(XMLValueType.VECTOR_ROT, compensationNodePath .. ".animationPart(?)#rotMax" , "Max.rotation" )
                            schema:register(XMLValueType.VECTOR_TRANS, compensationNodePath .. ".animationPart(?)#transMin" , "Min.translation" )
                            schema:register(XMLValueType.VECTOR_TRANS, compensationNodePath .. ".animationPart(?)#transMax" , "Max.translation" )
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
function SlopeCompensation:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_slopeCompensation
    for i, compensationNode in ipairs(spec.compensationNodes) do
        xmlFile:setValue( string.format( "%s.compensationNode(%d)#lastAngle" , key, i - 1 ), compensationNode.lastAngle)
    end
end

```

### setSlopeCompensationNodeAngle

**Description**

**Definition**

> setSlopeCompensationNodeAngle()

**Arguments**

| any | compensationNode |
|-----|------------------|
| any | angle            |

**Code**

```lua
function SlopeCompensation:setSlopeCompensationNodeAngle(compensationNode, angle)
    local position = (angle - compensationNode.minAngle) / (compensationNode.maxAngle - compensationNode.minAngle)

    if compensationNode.animationName ~ = nil then
        if self.setAnimationTime ~ = nil then
            local currentTime = self:getAnimationTime(compensationNode.animationName)
            self:setAnimationStopTime(compensationNode.animationName, position)
            self:playAnimation(compensationNode.animationName, math.sign(position - currentTime), currentTime, true )
            AnimatedVehicle.updateAnimationByName( self , compensationNode.animationName, 9999999 , true )
        end
    end

    if compensationNode.rotationNode ~ = nil then
        compensationNode.rotationNodeRotation[ 1 ], compensationNode.rotationNodeRotation[ 2 ], compensationNode.rotationNodeRotation[ 3 ] = getRotation(compensationNode.rotationNode)
        compensationNode.rotationNodeRotation[compensationNode.rotationAxis] = angle
        setRotation(compensationNode.rotationNode, compensationNode.rotationNodeRotation[ 1 ], compensationNode.rotationNodeRotation[ 2 ], compensationNode.rotationNodeRotation[ 3 ])

        if self.setMovingToolDirty ~ = nil then
            self:setMovingToolDirty(compensationNode.rotationNode)
        end
    end

    for _, animationPart in ipairs(compensationNode.animationParts) do
        local alpha
        if animationPart.isLeft then
            alpha = 1 - math.clamp((position - 0.5 ) / 0.5 + compensationNode.initialHeightOffset, 0 , 1 )
        else
                alpha = math.clamp(position / 0.5 - compensationNode.initialHeightOffset, 0 , 1 )
            end

            alpha = MathUtil.lerp(compensationNode.inActiveHeight, alpha, compensationNode.compensationLevel)

            animationPart.lastAlpha = alpha

            if animationPart.rotMin ~ = nil then
                local x, y, z = MathUtil.vector3ArrayLerp(animationPart.rotMin, animationPart.rotMax, alpha)
                setRotation(animationPart.node, x, y, z)

                if self.setMovingToolDirty ~ = nil then
                    self:setMovingToolDirty(animationPart.node)
                end
            end

            if animationPart.transMin ~ = nil then
                local x, y, z = MathUtil.vector3ArrayLerp(animationPart.transMin, animationPart.transMax, alpha)
                setTranslation(animationPart.node, x, y, z)

                if self.setMovingToolDirty ~ = nil then
                    self:setMovingToolDirty(animationPart.node)
                end
            end
        end

        compensationNode.lastAngle = angle
    end

```

### updateDebugValues

**Description**

**Definition**

> updateDebugValues()

**Arguments**

| any | values |
|-----|--------|

**Code**

```lua
function SlopeCompensation:updateDebugValues(values)
    local spec = self.spec_slopeCompensation

    for i, compensationNode in ipairs(spec.compensationNodes) do
        local angle = math.clamp(compensationNode.detectedAngle, compensationNode.minAngle, compensationNode.maxAngle)
        if compensationNode.inverted then
            angle = - angle
        end

        table.insert(values, { name = string.format( "compNode %d" , i), value = string.format( "%.2f°" , math.deg(angle)) } )
    end

end

```