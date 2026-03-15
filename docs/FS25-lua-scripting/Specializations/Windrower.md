## Windrower

**Description**

> Specialization for windrowers providing additional animations, effects and drop area functionalities

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processDropArea](#processdroparea)
- [processWindrowerArea](#processwindrowerarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### doCheckSpeedLimit

**Description**

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Windrower:doCheckSpeedLimit(superFunc)
    local turnOn = true
    if self.getIsTurnedOn ~ = nil then
        turnOn = self:getIsTurnedOn()
    end

    return superFunc( self ) or( self.getIsImplementChainLowered ~ = nil and self:getIsImplementChainLowered() and turnOn)
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function Windrower.getDefaultSpeedLimit()
    return 15
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
function Windrower:getDirtMultiplier(superFunc)
    local spec = self.spec_windrower

    local multiplier = superFunc( self )

    if spec.isWorking then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
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
function Windrower:getWearMultiplier(superFunc)
    local spec = self.spec_windrower

    local multiplier = superFunc( self )

    if spec.isWorking then
        local stoneMultiplier = 1
        if spec.stoneLastState ~ = 0 and spec.stoneWearMultiplierData ~ = nil then
            stoneMultiplier = spec.stoneWearMultiplierData[spec.stoneLastState] or 1
        end

        multiplier = multiplier + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit * stoneMultiplier
    end

    return multiplier
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Windrower.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "windrower" , false , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Windrower" )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.windrower.effects.effect(?)" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.windrower.effects.effect(?).sounds" , "work" )
    schema:register(XMLValueType.INT, "vehicle.windrower.effects.effect(?)#workAreaIndex" , "Work area index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.windrower.effects.effect(?)#dropAreaIndex" , "Drop area index(if defined the effect is only active if this drop area is set on workArea)" )

        AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.windrower.animationNodes" )
        SoundManager.registerSampleXMLPaths(schema, "vehicle.windrower.sounds" , "work" )

        schema:register(XMLValueType.BOOL, "vehicle.windrower#limitToLineHeight" , "Limit pickup to work area line height" , false )
        schema:register(XMLValueType.STRING, "vehicle.windrower#fillTypeCategories" , "Fill type categories" )
        schema:register(XMLValueType.STRING, "vehicle.windrower#fillTypes" , "List of supported fill types" )

        schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".windrower#particleSystemIndex" , "Particle system index" )
        schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".windrower#dropWindrowWorkAreaIndex" , "Drop work area index" , 1 )

        schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".windrower#particleSystemIndex" , "Particle system index" )
        schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".windrower#dropWindrowWorkAreaIndex" , "Drop work area index" , 1 )

        schema:setXMLSpecializationType()
    end

```

### loadWorkAreaFromXML

**Description**

**Definition**

> loadWorkAreaFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function Windrower:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.WINDROWER
    end

    if workArea.type = = WorkAreaType.WINDROWER then
        workArea.particleSystemIndex = xmlFile:getValue(key .. ".windrower#particleSystemIndex" )
        workArea.dropWindrowWorkAreaIndex = xmlFile:getValue(key .. ".windrower#dropWindrowWorkAreaIndex" , 1 )

        workArea.lastValidPickupFillType = FillType.UNKNOWN
        workArea.lastPickupLiters = 0
        workArea.lastDroppedLiters = 0
        workArea.litersToDrop = 0

        local spec = self.spec_windrower
        if spec.windrowerWorkAreaFillTypes = = nil then
            spec.windrowerWorkAreaFillTypes = { }
        end
        table.insert(spec.windrowerWorkAreaFillTypes, FillType.UNKNOWN)
        workArea.windrowerWorkAreaIndex = #spec.windrowerWorkAreaFillTypes
    end

    return retValue
end

```

### onAIFieldCourseSettingsInitialized

**Description**

**Definition**

> onAIFieldCourseSettingsInitialized()

