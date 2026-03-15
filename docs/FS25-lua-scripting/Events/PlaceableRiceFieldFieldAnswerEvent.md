## PlaceableRiceFieldFieldAnswerEvent

**Description**

> Event for a rice field

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
function PlaceableRiceFieldFieldAnswerEvent.emptyNew()
    return Event.new( PlaceableRiceFieldFieldAnswerEvent _mt, NetworkNode.CHANNEL_MAIN)
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
| any | statusCode         |

**Code**

```lua
function PlaceableRiceFieldFieldAnswerEvent.new(placeableRiceField, statusCode)
    local self = PlaceableRiceFieldFieldAnswerEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.statusCode = statusCode

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
function PlaceableRiceFieldFieldAnswerEvent:readStream(streamId, connection)
    self.placeableRiceField = NetworkUtil.readNodeObject(streamId)

    self.statusCode = streamReadUInt8(streamId)

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
function PlaceableRiceFieldFieldAnswerEvent:run(connection)
    if self.placeableRiceField ~ = nil and self.placeableRiceField:getIsSynchronized() then
        g_messageCenter:publish( PlaceableRiceFieldFieldAnswerEvent , self.statusCode)
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
function PlaceableRiceFieldFieldAnswerEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeableRiceField)

    streamWriteUInt8(streamId, self.statusCode)
end

```