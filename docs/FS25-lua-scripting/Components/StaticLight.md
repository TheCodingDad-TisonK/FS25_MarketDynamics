## StaticLight

**Description**

> Class for static light mesh control

**Functions**

- [loadFromXML](#loadfromxml)
- [loadLightsFromXML](#loadlightsfromxml)
- [merge](#merge)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)
- [setChargeFunction](#setchargefunction)
- [setIsBlinking](#setisblinking)
- [setLightTypesMask](#setlighttypesmask)
- [setState](#setstate)

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile        |
|-----|----------------|
| any | baseKey        |
| any | components     |
| any | i3dMappings    |
| any | loadLightTypes |
| any | sharedLight    |

**Code**

```lua
function StaticLight:loadFromXML(xmlFile, baseKey, components, i3dMappings, loadLightTypes, sharedLight)
    self.node = xmlFile:getValue(baseKey .. "#node" , nil , components, i3dMappings) or xmlFile:getValue(baseKey .. "#shaderNode" , nil , components, i3dMappings)
    if self.node = = nil then
        Logging.xmlWarning(xmlFile, "Missing static lights node in '%s'" , baseKey)
        return false
    end

    if getHasClassId( self.node, ClassIds.LIGHT_SOURCE) then
        Logging.xmlWarning(xmlFile, "Light source used in static light '%s'" , baseKey)
        return false
    end

    if not getHasClassId( self.node, ClassIds.SHAPE) then
        Logging.xmlWarning(xmlFile, "Node used in static light '%s' is not a shape" , baseKey)
        return false
    end

    if sharedLight ~ = nil then
        local isValid = false
        local parent = self.node
        while parent ~ = nil and parent ~ = 0 and parent ~ = getRootNode() do
            if parent = = sharedLight.node then
                isValid = true
                break
            end

            parent = getParent(parent)
        end

        if not isValid then
            Logging.xmlWarning(xmlFile, "Static light mesh '%s' is outside of the root shared light node(%s) in '%s'" , getName( self.node), getName(sharedLight.node), baseKey)
            return false
        end
    end

    self.useLightControlShaderParameter = getHasShaderParameter( self.node, "lightControl" )
    if not self.useLightControlShaderParameter then
        self.absUVSlotIndex = xmlFile:getValue(baseKey .. "#uvSlotIndex" )
        if self.absUVSlotIndex ~ = nil then
            self.uvSlotParameter = "lightIds0"
            self.uvSlotIndex = self.absUVSlotIndex

            if self.uvSlotIndex > 4 then
                self.uvSlotParameter = "lightIds1"
                self.uvSlotIndex = self.uvSlotIndex - 4
            end

            if self.uvSlotIndex > 4 then
                self.uvSlotParameter = "lightIds2"
                self.uvSlotIndex = self.uvSlotIndex - 4
            end

            if self.uvSlotIndex > 4 then
                self.uvSlotParameter = "lightIds3"
                self.uvSlotIndex = self.uvSlotIndex - 4
            end
        end
    end

    self.intensity = xmlFile:getValue(baseKey .. "#intensity" , 5 )

    self.toggleVisibility = xmlFile:getValue(baseKey .. "#toggleVisibility" , false )
    if self.toggleVisibility then
        setVisibility( self.node, false )
    else
            if not getHasShaderParameter( self.node, "lightControl" ) and not getHasShaderParameter( self.node, "lightIds0" ) then
                Logging.xmlWarning(xmlFile, "Static lights not using 'lightControl' or 'lightIds0' shader parameter in '%s'" , baseKey)
                return false
            end
        end

        if loadLightTypes ~ = false then
            self.lightTypes = xmlFile:getValue(baseKey .. "#lightTypes" , nil , true )
            self.excludedLightTypes = xmlFile:getValue(baseKey .. "#excludedLightTypes" , nil , true )

            -- overwrite the light types if custom light types are defined in the shared light definition
                if sharedLight ~ = nil then
                    if sharedLight.lightTypes ~ = nil then
                        self.lightTypes = table.clone(sharedLight.lightTypes, 1 )
                    end
                    if sharedLight.excludedLightTypes ~ = nil then
                        self.excludedLightTypes = table.clone(sharedLight.excludedLightTypes, 1 )
                    end
                end
            end

            if sharedLight ~ = nil then
                if sharedLight.additionalAttributes ~ = nil then
                    for k, v in pairs(sharedLight.additionalAttributes) do
                        self [k] = v
                    end
                end
            end

            if self.lightTypes = = nil then
                self.lightTypes = { }
            end

            if self.excludedLightTypes = = nil then
                self.excludedLightTypes = { }
            end

            -- additional attributes are not supported inside shared lights
            if self.vehicle ~ = nil then
                if xmlFile:getRootName() = = "vehicle" then
                    self.vehicle:loadAdditionalLightAttributesFromXML(xmlFile, baseKey, self )
                end
            end

            self:setState( false )

            return true
        end

```

### loadLightsFromXML

**Description**

**Definition**

> loadLightsFromXML()

**Arguments**

| any | lights         |
|-----|----------------|
| any | xmlFile        |
| any | baseKey        |
| any | vehicle        |
| any | components     |
| any | i3dMappings    |
| any | loadLightTypes |
| any | sharedLight    |

**Code**

```lua
function StaticLight.loadLightsFromXML(lights, xmlFile, baseKey, vehicle, components, i3dMappings, loadLightTypes, sharedLight)
    if lights = = nil then
        lights = { }
    end

    for _, key in xmlFile:iterator(baseKey) do
        local light = StaticLight.new(vehicle)
        if light:loadFromXML(xmlFile, key, components, i3dMappings, loadLightTypes, sharedLight) then
            if vehicle ~ = nil then
                local otherLight = vehicle:getStaticLightFromNode(light.node)
                if otherLight ~ = nil then
                    light = light:merge(otherLight)
                end
            end

            table.insert(lights, light)
        end
    end

    return lights
end

```

### merge

**Description**

**Definition**

> merge()

**Arguments**

| any | otherLight |
|-----|------------|

**Code**

```lua
function StaticLight:merge(otherLight)
    -- in case we are working with uv slot indices we only merge if we have the same index
        if self.uvSlotIndex ~ = nil then
            if self.uvSlotIndex ~ = otherLight.uvSlotIndex
                or self.uvSlotParameter ~ = otherLight.uvSlotParameter then
                return self
            end
        end

        -- add the light types and exluded light types from ourself to the other light
        -- and return the other light - so our instance is dropped, so we only have one StaticLight instance per node
        for i, lightType in ipairs( self.lightTypes) do
            table.addElement(otherLight.lightTypes, lightType)
        end

        for i, excludedLightType in ipairs( self.excludedLightTypes) do
            table.addElement(otherLight.excludedLightTypes, excludedLightType)
        end

        return otherLight
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
function StaticLight.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or StaticLight _mt)

    self.vehicle = vehicle

    self.chargeFunction = nil

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
function StaticLight.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Visual light node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#shaderNode" , "Shader node" )

    schema:register(XMLValueType.INT, basePath .. "#uvSlotIndex" , "UV slot if vehicleShader with 'lightIds' shader parameter is used(slot 1-16)" , "if not defined, all slots will be set equally" )

        schema:register(XMLValueType.FLOAT, basePath .. "#intensity" , "Intensity" , 5 )
        schema:register(XMLValueType.BOOL, basePath .. "#toggleVisibility" , "Toggle visibility" , false )

        schema:register(XMLValueType.VECTOR_N, basePath .. "#excludedLightTypes" , "Excluded light types" )
        schema:register(XMLValueType.VECTOR_N, basePath .. "#lightTypes" , "Light types" )
    end

```

### setChargeFunction

**Description**

**Definition**

> setChargeFunction()

**Arguments**

| any | func       |
|-----|------------|
| any | funcTarget |

**Code**

```lua
function StaticLight:setChargeFunction(func, funcTarget)
    self.chargeFunction, self.chargeFunctionTarget = func, funcTarget
end

```

### setIsBlinking

**Description**

**Definition**

> setIsBlinking()

**Arguments**

| any | isBlinking |
|-----|------------|

**Code**

```lua
function StaticLight:setIsBlinking(isBlinking)
    if not self.useLightControlShaderParameter then
        if self.absUVSlotIndex = = nil then
            local lightTypeBitMask = 0

            -- set all to blinking
            for i = 0 , 11 do
                lightTypeBitMask = bit32.bor(lightTypeBitMask, bit32.lshift(StaticLightCompoundLightType.BLINKING - 1 , i * 2 ))
            end

            setShaderParameter( self.node, "lightTypeBitMask" , lightTypeBitMask, nil , nil , nil , false )
        else
                if self.absUVSlotIndex < = 12 then
                    local lightTypeBitMask = getShaderParameter( self.node, "lightTypeBitMask" )

                    local bitIndex = ( self.absUVSlotIndex - 1 ) * 2
                    local mask = ( 2 ^ ( 12 * 2 ) - 1 ) - bit32.lshift(0x3, bitIndex)
                    lightTypeBitMask = bit32.band(lightTypeBitMask, mask) -- erase
                    lightTypeBitMask = bit32.bor(lightTypeBitMask, bit32.lshift(StaticLightCompoundLightType.BLINKING - 1 , bitIndex)) -- set to blinking
                    setShaderParameter( self.node, "lightTypeBitMask" , lightTypeBitMask, nil , nil , nil , false )
                end
            end
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

**Code**

```lua
function StaticLight:setLightTypesMask(lightsTypesMask)
    -- this function only works if any light types are defined, otherwise setState needs to be used
        if # self.lightTypes = = 0 then
            return
        end

        if self.vehicle = = nil then
            return
        end

        if self.vehicle:getIsLightActive( self ) then
            local isActive, chargeScale = false , nil

            for _, lightType in pairs( self.lightTypes) do
                if bit32.band(lightsTypesMask, 2 ^ lightType) ~ = 0 or(lightType = = - 1 and self.vehicle:getIsActiveForLights( true )) then
                    if not isActive then
                        isActive = true
                    else
                            -- if one base light type + one additional light type is enabled we increase the brightness(e.g.back and brake light)
                                if lightType > self.vehicle.spec_lights.maxLightState then
                                    chargeScale = 2
                                end
                            end
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

                    if self.chargeFunction ~ = nil then
                        chargeScale = self.chargeFunction( self.chargeFunctionTarget)
                    end

                    self:setState(isActive, chargeScale)
                else
                        self:setState( false , 0 )
                    end
                end

```

### setState

**Description**

**Definition**

> setState()

**Arguments**

| any | isActive    |
|-----|-------------|
| any | chargeScale |

**Code**

```lua
function StaticLight:setState(isActive, chargeScale)
    if self.toggleVisibility then
        setVisibility( self.node, isActive)
    else
            local lightCharge = chargeScale or(isActive and 1 or 0 )
            local intensity = self.intensity * lightCharge
            if self.useLightControlShaderParameter then
                setShaderParameter( self.node, "lightControl" , intensity, nil , nil , nil , false )
            else
                    if self.uvSlotIndex ~ = nil then
                        if self.uvSlotIndex = = 1 then
                            setShaderParameter( self.node, self.uvSlotParameter, intensity, nil , nil , nil , false )
                        elseif self.uvSlotIndex = = 2 then
                                setShaderParameter( self.node, self.uvSlotParameter, nil , intensity, nil , nil , false )
                            elseif self.uvSlotIndex = = 3 then
                                    setShaderParameter( self.node, self.uvSlotParameter, nil , nil , intensity, nil , false )
                                elseif self.uvSlotIndex = = 4 then
                                        setShaderParameter( self.node, self.uvSlotParameter, nil , nil , nil , intensity, false )
                                    end
                                else
                                        setShaderParameter( self.node, "lightIds0" , intensity, intensity, intensity, intensity, false )
                                        setShaderParameter( self.node, "lightIds1" , intensity, intensity, intensity, intensity, false )
                                        setShaderParameter( self.node, "lightIds2" , intensity, intensity, intensity, intensity, false )
                                        setShaderParameter( self.node, "lightIds3" , intensity, intensity, intensity, intensity, false )
                                    end
                                end
                            end
                        end

```