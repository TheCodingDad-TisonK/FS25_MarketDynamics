## PlaceableLoadingData

**Description**

> Stores all data that is required to load a Placeable

**Functions**

- [applyPositionData](#applypositiondata)
- [getConfigurations](#getconfigurations)
- [getCustomParameter](#getcustomparameter)
- [load](#load)
- [new](#new)
- [setBoughtConfigurations](#setboughtconfigurations)
- [setConfigurationData](#setconfigurationdata)
- [setConfigurations](#setconfigurations)
- [setCustomParameter](#setcustomparameter)
- [setFilename](#setfilename)
- [setForceServer](#setforceserver)
- [setIsRegistered](#setisregistered)
- [setIsSaved](#setissaved)
- [setOwnerFarmId](#setownerfarmid)
- [setPosition](#setposition)
- [setPropertyState](#setpropertystate)
- [setRotation](#setrotation)
- [setSavegameData](#setsavegamedata)
- [setSpawnNode](#setspawnnode)
- [setStoreItem](#setstoreitem)

### applyPositionData

**Description**

> Apply the position data to a given placeable

**Definition**

> applyPositionData(table placeable)

**Arguments**

| table | placeable | placeable |
|-------|-----------|-----------|

**Return Values**

| table | success | position data was successfully applied (otherwise the placeable was not correctly spawned and should be removed) |
|-------|---------|------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlaceableLoadingData:applyPositionData(placeable)
    if not self.validLocation then
        return false
    end

    if self.preplacedIndex ~ = nil then
        return true
    end

    if self.savegameData ~ = nil then
        local savegame = self.savegameData
        local x, y, z = savegame.xmlFile:getValue(savegame.key .. "#position" )
        local xRot, yRot, zRot = savegame.xmlFile:getValue(savegame.key .. "#rotation" )

        if x = = nil or y = = nil or z = = nil or xRot = = nil or yRot = = nil or zRot = = nil then
            Logging.xmlWarning(savegame.xmlFile, "Invalid position in '%s' (%s)!" , savegame.key, placeable.configFileName)
            return false
        end

        placeable:setPose(x, y, z, xRot, yRot, zRot)

        return true
    end

    placeable:setPose( self.position[ 1 ], self.position[ 2 ], self.position[ 3 ], self.rotation[ 1 ], self.rotation[ 2 ], self.rotation[ 3 ])

    return true
end

```

### getConfigurations

**Description**

> Returns a cloned table of the configurations for the given configFileName

**Definition**

> getConfigurations(string configFileName)

**Arguments**

| string | configFileName | path to xml file |
|--------|----------------|------------------|

**Return Values**

| string | configurations       | configurations       |
|--------|----------------------|----------------------|
| string | boughtConfigurations | boughtConfigurations |

**Code**

```lua
function PlaceableLoadingData:getConfigurations(configFileName)
    local configurations = table.clone( self.configurations, math.huge)
    local boughtConfigurations = table.clone( self.boughtConfigurations, math.huge)
    local configurationData = table.clone( self.configurationData, math.huge)

    local storeItem = g_storeManager:getItemByXMLFilename(configFileName)
    if storeItem ~ = nil and storeItem.configurations ~ = nil then
        for configName, configId in pairs(configurations) do
            if storeItem.configurations[configName] = = nil then
                configurations[configName] = nil
                boughtConfigurations[configName] = nil
            end
        end
    end

    if self.storeItem.configurations ~ = nil then
        for configName, configItems in pairs( self.storeItem.configurations) do
            local configIndex = configurations[configName]
            if configIndex = = nil then
                configurations[configName] = ConfigurationUtil.getDefaultConfigIdFromItems(configItems)
            end
        end
    end

    return configurations, boughtConfigurations, configurationData
end

```

### getCustomParameter

**Description**

> Returns custom parameter value by given name

**Definition**

> getCustomParameter(string name)

**Arguments**

| string | name | name of parameter |
|--------|------|-------------------|

**Return Values**

| string | value | parameter value |
|--------|-------|-----------------|

**Code**

```lua
function PlaceableLoadingData:getCustomParameter(name)
    return self.customParameters[name]
end

```

### load

**Description**

> Loads placeable from the set storeItem and calls the optional callback

**Definition**

> load(function? callback, table? callbackTarget, table? callbackArguments)

**Arguments**

| function? | callback          | callback to be called when all vehicles have been loaded |
|-----------|-------------------|----------------------------------------------------------|
| table?    | callbackTarget    | callback target                                          |
| table?    | callbackArguments | callback arguments                                       |

**Code**

```lua
function PlaceableLoadingData:load(callback, callbackTarget, callbackArguments)
    g_currentMission.placeableSystem:addPendingPlaceableLoad( self )

    self.callback, self.callbackTarget, self.callbackArguments = callback, callbackTarget, callbackArguments

    self.loadingState = PlaceableLoadingState.OK
    self:loadPlaceable( self.placeable)
end

```

### new

**Description**

> Creates a new instance of PlaceableLoadingData

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | PlaceableLoadingData | PlaceableLoadingData instance |
|-----|----------------------|-------------------------------|

**Code**

```lua
function PlaceableLoadingData.new(customMt)
    local self = setmetatable( { } , customMt or PlaceableLoadingData _mt)

    self.storeItem = nil
    self.validLocation = true

    self.placeable = nil
    self.isValid = false
    self.propertyState = PlaceablePropertyState.OWNED
    self.ownerFarmId = AccessHandler.EVERYONE

    self.forceServer = false
    self.isSaved = true

    self.uniqueId = nil
    self.loadingState = nil
    self.savegameData = nil
    self.configurations = { }
    self.boughtConfigurations = { }
    self.configurationData = { }

    self.isRegistered = true

    self.preplacedIndex = nil

    self.price = nil

    self.position = { 0 , 0 , 0 }
    self.rotation = { 0 , 0 , 0 }

    self.customParameters = { }

    return self
end

```

### setBoughtConfigurations

**Description**

> Sets the bought configurations for the placeable

**Definition**

> setBoughtConfigurations(table boughtConfigurations)

**Arguments**

| table | boughtConfigurations | boughtConfigurations |
|-------|----------------------|----------------------|

**Code**

```lua
function PlaceableLoadingData:setBoughtConfigurations(boughtConfigurations)
    if boughtConfigurations ~ = nil then
        self.boughtConfigurations = boughtConfigurations
    else
            self.boughtConfigurations = { }
        end
    end

```

### setConfigurationData

**Description**

> Sets the configuration data

**Definition**

> setConfigurationData(table boughtConfigurations)

**Arguments**

| table | boughtConfigurations | boughtConfigurations |
|-------|----------------------|----------------------|

**Code**

```lua
function PlaceableLoadingData:setConfigurationData(configurationData)
    if configurationData ~ = nil then
        self.configurationData = configurationData
    else
            self.configurationData = { }
        end
    end

```

### setConfigurations

**Description**

> Sets the configurations for the placeable

**Definition**

> setConfigurations(table configurations)

**Arguments**

| table | configurations | configurations |
|-------|----------------|----------------|

**Code**

```lua
function PlaceableLoadingData:setConfigurations(configurations)
    if configurations ~ = nil then
        self.configurations = configurations
    else
            self.configurations = { }
        end
    end

```

### setCustomParameter

**Description**

> Set custom parameter which is available inside the placeable

**Definition**

> setCustomParameter(string name, any value)

**Arguments**

| string | name  | name of parameter |
|--------|-------|-------------------|
| any    | value | parameter value   |

**Code**

```lua
function PlaceableLoadingData:setCustomParameter(name, value)
    self.customParameters[name] = value
end

```

### setFilename

**Description**

> Sets the store data by given xml filename

**Definition**

> setFilename(string filename)

**Arguments**

| string | filename | filename |
|--------|----------|----------|

**Code**

```lua
function PlaceableLoadingData:setFilename(filename)
    local storeItem = g_storeManager:getItemByXMLFilename(filename)
    if storeItem ~ = nil then
        self:setStoreItem(storeItem)
    else
            Logging.error( "Unable to find placeable storeitem for '%s'" , filename)
                printCallstack()
            end
        end

```

### setForceServer

**Description**

> Sets if the placeable is created as server placeable also on client side (With dynamic physics etc.)

**Definition**

> setForceServer(boolean forceServer)

**Arguments**

| boolean | forceServer | forceServer |
|---------|-------------|-------------|

**Code**

```lua
function PlaceableLoadingData:setForceServer(forceServer)
    self.forceServer = forceServer
end

```

### setIsRegistered

**Description**

> Sets if the placeable is registered after loading

**Definition**

> setIsRegistered(boolean isRegistered)

**Arguments**

| boolean | isRegistered | isRegistered |
|---------|--------------|--------------|

**Code**

```lua
function PlaceableLoadingData:setIsRegistered(isRegistered)
    self.isRegistered = isRegistered
end

```

### setIsSaved

**Description**

> Sets if the placeable is saved

**Definition**

> setIsSaved(boolean isSaved)

**Arguments**

| boolean | isSaved | isSaved |
|---------|---------|---------|

**Code**

```lua
function PlaceableLoadingData:setIsSaved(isSaved)
    self.isSaved = isSaved
end

```

### setOwnerFarmId

**Description**

> Sets the owner of the placeable

**Definition**

> setOwnerFarmId(integer ownerFarmId)

**Arguments**

| integer | ownerFarmId | ownerFarmId |
|---------|-------------|-------------|

**Code**

```lua
function PlaceableLoadingData:setOwnerFarmId(ownerFarmId)
    self.ownerFarmId = ownerFarmId
end

```

### setPosition

**Description**

> Set spawn translation (World space)

**Definition**

> setPosition(float x, float y, float z)

**Arguments**

| float | x | x translation                                           |
|-------|---|---------------------------------------------------------|
| float | y | y translation (if nil, the terrain height will be used) |
| float | z | z translation                                           |

**Code**

```lua
function PlaceableLoadingData:setPosition(x, y, z)
    if y = = nil then
        y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z)
    end

    self.position[ 1 ], self.position[ 2 ], self.position[ 3 ] = x, y, z
end

```

### setPropertyState

**Description**

> Sets the property state of the placeable

**Definition**

> setPropertyState(integer propertyState)

**Arguments**

| integer | propertyState | propertyState |
|---------|---------------|---------------|

**Code**

```lua
function PlaceableLoadingData:setPropertyState(propertyState)
    self.propertyState = propertyState
end

```

### setRotation

**Description**

> Set spawn rotation (World space)

**Definition**

> setRotation(float rx, float ry, float rz)

**Arguments**

| float | rx | x rotation |
|-------|----|------------|
| float | ry | y rotation |
| float | rz | z rotation |

**Code**

```lua
function PlaceableLoadingData:setRotation(rx, ry, rz)
    self.rotation[ 1 ], self.rotation[ 2 ], self.rotation[ 3 ] = rx, ry, rz
end

```

### setSavegameData

**Description**

> Sets the savegame data for a placeable if it's loaded from a savegame

**Definition**

> setSavegameData(table savegameData)

**Arguments**

| table | savegameData | savegameData (table with the following attributes: xmlFile, key, ignoreFarmId) |
|-------|--------------|--------------------------------------------------------------------------------|

**Code**

```lua
function PlaceableLoadingData:setSavegameData(savegameData)
    self.savegameData = savegameData

    if self.storeItem ~ = nil then
        -- load savegame configurations
        if savegameData ~ = nil and savegameData.xmlFile ~ = nil then
            self.configurations, self.boughtConfigurations, self.configurationData = ConfigurationUtil.loadConfigurationsFromXMLFile( self.storeItem.xmlFilename, savegameData.xmlFile, savegameData.key .. ".configuration" )

            -- savegame backward compatibility
            for _, key in savegameData.xmlFile:iterator(savegameData.key .. ".boughtConfiguration" ) do
                local name = savegameData.xmlFile:getValue(key .. "#name" )
                local id = savegameData.xmlFile:getValue(key .. "#id" )
                if name ~ = nil and id ~ = nil then
                    if self.boughtConfigurations[name] = = nil then
                        self.boughtConfigurations[name] = { }
                    end

                    local configIndex = ConfigurationUtil.getConfigIdBySaveId( self.storeItem.xmlFilename, name, id)
                    if configIndex ~ = nil then
                        self.boughtConfigurations[name][configIndex] = true
                    end
                else
                        Logging.xmlWarning(savegameData.xmlFile, "Invalid bought configuration in '%s'!" , savegameData.key)
                    end
                end
            end
        end
    end

```

### setSpawnNode

**Description**

> Set the spawn translation and rotation based on the given node's position

**Definition**

> setSpawnNode(entityId node)

**Arguments**

| entityId | node | node id |
|----------|------|---------|

**Code**

```lua
function PlaceableLoadingData:setSpawnNode(node)
    self.position[ 1 ], self.position[ 2 ], self.position[ 3 ] = getWorldTranslation(node)
    self.rotation[ 1 ], self.rotation[ 2 ], self.rotation[ 3 ] = getWorldRotation(node)
end

```

### setStoreItem

**Description**

> Sets the store item

**Definition**

> setStoreItem(table storeItem)

**Arguments**

| table | storeItem | storeItem |
|-------|-----------|-----------|

**Code**

```lua
function PlaceableLoadingData:setStoreItem(storeItem)
    if storeItem ~ = nil then
        self.storeItem = storeItem

        self.rotation[ 2 ] = storeItem.rotation

        self.placeable = { xmlFilename = storeItem.xmlFilename }
    end

    self.isValid = self.placeable ~ = nil
end

```