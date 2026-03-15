## PlaceableBuyingStation

**Description**

> Specialization for placeables

**Functions**

- [collectPickObjects](#collectpickobjects)
- [getBuyingStation](#getbuyingstation)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)

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
function PlaceableBuyingStation:collectPickObjects(superFunc, node)
    local spec = self.spec_buyingStation
    if spec.buyingStation ~ = nil then
        for _, loadTrigger in ipairs(spec.buyingStation.loadTriggers) do
            if node = = loadTrigger.triggerNode then
                return
            end
        end
    end

    superFunc( self , node)
end

```

### getBuyingStation

**Description**

**Definition**

> getBuyingStation()

**Code**

```lua
function PlaceableBuyingStation:getBuyingStation()
    return self.spec_buyingStation.buyingStation
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PlaceableBuyingStation.initSpecialization()
    g_storeManager:addSpecType( "buyingStationFillTypes" , "shopListAttributeIconOutput" , BuyingStation.loadSpecValueFillTypes, BuyingStation.getSpecValueFillTypes, StoreSpecies.PLACEABLE)
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableBuyingStation:onDelete()
    local spec = self.spec_buyingStation

    if spec.buyingStation ~ = nil then
        g_currentMission.storageSystem:removeLoadingStation(spec.buyingStation, spec.buyingStation.owningPlaceable)
        spec.buyingStation:delete()
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Code**

```lua
function PlaceableBuyingStation:onFinalizePlacement()
    local spec = self.spec_buyingStation

    if spec.buyingStation ~ = nil then
        spec.buyingStation:register( true )
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
function PlaceableBuyingStation:onLoad(savegame)
    local spec = self.spec_buyingStation

    local buyingStation = BuyingStation.new( self.isServer, self.isClient)
    if buyingStation:load( self.components, self.xmlFile, "placeable.buyingStation" , self.customEnvironment, self.i3dMappings) then
        spec.buyingStation = buyingStation
        spec.buyingStation.owningPlaceable = self

        g_currentMission.storageSystem:addLoadingStation(spec.buyingStation, spec.buyingStation.owningPlaceable)
    else
            Logging.xmlError( self.xmlFile, "Could not load buying station" )
            buyingStation:delete()
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
function PlaceableBuyingStation:onReadStream(streamId, connection)
    local spec = self.spec_buyingStation
    if spec.buyingStation ~ = nil then
        local buyingStationId = NetworkUtil.readNodeObjectId(streamId)
        spec.buyingStation:readStream(streamId, connection)
        g_client:finishRegisterObject(spec.buyingStation, buyingStationId)
    end
end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function PlaceableBuyingStation:onWriteStream(streamId, connection)
    local spec = self.spec_buyingStation
    if spec.buyingStation ~ = nil then
        NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(spec.buyingStation))
        spec.buyingStation:writeStream(streamId, connection)
        g_server:registerObjectInStream(connection, spec.buyingStation)
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
function PlaceableBuyingStation.prerequisitesPresent(specializations)
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
function PlaceableBuyingStation.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableBuyingStation )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableBuyingStation )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableBuyingStation )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableBuyingStation )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableBuyingStation )
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
function PlaceableBuyingStation.registerFunctions(placeableType)
    SpecializationUtil.registerFunction(placeableType, "getBuyingStation" , PlaceableBuyingStation.getBuyingStation)
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
function PlaceableBuyingStation.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "collectPickObjects" , PlaceableBuyingStation.collectPickObjects)
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
function PlaceableBuyingStation.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "BuyingStation" )
    BuyingStation.registerXMLPaths(schema, basePath .. ".buyingStation" )
    schema:setXMLSpecializationType()
end

```