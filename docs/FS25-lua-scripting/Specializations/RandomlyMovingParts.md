## RandomlyMovingParts

**Description**

> Specialization for making parts randomly move during work using rotation changes

**Functions**

- [getIsRandomlyMovingPartActive](#getisrandomlymovingpartactive)
- [initSpecialization](#initspecialization)
- [loadRandomlyMovingPartFromXML](#loadrandomlymovingpartfromxml)
- [onLoad](#onload)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [updateRandomlyMovingPart](#updaterandomlymovingpart)

### getIsRandomlyMovingPartActive

**Description**

> Returns if randomly moving part is active

**Definition**

> getIsRandomlyMovingPartActive(table part)

**Arguments**

| table | part | part to check |
|-------|------|---------------|

**Return Values**

| table | isActive | is active |
|-------|----------|-----------|

**Code**

```lua
function RandomlyMovingParts:getIsRandomlyMovingPartActive(part)
    local retValue = true
    if part.groundReferenceNode ~ = nil then
        retValue = self:getIsGroundReferenceNodeActive(part.groundReferenceNode)
    end

    return retValue
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function RandomlyMovingParts.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "RandomlyMovingParts" )

    schema:register(XMLValueType.FLOAT, "vehicle.randomlyMovingParts#maxUpdateDistance" , RandomlyMovingParts.DEFAULT_MAX_UPDATE_DISTANCE)

    schema:register(XMLValueType.NODE_INDEX, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#node" , "Node" )
    schema:register(XMLValueType.INT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#refNodeIndex" , "Ground reference node index" )

    schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#speedScale" , "Speed scale" , 1 )
    schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#speedVariance" , "Random variance in the speed scale" , 0.1 )
    schema:register(XMLValueType.TIME, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#fadeTime" , "Fade in and fade out time" , 1 )

    local names = { }
    for name, _ in pairs( RandomlyMovingParts.PRESETS) do
        table.insert(names, name)
    end

    schema:register(XMLValueType.STRING, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#preset" , "Name of the preset to use for random value behaviour(%s)" , "SOWINGMACHINE" , nil , names)

        schema:register(XMLValueType.VECTOR_ 3 , RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#noiseFrequency" , "The frequency of the different offsets that is applied" , "used from preset" )
        schema:register(XMLValueType.VECTOR_ 3 , RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#noiseAmount" , "The max.offset for each frequency" , "used from preset" )

            schema:register(XMLValueType.BOOL, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#hasBumps" , "The max.offset for each frequency" , "used from preset" )
                schema:register(XMLValueType.TIME, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#bumpFrequency" , "Max.time between bumps" , "used from preset" )
                schema:register(XMLValueType.TIME, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#bumpDuration" , "Duration of the bump" , "used from preset" )

                schema:register(XMLValueType.INT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#rotAxis" , "Rotation axis" )
                schema:register(XMLValueType.ANGLE, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#rotMax" , "Max.delta rotation value in position direction" )
                schema:register(XMLValueType.ANGLE, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#rotMin" , "Max.delta rotation value in negative direction" , "Inverted rotMax value" )
                schema:register(XMLValueType.ANGLE, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#rotStart" , "Initial rotation value on the defined axis" , "Current value from i3d" )

                schema:register(XMLValueType.INT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#transAxis" , "Translation axis" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#transMax" , "Max.delta translation value in position direction" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#transMin" , "Max.delta translation value in negative direction" , "Inverted rotMax value" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#transStart" , "Initial translation value on the defined axis" , "Current value from i3d" )

                schema:register(XMLValueType.BOOL, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. "#isSpeedDependent" , "Speed will adjust based on vehicle moving speed" , true )

                schema:register(XMLValueType.NODE_INDEX, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#node" , "Node that receives the same value" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#scale" , "Scale that is applied to the random value(use -1 to invert the value)" , 1 )

                schema:register(XMLValueType.INT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#rotAxis" , "Rotation axis" )
                schema:register(XMLValueType.ANGLE, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#rotMax" , "Max.delta rotation value in position direction" )
                schema:register(XMLValueType.ANGLE, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#rotMin" , "Max.delta rotation value in negative direction" , "Inverted rotMax value" )
                schema:register(XMLValueType.ANGLE, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#rotStart" , "Initial rotation value on the defined axis" , "Current value from i3d" )

                schema:register(XMLValueType.INT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#transAxis" , "Translation axis" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#transMax" , "Max.delta translation value in position direction" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#transMin" , "Max.delta translation value in negative direction" , "Inverted rotMax value" )
                schema:register(XMLValueType.FLOAT, RandomlyMovingParts.RANDOMLY_MOVING_PART_XML_KEY .. ".node(?)#transStart" , "Initial translation value on the defined axis" , "Current value from i3d" )

                schema:setXMLSpecializationType()
            end

```

### loadRandomlyMovingPartFromXML

**Description**

> Load randomly moving part from xml

**Definition**

> loadRandomlyMovingPartFromXML(table part, XMLFile xmlFile, string key)

**Arguments**

| table   | part    | part             |
|---------|---------|------------------|
| XMLFile | xmlFile | XMLFile instance |
| string  | key     | key              |

**Return Values**

| string | success |
|--------|---------|

**Code**

```lua
function RandomlyMovingParts:loadRandomlyMovingPartFromXML(part, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#rotMean" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#rotVariance" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#rotTimeMean" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#rotTimeVariance" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#pauseMean" ) --FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#pauseVariance" ) --FS22 to FS25

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node = = nil then
        Logging.xmlWarning(xmlFile, "Unknown node for randomlyMovingPart in '%s'" , key)
            return false
        end

        part.node = node

        if self.getGroundReferenceNodeFromIndex ~ = nil then
            local refNodeIndex = xmlFile:getValue(key .. "#refNodeIndex" )
            if refNodeIndex ~ = nil then
                if refNodeIndex ~ = 0 then
                    local groundReferenceNode = self:getGroundReferenceNodeFromIndex(refNodeIndex)
                    if groundReferenceNode ~ = nil then
                        part.groundReferenceNode = groundReferenceNode
                    end
                else
                        Logging.xmlWarning(xmlFile, "Unknown ground reference node in '%s'! Indices start with '0'" , key .. "#refNodeIndex" )
                    end
                end
            end

            part.isSpeedDependent = xmlFile:getValue(key .. "#isSpeedDependent" , true )

            part.speedScale = xmlFile:getValue(key .. "#speedScale" , 1 )
            part.speedVariance = xmlFile:getValue(key .. "#speedVariance" , 0.1 )
            part.speedScale = part.speedScale + ( math.random() * part.speedVariance - (part.speedVariance * 0.5 ))

            part.fadeTime = 1 / xmlFile:getValue(key .. "#fadeTime" , 1 )

            local preset = xmlFile:getValue(key .. "#preset" , "SOWINGMACHINE" )
            preset = RandomlyMovingParts.PRESETS[ string.upper(preset)] or RandomlyMovingParts.PRESETS.SOWINGMACHINE

            part.noiseFrequency = xmlFile:getValue(key .. "#noiseFrequency" , preset.noiseFrequency, true )
            part.noiseAmount = xmlFile:getValue(key .. "#noiseAmount" , preset.noiseAmount, true )

            part.hasBumps = xmlFile:getValue(key .. "#hasBumps" , preset.hasBumps)
            if part.hasBumps then
                part.bumpFrequency = xmlFile:getValue(key .. "#bumpFrequency" , preset.bumpFrequency or 10 )
                part.bumpNextTime = part.bumpFrequency * math.random()

                part.bumpTimer = 0
                part.bumpDuration = xmlFile:getValue(key .. "#bumpDuration" , preset.bumpDuration or 0.25 )
            end

            part.rotAxis = xmlFile:getValue(key .. "#rotAxis" , nil )
            if part.rotAxis ~ = nil then
                part.rotMax = xmlFile:getValue(key .. "#rotMax" , 0 )
                part.rotMin = xmlFile:getValue(key .. "#rotMin" ) or - part.rotMax
                part.rotation = { getRotation(part.node) }
                part.initialRotation = { getRotation(part.node) }

                part.rotStart = xmlFile:getValue(key .. "#rotStart" )
                if part.rotStart ~ = nil then
                    part.rotation[part.rotAxis] = part.rotStart
                    part.initialRotation[part.rotAxis] = part.rotStart
                    setRotation(part.node, part.initialRotation[ 1 ], part.initialRotation[ 2 ], part.initialRotation[ 3 ])
                end
            end

            part.transAxis = xmlFile:getValue(key .. "#transAxis" , nil )
            if part.transAxis ~ = nil then
                part.transMax = xmlFile:getValue(key .. "#transMax" , 0 )
                part.transMin = xmlFile:getValue(key .. "#transMin" ) or - part.transMax
                part.translation = { getTranslation(part.node) }
                part.initialTranslation = { getTranslation(part.node) }

                part.transStart = xmlFile:getValue(key .. "#transStart" )
                if part.transStart ~ = nil then
                    part.translation[part.transAxis] = part.transStart
                    part.initialTranslation[part.transAxis] = part.transStart
                    setTranslation(part.node, part.initialTranslation[ 1 ], part.initialTranslation[ 2 ], part.initialTranslation[ 3 ])
                end
            end

            if part.rotAxis = = nil and part.transAxis = = nil then
                Logging.xmlWarning(xmlFile, "No rotation or translation axis for randomlyMovingPart in '%s'" , key)
                    return false
                end

                part.nodes = { }
                for _, nodeKey in xmlFile:iterator(key .. ".node" ) do
                    local node = xmlFile:getValue(nodeKey .. "#node" , nil , self.components, self.i3dMappings)
                    if node ~ = nil then
                        local nodeData = { }
                        nodeData.node = node
                        nodeData.deltaScale = xmlFile:getValue(nodeKey .. "#scale" , 1 )

                        nodeData.rotAxis = xmlFile:getValue(key .. "#rotAxis" , part.rotAxis)
                        if nodeData.rotAxis ~ = nil then
                            nodeData.rotMax = xmlFile:getValue(key .. "#rotMax" , part.rotMax or 0 )
                            nodeData.rotMin = xmlFile:getValue(key .. "#rotMin" ) or - nodeData.rotMax
                            nodeData.rotation = { getRotation(nodeData.node) }
                            nodeData.initialRotation = { getRotation(nodeData.node) }

                            nodeData.rotStart = xmlFile:getValue(key .. "#rotStart" )
                            if nodeData.rotStart ~ = nil then
                                nodeData.rotation[nodeData.rotAxis] = nodeData.rotStart
                                nodeData.initialRotation[nodeData.rotAxis] = nodeData.rotStart
                                setRotation(nodeData.node, nodeData.initialRotation[ 1 ], nodeData.initialRotation[ 2 ], nodeData.initialRotation[ 3 ])
                            end
                        end

                        nodeData.transAxis = xmlFile:getValue(key .. "#transAxis" , part.transAxis)
                        if nodeData.transAxis ~ = nil then
                            nodeData.transMax = xmlFile:getValue(key .. "#transMax" , part.transMax or 0 )
                            nodeData.transMin = xmlFile:getValue(key .. "#transMin" ) or - nodeData.transMax
                            nodeData.translation = { getTranslation(nodeData.node) }
                            nodeData.initialTranslation = { getTranslation(nodeData.node) }

                            nodeData.transStart = xmlFile:getValue(key .. "#transStart" )
                            if nodeData.transStart ~ = nil then
                                nodeData.translation[nodeData.transAxis] = nodeData.transStart
                                nodeData.initialTranslation[nodeData.transAxis] = nodeData.transStart
                                setTranslation(nodeData.node, nodeData.initialTranslation[ 1 ], nodeData.initialTranslation[ 2 ], nodeData.initialTranslation[ 3 ])
                            end
                        end

                        if part.rotAxis ~ = nil or part.transAxis ~ = nil then
                            table.insert(part.nodes, nodeData)
                        end
                    end
                end

                part.isActive = true
                part.time = math.random()
                part.alpha = 0

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
function RandomlyMovingParts:onLoad(savegame)
    local spec = self.spec_randomlyMovingParts

    spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.randomlyMovingParts#maxUpdateDistance" , RandomlyMovingParts.DEFAULT_MAX_UPDATE_DISTANCE)

    spec.nodes = { }

    for _, key in self.xmlFile:iterator( "vehicle.randomlyMovingParts.randomlyMovingPart" ) do
        local randomlyMovingPart = { }
        if self:loadRandomlyMovingPartFromXML(randomlyMovingPart, self.xmlFile, key) then
            table.insert(spec.nodes, randomlyMovingPart)
        end
    end

    if not self.isClient or #spec.nodes = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdate" , RandomlyMovingParts )
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
function RandomlyMovingParts:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_randomlyMovingParts
    if self.currentUpdateDistance < spec.maxUpdateDistance then
        if self:getLastSpeed() > 0.1 then
            for _, part in pairs(spec.nodes) do
                self:updateRandomlyMovingPart(part, dt)
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
function RandomlyMovingParts.prerequisitesPresent(specializations)
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
function RandomlyMovingParts.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , RandomlyMovingParts )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , RandomlyMovingParts )
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
function RandomlyMovingParts.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadRandomlyMovingPartFromXML" , RandomlyMovingParts.loadRandomlyMovingPartFromXML)
    SpecializationUtil.registerFunction(vehicleType, "updateRandomlyMovingPart" , RandomlyMovingParts.updateRandomlyMovingPart)
    SpecializationUtil.registerFunction(vehicleType, "getIsRandomlyMovingPartActive" , RandomlyMovingParts.getIsRandomlyMovingPartActive)
end

```

### updateRandomlyMovingPart

**Description**

> Update randomly moving parts

**Definition**

> updateRandomlyMovingPart(table part, float dt)

**Arguments**

| table | part | part to update             |
|-------|------|----------------------------|
| float | dt   | time since last call in ms |

**Return Values**

| float | updated | part was updated |
|-------|---------|------------------|

**Code**

```lua
function RandomlyMovingParts:updateRandomlyMovingPart(part, dt)
    local speed
    if part.isSpeedDependent then
        speed = self.lastMovedDistance * self.movingDirection * 0.2
    else
            speed = dt * 0.00033
        end

        part.isActive = self:getIsRandomlyMovingPartActive(part)

        if part.isActive then
            if part.alpha < 1 then
                part.alpha = math.min(part.alpha + dt * part.fadeTime, 1 )
            end

            if part.hasBumps then
                if not part.isSpeedDependent or self:getLastSpeed() > 1 then
                    part.bumpNextTime = part.bumpNextTime - dt
                    if part.bumpNextTime < = 0 then
                        part.bumpTimer = part.bumpDuration
                        part.bumpNextTime = part.bumpFrequency * math.random()
                    end
                end

                if part.bumpTimer > 0 then
                    part.bumpTimer = part.bumpTimer - dt
                end
            end
        else
                if part.alpha > 0 then
                    part.alpha = math.max(part.alpha - dt * part.fadeTime, 0 )
                end
            end

            if part.alpha > 0 then
                part.time = part.time + speed * part.speedScale

                local delta = math.sin(part.time * part.noiseFrequency[ 1 ]) * part.noiseAmount[ 1 ] + math.sin(part.time * part.noiseFrequency[ 2 ]) * part.noiseAmount[ 2 ] + math.sin(part.time * part.noiseFrequency[ 3 ]) * part.noiseAmount[ 3 ]

                if part.hasBumps then
                    if part.bumpTimer > 0 then
                        local bumpAlpha = 1 - (part.bumpTimer / part.bumpDuration)
                        delta = math.min(delta + math.sin(bumpAlpha * math.pi), 1 )
                    end
                end

                updateNodeData( self , part, delta, part.alpha)

                for i, nodeData in ipairs(part.nodes) do
                    updateNodeData( self , nodeData, delta, part.alpha)
                end
            end
        end

```