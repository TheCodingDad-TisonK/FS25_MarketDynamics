## Attachable

**Description**

> Specialization for vehicles that may be attached to another vehicle

**Functions**

- [actionControllerLowerImplementEvent](#actioncontrollerlowerimplementevent)
- [addToPhysics](#addtophysics)
- [attachableAddToolCameras](#attachableaddtoolcameras)
- [attachableRemoveToolCameras](#attachableremovetoolcameras)
- [findRootVehicle](#findrootvehicle)
- [getActiveFarm](#getactivefarm)
- [getActiveInputAttacherJoint](#getactiveinputattacherjoint)
- [getActiveInputAttacherJointDescIndex](#getactiveinputattacherjointdescindex)
- [getAllowMultipleAttachments](#getallowmultipleattachments)
- [getAllowsLowering](#getallowslowering)
- [getAreControlledActionsAllowed](#getarecontrolledactionsallowed)
- [getAttachbleAirConsumerUsage](#getattachbleairconsumerusage)
- [getAttacherVehicle](#getattachervehicle)
- [getBlockFoliageDestruction](#getblockfoliagedestruction)
- [getBrakeForce](#getbrakeforce)
- [getCanAIImplementContinueWork](#getcanaiimplementcontinuework)
- [getCanBeReset](#getcanbereset)
- [getCanBeSelected](#getcanbeselected)
- [getCanToggleTurnedOn](#getcantoggleturnedon)
- [getConnectionHoseConfigIndex](#getconnectionhoseconfigindex)
- [getDeactivateOnLeave](#getdeactivateonleave)
- [getInputAttacherJointByJointDescIndex](#getinputattacherjointbyjointdescindex)
- [getInputAttacherJointIndexByNode](#getinputattacherjointindexbynode)
- [getInputAttacherJoints](#getinputattacherjoints)
- [getIsActive](#getisactive)
- [getIsAdditionalAttachment](#getisadditionalattachment)
- [getIsAttachedTo](#getisattachedto)
- [getIsAttacherJointHeightNodeActive](#getisattacherjointheightnodeactive)
- [getIsDashboardGroupActive](#getisdashboardgroupactive)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsImplementChainLowered](#getisimplementchainlowered)
- [getIsInputAttacherActive](#getisinputattacheractive)
- [getIsInUse](#getisinuse)
- [getIsInWorkPosition](#getisinworkposition)
- [getIsLightActive](#getislightactive)
- [getIsLowered](#getislowered)
- [getIsMapHotspotVisible](#getismaphotspotvisible)
- [getIsOperating](#getisoperating)
- [getIsPowered](#getispowered)
- [getIsReadyToFinishDetachProcess](#getisreadytofinishdetachprocess)
- [getIsSteeringAxleAllowed](#getissteeringaxleallowed)
- [getIsSupportAnimationAllowed](#getissupportanimationallowed)
- [getIsSupportVehicle](#getissupportvehicle)
- [getLoweringActionEventState](#getloweringactioneventstate)
- [getOwnerConnection](#getownerconnection)
- [getPowerTakeOffConfigIndex](#getpowertakeoffconfigindex)
- [getShowAttachableMapHotspot](#getshowattachablemaphotspot)
- [getSteeringAxleBaseVehicle](#getsteeringaxlebasevehicle)
- [getUpdatePriority](#getupdatepriority)
- [initSpecialization](#initspecialization)
- [isAttachAllowed](#isattachallowed)
- [isDetachAllowed](#isdetachallowed)
- [loadAdditionalLightAttributesFromXML](#loadadditionallightattributesfromxml)
- [loadAttacherJointHeightNode](#loadattacherjointheightnode)
- [loadDashboardGroupFromXML](#loaddashboardgroupfromxml)
- [loadInputAttacherJoint](#loadinputattacherjoint)
- [loadSteeringAngleNodeFromXML](#loadsteeringanglenodefromxml)
- [loadSteeringAxleFromXML](#loadsteeringaxlefromxml)
- [loadSupportAnimationFromXML](#loadsupportanimationfromxml)
- [mountDynamic](#mountdynamic)
- [onBottomArmBallsI3DLoaded](#onbottomarmballsi3dloaded)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onFoldStateChanged](#onfoldstatechanged)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostLoad](#onpostload)
- [onPreDelete](#onpredelete)
- [onPreInitComponentPlacement](#onpreinitcomponentplacement)
- [onReadStream](#onreadstream)
- [onRegisterAnimationValueTypes](#onregisteranimationvaluetypes)
- [onRootVehicleChanged](#onrootvehiclechanged)
- [onSelect](#onselect)
- [onStateChange](#onstatechange)
- [onUnselect](#onunselect)
- [onUpdate](#onupdate)
- [onUpdateInterpolation](#onupdateinterpolation)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [postAttach](#postattach)
- [postDetach](#postdetach)
- [preAttach](#preattach)
- [preDetach](#predetach)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerInputAttacherJointXMLPaths](#registerinputattacherjointxmlpaths)
- [registerLoweringActionEvent](#registerloweringactionevent)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSupportXMLPaths](#registersupportxmlpaths)
- [removeFromPhysics](#removefromphysics)
- [resolveMultipleAttachments](#resolvemultipleattachments)
- [saveToXMLFile](#savetoxmlfile)
- [setIsAdditionalAttachment](#setisadditionalattachment)
- [setIsSupportVehicle](#setissupportvehicle)
- [setLowered](#setlowered)
- [setLoweredAll](#setloweredall)
- [setToolBottomArmWidthByIndex](#settoolbottomarmwidthbyindex)
- [setWorldPositionQuaternion](#setworldpositionquaternion)
- [startDetachProcess](#startdetachprocess)
- [updateInputAttacherJointGraphics](#updateinputattacherjointgraphics)
- [updateSteeringAngleNode](#updatesteeringanglenode)

### actionControllerLowerImplementEvent

**Description**

**Definition**

> actionControllerLowerImplementEvent()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function Attachable:actionControllerLowerImplementEvent(direction)
    local spec = self.spec_attachable

    if self:getAllowsLowering() then
        local moveDown = true
        if direction < 0 then
            moveDown = false
        end

        local jointDescIndex = spec.attacherVehicle:getAttacherJointIndexFromObject( self )
        if spec.attacherVehicle:getJointMoveDown(jointDescIndex) ~ = moveDown then
            spec.attacherVehicle:setJointMoveDown(jointDescIndex, moveDown, false )
        end

        return true
    end

    return false
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
function Attachable:addToPhysics(superFunc)
    if not superFunc( self ) then
        return false
    end

    local spec = self.spec_attachable
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        if attacherVehicle.isAddedToPhysics then
            local implement = attacherVehicle:getImplementByObject( self )
            if implement ~ = nil then
                if not spec.isHardAttached then
                    attacherVehicle:createAttachmentJoint(implement, true )
                end
            end
        else
                -- if we are hard attached and our parent is still not added to physics, we are also not added to physics yet
                    -- so we reset the state to allow another 'addToPhysics' call
                    if spec.isHardAttached then
                        self.isAddedToPhysics = false

                        if self.isServer then
                            removeWakeUpReport( self.rootNode)
                        end
                    end
                end
            end

            return true
        end

```

### attachableAddToolCameras

**Description**

> Add tool cameras to root attacher vehicle

**Definition**

> attachableAddToolCameras()

**Code**

```lua
function Attachable:attachableAddToolCameras()
    local spec = self.spec_attachable

    if #spec.toolCameras > 0 then
        local rootAttacherVehicle = self.rootVehicle
        if rootAttacherVehicle ~ = nil then
            if rootAttacherVehicle.addToolCameras ~ = nil then
                rootAttacherVehicle:addToolCameras(spec.toolCameras)
            end
        end
    end
end

```

### attachableRemoveToolCameras

**Description**

> Remove tool cameras from root attacher vehicle

**Definition**

> attachableRemoveToolCameras()

**Code**

```lua
function Attachable:attachableRemoveToolCameras()
    local spec = self.spec_attachable

    if #spec.toolCameras > 0 then
        local rootAttacherVehicle = self.rootVehicle
        if rootAttacherVehicle ~ = nil then
            if rootAttacherVehicle.removeToolCameras ~ = nil then
                rootAttacherVehicle:removeToolCameras(spec.toolCameras)
            end
        end
    end
end

```

### findRootVehicle

**Description**

**Definition**

> findRootVehicle()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:findRootVehicle(superFunc)
    local spec = self.spec_attachable
    if spec.attacherVehicle ~ = nil then
        return spec.attacherVehicle:findRootVehicle()
    end

    return superFunc( self )
end

```

### getActiveFarm

**Description**

**Definition**

> getActiveFarm()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getActiveFarm(superFunc)
    local spec = self.spec_attachable

    -- Some vehicles can both be attached and entered.Entering takes precedence.
    if self.spec_enterable ~ = nil and self.spec_enterable.controllerFarmId ~ = 0 then
        return superFunc( self )
    end

    if spec.attacherVehicle ~ = nil then
        return spec.attacherVehicle:getActiveFarm()
    else
            return superFunc( self )
        end
    end

```

### getActiveInputAttacherJoint

**Description**

**Definition**

> getActiveInputAttacherJoint()

**Code**

```lua
function Attachable:getActiveInputAttacherJoint()
    return self.spec_attachable.attacherJoint
end

```

### getActiveInputAttacherJointDescIndex

**Description**

**Definition**

> getActiveInputAttacherJointDescIndex()

**Code**

```lua
function Attachable:getActiveInputAttacherJointDescIndex()
    return self.spec_attachable.inputAttacherJointDescIndex
end

```

### getAllowMultipleAttachments

**Description**

> Function to allow showing the attachment dialog even if the attachable is already attached

**Definition**

> getAllowMultipleAttachments()

**Code**

```lua
function Attachable:getAllowMultipleAttachments()
    return false
end

```

### getAllowsLowering

**Description**

> Returns true if tool can be lowered

**Definition**

> getAllowsLowering()

**Return Values**

| any | detachAllowed | detach is allowed                  |
|-----|---------------|------------------------------------|
| any | warning       | [optional] warning text to display |

**Code**

```lua
function Attachable:getAllowsLowering()
    local spec = self.spec_attachable
    if spec.isAdditionalAttachment then
        if not spec.additionalAttachmentNeedsLowering then
            return false , nil
        end
    end

    local inputAttacherJoint = self:getActiveInputAttacherJoint()
    if inputAttacherJoint ~ = nil then
        if not inputAttacherJoint.allowsLowering then
            return false , nil
        end
    end

    return true , nil
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
function Attachable:getAreControlledActionsAllowed(superFunc)
    local spec = self.spec_attachable
    for i = 1 , #spec.supportAnimations do
        if self:getIsAnimationPlaying(spec.supportAnimations[i].animationName) then
            return false
        end
    end

    return superFunc( self )
end

```

### getAttachbleAirConsumerUsage

**Description**

> Returns air consumer usage

**Definition**

> getAttachbleAirConsumerUsage()

**Return Values**

| any | usage | usage |
|-----|-------|-------|

**Code**

```lua
function Attachable:getAttachbleAirConsumerUsage()
    return self.spec_attachable.airConsumerUsage
end

```

### getAttacherVehicle

**Description**

**Definition**

> getAttacherVehicle()

**Code**

```lua
function Attachable:getAttacherVehicle()
    return self.spec_attachable.attacherVehicle
end

```

### getBlockFoliageDestruction

**Description**

> Returns if attachment blocks all foliage destructions of vehicle chain

**Definition**

> getBlockFoliageDestruction()

**Code**

```lua
function Attachable:getBlockFoliageDestruction()
    return self.spec_attachable.blockFoliageDestruction
end

```

### getBrakeForce

**Description**

**Definition**

> getBrakeForce()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getBrakeForce(superFunc)
    local superBrakeForce = superFunc( self )

    local spec = self.spec_attachable
    local brakeForce = spec.brakeForce
    if spec.maxBrakeForceMass > 0 then
        local mass = self:getTotalMass( not spec.maxBrakeForceMassIncludeAttachables)
        local percentage = math.min( math.max((mass - self.defaultMass) / (spec.maxBrakeForceMass - self.defaultMass), 0 ), 1 )
        brakeForce = MathUtil.lerp(spec.brakeForce, spec.maxBrakeForce, percentage)
    end

    if spec.loweredBrakeForce > = 0 then
        if self:getIsLowered( false ) then
            brakeForce = spec.loweredBrakeForce
        end
    end

    return math.max(superBrakeForce, brakeForce)
end

```

### getCanAIImplementContinueWork

**Description**

> Returns true if vehicle is ready for ai work

**Definition**

> getCanAIImplementContinueWork()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | isTurning |

**Return Values**

| any | isReady | is ready for ai work |
|-----|---------|----------------------|

**Code**

```lua
function Attachable:getCanAIImplementContinueWork(superFunc, isTurning)
    local canContinue, stopAI, stopReason = superFunc( self , isTurning)
    if not canContinue then
        return false , stopAI, stopReason
    end

    local spec = self.spec_attachable

    local isReady = true
    if spec.lowerAnimation ~ = nil then
        local time = self:getAnimationTime(spec.lowerAnimation)
        -- do not block the ai while lifting the implement to save time
            isReady = time = = 1 or time = = 0 or( self:getIsAnimationPlaying(spec.lowerAnimation) and self:getAnimationSpeed(spec.lowerAnimation) < 0 )
        end

        if spec.attacherVehicle ~ = nil then
            local jointDesc = spec.attacherVehicle:getAttacherJointDescFromObject( self )
            if jointDesc.allowsLowering and self:getAINeedsLowering() then
                if jointDesc.moveDown then
                    isReady = (jointDesc.moveAlpha = = jointDesc.lowerAlpha or jointDesc.moveAlpha = = jointDesc.upperAlpha) and isReady
                end
            end
        end

        return isReady
    end

```

### getCanBeReset

**Description**

**Definition**

> getCanBeReset()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getCanBeReset(superFunc)
    if self:getIsAdditionalAttachment() then
        return false
    end

    if self:getIsSupportVehicle() then
        return false
    end

    return superFunc( self )
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
function Attachable:getCanBeSelected(superFunc)
    return true
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
function Attachable:getCanToggleTurnedOn(superFunc)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        local jointDesc = attacherVehicle:getAttacherJointDescFromObject( self )
        if jointDesc ~ = nil then
            if not jointDesc.canTurnOnImplement then
                return false
            end
        end
    end

    local spec = self.spec_attachable
    if spec.attacherJoint ~ = nil and not spec.attacherJoint.allowTurnOn then
        return false
    end

    return superFunc( self )
end

```

### getConnectionHoseConfigIndex

**Description**

**Definition**

> getConnectionHoseConfigIndex()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getConnectionHoseConfigIndex(superFunc)
    local index = superFunc( self )
    index = self.xmlFile:getValue( "vehicle.attachable#connectionHoseConfigId" , index)

    if self.configurations[ "inputAttacherJoint" ] ~ = nil then
        local configKey = string.format( "vehicle.attachable.inputAttacherJointConfigurations.inputAttacherJointConfiguration(%d)" , self.configurations[ "inputAttacherJoint" ] - 1 )
        index = self.xmlFile:getValue(configKey .. "#connectionHoseConfigId" , index)
    end

    return index
end

```

### getDeactivateOnLeave

**Description**

**Definition**

> getDeactivateOnLeave()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getDeactivateOnLeave(superFunc)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        if not attacherVehicle:getDeactivateOnLeave() then
            return false
        end
    end

    return superFunc( self )
end

```

### getInputAttacherJointByJointDescIndex

**Description**

**Definition**

> getInputAttacherJointByJointDescIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function Attachable:getInputAttacherJointByJointDescIndex(index)
    return self.spec_attachable.inputAttacherJoints[index]
end

```

### getInputAttacherJointIndexByNode

**Description**

**Definition**

> getInputAttacherJointIndexByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Attachable:getInputAttacherJointIndexByNode(node)
    local spec = self.spec_attachable

    for i = 1 , #spec.inputAttacherJoints do
        local inputAttacherJoint = spec.inputAttacherJoints[i]
        if inputAttacherJoint.node = = node then
            return i
        end
    end

    return nil
end

```

### getInputAttacherJoints

**Description**

**Definition**

> getInputAttacherJoints()

**Code**

```lua
function Attachable:getInputAttacherJoints()
    return self.spec_attachable.inputAttacherJoints
end

```

### getIsActive

**Description**

**Definition**

> getIsActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getIsActive(superFunc)
    if superFunc( self ) then
        return true
    end
    local spec = self.spec_attachable
    if spec.attacherVehicle ~ = nil then
        return spec.attacherVehicle:getIsActive()
    end
    return false
end

```

### getIsAdditionalAttachment

**Description**

> get is additional attachment

**Definition**

> getIsAdditionalAttachment()

**Code**

```lua
function Attachable:getIsAdditionalAttachment()
    return self.spec_attachable.isAdditionalAttachment
end

```

### getIsAttachedTo

**Description**

**Definition**

> getIsAttachedTo()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function Attachable:getIsAttachedTo(vehicle)
    if vehicle = = self then
        return true
    end

    local spec = self.spec_attachable
    if spec.attacherVehicle ~ = nil then
        if spec.attacherVehicle = = vehicle then
            return true
        end
        if spec.attacherVehicle.getIsAttachedTo ~ = nil then
            return spec.attacherVehicle:getIsAttachedTo(vehicle)
        end
    end
    return false
end

```

### getIsAttacherJointHeightNodeActive

**Description**

> Returns if height node is active

**Definition**

> getIsAttacherJointHeightNodeActive(table heightNode)

**Arguments**

| table | heightNode | height node target table |
|-------|------------|--------------------------|

**Return Values**

| table | isActive | height node is active |
|-------|----------|-----------------------|

**Code**

```lua
function Attachable:getIsAttacherJointHeightNodeActive(heightNode)
    return true
end

```

### getIsDashboardGroupActive

**Description**

**Definition**

> getIsDashboardGroupActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | group     |

**Code**

```lua
function Attachable:getIsDashboardGroupActive(superFunc, group)
    if group.isAttached ~ = nil then
        if group.isAttached ~ = ( self:getAttacherVehicle() ~ = nil ) then
            return false
        end
    end

    return superFunc( self , group)
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
function Attachable:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_attachable

    if not spec.allowFoldingWhileAttached then
        if self:getAttacherVehicle() ~ = nil then
            return false , spec.texts.warningFoldingAttached
        end
    end

    if not spec.allowFoldingWhileLowered then
        if self:getIsLowered() then
            return false , spec.texts.warningFoldingLowered
        end
    end

    if spec.attacherJoint ~ = nil and not spec.attacherJoint.allowFolding then
        return false , spec.texts.warningFoldingAttacherJoint
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsImplementChainLowered

**Description**

> Returns true if vehicle itself is lowered and all parent vehicles are lowered until the first vehicle is not
> attachable (e.g. all implements until a tractor is in the chain)

**Definition**

> getIsImplementChainLowered(boolean defaultIsLowered)

**Arguments**

| boolean | defaultIsLowered | default value if lowering is not allowed |
|---------|------------------|------------------------------------------|

**Return Values**

| boolean | isLowered | implement chain is lowered |
|---------|-----------|----------------------------|

**Code**

```lua
function Attachable:getIsImplementChainLowered(defaultIsLowered)
    if not self:getIsLowered(defaultIsLowered) then
        return false
    end

    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        if attacherVehicle.getAllowsLowering ~ = nil then
            if attacherVehicle:getAllowsLowering() then
                if not attacherVehicle:getIsImplementChainLowered(defaultIsLowered) then
                    return false
                end
            end
        end
    end

    return true
end

```

### getIsInputAttacherActive

**Description**

> Returns true if input attacher is active and can be used to attach

**Definition**

> getIsInputAttacherActive(table inputAttacherJoint)

**Arguments**

| table | inputAttacherJoint | input attacher joint |
|-------|--------------------|----------------------|

**Return Values**

| table | isActive | input attacher is active |
|-------|----------|--------------------------|

**Code**

```lua
function Attachable:getIsInputAttacherActive(inputAttacherJoint)
    return true
end

```

### getIsInUse

**Description**

**Definition**

> getIsInUse()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | connection |

**Code**

```lua
function Attachable:getIsInUse(superFunc, connection)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        return attacherVehicle:getIsInUse(connection)
    end

    return superFunc( self , connection)
end

```

### getIsInWorkPosition

**Description**

> Returns true if it is in work position

**Definition**

> getIsInWorkPosition()

**Return Values**

| any | inWorkPosition | is in work position |
|-----|----------------|---------------------|

**Code**

```lua
function Attachable:getIsInWorkPosition()
    return true
end

```

### getIsLightActive

**Description**

**Definition**

> getIsLightActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | light     |

**Code**

```lua
function Attachable:getIsLightActive(superFunc, light)
    if light.inputAttacherJointIndex ~ = nil then
        if light.inputAttacherJointIndex ~ = self:getActiveInputAttacherJointDescIndex() then
            return false
        end
    end

    return superFunc( self , light)
end

```

### getIsLowered

**Description**

**Definition**

> getIsLowered()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | defaultIsLowered |

**Code**

```lua
function Attachable:getIsLowered(superFunc, defaultIsLowered)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        local jointDesc = attacherVehicle:getAttacherJointDescFromObject( self )
        if jointDesc ~ = nil then
            if jointDesc.allowsLowering or jointDesc.isDefaultLowered then
                return jointDesc.moveDown
            else
                    return defaultIsLowered
                end
            end
        end

        return superFunc( self , defaultIsLowered)
    end

```

### getIsMapHotspotVisible

**Description**

**Definition**

> getIsMapHotspotVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getIsMapHotspotVisible(superFunc)
    if not superFunc( self ) then
        return false
    end

    if self:getIsAdditionalAttachment() then
        return false
    end

    if self:getIsSupportVehicle() then
        return false
    end

    return self:getShowAttachableMapHotspot()
end

```

### getIsOperating

**Description**

> Returns if vehicle is operating

**Definition**

> getIsOperating()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | isOperating | is operating |
|-----|-------------|--------------|

**Code**

```lua
function Attachable:getIsOperating(superFunc)
    local spec = self.spec_attachable

    local isOperating = superFunc( self )

    if not isOperating and spec.attacherVehicle ~ = nil then
        isOperating = spec.attacherVehicle:getIsOperating()
    end

    return isOperating
end

```

### getIsPowered

**Description**

**Definition**

> getIsPowered()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getIsPowered(superFunc)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        local isPowered, warning = attacherVehicle:getIsPowered()
        if not isPowered then
            return isPowered, warning
        end
    else
            local spec = self.spec_attachable
            if spec.requiresExternalPower then
                if not SpecializationUtil.hasSpecialization( Motorized , self.specializations) then
                    return false , spec.attachToPowerWarning
                end
            end
        end

        return superFunc( self )
    end

```

### getIsReadyToFinishDetachProcess

**Description**

> Returns if all conditions are met to do the final detach of the attachable

**Definition**

> getIsReadyToFinishDetachProcess()

**Code**

```lua
function Attachable:getIsReadyToFinishDetachProcess()
    local spec = self.spec_attachable
    local readyforDetach = true
    for i = 1 , #spec.supportAnimations do
        local animation = spec.supportAnimations[i]
        if animation.detachAfterAnimation then
            if animation.detachAnimationTime > = 1 then
                if self:getIsAnimationPlaying(animation.animationName) then
                    readyforDetach = false
                end
            else
                    if self:getAnimationTime(animation.animationName) < animation.detachAnimationTime then
                        readyforDetach = false
                    end
                end
            end
        end

        return readyforDetach
    end

```

### getIsSteeringAxleAllowed

**Description**

> Returns if steering axle is allowed to adjust

**Definition**

> getIsSteeringAxleAllowed()

**Code**

```lua
function Attachable:getIsSteeringAxleAllowed()
    return true
end

```

### getIsSupportAnimationAllowed

**Description**

> Returns if support animation is allowed to play

**Definition**

> getIsSupportAnimationAllowed()

**Arguments**

| any | supportAnimation |
|-----|------------------|

**Code**

```lua
function Attachable:getIsSupportAnimationAllowed(supportAnimation)
    return self.playAnimation ~ = nil
end

```

### getIsSupportVehicle

**Description**

> get is additional attachment

**Definition**

> getIsSupportVehicle()

**Code**

```lua
function Attachable:getIsSupportVehicle()
    return self.spec_attachable.isSupportVehicle
end

```

### getLoweringActionEventState

**Description**

**Definition**

> getLoweringActionEventState()

**Code**

```lua
function Attachable:getLoweringActionEventState()
    local showLower = false

    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        local jointDesc = attacherVehicle:getAttacherJointDescFromObject( self )
        local inputJointDesc = self:getActiveInputAttacherJoint()
        showLower = jointDesc.allowsLowering and inputJointDesc.allowsLowering
    end

    local spec = self.spec_attachable
    local text
    if self:getIsLowered() then
        text = string.format(spec.texts.liftObject, self.typeDesc)
    else
            text = string.format(spec.texts.lowerObject, self.typeDesc)
        end

        return showLower, text
    end

```

### getOwnerConnection

**Description**

**Definition**

> getOwnerConnection()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getOwnerConnection(superFunc)
    local spec = self.spec_attachable

    if spec.attacherVehicle ~ = nil then
        return spec.attacherVehicle:getOwnerConnection()
    end

    return superFunc( self )
end

```

### getPowerTakeOffConfigIndex

**Description**

**Definition**

> getPowerTakeOffConfigIndex()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Attachable:getPowerTakeOffConfigIndex(superFunc)
    local index = superFunc( self )
    index = self.xmlFile:getValue( "vehicle.attachable#powerTakeOffConfigId" , index)

    if self.configurations[ "inputAttacherJoint" ] ~ = nil then
        local configKey = string.format( "vehicle.attachable.inputAttacherJointConfigurations.inputAttacherJointConfiguration(%d)" , self.configurations[ "inputAttacherJoint" ] - 1 )
        index = self.xmlFile:getValue(configKey .. "#powerTakeOffConfigId" , index)
    end

    return index
end

```

### getShowAttachableMapHotspot

**Description**

**Definition**

> getShowAttachableMapHotspot()

**Code**

```lua
function Attachable:getShowAttachableMapHotspot()
    return self.spec_attachable.attacherVehicle = = nil
end

```

### getSteeringAxleBaseVehicle

**Description**

> Returns vehicle used to calculate steering axle

**Definition**

> getSteeringAxleBaseVehicle()

**Code**

```lua
function Attachable:getSteeringAxleBaseVehicle()
    local spec = self.spec_attachable

    if spec.steeringAxleUseSuperAttachable then
        if spec.attacherVehicle ~ = nil then
            if spec.attacherVehicle.getAttacherVehicle ~ = nil then
                return spec.attacherVehicle:getAttacherVehicle()
            end
        end
    end

    if spec.attacherVehicle ~ = nil then
        if spec.steeringAxleForceUsage or spec.attacherVehicle:getCanSteerAttachable( self ) then
            return spec.attacherVehicle
        end
    end

    return nil
end

```

### getUpdatePriority

**Description**

**Definition**

> getUpdatePriority()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | skipCount    |
| any | x            |
| any | y            |
| any | z            |
| any | coeff        |
| any | connection   |
| any | isGuiVisible |

**Code**

```lua
function Attachable:getUpdatePriority(superFunc, skipCount, x, y, z, coeff, connection, isGuiVisible)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        return attacherVehicle:getUpdatePriority(skipCount, x, y, z, coeff, connection, isGuiVisible)
    end

    return superFunc( self , skipCount, x, y, z, coeff, connection)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Attachable.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "inputAttacherJoint" , g_i18n:getText( "configuration_inputAttacherJoint" ), "attachable" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Attachable" )

    Attachable.registerInputAttacherJointXMLPaths(schema, Attachable.INPUT_ATTACHERJOINT_XML_KEY)
    Attachable.registerInputAttacherJointXMLPaths(schema, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY)

    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, Attachable.INPUT_ATTACHERJOINT_XML_KEY)
    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY)

    Attachable.registerSupportXMLPaths(schema, "vehicle.attachable.inputAttacherJointConfigurations.inputAttacherJointConfiguration(?).support(?)" )

    schema:register(XMLValueType.INT, "vehicle.attachable#connectionHoseConfigId" , "Connection hose configuration index to use" )
    schema:register(XMLValueType.INT, "vehicle.attachable#powerTakeOffConfigId" , "Power take off configuration index to use" )
    schema:register(XMLValueType.INT, "vehicle.attachable.inputAttacherJointConfigurations.inputAttacherJointConfiguration(?)#connectionHoseConfigId" , "Connection hose configuration index to use" )
    schema:register(XMLValueType.INT, "vehicle.attachable.inputAttacherJointConfigurations.inputAttacherJointConfiguration(?)#powerTakeOffConfigId" , "Power take off configuration index to use" )

    schema:register(XMLValueType.FLOAT, "vehicle.attachable.brakeForce#force" , "Brake force" , 0 )
    schema:register(XMLValueType.FLOAT, "vehicle.attachable.brakeForce#maxForce" , "Brake force when vehicle reached mass of #maxForceMass" , 0 )
    schema:register(XMLValueType.FLOAT, "vehicle.attachable.brakeForce#maxForceMass" , "When this mass is reached the vehicle will brake with #maxForce" , 0 )
    schema:register(XMLValueType.BOOL, "vehicle.attachable.brakeForce#includeAttachables" , "Defines if the mass of the attached vehicles is included in the calculations" , false )
        schema:register(XMLValueType.FLOAT, "vehicle.attachable.brakeForce#loweredForce" , "Brake force while the tool is lowered" )

            schema:register(XMLValueType.FLOAT, "vehicle.attachable.airConsumer#usage" , "Air consumption while fully braking" , 0 )
                schema:register(XMLValueType.BOOL, "vehicle.attachable#allowFoldingWhileAttached" , "Allow folding while attached" , true )
                    schema:register(XMLValueType.BOOL, "vehicle.attachable#allowFoldingWhileLowered" , "Allow folding while lowered" , true )
                        schema:register(XMLValueType.BOOL, "vehicle.attachable#blockFoliageDestruction" , "If active the vehicle will block the complete foliage destruction of the vehicle chain" , false )

                        schema:register(XMLValueType.BOOL, "vehicle.attachable.power#requiresExternalPower" , "Tool requires external power from a vehicle with motor to work" , true )
                        schema:register(XMLValueType.L10N_STRING, "vehicle.attachable.power#attachToPowerWarning" , "Warning to be displayed if no vehicle with motor is attached" , "warning_attachToPower" )

                            schema:register(XMLValueType.FLOAT, "vehicle.attachable.steeringAxleAngleScale#startSpeed" , "Start speed" , 10 )
                            schema:register(XMLValueType.FLOAT, "vehicle.attachable.steeringAxleAngleScale#endSpeed" , "End speed" , 30 )
                            schema:register(XMLValueType.BOOL, "vehicle.attachable.steeringAxleAngleScale#backwards" , "Is active backwards" , false )
                            schema:register(XMLValueType.ANGLE, "vehicle.attachable.steeringAxleAngleScale#speed" , "Speed(Degrees per second)" , 60 )
                            schema:register(XMLValueType.BOOL, "vehicle.attachable.steeringAxleAngleScale#useSuperAttachable" , "Use super attachable" , false )
                            schema:register(XMLValueType.NODE_INDEX, "vehicle.attachable.steeringAxleAngleScale.targetNode#node" , "Target node" )
                            schema:register(XMLValueType.ANGLE, "vehicle.attachable.steeringAxleAngleScale.targetNode#refAngle" , "Reference angle to transfer from angle between vehicles to defined min.and max.rot for target node" )
                                schema:register(XMLValueType.ANGLE, "vehicle.attachable.steeringAxleAngleScale#minRot" , "Min Rotation" , 0 )
                                schema:register(XMLValueType.ANGLE, "vehicle.attachable.steeringAxleAngleScale#maxRot" , "Max Rotation" , 0 )
                                schema:register(XMLValueType.FLOAT, "vehicle.attachable.steeringAxleAngleScale#direction" , "Direction" , 1 )
                                schema:register(XMLValueType.BOOL, "vehicle.attachable.steeringAxleAngleScale#forceUsage" , "Force usage of steering axle, even if attacher vehicle does not have steering bar nodes" , false )
                                    schema:register(XMLValueType.BOOL, "vehicle.attachable.steeringAxleAngleScale#speedDependent" , "Steering axle angle is scaled based on speed with #startSpeed and #endSpeed" , true )
                                    schema:register(XMLValueType.FLOAT, "vehicle.attachable.steeringAxleAngleScale#distanceDelay" , "The steering angle is updated delayed after vehicle has been moved this distance" , 0 )
                                    schema:register(XMLValueType.INT, "vehicle.attachable.steeringAxleAngleScale#referenceComponentIndex" , "If defined the given component is used for steering angle reference.Y between root component and this component will result in steering angle." )

                                        schema:register(XMLValueType.NODE_INDEX, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#node" , "Steering angle node" )
                                        schema:register(XMLValueType.ANGLE, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#speed" , "Change speed(degree per second)" , 25 )
                                        schema:register(XMLValueType.FLOAT, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#scale" , "Scale of vehicle to vehicle angle that is applied" , 1 )
                                        schema:register(XMLValueType.ANGLE, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#offset" , "Angle offset" , 0 )
                                        schema:register(XMLValueType.FLOAT, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#minSpeed" , "Min.speed of vehicle to update" , 0 )

                                        Attachable.registerSupportXMLPaths(schema, "vehicle.attachable.support(?)" )

                                        schema:register(XMLValueType.STRING, "vehicle.attachable.lowerAnimation#name" , "Animation name" )
                                        schema:register(XMLValueType.FLOAT, "vehicle.attachable.lowerAnimation#speed" , "Animation speed" , 1 )
                                        schema:register(XMLValueType.INT, "vehicle.attachable.lowerAnimation#directionOnDetach" , "Direction on detach" , 0 )
                                        schema:register(XMLValueType.BOOL, "vehicle.attachable.lowerAnimation#defaultLowered" , "Is default lowered" , false )

                                        VehicleCamera.registerCameraXMLPaths(schema, "vehicle.attachable.toolCameras.toolCamera(?)" )

                                        SoundManager.registerSampleXMLPaths(schema, "vehicle.attachable.sounds" , "active(?)" )

                                        for i = 1 , # Lights.ADDITIONAL_LIGHT_ATTRIBUTES_KEYS do
                                            local key = Lights.ADDITIONAL_LIGHT_ATTRIBUTES_KEYS[i]
                                            schema:register(XMLValueType.INT, key .. "#inputAttacherJointIndex" , "Index of input attacher joint that needs to be active to activate light" )
                                        end

                                        schema:register(XMLValueType.BOOL, Dashboard.GROUP_XML_KEY .. "#isAttached" , "Tool is attached" )

                                        schema:addDelayedRegistrationFunc( "AnimatedVehicle:part" , function (cSchema, cKey)
                                            cSchema:register(XMLValueType.INT, cKey .. "#inputAttacherJointIndex" , "Input Attacher Joint Index [1 .. n]" )

                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#lowerRotLimitScaleStart" , "Lower rotation limit start" )
                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#lowerRotLimitScaleEnd" , "Lower rotation limit end" )
                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#upperRotLimitScaleStart" , "Upper rotation limit start" )
                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#upperRotLimitScaleEnd" , "Upper rotation limit end" )

                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#lowerTransLimitScaleStart" , "Lower translation limit start" )
                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#lowerTransLimitScaleEnd" , "Lower translation limit end" )
                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#upperTransLimitScaleStart" , "Upper translation limit start" )
                                            cSchema:register(XMLValueType.VECTOR_ 3 , cKey .. "#upperTransLimitScaleEnd" , "Upper translation limit end" )

                                            cSchema:register(XMLValueType.ANGLE, cKey .. "#lowerRotationOffsetStart" , "Lower rotation offset start" )
                                            cSchema:register(XMLValueType.ANGLE, cKey .. "#lowerRotationOffsetEnd" , "Lower rotation offset end" )
                                            cSchema:register(XMLValueType.ANGLE, cKey .. "#upperRotationOffsetStart" , "Upper rotation offset start" )
                                            cSchema:register(XMLValueType.ANGLE, cKey .. "#upperRotationOffsetEnd" , "Upper rotation offset end" )

                                            cSchema:register(XMLValueType.FLOAT, cKey .. "#lowerDistanceToGroundStart" , "Lower distance to ground start" )
                                            cSchema:register(XMLValueType.FLOAT, cKey .. "#lowerDistanceToGroundEnd" , "Lower distance to ground end" )
                                            cSchema:register(XMLValueType.FLOAT, cKey .. "#upperDistanceToGroundStart" , "Upper distance to ground start" )
                                            cSchema:register(XMLValueType.FLOAT, cKey .. "#upperDistanceToGroundEnd" , "Upper distance to ground end" )
                                        end )

                                        schema:setXMLSpecializationType()

                                        local schemaSavegame = Vehicle.xmlSchemaSavegame
                                        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).attachable#lowerAnimTime" , "Lower animation time" )
                                        schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).attachable#isDetachingBlocked" , "If detaching is blocked" )
                                    end

```

### isAttachAllowed

**Description**

> Returns true if attaching the vehicle is allowed

**Definition**

> isAttachAllowed(integer farmId, table attacherVehicle)

**Arguments**

| integer | farmId          | farmId of attacher vehicle |
|---------|-----------------|----------------------------|
| table   | attacherVehicle | attacher vehicle           |

**Return Values**

| table | detachAllowed | detach is allowed                  |
|-------|---------------|------------------------------------|
| table | warning       | [optional] warning text to display |

**Code**

```lua
function Attachable:isAttachAllowed(farmId, attacherVehicle)
    if not g_currentMission.accessHandler:canFarmAccess(farmId, self ) then
        return false , nil
    end

    if self.spec_attachable.detachingInProgress then
        return false , nil
    end

    return true , nil
end

```

### isDetachAllowed

**Description**

> Returns true if detach is allowed

**Definition**

> isDetachAllowed()

**Return Values**

| table | detachAllowed | detach is allowed                  |
|-------|---------------|------------------------------------|
| table | warning       | [optional] warning text to display |

**Code**

```lua
function Attachable:isDetachAllowed()
    local spec = self.spec_attachable

    if spec.isDetachingBlocked then
        return false
    end

    if spec.attacherJoint ~ = nil then
        if spec.attacherJoint.allowsDetaching = = false then
            return false , nil , false
        end

        if spec.attacherJoint.allowDetachWhileParentLifted = = false then
            local attacherVehicle = self:getAttacherVehicle()
            if attacherVehicle ~ = nil then
                if attacherVehicle.getIsLowered ~ = nil and not attacherVehicle:getIsLowered( true ) then
                    return false , string.format(spec.texts.lowerImplementFirst, attacherVehicle.typeDesc), true
                end
            end
        end
    end

    if spec.isAdditionalAttachment then
        return false
    end

    -- block detach while the attaching is still in progress
        local attacherVehicle = self:getAttacherVehicle()
        if attacherVehicle ~ = nil then
            local implement = attacherVehicle:getImplementByObject( self )
            if implement ~ = nil and implement.attachingIsInProgress then
                return false
            end
        end

        return true , nil
    end

```

### loadAdditionalLightAttributesFromXML

**Description**

**Definition**

> loadAdditionalLightAttributesFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | light     |

**Code**

```lua
function Attachable:loadAdditionalLightAttributesFromXML(superFunc, xmlFile, key, light)
    if not superFunc( self , xmlFile, key, light) then
        return false
    end

    light.inputAttacherJointIndex = xmlFile:getValue(key .. "#inputAttacherJointIndex" )

    return true
end

```

### loadAttacherJointHeightNode

**Description**

> Load height node from XML

**Definition**

> loadAttacherJointHeightNode(table xmlFile, string key, table heightNode, )

**Arguments**

| table  | xmlFile           | xml file object          |
|--------|-------------------|--------------------------|
| string | key               | height node xml key      |
| table  | heightNode        | height node target table |
| any    | attacherJointNode |                          |

**Code**

```lua
function Attachable:loadAttacherJointHeightNode(xmlFile, key, heightNode, attacherJointNode)
    heightNode.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    heightNode.attacherJointNode = attacherJointNode

    return true
end

```

### loadDashboardGroupFromXML

**Description**

**Definition**

> loadDashboardGroupFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | group     |

**Code**

```lua
function Attachable:loadDashboardGroupFromXML(superFunc, xmlFile, key, group)
    if not superFunc( self , xmlFile, key, group) then
        return false
    end

    group.isAttached = xmlFile:getValue(key .. "#isAttached" )

    return true
end

```

### loadInputAttacherJoint

**Description**

> Called on loading

**Definition**

> loadInputAttacherJoint(table savegame, , , )

**Arguments**

| table | savegame           | savegame |
|-------|--------------------|----------|
| any   | key                |          |
| any   | inputAttacherJoint |          |
| any   | index              |          |

**Code**

```lua
function Attachable:loadInputAttacherJoint(xmlFile, key, inputAttacherJoint, index)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#indexVisual" , key .. "#nodeVisual" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#ptoInputNode" , "vehicle.powerTakeOffs.input" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#lowerDistanceToGround" , key .. ".distanceToGround#lower" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#upperDistanceToGround" , key .. ".distanceToGround#upper" ) -- FS17 to FS19

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node ~ = nil then
        inputAttacherJoint.node = node

        inputAttacherJoint.heightNodes = { }
        xmlFile:iterate(key .. ".heightNode" , function (_, heightNodeKey)
            local heightNode = { }
            if self:loadAttacherJointHeightNode(xmlFile, heightNodeKey, heightNode, node) then
                table.insert(inputAttacherJoint.heightNodes, heightNode)
            end
        end )

        local jointTypeStr = xmlFile:getValue(key .. "#jointType" )
        local jointType
        if jointTypeStr ~ = nil then
            jointType = AttacherJoints.jointTypeNameToInt[jointTypeStr]
            if jointType = = nil then
                Logging.xmlWarning( self.xmlFile, "Invalid jointType '%s' for inputAttacherJoint '%s'!" , tostring(jointTypeStr), key)
                end
            else
                    Logging.xmlWarning( self.xmlFile, "Missing jointType for inputAttacherJoint '%s'!" , key)
                    end
                    if jointType = = nil then
                        local needsTrailerJoint = xmlFile:getValue(key .. "#needsTrailerJoint" , false )
                        local needsLowTrailerJoint = xmlFile:getValue(key .. "#needsLowJoint" , false )
                        if needsTrailerJoint then
                            if needsLowTrailerJoint then
                                jointType = AttacherJoints.JOINTTYPE_TRAILERLOW
                            else
                                    jointType = AttacherJoints.JOINTTYPE_TRAILER
                                end
                            else
                                    jointType = AttacherJoints.JOINTTYPE_IMPLEMENT
                                end
                            end
                            inputAttacherJoint.jointType = jointType

                            local subTypeStr = xmlFile:getValue(key .. ".subType#name" )
                            if not string.isNilOrWhitespace(subTypeStr) then
                                inputAttacherJoint.subTypes = string.split(subTypeStr, " " )
                            end
                            inputAttacherJoint.subTypeShowWarning = xmlFile:getValue(key .. ".subType#showWarning" , true )

                            local parentComponent = self:getParentComponent(inputAttacherJoint.node)
                            inputAttacherJoint.jointOrigTrans = { getTranslation(inputAttacherJoint.node) }
                            inputAttacherJoint.jointOrigOffsetComponent = { localToLocal(parentComponent, inputAttacherJoint.node, 0 , 0 , 0 ) }
                            inputAttacherJoint.jointOrigRotOffsetComponent = { localRotationToLocal(parentComponent, inputAttacherJoint.node, 0 , 0 , 0 ) }
                            inputAttacherJoint.topReferenceNode = xmlFile:getValue(key .. "#topReferenceNode" , nil , self.components, self.i3dMappings)
                            inputAttacherJoint.rootNode = xmlFile:getValue(key .. "#rootNode" , parentComponent, self.components, self.i3dMappings)
                            inputAttacherJoint.rootNodeBackup = inputAttacherJoint.rootNode
                            inputAttacherJoint.allowsDetaching = xmlFile:getValue(key .. "#allowsDetaching" , true )
                            inputAttacherJoint.fixedRotation = xmlFile:getValue(key .. "#fixedRotation" , false )
                            inputAttacherJoint.hardAttach = xmlFile:getValue(key .. "#hardAttach" , false )
                            if inputAttacherJoint.hardAttach and # self.components > 1 then
                                Logging.xmlWarning( self.xmlFile, "hardAttach only available for single component vehicles! InputAttacherJoint '%s'!" , key)
                                    inputAttacherJoint.hardAttach = false
                                end
                                inputAttacherJoint.visualNode = xmlFile:getValue(key .. "#nodeVisual" , nil , self.components, self.i3dMappings)
                                if inputAttacherJoint.hardAttach and inputAttacherJoint.visualNode ~ = nil then
                                    inputAttacherJoint.visualNodeData = {
                                    parent = getParent(inputAttacherJoint.visualNode),
                                    translation = { getTranslation(inputAttacherJoint.visualNode) } ,
                                    rotation = { getRotation(inputAttacherJoint.visualNode) } ,
                                    index = getChildIndex(inputAttacherJoint.visualNode)
                                    }
                                end

                                inputAttacherJoint.smoothAttachTime = xmlFile:getValue(key .. "#smoothAttachTime" )

                                if jointType = = AttacherJoints.JOINTTYPE_IMPLEMENT
                                    or jointType = = AttacherJoints.JOINTTYPE_CUTTER
                                    or jointType = = AttacherJoints.JOINTTYPE_CUTTERHARVESTER then
                                    if xmlFile:getValue(key .. ".distanceToGround#lower" ) = = nil then
                                        Logging.xmlWarning( self.xmlFile, "Missing '.distanceToGround#lower' for inputAttacherJoint '%s'!" , key)
                                        end
                                        if xmlFile:getValue(key .. ".distanceToGround#upper" ) = = nil then
                                            Logging.xmlWarning( self.xmlFile, "Missing '.distanceToGround#upper' for inputAttacherJoint '%s'!" , key)
                                            end
                                        end

                                        inputAttacherJoint.lowerDistanceToGround = xmlFile:getValue(key .. ".distanceToGround#lower" , 0.7 )
                                        inputAttacherJoint.upperDistanceToGround = xmlFile:getValue(key .. ".distanceToGround#upper" , 1.0 )
                                        if inputAttacherJoint.lowerDistanceToGround > inputAttacherJoint.upperDistanceToGround then
                                            Logging.xmlWarning( self.xmlFile, "distanceToGround#lower may not be larger than distanceToGround#upper for inputAttacherJoint '%s'.Switching values!" , key)
                                                local copy = inputAttacherJoint.lowerDistanceToGround
                                                inputAttacherJoint.lowerDistanceToGround = inputAttacherJoint.upperDistanceToGround
                                                inputAttacherJoint.upperDistanceToGround = copy
                                            end

                                            inputAttacherJoint.distanceToGroundByVehicle = { }
                                            xmlFile:iterate(key .. ".distanceToGround.vehicle" , function (_, vehicleKey)
                                                local entry = { }
                                                entry.filename = xmlFile:getValue(vehicleKey .. "#filename" )
                                                if entry.filename ~ = nil then
                                                    entry.filename = string.lower(entry.filename)
                                                    entry.lower = xmlFile:getValue(vehicleKey .. "#lower" , inputAttacherJoint.lowerDistanceToGround)
                                                    entry.upper = xmlFile:getValue(vehicleKey .. "#upper" , inputAttacherJoint.upperDistanceToGround)

                                                    table.insert(inputAttacherJoint.distanceToGroundByVehicle, entry)
                                                end
                                            end )

                                            inputAttacherJoint.lowerDistanceToGroundOriginal = inputAttacherJoint.lowerDistanceToGround
                                            inputAttacherJoint.upperDistanceToGroundOriginal = inputAttacherJoint.upperDistanceToGround

                                            inputAttacherJoint.lowerRotationOffset = xmlFile:getValue(key .. "#lowerRotationOffset" , 0 )

                                            local defaultUpperRotationOffset = 0
                                            if jointType = = AttacherJoints.JOINTTYPE_IMPLEMENT then
                                                defaultUpperRotationOffset = 8
                                            end

                                            inputAttacherJoint.upperRotationOffset = xmlFile:getValue(key .. "#upperRotationOffset" , defaultUpperRotationOffset)

                                            inputAttacherJoint.allowsJointRotLimitMovement = xmlFile:getValue(key .. "#allowsJointRotLimitMovement" , true )
                                            inputAttacherJoint.allowsJointTransLimitMovement = xmlFile:getValue(key .. "#allowsJointTransLimitMovement" , true )

                                            inputAttacherJoint.needsToolbar = xmlFile:getValue(key .. "#needsToolbar" , false )
                                            if inputAttacherJoint.needsToolbar and jointType ~ = AttacherJoints.JOINTTYPE_IMPLEMENT then
                                                Logging.xmlWarning( self.xmlFile, "'needsToolbar' requires jointType 'implement' for inputAttacherJoint '%s'!" , key)
                                                    inputAttacherJoint.needsToolbar = false
                                                end

                                                if jointType = = AttacherJoints.JOINTTYPE_IMPLEMENT and not inputAttacherJoint.needsToolbar then
                                                    inputAttacherJoint.bottomArm = { }

                                                    local categories = xmlFile:getValue(key .. ".bottomArm#categories" , "" , true )
                                                    for i, category in ipairs(categories) do
                                                        if category < 0 or category > 4 then
                                                            Logging.xmlWarning(xmlFile, "Bottom arm category should be between 0 and 4 in '%s'" , key)
                                                        end
                                                    end

                                                    inputAttacherJoint.bottomArm.widths = xmlFile:getValue(key .. ".bottomArm#widths" , nil , true )
                                                    if inputAttacherJoint.bottomArm.widths = = nil or #inputAttacherJoint.bottomArm.widths = = 0 then
                                                        inputAttacherJoint.bottomArm.widths = { }
                                                        for _, category in ipairs(categories) do
                                                            table.insert(inputAttacherJoint.bottomArm.widths, AttacherJoints.LOWER_LINK_WIDTH_BY_CATEGORY[category])
                                                        end
                                                    end

                                                    inputAttacherJoint.bottomArm.ballType = xmlFile:getValue(key .. ".bottomArm#ballType" , 1 )
                                                    inputAttacherJoint.bottomArm.ballDefaultVisibility = xmlFile:getValue(key .. ".bottomArm#ballDefaultVisibility" , not inputAttacherJoint.needsToolbar)
                                                    inputAttacherJoint.bottomArm.ballFilename = xmlFile:getValue(key .. ".bottomArm#ballFilename" )
                                                    if inputAttacherJoint.bottomArm.ballFilename ~ = nil then
                                                        inputAttacherJoint.bottomArm.ballFilename = Utils.getFilename(inputAttacherJoint.bottomArm.ballFilename, self.baseDirectory)
                                                    else
                                                            inputAttacherJoint.bottomArm.ballFilename = string.format( Attachable.LOWER_LINK_BALL_FILENAME, inputAttacherJoint.bottomArm.ballType)
                                                        end

                                                        if #inputAttacherJoint.bottomArm.widths > 0 then
                                                            if inputAttacherJoint.bottomArm.ballFilename ~ = nil then
                                                                if not fileExists(inputAttacherJoint.bottomArm.ballFilename) then
                                                                    Logging.xmlWarning(xmlFile, "Unable to load lower link balls from '%s' in '%s'" , inputAttacherJoint.bottomArm.ballFilename, key)
                                                                else
                                                                        inputAttacherJoint.bottomArm.sharedLoadRequestIdBalls = self:loadSubSharedI3DFile(inputAttacherJoint.bottomArm.ballFilename, false , false , Attachable.onBottomArmBallsI3DLoaded, self , inputAttacherJoint)
                                                                    end
                                                                end
                                                            end
                                                        end

                                                        if self.setMovingPartReferenceNode ~ = nil then
                                                            inputAttacherJoint.steeringBarLeftNode = xmlFile:getValue(key .. "#steeringBarLeftNode" , nil , self.components, self.i3dMappings)
                                                            inputAttacherJoint.steeringBarRightNode = xmlFile:getValue(key .. "#steeringBarRightNode" , nil , self.components, self.i3dMappings)
                                                            inputAttacherJoint.drawbarNode = xmlFile:getValue(key .. "#drawbarNode" , nil , self.components, self.i3dMappings)
                                                        end

                                                        inputAttacherJoint.bottomArmLeftNode = xmlFile:getValue(key .. "#bottomArmLeftNode" , nil , self.components, self.i3dMappings)
                                                        inputAttacherJoint.bottomArmRightNode = xmlFile:getValue(key .. "#bottomArmRightNode" , nil , self.components, self.i3dMappings)

                                                        --load joint limit scales
                                                        inputAttacherJoint.upperRotLimitScale = xmlFile:getValue( key .. "#upperRotLimitScale" , "0 0 0" , true )
                                                        inputAttacherJoint.lowerRotLimitScale = xmlFile:getValue( key .. "#lowerRotLimitScale" , nil , true )
                                                        if inputAttacherJoint.lowerRotLimitScale = = nil then
                                                            if math.abs(inputAttacherJoint.lowerDistanceToGround - inputAttacherJoint.upperDistanceToGround) > 0.0001 then
                                                                if jointType = = AttacherJoints.JOINTTYPE_IMPLEMENT then
                                                                    inputAttacherJoint.lowerRotLimitScale = { 0 , 0 , 1 }
                                                                else
                                                                        inputAttacherJoint.lowerRotLimitScale = { 1 , 1 , 1 }
                                                                    end
                                                                else
                                                                        inputAttacherJoint.lowerRotLimitScale = { 0 , 0 , 0 }
                                                                    end
                                                                end
                                                                inputAttacherJoint.rotLimitThreshold = xmlFile:getValue( key .. "#rotLimitThreshold" , 0 )

                                                                inputAttacherJoint.upperTransLimitScale = xmlFile:getValue( key .. "#upperTransLimitScale" , "0 0 0" , true )
                                                                inputAttacherJoint.lowerTransLimitScale = xmlFile:getValue( key .. "#lowerTransLimitScale" , "0 1 0" , true )
                                                                inputAttacherJoint.transLimitThreshold = xmlFile:getValue( key .. "#transLimitThreshold" , 0 )

                                                                inputAttacherJoint.rotLimitSpring = xmlFile:getValue( key .. "#rotLimitSpring" , "0 0 0" , true )
                                                                inputAttacherJoint.rotLimitDamping = xmlFile:getValue( key .. "#rotLimitDamping" , "1 1 1" , true )
                                                                inputAttacherJoint.rotLimitForceLimit = xmlFile:getValue( key .. "#rotLimitForceLimit" , "-1 -1 -1" , true )

                                                                inputAttacherJoint.transLimitSpring = xmlFile:getValue( key .. "#transLimitSpring" , "0 0 0" , true )
                                                                inputAttacherJoint.transLimitDamping = xmlFile:getValue( key .. "#transLimitDamping" , "1 1 1" , true )
                                                                inputAttacherJoint.transLimitForceLimit = xmlFile:getValue( key .. "#transLimitForceLimit" , "-1 -1 -1" , true )

                                                                inputAttacherJoint.attachAngleLimitAxis = xmlFile:getValue(key .. "#attachAngleLimitAxis" , 1 )

                                                                inputAttacherJoint.attacherHeight = xmlFile:getValue(key .. "#attacherHeight" )
                                                                if inputAttacherJoint.attacherHeight = = nil then
                                                                    if jointType = = AttacherJoints.JOINTTYPE_TRAILER then
                                                                        inputAttacherJoint.attacherHeight = 0.9
                                                                    elseif jointType = = AttacherJoints.JOINTTYPE_TRAILERLOW then
                                                                            inputAttacherJoint.attacherHeight = 0.55
                                                                        elseif jointType = = AttacherJoints.JOINTTYPE_TRAILERCAR then
                                                                                inputAttacherJoint.attacherHeight = 0.55
                                                                            end
                                                                        end

                                                                        local defaultNeedsLowering = true
                                                                        local defaultAllowsLowering = false
                                                                        if inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_TRAILER or inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_TRAILERLOW or inputAttacherJoint.jointType = = AttacherJoints.JOINTTYPE_TRAILERCAR then
                                                                            defaultNeedsLowering = false
                                                                        end
                                                                        if inputAttacherJoint.jointType ~ = AttacherJoints.JOINTTYPE_TRAILER and inputAttacherJoint.jointType ~ = AttacherJoints.JOINTTYPE_TRAILERLOW and inputAttacherJoint.jointType ~ = AttacherJoints.JOINTTYPE_TRAILERCAR then
                                                                            defaultAllowsLowering = true
                                                                        end
                                                                        inputAttacherJoint.needsLowering = xmlFile:getValue(key .. "#needsLowering" , defaultNeedsLowering)
                                                                        inputAttacherJoint.allowsLowering = xmlFile:getValue(key .. "#allowsLowering" , defaultAllowsLowering)
                                                                        inputAttacherJoint.isDefaultLowered = xmlFile:getValue(key .. "#isDefaultLowered" , false )
                                                                        inputAttacherJoint.useFoldingLoweredState = xmlFile:getValue(key .. "#useFoldingLoweredState" , false )
                                                                        inputAttacherJoint.forceSelection = xmlFile:getValue(key .. "#forceSelectionOnAttach" , true )
                                                                        inputAttacherJoint.forceAllowDetachWhileLifted = xmlFile:getValue(key .. "#forceAllowDetachWhileLifted" , false )
                                                                        inputAttacherJoint.forcedAttachingDirection = xmlFile:getValue(key .. "#forcedAttachingDirection" , 0 )

                                                                        inputAttacherJoint.allowFolding = xmlFile:getValue(key .. "#allowFolding" , true )
                                                                        inputAttacherJoint.allowTurnOn = xmlFile:getValue(key .. "#allowTurnOn" , true )
                                                                        inputAttacherJoint.allowAI = xmlFile:getValue(key .. "#allowAI" , true )
                                                                        inputAttacherJoint.allowDetachWhileParentLifted = xmlFile:getValue(key .. "#allowDetachWhileParentLifted" , true )

                                                                        inputAttacherJoint.useTopLights = xmlFile:getValue(key .. "#useTopLights" , true )

                                                                        inputAttacherJoint.dependentAttacherJoints = { }
                                                                        local k = 0
                                                                        while true do
                                                                            local dependentKey = string.format(key .. ".dependentAttacherJoint(%d)" , k)
                                                                            if not xmlFile:hasProperty(dependentKey) then
                                                                                break
                                                                            end
                                                                            local attacherJointIndex = xmlFile:getValue(dependentKey .. "#attacherJointIndex" )
                                                                            if attacherJointIndex ~ = nil then
                                                                                table.insert(inputAttacherJoint.dependentAttacherJoints, attacherJointIndex)
                                                                            end
                                                                            k = k + 1
                                                                        end

                                                                        -- reset values if hardAttach is active
                                                                            if inputAttacherJoint.hardAttach then
                                                                                inputAttacherJoint.needsLowering = false
                                                                                inputAttacherJoint.allowsLowering = false
                                                                                inputAttacherJoint.isDefaultLowered = false
                                                                                inputAttacherJoint.upperRotationOffset = 0
                                                                            end

                                                                            inputAttacherJoint.changeObjects = { }
                                                                            ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key, inputAttacherJoint.changeObjects, self.components, self )
                                                                            ObjectChangeUtil.setObjectChanges(inputAttacherJoint.changeObjects, false , self , self.setMovingToolDirty)

                                                                            inputAttacherJoint.additionalObjects = { }
                                                                            local i = 0
                                                                            while true do
                                                                                local baseKey = string.format( "%s.additionalObjects.additionalObject(%d)" , key, i)
                                                                                if not xmlFile:hasProperty(baseKey) then
                                                                                    break
                                                                                end

                                                                                local entry = { }
                                                                                entry.node = xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
                                                                                entry.attacherVehiclePath = xmlFile:getValue(baseKey .. "#attacherVehiclePath" )

                                                                                if entry.node ~ = nil and entry.attacherVehiclePath ~ = nil then
                                                                                    entry.attacherVehiclePath = NetworkUtil.convertToNetworkFilename(entry.attacherVehiclePath)
                                                                                    table.insert(inputAttacherJoint.additionalObjects, entry)
                                                                                end

                                                                                i = i + 1
                                                                            end

                                                                            inputAttacherJoint.additionalAttachment = { }
                                                                            local filename = xmlFile:getValue(key .. ".additionalAttachment#filename" )
                                                                            if filename ~ = nil then
                                                                                inputAttacherJoint.additionalAttachment.filename = Utils.getFilename(filename, self.customEnvironment)
                                                                            end
                                                                            inputAttacherJoint.additionalAttachment.inputAttacherJointIndex = xmlFile:getValue(key .. ".additionalAttachment#inputAttacherJointIndex" , 1 )
                                                                            inputAttacherJoint.additionalAttachment.needsLowering = xmlFile:getValue(key .. ".additionalAttachment#needsLowering" , false )

                                                                            local additionalJointTypeStr = xmlFile:getValue(key .. ".additionalAttachment#jointType" )
                                                                            local additionalJointType
                                                                            if additionalJointTypeStr ~ = nil then
                                                                                additionalJointType = AttacherJoints.jointTypeNameToInt[additionalJointTypeStr]
                                                                                if additionalJointType = = nil then
                                                                                    Logging.xmlWarning( self.xmlFile, "Invalid jointType '%s' for additonal implement '%s'!" , tostring(additionalJointTypeStr), inputAttacherJoint.additionalAttachment.filename)
                                                                                    end
                                                                                end

                                                                                inputAttacherJoint.additionalAttachment.jointType = additionalJointType or AttacherJoints.JOINTTYPE_IMPLEMENT

                                                                                return true
                                                                            end

                                                                            return false
                                                                        end

```

### loadSteeringAngleNodeFromXML

**Description**

> Load steering angle node from xml

**Definition**

> loadSteeringAngleNodeFromXML()

**Arguments**

| any | entry   |
|-----|---------|
| any | xmlFile |
| any | key     |

**Code**

```lua
function Attachable:loadSteeringAngleNodeFromXML(entry, xmlFile, key)
    entry.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    entry.speed = xmlFile:getValue(key .. "#speed" , 25 ) / 1000
    entry.scale = xmlFile:getValue(key .. "#scale" , 1 )
    entry.offset = xmlFile:getValue(key .. "#offset" , 0 )
    entry.minSpeed = xmlFile:getValue(key .. "#minSpeed" , 0 )

    entry.currentAngle = 0

    return true
end

```

### loadSteeringAxleFromXML

**Description**

**Definition**

> loadSteeringAxleFromXML()

**Arguments**

| any | spec    |
|-----|---------|
| any | xmlFile |
| any | key     |

**Code**

```lua
function Attachable:loadSteeringAxleFromXML(spec, xmlFile, key)
    spec.steeringAxleAngleScaleStart = xmlFile:getValue(key .. "#startSpeed" , 10 )
    spec.steeringAxleAngleScaleEnd = xmlFile:getValue(key .. "#endSpeed" , 30 )
    spec.steeringAxleAngleScaleSpeedDependent = xmlFile:getValue(key .. "#speedDependent" , true )
    spec.steeringAxleUpdateBackwards = xmlFile:getValue(key .. "#backwards" , false )
    spec.steeringAxleAngleSpeed = xmlFile:getValue(key .. "#speed" , 60 ) * 0.001
    spec.steeringAxleUseSuperAttachable = xmlFile:getValue(key .. "#useSuperAttachable" , false )
    spec.steeringAxleTargetNode = xmlFile:getValue(key .. ".targetNode#node" , nil , self.components, self.i3dMappings)
    spec.steeringAxleTargetNodeRefAngle = xmlFile:getValue(key .. ".targetNode#refAngle" )
    spec.steeringAxleAngleMinRot = xmlFile:getValue(key .. "#minRot" , 0 )
    spec.steeringAxleAngleMaxRot = xmlFile:getValue(key .. "#maxRot" , 0 )
    spec.steeringAxleDirection = xmlFile:getValue(key .. "#direction" , 1 )
    spec.steeringAxleForceUsage = xmlFile:getValue(key .. "#forceUsage" , spec.steeringAxleTargetNode ~ = nil )
    spec.steeringAxleDistanceDelay = xmlFile:getValue(key .. "#distanceDelay" , 0 )

    local referenceComponentIndex = xmlFile:getValue(key .. "#referenceComponentIndex" )
    if referenceComponentIndex ~ = nil then
        local component = self.components[referenceComponentIndex]
        if component ~ = nil then
            spec.steeringAxleReferenceComponentNode = component.node
        end
    end
end

```

### loadSupportAnimationFromXML

**Description**

> Loads support animation from xml

**Definition**

> loadSupportAnimationFromXML(table supportAnimation, XMLFile xmlFile, string key)

**Arguments**

| table   | supportAnimation | supportAnimation |
|---------|------------------|------------------|
| XMLFile | xmlFile          | XMLFile instance |
| string  | key              | key to load from |

**Code**

```lua
function Attachable:loadSupportAnimationFromXML(supportAnimation, xmlFile, key)
    supportAnimation.animationName = xmlFile:getValue(key .. "#animationName" )
    supportAnimation.delayedOnLoad = xmlFile:getValue(key .. "#delayedOnLoad" , false ) -- defines if the animation is played onPostLoad or onPreInitComponentPlacement -> useful if the animation collides e.g.with the folding animation
        supportAnimation.delayedOnAttach = xmlFile:getValue(key .. "#delayedOnAttach" , true ) -- defines if the animation is played before or after the attaching process
            supportAnimation.detachAfterAnimation = xmlFile:getValue(key .. "#detachAfterAnimation" , true ) -- defines if the vehicle is detached after the animation has played
                supportAnimation.detachAnimationTime = xmlFile:getValue(key .. "#detachAnimationTime" , 1 ) -- defines when in the support animation the vehicle is detached

                return supportAnimation.animationName ~ = nil
            end

```

### mountDynamic

**Description**

**Definition**

> mountDynamic()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | object            |
| any | objectActorId     |
| any | jointNode         |
| any | mountType         |
| any | forceAcceleration |

**Code**

```lua
function Attachable:mountDynamic(superFunc, object, objectActorId, jointNode, mountType, forceAcceleration)
    local spec = self.spec_attachable

    if spec.attacherVehicle ~ = nil then
        return false
    end

    return superFunc( self , object, objectActorId, jointNode, mountType, forceAcceleration)
end

```

### onBottomArmBallsI3DLoaded

**Description**

> Called when balls i3d was loaded

**Definition**

> onBottomArmBallsI3DLoaded(integer i3dNode, table args, )

**Arguments**

| integer | i3dNode            | top arm i3d node |
|---------|--------------------|------------------|
| table   | args               | async arguments  |
| any     | inputAttacherJoint |                  |

**Code**

```lua
function Attachable:onBottomArmBallsI3DLoaded(i3dNode, failedReason, inputAttacherJoint)
    if i3dNode ~ = 0 then
        local rootNode = getChildAt(i3dNode, 0 )
        if getNumOfChildren(rootNode) = = 3 then
            link(inputAttacherJoint.node, rootNode)
            setTranslation(rootNode, 0 , 0 , 0 )
            setRotation(rootNode, 0 , math.pi * 0.5 , 0 )

            inputAttacherJoint.bottomArm.ballsNode = rootNode
            inputAttacherJoint.bottomArm.ballsNodeLeft = getChildAt(rootNode, 0 )
            inputAttacherJoint.bottomArm.ballsNodeRight = getChildAt(rootNode, 1 )
            inputAttacherJoint.bottomArm.ballsNodeTop = getChildAt(rootNode, 2 )

            local width = inputAttacherJoint.bottomArm.widths[#inputAttacherJoint.bottomArm.widths]
            setTranslation(inputAttacherJoint.bottomArm.ballsNodeLeft, width * 0.5 , 0 , 0 )
            setTranslation(inputAttacherJoint.bottomArm.ballsNodeRight, - width * 0.5 , 0 , 0 )

            setVisibility(inputAttacherJoint.bottomArm.ballsNode, inputAttacherJoint.bottomArm.ballDefaultVisibility)

            setVisibility(inputAttacherJoint.bottomArm.ballsNodeTop, inputAttacherJoint.topReferenceNode ~ = nil )
            if inputAttacherJoint.topReferenceNode ~ = nil then
                link(inputAttacherJoint.topReferenceNode, inputAttacherJoint.bottomArm.ballsNodeTop)
            end
        else
                Logging.warning( "Loaded balls i3d node has wrong amount of nodes.One root node with 3(left, right, top) ball nodes is required! (%s)" , inputAttacherJoint.bottomArm.ballFilename)
            end
            delete(i3dNode)
        end
    end

```

### onDeactivate

**Description**

> Called on deactivate

**Definition**

> onDeactivate()

**Code**

```lua
function Attachable:onDeactivate()
    if self.brake ~ = nil then
        local brakeForce = self:getBrakeForce()
        if brakeForce > 0 then
            self:brake(brakeForce, true )
        end
    end

    if self.isClient then
        local spec = self.spec_attachable
        if spec.isActiveSamplePlaying then
            g_soundManager:stopSamples(spec.samples.active)
            spec.isActiveSamplePlaying = false
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
function Attachable:onDelete()
    local spec = self.spec_attachable

    if spec.toolCameras ~ = nil then
        for _, camera in ipairs(spec.toolCameras) do
            camera:delete()
        end
    end

    if spec.inputAttacherJoints ~ = nil then
        for i = 1 , #spec.inputAttacherJoints do
            local inputAttacherJoint = spec.inputAttacherJoints[i]
            if inputAttacherJoint.bottomArm ~ = nil and inputAttacherJoint.bottomArm.sharedLoadRequestIdBalls ~ = nil then
                g_i3DManager:releaseSharedI3DFile(inputAttacherJoint.bottomArm.sharedLoadRequestIdBalls)
            end
        end
    end

    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.active)
    end
end

```

### onFoldStateChanged

**Description**

> Called while folding state changes

**Definition**

> onFoldStateChanged()

**Arguments**

| any | direction    |
|-----|--------------|
| any | moveToMiddle |

**Code**

```lua
function Attachable:onFoldStateChanged(direction, moveToMiddle)
    local spec = self.spec_foldable
    if spec.foldMiddleAnimTime ~ = nil then
        if not moveToMiddle and direction = = spec.turnOnFoldDirection then
            SpecializationUtil.raiseEvent( self , "onSetLowered" , true )
        else
                SpecializationUtil.raiseEvent( self , "onSetLowered" , false )
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
function Attachable:onLoad(savegame)
    local spec = self.spec_attachable

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attacherJoint" , "vehicle.inputAttacherJoints.inputAttacherJoint" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.needsLowering" , "vehicle.inputAttacherJoints.inputAttacherJoint#needsLowering" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.allowsLowering" , "vehicle.inputAttacherJoints.inputAttacherJoint#allowsLowering" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.isDefaultLowered" , "vehicle.inputAttacherJoints.inputAttacherJoint#isDefaultLowered" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.forceSelectionOnAttach#value" , "vehicle.inputAttacherJoints.inputAttacherJoint#forceSelectionOnAttach" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.topReferenceNode#index" , "vehicle.attacherJoint#topReferenceNode" ) -- FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachRootNode#index" , "vehicle.attacherJoint#rootNode" ) -- FS15 to FS17

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.inputAttacherJoints" , "vehicle.attachable.inputAttacherJoints" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.inputAttacherJointConfigurations" , "vehicle.attachable.inputAttacherJointConfigurations" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.brakeForce" , "vehicle.attachable.brakeForce#force" ) -- FS17 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachable.brakeForce" , "vehicle.attachable.brakeForce#force" , nil , true ) -- FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.steeringAxleAngleScale" , "vehicle.attachable.steeringAxleAngleScale" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.support" , "vehicle.attachable.support" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.lowerAnimation" , "vehicle.attachable.lowerAnimation" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.toolCameras" , "vehicle.attachable.toolCameras" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachable.toolCameras#count" , "vehicle.attachable.toolCameras" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachable.toolCameras.toolCamera1" , "vehicle.attachable.toolCamera" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachable.toolCameras.toolCamera2" , "vehicle.attachable.toolCamera" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachable.toolCameras.toolCamera3" , "vehicle.attachable.toolCamera" ) -- FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.foldable.foldingParts#onlyFoldOnDetach" , "vehicle.attachable#allowFoldingWhileAttached" ) -- FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.maximalAirConsumptionPerFullStop" , "vehicle.attachable.airConsumer#usage(is now in usage per second at full brake power)" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.attachable.steeringAxleAngleScale#targetNode" , "vehicle.attachable.steeringAxleAngleScale.targetNode#node" ) --FS19 to FS22

    spec.attacherJoint = nil

    spec.supportAnimations = { }
    self.xmlFile:iterate( "vehicle.attachable.support" , function (_, baseKey)
        local entry = { }
        if self:loadSupportAnimationFromXML(entry, self.xmlFile, baseKey) then
            table.insert(spec.supportAnimations, entry)
        end
    end )

    spec.inputAttacherJoints = { }
    self.xmlFile:iterate( "vehicle.attachable.inputAttacherJoints.inputAttacherJoint" , function (i, key)
        local inputAttacherJoint = { }
        if self:loadInputAttacherJoint( self.xmlFile, key, inputAttacherJoint, i - 1 ) then
            table.insert(spec.inputAttacherJoints, inputAttacherJoint)
        end
    end )

    if self.configurations[ "inputAttacherJoint" ] ~ = nil then
        local attacherConfigs = string.format( "vehicle.attachable.inputAttacherJointConfigurations.inputAttacherJointConfiguration(%d)" , self.configurations[ "inputAttacherJoint" ] - 1 )
        self.xmlFile:iterate(attacherConfigs .. ".inputAttacherJoint" , function (i, baseName)
            local inputAttacherJoint = { }
            if self:loadInputAttacherJoint( self.xmlFile, baseName, inputAttacherJoint, i - 1 ) then
                table.insert(spec.inputAttacherJoints, inputAttacherJoint)
            end
        end )

        self.xmlFile:iterate(attacherConfigs .. ".support" , function (_, baseKey)
            local entry = { }
            if self:loadSupportAnimationFromXML(entry, self.xmlFile, baseKey) then
                table.insert(spec.supportAnimations, entry)
            end
        end )
    end

    spec.brakeForce = self.xmlFile:getValue( "vehicle.attachable.brakeForce#force" , 0 ) * 10
    spec.maxBrakeForce = self.xmlFile:getValue( "vehicle.attachable.brakeForce#maxForce" , 0 ) * 10
    spec.loweredBrakeForce = self.xmlFile:getValue( "vehicle.attachable.brakeForce#loweredForce" , - 1 ) * 10
    spec.maxBrakeForceMass = self.xmlFile:getValue( "vehicle.attachable.brakeForce#maxForceMass" , 0 ) / 1000
    spec.maxBrakeForceMassIncludeAttachables = self.xmlFile:getValue( "vehicle.attachable.brakeForce#includeAttachables" , false )
    if spec.maxBrakeForce ~ = 0 and spec.maxBrakeForceMass = = 0 then
        Logging.xmlWarning( self.xmlFile, "Max.brake force is defined, but no 'maxBrakeForceMass' is given.The brake force will not be used." )
    end

    spec.airConsumerUsage = self.xmlFile:getValue( "vehicle.attachable.airConsumer#usage" , 0 )

    spec.allowFoldingWhileAttached = self.xmlFile:getValue( "vehicle.attachable#allowFoldingWhileAttached" , true )
    spec.allowFoldingWhileLowered = self.xmlFile:getValue( "vehicle.attachable#allowFoldingWhileLowered" , true )
    spec.blockFoliageDestruction = self.xmlFile:getValue( "vehicle.attachable#blockFoliageDestruction" , false )

    spec.requiresExternalPower = self.xmlFile:getValue( "vehicle.attachable.power#requiresExternalPower" , true )
    spec.attachToPowerWarning = self.xmlFile:getValue( "vehicle.attachable.power#attachToPowerWarning" , "warning_attachToPower" , self.customEnvironment)

    spec.updateWheels = true
    spec.updateSteeringAxleAngle = true

    spec.isDetachingBlocked = false

    spec.isSelected = false
    spec.attachTime = 0

    spec.steeringAxleAngle = 0
    spec.steeringAxleTargetAngle = 0

    self:loadSteeringAxleFromXML(spec, self.xmlFile, "vehicle.attachable.steeringAxleAngleScale" )

    if spec.steeringAxleDistanceDelay > 0 then
        spec.steeringAxleTargetAngleHistory = { }
        for i = 1 , math.floor(spec.steeringAxleDistanceDelay / 0.1 ) do
            spec.steeringAxleTargetAngleHistory[i] = 0
        end
        spec.steeringAxleTargetAngleHistoryIndex = 1
        spec.steeringAxleTargetAngleHistoryMoved = 1
    end

    spec.steeringAngleNodes = { }
    self.xmlFile:iterate( "vehicle.attachable.steeringAngleNodes.steeringAngleNode" , function (_, key)
        local entry = { }
        if self:loadSteeringAngleNodeFromXML(entry, self.xmlFile, key) then
            table.insert(spec.steeringAngleNodes, entry)
        end
    end )

    spec.detachingInProgress = false

    spec.lowerAnimation = self.xmlFile:getValue( "vehicle.attachable.lowerAnimation#name" )
    spec.lowerAnimationSpeed = self.xmlFile:getValue( "vehicle.attachable.lowerAnimation#speed" , 1 )
    spec.lowerAnimationDirectionOnDetach = self.xmlFile:getValue( "vehicle.attachable.lowerAnimation#directionOnDetach" , 0 )
    spec.lowerAnimationDefaultLowered = self.xmlFile:getValue( "vehicle.attachable.lowerAnimation#defaultLowered" , false )

    spec.toolCameras = { }
    self.xmlFile:iterate( "vehicle.attachable.toolCameras.toolCamera" , function (_, cameraKey)
        local camera = VehicleCamera.new( self )
        if camera:loadFromXML( self.xmlFile, cameraKey) then
            table.insert(spec.toolCameras, camera)
        end
    end )

    if self.isClient then
        spec.samples = { }
        spec.samples.active = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.attachable.sounds" , "active" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.isActiveSamplePlaying = false
    end

    spec.isHardAttached = false
    spec.isAdditionalAttachment = false

    spec.texts = { }
    spec.texts.liftObject = g_i18n:getText( "action_liftOBJECT" )
    spec.texts.lowerObject = g_i18n:getText( "action_lowerOBJECT" )
    spec.texts.warningFoldingAttached = g_i18n:getText( "warning_foldingNotWhileAttached" )
    spec.texts.warningFoldingLowered = g_i18n:getText( "warning_foldingNotWhileLowered" )
    spec.texts.warningFoldingAttacherJoint = g_i18n:getText( "warning_foldingNotWhileAttachedToAttacherJoint" )
    spec.texts.lowerImplementFirst = g_i18n:getText( "warning_lowerImplementFirst" )
end

```

### onLoadFinished

**Description**

> Called when loading is finished

**Definition**

> onLoadFinished(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Attachable:onLoadFinished(savegame)
    local spec = self.spec_attachable
    for inputAttacherJointIndex, inputAttacherJoint in ipairs(spec.inputAttacherJoints) do
        inputAttacherJoint.jointInfo = g_currentMission.vehicleSystem:registerInputAttacherJoint( self , inputAttacherJointIndex, inputAttacherJoint)
    end
end

```

### onPostLoad

**Description**

> Called after loading

**Definition**

> onPostLoad(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Attachable:onPostLoad(savegame)
    local spec = self.spec_attachable

    for _, supportAnimation in ipairs(spec.supportAnimations) do
        if not supportAnimation.delayedOnLoad then
            if self:getIsSupportAnimationAllowed(supportAnimation) then
                self:playAnimation(supportAnimation.animationName, 1 , nil , true , false )
                AnimatedVehicle.updateAnimationByName( self , supportAnimation.animationName, 9999999 , true )
            end
        end
    end

    if self.brake ~ = nil then
        local brakeForce = self:getBrakeForce()
        if brakeForce > 0 then
            self:brake(brakeForce, true )
        end
    end

    spec.updateSteeringAxleAngle = #spec.steeringAngleNodes > 0 or spec.steeringAxleTargetNode ~ = nil or( self.getWheels ~ = nil and # self:getWheels() > 0 )

    if #spec.inputAttacherJoints = = 0 then
        SpecializationUtil.removeEventListener( self , "onUpdateInterpolation" , Attachable )
        SpecializationUtil.removeEventListener( self , "onUpdate" , Attachable )
    end
end

```

### onPreDelete

**Description**

> Called on before deleting

**Definition**

> onPreDelete()

**Code**

```lua
function Attachable:onPreDelete()
    local spec = self.spec_attachable

    if spec.attacherVehicle ~ = nil then
        spec.attacherVehicle:detachImplementByObject( self , true )
    end

    if spec.inputAttacherJoints ~ = nil then
        for i = 1 , #spec.inputAttacherJoints do
            local inputAttacherJoint = spec.inputAttacherJoints[i]
            if inputAttacherJoint.jointInfo ~ = nil then
                g_currentMission.vehicleSystem:removeInputAttacherJoint(inputAttacherJoint.jointInfo)
                inputAttacherJoint.jointInfo = nil
            end
        end
    end
end

```

### onPreInitComponentPlacement

**Description**

> Called on load finished

**Definition**

> onPreInitComponentPlacement(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Attachable:onPreInitComponentPlacement(savegame)
    local spec = self.spec_attachable

    for _, supportAnimation in ipairs(spec.supportAnimations) do
        if supportAnimation.delayedOnLoad then
            if self:getIsSupportAnimationAllowed(supportAnimation) then
                self:playAnimation(supportAnimation.animationName, 1 , nil , true , false )
                AnimatedVehicle.updateAnimationByName( self , supportAnimation.animationName, 9999999 , true )
            end
        end
    end

    for _, inputAttacherJoint in ipairs(spec.inputAttacherJoints) do
        if inputAttacherJoint.drawbarNode ~ = nil then
            self:setMovingPartReferenceNode(inputAttacherJoint.drawbarNode, inputAttacherJoint.node, false )
            self:setMovingPartReferenceNode(inputAttacherJoint.drawbarNode, nil , false )
        end
    end

    if savegame ~ = nil and not savegame.resetVehicles then
        if spec.lowerAnimation ~ = nil and self.playAnimation ~ = nil then
            local lowerAnimTime = savegame.xmlFile:getValue(savegame.key .. ".attachable#lowerAnimTime" )
            if lowerAnimTime ~ = nil then
                local speed = 1
                if lowerAnimTime < 0.5 then
                    speed = - 1
                end
                self:playAnimation(spec.lowerAnimation, speed, nil , true , false )
                self:setAnimationTime(spec.lowerAnimation, lowerAnimTime)
                AnimatedVehicle.updateAnimationByName( self , spec.lowerAnimation, 9999999 , true )

                if self.updateCylinderedInitial ~ = nil then
                    self:updateCylinderedInitial( false )
                end
            end
        end

        spec.isDetachingBlocked = savegame.xmlFile:getValue(savegame.key .. ".attachable#isDetachingBlocked" , false )
    else
            if spec.lowerAnimationDefaultLowered then
                self:playAnimation(spec.lowerAnimation, 1 , nil , true , false )
                AnimatedVehicle.updateAnimationByName( self , spec.lowerAnimation, 9999999 , true )
            end
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
function Attachable:onReadStream(streamId, connection)
    if streamReadBool(streamId) then
        local object = NetworkUtil.readNodeObject(streamId)
        local inputJointDescIndex = streamReadInt8(streamId)
        local jointDescIndex = streamReadInt8(streamId)
        local moveDown = streamReadBool(streamId)
        local implementIndex = streamReadInt8(streamId)
        if object ~ = nil and object:getIsSynchronized() then
            object:attachImplement( self , inputJointDescIndex, jointDescIndex, true , implementIndex, moveDown, true , true )
            object:setJointMoveDown(jointDescIndex, moveDown, true )
        end
    end
end

```

### onRegisterAnimationValueTypes

**Description**

> Called on pre load to register animation value types

**Definition**

> onRegisterAnimationValueTypes()

**Code**

```lua
function Attachable:onRegisterAnimationValueTypes()
    local loadInputAttacherJoint = function (value, xmlFile, xmlKey)
        value.inputAttacherJointIndex = xmlFile:getValue(xmlKey .. "#inputAttacherJointIndex" )

        if value.inputAttacherJointIndex ~ = nil then
            value:setWarningInformation( "inputAttacherJointIndex: " .. value.inputAttacherJointIndex)
            value:addCompareParameters( "inputAttacherJointIndex" )

            return true
        end

        return false
    end

    local resolveAttacherJoint = function (value)
        if value.inputAttacherJoint = = nil then
            value.inputAttacherJoint = self:getInputAttacherJointByJointDescIndex(value.inputAttacherJointIndex)
            if value.inputAttacherJoint = = nil then
                Logging.xmlWarning( self.xmlFile, "Unknown inputAttacherJointIndex '%s' for animation part." , value.inputAttacherJointIndex)
                    value.inputAttacherJointIndex = nil
                    return
                end
            end
        end

        local updateJointSettings = function ( .. .)
            if self.isServer then
                local attacherVehicle = self:getAttacherVehicle()
                if attacherVehicle ~ = nil then
                    attacherVehicle:updateAttacherJointSettingsByObject( self , .. .)
                end
            end
        end

        self:registerAnimationValueType( "lowerRotLimitScale" , "lowerRotLimitScaleStart" , "lowerRotLimitScaleEnd" , false , AnimationValueFloat ,
        loadInputAttacherJoint,

        function (value)
            if value.inputAttacherJointIndex ~ = nil then
                resolveAttacherJoint(value)
            end

            if value.inputAttacherJoint ~ = nil then
                return unpack(value.inputAttacherJoint.lowerRotLimitScale)
            else
                    return 0 , 0 , 0
                end
            end ,

            function (value, x, y, z)
                if value.inputAttacherJoint ~ = nil then
                    value.inputAttacherJoint.lowerRotLimitScale[ 1 ] = x
                    value.inputAttacherJoint.lowerRotLimitScale[ 2 ] = y
                    value.inputAttacherJoint.lowerRotLimitScale[ 3 ] = z
                    updateJointSettings( true )
                end
            end )

            self:registerAnimationValueType( "upperRotLimitScale" , "upperRotLimitScaleStart" , "upperRotLimitScaleEnd" , false , AnimationValueFloat ,
            loadInputAttacherJoint,

            function (value)
                if value.inputAttacherJointIndex ~ = nil then
                    resolveAttacherJoint(value)
                end

                if value.inputAttacherJoint ~ = nil then
                    return unpack(value.inputAttacherJoint.upperRotLimitScale)
                else
                        return 0 , 0 , 0
                    end
                end ,

                function (value, x, y, z)
                    if value.inputAttacherJoint ~ = nil then
                        value.inputAttacherJoint.upperRotLimitScale[ 1 ] = x
                        value.inputAttacherJoint.upperRotLimitScale[ 2 ] = y
                        value.inputAttacherJoint.upperRotLimitScale[ 3 ] = z
                        updateJointSettings( true )
                    end
                end )

                self:registerAnimationValueType( "lowerTransLimitScale" , "lowerTransLimitScaleStart" , "lowerTransLimitScaleEnd" , false , AnimationValueFloat ,
                loadInputAttacherJoint,

                function (value)
                    if value.inputAttacherJointIndex ~ = nil then
                        resolveAttacherJoint(value)
                    end

                    if value.inputAttacherJoint ~ = nil then
                        return unpack(value.inputAttacherJoint.lowerTransLimitScale)
                    else
                            return 0 , 0 , 0
                        end
                    end ,

                    function (value, x, y, z)
                        if value.inputAttacherJoint ~ = nil then
                            value.inputAttacherJoint.lowerTransLimitScale[ 1 ] = x
                            value.inputAttacherJoint.lowerTransLimitScale[ 2 ] = y
                            value.inputAttacherJoint.lowerTransLimitScale[ 3 ] = z
                            updateJointSettings( true )
                        end
                    end )

                    self:registerAnimationValueType( "upperTransLimitScale" , "upperTransLimitScaleStart" , "upperTransLimitScaleEnd" , false , AnimationValueFloat ,
                    loadInputAttacherJoint,

                    function (value)
                        if value.inputAttacherJointIndex ~ = nil then
                            resolveAttacherJoint(value)
                        end

                        if value.inputAttacherJoint ~ = nil then
                            return unpack(value.inputAttacherJoint.upperTransLimitScale)
                        else
                                return 0 , 0 , 0
                            end
                        end ,

                        function (value, x, y, z)
                            if value.inputAttacherJoint ~ = nil then
                                value.inputAttacherJoint.upperTransLimitScale[ 1 ] = x
                                value.inputAttacherJoint.upperTransLimitScale[ 2 ] = y
                                value.inputAttacherJoint.upperTransLimitScale[ 3 ] = z
                                updateJointSettings( true )
                            end
                        end )

                        self:registerAnimationValueType( "lowerRotationOffset" , "lowerRotationOffsetStart" , "lowerRotationOffsetEnd" , false , AnimationValueFloat ,
                        loadInputAttacherJoint,

                        function (value)
                            if value.inputAttacherJointIndex ~ = nil then
                                resolveAttacherJoint(value)
                            end

                            if value.inputAttacherJoint ~ = nil then
                                return value.inputAttacherJoint.lowerRotationOffset
                            else
                                    return 0
                                end
                            end ,

                            function (value, lowerRotationOffset)
                                if value.inputAttacherJoint ~ = nil then
                                    value.inputAttacherJoint.lowerRotationOffset = lowerRotationOffset
                                    updateJointSettings( false , true )
                                end
                            end )

                            self:registerAnimationValueType( "upperRotationOffset" , "upperRotationOffsetStart" , "upperRotationOffsetEnd" , false , AnimationValueFloat ,
                            loadInputAttacherJoint,

                            function (value)
                                if value.inputAttacherJointIndex ~ = nil then
                                    resolveAttacherJoint(value)
                                end

                                if value.inputAttacherJoint ~ = nil then
                                    return value.inputAttacherJoint.upperRotationOffset
                                else
                                        return 0
                                    end
                                end ,

                                function (value, upperRotationOffset)
                                    if value.inputAttacherJoint ~ = nil then
                                        value.inputAttacherJoint.upperRotationOffset = upperRotationOffset
                                        updateJointSettings( false , true )
                                    end
                                end )

                                self:registerAnimationValueType( "lowerDistanceToGround" , "lowerDistanceToGroundStart" , "lowerDistanceToGroundEnd" , false , AnimationValueFloat ,
                                loadInputAttacherJoint,

                                function (value)
                                    if value.inputAttacherJointIndex ~ = nil then
                                        resolveAttacherJoint(value)
                                    end

                                    if value.inputAttacherJoint ~ = nil then
                                        return value.inputAttacherJoint.lowerDistanceToGround
                                    else
                                            return 0
                                        end
                                    end ,

                                    function (value, lowerDistanceToGround)
                                        if value.inputAttacherJoint ~ = nil then
                                            value.inputAttacherJoint.lowerDistanceToGround = lowerDistanceToGround
                                            updateJointSettings( false , false , true )
                                        end
                                    end )

                                    self:registerAnimationValueType( "upperDistanceToGround" , "upperDistanceToGroundStart" , "upperDistanceToGroundEnd" , false , AnimationValueFloat ,
                                    loadInputAttacherJoint,

                                    function (value)
                                        if value.inputAttacherJointIndex ~ = nil then
                                            resolveAttacherJoint(value)
                                        end

                                        if value.inputAttacherJoint ~ = nil then
                                            return value.inputAttacherJoint.upperDistanceToGround
                                        else
                                                return 0
                                            end
                                        end ,

                                        function (value, upperDistanceToGround)
                                            if value.inputAttacherJoint ~ = nil then
                                                value.inputAttacherJoint.upperDistanceToGround = upperDistanceToGround
                                                updateJointSettings( false , false , true )
                                            end
                                        end )
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
function Attachable:onRootVehicleChanged(rootVehicle)
    local spec = self.spec_attachable
    local actionController = rootVehicle.actionController
    if actionController ~ = nil then
        if spec.controlledAction ~ = nil then
            spec.controlledAction:updateParent(actionController)
        end
    end
end

```

### onSelect

**Description**

**Definition**

> onSelect()

**Arguments**

| any | subSelectionIndex |
|-----|-------------------|

**Code**

```lua
function Attachable:onSelect(subSelectionIndex)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        attacherVehicle:setSelectedImplementByObject( self )
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
function Attachable:onStateChange(state, data)
    if self.getAILowerIfAnyIsLowered ~ = nil then
        if self:getAILowerIfAnyIsLowered() then
            if state = = VehicleStateChange.AI_START_LINE then
                Attachable.actionControllerLowerImplementEvent( self , 1 )
            elseif state = = VehicleStateChange.AI_END_LINE then
                    Attachable.actionControllerLowerImplementEvent( self , - 1 )
                end
            end
        end
    end

```

### onUnselect

**Description**

**Definition**

> onUnselect()

**Code**

```lua
function Attachable:onUnselect()
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        attacherVehicle:setSelectedImplementByObject( nil )
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
function Attachable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_attachable

    local yRot
    if spec.updateSteeringAxleAngle then
        if self:getLastSpeed() > 0.25 or not self.finishedFirstUpdate then
            local steeringAngle = 0
            local baseVehicle = self:getSteeringAxleBaseVehicle()
            local allowedBackwards = spec.steeringAxleUpdateBackwards and not self:getIsAIActive()
            if (baseVehicle ~ = nil or spec.steeringAxleReferenceComponentNode ~ = nil ) and( self.movingDirection > = 0 or allowedBackwards) then
                yRot = Utils.getYRotationBetweenNodes( self.steeringAxleNode, spec.steeringAxleReferenceComponentNode or baseVehicle.steeringAxleNode)

                local scale = 1
                if spec.steeringAxleAngleScaleSpeedDependent then
                    local startSpeed = spec.steeringAxleAngleScaleStart
                    local endSpeed = spec.steeringAxleAngleScaleEnd
                    scale = math.clamp( 1 + ( self:getLastSpeed() - startSpeed) * 1.0 / (startSpeed - endSpeed), 0 , 1 )
                end
                steeringAngle = yRot * scale
            elseif self:getLastSpeed() > 0.2 then
                    steeringAngle = 0
                end

                if not self:getIsSteeringAxleAllowed() then
                    steeringAngle = 0
                end

                if spec.steeringAxleDistanceDelay > 0 then
                    spec.steeringAxleTargetAngleHistoryMoved = spec.steeringAxleTargetAngleHistoryMoved + self.lastMovedDistance
                    if spec.steeringAxleTargetAngleHistoryMoved > 0.1 then
                        spec.steeringAxleTargetAngleHistory[spec.steeringAxleTargetAngleHistoryIndex] = steeringAngle

                        spec.steeringAxleTargetAngleHistoryIndex = spec.steeringAxleTargetAngleHistoryIndex + 1
                        if spec.steeringAxleTargetAngleHistoryIndex > #spec.steeringAxleTargetAngleHistory then
                            spec.steeringAxleTargetAngleHistoryIndex = 1
                        end
                    end

                    local lastIndex = spec.steeringAxleTargetAngleHistoryIndex + 1
                    if lastIndex > #spec.steeringAxleTargetAngleHistory then
                        lastIndex = 1
                    end
                    spec.steeringAxleTargetAngle = spec.steeringAxleTargetAngleHistory[lastIndex]
                else
                        spec.steeringAxleTargetAngle = steeringAngle
                    end

                    local dir = math.sign(spec.steeringAxleTargetAngle - spec.steeringAxleAngle)
                    local speed = spec.steeringAxleAngleSpeed
                    if not self.finishedFirstUpdate then
                        speed = 9999
                    end
                    if dir = = 1 then
                        spec.steeringAxleAngle = math.min(spec.steeringAxleAngle + dir * dt * speed, spec.steeringAxleTargetAngle)
                    else
                            spec.steeringAxleAngle = math.max(spec.steeringAxleAngle + dir * dt * speed, spec.steeringAxleTargetAngle)
                        end

                        if spec.steeringAxleTargetNode ~ = nil then
                            local angle
                            if spec.steeringAxleTargetNodeRefAngle ~ = nil then
                                local alpha = math.clamp(spec.steeringAxleAngle / spec.steeringAxleTargetNodeRefAngle, - 1 , 1 )
                                if alpha > = 0 then
                                    angle = spec.steeringAxleAngleMaxRot * alpha
                                else
                                        angle = spec.steeringAxleAngleMinRot * - alpha
                                    end
                                else
                                        angle = math.clamp(spec.steeringAxleAngle, spec.steeringAxleAngleMinRot, spec.steeringAxleAngleMaxRot)
                                    end

                                    setRotation(spec.steeringAxleTargetNode, 0 , angle * spec.steeringAxleDirection, 0 )
                                    self:setMovingToolDirty(spec.steeringAxleTargetNode)
                                end
                            end
                        end

                        local numSteeringAngleNodes = #spec.steeringAngleNodes
                        if numSteeringAngleNodes > 0 and yRot = = nil then
                            local baseVehicle = self:getSteeringAxleBaseVehicle()
                            if baseVehicle ~ = nil then
                                yRot = Utils.getYRotationBetweenNodes( self.steeringAxleNode, baseVehicle.steeringAxleNode)
                            end
                        end
                        if yRot ~ = nil then
                            for i = 1 , numSteeringAngleNodes do
                                self:updateSteeringAngleNode(spec.steeringAngleNodes[i], yRot, dt)
                            end
                        end

                        local attacherVehicle = self:getAttacherVehicle()

                        if spec.detachingInProgress then
                            if self:getIsReadyToFinishDetachProcess() then
                                if attacherVehicle ~ = nil then
                                    attacherVehicle:detachImplementByObject( self )
                                end

                                spec.detachingInProgress = false
                            end
                        end
                    end

```

### onUpdateInterpolation

**Description**

> Called after position interpolation update

**Definition**

> onUpdateInterpolation(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function Attachable:onUpdateInterpolation(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        if self.currentUpdateDistance < attacherVehicle.spec_attacherJoints.maxUpdateDistance then
            if self.updateLoopIndex = = attacherVehicle.updateLoopIndex then
                local implement = attacherVehicle:getImplementByObject( self )
                if implement ~ = nil then
                    attacherVehicle:updateAttacherJointGraphics(implement, dt, true )
                    self:updateInputAttacherJointGraphics(implement, dt, true )
                end
            end
        end
    end
end

```

### onUpdateTick

**Description**

> Called on update tick

**Definition**

> onUpdateTick(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function Attachable:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_attachable
    for i = 1 , #spec.inputAttacherJoints do
        local inputAttacherJoint = spec.inputAttacherJoints[i]
        if inputAttacherJoint.jointInfo ~ = nil then
            g_currentMission.vehicleSystem:updateInputAttacherJoint(inputAttacherJoint.jointInfo)
        end
    end

    if self.isClient then
        if self.lastSpeed > 0.00027 then
            if not spec.isActiveSamplePlaying then
                g_soundManager:playSamples(spec.samples.active)
                spec.isActiveSamplePlaying = true
            end
        else
                if spec.isActiveSamplePlaying then
                    g_soundManager:stopSamples(spec.samples.active)
                    spec.isActiveSamplePlaying = false
                end
            end
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
function Attachable:onWriteStream(streamId, connection)
    local spec = self.spec_attachable

    streamWriteBool(streamId, spec.attacherVehicle ~ = nil )
    if spec.attacherVehicle ~ = nil then
        local attacherJointVehicleSpec = spec.attacherVehicle.spec_attacherJoints
        local implementIndex = spec.attacherVehicle:getImplementIndexByObject( self )
        local implement = attacherJointVehicleSpec.attachedImplements[implementIndex]
        local inputJointDescIndex = spec.inputAttacherJointDescIndex
        local jointDescIndex = implement.jointDescIndex
        local jointDesc = attacherJointVehicleSpec.attacherJoints[jointDescIndex]
        local moveDown = jointDesc.moveDown
        NetworkUtil.writeNodeObject(streamId, spec.attacherVehicle)
        streamWriteInt8(streamId, inputJointDescIndex)
        streamWriteInt8(streamId, jointDescIndex)
        streamWriteBool(streamId, moveDown)
        streamWriteInt8(streamId, implementIndex)
    end
end

```

### postAttach

**Description**

> Called if vehicle gets attached

**Definition**

> postAttach(table attacherVehicle, integer inputJointDescIndex, integer jointDescIndex, boolean loadFromSavegame)

**Arguments**

| table   | attacherVehicle     | attacher vehicle                            |
|---------|---------------------|---------------------------------------------|
| integer | inputJointDescIndex | index of input attacher joint               |
| integer | jointDescIndex      | index of attacher joint it gets attached to |
| boolean | loadFromSavegame    | attachment is loaded from savegame          |

**Code**

```lua
function Attachable:postAttach(attacherVehicle, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local spec = self.spec_attachable

    -- only activate tool if root vehicle is controlled(activated).We don't want to activate a tool that is attached during loading
        local rootVehicle = self.rootVehicle
        if rootVehicle ~ = nil and rootVehicle.getIsControlled ~ = nil and rootVehicle:getIsControlled() then
            self:activate()
        end

        if self.setLightsTypesMask ~ = nil then
            local lightsSpecAttacherVehicle = attacherVehicle.spec_lights
            if lightsSpecAttacherVehicle ~ = nil then
                self:setLightsTypesMask(lightsSpecAttacherVehicle.lightsTypesMask, true , true )
                self:setBeaconLightsVisibility(lightsSpecAttacherVehicle.beaconLightsActive, true , true )
                self:setTurnLightState(lightsSpecAttacherVehicle.turnLightState, true , true )
            end
        end

        spec.attachTime = g_currentMission.time

        for _, supportAnimation in ipairs(spec.supportAnimations) do
            if self:getIsSupportAnimationAllowed(supportAnimation) then
                if supportAnimation.delayedOnAttach then
                    local skipAnimation = self.propertyState = = VehiclePropertyState.SHOP_CONFIG or loadFromSavegame

                    self:playAnimation(supportAnimation.animationName, - 1 , nil , true , not skipAnimation)
                    if skipAnimation then
                        AnimatedVehicle.updateAnimationByName( self , supportAnimation.animationName, 9999999 , true )
                    end
                end
            end
        end

        self:attachableAddToolCameras()

        ObjectChangeUtil.setObjectChanges(spec.attacherJoint.changeObjects, true , self , self.setMovingToolDirty)

        local jointDesc = attacherVehicle:getAttacherJointByJointDescIndex(jointDescIndex)
        if spec.attacherJoint.steeringBarLeftNode ~ = nil and jointDesc.steeringBarLeftNode ~ = nil then
            self:setMovingPartReferenceNode(spec.attacherJoint.steeringBarLeftNode, jointDesc.steeringBarLeftNode, false )
        end
        if spec.attacherJoint.steeringBarRightNode ~ = nil and jointDesc.steeringBarRightNode ~ = nil then
            self:setMovingPartReferenceNode(spec.attacherJoint.steeringBarRightNode, jointDesc.steeringBarRightNode, false )
        end
        if spec.attacherJoint.drawbarNode ~ = nil then
            self:setMovingPartReferenceNode(spec.attacherJoint.drawbarNode, jointDesc.jointTransform, false )
        end

        local actionController = self.rootVehicle.actionController
        if actionController ~ = nil then
            local inputJointDesc = self:getActiveInputAttacherJoint()
            if inputJointDesc ~ = nil then
                if inputJointDesc.needsLowering and inputJointDesc.allowsLowering and jointDesc.allowsLowering and(inputJointDesc.lowerDistanceToGround ~ = inputJointDesc.upperDistanceToGround or spec.lowerAnimation ~ = nil ) then
                    spec.controlledAction = actionController:registerAction( "lower" , InputAction.LOWER_IMPLEMENT, 2 )
                    spec.controlledAction:setCallback( self , Attachable.actionControllerLowerImplementEvent)
                    spec.controlledAction:setFinishedFunctions( self , function () return jointDesc.moveDown end , true , false )
                    spec.controlledAction:setIsSaved( true )
                    spec.controlledAction:setIsAvailableFunction( function ()
                        return true
                    end )
                    spec.controlledAction:setIsAccessibleFunction( function ()
                        -- if g_guidedTourManager:getIsTourRunning() then
                            -- if actionController:getActionControllerDirection() = = 1 then
                                -- if not g_currentMission.guidedTour:getCanBeLowered(self) then
                                    -- return false
                                    -- end
                                    -- else
                                        -- if not g_currentMission.guidedTour:getCanBeLifted(self) then
                                            -- return false
                                            -- end
                                            -- end
                                            -- end

                                            return true
                                        end )
                                        if self:getAINeedsLowering() then
                                            spec.controlledAction:addAIEventListener( self , "onAIImplementStartLine" , 1 , true )
                                            spec.controlledAction:addAIEventListener( self , "onAIImplementEndLine" , - 1 )
                                            spec.controlledAction:addAIEventListener( self , "onAIImplementStart" , - 1 )
                                            spec.controlledAction:addAIEventListener( self , "onAIImplementPrepareForTransport" , - 1 )
                                        end
                                    end
                                end
                            end

                            SpecializationUtil.raiseEvent( self , "onPostAttach" , attacherVehicle, inputJointDescIndex, jointDescIndex, loadFromSavegame)
                        end

```

### postDetach

**Description**

**Definition**

> postDetach()

**Arguments**

| any | implementIndex |
|-----|----------------|

**Code**

```lua
function Attachable:postDetach(implementIndex)
    local spec = self.spec_attachable

    self:deactivate()

    ObjectChangeUtil.setObjectChanges(spec.attacherJoint.changeObjects, false , self , self.setMovingToolDirty)

    if spec.attacherJoint.steeringBarLeftNode ~ = nil then
        self:setMovingPartReferenceNode(spec.attacherJoint.steeringBarLeftNode, nil , false )
    end
    if spec.attacherJoint.steeringBarRightNode ~ = nil then
        self:setMovingPartReferenceNode(spec.attacherJoint.steeringBarRightNode, nil , false )
    end
    if spec.attacherJoint.drawbarNode ~ = nil then
        self:setMovingPartReferenceNode(spec.attacherJoint.drawbarNode, nil , false )
    end

    if self.playAnimation ~ = nil then
        for _, supportAnimation in ipairs(spec.supportAnimations) do
            if self:getIsSupportAnimationAllowed(supportAnimation) then
                if not supportAnimation.detachAfterAnimation then
                    self:playAnimation(supportAnimation.animationName, 1 , nil , true )
                else
                        if self:getAnimationTime(supportAnimation.animationName) < 1 then
                            self:playAnimation(supportAnimation.animationName, 1 , nil , true )
                        end
                    end
                end
            end

            if spec.lowerAnimation ~ = nil and spec.lowerAnimationDirectionOnDetach ~ = 0 then
                self:playAnimation(spec.lowerAnimation, spec.lowerAnimationDirectionOnDetach, nil , true )
            end
        end

        self:attachableRemoveToolCameras()

        for _, additionalObject in ipairs(spec.attacherJoint.additionalObjects) do
            setVisibility(additionalObject.node, false )
        end

        if spec.attacherJoint.bottomArm ~ = nil and spec.attacherJoint.bottomArm.ballsNode ~ = nil then
            setVisibility(spec.attacherJoint.bottomArm.ballsNode, spec.attacherJoint.bottomArm.ballDefaultVisibility)
        end

        spec.attacherVehicle = nil

        spec.attacherJoint = nil
        spec.attacherJointIndex = nil

        spec.inputAttacherJointDescIndex = nil

        SpecializationUtil.raiseEvent( self , "onPostDetach" )
    end

```

### preAttach

**Description**

> Called before vehicle gets attached

**Definition**

> preAttach(table attacherVehicle, integer inputAttacherJointDescIndex, boolean loadFromSavegame, )

**Arguments**

| table   | attacherVehicle             | attacher vehicle                   |
|---------|-----------------------------|------------------------------------|
| integer | inputAttacherJointDescIndex | index of input attacher joint      |
| boolean | loadFromSavegame            | attachment is loaded from savegame |
| any     | loadFromSavegame            |                                    |

**Code**

```lua
function Attachable:preAttach(attacherVehicle, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local spec = self.spec_attachable

    spec.attacherVehicle = attacherVehicle
    spec.attacherJoint = spec.inputAttacherJoints[inputJointDescIndex]
    spec.inputAttacherJointDescIndex = inputJointDescIndex

    local attacherVehicleJointDesc = attacherVehicle:getAttacherJointByJointDescIndex(jointDescIndex)

    local distanceToGroundByVehicle = spec.attacherJoint.distanceToGroundByVehicle
    if #spec.attacherJoint.distanceToGroundByVehicle > 0 then
        local useDefault = true
        for i = 1 , #distanceToGroundByVehicle do
            local vehicleData = distanceToGroundByVehicle[i]
            if string.lower(attacherVehicle.configFileName):endsWith(vehicleData.filename) then
                spec.attacherJoint.lowerDistanceToGround = vehicleData.lower
                spec.attacherJoint.upperDistanceToGround = vehicleData.upper
                useDefault = false
            end
        end

        if useDefault then
            spec.attacherJoint.lowerDistanceToGround = spec.attacherJoint.lowerDistanceToGroundOriginal
            spec.attacherJoint.upperDistanceToGround = spec.attacherJoint.upperDistanceToGroundOriginal
        end
    end

    for _, additionalObject in ipairs(spec.attacherJoint.additionalObjects) do
        setVisibility(additionalObject.node, additionalObject.attacherVehiclePath = = NetworkUtil.convertToNetworkFilename(attacherVehicle.configFileName))
    end

    if spec.attacherJoint.bottomArm ~ = nil and spec.attacherJoint.bottomArm.ballsNode ~ = nil then
        local isAllowed = true
        if attacherVehicleJointDesc.bottomArm ~ = nil then
            isAllowed = attacherVehicleJointDesc.bottomArm.ballVisibility
        end

        setVisibility(spec.attacherJoint.bottomArm.ballsNode, isAllowed)
    end

    for _, supportAnimation in ipairs(spec.supportAnimations) do
        if self:getIsSupportAnimationAllowed(supportAnimation) then
            if not supportAnimation.delayedOnAttach then
                local skipAnimation = self.propertyState = = VehiclePropertyState.SHOP_CONFIG or loadFromSavegame

                self:playAnimation(supportAnimation.animationName, - 1 , nil , true , not skipAnimation)
                if skipAnimation then
                    AnimatedVehicle.updateAnimationByName( self , supportAnimation.animationName, 9999999 , true )
                end
            end
        end
    end

    SpecializationUtil.raiseEvent( self , "onPreAttach" , attacherVehicle, inputJointDescIndex, jointDescIndex)
end

```

### preDetach

**Description**

**Definition**

> preDetach()

**Arguments**

| any | attacherVehicle |
|-----|-----------------|
| any | implement       |

**Code**

```lua
function Attachable:preDetach(attacherVehicle, implement)
    local spec = self.spec_attachable
    if spec.controlledAction ~ = nil then
        spec.controlledAction:remove()
        spec.controlledAction = nil
    end

    SpecializationUtil.raiseEvent( self , "onPreDetach" , attacherVehicle, implement)
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
function Attachable.prerequisitesPresent(specializations)
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
function Attachable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onPreInitComponentPlacement" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDelete" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateInterpolation" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onSelect" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onUnselect" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onStateChange" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onRootVehicleChanged" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onFoldStateChanged" , Attachable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterAnimationValueTypes" , Attachable )
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
function Attachable.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onPreAttach" )
    SpecializationUtil.registerEvent(vehicleType, "onPostAttach" )
    SpecializationUtil.registerEvent(vehicleType, "onPreDetach" )
    SpecializationUtil.registerEvent(vehicleType, "onPostDetach" )
    SpecializationUtil.registerEvent(vehicleType, "onSetLowered" )
    SpecializationUtil.registerEvent(vehicleType, "onSetLoweredAll" )
    SpecializationUtil.registerEvent(vehicleType, "onLeaveRootVehicle" )
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
function Attachable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadInputAttacherJoint" , Attachable.loadInputAttacherJoint)
    SpecializationUtil.registerFunction(vehicleType, "loadAttacherJointHeightNode" , Attachable.loadAttacherJointHeightNode)
    SpecializationUtil.registerFunction(vehicleType, "getIsAttacherJointHeightNodeActive" , Attachable.getIsAttacherJointHeightNodeActive)
    SpecializationUtil.registerFunction(vehicleType, "getInputAttacherJointByJointDescIndex" , Attachable.getInputAttacherJointByJointDescIndex)
    SpecializationUtil.registerFunction(vehicleType, "getInputAttacherJointIndexByNode" , Attachable.getInputAttacherJointIndexByNode)
    SpecializationUtil.registerFunction(vehicleType, "getAttacherVehicle" , Attachable.getAttacherVehicle)
    SpecializationUtil.registerFunction(vehicleType, "getShowAttachableMapHotspot" , Attachable.getShowAttachableMapHotspot)
    SpecializationUtil.registerFunction(vehicleType, "getInputAttacherJoints" , Attachable.getInputAttacherJoints)
    SpecializationUtil.registerFunction(vehicleType, "getIsAttachedTo" , Attachable.getIsAttachedTo)
    SpecializationUtil.registerFunction(vehicleType, "getActiveInputAttacherJointDescIndex" , Attachable.getActiveInputAttacherJointDescIndex)
    SpecializationUtil.registerFunction(vehicleType, "getActiveInputAttacherJoint" , Attachable.getActiveInputAttacherJoint)
    SpecializationUtil.registerFunction(vehicleType, "getAllowsLowering" , Attachable.getAllowsLowering)
    SpecializationUtil.registerFunction(vehicleType, "loadSupportAnimationFromXML" , Attachable.loadSupportAnimationFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsSupportAnimationAllowed" , Attachable.getIsSupportAnimationAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getIsReadyToFinishDetachProcess" , Attachable.getIsReadyToFinishDetachProcess)
    SpecializationUtil.registerFunction(vehicleType, "startDetachProcess" , Attachable.startDetachProcess)
    SpecializationUtil.registerFunction(vehicleType, "getIsImplementChainLowered" , Attachable.getIsImplementChainLowered)
    SpecializationUtil.registerFunction(vehicleType, "getIsInWorkPosition" , Attachable.getIsInWorkPosition)
    SpecializationUtil.registerFunction(vehicleType, "getAttachbleAirConsumerUsage" , Attachable.getAttachbleAirConsumerUsage)
    SpecializationUtil.registerFunction(vehicleType, "isDetachAllowed" , Attachable.isDetachAllowed)
    SpecializationUtil.registerFunction(vehicleType, "isAttachAllowed" , Attachable.isAttachAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getIsInputAttacherActive" , Attachable.getIsInputAttacherActive)
    SpecializationUtil.registerFunction(vehicleType, "getSteeringAxleBaseVehicle" , Attachable.getSteeringAxleBaseVehicle)
    SpecializationUtil.registerFunction(vehicleType, "loadSteeringAxleFromXML" , Attachable.loadSteeringAxleFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsSteeringAxleAllowed" , Attachable.getIsSteeringAxleAllowed)
    SpecializationUtil.registerFunction(vehicleType, "loadSteeringAngleNodeFromXML" , Attachable.loadSteeringAngleNodeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "updateSteeringAngleNode" , Attachable.updateSteeringAngleNode)
    SpecializationUtil.registerFunction(vehicleType, "attachableAddToolCameras" , Attachable.attachableAddToolCameras)
    SpecializationUtil.registerFunction(vehicleType, "attachableRemoveToolCameras" , Attachable.attachableRemoveToolCameras)
    SpecializationUtil.registerFunction(vehicleType, "preAttach" , Attachable.preAttach)
    SpecializationUtil.registerFunction(vehicleType, "postAttach" , Attachable.postAttach)
    SpecializationUtil.registerFunction(vehicleType, "preDetach" , Attachable.preDetach)
    SpecializationUtil.registerFunction(vehicleType, "postDetach" , Attachable.postDetach)
    SpecializationUtil.registerFunction(vehicleType, "setLowered" , Attachable.setLowered)
    SpecializationUtil.registerFunction(vehicleType, "setLoweredAll" , Attachable.setLoweredAll)
    SpecializationUtil.registerFunction(vehicleType, "setToolBottomArmWidthByIndex" , Attachable.setToolBottomArmWidthByIndex)
    SpecializationUtil.registerFunction(vehicleType, "updateInputAttacherJointGraphics" , Attachable.updateInputAttacherJointGraphics)
    SpecializationUtil.registerFunction(vehicleType, "setIsAdditionalAttachment" , Attachable.setIsAdditionalAttachment)
    SpecializationUtil.registerFunction(vehicleType, "getIsAdditionalAttachment" , Attachable.getIsAdditionalAttachment)
    SpecializationUtil.registerFunction(vehicleType, "setIsSupportVehicle" , Attachable.setIsSupportVehicle)
    SpecializationUtil.registerFunction(vehicleType, "getIsSupportVehicle" , Attachable.getIsSupportVehicle)
    SpecializationUtil.registerFunction(vehicleType, "registerLoweringActionEvent" , Attachable.registerLoweringActionEvent)
    SpecializationUtil.registerFunction(vehicleType, "getLoweringActionEventState" , Attachable.getLoweringActionEventState)
    SpecializationUtil.registerFunction(vehicleType, "getAllowMultipleAttachments" , Attachable.getAllowMultipleAttachments)
    SpecializationUtil.registerFunction(vehicleType, "resolveMultipleAttachments" , Attachable.resolveMultipleAttachments)
    SpecializationUtil.registerFunction(vehicleType, "getBlockFoliageDestruction" , Attachable.getBlockFoliageDestruction)
    SpecializationUtil.registerFunction(vehicleType, "setIsDetachingBlocked" , Attachable.setIsDetachingBlocked)
end

```

### registerInputAttacherJointXMLPaths

**Description**

**Definition**

> registerInputAttacherJointXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | baseName |

**Code**

```lua
function Attachable.registerInputAttacherJointXMLPaths(schema, baseName)
    schema:addDelayedRegistrationPath(baseName, "Attachable:inputAttacherJoint" )

    schema:register(XMLValueType.NODE_INDEX, baseName .. "#node" , "Joint Node" )
    schema:register(XMLValueType.NODE_INDEX, baseName .. ".heightNode(?)#node" , "Height Node" )

    schema:register(XMLValueType.STRING, baseName .. "#jointType" , "Joint type" )
    schema:register(XMLValueType.STRING, baseName .. ".subType#name" , "If defined this type needs to match with the sub type in the attacher vehicle" )
    schema:register(XMLValueType.BOOL, baseName .. ".subType#showWarning" , "Show warning if user tries to attach with a different sub type" , true )

        schema:register(XMLValueType.BOOL, baseName .. "#needsTrailerJoint" , "Needs trailer joint(only if no joint type is given)" , false )
            schema:register(XMLValueType.BOOL, baseName .. "#needsLowJoint" , "Needs low trailer joint(only if no joint type is given)" , false )

                schema:register(XMLValueType.NODE_INDEX, baseName .. "#topReferenceNode" , "Top Reference Node" )
                schema:register(XMLValueType.NODE_INDEX, baseName .. "#rootNode" , "Root node" , "Parent component of attacher joint node" )

                schema:register(XMLValueType.BOOL, baseName .. "#allowsDetaching" , "Allows detaching" , true )
                schema:register(XMLValueType.BOOL, baseName .. "#fixedRotation" , "Fixed rotation(Rot limit is freezed)" , false )
                schema:register(XMLValueType.BOOL, baseName .. "#hardAttach" , "Implement is hard attached" , false )
                schema:register(XMLValueType.TIME, baseName .. "#smoothAttachTime" , "Time until the attachment is fully attached(seconds)" , 0.5 )

                schema:register(XMLValueType.NODE_INDEX, baseName .. "#nodeVisual" , "Visual joint node" )
                schema:register(XMLValueType.FLOAT, baseName .. ".distanceToGround#lower" , "Lower distance to ground" )
                schema:register(XMLValueType.FLOAT, baseName .. ".distanceToGround#upper" , "Upper distance to ground" )
                schema:register(XMLValueType.STRING, baseName .. ".distanceToGround.vehicle(?)#filename" , "Vehicle filename to activate these distances" )
                schema:register(XMLValueType.FLOAT, baseName .. ".distanceToGround.vehicle(?)#lower" , "Lower distance to ground while attached to this vehicle" )
                    schema:register(XMLValueType.FLOAT, baseName .. ".distanceToGround.vehicle(?)#upper" , "Upper distance to ground while attached to this vehicle" )
                        schema:register(XMLValueType.ANGLE, baseName .. "#lowerRotationOffset" , "Rotation offset if lowered" )
                            schema:register(XMLValueType.ANGLE, baseName .. "#upperRotationOffset" , "Rotation offset if lifted" , "8 degrees for implements" )
                                schema:register(XMLValueType.BOOL, baseName .. "#allowsJointRotLimitMovement" , "Rotation limit is changed during lifting/lowering" , true )
                                schema:register(XMLValueType.BOOL, baseName .. "#allowsJointTransLimitMovement" , "Translation limit is changed during lifting/lowering" , true )
                                schema:register(XMLValueType.BOOL, baseName .. "#needsToolbar" , "Needs toolbar" , false )

                                schema:register(XMLValueType.VECTOR_N, baseName .. ".bottomArm#categories" , "Bottom arm categories(0-4).Defines the width of the lower links and the ball size.Can be multiple categories separated by a whitespace if the tool support more than one." )
                                    schema:register(XMLValueType.VECTOR_N, baseName .. ".bottomArm#widths" , "Manual definition of the available lower link widths.Overwrites the category definition.Multiple width values separated by a whitespace." )
                                    schema:register(XMLValueType.INT, baseName .. ".bottomArm#ballType" , "Ball type to load(1:regular ball, 2:ball with guide cone)" , 1 )
                                    schema:register(XMLValueType.STRING, baseName .. ".bottomArm#ballFilename" , "Path to custom ball i3d file to use" )
                                    schema:register(XMLValueType.BOOL, baseName .. ".bottomArm#ballDefaultVisibility" , "Defines if the balls are also visible while the tool is not attached" , "'true' if no toolbar is used('needsToolbar' attribute)" )

                                        schema:register(XMLValueType.NODE_INDEX, baseName .. "#steeringBarLeftNode" , "Left steering bar node(Node of movingPart that should point towards the steeringBar left node of the tractor)" )
                                        schema:register(XMLValueType.NODE_INDEX, baseName .. "#steeringBarRightNode" , "Right steering bar node(Node of movingPart that should point towards the steeringBar right node of the tractor)" )
                                        schema:register(XMLValueType.NODE_INDEX, baseName .. "#drawbarNode" , "Drawbar node(Node of movingPart that should point towards the attacherJoint node of the tractor)" )

                                        schema:register(XMLValueType.NODE_INDEX, baseName .. "#bottomArmLeftNode" , "Left bottom arm node(Node can be used as movingTool target from the tractor)" )
                                        schema:register(XMLValueType.NODE_INDEX, baseName .. "#bottomArmRightNode" , "Right bottom arm node(Node can be used as movingTool target from the tractor)" )

                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#upperRotLimitScale" , "Upper rot limit scale" , "0 0 0" )
                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#lowerRotLimitScale" , "Lower rot limit scale" , "0 0 0" )
                                        schema:register(XMLValueType.FLOAT, baseName .. "#rotLimitThreshold" , "Defines when the transition from upper to lower rot limit starts(0:directly, 0.9:after 90% of lowering)" , 0 )

                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#upperTransLimitScale" , "Upper trans limit scale" , "0 0 0" )
                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#lowerTransLimitScale" , "Lower trans limit scale" , "0 0 0" )
                                        schema:register(XMLValueType.FLOAT, baseName .. "#transLimitThreshold" , "Defines when the transition from upper to lower trans limit starts(0:directly, 0.9:after 90% of lowering)" , 0 )

                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#rotLimitSpring" , "Rotation limit spring" , "0 0 0" )
                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#rotLimitDamping" , "Rotation limit damping" , "1 1 1" )
                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#rotLimitForceLimit" , "Rotation limit force limit" , "-1 -1 -1" )

                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#transLimitSpring" , "Translation limit spring" , "0 0 0" )
                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#transLimitDamping" , "Translation limit damping" , "1 1 1" )
                                        schema:register(XMLValueType.VECTOR_ 3 , baseName .. "#transLimitForceLimit" , "Translation limit force limit" , "-1 -1 -1" )

                                        schema:register(XMLValueType.INT, baseName .. "#attachAngleLimitAxis" , "Direction axis which is used to calculate angle to enable attach" , 1 )

                                        schema:register(XMLValueType.FLOAT, baseName .. "#attacherHeight" , "Height of attacher" , "0.9 for trailer, 0.55 for trailer low" )

                                            schema:register(XMLValueType.BOOL, baseName .. "#needsLowering" , "Needs lowering" )
                                            schema:register(XMLValueType.BOOL, baseName .. "#allowsLowering" , "Allows lowering" )
                                            schema:register(XMLValueType.BOOL, baseName .. "#isDefaultLowered" , "Is default lowered" , false )
                                            schema:register(XMLValueType.BOOL, baseName .. "#useFoldingLoweredState" , "Use folding lowered state" , false )
                                            schema:register(XMLValueType.BOOL, baseName .. "#forceSelectionOnAttach" , "Is selected on attach" , true )
                                            schema:register(XMLValueType.BOOL, baseName .. "#forceAllowDetachWhileLifted" , "Attacher vehicle can be always detached no matter if we are lifted or not" , false )
                                                schema:register(XMLValueType.INT, baseName .. "#forcedAttachingDirection" , "Tool can be only attached in this direction" , 0 )
                                                schema:register(XMLValueType.BOOL, baseName .. "#allowFolding" , "Folding is allowed while attached to this attacher joint" , true )
                                                    schema:register(XMLValueType.BOOL, baseName .. "#allowTurnOn" , "Turn on is allowed while attached to this attacher joint" , true )
                                                        schema:register(XMLValueType.BOOL, baseName .. "#allowAI" , "Toggling of AI is allowed while attached to this attacher joint" , true )
                                                            schema:register(XMLValueType.BOOL, baseName .. "#allowDetachWhileParentLifted" , "If set to false the parent vehicle needs to be lowered to be able to detach this implement" , true )
                                                            schema:register(XMLValueType.BOOL, baseName .. "#useTopLights" , "Defines if the tool attached to this attacher activates to automatic switch to the top lights" , true )

                                                                schema:register(XMLValueType.INT, baseName .. ".dependentAttacherJoint(?)#attacherJointIndex" , "Dependent attacher joint index" )

                                                                schema:register(XMLValueType.NODE_INDEX, baseName .. ".additionalObjects.additionalObject(?)#node" , "Additional object node" )
                                                                schema:register(XMLValueType.STRING, baseName .. ".additionalObjects.additionalObject(?)#attacherVehiclePath" , "Path to vehicle for object activation" )

                                                                    schema:register(XMLValueType.STRING, baseName .. ".additionalAttachment#filename" , "Path to additional attachment" )
                                                                    schema:register(XMLValueType.INT, baseName .. ".additionalAttachment#inputAttacherJointIndex" , "Input attacher joint index of additional attachment" )
                                                                    schema:register(XMLValueType.BOOL, baseName .. ".additionalAttachment#needsLowering" , "Additional implements needs lowering" )
                                                                    schema:register(XMLValueType.STRING, baseName .. ".additionalAttachment#jointType" , "Additional implement joint type" )
                                                                end

```

### registerLoweringActionEvent

**Description**

**Definition**

> registerLoweringActionEvent()

**Arguments**

| any | actionEventsTable |
|-----|-------------------|
| any | inputAction       |
| any | target            |
| any | callback          |
| any | triggerUp         |
| any | triggerDown       |
| any | triggerAlways     |
| any | startActive       |
| any | callbackState     |
| any | customIconName    |

**Code**

```lua
function Attachable:registerLoweringActionEvent(actionEventsTable, inputAction, target, callback, triggerUp, triggerDown, triggerAlways, startActive, callbackState, customIconName)
    return self:addPoweredActionEvent(actionEventsTable, inputAction, target, callback, triggerUp, triggerDown, triggerAlways, startActive, callbackState, customIconName)
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
function Attachable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "findRootVehicle" , Attachable.findRootVehicle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsActive" , Attachable.getIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsOperating" , Attachable.getIsOperating)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getBrakeForce" , Attachable.getBrakeForce)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , Attachable.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleTurnedOn" , Attachable.getCanToggleTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanImplementBeUsedForAI" , Attachable.getCanImplementBeUsedForAI)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanAIImplementContinueWork" , Attachable.getCanAIImplementContinueWork)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAreControlledActionsAllowed" , Attachable.getAreControlledActionsAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDeactivateOnLeave" , Attachable.getDeactivateOnLeave)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getActiveFarm" , Attachable.getActiveFarm)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Attachable.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsLowered" , Attachable.getIsLowered)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "mountDynamic" , Attachable.mountDynamic)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getOwnerConnection" , Attachable.getOwnerConnection)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsInUse" , Attachable.getIsInUse)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getUpdatePriority" , Attachable.getUpdatePriority)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeReset" , Attachable.getCanBeReset)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadAdditionalLightAttributesFromXML" , Attachable.loadAdditionalLightAttributesFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsLightActive" , Attachable.getIsLightActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsPowered" , Attachable.getIsPowered)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConnectionHoseConfigIndex" , Attachable.getConnectionHoseConfigIndex)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMapHotspotVisible" , Attachable.getIsMapHotspotVisible)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getPowerTakeOffConfigIndex" , Attachable.getPowerTakeOffConfigIndex)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadDashboardGroupFromXML" , Attachable.loadDashboardGroupFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsDashboardGroupActive" , Attachable.getIsDashboardGroupActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setWorldPositionQuaternion" , Attachable.setWorldPositionQuaternion)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , Attachable.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , Attachable.removeFromPhysics)
end

```

### registerSupportXMLPaths

**Description**

**Definition**

> registerSupportXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function Attachable.registerSupportXMLPaths(schema, key)
    schema:addDelayedRegistrationPath(key, "Attachable:support" )

    schema:register(XMLValueType.STRING, key .. "#animationName" , "Animation name" )
    schema:register(XMLValueType.BOOL, key .. "#delayedOnLoad" , "Defines if the animation is played onPostLoad or onPreInitComponentPlacement -> useful if the animation collides e.g.with the folding animation" , false )
        schema:register(XMLValueType.BOOL, key .. "#delayedOnAttach" , "Defines if the animation is played before or after the attaching process" , true )
            schema:register(XMLValueType.BOOL, key .. "#detachAfterAnimation" , "Defines if the vehicle is detached after the animation has played" , true )
                schema:register(XMLValueType.FLOAT, key .. "#detachAnimationTime" , "Defines when in the support animation the vehicle is detached(detachAfterAnimation needs to be true)" , 1 )
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
function Attachable:removeFromPhysics(superFunc)
    local spec = self.spec_attachable

    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil and attacherVehicle.isAddedToPhysics then
        local implement = attacherVehicle:getImplementByObject( self )
        if implement ~ = nil then
            if not spec.isHardAttached then
                local jointDesc = attacherVehicle.spec_attacherJoints.attacherJoints[implement.jointDescIndex]
                if jointDesc.jointIndex ~ = 0 then
                    jointDesc.jointIndex = 0
                end
            end
        end
    end

    return superFunc( self )
end

```

### resolveMultipleAttachments

**Description**

> Function that is called before attaching a attachable to second vehicle

**Definition**

> resolveMultipleAttachments()

**Code**

```lua
function Attachable:resolveMultipleAttachments()
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
function Attachable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_attachable
    if spec.lowerAnimation ~ = nil and self.playAnimation ~ = nil then
        local lowerAnimTime = self:getAnimationTime(spec.lowerAnimation)
        xmlFile:setValue(key .. "#lowerAnimTime" , lowerAnimTime)
    end

    xmlFile:setValue(key .. "#isDetachingBlocked" , Utils.getNoNil(spec.isDetachingBlocked, false ))
end

```

### setIsAdditionalAttachment

**Description**

> Sets if vehicle is a additional attachment -> can not be detached or lowered

**Definition**

> setIsAdditionalAttachment()

**Arguments**

| any | needsLowering |
|-----|---------------|
| any | vehicleLoaded |

**Code**

```lua
function Attachable:setIsAdditionalAttachment(needsLowering, vehicleLoaded)
    local spec = self.spec_attachable
    spec.isAdditionalAttachment = true
    spec.additionalAttachmentNeedsLowering = needsLowering

    if vehicleLoaded then
        self:requestActionEventUpdate()

        if not needsLowering then
            if spec.controlledAction ~ = nil then
                spec.controlledAction:remove()
            end
        end
    end
end

```

### setIsSupportVehicle

**Description**

> Sets if vehicle is a additional attachment -> can not be detached or lowered

**Definition**

> setIsSupportVehicle()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function Attachable:setIsSupportVehicle(state)
    local spec = self.spec_attachable
    if state = = nil then
        state = true
    end

    spec.isSupportVehicle = state
end

```

### setLowered

**Description**

> Set attachables lowering state

**Definition**

> setLowered(boolean lowered)

**Arguments**

| boolean | lowered | attachable is lowered |
|---------|---------|-----------------------|

**Code**

```lua
function Attachable:setLowered(lowered)
    local spec = self.spec_attachable

    if spec.lowerAnimation ~ = nil and self.playAnimation ~ = nil then
        local animationTime = self:getAnimationTime(spec.lowerAnimation)
        if lowered and animationTime < 1 then
            self:playAnimation(spec.lowerAnimation, spec.lowerAnimationSpeed, animationTime, true )
        elseif not lowered and animationTime > 0 then
                self:playAnimation(spec.lowerAnimation, - spec.lowerAnimationSpeed, animationTime, true )
            end
        end

        if spec.attacherJoint ~ = nil then
            for _, dependentAttacherJointIndex in pairs(spec.attacherJoint.dependentAttacherJoints) do
                if self.getAttacherJoints ~ = nil then
                    local attacherJoints = self:getAttacherJoints()
                    if attacherJoints[dependentAttacherJointIndex] ~ = nil then
                        self:setJointMoveDown(dependentAttacherJointIndex, lowered, true )
                    else
                            Logging.xmlWarning( self.xmlFile, "Failed to lower dependent attacher joint index '%d', No attacher joint defined!" , dependentAttacherJointIndex)
                        end
                    else
                            Logging.xmlWarning( self.xmlFile, "Failed to lower dependent attacher joint index '%d', AttacherJoint specialization is missing!" , dependentAttacherJointIndex)
                        end
                    end
                end

                SpecializationUtil.raiseEvent( self , "onSetLowered" , lowered)
            end

```

### setLoweredAll

**Description**

> Set attachables lowering all state

**Definition**

> setLoweredAll(boolean doLowering, )

**Arguments**

| boolean | doLowering     | do lowering |
|---------|----------------|-------------|
| any     | jointDescIndex |             |

**Code**

```lua
function Attachable:setLoweredAll(doLowering, jointDescIndex)
    self:getAttacherVehicle():handleLowerImplementByAttacherJointIndex(jointDescIndex, doLowering)

    SpecializationUtil.raiseEvent( self , "onSetLoweredAll" , doLowering, jointDescIndex)
end

```

### setToolBottomArmWidthByIndex

**Description**

> Sets the bottom arm width that should be used for attaching

**Definition**

> setToolBottomArmWidthByIndex(integer inputAttacherJointIndex, integer widthIndex)

**Arguments**

| integer | inputAttacherJointIndex | index of input attacher joint |
|---------|-------------------------|-------------------------------|
| integer | widthIndex              | index of width setting        |

**Code**

```lua
function Attachable:setToolBottomArmWidthByIndex(inputAttacherJointIndex, widthIndex)
    local inputAttacherJoint = self:getInputAttacherJointByJointDescIndex(inputAttacherJointIndex)
    if inputAttacherJoint ~ = nil and inputAttacherJoint.bottomArm ~ = nil then
        if inputAttacherJoint.bottomArm.ballsNodeLeft ~ = nil then
            local width = inputAttacherJoint.bottomArm.widths[widthIndex] or 0.5
            setTranslation(inputAttacherJoint.bottomArm.ballsNodeLeft, width * 0.5 , 0 , 0 )
            setTranslation(inputAttacherJoint.bottomArm.ballsNodeRight, - width * 0.5 , 0 , 0 )

            local nearestCategory = AttacherJoints.getClosestLowerLinkCategoryIndex(width)
            local ballSize = AttacherJoints.LOWER_LINK_BALL_SIZE_BY_CATEGORY[nearestCategory] or 0.056
            -- TODO apply the ball size to the mesh when we have support to scale skinned joints
        end
    end
end

```

### setWorldPositionQuaternion

**Description**

> Set world position and quaternion rotation of component

**Definition**

> setWorldPositionQuaternion(float x, float y, float z, float qx, float qy, float qz, float qw, integer i, boolean
> changeInterp, )

**Arguments**

| float   | x            | x position           |
|---------|--------------|----------------------|
| float   | y            | y position           |
| float   | z            | z position           |
| float   | qx           | x rotation           |
| float   | qy           | y rotation           |
| float   | qz           | z rotation           |
| float   | qw           | w rotation           |
| integer | i            | index if component   |
| boolean | changeInterp | change interpolation |
| any     | changeInterp |                      |

**Code**

```lua
function Attachable:setWorldPositionQuaternion(superFunc, x, y, z, qx, qy, qz, qw, i, changeInterp)
    if not self.isServer then
        -- while the object is hard attached and linked to the attacher vehicles
            -- received positions are not applied since the position is dependent on the attacher vehicle
            if not self.spec_attachable.isHardAttached then
                return superFunc( self , x, y, z, qx, qy, qz, qw, i, changeInterp)
            end

            return
        end

        return superFunc( self , x, y, z, qx, qy, qz, qw, i, changeInterp)
    end

```

### startDetachProcess

**Description**

> Detaches the vehicle if no support animation has 'detachAfterAnimation' set or start the support animation and
> detaches the implement afterwards

**Definition**

> startDetachProcess()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function Attachable:startDetachProcess(noEventSend)
    AttachableStartDetachEvent.sendEvent( self , noEventSend)
    local spec = self.spec_attachable
    for i = 1 , #spec.supportAnimations do
        if spec.supportAnimations[i].detachAfterAnimation then
            if self:getIsSupportAnimationAllowed(spec.supportAnimations[i]) then
                self:playAnimation(spec.supportAnimations[i].animationName, 1 , nil , true )
            end
        end
    end

    if self.isServer then
        if self:getIsReadyToFinishDetachProcess() then
            spec.detachingInProgress = false
            local attacherVehicle = self:getAttacherVehicle()
            if attacherVehicle ~ = nil then
                attacherVehicle:detachImplementByObject( self )
            end
            return true
        else
                spec.detachingInProgress = true
                return false
            end
        else
                if self:getIsReadyToFinishDetachProcess() then
                    return true
                else
                        return false
                    end
                end
            end

```

### updateInputAttacherJointGraphics

**Description**

**Definition**

> updateInputAttacherJointGraphics()

**Arguments**

| any | implement |
|-----|-----------|
| any | dt        |

**Code**

```lua
function Attachable:updateInputAttacherJointGraphics(implement, dt)
    if not implement.attachingIsInProgress then
        local attacherJoint = self:getAttacherVehicle():getAttacherJointByJointDescIndex(implement.jointDescIndex)
        local inputAttacherJoint = self:getInputAttacherJointByJointDescIndex(implement.inputJointDescIndex)
        if inputAttacherJoint ~ = nil then
            if inputAttacherJoint.steeringBarLeftNode ~ = nil and attacherJoint.steeringBarLeftNode ~ = nil then
                self:updateMovingPartByNode(inputAttacherJoint.steeringBarLeftNode, dt)
            end
            if inputAttacherJoint.steeringBarRightNode ~ = nil and attacherJoint.steeringBarRightNode ~ = nil then
                self:updateMovingPartByNode(inputAttacherJoint.steeringBarRightNode, dt)
            end
            if inputAttacherJoint.drawbarNode ~ = nil then
                self:updateMovingPartByNode(inputAttacherJoint.drawbarNode, dt)
            end
        end
    end
end

```

### updateSteeringAngleNode

**Description**

> Update steering angle nodes

**Definition**

> updateSteeringAngleNode()

**Arguments**

| any | steeringAngleNode |
|-----|-------------------|
| any | angle             |
| any | dt                |

**Code**

```lua
function Attachable:updateSteeringAngleNode(steeringAngleNode, angle, dt)
    if self.lastSpeed * 3600 > steeringAngleNode.minSpeed then
        local direction = math.sign(angle - steeringAngleNode.currentAngle)
        local limit = direction < 0 and math.max or math.min
        local newAngle = limit(steeringAngleNode.currentAngle + steeringAngleNode.speed * dt * direction, angle)
        if newAngle ~ = steeringAngleNode.currentAngle then
            steeringAngleNode.currentAngle = newAngle
            setRotation(steeringAngleNode.node, 0 , steeringAngleNode.offset + steeringAngleNode.currentAngle * steeringAngleNode.scale, 0 )

            if self.setMovingToolDirty ~ = nil then
                self:setMovingToolDirty(steeringAngleNode.node)
            end
        end
    end
end

```