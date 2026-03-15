## TramlineMapInitialEvent

**Description**

> Event for syncing the tramline settings from server to client on join

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
- [run](#run)
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
function TramlineMapInitialEvent.emptyNew()
    local self = Event.new( TramlineMapInitialEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Code**

```lua
function TramlineMapInitialEvent.new(farmlandTramlineStates)
    local self = TramlineMapInitialEvent.emptyNew()
    self.farmlandTramlineStates = farmlandTramlineStates

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
function TramlineMapInitialEvent:readStream(streamId, connection)
    self.farmlandTramlineStates = { }

    local numFarmlandsToReceive = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
    for i = 1 , numFarmlandsToReceive do
        local farmlandId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)

        local state = { }
        state.workingWidth = streamReadFloat32(streamId)
        state.workDirection = streamReadFloat32(streamId)
        state.spacing = streamReadFloat32(streamId)
        self.farmlandTramlineStates[farmlandId] = state
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
function TramlineMapInitialEvent:run(connection)
    if g_precisionFarming ~ = nil then
        if g_precisionFarming.tramlineMap ~ = nil then
            g_precisionFarming.tramlineMap.farmlandTramlineStates = self.farmlandTramlineStates
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
function TramlineMapInitialEvent:writeStream(streamId, connection)
    local numFarmlandsToSend = table.size( self.farmlandTramlineStates)
    streamWriteUIntN(streamId, numFarmlandsToSend, g_farmlandManager.numberOfBits)

    for farmlandId, state in pairs( self.farmlandTramlineStates) do
        streamWriteUIntN(streamId, farmlandId, g_farmlandManager.numberOfBits)
        streamWriteFloat32(streamId, state.workingWidth)
        streamWriteFloat32(streamId, state.workDirection)
        streamWriteFloat32(streamId, state.spacing)
    end
end

```