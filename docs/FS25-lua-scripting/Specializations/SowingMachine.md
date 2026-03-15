## SowingMachine

**Description**

> Specialization for sowing machines provoding seed selection functionality

**Functions**

- [actionEventToggleSeedType](#actioneventtoggleseedtype)
- [actionEventToggleSeedTypeBack](#actioneventtoggleseedtypeback)
- [addFillUnitFillLevel](#addfillunitfilllevel)
- [changeSeedIndex](#changeseedindex)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getAllowFillFromAir](#getallowfillfromair)
- [getAreControlledActionsAllowed](#getarecontrolledactionsallowed)
- [getCanAIImplementContinueWork](#getcanaiimplementcontinuework)
- [getCanBeSelected](#getcanbeselected)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getCanPlantOutsideSeason](#getcanplantoutsideseason)
- [getCanToggleTurnedOn](#getcantoggleturnedon)
- [getCurrentSeedTypeIcon](#getcurrentseedtypeicon)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirectionSnapAngle](#getdirectionsnapangle)
- [getDirtMultiplier](#getdirtmultiplier)
- [getDrawFirstFillText](#getdrawfirstfilltext)
- [getFillUnitAllowsFillType](#getfillunitallowsfilltype)
- [getIsSeedChangeAllowed](#getisseedchangeallowed)
- [getSowingMachineCanConsume](#getsowingmachinecanconsume)
- [getSowingMachineFillUnitIndex](#getsowingmachinefillunitindex)
- [getSowingMachineSeedFillTypeIndex](#getsowingmachineseedfilltypeindex)
- [getSpecValueSeedFillTypes](#getspecvalueseedfilltypes)
- [getUseSowingMachineAIRequirements](#getusesowingmachineairequirements)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadSpecValueSeedFillTypes](#loadspecvalueseedfilltypes)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onChangedFillType](#onchangedfilltype)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onStateChange](#onstatechange)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processSowingMachineArea](#processsowingmachinearea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setFillTypeSourceDisplayFillType](#setfilltypesourcedisplayfilltype)
- [setSeedFruitType](#setseedfruittype)
- [setSeedIndex](#setseedindex)
- [updateAiParameters](#updateaiparameters)
- [updateChooseSeedActionEvent](#updatechooseseedactionevent)
- [updateMissionSowingWarning](#updatemissionsowingwarning)

### actionEventToggleSeedType

**Description**

**Definition**

> actionEventToggleSeedType()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function SowingMachine.actionEventToggleSeedType( self , actionName, inputValue, callbackState, isAnalog)
    if self:getIsSeedChangeAllowed() then
        self:changeSeedIndex( 1 )
    end
end

```

### actionEventToggleSeedTypeBack

**Description**

**Definition**

> actionEventToggleSeedTypeBack()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function SowingMachine.actionEventToggleSeedTypeBack( self , actionName, inputValue, callbackState, isAnalog)
    if self:getIsSeedChangeAllowed() then
        self:changeSeedIndex( - 1 )
    end
end

```

### addFillUnitFillLevel

**Description**

**Definition**

> addFillUnitFillLevel()

**Arguments**

| any | superFunc      |
|-----|----------------|
| any | farmId         |
| any | fillUnitIndex  |
| any | fillLevelDelta |
| any | fillType       |
| any | toolType       |
| any | fillInfo       |

**Code**

```lua
function SowingMachine:addFillUnitFillLevel(superFunc, farmId, fillUnitIndex, fillLevelDelta, fillType, toolType, fillInfo)
    local spec = self.spec_sowingMachine

    if fillUnitIndex = = spec.fillUnitIndex then
        -- force material of fillVolume to be seeds, if fillType is accepted
            if self:getFillUnitSupportsFillType(fillUnitIndex, fillType) then
                fillType = spec.seedFillType
                self:setFillUnitForcedMaterialFillType(fillUnitIndex, fillType)
            end

            -- switch from seeds to 'fill type', if possible
                local fruitType = spec.seeds[spec.currentSeed]
                if fruitType ~ = nil then
                    local seedsFillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitType)
                    if seedsFillType ~ = nil then
                        if self:getFillUnitSupportsFillType(fillUnitIndex, seedsFillType) then
                            self:setFillUnitForcedMaterialFillType(fillUnitIndex, seedsFillType)
                        end
                    end
                end
            end

            return superFunc( self , farmId, fillUnitIndex, fillLevelDelta, fillType, toolType, fillInfo)
        end

```

### changeSeedIndex

**Description**

**Definition**

> changeSeedIndex()

**Arguments**

| any | increment |
|-----|-----------|

**Code**

```lua
function SowingMachine:changeSeedIndex(increment)
    local spec = self.spec_sowingMachine
    local seed = spec.currentSeed + increment
    if seed > #spec.seeds then
        seed = 1
    elseif seed < 1 then
            seed = #spec.seeds
        end

        self:setSeedIndex(seed)
    end

```

### doCheckSpeedLimit

**Description**

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SowingMachine:doCheckSpeedLimit(superFunc)
    local spec = self.spec_sowingMachine
    return superFunc( self ) or(( self.getIsImplementChainLowered = = nil or self:getIsImplementChainLowered()) and( not spec.needsActivation or self:getIsTurnedOn()))
end

```

### getAllowFillFromAir

**Description**

**Definition**

> getAllowFillFromAir()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SowingMachine:getAllowFillFromAir(superFunc)
    local spec = self.spec_sowingMachine
    if self:getIsTurnedOn() and not spec.allowFillFromAirWhileTurnedOn then
        return false
    end
    return superFunc( self )
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
function SowingMachine:getAreControlledActionsAllowed(superFunc)
    local spec = self.spec_sowingMachine

    if spec.requiresFilling then
        if spec.consumableName ~ = nil then
            if not self:getConsumableIsAvailable(spec.consumableName) then
                return false , g_i18n:getText( "info_firstFillTheTool" )
            end
        else
                if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 and self:getFillUnitCapacity(spec.fillUnitIndex) ~ = 0 then
                    return false , g_i18n:getText( "info_firstFillTheTool" )
                end
            end
        end

        return superFunc( self )
    end

```

### getCanAIImplementContinueWork

**Description**

**Definition**

> getCanAIImplementContinueWork()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | isTurning |

**Code**

```lua
function SowingMachine:getCanAIImplementContinueWork(superFunc, isTurning)
    local canContinue, stopAI, stopReason = superFunc( self , isTurning)
    if not canContinue then
        return false , stopAI, stopReason
    end

    if not self:getCanPlantOutsideSeason() and self:getUseSowingMachineAIRequirements() then
        local spec = self.spec_sowingMachine
        if spec.workAreaParameters.seedsFruitType ~ = nil then
            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(spec.workAreaParameters.seedsFruitType)
            if not fruitDesc:getIsPlantableInPeriod(g_currentMission.missionInfo.growthMode, g_currentMission.environment.currentPeriod) then
                return false , true , AIMessageErrorWrongSeason.new()
            end
        end
    end

    return canContinue, stopAI, stopReason
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
function SowingMachine:getCanBeSelected(superFunc)
    return true
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
function SowingMachine:getCanBeTurnedOn(superFunc)
    local spec = self.spec_sowingMachine
    if not spec.needsActivation then
        return false
    end

    return superFunc( self )
end

```

### getCanPlantOutsideSeason

**Description**

**Definition**

> getCanPlantOutsideSeason()

**Code**

```lua
function SowingMachine:getCanPlantOutsideSeason()
    return false
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
function SowingMachine:getCanToggleTurnedOn(superFunc)
    local spec = self.spec_sowingMachine
    if not spec.needsActivation then
        return false
    end

    return superFunc( self )
end

```

### getCurrentSeedTypeIcon

**Description**

**Definition**

> getCurrentSeedTypeIcon()

**Code**

```lua
function SowingMachine:getCurrentSeedTypeIcon()
    local spec = self.spec_sowingMachine
    local fillType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(spec.seeds[spec.currentSeed])
    if fillType ~ = nil then
        return fillType.hudOverlayFilename
    end

    return nil
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function SowingMachine.getDefaultSpeedLimit()
    return 15
end

```

### getDirectionSnapAngle

**Description**

**Definition**

> getDirectionSnapAngle()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SowingMachine:getDirectionSnapAngle(superFunc)
    local spec = self.spec_sowingMachine
    local seedsFruitType = spec.seeds[spec.currentSeed]
    local desc = g_fruitTypeManager:getFruitTypeByIndex(seedsFruitType)
    local snapAngle = 0
    if desc ~ = nil then
        snapAngle = desc.directionSnapAngle
    end
    return math.max(snapAngle, superFunc( self ))
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
function SowingMachine:getDirtMultiplier(superFunc)
    local spec = self.spec_sowingMachine
    local multiplier = superFunc( self )

    if self.movingDirection > 0 and spec.isWorking and( not spec.needsActivation or self:getIsTurnedOn()) then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
end

```

### getDrawFirstFillText

**Description**

**Definition**

> getDrawFirstFillText()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function SowingMachine:getDrawFirstFillText(superFunc)
    local spec = self.spec_sowingMachine
    if self.isClient then
        if self:getIsActiveForInput() and self:getIsSelected() then
            if spec.consumableName ~ = nil then
                if not self:getConsumableIsAvailable(spec.consumableName) then
                    return true
                end
            else
                    if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 and self:getFillUnitCapacity(spec.fillUnitIndex) ~ = 0 then
                        return true
                    end
                end
            end
        end

        return superFunc( self )
    end

```

### getFillUnitAllowsFillType

**Description**

**Definition**

> getFillUnitAllowsFillType()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |
| any | fillType      |

**Code**

```lua
function SowingMachine:getFillUnitAllowsFillType(superFunc, fillUnitIndex, fillType)
    if superFunc( self , fillUnitIndex, fillType) then
        return true
    end

    local specFillUnit = self.spec_fillUnit
    if specFillUnit.fillUnits[fillUnitIndex] ~ = nil then
        if self:getFillUnitSupportsFillType(fillUnitIndex, fillType) then
            local spec = self.spec_sowingMachine
            if fillType = = spec.seedFillType or specFillUnit.fillUnits[fillUnitIndex].fillType = = spec.seedFillType then
                return true
            end
        end
    end

    return false
end

```

### getIsSeedChangeAllowed

**Description**

**Definition**

> getIsSeedChangeAllowed()

**Code**

```lua
function SowingMachine:getIsSeedChangeAllowed()
    return self.spec_sowingMachine.allowsSeedChanging
end

```

### getSowingMachineCanConsume

**Description**

**Definition**

> getSowingMachineCanConsume()

**Code**

```lua
function SowingMachine:getSowingMachineCanConsume()
    local spec = self.spec_sowingMachine
    if spec.consumableName ~ = nil then
        return self:getConsumableIsAvailable(spec.consumableName)
    end

    if self:getFillUnitFillLevel(spec.fillUnitIndex) > 0 or self:getFillUnitCapacity(spec.fillUnitIndex) = = 0 then
        return true
    end
end

```

### getSowingMachineFillUnitIndex

**Description**

**Definition**

> getSowingMachineFillUnitIndex()

**Code**

```lua
function SowingMachine:getSowingMachineFillUnitIndex()
    return self.spec_sowingMachine.fillUnitIndex
end

```

### getSowingMachineSeedFillTypeIndex

**Description**

**Definition**

> getSowingMachineSeedFillTypeIndex()

**Code**

```lua
function SowingMachine:getSowingMachineSeedFillTypeIndex()
    local spec = self.spec_sowingMachine
    return g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(spec.seeds[spec.currentSeed])
end

```

### getSpecValueSeedFillTypes

**Description**

**Definition**

> getSpecValueSeedFillTypes()

**Arguments**

| any | storeItem |
|-----|-----------|
| any | realItem  |

**Code**

```lua
function SowingMachine.getSpecValueSeedFillTypes(storeItem, realItem)
    local fruitTypes = nil

    if storeItem.specs.seedFillTypes ~ = nil then
        local fruits = storeItem.specs.seedFillTypes
        if fruits.categories ~ = nil and fruits.names = = nil then
            fruitTypes = g_fruitTypeManager:getFillTypeIndicesByFruitTypeCategoryName(fruits.categories, nil )
        elseif fruits.categories = = nil and fruits.names ~ = nil then
                fruitTypes = g_fruitTypeManager:getFillTypeIndicesByFruitTypeNames(fruits.names, nil )
            end
            if fruitTypes ~ = nil then
                return fruitTypes
            end
        end

        return nil
    end

```

### getUseSowingMachineAIRequirements

**Description**

**Definition**

> getUseSowingMachineAIRequirements()

**Code**

```lua
function SowingMachine:getUseSowingMachineAIRequirements()
    return self:getAIRequiresTurnOn() or self:getIsTurnedOn()
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
function SowingMachine:getWearMultiplier(superFunc)
    local spec = self.spec_sowingMachine
    local multiplier = superFunc( self )

    if self.movingDirection > 0 and spec.isWorking and( not spec.needsActivation or self:getIsTurnedOn()) then
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
function SowingMachine.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "sowingMachine" , true , true , true )

    g_storeManager:addSpecType( "seedFillTypes" , "shopListAttributeIconSeeds" , SowingMachine.loadSpecValueSeedFillTypes, SowingMachine.getSpecValueSeedFillTypes, StoreSpecies.VEHICLE)

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "SowingMachine" )

    schema:register(XMLValueType.BOOL, "vehicle.sowingMachine.allowFillFromAirWhileTurnedOn#value" , "Allow fill from air while turned on" )
        schema:register(XMLValueType.NODE_INDEX, "vehicle.sowingMachine.directionNode#node" , "Direction node" )
        schema:register(XMLValueType.BOOL, "vehicle.sowingMachine.useDirectPlanting#value" , "Use direct planting" , false )
        schema:register(XMLValueType.BOOL, "vehicle.sowingMachine.waterSeeding#value" , "Seeding in water is required or prohibited(false:prohibited, true:required)" , false )
        schema:register(XMLValueType.STRING, "vehicle.sowingMachine.seedFruitTypeCategories" , "Seed fruit type categories" )
        schema:register(XMLValueType.STRING, "vehicle.sowingMachine.seedFruitTypes" , "Seed fruit types" )
        schema:register(XMLValueType.STRING, "vehicle.sowingMachine.seedFillType" , "Name of seeds fill type to use" , "SEEDS" )
        schema:register(XMLValueType.BOOL, "vehicle.sowingMachine.needsActivation#value" , "Needs activation" , false )
        schema:register(XMLValueType.BOOL, "vehicle.sowingMachine.requiresFilling#value" , "Requires filling" , true )
        schema:register(XMLValueType.STRING, "vehicle.sowingMachine.fieldGroundType#value" , "Defines the field ground type" , "SOWN" )
        schema:register(XMLValueType.BOOL, "vehicle.sowingMachine.fieldGroundType#ridgeSeeding" , "Defines if the sowing machine can seed into created ridges or destroys them" , false )

            SoundManager.registerSampleXMLPaths(schema, "vehicle.sowingMachine.sounds" , "work(?)" )
            SoundManager.registerSampleXMLPaths(schema, "vehicle.sowingMachine.sounds" , "airBlower(?)" )

            AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.sowingMachine.animationNodes" )

            schema:register(XMLValueType.STRING, "vehicle.sowingMachine.changeSeedInputButton" , "Input action name" , "IMPLEMENT_EXTRA3" )
            schema:register(XMLValueType.INT, "vehicle.sowingMachine#fillUnitIndex" , "Fill unit index" , 1 )
            schema:register(XMLValueType.INT, "vehicle.sowingMachine#unloadInfoIndex" , "Unload info index" , 1 )
            schema:register(XMLValueType.STRING, "vehicle.sowingMachine#consumableName" , "Define a consumable that is emptied instead of the fill unit" )

            schema:register(XMLValueType.FLOAT, "vehicle.sowingMachine#seedUsageScale" , "Seed usage scale(Can be used to increase or decrease the usage for certain tools)" , 1 )

                EffectManager.registerEffectXMLPaths(schema, "vehicle.sowingMachine.effects" )

                schema:register(XMLValueType.STRING, "vehicle.storeData.specs.seedFruitTypeCategories" , "Seed fruit type categories" )
                schema:register(XMLValueType.STRING, "vehicle.storeData.specs.seedFruitTypes" , "Seed fruit types" )

                schema:setXMLSpecializationType()

                local schemaSavegame = Vehicle.xmlSchemaSavegame
                schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).sowingMachine#selectedSeedFruitType" , "Selected fruit type name" )
                schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).sowingMachine#allowsSeedChanging" , "If seed change is allowed" )
            end

```

### loadSpecValueSeedFillTypes

**Description**

**Definition**

> loadSpecValueSeedFillTypes()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function SowingMachine.loadSpecValueSeedFillTypes(xmlFile, customEnvironment, baseDir)
    local categories = Utils.getNoNil(xmlFile:getValue( "vehicle.storeData.specs.seedFruitTypeCategories" ), xmlFile:getValue( "vehicle.sowingMachine.seedFruitTypeCategories" ))
    local names = Utils.getNoNil(xmlFile:getValue( "vehicle.storeData.specs.seedFruitTypes" ), xmlFile:getValue( "vehicle.sowingMachine.seedFruitTypes" ))

    return { categories = categories, names = names }
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
function SowingMachine:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.SOWINGMACHINE
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
function SowingMachine:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    local spec = self.spec_sowingMachine
    if spec.fieldGroundType = = FieldGroundType.PLANTED then
        fieldCourseSettings.headlandsFirst = true
        fieldCourseSettings.workInitialSegment = true
    end
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
function SowingMachine:onChangedFillType(fillUnitIndex, fillTypeIndex, oldFillTypeIndex)
    local spec = self.spec_sowingMachine
    if fillUnitIndex = = spec.fillUnitIndex then
        g_animationManager:setFillType(spec.animationNodes, fillTypeIndex)
    end
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function SowingMachine:onDeactivate()
    local spec = self.spec_sowingMachine
    if self.isClient then
        g_soundManager:stopSamples(spec.samples.work)
        g_soundManager:stopSamples(spec.samples.airBlower)
        spec.isWorkSamplePlaying = false
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function SowingMachine:onDelete()
    if self.isClient then
        local spec = self.spec_sowingMachine
        if spec.samples ~ = nil then
            g_soundManager:deleteSamples(spec.samples.work)
            g_soundManager:deleteSamples(spec.samples.airBlower)
        end

        g_effectManager:deleteEffects(spec.effects)
        g_animationManager:deleteAnimations(spec.animationNodes)
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
function SowingMachine:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self.spec_sowingMachine
    if self.isServer then
        local farmId = self:getLastTouchedFarmlandFarmId()

        if spec.workAreaParameters.lastChangedArea > 0 then
            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(spec.workAreaParameters.seedsFruitType)
            local lastHa = MathUtil.areaToHa(spec.workAreaParameters.lastChangedArea, g_currentMission:getFruitPixelsToSqm())
            local usage = fruitDesc.seedUsagePerSqm * lastHa * 10000 * spec.seedUsageScale
            local ha = MathUtil.areaToHa(spec.workAreaParameters.lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m

            local damage = self:getVehicleDamage()
            if damage > 0 then
                usage = usage * ( 1 + damage * SowingMachine.DAMAGED_USAGE_INCREASE)
            end

            g_farmManager:updateFarmStats(farmId, "seedUsage" , usage)
            g_farmManager:updateFarmStats(farmId, "sownHectares" , ha)
            self:updateLastWorkedArea(spec.workAreaParameters.lastStatsArea)

            if not self:getIsAIActive() or not g_currentMission.missionInfo.helperBuySeeds then
                if spec.consumableName = = nil then
                    local vehicle = spec.workAreaParameters.seedsVehicle
                    local fillUnitIndex = spec.workAreaParameters.seedsVehicleFillUnitIndex
                    local unloadInfoIndex = spec.workAreaParameters.seedsVehicleUnloadInfoIndex
                    local fillType = vehicle:getFillUnitFillType(fillUnitIndex)
                    local unloadInfo
                    if vehicle.getFillVolumeUnloadInfo ~ = nil then
                        unloadInfo = vehicle:getFillVolumeUnloadInfo(unloadInfoIndex)
                    end
                    vehicle:addFillUnitFillLevel( self:getOwnerFarmId(), fillUnitIndex, - usage, fillType, ToolType.UNDEFINED, unloadInfo)
                else
                        self:updateConsumable(spec.consumableName, - usage, true )
                    end
                else
                        local price = usage * g_currentMission.economyManager:getCostPerLiter(spec.seedFillType, false ) * 1.5 -- increase price if AI is active to reward the player's manual work
                            g_farmManager:updateFarmStats(farmId, "expenses" , price)
                            g_currentMission:addMoney( - price, self:getOwnerFarmId(), MoneyType.PURCHASE_SEEDS)
                        end
                    end

                    self:updateLastWorkedArea( 0 ) -- mark as working

                    if spec.isWorking then
                        g_farmManager:updateFarmStats(farmId, "sownTime" , dt / ( 1000 * 60 ))
                    end
                end

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
function SowingMachine:onLoad(savegame)
    local spec = self.spec_sowingMachine

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.sowingMachine.animationNodes.animationNode" , "sowingMachine" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnScrollers" , "vehicle.sowingMachine.scrollerNodes.scrollerNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.useDirectPlanting" , "vehicle.sowingMachine.useDirectPlanting#value" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.needsActivation#value" , "vehicle.sowingMachine.needsActivation#value" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.sowingEffects" , "vehicle.sowingMachine.effects" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.sowingEffectsWithFixedFillType" , "vehicle.sowingMachine.fixedEffects" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.sowingMachine#supportsAiWithoutSowingMachine" , "vehicle.turnOnVehicle.aiRequiresTurnOn" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.sowingMachine.directionNode#index" , "vehicle.sowingMachine.directionNode#node" ) --FS19 to FS21

    spec.allowFillFromAirWhileTurnedOn = self.xmlFile:getValue( "vehicle.sowingMachine.allowFillFromAirWhileTurnedOn#value" , true )
    spec.directionNode = self.xmlFile:getValue( "vehicle.sowingMachine.directionNode#node" , self.components[ 1 ].node, self.components, self.i3dMappings)
    spec.useDirectPlanting = self.xmlFile:getValue( "vehicle.sowingMachine.useDirectPlanting#value" , false )
    spec.waterSeeding = self.xmlFile:getValue( "vehicle.sowingMachine.waterSeeding#value" , false )
    spec.isWorking = false
    spec.isProcessing = false

    spec.stoneLastState = 0
    spec.stoneWearMultiplierData = g_currentMission.stoneSystem:getWearMultiplierByType( "SOWINGMACHINE" )

    spec.seeds = { }
    local fruitTypeIndices = { }
    local fruitTypeCategories = self.xmlFile:getValue( "vehicle.sowingMachine.seedFruitTypeCategories" )
    local fruitTypeNames = self.xmlFile:getValue( "vehicle.sowingMachine.seedFruitTypes" )
    if fruitTypeCategories ~ = nil and fruitTypeNames = = nil then
        fruitTypeIndices = g_fruitTypeManager:getFruitTypeIndicesByCategoryNames(fruitTypeCategories, "Warning: '" .. self.configFileName .. "' has invalid fruitTypeCategory '%s'." )
    elseif fruitTypeCategories = = nil and fruitTypeNames ~ = nil then
            fruitTypeIndices = g_fruitTypeManager:getFruitTypeIndicesByNames(fruitTypeNames, "Warning: '" .. self.configFileName .. "' has invalid fruitType '%s'." )
        else
                printWarning( "Warning: '" .. self.configFileName .. "' a sowingMachine needs either the 'seedFruitTypeCategories' or 'seedFruitTypes' element." )
            end

            if fruitTypeIndices ~ = nil then
                for _,fruitTypeIndex in pairs(fruitTypeIndices) do
                    table.insert(spec.seeds, fruitTypeIndex)
                end
            end

            local seedFillType = self.xmlFile:getValue( "vehicle.sowingMachine.seedFillType" , "SEEDS" )
            spec.seedFillType = FillType[seedFillType] or FillType.SEEDS

            spec.needsActivation = self.xmlFile:getValue( "vehicle.sowingMachine.needsActivation#value" , false )
            spec.requiresFilling = self.xmlFile:getValue( "vehicle.sowingMachine.requiresFilling#value" , true )

            spec.fieldGroundType = FieldGroundType.getValueByName( self.xmlFile:getValue( "vehicle.sowingMachine.fieldGroundType#value" , "SOWN" ))
            spec.ridgeSeeding = self.xmlFile:getValue( "vehicle.sowingMachine.fieldGroundType#ridgeSeeding" , false )

            -- use sown type to avoid doubled seeding
            if spec.fieldGroundType = = FieldGroundType.getValueByName( "RIDGE" ) then
                spec.fieldGroundType = FieldGroundType.getValueByName( "RIDGE_SOWN" )
            end

            if self.isClient then
                spec.isWorkSamplePlaying = false
                spec.samples = { }
                spec.samples.work = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.sowingMachine.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                spec.samples.airBlower = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.sowingMachine.sounds" , "airBlower" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

                spec.sampleFillEnabled = false
                spec.sampleFillStopTime = - 1
                spec.lastFillLevel = - 1

                spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.sowingMachine.animationNodes" , self.components, self , self.i3dMappings)
                g_animationManager:setFillType(spec.animationNodes, FillType.UNKNOWN)

                local changeSeedInputButtonStr = self.xmlFile:getValue( "vehicle.sowingMachine.changeSeedInputButton" )
                if changeSeedInputButtonStr ~ = nil then
                    spec.changeSeedInputButton = InputAction[changeSeedInputButtonStr]
                end
                spec.changeSeedInputButton = Utils.getNoNil(spec.changeSeedInputButton, InputAction.TOGGLE_SEEDS)
            end

            spec.currentSeed = 1
            spec.allowsSeedChanging = true
            spec.showFruitCanNotBePlantedWarning = false
            spec.showWrongFruitForMissionWarning = false
            spec.showWaterPlantingRequiredWarning = false
            spec.showWaterPlantingProhibitedWarning = false
            spec.showFieldTypeWarningRegularRequired = false
            spec.showFieldTypeWarningRiceRequired = false

            spec.warnings = { }
            spec.warnings.fruitCanNotBePlanted = g_i18n:getText( "warning_theSelectedFruitTypeIsNotAvailableOnThisMap" )
            spec.warnings.wrongFruitForMission = g_i18n:getText( "warning_theSelectedFruitTypeIsWrongForTheMission" )
            spec.warnings.wrongPlantingTime = g_i18n:getText( "warning_theSelectedFruitTypeCantBePlantedInThisPeriod" )

            spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.sowingMachine#fillUnitIndex" , 1 )
            spec.unloadInfoIndex = self.xmlFile:getValue( "vehicle.sowingMachine#unloadInfoIndex" , 1 )
            spec.consumableName = self.xmlFile:getValue( "vehicle.sowingMachine#consumableName" )
            if spec.consumableName ~ = nil and self.updateConsumable = = nil then
                Logging.xmlWarning( "Sowing machine has consumableName '%s' attribute defined but has no consumable specialization!" , spec.consumableName)
                spec.consumableName = nil
            end

            spec.seedUsageScale = self.xmlFile:getValue( "vehicle.sowingMachine#seedUsageScale" , 1 )

            if self:getFillUnitByIndex(spec.fillUnitIndex) = = nil then
                Logging.xmlError( self.xmlFile, "FillUnit '%d' not defined!" , spec.fillUnitIndex)
                self:setLoadingState(VehicleLoadingState.ERROR)
                return
            end

            spec.fillTypeSources = { }

            if self.isClient then
                spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.sowingMachine.effects" , self.components, self , self.i3dMappings)
            end

            spec.workAreaParameters = { }
            spec.workAreaParameters.seedsFruitType = nil
            spec.workAreaParameters.angle = 0
            spec.workAreaParameters.lastChangedArea = 0
            spec.workAreaParameters.lastStatsArea = 0
            spec.workAreaParameters.lastArea = 0

            self:setSeedIndex( 1 , true )

            if savegame ~ = nil then
                local selectedSeedFruitType = savegame.xmlFile:getValue(savegame.key .. ".sowingMachine#selectedSeedFruitType" )
                if selectedSeedFruitType ~ = nil then
                    local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByName(selectedSeedFruitType)
                    if fruitTypeDesc ~ = nil then
                        self:setSeedFruitType(fruitTypeDesc.index, true )
                    end
                end

                spec.allowsSeedChanging = savegame.xmlFile:getValue(savegame.key .. ".sowingMachine#allowsSeedChanging" , spec.allowsSeedChanging)
            end

            if not self.isClient then
                SpecializationUtil.removeEventListener( self , "onUpdate" , SowingMachine )
                SpecializationUtil.removeEventListener( self , "onUpdateTick" , SowingMachine )
            end

            self.needWaterInfo = true
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
function SowingMachine:onPostLoad(savegame)
    -- Update the ai parameters after all specs have been loaded to make sure we always have the same setup in case a spec changes these during loading(otherwise it might be changed when seed selection is changed)
    SowingMachine.updateAiParameters( self )
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
function SowingMachine:onReadStream(streamId, connection)
    local seedIndex = streamReadUInt8(streamId)
    self:setSeedIndex(seedIndex, true )
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
function SowingMachine:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_sowingMachine
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection and #spec.seeds > 1 then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.changeSeedInputButton, self , SowingMachine.actionEventToggleSeedType, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)

            SowingMachine.updateChooseSeedActionEvent( self )

            _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.TOGGLE_SEEDS_BACK, self , SowingMachine.actionEventToggleSeedTypeBack, false , true , false , true , nil )
            g_inputBinding:setActionEventTextVisibility(actionEventId, false )
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
function SowingMachine:onStartWorkAreaProcessing(dt)
    local spec = self.spec_sowingMachine

    spec.isWorking = false
    spec.isProcessing = false

    local seedsFruitType = spec.seeds[spec.currentSeed]

    local dx,_,dz = localDirectionToWorld(spec.directionNode, 0 , 0 , 1 )
    local angleRad = MathUtil.getYRotationFromDirection(dx, dz)
    local desc = g_fruitTypeManager:getFruitTypeByIndex(seedsFruitType)
    if desc ~ = nil and desc.directionSnapAngle ~ = 0 then
        angleRad = math.floor(angleRad / desc.directionSnapAngle + 0.5 ) * desc.directionSnapAngle
    end
    local angle = FSDensityMapUtil.convertToDensityMapAngle(angleRad, g_currentMission.fieldGroundSystem:getGroundAngleMaxValue())

    local seedsVehicle, seedsVehicleFillUnitIndex, seedsVehicleUnloadInfoIndex

    local isFilled
    if spec.consumableName ~ = nil then
        isFilled = self:getConsumableIsAvailable(spec.consumableName)
    else
            isFilled = self:getFillUnitFillLevel(spec.fillUnitIndex) > 0
        end

        if isFilled then
            seedsVehicle = self
            seedsVehicleFillUnitIndex = spec.fillUnitIndex
            seedsVehicleUnloadInfoIndex = spec.unloadInfoIndex
        else
                if spec.fillTypeSources[spec.seedFillType] ~ = nil then
                    for _, src in ipairs(spec.fillTypeSources[spec.seedFillType]) do
                        local vehicle = src.vehicle
                        if vehicle:getFillUnitFillLevel(src.fillUnitIndex) > 0 and vehicle:getFillUnitFillType(src.fillUnitIndex) = = spec.seedFillType then
                            seedsVehicle = vehicle
                            seedsVehicleFillUnitIndex = src.fillUnitIndex
                            break
                        end
                    end
                end
            end

            if seedsVehicle ~ = nil and seedsVehicle ~ = self then
                local fillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(seedsFruitType)
                if fillType ~ = nil then
                    seedsVehicle:setFillUnitFillTypeToDisplay(seedsVehicleFillUnitIndex, fillType)
                end
            end

            local isTurnedOn = self:getIsTurnedOn()

            -- check if selected fruit is available in current map
                local canFruitBePlanted = false
                if desc ~ = nil and desc.terrainDataPlaneId ~ = nil then
                    canFruitBePlanted = true
                end

                if spec.showWrongFruitForMissionWarning then
                    spec.showWrongFruitForMissionWarning = false
                end

                local isPlantingSeason = true
                if not self:getCanPlantOutsideSeason() then
                    local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(seedsFruitType)
                    if fruitDesc ~ = nil then
                        isPlantingSeason = fruitDesc:getIsPlantableInPeriod(g_currentMission.missionInfo.growthMode, g_currentMission.environment.currentPeriod)
                    end
                end

                local seedVehicleChanged = seedsVehicle ~ = spec.workAreaParameters.seedsVehicle or seedsVehicleFillUnitIndex ~ = spec.workAreaParameters.seedsVehicleFillUnitIndex

                spec.showFruitCanNotBePlantedWarning = not canFruitBePlanted
                spec.showWrongPlantingTimeWarning = not isPlantingSeason and(isTurnedOn or( not spec.needsActivation and self:getIsLowered()))

                spec.showWaterPlantingRequiredWarning = false
                spec.showWaterPlantingProhibitedWarning = false
                spec.showFieldTypeWarningRegularRequired = false
                spec.showFieldTypeWarningRiceRequired = false

                spec.workAreaParameters.isActive = not spec.needsActivation or isTurnedOn
                spec.workAreaParameters.canFruitBePlanted = canFruitBePlanted and isPlantingSeason
                spec.workAreaParameters.seedsFruitType = seedsFruitType
                spec.workAreaParameters.fieldGroundType = spec.fieldGroundType
                spec.workAreaParameters.ridgeSeeding = spec.ridgeSeeding
                spec.workAreaParameters.angle = angle
                spec.workAreaParameters.seedsVehicle = seedsVehicle
                spec.workAreaParameters.seedsVehicleFillUnitIndex = seedsVehicleFillUnitIndex
                spec.workAreaParameters.seedsVehicleUnloadInfoIndex = seedsVehicleUnloadInfoIndex
                spec.workAreaParameters.lastTotalArea = 0
                spec.workAreaParameters.lastChangedArea = 0
                spec.workAreaParameters.lastStatsArea = 0

                if seedVehicleChanged then
                    SowingMachine.updateAiParameters( self )
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
function SowingMachine:onStateChange(state, data)
    if state = = VehicleStateChange.ATTACH or state = = VehicleStateChange.DETACH or VehicleStateChange.FILLTYPE_CHANGE then
        local spec = self.spec_sowingMachine
        spec.fillTypeSources = { }
        if spec.seedFillType ~ = nil then
            spec.fillTypeSources[spec.seedFillType] = { }
            local root = self.rootVehicle
            FillUnit.addFillTypeSources(spec.fillTypeSources, root, self , { spec.seedFillType } )

            local fruitTypeIndex = spec.seeds[spec.currentSeed]
            if fruitTypeIndex ~ = nil then
                local fillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
                if fillType ~ = nil then
                    self:setFillTypeSourceDisplayFillType(fillType)
                end
            end
        end
    end
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function SowingMachine:onTurnedOff()
    local spec = self.spec_sowingMachine

    if self.isClient then
        g_soundManager:stopSamples(spec.samples.airBlower)
        g_animationManager:stopAnimations(spec.animationNodes)
    end

    if self.isServer then
        if spec.fillTypeSources[spec.seedFillType] ~ = nil then
            for _, src in ipairs(spec.fillTypeSources[spec.seedFillType]) do
                if src.vehicle.setIsTurnedOn ~ = nil then
                    src.vehicle:setIsTurnedOn( false )
                end
            end
        end
    end

    SowingMachine.updateAiParameters( self )
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function SowingMachine:onTurnedOn()
    local spec = self.spec_sowingMachine

    if self.isClient then
        g_soundManager:playSamples(spec.samples.airBlower)
        g_animationManager:startAnimations(spec.animationNodes)
    end

    if self.isServer then
        if spec.fillTypeSources[spec.seedFillType] ~ = nil then
            for _, src in ipairs(spec.fillTypeSources[spec.seedFillType]) do
                if src.vehicle.setIsTurnedOn ~ = nil then
                    src.vehicle:setIsTurnedOn( true )
                end
            end
        end
    end

    SowingMachine.updateAiParameters( self )
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
function SowingMachine:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_sowingMachine
    if spec.isProcessing then
        local fillType = self:getFillUnitForcedMaterialFillType(spec.fillUnitIndex)
        if fillType ~ = nil then
            g_effectManager:setEffectTypeInfo(spec.effects, fillType)
            g_effectManager:startEffects(spec.effects)
        end
    else
            g_effectManager:stopEffects(spec.effects)
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
function SowingMachine:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_sowingMachine
    local actionEvent = spec.actionEvents[spec.changeSeedInputButton]
    if actionEvent ~ = nil then
        g_inputBinding:setActionEventActive(actionEvent.actionEventId, self:getIsSeedChangeAllowed())
    end

    if self.isActiveForInputIgnoreSelectionIgnoreAI then
        if spec.showFruitCanNotBePlantedWarning then
            g_currentMission:showBlinkingWarning(spec.warnings.fruitCanNotBePlanted, 5000 )
        elseif spec.showWrongFruitForMissionWarning then
                g_currentMission:showBlinkingWarning(spec.warnings.wrongFruitForMission, 5000 )
            elseif spec.showWrongPlantingTimeWarning then
                    g_currentMission:showBlinkingWarning( string.format(spec.warnings.wrongPlantingTime, g_i18n:formatPeriod()), 5000 )
                elseif spec.showWaterPlantingRequiredWarning then
                        g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_seedingInWaterRequired" ), 5000 )
                    elseif spec.showWaterPlantingProhibitedWarning then
                            g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_seedingInWaterProhibited" ), 5000 )
                        elseif spec.showFieldTypeWarningRegularRequired then
                                g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_seedingOnRegularFieldRequired" ), 5000 )
                            elseif spec.showFieldTypeWarningRiceRequired then
                                    g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_seedingOnRiceFieldRequired" ), 5000 )
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
function SowingMachine:onWriteStream(streamId, connection)
    local spec = self.spec_sowingMachine
    streamWriteUInt8(streamId, spec.currentSeed)
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
function SowingMachine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and
    SpecializationUtil.hasSpecialization( WorkArea , specializations) and
    SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
end

```

### processSowingMachineArea

**Description**

**Definition**

> processSowingMachineArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function SowingMachine:processSowingMachineArea(workArea, dt)
    local spec = self.spec_sowingMachine
    local changedArea, totalArea = 0 , 0
    spec.isWorking = self:getLastSpeed() > 0.5

    if spec.waterSeeding and not self.isInWater then
        spec.showWaterPlantingRequiredWarning = true

        if self:getIsAIActive() then
            local rootVehicle = self.rootVehicle
            rootVehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
        end

        return changedArea, totalArea
    elseif not spec.waterSeeding and self.isInWater then
            spec.showWaterPlantingProhibitedWarning = true

            if self:getIsAIActive() then
                local rootVehicle = self.rootVehicle
                rootVehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
            end

            return changedArea, totalArea
        end

        if not spec.workAreaParameters.isActive then
            return changedArea, totalArea
        end

        if not self:getIsAIActive() or not g_currentMission.missionInfo.helperBuySeeds then
            if spec.workAreaParameters.seedsVehicle = = nil then
                if self:getIsAIActive() then
                    local rootVehicle = self.rootVehicle
                    rootVehicle:stopCurrentAIJob( AIMessageErrorOutOfFill.new())
                end

                return changedArea, totalArea
            end
        end

        if not spec.workAreaParameters.canFruitBePlanted then
            return changedArea, totalArea
        end

        local sx,_,sz = getWorldTranslation(workArea.start)
        local wx,_,wz = getWorldTranslation(workArea.width)
        local hx,_,hz = getWorldTranslation(workArea.height)

        -- remove tireTracks
        FSDensityMapUtil.eraseTireTrack(sx,sz, wx,wz, hx,hz)

        if not self.isServer and self.currentUpdateDistance > SowingMachine.CLIENT_DM_UPDATE_RADIUS then
            return 0 , 0
        end

        local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(spec.workAreaParameters.seedsFruitType)
        if fruitTypeDesc.seedRequiredFieldType ~ = nil then
            local cx, cz = (sx + wx + hx) / 3 , (sz + wz + hz) / 3
            if FSDensityMapUtil.getFieldTypeAtWorldPos(cx, cz) ~ = fruitTypeDesc.seedRequiredFieldType then
                if fruitTypeDesc.seedRequiredFieldType = = FieldType.RICE then
                    spec.showFieldTypeWarningRiceRequired = true

                    if self:getIsAIActive() then
                        local rootVehicle = self.rootVehicle
                        rootVehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
                    end
                else
                        spec.showFieldTypeWarningRegularRequired = true
                    end
                end
            end

            spec.isProcessing = spec.isWorking

            if not spec.useDirectPlanting then
                local area, _ = FSDensityMapUtil.updateSowingArea(spec.workAreaParameters.seedsFruitType, sx,sz, wx,wz, hx,hz, spec.workAreaParameters.fieldGroundType, spec.workAreaParameters.ridgeSeeding, spec.workAreaParameters.angle, nil )
                changedArea = changedArea + area
            else
                    local area, _ = FSDensityMapUtil.updateDirectSowingArea(spec.workAreaParameters.seedsFruitType, sx,sz, wx,wz, hx,hz, spec.workAreaParameters.fieldGroundType, spec.workAreaParameters.ridgeSeeding, spec.workAreaParameters.angle, nil )
                    changedArea = changedArea + area
                end

                if spec.isWorking then
                    spec.stoneLastState = FSDensityMapUtil.getStoneArea(sx, sz, wx, wz, hx, hz)
                else
                        spec.stoneLastState = 0
                    end

                    spec.workAreaParameters.lastChangedArea = spec.workAreaParameters.lastChangedArea + changedArea
                    spec.workAreaParameters.lastStatsArea = spec.workAreaParameters.lastStatsArea + changedArea
                    spec.workAreaParameters.lastTotalArea = spec.workAreaParameters.lastTotalArea + totalArea

                    self:updateMissionSowingWarning(sx, sz)

                    return changedArea, totalArea
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
function SowingMachine.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onChangedFillType" , SowingMachine )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , SowingMachine )
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
function SowingMachine.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "setSeedFruitType" , SowingMachine.setSeedFruitType)
    SpecializationUtil.registerFunction(vehicleType, "setSeedIndex" , SowingMachine.setSeedIndex)
    SpecializationUtil.registerFunction(vehicleType, "changeSeedIndex" , SowingMachine.changeSeedIndex)
    SpecializationUtil.registerFunction(vehicleType, "getIsSeedChangeAllowed" , SowingMachine.getIsSeedChangeAllowed)
    SpecializationUtil.registerFunction(vehicleType, "setIsSeedChangeAllowed" , SowingMachine.setIsSeedChangeAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getSowingMachineFillUnitIndex" , SowingMachine.getSowingMachineFillUnitIndex)
    SpecializationUtil.registerFunction(vehicleType, "getSowingMachineSeedFillTypeIndex" , SowingMachine.getSowingMachineSeedFillTypeIndex)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentSeedTypeIcon" , SowingMachine.getCurrentSeedTypeIcon)
    SpecializationUtil.registerFunction(vehicleType, "processSowingMachineArea" , SowingMachine.processSowingMachineArea)
    SpecializationUtil.registerFunction(vehicleType, "getUseSowingMachineAIRequirements" , SowingMachine.getUseSowingMachineAIRequirements)
    SpecializationUtil.registerFunction(vehicleType, "setFillTypeSourceDisplayFillType" , SowingMachine.setFillTypeSourceDisplayFillType)
    SpecializationUtil.registerFunction(vehicleType, "updateMissionSowingWarning" , SowingMachine.updateMissionSowingWarning)
    SpecializationUtil.registerFunction(vehicleType, "getCanPlantOutsideSeason" , SowingMachine.getCanPlantOutsideSeason)
    SpecializationUtil.registerFunction(vehicleType, "getSowingMachineCanConsume" , SowingMachine.getSowingMachineCanConsume)
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
function SowingMachine.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDrawFirstFillText" , SowingMachine.getDrawFirstFillText)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreControlledActionsAllowed" , SowingMachine.getAreControlledActionsAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitAllowsFillType" , SowingMachine.getFillUnitAllowsFillType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , SowingMachine.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleTurnedOn" , SowingMachine.getCanToggleTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowFillFromAir" , SowingMachine.getAllowFillFromAir)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirectionSnapAngle" , SowingMachine.getDirectionSnapAngle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addFillUnitFillLevel" , SowingMachine.addFillUnitFillLevel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , SowingMachine.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , SowingMachine.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , SowingMachine.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , SowingMachine.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , SowingMachine.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanAIImplementContinueWork" , SowingMachine.getCanAIImplementContinueWork)
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
function SowingMachine:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_sowingMachine
    local selectedSeedFruitTypeName = "unknown"
    local selectedSeedFruitType = spec.seeds[spec.currentSeed]
    if selectedSeedFruitType ~ = nil and selectedSeedFruitType ~ = FruitType.UNKNOWN then
        local fruitType = g_fruitTypeManager:getFruitTypeByIndex(selectedSeedFruitType)
        selectedSeedFruitTypeName = fruitType.name
    end
    xmlFile:setValue(key .. "#selectedSeedFruitType" , selectedSeedFruitTypeName)

    if spec.allowsSeedChanging ~ = nil then
        xmlFile:setValue(key .. "#allowsSeedChanging" , spec.allowsSeedChanging)
    end
end

```

### setFillTypeSourceDisplayFillType

**Description**

**Definition**

> setFillTypeSourceDisplayFillType()

**Arguments**

| any | fillType |
|-----|----------|

**Code**

```lua
function SowingMachine:setFillTypeSourceDisplayFillType(fillType)
    local spec = self.spec_sowingMachine
    if spec.fillTypeSources[spec.seedFillType] ~ = nil then
        for _, src in ipairs(spec.fillTypeSources[spec.seedFillType]) do
            local vehicle = src.vehicle
            local fillLevel = vehicle:getFillUnitFillLevel(src.fillUnitIndex)
            if fillLevel > 0 and vehicle:getFillUnitFillType(src.fillUnitIndex) = = spec.seedFillType then
                vehicle:setFillUnitFillTypeToDisplay(src.fillUnitIndex, fillType)
                break
            elseif fillLevel = = 0 then
                    -- when fill unit allowes only one fill type this icon is displayed permanently
                    -- so we overwrite this one as well
                    local fillTypes = vehicle:getFillUnitSupportedFillTypes(src.fillUnitIndex)
                    local numFillTypes = 0
                    for fillTypeIndex, state in pairs(fillTypes) do
                        if state then
                            numFillTypes = numFillTypes + 1
                        end
                    end

                    if numFillTypes = = 1 and fillTypes[spec.seedFillType] = = true then
                        vehicle:setFillUnitFillTypeToDisplay(src.fillUnitIndex, fillType)
                        break
                    end
                end
            end
        end
    end

```

### setSeedFruitType

**Description**

**Definition**

> setSeedFruitType()

**Arguments**

| any | fruitType   |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function SowingMachine:setSeedFruitType(fruitType, noEventSend)
    local spec = self.spec_sowingMachine
    for i,v in ipairs(spec.seeds) do
        if v = = fruitType then
            self:setSeedIndex(i, noEventSend)
            break
        end
    end
end

```

### setSeedIndex

**Description**

**Definition**

> setSeedIndex()

**Arguments**

| any | seedIndex   |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function SowingMachine:setSeedIndex(seedIndex, noEventSend)
    local spec = self.spec_sowingMachine
    SetSeedIndexEvent.sendEvent( self , seedIndex, noEventSend)
    spec.currentSeed = math.min( math.max(seedIndex, 1 ), #spec.seeds)

    local fruitTypeIndex = spec.seeds[spec.currentSeed]
    if fruitTypeIndex ~ = nil then
        local fillType = g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex)
        if fillType ~ = nil then
            self:setFillUnitFillTypeToDisplay(spec.fillUnitIndex, fillType, true )
            self:setFillTypeSourceDisplayFillType(fillType)
        end
    end

    SowingMachine.updateAiParameters( self )
    SowingMachine.updateChooseSeedActionEvent( self )
end

```

### updateAiParameters

**Description**

**Definition**

> updateAiParameters()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function SowingMachine.updateAiParameters( self )
    local spec = self.spec_sowingMachine

    if self.addAITerrainDetailRequiredRange ~ = nil then
        self:clearAITerrainDetailRequiredRange()
        self:clearAITerrainDetailProhibitedRange()
        self:clearAIFruitProhibitions()

        -- if a cultivator is attached we estimate that it will cultivate infront of our sowing machine and we use also fieldGroundType, potatoHillValue and grass as requirements
            local isCultivatorAttached = false
            local isWeederAttached = false
            local isRollerAttached = false
            local vehicles = self.rootVehicle:getChildVehicles()
            for i = 1 , #vehicles do
                local vehicle = vehicles[i]
                if SpecializationUtil.hasSpecialization( Cultivator , vehicle.specializations) then
                    vehicle:updateCultivatorEnabledState()
                    if vehicle:getIsCultivationEnabled() then
                        isCultivatorAttached = true
                        vehicle:updateCultivatorAIRequirements()
                    end
                end
                if SpecializationUtil.hasSpecialization( Weeder , vehicle.specializations) then
                    isWeederAttached = true
                    vehicle:updateWeederAIRequirements()
                end
                if SpecializationUtil.hasSpecialization( Roller , vehicle.specializations) then
                    isRollerAttached = true
                    vehicle:updateRollerAIRequirements()
                end
            end

            if isCultivatorAttached then
                -- if sowing machine ai requirements are not used it's fully handled by cultivator spec
                    -- use direct seeding requirements since we can cultivate as well
                    if self:getUseSowingMachineAIRequirements() then
                        self:addAIGroundTypeRequirements( SowingMachine.AI_REQUIRED_GROUND_TYPES)
                        self:addAIGroundTypeRequirements( SowingMachine.AI_OUTPUT_GROUND_TYPES)
                    end
                elseif isWeederAttached then
                        -- only if the weeder is turned on we use to sowingMachine requirements to sow the area
                            if self:getUseSowingMachineAIRequirements() then
                                self:clearAITerrainDetailRequiredRange()
                                self:addAIGroundTypeRequirements( SowingMachine.AI_REQUIRED_GROUND_TYPES)
                            end
                        elseif isRollerAttached then
                                -- only if the roller is turned on we use to sowingMachine requirements to sow the area
                                    if self:getUseSowingMachineAIRequirements() then
                                        self:clearAITerrainDetailRequiredRange()
                                        self:addAIGroundTypeRequirements( SowingMachine.AI_REQUIRED_GROUND_TYPES)
                                    end
                                else
                                        self:addAIGroundTypeRequirements( SowingMachine.AI_REQUIRED_GROUND_TYPES)

                                        if spec.useDirectPlanting then
                                            self:addAIGroundTypeRequirements( SowingMachine.AI_OUTPUT_GROUND_TYPES)
                                        end
                                    end

                                    if self:getUseSowingMachineAIRequirements() then
                                        local fruitTypeIndex = spec.seeds[spec.currentSeed]
                                        local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
                                        if fruitTypeDesc ~ = nil then
                                            -- for crops that need preparation(e.g.sugarBeet)
                                                -- to maxHarvesting state is above the cut state, as it only can be reached with preparation
                                                if fruitTypeDesc.cutState < fruitTypeDesc.maxHarvestingGrowthState then
                                                    self:clearAIFruitProhibitions()
                                                    self:addAIFruitProhibitions(fruitTypeIndex, 0 , fruitTypeDesc.cutState - 1 )
                                                    self:addAIFruitProhibitions(fruitTypeIndex, fruitTypeDesc.cutState + 1 , fruitTypeDesc.maxHarvestingGrowthState)
                                                else
                                                        self:setAIFruitProhibitions(fruitTypeIndex, 0 , fruitTypeDesc.maxHarvestingGrowthState)
                                                    end
                                                end
                                            end
                                        end
                                    end

```

### updateChooseSeedActionEvent

**Description**

**Definition**

> updateChooseSeedActionEvent()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function SowingMachine.updateChooseSeedActionEvent( self )
    local spec = self.spec_sowingMachine
    local actionEvent = spec.actionEvents[spec.changeSeedInputButton]
    if actionEvent ~ = nil then
        local additionalText = ""
        local fillType = g_fillTypeManager:getFillTypeByIndex(g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(spec.seeds[spec.currentSeed]))
        if fillType ~ = nil then
            if fillType ~ = FillType.UNKNOWN then
                additionalText = string.format( " (%s)" , fillType.title)
            end
        end

        g_inputBinding:setActionEventText(actionEvent.actionEventId, string.format( "%s%s" , g_i18n:getText( "action_chooseSeed" ), additionalText))
    end
end

```

### updateMissionSowingWarning

**Description**

**Definition**

> updateMissionSowingWarning()

**Arguments**

| any | x |
|-----|---|
| any | z |

**Code**

```lua
function SowingMachine:updateMissionSowingWarning(x, z)
    local spec = self.spec_sowingMachine

    spec.showWrongFruitForMissionWarning = false

    -- Unowned field.This function executes and thus it is allowed which means it is a mission field
        if self:getLastTouchedFarmlandFarmId() = = 0 then
            local mission = g_missionManager:getMissionAtWorldPosition(x, z)
            if mission ~ = nil and mission.type.name = = "sow" then
                if mission.fruitType ~ = spec.workAreaParameters.seedsFruitType then
                    spec.showWrongFruitForMissionWarning = true
                end
            end
        end
    end

```