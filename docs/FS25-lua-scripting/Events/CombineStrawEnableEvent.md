## CombineStrawEnableEvent

**Description**

> Event for straw enable state

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
function CombineStrawEnableEvent.emptyNew()
    local self = Event.new( CombineStrawEnableEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isSwathActive)

**Arguments**

| table   | vehicle       | vehicle          |
|---------|---------------|------------------|
| boolean | isSwathActive | is straw enabled |

**Code**

```lua
function CombineStrawEnableEvent.new(vehicle, isSwathActive)
    local self = CombineStrawEnableEvent.emptyNew()
    self.vehicle = vehicle
    self.isSwathActive = isSwathActive
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
function CombineStrawEnableEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.isSwathActive = streamReadBool(streamId)
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
function CombineStrawEnableEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setIsSwathActive( self.isSwathActive, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( CombineStrawEnableEvent.new( self.vehicle, self.isSwathActive), nil , connection, self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isSwathActive, boolean noEventSend)

**Arguments**

| table   | vehicle       | vehicle          |
|---------|---------------|------------------|
| boolean | isSwathActive | is straw enabled |
| boolean | noEventSend   | no event send    |

**Code**

```lua
function CombineStrawEnableEvent.sendEvent(vehicle, isSwathActive, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( CombineStrawEnableEvent.new(vehicle, isSwathActive), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( CombineStrawEnableEvent.new(vehicle, isSwathActive))
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
function CombineStrawEnableEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.isSwathActive)
end

```