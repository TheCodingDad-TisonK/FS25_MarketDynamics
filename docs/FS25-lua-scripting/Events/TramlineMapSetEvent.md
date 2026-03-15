## TramlineMapSetEvent

**Description**

> Event for syncing the tramline settings from client to server

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
function TramlineMapSetEvent.emptyNew()
    local self = Event.new( TramlineMapSetEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, , , , )

**Arguments**

| table | object        | object |
|-------|---------------|--------|
| any   | workingWidth  |        |
| any   | workDirection |        |
| any   | spacing       |        |
| any   | clearFruit    |        |

**Code**

```lua
function TramlineMapSetEvent.new(farmlandId, workingWidth, workDirection, spacing, clearFruit)
    local self = TramlineMapSetEvent.emptyNew()
    self.farmlandId = farmlandId
    self.workingWidth = workingWidth
    self.workDirection = workDirection
    self.spacing = spacing
    self.clearFruit = clearFruit

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
function TramlineMapSetEvent:readStream(streamId, connection)
    self.farmlandId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
    self.workingWidth = streamReadFloat32(streamId)
    self.workDirection = streamReadFloat32(streamId)
    self.spacing = streamReadFloat32(streamId)
    self.clearFruit = streamReadBool(streamId)

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
function TramlineMapSetEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, nil )
    end

    if g_precisionFarming ~ = nil then
        if g_precisionFarming.tramlineMap ~ = nil then
            g_precisionFarming.tramlineMap:setFarmlandTramlines( self.farmlandId, self.workingWidth, self.workDirection, self.spacing, self.clearFruit, true )
        end
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean noEventSend, , , , )

**Arguments**

| table   | object        | object        |
|---------|---------------|---------------|
| boolean | noEventSend   | no event send |
| any     | workDirection |               |
| any     | spacing       |               |
| any     | clearFruit    |               |
| any     | noEventSend   |               |

**Code**

```lua
function TramlineMapSetEvent.sendEvent(farmlandId, workingWidth, workDirection, spacing, clearFruit, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( TramlineMapSetEvent.new(farmlandId, workingWidth, workDirection, spacing, clearFruit), nil , nil , nil )
        else
                g_client:getServerConnection():sendEvent( TramlineMapSetEvent.new(farmlandId, workingWidth, workDirection, spacing, clearFruit))
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
function TramlineMapSetEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmlandId, g_farmlandManager.numberOfBits)
    streamWriteFloat32(streamId, self.workingWidth)
    streamWriteFloat32(streamId, self.workDirection)
    streamWriteFloat32(streamId, self.spacing)
    streamWriteBool(streamId, self.clearFruit)
end

```