## BuyVehicleData

**Description**

> Class to store and sync the data that is required to buy a new vehicle or reconfigure a existing vehicle (set by the
> ShopConfigScreen and use in BuyVehicleEvent and ChangeVehicleConfigEvent)
> The 'buy' function is able to load the vehicle(s) at the given store place

**Functions**

- [buy](#buy)
- [getIsLimitedObjectPurchase](#getislimitedobjectpurchase)
- [isValid](#isvalid)
- [new](#new)
- [readStream](#readstream)
- [setConfigurationData](#setconfigurationdata)
- [setConfigurations](#setconfigurations)
- [setIsFreeOfCharge](#setisfreeofcharge)
- [setLeaseVehicle](#setleasevehicle)
- [setLicensePlateData](#setlicenseplatedata)
- [setOwnerFarmId](#setownerfarmid)
- [setPrice](#setprice)
- [setSaleItem](#setsaleitem)
- [setStoreItem](#setstoreitem)
- [updatePrice](#updateprice)
- [writeStream](#writestream)

### buy

**Description**

> Execute the purchase and load the vehicle(s) at the given store places

**Definition**

> buy(table storePlaces, table usedStorePlaces, function? callback, table? callbackTarget, table? callbackArguments)

**Arguments**

| table     | storePlaces       | storePlaces                                                            |
|-----------|-------------------|------------------------------------------------------------------------|
| table     | usedStorePlaces   | usedStorePlaces                                                        |
| function? | callback          | callback that is called after all vehicles have been loaded (optional) |
| table?    | callbackTarget    | optional callback target                                               |
| table?    | callbackArguments | optional callback arguments                                            |

**Code**

```lua
function BuyVehicleData:buy(storePlaces, usedStorePlaces, callback, callbackTarget, callbackArguments)
    local data = VehicleLoadingData.new()
    data:setStoreItem( self.storeItem)
    data:setConfigurations( self.configurations, self.boughtConfigurations)
    data:setConfigurationData( self.configurationData)
    data:setLoadingPlace(storePlaces, usedStorePlaces)
    data:setPropertyState( self.leaseVehicle and VehiclePropertyState.LEASED or VehiclePropertyState.OWNED)
    data:setOwnerFarmId( self.ownerFarmId)
    data:setSaleItem( self.saleItem)

    data:load( self.onBought, self , { callback = callback, callbackTarget = callbackTarget, callbackArguments = callbackArguments } )
end

```

### getIsLimitedObjectPurchase

**Description**

> Returns if the purchase is for limited objects (pallets or bales)

**Definition**

> getIsLimitedObjectPurchase()

**Return Values**

| table? | isBalePurchase   | is a bale purchase   |
|--------|------------------|----------------------|
| table? | isPalletPurchase | is a pallet purchase |

**Code**

```lua
function BuyVehicleData:getIsLimitedObjectPurchase()
    -- check if buying bales and pallets
        local xmlFile = XMLFile.load( "BuyVehicleDataVehicleXML" , self.storeItem.xmlFilename, nil )
        local isBalePurchase = xmlFile:hasProperty( "vehicle.multipleItemPurchase" ) and xmlFile:getBool( "vehicle.multipleItemPurchase#isVehicle" ) = = false
        local isPalletPurchase = xmlFile:hasProperty( "vehicle.multipleItemPurchase" ) and xmlFile:getBool( "vehicle.multipleItemPurchase#isVehicle" )
        xmlFile:delete()

        return isBalePurchase, isPalletPurchase
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
function BuyVehicleData:isValid()
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

> Creates a new instance of BuyVehicleData

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function BuyVehicleData.new(customMt)
    local self = setmetatable( { } , customMt or BuyVehicleData _mt)

    self.storeItem = nil
    self.isFreeOfCharge = false
    self.configurations = { }
    self.boughtConfigurations = { }
    self.configurationData = { }
    self.leaseVehicle = false
    self.ownerFarmId = AccessHandler.EVERYONE
    self.licensePlateData = nil
    self.saleItem = nil
    self.price = 0

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
function BuyVehicleData:readStream(streamId, connection)
    local xmlFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))
    self.storeItem = g_storeManager:getItemByXMLFilename( string.lower(xmlFilename))

    self.isFreeOfCharge = streamReadBool(streamId)

    self.configurations, self.boughtConfigurations, self.configurationData = ConfigurationUtil.readConfigurationsFromStream(g_vehicleConfigurationManager, streamId, connection, xmlFilename)

    self.leaseVehicle = streamReadBool(streamId)
    self.ownerFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)

    self.licensePlateData = LicensePlateManager.readLicensePlateData(streamId, connection)

    local saleId = streamReadUInt8(streamId)
    if saleId ~ = 0 then
        self.saleItem = g_currentMission.vehicleSaleSystem:getSaleById(saleId)
    end
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
function BuyVehicleData:setConfigurationData(configurationData)
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
function BuyVehicleData:setConfigurations(configurations, boughtConfigurations)
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

### setIsFreeOfCharge

**Description**

> Sets if the vehicle is free of charge (e.g. achievement)

**Definition**

> setIsFreeOfCharge(boolean isFreeOfCharge)

**Arguments**

| boolean | isFreeOfCharge | isFreeOfCharge |
|---------|----------------|----------------|

**Code**

```lua
function BuyVehicleData:setIsFreeOfCharge(isFreeOfCharge)
    self.isFreeOfCharge = isFreeOfCharge
end

```

### setLeaseVehicle

**Description**

> Sets if the vehicle is leased or bough

**Definition**

> setLeaseVehicle(boolean leaseVehicle)

**Arguments**

| boolean | leaseVehicle | leaseVehicle |
|---------|--------------|--------------|

**Code**

```lua
function BuyVehicleData:setLeaseVehicle(leaseVehicle)
    self.leaseVehicle = leaseVehicle
end

```

### setLicensePlateData

**Description**

> Sets the license plate data

**Definition**

> setLicensePlateData(table licensePlateData)

**Arguments**

| table | licensePlateData | licensePlateData |
|-------|------------------|------------------|

**Code**

```lua
function BuyVehicleData:setLicensePlateData(licensePlateData)
    self.licensePlateData = licensePlateData
end

```

### setOwnerFarmId

**Description**

> Sets the owner of the vehicle

**Definition**

> setOwnerFarmId(integer ownerFarmId)

**Arguments**

| integer | ownerFarmId | ownerFarmId |
|---------|-------------|-------------|

**Code**

```lua
function BuyVehicleData:setOwnerFarmId(ownerFarmId)
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
function BuyVehicleData:setPrice(price)
    self.price = price
end

```

### setSaleItem

**Description**

> Sets the corresponding saleItem if the vehicle is bought from the sales

**Definition**

> setSaleItem(table saleItem)

**Arguments**

| table | saleItem | saleItem |
|-------|----------|----------|

**Code**

```lua
function BuyVehicleData:setSaleItem(saleItem)
    self.saleItem = saleItem
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
function BuyVehicleData:setStoreItem(storeItem)
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
function BuyVehicleData:updatePrice()
    self.price = g_currentMission.economyManager:getBuyPrice( self.storeItem, self.configurations, self.saleItem)

    if self.leaseVehicle then
        self.price = g_currentMission.economyManager:getInitialLeasingPrice( self.price)
    end
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
function BuyVehicleData:writeStream(streamId, connection)
    streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.storeItem.xmlFilename))

    streamWriteBool(streamId, self.isFreeOfCharge)

    ConfigurationUtil.writeConfigurationsToStream(g_vehicleConfigurationManager, streamId, connection, self.storeItem.xmlFilename, self.configurations, self.boughtConfigurations, self.configurationData)

    streamWriteBool(streamId, self.leaseVehicle)
    streamWriteUIntN(streamId, self.ownerFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)

    LicensePlateManager.writeLicensePlateData(streamId, connection, self.licensePlateData)

    if self.saleItem ~ = nil then
        streamWriteUInt8(streamId, self.saleItem.id)
    else
            streamWriteUInt8(streamId, 0 )
        end
    end

```