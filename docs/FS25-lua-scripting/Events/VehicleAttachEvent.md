## VehicleAttachEvent

**Description**

> Event for attaching

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
function VehicleAttachEvent.emptyNew()
    local self = Event.new( VehicleAttachEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, table implement, integer inputJointIndex, integer jointIndex, boolean startLowered)

**Arguments**

| table   | vehicle         | vehicle                       |
|---------|-----------------|-------------------------------|
| table   | implement       | implement                     |
| integer | inputJointIndex | index of input attacher joint |
| integer | jointIndex      | index of attacher joint       |
| boolean | startLowered    | start in lowered state        |

**Return Values**

| boolean | instance | instance of event |
|---------|----------|-------------------|

**Code**

```lua
function VehicleAttachEvent.new(vehicle, implement, inputJointIndex, jointIndex, startLowered)
    local self = VehicleAttachEvent.emptyNew()
    self.jointIndex = jointIndex
    self.inputJointIndex = inputJointIndex
    self.vehicle = vehicle
    self.implement = implement
    self.startLowered = startLowered
    assert( self.jointIndex > = 0 and self.jointIndex < 127 )
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
function VehicleAttachEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.implement = NetworkUtil.readNodeObject(streamId)
    self.jointIndex = streamReadUIntN(streamId, 7 )
    self.inputJointIndex = streamReadUIntN(streamId, 7 )
    self.startLowered = streamReadBool(streamId)
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
function VehicleAttachEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        if self.implement = = nil then
            Logging.error( "Failed to attach unknown implement to vehicle '%s' between joints '%d' and '%d'" , self.vehicle.configFileName, self.jointIndex, self.inputJointIndex)
            return
        end

        self.vehicle:attachImplement( self.implement, self.inputJointIndex, self.jointIndex, true , nil , self.startLowered)
    end
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , nil , connection, self.object)
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
function VehicleAttachEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    NetworkUtil.writeNodeObject(streamId, self.implement)
    streamWriteUIntN(streamId, self.jointIndex, 7 )
    streamWriteUIntN(streamId, self.inputJointIndex, 7 )
    streamWriteBool(streamId, self.startLowered)
end

```