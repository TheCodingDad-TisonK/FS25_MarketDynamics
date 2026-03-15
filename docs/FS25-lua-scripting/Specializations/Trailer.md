## Trailer

**Description**

> Specialization for trailers providing tipping animation and tip side selection functionlity

**Functions**

- [actionEventManualToggleDoor](#actioneventmanualtoggledoor)
- [actionEventManualToggleTip](#actioneventmanualtoggletip)
- [actionEventToggleTipSide](#actioneventtoggletipside)
- [endTipping](#endtipping)
- [externalActionEventDoorToggleRegister](#externalactioneventdoortoggleregister)
- [externalActionEventDoorToggleUpdate](#externalactioneventdoortoggleupdate)
- [getAIHasFinishedDischarge](#getaihasfinisheddischarge)
- [getAllowTrailerDoorToggle](#getallowtrailerdoortoggle)
- [getCanBeSelected](#getcanbeselected)
- [getCanChangePickupState](#getcanchangepickupstate)
- [getCanDischargeToGround](#getcandischargetoground)
- [getCanDischargeToObject](#getcandischargetoobject)
- [getCanTogglePreferdTipSide](#getcantogglepreferdtipside)
- [getDischargeNodeEmptyFactor](#getdischargenodeemptyfactor)
- [getIsNextCoverStateAllowed](#getisnextcoverstateallowed)
- [getIsTipSideAvailable](#getistipsideavailable)
- [getIsTurnedOnAnimationActive](#getisturnedonanimationactive)
- [getNextAvailableTipSide](#getnextavailabletipside)
- [getRequiresPower](#getrequirespower)
- [getTipState](#gettipstate)
- [initSpecialization](#initspecialization)
- [loadPickupFromXML](#loadpickupfromxml)
- [loadTipSide](#loadtipside)
- [loadTurnedOnAnimationFromXML](#loadturnedonanimationfromxml)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onDischargeStateChanged](#ondischargestatechanged)
- [onFillUnitFillLevelChanged](#onfillunitfilllevelchanged)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterAnimationValueTypes](#onregisteranimationvaluetypes)
- [onRegisterExternalActionEvents](#onregisterexternalactionevents)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [saveToXMLFile](#savetoxmlfile)
- [setManualDischargeState](#setmanualdischargestate)
- [setPreferedTipSide](#setpreferedtipside)
- [setTipSideUpdateDirty](#settipsideupdatedirty)
- [setTipState](#settipstate)
- [setTrailerDoorState](#settrailerdoorstate)
- [startAIDischarge](#startaidischarge)
- [startTipping](#starttipping)
- [stopTipping](#stoptipping)
- [updateTrailerAutomaticRedischarge](#updatetrailerautomaticredischarge)

### actionEventManualToggleDoor

**Description**

**Definition**

> actionEventManualToggleDoor()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Trailer.actionEventManualToggleDoor( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_trailer
    if self:getAllowTrailerDoorToggle(spec.preferedTipSideIndex) then
        self:setTrailerDoorState(spec.preferedTipSideIndex)
    else
            g_currentMission:showBlinkingWarning(g_i18n:getText( "warning_actionNotAllowedNow" ), 5000 )
        end
    end

```

### actionEventManualToggleTip

**Description**

**Definition**

> actionEventManualToggleTip()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Trailer.actionEventManualToggleTip( self , actionName, inputValue, callbackState, isAnalog)
    local tipState = self:getTipState()
    if tipState = = Trailer.TIPSTATE_CLOSED or tipState = = Trailer.TIPSTATE_CLOSING then
        self:startTipping( nil , false )
        TrailerToggleManualTipEvent.sendEvent( self , true )
    else
            self:stopTipping()
            TrailerToggleManualTipEvent.sendEvent( self , false )
        end
    end

```

### actionEventToggleTipSide

**Description**

**Definition**

> actionEventToggleTipSide()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Trailer.actionEventToggleTipSide( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_trailer

    if self:getCanTogglePreferdTipSide() then
        self:setPreferedTipSide( self:getNextAvailableTipSide(spec.preferedTipSideIndex))
    end
end

```

### endTipping

**Description**

**Definition**

> endTipping()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function Trailer:endTipping(noEventSend)
    local spec = self.spec_trailer

    local tipSide = spec.tipSides[spec.currentTipSideIndex]
    if tipSide ~ = nil then
        if ( not tipSide.manualDoorToggle or tipSide.manualDoorToggleWhileTipping) and tipSide.doorAnimation.name ~ = nil then
            if tipSide.doorAnimation.delayedClosing then
                self:setTrailerDoorState(spec.currentTipSideIndex, false , true )
            end
        end
    end

    spec.tipState = Trailer.TIPSTATE_CLOSED
    spec.currentTipSideIndex = nil

    SpecializationUtil.raiseEvent( self , "onEndTipping" )
end

```

### externalActionEventDoorToggleRegister

**Description**

**Definition**

> externalActionEventDoorToggleRegister()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Trailer.externalActionEventDoorToggleRegister(data, vehicle)
    local spec = vehicle.spec_trailer
    local tipSide = spec.tipSides[data.trailerTipSideIndex]
    if tipSide = = nil or not tipSide.manualDoorToggle then
        return
    end

    local function actionEvent(_, actionName, inputValue, callbackState, isAnalog)
        if vehicle:getIsTipSideAvailable(data.trailerTipSideIndex) then
            vehicle:setPreferedTipSide(data.trailerTipSideIndex)

            Trailer.actionEventManualToggleDoor(vehicle, actionName, inputValue, callbackState, isAnalog)
        end
    end

    local _
    _, data.actionEventId = g_inputBinding:registerActionEvent(tipSide.manualDoorToggleAction, data, actionEvent, false , true , false , true )
    g_inputBinding:setActionEventTextPriority(data.actionEventId, GS_PRIO_HIGH)
end

```

### externalActionEventDoorToggleUpdate

**Description**

**Definition**

> externalActionEventDoorToggleUpdate()

**Arguments**

| any | data    |
|-----|---------|
| any | vehicle |

**Code**

```lua
function Trailer.externalActionEventDoorToggleUpdate(data, vehicle)
    local spec = vehicle.spec_trailer
    local tipSide = spec.tipSides[data.trailerTipSideIndex]
    if tipSide = = nil or not tipSide.manualDoorToggle then
        return
    end

    local text
    if vehicle:getIsAnimationPlaying(tipSide.doorAnimation.name) then
        if vehicle:getAnimationSpeed(tipSide.doorAnimation.name) > 0 then
            text = tipSide.manualDoorToggleActionTextNeg
        else
                text = tipSide.manualDoorToggleActionTextPos
            end
        else
                if vehicle:getAnimationTime(tipSide.doorAnimation.name) < = 0 then
                    text = tipSide.manualDoorToggleActionTextPos
                else
                        text = tipSide.manualDoorToggleActionTextNeg
                    end
                end

                g_inputBinding:setActionEventText(data.actionEventId, text)
            end

```

### getAIHasFinishedDischarge

**Description**

**Definition**

> getAIHasFinishedDischarge()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function Trailer:getAIHasFinishedDischarge(superFunc, dischargeNode)
    if self:getTipState() ~ = Trailer.TIPSTATE_CLOSED then
        return false
    end

    return superFunc( self , dischargeNode)
end

```

### getAllowTrailerDoorToggle

**Description**

**Definition**

> getAllowTrailerDoorToggle()

**Arguments**

| any | tipSideIndex |
|-----|--------------|

**Code**

```lua
function Trailer:getAllowTrailerDoorToggle(tipSideIndex)
    local spec = self.spec_trailer
    local tipSide = spec.tipSides[tipSideIndex]
    if tipSide ~ = nil then
        if tipSide.manualDoorToggleFillUnitIndex ~ = nil and not tipSide.manualDoorToggleFillUnitAllowWhileFilled then
            if self:getFillUnitFillLevel(tipSide.manualDoorToggleFillUnitIndex) > 0 then
                return false
            end
        end

        -- do not allow door closing while tipping
            if tipSide.doorAnimation.state then
                if spec.tipState = = Trailer.TIPSTATE_OPENING or spec.tipState = = Trailer.TIPSTATE_OPEN then
                    return false
                end
            else
                    if tipSide.manualDoorResetWhileTipping then
                        if spec.tipState = = Trailer.TIPSTATE_OPENING or spec.tipState = = Trailer.TIPSTATE_OPEN or spec.tipState = = Trailer.TIPSTATE_CLOSING then
                            return false
                        end
                    end
                end
            end

            return true
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
function Trailer:getCanBeSelected(superFunc)
    return true
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
function Trailer:getCanChangePickupState(superFunc, spec, newState)
    if not superFunc( self , spec, newState) then
        return false
    end

    if not spec.allowWhileTipping then
        return self:getTipState() = = Trailer.TIPSTATE_CLOSED
    end

    return true
end

```

### getCanDischargeToGround

**Description**

**Definition**

> getCanDischargeToGround()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function Trailer:getCanDischargeToGround(superFunc, dischargeNode)
    local canTip = superFunc( self , dischargeNode)

    if dischargeNode ~ = nil then
        local spec = self.spec_trailer
        local tipSide = spec.tipSides[spec.currentTipSideIndex or spec.preferedTipSideIndex]
        if tipSide ~ = nil then
            if not tipSide.canTip then
                canTip = false
            else
                    local fillUnitIndex = dischargeNode.fillUnitIndex
                    if not tipSide.canTipIfEmpty and self:getFillUnitFillLevel(fillUnitIndex) = = 0 then
                        canTip = false
                    end
                end
            end
        end

        return canTip
    end

```

### getCanDischargeToObject

**Description**

**Definition**

> getCanDischargeToObject()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function Trailer:getCanDischargeToObject(superFunc, dischargeNode)
    local canTip = superFunc( self , dischargeNode)

    if dischargeNode ~ = nil then
        local spec = self.spec_trailer
        local tipSide = spec.tipSides[spec.currentTipSideIndex or spec.preferedTipSideIndex]
        if tipSide ~ = nil then
            if not tipSide.canTip then
                canTip = false
            end
        end
    end

    return canTip
end

```

### getCanTogglePreferdTipSide

**Description**

**Definition**

> getCanTogglePreferdTipSide()

**Code**

```lua
function Trailer:getCanTogglePreferdTipSide()
    local spec = self.spec_trailer
    return spec.tipState = = Trailer.TIPSTATE_CLOSED and spec.tipSideCount > 0
end

```

### getDischargeNodeEmptyFactor

**Description**

**Definition**

> getDischargeNodeEmptyFactor()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function Trailer:getDischargeNodeEmptyFactor(superFunc, dischargeNode)
    local spec = self.spec_trailer
    local tipSide = spec.dischargeNodeIndexToTipSide[dischargeNode.index]

    if tipSide ~ = nil then
        if tipSide.animation.name ~ = nil and tipSide.animation.startTipTime ~ = 0 then
            if self:getAnimationDuration(tipSide.animation.name) > 0 then
                if self:getAnimationTime(tipSide.animation.name) < tipSide.animation.startTipTime then
                    return 0
                end
            end
        end

        if tipSide.doorAnimation.name ~ = nil and tipSide.doorAnimation.startTipTime ~ = 0 then
            if self:getAnimationDuration(tipSide.doorAnimation.name) > 0 then
                if self:getAnimationTime(tipSide.doorAnimation.name) < tipSide.doorAnimation.startTipTime then
                    return 0
                end
            end
        end

        return tipSide.currentEmptyFactor
    end

    return superFunc( self , dischargeNode)
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
function Trailer:getIsNextCoverStateAllowed(superFunc, nextState)
    local spec = self.spec_trailer

    local tipSide
    if spec.currentTipSideIndex ~ = nil then
        tipSide = spec.tipSides[spec.currentTipSideIndex]
    end

    if spec.preferedTipSideIndex ~ = nil then
        local preferedTipSide = spec.tipSides[spec.preferedTipSideIndex]
        if preferedTipSide ~ = nil and preferedTipSide.manualDoorToggle and preferedTipSide.doorAnimation.state then
            tipSide = preferedTipSide
        end
    end

    if tipSide ~ = nil then
        if tipSide.dischargeNodeIndex ~ = nil then
            local dischargeNode = self:getDischargeNodeByIndex(tipSide.dischargeNodeIndex)

            local cover = self:getCoverByFillUnitIndex(dischargeNode.fillUnitIndex)
            if cover ~ = nil then
                if nextState ~ = cover.index then
                    return false
                end
            end
        end
    end

    return superFunc( self , nextState)
end

```

### getIsTipSideAvailable

**Description**

**Definition**

> getIsTipSideAvailable()

**Arguments**

| any | sideIndex |
|-----|-----------|

**Code**

```lua
function Trailer:getIsTipSideAvailable(sideIndex)
    local spec = self.spec_trailer
    local tipSide = spec.tipSides[sideIndex]
    if tipSide ~ = nil then
        if tipSide.fillLevel.fillUnitIndex ~ = nil then
            local fillLevelPct = self:getFillUnitFillLevelPercentage(tipSide.fillLevel.fillUnitIndex)
            if fillLevelPct < tipSide.fillLevel.minFillLevelPct or fillLevelPct > tipSide.fillLevel.maxFillLevelPct then
                return false
            end
        end

        return true
    end

    return false
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
function Trailer:getIsTurnedOnAnimationActive(superFunc, turnedOnAnimation)
    if turnedOnAnimation.playWhileTipping then
        return superFunc( self , turnedOnAnimation) or( self:getTipState() ~ = Trailer.TIPSTATE_CLOSED and self:getDischargeNodeEmptyFactor( self:getCurrentDischargeNode()) > 0 )
    end

    return superFunc( self , turnedOnAnimation)
end

```

### getNextAvailableTipSide

**Description**

**Definition**

> getNextAvailableTipSide()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function Trailer:getNextAvailableTipSide(index)
    local spec = self.spec_trailer
    local newTipSideIndex = index
    local checkCount = spec.tipSideCount
    local tipSideToCheck = index
    while checkCount > 0 do
        tipSideToCheck = tipSideToCheck + 1
        if tipSideToCheck > spec.tipSideCount then
            tipSideToCheck = 1
        end

        if self:getIsTipSideAvailable(tipSideToCheck) then
            newTipSideIndex = tipSideToCheck
            break
        end

        checkCount = checkCount - 1
    end

    return newTipSideIndex
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
function Trailer:getRequiresPower(superFunc)
    local tipState = self:getTipState()
    if tipState = = Trailer.TIPSTATE_OPENING or tipState = = Trailer.TIPSTATE_CLOSING then
        return true
    end

    return superFunc( self )
end

```

### getTipState

**Description**

**Definition**

> getTipState()

**Code**

```lua
function Trailer:getTipState()
    return self.spec_trailer.tipState
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Trailer.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "trailer" , g_i18n:getText( "configuration_trailer" ), "trailer" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Trailer" )

    local key = "vehicle.trailer.trailerConfigurations.trailerConfiguration(?).trailer"

    schema:register(XMLValueType.L10N_STRING, key .. "#infoText" , "Info text" , "action_toggleTipSide" )

    schema:register(XMLValueType.STRING, key .. ".tipSide(?)#name" , "Tip side name" )
    schema:register(XMLValueType.INT, key .. ".tipSide(?)#dischargeNodeIndex" , "Discharge node index" )
    schema:register(XMLValueType.BOOL, key .. ".tipSide(?)#canTipIfEmpty" , "Can tip if empty" , true )
        schema:register(XMLValueType.BOOL, key .. ".tipSide(?)#canTip" , "Can tip(if false, only back door control is allowed)" , true )

            schema:register(XMLValueType.BOOL, key .. ".tipSide(?).manualTipToggle#enabled" , "Tip animation can be toggled manually without dischargeable" , false )
            schema:register(XMLValueType.BOOL, key .. ".tipSide(?).manualTipToggle#stopOnDeactivate" , "Stop manual tipping while vehicle is deactivated(detached, exited etc)" , true )
                schema:register(XMLValueType.STRING, key .. ".tipSide(?).manualTipToggle#inputAction" , "Input action to toggle tipping" , "IMPLEMENT_EXTRA4" )
                schema:register(XMLValueType.L10N_STRING, key .. ".tipSide(?).manualTipToggle#inputActionTextPos" , "Positive input text to display" , "action_startTipping" )
                schema:register(XMLValueType.L10N_STRING, key .. ".tipSide(?).manualTipToggle#inputActionTextNeg" , "Negative input text to display" , "action_stopTipping" )

                schema:register(XMLValueType.BOOL, key .. ".tipSide(?).manualDoorToggle#enabled" , "Door animation can be toggled manually without dischargeable" , false )
                schema:register(XMLValueType.BOOL, key .. ".tipSide(?).manualDoorToggle#openWhileTipping" , "Still automatically open the door while tipping" , false )
                    schema:register(XMLValueType.BOOL, key .. ".tipSide(?).manualDoorToggle#resetWhileTipping" , "Snap the door back to closed instantly when starting to tip" , false )
                    schema:register(XMLValueType.STRING, key .. ".tipSide(?).manualDoorToggle#inputAction" , "Input action to toggle tipping" , "IMPLEMENT_EXTRA3" )
                    schema:register(XMLValueType.L10N_STRING, key .. ".tipSide(?).manualDoorToggle#inputActionTextPos" , "Positive input text to display" , "action_openBackDoor" )
                    schema:register(XMLValueType.L10N_STRING, key .. ".tipSide(?).manualDoorToggle#inputActionTextNeg" , "Negative input text to display" , "action_closeBackDoor" )
                    schema:register(XMLValueType.INT, key .. ".tipSide(?).manualDoorToggle.fillUnit#index" , "Reference fill unit index for fill level detection" )
                        schema:register(XMLValueType.BOOL, key .. ".tipSide(?).manualDoorToggle.fillUnit#allowWhileFilled" , "Allow manual door opening when fill unit is filled" , true )

                        schema:register(XMLValueType.STRING, key .. ".tipSide(?).animation#name" , "Tip animation name" )
                        schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).animation#speedScale" , "Tip animation speed scale" , 1 )
                        schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).animation#closeSpeedScale" , "Tip animation speed scale while stopping to tip" , "inversed speed scale" )
                            schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).animation#startTipTime" , "Tip animation start tip time" , 0 )
                            schema:register(XMLValueType.BOOL, key .. ".tipSide(?).animation#resetTipSideChange" , "Reset tip animation to zero while tip side is activated" , false )

                                schema:register(XMLValueType.STRING, key .. ".tipSide(?).doorAnimation#name" , "Door animation name" )
                                schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).doorAnimation#speedScale" , "Door animation speed scale" , 1 )
                                schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).doorAnimation#closeSpeedScale" , "Door animation speed scale while stopping to tip" , "inversed speed scale" )
                                    schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).doorAnimation#startTipTime" , "Door animation start tip time" , 0 )
                                    schema:register(XMLValueType.BOOL, key .. ".tipSide(?).doorAnimation#delayedClosing" , "Play door animation after tip animation while closing" , false )

                                        schema:register(XMLValueType.STRING, key .. ".tipSide(?).tippingAnimation#name" , "Tipping animation name(continuously played while tipping)" )
                                            schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).tippingAnimation#speedScale" , "Tipping animation speed scale" , 1 )

                                            schema:register(XMLValueType.INT, key .. ".tipSide(?).fillLevel#fillUnitIndex" , "Fill unit index to check" )
                                            schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).fillLevel#minFillLevelPct" , "Min.trailer fill level pct to select tip side" , 1 )
                                            schema:register(XMLValueType.FLOAT, key .. ".tipSide(?).fillLevel#maxFillLevelPct" , "Max.trailer fill level pct to select tip side" , 1 )

                                            AnimationManager.registerAnimationNodesXMLPaths(schema, key .. ".tipSide(?).animationNodes" )
                                            ObjectChangeUtil.registerObjectChangeXMLPaths(schema, key .. ".tipSide(?)" )
                                            SoundManager.registerSampleXMLPaths(schema, key .. ".tipSide(?)" , "unloadSound" )

                                            schema:addDelayedRegistrationFunc( "AnimatedVehicle:part" , function (cSchema, cKey)
                                                cSchema:register(XMLValueType.FLOAT, cKey .. "#startTipSideEmptyFactor" , "Start tip side empty factor" )
                                                cSchema:register(XMLValueType.FLOAT, cKey .. "#endTipSideEmptyFactor" , "End tip side empty factor" )

                                                cSchema:register(XMLValueType.FLOAT, cKey .. "#startDoorAnimationMaxTime" , "Max.time of door animation" )
                                                cSchema:register(XMLValueType.FLOAT, cKey .. "#endDoorAnimationMaxTime" , "Max.time of door animation" )
                                            end )

                                            schema:addDelayedRegistrationFunc( "ExternalVehicleControl:function" , function (cSchema, cKey)
                                                cSchema:register(XMLValueType.INT, cKey .. ".trailer#tipSideIndex" , "Index of tip side to control" )
                                            end )

                                            schema:register(XMLValueType.BOOL, Pickup.PICKUP_XML_KEY .. "#allowWhileTipping" , "Allow pickup movement while tipping" , true )
                                                schema:register(XMLValueType.BOOL, TurnOnVehicle.TURNED_ON_ANIMATION_XML_PATH .. "#playWhileTipping" , "Animation is active while tipping" , false )

                                                    schema:setXMLSpecializationType()

                                                    local schemaSavegame = Vehicle.xmlSchemaSavegame
                                                    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).trailer#tipSideIndex" , "Current tip side index" )
                                                    schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).trailer#doorState" , "Current back door state" )
                                                    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).trailer#tipState" , "Current tip state" )
                                                    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).trailer#tipAnimationTime" , "Current tip animation time" )
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
function Trailer:loadPickupFromXML(superFunc, xmlFile, key, spec)
    spec.allowWhileTipping = xmlFile:getValue(key .. "#allowWhileTipping" , true )

    return superFunc( self , xmlFile, key, spec)
end

```

### loadTipSide

**Description**

**Definition**

> loadTipSide()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function Trailer:loadTipSide(xmlFile, key, entry)
    local name = xmlFile:getValue(key .. "#name" )
    entry.name = g_i18n:convertText(name, self.customEnvironment)
    if entry.name = = nil then
        Logging.xmlWarning( self.xmlFile, "Given tipSide name '%s' not found for '%s'!" , tostring(name), key)
            return false
        end

        entry.dischargeNodeIndex = xmlFile:getValue(key .. "#dischargeNodeIndex" )
        entry.canTipIfEmpty = xmlFile:getValue(key .. "#canTipIfEmpty" , true )
        entry.canTip = xmlFile:getValue(key .. "#canTip" , true )

        entry.manualTipToggle = xmlFile:getValue(key .. ".manualTipToggle#enabled" , false )
        if entry.manualTipToggle then
            local manualTipToggleActionName = xmlFile:getValue(key .. ".manualTipToggle#inputAction" )
            entry.manualTipToggleAction = InputAction[manualTipToggleActionName] or InputAction.IMPLEMENT_EXTRA4

            entry.manualTipToggleStopOnDeactivate = xmlFile:getValue(key .. ".manualTipToggle#stopOnDeactivate" , true )

            entry.manualTipToggleActionTextPos = xmlFile:getValue(key .. ".manualTipToggle#inputActionTextPos" , "action_startTipping" , self.customEnvironment, false )
            entry.manualTipToggleActionTextNeg = xmlFile:getValue(key .. ".manualTipToggle#inputActionTextNeg" , "action_stopTipping" , self.customEnvironment, false )
        end

        entry.manualDoorToggle = xmlFile:getValue(key .. ".manualDoorToggle#enabled" , false )
        if entry.manualDoorToggle then
            entry.manualDoorToggleWhileTipping = xmlFile:getValue(key .. ".manualDoorToggle#openWhileTipping" , false )
            entry.manualDoorResetWhileTipping = xmlFile:getValue(key .. ".manualDoorToggle#resetWhileTipping" , false )

            local manualDoorToggleActionName = xmlFile:getValue(key .. ".manualDoorToggle#inputAction" )
            entry.manualDoorToggleAction = InputAction[manualDoorToggleActionName] or InputAction.IMPLEMENT_EXTRA3

            entry.manualDoorToggleActionTextPos = xmlFile:getValue(key .. ".manualDoorToggle#inputActionTextPos" , "action_openBackDoor" , self.customEnvironment, false )
            entry.manualDoorToggleActionTextNeg = xmlFile:getValue(key .. ".manualDoorToggle#inputActionTextNeg" , "action_closeBackDoor" , self.customEnvironment, false )

            entry.manualDoorToggleFillUnitIndex = xmlFile:getValue(key .. ".manualDoorToggle.fillUnit#index" )
            entry.manualDoorToggleFillUnitAllowWhileFilled = xmlFile:getValue(key .. ".manualDoorToggle.fillUnit#allowWhileFilled" , true )
        end

        entry.animation = { }
        entry.animation.name = xmlFile:getValue(key .. ".animation#name" )
        if entry.animation.name = = nil or not self:getAnimationExists(entry.animation.name) then
            Logging.xmlWarning( self.xmlFile, "Missing animation name for '%s'!" , key)
                return false
            end
            entry.animation.speedScale = xmlFile:getValue(key .. ".animation#speedScale" , 1.0 ) * Platform.gameplay.dischargeSpeedFactor
            entry.animation.closeSpeedScale = - xmlFile:getValue(key .. ".animation#closeSpeedScale" , entry.animation.speedScale)
            entry.animation.startTipTime = xmlFile:getValue(key .. ".animation#startTipTime" , 0 )
            entry.animation.resetTipSideChange = xmlFile:getValue(key .. ".animation#resetTipSideChange" , false )

            entry.doorAnimation = { }
            entry.doorAnimation.name = xmlFile:getValue(key .. ".doorAnimation#name" )
            entry.doorAnimation.speedScale = xmlFile:getValue(key .. ".doorAnimation#speedScale" , 1.0 )
            entry.doorAnimation.closeSpeedScale = - xmlFile:getValue(key .. ".doorAnimation#closeSpeedScale" , entry.doorAnimation.speedScale)
            entry.doorAnimation.startTipTime = xmlFile:getValue(key .. ".doorAnimation#startTipTime" , 0 )
            entry.doorAnimation.delayedClosing = xmlFile:getValue(key .. ".doorAnimation#delayedClosing" , false )
            entry.doorAnimation.state = false
            entry.doorAnimation.maxTime = 1
            if entry.doorAnimation.name ~ = nil and not self:getAnimationExists(entry.doorAnimation.name) then
                Logging.xmlWarning( self.xmlFile, "Unknown door animation name for '%s'!" , key)
                    return false
                end

                entry.tippingAnimation = { }
                entry.tippingAnimation.name = xmlFile:getValue(key .. ".tippingAnimation#name" )
                entry.tippingAnimation.speedScale = xmlFile:getValue(key .. ".tippingAnimation#speedScale" , 1.0 )

                entry.fillLevel = { }
                entry.fillLevel.fillUnitIndex = xmlFile:getValue(key .. ".fillLevel#fillUnitIndex" )
                entry.fillLevel.minFillLevelPct = xmlFile:getValue(key .. ".fillLevel#minFillLevelPct" , 0 )
                entry.fillLevel.maxFillLevelPct = xmlFile:getValue(key .. ".fillLevel#maxFillLevelPct" , 1 )

                if entry.fillLevel.fillUnitIndex ~ = nil then
                    self.spec_trailer.fillLevelDependentTipSides = true
                end

                if self.isClient then
                    entry.animationNodes = g_animationManager:loadAnimations( self.xmlFile, key .. ".animationNodes" , self.components, self , self.i3dMappings)
                    entry.unloadSound = g_soundManager:loadSampleFromXML( self.xmlFile, key, "unloadSound" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                end

                entry.objectChanges = { }
                ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key, entry.objectChanges, self.components, self )
                ObjectChangeUtil.setObjectChanges(entry.objectChanges, false , self , self.setMovingToolDirty)

                entry.currentEmptyFactor = 1

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
function Trailer:loadTurnedOnAnimationFromXML(superFunc, xmlFile, key, turnedOnAnimation)
    turnedOnAnimation.playWhileTipping = xmlFile:getValue(key .. "#playWhileTipping" , false )

    return superFunc( self , xmlFile, key, turnedOnAnimation)
end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function Trailer:onDeactivate()
    local spec = self.spec_trailer
    local tipSide = spec.tipSides[spec.preferedTipSideIndex]
    if tipSide ~ = nil then
        if tipSide.manualTipToggle and tipSide.manualTipToggleStopOnDeactivate then
            local tipState = self:getTipState()
            if tipState = = Trailer.TIPSTATE_OPEN or tipState = = Trailer.TIPSTATE_OPENING then
                self:stopTipping( true )
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
function Trailer:onDelete()
    local spec = self.spec_trailer
    if spec.tipSides ~ = nil then
        for _, tipSide in ipairs(spec.tipSides) do
            g_animationManager:deleteAnimations(tipSide.animationNodes)
            g_soundManager:deleteSample(tipSide.unloadSound)
        end
    end
end

```

### onDischargeStateChanged

**Description**

**Definition**

> onDischargeStateChanged()

**Arguments**

| any | dischargeState |
|-----|----------------|

**Code**

```lua
function Trailer:onDischargeStateChanged(dischargeState)
    local spec = self.spec_trailer

    if dischargeState = = Dischargeable.DISCHARGE_STATE_OFF then
        self:stopTipping( true )
    elseif dischargeState = = Dischargeable.DISCHARGE_STATE_GROUND or dischargeState = = Dischargeable.DISCHARGE_STATE_OBJECT then
            self:startTipping( nil , true )
        end

        if not spec.redischarge.isDisabled then
            if dischargeState = = Dischargeable.DISCHARGE_STATE_OBJECT then
                local dischargeNode = self:getCurrentDischargeNode()
                if dischargeNode ~ = nil then
                    local dischargeObject, _ = self:getDischargeTargetObject(dischargeNode)
                    spec.redischarge.dischargeObject = dischargeObject
                    spec.redischarge.dischargeNodeLastPos[ 1 ], spec.redischarge.dischargeNodeLastPos[ 2 ], spec.redischarge.dischargeNodeLastPos[ 3 ] = getWorldTranslation(dischargeNode.node)
                end
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
function Trailer:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillType, toolType, fillPositionData, appliedDelta)
    local spec = self.spec_trailer
    if spec.fillLevelDependentTipSides then
        if fillLevelDelta ~ = 0 then
            if not self:getIsTipSideAvailable(spec.preferedTipSideIndex) then
                local tipState = self:getTipState()
                if tipState = = Trailer.TIPSTATE_CLOSED then
                    self:setPreferedTipSide( self:getNextAvailableTipSide(spec.preferedTipSideIndex))
                else
                        self:setTipSideUpdateDirty()
                    end
                end
            end
        end

        if self.isServer then
            for tipSideIndex, tipSide in ipairs(spec.tipSides) do
                if tipSide.manualDoorToggle and not tipSide.manualDoorToggleFillUnitAllowWhileFilled and fillLevelDelta > 0 then
                    if tipSide.manualDoorToggleFillUnitIndex = = fillUnitIndex then
                        if self:getFillUnitFillLevel(fillUnitIndex) > 0 then
                            self:setTrailerDoorState(tipSideIndex, false )
                        end
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
function Trailer:onLoad(savegame)
    local spec = self.spec_trailer

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.tipScrollerNodes.tipScrollerNode" , "vehicle.trailer.trailerConfigurations.trailerConfiguration.trailer.tipSide.animationNodes.animationNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.tipRotationNodes.tipRotationNode" , "vehicle.trailer.trailerConfigurations.trailerConfiguration.trailer.tipSide.animationNodes.animationNode" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.tipAnimations.tipAnimation" , "vehicle.trailer.trailerConfigurations.trailerConfiguration.trailer.tipSide" ) --FS17 to FS19

    local trailerConfigurationId = Utils.getNoNil( self.configurations[ "trailer" ], 1 )
    local configKey = string.format( "vehicle.trailer.trailerConfigurations.trailerConfiguration(%d).trailer" , trailerConfigurationId - 1 )

    spec.fillLevelDependentTipSides = false
    spec.tipSideUpdateDirty = false

    spec.tipSides = { }
    spec.dischargeNodeIndexToTipSide = { }
    local i = 0
    while true do
        local key = string.format( "%s.tipSide(%d)" , configKey, i)
        if not self.xmlFile:hasProperty(key) then
            break
        end

        local entry = { }
        if self:loadTipSide( self.xmlFile, key, entry) then
            table.insert(spec.tipSides, entry)
            entry.index = #spec.tipSides

            if entry.dischargeNodeIndex ~ = nil then
                spec.dischargeNodeIndexToTipSide[entry.dischargeNodeIndex] = entry
            end
        end
        i = i + 1
    end

    spec.infoText = self.xmlFile:getValue(configKey .. "#infoText" , "action_toggleTipSide" , self.customEnvironment, false )

    spec.tipSideCount = #spec.tipSides
    spec.preferedTipSideIndex = 1
    spec.currentTipSideIndex = nil

    spec.tipState = Trailer.TIPSTATE_CLOSED

    spec.remainingFillDelta = 0

    spec.redischarge = { }
    spec.redischarge.isDisabled = false
    spec.redischarge.dischargeObject = nil
    spec.redischarge.dischargeNodeLastPos = { 0 , 0 , 0 }

    spec.dirtyFlag = self:getNextDirtyFlag()
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
function Trailer:onLoadFinished(savegame)
    local spec = self.spec_trailer
    if spec.tipSideCount > 1 then
        if not self:getIsTipSideAvailable(spec.preferedTipSideIndex) then
            self:setTipSideUpdateDirty()
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
function Trailer:onPostLoad(savegame)
    local spec = self.spec_trailer

    for tipSideIndex, tipSide in ipairs(spec.tipSides) do
        if tipSide.dischargeNodeIndex ~ = nil and self:getDischargeNodeByIndex(tipSide.dischargeNodeIndex) = = nil then
            Logging.xmlWarning( self.xmlFile, "Unknown dischargeNodeIndex '%s' for tipSide index '%s'" , tipSide.dischargeNodeIndex, tipSideIndex)
            end
        end

        if savegame ~ = nil then
            if spec.tipSideCount > 0 then
                if spec.tipSideCount > 1 then
                    local tipSideIndex = savegame.xmlFile:getValue(savegame.key .. ".trailer#tipSideIndex" )
                    if tipSideIndex ~ = nil then
                        self:setPreferedTipSide(tipSideIndex, true )
                    end
                end

                local doorState = savegame.xmlFile:getValue(savegame.key .. ".trailer#doorState" )
                if doorState ~ = nil then
                    self:setTrailerDoorState(spec.preferedTipSideIndex, doorState, true , true )
                end

                spec.tipState = savegame.xmlFile:getValue(savegame.key .. ".trailer#tipState" , spec.tipState)
                if spec.tipState = = Trailer.TIPSTATE_OPENING or spec.tipState = = Trailer.TIPSTATE_OPEN then
                    spec.currentTipSideIndex = spec.preferedTipSideIndex
                    self:setTipState( true )
                end

                local tipAnimationTime = savegame.xmlFile:getValue(savegame.key .. ".trailer#tipAnimationTime" )
                if tipAnimationTime ~ = nil then
                    local tipSide = spec.tipSides[spec.preferedTipSideIndex]
                    self:setAnimationTime(tipSide.animation.name, tipAnimationTime, true , false )
                end
            end
        else
                if spec.tipSideCount > 0 then
                    self:setPreferedTipSide(spec.preferedTipSideIndex, true )
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
function Trailer:onReadStream(streamId, connection)
    local spec = self.spec_trailer

    if spec.tipSideCount > 1 then
        self:setPreferedTipSide(streamReadUIntN(streamId, Trailer.TIP_SIDE_NUM_BITS), true )
    end

    spec.tipState = streamReadUIntN(streamId, Trailer.TIP_STATE_NUM_BITS)
    if streamReadBool(streamId) then
        spec.currentTipSideIndex = streamReadUIntN(streamId, Trailer.TIP_SIDE_NUM_BITS)
    end

    if streamReadBool(streamId) then
        local doorState = streamReadBool(streamId)
        self:setTrailerDoorState(spec.preferedTipSideIndex, doorState, true , true )
    end

    if streamReadBool(streamId) then
        local tipSide = spec.tipSides[spec.preferedTipSideIndex]
        local tipAnimationTime = streamReadFloat32(streamId)
        if tipAnimationTime ~ = nil then
            self:setAnimationTime(tipSide.animation.name, tipAnimationTime, true , false )
        end

        if streamReadBool(streamId) then
            if streamReadBool(streamId) then
                self:playAnimation(tipSide.animation.name, tipSide.animation.speedScale, tipAnimationTime, true )
            else
                    self:playAnimation(tipSide.animation.name, tipSide.animation.closeSpeedScale, tipAnimationTime, true )
                end
            end
        end

        if streamReadBool(streamId) then
            local tipSide = spec.tipSides[spec.preferedTipSideIndex]
            local doorAnimationTime = streamReadFloat32(streamId)
            if doorAnimationTime ~ = nil then
                self:setAnimationTime(tipSide.doorAnimation.name, doorAnimationTime, true , false )
            end

            if streamReadBool(streamId) then
                if streamReadBool(streamId) then
                    self:setAnimationStopTime(tipSide.doorAnimation.name, tipSide.doorAnimation.maxTime)
                    self:playAnimation(tipSide.doorAnimation.name, tipSide.doorAnimation.speedScale, doorAnimationTime, true )
                else
                        self:playAnimation(tipSide.doorAnimation.name, tipSide.doorAnimation.closeSpeedScale, doorAnimationTime, true )
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
function Trailer:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_trailer
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if spec.tipSideCount > 1 then
                local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_TIPSIDE, self , Trailer.actionEventToggleTipSide, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            end

            local tipSide = spec.tipSides[spec.preferedTipSideIndex]
            if tipSide ~ = nil then
                if tipSide.manualTipToggle then
                    local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, tipSide.manualTipToggleAction, self , Trailer.actionEventManualToggleTip, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
                end

                if tipSide.manualDoorToggle then
                    local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, tipSide.manualDoorToggleAction, self , Trailer.actionEventManualToggleDoor, false , true , false , true , nil )
                    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
                end
            end
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
function Trailer:onRegisterAnimationValueTypes()
    self:registerAnimationValueType( "tipSideEmptyFactor" , "startTipSideEmptyFactor" , "endTipSideEmptyFactor" , false , AnimationValueFloat ,
    function (value, xmlFile, xmlKey)
        value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)

        if value.node ~ = nil then
            value:setWarningInformation( "node: " .. getName(value.node))
            value:addCompareParameters( "node" )

            return true
        end

        return false
    end ,

    function (value)
        if value.tipSide = = nil then
            local dischargeNode = value.vehicle:getDischargeNodeByNode(value.node)
            local tipSide
            if dischargeNode ~ = nil then
                tipSide = value.vehicle.spec_trailer.dischargeNodeIndexToTipSide[dischargeNode.index]
            end
            if dischargeNode = = nil or tipSide = = nil then
                Logging.xmlWarning(value.xmlFile, "Could not update discharge emptyFactor.No tipSide or dischargeNode defined for node '%s'!" , getName(value.node))
                    return 0
                end

                value.tipSide = tipSide
            end

            return value.tipSide.currentEmptyFactor
        end ,

        function (value, emptyFactor)
            if value.tipSide ~ = nil then
                value.tipSide.currentEmptyFactor = emptyFactor
            end
        end )

        self:registerAnimationValueType( "doorAnimationMaxTime" , "startDoorAnimationMaxTime" , "endDoorAnimationMaxTime" , false , AnimationValueFloat ,
        function (value, xmlFile, xmlKey)
            value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)

            if value.node ~ = nil then
                value:setWarningInformation( "node: " .. getName(value.node))
                value:addCompareParameters( "node" )

                return true
            end

            return false
        end ,

        function (value)
            if value.tipSide = = nil then
                local dischargeNode = value.vehicle:getDischargeNodeByNode(value.node)
                local tipSide
                if dischargeNode ~ = nil then
                    tipSide = value.vehicle.spec_trailer.dischargeNodeIndexToTipSide[dischargeNode.index]
                end
                if dischargeNode = = nil or tipSide = = nil then
                    return 0
                end

                value.tipSide = tipSide
            end

            return value.tipSide.doorAnimation.maxTime
        end ,

        function (value, maxTime)
            if value.tipSide ~ = nil then
                value.tipSide.doorAnimation.maxTime = maxTime

                if value.tipSide.doorAnimation.state then
                    local currentTime = self:getAnimationTime(value.tipSide.doorAnimation.name)
                    if currentTime > maxTime then
                        self:setAnimationStopTime(value.tipSide.doorAnimation.name, maxTime)
                        self:playAnimation(value.tipSide.doorAnimation.name, - 9999 , currentTime, true )
                        AnimatedVehicle.updateAnimationByName( self , value.tipSide.doorAnimation.name, 999999 , true )
                    elseif currentTime < maxTime then
                            self:setAnimationStopTime(value.tipSide.doorAnimation.name, maxTime)
                            self:playAnimation(value.tipSide.doorAnimation.name, value.tipSide.doorAnimation.speedScale, currentTime, true )
                        end
                    end
                end
            end )
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
function Trailer:onRegisterExternalActionEvents(trigger, name, xmlFile, key)
    if name = = "trailerDoorToggle" then
        local data = self:registerExternalActionEvent(trigger, name, Trailer.externalActionEventDoorToggleRegister, Trailer.externalActionEventDoorToggleUpdate)
        data.trailerTipSideIndex = xmlFile:getValue(key .. ".trailer#tipSideIndex" , 1 )
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
function Trailer:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_trailer

    if spec.tipSideCount > 1 then
        local actionEvent = spec.actionEvents[InputAction.TOGGLE_TIPSIDE]
        if actionEvent ~ = nil then
            local state = self:getCanTogglePreferdTipSide()
            g_inputBinding:setActionEventActive(actionEvent.actionEventId, state)

            if state then
                local text = string.format(spec.infoText, spec.tipSides[spec.preferedTipSideIndex].name)
                g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
            end
        end

        if spec.tipSideUpdateDirty then
            local tipState = self:getTipState()
            if tipState = = Trailer.TIPSTATE_CLOSED then
                self:setPreferedTipSide( self:getNextAvailableTipSide(spec.preferedTipSideIndex), true )
                spec.tipSideUpdateDirty = false
            end
        end
    end

    local tipSide = spec.tipSides[spec.preferedTipSideIndex]
    if tipSide ~ = nil then
        if tipSide.manualTipToggle then
            local actionEvent = spec.actionEvents[tipSide.manualTipToggleAction]
            if actionEvent ~ = nil then
                local text
                local tipState = self:getTipState()
                if tipState = = Trailer.TIPSTATE_CLOSED or tipState = = Trailer.TIPSTATE_CLOSING then
                    text = tipSide.manualTipToggleActionTextPos
                else
                        text = tipSide.manualTipToggleActionTextNeg
                    end

                    g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
                end
            end

            if tipSide.manualDoorToggle then
                local actionEvent = spec.actionEvents[tipSide.manualDoorToggleAction]
                if actionEvent ~ = nil then
                    local text
                    if self:getIsAnimationPlaying(tipSide.doorAnimation.name) then
                        if self:getAnimationSpeed(tipSide.doorAnimation.name) > 0 then
                            text = tipSide.manualDoorToggleActionTextNeg
                        else
                                text = tipSide.manualDoorToggleActionTextPos
                            end
                        else
                                if self:getAnimationTime(tipSide.doorAnimation.name) < = 0 then
                                    text = tipSide.manualDoorToggleActionTextPos
                                else
                                        text = tipSide.manualDoorToggleActionTextNeg
                                    end
                                end

                                g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
                            end
                        end
                    end

                    -- update tipState
                    if spec.tipState = = Trailer.TIPSTATE_OPENING then
                        tipSide = spec.tipSides[spec.currentTipSideIndex]
                        if tipSide ~ = nil then
                            if self:getAnimationTime(tipSide.animation.name) > = 1.0 or self:getAnimationDuration(tipSide.animation.name) = = 0 then
                                spec.tipState = Trailer.TIPSTATE_OPEN
                            end
                        end
                    elseif spec.tipState = = Trailer.TIPSTATE_CLOSING then
                            tipSide = spec.tipSides[spec.currentTipSideIndex]
                            if tipSide ~ = nil then
                                if self:getAnimationTime(tipSide.animation.name) < = 0.0 or self:getAnimationDuration(tipSide.animation.name) = = 0 or tipSide.animation.closeSpeedScale = = 0 then
                                    spec.tipState = Trailer.TIPSTATE_CLOSED
                                    self:endTipping()
                                end
                            end
                        end

                        if self.isServer then
                            if self.rootVehicle.getIsControlled = = nil or not self.rootVehicle:getIsControlled() then
                                if spec.redischarge.dischargeObject ~ = nil then
                                    if self:getDischargeState() = = Dischargeable.DISCHARGE_STATE_OFF then
                                        self:updateTrailerAutomaticRedischarge()
                                    end
                                    self:raiseActive()
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
function Trailer:onWriteStream(streamId, connection)
    local spec = self.spec_trailer

    if spec.tipSideCount > 1 then
        streamWriteUIntN(streamId, spec.preferedTipSideIndex, Trailer.TIP_SIDE_NUM_BITS)
    end

    streamWriteUIntN(streamId, spec.tipState, Trailer.TIP_STATE_NUM_BITS)
    if streamWriteBool(streamId, spec.currentTipSideIndex ~ = nil ) then
        streamWriteUIntN(streamId, spec.currentTipSideIndex, Trailer.TIP_SIDE_NUM_BITS)
    end

    local tipSide = spec.tipSides[spec.preferedTipSideIndex]
    if streamWriteBool(streamId, tipSide ~ = nil and tipSide.manualDoorToggle) then
        streamWriteBool(streamId, tipSide.doorAnimation.state)
    end

    if streamWriteBool(streamId, tipSide ~ = nil and tipSide.animation.name ~ = nil ) then
        streamWriteFloat32(streamId, self:getAnimationTime(tipSide.animation.name))
        if streamWriteBool(streamId, self:getIsAnimationPlaying(tipSide.animation.name)) then
            streamWriteBool(streamId, self:getAnimationSpeed(tipSide.animation.name) > 0 )
        end
    end

    if streamWriteBool(streamId, tipSide ~ = nil and not tipSide.manualDoorToggle and tipSide.doorAnimation.name ~ = nil ) then
        streamWriteFloat32(streamId, self:getAnimationTime(tipSide.doorAnimation.name))
        if streamWriteBool(streamId, self:getIsAnimationPlaying(tipSide.doorAnimation.name)) then
            streamWriteBool(streamId, self:getAnimationSpeed(tipSide.doorAnimation.name) > 0 )
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
function Trailer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( FillUnit , specializations) and
    SpecializationUtil.hasSpecialization( Dischargeable , specializations) and
    SpecializationUtil.hasSpecialization( AnimatedVehicle , specializations)
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
function Trailer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onDischargeStateChanged" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterAnimationValueTypes" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterExternalActionEvents" , Trailer )
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged" , Trailer )
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
function Trailer.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onStartTipping" )
    SpecializationUtil.registerEvent(vehicleType, "onOpenBackDoor" )
    SpecializationUtil.registerEvent(vehicleType, "onStopTipping" )
    SpecializationUtil.registerEvent(vehicleType, "onCloseBackDoor" )
    SpecializationUtil.registerEvent(vehicleType, "onEndTipping" )
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
function Trailer.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadTipSide" , Trailer.loadTipSide)
    SpecializationUtil.registerFunction(vehicleType, "getCanTogglePreferdTipSide" , Trailer.getCanTogglePreferdTipSide)
    SpecializationUtil.registerFunction(vehicleType, "getIsTipSideAvailable" , Trailer.getIsTipSideAvailable)
    SpecializationUtil.registerFunction(vehicleType, "getNextAvailableTipSide" , Trailer.getNextAvailableTipSide)
    SpecializationUtil.registerFunction(vehicleType, "setPreferedTipSide" , Trailer.setPreferedTipSide)
    SpecializationUtil.registerFunction(vehicleType, "setTipSideUpdateDirty" , Trailer.setTipSideUpdateDirty)
    SpecializationUtil.registerFunction(vehicleType, "startTipping" , Trailer.startTipping)
    SpecializationUtil.registerFunction(vehicleType, "stopTipping" , Trailer.stopTipping)
    SpecializationUtil.registerFunction(vehicleType, "endTipping" , Trailer.endTipping)
    SpecializationUtil.registerFunction(vehicleType, "setTrailerDoorState" , Trailer.setTrailerDoorState)
    SpecializationUtil.registerFunction(vehicleType, "getAllowTrailerDoorToggle" , Trailer.getAllowTrailerDoorToggle)
    SpecializationUtil.registerFunction(vehicleType, "getTipState" , Trailer.getTipState)
    SpecializationUtil.registerFunction(vehicleType, "setTipState" , Trailer.setTipState)
    SpecializationUtil.registerFunction(vehicleType, "updateTrailerAutomaticRedischarge" , Trailer.updateTrailerAutomaticRedischarge)
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
function Trailer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDischargeNodeEmptyFactor" , Trailer.getDischargeNodeEmptyFactor)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanDischargeToGround" , Trailer.getCanDischargeToGround)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanDischargeToObject" , Trailer.getCanDischargeToObject)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsNextCoverStateAllowed" , Trailer.getIsNextCoverStateAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Trailer.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIHasFinishedDischarge" , Trailer.getAIHasFinishedDischarge)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "startAIDischarge" , Trailer.startAIDischarge)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadPickupFromXML" , Trailer.loadPickupFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanChangePickupState" , Trailer.getCanChangePickupState)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsTurnedOnAnimationActive" , Trailer.getIsTurnedOnAnimationActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadTurnedOnAnimationFromXML" , Trailer.loadTurnedOnAnimationFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRequiresPower" , Trailer.getRequiresPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setManualDischargeState" , Trailer.setManualDischargeState)
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
function Trailer:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_trailer

    if spec.tipSideCount > 1 then
        xmlFile:setValue(key .. "#tipSideIndex" , spec.preferedTipSideIndex)
    end

    local tipSide = spec.tipSides[spec.preferedTipSideIndex]
    if tipSide ~ = nil then
        xmlFile:setValue(key .. "#doorState" , self:getAnimationTime(tipSide.doorAnimation.name) > 0 )
        xmlFile:setValue(key .. "#tipAnimationTime" , self:getAnimationTime(tipSide.animation.name))
    end

    xmlFile:setValue(key .. "#tipState" , spec.tipState)
end

```

### setManualDischargeState

**Description**

**Definition**

> setManualDischargeState()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | state       |
| any | noEventSend |

**Code**

```lua
function Trailer:setManualDischargeState(superFunc, state, noEventSend)
    if state = = Dischargeable.DISCHARGE_STATE_OFF then
        -- redischarge function is disabled by a manual user discharge cancel
            local spec = self.spec_trailer
            spec.redischarge.dischargeObject = nil
            spec.redischarge.dischargeNodeLastPos[ 1 ], spec.redischarge.dischargeNodeLastPos[ 2 ], spec.redischarge.dischargeNodeLastPos[ 3 ] = 0 , 0 , 0
        end

        return superFunc( self , state, noEventSend)
    end

```

### setPreferedTipSide

**Description**

**Definition**

> setPreferedTipSide()

**Arguments**

| any | index       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function Trailer:setPreferedTipSide(index, noEventSend)
    local spec = self.spec_trailer
    index = math.max( 1 , math.min(spec.tipSideCount, index))

    local tipState = self:getTipState()
    if tipState ~ = Trailer.TIPSTATE_CLOSED and tipState ~ = Trailer.TIPSTATE_CLOSING then
        self:stopTipping( true )
    end

    if index ~ = spec.preferedTipSideIndex then
        if spec.tipSideCount > 1 then
            if noEventSend = = nil or noEventSend = = false then
                if g_server ~ = nil then
                    g_server:broadcastEvent( TrailerToggleTipSideEvent.new( self , index), nil , nil , self )
                else
                        g_client:getServerConnection():sendEvent( TrailerToggleTipSideEvent.new( self , index))
                    end
                end
            end
        end

        for i = 1 , #spec.tipSides do
            ObjectChangeUtil.setObjectChanges(spec.tipSides[i].objectChanges, i = = index, self , self.setMovingToolDirty)
        end

        local oldTipSide = spec.tipSides[spec.preferedTipSideIndex]

        spec.preferedTipSideIndex = index
        local newTipSide = spec.tipSides[index]

        if oldTipSide ~ = nil then
            -- if we use the same back door animation we keep the state as it is, if not we are closing
                if newTipSide.doorAnimation.name ~ = oldTipSide.doorAnimation.name then
                    if oldTipSide.doorAnimation.name ~ = nil and self:getAnimationTime(oldTipSide.doorAnimation.name) > 0 then
                        self:setTrailerDoorState(oldTipSide.index, false , true )
                    end
                end
            end

            if newTipSide.animation.resetTipSideChange then
                self:setAnimationTime(newTipSide.animation.name, 0 , true , false )
            end

            if newTipSide.dischargeNodeIndex ~ = nil then
                self:setCurrentDischargeNodeIndex(newTipSide.dischargeNodeIndex)
            end

            self:requestActionEventUpdate()
        end

```

### setTipSideUpdateDirty

**Description**

**Definition**

> setTipSideUpdateDirty()

**Code**

```lua
function Trailer:setTipSideUpdateDirty()
    local spec = self.spec_trailer
    spec.tipSideUpdateDirty = true
end

```

### setTipState

**Description**

> Set inital tip state to open or closed

**Definition**

> setTipState()

**Arguments**

| any | isOpen |
|-----|--------|

**Code**

```lua
function Trailer:setTipState(isOpen)
    local spec = self.spec_trailer
    local tipSide = spec.tipSides[spec.currentTipSideIndex]
    if tipSide ~ = nil then
        if isOpen then
            self:playAnimation(tipSide.animation.name, tipSide.animation.speedScale, self:getAnimationTime(tipSide.animation.name), true )

            if not tipSide.manualDoorToggle and tipSide.doorAnimation.name ~ = nil then
                self:setAnimationStopTime(tipSide.doorAnimation.name, tipSide.doorAnimation.maxTime)
                self:playAnimation(tipSide.doorAnimation.name, tipSide.doorAnimation.speedScale, self:getAnimationTime(tipSide.doorAnimation.name), true )
            end
        else
                self:playAnimation(tipSide.animation.name, tipSide.animation.closeSpeedScale, self:getAnimationTime(tipSide.animation.name), true )

                if not tipSide.manualDoorToggle and tipSide.doorAnimation.name ~ = nil then
                    self:playAnimation(tipSide.doorAnimation.name, tipSide.doorAnimation.closeSpeedScale, self:getAnimationTime(tipSide.doorAnimation.name), true )
                end
            end

            AnimatedVehicle.updateAnimationByName( self , tipSide.animation.name, 999999 , true )
            AnimatedVehicle.updateAnimationByName( self , tipSide.doorAnimation.name, 999999 , true )
        end
    end

```

### setTrailerDoorState

**Description**

**Definition**

> setTrailerDoorState()

**Arguments**

| any | tipSideIndex  |
|-----|---------------|
| any | state         |
| any | noEventSend   |
| any | instantUpdate |

**Code**

```lua
function Trailer:setTrailerDoorState(tipSideIndex, state, noEventSend, instantUpdate)
    local spec = self.spec_trailer
    local tipSide = spec.tipSides[tipSideIndex]
    if tipSide ~ = nil then
        if state = = nil then
            state = not tipSide.doorAnimation.state
        end

        tipSide.doorAnimation.state = state

        self:setAnimationStopTime(tipSide.doorAnimation.name, state and tipSide.doorAnimation.maxTime or 0 )
        self:playAnimation(tipSide.doorAnimation.name, state and tipSide.doorAnimation.speedScale or tipSide.doorAnimation.closeSpeedScale, self:getAnimationTime(tipSide.doorAnimation.name), true )

        if instantUpdate then
            AnimatedVehicle.updateAnimationByName( self , tipSide.doorAnimation.name, 999999 , true )
        end

        if tipSide.manualDoorToggle and tipSide.doorAnimation.name ~ = nil then
            if state then
                SpecializationUtil.raiseEvent( self , "onOpenBackDoor" , tipSideIndex)
            else
                    SpecializationUtil.raiseEvent( self , "onCloseBackDoor" , tipSideIndex)
                end
            end

            TrailerToggleManualDoorEvent.sendEvent( self , tipSideIndex, state, noEventSend)
        end
    end

```

### startAIDischarge

**Description**

**Definition**

> startAIDischarge()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |
| any | task          |

**Code**

```lua
function Trailer:startAIDischarge(superFunc, dischargeNode, task)
    local spec = self.spec_trailer
    local tipSide = spec.dischargeNodeIndexToTipSide[dischargeNode.index]
    if tipSide ~ = nil then
        self:setPreferedTipSide(tipSide.index)
    end

    superFunc( self , dischargeNode, task)
end

```

### startTipping

**Description**

**Definition**

> startTipping()

**Arguments**

| any | tipSideIndex |
|-----|--------------|
| any | noEventSend  |

**Code**

```lua
function Trailer:startTipping(tipSideIndex, noEventSend)
    local spec = self.spec_trailer
    tipSideIndex = tipSideIndex or spec.preferedTipSideIndex
    local tipSide = spec.tipSides[tipSideIndex]
    if tipSide ~ = nil then
        local animTime = self:getAnimationTime(tipSide.animation.name)
        self:playAnimation(tipSide.animation.name, tipSide.animation.speedScale, animTime, true )

        if ( not tipSide.manualDoorToggle or tipSide.manualDoorToggleWhileTipping) and tipSide.doorAnimation.name ~ = nil then
            self:setTrailerDoorState(spec.preferedTipSideIndex, true , true )
        elseif tipSide.manualDoorResetWhileTipping then
                self:setTrailerDoorState(spec.preferedTipSideIndex, false , true , true )
            end

            if tipSide.tippingAnimation.name ~ = nil then
                self:playAnimation(tipSide.tippingAnimation.name, tipSide.tippingAnimation.speedScale, self:getAnimationTime(tipSide.tippingAnimation.name), true )
            end

            if self.isClient then
                g_animationManager:startAnimations(tipSide.animationNodes)
                g_soundManager:playSample(tipSide.unloadSound)
            end

            spec.tipState = Trailer.TIPSTATE_OPENING
            spec.currentTipSideIndex = tipSideIndex

            if tipSide.dischargeNodeIndex ~ = nil then
                self:setCurrentDischargeNodeIndex(tipSide.dischargeNodeIndex)
            end

            spec.remainingFillDelta = 0

            SpecializationUtil.raiseEvent( self , "onStartTipping" , tipSideIndex)
            self:raiseActive()
        end
    end

```

### stopTipping

**Description**

**Definition**

> stopTipping()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function Trailer:stopTipping(noEventSend)
    local spec = self.spec_trailer
    local tipSide = spec.tipSides[spec.currentTipSideIndex]
    if tipSide ~ = nil then
        if tipSide.animation.closeSpeedScale ~ = 0 then
            local animTime = self:getAnimationTime(tipSide.animation.name)
            self:playAnimation(tipSide.animation.name, tipSide.animation.closeSpeedScale, animTime, true )
        else
                if self:getIsAnimationPlaying(tipSide.animation.name) then
                    self:stopAnimation(tipSide.animation.name, true )
                end
            end

            if ( not tipSide.manualDoorToggle or tipSide.manualDoorToggleWhileTipping) and tipSide.doorAnimation.name ~ = nil then
                if not tipSide.doorAnimation.delayedClosing then
                    self:setTrailerDoorState(spec.currentTipSideIndex, false , true )
                end
            end

            if tipSide.tippingAnimation.name ~ = nil then
                self:setAnimationStopTime(tipSide.tippingAnimation.name, 1 )
            end

            if self.isClient then
                g_animationManager:stopAnimations(tipSide.animationNodes)
                g_soundManager:stopSample(tipSide.unloadSound)
            end

            spec.tipState = Trailer.TIPSTATE_CLOSING

            spec.remainingFillDelta = 0

            SpecializationUtil.raiseEvent( self , "onStopTipping" )
            self:raiseActive()
        end
    end

```

### updateTrailerAutomaticRedischarge

**Description**

**Definition**

> updateTrailerAutomaticRedischarge()

**Code**

```lua
function Trailer:updateTrailerAutomaticRedischarge()
    local spec = self.spec_trailer

    local dischargeNode = self:getCurrentDischargeNode()
    if dischargeNode ~ = nil then
        local failed = false
        local x, y, z = getWorldTranslation(dischargeNode.node)
        local pos = spec.redischarge.dischargeNodeLastPos
        local distance = MathUtil.vector3Length(pos[ 1 ] - x, pos[ 2 ] - y, pos[ 3 ] - z)
        if distance < 1.5 then
            local dischargeObject, dischargeFillUnitIndex = self:getDischargeTargetObject(dischargeNode)
            if dischargeObject ~ = nil and dischargeObject = = spec.redischarge.dischargeObject then
                local fillLevel = self:getFillUnitFillLevel(dischargeNode.fillUnitIndex)
                if fillLevel > 0 then
                    local dischargeAllowed = true
                    local threshold = 0.5
                    if dischargeObject.getTrailerAutomaticRedischargeThreshold ~ = nil then
                        threshold = dischargeObject:getTrailerAutomaticRedischargeThreshold() or threshold
                    end

                    if dischargeObject.getFillUnitCapacity ~ = nil and dischargeObject.getFillUnitFreeCapacity ~ = nil then
                        local capacity = dischargeObject:getFillUnitCapacity(dischargeFillUnitIndex)
                        local freeCapacity = dischargeObject:getFillUnitFreeCapacity(dischargeFillUnitIndex, self:getDischargeFillType(dischargeNode), self:getActiveFarm())
                        dischargeAllowed = freeCapacity > (capacity * threshold) or fillLevel < freeCapacity
                    end

                    if dischargeAllowed then
                        spec.redischarge.isDisabled = true
                        self:setDischargeState( Dischargeable.DISCHARGE_STATE_OBJECT)
                        spec.redischarge.isDisabled = false
                    end
                else
                        failed = true
                    end
                end
            else
                    failed = true
                end

                if failed then
                    spec.redischarge.dischargeObject = nil
                    spec.redischarge.dischargeNodeLastPos[ 1 ], spec.redischarge.dischargeNodeLastPos[ 2 ], spec.redischarge.dischargeNodeLastPos[ 3 ] = 0 , 0 , 0
                end
            end
        end

```