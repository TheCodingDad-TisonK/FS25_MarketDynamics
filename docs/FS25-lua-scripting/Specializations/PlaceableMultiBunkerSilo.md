## PlaceableMultiBunkerSilo

**Description**

> Specialization for placeables

**Functions**

- [canBeSold](#canbesold)
- [getHasOverlap](#gethasoverlap)
- [getIsBunkerSiloExtendable](#getisbunkersiloextendable)
- [getPlacementPosition](#getplacementposition)
- [getPlacementRotation](#getplacementrotation)
- [initSpecialization](#initspecialization)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onSell](#onsell)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setOwnerFarmId](#setownerfarmid)
- [setWallVisibility](#setwallvisibility)
- [startPlacementCheck](#startplacementcheck)
- [updateBunkerSiloWalls](#updatebunkersilowalls)

### canBeSold

**Description**

**Definition**

> canBeSold()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function PlaceableMultiBunkerSilo:canBeSold(superFunc)
    local spec = self.spec_multiBunkerSilo

    for _, bunkerSilo in ipairs(spec.bunkerSilos) do
        if bunkerSilo.fillLevel > 0 then
            return true , spec.sellWarningText
        end ;
    end

    return true , nil
end

```

### getHasOverlap

**Description**

**Definition**

> getHasOverlap()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |
| any | rotY      |
| any | checkFunc |

**Code**

```lua
function PlaceableMultiBunkerSilo:getHasOverlap(superFunc, x, y, z, rotY, checkFunc)
    local spec = self.spec_multiBunkerSilo
    local overwrittenCheckFunc = checkFunc

    if spec.foundSnappingSilo ~ = nil then
        overwrittenCheckFunc = function (hitObjectId)
            local object = g_currentMission:getNodeObject(hitObjectId)
            if object = = spec.foundSnappingSilo then
                return false
            end

            if checkFunc ~ = nil then
                return checkFunc(hitObjectId)
            end

            return hitObjectId ~ = g_terrainNode
        end
    end

    return superFunc( self , x, y, z, rotY, overwrittenCheckFunc)
end

```

### getIsBunkerSiloExtendable

**Description**

**Definition**

> getIsBunkerSiloExtendable()

**Code**

```lua
function PlaceableMultiBunkerSilo:getIsBunkerSiloExtendable()
    local spec = self.spec_multiBunkerSilo
    return spec.isExtendable
end

```

### getPlacementPosition

**Description**

**Definition**

> getPlacementPosition()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |

**Code**

```lua
function PlaceableMultiBunkerSilo:getPlacementPosition(superFunc, x, y, z)
    x, y, z = superFunc( self , x, y, z)

    local spec = self.spec_multiBunkerSilo
    if spec.foundSnappingSilo ~ = nil then
        x, y, z = localToWorld(spec.foundSnappingSilo.rootNode, spec.siloSiloDistance * spec.foundSnappingSiloSide, 0 , 0 )
    end

    return x, y, z
end

```

### getPlacementRotation

**Description**

**Definition**

> getPlacementRotation()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | x         |
| any | y         |
| any | z         |

**Code**

```lua
function PlaceableMultiBunkerSilo:getPlacementRotation(superFunc, x, y, z)
    x, y, z = superFunc( self , x, y, z)

    local spec = self.spec_multiBunkerSilo
    if spec.foundSnappingSilo ~ = nil then
        local dx, _, dz = localDirectionToWorld(spec.foundSnappingSilo.rootNode, 0 , 0 , 1 )
        x, y, z = 0 , MathUtil.getYRotationFromDirection(dx, dz), 0
    end

    return x, y, z
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableMultiBunkerSilo.initSpecialization()
    g_placeableConfigurationManager:addConfigurationType( "bunkerSilo" , g_i18n:getText( "configuration_bunkerSilo" ), "bunkerSilo" , PlaceableConfigurationItem )
end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PlaceableMultiBunkerSilo:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_multiBunkerSilo
    local isSuccessful = true

    for i, bunkerSilo in ipairs(spec.bunkerSilos) do
        local bunkerSiloKey = string.format( "%s.bunkerSilo(%d)" , key, i - 1 )
        if not bunkerSilo:loadFromXMLFile(xmlFile, bunkerSiloKey) then
            isSuccessful = false
        end
    end

    return isSuccessful
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableMultiBunkerSilo:onDelete()
    local spec = self.spec_multiBunkerSilo

    self:updateBunkerSiloWalls( true )

    for i, bunkerSilo in ipairs _reverse(spec.bunkerSilos) do
        bunkerSilo:delete()
        table.remove(spec.bunkerSilos, i)
    end

    g_currentMission.placeableSystem:removeBunkerSilo( self )
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableMultiBunkerSilo:onFinalizePlacement()
    local spec = self.spec_multiBunkerSilo
    local ownerFarmId = self:getOwnerFarmId()

    self:updateBunkerSiloWalls( false )

    for _, bunkerSilo in ipairs(spec.bunkerSilos) do
        bunkerSilo:register( true )
        bunkerSilo:setOwnerFarmId(ownerFarmId, true )
    end

    g_currentMission.placeableSystem:addBunkerSilo( self )
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
function PlaceableMultiBunkerSilo:onLoad(savegame)
    local spec = self.spec_multiBunkerSilo

    spec.bunkerSilos = { }

    local xmlKey = "placeable.bunkerSilo"
    local bunkerSiloConfigurationId = Utils.getNoNil( self.configurations[ "bunkerSilo" ], 1 )
    local configKey = string.format( "%s.bunkerSiloConfigurations.bunkerSiloConfiguration(%d)" , xmlKey, bunkerSiloConfigurationId - 1 )

    --leftWall
    local leftWallNode = self.xmlFile:getValue(xmlKey .. ".wallLeft#node" , nil , self.components, self.i3dMappings)
    if leftWallNode ~ = nil then
        spec.wallLeft = { }
        spec.wallLeft.node = leftWallNode
        spec.wallLeft.visible = true
        spec.wallLeft.collision = self.xmlFile:getValue(xmlKey .. ".wallLeft#collision" , nil , self.components, self.i3dMappings)
    end

    --backWall
    local backWallNode = self.xmlFile:getValue(xmlKey .. ".wallRight#node" , nil , self.components, self.i3dMappings)
    if backWallNode ~ = nil then
        spec.wallRight = { }
        spec.wallRight.node = backWallNode
        spec.wallRight.visible = true
        spec.wallRight.collision = self.xmlFile:getValue(xmlKey .. ".wallRight#collision" , nil , self.components, self.i3dMappings)
    end

    --rightWall
    local rightWallNode = self.xmlFile:getValue(xmlKey .. ".wallBack#node" , nil , self.components, self.i3dMappings)
    if rightWallNode ~ = nil then
        spec.wallRight = { }
        spec.wallRight.node = rightWallNode
        spec.wallRight.visible = true
        spec.wallRight.collision = self.xmlFile:getValue(xmlKey .. ".wallBack#collision" , nil , self.components, self.i3dMappings)
    end

    spec.sellWarningText = g_i18n:convertText( self.xmlFile:getValue( "placeable.bunkerSilo#sellWarningText" , "$l10n_info_bunkerSiloNotEmpty" ))

    for _, key in self.xmlFile:iterator(configKey .. ".bunkerSilo" ) do
        local bunkerSilo = BunkerSilo.new( self.isServer, self.isClient)
        if not bunkerSilo:load( self.components, self.xmlFile, key, self.i3dMappings) then
            bunkerSilo:delete()
            return
        end

        table.insert(spec.bunkerSilos, bunkerSilo)
    end

    spec.isExtendable = self.xmlFile:getValue( "placeable.bunkerSilo#isExtendable" , false )
    if spec.isExtendable then
        spec.siloSiloDistance = self.xmlFile:getValue( "placeable.bunkerSilo#siloToSiloDistance" )
        if spec.siloSiloDistance = = nil then
            Logging.xmlError( self.xmlFile, "Bunker Silo is marked as extendable but 'placeable.bunkerSilo#siloToSiloDistance' is not set" )
            self:setLoadingState(PlaceableLoadingState.ERROR)
            return
        end
        spec.snapDistance = self.xmlFile:getValue( "placeable.bunkerSilo#snapDistance" ) or spec.siloSiloDistance * 1.1
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
function PlaceableMultiBunkerSilo:onReadStream(streamId, connection)
    local spec = self.spec_multiBunkerSilo

    for _, bunkerSilo in ipairs(spec.bunkerSilos) do
        local bunkerSiloId = NetworkUtil.readNodeObjectId(streamId)
        bunkerSilo:readStream(streamId, connection)
        g_client:finishRegisterObject(bunkerSilo, bunkerSiloId)
    end
end

```

### onSell

**Description**

**Definition**

> onSell()

**Code**

```lua
function PlaceableMultiBunkerSilo:onSell()
    local spec = self.spec_multiBunkerSilo
    for _, bunkerSilo in ipairs(spec.bunkerSilos) do
        bunkerSilo:clearSiloArea()
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
function PlaceableMultiBunkerSilo:onWriteStream(streamId, connection)
    local spec = self.spec_multiBunkerSilo

    for _, bunkerSilo in ipairs(spec.bunkerSilos) do
        NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(bunkerSilo))
        bunkerSilo:writeStream(streamId, connection)
        g_server:registerObjectInStream(connection, bunkerSilo)
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
function PlaceableMultiBunkerSilo.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableMultiBunkerSilo.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableMultiBunkerSilo )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableMultiBunkerSilo )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableMultiBunkerSilo )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableMultiBunkerSilo )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableMultiBunkerSilo )
    SpecializationUtil.registerEventListener(placeableType, "onSell" , PlaceableMultiBunkerSilo )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableMultiBunkerSilo.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "updateBunkerSiloWalls" , PlaceableMultiBunkerSilo.updateBunkerSiloWalls)
    SpecializationUtil.registerFunction(placeableType, "setWallVisibility" , PlaceableMultiBunkerSilo.setWallVisibility)
    SpecializationUtil.registerFunction(placeableType, "getIsBunkerSiloExtendable" , PlaceableMultiBunkerSilo.getIsBunkerSiloExtendable)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function PlaceableMultiBunkerSilo.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getPlacementPosition" , PlaceableMultiBunkerSilo.getPlacementPosition)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getPlacementRotation" , PlaceableMultiBunkerSilo.getPlacementRotation)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "getHasOverlap" , PlaceableMultiBunkerSilo.getHasOverlap)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "startPlacementCheck" , PlaceableMultiBunkerSilo.startPlacementCheck)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "canBeSold" , PlaceableMultiBunkerSilo.canBeSold)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableMultiBunkerSilo.setOwnerFarmId)
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableMultiBunkerSilo.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "MultiBunkerSilo" )
    BunkerSilo.registerSavegameXMLPaths(schema, basePath .. ".bunkerSilo(?)" )
    schema:setXMLSpecializationType()
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
function PlaceableMultiBunkerSilo.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "MultiBunkerSilo" )

    schema:register(XMLValueType.BOOL, basePath .. ".bunkerSilo#isExtendable" , "Checks if silo is extendable.If set 'siloToSiloDistance' needs to be provided as well" , false )
        schema:register(XMLValueType.FLOAT, basePath .. ".bunkerSilo#siloToSiloDistance" , "Silo to silo distance required for aligning multiple silos of the same type next to each other" )
            schema:register(XMLValueType.FLOAT, basePath .. ".bunkerSilo#snapDistance" , "Snap distance for building an array of the same silo" , "siloToSiloDistance * 1.1" )
                schema:register(XMLValueType.STRING, basePath .. ".bunkerSilo#sellWarningText" , "Sell warning text" )

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".bunkerSilo.wallLeft#node" , "Left wall node" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".bunkerSilo.wallLeft#collision" , "Left wall collision" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".bunkerSilo.wallBack#node" , "Back wall node" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".bunkerSilo.wallBack#collision" , "Back wall collision" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".bunkerSilo.wallRight#node" , "Right wall node" )
                schema:register(XMLValueType.NODE_INDEX, basePath .. ".bunkerSilo.wallRight#collision" , "Right wall collision" )

                basePath = basePath .. ".bunkerSilo.bunkerSiloConfigurations.bunkerSiloConfiguration(?)"
                BunkerSilo.registerXMLPaths(schema, basePath .. ".bunkerSilo(?)" )

                schema:setXMLSpecializationType()
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
function PlaceableMultiBunkerSilo:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_multiBunkerSilo

    for i, bunkerSilo in ipairs(spec.bunkerSilos) do
        local bunkerSiloKey = string.format( "%s.bunkerSilo(%d)" , key, i - 1 )
        bunkerSilo:saveToXMLFile(xmlFile, bunkerSiloKey, usedModNames)
    end
