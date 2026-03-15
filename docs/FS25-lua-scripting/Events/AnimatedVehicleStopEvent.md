## AnimatedVehicleStopEvent

**Description**

> Event for animation stop

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
function AnimatedVehicleStopEvent.emptyNew()
    local self = Event.new( AnimatedVehicleStopEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, string name)

**Arguments**

| table  | object | object |
|--------|--------|--------|
| string | name   | name   |

**Code**

```lua
function AnimatedVehicleStopEvent.new(object, name)
    local self = AnimatedVehicleStopEvent.emptyNew()
    self.name = name
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
function AnimatedVehicleStopEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.name = streamReadString(streamId)
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
function AnimatedVehicleStopEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:stopAnimation( self.name, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( AnimatedVehicleStopEvent.new( self.object, self.name), nil , connection, self.object)
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
function AnimatedVehicleStopEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteString(streamId, self.name)
end

```