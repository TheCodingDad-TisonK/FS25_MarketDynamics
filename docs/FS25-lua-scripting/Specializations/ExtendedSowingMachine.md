## ExtendedSowingMachine

**Description**

> Specialization to track seed usage

**Functions**

- [actionEventChangeSeedRate](#actioneventchangeseedrate)
- [actionEventToggleAuto](#actioneventtoggleauto)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onRegisterActionEvents](#onregisteractionevents)
- [onTramlinesChanged](#ontramlineschanged)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [processSowingMachineArea](#processsowingmachinearea)
- [setManualSeedRate](#setmanualseedrate)
- [setSeedRateAutoMode](#setseedrateautomode)
- [updateActionEventState](#updateactioneventstate)

### actionEventChangeSeedRate

**Description**

**Definition**

> actionEventChangeSeedRate()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |
| any | ...           |

**Code**

```lua
function ExtendedSowingMachine.actionEventChangeSeedRate( self , actionName, inputValue, callbackState, isAnalog, .. .)
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    self:setManualSeedRate(spec.manualSeedRate + math.sign(inputValue))
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
function ExtendedSowingMachine.actionEventToggleAuto( self , actionName, inputValue, callbackState, isAnalog)
    self:setSeedRateAutoMode()
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function ExtendedSowingMachine:onDelete()
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
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
function ExtendedSowingMachine:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    local specSowingMachine = self.spec_sowingMachine

    if self.isServer then
        if specSowingMachine.workAreaParameters.lastChangedArea > 0 then
            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(specSowingMachine.workAreaParameters.seedsFruitType)
            local realHa = MathUtil.areaToHa(spec.lastRealChangedArea, g_currentMission:getFruitPixelsToSqm())
            local lastHa = MathUtil.areaToHa(specSowingMachine.workAreaParameters.lastChangedArea, g_currentMission:getFruitPixelsToSqm())
            local usage = fruitDesc.seedUsagePerSqm * lastHa * 10000 * specSowingMachine.seedUsageScale
            local usageRegular = fruitDesc.seedUsagePerSqm * realHa * 10000 * specSowingMachine.seedUsageScale

            local damage = self:getVehicleDamage()
            if damage > 0 then
                usage = usage * ( 1 + damage * SowingMachine.DAMAGED_USAGE_INCREASE)
                usageRegular = usageRegular * ( 1 + damage * SowingMachine.DAMAGED_USAGE_INCREASE)
            end

            if self.updatePFStatistic ~ = nil then
                self:updatePFStatistic( "usedSeeds" , usage)
                self:updatePFStatistic( "usedSeedsRegular" , usageRegular)
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
function ExtendedSowingMachine:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionToggleAuto, self , ExtendedSowingMachine.actionEventToggleAuto, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)

            _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionToggleRate, self , ExtendedSowingMachine.actionEventChangeSeedRate, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventText(actionEventId, spec.texts.inputChangeSeedRate)

            ExtendedSowingMachine.updateActionEventState( self )
        end

        spec.attachStateChanged = true
    end
end

```

### onTramlinesChanged

**Description**

**Definition**

> onTramlinesChanged()

**Code**

```lua
function ExtendedSowingMachine:onTramlinesChanged()
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    spec.lastGroundUpdateDistance = math.huge
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
function ExtendedSowingMachine:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    spec.lastGroundUpdateDistance = spec.lastGroundUpdateDistance + self.lastMovedDistance
    if spec.lastGroundUpdateDistance > spec.groundUpdateDistance then
        spec.lastGroundUpdateDistance = 0

        local workArea = self:getWorkAreaByIndex( 1 )
        if workArea ~ = nil then
            local x, z

            -- if the work area starts in the middle of the vehicle we use the start node, otherwise the middle between start and width
                local lx, _, _ = localToLocal(workArea.start, self.rootNode, 0 , 0 , 0 )
                if math.abs(lx) < 0.5 then
                    x, _, z = getWorldTranslation(workArea.start)
                else
                        local x1, _, z1 = getWorldTranslation(workArea.start)
                        local x2, _, z2 = getWorldTranslation(workArea.width)
                        x, z = (x1 + x2) * 0.5 , (z1 + z2) * 0.5
                    end

                    local isOnField, _ = FSDensityMapUtil.getFieldDataAtWorldPosition(x, 0 , z)
                    if isOnField then
                        local soilTypeIndex = spec.soilMap:getTypeIndexAtWorldPos(x, z)
                        if soilTypeIndex > 0 then
                            local fruitTypeIndex = self.spec_sowingMachine.seeds[ self.spec_sowingMachine.currentSeed]
                            spec.seedRateRecommendation = spec.seedRateMap:getOptimalSeedRateByFruitTypeAndSoiltype(fruitTypeIndex, soilTypeIndex)
                        else
                                spec.seedRateRecommendation = nil
                            end

                            spec.tramlineWidth = spec.tramlineMap:getTramlineWidthAtWorldPos(x, z)
                        else
                                spec.seedRateRecommendation = nil
                                spec.tramlineWidth = nil
                            end
                        end
                    end

                    if isActiveForInputIgnoreSelection then
                        if spec.hudExtension ~ = nil then
                            local hud = g_currentMission.hud
                            hud:addHelpExtension(spec.hudExtension)
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
function ExtendedSowingMachine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( SowingMachine , specializations) and SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### processSowingMachineArea

**Description**

**Definition**

> processSowingMachineArea()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | workArea  |
| any | dt        |

**Code**

```lua
function ExtendedSowingMachine:processSowingMachineArea(superFunc, workArea, dt)
    local changedArea, totalArea = superFunc( self , workArea, dt)
    if changedArea > 0 then
        local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
        local specSowingMachine = self.spec_sowingMachine
        local workAreaParameters = specSowingMachine.workAreaParameters

        spec.lastRealChangedArea = workAreaParameters.lastChangedArea

        local sx, _, sz = getWorldTranslation(workArea.start)
        local wx, _, wz = getWorldTranslation(workArea.width)
        local hx, _, hz = getWorldTranslation(workArea.height)

        local fruitType = workAreaParameters.seedsFruitType

        local realUsage, realSeedRate, realSeedRateIndex = spec.seedRateMap:updateSeedArea(sx, sz, wx, wz, hx, hz, fruitType, spec.seedRateAutoMode, spec.manualSeedRate)

        if realSeedRateIndex ~ = nil then
            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(fruitType)
            local usageOffset = realUsage / fruitDesc.seedUsagePerSqm

            workAreaParameters.lastChangedArea = spec.lastRealChangedArea * usageOffset

            spec.lastSeedRate = realSeedRate
            spec.lastSeedRateIndex = realSeedRateIndex
        end
    end

    return changedArea, totalArea
end

```

### setManualSeedRate

**Description**

**Definition**

> setManualSeedRate()

**Arguments**

| any | seedRate    |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function ExtendedSowingMachine:setManualSeedRate(seedRate, noEventSend)
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    seedRate = math.clamp(seedRate, ExtendedSowingMachine.MIN_SEED_RATE, ExtendedSowingMachine.MAX_SEED_RATE)
    if seedRate ~ = spec.manualSeedRate then
        spec.manualSeedRate = seedRate

        ExtendedSowingMachineRateEvent.sendEvent( self , spec.seedRateAutoMode, spec.manualSeedRate, noEventSend)
    end
end

```

### setSeedRateAutoMode

**Description**

**Definition**

> setSeedRateAutoMode()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function ExtendedSowingMachine:setSeedRateAutoMode(state, noEventSend)
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    if state = = nil then
        state = not spec.seedRateAutoMode
    end

    if state ~ = spec.seedRateAutoMode then
        spec.seedRateAutoMode = state

        if self.isClient then
            ExtendedSowingMachine.updateActionEventState( self )
        end

        ExtendedSowingMachineRateEvent.sendEvent( self , spec.seedRateAutoMode, spec.manualSeedRate, noEventSend)
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
function ExtendedSowingMachine.updateActionEventState( self )
    local spec = self [ ExtendedSowingMachine.SPEC_TABLE_NAME]
    local actionEventToggleAuto = spec.actionEvents[spec.inputActionToggleAuto]
    if actionEventToggleAuto ~ = nil then
        g_inputBinding:setActionEventText(actionEventToggleAuto.actionEventId, spec.seedRateAutoMode and spec.texts.inputToggleAutoModeNeg or spec.texts.inputToggleAutoModePos)
    end

    local actionEventToggleRate = spec.actionEvents[spec.inputActionToggleRate]
    if actionEventToggleRate ~ = nil then
        g_inputBinding:setActionEventActive(actionEventToggleRate.actionEventId, not spec.seedRateAutoMode)
    end
end

```