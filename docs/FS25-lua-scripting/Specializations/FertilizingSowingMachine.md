## FertilizingSowingMachine

**Description**

> Specialization for sowing machines which also have a fertilizing function

**Functions**

- [getAreEffectsVisible](#getareeffectsvisible)
- [getUseSprayerAIRequirements](#getusesprayerairequirements)
- [initSpecialization](#initspecialization)
- [onLoad](#onload)
- [prerequisitesPresent](#prerequisitespresent)
- [processSowingMachineArea](#processsowingmachinearea)
- [registerEventListeners](#registereventlisteners)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)

### getAreEffectsVisible

**Description**

**Definition**

> getAreEffectsVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FertilizingSowingMachine:getAreEffectsVisible(superFunc)
    return superFunc( self ) and self:getFillUnitFillType( self:getSprayerFillUnitIndex()) ~ = FillType.UNKNOWN
end

```

### getUseSprayerAIRequirements

**Description**

**Definition**

> getUseSprayerAIRequirements()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FertilizingSowingMachine:getUseSprayerAIRequirements(superFunc)
    return false
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function FertilizingSowingMachine.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FertilizingSowingMachine" )

    schema:register(XMLValueType.BOOL, "vehicle.fertilizingSowingMachine#needsSetIsTurnedOn" , "Needs to be turned on to spray" , false )

    schema:setXMLSpecializationType()
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
function FertilizingSowingMachine:onLoad(savegame)
    local spec = self.spec_fertilizingSowingMachine
    spec.needsSetIsTurnedOn = self.xmlFile:getValue( "vehicle.fertilizingSowingMachine#needsSetIsTurnedOn" , false )

    self.spec_sprayer.needsToBeFilledToTurnOn = false
    self.spec_sprayer.useSpeedLimit = false

    self.needWaterInfo = true
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
function FertilizingSowingMachine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( SowingMachine , specializations) and SpecializationUtil.hasSpecialization( Sprayer , specializations)
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
function FertilizingSowingMachine:processSowingMachineArea(superFunc, workArea, dt)
    local spec = self.spec_fertilizingSowingMachine
    local specSowingMachine = self.spec_sowingMachine
    local specSpray = self.spec_sprayer

    local sprayerParams = specSpray.workAreaParameters
    local sowingParams = specSowingMachine.workAreaParameters
    local changedArea, totalArea

    self.spec_sowingMachine.isWorking = self:getLastSpeed() > 0.5

    if specSowingMachine.waterSeeding and not self.isInWater then
        specSowingMachine.showWaterPlantingRequiredWarning = true

        if self:getIsAIActive() then
            local rootVehicle = self.rootVehicle
            rootVehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
        end

        return 0 , 0
    elseif not specSowingMachine.waterSeeding and self.isInWater then
            specSowingMachine.showWaterPlantingProhibitedWarning = true

            if self:getIsAIActive() then
                local rootVehicle = self.rootVehicle
                rootVehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
            end

            return 0 , 0
        end

        if not sowingParams.isActive then
            return 0 , 0
        end

        if not self:getIsAIActive() or not g_currentMission.missionInfo.helperBuySeeds then
            if sowingParams.seedsVehicle = = nil then
                if self:getIsAIActive() then
                    local rootVehicle = self.rootVehicle
                    rootVehicle:stopCurrentAIJob( AIMessageErrorOutOfFill.new())
                end

                return 0 , 0
            end
        end

        -- stop the sowing machine if the fertilizer tank was filled and got empty
            -- do not stop if the tank was all the time empty
                if (specSpray.isSlurryTanker and g_currentMission.missionInfo.helperSlurrySource = = 1 )
                    or(specSpray.isManureSpreader and g_currentMission.missionInfo.helperManureSource = = 1 )
                    or(specSpray.isFertilizerSprayer and not g_currentMission.missionInfo.helperBuyFertilizer) then
                    if self:getIsAIActive() then
                        if sprayerParams.sprayFillType = = nil or sprayerParams.sprayFillType = = FillType.UNKNOWN then
                            if sprayerParams.lastAIHasSprayed ~ = nil then
                                local rootVehicle = self.rootVehicle
                                rootVehicle:stopCurrentAIJob( AIMessageErrorOutOfFill.new())
                                sprayerParams.lastAIHasSprayed = nil
                            end
                        else
                                sprayerParams.lastAIHasSprayed = true
                            end
                        end
                    end

                    if not sowingParams.canFruitBePlanted then
                        return 0 , 0
                    end

                    local startX, _, startZ = getWorldTranslation(workArea.start)
                    local widthX, _, widthZ = getWorldTranslation(workArea.width)
                    local heightX, _, heightZ = getWorldTranslation(workArea.height)

                    -- remove tireTracks
                    FSDensityMapUtil.eraseTireTrack(startX, startZ, widthX, widthZ, heightX, heightZ)

                    if not self.isServer and self.currentUpdateDistance > FertilizingSowingMachine.CLIENT_DM_UPDATE_RADIUS then
                        return 0 , 0
                    end

                    -- we need to use fertilizer as spraying type because fertilizer is the final blocking value
                    local sprayTypeIndex = SprayType.FERTILIZER
                    if sprayerParams.sprayFillLevel < = 0 or(spec.needsSetIsTurnedOn and not self:getIsTurnedOn()) then
                        sprayTypeIndex = nil
                    end

                    local fruitTypeDesc = g_fruitTypeManager:getFruitTypeByIndex(specSowingMachine.workAreaParameters.seedsFruitType)
                    if fruitTypeDesc.seedRequiredFieldType ~ = nil then
                        local cx, cz = (startX + widthX + heightX) / 3 , (startZ + widthZ + heightZ) / 3
                        if FSDensityMapUtil.getFieldTypeAtWorldPos(cx, cz) ~ = fruitTypeDesc.seedRequiredFieldType then
                            if fruitTypeDesc.seedRequiredFieldType = = FieldType.RICE then
                                specSowingMachine.showFieldTypeWarningRiceRequired = true
                            else
                                    specSowingMachine.showFieldTypeWarningRegularRequired = true
                                end

                                if self:getIsAIActive() then
                                    local rootVehicle = self.rootVehicle
                                    rootVehicle:stopCurrentAIJob( AIMessageErrorNoFieldFound.new())
                                end
                            end
                        end

                        if not specSowingMachine.useDirectPlanting then
                            changedArea, totalArea = FSDensityMapUtil.updateSowingArea(sowingParams.seedsFruitType, startX, startZ, widthX, widthZ, heightX, heightZ, sowingParams.fieldGroundType, sowingParams.ridgeSeeding, sowingParams.angle, nil , sprayTypeIndex)
                        else
                                changedArea, totalArea = FSDensityMapUtil.updateDirectSowingArea(sowingParams.seedsFruitType, startX, startZ, widthX, widthZ, heightX, heightZ, sowingParams.fieldGroundType, sowingParams.ridgeSeeding, sowingParams.angle, nil , sprayTypeIndex)
                            end

                            self.spec_sowingMachine.isProcessing = self.spec_sowingMachine.isWorking

                            if sprayTypeIndex ~ = nil then
                                local sprayAmount = specSpray.doubledAmountIsActive and 2 or 1
                                local sprayChangedArea, sprayTotalArea = FSDensityMapUtil.updateSprayArea(startX, startZ, widthX, widthZ, heightX, heightZ, sprayTypeIndex, sprayAmount)

                                sprayerParams.lastChangedArea = sprayerParams.lastChangedArea + sprayChangedArea
                                sprayerParams.lastTotalArea = sprayerParams.lastTotalArea + sprayTotalArea
                                sprayerParams.lastStatsArea = 0
                                sprayerParams.isActive = true
                                sprayerParams.lastSprayTime = g_ time

                                local farmId = self:getLastTouchedFarmlandFarmId()
                                local ha = MathUtil.areaToHa(sprayerParams.lastChangedArea, g_currentMission:getFruitPixelsToSqm())
                                g_farmManager:updateFarmStats(farmId, "sprayedHectares" , ha)
                                g_farmManager:updateFarmStats(farmId, "sprayedTime" , dt / ( 1000 * 60 ))
                                g_farmManager:updateFarmStats(farmId, "sprayUsage" , sprayerParams.usage)
                            end

                            sowingParams.lastChangedArea = sowingParams.lastChangedArea + changedArea
                            sowingParams.lastStatsArea = sowingParams.lastStatsArea + changedArea
                            sowingParams.lastTotalArea = sowingParams.lastTotalArea + totalArea

                            self:updateMissionSowingWarning(startX, startZ)

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
function FertilizingSowingMachine.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , FertilizingSowingMachine )
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
function FertilizingSowingMachine.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "processSowingMachineArea" , FertilizingSowingMachine.processSowingMachineArea)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getUseSprayerAIRequirements" , FertilizingSowingMachine.getUseSprayerAIRequirements)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreEffectsVisible" , FertilizingSowingMachine.getAreEffectsVisible)
end

```