## PrecisionFarmingSettingsInitialEvent

**Description**

> Event while settings have been updated on server or client side

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
function PrecisionFarmingSettingsInitialEvent.emptyNew()
    local self = Event.new( PrecisionFarmingSettingsInitialEvent _mt)
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
function PrecisionFarmingSettingsInitialEvent.new(settings)
    local self = PrecisionFarmingSettingsInitialEvent.emptyNew()
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
function PrecisionFarmingSettingsInitialEvent:readStream(streamId, connection)
    local precisionFarmingSettings = g_precisionFarming.precisionFarmingSettings

    for _, setting in ipairs(precisionFarmingSettings.settings) do
        if setting.isServerSetting then
            setting.state = streamReadBool(streamId)
        end
    end

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
function PrecisionFarmingSettingsInitialEvent:run(connection)
    local precisionFarmingSettings = g_precisionFarming.precisionFarmingSettings

    for _, setting in ipairs(precisionFarmingSettings.settings) do
        if setting.isServerSetting then
            precisionFarmingSettings:onSettingChanged(setting, true )
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
function PrecisionFarmingSettingsInitialEvent:writeStream(streamId, connection)
    local precisionFarmingSettings = g_precisionFarming.precisionFarmingSettings

    for _, setting in ipairs(precisionFarmingSettings.settings) do
        if setting.isServerSetting then
            streamWriteBool(streamId, setting.state = = true )
        end
    end
end

```