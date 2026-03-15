## TreePlanterCreateTreeEvent

**Description**

> Event for setting the tree type and variation index

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
function TreePlanterCreateTreeEvent.emptyNew()
    local self = Event.new( TreePlanterCreateTreeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer palletObjectId, )

**Arguments**

| table   | object             | object              |
|---------|--------------------|---------------------|
| integer | palletObjectId     | object id of pallet |
| any     | treeVariationIndex |                     |

**Code**

```lua
function TreePlanterCreateTreeEvent.new(object, treeTypeIndex, treeVariationIndex)
    local self = TreePlanterCreateTreeEvent.emptyNew()
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
function TreePlanterCreateTreeEvent:readStream(streamId, connection)
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
function TreePlanterCreateTreeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:createTree( true )
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
function TreePlanterCreateTreeEvent.sendEvent(object, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TreePlanterCreateTreeEvent.new(object), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( TreePlanterCreateTreeEvent.new(object))
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
function TreePlanterCreateTreeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
end

```