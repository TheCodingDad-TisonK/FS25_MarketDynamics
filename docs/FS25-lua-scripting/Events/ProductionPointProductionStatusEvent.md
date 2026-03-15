## ProductionPointProductionStatusEvent

**Description**

> Event for production point production state change

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
function ProductionPointProductionStatusEvent.emptyNew()
    local self = Event.new( ProductionPointProductionStatusEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(ProductionPoint productionPoint, integer productionIndex, integer status)

**Arguments**

| ProductionPoint | productionPoint |
|-----------------|-----------------|
| integer         | productionIndex |
| integer         | status          |

**Return Values**

| integer | self |
|---------|------|

**Code**

```lua
function ProductionPointProductionStatusEvent.new(productionPoint, productionIndex, status )
    local self = ProductionPointProductionStatusEvent.emptyNew()
    self.productionPoint = productionPoint
    self.productionIndex = productionIndex
    self.status = status
    return self
end

```

### readStream

**Description**

> Called on client side on join

**Definition**

> readStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function ProductionPointProductionStatusEvent:readStream(streamId, connection)
    self.productionPoint = NetworkUtil.readNodeObject(streamId)
    self.productionIndex = streamReadUInt8(streamId)
    self.status = streamReadUIntN(streamId, ProductionPoint.PROD_STATUS_NUM_BITS)
    self:run(connection)
end

```

### run

**Description**

> Run action on receiving side

**Definition**

> run()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function ProductionPointProductionStatusEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection)
    end

    if self.productionPoint ~ = nil then
        local production = self.productionPoint.productions[ self.productionIndex]
        self.productionPoint:setProductionStatus(production.id, self.status , true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent()

**Arguments**

| any | productionPoint |
|-----|-----------------|
| any | productionIndex |
| any | status          |
| any | noEventSend     |

**Code**

```lua
function ProductionPointProductionStatusEvent.sendEvent(productionPoint, productionIndex, status , noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( ProductionPointProductionStatusEvent.new(productionPoint, productionIndex, status ))
        else
                g_client:getServerConnection():sendEvent( ProductionPointProductionStatusEvent.new(productionPoint, productionIndex, status ))
            end
        end
    end

```

### writeStream

**Description**

> Called on server side on join

**Definition**

> writeStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function ProductionPointProductionStatusEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.productionPoint)
    streamWriteUInt8(streamId, self.productionIndex)
    streamWriteUIntN(streamId, self.status , ProductionPoint.PROD_STATUS_NUM_BITS)
end

```