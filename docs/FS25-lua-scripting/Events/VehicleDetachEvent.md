## VehicleDetachEvent

**Description**

> Event for detaching

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
function VehicleDetachEvent.emptyNew()
    local self = Event.new( VehicleDetachEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, table implement)

**Arguments**

| table | vehicle   | vehicle   |
|-------|-----------|-----------|
| table | implement | implement |

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function VehicleDetachEvent.new(vehicle, implement)
    local self = VehicleDetachEvent.emptyNew()
    self.implement = implement
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
function VehicleDetachEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.implement = NetworkUtil.readNodeObject(streamId)

    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        if connection:getIsServer() then
            self.vehicle:detachImplementByObject( self.implement, true )
        else
                self.vehicle:detachImplementByObject( self.implement)
            end
        end
    end

```

### run

**Description**

**Definition**

> run()

**Arguments**

| any | connection |
|-----|------------|

**Code**

```lua
function VehicleDetachEvent:run(connection)
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
function VehicleDetachEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    NetworkUtil.writeNodeObject(streamId, self.implement)
end

```