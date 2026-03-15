## SetCrabSteeringEvent

**Description**

> Event for steering mode

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
function SetCrabSteeringEvent.emptyNew()
    local self = Event.new( SetCrabSteeringEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer state)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| integer | state  | state  |

**Code**

```lua
function SetCrabSteeringEvent.new(vehicle, state)
    local self = SetCrabSteeringEvent.emptyNew()
    self.vehicle = vehicle
    self.state = state
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
function SetCrabSteeringEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadUIntN(streamId, CrabSteering.STEERING_SEND_NUM_BITS)
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
function SetCrabSteeringEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setCrabSteering( self.state, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( SetCrabSteeringEvent.new( self.vehicle, self.state), nil , connection, self.object)
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

| table   | vehicle     | vehicle       |
|---------|-------------|---------------|
| integer | state       | state         |
| boolean | noEventSend | no event send |

**Code**

```lua
function SetCrabSteeringEvent.sendEvent(vehicle, state, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SetCrabSteeringEvent.new(vehicle, state), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( SetCrabSteeringEvent.new(vehicle, state))
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
function SetCrabSteeringEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.state, CrabSteering.STEERING_SEND_NUM_BITS)
end

```