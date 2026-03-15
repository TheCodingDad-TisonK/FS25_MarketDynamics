## HonkEvent

**Description**

> Event for honking

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
function HonkEvent.emptyNew()
    local self = Event.new( HonkEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isPlaying)

**Arguments**

| table   | object    | object          |
|---------|-----------|-----------------|
| boolean | isPlaying | honk is playing |

**Code**

```lua
function HonkEvent.new(object, isPlaying)
    local self = HonkEvent.emptyNew()
    self.object = object
    self.isPlaying = isPlaying
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
function HonkEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.isPlaying = streamReadBool(streamId)
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
function HonkEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:playHonk( self.isPlaying, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( HonkEvent.new( self.object, self.isPlaying), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isPlaying, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle         |
|---------|-------------|-----------------|
| boolean | isPlaying   | honk is playing |
| boolean | noEventSend | no event send   |

**Code**

```lua
function HonkEvent.sendEvent(vehicle, isPlaying, noEventSend)
    if vehicle.spec_honk ~ = nil and vehicle.spec_honk.isPlaying ~ = isPlaying then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( HonkEvent.new(vehicle, isPlaying), nil , nil , vehicle)
            else
                    g_client:getServerConnection():sendEvent( HonkEvent.new(vehicle, isPlaying))
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
function HonkEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.isPlaying)
end

```