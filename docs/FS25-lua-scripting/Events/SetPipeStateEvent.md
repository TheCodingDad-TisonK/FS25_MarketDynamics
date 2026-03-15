## SetPipeStateEvent

**Description**

> Event for pipe state

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
function SetPipeStateEvent.emptyNew()
    local self = Event.new( SetPipeStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer pipeState)

**Arguments**

| table   | object    | object     |
|---------|-----------|------------|
| integer | pipeState | pipe state |

**Code**

```lua
function SetPipeStateEvent.new(object, pipeState)
    local self = SetPipeStateEvent.emptyNew()
    self.object = object
    self.pipeState = pipeState
    assert( self.pipeState > = 0 and self.pipeState < 8 )
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
function SetPipeStateEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.pipeState = streamReadUIntN(streamId, 3 )
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
function SetPipeStateEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPipeState( self.pipeState, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( SetPipeStateEvent.new( self.object, self.pipeState), nil , connection, self.object)
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
function SetPipeStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.pipeState, 3 )
end

```