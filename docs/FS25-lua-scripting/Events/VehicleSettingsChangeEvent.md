## VehicleSettingsChangeEvent

**Description**

> Event for vehicle setting change

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
function VehicleSettingsChangeEvent.emptyNew()
    local self = Event.new( VehicleSettingsChangeEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table vehicle, boolean isEasyControlActive, )

**Arguments**

| table   | vehicle             | vehicle                 |
|---------|---------------------|-------------------------|
| boolean | isEasyControlActive | is easy control enabled |
| any     | state               |                         |

**Code**

```lua
function VehicleSettingsChangeEvent.new(vehicle, settings, state)
    local self = VehicleSettingsChangeEvent.emptyNew()
    self.vehicle = vehicle
    self.settings = settings

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
function VehicleSettingsChangeEvent:readStream(streamId, connection)
    local vehicle = NetworkUtil.readNodeObject(streamId)
    local numSettings = streamReadUInt8(streamId)

    local isValid = vehicle ~ = nil and vehicle:getIsSynchronized()

    for i = 1 , numSettings do
        local index = streamReadUInt8(streamId)

        local state
        if streamReadBool(streamId) then
            state = streamReadBool(streamId)
        else
                state = streamReadUInt8(streamId)
            end

            if isValid then
                vehicle:setVehicleSettingState(index, state, true )
            end
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
function VehicleSettingsChangeEvent:run(connection)
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
function VehicleSettingsChangeEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)

    local numSettingsToSend = 0
    for i = 1 , # self.settings do
        if self.settings[i].isDirty then
            numSettingsToSend = numSettingsToSend + 1
        end
    end

    streamWriteUInt8(streamId, numSettingsToSend)

    for i = 1 , # self.settings do
        local setting = self.settings[i]
        if setting.isDirty then
            streamWriteUInt8(streamId, setting.index)

            if streamWriteBool(streamId, setting.isBool) then
                streamWriteBool(streamId, setting.state)
            else
                    streamWriteUInt8(streamId, setting.state)
                end

                setting.isDirty = false
            end
        end
    end

```