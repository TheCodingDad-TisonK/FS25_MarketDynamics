## ChainRollers

**Description**

> Specialization for roller chains that are controlled with a spline as position reference

**Functions**

- [initSpecialization](#initspecialization)
- [loadChainRollerFromXML](#loadchainrollerfromxml)
- [loadExtraDependentParts](#loadextradependentparts)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostUpdate](#onpostupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateChainRoller](#updatechainroller)
- [updateExtraDependentParts](#updateextradependentparts)

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function ChainRollers.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ChainRollers" )

    schema:register(XMLValueType.FLOAT, "vehicle.chainRollers#maxUpdateDistance" , "If the player is more than this distance away the nodes will no longer be updated" , 100 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.chainRollers.chainRoller(?)#elementsNode" , "Root node that contains every chain link" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.chainRollers.chainRoller(?)#endReferenceNode" , "Reference node for the alignment of the last chain link" )
        schema:register(XMLValueType.NODE_INDEX, "vehicle.chainRollers.chainRoller(?).splineNode(?)#node" , "Regular transform group(s) that define the spline(at least two have to be defined)" )

        schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
            cSchema:register(XMLValueType.NODE_INDICES, cKey .. ".chainRollers#splineNodes" , "Spline nodes to update" )
        end )

        schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
            cSchema:register(XMLValueType.NODE_INDICES, cKey .. ".chainRollers#splineNodes" , "Spline nodes to update" )
        end )

        schema:setXMLSpecializationType()
    end

```

### loadChainRollerFromXML

**Description**

**Definition**

> loadChainRollerFromXML()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | key         |
| any | chainRoller |

**Code**

```lua
function ChainRollers:loadChainRollerFromXML(xmlFile, key, chainRoller)
    local spec = self.spec_chainRollers

    chainRoller.elementsNode = xmlFile:getValue(key .. "#elementsNode" , nil , self.components, self.i3dMappings)
    if chainRoller.elementsNode = = nil then
        Logging.xmlWarning(xmlFile, "Missing 'elementsNode' for chainRoller '%s'!" , key)
            return false
        end

        chainRoller.elements = { }
        for i = 1 , getNumOfChildren(chainRoller.elementsNode) do
            local node = getChildAt(chainRoller.elementsNode, i - 1 )
            table.insert(chainRoller.elements, node)
        end

        chainRoller.numElements = #chainRoller.elements
        if chainRoller.numElements = = 0 then
            Logging.xmlWarning(xmlFile, "Missing elements inside 'elementsNode' for chainRoller '%s'!" , key)
                return false
            end

            chainRoller.endReferenceNode = xmlFile:getValue(key .. "#endReferenceNode" , nil , self.components, self.i3dMappings)

            chainRoller.splineNodes = { }
            xmlFile:iterate(key .. ".splineNode" , function (index, key)
                local splineNode = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                if splineNode = = nil then
                    Logging.xmlWarning(xmlFile, "Missing 'node' for chainRoller spline '%s'!" , key)
                        return false
                    end

                    table.insert(chainRoller.splineNodes, splineNode)
                end )

                if #chainRoller.splineNodes < 2 then
                    Logging.xmlWarning(xmlFile, "Missing spline nodes for chainRoller '%s', at least two are required!" , key)
                        return false
                    end

                    local editPoints = { }
                    for _, splineNode in pairs(chainRoller.splineNodes) do
                        local x, y, z = getTranslation(splineNode)
                        table.insert(editPoints, x)
                        table.insert(editPoints, y)
                        table.insert(editPoints, z)
                    end

                    chainRoller.spline = createSplineFromEditPoints(getParent(chainRoller.splineNodes[ 1 ]), editPoints, false , false )
                    setVisibility(chainRoller.spline, false )

                    for index, splineNode in pairs(chainRoller.splineNodes) do
                        spec.chainRollerSplineNodeToSpline[splineNode] = { chainRoller = chainRoller, spline = chainRoller.spline, index = index - 1 , isDirty = false }
                    end

                    chainRoller.isDirty = true

                    return true
                end

```

### loadExtraDependentParts

**Description**

**Definition**

> loadExtraDependentParts()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | baseName  |
| any | entry     |

**Code**

```lua
function ChainRollers:loadExtraDependentParts(superFunc, xmlFile, baseName, entry)
    if not superFunc( self , xmlFile, baseName, entry) then
        return false
    end

    local splineNodes = xmlFile:getValue(baseName .. ".chainRollers#splineNodes" , nil , self.components, self.i3dMappings, true )
    if splineNodes ~ = nil and #splineNodes > 0 then
        entry.chainRollerSplineNodes = splineNodes
    end

    return true
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
function ChainRollers:onLoad(savegame)
    local spec = self.spec_chainRollers

    if not self.xmlFile:hasProperty( "vehicle.chainRollers" ) then
        SpecializationUtil.removeEventListener( self , "onLoadFinished" , ChainRollers )
        SpecializationUtil.removeEventListener( self , "onPostUpdate" , ChainRollers )
        return
    end

    spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.chainRollers#maxUpdateDistance" , 100 )

    spec.chainRollers = { }
    spec.chainRollerSplineNodeToSpline = { }
    self.xmlFile:iterate( "vehicle.chainRollers.chainRoller" , function (index, key)
        local chainRoller = { }
        if self:loadChainRollerFromXML( self.xmlFile, key, chainRoller) then
            table.insert(spec.chainRollers, chainRoller)
        end
    end )

    if #spec.chainRollers = = 0 then
        SpecializationUtil.removeEventListener( self , "onLoadFinished" , ChainRollers )
        SpecializationUtil.removeEventListener( self , "onPostUpdate" , ChainRollers )
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
function ChainRollers:onLoadFinished(savegame)
    ChainRollers.onPostUpdate( self , 99999 , false , false , false )
end

```

### onPostUpdate

**Description**

**Definition**

> onPostUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function ChainRollers:onPostUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_chainRollers
    if self.currentUpdateDistance < spec.maxUpdateDistance then
        --#profile RemoteProfiler.zoneBeginN("ChainRollers:updateSplines")
        for splineNode, splineData in pairs(spec.chainRollerSplineNodeToSpline) do
            if splineData.isDirty then
                setSplineCV(splineData.spline, splineData.index, localToLocal(splineNode, splineData.spline, 0 , 0 , 0 ))
                splineData.isDirty = false
                splineData.chainRoller.isDirty = true
            end
        end
        --#profile RemoteProfiler.zoneEnd()

        for _, chainRoller in pairs(spec.chainRollers) do
            if chainRoller.isDirty then
                self:updateChainRoller(chainRoller, dt)
                chainRoller.isDirty = false
            end
        end

        if VehicleDebug.state = = VehicleDebug.DEBUG_ATTRIBUTES then
            for _, chainRoller in pairs(spec.chainRollers) do
                for i = 1 , #chainRoller.splineNodes - 1 do
                    local x1, y1, z1 = getWorldTranslation(chainRoller.splineNodes[i])
                    local x2, y2, z2 = getWorldTranslation(chainRoller.splineNodes[i + 1 ])
                    drawDebugLine(x1, y1, z1, 1 , 0 , 0 , x2, y2, z2, 1 , 0 , 0 , false )
                    drawDebugPoint(x1, y1, z1, 1 , 0 , 0 , 1 , false )
                    drawDebugPoint(x2, y2, z2, 1 , 0 , 0 , 1 , false )
                end

                for i = 0 , 99 do
                    local t = i / 100
                    local x1, y1, z1 = getSplinePosition(chainRoller.spline, t)
                    local x2, y2, z2 = getSplinePosition(chainRoller.spline, t + 0.01 )
                    drawDebugLine(x1, y1, z1, 0 , 1 , 0 , x2, y2, z2, 0 , 1 , 0 , false )
                end
            end
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
function ChainRollers.prerequisitesPresent(specializations)
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
function ChainRollers.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ChainRollers )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , ChainRollers )
    SpecializationUtil.registerEventListener(vehicleType, "onPostUpdate" , ChainRollers )
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
function ChainRollers.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadChainRollerFromXML" , ChainRollers.loadChainRollerFromXML)
    SpecializationUtil.registerFunction(vehicleType, "updateChainRoller" , ChainRollers.updateChainRoller)
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
function ChainRollers.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadExtraDependentParts" , ChainRollers.loadExtraDependentParts)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateExtraDependentParts" , ChainRollers.updateExtraDependentParts)
end

```

### updateChainRoller

**Description**

**Definition**

> updateChainRoller()

**Arguments**

| any | chainRoller |
|-----|-------------|
| any | dt          |

**Code**

```lua
function ChainRollers:updateChainRoller(chainRoller, dt)
    --#profile RemoteProfiler.zoneBeginN("ChainRollers:updateElements")
    local lastX, lastY, lastZ
    local lastElementNode
    for i = 1 , chainRoller.numElements do
        local elementNode = chainRoller.elements[i]

        local t = (i - 1 ) / (chainRoller.numElements - 1 )
        local x, y, z = getSplinePosition(chainRoller.spline, t)
        setWorldTranslation(elementNode, x, y, z)

        if lastX ~ = nil then
            local dx, dy, dz = MathUtil.vector3Normalize(x - lastX, y - lastY, z - lastZ)
            dx, dy, dz = worldDirectionToLocal(chainRoller.elementsNode, dx, dy, dz)
            setDirection(lastElementNode, dx, dy, dz, 0 , 1 , 0 )
        end

        lastX, lastY, lastZ = x, y, z
        lastElementNode = elementNode
    end

    if chainRoller.endReferenceNode ~ = nil then
        local lastElement = chainRoller.elements[chainRoller.numElements]
        local x, y, z = getWorldTranslation(chainRoller.endReferenceNode)
        local dx, dy, dz = MathUtil.vector3Normalize(x - lastX, y - lastY, z - lastZ)
        dx, dy, dz = worldDirectionToLocal(chainRoller.elementsNode, dx, dy, dz)
        setDirection(lastElement, dx, dy, dz, 0 , 1 , 0 )
    end
    --#profile RemoteProfiler.zoneEnd()
end

```

### updateExtraDependentParts

**Description**

**Definition**

> updateExtraDependentParts()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | part      |
| any | dt        |

**Code**

```lua
function ChainRollers:updateExtraDependentParts(superFunc, part, dt)
    superFunc( self , part, dt)

    if part.chainRollerSplineNodes ~ = nil then
        local spec = self.spec_chainRollers
        for i = 1 , #part.chainRollerSplineNodes do
            local splineNode = part.chainRollerSplineNodes[i]
            local splineData = spec.chainRollerSplineNodeToSpline[splineNode]
            if splineData ~ = nil then
                splineData.isDirty = true
            end
        end
    end
end

```