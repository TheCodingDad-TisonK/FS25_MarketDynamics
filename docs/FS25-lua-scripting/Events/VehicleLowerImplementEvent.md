## VehicleLowerImplementEvent

**Description**

> Event for lowering implement

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
function VehicleLowerImplementEvent.emptyNew()
    local self = Event.new( VehicleLowerImplementEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer jointIndex, boolean moveDown)

**Arguments**

| table   | vehicle    | vehicle        |
|---------|------------|----------------|
| integer | jointIndex | index of joint |
| boolean | moveDown   | move down      |

**Return Values**

| boolean | instance | instance of event |
|---------|----------|-------------------|

**Code**

```lua
function VehicleLowerImplementEvent.new(vehicle, jointIndex, moveDown)
    local self = VehicleLowerImplementEvent.emptyNew()
    self.jointIndex = jointIndex
    self.vehicle = vehicle
    self.moveDown = moveDown
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
function VehicleLowerImplementEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.jointIndex = streamReadInt8(streamId)
    self.moveDown = streamReadBool(streamId)
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
function VehicleLowerImplementEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setJointMoveDown( self.jointIndex, self.moveDown, true )
    end
    if not connection:getIsServer() then
        g_server:broadcastEvent( VehicleLowerImplementEvent.new( self.vehicle, self.jointIndex, self.moveDown), nil , connection, self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, integer jointIndex, boolean moveDown, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle        |
|---------|-------------|----------------|
| integer | jointIndex  | index of joint |
| boolean | moveDown    | move down      |
| boolean | noEventSend | no event send  |

**Code**

```lua
function VehicleLowerImplementEvent.sendEvent(vehicle, jointIndex, moveDown, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( VehicleLowerImplementEvent.new(vehicle, jointIndex, moveDown), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( VehicleLowerImplementEvent.new(vehicle, jointIndex, moveDown))
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
function VehicleLowerImplementEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteInt8(streamId, self.jointIndex)
    streamWriteBool(streamId, self.moveDown)
end

```