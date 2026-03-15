## StaticLightCompound

**Description**

> Class for static light compounds which combine multiple lights into one object and select the function via UV slots

**Functions**

- [loadFromXML](#loadfromxml)
- [loadFunctionMappingData](#loadfunctionmappingdata)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setLightTypes](#setlighttypes)
- [setLightTypesMask](#setlighttypesmask)
- [setOverwriteSettings](#setoverwritesettings)

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | baseKey     |
| any | components  |
| any | i3dMappings |
| any | vehicle     |
| any | sharedLight |

**Code**

```lua
function StaticLightCompound:loadFromXML(xmlFile, baseKey, components, i3dMappings, vehicle, sharedLight)
    self.bottomLightAsHighBeam = xmlFile:getValue(baseKey .. "#bottomLightAsHighBeam" , true )
    self.topLightAsHighBeam = xmlFile:getValue(baseKey .. "#topLightAsHighBeam" , true )

    self.useSliderTurnLights = xmlFile:getValue(baseKey .. "#useSliderTurnLights" , false )

    self.intensity = { }

    -- default intensity scales by type
    self.intensity[StaticLightCompoundUVSlot.HIGH_BEAM] = 1.4 -- 25 * 1.4 = 35
    self.intensity[StaticLightCompoundUVSlot.DAY_TIME_RUNNING_LIGHT] = 0.4 -- 25 * 0.4 = 10

    self.funcToUVSlotMapping = { }
    for index = 1 , 16 do
        self.funcToUVSlotMapping[index] = { }
    end

    local data = StaticLightCompound.loadFunctionMappingData(xmlFile, baseKey)
    for i, mappingData in ipairs(data) do
        table.insert( self.funcToUVSlotMapping[mappingData.defaultSlotIndex], mappingData)
    end

    if sharedLight ~ = nil and sharedLight.functionMappingData ~ = nil then
        -- clear the mapping data if there is a mapping for this slot already defined in the shared light
            -- otherwise we just assign multiple functions and are not able to overwrite
            for _, mappingData in ipairs(sharedLight.functionMappingData) do
                for mappedFuncIndex, mappedSlots in pairs( self.funcToUVSlotMapping) do
                    for i = #mappedSlots, 1 , - 1 do
                        local mappedSlot = mappedSlots[i]
                        if mappedSlot.uvSlotIndex = = mappingData.uvSlotIndex then
                            table.remove(mappedSlots, i)
                        end
                    end
                end
            end

            for i, mappingData in ipairs(sharedLight.functionMappingData) do
                table.insert( self.funcToUVSlotMapping[mappingData.defaultSlotIndex], mappingData)
            end
        end

        -- assign the default function if we don't have custom data defined for this slot
            for index = 1 , 16 do
                local uvSlotIsUsed = false
                for mappedFuncIndex, mappedSlots in pairs( self.funcToUVSlotMapping) do
                    for _, mappedSlot in pairs(mappedSlots) do
                        if mappedSlot.uvSlotIndex = = index then
                            uvSlotIsUsed = true
                            break
                        end
                    end

                    if uvSlotIsUsed then
                        break
                    end
                end

                if not uvSlotIsUsed then
                    table.insert( self.funcToUVSlotMapping[index], { uvSlotIndex = index, uvOffset = 0 , intensityScale = 1 } )
                end
            end

            self.nodes = { }
            for _, nodeKey in xmlFile:iterator(baseKey .. ".node" ) do
                local node = xmlFile:getValue(nodeKey .. "#node" , nil , components, i3dMappings)
                if node ~ = nil then
                    if sharedLight ~ = nil then
                        local isValid = false
                        local parent = node
                        while parent ~ = nil and parent ~ = 0 and parent ~ = getRootNode() do
                            if parent = = sharedLight.node then
                                isValid = true
                                break
                            end

                            parent = getParent(parent)
                        end

                        if not isValid then
                            Logging.xmlWarning(xmlFile, "Static compound light mesh '%s' is outside of the root shared light node(%s) in '%s'" , getName(node), getName(sharedLight.node), baseKey)
                            continue
                        end
                    end

                    if getHasClassId(node, ClassIds.LIGHT_SOURCE) then
                        Logging.xmlWarning(xmlFile, "Light source used in static light compound in '%s'" , nodeKey)
                        continue
                    end

                    if not getHasClassId(node, ClassIds.SHAPE) then
                        Logging.xmlWarning(xmlFile, "Node used in static light compound in '%s' is not a shape" , nodeKey)
                        continue
                    end

                    if not getHasShaderParameter(node, "lightIds0" ) then
                        Logging.xmlWarning(xmlFile, "Wrong shader applied to static light compound in '%s'.Missing 'lightIds' shader parameter." , nodeKey)
                        continue
                    else
                            setShaderParameter(node, "lightIds0" , 0 , 0 , 0 , 0 , false )
                            setShaderParameter(node, "lightIds1" , 0 , 0 , 0 , 0 , false )
                            setShaderParameter(node, "lightIds2" , 0 , 0 , 0 , 0 , false )
                            setShaderParameter(node, "lightIds3" , 0 , 0 , 0 , 0 , false )
                        end

                        local nodeData = { }
                        nodeData.node = node
                        nodeData.intensity = xmlFile:getValue(nodeKey .. "#intensity" , 5 )

                        nodeData.useSliderTurnLights = xmlFile:getValue(nodeKey .. "#useSliderTurnLights" , self.useSliderTurnLights)

                        -- additional attributes are not supported inside shared lights
                        if vehicle ~ = nil then
                            if xmlFile:getRootName() = = "vehicle" then
                                vehicle:loadAdditionalLightAttributesFromXML(xmlFile, nodeKey, nodeData)
                            end
                        end

                        if sharedLight ~ = nil then
                            if sharedLight.additionalAttributes ~ = nil then
                                for k, v in pairs(sharedLight.additionalAttributes) do
                                    nodeData[k] = v
                                end
                            end
                        end

                        table.insert( self.nodes, nodeData)
                    else
                            Logging.xmlWarning(xmlFile, "Invalid node in '%s'" , nodeKey)
                        end
                    end

                    if # self.nodes = = 0 then
                        Logging.xmlWarning(xmlFile, "Missing nodes for static light compound in '%s'" , baseKey)
                            return false
                        end

                        self.states = { }
                        self.stateFuncTypes = { }
                        self.stateLightTypes = { }
                        self.stateUVOffsets = { }
                        for i = 1 , 16 do
                            table.insert( self.states, 0 )
                            table.insert( self.stateFuncTypes, 0 )
                            table.insert( self.stateLightTypes, - 1 )
                            table.insert( self.stateUVOffsets, 0 )
                        end

                        return true
                    end

```

### loadFunctionMappingData

**Description**

**Definition**

> loadFunctionMappingData()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | baseKey |

**Code**

```lua
function StaticLightCompound.loadFunctionMappingData(xmlFile, baseKey)
    local data = { }
    for _, functionKey in xmlFile:iterator(baseKey .. ".function" ) do
        local functionName = xmlFile:getValue(functionKey .. "#name" )
        if functionName ~ = nil then
            local defaultSlotIndex = StaticLightCompoundUVSlot.getByName(functionName)
            if defaultSlotIndex ~ = nil then
                local uvSlotIndex = xmlFile:getValue(functionKey .. "#uvSlotIndex" , defaultSlotIndex)
                if uvSlotIndex > = 1 and uvSlotIndex < = 16 then
                    local uvOffset = xmlFile:getValue(functionKey .. "#uvOffset" , 0 )
                    local intensityScale = xmlFile:getValue(functionKey .. "#intensityScale" , 1 )

                    local lightTypeStr = xmlFile:getValue(functionKey .. "#lightType" )
                    local lightTypeIndex = StaticLightCompoundLightType.getByName(lightTypeStr)

                    table.insert(data, { defaultSlotIndex = defaultSlotIndex, uvSlotIndex = uvSlotIndex, uvOffset = uvOffset, intensityScale = intensityScale, lightTypeIndex = lightTypeIndex } )
                else
                        Logging.xmlWarning(xmlFile, "UV slot index out of range '%d' in '%s'.Range 1-16 is allowed." , uvSlotIndex, functionKey)
                    end
                else
                        Logging.xmlWarning(xmlFile, "Invalid function name '%s' in '%s'" , functionName, functionKey)
                        end
                    else
                            Logging.xmlWarning(xmlFile, "Missing function name in '%s'" , functionKey)
                            end
                        end

                        return data
                    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle  |
|-----|----------|
| any | customMt |

**Code**

```lua
function StaticLightCompound.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or StaticLightCompound _mt)

    self.vehicle = vehicle

    return self
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
function StaticLightCompound.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.BOOL, basePath .. "#bottomLightAsHighBeam" , "Use bottom light as high beam as well" , true )
    schema:register(XMLValueType.BOOL, basePath .. "#topLightAsHighBeam" , "Use top light as high beam as well" , true )
    schema:register(XMLValueType.BOOL, basePath .. "#useSliderTurnLights" , "Turn lights will work as sliders if set to 'true'" , false )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".node(?)#node" , "Static light node" )
        schema:register(XMLValueType.FLOAT, basePath .. ".node(?)#intensity" , "Intensity for all lights in this node" , 5 )
            schema:register(XMLValueType.BOOL, basePath .. ".node(?)#useSliderTurnLights" , "Turn lights will work as sliders if set to 'true'" , false )
                schema:register(XMLValueType.INT, basePath .. ".node(?)#lightTypeBitMask" , "Custom light type bit mask" )

                schema:register(XMLValueType.STRING, basePath .. ".function (?)#name" , "Function name" , nil , nil , StaticLightCompoundUVSlot.getAllOrderedByName())
                    schema:register(XMLValueType.INT, basePath .. ".function (?)#uvSlotIndex" , "Custom UV slot index to assign the defined function name" )
                        schema:register(XMLValueType.INT, basePath .. ".function (?)#uvOffset" , "Vertical UV offset that is used while this light function is active(value range:0-64 -> this represents the height of the texture with a resolution of 1/64).This is used for double usage of certain lights with different colors." , 0 )
                            schema:register(XMLValueType.FLOAT, basePath .. ".function (?)#intensityScale" , "Custom intensity scale for this light type(is multiplied by the intensity defined in the node)" )
                                schema:register(XMLValueType.STRING, basePath .. ".function (?)#lightType" , "Name of the light type to use" , nil , nil , StaticLightCompoundLightType.getAllOrderedByName())

                                    schema:register(XMLValueType.INT, basePath .. "#lightTypeBitMask" , "Custom light type bit mask" , "Default mask is '20480' with blinking type set for turn light slots 7 & 8" )
                                    end

```

### setLightTypes

**Description**

**Definition**

> setLightTypes()

**Arguments**

| any | lightTypes         |
|-----|--------------------|
| any | excludedLightTypes |

**Code**

```lua
function StaticLightCompound:setLightTypes(lightTypes, excludedLightTypes)
    if lightTypes ~ = nil and next(lightTypes) ~ = nil then
        self.lightTypes = lightTypes
    end

    if excludedLightTypes ~ = nil and next(excludedLightTypes) ~ = nil then
        self.excludedLightTypes = excludedLightTypes
    end
end

```

### setLightTypesMask

**Description**

**Definition**

> setLightTypesMask()

**Arguments**

| any | lightsTypesMask |
|-----|-----------------|
| any | vehicle         |

**Code**

```lua
function StaticLightCompound:setLightTypesMask(lightsTypesMask, vehicle)
    local startIndex = 1
    if self.lightTypes ~ = nil then
        local isActive = false
        for _, lightType in pairs( self.lightTypes) do
            if bit32.band(lightsTypesMask, 2 ^ lightType) ~ = 0 then
                isActive = true
                break
            end
        end

        if isActive and self.excludedLightTypes ~ = nil then
            for _, excludedLightType in pairs( self.excludedLightTypes) do
                if bit32.band(lightsTypesMask, 2 ^ excludedLightType) ~ = 0 then
                    isActive = false
                    break
                end
            end
        end

        self.states[ 1 ] = isActive and 1 or 0

        if self.turnLightLeft then
            self.stateFuncTypes[ 1 ] = StaticLightCompoundUVSlot.TURN_LIGHT_LEFT
        elseif self.turnLightRight then
                self.stateFuncTypes[ 1 ] = StaticLightCompoundUVSlot.TURN_LIGHT_RIGHT
            end

            startIndex = 2
        end

        for index = startIndex, 16 do
            self.states[index] = 0
            self.stateFuncTypes[index] = 0
            self.stateLightTypes[index] = - 1
            self.stateUVOffsets[index] = 0

            for mappedFuncIndex, mappedSlots in pairs( self.funcToUVSlotMapping) do
                for _, mappedSlot in pairs(mappedSlots) do
                    if mappedSlot.uvSlotIndex = = index then
                        local value = self:getStateValueByFunction(index, mappedFuncIndex, lightsTypesMask, vehicle)

                        if value > 0 then
                            self.states[index] = value * ( self.intensity[mappedFuncIndex] or 1 ) * mappedSlot.intensityScale

                            -- static light type can never overwrite blinking type(e.g.US back lights that are used as turn light as well)
                            if self.stateFuncTypes[index] ~ = StaticLightCompoundUVSlot.TURN_LIGHT_LEFT and self.stateFuncTypes[index] ~ = StaticLightCompoundUVSlot.TURN_LIGHT_RIGHT then
                                self.stateFuncTypes[index] = mappedFuncIndex
                            end

                            self.stateUVOffsets[index] = mappedSlot.uvOffset

                            if mappedSlot.lightTypeIndex ~ = nil then
                                self.stateLightTypes[index] = mappedSlot.lightTypeIndex
                            end

                            break
                        end
                    end
                end
            end
        end

        local lightTypesMask = self:getLightTypeMaskFromStates( self.useSliderTurnLights)
        local lightUvOffsetBitMask = self:getUVOffsetMaskFromStates()

        for i, nodeData in ipairs( self.nodes) do
            if vehicle:getIsLightActive(nodeData) then
                local intensity = nodeData.intensity
                setShaderParameter(nodeData.node, "lightIds0" , self.states[ 1 ] * intensity, self.states[ 2 ] * intensity, self.states[ 3 ] * intensity, self.states[ 4 ] * intensity, false )
                setShaderParameter(nodeData.node, "lightIds1" , self.states[ 5 ] * intensity, self.states[ 6 ] * intensity, self.states[ 7 ] * intensity, self.states[ 8 ] * intensity, false )
                setShaderParameter(nodeData.node, "lightIds2" , self.states[ 9 ] * intensity, self.states[ 10 ] * intensity, self.states[ 11 ] * intensity, self.states[ 12 ] * intensity, false )
                setShaderParameter(nodeData.node, "lightIds3" , self.states[ 13 ] * intensity, self.states[ 14 ] * intensity, self.states[ 15 ] * intensity, self.states[ 16 ] * intensity, false )

                if self.useSliderTurnLights ~ = nodeData.useSliderTurnLights then
                    local nodeLightTypesMask = self:getLightTypeMaskFromStates(nodeData.useSliderTurnLights)
                    setShaderParameter(nodeData.node, "lightTypeBitMask" , nodeLightTypesMask, nil , nil , nil , false )
                else
                        setShaderParameter(nodeData.node, "lightTypeBitMask" , lightTypesMask, nil , nil , nil , false )
                    end

                    setShaderParameter(nodeData.node, "lightUvOffsetBitMask" , lightUvOffsetBitMask, nil , nil , nil , false )
                else
                        setShaderParameter(nodeData.node, "lightIds0" , 0 , 0 , 0 , 0 , false )
                        setShaderParameter(nodeData.node, "lightIds1" , 0 , 0 , 0 , 0 , false )
                        setShaderParameter(nodeData.node, "lightIds2" , 0 , 0 , 0 , 0 , false )
                        setShaderParameter(nodeData.node, "lightIds3" , 0 , 0 , 0 , 0 , false )
                    end
                end
            end

```

### setOverwriteSettings

**Description**

**Definition**

> setOverwriteSettings()

**Arguments**

| any | turnLightLeft  |
|-----|----------------|
| any | turnLightRight |
| any | reverseLight   |

**Code**

```lua
function StaticLightCompound:setOverwriteSettings(turnLightLeft, turnLightRight, reverseLight)
    self.turnLightLeft = turnLightLeft
    self.turnLightRight = turnLightRight
    self.reverseLight = reverseLight

    if turnLightLeft then
        if self.lightTypes = = nil then
            self.lightTypes = { }
        end

        table.insert( self.lightTypes, self.vehicle.spec_lights.additionalLightTypes.turnLightLeft)
        table.insert( self.lightTypes, self.vehicle.spec_lights.additionalLightTypes.turnLightAny)
    end

    if turnLightRight then
        if self.lightTypes = = nil then
            self.lightTypes = { }
        end

        table.insert( self.lightTypes, self.vehicle.spec_lights.additionalLightTypes.turnLightRight)
        table.insert( self.lightTypes, self.vehicle.spec_lights.additionalLightTypes.turnLightAny)
    end

    if reverseLight then
        if self.lightTypes = = nil then
            self.lightTypes = { }
        end

        table.insert( self.lightTypes, self.vehicle.spec_lights.additionalLightTypes.reverseLight)
    end
end

```