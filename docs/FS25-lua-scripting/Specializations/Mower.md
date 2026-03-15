## Mower

**Description**

> Specialization for vehicles with grass mowing functionality

**Functions**

- [actionEventToggleDrop](#actioneventtoggledrop)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getCanBeSelected](#getcanbeselected)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getDropArea](#getdroparea)
- [getFruitExtraObjectTypeData](#getfruitextraobjecttypedata)
- [getMowerLoadPercentage](#getmowerloadpercentage)
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
- [onRegisterActionEvents](#onregisteractionevents)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processDropArea](#processdroparea)
- [processMowerArea](#processmowerarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setCutSoundEnabled](#setcutsoundenabled)
- [setDropEffectEnabled](#setdropeffectenabled)
- [setUseMowerWindrowDropAreas](#setusemowerwindrowdropareas)
- [updateActionEventToggleDrop](#updateactioneventtoggledrop)

### actionEventToggleDrop

**Description**

**Definition**

> actionEventToggleDrop()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Mower.actionEventToggleDrop( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_mower
    self:setUseMowerWindrowDropAreas( not spec.useWindrowDropAreas)
end

```

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
function Mower:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and( self.getIsLowered = = nil or self:getIsLowered()))
end

```

### getCanBeSelected

**Description**

**Definition**

> getCanBeSelected()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Mower:getCanBeSelected(superFunc)
    return true
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
function Mower.getDefaultSpeedLimit()
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
function Mower:getDirtMultiplier(superFunc)
    local spec = self.spec_mower

    local multiplier = superFunc( self )

    if spec.isWorking then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
end

```

### getDropArea

**Description**

**Definition**

> getDropArea()

**Arguments**

| any | workArea |
|-----|----------|

**Code**

```lua
function Mower:getDropArea(workArea)
    if workArea.dropWindrow then
        local dropArea
        if workArea.dropAreaIndex ~ = nil then
            dropArea = self.spec_workArea.workAreas[workArea.dropAreaIndex]
            if dropArea = = nil then
                printWarning( "Warning:Invalid dropAreaIndex '" .. tostring(workArea.dropAreaIndex) .. "' in '" .. tostring( self.configFileName) .. "'!" )
                workArea.dropAreaIndex = nil
            end

            if dropArea.type ~ = WorkAreaType.AUXILIARY then
                Logging.xmlWarning( self.xmlFile, "Invalid dropAreaIndex '%s'.Drop area type needs to be 'AUXILIARY'!" , workArea.dropAreaIndex)
                workArea.dropAreaIndex = nil
                dropArea = nil
            end
        end
        return dropArea
    end

    return nil
end

```

### getFruitExtraObjectTypeData

**Description**

**Definition**

> getFruitExtraObjectTypeData()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Mower:getFruitExtraObjectTypeData(superFunc)
    return self.spec_mower.lastFruitTypeIndex, nil
end

```

### getMowerLoadPercentage

**Description**

**Definition**

> getMowerLoadPercentage()

**Code**

```lua
function Mower:getMowerLoadPercentage()
    if self.spec_mower ~ = nil then
        return self.spec_mower.workAreaParameters.lastUsedAreasPct
    end

    return 0
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
function Mower:getWearMultiplier(superFunc)
    local spec = self.spec_mower

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

> Called on specialization initializing

**Definition**

> initSpecialization()

**Code**

```lua
function Mower.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "mower" , false , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Mower" )

    AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.mower.animationNodes" )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.mower.cutterEffects" )

    EffectManager.registerEffectXMLPaths(schema, "vehicle.mower.dropEffects.dropEffect(?)" )
    schema:register(XMLValueType.INT, "vehicle.mower.dropEffects.dropEffect(?)#dropAreaIndex" , "Drop area index" , 1 )
    schema:register(XMLValueType.INT, "vehicle.mower.dropEffects.dropEffect(?)#workAreaIndex" , "Work area index" , 1 )

    schema:register(XMLValueType.STRING, "vehicle.mower#fruitTypeConverter" , "Fruit type converter name" )
    schema:register(XMLValueType.INT, "vehicle.mower#fillUnitIndex" , "Fill unit index" )
    schema:register(XMLValueType.FLOAT, "vehicle.mower#pickupFillScale" , "Pickup fill scale" , 1 )
    schema:register(XMLValueType.L10N_STRING, "vehicle.mower.toggleWindrowDrop#enableText" , "Enable windrow drop text" )
    schema:register(XMLValueType.L10N_STRING, "vehicle.mower.toggleWindrowDrop#disableText" , "Disable windrow drop text" )

    schema:register(XMLValueType.STRING, "vehicle.mower.toggleWindrowDrop#animationName" , "Windrow drop animation name" )
    schema:register(XMLValueType.FLOAT, "vehicle.mower.toggleWindrowDrop#animationEnableSpeed" , "Animation enable speed" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.mower.toggleWindrowDrop#animationDisableSpeed" , "Animation disable speed" , "inversed 'animationEnableSpeed'" )
    schema:register(XMLValueType.BOOL, "vehicle.mower.toggleWindrowDrop#startEnabled" , "Start windrow drop enabled" , false )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.mower.sounds" , "cut(?)" )

    schema:register(XMLValueType.BOOL, WorkArea.WORK_AREA_XML_KEY .. ".mower#dropWindrow" , "Drop windrow" , true )
    schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".mower#dropAreaIndex" , "Drop area index" , 1 )

    schema:register(XMLValueType.BOOL, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".mower#dropWindrow" , "Drop windrow" , true )
    schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".mower#dropAreaIndex" , "Drop area index" , 1 )

    schema:setXMLSpecializationType()
end

```

### loadWorkAreaFromXML

**Description**

> Loads work areas from xml

**Definition**

> loadWorkAreaFromXML(table workArea, XMLFile xmlFile, string key, )

**Arguments**

| table   | workArea | workArea         |
|---------|----------|------------------|
| XMLFile | xmlFile  | XMLFile instance |
| string  | key      | key              |
| any     | key      |                  |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Mower:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.MOWER
    end

    if workArea.type = = WorkAreaType.MOWER then
        workArea.dropWindrow = xmlFile:getValue(key .. ".mower#dropWindrow" , true )
        workArea.dropAreaIndex = xmlFile:getValue(key .. ".mower#dropAreaIndex" , 1 )

        workArea.lastPickupLiters = 0
        workArea.pickedUpLiters = 0
    end

    if workArea.type = = WorkAreaType.AUXILIARY then
        workArea.litersToDrop = 0
        if self.spec_mower.dropAreas = = nil then
            self.spec_mower.dropAreas = { }
        end
        table.insert( self.spec_mower.dropAreas, workArea)
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
function Mower:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.headlandsFirst = true
    fieldCourseSettings.workInitialSegment = true
    fieldCourseSettings.cornerCutOutSupported = true
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Mower:onDelete()
    local spec = self.spec_mower

    if self.isClient then
        g_animationManager:deleteAnimations(spec.animationNodes)

        if spec.samples ~ = nil then
            g_soundManager:deleteSamples(spec.samples.cut)
        end
    end

    if spec.dropEffects ~ = nil then
        for _, dropEffect in pairs(spec.dropEffects) do
            g_effectManager:deleteEffects(dropEffect.effects)
        end
    end

    g_effectManager:deleteEffects(spec.cutterEffects)
end

```

### onEndWorkAreaProcessing

**Description**

**Definition**

> onEndWorkAreaProcessing()

**Arguments**

| any | dt           |
|-----|--------------|
| any | hasProcessed |

**Code**

```lua
function Mower:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self.spec_mower

    for _, dropArea in ipairs(spec.dropAreas) do
        self:processDropArea(dropArea, dt)
    end

    for i = 1 , #spec.workAreas do
        local workArea = spec.workAreas[i]
        for j = 1 , #workArea.dropEffects do
            local dropEffect = workArea.dropEffects[j]
            local dropArea = self:getDropArea(workArea)
            if dropEffect.dropAreaIndex = = dropArea.index then
                if workArea.pickedUpLiters > 0 then
                    if dropEffect.fillType ~ = dropArea.fillType then
                        dropEffect.fillType = dropArea.fillType
                        g_effectManager:setEffectTypeInfo(dropEffect.effects, dropEffect.fillType)
                    end
                    dropEffect.activeTime = dropEffect.activeTimeDuration
                    dropEffect.isActive = true
                else
                        dropEffect.activeTime = math.max(dropEffect.activeTime - dt, 0 )
                        if dropEffect.activeTime > 0 then
                            dropEffect.isActive = true
                        end
                    end
                end
            end
        end

        if self.isServer then
            local lastStatsArea = spec.workAreaParameters.lastStatsArea

            if lastStatsArea > 0 then
                local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
                g_farmManager:updateFarmStats( self:getLastTouchedFarmlandFarmId(), "threshedHectares" , ha)
                self:updateLastWorkedArea(lastStatsArea)
            end

            local isCutting = g_ time - spec.lastDropTime < 500
            if spec.isCutting ~ = isCutting then
                spec.isCutting = isCutting
                self:raiseDirtyFlags(spec.dirtyFlag)
                self:setCutSoundEnabled(spec.isCutting)
            end
        end

        spec.workAreaParameters.lastUsedAreasTime = spec.workAreaParameters.lastUsedAreasTime + dt
        if spec.workAreaParameters.lastUsedAreasTime > 500 then
            spec.workAreaParameters.lastUsedAreasPct = spec.workAreaParameters.lastUsedAreas / math.max(spec.workAreaParameters.lastUsedAreasSum, 0.01 )
            spec.workAreaParameters.lastUsedAreas = 0
            spec.workAreaParameters.lastUsedAreasSum = 0
            spec.workAreaParameters.lastUsedAreasTime = 0
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
function Mower:onLoad(savegame)
    local spec = self.spec_mower

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mowerEffects.mowerEffect" , "vehicle.mower.dropEffects.dropEffect" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mowerEffects.mowerEffect#mowerCutArea" , "vehicle.mower.dropEffects.dropEffect#dropAreaIndex" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.mower.turnOnNodes.turnOnNode" , "mower" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mowerStartSound" , "vehicle.turnOnVehicle.sounds.start" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mowerStopSound" , "vehicle.turnOnVehicle.sounds.stop" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.mowerSound" , "vehicle.turnOnVehicle.sounds.work" ) --FS17 to FS19

    if self.isClient then
        spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.mower.animationNodes" , self.components, self , self.i3dMappings)

        spec.samples = { }
        spec.samples.cut = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.mower.sounds" , "cut" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    end

    spec.dropEffects = { }

    self.xmlFile:iterate( "vehicle.mower.dropEffects.dropEffect" , function (_, key)
        local effects = g_effectManager:loadEffect( self.xmlFile, key, self.components, self , self.i3dMappings)
        if effects ~ = nil then
            local dropEffect = { }
            dropEffect.effects = effects
            dropEffect.dropAreaIndex = self.xmlFile:getValue(key .. "#dropAreaIndex" , 1 )
            dropEffect.workAreaIndex = self.xmlFile:getValue(key .. "#workAreaIndex" , 1 )
            if self:getWorkAreaByIndex(dropEffect.dropAreaIndex) ~ = nil then
                if self:getWorkAreaByIndex(dropEffect.workAreaIndex) ~ = nil then
                    dropEffect.activeTime = - 1
                    dropEffect.activeTimeDuration = 750
                    dropEffect.isActive = false
                    dropEffect.isActiveSent = false
                    table.insert(spec.dropEffects, dropEffect)
                else
                        Logging.xmlWarning( self.xmlFile, "Invalid workAreaIndex '%s' in '%s'" , dropEffect.workAreaIndex, key)
                    end
                else
                        Logging.xmlWarning( self.xmlFile, "Invalid dropAreaIndex '%s' in '%s'" , dropEffect.dropAreaIndex, key)
                    end
                end
            end )

            spec.cutterEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.mower.cutterEffects" , self.components, self , self.i3dMappings)

            if spec.dropAreas = = nil then
                spec.dropAreas = { }
            end

            spec.fruitTypeConverters = { }
            local converter = self.xmlFile:getValue( "vehicle.mower#fruitTypeConverter" )
            if converter ~ = nil then
                local data = g_fruitTypeManager:getConverterDataByName(converter)
                if data ~ = nil then
                    for input , converted in pairs(data) do
                        spec.fruitTypeConverters[ input ] = converted
                    end
                end
            else
                    printWarning( string.format( "Warning:Missing fruit type converter in '%s'" , self.configFileName))
                end

                spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.mower#fillUnitIndex" )
                spec.pickupFillScale = self.xmlFile:getValue( "vehicle.mower#pickupFillScale" , 1 )

                spec.toggleWindrowDropEnableText = self.xmlFile:getValue( "vehicle.mower.toggleWindrowDrop#enableText" , nil , self.customEnvironment, false )
                spec.toggleWindrowDropDisableText = self.xmlFile:getValue( "vehicle.mower.toggleWindrowDrop#disableText" , nil , self.customEnvironment, false )

                spec.toggleWindrowDropAnimation = self.xmlFile:getValue( "vehicle.mower.toggleWindrowDrop#animationName" )
                spec.enableWindrowDropAnimationSpeed = self.xmlFile:getValue( "vehicle.mower.toggleWindrowDrop#animationEnableSpeed" , 1 )
                spec.disableWindrowDropAnimationSpeed = self.xmlFile:getValue( "vehicle.mower.toggleWindrowDrop#animationDisableSpeed" , - spec.enableWindrowDropAnimationSpeed)

                spec.useWindrowDropAreas = self.xmlFile:getValue( "vehicle.mower.toggleWindrowDrop#startEnabled" , false )

                spec.workAreaParameters = { }
                spec.workAreaParameters.lastChangedArea = 0
                spec.workAreaParameters.lastStatsArea = 0
                spec.workAreaParameters.lastTotalArea = 0
                spec.workAreaParameters.lastUsedAreas = 0
                spec.workAreaParameters.lastUsedAreasSum = 0
                spec.workAreaParameters.lastUsedAreasPct = 0
                spec.workAreaParameters.lastUsedAreasTime = 0
                spec.workAreaParameters.lastCutTime = - math.huge
                spec.workAreaParameters.lastInputFruitType = FruitType.UNKNOWN
                spec.workAreaParameters.lastInputGrowthState = 0

                spec.isWorking = false
                spec.isCutting = false
                spec.lastDropTime = - math.huge

                spec.effectsAreRunning = false
                spec.lastFruitTypeIndex = FruitType.UNKNOWN
                spec.lastFruitGrowthState = 0

                spec.stoneLastState = 0
                spec.stoneWearMultiplierData = g_currentMission.stoneSystem:getWearMultiplierByType( "MOWER" )

                spec.dirtyFlag = self:getNextDirtyFlag()
                spec.effectDirtyFlag = self:getNextDirtyFlag()

                if self.addAITerrainDetailRequiredRange ~ = nil then
                    local mission = g_currentMission
                    local _, groundTypeFirstChannel, groundTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.GROUND_TYPE)

                    local grassValue = FieldGroundType.getValueByType(FieldGroundType.GRASS)
                    self:addAITerrainDetailRequiredRange(grassValue, grassValue, groundTypeFirstChannel, groundTypeNumChannels)

                    local sowingValue = FieldGroundType.getValueByType(FieldGroundType.SOWN)
                    self:addAITerrainDetailRequiredRange(sowingValue, sowingValue, groundTypeFirstChannel, groundTypeNumChannels)

                    local harvestReady = FieldGroundType.getValueByType(FieldGroundType.HARVEST_READY)
                    self:addAITerrainDetailRequiredRange(harvestReady, harvestReady, groundTypeFirstChannel, groundTypeNumChannels)
                end

                if self.addAIFruitRequirement ~ = nil then
                    for inputFruitType, _ in pairs(spec.fruitTypeConverters) do
                        local desc = g_fruitTypeManager:getFruitTypeByIndex(inputFruitType)
                        self:addAIFruitRequirement(desc.index, desc.minHarvestingGrowthState, desc.maxHarvestingGrowthState)
                    end
                end

                if #spec.cutterEffects = = 0 then
                    SpecializationUtil.removeEventListener( self , "onUpdate" , Mower )
                end
            end

```

### onPostLoad

**Description**

> Called after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Mower:onPostLoad(savegame)
    local spec = self.spec_mower
    spec.workAreas = self:getTypedWorkAreas(WorkAreaType.MOWER)
    for i = 1 , #spec.workAreas do
        local workArea = spec.workAreas[i]
        workArea.dropEffects = { }
        for _, dropEffect in pairs(spec.dropEffects) do
            if dropEffect.workAreaIndex = = workArea.index then
                table.insert(workArea.dropEffects, dropEffect)
            end
        end
    end
end

```

### onReadStream

**Description**

> Called on client side on join

**Definition**

> onReadStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function Mower:onReadStream(streamId, connection)
    local spec = self.spec_mower
    if spec.toggleWindrowDropEnableText ~ = nil and spec.toggleWindrowDropDisableText ~ = nil then
        local useMowerWindrowDropAreas = streamReadBool(streamId)
        self:setUseMowerWindrowDropAreas(useMowerWindrowDropAreas, true )
    end
end

```

### onReadUpdateStream

**Description**

> Called on on update

**Definition**

> onReadUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function Mower:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_mower

        if #spec.dropEffects > 0 then
            if streamReadBool(streamId) then
                for _, dropEffect in ipairs(spec.dropEffects) do
                    dropEffect.fillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                    self:setDropEffectEnabled(dropEffect, streamReadBool(streamId))
                end
            end
        else
                self:setCutSoundEnabled(streamReadBool(streamId))
            end

            if streamReadBool(streamId) then
                local effectsAreRunning = streamReadBool(streamId)
                if effectsAreRunning then
                    spec.lastFruitGrowthState = streamReadUIntN(streamId, 4 )

                    local inputFruitType = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)
                    if inputFruitType ~ = spec.lastFruitTypeIndex then
                        self:updateFruitExtraObjects()
                        spec.lastFruitTypeIndex = inputFruitType
                    end

                    self:setTestAreaRequirements(spec.lastFruitTypeIndex)
                end

                if effectsAreRunning ~ = spec.effectsAreRunning then
                    spec.effectsAreRunning = effectsAreRunning

                    if not effectsAreRunning then
                        g_effectManager:stopEffects(spec.cutterEffects)
                    end
                end
            end
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
function Mower:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_mower
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if spec.toggleWindrowDropEnableText ~ = nil and spec.toggleWindrowDropDisableText ~ = nil then
                local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA3, self , Mower.actionEventToggleDrop, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)
                Mower.updateActionEventToggleDrop( self )
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
function Mower:onStartWorkAreaProcessing(dt)
    local spec = self.spec_mower

    if self.isServer then
        for _, dropEffect in pairs(spec.dropEffects) do
            -- activate or deactivate dropEffect.Could be 1 frame delayed but safes a second for loop in onEndWorkAreaProcessing
                if dropEffect.isActive ~ = dropEffect.isActiveSent then
                    dropEffect.isActiveSent = dropEffect.isActive
                    self:setDropEffectEnabled(dropEffect, dropEffect.isActiveSent)
                    self:raiseDirtyFlags(spec.dirtyFlag)
                end

                dropEffect.isActive = false
            end
        end

        local workAreas = self:getTypedWorkAreas(WorkAreaType.MOWER)
        for i = 1 , #workAreas do
            local workArea = workAreas[i]
            workArea.pickedUpLiters = 0
        end

        spec.workAreaParameters.lastChangedArea = 0
        spec.workAreaParameters.lastStatsArea = 0
        spec.workAreaParameters.lastTotalArea = 0

        spec.isWorking = false
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
function Mower:onTurnedOff()
    local spec = self.spec_mower

    if self.isClient then
        for _, dropEffect in pairs(spec.dropEffects) do
            self:setDropEffectEnabled(dropEffect, false )
        end

        g_animationManager:stopAnimations(spec.animationNodes)
    end

    g_effectManager:stopEffects(spec.cutterEffects)
    spec.effectsAreRunning = false
end

```

### onTurnedOn

**Description**

> Called on turn off

**Definition**

> onTurnedOn(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function Mower:onTurnedOn()
    if self.isClient then
        local spec = self.spec_mower
        g_animationManager:startAnimations(spec.animationNodes)
    end
end

```

### onUpdate

**Description**

> Called on on update

**Definition**

> onUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | delta time                                  |
|---------|------------------|---------------------------------------------|
| boolean | isActiveForInput | true if specializations is active for input |
| boolean | isSelected       | true if specializations is selected         |
| any     | isSelected       |                                             |

**Code**

```lua
function Mower:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_mower

    if self:getIsTurnedOn() and self:getLastSpeed() > 0.5 then
        local currentTestAreaMinX, currentTestAreaMaxX, testAreaMinX, testAreaMaxX = self:getTestAreaWidthByWorkAreaIndex( 1 )

        local reset = false
        if currentTestAreaMinX = = - math.huge and currentTestAreaMaxX = = math.huge then
            currentTestAreaMinX = 0
            currentTestAreaMaxX = 0
            reset = true
        end

        if self.movingDirection > 0 then
            currentTestAreaMinX = currentTestAreaMinX * - 1
            currentTestAreaMaxX = currentTestAreaMaxX * - 1
            if currentTestAreaMaxX < currentTestAreaMinX then
                local t = currentTestAreaMinX
                currentTestAreaMinX = currentTestAreaMaxX
                currentTestAreaMaxX = t
            end
        end

        local inputFruitType, inputGrowthState
        local isActive
        if self.isServer then
            inputFruitType, inputGrowthState = FruitType.UNKNOWN, 3
            if g_ time - spec.workAreaParameters.lastCutTime < 500 then
                inputFruitType = spec.workAreaParameters.lastInputFruitType
                inputGrowthState = spec.workAreaParameters.lastInputGrowthState
            end

            isActive = not reset and inputFruitType ~ = nil and inputFruitType ~ = FruitType.UNKNOWN

            if isActive then
                if not spec.effectsAreRunning then
                    spec.effectsAreRunning = true
                    self:raiseDirtyFlags(spec.effectDirtyFlag)
                end
            else
                    if spec.effectsAreRunning then
                        g_effectManager:stopEffects(spec.cutterEffects)
                        spec.effectsAreRunning = false
                        self:raiseDirtyFlags(spec.effectDirtyFlag)
                    end
                end

                if inputFruitType ~ = spec.lastFruitTypeIndex then
                    spec.lastFruitTypeIndex = inputFruitType

                    self:updateFruitExtraObjects()
                end

                spec.lastFruitGrowthState = inputGrowthState
            else
                    inputFruitType, inputGrowthState = spec.lastFruitTypeIndex, spec.lastFruitGrowthState
                    isActive = spec.effectsAreRunning and spec.lastFruitTypeIndex ~ = FruitType.UNKNOWN
                end

                if isActive then
                    g_effectManager:setEffectTypeInfo(spec.cutterEffects, nil , inputFruitType, inputGrowthState)
                    g_effectManager:setMinMaxWidth(spec.cutterEffects, currentTestAreaMinX, currentTestAreaMaxX, currentTestAreaMinX / testAreaMinX, currentTestAreaMaxX / testAreaMaxX, reset)
                    g_effectManager:startEffects(spec.cutterEffects)
                end
            else
                    if spec.effectsAreRunning then
                        g_effectManager:stopEffects(spec.cutterEffects)
                        spec.effectsAreRunning = false
                        self:raiseDirtyFlags(spec.effectDirtyFlag)
                    end
                end
            end

```

### onWriteStream

**Description**

> Called on server side on join

**Definition**

> onWriteStream(integer streamId, Connection connection)

**Arguments**

| integer    | streamId   | streamId   |
|------------|------------|------------|
| Connection | connection | connection |

**Code**

```lua
function Mower:onWriteStream(streamId, connection)
    local spec = self.spec_mower
    if spec.toggleWindrowDropEnableText ~ = nil and spec.toggleWindrowDropDisableText ~ = nil then
        streamWriteBool(streamId, spec.useWindrowDropAreas)
    end
end

```

### onWriteUpdateStream

**Description**

> Called on on update

**Definition**

> onWriteUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function Mower:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_mower

        if #spec.dropEffects > 0 then
            if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
                for _, dropEffect in ipairs(spec.dropEffects) do
                    streamWriteUIntN(streamId, dropEffect.fillType or FillType.UNKNOWN, FillTypeManager.SEND_NUM_BITS)
                    streamWriteBool(streamId, dropEffect.isActiveSent)
                end
            end
        else
                streamWriteBool(streamId, spec.isCutting)
            end

            if streamWriteBool(streamId, bit32.band(dirtyMask, spec.effectDirtyFlag) ~ = 0 ) then
                if streamWriteBool(streamId, spec.effectsAreRunning) then
                    streamWriteUIntN(streamId, spec.lastFruitGrowthState, 4 )
                    streamWriteUIntN(streamId, spec.lastFruitTypeIndex, FruitTypeManager.SEND_NUM_BITS)
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
function Mower.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations) and SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations) and SpecializationUtil.hasSpecialization(FruitExtraObjects, specializations)
end

```

### processDropArea

**Description**

**Definition**

> processDropArea()

**Arguments**

| any | dropArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Mower:processDropArea(dropArea, dt)
    if not self.isServer and self.currentUpdateDistance > Mower.CLIENT_DM_UPDATE_RADIUS then
        return
    end

    if dropArea.litersToDrop > g_densityMapHeightManager:getMinValidLiterValue(dropArea.fillType) then
        local dropped, lineOffset
        local xs,_,zs = getWorldTranslation(dropArea.start)
        local xw,_,zw = getWorldTranslation(dropArea.width)
        local xh,_,zh = getWorldTranslation(dropArea.height)

        local f = math.random() -- any benefit from randomness in this case?
        local sx = xs + (f * (xh - xs))
        local sz = zs + (f * (zh - zs))
        local sy = getTerrainHeightAtWorldPos(g_terrainNode, sx, 0 ,sz)

        f = math.random()
        local ex = xw + (f * (xh - xs))
        local ez = zw + (f * (zh - zs))
        local ey = getTerrainHeightAtWorldPos(g_terrainNode, ex, 0 ,ez)

        dropped, lineOffset = DensityMapHeightUtil.tipToGroundAroundLine( self , dropArea.litersToDrop, dropArea.fillType, sx,sy,sz, ex,ey,ez, 0 , nil , dropArea.dropLineOffset, false , nil , false )

        dropArea.litersToDrop = dropArea.litersToDrop - dropped
        dropArea.dropLineOffset = lineOffset

        if dropped ~ = 0 then
            self.spec_mower.lastDropTime = g_ time
        end
    end
end

```

### processMowerArea

**Description**

**Definition**

> processMowerArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Mower:processMowerArea(workArea, dt)
    local spec = self.spec_mower

    if not self.isServer and self.currentUpdateDistance > Mower.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local xs,_,zs = getWorldTranslation(workArea.start)
    local xw,_,zw = getWorldTranslation(workArea.width)
    local xh,_,zh = getWorldTranslation(workArea.height)

    if self:getLastSpeed() > 1 then
        spec.isWorking = true
        spec.stoneLastState = FSDensityMapUtil.getStoneArea(xs, zs, xw, zw, xh, zh)
    else
            spec.stoneLastState = 0
        end

        local workAreaChanged, workAreaTotal = 0 , 0

        local limitToField = self:getIsAIActive()
        for inputFruitType, converterData in pairs(spec.fruitTypeConverters) do
            local changedArea, totalArea, sprayFactor, plowFactor, limeFactor, weedFactor, stubbleFactor, rollerFactor, beeYieldBonusPerc, growthState, _ = FSDensityMapUtil.updateMowerArea(inputFruitType, xs, zs, xw, zw, xh, zh, limitToField)

            if changedArea > 0 then
                local multiplier = g_currentMission:getHarvestScaleMultiplier(inputFruitType, sprayFactor, plowFactor, limeFactor, weedFactor, stubbleFactor, rollerFactor, beeYieldBonusPerc)

                local litersToDrop = g_fruitTypeManager:getFruitTypeAreaLiters(inputFruitType, changedArea, true )

                litersToDrop = litersToDrop * multiplier
                litersToDrop = litersToDrop * converterData.conversionFactor

                workArea.lastPickupLiters = litersToDrop
                workArea.pickedUpLiters = litersToDrop

                local dropArea = self:getDropArea(workArea)
                if dropArea ~ = nil then
                    dropArea.litersToDrop = dropArea.litersToDrop + litersToDrop
                    dropArea.fillType = converterData.fillTypeIndex
                    dropArea.workAreaIndex = workArea.index

                    -- if there is already dryGrass on the field and we cannot tip grass on the same spot
                        -- we pickup the dryGrass and drop it as grass again
                        if dropArea.fillType = = FillType.GRASS_WINDROW then
                            local lsx, lsy, lsz, lex, ley, lez, radius = DensityMapHeightUtil.getLineByArea(workArea.start, workArea.width, workArea.height, true )
                            local pickup
                            pickup, workArea.lineOffset = DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, FillType.DRYGRASS_WINDROW, lsx, lsy, lsz, lex, ley, lez, radius, nil , workArea.lineOffset or 0 , false , nil , false )
                            dropArea.litersToDrop = dropArea.litersToDrop - pickup
                        end

                        -- limit liters to drop so we don't buffer unlimited amount of grass
                        dropArea.litersToDrop = math.min(dropArea.litersToDrop, 1000 )
                    elseif spec.fillUnitIndex ~ = nil then
                            if self.isServer then
                                self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, litersToDrop, converterData.fillTypeIndex, ToolType.UNDEFINED)
                            end
                        end

                        spec.workAreaParameters.lastInputFruitType = inputFruitType
                        spec.workAreaParameters.lastInputGrowthState = growthState
                        spec.workAreaParameters.lastCutTime = g_ time

                        spec.workAreaParameters.lastChangedArea = spec.workAreaParameters.lastChangedArea + changedArea
                        spec.workAreaParameters.lastStatsArea = spec.workAreaParameters.lastStatsArea + totalArea
                        spec.workAreaParameters.lastTotalArea = spec.workAreaParameters.lastTotalArea + totalArea

                        spec.workAreaParameters.lastUsedAreas = spec.workAreaParameters.lastUsedAreas + 1

                        workAreaChanged = workAreaChanged + changedArea
                        workAreaTotal = totalArea

                        self:setTestAreaRequirements(inputFruitType)
                    end
                end

                spec.workAreaParameters.lastUsedAreasSum = spec.workAreaParameters.lastUsedAreasSum + 1

                return workAreaChanged, workAreaTotal
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
function Mower.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Mower )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , Mower )
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
function Mower.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processMowerArea" , Mower.processMowerArea)
    SpecializationUtil.registerFunction(vehicleType, "processDropArea" , Mower.processDropArea)
    SpecializationUtil.registerFunction(vehicleType, "getDropArea" , Mower.getDropArea)
    SpecializationUtil.registerFunction(vehicleType, "setDropEffectEnabled" , Mower.setDropEffectEnabled)
    SpecializationUtil.registerFunction(vehicleType, "setCutSoundEnabled" , Mower.setCutSoundEnabled)
    SpecializationUtil.registerFunction(vehicleType, "setUseMowerWindrowDropAreas" , Mower.setUseMowerWindrowDropAreas)
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
function Mower.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Mower.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Mower.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Mower.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Mower.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Mower.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFruitExtraObjectTypeData" , Mower.getFruitExtraObjectTypeData)
end

