## BuyHandToolData

**Description**

> Class to store and sync the data that is required to buy a new handtool

**Functions**

- [buy](#buy)
- [isValid](#isvalid)
- [new](#new)
- [readStream](#readstream)
- [setIsFreeOfCharge](#setisfreeofcharge)
- [setOwnerFarmId](#setownerfarmid)
- [setPrice](#setprice)
- [setStoreItem](#setstoreitem)
- [updatePrice](#updateprice)
- [writeStream](#writestream)

### buy

**Description**

> Execute the purchase and load the handtool

**Definition**

> buy(function? callback, table? callbackTarget, table? callbackArguments)

**Arguments**

| function? | callback          | callback that is called after all vehicles have been loaded (optional) |
|-----------|-------------------|------------------------------------------------------------------------|
| table?    | callbackTarget    | optional callback target                                               |
| table?    | callbackArguments | optional callback arguments                                            |

**Code**

```lua
function BuyHandToolData:buy(callback, callbackTarget, callbackArguments)
    local data = HandToolLoadingData.new()
    data:setStoreItem( self.storeItem)
    data:setOwnerFarmId( self.ownerFarmId)
    data:setHolder( self.holder)
    data:load( self.onBought, self , { callback = callback, callbackTarget = callbackTarget, callbackArguments = callbackArguments } )
end

```

### isValid

**Description**

> Returns if all required data is set and the handtool can be bought

**Definition**

> isValid()

**Return Values**

| table? | isValid | is valid |
|--------|---------|----------|

**Code**

```lua
function BuyHandToolData:isValid()
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

> Creates a new instance of BuyHandToolData

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | BuyHandToolData | BuyHandToolData instance |
|-----|-----------------|--------------------------|

**Code**

```lua
function BuyHandToolData.new(customMt)
    local self = setmetatable( { } , customMt or BuyHandToolData _mt)

    self.storeItem = nil
    self.isFreeOfCharge = false
    self.ownerFarmId = AccessHandler.EVERYONE
    self.price = 0
    self.holder = nil

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
function BuyHandToolData:readStream(streamId, connection)
    local xmlFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))
    self.storeItem = g_storeManager:getItemByXMLFilename( string.lower(xmlFilename))
    self.isFreeOfCharge = streamReadBool(streamId)
    self.ownerFarmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
end

```

### setIsFreeOfCharge

**Description**

> Sets if the handtool is free of charge (e.g. achievement)

**Definition**

> setIsFreeOfCharge(boolean isFreeOfCharge)

**Arguments**

| boolean | isFreeOfCharge | isFreeOfCharge |
|---------|----------------|----------------|

**Code**

```lua
function BuyHandToolData:setIsFreeOfCharge(isFreeOfCharge)
    self.isFreeOfCharge = isFreeOfCharge
end

```

### setOwnerFarmId

**Description**

> Sets the owner of the handtool

**Definition**

> setOwnerFarmId(integer ownerFarmId)

**Arguments**

| integer | ownerFarmId | ownerFarmId |
|---------|-------------|-------------|

**Code**

```lua
function BuyHandToolData:setOwnerFarmId(ownerFarmId)
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
function BuyHandToolData:setPrice(price)
    self.price = price
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
function BuyHandToolData:setStoreItem(storeItem)
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
function BuyHandToolData:updatePrice()
    self.price = g_currentMission.economyManager:getBuyPrice( self.storeItem)
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
function BuyHandToolData:writeStream(streamId, connection)
    streamWriteString(streamId, NetworkUtil.convertToNetworkFilename( self.storeItem.xmlFilename))
    streamWriteBool(streamId, self.isFreeOfCharge)
    streamWriteUIntN(streamId, self.ownerFarmId, FarmManager.FARM_ID_SEND_NUM_BITS)
end

```