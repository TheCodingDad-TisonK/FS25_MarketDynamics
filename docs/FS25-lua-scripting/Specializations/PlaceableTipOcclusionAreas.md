## PlaceableTipOcclusionAreas

**Description**

> Specialization for placeables

**Functions**

- [loadTipOcclusionArea](#loadtipocclusionarea)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [updateTipOcclusionAreas](#updatetipocclusionareas)

### loadTipOcclusionArea

**Description**

**Definition**

> loadTipOcclusionArea()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | area    |

**Code**

```lua
function PlaceableTipOcclusionAreas:loadTipOcclusionArea(xmlFile, key, area)
    local startNode = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
    local endNode = xmlFile:getValue(key .. "#endNode" , nil , self.components, self.i3dMappings)

    if startNode = = nil then
        Logging.xmlWarning(xmlFile, "Missing tip occlusion update area start node for '%s'" , key)
            return false
        end

        if endNode = = nil then
            Logging.xmlWarning(xmlFile, "Missing tip occlusion update area end node for '%s'" , key)
            return false
        end

        local startX, _, startZ = localToLocal(startNode, self.rootNode, 0 , 0 , 0 )
        local endX, _, endZ = localToLocal(endNode, self.rootNode, 0 , 0 , 0 )

        local sizeX = math.abs(endX - startX)
        local sizeZ = math.abs(endZ - startZ)

        area.center = { }
        area.center.x = (endX + startX) * 0.5
        area.center.z = (endZ + startZ) * 0.5

        area.size = { }
        area.size.x = sizeX
        area.size.z = sizeZ

        area.startNode = startNode
        area.endNode = endNode

        return true
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableTipOcclusionAreas:onDelete()
    if self.isServer then
        if not self.isReloading then
            local spec = self.spec_tipOcclusionAreas
            if spec.updateTipOcclusionAreasOnDelete then
                self:updateTipOcclusionAreas()
                spec.updateTipOcclusionAreasOnDelete = false
            end
        end
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableTipOcclusionAreas:onFinalizePlacement()
    if self.isServer then
        local missionInfo = g_currentMission.missionInfo
        if not self.isLoadedFromSavegame or not missionInfo.isValid or not missionInfo:getIsTipCollisionValid(g_currentMission) or not missionInfo:getIsPlacementCollisionValid(g_currentMission) then
            self:updateTipOcclusionAreas()
        end

        local spec = self.spec_tipOcclusionAreas
        spec.updateTipOcclusionAreasOnDelete = true
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
function PlaceableTipOcclusionAreas:onLoad(savegame)
    local spec = self.spec_tipOcclusionAreas
    local xmlFile = self.xmlFile

    spec.updateTipOcclusionAreasOnDelete = false
    spec.areas = { }
    xmlFile:iterate( "placeable.tipOcclusionUpdateAreas.tipOcclusionUpdateArea" , function (_, key)
        local area = { }
        if self:loadTipOcclusionArea(xmlFile, key, area) then
            table.insert(spec.areas, area)
        end
    end )

    if xmlFile:hasProperty( "placeable.tipOcclusionUpdateArea" ) then
        local sizeX = xmlFile:getValue( "placeable.tipOcclusionUpdateArea#sizeX" )
        local sizeZ = xmlFile:getValue( "placeable.tipOcclusionUpdateArea#sizeZ" )

        if sizeX ~ = nil and sizeZ ~ = nil then
            local centerX = xmlFile:getValue( "placeable.tipOcclusionUpdateArea#centerX" , 0 )
            local centerZ = xmlFile:getValue( "placeable.tipOcclusionUpdateArea#centerZ" , 0 )

            local area = { }
            area.center = { }
            area.center.x = centerX
            area.center.z = centerZ

            area.size = { }
            area.size.x = sizeX
            area.size.z = sizeZ

            table.insert(spec.areas, area)
        end
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
function PlaceableTipOcclusionAreas.prerequisitesPresent(specializations)
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
function PlaceableTipOcclusionAreas.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableTipOcclusionAreas )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableTipOcclusionAreas )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableTipOcclusionAreas )
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
function PlaceableTipOcclusionAreas.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "loadTipOcclusionArea" , PlaceableTipOcclusionAreas.loadTipOcclusionArea)
    SpecializationUtil.registerFunction(placeableType, "updateTipOcclusionAreas" , PlaceableTipOcclusionAreas.updateTipOcclusionAreas)
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
function PlaceableTipOcclusionAreas.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "TipOcclusionAreas" )
    schema:register(XMLValueType.FLOAT, basePath .. ".tipOcclusionUpdateArea#sizeX" , "Size X" )
    schema:register(XMLValueType.FLOAT, basePath .. ".tipOcclusionUpdateArea#sizeZ" , "Size Z" )
    schema:register(XMLValueType.FLOAT, basePath .. ".tipOcclusionUpdateArea#centerX" , "Center position X" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. ".tipOcclusionUpdateArea#centerZ" , "Center position Z" , 0 )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".tipOcclusionUpdateAreas.tipOcclusionUpdateArea(?)#startNode" , "Start node of tipOcclusion update area" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".tipOcclusionUpdateAreas.tipOcclusionUpdateArea(?)#endNode" , "End node of tipOcclusion update area" )
    schema:setXMLSpecializationType()
end

```

### updateTipOcclusionAreas

**Description**

**Definition**

> updateTipOcclusionAreas()

**Code**

```lua
function PlaceableTipOcclusionAreas:updateTipOcclusionAreas()
    if self.isServer then
        local spec = self.spec_tipOcclusionAreas
        for _, area in pairs(spec.areas) do
            local x, z = area.center.x, area.center.z
            local sizeX, sizeZ = area.size.x, area.size.z

            local x1, _, z1 = localToWorld( self.rootNode, x + sizeX * 0.5 , 0 , z + sizeZ * 0.5 )
            local x2, _, z2 = localToWorld( self.rootNode, x - sizeX * 0.5 , 0 , z + sizeZ * 0.5 )
            local x3, _, z3 = localToWorld( self.rootNode, x + sizeX * 0.5 , 0 , z - sizeZ * 0.5 )
            local x4, _, z4 = localToWorld( self.rootNode, x - sizeX * 0.5 , 0 , z - sizeZ * 0.5 )

            local minX = math.min(x1, x2, x3, x4)
            local maxX = math.max(x1, x2, x3, x4)
            local minZ = math.min(z1, z2, z3, z4)
            local maxZ = math.max(z1, z2, z3, z4)
            g_densityMapHeightManager:setCollisionMapAreaDirty(minX, minZ, maxX, maxZ, true )
        end
    end
end

```