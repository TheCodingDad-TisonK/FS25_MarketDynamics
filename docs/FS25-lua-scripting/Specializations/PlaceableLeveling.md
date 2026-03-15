## PlaceableLeveling

**Description**

> Specialization for placeables

**Functions**

- [addDeformationArea](#adddeformationarea)
- [applyDeformation](#applydeformation)
- [getDeformationObjects](#getdeformationobjects)
- [getRequiresLeveling](#getrequiresleveling)
- [getRequiresRealignAfterLeveling](#getrequiresrealignafterleveling)
- [loadLevelArea](#loadlevelarea)
- [loadPaintArea](#loadpaintarea)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### addDeformationArea

**Description**

> Add a leveling area of a placeable to a terrain deformation object.

**Definition**

> addDeformationArea(TerrainDeformation deformationObject, table area, integer terrainBrushId, boolean
> writeBlockedAreaMap)

**Arguments**

| TerrainDeformation | deformationObject   | instance                                                                                                                        |
|--------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------|
| table              | area                | Table which holds area nodes, {start=origin node, width=first side area delimiter node, height=second side area delimiter node} |
| integer            | terrainBrushId      | Terrain brush ID, currently this is a map layer index (zero-based)                                                              |
| boolean            | writeBlockedAreaMap |                                                                                                                                 |

**Code**

```lua
function PlaceableLeveling:addDeformationArea(deformationObject, area, terrainBrushId, writeBlockedAreaMap)
    local worldStartX, worldStartY, worldStartZ = getWorldTranslation(area.start)
    local worldSide1X, worldSide1Y, worldSide1Z = getWorldTranslation(area.width)
    local worldSide2X, worldSide2Y, worldSide2Z = getWorldTranslation(area.height)

    local side1X, side1Y, side1Z = worldSide1X - worldStartX, worldSide1Y - worldStartY, worldSide1Z - worldStartZ
    local side2X, side2Y, side2Z = worldSide2X - worldStartX, worldSide2Y - worldStartY, worldSide2Z - worldStartZ

    deformationObject:addArea(
    worldStartX, worldStartY, worldStartZ,
    side1X, side1Y, side1Z,
    side2X, side2Y, side2Z,
    terrainBrushId,
    writeBlockedAreaMap
    )
end

```

### applyDeformation

**Description**

**Definition**

> applyDeformation(boolean isPreview, function callback)

**Arguments**

| boolean  | isPreview |
|----------|-----------|
| function | callback  |

**Code**

```lua
function PlaceableLeveling:applyDeformation(isPreview, callback)
    local deformationObjects = self:getDeformationObjects(g_terrainNode)

    if #deformationObjects = = 0 then
        callback(TerrainDeformation.STATE_SUCCESS, 0 , nil )
        return
    end

    local recursiveCallback = { }
    recursiveCallback.index = 1
    recursiveCallback.volume = 0
    recursiveCallback.deformationObjects = deformationObjects
    recursiveCallback.finishCallback = callback
    recursiveCallback.callback = function (target, errorCode, displacedVolume, blockedObjectName)
        if errorCode ~ = TerrainDeformation.STATE_SUCCESS then
            -- Finished:delete all objects
            local objects = { }
            for _, object in ipairs(target.deformationObjects) do
                table.insert(objects, object)
            end

            -- do the delete in the next frame
                g_asyncTaskManager:addTask( function ()
                    for _, object in ipairs(objects) do
                        object:delete()
                    end
                end )

                target.finishCallback(errorCode, target.volume, blockedObjectName)
                return
            end

            target.volume = target.volume + displacedVolume
            target.index = target.index + 1

            local nextDeformationObject = target.deformationObjects[target.index]
            if nextDeformationObject ~ = nil then
                g_terrainDeformationQueue:queueJob(nextDeformationObject, isPreview, "callback" , target)
            else
                    -- Finished:delete all objects
                    local objects = { }
                    for _, object in ipairs(target.deformationObjects) do
                        table.insert(objects, object)
                    end

                    -- do the delete in the next frame
                        g_asyncTaskManager:addTask( function ()
                            for _, object in ipairs(objects) do
                                object:delete()
                            end
                        end )

                        target.finishCallback(TerrainDeformation.STATE_SUCCESS, target.volume, nil )
                    end
                end

                g_terrainDeformationQueue:queueJob(deformationObjects[ 1 ], isPreview, "callback" , recursiveCallback)
            end

```

### getDeformationObjects

**Description**

> Create a TerrainDeformation object for leveling the ground beneath this placeable and any ramps.

**Definition**

> getDeformationObjects(integer terrainRootNode, boolean forBlockingOnly, boolean isBlocking)

**Arguments**

| integer | terrainRootNode | Map terrain root node ID                                                                                          |
|---------|-----------------|-------------------------------------------------------------------------------------------------------------------|
| boolean | forBlockingOnly | Create the object only to write into the blocking map                                                             |
| boolean | isBlocking      | If forBlockingOnly is true, this also tells the method if we intend to block areas (true) or unblock them (false) |

**Return Values**

| boolean | deformationObjects |
|---------|--------------------|

**Code**

```lua
function PlaceableLeveling:getDeformationObjects(terrainRootNode, forBlockingOnly, isBlocking)
    local spec = self.spec_leveling
    local deformationObjects = { }

    if not forBlockingOnly then
        isBlocking = false
    end

    if terrainRootNode ~ = nil and terrainRootNode ~ = 0 then
        if #spec.levelAreas > 0 then
            local deformationObject = TerrainDeformation.new(terrainRootNode)

            if g_densityMapHeightManager.placementCollisionMap ~ = nil then
                deformationObject:setBlockedAreaMap(g_densityMapHeightManager.placementCollisionMap, 0 )
            end

            for _, levelArea in pairs(spec.levelAreas) do
                local layer = - 1
                if levelArea.groundType ~ = nil then
                    layer = g_groundTypeManager:getTerrainLayerByType(levelArea.groundType)
                end
                self:addDeformationArea(deformationObject, levelArea, layer, true )
            end

            if spec.smoothingGroundType ~ = nil then
                deformationObject:setOutsideAreaBrush(g_groundTypeManager:getTerrainLayerByType(spec.smoothingGroundType))
            end

            deformationObject:setOutsideAreaConstraints(spec.maxSmoothDistance, spec.maxSlope, spec.maxEdgeAngle)

            deformationObject:setBlockedAreaMaxDisplacement( 0.1 )
            deformationObject:setDynamicObjectCollisionMask(CollisionMask.LEVELING)
            deformationObject:setDynamicObjectMaxDisplacement( 0.3 )
            table.insert(deformationObjects, deformationObject)
        end
    end

    if not forBlockingOnly then
        if #spec.paintAreas > 0 then
            local paintingObject = TerrainDeformation.new(terrainRootNode)
            for _, paintArea in pairs(spec.paintAreas) do
                local layer = - 1
                if paintArea.groundType ~ = nil then
                    layer = g_groundTypeManager:getTerrainLayerByType(paintArea.groundType)
                end
                self:addDeformationArea(paintingObject, paintArea, layer, true )
            end
            paintingObject:enablePaintingMode()
            table.insert(deformationObjects, paintingObject)
        end
    end

    return deformationObjects
end

```

### getRequiresLeveling

**Description**

**Definition**

> getRequiresLeveling()

**Return Values**

| boolean | requiresLeveling |
|---------|------------------|

**Code**

```lua
function PlaceableLeveling:getRequiresLeveling()
    return self.spec_leveling.requiresLeveling
end

```

### getRequiresRealignAfterLeveling

**Description**

**Definition**

> getRequiresRealignAfterLeveling()

**Return Values**

| boolean | realignAfterLeveling |
|---------|----------------------|

**Code**

```lua
function PlaceableLeveling:getRequiresRealignAfterLeveling()
    return self.spec_leveling.realignAfterLeveling
end

```

### loadLevelArea

**Description**

**Definition**

> loadLevelArea(XMLFile xmlFile, string key, table area)

**Arguments**

| XMLFile | xmlFile |
|---------|---------|
| string  | key     |
| table   | area    |

**Return Values**

| table | success |
|-------|---------|

**Code**

```lua
function PlaceableLeveling:loadLevelArea(xmlFile, key, area)
    local start = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
    if start = = nil then
        Logging.xmlWarning(xmlFile, "Leveling area start node not defined for '%s'" , key)
            return false
        end

        local width = xmlFile:getValue(key .. "#widthNode" , nil , self.components, self.i3dMappings)
        if width = = nil then
            Logging.xmlWarning(xmlFile, "Leveling area width node not defined for '%s'" , key)
                return false
            end

            local height = xmlFile:getValue(key .. "#heightNode" , nil , self.components, self.i3dMappings)
            if height = = nil then
                Logging.xmlWarning(xmlFile, "Leveling area height node not defined for '%s'" , key)
                    return false
                end

                area.start = start
                area.width = width
                area.height = height
                area.groundType = xmlFile:getValue(key .. "#groundType" )

                return true
            end

```

### loadPaintArea

**Description**

**Definition**

> loadPaintArea(XMLFile xmlFile, string key, table area)

**Arguments**

| XMLFile | xmlFile |
|---------|---------|
| string  | key     |
| table   | area    |

**Return Values**

| table | success |
|-------|---------|

**Code**

```lua
function PlaceableLeveling:loadPaintArea(xmlFile, key, area)
    local start = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
    if start = = nil then
        Logging.xmlWarning(xmlFile, "Paint area start node not defined for '%s'" , key)
            return false
        end

        local width = xmlFile:getValue(key .. "#widthNode" , nil , self.components, self.i3dMappings)
        if width = = nil then
            Logging.xmlWarning(xmlFile, "Paint area width node not defined for '%s'" , key)
                return false
            end

            local height = xmlFile:getValue(key .. "#heightNode" , nil , self.components, self.i3dMappings)
            if height = = nil then
                Logging.xmlWarning(xmlFile, "Paint area height node not defined for '%s'" , key)
                    return false
                end

                area.start = start
                area.width = width
                area.height = height
                area.groundType = xmlFile:getValue(key .. "#groundType" )

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
function PlaceableLeveling:onLoad(savegame)
    local spec = self.spec_leveling
    local xmlFile = self.xmlFile

    -- load leveling properties
    spec.requiresLeveling = xmlFile:getValue( "placeable.leveling#requireLeveling" , false )
    local smoothingDistance = xmlFile:getValue( "placeable.leveling#maxSmoothDistance" , 3 )
    local clampedSmoothingDistance = math.clamp(smoothingDistance, 0 , 10 )
    if clampedSmoothingDistance ~ = smoothingDistance then
        Logging.xmlWarning(xmlFile, "Reduced 'placeable.leveling#maxSmoothDistance' to maximum allowed value of %d" , clampedSmoothingDistance)
    end
    spec.maxSmoothDistance = clampedSmoothingDistance
    spec.maxSlope = xmlFile:getValue( "placeable.leveling#maxSlope" , 45 )
    spec.maxEdgeAngle = xmlFile:getValue( "placeable.leveling#maxEdgeAngle" , 45 )
    spec.smoothingGroundType = xmlFile:getValue( "placeable.leveling#smoothingGroundType" )
    spec.realignAfterLeveling = xmlFile:getValue( "placeable.leveling#realignAfterLeveling" , true )

    if not self.xmlFile:hasProperty( "placeable.leveling" ) then
        Logging.xmlWarning( self.xmlFile, "Missing leveling areas" )
    end

    spec.levelAreas = { }
    xmlFile:iterate( "placeable.leveling.levelAreas.levelArea" , function (_, key)
        local levelArea = { }
        if self:loadLevelArea(xmlFile, key, levelArea) then
            table.insert(spec.levelAreas, levelArea)
        end
    end )

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.leveling.rampAreas.rampArea" , "placeable.leveling.levelAreas.levelArea" ) -- FS19 to FS22

    spec.paintAreas = { }
    xmlFile:iterate( "placeable.leveling.paintAreas.paintArea" , function (_, key)
        local paintArea = { }
        if self:loadPaintArea(xmlFile, key, paintArea) then
            table.insert(spec.paintAreas, paintArea)
        end
    end )
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
function PlaceableLeveling.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners(table placeableType)

**Arguments**

| table | placeableType |
|-------|---------------|

**Code**

```lua
function PlaceableLeveling.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableLeveling )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions(table placeableType)

**Arguments**

| table | placeableType |
|-------|---------------|

**Code**

```lua
function PlaceableLeveling.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "loadLevelArea" , PlaceableLeveling.loadLevelArea)
    SpecializationUtil.registerFunction(placeableType, "loadPaintArea" , PlaceableLeveling.loadPaintArea)
    SpecializationUtil.registerFunction(placeableType, "addDeformationArea" , PlaceableLeveling.addDeformationArea)
    SpecializationUtil.registerFunction(placeableType, "applyDeformation" , PlaceableLeveling.applyDeformation)
    SpecializationUtil.registerFunction(placeableType, "getDeformationObjects" , PlaceableLeveling.getDeformationObjects)
    SpecializationUtil.registerFunction(placeableType, "getRequiresLeveling" , PlaceableLeveling.getRequiresLeveling)
    SpecializationUtil.registerFunction(placeableType, "getRequiresRealignAfterLeveling" , PlaceableLeveling.getRequiresRealignAfterLeveling)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function PlaceableLeveling.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Leveling" )
    schema:register(XMLValueType.BOOL, basePath .. ".leveling#requireLeveling" , "If true, the ground around the placeable is leveled and all other leveling properties are used" , false )
    schema:register(XMLValueType.FLOAT, basePath .. ".leveling#maxSmoothDistance" , "Radius around leveling areas where terrain will be smoothed towards the placeable" , 3 )
    schema:register(XMLValueType.ANGLE, basePath .. ".leveling#maxSlope" , "Maximum slope of terrain created by outside smoothing expressed as an angle in degrees" , 45 )
    schema:register(XMLValueType.ANGLE, basePath .. ".leveling#maxEdgeAngle" , "Maximum angle between polygons in smoothed areas expressed as an angle in degrees" , 45 )
    schema:register(XMLValueType.STRING, basePath .. ".leveling#smoothingGroundType" , "Ground type used to paint the smoothed ground from leveling areas up to the radius of 'maxSmoothDistance' (one of the ground types defined in groundTypes.xml)" )
    schema:register(XMLValueType.BOOL, basePath .. ".leveling#realignAfterLeveling" , "If false placeable will not be realigned in y after leveling was performed" , true )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".leveling.levelAreas.levelArea(?)#startNode" , "Start node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".leveling.levelAreas.levelArea(?)#widthNode" , "Width node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".leveling.levelAreas.levelArea(?)#heightNode" , "Height node" )
    schema:register(XMLValueType.STRING, basePath .. ".leveling.levelAreas.levelArea(?)#groundType" , "Ground type name(one of the ground types defined in groundTypes.xml)" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".leveling.paintAreas.paintArea(?)#startNode" , "Start node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".leveling.paintAreas.paintArea(?)#widthNode" , "Width node" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".leveling.paintAreas.paintArea(?)#heightNode" , "Height node" )
    schema:register(XMLValueType.STRING, basePath .. ".leveling.paintAreas.paintArea(?)#groundType" , "Ground type name(one of the ground types defined in groundTypes.xml)" )
    schema:setXMLSpecializationType()
end

```