## PlaceablePlacement

**Description**

> Specialization for placeables

**Functions**

- [getHasOverlap](#gethasoverlap)
- [getHasOverlapWithPlaces](#gethasoverlapwithplaces)
- [getHasOverlapWithZones](#gethasoverlapwithzones)
- [getIsAreaOwnedByFarm](#getisareaownedbyfarm)
- [getPlacementPosition](#getplacementposition)
- [getPlacementRotation](#getplacementrotation)
- [getPositionSnapOffset](#getpositionsnapoffset)
- [getPositionSnapSize](#getpositionsnapsize)
- [getRotationSnapAngle](#getrotationsnapangle)
- [getTestParallelogramAtWorldPosition](#gettestparallelogramatworldposition)
- [loadTestArea](#loadtestarea)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPreFinalizePlacement](#onprefinalizeplacement)
- [playDestroySound](#playdestroysound)
- [playPlaceSound](#playplacesound)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [startPlacementCheck](#startplacementcheck)

### getHasOverlap

**Description**

**Definition**

> getHasOverlap()

**Arguments**

| any | x         |
|-----|-----------|
| any | y         |
| any | z         |
| any | rotY      |
| any | checkFunc |

**Code**

```lua
function PlaceablePlacement:getHasOverlap(x, y, z, rotY, checkFunc)
    local spec = self.spec_placement

    local placementOverlapMask = self:getPlacementOverlapMask()

    local callbackTarget = { hasOverlap = false }
    callbackTarget.overlapCallback = function (target, hitObjectId, hitX, hitY, hitZ, distance)
        if checkFunc ~ = nil then
            if checkFunc(hitObjectId) then
                callbackTarget.hasOverlap = true
                callbackTarget.node = hitObjectId
                return false
            end
        else
                if self:isValidOverlapNode(hitObjectId) then
                    callbackTarget.hasOverlap = true
                    callbackTarget.node = hitObjectId
                    return false
                end
            end

            return true
        end

        for _, area in ipairs(spec.testAreas) do
            local size = area.size
            local center = area.center

            local dirX, dirZ = MathUtil.getDirectionFromYRotation(rotY)
            local normX, _, normZ = MathUtil.crossProduct( 0 , 1 , 0 , dirX, 0 , dirZ)

            local posX = x + dirX * center.z + normX * center.x
            local posY = y + center.y
            local posZ = z + dirZ * center.z + normZ * center.x

            local sizeXHalf, sizeZHalf = size.x * 0.5 , size.z * 0.5
            local frontLeftX, frontLeftZ = posX + dirX * sizeZHalf - normX * sizeXHalf, posZ + dirZ * sizeZHalf - normZ * sizeXHalf
            local frontRightX, frontRightZ = posX + dirX * sizeZHalf + normX * sizeXHalf, posZ + dirZ * sizeZHalf + normZ * sizeXHalf
            local backLeftX, backLeftZ = posX - dirX * sizeZHalf - normX * sizeXHalf, posZ - dirZ * sizeZHalf - normZ * sizeXHalf
            local backRightX, backRightZ = posX - dirX * sizeZHalf + normX * sizeXHalf, posZ - dirZ * sizeZHalf + normZ * sizeXHalf

            if self:getIsAreaBlocked(frontLeftX, frontLeftZ, frontRightX, frontRightZ, backLeftX, backLeftZ) then
                return true , nil
            end

            local frontLeftY = getTerrainHeightAtWorldPos(g_terrainNode, frontLeftX, 0 , frontLeftZ)
            local frontRightY = getTerrainHeightAtWorldPos(g_terrainNode, frontRightX, 0 , frontRightZ)
            local backLeftY = getTerrainHeightAtWorldPos(g_terrainNode, backLeftX, 0 , backLeftZ)
            local backRightY = getTerrainHeightAtWorldPos(g_terrainNode, backRightX, 0 , backRightZ)
            local centerY = getTerrainHeightAtWorldPos(g_terrainNode, posX, 0 , posZ)

            local terrainBasedCenterY = math.min(frontLeftY, frontRightY, backLeftY, backRightY, centerY) + size.y * 0.5 - 0.5 -- we want to check 0.5m below terrain
            posY = math.max(terrainBasedCenterY, posY)

            local extendX, extendY, extendZ = size.x * 0.5 , size.y * 0.5 , size.z * 0.5
            overlapBox(posX, posY, posZ, 0 , rotY + area.rotYOffset, 0 , extendX, extendY, extendZ, "overlapCallback" , callbackTarget, placementOverlapMask, true , true , true , true )

            --#debug local boxColor = callbackTarget.hasOverlap and Color.PRESETS.RED or Color.PRESETS.GREEN
            --#debug DebugBox.renderAtPosition(posX, posY, posZ, 0, 1, 0, -math.sin(rotY + area.rotYOffset), 0, -math.cos(rotY + area.rotYOffset), size.x, size.y, size.z, boxColor, false)

            --#debug DebugGizmo.renderAtPosition(frontLeftX, frontLeftY, frontLeftZ, dirX, 0, dirZ, 0, 1, 0, "frontLeft", false, 5, 0.02)
            --#debug DebugGizmo.renderAtPosition(frontRightX, frontRightY, frontRightZ, dirX, 0, dirZ, 0, 1, 0, "frontRightX", false, 2, 0.02)
            --#debug DebugGizmo.renderAtPosition(backLeftX, backLeftY, backLeftZ, dirX, 0, dirZ, 0, 1, 0, "backLeftX", false, 2, 0.02)
            --#debug DebugGizmo.renderAtPosition(backRightX, backRightY, backRightZ, dirX, 0, dirZ, 0, 1, 0, "backRightX", false, 2, 0.02)

            if callbackTarget.hasOverlap then
                return true , callbackTarget.node
            end

            if self:getHasOverlapWithDensityHeight(area, x, z, rotY) then
                return true , nil
            end
        end

        return false , nil
    end

```

### getHasOverlapWithPlaces

**Description**

**Definition**

> getHasOverlapWithPlaces()

**Arguments**

| any | places |
|-----|--------|
| any | x      |
| any | y      |
| any | z      |
| any | rotY   |

**Code**

```lua
function PlaceablePlacement:getHasOverlapWithPlaces(places, x, y, z, rotY)
    local spec = self.spec_placement
    for _, area in ipairs(spec.testAreas) do
        local x1, z1, x2, z2, x3, z3, x4, z4 = self:getTestParallelogramAtWorldPosition(area, x, z, rotY)

        if PlacementUtil.isInsidePlacementPlaces(places, x1, y, z1) then
            return true
        end
        if PlacementUtil.isInsidePlacementPlaces(places, x2, y, z2) then
            return true
        end
        if PlacementUtil.isInsidePlacementPlaces(places, x3, y, z3) then
            return true
        end
        if PlacementUtil.isInsidePlacementPlaces(places, x4, y, z4) then
            return true
        end
    end

    return false
end

```

### getHasOverlapWithZones

**Description**

**Definition**

> getHasOverlapWithZones()

**Arguments**

| any | zones |
|-----|-------|
| any | x     |
| any | y     |
| any | z     |
| any | rotY  |

**Code**

```lua
function PlaceablePlacement:getHasOverlapWithZones(zones, x, y, z, rotY)
    local spec = self.spec_placement

    local doWaterCheck = not self:getCanBePlacedInWater()

    for _, area in ipairs(spec.testAreas) do
        local x1, z1, x2, z2, x3, z3, x4, z4 = self:getTestParallelogramAtWorldPosition(area, x, z, rotY)

        --#debug DebugGizmo.renderAtPosition(x1, y, z1, 0, 0, 1, 0, 1, 0, "P1", false, 2)
        --#debug DebugGizmo.renderAtPosition(x2, y, z2, 0, 0, 1, 0, 1, 0, "P2", false, 2)
        --#debug DebugGizmo.renderAtPosition(x3, y, z3, 0, 0, 1, 0, 1, 0, "P3", false, 2)
        --#debug DebugGizmo.renderAtPosition(x4, y, z4, 0, 0, 1, 0, 1, 0, "P4", false, 2)

        if PlacementUtil.isInsideRestrictedZone(zones, x1, y, z1, doWaterCheck) then
            return true
        end
        if PlacementUtil.isInsideRestrictedZone(zones, x2, y, z2, doWaterCheck) then
            return true
        end
        if PlacementUtil.isInsideRestrictedZone(zones, x3, y, z3, doWaterCheck) then
            return true
        end
        if PlacementUtil.isInsideRestrictedZone(zones, x4, y, z4, doWaterCheck) then
            return true
        end

        if not g_currentMission.placeableSystem:getIsInsideBoundary(x1, z1) then
            return true
        end

        if not g_currentMission.placeableSystem:getIsInsideBoundary(x2, z2) then
            return true
        end

        if not g_currentMission.placeableSystem:getIsInsideBoundary(x3, z3) then
            return true
        end

        if not g_currentMission.placeableSystem:getIsInsideBoundary(x4, z4) then
            return true
        end
    end

    return false
end

```

### getIsAreaOwnedByFarm

**Description**

**Definition**

> getIsAreaOwnedByFarm()

**Arguments**

| any | sx     |
|-----|--------|
| any | sz     |
| any | wx     |
| any | wz     |
| any | hx     |
| any | hz     |
| any | farmId |

**Code**

```lua
function PlaceablePlacement:getIsAreaOwnedByFarm(sx, sz, wx, wz, hx, hz, farmId)
    local dx1, dz1 = wx - sx, wz - sz
    local dx2, dz2 = hx - sx, hz - sz

    -- DebugLine.renderBetweenPositions(sx, nil, sz, wx, nil, wz, Color.PRESETS.RED)
    -- DebugLine.renderBetweenPositions(sx, nil, sz, hx, nil, hz, Color.PRESETS.GREEN)
    -- DebugLine.renderBetweenPositions(hx, nil, hz, hx + dx1, nil, hz + dz1, Color.PRESETS.BLUE)
    -- DebugLine.renderBetweenPositions(wx, nil, wz, wx + dx2, nil, wz + dz2, Color.PRESETS.YELLOW)

    return g_farmlandManager:getIsOwnedByFarmAlongLine(farmId, sx, sz, wx, wz) and
    g_farmlandManager:getIsOwnedByFarmAlongLine(farmId, sx, sz, hx, hz) and
    g_farmlandManager:getIsOwnedByFarmAlongLine(farmId, hx, hz, hx + dx1, hz + dz1) and
    g_farmlandManager:getIsOwnedByFarmAlongLine(farmId, wx, wz, wx + dx2, wz + dz2)
end

```

### getPlacementPosition

**Description**

**Definition**

> getPlacementPosition()

**Arguments**

| any | x |
|-----|---|
| any | y |
| any | z |

**Code**

```lua
function PlaceablePlacement:getPlacementPosition(x, y, z)
    local spec = self.spec_placement
    local snapSize = spec.positionSnapSize
    if snapSize ~ = 0 then
        snapSize = 1 / snapSize

        x = math.floor(x * snapSize) / snapSize + spec.positionSnapOffset
        z = math.floor(z * snapSize) / snapSize + spec.positionSnapOffset
    end

    return x, y, z
end

```

### getPlacementRotation

**Description**

**Definition**

> getPlacementRotation()

**Arguments**

| any | x |
|-----|---|
| any | y |
| any | z |

**Code**

```lua
function PlaceablePlacement:getPlacementRotation(x, y, z)
    local spec = self.spec_placement
    if spec.rotationSnapAngle ~ = 0 then
        local degAngle = MathUtil.snapValue( math.deg(y), math.deg(spec.rotationSnapAngle))
        y = math.rad(degAngle)
    end

    return x, y, z
end

```

### getPositionSnapOffset

**Description**

**Definition**

> getPositionSnapOffset()

**Code**

```lua
function PlaceablePlacement:getPositionSnapOffset()
    return self.spec_placement.positionSnapOffset
end

```

### getPositionSnapSize

**Description**

**Definition**

> getPositionSnapSize()

**Code**

```lua
function PlaceablePlacement:getPositionSnapSize()
    return self.spec_placement.positionSnapSize
end

```

### getRotationSnapAngle

**Description**

**Definition**

> getRotationSnapAngle()

**Code**

```lua
function PlaceablePlacement:getRotationSnapAngle()
    return self.spec_placement.rotationSnapAngle
end

```

### getTestParallelogramAtWorldPosition

**Description**

**Definition**

> getTestParallelogramAtWorldPosition()

**Arguments**

| any | testArea |
|-----|----------|
| any | x        |
| any | z        |
| any | rotY     |

**Code**

```lua
function PlaceablePlacement:getTestParallelogramAtWorldPosition(testArea, x, z, rotY)
    local dirX, dirZ = MathUtil.getDirectionFromYRotation(rotY)
    local normX, _, normZ = MathUtil.crossProduct( 0 , 1 , 0 , dirX, 0 , dirZ)

    local centerXOffset = testArea.center.x
    local centerZOffset = testArea.center.z
    local centerX = x + dirX * centerZOffset + normX * centerXOffset
    local centerZ = z + dirZ * centerZOffset + normZ * centerXOffset

    dirX, dirZ = MathUtil.getDirectionFromYRotation(rotY + testArea.rotYOffset)
    normX, _, normZ = MathUtil.crossProduct( 0 , 1 , 0 , dirX, 0 , dirZ)

    local startOffsetX = testArea.size.x * 0.5
    local startOffsetZ = testArea.size.z * 0.5
    local startX = centerX - dirX * startOffsetZ - normX * startOffsetX
    local startZ = centerZ - dirZ * startOffsetZ - normZ * startOffsetX

    local widthOffset = testArea.size.x
    local widthX = startX + normX * widthOffset
    local widthZ = startZ + normZ * widthOffset

    local heightOffset = testArea.size.z
    local heightX = startX + dirX * heightOffset
    local heightZ = startZ + dirZ * heightOffset

    local heightX2 = widthX + dirX * heightOffset
    local heightZ2 = widthZ + dirZ * heightOffset

    return startX, startZ, widthX, widthZ, heightX, heightZ, heightX2, heightZ2
end

```

### loadTestArea

**Description**

**Definition**

> loadTestArea()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | area    |

**Code**

```lua
function PlaceablePlacement:loadTestArea(xmlFile, key, area)
    local startNode = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
    local endNode = xmlFile:getValue(key .. "#endNode" , nil , self.components, self.i3dMappings)

    if startNode = = nil then
        Logging.xmlWarning(xmlFile, "Missing test area start node for '%s'" , key)
            return false
        end

        if endNode = = nil then
            Logging.xmlWarning(xmlFile, "Missing test area end node for '%s'" , key)
            return false
        end

        if getParent(endNode) ~ = startNode then
            Logging.xmlWarning(xmlFile, "Test area end node is not a direct child of startNode for '%s'" , key)
            return false
        end

        area.startNode = startNode
        area.endNode = endNode

        local ySafetyOffset = 0.05 -- shift all test areas down by 5cm to avoid stacking of placables with testArea start at y = 0
        local offsetX, offsetY, offsetZ = localToLocal(endNode, startNode, 0 , - ySafetyOffset, 0 )
        local centerX, centerY, centerZ = localToLocal(startNode, self.rootNode, offsetX * 0.5 , offsetY * 0.5 , offsetZ * 0.5 )
        local sizeX, sizeY, sizeZ = math.abs(offsetX), math.abs(offsetY + ySafetyOffset), math.abs(offsetZ)

        if offsetY < 0.01 then
            Logging.xmlDevWarning(xmlFile, "TestArea '%s 'has no height(endNode has same y as startNode)" , key)
        end

        area.size = { }
        area.size.x = math.abs(sizeX)
        area.size.y = math.abs(sizeY)
        area.size.z = math.abs(sizeZ)

        area.center = { }
        area.center.x = centerX
        area.center.y = centerY
        area.center.z = centerZ

        local dirX, _, dirZ = localDirectionToLocal(startNode, self.rootNode, 0 , 0 , 1 )
        local rotY = MathUtil.getYRotationFromDirection(dirX, dirZ)
        area.rotYOffset = rotY

        return true
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceablePlacement:onDelete()
    if self.isClient then
        local spec = self.spec_placement
        g_soundManager:deleteSamples(spec.samples)
    end
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
function PlaceablePlacement:onLoad(savegame)
    local spec = self.spec_placement
    local xmlFile = self.xmlFile

    spec.testAreas = { }
    xmlFile:iterate( "placeable.placement.testAreas.testArea" , function (_, key)
        local testArea = { }
        if self:loadTestArea(xmlFile, key, testArea) then
            table.insert(spec.testAreas, testArea)
        end
    end )

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#sizeX" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#sizeZ" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#sizeOffsetX" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#sizeOffsetZ" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#testSizeX" , "placeable.placement.testAreas.testArea" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#testSizeZ" , "placeable.placement.testAreas.testArea" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#testSizeOffsetX" , "placeable.placement.testAreas.testArea" ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "placeable.placement#testSizeOffsetZ" , "placeable.placement.testAreas.testArea" ) -- FS19 to FS22

    spec.useRandomYRotation = xmlFile:getValue( "placeable.placement#useRandomYRotation" , spec.useRandomYRotation)
    spec.useManualYRotation = xmlFile:getValue( "placeable.placement#useManualYRotation" , spec.useManualYRotation)
    spec.positionSnapSize = math.abs(xmlFile:getValue( "placeable.placement#placementPositionSnapSize" , 0.0 ))
    spec.positionSnapOffset = math.abs(xmlFile:getValue( "placeable.placement#placementPositionSnapOffset" , 0.0 ))
    spec.rotationSnapAngle = math.abs(xmlFile:getValue( "placeable.placement#placementRotationSnapAngle" , 0.0 ))

    spec.alignToWorldY = xmlFile:getValue( "placeable.placement#alignToWorldY" , true )
    if not spec.alignToWorldY then
        spec.pos1Node = xmlFile:getValue( "placeable.placement#pos1Node" , nil , self.components, self.i3dMappings)
        spec.pos2Node = xmlFile:getValue( "placeable.placement#pos2Node" , nil , self.components, self.i3dMappings)
        spec.pos3Node = xmlFile:getValue( "placeable.placement#pos3Node" , nil , self.components, self.i3dMappings)
        if spec.pos1Node = = nil or spec.pos2Node = = nil or spec.pos3Node = = nil then
            spec.alignToWorldY = true
            Logging.xmlWarning(xmlFile, "pos1Node, pos2Node and pos3Node has to be set when alignToWorldY is false!" )
        end
    end

    if self.isClient and Platform.hasContruction then
        spec.samples = { }
        spec.samples.place = g_soundManager:loadSample2DFromXML(xmlFile.handle, "placeable.placement.sounds" , "place" , self.baseDirectory, 1 , AudioGroup.GUI)
        spec.samples.placeLayered = g_soundManager:loadSample2DFromXML(xmlFile.handle, "placeable.placement.sounds" , "placeLayered" , self.baseDirectory, 1 , AudioGroup.GUI)
        spec.samples.destroy = g_soundManager:loadSample2DFromXML(xmlFile.handle, "placeable.placement.sounds" , "destroy" , self.baseDirectory, 1 , AudioGroup.GUI)
    end
end

```

### onPreFinalizePlacement

**Description**

**Definition**

> onPreFinalizePlacement()

**Code**

```lua
function PlaceablePlacement:onPreFinalizePlacement()
    local spec = self.spec_placement
    -- only(re-)align if the property is set and we're on the server, clients will get the correct transform in sync.
        -- This also avoids wrong positioning of placeables on modified terrain.
        if not spec.alignToWorldY and self.isServer then
            local x1,y1,z1 = getWorldTranslation( self.rootNode)
            y1 = getTerrainHeightAtWorldPos(g_terrainNode, x1,y1,z1)
            setTranslation( self.rootNode, x1,y1,z1)
            local x2,y2,z2 = getWorldTranslation(spec.pos1Node)
            y2 = getTerrainHeightAtWorldPos(g_terrainNode, x2,y2,z2)
            local x3,y3,z3 = getWorldTranslation(spec.pos2Node)
            y3 = getTerrainHeightAtWorldPos(g_terrainNode, x3,y3,z3)
            local x4,y4,z4 = getWorldTranslation(spec.pos3Node)
            y4 = getTerrainHeightAtWorldPos(g_terrainNode, x4,y4,z4)
            local dirX = x2 - x1
            local dirY = y2 - y1
            local dirZ = z2 - z1
            local dir2X = x3 - x4
            local dir2Y = y3 - y4
            local dir2Z = z3 - z4
            local upX,upY,upZ = MathUtil.crossProduct(dir2X, dir2Y, dir2Z, dirX, dirY, dirZ)
            setDirection( self.rootNode, dirX, dirY, dirZ, upX,upY,upZ)
        end
    end

```

### playDestroySound

**Description**

**Definition**

> playDestroySound()

**Arguments**

| any | onlyIfNotPlaying |
|-----|------------------|

**Code**

```lua
function PlaceablePlacement:playDestroySound(onlyIfNotPlaying)
    if self.isClient then
        local spec = self.spec_placement

        if not onlyIfNotPlaying or not g_soundManager:getIsSamplePlaying(spec.samples.destroy) then
            g_soundManager:playSample(spec.samples.destroy)
        end
    end
end

```

### playPlaceSound

**Description**

**Definition**

> playPlaceSound()

**Code**

```lua
function PlaceablePlacement:playPlaceSound()
    if self.isClient then
        local spec = self.spec_placement
        g_soundManager:playSample(spec.samples.place)
        g_soundManager:playSample(spec.samples.placeLayered)
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
function PlaceablePlacement.prerequisitesPresent(specializations)
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
function PlaceablePlacement.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceablePlacement )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceablePlacement )
    SpecializationUtil.registerEventListener(placeableType, "onPreFinalizePlacement" , PlaceablePlacement )
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
function PlaceablePlacement.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "loadTestArea" , PlaceablePlacement.loadTestArea)
    SpecializationUtil.registerFunction(placeableType, "getIsAreaOwnedByFarm" , PlaceablePlacement.getIsAreaOwnedByFarm)
    SpecializationUtil.registerFunction(placeableType, "getIsOnOwnedFarmland" , PlaceablePlacement.getIsOnOwnedFarmland)
    SpecializationUtil.registerFunction(placeableType, "startPlacementCheck" , PlaceablePlacement.startPlacementCheck)
    SpecializationUtil.registerFunction(placeableType, "getPlacementRotation" , PlaceablePlacement.getPlacementRotation)
    SpecializationUtil.registerFunction(placeableType, "getPlacementPosition" , PlaceablePlacement.getPlacementPosition)
    SpecializationUtil.registerFunction(placeableType, "getPositionSnapSize" , PlaceablePlacement.getPositionSnapSize)
    SpecializationUtil.registerFunction(placeableType, "getPositionSnapOffset" , PlaceablePlacement.getPositionSnapOffset)
    SpecializationUtil.registerFunction(placeableType, "getRotationSnapAngle" , PlaceablePlacement.getRotationSnapAngle)
    SpecializationUtil.registerFunction(placeableType, "getPlacementOverlapMask" , PlaceablePlacement.getPlacementOverlapMask)
    SpecializationUtil.registerFunction(placeableType, "isValidOverlapNode" , PlaceablePlacement.isValidOverlapNode)
    SpecializationUtil.registerFunction(placeableType, "getHasOverlap" , PlaceablePlacement.getHasOverlap)
    SpecializationUtil.registerFunction(placeableType, "getHasOverlapWithPlaces" , PlaceablePlacement.getHasOverlapWithPlaces)
    SpecializationUtil.registerFunction(placeableType, "getCanBePlacedInWater" , PlaceablePlacement.getCanBePlacedInWater)
    SpecializationUtil.registerFunction(placeableType, "getHasOverlapWithZones" , PlaceablePlacement.getHasOverlapWithZones)
    SpecializationUtil.registerFunction(placeableType, "getTestParallelogramAtWorldPosition" , PlaceablePlacement.getTestParallelogramAtWorldPosition)
    SpecializationUtil.registerFunction(placeableType, "playPlaceSound" , PlaceablePlacement.playPlaceSound)
    SpecializationUtil.registerFunction(placeableType, "playDestroySound" , PlaceablePlacement.playDestroySound)
    SpecializationUtil.registerFunction(placeableType, "getIsAreaBlocked" , PlaceablePlacement.getIsAreaBlocked)
    SpecializationUtil.registerFunction(placeableType, "getHasOverlapWithDensityHeight" , PlaceablePlacement.getHasOverlapWithDensityHeight)
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
function PlaceablePlacement.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Placement" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".placement#pos1Node" , "Position node 1(Required if alignToWorldY is false to calculate the terrain alignment)" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".placement#pos2Node" , "Position node 2(Required if alignToWorldY is false to calculate the terrain alignment)" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. ".placement#pos3Node" , "Position node 3(Required if alignToWorldY is false to calculate the terrain alignment)" )

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".placement.testAreas.testArea(?)#startNode" , "Start node of box for testing overlap" )
                    schema:register(XMLValueType.NODE_INDEX, basePath .. ".placement.testAreas.testArea(?)#endNode" , "End node of box for testing overlap" )

                        schema:register(XMLValueType.BOOL, basePath .. ".placement#useRandomYRotation" , "Use random Y rotation" , false )
                        schema:register(XMLValueType.BOOL, basePath .. ".placement#useManualYRotation" , "Use manual Y rotation" , false )
                        schema:register(XMLValueType.BOOL, basePath .. ".placement#alignToWorldY" , "Placeable is aligned to world Y instead of terrain" , true )
                        schema:register(XMLValueType.FLOAT, basePath .. ".placement#placementPositionSnapSize" , "Position snap size" , 0 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".placement#placementPositionSnapOffset" , "Position snap offset" , 0 )
                        schema:register(XMLValueType.ANGLE, basePath .. ".placement#placementRotationSnapAngle" , "Rotation snap angle" , 0 )

                        SoundManager.registerSampleXMLPaths(schema, basePath .. ".placement.sounds" , "place" )
                        SoundManager.registerSampleXMLPaths(schema, basePath .. ".placement.sounds" , "placeLayered" )
                        SoundManager.registerSampleXMLPaths(schema, basePath .. ".placement.sounds" , "destroy" )

                        schema:setXMLSpecializationType()
                    end

```

### startPlacementCheck

**Description**

**Definition**

> startPlacementCheck()

**Arguments**

| any | x    |
|-----|------|
| any | y    |
| any | z    |
| any | rotY |

**Code**

```lua
function PlaceablePlacement:startPlacementCheck(x, y, z, rotY)
end

```