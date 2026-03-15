## FarmlandStatisticsResetEvent

**Description**

> Event for syncing the farmland stats to the player

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
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
function FarmlandStatisticsResetEvent.emptyNew()
    local self = Event.new( FarmlandStatisticsResetEvent _mt)
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
function FarmlandStatisticsResetEvent.new(farmlandId)
    local self = FarmlandStatisticsResetEvent.emptyNew()
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
function FarmlandStatisticsResetEvent:readStream(streamId, connection)
    self.farmlandId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)

    local pfModule = g_precisionFarming
    if pfModule ~ = nil then
        if pfModule.farmlandStatistics ~ = nil then
            pfModule.farmlandStatistics:resetStatistic( self.farmlandId)
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
function FarmlandStatisticsResetEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmlandId, g_farmlandManager.numberOfBits)
end

```