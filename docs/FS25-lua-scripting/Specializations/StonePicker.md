## StonePicker

**Description**

> Specialization for all stonePickers, requires WorkArea specialization

**Functions**

- [doCheckSpeedLimit](#docheckspeedlimit)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getCanToggleTurnedOn](#getcantoggleturnedon)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getDoGroundManipulation](#getdogroundmanipulation)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getTurnedOnNotAllowedWarning](#getturnedonnotallowedwarning)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onPostAttach](#onpostattach)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processStonePickerArea](#processstonepickerarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setStonePickerEffectsState](#setstonepickereffectsstate)

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
function StonePicker:doCheckSpeedLimit(superFunc)
    local spec = self.spec_stonePicker
    return superFunc( self ) or( self:getIsImplementChainLowered() and( not spec.needsActivation or self:getIsTurnedOn()))
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
function StonePicker:getCanBeTurnedOn(superFunc)
    local spec = self.spec_stonePicker

    local freeCapacity = self:getFillUnitFreeCapacity(spec.fillUnitIndex)
    if freeCapacity < = 0 and not self:getIsAIActive() then
        return false
    end

    return superFunc( self )
end

```

### getCanToggleTurnedOn

**Description**

**Definition**

> getCanToggleTurnedOn()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function StonePicker:getCanToggleTurnedOn(superFunc)
    local spec = self.spec_stonePicker
    if not spec.needsActivation then
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
function StonePicker.getDefaultSpeedLimit()
    return 10
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
function StonePicker:getDirtMultiplier(superFunc)
    local spec = self.spec_stonePicker

    local multiplier = superFunc( self )
    if self.movingDirection > 0 and spec.isWorking and( not spec.needsActivation or self:getIsTurnedOn()) then
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
function StonePicker:getDoGroundManipulation(superFunc)
    local spec = self.spec_stonePicker

    if not spec.isWorking then
        return false
    end

    return superFunc( self )
end

```

### getIsWorkAreaActive

**Description**

**Definition**

> getIsWorkAreaActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |

**Code**

```lua
function StonePicker:getIsWorkAreaActive(superFunc, workArea)
    if workArea.type = = WorkAreaType.STONEPICKER then
        local spec = self.spec_stonePicker

        if spec.startActivationTime > g_currentMission.time then
            return false
        end

        if spec.onlyActiveWhenLowered and self.getIsLowered ~ = nil then
            if not self:getIsLowered( false ) then
                return false
            end
        end

        local freeCapacity = self:getFillUnitFreeCapacity(spec.fillUnitIndex)
        if freeCapacity < = 0 and not self:getIsAIActive() then
            return false
        end
    end

    return superFunc( self , workArea)
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
function StonePicker:getTurnedOnNotAllowedWarning(superFunc)
    local spec = self.spec_stonePicker

    local freeCapacity = self:getFillUnitFreeCapacity(spec.fillUnitIndex)
    if freeCapacity < = 0 and not self:getIsAIActive() then
        return spec.texts.warningToolIsFull
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
function StonePicker:getWearMultiplier(superFunc)
    local spec = self.spec_stonePicker
    local multiplier = superFunc( self )

    if self.movingDirection > 0 and spec.isWorking and( not spec.needsActivation or self:getIsTurnedOn()) then
        multiplier = multiplier + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit
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
function StonePicker.initSpecialization()
    AIFieldWorker.registerDriveStrategy( function (vehicle)
        return SpecializationUtil.hasSpecialization( StonePicker , vehicle.specializations)
    end , AIDriveStrategyStonePicker )

    g_workAreaTypeManager:addWorkAreaType( "stonePicker" , true , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "StonePicker" )

    schema:register(XMLValueType.INT, "vehicle.stonePicker#fillUnitIndex" , "Index of fillunit to be used for picked stones" )
        schema:register(XMLValueType.INT, "vehicle.stonePicker#loadInfoIndex" , "Index of load info to use" )
        schema:register(XMLValueType.NODE_INDEX, "vehicle.stonePicker.directionNode#node" , "Direction node" )
        schema:register(XMLValueType.BOOL, "vehicle.stonePicker.onlyActiveWhenLowered#value" , "Only active when lowered" , true )
        schema:register(XMLValueType.BOOL, "vehicle.stonePicker.needsActivation#value" , "Needs activation" , true )

        EffectManager.registerEffectXMLPaths(schema, "vehicle.stonePicker.effects" )
        EffectManager.registerEffectXMLPaths(schema, "vehicle.stonePicker.soilEffects" )

        SoundManager.registerSampleXMLPaths(schema, "vehicle.stonePicker.sounds" , "work" )
        SoundManager.registerSampleXMLPaths(schema, "vehicle.stonePicker.sounds" , "stone" )

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
function StonePicker:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.STONEPICKER
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
function StonePicker:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.headlandsFirst = true
    fieldCourseSettings.workInitialSegment = true

    -- as the stones are only partially on the field
    fieldCourseSettings.segmentSplitDistance = 50
    fieldCourseSettings.toolAlwaysActive = true
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function StonePicker:onDeactivate()
    if self.isClient then
        local spec = self.spec_stonePicker
        g_soundManager:stopSamples(spec.samples)
        spec.isWorkSamplePlaying = false
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
function StonePicker:onDelete()
    local spec = self.spec_stonePicker
    g_soundManager:deleteSamples(spec.samples)
    g_effectManager:deleteEffects(spec.effects)
    g_effectManager:deleteEffects(spec.soilEffects)
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
function StonePicker:onEndWorkAreaProcessing(dt)
    local spec = self.spec_stonePicker

    local params = spec.workAreaParameters

    if self.isServer then
        local lastStatsArea = spec.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            self:updateLastWorkedArea(lastStatsArea)
        end

        local state = (g_ time - spec.workAreaParameters.lastChangedAreaTime) < 500
        local soilState = spec.isWorking and self.isOnField
        if spec.isEffectActive ~ = state
            or spec.effectGrowthState ~ = spec.workAreaParameters.lastGrowthState
            or soilState ~ = spec.isSoilEffectActive then
            self:setStonePickerEffectsState(state, spec.workAreaParameters.lastGrowthState, soilState)
            self:raiseDirtyFlags(spec.dirtyFlag)
        end

        if params.pickedLiters > 0 then
            local loadInfo = self:getFillVolumeLoadInfo(spec.loadInfoIndex)
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, params.pickedLiters, FillType.STONE, ToolType.UNDEFINED, loadInfo)
        end
    end
end

```

### onFillUnitFillLevelChanged

**Description**

**Definition**

> onFillUnitFillLevelChanged()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillLevelDelta   |
| any | fillType         |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function StonePicker:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_stonePicker

    if self.isServer then
        if spec.fillUnitIndex = = fillUnitIndex then
            local freeCapacity = self:getFillUnitFreeCapacity(spec.fillUnitIndex)
            if freeCapacity < = 0 and self:getIsTurnedOn() and not self:getIsAIActive() then
                self:setIsTurnedOn( false , false )
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
function StonePicker:onLoad(savegame)

    if self:getGroundReferenceNodeFromIndex( 1 ) = = nil then
        printWarning( "Warning:No ground reference nodes in " .. self.configFileName)
    end

    local spec = self.spec_stonePicker

    if self.isClient then
        spec.samples = { }
        spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.stonePicker.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.samples.stone = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.stonePicker.sounds" , "stone" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.isWorkSamplePlaying = false
        spec.isStoneSamplePlaying = false

        spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.stonePicker.effects" , self.components, self , self.i3dMappings)
        spec.soilEffects = g_effectManager:loadEffect( self.xmlFile, "vehicle.stonePicker.soilEffects" , self.components, self , self.i3dMappings)
    end

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.stonePicker#fillUnitIndex" , 1 )
    spec.loadInfoIndex = self.xmlFile:getValue( "vehicle.stonePicker#loadInfoIndex" , 1 )
    spec.directionNode = self.xmlFile:getValue( "vehicle.stonePicker.directionNode#node" , self.components[ 1 ].node, self.components, self.i3dMappings)
    spec.onlyActiveWhenLowered = self.xmlFile:getValue( "vehicle.stonePicker.onlyActiveWhenLowered#value" , true )
    spec.needsActivation = self.xmlFile:getValue( "vehicle.stonePicker.needsActivation#value" , true )

    spec.startActivationTimeout = 2000
    spec.startActivationTime = 0
    spec.hasGroundContact = false
    spec.isWorking = false
    spec.isEffectActive = false
    spec.effectGrowthState = 1
    spec.isSoilEffectActive = false

    spec.texts = { }
    spec.texts.warningToolIsFull = g_i18n:getText( "warning_toolIsFull" )

    spec.workAreaParameters = { }
    spec.workAreaParameters.angle = 0
    spec.workAreaParameters.pickedLiters = 0
    spec.workAreaParameters.lastChangedArea = 0
    spec.workAreaParameters.lastChangedAreaTime = - math.huge
    spec.workAreaParameters.lastGrowthState = 1
    spec.workAreaParameters.lastStatsArea = 0
    spec.workAreaParameters.lastTotalArea = 0

    if self.isServer then
        local firstSowableValue, lastSowableValue = g_currentMission.fieldGroundSystem:getSowableRange()
        self:addAITerrainDetailRequiredRange(firstSowableValue, lastSowableValue)

        if g_currentMission.stoneSystem ~ = nil then
            local stoneMapId, stoneFirstChannel, stoneNumChannels = g_currentMission.stoneSystem:getDensityMapData()
            local minValue, maxValue = g_currentMission.stoneSystem:getMinMaxValues()

            self:addAIFruitRequirement( nil , minValue, maxValue, stoneMapId, stoneFirstChannel, stoneNumChannels)
        end
    end

    spec.dirtyFlag = self:getNextDirtyFlag()
end

```

### onPostAttach

**Description**

> Called if vehicle gets attached

**Definition**

> onPostAttach(table attacherVehicle, integer inputJointDescIndex, integer jointDescIndex)

**Arguments**

| table   | attacherVehicle     | attacher vehicle                            |
|---------|---------------------|---------------------------------------------|
| integer | inputJointDescIndex | index of input attacher joint               |
| integer | jointDescIndex      | index of attacher joint it gets attached to |

**Code**

```lua
function StonePicker:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_stonePicker
    spec.startActivationTime = g_currentMission.time + spec.startActivationTimeout
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
function StonePicker:onReadStream(streamId, connection)
    local state = streamReadBool(streamId)
    local growthState = streamReadUIntN(streamId, 2 )
    local stateSoil = streamReadBool(streamId)
    self:setStonePickerEffectsState(state, growthState, stateSoil)
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
function StonePicker:onReadUpdateStream(streamId, timestamp, connection)
    if connection.isServer then
        if streamReadBool(streamId) then
            local state = streamReadBool(streamId)
            local growthState = streamReadUIntN(streamId, 2 )
            local stateSoil = streamReadBool(streamId)
            self:setStonePickerEffectsState(state, growthState, stateSoil)
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
function StonePicker:onStartWorkAreaProcessing(dt)
    local spec = self.spec_stonePicker

    spec.isWorking = false

    local dx,_,dz = localDirectionToWorld(spec.directionNode, 0 , 0 , 1 )
    local angle = FSDensityMapUtil.convertToDensityMapAngle( MathUtil.getYRotationFromDirection(dx, dz), g_currentMission.fieldGroundSystem:getGroundAngleMaxValue())

    spec.workAreaParameters.isActive = not spec.needsActivation or self:getIsTurnedOn()
    spec.workAreaParameters.angle = angle
    spec.workAreaParameters.pickedLiters = 0
    spec.workAreaParameters.lastChangedArea = 0
    spec.workAreaParameters.lastStatsArea = 0
    spec.workAreaParameters.lastTotalArea = 0
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
function StonePicker:onWriteStream(streamId, connection)
    local spec = self.spec_stonePicker
    streamWriteBool(streamId, spec.isEffectActive)
    streamWriteUIntN(streamId, spec.effectGrowthState, 2 )
    streamWriteBool(streamId, spec.isSoilEffectActive)
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
function StonePicker:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection.isServer then
        local spec = self.spec_stonePicker
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteBool(streamId, spec.isEffectActive)
            streamWriteUIntN(streamId, spec.effectGrowthState, 2 )
            streamWriteBool(streamId, spec.isSoilEffectActive)
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
function StonePicker.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations)
    and SpecializationUtil.hasSpecialization( WorkArea , specializations)
