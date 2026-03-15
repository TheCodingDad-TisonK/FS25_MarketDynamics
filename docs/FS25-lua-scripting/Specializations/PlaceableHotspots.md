## PlaceableHotspots

**Description**

> Specialization for placeables

**Functions**

- [getHotspot](#gethotspot)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onOwnerChanged](#onownerchanged)
- [onPostFinalizePlacement](#onpostfinalizeplacement)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### getHotspot

**Description**

**Definition**

> getHotspot()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function PlaceableHotspots:getHotspot(index)
    local spec = self.spec_hotspots
    return spec.mapHotspots[index or 1 ]
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableHotspots:onDelete()
    local spec = self.spec_hotspots

    g_messageCenter:unsubscribeAll( self )
    if spec.mapHotspots ~ = nil then
        for _, hotspot in ipairs(spec.mapHotspots) do
            g_currentMission:removeMapHotspot(hotspot)
            hotspot:delete()
        end
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
function PlaceableHotspots:onLoad(savegame)
    local spec = self.spec_hotspots

    spec.mapHotspots = { }
    self.xmlFile:iterate( "placeable.hotspots.hotspot" , function (_, key)
        local hotspot = PlaceableHotspot.new()
        hotspot:setPlaceable( self )

        local hotspotTypeName = self.xmlFile:getValue(key .. "#type" , "UNLOADING" )
        local hotspotType = PlaceableHotspot.getTypeByName(hotspotTypeName)
        if hotspotType = = nil then
            Logging.xmlWarning( self.xmlFile, "Unknown placeable hotspot type '%s'.Falling back to type 'UNLOADING'\nAvailable types: %s" , hotspotTypeName, table.concatKeys(PlaceableHotspot.TYPE, " " ))
            hotspotType = PlaceableHotspot.TYPE.UNLOADING
        end
        hotspot:setPlaceableType(hotspotType)

        local linkNode = self.xmlFile:getValue(key .. "#linkNode" , nil , self.components, self.i3dMappings) or self.rootNode
        if linkNode ~ = nil then
            local x, _, z = getWorldTranslation(linkNode)
            hotspot:setWorldPosition(x, z)
        end

        local teleportNode = self.xmlFile:getValue(key .. "#teleportNode" , nil , self.components, self.i3dMappings)
        if teleportNode ~ = nil then
            local x, y, z = getWorldTranslation(teleportNode)
            hotspot:setTeleportWorldPosition(x, y, z)
        end

        local worldPositionX, worldPositionZ = self.xmlFile:getValue(key .. "#worldPosition" , nil )
        if worldPositionX ~ = nil then
            hotspot:setWorldPosition(worldPositionX, worldPositionZ)
        end

        local teleportX, teleportY, teleportZ = self.xmlFile:getValue(key .. "#teleportWorldPosition" , nil )
        if teleportX ~ = nil then
            if g_currentMission ~ = nil then
                teleportY = math.max(teleportY, getTerrainHeightAtWorldPos(g_terrainNode, teleportX, 0 , teleportZ))
            end
            hotspot:setTeleportWorldPosition(teleportX, teleportY, teleportZ)
        end

        local text = self.xmlFile:getValue(key .. "#text" , nil )
        if text ~ = nil then
            text = g_i18n:convertText(text, self.customEnvironment)
            hotspot:setName(text)
        end

        table.insert(spec.mapHotspots, hotspot)
    end )
end

```

### onOwnerChanged

**Description**

**Definition**

> onOwnerChanged()

**Code**

```lua
function PlaceableHotspots:onOwnerChanged()
    self:updateHotspots()
end

```

### onPostFinalizePlacement

**Description**

**Definition**

> onPostFinalizePlacement()

**Code**

```lua
function PlaceableHotspots:onPostFinalizePlacement()
    local spec = self.spec_hotspots

    -- Add now so that the hotspot does not show up during placement
    for _, hotspot in ipairs(spec.mapHotspots) do
        g_currentMission:addMapHotspot(hotspot)
    end

    self:updateHotspots()
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
function PlaceableHotspots.prerequisitesPresent(specializations)
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
function PlaceableHotspots.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableHotspots )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableHotspots )
    SpecializationUtil.registerEventListener(placeableType, "onPostFinalizePlacement" , PlaceableHotspots )
    SpecializationUtil.registerEventListener(placeableType, "onOwnerChanged" , PlaceableHotspots )
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
function PlaceableHotspots.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "getHotspot" , PlaceableHotspots.getHotspot)
    SpecializationUtil.registerFunction(placeableType, "updateHotspots" , PlaceableHotspots.updateHotspots)
    SpecializationUtil.registerFunction(placeableType, "setHotspotVisible" , PlaceableHotspots.setHotspotVisible)
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
function PlaceableHotspots.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "Hotspots" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".hotspots.hotspot(?)#linkNode" , "Node where hotspot is linked to" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".hotspots.hotspot(?)#teleportNode" , "Node where player is teleported to.Teleporting is only available if this is set" )
        schema:register(XMLValueType.STRING, basePath .. ".hotspots.hotspot(?)#type" , "Placeable hotspot type" , "UNLOADING" , false , table.toList(PlaceableHotspot.TYPE))
        schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".hotspots.hotspot(?)#worldPosition" , "Placeable world position" )
        schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".hotspots.hotspot(?)#teleportWorldPosition" , "Placeable teleport world position" )
        schema:register(XMLValueType.STRING, basePath .. ".hotspots.hotspot(?)#text" , "Placeable hotspot text" )
        schema:setXMLSpecializationType()
    end

```