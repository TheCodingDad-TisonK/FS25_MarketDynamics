## TreePlanterLoadPalletEvent

**Description**

> Event for loading of pallet on tree planter

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
function TreePlanterLoadPalletEvent.emptyNew()
    local self = Event.new( TreePlanterLoadPalletEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer palletObjectId)

**Arguments**

| table   | object         | object              |
|---------|----------------|---------------------|
| integer | palletObjectId | object id of pallet |

**Code**

```lua
function TreePlanterLoadPalletEvent.new(object, palletObjectId)
    local self = TreePlanterLoadPalletEvent.emptyNew()
    self.object = object
    self.palletObjectId = palletObjectId
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
function TreePlanterLoadPalletEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.palletObjectId = NetworkUtil.readNodeObjectId(streamId)
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
function TreePlanterLoadPalletEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:loadPallet( self.palletObjectId, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, integer palletObjectId, boolean noEventSend)

**Arguments**

| table   | object         | object              |
|---------|----------------|---------------------|
| integer | palletObjectId | object id of pallet |
| boolean | noEventSend    | no event send       |

**Code**

```lua
function TreePlanterLoadPalletEvent.sendEvent(object, palletObjectId, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TreePlanterLoadPalletEvent.new(object, palletObjectId), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( TreePlanterLoadPalletEvent.new(object, palletObjectId))
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
function TreePlanterLoadPalletEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    NetworkUtil.writeNodeObjectId(streamId, self.palletObjectId)
end

```