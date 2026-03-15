## VehicleBrokenEvent

**Description**

> Event for enter request

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
function VehicleBrokenEvent.emptyNew()
    local self = Event.new( VehicleBrokenEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, table playerStyle)

**Arguments**

| table | object      | object |
|-------|-------------|--------|
| table | playerStyle | info   |

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function VehicleBrokenEvent.new(object)
    local self = VehicleBrokenEvent.emptyNew()
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
function VehicleBrokenEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
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
function VehicleBrokenEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setBroken()
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
function VehicleBrokenEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
end

```