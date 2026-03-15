## TensionBeltsEvent

**Description**

> Event for tension belts state

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
function TensionBeltsEvent.emptyNew()
    local self = Event.new( TensionBeltsEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isActive, integer beltId)

**Arguments**

| table   | object   | object         |
|---------|----------|----------------|
| boolean | isActive | belt is active |
| integer | beltId   | id of belt     |

**Code**

```lua
function TensionBeltsEvent.new(object, isActive, beltId)
    local self = TensionBeltsEvent.emptyNew()
    self.object = object
    self.isActive = isActive
    self.beltId = beltId
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
function TensionBeltsEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    if not streamReadBool(streamId) then
        self.beltId = streamReadUIntN(streamId, TensionBelts.NUM_SEND_BITS) + 1
    end
    self.isActive = streamReadBool(streamId)
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
function TensionBeltsEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setTensionBeltsActive( self.isActive, self.beltId, true )
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
function TensionBeltsEvent.sendEvent(vehicle, isActive, beltId, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TensionBeltsEvent.new(vehicle, isActive, beltId), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( TensionBeltsEvent.new(vehicle, isActive, beltId))
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
function TensionBeltsEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.beltId = = nil )
    if self.beltId ~ = nil then
        streamWriteUIntN(streamId, self.beltId - 1 , TensionBelts.NUM_SEND_BITS)
    end
    streamWriteBool(streamId, self.isActive)
end

```