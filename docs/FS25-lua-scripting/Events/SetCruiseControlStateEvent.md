## SetCruiseControlStateEvent

**Description**

> Event for cruise control state event

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
function SetCruiseControlStateEvent.emptyNew()
    local self = Event.new( SetCruiseControlStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer state)

**Arguments**

| table   | vehicle | vehicle |
|---------|---------|---------|
| integer | state   | state   |

**Code**

```lua
function SetCruiseControlStateEvent.new(vehicle, state)
    local self = SetCruiseControlStateEvent.emptyNew()
    self.state = state
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
function SetCruiseControlStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadUIntN(streamId, 2 )
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
function SetCruiseControlStateEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setCruiseControlState( self.state, true )
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
function SetCruiseControlStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.state, 2 )
end

```