end

```

### setOwnerFarmId

**Description**

**Definition**

> setOwnerFarmId()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | farmId      |
| any | noEventSend |

**Code**

```lua
function PlaceableMultiBunkerSilo:setOwnerFarmId(superFunc, farmId, noEventSend)
    local spec = self.spec_multiBunkerSilo

    superFunc( self , farmId, noEventSend)

    if spec.bunkerSilos ~ = nil then
        for _, bunkerSilo in ipairs(spec.bunkerSilos) do
            bunkerSilo:setOwnerFarmId(farmId, true )
        end
    end
end

```

### setWallVisibility

**Description**

**Definition**

> setWallVisibility()

**Arguments**

| any | isLeftVisible  |
|-----|----------------|
| any | isBackVisible  |
| any | isRightVisible |

**Code**

```lua
function PlaceableMultiBunkerSilo:setWallVisibility(isLeftVisible, isBackVisible, isRightVisible)
    local spec = self.spec_multiBunkerSilo

    if spec.wallLeft ~ = nil then
        isLeftVisible = isLeftVisible or spec.wallLeft.visible

        if spec.wallLeft.visible ~ = isLeftVisible then
            spec.wallLeft.visible = isLeftVisible
            setVisibility(spec.wallLeft.node, isLeftVisible)
            if spec.wallLeft.collision ~ = nil then
                setRigidBodyType(spec.wallLeft.collision, isLeftVisible and RigidBodyType.STATIC or RigidBodyType.NONE)
            end
        end
    end

    if spec.wallBack ~ = nil then
        isBackVisible = isBackVisible or spec.wallBack.visible

        if spec.wallBack.visible ~ = isBackVisible then
            spec.wallBack.visible = isBackVisible
            setVisibility(spec.wallBack.node, isBackVisible)
            if spec.wallBack.collision ~ = nil then
                setRigidBodyType(spec.wallBack.collision, isBackVisible and RigidBodyType.STATIC or RigidBodyType.NONE)
            end
        end
    end

    if spec.wallRight ~ = nil then
        isRightVisible = isLeftVisible or spec.wallRight.visible

        if spec.wallRight.visible ~ = isRightVisible then
            spec.wallRight.visible = isRightVisible
            setVisibility(spec.wallRight.node, isRightVisible)
            if spec.wallRight.collision ~ = nil then
                setRigidBodyType(spec.wallRight.collision, isRightVisible and RigidBodyType.STATIC or RigidBodyType.NONE)
            end
        end
    end
