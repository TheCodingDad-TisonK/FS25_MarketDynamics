## ProductionPointProductionStateEvent

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
function ProductionPointProductionStateEvent.emptyNew()
    local self = Event.new( ProductionPointProductionStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new()

**Arguments**

| any | productionPoint |
|-----|-----------------|
| any | productionId    |
| any | isEnabled       |

**Code**

```lua
function ProductionPointProductionStateEvent.new(productionPoint, productionId, isEnabled)
    local self = ProductionPointProductionStateEvent.emptyNew()
    self.productionPoint = productionPoint
    self.productionId = productionId
    self.isEnabled = isEnabled
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
function ProductionPointProductionStateEvent:readStream(streamId, connection)
    self.productionPoint = NetworkUtil.readNodeObject(streamId)
    self.productionId = streamReadString(streamId)
    self.isEnabled = streamReadBool(streamId)
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
function ProductionPointProductionStateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection)
    end

    if self.productionPoint ~ = nil then
        self.productionPoint:setProductionState( self.productionId, self.isEnabled, true )
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
| any | productionId    |
| any | isEnabled       |
| any | noEventSend     |

**Code**

```lua
function ProductionPointProductionStateEvent.sendEvent(productionPoint, productionId, isEnabled, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( ProductionPointProductionStateEvent.new(productionPoint, productionId, isEnabled))
        else
                g_client:getServerConnection():sendEvent( ProductionPointProductionStateEvent.new(productionPoint, productionId, isEnabled))
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
function ProductionPointProductionStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.productionPoint)
    streamWriteString(streamId, self.productionId)
    streamWriteBool(streamId, self.isEnabled)
end

```