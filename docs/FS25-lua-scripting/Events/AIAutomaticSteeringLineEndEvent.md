## AIAutomaticSteeringLineEndEvent

**Description**

> Event when hitting the end of the line (server to client)

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
function AIAutomaticSteeringLineEndEvent.emptyNew()
    local self = Event.new( AIAutomaticSteeringLineEndEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer currentAngle, , )

**Arguments**

| table   | vehicle       | vehicle       |
|---------|---------------|---------------|
| integer | currentAngle  | current angle |
| any     | segmentIndex  |               |
| any     | segmentIsLeft |               |

**Code**

```lua
function AIAutomaticSteeringLineEndEvent.new(vehicle, state, segmentIndex, segmentIsLeft)
    local self = AIAutomaticSteeringLineEndEvent.emptyNew()
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
function AIAutomaticSteeringLineEndEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
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
function AIAutomaticSteeringLineEndEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        SpecializationUtil.raiseEvent( self.vehicle, "onAIAutomaticSteeringLineEnd" )
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
function AIAutomaticSteeringLineEndEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

```