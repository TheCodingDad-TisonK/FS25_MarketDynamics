## BalerDropFromPlatformEvent

**Description**

> Event for baler is unloading state

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
function BalerDropFromPlatformEvent.emptyNew()
    local self = Event.new( BalerDropFromPlatformEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean waitForNextBale)

**Arguments**

| table   | object          | object            |
|---------|-----------------|-------------------|
| boolean | waitForNextBale | is unloading bale |

**Code**

```lua
function BalerDropFromPlatformEvent.new(object, waitForNextBale)
    local self = BalerDropFromPlatformEvent.emptyNew()
    self.object = object
    self.waitForNextBale = waitForNextBale
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
function BalerDropFromPlatformEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.waitForNextBale = streamReadBool(streamId)
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
function BalerDropFromPlatformEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:dropBaleFromPlatform( self.waitForNextBale, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean waitForNextBale, boolean noEventSend)

**Arguments**

| table   | object          | object          |
|---------|-----------------|-----------------|
| boolean | waitForNextBale | waitForNextBale |
| boolean | noEventSend     | no event send   |

**Code**

```lua
function BalerDropFromPlatformEvent.sendEvent(object, waitForNextBale, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( BalerDropFromPlatformEvent.new(object, waitForNextBale), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( BalerDropFromPlatformEvent.new(object, waitForNextBale))
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
function BalerDropFromPlatformEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.waitForNextBale)
end

```