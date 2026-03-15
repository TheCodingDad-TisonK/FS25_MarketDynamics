## LocomotiveStateEvent

**Description**

> Event for locomotive state

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
function LocomotiveStateEvent.emptyNew()
    local self = Event.new( LocomotiveStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean state)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| boolean | state  | state  |

**Code**

```lua
function LocomotiveStateEvent.new(object, state)
    local self = LocomotiveStateEvent.emptyNew()
    self.object = object
    self.state = state
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
function LocomotiveStateEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadUIntN(streamId, Locomotive.NUM_BITS_STATE)
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
function LocomotiveStateEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setLocomotiveState( self.state, true )
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
function LocomotiveStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.state, Locomotive.NUM_BITS_STATE)
end

```