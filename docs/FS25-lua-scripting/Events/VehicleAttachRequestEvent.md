## VehicleAttachRequestEvent

**Description**

> Event for request attaching

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
function VehicleAttachRequestEvent.emptyNew()
    return Event.new( VehicleAttachRequestEvent _mt)
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table info)

**Arguments**

| table | info | attach info [attacherVehicle, attachable, attacherVehicleJointDescIndex, attachableJointDescIndex] |
|-------|------|----------------------------------------------------------------------------------------------------|

**Return Values**

| table | instance | instance of event |
|-------|----------|-------------------|

**Code**

```lua
function VehicleAttachRequestEvent.new(info)
    local self = VehicleAttachRequestEvent.emptyNew()
    self.attacherVehicle = info.attacherVehicle
    self.attachable = info.attachable
    self.attacherVehicleJointDescIndex = info.attacherVehicleJointDescIndex
    self.attachableJointDescIndex = info.attachableJointDescIndex
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
function VehicleAttachRequestEvent:readStream(streamId, connection)
    self.attacherVehicle = NetworkUtil.readNodeObject(streamId)
    self.attachable = NetworkUtil.readNodeObject(streamId)
    self.attacherVehicleJointDescIndex = streamReadUIntN(streamId, 7 )
    self.attachableJointDescIndex = streamReadUIntN(streamId, 7 )
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
function VehicleAttachRequestEvent:run(connection)
    if not connection:getIsServer() then
        if self.attacherVehicle ~ = nil and self.attacherVehicle:getIsSynchronized() then
            self.attacherVehicle:attachImplementFromInfo( self )
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
function VehicleAttachRequestEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.attacherVehicle)
    NetworkUtil.writeNodeObject(streamId, self.attachable)
    streamWriteUIntN(streamId, self.attacherVehicleJointDescIndex, 7 )
    streamWriteUIntN(streamId, self.attachableJointDescIndex, 7 )
end

```