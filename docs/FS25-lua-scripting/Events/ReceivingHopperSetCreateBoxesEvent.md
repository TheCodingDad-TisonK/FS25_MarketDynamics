## ReceivingHopperSetCreateBoxesEvent

**Description**

> Event for toggle box creation

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
function ReceivingHopperSetCreateBoxesEvent.emptyNew()
    local self = Event.new( ReceivingHopperSetCreateBoxesEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean state)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| boolean | state  | state  |

**Code**

```lua
function ReceivingHopperSetCreateBoxesEvent.new(object, state)
    local self = ReceivingHopperSetCreateBoxesEvent.emptyNew()
    self.object = object
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
function ReceivingHopperSetCreateBoxesEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)
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
function ReceivingHopperSetCreateBoxesEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setCreateBoxes( self.state, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( ReceivingHopperSetCreateBoxesEvent.new( self.object, self.state), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean state, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle       |
|---------|-------------|---------------|
| boolean | state       | state         |
| boolean | noEventSend | no event send |

**Code**

```lua
function ReceivingHopperSetCreateBoxesEvent.sendEvent(vehicle, state, noEventSend)
    if state ~ = vehicle.state then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( ReceivingHopperSetCreateBoxesEvent.new(vehicle, state), nil , nil , vehicle)
            else
                    g_client:getServerConnection():sendEvent( ReceivingHopperSetCreateBoxesEvent.new(vehicle, state))
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
function ReceivingHopperSetCreateBoxesEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
end

```