## PlaceableTrainSystemRentEvent

**Description**

> Event for ai start

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
function PlaceableTrainSystemRentEvent.emptyNew()
    local self = Event.new( PlaceableTrainSystemRentEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object, integer reason, boolean isStarted, integer helper)

**Arguments**

| table   | object    | object     |
|---------|-----------|------------|
| integer | reason    | reason     |
| boolean | isStarted | is started |
| integer | helper    | helper id  |

**Code**

```lua
function PlaceableTrainSystemRentEvent.new(object, isRented, farmId, splinePosition)
    local self = PlaceableTrainSystemRentEvent.emptyNew()
    self.object = object
    self.isRented = isRented
    self.farmId = farmId
    self.splinePosition = splinePosition
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
function PlaceableTrainSystemRentEvent:readStream(streamId, connection)
    self.object = NetworkUtil.readNodeObject(streamId)
    self.isRented = streamReadBool(streamId)

    if self.isRented then
        self.farmId = streamReadUIntN(streamId, FarmManager.FARM_ID_SEND_NUM_BITS)
        self.splinePosition = streamReadFloat32(streamId)
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
function PlaceableTrainSystemRentEvent:run(connection)
    local farmId, splinePosition
    if self.isRented then
        farmId = self.farmId
        splinePosition = self.splinePosition
    end

    if self.object ~ = nil and self.object:getIsSynchronized() then
        if self.isRented then
            self.object:rentRailroad(farmId, splinePosition, true )
        else
                self.object:returnRailroad( true )
            end
        end

        if not connection:getIsServer() then
            g_server:broadcastEvent( PlaceableTrainSystemRentEvent.new( self.object, self.isRented, self.farmId, self.splinePosition), nil , connection, self.object)
        end
    end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isSwathActive, boolean noEventSend, , )

**Arguments**

| table   | vehicle        | vehicle          |
|---------|----------------|------------------|
| boolean | isSwathActive  | is straw enabled |
| boolean | noEventSend    | no event send    |
| any     | splinePosition |                  |
| any     | noEventSend    |                  |

**Code**

```lua
function PlaceableTrainSystemRentEvent.sendEvent(object, isRented, farmId, splinePosition, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PlaceableTrainSystemRentEvent.new(object, isRented, farmId, splinePosition), nil , nil , object)
        else
                g_client:getServerConnection():sendEvent( PlaceableTrainSystemRentEvent.new(object, isRented, farmId, splinePosition))
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
function PlaceableTrainSystemRentEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.object)
    if streamWriteBool(streamId, self.isRented) then
        streamWriteUIntN(streamId, self.farmId, FarmManager.FARM_ID_SEND_NUM_BITS)
        streamWriteFloat32(streamId, self.splinePosition)
    end
end

```