end

```

### startPlacementCheck

**Description**

**Definition**

> startPlacementCheck(function superFunc, float? x, float? y, float? z, float? rotY)

**Arguments**

| function | superFunc |
|----------|-----------|
| float?   | x         |
| float?   | y         |
| float?   | z         |
| float?   | rotY      |

**Code**

```lua
function PlaceableMultiBunkerSilo:startPlacementCheck(superFunc, x, y, z, rotY)
    local spec = self.spec_multiBunkerSilo
    superFunc( self , x, y, z, rotY)

    if x = = nil then
        return
    end

    if not spec.isExtendable then
        return
    end

    spec.foundSnappingSilo = nil
    spec.foundSnappingSiloSide = 0
    local nearestDistance = spec.snapDistance
    for _, placeable in ipairs(g_currentMission.placeableSystem:getBunkerSilos()) do
        if placeable:getOwnerFarmId() = = g_localPlayer.farmId then
            if placeable.configFileName = = self.configFileName then

                local lx, _, lz = worldToLocal(placeable.rootNode, x, y, z)
                local distance = MathUtil.vector2Length(lx, lz)
                if distance < nearestDistance then
                    nearestDistance = distance
                    spec.foundSnappingSilo = placeable
                    spec.foundSnappingSiloSide = math.sign(lx)
                end
            end
        end
    end
