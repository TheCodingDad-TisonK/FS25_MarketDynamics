## PlaceableRiceFieldStateEvent

**Description**

> Event for a rice field state used in RiceFieldDialog

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [newServerToClient](#newservertoclient)
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
function PlaceableRiceFieldStateEvent.emptyNew()
    return Event.new( PlaceableRiceFieldStateEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new()

**Arguments**

| any | placeableRiceField |
|-----|--------------------|
| any | fieldIndex         |

**Code**

```lua
function PlaceableRiceFieldStateEvent.new(placeableRiceField, fieldIndex)
    local self = PlaceableRiceFieldStateEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.fieldIndex = fieldIndex

    return self
end

```

### newServerToClient

**Description**

> Create new instance of event

**Definition**

> newServerToClient()

**Arguments**

| any | placeableRiceField |
|-----|--------------------|
| any | fieldIndex         |
| any | fruitTypeIndex     |
| any | growthStateIndex   |

**Code**

```lua
function PlaceableRiceFieldStateEvent.newServerToClient(placeableRiceField, fieldIndex, fruitTypeIndex, growthStateIndex)
    local self = PlaceableRiceFieldStateEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.fieldIndex = fieldIndex

    self.fruitTypeIndex = fruitTypeIndex
    self.growthStateIndex = growthStateIndex

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
function PlaceableRiceFieldStateEvent:readStream(streamId, connection)
    self.placeableRiceField = NetworkUtil.readNodeObject(streamId)
    self.fieldIndex = streamReadUInt8(streamId)

    if connection:getIsServer() then
        self.fruitTypeIndex = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)
        self.growthStateIndex = streamReadUInt8(streamId)
    end

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
function PlaceableRiceFieldStateEvent:run(connection)
    if self.placeableRiceField = = nil or not self.placeableRiceField:getIsSynchronized() then
        return
    end

    if not connection:getIsServer() then
        self.placeableRiceField:getRiceFieldState( self.fieldIndex, function (_, fruitTypeIndex, growthStateIndex)
            connection:sendEvent( PlaceableRiceFieldStateEvent.newServerToClient( self.placeableRiceField, self.fieldIndex, fruitTypeIndex, growthStateIndex))
        end )
    else
            g_messageCenter:publish( PlaceableRiceFieldStateEvent , self.fruitTypeIndex, self.growthStateIndex)
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
function PlaceableRiceFieldStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeableRiceField)
    streamWriteUInt8(streamId, self.fieldIndex)

    if not connection:getIsServer() then
        -- answer with from server to client
        streamWriteUIntN(streamId, self.fruitTypeIndex, FruitTypeManager.SEND_NUM_BITS)
        streamWriteUInt8(streamId, self.growthStateIndex)
    end
end

```