## PlaceableWashingStation

**Description**

> Specialization for placeables

**Functions**

- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [onLoad](#onload)
- [onReadStream](#onreadstream)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setOwnerFarmId](#setownerfarmid)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PlaceableWashingStation:onDelete()
    local spec = self.spec_washingStation

    if spec.washingStations ~ = nil then
        for _, washingStation in ipairs(spec.washingStations) do
            washingStation:delete()
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
function PlaceableWashingStation:onFinalizePlacement()
    local spec = self.spec_washingStation
    if spec.washingStations ~ = nil then
        for _, washingStation in ipairs(spec.washingStations) do
            washingStation:setOwnerFarmId( self:getOwnerFarmId(), true )
            washingStation:register( true )
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
function PlaceableWashingStation:onLoad(savegame)
    local spec = self.spec_washingStation

    spec.washingStations = { }
    self.xmlFile:iterate( "placeable.washingStation.station" , function (_, key)
        local washingStation = WashingStation.new( self.isServer, self.isClient)
        if washingStation:load( self.components, self.xmlFile, key, self.customEnvironment, self.i3dMappings, self.rootNode) then
            table.insert(spec.washingStations, washingStation)
        else
                washingStation:delete()
            end
        end )
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
function PlaceableWashingStation:onReadStream(streamId, connection)
    local spec = self.spec_washingStation

    if spec.washingStations ~ = nil then
        for _, washingStation in ipairs(spec.washingStations) do
            local washingStationId = NetworkUtil.readNodeObjectId(streamId)
            washingStation:readStream(streamId, connection)
            g_client:finishRegisterObject(washingStation, washingStationId)
        end
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
function PlaceableWashingStation:onWriteStream(streamId, connection)
    local spec = self.spec_washingStation

    if spec.washingStations ~ = nil then
        for _, washingStation in ipairs(spec.washingStations) do
            NetworkUtil.writeNodeObjectId(streamId, NetworkUtil.getObjectId(washingStation))
            washingStation:writeStream(streamId, connection)
            g_server:registerObjectInStream(connection, washingStation)
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
function PlaceableWashingStation.prerequisitesPresent(specializations)
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
function PlaceableWashingStation.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onLoad" , PlaceableWashingStation )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , PlaceableWashingStation )
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , PlaceableWashingStation )
    SpecializationUtil.registerEventListener(placeableType, "onReadStream" , PlaceableWashingStation )
    SpecializationUtil.registerEventListener(placeableType, "onWriteStream" , PlaceableWashingStation )
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
function PlaceableWashingStation.registerOverwrittenFunctions(placeableType)
    SpecializationUtil.registerOverwrittenFunction(placeableType, "setOwnerFarmId" , PlaceableWashingStation.setOwnerFarmId)
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
function PlaceableWashingStation.registerXMLPaths(schema, basePath)
    schema:setXMLSpecializationType( "WashingStation" )
    WashingStation.registerXMLPaths(schema, basePath .. ".washingStation.station(?)" )
    schema:setXMLSpecializationType()
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
function PlaceableWashingStation:setOwnerFarmId(superFunc, farmId, noEventSend)
    local spec = self.spec_washingStation

    superFunc( self , farmId, noEventSend)

    if spec.washingStations ~ = nil then
        for _, washingStation in ipairs(spec.washingStations) do
            washingStation:setOwnerFarmId(farmId, true )
        end
    end
end

```