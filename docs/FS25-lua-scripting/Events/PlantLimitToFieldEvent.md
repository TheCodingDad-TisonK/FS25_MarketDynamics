## PlantLimitToFieldEvent

**Description**

> Event for limit to field state

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
function PlantLimitToFieldEvent.emptyNew()
    local self = Event.new( PlantLimitToFieldEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean plantLimitToField)

**Arguments**

| table   | object            | object                    |
|---------|-------------------|---------------------------|
| boolean | plantLimitToField | plant is limited to field |

**Code**

```lua
function PlantLimitToFieldEvent.new(object, plantLimitToField)
    local self = PlantLimitToFieldEvent.emptyNew()
    self.object = object
    self.plantLimitToField = plantLimitToField
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
function PlantLimitToFieldEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.plantLimitToField = streamReadBool(streamId)
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
function PlantLimitToFieldEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPlantLimitToField( self.plantLimitToField, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( PlantLimitToFieldEvent.new( self.object, self.plantLimitToField), nil , connection, self.object)
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
function PlantLimitToFieldEvent.sendEvent(vehicle, plantLimitToField, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlantLimitToFieldEvent.new(vehicle, plantLimitToField), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( PlantLimitToFieldEvent.new(vehicle, plantLimitToField))
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
function PlantLimitToFieldEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.plantLimitToField)
end

```