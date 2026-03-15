## SetCoverStateEvent

**Description**

> Event for cover state

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
function SetCoverStateEvent.emptyNew()
    return Event.new( SetCoverStateEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer state)

**Arguments**

| table   | vehicle | vehicle     |
|---------|---------|-------------|
| integer | state   | cover state |

**Code**

```lua
function SetCoverStateEvent.new(vehicle, state)
    local self = SetCoverStateEvent.emptyNew()

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
function SetCoverStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadUIntN(streamId, Cover.SEND_NUM_BITS)
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
function SetCoverStateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.vehicle)
    end

    if self.vehicle ~ = nil then
        if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
            self.vehicle:setCoverState( self.state, true )
        end
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
| integer | state       | cover state   |
| boolean | noEventSend | no event send |

**Code**

```lua
function SetCoverStateEvent.sendEvent(vehicle, state, noEventSend)
    if vehicle.spec_cover.state ~ = state then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( SetCoverStateEvent.new(vehicle, state), nil , nil , vehicle)
            else
                    g_client:getServerConnection():sendEvent( SetCoverStateEvent.new(vehicle, state))
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
function SetCoverStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.state, Cover.SEND_NUM_BITS)
end

```