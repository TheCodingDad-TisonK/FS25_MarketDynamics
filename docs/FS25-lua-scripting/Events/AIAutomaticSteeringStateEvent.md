## AIAutomaticSteeringStateEvent

**Description**

> Event for current automatic steering state

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
function AIAutomaticSteeringStateEvent.emptyNew()
    local self = Event.new( AIAutomaticSteeringStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer currentAngle, , )

**Arguments**

| table   | vehicle       | vehicle       |
|---------|---------------|---------------|
| integer | currentAngle  | current angle |
| any     | segmentIndex  |               |
| any     | segmentIsLeft |               |

**Code**

```lua
function AIAutomaticSteeringStateEvent.new(vehicle, state, segmentIndex, segmentIsLeft)
    local self = AIAutomaticSteeringStateEvent.emptyNew()
    self.vehicle = vehicle
    self.state = state
    self.segmentIndex = segmentIndex
    self.segmentIsLeft = segmentIsLeft

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
function AIAutomaticSteeringStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)

    if streamReadBool(streamId) then
        self.segmentIndex = streamReadUInt16(streamId)
        self.segmentIsLeft = streamReadBool(streamId)
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
function AIAutomaticSteeringStateEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.segmentIndex, self.segmentIsLeft = self.vehicle:setAIAutomaticSteeringEnabled( self.state, self.segmentIndex, self.segmentIsLeft, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( AIAutomaticSteeringStateEvent.new( self.vehicle, self.state, self.segmentIndex, self.segmentIsLeft), nil , nil , self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, integer aiMode, boolean noEventSend, , )

**Arguments**

| table   | vehicle       | vehicle       |
|---------|---------------|---------------|
| integer | aiMode        | aiMode        |
| boolean | noEventSend   | no event send |
| any     | segmentIsLeft |               |
| any     | noEventSend   |               |

**Code**

```lua
function AIAutomaticSteeringStateEvent.sendEvent(vehicle, state, segmentIndex, segmentIsLeft, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( AIAutomaticSteeringStateEvent.new(vehicle, state, segmentIndex, segmentIsLeft), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( AIAutomaticSteeringStateEvent.new(vehicle, state, segmentIndex, segmentIsLeft))
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
function AIAutomaticSteeringStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.state)

    if streamWriteBool(streamId, self.segmentIndex ~ = nil and self.segmentIndex > 0 ) then
        streamWriteUInt16(streamId, self.segmentIndex)
        streamWriteBool(streamId, Utils.getNoNil( self.segmentIsLeft, false ))
    end
end

```