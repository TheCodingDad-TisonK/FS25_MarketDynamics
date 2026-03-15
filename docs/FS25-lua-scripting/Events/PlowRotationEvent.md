## PlowRotationEvent

**Description**

> Event for plow rotation

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
function PlowRotationEvent.emptyNew()
    local self = Event.new( PlowRotationEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean rotationMax)

**Arguments**

| table   | object      | object       |
|---------|-------------|--------------|
| boolean | rotationMax | rotation max |

**Code**

```lua
function PlowRotationEvent.new(object, rotationMax)
    local self = PlowRotationEvent.emptyNew()
    self.object = object
    self.rotationMax = rotationMax
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
function PlowRotationEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.rotationMax = streamReadBool(streamId)
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
function PlowRotationEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setRotationMax( self.rotationMax, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( PlowRotationEvent.new( self.object, self.rotationMax), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean rotationMax, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | rotationMax | rotationMax   |
| boolean | noEventSend | no event send |

**Code**

```lua
function PlowRotationEvent.sendEvent(object, rotationMax, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlowRotationEvent.new(object, rotationMax), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( PlowRotationEvent.new(object, rotationMax))
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
function PlowRotationEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.rotationMax)
end

```