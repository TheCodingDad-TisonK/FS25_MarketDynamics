## SoilSampler

**Description**

> Specialization for soil samplers

**Functions**

- [actionEventSendSamples](#actioneventsendsamples)
- [actionEventStartSample](#actioneventstartsample)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getCanStartSoilSampling](#getcanstartsoilsampling)
- [getIsFoldAllowed](#getisfoldallowed)
- [getNormalizedSampleIndex](#getnormalizedsampleindex)
- [initSpecialization](#initspecialization)
- [onFoldStateChanged](#onfoldstatechanged)
- [onLeaveRootVehicle](#onleaverootvehicle)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onPreDetach](#onpredetach)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onSendSoilSamplesDialog](#onsendsoilsamplesdialog)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processSoilSampling](#processsoilsampling)
- [saveToXMLFile](#savetoxmlfile)
- [sendTakenSoilSamples](#sendtakensoilsamples)
- [setNumCollectedSoilSamples](#setnumcollectedsoilsamples)
- [startSoilSampling](#startsoilsampling)
- [updateActionEventState](#updateactioneventstate)

### actionEventSendSamples

**Description**

**Definition**

> actionEventSendSamples()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function SoilSampler.actionEventSendSamples( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if spec.numCollectedSamples > 0 and not spec.isSampling then
        InfoDialog.show(spec.texts.infoSamplesSend, SoilSampler.onSendSoilSamplesDialog, self )
    end
end

```

### actionEventStartSample

**Description**

**Definition**

> actionEventStartSample()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function SoilSampler.actionEventStartSample( self , actionName, inputValue, callbackState, isAnalog)
    local canStart, warning = self:getCanStartSoilSampling()
    if canStart then
        self:startSoilSampling()
    elseif warning ~ = nil then
            g_currentMission:showBlinkingWarning(warning, 2000 )
        end
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
function SoilSampler:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or self [ SoilSampler.SPEC_TABLE_NAME].isSampling
end

```

### getCanStartSoilSampling

**Description**

**Definition**

> getCanStartSoilSampling()

**Code**

```lua
function SoilSampler:getCanStartSoilSampling()
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    local x, _, z = getWorldTranslation(spec.samplingNode)
    local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(x, z)
    if farmlandId = = nil then -- no valid farmland, or not buyable
        return false , g_i18n:getText( "warning_youDontHaveAccessToThisLand" )
    end

    local landOwner = g_farmlandManager:getFarmlandOwner(farmlandId)
    local accessible = landOwner ~ = 0 and g_currentMission.accessHandler:canFarmAccessOtherId( self:getActiveFarm(), landOwner)
    if not accessible then
        return false , g_i18n:getText( "warning_youDontHaveAccessToThisLand" )
    end

    if self.getIsMotorStarted ~ = nil then
        if not self:getIsMotorStarted() then
            return false , g_i18n:getText( "warning_motorNotStarted" )
        end
    else
            local rootAttacherVehicle = self:getRootVehicle()
            if rootAttacherVehicle ~ = self then
                if rootAttacherVehicle.getIsMotorStarted ~ = nil then
                    if not rootAttacherVehicle:getIsMotorStarted() then
                        return false , g_i18n:getText( "warning_motorNotStarted" )
                    end
                end
            end
        end

        if self.getFoldAnimTime ~ = nil then
            local time = self:getFoldAnimTime()
            if time > spec.foldMaxLimit or time < spec.foldMinLimit then
                return false , self.spec_foldable.unfoldWarning
            end
        end

        return not self [ SoilSampler.SPEC_TABLE_NAME].isSampling
    end

```

### getIsFoldAllowed

**Description**

**Definition**

> getIsFoldAllowed()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | direction  |
| any | onAiTurnOn |

**Code**

```lua
function SoilSampler:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    return not self [ SoilSampler.SPEC_TABLE_NAME].isSampling and superFunc( self , direction, onAiTurnOn)
end

```

### getNormalizedSampleIndex

**Description**

**Definition**

> getNormalizedSampleIndex()

**Code**

```lua
function SoilSampler:getNormalizedSampleIndex()
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    local sampleIndex = spec.numCollectedSamples % #spec.visualSamples
    if spec.numCollectedSamples = = 0 then
        return 0
    else
            if sampleIndex = = 0 then
                return #spec.visualSamples
            end
        end

        return sampleIndex
    end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function SoilSampler.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "SoilSampler" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.soilSampler#node" , "Sampling Node" )
    schema:register(XMLValueType.FLOAT, "vehicle.soilSampler#radius" , "Sampling radius" , 10 )

    schema:register(XMLValueType.STRING, "vehicle.soilSampler#actionNameTake" , "Take sample input action name" , "IMPLEMENT_EXTRA" )
    schema:register(XMLValueType.STRING, "vehicle.soilSampler#actionNameSend" , "Send sample input action name" , "IMPLEMENT_EXTRA3" )

    schema:register(XMLValueType.STRING, "vehicle.soilSampler#animationName" , "Sampling animation name" )
    schema:register(XMLValueType.FLOAT, "vehicle.soilSampler#animationSpeed" , "Sampling animation speed" , 1 )

    schema:register(XMLValueType.FLOAT, "vehicle.soilSampler#foldMinLimit" , "Fold min.limit" , 0 )
    schema:register(XMLValueType.FLOAT, "vehicle.soilSampler#foldMaxLimit" , "Fold max.limit" , 1 )

    schema:register(XMLValueType.STRING, "vehicle.soilSampler.samplesAnimation#name" , "Samples animation name" )
    schema:register(XMLValueType.FLOAT, "vehicle.soilSampler.samplesAnimation#speed" , "Samples animation speed" , 1 )
    schema:register(XMLValueType.INT, "vehicle.soilSampler.samplesAnimation#minSamples" , "Min.samples" , 0 )
    schema:register(XMLValueType.INT, "vehicle.soilSampler.samplesAnimation#maxSamples" , "Max.samples" , 0 )

    schema:register(XMLValueType.FLOAT, "vehicle.soilSampler.visualSamples#updateTime" , "Update time" , 0.5 )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.soilSampler.visualSamples.visualSample(?)#node" , "Visual sample node" )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)." .. SoilSampler.SPEC_NAME .. "#numCollectedSamples" , "Num collected samples" )
end

```

### onFoldStateChanged

**Description**

**Definition**

> onFoldStateChanged()

**Arguments**

| any | direction    |
|-----|--------------|
| any | moveToMiddle |

**Code**

```lua
function SoilSampler:onFoldStateChanged(direction, moveToMiddle)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if self:getIsActiveForInput( true ) then
        spec.soilMap:setRequireMinimapDisplay(direction = = 1 , self , self:getIsSelected())
    end
end

```

### onLeaveRootVehicle

**Description**

**Definition**

> onLeaveRootVehicle()

**Code**

```lua
function SoilSampler:onLeaveRootVehicle()
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if spec.soilMap:getMinimapAdditionalElementLinkNode() = = spec.samplingNode then
        spec.soilMap:setRequireMinimapDisplay( false , self )
        spec.soilMap:setMinimapAdditionalElementLinkNode( nil )
        spec.soilMap:setMinimapSamplingState( false )
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
function SoilSampler:onLoad(savegame)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]

    local baseName = "vehicle.soilSampler"

    spec.samplingNode = self.xmlFile:getValue(baseName .. "#node" , nil , self.components, self.i3dMappings)
    spec.samplingRadius = self.xmlFile:getValue(baseName .. "#radius" , 10 )

    spec.densityMapCircle = DensityMapCircle.new()

    local actionNameTake = self.xmlFile:getValue(baseName .. "#actionNameTake" , "IMPLEMENT_EXTRA" )
    spec.inputActionTake = InputAction[actionNameTake] or InputAction.IMPLEMENT_EXTRA

    local actionNameSend = self.xmlFile:getValue(baseName .. "#actionNameSend" , "IMPLEMENT_EXTRA3" )
    spec.inputActionSend = InputAction[actionNameSend] or InputAction.IMPLEMENT_EXTRA

    spec.isSampling = false

    spec.animationName = self.xmlFile:getValue(baseName .. "#animationName" )
    spec.animationSpeed = self.xmlFile:getValue(baseName .. "#animationSpeed" , 1 )

    spec.numCollectedSamples = 0

    spec.foldMinLimit = self.xmlFile:getValue(baseName .. "#foldMinLimit" , 0 )
    spec.foldMaxLimit = self.xmlFile:getValue(baseName .. "#foldMaxLimit" , 1 )

    spec.samplesAnimation = { }
    spec.samplesAnimation.name = self.xmlFile:getValue(baseName .. ".samplesAnimation#name" )
    spec.samplesAnimation.speed = self.xmlFile:getValue(baseName .. ".samplesAnimation#speed" , 1 )
    spec.samplesAnimation.minSamples = self.xmlFile:getValue( baseName .. ".samplesAnimation#minSamples" , 0 )
    spec.samplesAnimation.maxSamples = self.xmlFile:getValue( baseName .. ".samplesAnimation#maxSamples" , 0 )

    spec.visualSampleUpdateTime = self.xmlFile:getValue(baseName .. ".visualSamples#updateTime" , 0.5 )
    spec.visualSampleUpdated = true
    spec.visualSamples = { }
    local i = 0
    while true do
        local visualSampleKey = string.format( "%s.visualSamples.visualSample(%d)" , baseName, i)
        if not self.xmlFile:hasProperty(visualSampleKey) then
            break
        end

        local node = self.xmlFile:getValue(visualSampleKey .. "#node" , nil , self.components, self.i3dMappings)
        if node ~ = nil then
            setVisibility(node, false )
            table.insert(spec.visualSamples, node)
        end

        i = i + 1
    end

    spec.texts = { }
    spec.texts.takeSample = g_i18n:getText( "action_takeSoilSample" , self.customEnvironment)
    spec.texts.sendSoilSamples = g_i18n:getText( "action_sendSoilSamples" , self.customEnvironment)
    spec.texts.numSamplesTaken = g_i18n:getText( "info_numSamplesTaken" , self.customEnvironment)
    spec.texts.infoSamplesSend = g_i18n:getText( "info_samplesSend" , self.customEnvironment)

    if g_precisionFarming ~ = nil then
        spec.soilMap = g_precisionFarming.soilMap
        spec.coverMap = g_precisionFarming.coverMap
        spec.farmlandStatistics = g_precisionFarming.farmlandStatistics
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
function SoilSampler:onPostLoad(savegame)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if savegame ~ = nil and not savegame.resetVehicles then
        local numSamples = savegame.xmlFile:getValue(savegame.key .. "." .. SoilSampler.SPEC_NAME .. "#numCollectedSamples" , spec.numCollectedSamples)
        self:setNumCollectedSoilSamples(numSamples, true )
    end
end

```

### onPreDetach

**Description**

**Definition**

> onPreDetach()

**Code**

```lua
function SoilSampler:onPreDetach()
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if spec.soilMap:getMinimapAdditionalElementLinkNode() = = spec.samplingNode then
        spec.soilMap:setRequireMinimapDisplay( false , self )
        spec.soilMap:setMinimapAdditionalElementLinkNode( nil )
        spec.soilMap:setMinimapSamplingState( false )
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
function SoilSampler:onReadStream(streamId, connection)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]

    local numSamples = streamReadUIntN(streamId, SoilSampler.SEND_NUM_BITS) or spec.numCollectedSamples
    self:setNumCollectedSoilSamples(numSamples, true )
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
function SoilSampler:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self [ SoilSampler.SPEC_TABLE_NAME]
        self:clearActionEventsTable(spec.actionEvents)
        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionTake, self , SoilSampler.actionEventStartSample, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventText(actionEventId, spec.texts.takeSample)

            _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionSend, self , SoilSampler.actionEventSendSamples, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventText(actionEventId, spec.texts.sendSoilSamples)

            SoilSampler.updateActionEventState( self )

            spec.soilMap:setRequireMinimapDisplay( self:getFoldAnimTime() > 0 , self , self:getIsSelected())
            spec.soilMap:setMinimapAdditionalElementLinkNode(spec.samplingNode)
            spec.soilMap:setMinimapAdditionalElementRealSize(spec.samplingRadius * 2 , spec.samplingRadius * 2 )
        end
    end
end

```

### onSendSoilSamplesDialog

**Description**

**Definition**

> onSendSoilSamplesDialog()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function SoilSampler.onSendSoilSamplesDialog( self )
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if spec.soilMap ~ = nil then
        -- send all samples collected by the farm with any sampler unit to the lab since we cannot only uncover for specific vehicle, only by farm
            spec.soilMap:sendSoilSamplesByFarm( self:getOwnerFarmId())
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
function SoilSampler:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    if spec.isSampling then
        if self.isClient then
            if not spec.visualSampleUpdated then
                if self:getAnimationTime(spec.animationName) > = spec.visualSampleUpdateTime then
                    local sampleIndex = self:getNormalizedSampleIndex()

                    for i = 1 , #spec.visualSamples do
                        setVisibility(spec.visualSamples[i], i < = sampleIndex)
                    end
                    spec.visualSampleUpdated = false
                end
            end
        end

        if not self:getIsAnimationPlaying(spec.animationName) then
            spec.isSampling = false
            self:setAnimationTime(spec.animationName, 0 , false )

            if spec.soilMap:getMinimapAdditionalElementLinkNode() = = spec.samplingNode then
                spec.soilMap:setMinimapSamplingState( false )
            end

            self:processSoilSampling()
            self.speedLimit = math.huge
        end
    end

    if isActiveForInputIgnoreSelection and spec.numCollectedSamples > 0 then
        g_currentMission:addExtraPrintText( string.format(spec.texts.numSamplesTaken, spec.numCollectedSamples))
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
function SoilSampler:onWriteStream(streamId, connection)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    streamWriteUIntN(streamId, spec.numCollectedSamples, SoilSampler.SEND_NUM_BITS)
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
function SoilSampler.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### processSoilSampling

**Description**

**Definition**

> processSoilSampling()

**Code**

```lua
function SoilSampler:processSoilSampling()
    if self.isServer then
        local spec = self [ SoilSampler.SPEC_TABLE_NAME]
        if spec.soilMap ~ = nil then
            local worldX, _, worldZ = getWorldTranslation(spec.samplingNode)
            spec.densityMapCircle:updateFromWorldPosition(worldX, worldZ, spec.samplingRadius, 20 )
            spec.coverMap:analyseArea(spec.densityMapCircle, nil , self:getOwnerFarmId())
        end
    end
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function SoilSampler:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    xmlFile:setValue(key .. "#numCollectedSamples" , spec.numCollectedSamples)
end

```

### sendTakenSoilSamples

**Description**

**Definition**

> sendTakenSoilSamples()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function SoilSampler:sendTakenSoilSamples(noEventSend)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]

    if self.isServer then
        if spec.soilMap ~ = nil then
            spec.soilMap:analyseSoilSamples( self:getOwnerFarmId(), spec.numCollectedSamples)
        end
    end

    if self.isClient then
        for i = 1 , #spec.visualSamples do
            setVisibility(spec.visualSamples[i], false )
        end

        self:playAnimation(spec.samplesAnimation.name, - spec.samplesAnimation.speed, self:getAnimationTime(spec.samplesAnimation.name), true )
    end

    spec.numCollectedSamples = 0
    SoilSampler.updateActionEventState( self )

    SoilSamplerSendEvent.sendEvent( self , noEventSend)
end

```

### setNumCollectedSoilSamples

**Description**

**Definition**

> setNumCollectedSoilSamples()

**Arguments**

| any | num           |
|-----|---------------|
| any | updateVisuals |

**Code**

```lua
function SoilSampler:setNumCollectedSoilSamples(num, updateVisuals)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    spec.numCollectedSamples = num or(spec.numCollectedSamples + 1 )

    if updateVisuals then
        local sampleIndex = self:getNormalizedSampleIndex()
        for j = 1 , #spec.visualSamples do
            setVisibility(spec.visualSamples[j], j < = sampleIndex)
        end

        local stopTime = (sampleIndex - spec.samplesAnimation.minSamples) / (spec.samplesAnimation.maxSamples - spec.samplesAnimation.minSamples)
        self:setAnimationTime(spec.samplesAnimation.name, stopTime, true )
    end
end

```

### startSoilSampling

**Description**

**Definition**

> startSoilSampling()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function SoilSampler:startSoilSampling(noEventSend)
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    spec.isSampling = true

    if self.isServer then
        if not self:getIsLowered( false ) then
            local attacherVehicle = self:getAttacherVehicle()
            if attacherVehicle ~ = nil then
                local jointDesc = attacherVehicle:getAttacherJointDescFromObject( self )
                if jointDesc.allowsLowering then
                    local jointDescIndex = attacherVehicle:getAttacherJointIndexFromObject( self )
                    attacherVehicle:setJointMoveDown(jointDescIndex, true , false )
                end
            end
        end

        local _, isOnField, _ = self:getPFStatisticInfo()
        if isOnField then
            self:updatePFStatistic( "numSoilSamples" , 1 )
            self:updatePFStatistic( "soilSampleCosts" , spec.soilMap:getPricePerSoilSample())
        end

        self.speedLimit = 0
    end

    self:playAnimation(spec.animationName, spec.animationSpeed, self:getAnimationTime(spec.animationName), true )

    self:setNumCollectedSoilSamples(spec.numCollectedSamples + 1 , false )

    if self:getIsActiveForInput( true ) then
        spec.soilMap:setMinimapSamplingState( true )
    end

    if self.isClient then
        if (spec.numCollectedSamples - 1 ) % #spec.visualSamples = = 0 then
            for i = 1 , #spec.visualSamples do
                setVisibility(spec.visualSamples[i], false )
            end

            self:playAnimation(spec.samplesAnimation.name, - spec.samplesAnimation.speed, self:getAnimationTime(spec.samplesAnimation.name), true )
        else
                local sampleIndex = self:getNormalizedSampleIndex()
                local stopTime = (sampleIndex - spec.samplesAnimation.minSamples) / (spec.samplesAnimation.maxSamples - spec.samplesAnimation.minSamples)
                if self:getAnimationTime(spec.samplesAnimation.name) < stopTime then
                    self:setAnimationStopTime(spec.samplesAnimation.name, stopTime)
                    self:playAnimation(spec.samplesAnimation.name, spec.samplesAnimation.speed, self:getAnimationTime(spec.samplesAnimation.name), true )
                end
            end

            spec.visualSampleUpdated = false
        end

        SoilSampler.updateActionEventState( self )

        SoilSamplerStartEvent.sendEvent( self , noEventSend)
    end

```

### updateActionEventState

**Description**

**Definition**

> updateActionEventState()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function SoilSampler.updateActionEventState( self )
    local spec = self [ SoilSampler.SPEC_TABLE_NAME]
    local actionEventSend = spec.actionEvents[spec.inputActionSend]
    if actionEventSend ~ = nil then
        g_inputBinding:setActionEventActive(actionEventSend.actionEventId, spec.numCollectedSamples > 0 )
    end
end

```