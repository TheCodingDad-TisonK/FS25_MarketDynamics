## EnvironmentalScoreEvent

**Description**

> Event for syncing the environmental score to the player

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
function EnvironmentalScoreEvent.emptyNew()
    local self = Event.new( EnvironmentalScoreEvent _mt)
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
function EnvironmentalScoreEvent.new(farmId)
    local self = EnvironmentalScoreEvent.emptyNew()
    self.farmId = farmId
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
function EnvironmentalScoreEvent:readStream(streamId, connection)
    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)

    local pfModule = g_precisionFarming
    if pfModule ~ = nil then
        if pfModule.environmentalScore ~ = nil then
            pfModule.environmentalScore:readStream(streamId, connection, self.farmId)
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
function EnvironmentalScoreEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)

    local pfModule = g_precisionFarming
    if pfModule ~ = nil then
        if pfModule.environmentalScore ~ = nil then
            pfModule.environmentalScore:writeStream(streamId, connection, self.farmId)
        end
    end
end

```