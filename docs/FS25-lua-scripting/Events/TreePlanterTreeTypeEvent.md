## TreePlanterTreeTypeEvent

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
function TreePlanterTreeTypeEvent.emptyNew()
    local self = Event.new( TreePlanterTreeTypeEvent _mt)
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
function TreePlanterTreeTypeEvent.new(object, treeTypeIndex, treeVariationIndex)
    local self = TreePlanterTreeTypeEvent.emptyNew()
    self.object = object
    self.treeTypeIndex = treeTypeIndex
    self.treeVariationIndex = treeVariationIndex
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
function TreePlanterTreeTypeEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.treeTypeIndex = streamReadUInt32(streamId)
    self.treeVariationIndex = streamReadUIntN(streamId, TreePlantManager.VARIATION_NUM_BITS)

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
function TreePlanterTreeTypeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setTreePlanterTreeTypeIndex( self.treeTypeIndex, self.treeVariationIndex, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, integer palletObjectId, boolean noEventSend, )

**Arguments**

| table   | object         | object              |
|---------|----------------|---------------------|
| integer | palletObjectId | object id of pallet |
| boolean | noEventSend    | no event send       |
| any     | noEventSend    |                     |

**Code**

```lua
function TreePlanterTreeTypeEvent.sendEvent(object, treeTypeIndex, treeVariationIndex, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TreePlanterTreeTypeEvent.new(object, treeTypeIndex, treeVariationIndex), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( TreePlanterTreeTypeEvent.new(object, treeTypeIndex, treeVariationIndex))
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
function TreePlanterTreeTypeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUInt32(streamId, self.treeTypeIndex)
    streamWriteUIntN(streamId, self.treeVariationIndex or 1 , TreePlantManager.VARIATION_NUM_BITS)
end

```