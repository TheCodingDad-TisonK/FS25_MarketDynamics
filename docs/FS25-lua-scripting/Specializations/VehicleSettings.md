## VehicleSettings

**Description**

> Specialization to store local settings for the vehicle based on the settings of the client which has entered the
> vehicle

**Functions**

- [forceVehicleSettingsUpdate](#forcevehiclesettingsupdate)
- [getVehicleSettingState](#getvehiclesettingstate)
- [initSpecialization](#initspecialization)
- [onPreLoad](#onpreload)
- [onStateChange](#onstatechange)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerVehicleSetting](#registervehiclesetting)
- [setVehicleSettingState](#setvehiclesettingstate)

### forceVehicleSettingsUpdate

**Description**

> Force update of vehicle settings -> current settings will be send from client to server

**Definition**

> forceVehicleSettingsUpdate()

**Code**

```lua
function VehicleSettings:forceVehicleSettingsUpdate()
    local spec = self.spec_vehicleSettings
    for i = 1 , #spec.settings do
        local setting = spec.settings[i]
        self:setVehicleSettingState(setting.index, g_gameSettings:getValue(setting.gameSettingId), true )
    end
end

```

### getVehicleSettingState

**Description**

> Returns the current state of vehicle setting by settings id

**Definition**

> getVehicleSettingState(integer gameSettingId)

**Arguments**

| integer | gameSettingId | gameSettingId |
|---------|---------------|---------------|

**Return Values**

| integer | state | state |
|---------|-------|-------|

**Code**

```lua
function VehicleSettings:getVehicleSettingState(gameSettingId)
    local spec = self.spec_vehicleSettings
    for i = 1 , #spec.settings do
        local setting = spec.settings[i]
        if setting.gameSettingId = = gameSettingId then
            return setting.state
        end
    end
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function VehicleSettings.initSpecialization()
end

```

### onPreLoad

**Description**

> Called on loading

**Definition**

> onPreLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function VehicleSettings:onPreLoad(savegame)
    local spec = self.spec_vehicleSettings

    spec.isDirty = false
    spec.settings = { }

    if self.isServer then
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , VehicleSettings )
    end
end

```

### onStateChange

**Description**

> Called if vehicle state changes

**Definition**

> onStateChange()

**Arguments**

| any | state         |
|-----|---------------|
| any | vehicle       |
| any | isControlling |

**Code**

```lua
function VehicleSettings:onStateChange(state, vehicle, isControlling)
    if isControlling then
        if state = = VehicleStateChange.ENTER_VEHICLE then
            self:forceVehicleSettingsUpdate()
        end
    end
end

```

### onUpdateTick

**Description**

> Called on updateTick

**Definition**

> onUpdateTick(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function VehicleSettings:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_vehicleSettings
    if spec.isDirty then
        local hasDirtyValue = false
        for i = 1 , #spec.settings do
            if spec.settings[i].isDirty then
                hasDirtyValue = true
                break
            end
        end

        if hasDirtyValue then
            if g_server = = nil and g_client ~ = nil then
                g_client:getServerConnection():sendEvent( VehicleSettingsChangeEvent.new( self , spec.settings))
            end
        end

        spec.isDirty = false
    end
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function VehicleSettings.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function VehicleSettings.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad" , VehicleSettings )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , VehicleSettings )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , VehicleSettings )
    SpecializationUtil.registerEventListener(vehicleType, "onPreAttach" , VehicleSettings )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function VehicleSettings.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onVehicleSettingChanged" )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function VehicleSettings.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "registerVehicleSetting" , VehicleSettings.registerVehicleSetting)
    SpecializationUtil.registerFunction(vehicleType, "setVehicleSettingState" , VehicleSettings.setVehicleSettingState)
    SpecializationUtil.registerFunction(vehicleType, "getVehicleSettingState" , VehicleSettings.getVehicleSettingState)
    SpecializationUtil.registerFunction(vehicleType, "forceVehicleSettingsUpdate" , VehicleSettings.forceVehicleSettingsUpdate)
end

```

### registerVehicleSetting

**Description**

> Registers a game settings for this vehicle

**Definition**

> registerVehicleSetting(string gameSettingId, boolean isBool)

**Arguments**

| string  | gameSettingId | id of game setting         |
|---------|---------------|----------------------------|
| boolean | isBool        | settings is only a boolean |

**Code**

```lua
function VehicleSettings:registerVehicleSetting(gameSettingId, isBool)
    local spec = self.spec_vehicleSettings

    local setting = { }
    setting.index = #spec.settings + 1
    setting.gameSettingId = gameSettingId
    setting.isBool = isBool
    setting.callback = function (_, state)
        if self:getIsActiveForInput( true , true ) then
            self:setVehicleSettingState(setting.index, state)
        end
    end

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[gameSettingId], setting.callback, self )

    table.insert(spec.settings, setting)
end

```

### setVehicleSettingState

**Description**

> Set state of vehicle setting by index

**Definition**

> setVehicleSettingState(integer settingIndex, any state, boolean noEventSend)

**Arguments**

| integer | settingIndex | index of setting              |
|---------|--------------|-------------------------------|
| any     | state        | state                         |
| boolean | noEventSend  | no event will be send if true |

**Code**

```lua
function VehicleSettings:setVehicleSettingState(settingIndex, state, noEventSend)
    local spec = self.spec_vehicleSettings
    local setting = spec.settings[settingIndex]
    if setting ~ = nil then
        if noEventSend = = nil or noEventSend = = false then
            if g_server = = nil and g_client ~ = nil then
                g_client:getServerConnection():sendEvent( VehicleSettingsChangeEvent.new( self , spec.settings))
            end
        end

        setting.state = state
        setting.isDirty = true
        spec.isDirty = true

        SpecializationUtil.raiseEvent( self , "onVehicleSettingChanged" , setting.gameSettingId, state)
    end
end

```