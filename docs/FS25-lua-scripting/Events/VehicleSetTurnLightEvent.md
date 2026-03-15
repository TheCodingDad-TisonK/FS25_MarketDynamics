## VehicleSetTurnLightEvent

**Description**

> Event for turn light state

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
function VehicleSetTurnLightEvent.emptyNew()
    local self = Event.new( VehicleSetTurnLightEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer state)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| integer | state  | state  |

**Code**

```lua
function VehicleSetTurnLightEvent.new(object, state)
    local self = VehicleSetTurnLightEvent.emptyNew()
    self.object = object
    self.state = state
    assert(state > = 0 and state < = Lights.TURNLIGHT_HAZARD)
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
function VehicleSetTurnLightEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadUIntN(streamId, Lights.turnLightSendNumBits)
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
function VehicleSetTurnLightEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setTurnLightState( self.state, true , true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( VehicleSetTurnLightEvent.new( self.object, self.state), nil , connection, self.object)
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
function VehicleSetTurnLightEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.state, Lights.turnLightSendNumBits)
end

```