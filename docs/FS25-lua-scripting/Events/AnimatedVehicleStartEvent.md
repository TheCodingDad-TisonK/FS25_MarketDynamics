## AnimatedVehicleStartEvent

**Description**

> Event for animation start

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
function AnimatedVehicleStartEvent.emptyNew()
    local self = Event.new( AnimatedVehicleStartEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, string name, float speed, float animTime)

**Arguments**

| table  | object   | object             |
|--------|----------|--------------------|
| string | name     | name of animation  |
| float  | speed    | speed of animation |
| float  | animTime | time of animation  |

**Code**

```lua
function AnimatedVehicleStartEvent.new(object, name, speed, animTime)
    local self = AnimatedVehicleStartEvent.emptyNew()
    self.name = name
    self.speed = speed
    self.animTime = animTime
    self.object = object
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
function AnimatedVehicleStartEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.name = streamReadString(streamId)
    self.speed = streamReadFloat32(streamId)
    self.animTime = streamReadFloat32(streamId)

    self:run(connection)
end

```

### run

**Description**

**Definition**

> run()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function AnimatedVehicleStartEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:playAnimation( self.name, self.speed, self.animTime, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( AnimatedVehicleStartEvent.new( self.object, self.name, self.speed, self.animTime), nil , connection, self.object)
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
function AnimatedVehicleStartEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteString(streamId, self.name)
    streamWriteFloat32(streamId, self.speed)
    streamWriteFloat32(streamId, self.animTime)
end

```