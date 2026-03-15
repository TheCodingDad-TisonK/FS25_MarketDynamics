## ProductionPointOutputModeEvent

**Description**

> Event for production point output mode changes

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
function ProductionPointOutputModeEvent.emptyNew()
    local self = Event.new( ProductionPointOutputModeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new()

**Arguments**

| any | productionPoint  |
|-----|------------------|
| any | outputFillTypeId |
| any | outputMode       |

**Code**

```lua
function ProductionPointOutputModeEvent.new(productionPoint, outputFillTypeId, outputMode)
    local self = ProductionPointOutputModeEvent.emptyNew()
    self.productionPoint = productionPoint
    self.outputFillTypeId = outputFillTypeId
    self.outputMode = outputMode
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
function ProductionPointOutputModeEvent:readStream(streamId, connection)
    self.productionPoint = NetworkUtil.readNodeObject(streamId)
    self.outputFillTypeId = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
    self.outputMode = streamReadUIntN(streamId, ProductionPoint.OUTPUT_MODE_NUM_BITS)
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
function ProductionPointOutputModeEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection)
    end

    if self.productionPoint ~ = nil then
        self.productionPoint:setOutputDistributionMode( self.outputFillTypeId, self.outputMode, true )
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

| any | productionPoint  |
|-----|------------------|
| any | outputFillTypeId |
| any | outputMode       |
| any | noEventSend      |

**Code**

```lua
function ProductionPointOutputModeEvent.sendEvent(productionPoint, outputFillTypeId, outputMode, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( ProductionPointOutputModeEvent.new(productionPoint, outputFillTypeId, outputMode))
        else
                g_client:getServerConnection():sendEvent( ProductionPointOutputModeEvent.new(productionPoint, outputFillTypeId, outputMode))
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
function ProductionPointOutputModeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.productionPoint)
    streamWriteUIntN(streamId, self.outputFillTypeId, FillTypeManager.SEND_NUM_BITS)
    streamWriteUIntN(streamId, self.outputMode, ProductionPoint.OUTPUT_MODE_NUM_BITS)
end

```