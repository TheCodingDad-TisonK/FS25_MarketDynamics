## PlaceableNPCSpot

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerXMLPaths](#registerxmlpaths)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableNPCSpot:onDelete()
    local spec = self.spec_npcSpot
    if spec.spots ~ = nil then
        for _, spot in ipairs(spec.spots) do
            g_npcManager:removeSpot(spot)
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
function PlaceableNPCSpot:onFinalizePlacement()
    local spec = self.spec_npcSpot
    if spec.spots ~ = nil then
        for _, spot in ipairs(spec.spots) do
            g_npcManager:addSpot(spot)
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
function PlaceableNPCSpot:onLoad(savegame)
    local spec = self.spec_npcSpot

    local placeableUniqueId = self:getUniqueId()

    local spots = { }
    for index, key in self.xmlFile:iterator( "placeable.npcSpots.spot" ) do
        local uniqueId = string.format( "PlaceableNPCSpot_%s_%d" , placeableUniqueId, index)
        local spot = NPCSpot.new()
        if spot:loadFromXMLFile( self.xmlFile, key, self.components, self.i3dMappings, uniqueId) then
            table.insert(spots, spot)
        else
                spot:delete()
            end
        end

        if #spots > 0 then
            spec.spots = spots
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
function PlaceableNPCSpot.prerequisitesPresent(specializations)
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
function PlaceableNPCSpot.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableNPCSpot )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableNPCSpot )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableNPCSpot )
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
function PlaceableNPCSpot.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "NPCSpot" )
    NPCSpot.registerXMLPaths(schema, basePath .. ".npcSpots.spot(?)" )
    schema:setXMLSpecializationType()
end

```