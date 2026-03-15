## WaterTrailerSetIsFillingEvent

**Description**

> Event for water trailer filling

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
function WaterTrailerSetIsFillingEvent.emptyNew()
    local self = Event.new( WaterTrailerSetIsFillingEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isFilling)

**Arguments**

| table   | vehicle   | vehicle    |
|---------|-----------|------------|
| boolean | isFilling | is filling |

**Code**

```lua
function WaterTrailerSetIsFillingEvent.new(vehicle, isFilling)
    local self = WaterTrailerSetIsFillingEvent.emptyNew()
    self.vehicle = vehicle
    self.isFilling = isFilling
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
function WaterTrailerSetIsFillingEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.isFilling = streamReadBool(streamId)
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
function WaterTrailerSetIsFillingEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.vehicle)
    end

    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setIsWaterTrailerFilling( self.isFilling, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isFilling, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle       |
|---------|-------------|---------------|
| boolean | isFilling   | is filling    |
| boolean | noEventSend | no event send |

**Code**

```lua
function WaterTrailerSetIsFillingEvent.sendEvent(vehicle, isFilling, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( WaterTrailerSetIsFillingEvent.new(vehicle, isFilling), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( WaterTrailerSetIsFillingEvent.new(vehicle, isFilling))
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
function WaterTrailerSetIsFillingEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.isFilling)
end

```