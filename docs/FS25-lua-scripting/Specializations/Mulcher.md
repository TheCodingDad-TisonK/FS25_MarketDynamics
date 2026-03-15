## Mulcher

**Description**

> Specialization for all mulchers, requires WorkArea specialization

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getAIImplementUseVineSegment](#getaiimplementusevinesegment)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getDoGroundManipulation](#getdogroundmanipulation)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processMulcherArea](#processmulcherarea)
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
function Mulcher:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or self:getIsImplementChainLowered()
end

```

### getAIImplementUseVineSegment

**Description**

**Definition**

> getAIImplementUseVineSegment()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | placeable   |
| any | segment     |
| any | segmentSide |

**Code**

```lua
function Mulcher:getAIImplementUseVineSegment(superFunc, placeable, segment, segmentSide)
    local startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ = placeable:getSegmentSideArea(segment, segmentSide)

    local area, areaTotal = AIVehicleUtil.getAIAreaOfVehicle( self , startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
    if areaTotal > 0 then
        return(area / areaTotal) > 0.01
    end

    return false
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
function Mulcher.getDefaultSpeedLimit()
    return 15
end

```

### getDirtMultiplier

**Description**

> Returns current dirt multiplier

**Definition**

> getDirtMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current dirt multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function Mulcher:getDirtMultiplier(superFunc)
    local spec = self.spec_mulcher

    local multiplier = superFunc( self )
    if spec.isWorking then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / spec.speedLimit
    end

    return multiplier
end

```

### getDoGroundManipulation

**Description**

> Returns if tool does ground manipulation

**Definition**

> getDoGroundManipulation()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | doGroundManipulation | do ground manipulation |
|-----|----------------------|------------------------|

**Code**

```lua
function Mulcher:getDoGroundManipulation(superFunc)
    local spec = self.spec_mulcher

    if not spec.isWorking then
        return false
    end

    return superFunc( self )
end

```

### getWearMultiplier

**Description**

> Returns current wear multiplier

**Definition**

> getWearMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current wear multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function Mulcher:getWearMultiplier(superFunc)
    local spec = self.spec_mulcher
    local multiplier = superFunc( self )

    if spec.isWorking then
        local stoneMultiplier = 1
        if spec.stoneLastState ~ = 0 and spec.stoneWearMultiplierData ~ = nil then
            stoneMultiplier = spec.stoneWearMultiplierData[spec.stoneLastState] or 1
        end

        multiplier = multiplier + self:getWorkWearMultiplier() * self:getLastSpeed() / spec.speedLimit * stoneMultiplier
    end

    return multiplier
end

```

### initSpecialization

**Description**

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function Mulcher.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "mulcher" , true , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Mulcher" )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.mulcher.effects.effect(?)" )
    schema:register(XMLValueType.INT, "vehicle.mulcher.effects.effect(?)#workAreaIndex" , "Work area index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.mulcher.effects.effect(?)#activeDirection" , "If vehicle is driving into this direction the effect will be activated(0 = any direction)" , 0 )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.mulcher.sounds" , "idle(?)" )
    SoundManager.registerSampleXMLPaths(schema, "vehicle.mulcher.sounds" , "work(?)" )

    schema:setXMLSpecializationType()
end

```

### loadWorkAreaFromXML

**Description**

> Loads work areas from xml

**Definition**

> loadWorkAreaFromXML(table workArea, integer xmlFile, string key, )

**Arguments**

| table   | workArea | workArea         |
|---------|----------|------------------|
| integer | xmlFile  | id of xml object |
| string  | key      | key              |
| any     | key      |                  |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Mulcher:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.MULCHER
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
function Mulcher:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.headlandsFirst = true
    fieldCourseSettings.workInitialSegment = true
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function Mulcher:onDeactivate()
    local spec = self.spec_mulcher
    if self.isClient then
        g_soundManager:stopSamples(spec.samples.idle)
        g_soundManager:stopSamples(spec.samples.work)
        spec.isWorkSamplePlaying = false
        spec.isIdleSamplePlaying = false
    end

    for _, effect in ipairs(spec.effects) do
        g_effectManager:stopEffects(effect.effects)
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Mulcher:onDelete()
    local spec = self.spec_mulcher
    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.idle)
        g_soundManager:deleteSamples(spec.samples.work)
    end

    if spec.effects ~ = nil then
        for _, effect in ipairs(spec.effects) do
            g_effectManager:deleteEffects(effect.effects)
        end
    end
end

```

### onEndWorkAreaProcessing

**Description**

**Definition**

> onEndWorkAreaProcessing()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Mulcher:onEndWorkAreaProcessing(dt)
    local spec = self.spec_mulcher

    if self.isClient then
        if spec.isWorking then
            if not spec.isWorkSamplePlaying then
                g_soundManager:playSamples(spec.samples.work)
                spec.isWorkSamplePlaying = true
            end
        else
                if spec.isWorkSamplePlaying then
                    g_soundManager:stopSamples(spec.samples.work)
                    spec.isWorkSamplePlaying = false
                end
            end

            if spec.isWorkingIdle then
                if not spec.isIdleSamplePlaying then
                    g_soundManager:playSamples(spec.samples.idle)
                    spec.isIdleSamplePlaying = true
                end
            else
                    if spec.isIdleSamplePlaying then
                        g_soundManager:stopSamples(spec.samples.idle)
                        spec.isIdleSamplePlaying = false
                    end
                end
            end
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
function Mulcher:onLoad(savegame)
    if self:getGroundReferenceNodeFromIndex( 1 ) = = nil then
        printWarning( "Warning:No ground reference nodes in " .. self.configFileName)
    end

    local spec = self.spec_mulcher

    if self.isClient then
        spec.samples = { }
        spec.samples.idle = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.mulcher.sounds" , "idle" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.samples.work = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.mulcher.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.isWorkSamplePlaying = false
        spec.isIdleSamplePlaying = false
    end

    spec.effects = { }
    spec.workAreaToEffects = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.mulcher.effects.effect(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local effects = g_effectManager:loadEffect( self.xmlFile, key, self.components, self , self.i3dMappings)
        if effects ~ = nil then
            local effect = { }
            effect.effects = effects
            effect.workAreaIndex = self.xmlFile:getValue(key .. "#workAreaIndex" , 1 )
            effect.activeDirection = self.xmlFile:getValue(key .. "#activeDirection" , 0 )
            effect.activeTime = - 1
            effect.activeTimeDuration = 250
            effect.isActive = false
            effect.isActiveSent = false

            for _, effectObject in ipairs(effects) do
                if effectObject:isa(CultivatorMotionPathEffect) then
                    effectObject.autoTurnOffSpeed = - math.huge
                end
            end

            table.insert(spec.effects, effect)
        end
        i = i + 1
    end

    spec.effectFillType = FillType.WHEAT

    if self.addAIGroundTypeRequirements ~ = nil then
        self:addAIGroundTypeRequirements( Mulcher.AI_REQUIRED_GROUND_TYPES)

        self:clearAIFruitRequirements()
        for _, fruitType in ipairs(g_fruitTypeManager:getFruitTypes()) do
            if fruitType.isCultivationAllowed then
                if fruitType.mulchedState > fruitType.cutState then
                    self:addAIFruitRequirement(fruitType.index, 2 , fruitType.mulchedState - 1 )
                else
                        self:addAIFruitRequirement(fruitType.index, 2 , 15 )
                    end
                end
            end

            local weedSystem = g_currentMission.weedSystem
            if weedSystem ~ = nil then
                local replacementData = weedSystem:getMulcherReplacements()
                if replacementData.custom ~ = nil then
                    for _, data in ipairs(replacementData.custom) do
                        local fruitType = data.fruitType
                        if fruitType.terrainDataPlaneId ~ = nil then
                            for sourceState, targetState in pairs(data.replacements) do
                                self:addAIFruitRequirement(fruitType.index, sourceState, sourceState)
                            end
                        end
                    end
                end
            end
        end

        spec.isWorking = false
        spec.isWorkingIdle = false
        spec.lastWorkTime = - math.huge

        spec.stoneLastState = 0
        spec.stoneWearMultiplierData = g_currentMission.stoneSystem:getWearMultiplierByType( "MULCHER" )

        spec.effectDirtyFlag = self:getNextDirtyFlag()

        if not self.isClient or #spec.effects = = 0 then
            SpecializationUtil.removeEventListener( self , "onUpdateTick" , Mulcher )
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
function Mulcher:onPostLoad(savegame)
    local spec = self.spec_mulcher
    for i = #spec.effects, 1 , - 1 do
        local effect = spec.effects[i]
        local workArea = self:getWorkAreaByIndex(effect.workAreaIndex)
        if workArea ~ = nil then
            if spec.workAreaToEffects[workArea.index] = = nil then
                spec.workAreaToEffects[workArea.index] = { }
            end
            table.insert(spec.workAreaToEffects[workArea.index], effect)
        else
                Logging.xmlWarning( self.xmlFile, "Invalid workAreaIndex '%d' for effect 'vehicle.mulcher.effects.effect(%d)'!" , effect.workAreaIndex, i)
                    table.remove(spec.effects, i)
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
function Mulcher:onReadStream(streamId, connection)
    local spec = self.spec_mulcher
    for _, effect in ipairs(spec.effects) do
        if streamReadBool(streamId) then
            g_effectManager:setEffectTypeInfo(effect.effects, spec.effectFillType)
            g_effectManager:startEffects(effect.effects)
        else
                g_effectManager:stopEffects(effect.effects)
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
function Mulcher:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_mulcher
        if streamReadBool(streamId) then
            for _, effect in ipairs(spec.effects) do
                if streamReadBool(streamId) then
                    g_effectManager:setEffectTypeInfo(effect.effects, spec.effectFillType)
                    g_effectManager:startEffects(effect.effects)
                else
                        g_effectManager:stopEffects(effect.effects)
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

| any | dt |
|-----|----|

**Code**

```lua
function Mulcher:onStartWorkAreaProcessing(dt)
    local spec = self.spec_mulcher

    spec.isWorking = false
    spec.isWorkingIdle = false
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
function Mulcher:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self.spec_mulcher
        for _, effect in ipairs(spec.effects) do
            if effect.isActive and g_currentMission.time > effect.activeTime then
                effect.isActive = false
                self:raiseDirtyFlags(spec.effectDirtyFlag)
                g_effectManager:stopEffects(effect.effects)
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
function Mulcher:onWriteStream(streamId, connection)
    local spec = self.spec_mulcher
    for _, effect in ipairs(spec.effects) do
        streamWriteBool(streamId, effect.isActive)
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
function Mulcher:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_mulcher
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.effectDirtyFlag) ~ = 0 ) then
            for _, effect in ipairs(spec.effects) do
                streamWriteBool(streamId, effect.isActive)
            end
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
function Mulcher.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations) and SpecializationUtil.hasSpecialization( GroundReference , specializations)
end

