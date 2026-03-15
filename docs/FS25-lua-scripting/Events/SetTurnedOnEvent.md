## SetTurnedOnEvent

**Description**

> Event for turned on state

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
function SetTurnedOnEvent.emptyNew()
    local self = Event.new( SetTurnedOnEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean isTurnedOn)

**Arguments**

| table   | object     | object             |
|---------|------------|--------------------|
| boolean | isTurnedOn | is turned on state |

**Code**

```lua
function SetTurnedOnEvent.new(object, isTurnedOn)
    local self = SetTurnedOnEvent.emptyNew()
    self.object = object
    self.isTurnedOn = isTurnedOn
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
function SetTurnedOnEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.isTurnedOn = streamReadBool(streamId)
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
function SetTurnedOnEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setIsTurnedOn( self.isTurnedOn, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean isTurnedOn, boolean noEventSend)

**Arguments**

| table   | object      | object             |
|---------|-------------|--------------------|
| boolean | isTurnedOn  | is turned on state |
| boolean | noEventSend | no event send      |

**Code**

```lua
function SetTurnedOnEvent.sendEvent(vehicle, isTurnedOn, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SetTurnedOnEvent.new(vehicle, isTurnedOn), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( SetTurnedOnEvent.new(vehicle, isTurnedOn))
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
function SetTurnedOnEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.isTurnedOn)
end

```