## Baler

**Description**

> Specialization for balers allowing to pickup swaths and create physical bale objects

**Functions**

- [actionControllerBaleUnloadEvent](#actioncontrollerbaleunloadevent)
- [actionEventToggleAutomaticDrop](#actioneventtoggleautomaticdrop)
- [actionEventToggleSize](#actioneventtogglesize)
- [actionEventUnloading](#actioneventunloading)
- [addToPhysics](#addtophysics)
- [createBale](#createbale)
- [createDummyBale](#createdummybale)
- [deleteDummyBale](#deletedummybale)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [dropBale](#dropbale)
- [dropBaleFromPlatform](#dropbalefromplatform)
- [externalActionEventAutomaticUnloadRegister](#externalactioneventautomaticunloadregister)
- [externalActionEventAutomaticUnloadUpdate](#externalactioneventautomaticunloadupdate)
- [externalActionEventBaleTypeRegister](#externalactioneventbaletyperegister)
- [externalActionEventBaleTypeUpdate](#externalactioneventbaletypeupdate)
- [externalActionEventUnloadRegister](#externalactioneventunloadregister)
- [externalActionEventUnloadUpdate](#externalactioneventunloadupdate)
- [finishBale](#finishbale)
- [getAlarmTriggerIsActive](#getalarmtriggerisactive)
- [getAllowDynamicMountFillLevelInfo](#getallowdynamicmountfilllevelinfo)
- [getBalerBaleOwnerFarmId](#getbalerbaleownerfarmid)
- [getCanBeSelected](#getcanbeselected)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getCanUnloadUnfinishedBale](#getcanunloadunfinishedbale)
- [getConsumingLoad](#getconsumingload)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getIsAttachedTo](#getisattachedto)
- [getIsBaleUnloading](#getisbaleunloading)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getRequiresPower](#getrequirespower)
- [getShowConsumableEmptyWarning](#getshowconsumableemptywarning)
- [getSpecValueBaleSize](#getspecvaluebalesize)
- [getSpecValueBaleSizeRound](#getspecvaluebalesizeround)
- [getSpecValueBaleSizeSquare](#getspecvaluebalesizesquare)
- [getTimeFromLevel](#gettimefromlevel)
- [handleUnloadingBaleEvent](#handleunloadingbaleevent)
- [initSpecialization](#initspecialization)
- [isUnloadingAllowed](#isunloadingallowed)
- [loadAlarmTrigger](#loadalarmtrigger)
- [loadSpecValueBaleSize](#loadspecvaluebalesize)
- [loadSpecValueBaleSizeRound](#loadspecvaluebalesizeround)
- [loadSpecValueBaleSizeSquare](#loadspecvaluebalesizesquare)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [moveBale](#movebale)
- [moveBales](#movebales)
- [onChangedFillType](#onchangedfilltype)
- [onConsumableVariationChanged](#onconsumablevariationchanged)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterExternalActionEvents](#onregisterexternalactionevents)
- [onRootVehicleChanged](#onrootvehiclechanged)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processBalerArea](#processbalerarea)
- [registerBalerXMLPaths](#registerbalerxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeFromPhysics](#removefromphysics)
- [saveToXMLFile](#savetoxmlfile)
- [setBalerAutomaticDrop](#setbalerautomaticdrop)
- [setBaleTime](#setbaletime)
- [setBaleTypeIndex](#setbaletypeindex)
- [setIsUnloadingBale](#setisunloadingbale)
- [updateActionEvents](#updateactionevents)
- [updateDummyBale](#updatedummybale)

### actionControllerBaleUnloadEvent

**Description**

**Definition**

> actionControllerBaleUnloadEvent()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function Baler:actionControllerBaleUnloadEvent(direction)
    if direction < 0 then
        local spec = self.spec_baler
        if self:isUnloadingAllowed() then
            if spec.allowsBaleUnloading then
                if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                    if #spec.bales > 0 then
                        self:setIsUnloadingBale( true )
                    end
                end
            end
        end
    end

    return true
end

```

### actionEventToggleAutomaticDrop

**Description**

**Definition**

> actionEventToggleAutomaticDrop()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Baler.actionEventToggleAutomaticDrop( self , actionName, inputValue, callbackState, isAnalog)
    self:setBalerAutomaticDrop()
end

```

### actionEventToggleSize

**Description**

**Definition**

> actionEventToggleSize()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Baler.actionEventToggleSize( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_baler

    local newIndex = spec.preSelectedBaleTypeIndex + 1
    if newIndex > #spec.baleTypes then
        newIndex = 1
    end

    self:setBaleTypeIndex(newIndex)
end

```

### actionEventUnloading

**Description**

**Definition**

> actionEventUnloading()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Baler.actionEventUnloading( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_baler
    if not spec.hasPlatform then
        self:handleUnloadingBaleEvent()
    else
            if self:getCanUnloadUnfinishedBale() and not spec.platformReadyToDrop then
                self:handleUnloadingBaleEvent()
            else
                    self:dropBaleFromPlatform( false )
                end
            end
        end

```

### addToPhysics

**Description**

> Add to physics

**Definition**

> addToPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Baler:addToPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    local spec = self.spec_baler
    local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]

    for baleIndex, bale in pairs(spec.bales) do
        local baleObject = bale.baleObject
        if baleObject ~ = nil then
            bale.baleObject:addToPhysics()

            if not spec.hasUnloadingAnimation then
                local constr = JointConstructor.new()
                constr:setActors(baleTypeDef.baleNodeComponent, baleObject.nodeId)
                constr:setJointTransforms(bale.baleJointNode, baleObject.nodeId)
                for i = 1 , 3 do
                    constr:setRotationLimit(i - 1 , 0 , 0 )
                    constr:setTranslationLimit(i - 1 , true , 0 , 0 )
                end
                constr:setEnableCollision( false )
                local baleJointIndex = constr:finalize()

                bale.baleJointIndex = baleJointIndex
                bale.baleObject = baleObject

                for otherBaleIndex, otherBale in pairs(spec.bales) do
                    if otherBaleIndex ~ = baleIndex then
                        setPairCollision(otherBale.baleObject.nodeId, baleObject.nodeId, false )
                    end
                end
            end
        end
    end

    return true
end

```

### createBale

**Description**

**Definition**

> createBale()

**Arguments**

| any | baleFillType     |
|-----|------------------|
| any | fillLevel        |
| any | baleServerId     |
| any | baleTime         |
| any | xmlFilename      |
| any | ownerFarmId      |
| any | variationId      |
| any | loadFromSavegame |

**Code**

```lua
function Baler:createBale(baleFillType, fillLevel, baleServerId, baleTime, xmlFilename, ownerFarmId, variationId, loadFromSavegame)
    local spec = self.spec_baler

    if spec.knotingAnimation ~ = nil and not loadFromSavegame then
        self:playAnimation(spec.knotingAnimation, spec.knotingAnimationSpeed, nil , true )
    end

    local isValid = false
    local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]

    -- only delete dummy bale if dummy bale is converted to physical one, not if loaded from savegame to a specific time
        if baleTime = = nil then
            self:deleteDummyBale(spec.dummyBale)
        end

        local bale = { }
        bale.filename = xmlFilename or spec.currentBaleXMLFilename
        bale.time = baleTime
        if bale.time = = nil and spec.baleAnimLength ~ = nil then
            bale.time = ((baleTypeDef.length * 0.5 ) / spec.baleAnimLength)
        end

        bale.fillType = baleFillType
        bale.fillLevel = fillLevel

        if spec.hasUnloadingAnimation then
            if not loadFromSavegame then
                self:updateConsumable( Baler.CONSUMABLE_TYPE_NAME_ROUND, - baleTypeDef.consumableUsage)
            end

            if self.isServer then
                local baleObject = Bale.new( self.isServer, self.isClient)
                local x, y, z = getWorldTranslation(baleTypeDef.baleRootNode)
                local rx, ry, rz = getWorldRotation(baleTypeDef.baleRootNode)
                if baleObject:loadFromConfigXML(bale.filename, x, y, z, rx, ry, rz) then
                    baleObject:setFillType(baleFillType)
                    baleObject:setFillLevel(fillLevel)
                    baleObject:setVariationId(variationId or spec.lastBaleVariationId or baleTypeDef.defaultBaleVariationId)

                    if ownerFarmId ~ = nil then
                        baleObject:setOwnerFarmId(ownerFarmId, true )
                    else
                            baleObject:setOwnerFarmId( self:getBalerBaleOwnerFarmId(x, z), true )
                        end

                        baleObject:register()

                        baleObject:mountKinematic( self , baleTypeDef.baleRootNode, 0 , 0 , 0 , 0 , 0 , 0 )

                        bale.baleObject = baleObject
                        isValid = true
                    end
                else
                        if baleServerId ~ = nil then
                            local baleObject = NetworkUtil.getObject(baleServerId)
                            if baleObject ~ = nil then
                                bale.baleServerId = baleServerId
                                baleObject:mountKinematic( self , baleTypeDef.baleRootNode, 0 , 0 , 0 , 0 , 0 , 0 )
                            else
                                    spec.baleToMount = { baleServerId = baleServerId, jointNode = baleTypeDef.baleRootNode, baleInfo = bale }
                                end

                                isValid = true
                            end
                        end
                    else
                            if not loadFromSavegame then
                                self:updateConsumable( Baler.CONSUMABLE_TYPE_NAME_SQUARE, - baleTypeDef.consumableUsage)
                            end
                        end

                        if self.isServer and not spec.hasUnloadingAnimation then
                            local x, y, z = getWorldTranslation(baleTypeDef.baleRootNode)
                            local rx, ry, rz = getWorldRotation(baleTypeDef.baleRootNode)

                            local baleJointNode = createTransformGroup( "BaleJointTG" )
                            link(baleTypeDef.baleRootNode, baleJointNode)

                            if bale.time ~ = nil then
                                x, y, z, rx, ry, rz = spec.baleAnimCurve:get(bale.time )
                                setTranslation(baleJointNode, x, y, z)
                                setRotation(baleJointNode, rx, ry, rz)

                                x, y, z = getWorldTranslation(baleJointNode)
                                rx, ry, rz = getWorldRotation(baleJointNode)
                            else
                                    setTranslation(baleJointNode, 0 , 0 , 0 )
                                    setRotation(baleJointNode, 0 , 0 , 0 )
                                end

                                local baleObject = Bale.new( self.isServer, self.isClient)
                                if baleObject:loadFromConfigXML(bale.filename, x, y, z, rx, ry, rz) then
                                    baleObject:setFillType(baleFillType)
                                    baleObject:setFillLevel(fillLevel)
                                    baleObject:setVariationId(variationId or spec.lastBaleVariationId or baleTypeDef.defaultBaleVariationId)

                                    if ownerFarmId ~ = nil then
                                        baleObject:setOwnerFarmId(ownerFarmId, true )
                                    else
                                            baleObject:setOwnerFarmId( self:getBalerBaleOwnerFarmId(x, z), true )
                                        end

                                        baleObject:register()
                                        baleObject:setCanBeSold( false )
                                        baleObject:setNeedsSaving( false )

                                        local constr = JointConstructor.new()
                                        constr:setActors(baleTypeDef.baleNodeComponent, baleObject.nodeId)
                                        constr:setJointTransforms(baleJointNode, baleObject.nodeId)
                                        for i = 1 , 3 do
                                            constr:setRotationLimit(i - 1 , 0 , 0 )
                                            constr:setTranslationLimit(i - 1 , true , 0 , 0 )
                                        end
                                        constr:setEnableCollision( false )
                                        local baleJointIndex = constr:finalize()

                                        bale.baleJointNode = baleJointNode
                                        bale.baleJointIndex = baleJointIndex
                                        bale.baleObject = baleObject

                                        baleObject.baleJointIndex = baleJointIndex

                                        for i = 1 , #spec.bales do
                                            local otherBale = spec.bales[i]
                                            setPairCollision(otherBale.baleObject.nodeId, baleObject.nodeId, false )
                                        end

                                        if not spec.baleAnimEnableCollision then
                                            setCollisionFilterMask(baleObject.nodeId, 0 )
                                        end

                                        isValid = true
                                    end
                                elseif not self.isServer and not spec.hasUnloadingAnimation then
                                        isValid = true
                                    end

                                    if isValid then
                                        table.insert(spec.bales, bale)
                                    end

                                    return isValid
                                end

```

### createDummyBale

**Description**

**Definition**

> createDummyBale()

**Arguments**

| any | dummyBaleData |
|-----|---------------|
| any | fillTypeIndex |

**Code**

```lua
function Baler:createDummyBale(dummyBaleData, fillTypeIndex)
    local spec = self.spec_baler

    if spec.currentBaleXMLFilename ~ = nil then
        local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]

        local baleId, sharedLoadRequestId = Bale.createDummyBale(spec.currentBaleXMLFilename, fillTypeIndex, baleTypeDef.chamberBaleVariationId)
        local linkNode = dummyBaleData.linkNode or baleTypeDef.baleNode
        link(linkNode, baleId)

        dummyBaleData.currentBale = baleId
        dummyBaleData.baleTypeDef = baleTypeDef
        dummyBaleData.currentBaleFillType = fillTypeIndex
        dummyBaleData.sharedLoadRequestId = sharedLoadRequestId
    end
end

```

### deleteDummyBale

**Description**

**Definition**

> deleteDummyBale()

**Arguments**

| any | dummyBaleData |
|-----|---------------|

**Code**

```lua
function Baler:deleteDummyBale(dummyBaleData)
    if dummyBaleData ~ = nil then
        if dummyBaleData.currentBale ~ = nil then
            delete(dummyBaleData.currentBale)
            dummyBaleData.currentBale = nil
        end
        if dummyBaleData.sharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile(dummyBaleData.sharedLoadRequestId)
            dummyBaleData.sharedLoadRequestId = nil
        end
    end
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
function Baler:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self:getIsTurnedOn() and self:getIsLowered())
end

```

### dropBale

**Description**

**Definition**

> dropBale()

**Arguments**

| any | baleIndex |
|-----|-----------|

**Code**

```lua
function Baler:dropBale(baleIndex)
    local spec = self.spec_baler
    local bale = spec.bales[baleIndex]

    if bale.baleObject ~ = nil then
        local mission = g_missionManager:getMissionByUniqueId(spec.workAreaParameters.lastMissionUniqueId)
        if mission ~ = nil then
            if mission.addBale ~ = nil then
                mission:addBale(bale.baleObject)
            end
        end
    end

    if self.isServer then
        local baleObject = bale.baleObject
        if bale.baleJointIndex ~ = nil then
            removeJoint(bale.baleJointIndex)
            delete(bale.baleJointNode)
        else
                baleObject:unmountKinematic()
            end

            if not spec.baleAnimEnableCollision then
                setCollisionFilterMask(baleObject.nodeId, CollisionPreset.BALE.mask)
            end

            for i = 1 , #spec.bales do
                if i ~ = baleIndex then
                    local otherBale = spec.bales[i]
                    setPairCollision(otherBale.baleObject.nodeId, baleObject.nodeId, true )
                end
            end

            if spec.lastBaleFillLevel ~ = nil and #spec.bales = = 1 then
                baleObject:setFillLevel(spec.lastBaleFillLevel)
                spec.lastBaleFillLevel = nil
            end

            baleObject.baleJointIndex = nil
            baleObject:setCanBeSold( true )
            baleObject:setNeedsSaving( true )

            if baleObject.nodeId ~ = nil and baleObject.nodeId ~ = 0 then
                local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]

                -- release bale
                local x,y,z = getWorldTranslation(baleObject.nodeId)
                local vx,vy,vz = getVelocityAtWorldPos(baleTypeDef.baleNodeComponent or self.components[ 1 ].node, x,y,z)
                setLinearVelocity(baleObject.nodeId, vx,vy,vz)

                g_farmManager:updateFarmStats( self:getBalerBaleOwnerFarmId(x, z), "baleCount" , 1 )
            end
        else
                if spec.hasUnloadingAnimation then
                    -- check if it is still available(it could already be picked up by a wrapper and be deleted)
                        local baleObject = NetworkUtil.getObject(bale.baleServerId)
                        if baleObject ~ = nil then
                            baleObject:unmountKinematic()
                        end
                    end
                end

                table.remove(spec.bales, baleIndex)

                if spec.hasPlatform then
                    if not spec.platformReadyToDrop then
                        spec.platformReadyToDrop = true
                    end

                    if spec.hasDynamicMountPlatform then
                        -- 5 frames delay to give the bale time to be added to physics and change from kinematic to dynamic
                        spec.platformMountDelay = 5
                    end
                end
            end

```

### dropBaleFromPlatform

**Description**

**Definition**

> dropBaleFromPlatform()

**Arguments**

| any | waitForNextBale |
|-----|-----------------|
| any | noEventSend     |

**Code**

```lua
function Baler:dropBaleFromPlatform(waitForNextBale, noEventSend)
    local spec = self.spec_baler
    if spec.platformReadyToDrop then
        self:setAnimationTime(spec.platformAnimation, 0 , false )
        self:playAnimation(spec.platformAnimation, 1 , self:getAnimationTime(spec.platformAnimation), true )
        if waitForNextBale = = true then
            self:setAnimationStopTime(spec.platformAnimation, spec.platformAnimationNextBaleTime)
        end
        spec.platformReadyToDrop = false
        spec.platformDropInProgress = true

        -- unmount bales on platform
        if self.isServer then
            if spec.hasDynamicMountPlatform then
                self:forceUnmountDynamicMountedObjects()
            end
        end
    end

    BalerDropFromPlatformEvent.sendEvent( self , waitForNextBale, noEventSend)
end

```

### externalActionEventAutomaticUnloadRegister

**Description**

**Definition**

> externalActionEventAutomaticUnloadRegister()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Baler.externalActionEventAutomaticUnloadRegister(data, vehicle)
    local function actionEvent(_, actionName, inputValue, callbackState, isAnalog)
        Baler.actionEventToggleAutomaticDrop(vehicle, actionName, inputValue, callbackState, isAnalog)
    end

    local _
    _, data.actionEventId = g_inputBinding:registerActionEvent(InputAction.IMPLEMENT_EXTRA4, data, actionEvent, false , true , false , true )
    g_inputBinding:setActionEventTextPriority(data.actionEventId, GS_PRIO_HIGH)
end

```

### externalActionEventAutomaticUnloadUpdate

**Description**

**Definition**

> externalActionEventAutomaticUnloadUpdate()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Baler.externalActionEventAutomaticUnloadUpdate(data, vehicle)
    local spec = vehicle.spec_baler

    local automaticDropState = spec.automaticDrop
    if spec.hasPlatform then
        automaticDropState = spec.platformAutomaticDrop
    end
    g_inputBinding:setActionEventText(data.actionEventId, automaticDropState and spec.toggleAutomaticDropTextNeg or spec.toggleAutomaticDropTextPos)
end

```

### externalActionEventBaleTypeRegister

**Description**

**Definition**

> externalActionEventBaleTypeRegister()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Baler.externalActionEventBaleTypeRegister(data, vehicle)
    local function actionEvent(_, actionName, inputValue, callbackState, isAnalog)
        Baler.actionEventToggleSize(vehicle, actionName, inputValue, callbackState, isAnalog)
    end

    local _
    _, data.actionEventId = g_inputBinding:registerActionEvent(InputAction.TOGGLE_BALE_TYPES, data, actionEvent, false , true , false , true )
    g_inputBinding:setActionEventTextPriority(data.actionEventId, GS_PRIO_HIGH)
end

```

### externalActionEventBaleTypeUpdate

**Description**

**Definition**

> externalActionEventBaleTypeUpdate()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Baler.externalActionEventBaleTypeUpdate(data, vehicle)
    local spec = vehicle.spec_baler
    local baleTypeDef = spec.baleTypes[spec.preSelectedBaleTypeIndex]
    local baleSize
    if spec.hasUnloadingAnimation then
        baleSize = baleTypeDef.diameter
    else
            baleSize = baleTypeDef.length
        end

        g_inputBinding:setActionEventText(data.actionEventId, spec.changeBaleTypeText:format(baleSize * 100 ))
    end

```

### externalActionEventUnloadRegister

**Description**

**Definition**

> externalActionEventUnloadRegister()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Baler.externalActionEventUnloadRegister(data, vehicle)
    local function actionEvent(_, actionName, inputValue, callbackState, isAnalog)
        if not vehicle.spec_baler.automaticDrop then
            Baler.actionEventUnloading(vehicle, actionName, inputValue, callbackState, isAnalog)
        end
    end

    local _
    _, data.actionEventId = g_inputBinding:registerActionEvent(InputAction.IMPLEMENT_EXTRA3, data, actionEvent, false , true , false , true )
    g_inputBinding:setActionEventTextPriority(data.actionEventId, GS_PRIO_HIGH)
end

```

### externalActionEventUnloadUpdate

**Description**

**Definition**

> externalActionEventUnloadUpdate()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Baler.externalActionEventUnloadUpdate(data, vehicle)
    local spec = vehicle.spec_baler

    local showAction = false

    if vehicle:isUnloadingAllowed() then
        if spec.hasUnloadingAnimation or spec.allowsBaleUnloading then
            if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                if vehicle:getCanUnloadUnfinishedBale() then
                    g_inputBinding:setActionEventText(data.actionEventId, spec.texts.unloadUnfinishedBale)
                    showAction = true
                end
                if #spec.bales > 0 then
                    g_inputBinding:setActionEventText(data.actionEventId, spec.texts.unloadBaler)
                    showAction = true
                end
            elseif spec.unloadingState = = Baler.UNLOADING_OPEN then
                    if spec.hasUnloadingAnimation then
                        g_inputBinding:setActionEventText(data.actionEventId, spec.texts.closeBack)
                        showAction = true
                    end
                end
            end
        end

        if spec.platformReadyToDrop then
            g_inputBinding:setActionEventText(data.actionEventId, spec.texts.unloadBaler)
            showAction = true
        end

        g_inputBinding:setActionEventActive(data.actionEventId, showAction)
    end

```

### finishBale

**Description**

**Definition**

> finishBale()

**Code**

```lua
function Baler:finishBale()
    local spec = self.spec_baler
    if spec.baleTypes ~ = nil then
        local fillTypeIndex = self:getFillUnitFillType(spec.fillUnitIndex)
        if not spec.hasUnloadingAnimation then
            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - math.huge, fillTypeIndex, ToolType.UNDEFINED)
            spec.buffer.unloadingStarted = false

            for fillType, _ in pairs(spec.pickupFillTypes) do
                spec.pickupFillTypes[fillType] = 0
            end

            if self:createBale(fillTypeIndex, self:getFillUnitCapacity(spec.fillUnitIndex)) then
                local bale = spec.bales[#spec.bales]

                -- note:spec.bales[numBales] can not be accessed anymore since the bale might be dropped already
                g_server:broadcastEvent( BalerCreateBaleEvent.new( self , fillTypeIndex, bale.time ), nil , nil , self )

                if self:getFillUnitFillLevel(spec.fillUnitIndex) = = 0 then
                    if spec.preSelectedBaleTypeIndex ~ = spec.currentBaleTypeIndex then
                        self:setBaleTypeIndex(spec.preSelectedBaleTypeIndex, true )
                    end
                end
            else
                    Logging.error( "Failed to create bale!" )
                end
            else
                    if self:createBale(fillTypeIndex, self:getFillUnitCapacity(spec.fillUnitIndex)) then
                        local bale = spec.bales[#spec.bales]
                        g_server:broadcastEvent( BalerCreateBaleEvent.new( self , fillTypeIndex, 0 , NetworkUtil.getObjectId(bale.baleObject)), nil , nil , self )
                    else
                            Logging.error( "Failed to create bale!" )
                        end
                    end
                end
            end

```

### getAlarmTriggerIsActive

**Description**

**Definition**

> getAlarmTriggerIsActive()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | alarmTrigger |

**Code**

```lua
function Baler:getAlarmTriggerIsActive(superFunc, alarmTrigger)
    local ret = superFunc( self , alarmTrigger)

    if alarmTrigger.needsBaleLoaded then
        if self.spec_baler ~ = nil then
            if # self.spec_baler.bales = = 0 then
                return false
            end
        end
    end

    return ret
end

```

### getAllowDynamicMountFillLevelInfo

**Description**

**Definition**

> getAllowDynamicMountFillLevelInfo()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Baler:getAllowDynamicMountFillLevelInfo(superFunc)
    return false
end

```

### getBalerBaleOwnerFarmId

**Description**

> Returns the current owner of the created bales

**Definition**

> getBalerBaleOwnerFarmId()

**Arguments**

| any | x |
|-----|---|
| any | z |

**Code**

```lua
function Baler:getBalerBaleOwnerFarmId(x, z)
    local spec = self.spec_baler
    local ownerFarmId
    if spec.useDropLandOwnershipForBales then
        local farmlandId = g_farmlandManager:getFarmlandIdAtWorldPosition(x, z)
        ownerFarmId = g_farmlandManager:getFarmlandOwner(farmlandId)
    else
            ownerFarmId = self:getLastTouchedFarmlandFarmId()
        end

        if ownerFarmId = = FarmManager.SPECTATOR_FARM_ID then
            ownerFarmId = self:getOwnerFarmId() -- in case of working on mission fields or the baler is dropped on a not buyable land
        end

        return ownerFarmId
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
function Baler:getCanBeSelected(superFunc)
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
function Baler:getCanBeTurnedOn(superFunc)
    local spec = self.spec_baler

    if spec.isBaleUnloading then
        return false
    end

    return superFunc( self )
end

```

### getCanUnloadUnfinishedBale

**Description**

**Definition**

> getCanUnloadUnfinishedBale()

**Code**

```lua
function Baler:getCanUnloadUnfinishedBale()
    local spec = self.spec_baler

    local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
    if spec.buffer.fillUnitIndex ~ = nil then
        fillLevel = fillLevel + self:getFillUnitFillLevel(spec.buffer.fillUnitIndex)
    end

    return spec.canUnloadUnfinishedBale and fillLevel > spec.unfinishedBaleThreshold
end

```

### getConsumingLoad

**Description**

**Definition**

> getConsumingLoad()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Baler:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local spec = self.spec_baler
    local loadPercentage = spec.pickUpLitersBuffer:get( 1000 ) / spec.maxPickupLitersPerSecond

    return value + loadPercentage, count + 1
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function Baler.getDefaultSpeedLimit()
    return 25
end

```

### getIsAttachedTo

**Description**

**Definition**

> getIsAttachedTo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | vehicle   |

**Code**

```lua
function Baler:getIsAttachedTo(superFunc, vehicle)
    if superFunc( self , vehicle) then
        return true
    end

    local spec = self.spec_baler
    for i = 1 , #spec.bales do
        if spec.bales[i].baleObject = = vehicle then
            return true
        end
    end

    return false
end

```

### getIsBaleUnloading

**Description**

**Definition**

> getIsBaleUnloading()

**Code**

```lua
function Baler:getIsBaleUnloading()
    return self.spec_baler.isBaleUnloading
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
function Baler:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_baler

    if #spec.bales > 0 and self:getFillUnitFillLevel(spec.fillUnitIndex) > spec.baleFoldThreshold then
        return false , spec.texts.warningFoldingBaleLoaded
    end

    if #spec.bales > 1 then
        return false , spec.texts.warningFoldingBaleLoaded
    end

    if self:getIsTurnedOn() then
        return false , spec.texts.warningFoldingTurnedOn
    end

    if spec.hasPlatform then
        if spec.platformReadyToDrop or spec.platformDropInProgress then
            return false , spec.texts.warningFoldingBaleLoaded
        end
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsSpeedRotatingPartActive

**Description**

**Definition**

> getIsSpeedRotatingPartActive()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |

**Code**

```lua
function Baler:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    local spec = self.spec_baler

    if speedRotatingPart.rotateOnlyIfFillLevelIncreased ~ = nil then
        if speedRotatingPart.rotateOnlyIfFillLevelIncreased and spec.lastAreaBiggerZeroTime = = 0 then
            return false
        end
    end

    return superFunc( self , speedRotatingPart)
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
function Baler:getIsWorkAreaActive(superFunc, workArea)
    local spec = self.spec_baler

    if not g_currentMission.slotSystem:getCanAddLimitedObjects(SlotSystem.LIMITED_OBJECT_BALE, 1 ) and self:getIsTurnedOn() then
        return false
    end

    if self:getFillUnitFreeCapacity(spec.buffer.fillUnitIndex or spec.fillUnitIndex) = = 0 then
        return false
    end

    if self.allowPickingUp ~ = nil and not self:allowPickingUp() then
        return false
    end

    if not self:getConsumableIsAvailable( Baler.CONSUMABLE_TYPE_NAME_ROUND)
        or not self:getConsumableIsAvailable( Baler.CONSUMABLE_TYPE_NAME_SQUARE) then
        return false
    end

    if spec.hasUnloadingAnimation and not spec.nonStopBaling then
        if #spec.bales > 0 or spec.unloadingState ~ = Baler.UNLOADING_CLOSED then
            return false
        end
    end

    return superFunc( self , workArea)
end

```

### getRequiresPower

**Description**

**Definition**

> getRequiresPower()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Baler:getRequiresPower(superFunc)
    local spec = self.spec_baler

    if spec.nonStopBaling then
        local bufferFillLevelPercentage = self:getFillUnitFillLevelPercentage(spec.buffer.fillUnitIndex)
        if bufferFillLevelPercentage > spec.buffer.overloadingStartFillLevelPct then
            return true
        end

        if spec.buffer.unloadingStarted then
            return true
        end
    end

    if spec.unloadingState ~ = Baler.UNLOADING_CLOSED then
        return true
    end

    if self:getIsTurnedOn() then
        return true
    end

    return superFunc( self )
end

```

### getShowConsumableEmptyWarning

**Description**

**Definition**

> getShowConsumableEmptyWarning()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | typeName  |

**Code**

```lua
function Baler:getShowConsumableEmptyWarning(superFunc, typeName)
    if typeName = = Baler.CONSUMABLE_TYPE_NAME_ROUND or typeName = = Baler.CONSUMABLE_TYPE_NAME_SQUARE then
        return self:getIsTurnedOn() and superFunc( self , typeName)
    end

    return superFunc( self , typeName)
end

```

### getSpecValueBaleSize

**Description**

**Definition**

> getSpecValueBaleSize()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |
| any | roundBale      |

**Code**

```lua
function Baler.getSpecValueBaleSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange, roundBale)
    local baleSizeAttributes = roundBale and storeItem.specs.balerBaleSizeRound or storeItem.specs.balerBaleSizeSquare
    if baleSizeAttributes ~ = nil then
        local minValue = baleSizeAttributes.isRoundBaler and baleSizeAttributes.minDiameter or baleSizeAttributes.minLength
        local maxValue = baleSizeAttributes.isRoundBaler and baleSizeAttributes.maxDiameter or baleSizeAttributes.maxLength

        if returnValues = = nil or not returnValues then
            local unit = g_i18n:getText( "unit_cmShort" )
            local size
            if maxValue ~ = minValue then
                size = string.format( "%d%s-%d%s" , minValue * 100 , unit, maxValue * 100 , unit)
            else
                    size = string.format( "%d%s" , minValue * 100 , unit)
                end

                return size
            else
                    if returnRange = = true and maxValue ~ = minValue then
                        return minValue * 100 , maxValue * 100 , g_i18n:getText( "unit_cmShort" )
                    else
                            return minValue * 100 , g_i18n:getText( "unit_cmShort" )
                        end
                    end
                else
                        if returnValues and returnRange then
                            return 0 , 0 , ""
                        elseif returnValues then
                                return 0 , ""
                            else
                                    return ""
                                end
                            end
                        end

```

### getSpecValueBaleSizeRound

**Description**

**Definition**

> getSpecValueBaleSizeRound()

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
function Baler.getSpecValueBaleSizeRound(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.balerBaleSizeRound ~ = nil then
        if storeItem.specs.balerBaleSizeRound.isRoundBaler then
            return Baler.getSpecValueBaleSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange, true )
        end
    end

    return nil
end

```

### getSpecValueBaleSizeSquare

**Description**

**Definition**

> getSpecValueBaleSizeSquare()

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
function Baler.getSpecValueBaleSizeSquare(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    if storeItem.specs.balerBaleSizeSquare ~ = nil then
        if not storeItem.specs.balerBaleSizeSquare.isRoundBaler then
            return Baler.getSpecValueBaleSize(storeItem, realItem, configurations, saleItem, returnValues, returnRange, false )
        end
    end

    return nil
end

```

### getTimeFromLevel

**Description**

**Definition**

> getTimeFromLevel()

**Arguments**

| any | level |
|-----|-------|

**Code**

```lua
function Baler:getTimeFromLevel(level)
    local spec = self.spec_baler

    -- level = capacity -> time = firstBaleMarker
    -- level = 0 -> time = 0
    if spec.currentBaleTypeDefinition ~ = nil then
        local baleLength = spec.currentBaleTypeDefinition.length + spec.baleAnimSpacing
        return level / self:getFillUnitCapacity(spec.fillUnitIndex) * (baleLength / spec.baleAnimLength)
    end
    return 0
end

```

### handleUnloadingBaleEvent

**Description**

**Definition**

> handleUnloadingBaleEvent()

**Code**

```lua
function Baler:handleUnloadingBaleEvent()
    local spec = self.spec_baler
    if self:isUnloadingAllowed() then
        if spec.hasUnloadingAnimation or spec.allowsBaleUnloading then
            if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                if #spec.bales > 0 or self:getCanUnloadUnfinishedBale() then
                    self:setIsUnloadingBale( true )
                end
            elseif spec.unloadingState = = Baler.UNLOADING_OPEN then
                    if spec.hasUnloadingAnimation then
                        self:setIsUnloadingBale( false )
                    end
                end
            end
        end
    end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Baler.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "baler" , g_i18n:getText( "shop_configuration" ), "baler" , VehicleConfigurationItem )

    AIFieldWorker.registerDriveStrategy( function (vehicle)
        return SpecializationUtil.hasSpecialization( Baler , vehicle.specializations)
    end , AIDriveStrategyBaler )

    g_workAreaTypeManager:addWorkAreaType( "baler" , false , false , true )

    g_storeManager:addSpecType( "balerBaleSizeRound" , "shopListAttributeIconBaleSizeRound" , Baler.loadSpecValueBaleSizeRound, Baler.getSpecValueBaleSizeRound, StoreSpecies.VEHICLE)
    g_storeManager:addSpecType( "balerBaleSizeSquare" , "shopListAttributeIconBaleSizeSquare" , Baler.loadSpecValueBaleSizeSquare, Baler.getSpecValueBaleSizeSquare, StoreSpecies.VEHICLE)

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Baler" )

    Baler.registerBalerXMLPaths(schema, "vehicle.baler" )
    Baler.registerBalerXMLPaths(schema, "vehicle.baler.balerConfigurations.balerConfiguration(?)" )

    schema:register(XMLValueType.BOOL, FillUnit.ALARM_TRIGGER_XML_KEY .. "#needsBaleLoaded" , "Alarm triggers only when a full bale is loaded" , false )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).baler#numBales" , "Number of bales" )
    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).baler.bale(?)#filename" , "XML Filename of bale" )
    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).baler.bale(?)#variationId" , "Variation ID of the bale" )
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).baler.bale(?)#ownerFarmId" , "Owner of the bale" )
    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).baler.bale(?)#fillType" , "Bale fill type index" )
    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).baler.bale(?)#fillLevel" , "Bale fill level" )
    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).baler.bale(?)#baleTime" , "Bale time" )

    schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).baler#platformReadyToDrop" , "Platform is ready to drop" , false )
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).baler#baleTypeIndex" , "Current bale type index" , 1 )
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).baler#preSelectedBaleTypeIndex" , "Pre selected bale type index" , 1 )
    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).baler#fillUnitCapacity" , "Current baler capacity depending on bale size" )
    schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).baler#bufferUnloadingStarted" , "Baler buffer unloading in progress" )
    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?).baler#workAreaMissionUniqueId" , "Workarea mission unique id" )
end

```

### isUnloadingAllowed

**Description**

**Definition**

> isUnloadingAllowed()

**Code**

```lua
function Baler:isUnloadingAllowed()
    local spec = self.spec_baler

    if spec.platformReadyToDrop or spec.platformDropInProgress then
        -- block only opening of baler
        if spec.unloadingState ~ = Baler.UNLOADING_OPEN then
            return false
        end
    end

    if self.spec_baleWrapper = = nil then
        return not spec.allowsBaleUnloading or(spec.allowsBaleUnloading and not self:getIsTurnedOn() and not spec.isBaleUnloading)
    end

    return self:allowsGrabbingBale()
end

```

### loadAlarmTrigger

**Description**

**Definition**

> loadAlarmTrigger()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | xmlFile      |
| any | key          |
| any | alarmTrigger |
| any | fillUnit     |

**Code**

```lua
function Baler:loadAlarmTrigger(superFunc, xmlFile, key, alarmTrigger, fillUnit)
    local ret = superFunc( self , xmlFile, key, alarmTrigger, fillUnit)

    alarmTrigger.needsBaleLoaded = xmlFile:getValue(key .. "#needsBaleLoaded" , false )

    return ret
end

```

### loadSpecValueBaleSize

**Description**

**Definition**

> loadSpecValueBaleSize()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Baler.loadSpecValueBaleSize(xmlFile, customEnvironment, baseDir)
    local rootName = xmlFile:getRootName()

    local baleSizeAttributes = { }
    baleSizeAttributes.isRoundBaler = false
    baleSizeAttributes.minDiameter, baleSizeAttributes.maxDiameter = math.huge, - math.huge
    baleSizeAttributes.minLength, baleSizeAttributes.maxLength = math.huge, - math.huge
    xmlFile:iterate(rootName .. ".baler.baleTypes.baleType" , function (_, key)
        baleSizeAttributes.isRoundBaler = xmlFile:getValue(key .. "#isRoundBale" , baleSizeAttributes.isRoundBaler)
        local diameter = MathUtil.round(xmlFile:getValue(key .. "#diameter" , 0 ), 2 )
        baleSizeAttributes.minDiameter = math.min(baleSizeAttributes.minDiameter, diameter)
        baleSizeAttributes.maxDiameter = math.max(baleSizeAttributes.maxDiameter, diameter)

        local length = MathUtil.round(xmlFile:getValue(key .. "#length" , 0 ), 2 )
        baleSizeAttributes.minLength = math.min(baleSizeAttributes.minLength, length)
        baleSizeAttributes.maxLength = math.max(baleSizeAttributes.maxLength, length)
    end )

    if baleSizeAttributes.minDiameter ~ = math.huge or baleSizeAttributes.minLength ~ = math.huge then
        return baleSizeAttributes
    end

    return nil
end

```

### loadSpecValueBaleSizeRound

**Description**

**Definition**

> loadSpecValueBaleSizeRound()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Baler.loadSpecValueBaleSizeRound(xmlFile, customEnvironment, baseDir)
    local baleSizeAttributes = Baler.loadSpecValueBaleSize(xmlFile, customEnvironment, baseDir)
    if baleSizeAttributes ~ = nil and baleSizeAttributes.isRoundBaler then
        return baleSizeAttributes
    end

    return nil
end

```

### loadSpecValueBaleSizeSquare

**Description**

**Definition**

> loadSpecValueBaleSizeSquare()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function Baler.loadSpecValueBaleSizeSquare(xmlFile, customEnvironment, baseDir)
    local baleSizeAttributes = Baler.loadSpecValueBaleSize(xmlFile, customEnvironment, baseDir)
    if baleSizeAttributes ~ = nil and not baleSizeAttributes.isRoundBaler then
        return baleSizeAttributes
    end

    return nil
end

```

### loadSpeedRotatingPartFromXML

**Description**

**Definition**

> loadSpeedRotatingPartFromXML()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |
| any | xmlFile           |
| any | key               |

**Code**

```lua
function Baler:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    speedRotatingPart.rotateOnlyIfFillLevelIncreased = xmlFile:getValue(key .. "#rotateOnlyIfFillLevelIncreased" , false )

    return superFunc( self , speedRotatingPart, xmlFile, key)
end

```

### moveBale

**Description**

**Definition**

> moveBale()

**Arguments**

| any | i           |
|-----|-------------|
| any | dt          |
| any | noEventSend |

**Code**

```lua
function Baler:moveBale(i, dt, noEventSend)
    local spec = self.spec_baler

    local bale = spec.bales[i]
    self:setBaleTime(i, bale.time + dt, noEventSend)
end

```

### moveBales

**Description**

**Definition**

> moveBales()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Baler:moveBales(dt)
    local spec = self.spec_baler

    for i = #spec.bales, 1 , - 1 do
        self:moveBale(i, dt)
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
function Baler:onChangedFillType(fillUnitIndex, fillTypeIndex, oldFillTypeIndex)
    local spec = self.spec_baler

    if fillUnitIndex = = spec.fillUnitIndex or fillUnitIndex = = spec.buffer.fillUnitIndex then
        -- always priorize the fill type of the main unit(if available) to choose the current bale index
            local mainFillTypeIndex = self:getFillUnitFillType(spec.fillUnitIndex)
            if mainFillTypeIndex ~ = FillType.UNKNOWN then
                fillTypeIndex = mainFillTypeIndex
            end

            if fillTypeIndex ~ = FillType.UNKNOWN then
                local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]
                spec.currentBaleTypeDefinition = baleTypeDef

                spec.currentBaleXMLFilename, spec.currentBaleIndex = g_baleManager:getBaleXMLFilename(fillTypeIndex,
                baleTypeDef.isRoundBale,
                baleTypeDef.width,
                baleTypeDef.height,
                baleTypeDef.length,
                baleTypeDef.diameter,
                self.customEnvironment)

                local baleCapacity = g_baleManager:getBaleCapacityByBaleIndex(spec.currentBaleIndex, fillTypeIndex)
                if fillUnitIndex = = spec.fillUnitIndex then
                    self:setFillUnitCapacity(fillUnitIndex, baleCapacity, false )
                else
                        if spec.buffer.capacityPercentage ~ = nil then
                            self:setFillUnitCapacity(fillUnitIndex, baleCapacity * spec.buffer.capacityPercentage, false )
                        end
                    end

                    ObjectChangeUtil.setObjectChanges(baleTypeDef.changeObjects, true , self , self.setMovingToolDirty)

                    if spec.currentBaleXMLFilename = = nil then
                        Logging.warning( "Could not find bale for given bale type definition '%s'" , baleTypeDef.index)
                        end
                    end
                end
            end

```

### onConsumableVariationChanged

**Description**

> Called while the consumable variation changed on the consum slots

**Definition**

> onConsumableVariationChanged()

**Arguments**

| any | variationIndex |
|-----|----------------|
| any | metaData       |

**Code**

```lua
function Baler:onConsumableVariationChanged(variationIndex, metaData)
    if metaData.bale_variation ~ = nil then
        local spec = self.spec_baler
        spec.lastBaleVariationId = metaData.bale_variation
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function Baler:onDelete()
    local spec = self.spec_baler

    if spec.bales ~ = nil then
        local dropBales = spec.dropBalesOnDelete or spec.dropBalesOnDelete = = nil
        -- if the baler was sold we drop the bales
            -- if vehicle is reconfigurated the bales are deleted with vehicle visuals
                if dropBales and( self.isReconfigurating = = nil or not self.isReconfigurating) then
                    for k, _ in pairs(spec.bales) do
                        self:dropBale(k)
                    end
                else
                        for _, bale in pairs(spec.bales) do
                            if bale.baleObject ~ = nil then
                                bale.baleObject:delete()
                            end
                        end
                    end
                end

                self:deleteDummyBale(spec.dummyBale)

                if spec.buffer ~ = nil then
                    if spec.buffer.dummyBale.available then
                        self:deleteDummyBale(spec.buffer.dummyBale)
                    end
                    g_soundManager:deleteSamples(spec.buffer.samplesOverloadingStart)
                    g_soundManager:deleteSamples(spec.buffer.samplesOverloadingWork)
                    g_soundManager:deleteSamples(spec.buffer.samplesOverloadingStop)
                    g_effectManager:deleteEffects(spec.buffer.overloadingEffects)
                    g_animationManager:deleteAnimations(spec.buffer.overloadingAnimationNodes)
                end

                g_soundManager:deleteSamples(spec.samples)
                g_effectManager:deleteEffects(spec.fillEffects)
                g_effectManager:deleteEffects(spec.additiveEffects)
                g_animationManager:deleteAnimations(spec.animationNodes)
                g_animationManager:deleteAnimations(spec.unloadAnimationNodes)
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
function Baler:onEndWorkAreaProcessing(dt, hasProcessed)
    local spec = self.spec_baler

    if self.isServer then
        local maxFillType = FillType.UNKNOWN
        local maxFillTypeFillLevel = 0
        for fillTypeIndex, fillLevel in pairs(spec.pickupFillTypes) do
            if fillLevel > maxFillTypeFillLevel then
                maxFillType = fillTypeIndex
                maxFillTypeFillLevel = fillLevel
            end
        end

        local pickedUpLiters = spec.workAreaParameters.lastPickedUpLiters
        if pickedUpLiters > 0 then
            spec.lastAreaBiggerZero = true

            local deltaLevel = pickedUpLiters * spec.fillScale

            spec.variableSpeedLimit.pickupPerSecond = spec.variableSpeedLimit.pickupPerSecond + deltaLevel

            if not spec.hasUnloadingAnimation then
                -- move all bales
                local deltaTime = self:getTimeFromLevel(deltaLevel)
                self:moveBales(deltaTime)
            end

            local fillUnitIndex = spec.fillUnitIndex
            if spec.nonStopBaling then
                if not spec.buffer.fillMainUnitAfterOverload or not spec.buffer.unloadingStarted then
                    fillUnitIndex = spec.buffer.fillUnitIndex
                else
                        if self:getFillUnitFreeCapacity(spec.fillUnitIndex) < = 0 then
                            fillUnitIndex = spec.buffer.fillUnitIndex
                        end
                    end
                end

                if spec.buffer.loadingStateAnimation ~ = nil then
                    local animTime = self:getAnimationTime(spec.buffer.loadingStateAnimation)
                    if fillUnitIndex = = spec.fillUnitIndex then
                        if animTime > = 0.99 then
                            self:playAnimation(spec.buffer.loadingStateAnimation, - spec.buffer.loadingStateAnimationSpeed)
                        end
                    else
                            if animTime < = 0.01 then
                                self:playAnimation(spec.buffer.loadingStateAnimation, spec.buffer.loadingStateAnimationSpeed)
                            end
                        end
                    end

                    self:setFillUnitFillType(fillUnitIndex, maxFillType)
                    self:addFillUnitFillLevel( self:getOwnerFarmId(), fillUnitIndex, deltaLevel, maxFillType, ToolType.UNDEFINED)
                end

                if spec.lastAreaBiggerZero ~ = spec.lastAreaBiggerZeroSent then
                    self:raiseDirtyFlags(spec.dirtyFlag)
                    spec.lastAreaBiggerZeroSent = spec.lastAreaBiggerZero
                end

                if spec.fillEffectType ~ = spec.fillEffectTypeSent then
                    spec.fillEffectTypeSent = spec.fillEffectType
                    self:raiseDirtyFlags(spec.dirtyFlag)
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
| any | fillTypeIndex    |
| any | toolType         |
| any | fillPositionData |
| any | appliedDelta     |

**Code**

```lua
function Baler:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_baler

    if fillUnitIndex = = spec.fillUnitIndex then
        local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]

        local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
        local capacity = self:getFillUnitCapacity(spec.fillUnitIndex)

        if self:updateDummyBale(spec.dummyBale, fillTypeIndex, fillLevel, capacity) then
            for i = 1 , #spec.baleTypes do
                self:setAnimationTime(spec.baleTypes[i].animations.fill, 0 )
            end
        end

        if fillLevel > 0 then
            self:setAnimationTime(baleTypeDef.animations.fill, fillLevel / capacity)
        end

        -- create bale
        if self.isServer then
            if fillLevelDelta > 0 then
                if self:getFillUnitFreeCapacity(spec.fillUnitIndex) < = 0 then
                    if self.isAddedToPhysics then
                        self:finishBale()
                    else
                            -- if the baler is not added to physic(e.g.on load) we create the bale delayed, so we can mount it directly
                                spec.createBaleNextFrame = true
                            end

                            spec.fillUnitOverflowFillLevel = fillLevelDelta - appliedDelta
                        else
                                -- fill level that is too much for the last bale will be added to the next bale(independent of the filltype)
                                    if spec.fillUnitOverflowFillLevel > 0 then
                                        if fillLevelDelta > 0 then
                                            local overflow = spec.fillUnitOverflowFillLevel
                                            spec.fillUnitOverflowFillLevel = 0
                                            overflow = overflow - self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, overflow, fillTypeIndex, toolType)
                                            spec.fillUnitOverflowFillLevel = overflow
                                        end
                                    end
                                end
                            end
                        end
                    elseif spec.nonStopBaling and fillUnitIndex = = spec.buffer.fillUnitIndex then
                            if spec.buffer.dummyBale.available then
                                local fillLevel = self:getFillUnitFillLevel(spec.buffer.fillUnitIndex)
                                local capacity = self:getFillUnitCapacity(spec.buffer.fillUnitIndex)

                                if spec.buffer.overloadAnimation ~ = nil then
                                    if self:getAnimationTime(spec.buffer.overloadAnimation) > 0 and fillLevel > 0 then
                                        return
                                    end
                                end

                                self:updateDummyBale(spec.buffer.dummyBale, fillTypeIndex, fillLevel, capacity)
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
function Baler:onLoad(savegame)
    local spec = self.spec_baler

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.fillScale#value" , "vehicle.baler#fillScale" ) --FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.turnedOnRotationNodes.turnedOnRotationNode#type" , "vehicle.baler.animationNodes.animationNode" , "baler" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.balingAnimation#name" , "vehicle.turnOnVehicle.turnedOnAnimation#name" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.fillParticleSystems" , "vehicle.baler.fillEffect with effectClass 'ParticleEffect'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.uvScrollParts.uvScrollPart" , "vehicle.baler.animationNodes.animationNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.balerAlarm" , "vehicle.fillUnit.fillUnitConfigurations.fillUnitConfiguration.fillUnits.fillUnit.alarmTriggers.alarmTrigger.alarmSound" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#node" , "vehicle.baler.baleTypes.baleType#baleNode" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#baleNode" , "vehicle.baler.baleTypes.baleType#baleNode" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#scaleNode" , "vehicle.baler.baleTypes.baleType#scaleNode" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#baleScaleComponent" , "vehicle.baler.baleTypes.baleType#scaleComponents" ) --FS19 to FS22

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#unloadAnimationName" , "vehicle.baler.baleTypes.baleType#unloadAnimation" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#unloadAnimationSpeed" , "vehicle.baler.baleTypes.baleType#unloadAnimationSpeed" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#baleDropAnimTime" , "vehicle.baler.baleTypes.baleType#dropAnimationTime" ) --FS19 to FS22

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler#toggleAutomaticDropTextPos" , "vehicle.baler.automaticDrop#textPos" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler#toggleAutomaticDropTextNeg" , "vehicle.baler.automaticDrop#textNeg" ) --FS19 to FS22

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baler.baleAnimation#firstBaleMarker" , "Please adjust bale nodes to match the default balers" ) --FS19 to FS22

    local baseKey = "vehicle.baler"
    local configurationId = self.configurations[ "baler" ] or 1
    local configKey = string.format( "vehicle.baler.balerConfigurations.balerConfiguration(%d)" , configurationId - 1 )
    if self.xmlFile:hasProperty(configKey) then
        baseKey = configKey
    end

    spec.fillScale = self.xmlFile:getValue(baseKey .. "#fillScale" , 1 )
    spec.fillUnitIndex = self.xmlFile:getValue(baseKey .. "#fillUnitIndex" , 1 )
    spec.consumableUsage = self.xmlFile:getValue(baseKey .. "#consumableUsage" , 0.025 )
    spec.useDropLandOwnershipForBales = self.xmlFile:getValue(baseKey .. "#useDropLandOwnershipForBales" , false )

    if self.xmlFile:hasProperty(baseKey .. ".baleAnimation" ) then
        local baleAnimCurve = AnimCurve.new(linearInterpolatorN)

        local keyframes = { }
        local lastX, lastY, lastZ
        local totalLength = 0
        self.xmlFile:iterate(baseKey .. ".baleAnimation.key" , function (_, key)
            XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#time" ) --FS19 to FS22

            local keyframe = { }
            keyframe.x, keyframe.y, keyframe.z = self.xmlFile:getValue(key .. "#pos" )
            if keyframe.x = = nil then
                Logging.xmlWarning( self.xmlFile, "Missing values for '%s'" , key .. "#pos" )
                    return
                end
                keyframe.rx, keyframe.ry, keyframe.rz = self.xmlFile:getValue(key .. "#rot" , "0 0 0" )

                if lastX ~ = nil then
                    keyframe.length = MathUtil.vector3Length(lastX - keyframe.x, lastY - keyframe.y, lastZ - keyframe.z)
                    totalLength = totalLength + keyframe.length
                    keyframe.pos = totalLength
                end

                table.insert(keyframes, keyframe)

                lastX, lastY, lastZ = keyframe.x, keyframe.y, keyframe.z
            end )

            for i = 1 , #keyframes do
                local keyframe = keyframes[i]
                local t = 0
                if keyframe.pos ~ = nil then
                    t = keyframe.pos / totalLength
                end

                baleAnimCurve:addKeyframe( { keyframe.x, keyframe.y, keyframe.z, keyframe.rx, keyframe.ry, keyframe.rz, time = t } )
            end

            if #keyframes > 0 then
                spec.baleAnimCurve = baleAnimCurve
                spec.baleAnimLength = totalLength
                spec.baleAnimSpacing = self.xmlFile:getValue(baseKey .. ".baleAnimation#spacing" , 0 )
                spec.baleAnimEnableCollision = self.xmlFile:getValue(baseKey .. ".baleAnimation#enableCollision" , true )
            end
        end

        spec.hasUnloadingAnimation = true
        spec.isRoundBaler = false
        spec.lastBaleVariationId = nil

        local defaultBaleTypeIndex = 1
        spec.baleTypes = { }
        self.xmlFile:iterate(baseKey .. ".baleTypes.baleType" , function (index, key)
            if #spec.baleTypes > = BalerBaleTypeEvent.MAX_NUM_BALE_TYPES then
                Logging.xmlError( self.xmlFile, "Too many bale types defined.Max.amount is '%d'! '%s'" , BalerBaleTypeEvent.MAX_NUM_BALE_TYPES, key)
                return false
            end

            local baleTypeDefinition = { }
            baleTypeDefinition.index = index
            baleTypeDefinition.isRoundBale = self.xmlFile:getValue(key .. "#isRoundBale" , false )
            baleTypeDefinition.width = MathUtil.round( self.xmlFile:getValue(key .. "#width" , 1.2 ), 2 )
            baleTypeDefinition.height = MathUtil.round( self.xmlFile:getValue(key .. "#height" , 0.9 ), 2 )
            baleTypeDefinition.length = MathUtil.round( self.xmlFile:getValue(key .. "#length" , 2.4 ), 2 )
            baleTypeDefinition.diameter = MathUtil.round( self.xmlFile:getValue(key .. "#diameter" , 1.8 ), 2 )

            if baleTypeDefinition.isRoundBale then
                spec.isRoundBaler = true
            end

            baleTypeDefinition.isDefault = self.xmlFile:getValue(key .. "#isDefault" , false )
            if baleTypeDefinition.isDefault then
                defaultBaleTypeIndex = index
            end

            baleTypeDefinition.consumableUsage = self.xmlFile:getValue(key .. "#consumableUsage" , spec.consumableUsage)

            baleTypeDefinition.chamberBaleVariationId = self.xmlFile:getValue(key .. "#chamberBaleVariationId" , "DEFAULT" )
            baleTypeDefinition.defaultBaleVariationId = self.xmlFile:getValue(key .. "#defaultBaleVariationId" , "DEFAULT" )

            baleTypeDefinition.baleNode = self.xmlFile:getValue(key .. ".nodes#baleNode" , nil , self.components, self.i3dMappings)
            baleTypeDefinition.baleRootNode, baleTypeDefinition.baleNodeComponent = self.xmlFile:getValue(key .. ".nodes#baleRootNode" , baleTypeDefinition.baleNode, self.components, self.i3dMappings)
            if baleTypeDefinition.baleRootNode ~ = nil and baleTypeDefinition.baleNodeComponent = = nil then
                baleTypeDefinition.baleNodeComponent = self:getParentComponent(baleTypeDefinition.baleRootNode)
            end

            if baleTypeDefinition.baleNode ~ = nil then
                baleTypeDefinition.scaleNode = self.xmlFile:getValue(key .. ".nodes#scaleNode" , nil , self.components, self.i3dMappings)
                baleTypeDefinition.scaleComponents = self.xmlFile:getValue(key .. ".nodes#scaleComponents" , nil , true )

                baleTypeDefinition.animations = { }
                baleTypeDefinition.animations.fill = self.xmlFile:getValue(key .. ".animations#fillAnimation" )

                baleTypeDefinition.animations.unloading = self.xmlFile:getValue(key .. ".animations#unloadAnimation" )
                baleTypeDefinition.animations.unloadingSpeed = self.xmlFile:getValue(key .. ".animations#unloadAnimationSpeed" , 1 )
                baleTypeDefinition.animations.dropAnimationTime = self.xmlFile:getValue(key .. ".animations#dropAnimationTime" , self:getAnimationDuration(baleTypeDefinition.animations.unloading) / 1000 )

                baleTypeDefinition.detailVisibilityCutNodes = { }
                self.xmlFile:iterate(key .. ".detailVisibilityCutNode" , function (_, detailsVisNodeKey)
                    local detailVisibilityCutNode = { }
                    detailVisibilityCutNode.node = self.xmlFile:getValue(detailsVisNodeKey .. "#node" , nil , self.components, self.i3dMappings)
                    if detailVisibilityCutNode.node ~ = nil then
                        detailVisibilityCutNode.axis = self.xmlFile:getValue(detailsVisNodeKey .. "#axis" , 3 )
                        detailVisibilityCutNode.direction = self.xmlFile:getValue(detailsVisNodeKey .. "#direction" , 1 )

                        table.insert(baleTypeDefinition.detailVisibilityCutNodes, detailVisibilityCutNode)
                    end
                end )

                baleTypeDefinition.changeObjects = { }
                ObjectChangeUtil.loadObjectChangeFromXML( self.xmlFile, key, baleTypeDefinition.changeObjects, self.components, self )

                table.insert(spec.baleTypes, baleTypeDefinition)

                spec.hasUnloadingAnimation = spec.hasUnloadingAnimation and baleTypeDefinition.animations.unloading ~ = nil

                return
            else
                    Logging.xmlError( self.xmlFile, "Missing baleNode for bale type. '%s'" , key)
                        return
                    end
                end )

                local defaultBaleType = spec.baleTypes[defaultBaleTypeIndex]
                if defaultBaleType ~ = nil then
                    ObjectChangeUtil.setObjectChanges(defaultBaleType.changeObjects, true , self , self.setMovingToolDirty)
                end

                spec.changeBaleTypeText = self.xmlFile:getValue(baseKey .. ".baleTypes#changeText" , "action_changeBaleSize" , self.customEnvironment)

                spec.preSelectedBaleTypeIndex = defaultBaleTypeIndex
                spec.currentBaleTypeIndex = defaultBaleTypeIndex
                spec.currentBaleXMLFilename = nil
                spec.currentBaleTypeDefinition = nil

                if #spec.baleTypes = = 0 then
                    Logging.xmlError( self.xmlFile, "No baleTypes definded for baler." )
                    end

                    if spec.hasUnloadingAnimation then
                        spec.automaticDrop = self.xmlFile:getValue(baseKey .. ".automaticDrop#enabled" , Platform.gameplay.automaticBaleDrop)
                        spec.toggleableAutomaticDrop = self.xmlFile:getValue(baseKey .. ".automaticDrop#toggleable" , not Platform.gameplay.automaticBaleDrop)

                        spec.toggleAutomaticDropTextPos = self.xmlFile:getValue(baseKey .. ".automaticDrop#textPos" , "action_toggleAutomaticBaleDropPos" , self.customEnvironment)
                        spec.toggleAutomaticDropTextNeg = self.xmlFile:getValue(baseKey .. ".automaticDrop#textNeg" , "action_toggleAutomaticBaleDropNeg" , self.customEnvironment)

                        spec.baleCloseAnimationName = self.xmlFile:getValue(baseKey .. ".baleAnimation#closeAnimationName" )
                        spec.baleCloseAnimationSpeed = self.xmlFile:getValue(baseKey .. ".baleAnimation#closeAnimationSpeed" , 1 )

                        local closeAnimation = self:getAnimationByName(spec.baleCloseAnimationName)
                        if spec.baleCloseAnimationName = = nil or closeAnimation = = nil then
                            Logging.xmlError( self.xmlFile, "Failed to find baler close animation. (%s)" , baseKey .. ".baleAnimation#closeAnimationName" )
                        else
                                closeAnimation.resetOnStart = false
                            end
                        end

                        spec.unfinishedBaleThreshold = self.xmlFile:getValue(baseKey .. "#unfinishedBaleThreshold" , 2000 )
                        spec.canUnloadUnfinishedBale = self.xmlFile:getValue(baseKey .. "#canUnloadUnfinishedBale" , false )
                        spec.lastBaleFillLevel = nil

                        if self.isClient then
                            spec.samples = { }
                            spec.samples.work = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                            spec.samples.eject = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "eject" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                            spec.samples.unload = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "unload" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                            spec.samples.door = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "door" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                            spec.samples.knotCleaning = g_soundManager:loadSampleFromXML( self.xmlFile, baseKey .. ".sounds" , "knotCleaning" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )

                            spec.knotCleaningTimer = 10000
                            spec.knotCleaningTime = 120000

                            spec.animationNodes = g_animationManager:loadAnimations( self.xmlFile, baseKey .. ".animationNodes" , self.components, self , self.i3dMappings)
                            spec.unloadAnimationNodes = g_animationManager:loadAnimations( self.xmlFile, baseKey .. ".unloadAnimationNodes" , self.components, self , self.i3dMappings)
                            spec.fillEffects = g_effectManager:loadEffect( self.xmlFile, baseKey .. ".fillEffect" , self.components, self , self.i3dMappings)
                            spec.fillEffectType = FillType.UNKNOWN
                            spec.additiveEffects = g_effectManager:loadEffect( self.xmlFile, baseKey .. ".additiveEffects" , self.components, self , self.i3dMappings)

                            spec.knotingAnimation = self.xmlFile:getValue(baseKey .. ".knotingAnimation#name" )
                            spec.knotingAnimationSpeed = self.xmlFile:getValue(baseKey .. ".knotingAnimation#speed" , 1 )

                            spec.compactingAnimation = self.xmlFile:getValue(baseKey .. ".compactingAnimation#name" )
                            spec.compactingAnimationInterval = self.xmlFile:getValue(baseKey .. ".compactingAnimation#interval" , 60 ) * 1000
                            spec.compactingAnimationCompactTime = self.xmlFile:getValue(baseKey .. ".compactingAnimation#compactTime" , 5 ) * 1000
                            spec.compactingAnimationCompactTimer = spec.compactingAnimationCompactTime
                            spec.compactingAnimationTime = spec.compactingAnimationInterval
                            spec.compactingAnimationSpeed = self.xmlFile:getValue(baseKey .. ".compactingAnimation#speed" , 1 )
                            spec.compactingAnimationMinTime = self.xmlFile:getValue(baseKey .. ".compactingAnimation#minFillLevelTime" , 1 )
                            spec.compactingAnimationMaxTime = self.xmlFile:getValue(baseKey .. ".compactingAnimation#maxFillLevelTime" , 0.1 )
                        end

                        spec.lastAreaBiggerZero = false
                        spec.lastAreaBiggerZeroSent = false
                        spec.lastAreaBiggerZeroTime = 0

                        spec.workAreaParameters = { }
                        spec.workAreaParameters.lastPickedUpLiters = 0

                        spec.fillUnitOverflowFillLevel = 0

                        spec.maxPickupLitersPerSecond = self.xmlFile:getValue(baseKey .. "#maxPickupLitersPerSecond" , 500 )
                        spec.pickUpLitersBuffer = ValueBuffer.new( 750 )

                        spec.unloadingState = Baler.UNLOADING_CLOSED
                        spec.pickupFillTypes = { }

                        spec.bales = { }

                        spec.dummyBale = { }
                        spec.dummyBale.currentBaleFillType = FillType.UNKNOWN
                        spec.dummyBale.currentBale = nil
                        spec.dummyBale.currentBaleLength = 0

                        spec.allowsBaleUnloading = self.xmlFile:getValue(baseKey .. ".baleUnloading#allowed" , false )
                        spec.baleUnloadingTime = self.xmlFile:getValue(baseKey .. ".baleUnloading#time" , 4 ) * 1000
                        spec.baleFoldThreshold = self.xmlFile:getValue(baseKey .. ".baleUnloading#foldThreshold" , 0.25 ) * self:getFillUnitCapacity(spec.fillUnitIndex)

                        spec.platformAnimation = self.xmlFile:getValue(baseKey .. ".platform#animationName" )
                        spec.platformAnimationNextBaleTime = self.xmlFile:getValue(baseKey .. ".platform#nextBaleTime" , 0 )
                        spec.platformAutomaticDrop = self.xmlFile:getValue(baseKey .. ".platform#automaticDrop" , Platform.gameplay.automaticBaleDrop)
                        spec.platformAIDropSpeed = self.xmlFile:getValue(baseKey .. ".platform#aiSpeed" , 3 )

                        spec.hasPlatform = spec.platformAnimation ~ = nil
                        spec.hasDynamicMountPlatform = SpecializationUtil.hasSpecialization( DynamicMountAttacher , self.specializations)

                        -- always automatically drop bale to platform, but player can decide when to drop from platform
                        if spec.hasPlatform then
                            spec.automaticDrop = true
                        end

                        spec.platformReadyToDrop = false -- bale is on platform and ready to be dropped
                        spec.platformDropInProgress = false -- bale is currently dropping from platform
                        spec.platformDelayedDropping = false -- unload baler if bale was dropped from platform
                            spec.platformMountDelay = - 1 -- when counter reaches zero the bale in the platform trigger is forced to be mounted

                            spec.buffer = { }
                            spec.buffer.fillUnitIndex = self.xmlFile:getValue(baseKey .. ".buffer#fillUnitIndex" )
                            spec.buffer.unloadInfoIndex = self.xmlFile:getValue(baseKey .. ".buffer#unloadInfoIndex" , 1 )
                            spec.buffer.capacityPercentage = self.xmlFile:getValue(baseKey .. ".buffer#capacityPercentage" )
                            spec.buffer.overloadingDuration = self.xmlFile:getValue(baseKey .. ".buffer#overloadingDuration" , 1 )
                            spec.buffer.overloadingDelay = self.xmlFile:getValue(baseKey .. ".buffer#overloadingDelay" , 0 )
                            spec.buffer.overloadingTimer = 0
                            spec.buffer.overloadingStartFillLevelPct = MathUtil.round( self.xmlFile:getValue(baseKey .. ".buffer#overloadingStartFillLevelPct" , 1 ), 2 )
                            spec.buffer.fillMainUnitAfterOverload = self.xmlFile:getValue(baseKey .. ".buffer#fillMainUnitAfterOverload" , false )
                            spec.buffer.unloadingStarted = false
                            spec.buffer.fillLevelToEmpty = 0

                            spec.buffer.dummyBale = { }
                            spec.buffer.dummyBale.available = self.xmlFile:hasProperty(baseKey .. ".buffer.dummyBale" )
                            spec.buffer.dummyBale.linkNode = self.xmlFile:getValue(baseKey .. ".buffer.dummyBale#node" , nil , self.components, self.i3dMappings)
                            spec.buffer.dummyBale.scaleComponents = self.xmlFile:getValue(baseKey .. ".buffer.dummyBale#scaleComponents" , "1 1 0" , true )

                            spec.buffer.overloadAnimation = self.xmlFile:getValue(baseKey .. ".buffer.overloadAnimation#name" )
                            spec.buffer.overloadAnimationSpeed = self.xmlFile:getValue(baseKey .. ".buffer.overloadAnimation#speedScale" , 1 )

                            spec.buffer.loadingStateAnimation = self.xmlFile:getValue(baseKey .. ".buffer.loadingStateAnimation#name" )
                            spec.buffer.loadingStateAnimationSpeed = self.xmlFile:getValue(baseKey .. ".buffer.loadingStateAnimation#speedScale" , 1 )

                            if self.isClient then
                                spec.buffer.overloadingEffects = g_effectManager:loadEffect( self.xmlFile, baseKey .. ".buffer.overloadingEffect" , self.components, self , self.i3dMappings)
                                spec.buffer.overloadingAnimationNodes = g_animationManager:loadAnimations( self.xmlFile, baseKey .. ".buffer.overloadingAnimationNodes" , self.components, self , self.i3dMappings)

                                spec.buffer.samplesOverloadingStart = g_soundManager:loadSamplesFromXML( self.xmlFile, baseKey .. ".sounds" , "bufferOverloadingStart" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                spec.buffer.samplesOverloadingStop = g_soundManager:loadSamplesFromXML( self.xmlFile, baseKey .. ".sounds" , "bufferOverloadingStop" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                spec.buffer.samplesOverloadingWork = g_soundManager:loadSamplesFromXML( self.xmlFile, baseKey .. ".sounds" , "bufferOverloadingWork" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                            end

                            spec.nonStopBaling = spec.buffer.fillUnitIndex ~ = nil

                            if spec.nonStopBaling ~ = nil then
                                local fillTypeName = self.xmlFile:getValue(baseKey .. ".buffer#balerDisplayType" )
                                local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
                                if fillTypeIndex ~ = nil then
                                    self:setFillUnitFillTypeToDisplay(spec.fillUnitIndex, fillTypeIndex, true )
                                end
                            end

                            spec.variableSpeedLimit = { }
                            spec.variableSpeedLimit.enabled = self.xmlFile:hasProperty(baseKey .. ".variableSpeedLimit" )
                            spec.variableSpeedLimit.pickupPerSecond = 0
                            spec.variableSpeedLimit.pickupPerSecondTimer = 0
                            spec.variableSpeedLimit.targetLiterPerSecond = self.xmlFile:getValue(baseKey .. ".variableSpeedLimit#targetLiterPerSecond" , 200 )
                            spec.variableSpeedLimit.changeInterval = self.xmlFile:getValue(baseKey .. ".variableSpeedLimit#changeInterval" , 1 )
                            spec.variableSpeedLimit.minSpeedLimit = self.xmlFile:getValue(baseKey .. ".variableSpeedLimit#minSpeedLimit" , 5 )
                            spec.variableSpeedLimit.maxSpeedLimit = self.xmlFile:getValue(baseKey .. ".variableSpeedLimit#maxSpeedLimit" , 15 )
                            spec.variableSpeedLimit.defaultSpeedLimit = self.xmlFile:getValue(baseKey .. ".variableSpeedLimit#defaultSpeedLimit" , 10 )
                            spec.variableSpeedLimit.backupSpeedLimit = self.speedLimit
                            spec.variableSpeedLimit.usedBackupSpeedLimit = false
                            spec.variableSpeedLimit.lastAdjustedSpeedLimit = nil
                            spec.variableSpeedLimit.lastAdjustedSpeedLimitType = nil

                            spec.variableSpeedLimit.fillTypeToTargetLiterPerSecond = { }

                            self.xmlFile:iterate(baseKey .. ".variableSpeedLimit.target" , function (index, key)
                                local fillType = g_fillTypeManager:getFillTypeIndexByName( self.xmlFile:getValue(key .. "#fillType" ))
                                if fillType ~ = nil then
                                    local targetLiterPerSecond = self.xmlFile:getValue(key .. "#targetLiterPerSecond" , 200 )
                                    local defaultSpeedLimit = self.xmlFile:getValue(key .. "#defaultSpeedLimit" , 10 )
                                    spec.variableSpeedLimit.fillTypeToTargetLiterPerSecond[fillType] = { targetLiterPerSecond = targetLiterPerSecond, defaultSpeedLimit = defaultSpeedLimit }
                                end
                            end )

                            spec.additives = { }
                            spec.additives.fillUnitIndex = self.xmlFile:getValue(baseKey .. ".additives#fillUnitIndex" )
                            spec.additives.available = self:getFillUnitByIndex(spec.additives.fillUnitIndex) ~ = nil
                            spec.additives.usage = self.xmlFile:getValue(baseKey .. ".additives#usage" , 0.0000275 )
                            local additivesFillTypeNames = self.xmlFile:getValue(baseKey .. ".additives#fillTypes" , "GRASS_WINDROW" )
                            spec.additives.fillTypes = g_fillTypeManager:getFillTypesByNames(additivesFillTypeNames, "Warning: '" .. self.xmlFile:getFilename() .. "' has invalid fillType '%s'." )
                            spec.additives.appliedByBufferOverloading = self.xmlFile:getValue(baseKey .. ".additives#appliedByBufferOverloading" , false )
                            spec.additives.isActiveTimer = 0
                            spec.additives.isActive = false

                            spec.isBaleUnloading = false
                            spec.balesToUnload = 0

                            spec.texts = { }
                            spec.texts.warningFoldingBaleLoaded = g_i18n:getText( "warning_foldingNotWhileBaleLoaded" )
                            spec.texts.warningFoldingTurnedOn = g_i18n:getText( "warning_foldingNotWhileTurnedOn" )
                            spec.texts.warningTooManyBales = g_i18n:getText( "warning_tooManyBales" )
                            spec.texts.unloadUnfinishedBale = g_i18n:getText( "action_unloadUnfinishedBale" )
                            spec.texts.unloadBaler = g_i18n:getText( "action_unloadBaler" )
                            spec.texts.closeBack = g_i18n:getText( "action_closeBack" )

                            spec.showBaleLimitWarning = false

                            spec.dirtyFlag = self:getNextDirtyFlag()

                            -- set already here to be set before the fill units are loaded and we may get a different first bale
                            if savegame ~ = nil and not savegame.resetVehicles then
                                local baleTypeIndex = savegame.xmlFile:getValue(savegame.key .. ".baler#baleTypeIndex" , spec.currentBaleTypeIndex)
                                self:setBaleTypeIndex(baleTypeIndex, true , true )

                                local preSelectedBaleTypeIndex = savegame.xmlFile:getValue(savegame.key .. ".baler#preSelectedBaleTypeIndex" , spec.preSelectedBaleTypeIndex)
                                self:setBaleTypeIndex(preSelectedBaleTypeIndex, nil , true )

                                local fillUnitCapacity = savegame.xmlFile:getValue(savegame.key .. ".baler#fillUnitCapacity" )
                                if fillUnitCapacity ~ = nil then
                                    if fillUnitCapacity = = 0 then
                                        fillUnitCapacity = math.huge
                                    end

                                    self:setFillUnitCapacity(spec.fillUnitIndex, fillUnitCapacity)

                                    if spec.buffer.capacityPercentage ~ = nil then
                                        self:setFillUnitCapacity(spec.fillUnitIndex, fillUnitCapacity * spec.buffer.capacityPercentage, false )
                                    end
                                end

                                spec.workAreaParameters.lastMissionUniqueId = savegame.xmlFile:getValue(savegame.key .. ".baler#workAreaMissionUniqueId" )

                                if spec.nonStopBaling then
                                    spec.buffer.unloadingStarted = savegame.xmlFile:getValue(savegame.key .. ".baler#bufferUnloadingStarted" , spec.buffer.unloadingStarted)
                                end
                            end
                        end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function Baler:onLoadFinished(savegame)
    local spec = self.spec_baler
    if self.isServer then
        if spec.createBaleNextFrame ~ = nil and spec.createBaleNextFrame then
            self:finishBale()
            spec.createBaleNextFrame = nil
        end
    end

    if spec.balesToLoad ~ = nil then
        for _, v in ipairs(spec.balesToLoad) do
            if self:createBale(v.fillType, v.fillLevel, nil , v.baleTime, v.filename, v.ownerFarmId, v.variationId, true ) then
                self:setBaleTime(#spec.bales, v.baleTime, true )
            end
        end

        spec.balesToLoad = nil
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
function Baler:onPostLoad(savegame)
    local spec = self.spec_baler

    for fillTypeIndex, enabled in pairs( self:getFillUnitSupportedFillTypes(spec.fillUnitIndex)) do
        if enabled and fillTypeIndex ~ = FillType.UNKNOWN then
            spec.pickupFillTypes[fillTypeIndex] = 0
        end
    end

    if savegame ~ = nil and not savegame.resetVehicles then
        local numBales = savegame.xmlFile:getValue(savegame.key .. ".baler#numBales" )
        if numBales ~ = nil then
            spec.balesToLoad = { }
            for i = 1 , numBales do
                local baleKey = string.format( "%s.baler.bale(%d)" , savegame.key, i - 1 )
                local bale = { }
                local filename = savegame.xmlFile:getValue(baleKey .. "#filename" )
                local fillTypeStr = savegame.xmlFile:getValue(baleKey .. "#fillType" )
                local fillType = g_fillTypeManager:getFillTypeByName(fillTypeStr)
                if filename ~ = nil and fillType ~ = nil then
                    bale.filename = filename
                    bale.fillType = fillType.index
                    bale.fillLevel = savegame.xmlFile:getValue(baleKey .. "#fillLevel" )
                    bale.baleTime = savegame.xmlFile:getValue(baleKey .. "#baleTime" )

                    bale.variationId = savegame.xmlFile:getValue(baleKey .. "#variationId" )
                    bale.ownerFarmId = savegame.xmlFile:getValue(baleKey .. "#ownerFarmId" )

                    table.insert(spec.balesToLoad, bale)
                end
            end
        end

        if spec.hasPlatform then
            spec.platformReadyToDrop = savegame.xmlFile:getValue(savegame.key .. ".baler#platformReadyToDrop" , spec.platformReadyToDrop)
            if spec.platformReadyToDrop then
                self:setAnimationTime(spec.platformAnimation, 1 , true )
                self:setAnimationTime(spec.platformAnimation, 0 , true )
                spec.platformMountDelay = 1
            end
        end
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
function Baler:onReadStream(streamId, connection)
    local spec = self.spec_baler

    if spec.hasUnloadingAnimation then
        local state = streamReadUIntN(streamId, 7 )
        local animTime = streamReadFloat32(streamId)
        if state = = Baler.UNLOADING_CLOSED or state = = Baler.UNLOADING_CLOSING then
            self:setIsUnloadingBale( false , true )
            self:setRealAnimationTime(spec.baleCloseAnimationName, animTime)
        elseif state = = Baler.UNLOADING_OPEN or state = = Baler.UNLOADING_OPENING then
                self:setIsUnloadingBale( true , true )
                self:setRealAnimationTime(spec.baleUnloadAnimationName, animTime)
            end
        end

        local numBales = streamReadUInt8(streamId)
        for i = 1 , numBales do
            local fillType = streamReadIntN(streamId, FillTypeManager.SEND_NUM_BITS)
            local fillLevel = streamReadFloat32(streamId)
            self:createBale(fillType, fillLevel)
            if spec.baleAnimCurve ~ = nil then
                local baleTime = streamReadFloat32(streamId)
                self:setBaleTime(i, baleTime)
            end
        end

        spec.lastAreaBiggerZero = streamReadBool(streamId)

        if spec.hasPlatform then
            spec.platformReadyToDrop = streamReadBool(streamId)
            if spec.platformReadyToDrop then
                self:setAnimationTime(spec.platformAnimation, 1 , true )
                self:setAnimationTime(spec.platformAnimation, 0 , true )
            end
        end

        spec.currentBaleTypeIndex = streamReadUIntN(streamId, BalerBaleTypeEvent.BALE_TYPE_SEND_NUM_BITS)
        spec.preSelectedBaleTypeIndex = streamReadUIntN(streamId, BalerBaleTypeEvent.BALE_TYPE_SEND_NUM_BITS)

        local capacity = streamReadFloat32(streamId)
        self:setFillUnitCapacity(spec.fillUnitIndex, capacity)

        local fillLevel = streamReadFloat32(streamId)
        local fillUnit = self:getFillUnitByIndex(spec.fillUnitIndex)
        if fillUnit ~ = nil then
            fillUnit.fillLevel = fillLevel
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
function Baler:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_baler

    if connection:getIsServer() then
        if streamReadBool(streamId) then
            spec.lastAreaBiggerZero = streamReadBool(streamId)
            spec.fillEffectType = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
            spec.showBaleLimitWarning = streamReadBool(streamId)

            if spec.nonStopBaling then
                spec.buffer.unloadingStarted = streamReadBool(streamId)

                if spec.buffer.unloadingStarted then
                    local fillType = self:getFillUnitFillType(spec.buffer.fillUnitIndex)
                    if fillType = = FillType.UNKNOWN then
                        fillType = self:getFillUnitFillType(spec.fillUnitIndex)
                    end
                    g_effectManager:setEffectTypeInfo(spec.buffer.overloadingEffects, fillType)
                    g_effectManager:startEffects(spec.buffer.overloadingEffects)

                    g_soundManager:playSamples(spec.buffer.samplesOverloadingStart)
                    g_soundManager:playSamples(spec.buffer.samplesOverloadingWork, 0 , spec.buffer.samplesOverloadingStart[ 0 ])

                    g_animationManager:startAnimations(spec.buffer.overloadingAnimationNodes)
                else
                        g_effectManager:stopEffects(spec.buffer.overloadingEffects)

                        g_soundManager:stopSamples(spec.buffer.samplesOverloadingStart)
                        if g_soundManager:getIsSamplePlaying(spec.buffer.samplesOverloadingWork[ 0 ]) then
                            g_soundManager:stopSamples(spec.buffer.samplesOverloadingWork)
                            g_soundManager:playSamples(spec.buffer.samplesOverloadingStop)
                        end

                        g_animationManager:stopAnimations(spec.buffer.overloadingAnimationNodes)
                    end
                end

                spec.additives.isActive = streamReadBool(streamId)
                if spec.additives.isActive then
                    g_effectManager:setEffectTypeInfo(spec.additiveEffects, FillType.LIQUIDFERTILIZER)
                    g_effectManager:startEffects(spec.additiveEffects)
                else
                        g_effectManager:stopEffects(spec.additiveEffects)
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
function Baler:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_baler
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if not spec.automaticDrop or not spec.platformAutomaticDrop then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA3, self , Baler.actionEventUnloading, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            end

            if #spec.baleTypes > 1 then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.TOGGLE_BALE_TYPES, self , Baler.actionEventToggleSize, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            end

            if spec.toggleableAutomaticDrop then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA4, self , Baler.actionEventToggleAutomaticDrop, false , true , false , true , nil )

                local automaticDropState = spec.automaticDrop
                if spec.hasPlatform then
                    automaticDropState = spec.platformAutomaticDrop
                end
                g_inputBinding:setActionEventText(actionEventId, automaticDropState and spec.toggleAutomaticDropTextNeg or spec.toggleAutomaticDropTextPos)
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            end

            Baler.updateActionEvents( self )
        end
    end
end

```

### onRegisterExternalActionEvents

**Description**

> Called on load to register external action events

**Definition**

> onRegisterExternalActionEvents()

**Arguments**

| any | trigger |
|-----|---------|
| any | name    |
| any | xmlFile |
| any | key     |

**Code**

```lua
function Baler:onRegisterExternalActionEvents(trigger, name, xmlFile, key)
    local spec = self.spec_baler

    if name = = "balerDrop" then
        self:registerExternalActionEvent(trigger, name, Baler.externalActionEventUnloadRegister, Baler.externalActionEventUnloadUpdate)
    elseif name = = "balerAutomaticDrop" then
            if spec.toggleableAutomaticDrop then
                self:registerExternalActionEvent(trigger, name, Baler.externalActionEventAutomaticUnloadRegister, Baler.externalActionEventAutomaticUnloadUpdate)
            end
        elseif name = = "balerBaleSize" then
                if #spec.baleTypes > 1 then
                    self:registerExternalActionEvent(trigger, name, Baler.externalActionEventBaleTypeRegister, Baler.externalActionEventBaleTypeUpdate)
                end
            end
        end

```

### onRootVehicleChanged

**Description**

> Called if root vehicle changes

**Definition**

> onRootVehicleChanged(table rootVehicle)

**Arguments**

| table | rootVehicle | root vehicle |
|-------|-------------|--------------|

**Code**

```lua
function Baler:onRootVehicleChanged(rootVehicle)
    local spec = self.spec_baler
    local actionController = rootVehicle.actionController
    if actionController ~ = nil then
        if spec.controlledAction ~ = nil then
            spec.controlledAction:updateParent(actionController)
            return
        end

        spec.controlledAction = actionController:registerAction( "baleUnload" , nil , 1 )
        spec.controlledAction:setCallback( self , Baler.actionControllerBaleUnloadEvent)
        spec.controlledAction:setFinishedFunctions( self , Baler.getIsBaleUnloading, false , false )
    else
            if spec.controlledAction ~ = nil then
                spec.controlledAction:remove()
                spec.controlledAction = nil
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
function Baler:onStartWorkAreaProcessing(dt)
    local spec = self.spec_baler

    if self.isServer then
        spec.lastAreaBiggerZero = false
        spec.workAreaParameters.lastPickedUpLiters = 0
    end
end

```

### onTurnedOff

**Description**

**Definition**

> onTurnedOff()

**Code**

```lua
function Baler:onTurnedOff()
    if self.isClient then
        local spec = self.spec_baler
        g_effectManager:stopEffects(spec.fillEffects)
        g_effectManager:stopEffects(spec.additiveEffects)
        g_effectManager:stopEffects(spec.buffer.overloadingEffects)
        g_animationManager:stopAnimations(spec.animationNodes)

        g_soundManager:stopSample(spec.samples.work)
        g_soundManager:stopSample(spec.samples.eject)
        g_soundManager:stopSample(spec.samples.unload)
        g_soundManager:stopSample(spec.samples.door)
        g_soundManager:stopSample(spec.samples.knotCleaning)

        g_soundManager:stopSamples(spec.buffer.samplesOverloadingStart)
        if g_soundManager:getIsSamplePlaying(spec.buffer.samplesOverloadingWork[ 1 ]) then
            g_soundManager:stopSamples(spec.buffer.samplesOverloadingWork)
            g_soundManager:playSamples(spec.buffer.samplesOverloadingStop)
        end
    end
end

```

### onTurnedOn

**Description**

**Definition**

> onTurnedOn()

**Code**

```lua
function Baler:onTurnedOn()
    if self.setFoldState ~ = nil then
        if # self.spec_foldable.foldingParts > 0 then
            self:setFoldState( self.spec_foldable.turnOnFoldDirection, false , true )
        end
    end
    if self.isClient then
        local spec = self.spec_baler
        g_animationManager:startAnimations(spec.animationNodes)
        g_soundManager:playSample(spec.samples.work)
    end

    self:raiseActive()
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
function Baler:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_baler

    if self.isClient then
        if spec.baleToMount ~ = nil then
            local baleObject = NetworkUtil.getObject(spec.baleToMount.baleServerId)
            if baleObject ~ = nil then
                baleObject:mountKinematic( self , spec.baleToMount.jointNode, 0 , 0 , 0 , 0 , 0 , 0 )
                spec.baleToMount.baleInfo.baleObject = baleObject
                spec.baleToMount.baleInfo.baleServerId = spec.baleToMount.baleServerId
                spec.baleToMount = nil
            end
        end

        local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]
        if baleTypeDef ~ = nil and #baleTypeDef.detailVisibilityCutNodes > 0 then
            for i = 1 , #spec.bales do
                local bale = spec.bales[i]
                if bale.baleObject ~ = nil then
                    bale.baleObject:resetDetailVisibilityCut()
                    if bale.time < 1 then
                        for j = 1 , #baleTypeDef.detailVisibilityCutNodes do
                            local detailVisibilityCutNode = baleTypeDef.detailVisibilityCutNodes[j]
                            bale.baleObject:setDetailVisibilityCutNode(detailVisibilityCutNode.node, detailVisibilityCutNode.axis, detailVisibilityCutNode.direction)
                        end
                    end
                end
            end

            if spec.dummyBale.currentBale ~ = nil then
                for j = 1 , #baleTypeDef.detailVisibilityCutNodes do
                    local detailVisibilityCutNode = baleTypeDef.detailVisibilityCutNodes[j]
                    Bale.setBaleMeshVisibilityCut(spec.dummyBale.currentBale, detailVisibilityCutNode.node, detailVisibilityCutNode.axis, detailVisibilityCutNode.direction, true )
                end
            end
        end
    end

    if self.isServer then
        if self.isAddedToPhysics then
            if spec.createBaleNextFrame ~ = nil and spec.createBaleNextFrame then
                self:finishBale()
                spec.createBaleNextFrame = nil
            end
        end

        -- update variable speed limit based on current pickup
        if spec.variableSpeedLimit.enabled then
            spec.variableSpeedLimit.pickupPerSecondTimer = spec.variableSpeedLimit.pickupPerSecondTimer + dt
            if spec.variableSpeedLimit.pickupPerSecondTimer > spec.variableSpeedLimit.changeInterval then
                local defaultSpeedLimit = spec.variableSpeedLimit.defaultSpeedLimit
                local targetLiterPerSecond = spec.variableSpeedLimit.targetLiterPerSecond

                local fillTypeIndex = self:getFillUnitFillType(spec.fillUnitIndex)
                if fillTypeIndex = = FillType.UNKNOWN and spec.nonStopBaling then
                    fillTypeIndex = self:getFillUnitFillType(spec.buffer.fillUnitIndex)
                end
                if fillTypeIndex ~ = nil and spec.variableSpeedLimit.fillTypeToTargetLiterPerSecond[fillTypeIndex] ~ = nil then
                    local target = spec.variableSpeedLimit.fillTypeToTargetLiterPerSecond[fillTypeIndex]
                    defaultSpeedLimit = target.defaultSpeedLimit
                    targetLiterPerSecond = target.targetLiterPerSecond
                end

                local litersPerSecond = spec.variableSpeedLimit.pickupPerSecond / (spec.variableSpeedLimit.changeInterval / 1000 )
                if litersPerSecond > 0 then
                    if spec.variableSpeedLimit.usedBackupSpeedLimit then
                        spec.variableSpeedLimit.usedBackupSpeedLimit = false
                        self.speedLimit = spec.variableSpeedLimit.lastAdjustedSpeedLimit or defaultSpeedLimit
                        if (spec.variableSpeedLimit.lastAdjustedSpeedLimitType or fillTypeIndex) ~ = fillTypeIndex then
                            self.speedLimit = defaultSpeedLimit
                        end
                    end

                    local threshold = targetLiterPerSecond * 0.15
                    local changeAmount = math.max( math.floor((litersPerSecond * 2 ) / targetLiterPerSecond), 1 )
                    if litersPerSecond > targetLiterPerSecond + threshold then
                        self.speedLimit = math.max( self.speedLimit - changeAmount, spec.variableSpeedLimit.minSpeedLimit)
                    elseif litersPerSecond < targetLiterPerSecond - threshold then
                            self.speedLimit = math.min( self.speedLimit + changeAmount, spec.variableSpeedLimit.maxSpeedLimit)
                        end

                        spec.variableSpeedLimit.lastAdjustedSpeedLimit = self.speedLimit
                        spec.variableSpeedLimit.lastAdjustedSpeedLimitType = fillTypeIndex
                    else
                            spec.variableSpeedLimit.usedBackupSpeedLimit = true
                            self.speedLimit = spec.variableSpeedLimit.backupSpeedLimit
                        end

                        spec.variableSpeedLimit.pickupPerSecondTimer = 0
                        spec.variableSpeedLimit.pickupPerSecond = 0
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
function Baler:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_baler

    local showBaleLimitWarning = false
    local isTurnedOn = self:getIsTurnedOn()

    if isTurnedOn then
        if not g_currentMission.slotSystem:getCanAddLimitedObjects(SlotSystem.LIMITED_OBJECT_BALE, 1 ) then
            showBaleLimitWarning = true
        end

        if self.isClient then

            if spec.lastAreaBiggerZero and spec.fillEffectType ~ = FillType.UNKNOWN then
                spec.lastAreaBiggerZeroTime = 500
            elseif spec.lastAreaBiggerZeroTime > 0 then
                    spec.lastAreaBiggerZeroTime = math.max(spec.lastAreaBiggerZeroTime - dt, 0 )
                end

                if spec.lastAreaBiggerZeroTime > 0 then
                    if spec.fillEffectType ~ = FillType.UNKNOWN then
                        g_effectManager:setEffectTypeInfo(spec.fillEffects, spec.fillEffectType)
                    end

                    g_effectManager:startEffects(spec.fillEffects)

                    local loadPercentage = spec.pickUpLitersBuffer:get( 1000 ) / spec.maxPickupLitersPerSecond
                    g_effectManager:setDensity(spec.fillEffects, math.max(loadPercentage, 0.40 ))
                else
                        g_effectManager:stopEffects(spec.fillEffects)
                    end

                    if spec.knotCleaningTimer < = g_currentMission.time then
                        g_soundManager:playSample(spec.samples.knotCleaning)
                        spec.knotCleaningTimer = g_currentMission.time + spec.knotCleaningTime
                    end

                    if spec.compactingAnimation ~ = nil and spec.unloadingState = = Baler.UNLOADING_CLOSED then
                        if spec.compactingAnimationTime < = g_currentMission.time then
                            local fillLevel = self:getFillUnitFillLevelPercentage(spec.fillUnitIndex)
                            local stopTime = MathUtil.lerp(spec.compactingAnimationMinTime, spec.compactingAnimationMaxTime, fillLevel)
                            if stopTime > 0 then
                                self:setAnimationStopTime(spec.compactingAnimation, math.clamp(stopTime, 0 , 1 ))
                                self:playAnimation(spec.compactingAnimation, spec.compactingAnimationSpeed, self:getAnimationTime(spec.compactingAnimation), false )
                                spec.compactingAnimationTime = math.huge
                            end
                        end

                        if spec.compactingAnimationTime = = math.huge then
                            if not self:getIsAnimationPlaying(spec.compactingAnimation) then
                                spec.compactingAnimationCompactTimer = spec.compactingAnimationCompactTimer - dt
                                if spec.compactingAnimationCompactTimer < 0 then
                                    self:playAnimation(spec.compactingAnimation, - spec.compactingAnimationSpeed, self:getAnimationTime(spec.compactingAnimation), false )
                                    spec.compactingAnimationCompactTimer = spec.compactingAnimationCompactTime
                                end

                                if self:getAnimationTime(spec.compactingAnimation) = = 0 then
                                    spec.compactingAnimationTime = g_currentMission.time + spec.compactingAnimationInterval
                                end
                            end
                        end
                    end
                end
            else
                    if spec.isBaleUnloading and self.isServer then
                        local deltaTime = dt / spec.baleUnloadingTime
                        self:moveBales(deltaTime)
                    end
                end

                if self.isClient then
                    --delete dummy bale on client after physical bale is displayed
                    if spec.unloadingState = = Baler.UNLOADING_OPEN then
                        local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]
                        if getNumOfChildren(baleTypeDef.baleNode) > 0 then
                            delete(getChildAt(baleTypeDef.baleNode, 0 ))
                        end
                    end
                end

                if spec.unloadingState = = Baler.UNLOADING_OPENING then
                    local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]
                    local isPlaying = self:getIsAnimationPlaying(baleTypeDef.animations.unloading)
                    local animTime = self:getRealAnimationTime(baleTypeDef.animations.unloading)
                    if not isPlaying or animTime > = baleTypeDef.animations.dropAnimationTime then
                        if #spec.bales > 0 then
                            self:dropBale( 1 )
                            if self.isServer then
                                self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, - math.huge, self:getFillUnitFillType(spec.fillUnitIndex), ToolType.UNDEFINED)
                                spec.buffer.unloadingStarted = false

                                for fillType, _ in pairs(spec.pickupFillTypes) do
                                    spec.pickupFillTypes[fillType] = 0
                                end

                                if self:getFillUnitFillLevel(spec.fillUnitIndex) = = 0 then
                                    if spec.preSelectedBaleTypeIndex ~ = spec.currentBaleTypeIndex then
                                        self:setBaleTypeIndex(spec.preSelectedBaleTypeIndex, true )
                                    end
                                end
                            end
                        end
                        if not isPlaying then
                            spec.unloadingState = Baler.UNLOADING_OPEN

                            if self.isClient then
                                g_soundManager:stopSample(spec.samples.eject)
                                g_soundManager:stopSample(spec.samples.door)
                                g_animationManager:stopAnimations(spec.unloadAnimationNodes)
                            end
                        end
                    else
                            g_animationManager:startAnimations(spec.unloadAnimationNodes)
                        end
                    elseif spec.unloadingState = = Baler.UNLOADING_CLOSING then
                            if not self:getIsAnimationPlaying(spec.baleCloseAnimationName) then
                                spec.unloadingState = Baler.UNLOADING_CLOSED
                                if self.isClient then
                                    g_soundManager:stopSample(spec.samples.door)
                                end
                            end
                        end

                        -- on client side it can happen that the baler is closed 1 frame before the animation is synced completelly
                        -- in this case we drop the bale here
                        if spec.unloadingState = = Baler.UNLOADING_OPEN or spec.unloadingState = = Baler.UNLOADING_CLOSING then
                            if not self.isServer then
                                if #spec.bales > 0 then
                                    self:dropBale( 1 )
                                end
                            end
                        end

                        Baler.updateActionEvents( self )

                        if self.isServer then
                            --automatically drop bale and close door afterwards
                            if (spec.automaticDrop ~ = nil and spec.automaticDrop) or self:getIsAIActive() then
                                if self:isUnloadingAllowed() then
                                    if spec.hasUnloadingAnimation or spec.allowsBaleUnloading then
                                        if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                                            if #spec.bales > 0 then
                                                self:setIsUnloadingBale( true )
                                            end
                                        end
                                    end
                                end

                                if spec.hasUnloadingAnimation then
                                    if spec.unloadingState = = Baler.UNLOADING_OPEN then
                                        self:setIsUnloadingBale( false )
                                    end
                                end
                            end

                            spec.pickUpLitersBuffer:add(spec.workAreaParameters.lastPickedUpLiters)

                            if spec.additives.isActiveTimer > 0 then
                                spec.additives.isActiveTimer = spec.additives.isActiveTimer - dt
                                if spec.additives.isActiveTimer < 0 then
                                    spec.additives.isActiveTimer = 0
                                    spec.additives.isActive = false

                                    if self.isClient then
                                        g_effectManager:stopEffects(spec.additiveEffects)
                                    end

                                    self:raiseDirtyFlags(spec.dirtyFlag)
                                end
                            end

                            if spec.platformAutomaticDrop then
                                if spec.platformReadyToDrop then
                                    self:dropBaleFromPlatform( true )
                                end
                            end

                            -- automatically drop bale on platform if new bale is ready
                                if spec.hasPlatform then
                                    if #spec.bales > 0 then
                                        if spec.platformReadyToDrop then
                                            self:dropBaleFromPlatform( true )
                                        end
                                    end

                                    -- mount the bale directly to the bale dropper since we never stop moving, so DynamicMountAttacher spec would mount it
                                    if spec.hasDynamicMountPlatform then
                                        if spec.platformMountDelay > 0 then
                                            spec.platformMountDelay = spec.platformMountDelay - 1
                                            if spec.platformMountDelay = = 0 then
                                                self:forceDynamicMountPendingObjects( true )
                                            end
                                        else
                                                -- play drop animation if bale was lost
                                                    if spec.platformReadyToDrop then
                                                        if not self:getHasDynamicMountedObjects() then
                                                            self:dropBaleFromPlatform( false )
                                                        end
                                                    end
                                                end
                                            end
                                        end

                                        -- unload from buffer to bale chamber once it is full
                                        if spec.nonStopBaling then
                                            local lastUnloadingStarted = spec.buffer.unloadingStarted

                                            local bufferLevel = self:getFillUnitFillLevel(spec.buffer.fillUnitIndex)
                                            if bufferLevel > 0 then
                                                local capacity = self:getFillUnitCapacity(spec.buffer.fillUnitIndex)
                                                if isTurnedOn and MathUtil.round(bufferLevel / capacity, 2 ) > = spec.buffer.overloadingStartFillLevelPct then
                                                    capacity = self:getFillUnitCapacity(spec.fillUnitIndex)
                                                    if capacity = = 0 or capacity = = math.huge or self:getFillUnitFreeCapacity(spec.fillUnitIndex) > 0 then
                                                        if not spec.buffer.unloadingStarted then
                                                            if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                                                                spec.buffer.unloadingStarted = true
                                                                spec.buffer.overloadingTimer = 0

                                                                if spec.buffer.overloadAnimation ~ = nil then
                                                                    self:playAnimation(spec.buffer.overloadAnimation, spec.buffer.overloadAnimationSpeed)
                                                                end
                                                            end
                                                        end
                                                    end
                                                end

                                                if spec.buffer.unloadingStarted then
                                                    spec.buffer.overloadingTimer = spec.buffer.overloadingTimer + dt
                                                    if spec.buffer.overloadingTimer > = spec.buffer.overloadingDelay then
                                                        if self:getFillUnitFreeCapacity(spec.fillUnitIndex) > 0 then
                                                            capacity = self:getFillUnitCapacity(spec.buffer.fillUnitIndex)
                                                            local delta = math.min(capacity / spec.buffer.overloadingDuration * dt, bufferLevel)
                                                            local sourceFillType = self:getFillUnitFillType(spec.buffer.fillUnitIndex)
                                                            local unloadInfo = self:getFillVolumeUnloadInfo(spec.buffer.unloadInfoIndex)
                                                            local realDelta = self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.buffer.fillUnitIndex, - delta, sourceFillType, ToolType.UNDEFINED, unloadInfo)

                                                            local targetFillType = self:getFillUnitFillType(spec.fillUnitIndex)
                                                            if targetFillType = = FillType.UNKNOWN then
                                                                targetFillType = sourceFillType
                                                            end

                                                            local overloadedLiters = - realDelta
                                                            if spec.additives.available and spec.additives.appliedByBufferOverloading then
                                                                local fillTypeSupported = false
                                                                for i = 1 , #spec.additives.fillTypes do
                                                                    if targetFillType = = spec.additives.fillTypes[i] then
                                                                        fillTypeSupported = true
                                                                        break
                                                                    end
                                                                end

                                                                if fillTypeSupported then
                                                                    local additivesFillLevel = self:getFillUnitFillLevel(spec.additives.fillUnitIndex)
                                                                    if additivesFillLevel > 0 then
                                                                        local usage = spec.additives.usage * overloadedLiters
                                                                        if usage > 0 then
                                                                            local availableUsage = math.min(additivesFillLevel / usage, 1 )

                                                                            overloadedLiters = overloadedLiters * ( 1 + 0.05 * availableUsage)

                                                                            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.additives.fillUnitIndex, - usage, self:getFillUnitFillType(spec.additives.fillUnitIndex), ToolType.UNDEFINED)

                                                                            spec.additives.isActiveTimer = 250
                                                                            spec.additives.isActive = true
                                                                            self:raiseDirtyFlags(spec.dirtyFlag)

                                                                            if self.isClient then
                                                                                g_effectManager:setEffectTypeInfo(spec.additiveEffects, FillType.LIQUIDFERTILIZER)
                                                                                g_effectManager:startEffects(spec.additiveEffects)
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, overloadedLiters, targetFillType, ToolType.UNDEFINED, nil )

                                                            -- if we unload a unfinished bale we first empty the buffer, drop bale on platform and then unload the new bale
                                                                if spec.buffer.fillLevelToEmpty > 0 then
                                                                    spec.buffer.fillLevelToEmpty = math.max(spec.buffer.fillLevelToEmpty - delta, 0 )

                                                                    if spec.buffer.fillLevelToEmpty = = 0 then
                                                                        spec.platformDelayedDropping = true
                                                                        spec.buffer.unloadingStarted = false
                                                                    end
                                                                end
                                                            end
                                                        end

                                                        -- baler is full
                                                        if self:getFillUnitFillLevelPercentage(spec.fillUnitIndex) = = 1 or not isTurnedOn then
                                                            spec.buffer.unloadingStarted = false
                                                        end
                                                    end
                                                else
                                                        if not spec.buffer.fillMainUnitAfterOverload then
                                                            spec.buffer.unloadingStarted = false
                                                        end
                                                    end

                                                    if lastUnloadingStarted ~ = spec.buffer.unloadingStarted then
                                                        if self.isClient then
                                                            if spec.buffer.unloadingStarted then
                                                                local fillType = self:getFillUnitFillType(spec.buffer.fillUnitIndex)
                                                                g_effectManager:setEffectTypeInfo(spec.buffer.overloadingEffects, fillType)
                                                                g_effectManager:startEffects(spec.buffer.overloadingEffects)

                                                                g_animationManager:startAnimations(spec.buffer.overloadingAnimationNodes)

                                                                g_soundManager:playSamples(spec.buffer.samplesOverloadingStart)
                                                                g_soundManager:playSamples(spec.buffer.samplesOverloadingWork, 0 , spec.buffer.samplesOverloadingStart[ 1 ])
                                                            else
                                                                    g_effectManager:stopEffects(spec.buffer.overloadingEffects)

                                                                    g_animationManager:stopAnimations(spec.buffer.overloadingAnimationNodes)

                                                                    g_soundManager:stopSamples(spec.buffer.samplesOverloadingStart)
                                                                    if g_soundManager:getIsSamplePlaying(spec.buffer.samplesOverloadingWork[ 1 ]) then
                                                                        g_soundManager:stopSamples(spec.buffer.samplesOverloadingWork)
                                                                        g_soundManager:playSamples(spec.buffer.samplesOverloadingStop)
                                                                    end
                                                                end
                                                            end

                                                            self:raiseDirtyFlags(spec.dirtyFlag)
                                                        end

                                                        if spec.buffer.overloadAnimation ~ = nil then
                                                            if not self:getIsAnimationPlaying(spec.buffer.overloadAnimation) and self:getAnimationTime(spec.buffer.overloadAnimation) > 0.5 then
                                                                self:playAnimation(spec.buffer.overloadAnimation, - spec.buffer.overloadAnimationSpeed)
                                                            end
                                                        end

                                                        if isTurnedOn then
                                                            self:raiseActive()
                                                        end
                                                    end
                                                end

                                                if self.isServer then
                                                    if spec.showBaleLimitWarning ~ = showBaleLimitWarning then
                                                        spec.showBaleLimitWarning = showBaleLimitWarning
                                                        self:raiseDirtyFlags(spec.dirtyFlag)
                                                    end
                                                end

                                                if spec.hasPlatform then
                                                    -- unload bale after last bale was dropped from platform
                                                    if spec.platformDelayedDropping then
                                                        if not spec.platformDropInProgress then
                                                            Baler.actionEventUnloading( self )
                                                            spec.platformDelayedDropping = false
                                                        end
                                                    end

                                                    if spec.platformDropInProgress and not self:getIsAnimationPlaying(spec.platformAnimation) then
                                                        spec.platformDropInProgress = false
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
function Baler:onWriteStream(streamId, connection)
    local spec = self.spec_baler

    if spec.hasUnloadingAnimation then
        streamWriteUIntN(streamId, spec.unloadingState, 7 )
        local animTime = 0
        if spec.unloadingState = = Baler.UNLOADING_CLOSED or spec.unloadingState = = Baler.UNLOADING_CLOSING then
            animTime = self:getRealAnimationTime(spec.baleCloseAnimationName)
        elseif spec.unloadingState = = Baler.UNLOADING_OPEN or spec.unloadingState = = Baler.UNLOADING_OPENING then
                animTime = self:getRealAnimationTime(spec.baleUnloadAnimationName)
            end
            streamWriteFloat32(streamId, animTime)
        end

        streamWriteUInt8(streamId, #spec.bales)
        for i = 1 , #spec.bales do
            local bale = spec.bales[i]
            streamWriteIntN(streamId, bale.fillType, FillTypeManager.SEND_NUM_BITS)
            streamWriteFloat32(streamId, bale.fillLevel)
            if spec.baleAnimCurve ~ = nil then
                streamWriteFloat32(streamId, bale.time )
            end
        end

        streamWriteBool(streamId, spec.lastAreaBiggerZero)

        if spec.hasPlatform then
            streamWriteBool(streamId, spec.platformReadyToDrop)
        end

        streamWriteUIntN(streamId, spec.currentBaleTypeIndex, BalerBaleTypeEvent.BALE_TYPE_SEND_NUM_BITS)
        streamWriteUIntN(streamId, spec.preSelectedBaleTypeIndex, BalerBaleTypeEvent.BALE_TYPE_SEND_NUM_BITS)

        streamWriteFloat32(streamId, self:getFillUnitCapacity(spec.fillUnitIndex))
        streamWriteFloat32(streamId, self:getFillUnitFillLevel(spec.fillUnitIndex))
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
function Baler:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_baler

    if not connection:getIsServer() then
        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
            streamWriteBool(streamId, spec.lastAreaBiggerZero)
            streamWriteUIntN(streamId, spec.fillEffectTypeSent, FillTypeManager.SEND_NUM_BITS)
            streamWriteBool(streamId, spec.showBaleLimitWarning)

            if spec.nonStopBaling then
                streamWriteBool(streamId, spec.buffer.unloadingStarted)
            end

            streamWriteBool(streamId, spec.additives.isActive)
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
function Baler.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations)
    and SpecializationUtil.hasSpecialization( WorkArea , specializations)
    and SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations)
    and SpecializationUtil.hasSpecialization( AnimatedVehicle , specializations)
    and SpecializationUtil.hasSpecialization(Consumable, specializations)
end

```

### processBalerArea

**Description**

**Definition**

> processBalerArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Baler:processBalerArea(workArea, dt)
    local spec = self.spec_baler

    if not self.isServer and self.currentUpdateDistance > Baler.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local lsx, lsy, lsz, lex, ley, lez, lineRadius = DensityMapHeightUtil.getLineByArea(workArea.start, workArea.width, workArea.height)
    if self.isServer then
        spec.fillEffectType = FillType.UNKNOWN
    end

    local mission = self:getMissionByWorkArea(workArea)

    for fillTypeIndex, _ in pairs(spec.pickupFillTypes) do
        local pickedUpLiters = - DensityMapHeightUtil.tipToGroundAroundLine( self , - math.huge, fillTypeIndex, lsx, lsy, lsz, lex, ley, lez, lineRadius, nil , nil , false , nil )
        if pickedUpLiters > 0 then
            if self.isServer then
                spec.fillEffectType = fillTypeIndex

                if spec.additives.available and not spec.additives.appliedByBufferOverloading then
                    local fillTypeSupported = false
                    for i = 1 , #spec.additives.fillTypes do
                        if fillTypeIndex = = spec.additives.fillTypes[i] then
                            fillTypeSupported = true
                            break
                        end
                    end

                    if fillTypeSupported then
                        local additivesFillLevel = self:getFillUnitFillLevel(spec.additives.fillUnitIndex)
                        if additivesFillLevel > 0 then
                            local usage = spec.additives.usage * pickedUpLiters
                            if usage > 0 then
                                local availableUsage = math.min(additivesFillLevel / usage, 1 )

                                pickedUpLiters = pickedUpLiters * ( 1 + 0.05 * availableUsage)

                                self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.additives.fillUnitIndex, - usage, self:getFillUnitFillType(spec.additives.fillUnitIndex), ToolType.UNDEFINED)

                                spec.additives.isActiveTimer = 250
                                spec.additives.isActive = true
                                self:raiseDirtyFlags(spec.dirtyFlag)

                                if self.isClient then
                                    g_effectManager:setEffectTypeInfo(spec.additiveEffects, FillType.LIQUIDFERTILIZER)
                                    g_effectManager:startEffects(spec.additiveEffects)
                                end
                            end
                        end
                    end
                end
            end

            spec.pickupFillTypes[fillTypeIndex] = spec.pickupFillTypes[fillTypeIndex] + pickedUpLiters

            spec.workAreaParameters.lastMissionUniqueId = mission ~ = nil and mission:getUniqueId() or nil
            spec.workAreaParameters.lastPickedUpLiters = spec.workAreaParameters.lastPickedUpLiters + pickedUpLiters

            return pickedUpLiters, pickedUpLiters
        end
    end

    return 0 , 0
end

```

### registerBalerXMLPaths

**Description**

**Definition**

> registerBalerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Baler.registerBalerXMLPaths(schema, basePath)
    schema:register(XMLValueType.FLOAT, basePath .. "#fillScale" , "Fill scale" , 1 )
    schema:register(XMLValueType.INT, basePath .. "#fillUnitIndex" , "Fill unit index" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. "#consumableUsage" , "Usage of bale net or twine per bale" , 0.025 )
    schema:register(XMLValueType.BOOL, basePath .. "#useDropLandOwnershipForBales" , "Defines if the produced bales are always owned by the land owner of the current location while dropping the bale.If not, the owner is either the owner from the last workArea pickup location(if available) or the owner of the bale as default." , false )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleAnimation#spacing" , "Spacing between bales" , 0 )
        schema:register(XMLValueType.BOOL, basePath .. ".baleAnimation#enableCollision" , "Enable collision of bales with any other object" , true )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleAnimation.key(?)#time" , "Key time" )
        schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".baleAnimation.key(?)#pos" , "Key position" )
        schema:register(XMLValueType.VECTOR_ROT, basePath .. ".baleAnimation.key(?)#rot" , "Key rotation" )

        schema:register(XMLValueType.STRING, basePath .. ".baleAnimation#closeAnimationName" , "Close animation name" )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleAnimation#closeAnimationSpeed" , "Close animation speed" , 1 )

        schema:register(XMLValueType.BOOL, basePath .. ".automaticDrop#enabled" , "Automatic drop default enabled" , "true on mobile" )
        schema:register(XMLValueType.BOOL, basePath .. ".automaticDrop#toggleable" , "Automatic bale drop can be toggled" , "false on mobile" )

        schema:register(XMLValueType.L10N_STRING, basePath .. ".baleTypes#changeText" , "Change bale size text" , "action_changeBaleSize" )
        schema:register(XMLValueType.BOOL, basePath .. ".baleTypes.baleType(?)#isRoundBale" , "Is round bale" , false )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleTypes.baleType(?)#width" , "Bale width" , 1.2 )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleTypes.baleType(?)#height" , "Bale height" , 0.9 )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleTypes.baleType(?)#length" , "Bale length" , 2.4 )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleTypes.baleType(?)#diameter" , "Bale diameter" , 2.8 )
        schema:register(XMLValueType.BOOL, basePath .. ".baleTypes.baleType(?)#isDefault" , "Bale type is selected by default" , false )
        schema:register(XMLValueType.FLOAT, basePath .. ".baleTypes.baleType(?)#consumableUsage" , "Usage of bale net or twine per bale" , 0.025 )
        schema:register(XMLValueType.STRING, basePath .. ".baleTypes.baleType(?)#chamberBaleVariationId" , "Variation identifier of the dummy bale in the chamber" , "DEFAULT" )
        schema:register(XMLValueType.STRING, basePath .. ".baleTypes.baleType(?)#defaultBaleVariationId" , "Variation identifier of the final bale of no consumables are used" , "DEFAULT" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".baleTypes.baleType(?).nodes#baleNode" , "Bale link node" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".baleTypes.baleType(?).nodes#baleRootNode" , "Bale root node" , "Same as baleNode" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. ".baleTypes.baleType(?).nodes#scaleNode" , "Bale scale node" )
        schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".baleTypes.baleType(?).nodes#scaleComponents" , "Bale scale component" )

        schema:register(XMLValueType.STRING, basePath .. ".baleTypes.baleType(?).animations#fillAnimation" , "Fill animation while this bale type is active" )
            schema:register(XMLValueType.STRING, basePath .. ".baleTypes.baleType(?).animations#unloadAnimation" , "Unload animation while this bale type is active" )
                schema:register(XMLValueType.FLOAT, basePath .. ".baleTypes.baleType(?).animations#unloadAnimationSpeed" , "Unload animation speed" , 1 )
                schema:register(XMLValueType.TIME, basePath .. ".baleTypes.baleType(?).animations#dropAnimationTime" , "Specific time in #unloadAnimation when to drop the bale" , "At the end of the unloading animation" )

                schema:register(XMLValueType.NODE_INDEX, basePath .. ".baleTypes.baleType(?).detailVisibilityCutNode(?)#node" , "Reference node for details visibility cut" )
                    schema:register(XMLValueType.INT, basePath .. ".baleTypes.baleType(?).detailVisibilityCutNode(?)#axis" , "Axis of visibility cut [1, 3]" , 3 )
                    schema:register(XMLValueType.INT, basePath .. ".baleTypes.baleType(?).detailVisibilityCutNode(?)#direction" , "Direction of visibility cut [-1, 1]" , 1 )

                    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath .. ".baleTypes.baleType(?)" )

                    schema:register(XMLValueType.FLOAT, basePath .. "#unfinishedBaleThreshold" , "Threshold to unload a unfinished bale" , 2000 )
                    schema:register(XMLValueType.BOOL, basePath .. "#canUnloadUnfinishedBale" , "Can unload unfinished bale" , false )

                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "work" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "eject" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "unload" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "door" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "knotCleaning" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "bufferOverloadingStart(?)" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "bufferOverloadingStop(?)" )
                    SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "bufferOverloadingWork(?)" )

                    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".animationNodes" )
                    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".unloadAnimationNodes" )

                    EffectManager.registerEffectXMLPaths(schema, basePath .. ".fillEffect" )
                    EffectManager.registerEffectXMLPaths(schema, basePath .. ".additiveEffects" )

                    schema:register(XMLValueType.STRING, basePath .. ".knotingAnimation#name" , "Knoting animation name" )
                    schema:register(XMLValueType.FLOAT, basePath .. ".knotingAnimation#speed" , "Knoting animation speed" , 1 )

                    schema:register(XMLValueType.STRING, basePath .. ".compactingAnimation#name" , "Compacting animation name" )
                    schema:register(XMLValueType.FLOAT, basePath .. ".compactingAnimation#interval" , "Compacting interval" , 60 )
                    schema:register(XMLValueType.FLOAT, basePath .. ".compactingAnimation#compactTime" , "Compacting time" , 5 )
                    schema:register(XMLValueType.FLOAT, basePath .. ".compactingAnimation#speed" , "Compacting animation speed" , 1 )
                    schema:register(XMLValueType.FLOAT, basePath .. ".compactingAnimation#minFillLevelTime" , "Compacting min.fill level animation target time" , 1 )
                    schema:register(XMLValueType.FLOAT, basePath .. ".compactingAnimation#maxFillLevelTime" , "Compacting max.fill level animation target time" , 0.1 )

                    schema:register(XMLValueType.STRING, basePath .. "#maxPickupLitersPerSecond" , "Max pickup liters per second" , 500 )

                    schema:register(XMLValueType.BOOL, basePath .. ".baleUnloading#allowed" , "Bale unloading allowed" , false )
                    schema:register(XMLValueType.FLOAT, basePath .. ".baleUnloading#time" , "Bale unloading time" , 4 )
                    schema:register(XMLValueType.FLOAT, basePath .. ".baleUnloading#foldThreshold" , "Bale unloading fold threshold" , 0.25 )

                    schema:register(XMLValueType.L10N_STRING, basePath .. ".automaticDrop#textPos" , "Positive toggle automatic drop text" , "action_toggleAutomaticBaleDropPos" )
                    schema:register(XMLValueType.L10N_STRING, basePath .. ".automaticDrop#textNeg" , "Negative toggle automatic drop text" , "action_toggleAutomaticBaleDropNeg" )

                    schema:register(XMLValueType.STRING, basePath .. ".platform#animationName" , "Platform animation" )
                    schema:register(XMLValueType.FLOAT, basePath .. ".platform#nextBaleTime" , "Animation time when directly the next bale is unloaded after dropping from platform" , 0 )
                    schema:register(XMLValueType.BOOL, basePath .. ".platform#automaticDrop" , "Bale is automatically dropped from platform" , "true on mobile" )
                    schema:register(XMLValueType.FLOAT, basePath .. ".platform#aiSpeed" , "Speed of AI while dropping a bale from platform(km/h)" , 3 )

                        schema:register(XMLValueType.INT, basePath .. ".buffer#fillUnitIndex" , "Buffer fill unit index" )
                        schema:register(XMLValueType.INT, basePath .. ".buffer#unloadInfoIndex" , "Fill volume unload info index index" , 1 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".buffer#capacityPercentage" , "If set, this percentage of the bale capacity is set for the buffer.If not set the defined capacity from the xml is used." )
                            schema:register(XMLValueType.TIME, basePath .. ".buffer#overloadingDuration" , "Duration of overloading from buffer to baler unit(sec)" , 0.5 )
                            schema:register(XMLValueType.TIME, basePath .. ".buffer#overloadingDelay" , "Time until the real overloading is starting(can be used to wait for the effects to be fully fade in) (sec)" , 0 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".buffer#overloadingStartFillLevelPct" , "Fill level percentage [0-1] of the buffer to start the overloading" , 1 )
                                schema:register(XMLValueType.BOOL, basePath .. ".buffer#fillMainUnitAfterOverload" , "After overloading the full buffer to the main unit it will continue filling the main unit until it's full" , false )
                                schema:register(XMLValueType.STRING, basePath .. ".buffer#balerDisplayType" , "Forced fill type to display on baler unit" )

                                schema:register(XMLValueType.NODE_INDEX, basePath .. ".buffer.dummyBale#node" , "Dummy bale link node" )
                                schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".buffer.dummyBale#scaleComponents" , "Dummy bale link scale components" , "1 1 0" )

                                schema:register(XMLValueType.STRING, basePath .. ".buffer.overloadAnimation#name" , "Name of overload animation" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".buffer.overloadAnimation#speedScale" , "Speed of overload animation" , 1 )

                                schema:register(XMLValueType.STRING, basePath .. ".buffer.loadingStateAnimation#name" , "Name of loading state animation" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".buffer.loadingStateAnimation#speedScale" , "Speed of loading state animation" , 1 )

                                EffectManager.registerEffectXMLPaths(schema, basePath .. ".buffer.overloadingEffect" )
                                AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".buffer.overloadingAnimationNodes" )

                                schema:register(XMLValueType.FLOAT, basePath .. ".variableSpeedLimit#targetLiterPerSecond" , "Target liters per second" , 200 )
                                schema:register(XMLValueType.TIME, basePath .. ".variableSpeedLimit#changeInterval" , "Interval which adjusts speed limit to conditions" , 1 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".variableSpeedLimit#minSpeedLimit" , "Min.speed limit" , 5 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".variableSpeedLimit#maxSpeedLimit" , "Max.speed limit" , 15 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".variableSpeedLimit#defaultSpeedLimit" , "Default speed limit" , 10 )
                                schema:register(XMLValueType.STRING, basePath .. ".variableSpeedLimit.target(?)#fillType" , "Name of fill type" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".variableSpeedLimit.target(?)#targetLiterPerSecond" , "Target liters per second with this fill type" , 200 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".variableSpeedLimit.target(?)#defaultSpeedLimit" , "Default speed limit with this fill type" , 10 )

                                schema:register(XMLValueType.INT, basePath .. ".additives#fillUnitIndex" , "Additives fill unit index" )
                                schema:register(XMLValueType.FLOAT, basePath .. ".additives#usage" , "Usage per picked up liter" , 0.0000275 )
                                schema:register(XMLValueType.STRING, basePath .. ".additives#fillTypes" , "Fill types to apply additives" , "GRASS_WINDROW" )
                                schema:register(XMLValueType.BOOL, basePath .. ".additives#appliedByBufferOverloading" , "Additives are applied while the buffer unit is overloaded into main unit" , false )
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
function Baler.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterExternalActionEvents" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onRootVehicleChanged" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onChangedFillType" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Baler )
    SpecializationUtil.registerEventListener(vehicleType, "onConsumableVariationChanged" , Baler )
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
function Baler.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onBalerUnloadingStarted" )
    SpecializationUtil.registerEvent(vehicleType, "onBalerUnloadingFinished" )
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
function Baler.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processBalerArea" , Baler.processBalerArea)
    SpecializationUtil.registerFunction(vehicleType, "setBaleTypeIndex" , Baler.setBaleTypeIndex)
    SpecializationUtil.registerFunction(vehicleType, "isUnloadingAllowed" , Baler.isUnloadingAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getTimeFromLevel" , Baler.getTimeFromLevel)
    SpecializationUtil.registerFunction(vehicleType, "moveBales" , Baler.moveBales)
    SpecializationUtil.registerFunction(vehicleType, "moveBale" , Baler.moveBale)
    SpecializationUtil.registerFunction(vehicleType, "setIsUnloadingBale" , Baler.setIsUnloadingBale)
    SpecializationUtil.registerFunction(vehicleType, "getIsBaleUnloading" , Baler.getIsBaleUnloading)
    SpecializationUtil.registerFunction(vehicleType, "dropBale" , Baler.dropBale)
    SpecializationUtil.registerFunction(vehicleType, "finishBale" , Baler.finishBale)
    SpecializationUtil.registerFunction(vehicleType, "createBale" , Baler.createBale)
    SpecializationUtil.registerFunction(vehicleType, "setBaleTime" , Baler.setBaleTime)
    SpecializationUtil.registerFunction(vehicleType, "getCanUnloadUnfinishedBale" , Baler.getCanUnloadUnfinishedBale)
    SpecializationUtil.registerFunction(vehicleType, "setBalerAutomaticDrop" , Baler.setBalerAutomaticDrop)
    SpecializationUtil.registerFunction(vehicleType, "updateDummyBale" , Baler.updateDummyBale)
    SpecializationUtil.registerFunction(vehicleType, "deleteDummyBale" , Baler.deleteDummyBale)
    SpecializationUtil.registerFunction(vehicleType, "createDummyBale" , Baler.createDummyBale)
    SpecializationUtil.registerFunction(vehicleType, "handleUnloadingBaleEvent" , Baler.handleUnloadingBaleEvent)
    SpecializationUtil.registerFunction(vehicleType, "dropBaleFromPlatform" , Baler.dropBaleFromPlatform)
    SpecializationUtil.registerFunction(vehicleType, "getBalerBaleOwnerFarmId" , Baler.getBalerBaleOwnerFarmId)
    SpecializationUtil.registerFunction(vehicleType, "getIsRoundBaler" , Baler.getIsRoundBaler)
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
function Baler.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , Baler.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Baler.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , Baler.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , Baler.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , Baler.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , Baler.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , Baler.getConsumingLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRequiresPower" , Baler.getRequiresPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Baler.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAttachedTo" , Baler.getIsAttachedTo)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowDynamicMountFillLevelInfo" , Baler.getAllowDynamicMountFillLevelInfo)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAlarmTriggerIsActive" , Baler.getAlarmTriggerIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadAlarmTrigger" , Baler.loadAlarmTrigger)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShowConsumableEmptyWarning" , Baler.getShowConsumableEmptyWarning)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , Baler.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , Baler.removeFromPhysics)
end

```

### removeFromPhysics

**Description**

> Add to physics

**Definition**

> removeFromPhysics()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function Baler:removeFromPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    local spec = self.spec_baler
    for baleIndex, bale in pairs(spec.bales) do
        if bale.baleObject ~ = nil then
            bale.baleObject:removeFromPhysics()

            if not spec.hasUnloadingAnimation then
                if bale.baleJointIndex ~ = nil then
                    removeJoint(bale.baleJointIndex)
                    bale.baleJointIndex = nil
                end
            end
        end
    end

    return true
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
function Baler:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_baler
    -- never save bales on round balers since they can only have one bale and that is saved in the fillUnit
    -- if the fill unit is not full we try to save the bale(maybe the user saves while unloading)
        if not spec.hasUnloadingAnimation or self:getFillUnitFreeCapacity(spec.fillUnitIndex) > 0 then
            xmlFile:setValue(key .. "#numBales" , #spec.bales)

            for k, bale in ipairs(spec.bales) do
                local baleKey = string.format( "%s.bale(%d)" , key, k - 1 )
                xmlFile:setValue(baleKey .. "#filename" , bale.filename)
                xmlFile:setValue(baleKey .. "#variationId" , bale.baleObject:getVariationId())
                xmlFile:setValue(baleKey .. "#ownerFarmId" , bale.baleObject:getOwnerFarmId())

                local fillTypeStr = "UNKNOWN"
                if bale.fillType ~ = FillType.UNKNOWN then
                    fillTypeStr = g_fillTypeManager:getFillTypeNameByIndex(bale.fillType)
                end
                xmlFile:setValue(baleKey .. "#fillType" , fillTypeStr)
                xmlFile:setValue(baleKey .. "#fillLevel" , bale.fillLevel)

                if spec.baleAnimCurve ~ = nil then
                    xmlFile:setValue(baleKey .. "#baleTime" , bale.time )
                end
            end
        end

        if spec.hasPlatform then
            xmlFile:setValue(key .. "#platformReadyToDrop" , spec.platformReadyToDrop)
        end

        xmlFile:setValue(key .. "#baleTypeIndex" , spec.currentBaleTypeIndex)
        xmlFile:setValue(key .. "#preSelectedBaleTypeIndex" , spec.preSelectedBaleTypeIndex)

        xmlFile:setValue(key .. "#fillUnitCapacity" , self:getFillUnitCapacity(spec.fillUnitIndex))

        local mission = g_missionManager:getMissionByUniqueId(spec.workAreaParameters.lastMissionUniqueId)
        if mission ~ = nil and mission:getIsRunning() then
            xmlFile:setValue(key .. "#workAreaMissionUniqueId" , mission:getUniqueId())
        end

        if spec.nonStopBaling then
            xmlFile:setValue(key .. "#bufferUnloadingStarted" , spec.buffer.unloadingStarted)
        end
    end

```

### setBalerAutomaticDrop

**Description**

> Sets automatic drop state

**Definition**

> setBalerAutomaticDrop()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Baler:setBalerAutomaticDrop(state, noEventSend)
    local spec = self.spec_baler
    if state = = nil then
        if spec.hasPlatform then
            state = not spec.platformAutomaticDrop
        else
                state = not spec.automaticDrop
            end
        end

        if spec.hasPlatform then
            spec.platformAutomaticDrop = state
        else
                spec.automaticDrop = state
            end

            -- update so we have the unloading action events
            self:requestActionEventUpdate()

            BalerAutomaticDropEvent.sendEvent( self , state, noEventSend)
        end

```

### setBaleTime

**Description**

**Definition**

> setBaleTime()

**Arguments**

| any | i           |
|-----|-------------|
| any | baleTime    |
| any | noEventSend |

**Code**

```lua
function Baler:setBaleTime(i, baleTime, noEventSend)
    local spec = self.spec_baler

    if spec.baleAnimCurve ~ = nil then
        local bale = spec.bales[i]
        if bale ~ = nil then
            bale.time = baleTime
            if self.isServer then
                local x, y, z, rx, ry, rz = spec.baleAnimCurve:get(bale.time )
                setTranslation(bale.baleJointNode, x, y, z)
                setRotation(bale.baleJointNode, rx, ry, rz)
                if bale.baleJointIndex ~ = 0 then
                    setJointFrame(bale.baleJointIndex, 0 , bale.baleJointNode)
                end
            end
            if bale.time > = 1 then
                self:dropBale(i)
            end
            if #spec.bales = = 0 then
                spec.isBaleUnloading = false

                if self.isClient then
                    g_soundManager:stopSample(spec.samples.unload)
                end

                SpecializationUtil.raiseEvent( self , "onBalerUnloadingFinished" , spec.balesToUnload)
            end
            if self.isServer then
                if noEventSend = = nil or not noEventSend then
                    g_server:broadcastEvent(BalerSetBaleTimeEvent.new( self , i, bale.time ), nil , nil , self )
                end
            end
        end
    end
end

```

### setBaleTypeIndex

**Description**

**Definition**

> setBaleTypeIndex()

**Arguments**

| any | baleTypeIndex |
|-----|---------------|
| any | force         |
| any | noEventSend   |

**Code**

```lua
function Baler:setBaleTypeIndex(baleTypeIndex, force, noEventSend)
    local spec = self.spec_baler

    spec.preSelectedBaleTypeIndex = baleTypeIndex
    if self:getFillUnitFillLevel(spec.fillUnitIndex) = = 0 or force then
        spec.currentBaleTypeIndex = baleTypeIndex
    end

    Baler.updateActionEvents( self )

    BalerBaleTypeEvent.sendEvent( self , baleTypeIndex, force, noEventSend)
end

```

### setIsUnloadingBale

**Description**

**Definition**

> setIsUnloadingBale()

**Arguments**

| any | isUnloadingBale |
|-----|-----------------|
| any | noEventSend     |

**Code**

```lua
function Baler:setIsUnloadingBale(isUnloadingBale, noEventSend)
    local spec = self.spec_baler

    if spec.hasUnloadingAnimation then
        if isUnloadingBale then
            if spec.unloadingState ~ = Baler.UNLOADING_OPENING then
                if #spec.bales = = 0 and spec.canUnloadUnfinishedBale then
                    local fillTypeIndex = self:getFillUnitFillType(spec.fillUnitIndex)
                    local fillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
                    if spec.buffer.fillUnitIndex ~ = nil then
                        fillLevel = fillLevel + self:getFillUnitFillLevel(spec.buffer.fillUnitIndex)

                        if fillTypeIndex = = FillType.UNKNOWN then
                            fillTypeIndex = self:getFillUnitFillType(spec.buffer.fillUnitIndex)
                        end
                    end

                    if fillLevel > spec.unfinishedBaleThreshold then
                        local delta = self:getFillUnitFreeCapacity(spec.fillUnitIndex)
                        fillLevel = math.min(fillLevel, self:getFillUnitCapacity(spec.fillUnitIndex))

                        if spec.buffer.fillUnitIndex ~ = nil then
                            local mainFillLevel = self:getFillUnitFillLevel(spec.fillUnitIndex)
                            self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.buffer.fillUnitIndex, - math.max(fillLevel - mainFillLevel, 0 ), self:getFillUnitFillType(spec.buffer.fillUnitIndex), ToolType.UNDEFINED)
                        end

                        spec.lastBaleFillLevel = fillLevel
                        self:setFillUnitFillLevelToDisplay(spec.fillUnitIndex, fillLevel)
                        self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, delta, fillTypeIndex, ToolType.UNDEFINED)
                        spec.buffer.unloadingStarted = false
                    end
                end

                BalerSetIsUnloadingBaleEvent.sendEvent( self , isUnloadingBale, noEventSend)
                spec.unloadingState = Baler.UNLOADING_OPENING
                if self.isClient then
                    g_soundManager:playSample(spec.samples.eject)
                    g_soundManager:playSample(spec.samples.door)
                end

                local baleTypeDef = spec.baleTypes[spec.currentBaleTypeIndex]
                self:playAnimation(baleTypeDef.animations.unloading, baleTypeDef.animations.unloadingSpeed, nil , true )
            end
        else
                if spec.unloadingState ~ = Baler.UNLOADING_CLOSING and spec.unloadingState ~ = Baler.UNLOADING_CLOSED then
                    BalerSetIsUnloadingBaleEvent.sendEvent( self , isUnloadingBale, noEventSend)
                    spec.unloadingState = Baler.UNLOADING_CLOSING
                    if self.isClient then
                        g_soundManager:playSample(spec.samples.door)
                    end
                    self:playAnimation(spec.baleCloseAnimationName, spec.baleCloseAnimationSpeed, nil , true )
                end
            end
        elseif spec.allowsBaleUnloading then
                if isUnloadingBale then
                    BalerSetIsUnloadingBaleEvent.sendEvent( self , isUnloadingBale, noEventSend)
                    spec.isBaleUnloading = true
                    spec.balesToUnload = #spec.bales

                    if self.isClient then
                        g_soundManager:playSample(spec.samples.unload)
                    end

                    SpecializationUtil.raiseEvent( self , "onBalerUnloadingStarted" , spec.balesToUnload)
                end
            end
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
function Baler.updateActionEvents( self )
    local spec = self.spec_baler
    local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
    if actionEvent ~ = nil then
        local showAction = false

        if not spec.automaticDrop and self:isUnloadingAllowed() then
            if spec.hasUnloadingAnimation or spec.allowsBaleUnloading then

                if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                    if self:getCanUnloadUnfinishedBale() then
                        g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.unloadUnfinishedBale)
                        showAction = true
                    end
                    if #spec.bales > 0 then
                        g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.unloadBaler)
                        showAction = true
                    end
                elseif spec.unloadingState = = Baler.UNLOADING_OPEN then
                        if spec.hasUnloadingAnimation then
                            g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.closeBack)
                            showAction = true
                        end
                    end
                end
            end

            if spec.platformReadyToDrop then
                g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.unloadBaler)
                showAction = true
            else
                    if spec.hasPlatform then
                        if spec.automaticDrop and self:isUnloadingAllowed() then
                            if spec.hasUnloadingAnimation or spec.allowsBaleUnloading then
                                if spec.unloadingState = = Baler.UNLOADING_CLOSED then
                                    if self:getCanUnloadUnfinishedBale() then
                                        g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.unloadUnfinishedBale)
                                        showAction = true
                                    end
                                end
                            end
                        end
                    end
                end

                g_inputBinding:setActionEventActive(actionEvent.actionEventId, showAction)
            end

            if spec.toggleableAutomaticDrop then
                actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA4]
                if actionEvent ~ = nil then
                    local automaticDropState = spec.automaticDrop
                    if spec.hasPlatform then
                        automaticDropState = spec.platformAutomaticDrop
                    end
                    g_inputBinding:setActionEventText(actionEvent.actionEventId, automaticDropState and spec.toggleAutomaticDropTextNeg or spec.toggleAutomaticDropTextPos)
                end
            end

            if #spec.baleTypes > 1 then
                actionEvent = spec.actionEvents[InputAction.TOGGLE_BALE_TYPES]
                if actionEvent ~ = nil then
                    local baleTypeDef = spec.baleTypes[spec.preSelectedBaleTypeIndex]
                    local baleSize
                    if spec.hasUnloadingAnimation then
                        baleSize = baleTypeDef.diameter
                    else
                            baleSize = baleTypeDef.length
                        end

                        g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.changeBaleTypeText:format(baleSize * 100 ))
                    end
                end
            end

```

### updateDummyBale

**Description**

**Definition**

> updateDummyBale()

**Arguments**

| any | dummyBaleData |
|-----|---------------|
| any | fillTypeIndex |
| any | fillLevel     |
| any | capacity      |

**Code**

```lua
function Baler:updateDummyBale(dummyBaleData, fillTypeIndex, fillLevel, capacity)
    local spec = self.spec_baler
    local baleTypeDef = dummyBaleData.baleTypeDef or spec.baleTypes[spec.currentBaleTypeIndex]
    local generatedBale = false
    local baleNode = dummyBaleData.linkNode or baleTypeDef.baleNode
    if baleNode ~ = nil and fillLevel > 0 and fillLevel < capacity and(dummyBaleData.currentBale = = nil or dummyBaleData.currentBaleFillType ~ = fillTypeIndex) then
        if dummyBaleData.currentBale ~ = nil then
            self:deleteDummyBale(dummyBaleData)
        end

        self:createDummyBale(dummyBaleData, fillTypeIndex)
        generatedBale = true
    end

    if dummyBaleData.currentBale ~ = nil then
        local scaleNode = dummyBaleData.linkNode or baleTypeDef.scaleNode
        if scaleNode ~ = nil and capacity > 0 then
            local percentage = fillLevel / capacity
            local x = 1
            local y = baleTypeDef.isRoundBale and percentage or 1
            local z = percentage

            local scaleComponents = dummyBaleData.scaleComponents or baleTypeDef.scaleComponents
            if scaleComponents ~ = nil then
                x, y, z = 1 , 1 , 1
                for axis, value in ipairs(scaleComponents) do
                    if value > 0 then
                        if axis = = 1 then
                            x = percentage * value
                        elseif axis = = 2 then
                                y = percentage * value
                            else
                                    z = percentage * value
                                end
                            end
                        end
                    end

                    setScale(scaleNode, x, y, z)
                end
            end

            return generatedBale
        end

```