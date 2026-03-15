## SharedLight

**Description**

> Class for shared lights

**Functions**

- [consoleCommandDebug](#consolecommanddebug)
- [delete](#delete)
- [loadFromVehicleXML](#loadfromvehiclexml)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onFinished](#onfinished)
- [onI3DLoaded](#oni3dloaded)
- [registerExternalXMLPaths](#registerexternalxmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [setCallback](#setcallback)
- [setLightTypes](#setlighttypes)
- [setRotationNodes](#setrotationnodes)

### consoleCommandDebug

**Description**

**Definition**

> consoleCommandDebug()

**Arguments**

| any | _              |
|-----|----------------|
| any | defaultLight   |
| any | brakeLight     |
| any | highBeam       |
| any | workLightBack  |
| any | workLightFront |
| any | turnLightLeft  |
| any | turnLeftRight  |
| any | reverseLight   |

**Code**

```lua
function SharedLight.consoleCommandDebug(_, defaultLight, brakeLight, highBeam, workLightBack, workLightFront, turnLightLeft, turnLeftRight, reverseLight)
    if SharedLight.debugRootNode = = nil then
        SharedLight.debugRootNode = createTransformGroup( "sharedLightDebugRoot" )
        link(getRootNode(), SharedLight.debugRootNode)

        local x, y, z = g_localPlayer:getPosition()
        local dirX, dirZ = g_localPlayer:getCurrentFacingDirection()

        x, z = x + dirX * 4 , z + dirZ * 4
        local ry = MathUtil.getYRotationFromDirection(dirX, dirZ)

        setWorldTranslation( SharedLight.debugRootNode, x, y, z)
        setWorldRotation( SharedLight.debugRootNode, 0 , ry, 0 )
    end

    if SharedLight.debugSharedLights ~ = nil then
        for _, light in ipairs( SharedLight.debugSharedLights) do
            light:delete()
            delete(light.linkNode)
        end
    end
    SharedLight.debugSharedLights = { }

    SharedLight.debugStaticLights = { }
    SharedLight.debugStaticLights.defaultLights = { }
    SharedLight.debugStaticLights.topLights = { }
    SharedLight.debugStaticLights.bottomLights = { }
    SharedLight.debugStaticLights.brakeLights = { }
    SharedLight.debugStaticLights.reverseLights = { }
    SharedLight.debugStaticLights.dayTimeLights = { }
    SharedLight.debugStaticLights.turnLightsLeft = { }
    SharedLight.debugStaticLights.turnLightsRight = { }

    local dummyVehicle = { }
    dummyVehicle.getIsPowered = function ( .. .) return true end
    dummyVehicle.getIsInShowroom = function ( .. .) return false end
    dummyVehicle.getIsLightActive = function ( .. .) return true end
    dummyVehicle.getIsActiveForLights = function ( .. .) return true end
    dummyVehicle.getStaticLightFromNode = function ( .. .) return nil end
    dummyVehicle.spec_lights = { }
    local spec = dummyVehicle.spec_lights
    spec.topLightsVisibility = false
    spec.maxLightState = Lights.LIGHT_TYPE_HIGHBEAM
    spec.additionalLightTypes = { }
    spec.additionalLightTypes.bottomLight = spec.maxLightState + 1
    spec.additionalLightTypes.topLight = spec.maxLightState + 2
    spec.additionalLightTypes.brakeLight = spec.maxLightState + 3
    spec.additionalLightTypes.turnLightLeft = spec.maxLightState + 4
    spec.additionalLightTypes.turnLightRight = spec.maxLightState + 5
    spec.additionalLightTypes.turnLightAny = spec.maxLightState + 6
    spec.additionalLightTypes.reverseLight = spec.maxLightState + 7
    spec.additionalLightTypes.interiorLight = spec.maxLightState + 8

    local lightTypeMask = 0
    local lightStates = { }
    lightStates[ Lights.LIGHT_TYPE_DEFAULT] = string.lower(defaultLight or "false" ) = = "true"
    lightStates[spec.additionalLightTypes.brakeLight] = string.lower(brakeLight or "false" ) = = "true"
    lightStates[ Lights.LIGHT_TYPE_HIGHBEAM] = string.lower(highBeam or "false" ) = = "true"
    lightStates[ Lights.LIGHT_TYPE_WORK_BACK] = string.lower(workLightBack or "false" ) = = "true"
    lightStates[ Lights.LIGHT_TYPE_WORK_FRONT] = string.lower(workLightFront or "false" ) = = "true"
    lightStates[spec.additionalLightTypes.turnLightLeft] = string.lower(turnLightLeft or "false" ) = = "true"
    lightStates[spec.additionalLightTypes.turnLightRight] = string.lower(turnLeftRight or "false" ) = = "true"
    lightStates[spec.additionalLightTypes.reverseLight] = string.lower(reverseLight or "false" ) = = "true"

    for bitIndex, value in pairs(lightStates) do
        if value then
            lightTypeMask = bit32.bor(lightTypeMask, bit32.lshift( 1 , bitIndex))
        end
    end

    local files = Files.getFilesRecursive(getAppBasePath() .. "data/shared/assets/lights" )
    table.sort(files, function (a, b)
        return a.path < b.path
    end )

    local rowIndex = 0
    local rowPosition = 0
    local lastBasePath = nil
    local lastName = nil
    local numLightsToLoad, numLightsToLoadTotal = 0 , 0
    local numLightsSuccess, numLightsFailed = 0 , 0
    for _, file in ipairs(files) do
        if not file.isDirectory then
            if file.filename:contains( ".xml" ) then
                numLightsToLoad = numLightsToLoad + 1
                numLightsToLoadTotal = numLightsToLoadTotal + 1

                local linkNode = createTransformGroup( "linkNode" )
                link( SharedLight.debugRootNode, linkNode)

                local name = file.filename
                name = string.gsub(name, "White" , "" )
                name = string.gsub(name, "Orange" , "" )
                name = string.gsub(name, "Red" , "" )
                name = string.gsub(name, "Reverse" , "" )
                name = string.gsub(name, ".xml" , "" )
                name = string.split(name, "_" )[ 1 ]
                name = string.gsub(name, "%d" , "" )

                local basePath = file.path:split(file.filename)[ 1 ]
                if basePath ~ = lastBasePath or name ~ = lastName then
                    rowIndex = rowIndex + 1
                    rowPosition = 0
                    lastBasePath = basePath
                    lastName = name

                    local wx, wy, wz = localToWorld( SharedLight.debugRootNode, rowIndex * 2 , 1 , - 1 )
                    local rx, ry, rz = localRotationToWorld( SharedLight.debugRootNode, - math.pi * 0.5 , math.pi, 0 )
                    g_debugManager:addElement( DebugText3D.new():createWithWorldPos(wx, wy, wz, rx, ry, rz, name, 0.15 ), nil , nil , math.huge)
                end

                local x = rowIndex * 2
                local y = 1
                local z = rowPosition

                rowPosition = rowPosition + 1

                setTranslation(linkNode, x, y, z)
                setRotation(linkNode, 0 , math.pi, 0 )

                local sharedLight = SharedLight.new(dummyVehicle, SharedLight.debugStaticLights)
                sharedLight:setCallback( function (success)
                    numLightsToLoad = numLightsToLoad - 1
                    if success then
                        numLightsSuccess = numLightsSuccess + 1
                        table.insert( SharedLight.debugSharedLights, sharedLight)
                    else
                            numLightsFailed = numLightsFailed + 1
                        end

                        if numLightsToLoad = = 0 then
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.topLights, spec.additionalLightTypes.topLight)
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.bottomLights, spec.additionalLightTypes.bottomLight)
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.brakeLights, spec.additionalLightTypes.brakeLight)
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.reverseLights, spec.additionalLightTypes.reverseLight)
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.turnLightsLeft, spec.additionalLightTypes.turnLightLeft, true )
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.turnLightsLeft, spec.additionalLightTypes.turnLightAny, true )
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.turnLightsRight, spec.additionalLightTypes.turnLightRight, true )
                            Lights.applyAdditionalActiveLightType(dummyVehicle, SharedLight.debugStaticLights.turnLightsRight, spec.additionalLightTypes.turnLightAny, true )

                            for _, staticLightsByType in pairs( SharedLight.debugStaticLights) do
                                for _, staticLight in ipairs(staticLightsByType) do
                                    staticLight:setLightTypesMask(lightTypeMask)
                                end
                            end

                            for _, _sharedLight in ipairs( SharedLight.debugSharedLights) do
                                if _sharedLight.staticLightCompound ~ = nil then
                                    _sharedLight.staticLightCompound:setLightTypesMask(lightTypeMask, dummyVehicle)
                                end
                            end

                            Logging.info( "%d Static lights: %d loaded, %d failed to load" , numLightsToLoadTotal, numLightsSuccess, numLightsFailed)
                        end
                    end )

                    local filename = string.gsub(file.path, getAppBasePath(), "" )
                    if sharedLight:loadFromXML(linkNode, filename, "" ) then
                        local wx, wy, wz = localToWorld(linkNode, 0 , 0 , - 0.2 )
                        local rx, ry, rz = localRotationToWorld(linkNode, - math.pi * 0.5 , 0 , 0 )
                        g_debugManager:addElement( DebugText3D.new():createWithWorldPos(wx, wy, wz, rx, ry, rz, file.filename, 0.07 ), nil , nil , math.huge)
                        g_debugManager:addElement( DebugGizmo.new():createWithNode(linkNode, "" , nil , nil , 0.1 ), nil , nil , math.huge)
                    end
                end
            end
        end

        BeaconLight.spawnDebugBeacons( SharedLight.debugRootNode)
    end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function SharedLight:delete()
    if self.xmlFile ~ = nil then
        self.xmlFile:delete()
        self.xmlFile = nil
    end

    if self.node ~ = nil then
        delete( self.node)
        self.node = nil
    end

    if self.sharedLoadRequestId ~ = nil then
        g_i3DManager:releaseSharedI3DFile( self.sharedLoadRequestId)
        self.sharedLoadRequestId = nil
    end
end

```

### loadFromVehicleXML

**Description**

**Definition**

> loadFromVehicleXML()

**Arguments**

| any | key           |
|-----|---------------|
| any | baseDirectory |
| any | callback      |

**Code**

```lua
function SharedLight:loadFromVehicleXML(key, baseDirectory, callback)
    local xmlFile = self.vehicle.xmlFile
    local xmlFilename = xmlFile:getValue(key .. "#filename" )
    if xmlFilename ~ = nil then
        xmlFilename = Utils.getFilename(xmlFilename, baseDirectory)

        local linkNode = xmlFile:getValue(key .. "#linkNode" , "0>" , self.vehicle.components, self.vehicle.i3dMappings)
        if linkNode = = nil then
            Logging.xmlWarning(xmlFile, "Missing light linkNode in '%s'!" , key)
            return
        else
                local isReference, filename, runtimeLoaded = getReferenceInfo(linkNode)
                if isReference and runtimeLoaded then
                    local xmlName = Utils.getFilenameInfo(xmlFilename, true )
                    local i3dName = Utils.getFilenameInfo(filename, true )

                    if xmlName ~ = i3dName then
                        Logging.xmlWarning(xmlFile, "Shared light '%s' loading different file from XML compared to i3D. (XML: %s vs i3D: %s)" , getName(linkNode), xmlName, i3dName)
                    end

                    Logging.xmlWarning(xmlFile, "Shared light link node '%s' is a runtime loaded reference.Please load functional lights via XML and non-functional(e.g.reflectors) as i3D reference, but not both!" , getName(linkNode))
                    return
                end

                if not getVisibility(linkNode) then
                    Logging.xmlWarning(xmlFile, "Shared light link node '%s' is hidden!" , getName(linkNode))
                    return
                end
            end

            local rotationNodes = { }
            for _, rotKey in xmlFile:iterator(key .. ".rotationNode" ) do
                local name = xmlFile:getValue(rotKey .. "#name" )
                if name ~ = nil then
                    rotationNodes[name] = xmlFile:getValue(rotKey .. "#rotation" , nil , true )
                end
            end

            local lightTypes = xmlFile:getValue(key .. "#lightTypes" , nil , true )
            local excludedLightTypes = xmlFile:getValue(key .. "#excludedLightTypes" , nil , true )

            self.reverseLight = xmlFile:getValue(key .. "#reverseLight" , self.reverseLight)
            self.turnLightLeft = xmlFile:getValue(key .. "#turnLightLeft" , self.turnLightLeft)
            self.turnLightRight = xmlFile:getValue(key .. "#turnLightRight" , self.turnLightRight)

            self.functionMappingData = StaticLightCompound.loadFunctionMappingData(xmlFile, key)

            self.additionalAttributes = { }
            self.vehicle:loadAdditionalLightAttributesFromXML(xmlFile, key, self.additionalAttributes)

            self:setRotationNodes(rotationNodes)
            self:setLightTypes(lightTypes, excludedLightTypes)
            self:setCallback( function (success)
                callback(success, success and self or nil )
            end )

            self:loadFromXML(linkNode, xmlFilename, baseDirectory)
        end
    end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | linkNode      |
|-----|---------------|
| any | xmlFilename   |
| any | baseDirectory |

**Code**

```lua
function SharedLight:loadFromXML(linkNode, xmlFilename, baseDirectory)
    self.xmlFile = XMLFile.loadIfExists( "sharedLight" , xmlFilename, SharedLight.xmlSchema)

    if self.xmlFile = = nil then
        -- check if there is a replacement after file rename
            for old, new in pairs( SharedLight.FS22_RENAMED_LIGHTS) do
                if xmlFilename:find(old) then
                    local newPath = xmlFilename:gsub(old, new)
                    if fileExists(newPath) then
                        if self.vehicle ~ = nil then
                            Logging.xmlWarning( self.vehicle.xmlFile, "Light has been renamed from '%s' to '%s'!" , old, new)
                        else
                                Logging.warning( "Light '%s' has been renamed to '%s' in '%s'!" , old, new)
                            end

                            self:onFinished( false )
                            return false
                        end
                    end
                end

                if self.vehicle ~ = nil then
                    Logging.xmlWarning( self.vehicle.xmlFile, "Unable to load shared lights from xml '%s'" , xmlFilename)
                else
                        Logging.warning( "Unable to load shared lights from xml '%s'" , xmlFilename)
                    end

                    self:onFinished( false )
                    return false
                end

                local filename = self.xmlFile:getValue( "light.filename" )
                if filename = = nil then
                    Logging.xmlWarning( self.xmlFile, "Missing light i3d filename!" )
                    self.xmlFile:delete()
                    self.xmlFile = nil

                    self:onFinished( false )
                    return false
                end

                self.filename = Utils.getFilename(filename, baseDirectory)
                self.linkNode = linkNode

                if self.vehicle ~ = nil and self.vehicle.loadSubSharedI3DFile ~ = nil then
                    self.sharedLoadRequestId = self.vehicle:loadSubSharedI3DFile( self.filename, false , false , self.onI3DLoaded, self , nil )
                else
                        self.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync( self.filename, false , false , self.onI3DLoaded, self , nil )
                    end

                    return true
                end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle      |
|-----|--------------|
| any | staticLights |
| any | customMt     |

**Code**

```lua
function SharedLight.new(vehicle, staticLights, customMt)
    local self = setmetatable( { } , customMt or SharedLight _mt)

    self.vehicle = vehicle
    self.staticLights = staticLights

    self.reverseLight = false
    self.turnLightLeft = false
    self.turnLightRight = false

    return self
end

```

### onFinished

**Description**

**Definition**

> onFinished()

**Arguments**

| any | success |
|-----|---------|

**Code**

```lua
function SharedLight:onFinished(success)
    if self.callback ~ = nil then
        if self.callbackTarget ~ = nil then
            self.callback( self.callbackTarget, success)
        else
                self.callback(success)
            end
        end
    end

```

### onI3DLoaded

**Description**

**Definition**

> onI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function SharedLight:onI3DLoaded(i3dNode, failedReason, args)
    if i3dNode ~ = 0 then
        self.node = self.xmlFile:getValue( "light.rootNode#node" , "0" , i3dNode)

        if self.node ~ = nil then
            if self.reverseLight then
                StaticLight.loadLightsFromXML( self.staticLights.reverseLights, self.xmlFile, "light.defaultLight" , self.vehicle, i3dNode, nil , false , self )
            elseif self.turnLightLeft then
                    StaticLight.loadLightsFromXML( self.staticLights.turnLightsLeft, self.xmlFile, "light.defaultLight" , self.vehicle, i3dNode, nil , false , self )
                elseif self.turnLightRight then
                        StaticLight.loadLightsFromXML( self.staticLights.turnLightsRight, self.xmlFile, "light.defaultLight" , self.vehicle, i3dNode, nil , false , self )
                    else
                            StaticLight.loadLightsFromXML( self.staticLights.defaultLights, self.xmlFile, "light.defaultLight" , self.vehicle, i3dNode, nil , true , self )
                        end

                        StaticLight.loadLightsFromXML( self.staticLights.topLights, self.xmlFile, "light.topLight" , self.vehicle, i3dNode, nil , false , self )
                        StaticLight.loadLightsFromXML( self.staticLights.bottomLights, self.xmlFile, "light.bottomLight" , self.vehicle, i3dNode, nil , false , self )
                        StaticLight.loadLightsFromXML( self.staticLights.brakeLights, self.xmlFile, "light.brakeLight" , self.vehicle, i3dNode, nil , false , self )
                        StaticLight.loadLightsFromXML( self.staticLights.reverseLights, self.xmlFile, "light.reverseLight" , self.vehicle, i3dNode, nil , false , self )
                        StaticLight.loadLightsFromXML( self.staticLights.dayTimeLights, self.xmlFile, "light.dayTimeLight" , self.vehicle, i3dNode, nil , false , self )
                        StaticLight.loadLightsFromXML( self.staticLights.turnLightsLeft, self.xmlFile, "light.turnLightLeft" , self.vehicle, i3dNode, nil , false , self )
                        StaticLight.loadLightsFromXML( self.staticLights.turnLightsRight, self.xmlFile, "light.turnLightRight" , self.vehicle, i3dNode, nil , false , self )

                        if self.rotationNodes ~ = nil then
                            self.xmlFile:iterate( "light.rotationNode" , function (_, baseKey)
                                local name = self.xmlFile:getValue(baseKey .. "#name" )
                                if name ~ = nil then
                                    local node = self.xmlFile:getValue(baseKey .. "#node" , nil , i3dNode)
                                    if self.rotationNodes[name] ~ = nil then
                                        setRotation(node, unpack( self.rotationNodes[name]))
                                    end
                                end
                            end )
                        end

                        if self.xmlFile:hasProperty( "light.staticLightCompound" ) then
                            local staticLightCompound = StaticLightCompound.new( self.vehicle)
                            if staticLightCompound:loadFromXML( self.xmlFile, "light.staticLightCompound" , i3dNode, nil , nil , self ) then
                                staticLightCompound:setLightTypes( self.lightTypes, self.excludedLightTypes)
                                staticLightCompound:setOverwriteSettings( self.turnLightLeft, self.turnLightRight, self.reverseLight)
                                self.staticLightCompound = staticLightCompound
                            end
                        end

                        if self.xmlFile:hasProperty( "light.baseMaterial" ) then
                            local material = VehicleMaterial.new( self.vehicle.baseDirectory)
                            if material:loadFromXML( self.xmlFile, "light.baseMaterial" , self.vehicle.customEnvironment) then
                                material:apply( self.node, "sharedLightBase_mat" )
                            end
                        end

                        if self.xmlFile:hasProperty( "light.glassMaterial" ) then
                            local material = VehicleMaterial.new( self.vehicle.baseDirectory)
                            if material:loadFromXML( self.xmlFile, "light.glassMaterial" , self.vehicle.customEnvironment) then
                                material:apply( self.node, "sharedLightGlass_mat" )
                            end
                        end

                        link( self.linkNode, self.node)
                    end

                    delete(i3dNode)
                end

                self.xmlFile:delete()
                self.xmlFile = nil
                self:onFinished( self.node ~ = nil )
            end

```

### registerExternalXMLPaths

**Description**

**Definition**

> registerExternalXMLPaths()

**Arguments**

| any | schema |
|-----|--------|

**Code**

```lua
function SharedLight.registerExternalXMLPaths(schema)
    schema:register(XMLValueType.STRING, "light.filename" , "Path to i3d file" , nil , true )
    schema:register(XMLValueType.NODE_INDEX, "light.rootNode#node" , "Node index" , "0" )

    StaticLight.registerXMLPaths(schema, "light.defaultLight(?)" )
    StaticLight.registerXMLPaths(schema, "light.topLight(?)" )
    StaticLight.registerXMLPaths(schema, "light.bottomLight(?)" )
    StaticLight.registerXMLPaths(schema, "light.brakeLight(?)" )
    StaticLight.registerXMLPaths(schema, "light.reverseLight(?)" )
    StaticLight.registerXMLPaths(schema, "light.dayTimeLight(?)" )
    StaticLight.registerXMLPaths(schema, "light.turnLightLeft(?)" )
    StaticLight.registerXMLPaths(schema, "light.turnLightRight(?)" )

    schema:register(XMLValueType.STRING, "light.rotationNode(?)#name" , "Name for reference in vehicle xml" )
        schema:register(XMLValueType.NODE_INDEX, "light.rotationNode(?)#node" , "Node" )

        VehicleMaterial.registerXMLPaths(schema, "light.baseMaterial" )
        VehicleMaterial.registerXMLPaths(schema, "light.glassMaterial" )

        StaticLightCompound.registerXMLPaths(schema, "light.staticLightCompound" )
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
function SharedLight.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#filename" , "Shared light filename" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#linkNode" , "Link node" , "0>" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#lightTypes" , "Light types" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#excludedLightTypes" , "Excluded light types" )
    schema:register(XMLValueType.STRING, basePath .. ".rotationNode(?)#name" , "Rotation node name" )
    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".rotationNode(?)#rotation" , "Rotation" )

    schema:register(XMLValueType.BOOL, basePath .. "#reverseLight" , "All 'defaultLight' nodes will be used as reverse light" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#turnLightLeft" , "All 'defaultLight' nodes will be used as left turn light" , false )
    schema:register(XMLValueType.BOOL, basePath .. "#turnLightRight" , "All 'defaultLight' nodes will be used as right turn light" , false )

    schema:register(XMLValueType.STRING, basePath .. ".function (?)#name" , "Function name" , nil , nil , StaticLightCompoundUVSlot.getAllOrderedByName())
        schema:register(XMLValueType.INT, basePath .. ".function (?)#uvSlotIndex" , "Custom UV slot index to assign the defined function name" )
            schema:register(XMLValueType.INT, basePath .. ".function (?)#uvOffset" , "Vertical UV offset that is used while this light function is active(value range:0-64 -> this represents the height of the texture with a resolution of 1/64).This is used for double usage of certain lights with different colors." , 0 )
                schema:register(XMLValueType.FLOAT, basePath .. ".function (?)#intensityScale" , "Custom intensity scale for this light type(is multiplied by the intensity defined in the node)" )
                    schema:register(XMLValueType.STRING, basePath .. ".function (?)#lightType" , "Name of the light type to use" , nil , nil , StaticLightCompoundLightType.getAllOrderedByName())
                    end

```

### setCallback

**Description**

**Definition**

> setCallback()

**Arguments**

| any | callback       |
|-----|----------------|
| any | callbackTarget |

**Code**

```lua
function SharedLight:setCallback(callback, callbackTarget)
    self.callback = callback
    self.callbackTarget = callbackTarget
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
function SharedLight:setLightTypes(lightTypes, excludedLightTypes)
    self.lightTypes = lightTypes
    self.excludedLightTypes = excludedLightTypes
end

```

### setRotationNodes

**Description**

**Definition**

> setRotationNodes()

**Arguments**

| any | rotationNodes |
|-----|---------------|

**Code**

```lua
function SharedLight:setRotationNodes(rotationNodes)
    self.rotationNodes = rotationNodes
end

```