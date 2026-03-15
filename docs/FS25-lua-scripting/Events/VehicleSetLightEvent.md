## VehicleSetLightEvent

**Description**

> Event for light state

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
function VehicleSetLightEvent.emptyNew()
    local self = Event.new( VehicleSetLightEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer lightsTypesMask, )

**Arguments**

| table   | object          | object           |
|---------|-----------------|------------------|
| integer | lightsTypesMask | light types mask |
| any     | numBits         |                  |

**Code**

```lua
function VehicleSetLightEvent.new(object, lightsTypesMask, numBits)
    local self = VehicleSetLightEvent.emptyNew()
    self.object = object
    self.lightsTypesMask = lightsTypesMask
    self.numBits = numBits
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
function VehicleSetLightEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.numBits = streamReadUIntN(streamId, 5 )
    self.lightsTypesMask = streamReadUIntN(streamId, self.numBits)
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
function VehicleSetLightEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setLightsTypesMask( self.lightsTypesMask, true , true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( VehicleSetLightEvent.new( self.object, self.lightsTypesMask, self.numBits), nil , connection, self.object)
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
function VehicleSetLightEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.numBits, 5 )
    streamWriteUIntN(streamId, self.lightsTypesMask, self.numBits)
end

```