**Arguments**

| any | fieldCourseSettings |
|-----|---------------------|

**Code**

```lua
function Windrower:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.headlandsFirst = true
    fieldCourseSettings.workInitialSegment = true
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function Windrower:onDelete()
    local spec = self.spec_windrower
    g_soundManager:deleteSamples(spec.samples)
    g_animationManager:deleteAnimations(spec.animationNodes)

    if spec.effects ~ = nil then
        for _, effect in ipairs(spec.effects) do
            g_effectManager:deleteEffects(effect.effects)
            g_soundManager:deleteSamples(effect.samples)
        end
    end
end

```

### onEndWorkAreaProcessing

**Description**

**Definition**

> onEndWorkAreaProcessing()

**Arguments**

| any | dt        |
|-----|-----------|
| any | workAreas |

**Code**

```lua
function Windrower:onEndWorkAreaProcessing(dt, workAreas)
    local spec = self.spec_windrower

    if self.isClient then
        if self.getIsTurnedOn = = nil then
            if spec.isWorking then
                if not g_soundManager:getIsSamplePlaying(spec.samples.work) then
                    g_soundManager:playSample(spec.samples.work)
                end
            else
                    if g_soundManager:getIsSamplePlaying(spec.samples.work) then
                        g_soundManager:stopSample(spec.samples.work)
                    end
                end
            end
        end
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
function Windrower:onLoad(savegame)
    local spec = self.spec_windrower

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.animation" , "vehicle.windrowers.windrower" ) --FS13 to FS15

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.windrowerParticleSystems" , "vehicle.windrower.effects" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.windrower.animationNodes.animationNode" , "windrower" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.windrowerSound" , "vehicle.windrower.sounds.work" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.windrower.rakes.rake" , "vehicle.windrower.animationNodes.animationNode with type 'RotationAnimationSpikes'" ) --FS19 to FS22

    if self.isClient then
        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.windrower.animationNodes" , self.components, self , self.i3dMappings)

        spec.effects = { }
        spec.workAreaToEffects = { }
        local i = 0
        while true do
            local key = string.format( "vehicle.windrower.effects.effect(%d)" , i)
            if not self.xmlFile:hasProperty(key) then
                break
            end
            local effects = g_effectManager:loadEffect( self.xmlFile, key, self.components, self , self.i3dMappings)
            if effects ~ = nil then
                local effect = { }
                effect.effects = effects
                effect.workAreaIndex = self.xmlFile:getValue(key .. "#workAreaIndex" , 1 )
                effect.dropAreaIndex = self.xmlFile:getValue(key .. "#dropAreaIndex" )
                effect.activeTime = - 1
                effect.activeTimeDuration = 250
                effect.isActive = false
                effect.isActiveSent = false

                effect.samples = { }
                effect.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, key .. ".sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

                table.insert(spec.effects, effect)

                for j = 1 , #effects do
                    if effects[j].setWorkAreaIndex ~ = nil then
                        effects[j]:setWorkAreaIndex(effect.workAreaIndex)
                    end
                end
            end
            i = i + 1
        end

        spec.samples = { }
        spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.windrower.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    spec.isWorking = false
    spec.limitToLineHeight = self.xmlFile:getValue( "vehicle.windrower#limitToLineHeight" , false )

    spec.stoneLastState = 0
    spec.stoneWearMultiplierData = g_currentMission.stoneSystem:getWearMultiplierByType( "WINDROWER" )

    spec.supportedFillTypes = g_fillTypeManager:getFillTypesFromXML( self.xmlFile, "vehicle.windrower#fillTypeCategories" , "vehicle.windrower#fillTypes" , true )

    spec.fillTypesDirtyFlag = self:getNextDirtyFlag()
    spec.effectDirtyFlag = self:getNextDirtyFlag()

    if self.addAIDensityHeightTypeRequirement ~ = nil then
        for _, fillTypeIndex in ipairs(spec.supportedFillTypes) do
            self:addAIDensityHeightTypeRequirement(fillTypeIndex)
        end
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Windrower:onPostLoad(savegame)
    local spec = self.spec_windrower
    for i = #spec.effects, 1 , - 1 do
        local effect = spec.effects[i]
        local workArea = self:getWorkAreaByIndex(effect.workAreaIndex)
        if workArea ~ = nil then
            effect.windrowerWorkAreaFillTypeIndex = workArea.windrowerWorkAreaIndex

            if spec.workAreaToEffects[workArea.index] = = nil then
                spec.workAreaToEffects[workArea.index] = { }
            end
            table.insert(spec.workAreaToEffects[workArea.index], effect)
        else
                Logging.xmlWarning( self.xmlFile, "Invalid workAreaIndex '%d' for effect 'vehicle.windrower.effects.effect(%d)'!" , effect.workAreaIndex, i)
                    table.insert(spec.effects, i)
                end
            end
        end

```

