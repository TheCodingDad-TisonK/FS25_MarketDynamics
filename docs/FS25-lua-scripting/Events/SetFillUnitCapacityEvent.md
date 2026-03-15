## SetFillUnitCapacityEvent

**Description**

> Event for fill unit capacity sync

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
function SetFillUnitCapacityEvent.emptyNew()
    local self = Event.new( SetFillUnitCapacityEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean capacity, )

**Arguments**

| table   | vehicle  | vehicle          |
|---------|----------|------------------|
| boolean | capacity | is filling state |
| any     | capacity |                  |

**Code**

```lua
function SetFillUnitCapacityEvent.new(vehicle, fillUnitIndex, capacity)
    local self = SetFillUnitCapacityEvent.emptyNew()
    self.vehicle = vehicle
    self.fillUnitIndex = fillUnitIndex
    self.capacity = capacity
    return self
end

```

### readStream

**Description**

> Called on client side

**Definition**

> readStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function SetFillUnitCapacityEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.fillUnitIndex = streamReadUIntN(streamId, 8 )
    self.capacity = streamReadFloat32(streamId)
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
function SetFillUnitCapacityEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setFillUnitCapacity( self.fillUnitIndex, self.capacity, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( SetFillUnitCapacityEvent.new( self.vehicle, self.fillUnitIndex, self.capacity), nil , connection, self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean isActive, boolean noEventSend, )

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | isActive    | is active     |
| boolean | noEventSend | no event send |
| any     | noEventSend |               |

**Code**

```lua
function SetFillUnitCapacityEvent.sendEvent(vehicle, fillUnitIndex, capacity, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SetFillUnitCapacityEvent.new(vehicle, fillUnitIndex, capacity), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( SetFillUnitCapacityEvent.new(vehicle, fillUnitIndex, capacity))
            end
        end
    end

```

### writeStream

**Description**

> Called on server side

**Definition**

> writeStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function SetFillUnitCapacityEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.fillUnitIndex, 8 )
    streamWriteFloat32(streamId, self.capacity)
end

```