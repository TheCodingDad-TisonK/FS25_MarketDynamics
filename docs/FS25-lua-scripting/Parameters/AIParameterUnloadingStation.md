## AIParameterUnloadingStation

**Parent**

> [AIParameter](?version=script&category=65&class=594)

**Functions**

- [getString](#getstring)
- [getUnloadingStation](#getunloadingstation)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [onPlaceableLoaded](#onplaceableloaded)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setNextItem](#setnextitem)
- [setPreviousItem](#setpreviousitem)
- [setUnloadingStation](#setunloadingstation)
- [setUnloadingStationFromUniqueId](#setunloadingstationfromuniqueid)
- [setValidUnloadingStations](#setvalidunloadingstations)
- [validate](#validate)
- [writeStream](#writestream)

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterUnloadingStation:getString()
    local unloadingStation = NetworkUtil.getObject( self.unloadingStationId)
    if unloadingStation ~ = nil then
        return unloadingStation:getName()
    end

    return ""
end

```

### getUnloadingStation

**Description**

**Definition**

> getUnloadingStation()

**Code**

```lua
function AIParameterUnloadingStation:getUnloadingStation()
    local unloadingStation = NetworkUtil.getObject( self.unloadingStationId)
    if unloadingStation ~ = nil and unloadingStation.owningPlaceable ~ = nil and unloadingStation.owningPlaceable:getIsSynchronized() then
        return unloadingStation
    end

    return nil
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
function AIParameterUnloadingStation:loadFromXMLFile(xmlFile, key)
    local unloadingStationUniqueId = xmlFile:getString(key .. "#stationUniqueId" )
    local stationIndex = xmlFile:getInt(key .. "#stationIndex" )

    if unloadingStationUniqueId ~ = nil and stationIndex ~ = nil then
        if not self:setUnloadingStationFromUniqueId(unloadingStationUniqueId, stationIndex) then
            g_messageCenter:subscribeOneshot(MessageType.LOADED_ALL_SAVEGAME_PLACEABLES, self.onPlaceableLoaded, self , { unloadingStationUniqueId, stationIndex } )
        end
    end
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Code**

```lua
function AIParameterUnloadingStation.new(customMt)
    local self = AIParameter.new(customMt or AIParameterUnloadingStation _mt)

    self.type = AIParameterType.UNLOADING_STATION

    self.unloadingStationId = nil
    self.unloadingStationIds = { }

    return self
end

```

### onPlaceableLoaded

**Description**

**Definition**

> onPlaceableLoaded()

**Arguments**

| any | args |
|-----|------|

**Code**

```lua
function AIParameterUnloadingStation:onPlaceableLoaded(args)
    self:setUnloadingStationFromUniqueId(args[ 1 ], args[ 2 ])
end

```

### readStream

**Description**

**Definition**

> readStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AIParameterUnloadingStation:readStream(streamId, connection)
    if streamReadBool(streamId) then
        self.unloadingStationId = NetworkUtil.readNodeObjectId(streamId)
    end
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
function AIParameterUnloadingStation:saveToXMLFile(xmlFile, key, usedModNames)
    local unloadingStation = self:getUnloadingStation()
    if unloadingStation ~ = nil then
        local owningPlaceable = unloadingStation.owningPlaceable
        if owningPlaceable ~ = nil then
            local uniqueId = owningPlaceable:getUniqueId()
            if uniqueId ~ = nil then
                local index = g_currentMission.storageSystem:getPlaceableUnloadingStationIndex(owningPlaceable, unloadingStation)
                if index ~ = nil then
                    xmlFile:setString(key .. "#stationUniqueId" , uniqueId)
                    xmlFile:setInt(key .. "#stationIndex" , index)
                end
            end
        end
    end
end

```

### setNextItem

**Description**

**Definition**

> setNextItem()

**Code**

```lua
function AIParameterUnloadingStation:setNextItem()
    local nextIndex = 0
    for k, unloadingStationId in ipairs( self.unloadingStationIds) do
        if unloadingStationId = = self.unloadingStationId then
            nextIndex = k + 1
        end
    end

    if nextIndex > # self.unloadingStationIds then
        nextIndex = 1
    end

    self.unloadingStationId = self.unloadingStationIds[nextIndex]
end

```

### setPreviousItem

**Description**

**Definition**

> setPreviousItem()

**Code**

```lua
function AIParameterUnloadingStation:setPreviousItem()
    local previousIndex = 0
    for k, unloadingStationId in ipairs( self.unloadingStationIds) do
        if unloadingStationId = = self.unloadingStationId then
            previousIndex = k - 1
        end
    end

    if previousIndex < 1 then
        previousIndex = # self.unloadingStationIds
    end

    self.unloadingStationId = self.unloadingStationIds[previousIndex]
end

```

### setUnloadingStation

**Description**

**Definition**

> setUnloadingStation()

**Arguments**

| any | unloadingStation |
|-----|------------------|

**Code**

```lua
function AIParameterUnloadingStation:setUnloadingStation(unloadingStation)
    self.unloadingStationId = NetworkUtil.getObjectId(unloadingStation)
end

```

### setUnloadingStationFromUniqueId

**Description**

**Definition**

> setUnloadingStationFromUniqueId()

**Arguments**

| any | uniqueId |
|-----|----------|
| any | index    |

**Code**

```lua
function AIParameterUnloadingStation:setUnloadingStationFromUniqueId(uniqueId, index)
    local placeable = g_currentMission.placeableSystem:getPlaceableByUniqueId(uniqueId)
    if placeable ~ = nil then
        local unloadingStation = g_currentMission.storageSystem:getPlaceableUnloadingStation(placeable, index)
        self:setUnloadingStation(unloadingStation)

        return true
    end

    return false
end

```

### setValidUnloadingStations

**Description**

**Definition**

> setValidUnloadingStations()

**Arguments**

| any | unloadingStations |
|-----|-------------------|

**Code**

```lua
function AIParameterUnloadingStation:setValidUnloadingStations(unloadingStations)
    self.unloadingStationIds = { }
    local nextUnloadingStationId

    for _, unloadingStation in ipairs(unloadingStations) do
        local id = NetworkUtil.getObjectId(unloadingStation)
        if id ~ = nil then
            if id = = self.unloadingStationId then
                nextUnloadingStationId = id
            end
            table.insert( self.unloadingStationIds, id)
        end
    end

    self.unloadingStationId = nextUnloadingStationId or self.unloadingStationIds[ 1 ]
end

```

### validate

**Description**

**Definition**

> validate()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|
| any | farmId        |

**Code**

```lua
function AIParameterUnloadingStation:validate(fillTypeIndex, farmId)
    if self.unloadingStationId = = nil then
        return false , g_i18n:getText( "ai_validationErrorNoUnloadingStation" )
    end

    local unloadingStation = self:getUnloadingStation()
    if unloadingStation = = nil then
        return false , g_i18n:getText( "ai_validationErrorUnloadingStationDoesNotExistAnymore" )
    end

    if fillTypeIndex ~ = nil then
        if not unloadingStation:getIsFillTypeAISupported(fillTypeIndex) then
            return false , g_i18n:getText( "ai_validationErrorFillTypeNotSupportedByUnloadingStation" )
        end
        if unloadingStation:getFreeCapacity(fillTypeIndex, farmId) < = 0 then
            return false , g_i18n:getText( "ai_validationErrorUnloadingStationIsFull" )
        end
    end

    return true , nil
end

```

### writeStream

**Description**

**Definition**

> writeStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AIParameterUnloadingStation:writeStream(streamId, connection)
    if streamWriteBool(streamId, self.unloadingStationId ~ = nil ) then
        NetworkUtil.writeNodeObjectId(streamId, self.unloadingStationId)
    end
end

```