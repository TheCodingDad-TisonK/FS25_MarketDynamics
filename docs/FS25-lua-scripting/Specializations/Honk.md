## Honk

**Description**

> Specialization adding honk/horn functionality to a vehicle

**Functions**

- [actionEventHonk](#actioneventhonk)
- [getIsHonkAvailable](#getishonkavailable)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLeaveVehicle](#onleavevehicle)
- [onLoad](#onload)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [playHonk](#playhonk)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [setHonkInput](#sethonkinput)

### actionEventHonk

**Description**

**Definition**

> actionEventHonk()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Honk.actionEventHonk( self , actionName, inputValue, callbackState, isAnalog)
    self:setHonkInput()
end

```

### getIsHonkAvailable

**Description**

**Definition**

> getIsHonkAvailable()

**Code**

```lua
function Honk:getIsHonkAvailable()
    return true
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function Honk.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Honk" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.honk" , "sound" )
    schema:setXMLSpecializationType()
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Honk:onDelete()
    local spec = self.spec_honk
    g_soundManager:deleteSample(spec.sample)
end

```

### onLeaveVehicle

**Description**

> Called on leaving the vehicle

**Definition**

> onLeaveVehicle()

**Code**

```lua
function Honk:onLeaveVehicle()
    self:playHonk( false , true )
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Honk:onLoad(savegame)
    local spec = self.spec_honk

    spec.inputPressed = false
    spec.isPlaying = false
    if self.isClient then
        spec.sample = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.honk" , "sound" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    if not self.isClient then
        SpecializationUtil.removeEventListener( self , "onUpdate" , Honk )
    end
end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |

**Code**

```lua
function Honk:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_honk
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection and spec.sample ~ = nil then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.HONK, self , Honk.actionEventHonk, false , true , true , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
            g_inputBinding:setActionEventActive(actionEventId, true )
            g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_honk" ))
        end
    end
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Honk:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient and isActiveForInputIgnoreSelection then
        local spec = self.spec_honk
        if spec.inputPressed then
            if not g_soundManager:getIsSamplePlaying(spec.sample) then
                self:playHonk( true )
            end
        else
                if spec.isPlaying then
                    self:playHonk( false )
                end
            end
            spec.inputPressed = false
        end
    end

```

### playHonk

**Description**

**Definition**

> playHonk()

**Arguments**

| any | isPlaying   |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Honk:playHonk(isPlaying, noEventSend)
    HonkEvent.sendEvent( self , isPlaying, noEventSend)
    local spec = self.spec_honk

    spec.isPlaying = isPlaying
    if spec.sample ~ = nil then

        if isPlaying then
            if self:getIsActive() then
                if self.isClient then
                    g_soundManager:playSample(spec.sample)
                end
            end
        else
                g_soundManager:stopSample(spec.sample)
            end
        end
    end

```

### prerequisitesPresent

**Description**

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function Honk.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Drivable , specializations)
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
function Honk.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Honk )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Honk )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Honk )
    SpecializationUtil.registerEventListener(vehicleType, "onLeaveVehicle" , Honk )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Honk )
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
function Honk.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getIsHonkAvailable" , Honk.getIsHonkAvailable)
    SpecializationUtil.registerFunction(vehicleType, "setHonkInput" , Honk.setHonkInput)
    SpecializationUtil.registerFunction(vehicleType, "playHonk" , Honk.playHonk)
end

```

### setHonkInput

**Description**

**Definition**

> setHonkInput()

**Code**

```lua
function Honk:setHonkInput()
    local spec = self.spec_honk
    spec.inputPressed = true
end

```