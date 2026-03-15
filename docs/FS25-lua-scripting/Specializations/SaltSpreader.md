## SaltSpreader

**Description**

> Specialization for road salt spreaders

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getAreControlledActionsAllowed](#getarecontrolledactionsallowed)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getTurnedOnNotAllowedWarning](#getturnedonnotallowedwarning)
- [getVariableWorkWidthUsage](#getvariableworkwidthusage)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [processSaltSpreaderArea](#processsaltspreaderarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### doCheckSpeedLimit

**Description**

> Returns if speed limit should be checked

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | checkSpeedlimit | check speed limit |
|-----|-----------------|-------------------|

**Code**

```lua
function SaltSpreader:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or self:getIsTurnedOn()
end

```

### getAreControlledActionsAllowed

**Description**

> Returns if controlled actions are allowed

**Definition**

> getAreControlledActionsAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | allow   | allow controlled actions |
|-----|---------|--------------------------|
| any | warning | not allowed warning      |

**Code**

```lua
function SaltSpreader:getAreControlledActionsAllowed(superFunc)
    local spec = self.spec_saltSpreader

    if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 then
        return false , spec.fillToolWarning
    end

    return superFunc( self )
end

```

### getCanBeTurnedOn

**Description**

**Definition**

> getCanBeTurnedOn()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SaltSpreader:getCanBeTurnedOn(superFunc)
    local spec = self.spec_saltSpreader
    if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 then
        return false
    end

    return superFunc( self )
end

```

### getDefaultSpeedLimit

**Description**

> Returns default speed limit

**Definition**

> getDefaultSpeedLimit()

**Return Values**

| any | speedLimit | speed limit |
|-----|------------|-------------|

**Code**

```lua
function SaltSpreader.getDefaultSpeedLimit()
    return 20
end

```

### getDirtMultiplier

**Description**

**Definition**

> getDirtMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SaltSpreader:getDirtMultiplier(superFunc)
    if self:getIsTurnedOn() then
        return superFunc( self ) + self:getWorkDirtMultiplier()
    end

    return superFunc( self )
end

```

### getTurnedOnNotAllowedWarning

**Description**

**Definition**

> getTurnedOnNotAllowedWarning()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SaltSpreader:getTurnedOnNotAllowedWarning(superFunc)
    local spec = self.spec_saltSpreader
    if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 then
        return spec.fillToolWarning
    end

    return superFunc( self )
end

```

### getVariableWorkWidthUsage

**Description**

> Returns the current usage for variable work width (nil if usage should not be displayed)

**Definition**

> getVariableWorkWidthUsage()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | usage | usage |
|-----|-------|-------|

**Code**

```lua
function SaltSpreader:getVariableWorkWidthUsage(superFunc)
    local usage = superFunc( self )
    if usage = = nil then
        if self:getIsTurnedOn() then
            local spec = self.spec_saltSpreader
            local usageMultiplier = 1
            if spec.usageWorkArea ~ = nil then
                usageMultiplier = self:getWorkAreaWidth(spec.usageWorkArea)
            end

            return spec.usage * usageMultiplier * 1000 * 60
        end

        return 0
    end

    return usage
end

```

### getWearMultiplier

**Description**

**Definition**

> getWearMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SaltSpreader:getWearMultiplier(superFunc)
    if self:getIsTurnedOn() then
        return superFunc( self ) + self:getWorkWearMultiplier()
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function SaltSpreader.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "saltSpreader" , false , false , false )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "SaltSpreader" )

    schema:register(XMLValueType.INT, "vehicle.saltSpreader#fillUnitIndex" , "Fill unit index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.saltSpreader#unloadInfoIndex" , "Unload info index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.saltSpreader#usageWorkArea" , "Width of this work area is used as multiplier for usage" )
        schema:register(XMLValueType.FLOAT, "vehicle.saltSpreader#usage" , "Salt usage in liter per second" , 1 )

        EffectManager.registerEffectXMLPaths(schema, "vehicle.saltSpreader.effects" )

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
function SaltSpreader:onDelete()
    local spec = self.spec_saltSpreader
    g_effectManager:deleteEffects(spec.effects)
end

```

### onLoad

**Description**

> Called on loading

**Definition**

> onLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function SaltSpreader:onLoad(savegame)
    local spec = self.spec_saltSpreader

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.saltSpreader#fillUnitIndex" , 1 )
    spec.unloadInfoIndex = self.xmlFile:getValue( "vehicle.saltSpreader#unloadInfoIndex" , 1 )
    spec.usageWorkArea = self.xmlFile:getValue( "vehicle.saltSpreader#usageWorkArea" )
    spec.usage = self.xmlFile:getValue( "vehicle.saltSpreader#usage" , 1 ) / 1000

    if self.isClient then
        spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.saltSpreader.effects" , self.components, self , self.i3dMappings)
    end

    spec.fillToolWarning = g_i18n:getText( "info_firstFillTheTool" )
    spec.snowSystem = g_currentMission.snowSystem

    if not self.isServer then
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , SaltSpreader )
    end
end

```

### onTurnedOff

**Description**

> Called on turn off

**Definition**

> onTurnedOff(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function SaltSpreader:onTurnedOff()
    if self.isClient then
        local spec = self.spec_saltSpreader
        g_effectManager:stopEffects(spec.effects)
    end
end

```

### onTurnedOn

**Description**

> Called on turn on

**Definition**

> onTurnedOn(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function SaltSpreader:onTurnedOn()
    if self.isClient then
        local spec = self.spec_saltSpreader
        local fillTypeIndex = self:getFillUnitFillType(spec.fillUnitIndex)
        if fillTypeIndex ~ = FillType.UNKNOWN then
            g_effectManager:setEffectTypeInfo(spec.effects, fillTypeIndex)
            g_effectManager:startEffects(spec.effects)
        end
    end
end

```

### onUpdateTick

**Description**

> Called on update

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
function SaltSpreader:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self:getIsTurnedOn() then
        local spec = self.spec_saltSpreader

        local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
        if fillLevel > 0 then
            local usageMultiplier = 1
            if spec.usageWorkArea ~ = nil then
                usageMultiplier = self:getWorkAreaWidth(spec.usageWorkArea)
            end

            local usage = spec.usage * dt * usageMultiplier
            local unloadInfo = self:getFillVolumeUnloadInfo(spec.unloadInfoIndex)
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - usage, self:getFillUnitFillType(spec.fillUnitIndex), ToolType.UNDEFINED, unloadInfo)
        else
                self:setIsTurnedOn( false )
            end
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
function SaltSpreader.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations) and SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
end

```

### processSaltSpreaderArea

**Description**

**Definition**

> processSaltSpreaderArea()

**Arguments**

| any | workArea |
|-----|----------|

**Code**

```lua
function SaltSpreader:processSaltSpreaderArea(workArea)
    if self.isServer then
        local xs, _, zs = getWorldTranslation(workArea.start)
        local xw, _, zw = getWorldTranslation(workArea.width)
        local xh, _, zh = getWorldTranslation(workArea.height)

        return self.spec_saltSpreader.snowSystem:saltArea(xs, zs, xw, zw, xh, zh)
    end
    return 0 , 0
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
function SaltSpreader.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , SaltSpreader )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , SaltSpreader )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , SaltSpreader )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , SaltSpreader )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , SaltSpreader )
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
function SaltSpreader.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processSaltSpreaderArea" , SaltSpreader.processSaltSpreaderArea)
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
function SaltSpreader.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , SaltSpreader.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , SaltSpreader.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , SaltSpreader.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreControlledActionsAllowed" , SaltSpreader.getAreControlledActionsAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , SaltSpreader.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getTurnedOnNotAllowedWarning" , SaltSpreader.getTurnedOnNotAllowedWarning)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getVariableWorkWidthUsage" , SaltSpreader.getVariableWorkWidthUsage)
end

```