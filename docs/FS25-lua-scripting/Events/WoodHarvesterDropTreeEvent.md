## WoodHarvesterDropTreeEvent

**Description**

> Event for cut tree

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
function WoodHarvesterDropTreeEvent.emptyNew()
    local self = Event.new( WoodHarvesterDropTreeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, float length)

**Arguments**

| table | object | object |
|-------|--------|--------|
| float | length | length |

**Code**

```lua
function WoodHarvesterDropTreeEvent.new(object)
    local self = WoodHarvesterDropTreeEvent.emptyNew()
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
function WoodHarvesterDropTreeEvent:readStream(streamId, connection)
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
function WoodHarvesterDropTreeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( WoodHarvesterDropTreeEvent.new( self.object), nil , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:dropWoodHarvesterTree( true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, float length, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| float   | length      | length        |
| boolean | noEventSend | no event send |

**Code**

```lua
function WoodHarvesterDropTreeEvent.sendEvent(object, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( WoodHarvesterDropTreeEvent.new(object), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( WoodHarvesterDropTreeEvent.new(object))
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
function WoodHarvesterDropTreeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
end

```