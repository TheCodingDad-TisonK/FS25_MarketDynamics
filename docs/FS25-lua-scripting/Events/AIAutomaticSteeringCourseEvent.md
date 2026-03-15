## AIAutomaticSteeringCourseEvent

**Description**

> Event for current automatic steering course

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
function AIAutomaticSteeringCourseEvent.emptyNew()
    local self = Event.new( AIAutomaticSteeringCourseEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, integer currentAngle)

**Arguments**

| table   | vehicle      | vehicle       |
|---------|--------------|---------------|
| integer | currentAngle | current angle |

**Code**

```lua
function AIAutomaticSteeringCourseEvent.new(vehicle, steeringFieldCourse)
    local self = AIAutomaticSteeringCourseEvent.emptyNew()
    self.vehicle = vehicle
    self.steeringFieldCourse = steeringFieldCourse

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
function AIAutomaticSteeringCourseEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setAIAutomaticSteeringCourse( nil , true )
    end

    if streamReadBool(streamId) then
        SteeringFieldCourse.readStream(streamId, connection, function (steeringFieldCourse)
            if steeringFieldCourse ~ = nil then
                if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
                    self.vehicle:setAIAutomaticSteeringCourse(steeringFieldCourse, true )
                end
            end
        end )
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
function AIAutomaticSteeringCourseEvent:run(connection)
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
function AIAutomaticSteeringCourseEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)

    if streamWriteBool(streamId, self.steeringFieldCourse ~ = nil ) then
        self.steeringFieldCourse:writeStream(streamId, connection)
    end
end

```