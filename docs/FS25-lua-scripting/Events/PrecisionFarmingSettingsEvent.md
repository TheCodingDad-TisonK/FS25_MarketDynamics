## PrecisionFarmingSettingsEvent

**Description**

> Event while settings have been updated on server or client side

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
function PrecisionFarmingSettingsEvent.emptyNew()
    local self = Event.new( PrecisionFarmingSettingsEvent _mt)
    return self
end

```

### new

**Description**

> Create new instance of event

**Definition**

> new(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Code**

```lua
function PrecisionFarmingSettingsEvent.new(setting)
    local self = PrecisionFarmingSettingsEvent.emptyNew()
    self.setting = setting
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
function PrecisionFarmingSettingsEvent:readStream(streamId, connection)
    local precisionFarmingSettings = g_precisionFarming.precisionFarmingSettings

    local index = streamReadUIntN(streamId, precisionFarmingSettings.settingIndexNumBits)
    local state = streamReadBool(streamId)
    self.setting = precisionFarmingSettings.settings[index]
    self.setting.state = state

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
function PrecisionFarmingSettingsEvent:run(connection)
    if not connection:getIsServer() then
        g_server:broadcastEvent( self , false , connection, nil )
    end

    local precisionFarmingSettings = g_precisionFarming.precisionFarmingSettings
    precisionFarmingSettings:onSettingChanged( self.setting, true )
end

```

### sendEvent

**Description**

> Broadcast event from server to all clients, if called on client call function on server and broadcast it to all
> clients

**Definition**

> sendEvent(table object, boolean noEventSend)

**Arguments**

| table   | object      | object        |
|---------|-------------|---------------|
| boolean | noEventSend | no event send |

**Code**

```lua
function PrecisionFarmingSettingsEvent.sendEvent(setting, noEventSend)
    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( PrecisionFarmingSettingsEvent.new(setting), nil , nil , nil )
        else
                g_client:getServerConnection():sendEvent( PrecisionFarmingSettingsEvent.new(setting))
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
function PrecisionFarmingSettingsEvent:writeStream(streamId, connection)
    local precisionFarmingSettings = g_precisionFarming.precisionFarmingSettings

    streamWriteUIntN(streamId, self.setting.index, precisionFarmingSettings.settingIndexNumBits)
    streamWriteBool(streamId, self.setting.state = = true ) -- only supports booleans for now
    end

```