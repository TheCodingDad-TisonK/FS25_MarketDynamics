## ExtendedSprayerDefaultFruitTypeEvent

**Description**

> Event for sync of spray amount and automatic state

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
function ExtendedSprayerDefaultFruitTypeEvent.emptyNew()
    local self = Event.new( ExtendedSprayerDefaultFruitTypeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer fruitRequirementIndex)

**Arguments**

| table   | object                | object                |
|---------|-----------------------|-----------------------|
| integer | fruitRequirementIndex | fruitRequirementIndex |

**Code**

```lua
function ExtendedSprayerDefaultFruitTypeEvent.new(object, fruitRequirementIndex)
    local self = ExtendedSprayerDefaultFruitTypeEvent.emptyNew()
    self.object = object
    self.fruitRequirementIndex = fruitRequirementIndex
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
function ExtendedSprayerDefaultFruitTypeEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.fruitRequirementIndex = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)

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
function ExtendedSprayerDefaultFruitTypeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setSprayAmountDefaultFruitRequirementIndex( self.fruitRequirementIndex, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean noEventSend, )

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | noEventSend | no event send |
| any     | noEventSend |               |

**Code**

```lua
function ExtendedSprayerDefaultFruitTypeEvent.sendEvent(object, fruitRequirementIndex, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( ExtendedSprayerDefaultFruitTypeEvent.new(object, fruitRequirementIndex), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( ExtendedSprayerDefaultFruitTypeEvent.new(object, fruitRequirementIndex))
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
function ExtendedSprayerDefaultFruitTypeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteUIntN(streamId, self.fruitRequirementIndex, FruitTypeManager.SEND_NUM_BITS)
end

```