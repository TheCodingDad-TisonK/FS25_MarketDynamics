## Cylindered

**Description**

> Specialization for vehicles with dependent movable parts (e.g. cylinders)

**Functions**

- [actionEventInput](#actioneventinput)
- [allowLoadMovingToolStates](#allowloadmovingtoolstates)
- [checkMovingPartDirtyUpdateNode](#checkmovingpartdirtyupdatenode)
- [getAdditionalSchemaText](#getadditionalschematext)
- [getConsumingLoad](#getconsumingload)
- [getDischargeNodeEmptyFactor](#getdischargenodeemptyfactor)
- [getDoConsumePtoPower](#getdoconsumeptopower)
- [getIsDynamicMountGrabOpened](#getisdynamicmountgrabopened)
- [getIsMovingPartActive](#getismovingpartactive)
- [getIsMovingToolActive](#getismovingtoolactive)
- [getMovingPartByNode](#getmovingpartbynode)
- [getMovingToolByNode](#getmovingtoolbynode)
- [getMovingToolDashboardState](#getmovingtooldashboardstate)
- [getMovingToolMoveValue](#getmovingtoolmovevalue)
- [getMovingToolState](#getmovingtoolstate)
- [getShovelNodeIsActive](#getshovelnodeisactive)
- [getTranslatingPartByNode](#gettranslatingpartbynode)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [isDetachAllowed](#isdetachallowed)
- [limitInterpolator](#limitinterpolator)
- [loadActionSoundsFromXML](#loadactionsoundsfromxml)
- [loadCopyLocalDirectionParts](#loadcopylocaldirectionparts)
- [loadDependentAnimations](#loaddependentanimations)
- [loadDependentAttacherJoints](#loaddependentattacherjoints)
- [loadDependentComponentJoints](#loaddependentcomponentjoints)
- [loadDependentMovingTools](#loaddependentmovingtools)
- [loadDependentParts](#loaddependentparts)
- [loadDependentTranslatingParts](#loaddependenttranslatingparts)
- [loadDependentWheels](#loaddependentwheels)
- [loadDischargeNode](#loaddischargenode)
- [loadDynamicMountGrabFromXML](#loaddynamicmountgrabfromxml)
- [loadEasyArmControlFromXML](#loadeasyarmcontrolfromxml)
- [loadExtraDependentParts](#loadextradependentparts)
- [loadMovingPartFromXML](#loadmovingpartfromxml)
- [loadMovingPartsFromXML](#loadmovingpartsfromxml)
- [loadMovingToolFromXML](#loadmovingtoolfromxml)
- [loadMovingToolsFromXML](#loadmovingtoolsfromxml)
- [loadObjectChangeValuesFromXML](#loadobjectchangevaluesfromxml)
- [loadRotationBasedLimits](#loadrotationbasedlimits)
- [loadShovelNode](#loadshovelnode)
- [movingToolDashboardAttributes](#movingtooldashboardattributes)
- [onAIImplementStart](#onaiimplementstart)
- [onAnimationPartChanged](#onanimationpartchanged)
- [onDeactivate](#ondeactivate)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onMovingPartSoundEvent](#onmovingpartsoundevent)
- [onPostAttach](#onpostattach)
- [onPostLoad](#onpostload)
- [onPostUpdate](#onpostupdate)
- [onPostUpdateTick](#onpostupdatetick)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterAnimationValueTypes](#onregisteranimationvaluetypes)
- [onRegisterDashboardValueTypes](#onregisterdashboardvaluetypes)
- [onSelect](#onselect)
- [onUnselect](#onunselect)
- [onUpdate](#onupdate)
- [onUpdateEnd](#onupdateend)
- [onUpdateTick](#onupdatetick)
- [onVehicleSettingChanged](#onvehiclesettingchanged)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerCopyLocalDirectionXMLPaths](#registercopylocaldirectionxmlpaths)
- [registerDependentAnimationXMLPaths](#registerdependentanimationxmlpaths)
- [registerDependentComponentJointXMLPaths](#registerdependentcomponentjointxmlpaths)
- [registerDependentMovingToolXMLPaths](#registerdependentmovingtoolxmlpaths)
- [registerEasyArmControlXMLPaths](#registereasyarmcontrolxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerMovingPartXMLPaths](#registermovingpartxmlpaths)
- [registerMovingToolXMLPaths](#registermovingtoolxmlpaths)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSoundXMLPaths](#registersoundxmlpaths)
- [resolveDependentPartData](#resolvedependentpartdata)
- [saveToXMLFile](#savetoxmlfile)
- [setAbsoluteToolRotation](#setabsolutetoolrotation)
- [setAbsoluteToolTranslation](#setabsolutetooltranslation)
- [setComponentJointFrame](#setcomponentjointframe)
- [setDelayedData](#setdelayeddata)
- [setDirty](#setdirty)
- [setEasyControlForcedTransMove](#seteasycontrolforcedtransmove)
- [setIsEasyControlActive](#setiseasycontrolactive)
- [setMovingPartReferenceNode](#setmovingpartreferencenode)
- [setMovingToolDirty](#setmovingtooldirty)
- [setObjectChangeValues](#setobjectchangevalues)
- [setToolAnimation](#settoolanimation)
- [setToolRotation](#settoolrotation)
- [setToolTranslation](#settooltranslation)
- [updateAttacherJoints](#updateattacherjoints)
- [updateComponentJoints](#updatecomponentjoints)
- [updateControlGroups](#updatecontrolgroups)
- [updateCylinderedInitial](#updatecylinderedinitial)
- [updateDelayedTool](#updatedelayedtool)
- [updateDependentAnimations](#updatedependentanimations)
- [updateDependentToolLimits](#updatedependenttoollimits)
- [updateDirtyMovingParts](#updatedirtymovingparts)
- [updateEasyControl](#updateeasycontrol)
- [updateExtraDependentParts](#updateextradependentparts)
- [updateMovingPart](#updatemovingpart)
- [updateMovingPartByNode](#updatemovingpartbynode)
- [updateMovingToolSoundEvents](#updatemovingtoolsoundevents)
- [updateRotationBasedLimits](#updaterotationbasedlimits)
- [updateWheels](#updatewheels)

### actionEventInput

**Description**

**Definition**

> actionEventInput()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |
| any | isMouse       |

**Code**

```lua
function Cylindered.actionEventInput( self , actionName, inputValue, callbackState, isAnalog, isMouse)
    local spec = self.spec_cylindered
    local tool = spec.movingTools[callbackState]

    if tool ~ = nil then
        tool.lastInputTime = g_ time

        local move
        if tool.invertAxis then
            move = - inputValue
        else
                move = inputValue
            end

            move = move * g_gameSettings:getValue(GameSettings.SETTING.VEHICLE_ARM_SENSITIVITY)
            if isMouse then
                -- revert dt scaling for mouse input
                    move = move * 16.666 / g_currentDt * tool.mouseSpeedFactor

                    -- allow only the input of the highest mouse axis value
                    -- lock the move of the lower mouse axis value until it is higher than 0.75 or the value is higher than the doubled value of the other tool
                    if tool.moveLocked then
                        if math.abs(inputValue) < 0.75 then
                            if math.abs(move) > math.abs(tool.lockTool.move) * 2 then
                                tool.moveLocked = false
                            else
                                    move = 0
                                end
                            else
                                    tool.moveLocked = false
                                end
                            else
                                    local checkOtherTools = function (tools)
                                        for tool2Index, tool2 in ipairs(tools) do
                                            if tool2Index ~ = callbackState then
                                                if tool2.move ~ = nil and tool2.move ~ = 0 then
                                                    if math.abs(move) > math.abs(tool2.move) then
                                                        tool2.move = 0
                                                        tool2.moveToSend = 0
                                                        tool2.moveLocked = true
                                                        tool2.lockTool = tool
                                                    else
                                                            move = 0
                                                            tool.moveLocked = true
                                                            tool.lockTool = tool2
                                                        end
                                                    end
                                                end
                                            end
                                        end

                                        checkOtherTools(spec.movingTools)

                                        if self.getAttachedImplements ~ = nil then
                                            for _, implement in pairs( self:getAttachedImplements()) do
                                                local vehicle = implement.object
                                                if vehicle.spec_cylindered ~ = nil then
                                                    checkOtherTools(vehicle.spec_cylindered.movingTools)
                                                end
                                            end
                                        end
                                    end
                                end

                                if move ~ = tool.move then
                                    tool.move = move
                                end

                                if tool.move ~ = tool.moveToSend then
                                    tool.moveToSend = tool.move
                                    self:raiseDirtyFlags(spec.cylinderedInputDirtyFlag)
                                end

                                tool.smoothedMove = tool.smoothedMove * 0.9 + move * 0.1
                            end
                        end

```

### allowLoadMovingToolStates

**Description**

> Returns if loading of moving tool stats from savegame is allowed

**Definition**

> allowLoadMovingToolStates()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | isAllowed | is allowed |
|-----|-----------|------------|

**Code**

```lua
function Cylindered:allowLoadMovingToolStates(superFunc)
    return true
end

```

### checkMovingPartDirtyUpdateNode

**Description**

**Definition**

> checkMovingPartDirtyUpdateNode()

**Arguments**

| any | node       |
|-----|------------|
| any | movingPart |

**Code**

```lua
function Cylindered:checkMovingPartDirtyUpdateNode(node, movingPart)
end

```

### getAdditionalSchemaText

**Description**

**Definition**

> getAdditionalSchemaText()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Cylindered:getAdditionalSchemaText(superFunc)
    local t = superFunc( self )
    if self.isClient then
        if self:getIsActiveForInput( true ) then
            local spec = self.spec_cylindered
            if #spec.controlGroupNames > 1 and spec.currentControlGroupIndex ~ = 0 then
                t = tostring(spec.currentControlGroupIndex)
            end
        end
    end

    return t
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
function Cylindered:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local spec = self.spec_cylindered
    local loadPercentage = math.max(spec.powerConsumingTimer / spec.powerConsumingActiveTimeOffset, 0 )
    return value + loadPercentage, count + 1
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
function Cylindered:getDischargeNodeEmptyFactor(superFunc, dischargeNode)
    if dischargeNode.movingToolActivation = = nil then
        return superFunc( self , dischargeNode)
    else
            local spec = self.spec_cylindered
            local movingToolActivation = dischargeNode.movingToolActivation

            local currentSpeed = superFunc( self , dischargeNode)

            local movingTool = spec.nodesToMovingTools[movingToolActivation.node]
            local state = math.clamp( Cylindered.getMovingToolState( self , movingTool), 0 , 1 )
            if movingToolActivation.isInverted then
                state = math.abs(state - 1 )
            end

            state = math.max(state - movingToolActivation.openOffset, 0 ) / movingToolActivation.openOffsetInv
            local speedFactor = math.clamp(state / movingToolActivation.openFactor, 0 , 1 )

            return currentSpeed * speedFactor
        end
    end

```

### getDoConsumePtoPower

**Description**

> Returns if should consume pto power

**Definition**

> getDoConsumePtoPower()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | consume | consumePtoPower |
|-----|---------|-----------------|

**Code**

```lua
function Cylindered:getDoConsumePtoPower(superFunc)
    return superFunc( self ) or self.spec_cylindered.powerConsumingTimer > 0
end

```

### getIsDynamicMountGrabOpened

**Description**

**Definition**

> getIsDynamicMountGrabOpened()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | grab      |

**Code**

```lua
function Cylindered:getIsDynamicMountGrabOpened(superFunc, grab)
    local isActive = superFunc( self , grab)
    if not isActive or grab.movingToolActivation = = nil then
        return isActive
    end

    local spec = self.spec_cylindered
    local movingToolActivation = grab.movingToolActivation
    local movingTool = spec.nodesToMovingTools[movingToolActivation.node]
    local state = Cylindered.getMovingToolState( self , movingTool)
    if movingToolActivation.isInverted then
        state = math.abs(state - 1 )
    end

    return state > movingToolActivation.openFactor
end

```

### getIsMovingPartActive

**Description**

**Definition**

> getIsMovingPartActive()

**Arguments**

| any | movingPart |
|-----|------------|

**Code**

```lua
function Cylindered:getIsMovingPartActive(movingPart)
    return movingPart.isActive
end

```

### getIsMovingToolActive

**Description**

**Definition**

> getIsMovingToolActive()

**Arguments**

| any | movingTool |
|-----|------------|

**Code**

```lua
function Cylindered:getIsMovingToolActive(movingTool)
    return movingTool.isActive and movingTool.hasRequiredConfigurations
end

```

### getMovingPartByNode

**Description**

**Definition**

> getMovingPartByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Cylindered:getMovingPartByNode(node)
    return self.spec_cylindered.nodesToMovingParts[node]
end

```

### getMovingToolByNode

**Description**

**Definition**

> getMovingToolByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Cylindered:getMovingToolByNode(node)
    return self.spec_cylindered.nodesToMovingTools[node]
end

```

### getMovingToolDashboardState

**Description**

**Definition**

> getMovingToolDashboardState()

**Arguments**

| any | self      |
|-----|-----------|
| any | dashboard |

**Code**

```lua
function Cylindered.getMovingToolDashboardState( self , dashboard)
    local vehicle = self

    if dashboard.attacherJointNodes ~ = nil then
        if dashboard.attacherJointIndices = = nil then
            dashboard.attacherJointIndices = { }
        end

        for _, node in ipairs(dashboard.attacherJointNodes) do
            local index = self:getAttacherJointIndexByNode(node)
            if index ~ = nil then
                table.insert(dashboard.attacherJointIndices, index)
            end
        end

        dashboard.attacherJointNodes = nil
        if #dashboard.attacherJointIndices = = 0 then
            dashboard.attacherJointIndices = nil
        end
    end

    if dashboard.attacherJointIndices ~ = nil then
        vehicle = nil
        for _, index in ipairs(dashboard.attacherJointIndices) do
            local implement = self:getImplementFromAttacherJointIndex(index)
            if implement ~ = nil then
                vehicle = implement.object
                break
            end
        end
    end

    if vehicle ~ = nil then
        local spec = vehicle.spec_cylindered
        if spec ~ = nil then
            for _, movingTool in ipairs(spec.movingTools) do
                if movingTool.axis = = dashboard.axis then
                    local isSelectedGroup = movingTool.controlGroupIndex = = 0 or movingTool.controlGroupIndex = = spec.currentControlGroupIndex
                    local easyArmControlActive = false
                    if spec.easyArmControl ~ = nil then
                        easyArmControlActive = spec.easyArmControl.state
                    end
                    local canBeControlled = (easyArmControlActive and movingTool.easyArmControlActive) or( not easyArmControlActive and not movingTool.isEasyControlTarget)
                    if isSelectedGroup and canBeControlled then
                        return(movingTool.smoothedMove + 1 ) / 2
                    end
                end
            end
        end
    end

    return 0.5
end

```

### getMovingToolMoveValue

**Description**

**Definition**

> getMovingToolMoveValue()

**Arguments**

| any | movingTool |
|-----|------------|

**Code**

```lua
function Cylindered:getMovingToolMoveValue(movingTool)
    return movingTool.move + movingTool.externalMove
end

```

### getMovingToolState

**Description**

> Returns moving tool state

**Definition**

> getMovingToolState(table tool, )

**Arguments**

| table | tool | tool |
|-------|------|------|
| any   | tool |      |

**Return Values**

| any | state | state of moving tool [0..1] |
|-----|-------|-----------------------------|

**Code**

```lua
function Cylindered.getMovingToolState( self , tool)
    local state = 0
    if tool.rotMax ~ = nil and tool.rotMin ~ = nil then
        state = (tool.curRot[tool.rotationAxis] - tool.rotMin) / (tool.rotMax - tool.rotMin)
    elseif tool.rotSpeed ~ = nil then
            state = tool.curRot[tool.rotationAxis]
        elseif tool.transMax ~ = nil and tool.transMin ~ = nil then
                state = (tool.curTrans[tool.translationAxis] - tool.transMin) / (tool.transMax - tool.transMin)
            elseif tool.transSpeed ~ = nil then
                    state = tool.curTrans[tool.translationAxis]
                elseif tool.animName ~ = nil then
                        return self:getAnimationTime(tool.animName)
                    end

                    return state
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
function Cylindered:getShovelNodeIsActive(superFunc, shovelNode)
    local isActive = superFunc( self , shovelNode)
    if not isActive or shovelNode.movingToolActivation = = nil then
        return isActive
    end

    local spec = self.spec_cylindered
    local movingToolActivation = shovelNode.movingToolActivation
    local movingTool = spec.nodesToMovingTools[movingToolActivation.node]
    local state = Cylindered.getMovingToolState( self , movingTool)
    if movingToolActivation.isInverted then
        state = math.abs(state - 1 )
    end

    return state > movingToolActivation.openFactor
end

```

### getTranslatingPartByNode

**Description**

**Definition**

> getTranslatingPartByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Cylindered:getTranslatingPartByNode(node)
    local spec = self.spec_cylindered
    for i = 1 , #spec.movingParts do
        local part = spec.movingParts[i]
        if part.translatingParts ~ = nil then
            for j = 1 , part.numTranslatingParts do
                if part.translatingParts[j].node = = node then
                    return part.translatingParts[j]
                end
            end
        end
    end

    return nil
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

| any | wearMultiplier | current wear multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function Cylindered:getWearMultiplier(superFunc)
    local spec = self.spec_cylindered
    local multiplier = superFunc( self )

    if spec.isHydraulicSamplePlaying then
        multiplier = multiplier + self:getWorkWearMultiplier()
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
function Cylindered.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "cylindered" , g_i18n:getText( "shop_configuration" ), "cylindered" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema

    schema:setXMLSpecializationType( "Cylindered" )

    schema:register(XMLValueType.TIME, "vehicle.cylindered.movingTools#powerConsumingActiveTimeOffset" , "Power consumer deactivation delay.After the moving tool has not been moved this long it will no longer consume power." , 5 )

    Cylindered.registerSoundXMLPaths(schema, "vehicle.cylindered.sounds" )
    Cylindered.registerSoundXMLPaths(schema, "vehicle.cylindered.cylinderedConfigurations.cylinderedConfiguration(?).sounds" )

    for _, toolKey in ipairs( Cylindered.MOVING_TOOLS_XML_KEYS) do
        Cylindered.registerMovingToolXMLPaths(schema, toolKey .. ".movingTool(?)" )
        Cylindered.registerEasyArmControlXMLPaths(schema, toolKey .. ".easyArmControl" )

        schema:register(XMLValueType.L10N_STRING, toolKey .. ".controlGroups.controlGroup(?)#name" , "Control group name" )
    end

    for _, partKey in ipairs( Cylindered.MOVING_PART_XML_KEYS) do
        Cylindered.registerMovingPartXMLPaths(schema, partKey)
    end

    schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
        cSchema:register(XMLValueType.INT, cKey .. "#inputAttacherJointIndex" , "Input Attacher Joint Index [1 .. n]" )
    end )

    for _, dashboardKey in ipairs( Cylindered.DASHBOARD_XML_KEYS) do
        Dashboard.registerDashboardXMLPaths(schema, dashboardKey, { "movingTool" } )
        schema:register(XMLValueType.STRING, dashboardKey .. ".dashboard(?)#axis" , "Moving tool input action name" )
        schema:register(XMLValueType.INT, dashboardKey .. ".dashboard(?)#attacherJointIndex" , "Index of attacher joint that has to be connected" )
        schema:register(XMLValueType.NODE_INDEX, dashboardKey .. ".dashboard(?)#attacherJointNode" , "Node of attacher joint that has to be connected" )
        schema:register(XMLValueType.NODE_INDICES, dashboardKey .. ".dashboard(?)#attacherJointNodes" , "List of attacher joints nodes that has to be connected(on of them)" )
    end

    ObjectChangeUtil.addAdditionalObjectChangeXMLPaths(schema, function (_schema, key)
        _schema:register(XMLValueType.ANGLE, key .. "#movingToolRotMaxActive" , "Moving tool max.rotation if object change active" )
            _schema:register(XMLValueType.ANGLE, key .. "#movingToolRotMaxInactive" , "Moving tool max.rotation if object change inactive" )
                _schema:register(XMLValueType.ANGLE, key .. "#movingToolRotMinActive" , "Moving tool min.rotation if object change active" )
                    _schema:register(XMLValueType.ANGLE, key .. "#movingToolRotMinInactive" , "Moving tool min.rotation if object change inactive" )

                        _schema:register(XMLValueType.ANGLE, key .. "#movingToolStartRotActive" , "Moving tool start rotation if object change inactive" )
                            _schema:register(XMLValueType.ANGLE, key .. "#movingToolStartRotInactive" , "Moving tool start rotation if object change inactive" )

                                _schema:register(XMLValueType.FLOAT, key .. "#movingToolTransMaxActive" , "Moving tool max.translation if object change active" )
                                    _schema:register(XMLValueType.FLOAT, key .. "#movingToolTransMaxInactive" , "Moving tool max.translation if object change inactive" )
                                        _schema:register(XMLValueType.FLOAT, key .. "#movingToolTransMinActive" , "Moving tool min.translation if object change active" )
                                            _schema:register(XMLValueType.FLOAT, key .. "#movingToolTransMinInactive" , "Moving tool min.translation if object change inactive" )

                                                _schema:register(XMLValueType.FLOAT, key .. "#movingToolStartTransActive" , "Moving tool start translation if object change inactive" )
                                                    _schema:register(XMLValueType.FLOAT, key .. "#movingToolStartTransInactive" , "Moving tool start translation if object change inactive" )

                                                        _schema:register(XMLValueType.BOOL, key .. "#movingPartUpdateActive" , "moving part active state if object change active" )
                                                            _schema:register(XMLValueType.BOOL, key .. "#movingPartUpdateInactive" , "moving part active state if object change inactive" )
                                                            end )

                                                            schema:register(XMLValueType.NODE_INDEX, Dischargeable.DISCHARGE_NODE_XML_PATH .. ".movingToolActivation#node" , "Moving tool node" )
                                                            schema:register(XMLValueType.BOOL, Dischargeable.DISCHARGE_NODE_XML_PATH .. ".movingToolActivation#isInverted" , "Activation is inverted" , false )
                                                            schema:register(XMLValueType.FLOAT, Dischargeable.DISCHARGE_NODE_XML_PATH .. ".movingToolActivation#openFactor" , "Open factor" , 1 )
                                                            schema:register(XMLValueType.FLOAT, Dischargeable.DISCHARGE_NODE_XML_PATH .. ".movingToolActivation#openOffset" , "Open offset" , 0 )

                                                            schema:register(XMLValueType.NODE_INDEX, Dischargeable.DISCHARGE_NODE_CONFIG_XML_PATH .. ".movingToolActivation#node" , "Moving tool node" )
                                                            schema:register(XMLValueType.BOOL, Dischargeable.DISCHARGE_NODE_CONFIG_XML_PATH .. ".movingToolActivation#isInverted" , "Activation is inverted" , false )
                                                            schema:register(XMLValueType.FLOAT, Dischargeable.DISCHARGE_NODE_CONFIG_XML_PATH .. ".movingToolActivation#openFactor" , "Open factor" , 1 )
                                                            schema:register(XMLValueType.FLOAT, Dischargeable.DISCHARGE_NODE_CONFIG_XML_PATH .. ".movingToolActivation#openOffset" , "Open offset" , 0 )

                                                            schema:register(XMLValueType.NODE_INDEX, Shovel.SHOVEL_NODE_XML_KEY .. ".movingToolActivation#node" , "Moving tool node" )
                                                            schema:register(XMLValueType.BOOL, Shovel.SHOVEL_NODE_XML_KEY .. ".movingToolActivation#isInverted" , "Activation is inverted" , false )
                                                            schema:register(XMLValueType.FLOAT, Shovel.SHOVEL_NODE_XML_KEY .. ".movingToolActivation#openFactor" , "Open factor" , 1 )

                                                            schema:register(XMLValueType.NODE_INDEX, DynamicMountAttacher.DYNAMIC_MOUNT_GRAB_XML_PATH .. ".movingToolActivation#node" , "Moving tool node" )
                                                            schema:register(XMLValueType.BOOL, DynamicMountAttacher.DYNAMIC_MOUNT_GRAB_XML_PATH .. ".movingToolActivation#isInverted" , "Activation is inverted" , false )
                                                            schema:register(XMLValueType.FLOAT, DynamicMountAttacher.DYNAMIC_MOUNT_GRAB_XML_PATH .. ".movingToolActivation#openFactor" , "Open factor" , 1 )

                                                            schema:addDelayedRegistrationFunc( "AnimatedVehicle:part" , function (cSchema, cKey)
                                                                cSchema:register(XMLValueType.NODE_INDEX, cKey .. "#startReferencePoint" , "Start reference point" )
                                                                cSchema:register(XMLValueType.NODE_INDEX, cKey .. "#endReferencePoint" , "End reference point" )
                                                            end )

                                                            schema:setXMLSpecializationType()

                                                            local schemaSavegame = Vehicle.xmlSchemaSavegame
                                                            schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).cylindered.movingTool(?)#translation" , "Current translation value" )
                                                            schemaSavegame:register(XMLValueType.ANGLE, "vehicles.vehicle(?).cylindered.movingTool(?)#rotation" , "Current rotation in rad" )
                                                            schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?).cylindered.movingTool(?)#animationTime" , "Current animation time" )
                                                        end

```

### isDetachAllowed

**Description**

> Returns true if detach is allowed

**Definition**

> isDetachAllowed(function superFunc)

**Arguments**

| function | superFunc |
|----------|-----------|

**Return Values**

| function | detachAllowed | detach is allowed                  |
|----------|---------------|------------------------------------|
| function | warning       | [optional] warning text to display |

**Code**

```lua
function Cylindered:isDetachAllowed(superFunc)
    local spec = self.spec_cylindered
    if spec.detachLockNodes ~ = nil then
        for entry, data in pairs(spec.detachLockNodes) do
            local node = entry.node
            local rot = select(entry.rotationAxis, getRotation(node))

            if data.detachingRotMinLimit ~ = nil and rot < data.detachingRotMinLimit then
                return false , nil
            end
            if data.detachingRotMaxLimit ~ = nil and rot > data.detachingRotMaxLimit then
                return false , nil
            end

            local trans = select(entry.translationAxis, getTranslation(node))
            if data.detachingTransMinLimit ~ = nil and trans < data.detachingTransMinLimit then
                return false , nil
            end
            if data.detachingTransMaxLimit ~ = nil and trans > data.detachingTransMaxLimit then
                return false , nil
            end
        end
    end

    return superFunc( self )
end

```

### limitInterpolator

**Description**

**Definition**

> limitInterpolator()

**Arguments**

| any | first  |
|-----|--------|
| any | second |
| any | alpha  |

**Code**

```lua
function Cylindered.limitInterpolator(first, second, alpha)
    local oneMinusAlpha = 1 - alpha

    local rotMin = nil
    local rotMax = nil
    local transMin = nil
    local transMax = nil

    if first.rotMin ~ = nil and second.rotMin ~ = nil then
        rotMin = first.rotMin * alpha + second.rotMin * oneMinusAlpha
    end
    if first.rotMax ~ = nil and second.rotMax ~ = nil then
        rotMax = first.rotMax * alpha + second.rotMax * oneMinusAlpha
    end
    if first.transMin ~ = nil and second.transMin ~ = nil then
        transMin = first.minTrans * alpha + second.transMin * oneMinusAlpha
    end
    if first.transMax ~ = nil and second.transMax ~ = nil then
        transMax = first.transMax * alpha + second.transMax * oneMinusAlpha
    end

    return rotMin, rotMax, transMin, transMax
end

```

### loadActionSoundsFromXML

**Description**

**Definition**

> loadActionSoundsFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function Cylindered:loadActionSoundsFromXML(xmlFile, key)
    local spec = self.spec_cylindered

    local i = 0
    while true do
        local actionKey = string.format( "actionSound(%d)" , i)
        local baseKey = key .. "." .. actionKey
        if not xmlFile:hasProperty(baseKey) then
            break
        end

        local sample = g_soundManager:loadSampleFromXML(xmlFile, key, actionKey, self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )

        if sample ~ = nil then
            local actionNamesStr = xmlFile:getValue(baseKey .. "#actionNames" )
            local actionNames = string.split(actionNamesStr:trim(), " " )

            local nodesStr = xmlFile:getValue(baseKey .. "#nodes" )
            local nodes = string.split(nodesStr, " " )

            for l = 1 , #nodes do
                nodes[l] = I3DUtil.indexToObject( self.components, nodes[l], self.i3dMappings)
            end

            for j = 1 , #actionNames do
                local actionName = actionNames[j]
                actionName = "SOUND_ACTION_" .. string.upper(actionName)
                local action = Cylindered [actionName]
                if action ~ = nil then
                    for l = 1 , #nodes do
                        local node = nodes[l]
                        if node ~ = nil then
                            if spec.nodesToSamples[node] = = nil then
                                spec.nodesToSamples[node] = { }
                            end

                            if spec.nodesToSamples[node][action] = = nil then
                                spec.nodesToSamples[node][action] = { }
                            end

                            local part = self:getMovingPartByNode(node) or self:getTranslatingPartByNode(node) or self:getMovingToolByNode(node)
                            if part ~ = nil then
                                part.samplesByAction = spec.nodesToSamples[node]
                            else
                                    Logging.xmlWarning(xmlFile, "Unable to find movingPart or translatingPart for node '%s' in %s" , getName(node), baseKey)
                                    end

                                    table.insert(spec.nodesToSamples[node][action], sample)
                                end
                            end
                        else
                                Logging.xmlWarning(xmlFile, "Unable to find sound action '%s' for sound '%s'" , actionName, baseKey)
                                end
                            end

                            sample.dropOffFactor = xmlFile:getValue(baseKey .. ".pitch#dropOffFactor" , 1 )
                            sample.dropOffTime = xmlFile:getValue(baseKey .. ".pitch#dropOffTime" , 0 ) * 1000

                            sample.actionNames = actionNames
                            sample.nodes = nodes

                            table.insert(spec.actionSamples, sample)
                        end

                        i = i + 1
                    end
                end

```

### loadCopyLocalDirectionParts

**Description**

> Load copy local direction parts from xml

**Definition**

> loadCopyLocalDirectionParts(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadCopyLocalDirectionParts(xmlFile, baseName, entry)
    entry.copyLocalDirectionParts = { }

    for _, copyLocalDirectionPartKey in xmlFile:iterator(baseName .. ".copyLocalDirectionPart" ) do

        XMLUtil.checkDeprecatedXMLElements(xmlFile, copyLocalDirectionPartKey .. "#index" , copyLocalDirectionPartKey .. "#node" ) --FS15 to FS17

        local node = xmlFile:getValue(copyLocalDirectionPartKey .. "#node" , nil , self.components, self.i3dMappings)
        if node ~ = nil then
            local copyLocalDirectionPart = { }
            copyLocalDirectionPart.node = node
            copyLocalDirectionPart.dirScale = xmlFile:getValue(copyLocalDirectionPartKey .. "#dirScale" , nil , true )
            copyLocalDirectionPart.upScale = xmlFile:getValue(copyLocalDirectionPartKey .. "#upScale" , nil , true )

            if copyLocalDirectionPart.dirScale = = nil then
                Logging.xmlWarning(xmlFile, "Missing values for '%s'" , copyLocalDirectionPartKey .. "#dirScale" )
                    continue
                end
                if copyLocalDirectionPart.upScale = = nil then
                    Logging.xmlWarning(xmlFile, "Missing values for '%s'" , copyLocalDirectionPartKey .. "#upScale" )
                        continue
                    end

                    self:loadDependentComponentJoints(xmlFile, copyLocalDirectionPartKey, copyLocalDirectionPart)

                    table.insert(entry.copyLocalDirectionParts, copyLocalDirectionPart)
                end
            end
        end

```

### loadDependentAnimations

**Description**

**Definition**

> loadDependentAnimations()

**Arguments**

| any | xmlFile  |
|-----|----------|
| any | baseName |
| any | entry    |

**Code**

```lua
function Cylindered:loadDependentAnimations(xmlFile, baseName, entry)
    entry.dependentAnimations = { }

    local i = 0
    while true do
        local baseKey = string.format( "%s.dependentAnimation(%d)" , baseName, i)
        if not xmlFile:hasProperty(baseKey) then
            break
        end

        local animationName = xmlFile:getValue(baseKey .. "#name" )
        if animationName ~ = nil then
            local dependentAnimation = { }
            dependentAnimation.name = animationName
            dependentAnimation.lastPos = 0

            dependentAnimation.translationAxis = xmlFile:getValue(baseKey .. "#translationAxis" )
            dependentAnimation.rotationAxis = xmlFile:getValue(baseKey .. "#rotationAxis" )

            dependentAnimation.node = entry.node
            local useTranslatingPartIndex = xmlFile:getValue(baseKey .. "#useTranslatingPartIndex" )
            if useTranslatingPartIndex ~ = nil then
                if entry.translatingParts[useTranslatingPartIndex] ~ = nil then
                    dependentAnimation.node = entry.translatingParts[useTranslatingPartIndex].node
                end
            end

            dependentAnimation.minValue = xmlFile:getValue(baseKey .. "#minValue" )
            dependentAnimation.maxValue = xmlFile:getValue(baseKey .. "#maxValue" )
            if dependentAnimation.rotationAxis ~ = nil then
                dependentAnimation.minValue = MathUtil.degToRad(dependentAnimation.minValue)
                dependentAnimation.maxValue = MathUtil.degToRad(dependentAnimation.maxValue)
            end

            dependentAnimation.invert = xmlFile:getValue(baseKey .. "#invert" , false )

            table.insert(entry.dependentAnimations, dependentAnimation)
        end

        i = i + 1
    end
end

```

### loadDependentAttacherJoints

**Description**

> Load attacher joints from xml

**Definition**

> loadDependentAttacherJoints(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadDependentAttacherJoints(xmlFile, baseName, entry)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#jointIndices" , baseName .. ".attacherJoint#jointIndices" ) --FS15 to FS17

    local indices = xmlFile:getValue(baseName .. ".attacherJoint#jointIndices" , nil , true )
    if indices ~ = nil then
        local ignoreWarning = xmlFile:getValue(baseName .. ".attacherJoint#ignoreWarning" , false )

        entry.attacherJoints = { }

        local availableAttacherJoints
        if self.getAttacherJoints ~ = nil then
            availableAttacherJoints = self:getAttacherJoints()
        end
        if availableAttacherJoints ~ = nil then
            for i = 1 , #indices do
                if availableAttacherJoints[indices[i]] ~ = nil then
                    table.insert(entry.attacherJoints, availableAttacherJoints[indices[i]])
                elseif not ignoreWarning then
                        Logging.xmlWarning(xmlFile, "Invalid attacher joint index '%s' for '%s'!" , indices[i], baseName)
                        end
                    end
                end
            end

            XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#inputAttacherJoint" , baseName .. ".inputAttacherJoint#value" ) --FS15 to FS17

            entry.inputAttacherJoint = xmlFile:getValue(baseName .. ".inputAttacherJoint#value" , false )
        end

```

### loadDependentComponentJoints

**Description**

> Load component joints from xml

**Definition**

> loadDependentComponentJoints(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadDependentComponentJoints(xmlFile, baseName, entry)
    if not self.isServer then
        return
    end

    entry.componentJoints = { }

    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#componentJointIndex" , baseName .. ".componentJoint#index" ) --FS15 to FS17
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#anchorActor" , baseName .. ".componentJoint#anchorActor" ) --FS15 to FS17

    local i = 0
    while true do
        local key = baseName .. string.format( ".componentJoint(%d)" , i)
        if not xmlFile:hasProperty(key) then
            break
        end
        local index = xmlFile:getValue(key .. "#index" )
        if index ~ = nil and self.componentJoints[index] ~ = nil then
            local anchorActor = xmlFile:getValue(key .. "#anchorActor" , 0 )

            local componentJoint = self.componentJoints[index]

            local jointEntry = { }
            jointEntry.componentJoint = componentJoint
            jointEntry.anchorActor = anchorActor
            jointEntry.index = index

            local jointNode = componentJoint.jointNode
            if jointEntry.anchorActor = = 1 then
                jointNode = componentJoint.jointNodeActor1
            end

            local node = self.components[componentJoint.componentIndices[ 2 ]].node
            jointEntry.x, jointEntry.y, jointEntry.z = localToLocal(node, jointNode, 0 , 0 , 0 )
            jointEntry.upX, jointEntry.upY, jointEntry.upZ = localDirectionToLocal(node, jointNode, 0 , 1 , 0 )
            jointEntry.dirX, jointEntry.dirY, jointEntry.dirZ = localDirectionToLocal(node, jointNode, 0 , 0 , 1 )

            table.insert(entry.componentJoints, jointEntry)
        elseif not xmlFile:getValue(key .. "#ignoreWarning" ) then
                Logging.xmlWarning(xmlFile, "Invalid index for '%s'" , key)
                end

                i = i + 1
            end
        end

```

### loadDependentMovingTools

**Description**

> Load dependent moving tools from xml

**Definition**

> loadDependentMovingTools(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadDependentMovingTools(xmlFile, baseName, entry)
    entry.dependentMovingTools = { }

    local j = 0
    while true do
        local refBaseName = baseName .. string.format( ".dependentMovingTool(%d)" , j)
        if not xmlFile:hasProperty(refBaseName) then
            break
        end

        XMLUtil.checkDeprecatedXMLElements(xmlFile, refBaseName .. "#index" , refBaseName .. "#index" ) --FS17 to FS19

        local node = xmlFile:getValue(refBaseName .. "#node" , nil , self.components, self.i3dMappings)
        local speedScale = xmlFile:getValue(refBaseName .. "#speedScale" )
        local requiresMovement = xmlFile:getValue(refBaseName .. "#requiresMovement" , false )
        local axis = xmlFile:getValue(refBaseName .. "#axis" , 1 )

        local rotationBasedLimits = AnimCurve.new( Cylindered.limitInterpolator)
        local found = false
        local i = 0
        while true do
            local key = string.format( "%s.limit(%d)" , refBaseName .. ".rotationBasedLimits" , i)
            if not xmlFile:hasProperty(key) then
                break
            end

            local keyFrame = self:loadRotationBasedLimits(xmlFile, key, entry)
            if keyFrame ~ = nil then
                rotationBasedLimits:addKeyframe(keyFrame)
                found = true
            end
            i = i + 1
        end
        if not found then
            rotationBasedLimits = nil
        end

        local minTransLimits = xmlFile:getValue(refBaseName .. "#minTransLimits" , nil , true )
        local maxTransLimits = xmlFile:getValue(refBaseName .. "#maxTransLimits" , nil , true )
        local minRotLimits = xmlFile:getValue(refBaseName .. "#minRotLimits" , nil , true )
        local maxRotLimits = xmlFile:getValue(refBaseName .. "#maxRotLimits" , nil , true )
        if node ~ = nil and(rotationBasedLimits ~ = nil or speedScale ~ = nil or minTransLimits ~ = nil or maxTransLimits ~ = nil or minRotLimits ~ = nil or maxRotLimits ~ = nil ) then
            local dependentTool = { }
            dependentTool.node = node
            dependentTool.axis = axis
            dependentTool.rotation = { 0 , 0 , 0 }
            dependentTool.rotationBasedLimits = rotationBasedLimits
            dependentTool.speedScale = speedScale
            dependentTool.requiresMovement = requiresMovement
            dependentTool.minTransLimits = minTransLimits
            dependentTool.maxTransLimits = maxTransLimits
            dependentTool.minRotLimits = minRotLimits
            dependentTool.maxRotLimits = maxRotLimits
            table.insert(entry.dependentMovingTools, dependentTool)
        end

        j = j + 1
    end
end

```

### loadDependentParts

**Description**

> Load dependent parts from xml

**Definition**

> loadDependentParts(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadDependentParts(xmlFile, baseName, entry)
    entry.dependentPartData = { }

    xmlFile:iterate(baseName .. ".dependentPart" , function (_, key)
        XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

        local dependentPart = { }
        dependentPart.node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if dependentPart.node ~ = nil then
            dependentPart.maxUpdateDistance = xmlFile:getValue(key .. "#maxUpdateDistance" , "-" )
            if dependentPart.maxUpdateDistance = = "-" then
                dependentPart.maxUpdateDistance = math.huge
            else
                    dependentPart.maxUpdateDistance = tonumber(dependentPart.maxUpdateDistance)
                end

                dependentPart.part = nil

                table.insert(entry.dependentPartData, dependentPart)
            end
        end )
    end

```

### loadDependentTranslatingParts

**Description**

> Load translating parts

**Definition**

> loadDependentTranslatingParts(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadDependentTranslatingParts(xmlFile, baseName, entry)
    entry.translatingParts = { }
    if entry.hasReferencePoints then
        entry.divideTranslatingDistance = xmlFile:getValue(baseName .. "#divideTranslatingDistance" , true )
        entry.translatingPartsDivider = 0

        local j = 0
        while true do
            local refBaseName = baseName .. string.format( ".translatingPart(%d)" , j)
            if not xmlFile:hasProperty(refBaseName) then
                break
            end

            XMLUtil.checkDeprecatedXMLElements(xmlFile, refBaseName .. "#index" , refBaseName .. "#node" ) --FS15 to FS17

            local node = xmlFile:getValue(refBaseName .. "#node" , nil , self.components, self.i3dMappings)
            if node ~ = nil then
                local transEntry = { }
                transEntry.node = node
                local x, y, z = getTranslation(node)
                transEntry.startPos = { x, y, z }
                transEntry.lastZ = z

                local _, refZ
                if entry.referencePoint ~ = nil then
                    _, _, refZ = worldToLocal(node, getWorldTranslation(entry.referencePoint))
                else
                        refZ = 0
                        for i, referencePoint in ipairs(entry.referencePoints) do
                            _, _, z = worldToLocal(node, getWorldTranslation(referencePoint))
                            refZ = refZ + z
                        end

                        refZ = refZ / entry.numReferencePoints
                    end

                    transEntry.referenceDistance = xmlFile:getValue(refBaseName .. "#referenceDistance" , refZ)

                    transEntry.minZTrans = xmlFile:getValue(refBaseName .. "#minZTrans" )
                    transEntry.maxZTrans = xmlFile:getValue(refBaseName .. "#maxZTrans" )

                    transEntry.divideTranslatingDistance = xmlFile:getValue(refBaseName .. "#divideTranslatingDistance" , entry.divideTranslatingDistance)
                    if transEntry.divideTranslatingDistance then
                        entry.translatingPartsDivider = entry.translatingPartsDivider + 1
                    end

                    table.insert(entry.translatingParts, transEntry)
                end

                j = j + 1
            end

            entry.translatingPartsDivider = math.max(entry.translatingPartsDivider, 1 )
            entry.numTranslatingParts = #entry.translatingParts
        end
    end

```

### loadDependentWheels

**Description**

> Load wheels from xml

**Definition**

> loadDependentWheels(XMLFile xmlFile, string baseName, table entry)

**Arguments**

| XMLFile | xmlFile  | XMLFile instance |
|---------|----------|------------------|
| string  | baseName | base name        |
| table   | entry    | entry to add     |

**Code**

```lua
function Cylindered:loadDependentWheels(xmlFile, baseName, entry)
    if SpecializationUtil.hasSpecialization( Wheels , self.specializations) then
        local indices = xmlFile:getValue(baseName .. "#wheelIndices" , nil , true )
        if indices ~ = nil then
            entry.wheels = { }
            for _,wheelIndex in pairs(indices) do
                local wheel = self:getWheelFromWheelIndex(wheelIndex)
                if wheel ~ = nil then
                    table.insert(entry.wheels, wheel)
                else
                        Logging.xmlWarning(xmlFile, "Invalid wheelIndex '%s' for '%s'!" , wheelIndex, baseName)
                        end
                    end
                end

                local wheelNodesStr = xmlFile:getValue(baseName .. "#wheelNodes" )
                if wheelNodesStr ~ = nil and wheelNodesStr ~ = "" then
                    entry.wheels = entry.wheels or { }
                    local wheelNodes = string.split(wheelNodesStr, " " )
                    for i = 1 , #wheelNodes do
                        local wheel = self:getWheelByWheelNode(wheelNodes[i])
                        if wheel ~ = nil then
                            table.insert(entry.wheels, wheel)
                        else
                                Logging.xmlWarning(xmlFile, "Invalid wheelNode '%s' for '%s'!" , wheelNodes[i], baseName)
                                end
                            end
                        end
                    end
                end

```

### loadDischargeNode

**Description**

**Definition**

> loadDischargeNode()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function Cylindered:loadDischargeNode(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    local baseKey = key .. ".movingToolActivation"

    if xmlFile:hasProperty(baseKey) then
        entry.movingToolActivation = { }
        entry.movingToolActivation.node = xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
        entry.movingToolActivation.isInverted = xmlFile:getValue(baseKey .. "#isInverted" , false )
        entry.movingToolActivation.openFactor = xmlFile:getValue(baseKey .. "#openFactor" , 1 )
        entry.movingToolActivation.openOffset = xmlFile:getValue(baseKey .. "#openOffset" , 0 )
        entry.movingToolActivation.openOffsetInv = 1 - entry.movingToolActivation.openOffset
    end

    return true
end

```

### loadDynamicMountGrabFromXML

**Description**

**Definition**

> loadDynamicMountGrabFromXML()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function Cylindered:loadDynamicMountGrabFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    local baseKey = key .. ".movingToolActivation"
    if not xmlFile:hasProperty(baseKey) then
        return true
    end

    entry.movingToolActivation = { }
    entry.movingToolActivation.node = xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
    entry.movingToolActivation.isInverted = xmlFile:getValue(baseKey .. "#isInverted" , false )
    entry.movingToolActivation.openFactor = xmlFile:getValue(baseKey .. "#openFactor" , 1 )

    return true
end

```

### loadEasyArmControlFromXML

**Description**

**Definition**

> loadEasyArmControlFromXML()

**Arguments**

| any | xmlFile        |
|-----|----------------|
| any | key            |
| any | easyArmControl |

**Code**

```lua
function Cylindered:loadEasyArmControlFromXML(xmlFile, key, easyArmControl)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".xRotationNodes#maxDistance" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".xRotationNodes#transRotRatio" ) --FS19 to FS22

    easyArmControl.rootNode = xmlFile:getValue(key .. "#rootNode" , nil , self.components, self.i3dMappings)
    easyArmControl.targetNodeY = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    easyArmControl.targetNodeZ = xmlFile:getValue(key .. "#targetNodeZ" , easyArmControl.targetNodeY, self.components, self.i3dMappings)
    easyArmControl.state = false

    if easyArmControl.targetNodeZ ~ = nil and easyArmControl.targetNodeY ~ = nil then
        local targetYTool = self:getMovingToolByNode(easyArmControl.targetNodeY)
        local targetZTool = self:getMovingToolByNode(easyArmControl.targetNodeZ)
        if targetYTool ~ = nil and targetZTool ~ = nil then
            easyArmControl.targetNode = easyArmControl.targetNodeZ
            if getParent(easyArmControl.targetNodeY) = = easyArmControl.targetNodeZ then
                easyArmControl.targetNode = easyArmControl.targetNodeY
            end
            easyArmControl.targetRefNode = xmlFile:getValue(key .. "#refNode" , nil , self.components, self.i3dMappings)
            easyArmControl.lastValidPositionY = { getTranslation(easyArmControl.targetNodeY) }
            easyArmControl.lastValidPositionZ = { getTranslation(easyArmControl.targetNodeZ) }

            easyArmControl.moveSpeed = xmlFile:getValue(key .. ".targetMovement#speed" , 1 ) / 1000
            easyArmControl.moveAcceleration = xmlFile:getValue(key .. ".targetMovement#acceleration" , 50 ) / ( 1000 * 1000 )
            easyArmControl.lastSpeedY = 0
            easyArmControl.lastSpeedZ = 0

            easyArmControl.minTransMoveRatio = xmlFile:getValue(key .. ".zTranslationNodes#minMoveRatio" , 0.2 )
            easyArmControl.maxTransMoveRatio = xmlFile:getValue(key .. ".zTranslationNodes#maxMoveRatio" , 0.8 )
            easyArmControl.transMoveRatioMinDir = xmlFile:getValue(key .. ".zTranslationNodes#moveRatioMinDir" , 0 )
            easyArmControl.transMoveRatioMaxDir = xmlFile:getValue(key .. ".zTranslationNodes#moveRatioMaxDir" , 1 )
            easyArmControl.allowNegativeTrans = xmlFile:getValue(key .. ".zTranslationNodes#allowNegativeTrans" , false )
            easyArmControl.minNegativeTrans = xmlFile:getValue(key .. ".zTranslationNodes#minNegativeTrans" , 0 )

            easyArmControl.forcedTransMove = nil

            easyArmControl.zTranslationNodes = { }
            local maxTrans = 0
            xmlFile:iterate(key .. ".zTranslationNodes.zTranslationNode" , function (_, transKey)
                local node = xmlFile:getValue(transKey .. "#node" , nil , self.components, self.i3dMappings)
                if node ~ = nil then
                    local movingTool = self:getMovingToolByNode(node)
                    if movingTool ~ = nil then
                        local maxDistance = math.abs(movingTool.transMin - movingTool.transMax)
                        maxTrans = maxTrans + maxDistance
                        movingTool.easyArmControlActive = false
                        table.insert(easyArmControl.zTranslationNodes, { node = node, movingTool = movingTool, maxDistance = maxDistance, transFactor = 0 , startTranslation = { getTranslation(node) } } )
                    end
                end
            end )

            for _, translationNode in ipairs(easyArmControl.zTranslationNodes) do
                translationNode.transFactor = translationNode.maxDistance / maxTrans
            end

            easyArmControl.xRotationNodes = { }
            for i = 1 , 2 do
                local xRotKey = string.format( "%s.xRotationNodes.xRotationNode%d" , key, i)
                if not xmlFile:hasProperty(xRotKey) then
                    Logging.xmlWarning(xmlFile, "Missing second xRotation node for easy control!" )
                        return false
                    end

                    XMLUtil.checkDeprecatedXMLElements(xmlFile, xRotKey .. "#refNode" ) --FS19 to FS22

                    local node = xmlFile:getValue(xRotKey .. "#node" , nil , self.components, self.i3dMappings)
                    if node ~ = nil then
                        local movingTool = self:getMovingToolByNode(node)
                        if movingTool ~ = nil then
                            movingTool.easyArmControlActive = false
                            table.insert(easyArmControl.xRotationNodes, { node = node, movingTool = movingTool, startRotation = { getRotation(node) } } )
                        end
                    end
                end

                if #easyArmControl.xRotationNodes ~ = 2 then
                    Logging.xmlWarning(xmlFile, "Easy arm control requires two x rotation nodes! Only %d given. (%s)" , #easyArmControl.xRotationNodes, key)
                    return false
                end

                if easyArmControl.targetRefNode ~ = nil then
                    local xOffset, yOffset, _ = localToLocal(easyArmControl.targetRefNode, easyArmControl.xRotationNodes[ 2 ].node, 0 , 0 , 0 )
                    if math.abs(xOffset) > 0.0001 or math.abs(yOffset) > 0.0001 then
                        Logging.xmlWarning(xmlFile, "Invalid position of '%s'.Offset to second xRotation node is not 0 on X or Y axis(x: %f y: %f)" , key .. "#refNode" , xOffset, yOffset)
                        return false
                    end
                end

                local xOffset, yOffset, _ = localToLocal(easyArmControl.xRotationNodes[ 2 ].node, easyArmControl.xRotationNodes[ 1 ].node, 0 , 0 , 0 )
                if math.abs(xOffset) > 0.0001 or math.abs(yOffset) > 0.0001 then
                    Logging.xmlWarning(xmlFile, "Invalid position of xRotationNode2.Offset to second xRotationNode1 is not 0 on X or Y axis(x: %f y: %f)" , xOffset, yOffset)
                    return false
                end

                local rootOffset = calcDistanceFrom(easyArmControl.rootNode, easyArmControl.xRotationNodes[ 1 ].node)
                if rootOffset > 0.05 then
                    Logging.xmlWarning(xmlFile, "Distance between easyArmControl rootNode and xRotationNode1 is to big(%.2f).They should be at the same position." , rootOffset)
                    return false
                end

                easyArmControl.maxTotalDistance = xmlFile:getValue(key .. "#maxTotalDistance" )
                if easyArmControl.maxTotalDistance = = nil then
                    -- move nodes to the max length state
                    for i = 1 , #easyArmControl.xRotationNodes do
                        local xRotationNode = easyArmControl.xRotationNodes[i]
                        local curRot = { getRotation(xRotationNode.node) }
                        curRot[xRotationNode.movingTool.rotationAxis] = xRotationNode.movingTool.rotMin
                        setRotation(xRotationNode.node, curRot[ 1 ], curRot[ 2 ], curRot[ 3 ])
                    end

                    for i = 1 , #easyArmControl.zTranslationNodes do
                        local zTranslationNode = easyArmControl.zTranslationNodes[i]
                        local curTrans = { getTranslation(zTranslationNode.node) }
                        curTrans[zTranslationNode.movingTool.translationAxis] = zTranslationNode.movingTool.transMax
                        setTranslation(zTranslationNode.node, curTrans[ 1 ], curTrans[ 2 ], curTrans[ 3 ])
                    end

                    -- calculate max distances
                    easyArmControl.maxTotalDistance = calcDistanceFrom(easyArmControl.rootNode, easyArmControl.targetRefNode)
                    easyArmControl.maxTransDistance = calcDistanceFrom(easyArmControl.xRotationNodes[#easyArmControl.xRotationNodes].node, easyArmControl.targetRefNode)

                    -- reset nodes again to previous states
                    for i = 1 , #easyArmControl.xRotationNodes do
                        local xRotationNode = easyArmControl.xRotationNodes[i]
                        setRotation(xRotationNode.node, xRotationNode.startRotation[ 1 ], xRotationNode.startRotation[ 2 ], xRotationNode.startRotation[ 3 ])
                    end

                    for i = 1 , #easyArmControl.zTranslationNodes do
                        local zTranslationNode = easyArmControl.zTranslationNodes[i]
                        setTranslation(zTranslationNode.node, zTranslationNode.startTranslation[ 1 ], zTranslationNode.startTranslation[ 2 ], zTranslationNode.startTranslation[ 3 ])
                    end
                end
            else
                    Logging.xmlError(xmlFile, "Missing moving tools for easy control targets!" )
                        return false
                    end
                else
                        Logging.xmlError(xmlFile, "Missing easy control targets!" )
                        return false
                    end

                    return true
                end

```

### loadExtraDependentParts

**Description**

**Definition**

> loadExtraDependentParts()

**Arguments**

| any | xmlFile  |
|-----|----------|
| any | baseName |
| any | entry    |

**Code**

```lua
function Cylindered:loadExtraDependentParts(xmlFile, baseName, entry)
    return true
end

```

### loadMovingPartFromXML

**Description**

**Definition**

> loadMovingPartFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function Cylindered:loadMovingPartFromXML(xmlFile, key, entry)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    local referenceFrame = xmlFile:getValue(key .. "#referenceFrame" , nil , self.components, self.i3dMappings)
    if node ~ = nil and referenceFrame ~ = nil then
        entry.referencePoint = xmlFile:getValue(key .. "#referencePoint" , nil , self.components, self.i3dMappings)
        entry.referencePoints = xmlFile:getValue(key .. "#referencePoints" , nil , self.components, self.i3dMappings, true )
        entry.numReferencePoints = #entry.referencePoints
        entry.hasReferencePoints = entry.numReferencePoints > 0 or entry.referencePoint ~ = nil

        entry.node = node
        entry.parent = getParent(node)
        entry.referenceFrame = referenceFrame
        entry.invertZ = xmlFile:getValue(key .. "#invertZ" , false )
        entry.scaleZ = xmlFile:getValue(key .. "#scaleZ" , false )
        entry.limitedAxis = xmlFile:getValue(key .. "#limitedAxis" )
        entry.isActiveDirty = xmlFile:getValue(key .. "#isActiveDirty" , false )
        entry.playSound = xmlFile:getValue(key .. "#playSound" , false )

        entry.moveToReferenceFrame = xmlFile:getValue(key .. "#moveToReferenceFrame" , false )
        if entry.moveToReferenceFrame then
            local x,y,z = worldToLocal(referenceFrame, getWorldTranslation(node))
            entry.referenceFrameOffset = { x,y,z }
        end

        if entry.referenceFrame = = entry.node then
            Logging.xmlWarning(xmlFile, "Reference frame equals moving part node.This can lead to bad behaviours! Node '%s' in '%s'." , getName(entry.node), key)
        end

        entry.doLineAlignment = xmlFile:getValue(key .. "#doLineAlignment" , false )
        entry.doInversedLineAlignment = xmlFile:getValue(key .. "#doInversedLineAlignment" , false )
        entry.do3DLineAlignment = xmlFile:getValue(key .. "#do3DLineAlignment" , false )
        entry.partLength = xmlFile:getValue(key .. ".orientationLine#partLength" , 0.5 )
        entry.partLengthNode = xmlFile:getValue(key .. ".orientationLine#partLengthNode" , nil , self.components, self.i3dMappings)

        entry.orientationLineNodes = { }
        for _, pointKey in self.xmlFile:iterator(key .. ".orientationLine.lineNode" ) do
            local lineNode = xmlFile:getValue(pointKey .. "#node" , nil , self.components, self.i3dMappings)
            if lineNode ~ = nil then
                if entry.doInversedLineAlignment then
                    local _, _, zOffset = localToLocal(lineNode, entry.node, 0 , 0 , 0 )
                    if zOffset < 0 then
                        Logging.xmlWarning(xmlFile, "Local orientation line node '%s' is in negative Z direction to the movingPart node.This is not allowed! (%s)" , getName(lineNode), pointKey)
                        continue
                    end
                end

                table.insert(entry.orientationLineNodes, lineNode)
            end
        end

        if entry.do3DLineAlignment then
            if #entry.orientationLineNodes = = 2 then
                entry.orientationLineTransNode = xmlFile:getValue(key .. ".orientationLine#referenceTransNode" , nil , self.components, self.i3dMappings)
                if entry.orientationLineTransNode = = nil then
                    Logging.xmlWarning(xmlFile, "Failed to load 3D line alignment from xml.Missing referenceTransNode! (movingPart '%s')" , getName(node))
                    entry.do3DLineAlignment = false
                end
            else
                    Logging.xmlWarning(xmlFile, "Failed to load 3D line alignment from xml.Requires exactly two line nodes! (movingPart '%s')" , getName(node))
                    entry.do3DLineAlignment = false
                end
            end

            entry.doDirectionAlignment = xmlFile:getValue(key .. "#doDirectionAlignment" , true )
            entry.doRotationAlignment = xmlFile:getValue(key .. "#doRotationAlignment" , false )
            entry.rotMultiplier = xmlFile:getValue(key .. "#rotMultiplier" , 0 )

            if entry.doDirectionAlignment and entry.doRotationAlignment then
                Logging.xmlWarning(xmlFile, "Direction alignment and rotation alignment used at the same time for movingPart '%s' in '%s'" , getName(node), key)
                    return false
                end

                if entry.doDirectionAlignment and(entry.doLineAlignment or entry.doInversedLineAlignment or entry.do3DLineAlignment) then
                    Logging.xmlWarning(xmlFile, "Direction alignment and line alignment used at the same time for movingPart '%s' in '%s'" , getName(node), key)
                        return false
                    end

                    local minRot = xmlFile:getValue(key .. "#minRot" )
                    local maxRot = xmlFile:getValue(key .. "#maxRot" )
                    if minRot ~ = nil and maxRot ~ = nil then
                        if entry.limitedAxis ~ = nil then
                            entry.minRot = MathUtil.getValidLimit(minRot)
                            entry.maxRot = MathUtil.getValidLimit(maxRot)
                        else
                                Logging.xmlWarning(xmlFile, "minRot/maxRot requires the use of limitedAxis in for movingPart '%s' in '%s'" , getName(node), key)
                                end
                            end
                            entry.alignToWorldY = xmlFile:getValue(key .. "#alignToWorldY" , false )

                            if entry.hasReferencePoints then
                                local localReferencePoint = xmlFile:getValue(key .. "#localReferencePoint" , nil , self.components, self.i3dMappings)

                                local refX, refY, refZ
                                if entry.referencePoint ~ = nil then
                                    refX, refY, refZ = worldToLocal(node, getWorldTranslation(entry.referencePoint))
                                else
                                        refX, refY, refZ = 0 , 0 , 0
                                        for i, referencePoint in ipairs(entry.referencePoints) do
                                            local x, y, z = worldToLocal(node, getWorldTranslation(referencePoint))
                                            refX, refY, refZ = refX + x, refY + y, refZ + z
                                        end

                                        refX, refY, refZ = refX / entry.numReferencePoints, refY / entry.numReferencePoints, refZ / entry.numReferencePoints
                                    end

                                    local _
                                    _, _, entry.smoothedDirectionScaleZOffset = worldToLocal(entry.node, refX, refY, refZ)

                                    if localReferencePoint ~ = nil then
                                        local x,y,z = worldToLocal(node, getWorldTranslation(localReferencePoint))

                                        entry.referenceDistance = MathUtil.vector3Length(refX - x, refY - y, refZ - z)
                                        entry.lastReferenceDistance = entry.referenceDistance
                                        entry.localReferencePoint = { x, y, z }

                                        local side = y * (refZ - z) - z * (refY - y)
                                        entry.localReferenceAngleSide = side
                                        entry.localReferencePointNode = localReferencePoint
                                        entry.updateLocalReferenceDistance = xmlFile:getValue(key .. "#updateLocalReferenceDistance" , false )
                                        entry.localReferenceTranslate = xmlFile:getValue(key .. "#localReferenceTranslate" , false )
                                        if entry.localReferenceTranslate then
                                            entry.localReferenceTranslation = { getTranslation(entry.node) }
                                        end

                                        entry.dynamicLocalReferenceDistance = xmlFile:getValue(key .. "#dynamicLocalReferenceDistance" , false )
                                    else
                                            entry.referenceDistance = 0
                                            entry.localReferencePoint = { refX, refY, refZ }
                                        end
                                        entry.referenceDistanceThreshold = xmlFile:getValue(key .. "#referenceDistanceThreshold" , 0.0001 )

                                        entry.useLocalOffset = xmlFile:getValue(key .. "#useLocalOffset" , false )
                                        entry.referencePointOffset = xmlFile:getValue(key .. "#referencePointOffset" )

                                        entry.referenceDistance = xmlFile:getValue(key .. "#referenceDistance" , entry.referenceDistance)

                                        entry.referenceDistancePoint = xmlFile:getValue(key .. "#referenceDistancePoint" , nil , self.components, self.i3dMappings)

                                        entry.localReferenceDistance = xmlFile:getValue(key .. "#localReferenceDistance" , MathUtil.vector2Length(entry.localReferencePoint[ 2 ], entry.localReferencePoint[ 3 ]))

                                        self:loadDependentTranslatingParts(xmlFile, key, entry)
                                    end

                                    self:loadDependentMovingTools(xmlFile, key, entry)

                                    -- direction threshold for updateing the moving tools of the vehicle is entered/active
                                        entry.directionThreshold = xmlFile:getValue(key .. "#directionThreshold" , 0.0001 )
                                        entry.directionThresholdActive = xmlFile:getValue(key .. "#directionThresholdActive" , 0.00001 )

                                        if entry.doDirectionAlignment and not entry.hasReferencePoints then
                                            entry.directionThreshold = 0
                                            entry.directionThresholdActive = 0
                                        end

                                        entry.maxUpdateDistance = xmlFile:getValue(key .. "#maxUpdateDistance" , "-" )
                                        if entry.maxUpdateDistance = = "-" then
                                            entry.maxUpdateDistance = math.huge
                                        else
                                                entry.maxUpdateDistance = tonumber(entry.maxUpdateDistance)
                                            end

                                            if entry.isActiveDirty and(xmlFile:getString(key .. "#maxUpdateDistance" ) = = nil or entry.maxUpdateDistance = = nil ) then
                                                Logging.xmlWarning(xmlFile, "No max.update distance set for isActiveDirty moving part '%s'! Use #maxUpdateDistance attribute." , getName(node))
                                                end

                                                entry.smoothedDirectionScale = xmlFile:getValue(key .. "#smoothedDirectionScale" , false )
                                                entry.smoothedDirectionTime = 1 / (xmlFile:getValue(key .. "#smoothedDirectionTime" , 2 ))
                                                entry.smoothedDirectionScaleAlpha = nil

                                                if entry.smoothedDirectionScale then
                                                    entry.initialDirection = { localDirectionToLocal(entry.node, getParent(entry.node), 0 , 0 , 1 ) }
                                                end

                                                entry.debug = xmlFile:getValue(key .. "#debug" , false )
                                                if entry.debug then
                                                    Logging.xmlWarning(xmlFile, "MovingPart debug enabled for moving part '%s'" , getName(node))
                                                    end

                                                    entry.lastDirection = { 0 , 0 , 0 }
                                                    entry.lastUpVector = { 0 , 0 , 0 }

                                                    entry.isDirty = false
                                                    entry.isPart = true
                                                    entry.isActive = true

                                                    return true
                                                end

                                                return false
                                            end

```

### loadMovingPartsFromXML

**Description**

**Definition**

> loadMovingPartsFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function Cylindered:loadMovingPartsFromXML(xmlFile, key)
    local spec = self.spec_cylindered

    for _, partKey in xmlFile:iterator(key) do
        local entry = { }
        if self:loadMovingPartFromXML(xmlFile, partKey, entry) then
            if spec.referenceNodes[entry.node] = = nil then
                spec.referenceNodes[entry.node] = { }
            end
            if spec.nodesToMovingParts[entry.node] = = nil then
                table.insert(spec.referenceNodes[entry.node], entry)

                self:loadDependentParts(xmlFile, partKey, entry)
                self:loadDependentComponentJoints(xmlFile, partKey, entry)
                self:loadCopyLocalDirectionParts(xmlFile, partKey, entry)
                self:loadExtraDependentParts(xmlFile, partKey, entry)
                self:loadDependentAnimations(xmlFile, partKey, entry)

                entry.key = partKey
                table.insert(spec.movingParts, entry)

                if entry.isActiveDirty then
                    table.insert(spec.activeDirtyMovingParts, entry)
                end

                spec.nodesToMovingParts[entry.node] = entry
            else
                    Logging.xmlWarning(xmlFile, "Moving part with node '%s' already exists!" , getName(entry.node))
                end
            end
        end
    end

```

### loadMovingToolFromXML

**Description**

**Definition**

> loadMovingToolFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function Cylindered:loadMovingToolFromXML(xmlFile, key, entry)
    local spec = self.spec_cylindered

    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#index" , key .. "#node" ) --FS17 to FS19

    local node = xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
    if node ~ = nil then
        entry.node = node

        entry.externalMove = 0
        entry.easyArmControlActive = true
        entry.isEasyControlTarget = xmlFile:getValue(key .. "#isEasyControlTarget" , false )

        entry.networkInterpolators = { }

        -- rotation
        XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#rotSpeed" , key .. ".rotation#rotSpeed" ) --FS15 to FS17

        local rotSpeed = xmlFile:getValue(key .. ".rotation#rotSpeed" )
        if rotSpeed ~ = nil then
            entry.rotSpeed = rotSpeed / 1000
        end
        local rotAcceleration = xmlFile:getValue(key .. ".rotation#rotAcceleration" )
        if rotAcceleration ~ = nil then
            entry.rotAcceleration = rotAcceleration / ( 1000 * 1000 )
        end
        entry.lastRotSpeed = 0
        entry.rotMax = xmlFile:getValue(key .. ".rotation#rotMax" )
        entry.rotMin = xmlFile:getValue(key .. ".rotation#rotMin" )
        entry.syncMaxRotLimits = xmlFile:getValue(key .. ".rotation#syncMaxRotLimits" , false )
        entry.syncMinRotLimits = xmlFile:getValue(key .. ".rotation#syncMinRotLimits" , false )
        entry.rotSendNumBits = xmlFile:getValue(key .. ".rotation#rotSendNumBits" )
        entry.attachRotMax = xmlFile:getValue(key .. ".rotation#attachRotMax" )
        entry.attachRotMin = xmlFile:getValue(key .. ".rotation#attachRotMin" )

        if entry.rotSendNumBits = = nil then
            if entry.rotMin ~ = nil and entry.rotMax ~ = nil then
                local range = entry.rotMax - entry.rotMin
                local requiredMinValues = math.ceil(range / Cylindered.MOVING_TOOL_SEND_MIN_RESOLUTION)

                local bitsToUse = 11
                for i = 11 , 1 , - 1 do
                    local availableValues = 2 ^ i - 1
                    if requiredMinValues < = availableValues then
                        bitsToUse = i
                    end
                end

                entry.rotSendNumBits = bitsToUse
            else
                    entry.rotSendNumBits = 11 -- 0.35deg precision for 360deg rotation
                    end
                end

                if entry.rotMin ~ = nil and entry.rotMax ~ = nil then
                    if entry.rotMin > = entry.rotMax then
                        Logging.xmlWarning(xmlFile, "Rotation min value is greater or equal to max value for movingTool '%s' in '%s'" , getName(node), key)
                            return false
                        end
                    end

                    -- translation
                    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#transSpeed" , key .. ".rotation#transSpeed" ) --FS15 to FS17

                    local transSpeed = xmlFile:getValue(key .. ".translation#transSpeed" )
                    if transSpeed ~ = nil then
                        entry.transSpeed = transSpeed / 1000
                    end
                    local transAcceleration = xmlFile:getValue(key .. ".translation#transAcceleration" )
                    if transAcceleration ~ = nil then
                        entry.transAcceleration = transAcceleration / ( 1000 * 1000 )
                    end
                    entry.lastTransSpeed = 0
                    entry.transMax = xmlFile:getValue(key .. ".translation#transMax" )
                    entry.transMin = xmlFile:getValue(key .. ".translation#transMin" )
                    entry.attachTransMax = xmlFile:getValue(key .. ".translation#attachTransMax" )
                    entry.attachTransMin = xmlFile:getValue(key .. ".translation#attachTransMin" )
                    entry.playSound = xmlFile:getValue(key .. "#playSound" , false )

                    if entry.transMin ~ = nil and entry.transMax ~ = nil then
                        if entry.transMin > = entry.transMax then
                            Logging.xmlWarning(xmlFile, "Translation min value is greater or equal to max value for movingTool '%s' in '%s'" , getName(node), key)
                                return false
                            end
                        end

                        entry.isConsumingPower = xmlFile:getValue(key .. "#isConsumingPower" , false )

                        -- animation
                        if SpecializationUtil.hasSpecialization( AnimatedVehicle , self.specializations) then
                            local animSpeed = xmlFile:getValue(key .. ".animation#animSpeed" )
                            if animSpeed ~ = nil then
                                entry.animSpeed = animSpeed / 1000
                            end
                            local animAcceleration = xmlFile:getValue(key .. ".animation#animAcceleration" )
                            if animAcceleration ~ = nil then
                                entry.animAcceleration = animAcceleration / ( 1000 * 1000 )
                            end
                            entry.curAnimTime = 0
                            entry.lastAnimSpeed = 0
                            entry.animName = xmlFile:getValue(key .. ".animation#animName" )
                            entry.animSendNumBits = xmlFile:getValue(key .. ".animation#animSendNumBits" , 8 )
                            entry.animMaxTime = math.min(xmlFile:getValue(key .. ".animation#animMaxTime" , 1.0 ), 1.0 )
                            entry.animMinTime = math.max(xmlFile:getValue(key .. ".animation#animMinTime" , 0.0 ), 0.0 )

                            if entry.animMinTime > = entry.animMaxTime then
                                Logging.xmlWarning(xmlFile, "Animation min value is greater or equal to max value for movingTool '%s' in '%s'" , getName(node), key)
                                    return false
                                end

                                entry.animStartTime = xmlFile:getValue(key .. ".animation#animStartTime" )
                                if entry.animStartTime ~ = nil then
                                    entry.curAnimTime = entry.animStartTime
                                end

                                entry.networkInterpolators.animation = InterpolatorValue.new(entry.curAnimTime)
                                entry.networkInterpolators.animation:setMinMax( 0 , 1 )

                                entry.networkInterpolators.resetAnimInterpolation = false
                            end

                            XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. ".controls#iconFilename" , key .. ".controls#iconName" ) --FS17 to FS19

                            local iconName = xmlFile:getValue(key .. ".controls#iconName" )
                            if iconName ~ = nil then
                                if InputHelpElement.AXIS_ICON[iconName] = = nil then
                                    -- add the mod name as a prefix to match axis icon loading name collision avoidance
                                    iconName = ( self.customEnvironment or "" ) .. iconName
                                end

                                entry.axisActionIcon = iconName
                            end

                            entry.controlGroupIndex = xmlFile:getValue(key .. ".controls#groupIndex" , 0 )
                            if entry.controlGroupIndex ~ = 0 then
                                if spec.controlGroupNames[entry.controlGroupIndex] ~ = nil then
                                    table.addElement(spec.controlGroups, entry.controlGroupIndex)
                                else
                                        Logging.xmlWarning(xmlFile, "ControlGroup '%d' not defined for '%s'!" , entry.controlGroupIndex, key)
                                        end
                                    end

                                    entry.axis = xmlFile:getValue(key .. ".controls#axis" )
                                    if entry.axis ~ = nil then
                                        entry.axisActionIndex = InputAction[entry.axis]
                                    end
                                    entry.invertAxis = xmlFile:getValue(key .. ".controls#invertAxis" , false )
                                    entry.mouseSpeedFactor = xmlFile:getValue(key .. ".controls#mouseSpeedFactor" , 1.0 )

                                    if (entry.rotSpeed ~ = nil or entry.transSpeed ~ = nil or entry.animSpeed ~ = nil ) then
                                        entry.dirtyFlag = self:getNextDirtyFlag()
                                        entry.saving = xmlFile:getValue(key .. "#allowSaving" , true )
                                    end

                                    entry.aiActivePosition = xmlFile:getValue(key .. "#aiActivePosition" )

                                    entry.isDirty = false
                                    entry.isIntitialDirty = xmlFile:getValue(key .. "#isIntitialDirty" , true )

                                    entry.rotationAxis = xmlFile:getValue(key .. ".rotation#rotationAxis" , 1 )
                                    entry.translationAxis = xmlFile:getValue(key .. ".translation#translationAxis" , 3 )

                                    local detachingRotMaxLimit = xmlFile:getValue(key .. ".rotation#detachingRotMaxLimit" )
                                    local detachingRotMinLimit = xmlFile:getValue(key .. ".rotation#detachingRotMinLimit" )
                                    local detachingTransMaxLimit = xmlFile:getValue(key .. ".translation#detachingTransMaxLimit" )
                                    local detachingTransMinLimit = xmlFile:getValue(key .. ".translation#detachingTransMinLimit" )
                                    if detachingRotMaxLimit ~ = nil or detachingRotMinLimit ~ = nil or detachingTransMaxLimit ~ = nil or detachingTransMinLimit ~ = nil then
                                        if spec.detachLockNodes = = nil then
                                            spec.detachLockNodes = { }
                                        end

                                        local detachLock = { }
                                        detachLock.detachingRotMaxLimit = detachingRotMaxLimit
                                        detachLock.detachingRotMinLimit = detachingRotMinLimit
                                        detachLock.detachingTransMinLimit = detachingTransMinLimit
                                        detachLock.detachingTransMaxLimit = detachingTransMaxLimit

                                        spec.detachLockNodes[entry] = detachLock
                                    end

                                    entry.hasRequiredConfigurations = true
                                    local requiredConfigurationName = xmlFile:getValue(key .. "#requiredConfigurationName" )
                                    if requiredConfigurationName ~ = nil then
                                        local requiredConfigurationIndices = xmlFile:getValue(key .. "#requiredConfigurationIndices" , nil , true )
                                        if requiredConfigurationIndices ~ = nil then
                                            entry.hasRequiredConfigurations = false
                                            for i = 1 , #requiredConfigurationIndices do
                                                if self.configurations[requiredConfigurationName] = = requiredConfigurationIndices[i] then
                                                    entry.hasRequiredConfigurations = true
                                                    break
                                                end
                                            end
                                        end
                                    end

                                    local rx,ry,rz = getRotation(node)
                                    entry.curRot = { rx,ry,rz }
                                    local x,y,z = getTranslation(node)
                                    entry.curTrans = { x,y,z }

                                    entry.startRot = xmlFile:getValue(key .. ".rotation#startRot" )
                                    entry.startTrans = xmlFile:getValue(key .. ".translation#startTrans" )

                                    entry.move = 0
                                    entry.moveToSend = 0

                                    entry.smoothedMove = 0
                                    entry.lastInputTime = 0

                                    -- delayed node
                                    XMLUtil.checkDeprecatedXMLElements(xmlFile, key .. "#delayedIndex" , key .. "#delayedNode" ) --FS17 to FS19

                                    entry.delayedNode = xmlFile:getValue(key .. "#delayedNode" , nil , self.components, self.i3dMappings)
                                    if entry.delayedNode ~ = nil then
                                        entry.delayedFrames = xmlFile:getValue(key .. "#delayedFrames" , 3 )

                                        entry.currentDelayedData = { rot = { rx, ry, rz } , trans = { x, y, z } }
                                        entry.delayedHistroyData = { }
                                        for i = 1 , entry.delayedFrames do
                                            entry.delayedHistroyData[i] = { rot = { rx, ry, rz } , trans = { x, y, z } }
                                        end

                                        entry.delayedHistoryIndex = 0
                                    end

                                    entry.networkInterpolators.translation = InterpolatorValue.new(entry.curTrans[entry.translationAxis])
                                    entry.networkInterpolators.translation:setMinMax(entry.transMin, entry.transMax)
                                    entry.networkInterpolators.rotation = InterpolatorAngle.new(entry.curRot[entry.rotationAxis])
                                    entry.networkInterpolators.rotation:setMinMax(entry.rotMin, entry.rotMax)
                                    entry.networkTimeInterpolator = InterpolationTime.new( 1.2 )

                                    entry.isTool = true

                                    return true
                                end

                                return false
                            end

```

### loadMovingToolsFromXML

**Description**

**Definition**

> loadMovingToolsFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function Cylindered:loadMovingToolsFromXML(xmlFile, key)
    local spec = self.spec_cylindered

    for _, toolKey in xmlFile:iterator(key) do
        local entry = { }
        if self:loadMovingToolFromXML(xmlFile, toolKey, entry) then
            if spec.referenceNodes[entry.node] = = nil then
                spec.referenceNodes[entry.node] = { }
            end

            if spec.nodesToMovingTools[entry.node] = = nil then
                table.insert(spec.referenceNodes[entry.node], entry)

                self:loadDependentMovingTools(xmlFile, toolKey, entry)
                self:loadDependentParts(xmlFile, toolKey, entry)
                self:loadDependentComponentJoints(xmlFile, toolKey, entry)
                self:loadExtraDependentParts(xmlFile, toolKey, entry)
                self:loadDependentAnimations(xmlFile, toolKey, entry)

                entry.isActive = true
                entry.key = toolKey
                table.insert(spec.movingTools, entry)
                spec.nodesToMovingTools[entry.node] = entry
            else
                    Logging.xmlWarning(xmlFile, "Moving tool with node '%s' already exists!" , getName(entry.node))
                end
            end
        end
    end

```

### loadObjectChangeValuesFromXML

**Description**

> Load object change from xml

**Definition**

> loadObjectChangeValuesFromXML(XMLFile xmlFile, string key, integer node, table object, )

**Arguments**

| XMLFile | xmlFile | XMLFile instance |
|---------|---------|------------------|
| string  | key     | key              |
| integer | node    | node id          |
| table   | object  | object           |
| any     | object  |                  |

**Code**

```lua
function Cylindered:loadObjectChangeValuesFromXML(superFunc, xmlFile, key, node, object)
    superFunc( self , xmlFile, key, node, object)

    local spec = self.spec_cylindered

    if spec.nodesToMovingTools ~ = nil and spec.nodesToMovingTools[node] ~ = nil then
        local movingTool = spec.nodesToMovingTools[node]
        object.movingToolRotMaxActive = xmlFile:getValue(key .. "#movingToolRotMaxActive" , math.deg(movingTool.rotMax or 0 ))
        object.movingToolRotMaxInactive = xmlFile:getValue(key .. "#movingToolRotMaxInactive" , math.deg(movingTool.rotMax or 0 ))
        object.movingToolRotMinActive = xmlFile:getValue(key .. "#movingToolRotMinActive" , math.deg(movingTool.rotMin or 0 ))
        object.movingToolRotMinInactive = xmlFile:getValue(key .. "#movingToolRotMinInactive" , math.deg(movingTool.rotMin or 0 ))

        object.movingToolStartRotActive = xmlFile:getValue(key .. "#movingToolStartRotActive" )
        object.movingToolStartRotInactive = xmlFile:getValue(key .. "#movingToolStartRotInactive" )

        object.movingToolTransMaxActive = xmlFile:getValue(key .. "#movingToolTransMaxActive" , movingTool.transMax)
        object.movingToolTransMaxInactive = xmlFile:getValue(key .. "#movingToolTransMaxInactive" , movingTool.transMax)
        object.movingToolTransMinActive = xmlFile:getValue(key .. "#movingToolTransMinActive" , movingTool.transMin)
        object.movingToolTransMinInactive = xmlFile:getValue(key .. "#movingToolTransMinInactive" , movingTool.transMin)

        object.movingToolStartTransActive = xmlFile:getValue(key .. "#movingToolStartTransActive" )
        object.movingToolStartTransInactive = xmlFile:getValue(key .. "#movingToolStartTransInactive" )
    end

    ObjectChangeUtil.loadValueType(object.values, xmlFile, key, "movingPartUpdate" , nil ,
    function (state)
        if self.getMovingPartByNode ~ = nil then
            local movingPart = self:getMovingPartByNode(node)
            if movingPart ~ = nil then
                movingPart.isActive = state
            end
        end
    end , false )
end

```

### loadRotationBasedLimits

**Description**

**Definition**

> loadRotationBasedLimits()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | tool    |

**Code**

```lua
function Cylindered:loadRotationBasedLimits(xmlFile, key, tool)
    local rotation = xmlFile:getValue(key .. "#rotation" )
    local rotMin = xmlFile:getValue(key .. "#rotMin" )
    local rotMax = xmlFile:getValue(key .. "#rotMax" )
    local transMin = xmlFile:getValue(key .. "#transMin" )
    local transMax = xmlFile:getValue(key .. "#transMax" )

    if rotation ~ = nil and(rotMin ~ = nil or rotMax ~ = nil or transMin ~ = nil or transMax ~ = nil ) then
        local time = rotation
        if tool.rotMin ~ = nil and tool.rotMax ~ = nil then
            -- normalize to moving tool range if we are inside a moving tool
                time = (rotation - tool.rotMin) / (tool.rotMax - tool.rotMin)
            end

            return { rotMin = rotMin, rotMax = rotMax, transMin = transMin, transMax = transMax, time = time }
        end

        return nil
    end

```

### loadShovelNode

**Description**

**Definition**

> loadShovelNode()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | key       |
| any | entry     |

**Code**

```lua
function Cylindered:loadShovelNode(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    local baseKey = key .. ".movingToolActivation"
    if not xmlFile:hasProperty(baseKey) then
        return true
    end

    entry.movingToolActivation = { }
    entry.movingToolActivation.node = xmlFile:getValue(baseKey .. "#node" , nil , self.components, self.i3dMappings)
    entry.movingToolActivation.isInverted = xmlFile:getValue(baseKey .. "#isInverted" , false )
    entry.movingToolActivation.openFactor = xmlFile:getValue(baseKey .. "#openFactor" , 1 )

    return true
end

```

### movingToolDashboardAttributes

**Description**

**Definition**

> movingToolDashboardAttributes()

**Arguments**

| any | self        |
|-----|-------------|
| any | xmlFile     |
| any | key         |
| any | dashboard   |
| any | components  |
| any | i3dMappings |

**Code**

```lua
function Cylindered.movingToolDashboardAttributes( self , xmlFile, key, dashboard, components, i3dMappings)
    dashboard.axis = xmlFile:getValue(key .. "#axis" )

    if dashboard.axis = = nil then
        Logging.xmlWarning(xmlFile, "Misssing axis attribute for dashboard '%s'" , key)
            return false
        end

        local attacherJointIndex = xmlFile:getValue(key .. "#attacherJointIndex" )
        if attacherJointIndex ~ = nil then
            dashboard.attacherJointIndices = { }
            table.insert(dashboard.attacherJointIndices, attacherJointIndex)
        end

        dashboard.attacherJointNode = xmlFile:getValue(key .. "#attacherJointNode" , nil , self.components, self.i3dMappings)
        dashboard.attacherJointNodes = xmlFile:getValue(key .. "#attacherJointNodes" , nil , self.components, self.i3dMappings, true )
        table.insert(dashboard.attacherJointNodes, dashboard.attacherJointNode)

        if #dashboard.attacherJointNodes = = 0 then
            dashboard.attacherJointNodes = nil
        end

        return true
    end

```

### onAIImplementStart

**Description**

> Called when when the ai starts to work

**Definition**

> onAIImplementStart()

**Code**

```lua
function Cylindered:onAIImplementStart()
    local spec = self.spec_cylindered
    for _, movingTool in ipairs(spec.movingTools) do
        if movingTool.aiActivePosition ~ = nil then
            movingTool.curTargetPosition = movingTool.aiActivePosition
            movingTool.curTargetDirection = movingTool.curTargetPosition - Cylindered.getMovingToolState( self , movingTool)
        end
    end
end

```

### onAnimationPartChanged

**Description**

> Called when animation part has changed

**Definition**

> onAnimationPartChanged()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function Cylindered:onAnimationPartChanged(node)
    self:setMovingToolDirty(node)
end

```

### onDeactivate

**Description**

> Called on deactivate

**Definition**

> onDeactivate()

**Code**

```lua
function Cylindered:onDeactivate()
    if self.isClient then
        local spec = self.spec_cylindered
        g_soundManager:stopSample(spec.samples.hydraulic)
        spec.isHydraulicSamplePlaying = false

        -- reset the moving tool input values
        for _, movingTool in ipairs(spec.movingTools) do
            movingTool.move = 0
            movingTool.externalMove = 0
        end
    end
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Cylindered:onDelete()
    local spec = self.spec_cylindered

    g_soundManager:deleteSamples(spec.samples)
    g_soundManager:deleteSamples(spec.actionSamples)

    if spec.movingTools ~ = nil then
        for _,movingTool in pairs(spec.movingTools) do
            if movingTool.icon ~ = nil then
                movingTool.icon:delete()
                movingTool.icon = nil
            end
        end
    end
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
function Cylindered:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_cylindered
    if #spec.controlGroupNames > 1 then
        if isActiveForInputIgnoreSelection then
            if spec.currentControlGroupIndex ~ = 0 then
                g_currentMission:addExtraPrintText( string.format(g_i18n:getText( "action_selectedControlGroup" ), spec.controlGroupNames[spec.currentControlGroupIndex], spec.currentControlGroupIndex))
            end
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
function Cylindered:onLoad(savegame)
    local spec = self.spec_cylindered

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.movingParts" , "vehicle.cylindered.movingParts" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.movingTools" , "vehicle.cylindered.movingTools" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cylinderedHydraulicSound" , "vehicle.cylindered.sounds.hydraulic" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cylindered.movingParts#isActiveDirtyTimeOffset" ) --FS19 to FS22

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.cylindered.movingParts.sounds" , "vehicle.cylindered.sounds" ) --FS19 to FS22

    local configurationId = self.configurations[ "cylindered" ] or 1
    local configKey = string.format( "vehicle.cylindered.cylinderedConfigurations.cylinderedConfiguration(%d)" , configurationId - 1 )

    spec.activeDirtyMovingParts = { }

    spec.referenceNodes = { }
    spec.nodesToMovingParts = { }
    spec.movingParts = { }
    self.anyMovingPartsDirty = false
    spec.detachLockNodes = nil

    self:loadMovingPartsFromXML( self.xmlFile, "vehicle.cylindered.movingParts.movingPart" )
    self:loadMovingPartsFromXML( self.xmlFile, configKey .. ".movingParts.movingPart" )

    if Cylindered.DIRTY_COLLISION_UPDATE_CHECK then
        -- collect all active dirty moving parts which have directionThreshold not changed from xml
        -- and check if any of these has collisions as children.If yes, print warning
            local function collectDependentParts(part, target)
                table.insert(target, part)

                if part.dependentPartNodes ~ = nil then
                    for l = 1 , #part.dependentPartNodes do
                        local dependentMovingPart = spec.nodesToMovingParts[part.dependentPartNodes[l]]
                        if dependentMovingPart ~ = nil then
                            table.insert(target, dependentMovingPart)

                            collectDependentParts(dependentMovingPart, target)
                        end
                    end
                end
            end

            local function subCollisionErrorFunction(collisionNode, xmlFile, key)
                if getHasClassId(collisionNode, ClassIds.SHAPE) then
                    Logging.xmlError(xmlFile, "Found collision '%s' as child of isActiveDirty movingPart '%s'.This can cause the vehicle to never sleep!" , getName(collisionNode), key)
                end
            end

            spec.realActiveDirtyParts = { }
            for j = 1 , #spec.movingParts do
                local movingPart = spec.movingParts[j]
                if movingPart.isActiveDirty and movingPart.directionThreshold = = 0.0001 then
                    collectDependentParts(movingPart, spec.realActiveDirtyParts)
                end
            end

            for j = 1 , #spec.realActiveDirtyParts do
                local part = spec.realActiveDirtyParts[j]
                I3DUtil.checkForChildCollisions(part.node, subCollisionErrorFunction, self.xmlFile, getName(part.node))
            end
        end

        spec.powerConsumingActiveTimeOffset = self.xmlFile:getValue( "vehicle.cylindered.movingTools#powerConsumingActiveTimeOffset" , 5 )
        spec.powerConsumingTimer = - 1

        -- find dependencies
        for _, part in pairs(spec.movingParts) do
            self:resolveDependentPartData(part.dependentPartData, spec.referenceNodes)
        end

        local function addMovingPart(part, newTable, allowDependentParts)
            for _, addedPart in ipairs(newTable) do
                if addedPart = = part then
                    return
                end
            end

            if part.isDependentPart = = true then
                if allowDependentParts ~ = true then
                    return
                end
            end

            table.insert(newTable, part)

            for _, depPart in pairs(part.dependentPartData) do
                addMovingPart(depPart.part, newTable, true )
            end
        end

        local newParts = { }
        for _, part in ipairs(spec.movingParts) do
            addMovingPart(part, newParts)
        end
        spec.movingParts = newParts

        spec.controlGroups = { }
        spec.controlGroupMapping = { }
        spec.currentControlGroupIndex = 1
        spec.controlGroupNames = { }

        for _, toolKey in ipairs( Cylindered.MOVING_TOOLS_XML_KEYS) do
            for _, groupKey in self.xmlFile:iterator(toolKey .. ".controlGroups.controlGroup" ) do
                local name = self.xmlFile:getValue(groupKey .. "#name" , "" , self.customEnvironment, false )
                if name ~ = nil then
                    table.insert(spec.controlGroupNames, name)
                end
            end
        end

        spec.nodesToMovingTools = { }
        spec.movingTools = { }

        self:loadMovingToolsFromXML( self.xmlFile, "vehicle.cylindered.movingTools.movingTool" )
        self:loadMovingToolsFromXML( self.xmlFile, configKey .. ".movingTools.movingTool" )

        local function sort(a, b)
            return a < b
        end
        table.sort(spec.controlGroups, sort )

        for _, groupIndex in ipairs(spec.controlGroups) do
            local subSelectionIndex = self:addSubselection(groupIndex)
            spec.controlGroupMapping[subSelectionIndex] = groupIndex
        end

        for _, part in pairs(spec.movingTools) do
            self:resolveDependentPartData(part.dependentPartData, spec.referenceNodes)

            for j = #part.dependentMovingTools, 1 , - 1 do
                local dependentTool = part.dependentMovingTools[j]
                local tool = spec.nodesToMovingTools[dependentTool.node]
                if tool ~ = nil then
                    dependentTool.movingTool = tool
                else
                        Logging.xmlWarning( self.xmlFile, "Dependent moving tool '%s' not defined.Ignoring it!" , getName(dependentTool.node))
                        table.remove(part.dependentMovingTools, j)
                    end
                end
            end

            for _, part in pairs(spec.movingParts) do
                for j = #part.dependentMovingTools, 1 , - 1 do
                    local dependentTool = part.dependentMovingTools[j]
                    local tool = spec.nodesToMovingTools[dependentTool.node]
                    if tool ~ = nil then
                        dependentTool.movingTool = tool
                    else
                            Logging.xmlWarning( self.xmlFile, "Dependent moving tool '%s' not defined.Ignoring it!" , getName(dependentTool.node))
                            table.remove(part.dependentMovingTools, j)
                        end
                    end
                end

                spec.referenceNodes = nil

                local easyArmControlKey = configKey .. ".movingTools.easyArmControl"
                if not self.xmlFile:hasProperty(easyArmControlKey) then
                    easyArmControlKey = "vehicle.cylindered.movingTools.easyArmControl"
                end

                if self.xmlFile:hasProperty(easyArmControlKey) then
                    local easyArmControl = { }
                    if self:loadEasyArmControlFromXML( self.xmlFile, easyArmControlKey, easyArmControl) then
                        spec.easyArmControl = easyArmControl
                    end
                end

                if self.xmlFile:hasProperty(configKey) then
                    local movingTool = DashboardValueType.new( "cylindered" , "movingTool" )
                    movingTool:setXMLKey(configKey .. ".dashboards" )
                    movingTool:setValue( self , Cylindered.getMovingToolDashboardState)
                    movingTool:setRange( 0 , 1 )
                    movingTool:setAdditionalFunctions( Cylindered.movingToolDashboardAttributes, nil )
                    movingTool:setIdleValue( 0.5 )
                    self:registerDashboardValueType(movingTool)
                end

                spec.samples = { }
                spec.actionSamples = { }
                if self.isClient then
                    spec.samples.hydraulic = g_soundManager:loadSampleFromXML( self.xmlFile, configKey .. ".sounds" , "hydraulic" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                    if spec.samples.hydraulic = = nil then
                        spec.samples.hydraulic = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.cylindered.sounds" , "hydraulic" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
                    end
                    spec.isHydraulicSamplePlaying = false

                    spec.nodesToSamples = { }
                    spec.activeSamples = { }
                    spec.endingSamples = { }
                    spec.endingSamplesBySample = { }
                    spec.startingSamples = { }
                    spec.startingSamplesBySample = { }

                    self:loadActionSoundsFromXML( self.xmlFile, "vehicle.cylindered.sounds" )
                    self:loadActionSoundsFromXML( self.xmlFile, configKey .. ".sounds" )
                end

                spec.cylinderedDirtyFlag = self:getNextDirtyFlag()
                spec.cylinderedInputDirtyFlag = self:getNextDirtyFlag()

                self:registerVehicleSetting(GameSettings.SETTING.EASY_ARM_CONTROL, true )

                spec.isLoading = true
            end

```

### onLoadFinished

**Description**

> Called after loading

**Definition**

> onLoadFinished(table savegame)

**Arguments**

| table | savegame | savegame |
|-------|----------|----------|

**Code**

```lua
function Cylindered:onLoadFinished(savegame)
    local spec = self.spec_cylindered
    spec.isLoading = false

    for i = 1 , #spec.movingTools do
        local tool = spec.movingTools[i]
        if tool.delayedHistoryIndex ~ = nil and tool.delayedHistoryIndex > 0 then
            self:updateDelayedTool(tool, true )
        end
    end
end

```

### onMovingPartSoundEvent

**Description**

**Definition**

> onMovingPartSoundEvent()

**Arguments**

| any | part   |
|-----|--------|
| any | action |
| any | type   |

**Code**

```lua
function Cylindered:onMovingPartSoundEvent(part, action, type )
    if part.samplesByAction ~ = nil then
        local samples = part.samplesByAction[action]
        if samples ~ = nil then
            for i = 1 , #samples do
                local sample = samples[i]

                if type = = Cylindered.SOUND_TYPE_EVENT then
                    if sample.loops = = 0 then
                        sample.loops = 1
                    end

                    g_soundManager:playSample(sample)
                elseif type = = Cylindered.SOUND_TYPE_CONTINUES then
                        if not g_soundManager:getIsSamplePlaying(sample) then
                            g_soundManager:playSample(sample)

                            sample.lastActivationTime = g_ time
                            sample.lastActivationPart = part

                            local spec = self.spec_cylindered
                            table.insert(spec.activeSamples, sample)
                        else
                                if sample.lastActivationPart = = part then
                                    sample.lastActivationTime = g_ time
                                end
                            end
                        elseif type = = Cylindered.SOUND_TYPE_ENDING then
                                local spec = self.spec_cylindered
                                if spec.endingSamplesBySample[sample] = = nil then
                                    sample.lastActivationTime = g_ time

                                    table.insert(spec.endingSamples, sample)
                                    spec.endingSamplesBySample[sample] = sample
                                else
                                        sample.lastActivationTime = g_ time
                                    end
                                elseif type = = Cylindered.SOUND_TYPE_STARTING then
                                        local spec = self.spec_cylindered
                                        if spec.startingSamplesBySample[sample] = = nil then
                                            if sample.loops = = 0 then
                                                sample.loops = 1
                                            end

                                            g_soundManager:playSample(sample)

                                            sample.lastActivationTime = g_ time

                                            table.insert(spec.startingSamples, sample)
                                            spec.startingSamplesBySample[sample] = sample
                                        else
                                                sample.lastActivationTime = g_ time
                                            end
                                        end
                                    end
                                end
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
function Cylindered:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_cylindered

    for _, tool in ipairs(spec.movingTools) do
        local changed = false
        if tool.transSpeed ~ = nil then
            local trans = tool.curTrans[tool.translationAxis]

            local changedTrans = false
            if tool.attachTransMax ~ = nil and trans > tool.attachTransMax then
                trans = tool.attachTransMax
                changedTrans = true
            elseif tool.attachTransMin ~ = nil and trans < tool.attachTransMin then
                    trans = tool.attachTransMin
                    changedTrans = true
                end
                if changedTrans then
                    tool.curTrans[tool.translationAxis] = trans
                    setTranslation(tool.node, unpack(tool.curTrans))
                    changed = true
                end
            end
            if tool.rotSpeed ~ = nil then
                local rot = tool.curRot[tool.rotationAxis]

                local changedRot = false
                if tool.attachRotMax ~ = nil and rot > tool.attachRotMax then
                    rot = tool.attachRotMax
                    changedRot = true
                elseif tool.attachRotMin ~ = nil and rot < tool.attachRotMin then
                        rot = tool.attachRotMin
                        changedRot = true
                    end
                    if changedRot then
                        tool.curRot[tool.rotationAxis] = rot
                        setRotation(tool.node, unpack(tool.curRot))
                        changed = true
                    end
                end
                if changed then
                    Cylindered.setDirty( self , tool)
                end
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
function Cylindered:onPostLoad(savegame)
    local spec = self.spec_cylindered

    for _, tool in pairs(spec.movingTools) do
        if self:getIsMovingToolActive(tool) then
            if tool.startRot ~ = nil then
                tool.curRot[tool.rotationAxis] = tool.startRot
                setRotation(tool.node, unpack(tool.curRot))

                SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, 0 , 0 )
            end
            if tool.startTrans ~ = nil then
                tool.curTrans[tool.translationAxis] = tool.startTrans
                setTranslation(tool.node, unpack(tool.curTrans))

                SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, 0 , 0 )
            end

            if tool.animStartTime ~ = nil then
                self:setAnimationTime(tool.animName, tool.animStartTime, nil , false )

                SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, 0 , 0 )
            end

            if tool.delayedNode ~ = nil then
                self:setDelayedData(tool, true )
            end

            if tool.isIntitialDirty then
                Cylindered.setDirty( self , tool)
            end
        end
    end

    for _, part in pairs(spec.movingParts) do
        self:loadDependentAttacherJoints( self.xmlFile, part.key, part)
        self:loadDependentWheels( self.xmlFile, part.key, part)
    end

    for _, tool in pairs(spec.movingTools) do
        self:loadDependentAttacherJoints( self.xmlFile, tool.key, tool)
        self:loadDependentWheels( self.xmlFile, tool.key, tool)
    end

    if self:allowLoadMovingToolStates() then
        if savegame ~ = nil and not savegame.resetVehicles then
            local i = 0
            for _, tool in ipairs(spec.movingTools) do
                if tool.saving then
                    if self:getIsMovingToolActive(tool) then
                        local toolKey = string.format( "%s.cylindered.movingTool(%d)" , savegame.key, i)
                        local changed = false
                        if tool.transSpeed ~ = nil then
                            local newTrans = savegame.xmlFile:getValue(toolKey .. "#translation" )
                            if newTrans ~ = nil then
                                if tool.transMax ~ = nil then
                                    newTrans = math.min(newTrans, tool.transMax)
                                end
                                if tool.transMin ~ = nil then
                                    newTrans = math.max(newTrans, tool.transMin)
                                end
                            end
                            if newTrans ~ = nil and math.abs(newTrans - tool.curTrans[tool.translationAxis]) > 0.0001 then
                                tool.curTrans = { getTranslation(tool.node) }
                                tool.curTrans[tool.translationAxis] = newTrans
                                setTranslation(tool.node, unpack(tool.curTrans))
                                changed = true
                            end
                        end
                        if tool.rotSpeed ~ = nil then
                            local newRot = savegame.xmlFile:getValue(toolKey .. "#rotation" )
                            if newRot ~ = nil then
                                if tool.rotMax ~ = nil then
                                    newRot = math.min(newRot, tool.rotMax)
                                end
                                if tool.rotMin ~ = nil then
                                    newRot = math.max(newRot, tool.rotMin)
                                end
                            end
                            if newRot ~ = nil and math.abs(newRot - tool.curRot[tool.rotationAxis]) > 0.0001 then
                                tool.curRot = { getRotation(tool.node) }
                                tool.curRot[tool.rotationAxis] = newRot
                                setRotation(tool.node, unpack(tool.curRot))
                                changed = true
                            end
                        end
                        if tool.animSpeed ~ = nil then
                            local animTime = savegame.xmlFile:getValue(toolKey .. "#animationTime" )
                            if animTime ~ = nil then
                                if tool.animMinTime ~ = nil then
                                    animTime = math.max(animTime, tool.animMinTime)
                                end
                                if tool.animMaxTime ~ = nil then
                                    animTime = math.min(animTime, tool.animMaxTime)
                                end

                                tool.curAnimTime = animTime
                                self:setAnimationTime(tool.animName, animTime, true , false )
                            end
                        end
                        if changed then
                            Cylindered.setDirty( self , tool)

                            SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, 0 , 0 )
                        end

                        if tool.delayedNode ~ = nil then
                            self:setDelayedData(tool, true )
                        end
                    end
                    i = i + 1
                end

                for _, dependentTool in pairs(tool.dependentMovingTools) do
                    Cylindered.updateRotationBasedLimits( self , tool, dependentTool)
                end
            end
        end
    end

    self:updateEasyControl( 9999 , true )
    self:updateCylinderedInitial( false )

    local hasTools, hasParts = #spec.movingTools > 0 , #spec.movingParts > 0
    if not hasTools then
        SpecializationUtil.removeEventListener( self , "onReadStream" , Cylindered )
        SpecializationUtil.removeEventListener( self , "onWriteStream" , Cylindered )
        SpecializationUtil.removeEventListener( self , "onReadUpdateStream" , Cylindered )
        SpecializationUtil.removeEventListener( self , "onWriteUpdateStream" , Cylindered )
        SpecializationUtil.removeEventListener( self , "onUpdate" , Cylindered )

        if not hasParts then
            SpecializationUtil.removeEventListener( self , "onUpdateTick" , Cylindered )
            SpecializationUtil.removeEventListener( self , "onPostUpdate" , Cylindered )
            SpecializationUtil.removeEventListener( self , "onPostUpdateTick" , Cylindered )
        end
    end

    if not self.isClient or not hasTools then
        SpecializationUtil.removeEventListener( self , "onDraw" , Cylindered )
        SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , Cylindered )
    end

    -- check if functional nodes are included in moving parts with limited update distance
        if g_isDevelopmentVersion then
            local function checkPart(part)
                I3DUtil.iterateRecursively(part.node, function (child, depth)
                    self:checkMovingPartDirtyUpdateNode(child, part)
                end )

                if part.dependentPartData ~ = nil then
                    for _, data in pairs(part.dependentPartData) do
                        if data.part ~ = nil then
                            checkPart(data.part)
                        end
                    end
                end
            end

            for j = 1 , #spec.movingParts do
                local movingPart = spec.movingParts[j]
                if movingPart.isActiveDirty then
                    if movingPart.maxUpdateDistance ~ = math.huge then
                        checkPart(movingPart)
                    end
                end
            end
        end
    end

```

### onPostUpdate

**Description**

**Definition**

> onPostUpdate()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Cylindered:onPostUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_cylindered
    for _, part in pairs(spec.activeDirtyMovingParts) do
        if self.currentUpdateDistance < part.maxUpdateDistance then
            Cylindered.setDirty( self , part)
        end
    end

    self:updateDirtyMovingParts(dt, true )
end

```

### onPostUpdateTick

**Description**

**Definition**

> onPostUpdateTick()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Cylindered:onPostUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    -- update the moving parts that have been set dirty in the updateTick, so they won't be one frame delayed
    self:updateDirtyMovingParts(dt, false )
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
function Cylindered:onReadStream(streamId, connection)
    local spec = self.spec_cylindered

    if connection:getIsServer() then
        if streamReadBool(streamId) then
            for i = 1 , #spec.movingTools do
                local tool = spec.movingTools[i]
                if tool.dirtyFlag ~ = nil then
                    tool.networkTimeInterpolator:reset()
                    if tool.transSpeed ~ = nil then
                        local newTrans = streamReadFloat32(streamId)
                        tool.curTrans[tool.translationAxis] = newTrans
                        setTranslation(tool.node, unpack(tool.curTrans))
                        tool.networkInterpolators.translation:setValue(tool.curTrans[tool.translationAxis])
                    end
                    if tool.rotSpeed ~ = nil then
                        local newRot = streamReadFloat32(streamId)
                        tool.curRot[tool.rotationAxis] = newRot
                        setRotation(tool.node, unpack(tool.curRot))
                        tool.networkInterpolators.rotation:setAngle(newRot)
                    end
                    if tool.animSpeed ~ = nil then
                        local newAnimTime = streamReadFloat32(streamId)
                        tool.curAnimTime = newAnimTime
                        self:setAnimationTime(tool.animName, tool.curAnimTime, nil , false )
                        tool.networkInterpolators.animation:setValue(newAnimTime)
                    end
                    if tool.delayedNode ~ = nil then
                        self:setDelayedData(tool, true )
                    end
                    Cylindered.setDirty( self , tool)

                    SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, 0 , 0 )
                end
            end
        end
    end
end

```

### onReadUpdateStream

**Description**

> Called on on update

**Definition**

> onReadUpdateStream(integer streamId, integer timestamp, table connection)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| integer | timestamp  | timestamp  |
| table   | connection | connection |

**Code**

```lua
function Cylindered:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_cylindered

    -- if server, read input from client
        if not connection:getIsServer() then
            if streamReadBool(streamId) then
                for _, tool in ipairs(spec.movingTools) do
                    if tool.axisActionIndex ~ = nil then
                        tool.move = (streamReadUIntN(streamId, 12 ) / 4095 * 2 - 1 ) * 5
                        if math.abs(tool.move) < 0.01 then
                            tool.move = 0
                        end
                    end
                end
            end
        else
                -- if client, read updated attributes
                    if streamReadBool(streamId) then
                        for _, tool in ipairs(spec.movingTools) do
                            if tool.dirtyFlag ~ = nil then
                                if streamReadBool(streamId) then
                                    tool.networkTimeInterpolator:startNewPhaseNetwork()

                                    if tool.transSpeed ~ = nil then
                                        local newTrans = streamReadFloat32(streamId)
                                        if math.abs(newTrans - tool.curTrans[tool.translationAxis]) > 0.0001 then
                                            tool.networkInterpolators.translation:setTargetValue(newTrans)
                                        end
                                    end
                                    if tool.rotSpeed ~ = nil then
                                        local newRot
                                        if tool.rotMin = = nil or tool.rotMax = = nil then
                                            newRot = NetworkUtil.readCompressedAngle(streamId)
                                        else
                                                if tool.syncMinRotLimits then
                                                    tool.rotMin = streamReadFloat32(streamId)
                                                end
                                                if tool.syncMaxRotLimits then
                                                    tool.rotMax = streamReadFloat32(streamId)
                                                end

                                                tool.networkInterpolators.rotation:setMinMax(tool.rotMin, tool.rotMax)
                                                newRot = NetworkUtil.readCompressedRange(streamId, tool.rotMin, tool.rotMax, tool.rotSendNumBits)
                                            end
                                            if math.abs(newRot - tool.curRot[tool.rotationAxis]) > 0.0001 then
                                                tool.networkInterpolators.rotation:setTargetAngle(newRot)
                                            end
                                        end
                                        if tool.animSpeed ~ = nil then
                                            local resetAnimInterpolation = streamReadBool(streamId)

                                            local newAnimTime = NetworkUtil.readCompressedRange(streamId, tool.animMinTime, tool.animMaxTime, tool.animSendNumBits)
                                            if math.abs(newAnimTime - tool.curAnimTime) > 0.0001 then
                                                tool.networkInterpolators.animation:setTargetValue(newAnimTime)

                                                -- animation has been changed from outside of cylindered, so we reset the interpolation
                                                if resetAnimInterpolation then
                                                    tool.networkInterpolators.animation:setValue(newAnimTime)
                                                end
                                            end
                                        end
                                    end
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
function Cylindered:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_cylindered
        self:clearActionEventsTable(spec.actionEvents)

        -- no check for selection since movingTools can be controlled globally
            -- sub selection moving tools always require the selection of the sub index
            if isActiveForInputIgnoreSelection then
                for i = 1 , #spec.movingTools do
                    local movingTool = spec.movingTools[i]
                    local isSelectedGroup = movingTool.controlGroupIndex = = 0 or movingTool.controlGroupIndex = = spec.currentControlGroupIndex
                    local easyArmControlActive = g_gameSettings:getValue(GameSettings.SETTING.EASY_ARM_CONTROL)
                    local canBeControlled = (easyArmControlActive and movingTool.easyArmControlActive) or( not easyArmControlActive and not movingTool.isEasyControlTarget)
                    if movingTool.axisActionIndex ~ = nil and isSelectedGroup and canBeControlled then
                        local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, movingTool.axisActionIndex, self , Cylindered.actionEventInput, true , false , true , true , i, movingTool.axisActionIcon)
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
function Cylindered:onRegisterAnimationValueTypes()
    self:registerAnimationValueType( "movingPartReferencePoint" , "" , "" , false , AnimationValueFloat ,
    function (value, xmlFile, xmlKey)
        value.node = xmlFile:getValue(xmlKey .. "#node" , nil , value.part.components, value.part.i3dMappings)

        value.startReferencePoint = xmlFile:getValue(xmlKey .. "#startReferencePoint" , nil , value.part.components, value.part.i3dMappings)
        value.endReferencePoint = xmlFile:getValue(xmlKey .. "#endReferencePoint" , nil , value.part.components, value.part.i3dMappings)

        if value.node ~ = nil and value.startReferencePoint ~ = nil and value.endReferencePoint ~ = nil then
            value:setWarningInformation( "node: " .. getName(value.node))
            value:addCompareParameters( "node" )

            value.animatedReferencePoint = createTransformGroup( "animatedReferencePoint_" .. getName(value.node))
            link(getParent(value.node), value.animatedReferencePoint)
            setWorldTranslation(value.animatedReferencePoint, getWorldTranslation(value.startReferencePoint))

            value.startValue = { 0 }
            value.endValue = { 1 }

            return true
        end

        return false
    end ,

    function (value)
        local startTime = value.startValue or value.endValue
        if value.animation.currentSpeed < 0 then
            startTime = value.endValue or value.startValue
        end

        return startTime[ 1 ]
    end ,

    function (value, alpha)
        if value.movingPart = = nil then
            value.movingPart = self:getMovingPartByNode(value.node)
        end

        local x1, y1, z1 = localToLocal(value.startReferencePoint, getParent(value.node), 0 , 0 , 0 )
        local x2, y2, z2 = localToLocal(value.endReferencePoint, getParent(value.node), 0 , 0 , 0 )
        local x, y, z = MathUtil.vector3Lerp(x1, y1, z1, x2, y2, z2, alpha)
        setTranslation(value.animatedReferencePoint, x, y, z)

        if value.movingPart ~ = nil then
            if alpha = = 1 then
                self:setMovingPartReferenceNode(value.movingPart, value.endReferencePoint)
            elseif alpha = = 0 then
                    self:setMovingPartReferenceNode(value.movingPart, value.startReferencePoint)
                else
                        self:setMovingPartReferenceNode(value.movingPart, value.animatedReferencePoint)
                    end
                end
            end )
        end

```

### onRegisterDashboardValueTypes

**Description**

> Called on post load to register dashboard value types

**Definition**

> onRegisterDashboardValueTypes()

**Code**

```lua
function Cylindered:onRegisterDashboardValueTypes()
    local movingTool = DashboardValueType.new( "cylindered" , "movingTool" )
    movingTool:setValue( self , Cylindered.getMovingToolDashboardState)
    movingTool:setRange( 0 , 1 )
    movingTool:setAdditionalFunctions( Cylindered.movingToolDashboardAttributes, nil )
    movingTool:setIdleValue( 0.5 )
    self:registerDashboardValueType(movingTool)
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
function Cylindered:onSelect(subSelectionIndex)
    local spec = self.spec_cylindered
    local controlGroupIndex = spec.controlGroupMapping[subSelectionIndex]
    if controlGroupIndex ~ = nil then
        spec.currentControlGroupIndex = controlGroupIndex
    else
            spec.currentControlGroupIndex = 0
        end
    end

```

### onUnselect

**Description**

**Definition**

> onUnselect()

**Code**

```lua
function Cylindered:onUnselect()
    local spec = self.spec_cylindered
    spec.currentControlGroupIndex = 0
end

```

### onUpdate

**Description**

> Called on update

**Definition**

> onUpdate(float dt, boolean isActive, boolean isActiveForInput, boolean isSelected)

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActive         | true if vehicle is active           |
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |

**Code**

```lua
function Cylindered:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_cylindered

    spec.movingToolNeedsSound = false
    spec.movingPartNeedsSound = false

    self:updateEasyControl(dt)

    if self.isServer then
        for i = 1 , #spec.movingTools do
            local tool = spec.movingTools[i]

            local rotSpeed = 0
            local transSpeed = 0
            local animSpeed = 0

            local move = self:getMovingToolMoveValue(tool)
            tool.externalMove = 0 -- reset external move in any case, also if the movement is blocked, otherwise it will be summed up

                if tool.curTargetPosition ~ = nil then
                    local delta = math.abs( Cylindered.getMovingToolState( self , tool) - tool.curTargetPosition)
                    if delta < 0.001 then
                        tool.curTargetPosition = nil
                        tool.curTargetDirection = nil
                    else
                            move = tool.curTargetDirection
                        end
                    end

                    if math.abs(move) > 0 then
                        if tool.rotSpeed ~ = nil then
                            rotSpeed = move * tool.rotSpeed
                            if tool.rotAcceleration ~ = nil and math.abs(rotSpeed - tool.lastRotSpeed) > = tool.rotAcceleration * dt then
                                if rotSpeed > tool.lastRotSpeed then
                                    rotSpeed = tool.lastRotSpeed + tool.rotAcceleration * dt
                                else
                                        rotSpeed = tool.lastRotSpeed - tool.rotAcceleration * dt
                                    end
                                end
                            end
                            if tool.transSpeed ~ = nil then
                                transSpeed = move * tool.transSpeed
                                if tool.transAcceleration ~ = nil and math.abs(transSpeed - tool.lastTransSpeed) > = tool.transAcceleration * dt then
                                    if transSpeed > tool.lastTransSpeed then
                                        transSpeed = tool.lastTransSpeed + tool.transAcceleration * dt
                                    else
                                            transSpeed = tool.lastTransSpeed - tool.transAcceleration * dt
                                        end
                                    end
                                end
                                if tool.animSpeed ~ = nil then
                                    animSpeed = move * tool.animSpeed
                                    if tool.animAcceleration ~ = nil and math.abs(animSpeed - tool.lastAnimSpeed) > = tool.animAcceleration * dt then
                                        if animSpeed > tool.lastAnimSpeed then
                                            animSpeed = tool.lastAnimSpeed + tool.animAcceleration * dt
                                        else
                                                animSpeed = tool.lastAnimSpeed - tool.animAcceleration * dt
                                            end
                                        end
                                    end
                                else
                                        -- decelerate
                                        if tool.rotAcceleration ~ = nil then
                                            if tool.lastRotSpeed < 0 then
                                                rotSpeed = math.min(tool.lastRotSpeed + tool.rotAcceleration * dt, 0 )
                                            else
                                                    rotSpeed = math.max(tool.lastRotSpeed - tool.rotAcceleration * dt, 0 )
                                                end
                                            end
                                            if tool.transAcceleration ~ = nil then
                                                if tool.lastTransSpeed < 0 then
                                                    transSpeed = math.min(tool.lastTransSpeed + tool.transAcceleration * dt, 0 )
                                                else
                                                        transSpeed = math.max(tool.lastTransSpeed - tool.transAcceleration * dt, 0 )
                                                    end
                                                end
                                                if tool.animAcceleration ~ = nil then
                                                    if tool.lastAnimSpeed < 0 then
                                                        animSpeed = math.min(tool.lastAnimSpeed + tool.animAcceleration * dt, 0 )
                                                    else
                                                            animSpeed = math.max(tool.lastAnimSpeed - tool.animAcceleration * dt, 0 )
                                                        end
                                                    end
                                                end

                                                local changed = false
                                                if rotSpeed ~ = nil and rotSpeed ~ = 0 then
                                                    changed = changed or Cylindered.setToolRotation( self , tool, rotSpeed, dt)
                                                else
                                                        tool.lastRotSpeed = 0
                                                    end
                                                    if transSpeed ~ = nil and transSpeed ~ = 0 then
                                                        changed = changed or Cylindered.setToolTranslation( self , tool, transSpeed, dt)
                                                    else
                                                            tool.lastTransSpeed = 0
                                                        end
                                                        if animSpeed ~ = nil and animSpeed ~ = 0 then
                                                            changed = changed or Cylindered.setToolAnimation( self , tool, animSpeed, dt)
                                                        else
                                                                tool.lastAnimSpeed = 0
                                                            end

                                                            for _, dependentTool in pairs(tool.dependentMovingTools) do
                                                                if dependentTool.speedScale ~ = nil then
                                                                    local isAllowed = true
                                                                    if dependentTool.requiresMovement then
                                                                        if not changed then
                                                                            isAllowed = false
                                                                        end
                                                                    end

                                                                    if isAllowed then
                                                                        dependentTool.movingTool.externalMove = dependentTool.movingTool.externalMove + dependentTool.speedScale * tool.move
                                                                    end
                                                                end

                                                                Cylindered.updateRotationBasedLimits( self , tool, dependentTool)

                                                                self:updateDependentToolLimits(tool, dependentTool)
                                                            end

                                                            if changed then
                                                                if tool.playSound then
                                                                    spec.movingToolNeedsSound = true
                                                                end
                                                                Cylindered.setDirty( self , tool)
                                                                tool.networkPositionIsDirty = true
                                                                self:raiseDirtyFlags(tool.dirtyFlag)
                                                                self:raiseDirtyFlags(spec.cylinderedDirtyFlag)

                                                                -- keep moving tool at least 2 frames in a row network dirty, so the client will always recieve and set the final position of the tool
                                                                tool.networkDirtyNextFrame = true

                                                                if tool.isConsumingPower then
                                                                    spec.powerConsumingTimer = spec.powerConsumingActiveTimeOffset
                                                                end
                                                            else
                                                                    if tool.networkDirtyNextFrame then
                                                                        self:raiseDirtyFlags(tool.dirtyFlag)
                                                                        self:raiseDirtyFlags(spec.cylinderedDirtyFlag)
                                                                        tool.networkDirtyNextFrame = nil
                                                                    end
                                                                end
                                                            end
                                                        else
                                                                -- client side
                                                                for i = 1 , #spec.movingTools do
                                                                    local tool = spec.movingTools[i]

                                                                    tool.networkTimeInterpolator:update(dt)
                                                                    local interpolationAlpha = tool.networkTimeInterpolator:getAlpha()
                                                                    local changed = false

                                                                    if self:getIsMovingToolActive(tool) then
                                                                        if tool.rotSpeed ~ = nil then
                                                                            local newRot = tool.networkInterpolators.rotation:getInterpolatedValue(interpolationAlpha)
                                                                            if math.abs(newRot - tool.curRot[tool.rotationAxis]) > 0.0001 then
                                                                                changed = true
                                                                                tool.curRot[tool.rotationAxis] = newRot
                                                                                setRotation(tool.node, tool.curRot[ 1 ], tool.curRot[ 2 ], tool.curRot[ 3 ])
                                                                            end
                                                                        end

                                                                        if tool.transSpeed ~ = nil then
                                                                            local newTrans = tool.networkInterpolators.translation:getInterpolatedValue(interpolationAlpha)
                                                                            if math.abs(newTrans - tool.curTrans[tool.translationAxis]) > 0.0001 then
                                                                                changed = true
                                                                                tool.curTrans[tool.translationAxis] = newTrans
                                                                                setTranslation(tool.node, tool.curTrans[ 1 ], tool.curTrans[ 2 ], tool.curTrans[ 3 ])
                                                                            end
                                                                        end

                                                                        if tool.animSpeed ~ = nil then
                                                                            local newAnimTime = tool.networkInterpolators.animation:getInterpolatedValue(interpolationAlpha)
                                                                            if math.abs(newAnimTime - tool.curAnimTime) > 0.0001 then
                                                                                changed = true
                                                                                tool.curAnimTime = newAnimTime
                                                                                self:setAnimationTime(tool.animName, newAnimTime, nil , true )
                                                                            end
                                                                        end

                                                                        if changed then
                                                                            Cylindered.setDirty( self , tool)

                                                                            SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, 0 , dt)
                                                                        end
                                                                    end

                                                                    for _, dependentTool in pairs(tool.dependentMovingTools) do
                                                                        if not dependentTool.movingTool.syncMinRotLimits or not dependentTool.movingTool.syncMaxRotLimits then
                                                                            Cylindered.updateRotationBasedLimits( self , tool, dependentTool)
                                                                            self:updateDependentToolLimits(tool, dependentTool)
                                                                        end
                                                                    end

                                                                    if tool.networkTimeInterpolator:isInterpolating() then
                                                                        self:raiseActive()
                                                                    end
                                                                end
                                                            end

                                                            for i = 1 , #spec.movingTools do
                                                                local tool = spec.movingTools[i]
                                                                if tool.delayedHistoryIndex ~ = nil and tool.delayedHistoryIndex > 0 then
                                                                    self:updateDelayedTool(tool)
                                                                end

                                                                if tool.smoothedMove ~ = 0 then
                                                                    if tool.lastInputTime + 50 < g_ time then
                                                                        tool.smoothedMove = 0
                                                                    end
                                                                end
                                                            end

                                                            if spec.powerConsumingTimer > 0 then
                                                                spec.powerConsumingTimer = spec.powerConsumingTimer - dt
                                                            end

                                                            if next(spec.activeSamples) ~ = nil then
                                                                self:raiseActive()
                                                            end
                                                        end

```

### onUpdateEnd

**Description**

**Definition**

> onUpdateEnd()

**Arguments**

| any | dt                              |
|-----|---------------------------------|
| any | isActiveForInput                |
| any | isActiveForInputIgnoreSelection |
| any | isSelected                      |

**Code**

```lua
function Cylindered:onUpdateEnd(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    -- force update of all moving parts independent of camera distance right before vehicles starts to sleep
    -- so if we get into the moving part update distance agan we are already in the right state without waking up the vehicle
        local spec = self.spec_cylindered
        for _, part in pairs(spec.activeDirtyMovingParts) do
            Cylindered.setDirty( self , part)
        end

        self:updateDirtyMovingParts(dt, true )
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
function Cylindered:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_cylindered
        local movingToolStateChanged = false
        for _, movingTool in pairs(spec.movingTools) do
            if movingTool.axisActionIndex ~ = nil then
                local isActive = self:getIsMovingToolActive(movingTool)
                if isActive ~ = movingTool.lastIsActiveState then
                    movingTool.lastIsActiveState = isActive
                    movingToolStateChanged = true
                end

                -- check only movingTools from selected control group since the other movingTools action events are not registered
                if spec.currentControlGroupIndex = = movingTool.controlGroupIndex then
                    local actionEvent = spec.actionEvents[movingTool.axisActionIndex]
                    if actionEvent ~ = nil then
                        g_inputBinding:setActionEventActive(actionEvent.actionEventId, isActive)

                        -- reset the move values if the action gets deactivate while still being pressed
                            if not isActive then
                                movingTool.move = 0
                                if movingTool.move ~ = movingTool.moveToSend then
                                    movingTool.moveToSend = movingTool.move
                                    self:raiseDirtyFlags(spec.cylinderedInputDirtyFlag)
                                end
                            end
                        end
                    end
                end
            end

            if movingToolStateChanged then
                self:updateControlGroups()
            end

            for i = #spec.activeSamples, 1 , - 1 do
                local sample = spec.activeSamples[i]
                if sample.lastActivationTime + dt * 3 < g_ time then
                    if sample.lastActivationTime + dt * 3 + sample.dropOffTime > = g_ time then
                        if not sample.dropOffActive then
                            sample.dropOffActive = true
                            g_soundManager:setSamplePitchOffset(sample, g_soundManager:getCurrentSamplePitch(sample) * (sample.dropOffFactor - 1 ))
                        end
                    else
                            sample.dropOffActive = false
                            g_soundManager:setSamplePitchOffset(sample, 0 )
                            g_soundManager:stopSample(sample)
                            table.remove(spec.activeSamples, i)
                        end
                    end
                end

                for i = #spec.endingSamples, 1 , - 1 do
                    local sample = spec.endingSamples[i]
                    if sample.lastActivationTime + dt < g_ time then
                        if sample.loops = = 0 then
                            sample.loops = 1
                        end

                        g_soundManager:playSample(sample)
                        table.remove(spec.endingSamples, i)
                        spec.endingSamplesBySample[sample] = nil
                    end
                end

                for i = #spec.startingSamples, 1 , - 1 do
                    local sample = spec.startingSamples[i]
                    if sample.lastActivationTime + dt < g_ time then
                        table.remove(spec.startingSamples, i)
                        spec.startingSamplesBySample[sample] = nil
                    end
                end
            end
        end

```

### onVehicleSettingChanged

**Description**

> Called when vehicle settings change

**Definition**

> onVehicleSettingChanged()

**Arguments**

| any | gameSettingId |
|-----|---------------|
| any | state         |

**Code**

```lua
function Cylindered:onVehicleSettingChanged(gameSettingId, state)
    if gameSettingId = = GameSettings.SETTING.EASY_ARM_CONTROL then
        self:setIsEasyControlActive(state)
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
function Cylindered:onWriteStream(streamId, connection)
    local spec = self.spec_cylindered

    if not connection:getIsServer() then
        if streamWriteBool(streamId, self:allowLoadMovingToolStates()) then
            for i = 1 , #spec.movingTools do
                local tool = spec.movingTools[i]
                if tool.dirtyFlag ~ = nil then
                    if tool.transSpeed ~ = nil then
                        streamWriteFloat32(streamId, tool.curTrans[tool.translationAxis])
                    end
                    if tool.rotSpeed ~ = nil then
                        streamWriteFloat32(streamId, tool.curRot[tool.rotationAxis])
                    end
                    if tool.animSpeed ~ = nil then
                        tool.curAnimTime = self:getAnimationTime(tool.animName)
                        streamWriteFloat32(streamId, tool.curAnimTime)
                    end
                end
            end
        end
    end
end

```

### onWriteUpdateStream

**Description**

> Called on on update

**Definition**

> onWriteUpdateStream(integer streamId, table connection, integer dirtyMask)

**Arguments**

| integer | streamId   | stream ID  |
|---------|------------|------------|
| table   | connection | connection |
| integer | dirtyMask  | dirty mask |

**Code**

```lua
function Cylindered:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_cylindered

    -- if client, send input to server
        if connection:getIsServer() then
            if streamWriteBool(streamId, bit32.band(dirtyMask, spec.cylinderedInputDirtyFlag) ~ = 0 ) then
                for _, tool in ipairs(spec.movingTools) do
                    if tool.axisActionIndex ~ = nil then
                        local value = ( math.clamp(tool.moveToSend / 5 , - 1 , 1 ) + 1 ) / 2 * 4095
                        streamWriteUIntN(streamId, value, 12 )
                    end
                end
            end
        else
                -- if server, send updated attributes
                    if streamWriteBool(streamId, bit32.band(dirtyMask, spec.cylinderedDirtyFlag) ~ = 0 ) then
                        for _, tool in ipairs(spec.movingTools) do
                            if tool.dirtyFlag ~ = nil then
                                if streamWriteBool(streamId, bit32.band(dirtyMask, tool.dirtyFlag) ~ = 0 and self:getIsMovingToolActive(tool)) then
                                    if tool.transSpeed ~ = nil then
                                        streamWriteFloat32(streamId, tool.curTrans[tool.translationAxis])
                                    end
                                    if tool.rotSpeed ~ = nil then
                                        local rot = tool.curRot[tool.rotationAxis]
                                        if tool.rotMin = = nil or tool.rotMax = = nil then
                                            NetworkUtil.writeCompressedAngle(streamId, rot)
                                        else
                                                if tool.syncMinRotLimits then
                                                    streamWriteFloat32(streamId, tool.rotMin)
                                                end
                                                if tool.syncMaxRotLimits then
                                                    streamWriteFloat32(streamId, tool.rotMax)
                                                end
                                                NetworkUtil.writeCompressedRange(streamId, rot, tool.rotMin, tool.rotMax, tool.rotSendNumBits)
                                            end
                                        end
                                        if tool.animSpeed ~ = nil then
                                            local curAnimTime = self:getAnimationTime(tool.animName)
                                            local hasChanged = math.abs(curAnimTime - tool.curAnimTime) > 0.001
                                            streamWriteBool(streamId, hasChanged or tool.networkInterpolators.resetAnimInterpolation)
                                            tool.networkInterpolators.resetAnimInterpolation = false

                                            tool.curAnimTime = curAnimTime
                                            NetworkUtil.writeCompressedRange(streamId, tool.curAnimTime, tool.animMinTime, tool.animMaxTime, tool.animSendNumBits)
                                        end
                                    end
                                end
                            end
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
function Cylindered.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( VehicleSettings , specializations)
end

```

### registerCopyLocalDirectionXMLPaths

**Description**

**Definition**

> registerCopyLocalDirectionXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Cylindered.registerCopyLocalDirectionXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".copyLocalDirectionPart(?)#node" , "Copy local direction part" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".copyLocalDirectionPart(?)#dirScale" , "Direction scale" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".copyLocalDirectionPart(?)#upScale" , "Up vector scale" )

    Cylindered.registerDependentComponentJointXMLPaths(schema, basePath .. ".copyLocalDirectionPart(?)" )
end

```

### registerDependentAnimationXMLPaths

**Description**

**Definition**

> registerDependentAnimationXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Cylindered.registerDependentAnimationXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. ".dependentAnimation(?)#name" , "Dependent animation name" )
    schema:register(XMLValueType.INT, basePath .. ".dependentAnimation(?)#translationAxis" , "Translation axis" )
    schema:register(XMLValueType.INT, basePath .. ".dependentAnimation(?)#rotationAxis" , "Rotation axis" )
    schema:register(XMLValueType.INT, basePath .. ".dependentAnimation(?)#useTranslatingPartIndex" , "Use translation part index" )
    schema:register(XMLValueType.FLOAT, basePath .. ".dependentAnimation(?)#minValue" , "Min.reference value" )
    schema:register(XMLValueType.FLOAT, basePath .. ".dependentAnimation(?)#maxValue" , "Max.reference value" )
    schema:register(XMLValueType.BOOL, basePath .. ".dependentAnimation(?)#invert" , "Invert reference value" , false )
end

```

### registerDependentComponentJointXMLPaths

**Description**

**Definition**

> registerDependentComponentJointXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Cylindered.registerDependentComponentJointXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. ".componentJoint(?)#index" , "Dependent component joint index" )
    schema:register(XMLValueType.BOOL, basePath .. ".componentJoint(?)#ignoreWarning" , "Ignore if the index could not be found(due to configurations for example)" , false )
        schema:register(XMLValueType.INT, basePath .. ".componentJoint(?)#anchorActor" , "Dependent component anchor actor" )
    end

```

### registerDependentMovingToolXMLPaths

**Description**

**Definition**

> registerDependentMovingToolXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function Cylindered.registerDependentMovingToolXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".dependentMovingTool(?)#node" , "Dependent part" )
    schema:register(XMLValueType.INT, basePath .. ".dependentMovingTool(?)#axis" , "Rotation axis of the moving part which is used as reference in the rotationBasedLimits" , 1 )
    schema:register(XMLValueType.FLOAT, basePath .. ".dependentMovingTool(?)#speedScale" , "Speed scale" )
    schema:register(XMLValueType.BOOL, basePath .. ".dependentMovingTool(?)#requiresMovement" , "Requires movement" , false )
    schema:register(XMLValueType.ANGLE, basePath .. ".dependentMovingTool(?).rotationBasedLimits.limit(?)#rotation" , "Rotation" )
    schema:register(XMLValueType.ANGLE, basePath .. ".dependentMovingTool(?).rotationBasedLimits.limit(?)#rotMin" , "Min.rotation" )
    schema:register(XMLValueType.ANGLE, basePath .. ".dependentMovingTool(?).rotationBasedLimits.limit(?)#rotMax" , "Max.rotation" )
    schema:register(XMLValueType.FLOAT, basePath .. ".dependentMovingTool(?).rotationBasedLimits.limit(?)#transMin" , "Min.translation" )
    schema:register(XMLValueType.FLOAT, basePath .. ".dependentMovingTool(?).rotationBasedLimits.limit(?)#transMax" , "Max.translation" )
    schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".dependentMovingTool(?)#minTransLimits" , "Min.translation limits" )
    schema:register(XMLValueType.VECTOR_ 2 , basePath .. ".dependentMovingTool(?)#maxTransLimits" , "Max.translation limits" )
    schema:register(XMLValueType.VECTOR_ROT_ 2 , basePath .. ".dependentMovingTool(?)#minRotLimits" , "Min.rotation limits" )
    schema:register(XMLValueType.VECTOR_ROT_ 2 , basePath .. ".dependentMovingTool(?)#maxRotLimits" , "Max.rotation limits" )
end

```

### registerEasyArmControlXMLPaths

**Description**

**Definition**

> registerEasyArmControlXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function Cylindered.registerEasyArmControlXMLPaths(schema, key)
    schema:register(XMLValueType.NODE_INDEX, key .. "#rootNode" , "Root node" )
    schema:register(XMLValueType.NODE_INDEX, key .. "#node" , "Node" )
    schema:register(XMLValueType.NODE_INDEX, key .. "#targetNodeZ" , "Z target node" )
    schema:register(XMLValueType.NODE_INDEX, key .. "#refNode" , "Reference node" )
    schema:register(XMLValueType.FLOAT, key .. "#maxTotalDistance" , "Max.total distance the arms can move from rootNode" , "automatically calculated" )
    schema:register(XMLValueType.FLOAT, key .. ".targetMovement#speed" , "Target node move speed" , 1 )
    schema:register(XMLValueType.FLOAT, key .. ".targetMovement#acceleration" , "Target node move acceleration" , 50 )
    schema:register(XMLValueType.FLOAT, key .. ".zTranslationNodes#minMoveRatio" , "Min.ratio between translation and rotation movement [0:only rotation, 1:only translation]" , 0.2 )
    schema:register(XMLValueType.FLOAT, key .. ".zTranslationNodes#maxMoveRatio" , "Max.ratio between translation and rotation movement [0:only rotation, 1:only translation]" , 0.8 )
    schema:register(XMLValueType.FLOAT, key .. ".zTranslationNodes#moveRatioMinDir" , "Defines direction value when the translation parts start to move" , 0.0 )
    schema:register(XMLValueType.FLOAT, key .. ".zTranslationNodes#moveRatioMaxDir" , "Defines direction value when the rotation parts stop to move" , 1.0 )
    schema:register(XMLValueType.BOOL, key .. ".zTranslationNodes#allowNegativeTrans" , "Allow translation movement if translation parts are pointing towards the root node" , false )
        schema:register(XMLValueType.FLOAT, key .. ".zTranslationNodes#minNegativeTrans" , "Min.translation percentage when moving the translation parts into negative direction while they are pointing towards the root node" , 0 )
            schema:register(XMLValueType.NODE_INDEX, key .. ".zTranslationNodes.zTranslationNode(?)#node" , "Z translation node" )
            schema:register(XMLValueType.NODE_INDEX, key .. ".xRotationNodes.xRotationNode1#node" , "X translation node" )
            schema:register(XMLValueType.NODE_INDEX, key .. ".xRotationNodes.xRotationNode2#node" , "X translation node" )
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
function Cylindered.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterDashboardValueTypes" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateEnd" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onPostUpdate" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onPostUpdateTick" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onSelect" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onUnselect" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onDeactivate" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onAnimationPartChanged" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementStart" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onVehicleSettingChanged" , Cylindered )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterAnimationValueTypes" , Cylindered )
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
function Cylindered.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onMovingToolChanged" )
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
function Cylindered.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadMovingPartsFromXML" , Cylindered.loadMovingPartsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadMovingPartFromXML" , Cylindered.loadMovingPartFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadMovingToolsFromXML" , Cylindered.loadMovingToolsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadMovingToolFromXML" , Cylindered.loadMovingToolFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentMovingTools" , Cylindered.loadDependentMovingTools)
    SpecializationUtil.registerFunction(vehicleType, "loadEasyArmControlFromXML" , Cylindered.loadEasyArmControlFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentParts" , Cylindered.loadDependentParts)
    SpecializationUtil.registerFunction(vehicleType, "resolveDependentPartData" , Cylindered.resolveDependentPartData)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentComponentJoints" , Cylindered.loadDependentComponentJoints)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentAttacherJoints" , Cylindered.loadDependentAttacherJoints)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentWheels" , Cylindered.loadDependentWheels)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentTranslatingParts" , Cylindered.loadDependentTranslatingParts)
    SpecializationUtil.registerFunction(vehicleType, "loadExtraDependentParts" , Cylindered.loadExtraDependentParts)
    SpecializationUtil.registerFunction(vehicleType, "loadDependentAnimations" , Cylindered.loadDependentAnimations)
    SpecializationUtil.registerFunction(vehicleType, "loadCopyLocalDirectionParts" , Cylindered.loadCopyLocalDirectionParts)
    SpecializationUtil.registerFunction(vehicleType, "loadRotationBasedLimits" , Cylindered.loadRotationBasedLimits)
    SpecializationUtil.registerFunction(vehicleType, "loadActionSoundsFromXML" , Cylindered.loadActionSoundsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "checkMovingPartDirtyUpdateNode" , Cylindered.checkMovingPartDirtyUpdateNode)
    SpecializationUtil.registerFunction(vehicleType, "updateDirtyMovingParts" , Cylindered.updateDirtyMovingParts)
    SpecializationUtil.registerFunction(vehicleType, "setMovingToolDirty" , Cylindered.setMovingToolDirty)
    SpecializationUtil.registerFunction(vehicleType, "setMovingPartReferenceNode" , Cylindered.setMovingPartReferenceNode)
    SpecializationUtil.registerFunction(vehicleType, "updateMovingPartByNode" , Cylindered.updateMovingPartByNode)
    SpecializationUtil.registerFunction(vehicleType, "updateCylinderedInitial" , Cylindered.updateCylinderedInitial)
    SpecializationUtil.registerFunction(vehicleType, "allowLoadMovingToolStates" , Cylindered.allowLoadMovingToolStates)
    SpecializationUtil.registerFunction(vehicleType, "getMovingToolByNode" , Cylindered.getMovingToolByNode)
    SpecializationUtil.registerFunction(vehicleType, "getMovingPartByNode" , Cylindered.getMovingPartByNode)
    SpecializationUtil.registerFunction(vehicleType, "getTranslatingPartByNode" , Cylindered.getTranslatingPartByNode)
    SpecializationUtil.registerFunction(vehicleType, "getIsMovingToolActive" , Cylindered.getIsMovingToolActive)
    SpecializationUtil.registerFunction(vehicleType, "getIsMovingPartActive" , Cylindered.getIsMovingPartActive)
    SpecializationUtil.registerFunction(vehicleType, "getMovingToolMoveValue" , Cylindered.getMovingToolMoveValue)
    SpecializationUtil.registerFunction(vehicleType, "setDelayedData" , Cylindered.setDelayedData)
    SpecializationUtil.registerFunction(vehicleType, "updateDelayedTool" , Cylindered.updateDelayedTool)
    SpecializationUtil.registerFunction(vehicleType, "updateEasyControl" , Cylindered.updateEasyControl)
    SpecializationUtil.registerFunction(vehicleType, "setIsEasyControlActive" , Cylindered.setIsEasyControlActive)
    SpecializationUtil.registerFunction(vehicleType, "setEasyControlForcedTransMove" , Cylindered.setEasyControlForcedTransMove)
    SpecializationUtil.registerFunction(vehicleType, "updateExtraDependentParts" , Cylindered.updateExtraDependentParts)
    SpecializationUtil.registerFunction(vehicleType, "updateDependentAnimations" , Cylindered.updateDependentAnimations)
    SpecializationUtil.registerFunction(vehicleType, "updateDependentToolLimits" , Cylindered.updateDependentToolLimits)
    SpecializationUtil.registerFunction(vehicleType, "onMovingPartSoundEvent" , Cylindered.onMovingPartSoundEvent)
    SpecializationUtil.registerFunction(vehicleType, "updateMovingToolSoundEvents" , Cylindered.updateMovingToolSoundEvents)
    SpecializationUtil.registerFunction(vehicleType, "updateControlGroups" , Cylindered.updateControlGroups)
end

```

### registerMovingPartXMLPaths

**Description**

**Definition**

> registerMovingPartXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | partKey |

**Code**

```lua
function Cylindered.registerMovingPartXMLPaths(schema, partKey)
    schema:addDelayedRegistrationPath(partKey, "Cylindered:movingPart" )

    schema:register(XMLValueType.NODE_INDEX, partKey .. "#node" , "Node" )
    schema:register(XMLValueType.NODE_INDEX, partKey .. "#referenceFrame" , "Reference frame" )
    schema:register(XMLValueType.NODE_INDEX, partKey .. "#referencePoint" , "Reference point" )
    schema:register(XMLValueType.NODE_INDICES, partKey .. "#referencePoints" , "List of reference points(average position will be used as reference)" )

    schema:register(XMLValueType.BOOL, partKey .. "#invertZ" , "Invert Z axis" , false )
    schema:register(XMLValueType.BOOL, partKey .. "#scaleZ" , "Allow Z axis scaling" , false )
    schema:register(XMLValueType.INT, partKey .. "#limitedAxis" , "Limited axis" )
    schema:register(XMLValueType.BOOL, partKey .. "#isActiveDirty" , "Part is permanently updated" , false )
    schema:register(XMLValueType.BOOL, partKey .. "#playSound" , "Play hydraulic sound" , false )
    schema:register(XMLValueType.BOOL, partKey .. "#moveToReferenceFrame" , "Move to reference frame" , false )
    schema:register(XMLValueType.BOOL, partKey .. "#doLineAlignment" , "Do line alignment(line as ref point)" , false )
    schema:register(XMLValueType.BOOL, partKey .. "#doInversedLineAlignment" , "Do inversed line alignment(line inside part and fixed ref point)" , false )
    schema:register(XMLValueType.BOOL, partKey .. "#do3DLineAlignment" , "Do 3D line alignment(X and Y rotation is aligned to the given line - line is only allowed to have two points!)" , false )
    schema:register(XMLValueType.FLOAT, partKey .. ".orientationLine#partLength" , "Part length(Distance from part to line)" , 0.5 )
    schema:register(XMLValueType.NODE_INDEX, partKey .. ".orientationLine#referenceTransNode" , "Node that is moved to the current line position and at the same time is used a referencePoint for the directional alignment of the movingPart" )
        schema:register(XMLValueType.NODE_INDEX, partKey .. ".orientationLine#partLengthNode" , "Node to measure the part length dynamically" )
        schema:register(XMLValueType.NODE_INDEX, partKey .. ".orientationLine.lineNode(?)#node" , "Line node" )

        schema:register(XMLValueType.BOOL, partKey .. "#doDirectionAlignment" , "Do direction alignment" , true )
        schema:register(XMLValueType.BOOL, partKey .. "#doRotationAlignment" , "Do rotation alignment" , false )
        schema:register(XMLValueType.FLOAT, partKey .. "#rotMultiplier" , "Rotation multiplier for rotation alignment" , 0 )

            schema:register(XMLValueType.ANGLE, partKey .. "#minRot" , "Min.rotation for limited axis" )
                schema:register(XMLValueType.ANGLE, partKey .. "#maxRot" , "Max.rotation for limited axis" )

                    schema:register(XMLValueType.BOOL, partKey .. "#alignToWorldY" , "Align part to world Y axis" , false )
                    schema:register(XMLValueType.NODE_INDEX, partKey .. "#localReferencePoint" , "Local reference point" )
                    schema:register(XMLValueType.NODE_INDEX, partKey .. "#referenceDistancePoint" , "Z translation will be used as reference distance" )
                    schema:register(XMLValueType.FLOAT, partKey .. "#referenceDistance" , "Reference distance to be used instead of the current distance in the i3d(distance between node and ref point - or local ref point and ref point)" )
                    schema:register(XMLValueType.FLOAT, partKey .. "#localReferenceDistance" , "Predefined reference distance" , "calculated automatically" )
                    schema:register(XMLValueType.BOOL, partKey .. "#updateLocalReferenceDistance" , "Update distance to local reference point" , false )
                    schema:register(XMLValueType.BOOL, partKey .. "#dynamicLocalReferenceDistance" , "Local reference distance will be calculated based on the initial distance and the localReferencePoint direction" , false )
                    schema:register(XMLValueType.BOOL, partKey .. "#localReferenceTranslate" , "Translate to local reference node" , false )
                    schema:register(XMLValueType.FLOAT, partKey .. "#referenceDistanceThreshold" , "Distance threshold to update moving part while isActiveDirty" , 0.0001 )
                        schema:register(XMLValueType.BOOL, partKey .. "#useLocalOffset" , "Use local offset" , false )
                        schema:register(XMLValueType.FLOAT, partKey .. "#referencePointOffset" , "Offset to the reference point in Y alignment" )
                        schema:register(XMLValueType.FLOAT, partKey .. "#directionThreshold" , "Direction threshold to update part if vehicle is inactive" , 0.0001 )
                            schema:register(XMLValueType.FLOAT, partKey .. "#directionThresholdActive" , "Direction threshold to update part if vehicle is inactive" , 0.0001 )
                                schema:register(XMLValueType.STRING, partKey .. "#maxUpdateDistance" , "Max.distance to vehicle root while isActiveDirty is set('-' means unlimited)" )

                                    schema:register(XMLValueType.BOOL, partKey .. "#smoothedDirectionScale" , "If moving part is deactivated e.g.due to folding limits the direction is slowly interpolated back to the start direction depending on #smoothedDirectionTime" , false )
                                    schema:register(XMLValueType.TIME, partKey .. "#smoothedDirectionTime" , "Defines how low it takes until the part is back in original direction(sec.)" , 2 )

                                    schema:register(XMLValueType.BOOL, partKey .. "#debug" , "Enables debug rendering for this part" , false )

                                        schema:register(XMLValueType.NODE_INDEX, partKey .. ".dependentPart(?)#node" , "Dependent part" )
                                        schema:register(XMLValueType.STRING, partKey .. ".dependentPart(?)#maxUpdateDistance" , "Max.distance to vehicle root to update dependent part('-' means unlimited)" , "-" )

                                        schema:register(XMLValueType.BOOL, partKey .. "#divideTranslatingDistance" , "If true all translating parts will move at the same time.If false they start to move in the order from the xml" , true )

                                        schema:register(XMLValueType.NODE_INDEX, partKey .. ".translatingPart(?)#node" , "Translating part" )
                                        schema:register(XMLValueType.FLOAT, partKey .. ".translatingPart(?)#referenceDistance" , "Reference distance" )
                                        schema:register(XMLValueType.FLOAT, partKey .. ".translatingPart(?)#minZTrans" , "Min.Z Translation" )
                                        schema:register(XMLValueType.FLOAT, partKey .. ".translatingPart(?)#maxZTrans" , "Max.Z Translation" )
                                        schema:register(XMLValueType.BOOL, partKey .. ".translatingPart(?)#divideTranslatingDistance" , "Define individual division per translating part.E.g.one part is extending without division and two other parts extend afterwards at the same speed." , "movingPart#divideTranslatingDistance" )

                                        schema:register(XMLValueType.VECTOR_N, partKey .. "#wheelIndices" , "List of wheel indices to update" )
                                        schema:register(XMLValueType.STRING, partKey .. "#wheelNodes" , "List of wheel nodes to update" )
                                        schema:register(XMLValueType.BOOL, partKey .. ".inputAttacherJoint#value" , "Update input attacher joint" )
                                        schema:register(XMLValueType.VECTOR_N, partKey .. ".attacherJoint#jointIndices" , "List of attacher joints to update" )
                                        schema:register(XMLValueType.BOOL, partKey .. ".attacherJoint#ignoreWarning" , "No warning is printed if the joint index is not available(due to configurations)" , false )

                                            Cylindered.registerDependentComponentJointXMLPaths(schema, partKey)
                                            Cylindered.registerCopyLocalDirectionXMLPaths(schema, partKey)
                                            Cylindered.registerDependentAnimationXMLPaths(schema, partKey)
                                            Cylindered.registerDependentMovingToolXMLPaths(schema, partKey)
                                        end

```

### registerMovingToolXMLPaths

**Description**

**Definition**

> registerMovingToolXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | toolKey |

**Code**

```lua
function Cylindered.registerMovingToolXMLPaths(schema, toolKey)
    schema:addDelayedRegistrationPath(toolKey, "Cylindered:movingTool" )

    schema:register(XMLValueType.NODE_INDEX, toolKey .. "#node" , "Node" )
    schema:register(XMLValueType.BOOL, toolKey .. "#isEasyControlTarget" , "Is easy control target" , false )

    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#rotSpeed" , "Rotation speed" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#rotAcceleration" , "Rotation acceleration" )
    schema:register(XMLValueType.INT, toolKey .. ".rotation#rotationAxis" , "Rotation axis" , 1 )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#rotMax" , "Max.rotation" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#rotMin" , "Min.rotation" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#startRot" , "Start rotation" )
    schema:register(XMLValueType.BOOL, toolKey .. ".rotation#syncMaxRotLimits" , "Synchronize max.rotation limits" , false )
    schema:register(XMLValueType.BOOL, toolKey .. ".rotation#syncMinRotLimits" , "Synchronize min.rotation limits" , false )
    schema:register(XMLValueType.INT, toolKey .. ".rotation#rotSendNumBits" , "Number of bits to synchronize" , "automatically calculated by rotation range" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#attachRotMax" , "Max.rotation value set during attach" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#attachRotMin" , "Min.rotation value set during attach" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#detachingRotMaxLimit" , "Max.rotation to detach vehicle" )
    schema:register(XMLValueType.ANGLE, toolKey .. ".rotation#detachingRotMinLimit" , "Min.rotation to detach vehicle" )

    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#transSpeed" , "Translation speed" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#transAcceleration" , "Translation acceleration" )
    schema:register(XMLValueType.INT, toolKey .. ".translation#translationAxis" , "Translation axis" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#transMax" , "Max.translation" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#transMin" , "Min.translation" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#startTrans" , "Start translation" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#attachTransMax" , "Max.translation value set during attach" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#attachTransMin" , "Min.translation value set during attach" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#detachingTransMaxLimit" , "Max.translation to detach vehicle" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".translation#detachingTransMinLimit" , "Min.translation to detach vehicle" )

    schema:register(XMLValueType.STRING, toolKey .. "#requiredConfigurationName" , "Name of configuration that is required to use this moving tool" )
    schema:register(XMLValueType.VECTOR_N, toolKey .. "#requiredConfigurationIndices" , "List of configuration indices that are required to use this moving tool" )

    schema:register(XMLValueType.BOOL, toolKey .. "#playSound" , "Play sound" , false )

    schema:register(XMLValueType.STRING, toolKey .. ".animation#animName" , "Animation name" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".animation#animSpeed" , "Animation speed" )
    schema:register(XMLValueType.FLOAT, toolKey .. ".animation#animAcceleration" , "Animation acceleration" )
    schema:register(XMLValueType.INT, toolKey .. ".animation#animSendNumBits" , "Number of bits to synchronize" , 8 )
    schema:register(XMLValueType.FLOAT, toolKey .. ".animation#animMaxTime" , "Animation max.time" , 1 )
    schema:register(XMLValueType.FLOAT, toolKey .. ".animation#animMinTime" , "Animation min.time" , 0 )
    schema:register(XMLValueType.FLOAT, toolKey .. ".animation#animStartTime" , "Animation start time" )

    schema:register(XMLValueType.STRING, toolKey .. ".controls#iconName" , "Icon identifier" )
    schema:registerAutoCompletionDataSource(toolKey .. ".controls#iconName" , "$dataS/axisIcons.xml" , "axisIcons.icon#name" )
    schema:register(XMLValueType.INT, toolKey .. ".controls#groupIndex" , "Control group index" , 0 )
    schema:register(XMLValueType.STRING, toolKey .. ".controls#axis" , "Input action name" )
    schema:register(XMLValueType.BOOL, toolKey .. ".controls#invertAxis" , "Invert input axis" , false )
    schema:register(XMLValueType.FLOAT, toolKey .. ".controls#mouseSpeedFactor" , "Mouse speed factor" , 1 )
    schema:register(XMLValueType.BOOL, toolKey .. "#allowSaving" , "Allow saving" , true )
    schema:register(XMLValueType.FLOAT, toolKey .. "#aiActivePosition" , "Position of the moving tool(trans, rot, anim) while the AI is active [0-1].Position will then be enforced when the AI starts to work." )

        schema:register(XMLValueType.BOOL, toolKey .. "#isIntitialDirty" , "Is initial dirty" , true )
        schema:register(XMLValueType.NODE_INDEX, toolKey .. "#delayedNode" , "Delayed node" )
        schema:register(XMLValueType.INT, toolKey .. "#delayedFrames" , "Delayed frames" , 3 )

        schema:register(XMLValueType.BOOL, toolKey .. "#isConsumingPower" , "While tool is moving the power consumer is set active" , false )

        schema:register(XMLValueType.NODE_INDEX, toolKey .. ".dependentPart(?)#node" , "Dependent part" )
        schema:register(XMLValueType.STRING, toolKey .. ".dependentPart(?)#maxUpdateDistance" , "Max.distance to vehicle root to update dependent part('-' means unlimited)" , "-" )

        schema:register(XMLValueType.VECTOR_N, toolKey .. "#wheelIndices" , "List of wheel indices to update" )
        schema:register(XMLValueType.STRING, toolKey .. "#wheelNodes" , "List of wheel nodes to update" )
        schema:register(XMLValueType.BOOL, toolKey .. ".inputAttacherJoint#value" , "Update input attacher joint" )
        schema:register(XMLValueType.VECTOR_N, toolKey .. ".attacherJoint#jointIndices" , "List of attacher joints to update" )
        schema:register(XMLValueType.BOOL, toolKey .. ".attacherJoint#ignoreWarning" , "No warning is printed if the joint index is not available(due to configurations)" , false )

            schema:register(XMLValueType.INT, toolKey .. "#fillUnitIndex" , "Fill unit index" )
            schema:register(XMLValueType.FLOAT, toolKey .. "#minFillLevel" , "Min.fill level" )
            schema:register(XMLValueType.FLOAT, toolKey .. "#maxFillLevel" , "Max.fill level" )

            schema:register(XMLValueType.FLOAT, toolKey .. "#foldMinLimit" , "Min.fold time" , 0 )
            schema:register(XMLValueType.FLOAT, toolKey .. "#foldMaxLimit" , "Max.fold time" , 1 )

            Cylindered.registerDependentComponentJointXMLPaths(schema, toolKey)
            Cylindered.registerDependentAnimationXMLPaths(schema, toolKey)
            Cylindered.registerDependentMovingToolXMLPaths(schema, toolKey)
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
function Cylindered.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "isDetachAllowed" , Cylindered.isDetachAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadObjectChangeValuesFromXML" , Cylindered.loadObjectChangeValuesFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setObjectChangeValues" , Cylindered.setObjectChangeValues)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadDischargeNode" , Cylindered.loadDischargeNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDischargeNodeEmptyFactor" , Cylindered.getDischargeNodeEmptyFactor)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadShovelNode" , Cylindered.loadShovelNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getShovelNodeIsActive" , Cylindered.getShovelNodeIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadDynamicMountGrabFromXML" , Cylindered.loadDynamicMountGrabFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsDynamicMountGrabOpened" , Cylindered.getIsDynamicMountGrabOpened)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setComponentJointFrame" , Cylindered.setComponentJointFrame)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAdditionalSchemaText" , Cylindered.getAdditionalSchemaText)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , Cylindered.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDoConsumePtoPower" , Cylindered.getDoConsumePtoPower)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , Cylindered.getConsumingLoad)
end

```

### registerSoundXMLPaths

**Description**

**Definition**

> registerSoundXMLPaths()

**Arguments**

| any | schema  |
|-----|---------|
| any | baseKey |

**Code**

```lua
function Cylindered.registerSoundXMLPaths(schema, baseKey)
    SoundManager.registerSampleXMLPaths(schema, baseKey, "hydraulic" )

    SoundManager.registerSampleXMLPaths(schema, baseKey, "actionSound(?)" )
    schema:register(XMLValueType.STRING, baseKey .. ".actionSound(?)#actionNames" , "Target actions on given nodes" )
    schema:register(XMLValueType.STRING, baseKey .. ".actionSound(?)#nodes" , "Nodes that can activate this sound on given action events" )
    schema:register(XMLValueType.FLOAT, baseKey .. ".actionSound(?).pitch#dropOffFactor" , "Factor that is applied to pitch while drop off time is active" , 1 )
        schema:register(XMLValueType.FLOAT, baseKey .. ".actionSound(?).pitch#dropOffTime" , "After this time the sound will be deactivated" , 0 )
    end

```

### resolveDependentPartData

**Description**

> Resolve loaded dependent part data into real moving parts and tools

**Definition**

> resolveDependentPartData(table dependentPartData, table referenceNodes)

**Arguments**

| table | dependentPartData | dependentPartData |
|-------|-------------------|-------------------|
| table | referenceNodes    | referenceNodes    |

**Code**

```lua
function Cylindered:resolveDependentPartData(dependentPartData, referenceNodes)
    for _, dependentPart in pairs(dependentPartData) do
        if dependentPart.part = = nil then
            if referenceNodes[dependentPart.node] ~ = nil then
                for j = 1 , #referenceNodes[dependentPart.node] do
                    local depPart = referenceNodes[dependentPart.node][j]
                    if j = = 1 then
                        dependentPart.part = depPart
                        depPart.isDependentPart = true
                    else
                            table.insert(dependentPartData, {
                            node = dependentPart.node,
                            maxUpdateDistance = dependentPart.maxUpdateDistance,
                            part = depPart,
                            } )

                            depPart.isDependentPart = true
                        end
                    end
                end
            end
        end

        for j = #dependentPartData, 1 , - 1 do
            local data = dependentPartData[j]
            if data.part = = nil then
                table.remove(dependentPartData, j)
            end
        end
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
function Cylindered:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_cylindered

    local index = 0
    for _, tool in ipairs(spec.movingTools) do
        if tool.saving then
            local toolKey = string.format( "%s.movingTool(%d)" , key, index)

            if tool.transSpeed ~ = nil then
                xmlFile:setValue(toolKey .. "#translation" , tool.curTrans[tool.translationAxis])
            end
            if tool.rotSpeed ~ = nil then
                xmlFile:setValue(toolKey .. "#rotation" , tool.curRot[tool.rotationAxis])
            end
            if tool.animSpeed ~ = nil then
                xmlFile:setValue(toolKey .. "#animationTime" , tool.curAnimTime)
            end

            index = index + 1
        end
    end
end

```

### setAbsoluteToolRotation

**Description**

> Set absolute tool rotation

**Definition**

> setAbsoluteToolRotation(table tool, float rotation, boolean updateDelayedNodes, )

**Arguments**

| table   | tool               | tool                 |
|---------|--------------------|----------------------|
| float   | rotation           | rotation             |
| boolean | updateDelayedNodes | update delayed nodes |
| any     | updateDelayedNodes |                      |

**Code**

```lua
function Cylindered.setAbsoluteToolRotation( self , tool, rotation, updateDelayedNodes)
    tool.curRot[ 1 ], tool.curRot[ 2 ], tool.curRot[ 3 ] = getRotation(tool.node)
    local oldRot = tool.curRot[tool.rotationAxis]
    if Cylindered.setToolRotation( self , tool, nil , 0 , rotation - oldRot) then
        Cylindered.setDirty( self , tool)

        if updateDelayedNodes ~ = nil and updateDelayedNodes then
            self:updateDelayedTool(tool)
        end

        self:raiseDirtyFlags(tool.dirtyFlag)
        self:raiseDirtyFlags( self.spec_cylindered.cylinderedDirtyFlag)
    end
end

```

### setAbsoluteToolTranslation

**Description**

> Set absolute tool translation

**Definition**

> setAbsoluteToolTranslation(table tool, float translation, )

**Arguments**

| table | tool        | tool        |
|-------|-------------|-------------|
| float | translation | translation |
| any   | translation |             |

**Code**

```lua
function Cylindered.setAbsoluteToolTranslation( self , tool, translation)
    tool.curTrans[ 1 ], tool.curTrans[ 2 ], tool.curTrans[ 3 ] = getTranslation(tool.node)
    local oldTrans = tool.curTrans[tool.translationAxis]
    if Cylindered.setToolTranslation( self , tool, nil , 0 , translation - oldTrans) then
        Cylindered.setDirty( self , tool)

        self:raiseDirtyFlags(tool.dirtyFlag)
        self:raiseDirtyFlags( self.spec_cylindered.cylinderedDirtyFlag)
    end
end

```

### setComponentJointFrame

**Description**

**Definition**

> setComponentJointFrame()

**Arguments**

| any | superFunc   |
|-----|-------------|
| any | jointDesc   |
| any | anchorActor |

**Code**

```lua
function Cylindered:setComponentJointFrame(superFunc, jointDesc, anchorActor)
    superFunc( self , jointDesc, anchorActor)

    -- update the joint to component offset
    local spec = self.spec_cylindered
    for _, movingTool in ipairs(spec.movingTools) do
        for _, componentJoint in ipairs(movingTool.componentJoints) do
            local componentJointDesc = self.componentJoints[componentJoint.index]

            local jointNode = componentJointDesc.jointNode
            if componentJoint.anchorActor = = 1 then
                jointNode = componentJointDesc.jointNodeActor1
            end

            local node = self.components[componentJointDesc.componentIndices[ 2 ]].node
            componentJoint.x, componentJoint.y, componentJoint.z = localToLocal(node, jointNode, 0 , 0 , 0 )
            componentJoint.upX, componentJoint.upY, componentJoint.upZ = localDirectionToLocal(node, jointNode, 0 , 1 , 0 )
            componentJoint.dirX, componentJoint.dirY, componentJoint.dirZ = localDirectionToLocal(node, jointNode, 0 , 0 , 1 )
        end
    end
end

```

### setDelayedData

**Description**

**Definition**

> setDelayedData()

**Arguments**

| any | tool      |
|-----|-----------|
| any | immediate |

**Code**

```lua
function Cylindered:setDelayedData(tool, immediate)
    local x, y, z = getTranslation(tool.node)
    local rx, ry, rz = getRotation(tool.node)

    tool.delayedHistroyData[tool.delayedFrames] = { rot = { rx, ry, rz } , trans = { x, y, z } }
    if immediate then
        for i = 1 , tool.delayedFrames - 1 do
            tool.delayedHistroyData[i] = tool.delayedHistroyData[tool.delayedFrames]
        end
    end

    tool.delayedHistoryIndex = tool.delayedFrames
end

```

### setDirty

**Description**

> Set dirty

**Definition**

> setDirty(table part, )

**Arguments**

| table | part | part to set dirty |
|-------|------|-------------------|
| any   | part |                   |

**Code**

```lua
function Cylindered.setDirty( self , part)
    if not part.isDirty or self.spec_cylindered.isLoading then -- during loading we always allow setting dirty since we do not reset it
        part.isDirty = true
        self.anyMovingPartsDirty = true

        if part.delayedNode ~ = nil then
            self:setDelayedData(part)
        end

        -- on moving tools we update the wheels and attacher joints on dirty since the are updated from external influences(e.g.animations)
        -- on moving parts the part is updated first and then the wheels and attacher joints are updated
        if part.isTool then
            Cylindered.updateAttacherJoints( self , part)
            Cylindered.updateWheels( self , part)
        end

        for _, data in pairs(part.dependentPartData) do
            if self.currentUpdateDistance < data.maxUpdateDistance then
                Cylindered.setDirty( self , data.part)
            end
        end
    end
end

```

### setEasyControlForcedTransMove

**Description**

**Definition**

> setEasyControlForcedTransMove()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function Cylindered:setEasyControlForcedTransMove(value)
    local spec = self.spec_cylindered
    local easyArmControl = spec.easyArmControl
    if easyArmControl ~ = nil then
        easyArmControl.forcedTransMove = value
    end
end

```

### setIsEasyControlActive

**Description**

**Definition**

> setIsEasyControlActive()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function Cylindered:setIsEasyControlActive(state)
    local spec = self.spec_cylindered
    local easyArmControl = spec.easyArmControl
    if easyArmControl ~ = nil then
        if self.isServer then
            if easyArmControl ~ = nil then
                local targetYTool = self:getMovingToolByNode(easyArmControl.targetNodeY)
                local targetZTool = self:getMovingToolByNode(easyArmControl.targetNodeZ)

                if state then
                    local origin = getParent(easyArmControl.targetNodeY)
                    if origin = = easyArmControl.targetNodeZ then
                        origin = getParent(easyArmControl.targetNodeZ)
                    end

                    local _, y, _ = localToLocal(easyArmControl.targetRefNode, origin, 0 , 0 , 0 )
                    local _, oldY, _ = getTranslation(easyArmControl.targetNodeY)
                    if Cylindered.setToolTranslation( self , targetYTool, nil , 0 , y - oldY) then
                        Cylindered.setDirty( self , targetYTool)
                    end

                    local z
                    _, _, z = localToLocal(easyArmControl.targetRefNode, origin, 0 , 0 , 0 )
                    local _, _, oldZ = getTranslation(easyArmControl.targetNodeZ)
                    if Cylindered.setToolTranslation( self , targetZTool, nil , 0 , z - oldZ) then
                        Cylindered.setDirty( self , targetZTool)
                    end

                    easyArmControl.lastValidPositionY[ 1 ], easyArmControl.lastValidPositionY[ 2 ], easyArmControl.lastValidPositionY[ 3 ] = getTranslation(easyArmControl.targetNodeY)
                    easyArmControl.lastValidPositionZ[ 1 ], easyArmControl.lastValidPositionZ[ 2 ], easyArmControl.lastValidPositionZ[ 3 ] = getTranslation(easyArmControl.targetNodeZ)

                    self:raiseDirtyFlags(spec.cylinderedDirtyFlag)
                end

                easyArmControl.state = state
            end
        else
                easyArmControl.state = state
            end
        end

        self:requestActionEventUpdate()
    end

```

### setMovingPartReferenceNode

**Description**

> Sets the reference point of a moving part to a defined node (if no reference node is given, it will be set to the
> value loaded from XML)

**Definition**

> setMovingPartReferenceNode(integer movingPartNode, integer referenceNode, )

**Arguments**

| integer | movingPartNode | node of moving part     |
|---------|----------------|-------------------------|
| integer | referenceNode  | node of reference point |
| any     | isActiveDirty  |                         |

**Code**

```lua
function Cylindered:setMovingPartReferenceNode(movingPartNode, referenceNode, isActiveDirty)
    local spec = self.spec_cylindered

    local movingPart = self:getMovingPartByNode(movingPartNode)
    if movingPart ~ = nil then
        if movingPart.referencePointOrig = = nil then
            movingPart.referencePointOrig = movingPart.referencePoint
        end

        if referenceNode ~ = movingPart.referencePoint and movingPart.smoothedDirectionScale then
            movingPart.smoothedDirectionScaleAlpha = 0

            local dx, dy, dz = localDirectionToLocal(movingPart.node, getParent(movingPart.node), 0 , 0 , 1 )
            movingPart.initialDirection[ 1 ], movingPart.initialDirection[ 2 ], movingPart.initialDirection[ 3 ] = dx, dy, dz

            if movingPart.hasReferencePoints then
                if movingPart.numTranslatingParts > 0 then
                    local refX, refY, refZ = getWorldTranslation(movingPart.referencePoint)

                    local _
                    _, _, movingPart.smoothedDirectionScaleZOffset = worldToLocal(movingPart.node, refX, refY, refZ)
                end
            end

            if not movingPart.isActiveDirty then
                table.addElement(spec.activeDirtyMovingParts, movingPart)
                movingPart.smoothedDirectionScaleTempDirty = true
            end
        end

        if referenceNode = = nil then
            movingPart.referencePoint = movingPart.referencePointOrig
        else
                movingPart.referencePoint = referenceNode
            end

            if isActiveDirty ~ = nil and not movingPart.smoothedDirectionScaleTempDirty then
                if isActiveDirty then
                    table.addElement(spec.activeDirtyMovingParts, movingPart)
                else
                        if not movingPart.isActiveDirty then
                            table.removeElement(spec.activeDirtyMovingParts, movingPart)
                        end
                    end
                end

                Cylindered.updateMovingPart( self , movingPart, false , true , true )
                self:updateExtraDependentParts(movingPart, 99999 )
                self:updateDependentAnimations(movingPart, 99999 )

                -- if any dependent parts use the same reference point in the xml, we update it as well
                    for _, data in pairs(movingPart.dependentPartData) do
                        if (data.part.referencePointOrig or data.part.referencePoint) = = movingPart.referencePointOrig then
                            self:setMovingPartReferenceNode(data.part.node, referenceNode, isActiveDirty)
                        end
                    end
                end
            end

```

### setMovingToolDirty

**Description**

> Set moving tool dirty

**Definition**

> setMovingToolDirty(integer node, boolean forceUpdate, float dt)

**Arguments**

| integer | node        | node id                                                   |
|---------|-------------|-----------------------------------------------------------|
| boolean | forceUpdate | force immediate update of moving tool and dependent parts |
| float   | dt          | time since last call (only if forceUpdate is set)         |

**Code**

```lua
function Cylindered:setMovingToolDirty(node, forceUpdate, dt)
    local spec = self.spec_cylindered

    local tool = spec.nodesToMovingTools[node]
    if tool ~ = nil then
        -- update curTrans and curRot values + moving tool action sounds
        if tool.transSpeed ~ = nil then
            local oldTrans = tool.curTrans[tool.translationAxis]
            tool.curTrans[ 1 ], tool.curTrans[ 2 ], tool.curTrans[ 3 ] = getTranslation(tool.node)
            local newTrans = tool.curTrans[tool.translationAxis]

            local diff = newTrans - oldTrans
            if math.abs(diff) > 0.0001 then
                self:updateMovingToolSoundEvents(tool, diff > 0 , math.abs(newTrans - (tool.transMax or math.huge)) < 0.0001 or math.abs(newTrans - (tool.transMin or math.huge)) < 0.0001 , math.abs(oldTrans - (tool.transMax or math.huge)) < 0.0001 or math.abs(oldTrans - (tool.transMin or math.huge)) < 0.0001 )
            end
        end

        if tool.rotSpeed ~ = nil then
            local oldRot = tool.curRot[tool.rotationAxis]
            tool.curRot[ 1 ], tool.curRot[ 2 ], tool.curRot[ 3 ] = getRotation(tool.node)
            local newRot = tool.curRot[tool.rotationAxis]

            local diff = newRot - oldRot
            if math.abs(diff) > 0.0001 then
                self:updateMovingToolSoundEvents(tool, diff > 0 , math.abs(newRot - (tool.rotMax or math.huge)) < 0.0001 or math.abs(newRot - (tool.rotMin or math.huge)) < 0.0001 , math.abs(oldRot - (tool.rotMax or math.huge)) < 0.0001 or math.abs(oldRot - (tool.rotMin or math.huge)) < 0.0001 )
            end
        end

        Cylindered.setDirty( self , tool)

        if not self.isServer and self.isClient then
            tool.networkInterpolators.translation:setValue(tool.curTrans[tool.translationAxis])
            tool.networkInterpolators.rotation:setAngle(tool.curRot[tool.rotationAxis])
        end

        if forceUpdate or( self.finishedFirstUpdate and not self.isActive) then
            self:updateDirtyMovingParts(dt or g_currentDt, true )
        end
    end
end

```

### setObjectChangeValues

**Description**

> Sets object change values

**Definition**

> setObjectChangeValues(table object, boolean isActive, )

**Arguments**

| table   | object   | object    |
|---------|----------|-----------|
| boolean | isActive | is active |
| any     | isActive |           |

**Code**

```lua
function Cylindered:setObjectChangeValues(superFunc, object, isActive)
    superFunc( self , object, isActive)

    local spec = self.spec_cylindered

    if spec.nodesToMovingTools ~ = nil and spec.nodesToMovingTools[object.node] ~ = nil then
        local movingTool = spec.nodesToMovingTools[object.node]
        if isActive then
            movingTool.rotMax = object.movingToolRotMaxActive
            movingTool.rotMin = object.movingToolRotMinActive
            movingTool.transMax = object.movingToolTransMaxActive
            movingTool.transMin = object.movingToolTransMinActive

            movingTool.startRot = object.movingToolStartRotActive or movingTool.startRot
            movingTool.startTrans = object.movingToolStartTransActive or movingTool.startTrans
        else
                movingTool.rotMax = object.movingToolRotMaxInactive
                movingTool.rotMin = object.movingToolRotMinInactive
                movingTool.transMax = object.movingToolTransMaxInactive
                movingTool.transMin = object.movingToolTransMinInactive

                movingTool.startRot = object.movingToolStartRotInactive or movingTool.startRot
                movingTool.startTrans = object.movingToolStartTransInactive or movingTool.startTrans
            end
        end
    end

```

### setToolAnimation

**Description**

> Set tool animation

**Definition**

> setToolAnimation(table tool, float animSpeed, float dt, )

**Arguments**

| table | tool      | tool                       |
|-------|-----------|----------------------------|
| float | animSpeed | animation speed            |
| float | dt        | time since last call in ms |
| any   | dt        |                            |

**Return Values**

| any | changed | animation changed |
|-----|---------|-------------------|

**Code**

```lua
function Cylindered.setToolAnimation( self , tool, animSpeed, dt)
    local curAnimTime = self:getAnimationTime(tool.animName)
    if math.abs(curAnimTime - tool.curAnimTime) > 0.001 then
        tool.networkInterpolators.resetAnimInterpolation = true
    end

    tool.curAnimTime = curAnimTime

    local newAnimTime = tool.curAnimTime + animSpeed * dt
    local oldAnimTime = tool.curAnimTime

    if tool.animMaxTime ~ = nil then
        newAnimTime = math.min(newAnimTime, tool.animMaxTime)
    end
    if tool.animMinTime ~ = nil then
        newAnimTime = math.max(newAnimTime, tool.animMinTime)
    end
    local diff = newAnimTime - tool.curAnimTime
    if dt ~ = 0 then
        tool.lastAnimSpeed = diff / dt
    end
    if math.abs(diff) > 0.0001 then
        tool.curAnimTime = newAnimTime
        self:setAnimationTime(tool.animName, newAnimTime, nil , true )

        self:updateMovingToolSoundEvents(tool, diff > 0 , newAnimTime = = tool.animMaxTime or newAnimTime = = tool.animMinTime or newAnimTime = = 0 or newAnimTime = = 1 , oldAnimTime = = tool.animMaxTime or oldAnimTime = = tool.animMinTime or oldAnimTime = = 0 or oldAnimTime = = 1 )

        SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, animSpeed, dt)
        return true
    end

    return false
end

```

### setToolRotation

**Description**

> Set tool rotation

**Definition**

> setToolRotation(table tool, float rotSpeed, float dt, float delta, )

**Arguments**

| table | tool     | tool                       |
|-------|----------|----------------------------|
| float | rotSpeed | rotation speed             |
| float | dt       | time since last call in ms |
| float | delta    | delta rotation             |
| any   | delta    |                            |

**Return Values**

| any | changed | rotation changed |
|-----|---------|------------------|

**Code**

```lua
function Cylindered.setToolRotation( self , tool, rotSpeed, dt, delta)
    --#debug if VehicleDebug.cylinderedUpdateDebugState and self:getIsActiveForInput() then
        --#debug DebugGizmo.renderAtNode(tool.node, "Tool: " .. getName(tool.node), true)
        --#debug end

        tool.curRot[ 1 ], tool.curRot[ 2 ], tool.curRot[ 3 ] = getRotation(tool.node)
        local newRot = tool.curRot[tool.rotationAxis]
        local oldRot = newRot
        if rotSpeed ~ = nil then
            newRot = newRot + rotSpeed * dt
        else
                newRot = newRot + delta
            end
            if tool.rotMax ~ = nil then
                newRot = math.min(newRot, tool.rotMax)
            end
            if tool.rotMin ~ = nil then
                newRot = math.max(newRot, tool.rotMin)
            end
            local diff = newRot - tool.curRot[tool.rotationAxis]
            if rotSpeed ~ = nil then
                if dt ~ = 0 then
                    tool.lastRotSpeed = diff / dt
                end
            end

            if math.abs(diff) > 0.0001 then
                -- wrap if not limited
                    if tool.rotMin = = nil and tool.rotMax = = nil then
                        if newRot > 2 * math.pi then
                            newRot = newRot - 2 * math.pi
                        end
                        if newRot < 0 then
                            newRot = newRot + 2 * math.pi
                        end
                    end
                    tool.curRot[tool.rotationAxis] = newRot
                    setRotation(tool.node, tool.curRot[ 1 ], tool.curRot[ 2 ], tool.curRot[ 3 ])

                    self:updateMovingToolSoundEvents(tool, diff > 0 , newRot = = tool.rotMax or newRot = = tool.rotMin, oldRot = = tool.rotMax or oldRot = = tool.rotMin)

                    SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, rotSpeed, dt)

                    return true
                end

                return false
            end

```

### setToolTranslation

**Description**

> Set tool translation

**Definition**

> setToolTranslation(table tool, float transSpeed, float dt, , )

**Arguments**

| table | tool       | tool                       |
|-------|------------|----------------------------|
| float | transSpeed | translation speed          |
| float | dt         | time since last call in ms |
| any   | dt         |                            |
| any   | delta      |                            |

**Return Values**

| any | changed | translation changed |
|-----|---------|---------------------|

**Code**

```lua
function Cylindered.setToolTranslation( self , tool, transSpeed, dt, delta)
    --#debug if VehicleDebug.cylinderedUpdateDebugState and self:getIsActiveForInput() then
        --#debug DebugGizmo.renderAtNode(tool.node, "Tool: " .. getName(tool.node), true)
        --#debug end

        tool.curTrans[ 1 ], tool.curTrans[ 2 ], tool.curTrans[ 3 ] = getTranslation(tool.node)
        local newTrans = tool.curTrans[tool.translationAxis]
        local oldTrans = newTrans
        if transSpeed ~ = nil then
            newTrans = newTrans + transSpeed * dt
        else
                newTrans = newTrans + delta
            end
            if tool.transMax ~ = nil then
                newTrans = math.min(newTrans, tool.transMax)
            end
            if tool.transMin ~ = nil then
                newTrans = math.max(newTrans, tool.transMin)
            end
            local diff = newTrans - oldTrans
            if dt ~ = 0 then
                tool.lastTransSpeed = diff / dt
            end
            if math.abs(diff) > 0.0001 then
                tool.curTrans[tool.translationAxis] = newTrans
                setTranslation(tool.node, tool.curTrans[ 1 ], tool.curTrans[ 2 ], tool.curTrans[ 3 ])

                self:updateMovingToolSoundEvents(tool, diff > 0 , newTrans = = tool.transMax or newTrans = = tool.transMin, oldTrans = = tool.transMax or oldTrans = = tool.transMin)

                SpecializationUtil.raiseEvent( self , "onMovingToolChanged" , tool, transSpeed, dt)

                return true
            end

            return false
        end

```

### updateAttacherJoints

**Description**

> Update attacher joints

**Definition**

> updateAttacherJoints(table entry, )

**Arguments**

| table | entry | entry |
|-------|-------|-------|
| any   | entry |       |

**Code**

```lua
function Cylindered.updateAttacherJoints( self , entry)
    if self.isServer then
        if entry.attacherJoints ~ = nil then
            for _,joint in ipairs(entry.attacherJoints) do
                if joint.jointIndex ~ = 0 then
                    setJointFrame(joint.jointIndex, 0 , joint.jointTransform)
                end
            end
        end

        if entry.inputAttacherJoint then
            if self.getAttacherVehicle ~ = nil then
                local attacherVehicle = self:getAttacherVehicle()
                if attacherVehicle ~ = nil then

                    local attacherJoints = attacherVehicle:getAttacherJoints()
                    if attacherJoints ~ = nil then

                        local jointDescIndex = attacherVehicle:getAttacherJointIndexFromObject( self )
                        if jointDescIndex ~ = nil then
                            local jointDesc = attacherJoints[jointDescIndex]

                            local inputAttacherJoint = self:getActiveInputAttacherJoint()
                            if inputAttacherJoint ~ = nil then
                                local xNew = jointDesc.jointOrigTrans[ 1 ] + jointDesc.jointPositionOffset[ 1 ]
                                local yNew = jointDesc.jointOrigTrans[ 2 ] + jointDesc.jointPositionOffset[ 2 ]
                                local zNew = jointDesc.jointOrigTrans[ 3 ] + jointDesc.jointPositionOffset[ 3 ]

                                -- transform offset position to world coord and to jointTransform coord to get position offset dependend on angle and position
                                local ox, oy, oz = getTranslation(jointDesc.jointTransform)
                                setTranslation(jointDesc.jointTransform, unpack(jointDesc.jointOrigTrans))
                                local x, y, z = localToWorld(getParent(jointDesc.jointTransform), xNew, yNew, zNew)
                                local x1, y1, z1 = worldToLocal(jointDesc.jointTransform, x, y, z)
                                setTranslation(jointDesc.jointTransform, ox, oy, oz)

                                -- transform it to implement position and angle
                                x, y, z = localToWorld(inputAttacherJoint.node, x1, y1, z1)
                                local x2, y2, z2 = worldToLocal(getParent(inputAttacherJoint.node), x, y, z)
                                setTranslation(inputAttacherJoint.node, x2, y2, z2)

                                setJointFrame(jointDesc.jointIndex, 1 , inputAttacherJoint.node)

                                setTranslation(inputAttacherJoint.node, unpack(inputAttacherJoint.jointOrigTrans))
                            end
                        end
                    end
                end
            end
        end
    end
end

```

### updateComponentJoints

**Description**

> Update component joints

**Definition**

> updateComponentJoints(table entry, boolean placeComponents, )

**Arguments**

| table   | entry           | entry            |
|---------|-----------------|------------------|
| boolean | placeComponents | place components |
| any     | placeComponents |                  |

**Code**

```lua
function Cylindered.updateComponentJoints( self , entry, placeComponents)
    if self.isServer then
        if entry.componentJoints ~ = nil then
            for _,joint in ipairs(entry.componentJoints) do
                local componentJoint = joint.componentJoint

                local jointNode = componentJoint.jointNode
                if joint.anchorActor = = 1 then
                    jointNode = componentJoint.jointNodeActor1
                end

                if placeComponents then
                    local node = self.components[componentJoint.componentIndices[ 2 ]].node
                    local x,y,z = localToWorld(jointNode, joint.x, joint.y, joint.z)
                    local upX,upY,upZ = localDirectionToWorld(jointNode, joint.upX,joint.upY,joint.upZ)
                    local dirX,dirY,dirZ = localDirectionToWorld(jointNode, joint.dirX,joint.dirY,joint.dirZ)
                    setWorldTranslation(node, x,y,z)
                    I3DUtil.setWorldDirection(node, dirX,dirY,dirZ, upX,upY,upZ)
                end

                self:setComponentJointFrame(componentJoint, joint.anchorActor)
            end
        end
    end
end

```

### updateControlGroups

**Description**

**Definition**

> updateControlGroups()

**Code**

```lua
function Cylindered:updateControlGroups()
    local spec = self.spec_cylindered

    self:clearSubselections()
    for k, _ in pairs(spec.controlGroupMapping) do
        spec.controlGroupMapping[k] = nil
    end

    for _, groupIndex in ipairs(spec.controlGroups) do
        local isActive = false
        for _, movingTool in pairs(spec.movingTools) do
            if movingTool.axisActionIndex ~ = nil and movingTool.controlGroupIndex = = groupIndex then
                if movingTool.lastIsActiveState then
                    isActive = true
                    break
                end
            end
        end

        if isActive then
            local subSelectionIndex = self:addSubselection(groupIndex)
            spec.controlGroupMapping[subSelectionIndex] = groupIndex
        end
    end

    self.rootVehicle:updateSelectableObjects()
    local vehicle = self.rootVehicle:getSelectedVehicle()
    if vehicle = = self then
        self.rootVehicle:setSelectedVehicle( self , 99999 , false )
    end
end

```

### updateCylinderedInitial

**Description**

> Initial update of cylindered

**Definition**

> updateCylinderedInitial(boolean placeComponents, )

**Arguments**

| boolean | placeComponents | place components |
|---------|-----------------|------------------|
| any     | keepDirty       |                  |

**Code**

```lua
function Cylindered:updateCylinderedInitial(placeComponents, keepDirty)
    if placeComponents = = nil then
        placeComponents = true
    end

    if keepDirty = = nil then
        keepDirty = false
    end

    local spec = self.spec_cylindered

    for _, part in pairs(spec.activeDirtyMovingParts) do
        Cylindered.setDirty( self , part)
    end

    for _, tool in ipairs(spec.movingTools) do
        if tool.isDirty then
            Cylindered.updateWheels( self , tool)
            if self.isServer then
                Cylindered.updateComponentJoints( self , tool, placeComponents)
            end
            tool.isDirty = false or keepDirty
        end

        self:updateExtraDependentParts(tool, 9999 )
        self:updateDependentAnimations(tool, 9999 )
    end

    for _, part in ipairs(spec.movingParts) do
        local isActive = self:getIsMovingPartActive(part)
        if isActive or part.smoothedDirectionScale and part.smoothedDirectionScaleAlpha ~ = 0 then
            if part.isDirty then
                Cylindered.updateMovingPart( self , part, placeComponents, nil , isActive, false )
                Cylindered.updateWheels( self , part)
                part.isDirty = false or keepDirty
            end

            self:updateExtraDependentParts(part, 9999 )
            self:updateDependentAnimations(part, 9999 )
        end
    end
end

```

### updateDelayedTool

**Description**

**Definition**

> updateDelayedTool()

**Arguments**

| any | tool              |
|-----|-------------------|
| any | forceLastPosition |

**Code**

```lua
function Cylindered:updateDelayedTool(tool, forceLastPosition)
    local spec = self.spec_cylindered

    if forceLastPosition ~ = nil and forceLastPosition then
        for i = 1 , tool.delayedFrames - 1 do
            tool.delayedHistroyData[i] = tool.delayedHistroyData[tool.delayedFrames]
        end
    end

    local currentData = tool.delayedHistroyData[ 1 ]
    for i = 1 , tool.delayedFrames - 1 do
        tool.delayedHistroyData[i] = tool.delayedHistroyData[i + 1 ]
    end

    setRotation(tool.delayedNode, unpack(currentData.rot))
    setTranslation(tool.delayedNode, unpack(currentData.trans))

    -- local r, _, _ = getRotation(tool.node)
    -- log(string.format("%s: %.2f | %s: %.2f", getName(tool.node), math.deg(r), getName(tool.delayedNode), math.deg(currentData.rot[1])))

    tool.delayedHistoryIndex = tool.delayedHistoryIndex - 1

    local movingPart = spec.nodesToMovingParts[tool.delayedNode]
    local movingTool = spec.nodesToMovingTools[tool.delayedNode]
    if movingPart ~ = nil then
        Cylindered.setDirty( self , movingPart)
    end
    if spec.nodesToMovingTools[tool.delayedNode] ~ = nil then
        Cylindered.setDirty( self , movingTool)
    end
end

```

### updateDependentAnimations

**Description**

**Definition**

> updateDependentAnimations()

**Arguments**

| any | part |
|-----|------|
| any | dt   |

**Code**

```lua
function Cylindered:updateDependentAnimations(part, dt)
    if #part.dependentAnimations > 0 then
        for _, dependentAnimation in ipairs(part.dependentAnimations) do
            local pos = 0
            if dependentAnimation.translationAxis ~ = nil then
                local translationAxisValue = select(dependentAnimation.translationAxis, getTranslation(dependentAnimation.node))
                pos = (translationAxisValue - dependentAnimation.minValue) / (dependentAnimation.maxValue - dependentAnimation.minValue)
            end

            if dependentAnimation.rotationAxis ~ = nil then
                local rotationAxisValue = select(dependentAnimation.rotationAxis, getRotation(dependentAnimation.node))
                pos = (rotationAxisValue - dependentAnimation.minValue) / (dependentAnimation.maxValue - dependentAnimation.minValue)
            end

            pos = math.clamp(pos, 0 , 1 )
            if dependentAnimation.invert then
                pos = 1 - pos
            end
            dependentAnimation.lastPos = pos

            self:setAnimationTime(dependentAnimation.name, pos, true , true )
        end
    end
end

```

### updateDependentToolLimits

**Description**

**Definition**

> updateDependentToolLimits()

**Arguments**

| any | tool          |
|-----|---------------|
| any | dependentTool |

**Code**

```lua
function Cylindered:updateDependentToolLimits(tool, dependentTool)
    if dependentTool.minTransLimits ~ = nil or dependentTool.maxTransLimits ~ = nil then
        local state = Cylindered.getMovingToolState( self , tool)
        if dependentTool.minTransLimits ~ = nil then
            dependentTool.movingTool.transMin = MathUtil.lerp(dependentTool.minTransLimits[ 1 ], dependentTool.minTransLimits[ 2 ], 1 - state)
        end
        if dependentTool.maxTransLimits ~ = nil then
            dependentTool.movingTool.transMax = MathUtil.lerp(dependentTool.maxTransLimits[ 1 ], dependentTool.maxTransLimits[ 2 ], 1 - state)
        end
        local transLimitChanged = Cylindered.setToolTranslation( self , dependentTool.movingTool, 0 , 0 )
        if transLimitChanged then
            Cylindered.setDirty( self , dependentTool.movingTool)
        end
    end

    if dependentTool.minRotLimits ~ = nil or dependentTool.maxRotLimits ~ = nil then
        local state = Cylindered.getMovingToolState( self , tool)
        if dependentTool.minRotLimits ~ = nil then
            dependentTool.movingTool.rotMin = MathUtil.lerp(dependentTool.minRotLimits[ 1 ], dependentTool.minRotLimits[ 2 ], 1 - state)
        end
        if dependentTool.maxRotLimits ~ = nil then
            dependentTool.movingTool.rotMax = MathUtil.lerp(dependentTool.maxRotLimits[ 1 ], dependentTool.maxRotLimits[ 2 ], 1 - state)
        end

        dependentTool.movingTool.networkInterpolators.rotation:setMinMax(dependentTool.movingTool.rotMin, dependentTool.movingTool.rotMax)

        local rotLimitChanged = Cylindered.setToolRotation( self , dependentTool.movingTool, 0 , 0 )
        if rotLimitChanged then
            Cylindered.setDirty( self , dependentTool.movingTool)
        end
    end
end

```

### updateDirtyMovingParts

**Description**

**Definition**

> updateDirtyMovingParts()

**Arguments**

| any | dt          |
|-----|-------------|
| any | updateSound |

**Code**

```lua
function Cylindered:updateDirtyMovingParts(dt, updateSound)
    local spec = self.spec_cylindered

    for i = 1 , #spec.movingTools do
        local tool = spec.movingTools[i]
        if tool.isDirty then
            if tool.playSound then
                spec.movingToolNeedsSound = true
            end
            Cylindered.updateWheels( self , tool)
            if self.isServer then
                -- update component joint
                Cylindered.updateComponentJoints( self , tool, false )
            end
            self:updateExtraDependentParts(tool, dt)
            self:updateDependentAnimations(tool, dt)
            tool.isDirty = false
        end
    end

    if self.anyMovingPartsDirty then
        for i = 1 , #spec.movingParts do
            local part = spec.movingParts[i]
            if part.isDirty then
                local isActive = self:getIsMovingPartActive(part)
                if isActive or part.smoothedDirectionScale and part.smoothedDirectionScaleAlpha ~ = 0 then
                    Cylindered.updateMovingPart( self , part, false , nil , isActive)
                    self:updateExtraDependentParts(part, dt)
                    self:updateDependentAnimations(part, dt)
                    if part.playSound then
                        spec.cylinderedHydraulicSoundPartNumber = i
                        spec.movingPartNeedsSound = true
                    end
                end
            else
                    if spec.isClient and spec.cylinderedHydraulicSoundPartNumber = = i then
                        spec.movingPartNeedsSound = false
                    end
                end
            end
            self.anyMovingPartsDirty = false
        end

        if updateSound then
            if self.isClient then
                if spec.movingToolNeedsSound or spec.movingPartNeedsSound then
                    if not spec.isHydraulicSamplePlaying then
                        g_soundManager:playSample(spec.samples.hydraulic)
                        spec.isHydraulicSamplePlaying = true
                    end
                    self:raiseActive()
                else
                        if spec.isHydraulicSamplePlaying then
                            g_soundManager:stopSample(spec.samples.hydraulic)
                            spec.isHydraulicSamplePlaying = false
                        end
                    end
                end
            end
        end

```

### updateEasyControl

**Description**

**Definition**

> updateEasyControl()

**Arguments**

| any | dt                 |
|-----|--------------------|
| any | updateDelayedNodes |

**Code**

```lua
function Cylindered:updateEasyControl(dt, updateDelayedNodes)
    local spec = self.spec_cylindered
    local easyArmControl = spec.easyArmControl
    if easyArmControl ~ = nil then
        local targetYTool = self:getMovingToolByNode(easyArmControl.targetNodeY)
        local targetZTool = self:getMovingToolByNode(easyArmControl.targetNodeZ)

        local moveInputY = self:getMovingToolMoveValue(targetYTool)
        local moveInputZ = self:getMovingToolMoveValue(targetZTool)

        local hasChanged = false
        if moveInputY ~ = 0 or moveInputZ ~ = 0 then
            hasChanged = true

            if (moveInputY ~ = 0 and targetYTool.isConsumingPower) or(moveInputZ ~ = 0 and targetZTool.isConsumingPower) then
                spec.powerConsumingTimer = spec.powerConsumingActiveTimeOffset
            end
        end

        if self.isServer and easyArmControl.state and hasChanged then
            local transSpeedY = moveInputY * easyArmControl.moveSpeed
            if easyArmControl.moveAcceleration ~ = nil and math.abs(transSpeedY - easyArmControl.lastSpeedY) > = easyArmControl.moveAcceleration * dt then
                if transSpeedY > easyArmControl.lastSpeedY then
                    transSpeedY = easyArmControl.lastSpeedY + easyArmControl.moveAcceleration * dt
                else
                        transSpeedY = easyArmControl.lastSpeedY - easyArmControl.moveAcceleration * dt
                    end
                end

                local transSpeedZ = moveInputZ * easyArmControl.moveSpeed
                if easyArmControl.moveAcceleration ~ = nil and math.abs(transSpeedZ - easyArmControl.lastSpeedZ) > = easyArmControl.moveAcceleration * dt then
                    if transSpeedZ > easyArmControl.lastSpeedZ then
                        transSpeedZ = easyArmControl.lastSpeedZ + easyArmControl.moveAcceleration * dt
                    else
                            transSpeedZ = easyArmControl.lastSpeedZ - easyArmControl.moveAcceleration * dt
                        end
                    end

                    easyArmControl.lastSpeedY = transSpeedY
                    local moveY = transSpeedY * dt

                    easyArmControl.lastSpeedZ = transSpeedZ
                    local moveZ = transSpeedZ * dt

                    -- target world position
                    local worldTargetDirX, worldTargetDirY, worldTargetDirZ = localDirectionToWorld(easyArmControl.rootNode, 0 , moveY, moveZ)
                    local worldTargetX, worldTargetY, worldTargetZ = getWorldTranslation(easyArmControl.targetRefNode)
                    worldTargetX, worldTargetY, worldTargetZ = worldTargetX + worldTargetDirX, worldTargetY + worldTargetDirY, worldTargetZ + worldTargetDirZ

                    -- limit target position to max distance radius
                    local locTargetX, locTargetY, locTargetZ = worldToLocal(easyArmControl.rootNode, worldTargetX, worldTargetY, worldTargetZ)
                    local distanceToTarget = MathUtil.vector3Length(locTargetX, locTargetY, locTargetZ)

                    local targetExceedFactor = easyArmControl.maxTotalDistance / distanceToTarget
                    if targetExceedFactor < 1 then
                        locTargetX, locTargetY, locTargetZ = locTargetX * targetExceedFactor, locTargetY * targetExceedFactor, locTargetZ * targetExceedFactor
                        worldTargetX, worldTargetY, worldTargetZ = localToWorld(easyArmControl.rootNode, locTargetX, locTargetY, locTargetZ)

                        distanceToTarget = easyArmControl.maxTotalDistance
                    end

                    -- distance from arm1 to arm2 and arm2 to end node
                    local circleDistance1 = MathUtil.vector3Length(localToLocal(easyArmControl.xRotationNodes[ 2 ].node, easyArmControl.xRotationNodes[ 1 ].node, 0 , 0 , 0 ))
                    local _, _, circleDistance2 = localToLocal(easyArmControl.targetRefNode, easyArmControl.xRotationNodes[ 2 ].node, 0 , 0 , 0 )

                    -- circle center positions
                    local circle1X, circle1Y, circle1Z = localToLocal(easyArmControl.xRotationNodes[ 1 ].node, easyArmControl.rootNode, 0 , 0 , 0 )
                    local circle2X, circle2Y, circle2Z = worldToLocal(easyArmControl.rootNode, worldTargetX, worldTargetY, worldTargetZ)

                    --#debug local c1xw, c1yw, c1zw = localToWorld(easyArmControl.rootNode, circle1X, circle1Y, circle1Z)
                    --#debug DebugGizmo.renderAtPositionSimple(c1xw, c1yw, c1zw, "c1")
                    --#debug local c2xw, c2yw, c2zw = localToWorld(easyArmControl.rootNode, circle2X, circle2Y, circle2Z)
                    --#debug DebugGizmo.renderAtPositionSimple(c2xw, c2yw, c2zw, "c2")

                    --#debug DebugGizmo.renderAtPositionSimple(c2xw, c2yw - 0.5, c2zw, string.format("move: %.2f %.2f", moveY / dt * 1000, moveZ / dt * 1000))

                    local numZTranslationNodes = #easyArmControl.zTranslationNodes
                    if numZTranslationNodes > 0 then
                        -- get angle between input direction and translatio node direction
                        local inputDirY, inputDirZ = MathUtil.vector2Normalize( math.abs(moveY), math.abs(moveZ))
                        if moveY = = 0 and moveZ = = 0 then
                            inputDirY, inputDirZ = 0 , 0
                        end
                        local transDirX, transDirY, transDirZ = localDirectionToWorld(easyArmControl.zTranslationNodes[ 1 ].node, 0 , 0 , 1 )
                        transDirX, transDirY, transDirZ = worldDirectionToLocal(easyArmControl.rootNode, transDirX, transDirY, transDirZ)

                        local difference = math.acos( MathUtil.dotProduct( 0 , inputDirY, inputDirZ, 0 , transDirY, transDirZ))
                        if difference > ( math.pi * 0.5 ) then
                            difference = - difference + math.pi
                        end

                        -- move translation parts
                        local rotTransRatio = 1 - (difference / ( math.pi * 0.5 )) -- 1:only trans / 0:only rot
                        rotTransRatio = (rotTransRatio - easyArmControl.transMoveRatioMinDir) / (easyArmControl.transMoveRatioMaxDir - easyArmControl.transMoveRatioMinDir)
                        rotTransRatio = math.clamp(rotTransRatio, easyArmControl.minTransMoveRatio, easyArmControl.maxTransMoveRatio)

                        local _, _, targetZOffset = worldToLocal(easyArmControl.xRotationNodes[ 2 ].node, worldTargetX, worldTargetY, worldTargetZ)
                        local zDifference = targetZOffset - circleDistance2

                        local minTransPct = 0
                        if not easyArmControl.allowNegativeTrans then
                            if transDirZ < 0 then
                                -- move the translation parts to the min position
                                if zDifference > 0 then
                                    rotTransRatio = - 2
                                end

                                minTransPct = easyArmControl.minNegativeTrans * - transDirZ
                            end
                        end

                        local transMove = zDifference * rotTransRatio

                        --#debug DebugGizmo.renderAtPositionSimple(c2xw, c2yw - 1, c2zw, string.format("transDirZ %.2f\n rotTransRatio: %.2f\n transMove: %.3f\n zDifference: %.3f\n", transDirZ, rotTransRatio, transMove / dt * 1000, zDifference / dt * 1000))

                        for i = 1 , numZTranslationNodes do
                            local zTranslationNode = easyArmControl.zTranslationNodes[i]
                            local movingTool = zTranslationNode.movingTool

                            local delta = transMove / numZTranslationNodes
                            if easyArmControl.forcedTransMove ~ = nil then
                                delta = easyArmControl.forcedTransMove * movingTool.transSpeed * dt
                                easyArmControl.forcedTransMove = nil
                            end

                            local currentTrans = movingTool.curTrans[movingTool.translationAxis]
                            local transMin = (movingTool.transMax - movingTool.transMin) * minTransPct + movingTool.transMin
                            local newTrans = math.clamp(currentTrans + delta, transMin, movingTool.transMax)
                            local newDelta = newTrans - currentTrans

                            Cylindered.setAbsoluteToolTranslation( self , movingTool, currentTrans + newDelta)

                            --#debug DebugGizmo.renderAtNode(zTranslationNode.node, "trans" .. tostring(i))
                        end

                        circleDistance2 = MathUtil.vector3Length(worldToLocal(easyArmControl.xRotationNodes[ 2 ].node, getWorldTranslation(easyArmControl.targetRefNode)))
                    end

                    --#debug DebugUtil.drawDebugCircleAtNode(easyArmControl.rootNode, circleDistance1, 200, {1, 1, 1, 1}, true, {0, circle1Y, circle1Z})
                    --#debug DebugUtil.drawDebugCircleAtNode(easyArmControl.rootNode, circleDistance2, 200, {1, 0, 1, 1}, true, {0, circle2Y, circle2Z})

                    -- calculate intersections
                    local ix, iy, i2x, i2y = MathUtil.getCircleCircleIntersection(circle1Z, circle1Y, circleDistance1, circle2Z, circle2Y, circleDistance2)
                    if ix ~ = nil and iy ~ = nil then
                        local node1Tool = easyArmControl.xRotationNodes[ 1 ].movingTool
                        local node2Tool = easyArmControl.xRotationNodes[ 2 ].movingTool

                        -- rotation node 1
                        local node1Rotation = - math.atan2(iy, ix)
                        local node1RotationClamped = math.clamp(node1Rotation, node1Tool.rotMin, node1Tool.rotMax)
                        local node1Overrun = 0 -- node1Rotation - node1RotationClamped

                        Cylindered.setAbsoluteToolRotation( self , easyArmControl.xRotationNodes[ 1 ].movingTool, node1RotationClamped, updateDelayedNodes)

                        -- rotation node 2
                        local node2Rotation = math.pi - math.acos((circleDistance1 * circleDistance1 + circleDistance2 * circleDistance2 - distanceToTarget * distanceToTarget) / ( 2 * circleDistance1 * circleDistance2))
                        local node2RotationClamped = math.clamp(node2Rotation + node1Overrun, node2Tool.rotMin, node2Tool.rotMax)
                        local node2Overrun = node2Rotation - node2RotationClamped

                        Cylindered.setAbsoluteToolRotation( self , easyArmControl.xRotationNodes[ 2 ].movingTool, node2RotationClamped, updateDelayedNodes)

                        -- rotation node 1
                        node1RotationClamped = math.clamp(node1RotationClamped + node2Overrun * 0.5 , node1Tool.rotMin, node1Tool.rotMax)
                        Cylindered.setAbsoluteToolRotation( self , easyArmControl.xRotationNodes[ 1 ].movingTool, node1RotationClamped, updateDelayedNodes)

                        -- debug
                        --#debug local dx0, dy0, dz0 = localToWorld(easyArmControl.rootNode, 0, 0, 0)
                        --#debug local dx1, dy1, dz1 = localToWorld(easyArmControl.rootNode, 0, iy, ix)
                        --#debug local dx2, dy2, dz2 = localToWorld(easyArmControl.rootNode, 0, i2y, i2x)
                        --#debug DebugGizmo.renderAtPositionSimple(dx1, dy1, dz1, "i1")
                        --#debug DebugGizmo.renderAtPositionSimple(dx2, dy2, dz2, "i2")
                        --#debug drawDebugLine(dx0, dy0, dz0, 1, 0, 0, worldTargetX, worldTargetY, worldTargetZ, 1, 0, 0) -- root to target
                        --#debug drawDebugLine(dx0, dy0, dz0, 1, 1, 0, dx1, dy1, dz1, 1, 1, 0) -- root to i1
                        --#debug drawDebugLine(dx1, dy1, dz1, 1, 1, 0, worldTargetX, worldTargetY, worldTargetZ, 1, 1, 0) -- i1 to target

                        --#debug DebugUtil.drawDebugCircleAtNode(easyArmControl.rootNode, easyArmControl.maxTotalDistance, 200, {0, 1, 0, 1}, true)
                        --#debug if easyArmControl.maxTransDistance ~ = nil then
                            --#debug DebugUtil.drawDebugCircleAtNode(easyArmControl.xRotationNodes[2].node, easyArmControl.maxTransDistance, 200, {0, 1, 0, 1}, true)
                            --#debug end
                        end
                    end
                end
            end

```

### updateExtraDependentParts

**Description**

**Definition**

> updateExtraDependentParts()

**Arguments**

| any | part |
|-----|------|
| any | dt   |

**Code**

```lua
function Cylindered:updateExtraDependentParts(part, dt)
end

```

### updateMovingPart

**Description**

> Update moving part

**Definition**

> updateMovingPart(table part, boolean? placeComponents, boolean? updateDependentParts, boolean? isActive, , )

**Arguments**

| table    | part                 | part                                  |
|----------|----------------------|---------------------------------------|
| boolean? | placeComponents      | place components                      |
| boolean? | updateDependentParts | update dependent parts                |
| boolean? | isActive             | moving part is active (default: true) |
| any      | isActive             |                                       |
| any      | updateSounds         |                                       |

**Code**

```lua
function Cylindered.updateMovingPart( self , part, placeComponents, updateDependentParts, isActive, updateSounds)
    --#debug if VehicleDebug.cylinderedUpdateDebugState and self:getIsActiveForInput() then
        --#debug DebugGizmo.renderAtNode(part.node, "Part: " .. getName(part.node), true)
        --#debug end

        -- the local reference point must be referenceDistance away from the referencePoint
        local refX, refY, refZ
        local dirX, dirY, dirZ = 0 , 0 , 0
        local changed, applyDirection = false , false
        if part.hasReferencePoints then
            if part.moveToReferenceFrame then
                local x,y,z = localToLocal(part.referenceFrame, getParent(part.node), part.referenceFrameOffset[ 1 ], part.referenceFrameOffset[ 2 ], part.referenceFrameOffset[ 3 ])
                setTranslation(part.node, x,y,z)
                changed = true
            end

            if part.referencePoint ~ = nil then
                refX, refY, refZ = getWorldTranslation(part.referencePoint)
            else
                    refX, refY, refZ = 0 , 0 , 0
                    for i, referencePoint in ipairs(part.referencePoints) do
                        local x, y, z = getWorldTranslation(referencePoint)
                        refX, refY, refZ = refX + x, refY + y, refZ + z
                    end

                    refX, refY, refZ = refX / part.numReferencePoints, refY / part.numReferencePoints, refZ / part.numReferencePoints
                end

                if part.referenceDistance = = 0 then
                    if part.useLocalOffset then
                        local lx, ly, lz = worldToLocal(part.node, refX, refY, refZ)
                        dirX, dirY, dirZ = localDirectionToWorld(part.node, lx - part.localReferencePoint[ 1 ], ly - part.localReferencePoint[ 2 ], lz)
                    elseif part.referencePointOffset ~ = nil then
                            local offset = math.abs(part.referencePointOffset)
                            local direction = math.sign(part.referencePointOffset)

                            local x, y, z = getWorldTranslation(part.node)
                            --#debug drawDebugPoint(x, y, z, 0, 1, 0, 1, false)

                            local _, y1, z1 = localToLocal(part.node, part.referenceFrame, 0 , 0 , 0 )
                            local _, y2, z2 = localToLocal(part.referencePoint, part.referenceFrame, 0 , 0 , 0 )

                            --#debug local wx2, wy2, wz2 = localToWorld(part.referenceFrame, 0, y2, z2)
                            --#debug drawDebugPoint(wx2, wy2, wz2, 0, 1, 0, 1, false)

                            local a = MathUtil.vector2Length(y2 - y1, z2 - z1)
                            if a > offset then
                                local b = math.sqrt(a ^ 2 - offset ^ 2 )
                                local rotOffset = math.atan(offset / b)

                                --#debug DebugUtil.drawDebugCircleAtNode(part.referenceFrame, offset, 25, nil, true, {0, y2, z2})

                                local rot = MathUtil.getYRotationFromDirection(y2 - y1, z2 - z1)
                                local tDirY, tDirZ = MathUtil.getDirectionFromYRotation(rot + rotOffset * direction)

                                local ty, tz = y1 + tDirY * b, z1 + tDirZ * b
                                refX, refY, refZ = localToWorld(part.referenceFrame, 0 , ty, tz)

                                --#debug drawDebugPoint(refX, refY, refZ, 0, 1, 0, 1, false)
                                --#debug drawDebugLine(x, y, z, 0, 1, 0, refX, refY, refZ, 0, 1, 0, false)

                                dirX, dirY, dirZ = refX - x, refY - y, refZ - z
                            end
                        else
                                local x, y, z = getWorldTranslation(part.node)
                                dirX, dirY, dirZ = refX - x, refY - y, refZ - z
                            end
                        else
                                if part.updateLocalReferenceDistance then
                                    local _,y,z = worldToLocal(part.node, getWorldTranslation(part.localReferencePointNode))
                                    part.localReferenceDistance = MathUtil.vector2Length(y, z)
                                end
                                if part.referenceDistancePoint ~ = nil then
                                    local _,_,z = worldToLocal(part.node, getWorldTranslation(part.referenceDistancePoint))
                                    part.referenceDistance = z
                                end

                                if part.localReferenceTranslate then
                                    local _, ly, lz = worldToLocal(part.node, refX, refY, refZ)

                                    -- calculate line-circle intersection
                                    if math.abs(ly) < part.referenceDistance then
                                        local dz = math.sqrt(part.referenceDistance * part.referenceDistance - ly * ly)

                                        local z1 = (lz - dz) - part.localReferenceDistance
                                        local z2 = (lz + dz) - part.localReferenceDistance
                                        if math.abs(z2) < math.abs(z1) then
                                            z1 = z2
                                        end
                                        local parentNode = getParent(part.node)
                                        local tx,ty,tz = unpack(part.localReferenceTranslation)
                                        local _, _, coz = localToLocal(parentNode, part.node, tx,ty,tz)
                                        local ox,oy,oz = localDirectionToLocal(part.node, parentNode, 0 , 0 ,z1 - coz)
                                        setTranslation(part.node, tx + ox,ty + oy,tz + oz)
                                        changed = true
                                    end
                                else
                                        local r1 = part.localReferenceDistance
                                        local r2 = part.referenceDistance

                                        if part.dynamicLocalReferenceDistance then
                                            local _, y1, z1 = worldToLocal(part.node, getWorldTranslation(part.localReferencePointNode))
                                            local _, y2, z2 = worldToLocal(part.node, localToWorld(part.localReferencePointNode, 0 , 0 , part.referenceDistance))

                                            r2 = MathUtil.vector2Length(y1 - y2, z1 - z2)
                                        end

                                        local _, ly, lz = worldToLocal(part.node, refX, refY, refZ)
                                        --print("intersect: " .. ly .. " " .. lz)
                                        local ix, iy, i2x, i2y = MathUtil.getCircleCircleIntersection( 0 , 0 , r1, ly, lz, r2)

                                        local allowUpdate = true
                                        if part.referenceDistanceThreshold > 0 then
                                            local lRefX, lRefY, lRefZ = getWorldTranslation(part.localReferencePointNode)
                                            local currentDistance = MathUtil.vector3Length(refX - lRefX, refY - lRefY, refZ - lRefZ)
                                            if math.abs(currentDistance - part.referenceDistance) < part.referenceDistanceThreshold then
                                                allowUpdate = false
                                            end
                                        end

                                        if allowUpdate and ix ~ = nil then
                                            if i2x ~ = nil then
                                                -- use the point which as the same angle side as the original configuration
                                                local side = ix * (lz - iy) - iy * (ly - ix)
                                                if (side < 0 ) ~ = (part.localReferenceAngleSide < 0 ) then
                                                    iy = i2y
                                                    ix = i2x
                                                end
                                            end
                                            dirX, dirY, dirZ = localDirectionToWorld(part.node, 0 , ix, iy)
                                            changed = true
                                        end
                                    end
                                end

                                if part.doInversedLineAlignment then
                                    if part.doInversedLineAlignmentRoot = = nil then
                                        part.doInversedLineAlignmentRoot = createTransformGroup( "inversedLineAlignmentRoot" )
                                        link(getParent(part.node), part.doInversedLineAlignmentRoot, getChildIndex(part.node))
                                        setTranslation(part.doInversedLineAlignmentRoot, getTranslation(part.node))
                                        setRotation(part.doInversedLineAlignmentRoot, getRotation(part.node))
                                        link(part.doInversedLineAlignmentRoot, part.node)
                                        setTranslation(part.node, 0 , 0 , 0 )
                                        setRotation(part.node, 0 , 0 , 0 )
                                    end

                                    for i = 1 , #part.orientationLineNodes - 1 do
                                        local startNode = part.orientationLineNodes[i]
                                        local endNode = part.orientationLineNodes[i + 1 ]

                                        local _, sy, sz = localToLocal(startNode, part.node, 0 , 0 , 0 )
                                        local _, ey, ez = localToLocal(endNode, part.node, 0 , 0 , 0 )

                                        local minLength = MathUtil.vector2Length(sy, sz)
                                        local maxLength = MathUtil.vector2Length(ey, ez)

                                        local rootX, rootY, rootZ = getWorldTranslation(part.doInversedLineAlignmentRoot)
                                        local targetLength = MathUtil.vector3Length(refX - rootX, refY - rootY, refZ - rootZ)

                                        if not MathUtil.getIsOutOfBounds(targetLength, minLength, maxLength) then
                                            local alpha = (targetLength - minLength) / (maxLength - minLength)

                                            local ty = MathUtil.lerp(sy, ey, alpha)
                                            local tz = MathUtil.lerp(sz, ez, alpha)

                                            -- alignment root always pointing to reference point
                                            -- actual moving part is adjusting to local offset to current target point on the line

                                            local upX, upY, upZ = localDirectionToWorld(part.referenceFrame, 0 , 1 , 0 )

                                            dirX, dirY, dirZ = localDirectionToWorld(part.doInversedLineAlignmentRoot, 0 , - ty, tz)
                                            I3DUtil.setWorldDirection(part.node, dirX, dirY, dirZ, upX, upY, upZ, part.limitedAxis, part.minRot, part.maxRot)

                                            local x, y, z = getWorldTranslation(part.doInversedLineAlignmentRoot)
                                            dirX, dirY, dirZ = refX - x, refY - y, refZ - z
                                            I3DUtil.setWorldDirection(part.doInversedLineAlignmentRoot, dirX, dirY, dirZ, upX, upY, upZ, part.limitedAxis, part.minRot, part.maxRot)

                                            --#debug local rx, ry, rz = getWorldTranslation(part.doInversedLineAlignmentRoot)
                                            --#debug drawDebugLine(rx, ry, rz, 1, 0, 1, rx + dirX * targetLength, ry + dirY * targetLength, rz + dirZ * targetLength, 1, 0, 1, true)

                                            --#debug local tx
                                            --#debug tx, ty, tz = localToWorld(part.node, 0, ty, tz)
                                            --#debug drawDebugPoint(tx, ty, tz, 1, 0, 0, 1, true)
                                            --#debug drawDebugPoint(refX, refY, refZ, 1, 0, 1, 1, true)
                                            --#debug Utils.renderTextAtWorldPosition(tx, ty + 0.02, tz, string.format("%.2f(min%.2f, max%.2f, tar%.2f)", alpha, minLength, maxLength, targetLength), getCorrectTextSize(0.008))

                                            changed = true
                                            break
                                        end
                                    end
                                end
                            else
                                    if part.alignToWorldY then
                                        dirX, dirY, dirZ = localDirectionToWorld(getRootNode(), 0 , 1 , 0 )

                                        local lDX, lDY, lDZ = worldDirectionToLocal(part.referenceFrame, dirX, dirY, dirZ)
                                        if lDZ < 0 then
                                            lDZ = - lDZ
                                        end
                                        dirX, dirY, dirZ = localDirectionToWorld(part.referenceFrame, lDX, lDY, lDZ)

                                        changed = true
                                    elseif part.doDirectionAlignment then
                                            dirX, dirY, dirZ = localDirectionToWorld(part.referenceFrame, 0 , 0 , 1 )
                                            changed = true
                                        end
                                        if part.moveToReferenceFrame then
                                            local x,y,z = localToLocal(part.referenceFrame, getParent(part.node), part.referenceFrameOffset[ 1 ], part.referenceFrameOffset[ 2 ], part.referenceFrameOffset[ 3 ])
                                            setTranslation(part.node, x,y,z)
                                            changed = true
                                        end

                                        if part.doLineAlignment then
                                            local foundPoint = false
                                            for i = 1 , #part.orientationLineNodes - 1 do
                                                local startNode = part.orientationLineNodes[i]
                                                local endNode = part.orientationLineNodes[i + 1 ]

                                                local _, sy, sz = localToLocal(startNode, part.referenceFrame, 0 , 0 , 0 )
                                                local _, ey, ez = localToLocal(endNode, part.referenceFrame, 0 , 0 , 0 )
                                                local _, cy, cz = localToLocal(part.node, part.referenceFrame, 0 , 0 , 0 )

                                                local partLength = part.partLength
                                                if part.partLengthNode ~ = nil then
                                                    partLength = calcDistanceFrom(part.node, part.partLengthNode)
                                                end

                                                local hasIntersection, i1y, i1z, i2y, i2z = MathUtil.getCircleLineIntersection(cy, cz, partLength, sy, sz, ey, ez)
                                                if hasIntersection then
                                                    local targetY, targetZ
                                                    if i1y ~ = nil and i1z ~ = nil then
                                                        targetY, targetZ = i1y, i1z
                                                        foundPoint = true
                                                    elseif i2y ~ = nil and i2z ~ = nil then
                                                            targetY, targetZ = i2y, i2z
                                                            foundPoint = true
                                                        end

                                                        if foundPoint and not MathUtil.isNan(targetY) and not MathUtil.isNan(targetZ) then
                                                            dirX, dirY, dirZ = localDirectionToWorld(part.referenceFrame, 0 , targetY, targetZ)

                                                            changed = true
                                                            applyDirection = true
                                                            break
                                                        end
                                                    end
                                                end
                                            end

                                            if part.do3DLineAlignment then
                                                local partLength = part.partLength
                                                if part.partLengthNode ~ = nil then
                                                    partLength = calcDistanceFrom(part.node, part.partLengthNode)
                                                end

                                                local startNode = part.orientationLineNodes[ 1 ]
                                                local endNode = part.orientationLineNodes[ 2 ]

                                                local x, y, z = getWorldTranslation(part.node)

                                                local sx, sy, sz = getWorldTranslation(startNode)
                                                local ex, ey, ez = getWorldTranslation(endNode)

                                                local startDistance = MathUtil.vector3Length(sx - x, sy - y, sz - z)
                                                local endDistance = MathUtil.vector3Length(ex - x, ey - y, ez - z)

                                                local alpha = math.clamp( MathUtil.inverseLerp(startDistance, endDistance, partLength), 0 , 1 )

                                                local rx, ry, rz = MathUtil.vector3Lerp(sx, sy, sz, ex, ey, ez, alpha)

                                                --#debug drawDebugLine(sx, sy, sz, 1, 1, 0, ex, ey, ez, 1, 1, 0, true)
                                                --#debug drawDebugPoint(rx, ry, rz, 0, 1, 0, 1, true)

                                                dirX, dirY, dirZ = MathUtil.vector3Normalize(rx - x, ry - y, rz - z)

                                                setWorldTranslation(part.orientationLineTransNode, rx, ry, rz)
                                                applyDirection = true
                                            end
                                        end

                                        --#debug for i = 1, #part.orientationLineNodes-1 do
                                            --#debug local startNode = part.orientationLineNodes[i]
                                            --#debug local endNode = part.orientationLineNodes[i + 1]
                                            --#debug local swx, swy, swz = getWorldTranslation(startNode)
                                            --#debug local ewx, ewy, ewz = getWorldTranslation(endNode)
                                            --#debug drawDebugLine(swx, swy, swz, 0, 1, 0, ewx, ewy, ewz, 0, 1, 0, true)
                                            --#debug end

                                            local zReferenceOffset = nil

                                            if part.smoothedDirectionScale then
                                                if part.smoothedDirectionScaleAlpha = = nil then
                                                    part.smoothedDirectionScaleAlpha = isActive and 1 or 0
                                                end

                                                local dt = g_currentDt or 9999
                                                if isActive then
                                                    part.smoothedDirectionScaleAlpha = math.min(part.smoothedDirectionScaleAlpha + dt * part.smoothedDirectionTime, 1 )
                                                else
                                                        part.smoothedDirectionScaleAlpha = math.max(part.smoothedDirectionScaleAlpha - dt * part.smoothedDirectionTime, 0 )
                                                    end

                                                    local inDirX, inDirY, inDirZ = localDirectionToWorld(getParent(part.node), unpack(part.initialDirection))
                                                    dirX, dirY, dirZ = MathUtil.vector3Lerp(inDirX, inDirY, inDirZ, dirX, dirY, dirZ, part.smoothedDirectionScaleAlpha)

                                                    if part.hasReferencePoints then
                                                        if part.numTranslatingParts > 0 then
                                                            local _
                                                            _, _, zReferenceOffset = worldToLocal(part.node, refX, refY, refZ)
                                                            zReferenceOffset = MathUtil.lerp(part.smoothedDirectionScaleZOffset, zReferenceOffset, part.smoothedDirectionScaleAlpha)
                                                        end
                                                    end

                                                    if part.smoothedDirectionScaleTempDirty and(part.smoothedDirectionScaleAlpha = = 0 or part.smoothedDirectionScaleAlpha = = 1 ) then
                                                        table.removeElement( self.spec_cylindered.activeDirtyMovingParts, part)
                                                        part.smoothedDirectionScaleTempDirty = false
                                                    end
                                                end

                                                if (part.doDirectionAlignment or applyDirection) and(dirX ~ = 0 or dirY ~ = 0 or dirZ ~ = 0 ) then
                                                    local upX, upY, upZ = localDirectionToWorld(part.referenceFrame, 0 , 1 , 0 )
                                                    if part.invertZ then
                                                        dirX = - dirX
                                                        dirY = - dirY
                                                        dirZ = - dirZ
                                                    end

                                                    local directionThreshold = part.directionThresholdActive
                                                    if not self.isActive then
                                                        if part.directionThreshold ~ = nil and part.directionThreshold > 0 then
                                                            directionThreshold = part.directionThreshold
                                                        end
                                                    end

                                                    local lDirX, lDirY, lDirZ = worldDirectionToLocal(part.parent, dirX, dirY, dirZ)
                                                    local lastDirection, lastUpVector = part.lastDirection, part.lastUpVector
                                                    if math.abs(lastDirection[ 1 ] - lDirX) > directionThreshold or
                                                        math.abs(lastDirection[ 2 ] - lDirY) > directionThreshold or
                                                        math.abs(lastDirection[ 3 ] - lDirZ) > directionThreshold or
                                                        math.abs(lastUpVector[ 1 ] - upX) > directionThreshold or
                                                        math.abs(lastUpVector[ 2 ] - upY) > directionThreshold or
                                                        math.abs(lastUpVector[ 3 ] - upZ) > directionThreshold then

                                                        I3DUtil.setWorldDirection(part.node, dirX, dirY, dirZ, upX, upY, upZ, part.limitedAxis, part.minRot, part.maxRot)

                                                        if part.debug then
                                                            local x, y, z = getWorldTranslation(part.node)
                                                            drawDebugPoint(x, y, z, 1 , 0 , 0 , 1 , false )

                                                            local length, _ = 1 , nil
                                                            if part.hasReferencePoints then
                                                                _, _, length = worldToLocal(part.node, refX, refY, refZ)
                                                            end

                                                            local nDirX, nDirY, nDirZ = MathUtil.vector3Normalize(dirX, dirY, dirZ)
                                                            drawDebugLine(x, y, z, 1 , 0 , 0 , x + nDirX * length, y + nDirY * length, z + nDirZ * length, 0 , 1 , 0 , true )

                                                            if part.referencePoint ~ = nil then
                                                                x, y, z = getWorldTranslation(part.referencePoint)
                                                                drawDebugPoint(x, y, z, 0 , 1 , 0 , 1 , false )

                                                                drawDebugPoint(refX, refY, refZ, 0 , 0 , 1 , 1 , false )
                                                            end
                                                        end

                                                        lastDirection[ 1 ], lastDirection[ 2 ], lastDirection[ 3 ] = lDirX, lDirY, lDirZ
                                                        lastUpVector[ 1 ], lastUpVector[ 2 ], lastUpVector[ 3 ] = upX, upY, upZ

                                                        changed = true
                                                    else
                                                            changed = false
                                                        end

                                                        if part.scaleZ and part.localReferenceDistance ~ = nil and part.localReferenceDistance ~ = 0 then
                                                            local len = MathUtil.vector3Length(dirX, dirY, dirZ)
                                                            setScale(part.node, 1 , 1 , len / part.localReferenceDistance)

                                                            if part.debug then
                                                                DebugGizmo.renderAtNode(part.node, string.format( "scale:%.2f" , len / part.localReferenceDistance))
                                                            end
                                                        end
                                                    end

                                                    if part.doRotationAlignment then
                                                        local x, y, z = getRotation(part.referenceFrame)
                                                        x, y, z = x * part.rotMultiplier, y * part.rotMultiplier, z * part.rotMultiplier
                                                        local ox, oy, oz = getRotation(part.node)
                                                        if math.abs(x - ox) > 0.0001 or math.abs(y - oy) > 0.0001 or math.abs(z - oz) > 0.0001 then
                                                            setRotation(part.node, x, y, z)
                                                            changed = true
                                                        end
                                                    end

                                                    if part.hasReferencePoints then
                                                        if part.numTranslatingParts > 0 then
                                                            if zReferenceOffset = = nil then
                                                                local _
                                                                _, _, zReferenceOffset = worldToLocal(part.node, refX, refY, refZ)
                                                            end

                                                            for i = 1 , part.numTranslatingParts do
                                                                local translatingPart = part.translatingParts[i]
                                                                local newZ = zReferenceOffset - translatingPart.referenceDistance
                                                                if part.translatingPartsDivider ~ = 1 and translatingPart.divideTranslatingDistance then
                                                                    newZ = newZ / part.translatingPartsDivider
                                                                end

                                                                if translatingPart.minZTrans ~ = nil then
                                                                    newZ = math.max(translatingPart.minZTrans, newZ)
                                                                end

                                                                if translatingPart.maxZTrans ~ = nil then
                                                                    newZ = math.min(translatingPart.maxZTrans, newZ)
                                                                end

                                                                if not translatingPart.divideTranslatingDistance then
                                                                    zReferenceOffset = zReferenceOffset - (newZ - translatingPart.startPos[ 3 ])
                                                                end

                                                                if part.referenceDistanceThreshold = = 0 or math.abs(translatingPart.lastZ - newZ) > part.referenceDistanceThreshold then
                                                                    if updateSounds ~ = false then
                                                                        if part.samplesByAction ~ = nil or translatingPart.samplesByAction ~ = nil then
                                                                            if newZ ~ = translatingPart.lastZ then
                                                                                if math.abs(translatingPart.lastZ - newZ) > 0.0001 then
                                                                                    self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_END, Cylindered.SOUND_TYPE_ENDING)
                                                                                    self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_END, Cylindered.SOUND_TYPE_ENDING)

                                                                                    self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_START, Cylindered.SOUND_TYPE_STARTING)
                                                                                    self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_START, Cylindered.SOUND_TYPE_STARTING)

                                                                                    if newZ > translatingPart.lastZ + 0.0001 then
                                                                                        self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_POS, Cylindered.SOUND_TYPE_CONTINUES)
                                                                                        self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_POS, Cylindered.SOUND_TYPE_CONTINUES)

                                                                                        self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_END_POS, Cylindered.SOUND_TYPE_ENDING)
                                                                                        self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_END_POS, Cylindered.SOUND_TYPE_ENDING)

                                                                                        self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_START_POS, Cylindered.SOUND_TYPE_STARTING)
                                                                                        self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_START_POS, Cylindered.SOUND_TYPE_STARTING)
                                                                                    elseif newZ < translatingPart.lastZ - 0.0001 then
                                                                                            self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_NEG, Cylindered.SOUND_TYPE_CONTINUES)
                                                                                            self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_NEG, Cylindered.SOUND_TYPE_CONTINUES)

                                                                                            self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_END_NEG, Cylindered.SOUND_TYPE_ENDING)
                                                                                            self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_END_NEG, Cylindered.SOUND_TYPE_ENDING)

                                                                                            self:onMovingPartSoundEvent(part, Cylindered.SOUND_ACTION_TRANSLATING_START_NEG, Cylindered.SOUND_TYPE_STARTING)
                                                                                            self:onMovingPartSoundEvent(translatingPart, Cylindered.SOUND_ACTION_TRANSLATING_START_NEG, Cylindered.SOUND_TYPE_STARTING)
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end

                                                                        translatingPart.lastZ = newZ
                                                                        setTranslation(translatingPart.node, translatingPart.startPos[ 1 ], translatingPart.startPos[ 2 ], newZ)
                                                                        changed = true
                                                                    end
                                                                end
                                                            end
                                                        end

                                                        if changed then
                                                            if part.copyLocalDirectionParts ~ = nil then
                                                                for _,copyLocalDirectionPart in pairs(part.copyLocalDirectionParts) do
                                                                    local dx,dy,dz = localDirectionToWorld(part.node, 0 , 0 , 1 )
                                                                    dx,dy,dz = worldDirectionToLocal(getParent(part.node), dx,dy,dz)
                                                                    dx = dx * copyLocalDirectionPart.dirScale[ 1 ]
                                                                    dy = dy * copyLocalDirectionPart.dirScale[ 2 ]
                                                                    dz = dz * copyLocalDirectionPart.dirScale[ 3 ]

                                                                    local ux,uy,uz = localDirectionToWorld(part.node, 0 , 1 , 0 )
                                                                    ux,uy,uz = worldDirectionToLocal(getParent(part.node), ux,uy,uz)
                                                                    ux = ux * copyLocalDirectionPart.upScale[ 1 ]
                                                                    uy = uy * copyLocalDirectionPart.upScale[ 2 ]
                                                                    uz = uz * copyLocalDirectionPart.upScale[ 3 ]

                                                                    setDirection(copyLocalDirectionPart.node, dx,dy,dz, ux,uy,uz)

                                                                    if self.isServer then
                                                                        Cylindered.updateComponentJoints( self , copyLocalDirectionPart, placeComponents)
                                                                    end
                                                                end
                                                            end

                                                            -- update component joint
                                                            if self.isServer then
                                                                Cylindered.updateComponentJoints( self , part, placeComponents)
                                                                Cylindered.updateAttacherJoints( self , part)
                                                                Cylindered.updateWheels( self , part)
                                                            end

                                                            Cylindered.updateWheels( self , part)

                                                            for _, dependentTool in pairs(part.dependentMovingTools) do
                                                                Cylindered.updateRotationBasedLimits( self , part, dependentTool)
                                                            end
                                                        end

                                                        if updateDependentParts then
                                                            for _, data in pairs(part.dependentPartData) do
                                                                if self.currentUpdateDistance < data.maxUpdateDistance then
                                                                    local dependentPart = data.part
                                                                    local dependentIsActive = self:getIsMovingPartActive(dependentPart)
                                                                    if dependentIsActive or dependentPart.smoothedDirectionScale and dependentPart.smoothedDirectionScaleAlpha ~ = 0 then
                                                                        Cylindered.updateMovingPart( self , dependentPart, placeComponents, updateDependentParts, dependentIsActive)
                                                                    end
                                                                end
                                                            end
                                                        end

                                                        part.isDirty = false
                                                    end

```

### updateMovingPartByNode

**Description**

**Definition**

> updateMovingPartByNode()

**Arguments**

| any | movingPartNode |
|-----|----------------|
| any | dt             |

**Code**

```lua
function Cylindered:updateMovingPartByNode(movingPartNode, dt)
    local movingPart = self.spec_cylindered.nodesToMovingParts[movingPartNode]
    if movingPart ~ = nil then
        Cylindered.updateMovingPart( self , movingPart, false , true , true )

        self:updateExtraDependentParts(movingPart, dt)
        self:updateDependentAnimations(movingPart, dt)
    end
end

```

### updateMovingToolSoundEvents

**Description**

**Definition**

> updateMovingToolSoundEvents()

**Arguments**

| any | tool       |
|-----|------------|
| any | direction  |
| any | hitLimit   |
| any | wasAtLimit |

**Code**

```lua
function Cylindered:updateMovingToolSoundEvents(tool, direction, hitLimit, wasAtLimit)
    if tool.samplesByAction ~ = nil then
        self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_END, Cylindered.SOUND_TYPE_ENDING)
        self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_START, Cylindered.SOUND_TYPE_STARTING)

        if direction then
            self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_POS, Cylindered.SOUND_TYPE_CONTINUES)
            self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_END_POS, Cylindered.SOUND_TYPE_ENDING)
            self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_START_POS, Cylindered.SOUND_TYPE_STARTING)

            if hitLimit then
                self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_END_POS_LIMIT, Cylindered.SOUND_TYPE_ENDING)
            end

            if wasAtLimit then
                self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_START_POS_LIMIT, Cylindered.SOUND_TYPE_STARTING)
            end
        else
                self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_NEG, Cylindered.SOUND_TYPE_CONTINUES)
                self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_END_NEG, Cylindered.SOUND_TYPE_ENDING)
                self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_START_NEG, Cylindered.SOUND_TYPE_STARTING)

                if hitLimit then
                    self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_END_NEG_LIMIT, Cylindered.SOUND_TYPE_ENDING)
                end

                if wasAtLimit then
                    self:onMovingPartSoundEvent(tool, Cylindered.SOUND_ACTION_TOOL_MOVE_START_NEG_LIMIT, Cylindered.SOUND_TYPE_STARTING)
                end
            end
        end
    end

```

### updateRotationBasedLimits

**Description**

**Definition**

> updateRotationBasedLimits()

**Arguments**

| any | self          |
|-----|---------------|
| any | tool          |
| any | dependentTool |

**Code**

```lua
function Cylindered.updateRotationBasedLimits( self , tool, dependentTool)
    if dependentTool.rotationBasedLimits ~ = nil then
        local state
        if tool.isTool then
            state = Cylindered.getMovingToolState( self , tool)
        else
                dependentTool.rotation[ 1 ], dependentTool.rotation[ 2 ], dependentTool.rotation[ 3 ] = getRotation(tool.node)
                state = dependentTool.rotation[dependentTool.axis]
            end

            local minRot, maxRot, minTrans, maxTrans = dependentTool.rotationBasedLimits:get(state)

            if minRot ~ = nil then
                dependentTool.movingTool.rotMin = minRot
            end
            if maxRot ~ = nil then
                dependentTool.movingTool.rotMax = maxRot
            end
            if minTrans ~ = nil then
                dependentTool.movingTool.transMin = minTrans
            end
            if maxTrans ~ = nil then
                dependentTool.movingTool.transMax = maxTrans
            end

            if self.isServer then
                local isDirty = false
                if minRot ~ = nil or maxRot ~ = nil then
                    isDirty = isDirty or Cylindered.setToolRotation( self , dependentTool.movingTool, 0 , 0 )
                end
                if minTrans ~ = nil or maxTrans ~ = nil then
                    isDirty = isDirty or Cylindered.setToolTranslation( self , dependentTool.movingTool, 0 , 0 )
                end

                if isDirty then
                    Cylindered.setDirty( self , dependentTool.movingTool)

                    -- sync the new limited rotation values and also the new rotation limits
                    self:raiseDirtyFlags(dependentTool.movingTool.dirtyFlag)
                    self:raiseDirtyFlags( self.spec_cylindered.cylinderedDirtyFlag)
                end
            else
                    -- on client side the onUpdate is taking care to keep the tool in it's limits if the interpolator is correctly set
                        if minRot ~ = nil or maxRot ~ = nil then
                            dependentTool.movingTool.networkInterpolators.rotation:setMinMax(dependentTool.movingTool.rotMin, dependentTool.movingTool.rotMax)
                        end
                    end
                end
            end

```

### updateWheels

**Description**

> Update wheel of part

**Definition**

> updateWheels(table part, )

**Arguments**

| table | part | part |
|-------|------|------|
| any   | part |      |

**Code**

```lua
function Cylindered.updateWheels( self , part)
    if part.wheels ~ = nil then
        for _, wheel in pairs(part.wheels) do
            wheel.physics:updateShapePosition()

            for _, wheelChock in ipairs(wheel.wheelChocks) do
                wheelChock:update()
            end
        end
    end
end

```