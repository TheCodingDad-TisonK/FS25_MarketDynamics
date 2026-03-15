## Plow

**Description**

> Specialization for plows providing additional folding/rotating functionality

**Functions**

- [actionControllerRotateBackEvent](#actioncontrollerrotatebackevent)
- [actionControllerRotateEvent](#actioncontrollerrotateevent)
- [actionEventLimitToField](#actioneventlimittofield)
- [actionEventTurn](#actioneventturn)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getAIInvertMarkersOnTurn](#getaiinvertmarkersonturn)
- [getAllowsLowering](#getallowslowering)
- [getCanAIImplementContinueWork](#getcanaiimplementcontinuework)
- [getCanBeSelected](#getcanbeselected)
- [getCanTogglePlowRotation](#getcantoggleplowrotation)
- [getDefaultSpeedLimit](#getdefaultspeedlimit)
- [getDirtMultiplier](#getdirtmultiplier)
- [getIsAIPreparingToDrive](#getisaipreparingtodrive)
- [getIsAIReadyToDrive](#getisaireadytodrive)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsFoldMiddleAllowed](#getisfoldmiddleallowed)
- [getIsPlowRotationAllowed](#getisplowrotationallowed)
- [getIsSpeedRotatingPartActive](#getisspeedrotatingpartactive)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getPlowForceLimitToField](#getplowforcelimittofield)
- [getPlowLimitToField](#getplowlimittofield)
- [getSpeedRotatingPartDirection](#getspeedrotatingpartdirection)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [isDetachAllowed](#isdetachallowed)
- [loadSpeedRotatingPartFromXML](#loadspeedrotatingpartfromxml)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldCourseSettingsInitialized](#onaifieldcoursesettingsinitialized)
- [onAIImplementEnd](#onaiimplementend)
- [onAIImplementEndTurn](#onaiimplementendturn)
- [onAIImplementSideOffsetChanged](#onaiimplementsideoffsetchanged)
- [onAIImplementStartTurn](#onaiimplementstartturn)
- [onAIImplementTurnProgress](#onaiimplementturnprogress)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onEndWorkAreaProcessing](#onendworkareaprocessing)
- [onFinishAnimation](#onfinishanimation)
- [onFoldTimeChanged](#onfoldtimechanged)
- [onLoad](#onload)
- [onPostAttach](#onpostattach)
- [onPostLoad](#onpostload)
- [onPreDetach](#onpredetach)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRootVehicleChanged](#onrootvehiclechanged)
- [onStartAnimation](#onstartanimation)
- [onStartWorkAreaProcessing](#onstartworkareaprocessing)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [processPlowArea](#processplowarea)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setPlowAIRequirements](#setplowairequirements)
- [setPlowLimitToField](#setplowlimittofield)
- [setRotationCenter](#setrotationcenter)
- [setRotationMax](#setrotationmax)

### actionControllerRotateBackEvent

**Description**

**Definition**

> actionControllerRotateBackEvent()

**Arguments**

| any | self      |
|-----|-----------|
| any | direction |
| any | isAIEvent |

**Code**

```lua
function Plow.actionControllerRotateBackEvent( self , direction, isAIEvent)
    if isAIEvent then
        local spec = self.spec_plow
        if spec.rotationPart.turnAnimation ~ = nil then
            if self:getCanTogglePlowRotation() then
                if spec.rotationMax then
                    self:setRotationMax( false )
                end
            end
        end

        return true
    end

    return false
end

```

### actionControllerRotateEvent

**Description**

**Definition**

> actionControllerRotateEvent()

**Arguments**

| any | self      |
|-----|-----------|
| any | direction |
| any | isAIEvent |

**Code**

```lua
function Plow.actionControllerRotateEvent( self , direction, isAIEvent)
    local spec = self.spec_plow
    if spec.rotationPart.turnAnimation ~ = nil then
        if self:getCanTogglePlowRotation() then
            if direction < 0 then
                self:setRotationMax( not spec.rotationMax)
            else
                    if not self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) then
                        local animationTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
                        if animationTime > 0 and animationTime < 1 then
                            self:setRotationMax(spec.rotationMax)
                        end
                    end
                end
            end
        end

        return true
    end

```

### actionEventLimitToField

**Description**

**Definition**

> actionEventLimitToField()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Plow.actionEventLimitToField( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_plow
    if not self:getPlowForceLimitToField() then
        self:setPlowLimitToField( not spec.limitToField)
    end
end

```

### actionEventTurn

**Description**

**Definition**

> actionEventTurn()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function Plow.actionEventTurn( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_plow
    if spec.rotationPart.turnAnimation ~ = nil then
        if self:getCanTogglePlowRotation() then
            self:setRotationMax( not spec.rotationMax)
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
function Plow:doCheckSpeedLimit(superFunc)
    return superFunc( self ) or( self.spec_plow.onlyActiveWhenLowered and self:getIsImplementChainLowered())
end

```

### getAIInvertMarkersOnTurn

**Description**

**Definition**

> getAIInvertMarkersOnTurn()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | turnLeft  |

**Code**

```lua
function Plow:getAIInvertMarkersOnTurn(superFunc, turnLeft)
    local spec = self.spec_plow
    if spec.rotationPart.turnAnimation ~ = nil then
        if turnLeft then
            return spec.rotationMax = = spec.rotateLeftToMax
        else
                return spec.rotationMax ~ = spec.rotateLeftToMax
            end
        end

        return false
    end

```

### getAllowsLowering

**Description**

> Returns true if lowering is allowed

**Definition**

> getAllowsLowering()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | allowed | lowering is allowed |
|-----|---------|---------------------|

**Code**

```lua
function Plow:getAllowsLowering(superFunc)
    local spec = self.spec_plow
    if self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) then
        return false
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
function Plow:getCanAIImplementContinueWork(superFunc, isTurning)
    local canContinue, stopAI, stopReason = superFunc( self , isTurning)
    if not canContinue then
        return false , stopAI, stopReason
    end

    local spec = self.spec_plow
    if not spec.ai.stopDuringTurn and isTurning then
        return true
    end

    return not self:getIsAnimationPlaying(spec.rotationPart.turnAnimation)
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
function Plow:getCanBeSelected(superFunc)
    return true
end

```

### getCanTogglePlowRotation

**Description**

> Returns if it's allowed to change the plow turn state in the current vehicle state

**Definition**

> getCanTogglePlowRotation()

**Code**

```lua
function Plow:getCanTogglePlowRotation()
    local spec = self.spec_plow

    if not self:getIsPlowRotationAllowed() then
        return false
    end

    if not spec.rotationPart.rotationAllowedIfLowered and self.getIsLowered ~ = nil and self:getIsLowered() then
        return false
    end

    if not self:getIsPowered() then
        return false
    end

    return true
end

```

### getDefaultSpeedLimit

**Description**

**Definition**

> getDefaultSpeedLimit()

**Code**

```lua
function Plow.getDefaultSpeedLimit()
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
function Plow:getDirtMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_plow
    if spec.isWorking then
        multiplier = multiplier + self:getWorkDirtMultiplier() * self:getLastSpeed() / self.speedLimit
    end

    return multiplier
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
function Plow:getIsAIPreparingToDrive(superFunc)
    local spec = self.spec_plow
    if self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) then
        return true
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
function Plow:getIsAIReadyToDrive(superFunc)
    local spec = self.spec_plow
    if spec.rotationMax or self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) then
        return false
    end

    return superFunc( self )
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
function Plow:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_plow

    if spec.rotationPart.limitFoldRotationMax ~ = nil and spec.rotationPart.limitFoldRotationMax = = spec.rotationMax then
        return false , spec.texts.warningFoldingPlowTurned
    end

    if spec.rotationPart.turnAnimation ~ = nil and self.getAnimationTime ~ = nil then
        local rotationTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        if rotationTime > spec.rotationPart.foldRotationMaxLimit or rotationTime < spec.rotationPart.foldRotationMinLimit then
            return false , spec.texts.warningFoldingPlowTurned
        end
    end

    if not spec.rotationPart.rotationAllowedIfLowered and self.getIsLowered ~ = nil and self:getIsLowered() then
        return false , spec.texts.warningFoldingLowered
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsFoldMiddleAllowed

**Description**

**Definition**

> getIsFoldMiddleAllowed()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Plow:getIsFoldMiddleAllowed(superFunc)
    local spec = self.spec_plow

    if spec.rotationPart.limitFoldRotationMax ~ = nil and spec.rotationPart.limitFoldRotationMax = = spec.rotationMax then
        return false
    end
    if spec.rotationPart.turnAnimation ~ = nil and self.getAnimationTime ~ = nil then
        local rotationTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        if rotationTime > spec.rotationPart.foldRotationMaxLimit or rotationTime < spec.rotationPart.foldRotationMinLimit then
            return false
        end
    end
    return superFunc( self )
end

```

### getIsPlowRotationAllowed

**Description**

> Returns if it's allowed to set the plow rotation in the current vehicle state

**Definition**

> getIsPlowRotationAllowed()

**Code**

```lua
function Plow:getIsPlowRotationAllowed()
    local spec = self.spec_plow

    if self.getFoldAnimTime ~ = nil then
        local foldAnimTime = self:getFoldAnimTime()
        if foldAnimTime > spec.rotationPart.rotationFoldMaxLimit or foldAnimTime < spec.rotationPart.rotationFoldMinLimit then
            return false
        end
    end

    return true
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
function Plow:getIsSpeedRotatingPartActive(superFunc, speedRotatingPart)
    local spec = self.spec_plow

    if spec.rotationPart.turnAnimation ~ = nil and speedRotatingPart.disableOnTurn then
        local turnAnimTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        if turnAnimTime ~ = nil then
            local enabled
            if speedRotatingPart.turnAnimLimitSide < 0 then
                enabled = (turnAnimTime < = speedRotatingPart.turnAnimLimit)
            elseif speedRotatingPart.turnAnimLimitSide > 0 then
                    enabled = ( 1 - turnAnimTime < = speedRotatingPart.turnAnimLimit)
                else
                        enabled = (turnAnimTime < = speedRotatingPart.turnAnimLimit or 1 - turnAnimTime < = speedRotatingPart.turnAnimLimit)
                    end
                    if not enabled then
                        return false
                    end
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
function Plow:getIsWorkAreaActive(superFunc, workArea)
    if workArea.type = = WorkAreaType.PLOW then
        local spec = self.spec_plow
        if spec.startActivationTime > g_currentMission.time then
            return false
        end

        if spec.onlyActiveWhenLowered and self.getIsLowered ~ = nil then
            if not self:getIsLowered( false ) then
                return false
            end
        end
    end

    return superFunc( self , workArea)
end

```

### getPlowForceLimitToField

**Description**

> Returns if plow limit to field is forced and not changeable

**Definition**

> getPlowForceLimitToField()

**Return Values**

| any | isForced | is forced |
|-----|----------|-----------|

**Code**

```lua
function Plow:getPlowForceLimitToField()
    return self.spec_plow.forceLimitToField or not Platform.gameplay.canCreateFields
end

```

### getPlowLimitToField

**Description**

> Returns if plow is limited to the field

**Definition**

> getPlowLimitToField()

**Return Values**

| any | isLimited | is limited to field |
|-----|-----------|---------------------|

**Code**

```lua
function Plow:getPlowLimitToField()
    return self.spec_plow.limitToField
end

```

### getSpeedRotatingPartDirection

**Description**

**Definition**

> getSpeedRotatingPartDirection()

**Arguments**

| any | superFunc         |
|-----|-------------------|
| any | speedRotatingPart |

**Code**

```lua
function Plow:getSpeedRotatingPartDirection(superFunc, speedRotatingPart)
    local spec = self.spec_plow

    if spec.rotationPart.turnAnimation ~ = nil then
        local turnAnimTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        if turnAnimTime > 0.5 and speedRotatingPart.invertDirectionOnRotation then
            return - 1
        end
    end

    return superFunc( self , speedRotatingPart)
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
function Plow:getWearMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_plow
    if spec.isWorking then
        multiplier = multiplier + self:getWorkWearMultiplier() * self:getLastSpeed() / self.speedLimit
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
function Plow.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "plow" , g_i18n:getText( "configuration_design" ), "plow" , VehicleConfigurationItem )
    g_workAreaTypeManager:addWorkAreaType( "plow" , true , true , true )
    g_workAreaTypeManager:addWorkAreaType( "plowShare" , true , false , false )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Plow" )

    Plow.registerXMLPaths(schema, "vehicle.plow" )
    Plow.registerXMLPaths(schema, "vehicle.plow.plowConfigurations.plowConfiguration(?)" )

    schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#disableOnTurn" , "Disable while turning" , true )
        schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#turnAnimLimit" , "Turn animation limit" , 0 )
        schema:register(XMLValueType.FLOAT, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#turnAnimLimitSide" , "Turn animation limit side" , 0 )
        schema:register(XMLValueType.BOOL, SpeedRotatingParts.SPEED_ROTATING_PART_XML_KEY .. "#invertDirectionOnRotation" , "Invert direction on rotation" , true )

        schema:setXMLSpecializationType()

        local schemaSavegame = Vehicle.xmlSchemaSavegame
        schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).plow#rotationMax" , "Rotation max." )
        schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).plow#turnAnimTime" , "Turn animation time" )
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

| any | detachAllowed | detach is allowed |
|-----|---------------|-------------------|

**Code**

```lua
function Plow:isDetachAllowed(superFunc)
    local spec = self.spec_plow
    if self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) then
        return false
    end

    if spec.rotationPart.turnAnimation ~ = nil then
        local animTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        if animTime < spec.rotationPart.detachMinLimit or animTime > spec.rotationPart.detachMaxLimit then
            return false , spec.rotationPart.detachWarning, true
        end
    end

    return superFunc( self )
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
function Plow:loadSpeedRotatingPartFromXML(superFunc, speedRotatingPart, xmlFile, key)
    if not superFunc( self , speedRotatingPart, xmlFile, key) then
        return false
    end

    speedRotatingPart.disableOnTurn = xmlFile:getValue(key .. "#disableOnTurn" , true )
    speedRotatingPart.turnAnimLimit = xmlFile:getValue(key .. "#turnAnimLimit" , 0 )
    speedRotatingPart.turnAnimLimitSide = xmlFile:getValue(key .. "#turnAnimLimitSide" , 0 )
    speedRotatingPart.invertDirectionOnRotation = xmlFile:getValue(key .. "#invertDirectionOnRotation" , true )

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
function Plow:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    local retValue = superFunc( self , workArea, xmlFile, key)

    if workArea.type = = WorkAreaType.DEFAULT then
        workArea.type = WorkAreaType.PLOW
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
function Plow:onAIFieldCourseSettingsInitialized(fieldCourseSettings)
    fieldCourseSettings.toolFullOverlap = true
    fieldCourseSettings.toolFullOverlapInside = true
    fieldCourseSettings.segmentSplitAngle = 25 -- force the default split angle
end

```

### onAIImplementEnd

**Description**

**Definition**

> onAIImplementEnd()

**Code**

```lua
function Plow:onAIImplementEnd()
    self.spec_plow.ai.rotationMaxToSet = nil
end

```

### onAIImplementEndTurn

**Description**

**Definition**

> onAIImplementEndTurn()

**Arguments**

| any | isLeft |
|-----|--------|

**Code**

```lua
function Plow:onAIImplementEndTurn(isLeft)
    -- make sure the turn side is applied(can happen if the turning while reversing is blocked)
        self:setRotationMax(isLeft)
    end

```

### onAIImplementSideOffsetChanged

**Description**

**Definition**

> onAIImplementSideOffsetChanged()

**Arguments**

| any | isLeft    |
|-----|-----------|
| any | isInitial |

**Code**

```lua
function Plow:onAIImplementSideOffsetChanged(isLeft, isInitial)
    if isInitial then
        local spec = self.spec_plow
        if self:getIsPlowRotationAllowed() then
            self:setRotationMax(isLeft)
        else
                spec.ai.rotationMaxToSet = isLeft
            end
        end
    end

```

### onAIImplementStartTurn

**Description**

**Definition**

> onAIImplementStartTurn()

**Arguments**

| any | isLeft |
|-----|--------|

**Code**

```lua
function Plow:onAIImplementStartTurn(isLeft)
    self.spec_plow.ai.lastHeadlandPosition = 0
end

```

### onAIImplementTurnProgress

**Description**

**Definition**

> onAIImplementTurnProgress()

**Arguments**

| any | progress        |
|-----|-----------------|
| any | isLeft          |
| any | movingDirection |

**Code**

```lua
function Plow:onAIImplementTurnProgress(progress, isLeft, movingDirection)
    local spec = self.spec_plow
    if movingDirection > 0 or spec.ai.allowTurnWhileReversing then
        if spec.ai.lastHeadlandPosition < = spec.ai.rotateToCenterHeadlandPos and progress > spec.ai.rotateToCenterHeadlandPos
            and progress < spec.ai.rotateCompletelyHeadlandPos then
            self:setRotationCenter()
        elseif spec.ai.lastHeadlandPosition < spec.ai.rotateCompletelyHeadlandPos and progress > spec.ai.rotateCompletelyHeadlandPos then
                self:setRotationMax(isLeft)
            end

            spec.ai.lastHeadlandPosition = progress
        end
    end

```

### onDeactivate

**Description**

**Definition**

> onDeactivate()

**Code**

```lua
function Plow:onDeactivate()
    if self.isClient then
        local spec = self.spec_plow
        g_soundManager:stopSamples(spec.samples.work)
        g_soundManager:stopSamples(spec.samples.turn)
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
function Plow:onDelete()
    local spec = self.spec_plow
    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.turn)
        g_soundManager:deleteSamples(spec.samples.work)
    end
end

```

### onEndWorkAreaProcessing

**Description**

**Definition**

> onEndWorkAreaProcessing()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Plow:onEndWorkAreaProcessing(dt)
    local spec = self.spec_plow

    if self.isServer then
        local farmId = self:getLastTouchedFarmlandFarmId()

        local lastStatsArea = spec.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_farmManager:updateFarmStats(farmId, "plowedHectares" , ha)
            self:updateLastWorkedArea(lastStatsArea)
        end

        if spec.isWorking then
            g_farmManager:updateFarmStats(farmId, "plowedTime" , dt / ( 1000 * 60 ))
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

### onFinishAnimation

**Description**

**Definition**

> onFinishAnimation()

**Arguments**

| any | animName |
|-----|----------|

**Code**

```lua
function Plow:onFinishAnimation(animName)
    local spec = self.spec_plow
    if animName = = spec.rotationPart.turnAnimation then
        g_soundManager:stopSamples(spec.samples.turn)
    end
end

```

### onFoldTimeChanged

**Description**

**Definition**

> onFoldTimeChanged()

**Arguments**

| any | foldAnimTime |
|-----|--------------|

**Code**

```lua
function Plow:onFoldTimeChanged(foldAnimTime)
    if self.isServer then
        local spec = self.spec_plow
        if spec.ai.rotationMaxToSet ~ = nil then
            if self:getIsPlowRotationAllowed() then
                self:setRotationMax(spec.ai.rotationMaxToSet)
                spec.ai.rotationMaxToSet = nil
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
function Plow:onLoad(savegame)

    if self:getGroundReferenceNodeFromIndex( 1 ) = = nil then
        printWarning( "Warning:No ground reference nodes in " .. self.configFileName)
    end

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.rotationPart" , "vehicle.plow.rotationPart" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.ploughDirectionNode#index" , "vehicle.plow.directionNode#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.rotateLeftToMax#value" , "vehicle.plow.rotateLeftToMax#value" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.animTimeCenterPosition#value" , "vehicle.plow.ai#centerPosition" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.aiPlough#rotateEarly" , "vehicle.plow.ai#rotateCompletelyHeadlandPos" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.onlyActiveWhenLowered#value" , "vehicle.plow.onlyActiveWhenLowered#value" ) --FS17 to FS19

    local plowConfigurationId = self.configurations[ "plow" ] or 1
    local configKey = string.format( "vehicle.plow.plowConfigurations.plowConfiguration(%d)" , plowConfigurationId - 1 )

    if not self.xmlFile:hasProperty(configKey) then
        configKey = "vehicle.plow"
    end

    local spec = self.spec_plow

    spec.rotationPart = { }
    spec.rotationPart.turnAnimation = self.xmlFile:getValue(configKey .. ".rotationPart#turnAnimationName" )
    spec.rotationPart.foldMinLimit = self.xmlFile:getValue(configKey .. ".rotationPart#foldMinLimit" , 0 )
    spec.rotationPart.foldMaxLimit = self.xmlFile:getValue(configKey .. ".rotationPart#foldMaxLimit" , 1 )
    spec.rotationPart.limitFoldRotationMax = self.xmlFile:getValue(configKey .. ".rotationPart#limitFoldRotationMax" )
    spec.rotationPart.foldRotationMinLimit = self.xmlFile:getValue(configKey .. ".rotationPart#foldRotationMinLimit" , 0 )
    spec.rotationPart.foldRotationMaxLimit = self.xmlFile:getValue(configKey .. ".rotationPart#foldRotationMaxLimit" , 1 )
    spec.rotationPart.rotationFoldMinLimit = self.xmlFile:getValue(configKey .. ".rotationPart#rotationFoldMinLimit" , 0 )
    spec.rotationPart.rotationFoldMaxLimit = self.xmlFile:getValue(configKey .. ".rotationPart#rotationFoldMaxLimit" , 1 )
    spec.rotationPart.detachMinLimit = self.xmlFile:getValue(configKey .. ".rotationPart#detachMinLimit" , 0 )
    spec.rotationPart.detachMaxLimit = self.xmlFile:getValue(configKey .. ".rotationPart#detachMaxLimit" , 1 )
    spec.rotationPart.rotationAllowedIfLowered = self.xmlFile:getValue(configKey .. ".rotationPart#rotationAllowedIfLowered" , true )

    spec.rotationPart.detachWarning = string.format( self.xmlFile:getValue(configKey .. ".rotationPart#detachWarning" , "warning_detachNotAllowedPlowTurn" , self.customEnvironment, false ))

    spec.directionNode = self.xmlFile:getValue(configKey .. ".directionNode#node" , self.components[ 1 ].node, self.components, self.i3dMappings)

    self:setPlowAIRequirements()

    spec.ai = { }
    spec.ai.centerPosition = self.xmlFile:getValue(configKey .. ".ai#centerPosition" , 0.5 )
    spec.ai.rotateToCenterHeadlandPos = self.xmlFile:getValue(configKey .. ".ai#rotateToCenterHeadlandPos" , 0.5 )
    spec.ai.rotateCompletelyHeadlandPos = self.xmlFile:getValue(configKey .. ".ai#rotateCompletelyHeadlandPos" , 0.5 )
    spec.ai.stopDuringTurn = self.xmlFile:getValue(configKey .. ".ai#stopDuringTurn" , true )
    spec.ai.allowTurnWhileReversing = self.xmlFile:getValue(configKey .. ".ai#allowTurnWhileReversing" , true )
    spec.ai.lastHeadlandPosition = 0

    spec.rotateLeftToMax = self.xmlFile:getValue(configKey .. ".rotateLeftToMax#value" , true )
    spec.onlyActiveWhenLowered = self.xmlFile:getValue(configKey .. ".onlyActiveWhenLowered#value" , true )
    spec.rotationMax = false
    spec.startActivationTimeout = 2000
    spec.startActivationTime = 0
    spec.lastPlowArea = 0
    spec.limitToField = true
    spec.forceLimitToField = false
    spec.wasTurnAnimationStopped = false
    spec.isWorking = false

    if self.isClient then
        spec.samples = { }
        spec.samples.turn = g_soundManager:loadSamplesFromXML( self.xmlFile, configKey .. ".sounds" , "turn" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.samples.work = g_soundManager:loadSamplesFromXML( self.xmlFile, configKey .. ".sounds" , "work" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        spec.isWorkSamplePlaying = false
    end

    spec.texts = { }
    spec.texts.warningFoldingLowered = g_i18n:getText( "warning_foldingNotWhileLowered" )
    spec.texts.warningFoldingPlowTurned = g_i18n:getText( "warning_foldingNotWhilePlowTurned" )
    spec.texts.turnPlow = g_i18n:getText( "action_turnPlow" )
    spec.texts.allowCreateFields = g_i18n:getText( "action_allowCreateFields" )
    spec.texts.limitToFields = g_i18n:getText( "action_limitToFields" )

    spec.workAreaParameters = { }
    spec.workAreaParameters.limitToField = self:getPlowLimitToField()
    spec.workAreaParameters.forceLimitToField = self:getPlowForceLimitToField()
    spec.workAreaParameters.angle = 0
    spec.workAreaParameters.lastChangedArea = 0
    spec.workAreaParameters.lastStatsArea = 0
    spec.workAreaParameters.lastTotalArea = 0

    if not self.isClient then
        SpecializationUtil.removeEventListener( self , "onUpdate" , Plow )
    end
end

```

### onPostAttach

**Description**

> Called if vehicle gets attached

**Definition**

> onPostAttach(table attacherVehicle, integer inputJointDescIndex, integer jointDescIndex)

**Arguments**

| table   | attacherVehicle     | attacher vehicle                            |
|---------|---------------------|---------------------------------------------|
| integer | inputJointDescIndex | index of input attacher joint               |
| integer | jointDescIndex      | index of attacher joint it gets attached to |

**Code**

```lua
function Plow:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_plow

    spec.startActivationTime = g_currentMission.time + spec.startActivationTimeout
    if spec.wasTurnAnimationStopped then
        local dir = 1
        if not spec.rotationMax then
            dir = - 1
        end
        self:playAnimation(spec.rotationPart.turnAnimation, dir, self:getAnimationTime(spec.rotationPart.turnAnimation), true )
        spec.wasTurnAnimationStopped = false
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
function Plow:onPostLoad(savegame)
    if savegame ~ = nil and not savegame.resetVehicles then
        local rotationMax = savegame.xmlFile:getValue(savegame.key .. ".plow#rotationMax" )
        if rotationMax ~ = nil then
            if self:getIsPlowRotationAllowed() then
                local plowTurnAnimTime = savegame.xmlFile:getValue(savegame.key .. ".plow#turnAnimTime" )
                self:setRotationMax(rotationMax, true , plowTurnAnimTime)

                if self.updateCylinderedInitial ~ = nil then
                    self:updateCylinderedInitial( false )
                end
            end
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
function Plow:onPreDetach(attacherVehicle, implement)
    local spec = self.spec_plow

    spec.limitToField = true
    if self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) then
        self:stopAnimation(spec.rotationPart.turnAnimation, true )
        spec.wasTurnAnimationStopped = true
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
function Plow:onReadStream(streamId, connection)
    local spec = self.spec_plow

    local rotationMax = streamReadBool(streamId)
    local turnAnimTime
    if spec.rotationPart.turnAnimation ~ = nil and self.playAnimation ~ = nil then
        turnAnimTime = streamReadFloat32(streamId)
    end

    self:setRotationMax(rotationMax, true , turnAnimTime)

    if self.updateCylinderedInitial ~ = nil then
        self:updateCylinderedInitial( false )
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
function Plow:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_plow
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            if spec.rotationPart.turnAnimation ~ = nil then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA, self , Plow.actionEventTurn, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
                g_inputBinding:setActionEventText(actionEventId, spec.texts.turnPlow)
            end

            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA3, self , Plow.actionEventLimitToField, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
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
function Plow:onRootVehicleChanged(rootVehicle)
    local spec = self.spec_plow

    local specFoldable = self.spec_foldable
    if specFoldable ~ = nil and #specFoldable.foldingParts > 0 then
        local actionController = rootVehicle.actionController
        if actionController ~ = nil then
            if spec.controlledActionRotateBack ~ = nil then
                spec.controlledActionRotateBack:updateParent(actionController)
                return
            end

            spec.controlledActionRotateBack = actionController:registerAction( "rotateBackPlow" , nil , 3 )
            spec.controlledActionRotateBack:setCallback( self , Plow.actionControllerRotateBackEvent)
            spec.controlledActionRotateBack:addAIEventListener( self , "onAIImplementPrepareForTransport" , - 1 , true )
        else
                if spec.controlledActionRotateBack ~ = nil then
                    spec.controlledActionRotateBack:remove()
                    spec.controlledActionRotateBack = nil
                end
            end
        end

        local actionController = rootVehicle.actionController
        if actionController ~ = nil then
            if spec.controlledActionRotate ~ = nil then
                spec.controlledActionRotate:updateParent(actionController)
                return
            end

            spec.controlledActionRotate = actionController:registerAction( "rotatePlow" , nil , 3 )
            spec.controlledActionRotate:setCallback( self , Plow.actionControllerRotateEvent)
            spec.controlledActionRotate:setFinishedFunctions( self , function (vehicle) return self:getIsAnimationPlaying(spec.rotationPart.turnAnimation) end , false , false )
            spec.controlledActionRotate:addAIEventListener( self , "onAIImplementStart" , 1 , true )
            spec.controlledActionRotate:setResetOnDeactivation( false )
        else
                if spec.controlledActionRotate ~ = nil then
                    spec.controlledActionRotate:remove()
                    spec.controlledActionRotate = nil
                end
            end
        end

```

### onStartAnimation

**Description**

**Definition**

> onStartAnimation()

**Arguments**

| any | animName |
|-----|----------|

**Code**

```lua
function Plow:onStartAnimation(animName)
    local spec = self.spec_plow
    if animName = = spec.rotationPart.turnAnimation then
        g_soundManager:playSamples(spec.samples.turn)
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
function Plow:onStartWorkAreaProcessing(dt)
    local spec = self.spec_plow

    spec.isWorking = false

    local limitToField = self:getPlowLimitToField()
    local limitFruitDestructionToField = limitToField
    if not g_currentMission:getHasPlayerPermission( "createFields" , self:getOwnerConnection(), nil , true ) then
        limitToField = true
        limitFruitDestructionToField = true
    end

    local dx,_,dz = localDirectionToWorld(spec.directionNode, 0 , 0 , 1 )
    local angle = FSDensityMapUtil.convertToDensityMapAngle( MathUtil.getYRotationFromDirection(dx, dz), g_currentMission.fieldGroundSystem:getGroundAngleMaxValue())

    spec.workAreaParameters.limitToField = limitToField
    spec.workAreaParameters.limitFruitDestructionToField = limitFruitDestructionToField
    spec.workAreaParameters.angle = angle
    spec.workAreaParameters.lastChangedArea = 0
    spec.workAreaParameters.lastStatsArea = 0
    spec.workAreaParameters.lastTotalArea = 0
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
function Plow:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_plow

        local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
        if actionEvent ~ = nil then
            if not self:getPlowForceLimitToField() and g_currentMission:getHasPlayerPermission( "createFields" , self:getOwnerConnection()) then
                g_inputBinding:setActionEventActive(actionEvent.actionEventId, true )

                if self:getPlowLimitToField() then
                    g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.allowCreateFields)
                else
                        g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.texts.limitToFields)
                    end
                else
                        g_inputBinding:setActionEventActive(actionEvent.actionEventId, false )
                    end
                end

                if spec.rotationPart.turnAnimation ~ = nil then
                    actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA]
                    if actionEvent ~ = nil then
                        g_inputBinding:setActionEventActive(actionEvent.actionEventId, self:getCanTogglePlowRotation())
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
function Plow:onWriteStream(streamId, connection)
    local spec = self.spec_plow

    streamWriteBool(streamId, spec.rotationMax)
    if spec.rotationPart.turnAnimation ~ = nil and self.playAnimation ~ = nil then
        local turnAnimTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        streamWriteFloat32(streamId, turnAnimTime)
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
function Plow.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( WorkArea , specializations)
end

```

### processPlowArea

**Description**

**Definition**

> processPlowArea()

**Arguments**

| any | workArea |
|-----|----------|
| any | dt       |

**Code**

```lua
function Plow:processPlowArea(workArea, dt)
    local spec = self.spec_plow

    local xs,_,zs = getWorldTranslation(workArea.start)
    local xw,_,zw = getWorldTranslation(workArea.width)
    local xh,_,zh = getWorldTranslation(workArea.height)

    FSDensityMapUtil.eraseTireTrack(xs,zs, xw,zw, xh,zh)

    if not self.isServer and self.currentUpdateDistance > Plow.CLIENT_DM_UPDATE_RADIUS then
        return 0 , 0
    end

    local params = spec.workAreaParameters
    local changedArea, totalArea = 0 , 0

    if self.tailwaterDepth < 0.1 then
        changedArea, totalArea = FSDensityMapUtil.updatePlowArea(xs,zs, xw,zw, xh,zh, not params.limitToField, params.limitFruitDestructionToField, params.angle)
        changedArea = changedArea + FSDensityMapUtil.updateVineCultivatorArea(xs, zs, xw, zw, xh, zh)
    end

    params.lastChangedArea = params.lastChangedArea + changedArea
    params.lastStatsArea = params.lastStatsArea + changedArea
    params.lastTotalArea = params.lastTotalArea + totalArea

    spec.isWorking = self:getLastSpeed() > 0.5

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
function Plow.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onStartWorkAreaProcessing" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetach" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldCourseSettingsInitialized" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementStartTurn" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementTurnProgress" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementEndTurn" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementSideOffsetChanged" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementEnd" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onStartAnimation" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onFinishAnimation" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onFoldTimeChanged" , Plow )
    SpecializationUtil.registerEventListener(vehicleType, "onRootVehicleChanged" , Plow )
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
function Plow.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processPlowArea" , Plow.processPlowArea)
    SpecializationUtil.registerFunction(vehicleType, "processPlowShareArea" , Plow.processPlowShareArea)
    SpecializationUtil.registerFunction(vehicleType, "setRotationMax" , Plow.setRotationMax)
    SpecializationUtil.registerFunction(vehicleType, "setRotationCenter" , Plow.setRotationCenter)
    SpecializationUtil.registerFunction(vehicleType, "setPlowLimitToField" , Plow.setPlowLimitToField)
    SpecializationUtil.registerFunction(vehicleType, "getIsPlowRotationAllowed" , Plow.getIsPlowRotationAllowed)
    SpecializationUtil.registerFunction(vehicleType, "getCanTogglePlowRotation" , Plow.getCanTogglePlowRotation)
    SpecializationUtil.registerFunction(vehicleType, "getPlowLimitToField" , Plow.getPlowLimitToField)
    SpecializationUtil.registerFunction(vehicleType, "getPlowForceLimitToField" , Plow.getPlowForceLimitToField)
    SpecializationUtil.registerFunction(vehicleType, "setPlowAIRequirements" , Plow.setPlowAIRequirements)
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
function Plow.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , Plow.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldMiddleAllowed" , Plow.getIsFoldMiddleAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , Plow.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Plow.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadSpeedRotatingPartFromXML" , Plow.loadSpeedRotatingPartFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsSpeedRotatingPartActive" , Plow.getIsSpeedRotatingPartActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getSpeedRotatingPartDirection" , Plow.getSpeedRotatingPartDirection)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "doCheckSpeedLimit" , Plow.doCheckSpeedLimit)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , Plow.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , Plow.getIsWorkAreaActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanAIImplementContinueWork" , Plow.getCanAIImplementContinueWork)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIInvertMarkersOnTurn" , Plow.getAIInvertMarkersOnTurn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , Plow.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isDetachAllowed" , Plow.isDetachAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowsLowering" , Plow.getAllowsLowering)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIReadyToDrive" , Plow.getIsAIReadyToDrive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAIPreparingToDrive" , Plow.getIsAIPreparingToDrive)
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
function Plow.registerXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. ".rotationPart#turnAnimationName" , "Turn animation name" )
    schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#foldMinLimit" , "Fold min.limit" , 0 )
    schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#foldMaxLimit" , "Fold max.limit" , 1 )
    schema:register(XMLValueType.BOOL, basePath .. ".rotationPart#limitFoldRotationMax" , "Block folding if in max state" )
        schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#foldRotationMinLimit" , "Fold allow if inbetween this limit" , 0 )
            schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#foldRotationMaxLimit" , "Fold allow if inbetween this limit" , 1 )
                schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#rotationFoldMinLimit" , "Rotation allow if fold time inbetween this limit" , 0 )
                    schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#rotationFoldMaxLimit" , "Rotation allow if fold time inbetween this limit" , 1 )
                        schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#detachMinLimit" , "Detach is allowed if turn animation between these values" , 0 )
                            schema:register(XMLValueType.FLOAT, basePath .. ".rotationPart#detachMaxLimit" , "Detach is allowed if turn animation between these values" , 1 )
                                schema:register(XMLValueType.BOOL, basePath .. ".rotationPart#rotationAllowedIfLowered" , "Allow plow rotation if lowered" , true )

                                    schema:register(XMLValueType.L10N_STRING, basePath .. ".rotationPart#detachWarning" , "Warning to be displayed if not in correct turn state for detach" , "warning_detachNotAllowedPlowTurn" )

                                        schema:register(XMLValueType.NODE_INDEX, basePath .. ".directionNode#node" , "Plow direction node" )

                                        schema:register(XMLValueType.FLOAT, basePath .. ".ai#centerPosition" , "Center position" , 0.5 )
                                        schema:register(XMLValueType.FLOAT, basePath .. ".ai#rotateToCenterHeadlandPos" , "Rotate to center headland position" , 0.5 )
                                        schema:register(XMLValueType.FLOAT, basePath .. ".ai#rotateCompletelyHeadlandPos" , "Rotate completely headland position" , 0.5 )
                                        schema:register(XMLValueType.BOOL, basePath .. ".ai#stopDuringTurn" , "Stop the vehicle while the plow is turning" , true )
                                            schema:register(XMLValueType.BOOL, basePath .. ".ai#allowTurnWhileReversing" , "Allow the turn of the plow while we are reversing" , true )

                                                schema:register(XMLValueType.BOOL, basePath .. ".rotateLeftToMax#value" , "Rotate left to max" , true )
                                                schema:register(XMLValueType.BOOL, basePath .. ".onlyActiveWhenLowered#value" , "Only active when lowered" , true )

                                                SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "turn(?)" )
                                                SoundManager.registerSampleXMLPaths(schema, basePath .. ".sounds" , "work(?)" )
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
function Plow:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_plow
    xmlFile:setValue(key .. "#rotationMax" , spec.rotationMax)
    if spec.rotationPart.turnAnimation ~ = nil and self.playAnimation ~ = nil then
        local turnAnimTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        xmlFile:setValue(key .. "#turnAnimTime" , turnAnimTime)
    end
end

```

### setPlowAIRequirements

**Description**

> Sets plow ai requirements and optional exclude the given ground type

**Definition**

> setPlowAIRequirements(table excludedGroundTypes)

**Arguments**

| table | excludedGroundTypes | these ground types will be excluded |
|-------|---------------------|-------------------------------------|

**Code**

```lua
function Plow:setPlowAIRequirements(excludedGroundTypes)
    if self.clearAITerrainDetailRequiredRange ~ = nil then
        self:clearAITerrainDetailRequiredRange()

        if excludedGroundTypes ~ = nil then
            self:addAIGroundTypeRequirements( Plow.AI_REQUIRED_GROUND_TYPES, unpack(excludedGroundTypes))
        else
                self:addAIGroundTypeRequirements( Plow.AI_REQUIRED_GROUND_TYPES)
            end

            self:setAIImplementVariableSideOffset( true )
        end
    end

```

### setPlowLimitToField

**Description**

**Definition**

> setPlowLimitToField()

**Arguments**

| any | plowLimitToField |
|-----|------------------|
| any | noEventSend      |

**Code**

```lua
function Plow:setPlowLimitToField(plowLimitToField, noEventSend)
    local spec = self.spec_plow

    if spec.limitToField ~ = plowLimitToField then
        if noEventSend = = nil or noEventSend = = false then
            if g_server ~ = nil then
                g_server:broadcastEvent( PlowLimitToFieldEvent.new( self , plowLimitToField), nil , nil , self )
            else
                    g_client:getServerConnection():sendEvent( PlowLimitToFieldEvent.new( self , plowLimitToField))
                end
            end
            spec.limitToField = plowLimitToField

            local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA3]
            if actionEvent ~ = nil then
                local text
                if spec.limitToField then
                    text = spec.texts.allowCreateFields
                else
                        text = spec.texts.limitToFields
                    end
                    g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
                end
            end
        end

```

### setRotationCenter

**Description**

**Definition**

> setRotationCenter()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function Plow:setRotationCenter(noEventSend)
    local spec = self.spec_plow

    if spec.rotationPart.turnAnimation ~ = nil then
        local animTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
        if animTime ~ = spec.ai.centerPosition then
            self:setAnimationStopTime(spec.rotationPart.turnAnimation, spec.ai.centerPosition)

            if animTime < spec.ai.centerPosition then
                self:playAnimation(spec.rotationPart.turnAnimation, 1 , animTime, true )
            elseif animTime > spec.ai.centerPosition then
                    self:playAnimation(spec.rotationPart.turnAnimation, - 1 , animTime, true )
                end
            end
        end

        PlowRotationCenterEvent.sendEvent( self , noEventSend)
    end

```

### setRotationMax

**Description**

**Definition**

> setRotationMax()

**Arguments**

| any | rotationMax       |
|-----|-------------------|
| any | noEventSend       |
| any | turnAnimationTime |

**Code**

```lua
function Plow:setRotationMax(rotationMax, noEventSend, turnAnimationTime)
    PlowRotationEvent.sendEvent( self , rotationMax, noEventSend)

    local spec = self.spec_plow

    spec.rotationMax = rotationMax

    if spec.rotationPart.turnAnimation ~ = nil then
        if turnAnimationTime = = nil then
            local animTime = self:getAnimationTime(spec.rotationPart.turnAnimation)
            if spec.rotationMax then
                self:playAnimation(spec.rotationPart.turnAnimation, 1 , animTime, true )
            else
                    self:playAnimation(spec.rotationPart.turnAnimation, - 1 , animTime, true )
                end
            else
                    self:setAnimationTime(spec.rotationPart.turnAnimation, turnAnimationTime, true )
                end
            end
        end

```