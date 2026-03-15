## TrailerToggleManualTipEvent

**Description**

> Event for toggle manual trailer tipping

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
function TrailerToggleManualTipEvent.emptyNew()
    local self = Event.new( TrailerToggleManualTipEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean state)

**Arguments**

| table   | object | object |
|---------|--------|--------|
| boolean | state  | state  |

**Return Values**

| boolean | self |
|---------|------|

**Code**

```lua
function TrailerToggleManualTipEvent.new(object, state)
    local self = TrailerToggleManualTipEvent.emptyNew()
    self.object = object
    self.state = state
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
function TrailerToggleManualTipEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.state = streamReadBool(streamId)

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
function TrailerToggleManualTipEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        if self.state then
            self.object:startTipping( nil , true )
        else
                self.object:stopTipping( true )
            end
        end
    end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean state, boolean? noEventSend)

**Arguments**

| table    | vehicle     | vehicle        |
|----------|-------------|----------------|
| boolean  | state       | belt is active |
| boolean? | noEventSend | no event send  |

**Code**

```lua
function TrailerToggleManualTipEvent.sendEvent(vehicle, state, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TrailerToggleManualTipEvent.new(vehicle, state), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( TrailerToggleManualTipEvent.new(vehicle, state))
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
function TrailerToggleManualTipEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.state)
end

```