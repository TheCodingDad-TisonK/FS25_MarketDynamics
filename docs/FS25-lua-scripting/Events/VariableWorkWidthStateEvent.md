## VariableWorkWidthStateEvent

**Description**

> Event for variable work width state

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
function VariableWorkWidthStateEvent.emptyNew()
    local self = Event.new( VariableWorkWidthStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer leftSide, integer rightSide)

**Arguments**

| table   | object    | object    |
|---------|-----------|-----------|
| integer | leftSide  | leftSide  |
| integer | rightSide | rightSide |

**Code**

```lua
function VariableWorkWidthStateEvent.new(vehicle, leftSide, rightSide)
    local self = VariableWorkWidthStateEvent.emptyNew()
    self.vehicle = vehicle
    self.leftSide = leftSide
    self.rightSide = rightSide
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
function VariableWorkWidthStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.leftSide = streamReadUIntN(streamId, VariableWorkWidth.SEND_NUM_BITS)
    self.rightSide = streamReadUIntN(streamId, VariableWorkWidth.SEND_NUM_BITS)
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
function VariableWorkWidthStateEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setSectionsActive( self.leftSide, self.rightSide, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( VariableWorkWidthStateEvent.new( self.vehicle, self.leftSide, self.rightSide), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, integer leftSide, integer rightSide, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle       |
|---------|-------------|---------------|
| integer | leftSide    | leftSide      |
| integer | rightSide   | rightSide     |
| boolean | noEventSend | no event send |

**Code**

```lua
function VariableWorkWidthStateEvent.sendEvent(vehicle, leftSide, rightSide, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( VariableWorkWidthStateEvent.new(vehicle, leftSide, rightSide), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( VariableWorkWidthStateEvent.new(vehicle, leftSide, rightSide))
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
function VariableWorkWidthStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.leftSide, VariableWorkWidth.SEND_NUM_BITS)
    streamWriteUIntN(streamId, self.rightSide, VariableWorkWidth.SEND_NUM_BITS)
end

```