```

### setCutSoundEnabled

**Description**

> Enable cut sounds

**Definition**

> setCutSoundEnabled(boolean isActive)

**Arguments**

| boolean | isActive | new is active state |
|---------|----------|---------------------|

**Code**

```lua
function Mower:setCutSoundEnabled(isActive)
    if self.isClient then
        local spec = self.spec_mower

        if isActive then
            for i = 1 , #spec.samples.cut do
                if not g_soundManager:getIsSamplePlaying(spec.samples.cut[i]) then
                    g_soundManager:playSample(spec.samples.cut[i])
                end
            end
        else
                for i = 1 , #spec.samples.cut do
                    if g_soundManager:getIsSamplePlaying(spec.samples.cut[i]) then
                        g_soundManager:stopSample(spec.samples.cut[i])
                    end
                end
            end
        end
    end

```

### setDropEffectEnabled

**Description**

> Enable mower effect

**Definition**

> setDropEffectEnabled(table mowerEffect, boolean isActive)

**Arguments**

| table   | mowerEffect | mower effect        |
|---------|-------------|---------------------|
| boolean | isActive    | new is active state |

**Code**

```lua
function Mower:setDropEffectEnabled(dropEffect, isActive)
    dropEffect.isActive = isActive
    if self.isClient then
        if isActive then
            g_effectManager:setEffectTypeInfo(dropEffect.effects, dropEffect.fillType)
            g_effectManager:startEffects(dropEffect.effects)
        else
                g_effectManager:stopEffects(dropEffect.effects)
            end
        end
    end

