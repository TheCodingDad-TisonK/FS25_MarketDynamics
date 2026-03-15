## PlowPackerStateEvent

**Description**

> Event for setting the plow packer state

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
- [sendEvent](#sendevent)
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
function PlowPackerStateEvent.emptyNew()
    return Event.new( PlowPackerStateEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean state, boolean updateAnimations)

**Arguments**

| table   | object           | object           |
|---------|------------------|------------------|
| boolean | state            | state            |
| boolean | updateAnimations | updateAnimations |

**Code**

```lua
function PlowPackerStateEvent.new(object, state, updateAnimations)
    local self = PlowPackerStateEvent.emptyNew()
    self.object = object
    self.state = state
    self.updateAnimations = updateAnimations
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
function PlowPackerStateEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)
    self.updateAnimations = streamReadBool(streamId)
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
function PlowPackerStateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPackerState( self.state, self.updateAnimations, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean state, boolean updateAnimations, boolean noEventSend)

**Arguments**

| table   | object           | object           |
|---------|------------------|------------------|
| boolean | state            | state            |
| boolean | updateAnimations | updateAnimations |
| boolean | noEventSend      | no event send    |

**Code**

```lua
function PlowPackerStateEvent.sendEvent(object, state, updateAnimations, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlowPackerStateEvent.new(object, state, updateAnimations), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( PlowPackerStateEvent.new(object, state, updateAnimations))
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
function PlowPackerStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
    streamWriteBool(streamId, self.updateAnimations)
end

```