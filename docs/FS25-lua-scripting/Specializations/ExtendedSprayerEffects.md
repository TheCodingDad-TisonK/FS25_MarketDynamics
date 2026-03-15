## ExtendedSprayerEffects

**Description**

> Specialization to have individual nozzle effects for sprayers (controlled by ExtendedSprayer & WeedSpotSpray
> specializations)

**Functions**

- [addExtendedSprayerNozzleEffect](#addextendedsprayernozzleeffect)
- [addExtendedSprayerNozzleEffects](#addextendedsprayernozzleeffects)
- [getAreEffectsVisible](#getareeffectsvisible)
- [getNumExtendedSprayerNozzleEffectsActive](#getnumextendedsprayernozzleeffectsactive)
- [initExtendedSprayerNozzleEffect](#initextendedsprayernozzleeffect)
- [initSpecialization](#initspecialization)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onPreInitComponentPlacement](#onpreinitcomponentplacement)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [updateExtendedSprayerNozzleEffects](#updateextendedsprayernozzleeffects)
- [updateExtendedSprayerNozzleEffectsState](#updateextendedsprayernozzleeffectsstate)
- [updateExtendedSprayerNozzleEffectState](#updateextendedsprayernozzleeffectstate)

### addExtendedSprayerNozzleEffect

**Description**

**Definition**

> addExtendedSprayerNozzleEffect()

**Arguments**

| any | effectData     |
|-----|----------------|
| any | effectNode     |
| any | linkNode       |
| any | effectNodeData |

**Code**

```lua
function ExtendedSprayerEffects:addExtendedSprayerNozzleEffect(effectData, effectNode, linkNode, effectNodeData)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]
    effectData.effectNode = effectNode

    effectData.isActive = false
    effectData.amountScale = 1

    effectData.lastWorldTranslation = { 0 , 0 , 0 }
    effectData.speed = 0

    effectData.fadeCur = { - 1 , 1 }
    effectData.fadeDir = ExtendedSprayerEffects.EFFECT_DIRECTION_OFF
    effectData.state = ShaderPlaneEffect.STATE_OFF

    setShaderParameter(effectNode, "fadeProgress" , effectData.fadeCur[ 1 ], effectData.fadeCur[ 2 ], 0.0 , 0.0 , false )
    setShaderParameter(effectNode, "offsetUV" , math.random(), math.random(), 0.0 , 0.0 , false )

    setShaderParameter(effectNode, "isPulsating" , spec.pwmEnabled and 1 or 0 , nil , nil , nil , false )
    setShaderParameter(effectNode, "blinkMulti" , 1 , 1 , 100 , math.random() * 100 , false )

    link(linkNode, effectNode)

    if effectNodeData ~ = nil then
        setTranslation(effectNode, effectNodeData.translation[ 1 ], effectNodeData.translation[ 2 ], effectNodeData.translation[ 3 ])
        setRotation(effectNode, effectNodeData.rotation[ 1 ], effectNodeData.rotation[ 2 ], effectNodeData.rotation[ 3 ])
    end

    local _
    effectData.xOffset, _, _ = localToLocal(effectNode, self:getParentComponent(linkNode), 0 , 0 , 0 )

    return true
end

```

### addExtendedSprayerNozzleEffects

**Description**

**Definition**

> addExtendedSprayerNozzleEffects()

**Arguments**

| any | linkData |
|-----|----------|

**Code**

```lua
function ExtendedSprayerEffects:addExtendedSprayerNozzleEffects(linkData)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    for _, effectNodeData in pairs(linkData.effectNodes) do
        local linkNode
        if effectNodeData.nodeName ~ = nil then
            if self.i3dMappings[effectNodeData.nodeName] ~ = nil then
                linkNode = self.i3dMappings[effectNodeData.nodeName].nodeId
            end
        end

        if linkNode ~ = nil then
            local effectNode = g_precisionFarming:getClonedSprayerEffectNode()
            if effectNode ~ = nil then
                local effectData = { }
                if self:addExtendedSprayerNozzleEffect(effectData, effectNode, linkNode, effectNodeData) then
                    table.insert(spec.sprayerEffects, effectData)
                end
            end
        end
    end
end

```

### getAreEffectsVisible

**Description**

**Definition**

> getAreEffectsVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ExtendedSprayerEffects:getAreEffectsVisible(superFunc)
    -- effects are fully overwritten by the nozzle effects
    if self [ ExtendedSprayerEffects.SPEC_TABLE_NAME].hasCustomEffects then
        return false
    end

    return superFunc( self )
end

```

### getNumExtendedSprayerNozzleEffectsActive

**Description**

**Definition**

> getNumExtendedSprayerNozzleEffectsActive()

**Code**

```lua
function ExtendedSprayerEffects:getNumExtendedSprayerNozzleEffectsActive()
    local specEffects = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]
    if specEffects.hasCustomEffects then
        local numActiveEffects = 0
        for _, effectData in pairs(specEffects.sprayerEffects) do
            if effectData.isActive then
                numActiveEffects = numActiveEffects + 1
            end
        end

        return numActiveEffects, numActiveEffects / specEffects.numCustomEffects
    end

    return 1 , 1
end

```

### initExtendedSprayerNozzleEffect

**Description**

**Definition**

> initExtendedSprayerNozzleEffect()

**Arguments**

| any | effectData |
|-----|------------|

**Code**

```lua
function ExtendedSprayerEffects:initExtendedSprayerNozzleEffect(effectData)
    local spec_variableWorkWidth = self.spec_variableWorkWidth
    if spec_variableWorkWidth ~ = nil then
        local numSections = #spec_variableWorkWidth.sections
        if numSections > 0 then
            local minWidth = 1
            if #spec_variableWorkWidth.sectionNodes > 0 then
                local sectionNode = spec_variableWorkWidth.sectionNodes[ 1 ]
                minWidth = math.abs(sectionNode.startTransX or sectionNode.startTrans[ 1 ])
            end

            local x = effectData.xOffset or 0
            if x > 0 then
                effectData.sectionIndex = 0

                for _, section in ipairs(spec_variableWorkWidth.sectionsLeft) do
                    if x > minWidth and x < = section.widthAbs then
                        effectData.sectionIndex = section.index
                        break
                    end
                end
            else
                    effectData.sectionIndex = 0

                    for _, section in ipairs(spec_variableWorkWidth.sectionsRight) do
                        if x < - minWidth and x > = section.widthAbs then
                            effectData.sectionIndex = section.index
                            break
                        end
                    end
                end
            end
        end
    end

```

### initSpecialization

**Description**

> Called while initializing the specialization

**Definition**

> initSpecialization()

**Code**

```lua
function ExtendedSprayerEffects.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ExtendedSprayerEffects" )

    schema:register(XMLValueType.INT, "vehicle.sprayer.nozzles(?)#foldingConfigurationIndex" , "Folding configuration index to use these nozzles" , 1 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.sprayer.nozzles(?).nozzle(?)#node" , "Nozzle Node" )
    schema:register(XMLValueType.VECTOR_TRANS, "vehicle.sprayer.nozzles(?).nozzle(?)#translation" , "Translation offset from the defined node" )
    schema:register(XMLValueType.VECTOR_ROT, "vehicle.sprayer.nozzles(?).nozzle(?)#rotation" , "Rotation offset from the defined node" )

    schema:setXMLSpecializationType()
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function ExtendedSprayerEffects:onDelete()
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    if spec.soundSamplesBySection ~ = nil then
        for _, sampleData in pairs(spec.soundSamplesBySection) do
            g_soundManager:deleteSample(sampleData.turnOn)
            g_soundManager:deleteSample(sampleData.turnOff)
        end
    end

    g_soundManager:deleteSample(spec.spraySampleLeft)
    g_soundManager:deleteSample(spec.spraySampleRight)
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
function ExtendedSprayerEffects:onLoad(savegame)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    spec.pwmEnabled = ( self.configurations[ "pulseWidthModulation" ] or 1 ) > 1
    spec.individualNozzleControl = spec.pwmEnabled or( self.getIsSpotSprayEnabled ~ = nil and self:getIsSpotSprayEnabled())

    spec.effectFadeTime = 250
    spec.effectsDirty = false

    spec.sprayerEffects = { }
    spec.sprayerEffectsBySection = { }
    spec.soundSamplesBySection = { }

    if g_precisionFarming ~ = nil then
        local linkData, _ = g_precisionFarming:getSprayerNodeData( self.configFileName, self.configurations)
        if linkData ~ = nil then
            self:addExtendedSprayerNozzleEffects(linkData)
        end
    end

    spec.nozzleNodesToDelete = { }
    self.xmlFile:iterate( "vehicle.sprayer.nozzles" , function (index, nozzlesKey)
        local foldingConfigIndex = self.xmlFile:getValue(nozzlesKey .. "#foldingConfigurationIndex" , 1 )

        self.xmlFile:iterate(nozzlesKey .. ".nozzle" , function (_, key)
            local linkNode = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            if linkNode ~ = nil then
                if foldingConfigIndex = = self.configurations[ "folding" ] or( self.configurations[ "folding" ] = = nil and foldingConfigIndex = = 1 ) then
                    local effectNode = g_precisionFarming:getClonedSprayerEffectNode()
                    if effectNode ~ = nil then
                        local effectNodeData = { }
                        effectNodeData.translation = self.xmlFile:getValue(key .. "#translation" , { 0 , 0 , 0 } , true )
                        effectNodeData.rotation = self.xmlFile:getValue(key .. "#rotation" , { 0 , 0 , 0 } , true )

                        local effectData = { }
                        if self:addExtendedSprayerNozzleEffect(effectData, effectNode, linkNode, effectNodeData) then
                            table.insert(spec.sprayerEffects, effectData)
                        end
                    end
                else
                        spec.nozzleNodesToDelete[linkNode] = true
                    end
                end
            end )
        end )

        for i = 1 , #spec.nozzleNodesToDelete do
            if entityExists(spec.nozzleNodesToDelete[i]) then
                delete(spec.nozzleNodesToDelete[i])
            end
        end
        spec.nozzleNodesToDelete = { }
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
function ExtendedSprayerEffects:onPostLoad(savegame)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    for _, effectData in pairs(spec.sprayerEffects) do
        self:initExtendedSprayerNozzleEffect(effectData)

        if spec.sprayerEffectsBySection[effectData.sectionIndex] = = nil then
            spec.sprayerEffectsBySection[effectData.sectionIndex] = { }
        end
        table.insert(spec.sprayerEffectsBySection[effectData.sectionIndex], effectData)
    end
end

```

### onPreInitComponentPlacement

**Description**

**Definition**

> onPreInitComponentPlacement()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function ExtendedSprayerEffects:onPreInitComponentPlacement(savegame)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    spec.numCustomEffects = #spec.sprayerEffects
    spec.hasCustomEffects = spec.numCustomEffects > 0
    if not spec.hasCustomEffects then
        SpecializationUtil.removeEventListener( self , "onUpdate" , ExtendedSprayerEffects )
    else
            -- we disable the manual switching of the sections as we auto control them and hide the hud extension
            SpecializationUtil.removeEventListener( self , "onDraw" , VariableWorkWidth )
            SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , VariableWorkWidth )

            local specSprayer = self.spec_sprayer
            if specSprayer.samples ~ = nil then
                g_soundManager:deleteSamples(specSprayer.samples.spray)
                specSprayer.samples.spray = { }
            end

            for _, sprayType in pairs(specSprayer.sprayTypes) do
                if sprayType.samples ~ = nil then
                    g_soundManager:deleteSamples(sprayType.samples.spray)
                    sprayType.samples.spray = { }
                end
            end

            local leftX, leftY, leftZ, numLeft = 0 , 0 , 0 , 0
            local rightX, rightY, rightZ, numRight = 0 , 0 , 0 , 0

            for sectionIndex, sprayerEffects in pairs(spec.sprayerEffectsBySection) do
                local linkNode = createTransformGroup( "sectionCenterNode" .. tostring(sectionIndex))
                link( self.rootNode, linkNode)

                local wx, wy, wz = 0 , 0 , 0
                local isLeft = false
                for i, effectData in ipairs(sprayerEffects) do
                    local x, y, z = getWorldTranslation(effectData.effectNode)
                    wx, wy, wz = wx + x, wy + y, wz + z

                    local xOffset, _, _ = localToLocal(effectData.effectNode, self.rootNode, 0 , 0 , 0 )
                    if xOffset > 0 then
                        leftX, leftY, leftZ = leftX + x, leftY + y, leftZ + z
                        numLeft = numLeft + 1

                        isLeft = true
                    else
                            rightX, rightY, rightZ = rightX + x, rightY + y, rightZ + z
                            numRight = numRight + 1
                        end
                    end

                    local numEffects = #sprayerEffects
                    wx = wx / numEffects
                    wy = wy / numEffects
                    wz = wz / numEffects
                    setWorldTranslation(linkNode, wx, wy, wz)

                    local sampleData = { }
                    sampleData.linkNode = linkNode
                    sampleData.sectionIndex = sectionIndex
                    sampleData.sprayIsActive = false
                    sampleData.isLeft = isLeft

                    sampleData.turnOn = g_precisionFarming:getSprayerClonedSectionSamples( "turnOn" , linkNode, self )
                    sampleData.turnOff = g_precisionFarming:getSprayerClonedSectionSamples( "turnOff" , linkNode, self )

                    spec.soundSamplesBySection[sectionIndex] = sampleData
                end

                if numLeft > 0 then
                    leftX, leftY, leftZ = leftX / numLeft, leftY / numLeft, leftZ / numLeft

                    local sampleLinkNode = createTransformGroup( "sectionsLeftNode" )
                    link( self.rootNode, sampleLinkNode)
                    setWorldTranslation(sampleLinkNode, leftX, leftY, leftZ)
                    spec.spraySampleLeft = g_precisionFarming:getSprayerClonedSectionSamples( "spray" , sampleLinkNode, self )
                end

                if numRight > 0 then
                    rightX, rightY, rightZ = rightX / numRight, rightY / numRight, rightZ / numRight

                    local sampleLinkNode = createTransformGroup( "sectionsRightNode" )
                    link( self.rootNode, sampleLinkNode)
                    setWorldTranslation(sampleLinkNode, rightX, rightY, rightZ)
                    spec.spraySampleRight = g_precisionFarming:getSprayerClonedSectionSamples( "spray" , sampleLinkNode, self )
                end

                for _, sampleData in pairs(spec.soundSamplesBySection) do
                    if sampleData.isLeft then
                        sampleData.spray = spec.spraySampleLeft
                    else
                            sampleData.spray = spec.spraySampleRight
                        end
                    end
                end
            end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function ExtendedSprayerEffects:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    --#profile RemoteProfiler.zoneBeginN("ExtendedSprayerEffects:updateExtendedSprayerNozzleEffectState")

    local isTurnedOn = self:getIsTurnedOn()
    local lastSpeed = self:getLastSpeed()
    if spec.individualNozzleControl then
        self:updateExtendedSprayerNozzleEffectsState(spec.sprayerEffects, false , dt, isTurnedOn, lastSpeed)
    else
            for _, sprayerEffects in pairs(spec.sprayerEffectsBySection) do
                self:updateExtendedSprayerNozzleEffectsState(sprayerEffects, true , dt, isTurnedOn, lastSpeed)
            end
        end

        --#profile RemoteProfiler.zoneEnd()

        --#profile RemoteProfiler.zoneBeginN("ExtendedSprayerEffects:updateExtendedSprayerNozzleEffects")
        if spec.effectsDirty then
            spec.effectsDirty = false

            self:updateExtendedSprayerNozzleEffects(dt)
            self:raiseActive()
        end
        --#profile RemoteProfiler.zoneEnd()
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
function ExtendedSprayerEffects.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Sprayer , specializations) and SpecializationUtil.hasSpecialization( ExtendedSprayer , specializations)
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
function ExtendedSprayerEffects.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ExtendedSprayerEffects )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , ExtendedSprayerEffects )
    SpecializationUtil.registerEventListener(vehicleType, "onPreInitComponentPlacement" , ExtendedSprayerEffects )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , ExtendedSprayerEffects )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , ExtendedSprayerEffects )
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
function ExtendedSprayerEffects.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "addExtendedSprayerNozzleEffects" , ExtendedSprayerEffects.addExtendedSprayerNozzleEffects)
    SpecializationUtil.registerFunction(vehicleType, "addExtendedSprayerNozzleEffect" , ExtendedSprayerEffects.addExtendedSprayerNozzleEffect)
    SpecializationUtil.registerFunction(vehicleType, "initExtendedSprayerNozzleEffect" , ExtendedSprayerEffects.initExtendedSprayerNozzleEffect)
    SpecializationUtil.registerFunction(vehicleType, "updateExtendedSprayerNozzleEffectsState" , ExtendedSprayerEffects.updateExtendedSprayerNozzleEffectsState)
    SpecializationUtil.registerFunction(vehicleType, "updateExtendedSprayerNozzleEffectState" , ExtendedSprayerEffects.updateExtendedSprayerNozzleEffectState)
    SpecializationUtil.registerFunction(vehicleType, "updateExtendedSprayerNozzleEffects" , ExtendedSprayerEffects.updateExtendedSprayerNozzleEffects)
    SpecializationUtil.registerFunction(vehicleType, "getNumExtendedSprayerNozzleEffectsActive" , ExtendedSprayerEffects.getNumExtendedSprayerNozzleEffectsActive)
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
function ExtendedSprayerEffects.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreEffectsVisible" , ExtendedSprayerEffects.getAreEffectsVisible)
end

```

### updateExtendedSprayerNozzleEffects

**Description**

**Definition**

> updateExtendedSprayerNozzleEffects()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function ExtendedSprayerEffects:updateExtendedSprayerNozzleEffects(dt)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]
    for _, effectData in pairs(spec.sprayerEffects) do
        local fadeSpeedScale = 1

        if effectData.state = = ShaderPlaneEffect.STATE_TURNING_ON or effectData.state = = ShaderPlaneEffect.STATE_TURNING_OFF then
            effectData.fadeCur[ 1 ] = math.max( math.min(effectData.fadeCur[ 1 ] + effectData.fadeDir[ 1 ] * (dt / (spec.effectFadeTime * fadeSpeedScale)), 1 ), - 1 )
            effectData.fadeCur[ 2 ] = math.max( math.min(effectData.fadeCur[ 2 ] + effectData.fadeDir[ 2 ] * (dt / (spec.effectFadeTime * fadeSpeedScale)), 1 ), - 1 )

            setShaderParameter(effectData.effectNode, "fadeProgress" , effectData.fadeCur[ 1 ], effectData.fadeCur[ 2 ], 0.0 , 0.0 , false )

            if effectData.state = = ShaderPlaneEffect.STATE_TURNING_OFF then
                if effectData.fadeCur[ 1 ] = = 1 and effectData.fadeCur[ 2 ] = = - 1 then
                    effectData.state = ShaderPlaneEffect.STATE_OFF
                end
            elseif effectData.state = = ShaderPlaneEffect.STATE_TURNING_ON then
                    if effectData.fadeCur[ 1 ] = = 1 and effectData.fadeCur[ 2 ] = = 1 then
                        effectData.state = ShaderPlaneEffect.STATE_ON
                    end
                end

                spec.effectsDirty = true
            end

            if spec.pwmEnabled then
                local pauseTicks = 1 + math.max( math.floor(( 1 - effectData.amountScale) * 5 ), 0 )
                setShaderParameter(effectData.effectNode, "blinkMulti" , nil , pauseTicks, nil , nil , false )
            end
        end
    end

```

### updateExtendedSprayerNozzleEffectsState

**Description**

**Definition**

> updateExtendedSprayerNozzleEffectsState()

**Arguments**

| any | sprayerEffects |
|-----|----------------|
| any | useFullSection |
| any | dt             |
| any | isTurnedOn     |
| any | lastSpeed      |

**Code**

```lua
function ExtendedSprayerEffects:updateExtendedSprayerNozzleEffectsState(sprayerEffects, useFullSection, dt, isTurnedOn, lastSpeed)
    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]

    local anyEffectActive = false
    for _, effectData in pairs(sprayerEffects) do
        local isActive, amountScale = self:updateExtendedSprayerNozzleEffectState(effectData, dt, isTurnedOn, lastSpeed)

        effectData.isDirty = isActive ~ = effectData.isActive
        effectData.isActive = isActive

        if amountScale ~ = effectData.amountScale then
            effectData.amountScale = amountScale
            spec.effectsDirty = true
        end

        if useFullSection and isActive then
            anyEffectActive = true
            break
        end
    end

    -- as soon as we turn on one nozzle of the section, we turn on all
    if useFullSection then
        if anyEffectActive then
            for _, effectData in pairs(sprayerEffects) do
                if not effectData.isActive then
                    effectData.isActive = true
                    effectData.isDirty = true
                end
            end
        end
    end

    for _, effectData in pairs(sprayerEffects) do
        if effectData.isDirty then
            effectData.isDirty = false
            spec.effectsDirty = true

            if effectData.isActive then
                if effectData.state ~ = ShaderPlaneEffect.STATE_ON and effectData.state ~ = ShaderPlaneEffect.STATE_TURNING_ON then
                    effectData.state = ShaderPlaneEffect.STATE_TURNING_ON
                    effectData.fadeDir = ExtendedSprayerEffects.EFFECT_DIRECTION_START
                    effectData.fadeCur[ 1 ] = - 1
                    effectData.fadeCur[ 2 ] = 1
                end
            else
                    if effectData.state ~ = ShaderPlaneEffect.STATE_OFF and effectData.state ~ = ShaderPlaneEffect.STATE_TURNING_OFF then
                        effectData.state = ShaderPlaneEffect.STATE_TURNING_OFF
                        effectData.fadeDir = ExtendedSprayerEffects.EFFECT_DIRECTION_STOP
                    end
                end

                local sampleData = spec.soundSamplesBySection[effectData.sectionIndex]
                if sampleData ~ = nil then
                    local sprayIsActive = g_soundManager:getIsSamplePlaying(sampleData.spray)

                    if effectData.isActive then
                        if not g_soundManager:getIsSamplePlaying(sampleData.turnOn) then
                            g_soundManager:playSample(sampleData.turnOn)
                        end

                        if not sprayIsActive then
                            g_soundManager:playSample(sampleData.spray, 0 , sampleData.turnOn)
                        end
                    end

                    if not effectData.isActive then
                        if not g_soundManager:getIsSamplePlaying(sampleData.turnOff) then
                            g_soundManager:playSample(sampleData.turnOff)
                        end

                        local anyOtherEffectActive = false
                        for sectionIndex, otherSampleData in pairs(spec.soundSamplesBySection) do
                            if otherSampleData ~ = sampleData and otherSampleData.spray = = sampleData.spray then
                                local otherEffects = spec.sprayerEffectsBySection[sectionIndex]
                                for _, otherEffect in pairs(otherEffects) do
                                    if otherEffect.isActive then
                                        anyOtherEffectActive = true
                                        break
                                    end
                                end
                            end
                        end

                        if not anyOtherEffectActive and sprayIsActive then
                            g_soundManager:stopSample(sampleData.spray)
                        end
                    end
                end
            end
        end
    end

```

### updateExtendedSprayerNozzleEffectState

**Description**

**Definition**

> updateExtendedSprayerNozzleEffectState()

**Arguments**

| any | effectData |
|-----|------------|
| any | dt         |
| any | isTurnedOn |
| any | lastSpeed  |

**Code**

```lua
function ExtendedSprayerEffects:updateExtendedSprayerNozzleEffectState(effectData, dt, isTurnedOn, lastSpeed)
    if effectData.sectionIndex ~ = 0 then
        if not self.spec_variableWorkWidth.sections[effectData.sectionIndex].isActive then
            return false , 1
        end
    end

    local spec = self [ ExtendedSprayerEffects.SPEC_TABLE_NAME]
    if spec.pwmEnabled then
        local x, y, z = getWorldTranslation(effectData.effectNode)
        local lx, ly, lz = effectData.lastWorldTranslation[ 1 ], effectData.lastWorldTranslation[ 2 ], effectData.lastWorldTranslation[ 3 ]
        local distance = MathUtil.vector3Length(x - lx, y - ly, z - lz)
        effectData.speed = distance / (g_physicsDt * 0.001 ) * 3.6
        effectData.lastWorldTranslation[ 1 ], effectData.lastWorldTranslation[ 2 ], effectData.lastWorldTranslation[ 3 ] = x, y, z

        return isTurnedOn, math.min(effectData.speed / self.speedLimit, 1 )
    else
            if (lastSpeed or 1 ) < 0.1 then
                isTurnedOn = false
            end
        end

        return isTurnedOn, 1
    end

```