## VehicleSetBeaconLightEvent

**Description**

> Event for beacon light state

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
function VehicleSetBeaconLightEvent.emptyNew()
    local self = Event.new( VehicleSetBeaconLightEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean active)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| boolean | active | active |

**Code**

```lua
function VehicleSetBeaconLightEvent.new(object, active)
    local self = VehicleSetBeaconLightEvent.emptyNew()
    self.active = active
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
function VehicleSetBeaconLightEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.active = streamReadBool(streamId)
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
function VehicleSetBeaconLightEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setBeaconLightsVisibility( self.active, true , true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( VehicleSetBeaconLightEvent.new( self.object, self.active), nil , connection, self.object)
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
function VehicleSetBeaconLightEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.active)
end

```