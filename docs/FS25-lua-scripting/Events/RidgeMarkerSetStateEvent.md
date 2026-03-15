## RidgeMarkerSetStateEvent

**Description**

> Event for ridge marker state

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
function RidgeMarkerSetStateEvent.emptyNew()
    local self = Event.new( RidgeMarkerSetStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer state)

**Arguments**

| table   | vehicle | vehicle |
|---------|---------|---------|
| integer | state   | state   |

**Code**

```lua
function RidgeMarkerSetStateEvent.new(vehicle, state)
    local self = RidgeMarkerSetStateEvent.emptyNew()
    self.vehicle = vehicle
    self.state = state
    assert(state > = 0 and state < RidgeMarker.MAX_NUM_RIDGEMARKERS)
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
function RidgeMarkerSetStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadUIntN(streamId, RidgeMarker.SEND_NUM_BITS)
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
function RidgeMarkerSetStateEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setRidgeMarkerState( self.state, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( RidgeMarkerSetStateEvent.new( self.vehicle, self.state), nil , connection, self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, integer state, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle         |
|---------|-------------|-----------------|
| integer | state       | discharge state |
| boolean | noEventSend | no event send   |

**Code**

```lua
function RidgeMarkerSetStateEvent.sendEvent(vehicle, state, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( RidgeMarkerSetStateEvent.new(vehicle, state), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( RidgeMarkerSetStateEvent.new(vehicle, state))
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
function RidgeMarkerSetStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.state, RidgeMarker.SEND_NUM_BITS)
end

```