## RealLight

**Description**

> Class for real light source control

**Functions**

- [consoleCommandDebugIES](#consolecommanddebugies)
- [finalize](#finalize)
- [getAreShadowsMergable](#getareshadowsmergable)
- [getMergedConeAngleSize](#getmergedconeanglesize)
- [loadFromXML](#loadfromxml)
- [loadLightsFromXML](#loadlightsfromxml)
- [merge](#merge)
- [new](#new)
- [onLightsProfileChanged](#onlightsprofilechanged)
- [registerXMLPaths](#registerxmlpaths)
- [setCharge](#setcharge)
- [setChargeFunction](#setchargefunction)
- [setIsBlinking](#setisblinking)
- [setLightTypesMask](#setlighttypesmask)
- [setState](#setstate)
- [updateIESProfile](#updateiesprofile)
- [updateLightScattering](#updatelightscattering)
- [updateMergedShadows](#updatemergedshadows)

### consoleCommandDebugIES

**Description**

**Definition**

> consoleCommandDebugIES()

**Arguments**

| any | _       |
|-----|---------|
| any | enabled |

**Code**

```lua
function RealLight.consoleCommandDebugIES(_, enabled)
    if RealLight.IES_DEBUG_ENABLED = = nil then
        local performanceClass = Utils.getPerformanceClassId()
        RealLight.IES_DEBUG_ENABLED = performanceClass = = GS_PROFILE_VERY_HIGH or performanceClass = = GS_PROFILE_ULTRA
    end

    if enabled ~ = nil then
        enabled = enabled = = "true"
    else
            enabled = not RealLight.IES_DEBUG_ENABLED
        end

        RealLight.IES_DEBUG_ENABLED = enabled

        if g_currentMission ~ = nil and g_localPlayer:getCurrentVehicle() ~ = nil then
            local vehicle = g_localPlayer:getCurrentVehicle()
            for i = 1 , #vehicle.childVehicles do
                local childVehicle = vehicle.childVehicles[i]
                Logging.info( "IES Profiles Enabled: '%s' on '%s'" , enabled, vehicle:getFullName())

                if childVehicle.spec_lights ~ = nil then
                    for _, profile in pairs(childVehicle.spec_lights.realLights) do
                        for _, lights in pairs(profile) do
                            for _, realLight in ipairs(lights) do
                                realLight:updateIESProfile(enabled)
                            end
                        end
                    end
                end
            end
        end
    end

```

### finalize

**Description**

**Definition**

> finalize()

**Code**

```lua
function RealLight:finalize()
    self:updateMergedShadows()
end

```

### getAreShadowsMergable

**Description**

> Returns true if all lights are in a 180deg lighting range and can be used for merged shadows

**Definition**

> getAreShadowsMergable()

**Arguments**

| any | lightSources |
|-----|--------------|

**Code**

```lua
function RealLight.getAreShadowsMergable(lightSources)
    for _, lightSource1 in ipairs(lightSources) do
        for _, lightSource2 in ipairs(lightSources) do
            if lightSource1 ~ = lightSource2 then
                local coneAngle = getLightConeAngle(lightSource2)

                local dx, dz = MathUtil.getDirectionFromYRotation(coneAngle * 0.5 )
                local lx, ly, lz = localDirectionToLocal(lightSource2, lightSource1, dx, 0 , - dz)

                local radius = math.sqrt(lx ^ 2 + ly ^ 2 )
                local angle = math.acos( math.abs(lz) / ( math.sqrt( math.abs(lz) ^ 2 + radius ^ 2 )))
                if lz > 0 then
                    angle = math.pi - angle
                end

                if angle + coneAngle * 0.5 > math.pi then
                    return false
                end

                dx, dz = MathUtil.getDirectionFromYRotation( - coneAngle * 0.5 )
                lx, ly, lz = localDirectionToLocal(lightSource2, lightSource1, dx, 0 , - dz)

                radius = math.sqrt(lx ^ 2 + ly ^ 2 )
                angle = math.acos( math.abs(lz) / ( math.sqrt( math.abs(lz) ^ 2 + radius ^ 2 )))
                if lz > 0 then
                    angle = math.pi - angle
                end

                if angle + coneAngle * 0.5 > math.pi then
                    return false
                end
            end
        end
    end

    return true
end

```

### getMergedConeAngleSize

**Description**

> Returns the max. cone angle if we merge the given lights sources together to one

**Definition**

> getMergedConeAngleSize()

**Arguments**

| any | lightSources |
|-----|--------------|

**Code**

```lua
function RealLight.getMergedConeAngleSize(lightSources)
    local mergedConeAngle = 0
    for _, lightSource1 in ipairs(lightSources) do
        for _, lightSource2 in ipairs(lightSources) do
            if lightSource1 ~ = lightSource2 then
                local coneAngle = getLightConeAngle(lightSource2)

                local dx, dz = MathUtil.getDirectionFromYRotation(coneAngle * 0.5 )
                local lx, ly, lz = localDirectionToLocal(lightSource2, lightSource1, dx, 0 , - dz)

                local radius = math.sqrt(lx ^ 2 + ly ^ 2 )
                local angle = math.acos( math.abs(lz) / ( math.sqrt( math.abs(lz) ^ 2 + radius ^ 2 )))
                if lz > 0 then
                    angle = math.pi - angle
                end

                mergedConeAngle = math.max(mergedConeAngle, (angle + coneAngle * 0.5 ))

                dx, dz = MathUtil.getDirectionFromYRotation( - coneAngle * 0.5 )
                lx, ly, lz = localDirectionToLocal(lightSource2, lightSource1, dx, 0 , - dz)

                radius = math.sqrt(lx ^ 2 + ly ^ 2 )
                angle = math.acos( math.abs(lz) / ( math.sqrt( math.abs(lz) ^ 2 + radius ^ 2 )))
                if lz > 0 then
                    angle = math.pi - angle
                end

                mergedConeAngle = math.max(mergedConeAngle, (angle + coneAngle * 0.5 ))
            end
        end
    end

    return mergedConeAngle
end

```

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

**Code**

```lua
function RealLight:loadFromXML(xmlFile, baseKey, components, i3dMappings, loadLightTypes)
    self.node = xmlFile:getValue(baseKey .. "#node" , nil , components, i3dMappings)
    if self.node = = nil then
        Logging.xmlWarning(xmlFile, "Missing light source node in '%s'" , baseKey)
        return false
    end

    if not getHasClassId( self.node, ClassIds.LIGHT_SOURCE) then
        Logging.xmlWarning(xmlFile, "Defined node is not a light source '%s'" , baseKey)
        return false
    end

    self.lightSources = { self.node }
    I3DUtil.iterateRecursively( self.node, function (childNode)
        if not getVisibility(childNode) then
            Logging.xmlWarning(xmlFile, "Real light source '%s' is hidden in '%s'!" , getName(childNode), baseKey)
        end

        if getHasClassId(childNode, ClassIds.LIGHT_SOURCE) then
            table.insert( self.lightSources, childNode)
        end
    end )

    self.defaultColor = self.defaultColor or { getLightColor( self.node) }
    self.intensityScale = xmlFile:getValue(baseKey .. "#intensityScale" , 1 )
    self.curIntensityScale = self.intensityScale

    setVisibility( self.node, false )

    if loadLightTypes ~ = false then
        self.lightTypes = xmlFile:getValue(baseKey .. "#lightTypes" , nil , true )
        self.excludedLightTypes = xmlFile:getValue(baseKey .. "#excludedLightTypes" , nil , true )
    end

    if self.lightTypes = = nil then
        self.lightTypes = { }
    end

    if self.excludedLightTypes = = nil then
        self.excludedLightTypes = { }
    end

    local lightsProfile = g_gameSettings:getValue(GameSettings.SETTING.LIGHTS_PROFILE)

    local xmlIESProfile = xmlFile:getValue(baseKey .. "#iesProfile" )
    if xmlIESProfile ~ = nil then
        self.xmlIESProfile = Utils.getFilename(xmlIESProfile, self.vehicle.baseDirectory)
    else
            local iesProfile = getLightIESProfile( self.lightSources[ 1 ])
            if iesProfile ~ = "" then
                self.xmlIESProfile = iesProfile
            end
        end

        self.useLightScattering = xmlFile:getValue(baseKey .. "#useLightScattering" )

        self:updateIESProfile(lightsProfile = = GS_PROFILE_VERY_HIGH or lightsProfile = = GS_PROFILE_ULTRA)
        self:updateLightScattering()

        self.hasMergedShadows = false

        self.hasShadows = xmlFile:getValue(baseKey .. "#hasShadows" , getLightRange( self.node) > 7.5 )
        if self.hasShadows then
            if # self.lightSources > 1 then
                local shadowLightOffset = xmlFile:getValue(baseKey .. "#shadowLightOffset" , nil , true )

                local x, y, z = 0 , 0 , 0
                local tx, ty, tz = 0 , 0 , 0
                local maxLightRange = 0
                local maxConeAngle = 0
                for i, lightSource in ipairs( self.lightSources) do
                    maxLightRange = math.max(maxLightRange, getLightRange(lightSource))
                    maxConeAngle = math.max(maxConeAngle, getLightConeAngle(lightSource))
                    local _x, _y, _z = localToLocal(lightSource, getParent( self.node), 0 , 0 , 0 )
                    x, y, z = x + _x, y + _y, z + _z

                    local _tx, _ty, _tz = localToLocal(lightSource, getParent( self.node), 0 , 0 , - 20 )
                    tx, ty, tz = tx + _tx, ty + _ty, tz + _tz
                end

                local numLightSources = # self.lightSources
                if numLightSources > 1 then
                    x, y, z = x / numLightSources, y / numLightSources, z / numLightSources
                    tx, ty, tz = tx / numLightSources, ty / numLightSources, tz / numLightSources
                end

                self.shadowLightSource = createLightSource(getName( self.node) .. "_shadow" , LightType.SPOT, 0.85 , 0.85 , 1 , maxLightRange)
                setLightConeAngle( self.shadowLightSource, math.max(maxConeAngle, RealLight.getMergedConeAngleSize( self.lightSources)))
                setLightShadowMap( self.shadowLightSource, true , 512 )
                setVisibility( self.shadowLightSource, false )

                link(getParent( self.node), self.shadowLightSource)
                setTranslation( self.shadowLightSource, x, y, z)

                setLightSoftShadowSize( self.shadowLightSource, 0.008 )
                setLightSoftShadowDistance( self.shadowLightSource, 15 )

                setLightSoftShadowDepthBiasFactor( self.shadowLightSource, 0.02 )

                local dx, dy, dz = MathUtil.vector3Normalize(tx - x, ty - y, tz - z)
                setDirection( self.shadowLightSource, - dx, - dy, - dz, 0 , 1 , 0 )

                if shadowLightOffset ~ = nil then
                    local ox, oy, oz = localToLocal( self.shadowLightSource, getParent( self.shadowLightSource), shadowLightOffset[ 1 ], shadowLightOffset[ 2 ], - shadowLightOffset[ 3 ])
                    setTranslation( self.shadowLightSource, ox, oy, oz)
                end

                for i, lightSource in ipairs( self.lightSources) do
                    setLightShadowMap(lightSource, true , 512 )
                end
            end
        end

        -- additional attributes are not supported inside shared lights
        if xmlFile:getRootName() = = "vehicle" then
            self.vehicle:loadAdditionalLightAttributesFromXML(xmlFile, baseKey, self )
        end

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

**Code**

```lua
function RealLight.loadLightsFromXML(lights, xmlFile, baseKey, vehicle, components, i3dMappings, loadLightTypes)
    if lights = = nil then
        lights = { }
    end

    for _, key in xmlFile:iterator(baseKey) do
        local light = RealLight.new(vehicle)
        if light:loadFromXML(xmlFile, key, components, i3dMappings, loadLightTypes) then
            local otherLight = vehicle:getRealLightFromNode(light.node)
            if otherLight ~ = nil then
                light = light:merge(otherLight)
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
function RealLight:merge(otherLight)
    -- add the light types and exluded light types from ourself to the other light
    -- and return the other light - so our instance is dropped, so we only have one RealLight instance per node

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
function RealLight.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or RealLight _mt)

    self.vehicle = vehicle

    self.chargeFunction = nil

    return self
end

```

### onLightsProfileChanged

**Description**

**Definition**

> onLightsProfileChanged()

**Arguments**

| any | lightsProfile |
|-----|---------------|

**Code**

```lua
function RealLight:onLightsProfileChanged(lightsProfile)
    self:updateIESProfile(lightsProfile = = GS_PROFILE_VERY_HIGH or lightsProfile = = GS_PROFILE_ULTRA)

    self:updateLightScattering()
    self:updateMergedShadows()
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
function RealLight.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Real light node" )

    schema:register(XMLValueType.FLOAT, basePath .. "#intensityScale" , "Additional scale of the light source intensity" , 1 )

    schema:register(XMLValueType.VECTOR_N, basePath .. "#excludedLightTypes" , "Excluded light types" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#lightTypes" , "Light types" )

    schema:register(XMLValueType.BOOL, basePath .. "#hasShadows" , "Defines if the light has shadows or not(Only in ULTRA game setting)" , "Automatically when range is greater 7.5m" )
        schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#shadowLightOffset" , "Offset of the shadow light calculation from the center of all light sources(in lighting direction)" )
        schema:register(XMLValueType.STRING, basePath .. "#iesProfile" , "Path to IES profile file(Only used in very high and above)" )
        schema:register(XMLValueType.BOOL, basePath .. "#useLightScattering" , "Defines if light scattering is used" , "automatically calculated based on lightType and range" )
        end

```

### setCharge

**Description**

**Definition**

> setCharge()

**Arguments**

| any | alpha |
|-----|-------|

**Code**

```lua
function RealLight:setCharge(alpha)
    alpha = alpha * self.curIntensityScale
    local color = self.defaultColor
    for _, lightSource in ipairs( self.lightSources) do
        setLightColor(lightSource, color[ 1 ] * alpha, color[ 2 ] * alpha, color[ 3 ] * alpha)
    end
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
function RealLight:setChargeFunction(func, funcTarget)
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
function RealLight:setIsBlinking(isBlinking)
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
function RealLight:setLightTypesMask(lightsTypesMask)
    if self.vehicle:getIsLightActive( self ) then
        local isActive, chargeScale = false , 1

        if self.lightTypes ~ = nil then
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
                else
                        isActive = false
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
function RealLight:setState(isActive, chargeScale)
    self:setCharge(chargeScale or(isActive and 1 or 0 ))
    setVisibility( self.node, isActive)
end

```

### updateIESProfile

**Description**

**Definition**

> updateIESProfile()

**Arguments**

| any | iesEnabled |
|-----|------------|

**Code**

```lua
function RealLight:updateIESProfile(iesEnabled)
    for i, lightSource in ipairs( self.lightSources) do
        local nodeName = string.lower(getName(lightSource))
        for searchString, profile in pairs( RealLight.DEFAULT_LIGHT_PROFILE) do
            if string.contains(nodeName, searchString) then
                if iesEnabled then
                    if self.xmlIESProfile ~ = nil then
                        -- xml profile overwrites the i3d setting completely
                        setLightIESProfile(lightSource, self.xmlIESProfile)
                    else
                            local iesProfile = getLightIESProfile(lightSource)
                            if iesProfile = = "" then
                                setLightIESProfile(lightSource, profile.iesProfile)
                            end
                        end
                    else
                            -- remove ies profiles that were set inside the i3d file
                            local iesProfile = getLightIESProfile(lightSource)
                            if iesProfile ~ = "" then
                                setLightIESProfile(lightSource, "" )
                                self.curIntensityScale = self.intensityScale
                            end
                        end

                        self.curIntensityScale = self.intensityScale * profile.intensityScale
                        break
                    end
                end
            end
        end

```

### updateLightScattering

**Description**

**Definition**

> updateLightScattering()

**Code**

```lua
function RealLight:updateLightScattering()
    local lightsProfile = g_gameSettings:getValue(GameSettings.SETTING.LIGHTS_PROFILE)

    local isDefaultLightOrHighBeam = false
    for i, lightType in ipairs( self.lightTypes) do
        if lightType = = Lights.LIGHT_TYPE_DEFAULT or lightType = = Lights.LIGHT_TYPE_HIGHBEAM then
            isDefaultLightOrHighBeam = true
            break
        end
    end

    for i, lightSource in ipairs( self.lightSources) do
        local useLightScattering = false

        if self.useLightScattering = = true then
            useLightScattering = lightsProfile > = GS_PROFILE_HIGH
        elseif self.useLightScattering = = nil then
                if isDefaultLightOrHighBeam then
                    useLightScattering = lightsProfile > = GS_PROFILE_HIGH
                else
                        -- only used typed lights like work lights etc
                        if # self.lightTypes > 0 then
                            useLightScattering = lightsProfile > = GS_PROFILE_VERY_HIGH
                        end
                    end

                    useLightScattering = useLightScattering and getLightRange(lightSource) > 7.5
                end

                if useLightScattering then
                    setLightUseLightScattering(lightSource, true )

                    local coneAngle = getLightConeAngle(lightSource)
                    if coneAngle > RealLight.SCATTERING_MAX_ANGLE then
                        setLightScatteringConeAngle(lightSource, RealLight.SCATTERING_MAX_ANGLE)
                    end

                    setLightScatteringIntensity(lightSource, 1 )
                else
                        if getLightUseLightScattering(lightSource) then
                            setLightUseLightScattering(lightSource, false )
                        end
                    end
                end
            end

```

### updateMergedShadows

**Description**

**Definition**

> updateMergedShadows()

**Code**

```lua
function RealLight:updateMergedShadows()
    if not self.hasShadows then
        return
    end

    local lightsProfile = g_gameSettings:getValue(GameSettings.SETTING.LIGHTS_PROFILE)
    if lightsProfile = = GS_PROFILE_ULTRA then
        if # self.lightSources > 1 then
            if not self.mergedShadowLightCreated then
                mergeLightShadows( table.unpack( self.lightSources))
                setMergedShadowSettingsLight( self.node, self.shadowLightSource)

                for _, component in ipairs( self.vehicle.components) do
                    addMergedShadowIgnoreShapes( self.lightSources[ 1 ], component.node)
                end

                self.mergedShadowLightCreated = true
            end

            for _, lightSource in ipairs( self.lightSources) do
                setLightShadowMap(lightSource, true , 512 )
                setLightShadowPriority( self.node, 1.0 )
            end

            setMergedShadowActive( self.node, true )
        else
                setLightShadowMap( self.node, true , 512 )
                setLightShadowPriority( self.node, 0.5 )

                for _, component in ipairs( self.vehicle.components) do
                    addLightShadowIgnoreShapes( self.lightSources[ 1 ], component.node)
                end
            end
        else
                if # self.lightSources > 1 then
                    setMergedShadowActive( self.node, false )

                    for _, lightSource in ipairs( self.lightSources) do
                        setLightShadowMap(lightSource, false , 512 )
                    end
                else
                        setLightShadowMap( self.node, false , 512 )
                    end
                end
            end

```