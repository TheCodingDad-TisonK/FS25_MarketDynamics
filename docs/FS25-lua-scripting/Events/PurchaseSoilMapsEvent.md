## PurchaseSoilMapsEvent

**Description**

> Event to sync soil map purchase to the server

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [writeStream](#writestream)

### emptyNew

**Description**

> Create instance of Event class

**Definition**

> emptyNew()

**Return Values**

| any | self | instance of class event |
|-----|------|-------------------------|

**Code**

```lua
function PurchaseSoilMapsEvent.emptyNew()
    local self = Event.new( PurchaseSoilMapsEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Code**

```lua
function PurchaseSoilMapsEvent.new(farmlandId)
    local self = PurchaseSoilMapsEvent.emptyNew()
    self.farmlandId = farmlandId
    return self
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function PurchaseSoilMapsEvent:readStream(streamId, connection)
    self.farmlandId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
    self:run(connection)
end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run(Connection connection)

**Arguments**

| Connection | connection | connection |
|------------|------------|------------|

**Code**

```lua
function PurchaseSoilMapsEvent:run(connection)
    if not connection:getIsServer() then
        if g_precisionFarming ~ = nil then
            if g_precisionFarming.soilMap ~ = nil then
                g_precisionFarming.soilMap:purchaseSoilMaps( self.farmlandId)
                g_precisionFarming:updatePrecisionFarmingOverlays()
            end
        end
    end
end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function PurchaseSoilMapsEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmlandId, g_farmlandManager.numberOfBits)
end

```