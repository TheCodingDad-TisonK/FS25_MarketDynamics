## HandToolTethered

**Description**

> The hand tool specialisation for any hand tool that is tethered to its holder, like a high pressure washer lance.

**Functions**

- [onCarryingPlayerEnteredVehicle](#oncarryingplayerenteredvehicle)
- [onCarryingPlayerLeftGame](#oncarryingplayerleftgame)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPreUpdate](#onpreupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [returnToHolder](#returntoholder)
- [setAttachedHolder](#setattachedholder)
- [setHolder](#setholder)
- [showRangeWarning](#showrangewarning)

### onCarryingPlayerEnteredVehicle

**Description**

**Definition**

> onCarryingPlayerEnteredVehicle()

**Code**

```lua
function HandToolTethered:onCarryingPlayerEnteredVehicle()
    self:returnToHolder()
end

```

### onCarryingPlayerLeftGame

**Description**

**Definition**

> onCarryingPlayerLeftGame()

**Code**

```lua
function HandToolTethered:onCarryingPlayerLeftGame()
    self:returnToHolder()
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolTethered:onDelete()
    local spec = self.spec_tethered
    if spec.attachedHolder ~ = nil then
        spec.attachedHolder.spawnedHandTool = nil
    end
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | baseDirectory |

**Code**

```lua
function HandToolTethered:onLoad(xmlFile, baseDirectory)

    local spec = self.spec_tethered

    -- The holder that this tool is tethered to.
    spec.attachedHolder = nil

    -- Load the warning text.
    spec.rangeWarningText = self.xmlFile:getValue( "handTool.tethered#warningText" , "DistanceWarning %d" , self.customEnvironment, true )

    -- The maximum range this tool can be from its holder before it snaps back to it.
    spec.actionRange = xmlFile:getValue( "handTool.tethered#actionRange" , 3 )
    spec.maximumRange = xmlFile:getValue( "handTool.tethered#range" , 5 )

    -- Ensure the mustBeHeld member is true, as tethered tools cannot be put away.
    if not self.mustBeHeld then
        Logging.warning( "HandTool %q has its mustBeHeld value set to false, but tethered tools cannot be put away! Setting to true!" , self.typeName)
        self.mustBeHeld = true
    end

    -- Ensure the canBeSaved member is false, as tethered tools cannot be saved.
    if self.canBeSaved then
        Logging.warning( "HandTool %q has its canBeSaved value set to true, but tethered tools cannot be saved! Setting to false!" , self.typeName)
        self.canBeSaved = false
    end

    spec.warningIdentifier = getMD5( tostring( self ))
end

```

### onPreUpdate

**Description**

**Definition**

> onPreUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HandToolTethered:onPreUpdate(dt)
    local spec = self.spec_tethered
    if spec.attachedHolder = = nil then
        return
    end

    -- If the tool is not being held, do nothing.
        if not self:getIsHeld() then
            return
        end

        -- Get the player holding this tool.
        local player = self:getCarryingPlayer()
        if player = = nil then
            return
        end

        -- Get the position of the player, the position of the holder, and the distance between the two.
        local playerPositionX, playerPositionY, playerPositionZ = player:getPosition()
        local holderPositionX, holderPositionY, holderPositionZ = getWorldTranslation(spec.attachedHolder.holderNode)
        local holderPlayerDistance = MathUtil.vector3Length(playerPositionX - holderPositionX, playerPositionY - holderPositionY, playerPositionZ - holderPositionZ)

        -- If the distance is higher than the range of the tether, snap back to the holder.
        if holderPlayerDistance > spec.maximumRange then
            self:returnToHolder()
        elseif holderPlayerDistance > spec.actionRange and player = = g_localPlayer then
                self:showRangeWarning(holderPlayerDistance)
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
function HandToolTethered.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( HandToolStorable , specializations)
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolTethered.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolTethered )
    SpecializationUtil.registerEventListener(handToolType, "onDelete" , HandToolTethered )
    SpecializationUtil.registerEventListener(handToolType, "onCarryingPlayerEnteredVehicle" , HandToolTethered )
    SpecializationUtil.registerEventListener(handToolType, "onCarryingPlayerLeftGame" , HandToolTethered )
    SpecializationUtil.registerEventListener(handToolType, "onPreUpdate" , HandToolTethered )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolTethered.registerFunctions(handToolType)
    SpecializationUtil.registerFunction(handToolType, "showRangeWarning" , HandToolTethered.showRangeWarning)
    SpecializationUtil.registerFunction(handToolType, "returnToHolder" , HandToolTethered.returnToHolder)
    SpecializationUtil.registerFunction(handToolType, "setAttachedHolder" , HandToolTethered.setAttachedHolder)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function HandToolTethered.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setHolder" , HandToolTethered.setHolder)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | xmlSchema |
|-----|-----------|

**Code**

```lua
function HandToolTethered.registerXMLPaths(xmlSchema)
    xmlSchema:setXMLSpecializationType( "HandToolTethered" )
    xmlSchema:register(XMLValueType.L10N_STRING, "handTool.tethered#warningText" , "The l10n text string to use when warning the player of the range.The remaining range is the first argument" , nil , false )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.tethered#actionRange" , "The range in metres in which this tool can work.When outside of this range, the range warning is shown" , "3 metres" , false )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.tethered#range" , "The range in metres before this tool snaps back into its holder" , "5 metres" , false )
end

```

### returnToHolder

**Description**

**Definition**

> returnToHolder()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function HandToolTethered:returnToHolder(noEventSend)
    local spec = self.spec_tethered
    if spec.attachedHolder = = nil then
        return
    end

    self:setHolder(spec.attachedHolder, noEventSend)
end

```

### setAttachedHolder

**Description**

**Definition**

> setAttachedHolder()

**Arguments**

| any | holder |
|-----|--------|

**Code**

```lua
function HandToolTethered:setAttachedHolder(holder)
    local spec = self.spec_tethered
    if spec.attachedHolder ~ = nil then
        Logging.devWarning( "Tethered tool holder already set" )
        return
    end

    spec.attachedHolder = holder
end

```

### setHolder

**Description**

**Definition**

> setHolder()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | holder      |
| any | noEventSend |

**Code**

```lua
function HandToolTethered:setHolder(superFunc, holder, noEventSend)
    if holder = = nil then
        local spec = self.spec_tethered
        if spec.attachedHolder = = nil then
            return
        end

        holder = spec.attachedHolder
    end

    superFunc( self , holder, noEventSend)
end

```

### showRangeWarning

**Description**

**Definition**

> showRangeWarning()

**Arguments**

| any | holderPlayerDistance |
|-----|----------------------|

**Code**

```lua
function HandToolTethered:showRangeWarning(holderPlayerDistance)
    if g_gui:getIsGuiVisible() then
        return
    end

    -- If there is no text to display, do nothing.
        local spec = self.spec_tethered
        if string.isNilOrWhitespace(spec.rangeWarningText) then
            return
        end

        -- Display the text with the remaining distance.
        local remainingDistance = spec.maximumRange - holderPlayerDistance
        local mission = g_currentMission
        mission:showBlinkingWarning( string.format(spec.rangeWarningText, remainingDistance), 100 , spec.warningIdentifier)
    end

```