```

### processMulcherArea

**Description**

**Definition**

> processMulcherArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Mulcher:processMulcherArea(workArea, dt)
    local spec = self.spec_mulcher

    spec.isWorkingIdle = self:getLastSpeed() > 0.5

    local xs,_,zs = getWorldTranslation(workArea.start)
    local xw,_,zw = getWorldTranslation(workArea.width)
    local xh,_,zh = getWorldTranslation(workArea.height)

    FSDensityMapUtil.eraseTireTrack(xs,zs, xw,zw, xh,zh)

    if not self.isServer and self.currentUpdateDistance > Mulcher.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local realArea, area = FSDensityMapUtil.updateMulcherArea(xs,zs, xw,zw, xh,zh)
    if realArea > 0 and spec.isWorkingIdle then
        local effects = spec.workAreaToEffects[workArea.index]
        if effects ~ = nil then
            for _, effect in ipairs(effects) do
                if effect.activeDirection = = 0 or self.movingDirection = = effect.activeDirection then
                    effect.activeTime = g_currentMission.time + effect.activeTimeDuration

                    if not effect.isActive then
                        g_effectManager:setEffectTypeInfo(effect.effects, spec.effectFillType)
                        g_effectManager:startEffects(effect.effects)

                        effect.isActive = true
                        self:raiseDirtyFlags(spec.effectDirtyFlag)
                    end
                end
            end
        end

        spec.lastWorkTime = g_ time
    end

    spec.isWorking = (g_ time - spec.lastWorkTime) < 500

    if spec.isWorking then
        spec.stoneLastState = FSDensityMapUtil.getStoneArea(xs, zs, xw, zw, xh, zh)
    else
            spec.stoneLastState = 0
        end

        return realArea, area
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
function Mulcher.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Mulcher )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , Mulcher )
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
function Mulcher.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processMulcherArea" , Mulcher.processMulcherArea)
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
function Mulcher.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Mulcher.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoGroundManipulation" , Mulcher.getDoGroundManipulation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Mulcher.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Mulcher.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIImplementUseVineSegment" , Mulcher.getAIImplementUseVineSegment)
end

```