end

```

### processStonePickerArea

**Description**

**Definition**

> processStonePickerArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function StonePicker:processStonePickerArea(workArea, dt)
    local spec = self.spec_stonePicker

    if not spec.workAreaParameters.isActive then
        return 0 , 0
    end

    local xs,_,zs = getWorldTranslation(workArea.start)
    local xw,_,zw = getWorldTranslation(workArea.width)
    local xh,_,zh = getWorldTranslation(workArea.height)

    FSDensityMapUtil.eraseTireTrack(xs,zs, xw,zw, xh,zh)

    if not self.isServer and self.currentUpdateDistance > StonePicker.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local params = spec.workAreaParameters

    local stoneFactor, touchedArea, totalArea = FSDensityMapUtil.updateStonePickerArea(xs,zs, xw,zw, xh,zh, params.angle)
    local litersPerSqm = g_currentMission.stoneSystem:getLitersPerSqm()
    local sqm = g_currentMission:getFruitPixelsToSqm() * touchedArea
    local liters = sqm * litersPerSqm * stoneFactor

    params.pickedLiters = params.pickedLiters + liters
    params.lastChangedArea = params.lastChangedArea + touchedArea
    params.lastStatsArea = params.lastStatsArea + touchedArea
    params.lastTotalArea = params.lastTotalArea + totalArea
    if touchedArea > 0 then
        params.lastChangedAreaTime = g_ time
        params.lastGrowthState = math.clamp( math.floor(stoneFactor + 0.49 ), 1 , 3 )
    end

    spec.isWorking = self:getLastSpeed() > 0.5

    return touchedArea, totalArea
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
function StonePicker.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , StonePicker )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , StonePicker )
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
function StonePicker.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processStonePickerArea" , StonePicker.processStonePickerArea)
    SpecializationUtil.registerFunction(vehicleType, "setStonePickerEffectsState" , StonePicker.setStonePickerEffectsState)
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
function StonePicker.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , StonePicker.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoGroundManipulation" , StonePicker.getDoGroundManipulation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , StonePicker.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , StonePicker.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , StonePicker.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , StonePicker.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , StonePicker.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getTurnedOnNotAllowedWarning" , StonePicker.getTurnedOnNotAllowedWarning)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleTurnedOn" , StonePicker.getCanToggleTurnedOn)
end

```

