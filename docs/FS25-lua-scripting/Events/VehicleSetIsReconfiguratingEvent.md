## VehicleSetIsReconfiguratingEvent

**Description**

> Event for set isRegonfigurating on vehicles

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
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
function VehicleSetIsReconfiguratingEvent.emptyNew()
    local self = Event.new( VehicleSetIsReconfiguratingEvent _mt)
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
function VehicleSetIsReconfiguratingEvent.new(object)
    local self = VehicleSetIsReconfiguratingEvent.emptyNew()
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
function VehicleSetIsReconfiguratingEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object.isReconfigurating = true
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
function VehicleSetIsReconfiguratingEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
end

```