### onReadStream

**Description**

**Definition**

> onReadStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Windrower:onReadStream(streamId, connection)
    local spec = self.spec_windrower
    for index, _ in ipairs(spec.windrowerWorkAreaFillTypes) do
        local fillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
        spec.windrowerWorkAreaFillTypes[index] = fillType
    end
    for _, effect in ipairs(spec.effects) do
        if streamReadBool(streamId) then
            local fillType = spec.windrowerWorkAreaFillTypes[effect.windrowerWorkAreaFillTypeIndex]
            g_effectManager:setEffectTypeInfo(effect.effects, fillType)
            g_effectManager:startEffects(effect.effects)

            if not g_soundManager:getIsSamplePlaying(effect.samples.work) then
                g_soundManager:playSample(effect.samples.work)
            end
        else
                g_effectManager:stopEffects(effect.effects)
                g_soundManager:stopSample(effect.samples.work)
            end
        end
    end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function Windrower:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_windrower

        if streamReadBool(streamId) then
            for index, _ in ipairs(spec.windrowerWorkAreaFillTypes) do
                local fillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                spec.windrowerWorkAreaFillTypes[index] = fillType
            end
        end

        if streamReadBool(streamId) then
            for _, effect in ipairs(spec.effects) do
                if streamReadBool(streamId) then
                    local fillType = spec.windrowerWorkAreaFillTypes[effect.windrowerWorkAreaFillTypeIndex]
                    g_effectManager:setEffectTypeInfo(effect.effects, fillType)
                    g_effectManager:startEffects(effect.effects)

                    if not g_soundManager:getIsSamplePlaying(effect.samples.work) then
                        g_soundManager:playSample(effect.samples.work)
                    end
                else
                        g_effectManager:stopEffects(effect.effects)
                        g_soundManager:stopSample(effect.samples.work)
                    end
                end
            end
        end
    end

```

### onStartWorkAreaProcessing

**Description**

**Definition**

> onStartWorkAreaProcessing()

**Arguments**

| any | dt        |
|-----|-----------|
| any | workAreas |

**Code**

```lua
function Windrower:onStartWorkAreaProcessing(dt, workAreas)
    local spec = self.spec_windrower
    for _, workArea in pairs(workAreas) do
        workArea.lastValidPickupFillType = FillType.UNKNOWN
        workArea.lastPickupLiters = 0
        workArea.lastDroppedLiters = 0
    end
    spec.isWorking = false
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function Windrower:onTurnedOff()
    local spec = self.spec_windrower
    g_soundManager:stopSamples(spec.samples)

    for _, effect in ipairs(spec.effects) do
        g_effectManager:stopEffects(effect.effects)
        g_soundManager:stopSample(effect.samples.work)
    end
    g_animationManager:stopAnimations(spec.animationNodes)
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function Windrower:onTurnedOn()
    local spec = self.spec_windrower
    if self.isClient then
        g_soundManager:playSample(spec.samples.work)
        g_animationManager:startAnimations(spec.animationNodes)
    end
