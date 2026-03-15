## CraneShovelEvent

**Description**

> Event for crane shovel state

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
function CraneShovelEvent.emptyNew()
    local self = Event.new( CraneShovelEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, )

**Arguments**

| table | object | object |
|-------|--------|--------|
| any   | state  |        |

**Code**

```lua
function CraneShovelEvent.new(object, state)
    local self = CraneShovelEvent.emptyNew()

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
function CraneShovelEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)

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
function CraneShovelEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setCraneShovelState( self.state, nil , true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean isActive, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | isActive    | is active     |
| boolean | noEventSend | no event send |

**Code**

```lua
function CraneShovelEvent.sendEvent(object, state, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( CraneShovelEvent.new(object, state), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( CraneShovelEvent.new(object, state))
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
function CraneShovelEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
end

```