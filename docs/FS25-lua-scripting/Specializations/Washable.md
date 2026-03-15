## Washable

**Description**

> Specialization for vehicles which can get dirty and be cleaned by a pressure washer

**Functions**

- [addAllSubWashableNodes](#addallsubwashablenodes)
- [addDirtAmount](#adddirtamount)
- [addToGlobalWashableNode](#addtoglobalwashablenode)
- [addToLocalWashableNode](#addtolocalwashablenode)
- [addWashableNode](#addwashablenode)
- [addWashableNodes](#addwashablenodes)
- [addWetnessAmount](#addwetnessamount)
- [cleanVehicle](#cleanvehicle)
- [getAllowsWashingByType](#getallowswashingbytype)
- [getDirtAmount](#getdirtamount)
- [getDirtMultiplier](#getdirtmultiplier)
- [getIntervalMultiplier](#getintervalmultiplier)
- [getIsWet](#getiswet)
- [getNodeDirtAmount](#getnodedirtamount)
- [getWashableNodeByCustomIndex](#getwashablenodebycustomindex)
- [getWashDuration](#getwashduration)
- [getWorkDirtMultiplier](#getworkdirtmultiplier)
- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [readWashableNodeData](#readwashablenodedata)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [removeAllSubWashableNodes](#removeallsubwashablenodes)
- [removeWashableNode](#removewashablenode)
- [saveToXMLFile](#savetoxmlfile)
- [setDirtAmount](#setdirtamount)
- [setNodeDirtAmount](#setnodedirtamount)
- [setNodeDirtColor](#setnodedirtcolor)
- [setNodeWetness](#setnodewetness)
- [updateDebugValues](#updatedebugvalues)
- [updateDirtAmount](#updatedirtamount)
- [updateWetness](#updatewetness)
- [validateWashableNode](#validatewashablenode)
- [writeWashableNodeData](#writewashablenodedata)

### addAllSubWashableNodes

**Description**

**Definition**

> addAllSubWashableNodes()

**Arguments**

| any | rootNode |
|-----|----------|

**Code**

```lua
function Washable:addAllSubWashableNodes(rootNode)
    if rootNode ~ = nil then
        I3DUtil.iterateShaderParametersNodesRecursively(rootNode, Washable.SHADER_PARAMETERS, self.addWashableNode, self )
    end

    -- if we are done with adding new nodes we apply the last dirt amount to all nodes
        self:addDirtAmount( 0 , true )
    end

```

### addDirtAmount

**Description**

**Definition**

> addDirtAmount()

**Arguments**

| any | dirtAmount |
|-----|------------|
| any | force      |

**Code**

```lua
function Washable:addDirtAmount(dirtAmount, force)
    local spec = self.spec_washable
    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]
        self:setNodeDirtAmount(nodeData, nodeData.dirtAmount + dirtAmount, force)
    end
end

```

### addToGlobalWashableNode

**Description**

**Definition**

> addToGlobalWashableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Washable:addToGlobalWashableNode(node)
    local spec = self.spec_washable
    if spec.washableNodes[ 1 ] ~ = nil then
        local useWetness = true
        if next(spec.wetnessIgnoreNodes) ~ = nil then
            local nodeToCheck = node
            while nodeToCheck ~ = 0 do
                if spec.wetnessIgnoreNodes[nodeToCheck] = = true then
                    useWetness = false
                    break
                end
                nodeToCheck = getParent(nodeToCheck)
            end
        end

        spec.washableNodes[ 1 ].nodes[node] = useWetness
    end
end

```

### addToLocalWashableNode

**Description**

**Definition**

> addToLocalWashableNode()

**Arguments**

| any | node        |
|-----|-------------|
| any | updateFunc  |
| any | customIndex |
| any | extraParams |

**Code**

```lua
function Washable:addToLocalWashableNode(node, updateFunc, customIndex, extraParams)
    local spec = self.spec_washable

    local useWetness = true
    if node ~ = nil and next(spec.wetnessIgnoreNodes) ~ = nil then
        local nodeToCheck = node
        while nodeToCheck ~ = 0 do
            if spec.wetnessIgnoreNodes[nodeToCheck] = = true then
                useWetness = false
                break
            end
            nodeToCheck = getParent(nodeToCheck)
        end
    end

    local nodeData = { }

    --if washableNode already exists we add node to existing washableNode
        if customIndex ~ = nil then
            if spec.washableNodesByIndex[customIndex] ~ = nil then
                if getHasShaderParameter(node, "scratches_dirt_snow_wetness" ) then
                    spec.washableNodesByIndex[customIndex].nodes[node] = useWetness
                else
                        spec.washableNodesByIndex[customIndex].mudNodes[node] = useWetness
                    end
                    return
                else
                        spec.washableNodesByIndex[customIndex] = nodeData
                    end
                end

                --if washableNode doesn't exists we create a new one
                    nodeData.nodes = { }
                    nodeData.mudNodes = { }
                    if node ~ = nil then
                        if getHasShaderParameter(node, "scratches_dirt_snow_wetness" ) then
                            nodeData.nodes[node] = useWetness
                        else
                                nodeData.mudNodes[node] = useWetness
                            end
                        end

                        nodeData.updateFunc = updateFunc
                        nodeData.dirtAmount = 0
                        nodeData.dirtAmountSent = 0

                        nodeData.wetness = 0
                        nodeData.wetnessSent = 0

                        nodeData.colorChanged = false
                        local defaultColor, _ = g_currentMission.environment:getDirtColors()
                        nodeData.color = { defaultColor[ 1 ], defaultColor[ 2 ], defaultColor[ 3 ] }
                        nodeData.defaultColor = { defaultColor[ 1 ], defaultColor[ 2 ], defaultColor[ 3 ] }

                        if extraParams ~ = nil then
                            for i, v in pairs(extraParams) do
                                nodeData[i] = v
                            end
                        end

                        table.insert(spec.washableNodes, nodeData)
                    end

```

### addWashableNode

**Description**

**Definition**

> addWashableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Washable:addWashableNode(node)
    local isGlobal, updateFunc, customIndex, extraParams = self:validateWashableNode(node)
    if isGlobal then
        self:addToGlobalWashableNode(node)
    elseif updateFunc ~ = nil then
            self:addToLocalWashableNode(node, updateFunc, customIndex, extraParams)
        end
    end

```

### addWashableNodes

**Description**

**Definition**

> addWashableNodes()

**Arguments**

| any | nodes |
|-----|-------|

**Code**

```lua
function Washable:addWashableNodes(nodes)
    for _, node in ipairs(nodes) do
        self:addWashableNode(node)
    end
end

```

### addWetnessAmount

**Description**

**Definition**

> addWetnessAmount()

**Arguments**

| any | amount |
|-----|--------|

**Code**

```lua
function Washable:addWetnessAmount(amount)
    local spec = self.spec_washable

    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]
        self:setNodeWetness(nodeData, nodeData.wetness + amount)
    end
end

```

### cleanVehicle

**Description**

**Definition**

> cleanVehicle()

**Arguments**

| any | amount |
|-----|--------|

**Code**

```lua
function Washable:cleanVehicle(amount)
    local spec = self.spec_washable
    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]
        local nodeAmount = amount * (nodeData.cleaningMultiplier or 1 )
        self:setNodeDirtAmount(nodeData, nodeData.dirtAmount - nodeAmount, true )
        self:setNodeWetness(nodeData, nodeData.wetness + nodeAmount * 5 , true )
    end
end

```

### getAllowsWashingByType

**Description**

**Definition**

> getAllowsWashingByType()

**Arguments**

| any | type |
|-----|------|

**Code**

```lua
function Washable:getAllowsWashingByType( type )
    local spec = self.spec_washable
    return spec.blockedWashTypes[ type ] = = nil
end

```

### getDirtAmount

**Description**

**Definition**

> getDirtAmount()

**Code**

```lua
function Washable:getDirtAmount()
    local spec = self.spec_washable

    if #spec.washableNodes > 0 then
        return spec.washableNodes[ 1 ].dirtAmount
    end

    return 0
end

```

### getDirtMultiplier

**Description**

**Definition**

> getDirtMultiplier()

**Code**

```lua
function Washable:getDirtMultiplier()
    local spec = self.spec_washable

    local multiplier = 1
    if self:getLastSpeed() < 1 then
        multiplier = 0
    end

    if self.isOnField then
        multiplier = multiplier * spec.fieldMultiplier

        local wetness = g_currentMission.environment.weather:getGroundWetness()
        if wetness > 0 then
            multiplier = multiplier * ( 1 + wetness * spec.wetMultiplier)
        end
    end

    return multiplier
end

```

### getIntervalMultiplier

**Description**

**Definition**

> getIntervalMultiplier()

**Code**

```lua
function Washable.getIntervalMultiplier()
    if g_currentMission.missionInfo.dirtInterval = = 1 then
        return 0
    elseif g_currentMission.missionInfo.dirtInterval = = 2 then
            return 0.25
        elseif g_currentMission.missionInfo.dirtInterval = = 3 then
                return 0.5
            elseif g_currentMission.missionInfo.dirtInterval = = 4 then
                    return 1
                end
                return 1
            end

```

### getIsWet

**Description**

**Definition**

> getIsWet()

**Code**

```lua
function Washable:getIsWet()
    for _, nodeData in pairs( self.spec_washable.washableNodes) do
        if nodeData.wetness > 0 then
            return true
        end
    end

    return false
end

```

### getNodeDirtAmount

**Description**

**Definition**

> getNodeDirtAmount()

**Arguments**

| any | nodeData |
|-----|----------|

**Code**

```lua
function Washable:getNodeDirtAmount(nodeData)
    return nodeData.dirtAmount
end

```

### getWashableNodeByCustomIndex

**Description**

**Definition**

> getWashableNodeByCustomIndex()

**Arguments**

| any | customIndex |
|-----|-------------|

**Code**

```lua
function Washable:getWashableNodeByCustomIndex(customIndex)
    return self.spec_washable.washableNodesByIndex[customIndex]
end

```

### getWashDuration

**Description**

**Definition**

> getWashDuration()

**Code**

```lua
function Washable:getWashDuration()
    local spec = self.spec_washable

    return spec.washDuration
end

```

### getWorkDirtMultiplier

**Description**

**Definition**

> getWorkDirtMultiplier()

**Code**

```lua
function Washable:getWorkDirtMultiplier()
    local spec = self.spec_washable

    return spec.workMultiplier
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Washable.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Washable" )
    schema:register(XMLValueType.FLOAT, "vehicle.washable#dirtDuration" , "Duration until fully dirty(minutes)" , 90 )
    schema:register(XMLValueType.FLOAT, "vehicle.washable#washDuration" , "Duration until fully clean(minutes)" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.washable#rainWashDuration" , "Duration until fully clean when it rains(minutes)" , 10 )
    schema:register(XMLValueType.FLOAT, "vehicle.washable#wetDuration" , "Duration until fully wet(ingame minutes)" , 10 )
    schema:register(XMLValueType.FLOAT, "vehicle.washable#dryDuration" , "Duration until the vehicle is fully dry again(ingame minutes)" , 120 )
    schema:register(XMLValueType.FLOAT, "vehicle.washable#workMultiplier" , "Multiplier while working" , 4 )
        schema:register(XMLValueType.FLOAT, "vehicle.washable#fieldMultiplier" , "Multiplier while on field" , 2 )
            schema:register(XMLValueType.FLOAT, "vehicle.washable#wetMultiplier" , "Multiplier while on it's wet" , 5 )
                schema:register(XMLValueType.STRING, "vehicle.washable#blockedWashTypes" , "Block specific ways to clean vehicle(HIGH_PRESSURE_WASHER, RAIN, TRIGGER)" )
                schema:register(XMLValueType.NODE_INDEX, "vehicle.washable.wetnessIgnoreNode(?)#node" , "Node, including it's children will never get wet" )
                schema:setXMLSpecializationType()

                local schemaSavegame = Vehicle.xmlSchemaSavegame
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).washable.dirtNode(?)#amount" , "Dirt amount" )
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).washable.dirtNode(?)#snowScale" , "Snow scale" )
                schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).washable.dirtNode(?)#wetness" , "Wetness" )
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
function Washable:onLoad(savegame)
    local spec = self.spec_washable

    spec.wetnessIgnoreNodes = { }
    for _, key in self.xmlFile:iterator( "vehicle.washable.wetnessIgnoreNode" ) do
        local node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if node ~ = nil then
            spec.wetnessIgnoreNodes[node] = true
        else
                Logging.xmlWarning( self.xmlFile, "Invalid node for wetnessIgnoreNode '%s'" , key)
                end
            end

            spec.washableNodes = { }
            spec.washableNodesByIndex = { }
            self:addToLocalWashableNode( nil , Washable.updateDirtAmount, nil , nil ) -- create global / default washableNode
            spec.globalWashableNode = spec.washableNodes[ 1 ]

            spec.dirtDuration = self.xmlFile:getValue( "vehicle.washable#dirtDuration" , 90 ) * 60 * 1000
            if spec.dirtDuration ~ = 0 then
                spec.dirtDuration = 1 / spec.dirtDuration
            end

            spec.washDuration = math.max( self.xmlFile:getValue( "vehicle.washable#washDuration" , 1 ) * 60 * 1000 , 0.00001 ) -- washDuration = = 0 washes vehicle immediately
            spec.rainWashDuration = math.max( self.xmlFile:getValue( "vehicle.washable#rainWashDuration" , 10 ) * 60 * 1000 , 0.00001 )
            spec.wetDuration = self.xmlFile:getValue( "vehicle.washable#wetDuration" , 10 ) / 60 / 1000
            spec.dryDuration = 1 / math.max( self.xmlFile:getValue( "vehicle.washable#dryDuration" , 120 ) * 60 * 1000 , 0.0001 )

            spec.workMultiplier = self.xmlFile:getValue( "vehicle.washable#workMultiplier" , 4 )
            spec.fieldMultiplier = self.xmlFile:getValue( "vehicle.washable#fieldMultiplier" , 2 )
            spec.wetMultiplier = self.xmlFile:getValue( "vehicle.washable#wetMultiplier" , 5 )

            spec.blockedWashTypes = { }
            local blockedWashTypesStr = self.xmlFile:getValue( "vehicle.washable#blockedWashTypes" )
            if blockedWashTypesStr ~ = nil then
                local blockedWashTypes = blockedWashTypesStr:split( " " )
                for _, typeStr in pairs(blockedWashTypes) do
                    typeStr = "WASHTYPE_" .. typeStr
                    if Washable [typeStr] ~ = nil then
                        spec.blockedWashTypes[ Washable [typeStr]] = true
                    else
                            Logging.xmlWarning( self.xmlFile, "Unknown wash type '%s' in '%s'" , typeStr, "vehicle.washable#blockedWashTypes" )
                        end
                    end
                end

                spec.lastDirtMultiplier = 0

                spec.dirtyFlag = self:getNextDirtyFlag()

                if self.propertyState = = VehiclePropertyState.SHOP_CONFIG then
                    SpecializationUtil.removeEventListener( self , "onUpdateTick" , Washable )
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
function Washable:onLoadFinished(savegame)
    local spec = self.spec_washable

    -- getting als washable nodes in postLoad to make sure also linked nodes are washable
    for _, component in pairs( self.components) do
        self:addAllSubWashableNodes(component.node)
    end

    if savegame ~ = nil and Washable.getIntervalMultiplier() ~ = 0 then
        for i = 1 , #spec.washableNodes do
            local nodeData = spec.washableNodes[i]
            local nodeKey = string.format( "%s.washable.dirtNode(%d)" , savegame.key, i - 1 )
            local amount = savegame.xmlFile:getValue(nodeKey .. "#amount" , 0 )
            self:setNodeDirtAmount(nodeData, amount, true )

            local wetness = savegame.xmlFile:getValue(nodeKey .. "#wetness" , 0 )
            self:setNodeWetness(nodeData, wetness, true )

            if nodeData.loadFromSavegameFunc ~ = nil then
                nodeData.loadFromSavegameFunc(savegame.xmlFile, nodeKey)
            end
        end
    else
            for i = 1 , #spec.washableNodes do
                local nodeData = spec.washableNodes[i]
                self:setNodeDirtAmount(nodeData, 0 , true )
            end
        end
    end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Washable:onReadStream(streamId, connection)
    Washable.readWashableNodeData( self , streamId, connection)
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function Washable:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_washable
        if spec.washableNodes ~ = nil then
            if streamReadBool(streamId) then
                Washable.readWashableNodeData( self , streamId, connection)
            end
        end
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
function Washable:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self.spec_washable
        spec.lastDirtMultiplier = self:getDirtMultiplier() * Washable.getIntervalMultiplier() * Platform.gameplay.dirtDurationScale

        local allowsWashingByRain = self:getAllowsWashingByType( Washable.WASHTYPE_RAIN)
        local rainScale, timeSinceLastRain, temperature = 0 , 0 , 0
        if allowsWashingByRain then
            local weather = g_currentMission.environment.weather
            rainScale = weather:getRainFallScale()
            timeSinceLastRain = weather:getTimeSinceLastRain()
            temperature = weather:getCurrentTemperature()
        end

        for i = 1 , #spec.washableNodes do
            local nodeData = spec.washableNodes[i]
            local changeDirt, changeWetness = nodeData.updateFunc( self , nodeData, dt, allowsWashingByRain, rainScale, timeSinceLastRain, temperature)
            if changeDirt ~ = 0 then
                self:setNodeDirtAmount(nodeData, nodeData.dirtAmount + changeDirt)
            end
            if changeWetness ~ = 0 then
                self:setNodeWetness(nodeData, nodeData.wetness + changeWetness)
            end
        end
    end
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Washable:onWriteStream(streamId, connection)
    Washable.writeWashableNodeData( self , streamId, connection)
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function Washable:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_washable
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            Washable.writeWashableNodeData( self , streamId, connection)
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
function Washable.prerequisitesPresent(specializations)
    return true
end

```

### readWashableNodeData

**Description**

**Definition**

> readWashableNodeData()

**Arguments**

| any | self       |
|-----|------------|
| any | streamId   |
| any | connection |

**Code**

```lua
function Washable.readWashableNodeData( self , streamId, connection)
    local spec = self.spec_washable
    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]
        local dirtAmount = streamReadUIntN(streamId, Washable.SEND_NUM_BITS) / Washable.SEND_MAX_VALUE
        self:setNodeDirtAmount(nodeData, dirtAmount, true )

        local wetness = streamReadUIntN(streamId, Washable.SEND_NUM_BITS_WETNESS) / Washable.SEND_MAX_VALUE_WETNESS
        self:setNodeWetness(nodeData, wetness, true )

        if streamReadBool(streamId) then
            local r = streamReadUIntN(streamId, Washable.SEND_NUM_BITS) / Washable.SEND_MAX_VALUE
            local g = streamReadUIntN(streamId, Washable.SEND_NUM_BITS) / Washable.SEND_MAX_VALUE
            local b = streamReadUIntN(streamId, Washable.SEND_NUM_BITS) / Washable.SEND_MAX_VALUE

            self:setNodeDirtColor(nodeData, r, g, b, true )
        end
    end
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
function Washable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Washable )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Washable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Washable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Washable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Washable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Washable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Washable )
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
function Washable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "cleanVehicle" , Washable.cleanVehicle)
    SpecializationUtil.registerFunction(vehicleType, "updateDirtAmount" , Washable.updateDirtAmount)
    SpecializationUtil.registerFunction(vehicleType, "addDirtAmount" , Washable.addDirtAmount)
    SpecializationUtil.registerFunction(vehicleType, "setDirtAmount" , Washable.setDirtAmount)
    SpecializationUtil.registerFunction(vehicleType, "getDirtAmount" , Washable.getDirtAmount)
    SpecializationUtil.registerFunction(vehicleType, "setNodeDirtAmount" , Washable.setNodeDirtAmount)
    SpecializationUtil.registerFunction(vehicleType, "getNodeDirtAmount" , Washable.getNodeDirtAmount)
    SpecializationUtil.registerFunction(vehicleType, "setNodeDirtColor" , Washable.setNodeDirtColor)
    SpecializationUtil.registerFunction(vehicleType, "updateWetness" , Washable.updateWetness)
    SpecializationUtil.registerFunction(vehicleType, "getIsWet" , Washable.getIsWet)
    SpecializationUtil.registerFunction(vehicleType, "addWetnessAmount" , Washable.addWetnessAmount)
    SpecializationUtil.registerFunction(vehicleType, "setNodeWetness" , Washable.setNodeWetness)
    SpecializationUtil.registerFunction(vehicleType, "addAllSubWashableNodes" , Washable.addAllSubWashableNodes)
    SpecializationUtil.registerFunction(vehicleType, "addWashableNodes" , Washable.addWashableNodes)
    SpecializationUtil.registerFunction(vehicleType, "addWashableNode" , Washable.addWashableNode)
    SpecializationUtil.registerFunction(vehicleType, "validateWashableNode" , Washable.validateWashableNode)
    SpecializationUtil.registerFunction(vehicleType, "addToGlobalWashableNode" , Washable.addToGlobalWashableNode)
    SpecializationUtil.registerFunction(vehicleType, "getWashableNodeByCustomIndex" , Washable.getWashableNodeByCustomIndex)
    SpecializationUtil.registerFunction(vehicleType, "addToLocalWashableNode" , Washable.addToLocalWashableNode)
    SpecializationUtil.registerFunction(vehicleType, "removeAllSubWashableNodes" , Washable.removeAllSubWashableNodes)
    SpecializationUtil.registerFunction(vehicleType, "removeWashableNode" , Washable.removeWashableNode)
    SpecializationUtil.registerFunction(vehicleType, "getDirtMultiplier" , Washable.getDirtMultiplier)
    SpecializationUtil.registerFunction(vehicleType, "getWorkDirtMultiplier" , Washable.getWorkDirtMultiplier)
    SpecializationUtil.registerFunction(vehicleType, "getWashDuration" , Washable.getWashDuration)
    SpecializationUtil.registerFunction(vehicleType, "getAllowsWashingByType" , Washable.getAllowsWashingByType)
end

```

### removeAllSubWashableNodes

**Description**

**Definition**

> removeAllSubWashableNodes()

**Arguments**

| any | rootNode |
|-----|----------|

**Code**

```lua
function Washable:removeAllSubWashableNodes(rootNode)
    if rootNode ~ = nil then
        I3DUtil.iterateShaderParametersNodesRecursively(rootNode, Washable.SHADER_PARAMETERS, self.removeWashableNode, self )
    end
end

```

### removeWashableNode

**Description**

**Definition**

> removeWashableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Washable:removeWashableNode(node)
    local spec = self.spec_washable

    if node ~ = nil then
        for i = 1 , #spec.washableNodes do
            spec.washableNodes[i].nodes[node] = nil
            spec.washableNodes[i].mudNodes[node] = nil
        end
    end
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
function Washable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_washable

    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]
        local nodeKey = string.format( "%s.dirtNode(%d)" , key, i - 1 )
        xmlFile:setValue(nodeKey .. "#amount" , nodeData.dirtAmount)
        xmlFile:setValue(nodeKey .. "#wetness" , nodeData.wetness)

        if nodeData.saveToSavegameFunc ~ = nil then
            nodeData.saveToSavegameFunc(xmlFile, nodeKey)
        end
    end
end

```

### setDirtAmount

**Description**

**Definition**

> setDirtAmount()

**Arguments**

| any | dirtAmount |
|-----|------------|

**Code**

```lua
function Washable:setDirtAmount(dirtAmount)
    local spec = self.spec_washable
    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]

        if next(nodeData.mudNodes) ~ = nil then
            self:setNodeDirtAmount(nodeData, (dirtAmount - 0.75 ) / 0.25 , true )
        else
                self:setNodeDirtAmount(nodeData, dirtAmount, true )
            end
        end
    end

```

### setNodeDirtAmount

**Description**

**Definition**

> setNodeDirtAmount()

**Arguments**

| any | nodeData   |
|-----|------------|
| any | dirtAmount |
| any | force      |

**Code**

```lua
function Washable:setNodeDirtAmount(nodeData, dirtAmount, force)
    local spec = self.spec_washable
    nodeData.dirtAmount = math.clamp(dirtAmount, 0 , 1 )

    local diff = nodeData.dirtAmountSent - nodeData.dirtAmount
    if math.abs(diff) > Washable.SEND_THRESHOLD or force or(nodeData.dirtAmount = = 0 and nodeData.dirtAmountSent ~ = 0 ) then
        for node, _ in pairs(nodeData.nodes) do
            setShaderParameter(node, "scratches_dirt_snow_wetness" , nil , nodeData.dirtAmount, nil , nil , false )
        end

        for node, _ in pairs(nodeData.mudNodes) do
            g_animationManager:setPrevShaderParameter(node, "mudAmount" , nodeData.dirtAmount, 0 , 0 , 0 , false , "prevMudAmount" )
        end

        if self.isServer then
            self:raiseDirtyFlags(spec.dirtyFlag)
            nodeData.dirtAmountSent = nodeData.dirtAmount
        end
    end
end

```

### setNodeDirtColor

**Description**

**Definition**

> setNodeDirtColor()

**Arguments**

| any | nodeData |
|-----|----------|
| any | r        |
| any | g        |
| any | b        |
| any | force    |

**Code**

```lua
function Washable:setNodeDirtColor(nodeData, r, g, b, force)
    local spec = self.spec_washable
    local cr, cg, cb = nodeData.color[ 1 ], nodeData.color[ 2 ], nodeData.color[ 3 ]
    if ( math.abs(r - cr) > Washable.SEND_THRESHOLD or math.abs(g - cg) > Washable.SEND_THRESHOLD or math.abs(b - cb) > Washable.SEND_THRESHOLD) or force then
        for node, _ in pairs(nodeData.nodes) do
            setShaderParameter(node, "dirtColor" , r, g, b, nil , false )
        end

        for node, _ in pairs(nodeData.mudNodes) do
            setShaderParameter(node, "dirtColor" , r, g, b, nil , false )
        end

        nodeData.color[ 1 ], nodeData.color[ 2 ], nodeData.color[ 3 ] = r, g, b

        if self.isServer then
            self:raiseDirtyFlags(spec.dirtyFlag)
            nodeData.colorChanged = true
        end
    end
end

```

### setNodeWetness

**Description**

**Definition**

> setNodeWetness()

**Arguments**

| any | nodeData |
|-----|----------|
| any | wetness  |
| any | force    |

**Code**

```lua
function Washable:setNodeWetness(nodeData, wetness, force)
    local spec = self.spec_washable
    nodeData.wetness = math.clamp(wetness, 0 , 1 )

    local diff = nodeData.wetnessSent - nodeData.wetness
    if math.abs(diff) > Washable.SEND_THRESHOLD_WETNESS or force then
        for node, useWetness in pairs(nodeData.nodes) do
            if useWetness then
                setShaderParameter(node, "scratches_dirt_snow_wetness" , nil , nil , nil , nodeData.wetness, false )
            end
        end

        for node, useWetness in pairs(nodeData.mudNodes) do
            if useWetness then
                setShaderParameter(node, "wetness" , nodeData.wetness, nil , nil , nil , false )
            end
        end

        if self.isServer then
            self:raiseDirtyFlags(spec.dirtyFlag)
            nodeData.wetnessSent = nodeData.wetness
        end
    end
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
function Washable:updateDebugValues(values)
    local spec = self.spec_washable
    if spec.washableNodes ~ = nil then
        local allowsWashingByRain = self:getAllowsWashingByType( Washable.WASHTYPE_RAIN)
        local rainScale, timeSinceLastRain, temperature = 0 , 0 , 0
        if allowsWashingByRain then
            local weather = g_currentMission.environment.weather
            rainScale = weather:getRainFallScale()
            timeSinceLastRain = weather:getTimeSinceLastRain()
            temperature = weather:getCurrentTemperature()
        end

        local isRaining = rainScale > 0.1 and timeSinceLastRain < 30 and temperature > 0
        local changeWetness = 0
        if isRaining then
            changeWetness = 3600000 * spec.wetDuration * ( 1 + math.min( self.lastSpeed * 3600 / 10 , 1 ))
        end

        table.insert(values, { name = "Dirt Multiplier" , value = string.format( "%.3f" , self:getDirtMultiplier()) } )

        for i, nodeData in ipairs(spec.washableNodes) do

            local changedAmountDirt, changedAmountWetness = nodeData.updateFunc( self , nodeData, 3600000 , allowsWashingByRain, rainScale, timeSinceLastRain, temperature)

            if not isRaining then
                local dirtFactor = ( 1 - nodeData.dirtAmount) * 0.5 + 0.5 -- vehicle drys slower if completely dirty
                    changedAmountWetness = changedAmountWetness - 3600000 * spec.dryDuration * dirtFactor * ( 1 + math.min( self.lastSpeed * 3600 / 10 , 1 ))
                else
                        changedAmountWetness = changedAmountWetness + changeWetness
                    end

                    table.insert(values, { name = "WashableNode" .. i, value = string.format( "%.4f a/h(%.2f) (color %.2f %.2f %.2f) (wetness: %.2f , %.4f a/min)" , changedAmountDirt, spec.washableNodes[i].dirtAmount, nodeData.color[ 1 ], nodeData.color[ 2 ], nodeData.color[ 3 ], nodeData.wetness, changedAmountWetness / 60 ) } )
                end
            end
        end

```

### updateDirtAmount

**Description**

**Definition**

> updateDirtAmount()

**Arguments**

| any | nodeData            |
|-----|---------------------|
| any | dt                  |
| any | allowsWashingByRain |
| any | rainScale           |
| any | timeSinceLastRain   |
| any | temperature         |

**Code**

```lua
function Washable:updateDirtAmount(nodeData, dt, allowsWashingByRain, rainScale, timeSinceLastRain, temperature)
    local spec = self.spec_washable
    local changeDirt, changeWetness = 0 , 0
    local dirtMultiplier = spec.lastDirtMultiplier

    if allowsWashingByRain then
        if rainScale > 0.1 and timeSinceLastRain < 30 and temperature > 0 then
            if nodeData.dirtAmount > 0.5 and( not self:getIsOnField() or self:getLastSpeed() < 1 ) then
                changeDirt = - (dt / spec.rainWashDuration)
            end
        end
    end

    if temperature > 0 and rainScale > 0.1 and timeSinceLastRain < 30 then
        dirtMultiplier = dirtMultiplier * 2.5
    end

    if dirtMultiplier ~ = 0 then
        changeDirt = dt * spec.dirtDuration * dirtMultiplier
    end

    return changeDirt, changeWetness
end

```

### updateWetness

**Description**

**Definition**

> updateWetness()

**Arguments**

| any | isRaining |
|-----|-----------|
| any | dt        |

**Code**

```lua
function Washable:updateWetness(isRaining, dt)
    local spec = self.spec_washable

    local changeWetness
    if isRaining then
        changeWetness = dt * spec.wetDuration * ( 1 + math.min( self.lastSpeed * 3600 / 10 , 1 ))
    end

    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]

        if not isRaining then
            local dirtFactor = ( 1 - nodeData.dirtAmount) * 0.5 + 0.5 -- vehicle drys slower if completely dirty
                changeWetness = - dt * spec.dryDuration * dirtFactor * ( 1 + math.min( self.lastSpeed * 3600 / 10 , 1 ))
            end

            self:setNodeWetness(nodeData, nodeData.wetness + changeWetness)
        end
    end

```

### validateWashableNode

**Description**

**Definition**

> validateWashableNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Washable:validateWashableNode(node)
    return true , nil -- by default all nodes are global
end

```

### writeWashableNodeData

**Description**

**Definition**

> writeWashableNodeData()

**Arguments**

| any | self       |
|-----|------------|
| any | streamId   |
| any | connection |

**Code**

```lua
function Washable.writeWashableNodeData( self , streamId, connection)
    local spec = self.spec_washable
    for i = 1 , #spec.washableNodes do
        local nodeData = spec.washableNodes[i]
        streamWriteUIntN(streamId, math.floor(nodeData.dirtAmount * Washable.SEND_MAX_VALUE + 0.5 ), Washable.SEND_NUM_BITS)
        streamWriteUIntN(streamId, math.floor(nodeData.wetness * Washable.SEND_MAX_VALUE_WETNESS + 0.5 ), Washable.SEND_NUM_BITS_WETNESS)

        streamWriteBool(streamId, nodeData.colorChanged)
        if nodeData.colorChanged then
            streamWriteUIntN(streamId, math.floor(nodeData.color[ 1 ] * Washable.SEND_MAX_VALUE + 0.5 ), Washable.SEND_NUM_BITS)
            streamWriteUIntN(streamId, math.floor(nodeData.color[ 2 ] * Washable.SEND_MAX_VALUE + 0.5 ), Washable.SEND_NUM_BITS)
            streamWriteUIntN(streamId, math.floor(nodeData.color[ 3 ] * Washable.SEND_MAX_VALUE + 0.5 ), Washable.SEND_NUM_BITS)
            nodeData.colorChanged = false
        end
    end
end

```