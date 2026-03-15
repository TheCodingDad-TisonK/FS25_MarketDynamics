## FoliageBending

**Description**

> Specialization enabling vehicles to bend/inflect foliage/plants on the map

**Functions**

- [activateBendingNodes](#activatebendingnodes)
- [deactivateBendingNodes](#deactivatebendingnodes)
- [getFoliageBendingNodeByIndex](#getfoliagebendingnodebyindex)
- [initSpecialization](#initspecialization)
- [loadBendingNodeFromXML](#loadbendingnodefromxml)
- [loadBendingNodeModifierFromXML](#loadbendingnodemodifierfromxml)
- [onActivate](#onactivate)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onPostLoad](#onpostload)
- [postInitSpecialization](#postinitspecialization)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)

### activateBendingNodes

**Description**

**Definition**

> activateBendingNodes()

**Code**

```lua
function FoliageBending:activateBendingNodes()
    local spec = self.spec_foliageBending
    for _, bendingNode in ipairs(spec.bendingNodes) do
        if bendingNode.isActive then
            if bendingNode.id = = nil and g_currentMission.foliageBendingSystem then
                bendingNode.id = g_currentMission.foliageBendingSystem:createRectangle(bendingNode.minX, bendingNode.maxX, bendingNode.minZ, bendingNode.maxZ, bendingNode.yOffset, bendingNode.node)
            end
        end
    end
end

```

### deactivateBendingNodes

**Description**

**Definition**

> deactivateBendingNodes()

**Code**

```lua
function FoliageBending:deactivateBendingNodes()
    local spec = self.spec_foliageBending
    if spec.bendingNodes ~ = nil then
        for _, bendingNode in ipairs(spec.bendingNodes) do
            if bendingNode.id ~ = nil then
                g_currentMission.foliageBendingSystem:destroyObject(bendingNode.id)
                bendingNode.id = nil
            end
        end
    end
end

```

### getFoliageBendingNodeByIndex

**Description**

**Definition**

> getFoliageBendingNodeByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function FoliageBending:getFoliageBendingNodeByIndex(index)
    return self.spec_foliageBending.bendingNodes[index]
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function FoliageBending.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FoliageBending" )

    local key = FoliageBending.BENDING_NODE_XML_KEY
    schema:register(XMLValueType.NODE_INDEX, key .. "#node" , "Bending node" )
    schema:register(XMLValueType.FLOAT, key .. "#minX" , "Min.width" )
    schema:register(XMLValueType.FLOAT, key .. "#maxX" , "Max.width" )
    schema:register(XMLValueType.FLOAT, key .. "#minZ" , "Min.length" )
    schema:register(XMLValueType.FLOAT, key .. "#maxZ" , "Max.length" )
    schema:register(XMLValueType.FLOAT, key .. "#yOffset" , "Y translation offset" )

    schema:setXMLSpecializationType()
end

```

### loadBendingNodeFromXML

**Description**

**Definition**

> loadBendingNodeFromXML()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | key         |
| any | bendingNode |

**Code**

```lua
function FoliageBending:loadBendingNodeFromXML(xmlFile, key, bendingNode)
    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node = = nil then
        node = self.rootNode
    end

    bendingNode.node = node
    bendingNode.key = key
    bendingNode.minX = xmlFile:getValue(key .. "#minX" , - 1 )
    bendingNode.maxX = xmlFile:getValue(key .. "#maxX" , 1 )
    bendingNode.minZ = xmlFile:getValue(key .. "#minZ" , - 1 )
    bendingNode.maxZ = xmlFile:getValue(key .. "#maxZ" , 1 )
    bendingNode.yOffset = xmlFile:getValue(key .. "#yOffset" , 0 )
    bendingNode.isActive = true

    return true
end

```

### loadBendingNodeModifierFromXML

**Description**

**Definition**

> loadBendingNodeModifierFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function FoliageBending:loadBendingNodeModifierFromXML(xmlFile, key)
    local modifier = { }

    modifier.index = xmlFile:getValue(key .. "#index" )
    modifier.indices = xmlFile:getValue(key .. "#indices" , nil , true )
    if modifier.index = = nil and modifier.indices = = nil then
        Logging.xmlWarning( self.xmlFile, "Missing bending node index for bending modifier '%s'" , key)
            return
        end

        modifier.indices = modifier.indices or { }
        if modifier.index ~ = nil then
            table.insert(modifier.indices, modifier.index)
        end

        modifier.minX = xmlFile:getValue(key .. "#minX" )
        modifier.maxX = xmlFile:getValue(key .. "#maxX" )
        modifier.minZ = xmlFile:getValue(key .. "#minZ" )
        modifier.maxZ = xmlFile:getValue(key .. "#maxZ" )
        modifier.yOffset = xmlFile:getValue(key .. "#yOffset" )
        modifier.isActive = xmlFile:getValue(key .. "#isActive" , true )
        modifier.overwrite = xmlFile:getValue(key .. "#overwrite" , true )

        local spec = self.spec_foliageBending
        if spec.bendingModifiers = = nil then
            spec.bendingModifiers = { }
        end

        table.insert(spec.bendingModifiers, modifier)
    end

```

### onActivate

**Description**

**Definition**

> onActivate()

**Code**

```lua
function FoliageBending:onActivate()
    self:activateBendingNodes()
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function FoliageBending:onDeactivate()
    self:deactivateBendingNodes()
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function FoliageBending:onDelete()
    self:deactivateBendingNodes()
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function FoliageBending:onPostLoad(savegame)
    local spec = self.spec_foliageBending

    spec.bendingNodes = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.foliageBending.bendingNode(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local bendingNode = { }
        if self:loadBendingNodeFromXML( self.xmlFile, key, bendingNode) then
            table.insert(spec.bendingNodes, bendingNode)
            bendingNode.index = #spec.bendingNodes
        end

        i = i + 1
    end

    for name, id in pairs( self.configurations) do
        local configDesc = g_vehicleConfigurationManager:getConfigurationDescByName(name)
        local key = string.format( "%s(%d).foliageBendingModifier" , configDesc.configurationKey, id - 1 )
        for _, modifierKey in self.xmlFile:iterator(key) do
            self:loadBendingNodeModifierFromXML( self.xmlFile, modifierKey)
        end
    end

    if spec.bendingModifiers ~ = nil then
        for _, modifier in ipairs(spec.bendingModifiers) do
            for _, modifierBendingNodeIndex in ipairs(modifier.indices) do
                local bendingNode = spec.bendingNodes[modifierBendingNodeIndex]
                if bendingNode ~ = nil then
                    if modifier.overwrite then
                        bendingNode.minX = modifier.minX or bendingNode.minX
                        bendingNode.maxX = modifier.maxX or bendingNode.maxX
                        bendingNode.minZ = modifier.minZ or bendingNode.minZ
                        bendingNode.maxZ = modifier.maxZ or bendingNode.maxZ
                        bendingNode.yOffset = modifier.yOffset or bendingNode.yOffset
                    else
                            bendingNode.minX = math.min(bendingNode.minX, modifier.minX or bendingNode.minX)
                            bendingNode.maxX = math.max(bendingNode.maxX, modifier.maxX or bendingNode.maxX)
                            bendingNode.minZ = math.min(bendingNode.minZ, modifier.minZ or bendingNode.minZ)
                            bendingNode.maxZ = math.max(bendingNode.maxZ, modifier.maxZ or bendingNode.maxZ)
                            bendingNode.yOffset = math.max(bendingNode.yOffset, modifier.yOffset or bendingNode.yOffset)
                        end

                        if not modifier.isActive then
                            bendingNode.isActive = false
                        end
                    else
                            Logging.xmlWarning( self.xmlFile, "Undefined bendingNode index '%d' for bending modifier '%s'!" , modifierBendingNodeIndex, modifier.key)
                            end
                        end
                    end

                    spec.bendingModifiers = nil
                end
            end

```

### postInitSpecialization

**Description**

**Definition**

> postInitSpecialization()

**Code**

```lua
function FoliageBending.postInitSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FoliageBending" )

    for name, configDesc in pairs(g_vehicleConfigurationManager:getConfigurations()) do
        local basePath = configDesc.configurationKey .. "(?)"

        schema:setXMLSharedRegistration( "foliageBendingModifier" , basePath)
        schema:register(XMLValueType.INT, basePath .. ".foliageBendingModifier(?)#index" , "Bending node index" )
        schema:register(XMLValueType.VECTOR_N, basePath .. ".foliageBendingModifier(?)#indices" , "Bending node indices" )
        schema:register(XMLValueType.FLOAT, basePath .. ".foliageBendingModifier(?)#minX" , "Min.width" )
        schema:register(XMLValueType.FLOAT, basePath .. ".foliageBendingModifier(?)#maxX" , "Max.width" )
        schema:register(XMLValueType.FLOAT, basePath .. ".foliageBendingModifier(?)#minZ" , "Min.length" )
        schema:register(XMLValueType.FLOAT, basePath .. ".foliageBendingModifier(?)#maxZ" , "Max.length" )
        schema:register(XMLValueType.FLOAT, basePath .. ".foliageBendingModifier(?)#yOffset" , "Y translation offset" )
        schema:register(XMLValueType.BOOL, basePath .. ".foliageBendingModifier(?)#isActive" , "Bending node is active" , true )
        schema:register(XMLValueType.BOOL, basePath .. ".foliageBendingModifier(?)#overwrite" , "Overwrite the bending node values and do not use the max values" , true )
            schema:resetXMLSharedRegistration( "foliageBendingModifier" , basePath)
        end

        schema:setXMLSpecializationType()
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
function FoliageBending.prerequisitesPresent(specializations)
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
function FoliageBending.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , FoliageBending )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , FoliageBending )
    SpecializationUtil.registerEventListener(vehicleType, "onActivate" , FoliageBending )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , FoliageBending )
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
function FoliageBending.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadBendingNodeFromXML" , FoliageBending.loadBendingNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadBendingNodeModifierFromXML" , FoliageBending.loadBendingNodeModifierFromXML)
    SpecializationUtil.registerFunction(vehicleType, "activateBendingNodes" , FoliageBending.activateBendingNodes)
    SpecializationUtil.registerFunction(vehicleType, "deactivateBendingNodes" , FoliageBending.deactivateBendingNodes)
    SpecializationUtil.registerFunction(vehicleType, "getFoliageBendingNodeByIndex" , FoliageBending.getFoliageBendingNodeByIndex)
end

```