end

```

### updateBunkerSiloWalls

**Description**

**Definition**

> updateBunkerSiloWalls()

**Arguments**

| any | isDeleting |
|-----|------------|

**Code**

```lua
function PlaceableMultiBunkerSilo:updateBunkerSiloWalls(isDeleting)
    local spec = self.spec_multiBunkerSilo
    if self.rootNode ~ = nil then
        local x, y, z = getWorldTranslation( self.rootNode)
        local placeableSystem = g_currentMission.placeableSystem
        for _, placeable in ipairs(placeableSystem:getBunkerSilos()) do
            if placeable:getIsBunkerSiloExtendable() and placeable ~ = self and placeable:getOwnerFarmId() = = self:getOwnerFarmId() then
                if placeable.configFileName = = self.configFileName then
                    local lx, _, lz = worldToLocal(placeable.rootNode, x, y, z)
                    local distance = MathUtil.vector2Length(lx, lz)
                    if distance < spec.siloSiloDistance + 0.5 then
                        local isLeft = lx > 0
                        local isBack = lz < 0

                        if isDeleting then
                            -- always set walls visible
                            if isLeft then
                                placeable:setWallVisibility( true , nil , nil )
                            elseif isBack then
                                    placeable:setWallVisibility( nil , true , nil )
                                else
                                        placeable:setWallVisibility( nil , nil , true )
                                    end
                                else
                                        if isLeft then
                                            placeable:setWallVisibility( false , nil , nil )
                                        elseif isBack then
                                                placeable:setWallVisibility( nil , false , nil )
                                            else
                                                    placeable:setWallVisibility( nil , nil , false )
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

```