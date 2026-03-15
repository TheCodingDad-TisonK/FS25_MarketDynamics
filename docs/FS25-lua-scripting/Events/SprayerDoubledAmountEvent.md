## SprayerDoubledAmountEvent

**Description**

> Event for sprayer doubled amount state

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
function SprayerDoubledAmountEvent.emptyNew()
    local self = Event.new( SprayerDoubledAmountEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer isActive)

**Arguments**

| table   | object   | object     |
|---------|----------|------------|
| integer | isActive | pipe state |

**Code**

```lua
function SprayerDoubledAmountEvent.new(object, isActive)
    local self = SprayerDoubledAmountEvent.emptyNew()
    self.object = object
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
function SprayerDoubledAmountEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
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
function SprayerDoubledAmountEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setSprayerDoubledAmountActive( self.isActive, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( SprayerDoubledAmountEvent.new( self.object, self.isActive), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean isActive, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | isActive    | is active     |
| boolean | noEventSend | no event send |

**Code**

```lua
function SprayerDoubledAmountEvent.sendEvent(vehicle, isActive, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SprayerDoubledAmountEvent.new(vehicle, isActive), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( SprayerDoubledAmountEvent.new(vehicle, isActive))
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
function SprayerDoubledAmountEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.isActive)
end

```