## ExtendedSprayer

**Description**

> Specialization to control the sprayer usage depending on the soil

**Functions**

- [actionEventChangeDefaultFruitRequirement](#actioneventchangedefaultfruitrequirement)
- [actionEventChangeSprayAmount](#actioneventchangesprayamount)
- [actionEventToggleAuto](#actioneventtoggleauto)
- [changeSeedIndex](#changeseedindex)
- [getCurrentNitrogenLevelOffset](#getcurrentnitrogenleveloffset)
- [getCurrentNitrogenUsageLevelOffset](#getcurrentnitrogenusageleveloffset)
- [getCurrentSprayerMode](#getcurrentsprayermode)
- [getFillTypeSourceVehicle](#getfilltypesourcevehicle)
- [getIsPrecisionSprayingRequired](#getisprecisionsprayingrequired)
- [getIsUsingExactNitrogenAmount](#getisusingexactnitrogenamount)
- [getIsVehicleValid](#getisvehiclevalid)
- [getShowExtendedSprayerHudExtension](#getshowextendedsprayerhudextension)
- [getSprayerDoubledAmountActive](#getsprayerdoubledamountactive)
- [getSprayerUsage](#getsprayerusage)
- [getUseExtendedSprayerHudExtension](#getuseextendedsprayerhudextension)
- [getValidSprayerToUse](#getvalidsprayertouse)
- [initSpecialization](#initspecialization)
- [onChangedFillType](#onchangedfilltype)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onStateChange](#onstatechange)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onVariableWorkWidthSectionChanged](#onvariableworkwidthsectionchanged)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [preProcessExtUnderRootFertilizerArea](#preprocessextunderrootfertilizerarea)
- [prerequisitesPresent](#prerequisitespresent)
- [processSprayerArea](#processsprayerarea)
- [saveToXMLFile](#savetoxmlfile)
- [setSprayAmountAutoFruitTypeIndex](#setsprayamountautofruittypeindex)
- [setSprayAmountAutoMode](#setsprayamountautomode)
- [setSprayAmountDefaultFruitRequirementIndex](#setsprayamountdefaultfruitrequirementindex)
- [setSprayAmountManualValue](#setsprayamountmanualvalue)
- [setSprayerAITerrainDetailProhibitedRange](#setsprayeraiterraindetailprohibitedrange)
- [updateActionEventAutoModeDefault](#updateactioneventautomodedefault)
- [updateActionEventState](#updateactioneventstate)
- [updateDebugValues](#updatedebugvalues)
- [updateExtendedSprayerNozzleEffectState](#updateextendedsprayernozzleeffectstate)
- [updateMinimapActiveState](#updateminimapactivestate)
- [updateSprayerEffects](#updatesprayereffects)
- [updateSprayerEffectState](#updatesprayereffectstate)
- [updateWorkAreaWidth](#updateworkareawidth)

### actionEventChangeDefaultFruitRequirement

**Description**

**Definition**

> actionEventChangeDefaultFruitRequirement()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function ExtendedSprayer.actionEventChangeDefaultFruitRequirement( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    self:setSprayAmountDefaultFruitRequirementIndex(spec.nitrogenMap:getNextFruitRequirementIndex(spec.nApplyAutoModeFruitRequirementDefaultIndex))
end

```

### actionEventChangeSprayAmount

**Description**

**Definition**

> actionEventChangeSprayAmount()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function ExtendedSprayer.actionEventChangeSprayAmount( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    self:setSprayAmountManualValue(spec.sprayAmountManual + math.sign(inputValue))
end

```

### actionEventToggleAuto

**Description**

**Definition**

> actionEventToggleAuto()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function ExtendedSprayer.actionEventToggleAuto( self , actionName, inputValue, callbackState, isAnalog)
    self:setSprayAmountAutoMode()
end

```

### changeSeedIndex

**Description**

**Definition**

> changeSeedIndex()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | ...       |

**Code**

```lua
function ExtendedSprayer:changeSeedIndex(superFunc, .. .)
    superFunc( self , .. .)

    -- update nitrogen requirements data in ui without need to move
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    spec.lastGroundUpdateDistance = math.huge
end

```

### getCurrentNitrogenLevelOffset

**Description**

**Definition**

> getCurrentNitrogenLevelOffset()

**Arguments**

| any | lastChangeLevels |
|-----|------------------|

**Code**

```lua
function ExtendedSprayer:getCurrentNitrogenLevelOffset(lastChangeLevels)
    return 0
end

```

### getCurrentNitrogenUsageLevelOffset

**Description**

**Definition**

> getCurrentNitrogenUsageLevelOffset()

**Arguments**

| any | lastChangeLevels |
|-----|------------------|

**Code**

```lua
function ExtendedSprayer:getCurrentNitrogenUsageLevelOffset(lastChangeLevels)
    return 0
end

```

### getCurrentSprayerMode

**Description**

**Definition**

> getCurrentSprayerMode()

**Code**

```lua
function ExtendedSprayer:getCurrentSprayerMode()
    local sprayer, fillUnitIndex = ExtendedSprayer.getFillTypeSourceVehicle( self )
    local fillType = sprayer:getFillUnitFillType(fillUnitIndex)

    if fillType = = FillType.UNKNOWN then
        -- ai worker will always fertilze by default, if nothing is filled
            if self:getIsAIActive() then
                return false , true
            end

            fillType = sprayer:getFillUnitLastValidFillType(fillUnitIndex)
        end

        if fillType = = FillType.LIME then
            return true , false
        end

        local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
        if spec.nitrogenMap:getFillTypeIsFertilizer(fillType) then
            return false , true
        end

        if fillType = = FillType.HERBICIDE then
            return false , false
        end

        return false , false
    end

```

### getFillTypeSourceVehicle

**Description**

**Definition**

> getFillTypeSourceVehicle()

**Arguments**

| any | sprayer |
|-----|---------|

**Code**

```lua
function ExtendedSprayer.getFillTypeSourceVehicle(sprayer)
    -- check the valid sprayer if he has a fill type source to consume from, otherwise hide the display
        local firstEmptySource, firstEmptySourceFillUnitIndex = nil , 1

        local fillUnitIndex = sprayer:getSprayerFillUnitIndex()
        if sprayer:getFillUnitFillLevel(fillUnitIndex) < = 0 then
            local spec = sprayer.spec_sprayer
            for _, supportedSprayType in ipairs(spec.supportedSprayTypes) do
                for _, src in ipairs(spec.fillTypeSources[supportedSprayType]) do
                    local vehicle = src.vehicle
                    local fillLevel = vehicle:getFillUnitFillLevel(src.fillUnitIndex)
                    if vehicle:getFillUnitFillType(src.fillUnitIndex) = = supportedSprayType then
                        if fillLevel > 0 then
                            return vehicle, src.fillUnitIndex
                        end
                    elseif fillLevel = = 0 and vehicle:getFillUnitSupportsFillType(src.fillUnitIndex, supportedSprayType) then
                            firstEmptySource = vehicle
                            firstEmptySourceFillUnitIndex = src.fillUnitIndex
                        end
                    end
                end
            end

            if sprayer:getIsAIActive() and sprayer:getFillUnitCapacity(fillUnitIndex) = = 0 then
                return firstEmptySource or sprayer, firstEmptySourceFillUnitIndex or fillUnitIndex
            end

            return sprayer, fillUnitIndex
        end

```

### getIsPrecisionSprayingRequired

**Description**

**Definition**

> getIsPrecisionSprayingRequired()

**Code**

```lua
function ExtendedSprayer:getIsPrecisionSprayingRequired()
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    if spec.isDoingMissionWork then
        return true
    end

    if spec.sprayAmountAutoMode then
        local dataUncovered = false
        for _, workArea in pairs(spec.workAreas) do
            if workArea.isPrecisionFarmingDataUncovered then
                dataUncovered = true
                break
            end
        end

        if not dataUncovered then
            return true
        end

        if not spec.pwmEnabled then
            if spec.isLiming then
                if spec.phActualValue > = spec.phTargetValue then
                    return false
                end
            elseif spec.isFertilizing then
                    if spec.nActualValue > = spec.nTargetValue then
                        return false
                    end
                end
            end
        end

        return true
    end

```

### getIsUsingExactNitrogenAmount

**Description**

**Definition**

> getIsUsingExactNitrogenAmount()

**Code**

```lua
function ExtendedSprayer:getIsUsingExactNitrogenAmount()
    return true
end

```

### getIsVehicleValid

**Description**

**Definition**

> getIsVehicleValid()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function ExtendedSprayer.getIsVehicleValid(vehicle)
    if not SpecializationUtil.hasSpecialization( ExtendedSprayer , vehicle.specializations) then
        return false
    end

    if not SpecializationUtil.hasSpecialization( WorkArea , vehicle.specializations) then
        return false
    end

    if #vehicle.spec_workArea.workAreas = = 0 then
        return false
    end

    if SpecializationUtil.hasSpecialization( ManureBarrel , vehicle.specializations) and vehicle.spec_manureBarrel.attachedTool ~ = nil then
        return false
    end

    return true
end

```

### getShowExtendedSprayerHudExtension

**Description**

**Definition**

> getShowExtendedSprayerHudExtension()

**Code**

```lua
function ExtendedSprayer:getShowExtendedSprayerHudExtension()
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if not self.isClient then
        return false
    end

    if self.spec_manureBarrel ~ = nil and self.spec_manureBarrel.attachedTool ~ = nil then
        return false
    end

    if not spec.isSlurryTanker and not spec.isManureSpreader then
        local sourceVehicle, sourceFillUnitIndex = ExtendedSprayer.getFillTypeSourceVehicle( self )
        if sourceVehicle:getFillUnitFillLevel(sourceFillUnitIndex) < = 0 then
            if not self:getIsAIActive() then
                return false
            end
        end

        if not spec.isLiming and not spec.isFertilizing then
            return false
        end
    end

    return true
end

```

### getSprayerDoubledAmountActive

**Description**

**Definition**

> getSprayerDoubledAmountActive()

**Arguments**

| any | superFunc      |
|-----|----------------|
| any | sprayTypeIndex |

**Code**

```lua
function ExtendedSprayer:getSprayerDoubledAmountActive(superFunc, sprayTypeIndex)
    -- disable double application rate since we can precisely set the application amount
    return false , false
end

```

### getSprayerUsage

**Description**

**Definition**

> getSprayerUsage()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | fillType  |
| any | dt        |

**Code**

```lua
function ExtendedSprayer:getSprayerUsage(superFunc, fillType, dt)
    local usage = superFunc( self , fillType, dt)

    if self:getIsTurnedOn() then
        local specSpray = self.spec_sprayer
        local usageScale = specSpray.usageScale
        local activeSprayType = self:getActiveSprayType()
        if activeSprayType ~ = nil then
            usageScale = activeSprayType.usageScale
        end

        local workWidth
        if usageScale.workAreaIndex ~ = nil then
            workWidth = self:getWorkAreaWidth(usageScale.workAreaIndex)
        else
                workWidth = usageScale.workingWidth
            end

            local lastSpeed = math.max( self:getLastSpeed(), 1 ) -- don't stop usage while player stops, but sprayer still turned on

                local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

                local dataUncovered = false
                for _, workArea in pairs(spec.workAreas) do
                    if workArea.isPrecisionFarmingDataUncovered then
                        dataUncovered = true
                        break
                    end
                end

                local minRate = spec.sprayAmountAutoMode and 0 or 1
                if spec.isLiming then
                    if spec.pHMap ~ = nil then
                        local changeValue
                        if spec.sprayAmountAutoMode then
                            if spec.pwmEnabled then
                                local accumulatedChange, numSections = 0 , 0
                                for _, workArea in pairs(spec.workAreas) do
                                    if workArea.numSubSections > 0 then
                                        for _, subSectionData in ipairs(workArea.subSectionData) do
                                            accumulatedChange = accumulatedChange + math.max(subSectionData.phTargetLevel - subSectionData.phLevel, 0 )
                                            numSections = numSections + 1
                                        end
                                    end
                                end

                                if numSections > 0 then
                                    changeValue = accumulatedChange / numSections
                                else
                                        changeValue = 0
                                    end
                                else
                                        changeValue = math.ceil(spec.phTargetValue - spec.phActualValue)

                                        if spec.pHMap.realisticSpreadOutputEnabled and not spec.speedDependentApplication then
                                            lastSpeed = self:getRawSpeedLimit()
                                        end
                                    end

                                    if not dataUncovered then
                                        changeValue = spec.pHMap:getDefaultLimeStateChange()
                                    end
                                else
                                        changeValue = math.max(spec.sprayAmountManual, 1 )

                                        if spec.pHMap.realisticSpreadOutputEnabled and not spec.speedDependentApplication then
                                            lastSpeed = self:getRawSpeedLimit()
                                        end
                                    end

                                    if self.getNumExtendedSprayerNozzleEffectsActive ~ = nil then
                                        local _, alpha = self:getNumExtendedSprayerNozzleEffectsActive()
                                        changeValue = changeValue * alpha
                                    end

                                    local litersPerUpdate, literPerHectar, regularUsage = spec.pHMap:getLimeUsage(workWidth, lastSpeed, changeValue, dt)

                                    spec.lastRegularUsage = regularUsage
                                    usage = litersPerUpdate
                                    spec.lastLitersPerHectar = literPerHectar
                                    spec.lastNitrogenProportion = 0
                                end
                            elseif spec.isFertilizing then
                                    if spec.nitrogenMap ~ = nil then
                                        if not spec.isDoingMissionWork then
                                            local sprayVehicle = specSpray.workAreaParameters.sprayVehicle
                                            if sprayVehicle = = nil then
                                                sprayVehicle = ExtendedSprayer.getFillTypeSourceVehicle( self )
                                            end

                                            local changeValue
                                            if spec.sprayAmountAutoMode then
                                                if spec.pwmEnabled then
                                                    local accumulatedChange, numSections = 0 , 0
                                                    for _, workArea in pairs(spec.sprayerWorkAreas) do
                                                        if workArea.numSubSections > 0 then
                                                            for _, subSectionData in ipairs(workArea.subSectionData) do
                                                                accumulatedChange = accumulatedChange + math.max(subSectionData.nitrogenTargetLevel - subSectionData.nitrogenLevel, 0 )
                                                                numSections = numSections + 1
                                                            end
                                                        end
                                                    end
                                                    for _, workArea in pairs(spec.sowingMachineWorkAreas) do
                                                        if workArea.numSubSections > 0 then
                                                            for _, subSectionData in ipairs(workArea.subSectionData) do
                                                                accumulatedChange = accumulatedChange + math.max(subSectionData.nitrogenTargetLevel - subSectionData.nitrogenLevel, 0 )
                                                                numSections = numSections + 1
                                                            end
                                                        end
                                                    end

                                                    if numSections > 0 then
                                                        changeValue = accumulatedChange / numSections
                                                    else
                                                            changeValue = 0
                                                        end
                                                    else
                                                            changeValue = math.ceil(spec.nTargetValue - spec.nActualValue)

                                                            if spec.pHMap.realisticSpreadOutputEnabled and not spec.speedDependentApplication then
                                                                lastSpeed = self:getRawSpeedLimit()
                                                            end
                                                        end

                                                        if not dataUncovered then
                                                            changeValue = spec.nitrogenMap:getDefaultNitrogenStateChange()
                                                        end
                                                    else
                                                            changeValue = math.max(spec.sprayAmountManual, 1 )

                                                            if spec.pHMap.realisticSpreadOutputEnabled and not spec.speedDependentApplication then
                                                                lastSpeed = self:getRawSpeedLimit()
                                                            end
                                                        end

                                                        if self.getNumExtendedSprayerNozzleEffectsActive ~ = nil then
                                                            local _, alpha = self:getNumExtendedSprayerNozzleEffectsActive()
                                                            changeValue = changeValue * alpha
                                                        end

                                                        local nitrogenUsageLevelOffset = (sprayVehicle ~ = nil and sprayVehicle.getCurrentNitrogenUsageLevelOffset ~ = nil ) and sprayVehicle:getCurrentNitrogenUsageLevelOffset(changeValue) or 0
                                                        local litersPerUpdate, literPerHectar, regularUsage, nitrogenProportion = spec.nitrogenMap:getFertilizerUsage(workWidth, lastSpeed, math.max(changeValue, minRate), fillType, dt, spec.sprayAmountAutoMode, spec.nApplyAutoModeFruitType, spec.nActualValue, nitrogenUsageLevelOffset)

                                                        spec.lastRegularUsage = regularUsage
                                                        usage = litersPerUpdate
                                                        spec.lastLitersPerHectar = literPerHectar
                                                        spec.lastNitrogenProportion = nitrogenProportion
                                                    else
                                                            -- keep default spray rate for mission work
                                                                spec.lastRegularUsage = usage
                                                                spec.lastLitersPerHectar = usage / dt * ( 10000 / workWidth) / ( self.speedLimit / 3600 )
                                                                spec.lastNitrogenProportion = 0
                                                            end
                                                        end
                                                    end

                                                    -- use a min.amount of usage to keep the ai going, otherwise he will not work since the usage is the fillLevel while it's active
                                                        if self:getIsAIActive() and usage = = 0 then
                                                            usage = 0.0001
                                                        end
                                                    end

                                                    return usage
                                                end

```

### getUseExtendedSprayerHudExtension

**Description**

**Definition**

> getUseExtendedSprayerHudExtension()

**Code**

```lua
function ExtendedSprayer:getUseExtendedSprayerHudExtension()
    if not SpecializationUtil.hasSpecialization( WorkArea , self.specializations) then
        return false
    end

    if # self.spec_workArea.workAreas = = 0 then
        return false
    end

    return true
end

```

### getValidSprayerToUse

**Description**

**Definition**

> getValidSprayerToUse()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function ExtendedSprayer.getValidSprayerToUse( self )
    local vehicleList = self.rootVehicle.childVehicles
    for i = 1 , #vehicleList do
        local subVehicle = vehicleList[i]
        if ExtendedSprayer.getIsVehicleValid(subVehicle) then
            return subVehicle
        end
    end

    return nil
end

```

### initSpecialization

**Description**

> Called while initializing the specialization

**Definition**

> initSpecialization()

**Code**

```lua
function ExtendedSprayer.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "pulseWidthModulation" , g_i18n:getText( "configuration_pulseWidthModulation" ), "sprayer" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ExtendedSprayer" )

    schema:register(XMLValueType.BOOL, "vehicle.sprayer.pulseWidthModulationConfigurations#isAlwaysActive" , "Pulse width modulation is always active" , false )
    schema:register(XMLValueType.BOOL, "vehicle.sprayer.speedDependentApplication#isSupported" , "Spreader / sprayer does automatically reduce the application rate while driving slower" , "by default supported on all except sprayers" )

        schema:setXMLSpecializationType()
    end

```

### onChangedFillType

**Description**

**Definition**

> onChangedFillType()

**Arguments**

| any | fillUnitIndex    |
|-----|------------------|
| any | fillTypeIndex    |
| any | oldFillTypeIndex |

**Code**

```lua
function ExtendedSprayer:onChangedFillType(fillUnitIndex, fillTypeIndex, oldFillTypeIndex)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    if spec.isSolidFertilizerSprayer and fillTypeIndex = = FillType.LIME then
        local _, _, pHMaxValue = spec.pHMap:getMinMaxValue()
        spec.sprayAmountManualMax = pHMaxValue - 1
    else
            local _, _, nMaxValue = spec.nitrogenMap:getMinMaxValue()
            spec.sprayAmountManualMax = nMaxValue - 1
        end
    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function ExtendedSprayer:onDelete()
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    if spec.hudExtension ~ = nil then
        spec.hudExtension:delete()
    end
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
function ExtendedSprayer:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    local specSprayer = self.spec_sprayer

    if self.isServer then
        if specSprayer.workAreaParameters.isActive then
            local sprayVehicle = specSprayer.workAreaParameters.sprayVehicle
            local usage = specSprayer.workAreaParameters.usage
            local fillType = specSprayer.workAreaParameters.sprayFillType

            if sprayVehicle ~ = nil or self:getIsAIActive() then
                if self:getIsTurnedOn() then
                    local usageRegular = spec.lastRegularUsage

                    if fillType = = FillType.LIME then
                        self:updatePFStatistic( "usedLime" , usage)
                        self:updatePFStatistic( "usedLimeRegular" , usageRegular)
                    elseif fillType = = FillType.FERTILIZER then
                            self:updatePFStatistic( "usedMineralFertilizer" , usage)
                            self:updatePFStatistic( "usedMineralFertilizerRegular" , usageRegular)
                        elseif fillType = = FillType.LIQUIDFERTILIZER then
                                self:updatePFStatistic( "usedLiquidFertilizer" , usage)
                                self:updatePFStatistic( "usedLiquidFertilizerRegular" , usageRegular)
                            elseif fillType = = FillType.MANURE then
                                    self:updatePFStatistic( "usedManure" , usage)
                                    self:updatePFStatistic( "usedManureRegular" , usageRegular)
                                elseif fillType = = FillType.LIQUIDMANURE or fillType = = FillType.DIGESTATE then
                                        self:updatePFStatistic( "usedLiquidManure" , usage)
                                        self:updatePFStatistic( "usedLiquidManureRegular" , usageRegular)
                                    end
                                end
                            end
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
function ExtendedSprayer:onPostLoad(savegame)
    if savegame ~ = nil and not savegame.resetVehicles then
        local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
        local specName = ExtendedSprayer.SPEC_NAME
        self:setSprayAmountAutoMode( Utils.getNoNil(savegame.xmlFile:getBool(savegame.key .. "." .. specName .. "#sprayAmountAutoMode" ), spec.sprayAmountAutoMode), true )
        self:setSprayAmountManualValue(savegame.xmlFile:getInt(savegame.key .. "." .. specName .. "#sprayAmountManual" ) or spec.sprayAmountManual, true )
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
function ExtendedSprayer:onReadStream(streamId, connection)
    local sprayAmountAutoMode = streamReadBool(streamId)
    local sprayAmountManual = streamReadUIntN(streamId, NitrogenMap.NUM_BITS)

    self:setSprayAmountAutoMode(sprayAmountAutoMode, true )
    self:setSprayAmountManualValue(sprayAmountManual, true )
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
function ExtendedSprayer:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

        if streamReadBool(streamId) then
            spec.phActualValue = streamReadUIntN(streamId, PHMap.NUM_BITS)
            spec.phTargetValue = streamReadUIntN(streamId, PHMap.NUM_BITS)

            spec.nActualValue = streamReadUIntN(streamId, NitrogenMap.NUM_BITS)
            spec.nTargetValue = streamReadUIntN(streamId, NitrogenMap.NUM_BITS)

            spec.lastTouchedSoilType = streamReadUIntN(streamId, 3 )

            if streamReadBool(streamId) then
                self:setSprayAmountAutoFruitTypeIndex(streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS))
            else
                    self:setSprayAmountAutoFruitTypeIndex( nil )
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
function ExtendedSprayer:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
        self:clearActionEventsTable(spec.actionEvents)
        spec.pHMap:setRequireMinimapDisplay( false , self )
        spec.nitrogenMap:setRequireMinimapDisplay( false , self )
        if isActiveForInputIgnoreSelection then
            if self = = ExtendedSprayer.getValidSprayerToUse( self ) then
                if spec.sprayAmountAutoModeChangeAllowed then
                    local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionToggleAuto, self , ExtendedSprayer.actionEventToggleAuto, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
                end

                local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionToggleSprayAmount, self , ExtendedSprayer.actionEventChangeSprayAmount, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
                g_inputBinding:setActionEventText(actionEventId, spec.texts.toggleSprayAmountAutoManual)

                if self.spec_sowingMachine = = nil then
                    _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_SEEDS, self , ExtendedSprayer.actionEventChangeDefaultFruitRequirement, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
                    g_inputBinding:setActionEventText(actionEventId, spec.texts.toggleSprayDefaultFruitRequirement)
                end

                ExtendedSprayer.updateActionEventState( self )
                ExtendedSprayer.updateActionEventAutoModeDefault( self )
                ExtendedSprayer.updateMinimapActiveState( self )
            end
        end

        spec.attachStateChanged = true
    end
end

```

### onStateChange

**Description**

**Definition**

> onStateChange()

**Arguments**

| any | state |
|-----|-------|
| any | data  |

**Code**

```lua
function ExtendedSprayer:onStateChange(state, data)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if state = = VehicleStateChange.ATTACH or state = = VehicleStateChange.DETACH then
        spec.attachStateChanged = true
    end
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function ExtendedSprayer:onTurnedOff()
    if self.isClient then
        ExtendedSprayer.updateSprayerEffectState( self , true )
    end
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function ExtendedSprayer:onTurnedOn()
    if self.isClient then
        ExtendedSprayer.updateSprayerEffectState( self , true )
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
function ExtendedSprayer:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if self.isServer then
        if not self.finishedFirstUpdate then
            spec.isLiming, spec.isFertilizing = self:getCurrentSprayerMode()
            ExtendedSprayer.updateActionEventState( self )
            ExtendedSprayer.updateActionEventAutoModeDefault( self )
        end

        if self.finishedFirstUpdate then
            spec.lastGroundUpdateDistance = spec.lastGroundUpdateDistance + self.lastMovedDistance
            if spec.lastGroundUpdateDistance > spec.groundUpdateDistance then
                spec.lastGroundUpdateDistance = 0

                --#profile RemoteProfiler.zoneBeginN("ExtendedSprayer:updateWorkAreaSubSectionData")
                for _, workArea in pairs(spec.sprayerWorkAreas) do
                    local isAllowed = true
                    if workArea.sprayType ~ = nil then
                        local sprayType = self:getActiveSprayType()
                        if sprayType ~ = nil then
                            if sprayType.index ~ = workArea.sprayType then
                                isAllowed = false
                            end
                        end
                    end

                    if isAllowed then
                        self:updateWorkAreaSubSectionData(workArea)
                    end
                end

                for _, workArea in pairs(spec.sowingMachineWorkAreas) do
                    self:updateWorkAreaSubSectionData(workArea)
                end
                for _, workArea in pairs(spec.cultivatorWorkAreas) do
                    self:updateWorkAreaSubSectionData(workArea)
                end

                -- update cultivator area specs if cultivatorSowingMachineExtension spec of nexat DLC is used
                    for _, vehicle in ipairs( self.rootVehicle.childVehicles) do
                        if vehicle[ "spec_pdlc_nexatPack.cultivatorSowingMachineExtension" ] ~ = nil then
                            for _, workArea in pairs(vehicle.spec_workArea.workAreas) do
                                if workArea.type = = WorkAreaType.CULTIVATOR then
                                    if workArea.subSectionData = = nil then
                                        self:updateWorkAreaWidth( 0 , workArea)
                                    end

                                    self:updateWorkAreaSubSectionData(workArea)
                                end
                            end
                        end
                    end
                    --#profile RemoteProfiler.zoneEnd()
                end
            end
        end

        if self.isActiveForInputIgnoreSelectionIgnoreAI then
            if self:getShowExtendedSprayerHudExtension() then
                if spec.hudExtension ~ = nil then
                    local hud = g_currentMission.hud
                    hud:addHelpExtension(spec.hudExtension)
                end
            end
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
function ExtendedSprayer:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if self.isClient then
        if self:getIsTurnedOn() then
            ExtendedSprayer.updateSprayerEffectState( self )
        else
                spec.lastSprayerEffectState = true
            end
        end

        local isLiming, isFertilizing = self:getCurrentSprayerMode()
        if isLiming ~ = spec.isLiming or isFertilizing ~ = spec.isFertilizing then
            spec.isLiming = isLiming
            spec.isFertilizing = isFertilizing

            ExtendedSprayer.updateActionEventState( self )
            ExtendedSprayer.updateActionEventAutoModeDefault( self )
        end

        if self.isActiveForInputIgnoreSelectionIgnoreAI then
            ExtendedSprayer.updateMinimapActiveState( self )

            local _, _, _, _, mission = self:getPFStatisticInfo()
            local isDoingMissionWork = mission ~ = nil or(spec.sprayAmountAutoMode and spec.nApplyAutoModeFruitTypeRequiresDefaultMode)
            if spec.isDoingMissionWork ~ = isDoingMissionWork then
                spec.isDoingMissionWork = isDoingMissionWork
                ExtendedSprayer.updateMinimapActiveState( self )
            end
        end
    end

```

### onVariableWorkWidthSectionChanged

**Description**

**Definition**

> onVariableWorkWidthSectionChanged()

**Code**

```lua
function ExtendedSprayer:onVariableWorkWidthSectionChanged()
    local vehicles = self.rootVehicle.childVehicles
    for i = 1 , #vehicles do
        local vehicle = vehicles[i]
        if SpecializationUtil.hasSpecialization( CropSensor , vehicle.specializations) then
            vehicle:updateCropSensorWorkingWidth()
        end
    end

    if self.isClient then
        ExtendedSprayer.updateSprayerEffectState( self , true )
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
function ExtendedSprayer:onWriteStream(streamId, connection)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    streamWriteBool(streamId, spec.sprayAmountAutoMode)
    streamWriteUIntN(streamId, spec.sprayAmountManual, NitrogenMap.NUM_BITS)
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
function ExtendedSprayer:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.usageValuesDirtyFlag) ~ = 0 ) then
            streamWriteUIntN(streamId, spec.phActualValue, PHMap.NUM_BITS)
            streamWriteUIntN(streamId, spec.phTargetValue, PHMap.NUM_BITS)

            streamWriteUIntN(streamId, spec.nActualValue, NitrogenMap.NUM_BITS)
            streamWriteUIntN(streamId, spec.nTargetValue, NitrogenMap.NUM_BITS)

            streamWriteUIntN(streamId, spec.lastTouchedSoilType, 3 )

            if streamWriteBool(streamId, spec.nApplyAutoModeFruitType ~ = nil ) then
                streamWriteUIntN(streamId, spec.nApplyAutoModeFruitType, FruitTypeManager.SEND_NUM_BITS)
            end
        end
    end
end

```

### preProcessExtUnderRootFertilizerArea

**Description**

**Definition**

> preProcessExtUnderRootFertilizerArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function ExtendedSprayer:preProcessExtUnderRootFertilizerArea(workArea, dt)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if self.isServer then
        local sx, _, sz = getWorldTranslation(workArea.start)
        local wx, _, wz = getWorldTranslation(workArea.width)
        local hx, _, hz = getWorldTranslation(workArea.height)

        if spec.nitrogenMap ~ = nil then
            spec.densityMapParallelogram:updateFromWorldPositions(sx, sz, wx, wz, hx, hz)

            local sprayTypeIndex = SprayType.FERTILIZER -- fertilizing cultivator and sowing machine always using fertilizer spray type instead of manure/digestate
            spec.nitrogenMap:preUpdateNitrogenLevelAtArea(spec.densityMapParallelogram, sprayTypeIndex)

            self:processWorkAreaSubSectionData(workArea)
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
function ExtendedSprayer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Sprayer , specializations) and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### processSprayerArea

**Description**

**Definition**

> processSprayerArea()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | dt        |

**Code**

```lua
function ExtendedSprayer:processSprayerArea(superFunc, workArea, dt)
    local specSpray = self.spec_sprayer
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if specSpray.workAreaParameters.sprayFillLevel < = 0 then
        return superFunc( self , workArea, dt)
    end

    if not spec.isLiming and not spec.isFertilizing then
        return superFunc( self , workArea, dt)
    end

    local sx, _, sz = getWorldTranslation(workArea.start)
    local wx, _, wz = getWorldTranslation(workArea.width)
    local hx, _, hz = getWorldTranslation(workArea.height)

    if self.isServer then
        if specSpray.workAreaParameters.sprayType ~ = workArea.lastSprayTypeIndex then
            workArea.lastSprayTypeIndex = specSpray.workAreaParameters.sprayType
            self:updateWorkAreaSubSectionData(workArea)
        end

        spec.densityMapParallelogram:updateFromWorldPositions(sx, sz, wx, wz, hx, hz)

        --#profile RemoteProfiler.zoneBeginN("processSprayerArea:preUpdate")
        if spec.isLiming then
            spec.pHMap:preUpdatePHLevelAtArea(spec.densityMapParallelogram, specSpray.workAreaParameters.sprayType)
        end

        if spec.isFertilizing then
            spec.nitrogenMap:preUpdateNitrogenLevelAtArea(spec.densityMapParallelogram, specSpray.workAreaParameters.sprayType)
        end
        --#profile RemoteProfiler.zoneEnd()

        --#profile RemoteProfiler.zoneBeginN("processSprayerArea:processWorkAreaSubSectionData")
        self:processWorkAreaSubSectionData(workArea)
        --#profile RemoteProfiler.zoneEnd()

        local changedArea, totalArea = 0 , 0
        if self:getIsPrecisionSprayingRequired() then
            changedArea, totalArea = superFunc( self , workArea, dt)

            if changedArea > 0 then
                spec.nitrogenMap:setMinimapRequiresUpdate( true )
            end
        end

        -- set ground type independent on spray level since we are using it as lock bit
        local desc = g_sprayTypeManager:getSprayTypeByIndex(specSpray.workAreaParameters.sprayType)
        if desc ~ = nil then
            FSDensityMapUtil.setGroundTypeLayerArea(sx, sz, wx, wz, hx, hz, desc.sprayGroundType)
        end

        return changedArea, totalArea
    else
            local changedArea, totalArea = 0 , 0
            if self:getIsPrecisionSprayingRequired() then
                changedArea, totalArea = superFunc( self , workArea, dt)

                if changedArea > 0 then
                    spec.nitrogenMap:setMinimapRequiresUpdate( true )
                end
            end

            -- set ground type independent on spray level since we are using it as lock bit
            local desc = g_sprayTypeManager:getSprayTypeByIndex(specSpray.workAreaParameters.sprayType)
            if desc ~ = nil then
                FSDensityMapUtil.setGroundTypeLayerArea(sx, sz, wx, wz, hx, hz, desc.sprayGroundType)
            end

            return changedArea, totalArea
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
function ExtendedSprayer:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    xmlFile:setBool(key .. "#sprayAmountAutoMode" , spec.sprayAmountAutoMode)
    xmlFile:setInt(key .. "#sprayAmountManual" , spec.sprayAmountManual)
end

```

### setSprayAmountAutoFruitTypeIndex

**Description**

**Definition**

> setSprayAmountAutoFruitTypeIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function ExtendedSprayer:setSprayAmountAutoFruitTypeIndex(index)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    if index ~ = spec.nApplyAutoModeFruitType then
        spec.nApplyAutoModeFruitType = index
        spec.nApplyAutoModeFruitTypeRequiresDefaultMode = spec.nitrogenMap:getFruitTypeRequirementRequiresDefaultMode(index)
        ExtendedSprayer.updateActionEventAutoModeDefault( self )
    end
end

```

### setSprayAmountAutoMode

**Description**

**Definition**

> setSprayAmountAutoMode()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function ExtendedSprayer:setSprayAmountAutoMode(state, noEventSend)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    if state = = nil then
        state = not spec.sprayAmountAutoMode
    end

    if not spec.sprayAmountAutoModeChangeAllowed then
        state = false
    end

    spec.sprayAmountAutoMode = state

    ExtendedSprayer.updateActionEventState( self )
    ExtendedSprayer.updateActionEventAutoModeDefault( self )
    ExtendedSprayerAmountEvent.sendEvent( self , spec.sprayAmountAutoMode, spec.sprayAmountManual, noEventSend)
end

```

### setSprayAmountDefaultFruitRequirementIndex

**Description**

**Definition**

> setSprayAmountDefaultFruitRequirementIndex()

**Arguments**

| any | index       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function ExtendedSprayer:setSprayAmountDefaultFruitRequirementIndex(index, noEventSend)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    spec.nApplyAutoModeFruitRequirementDefaultIndex = index
    spec.lastGroundUpdateDistance = math.huge -- force update of values

    ExtendedSprayerDefaultFruitTypeEvent.sendEvent( self , index, noEventSend)
end

```

### setSprayAmountManualValue

**Description**

**Definition**

> setSprayAmountManualValue()

**Arguments**

| any | value       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function ExtendedSprayer:setSprayAmountManualValue(value, noEventSend)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    spec.sprayAmountManual = math.clamp(value, spec.sprayAmountManualMin, spec.sprayAmountManualMax)

    ExtendedSprayer.updateActionEventState( self )
    ExtendedSprayerAmountEvent.sendEvent( self , spec.sprayAmountAutoMode, spec.sprayAmountManual, noEventSend)
end

```

### setSprayerAITerrainDetailProhibitedRange

**Description**

**Definition**

> setSprayerAITerrainDetailProhibitedRange()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | fillType  |

**Code**

```lua
function ExtendedSprayer:setSprayerAITerrainDetailProhibitedRange(superFunc, fillType)
    superFunc( self , fillType)

    if self:getUseSprayerAIRequirements() then
        if self.addAITerrainDetailProhibitedRange ~ = nil then
            self:clearAIFruitProhibitions() -- clear the spray level requirement as it does not matter anymore with PF

            local sprayTypeDesc = g_sprayTypeManager:getSprayTypeByFillTypeIndex(fillType)
            if sprayTypeDesc ~ = nil then
                if sprayTypeDesc.isFertilizer then
                    local mission = g_currentMission
                    local sprayTypeMapId, sprayTypeFirstChannel, sprayTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.SPRAY_TYPE)
                    self:addAIFruitProhibitions( 0 , sprayTypeDesc.sprayGroundType, sprayTypeDesc.sprayGroundType, sprayTypeMapId, sprayTypeFirstChannel, sprayTypeNumChannels)
                elseif sprayTypeDesc.isLime then
                        local mission = g_currentMission
                        local sprayTypeMapId, sprayTypeFirstChannel, sprayTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.SPRAY_TYPE)
                        self:addAIFruitProhibitions( 0 , sprayTypeDesc.sprayGroundType, sprayTypeDesc.sprayGroundType, sprayTypeMapId, sprayTypeFirstChannel, sprayTypeNumChannels)
                    end

                    -- block ai from working on fully growth fields
                    if sprayTypeDesc.isHerbicide or sprayTypeDesc.isFertilizer or sprayTypeDesc.isLime then
                        for _, fruitType in pairs(g_fruitTypeManager:getFruitTypes()) do
                            if fruitType.terrainDataPlaneId ~ = nil and string.lower(fruitType.name) ~ = "grass" then
                                if fruitType.minHarvestingGrowthState ~ = nil and fruitType.maxHarvestingGrowthState ~ = nil then
                                    self:addAIFruitProhibitions(fruitType.index, fruitType.minHarvestingGrowthState, fruitType.maxHarvestingGrowthState)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

```

### updateActionEventAutoModeDefault

**Description**

**Definition**

> updateActionEventAutoModeDefault()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function ExtendedSprayer.updateActionEventAutoModeDefault( self )
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    local actionEvent = spec.actionEvents[InputAction.TOGGLE_SEEDS]
    if actionEvent ~ = nil then
        g_inputBinding:setActionEventActive(actionEvent.actionEventId, spec.isFertilizing and spec.sprayAmountAutoMode and(spec.nApplyAutoModeFruitType = = nil or spec.nApplyAutoModeFruitType = = FruitType.UNKNOWN))
    end
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
function ExtendedSprayer.updateActionEventState( self )
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
    local actionEventToggleAuto = spec.actionEvents[spec.inputActionToggleAuto]
    if actionEventToggleAuto ~ = nil then
        g_inputBinding:setActionEventActive(actionEventToggleAuto.actionEventId, spec.isLiming or spec.isFertilizing)
        g_inputBinding:setActionEventText(actionEventToggleAuto.actionEventId, spec.sprayAmountAutoMode and spec.texts.toggleSprayAmountAutoModeNeg or spec.texts.toggleSprayAmountAutoModePos)
    end

    local actionEventToggleSprayAmount = spec.actionEvents[spec.inputActionToggleSprayAmount]
    if actionEventToggleSprayAmount ~ = nil then
        g_inputBinding:setActionEventActive(actionEventToggleSprayAmount.actionEventId, not spec.sprayAmountAutoMode and(spec.isLiming or spec.isFertilizing))
    end
end

```

### updateDebugValues

**Description**

**Definition**

> updateDebugValues()

**Arguments**

| any | values |
|-----|--------|

**Code**

```lua
function ExtendedSprayer:updateDebugValues(values)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    local function addWorkArea(workArea, name)
        if workArea.subSectionData ~ = nil then
            local nitrogenValue = spec.nitrogenMap:getNitrogenValueFromInternalValue(workArea.nitrogenLevel)
            local nitrogenTargetValue = spec.nitrogenMap:getNitrogenValueFromInternalValue(workArea.nitrogenTargetLevel)
            local phValue = spec.pHMap:getPhValueFromInternalValue(workArea.phLevel)
            local phTargetValue = spec.pHMap:getPhValueFromInternalValue(workArea.phTargetLevel)
            local fruitTypeName = g_fruitTypeManager:getFruitTypeNameByIndex(workArea.fruitTypeIndex)

            local soilTypeName
            local soilType = spec.soilMap:getSoilTypeByIndex(workArea.soilTypeIndex)
            if soilType ~ = nil then
                soilTypeName = soilType.name
            else
                    soilTypeName = "Unknown"
                end

                table.insert(values, { name = string.format( "Detected(%s)" , name), value = string.format( "N %dkg pH %.3f FruitType: %s|%d Soil: %s(Target:N: %dkg | pH %.3f)" , nitrogenValue, phValue, fruitTypeName, workArea.growthState, soilTypeName, nitrogenTargetValue, phTargetValue) } )

                for subSectionDataIndex, subSectionData in ipairs(workArea.subSectionData) do
                    fruitTypeName = g_fruitTypeManager:getFruitTypeNameByIndex(subSectionData.fruitTypeIndex)

                    nitrogenValue = spec.nitrogenMap:getNitrogenValueFromInternalValue(subSectionData.nitrogenLevel)
                    nitrogenTargetValue = spec.nitrogenMap:getNitrogenValueFromInternalValue(subSectionData.nitrogenTargetLevel)

                    phValue = spec.pHMap:getPhValueFromInternalValue(subSectionData.phLevel)
                    phTargetValue = spec.pHMap:getPhValueFromInternalValue(subSectionData.phTargetLevel)

                    soilType = spec.soilMap:getSoilTypeByIndex(subSectionData.soilTypeIndex)
                    if soilType ~ = nil then
                        soilTypeName = soilType.name
                    else
                            soilTypeName = "Unknown"
                        end

                        table.insert(values, { name = string.format( "Sub Section %d" , subSectionDataIndex), value = string.format( "%dkg/%dkg pH %.3f/%.3f FruitType: %s|%d Soil: %s Speed: %.2fkm/h(%s)" , nitrogenValue, nitrogenTargetValue, phValue, phTargetValue, fruitTypeName, subSectionData.growthState, soilTypeName, subSectionData.lastSpeed, subSectionData.isValid and "Valid" or "Invalid" ) } )
                    end
                end
            end

            for i, workArea in pairs(spec.sprayerWorkAreas) do
                local isAllowed = true
                if workArea.sprayType ~ = nil then
                    local sprayType = self:getActiveSprayType()
                    if sprayType ~ = nil then
                        if sprayType.index ~ = workArea.sprayType then
                            isAllowed = false
                        end
                    end
                end

                if isAllowed then
                    addWorkArea(workArea, "SPRAYER" .. tostring(i))
                end
            end

            for i, workArea in pairs(spec.sowingMachineWorkAreas) do
                addWorkArea(workArea, "SOWINGMACHINE" .. tostring(i))
            end

            for i, workArea in pairs(spec.cultivatorWorkAreas) do
                addWorkArea(workArea, "CULTIVATOR" .. tostring(i))
            end
        end

```

### updateExtendedSprayerNozzleEffectState

**Description**

**Definition**

> updateExtendedSprayerNozzleEffectState()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | effectData |
| any | dt         |
| any | isTurnedOn |
| any | lastSpeed  |

**Code**

```lua
function ExtendedSprayer:updateExtendedSprayerNozzleEffectState(superFunc, effectData, dt, isTurnedOn, lastSpeed)
    local isActive, amountScale = superFunc( self , effectData, dt, isTurnedOn, lastSpeed)

    if isActive then
        local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]
        if (spec.pwmEnabled or spec.spotSprayEnabled) and(spec.isLiming or spec.isFertilizing) then
            local x, y, z = localToWorld(effectData.effectNode, 0 , 0 , 1 )
            local densityBitsGround = getDensityAtWorldPos(spec.groundTypeMapId, x, y, z)
            local groundTypeValue = bit32.band(bit32.rshift(densityBitsGround, spec.groundTypeFirstChannel), 2 ^ spec.groundTypeNumChannels - 1 )
            local groundType = FieldGroundType.getTypeByValue(groundTypeValue)

            if groundType = = FieldGroundType.NONE then
                isActive = false
            end
        end
    end

    return isActive, amountScale
end

```

### updateMinimapActiveState

**Description**

**Definition**

> updateMinimapActiveState()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function ExtendedSprayer.updateMinimapActiveState( self )
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    local _, _, _, isOnField = self:getPFStatisticInfo()
    local isActive = isOnField
    if isActive then
        local sprayer, fillUnitIndex = ExtendedSprayer.getFillTypeSourceVehicle( self )
        isActive = isActive and(sprayer:getFillUnitFillLevel(fillUnitIndex) > 0 or self:getIsAIActive())
    end

    isActive = isActive and(spec.isLiming or spec.isFertilizing)
    if spec.isLiming then
        spec.pHMap:setRequireMinimapDisplay(isActive, self , self:getIsSelected())
    elseif spec.isFertilizing then
            spec.nitrogenMap:setRequireMinimapDisplay(isActive, self , self:getIsSelected())
            spec.nitrogenMap:setMinimapMissionState(spec.isDoingMissionWork)
        end
    end

```

### updateSprayerEffects

**Description**

**Definition**

> updateSprayerEffects()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | force     |

**Code**

```lua
function ExtendedSprayer:updateSprayerEffects(superFunc, force)
end

```

### updateSprayerEffectState

**Description**

**Definition**

> updateSprayerEffectState()

**Arguments**

| any | self  |
|-----|-------|
| any | force |

**Code**

```lua
function ExtendedSprayer.updateSprayerEffectState( self , force)
    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    local effectState = self:getIsPrecisionSprayingRequired() and self:getAreEffectsVisible() and self:getIsTurnedOn()
    if spec.lastSprayerEffectState ~ = effectState or force then
        local specSprayer = self.spec_sprayer
        local sprayType = self:getActiveSprayType()
        if effectState then
            local fillType = self:getFillUnitLastValidFillType( self:getSprayerFillUnitIndex())
            if fillType = = FillType.UNKNOWN then
                fillType = self:getFillUnitFirstSupportedFillType( self:getSprayerFillUnitIndex())
            end

            g_effectManager:setEffectTypeInfo(specSprayer.effects, fillType)
            g_effectManager:startEffects(specSprayer.effects)

            g_soundManager:playSamples(specSprayer.samples.spray)

            if sprayType ~ = nil then
                g_effectManager:setEffectTypeInfo(sprayType.effects, fillType)
                g_effectManager:startEffects(sprayType.effects)

                g_animationManager:startAnimations(sprayType.animationNodes)

                g_soundManager:playSamples(sprayType.samples.spray)
            end

            g_animationManager:startAnimations(specSprayer.animationNodes)
        else
                g_effectManager:stopEffects(specSprayer.effects)

                g_soundManager:stopSamples(specSprayer.samples.spray)

                -- deactivate effects on all spray types(the spray type has may changed during activation)
                for _, _sprayType in ipairs(specSprayer.sprayTypes) do
                    g_effectManager:stopEffects(_sprayType.effects)

                    g_animationManager:stopAnimations(_sprayType.animationNodes)

                    g_soundManager:stopSamples(_sprayType.samples.spray)
                end

                g_animationManager:stopAnimations(specSprayer.animationNodes)
            end

            spec.lastSprayerEffectState = effectState
        end
    end

```

### updateWorkAreaWidth

**Description**

> Updates work area width based on position of area nodes

**Definition**

> updateWorkAreaWidth(integer workAreaIndex, , )

**Arguments**

| integer | workAreaIndex | index of work area |
|---------|---------------|--------------------|
| any     | workAreaIndex |                    |
| any     | workArea      |                    |

**Code**

```lua
function ExtendedSprayer:updateWorkAreaWidth(superFunc, workAreaIndex, workArea)
    superFunc( self , workAreaIndex)

    local specWorkArea = self.spec_workArea
    workArea = workArea or specWorkArea.workAreas[workAreaIndex]
    if workArea = = nil then
        return
    end

    local spec = self [ ExtendedSprayer.SPEC_TABLE_NAME]

    local xOffset, _, _ = localToLocal(workArea.start, self.rootNode, 0 , 0 , 0 )
    local isFertilizerSpreader = math.abs(xOffset) < 0.1

    local numMainDivisions = 1
    local numSubDivisions = math.ceil(workArea.workWidth * 0.5 )
    if isFertilizerSpreader then
        numMainDivisions = 2
        numSubDivisions = math.ceil(workArea.workWidth * 0.5 * 0.5 )
    end

    if numMainDivisions ~ = workArea.numMainDivisions or numSubDivisions ~ = workArea.numSubDivisions then
        workArea.numMainDivisions = numMainDivisions
        workArea.numSubDivisions = numSubDivisions

        workArea.maxPHApplicationOffset = 0
        workArea.maxNApplicationOffset = 0

        local subSectionIndex = 1
        workArea.subSectionData = { }
        for mainIndex = 1 , workArea.numMainDivisions do
            for subIndex = 1 , workArea.numSubDivisions do
                local subSectionData

                if workArea.subSectionData[subSectionIndex] = = nil then
                    workArea.subSectionData[subSectionIndex] = { }
                    subSectionData = workArea.subSectionData[subSectionIndex]
                end

                subSectionData.index = subSectionIndex

                subSectionData.mainIndex = mainIndex
                subSectionData.subIndex = subIndex

                subSectionData.isValid = false

                subSectionData.nitrogenLevel = 0
                subSectionData.nitrogenTargetLevel = 0

                subSectionData.phLevel = 0
                subSectionData.phTargetLevel = 0

                subSectionData.soilTypeIndex = 0
                subSectionData.fruitType = FruitType.UNKNOWN
                subSectionData.growthState = 0
                subSectionData.lastSpeed = 0

                subSectionData.phApplicationOffset = 0
                subSectionData.nApplicationOffset = 0
                if workArea.numMainDivisions > 1 and workArea.numSubDivisions > 1 then
                    subSectionData.phApplicationOffset = - math.floor((subIndex - 1 ) / (workArea.numSubDivisions - 1 ) * 2.01 )
                    subSectionData.nApplicationOffset = - math.floor((subIndex - 1 ) / (workArea.numSubDivisions - 1 ) * 4.01 )

                    workArea.maxPHApplicationOffset = math.max(workArea.maxPHApplicationOffset, math.abs(subSectionData.phApplicationOffset))
                    workArea.maxNApplicationOffset = math.max(workArea.maxNApplicationOffset, math.abs(subSectionData.nApplicationOffset))
                end

                subSectionData.lastDetectionX = 0
                subSectionData.lastDetectionZ = 0

                subSectionIndex = subSectionIndex + 1
            end
        end

        workArea.numSubSections = subSectionIndex - 1

        workArea.nitrogenLevel = 0
        workArea.nitrogenTargetLevel = 0

        workArea.phLevel = 0
        workArea.phTargetLevel = 0

        workArea.lastSpeed = 0

        workArea.fruitType = FruitType.UNKNOWN
        if workArea.fruitTypes = = nil then
            workArea.fruitTypes = { }
        end
        for index, _ in pairs(g_fruitTypeManager:getFruitTypes()) do
            workArea.fruitTypes[index] = 0
        end

        workArea.growthState = 0

        workArea.soilTypeIndex = 0
        if workArea.soilTypes = = nil then
            workArea.soilTypes = { }
        end
        if spec.soilMap ~ = nil and spec.soilMap.soilTypes ~ = nil then
            for index, _ in pairs(spec.soilMap.soilTypes) do
                workArea.soilTypes[index] = 0
            end
        end

        spec.lastGroundUpdateDistance = math.huge
    end
end

```