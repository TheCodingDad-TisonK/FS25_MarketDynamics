## AIConveyorBeltSetAngleEvent

**Description**

> Event for conveyor belt angle

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
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
function AIConveyorBeltSetAngleEvent.emptyNew()
    local self = Event.new( AIConveyorBeltSetAngleEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer currentAngle)

**Arguments**

| table   | vehicle      | vehicle       |
|---------|--------------|---------------|
| integer | currentAngle | current angle |

**Code**

```lua
function AIConveyorBeltSetAngleEvent.new(vehicle, currentAngle)
    local self = AIConveyorBeltSetAngleEvent.emptyNew()
    self.currentAngle = currentAngle
    self.vehicle = vehicle
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
function AIConveyorBeltSetAngleEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.currentAngle = streamReadInt8(streamId)
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
function AIConveyorBeltSetAngleEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setAIConveyorBeltAngle( self.currentAngle, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( AIConveyorBeltSetAngleEvent.new( self.vehicle, self.currentAngle), nil , connection, self.vehicle)
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
function AIConveyorBeltSetAngleEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteInt8(streamId, self.currentAngle)
end

```