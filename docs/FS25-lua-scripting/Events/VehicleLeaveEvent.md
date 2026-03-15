## VehicleLeaveEvent

**Description**

> Event for leaving

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
function VehicleLeaveEvent.emptyNew()
    local self = Event.new( VehicleLeaveEvent _mt, NetworkNode.CHANNEL_MAIN)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle | vehicle |
|-------|---------|---------|
| any   | userId  |         |

**Return Values**

| any | instance | instance of event |
|-----|----------|-------------------|

**Code**

```lua
function VehicleLeaveEvent.new(vehicle, userId)
    local self = VehicleLeaveEvent.emptyNew()
    self.vehicle = vehicle
    self.userId = userId
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
function VehicleLeaveEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.userId = User.streamReadUserId(streamId)
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
function VehicleLeaveEvent:run(connection)

    -- If the vehicle is not yet ready, do nothing.
        if self.vehicle = = nil or not self.vehicle:getIsSynchronized() then
            Logging.devInfo( "VehicleLeaveEvent.run:Vehicle not found or not synchronized yet" )
            return
        end

        -- If this is the server, handle setting the owner.
        if not connection:getIsServer() then

            -- If the vehicle has an owner, unset it.
            if self.vehicle:getOwnerConnection() ~ = nil then
                self.vehicle:setOwnerConnection( nil )
                self.vehicle.controllerFarmId = nil
            end

            -- Fire the leave event on all clients except the one who left the vehicle.
            g_server:broadcastEvent( VehicleLeaveEvent.new( self.vehicle, self.userId), nil , connection, self.vehicle)
        end

        local player = g_currentMission.playerSystem:getPlayerByUserId( self.userId)
        if player ~ = nil then
            player:leaveVehicle( self.vehicle, true )
        end
    end

```

### sendEvent

**Description**

**Definition**

> sendEvent()

**Arguments**

| any | vehicle     |
|-----|-------------|
| any | userId      |
| any | noEventSend |

**Code**

```lua
function VehicleLeaveEvent.sendEvent(vehicle, userId, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( VehicleLeaveEvent.new(vehicle, userId), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( VehicleLeaveEvent.new(vehicle, userId))
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
function VehicleLeaveEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    User.streamWriteUserId(streamId, self.userId)
end

```