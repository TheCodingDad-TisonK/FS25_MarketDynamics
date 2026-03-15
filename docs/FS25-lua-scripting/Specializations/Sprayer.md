## Sprayer

**Description**

> Specialization for vehicles with spraying functionality (fertilizer, lime, herbicide)

**Functions**

- [actionEventDoubledAmount](#actioneventdoubledamount)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getActiveSprayType](#getactivespraytype)
- [getAIImplementUseVineSegment](#getaiimplementusevinesegment)
- [getAIRequiresTurnOffOnHeadland](#getairequiresturnoffonheadland)
- [getAreControlledActionsAllowed](#getarecontrolledactionsallowed)
- [getAreEffectsVisible](#getareeffectsvisible)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getCanToggleTurnedOn](#getcantoggleturnedon)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getDrawFirstFillText](#getdrawfirstfilltext)
- [getEffectByNode](#geteffectbynode)
- [getExternalFill](#getexternalfill)
- [getFillVolumeUVScrollSpeed](#getfillvolumeuvscrollspeed)
- [getIsSprayerExternallyFilled](#getissprayerexternallyfilled)
- [getIsSprayTypeActive](#getisspraytypeactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getRawSpeedLimit](#getrawspeedlimit)
- [getSprayerDoubledAmountActive](#getsprayerdoubledamountactive)
- [getSprayerFillUnitIndex](#getsprayerfillunitindex)
- [getSprayerUsage](#getsprayerusage)
- [getUseSprayerAIRequirements](#getusesprayerairequirements)
- [getVariableWorkWidthUsage](#getvariableworkwidthusage)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadSprayTypeFromXML](#loadspraytypefromxml)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIImplementEnd](#onaiimplementend)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onPreDetach](#onpredetach)
- [onRegisterActionEvents](#onregisteractionevents)
- [onSetLowered](#onsetlowered)
- [onSprayTypeChange](#onspraytypechange)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onStateChange](#onstatechange)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdateTick](#onupdatetick)
- [onVariableWorkWidthSectionChanged](#onvariableworkwidthsectionchanged)
- [prerequisitesPresent](#prerequisitespresent)
- [processSprayerArea](#processsprayerarea)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [setSprayerAITerrainDetailProhibitedRange](#setsprayeraiterraindetailprohibitedrange)
- [setSprayerDoubledAmountActive](#setsprayerdoubledamountactive)
- [updateSprayerEffects](#updatesprayereffects)

### actionEventDoubledAmount

**Description**

**Definition**

> actionEventDoubledAmount()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Sprayer.actionEventDoubledAmount( self , actionName, inputValue, callbackState, isAnalog)
    self:setSprayerDoubledAmountActive( not self.spec_sprayer.doubledAmountIsActive)
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
function Sprayer:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and self.spec_sprayer.useSpeedLimit)
end

```

### getActiveSprayType

**Description**

**Definition**

> getActiveSprayType()

**Code**

```lua
function Sprayer:getActiveSprayType()
    local spec = self.spec_sprayer
    for _, sprayType in ipairs(spec.sprayTypes) do
        if self:getIsSprayTypeActive(sprayType) then
            return sprayType
        end
    end

    return nil
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
function Sprayer:getAIImplementUseVineSegment(superFunc, placeable, segment, segmentSide)
    local startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ = placeable:getSegmentSideArea(segment, segmentSide)

    local area, areaTotal = AIVehicleUtil.getAIAreaOfVehicle( self , startWorldX, startWorldZ, widthWorldX, widthWorldZ, heightWorldX, heightWorldZ)
    if areaTotal > 0 then
        return(area / areaTotal) > 0.1
    end

    return false
end

```

### getAIRequiresTurnOffOnHeadland

**Description**

**Definition**

> getAIRequiresTurnOffOnHeadland()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Sprayer:getAIRequiresTurnOffOnHeadland(superFunc)
    return true
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
function Sprayer:getAreControlledActionsAllowed(superFunc)
    local spec = self.spec_sprayer

    if spec.needsToBeFilledToTurnOn then
        if self:getFillUnitFillLevel(spec.fillUnitIndex) < = 0 and self:getFillUnitCapacity(spec.fillUnitIndex) ~ = 0 then
            return false , g_i18n:getText( "info_firstFillTheTool" )
        end
    end

    return superFunc( self )
end

```

### getAreEffectsVisible

**Description**

**Definition**

> getAreEffectsVisible()

**Code**

```lua
function Sprayer:getAreEffectsVisible()
    return self.spec_sprayer.workAreaParameters.lastSprayTime + 100 > g_ time
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
function Sprayer:getCanBeTurnedOn(superFunc)
    local spec = self.spec_sprayer
    if not spec.allowsSpraying then
        return false
    end

    if self:getFillUnitFillLevel( self:getSprayerFillUnitIndex()) < = 0 and spec.needsToBeFilledToTurnOn then
        if not self:getIsAIActive() then
            local sprayVehicle = nil
            for _, supportedSprayType in ipairs(spec.supportedSprayTypes) do
                for _, src in ipairs(spec.fillTypeSources[supportedSprayType]) do
                    local vehicle = src.vehicle
                    if vehicle:getFillUnitFillType(src.fillUnitIndex) = = supportedSprayType and vehicle:getFillUnitFillLevel(src.fillUnitIndex) > 0 then
                        sprayVehicle = vehicle
                        break
                    end
                end
            end

            if sprayVehicle = = nil then
                return false
            end
        end
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
function Sprayer:getCanToggleTurnedOn(superFunc)
    if self.isClient then
        local spec = self.spec_sprayer
        if spec.needsToBeFilledToTurnOn then
            if not self:getCanBeTurnedOn() and self:getFillUnitCapacity( self:getSprayerFillUnitIndex()) < = 0 then
                return false
            end
        end
    end

    return superFunc( self )
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function Sprayer.getDefaultSpeedLimit()
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
function Sprayer:getDirtMultiplier(superFunc)
    local spec = self.spec_sprayer

    if spec.isWorking then
        return superFunc( self ) + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return superFunc( self )
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
function Sprayer:getDrawFirstFillText(superFunc)
    if self.isClient then
        local spec = self.spec_sprayer
        if spec.needsToBeFilledToTurnOn then
            if self:getIsActiveForInput() and self:getIsSelected() and not self.isAlwaysTurnedOn then
                local fillUnitIndex = self:getSprayerFillUnitIndex()
                if not self:getCanBeTurnedOn() and self:getFillUnitFillLevel(fillUnitIndex) < = 0 and self:getFillUnitCapacity(fillUnitIndex) > 0 then
                    return true
                end
            end
        end
    end

    return superFunc( self )
end

```

### getEffectByNode

**Description**

> Returns the effect object with the given node

**Definition**

> getEffectByNode(integer node, )

**Arguments**

| integer | node | node |
|---------|------|------|
| any     | node |      |

**Code**

```lua
function Sprayer:getEffectByNode(superFunc, node)
    local spec = self.spec_sprayer

    for i = 1 , #spec.effects do
        local effect = spec.effects[i]
        if node = = effect.node then
            return effect
        end
    end

    for i = 1 , #spec.sprayTypes do
        local sprayType = spec.sprayTypes[i]
        for j = 1 , #sprayType.effects do
            local effect = sprayType.effects[j]
            if node = = effect.node then
                return effect
            end
        end
    end

    return superFunc( self , node)
end

```

### getExternalFill

**Description**

**Definition**

> getExternalFill()

**Arguments**

| any | fillType |
|-----|----------|
| any | dt       |

**Code**

```lua
function Sprayer:getExternalFill(fillType, dt)
    local found = false
    local isUnknownFillType = fillType = = FillType.UNKNOWN
    local fillUnitIndex = self:getSprayerFillUnitIndex()
    local allowLiquidManure = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.LIQUIDMANURE)
    local allowDigestate = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.DIGESTATE)
    local allowManure = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.MANURE)
    local allowLiquidFertilizer = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.LIQUIDFERTILIZER)
    local allowFertilizer = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.FERTILIZER)
    local allowHerbicide = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.HERBICIDE)
    local allowsLiquidManureDigistate = allowLiquidManure or allowDigestate
    local usage = 0

    local farmId = self:getActiveFarm()
    local statsFarmId = self:getLastTouchedFarmlandFarmId()

    if fillType = = FillType.LIQUIDMANURE or fillType = = FillType.DIGESTATE or(isUnknownFillType and allowsLiquidManureDigistate) then
        if g_currentMission.missionInfo.helperSlurrySource = = 2 then -- buy manure
            found = true
            if g_currentMission.economyManager:getCostPerLiter(FillType.LIQUIDMANURE, false ) then
                fillType = FillType.LIQUIDMANURE
            else
                    fillType = FillType.DIGESTATE
                end

                usage = self:getSprayerUsage(fillType, dt)
                if self.isServer then
                    local price = usage * g_currentMission.economyManager:getCostPerLiter(fillType, false ) * 1.5 -- increase price if AI is active to reward the player's manual work
                        g_farmManager:updateFarmStats(statsFarmId, "expenses" , price)
                        g_currentMission:addMoney( - price, farmId, MoneyType.PURCHASE_FERTILIZER)
                    end
                elseif g_currentMission.missionInfo.helperSlurrySource > 2 then
                        local loadingStation = g_currentMission.liquidManureLoadingStations[g_currentMission.missionInfo.helperSlurrySource - 2 ]
                        if self.isServer and loadingStation ~ = nil then -- Can be nil if pen was removed
                            usage = self:getSprayerUsage(FillType.LIQUIDMANURE, dt)
                            local remainingDelta = loadingStation:removeFillLevel(FillType.LIQUIDMANURE, usage, farmId or self:getOwnerFarmId())
                            if usage - remainingDelta > 0.000001 then
                                found = true
                                fillType = FillType.LIQUIDMANURE
                            else
                                    remainingDelta = loadingStation:removeFillLevel(FillType.DIGESTATE, usage, farmId or self:getOwnerFarmId())
                                    if usage - remainingDelta > 0.000001 then
                                        found = true
                                        fillType = FillType.DIGESTATE
                                    end
                                end
                            end
                        end
                    elseif fillType = = FillType.MANURE or(fillType = = FillType.UNKNOWN and allowManure) then
                            if g_currentMission.missionInfo.helperManureSource = = 2 then -- buy manure
                                found = true
                                fillType = FillType.MANURE

                                usage = self:getSprayerUsage(fillType, dt)
                                if self.isServer then
                                    local price = usage * g_currentMission.economyManager:getCostPerLiter(fillType, false ) * 1.5 -- increase price if AI is active to reward the player's manual work
                                        g_farmManager:updateFarmStats(statsFarmId, "expenses" , price)
                                        g_currentMission:addMoney( - price, farmId, MoneyType.PURCHASE_FERTILIZER)
                                    end
                                elseif g_currentMission.missionInfo.helperManureSource > 2 then
                                        local loadingStation = g_currentMission.manureLoadingStations[g_currentMission.missionInfo.helperManureSource - 2 ]
                                        if self.isServer and loadingStation ~ = nil then -- Can be nil if pen was removed
                                            usage = self:getSprayerUsage(FillType.MANURE, dt)
                                            local remainingDelta = loadingStation:removeFillLevel(FillType.MANURE, usage, farmId or self:getOwnerFarmId())
                                            if usage - remainingDelta > 0.000001 then
                                                found = true
                                                fillType = FillType.MANURE
                                            end
                                        end
                                    end
                                elseif fillType = = FillType.FERTILIZER or
                                        fillType = = FillType.LIQUIDFERTILIZER or
                                        fillType = = FillType.HERBICIDE or
                                        fillType = = FillType.LIME or
                                        (fillType = = FillType.UNKNOWN and(allowLiquidFertilizer or allowFertilizer or allowHerbicide)) then
                                        if g_currentMission.missionInfo.helperBuyFertilizer then
                                            found = true
                                            if fillType = = FillType.UNKNOWN then
                                                if allowLiquidFertilizer then
                                                    fillType = FillType.LIQUIDFERTILIZER
                                                elseif allowFertilizer then
                                                        fillType = FillType.FERTILIZER
                                                    elseif allowHerbicide then
                                                            fillType = FillType.HERBICIDE
                                                        end
                                                    end

                                                    usage = self:getSprayerUsage(fillType, dt)
                                                    if self.isServer then
                                                        local price = usage * g_currentMission.economyManager:getCostPerLiter(fillType, false ) * 1.5 -- increase price if AI is active to reward the player's manual work
                                                            g_farmManager:updateFarmStats(statsFarmId, "expenses" , price)
                                                            g_currentMission:addMoney( - price, farmId, MoneyType.PURCHASE_FERTILIZER)
                                                        end
                                                    end
                                                end

                                                if found then
                                                    return fillType, usage
                                                end

                                                return FillType.UNKNOWN, 0
                                            end

```

### getFillVolumeUVScrollSpeed

**Description**

**Definition**

> getFillVolumeUVScrollSpeed()

**Arguments**

| any | superFunc       |
|-----|-----------------|
| any | fillVolumeIndex |

**Code**

```lua
function Sprayer:getFillVolumeUVScrollSpeed(superFunc, fillVolumeIndex)
    local spec = self.spec_sprayer

    local sprayerFillVolumeIndex = spec.fillVolumeIndex
    local sprayType = self:getActiveSprayType()
    if sprayType ~ = nil then
        sprayerFillVolumeIndex = sprayType.fillVolumeIndex or sprayerFillVolumeIndex
    end

    if fillVolumeIndex = = sprayerFillVolumeIndex then
        if self:getIsTurnedOn() then
            if not self:getIsSprayerExternallyFilled() then
                return spec.dischargeUVScrollSpeed[ 1 ], spec.dischargeUVScrollSpeed[ 2 ], spec.dischargeUVScrollSpeed[ 3 ]
            end
        end
    end

    return superFunc( self , fillVolumeIndex)
end

```

### getIsSprayerExternallyFilled

**Description**

> Returns if sprayer is currently filled by external sources

**Definition**

> getIsSprayerExternallyFilled()

**Code**

```lua
function Sprayer:getIsSprayerExternallyFilled()
    if self:getIsAIActive() then
        -- we do not allow the ai to fill externally if no tank is mounted
            local sprayCapacity = self:getFillUnitCapacity( self:getSprayerFillUnitIndex())
            if sprayCapacity = = 0 then
                local spec = self.spec_sprayer
                local hasSource = false
                for _, supportedSprayType in ipairs(spec.supportedSprayTypes) do
                    if #spec.fillTypeSources[supportedSprayType] > 0 then
                        hasSource = true
                        break
                    end
                end

                if not hasSource then
                    return false
                end
            end

            if self.rootVehicle.getIsFieldWorkActive = = nil or not self.rootVehicle:getIsFieldWorkActive() then
                return false
            end

            local spec = self.spec_sprayer
            return(spec.isSlurryTanker and g_currentMission.missionInfo.helperSlurrySource > 1 )
            or(spec.isManureSpreader and g_currentMission.missionInfo.helperManureSource > 1 )
            or(spec.isFertilizerSprayer and g_currentMission.missionInfo.helperBuyFertilizer)
        end

        return false
    end

```

### getIsSprayTypeActive

**Description**

**Definition**

> getIsSprayTypeActive()

**Arguments**

| any | sprayType |
|-----|-----------|

**Code**

```lua
function Sprayer:getIsSprayTypeActive(sprayType)
    if sprayType.fillTypes ~ = nil then
        local retValue = false

        local currentFillType = self:getFillUnitFillType(sprayType.fillUnitIndex or self.spec_sprayer.fillUnitIndex)
        for _, fillType in ipairs(sprayType.fillTypes) do
            if currentFillType = = g_fillTypeManager:getFillTypeIndexByName(fillType) then
                retValue = true
            end
        end

        if not retValue then
            return false
        end
    end

    return true
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
function Sprayer:getIsWorkAreaActive(superFunc, workArea)
    if workArea.sprayType ~ = nil then
        local sprayType = self:getActiveSprayType()
        if sprayType ~ = nil then
            if sprayType.index ~ = workArea.sprayType then
                return false
            end
        end
    end

    return superFunc( self , workArea)
end

```

### getRawSpeedLimit

**Description**

**Definition**

> getRawSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Sprayer:getRawSpeedLimit(superFunc)
    local spec = self.spec_sprayer
    local sprayType
    if spec.workAreaParameters ~ = nil then
        sprayType = spec.workAreaParameters.sprayType
    end

    if self:getSprayerDoubledAmountActive(sprayType) and self:getIsTurnedOn() then
        return spec.doubledAmountSpeed
    end

    return superFunc( self )
end

```

### getSprayerDoubledAmountActive

**Description**

**Definition**

> getSprayerDoubledAmountActive()

**Arguments**

| any | sprayTypeIndex |
|-----|----------------|

**Code**

```lua
function Sprayer:getSprayerDoubledAmountActive(sprayTypeIndex)
    local spec = self.spec_sprayer
    -- only allow double spray amount for manure, digestate and slurry
        if not spec.isFertilizerSprayer then
            if sprayTypeIndex = = nil then
                return spec.doubledAmountIsActive, true
            else
                    local desc = g_sprayTypeManager:getSprayTypeByIndex(sprayTypeIndex)
                    if desc ~ = nil then
                        if desc.isFertilizer then
                            return spec.doubledAmountIsActive, true
                        end
                    else
                            return spec.doubledAmountIsActive, true
                        end
                    end
                end

                return false , false
            end

```

### getSprayerFillUnitIndex

**Description**

**Definition**

> getSprayerFillUnitIndex()

**Code**

```lua
function Sprayer:getSprayerFillUnitIndex()
    local sprayType = self:getActiveSprayType()
    if sprayType ~ = nil then
        return sprayType.fillUnitIndex
    end

    return self.spec_sprayer.fillUnitIndex
end

```

### getSprayerUsage

**Description**

**Definition**

> getSprayerUsage()

**Arguments**

| any | fillType |
|-----|----------|
| any | dt       |

**Code**

```lua
function Sprayer:getSprayerUsage(fillType, dt)
    if fillType = = FillType.UNKNOWN then
        return 0
    end

    local spec = self.spec_sprayer

    local scale = Utils.getNoNil(spec.usageScale.fillTypeScales[fillType], spec.usageScale.default)
    local litersPerSecond = 1

    local sprayType = g_sprayTypeManager:getSprayTypeByFillTypeIndex(fillType)
    if sprayType ~ = nil then
        litersPerSecond = sprayType.litersPerSecond
    end

    local usageScale = spec.usageScale
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

        return scale * litersPerSecond * self.speedLimit * workWidth * dt * 0.001
    end

```

### getUseSprayerAIRequirements

**Description**

**Definition**

> getUseSprayerAIRequirements()

**Code**

```lua
function Sprayer:getUseSprayerAIRequirements()
    return true
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
function Sprayer:getVariableWorkWidthUsage(superFunc)
    local usage = superFunc( self )
    if usage = = nil then
        if self:getIsTurnedOn() then
            return self.spec_sprayer.workAreaParameters.usagePerMin
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
function Sprayer:getWearMultiplier(superFunc)
    local spec = self.spec_sprayer

    if spec.isWorking then
        return superFunc( self ) + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return superFunc( self )
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Sprayer.initSpecialization()
    g_workAreaTypeManager:addWorkAreaType( "sprayer" , false , true , true )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Sprayer" )

    schema:register(XMLValueType.BOOL, "vehicle.sprayer#allowsSpraying" , "Allows spraying" , true )
    schema:register(XMLValueType.BOOL, "vehicle.sprayer#activateTankOnLowering" , "Activate tank on lowering" , false )
    schema:register(XMLValueType.BOOL, "vehicle.sprayer#activateOnLowering" , "Activate on lowering" , false )

    schema:register(XMLValueType.FLOAT, "vehicle.sprayer.usageScales#scale" , "Usage scale" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.sprayer.usageScales#workingWidth" , "Working width" , 12 )
    schema:register(XMLValueType.INT, "vehicle.sprayer.usageScales#workAreaIndex" , "Work area that is used for working width reference instead of #workingWidth" )

        schema:register(XMLValueType.STRING, "vehicle.sprayer.usageScales.sprayUsageScale(?)#fillType" , "Fill type name" )
        schema:register(XMLValueType.FLOAT, "vehicle.sprayer.usageScales.sprayUsageScale(?)#scale" , "Scale" )

        schema:register(XMLValueType.INT, Sprayer.SPRAY_TYPE_XML_KEY .. "#fillUnitIndex" , "Fill unit index" )
        schema:register(XMLValueType.INT, Sprayer.SPRAY_TYPE_XML_KEY .. "#unloadInfoIndex" , "Unload info index" )
        schema:register(XMLValueType.INT, Sprayer.SPRAY_TYPE_XML_KEY .. "#fillVolumeIndex" , "Fill volume index" )

        schema:register(XMLValueType.BOOL, Sprayer.SPRAY_TYPE_XML_KEY .. "#supportsVariableWorkWidth" , "Spray type support variable work width" , true )

        SoundManager.registerSampleXMLPaths(schema, Sprayer.SPRAY_TYPE_XML_KEY .. ".sounds" , "work(?)" )
        SoundManager.registerSampleXMLPaths(schema, Sprayer.SPRAY_TYPE_XML_KEY .. ".sounds" , "spray(?)" )
        AnimationManager.registerAnimationNodesXMLPaths(schema, Sprayer.SPRAY_TYPE_XML_KEY .. ".animationNodes" )
        EffectManager.registerEffectXMLPaths(schema, Sprayer.SPRAY_TYPE_XML_KEY .. ".effects" )

        schema:register(XMLValueType.STRING, Sprayer.SPRAY_TYPE_XML_KEY .. ".turnedAnimation#name" , "Turned animation name" )
        schema:register(XMLValueType.FLOAT, Sprayer.SPRAY_TYPE_XML_KEY .. ".turnedAnimation#turnOnSpeedScale" , "Speed Scale while turned on" , 1 )
            schema:register(XMLValueType.FLOAT, Sprayer.SPRAY_TYPE_XML_KEY .. ".turnedAnimation#turnOffSpeedScale" , "Speed Scale while turned off" , "Inversed #turnOnSpeedScale" )
                schema:register(XMLValueType.BOOL, Sprayer.SPRAY_TYPE_XML_KEY .. ".turnedAnimation#externalFill" , "Animation is played while sprayer is externally filled" , true )

                    AIImplement.registerAIImplementBaseXMLPaths(schema, Sprayer.SPRAY_TYPE_XML_KEY .. ".ai" )

                    schema:register(XMLValueType.STRING, Sprayer.SPRAY_TYPE_XML_KEY .. "#fillTypes" , "Fill types" )
                    schema:register(XMLValueType.FLOAT, Sprayer.SPRAY_TYPE_XML_KEY .. ".usageScales#workingWidth" , "Work width" , 12 )
                    schema:register(XMLValueType.INT, Sprayer.SPRAY_TYPE_XML_KEY .. ".usageScales#workAreaIndex" , "Work area that is used for working width reference instead of #workingWidth" )

                        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, Sprayer.SPRAY_TYPE_XML_KEY)

                        EffectManager.registerEffectXMLPaths(schema, "vehicle.sprayer.effects" )
                        SoundManager.registerSampleXMLPaths(schema, "vehicle.sprayer.sounds" , "work(?)" )
                        SoundManager.registerSampleXMLPaths(schema, "vehicle.sprayer.sounds" , "spray(?)" )
                        AnimationManager.registerAnimationNodesXMLPaths(schema, "vehicle.sprayer.animationNodes" )

                        schema:register(XMLValueType.STRING, "vehicle.sprayer.animation#name" , "Spray animation name" )
                        schema:register(XMLValueType.INT, "vehicle.sprayer#fillUnitIndex" , "Fill unit index" , 1 )
                        schema:register(XMLValueType.INT, "vehicle.sprayer#unloadInfoIndex" , "Unload info index" , 1 )
                        schema:register(XMLValueType.INT, "vehicle.sprayer#fillVolumeIndex" , "Fill volume index" )
                        schema:register(XMLValueType.VECTOR_ 3 , "vehicle.sprayer#fillVolumeDischargeScrollSpeed" , "Fill volume discharge scroll speed" , "0 0 0" )

                        schema:register(XMLValueType.FLOAT, "vehicle.sprayer.doubledAmount#decreasedSpeed" , "Speed while doubled amount is sprayed" , "automatically calculated" )
                            schema:register(XMLValueType.FLOAT, "vehicle.sprayer.doubledAmount#decreaseFactor" , "Decrease factor that is applied on speedLimit while doubled amount is sprayed" , 0.5 )
                                schema:register(XMLValueType.STRING, "vehicle.sprayer.doubledAmount#toggleButton" , "Name of input action to toggle doubled amount" , "IMPLEMENT_EXTRA4" )

                                schema:register(XMLValueType.L10N_STRING, "vehicle.sprayer.doubledAmount#deactivateText" , "Deactivated text" , "action_deactivateDoubledSprayAmount" )
                                schema:register(XMLValueType.L10N_STRING, "vehicle.sprayer.doubledAmount#activateText" , "Activate text" , "action_activateDoubledSprayAmount" )

                                schema:register(XMLValueType.STRING, "vehicle.sprayer.turnedAnimation#name" , "Turned animation name" )
                                schema:register(XMLValueType.FLOAT, "vehicle.sprayer.turnedAnimation#turnOnSpeedScale" , "Speed Scale while turned on" , 1 )
                                    schema:register(XMLValueType.FLOAT, "vehicle.sprayer.turnedAnimation#turnOffSpeedScale" , "Speed Scale while turned off" , "Inversed #turnOnSpeedScale" )
                                        schema:register(XMLValueType.BOOL, "vehicle.sprayer.turnedAnimation#externalFill" , "Animation is played while sprayer is externally filled" , true )

                                            schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. "#sprayType" , "Spray type index" )
                                            schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. "#sprayType" , "Spray type index" )

                                            schema:setXMLSpecializationType()
                                        end

```

### loadSprayTypeFromXML

**Description**

**Definition**

> loadSprayTypeFromXML()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | key       |
| any | sprayType |

**Code**

```lua
function Sprayer:loadSprayTypeFromXML(xmlFile, key, sprayType)
    sprayType.fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" , 1 )
    sprayType.unloadInfoIndex = xmlFile:getValue(key .. "#unloadInfoIndex" , 1 )
    sprayType.fillVolumeIndex = xmlFile:getValue(key .. "#fillVolumeIndex" )

    sprayType.supportsVariableWorkWidth = xmlFile:getValue(key .. "#supportsVariableWorkWidth" , true )

    sprayType.samples = { }
    sprayType.samples.work = g_soundManager:loadSamplesFromXML(xmlFile, key .. ".sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
    sprayType.samples.spray = g_soundManager:loadSamplesFromXML(xmlFile, key .. ".sounds" , "spray" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

    sprayType.effects = g_effectManager:loadEffect(xmlFile, key .. ".effects" , self.components, self , self.i3dMappings)

    sprayType.animationNodes = g_animationManager:loadAnimations(xmlFile, key .. ".animationNodes" , self.components, self , self.i3dMappings)

    sprayType.turnedAnimation = xmlFile:getValue(key .. ".turnedAnimation#name" , "" )
    sprayType.turnedAnimationTurnOnSpeedScale = xmlFile:getValue(key .. ".turnedAnimation#turnOnSpeedScale" , 1 )
    sprayType.turnedAnimationTurnOffSpeedScale = xmlFile:getValue(key .. ".turnedAnimation#turnOffSpeedScale" , - sprayType.turnedAnimationTurnOnSpeedScale)
    sprayType.turnedAnimationExternalFill = xmlFile:getValue(key .. ".turnedAnimation#externalFill" , true )

    if self.loadAIImplementBaseSetupFromXML ~ = nil then
        self:loadAIImplementBaseSetupFromXML(xmlFile, key .. ".ai" , function (_)
            return self:getIsSprayTypeActive(sprayType)
        end )
    end

    local fillTypesStr = xmlFile:getValue(key .. "#fillTypes" )
    if fillTypesStr ~ = nil then
        sprayType.fillTypes = fillTypesStr:split( " " )
    end

    sprayType.objectChanges = { }
    ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key, sprayType.objectChanges, self.components, self )
    ObjectChangeUtil.setObjectChanges(sprayType.objectChanges, false , self , self.setMovingToolDirty)

    sprayType.usageScale = { }
    if xmlFile:hasProperty(key .. ".usageScales" ) then
        sprayType.usageScale.workingWidth = xmlFile:getValue(key .. ".usageScales#workingWidth" , 12 )
        sprayType.usageScale.workAreaIndex = xmlFile:getValue(key .. ".usageScales#workAreaIndex" )
    else
            sprayType.usageScale.workingWidth = self.spec_sprayer.usageScale.workingWidth
            sprayType.usageScale.workAreaIndex = self.spec_sprayer.usageScale.workAreaIndex
        end

        return true
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
function Sprayer:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.SPRAYER
    end

    workArea.sprayType = xmlFile:getValue(key .. "#sprayType" )

    return retValue
end

```

### onAIImplementEnd

**Description**

**Definition**

> onAIImplementEnd()

**Code**

```lua
function Sprayer:onAIImplementEnd()
    -- turn off all fill type sources on ai turn off
    local spec = self.spec_sprayer
    for _, supportedSprayType in ipairs(spec.supportedSprayTypes) do
        for _, src in ipairs(spec.fillTypeSources[supportedSprayType]) do
            local vehicle = src.vehicle
            if vehicle.getIsTurnedOn ~ = nil then
                if vehicle:getIsTurnedOn() then
                    vehicle:setIsTurnedOn( false , true )
                end
            end
        end
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function Sprayer:onDelete()
    local spec = self.spec_sprayer

    g_effectManager:deleteEffects(spec.effects)
    g_animationManager:deleteAnimations(spec.animationNodes)
    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.work)
        g_soundManager:deleteSamples(spec.samples.spray)
    end

    if spec.sprayTypes ~ = nil then
        for _, sprayType in ipairs(spec.sprayTypes) do
            g_effectManager:deleteEffects(sprayType.effects)
            g_animationManager:deleteAnimations(sprayType.animationNodes)

            if sprayType.samples ~ = nil then
                g_soundManager:deleteSamples(sprayType.samples.work)
                g_soundManager:deleteSamples(sprayType.samples.spray)
            end
        end
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
function Sprayer:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self.spec_sprayer

    if self.isServer then
        if spec.workAreaParameters.isActive then
            local sprayVehicle = spec.workAreaParameters.sprayVehicle
            local usage = spec.workAreaParameters.usage

            if sprayVehicle ~ = nil then
                local sprayVehicleFillUnitIndex = spec.workAreaParameters.sprayVehicleFillUnitIndex
                local sprayFillType = spec.workAreaParameters.sprayFillType

                local unloadInfoIndex = spec.unloadInfoIndex
                local sprayType = self:getActiveSprayType()
                if sprayType ~ = nil then
                    unloadInfoIndex = sprayType.unloadInfoIndex
                end

                local unloadInfo = self:getFillVolumeUnloadInfo(unloadInfoIndex)
                sprayVehicle:addFillUnitFillLevel( self:getOwnerFarmId(), sprayVehicleFillUnitIndex, - usage, sprayFillType, ToolType.UNDEFINED, unloadInfo)
            end

            local ha = MathUtil.areaToHa(spec.workAreaParameters.lastStatsArea, g_currentMission:getFruitPixelsToSqm())
            local farmId = self:getLastTouchedFarmlandFarmId()
            g_farmManager:updateFarmStats(farmId, "sprayedHectares" , ha)
            g_farmManager:updateFarmStats(farmId, "sprayedTime" , dt / ( 1000 * 60 ))
            g_farmManager:updateFarmStats(farmId, "sprayUsage" , usage)
            self:updateLastWorkedArea(spec.workAreaParameters.lastStatsArea)
        end
    end

    self:updateSprayerEffects()
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
function Sprayer:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_sprayer
    if fillUnitIndex = = spec.fillUnitIndex then
        local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)
        if fillLevel = = 0 and self:getIsTurnedOn() and not self:getIsAIActive() then

            -- only deactivate sprayer if no fill type source for the same fill type is available
                local hasValidSource = false
                if spec.fillTypeSources[fillType] ~ = nil then
                    for _, src in ipairs(spec.fillTypeSources[fillType]) do
                        local vehicle = src.vehicle
                        if vehicle:getIsFillUnitActive(src.fillUnitIndex) then
                            local vehicleFillType = vehicle:getFillUnitFillType(src.fillUnitIndex)
                            local vehicleFillLevel = vehicle:getFillUnitFillLevel(src.fillUnitIndex)
                            if vehicleFillLevel > 0 and vehicleFillType = = fillType then
                                hasValidSource = true
                            end
                        end
                    end
                end

                if not hasValidSource then
                    self:setIsTurnedOn( false )

                    if Platform.gameplay.automaticVehicleControl then
                        self.rootVehicle:playControlledActions()
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
function Sprayer:onLoad(savegame)
    local spec = self.spec_sprayer

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.sprayParticles.emitterShape" , "vehicle.sprayer.effects.effectNode#effectClass = 'ParticleEffect'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.sprayer#needsTankActivation" ) --FS19 to FS22

    spec.allowsSpraying = self.xmlFile:getValue( "vehicle.sprayer#allowsSpraying" , true )
    spec.activateTankOnLowering = self.xmlFile:getValue( "vehicle.sprayer#activateTankOnLowering" , false )
    spec.activateOnLowering = self.xmlFile:getValue( "vehicle.sprayer#activateOnLowering" , false )

    spec.usageScale = { }
    spec.usageScale.default = self.xmlFile:getValue( "vehicle.sprayer.usageScales#scale" , 1 )
    spec.usageScale.workingWidth = self.xmlFile:getValue( "vehicle.sprayer.usageScales#workingWidth" , 12 )
    spec.usageScale.workAreaIndex = self.xmlFile:getValue( "vehicle.sprayer.usageScales#workAreaIndex" )
    spec.usageScale.fillTypeScales = { }
    local i = 0
    while true do
        local key = string.format( "vehicle.sprayer.usageScales.sprayUsageScale(%d)" , i)
        if not self.xmlFile:hasProperty(key) then
            break
        end
        local fillTypeStr = self.xmlFile:getValue(key .. "#fillType" )
        local scale = self.xmlFile:getValue(key .. "#scale" )
        if fillTypeStr ~ = nil and scale ~ = nil then
            local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeStr)
            if fillTypeIndex ~ = nil then
                spec.usageScale.fillTypeScales[fillTypeIndex] = scale
            else
                    printWarning( "Warning:Invalid spray usage scale fill type '" .. fillTypeStr .. "' in '" .. self.configFileName .. "'" )
                end
            end
            i = i + 1
        end

        spec.sprayTypes = { }
        i = 0
        while true do
            local key = string.format( "vehicle.sprayer.sprayTypes.sprayType(%d)" , i)
            if not self.xmlFile:hasProperty(key) then
                break
            end

            local sprayType = { }
            if self:loadSprayTypeFromXML( self.xmlFile, key, sprayType) then
                table.insert(spec.sprayTypes, sprayType)
                sprayType.index = #spec.sprayTypes
            end

            i = i + 1
        end

        spec.lastActiveSprayType = nil

        if self.isClient then
            spec.effects = g_effectManager:loadEffect( self.xmlFile, "vehicle.sprayer.effects" , self.components, self , self.i3dMappings)

            spec.animationName = self.xmlFile:getValue( "vehicle.sprayer.animation#name" , "" )

            spec.samples = { }
            spec.samples.work = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.sprayer.sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
            spec.samples.spray = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.sprayer.sounds" , "spray" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

            spec.sampleFillEnabled = false
            spec.sampleFillStopTime = - 1
            spec.lastFillLevel = - 1

            spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, "vehicle.sprayer.animationNodes" , self.components, self , self.i3dMappings)
        end

        if self.addAIGroundTypeRequirements ~ = nil then
            self:addAIGroundTypeRequirements( Sprayer.AI_REQUIRED_GROUND_TYPES)
        end

        spec.supportedSprayTypes = { }

        spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.sprayer#fillUnitIndex" , 1 )
        spec.unloadInfoIndex = self.xmlFile:getValue( "vehicle.sprayer#unloadInfoIndex" , 1 )
        spec.fillVolumeIndex = self.xmlFile:getValue( "vehicle.sprayer#fillVolumeIndex" )
        spec.dischargeUVScrollSpeed = self.xmlFile:getValue( "vehicle.sprayer#fillVolumeDischargeScrollSpeed" , "0 0 0" , true )

        if self:getFillUnitByIndex(spec.fillUnitIndex) = = nil then
            Logging.xmlError( self.xmlFile, "FillUnit '%d' not defined!" , spec.fillUnitIndex)
            self:setLoadingState(VehicleLoadingState.ERROR)
            return
        end

        local decreasedSpeedLimit = self.xmlFile:getValue( "vehicle.sprayer.doubledAmount#decreasedSpeed" )
        if decreasedSpeedLimit = = nil then
            local decreaseFactor = self.xmlFile:getValue( "vehicle.sprayer.doubledAmount#decreaseFactor" , 0.5 )
            decreasedSpeedLimit = self:getSpeedLimit() * decreaseFactor
        end
        spec.doubledAmountSpeed = decreasedSpeedLimit
        spec.doubledAmountIsActive = false

        local toggleButtonStr = self.xmlFile:getValue( "vehicle.sprayer.doubledAmount#toggleButton" )
        if toggleButtonStr ~ = nil then
            spec.toggleDoubledAmountInputBinding = InputAction[toggleButtonStr]
        end
        spec.toggleDoubledAmountInputBinding = spec.toggleDoubledAmountInputBinding or InputAction.DOUBLED_SPRAY_AMOUNT
        spec.doubledAmountDeactivateText = self.xmlFile:getValue( "vehicle.sprayer.doubledAmount#deactivateText" , "action_deactivateDoubledSprayAmount" , self.customEnvironment)
        spec.doubledAmountActivateText = self.xmlFile:getValue( "vehicle.sprayer.doubledAmount#activateText" , "action_activateDoubledSprayAmount" , self.customEnvironment)

        spec.turnedAnimation = self.xmlFile:getValue( "vehicle.sprayer.turnedAnimation#name" , "" )
        spec.turnedAnimationTurnOnSpeedScale = self.xmlFile:getValue( "vehicle.sprayer.turnedAnimation#turnOnSpeedScale" , 1 )
        spec.turnedAnimationTurnOffSpeedScale = self.xmlFile:getValue( "vehicle.sprayer.turnedAnimation#turnOffSpeedScale" , - spec.turnedAnimationTurnOnSpeedScale)
        spec.turnedAnimationExternalFill = self.xmlFile:getValue( "vehicle.sprayer.turnedAnimation#externalFill" , true )

        spec.needsToBeFilledToTurnOn = true
        spec.useSpeedLimit = true
        spec.isWorking = false
        spec.lastEffectsState = false

        local fillUnitIndex = self:getSprayerFillUnitIndex()
        spec.isSlurryTanker = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.LIQUIDMANURE) or self:getFillUnitAllowsFillType(fillUnitIndex, FillType.DIGESTATE)
        spec.isManureSpreader = self:getFillUnitAllowsFillType(fillUnitIndex, FillType.MANURE)
        spec.isFertilizerSprayer = not spec.isSlurryTanker and not spec.isManureSpreader

        spec.hasWorkAreas = self:getWorkAreaByIndex( 1 ) ~ = nil

        spec.workAreaParameters = { }
        spec.workAreaParameters.sprayVehicle = nil
        spec.workAreaParameters.sprayVehicleFillUnitIndex = nil
        spec.workAreaParameters.lastChangedArea = 0
        spec.workAreaParameters.lastTotalArea = 0
        spec.workAreaParameters.lastIsExternallyFilled = false
        spec.workAreaParameters.lastSprayTime = - math.huge
        spec.workAreaParameters.usage = 0
        spec.workAreaParameters.usagePerMin = 0

        -- do not register doubled application rate input action as it makes no sense for tankers
            if not spec.hasWorkAreas then
                SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , Sprayer )
            end
        end

```

### onPreDetach

**Description**

**Definition**

> onPreDetach()

**Arguments**

| any | attacherVehicle |
|-----|-----------------|
| any | jointDescIndex  |

**Code**

```lua
function Sprayer:onPreDetach(attacherVehicle, jointDescIndex)
    if attacherVehicle.setIsTurnedOn ~ = nil and attacherVehicle:getIsTurnedOn() then
        attacherVehicle:setIsTurnedOn( false )
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
function Sprayer:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_sprayer
        self:clearActionEventsTable(spec.actionEvents)
        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.toggleDoubledAmountInputBinding, self , Sprayer.actionEventDoubledAmount, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
        end
    end
end

```

### onSetLowered

**Description**

**Definition**

> onSetLowered()

**Arguments**

| any | isLowered |
|-----|-----------|

**Code**

```lua
function Sprayer:onSetLowered(isLowered)
    local spec = self.spec_sprayer

    if self.isServer then
        if spec.activateOnLowering then
            if self:getCanBeTurnedOn() then
                self:setIsTurnedOn(isLowered)
            else
                    spec.pendingActivationAfterLowering = true
                end
            end

            if not isLowered then
                spec.pendingActivationAfterLowering = false
            end
        end

        if spec.activateTankOnLowering then
            for _, supportedSprayType in ipairs(spec.supportedSprayTypes) do
                for _, src in ipairs(spec.fillTypeSources[supportedSprayType]) do
                    local vehicle = src.vehicle
                    if vehicle.getIsTurnedOn ~ = nil then
                        vehicle:setIsTurnedOn(isLowered, true )
                    end
                end
            end
        end
    end

```

### onSprayTypeChange

**Description**

**Definition**

> onSprayTypeChange()

**Arguments**

| any | activeSprayType |
|-----|-----------------|

**Code**

```lua
function Sprayer:onSprayTypeChange(activeSprayType)
    local spec = self.spec_sprayer
    for _, sprayType in ipairs(spec.sprayTypes) do
        ObjectChangeUtil.setObjectChanges(sprayType.objectChanges, sprayType = = activeSprayType, self , self.setMovingToolDirty)
    end

    if self.setVariableWorkWidthActive ~ = nil then
        self:setVariableWorkWidthActive(activeSprayType = = nil or activeSprayType.supportsVariableWorkWidth)
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
function Sprayer:onStartWorkAreaProcessing(dt)
    local spec = self.spec_sprayer

    local fillUnitIndex = self:getSprayerFillUnitIndex()
    local sprayVehicle = nil
    local sprayVehicleFillUnitIndex = nil
    local fillType = self:getFillUnitFillType(fillUnitIndex)
    local usage = self:getSprayerUsage(fillType, dt)
    local sprayFillLevel = self:getFillUnitFillLevel(fillUnitIndex)

    if sprayFillLevel > 0 then
        sprayVehicle = self
        sprayVehicleFillUnitIndex = fillUnitIndex
    else
            for _, supportedSprayType in ipairs(spec.supportedSprayTypes) do
                for _, src in ipairs(spec.fillTypeSources[supportedSprayType]) do
                    local vehicle = src.vehicle
                    if vehicle:getIsFillUnitActive(src.fillUnitIndex) then
                        local vehicleFillType = vehicle:getFillUnitFillType(src.fillUnitIndex)
                        local vehicleFillLevel = vehicle:getFillUnitFillLevel(src.fillUnitIndex)
                        if vehicleFillLevel > 0 and vehicleFillType = = supportedSprayType then
                            sprayVehicle = vehicle
                            sprayVehicleFillUnitIndex = src.fillUnitIndex
                            fillType = sprayVehicle:getFillUnitFillType(sprayVehicleFillUnitIndex)
                            usage = self:getSprayerUsage(fillType, dt)
                            sprayFillLevel = vehicleFillLevel
                            break
                        end
                    else
                            -- if the ai is active we try to activate the source to activate the fill unit
                                if self:getIsAIActive() then
                                    if vehicle.setIsTurnedOn ~ = nil then
                                        if not vehicle:getIsTurnedOn() then
                                            vehicle:setIsTurnedOn( true )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                local isExternallyFilled = self:getIsSprayerExternallyFilled()
                if isExternallyFilled then
                    -- only consume when the tool is actually turned on(turned off during headlands etc.)
                    if self:getIsTurnedOn() then
                        local externalFillType, externalUsage = self:getExternalFill(fillType, dt)
                        if externalFillType ~ = FillType.UNKNOWN then
                            fillType = externalFillType
                            usage = externalUsage
                            sprayFillLevel = externalUsage

                            -- do not consume the fill unit fill level if we buy fertilizer
                                sprayVehicle = nil
                                sprayVehicleFillUnitIndex = nil
                            end
                        end
                    end

                    if isExternallyFilled ~ = spec.workAreaParameters.lastIsExternallyFilled then
                        local sprayType = self:getActiveSprayType()
                        if sprayType ~ = nil then
                            if isExternallyFilled then
                                if not sprayType.turnedAnimationExternalFill and self:getIsAnimationPlaying(sprayType.turnedAnimation) then
                                    self:stopAnimation(sprayType.turnedAnimation)
                                end
                            else
                                    if not self:getIsAnimationPlaying(sprayType.turnedAnimation) then
                                        self:playAnimation(sprayType.turnedAnimation, sprayType.turnedAnimationTurnOnSpeedScale, self:getAnimationTime(sprayType.turnedAnimation), true )
                                    end
                                end
                            end

                            if isExternallyFilled then
                                if not spec.turnedAnimationExternalFill and self:getIsAnimationPlaying(spec.turnedAnimation) then
                                    self:stopAnimation(spec.turnedAnimation)
                                end
                            else
                                    if not self:getIsAnimationPlaying(spec.turnedAnimation) then
                                        self:playAnimation(spec.turnedAnimation, spec.turnedAnimationTurnOnSpeedScale, self:getAnimationTime(spec.turnedAnimation), true )
                                    end
                                end

                                spec.workAreaParameters.lastIsExternallyFilled = isExternallyFilled
                            end

                            if self.isServer then
                                if fillType ~ = FillType.UNKNOWN and fillType ~ = spec.workAreaParameters.sprayFillType then
                                    self:setSprayerAITerrainDetailProhibitedRange(fillType)
                                end
                            end

                            spec.workAreaParameters.sprayType = g_sprayTypeManager:getSprayTypeIndexByFillTypeIndex(fillType)
                            spec.workAreaParameters.sprayFillType = fillType
                            spec.workAreaParameters.sprayFillLevel = sprayFillLevel
                            spec.workAreaParameters.usage = usage
                            spec.workAreaParameters.usagePerMin = usage / dt * 1000 * 60
                            spec.workAreaParameters.sprayVehicle = sprayVehicle
                            spec.workAreaParameters.sprayVehicleFillUnitIndex = sprayVehicleFillUnitIndex
                            spec.workAreaParameters.lastChangedArea = 0
                            spec.workAreaParameters.lastTotalArea = 0
                            spec.workAreaParameters.lastStatsArea = 0
                            spec.workAreaParameters.isActive = false

                            spec.isWorking = false
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
function Sprayer:onStateChange(state, data)
    if state = = VehicleStateChange.ATTACH or state = = VehicleStateChange.DETACH or state = = VehicleStateChange.FILLTYPE_CHANGE then
        local spec = self.spec_sprayer

        spec.fillTypeSources = { }
        local supportedFillTypes = self:getFillUnitSupportedFillTypes( self:getSprayerFillUnitIndex())
        spec.supportedSprayTypes = { }

        if supportedFillTypes ~ = nil then
            for fillType, supported in pairs(supportedFillTypes) do
                if supported then
                    spec.fillTypeSources[fillType] = { }
                    table.insert(spec.supportedSprayTypes, fillType)
                end
            end
        end

        local root = self.rootVehicle
        FillUnit.addFillTypeSources(spec.fillTypeSources, root, self , spec.supportedSprayTypes)
    end
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function Sprayer:onTurnedOff()
    local spec = self.spec_sprayer
    if self.isClient then
        self:updateSprayerEffects()

        if spec.animationName ~ = "" and self.stopAnimation ~ = nil then
            self:stopAnimation(spec.animationName, true )
        end

        g_soundManager:stopSamples(spec.samples.work)

        -- deactivate effects on all spray types(the spray type has may changed during activation)
        for _, sprayType in ipairs(spec.sprayTypes) do
            g_soundManager:stopSamples(sprayType.samples.work)

            self:playAnimation(sprayType.turnedAnimation, sprayType.turnedAnimationTurnOffSpeedScale, self:getAnimationTime(sprayType.turnedAnimation), true )
        end

        self:playAnimation(spec.turnedAnimation, spec.turnedAnimationTurnOffSpeedScale, self:getAnimationTime(spec.turnedAnimation), true )
    end
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function Sprayer:onTurnedOn()
    local spec = self.spec_sprayer
    if self.isClient then
        self:updateSprayerEffects()

        if spec.animationName ~ = "" and self.playAnimation ~ = nil then
            self:playAnimation(spec.animationName, 1 , self:getAnimationTime(spec.animationName), true )
        end

        g_soundManager:playSamples(spec.samples.work)

        local sprayType = self:getActiveSprayType()
        if sprayType ~ = nil then
            g_soundManager:playSamples(sprayType.samples.work)

            if sprayType.turnedAnimationExternalFill or not self:getIsSprayerExternallyFilled() then
                self:playAnimation(sprayType.turnedAnimation, sprayType.turnedAnimationTurnOnSpeedScale, self:getAnimationTime(sprayType.turnedAnimation), true )
            end
        end

        if spec.turnedAnimationExternalFill or not self:getIsSprayerExternallyFilled() then
            self:playAnimation(spec.turnedAnimation, spec.turnedAnimationTurnOnSpeedScale, self:getAnimationTime(spec.turnedAnimation), true )
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
function Sprayer:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local activeSprayType = self:getActiveSprayType()
    if activeSprayType ~ = nil then
        local spec = self.spec_sprayer
        if activeSprayType ~ = spec.lastActiveSprayType then
            for _, sprayType in ipairs(spec.sprayTypes) do
                if sprayType = = spec.lastActiveSprayType then
                    g_effectManager:stopEffects(sprayType.effects)
                    g_animationManager:stopAnimations(sprayType.animationNodes)
                end
            end

            SpecializationUtil.raiseEvent( self , "onSprayTypeChange" , activeSprayType)
            spec.lastActiveSprayType = activeSprayType

            self:updateSprayerEffects( true )
        end
    end

    if self.isClient then
        local spec = self.spec_sprayer
        local actionEvent = spec.actionEvents[spec.toggleDoubledAmountInputBinding]
        if actionEvent ~ = nil then
            local text
            if spec.doubledAmountIsActive then
                text = spec.doubledAmountDeactivateText
            else
                    text = spec.doubledAmountActivateText
                end
                g_inputBinding:setActionEventText(actionEvent.actionEventId, text)

                local _, isAllowed = self:getSprayerDoubledAmountActive(spec.workAreaParameters.sprayType)
                g_inputBinding:setActionEventActive(actionEvent.actionEventId, isAllowed)
            end
        end

        if self.isServer then
            local spec = self.spec_sprayer
            if spec.pendingActivationAfterLowering then
                if self:getCanBeTurnedOn() then
                    self:setIsTurnedOn( true )
                    spec.pendingActivationAfterLowering = false
                end
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
function Sprayer:onVariableWorkWidthSectionChanged()
    self:updateSprayerEffects( true )
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
function Sprayer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and
    SpecializationUtil.hasSpecialization( WorkArea , specializations) and
    SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
end

```

### processSprayerArea

**Description**

**Definition**

> processSprayerArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Sprayer:processSprayerArea(workArea, dt)
    local spec = self.spec_sprayer

    if self:getIsAIActive() and self.isServer then
        if spec.workAreaParameters.sprayFillType = = nil or spec.workAreaParameters.sprayFillType = = FillType.UNKNOWN then
            local rootVehicle = self.rootVehicle
            rootVehicle:stopCurrentAIJob( AIMessageErrorOutOfFill.new())

            return 0 , 0
        end
    end

    if spec.workAreaParameters.sprayFillLevel < = 0 then
        return 0 , 0
    end

    local sx,_,sz = getWorldTranslation(workArea.start)
    local wx,_,wz = getWorldTranslation(workArea.width)
    local hx,_,hz = getWorldTranslation(workArea.height)

    if not self.isServer and self.currentUpdateDistance > Sprayer.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local sprayAmount = self:getSprayerDoubledAmountActive(spec.workAreaParameters.sprayType) and 2 or 1
    local changedArea, totalArea = FSDensityMapUtil.updateSprayArea(sx,sz, wx,wz, hx,hz, spec.workAreaParameters.sprayType, sprayAmount)

    spec.workAreaParameters.isActive = true
    spec.workAreaParameters.lastChangedArea = spec.workAreaParameters.lastChangedArea + changedArea
    spec.workAreaParameters.lastStatsArea = spec.workAreaParameters.lastStatsArea + changedArea
    spec.workAreaParameters.lastTotalArea = spec.workAreaParameters.lastTotalArea + totalArea
    spec.workAreaParameters.lastSprayTime = g_ time

    if self:getLastSpeed() > 1 then
        spec.isWorking = true
    end

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
function Sprayer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetach" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onSetLowered" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onSprayTypeChange" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementEnd" , Sprayer )
    SpecializationUtil.registerEventListener(vehicleType, "onVariableWorkWidthSectionChanged" , Sprayer )
end

```

### registerEvents

**Description**

**Definition**

> registerEvents()

**Arguments**

| any | vehicleType |
|-----|-------------|

**Code**

```lua
function Sprayer.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onSprayTypeChange" )
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
function Sprayer.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processSprayerArea" , Sprayer.processSprayerArea)
    SpecializationUtil.registerFunction(vehicleType, "getIsSprayerExternallyFilled" , Sprayer.getIsSprayerExternallyFilled)
    SpecializationUtil.registerFunction(vehicleType, "getExternalFill" , Sprayer.getExternalFill)
    SpecializationUtil.registerFunction(vehicleType, "getAreEffectsVisible" , Sprayer.getAreEffectsVisible)
    SpecializationUtil.registerFunction(vehicleType, "updateSprayerEffects" , Sprayer.updateSprayerEffects)
    SpecializationUtil.registerFunction(vehicleType, "getSprayerUsage" , Sprayer.getSprayerUsage)
    SpecializationUtil.registerFunction(vehicleType, "getUseSprayerAIRequirements" , Sprayer.getUseSprayerAIRequirements)
    SpecializationUtil.registerFunction(vehicleType, "setSprayerAITerrainDetailProhibitedRange" , Sprayer.setSprayerAITerrainDetailProhibitedRange)
    SpecializationUtil.registerFunction(vehicleType, "getSprayerFillUnitIndex" , Sprayer.getSprayerFillUnitIndex)
    SpecializationUtil.registerFunction(vehicleType, "loadSprayTypeFromXML" , Sprayer.loadSprayTypeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getActiveSprayType" , Sprayer.getActiveSprayType)
    SpecializationUtil.registerFunction(vehicleType, "getIsSprayTypeActive" , Sprayer.getIsSprayTypeActive)
    SpecializationUtil.registerFunction(vehicleType, "setSprayerDoubledAmountActive" , Sprayer.setSprayerDoubledAmountActive)
    SpecializationUtil.registerFunction(vehicleType, "getSprayerDoubledAmountActive" , Sprayer.getSprayerDoubledAmountActive)
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
function Sprayer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDrawFirstFillText" , Sprayer.getDrawFirstFillText)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreControlledActionsAllowed" , Sprayer.getAreControlledActionsAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleTurnedOn" , Sprayer.getCanToggleTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , Sprayer.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Sprayer.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , Sprayer.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Sprayer.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRawSpeedLimit" , Sprayer.getRawSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillVolumeUVScrollSpeed" , Sprayer.getFillVolumeUVScrollSpeed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIRequiresTurnOffOnHeadland" , Sprayer.getAIRequiresTurnOffOnHeadland)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Sprayer.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Sprayer.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getEffectByNode" , Sprayer.getEffectByNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getVariableWorkWidthUsage" , Sprayer.getVariableWorkWidthUsage)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIImplementUseVineSegment" , Sprayer.getAIImplementUseVineSegment)
end

```

### setSprayerAITerrainDetailProhibitedRange

**Description**

**Definition**

> setSprayerAITerrainDetailProhibitedRange()

**Arguments**

| any | fillType |
|-----|----------|

**Code**

```lua
function Sprayer:setSprayerAITerrainDetailProhibitedRange(fillType)
    if self:getUseSprayerAIRequirements() then
        if self.addAITerrainDetailProhibitedRange ~ = nil then
            self:clearAITerrainDetailRequiredRange()
            self:clearAITerrainDetailProhibitedRange()
            self:clearAIFruitRequirements()
            self:clearAIFruitProhibitions()

            local sprayTypeDesc = g_sprayTypeManager:getSprayTypeByFillTypeIndex(fillType)
            if sprayTypeDesc ~ = nil then
                if sprayTypeDesc.isHerbicide then
                    local weedSystem = g_currentMission.weedSystem
                    if weedSystem ~ = nil then
                        local weedMapId, weedFirstChannel, weedNumChannels = weedSystem:getDensityMapData()
                        local replacementData = weedSystem:getHerbicideReplacements()
                        if replacementData.weed ~ = nil then
                            local startState, lastState = - 1 , - 1
                            for sourceState, targetState in pairs(replacementData.weed.replacements) do
                                if startState = = - 1 then
                                    startState = sourceState
                                else
                                        if sourceState ~ = lastState + 1 then
                                            self:addAIFruitRequirement( nil , startState, lastState, weedMapId, weedFirstChannel, weedNumChannels)
                                            startState = sourceState
                                        end
                                    end

                                    lastState = sourceState
                                end

                                if startState ~ = - 1 then
                                    self:addAIFruitRequirement( nil , startState, lastState, weedMapId, weedFirstChannel, weedNumChannels)
                                end
                            end
                        end
                    elseif sprayTypeDesc.isFertilizer then
                            self:addAIGroundTypeRequirements( Sprayer.AI_REQUIRED_GROUND_TYPES)

                            local mission = g_currentMission
                            local sprayTypeMapId, sprayTypeFirstChannel, sprayTypeNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.SPRAY_TYPE)
                            local sprayLevelMapId, sprayLevelFirstChannel, sprayLevelNumChannels = mission.fieldGroundSystem:getDensityMapData(FieldDensityMap.SPRAY_LEVEL)
                            local sprayLevelMaxValue = mission.fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL)
                            self:addAIFruitProhibitions( 0 , sprayTypeDesc.sprayGroundType, sprayTypeDesc.sprayGroundType, sprayTypeMapId, sprayTypeFirstChannel, sprayTypeNumChannels)
                            self:addAIFruitProhibitions( 0 , sprayLevelMaxValue, sprayLevelMaxValue, sprayLevelMapId, sprayLevelFirstChannel, sprayLevelNumChannels)
                        elseif sprayTypeDesc.isLime then
                                self:addAIGroundTypeRequirements( Sprayer.AI_REQUIRED_GROUND_TYPES)

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

### setSprayerDoubledAmountActive

**Description**

**Definition**

> setSprayerDoubledAmountActive()

**Arguments**

| any | isActive    |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Sprayer:setSprayerDoubledAmountActive(isActive, noEventSend)
    local spec = self.spec_sprayer
    if isActive ~ = spec.doubledAmountIsActive then
        spec.doubledAmountIsActive = isActive

        SprayerDoubledAmountEvent.sendEvent( self , isActive, noEventSend)
    end
end

```

### updateSprayerEffects

**Description**

**Definition**

> updateSprayerEffects()

**Arguments**

| any | force |
|-----|-------|

**Code**

```lua
function Sprayer:updateSprayerEffects(force)
    local spec = self.spec_sprayer

    local effectsState = self:getAreEffectsVisible()
    if effectsState ~ = spec.lastEffectsState or force then
        if effectsState then
            local fillUnitIndex = self:getSprayerFillUnitIndex()
            local fillType = self:getFillUnitLastValidFillType(fillUnitIndex)
            if fillType = = FillType.UNKNOWN then
                fillType = self:getFillUnitFirstSupportedFillType(fillUnitIndex)
            end

            g_effectManager:setEffectTypeInfo(spec.effects, fillType)
            g_effectManager:startEffects(spec.effects)

            g_soundManager:playSamples(spec.samples.spray)

            local sprayType = self:getActiveSprayType()
            if sprayType ~ = nil then
                g_effectManager:setEffectTypeInfo(sprayType.effects, fillType)
                g_effectManager:startEffects(sprayType.effects)

                g_animationManager:startAnimations(sprayType.animationNodes)

                g_soundManager:playSamples(sprayType.samples.spray)
            end

            g_animationManager:startAnimations(spec.animationNodes)
        else
                g_effectManager:stopEffects(spec.effects)
                g_animationManager:stopAnimations(spec.animationNodes)

                g_soundManager:stopSamples(spec.samples.spray)

                -- deactivate effects on all spray types(the spray type has may changed during activation)
                for _, sprayType in ipairs(spec.sprayTypes) do
                    g_effectManager:stopEffects(sprayType.effects)
                    g_animationManager:stopAnimations(sprayType.animationNodes)

                    g_soundManager:stopSamples(sprayType.samples.spray)
                end
            end

            spec.lastEffectsState = effectsState
        end
    end

```