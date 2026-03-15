## AISetModeEvent

**Description**

> Event for ai mode (worker or steering assist)

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
function AISetModeEvent.emptyNew()
    local self = Event.new( AISetModeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer aiMode)

**Arguments**

| table   | vehicle | vehicle |
|---------|---------|---------|
| integer | aiMode  | aiMode  |

**Code**

```lua
function AISetModeEvent.new(vehicle, aiMode)
    local self = AISetModeEvent.emptyNew()
    self.vehicle = vehicle
    self.aiMode = aiMode
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
function AISetModeEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.aiMode = streamReadUIntN(streamId, AIModeSelection.NUM_BITS) + 1
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
function AISetModeEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setAIModeSelection( self.aiMode, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( AISetModeEvent.new( self.vehicle, self.aiMode), nil , connection, self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, integer aiMode, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle       |
|---------|-------------|---------------|
| integer | aiMode      | aiMode        |
| boolean | noEventSend | no event send |

**Code**

```lua
function AISetModeEvent.sendEvent(vehicle, aiMode, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( AISetModeEvent.new(vehicle, aiMode), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( AISetModeEvent.new(vehicle, aiMode))
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
function AISetModeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.aiMode - 1 , AIModeSelection.NUM_BITS)
end

```