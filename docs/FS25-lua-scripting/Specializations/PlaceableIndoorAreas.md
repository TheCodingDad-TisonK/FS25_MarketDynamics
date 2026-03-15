## PlaceableIndoorAreas

**Description**

> Specialization for placeables

**Functions**

- [loadIndoorArea](#loadindoorarea)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)

### loadIndoorArea

**Description**

**Definition**

> loadIndoorArea()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | area    |

**Code**

```lua
function PlaceableIndoorAreas:loadIndoorArea(xmlFile, key, area)
    local start = xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
    if start = = nil then
        Logging.xmlWarning(xmlFile, "Indoor area start node not defined for '%s'" , key)
            return false
        end

        local width = xmlFile:getValue(key .. "#widthNode" , nil , self.components, self.i3dMappings)
        if width = = nil then
            Logging.xmlWarning(xmlFile, "Indoor area width node not defined for '%s'" , key)
                return false
            end

            local height = xmlFile:getValue(key .. "#heightNode" , nil , self.components, self.i3dMappings)
            if height = = nil then
                Logging.xmlWarning(xmlFile, "Indoor area height node not defined for '%s'" , key)
                    return false
                end

                area.start = start
                area.width = width
                area.height = height

                return true
            end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableIndoorAreas:onDelete()
    local spec = self.spec_indoorAreas

    if spec.areas ~ = nil and spec.resetIndoorMaskOnDelete and not self.isReloading then
        for _, area in ipairs(spec.areas) do
            g_currentMission.indoorMask:setStateByArea(area, IndoorMask.OUTDOOR)
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
function PlaceableIndoorAreas:onFinalizePlacement()
    local spec = self.spec_indoorAreas

    for _, area in pairs(spec.areas) do
        g_currentMission.indoorMask:setStateByArea(area, IndoorMask.INDOOR)
    end

    spec.resetIndoorMaskOnDelete = true
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
function PlaceableIndoorAreas:onLoad(savegame)
    local spec = self.spec_indoorAreas

    spec.resetIndoorMaskOnDelete = false
    spec.areas = { }
    self.xmlFile:iterate( "placeable.indoorAreas.indoorArea" , function (_, key)
        local area = { }
        if self:loadIndoorArea( self.xmlFile, key, area) then
            table.insert(spec.areas, area)
        end
    end )

    if not self.xmlFile:hasProperty( "placeable.indoorAreas" ) then
        Logging.xmlWarning( self.xmlFile, "Missing indoor areas" )
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
function PlaceableIndoorAreas.prerequisitesPresent(specializations)
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
function PlaceableIndoorAreas.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableIndoorAreas )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableIndoorAreas )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableIndoorAreas )
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
function PlaceableIndoorAreas.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "loadIndoorArea" , PlaceableIndoorAreas.loadIndoorArea)
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
function PlaceableIndoorAreas.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "IndoorAreas" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".indoorAreas.indoorArea(?)#startNode" , "Start node of indoor mask area" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".indoorAreas.indoorArea(?)#widthNode" , "Width node of indoor mask area" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".indoorAreas.indoorArea(?)#heightNode" , "Height node of indoor mask area" )
    schema:setXMLSpecializationType()
end

```