## ResetYieldMapEvent

**Description**

> Event for syncing the farmland stats to the player

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
function ResetYieldMapEvent.emptyNew()
    local self = Event.new( ResetYieldMapEvent _mt)
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
function ResetYieldMapEvent.new(farmlandId)
    local self = ResetYieldMapEvent.emptyNew()
    self.farmlandId = farmlandId
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
function ResetYieldMapEvent:readStream(streamId, connection)
    self.farmlandId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
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
function ResetYieldMapEvent:run(connection)
    if not connection:getIsServer() then
        if g_precisionFarming ~ = nil then
            if g_precisionFarming.yieldMap ~ = nil then
                g_precisionFarming.yieldMap:resetFarmlandYieldArea( self.farmlandId)
                g_precisionFarming:updatePrecisionFarmingOverlays()
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
function ResetYieldMapEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmlandId, g_farmlandManager.numberOfBits)
end

```