## FillUnitUnloadEvent

**Description**

> Event for turned on state

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [newServerToClient](#newservertoclient)
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
function FillUnitUnloadEvent.emptyNew()
    local self = Event.new( FillUnitUnloadEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Code**

```lua
function FillUnitUnloadEvent.new(object)
    local self = FillUnitUnloadEvent.emptyNew()
    self.object = object
    return self
end

```

### newServerToClient

**Description**

**Definition**

> newServerToClient()

**Code**

```lua
function FillUnitUnloadEvent.newServerToClient()
    local self = FillUnitUnloadEvent.emptyNew()
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
function FillUnitUnloadEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.object = NetworkUtil.readNodeObject(streamId)
    end
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
function FillUnitUnloadEvent:run(connection)
    if not connection:getIsServer() then
        if self.object ~ = nil and self.object:getIsSynchronized() then
            self.object:unloadFillUnits( true )
        end
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
function FillUnitUnloadEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.object)
    end
end

```