### setStonePickerEffectsState

**Description**

**Definition**

> setStonePickerEffectsState()

**Arguments**

| any | state       |
|-----|-------------|
| any | growthState |
| any | stateSoil   |

**Code**

```lua
function StonePicker:setStonePickerEffectsState(state, growthState, stateSoil)
    local spec = self.spec_stonePicker
    if state ~ = spec.isEffectActive or growthState ~ = spec.effectGrowthState or stateSoil ~ = spec.isSoilEffectActive then
        spec.isEffectActive = state
        spec.effectGrowthState = growthState
        spec.isSoilEffectActive = stateSoil

        if self.isClient then
            if state then
                g_effectManager:setEffectTypeInfo(spec.effects, FillType.STONE, nil , growthState)
                g_effectManager:startEffects(spec.effects)

                if not spec.isStoneSamplePlaying then
                    g_soundManager:playSample(spec.samples.stone)
                    spec.isStoneSamplePlaying = true
                end
            else
                    g_effectManager:stopEffects(spec.effects)

                    if spec.isStoneSamplePlaying then
                        g_soundManager:stopSample(spec.samples.stone)
                        spec.isStoneSamplePlaying = false
                    end
                end

                if stateSoil then
                    g_effectManager:startEffects(spec.soilEffects)

                    if not spec.isWorkSamplePlaying then
                        g_soundManager:playSample(spec.samples.work)
                        spec.isWorkSamplePlaying = true
                    end
                else
                        g_effectManager:stopEffects(spec.soilEffects)

                        if spec.isWorkSamplePlaying then
                            g_soundManager:stopSample(spec.samples.work)
                            spec.isWorkSamplePlaying = false
                        end
                    end
                end
            end
        end

```