## ExtendedSowingMachineRateEvent

**Description**

> Event for sync of seed rate

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
function ExtendedSowingMachineRateEvent.emptyNew()
    local self = Event.new( ExtendedSowingMachineRateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, boolean automaticMode, integer manualValue)

**Arguments**

| table   | object        | object        |
|---------|---------------|---------------|
| boolean | automaticMode | automaticMode |
| integer | manualValue   | manualValue   |

**Code**

```lua
function ExtendedSowingMachineRateEvent.new(object, automaticMode, manualValue)
    local self = ExtendedSowingMachineRateEvent.emptyNew()
    self.object = object
    self.automaticMode = automaticMode
    self.manualValue = manualValue
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
function ExtendedSowingMachineRateEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.automaticMode = streamReadBool(streamId)
    if not self.automaticMode then
        self.manualValue = streamReadUIntN(streamId, 2 )
    end

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
function ExtendedSowingMachineRateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.object)
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        self.object:setSeedRateAutoMode( self.automaticMode, true )
        if not self.automaticMode then
            self.object:setManualSeedRate( self.manualValue, true )
        end
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean noEventSend, , )

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | noEventSend | no event send |
| any     | manualValue |               |
| any     | noEventSend |               |

**Code**

```lua
function ExtendedSowingMachineRateEvent.sendEvent(object, automaticMode, manualValue, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( ExtendedSowingMachineRateEvent.new(object, automaticMode, manualValue), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( ExtendedSowingMachineRateEvent.new(object, automaticMode, manualValue))
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
function ExtendedSowingMachineRateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    if not streamWriteBool(streamId, self.automaticMode) then
        streamWriteUIntN(streamId, self.manualValue, 2 )
    end
end

```