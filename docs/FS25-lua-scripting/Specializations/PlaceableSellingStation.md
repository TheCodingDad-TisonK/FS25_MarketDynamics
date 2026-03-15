## PlaceableSellingStation

**Description**

> Specialization for placeables

**Functions**

- [collectPickObjects](#collectpickobjects)
- [getSellingStation](#getsellingstation)
- [initSpecialization](#initspecialization)
- [loadFromXMLFile](#loadfromxmlfile)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)

### collectPickObjects

**Description**

**Definition**

> collectPickObjects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | node      |

**Code**

```lua
function PlaceableSellingStation:collectPickObjects(superFunc, node)
    local spec = self.spec_sellingStation

    local foundNode = false
    for _, unloadTrigger in ipairs(spec.sellingStation.unloadTriggers) do
        if node = = unloadTrigger.exactFillRootNode then
            foundNode = true
            break
        end
    end

    if not foundNode then
        superFunc( self , node)
    end
end

```

### getSellingStation

**Description**

**Definition**

> getSellingStation()

**Code**

```lua
function PlaceableSellingStation:getSellingStation()
    return self.spec_sellingStation.sellingStation
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableSellingStation.initSpecialization()
    g_storeManager:addSpecType( "sellingStationFillTypes" , "shopListAttributeIconInput" , SellingStation.loadSpecValueFillTypes, SellingStation.getSpecValueFillTypes, StoreSpecies.PLACEABLE)
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
function PlaceableSellingStation:loadFromXMLFile(xmlFile, key)
    local spec = self.spec_sellingStation
    spec.sellingStation:loadFromXMLFile(xmlFile, key)
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableSellingStation:onDelete()
    local spec = self.spec_sellingStation
    if spec.sellingStation ~ = nil then
        g_currentMission.storageSystem:removeUnloadingStation(spec.sellingStation, self )
        g_currentMission.economyManager:removeSellingStation(spec.sellingStation)
        spec.sellingStation:delete()
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableSellingStation:onFinalizePlacement()
    local spec = self.spec_sellingStation
    spec.sellingStation:register( true )
    g_currentMission.storageSystem:addUnloadingStation(spec.sellingStation, self )
    g_currentMission.economyManager:addSellingStation(spec.sellingStation)
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
function PlaceableSellingStation:onLoad(savegame)
    local spec = self.spec_sellingStation
    local xmlFile = self.xmlFile

    spec.sellingStation = SellingStation.new( self.isServer, self.isClient)
    spec.sellingStation:load( self.components, xmlFile, "placeable.sellingStation" , self.customEnvironment, self.i3dMappings, self.components[ 1 ].node)
    spec.sellingStation.owningPlaceable = self
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
function PlaceableSellingStation:onReadStream(streamId, connection)
    local spec = self.spec_sellingStation

    local sellingStationId = NetworkUtil.readNodeObjectId(streamId)
    spec.sellingStation:readStream(streamId, connection)
    g_client:finishRegisterObject(spec.sellingStation, sellingStationId)
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
function PlaceableSellingStation:onWriteStream(streamId, connection)
    local spec = self.spec_sellingStation

    NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.sellingStation))
    spec.sellingStation:writeStream(streamId, connection)
    g_server:registerObjectInStream(connection, spec.sellingStation)
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
function PlaceableSellingStation.prerequisitesPresent(specializations)
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
function PlaceableSellingStation.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableSellingStation )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableSellingStation )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableSellingStation )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableSellingStation )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableSellingStation )
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
function PlaceableSellingStation.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "getSellingStation" , PlaceableSellingStation.getSellingStation)
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
function PlaceableSellingStation.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableSellingStation.collectPickObjects)
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
function PlaceableSellingStation.registerSavegameXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "SellingStation" )
    SellingStation.registerSavegameXMLPaths(schema, basePath)
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
function PlaceableSellingStation.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "SellingStation" )
    SellingStation.registerXMLPaths(schema, basePath .. ".sellingStation" )
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
function PlaceableSellingStation:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_sellingStation
    spec.sellingStation:saveToXMLFile(xmlFile, key, usedModNames)
end

```