```

### setUseMowerWindrowDropAreas

**Description**

> Toggle use of windrower drop areas

**Definition**

> setUseMowerWindrowDropAreas(boolean useMowerWindrowDropAreas, boolean noEventSend)

**Arguments**

| boolean | useMowerWindrowDropAreas | use mower windrow drop areas |
|---------|--------------------------|------------------------------|
| boolean | noEventSend              | no event send                |

**Code**

```lua
function Mower:setUseMowerWindrowDropAreas(useMowerWindrowDropAreas, noEventSend)
    local spec = self.spec_mower
    if useMowerWindrowDropAreas ~ = spec.useWindrowDropAreas then
        MowerToggleWindrowDropEvent.sendEvent( self , useMowerWindrowDropAreas, noEventSend)
        spec.useWindrowDropAreas = useMowerWindrowDropAreas

        if spec.toggleWindrowDropAnimation ~ = nil and self.playAnimation ~ = nil then
            local speed = spec.enableWindrowDropAnimationSpeed
            if not useMowerWindrowDropAreas then
                speed = spec.disableWindrowDropAnimationSpeed
            end
            self:playAnimation(spec.toggleWindrowDropAnimation, speed, nil , true )
        end
    end
end

```

### updateActionEventToggleDrop

**Description**

**Definition**

> updateActionEventToggleDrop()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Mower.updateActionEventToggleDrop( self )
    local spec = self.spec_mower
    local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
    if actionEvent ~ = nil then
        local text = string.format(spec.toggleWindrowDropDisableText, self.typeDesc)
        if not spec.useWindrowDropAreas then
            text = string.format(spec.toggleWindrowDropEnableText, self.typeDesc)
        end
        g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
    end
end

```