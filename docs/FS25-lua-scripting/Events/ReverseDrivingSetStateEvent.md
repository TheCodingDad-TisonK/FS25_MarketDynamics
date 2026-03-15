## ReverseDrivingSetStateEvent

**Description**

> Event for reverse driving state

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
function ReverseDrivingSetStateEvent.emptyNew()
    local self = Event.new( ReverseDrivingSetStateEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isReverseDriving)

**Arguments**

| table   | vehicle          | vehicle            |
|---------|------------------|--------------------|
| boolean | isReverseDriving | is reverse driving |

**Code**

```lua
function ReverseDrivingSetStateEvent.new(vehicle, isReverseDriving)
    local self = ReverseDrivingSetStateEvent.emptyNew()
    self.vehicle = vehicle
    self.isReverseDriving = isReverseDriving
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
function ReverseDrivingSetStateEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.isReverseDriving = streamReadBool(streamId)
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
function ReverseDrivingSetStateEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, self.vehicle)
    end

    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setIsReverseDriving( self.isReverseDriving, true )
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, boolean isReverseDriving, boolean noEventSend)

**Arguments**

| table   | vehicle          | vehicle            |
|---------|------------------|--------------------|
| boolean | isReverseDriving | is reverse driving |
| boolean | noEventSend      | no event send      |

**Code**

```lua
function ReverseDrivingSetStateEvent.sendEvent(vehicle, isReverseDriving, noEventSend)
    if isReverseDriving ~ = vehicle.isReverseDriving then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( ReverseDrivingSetStateEvent.new(vehicle, isReverseDriving), nil , nil , vehicle)
            else
                    g_client:getServerConnection():sendEvent( ReverseDrivingSetStateEvent.new(vehicle, isReverseDriving))
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
function ReverseDrivingSetStateEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.isReverseDriving)
end

```