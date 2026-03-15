## BaleWrapperAutomaticDropEvent

**Description**

> Event for baleWrappers to sync automatic drop state

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
function BaleWrapperAutomaticDropEvent.emptyNew()
    return Event.new( BaleWrapperAutomaticDropEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean automaticDrop)

**Arguments**

| table   | object        | object        |
|---------|---------------|---------------|
| boolean | automaticDrop | automaticDrop |

**Code**

```lua
function BaleWrapperAutomaticDropEvent.new(object, automaticDrop)
    local self = BaleWrapperAutomaticDropEvent.emptyNew()
    self.object = object
    self.automaticDrop = automaticDrop
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
function BaleWrapperAutomaticDropEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.automaticDrop = streamReadBool(streamId)
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
function BaleWrapperAutomaticDropEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setBaleWrapperAutomaticDrop( self.automaticDrop, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean automaticDrop, boolean noEventSend)

**Arguments**

| table   | object        | object        |
|---------|---------------|---------------|
| boolean | automaticDrop | automaticDrop |
| boolean | noEventSend   | no event send |

**Code**

```lua
function BaleWrapperAutomaticDropEvent.sendEvent(object, automaticDrop, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( BaleWrapperAutomaticDropEvent.new(object, automaticDrop), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( BaleWrapperAutomaticDropEvent.new(object, automaticDrop))
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
function BaleWrapperAutomaticDropEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.automaticDrop)
end

```