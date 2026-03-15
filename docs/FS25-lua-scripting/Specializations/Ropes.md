## Ropes

**Description**

> Specialization for vehicles with animated ropes

**Functions**

- [initSpecialization](#initspecialization)
- [loadAdjusterNode](#loadadjusternode)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostUpdate](#onpostupdate)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [updateAdjusterNodes](#updateadjusternodes)
- [updateRopes](#updateropes)

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Ropes.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Ropes" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.ropes.rope(?)#baseNode" , "Base node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.ropes.rope(?)#targetNode" , "Target node" )
    schema:register(XMLValueType.VECTOR_ 4 , "vehicle.ropes.rope(?)#baseParameters" , "Base parameters" )
    schema:register(XMLValueType.VECTOR_ 4 , "vehicle.ropes.rope(?)#targetParameters" , "Target parameters" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.ropes.rope(?).baseParameterAdjuster(?)#node" , "Adjuster node" )
    schema:register(XMLValueType.INT, "vehicle.ropes.rope(?).baseParameterAdjuster(?)#rotationAxis" , "Rotation axis" )
    schema:register(XMLValueType.VECTOR_ROT_ 2 , "vehicle.ropes.rope(?).baseParameterAdjuster(?)#rotationRange" , "Rotation range" )
    schema:register(XMLValueType.INT, "vehicle.ropes.rope(?).baseParameterAdjuster(?)#translationAxis" , "Translation axis" )
    schema:register(XMLValueType.VECTOR_ 2 , "vehicle.ropes.rope(?).baseParameterAdjuster(?)#translationRange" , "Translation range" )
    schema:register(XMLValueType.VECTOR_ 4 , "vehicle.ropes.rope(?).baseParameterAdjuster(?)#minTargetParameters" , "Min.target parameters" )
    schema:register(XMLValueType.VECTOR_ 4 , "vehicle.ropes.rope(?).baseParameterAdjuster(?)#maxTargetParameters" , "Max.target parameters" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.ropes.rope(?).targetParameterAdjuster(?)#node" , "Adjuster node" )
    schema:register(XMLValueType.INT, "vehicle.ropes.rope(?).targetParameterAdjuster(?)#rotationAxis" , "Rotation axis" )
    schema:register(XMLValueType.VECTOR_ROT_ 2 , "vehicle.ropes.rope(?).targetParameterAdjuster(?)#rotationRange" , "Rotation range" )
    schema:register(XMLValueType.INT, "vehicle.ropes.rope(?).targetParameterAdjuster(?)#translationAxis" , "Translation axis" )
    schema:register(XMLValueType.VECTOR_ 2 , "vehicle.ropes.rope(?).targetParameterAdjuster(?)#translationRange" , "Translation range" )
    schema:register(XMLValueType.VECTOR_ 4 , "vehicle.ropes.rope(?).targetParameterAdjuster(?)#minTargetParameters" , "Min.target parameters" )
    schema:register(XMLValueType.VECTOR_ 4 , "vehicle.ropes.rope(?).targetParameterAdjuster(?)#maxTargetParameters" , "Max.target parameters" )

    schema:setXMLSpecializationType()
end

```

### loadAdjusterNode

**Description**

**Definition**

> loadAdjusterNode()

**Arguments**

| any | adjusterNode |
|-----|--------------|
| any | xmlFile      |
| any | key          |

**Code**

```lua
function Ropes:loadAdjusterNode(adjusterNode, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node ~ = nil then
        adjusterNode.node = node

        adjusterNode.rotationAxis = xmlFile:getValue(key .. "#rotationAxis" , 1 )
        adjusterNode.rotationRange = xmlFile:getValue(key .. "#rotationRange" , nil , true )

        adjusterNode.translationAxis = xmlFile:getValue(key .. "#translationAxis" , 1 )
        adjusterNode.translationRange = xmlFile:getValue(key .. "#translationRange" , nil , true )

        adjusterNode.minTargetParameters = xmlFile:getValue(key .. "#minTargetParameters" , nil , true )
        if adjusterNode.minTargetParameters = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing minTargetParameters attribute in '%s'" , key)
            return false
        end

        adjusterNode.maxTargetParameters = xmlFile:getValue(key .. "#maxTargetParameters" , nil , true )
        if adjusterNode.maxTargetParameters = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing maxTargetParameters attribute in '%s'" , key)
            return false
        end

        return true
    else
            Logging.xmlWarning( self.xmlFile, "Missing node attribute in '%s'" , key)
        end

        return false
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
function Ropes:onLoad(savegame)
    local spec = self.spec_ropes

    if self.isClient then
        spec.ropes = { }

        for _ropeIndex, ropeKey in self.xmlFile:iterator( "vehicle.ropes.rope" ) do
            local entry = { }

            entry.baseNode = self.xmlFile:getValue(ropeKey .. "#baseNode" , nil , self.components, self.i3dMappings)
            entry.targetNode = self.xmlFile:getValue(ropeKey .. "#targetNode" , nil , self.components, self.i3dMappings)
            entry.baseParameters = self.xmlFile:getValue(ropeKey .. "#baseParameters" , nil , true )
            if entry.baseParameters = = nil then
                Logging.xmlWarning( self.xmlFile, "Missing values for '%s'" , ropeKey .. "#baseParameters" )
                    continue
                end
                entry.targetParameters = self.xmlFile:getValue(ropeKey .. "#targetParameters" , nil , true )
                if entry.targetParameters = = nil then
                    Logging.xmlWarning( self.xmlFile, "Missing values for '%s'" , ropeKey .. "#targetParameters" )
                        continue
                    end

                    setShaderParameter(entry.baseNode, "cv0" , entry.baseParameters[ 1 ], entry.baseParameters[ 2 ], entry.baseParameters[ 3 ], entry.baseParameters[ 4 ], false )
                    setShaderParameter(entry.baseNode, "cv1" , 0 , 0 , 0 , 0 , false )
                    local x,y,z = localToLocal(entry.targetNode, entry.baseNode, entry.targetParameters[ 1 ], entry.targetParameters[ 2 ], entry.targetParameters[ 3 ])
                    setShaderParameter(entry.baseNode, "cv3" , x, y, z, 0 , false )

                    entry.baseParameterAdjusters = { }

                    for _, adjusterKey in self.xmlFile:iterator(ropeKey .. "baseParameterAdjuster" ) do
                        local adjusterNode = { }
                        if self:loadAdjusterNode(adjusterNode, self.xmlFile, adjusterKey) then
                            table.insert(entry.baseParameterAdjusters, adjusterNode)
                        end
                    end

                    entry.targetParameterAdjusters = { }
                    for _, adjusterKey in self.xmlFile:iterator(ropeKey .. "targetParameterAdjuster" ) do
                        local adjusterNode = { }
                        if self:loadAdjusterNode(adjusterNode, self.xmlFile, adjusterKey) then
                            table.insert(entry.targetParameterAdjusters, adjusterNode)
                        end
                    end

                    table.insert(spec.ropes, entry)
                end
            end

            if not self.isClient or #spec.ropes = = 0 then
                SpecializationUtil.removeEventListener( self , "onLoadFinished" , Ropes )
                SpecializationUtil.removeEventListener( self , "onPostUpdate" , Ropes )
            end
        end

```

### onLoadFinished

**Description**

> Called on load finished

**Definition**

> onLoadFinished(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Ropes:onLoadFinished(savegame)
    self:updateRopes( 9999 )
end

```

### onPostUpdate

**Description**

> Called on post update

**Definition**

> onPostUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function Ropes:onPostUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    self:updateRopes(dt)
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
function Ropes:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    -- old function for backwards compatibility
        Ropes.onPostUpdate( self , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
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
function Ropes.prerequisitesPresent(specializations)
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
function Ropes.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Ropes )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Ropes )
    SpecializationUtil.registerEventListener(vehicleType, "onPostUpdate" , Ropes )
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
function Ropes.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadAdjusterNode" , Ropes.loadAdjusterNode)
    SpecializationUtil.registerFunction(vehicleType, "updateRopes" , Ropes.updateRopes)
    SpecializationUtil.registerFunction(vehicleType, "updateAdjusterNodes" , Ropes.updateAdjusterNodes)
end

```

### updateAdjusterNodes

**Description**

**Definition**

> updateAdjusterNodes()

**Arguments**

| any | adjusterNodes |
|-----|---------------|

**Code**

```lua
function Ropes:updateAdjusterNodes(adjusterNodes)
    local xRet, yRet, zRet = 0 , 0 , 0
    for _, adjusterNode in pairs(adjusterNodes) do
        if adjusterNode.rotationAxis ~ = nil and adjusterNode.rotationRange ~ = nil then
            local rotations = { getRotation(adjusterNode.node) }
            local rot = rotations[adjusterNode.rotationAxis]
            local alpha = math.max( 0 , math.min( 1 , (rot - adjusterNode.rotationRange[ 1 ]) / (adjusterNode.rotationRange[ 2 ] - adjusterNode.rotationRange[ 1 ]) ))
            local x, y, z = MathUtil.vector3ArrayLerp(adjusterNode.minTargetParameters, adjusterNode.maxTargetParameters, alpha)
            xRet, yRet, zRet = xRet + x, yRet + y, zRet + z
        elseif adjusterNode.translationAxis ~ = nil and adjusterNode.translationRange ~ = nil then
                local translations = { getTranslation(adjusterNode.node) }
                local trans = translations[adjusterNode.translationAxis]
                local alpha = math.max( 0 , math.min( 1 , (trans - adjusterNode.translationRange[ 1 ]) / (adjusterNode.translationRange[ 2 ] - adjusterNode.translationRange[ 1 ]) ))
                local x, y, z = MathUtil.vector3ArrayLerp(adjusterNode.minTargetParameters, adjusterNode.maxTargetParameters, alpha)
                xRet, yRet, zRet = xRet + x, yRet + y, zRet + z
            end
        end

        return xRet, yRet, zRet
    end

```

### updateRopes

**Description**

**Definition**

> updateRopes()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Ropes:updateRopes(dt)
    local spec = self.spec_ropes
    for _, rope in pairs(spec.ropes) do
        local x, y, z = self:updateAdjusterNodes(rope.baseParameterAdjusters)
        setShaderParameter(rope.baseNode, "cv0" , rope.baseParameters[ 1 ] + x, rope.baseParameters[ 2 ] + y, rope.baseParameters[ 3 ] + z, 0 , false )

        x, y, z = localToLocal(rope.targetNode, rope.baseNode, 0 , 0 , 0 )
        setShaderParameter(rope.baseNode, "cv2" , 0 , 0 , 0 , 0 , false )
        setShaderParameter(rope.baseNode, "cv3" , x, y, z, 0 , false )

        x, y, z = self:updateAdjusterNodes(rope.targetParameterAdjusters)
        x, y, z = localToLocal(rope.targetNode, rope.baseNode, rope.targetParameters[ 1 ] + x, rope.targetParameters[ 2 ] + y, rope.targetParameters[ 3 ] + z)
        setShaderParameter(rope.baseNode, "cv4" , x,y,z, 0 , false )
    end
end

```