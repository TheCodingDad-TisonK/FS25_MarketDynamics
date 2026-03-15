## FillUnit

**Description**

> Specialization for vehicles with any sort of capacity or tank. Manages filltypes, capacities, fillLevel changes

**Functions**

- [actionEventConsoleFillUnitDec](#actioneventconsolefillunitdec)
- [actionEventConsoleFillUnitInc](#actioneventconsolefillunitinc)
- [actionEventConsoleFillUnitNext](#actioneventconsolefillunitnext)
- [actionEventUnload](#actioneventunload)
- [addExactFillRootAimToUpdate](#addexactfillrootaimtoupdate)
- [addFillTypeSources](#addfilltypesources)
- [addFillUnitFillLevel](#addfillunitfilllevel)
- [addFillUnitTrigger](#addfillunittrigger)
- [debugGetSupportedFillTypesPerFillUnit](#debuggetsupportedfilltypesperfillunit)
- [emptyAllFillUnits](#emptyallfillunits)
- [getAdditionalComponentMass](#getadditionalcomponentmass)
- [getAlarmTriggerIsActive](#getalarmtriggerisactive)
- [getAllowLoadTriggerActivation](#getallowloadtriggeractivation)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getCapacityFromXml](#getcapacityfromxml)
- [getDoConsumePtoPower](#getdoconsumeptopower)
- [getDrawFirstFillText](#getdrawfirstfilltext)
- [getFillLevelInformation](#getfilllevelinformation)
- [getFillTypeChangeThreshold](#getfilltypechangethreshold)
- [getFillTypeNamesFromXML](#getfilltypenamesfromxml)
- [getFillUnitAllowsFillType](#getfillunitallowsfilltype)
- [getFillUnitAutoAimTargetNode](#getfillunitautoaimtargetnode)
- [getFillUnitByIndex](#getfillunitbyindex)
- [getFillUnitCanBeFilled](#getfillunitcanbefilled)
- [getFillUnitCapacity](#getfillunitcapacity)
- [getFillUnitEmptyOnReset](#getfillunitemptyonreset)
- [getFillUnitExactFillRootNode](#getfillunitexactfillrootnode)
- [getFillUnitExists](#getfillunitexists)
- [getFillUnitExtraDistanceFromNode](#getfillunitextradistancefromnode)
- [getFillUnitFillLevel](#getfillunitfilllevel)
- [getFillUnitFillLevelPercentage](#getfillunitfilllevelpercentage)
- [getFillUnitFillType](#getfillunitfilltype)
- [getFillUnitFirstSupportedFillType](#getfillunitfirstsupportedfilltype)
- [getFillUnitForcedMaterialFillType](#getfillunitforcedmaterialfilltype)
- [getFillUnitFreeCapacity](#getfillunitfreecapacity)
- [getFillUnitFromNode](#getfillunitfromnode)
- [getFillUnitHasMountedPalletsToUnload](#getfillunithasmountedpalletstounload)
- [getFillUnitIndexFromNode](#getfillunitindexfromnode)
- [getFillUnitLastValidFillType](#getfillunitlastvalidfilltype)
- [getFillUnitMountedPalletsToUnload](#getfillunitmountedpalletstounload)
- [getFillUnitRootNode](#getfillunitrootnode)
- [getFillUnits](#getfillunits)
- [getFillUnitSupportedFillTypes](#getfillunitsupportedfilltypes)
- [getFillUnitSupportedToolTypes](#getfillunitsupportedtooltypes)
- [getFillUnitSupportsFillType](#getfillunitsupportsfilltype)
- [getFillUnitSupportsToolType](#getfillunitsupportstooltype)
- [getFillUnitSupportsToolTypeAndFillType](#getfillunitsupportstooltypeandfilltype)
- [getFillUnitUnloadingTasks](#getfillunitunloadingtasks)
- [getFillUnitUnloadPalletFilename](#getfillunitunloadpalletfilename)
- [getFirstValidFillUnitToFill](#getfirstvalidfillunittofill)
- [getIsAttacherJointCompatible](#getisattacherjointcompatible)
- [getIsFillAllowedFromFarm](#getisfillallowedfromfarm)
- [getIsFillUnitActive](#getisfillunitactive)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsLevelerPickupNodeActive](#getislevelerpickupnodeactive)
- [getIsMovingToolActive](#getismovingtoolactive)
- [getIsPowerTakeOffActive](#getispowertakeoffactive)
- [getIsReadyForAutomatedTrainTravel](#getisreadyforautomatedtraintravel)
- [getSpecValueCapacity](#getspecvaluecapacity)
- [getSpecValueFillTypes](#getspecvaluefilltypes)
- [getSpecValueStartFillUnitMassByMassData](#getspecvaluestartfillunitmassbymassdata)
- [initSpecialization](#initspecialization)
- [loadAlarmTrigger](#loadalarmtrigger)
- [loadAttacherJointFromXML](#loadattacherjointfromxml)
- [loadFillPlane](#loadfillplane)
- [loadFillTypeMaterials](#loadfilltypematerials)
- [loadFillUnitFromXML](#loadfillunitfromxml)
- [loadFillUnitUnloadingFromXML](#loadfillunitunloadingfromxml)
- [loadLevelerNodeFromXML](#loadlevelernodefromxml)
- [loadMeasurementNode](#loadmeasurementnode)
- [loadMovingToolFromXML](#loadmovingtoolfromxml)
- [loadSpecValueCapacity](#loadspecvaluecapacity)
- [loadSpecValueFillTypes](#loadspecvaluefilltypes)
- [loadSpecValueFillUnitMassData](#loadspecvaluefillunitmassdata)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onDischargeTargetObjectChanged](#ondischargetargetobjectchanged)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onPostUpdate](#onpostupdate)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerUnitDisplaySchema](#registerunitdisplayschema)
- [removeFillUnitTrigger](#removefillunittrigger)
- [saveStatsToXMLFile](#savestatstoxmlfile)
- [saveToXMLFile](#savetoxmlfile)
- [setAlarmTriggerState](#setalarmtriggerstate)
- [setFillPlaneForcedFillType](#setfillplaneforcedfilltype)
- [setFillSoundIsPlaying](#setfillsoundisplaying)
- [setFillUnitCapacity](#setfillunitcapacity)
- [setFillUnitCapacityToDisplay](#setfillunitcapacitytodisplay)
- [setFillUnitFillLevelToDisplay](#setfillunitfillleveltodisplay)
- [setFillUnitFillType](#setfillunitfilltype)
- [setFillUnitFillTypeToDisplay](#setfillunitfilltypetodisplay)
- [setFillUnitForcedMaterialFillType](#setfillunitforcedmaterialfilltype)
- [setFillUnitInTriggerRange](#setfillunitintriggerrange)
- [setFillUnitIsFilling](#setfillunitisfilling)
- [setFillUnitLastValidFillType](#setfillunitlastvalidfilltype)
- [showInfo](#showinfo)
- [unloadFillUnits](#unloadfillunits)
- [updateAlarmTriggers](#updatealarmtriggers)
- [updateFillTypeMaterials](#updatefilltypematerials)
- [updateFillUnitAutoAimTarget](#updatefillunitautoaimtarget)
- [updateFillUnitFillPlane](#updatefillunitfillplane)
- [updateFillUnitTriggers](#updatefillunittriggers)
- [updateMeasurementNodes](#updatemeasurementnodes)
- [updateUnloadActionDisplay](#updateunloadactiondisplay)

### actionEventConsoleFillUnitDec

**Description**

**Definition**

> actionEventConsoleFillUnitDec()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function FillUnit.actionEventConsoleFillUnitDec( self , actionName, inputValue, callbackState, isAnalog)
    if self:getIsSelected() then
        local fillType = self:getFillUnitFillType( 1 )
        self:addFillUnitFillLevel( self:getOwnerFarmId(), 1 , - 1000 , fillType, ToolType.UNDEFINED, nil )
    end
end

```

### actionEventConsoleFillUnitInc

**Description**

**Definition**

> actionEventConsoleFillUnitInc()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function FillUnit.actionEventConsoleFillUnitInc( self , actionName, inputValue, callbackState, isAnalog)
    if self:getIsSelected() then
        local fillType = self:getFillUnitFillType( 1 )
        if fillType = = FillType.UNKNOWN then
            local fillUnit = self:getFillUnitByIndex( 1 )
            fillType = next(fillUnit.supportedFillTypes)
        end
        self:addFillUnitFillLevel( self:getOwnerFarmId(), 1 , 1000 , fillType, ToolType.UNDEFINED, nil )
    end
end

```

### actionEventConsoleFillUnitNext

**Description**

**Definition**

> actionEventConsoleFillUnitNext()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function FillUnit.actionEventConsoleFillUnitNext( self , actionName, inputValue, callbackState, isAnalog)
    if self:getIsSelected() then
        local fillType = self:getFillUnitFillType( 1 )
        local fillUnit = self:getFillUnitByIndex( 1 )
        local found = false
        local nextFillType = nil
        for supportedFillType,_ in pairs(fillUnit.supportedFillTypes) do
            if not found then
                if supportedFillType = = fillType then
                    found = true
                end
            else
                    nextFillType = supportedFillType
                    break
                end
            end

            if nextFillType = = nil then
                nextFillType = next(fillUnit.supportedFillTypes)
            end

            self:addFillUnitFillLevel( self:getOwnerFarmId(), 1 , - math.huge, fillType, ToolType.UNDEFINED, nil )
            self:addFillUnitFillLevel( self:getOwnerFarmId(), 1 , 100 , nextFillType, ToolType.UNDEFINED, nil )
        end
    end

```

### actionEventUnload

**Description**

**Definition**

> actionEventUnload()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function FillUnit.actionEventUnload( self , actionName, inputValue, callbackState, isAnalog)
    self:unloadFillUnits()
end

```

### addExactFillRootAimToUpdate

**Description**

**Definition**

> addExactFillRootAimToUpdate()

**Arguments**

| any | vehicle |
|-----|---------|
| any | func    |

**Code**

```lua
function FillUnit:addExactFillRootAimToUpdate(vehicle, func)
    local spec = self.spec_fillUnit
    spec.exactFillRootNodeAimToUpdate[vehicle] = func
end

```

### addFillTypeSources

**Description**

**Definition**

> addFillTypeSources()

**Arguments**

| any | sources        |
|-----|----------------|
| any | currentVehicle |
| any | excludeVehicle |
| any | fillTypes      |

**Code**

```lua
function FillUnit.addFillTypeSources(sources, currentVehicle, excludeVehicle, fillTypes)
    if currentVehicle ~ = excludeVehicle then
        local curVehicle = currentVehicle.spec_fillUnit
        if curVehicle ~ = nil then
            for fillUnitIndex2, fillUnit2 in pairs(curVehicle.fillUnits) do
                for _,fillType in pairs(fillTypes) do
                    if fillUnit2.supportedFillTypes[fillType] then
                        if sources[fillType] = = nil then
                            sources[fillType] = { }
                        end
                        table.insert(sources[fillType], { vehicle = currentVehicle, fillUnitIndex = fillUnitIndex2 } )
                    end
                end
            end
        end
    end

    if currentVehicle.getAttachedImplements ~ = nil then
        local attachedImplements = currentVehicle:getAttachedImplements()
        for _,implement in pairs(attachedImplements) do
            if implement.object ~ = nil then
                FillUnit.addFillTypeSources(sources, implement.object, excludeVehicle, fillTypes)
            end
        end
    end
end

```

### addFillUnitFillLevel

**Description**

**Definition**

> addFillUnitFillLevel()

**Arguments**

| any | farmId           |
|-----|------------------|
| any | fillUnitIndex    |
| any | fillLevelDelta   |
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |

**Code**

```lua
function FillUnit:addFillUnitFillLevel(farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData)
    local spec = self.spec_fillUnit
    spec.isInfoDirty = true

    -- Check for permission.Do allow vehicles with farmId 0(all-access vehicles).
        -- Only check for access if value is being removed
            if fillLevelDelta < 0 and not g_currentMission.accessHandler:canFarmAccess(farmId, self , true ) and not g_guidedTourManager:getIsTourRunning() then
                return 0
            end

            -- If this fillunit belongs to a mounted object(pallet), check that the controller of the object
            -- is allowed to empty the fill unit.
            if self.getDynamicMountObject ~ = nil then
                local mounter = self:getDynamicMountObject()
                if mounter ~ = nil then
                    -- if the active farm of the mounter has NO access to farmId fill unit:disallow
                        if not g_currentMission.accessHandler:canFarmAccess(mounter:getActiveFarm(), self , true ) then
                            return 0
                        end
                    end
                end

                local fillUnit = spec.fillUnits[fillUnitIndex]
                if fillUnit ~ = nil then
                    if fillLevelDelta > 0 then
                        if not fillUnit.ignoreFillLimit then
                            if g_currentMission.missionInfo.trailerFillLimit and self:getMaxComponentMassReached() then
                                return 0
                            end
                        end
                    end

                    if not self:getFillUnitSupportsToolTypeAndFillType(fillUnitIndex, toolType, fillTypeIndex) then
                        return 0
                    end

                    -- apply limit only on server side, client will receive the correct data
                    if self.isServer then
                        if fillLevelDelta > 0 then
                            if not fillUnit.ignoreFillLimit then
                                if g_currentMission.missionInfo.trailerFillLimit then
                                    local maxMassToApply = self:getAvailableComponentMass()
                                    local fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
                                    if fillTypeDesc ~ = nil and fillTypeDesc.massPerLiter ~ = 0 then
                                        fillLevelDelta = math.min(fillLevelDelta, maxMassToApply / fillTypeDesc.massPerLiter)
                                    end
                                end
                            end
                        end
                    end

                    local oldFillLevel = fillUnit.fillLevel
                    local capacity = fillUnit.capacity
                    if capacity = = 0 then
                        capacity = math.huge
                    end

                    local fillTypeChanged = false
                    if fillUnit.fillType = = fillTypeIndex then
                        fillUnit.fillLevel = math.max( 0 , math.min(capacity, oldFillLevel + fillLevelDelta))
                    else
                            if fillLevelDelta > 0 then
                                local allowFillType = self:getFillUnitAllowsFillType(fillUnitIndex, fillTypeIndex)
                                if allowFillType then
                                    local oldFillTypeIndex = fillUnit.fillType
                                    if oldFillLevel > 0 then
                                        local oldRemoveOnEmpty = spec.removeVehicleIfEmpty
                                        spec.removeVehicleIfEmpty = false -- do not remove vehicle if we directly fill it again

                                            self:addFillUnitFillLevel(farmId, fillUnitIndex, - math.huge, fillUnit.fillType, toolType, fillPositionData)

                                            spec.removeVehicleIfEmpty = oldRemoveOnEmpty
                                        end
                                        oldFillLevel = 0
                                        fillUnit.fillLevel = math.max( 0 , math.min(capacity, fillLevelDelta))
                                        fillUnit.fillType = fillTypeIndex

                                        fillTypeChanged = true
                                        self.rootVehicle:raiseStateChange(VehicleStateChange.FILLTYPE_CHANGE)
                                        SpecializationUtil.raiseEvent( self , "onChangedFillType" , fillUnitIndex, fillTypeIndex, oldFillTypeIndex)
                                    else
                                            return 0
                                        end
                                    end
                                end

                                -- reset fill level if below threshold due to float 32 inaccuracy
                                    if fillUnit.fillLevel < 0.00001 then
                                        fillUnit.fillLevel = 0
                                    end

                                    if fillUnit.fillLevel > 0 then
                                        fillUnit.lastValidFillType = fillUnit.fillType
                                    else
                                            SpecializationUtil.raiseEvent( self , "onChangedFillType" , fillUnitIndex, FillType.UNKNOWN, fillUnit.fillType)
                                            fillUnit.fillType = FillType.UNKNOWN

                                            if not fillUnit.fillTypeToDisplayIsPersistent then
                                                fillUnit.fillTypeToDisplay = FillType.UNKNOWN
                                            end

                                            if not fillUnit.fillLevelToDisplayIsPersistent then
                                                fillUnit.fillLevelToDisplay = nil
                                            end
                                        end

                                        local appliedDelta = fillUnit.fillLevel - oldFillLevel

                                        if self.isServer then
                                            -- prepare for network
                                                if fillUnit.synchronizeFillLevel then
                                                    local hasChanged = false
                                                    if fillUnit.fillLevel ~ = fillUnit.fillLevelSent then
                                                        local maxValue = 2 ^ fillUnit.synchronizationNumBits - 1
                                                        local levelPerBit = fillUnit.capacity / maxValue
                                                        local changedLevel = math.abs(fillUnit.fillLevel - fillUnit.fillLevelSent)

                                                        if changedLevel > levelPerBit then
                                                            fillUnit.fillLevelSent = fillUnit.fillLevel
                                                            hasChanged = true
                                                        end
                                                    end
                                                    if fillUnit.fillType ~ = fillUnit.fillTypeSent then
                                                        fillUnit.fillTypeSent = fillUnit.fillType
                                                        hasChanged = true
                                                    end
                                                    if fillUnit.lastValidFillType ~ = fillUnit.lastValidFillTypeSent then
                                                        fillUnit.lastValidFillTypeSent = fillUnit.lastValidFillType
                                                        hasChanged = true
                                                    end
                                                    if hasChanged then
                                                        self:raiseDirtyFlags(spec.dirtyFlag)
                                                    end
                                                end
                                            end

                                            if fillUnit.updateMass then
                                                self:setMassDirty()
                                            end

                                            self:updateFillUnitAutoAimTarget(fillUnit)

                                            if self.isClient then
                                                self:updateAlarmTriggers(fillUnit.alarmTriggers)
                                                self:updateFillUnitFillPlane(fillUnit)
                                                self:updateMeasurementNodes(fillUnit, 0 , true )

                                                if fillTypeChanged then
                                                    self:updateFillTypeMaterials(fillUnit.fillTypeMaterials, fillUnit.fillType)
                                                end
                                            end

                                            SpecializationUtil.raiseEvent( self , "onFillUnitFillLevelChanged" , fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)

                                            if self.isServer then
                                                if spec.removeVehicleIfEmpty and fillUnit.fillLevel < = spec.removeVehicleThreshold and fillLevelDelta ~ = 0 then
                                                    if spec.removeVehicleDelay = = 0 then
                                                        self:delete()

                                                        if spec.removeVehicleReward > 0 then
                                                            g_currentMission:addMoney(spec.removeVehicleReward, self:getOwnerFarmId(), MoneyType.SOLD_PRODUCTS, true , true )
                                                        end
                                                    else
                                                            Timer.createOneshot(spec.removeVehicleDelay, function ()
                                                                if not self.isDeleted then
                                                                    self:delete()
                                                                end

                                                                if spec.removeVehicleReward > 0 then
                                                                    g_currentMission:addMoney(spec.removeVehicleReward, self:getOwnerFarmId(), MoneyType.SOLD_PRODUCTS, true , true )
                                                                end
                                                            end )
                                                        end
                                                    end
                                                end

                                                if appliedDelta > 0 then
                                                    -- display default effects
                                                    if #spec.fillEffects > 0 then
                                                        g_effectManager:setEffectTypeInfo(spec.fillEffects, fillUnit.fillType)
                                                        g_effectManager:startEffects(spec.fillEffects)

                                                        spec.activeFillEffects[spec.fillEffects] = 500
                                                    end

                                                    -- display fill unit effects
                                                    if #fillUnit.fillEffects > 0 then
                                                        g_effectManager:setEffectTypeInfo(fillUnit.fillEffects, fillUnit.fillType)
                                                        g_effectManager:startEffects(fillUnit.fillEffects)

                                                        spec.activeFillEffects[fillUnit.fillEffects] = 500
                                                    end

                                                    -- start default animation nodes
                                                    if #spec.animationNodes > 0 then
                                                        g_animationManager:startAnimations(spec.animationNodes)
                                                        spec.activeFillAnimations[spec.animationNodes] = 500
                                                    end

                                                    -- start fill unit animation nodes
                                                    if #fillUnit.animationNodes > 0 then
                                                        g_animationManager:startAnimations(fillUnit.animationNodes)
                                                        spec.activeFillAnimations[fillUnit.animationNodes] = 500
                                                    end

                                                    if fillUnit.fillAnimation ~ = nil then
                                                        if fillUnit.fillAnimationLoadTime ~ = nil then
                                                            local animTime = self:getAnimationTime(fillUnit.fillAnimation)
                                                            local direction = math.sign(fillUnit.fillAnimationLoadTime - animTime)
                                                            if direction ~ = 0 then
                                                                self:playAnimation(fillUnit.fillAnimation, direction, animTime)
                                                                self:setAnimationStopTime(fillUnit.fillAnimation, fillUnit.fillAnimationLoadTime)
                                                            end
                                                        end
                                                    end
                                                end

                                                if appliedDelta ~ = 0 then
                                                    for _, fillLevelAnimation in ipairs(fillUnit.fillLevelAnimations) do
                                                        if fillUnit.fillLevel > 0 or fillLevelAnimation.resetOnEmpty then
                                                            local currentTime = self:getAnimationTime(fillLevelAnimation.name)
                                                            local targetTime = fillUnit.fillLevel / fillUnit.capacity
                                                            if fillLevelAnimation.useMaxStateIfEmpty and fillUnit.fillLevel = = 0 then
                                                                targetTime = 1
                                                            end
                                                            if not fillLevelAnimation.updateWhileFilled and fillLevelDelta > 0 then
                                                                targetTime = 1
                                                            end

                                                            self:setAnimationStopTime(fillLevelAnimation.name, targetTime)

                                                            local speedScale = math.sign(targetTime - currentTime)
                                                            self:playAnimation(fillLevelAnimation.name, speedScale, currentTime, true )
                                                        end
                                                    end

                                                    if fillUnit.hasDashboards and self.updateDashboardValueType ~ = nil then
                                                        self:updateDashboardValueType( "fillUnit.fillLevel" )
                                                        self:updateDashboardValueType( "fillUnit.fillLevelPct" )
                                                        self:updateDashboardValueType( "fillUnit.fillLevelWarning" )
                                                    end

                                                    FillUnit.updateUnloadActionDisplay( self )
                                                end

                                                if fillUnit.fillLevel < 0.0001 then
                                                    if fillUnit.fillAnimation ~ = nil then
                                                        if fillUnit.fillAnimationEmptyTime ~ = nil then
                                                            local animTime = self:getAnimationTime(fillUnit.fillAnimation)
                                                            local direction = math.sign(fillUnit.fillAnimationEmptyTime - animTime)
                                                            self:playAnimation(fillUnit.fillAnimation, direction, animTime)
                                                            self:setAnimationStopTime(fillUnit.fillAnimation, fillUnit.fillAnimationEmptyTime)
                                                        end
                                                    end
                                                end

                                                if self.isServer then
                                                    if not spec.allowFoldingWhileFilled and spec.resetFoldingWhileFilled then
                                                        if fillUnit.fillLevel > (fillUnit.allowFoldingThreshold or spec.allowFoldingThreshold) and(fillUnit.allowFoldingFillType = = nil or fillUnit.allowFoldingFillType = = fillUnit.fillType) then
                                                            if self:getIsUnfolded() then
                                                                self:setFoldState( - self.spec_foldable.turnOnFoldDirection, false )
                                                            end
                                                        end
                                                    end
                                                end

                                                return appliedDelta
                                            end

                                            return 0
                                        end

```

### addFillUnitTrigger

**Description**

> Adds fill trigger

**Definition**

> addFillUnitTrigger(table trigger, integer fillTypeIndex, )

**Arguments**

| table   | trigger       | trigger       |
|---------|---------------|---------------|
| integer | fillTypeIndex | fillTypeIndex |
| any     | fillUnitIndex |               |

**Code**

```lua
function FillUnit:addFillUnitTrigger(trigger, fillTypeIndex, fillUnitIndex)
    local spec = self.spec_fillUnit
    if #spec.fillTrigger.triggers = = 0 then
        g_currentMission.activatableObjectsSystem:addActivatable(spec.fillTrigger.activatable)
        spec.fillTrigger.activatable:setFillType(fillTypeIndex)

        -- automatic filling for mobile version
            if self.isServer and Platform.gameplay.automaticFilling then
                self:setFillUnitIsFilling( true )
            end
        end
        table.addElement(spec.fillTrigger.triggers, trigger)
        SpecializationUtil.raiseEvent( self , "onAddedFillUnitTrigger" , fillTypeIndex, fillUnitIndex, #spec.fillTrigger.triggers)

        self:updateFillUnitTriggers()
    end

```

### debugGetSupportedFillTypesPerFillUnit

**Description**

> Returns table with key=fillUnitIndex and value=array of fillTypeIds

**Definition**

> debugGetSupportedFillTypesPerFillUnit()

**Code**

```lua
function FillUnit:debugGetSupportedFillTypesPerFillUnit()
    local fillUnitToFillTypes = { }
    for _, fillUnit in ipairs( self:getFillUnits()) do
        fillUnitToFillTypes[fillUnit.fillUnitIndex] = fillUnit.supportedFillTypes
    end
    return fillUnitToFillTypes
end

```

### emptyAllFillUnits

**Description**

**Definition**

> emptyAllFillUnits()

**Arguments**

| any | ignoreDeleteOnEmptyFlag |
|-----|-------------------------|

**Code**

```lua
function FillUnit:emptyAllFillUnits(ignoreDeleteOnEmptyFlag)
    local spec = self.spec_fillUnit
    local oldRemoveOnEmpty = spec.removeVehicleIfEmpty
    if ignoreDeleteOnEmptyFlag then
        spec.removeVehicleIfEmpty = false
    end

    for k, _ in ipairs( self:getFillUnits()) do
        local fillTypeIndex = self:getFillUnitFillType(k)
        self:addFillUnitFillLevel( self:getOwnerFarmId(), k, - math.huge, fillTypeIndex, ToolType.UNDEFINED, nil )
    end

    spec.removeVehicleIfEmpty = oldRemoveOnEmpty
end

```

### getAdditionalComponentMass

**Description**

**Definition**

> getAdditionalComponentMass()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | component |

**Code**

```lua
function FillUnit:getAdditionalComponentMass(superFunc, component)
    local additionalMass = superFunc( self , component)
    local spec = self.spec_fillUnit

    for _, fillUnit in ipairs(spec.fillUnits) do
        if fillUnit.updateMass and fillUnit.fillMassNode = = component.node and fillUnit.fillType ~ = nil and fillUnit.fillType ~ = FillType.UNKNOWN then
            local desc = g_fillTypeManager:getFillTypeByIndex(fillUnit.fillType)
            local mass = fillUnit.fillLevel * desc.massPerLiter
            additionalMass = additionalMass + mass
        end
    end

    return additionalMass
end

```

### getAlarmTriggerIsActive

**Description**

**Definition**

> getAlarmTriggerIsActive()

**Arguments**

| any | alarmTrigger |
|-----|--------------|

**Code**

```lua
function FillUnit:getAlarmTriggerIsActive(alarmTrigger)
    local ret = false

    local fillLevelPct = alarmTrigger.fillUnit.fillLevel / alarmTrigger.fillUnit.capacity
    if fillLevelPct > = alarmTrigger.minFillLevel and fillLevelPct < = alarmTrigger.maxFillLevel then
        ret = true
    end

    return ret
end

```

### getAllowLoadTriggerActivation

**Description**

**Definition**

> getAllowLoadTriggerActivation()

**Arguments**

| any | rootVehicle |
|-----|-------------|

**Code**

```lua
function FillUnit:getAllowLoadTriggerActivation(rootVehicle)
    -- if not g_currentMission.guidedTour:getCanBeFilledByTrigger(self) then
        -- return false
        -- end

        if self.rootVehicle = = g_localPlayer:getCurrentVehicle() then
            return true
        end

        return false
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
function FillUnit:getCanBeTurnedOn(superFunc)
    local spec = self.spec_fillUnit

    for _, alarmTrigger in pairs(spec.activeAlarmTriggers) do
        if alarmTrigger.turnOffInTrigger then
            return false
        end
    end

    return superFunc( self )
end

```

### getCapacityFromXml

**Description**

**Definition**

> getCapacityFromXml()

**Arguments**

| any | xmlFile |
|-----|---------|

**Code**

```lua
function FillUnit.getCapacityFromXml(xmlFile)
    local rootName = xmlFile:getRootName()
    local maxCapacity = 0

    xmlFile:iterate(rootName .. ".fillUnit.fillUnitConfigurations.fillUnitConfiguration" , function (_, key)
        xmlFile:iterate(key .. ".fillUnits.fillUnit" , function (_, fillUnitKey)
            maxCapacity = math.max(maxCapacity, xmlFile:getValue(fillUnitKey .. "#capacity" ) or 0 )
        end )
    end )

    return maxCapacity
end

```

### getDoConsumePtoPower

**Description**

**Definition**

> getDoConsumePtoPower()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FillUnit:getDoConsumePtoPower(superFunc)
    local fillTrigger = self.spec_fillUnit.fillTrigger
    return superFunc( self ) or(fillTrigger.isFilling and fillTrigger.consumePtoPower)
end

```

### getDrawFirstFillText

**Description**

**Definition**

> getDrawFirstFillText()

**Code**

```lua
function FillUnit:getDrawFirstFillText()
    return false
end

```

### getFillLevelInformation

**Description**

> Get fill level information

**Definition**

> getFillLevelInformation(function superFunc, table display)

**Arguments**

| function | superFunc |                        |
|----------|-----------|------------------------|
| table    | display   | fill level information |

**Code**

```lua
function FillUnit:getFillLevelInformation(superFunc, display)
    superFunc( self , display)

    local spec = self.spec_fillUnit
    for i = 1 , #spec.fillUnits do
        local fillUnit = spec.fillUnits[i]
        if fillUnit.capacity > 0 and fillUnit.showOnHud then
            local fillType = fillUnit.fillType

            -- if we only support one fill type and are empty we show the fill type
                if fillType = = FillType.UNKNOWN then
                    if table.size(fillUnit.supportedFillTypes) = = 1 then
                        fillType = next(fillUnit.supportedFillTypes)
                    end
                end

                if fillUnit.fillTypeToDisplay ~ = FillType.UNKNOWN then
                    fillType = fillUnit.fillTypeToDisplay
                end

                local fillLevel = fillUnit.fillLevel
                if fillUnit.fillLevelToDisplay ~ = nil then
                    fillLevel = fillUnit.fillLevelToDisplay
                end

                local capacity = fillUnit.capacity
                if fillUnit.capacityToDisplay ~ = nil then
                    capacity = fillUnit.capacityToDisplay
                end

                -- child and parent units will be merged together as display if one of them has a valid fill type and another an unknown fill type
                    -- capacity is used from the parent one
                    if fillUnit.parentUnitOnHud ~ = nil then
                        if fillType = = FillType.UNKNOWN then
                            fillType = spec.fillUnits[fillUnit.parentUnitOnHud].fillType
                        end
                        capacity = 0
                    elseif fillUnit.childUnitOnHud ~ = nil then
                            if fillType = = FillType.UNKNOWN then
                                fillType = spec.fillUnits[fillUnit.childUnitOnHud].fillType
                            end
                        end

                        local maxReached = not fillUnit.ignoreFillLimit and g_currentMission.missionInfo.trailerFillLimit and self:getMaxComponentMassReached()
                        display:addFillLevel(fillType, fillLevel, capacity, fillLevel > 0 and fillUnit.uiPrecision or 0 , maxReached, fillUnit.uiDisplayTypeId, fillUnit.uiCustomFillTypeName, fillUnit.uiExtraInfoText)
                    end
                end
            end

```

### getFillTypeChangeThreshold

**Description**

**Definition**

> getFillTypeChangeThreshold()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillTypeChangeThreshold(fillUnitIndex)
    if fillUnitIndex = = nil then
        return self.spec_fillUnit.fillTypeChangeThreshold
    else
            local capacity = self:getFillUnitCapacity(fillUnitIndex) or 1
            return capacity * self.spec_fillUnit.fillTypeChangeThreshold
        end
    end

```

### getFillTypeNamesFromXML

**Description**

**Definition**

> getFillTypeNamesFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|

**Code**

```lua
function FillUnit.getFillTypeNamesFromXML(xmlFile)
    local fillTypeNames = nil
    local fillTypeCategoryNames = nil
    local rootName = xmlFile:getRootName()

    xmlFile:iterate(rootName .. ".fillUnit.fillUnitConfigurations.fillUnitConfiguration" , function (_, key)
        xmlFile:iterate(key .. ".fillUnits.fillUnit" , function (_, fillUnitKey)
            local capacity = xmlFile:getValue(fillUnitKey .. "#capacity" )
            if capacity = = nil or capacity > 0 then
                local currentFillTypes = xmlFile:getValue(fillUnitKey .. "#fillTypes" )
                if currentFillTypes ~ = nil then
                    if fillTypeNames = = nil then
                        fillTypeNames = currentFillTypes
                    else
                            fillTypeNames = fillTypeNames .. " " .. currentFillTypes
                        end
                    end

                    local currentFillTypeCategories = xmlFile:getValue(fillUnitKey .. "#fillTypeCategories" )
                    if currentFillTypeCategories ~ = nil then
                        if fillTypeCategoryNames = = nil then
                            fillTypeCategoryNames = currentFillTypeCategories
                        else
                                fillTypeCategoryNames = fillTypeCategoryNames .. " " .. currentFillTypeCategories
                            end
                        end
                    end
                end )
            end )

            return { fillTypeNames = fillTypeNames, fillTypeCategoryNames = fillTypeCategoryNames }
        end

```

### getFillUnitAllowsFillType

**Description**

**Definition**

> getFillUnitAllowsFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillType      |

**Code**

```lua
function FillUnit:getFillUnitAllowsFillType(fillUnitIndex, fillType)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        if self:getFillUnitSupportsFillType(fillUnitIndex, fillType) then
            if fillType = = spec.fillUnits[fillUnitIndex].fillType then
                return true
            else
                    return(spec.fillUnits[fillUnitIndex].fillLevel / math.max(spec.fillUnits[fillUnitIndex].capacity, 0.0001 )) < = self:getFillTypeChangeThreshold()
                end
            end
        end
        return false
    end

```

### getFillUnitAutoAimTargetNode

**Description**

**Definition**

> getFillUnitAutoAimTargetNode()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitAutoAimTargetNode(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].autoAimTarget.node
    end
    return nil
end

```

### getFillUnitByIndex

**Description**

**Definition**

> getFillUnitByIndex()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitByIndex(fillUnitIndex)
    local spec = self.spec_fillUnit
    if self:getFillUnitExists(fillUnitIndex) then
        return spec.fillUnits[fillUnitIndex]
    end
    return nil
end

```

### getFillUnitCanBeFilled

**Description**

**Definition**

> getFillUnitCanBeFilled()

**Arguments**

| any | fillUnitIndex  |
|-----|----------------|
| any | fillType       |
| any | ignoreCapacity |

**Code**

```lua
function FillUnit:getFillUnitCanBeFilled(fillUnitIndex, fillType, ignoreCapacity)
    if self:getFillUnitAllowsFillType(fillUnitIndex, fillType) then
        if self:getFillUnitFreeCapacity(fillUnitIndex) > 0 or(ignoreCapacity ~ = nil and ignoreCapacity) then
            return true
        end
    end

    return false
end

```

### getFillUnitCapacity

**Description**

**Definition**

> getFillUnitCapacity()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitCapacity(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].capacity
    end
    return nil
end

```

### getFillUnitEmptyOnReset

**Description**

**Definition**

> getFillUnitEmptyOnReset()

**Code**

```lua
function FillUnit:getFillUnitEmptyOnReset()
    return true
end

```

### getFillUnitExactFillRootNode

**Description**

**Definition**

> getFillUnitExactFillRootNode()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitExactFillRootNode(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].exactFillRootNode
    end
    return nil
end

```

### getFillUnitExists

**Description**

**Definition**

> getFillUnitExists()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitExists(fillUnitIndex)
    local spec = self.spec_fillUnit
    return fillUnitIndex ~ = nil and spec.fillUnits[fillUnitIndex] ~ = nil
end

```

### getFillUnitExtraDistanceFromNode

**Description**

**Definition**

> getFillUnitExtraDistanceFromNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function FillUnit:getFillUnitExtraDistanceFromNode(node)
    local spec = self.spec_fillUnit
    return spec.exactFillRootNodeToExtraDistance[node] or 0
end

```

### getFillUnitFillLevel

**Description**

**Definition**

> getFillUnitFillLevel()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitFillLevel(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].fillLevel
    end
    return nil
end

```

### getFillUnitFillLevelPercentage

**Description**

**Definition**

> getFillUnitFillLevelPercentage()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitFillLevelPercentage(fillUnitIndex)
    local spec = self.spec_fillUnit
    local fillUnit = spec.fillUnits[fillUnitIndex]
    if fillUnit ~ = nil then
        if fillUnit.capacity > 0 then
            return fillUnit.fillLevel / fillUnit.capacity
        end

        return 0
    end

    return nil
end

```

### getFillUnitFillType

**Description**

**Definition**

> getFillUnitFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitFillType(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].fillType
    end
    return nil
end

```

### getFillUnitFirstSupportedFillType

**Description**

**Definition**

> getFillUnitFirstSupportedFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitFirstSupportedFillType(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return next(spec.fillUnits[fillUnitIndex].supportedFillTypes)
    end
    return nil
end

```

### getFillUnitForcedMaterialFillType

**Description**

**Definition**

> getFillUnitForcedMaterialFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitForcedMaterialFillType(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].forcedMaterialFillType
    end

    return FillType.UNKNOWN
end

```

### getFillUnitFreeCapacity

**Description**

> getFillUnitFreeCapacity

**Definition**

> getFillUnitFreeCapacity(integer fillUnitIndex, integer fillTypeIndex, integer farmId)

**Arguments**

| integer | fillUnitIndex |                          |
|---------|---------------|--------------------------|
| integer | fillTypeIndex | currently ignored/unused |
| integer | farmId        | currently ignored/unused |

**Code**

```lua
function FillUnit:getFillUnitFreeCapacity(fillUnitIndex, fillTypeIndex, farmId)
    local spec = self.spec_fillUnit
    local fillUnit = spec.fillUnits[fillUnitIndex]
    if fillUnit ~ = nil then
        local freeCapacity = fillUnit.capacity - fillUnit.fillLevel

        if not fillUnit.ignoreFillLimit then
            if g_currentMission.missionInfo.trailerFillLimit and self:getMaxComponentMassReached() then
                return 0
            end
        end

        return freeCapacity
    end
    return nil
end

```

### getFillUnitFromNode

**Description**

**Definition**

> getFillUnitFromNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function FillUnit:getFillUnitFromNode(node)
    local spec = self.spec_fillUnit
    return spec.exactFillRootNodeToFillUnit[node]
end

```

### getFillUnitHasMountedPalletsToUnload

**Description**

**Definition**

> getFillUnitHasMountedPalletsToUnload()

**Code**

```lua
function FillUnit:getFillUnitHasMountedPalletsToUnload()
    return false
end

```

### getFillUnitIndexFromNode

**Description**

**Definition**

> getFillUnitIndexFromNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function FillUnit:getFillUnitIndexFromNode(node)
    local spec = self.spec_fillUnit
    local fillUnit = spec.exactFillRootNodeToFillUnit[node]
    if fillUnit ~ = nil then
        return fillUnit.fillUnitIndex
    end

    return nil
end

```

### getFillUnitLastValidFillType

**Description**

**Definition**

> getFillUnitLastValidFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitLastValidFillType(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].lastValidFillType
    end
    return nil
end

```

### getFillUnitMountedPalletsToUnload

**Description**

**Definition**

> getFillUnitMountedPalletsToUnload()

**Code**

```lua
function FillUnit:getFillUnitMountedPalletsToUnload()
    return nil
end

```

### getFillUnitRootNode

**Description**

**Definition**

> getFillUnitRootNode()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitRootNode(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].fillRootNode
    end
    return nil
end

```

### getFillUnits

**Description**

**Definition**

> getFillUnits()

**Code**

```lua
function FillUnit:getFillUnits()
    local spec = self.spec_fillUnit
    return spec.fillUnits
end

```

### getFillUnitSupportedFillTypes

**Description**

**Definition**

> getFillUnitSupportedFillTypes()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitSupportedFillTypes(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].supportedFillTypes
    end
    return nil
end

```

### getFillUnitSupportedToolTypes

**Description**

**Definition**

> getFillUnitSupportedToolTypes()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitSupportedToolTypes(fillUnitIndex)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].supportedToolTypes
    end
    return nil
end

```

### getFillUnitSupportsFillType

**Description**

**Definition**

> getFillUnitSupportsFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillType      |

**Code**

```lua
function FillUnit:getFillUnitSupportsFillType(fillUnitIndex, fillType)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].supportedFillTypes[fillType]
    end
    return false
end

```

### getFillUnitSupportsToolType

**Description**

**Definition**

> getFillUnitSupportsToolType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | toolType      |

**Code**

```lua
function FillUnit:getFillUnitSupportsToolType(fillUnitIndex, toolType)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        return spec.fillUnits[fillUnitIndex].supportedToolTypes[toolType]
    end
    return false
end

```

### getFillUnitSupportsToolTypeAndFillType

**Description**

**Definition**

> getFillUnitSupportsToolTypeAndFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | toolType      |
| any | fillType      |

**Code**

```lua
function FillUnit:getFillUnitSupportsToolTypeAndFillType(fillUnitIndex, toolType, fillType)
    return self:getFillUnitSupportsToolType(fillUnitIndex, toolType)
    and self:getFillUnitSupportsFillType(fillUnitIndex, fillType)
end

```

### getFillUnitUnloadingTasks

**Description**

**Definition**

> getFillUnitUnloadingTasks()

**Code**

```lua
function FillUnit:getFillUnitUnloadingTasks()
    local unloadingTasks = { }
    for fillUnitIndex, fillUnit in ipairs( self:getFillUnits()) do
        local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)
        if fillUnit.canBeUnloaded and self:getFillUnitFillLevel(fillUnitIndex) > 0 then
            local palletFilename = self:getFillUnitUnloadPalletFilename(fillUnitIndex)
            if palletFilename ~ = nil then
                local fillTypeIndex = self:getFillUnitFillType(fillUnitIndex)
                table.insert(unloadingTasks, { fillUnitIndex = fillUnitIndex, fillTypeIndex = fillTypeIndex, fillLevel = fillLevel, filename = palletFilename } )
            end
        end
    end

    return unloadingTasks
end

```

### getFillUnitUnloadPalletFilename

**Description**

**Definition**

> getFillUnitUnloadPalletFilename()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getFillUnitUnloadPalletFilename(fillUnitIndex)
    local fillTypeIndex = self:getFillUnitFillType(fillUnitIndex)
    if fillTypeIndex ~ = FillType.UNKNOWN then
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        return fillType.palletFilename
    end

    return nil
end

```

### getFirstValidFillUnitToFill

**Description**

**Definition**

> getFirstValidFillUnitToFill()

**Arguments**

| any | fillType       |
|-----|----------------|
| any | ignoreCapacity |

**Code**

```lua
function FillUnit:getFirstValidFillUnitToFill(fillType, ignoreCapacity)
    local spec = self.spec_fillUnit
    for fillUnitIndex, _ in ipairs(spec.fillUnits) do
        if self:getFillUnitAllowsFillType(fillUnitIndex, fillType) then
            if self:getFillUnitFreeCapacity(fillUnitIndex) > 0 or(ignoreCapacity ~ = nil and ignoreCapacity) then
                return fillUnitIndex
            end
        end
    end

    return nil
end

```

### getIsAttacherJointCompatible

**Description**

**Definition**

> getIsAttacherJointCompatible()

**Arguments**

| any | superFunc            |
|-----|----------------------|
| any | vehicle              |
| any | attacherJoint        |
| any | inputAttacherVehicle |
| any | inputAttacherJoint   |

**Code**

```lua
function FillUnit:getIsAttacherJointCompatible(superFunc, vehicle, attacherJoint, inputAttacherVehicle, inputAttacherJoint)
    if attacherJoint.limitFillUnitIndex ~ = nil then
        local fillLevelPct = self:getFillUnitFillLevelPercentage(attacherJoint.limitFillUnitIndex)
        if fillLevelPct ~ = nil and(fillLevelPct < attacherJoint.minFillLevel or fillLevelPct > attacherJoint.maxFillLevel) then
            if not attacherJoint.fillUnitTopArmOnly or inputAttacherJoint.topReferenceNode ~ = nil then
                return false , g_i18n:getText( "warning_fillUnitAttachNotAllowed" )
            end
        end
    end

    return superFunc( self , vehicle, attacherJoint, inputAttacherVehicle, inputAttacherJoint)
end

```

### getIsFillAllowedFromFarm

**Description**

**Definition**

> getIsFillAllowedFromFarm()

**Arguments**

| any | farmId |
|-----|--------|

**Code**

```lua
function FillUnit:getIsFillAllowedFromFarm(farmId)
    return true
end

```

### getIsFillUnitActive

**Description**

**Definition**

> getIsFillUnitActive()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|

**Code**

```lua
function FillUnit:getIsFillUnitActive(fillUnitIndex)
    return true
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
function FillUnit:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_fillUnit
    if not spec.allowFoldingWhileFilled then
        for fillUnitIndex, fillUnit in ipairs(spec.fillUnits) do
            if self:getFillUnitFillLevel(fillUnitIndex) > (fillUnit.allowFoldingThreshold or spec.allowFoldingThreshold) and(fillUnit.allowFoldingFillType = = nil or fillUnit.allowFoldingFillType = = fillUnit.fillType) then
                return false , spec.texts.warningFoldingFilled
            end
        end
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsLevelerPickupNodeActive

**Description**

**Definition**

> getIsLevelerPickupNodeActive()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | levelerNode |

**Code**

```lua
function FillUnit:getIsLevelerPickupNodeActive(superFunc, levelerNode)
    local fillLevelPct = self:getFillUnitFillLevelPercentage(levelerNode.limitFillUnitIndex)
    if fillLevelPct ~ = nil and(fillLevelPct < levelerNode.minFillLevel or fillLevelPct > levelerNode.maxFillLevel) then
        return false
    end

    return superFunc( self , levelerNode)
end

```

### getIsMovingToolActive

**Description**

**Definition**

> getIsMovingToolActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | movingTool |

**Code**

```lua
function FillUnit:getIsMovingToolActive(superFunc, movingTool)
    if movingTool.fillUnitIndex ~ = nil then
        local fillLevelPct = self:getFillUnitFillLevelPercentage(movingTool.fillUnitIndex)
        if fillLevelPct > movingTool.minFillLevel or fillLevelPct < movingTool.maxFillLevel then
            return false
        end
    end

    return superFunc( self , movingTool)
end

```

### getIsPowerTakeOffActive

**Description**

**Definition**

> getIsPowerTakeOffActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FillUnit:getIsPowerTakeOffActive(superFunc)
    local fillTrigger = self.spec_fillUnit.fillTrigger
    return superFunc( self ) or(fillTrigger.isFilling and fillTrigger.consumePtoPower)
end

```

### getIsReadyForAutomatedTrainTravel

**Description**

**Definition**

> getIsReadyForAutomatedTrainTravel()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function FillUnit:getIsReadyForAutomatedTrainTravel(superFunc)
    local spec = self.spec_fillUnit
    for _, fillUnit in ipairs(spec.fillUnits) do
        if fillUnit.blocksAutomatedTrainTravel and fillUnit.fillLevel > 0 then
            return false
        end
    end

    return superFunc( self )
end

```

### getSpecValueCapacity

**Description**

**Definition**

> getSpecValueCapacity()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function FillUnit.getSpecValueCapacity(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    local configurationIndex = 1
    if realItem ~ = nil and storeItem.configurations ~ = nil and realItem.configurations[ "fillUnit" ] ~ = nil and storeItem.configurations[ "fillUnit" ] ~ = nil then
        configurationIndex = realItem.configurations[ "fillUnit" ]
    elseif configurations ~ = nil and storeItem.configurations ~ = nil and configurations[ "fillUnit" ] ~ = nil and storeItem.configurations[ "fillUnit" ] ~ = nil then
            configurationIndex = configurations[ "fillUnit" ]
        end

        local minCapacity = 0
        local capacity = 0
        local unit = ""

        local fillUnitConfigurations = storeItem.specs.capacity
        if fillUnitConfigurations ~ = nil then
            if realItem ~ = nil or(configurations ~ = nil and saleItem ~ = nil ) then
                if fillUnitConfigurations[configurationIndex] ~ = nil then
                    for _, fillUnit in ipairs(fillUnitConfigurations[configurationIndex].fillUnits) do
                        if realItem ~ = nil and realItem.getFillUnitCapacity ~ = nil and fillUnit.fillUnitIndex ~ = nil then
                            local unitCapacity = realItem:getFillUnitCapacity(fillUnit.fillUnitIndex)
                            if unitCapacity ~ = 0 and unitCapacity ~ = math.huge then
                                if fillUnit.conversionFunc ~ = nil then
                                    unitCapacity = fillUnit.conversionFunc(unitCapacity)
                                end
                                capacity = capacity + unitCapacity
                            end
                        else
                                capacity = capacity + fillUnit.capacity
                            end

                            unit = fillUnit.unit
                        end
                        minCapacity = capacity
                    end
                else
                        -- if no configuration index is given we use the max capacity the vehicle can have
                            minCapacity = math.huge
                            capacity = 0
                            for _, configuration in ipairs(fillUnitConfigurations) do
                                if configuration.isSelectable then
                                    local configCapacity = 0
                                    for _, fillUnit in ipairs(configuration.fillUnits) do
                                        configCapacity = configCapacity + fillUnit.capacity
                                        unit = fillUnit.unit
                                    end

                                    if configCapacity ~ = 0 then
                                        minCapacity = math.min(minCapacity, configCapacity)
                                        capacity = math.max(capacity, configCapacity)
                                    end
                                end
                            end

                            if minCapacity = = capacity then
                                capacity = minCapacity
                            else
                                    if minCapacity ~ = math.huge and capacity ~ = 0 then
                                        if returnValues = = nil or not returnValues then
                                            -- while allowed to return a string we return capacity range
                                                capacity = string.format( "%s-%s" , minCapacity, capacity)
                                            end
                                        end
                                    end
                                end
                            end

                            if type(capacity) = = "number" and capacity = = 0 then
                                if returnValues = = nil or not returnValues then
                                    return nil
                                end
                            end

                            if unit ~ = "" then
                                if unit:sub( 1 , 6 ) = = "$l10n_" then
                                    unit = unit:sub( 7 )
                                end
                            end

                            if returnValues = = nil or not returnValues then
                                return string.format(g_i18n:getText( "shop_capacityValue" ), capacity, g_i18n:getText(unit or "unit_literShort" ))
                            else
                                    if returnRange = = true and capacity ~ = minCapacity then
                                        return minCapacity, capacity, unit
                                    else
                                            return minCapacity, unit
                                        end
                                    end
                                end

```

### getSpecValueFillTypes

**Description**

**Definition**

> getSpecValueFillTypes()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |

**Code**

```lua
function FillUnit.getSpecValueFillTypes(storeItem, realItem, configurations)
    local specs = storeItem.specs.fillTypes
    if specs ~ = nil then
        local configuration
        if configurations ~ = nil then
            local configId = configurations[ "fillUnit" ]
            configuration = specs.fillTypesByConfiguration[configId]
        end

        local categoryNames = specs.categoryNames
        if configuration ~ = nil then
            categoryNames = configuration.categoryNames or categoryNames
        end

        local fillTypeNames = specs.fillTypeNames
        if configuration ~ = nil then
            fillTypeNames = configuration.fillTypeNames or fillTypeNames
        end

        if categoryNames ~ = nil or fillTypeNames ~ = nil then
            local fillTypes = { }
            if categoryNames ~ = nil then
                g_fillTypeManager:getFillTypesByCategoryNames(categoryNames, nil , fillTypes)
            end
            if fillTypeNames ~ = nil then
                g_fillTypeManager:getFillTypesByNames(fillTypeNames, nil , fillTypes)
            end

            return fillTypes
        elseif specs.fruitTypeNames ~ = nil then
                return g_fruitTypeManager:getFillTypeIndicesByFruitTypeNames(specs.fruitTypeNames, nil )
            elseif specs.fruitTypeCategoryNames ~ = nil then
                    return g_fruitTypeManager:getFillTypeIndicesByFruitTypeCategoryName(specs.fruitTypeCategoryNames, nil )
                elseif specs.windrowFillTypes ~ = nil then
                        return specs.windrowFillTypes
                    end
                end
                return nil
            end

```

### getSpecValueStartFillUnitMassByMassData

**Description**

**Definition**

> getSpecValueStartFillUnitMassByMassData()

**Arguments**

| any | fillUnitMassData |
|-----|------------------|

**Code**

```lua
function FillUnit.getSpecValueStartFillUnitMassByMassData(fillUnitMassData)
    local mass = 0
    for _, massData in pairs(fillUnitMassData) do
        local fillType
        if massData.fillTypeCategories ~ = nil then
            local fillTypes = g_fillTypeManager:getFillTypesByCategoryNames(massData.fillTypeCategories)
            fillType = fillTypes[ 1 ]
        elseif massData.fillTypes ~ = nil then
                local fillTypes = g_fillTypeManager:getFillTypesByNames(massData.fillTypes)
                fillType = fillTypes[ 1 ]
            elseif massData.fillType ~ = nil then
                    fillType = g_fillTypeManager:getFillTypeIndexByName(massData.fillType)
                end

                if fillType ~ = nil then
                    local fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(fillType)
                    mass = mass + massData.capacity * fillTypeDesc.massPerLiter
                end
            end

            return mass
        end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function FillUnit.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "fillUnit" , g_i18n:getText( "configuration_fillUnit" ), "fillUnit" , VehicleConfigurationItem )

    g_storeManager:addSpecType( "capacity" , "shopListAttributeIconCapacity" , FillUnit.loadSpecValueCapacity, FillUnit.getSpecValueCapacity, StoreSpecies.VEHICLE, { "fillUnit" } )
    g_storeManager:addSpecType( "fillTypes" , "shopListAttributeIconFillTypes" , FillUnit.loadSpecValueFillTypes, FillUnit.getSpecValueFillTypes, StoreSpecies.VEHICLE, { "fillUnit" } )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "FillUnit" )

    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.fillTypes" , "Fill types" )
    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.fillTypeCategories" , "Fill type categories" )
    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.fruitTypes" , "Fruit types" )
    schema:register(XMLValueType.STRING, "vehicle.storeData.specs.fruitTypeCategories" , "Fruit type categories" )
    schema:register(XMLValueType.FLOAT, "vehicle.storeData.specs.capacity" , "Capacity" )
    FillUnit.registerUnitDisplaySchema(schema, "vehicle.storeData.specs.capacity" )

    schema:register(XMLValueType.BOOL, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#removeVehicleIfEmpty" , "Remove vehicle if unit empty" , false )
        schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#removeVehicleThreshold" , "Remove vehicle if empty threshold in liters" , 0 )
            schema:register(XMLValueType.TIME, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#removeVehicleDelay" , "Delay for vehicle removal(e.g.can be used while sounds are still playing)" , 0 )
                schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#removeVehicleReward" , "Amount of money as reward of removing the pallet" , 0 )
                schema:register(XMLValueType.BOOL, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#allowFoldingWhileFilled" , "Allow folding while filled" , true )
                    schema:register(XMLValueType.BOOL, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#resetFoldingWhileFilled" , "Reset folding while filled" , false )
                        schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#allowFoldingThreshold" , "Allow folding threshold" , 0.0001 )
                        schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits#fillTypeChangeThreshold" , "Fill type overwrite threshold" , 0.05 )

                        schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.fillTrigger#litersPerSecond" , "Fill liters per second" , 200 )
                        schema:register(XMLValueType.BOOL, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.fillTrigger#consumePtoPower" , "Consume pto power while filling" , false )

                            local fillUnitPath = FillUnit.FILL_UNIT_XML_KEY

                            schema:register(XMLValueType.FLOAT, fillUnitPath .. "#capacity" , "Capacity" , "unlimited" )
                            schema:register(XMLValueType.BOOL, fillUnitPath .. "#updateMass" , "Update vehicle mass while fill level changes" , true )
                                schema:register(XMLValueType.BOOL, fillUnitPath .. "#canBeUnloaded" , "Can be unloaded" , true )
                                schema:register(XMLValueType.FLOAT, fillUnitPath .. "#allowFoldingThreshold" , "Allow folding threshold" , "Value of fillUnits#allowFoldingThreshold" )
                                schema:register(XMLValueType.STRING, fillUnitPath .. "#allowFoldingFillType" , "Defines the fill type for which the folding threshold applies - all others are always allowed" )

                                    FillUnit.registerUnitDisplaySchema(schema, fillUnitPath)
                                    schema:register(XMLValueType.BOOL, fillUnitPath .. "#showCapacityInShop" , "Show capacity in shop" , true )
                                    schema:register(XMLValueType.BOOL, fillUnitPath .. "#showInShop" , "Show in shop" , true )

                                    schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".exactFillRootNode#node" , "Exact fill root node" )
                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. ".exactFillRootNode#extraEffectDistance" , "Exact fill root node extra distance" , 0 )

                                    schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".autoAimTargetNode#node" , "Auto aim target node" )
                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. ".autoAimTargetNode#startZ" , "Start Z translation" )
                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. ".autoAimTargetNode#endZ" , "End Z translation" )
                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. ".autoAimTargetNode#startPercentage" , "Start move percentage" )
                                    schema:register(XMLValueType.BOOL, fillUnitPath .. ".autoAimTargetNode#invert" , "Invert Z movement" )

                                    schema:register(XMLValueType.STRING, fillUnitPath .. "#fillTypeCategories" , "Supported fill type categories" )
                                    schema:register(XMLValueType.STRING, fillUnitPath .. "#fillTypes" , "Supported fill types" )

                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. "#startFillLevel" , "Start fill level" )
                                    schema:register(XMLValueType.STRING, fillUnitPath .. "#startFillType" , "Start fill type" )

                                    schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".fillRootNode#node" , "Fill root node" , "first component" )
                                    schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".fillMassNode#node" , "Fill root node" , "first component" )
                                    schema:register(XMLValueType.BOOL, fillUnitPath .. "#updateFillLevelMass" , "Update fill level mass" , true )
                                    schema:register(XMLValueType.BOOL, fillUnitPath .. "#ignoreFillLimit" , "Ignores limiting of filling if the max mass is reached(if the settings is turned on)" , false )

                                        schema:register(XMLValueType.BOOL, fillUnitPath .. "#synchronizeFillLevel" , "Synchronize fill level" , true )
                                        schema:register(XMLValueType.BOOL, fillUnitPath .. "#synchronizeFullFillLevel" , "Synchronize fill level as 32bit float instead of percentage with max.16 bits" , false )
                                        schema:register(XMLValueType.INT, fillUnitPath .. "#synchronizationNumBits" , "Synchronization bits" )

                                        schema:register(XMLValueType.BOOL, fillUnitPath .. "#showOnHud" , "Show on HUD" , true )
                                        schema:register(XMLValueType.BOOL, fillUnitPath .. "#showOnInfoHud" , "Show on Info HUD" , true )
                                        schema:register(XMLValueType.INT, fillUnitPath .. "#uiPrecision" , "Precision in UI display" , 0 )
                                        schema:register(XMLValueType.L10N_STRING, fillUnitPath .. "#uiCustomFillTypeName" , "Custom fill type name for UI display" )
                                            schema:register(XMLValueType.L10N_STRING, fillUnitPath .. "#uiExtraInfoText" , "Extra text to display behind the fill type name" )
                                            schema:register(XMLValueType.STRING, fillUnitPath .. "#uiDisplayType" , "The style that is used for the display of the fill level in the HUD('BAR' or 'STEP')" , "BAR" )
                                                schema:register(XMLValueType.BOOL, fillUnitPath .. "#blocksAutomatedTrainTravel" , "Block automated train travel if not empty" , false )

                                                    schema:register(XMLValueType.STRING, fillUnitPath .. "#fillAnimation" , "Fill animation name" )
                                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. "#fillAnimationLoadTime" , "Fill animation load time" )
                                                    schema:register(XMLValueType.FLOAT, fillUnitPath .. "#fillAnimationEmptyTime" , "Fill animation empty time" )

                                                    schema:register(XMLValueType.STRING, fillUnitPath .. ".fillLevelAnimation(?)#name" , "Fill level animation name(Animation time is set depending on fill level percentage)" )
                                                    schema:register(XMLValueType.BOOL, fillUnitPath .. ".fillLevelAnimation(?)#resetOnEmpty" , "Update animation when fill level reaches zero" , true )
                                                    schema:register(XMLValueType.BOOL, fillUnitPath .. ".fillLevelAnimation(?)#updateWhileFilled" , "Animation will be updated while filled(If not 'true', the animation will be set the the max.state)" , true )
                                                        schema:register(XMLValueType.BOOL, fillUnitPath .. ".fillLevelAnimation(?)#useMaxStateIfEmpty" , "If the fill unit is empty, the animation will use the max.state" , true )

                                                        schema:register(XMLValueType.FLOAT, fillUnitPath .. ".alarmTriggers.alarmTrigger(?)#minFillLevel" , "Fill animation empty time" )
                                                        schema:register(XMLValueType.FLOAT, fillUnitPath .. ".alarmTriggers.alarmTrigger(?)#maxFillLevel" , "Fill animation empty time" )
                                                        schema:register(XMLValueType.BOOL, fillUnitPath .. ".alarmTriggers.alarmTrigger(?)#needsTurnOn" , "Needs turn on" , false )
                                                        schema:register(XMLValueType.BOOL, fillUnitPath .. ".alarmTriggers.alarmTrigger(?)#turnOffInTrigger" , "Turn off in trigger" , false )
                                                        SoundManager.registerSampleXMLPaths(schema, fillUnitPath .. ".alarmTriggers.alarmTrigger(?)" , "alarmSound" )

                                                        BeaconLight.registerVehicleXMLPaths(schema, fillUnitPath .. ".alarmTriggers.alarmTrigger(?).beaconLight(?)" )
                                                        schema:register(XMLValueType.TIME, fillUnitPath .. ".alarmTriggers.alarmTrigger(?).beaconLight(?)#activeDuration" , "Duration the beacon light is active(0:as long as the alarm trigger is active)" , 0 )

                                                        schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".measurementNodes.measurementNode(?)#node" , "Measurement node" )

                                                        schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".fillPlane.node(?)#node" , "Fill plane node" )
                                                        schema:register(XMLValueType.FLOAT, fillUnitPath .. ".fillPlane.node(?).key(?)#time" , "Key time" )
                                                        schema:register(XMLValueType.VECTOR_TRANS, fillUnitPath .. ".fillPlane.node(?).key(?)#translation" , "Translation" )
                                                        schema:register(XMLValueType.FLOAT, fillUnitPath .. ".fillPlane.node(?).key(?)#y" , "Y Translation" )
                                                        schema:register(XMLValueType.VECTOR_ROT, fillUnitPath .. ".fillPlane.node(?).key(?)#rotation" , "Rotation" )
                                                        schema:register(XMLValueType.VECTOR_SCALE, fillUnitPath .. ".fillPlane.node(?).key(?)#scale" , "Scale" )
                                                        schema:register(XMLValueType.VECTOR_ 2 , fillUnitPath .. ".fillPlane.node(?)#minMaxY" , "Min.and max.Y translation" )
                                                        schema:register(XMLValueType.BOOL, fillUnitPath .. ".fillPlane.node(?)#alwaysVisible" , "Is always visible" , false )
                                                        schema:register(XMLValueType.STRING, fillUnitPath .. ".fillPlane#defaultFillType" , "Default fill type name" )

                                                        schema:register(XMLValueType.STRING, fillUnitPath .. ".fillTypeMaterials.material(?)#fillType" , "Fill type name" )
                                                        schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".fillTypeMaterials.material(?)#node" , "Node which receives material" )
                                                        schema:register(XMLValueType.NODE_INDEX, fillUnitPath .. ".fillTypeMaterials.material(?)#refNode" , "Node which provides material" )
                                                        schema:register(XMLValueType.STRING, fillUnitPath .. ".fillTypeMaterials.material(?)#materialSlotName" , "Material slot name to apply the defined texture as diffuse map" )
                                                        schema:register(XMLValueType.FILENAME, fillUnitPath .. ".fillTypeMaterials.material(?)#diffuse" , "Path to a custom diffuse texture to apply" )

                                                        EffectManager.registerEffectXMLPaths(schema, fillUnitPath .. ".fillEffect" )
                                                        AnimationManager.registerAnimationNodesXMLPaths(schema, fillUnitPath .. ".animationNodes" )

                                                        Dashboard.registerDashboardXMLPaths(schema, fillUnitPath, { "fillLevel" , "fillLevelPct" , "fillLevelWarning" } )

                                                        Dashboard.addDelayedRegistrationFunc(schema, function (cSchema, cKey)
                                                            cSchema:register(XMLValueType.STRING, cKey .. "#fillType" , "Fill type of fillUnit to be used" )
                                                            cSchema:register(XMLValueType.INT, cKey .. "#fillUnitIndex" , "Fill unit index to represent" )
                                                        end )

                                                        schema:register(XMLValueType.NODE_INDEX, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.unloading(?)#node" , "Unloading node" )
                                                        schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.unloading(?)#width" , "Unloading width" , 15 )
                                                        schema:register(XMLValueType.VECTOR_TRANS, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.unloading(?)#offset" , "Unloading offset" , "0 0 0" )

                                                        EffectManager.registerEffectXMLPaths(schema, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.fillEffect" )
                                                        AnimationManager.registerAnimationNodesXMLPaths(schema, FillUnit.FILL_UNIT_CONFIG_XML_KEY .. ".fillUnits.animationNodes" )
                                                        SoundManager.registerSampleXMLPaths(schema, "vehicle.fillUnit.sounds" , "fill" )

                                                        schema:register(XMLValueType.INT, Leveler.LEVELER_NODE_XML_KEY .. "#fillUnitIndex" , "Reference fill unit index" , 1 )
                                                        schema:register(XMLValueType.FLOAT, Leveler.LEVELER_NODE_XML_KEY .. "#minFillLevel" , "Min.fill level to activate leveler node(pct between 0 and 1)" , 0 )
                                                        schema:register(XMLValueType.FLOAT, Leveler.LEVELER_NODE_XML_KEY .. "#maxFillLevel" , "Max.fill level to activate leveler node(pct between 0 and 1)" , 1 )

                                                        schema:addDelayedRegistrationFunc( "AttacherJoint" , function (cSchema, cKey)
                                                            cSchema:register(XMLValueType.INT, cKey .. "#fillUnitIndex" , "Reference fill unit index" , 1 )
                                                            cSchema:register(XMLValueType.BOOL, cKey .. "#fillUnitTopArmOnly" , "Block attaching of implements with top arm only" , false )
                                                            cSchema:register(XMLValueType.FLOAT, cKey .. "#minFillLevel" , "Min.fill level to activate attacher joint(pct between 0 and 1)" , 0 )
                                                            cSchema:register(XMLValueType.FLOAT, cKey .. "#maxFillLevel" , "Max.fill level to activate attacher joint(pct between 0 and 1)" , 1 )
                                                        end )

                                                        schema:setXMLSpecializationType()

                                                        local schemaSavegame = Vehicle.xmlSchemaSavegame
                                                        schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).fillUnit.unit(?)#index" , "Fill Unit index" )
                                                        schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).fillUnit.unit(?)#fillType" , "Fill type" )
                                                        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).fillUnit.unit(?)#fillLevel" , "Fill level" )
                                                    end

```

### loadAlarmTrigger

**Description**

**Definition**

> loadAlarmTrigger()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | alarmTrigger |
| any | fillUnit     |

**Code**

```lua
function FillUnit:loadAlarmTrigger(xmlFile, key, alarmTrigger, fillUnit)
    alarmTrigger.fillUnit = fillUnit
    alarmTrigger.isActive = false

    local success = true
    alarmTrigger.minFillLevel = xmlFile:getValue(key .. "#minFillLevel" )
    if alarmTrigger.minFillLevel = = nil then
        Logging.xmlWarning( self.xmlFile, "Missing 'minFillLevel' for alarmTrigger '%s'" , key)
            success = false
        end

        alarmTrigger.maxFillLevel = xmlFile:getValue(key .. "#maxFillLevel" )
        if alarmTrigger.maxFillLevel = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing 'maxFillLevel' for alarmTrigger '%s'" , key)
                success = false
            end

            alarmTrigger.sample = g_soundManager:loadSampleFromXML(xmlFile, key, "alarmSound" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

            alarmTrigger.beaconLights = { }
            xmlFile:iterate(key .. ".beaconLight" , function (_, beaconKey)
                local beaconLight = BeaconLight.loadFromVehicleXML(alarmTrigger.beaconLights, xmlFile, beaconKey, self )
                if beaconLight ~ = nil then
                    beaconLight.activeDuration = xmlFile:getValue(beaconKey .. "#activeDuration" , 0 )
                end
            end )

            return success
        end

```

### loadAttacherJointFromXML

**Description**

> Load attacher joint from xml

**Definition**

> loadAttacherJointFromXML(table attacherJoint, integer fileId, string baseName, integer index, )

**Arguments**

| table   | attacherJoint | attacherJoint           |
|---------|---------------|-------------------------|
| integer | fileId        | xml file id             |
| string  | baseName      | baseName                |
| integer | index         | index of attacher joint |
| any     | index         |                         |

**Code**

```lua
function FillUnit:loadAttacherJointFromXML(superFunc, attacherJoint, xmlFile, baseName, index)
    attacherJoint.limitFillUnitIndex = xmlFile:getValue(baseName .. "#fillUnitIndex" )
    if attacherJoint.limitFillUnitIndex ~ = nil then
        attacherJoint.fillUnitTopArmOnly = xmlFile:getValue(baseName .. "#fillUnitTopArmOnly" , false )
        attacherJoint.minFillLevel = xmlFile:getValue(baseName .. "#minFillLevel" , 0 )
        attacherJoint.maxFillLevel = xmlFile:getValue(baseName .. "#maxFillLevel" , 1 )
    end

    return superFunc( self , attacherJoint, xmlFile, baseName, index)
end

```

### loadFillPlane

**Description**

**Definition**

> loadFillPlane()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | key       |
| any | fillPlane |
| any | fillUnit  |

**Code**

```lua
function FillUnit:loadFillPlane(xmlFile, key, fillPlane, fillUnit)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#fillType" , "Material is dynamically assigned to the nodes" )

    if not xmlFile:hasProperty(key) then
        return false
    end

    fillPlane.nodes = { }
    local i = 0
    while true do
        local nodeKey = string.format( "%s.node(%d)" , key, i)
        if not xmlFile:hasProperty(nodeKey) then
            break
        end

        XMLUtil.checkDeprecatedXMLElements(xmlFile, nodeKey .. "#index" , nodeKey .. "#node" ) -- FS17 to FS19

        local node = xmlFile:getValue(nodeKey .. "#node" , nil , self.components, self.i3dMappings)
        if node ~ = nil then
            local defaultX, defaultY, defaultZ = getTranslation(node)
            local defaultRX, defaultRY, defaultRZ = getRotation(node)

            local animCurve = AnimCurve.new(linearInterpolatorTransRotScale)
            local j = 0
            while true do
                local animKey = string.format( "%s.key(%d)" , nodeKey, j)
                if not xmlFile:hasProperty(animKey) then
                    break
                end

                local keyTime = xmlFile:getValue(animKey .. "#time" )
                if keyTime = = nil then
                    break
                end

                local x, y, z = xmlFile:getValue(animKey .. "#translation" )
                if y = = nil then
                    y = xmlFile:getValue(animKey .. "#y" )
                end
                x = x or defaultX
                y = y or defaultY
                z = z or defaultZ

                local rx, ry, rz = xmlFile:getValue(animKey .. "#rotation" )
                rx = rx or defaultRX
                ry = ry or defaultRY
                rz = rz or defaultRZ

                local sx, sy, sz = xmlFile:getValue(animKey .. "#scale" )
                sx = sx or 1
                sy = sy or 1
                sz = sz or 1

                animCurve:addKeyframe( { x = x, y = y, z = z, rx = rx, ry = ry, rz = rz, sx = sx, sy = sy, sz = sz, time = keyTime } )
                j = j + 1
            end

            if j = = 0 then
                local minY, maxY = xmlFile:getValue(nodeKey .. "#minMaxY" )
                minY = minY or defaultY
                maxY = maxY or defaultY
                animCurve:addKeyframe( { defaultX, minY, defaultZ, defaultRX, defaultRY, defaultRZ, 1 , 1 , 1 , time = 0 } )
                animCurve:addKeyframe( { defaultX, maxY, defaultZ, defaultRX, defaultRY, defaultRZ, 1 , 1 , 1 , time = 1 } )
            end

            local alwaysVisible = xmlFile:getValue(nodeKey .. "#alwaysVisible" , false )
            setVisibility(node, alwaysVisible)

            table.insert(fillPlane.nodes, { node = node, animCurve = animCurve, alwaysVisible = alwaysVisible } )

            local fillPlaneMaterial = g_materialManager:getBaseMaterialByName( "fillPlane" )
            if fillPlaneMaterial ~ = nil then
                setMaterial(node, fillPlaneMaterial, 0 )
                g_fillTypeManager:assignFillTypeTextureArraysFromTerrain(node, g_terrainNode, true , true , true )

                setShaderParameter(node, "isCustomShape" , 1 , 0 , 0 , 0 , false )
            else
                    Logging.error( "Failed to assign material to fill plane.Base Material 'fillPlane' not found!" )
                end
            end
            i = i + 1
        end

        fillPlane.forcedFillType = nil

        local defaultFillTypeStr = xmlFile:getValue(key .. "#defaultFillType" )
        if defaultFillTypeStr ~ = nil then
            local defaultFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(defaultFillTypeStr)
            if defaultFillTypeIndex = = nil then
                Logging.xmlWarning( self.xmlFile, "Invalid defaultFillType '%s' for '%s'!" , tostring(defaultFillTypeStr), key)
                    return false
                else
                        fillPlane.defaultFillType = defaultFillTypeIndex
                    end
                else
                        fillPlane.defaultFillType = next(fillUnit.supportedFillTypes)
                    end

                    return true
                end

```

### loadFillTypeMaterials

**Description**

**Definition**

> loadFillTypeMaterials()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function FillUnit:loadFillTypeMaterials(xmlFile, key)
    local fillTypeMaterials = { }
    xmlFile:iterate(key .. ".fillTypeMaterials.material" , function (_, materialKey)
        local fillTypeName = xmlFile:getValue(materialKey .. "#fillType" )
        if fillTypeName ~ = nil then
            local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
            if fillTypeIndex ~ = nil then
                local node = xmlFile:getValue(materialKey .. "#node" , nil , self.components, self.i3dMappings)
                local refNode = xmlFile:getValue(materialKey .. "#refNode" , nil , self.components, self.i3dMappings)
                local materialSlotName = xmlFile:getValue(materialKey .. "#materialSlotName" )
                if node ~ = nil and refNode ~ = nil then
                    local fillTypeMaterial = { }
                    fillTypeMaterial.fillTypeIndex = fillTypeIndex
                    fillTypeMaterial.node = node
                    fillTypeMaterial.refNode = refNode
                    table.insert(fillTypeMaterials, fillTypeMaterial)
                elseif materialSlotName ~ = nil then
                        local materialId = MaterialUtil.getMaterialBySlotName( self.rootNode, materialSlotName)
                        if materialId = = nil then
                            Logging.xmlWarning(xmlFile, "Material for slot name '%s' not found in '%s'" , materialSlotName, materialKey)
                                return
                            end

                            local diffuse = xmlFile:getValue(materialKey .. "#diffuse" , nil , self.baseDirectory)
                            if diffuse ~ = nil then
                                if textureFileExists(diffuse) then
                                    local fillTypeMaterial = { }
                                    fillTypeMaterial.fillTypeIndex = fillTypeIndex
                                    fillTypeMaterial.materialId = materialId
                                    fillTypeMaterial.diffuse = diffuse
                                    table.insert(fillTypeMaterials, fillTypeMaterial)
                                else
                                        Logging.xmlWarning(xmlFile, "Diffuse texture '%s' not found in '%s'" , diffuse, materialKey)
                                    end
                                else
                                        Logging.xmlWarning(xmlFile, "Missing diffuse texture for fill type '%s' in '%s'" , fillTypeName, materialKey)
                                        end
                                    else
                                            Logging.xmlWarning(xmlFile, "Missing node or ref node or materialSlotName in '%s'" , materialKey)
                                        end
                                    else
                                            Logging.xmlWarning(xmlFile, "Unknown fill type '%s' in '%s'" , fillTypeName, materialKey)
                                        end
                                    else
                                            Logging.xmlWarning(xmlFile, "Missing fill type in '%s'" , materialKey)
                                        end
                                    end )

                                    return fillTypeMaterials
                                end

```

### loadFillUnitFromXML

**Description**

**Definition**

> loadFillUnitFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |
| any | index   |

**Code**

```lua
function FillUnit:loadFillUnitFromXML(xmlFile, key, entry, index)
    local spec = self.spec_fillUnit

    entry.fillUnitIndex = index
    entry.capacity = xmlFile:getValue(key .. "#capacity" , math.huge)
    entry.defaultCapacity = entry.capacity
    entry.updateMass = xmlFile:getValue(key .. "#updateMass" , true )
    entry.canBeUnloaded = xmlFile:getValue(key .. "#canBeUnloaded" , true )
    entry.allowFoldingThreshold = xmlFile:getValue(key .. "#allowFoldingThreshold" )
    local allowFoldingFillTypeName = xmlFile:getValue(key .. "#allowFoldingFillType" )
    if allowFoldingFillTypeName ~ = nil then
        local allowFoldingFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(allowFoldingFillTypeName)
        if allowFoldingFillTypeIndex ~ = nil then
            entry.allowFoldingFillType = allowFoldingFillTypeIndex
        else
                Logging.xmlWarning( self.xmlFile, "Invalid fill type for fill unit in '%s'" , allowFoldingFillTypeName, key .. "#allowFoldingFillType" )
                end
            end
            entry.needsSaving = true

            entry.fillLevel = 0
            entry.fillLevelSent = 0

            entry.fillType = FillType.UNKNOWN
            entry.fillTypeSent = FillType.UNKNOWN
            entry.fillTypeToDisplay = FillType.UNKNOWN
            entry.fillLevelToDisplay = nil
            entry.capacityToDisplay = nil

            entry.lastValidFillType = FillType.UNKNOWN
            entry.lastValidFillTypeSent = FillType.UNKNOWN

            if xmlFile:hasProperty(key .. ".exactFillRootNode" ) then
                XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".exactFillRootNode#index" , key .. ".exactFillRootNode#node" ) --FS17 to FS19

                entry.exactFillRootNode = xmlFile:getValue(key .. ".exactFillRootNode#node" , nil , self.components, self.i3dMappings)
                if entry.exactFillRootNode ~ = nil then
                    if not CollisionFlag.getHasGroupFlagSet(entry.exactFillRootNode, CollisionFlag.FILLABLE) then
                        Logging.xmlWarning( self.xmlFile, "Missing collision group %s.Please add this bit to exact fill root node '%s' collision filter group in '%s'" , CollisionFlag.getBitAndName(CollisionFlag.FILLABLE), getName(entry.exactFillRootNode), key)
                    else
                            spec.exactFillRootNodeToFillUnit[entry.exactFillRootNode] = entry
                            spec.exactFillRootNodeToExtraDistance[entry.exactFillRootNode] = xmlFile:getValue(key .. ".exactFillRootNode#extraEffectDistance" , 0 )
                            spec.hasExactFillRootNodes = true

                            g_currentMission:addNodeObject(entry.exactFillRootNode, self )
                        end
                    else
                            Logging.xmlWarning( self.xmlFile, "ExactFillRootNode not found for fillUnit '%s'!" , key)
                            end
                        end

                        XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".autoAimTargetNode#index" , key .. ".autoAimTargetNode#node" ) --FS17 to FS19

                        entry.autoAimTarget = { }
                        entry.autoAimTarget.node = xmlFile:getValue(key .. ".autoAimTargetNode#node" , nil , self.components, self.i3dMappings)
                        if entry.autoAimTarget.node ~ = nil then
                            entry.autoAimTarget.baseTrans = { getTranslation(entry.autoAimTarget.node) }
                            entry.autoAimTarget.startZ = xmlFile:getValue( key .. ".autoAimTargetNode#startZ" )
                            entry.autoAimTarget.endZ = xmlFile:getValue( key .. ".autoAimTargetNode#endZ" )
                            entry.autoAimTarget.startPercentage = xmlFile:getValue( key .. ".autoAimTargetNode#startPercentage" , 25 ) / 100
                            entry.autoAimTarget.invert = xmlFile:getValue( key .. ".autoAimTargetNode#invert" , false )
                            if entry.autoAimTarget.startZ ~ = nil and entry.autoAimTarget.endZ ~ = nil then
                                local startZ = entry.autoAimTarget.startZ
                                if entry.autoAimTarget.invert then
                                    startZ = entry.autoAimTarget.endZ
                                end

                                setTranslation(entry.autoAimTarget.node, entry.autoAimTarget.baseTrans[ 1 ], entry.autoAimTarget.baseTrans[ 2 ], startZ)
                            end
                        end

                        entry.supportedFillTypes = { }
                        local fillTypes
                        local fillTypeCategories = xmlFile:getValue(key .. "#fillTypeCategories" )
                        local fillTypeNames = xmlFile:getValue(key .. "#fillTypes" )
                        if fillTypeCategories ~ = nil and fillTypeNames = = nil then
                            fillTypes = g_fillTypeManager:getFillTypesByCategoryNames(fillTypeCategories, "Warning: '" .. self.configFileName .. "' has invalid fillTypeCategory '%s'." )
                        elseif fillTypeCategories = = nil and fillTypeNames ~ = nil then
                                fillTypes = g_fillTypeManager:getFillTypesByNames(fillTypeNames, "Warning: '" .. self.configFileName .. "' has invalid fillType '%s'." )
                            else
                                    Logging.xmlWarning( self.xmlFile, "Missing 'fillTypeCategories' or 'fillTypes' for fillUnit '%s'" , key)
                                        return false
                                    end

                                    if fillTypes ~ = nil then
                                        for _,fillType in pairs(fillTypes) do
                                            entry.supportedFillTypes[fillType] = true
                                        end
                                    end

                                    entry.supportedToolTypes = { }
                                    for i = 1 , g_toolTypeManager:getNumberOfToolTypes() do
                                        entry.supportedToolTypes[i] = true
                                    end

                                    local startFillLevel = xmlFile:getValue(key .. "#startFillLevel" )
                                    local startFillTypeStr = xmlFile:getValue(key .. "#startFillType" )
                                    if startFillTypeStr ~ = nil then
                                        local startFillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(startFillTypeStr)
                                        if startFillTypeIndex ~ = nil then
                                            entry.startFillLevel = startFillLevel
                                            entry.startFillTypeIndex = startFillTypeIndex
                                        end
                                    end

                                    entry.fillRootNode = xmlFile:getValue(key .. ".fillRootNode#node" , nil , self.components, self.i3dMappings)
                                    if entry.fillRootNode = = nil then
                                        entry.fillRootNode = self.components[ 1 ].node
                                    end

                                    entry.fillMassNode = xmlFile:getValue(key .. ".fillMassNode#node" , nil , self.components, self.i3dMappings)
                                    local updateFillLevelMass = xmlFile:getValue(key .. "#updateFillLevelMass" , true )
                                    if entry.fillMassNode = = nil and updateFillLevelMass then
                                        entry.fillMassNode = self.components[ 1 ].node
                                    end

                                    entry.ignoreFillLimit = xmlFile:getValue(key .. "#ignoreFillLimit" , false )

                                    -- mp sync info
                                    entry.synchronizeFillLevel = xmlFile:getValue(key .. "#synchronizeFillLevel" , true )
                                    entry.synchronizeFullFillLevel = xmlFile:getValue(key .. "#synchronizeFullFillLevel" , false )

                                    local defaultBits = 16
                                    for startCapacity, bits in pairs( FillUnit.CAPACITY_TO_NETWORK_BITS) do
                                        if entry.capacity > = startCapacity then
                                            defaultBits = bits
                                        end
                                    end

                                    entry.synchronizationNumBits = xmlFile:getValue(key .. "#synchronizationNumBits" , defaultBits)

                                    entry.showOnHud = xmlFile:getValue(key .. "#showOnHud" , true )
                                    entry.showOnInfoHud = xmlFile:getValue(key .. "#showOnInfoHud" , true )
                                    entry.uiPrecision = xmlFile:getValue(key .. "#uiPrecision" , 0 )
                                    entry.uiCustomFillTypeName = xmlFile:getValue(key .. "#uiCustomFillTypeName" , nil , self.customEnvironment, false )
                                    entry.uiExtraInfoText = xmlFile:getValue(key .. "#uiExtraInfoText" , nil , self.customEnvironment, false )
                                    entry.uiDisplayTypeId = FillLevelsDisplay [ "TYPE_" .. xmlFile:getValue(key .. "#uiDisplayType" , "BAR" )] or FillLevelsDisplay.TYPE_BAR
                                    local unitText = xmlFile:getValue(key .. "#unitTextOverride" )
                                    if unitText ~ = nil then
                                        entry.unitText = g_i18n:convertText(unitText)
                                    end
                                    entry.parentUnitOnHud = nil
                                    entry.childUnitOnHud = nil
                                    entry.blocksAutomatedTrainTravel = xmlFile:getValue(key .. "#blocksAutomatedTrainTravel" , false )

                                    entry.fillAnimation = xmlFile:getValue(key .. "#fillAnimation" )
                                    entry.fillAnimationLoadTime = xmlFile:getValue(key .. "#fillAnimationLoadTime" )
                                    entry.fillAnimationEmptyTime = xmlFile:getValue(key .. "#fillAnimationEmptyTime" )

                                    entry.fillLevelAnimations = { }
                                    for _, key in xmlFile:iterator(key .. ".fillLevelAnimation" ) do
                                        local fillLevelAnimation = { }
                                        fillLevelAnimation.name = xmlFile:getValue(key .. "#name" )
                                        if fillLevelAnimation.name ~ = nil then
                                            fillLevelAnimation.resetOnEmpty = xmlFile:getValue(key .. "#resetOnEmpty" , true )
                                            fillLevelAnimation.updateWhileFilled = xmlFile:getValue(key .. "#updateWhileFilled" , true )
                                            fillLevelAnimation.useMaxStateIfEmpty = xmlFile:getValue(key .. "#useMaxStateIfEmpty" , false )

                                            table.insert(entry.fillLevelAnimations, fillLevelAnimation)
                                        else
                                                Logging.xmlWarning(xmlFile, "Missing 'name' for fillLevelAnimation '%s'" , key)
                                                end
                                            end

                                            --
                                            if self.isClient then
                                                entry.alarmTriggers = { }
                                                local i = 0
                                                while true do
                                                    local nodeKey = key .. string.format( ".alarmTriggers.alarmTrigger(%d)" , i)
                                                    if not xmlFile:hasProperty(nodeKey) then
                                                        break
                                                    end
                                                    local alarmTrigger = { }
                                                    if self:loadAlarmTrigger(xmlFile, nodeKey, alarmTrigger, entry) then
                                                        table.insert(entry.alarmTriggers, alarmTrigger)
                                                    end
                                                    i = i + 1
                                                end

                                                entry.measurementNodes = { }
                                                i = 0
                                                while true do
                                                    local nodeKey = key .. string.format( ".measurementNodes.measurementNode(%d)" , i)
                                                    if not xmlFile:hasProperty(nodeKey) then
                                                        break
                                                    end

                                                    local measurementNode = { }
                                                    if self:loadMeasurementNode(xmlFile, nodeKey, measurementNode) then
                                                        table.insert(entry.measurementNodes, measurementNode)
                                                    end

                                                    i = i + 1
                                                end

                                                entry.fillPlane = { }
                                                entry.lastFillPlaneType = nil
                                                if not self:loadFillPlane(xmlFile, key .. ".fillPlane" , entry.fillPlane, entry) then
                                                    entry.fillPlane = nil
                                                end

                                                entry.fillTypeMaterials = self:loadFillTypeMaterials(xmlFile, key)

                                                entry.fillEffects = g_effectManager:loadEffect(xmlFile, key .. ".fillEffect" , self.components, self , self.i3dMappings)
                                                entry.animationNodes = g_animationManager:loadAnimations(xmlFile, key .. ".animationNodes" , self.components, self , self.i3dMappings)

                                                XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".fillLevelHud" , key .. ".dashboard" ) --FS17 to FS19

                                                entry.hasDashboards = false

                                                if self.registerDashboardValueType ~ = nil then
                                                    local fillUnitLoadFunc = function ( self , xmlFile, key, dashboard, isActive)
                                                        local fillTypeName = xmlFile:getValue(key .. "#fillType" )
                                                        if fillTypeName ~ = nil then
                                                            local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
                                                            if fillTypeIndex ~ = nil then
                                                                for _, fillUnit in ipairs(spec.fillUnits) do
                                                                    if fillUnit.supportedFillTypes[fillTypeIndex] then
                                                                        dashboard.fillUnit = fillUnit
                                                                    end
                                                                end
                                                            end
                                                        end

                                                        local fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" )
                                                        if fillUnitIndex ~ = nil then
                                                            dashboard.fillUnit = spec.fillUnits[fillUnitIndex]
                                                        end

                                                        if dashboard.fillUnit ~ = nil then
                                                            dashboard.fillUnit.hasDashboards = true
                                                        else
                                                                entry.hasDashboards = true
                                                            end

                                                            return true
                                                        end

                                                        local fillUnitLoadFuncWarning = function ( self , xmlFile, key, dashboard, isActive)
                                                            fillUnitLoadFunc( self , xmlFile, key, dashboard, isActive)

                                                            return Dashboard.warningAttributes( self , xmlFile, key, dashboard, isActive)
                                                        end

                                                        local fillLevel = DashboardValueType.new( "fillUnit" , "fillLevel" )
                                                        fillLevel:setXMLKey(key)
                                                        fillLevel:setValue(entry, function (_fillUnit, dashboard)
                                                            return(dashboard.fillUnit or _fillUnit).fillLevel
                                                        end )
                                                        fillLevel:setRange( 0 , function (_fillUnit, dashboard)
                                                            return(dashboard.fillUnit or _fillUnit).capacity
                                                        end )
                                                        fillLevel:setInterpolationSpeed( function (_fillUnit, dashboard)
                                                            return(dashboard.fillUnit or _fillUnit).capacity * 0.001
                                                        end )
                                                        fillLevel:setAdditionalFunctions(fillUnitLoadFunc, nil )
                                                        fillLevel:setPollUpdate( false )
                                                        self:registerDashboardValueType(fillLevel)

                                                        local fillLevelPct = DashboardValueType.new( "fillUnit" , "fillLevelPct" )
                                                        fillLevelPct:setXMLKey(key)
                                                        fillLevelPct:setValue(entry, function (_fillUnit, dashboard)
                                                            _fillUnit = dashboard.fillUnit or _fillUnit
                                                            return math.clamp(_fillUnit.fillLevel / _fillUnit.capacity, 0 , 1 ) * 100
                                                        end )
                                                        fillLevelPct:setRange( 0 , 100 )
                                                        fillLevelPct:setInterpolationSpeed( 100 * 0.001 )
                                                        fillLevelPct:setAdditionalFunctions(fillUnitLoadFunc, nil )
                                                        fillLevelPct:setPollUpdate( false )
                                                        self:registerDashboardValueType(fillLevelPct)

                                                        local fillLevelWarning = DashboardValueType.new( "fillUnit" , "fillLevelWarning" )
                                                        fillLevelWarning:setXMLKey(key)
                                                        fillLevelWarning:setValue(entry, function (_fillUnit, dashboard)
                                                            local fillLevel = (dashboard.fillUnit or _fillUnit).fillLevel
                                                            return fillLevel > dashboard.warningThresholdMin and fillLevel < dashboard.warningThresholdMax
                                                        end )
                                                        fillLevelWarning:setAdditionalFunctions(fillUnitLoadFuncWarning)
                                                        fillLevelWarning:setPollUpdate( false )
                                                        self:registerDashboardValueType(fillLevelWarning)
                                                    end
                                                end

                                                return true
                                            end

```

### loadFillUnitUnloadingFromXML

**Description**

**Definition**

> loadFillUnitUnloadingFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |
| any | index   |

**Code**

```lua
function FillUnit:loadFillUnitUnloadingFromXML(xmlFile, key, entry, index)
    entry.node = xmlFile:getValue(key .. "#node" , self.rootNode, self.components, self.i3dMappings)
    entry.width = xmlFile:getValue(key .. "#width" , 15 )
    entry.offset = xmlFile:getValue(key .. "#offset" , "0 0 0" , true )

    return true
end

```

### loadLevelerNodeFromXML

**Description**

**Definition**

> loadLevelerNodeFromXML()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | levelerNode |
| any | xmlFile     |
| any | key         |

**Code**

```lua
function FillUnit:loadLevelerNodeFromXML(superFunc, levelerNode, xmlFile, key)
    levelerNode.limitFillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" , 1 )
    levelerNode.minFillLevel = xmlFile:getValue(key .. "#minFillLevel" , 0 )
    levelerNode.maxFillLevel = xmlFile:getValue(key .. "#maxFillLevel" , 1 )

    return superFunc( self , levelerNode, xmlFile, key)
end

```

### loadMeasurementNode

**Description**

**Definition**

> loadMeasurementNode()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function FillUnit:loadMeasurementNode(xmlFile, key, entry)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" )

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node = = nil then
        Logging.xmlWarning( self.xmlFile, "Missing 'node' for measurementNode '%s'" , key)
            return false
        end
        entry.node = node
        entry.measurementTime = 0
        entry.intensity = 0

        return true
    end

```

### loadMovingToolFromXML

**Description**

**Definition**

> loadMovingToolFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function FillUnit:loadMovingToolFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" )
    entry.minFillLevel = xmlFile:getValue(key .. "#minFillLevel" )
    entry.maxFillLevel = xmlFile:getValue(key .. "#maxFillLevel" )

    return true
end

```

### loadSpecValueCapacity

**Description**

**Definition**

> loadSpecValueCapacity()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function FillUnit.loadSpecValueCapacity(xmlFile, customEnvironment, baseDir)
    -- check if #unitText or #unit was set and convert capacity, liters otherwise
        local function getUnitCapacityAndText(fillUnitKey, capacity)
            local unitText = xmlFile:getValue(fillUnitKey .. "#unitTextOverride" )
            if unitText = = nil then
                local unitId = xmlFile:getValue(fillUnitKey .. "#shopDisplayUnit" )
                local convFuncAndL10n = FillUnit.UNIT[unitId]
                if unitId ~ = nil and convFuncAndL10n = = nil then
                    Logging.xmlWarning(xmlFile, "Unit '%s' is not defined in fillUnit '%s'.Available units: %s.Using LITER as default" , unitId, fillUnitKey, table.concatKeys( FillUnit.UNIT, " " ))
                end
                convFuncAndL10n = convFuncAndL10n or FillUnit.UNIT[ "LITER" ]
                return convFuncAndL10n.conversionFunc(capacity), convFuncAndL10n.l10n, convFuncAndL10n.conversionFunc
            end
            return capacity, unitText
        end

        local rootName = xmlFile:getRootName()
        local fillUnitConfigurations = { }

        XMLUtil.checkDeprecatedXMLElements(xmlFile, rootName .. ".storeData.specs.capacity#unit" , rootName .. ".storeData.specs.capacity#unitTextOverride" ) --FS19 to FS22

        local overwrittenCapacity = xmlFile:getValue(rootName .. ".storeData.specs.capacity" )
        local overwrittenUnitText
        local conversionFunc

        if overwrittenCapacity ~ = nil then
            overwrittenCapacity, overwrittenUnitText, conversionFunc = getUnitCapacityAndText(rootName .. ".storeData.specs.capacity" , overwrittenCapacity)
        end

        if overwrittenCapacity ~ = nil and overwrittenUnitText ~ = nil then
            table.insert(fillUnitConfigurations, { isSelectable = true , fillUnits = { { capacity = overwrittenCapacity, unit = overwrittenUnitText, conversionFunc = conversionFunc } } } )
            return fillUnitConfigurations
        end

        xmlFile:iterate(rootName .. ".fillUnit.fillUnitConfigurations.fillUnitConfiguration" , function (_, key)
            local fillUnitConfiguration = { }
            fillUnitConfiguration.isSelectable = xmlFile:getValue(key .. "#isSelectable" , true )
            fillUnitConfiguration.fillUnits = { }

            xmlFile:iterate(key .. ".fillUnits.fillUnit" , function (fillUnitIndex, fillUnitKey)

                XMLUtil.checkDeprecatedXMLElements(xmlFile, fillUnitKey .. "#unit" , fillUnitKey .. "#unitTextOverride" ) --FS19 to FS22

                if xmlFile:getValue(fillUnitKey .. "#showCapacityInShop" ) ~ = false and xmlFile:getValue(fillUnitKey .. "#showInShop" ) ~ = false then
                    local capacity = xmlFile:getValue(fillUnitKey .. "#capacity" ) or 0
                    local unitText

                    capacity, unitText, conversionFunc = getUnitCapacityAndText(fillUnitKey, capacity)

                    table.insert(fillUnitConfiguration.fillUnits, { capacity = capacity, unit = unitText, conversionFunc = conversionFunc, fillUnitIndex = fillUnitIndex } )
                end
            end )

            table.insert(fillUnitConfigurations, fillUnitConfiguration)
        end )

        if #fillUnitConfigurations > 0 then
            return fillUnitConfigurations
        end

        return nil
    end

```

### loadSpecValueFillTypes

**Description**

**Definition**

> loadSpecValueFillTypes()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function FillUnit.loadSpecValueFillTypes(xmlFile, customEnvironment, baseDir)
    local fillTypeNames = nil
    local fillTypeCategoryNames = nil
    local fillTypes = nil
    local fruitTypeNames = nil
    local fillTypesByConfiguration = { }

    local rootName = xmlFile:getRootName()

    XMLUtil.checkDeprecatedXMLElements(xmlFile, rootName .. ".fillTypes" , rootName .. ".cutter#fruitTypes" ) --FS19 to FS21
    XMLUtil.checkDeprecatedXMLElements(xmlFile, rootName .. ".fruitTypes" , rootName .. ".storeData.specs.fillTypes" ) --FS19 to FS21
    XMLUtil.checkDeprecatedXMLElements(xmlFile, rootName .. ".fillTypeCategories" , rootName .. ".storeData.specs.fillTypeCategories" ) --FS19 to FS21

    -- get fill types of all configurations and all fill units to display all possible fill types
    local i = 0
    while true do
        local key = string.format(rootName .. ".fillUnit.fillUnitConfigurations.fillUnitConfiguration(%d)" , i)
        if not xmlFile:hasProperty(key) then
            break
        end

        local j = 0
        while true do
            local unitKey = string.format(key .. ".fillUnits.fillUnit(%d)" , j)
            if not xmlFile:hasProperty(unitKey) then
                break
            end

            local showInShop = xmlFile:getValue(unitKey .. "#showInShop" )
            local capacity = xmlFile:getValue(unitKey .. "#capacity" )
            if (showInShop = = nil or showInShop) and(capacity = = nil or capacity > 0 ) then
                local currentFillTypes = xmlFile:getValue(unitKey .. "#fillTypes" )
                if currentFillTypes ~ = nil then
                    if fillTypeNames = = nil then
                        fillTypeNames = currentFillTypes
                    else
                            fillTypeNames = fillTypeNames .. " " .. currentFillTypes
                        end
                    end

                    local currentFillTypeCategories = xmlFile:getValue(unitKey .. "#fillTypeCategories" )
                    if currentFillTypeCategories ~ = nil then
                        if fillTypeCategoryNames = = nil then
                            fillTypeCategoryNames = currentFillTypeCategories
                        else
                                fillTypeCategoryNames = fillTypeCategoryNames .. " " .. currentFillTypeCategories
                            end
                        end

                        fillTypesByConfiguration[i + 1 ] = { fillTypeNames = currentFillTypes, categoryNames = currentFillTypeCategories }
                    end

                    j = j + 1
                end

                i = i + 1
            end

            local overwrittenFillTypeNames = xmlFile:getValue(rootName .. ".storeData.specs.fillTypes" )
            if overwrittenFillTypeNames ~ = nil then
                fillTypeNames = overwrittenFillTypeNames
                fillTypeCategoryNames = nil
            end

            if fillTypes = = nil then
                fruitTypeNames = xmlFile:getValue(rootName .. ".storeData.specs.fruitTypes" )

                if fruitTypeNames = = nil then
                    fruitTypeNames = xmlFile:getValue(rootName .. ".cutter#fruitTypes" )
                end
            end

            local fruitTypeCategoryNames = xmlFile:getValue(rootName .. ".storeData.specs.fruitTypeCategories" )
            if fruitTypeCategoryNames = = nil then
                fruitTypeCategoryNames = xmlFile:getValue(rootName .. ".cutter#fruitTypeCategories" )
            end

            local windrowFillTypes = nil
            local fillTypeConverterName = xmlFile:getValue(rootName .. ".cutter#fillTypeConverter" )
            if fillTypeConverterName ~ = nil then
                local fillTypeConverter = g_fillTypeManager:getConverterDataByName(fillTypeConverterName)
                if fillTypeConverter ~ = nil then
                    windrowFillTypes = { }
                    for sourceFillTypeIndex, _ in pairs(fillTypeConverter) do
                        table.insert(windrowFillTypes, sourceFillTypeIndex)
                    end

                    table.sort(windrowFillTypes)
                end
            end

            fillTypeCategoryNames = xmlFile:getValue(rootName .. ".storeData.specs.fillTypeCategories" , fillTypeCategoryNames)

            return { categoryNames = fillTypeCategoryNames, fillTypeNames = fillTypeNames, fruitTypeNames = fruitTypeNames, fruitTypeCategoryNames = fruitTypeCategoryNames, windrowFillTypes = windrowFillTypes, fillTypesByConfiguration = fillTypesByConfiguration }
        end

```

### loadSpecValueFillUnitMassData

**Description**

**Definition**

> loadSpecValueFillUnitMassData()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function FillUnit.loadSpecValueFillUnitMassData(xmlFile, customEnvironment, baseDir)
    local fillUnitMassData = { }
    xmlFile:iterate( "vehicle.motorized.consumerConfigurations.consumerConfiguration(0).consumer" , function (index, key)
        local fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" , 0 )
        if fillUnitIndex ~ = 0 then
            local capacity = xmlFile:getValue(key .. "#capacity" )

            local unitKey = string.format( "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration(0).fillUnits.fillUnit(%d)" , fillUnitIndex - 1 )

            local fillTypeCategories = xmlFile:getValue(unitKey .. "#fillTypeCategories" )
            local fillTypes = xmlFile:getValue(unitKey .. "#fillTypes" )
            if capacity = = nil then
                capacity = xmlFile:getValue(unitKey .. "#capacity" , 0 )
            end

            if capacity > 0 then
                table.insert(fillUnitMassData, { fillTypeCategories = fillTypeCategories, fillTypes = fillTypes, capacity = capacity } )
            end
        end
    end )

    xmlFile:iterate( "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration(0).fillUnits.fillUnit" , function (index, key)
        local startFillLevel = xmlFile:getValue(key .. "#startFillLevel" , 0 )
        if startFillLevel > 0 then
            local startFillType = xmlFile:getValue(key .. "#startFillType" )
            table.insert(fillUnitMassData, { fillType = startFillType, capacity = startFillLevel } )
        end
    end )

    return fillUnitMassData
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function FillUnit:onDeactivate()
    local spec = self.spec_fillUnit
    if spec.fillTrigger.isFilling then
        self:setFillUnitIsFilling( false , true )
    end

    for _, fillUnit in pairs(spec.fillUnits) do
        self:updateMeasurementNodes(fillUnit, 0 , false , 0 )
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function FillUnit:onDelete()
    local spec = self.spec_fillUnit

    if spec.fillTrigger ~ = nil then
        g_currentMission.activatableObjectsSystem:removeActivatable(spec.fillTrigger.activatable)
        for _, trigger in pairs(spec.fillTrigger.triggers) do
            trigger:onVehicleDeleted( self )
        end
        spec.fillTrigger.currentTrigger = nil
        spec.fillTrigger.selectedTrigger = nil
    end

    if spec.fillUnits ~ = nil then
        for _, fillUnit in ipairs(spec.fillUnits) do
            for _, alarmTrigger in ipairs(fillUnit.alarmTriggers) do
                g_soundManager:deleteSample(alarmTrigger.sample)

                for _, beaconLight in ipairs(alarmTrigger.beaconLights) do
                    beaconLight:delete()
                end
            end

            g_effectManager:deleteEffects(fillUnit.fillEffects)
            g_animationManager:deleteAnimations(fillUnit.animationNodes)

            if fillUnit.exactFillRootNode ~ = nil then
                g_currentMission:removeNodeObject(fillUnit.exactFillRootNode)
            end
        end
    end

    g_effectManager:deleteEffects(spec.fillEffects)
    g_animationManager:deleteAnimations(spec.animationNodes)

    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples)
        table.clear(spec.samples)
    end
end

```

### onDischargeTargetObjectChanged

**Description**

**Definition**

> onDischargeTargetObjectChanged()

**Arguments**

| any | dischargeObject |
|-----|-----------------|

**Code**

```lua
function FillUnit:onDischargeTargetObjectChanged(dischargeObject)
    -- update unloading action event in case we overlap with the overloading action
    FillUnit.updateUnloadActionDisplay( self )
end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Arguments**

| any | isActiveForInput                |
|-----|---------------------------------|
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function FillUnit:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self:getDrawFirstFillText() then
        local spec = self.spec_fillUnit
        g_currentMission:addExtraPrintText(spec.texts.firstFillTheTool)
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
function FillUnit:onLoad(savegame)
    local spec = self.spec_fillUnit

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.measurementNodes.measurementNode" , "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration.fillUnits.fillUnit.measurementNodes.measurementNode" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.fillPlanes.fillPlane" , "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration.fillUnits.fillUnit.fillPlane" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.foldable.foldingParts#onlyFoldOnEmpty" , "vehicle.fillUnit#allowFoldingWhileFilled" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.fillAutoAimTargetNode" , "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration.fillUnits.fillUnit.autoAimTargetNode" ) --FS17 to FS19

    local fillUnitConfigurationId = Utils.getNoNil( self.configurations[ "fillUnit" ], 1 )
    local baseKey = string.format( "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration(%d).fillUnits" , fillUnitConfigurationId - 1 )

    spec.removeVehicleIfEmpty = self.xmlFile:getValue(baseKey .. "#removeVehicleIfEmpty" , false )
    spec.removeVehicleThreshold = self.xmlFile:getValue(baseKey .. "#removeVehicleThreshold" , 0 )
    spec.removeVehicleDelay = self.xmlFile:getValue(baseKey .. "#removeVehicleDelay" , 0 )
    spec.removeVehicleReward = self.xmlFile:getValue(baseKey .. "#removeVehicleReward" , 0 )
    spec.allowFoldingWhileFilled = self.xmlFile:getValue(baseKey .. "#allowFoldingWhileFilled" , true )
    spec.resetFoldingWhileFilled = self.xmlFile:getValue(baseKey .. "#resetFoldingWhileFilled" , false )
    spec.allowFoldingThreshold = self.xmlFile:getValue(baseKey .. "#allowFoldingThreshold" , 0.0001 )
    spec.fillTypeChangeThreshold = self.xmlFile:getValue(baseKey .. "#fillTypeChangeThreshold" , 0.05 ) -- fill level percentage that still allows overriding with another fill type
    spec.fillUnits = { }
    spec.exactFillRootNodeToFillUnit = { }
    spec.exactFillRootNodeToExtraDistance = { }
    spec.exactFillRootNodeAimToUpdate = { }
    spec.hasExactFillRootNodes = false
    spec.activeAlarmTriggers = { }

    spec.fillTrigger = { }
    spec.fillTrigger.triggers = { }
    spec.fillTrigger.activatable = FillActivatable.new( self )
    spec.fillTrigger.isFilling = false
    spec.fillTrigger.currentTrigger = nil -- trigger that is currently used for filling
        spec.fillTrigger.selectedTrigger = nil -- currently used trigger no matter if filling or not
            spec.fillTrigger.litersPerSecond = self.xmlFile:getValue(baseKey .. ".fillTrigger#litersPerSecond" , 200 )
            spec.fillTrigger.consumePtoPower = self.xmlFile:getValue(baseKey .. ".fillTrigger#consumePtoPower" , false )

            local i = 0
            while true do
                local key = string.format( "%s.fillUnit(%d)" , baseKey, i)
                if not self.xmlFile:hasProperty(key) then
                    break
                end
                local entry = { }

                if self:loadFillUnitFromXML( self.xmlFile, key, entry, i + 1 ) then
                    table.insert(spec.fillUnits, entry)
                else
                        Logging.xmlWarning( self.xmlFile, "Could not load fillUnit for '%s'" , key)
                            self:setLoadingState(VehicleLoadingState.ERROR)
                            break
                        end

                        i = i + 1
                    end

                    if self.xmlFile:hasProperty(baseKey .. ".unloading" ) then
                        spec.unloading = { }
                        self.xmlFile:iterate(baseKey .. ".unloading" , function (_, unloadingKey)
                            local entry = { }

                            if self:loadFillUnitUnloadingFromXML( self.xmlFile, unloadingKey, entry, i + 1 ) then
                                table.insert(spec.unloading, entry)
                                return
                            else
                                    Logging.xmlWarning( self.xmlFile, "Could not load unloading node for '%s'" , unloadingKey)
                                        return false -- stop iteration
                                    end
                                end )
                            end

                            if self.isClient then
                                spec.samples = { }
                                spec.samples.fill = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.fillUnit.sounds" , "fill" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

                                spec.fillEffects = g_effectManager:loadEffect( self.xmlFile, baseKey .. ".fillEffect" , self.components, self , self.i3dMappings)
                                spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, baseKey .. ".animationNodes" , self.components, self , self.i3dMappings)

                                spec.activeFillEffects = { }
                                spec.activeFillAnimations = { }
                            end

                            spec.texts = { }
                            spec.texts.warningFoldingFilled = g_i18n:getText( "warning_foldingNotWhileFilled" )
                            spec.texts.firstFillTheTool = g_i18n:getText( "info_firstFillTheTool" )
                            spec.texts.unloadNoSpace = g_i18n:getText( "fillUnit_unload_nospace" )
                            spec.texts.stopRefill = g_i18n:getText( "action_stopRefillingOBJECT" )
                            spec.texts.startRefill = g_i18n:getText( "action_refillOBJECT" )

                            spec.isInfoDirty = false
                            spec.fillUnitInfos = { }

                            spec.dirtyFlag = self:getNextDirtyFlag()
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
function FillUnit:onPostLoad(savegame)
    local spec = self.spec_fillUnit

    if self.isServer then
        -- fill units that do not have a start fill level will be only loaded from savegame if not reset and savegame available
            local fillUnitsToLoad = { }
            for i, fillUnit in ipairs(spec.fillUnits) do
                if fillUnit.startFillLevel = = nil and fillUnit.startFillTypeIndex = = nil then
                    fillUnitsToLoad[i] = fillUnit
                end
            end

            -- if the fill units are not in the savegame we fill them also with the start fill level(e.g.on a new savegame)
                if savegame ~ = nil and savegame.xmlFile:hasProperty(savegame.key .. ".fillUnit" ) then
                    local i = 0
                    local xmlFile = savegame.xmlFile
                    while true do
                        local key = string.format( "%s.fillUnit.unit(%d)" , savegame.key, i)
                        if not xmlFile:hasProperty(key) then
                            break
                        end

                        local fillUnitIndex = xmlFile:getValue(key .. "#index" )

                        local allowLoading = fillUnitsToLoad[fillUnitIndex] = = nil or -- always load(fill unit with start fill level)
                        (fillUnitsToLoad[fillUnitIndex] ~ = nil and( not savegame.resetVehicles or not self:getFillUnitEmptyOnReset())) -- only load if not reset(fill unit without start fill level)
                            if allowLoading then
                                local fillTypeName = xmlFile:getValue(key .. "#fillType" )
                                local fillLevel = xmlFile:getValue(key .. "#fillLevel" )
                                local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
                                self:addFillUnitFillLevel( self:getOwnerFarmId(), fillUnitIndex, fillLevel, fillTypeIndex, ToolType.UNDEFINED, nil )

                                local fillUnit = spec.fillUnits[fillUnitIndex]
                                if fillUnit ~ = nil then
                                    for _, fillLevelAnimation in ipairs(fillUnit.fillLevelAnimations) do
                                        AnimatedVehicle.updateAnimationByName( self , fillLevelAnimation.name, 9999999 , true )
                                    end
                                end
                            end

                            i = i + 1
                        end
                    else
                            if not self.vehicleLoadingData:getCustomParameter( "spawnEmpty" ) then
                                -- fill units that are filled by a start fill level are always loaded from the savegame(otherwise you could cheat if you reset the vehicle)
                                    for fillUnitIndex, fillUnit in pairs(spec.fillUnits) do
                                        if fillUnit.startFillLevel ~ = nil and fillUnit.startFillTypeIndex ~ = nil then
                                            self:addFillUnitFillLevel( self:getOwnerFarmId(), fillUnitIndex, fillUnit.startFillLevel, fillUnit.startFillTypeIndex, ToolType.UNDEFINED, nil )

                                            for _, fillLevelAnimation in ipairs(fillUnit.fillLevelAnimations) do
                                                AnimatedVehicle.updateAnimationByName( self , fillLevelAnimation.name, 9999999 , true )
                                            end
                                        end
                                    end
                                end
                            end

                            for i, fillUnit in ipairs(spec.fillUnits) do
                                self:updateAlarmTriggers(fillUnit.alarmTriggers)
                            end
                        end

                        if #spec.fillUnits = = 0 then
                            SpecializationUtil.removeEventListener( self , "onReadStream" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onWriteStream" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onReadUpdateStream" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onWriteUpdateStream" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onUpdateTick" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onPostUpdate" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onDraw" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onDeactivate" , FillUnit )
                            SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , FillUnit )
                        end
                    end

```

### onPostUpdate

**Description**

> Called on post update

**Definition**

> onPostUpdate(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function FillUnit:onPostUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_fillUnit
    for vehicle, func in pairs(spec.exactFillRootNodeAimToUpdate) do
        if not vehicle.isDeleted then
            func(vehicle, dt)
        end

        spec.exactFillRootNodeAimToUpdate[vehicle] = nil
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
function FillUnit:onReadStream(streamId, connection)
    if connection:getIsServer() then
        local spec = self.spec_fillUnit

        self:setFillUnitIsFilling(streamReadBool(streamId), true )

        for i = 1 ,#spec.fillUnits do
            if spec.fillUnits[i].synchronizeFillLevel then
                local fillLevel = streamReadFloat32(streamId)
                local fillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)

                self:addFillUnitFillLevel( self:getOwnerFarmId(), i, fillLevel, fillType, ToolType.UNDEFINED, nil )

                local lastValidFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                self:setFillUnitLastValidFillType(i, lastValidFillType, true )
            end
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
function FillUnit:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_fillUnit

        if streamReadBool(streamId) then
            for i = 1 ,#spec.fillUnits do
                local fillUnit = spec.fillUnits[i]
                if fillUnit.synchronizeFillLevel then
                    local fillLevel
                    if streamReadBool(streamId) then
                        fillLevel = streamReadFloat32(streamId)
                    else
                            local maxValue = 2 ^ fillUnit.synchronizationNumBits - 1
                            fillLevel = fillUnit.capacity * streamReadUIntN(streamId, fillUnit.synchronizationNumBits) / maxValue
                        end

                        local fillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                        if fillLevel ~ = fillUnit.fillLevel or fillType ~ = fillUnit.fillType then
                            local oldFillType = self:getFillUnitFillType(i)

                            -- if fill type is unknown we empty the fillUnit
                                if fillType = = FillType.UNKNOWN then
                                    self:addFillUnitFillLevel( self:getOwnerFarmId(), i, - math.huge, oldFillType, ToolType.UNDEFINED, nil )
                                else
                                        -- in case the fill type was switched dynamically
                                        if oldFillType ~ = FillType.UNKNOWN and fillType ~ = oldFillType then
                                            self:setFillUnitFillType(i, fillType)
                                        end

                                        self:addFillUnitFillLevel( self:getOwnerFarmId(), i, fillLevel - fillUnit.fillLevel, fillType, ToolType.UNDEFINED, nil )
                                    end
                                end

                                local lastValidFillType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                                self:setFillUnitLastValidFillType(i, lastValidFillType, lastValidFillType ~ = fillUnit.lastValidFillType)
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
function FillUnit:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_fillUnit
        self:clearActionEventsTable(spec.actionEvents)
        if isActiveForInputIgnoreSelection then
            if self.isServer and GS_IS_CONSOLE_VERSION and g_isDevelopmentVersion then
                local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.CONSOLE_DEBUG_FILLUNIT_NEXT, self , FillUnit.actionEventConsoleFillUnitNext, false , true , false , true , nil )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.CONSOLE_DEBUG_FILLUNIT_INC, self , FillUnit.actionEventConsoleFillUnitInc, false , true , false , true , nil )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
                _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.CONSOLE_DEBUG_FILLUNIT_DEC, self , FillUnit.actionEventConsoleFillUnitDec, false , true , false , true , nil )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_LOW)
            end

            if spec.unloading ~ = nil then
                local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.UNLOAD, self , FillUnit.actionEventUnload, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
                spec.unloadActionEventId = actionEventId
                FillUnit.updateUnloadActionDisplay( self )
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
function FillUnit:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_fillUnit

    if self.isServer and spec.fillTrigger.isFilling then
        local delta = 0
        local trigger = spec.fillTrigger.currentTrigger
        if trigger ~ = nil then
            delta = spec.fillTrigger.litersPerSecond * dt * 0.001
            delta = trigger:fillVehicle( self , delta, dt)
        end

        if delta < = 0 then
            self:setFillUnitIsFilling( false )
        end
    end

    if self.isClient then
        for _, fillUnit in pairs(spec.fillUnits) do
            self:updateMeasurementNodes(fillUnit, dt, false )
        end

        self:updateAlarmTriggers(spec.activeAlarmTriggers)

        local needsUpdate = false

        -- stop effects
        for effect, time in pairs(spec.activeFillEffects) do
            time = time - dt
            if time < 0 then
                g_effectManager:stopEffects(effect)
                spec.activeFillEffects[effect] = nil
            else
                    needsUpdate = true
                    spec.activeFillEffects[effect] = time
                end
            end

            -- stop animations
            for animationNodes, time in pairs(spec.activeFillAnimations) do
                time = time - dt
                if time < 0 then
                    g_animationManager:stopAnimations(animationNodes)
                    spec.activeFillAnimations[animationNodes] = nil
                else
                        needsUpdate = true
                        spec.activeFillAnimations[animationNodes] = time
                    end
                end

                if needsUpdate then
                    self:raiseActive()
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
function FillUnit:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_fillUnit

        streamWriteBool(streamId, spec.fillTrigger.isFilling)

        for i = 1 ,#spec.fillUnits do
            if spec.fillUnits[i].synchronizeFillLevel then
                local fillUnit = spec.fillUnits[i]
                streamWriteFloat32(streamId, fillUnit.fillLevel)
                streamWriteUIntN(streamId, fillUnit.fillType, FillTypeManager.SEND_NUM_BITS)
                streamWriteUIntN(streamId, fillUnit.lastValidFillType, FillTypeManager.SEND_NUM_BITS)
            end
        end
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
function FillUnit:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_fillUnit

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            for i = 1 ,#spec.fillUnits do
                local fillUnit = spec.fillUnits[i]
                if fillUnit.synchronizeFillLevel then
                    if streamWriteBool(streamId, fillUnit.synchronizeFullFillLevel or fillUnit.capacity = = math.huge) then
                        streamWriteFloat32(streamId, fillUnit.fillLevelSent)
                    else
                            local percent = 0
                            if fillUnit.capacity > 0 then
                                percent = math.clamp(fillUnit.fillLevelSent / fillUnit.capacity, 0 , 1 )
                            end

                            local value = math.floor(percent * ( 2 ^ fillUnit.synchronizationNumBits - 1 ) + 0.5 )
                            streamWriteUIntN(streamId, value, fillUnit.synchronizationNumBits)
                        end
                        streamWriteUIntN(streamId, fillUnit.fillTypeSent, FillTypeManager.SEND_NUM_BITS)
                        streamWriteUIntN(streamId, fillUnit.lastValidFillTypeSent, FillTypeManager.SEND_NUM_BITS)
                    end
                end
            end
        end
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
function FillUnit.prerequisitesPresent(specializations)
    return true
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
function FillUnit.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onPostUpdate" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , FillUnit )
    SpecializationUtil.registerEventListener(vehicleType, "onDischargeTargetObjectChanged" , FillUnit )
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
function FillUnit.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onFillUnitFillLevelChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onChangedFillType" )
    SpecializationUtil.registerEvent(vehicleType, "onAlarmTriggerChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onAddedFillUnitTrigger" )
    SpecializationUtil.registerEvent(vehicleType, "onFillUnitTriggerChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onRemovedFillUnitTrigger" )
    SpecializationUtil.registerEvent(vehicleType, "onFillUnitIsFillingStateChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onFillUnitUnloadPallet" )
    SpecializationUtil.registerEvent(vehicleType, "onFillUnitUnloaded" )
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
function FillUnit.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getDrawFirstFillText" , FillUnit.getDrawFirstFillText)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnits" , FillUnit.getFillUnits)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitByIndex" , FillUnit.getFillUnitByIndex)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitExists" , FillUnit.getFillUnitExists)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitCapacity" , FillUnit.getFillUnitCapacity)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitFreeCapacity" , FillUnit.getFillUnitFreeCapacity)
    SpecializationUtil.registerFunction(vehicleType, "getIsFillAllowedFromFarm" , FillUnit.getIsFillAllowedFromFarm)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitFillLevel" , FillUnit.getFillUnitFillLevel)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitFillLevelPercentage" , FillUnit.getFillUnitFillLevelPercentage)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitFillType" , FillUnit.getFillUnitFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitLastValidFillType" , FillUnit.getFillUnitLastValidFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitFirstSupportedFillType" , FillUnit.getFillUnitFirstSupportedFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitExactFillRootNode" , FillUnit.getFillUnitExactFillRootNode)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitRootNode" , FillUnit.getFillUnitRootNode)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitAutoAimTargetNode" , FillUnit.getFillUnitAutoAimTargetNode)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitSupportsFillType" , FillUnit.getFillUnitSupportsFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitSupportsToolType" , FillUnit.getFillUnitSupportsToolType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitSupportsToolTypeAndFillType" , FillUnit.getFillUnitSupportsToolTypeAndFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitSupportedFillTypes" , FillUnit.getFillUnitSupportedFillTypes)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitSupportedToolTypes" , FillUnit.getFillUnitSupportedToolTypes)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitAllowsFillType" , FillUnit.getFillUnitAllowsFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillTypeChangeThreshold" , FillUnit.getFillTypeChangeThreshold)
    SpecializationUtil.registerFunction(vehicleType, "getFirstValidFillUnitToFill" , FillUnit.getFirstValidFillUnitToFill)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitCanBeFilled" , FillUnit.getFillUnitCanBeFilled)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitFillType" , FillUnit.setFillUnitFillType)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitFillTypeToDisplay" , FillUnit.setFillUnitFillTypeToDisplay)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitFillLevelToDisplay" , FillUnit.setFillUnitFillLevelToDisplay)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitCapacityToDisplay" , FillUnit.setFillUnitCapacityToDisplay)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitCapacity" , FillUnit.setFillUnitCapacity)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitForcedMaterialFillType" , FillUnit.setFillUnitForcedMaterialFillType)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitForcedMaterialFillType" , FillUnit.getFillUnitForcedMaterialFillType)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitInTriggerRange" , FillUnit.setFillUnitInTriggerRange)
    SpecializationUtil.registerFunction(vehicleType, "updateAlarmTriggers" , FillUnit.updateAlarmTriggers)
    SpecializationUtil.registerFunction(vehicleType, "getAlarmTriggerIsActive" , FillUnit.getAlarmTriggerIsActive)
    SpecializationUtil.registerFunction(vehicleType, "setAlarmTriggerState" , FillUnit.setAlarmTriggerState)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitIndexFromNode" , FillUnit.getFillUnitIndexFromNode)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitExtraDistanceFromNode" , FillUnit.getFillUnitExtraDistanceFromNode)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitFromNode" , FillUnit.getFillUnitFromNode)
    SpecializationUtil.registerFunction(vehicleType, "addFillUnitFillLevel" , FillUnit.addFillUnitFillLevel)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitLastValidFillType" , FillUnit.setFillUnitLastValidFillType)
    SpecializationUtil.registerFunction(vehicleType, "loadFillUnitFromXML" , FillUnit.loadFillUnitFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadAlarmTrigger" , FillUnit.loadAlarmTrigger)
    SpecializationUtil.registerFunction(vehicleType, "loadMeasurementNode" , FillUnit.loadMeasurementNode)
    SpecializationUtil.registerFunction(vehicleType, "updateMeasurementNodes" , FillUnit.updateMeasurementNodes)
    SpecializationUtil.registerFunction(vehicleType, "loadFillPlane" , FillUnit.loadFillPlane)
    SpecializationUtil.registerFunction(vehicleType, "setFillPlaneForcedFillType" , FillUnit.setFillPlaneForcedFillType)
    SpecializationUtil.registerFunction(vehicleType, "updateFillUnitFillPlane" , FillUnit.updateFillUnitFillPlane)
    SpecializationUtil.registerFunction(vehicleType, "loadFillTypeMaterials" , FillUnit.loadFillTypeMaterials)
    SpecializationUtil.registerFunction(vehicleType, "updateFillTypeMaterials" , FillUnit.updateFillTypeMaterials)
    SpecializationUtil.registerFunction(vehicleType, "updateFillUnitAutoAimTarget" , FillUnit.updateFillUnitAutoAimTarget)
    SpecializationUtil.registerFunction(vehicleType, "addFillUnitTrigger" , FillUnit.addFillUnitTrigger)
    SpecializationUtil.registerFunction(vehicleType, "removeFillUnitTrigger" , FillUnit.removeFillUnitTrigger)
    SpecializationUtil.registerFunction(vehicleType, "setFillUnitIsFilling" , FillUnit.setFillUnitIsFilling)
    SpecializationUtil.registerFunction(vehicleType, "setFillSoundIsPlaying" , FillUnit.setFillSoundIsPlaying)
    SpecializationUtil.registerFunction(vehicleType, "getIsFillUnitActive" , FillUnit.getIsFillUnitActive)
    SpecializationUtil.registerFunction(vehicleType, "updateFillUnitTriggers" , FillUnit.updateFillUnitTriggers)
    SpecializationUtil.registerFunction(vehicleType, "emptyAllFillUnits" , FillUnit.emptyAllFillUnits)
    SpecializationUtil.registerFunction(vehicleType, "unloadFillUnits" , FillUnit.unloadFillUnits)
    SpecializationUtil.registerFunction(vehicleType, "loadFillUnitUnloadingFromXML" , FillUnit.loadFillUnitUnloadingFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitUnloadPalletFilename" , FillUnit.getFillUnitUnloadPalletFilename)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitHasMountedPalletsToUnload" , FillUnit.getFillUnitHasMountedPalletsToUnload)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitMountedPalletsToUnload" , FillUnit.getFillUnitMountedPalletsToUnload)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitUnloadingTasks" , FillUnit.getFillUnitUnloadingTasks)
    SpecializationUtil.registerFunction(vehicleType, "getFillUnitEmptyOnReset" , FillUnit.getFillUnitEmptyOnReset)
    SpecializationUtil.registerFunction(vehicleType, "getAllowLoadTriggerActivation" , FillUnit.getAllowLoadTriggerActivation)
    SpecializationUtil.registerFunction(vehicleType, "addExactFillRootAimToUpdate" , FillUnit.addExactFillRootAimToUpdate)
    SpecializationUtil.registerFunction(vehicleType, "debugGetSupportedFillTypesPerFillUnit" , FillUnit.debugGetSupportedFillTypesPerFillUnit)
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
function FillUnit.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAdditionalComponentMass" , FillUnit.getAdditionalComponentMass)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillLevelInformation" , FillUnit.getFillLevelInformation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , FillUnit.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsReadyForAutomatedTrainTravel" , FillUnit.getIsReadyForAutomatedTrainTravel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingToolFromXML" , FillUnit.loadMovingToolFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingToolActive" , FillUnit.getIsMovingToolActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower" , FillUnit.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsPowerTakeOffActive" , FillUnit.getIsPowerTakeOffActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , FillUnit.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "showInfo" , FillUnit.showInfo)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadLevelerNodeFromXML" , FillUnit.loadLevelerNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsLevelerPickupNodeActive" , FillUnit.getIsLevelerPickupNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadAttacherJointFromXML" , FillUnit.loadAttacherJointFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAttacherJointCompatible" , FillUnit.getIsAttacherJointCompatible)
end

```

### registerUnitDisplaySchema

**Description**

**Definition**

> registerUnitDisplaySchema()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function FillUnit.registerUnitDisplaySchema(schema, key)
    schema:register(XMLValueType.STRING, key .. "#shopDisplayUnit" , "Unit used for displaying the capacity in shop(converts to given unit from capacity in liters)" , "LITER" , false , table.toList( FillUnit.UNIT))
        schema:register(XMLValueType.STRING, key .. "#unitTextOverride" , "Unit text override, no conversion performed on given capacity" )
    end

```

### removeFillUnitTrigger

**Description**

> Removes fill trigger

**Definition**

> removeFillUnitTrigger(table trigger)

**Arguments**

| table | trigger | trigger |
|-------|---------|---------|

**Code**

```lua
function FillUnit:removeFillUnitTrigger(trigger)
    local spec = self.spec_fillUnit
    table.removeElement(spec.fillTrigger.triggers, trigger)

    if self.isServer and trigger = = spec.fillTrigger.currentTrigger then
        self:setFillUnitIsFilling( false )
    end

    if #spec.fillTrigger.triggers = = 0 then
        g_currentMission.activatableObjectsSystem:removeActivatable(spec.fillTrigger.activatable)

        -- automatic filling for mobile version
            if self.isServer and Platform.gameplay.automaticFilling then
                self:setFillUnitIsFilling( false )
            end
        end

        SpecializationUtil.raiseEvent( self , "onRemovedFillUnitTrigger" , #spec.fillTrigger.triggers)

        self:updateFillUnitTriggers()
    end

```

### saveStatsToXMLFile

**Description**

**Definition**

> saveStatsToXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function FillUnit:saveStatsToXMLFile(xmlFile, key)
    local spec = self.spec_fillUnit

    local fillTypes = ''
    local fillLevels = ''
    local numFillUnits = #spec.fillUnits
    for i,fillUnit in ipairs(spec.fillUnits) do
        local fillTypeName = Utils.getNoNil(g_fillTypeManager:getFillTypeNameByIndex(fillUnit.fillType), "unknown" )
        fillTypes = fillTypes .. HTMLUtil.encodeToHTML( tostring(fillTypeName))
        fillLevels = fillLevels .. string.format( "%.3f" , fillUnit.fillLevel)
        if numFillUnits > 1 and i ~ = numFillUnits then
            fillTypes = fillTypes .. ' '
            fillLevels = fillLevels .. ' '
        end
    end

    setXMLString(xmlFile, key .. "#fillTypes" , fillTypes)
    setXMLString(xmlFile, key .. "#fillLevels" , fillLevels)
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
function FillUnit:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_fillUnit
    local i = 0
    for k, fillUnit in ipairs(spec.fillUnits) do
        if fillUnit.needsSaving then
            local fillUnitKey = string.format( "%s.unit(%d)" , key, i)
            local fillTypeName = Utils.getNoNil(g_fillTypeManager:getFillTypeNameByIndex(fillUnit.fillType), "unknown" )
            xmlFile:setValue(fillUnitKey .. "#index" , k)
            xmlFile:setValue(fillUnitKey .. "#fillType" , fillTypeName)
            xmlFile:setValue(fillUnitKey .. "#fillLevel" , fillUnit.fillLevel)
            i = i + 1
        end
    end
end

```

### setAlarmTriggerState

**Description**

**Definition**

> setAlarmTriggerState()

**Arguments**

| any | alarmTrigger |
|-----|--------------|
| any | state        |

**Code**

```lua
function FillUnit:setAlarmTriggerState(alarmTrigger, state)
    local spec = self.spec_fillUnit

    if state ~ = alarmTrigger.isActive then
        if state then
            if alarmTrigger.sample ~ = nil then
                g_soundManager:playSample(alarmTrigger.sample)
            end

            for _, beaconLight in ipairs(alarmTrigger.beaconLights) do
                beaconLight:setIsActive( true )

                if beaconLight.activeDuration ~ = 0 then
                    Timer.createOneshot(beaconLight.activeDuration, function ()
                        beaconLight:setIsActive( false )
                    end )
                end
            end

            spec.activeAlarmTriggers[alarmTrigger] = alarmTrigger
        else
                if alarmTrigger.sample ~ = nil then
                    g_soundManager:stopSample(alarmTrigger.sample)
                end

                for _, beaconLight in ipairs(alarmTrigger.beaconLights) do
                    beaconLight:setIsActive( false )
                end

                spec.activeAlarmTriggers[alarmTrigger] = nil
            end

            alarmTrigger.isActive = state
            SpecializationUtil.raiseEvent( self , "onAlarmTriggerChanged" , alarmTrigger, state)
        end
    end

```

### setFillPlaneForcedFillType

**Description**

**Definition**

> setFillPlaneForcedFillType()

**Arguments**

| any | fillUnitIndex  |
|-----|----------------|
| any | forcedFillType |

**Code**

```lua
function FillUnit:setFillPlaneForcedFillType(fillUnitIndex, forcedFillType)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        if spec.fillUnits[fillUnitIndex].fillPlane ~ = nil then
            spec.fillUnits[fillUnitIndex].fillPlane.forcedFillType = forcedFillType
        end
    end
end

```

### setFillSoundIsPlaying

**Description**

**Definition**

> setFillSoundIsPlaying()

**Arguments**

| any | isPlaying |
|-----|-----------|

**Code**

```lua
function FillUnit:setFillSoundIsPlaying(isPlaying)
    local spec = self.spec_fillUnit
    if isPlaying then
        if not g_soundManager:getIsSamplePlaying(spec.samples.fill) then
            g_soundManager:playSample(spec.samples.fill)
        end
    else
            if g_soundManager:getIsSamplePlaying(spec.samples.fill) then
                g_soundManager:stopSample(spec.samples.fill)
            end
        end
    end

```

### setFillUnitCapacity

**Description**

**Definition**

> setFillUnitCapacity()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | capacity      |
| any | noEventSend   |

**Code**

```lua
function FillUnit:setFillUnitCapacity(fillUnitIndex, capacity, noEventSend)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        if capacity ~ = spec.fillUnits[fillUnitIndex].capacity then
            spec.fillUnits[fillUnitIndex].capacity = capacity

            SetFillUnitCapacityEvent.sendEvent( self , fillUnitIndex, capacity, noEventSend)
        end
    end
end

```

### setFillUnitCapacityToDisplay

**Description**

**Definition**

> setFillUnitCapacityToDisplay()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | capacity      |

**Code**

```lua
function FillUnit:setFillUnitCapacityToDisplay(fillUnitIndex, capacity)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        spec.fillUnits[fillUnitIndex].capacityToDisplay = capacity
    end
end

```

### setFillUnitFillLevelToDisplay

**Description**

**Definition**

> setFillUnitFillLevelToDisplay()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillLevel     |
| any | isPersistent  |

**Code**

```lua
function FillUnit:setFillUnitFillLevelToDisplay(fillUnitIndex, fillLevel, isPersistent)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        spec.fillUnits[fillUnitIndex].fillLevelToDisplay = fillLevel
        spec.fillUnits[fillUnitIndex].fillLevelToDisplayIsPersistent = isPersistent ~ = nil and isPersistent
    end
end

```

### setFillUnitFillType

**Description**

**Definition**

> setFillUnitFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillTypeIndex |

**Code**

```lua
function FillUnit:setFillUnitFillType(fillUnitIndex, fillTypeIndex)
    local spec = self.spec_fillUnit
    local oldFillTypeIndex = spec.fillUnits[fillUnitIndex].fillType
    if oldFillTypeIndex ~ = fillTypeIndex then
        spec.fillUnits[fillUnitIndex].fillType = fillTypeIndex
        SpecializationUtil.raiseEvent( self , "onChangedFillType" , fillUnitIndex, fillTypeIndex, oldFillTypeIndex)
    end
end

```

### setFillUnitFillTypeToDisplay

**Description**

**Definition**

> setFillUnitFillTypeToDisplay()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillTypeIndex |
| any | isPersistent  |

**Code**

```lua
function FillUnit:setFillUnitFillTypeToDisplay(fillUnitIndex, fillTypeIndex, isPersistent)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        spec.fillUnits[fillUnitIndex].fillTypeToDisplay = fillTypeIndex
        spec.fillUnits[fillUnitIndex].fillTypeToDisplayIsPersistent = isPersistent ~ = nil and isPersistent
    end
end

```

### setFillUnitForcedMaterialFillType

**Description**

**Definition**

> setFillUnitForcedMaterialFillType()

**Arguments**

| any | fillUnitIndex          |
|-----|------------------------|
| any | forcedMaterialFillType |

**Code**

```lua
function FillUnit:setFillUnitForcedMaterialFillType(fillUnitIndex, forcedMaterialFillType)
    local spec = self.spec_fillUnit
    if spec.fillUnits[fillUnitIndex] ~ = nil then
        spec.fillUnits[fillUnitIndex].forcedMaterialFillType = forcedMaterialFillType
    end

    self:setFillPlaneForcedFillType(fillUnitIndex, forcedMaterialFillType)

    if self.setFillVolumeForcedFillTypeByFillUnitIndex ~ = nil then
        self:setFillVolumeForcedFillTypeByFillUnitIndex(fillUnitIndex, forcedMaterialFillType)
    end
end

```

### setFillUnitInTriggerRange

**Description**

**Definition**

> setFillUnitInTriggerRange()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | isInRange     |

**Code**

```lua
function FillUnit:setFillUnitInTriggerRange(fillUnitIndex, isInRange)
end

```

### setFillUnitIsFilling

**Description**

**Definition**

> setFillUnitIsFilling()

**Arguments**

| any | isFilling   |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function FillUnit:setFillUnitIsFilling(isFilling, noEventSend)
    local spec = self.spec_fillUnit
    if isFilling ~ = spec.fillTrigger.isFilling then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( SetFillUnitIsFillingEvent.new( self , isFilling), nil , nil , self )
            else
                    g_client:getServerConnection():sendEvent( SetFillUnitIsFillingEvent.new( self , isFilling))
                end
            end

            spec.fillTrigger.isFilling = isFilling

            if isFilling then
                spec.fillTrigger.currentTrigger = nil

                -- find the first trigger which is activable
                for _, trigger in ipairs(spec.fillTrigger.triggers) do
                    if trigger:getIsActivatable( self ) then
                        spec.fillTrigger.currentTrigger = trigger
                        trigger:setFillSoundIsPlaying(isFilling)
                        break
                    end
                end
            else
                    if spec.fillTrigger.currentTrigger ~ = nil then
                        spec.fillTrigger.currentTrigger:setFillSoundIsPlaying(isFilling)
                        spec.fillTrigger.currentTrigger = nil
                    end
                end

                if self.isClient then
                    self:setFillSoundIsPlaying(isFilling)
                end

                SpecializationUtil.raiseEvent( self , "onFillUnitIsFillingStateChanged" , isFilling)

                if not isFilling then
                    self:updateFillUnitTriggers()
                end
            end
        end

```

### setFillUnitLastValidFillType

**Description**

**Definition**

> setFillUnitLastValidFillType()

**Arguments**

| any | fillUnitIndex |
|-----|---------------|
| any | fillType      |
| any | force         |

**Code**

```lua
function FillUnit:setFillUnitLastValidFillType(fillUnitIndex, fillType, force)
    local spec = self.spec_fillUnit
    local fillUnit = spec.fillUnits[fillUnitIndex]
    if fillUnit ~ = nil and fillUnit.lastValidFillType ~ = fillType then
        fillUnit.lastValidFillType = fillType
        fillUnit.lastValidFillTypeSent = fillType
        self:raiseDirtyFlags(spec.dirtyFlag)
    end
end

```

### showInfo

**Description**

**Definition**

> showInfo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | box       |

**Code**

```lua
function FillUnit:showInfo(superFunc, box)
    local spec = self.spec_fillUnit

    if spec.isInfoDirty then
        spec.fillUnitInfos = { }
        local fillTypeToInfo = { }

        for _, fillUnit in ipairs(spec.fillUnits) do
            if fillUnit.showOnInfoHud and fillUnit.fillLevel > 0 then
                local info = fillTypeToInfo[fillUnit.fillType]
                if info = = nil then
                    local fillType = g_fillTypeManager:getFillTypeByIndex(fillUnit.fillType)
                    info = { title = fillType.title, fillLevel = 0 , unit = fillUnit.unitText, precision = 0 }
                    table.insert(spec.fillUnitInfos, info)
                    fillTypeToInfo[fillUnit.fillType] = info
                end

                info.fillLevel = info.fillLevel + fillUnit.fillLevel
                if info.precision = = 0 and fillUnit.fillLevel > 0 then
                    info.precision = fillUnit.uiPrecision or 0
                end
            end
        end

        spec.isInfoDirty = false
    end

    for _, info in ipairs(spec.fillUnitInfos) do
        local formattedNumber
        if info.precision > 0 then
            local rounded = MathUtil.round(info.fillLevel, info.precision)
            formattedNumber = string.format( "%d%s%0" .. info.precision .. "d" , math.floor(rounded), g_i18n.decimalSeparator, (rounded - math.floor(rounded)) * 10 ^ info.precision)
        else
                formattedNumber = string.format( "%d" , MathUtil.round(info.fillLevel))
            end

            formattedNumber = formattedNumber .. " " .. (info.unit or g_i18n:getVolumeUnit())

            box:addLine(info.title, formattedNumber)
        end

        superFunc( self , box)
    end

```

### unloadFillUnits

**Description**

**Definition**

> unloadFillUnits()

**Arguments**

| any | ignoreWarning |
|-----|---------------|

**Code**

```lua
function FillUnit:unloadFillUnits(ignoreWarning)
    if not self.isServer then
        g_client:getServerConnection():sendEvent( FillUnitUnloadEvent.new( self ))
    else
            local spec = self.spec_fillUnit
            if spec.unloadingFillUnitsRunning then
                return
            else
                    spec.unloadingFillUnitsRunning = true
                end

                local unloadingPlaces = spec.unloading

                local places = { }

                for _, unloading in ipairs(unloadingPlaces) do
                    local node = unloading.node
                    local ox, oy, oz = unpack(unloading.offset)
                    local x, y, z = localToWorld(node, ox - unloading.width * 0.5 , oy, oz)

                    local place = { }
                    place.startX, place.startY, place.startZ = x, y, z
                    place.rotX, place.rotY, place.rotZ = getWorldRotation(node)
                    place.dirX, place.dirY, place.dirZ = localDirectionToWorld(node, 1 , 0 , 0 )
                    place.dirPerpX, place.dirPerpY, place.dirPerpZ = localDirectionToWorld(node, 0 , 0 , 1 )
                    place.yOffset = 1
                    place.maxWidth = math.huge
                    place.maxLength = math.huge
                    place.maxHeight = math.huge
                    place.width = unloading.width

                    table.insert(places, place)
                end

                local usedPlaces = { }

                local availablePallets = { }

                local unloadingTasks = self:getFillUnitUnloadingTasks()

                if self:getFillUnitHasMountedPalletsToUnload() then
                    local pallets = self:getFillUnitMountedPalletsToUnload()
                    if pallets ~ = nil and #pallets > 0 then
                        for i, pallet in ipairs(pallets) do
                            local x, y, z, place, width, _ = PlacementUtil.getPlace(places, pallet.size, usedPlaces, true , true , false , true )
                            if x ~ = nil then
                                if pallet.unmount ~ = nil then
                                    pallet:unmount( true )
                                end

                                PlacementUtil.markPlaceUsed(usedPlaces, place, width)

                                local rotY = MathUtil.getYRotationFromDirection(place.dirPerpX, place.dirPerpZ)
                                pallet:setAbsolutePosition(x, y, z, 0 , rotY, 0 )

                                SpecializationUtil.raiseEvent( self , "onFillUnitUnloadPallet" , pallet)

                                g_server:broadcastEvent( FillUnitUnloadedEvent.new( self , pallet), false , nil , self )
                            else
                                    if ignoreWarning = = nil or not ignoreWarning then
                                        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, spec.texts.unloadNoSpace)
                                    end

                                    g_server:broadcastEvent( FillUnitUnloadedEvent.new( self , nil , true ), false , nil , self )
                                end
                            end
                        end
                    end

                    local function unloadNext()
                        local task = unloadingTasks[ 1 ]
                        if task ~ = nil then
                            -- try to fill existing pallets
                            for pallet, _ in pairs(availablePallets) do
                                local fillUnitIndex = pallet:getFirstValidFillUnitToFill(task.fillTypeIndex)
                                if fillUnitIndex ~ = nil then
                                    local appliedDelta = pallet:addFillUnitFillLevel( self:getOwnerFarmId(), fillUnitIndex, task.fillLevel, task.fillTypeIndex, ToolType.UNDEFINED, nil )
                                    self:addFillUnitFillLevel( self:getOwnerFarmId(), task.fillUnitIndex, - appliedDelta, task.fillTypeIndex, ToolType.UNDEFINED, nil )
                                    task.fillLevel = task.fillLevel - appliedDelta

                                    -- remove filled pallets
                                    if pallet:getFillUnitFreeCapacity(fillUnitIndex) < = 0 then
                                        availablePallets[pallet] = nil
                                    end
                                end
                            end

                            if task.fillLevel > 0.01 then
                                local asyncCallback = function (_, vehicles, vehicleLoadState, arguments)
                                    if vehicleLoadState = = VehicleLoadingState.OK then
                                        for _, vehicle in ipairs(vehicles) do
                                            vehicle:emptyAllFillUnits( true )
                                            availablePallets[vehicle] = true

                                            SpecializationUtil.raiseEvent( self , "onFillUnitUnloadPallet" , vehicle)
                                        end

                                        unloadNext()
                                    elseif vehicleLoadState = = VehicleLoadingState.NO_SPACE then
                                            if ignoreWarning = = nil or not ignoreWarning then
                                                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, spec.texts.unloadNoSpace)
                                            end

                                            SpecializationUtil.raiseEvent( self , "onFillUnitUnloaded" , false )
                                            g_server:broadcastEvent( FillUnitUnloadedEvent.new( self , nil , true , false ), false , nil , self )
                                            spec.unloadingFillUnitsRunning = false
                                        end
                                    end

                                    local data = VehicleLoadingData.new()
                                    data:setFilename(task.filename)
                                    data:setLoadingPlace(places, usedPlaces, 0.5 , true )
                                    data:setPropertyState(VehiclePropertyState.OWNED)
                                    data:setOwnerFarmId( self:getOwnerFarmId())

                                    data:load(asyncCallback)
                                else
                                        table.remove(unloadingTasks, 1 )
                                        unloadNext()
                                    end
                                else
                                        SpecializationUtil.raiseEvent( self , "onFillUnitUnloaded" , true )
                                        g_server:broadcastEvent( FillUnitUnloadedEvent.new( self , nil , false , true ), false , nil , self )
                                        spec.unloadingFillUnitsRunning = false
                                    end
                                end

                                unloadNext()
                            end
                        end

```

### updateAlarmTriggers

**Description**

**Definition**

> updateAlarmTriggers()

**Arguments**

| any | alarmTriggers |
|-----|---------------|

**Code**

```lua
function FillUnit:updateAlarmTriggers(alarmTriggers)
    for _, alarmTrigger in pairs(alarmTriggers) do
        self:setAlarmTriggerState(alarmTrigger, self:getAlarmTriggerIsActive(alarmTrigger))
    end
end

```

### updateFillTypeMaterials

**Description**

**Definition**

> updateFillTypeMaterials()

**Arguments**

| any | fillTypeMaterials |
|-----|-------------------|
| any | fillTypeIndex     |

**Code**

```lua
function FillUnit:updateFillTypeMaterials(fillTypeMaterials, fillTypeIndex)
    for i = 1 , #fillTypeMaterials do
        local fillTypeMaterial = fillTypeMaterials[i]
        if fillTypeMaterial.fillTypeIndex = = fillTypeIndex then
            if fillTypeMaterial.refNode ~ = nil then
                local materialId = getMaterial(fillTypeMaterial.refNode, 0 )
                setMaterial(fillTypeMaterial.node, materialId, 0 )
            elseif fillTypeMaterial.materialId ~ = nil then
                    local newMaterialId = setMaterialDiffuseMapFromFile(fillTypeMaterial.materialId, fillTypeMaterial.diffuse, true , true , false )

                    MaterialUtil.replaceMaterialRec( self.rootNode, fillTypeMaterial.materialId, newMaterialId)

                    fillTypeMaterial.materialId = newMaterialId
                end
            end
        end
    end

```

### updateFillUnitAutoAimTarget

**Description**

**Definition**

> updateFillUnitAutoAimTarget()

**Arguments**

| any | fillUnit |
|-----|----------|

**Code**

```lua
function FillUnit:updateFillUnitAutoAimTarget(fillUnit)
    local autoAimTarget = fillUnit.autoAimTarget
    if autoAimTarget.node ~ = nil then
        if autoAimTarget.startZ ~ = nil and autoAimTarget.endZ ~ = nil then
            local startFillLevel = fillUnit.capacity * autoAimTarget.startPercentage
            local percent = math.clamp((fillUnit.fillLevel - startFillLevel) / (fillUnit.capacity - startFillLevel), 0 , 1 )
            if autoAimTarget.invert then
                percent = 1 - percent
            end
            local newZ = (autoAimTarget.endZ - autoAimTarget.startZ) * percent + autoAimTarget.startZ
            setTranslation(autoAimTarget.node, autoAimTarget.baseTrans[ 1 ], autoAimTarget.baseTrans[ 2 ], newZ)
        end
    end
end

```

### updateFillUnitFillPlane

**Description**

**Definition**

> updateFillUnitFillPlane()

**Arguments**

| any | fillUnit |
|-----|----------|

**Code**

```lua
function FillUnit:updateFillUnitFillPlane(fillUnit)
    local fillPlane = fillUnit.fillPlane
    if fillPlane ~ = nil then
        local t = self:getFillUnitFillLevelPercentage(fillUnit.fillUnitIndex)

        for _, node in ipairs(fillPlane.nodes) do
            local x,y,z, rx,ry,rz, sx,sy,sz = node.animCurve:get(t)

            setTranslation(node.node, x, y, z)
            setRotation(node.node, rx, ry, rz)
            setScale(node.node, sx, sy, sz)
            setVisibility(node.node, fillUnit.fillLevel > 0 or node.alwaysVisible)
        end

        if fillUnit.fillType ~ = fillUnit.lastFillPlaneType then
            local textureArrayIndex = g_fillTypeManager:getTextureArrayIndexByFillTypeIndex(fillUnit.fillType)
            if textureArrayIndex ~ = nil then
                for _, node in ipairs(fillPlane.nodes) do
                    setShaderParameter(node.node, "fillTypeId" , textureArrayIndex - 1 , 0 , 0 , 0 , false )
                end
            end
        end
    end
end

```

### updateFillUnitTriggers

**Description**

**Definition**

> updateFillUnitTriggers()

**Code**

```lua
function FillUnit:updateFillUnitTriggers()
    local spec = self.spec_fillUnit

    table.sort(spec.fillTrigger.triggers, function (t1, t2)
        local fillTypeIndex1 = t1:getCurrentFillType()
        local fillTypeIndex2 = t2:getCurrentFillType()

        local t1FillUnitIndex = self:getFirstValidFillUnitToFill(fillTypeIndex1)
        local t2FillUnitIndex = self:getFirstValidFillUnitToFill(fillTypeIndex2)

        if t1FillUnitIndex ~ = nil and t2FillUnitIndex ~ = nil then
            return self:getFillUnitFillLevel(t1FillUnitIndex) > self:getFillUnitFillLevel(t2FillUnitIndex)
        elseif t1FillUnitIndex ~ = nil then
                return true
            end

            return false
        end )

        if #spec.fillTrigger.triggers > 0 then
            local fillTypeIndex = spec.fillTrigger.triggers[ 1 ]:getCurrentFillType()
            spec.fillTrigger.activatable:setFillType(fillTypeIndex)

            if spec.fillTrigger.selectedTrigger ~ = spec.fillTrigger.triggers[ 1 ] then
                SpecializationUtil.raiseEvent( self , "onFillUnitTriggerChanged" , spec.fillTrigger.triggers[ 1 ], fillTypeIndex, self:getFirstValidFillUnitToFill(fillTypeIndex), #spec.fillTrigger.triggers)

                spec.fillTrigger.selectedTrigger = spec.fillTrigger.triggers[ 1 ]
            end
        else
                spec.fillTrigger.selectedTrigger = nil
            end
        end

```

### updateMeasurementNodes

**Description**

**Definition**

> updateMeasurementNodes()

**Arguments**

| any | fillUnit        |
|-----|-----------------|
| any | dt              |
| any | setActive       |
| any | forcedIntensity |

**Code**

```lua
function FillUnit:updateMeasurementNodes(fillUnit, dt, setActive, forcedIntensity)
    if fillUnit.measurementNodes ~ = nil then
        for _, measurementNode in pairs(fillUnit.measurementNodes) do
            if setActive ~ = nil and setActive then
                measurementNode.measurementTime = 5000
            end

            if measurementNode.measurementTime > 0 then
                measurementNode.measurementTime = math.max(measurementNode.measurementTime - dt, 0 )
            end

            local intensity = math.min(measurementNode.measurementTime / 5000 , 1 )
            intensity = math.max(intensity, math.min( self.lastSpeed * 3600 / 10 , 1 ))
            intensity = forcedIntensity or intensity
            if intensity ~ = measurementNode.intensity then
                setShaderParameter(measurementNode.node, "fillLevel" , fillUnit.fillLevel / fillUnit.capacity, intensity, 0 , 0 , false )
                setShaderParameter(measurementNode.node, "prevFillLevel" , fillUnit.fillLevel / fillUnit.capacity, measurementNode.intensity, 0 , 0 , false )
                measurementNode.intensity = intensity
            end
        end
    end
end

```

### updateUnloadActionDisplay

**Description**

**Definition**

> updateUnloadActionDisplay()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function FillUnit.updateUnloadActionDisplay( self )
    local spec = self.spec_fillUnit
    if spec ~ = nil and spec.unloading ~ = nil then
        local isActive = false
        for fillUnitIndex, fillUnit in ipairs( self:getFillUnits()) do
            if fillUnit.canBeUnloaded and self:getFillUnitFillLevel(fillUnitIndex) > 0 then
                if self:getFillUnitUnloadPalletFilename(fillUnitIndex) ~ = nil then
                    isActive = true
                    break
                end
            end
        end

        if self:getFillUnitHasMountedPalletsToUnload() then
            isActive = true
        end

        if self.getCurrentDischargeNode ~ = nil then
            local dischargeNode = self:getCurrentDischargeNode()
            if dischargeNode ~ = nil then
                local dischargeObject, _ = self:getDischargeTargetObject(dischargeNode)
                if dischargeObject ~ = nil then
                    isActive = false
                end
            end
        end

        g_inputBinding:setActionEventActive(spec.unloadActionEventId, isActive)
    end
end

```