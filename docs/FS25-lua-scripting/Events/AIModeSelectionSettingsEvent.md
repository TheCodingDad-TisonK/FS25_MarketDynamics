## AIModeSelectionSettingsEvent

**Description**

> Event from client to server to send the latest settings that were used on the client side

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
function AIModeSelectionSettingsEvent.emptyNew()
    local self = Event.new( AIModeSelectionSettingsEvent _mt)
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
function AIModeSelectionSettingsEvent.new(vehicle, fieldCourseSettings)
    local self = AIModeSelectionSettingsEvent.emptyNew()
    self.vehicle = vehicle
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
function AIModeSelectionSettingsEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)

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
function AIModeSelectionSettingsEvent:run(connection)
    if self.vehicle ~ = nil and self.vehicle:getIsSynchronized() then
        self.vehicle:setAIModeFieldCourseSettings( self.fieldCourseSettings)
    end

    if not connection:getIsServer() then
        g_server:broadcastEvent( AIModeSelectionSettingsEvent.new( self.vehicle, self.fieldCourseSettings), nil , connection, self.vehicle)
    end
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table vehicle, integer state, boolean noEventSend)

**Arguments**

| table   | vehicle     | vehicle       |
|---------|-------------|---------------|
| integer | state       | state         |
| boolean | noEventSend | no event send |

**Code**

```lua
function AIModeSelectionSettingsEvent.sendEvent(vehicle, fieldCourseSettings, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( AIModeSelectionSettingsEvent.new(vehicle, fieldCourseSettings), nil , nil , vehicle)
        else
                g_client:getServerConnection():sendEvent( AIModeSelectionSettingsEvent.new(vehicle, fieldCourseSettings))
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
function AIModeSelectionSettingsEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)

    self.fieldCourseSettings:writeStream(streamId, connection)
end

```