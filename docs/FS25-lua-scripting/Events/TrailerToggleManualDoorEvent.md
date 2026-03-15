## TrailerToggleManualDoorEvent

**Description**

> Event for toggle manual trailer door opening

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
function TrailerToggleManualDoorEvent.emptyNew()
    local self = Event.new( TrailerToggleManualDoorEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean state, )

**Arguments**

| table   | object | object |
|---------|--------|--------|
| boolean | state  | state  |
| any     | state  |        |

**Code**

```lua
function TrailerToggleManualDoorEvent.new(object, tipSideIndex, state)
    local self = TrailerToggleManualDoorEvent.emptyNew()
    self.object = object
    self.tipSideIndex = tipSideIndex
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
function TrailerToggleManualDoorEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)
    self.tipSideIndex = streamReadUIntN(streamId, Trailer.TIP_SIDE_NUM_BITS)

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
function TrailerToggleManualDoorEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setTrailerDoorState( self.tipSideIndex, self.state, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isActive, integer beltId, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle        |
|---------|-------------|----------------|
| boolean | isActive    | belt is active |
| integer | beltId      | id of belt     |
| boolean | noEventSend | no event send  |

**Code**

```lua
function TrailerToggleManualDoorEvent.sendEvent(vehicle, tipSideIndex, state, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TrailerToggleManualDoorEvent.new(vehicle, tipSideIndex, state), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( TrailerToggleManualDoorEvent.new(vehicle, tipSideIndex, state))
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
function TrailerToggleManualDoorEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
    streamWriteUIntN(streamId, self.tipSideIndex, Trailer.TIP_SIDE_NUM_BITS)
end

```