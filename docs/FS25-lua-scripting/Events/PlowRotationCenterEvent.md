## PlowRotationCenterEvent

**Description**

> Event for plow center rotation

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
function PlowRotationCenterEvent.emptyNew()
    local self = Event.new( PlowRotationCenterEvent _mt)
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
function PlowRotationCenterEvent.new(object)
    local self = PlowRotationCenterEvent.emptyNew()
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
function PlowRotationCenterEvent:readStream(streamId, connection)
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
function PlowRotationCenterEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setRotationCenter( true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( PlowRotationCenterEvent.new( self.object), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | noEventSend | no event send |

**Code**

```lua
function PlowRotationCenterEvent.sendEvent(object, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlowRotationCenterEvent.new(object), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( PlowRotationCenterEvent.new(object))
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
function PlowRotationCenterEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
end

```