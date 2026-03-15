## BalerBaleTypeEvent

**Description**

> Event for balers to sync selected bale type

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [sendEvent](#sendevent)
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
function BalerBaleTypeEvent.emptyNew()
    return Event.new( BalerBaleTypeEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer baleTypeIndex, boolean force)

**Arguments**

| table   | object        | object        |
|---------|---------------|---------------|
| integer | baleTypeIndex | baleTypeIndex |
| boolean | force         | force         |

**Code**

```lua
function BalerBaleTypeEvent.new(object, baleTypeIndex, force)
    local self = BalerBaleTypeEvent.emptyNew()
    self.object = object
    self.baleTypeIndex = baleTypeIndex
    self.force = force
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
function BalerBaleTypeEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.baleTypeIndex = streamReadUIntN(streamId, BalerBaleTypeEvent.BALE_TYPE_SEND_NUM_BITS)
    self.force = streamReadBool(streamId)
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
function BalerBaleTypeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setBaleTypeIndex( self.baleTypeIndex, self.force, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, integer baleTypeIndex, boolean force, boolean noEventSend)

**Arguments**

| table   | object        | object        |
|---------|---------------|---------------|
| integer | baleTypeIndex | baleTypeIndex |
| boolean | force         | force         |
| boolean | noEventSend   | no event send |

**Code**

```lua
function BalerBaleTypeEvent.sendEvent(object, baleTypeIndex, force, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( BalerBaleTypeEvent.new(object, baleTypeIndex, force), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( BalerBaleTypeEvent.new(object, baleTypeIndex, force))
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
function BalerBaleTypeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.baleTypeIndex, BalerBaleTypeEvent.BALE_TYPE_SEND_NUM_BITS)
    streamWriteBool(streamId, Utils.getNoNil( self.force, false ))
end

```