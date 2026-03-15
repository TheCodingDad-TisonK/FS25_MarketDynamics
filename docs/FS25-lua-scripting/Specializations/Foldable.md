## Foldable

**Description**

> Specialization for vehicle parts with two or three folding states (e.g. tedder, cultivator, sowing machine)

**Functions**

- [actionControllerFoldEvent](#actioncontrollerfoldevent)
- [actionControllerLowerEvent](#actioncontrollerlowerevent)
- [actionControllerLowerEventAIStart](#actioncontrollerlowereventaistart)
- [actionEventFold](#actioneventfold)
- [actionEventFoldAll](#actioneventfoldall)
- [actionEventFoldMiddle](#actioneventfoldmiddle)
- [allowLoadMovingToolStates](#allowloadmovingtoolstates)
- [externalActionEventRegister](#externalactioneventregister)
- [externalActionEventUpdate](#externalactioneventupdate)
- [getAllowDynamicMountObjects](#getallowdynamicmountobjects)
- [getAllowsLowering](#getallowslowering)
- [getBrakeForce](#getbrakeforce)
- [getCanAIImplementContinueWork](#getcanaiimplementcontinuework)
- [getCanBeSelected](#getcanbeselected)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getCanChangePickupState](#getcanchangepickupstate)
- [getCanToggleCrabSteering](#getcantogglecrabsteering)
- [getCrabSteeringModeAvailable](#getcrabsteeringmodeavailable)
- [getCraneShovelStateChangedAllowed](#getcraneshovelstatechangedallowed)
- [getCutterTiltIsActive](#getcuttertiltisactive)
- [getFillUnitSupportsToolType](#getfillunitsupportstooltype)
- [getFoldAnimTime](#getfoldanimtime)
- [getIsAdditionalCharacterActive](#getisadditionalcharacteractive)
- [getIsAIPreparingToDrive](#getisaipreparingtodrive)
- [getIsAIReadyToDrive](#getisaireadytodrive)
- [getIsAttacherJointHeightNodeActive](#getisattacherjointheightnodeactive)
- [getIsFoldActionAllowed](#getisfoldactionallowed)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsFoldMiddleAllowed](#getisfoldmiddleallowed)
- [getIsGroundAdjustedNodeActive](#getisgroundadjustednodeactive)
- [getIsInputAttacherActive](#getisinputattacheractive)
- [getIsInWorkPosition](#getisinworkposition)
- [getIsLevelerPickupNodeActive](#getislevelerpickupnodeactive)
- [getIsLowered](#getislowered)
- [getIsMovingPartActive](#getismovingpartactive)
- [getIsMovingToolActive](#getismovingtoolactive)
- [getIsNextCoverStateAllowed](#getisnextcoverstateallowed)
- [getIsNextCoverStateAllowedWarning](#getisnextcoverstateallowedwarning)
- [getIsPreprunerNodeActive](#getispreprunernodeactive)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsSprayTypeActive](#getisspraytypeactive)
- [getIsSteeringAxleAllowed](#getissteeringaxleallowed)
- [getIsSupportAnimationAllowed](#getissupportanimationallowed)
- [getIsSuspensionNodeActive](#getissuspensionnodeactive)
- [getIsTurnedOnAnimationActive](#getisturnedonanimationactive)
- [getIsUnfolded](#getisunfolded)
- [getIsVehicleControlAllowed](#getisvehiclecontrolallowed)
- [getIsVersatileYRotActive](#getisversatileyrotactive)
- [getIsWheelChockAllowed](#getiswheelchockallowed)
- [getIsWoodHarvesterTiltStateAllowed](#getiswoodharvestertiltstateallowed)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getRequiresPower](#getrequirespower)
- [getShovelNodeIsActive](#getshovelnodeisactive)
- [getSlopeCompensationAngleScale](#getslopecompensationanglescale)
- [getToggledFoldDirection](#gettoggledfolddirection)
- [getToggledFoldMiddleDirection](#gettoggledfoldmiddledirection)
- [getTurnedOnNotAllowedWarning](#getturnedonnotallowedwarning)
- [initSpecialization](#initspecialization)
- [isAttachAllowed](#isattachallowed)
- [isDetachAllowed](#isdetachallowed)
- [loadAdditionalCharacterFromXML](#loadadditionalcharacterfromxml)
- [loadAttacherJointHeightNode](#loadattacherjointheightnode)
- [loadCrabSteeringModeFromXML](#loadcrabsteeringmodefromxml)
- [loadCraneShovelFromXML](#loadcraneshovelfromxml)
- [loadCutterTiltFromXML](#loadcuttertiltfromxml)
- [loadFillUnitFromXML](#loadfillunitfromxml)
- [loadFoldingPartFromXML](#loadfoldingpartfromxml)
- [loadGroundAdjustedNodeFromXML](#loadgroundadjustednodefromxml)
- [loadGroundReferenceNode](#loadgroundreferencenode)
- [loadInputAttacherJoint](#loadinputattacherjoint)
- [loadLevelerNodeFromXML](#loadlevelernodefromxml)
- [loadMovingPartFromXML](#loadmovingpartfromxml)
- [loadMovingToolFromXML](#loadmovingtoolfromxml)
- [loadPickupFromXML](#loadpickupfromxml)
- [loadPreprunerNodeFromXML](#loadpreprunernodefromxml)
- [loadShovelNode](#loadshovelnode)
- [loadSlopeCompensationNodeFromXML](#loadslopecompensationnodefromxml)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [loadSprayTypeFromXML](#loadspraytypefromxml)
- [loadSteeringAngleNodeFromXML](#loadsteeringanglenodefromxml)
- [loadSteeringAxleFromXML](#loadsteeringaxlefromxml)
- [loadSupportAnimationFromXML](#loadsupportanimationfromxml)
- [loadSuspensionNodeFromXML](#loadsuspensionnodefromxml)
- [loadTurnedOnAnimationFromXML](#loadturnedonanimationfromxml)
- [loadWheelFromXML](#loadwheelfromxml)
- [loadWoodHarvesterHeaderTiltFromXML](#loadwoodharvesterheadertiltfromxml)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onDeactivate](#ondeactivate)
- [onDynamicMountTypeChanged](#ondynamicmounttypechanged)
- [onLoad](#onload)
- [onLoadWheelChockFromXML](#onloadwheelchockfromxml)
- [onPostAttach](#onpostattach)
- [onPostLoad](#onpostload)
- [onPreAttachImplement](#onpreattachimplement)
- [onPreDetach](#onpredetach)
- [onPreDetachImplement](#onpredetachimplement)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegistered](#onregistered)
- [onRegisterExternalActionEvents](#onregisterexternalactionevents)
- [onRootVehicleChanged](#onrootvehiclechanged)
- [onSetLoweredAll](#onsetloweredall)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFoldingXMLPaths](#registerfoldingxmlpaths)
- [registerFunctions](#registerfunctions)
- [registerLoweringActionEvent](#registerloweringactionevent)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSelfLoweringActionEvent](#registerselfloweringactionevent)
- [saveToXMLFile](#savetoxmlfile)
- [setAnimTime](#setanimtime)
- [setFoldDirection](#setfolddirection)
- [setFoldMiddleState](#setfoldmiddlestate)
- [setFoldState](#setfoldstate)
- [setIsFoldActionAllowed](#setisfoldactionallowed)
- [updateActionEventFold](#updateactioneventfold)
- [updateActionEventFoldMiddle](#updateactioneventfoldmiddle)
- [updateGroundReferenceNode](#updategroundreferencenode)
- [updateSteeringAngleNode](#updatesteeringanglenode)

### actionControllerFoldEvent

**Description**

**Definition**

> actionControllerFoldEvent()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function Foldable:actionControllerFoldEvent(direction)
    local spec = self.spec_foldable

    if spec.hasFoldingParts then
        if self:getIsFoldMiddleAllowed() then
            if spec.foldAnimTime > 0 and spec.foldAnimTime < spec.foldMiddleAnimTime then
                return false
            end
        end

        direction = spec.turnOnFoldDirection * direction
        if self:getIsFoldAllowed(direction, false ) then
            if direction = = spec.turnOnFoldDirection then
                if (direction < 0 and spec.foldAnimTime > 0 ) or(direction > 0 and spec.foldAnimTime < 1 ) then
                    self:setFoldState(direction, true )
                end
            else
                    if (direction < 0 and spec.foldAnimTime > 0 ) or(direction > 0 and spec.foldAnimTime < 1 ) then
                        self:setFoldState(direction, false )
                    end
                end

                return true
            end
        end

        return false
    end

```

### actionControllerLowerEvent

**Description**

**Definition**

> actionControllerLowerEvent()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function Foldable:actionControllerLowerEvent(direction)
    local spec = self.spec_foldable
    if spec.hasFoldingParts then
        direction = spec.turnOnFoldDirection * direction
        if self:getIsFoldMiddleAllowed() then
            if direction = = spec.turnOnFoldDirection then
                self:setFoldState(direction, false )
            else
                    -- move to fold middle position, no matter where we are
                    if spec.foldMiddleDirection > 0 then
                        if spec.foldAnimTime > spec.foldMiddleAnimTime then
                            self:setFoldState( - direction, true )
                        else
                                self:setFoldState(direction, true )
                            end
                        else
                                if spec.foldAnimTime < spec.foldMiddleAnimTime then
                                    self:setFoldState( - direction, true )
                                else
                                        self:setFoldState(direction, true )
                                    end
                                end
                            end

                            return true
                        end
                    end

                    return false
                end

```

### actionControllerLowerEventAIStart

**Description**

**Definition**

> actionControllerLowerEventAIStart()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function Foldable:actionControllerLowerEventAIStart(direction)
    local spec = self.spec_foldable
    if spec.hasFoldingParts then
        direction = spec.turnOnFoldDirection * direction
        if self:getIsFoldMiddleAllowed() then
            if spec.foldAnimTime > = spec.foldMiddleAnimTime then
                return true
            end

            -- move to fold middle position, no matter where we are
            if spec.foldMiddleDirection > 0 then
                if spec.foldAnimTime > spec.foldMiddleAnimTime then
                    self:setFoldState( - direction, true )
                else
                        self:setFoldState(direction, true )
                    end
                else
                        if spec.foldAnimTime < spec.foldMiddleAnimTime then
                            self:setFoldState( - direction, true )
                        else
                                self:setFoldState(direction, true )
                            end
                        end
                    end
                end

                return true
            end

```

### actionEventFold

**Description**

**Definition**

> actionEventFold()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Foldable.actionEventFold( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_foldable

    if spec.hasFoldingParts then
        local toggleDirection = self:getToggledFoldDirection()
        local allowed, warning = self:getIsFoldAllowed(toggleDirection, false )
        if allowed then
            if toggleDirection = = spec.turnOnFoldDirection then
                self:setFoldState(toggleDirection, true )
            else
                    self:setFoldState(toggleDirection, false )

                    -- while using folding and the tool is still lowered
                        -- so we need to lift up the attacher joint as well
                        if self:getIsFoldMiddleAllowed() then
                            if self.getAttacherVehicle ~ = nil then
                                local attacherVehicle = self:getAttacherVehicle()
                                local attacherJointIndex = attacherVehicle:getAttacherJointIndexFromObject( self )
                                if attacherJointIndex ~ = nil then
                                    local moveDown = attacherVehicle:getJointMoveDown(attacherJointIndex)
                                    local targetMoveDown = toggleDirection = = spec.turnOnFoldDirection
                                    if targetMoveDown ~ = moveDown then
                                        attacherVehicle:setJointMoveDown(attacherJointIndex, targetMoveDown)
                                    end
                                end
                            end
                        end
                    end
                elseif warning ~ = nil then
                        g_currentMission:showBlinkingWarning(warning, 2000 )
                    end
                end
            end

```

### actionEventFoldAll

**Description**

**Definition**

> actionEventFoldAll()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Foldable.actionEventFoldAll( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_foldable

    if spec.hasFoldingParts then
        local displayWarning = true
        local warningToDisplay = nil
        local toggleDirection = self:getToggledFoldDirection()
        local allowed, warning = self:getIsFoldAllowed(toggleDirection, false )
        if allowed then
            if toggleDirection = = spec.turnOnFoldDirection then
                self:setFoldState(toggleDirection, true )
            else
                    self:setFoldState(toggleDirection, false )
                end
                displayWarning = false
            elseif warning ~ = nil then
                    warningToDisplay = warning
                end

                local vehicles = self.rootVehicle:getChildVehicles()
                for i = 1 , #vehicles do
                    local vehicle = vehicles[i]
                    if vehicle.setFoldState ~ = nil then
                        local spec2 = vehicle.spec_foldable
                        if #spec2.foldingParts > 0 then
                            local toggleDirection2 = vehicle:getToggledFoldDirection()
                            local allowed2, warning2 = vehicle:getIsFoldAllowed(toggleDirection, false )
                            if allowed2 then
                                if (toggleDirection = = spec.turnOnFoldDirection) = = (toggleDirection2 = = spec2.turnOnFoldDirection) then
                                    if toggleDirection2 = = spec2.turnOnFoldDirection then
                                        vehicle:setFoldState(toggleDirection2, true )
                                    else
                                            vehicle:setFoldState(toggleDirection2, false )
                                        end
                                        displayWarning = false
                                    end
                                elseif warning2 ~ = nil then
                                        warningToDisplay = warning2
                                    end
                                end
                            end
                        end

                        if displayWarning and warningToDisplay ~ = nil then
                            g_currentMission:showBlinkingWarning(warningToDisplay, 2000 )
                        end
                    end
                end

```

### actionEventFoldMiddle

**Description**

**Definition**

> actionEventFoldMiddle()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Foldable.actionEventFoldMiddle( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_foldable

    if spec.hasFoldingParts then
        if self:getIsFoldMiddleAllowed() then
            local ignoreFoldMiddle = false
            if spec.ignoreFoldMiddleWhileFolded then
                if self:getFoldAnimTime() > spec.foldMiddleAnimTime then
                    ignoreFoldMiddle = true
                end
            end

            if not ignoreFoldMiddle then
                local direction = self:getToggledFoldMiddleDirection()
                if direction ~ = 0 then
                    if direction = = spec.turnOnFoldDirection then
                        self:setFoldState(direction, false )
                    else
                            self:setFoldState(direction, true )
                        end

                        -- equalize moveDown state of the attacher joint with the inverse fold middle state
                        -- before we execute setJointMoveDown with the AttacherJoints.actionEventLowerImplement below
                        -- so the fold middle state and the joint move down state are always in line
                        if self.getAttacherVehicle ~ = nil then
                            local attacherVehicle = self:getAttacherVehicle()
                            local attacherJointIndex = attacherVehicle:getAttacherJointIndexFromObject( self )
                            if attacherJointIndex ~ = nil then
                                local moveDown = attacherVehicle:getJointMoveDown(attacherJointIndex)
                                local targetMoveDown = direction = = spec.turnOnFoldDirection
                                if targetMoveDown ~ = moveDown then
                                    attacherVehicle:setJointMoveDown(attacherJointIndex, targetMoveDown)
                                end
                            end
                        end
                    end
                elseif self.getAttacherVehicle ~ = nil then
                        local attacherVehicle = self:getAttacherVehicle()
                        if attacherVehicle ~ = nil then
                            attacherVehicle:handleLowerImplementEvent( self )
                        end
                    end
                end
            end
        end

```

### allowLoadMovingToolStates

**Description**

**Definition**

> allowLoadMovingToolStates()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:allowLoadMovingToolStates(superFunc)
    local spec = self.spec_foldable

    if spec.foldAnimTime > spec.loadMovingToolStatesMaxLimit or spec.foldAnimTime < spec.loadMovingToolStatesMinLimit then
        return false
    end

    return superFunc( self )
end

```

### externalActionEventRegister

**Description**

**Definition**

> externalActionEventRegister()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Foldable.externalActionEventRegister(data, vehicle)
    local spec = vehicle.spec_foldable

    local function actionEvent(_, actionName, inputValue, callbackState, isAnalog)
        Motorized.tryStartMotor(vehicle)

        if spec.requiresPower then
            local isPowered, warning = vehicle:getIsPowered()
            if isPowered then
                Foldable.actionEventFold(vehicle, actionName, inputValue, callbackState, isAnalog)
            else
                    if inputValue ~ = 0 and warning ~ = nil then
                        g_currentMission:showBlinkingWarning(warning, 2000 )
                    end
                end
            else
                    Foldable.actionEventFold(vehicle, actionName, inputValue, callbackState, isAnalog)
                end
            end

            local _
            _, data.actionEventId = g_inputBinding:registerActionEvent(spec.foldInputButton, data, actionEvent, false , true , false , true )
            g_inputBinding:setActionEventTextPriority(data.actionEventId, GS_PRIO_HIGH)
        end

```

### externalActionEventUpdate

**Description**

**Definition**

> externalActionEventUpdate()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Foldable.externalActionEventUpdate(data, vehicle)
    local spec = vehicle.spec_foldable

    if data.actionEventId ~ = nil then
        local text
        if vehicle:getToggledFoldDirection() = = spec.turnOnFoldDirection then
            text = spec.negDirectionText
        else
                text = spec.posDirectionText
            end
            g_inputBinding:setActionEventText(data.actionEventId, text)
        end
    end

```

### getAllowDynamicMountObjects

**Description**

**Definition**

> getAllowDynamicMountObjects()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getAllowDynamicMountObjects(superFunc)
    local spec = self.spec_foldable
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < spec.dynamicMountMinLimit or foldAnimTime > spec.dynamicMountMaxLimit then
        return false
    end

    return superFunc( self )
end

```

### getAllowsLowering

**Description**

> Returns true if tool can be lowered

**Definition**

> getAllowsLowering()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | detachAllowed | detach is allowed                  |
|-----|---------------|------------------------------------|
| any | warning       | [optional] warning text to display |

**Code**

```lua
function Foldable:getAllowsLowering(superFunc)
    local spec = self.spec_foldable

    if spec.foldAnimTime > spec.loweringMaxLimit or spec.foldAnimTime < spec.loweringMinLimit then
        return false , spec.unfoldWarning
    end

    return superFunc( self )
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
function Foldable:getBrakeForce(superFunc)
    local spec = self.spec_foldable
    if spec.releaseBrakesWhileFolding then
        if spec.foldMoveDirection ~ = 0 then
            return 0
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
function Foldable:getCanAIImplementContinueWork(superFunc, isTurning)
    local canContinue, stopAI, stopReason = superFunc( self , isTurning)
    if not canContinue then
        return false , stopAI, stopReason
    end

    local spec = self.spec_foldable

    if spec.hasFoldingParts and spec.allowUnfoldingByAI then
        if spec.foldMiddleAnimTime ~ = nil then
            if math.abs(spec.foldAnimTime - spec.foldMiddleAnimTime) > 0.001 and spec.foldAnimTime ~ = 0 and spec.foldAnimTime ~ = 1 then
                -- do not block the ai while lifting the implement to save time
                    if spec.foldAnimTime > 0 and spec.foldAnimTime < spec.foldMiddleAnimTime then
                        if spec.foldMoveDirection > 0 then
                            return true
                        end
                    end

                    return false
                end
            else
                    if spec.foldAnimTime ~ = 0 and spec.foldAnimTime ~ = 1 then
                        return false
                    end
                end
            end

            return canContinue
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
function Foldable:getCanBeSelected(superFunc)
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
function Foldable:getCanBeTurnedOn(superFunc)
    local spec = self.spec_foldable
    if spec.foldAnimTime > spec.turnOnFoldMaxLimit or spec.foldAnimTime < spec.turnOnFoldMinLimit then
        return false
    end

    return superFunc( self )
end

```

### getCanChangePickupState

**Description**

**Definition**

> getCanChangePickupState()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | spec      |
| any | newState  |

**Code**

```lua
function Foldable:getCanChangePickupState(superFunc, spec, newState)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < spec.foldMinLimit or foldAnimTime > spec.foldMaxLimit then
        return false
    end

    return superFunc( self , spec, newState)
end

```

### getCanToggleCrabSteering

**Description**

**Definition**

> getCanToggleCrabSteering()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getCanToggleCrabSteering(superFunc)
    local spec = self.spec_foldable
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < spec.crabSteeringMinLimit or foldAnimTime > spec.crabSteeringMaxLimit then
        return false , spec.unfoldWarning
    end

    return superFunc( self )
end

```

### getCrabSteeringModeAvailable

**Description**

**Definition**

> getCrabSteeringModeAvailable()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | mode      |

**Code**

```lua
function Foldable:getCrabSteeringModeAvailable(superFunc, mode)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < mode.foldMinLimit or foldAnimTime > mode.foldMaxLimit then
        return false
    end

    return superFunc( self , mode)
end

```

### getCraneShovelStateChangedAllowed

**Description**

**Definition**

> getCraneShovelStateChangedAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | spec      |

**Code**

```lua
function Foldable:getCraneShovelStateChangedAllowed(superFunc, spec)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime ~ = nil and(foldAnimTime < spec.foldableMinLimit or foldAnimTime > spec.foldableMaxLimit) then
        return false , self.spec_foldable.unfoldWarning
    end

    return superFunc( self , spec)
end

```

### getCutterTiltIsActive

**Description**

> Returns if cutter tilt is active

**Definition**

> getCutterTiltIsActive()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | automaticTilt |

**Return Values**

| any | isActive | cutter tilt is active                 |
|-----|----------|---------------------------------------|
| any | doReset  | reset header tilt to initial position |

**Code**

```lua
function Foldable:getCutterTiltIsActive(superFunc, automaticTilt)
    local isActive, doReset = superFunc( self , automaticTilt)
    if not isActive then
        return isActive, doReset
    end

    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < automaticTilt.foldMinLimit or foldAnimTime > automaticTilt.foldMaxLimit then
        return false , true
    end

    return true , false
end

```

### getFillUnitSupportsToolType

**Description**

**Definition**

> getFillUnitSupportsToolType()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | fillUnitIndex |
| any | toolType      |

**Code**

```lua
function Foldable:getFillUnitSupportsToolType(superFunc, fillUnitIndex, toolType)
    -- tool type undefined is always allowed
    if toolType ~ = ToolType.UNDEFINED then
        local fillUnit = self.spec_fillUnit.fillUnits[fillUnitIndex]
        if fillUnit ~ = nil then
            if fillUnit.foldMinLimit ~ = nil and fillUnit.foldMaxLimit ~ = nil then
                local foldAnimTime = self:getFoldAnimTime()
                if foldAnimTime < fillUnit.foldMinLimit or foldAnimTime > fillUnit.foldMaxLimit then
                    return false
                end
            end
        end
    end

    return superFunc( self , fillUnitIndex, toolType)
end

```

### getFoldAnimTime

**Description**

**Definition**

> getFoldAnimTime()

**Code**

```lua
function Foldable:getFoldAnimTime()
    local spec = self.spec_foldable
    return spec.loadedFoldAnimTime or spec.foldAnimTime
end

```

### getIsAdditionalCharacterActive

**Description**

**Definition**

> getIsAdditionalCharacterActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getIsAdditionalCharacterActive(superFunc)
    local spec = self.spec_enterable
    if spec.additionalCharacterFoldMinLimit ~ = nil and spec.additionalCharacterFoldMaxLimit ~ = nil then
        local foldAnimTime = self:getFoldAnimTime()
        if foldAnimTime > = spec.additionalCharacterFoldMinLimit and foldAnimTime < = spec.additionalCharacterFoldMaxLimit then
            return true
        end
    end

    return superFunc( self )
end

```

### getIsAIPreparingToDrive

**Description**

**Definition**

> getIsAIPreparingToDrive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getIsAIPreparingToDrive(superFunc)
    local spec = self.spec_foldable

    if spec.hasFoldingParts and spec.allowUnfoldingByAI then
        if spec.foldAnimTime ~ = spec.foldMiddleAnimTime and spec.foldAnimTime ~ = 0 and spec.foldAnimTime ~ = 1 then
            return true
        end
    end

    return superFunc( self )
end

```

### getIsAIReadyToDrive

**Description**

**Definition**

> getIsAIReadyToDrive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getIsAIReadyToDrive(superFunc)
    local spec = self.spec_foldable

    if spec.hasFoldingParts and spec.allowUnfoldingByAI then
        if spec.turnOnFoldDirection > 0 then
            if spec.foldAnimTime > 0 then
                return false
            end
        else
                if spec.foldAnimTime < 1 then
                    return false
                end
            end
        end

        return superFunc( self )
    end

```

### getIsAttacherJointHeightNodeActive

**Description**

**Definition**

> getIsAttacherJointHeightNodeActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | heightNode |

**Code**

```lua
function Foldable:getIsAttacherJointHeightNodeActive(superFunc, heightNode)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < heightNode.foldMinLimit or foldAnimTime > heightNode.foldMaxLimit then
        return false
    end

    return superFunc( self , heightNode)
end

```

### getIsFoldActionAllowed

**Description**

> Returns if the fold action is shown or not

**Definition**

> getIsFoldActionAllowed()

**Return Values**

| any | isFoldAllowed |
|-----|---------------|

**Code**

```lua
function Foldable:getIsFoldActionAllowed()
    return self.spec_foldable.isFoldAllowed
end

```

### getIsFoldAllowed

**Description**

> Returns if the actual fold action is executed or not & a warning to indicate the reason for the player

**Definition**

> getIsFoldAllowed(integer direction, boolean onAiTurnOn)

**Arguments**

| integer | direction  |
|---------|------------|
| boolean | onAiTurnOn |

**Return Values**

| boolean | isFoldAllowed |
|---------|---------------|
| boolean | warning       |

**Code**

```lua
function Foldable:getIsFoldAllowed(direction, onAiTurnOn)
    local spec = self.spec_foldable
    if not spec.isFoldAllowed then
        return false , nil
    end

    if self.getAttacherVehicle ~ = nil and self:getAttacherVehicle() ~ = nil then
        local inputAttacherJoint = self:getActiveInputAttacherJoint()
        if inputAttacherJoint.foldMinLimit ~ = nil and inputAttacherJoint.foldMaxLimit ~ = nil then
            local foldAnimTime = self:getFoldAnimTime()
            if foldAnimTime < inputAttacherJoint.foldMinLimit or foldAnimTime > inputAttacherJoint.foldMaxLimit then
                return false , nil
            end
        end
    end

    if (spec.toggleFoldingBlockedDirection = = 0 and spec.foldMoveDirection ~ = 0 ) or(spec.toggleFoldingBlockedDirection ~ = 0 and spec.foldMoveDirection = = - spec.toggleFoldingBlockedDirection) then
        if spec.foldAnimTime > spec.toggleFoldingMaxLimit or spec.foldAnimTime < spec.toggleFoldingMinLimit then
            return false , nil
        end
    end

    return true , nil
end

```

### getIsFoldMiddleAllowed

**Description**

**Definition**

> getIsFoldMiddleAllowed()

**Code**

```lua
function Foldable:getIsFoldMiddleAllowed()
    local spec = self.spec_foldable

    if not spec.isFoldAllowed then
        return false
    end

    return spec.foldMiddleAnimTime ~ = nil
end

```

### getIsGroundAdjustedNodeActive

**Description**

**Definition**

> getIsGroundAdjustedNodeActive()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | adjustedNode      |
| any | ignoreAttachState |

**Code**

```lua
function Foldable:getIsGroundAdjustedNodeActive(superFunc, adjustedNode, ignoreAttachState)
    local spec = self.spec_foldable

    local foldAnimTime = spec.foldAnimTime
    if foldAnimTime ~ = nil and(foldAnimTime > adjustedNode.foldMaxLimit or foldAnimTime < adjustedNode.foldMinLimit) then
        return false
    end

    return superFunc( self , adjustedNode, ignoreAttachState)
end

```

### getIsInputAttacherActive

**Description**

> Returns true if input attacher is active and can be used to attach

**Definition**

> getIsInputAttacherActive(table inputAttacherJoint, )

**Arguments**

| table | inputAttacherJoint | input attacher joint |
|-------|--------------------|----------------------|
| any   | inputAttacherJoint |                      |

**Return Values**

| any | isActive | input attacher is active |
|-----|----------|--------------------------|

**Code**

```lua
function Foldable:getIsInputAttacherActive(superFunc, inputAttacherJoint)
    if inputAttacherJoint.foldMinLimit ~ = nil and inputAttacherJoint.foldMaxLimit ~ = nil then
        local foldAnimTime = self:getFoldAnimTime()
        if foldAnimTime < inputAttacherJoint.foldMinLimit or foldAnimTime > inputAttacherJoint.foldMaxLimit then
            return false
        end
    end

    return superFunc( self , inputAttacherJoint)
end

```

### getIsInWorkPosition

**Description**

**Definition**

> getIsInWorkPosition()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getIsInWorkPosition(superFunc)
    local spec = self.spec_foldable

    if spec.turnOnFoldDirection ~ = 0 and not(#spec.foldingParts = = 0 or(spec.turnOnFoldDirection = = - 1 and spec.foldAnimTime = = 0 ) or(spec.turnOnFoldDirection = = 1 and spec.foldAnimTime = = 1 )) then
        return false
    end

    return superFunc( self )
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
function Foldable:getIsLevelerPickupNodeActive(superFunc, levelerNode)
    local spec = self.spec_foldable

    if not levelerNode.foldLimitedOuterRange then
        if spec.foldAnimTime > levelerNode.foldMaxLimit or spec.foldAnimTime < levelerNode.foldMinLimit then
            return false
        end
    else
            if spec.foldAnimTime < = levelerNode.foldMaxLimit and spec.foldAnimTime > levelerNode.foldMinLimit then
                return false
            end
        end

        return superFunc( self , levelerNode)
    end

```

### getIsLowered

**Description**

**Definition**

> getIsLowered()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | default   |

**Code**

```lua
function Foldable:getIsLowered(superFunc, default)
    local spec = self.spec_foldable

    if self:getIsFoldMiddleAllowed() then
        if spec.foldMiddleAnimTime ~ = nil and spec.foldMiddleInputButton ~ = nil then
            local ignoreFoldMiddle = false
            if spec.ignoreFoldMiddleWhileFolded then
                if self:getFoldAnimTime() > spec.foldMiddleAnimTime then
                    ignoreFoldMiddle = true
                end
            end

            if not ignoreFoldMiddle then
                if spec.foldMoveDirection ~ = 0 then
                    if spec.foldMiddleDirection > 0 then
                        if spec.foldAnimTime < spec.foldMiddleAnimTime + 0.01 then
                            return spec.foldMoveDirection < 0 and spec.moveToMiddle ~ = true
                        end
                    else
                            if spec.foldAnimTime > spec.foldMiddleAnimTime - 0.01 then
                                return spec.foldMoveDirection > 0 and spec.moveToMiddle ~ = true
                            end
                        end
                    else
                            if spec.foldMiddleDirection > 0 and spec.foldAnimTime < 0.01 then
                                return true
                            elseif spec.foldMiddleDirection < 0 and math.abs( 1.0 - spec.foldAnimTime) < 0.01 then
                                    return true
                                end
                            end

                            return false
                        else
                                return superFunc( self , default)
                            end
                        end
                    end

                    return superFunc( self , default)
                end

```

### getIsMovingPartActive

**Description**

**Definition**

> getIsMovingPartActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | movingPart |

**Code**

```lua
function Foldable:getIsMovingPartActive(superFunc, movingPart)
    if movingPart.foldMaxLimit ~ = 1 or movingPart.foldMinLimit ~ = 0 then
        local foldAnimTime = self:getFoldAnimTime()
        if foldAnimTime > movingPart.foldMaxLimit or foldAnimTime < movingPart.foldMinLimit then
            return false
        end
    end

    return superFunc( self , movingPart)
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
function Foldable:getIsMovingToolActive(superFunc, movingTool)
    if not movingTool.hasRequiredFoldingConfiguration then
        return false
    end

    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime > movingTool.foldMaxLimit or foldAnimTime < movingTool.foldMinLimit then
        return false
    end

    return superFunc( self , movingTool)
end

```

### getIsNextCoverStateAllowed

**Description**

**Definition**

> getIsNextCoverStateAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | nextState |

**Code**

```lua
function Foldable:getIsNextCoverStateAllowed(superFunc, nextState)
    if not superFunc( self , nextState) then
        return false
    end

    local spec = self.spec_foldable
    if spec.foldAnimTime > spec.toggleCoverMaxLimit or spec.foldAnimTime < spec.toggleCoverMinLimit then
        return false
    end

    return true
end

```

### getIsNextCoverStateAllowedWarning

**Description**

**Definition**

> getIsNextCoverStateAllowedWarning()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | nextState |

**Code**

```lua
function Foldable:getIsNextCoverStateAllowedWarning(superFunc, nextState)
    local spec = self.spec_foldable
    if spec.foldAnimTime > spec.toggleCoverMaxLimit or spec.foldAnimTime < spec.toggleCoverMinLimit then
        return spec.unfoldWarning
    end

    return superFunc( self , nextState)
end

```

### getIsPreprunerNodeActive

**Description**

**Definition**

> getIsPreprunerNodeActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | prunerNode |

**Code**

```lua
function Foldable:getIsPreprunerNodeActive(superFunc, prunerNode)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < prunerNode.foldMinLimit or foldAnimTime > prunerNode.foldMaxLimit then
        return false
    end

    return superFunc( self , prunerNode)
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
function Foldable:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    local spec = self.spec_foldable

    if not speedRotatingPart.foldLimitedOuterRange then
        if spec.foldAnimTime > speedRotatingPart.foldMaxLimit or spec.foldAnimTime < speedRotatingPart.foldMinLimit then
            return false
        end
    else
            if spec.foldAnimTime < = speedRotatingPart.foldMaxLimit and spec.foldAnimTime > speedRotatingPart.foldMinLimit then
                return false
            end
        end

        return superFunc( self , speedRotatingPart)
    end

```

### getIsSprayTypeActive

**Description**

**Definition**

> getIsSprayTypeActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | sprayType |

**Code**

```lua
function Foldable:getIsSprayTypeActive(superFunc, sprayType)
    local spec = self.spec_foldable

    if sprayType.foldMinLimit ~ = nil and sprayType.foldMaxLimit ~ = nil then
        local foldAnimTime = spec.foldAnimTime
        if foldAnimTime ~ = nil and(foldAnimTime > sprayType.foldMaxLimit or foldAnimTime < sprayType.foldMinLimit) then
            return false
        end
    end

    if not sprayType.hasRequiredFoldingConfiguration then
        return false
    end

    return superFunc( self , sprayType)
end

```

### getIsSteeringAxleAllowed

**Description**

**Definition**

> getIsSteeringAxleAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getIsSteeringAxleAllowed(superFunc)
    local spec = self.spec_attachable
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < spec.foldMinLimit or foldAnimTime > spec.foldMaxLimit then
        return false
    end

    return superFunc( self )
end

```

### getIsSupportAnimationAllowed

**Description**

> Returns if support animation is allowed to play

**Definition**

> getIsSupportAnimationAllowed()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | supportAnimation |

**Code**

```lua
function Foldable:getIsSupportAnimationAllowed(superFunc, supportAnimation)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < supportAnimation.foldMinLimit or foldAnimTime > supportAnimation.foldMaxLimit then
        return false
    end

    return superFunc( self , supportAnimation)
end

```

### getIsSuspensionNodeActive

**Description**

**Definition**

> getIsSuspensionNodeActive()

**Arguments**

| any | superFunc      |
|-----|----------------|
| any | suspensionNode |

**Code**

```lua
function Foldable:getIsSuspensionNodeActive(superFunc, suspensionNode)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < suspensionNode.foldMinLimit or foldAnimTime > suspensionNode.foldMaxLimit then
        return false
    end

    return superFunc( self , suspensionNode)
end

```

### getIsTurnedOnAnimationActive

**Description**

**Definition**

> getIsTurnedOnAnimationActive()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | turnedOnAnimation |

**Code**

```lua
function Foldable:getIsTurnedOnAnimationActive(superFunc, turnedOnAnimation)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < turnedOnAnimation.foldMinLimit or foldAnimTime > turnedOnAnimation.foldMaxLimit then
        return false
    end

    return superFunc( self , turnedOnAnimation)
end

```

### getIsUnfolded

**Description**

**Definition**

> getIsUnfolded()

**Code**

```lua
function Foldable:getIsUnfolded()
    local spec = self.spec_foldable

    if spec.hasFoldingParts then
        if spec.foldMiddleAnimTime ~ = nil then
            if (spec.turnOnFoldDirection = = - 1 and spec.foldAnimTime < spec.foldMiddleAnimTime + 0.01 ) or
                (spec.turnOnFoldDirection = = 1 and spec.foldAnimTime > spec.foldMiddleAnimTime - 0.01 )
                then
                return true
            else
                    return false
                end
            else
                    if (spec.turnOnFoldDirection = = - 1 and spec.foldAnimTime = = 0 ) or(spec.turnOnFoldDirection = = 1 and spec.foldAnimTime = = 1 ) then
                        return true
                    else
                            return false
                        end
                    end
                else
                        return true
                    end
                end

```

### getIsVehicleControlAllowed

**Description**

**Definition**

> getIsVehicleControlAllowed()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Foldable.getIsVehicleControlAllowed( self )
    local spec = self.spec_foldable
    if spec.foldMoveDirection ~ = 0 then
        return false , nil
    end

    return true , nil
end

```

### getIsVersatileYRotActive

**Description**

**Definition**

> getIsVersatileYRotActive()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | wheel     |

**Code**

```lua
function Foldable:getIsVersatileYRotActive(superFunc, wheel)
    local spec = self.spec_foldable

    if spec.foldAnimTime > wheel.versatileFoldMaxLimit or spec.foldAnimTime < wheel.versatileFoldMinLimit then
        return false
    end

    return superFunc( self , wheel)
end

```

### getIsWheelChockAllowed

**Description**

**Definition**

> getIsWheelChockAllowed()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | wheelChock |

**Code**

```lua
function Foldable:getIsWheelChockAllowed(superFunc, wheelChock)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime ~ = nil and(foldAnimTime < wheelChock.foldMinLimit or foldAnimTime > wheelChock.foldMaxLimit) then
        return false
    end

    return superFunc( self )
end

```

### getIsWoodHarvesterTiltStateAllowed

**Description**

**Definition**

> getIsWoodHarvesterTiltStateAllowed()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | headerTilt |

**Code**

```lua
function Foldable:getIsWoodHarvesterTiltStateAllowed(superFunc, headerTilt)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < headerTilt.foldMinLimit or foldAnimTime > headerTilt.foldMaxLimit then
        return false
    end

    return superFunc( self , headerTilt)
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
function Foldable:getIsWorkAreaActive(superFunc, workArea)
    local spec = self.spec_foldable

    if not workArea.foldLimitedOuterRange then
        if spec.foldAnimTime > workArea.foldMaxLimit or spec.foldAnimTime < workArea.foldMinLimit then
            return false
        end
    else
            if spec.foldAnimTime < = workArea.foldMaxLimit and spec.foldAnimTime > workArea.foldMinLimit then
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
function Foldable:getRequiresPower(superFunc)
    return self.spec_foldable.foldMoveDirection ~ = 0 or superFunc( self )
end

```

### getShovelNodeIsActive

**Description**

**Definition**

> getShovelNodeIsActive()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | shovelNode |

**Code**

```lua
function Foldable:getShovelNodeIsActive(superFunc, shovelNode)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < shovelNode.foldMinLimit or foldAnimTime > shovelNode.foldMaxLimit then
        return false
    end

    return superFunc( self , shovelNode)
end

```

### getSlopeCompensationAngleScale

**Description**

**Definition**

> getSlopeCompensationAngleScale()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | compensationNode |

**Code**

```lua
function Foldable:getSlopeCompensationAngleScale(superFunc, compensationNode)
    local scale = superFunc( self , compensationNode)

    if compensationNode.foldAngleScale ~ = nil then
        local spec = self.spec_foldable
        local animTime = 1 - spec.foldAnimTime
        if compensationNode.invertFoldAngleScale then
            animTime = 1 - animTime
        end

        if spec.foldMiddleAnimTime ~ = nil then
            scale = scale * MathUtil.lerp(compensationNode.foldAngleScale, 1 , animTime / ( 1 - spec.foldMiddleAnimTime))
        else
                scale = scale * MathUtil.lerp(compensationNode.foldAngleScale, 1 , animTime)
            end
        end

        return scale
    end

```

### getToggledFoldDirection

**Description**

**Definition**

> getToggledFoldDirection()

**Code**

```lua
function Foldable:getToggledFoldDirection()
    local spec = self.spec_foldable

    local foldMidTime = 0.5
    if spec.foldMiddleAnimTime ~ = nil then
        if spec.foldMiddleDirection > 0 then
            foldMidTime = ( 1 + spec.foldMiddleAnimTime) * 0.5
        else
                foldMidTime = spec.foldMiddleAnimTime * 0.5
            end
        end

        local targetDirection = 0

        if spec.moveToMiddle then
            targetDirection = spec.foldMiddleDirection
        elseif spec.foldMoveDirection = = 0 then
                if spec.foldAnimTime < foldMidTime then
                    targetDirection = 1
                else
                        targetDirection = - 1
                    end
                else
                        targetDirection = - spec.foldMoveDirection
                    end

                    -- if we are still in lowered range, we always fold the tool
                        -- otherwise we stay in this inbetween state
                        if spec.foldMiddleAnimTime ~ = nil then
                            if spec.foldMiddleDirection > 0 then
                                if spec.foldAnimTime < spec.foldMiddleAnimTime - 0.01 then
                                    targetDirection = 1
                                end
                            else
                                    if spec.foldAnimTime > spec.foldMiddleAnimTime + 0.01 then
                                        targetDirection = - 1
                                    end
                                end
                            end

                            return targetDirection
                        end

```

### getToggledFoldMiddleDirection

**Description**

**Definition**

> getToggledFoldMiddleDirection()

**Code**

```lua
function Foldable:getToggledFoldMiddleDirection()
    local spec = self.spec_foldable

    local ret = 0
    if spec.foldMiddleAnimTime ~ = nil then
        if spec.foldMoveDirection > 0.1 then
            ret = - 1
        else
                ret = 1
            end
            if spec.foldMiddleDirection > 0 then
                if spec.foldAnimTime > = spec.foldMiddleAnimTime - 0.01 then
                    ret = - 1
                end
            else
                    if spec.foldAnimTime < = spec.foldMiddleAnimTime + 0.01 then
                        ret = 1
                    else
                            ret = - 1
                        end
                    end
                end
                return ret
            end

```

### getTurnedOnNotAllowedWarning

**Description**

**Definition**

> getTurnedOnNotAllowedWarning()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Foldable:getTurnedOnNotAllowedWarning(superFunc)
    local spec = self.spec_foldable

    if spec.foldAnimTime > spec.turnOnFoldMaxLimit or spec.foldAnimTime < spec.turnOnFoldMinLimit then
        return spec.unfoldWarning
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
function Foldable.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "folding" , g_i18n:getText( "configuration_folding" ), "foldable" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Foldable" )

    schema:register(XMLValueType.FLOAT, "vehicle.foldable.foldingConfigurations.foldingConfiguration(?)#workingWidth" , "Working width to display in shop" )

    Foldable.registerFoldingXMLPaths(schema, "vehicle.foldable.foldingConfigurations.foldingConfiguration(?).foldingParts" )

    schema:register(XMLValueType.BOOL, WorkArea.WORK_AREA_XML_KEY .. "#foldLimitedOuterRange" , "Fold limit outer range" , false )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".folding#minLimit" , "Min.fold limit" , 0 )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_KEY .. ".folding#maxLimit" , "Max.fold limit" , 1 )

    schema:register(XMLValueType.BOOL, WorkArea.WORK_AREA_XML_CONFIG_KEY .. "#foldLimitedOuterRange" , "Fold limit outer range" , false )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".folding#minLimit" , "Min.fold limit" , 0 )
    schema:register(XMLValueType.FLOAT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".folding#maxLimit" , "Max.fold limit" , 1 )

    schema:register(XMLValueType.FLOAT, GroundReference.GROUND_REFERENCE_XML_KEY .. ".folding#minLimit" , "Min.fold limit" , 0 )
    schema:register(XMLValueType.FLOAT, GroundReference.GROUND_REFERENCE_XML_KEY .. ".folding#maxLimit" , "Max.fold limit" , 1 )

    schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#foldLimitedOuterRange" , "Fold limit outer range" , false )
    schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#foldMinLimit" , "Min.fold limit" , 0 )
    schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#foldMaxLimit" , "Max.fold limit" , 1 )

    schema:register(XMLValueType.BOOL, Leveler.LEVELER_NODE_XML_KEY .. "#foldLimitedOuterRange" , "Fold limit outer range" , false )
    schema:register(XMLValueType.FLOAT, Leveler.LEVELER_NODE_XML_KEY .. "#foldMinLimit" , "Min.fold limit" , 0 )
    schema:register(XMLValueType.FLOAT, Leveler.LEVELER_NODE_XML_KEY .. "#foldMaxLimit" , "Max.fold limit" , 1 )

    schema:addDelayedRegistrationFunc( "SlopeCompensation:compensationNode" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldAngleScale" , "Fold angle scale" )
        cSchema:register(XMLValueType.BOOL, cKey .. "#invertFoldAngleScale" , "Invert fold angle scale" , false )
    end )

    schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldMinLimit" , "Fold min.time" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldMaxLimit" , "Fold max.time" , 1 )

        cSchema:register(XMLValueType.INT, cKey .. "#foldingConfigurationIndex" , "Index of folding configuration to activate the moving tool" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. "#foldingConfigurationIndices" , "List of folding configuration indices to activate the moving tool" )
    end )

    schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldMinLimit" , "Fold min.time" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldMaxLimit" , "Fold max.time" , 1 )
    end )

    schema:addDelayedRegistrationFunc( "Attachable:support" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. ".folding#minLimit" , "Min.fold limit" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. ".folding#maxLimit" , "Max.fold limit" , 1 )
    end )

    schema:addDelayedRegistrationFunc( "CrabSteering:steeringMode" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. ".folding#minLimit" , "Min.fold limit" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. ".folding#maxLimit" , "Max.fold limit" , 1 )
    end )

    schema:addDelayedRegistrationFunc( "WheelChock" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldMinLimit" , "Fold min.time" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. "#foldMaxLimit" , "Fold max.time" , 1 )
    end )

    schema:addDelayedRegistrationFunc( "GroundAdjustedNodes:node" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. ".foldable#minLimit" , "Fold min.time" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. ".foldable#maxLimit" , "Fold max.time" , 1 )
    end )

    schema:addDelayedRegistrationFunc( "CraneShovel" , function (cSchema, cKey)
        cSchema:register(XMLValueType.FLOAT, cKey .. ".foldable#minLimit" , "Fold min.time" , 0 )
        cSchema:register(XMLValueType.FLOAT, cKey .. ".foldable#maxLimit" , "Fold max.time" , 1 )
    end )

    schema:register(XMLValueType.FLOAT, Sprayer.SPRAY_TYPE_XML_KEY .. "#foldMinLimit" , "Fold min.time" , 0 )
    schema:register(XMLValueType.FLOAT, Sprayer.SPRAY_TYPE_XML_KEY .. "#foldMaxLimit" , "Fold max.time" , 1 )
    schema:register(XMLValueType.INT, Sprayer.SPRAY_TYPE_XML_KEY .. "#foldingConfigurationIndex" , "Index of folding configuration to activate spray type" )
    schema:register(XMLValueType.VECTOR_N, Sprayer.SPRAY_TYPE_XML_KEY .. "#foldingConfigurationIndices" , "List of folding configuration indices to activate spray type" )

    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_XML_KEY .. "#foldMinLimit" , "Fold min.time" , 0 )
    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_XML_KEY .. "#foldMaxLimit" , "Fold max.time" , 1 )

    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY .. "#foldMinLimit" , "Fold min.time" , 0 )
    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY .. "#foldMaxLimit" , "Fold max.time" , 1 )

    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_XML_KEY .. ".heightNode(?)#foldMinLimit" , "Fold min.time" , 0 )
    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_XML_KEY .. ".heightNode(?)#foldMaxLimit" , "Fold max.time" , 1 )

    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY .. ".heightNode(?)#foldMinLimit" , "Fold min.time" , 0 )
    schema:register(XMLValueType.FLOAT, Attachable.INPUT_ATTACHERJOINT_CONFIG_XML_KEY .. ".heightNode(?)#foldMaxLimit" , "Fold max.time" , 1 )

    schema:register(XMLValueType.FLOAT, Enterable.ADDITIONAL_CHARACTER_XML_KEY .. "#foldMinLimit" , "Fold min.time" , 0 )
    schema:register(XMLValueType.FLOAT, Enterable.ADDITIONAL_CHARACTER_XML_KEY .. "#foldMaxLimit" , "Fold max.time" , 1 )

    schema:register(XMLValueType.FLOAT, Attachable.STEERING_AXLE_XML_KEY .. ".folding#minLimit" , "Min.fold limit" , 0 )
    schema:register(XMLValueType.FLOAT, Attachable.STEERING_AXLE_XML_KEY .. ".folding#maxLimit" , "Max.fold limit" , 1 )

    schema:register(XMLValueType.FLOAT, Wheels.WHEEL_XML_PATH .. "#versatileFoldMinLimit" , "Fold min.time for versatility" , 0 )
        schema:register(XMLValueType.FLOAT, Wheels.WHEEL_XML_PATH .. "#versatileFoldMaxLimit" , "Fold max.time for versatility" , 1 )

            schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_XML_KEY .. "#foldMinLimit" , "Fold min.time for filling" , 0 )
                schema:register(XMLValueType.FLOAT, FillUnit.FILL_UNIT_XML_KEY .. "#foldMaxLimit" , "Fold max.time for filling" , 1 )

                    schema:register(XMLValueType.FLOAT, TurnOnVehicle.TURNED_ON_ANIMATION_XML_PATH .. "#foldMinLimit" , "Fold min.time for running turned on animation" , 0 )
                        schema:register(XMLValueType.FLOAT, TurnOnVehicle.TURNED_ON_ANIMATION_XML_PATH .. "#foldMaxLimit" , "Fold max.time for running turned on animation" , 1 )

                            schema:register(XMLValueType.FLOAT, Pickup.PICKUP_XML_KEY .. "#foldMinLimit" , "Fold min.time for pickup lowering" , 0 )
                                schema:register(XMLValueType.FLOAT, Pickup.PICKUP_XML_KEY .. "#foldMaxLimit" , "Fold max.time for pickup lowering" , 1 )

                                    schema:register(XMLValueType.FLOAT, Cutter.CUTTER_TILT_XML_KEY .. "#foldMinLimit" , "Fold min.time for cutter automatic tilt" , 0 )
                                        schema:register(XMLValueType.FLOAT, Cutter.CUTTER_TILT_XML_KEY .. "#foldMaxLimit" , "Fold max.time for cutter automatic tilt" , 1 )

                                            schema:register(XMLValueType.FLOAT, VinePrepruner.PRUNER_NODE_XML_KEY .. "#foldMinLimit" , "Fold min.time for pruner node update" , 0 )
                                                schema:register(XMLValueType.FLOAT, VinePrepruner.PRUNER_NODE_XML_KEY .. "#foldMaxLimit" , "Fold max.time for pruner node update" , 1 )

                                                    schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#foldMinLimit" , "Fold min.time for shovel pickup" , 0 )
                                                        schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. "#foldMaxLimit" , "Fold max.time for shovel pickup" , 1 )

                                                            schema:register(XMLValueType.FLOAT, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#foldMinLimit" , "Fold min.time for steering angle nodes to update" , 0 )
                                                                schema:register(XMLValueType.FLOAT, Attachable.STEERING_ANGLE_NODE_XML_KEY .. "#foldMaxLimit" , "Fold max.time for steering angle nodes to update" , 1 )

                                                                    schema:register(XMLValueType.FLOAT, WoodHarvester.HEADER_JOINT_TILT_XML_KEY .. "#foldMinLimit" , "Fold min.time for header tilt to be allowed" , 0 )
                                                                        schema:register(XMLValueType.FLOAT, WoodHarvester.HEADER_JOINT_TILT_XML_KEY .. "#foldMaxLimit" , "Fold max.time for header tilt to be allowed" , 1 )

                                                                            schema:register(XMLValueType.FLOAT, Suspensions.SUSPENSION_NODE_XML_KEY .. "#foldMinLimit" , "Fold min.time for suspension node to be active" , 0 )
                                                                                schema:register(XMLValueType.FLOAT, Suspensions.SUSPENSION_NODE_XML_KEY .. "#foldMaxLimit" , "Fold max.time for suspension node to be active" , 1 )

                                                                                    schema:setXMLSpecializationType()

                                                                                    local schemaSavegame = Vehicle.xmlSchemaSavegame
                                                                                    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).foldable#foldAnimTime" , "Fold animation time" )
                                                                                    schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).foldable#isAllowed" , "If folding is allowed" )
                                                                                end

```

### isAttachAllowed

**Description**

> Returns true if attaching the vehicle is allowed

**Definition**

> isAttachAllowed(integer farmId, table attacherVehicle, )

**Arguments**

| integer | farmId          | farmId of attacher vehicle |
|---------|-----------------|----------------------------|
| table   | attacherVehicle | attacher vehicle           |
| any     | attacherVehicle |                            |

**Return Values**

| any | detachAllowed | detach is allowed                  |
|-----|---------------|------------------------------------|
| any | warning       | [optional] warning text to display |

**Code**

```lua
function Foldable:isAttachAllowed(superFunc, farmId, attacherVehicle)
    local spec = self.spec_foldable

    if spec.foldAnimTime > spec.attachingMaxLimit or spec.foldAnimTime < spec.attachingMinLimit then
        return false , spec.unfoldWarning
    end

    return superFunc( self , farmId, attacherVehicle)
end

```

### isDetachAllowed

**Description**

> Returns true if detach is allowed

**Definition**

> isDetachAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | detachAllowed | detach is allowed                  |
|-----|---------------|------------------------------------|
| any | warning       | [optional] warning text to display |

**Code**

```lua
function Foldable:isDetachAllowed(superFunc)
    local spec = self.spec_foldable

    if spec.foldAnimTime > spec.detachingMaxLimit or spec.foldAnimTime < spec.detachingMinLimit then
        return false , spec.unfoldWarning
    end

    if not spec.allowDetachingWhileFolding then
        if (spec.foldMiddleAnimTime = = nil or math.abs(spec.foldAnimTime - spec.foldMiddleAnimTime) > 0.001 ) and(spec.foldAnimTime > 0 and spec.foldAnimTime < 1 ) then
            return false , spec.detachWarning
        end
    end

    return superFunc( self )
end

```

### loadAdditionalCharacterFromXML

**Description**

**Definition**

> loadAdditionalCharacterFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |

**Code**

```lua
function Foldable:loadAdditionalCharacterFromXML(superFunc, xmlFile)
    local spec = self.spec_enterable

    spec.additionalCharacterFoldMinLimit = xmlFile:getValue( "vehicle.enterable.additionalCharacter#foldMinLimit" )
    spec.additionalCharacterFoldMaxLimit = xmlFile:getValue( "vehicle.enterable.additionalCharacter#foldMaxLimit" )

    return superFunc( self , xmlFile)
end

```

### loadAttacherJointHeightNode

**Description**

**Definition**

> loadAttacherJointHeightNode()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | xmlFile           |
| any | key               |
| any | heightNode        |
| any | attacherJointNode |

**Code**

```lua
function Foldable:loadAttacherJointHeightNode(superFunc, xmlFile, key, heightNode, attacherJointNode)
    heightNode.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    heightNode.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return superFunc( self , xmlFile, key, heightNode, attacherJointNode)
end

```

### loadCrabSteeringModeFromXML

**Description**

**Definition**

> loadCrabSteeringModeFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | mode      |

**Code**

```lua
function Foldable:loadCrabSteeringModeFromXML(superFunc, xmlFile, key, mode)
    if not superFunc( self , xmlFile, key, mode) then
        return false
    end

    mode.foldMinLimit = xmlFile:getValue(key .. ".folding#minLimit" , 0 )
    mode.foldMaxLimit = xmlFile:getValue(key .. ".folding#maxLimit" , 1 )

    return true
end

```

### loadCraneShovelFromXML

**Description**

**Definition**

> loadCraneShovelFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | spec      |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function Foldable:loadCraneShovelFromXML(superFunc, spec, xmlFile, key)
    if not superFunc( self , spec, xmlFile, key) then
        return false
    end

    spec.foldableMinLimit = xmlFile:getValue(key .. ".foldable#minLimit" , 0 )
    spec.foldableMaxLimit = xmlFile:getValue(key .. ".foldable#maxLimit" , 1 )

    return true
end

```

### loadCutterTiltFromXML

**Description**

> Loads header tilt from xml file

**Definition**

> loadCutterTiltFromXML(table xmlFile, string key, , )

**Arguments**

| table  | xmlFile | xml file object  |
|--------|---------|------------------|
| string | key     | key to load from |
| any    | key     |                  |
| any    | target  |                  |

**Return Values**

| any | success | successfully loaded |
|-----|---------|---------------------|

**Code**

```lua
function Foldable:loadCutterTiltFromXML(superFunc, xmlFile, key, target)
    if not superFunc( self , xmlFile, key, target) then
        return false
    end

    target.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    target.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return true
end

```

### loadFillUnitFromXML

**Description**

**Definition**

> loadFillUnitFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |
| any | index     |

**Code**

```lua
function Foldable:loadFillUnitFromXML(superFunc, xmlFile, key, entry, index)
    entry.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    entry.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return superFunc( self , xmlFile, key, entry, index)
end

```

### loadFoldingPartFromXML

**Description**

> Load folding part from xml

**Definition**

> loadFoldingPartFromXML(table xmlFile, string baseKey, table foldingPart)

**Arguments**

| table  | xmlFile     | xml file object   |
|--------|-------------|-------------------|
| string | baseKey     | xml key           |
| table  | foldingPart | folding part data |

**Return Values**

| table | success | successfully loaded folding part |
|-------|---------|----------------------------------|

**Code**

```lua
function Foldable:loadFoldingPartFromXML(xmlFile, baseKey, foldingPart)
    local isValid = false

    foldingPart.speedScale = xmlFile:getValue(baseKey .. "#speedScale" , 1 )
    if foldingPart.speedScale < = 0 then
        Logging.xmlWarning(xmlFile, "Negative speed scale for folding part '%s' not allowed!" , baseKey)
            return false
        end

        local componentJointIndex = xmlFile:getValue(baseKey .. "#componentJointIndex" )
        local componentJoint = nil
        if componentJointIndex ~ = nil then
            if componentJointIndex = = 0 then
                Logging.xmlWarning(xmlFile, "Invalid componentJointIndex for folding part '%s'.Indexing starts with 1!" , baseKey)
                    return false
                else
                        componentJoint = self.componentJoints[componentJointIndex]
                        foldingPart.componentJoint = componentJoint
                    end
                end
                foldingPart.anchorActor = xmlFile:getValue( baseKey .. "#anchorActor" , 0 )

                foldingPart.animCharSet = 0

                local rootNode = xmlFile:getValue(baseKey .. "#rootNode" , nil , self.components, self.i3dMappings)
                if rootNode ~ = nil then
                    local animCharSet = getAnimCharacterSet(rootNode)
                    if animCharSet ~ = 0 then
                        local clip = getAnimClipIndex(animCharSet, xmlFile:getValue(baseKey .. "#animationClip" ))
                        if clip > = 0 then
                            isValid = true

                            foldingPart.animCharSet = animCharSet
                            assignAnimTrackClip(foldingPart.animCharSet, 0 , clip)
                            setAnimTrackLoopState(foldingPart.animCharSet, 0 , false )
                            foldingPart.animDuration = getAnimClipDuration(foldingPart.animCharSet, clip)
                        end
                    end
                end

                if not isValid then
                    if SpecializationUtil.hasSpecialization( AnimatedVehicle , self.specializations) then
                        local animationName = xmlFile:getValue(baseKey .. "#animationName" )
                        if animationName ~ = nil then
                            if self:getAnimationExists(animationName) then
                                foldingPart.animDuration = self:getAnimationDuration(animationName)
                                if foldingPart.animDuration > 0 then
                                    isValid = true
                                    foldingPart.animationName = animationName

                                    local animation = self:getAnimationByName(animationName)
                                    animation.resetOnStart = true
                                else
                                        Logging.xmlWarning(xmlFile, "Empty animation in folding part '%s'" , baseKey)
                                    end
                                end
                            end
                        else
                                if xmlFile:getValue(baseKey .. "#animationName" ) ~ = nil then
                                    Logging.xmlWarning(xmlFile, "Found animationName in folding part '%s', but vehicle has no animations!" , baseKey)
                                    return false
                                end
                            end
                        end

                        if not isValid then
                            Logging.xmlWarning(xmlFile, "Invalid folding part '%s'.Either a animationClip or animationName needs to be defined!" , baseKey)
                            return false
                        end

                        local distance = xmlFile:getValue(baseKey .. "#delayDistance" )
                        if distance ~ = nil then
                            foldingPart.delayedLowering = { }

                            foldingPart.delayedLowering.distance = distance
                            foldingPart.delayedLowering.previousDuration = xmlFile:getValue(baseKey .. "#previousDuration" , 1 ) * 1000
                            foldingPart.delayedLowering.loweringDuration = xmlFile:getValue(baseKey .. "#loweringDuration" , 1 ) * 1000
                            foldingPart.delayedLowering.maxDelayDuration = xmlFile:getValue(baseKey .. "#maxDelayDuration" , 7.5 ) * 1000
                            foldingPart.delayedLowering.aiSkipDelay = xmlFile:getValue(baseKey .. "#aiSkipDelay" , false )
                            foldingPart.delayedLowering.skipDelayOnReverse = xmlFile:getValue(baseKey .. "#skipDelayOnReverse" , true )
                            foldingPart.delayedLowering.currentDistance = - 1
                            foldingPart.delayedLowering.startTime = math.huge
                            foldingPart.delayedLowering.speedScale = 0
                            foldingPart.delayedLowering.animTime = 0
                            foldingPart.delayedLowering.stopAnimTime = 0
                            foldingPart.delayedLowering.prevDistance = nil
                        end

                        if componentJoint ~ = nil then
                            local node = self.components[componentJoint.componentIndices[((foldingPart.anchorActor + 1 ) % 2 ) + 1 ] ].node
                            foldingPart.x, foldingPart.y, foldingPart.z = worldToLocal(componentJoint.jointNode, getWorldTranslation(node))
                            foldingPart.upX, foldingPart.upY, foldingPart.upZ = worldDirectionToLocal(componentJoint.jointNode, localDirectionToWorld(node, 0 , 1 , 0 ))
                            foldingPart.dirX, foldingPart.dirY, foldingPart.dirZ = worldDirectionToLocal(componentJoint.jointNode, localDirectionToWorld(node, 0 , 0 , 1 ))
                        end

                        return true
                    end

```

### loadGroundAdjustedNodeFromXML

**Description**

**Definition**

> loadGroundAdjustedNodeFromXML()

**Arguments**

| any | superFunc    |
|-----|--------------|
| any | xmlFile      |
| any | key          |
| any | adjustedNode |

**Code**

```lua
function Foldable:loadGroundAdjustedNodeFromXML(superFunc, xmlFile, key, adjustedNode)
    if not superFunc( self , xmlFile, key, adjustedNode) then
        return false
    end

    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#foldMinLimit" , key .. ".foldable#minLimit" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#foldMaxLimit" , key .. ".foldable#maxLimit" ) --FS17 to FS19

    adjustedNode.foldMinLimit = xmlFile:getValue(key .. ".foldable#minLimit" , 0 )
    adjustedNode.foldMaxLimit = xmlFile:getValue(key .. ".foldable#maxLimit" , 1 )

    return true
end

```

### loadGroundReferenceNode

**Description**

**Definition**

> loadGroundReferenceNode()

**Arguments**

| any | superFunc           |
|-----|---------------------|
| any | xmlFile             |
| any | key                 |
| any | groundReferenceNode |

**Code**

```lua
function Foldable:loadGroundReferenceNode(superFunc, xmlFile, key, groundReferenceNode)
    local returnValue = superFunc( self , xmlFile, key, groundReferenceNode)

    if returnValue then
        groundReferenceNode.foldMinLimit = xmlFile:getValue(key .. ".folding#minLimit" , 0 )
        groundReferenceNode.foldMaxLimit = xmlFile:getValue(key .. ".folding#maxLimit" , 1 )
    end

    return returnValue
end

```

### loadInputAttacherJoint

**Description**

**Definition**

> loadInputAttacherJoint()

**Arguments**

| any | superFunc          |
|-----|--------------------|
| any | xmlFile            |
| any | key                |
| any | inputAttacherJoint |
| any | index              |

**Code**

```lua
function Foldable:loadInputAttacherJoint(superFunc, xmlFile, key, inputAttacherJoint, index)
    inputAttacherJoint.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" )
    inputAttacherJoint.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" )

    return superFunc( self , xmlFile, key, inputAttacherJoint, index)
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
function Foldable:loadLevelerNodeFromXML(superFunc, levelerNode, xmlFile, key)
    levelerNode.foldLimitedOuterRange = xmlFile:getValue(key .. "#foldLimitedOuterRange" , false )
    local minFoldLimit = 0
    local maxFoldLimit = 1
    if levelerNode.foldLimitedOuterRange then
        minFoldLimit = 0.5
        maxFoldLimit = 0.5
    end
    levelerNode.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , minFoldLimit)
    levelerNode.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , maxFoldLimit)

    return superFunc( self , levelerNode, xmlFile, key)
end

```

### loadMovingPartFromXML

**Description**

**Definition**

> loadMovingPartFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function Foldable:loadMovingPartFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    entry.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

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
function Foldable:loadMovingToolFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    entry.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    entry.hasRequiredFoldingConfiguration = true
    if self.configurations[ "folding" ] ~ = nil then
        local foldingConfigurationIndex = xmlFile:getValue(key .. "#foldingConfigurationIndex" )
        if foldingConfigurationIndex ~ = nil then
            if self.configurations[ "folding" ] ~ = foldingConfigurationIndex then
                entry.hasRequiredFoldingConfiguration = false
            end
        end
        local foldingConfigurationIndices = xmlFile:getValue(key .. "#foldingConfigurationIndices" , nil , true )
        if foldingConfigurationIndices ~ = nil and #foldingConfigurationIndices > 0 then
            entry.hasRequiredFoldingConfiguration = false
            for i = 1 , #foldingConfigurationIndices do
                if self.configurations[ "folding" ] = = foldingConfigurationIndices[i] then
                    entry.hasRequiredFoldingConfiguration = true
                    break
                end
            end
        end
    end

    return true
end

```

### loadPickupFromXML

**Description**

**Definition**

> loadPickupFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | spec      |

**Code**

```lua
function Foldable:loadPickupFromXML(superFunc, xmlFile, key, spec)
    spec.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    spec.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return superFunc( self , xmlFile, key, spec)
end

```

### loadPreprunerNodeFromXML

**Description**

**Definition**

> loadPreprunerNodeFromXML()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | xmlFile    |
| any | key        |
| any | prunerNode |

**Code**

```lua
function Foldable:loadPreprunerNodeFromXML(superFunc, xmlFile, key, prunerNode)
    if not superFunc( self , xmlFile, key, prunerNode) then
        return false
    end

    prunerNode.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    prunerNode.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return true
end

```

### loadShovelNode

**Description**

**Definition**

> loadShovelNode()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | xmlFile    |
| any | key        |
| any | shovelNode |

**Code**

```lua
function Foldable:loadShovelNode(superFunc, xmlFile, key, shovelNode)
    superFunc( self , xmlFile, key, shovelNode)

    shovelNode.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    shovelNode.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return true
end

```

### loadSlopeCompensationNodeFromXML

**Description**

**Definition**

> loadSlopeCompensationNodeFromXML()

**Arguments**

| any | superFunc        |
|-----|------------------|
| any | compensationNode |
| any | xmlFile          |
| any | key              |

**Code**

```lua
function Foldable:loadSlopeCompensationNodeFromXML(superFunc, compensationNode, xmlFile, key)
    compensationNode.foldAngleScale = xmlFile:getValue(key .. "#foldAngleScale" )
    compensationNode.invertFoldAngleScale = xmlFile:getValue(key .. "#invertFoldAngleScale" , false )

    return superFunc( self , compensationNode, xmlFile, key)
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
function Foldable:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    if not superFunc( self , speedRotatingPart, xmlFile, key) then
        return false
    end

    speedRotatingPart.foldLimitedOuterRange = xmlFile:getValue(key .. "#foldLimitedOuterRange" , false )
    local minFoldLimit = 0
    local maxFoldLimit = 1
    if speedRotatingPart.foldLimitedOuterRange then
        minFoldLimit = 0.5
        maxFoldLimit = 0.5
    end
    speedRotatingPart.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , minFoldLimit)
    speedRotatingPart.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , maxFoldLimit)

    return true
end

```

### loadSprayTypeFromXML

**Description**

**Definition**

> loadSprayTypeFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | sprayType |

**Code**

```lua
function Foldable:loadSprayTypeFromXML(superFunc, xmlFile, key, sprayType)
    sprayType.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" )
    sprayType.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" )

    sprayType.hasRequiredFoldingConfiguration = true
    if self.configurations[ "folding" ] ~ = nil then
        local foldingConfigurationIndex = xmlFile:getValue(key .. "#foldingConfigurationIndex" )
        if foldingConfigurationIndex ~ = nil then
            if self.configurations[ "folding" ] ~ = foldingConfigurationIndex then
                sprayType.hasRequiredFoldingConfiguration = false
            end
        end
        local foldingConfigurationIndices = xmlFile:getValue(key .. "#foldingConfigurationIndices" , nil , true )
        if foldingConfigurationIndices ~ = nil and #foldingConfigurationIndices > 0 then
            sprayType.hasRequiredFoldingConfiguration = false
            for i = 1 , #foldingConfigurationIndices do
                if self.configurations[ "folding" ] = = foldingConfigurationIndices[i] then
                    sprayType.hasRequiredFoldingConfiguration = true
                    break
                end
            end
        end
    end

    return superFunc( self , xmlFile, key, sprayType)
end

```

### loadSteeringAngleNodeFromXML

**Description**

**Definition**

> loadSteeringAngleNodeFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | entry     |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function Foldable:loadSteeringAngleNodeFromXML(superFunc, entry, xmlFile, key)
    if not superFunc( self , entry, xmlFile, key) then
        return false
    end

    entry.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    entry.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return true
end

```

### loadSteeringAxleFromXML

**Description**

**Definition**

> loadSteeringAxleFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | spec      |
| any | xmlFile   |
| any | key       |

**Code**

```lua
function Foldable:loadSteeringAxleFromXML(superFunc, spec, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#foldMinLimit" , key .. ".folding#minLimit" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#foldMaxLimit" , key .. ".folding#maxLimit" ) --FS19 to FS22

    spec.foldMinLimit = xmlFile:getValue(key .. ".folding#minLimit" , 0 )
    spec.foldMaxLimit = xmlFile:getValue(key .. ".folding#maxLimit" , 1 )

    return superFunc( self , spec, xmlFile, key)
end

```

### loadSupportAnimationFromXML

**Description**

> Loads support animation from xml

**Definition**

> loadSupportAnimationFromXML(table spec, integer xmlFile, string key, )

**Arguments**

| table   | spec    | spec             |
|---------|---------|------------------|
| integer | xmlFile | xmlFile id       |
| string  | key     | key to load from |
| any     | key     |                  |

**Code**

```lua
function Foldable:loadSupportAnimationFromXML(superFunc, supportAnimation, xmlFile, key)
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#foldMinLimit" , key .. ".folding#minLimit" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, key .. "#foldMaxLimit" , key .. ".folding#maxLimit" ) --FS19 to FS22

    supportAnimation.foldMinLimit = xmlFile:getValue(key .. ".folding#minLimit" , 0 )
    supportAnimation.foldMaxLimit = xmlFile:getValue(key .. ".folding#maxLimit" , 1 )

    return superFunc( self , supportAnimation, xmlFile, key)
end

```

### loadSuspensionNodeFromXML

**Description**

**Definition**

> loadSuspensionNodeFromXML()

**Arguments**

| any | superFunc      |
|-----|----------------|
| any | xmlFile        |
| any | key            |
| any | suspensionNode |

**Code**

```lua
function Foldable:loadSuspensionNodeFromXML(superFunc, xmlFile, key, suspensionNode)
    if not superFunc( self , xmlFile, key, suspensionNode) then
        return false
    end

    suspensionNode.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    suspensionNode.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return true
end

```

### loadTurnedOnAnimationFromXML

**Description**

**Definition**

> loadTurnedOnAnimationFromXML()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | xmlFile           |
| any | key               |
| any | turnedOnAnimation |

**Code**

```lua
function Foldable:loadTurnedOnAnimationFromXML(superFunc, xmlFile, key, turnedOnAnimation)
    turnedOnAnimation.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    turnedOnAnimation.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

    return superFunc( self , xmlFile, key, turnedOnAnimation)
end

```

### loadWheelFromXML

**Description**

**Definition**

> loadWheelFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | wheel     |

**Code**

```lua
function Foldable:loadWheelFromXML(superFunc, wheel)
    wheel.versatileFoldMinLimit = wheel.xmlObject:getValue( "#versatileFoldMinLimit" , 0 )
    wheel.versatileFoldMaxLimit = wheel.xmlObject:getValue( "#versatileFoldMaxLimit" , 1 )

    return superFunc( self , wheel)
end

```

### loadWoodHarvesterHeaderTiltFromXML

**Description**

**Definition**

> loadWoodHarvesterHeaderTiltFromXML()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | headerTilt |
| any | xmlFile    |
| any | key        |

**Code**

```lua
function Foldable:loadWoodHarvesterHeaderTiltFromXML(superFunc, headerTilt, xmlFile, key)
    if not superFunc( self , headerTilt, xmlFile, key) then
        return false
    end

    headerTilt.foldMinLimit = xmlFile:getValue(key .. "#foldMinLimit" , 0 )
    headerTilt.foldMaxLimit = xmlFile:getValue(key .. "#foldMaxLimit" , 1 )

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
function Foldable:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    workArea.foldLimitedOuterRange = xmlFile:getValue(key .. "#foldLimitedOuterRange" , false )
    local minFoldLimit = 0
    local maxFoldLimit = 1
    if workArea.foldLimitedOuterRange then
        minFoldLimit = 0.5
        maxFoldLimit = 0.5
    end

    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#foldMinLimit" , key .. ".folding#minLimit" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#foldMaxLimit" , key .. ".folding#maxLimit" ) --FS17 to FS19

    workArea.foldMinLimit = xmlFile:getValue(key .. ".folding#minLimit" , minFoldLimit)
    workArea.foldMaxLimit = xmlFile:getValue(key .. ".folding#maxLimit" , maxFoldLimit)

    return superFunc( self , workArea, xmlFile, key)
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function Foldable:onDeactivate()
    -- keep on folding while on mobile version since tools are folded when detached
        local spec = self.spec_foldable
        if not spec.keepFoldingWhileDetached and not spec.lowerWhileDetach and not spec.foldWhileDetach then
            self:setFoldDirection( 0 , true )
        end
    end

```

### onDynamicMountTypeChanged

**Description**

**Definition**

> onDynamicMountTypeChanged()

**Arguments**

| any | dynamicMountType |
|-----|------------------|
| any | mountObject      |

**Code**

```lua
function Foldable:onDynamicMountTypeChanged(dynamicMountType, mountObject)
    if dynamicMountType ~ = MountableObject.MOUNT_TYPE_NONE then
        self:setFoldDirection( 0 , true )
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
function Foldable:onLoad(savegame)
    local spec = self.spec_foldable

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.foldingParts" , "vehicle.foldable.foldingConfigurations.foldingConfiguration.foldingParts" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.foldable.foldingParts" , "vehicle.foldable.foldingConfigurations.foldingConfiguration.foldingParts" ) --FS19 to FS21

    local foldingConfigurationId = Utils.getNoNil( self.configurations[ "folding" ], 1 )
    local configKey = string.format( "vehicle.foldable.foldingConfigurations.foldingConfiguration(%d).foldingParts" , foldingConfigurationId - 1 )

    spec.isFoldAllowed = true
    spec.objectText = self.xmlFile:getValue(configKey .. "#objectText" , self.typeDesc, self.customEnvironment, false )
    spec.posDirectionText = string.format( self.xmlFile:getValue(configKey .. "#posDirectionText" , "action_foldOBJECT" , self.customEnvironment, false ), spec.objectText)
    spec.negDirectionText = string.format( self.xmlFile:getValue(configKey .. "#negDirectionText" , "action_unfoldOBJECT" , self.customEnvironment, false ), spec.objectText)
    spec.middlePosDirectionText = string.format( self.xmlFile:getValue(configKey .. "#middlePosDirectionText" , "action_liftOBJECT" , self.customEnvironment, false ), spec.objectText)
    spec.middleNegDirectionText = string.format( self.xmlFile:getValue(configKey .. "#middleNegDirectionText" , "action_lowerOBJECT" , self.customEnvironment, false ), spec.objectText)

    spec.startAnimTime = self.xmlFile:getValue(configKey .. "#startAnimTime" )
    spec.foldMoveDirection = 0
    spec.moveToMiddle = false
    if spec.startAnimTime = = nil then
        spec.startAnimTime = 0
        local startMoveDirection = self.xmlFile:getValue(configKey .. "#startMoveDirection" , 0 )
        if startMoveDirection > 0.1 then
            spec.startAnimTime = 1
        end
    end
    spec.turnOnFoldDirection = 1
    if spec.startAnimTime > 0.5 then
        spec.turnOnFoldDirection = - 1
    end

    spec.turnOnFoldDirection = math.sign( self.xmlFile:getValue(configKey .. "#turnOnFoldDirection" , spec.turnOnFoldDirection))
    if spec.turnOnFoldDirection = = 0 then
        Logging.xmlWarning( self.xmlFile, "Foldable 'turnOnFoldDirection' not allowed to be 0! Only -1 and 1 are allowed" )
        spec.turnOnFoldDirection = - 1
    end

    spec.allowUnfoldingByAI = self.xmlFile:getValue(configKey .. "#allowUnfoldingByAI" , true )

    local foldInputButtonStr = self.xmlFile:getValue(configKey .. "#foldInputButton" )
    if foldInputButtonStr ~ = nil then
        spec.foldInputButton = InputAction[foldInputButtonStr]
    end
    spec.foldInputButton = Utils.getNoNil(spec.foldInputButton, InputAction.IMPLEMENT_EXTRA2)

    local foldMiddleInputButtonStr = self.xmlFile:getValue(configKey .. "#foldMiddleInputButton" )
    if foldMiddleInputButtonStr ~ = nil then
        spec.foldMiddleInputButton = InputAction[foldMiddleInputButtonStr]
    end
    spec.foldMiddleInputButton = Utils.getNoNil(spec.foldMiddleInputButton, InputAction.LOWER_IMPLEMENT)

    spec.foldMiddleAnimTime = self.xmlFile:getValue(configKey .. "#foldMiddleAnimTime" )
    spec.foldMiddleDirection = self.xmlFile:getValue(configKey .. "#foldMiddleDirection" , 1 )
    spec.foldMiddleAIRaiseDirection = self.xmlFile:getValue(configKey .. "#foldMiddleAIRaiseDirection" , spec.foldMiddleDirection)

    spec.turnOnFoldMaxLimit = self.xmlFile:getValue(configKey .. "#turnOnFoldMaxLimit" , 1 )
    spec.turnOnFoldMinLimit = self.xmlFile:getValue(configKey .. "#turnOnFoldMinLimit" , 0 )
    spec.toggleCoverMaxLimit = self.xmlFile:getValue(configKey .. "#toggleCoverMaxLimit" , 1 )
    spec.toggleCoverMinLimit = self.xmlFile:getValue(configKey .. "#toggleCoverMinLimit" , 0 )
    spec.detachingMaxLimit = self.xmlFile:getValue(configKey .. "#detachingMaxLimit" , 1 )
    spec.detachingMinLimit = self.xmlFile:getValue(configKey .. "#detachingMinLimit" , 0 )
    spec.attachingMaxLimit = self.xmlFile:getValue(configKey .. "#attachingMaxLimit" , 1 )
    spec.attachingMinLimit = self.xmlFile:getValue(configKey .. "#attachingMinLimit" , 0 )
    spec.allowDetachingWhileFolding = self.xmlFile:getValue(configKey .. "#allowDetachingWhileFolding" , false )
    spec.loweringMaxLimit = self.xmlFile:getValue(configKey .. "#loweringMaxLimit" , 1 )
    spec.loweringMinLimit = self.xmlFile:getValue(configKey .. "#loweringMinLimit" , 0 )
    spec.loadMovingToolStatesMaxLimit = self.xmlFile:getValue(configKey .. "#loadMovingToolStatesMaxLimit" , 1 )
    spec.loadMovingToolStatesMinLimit = self.xmlFile:getValue(configKey .. "#loadMovingToolStatesMinLimit" , 0 )
    spec.dynamicMountMinLimit = self.xmlFile:getValue(configKey .. "#dynamicMountMinLimit" , 0 )
    spec.dynamicMountMaxLimit = self.xmlFile:getValue(configKey .. "#dynamicMountMaxLimit" , 1 )
    spec.crabSteeringMinLimit = self.xmlFile:getValue(configKey .. "#crabSteeringMinLimit" , 0 )
    spec.crabSteeringMaxLimit = self.xmlFile:getValue(configKey .. "#crabSteeringMaxLimit" , 1 )
    spec.toggleFoldingMinLimit = self.xmlFile:getValue(configKey .. ".toggleFolding#minLimit" , 0 )
    spec.toggleFoldingMaxLimit = self.xmlFile:getValue(configKey .. ".toggleFolding#maxLimit" , 1 )
    spec.toggleFoldingBlockedDirection = self.xmlFile:getValue(configKey .. ".toggleFolding#blockedDirection" , 0 )
    spec.unfoldWarning = string.format( self.xmlFile:getValue(configKey .. "#unfoldWarning" , "warning_firstUnfoldTheTool" , self.customEnvironment, false ), spec.objectText)
    spec.detachWarning = string.format( self.xmlFile:getValue(configKey .. "#detachWarning" , "warning_doNotDetachWhileFolding" , self.customEnvironment, false ), spec.objectText)

    spec.useParentFoldingState = self.xmlFile:getValue(configKey .. "#useParentFoldingState" , false )
    spec.subFoldingStateVehicles = { }

    spec.ignoreFoldMiddleWhileFolded = self.xmlFile:getValue(configKey .. "#ignoreFoldMiddleWhileFolded" , false )
    spec.lowerWhileDetach = self.xmlFile:getValue(configKey .. "#lowerWhileDetach" , false )
    spec.foldWhileDetach = self.xmlFile:getValue(configKey .. "#foldWhileDetach" , false )
    spec.keepFoldingWhileDetached = self.xmlFile:getValue(configKey .. "#keepFoldingWhileDetached" , Platform.gameplay.keepFoldingWhileDetached)
    spec.releaseBrakesWhileFolding = self.xmlFile:getValue(configKey .. "#releaseBrakesWhileFolding" , false )
    spec.requiresPower = self.xmlFile:getValue(configKey .. "#requiresPower" , true )
    spec.allowControlWhileFolding = self.xmlFile:getValue(configKey .. "#allowControlWhileFolding" , true )

    spec.foldAnimTime = 0
    spec.maxFoldAnimDuration = 0.0001

    spec.foldingParts = { }
    local i = 0
    while true do
        local baseKey = string.format(configKey .. ".foldingPart(%d)" , i)
        if not self.xmlFile:hasProperty(baseKey) then
            break
        end

        local foldingPart = { }
        if self:loadFoldingPartFromXML( self.xmlFile, baseKey, foldingPart) then
            table.insert(spec.foldingParts, foldingPart)
            spec.maxFoldAnimDuration = math.max(spec.maxFoldAnimDuration, foldingPart.animDuration)
        end

        i = i + 1
    end

    spec.hasFoldingParts = #spec.foldingParts > 0

    spec.actionEventsLowering = { }

    if spec.hasFoldingParts then
        if savegame ~ = nil and not savegame.resetVehicles then
            spec.loadedFoldAnimTime = savegame.xmlFile:getValue(savegame.key .. ".foldable#foldAnimTime" )
            spec.isFoldAllowed = savegame.xmlFile:getValue(savegame.key .. ".foldable#isAllowed" , spec.isFoldAllowed)
        end
    end

    if spec.loadedFoldAnimTime = = nil then
        spec.loadedFoldAnimTime = spec.startAnimTime
    end

    if self.vehicleLoadingData:getCustomParameter( "foldableInvertFoldState" ) then
        spec.loadedFoldAnimTime = 1 - spec.loadedFoldAnimTime
    else
            local foldAnimTime = self.vehicleLoadingData:getCustomParameter( "foldableFoldingTime" )
            if foldAnimTime ~ = nil then
                spec.loadedFoldAnimTime = foldAnimTime
            end
        end
    end

```

### onLoadWheelChockFromXML

**Description**

**Definition**

> onLoadWheelChockFromXML()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | wheelChock |
| any | xmlObject  |
| any | key        |

**Code**

```lua
function Foldable:onLoadWheelChockFromXML(superFunc, wheelChock, xmlObject, key)
    superFunc( self )

    wheelChock.foldMinLimit = xmlObject:getValue(key .. "#foldMinLimit" , 0 )
    wheelChock.foldMaxLimit = xmlObject:getValue(key .. "#foldMaxLimit" , 1 )
end

```

### onPostAttach

**Description**

**Definition**

> onPostAttach()

**Arguments**

| any | attacherVehicle     |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |

**Code**

```lua
function Foldable:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_foldable
    if spec.lowerWhileDetach then
        if attacherVehicle ~ = nil then
            local jointDesc = attacherVehicle:getAttacherJointByJointDescIndex(jointDescIndex)
            if not jointDesc.moveDown then
                if self:getFoldAnimTime() < 0.001 then
                    self:setFoldState( 1 , true , true )
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
function Foldable:onPostLoad(savegame)
    local spec = self.spec_foldable
    Foldable.setAnimTime( self , spec.loadedFoldAnimTime, false )

    if #spec.foldingParts = = 0 or spec.useParentFoldingState then
        SpecializationUtil.removeEventListener( self , "onReadStream" , Foldable )
        SpecializationUtil.removeEventListener( self , "onWriteStream" , Foldable )
        SpecializationUtil.removeEventListener( self , "onUpdate" , Foldable )
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , Foldable )
        SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , Foldable )
        SpecializationUtil.removeEventListener( self , "onRegisterExternalActionEvents" , Foldable )
        SpecializationUtil.removeEventListener( self , "onDeactivate" , Foldable )
        SpecializationUtil.removeEventListener( self , "onSetLoweredAll" , Foldable )
        SpecializationUtil.removeEventListener( self , "onPostAttach" , Foldable )
        SpecializationUtil.removeEventListener( self , "onPreDetach" , Foldable )
        SpecializationUtil.removeEventListener( self , "onDynamicMountTypeChanged" , Foldable )
    end
end

```

### onPreAttachImplement

**Description**

> Called if vehicle gets detached

**Definition**

> onPreAttachImplement(table attacherVehicle, table implement, , )

**Arguments**

| table | attacherVehicle  | attacher vehicle |
|-------|------------------|------------------|
| table | implement        | implement        |
| any   | jointDescIndex   |                  |
| any   | loadFromSavegame |                  |

**Code**

```lua
function Foldable:onPreAttachImplement(object, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local subSpec = object.spec_foldable
    if subSpec ~ = nil then
        if subSpec.useParentFoldingState then
            self.spec_foldable.subFoldingStateVehicles[object] = object
            Foldable.setAnimTime(object, self.spec_foldable.foldAnimTime, false )
        end
    end
end

```

### onPreDetach

**Description**

> Called if vehicle gets detached

**Definition**

> onPreDetach(table attacherVehicle, table implement)

**Arguments**

| table | attacherVehicle | attacher vehicle |
|-------|-----------------|------------------|
| table | implement       | implement        |

**Code**

```lua
function Foldable:onPreDetach(attacherVehicle, implement)
    local spec = self.spec_foldable
    if spec.lowerWhileDetach and spec.foldMiddleAnimTime ~ = nil then
        local foldAnimTime = self:getFoldAnimTime()
        if math.abs(foldAnimTime - spec.foldMiddleAnimTime) < 0.001 then
            self:setFoldState( - 1 , false , true )
        end
    elseif spec.foldWhileDetach then
            self:setFoldState( - spec.turnOnFoldDirection, false , true )
        end
    end

```

### onPreDetachImplement

**Description**

> Called if vehicle gets detached

**Definition**

> onPreDetachImplement(table attacherVehicle, table implement)

**Arguments**

| table | attacherVehicle | attacher vehicle |
|-------|-----------------|------------------|
| table | implement       | implement        |

**Code**

```lua
function Foldable:onPreDetachImplement(implement)
    local subSpec = implement.object.spec_foldable
    if subSpec ~ = nil then
        if subSpec.useParentFoldingState then
            self.spec_foldable.subFoldingStateVehicles[implement.object] = nil
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
function Foldable:onReadStream(streamId, connection)
    local direction = streamReadUIntN(streamId, 2 ) - 1
    local moveToMiddle = streamReadBool(streamId)
    local animTime = streamReadFloat32(streamId)
    Foldable.setAnimTime( self , animTime, false )
    self:setFoldState(direction, moveToMiddle, true )
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
function Foldable:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_foldable
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            local isOnlyLowering = spec.foldMiddleAnimTime ~ = nil and spec.foldMiddleAnimTime = = 1
            if not isOnlyLowering then
                local _, actionEventId
                if spec.requiresPower then
                    _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, spec.foldInputButton, self , Foldable.actionEventFold, false , true , false , true , nil )
                else
                        _, actionEventId = self:addActionEvent(spec.actionEvents, spec.foldInputButton, self , Foldable.actionEventFold, false , true , false , true , nil )
                    end

                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
                    Foldable.updateActionEventFold( self )

                    _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.FOLD_ALL_IMPLEMENTS, self , Foldable.actionEventFoldAll, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                end
            end
        end
    end

```

### onRegistered

**Description**

**Definition**

> onRegistered()

**Code**

```lua
function Foldable:onRegistered()
    local spec = self.spec_foldable
    if not spec.allowControlWhileFolding then
        if self.registerPlayerVehicleControlAllowedFunction ~ = nil then
            self:registerPlayerVehicleControlAllowedFunction( self , Foldable.getIsVehicleControlAllowed)
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
function Foldable:onRegisterExternalActionEvents(trigger, name, xmlFile, key)
    if name = = "folding" then
        local spec = self.spec_foldable
        if spec.hasFoldingParts then
            self:registerExternalActionEvent(trigger, name, Foldable.externalActionEventRegister, Foldable.externalActionEventUpdate)
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
function Foldable:onRootVehicleChanged(rootVehicle)
    local spec = self.spec_foldable
    if spec.hasFoldingParts then
        local actionController = rootVehicle.actionController
        if actionController ~ = nil then
            if spec.controlledActionFold ~ = nil then
                spec.controlledActionFold:updateParent(actionController)

                if spec.controlledActionLower ~ = nil then
                    spec.controlledActionLower:updateParent(actionController)
                end

                if spec.controlledActionLowerAIStart ~ = nil then
                    spec.controlledActionLowerAIStart:updateParent(actionController)
                end

                return
            end

            spec.controlledActionFold = actionController:registerAction( "fold" , spec.toggleTurnOnInputBinding, 4 )
            spec.controlledActionFold:setCallback( self , Foldable.actionControllerFoldEvent)
            spec.controlledActionFold:setFinishedFunctions( self , function (vehicle)
                if spec.turnOnFoldDirection < 0 then
                    local foldTime = vehicle:getFoldAnimTime()
                    return foldTime = = 1 or foldTime < = (spec.foldMiddleAnimTime or 0 )
                else
                        local foldTime = vehicle:getFoldAnimTime()
                        return foldTime = = 0 or foldTime > = (spec.foldMiddleAnimTime or 1 )
                    end
                end , true , true )
                if spec.allowUnfoldingByAI then
                    spec.controlledActionFold:addAIEventListener( self , "onAIFieldWorkerPrepareForWork" , 1 )
                    spec.controlledActionFold:addAIEventListener( self , "onAIImplementPrepareForWork" , 1 )

                    spec.controlledActionFold:addAIEventListener( self , "onAIImplementPrepareForTransport" , - 1 , true )

                    if Platform.gameplay.foldAfterAIFinished then
                        spec.controlledActionFold:addAIEventListener( self , "onAIImplementEnd" , - 1 , true )
                        spec.controlledActionFold:addAIEventListener( self , "onAIFieldWorkerEnd" , - 1 )
                    end
                end

                if self:getIsFoldMiddleAllowed() then
                    spec.controlledActionLower = actionController:registerAction( "lowerFoldable" , spec.toggleTurnOnInputBinding, 3 )
                    spec.controlledActionLower:setCallback( self , Foldable.actionControllerLowerEvent)
                    spec.controlledActionLower:setFinishedFunctions( self , self.getFoldAnimTime, spec.turnOnFoldDirection < 0 and 0 or 1 , spec.foldMiddleAnimTime)
                    spec.controlledActionLower:setResetOnDeactivation( false )
                    if spec.allowUnfoldingByAI then
                        spec.controlledActionLower:addAIEventListener( self , "onAIImplementStartLine" , 1 )
                        spec.controlledActionLower:addAIEventListener( self , "onAIImplementEndLine" , - 1 )
                    end

                    spec.controlledActionLowerAIStart = actionController:registerAction( "lowerFoldableAIStart" , spec.toggleTurnOnInputBinding, 3 )
                    spec.controlledActionLowerAIStart:setCallback( self , Foldable.actionControllerLowerEventAIStart)
                    spec.controlledActionLowerAIStart:setFinishedFunctions( self , self.getFoldAnimTime, spec.turnOnFoldDirection < 0 and 0 or 1 , spec.foldMiddleAnimTime)
                    spec.controlledActionLowerAIStart:setResetOnDeactivation( false )
                    if spec.allowUnfoldingByAI then
                        spec.controlledActionLowerAIStart:addAIEventListener( self , "onAIImplementStart" , - 1 )
                    end
                end
            else
                    if spec.controlledActionFold ~ = nil then
                        spec.controlledActionFold:remove()
                    end
                    if spec.controlledActionLower ~ = nil then
                        spec.controlledActionLower:remove()
                    end
                    if spec.controlledActionLowerAIStart ~ = nil then
                        spec.controlledActionLowerAIStart:remove()
                    end
                end
            end
        end

```

### onSetLoweredAll

**Description**

**Definition**

> onSetLoweredAll()

**Arguments**

| any | doLowering     |
|-----|----------------|
| any | jointDescIndex |

**Code**

```lua
function Foldable:onSetLoweredAll(doLowering, jointDescIndex)
    self:setFoldMiddleState(doLowering)
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
function Foldable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_foldable
    if math.abs(spec.foldMoveDirection) > 0.1 then
        local isInvalid = false
        local foldAnimTime = 0
        if spec.foldMoveDirection < - 0.1 then
            foldAnimTime = 1
        end
        for _,foldingPart in pairs(spec.foldingParts) do
            local charSet = foldingPart.animCharSet
            if spec.foldMoveDirection > 0 then
                local animTime
                if charSet ~ = 0 then
                    animTime = getAnimTrackTime(charSet, 0 )
                else
                        animTime = self:getRealAnimationTime(foldingPart.animationName)
                    end
                    if animTime < foldingPart.animDuration then
                        isInvalid = true
                    end
                    foldAnimTime = math.max(foldAnimTime, animTime / spec.maxFoldAnimDuration)
                elseif spec.foldMoveDirection < 0 then
                        local animTime
                        if charSet ~ = 0 then
                            animTime = getAnimTrackTime(charSet, 0 )
                        else
                                animTime = self:getRealAnimationTime(foldingPart.animationName)
                            end
                            if animTime > 0 then
                                isInvalid = true
                            end
                            foldAnimTime = math.min(foldAnimTime, animTime / spec.maxFoldAnimDuration)
                        end
                    end
                    foldAnimTime = math.clamp(foldAnimTime, 0 , 1 )
                    if foldAnimTime ~ = spec.foldAnimTime then
                        spec.foldAnimTime = foldAnimTime
                        SpecializationUtil.raiseEvent( self , "onFoldTimeChanged" , spec.foldAnimTime)
                    end

                    if spec.foldMoveDirection > 0 then
                        if not spec.moveToMiddle or spec.foldMiddleAnimTime = = nil then
                            if spec.foldAnimTime = = 1 then
                                spec.foldMoveDirection = 0
                            end
                        else
                                if spec.foldAnimTime = = spec.foldMiddleAnimTime then
                                    spec.foldMoveDirection = 0
                                end
                            end
                        elseif spec.foldMoveDirection < 0 then
                                if not spec.moveToMiddle or spec.foldMiddleAnimTime = = nil then
                                    if spec.foldAnimTime = = 0 then
                                        spec.foldMoveDirection = 0
                                    end
                                else
                                        if spec.foldAnimTime = = spec.foldMiddleAnimTime then
                                            spec.foldMoveDirection = 0
                                        end
                                    end
                                end

                                if isInvalid and self.isServer then
                                    for _,foldingPart in pairs(spec.foldingParts) do
                                        if foldingPart.componentJoint ~ = nil then
                                            self:setComponentJointFrame(foldingPart.componentJoint, foldingPart.anchorActor)
                                        end
                                    end
                                end

                                for _, vehicle in pairs(spec.subFoldingStateVehicles) do
                                    Foldable.setAnimTime(vehicle, spec.foldAnimTime, false )
                                end

                                if not spec.allowControlWhileFolding then
                                    if self.brake ~ = nil then
                                        self:brake( self:getBrakeForce())
                                    end
                                end
                            end

                            for i = 1 , #spec.foldingParts do
                                local foldingPart = spec.foldingParts[i]

                                local delayedLowering = foldingPart.delayedLowering
                                if delayedLowering ~ = nil then
                                    if delayedLowering.currentDistance > = 0 then
                                        delayedLowering.currentDistance = delayedLowering.currentDistance + self.lastMovedDistance

                                        if delayedLowering.prevDistance = = nil and delayedLowering.startTime + delayedLowering.previousDuration < g_ time then
                                            delayedLowering.prevDistance = delayedLowering.currentDistance
                                        end

                                        local lowerDistance = self.lastSpeedReal * delayedLowering.loweringDuration
                                        local prevDistance = delayedLowering.prevDistance or( self.lastSpeedReal * delayedLowering.previousDuration)

                                        local distance = (delayedLowering.distance + prevDistance) - lowerDistance
                                        local force = g_ time > delayedLowering.startTime + delayedLowering.maxDelayDuration * math.clamp((delayedLowering.currentDistance / distance) * 0.5 + 0.5 , 0 , 1 )

                                        if delayedLowering.aiSkipDelay then
                                            force = force or self:getIsAIActive()
                                        end

                                        if delayedLowering.skipDelayOnReverse then
                                            force = force or( self:getLastSpeed() > 2.5 and self.movingDirection < 0 )
                                        end

                                        if delayedLowering.currentDistance > = distance or force then
                                            self:playAnimation(foldingPart.animationName, delayedLowering.speedScale, delayedLowering.animTime, true )

                                            if delayedLowering.stopAnimTime ~ = nil then
                                                self:setAnimationStopTime(foldingPart.animationName, delayedLowering.stopAnimTime)
                                            end

                                            delayedLowering.currentDistance = - 1
                                        end
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
function Foldable:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_foldable

    -- update actionEvents
    if self.isClient then
        Foldable.updateActionEventFold( self )
        if spec.foldMiddleAnimTime ~ = nil then
            Foldable.updateActionEventFoldMiddle( self )
        end
    end

    if self.isServer then
        -- after the tool has been unfolded we need to sync the attacher joint lowering state with the folding lowering state to be in line
        if spec.ignoreFoldMiddleWhileFolded and self.getAttacherVehicle ~ = nil then
            if math.abs(spec.foldAnimTime - spec.foldMiddleAnimTime) < 0.001 and(spec.foldMoveDirection = = 1 ) = = (spec.turnOnFoldDirection = = 1 ) then
                local attacherVehicle = self:getAttacherVehicle()
                if attacherVehicle ~ = nil then
                    local jointDesc = attacherVehicle:getAttacherJointDescFromObject( self )
                    if jointDesc.allowsLowering or jointDesc.isDefaultLowered then
                        if jointDesc.moveDown then
                            self:setFoldState( - 1 , false )
                        end
                    end
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
function Foldable:onWriteStream(streamId, connection)
    local spec = self.spec_foldable

    local direction = math.sign(spec.foldMoveDirection) + 1
    streamWriteUIntN(streamId, direction, 2 )
    streamWriteBool(streamId, spec.moveToMiddle)
    streamWriteFloat32(streamId, spec.foldAnimTime)
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
function Foldable.prerequisitesPresent(specializations)
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
function Foldable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegistered" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterExternalActionEvents" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onSetLoweredAll" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetach" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onRootVehicleChanged" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onPreAttachImplement" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetachImplement" , Foldable )
    SpecializationUtil.registerEventListener(vehicleType, "onDynamicMountTypeChanged" , Foldable )
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
function Foldable.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onFoldStateChanged" )
    SpecializationUtil.registerEvent(vehicleType, "onFoldTimeChanged" )
end

```

### registerFoldingXMLPaths

**Description**

**Definition**

> registerFoldingXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Foldable.registerFoldingXMLPaths(schema, basePath)
    schema:register(XMLValueType.L10N_STRING, basePath .. "#objectText" , "override OBJECT text inserted in folding action string" , "vehicle typeDesc" )
    schema:register(XMLValueType.L10N_STRING, basePath .. "#posDirectionText" , "Positive direction text" , "$l10n_action_foldOBJECT" )
    schema:register(XMLValueType.L10N_STRING, basePath .. "#negDirectionText" , "Negative direction text" , "$l10n_action_unfoldOBJECT" )
    schema:register(XMLValueType.L10N_STRING, basePath .. "#middlePosDirectionText" , "Positive middle direction text" , "$l10n_action_liftOBJECT" )
    schema:register(XMLValueType.L10N_STRING, basePath .. "#middleNegDirectionText" , "Negative middle direction text" , "$l10n_action_lowerOBJECT" )

    schema:register(XMLValueType.FLOAT, basePath .. "#startAnimTime" , "Start animation time" , "Depending on startMoveDirection" )
    schema:register(XMLValueType.INT, basePath .. "#startMoveDirection" , "Start move direction" , 0 )
    schema:register(XMLValueType.INT, basePath .. "#turnOnFoldDirection" , "Turn on fold direction" )
    schema:register(XMLValueType.BOOL, basePath .. "#allowUnfoldingByAI" , "Allow folding by AI" , true )

    schema:register(XMLValueType.STRING, basePath .. "#foldInputButton" , "Fold Input action" , "IMPLEMENT_EXTRA2" )
    schema:register(XMLValueType.STRING, basePath .. "#foldMiddleInputButton" , "Fold middle Input action" , "LOWER_IMPLEMENT" )

    schema:register(XMLValueType.FLOAT, basePath .. "#foldMiddleAnimTime" , "Fold middle anim time" )
    schema:register(XMLValueType.INT, basePath .. "#foldMiddleDirection" , "Fold middle direction" , 1 )
    schema:register(XMLValueType.INT, basePath .. "#foldMiddleAIRaiseDirection" , "Fold middle AI raise direction" , "same as foldMiddleDirection" )

    schema:register(XMLValueType.FLOAT, basePath .. "#turnOnFoldMaxLimit" , "Turn on fold max.limit" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. "#turnOnFoldMinLimit" , "Turn on fold min.limit" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#toggleCoverMaxLimit" , "Toggle cover fold max.limit" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. "#toggleCoverMinLimit" , "Toggle cover fold min.limit" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#detachingMaxLimit" , "Detach fold max.limit" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. "#detachingMinLimit" , "Detach fold min.limit" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. "#attachingMaxLimit" , "Attach fold max.limit" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. "#attachingMinLimit" , "Attach fold min.limit" , 0 )
    schema:register(XMLValueType.BOOL, basePath .. "#allowDetachingWhileFolding" , "Allow detaching while folding" , false )
        schema:register(XMLValueType.FLOAT, basePath .. "#loweringMaxLimit" , "Lowering fold max.limit" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#loweringMinLimit" , "Lowering fold min.limit" , 0 )
        schema:register(XMLValueType.FLOAT, basePath .. "#loadMovingToolStatesMaxLimit" , "Load moving tool states fold max.limit" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#loadMovingToolStatesMinLimit" , "Load moving tool states fold min.limit" , 0 )
        schema:register(XMLValueType.FLOAT, basePath .. "#dynamicMountMaxLimit" , "Dynamic mount fold max.limit" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#dynamicMountMinLimit" , "Dynamic mount fold min.limit" , 0 )
        schema:register(XMLValueType.FLOAT, basePath .. "#crabSteeringMinLimit" , "Crab steering change fold max.limit" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#crabSteeringMaxLimit" , "Crab steering change fold min.limit" , 0 )
        schema:register(XMLValueType.FLOAT, basePath .. ".toggleFolding#minLimit" , "Min.fold time to invert the current folding direction when already folding" , 0 )
        schema:register(XMLValueType.FLOAT, basePath .. ".toggleFolding#maxLimit" , "Max.fold time to invert the current folding direction when already folding" , 1 )
        schema:register(XMLValueType.INT, basePath .. ".toggleFolding#blockedDirection" , "Direction which is blocked while not in the given range(0 = all directions)" , 0 )

            schema:register(XMLValueType.L10N_STRING, basePath .. "#unfoldWarning" , "Unfold warning(Triggered when not in the right folding state for certain action(due to min/max limits))" , "$l10n_warning_firstUnfoldTheTool" )
                schema:register(XMLValueType.L10N_STRING, basePath .. "#detachWarning" , "Detach warning(Triggered when trying to detach while currently folding)" , "$l10n_warning_doNotDetachWhileFolding" )

                    schema:register(XMLValueType.BOOL, basePath .. "#useParentFoldingState" , "The fold state can not be controlled manually.It's always a copy of the fold state of the parent vehicle." , false )
                    schema:register(XMLValueType.BOOL, basePath .. "#ignoreFoldMiddleWhileFolded" , "While the tool is folded pressing the lowering button will only control the attacher joint state, not the fold state.The lowering key has only function if the tool is unfolded. (only if fold middle time defined)" , false )
                        schema:register(XMLValueType.BOOL, basePath .. "#lowerWhileDetach" , "If tool is in fold middle state it gets lowered on detach and lifted while it's attached again" , false )
                            schema:register(XMLValueType.BOOL, basePath .. "#foldWhileDetach" , "Fold the tool while it is being detached" , false )
                                schema:register(XMLValueType.BOOL, basePath .. "#keepFoldingWhileDetached" , "If set to 'true' the tool is still continuing with the folding animation after the tool is detached, otherwise it's stopped" , "true for mobile platform, otherwise false" )
                                    schema:register(XMLValueType.BOOL, basePath .. "#releaseBrakesWhileFolding" , "If set to 'true' the tool is releasing it's brakes while the folding is active" , false )
                                        schema:register(XMLValueType.BOOL, basePath .. "#requiresPower" , "Vehicle needs to be powered to change folding state" , true )
                                        schema:register(XMLValueType.BOOL, basePath .. "#allowControlWhileFolding" , "Allow controlling of vehicle while folding is in progress" , true )

                                            schema:register(XMLValueType.FLOAT, basePath .. ".foldingPart(?)#speedScale" , "Speed scale" , 1 )
                                            schema:register(XMLValueType.INT, basePath .. ".foldingPart(?)#componentJointIndex" , "Component joint index" )
                                            schema:register(XMLValueType.INT, basePath .. ".foldingPart(?)#anchorActor" , "Component joint anchor actor" , 0 )

                                            schema:register(XMLValueType.NODE_INDEX, basePath .. ".foldingPart(?)#rootNode" , "Root node for animation clip" )
                                                schema:register(XMLValueType.STRING, basePath .. ".foldingPart(?)#animationClip" , "Animation clip name" )
                                                schema:register(XMLValueType.STRING, basePath .. ".foldingPart(?)#animationName" , "Animation name" )

                                                schema:register(XMLValueType.FLOAT, basePath .. ".foldingPart(?)#delayDistance" , "Distance to be moved by the vehicle until part is played" )
                                                schema:register(XMLValueType.FLOAT, basePath .. ".foldingPart(?)#previousDuration" , "lowering duration if previous part" , 1 )
                                                    schema:register(XMLValueType.FLOAT, basePath .. ".foldingPart(?)#loweringDuration" , "lowering duration if folding part" , 1 )
                                                        schema:register(XMLValueType.FLOAT, basePath .. ".foldingPart(?)#maxDelayDuration" , "Max.duration of distance delay until movement is forced.Decreases by half when not moving" , 7.5 )
                                                        schema:register(XMLValueType.BOOL, basePath .. ".foldingPart(?)#aiSkipDelay" , "Defines if the AI uses the delayed lowering/lifting or is controls all parts synchronized" , false )
                                                            schema:register(XMLValueType.BOOL, basePath .. ".foldingPart(?)#skipDelayOnReverse" , "While reversing the delay is completely skipped" , true )
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
function Foldable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadFoldingPartFromXML" , Foldable.loadFoldingPartFromXML)
    SpecializationUtil.registerFunction(vehicleType, "setFoldDirection" , Foldable.setFoldDirection)
    SpecializationUtil.registerFunction(vehicleType, "setFoldState" , Foldable.setFoldState)
    SpecializationUtil.registerFunction(vehicleType, "setFoldMiddleState" , Foldable.setFoldMiddleState)
    SpecializationUtil.registerFunction(vehicleType, "getIsUnfolded" , Foldable.getIsUnfolded)
    SpecializationUtil.registerFunction(vehicleType, "getFoldAnimTime" , Foldable.getFoldAnimTime)
    SpecializationUtil.registerFunction(vehicleType, "setIsFoldActionAllowed" , Foldable.setIsFoldActionAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getIsFoldActionAllowed" , Foldable.getIsFoldActionAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getIsFoldAllowed" , Foldable.getIsFoldAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getIsFoldMiddleAllowed" , Foldable.getIsFoldMiddleAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getToggledFoldDirection" , Foldable.getToggledFoldDirection)
    SpecializationUtil.registerFunction(vehicleType, "getToggledFoldMiddleDirection" , Foldable.getToggledFoldMiddleDirection)
end

```

### registerLoweringActionEvent

**Description**

**Definition**

> registerLoweringActionEvent()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | actionEventsTable |
| any | inputAction       |
| any | target            |
| any | callback          |
| any | triggerUp         |
| any | triggerDown       |
| any | triggerAlways     |
| any | startActive       |
| any | callbackState     |
| any | customIconName    |
| any | ignoreCollisions  |

**Code**

```lua
function Foldable:registerLoweringActionEvent(superFunc, actionEventsTable, inputAction, target, callback, triggerUp, triggerDown, triggerAlways, startActive, callbackState, customIconName, ignoreCollisions)
    local spec = self.spec_foldable
    if spec.hasFoldingParts then
        if spec.foldMiddleAnimTime ~ = nil then
            self:clearActionEventsTable(spec.actionEventsLowering)

            local state, actionEventId
            if spec.requiresPower then
                state, actionEventId = self:addPoweredActionEvent(spec.actionEventsLowering, spec.foldMiddleInputButton, self , Foldable.actionEventFoldMiddle, false , true , false , true , nil , nil , ignoreCollisions)
            else
                    state, actionEventId = self:addActionEvent(spec.actionEventsLowering, spec.foldMiddleInputButton, self , Foldable.actionEventFoldMiddle, false , true , false , true , nil , nil , ignoreCollisions)
                end

                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
                Foldable.updateActionEventFoldMiddle( self )

                -- if we are using the same button we use only Foldable.actionEventFoldMiddle, if not, we use both
                    if spec.foldMiddleInputButton = = inputAction then
                        return state, actionEventId
                    end
                end
            end

            return superFunc( self , actionEventsTable, inputAction, target, callback, triggerUp, triggerDown, triggerAlways, startActive, callbackState, customIconName)
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
function Foldable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "allowLoadMovingToolStates" , Foldable.allowLoadMovingToolStates)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , Foldable.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , Foldable.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSlopeCompensationNodeFromXML" , Foldable.loadSlopeCompensationNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getSlopeCompensationAngleScale" , Foldable.getSlopeCompensationAngleScale)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWheelFromXML" , Foldable.loadWheelFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsVersatileYRotActive" , Foldable.getIsVersatileYRotActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Foldable.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , Foldable.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadGroundReferenceNode" , Foldable.loadGroundReferenceNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateGroundReferenceNode" , Foldable.updateGroundReferenceNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadLevelerNodeFromXML" , Foldable.loadLevelerNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsLevelerPickupNodeActive" , Foldable.getIsLevelerPickupNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingToolFromXML" , Foldable.loadMovingToolFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingToolActive" , Foldable.getIsMovingToolActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingPartFromXML" , Foldable.loadMovingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingPartActive" , Foldable.getIsMovingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , Foldable.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsNextCoverStateAllowed" , Foldable.getIsNextCoverStateAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsNextCoverStateAllowedWarning" , Foldable.getIsNextCoverStateAllowedWarning)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsInWorkPosition" , Foldable.getIsInWorkPosition)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getTurnedOnNotAllowedWarning" , Foldable.getTurnedOnNotAllowedWarning)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isDetachAllowed" , Foldable.isDetachAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isAttachAllowed" , Foldable.isAttachAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowsLowering" , Foldable.getAllowsLowering)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsLowered" , Foldable.getIsLowered)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanAIImplementContinueWork" , Foldable.getCanAIImplementContinueWork)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIReadyToDrive" , Foldable.getIsAIReadyToDrive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIPreparingToDrive" , Foldable.getIsAIPreparingToDrive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "registerLoweringActionEvent" , Foldable.registerLoweringActionEvent)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "registerSelfLoweringActionEvent" , Foldable.registerSelfLoweringActionEvent)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadGroundAdjustedNodeFromXML" , Foldable.loadGroundAdjustedNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsGroundAdjustedNodeActive" , Foldable.getIsGroundAdjustedNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSprayTypeFromXML" , Foldable.loadSprayTypeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSprayTypeActive" , Foldable.getIsSprayTypeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Foldable.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadInputAttacherJoint" , Foldable.loadInputAttacherJoint)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsInputAttacherActive" , Foldable.getIsInputAttacherActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadAdditionalCharacterFromXML" , Foldable.loadAdditionalCharacterFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAdditionalCharacterActive" , Foldable.getIsAdditionalCharacterActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowDynamicMountObjects" , Foldable.getAllowDynamicMountObjects)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSupportAnimationFromXML" , Foldable.loadSupportAnimationFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSupportAnimationAllowed" , Foldable.getIsSupportAnimationAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSteeringAxleFromXML" , Foldable.loadSteeringAxleFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSteeringAxleAllowed" , Foldable.getIsSteeringAxleAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadFillUnitFromXML" , Foldable.loadFillUnitFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillUnitSupportsToolType" , Foldable.getFillUnitSupportsToolType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadTurnedOnAnimationFromXML" , Foldable.loadTurnedOnAnimationFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsTurnedOnAnimationActive" , Foldable.getIsTurnedOnAnimationActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadAttacherJointHeightNode" , Foldable.loadAttacherJointHeightNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAttacherJointHeightNodeActive" , Foldable.getIsAttacherJointHeightNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadPickupFromXML" , Foldable.loadPickupFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanChangePickupState" , Foldable.getCanChangePickupState)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadCutterTiltFromXML" , Foldable.loadCutterTiltFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCutterTiltIsActive" , Foldable.getCutterTiltIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadPreprunerNodeFromXML" , Foldable.loadPreprunerNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsPreprunerNodeActive" , Foldable.getIsPreprunerNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadShovelNode" , Foldable.loadShovelNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShovelNodeIsActive" , Foldable.getShovelNodeIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSteeringAngleNodeFromXML" , Foldable.loadSteeringAngleNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateSteeringAngleNode" , Foldable.updateSteeringAngleNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWoodHarvesterHeaderTiltFromXML" , Foldable.loadWoodHarvesterHeaderTiltFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWoodHarvesterTiltStateAllowed" , Foldable.getIsWoodHarvesterTiltStateAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSuspensionNodeFromXML" , Foldable.loadSuspensionNodeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSuspensionNodeActive" , Foldable.getIsSuspensionNodeActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadCrabSteeringModeFromXML" , Foldable.loadCrabSteeringModeFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCrabSteeringModeAvailable" , Foldable.getCrabSteeringModeAvailable)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanToggleCrabSteering" , Foldable.getCanToggleCrabSteering)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "onLoadWheelChockFromXML" , Foldable.onLoadWheelChockFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWheelChockAllowed" , Foldable.getIsWheelChockAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadCraneShovelFromXML" , Foldable.loadCraneShovelFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCraneShovelStateChangedAllowed" , Foldable.getCraneShovelStateChangedAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getBrakeForce" , Foldable.getBrakeForce)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRequiresPower" , Foldable.getRequiresPower)
end

```

### registerSelfLoweringActionEvent

**Description**

**Definition**

> registerSelfLoweringActionEvent()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | actionEventsTable |
| any | inputAction       |
| any | target            |
| any | callback          |
| any | triggerUp         |
| any | triggerDown       |
| any | triggerAlways     |
| any | startActive       |
| any | callbackState     |
| any | customIconName    |
| any | ignoreCollisions  |

**Code**

```lua
function Foldable:registerSelfLoweringActionEvent(superFunc, actionEventsTable, inputAction, target, callback, triggerUp, triggerDown, triggerAlways, startActive, callbackState, customIconName, ignoreCollisions)
    return Foldable.registerLoweringActionEvent( self , superFunc, actionEventsTable, inputAction, target, callback, triggerUp, triggerDown, triggerAlways, startActive, callbackState, customIconName, ignoreCollisions)
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
function Foldable:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_foldable
    if spec.hasFoldingParts then
        xmlFile:setValue(key .. "#foldAnimTime" , spec.foldAnimTime)
        xmlFile:setValue(key .. "#isAllowed" , spec.isFoldAllowed)
    end
end

```

### setAnimTime

**Description**

**Definition**

> setAnimTime()

**Arguments**

| any | self            |
|-----|-----------------|
| any | animTime        |
| any | placeComponents |

**Code**

```lua
function Foldable.setAnimTime( self , animTime, placeComponents)
    local spec = self.spec_foldable

    spec.foldAnimTime = animTime
    spec.loadedFoldAnimTime = nil
    for _,foldingPart in pairs(spec.foldingParts) do
        if foldingPart.animCharSet ~ = 0 then
            enableAnimTrack(foldingPart.animCharSet, 0 )
            setAnimTrackTime(foldingPart.animCharSet, 0 , spec.foldAnimTime * foldingPart.animDuration, true )
            disableAnimTrack(foldingPart.animCharSet, 0 )
        else
                animTime = (spec.foldAnimTime * spec.maxFoldAnimDuration) / self:getAnimationDuration(foldingPart.animationName)
                self:setAnimationTime(foldingPart.animationName, animTime, true )
            end
        end

        if placeComponents = = nil then
            placeComponents = true
        end

        if self.updateCylinderedInitial ~ = nil then
            self:updateCylinderedInitial(placeComponents)
        end

        if placeComponents then
            if self.isServer then
                for _,foldingPart in pairs(spec.foldingParts) do
                    if foldingPart.componentJoint ~ = nil then
                        local componentJoint = foldingPart.componentJoint

                        local jointNode = componentJoint.jointNode
                        if foldingPart.anchorActor = = 1 then
                            jointNode = componentJoint.jointNodeActor1
                        end

                        local node = self.components[componentJoint.componentIndices[ ((foldingPart.anchorActor + 1 ) % 2 ) + 1 ] ].node
                        local x,y,z = localToWorld(jointNode, foldingPart.x, foldingPart.y, foldingPart.z)
                        local upX,upY,upZ = localDirectionToWorld(jointNode, foldingPart.upX,foldingPart.upY,foldingPart.upZ)
                        local dirX,dirY,dirZ = localDirectionToWorld(jointNode, foldingPart.dirX,foldingPart.dirY,foldingPart.dirZ)
                        setWorldTranslation(node, x,y,z)
                        I3DUtil.setWorldDirection(node, dirX,dirY,dirZ, upX,upY,upZ)

                        self:setComponentJointFrame(componentJoint, foldingPart.anchorActor)
                    end
                end
            end
        end

        for _, vehicle in pairs(spec.subFoldingStateVehicles) do
            Foldable.setAnimTime(vehicle, animTime, placeComponents)
        end

        SpecializationUtil.raiseEvent( self , "onFoldTimeChanged" , spec.foldAnimTime)
    end

```

### setFoldDirection

**Description**

**Definition**

> setFoldDirection()

**Arguments**

| any | direction   |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Foldable:setFoldDirection(direction, noEventSend)
    self:setFoldState(direction, false , noEventSend)
end

```

### setFoldMiddleState

**Description**

**Definition**

> setFoldMiddleState()

**Arguments**

| any | doLowering |
|-----|------------|

**Code**

```lua
function Foldable:setFoldMiddleState(doLowering)
    local spec = self.spec_foldable
    if spec.foldMiddleAnimTime ~ = nil then
        if self:getIsFoldMiddleAllowed() then
            if doLowering then
                self:setFoldState( - spec.foldMiddleAIRaiseDirection, false )
            else
                    self:setFoldState(spec.foldMiddleAIRaiseDirection, true )
                end
            end
        end
    end

```

### setFoldState

**Description**

**Definition**

> setFoldState()

**Arguments**

| any | direction    |
|-----|--------------|
| any | moveToMiddle |
| any | noEventSend  |

**Code**

```lua
function Foldable:setFoldState(direction, moveToMiddle, noEventSend)
    local spec = self.spec_foldable

    if spec.foldMiddleAnimTime = = nil then
        moveToMiddle = false
    end
    if spec.foldMoveDirection ~ = direction or spec.moveToMiddle ~ = moveToMiddle then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( FoldableSetFoldDirectionEvent.new( self , direction, moveToMiddle), nil , nil , self )
            else
                    g_client:getServerConnection():sendEvent( FoldableSetFoldDirectionEvent.new( self , direction, moveToMiddle))
                end
            end
            spec.foldMoveDirection = direction
            spec.moveToMiddle = moveToMiddle

            for _,foldingPart in pairs(spec.foldingParts) do
                local speedScale = nil
                -- We don't do any animations if we are already past the middle time
                    if spec.foldMoveDirection > 0.1 then
                        if not spec.moveToMiddle or spec.foldAnimTime < spec.foldMiddleAnimTime then
                            speedScale = foldingPart.speedScale
                        end
                    elseif spec.foldMoveDirection < - 0.1 then
                            if not spec.moveToMiddle or spec.foldAnimTime > spec.foldMiddleAnimTime then
                                speedScale = - foldingPart.speedScale
                            end
                        end

                        local charSet = foldingPart.animCharSet
                        if charSet ~ = 0 then
                            if speedScale ~ = nil then
                                if speedScale > 0 then
                                    if getAnimTrackTime(charSet, 0 ) < 0.0 then
                                        setAnimTrackTime(charSet, 0 , 0.0 )
                                    end
                                else
                                        if getAnimTrackTime(charSet, 0 ) > foldingPart.animDuration then
                                            setAnimTrackTime(charSet, 0 , foldingPart.animDuration)
                                        end
                                    end
                                    setAnimTrackSpeedScale(charSet, 0 , speedScale)
                                    enableAnimTrack(charSet, 0 )
                                else
                                        disableAnimTrack(charSet, 0 )
                                    end
                                else
                                        -- always stop to make sure the animation state is reset
                                        local animTime
                                        if self:getIsAnimationPlaying(foldingPart.animationName) then
                                            animTime = self:getAnimationTime(foldingPart.animationName)
                                        else
                                                animTime = (spec.foldAnimTime * spec.maxFoldAnimDuration) / self:getAnimationDuration(foldingPart.animationName)
                                            end
                                            local alreadyPlaying = self:getIsAnimationPlaying(foldingPart.animationName)
                                            self:stopAnimation(foldingPart.animationName, true )
                                            if speedScale ~ = nil then
                                                local stopAnimTime
                                                if moveToMiddle then
                                                    stopAnimTime = (spec.foldMiddleAnimTime * spec.maxFoldAnimDuration) / self:getAnimationDuration(foldingPart.animationName)
                                                end

                                                local isFolding = ((direction ~ = spec.turnOnFoldDirection) = = not moveToMiddle)
                                                if foldingPart.delayedLowering = = nil or isFolding or alreadyPlaying then
                                                    self:playAnimation(foldingPart.animationName, speedScale, animTime, true )

                                                    if moveToMiddle then
                                                        self:setAnimationStopTime(foldingPart.animationName, stopAnimTime)
                                                    end

                                                    if foldingPart.delayedLowering ~ = nil then
                                                        foldingPart.delayedLowering.currentDistance = - 1
                                                    end
                                                else
                                                        local delayedLowering = foldingPart.delayedLowering
                                                        delayedLowering.currentDistance = 0
                                                        delayedLowering.speedScale = speedScale
                                                        delayedLowering.animTime = animTime
                                                        delayedLowering.stopAnimTime = stopAnimTime
                                                        delayedLowering.startTime = g_ time
                                                        delayedLowering.prevDistance = nil
                                                    end
                                                end
                                            end
                                        end
                                        -- slightly move fold anim time, so that fold limits can trigger for different actions
                                            if spec.foldMoveDirection > 0.1 then
                                                spec.foldAnimTime = math.min(spec.foldAnimTime + 0.0001 , math.max(spec.foldAnimTime, 1 ))
                                            elseif spec.foldMoveDirection < - 0.1 then
                                                    spec.foldAnimTime = math.max(spec.foldAnimTime - 0.0001 , math.min(spec.foldAnimTime, 0 ))
                                                end

                                                if not spec.allowControlWhileFolding then
                                                    if self.setCruiseControlState ~ = nil then
                                                        self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF)
                                                    end
                                                end

                                                SpecializationUtil.raiseEvent( self , "onFoldStateChanged" , direction, moveToMiddle)
                                            end
                                        end

```

### setIsFoldActionAllowed

**Description**

> Used to block the folding input action

**Definition**

> setIsFoldActionAllowed(boolean isAllowed)

**Arguments**

| boolean | isAllowed |
|---------|-----------|

**Code**

```lua
function Foldable:setIsFoldActionAllowed(isAllowed)
    self.spec_foldable.isFoldAllowed = isAllowed
end

```

### updateActionEventFold

**Description**

**Definition**

> updateActionEventFold()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Foldable.updateActionEventFold( self )
    local spec = self.spec_foldable
    local actionEvent = spec.actionEvents[spec.foldInputButton]
    if actionEvent ~ = nil then
        local direction = self:getToggledFoldDirection()
        local text
        if direction = = spec.turnOnFoldDirection then
            text = spec.negDirectionText
        else
                text = spec.posDirectionText
            end
            g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
            g_inputBinding:setActionEventActive(actionEvent.actionEventId, self:getIsFoldActionAllowed())
        end
    end

```

### updateActionEventFoldMiddle

**Description**

**Definition**

> updateActionEventFoldMiddle()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function Foldable.updateActionEventFoldMiddle( self )
    local spec = self.spec_foldable
    local actionEvent = spec.actionEventsLowering[spec.foldMiddleInputButton]
    if actionEvent ~ = nil then
        local state = self:getIsFoldMiddleAllowed()
        g_inputBinding:setActionEventActive(actionEvent.actionEventId, state)
        if state then
            local direction = self:getToggledFoldMiddleDirection() = = spec.foldMiddleDirection
            if spec.ignoreFoldMiddleWhileFolded then
                if self:getFoldAnimTime() > spec.foldMiddleAnimTime then
                    direction = self:getIsLowered( true )
                end
            end

            local text
            if direction then
                text = spec.middlePosDirectionText
            else
                    text = spec.middleNegDirectionText
                end
                g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
            end
        end
    end

```

### updateGroundReferenceNode

**Description**

**Definition**

> updateGroundReferenceNode()

**Arguments**

| any | superFunc           |
|-----|---------------------|
| any | groundReferenceNode |

**Code**

```lua
function Foldable:updateGroundReferenceNode(superFunc, groundReferenceNode)
    superFunc( self , groundReferenceNode)

    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime > groundReferenceNode.foldMaxLimit or foldAnimTime < groundReferenceNode.foldMinLimit then
        groundReferenceNode.isActive = false
    end
end

```

### updateSteeringAngleNode

**Description**

**Definition**

> updateSteeringAngleNode()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | steeringAngleNode |
| any | angle             |
| any | dt                |

**Code**

```lua
function Foldable:updateSteeringAngleNode(superFunc, steeringAngleNode, angle, dt)
    local foldAnimTime = self:getFoldAnimTime()
    if foldAnimTime < steeringAngleNode.foldMinLimit or foldAnimTime > steeringAngleNode.foldMaxLimit then
        return
    end

    return superFunc( self , steeringAngleNode, angle, dt)
end

```