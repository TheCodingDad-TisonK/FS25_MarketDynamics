## AIAutomaticSteeringRequestEvent

**Description**

> Event from client to server to request a field course with the given settings from the server

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
function AIAutomaticSteeringRequestEvent.emptyNew()
    local self = Event.new( AIAutomaticSteeringRequestEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer currentAngle, , )

**Arguments**

| table   | vehicle             | vehicle       |
|---------|---------------------|---------------|
| integer | currentAngle        | current angle |
| any     | z                   |               |
| any     | fieldCourseSettings |               |

**Code**

```lua
function AIAutomaticSteeringRequestEvent.new(vehicle, x, z, fieldCourseSettings)
    local self = AIAutomaticSteeringRequestEvent.emptyNew()
    self.vehicle = vehicle
    self.x, self.z = x, z
    self.fieldCourseSettings = fieldCourseSettings

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
function AIAutomaticSteeringRequestEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.x, self.z = g_fieldCourseManager:readTerrainDetailPixel(streamId)

    local attributes = FieldCourseSettings.readStream(streamId, connection)

    self.fieldCourseSettings = FieldCourseSettings.new( self.vehicle)
    self.fieldCourseSettings:applyAttributes(attributes)

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
function AIAutomaticSteeringRequestEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:generateSteeringFieldCourse( self.x, self.z, self.fieldCourseSettings)
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
function AIAutomaticSteeringRequestEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    g_fieldCourseManager:writeTerrainDetailPixel(streamId, self.x, self.z)

    self.fieldCourseSettings:writeStream(streamId, connection)
end

```