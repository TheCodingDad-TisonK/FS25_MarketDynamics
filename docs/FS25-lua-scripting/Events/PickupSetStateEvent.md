## PickupSetStateEvent

**Description**

> Event for lower and lift pickup

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
function PickupSetStateEvent.emptyNew()
    local self = Event.new( PickupSetStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isPickupLowered)

**Arguments**

| table   | object          | object            |
|---------|-----------------|-------------------|
| boolean | isPickupLowered | is pickup lowered |

**Code**

```lua
function PickupSetStateEvent.new(object, isPickupLowered)
    local self = PickupSetStateEvent.emptyNew()
    self.object = object
    self.isPickupLowered = isPickupLowered
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
function PickupSetStateEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.isPickupLowered = streamReadBool(streamId)
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
function PickupSetStateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPickupState( self.isPickupLowered, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isPickupLowered, boolean noEventSend)

**Arguments**

| table   | vehicle         | vehicle           |
|---------|-----------------|-------------------|
| boolean | isPickupLowered | is pickup lowered |
| boolean | noEventSend     | no event send     |

**Code**

```lua
function PickupSetStateEvent.sendEvent(vehicle, isPickupLowered, noEventSend)
    if isPickupLowered ~ = vehicle.spec_pickup.isLowered then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( PickupSetStateEvent.new(vehicle, isPickupLowered), nil , nil , vehicle)
            else
                    g_client:getServerConnection():sendEvent( PickupSetStateEvent.new(vehicle, isPickupLowered))
                end
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
function PickupSetStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.isPickupLowered)
end

```