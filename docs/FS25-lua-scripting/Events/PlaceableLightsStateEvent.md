## PlaceableLightsStateEvent

**Description**

> Event for toggling placeable light state

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
function PlaceableLightsStateEvent.emptyNew()
    return Event.new( PlaceableLightsStateEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer groupIndex, boolean isActive)

**Arguments**

| table   | object     | object         |
|---------|------------|----------------|
| integer | groupIndex | index of group |
| boolean | isActive   | is active      |

**Code**

```lua
function PlaceableLightsStateEvent.new(placeable, groupIndex, isActive)
    local self = PlaceableLightsStateEvent.emptyNew()
    self.placeable = placeable
    self.groupIndex = groupIndex
    self.isActive = isActive
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
function PlaceableLightsStateEvent:readStream(streamId, connection)
    self.placeable = NetworkUtil.readNodeObject(streamId)
    self.groupIndex = streamReadUIntN(streamId, PlaceableLights.MAX_NUM_BITS)
    self.isActive = streamReadBool(streamId)
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
function PlaceableLightsStateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.placeable)
    end

    if self.placeable ~ = nil and self.placeable:getIsSynchronized() and self.placeable.setGroupIsActive ~ = nil then
        self.placeable:setGroupIsActive( self.groupIndex, self.isActive, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table lightSystem, integer groupIndex, boolean isActive, )

**Arguments**

| table   | lightSystem | lightSystem object |
|---------|-------------|--------------------|
| integer | groupIndex  | index of group     |
| boolean | isActive    | is active          |
| any     | noEventSend |                    |

**Code**

```lua
function PlaceableLightsStateEvent.sendEvent(placeable, groupIndex, isActive, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlaceableLightsStateEvent.new(placeable, groupIndex, isActive), nil , nil , placeable)
        else
                g_client:getServerConnection():sendEvent( PlaceableLightsStateEvent.new(placeable, groupIndex, isActive))
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
function PlaceableLightsStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.placeable)
    streamWriteUIntN(streamId, self.groupIndex, PlaceableLights.MAX_NUM_BITS)
    streamWriteBool(streamId, self.isActive)
end

```