end

```

### onUpdateTick

**Description**

**Definition**

> onUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Windrower:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_windrower

    if self.isServer then
        for _, effect in ipairs(spec.effects) do
            if effect.isActive and g_currentMission.time > effect.activeTime then
                effect.isActive = false
                if effect.isActiveSent then
                    effect.isActiveSent = false
                    self:raiseDirtyFlags(spec.effectDirtyFlag)
                end
                g_effectManager:stopEffects(effect.effects)
                g_soundManager:stopSample(effect.samples.work)
            end
        end
    end
end

```

### onWriteStream

**Description**

**Definition**

> onWriteStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function Windrower:onWriteStream(streamId, connection)
    local spec = self.spec_windrower
    for _, fillTypeIndex in ipairs(spec.windrowerWorkAreaFillTypes) do
        streamWriteUIntN(streamId, fillTypeIndex, FillTypeManager.SEND_NUM_BITS)
    end
    for _, effect in ipairs(spec.effects) do
        streamWriteBool(streamId, effect.isActiveSent)
    end
end

```

### onWriteUpdateStream

**Description**

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function Windrower:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_windrower

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.fillTypesDirtyFlag) ~ = 0 ) then
            for _, fillTypeIndex in ipairs(spec.windrowerWorkAreaFillTypes) do
                streamWriteUIntN(streamId, fillTypeIndex, FillTypeManager.SEND_NUM_BITS)
            end
        end

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.effectDirtyFlag) ~ = 0 ) then
            for _, effect in ipairs(spec.effects) do
                streamWriteBool(streamId, effect.isActiveSent)
            end
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
function Windrower.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations)
end

```

### processDropArea

**Description**

**Definition**

> processDropArea()

**Arguments**

| any | dropArea     |
|-----|--------------|
| any | litersToDrop |
| any | fillType     |

**Code**

```lua
function Windrower:processDropArea(dropArea, litersToDrop, fillType)
    local lsx, lsy, lsz, lex, ley, lez, radius = DensityMapHeightUtil.getLineByArea(dropArea.start, dropArea.width, dropArea.height)
    local dropped, lineOffset = DensityMapHeightUtil.tipToGroundAroundLine( self , litersToDrop, fillType, lsx,lsy,lsz, lex,ley,lez, radius, nil , dropArea.lineOffset, false , nil , false )
    dropArea.lineOffset = lineOffset

    return dropped
end

```

### processWindrowerArea

**Description**

**Definition**

> processWindrowerArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Windrower:processWindrowerArea(workArea, dt)
    local spec = self.spec_windrower
    local workAreaSpec = self.spec_workArea

    if not self.isServer and self.currentUpdateDistance > Windrower.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    spec.isWorking = self:getLastSpeed() > 0.5

    local sx, sy, sz = getWorldTranslation(workArea.start)
    local wx, wy, wz = getWorldTranslation(workArea.width)
    local hx, hy, hz = getWorldTranslation(workArea.height)

    if spec.isWorking then
        spec.stoneLastState = FSDensityMapUtil.getStoneArea(sx, sz, wx, wz, hx, hz)
    else
            spec.stoneLastState = 0
        end

        -- pick up
        local lsx, lsy, lsz, lex, ley, lez, radius = DensityMapHeightUtil.getLineByAreaDimensions(sx, sy, sz, wx, wy, wz, hx, hy, hz)

        -- loop over all fruitTypes or use only lastValidPickupFillType
        local pickupLiters = 0
        local pickupFillType = FillType.UNKNOWN

        if workArea.lastPickupLiters = = 0 and(workArea.lastValidPickupFillType = = FillType.UNKNOWN or workArea.litersToDrop < g_densityMapHeightManager:getMinValidLiterValue(workArea.lastValidPickupFillType)) then
            for _, fillTypeIndex in ipairs(spec.supportedFillTypes) do
                pickupLiters = - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, fillTypeIndex, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , spec.limitToLineHeight, nil )
                if pickupLiters > 0 then
                    pickupFillType = fillTypeIndex
                    break
                end
            end
        else
                pickupLiters = - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, workArea.lastValidPickupFillType, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )

                if workArea.lastValidPickupFillType = = FillType.GRASS_WINDROW then
                    pickupLiters = pickupLiters - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, FillType.DRYGRASS_WINDROW, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )
                elseif workArea.lastValidPickupFillType = = FillType.DRYGRASS_WINDROW then
                        pickupLiters = pickupLiters - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, FillType.GRASS_WINDROW, lsx,lsy,lsz, lex,ley,lez, radius, nil , nil , false , nil )
                    end

                    if pickupLiters > 0 then
                        pickupFillType = workArea.lastValidPickupFillType
                    end
                end

                if pickupFillType ~ = FillType.UNKNOWN then
                    workArea.lastValidPickupFillType = pickupFillType

                    self:setTestAreaRequirements( nil , pickupFillType, nil )
                end
                workArea.lastPickupLiters = pickupLiters
                workArea.litersToDrop = workArea.litersToDrop + pickupLiters

                --calculating area by area width multiplied by last moved distance(not 100% accuracy in corners)
                local areaWidth = MathUtil.vector3Length(lsx - lex, lsy - ley, lsz - lez)
                local area = areaWidth * self.lastMovedDistance

                -- drop
                if workArea.lastPickupLiters > 0 then
                    local dropArea = workAreaSpec.workAreas[workArea.dropWindrowWorkAreaIndex]
                    if dropArea ~ = nil then
                        local dropType = workArea.lastValidPickupFillType
                        local dropped = self:processDropArea(dropArea, workArea.lastPickupLiters, dropType)
                        workArea.lastDroppedLiters = dropped
                        workArea.litersToDrop = workArea.litersToDrop - dropped

                        if self.isServer then
                            --particles
                            if self:getLastSpeed( true ) > 0.5 then
                                if dropped > 0 then
                                    local changedFillType = false
                                    if spec.windrowerWorkAreaFillTypes[workArea.windrowerWorkAreaIndex] ~ = dropType then
                                        spec.windrowerWorkAreaFillTypes[workArea.windrowerWorkAreaIndex] = dropType
                                        self:raiseDirtyFlags(spec.fillTypesDirtyFlag)
                                        changedFillType = true
                                    end

                                    local effects = spec.workAreaToEffects[workArea.index]
                                    if effects ~ = nil then
                                        for _, effect in ipairs(effects) do
                                            if effect.dropAreaIndex = = nil or effect.dropAreaIndex = = workArea.dropWindrowWorkAreaIndex then
                                                effect.activeTime = g_currentMission.time + effect.activeTimeDuration

                                                -- sync mp
                                                if not effect.isActiveSent then
                                                    effect.isActiveSent = true
                                                    self:raiseDirtyFlags(spec.effectDirtyFlag)
                                                end

                                                if changedFillType then
                                                    g_effectManager:setEffectTypeInfo(effect.effects, dropType)
                                                end

                                                -- enable effect
                                                if not effect.isActive then
                                                    g_effectManager:setEffectTypeInfo(effect.effects, dropType)
                                                    g_effectManager:startEffects(effect.effects)

                                                    g_soundManager:playSample(effect.samples.work)
                                                end

                                                effect.isActive = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                return workArea.lastDroppedLiters, area
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
function Windrower.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Windrower )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , Windrower )
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
function Windrower.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processWindrowerArea" , Windrower.processWindrowerArea)
    SpecializationUtil.registerFunction(vehicleType, "processDropArea" , Windrower.processDropArea)
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
function Windrower.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Windrower.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Windrower.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Windrower.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Windrower.getWearMultiplier)
end

```