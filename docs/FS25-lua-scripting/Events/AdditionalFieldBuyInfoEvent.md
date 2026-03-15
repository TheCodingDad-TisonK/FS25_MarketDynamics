## AdditionalFieldBuyInfoEvent

**Description**

> Event for syncing the field buy info to the player

**Parent**

> [Event](?version=script&category=&class=)

**Functions**

- [emptyNew](#emptynew)
- [new](#new)
- [readStream](#readstream)
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
function AdditionalFieldBuyInfoEvent.emptyNew()
    local self = Event.new( AdditionalFieldBuyInfoEvent _mt)
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
function AdditionalFieldBuyInfoEvent.new(farmlandId)
    local self = AdditionalFieldBuyInfoEvent.emptyNew()
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
function AdditionalFieldBuyInfoEvent:readStream(streamId, connection)
    self.farmlandId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)

    local pfModule = g_precisionFarming
    if pfModule ~ = nil then
        if pfModule.additionalFieldBuyInfo ~ = nil then
            pfModule.additionalFieldBuyInfo:readInfoFromStream( self.farmlandId, streamId, connection)
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
function AdditionalFieldBuyInfoEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.farmlandId, g_farmlandManager.numberOfBits)

    local pfModule = g_precisionFarming
    if pfModule ~ = nil then
        if pfModule.additionalFieldBuyInfo ~ = nil then
            pfModule.additionalFieldBuyInfo:writeInfoToStream( self.farmlandId, streamId, connection)
        end
    end
end

```