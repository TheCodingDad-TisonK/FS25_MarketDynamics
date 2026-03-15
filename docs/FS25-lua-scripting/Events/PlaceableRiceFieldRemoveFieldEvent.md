## PlaceableRiceFieldRemoveFieldEvent

**Description**

> Event for removing a rice field

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
function PlaceableRiceFieldRemoveFieldEvent.emptyNew()
    return Event.new( PlaceableRiceFieldRemoveFieldEvent _mt, NetworkNode.CHANNEL_MAIN)
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
function PlaceableRiceFieldRemoveFieldEvent.new(placeableRiceField, fieldIndex)
    local self = PlaceableRiceFieldRemoveFieldEvent.emptyNew()

    self.placeableRiceField = placeableRiceField
    self.fieldIndex = fieldIndex

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
function PlaceableRiceFieldRemoveFieldEvent:readStream(streamId, connection)
    self.placeableRiceField = NetworkUtil.readNodeObject(streamId)

    self.fieldIndex = streamReadUInt8(streamId)

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
function PlaceableRiceFieldRemoveFieldEvent:run(connection)
    if self.placeableRiceField ~ = nil and self.placeableRiceField:getIsSynchronized() then
        self.placeableRiceField:removeFieldByIndex( self.fieldIndex)

        -- Server broadcasts to all clients
        if not connection:getIsServer() then
            g_server:broadcastEvent( self )
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
function PlaceableRiceFieldRemoveFieldEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeableRiceField)

    streamWriteUInt8(streamId, self.fieldIndex)
end

```