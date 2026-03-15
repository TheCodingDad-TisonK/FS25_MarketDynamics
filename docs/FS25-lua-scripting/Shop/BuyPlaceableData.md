## BuyPlaceableData

**Description**

> Class to store and sync the data that is required to buy a new placeable (set by the ConstructionScreen and use in
> BuyPlacdeableEvent)
> The 'buy' function is able to load the placeable at the given place

**Functions**

- [buy](#buy)
- [isValid](#isvalid)
- [new](#new)
- [readStream](#readstream)
- [setConfigurationData](#setconfigurationdata)
- [setConfigurations](#setconfigurations)
- [setDisplacementCosts](#setdisplacementcosts)
- [setIsFreeOfCharge](#setisfreeofcharge)
- [setModifyTerrain](#setmodifyterrain)
- [setOwnerFarmId](#setownerfarmid)
- [setPrice](#setprice)
- [setRealignToTerrainAfterLeveling](#setrealigntoterrainafterleveling)
- [setStoreItem](#setstoreitem)
- [updatePrice](#updateprice)
- [writeStream](#writestream)

### buy

**Description**

> Execute the purchase and load the placeable at the given places

**Definition**

> buy(function? callback, table? callbackTarget, table? callbackArguments)

**Arguments**

| function? | callback          | callback that is called after all vehicles have been loaded (optional) |
|-----------|-------------------|------------------------------------------------------------------------|
| table?    | callbackTarget    | optional callback target                                               |
| table?    | callbackArguments | optional callback arguments                                            |

**Code**

```lua
function BuyPlaceableData:buy(callback, callbackTarget, callbackArguments)
    local data = PlaceableLoadingData.new()
    data:setStoreItem( self.storeItem)
    data:setConfigurations( self.configurations, self.boughtConfigurations)
    data:setConfigurationData( self.configurationData)
    data:setOwnerFarmId( self.ownerFarmId)
    data:setPosition( self.position[ 1 ], self.position[ 2 ], self.position[ 3 ])
    data:setRotation( self.rotation[ 1 ], self.rotation[ 2 ], self.rotation[ 3 ])
    data:load( self.onLoaded, self , { callback = callback, callbackTarget = callbackTarget, callbackArguments = callbackArguments } )
end

```

### isValid

**Description**

> Returns if all required data is set and the vehicle can be bought

**Definition**

> isValid()

**Return Values**

| table? | isValid | is valid |
|--------|---------|----------|

**Code**

```lua
function BuyPlaceableData:isValid()
    if self.storeItem = = nil then
        return false
    end

    if GS_IS_CONSOLE_VERSION and not fileExists( self.storeItem.xmlFilename) then
        return false
    end

    return true
end

```

### new

**Description**

> Creates a new instance of BuyPlaceableData

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self | BuyPlaceableData instance |
|--------|------|---------------------------|

**Code**

```lua
function BuyPlaceableData.new(customMt)
    local self = setmetatable( { } , customMt or BuyPlaceableData _mt)

    self.storeItem = nil
    self.isFreeOfCharge = false
    self.configurations = { }
    self.boughtConfigurations = { }
    self.configurationData = { }
    self.ownerFarmId = AccessHandler.EVERYONE
    self.price = 0
    self.displacementCosts = 0
    self.modifyTerrain = false
    self.realignToTerrain = true
    self.position = { 0 , 0 , 0 }
    self.rotation = { 0 , 0 , 0 }

    return self
end

```

### readStream

**Description**

> Read data from stream

**Definition**

> readStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | streamId   |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function BuyPlaceableData:readStream(streamId, connection)
    local xmlFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))
    self.storeItem = g_storeManager:getItemByXMLFilename( string.lower(xmlFilename))

    self.position[ 1 ] = streamReadFloat32(streamId)
    self.position[ 2 ] = streamReadFloat32(streamId)
    self.position[ 3 ] = streamReadFloat32(streamId)
    self.rotation[ 1 ] = streamReadFloat32(streamId)
    self.rotation[ 2 ] = streamReadFloat32(streamId)
    self.rotation[ 3 ] = streamReadFloat32(streamId)

    self.configurations, self.boughtConfigurations, self.configurationData = ConfigurationUtil.readConfigurationsFromStream(g_placeableConfigurationManager, streamId, connection, xmlFilename)

    self.ownerFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
    self.isFreeOfCharge = streamReadBool(streamId)
    self.displacementCosts = streamReadInt32(streamId)
    self.modifyTerrain = streamReadBool(streamId)
end

```

### setConfigurationData

**Description**

> Sets the configuration data

**Definition**

> setConfigurationData(table configurationData)

**Arguments**

| table | configurationData | configurationData |
|-------|-------------------|-------------------|

**Code**

```lua
function BuyPlaceableData:setConfigurationData(configurationData)
    self.configurationData = configurationData or self.configurationData
end

```

### setConfigurations

**Description**

> Sets the configurations

**Definition**

> setConfigurations(table configurations, table boughtConfigurations)

**Arguments**

| table | configurations       | configurations       |
|-------|----------------------|----------------------|
| table | boughtConfigurations | boughtConfigurations |

**Code**

```lua
function BuyPlaceableData:setConfigurations(configurations, boughtConfigurations)
    self.configurations = configurations or self.configurations
    self.boughtConfigurations = boughtConfigurations or self.boughtConfigurations

    for configName, index in pairs( self.configurations) do
        if self.boughtConfigurations[configName] = = nil then
            self.boughtConfigurations[configName] = { }
        end

        self.boughtConfigurations[configName][index] = true
    end
end

```

### setDisplacementCosts

**Description**

> Sets the displacement costs

**Definition**

> setDisplacementCosts(integer displacementCosts)

**Arguments**

| integer | displacementCosts |
|---------|-------------------|

**Code**

```lua
function BuyPlaceableData:setDisplacementCosts(displacementCosts)
    self.displacementCosts = displacementCosts
end

```

### setIsFreeOfCharge

**Description**

> Sets if the palceable is free of charge (e.g. achievement)

**Definition**

> setIsFreeOfCharge(boolean isFreeOfCharge)

**Arguments**

| boolean | isFreeOfCharge | isFreeOfCharge |
|---------|----------------|----------------|

**Code**

```lua
function BuyPlaceableData:setIsFreeOfCharge(isFreeOfCharge)
    self.isFreeOfCharge = isFreeOfCharge
end

```

### setModifyTerrain

**Description**

> Sets if terrain is modified

**Definition**

> setModifyTerrain(boolean modifyTerrain)

**Arguments**

| boolean | modifyTerrain | modifyTerrain |
|---------|---------------|---------------|

**Code**

```lua
function BuyPlaceableData:setModifyTerrain(modifyTerrain)
    self.modifyTerrain = modifyTerrain
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
function BuyPlaceableData:setOwnerFarmId(ownerFarmId)
    self.ownerFarmId = ownerFarmId
end

```

### setPrice

**Description**

> Sets a custom price for the purchase

**Definition**

> setPrice(integer price)

**Arguments**

| integer | price | price |
|---------|-------|-------|

**Code**

```lua
function BuyPlaceableData:setPrice(price)
    self.price = price
end

```

### setRealignToTerrainAfterLeveling

**Description**

> Sets if placeable is realigned to terrain after leveling. Default: true

**Definition**

> setRealignToTerrainAfterLeveling(boolean realignToTerrain)

**Arguments**

| boolean | realignToTerrain | realignToTerrain |
|---------|------------------|------------------|

**Code**

```lua
function BuyPlaceableData:setRealignToTerrainAfterLeveling(realignToTerrain)
    self.realignToTerrain = realignToTerrain
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
function BuyPlaceableData:setStoreItem(storeItem)
    self.storeItem = storeItem
end

```

### updatePrice

**Description**

> Updates to price depending on the store item + configurations

**Definition**

> updatePrice()

**Code**

```lua
function BuyPlaceableData:updatePrice()
    self.price = g_currentMission.economyManager:getBuyPrice( self.storeItem, self.configurations, nil )
end

```

### writeStream

**Description**

> Write data to stream

**Definition**

> writeStream(integer streamId, table connection)

**Arguments**

| integer | streamId   | streamId   |
|---------|------------|------------|
| table   | connection | connection |

**Code**

```lua
function BuyPlaceableData:writeStream(streamId, connection)
    streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.storeItem.xmlFilename))

    streamWriteFloat32(streamId, self.position[ 1 ])
    streamWriteFloat32(streamId, self.position[ 2 ])
    streamWriteFloat32(streamId, self.position[ 3 ])
    streamWriteFloat32(streamId, self.rotation[ 1 ])
    streamWriteFloat32(streamId, self.rotation[ 2 ])
    streamWriteFloat32(streamId, self.rotation[ 3 ])

    ConfigurationUtil.writeConfigurationsToStream(g_placeableConfigurationManager, streamId, connection, self.storeItem.xmlFilename, self.configurations, self.boughtConfigurations, self.configurationData)

    streamWriteUIntN(streamId, self.ownerFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)
    streamWriteBool(streamId, self.isFreeOfCharge)
    streamWriteInt32(streamId, self.displacementCosts)
    streamWriteBool(streamId, self.modifyTerrain)
end

```