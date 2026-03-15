## GroundAdjustedNodes

**Description**

> Specialization for adjusting nodes to the ground/terrain height (e.g. liquid manure spreaders with hoses)

**Functions**

- [getIsGroundAdjustedNodeActive](#getisgroundadjustednodeactive)
- [initGroundAdjustedAdjustNode](#initgroundadjustedadjustnode)
- [initSpecialization](#initspecialization)
- [loadGroundAdjustedAdjustNodeFromXML](#loadgroundadjustedadjustnodefromxml)
- [loadGroundAdjustedNodeFromXML](#loadgroundadjustednodefromxml)
- [loadGroundAdjustedRaycastNodeFromXML](#loadgroundadjustedraycastnodefromxml)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onRegisterAnimationValueTypes](#onregisteranimationvaluetypes)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerAdjustNodeXMLPaths](#registeradjustnodexmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerNodeXMLPaths](#registernodexmlpaths)
- [updateGroundAdjustedNode](#updategroundadjustednode)
- [updateGroundAdjustedRaycasts](#updategroundadjustedraycasts)

### getIsGroundAdjustedNodeActive

**Description**

**Definition**

> getIsGroundAdjustedNodeActive()

**Arguments**

| any | groundAdjustedNode |
|-----|--------------------|
| any | ignoreAttachState  |

**Code**

```lua
function GroundAdjustedNodes:getIsGroundAdjustedNodeActive(groundAdjustedNode, ignoreAttachState)
    local spec = self.spec_groundAdjustedNodes
    return not spec.onlyActiveWhileAttached or( self.getAttacherVehicle = = nil or self:getAttacherVehicle() ~ = nil ) or ignoreAttachState
end

```

### initGroundAdjustedAdjustNode

**Description**

**Definition**

> initGroundAdjustedAdjustNode()

**Arguments**

| any | groundAdjustedNode |
|-----|--------------------|
| any | adjustNode         |

**Code**

```lua
function GroundAdjustedNodes:initGroundAdjustedAdjustNode(groundAdjustedNode, adjustNode)
    if #groundAdjustedNode.raycastNodes = = 2 then
        local x1, _, z1 = localToLocal(adjustNode.node, getParent(groundAdjustedNode.raycastNodes[ 1 ].node), 0 , 0 , 0 )
        local x2, _, z2 = localToLocal(groundAdjustedNode.raycastNodes[ 1 ].node, getParent(groundAdjustedNode.raycastNodes[ 1 ].node), 0 , 0 , 0 )
        local x3, _, z3 = localToLocal(groundAdjustedNode.raycastNodes[ 2 ].node, getParent(groundAdjustedNode.raycastNodes[ 1 ].node), 0 , 0 , 0 )
        local dirX, dirZ = x3 - x2, z3 - z2
        local length = MathUtil.vector2Length(x3 - x2, z3 - z2)
        dirX, dirZ = MathUtil.vector2Normalize(dirX, dirZ)

        adjustNode.alpha = MathUtil.getProjectOnLineParameter(x1, z1, x2, z2, dirX, dirZ) / length
    end
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function GroundAdjustedNodes.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "groundAdjustedNode" , g_i18n:getText( "shop_configuration" ), "groundAdjustedNodes" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "GroundAdjustedNodes" )

    schema:register(XMLValueType.FLOAT, "vehicle.groundAdjustedNodes#maxUpdateDistance" , "If the player is more than this distance away the nodes will no longer be updated" , 100 )
    schema:register(XMLValueType.FLOAT, "vehicle.groundAdjustedNodes#maxUpdateDistanceWobble" , "If the player is more than this distance away the wobble effect which is applied on the field will not be shown anymore" , 50 )
    schema:register(XMLValueType.BOOL, "vehicle.groundAdjustedNodes#adjustToWater" , "If 'true', the adjust node will be placed on top of any water plane" , false )
    schema:register(XMLValueType.BOOL, "vehicle.groundAdjustedNodes#onlyActiveWhileAttached" , "Defines if the tool needs to be attached to have the ground adjusted nodes active" , true )

        GroundAdjustedNodes.registerNodeXMLPaths(schema, "vehicle.groundAdjustedNodes.groundAdjustedNode(?)" )
        GroundAdjustedNodes.registerNodeXMLPaths(schema, "vehicle.groundAdjustedNodes.groundAdjustedNodeConfigurations.groundAdjustedNodeConfiguration(?).groundAdjustedNode(?)" )

        schema:addDelayedRegistrationFunc( "AnimatedVehicle:part" , function (cSchema, cKey)
            cSchema:register(XMLValueType.FLOAT, cKey .. "#startGroundAdjustScale" , "Start scale of ground adjusted node(blending between detected ground and inactive position)" )
            cSchema:register(XMLValueType.FLOAT, cKey .. "#endGroundAdjustScale" , "Start scale of ground adjusted node(blending between detected ground and inactive position)" )
        end )

        schema:setXMLSpecializationType()
    end

```

### loadGroundAdjustedAdjustNodeFromXML

**Description**

**Definition**

> loadGroundAdjustedAdjustNodeFromXML()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | key                |
| any | groundAdjustedNode |
| any | adjustNode         |
| any | required           |

**Code**

```lua
function GroundAdjustedNodes:loadGroundAdjustedAdjustNodeFromXML(xmlFile, key, groundAdjustedNode, adjustNode, required)
    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node = = nil then
        if required = = true then
            Logging.xmlWarning(xmlFile, "Missing 'node' for groundAdjustedNode '%s'!" , key)
            end

            return false
        end

        local x, y, z = getTranslation(node)
        adjustNode.node = node
        adjustNode.x = x
        adjustNode.y = y
        adjustNode.z = z

        adjustNode.minY = xmlFile:getValue(key .. "#minY" , y - 1 )
        adjustNode.maxY = xmlFile:getValue(key .. "#maxY" , adjustNode.minY + 1 )
        adjustNode.moveSpeed = xmlFile:getValue(key .. "#moveSpeed" , 1 ) / 1000
        adjustNode.moveSpeedStateChange = (xmlFile:getValue(key .. "#moveSpeedStateChange" , adjustNode.moveSpeed * 1000 )) / 1000
        adjustNode.resetIfNotActive = xmlFile:getValue(key .. "#resetIfNotActive" , true )
        adjustNode.updateThreshold = xmlFile:getValue(key .. "#updateThreshold" , 0.002 )

        adjustNode.inActiveY = xmlFile:getValue(key .. "#inActiveY" , y) + xmlFile:getValue(key .. "#inActiveOffsetY" , 0 )
        adjustNode.averageInActivePosY = xmlFile:getValue(key .. "#averageInActivePosY" , false )

        adjustNode.targetY = adjustNode.inActiveY
        adjustNode.curY = adjustNode.inActiveY
        adjustNode.lastY = adjustNode.inActiveY

        adjustNode.lastOffsetDistance = math.random() * 10000

        return true
    end

```

### loadGroundAdjustedNodeFromXML

**Description**

**Definition**

> loadGroundAdjustedNodeFromXML()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | key                |
| any | groundAdjustedNode |

**Code**

```lua
function GroundAdjustedNodes:loadGroundAdjustedNodeFromXML(xmlFile, key, groundAdjustedNode)
    local spec = self.spec_groundAdjustedNodes

    groundAdjustedNode.yOffset = xmlFile:getValue(key .. "#yOffset" )

    groundAdjustedNode.activationTime = xmlFile:getValue(key .. "#activationTime" , 0 ) * 1000
    groundAdjustedNode.activationTimer = 0

    groundAdjustedNode.activeScale = 1 -- interpolation between raycasts target position and inactive position

    groundAdjustedNode.adjustNodes = { }

    -- fallback to still support the old writting style
    local baseAdjustNode = { }
    if self:loadGroundAdjustedAdjustNodeFromXML(xmlFile, key, groundAdjustedNode, baseAdjustNode, false ) then
        table.insert(groundAdjustedNode.adjustNodes, baseAdjustNode)
    end

    xmlFile:iterate(key .. ".adjustNode" , function (index, adjustKey)
        local adjustNode = { }
        if self:loadGroundAdjustedAdjustNodeFromXML(xmlFile, adjustKey, groundAdjustedNode, adjustNode, true ) then
            table.insert(groundAdjustedNode.adjustNodes, adjustNode)
        end
    end )

    groundAdjustedNode.raycastNodes = { }
    xmlFile:iterate(key .. ".raycastNode" , function (index, raycastKey)
        local raycastNode = self:loadGroundAdjustedRaycastNodeFromXML(xmlFile, raycastKey, groundAdjustedNode, { } )
        if raycastNode ~ = nil then
            if #groundAdjustedNode.raycastNodes > 2 then
                Logging.xmlWarning( self.xmlFile, "Max.two raycast nodes are allowed per groundAdjustedNode! (%s)" , key)
                return
            end

            table.insert(groundAdjustedNode.raycastNodes, raycastNode)
            spec.raycastNodesByNode[raycastNode.node] = raycastNode
        end
    end )

    for i = 1 , #groundAdjustedNode.adjustNodes do
        self:initGroundAdjustedAdjustNode(groundAdjustedNode, groundAdjustedNode.adjustNodes[i])
    end

    if #groundAdjustedNode.raycastNodes > 0 and #groundAdjustedNode.adjustNodes > 0 then
        groundAdjustedNode.isActive = false
        return true
    else
            Logging.xmlWarning( self.xmlFile, "No raycastNodes or adjust nodes defined for groundAdjustedNode '%s'!" , key)
                return false
            end
        end

```

### loadGroundAdjustedRaycastNodeFromXML

**Description**

**Definition**

> loadGroundAdjustedRaycastNodeFromXML()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | key                |
| any | groundAdjustedNode |
| any | raycastNode        |

**Code**

```lua
function GroundAdjustedNodes:loadGroundAdjustedRaycastNodeFromXML(xmlFile, key, groundAdjustedNode, raycastNode)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node = = nil then
        Logging.xmlWarning(xmlFile, "Missing 'node' for groundAdjustedNodes raycast '%s'!" , key)
            return nil
        end

        raycastNode.node = node

        raycastNode.maxDistance = xmlFile:getValue(key .. "#distance" , 4 )
        raycastNode.lastRaycastDistance = raycastNode.maxDistance

        raycastNode.yOffset = xmlFile:getValue(key .. "#yOffset" , groundAdjustedNode.yOffset or 0 )

        local spec = self.spec_groundAdjustedNodes
        if spec.raycastNodesByNode[node] ~ = nil then
            local otherRaycastNode = spec.raycastNodesByNode[node]

            if math.abs(raycastNode.yOffset - otherRaycastNode.yOffset) < 0.01
                and math.abs(raycastNode.maxDistance - otherRaycastNode.maxDistance) < 0.01 then
                return spec.raycastNodesByNode[node]
            else
                    Logging.xmlWarning(xmlFile, "Found multiple groundAdjustedNode raycasts with different settings for '%s'!" , getName(node))
                        return nil
                    end
                end

                raycastNode.groundAdjustRaycastCallback = function (_, transformId, x, y, z, distance)
                    if getHasTrigger(transformId) then
                        return true
                    end

                    if transformId ~ = 0 then
                        raycastNode.lastRaycastDistance = distance
                    end

                    return false
                end

                raycastNode.parent = groundAdjustedNode

                return raycastNode
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
function GroundAdjustedNodes:onLoad(savegame)
    local spec = self.spec_groundAdjustedNodes

    local configurationId = self.configurations[ "groundAdjustedNode" ] or 1
    local configKey = string.format( "vehicle.groundAdjustedNodes.groundAdjustedNodeConfigurations.groundAdjustedNodeConfiguration(%d)" , configurationId - 1 )

    spec.raycastNodesByNode = { }

    spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.groundAdjustedNodes#maxUpdateDistance" , 100 )
    spec.maxUpdateDistanceWobble = self.xmlFile:getValue( "vehicle.groundAdjustedNodes#maxUpdateDistanceWobble" , 50 )
    spec.adjustToWater = self.xmlFile:getValue( "vehicle.groundAdjustedNodes#adjustToWater" , false )
    spec.onlyActiveWhileAttached = self.xmlFile:getValue( "vehicle.groundAdjustedNodes#onlyActiveWhileAttached" , true )

    spec.groundAdjustedNodes = { }
    self.xmlFile:iterate( "vehicle.groundAdjustedNodes.groundAdjustedNode" , function (index, key)
        local groundAdjustedNode = { }
        if self:loadGroundAdjustedNodeFromXML( self.xmlFile, key, groundAdjustedNode) then
            table.insert(spec.groundAdjustedNodes, groundAdjustedNode)
        end
    end )

    self.xmlFile:iterate(configKey .. ".groundAdjustedNode" , function (index, key)
        local groundAdjustedNode = { }
        if self:loadGroundAdjustedNodeFromXML( self.xmlFile, key, groundAdjustedNode) then
            table.insert(spec.groundAdjustedNodes, groundAdjustedNode)
        end
    end )

    if #spec.groundAdjustedNodes = = 0 then
        SpecializationUtil.removeEventListener( self , "onLoadFinished" , GroundAdjustedNodes )
        SpecializationUtil.removeEventListener( self , "onUpdate" , GroundAdjustedNodes )
        SpecializationUtil.removeEventListener( self , "onRegisterAnimationValueTypes" , GroundAdjustedNodes )
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
function GroundAdjustedNodes:onLoadFinished(savegame)
    local spec = self.spec_groundAdjustedNodes

    for _, groundAdjustedNode in pairs(spec.groundAdjustedNodes) do
        groundAdjustedNode.isActive = self:getIsGroundAdjustedNodeActive(groundAdjustedNode, true )
        if groundAdjustedNode.isActive then
            for i = 1 , #groundAdjustedNode.adjustNodes do
                local adjustNode = groundAdjustedNode.adjustNodes[i]
                if math.abs(adjustNode.y - adjustNode.curY) > 0.01 then
                    setTranslation(adjustNode.node, adjustNode.x, adjustNode.curY, adjustNode.z)

                    if self.setMovingToolDirty ~ = nil then
                        self:setMovingToolDirty(adjustNode.node)
                    end
                end
            end
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
function GroundAdjustedNodes:onRegisterAnimationValueTypes()
    self:registerAnimationValueType( "groundAdjustScale" , "startGroundAdjustScale" , "endGroundAdjustScale" , false , AnimationValueFloat ,
    function (value, xmlFile, xmlKey)
        value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)

        if value.node ~ = nil then
            value:setWarningInformation( "node: " .. getName(value.node))
            value:addCompareParameters( "node" )

            return true
        end

        return false
    end ,

    function (value)
        if value.groundAdjustedNode = = nil then
            local spec = self.spec_groundAdjustedNodes
            for _, groundAdjustedNode in pairs(spec.groundAdjustedNodes) do
                for _, adjustNode in pairs(groundAdjustedNode.adjustNodes) do
                    if adjustNode.node = = value.node then
                        value.groundAdjustedNode = groundAdjustedNode
                        break
                    end
                end

                if value.groundAdjustedNode ~ = nil then
                    break
                end
            end

            if value.groundAdjustedNode = = nil then
                Logging.xmlWarning(value.xmlFile, "Could not find groundAdjustedNode for node '%s'!" , getName(value.node))
                    return 0
                end
            end

            return value.groundAdjustedNode.activeScale
        end ,

        function (value, activeScale)
            if value.groundAdjustedNode ~ = nil then
                value.groundAdjustedNode.activeScale = activeScale
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
function GroundAdjustedNodes:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_groundAdjustedNodes
    if self.currentUpdateDistance < spec.maxUpdateDistance then
        self:updateGroundAdjustedRaycasts(dt)

        for _, groundAdjustedNode in pairs(spec.groundAdjustedNodes) do
            self:updateGroundAdjustedNode(groundAdjustedNode, dt)
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
function GroundAdjustedNodes.prerequisitesPresent(specializations)
    return true
end

```

### registerAdjustNodeXMLPaths

**Description**

**Definition**

> registerAdjustNodeXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function GroundAdjustedNodes.registerAdjustNodeXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Ground adjusted node" )
    schema:register(XMLValueType.FLOAT, basePath .. "#minY" , "Min.Y translation" , "translation in i3d - 1" )
    schema:register(XMLValueType.FLOAT, basePath .. "#maxY" , "Max.Y translation" , "minY + 1" )
    schema:register(XMLValueType.FLOAT, basePath .. "#moveSpeed" , "Move speed" , 1 )
    schema:register(XMLValueType.BOOL, basePath .. "#resetIfNotActive" , "Reset node to start translation if not active" , true )
        schema:register(XMLValueType.FLOAT, basePath .. "#moveSpeedStateChange" , "Move speed while node is inactive or active an in range of #activationTime" , "#moveSpeed" )
            schema:register(XMLValueType.FLOAT, basePath .. "#updateThreshold" , "Position of node will be updated if change is greater than this value" , 0.002 )
                schema:register(XMLValueType.FLOAT, basePath .. "#inActiveOffsetY" , "Offset of the in active position in Y, will be applied on top of the current position in i3d" , 0 )
                schema:register(XMLValueType.FLOAT, basePath .. "#inActiveY" , "Adjust node will go to this state while it's not active" , "Position in i3d file" )
                    schema:register(XMLValueType.BOOL, basePath .. "#averageInActivePosY" , "While nodes are turned off the average Y position will be used as target for all nodes" , false )
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
function GroundAdjustedNodes.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , GroundAdjustedNodes )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , GroundAdjustedNodes )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , GroundAdjustedNodes )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterAnimationValueTypes" , GroundAdjustedNodes )
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
function GroundAdjustedNodes.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadGroundAdjustedNodeFromXML" , GroundAdjustedNodes.loadGroundAdjustedNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadGroundAdjustedAdjustNodeFromXML" , GroundAdjustedNodes.loadGroundAdjustedAdjustNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "initGroundAdjustedAdjustNode" , GroundAdjustedNodes.initGroundAdjustedAdjustNode)
    SpecializationUtil.registerFunction(vehicleType, "loadGroundAdjustedRaycastNodeFromXML" , GroundAdjustedNodes.loadGroundAdjustedRaycastNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsGroundAdjustedNodeActive" , GroundAdjustedNodes.getIsGroundAdjustedNodeActive)
    SpecializationUtil.registerFunction(vehicleType, "updateGroundAdjustedRaycasts" , GroundAdjustedNodes.updateGroundAdjustedRaycasts)
    SpecializationUtil.registerFunction(vehicleType, "updateGroundAdjustedNode" , GroundAdjustedNodes.updateGroundAdjustedNode)
end

```

### registerNodeXMLPaths

**Description**

**Definition**

> registerNodeXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function GroundAdjustedNodes.registerNodeXMLPaths(schema, basePath)
    schema:addDelayedRegistrationPath(basePath, "GroundAdjustedNodes:node" )

    schema:register(XMLValueType.FLOAT, basePath .. "#activationTime" , "In this time after the activation of the node the #moveSpeedStateChange will be used" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#yOffset" , "Raycast Y translation offset(Raycast will start this distance above the node)" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".raycastNode(?)#node" , "Ground adjusted raycast node" )
    schema:register(XMLValueType.FLOAT, basePath .. ".raycastNode(?)#distance" , "Ground adjusted raycast distance" , 4 )
    schema:register(XMLValueType.INT, basePath .. ".raycastNode(?)#updateFrame" , "Defines the frame delay between two raycasts" , "Number of raycasts" )
    schema:register(XMLValueType.FLOAT, basePath .. ".raycastNode(?)#yOffset" , "Raycast Y translation offset(Raycast will start this distance above the node)" , 0 )

    GroundAdjustedNodes.registerAdjustNodeXMLPaths(schema, basePath)
    GroundAdjustedNodes.registerAdjustNodeXMLPaths(schema, basePath .. ".adjustNode(?)" )
end

```

### updateGroundAdjustedNode

**Description**

**Definition**

> updateGroundAdjustedNode()

**Arguments**

| any | groundAdjustedNode |
|-----|--------------------|
| any | dt                 |

**Code**

```lua
function GroundAdjustedNodes:updateGroundAdjustedNode(groundAdjustedNode, dt)
    local spec = self.spec_groundAdjustedNodes

    local wasActive = groundAdjustedNode.isActive
    groundAdjustedNode.isActive = self:getIsGroundAdjustedNodeActive(groundAdjustedNode)
    if groundAdjustedNode.isActive then
        groundAdjustedNode.activationTimer = math.max(groundAdjustedNode.activationTimer - dt, 0 )
    else
            if groundAdjustedNode.averageInActivePosY and wasActive then
                local groundAdjustedNodes = spec.groundAdjustedNodes
                local inActiveY, numNodes = 0 , 0
                for _, _groundAdjustedNode in pairs(groundAdjustedNodes) do
                    for i = 1 , #_groundAdjustedNode.adjustNodes do
                        local _adjustNode = _groundAdjustedNode.adjustNodes[i]
                        if _adjustNode.averageInActivePosY then
                            inActiveY = inActiveY + _adjustNode.curY
                            numNodes = numNodes + 1
                        end
                    end
                end

                if numNodes > 0 then
                    groundAdjustedNode.inActiveY = inActiveY / numNodes

                    -- reapply to all since some could have already changed
                    for _, _groundAdjustedNode in pairs(groundAdjustedNodes) do
                        for i = 1 , #_groundAdjustedNode.adjustNodes do
                            local _adjustNode = _groundAdjustedNode.adjustNodes[i]
                            if _adjustNode.averageInActivePosY then
                                _adjustNode.inActiveY = inActiveY / numNodes
                            end
                        end
                    end
                end
            end

            groundAdjustedNode.activationTimer = groundAdjustedNode.activationTime
        end

        for i = 1 , #groundAdjustedNode.adjustNodes do
            local adjustNode = groundAdjustedNode.adjustNodes[i]

            if groundAdjustedNode.isActive and groundAdjustedNode.activeScale > 0 then
                if not wasActive then
                    local _, y, _ = getTranslation(adjustNode.node)
                    adjustNode.curY = y
                end

                local raycastNode = groundAdjustedNode.raycastNodes[ 1 ]
                local height
                if #groundAdjustedNode.raycastNodes = = 2 then
                    height = groundAdjustedNode.raycastNodes[ 1 ].lastRaycastDistance * ( 1 - adjustNode.alpha)
                    + groundAdjustedNode.raycastNodes[ 2 ].lastRaycastDistance * adjustNode.alpha
                else
                        height = groundAdjustedNode.raycastNodes[ 1 ].lastRaycastDistance
                    end

                    local _, targetY, _ = localToLocal(raycastNode.node, getParent(adjustNode.node), 0 , raycastNode.yOffset - height, 0 )

                    if self.currentUpdateDistance < spec.maxUpdateDistanceWobble then
                        if raycastNode.lastIsOnField then
                            adjustNode.lastOffsetDistance = adjustNode.lastOffsetDistance + ( self.lastMovedDistance * self.movingDirection * 0.1 )
                            local noise = getRandomOffset(adjustNode.lastOffsetDistance)
                            targetY = targetY + noise * PERLIN_NOISE.maxOffset
                        end
                    end

                    adjustNode.targetY = math.clamp(targetY, adjustNode.minY, adjustNode.maxY)
                else
                        if adjustNode.resetIfNotActive then
                            adjustNode.targetY = adjustNode.inActiveY
                        end
                    end

                    adjustNode.targetY = adjustNode.targetY * groundAdjustedNode.activeScale + adjustNode.inActiveY * ( 1 - groundAdjustedNode.activeScale)

                    if adjustNode.targetY ~ = adjustNode.curY then
                        local stateChangeActive = not groundAdjustedNode.isActive or groundAdjustedNode.activationTimer > 0
                        local moveSpeed = stateChangeActive and adjustNode.moveSpeedStateChange or adjustNode.moveSpeed

                        if adjustNode.targetY > adjustNode.curY then
                            adjustNode.curY = math.min(adjustNode.curY + moveSpeed * dt, adjustNode.targetY)
                        else
                                adjustNode.curY = math.max(adjustNode.curY - moveSpeed * dt, adjustNode.targetY)
                            end

                            if math.abs(adjustNode.lastY - adjustNode.curY) > adjustNode.updateThreshold then
                                setTranslation(adjustNode.node, adjustNode.x, adjustNode.curY, adjustNode.z)
                                adjustNode.lastY = adjustNode.curY

                                if self.setMovingToolDirty ~ = nil then
                                    self:setMovingToolDirty(adjustNode.node)
                                end
                            end
                        end
                    end
                end

```

### updateGroundAdjustedRaycasts

**Description**

**Definition**

> updateGroundAdjustedRaycasts()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function GroundAdjustedNodes:updateGroundAdjustedRaycasts(dt)
    local spec = self.spec_groundAdjustedNodes
    for node, raycastNode in pairs(spec.raycastNodesByNode) do
        if raycastNode.parent.isActive and raycastNode.parent.activeScale > 0 then
            local x, y, z = localToWorld(raycastNode.node, 0 , raycastNode.yOffset, 0 )

            raycastNode.lastIsOnField = getDensityAtWorldPos(g_currentMission.terrainDetailId, x, 0 , z) ~ = 0
            if not raycastNode.lastIsOnField or spec.adjustToWater then
                local dx, dy, dz = localDirectionToWorld(raycastNode.node, 0 , - 1 , 0 )

                local mask = GroundAdjustedNodes.COLLISION_MASK
                if spec.adjustToWater then
                    mask = GroundAdjustedNodes.COLLISION_MASK_WATER
                end

                raycastAll(x, y, z, dx, dy, dz, raycastNode.maxDistance, "groundAdjustRaycastCallback" , raycastNode, mask)

                --#debug drawDebugLine(x, y, z, 0, 1, 0, x+dx*raycastNode.maxDistance, y+dy*raycastNode.maxDistance, z+dz*raycastNode.maxDistance, 1, 0, 0, true)
                --#debug local x, y, z = localToWorld(raycastNode.node, 0, raycastNode.yOffset - raycastNode.lastRaycastDistance, 0)
                --#debug drawDebugPoint(x, y, z, 0, 1, 0, 1, true)
            else
                    local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)
                    if y > terrainHeight - 10 then
                        raycastNode.lastRaycastDistance = math.min(y - terrainHeight, raycastNode.maxDistance)
                        --#debug local x, y, z = localToWorld(raycastNode.node, 0, raycastNode.yOffset - raycastNode.lastRaycastDistance, 0)
                        --#debug drawDebugPoint(x, y, z, 0, 0, 1, 1, true)
                    end
                end
            end
        end
    end

```