## SetSeedIndexEvent

**Description**

> Set seed index event

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
function SetSeedIndexEvent.emptyNew()
    local self = Event.new( SetSeedIndexEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer seedIndex)

**Arguments**

| table   | object    | object        |
|---------|-----------|---------------|
| integer | seedIndex | index of seed |

**Code**

```lua
function SetSeedIndexEvent.new(object, seedIndex)
    local self = SetSeedIndexEvent.emptyNew()
    self.object = object
    self.seedIndex = seedIndex
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
function SetSeedIndexEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.seedIndex = streamReadUInt8(streamId)
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
function SetSeedIndexEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setSeedIndex( self.seedIndex, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, integer seedIndex, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| integer | seedIndex   | index of seed |
| boolean | noEventSend | no event send |

**Code**

```lua
function SetSeedIndexEvent.sendEvent(object, seedIndex, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SetSeedIndexEvent.new(object, seedIndex), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( SetSeedIndexEvent.new(object, seedIndex))
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
function SetSeedIndexEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUInt8(streamId, self.seedIndex)
end

```