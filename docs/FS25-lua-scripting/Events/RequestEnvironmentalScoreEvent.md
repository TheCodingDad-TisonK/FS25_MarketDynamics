## RequestEnvironmentalScoreEvent

**Description**

> Event for syncing the environmental score to the player

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
function RequestEnvironmentalScoreEvent.emptyNew()
    local self = Event.new( RequestEnvironmentalScoreEvent _mt)
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
function RequestEnvironmentalScoreEvent.new(farmId)
    local self = RequestEnvironmentalScoreEvent.emptyNew()
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
function RequestEnvironmentalScoreEvent:readStream(streamId, connection)
    self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
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
function RequestEnvironmentalScoreEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( EnvironmentalScoreEvent.new( self.farmId), false , nil , nil , true , { connection } )
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
function RequestEnvironmentalScoreEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
end

```