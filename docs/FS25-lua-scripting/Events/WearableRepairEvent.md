## WearableRepairEvent

**Description**

> Event for repairing

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
function WearableRepairEvent.emptyNew()
    return Event.new( WearableRepairEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle        | vehicle |
|-------|----------------|---------|
| any   | atSellingPoint |         |

**Code**

```lua
function WearableRepairEvent.new(vehicle, atSellingPoint)
    local self = WearableRepairEvent.emptyNew()
    self.vehicle = vehicle
    self.atSellingPoint = atSellingPoint
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
function WearableRepairEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.atSellingPoint = streamReadBool(streamId)
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
function WearableRepairEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        if self.vehicle.repairVehicle ~ = nil then
            self.vehicle:repairVehicle( self.atSellingPoint)

            if not connection:getIsServer() then
                g_server:broadcastEvent( self ) -- broadcast for UI updates
                end

                g_messageCenter:publish(MessageType.VEHICLE_REPAIRED, self.vehicle, self.atSellingPoint)
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
function WearableRepairEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteBool(streamId, self.atSellingPoint)
end

```