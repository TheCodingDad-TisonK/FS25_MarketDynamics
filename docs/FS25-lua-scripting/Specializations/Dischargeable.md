## Dischargeable

**Description**

> Specialization for discharging fillables from a vehicle

**Functions**

- [actionEventToggleDischargeToGround](#actioneventtoggledischargetoground)
- [actionEventToggleDischarging](#actioneventtoggledischarging)
- [dashboardDischargeAttributes](#dashboarddischargeattributes)
- [discharge](#discharge)
- [dischargeActivationTriggerCallback](#dischargeactivationtriggercallback)
- [dischargeToGround](#dischargetoground)
- [dischargeToObject](#dischargetoobject)
- [dischargeTriggerCallback](#dischargetriggercallback)
- [finishDischargeRaycast](#finishdischargeraycast)
- [getAllowLoadTriggerActivation](#getallowloadtriggeractivation)
- [getCanBeSelected](#getcanbeselected)
- [getCanDischargeAtPosition](#getcandischargeatposition)
- [getCanDischargeToGround](#getcandischargetoground)
- [getCanDischargeToLand](#getcandischargetoland)
- [getCanDischargeToObject](#getcandischargetoobject)
- [getCanToggleDischargeToGround](#getcantoggledischargetoground)
- [getCanToggleDischargeToObject](#getcantoggledischargetoobject)
- [getCurrentDischargeNode](#getcurrentdischargenode)
- [getCurrentDischargeNodeIndex](#getcurrentdischargenodeindex)
- [getCurrentDischargeObject](#getcurrentdischargeobject)
- [getDischargeFillType](#getdischargefilltype)
- [getDischargeNodeAutomaticDischarge](#getdischargenodeautomaticdischarge)
- [getDischargeNodeByIndex](#getdischargenodebyindex)
- [getDischargeNodeByNode](#getdischargenodebynode)
- [getDischargeNodeEmptyFactor](#getdischargenodeemptyfactor)
- [getDischargeNotAllowedWarning](#getdischargenotallowedwarning)
- [getDischargeState](#getdischargestate)
- [getDischargeTargetObject](#getdischargetargetobject)
- [getDoConsumePtoPower](#getdoconsumeptopower)
- [getIsDischargeNodeActive](#getisdischargenodeactive)
- [getIsPowerTakeOffActive](#getispowertakeoffactive)
- [getRequiresTipOcclusionArea](#getrequirestipocclusionarea)
- [handleDischarge](#handledischarge)
- [handleDischargeNodeChanged](#handledischargenodechanged)
- [handleDischargeOnEmpty](#handledischargeonempty)
- [handleDischargeRaycast](#handledischargeraycast)
- [handleFoundDischargeObject](#handlefounddischargeobject)
- [initSpecialization](#initspecialization)
- [loadDischargeNode](#loaddischargenode)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onDeleteActivationTriggerObject](#ondeleteactivationtriggerobject)
- [onDeleteDischargeTriggerObject](#ondeletedischargetriggerobject)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterDashboardValueTypes](#onregisterdashboardvaluetypes)
- [onStateChange](#onstatechange)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [raycastCallbackDischargeNode](#raycastcallbackdischargenode)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setCurrentDischargeNodeIndex](#setcurrentdischargenodeindex)
- [setDischargeEffectActive](#setdischargeeffectactive)
- [setDischargeEffectDistance](#setdischargeeffectdistance)
- [setDischargeState](#setdischargestate)
- [setForcedFillTypeIndex](#setforcedfilltypeindex)
- [setManualDischargeState](#setmanualdischargestate)
- [updateActionEvents](#updateactionevents)
- [updateDebugValues](#updatedebugvalues)
- [updateDischargeInfo](#updatedischargeinfo)
- [updateDischargeSound](#updatedischargesound)
- [updateRaycast](#updateraycast)

### actionEventToggleDischargeToGround

**Description**

**Definition**

> actionEventToggleDischargeToGround()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Dischargeable.actionEventToggleDischargeToGround( self , actionName, inputValue, callbackState, isAnalog)
    if self:getCanToggleDischargeToGround() then
        local spec = self.spec_dischargeable
        local currentDischargeNode = spec.currentDischargeNode
        if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OFF then
            if self:getCanDischargeToGround(currentDischargeNode) then
                if self:getCanDischargeToLand(currentDischargeNode) then
                    if self:getCanDischargeAtPosition(currentDischargeNode) then
                        self:setManualDischargeState( Dischargeable.DISCHARGE_STATE_GROUND)
                    else
                            g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_actionNotAllowedHere" ), 5000 )
                        end
                    else
                            g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_youDontHaveAccessToThisLand" ), 5000 )
                        end
                    end
                else
                        self:setManualDischargeState( Dischargeable.DISCHARGE_STATE_OFF)
                    end
                end
            end

```

### actionEventToggleDischarging

**Description**

**Definition**

> actionEventToggleDischarging()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Dischargeable.actionEventToggleDischarging( self , actionName, inputValue, callbackState, isAnalog)
    if self:getCanToggleDischargeToObject() then
        local spec = self.spec_dischargeable
        local currentDischargeNode = spec.currentDischargeNode

        if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OFF then
            if self:getCanDischargeToObject(currentDischargeNode) then
                self:setManualDischargeState( Dischargeable.DISCHARGE_STATE_OBJECT)
            elseif currentDischargeNode.dischargeHit then
                    if self:getDischargeFillType(currentDischargeNode) ~ = FillType.UNKNOWN then
                        local warning = self:getDischargeNotAllowedWarning(currentDischargeNode)
                        g_currentMission:showBlinkingWarning(warning, 5000 )
                    end
                end
            else
                    self:setManualDischargeState( Dischargeable.DISCHARGE_STATE_OFF)
                end
            end
        end

```

### dashboardDischargeAttributes

**Description**

**Definition**

> dashboardDischargeAttributes()

**Arguments**

| any | self      |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | dashboard |
| any | isActive  |

**Code**

```lua
function Dischargeable.dashboardDischargeAttributes( self , xmlFile, key, dashboard, isActive)
    dashboard.dischargeNodeIndex = xmlFile:getValue(key .. "#dischargeNodeIndex" )
    return true
end

```

### discharge

**Description**

**Definition**

> discharge()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | emptyLiters   |

**Code**

```lua
function Dischargeable:discharge(dischargeNode, emptyLiters)
    local spec = self.spec_dischargeable
    local dischargedLiters = 0
    local minDropReached = true
    local hasMinDropFillLevel = true
    local object, fillUnitIndex = self:getDischargeTargetObject(dischargeNode)

    dischargeNode.currentDischargeObject = nil

    if object ~ = nil then
        if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OBJECT then
            dischargedLiters = self:dischargeToObject(dischargeNode, emptyLiters, object, fillUnitIndex)
        end
    elseif dischargeNode.dischargeHitTerrain then
            if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_GROUND then
                dischargedLiters, minDropReached, hasMinDropFillLevel = self:dischargeToGround(dischargeNode, emptyLiters)
            end
        end

        return dischargedLiters, minDropReached, hasMinDropFillLevel
    end

```

### dischargeActivationTriggerCallback

**Description**

**Definition**

> dischargeActivationTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function Dischargeable:dischargeActivationTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_dischargeable
    if onEnter or onLeave then
        local object = g_currentMission:getNodeObject(otherActorId)
        if object ~ = nil and object ~ = self then
            if object.getFillUnitIndexFromNode ~ = nil then
                local fillUnitIndex = object:getFillUnitIndexFromNode(otherShapeId)
                local dischargeNode = spec.activationTriggerToDischargeNode[triggerId]

                if dischargeNode ~ = nil and fillUnitIndex ~ = nil then
                    local trigger = dischargeNode.activationTrigger
                    if onEnter then
                        if trigger.objects[object] = = nil then
                            trigger.objects[object] = { count = 0 , fillUnitIndex = fillUnitIndex, shape = otherShapeId }
                            trigger.numObjects = trigger.numObjects + 1

                            object:addDeleteListener( self , "onDeleteActivationTriggerObject" )
                        end
                        trigger.objects[object].count = trigger.objects[object].count + 1

                        self:raiseActive()
                    elseif onLeave then
                            trigger.objects[object].count = trigger.objects[object].count - 1
                            if trigger.objects[object].count = = 0 then
                                trigger.objects[object] = nil
                                trigger.numObjects = trigger.numObjects - 1

                                object:removeDeleteListener( self , "onDeleteActivationTriggerObject" )
                            end
                        end
                    end
                end
            end
        end
    end

```

### dischargeToGround

**Description**

**Definition**

> dischargeToGround()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | emptyLiters   |

**Code**

```lua
function Dischargeable:dischargeToGround(dischargeNode, emptyLiters)
    if emptyLiters = = 0 then
        return 0 , false , false
    end

    local fillType, factor = self:getDischargeFillType(dischargeNode)
    local fillLevel = self:getFillUnitFillLevel(dischargeNode.fillUnitIndex)
    local minLiterToDrop = g_densityMapHeightManager:getMinValidLiterValue(fillType)

    dischargeNode.litersToDrop = math.min(dischargeNode.litersToDrop + emptyLiters, math.max(dischargeNode.emptySpeed * 250 , minLiterToDrop))

    -- do not tip more than we have if defined via xml
        -- has the side effect that the fill unit never goes completely empty
        if dischargeNode.limitGroundTipToFillLevel then
            dischargeNode.litersToDrop = math.min(dischargeNode.litersToDrop, fillLevel)
        end

        local minDropReached = dischargeNode.litersToDrop > minLiterToDrop
        local hasMinDropFillLevel = fillLevel > minLiterToDrop
        local info = dischargeNode.info
        local dischargedLiters = 0
        local sx,sy,sz = localToWorld(info.node, - info.width, 0 , info.zOffset)
        local ex,ey,ez = localToWorld(info.node, info.width, 0 , info.zOffset)

        sy = sy + info.yOffset
        ey = ey + info.yOffset

        if info.limitToGround then
            sy = math.max(getTerrainHeightAtWorldPos(g_terrainNode, sx, 0 , sz) + 0.1 , sy)
            ey = math.max(getTerrainHeightAtWorldPos(g_terrainNode, ex, 0 , ez) + 0.1 , ey)
        end

        local dropped, lineOffset = DensityMapHeightUtil.tipToGroundAroundLine( self , dischargeNode.litersToDrop * factor, fillType, sx,sy,sz, ex,ey,ez, info.length, nil , dischargeNode.lineOffset, true , nil , true )
        dropped = dropped / factor
        dischargeNode.lineOffset = lineOffset
        dischargeNode.litersToDrop = dischargeNode.litersToDrop - dropped

        if dropped > 0 then
            local unloadInfo = self:getFillVolumeUnloadInfo(dischargeNode.unloadInfoIndex)
            dischargedLiters = self:addFillUnitFillLevel( self:getOwnerFarmId(), dischargeNode.fillUnitIndex, - dropped, self:getFillUnitFillType(dischargeNode.fillUnitIndex), ToolType.UNDEFINED, unloadInfo)
        end

        fillLevel = self:getFillUnitFillLevel(dischargeNode.fillUnitIndex)
        if fillLevel > 0 and fillLevel < = minLiterToDrop then
            dischargeNode.litersToDrop = minLiterToDrop
        end

        return dischargedLiters, minDropReached, hasMinDropFillLevel
    end

```

### dischargeToObject

**Description**

**Definition**

> dischargeToObject()

**Arguments**

| any | dischargeNode       |
|-----|---------------------|
| any | emptyLiters         |
| any | object              |
| any | targetFillUnitIndex |

**Code**

```lua
function Dischargeable:dischargeToObject(dischargeNode, emptyLiters, object, targetFillUnitIndex)
    local fillType, factor = self:getDischargeFillType(dischargeNode)
    local supportsFillType = object:getFillUnitSupportsFillType(targetFillUnitIndex, fillType)
    local dischargedLiters = 0

    if supportsFillType then
        local allowFillType = object:getFillUnitAllowsFillType(targetFillUnitIndex, fillType)
        if allowFillType then
            dischargeNode.currentDischargeObject = object

            local delta = object:addFillUnitFillLevel( self:getActiveFarm(), targetFillUnitIndex, emptyLiters * factor, fillType, dischargeNode.toolType, dischargeNode.info)
            delta = delta / factor
            local unloadInfo = self:getFillVolumeUnloadInfo(dischargeNode.unloadInfoIndex)

            dischargedLiters = self:addFillUnitFillLevel( self:getOwnerFarmId(), dischargeNode.fillUnitIndex, - delta, self:getFillUnitFillType(dischargeNode.fillUnitIndex), ToolType.UNDEFINED, unloadInfo)
        end
    end

    return dischargedLiters
end

```

### dischargeTriggerCallback

**Description**

**Definition**

> dischargeTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function Dischargeable:dischargeTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_dischargeable
    if onEnter or onLeave then
        local object = g_currentMission:getNodeObject(otherActorId)
        if object ~ = nil and object ~ = self then
            if object.getFillUnitIndexFromNode ~ = nil then
                local fillUnitIndex = object:getFillUnitIndexFromNode(otherShapeId)
                local dischargeNode = spec.triggerToDischargeNode[triggerId]

                local validObject = fillUnitIndex ~ = nil
                if not dischargeNode.canDischargeToVehicle then
                    validObject = validObject and not object:isa( Vehicle )
                end

                if dischargeNode ~ = nil and validObject then
                    local trigger = dischargeNode.trigger
                    if onEnter then
                        if trigger.objects[object] = = nil then
                            trigger.objects[object] = { count = 0 , fillUnitIndex = fillUnitIndex, shape = otherShapeId }
                            trigger.numObjects = trigger.numObjects + 1

                            object:addDeleteListener( self , "onDeleteDischargeTriggerObject" )
                        end
                        trigger.objects[object].count = trigger.objects[object].count + 1
                        self:raiseActive()
                    elseif onLeave then
                            trigger.objects[object].count = trigger.objects[object].count - 1
                            if trigger.objects[object].count = = 0 then
                                trigger.objects[object] = nil
                                trigger.numObjects = trigger.numObjects - 1

                                if object = = dischargeNode.dischargeObject then
                                    dischargeNode.dischargeObject = nil
                                    dischargeNode.dischargeHitTerrain = false
                                    dischargeNode.dischargeShape = nil
                                    dischargeNode.dischargeDistance = 0
                                    dischargeNode.dischargeFillUnitIndex = nil
                                end

                                object:removeDeleteListener( self , "onDeleteDischargeTriggerObject" )
                            end
                        end
                    end
                end
            end
        end
    end

```

### finishDischargeRaycast

**Description**

**Definition**

> finishDischargeRaycast()

**Code**

```lua
function Dischargeable:finishDischargeRaycast()
    local spec = self.spec_dischargeable

    local dischargeNode = spec.currentRaycastDischargeNode

    dischargeNode.dischargeObject = dischargeNode.raycastDischargeObject
    dischargeNode.dischargeHitObject = dischargeNode.raycastDischargeHitObject
    dischargeNode.dischargeHitObjectUnitIndex = dischargeNode.raycastDischargeHitObjectUnitIndex
    dischargeNode.dischargeHitTerrain = dischargeNode.raycastDischargeHitTerrain
    dischargeNode.dischargeShape = dischargeNode.raycastDischargeShape
    dischargeNode.dischargeDistance = dischargeNode.raycastDischargeDistance
    dischargeNode.dischargeFillUnitIndex = dischargeNode.raycastDischargeFillUnitIndex
    dischargeNode.dischargeHit = dischargeNode.raycastDischargeHit
    dischargeNode.dischargeFailedReason = dischargeNode.raycastDischargeFailedReason

    self:handleDischargeRaycast(dischargeNode, dischargeNode.dischargeObject, dischargeNode.dischargeShape, dischargeNode.dischargeDistance, dischargeNode.dischargeFillUnitIndex, dischargeNode.dischargeHitTerrain)
    spec.isAsyncRaycastActive = false

    if dischargeNode.lastDischargeObject ~ = dischargeNode.dischargeObject then
        SpecializationUtil.raiseEvent( self , "onDischargeTargetObjectChanged" , dischargeNode.dischargeObject)
        self.rootVehicle:raiseActive()
    end
end

```

### getAllowLoadTriggerActivation

**Description**

**Definition**

> getAllowLoadTriggerActivation()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | rootVehicle |

**Code**

```lua
function Dischargeable:getAllowLoadTriggerActivation(superFunc, rootVehicle)
    if superFunc( self , rootVehicle) then
        return true
    end

    local spec = self.spec_dischargeable
    if spec.currentDischargeNode ~ = nil then
        local object = spec.currentDischargeNode.dischargeHitObject
        if object ~ = nil and object.getAllowLoadTriggerActivation ~ = nil then
            -- if we start to hit ourself again we break to avoid the endless looping
                if object = = rootVehicle then
                    return false
                end

                return object:getAllowLoadTriggerActivation(rootVehicle)
            end
        end

        return false
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
function Dischargeable:getCanBeSelected(superFunc)
    return true
end

```

### getCanDischargeAtPosition

**Description**

**Definition**

> getCanDischargeAtPosition()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getCanDischargeAtPosition(dischargeNode)
    if dischargeNode = = nil then
        return false
    end

    --#profile RemoteProfiler.zoneBeginN("Dischargeable:getCanDischargeAtPosition")
    if self:getFillUnitFillLevel(dischargeNode.fillUnitIndex) > 0 then
        local info = dischargeNode.info
        local sx,sy,sz = localToWorld(info.node, - info.width, 0 , info.zOffset)
        local ex,ey,ez = localToWorld(info.node, info.width, 0 , info.zOffset)

        -- check if at the ground position is still space for some more
            -- check this only if we wan't to discharge to the ground(farmland check is also done while discharging to objects)
                local spec = self.spec_dischargeable
                if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OFF or spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_GROUND then
                    sy = sy + info.yOffset
                    ey = ey + info.yOffset

                    if info.limitToGround then
                        sy = math.max(getTerrainHeightAtWorldPos(g_terrainNode, sx, 0 , sz) + 0.1 , sy)
                        ey = math.max(getTerrainHeightAtWorldPos(g_terrainNode, ex, 0 , ez) + 0.1 , ey)
                    end

                    local fillType = self:getDischargeFillType(dischargeNode)
                    local testDrop = g_densityMapHeightManager:getMinValidLiterValue(fillType)
                    if not DensityMapHeightUtil.getCanTipToGroundAroundLine( self , testDrop, fillType, sx,sy,sz, ex,ey,ez, info.length, nil , dischargeNode.lineOffset, true , nil , true ) then
                        --#profile RemoteProfiler.zoneEnd()
                        return false
                    end
                end
            end
            --#profile RemoteProfiler.zoneEnd()

            return true
        end

```

### getCanDischargeToGround

**Description**

**Definition**

> getCanDischargeToGround()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getCanDischargeToGround(dischargeNode)
    if not self.spec_dischargeable.isDischargeAllowed then
        return false
    end

    if dischargeNode = = nil then
        return false
    end

    if not dischargeNode.dischargeHitTerrain then
        return false
    end

    if self:getFillUnitFillLevel(dischargeNode.fillUnitIndex) > 0 then
        local fillTypeIndex = self:getDischargeFillType(dischargeNode)
        if not DensityMapHeightUtil.getCanTipToGround(fillTypeIndex) then
            return false
        end
    end

    return true
end

```

### getCanDischargeToLand

**Description**

**Definition**

> getCanDischargeToLand()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getCanDischargeToLand(dischargeNode)
    if dischargeNode = = nil then
        return false
    end

    if dischargeNode.canDischargeToGroundAnywhere then
        return true
    end

    local info = dischargeNode.info
    local sx,_,sz = localToWorld(info.node, - info.width, 0 , info.zOffset)
    local ex,_,ez = localToWorld(info.node, info.width, 0 , info.zOffset)
    local activeFarmId = self:getActiveFarm()

    if dischargeNode.canDischargeToMissionGround then
        local mission = g_missionManager:getMissionAtWorldPosition(sx, sz)
        if mission = = nil then
            mission = g_missionManager:getMissionAtWorldPosition(ex, ez)
        end

        if mission ~ = nil and mission.farmId ~ = nil and mission.farmId = = activeFarmId then
            return true
        end
    end

    -- is start owned
    if not g_currentMission.accessHandler:canFarmAccessLand(activeFarmId, sx, sz) then
        return false
    end

    -- is end owned
    if not g_currentMission.accessHandler:canFarmAccessLand(activeFarmId, ex, ez) then
        return false
    end

    return true
end

```

### getCanDischargeToObject

**Description**

**Definition**

> getCanDischargeToObject()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getCanDischargeToObject(dischargeNode)
    if not self.spec_dischargeable.isDischargeAllowed then
        return false
    end

    if dischargeNode = = nil then
        return false
    end

    local object = dischargeNode.dischargeObject
    if object = = nil then
        return false
    end

    local fillType = self:getDischargeFillType(dischargeNode)

    if not object:getFillUnitSupportsFillType(dischargeNode.dischargeFillUnitIndex, fillType) then
        return false
    end

    local allowFillType = object:getFillUnitAllowsFillType(dischargeNode.dischargeFillUnitIndex, fillType)
    if not allowFillType then
        return false
    end

    if object.getFillUnitFreeCapacity ~ = nil and object:getFillUnitFreeCapacity(dischargeNode.dischargeFillUnitIndex, fillType, self:getActiveFarm()) < = 0 then
        return false
    end

    if object.getIsFillAllowedFromFarm ~ = nil and not object:getIsFillAllowedFromFarm( self:getActiveFarm()) then
        return false
    end

    -- Adding should only be done if removing is allowed(generally adding is always allowed because it is beneficial to the receiver)
        -- A case where this is not allowed is when this is a pallet where the the controller does not own it(or can access it)
        if self.getDynamicMountObject ~ = nil then
            local mounter = self:getDynamicMountObject()
            if mounter ~ = nil then
                -- if the active farm of the mounter has NO access to farmId fill unit:disallow
                    if not g_currentMission.accessHandler:canFarmAccess(mounter:getActiveFarm(), self , true ) then
                        return false
                    end
                end
            end

            return true
        end

```

### getCanToggleDischargeToGround

**Description**

**Definition**

> getCanToggleDischargeToGround()

**Code**

```lua
function Dischargeable:getCanToggleDischargeToGround()
    local spec = self.spec_dischargeable
    local dischargeNode = spec.currentDischargeNode

    return dischargeNode ~ = nil and dischargeNode.canDischargeToGround and not dischargeNode.canStartGroundDischargeAutomatically
end

```

### getCanToggleDischargeToObject

**Description**

**Definition**

> getCanToggleDischargeToObject()

**Code**

```lua
function Dischargeable:getCanToggleDischargeToObject()
    local spec = self.spec_dischargeable
    local dischargeNode = spec.currentDischargeNode

    return dischargeNode ~ = nil and dischargeNode.canDischargeToObject
end

```

### getCurrentDischargeNode

**Description**

**Definition**

> getCurrentDischargeNode()

**Code**

```lua
function Dischargeable:getCurrentDischargeNode()
    local spec = self.spec_dischargeable
    return spec.currentDischargeNode
end

```

### getCurrentDischargeNodeIndex

**Description**

**Definition**

> getCurrentDischargeNodeIndex()

**Code**

```lua
function Dischargeable:getCurrentDischargeNodeIndex()
    local spec = self.spec_dischargeable
    if spec.currentDischargeNode ~ = nil then
        return spec.currentDischargeNode.index
    end

    return 0
end

```

### getCurrentDischargeObject

**Description**

> Object being discharged to

**Definition**

> getCurrentDischargeObject()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getCurrentDischargeObject(dischargeNode)
    return dischargeNode.currentDischargeObject
end

```

### getDischargeFillType

**Description**

**Definition**

> getDischargeFillType()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getDischargeFillType(dischargeNode)
    local fillType = self:getFillUnitFillType(dischargeNode.fillUnitIndex)
    local conversionFactor = 1

    if dischargeNode.fillTypeConverter ~ = nil then
        local conversion = dischargeNode.fillTypeConverter[fillType]
        if conversion ~ = nil then
            fillType = conversion.targetFillTypeIndex
            conversionFactor = conversion.conversionFactor
        end
    end

    return fillType, conversionFactor
end

```

### getDischargeNodeAutomaticDischarge

**Description**

**Definition**

> getDischargeNodeAutomaticDischarge()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getDischargeNodeAutomaticDischarge(dischargeNode)
    return dischargeNode.canStartDischargeAutomatically
end

```

### getDischargeNodeByIndex

**Description**

**Definition**

> getDischargeNodeByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function Dischargeable:getDischargeNodeByIndex(index)
    local spec = self.spec_dischargeable
    return spec.dischargeNodes[index]
end

```

### getDischargeNodeByNode

**Description**

**Definition**

> getDischargeNodeByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Dischargeable:getDischargeNodeByNode(node)
    return self.spec_dischargeable.dischargNodeMapping[node]
end

```

### getDischargeNodeEmptyFactor

**Description**

**Definition**

> getDischargeNodeEmptyFactor()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getDischargeNodeEmptyFactor(dischargeNode)
    return 1.0
end

```

### getDischargeNotAllowedWarning

**Description**

**Definition**

> getDischargeNotAllowedWarning()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getDischargeNotAllowedWarning(dischargeNode)
    local text = g_i18n:getText( Dischargeable.DISCHARGE_WARNINGS[dischargeNode.dischargeFailedReason or Dischargeable.DISCHARGE_REASON_NOT_ALLOWED_HERE] or "warning_actionNotAllowedHere" )
    if dischargeNode.customNotAllowedWarning ~ = nil then
        text = dischargeNode.customNotAllowedWarning
    end

    local fillType = self:getDischargeFillType(dischargeNode)
    local fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(fillType)
    return string.format(text, fillTypeDesc.title)
end

```

### getDischargeState

**Description**

**Definition**

> getDischargeState()

**Code**

```lua
function Dischargeable:getDischargeState()
    return self.spec_dischargeable.currentDischargeState
end

```

### getDischargeTargetObject

**Description**

> Object found for possible discharging

**Definition**

> getDischargeTargetObject()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getDischargeTargetObject(dischargeNode)
    return dischargeNode.dischargeObject, dischargeNode.dischargeFillUnitIndex
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
function Dischargeable:getDoConsumePtoPower(superFunc)
    return( self.spec_dischargeable.consumePower and self:getDischargeState() ~ = Dischargeable.DISCHARGE_STATE_OFF) or superFunc( self )
end

```

### getIsDischargeNodeActive

**Description**

**Definition**

> getIsDischargeNodeActive()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:getIsDischargeNodeActive(dischargeNode)
    return self.spec_dischargeable.isDischargeAllowed
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
function Dischargeable:getIsPowerTakeOffActive(superFunc)
    return( self.spec_dischargeable.consumePower and self:getDischargeState() ~ = Dischargeable.DISCHARGE_STATE_OFF) or superFunc( self )
end

```

### getRequiresTipOcclusionArea

**Description**

**Definition**

> getRequiresTipOcclusionArea()

**Code**

```lua
function Dischargeable:getRequiresTipOcclusionArea()
    local spec = self.spec_dischargeable
    return spec.requiresTipOcclusionArea
end

```

### handleDischarge

**Description**

**Definition**

> handleDischarge()

**Arguments**

| any | dischargeNode       |
|-----|---------------------|
| any | dischargedLiters    |
| any | minDropReached      |
| any | hasMinDropFillLevel |

**Code**

```lua
function Dischargeable:handleDischarge(dischargeNode, dischargedLiters, minDropReached, hasMinDropFillLevel)
    local spec = self.spec_dischargeable

    if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_GROUND then
        local canDrop = not minDropReached and hasMinDropFillLevel

        if dischargeNode.stopDischargeIfNotPossible then
            if dischargedLiters = = 0 and not canDrop then
                self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF)
            end
        end
    else
            if dischargeNode.stopDischargeIfNotPossible then
                if dischargedLiters = = 0 then
                    self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF)
                end
            end
        end
    end

```

### handleDischargeNodeChanged

**Description**

**Definition**

> handleDischargeNodeChanged()

**Code**

```lua
function Dischargeable:handleDischargeNodeChanged()
end

```

### handleDischargeOnEmpty

**Description**

**Definition**

> handleDischargeOnEmpty()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:handleDischargeOnEmpty(dischargeNode)
    local spec = self.spec_dischargeable
    if spec.currentDischargeNode.stopDischargeOnEmpty then
        self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF, true )
    end
end

```

### handleDischargeRaycast

**Description**

**Definition**

> handleDischargeRaycast()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | object        |
| any | shape         |
| any | distance      |
| any | illUnitIndex  |
| any | hitTerrain    |

**Code**

```lua
function Dischargeable:handleDischargeRaycast(dischargeNode, object, shape, distance, illUnitIndex, hitTerrain)
    local spec = self.spec_dischargeable
    if self.isServer then
        -- stop tipping if discharge to object is active but object is not hit anymore
            if object = = nil and spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OBJECT then
                self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF)
            end

            if object = = nil and dischargeNode.canStartGroundDischargeAutomatically then
                if self:getCanDischargeToGround(dischargeNode) and self:getCanDischargeToLand(dischargeNode) and self:getCanDischargeAtPosition(dischargeNode) then
                    self:setDischargeState( Dischargeable.DISCHARGE_STATE_GROUND)
                end
            end
        end

        local currentDischargeNode = spec.currentDischargeNode
        if currentDischargeNode.distanceObjectChanges ~ = nil then
            ObjectChangeUtil.setObjectChanges(currentDischargeNode.distanceObjectChanges, distance > currentDischargeNode.distanceObjectChangeThreshold or spec.currentDischargeState ~ = Dischargeable.DISCHARGE_STATE_OFF, self , self.setMovingToolDirty)
        end
    end

```

### handleFoundDischargeObject

**Description**

**Definition**

> handleFoundDischargeObject()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:handleFoundDischargeObject(dischargeNode)
    if self:getDischargeNodeAutomaticDischarge(dischargeNode) then
        self:setDischargeState( Dischargeable.DISCHARGE_STATE_OBJECT)
    end
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Dischargeable.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "dischargeable" , g_i18n:getText( "configuration_dischargeable" ), "dischargeable" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Dischargeable" )

    Dischargeable.registerXMLPaths(schema, "vehicle.dischargeable" )
    Dischargeable.registerXMLPaths(schema, "vehicle.dischargeable.dischargeableConfigurations.dischargeableConfiguration(?)" )

    Dashboard.registerDashboardXMLPaths(schema, "vehicle.dischargeable.dashboards" , { "activeDischargeNode" , "dischargeState" } )
    schema:register(XMLValueType.INT, "vehicle.dischargeable.dashboards.dashboard(?)#dischargeNodeIndex" , "Index of discharge node" )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).dischargeable#isAllowed" , "If is dicharge allowed" , nil )
end

```

### loadDischargeNode

**Description**

**Definition**

> loadDischargeNode()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function Dischargeable:loadDischargeNode(xmlFile, key, entry)
    entry.isActive = true

    entry.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if entry.node = = nil then
        Logging.xmlWarning( self.xmlFile, "Missing discharge 'node' for dischargeNode '%s'" , key)
            return false
        end

        entry.fillUnitIndex = xmlFile:getValue(key .. "#fillUnitIndex" )
        if entry.fillUnitIndex = = nil then
            Logging.xmlWarning( self.xmlFile, "Missing 'fillUnitIndex' for dischargeNode '%s'" , key)
                return false
            end

            entry.unloadInfoIndex = xmlFile:getValue(key .. "#unloadInfoIndex" , 1 )
            entry.stopDischargeOnEmpty = xmlFile:getValue(key .. "#stopDischargeOnEmpty" , true )
            entry.canDischargeToGround = xmlFile:getValue(key .. "#canDischargeToGround" , true )
            entry.canDischargeToObject = xmlFile:getValue(key .. "#canDischargeToObject" , true )
            entry.canDischargeToVehicle = xmlFile:getValue(key .. "#canDischargeToVehicle" , entry.canDischargeToObject)
            entry.canStartDischargeAutomatically = xmlFile:getValue(key .. "#canStartDischargeAutomatically" , Platform.gameplay.automaticDischarge)
            entry.canStartGroundDischargeAutomatically = xmlFile:getValue(key .. "#canStartGroundDischargeAutomatically" , false )
            entry.stopDischargeIfNotPossible = xmlFile:getValue(key .. "#stopDischargeIfNotPossible" , xmlFile:hasProperty(key .. ".trigger#node" ))
            entry.canDischargeToGroundAnywhere = xmlFile:getValue(key .. "#canDischargeToGroundAnywhere" , false )
            entry.canDischargeToMissionGround = xmlFile:getValue(key .. "#canDischargeToMissionGround" , false )
            entry.canFillOwnVehicle = xmlFile:getValue(key .. "#canFillOwnVehicle" , false )
            entry.limitGroundTipToFillLevel = xmlFile:getValue(key .. "#limitGroundTipToFillLevel" , false )
            entry.emptySpeed = xmlFile:getValue(key .. "#emptySpeed" , self:getFillUnitCapacity(entry.fillUnitIndex)) / 1000 * Platform.gameplay.dischargeSpeedFactor
            entry.effectTurnOffThreshold = xmlFile:getValue(key .. "#effectTurnOffThreshold" , 0.25 )

            entry.lineOffset = 0
            entry.litersToDrop = 0

            local toolTypeStr = xmlFile:getValue(key .. "#toolType" , "dischargeable" )
            entry.toolType = g_toolTypeManager:getToolTypeIndexByName(toolTypeStr)

            entry.info = { }
            entry.info.node = xmlFile:getValue(key .. ".info#node" , entry.node, self.components, self.i3dMappings)
            if entry.info.node = = entry.node then
                entry.info.node = createTransformGroup( "dischargeInfoNode" )
                link(entry.node, entry.info.node)
            end
            entry.info.width = xmlFile:getValue(key .. ".info#width" , 1.0 ) / 2
            entry.info.length = xmlFile:getValue(key .. ".info#length" , 1.0 ) / 2
            entry.info.zOffset = xmlFile:getValue(key .. ".info#zOffset" , 0.0 )
            entry.info.yOffset = xmlFile:getValue(key .. ".info#yOffset" , 2.0 )
            entry.info.limitToGround = xmlFile:getValue(key .. ".info#limitToGround" , true )
            entry.info.useRaycastHitPosition = xmlFile:getValue(key .. ".info#useRaycastHitPosition" , false )

            entry.trigger = { }
            entry.trigger.node = xmlFile:getValue(key .. ".trigger#node" , nil , self.components, self.i3dMappings)
            if entry.trigger.node ~ = nil then
                addTrigger(entry.trigger.node, "dischargeTriggerCallback" , self )
                setTriggerReportStatics(entry.trigger.node, true ) -- enable for static exactFillNodes e.g.in placeables
                end
                entry.trigger.objects = { }
                entry.trigger.numObjects = 0

                entry.raycast = { }
                entry.raycast.node = xmlFile:getValue(key .. ".raycast#node" , nil , self.components, self.i3dMappings)
                if entry.raycast.node = = nil and entry.trigger.node = = nil then
                    entry.raycast.node = entry.node
                end
                entry.raycast.useWorldNegYDirection = xmlFile:getValue(key .. ".raycast#useWorldNegYDirection" , false )
                entry.raycast.yOffset = xmlFile:getValue(key .. ".raycast#yOffset" , 0 )

                local raycastMaxDistance = xmlFile:getValue(key .. ".raycast#maxDistance" )
                entry.maxDistance = xmlFile:getValue(key .. "#maxDistance" , raycastMaxDistance) or 10

                entry.dischargeObject = nil
                entry.dischargeHitObject = nil
                entry.dischargeHitObjectUnitIndex = nil
                entry.dischargeHitTerrain = false
                entry.dischargeShape = nil
                entry.dischargeDistance = 0
                entry.dischargeDistanceSent = 0
                entry.dischargeFillUnitIndex = nil
                entry.dischargeHit = false

                entry.activationTrigger = { }
                entry.activationTrigger.node = xmlFile:getValue(key .. ".activationTrigger#node" , nil , self.components, self.i3dMappings)
                if entry.activationTrigger.node ~ = nil then
                    addTrigger(entry.activationTrigger.node, "dischargeActivationTriggerCallback" , self )
                end
                entry.activationTrigger.objects = { }
                entry.activationTrigger.numObjects = 0

                local fillTypeConverterName = xmlFile:getValue(key .. ".fillType#converterName" )
                if fillTypeConverterName ~ = nil then
                    entry.fillTypeConverter = g_fillTypeManager:getConverterDataByName(fillTypeConverterName)
                end

                entry.distanceObjectChanges = { }
                ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key .. ".distanceObjectChanges" , entry.distanceObjectChanges, self.components, self )
                if #entry.distanceObjectChanges = = 0 then
                    entry.distanceObjectChanges = nil
                else
                        entry.distanceObjectChangeThreshold = xmlFile:getValue(key .. ".distanceObjectChanges#threshold" , 0.5 )
                        ObjectChangeUtil.setObjectChanges(entry.distanceObjectChanges, false , self , self.setMovingToolDirty)
                    end

                    entry.stateObjectChanges = { }
                    ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key .. ".stateObjectChanges" , entry.stateObjectChanges, self.components, self )
                    if #entry.stateObjectChanges = = 0 then
                        entry.stateObjectChanges = nil
                    else
                            ObjectChangeUtil.setObjectChanges(entry.stateObjectChanges, false , self , self.setMovingToolDirty)
                        end

                        entry.nodeActiveObjectChanges = { }
                        ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key .. ".nodeActiveObjectChanges" , entry.nodeActiveObjectChanges, self.components, self )
                        if #entry.nodeActiveObjectChanges = = 0 then
                            entry.nodeActiveObjectChanges = nil
                        else
                                ObjectChangeUtil.setObjectChanges(entry.nodeActiveObjectChanges, false , self , self.setMovingToolDirty)
                            end

                            entry.effects = g_effectManager:loadEffect(xmlFile, key .. ".effects" , self.components, self , self.i3dMappings, math.huge)

                            entry.animationName = xmlFile:getValue(key .. ".animation#name" )
                            entry.animationSpeed = xmlFile:getValue(key .. ".animation#speed" , 1 )
                            entry.animationResetSpeed = xmlFile:getValue(key .. ".animation#resetSpeed" , 1 )

                            if self.isClient then
                                entry.playSound = xmlFile:getValue(key .. "#playSound" , true )
                                entry.soundNode = xmlFile:getValue(key .. "#soundNode" , nil , self.components, self.i3dMappings)

                                -- additional discharge sound if the flag overwriteSharedSound is not set
                                    if entry.playSound then
                                        entry.dischargeSample = g_soundManager:loadSampleFromXML( self.xmlFile, key, "dischargeSound" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                    end

                                    if xmlFile:getValue(key .. ".dischargeSound#overwriteSharedSound" , false ) then
                                        entry.playSound = false
                                    end

                                    entry.dischargeStateSamples = g_soundManager:loadSamplesFromXML( self.xmlFile, key, "dischargeStateSound" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

                                    entry.animationNodes = g_animationManager:loadAnimations( self.xmlFile, key .. ".animationNodes" , self.components, self , self.i3dMappings)
                                    entry.effectAnimationNodes = g_animationManager:loadAnimations( self.xmlFile, key .. ".effectAnimationNodes" , self.components, self , self.i3dMappings)
                                end

                                entry.sentHitDistance = 0
                                entry.isEffectActive = false
                                entry.isEffectActiveSent = false

                                entry.lastEffect = entry.effects[#entry.effects]

                                return true
                            end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function Dischargeable:onDeactivate()
    local spec = self.spec_dischargeable
    if spec.stopDischargeOnDeactivate then
        if spec.currentDischargeState ~ = Dischargeable.DISCHARGE_STATE_OFF then
            self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF, true )
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
function Dischargeable:onDelete()
    local spec = self.spec_dischargeable
    if spec.dischargeNodes ~ = nil then
        for _, dischargeNode in ipairs(spec.dischargeNodes) do
            g_effectManager:deleteEffects(dischargeNode.effects)
            g_soundManager:deleteSample(dischargeNode.sample)
            g_soundManager:deleteSample(dischargeNode.dischargeSample)
            g_soundManager:deleteSamples(dischargeNode.dischargeStateSamples)
            g_animationManager:deleteAnimations(dischargeNode.animationNodes)
            g_animationManager:deleteAnimations(dischargeNode.effectAnimationNodes)

            if dischargeNode.trigger.node ~ = nil then
                local trigger = dischargeNode.trigger
                removeTrigger(trigger.node)

                for object, _ in pairs(trigger.objects) do
                    if object.removeDeleteListener ~ = nil then
                        object:removeDeleteListener( self , "onDeleteDischargeTriggerObject" )
                    end
                end
                table.clear(trigger.objects)
                trigger.numObjects = 0
            end

            if dischargeNode.activationTrigger.node ~ = nil then
                local trigger = dischargeNode.activationTrigger
                removeTrigger(trigger.node)

                for object, _ in pairs(trigger.objects) do
                    if object.removeDeleteListener ~ = nil then
                        object:removeDeleteListener( self , "onDeleteActivationTriggerObject" )
                    end
                end
                table.clear(trigger.objects)
                trigger.numObjects = 0
            end
        end
    end

    spec.dischargeNodes = nil
end

```

### onDeleteActivationTriggerObject

**Description**

**Definition**

> onDeleteActivationTriggerObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function Dischargeable:onDeleteActivationTriggerObject(object)
    local spec = self.spec_dischargeable
    for _, dischargeNode in pairs(spec.activationTriggerToDischargeNode) do
        local trigger = dischargeNode.activationTrigger

        if trigger.objects[object] ~ = nil then
            trigger.objects[object] = nil
            trigger.numObjects = trigger.numObjects - 1
        end
    end
end

```

### onDeleteDischargeTriggerObject

**Description**

**Definition**

> onDeleteDischargeTriggerObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function Dischargeable:onDeleteDischargeTriggerObject(object)
    local spec = self.spec_dischargeable
    for _, dischargeNode in pairs(spec.triggerToDischargeNode) do
        local trigger = dischargeNode.trigger

        if object = = dischargeNode.dischargeObject then
            dischargeNode.dischargeObject = nil
            dischargeNode.dischargeHitTerrain = false
            dischargeNode.dischargeShape = nil
            dischargeNode.dischargeDistance = 0
            dischargeNode.dischargeFillUnitIndex = nil
        end

        if trigger.objects[object] ~ = nil then
            trigger.objects[object] = nil
            trigger.numObjects = trigger.numObjects - 1
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
function Dischargeable:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_dischargeable

    local dischargeNode = spec.fillUnitDischargeNodeMapping[fillUnitIndex]
    if dischargeNode ~ = nil then
        local fillLevel = self:getFillUnitFillLevel(fillUnitIndex)
        if fillLevel = = 0 then
            self:handleDischargeOnEmpty(dischargeNode)
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
function Dischargeable:onLoad(savegame)
    local spec = self.spec_dischargeable

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.pipeEffect" , "vehicle.dischargeable.dischargeNode.effects" ) --FS17 to FS19

    local coverConfigurationId = Utils.getNoNil( self.configurations[ "dischargeable" ], 1 )
    local configKey = string.format( "vehicle.dischargeable.dischargeableConfigurations.dischargeableConfiguration(%d)" , coverConfigurationId - 1 )

    if not self.xmlFile:hasProperty(configKey) then
        configKey = "vehicle.dischargeable"
    end

    spec.isDischargeAllowed = true
    spec.dischargeNodes = { }
    spec.fillUnitDischargeNodeMapping = { }
    spec.dischargNodeMapping = { }
    spec.triggerToDischargeNode = { }
    spec.activationTriggerToDischargeNode = { }

    spec.requiresTipOcclusionArea = self.xmlFile:getValue(configKey .. "#requiresTipOcclusionArea" , true )
    spec.consumePower = self.xmlFile:getValue(configKey .. "#consumePower" , true )
    spec.stopDischargeOnDeactivate = self.xmlFile:getValue(configKey .. "#stopDischargeOnDeactivate" , true )

    spec.dischargedLiters = 0

    self.xmlFile:iterate(configKey .. ".dischargeNode" , function (i, key)
        local entry = { }
        if self:loadDischargeNode( self.xmlFile, key, entry) then
            local canBeAdded = true

            if spec.dischargNodeMapping[entry.node] ~ = nil then
                Logging.xmlWarning( self.xmlFile, "DischargeNode '%d | %s' already defined.Discharge nodes need to be unique.Ignoring it!" , entry.node, getName(entry.node))
                canBeAdded = false
            end
            if entry.trigger.node ~ = nil and spec.triggerToDischargeNode[entry.trigger.node] ~ = nil then
                Logging.xmlWarning( self.xmlFile, "DischargeNode trigger '%d | %s' already defined.DischargeNode triggers need to be unique.Ignoring it!" , entry.trigger.node, getName(entry.trigger.node))
                canBeAdded = false
            end
            if entry.activationTrigger.node ~ = nil and spec.activationTriggerToDischargeNode[entry.activationTrigger.node] ~ = nil then
                Logging.xmlWarning( self.xmlFile, "DischargeNode activationTrigger '%d | %s' already defined.DischargeNode activationTriggers need to be unique.Ignoring it!" , entry.activationTrigger.node, getName(entry.activationTrigger.node))
                canBeAdded = false
            end
            if self.getFillUnitExists ~ = nil and not self:getFillUnitExists(entry.fillUnitIndex) then
                Logging.xmlWarning( self.xmlFile, "FillUnit with index '%d' does not exist for discharge node '%s'.Ignoring discharge node!" , entry.fillUnitIndex, key)
                    canBeAdded = false
                end

                if canBeAdded then
                    table.insert(spec.dischargeNodes, entry)
                    entry.index = #spec.dischargeNodes
                    spec.fillUnitDischargeNodeMapping[entry.fillUnitIndex] = entry
                    spec.dischargNodeMapping[entry.node] = entry

                    if entry.trigger.node ~ = nil then
                        spec.triggerToDischargeNode[entry.trigger.node] = entry
                    end
                    if entry.activationTrigger.node ~ = nil then
                        spec.activationTriggerToDischargeNode[entry.activationTrigger.node] = entry
                    end
                end
            end
        end )

        spec.requiresTipOcclusionArea = spec.requiresTipOcclusionArea and #spec.dischargeNodes > 0

        spec.currentDischargeState = Dischargeable.DISCHARGE_STATE_OFF
        spec.currentRaycast = nil
        spec.forcedFillTypeIndex = nil
        spec.raycastCollisionMask = CollisionFlag.FILLABLE + CollisionFlag.VEHICLE + CollisionFlag.TERRAIN
        spec.isAsyncRaycastActive = false
        spec.currentRaycast = { }
        self:setCurrentDischargeNodeIndex( 1 )

        spec.dirtyFlag = self:getNextDirtyFlag()

        if #spec.dischargeNodes = = 0 then
            SpecializationUtil.removeEventListener( self , "onPostLoad" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onReadStream" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onWriteStream" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onReadUpdateStream" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onWriteUpdateStream" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onUpdate" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onUpdateTick" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onFillUnitFillLevelChanged" , Dischargeable )
            SpecializationUtil.removeEventListener( self , "onDeactivate" , Dischargeable )
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
function Dischargeable:onPostLoad(savegame)
    local spec = self.spec_dischargeable
    if savegame ~ = nil and not savegame.resetVehicles then
        spec.isDischargeAllowed = savegame.xmlFile:getValue(savegame.key .. ".dischargeable#isAllowed" , spec.isDischargeAllowed)
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
function Dischargeable:onReadStream(streamId, connection)
    if connection:getIsServer() then
        local spec = self.spec_dischargeable

        for _, dischargeNode in ipairs(spec.dischargeNodes) do
            if streamReadBool(streamId) then
                local distance = streamReadUIntN(streamId, 8 ) * dischargeNode.maxDistance / 255
                dischargeNode.dischargeDistance = distance
                local fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                self:setDischargeEffectActive(dischargeNode, true , true , fillTypeIndex)
                self:setDischargeEffectDistance(dischargeNode, distance)
            else
                    self:setDischargeEffectActive(dischargeNode, false , true )
                end
            end

            self:setDischargeState(streamReadUIntN(streamId, Dischargeable.SEND_NUM_BITS_DISCHARGE_STATE), true )
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
function Dischargeable:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_dischargeable

        if streamReadBool(streamId) then
            for _, dischargeNode in ipairs(spec.dischargeNodes) do
                if streamReadBool(streamId) then
                    local distance = streamReadUIntN(streamId, 8 ) * dischargeNode.maxDistance / 255
                    dischargeNode.dischargeDistance = distance
                    local fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
                    self:setDischargeEffectActive(dischargeNode, true , true , fillTypeIndex)
                    self:setDischargeEffectDistance(dischargeNode, distance)
                else
                        self:setDischargeEffectActive(dischargeNode, false , true )
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
function Dischargeable:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_dischargeable
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if self:getCanToggleDischargeToGround() then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.TOGGLE_TIPSTATE_GROUND, self , Dischargeable.actionEventToggleDischargeToGround, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            end
            if self:getCanToggleDischargeToObject() then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.TOGGLE_TIPSTATE, self , Dischargeable.actionEventToggleDischarging, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
            end

            Dischargeable.updateActionEvents( self )
        end
    end
end

```

### onRegisterDashboardValueTypes

**Description**

> Called on post load to register dashboard value types

**Definition**

> onRegisterDashboardValueTypes()

**Code**

```lua
function Dischargeable:onRegisterDashboardValueTypes()
    local spec = self.spec_dischargeable

    local activeDischargeNode = DashboardValueType.new( "dischargeable" , "activeDischargeNode" )
    activeDischargeNode:setValue( self , function (_, dashboard)
        return dashboard.dischargeNodeIndex ~ = nil and self:getCurrentDischargeNodeIndex() = = dashboard.dischargeNodeIndex
    end )
    activeDischargeNode:setAdditionalFunctions( Dischargeable.dashboardDischargeAttributes)
    activeDischargeNode:setPollUpdate( false )
    self:registerDashboardValueType(activeDischargeNode)

    local dischargeState = DashboardValueType.new( "dischargeable" , "dischargeState" )
    dischargeState:setValue(spec, "currentDischargeState" )
    dischargeState:setValueCompare( Dischargeable.DISCHARGE_STATE_OBJECT, Dischargeable.DISCHARGE_STATE_GROUND)
    dischargeState:setPollUpdate( false )
    self:registerDashboardValueType(dischargeState)
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
function Dischargeable:onStateChange(state, data)
    if state = = VehicleStateChange.MOTOR_TURN_OFF then
        if not self:getIsPowered() then
            local spec = self.spec_dischargeable
            if spec.stopDischargeOnDeactivate then
                if spec.currentDischargeState ~ = Dischargeable.DISCHARGE_STATE_OFF then
                    self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF, true )
                end
            end
        end
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
function Dischargeable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_dischargeable

    local dischargeNode = spec.currentDischargeNode
    if dischargeNode ~ = nil then
        if dischargeNode.activationTrigger.numObjects > 0 or spec.currentDischargeState ~ = Dischargeable.DISCHARGE_STATE_OFF then
            self:raiseActive()
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
function Dischargeable:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_dischargeable

    local dischargeNode = spec.currentDischargeNode
    if dischargeNode ~ = nil then
        if isActiveForInputIgnoreSelection then
            --#profile RemoteProfiler.zoneBeginN("Dischargeable:updateActionEvents")
            Dischargeable.updateActionEvents( self )
            --#profile RemoteProfiler.zoneEnd()
        end

        if self:getIsDischargeNodeActive(dischargeNode) then
            local trigger = dischargeNode.trigger
            if trigger.numObjects > 0 then
                local lastDischargeObject = dischargeNode.dischargeObject

                dischargeNode.dischargeObject = nil
                dischargeNode.dischargeHitObject = nil
                dischargeNode.dischargeHitObjectUnitIndex = nil
                dischargeNode.dischargeHitTerrain = false
                dischargeNode.dischargeShape = nil
                dischargeNode.dischargeDistance = 0
                dischargeNode.dischargeFillUnitIndex = nil
                dischargeNode.dischargeHit = false -- any(also unsupported) object hit

                local nearestDistance = math.huge
                for object, data in pairs(trigger.objects) do
                    local fillType = spec.forcedFillTypeIndex
                    if fillType = = nil then
                        fillType = self:getDischargeFillType(dischargeNode)
                    end

                    local dischargeFailedReason = nil
                    local dischargeFailedReasonShowAuto = false
                    local customNotAllowedWarning = nil

                    if object:getFillUnitSupportsFillType(data.fillUnitIndex, fillType) then
                        local allowFillType = object:getFillUnitAllowsFillType(data.fillUnitIndex, fillType)
                        local allowToolType = object:getFillUnitSupportsToolType(data.fillUnitIndex, ToolType.TRIGGER)
                        local freeSpace = object:getFillUnitFreeCapacity(data.fillUnitIndex, fillType, self:getActiveFarm()) > 0
                        local accessible = object:getIsFillAllowedFromFarm( self:getActiveFarm())

                        if allowFillType and allowToolType and freeSpace then
                            local exactFillRootNode = object:getFillUnitExactFillRootNode(data.fillUnitIndex)
                            if exactFillRootNode ~ = nil and entityExists(exactFillRootNode) then
                                local distance = calcDistanceFrom(dischargeNode.node, exactFillRootNode)
                                if distance < nearestDistance then
                                    dischargeNode.dischargeObject = object
                                    dischargeNode.dischargeHitTerrain = false
                                    dischargeNode.dischargeShape = data.shape
                                    dischargeNode.dischargeDistance = distance
                                    dischargeNode.dischargeFillUnitIndex = data.fillUnitIndex
                                    nearestDistance = distance

                                    if object ~ = lastDischargeObject then
                                        SpecializationUtil.raiseEvent( self , "onDischargeTargetObjectChanged" , object)
                                        self.rootVehicle:raiseActive()
                                    end
                                end
                            end
                        elseif not allowFillType then
                                dischargeFailedReason = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED
                            elseif not allowToolType then
                                    dischargeFailedReason = Dischargeable.DISCHARGE_REASON_TOOLTYPE_NOT_SUPPORTED
                                elseif not accessible then
                                        dischargeFailedReason = Dischargeable.DISCHARGE_REASON_NO_ACCESS
                                    elseif not freeSpace then
                                            dischargeFailedReason = Dischargeable.DISCHARGE_REASON_NO_FREE_CAPACITY
                                        end

                                        dischargeNode.dischargeHitObject = object
                                        dischargeNode.dischargeHitObjectUnitIndex = data.fillUnitIndex
                                    else
                                            if fillType ~ = FillType.UNKNOWN then
                                                dischargeFailedReason = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED
                                            end
                                        end

                                        if dischargeFailedReason = = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED
                                            or dischargeFailedReason = = Dischargeable.DISCHARGE_REASON_NO_FREE_CAPACITY
                                            or dischargeFailedReason = = Dischargeable.DISCHARGE_REASON_NO_ACCESS then
                                            if object.isa = = nil or not object:isa( Vehicle ) then
                                                dischargeFailedReasonShowAuto = true
                                            end
                                        end

                                        if dischargeFailedReason ~ = nil then
                                            -- only display custom warning if at least the fill type would be supported
                                                if dischargeFailedReason ~ = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED then
                                                    if object.getCustomDischargeNotAllowedWarning ~ = nil then
                                                        customNotAllowedWarning = object:getCustomDischargeNotAllowedWarning()
                                                    end
                                                end
                                            end

                                            if dischargeNode.dischargeObject = = nil and dischargeFailedReason ~ = nil then
                                                -- failed reasons are priorized by their value(e.g.if one trigger has a NO_FREE_CAPACITY it has a higher prio than NOT_SUPPORTED warning, so we show the least worst warning)
                                                    if dischargeNode.dischargeFailedReason = = nil or dischargeFailedReason < dischargeNode.dischargeFailedReason then
                                                        dischargeNode.dischargeFailedReason = dischargeFailedReason
                                                        dischargeNode.dischargeFailedReasonShowAuto = dischargeFailedReasonShowAuto
                                                        dischargeNode.customNotAllowedWarning = customNotAllowedWarning
                                                    end
                                                else
                                                        -- if we found at least one object to discharge we ignore failed warnings for all other hit objects
                                                            dischargeNode.dischargeFailedReason = nil
                                                            dischargeNode.dischargeFailedReasonShowAuto = false
                                                            dischargeNode.customNotAllowedWarning = nil
                                                        end

                                                        dischargeNode.dischargeHit = true -- any(also unsupported) object has been hit
                                                    end

                                                    if lastDischargeObject ~ = nil and dischargeNode.dischargeObject = = nil then
                                                        SpecializationUtil.raiseEvent( self , "onDischargeTargetObjectChanged" , nil )
                                                        self.rootVehicle:raiseActive()
                                                    end
                                                else
                                                        if not spec.isAsyncRaycastActive then
                                                            --#profile RemoteProfiler.zoneBeginN("Dischargeable:updateRaycast")
                                                            self:updateRaycast(dischargeNode)
                                                            --#profile RemoteProfiler.zoneEnd()
                                                        end
                                                    end
                                                else
                                                        if spec.currentDischargeState ~ = Dischargeable.DISCHARGE_STATE_OFF then
                                                            self:setDischargeState( Dischargeable.DISCHARGE_STATE_OFF, true )
                                                        end

                                                        if dischargeNode.dischargeObject ~ = nil then
                                                            SpecializationUtil.raiseEvent( self , "onDischargeTargetObjectChanged" , nil )
                                                            self.rootVehicle:raiseActive()
                                                        end

                                                        dischargeNode.dischargeObject = nil
                                                        dischargeNode.dischargeHitObject = nil
                                                        dischargeNode.dischargeHitObjectUnitIndex = nil
                                                        dischargeNode.dischargeHitTerrain = false
                                                        dischargeNode.dischargeShape = nil
                                                        dischargeNode.dischargeDistance = 0
                                                        dischargeNode.dischargeFillUnitIndex = nil
                                                        dischargeNode.dischargeHit = false -- any(also unsupported) object hit
                                                    end

                                                    --#profile RemoteProfiler.zoneBeginN("Dischargeable:updateDischargeSound")
                                                    self:updateDischargeSound(dischargeNode, dt)
                                                    --#profile RemoteProfiler.zoneEnd()

                                                    --#profile RemoteProfiler.zoneBeginN("Dischargeable:handleDischarge")
                                                    if self.isServer then
                                                        if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OFF then
                                                            if dischargeNode.dischargeObject ~ = nil then
                                                                self:handleFoundDischargeObject(dischargeNode)
                                                            end
                                                        else
                                                                local fillLevel = self:getFillUnitFillLevel(dischargeNode.fillUnitIndex)
                                                                local emptySpeed = self:getDischargeNodeEmptyFactor(dischargeNode)

                                                                -- Only allow discharge into a node, or if the land is owned
                                                                    local canDischargeToObject = self:getCanDischargeToObject(dischargeNode) and spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OBJECT
                                                                    local canDischargeToGround = self:getCanDischargeToGround(dischargeNode) and spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_GROUND
                                                                    local canDischarge = canDischargeToObject or canDischargeToGround
                                                                    local allowedToDischarge = dischargeNode.dischargeObject ~ = nil or( self:getCanDischargeToLand(dischargeNode) and self:getCanDischargeAtPosition(dischargeNode))
                                                                    local isReadyToStartDischarge = fillLevel > 0 and emptySpeed > 0 and allowedToDischarge and canDischarge

                                                                    self:setDischargeEffectActive(dischargeNode, isReadyToStartDischarge)
                                                                    self:setDischargeEffectDistance(dischargeNode, dischargeNode.dischargeDistance)

                                                                    local isReadyForDischarge = dischargeNode.lastEffect = = nil or dischargeNode.lastEffect:getIsFullyVisible()
                                                                    if isReadyForDischarge and allowedToDischarge and canDischarge then
                                                                        local emptyLiters = math.min(fillLevel, dischargeNode.emptySpeed * emptySpeed * dt)
                                                                        local dischargedLiters, minDropReached, hasMinDropFillLevel = self:discharge(dischargeNode, emptyLiters)

                                                                        spec.dischargedLiters = dischargedLiters
                                                                        self:handleDischarge(dischargeNode, dischargedLiters, minDropReached, hasMinDropFillLevel)
                                                                    end
                                                                end

                                                                if math.abs(dischargeNode.dischargeDistanceSent - dischargeNode.dischargeDistance) > 0.05 then
                                                                    self:raiseDirtyFlags(spec.dirtyFlag)
                                                                    dischargeNode.dischargeDistanceSent = dischargeNode.dischargeDistance
                                                                end
                                                            end
                                                            --#profile RemoteProfiler.zoneEnd()
                                                        end

                                                        --#profile RemoteProfiler.zoneBeginN("Dischargeable:showTipContext")
                                                        if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OFF then
                                                            local currentDischargeNode = spec.currentDischargeNode
                                                            if isActiveForInput and self:getCanDischargeToObject(currentDischargeNode) and self:getCanToggleDischargeToObject() then
                                                                g_currentMission:showTipContext( self:getFillUnitFillType(dischargeNode.fillUnitIndex))
                                                            end
                                                        end
                                                        --#profile RemoteProfiler.zoneEnd()

                                                        -- permanent warning if automatic discharge is enabled, otherwise only on action event
                                                            if isActiveForInputIgnoreSelection then
                                                                if dischargeNode ~ = nil and dischargeNode.canStartDischargeAutomatically then
                                                                    if dischargeNode.dischargeHit then
                                                                        if dischargeNode.dischargeFailedReasonShowAuto then
                                                                            if dischargeNode.dischargeFailedReason ~ = nil and g_currentMission.time > 10000 then
                                                                                local warning = self:getDischargeNotAllowedWarning(dischargeNode)
                                                                                g_currentMission:showBlinkingWarning(warning, 5000 )
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            -- Look for non-used discharge node that still have their stop animation running
                                                                if self.isServer then
                                                                    for _, inactiveDischargeNode in ipairs(spec.dischargeNodes) do
                                                                        if inactiveDischargeNode.stopEffectTime ~ = nil then
                                                                            if inactiveDischargeNode.stopEffectTime < g_ time then
                                                                                self:setDischargeEffectActive(inactiveDischargeNode, false , true )
                                                                                inactiveDischargeNode.stopEffectTime = nil
                                                                            else
                                                                                    self:raiseActive()
                                                                                end
                                                                            end
                                                                        end
                                                                    end

                                                                    -- keep updating while discharge sounds are still playing(until the effect is done and the sound is stopped)
                                                                        if self.isClient then
                                                                            for _, dischargeNode in ipairs(spec.dischargeNodes) do
                                                                                if g_soundManager:getIsSamplePlaying(dischargeNode.dischargeSample) then
                                                                                    self:raiseActive()
                                                                                end

                                                                                if dischargeNode.sample ~ = nil then
                                                                                    if g_soundManager:getIsSamplePlaying(dischargeNode.sample) then
                                                                                        self:raiseActive()
                                                                                    end
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
function Dischargeable:onWriteStream(streamId, connection)
    if not connection:getIsServer() then
        local spec = self.spec_dischargeable

        for _, dischargeNode in ipairs(spec.dischargeNodes) do
            if streamWriteBool(streamId, dischargeNode.isEffectActiveSent) then
                streamWriteUIntN(streamId, math.clamp( math.floor(dischargeNode.dischargeDistanceSent / dischargeNode.maxDistance * 255 ), 1 , 255 ), 8 )
                streamWriteUIntN(streamId, self:getDischargeFillType(dischargeNode), FillTypeManager.SEND_NUM_BITS)
            end
        end

        streamWriteUIntN(streamId, spec.currentDischargeState, Dischargeable.SEND_NUM_BITS_DISCHARGE_STATE)
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
function Dischargeable:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_dischargeable

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            for _, dischargeNode in ipairs(spec.dischargeNodes) do
                if streamWriteBool(streamId, dischargeNode.isEffectActiveSent) then
                    streamWriteUIntN(streamId, math.clamp( math.floor(dischargeNode.dischargeDistanceSent / dischargeNode.maxDistance * 255 ), 1 , 255 ), 8 )
                    streamWriteUIntN(streamId, self:getDischargeFillType(dischargeNode), FillTypeManager.SEND_NUM_BITS)
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
function Dischargeable.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and SpecializationUtil.hasSpecialization( FillVolume , specializations)
end

```

### raycastCallbackDischargeNode

**Description**

**Definition**

> raycastCallbackDischargeNode()

**Arguments**

| any | hitActorId    |
|-----|---------------|
| any | x             |
| any | y             |
| any | z             |
| any | distance      |
| any | nx            |
| any | ny            |
| any | nz            |
| any | subShapeIndex |
| any | hitShapeId    |
| any | isLast        |

**Code**

```lua
function Dischargeable:raycastCallbackDischargeNode(hitActorId, x, y, z, distance, nx, ny, nz, subShapeIndex, hitShapeId, isLast)
    if self.isDeleted or self.isDeleting then
        return
    end

    local spec = self.spec_dischargeable
    local dischargeNode = spec.currentRaycastDischargeNode

    if hitActorId ~ = 0 then
        local object = g_currentMission:getNodeObject(hitActorId)

        distance = distance - dischargeNode.raycast.yOffset

        if VehicleDebug.state = = VehicleDebug.DEBUG then
            DebugGizmo.renderAtPositionSimple(x,y,z, string.format( "hitActorId %d | %s; hitShape %d | %s; object %s" , hitActorId, getName(hitActorId), hitShapeId, getName(hitShapeId), object))
        end

        local validObject = object ~ = nil and(object ~ = self or dischargeNode.canFillOwnVehicle)
        -- if we hit a object because of the yOffset it has to be a exact fill root node, otherwise we ignore it
            -- is used to get exactFillRootNodes if the dischargeNode of the shovel is already below it
                if validObject and distance < 0 then
                    if object.getFillUnitIndexFromNode ~ = nil then
                        validObject = validObject and object:getFillUnitIndexFromNode(hitShapeId) ~ = nil
                    end

                    if not dischargeNode.canDischargeToVehicle then
                        validObject = validObject and not object:isa( Vehicle )
                    end
                end

                if validObject then
                    if object.getFillUnitIndexFromNode ~ = nil then
                        local fillUnitIndex = object:getFillUnitIndexFromNode(hitShapeId)
                        if fillUnitIndex ~ = nil then
                            local fillType = spec.forcedFillTypeIndex
                            if fillType = = nil then
                                fillType = self:getDischargeFillType(dischargeNode)
                            end

                            local dischargeFailedReason = nil
                            local dischargeFailedReasonShowAuto = false
                            local customNotAllowedWarning = nil

                            if object:getFillUnitSupportsFillType(fillUnitIndex, fillType) then
                                local allowFillType = object:getFillUnitAllowsFillType(fillUnitIndex, fillType)
                                local allowToolType = object:getFillUnitSupportsToolType(fillUnitIndex, dischargeNode.toolType)
                                local freeSpace = object:getFillUnitFreeCapacity(fillUnitIndex, fillType, self:getActiveFarm()) > 0
                                local accessible = object:getIsFillAllowedFromFarm( self:getActiveFarm())

                                if allowFillType and allowToolType and freeSpace then
                                    dischargeNode.raycastDischargeObject = object
                                    dischargeNode.raycastDischargeShape = hitShapeId
                                    dischargeNode.raycastDischargeDistance = distance
                                    dischargeNode.raycastDischargeFillUnitIndex = fillUnitIndex

                                    if object.getFillUnitExtraDistanceFromNode ~ = nil then
                                        dischargeNode.raycastDischargeExtraDistance = object:getFillUnitExtraDistanceFromNode(hitShapeId)
                                    end
                                elseif not allowFillType then
                                        dischargeFailedReason = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED
                                    elseif not allowToolType then
                                            dischargeFailedReason = Dischargeable.DISCHARGE_REASON_TOOLTYPE_NOT_SUPPORTED
                                        elseif not accessible then
                                                dischargeFailedReason = Dischargeable.DISCHARGE_REASON_NO_ACCESS
                                            elseif not freeSpace then
                                                    dischargeFailedReason = Dischargeable.DISCHARGE_REASON_NO_FREE_CAPACITY
                                                end
                                            else
                                                    if fillType ~ = FillType.UNKNOWN then
                                                        dischargeFailedReason = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED
                                                    end
                                                end

                                                if dischargeFailedReason = = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED
                                                    or dischargeFailedReason = = Dischargeable.DISCHARGE_REASON_NO_FREE_CAPACITY
                                                    or dischargeFailedReason = = Dischargeable.DISCHARGE_REASON_NO_ACCESS then
                                                    if object.isa = = nil or not object:isa( Vehicle ) then
                                                        dischargeFailedReasonShowAuto = true
                                                    end
                                                end

                                                if dischargeFailedReason ~ = nil then
                                                    -- only display custom warning if at least the fill type would be supported
                                                        if dischargeFailedReason ~ = Dischargeable.DISCHARGE_REASON_FILLTYPE_NOT_SUPPORTED then
                                                            if object.getCustomDischargeNotAllowedWarning ~ = nil then
                                                                customNotAllowedWarning = object:getCustomDischargeNotAllowedWarning()
                                                            end
                                                        end
                                                    end

                                                    if dischargeNode.raycastDischargeObject = = nil and dischargeFailedReason ~ = nil then
                                                        -- failed reasons are priorized by their value(e.g.if one trigger has a NO_FREE_CAPACITY it has a higher prio than NOT_SUPPORTED warning, so we show the least worst warning)
                                                            if dischargeNode.raycastDischargeFailedReason = = nil or dischargeFailedReason < dischargeNode.raycastDischargeFailedReason then
                                                                dischargeNode.raycastDischargeFailedReason = dischargeFailedReason
                                                                dischargeNode.raycastDischargeFailedReasonShowAuto = dischargeFailedReasonShowAuto
                                                                dischargeNode.customNotAllowedWarning = customNotAllowedWarning
                                                            end
                                                        else
                                                                -- if we found at least one object to discharge we ignore failed warnings for all other hit objects
                                                                    dischargeNode.raycastDischargeFailedReason = nil
                                                                    dischargeNode.raycastDischargeFailedReasonShowAuto = false
                                                                    dischargeNode.customNotAllowedWarning = nil
                                                                end

                                                                dischargeNode.raycastDischargeHit = true -- any, even unsupported, object has been hit.
                                                                dischargeNode.raycastDischargeHitObject = object -- hit object, no matter if it's fillable or not
                                                                    dischargeNode.raycastDischargeHitObjectUnitIndex = fillUnitIndex
                                                                else
                                                                        if dischargeNode.raycastDischargeHit then
                                                                            -- raycast until we hit the object underneath the exact fill root node
                                                                            dischargeNode.raycastDischargeDistance = distance + (dischargeNode.raycastDischargeExtraDistance or 0 )
                                                                            dischargeNode.raycastDischargeExtraDistance = nil
                                                                            self:updateDischargeInfo(dischargeNode, x, y, z)

                                                                            self:finishDischargeRaycast()
                                                                            return false
                                                                        end
                                                                    end
                                                                end
                                                            elseif hitActorId = = g_terrainNode then
                                                                    dischargeNode.raycastDischargeDistance = math.min(dischargeNode.raycastDischargeDistance, distance)
                                                                    dischargeNode.raycastDischargeHitTerrain = true
                                                                    self:updateDischargeInfo(dischargeNode, x, y, z)
                                                                    self:finishDischargeRaycast()
                                                                    return false -- stop callbacks
                                                                end
                                                            end

                                                            if isLast then
                                                                self:finishDischargeRaycast()
                                                                return false
                                                            end

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
function Dischargeable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterDashboardValueTypes" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Dischargeable )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , Dischargeable )
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
function Dischargeable.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onDischargeStateChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onDischargeTargetObjectChanged" )
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
function Dischargeable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadDischargeNode" , Dischargeable.loadDischargeNode)
    SpecializationUtil.registerFunction(vehicleType, "setCurrentDischargeNodeIndex" , Dischargeable.setCurrentDischargeNodeIndex)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentDischargeNode" , Dischargeable.getCurrentDischargeNode)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentDischargeNodeIndex" , Dischargeable.getCurrentDischargeNodeIndex)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeTargetObject" , Dischargeable.getDischargeTargetObject)
    SpecializationUtil.registerFunction(vehicleType, "getCurrentDischargeObject" , Dischargeable.getCurrentDischargeObject)
    SpecializationUtil.registerFunction(vehicleType, "discharge" , Dischargeable.discharge)
    SpecializationUtil.registerFunction(vehicleType, "dischargeToGround" , Dischargeable.dischargeToGround)
    SpecializationUtil.registerFunction(vehicleType, "dischargeToObject" , Dischargeable.dischargeToObject)
    SpecializationUtil.registerFunction(vehicleType, "setManualDischargeState" , Dischargeable.setManualDischargeState)
    SpecializationUtil.registerFunction(vehicleType, "setDischargeState" , Dischargeable.setDischargeState)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeState" , Dischargeable.getDischargeState)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeFillType" , Dischargeable.getDischargeFillType)
    SpecializationUtil.registerFunction(vehicleType, "getCanDischargeToGround" , Dischargeable.getCanDischargeToGround)
    SpecializationUtil.registerFunction(vehicleType, "getCanDischargeAtPosition" , Dischargeable.getCanDischargeAtPosition)
    SpecializationUtil.registerFunction(vehicleType, "getCanDischargeToLand" , Dischargeable.getCanDischargeToLand)
    SpecializationUtil.registerFunction(vehicleType, "getCanDischargeToObject" , Dischargeable.getCanDischargeToObject)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeNotAllowedWarning" , Dischargeable.getDischargeNotAllowedWarning)
    SpecializationUtil.registerFunction(vehicleType, "getCanToggleDischargeToObject" , Dischargeable.getCanToggleDischargeToObject)
    SpecializationUtil.registerFunction(vehicleType, "getCanToggleDischargeToGround" , Dischargeable.getCanToggleDischargeToGround)
    SpecializationUtil.registerFunction(vehicleType, "getIsPossibleToDischargeToObject" , Dischargeable.getIsPossibleToDischargeToObject)
    SpecializationUtil.registerFunction(vehicleType, "getIsDischargeNodeActive" , Dischargeable.getIsDischargeNodeActive)
    SpecializationUtil.registerFunction(vehicleType, "setIsDischargeAllowed" , Dischargeable.setIsDischargeAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeNodeEmptyFactor" , Dischargeable.getDischargeNodeEmptyFactor)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeNodeAutomaticDischarge" , Dischargeable.getDischargeNodeAutomaticDischarge)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeNodeByNode" , Dischargeable.getDischargeNodeByNode)
    SpecializationUtil.registerFunction(vehicleType, "updateRaycast" , Dischargeable.updateRaycast)
    SpecializationUtil.registerFunction(vehicleType, "updateDischargeInfo" , Dischargeable.updateDischargeInfo)
    SpecializationUtil.registerFunction(vehicleType, "raycastCallbackDischargeNode" , Dischargeable.raycastCallbackDischargeNode)
    SpecializationUtil.registerFunction(vehicleType, "finishDischargeRaycast" , Dischargeable.finishDischargeRaycast)
    SpecializationUtil.registerFunction(vehicleType, "getDischargeNodeByIndex" , Dischargeable.getDischargeNodeByIndex)
    SpecializationUtil.registerFunction(vehicleType, "handleDischargeOnEmpty" , Dischargeable.handleDischargeOnEmpty)
    SpecializationUtil.registerFunction(vehicleType, "handleDischargeNodeChanged" , Dischargeable.handleDischargeNodeChanged)
    SpecializationUtil.registerFunction(vehicleType, "handleDischarge" , Dischargeable.handleDischarge)
    SpecializationUtil.registerFunction(vehicleType, "handleDischargeRaycast" , Dischargeable.handleDischargeRaycast)
    SpecializationUtil.registerFunction(vehicleType, "handleFoundDischargeObject" , Dischargeable.handleFoundDischargeObject)
    SpecializationUtil.registerFunction(vehicleType, "setDischargeEffectDistance" , Dischargeable.setDischargeEffectDistance)
    SpecializationUtil.registerFunction(vehicleType, "setDischargeEffectActive" , Dischargeable.setDischargeEffectActive)
    SpecializationUtil.registerFunction(vehicleType, "updateDischargeSound" , Dischargeable.updateDischargeSound)
    SpecializationUtil.registerFunction(vehicleType, "dischargeTriggerCallback" , Dischargeable.dischargeTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "onDeleteDischargeTriggerObject" , Dischargeable.onDeleteDischargeTriggerObject)
    SpecializationUtil.registerFunction(vehicleType, "dischargeActivationTriggerCallback" , Dischargeable.dischargeActivationTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "onDeleteActivationTriggerObject" , Dischargeable.onDeleteActivationTriggerObject)
    SpecializationUtil.registerFunction(vehicleType, "setForcedFillTypeIndex" , Dischargeable.setForcedFillTypeIndex)
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
function Dischargeable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRequiresTipOcclusionArea" , Dischargeable.getRequiresTipOcclusionArea)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Dischargeable.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower" , Dischargeable.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsPowerTakeOffActive" , Dischargeable.getIsPowerTakeOffActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowLoadTriggerActivation" , Dischargeable.getAllowLoadTriggerActivation)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Dischargeable.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.BOOL, basePath .. "#requiresTipOcclusionArea" , "Requires tip occlusion area" , true )
    schema:register(XMLValueType.BOOL, basePath .. "#consumePower" , "While in discharge state, PTO power is consumed" , true )
    schema:register(XMLValueType.BOOL, basePath .. "#stopDischargeOnDeactivate" , "Stop discharge if the vehicle is deactivated" , true )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".dischargeNode(?)#node" , "Discharge node" )
        schema:register(XMLValueType.INT, basePath .. ".dischargeNode(?)#fillUnitIndex" , "Fill unit index" )
        schema:register(XMLValueType.INT, basePath .. ".dischargeNode(?)#unloadInfoIndex" , "Unload info index" , 1 )
        schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#stopDischargeOnEmpty" , "Stop discharge if fill unit empty" , true )
            schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canDischargeToGround" , "Can discharge to ground" , true )
            schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canDischargeToObject" , "Can discharge to object" , true )
            schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canDischargeToVehicle" , "Can discharge to other vehicles" , "same as canDischargeToObject" )
            schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canStartDischargeAutomatically" , "Can start discharge automatically" , false )
            schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canStartGroundDischargeAutomatically" , "Can start discharge to ground automatically" , false )
            schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#stopDischargeIfNotPossible" , "Stop discharge if not possible" , "default 'true' while having discharge trigger" )
                schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canDischargeToGroundAnywhere" , "Can discharge to ground independent of land owned state" , false )
                schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canDischargeToMissionGround" , "Can discharge to ground if an active mission is running on the farmland" , false )
                    schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#canFillOwnVehicle" , "Discharge node can fill other fill units of the vehicle itself" , false )
                    schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#limitGroundTipToFillLevel" , "Limit the amount that is dropped on the ground to the fill level of the tool(Otherwise it will tip the min.amount possible even if the fill level is below.)" , false )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?)#emptySpeed" , "Empty speed in l/sec" , "fill unit capacity" )
                        schema:register(XMLValueType.TIME, basePath .. ".dischargeNode(?)#effectTurnOffThreshold" , "After this time has passed and nothing has been harvested the effects are turned off" , 0.25 )
                        schema:register(XMLValueType.STRING, basePath .. ".dischargeNode(?)#toolType" , "Tool type" , "dischargable" )

                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".dischargeNode(?).info#node" , "Discharge info node" , "Discharge node" )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).info#width" , "Discharge info width" , 1 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).info#length" , "Discharge info length" , 1 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).info#zOffset" , "Discharge info Z axis offset" , 0 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).info#yOffset" , "Discharge info y axis offset" , 2 )
                        schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?).info#limitToGround" , "Discharge info is limited to ground" , true )
                        schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?).info#useRaycastHitPosition" , "Discharge info uses raycast hit position" , false )

                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".dischargeNode(?).raycast#node" , "Raycast node" , "Discharge node" )
                        schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?).raycast#useWorldNegYDirection" , "Use world negative Y Direction" , false )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).raycast#yOffset" , "Y Offset" , 0 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).raycast#maxDistance" , "Max.raycast distance" , 10 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?)#maxDistance" , "Max.raycast distance" , 10 )

                        schema:register(XMLValueType.STRING, basePath .. ".dischargeNode(?).fillType#converterName" , "Converter to be used to convert the fill types" )

                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".dischargeNode(?).trigger#node" , "Discharge trigger node" )
                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".dischargeNode(?).activationTrigger#node" , "Discharge activation trigger node" )

                        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath .. ".dischargeNode(?).distanceObjectChanges" )
                        schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).distanceObjectChanges#threshold" , "Defines at which raycast distance the object changes" , 0.5 )

                        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath .. ".dischargeNode(?).stateObjectChanges" )
                        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath .. ".dischargeNode(?).nodeActiveObjectChanges" )

                        EffectManager.registerEffectXMLPaths(schema, basePath .. ".dischargeNode(?).effects" )

                        schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?)#playSound" , "Play discharge sound" , true )
                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".dischargeNode(?)#soundNode" , "Sound link node" , "Discharge node" )

                        schema:register(XMLValueType.STRING, basePath .. ".dischargeNode(?).animation#name" , "Name of animation to play while discharging" )
                            schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).animation#speed" , "Animation speed while discharging" , 1 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".dischargeNode(?).animation#resetSpeed" , "Animation speed while discharge has been stopped" , 1 )

                                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".dischargeNode(?)" , "dischargeSound" )
                                    schema:register(XMLValueType.BOOL, basePath .. ".dischargeNode(?).dischargeSound#overwriteSharedSound" , "Overwrite shared discharge sound with sound defined in discharge node" , false )

                                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".dischargeNode(?)" , "dischargeStateSound(?)" )

                                    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".dischargeNode(?).animationNodes" )
                                    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".dischargeNode(?).effectAnimationNodes" )
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
function Dischargeable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_dischargeable
    xmlFile:setValue(key .. "#isAllowed" , spec.isDischargeAllowed)
end

```

### setCurrentDischargeNodeIndex

**Description**

**Definition**

> setCurrentDischargeNodeIndex()

**Arguments**

| any | dischargeNodeIndex |
|-----|--------------------|

**Code**

```lua
function Dischargeable:setCurrentDischargeNodeIndex(dischargeNodeIndex)
    local spec = self.spec_dischargeable

    -- deactivate effects on old discharge node
    if spec.currentDischargeNode ~ = nil and spec.dischargeNodes[dischargeNodeIndex] ~ = spec.currentDischargeNode then
        self:setDischargeEffectActive(spec.currentDischargeNode, false , true )
        self:updateDischargeSound(spec.currentDischargeNode, 99999 )

        if spec.dischargeNodes[dischargeNodeIndex] ~ = spec.currentDischargeNode then
            g_animationManager:stopAnimations(spec.currentDischargeNode.animationNodes)
            g_animationManager:stopAnimations(spec.currentDischargeNode.effectAnimationNodes)
        end

        g_soundManager:stopSamples(spec.currentDischargeNode.dischargeStateSamples)
    end

    spec.currentDischargeNode = spec.dischargeNodes[dischargeNodeIndex]

    for i = 1 , #spec.dischargeNodes do
        local node = spec.dischargeNodes[i]
        if node.nodeActiveObjectChanges ~ = nil then
            ObjectChangeUtil.setObjectChanges(node.nodeActiveObjectChanges, i = = dischargeNodeIndex, self , self.setMovingToolDirty)
        end
    end

    if self.isClient then
        if self.updateDashboardValueType ~ = nil then
            self:updateDashboardValueType( "dischargeable.activeDischargeNode" )
        end
    end

    self:handleDischargeNodeChanged()
end

```

### setDischargeEffectActive

**Description**

**Definition**

> setDischargeEffectActive()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | isActive      |
| any | force         |
| any | fillTypeIndex |

**Code**

```lua
function Dischargeable:setDischargeEffectActive(dischargeNode, isActive, force, fillTypeIndex)
    if isActive then
        if not dischargeNode.isEffectActive then
            if fillTypeIndex = = nil then
                fillTypeIndex = self:getDischargeFillType(dischargeNode)
            end

            g_effectManager:setEffectTypeInfo(dischargeNode.effects, fillTypeIndex)
            g_effectManager:startEffects(dischargeNode.effects)
            g_animationManager:startAnimations(dischargeNode.effectAnimationNodes)

            dischargeNode.isEffectActive = true
        end

        dischargeNode.stopEffectTime = nil
    else
            if force = = nil or not force then
                if dischargeNode.stopEffectTime = = nil then
                    dischargeNode.stopEffectTime = g_ time + dischargeNode.effectTurnOffThreshold
                    self:raiseActive()
                end
            else
                    if dischargeNode.isEffectActive then
                        g_effectManager:stopEffects(dischargeNode.effects)
                        g_animationManager:stopAnimations(dischargeNode.effectAnimationNodes)

                        dischargeNode.isEffectActive = false
                    end
                end
            end

            if self.isServer then
                if dischargeNode.isEffectActive ~ = dischargeNode.isEffectActiveSent then
                    self:raiseDirtyFlags( self.spec_dischargeable.dirtyFlag)
                    dischargeNode.isEffectActiveSent = dischargeNode.isEffectActive
                end
            end
        end

```

### setDischargeEffectDistance

**Description**

**Definition**

> setDischargeEffectDistance()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | distance      |

**Code**

```lua
function Dischargeable:setDischargeEffectDistance(dischargeNode, distance)
    if dischargeNode.isEffectActive then
        if dischargeNode.effects ~ = nil and distance ~ = math.huge then
            for _, effect in pairs(dischargeNode.effects) do
                if effect.setDistance ~ = nil then
                    effect:setDistance(distance, g_terrainNode)
                end
            end
        end
    end
end

```

### setDischargeState

**Description**

**Definition**

> setDischargeState()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Dischargeable:setDischargeState(state, noEventSend)
    local spec = self.spec_dischargeable
    if state ~ = spec.currentDischargeState then
        SetDischargeStateEvent.sendEvent( self , state, noEventSend)

        spec.currentDischargeState = state

        local dischargeNode = spec.currentDischargeNode
        if self.isServer then
            if state = = Dischargeable.DISCHARGE_STATE_OFF then
                self:setDischargeEffectActive(dischargeNode, false )
            end
        end

        if self.isClient then
            if state = = Dischargeable.DISCHARGE_STATE_OFF then
                g_animationManager:stopAnimations(dischargeNode.animationNodes)
                g_soundManager:stopSamples(dischargeNode.dischargeStateSamples)
            else
                    g_animationManager:startAnimations(dischargeNode.animationNodes)
                    g_soundManager:playSamples(dischargeNode.dischargeStateSamples)
                end

                if self.updateDashboardValueType ~ = nil then
                    self:updateDashboardValueType( "dischargeable.dischargeState" )
                end
            end

            for i = 1 , #spec.dischargeNodes do
                local node = spec.dischargeNodes[i]
                if node.stateObjectChanges ~ = nil then
                    ObjectChangeUtil.setObjectChanges(node.stateObjectChanges, state ~ = Dischargeable.DISCHARGE_STATE_OFF and node = = dischargeNode, self , self.setMovingToolDirty)
                end
            end

            if dischargeNode.animationName ~ = nil then
                if state ~ = Dischargeable.DISCHARGE_STATE_OFF then
                    self:playAnimation(dischargeNode.animationName, dischargeNode.animationSpeed, self:getAnimationTime(dischargeNode.animationName), true )
                else
                        self:playAnimation(dischargeNode.animationName, - dischargeNode.animationResetSpeed, self:getAnimationTime(dischargeNode.animationName), true )
                    end
                end

                SpecializationUtil.raiseEvent( self , "onDischargeStateChanged" , state)
            end
        end

```

### setForcedFillTypeIndex

**Description**

**Definition**

> setForcedFillTypeIndex()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|

**Code**

```lua
function Dischargeable:setForcedFillTypeIndex(fillTypeIndex)
    self.spec_dischargeable.forcedFillTypeIndex = fillTypeIndex
end

```

### setManualDischargeState

**Description**

> Discharge state set that is triggered by a manual user action (button press)

**Definition**

> setManualDischargeState()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Dischargeable:setManualDischargeState(state, noEventSend)
    self:setDischargeState(state, noEventSend)
end

```

### updateActionEvents

**Description**

**Definition**

> updateActionEvents()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Dischargeable.updateActionEvents( self )
    local spec = self.spec_dischargeable

    local actionEventTip = spec.actionEvents[InputAction.TOGGLE_TIPSTATE]
    local actionEventTipGround = spec.actionEvents[InputAction.TOGGLE_TIPSTATE_GROUND]
    local showTip = false
    local showTipGround = false

    if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OFF then
        if actionEventTip ~ = nil or actionEventTipGround ~ = nil then
            local currentDischargeNode = spec.currentDischargeNode
            if self:getIsDischargeNodeActive(currentDischargeNode) then
                if actionEventTip ~ = nil and self:getCanDischargeToObject(currentDischargeNode) and self:getCanToggleDischargeToObject() then
                    g_inputBinding:setActionEventText(actionEventTip.actionEventId, g_i18n:getText( "action_startOverloading" ))
                    showTip = true
                elseif actionEventTipGround ~ = nil and self:getCanDischargeToGround(currentDischargeNode) and self:getCanToggleDischargeToGround() then
                        g_inputBinding:setActionEventText(actionEventTipGround.actionEventId, g_i18n:getText( "action_startTipToGround" ))
                        showTipGround = true
                    end
                end
            end
        elseif spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_GROUND then
                if actionEventTipGround ~ = nil then
                    g_inputBinding:setActionEventText(actionEventTipGround.actionEventId, g_i18n:getText( "action_stopTipToGround" ))
                    showTipGround = true
                end
            else
                    if actionEventTip ~ = nil then
                        g_inputBinding:setActionEventText(actionEventTip.actionEventId, g_i18n:getText( "action_stopOverloading" ))
                        showTip = true
                    end
                end

                if actionEventTip ~ = nil then
                    g_inputBinding:setActionEventTextVisibility(actionEventTip.actionEventId, showTip)
                end
                if actionEventTipGround ~ = nil then
                    g_inputBinding:setActionEventTextVisibility(actionEventTipGround.actionEventId, showTipGround)
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
function Dischargeable:updateDebugValues(values)
    local spec = self.spec_dischargeable
    local currentDischargeNode = spec.currentDischargeNode

    local state = "OFF"
    if spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_OBJECT then
        state = "OBJECT"
    elseif spec.currentDischargeState = = Dischargeable.DISCHARGE_STATE_GROUND then
            state = "GROUND"
        end
        table.insert(values, { name = "state" , value = state } )
        table.insert(values, { name = "getCanDischargeToObject" , value = tostring( self:getCanDischargeToObject(currentDischargeNode)) } )
        table.insert(values, { name = "getCanDischargeToGround" , value = tostring( self:getCanDischargeToGround(currentDischargeNode)) } )
        table.insert(values, { name = "dischargedLiters" , value = tostring(spec.dischargedLiters) } )
        table.insert(values, { name = "currentNode" , value = tostring(currentDischargeNode) } )

        for _, dischargeNode in ipairs(spec.dischargeNodes) do
            table.insert(values, { name = "--->" , value = tostring(dischargeNode) } )
            local object = nil
            if dischargeNode.dischargeObject ~ = nil then
                object = tostring(dischargeNode.dischargeObject.configFileName)
            end
            table.insert(values, { name = "object" , value = tostring(object) } )
            table.insert(values, { name = "distance" , value = dischargeNode.dischargeDistance } )
            table.insert(values, { name = "effect" , value = tostring(dischargeNode.isEffectActive) } )
            table.insert(values, { name = "fillLevel" , value = tostring( self:getFillUnitFillLevel(dischargeNode.fillUnitIndex)) } )
            table.insert(values, { name = "litersToDrop" , value = tostring(dischargeNode.litersToDrop) } )
            table.insert(values, { name = "emptyFactor" , value = tostring( self:getDischargeNodeEmptyFactor(dischargeNode)) } )
            table.insert(values, { name = "emptySpeed" , value = tostring( self:getDischargeNodeEmptyFactor(dischargeNode)) } )
            table.insert(values, { name = "readyForDischarge" , value = tostring(dischargeNode.lastEffect = = nil or dischargeNode.lastEffect:getIsFullyVisible()) } )
            table.insert(values, { name = "objectsInTrigger" , value = tostring(dischargeNode.trigger.numObjects) } )
            table.insert(values, { name = "objectsInActivationTrigger" , value = tostring(dischargeNode.activationTrigger.numObjects) } )
        end
    end

```

### updateDischargeInfo

**Description**

**Definition**

> updateDischargeInfo()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | x             |
| any | y             |
| any | z             |

**Code**

```lua
function Dischargeable:updateDischargeInfo(dischargeNode, x, y, z)
    if dischargeNode.info.useRaycastHitPosition then
        setWorldTranslation(dischargeNode.info.node, x, y, z)
    end
end

```

### updateDischargeSound

**Description**

**Definition**

> updateDischargeSound()

**Arguments**

| any | dischargeNode |
|-----|---------------|
| any | dt            |

**Code**

```lua
function Dischargeable:updateDischargeSound(dischargeNode, dt)
    if self.isClient then
        local fillType = self:getDischargeFillType(dischargeNode)
        local isInDischargeState = self.spec_dischargeable.currentDischargeState ~ = Dischargeable.DISCHARGE_STATE_OFF
        local isEffectActive = dischargeNode.isEffectActive and fillType ~ = FillType.UNKNOWN
        local lastEffectVisible = dischargeNode.lastEffect = = nil or dischargeNode.lastEffect:getIsVisible()
        local effectsStillActive = dischargeNode.lastEffect ~ = nil and dischargeNode.lastEffect:getIsVisible()
        if ((isInDischargeState and isEffectActive) or effectsStillActive) and lastEffectVisible then
            -- shared sample
            if dischargeNode.playSound and fillType ~ = FillType.UNKNOWN then
                local sharedSample = g_fillTypeManager:getSampleByFillType(fillType)
                if sharedSample ~ = nil then
                    if sharedSample ~ = dischargeNode.sharedSample then
                        if dischargeNode.sample ~ = nil then
                            g_soundManager:deleteSample(dischargeNode.sample)
                        end

                        dischargeNode.sample = g_soundManager:cloneSample(sharedSample, dischargeNode.node or dischargeNode.soundNode, self )
                        dischargeNode.sharedSample = sharedSample

                        g_soundManager:playSample(dischargeNode.sample)
                    else
                            if not g_soundManager:getIsSamplePlaying(dischargeNode.sample) then
                                g_soundManager:playSample(dischargeNode.sample)
                            end
                        end
                    end
                end

                -- additional sample
                if dischargeNode.dischargeSample ~ = nil then
                    if not g_soundManager:getIsSamplePlaying(dischargeNode.dischargeSample) then
                        g_soundManager:playSample(dischargeNode.dischargeSample)
                    end
                end
                dischargeNode.turnOffSoundTimer = 250
            else
                    if dischargeNode.turnOffSoundTimer ~ = nil and dischargeNode.turnOffSoundTimer > 0 then
                        dischargeNode.turnOffSoundTimer = dischargeNode.turnOffSoundTimer - dt
                        if dischargeNode.turnOffSoundTimer < = 0 then
                            -- shared sample
                            if dischargeNode.playSound then
                                if g_soundManager:getIsSamplePlaying(dischargeNode.sample) then
                                    g_soundManager:stopSample(dischargeNode.sample)
                                end
                            end

                            -- additional sample
                            if dischargeNode.dischargeSample ~ = nil then
                                if g_soundManager:getIsSamplePlaying(dischargeNode.dischargeSample) then
                                    g_soundManager:stopSample(dischargeNode.dischargeSample)
                                end
                            end

                            dischargeNode.turnOffSoundTimer = 0
                        end
                    end
                end
            end
        end

```

### updateRaycast

**Description**

**Definition**

> updateRaycast()

**Arguments**

| any | dischargeNode |
|-----|---------------|

**Code**

```lua
function Dischargeable:updateRaycast(dischargeNode)
    local spec = self.spec_dischargeable
    local raycast = dischargeNode.raycast

    if raycast.node = = nil then
        return
    end

    dischargeNode.lastDischargeObject = dischargeNode.dischargeObject

    dischargeNode.raycastDischargeObject = nil
    dischargeNode.raycastDischargeHitObject = nil
    dischargeNode.raycastDischargeHitObjectUnitIndex = nil
    dischargeNode.raycastDischargeHitTerrain = false
    dischargeNode.raycastDischargeShape = nil
    dischargeNode.raycastDischargeDistance = math.huge
    dischargeNode.raycastDischargeFillUnitIndex = nil
    dischargeNode.raycastDischargeHit = false
    dischargeNode.raycastDischargeFailedReason = nil

    local x, y, z = getWorldTranslation(raycast.node)
    local dx, dy, dz = 0 , - 1 , 0

    y = y + raycast.yOffset

    if not raycast.useWorldNegYDirection then
        dx, dy, dz = localDirectionToWorld(raycast.node, 0 , - 1 , 0 )
    end

    spec.currentRaycastDischargeNode = dischargeNode
    spec.currentRaycast = raycast
    spec.isAsyncRaycastActive = true

    raycastAllAsync(x, y, z, dx, dy, dz, dischargeNode.maxDistance, "raycastCallbackDischargeNode" , self , spec.raycastCollisionMask)

    if VehicleDebug.state = = VehicleDebug.DEBUG then
        drawDebugLine(x, y, z, 0 , 1 , 0 , x + dx * dischargeNode.maxDistance, y + dy * dischargeNode.maxDistance, z + dz * dischargeNode.maxDistance, 0 , 1 , 0 , true )
    end
end

```