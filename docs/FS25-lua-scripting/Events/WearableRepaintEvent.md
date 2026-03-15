## WearableRepaintEvent

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
function WearableRepaintEvent.emptyNew()
    return Event.new( WearableRepaintEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle)

**Arguments**

| table | vehicle | vehicle |
|-------|---------|---------|

**Code**

```lua
function WearableRepaintEvent.new(vehicle)
    local self = WearableRepaintEvent.emptyNew()
    self.vehicle = vehicle
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
function WearableRepaintEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
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
function WearableRepaintEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        if self.vehicle.repaintVehicle ~ = nil then
            self.vehicle:repaintVehicle()

            if not connection:getIsServer() then
                g_server:broadcastEvent( self ) -- broadcast for UI updates
                end

                g_messageCenter:publish(MessageType.VEHICLE_REPAINTED, self.vehicle)
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
function WearableRepaintEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

```