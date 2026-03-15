## JumpEvent

**Description**

> Event for horse jumping

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
function JumpEvent.emptyNew()
    local self = Event.new( JumpEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isPlaying)

**Arguments**

| table   | object    | object          |
|---------|-----------|-----------------|
| boolean | isPlaying | honk is playing |

**Code**

```lua
function JumpEvent.new(object)
    local self = JumpEvent.emptyNew()
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
function JumpEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.object = NetworkUtil.readNodeObject(streamId)
        self:run(connection)
    end
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
function JumpEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:jump( true )
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
function JumpEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.object)
    end
end

```