## SetPipeDischargeToGroundEvent

**Description**

> Event for pipe discharge to ground state

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
function SetPipeDischargeToGroundEvent.emptyNew()
    local self = Event.new( SetPipeDischargeToGroundEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean dischargeState)

**Arguments**

| table   | object         | object                    |
|---------|----------------|---------------------------|
| boolean | dischargeState | discharge to ground state |

**Code**

```lua
function SetPipeDischargeToGroundEvent.new(object, dischargeState)
    local self = SetPipeDischargeToGroundEvent.emptyNew()
    self.object = object
    self.dischargeState = dischargeState
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
function SetPipeDischargeToGroundEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.dischargeState = streamReadBool(streamId)
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
function SetPipeDischargeToGroundEvent:run(connection)
    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setPipeDischargeToGround( self.dischargeState, true )
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( SetPipeDischargeToGroundEvent.new( self.object, self.dischargeState), nil , connection, self.object)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean dischargeState, boolean noEventSend)

**Arguments**

| table   | object         | object                    |
|---------|----------------|---------------------------|
| boolean | dischargeState | discharge to ground state |
| boolean | noEventSend    | no event send             |

**Code**

```lua
function SetPipeDischargeToGroundEvent.sendEvent(object, dischargeState, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SetPipeDischargeToGroundEvent.new(object, dischargeState), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( SetPipeDischargeToGroundEvent.new(object, dischargeState))
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
function SetPipeDischargeToGroundEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    streamWriteBool(streamId, self.dischargeState)
end

```