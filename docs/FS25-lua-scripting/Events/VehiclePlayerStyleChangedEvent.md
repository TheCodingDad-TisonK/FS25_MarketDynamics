## VehiclePlayerStyleChangedEvent

**Description**

> Event for enter request

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
function VehiclePlayerStyleChangedEvent.emptyNew()
    local self = Event.new( VehiclePlayerStyleChangedEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, table playerStyle)

**Arguments**

| table | vehicle     | vehicle |
|-------|-------------|---------|
| table | playerStyle | info    |

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function VehiclePlayerStyleChangedEvent.new(vehicle, playerStyle)
    local self = VehiclePlayerStyleChangedEvent.emptyNew()

    self.vehicle = vehicle
    self.playerStyle = playerStyle

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
function VehiclePlayerStyleChangedEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)

    self.playerStyle = PlayerStyle.new()
    self.playerStyle:readStream(streamId, connection)

    -- only do on client
        if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
            self.vehicle:setVehicleCharacter( self.playerStyle)
        end
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
function VehiclePlayerStyleChangedEvent:run(connection)
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
function VehiclePlayerStyleChangedEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    self.playerStyle:writeStream(streamId, connection)
end

```