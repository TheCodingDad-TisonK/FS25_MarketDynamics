## SetCruiseControlSpeedEvent

**Description**

> Event for cruise control speed

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
function SetCruiseControlSpeedEvent.emptyNew()
    local self = Event.new( SetCruiseControlSpeedEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, float speed, float speedReverse)

**Arguments**

| table | vehicle      | vehicle      |
|-------|--------------|--------------|
| float | speed        | speed        |
| float | speedReverse | speedReverse |

**Code**

```lua
function SetCruiseControlSpeedEvent.new(vehicle, speed, speedReverse)
    local self = SetCruiseControlSpeedEvent.emptyNew()
    self.speed = speed
    self.speedReverse = speedReverse
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
function SetCruiseControlSpeedEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.speed = streamReadUInt8(streamId)
    self.speedReverse = streamReadUInt8(streamId)
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
function SetCruiseControlSpeedEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.vehicle)
    end
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setCruiseControlMaxSpeed( self.speed, self.speedReverse)
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
function SetCruiseControlSpeedEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUInt8(streamId, self.speed)
    streamWriteUInt8(streamId, self.speedReverse)
end

```