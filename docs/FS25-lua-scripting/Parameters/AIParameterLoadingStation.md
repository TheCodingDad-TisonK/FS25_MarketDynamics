## AIParameterLoadingStation

**Parent**

> [AIParameter](?version=script&category=65&class=590)

**Functions**

- [getLoadingStation](#getloadingstation)
- [getString](#getstring)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [onPlaceableLoaded](#onplaceableloaded)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setLoadingStation](#setloadingstation)
- [setLoadingStationFromUniqueId](#setloadingstationfromuniqueid)
- [setNextItem](#setnextitem)
- [setPreviousItem](#setpreviousitem)
- [setValidLoadingStations](#setvalidloadingstations)
- [validate](#validate)
- [writeStream](#writestream)

### getLoadingStation

**Description**

**Definition**

> getLoadingStation()

**Code**

```lua
function AIParameterLoadingStation:getLoadingStation()
    local loadingStation = NetworkUtil.getObject( self.loadingStationId)
    if loadingStation ~ = nil and loadingStation.owningPlaceable ~ = nil and loadingStation.owningPlaceable:getIsSynchronized() then
        return loadingStation
    end

    return nil
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterLoadingStation:getString()
    local loadingStation = NetworkUtil.getObject( self.loadingStationId)
    if loadingStation ~ = nil then
        return loadingStation:getName()
    end

    return ""
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
function AIParameterLoadingStation:loadFromXMLFile(xmlFile, key)
    local loadingStationUniqueId = xmlFile:getString(key .. "#stationUniqueId" )
    local stationIndex = xmlFile:getInt(key .. "#stationIndex" )

    if loadingStationUniqueId ~ = nil and stationIndex ~ = nil then
        if not self:setLoadingStationFromUniqueId(loadingStationUniqueId, stationIndex) then
            g_messageCenter:subscribeOneshot(MessageType.LOADED_ALL_SAVEGAME_PLACEABLES, self.onPlaceableLoaded, self , { loadingStationUniqueId, stationIndex } )
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
function AIParameterLoadingStation.new(customMt)
    local self = AIParameter.new(customMt or AIParameterLoadingStation _mt)

    self.type = AIParameterType.LOADING_STATION

    self.loadingStationId = nil
    self.loadingStationIds = { }

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
function AIParameterLoadingStation:onPlaceableLoaded(args)
    self:setLoadingStationFromUniqueId(args[ 1 ], args[ 2 ])
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
function AIParameterLoadingStation:readStream(streamId, connection)
    if streamReadBool(streamId) then
        self.loadingStationId = NetworkUtil.readNodeObjectId(streamId)
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
function AIParameterLoadingStation:saveToXMLFile(xmlFile, key, usedModNames)
    local loadingStation = self:getLoadingStation()
    if loadingStation ~ = nil then
        local owningPlaceable = loadingStation.owningPlaceable
        if owningPlaceable ~ = nil then
            local uniqueId = owningPlaceable:getUniqueId()
            if uniqueId ~ = nil then
                local index = g_currentMission.storageSystem:getPlaceableLoadingStationIndex(owningPlaceable, loadingStation)
                if index ~ = nil then
                    xmlFile:setString(key .. "#stationUniqueId" , uniqueId)
                    xmlFile:setInt(key .. "#stationIndex" , index)
                end
            end
        end
    end
end

```

### setLoadingStation

**Description**

**Definition**

> setLoadingStation()

**Arguments**

| any | loadingStation |
|-----|----------------|

**Code**

```lua
function AIParameterLoadingStation:setLoadingStation(loadingStation)
    self.loadingStationId = NetworkUtil.getObjectId(loadingStation)
end

```

### setLoadingStationFromUniqueId

**Description**

**Definition**

> setLoadingStationFromUniqueId()

**Arguments**

| any | uniqueId |
|-----|----------|
| any | index    |

**Code**

```lua
function AIParameterLoadingStation:setLoadingStationFromUniqueId(uniqueId, index)
    local placeable = g_currentMission.placeableSystem:getPlaceableByUniqueId(uniqueId)
    if placeable ~ = nil then
        local loadingStation = g_currentMission.storageSystem:getPlaceableLoadingStation(placeable, index)
        self:setLoadingStation(loadingStation)

        return true
    end

    return false
end

```

### setNextItem

**Description**

**Definition**

> setNextItem()

**Code**

```lua
function AIParameterLoadingStation:setNextItem()
    local nextIndex = 0
    for k, loadingStationId in ipairs( self.loadingStationIds) do
        if loadingStationId = = self.loadingStationId then
            nextIndex = k + 1
        end
    end

    if nextIndex > # self.loadingStationIds then
        nextIndex = 1
    end

    self.loadingStationId = self.loadingStationIds[nextIndex]
end

```

### setPreviousItem

**Description**

**Definition**

> setPreviousItem()

**Code**

```lua
function AIParameterLoadingStation:setPreviousItem()
    local previousIndex = 0
    for k, loadingStationId in ipairs( self.loadingStationIds) do
        if loadingStationId = = self.loadingStationId then
            previousIndex = k - 1
        end
    end

    if previousIndex < 1 then
        previousIndex = # self.loadingStationIds
    end

    self.loadingStationId = self.loadingStationIds[previousIndex]
end

```

### setValidLoadingStations

**Description**

**Definition**

> setValidLoadingStations()

**Arguments**

| any | loadingStationIds |
|-----|-------------------|

**Code**

```lua
function AIParameterLoadingStation:setValidLoadingStations(loadingStationIds)
    self.loadingStationIds = { }
    local nextLoadingStationId

    for _, loadingStation in ipairs(loadingStationIds) do
        local id = NetworkUtil.getObjectId(loadingStation)
        if id ~ = nil then
            if id = = self.loadingStationId then
                nextLoadingStationId = id
            end
            table.insert( self.loadingStationIds, id)
        end
    end

    self.loadingStationId = nextLoadingStationId or self.loadingStationIds[ 1 ]
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
function AIParameterLoadingStation:validate(fillTypeIndex, farmId)
    if self.loadingStationId = = nil then
        return false , g_i18n:getText( "ai_validationErrorNoLoadingStation" )
    end

    local loadingStation = self:getLoadingStation()
    if loadingStation = = nil then
        return false , g_i18n:getText( "ai_validationErrorLoadingStationDoesNotExistAnymore" )
    end

    if fillTypeIndex ~ = nil then
        if not loadingStation:getIsFillTypeAISupported(fillTypeIndex) then
            return false , g_i18n:getText( "ai_validationErrorFillTypeNotSupportedByLoadingStation" )
        elseif loadingStation:getFillLevel(fillTypeIndex, farmId) < = 0 then
                return false , g_i18n:getText( "ai_validationErrorLoadingStationIsEmpty" )
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
function AIParameterLoadingStation:writeStream(streamId, connection)
    if streamWriteBool(streamId, self.loadingStationId ~ = nil ) then
        NetworkUtil.writeNodeObjectId(streamId, self.loadingStationId)
    end
end

```