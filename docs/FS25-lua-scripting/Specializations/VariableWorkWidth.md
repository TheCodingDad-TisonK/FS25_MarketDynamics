## VariableWorkWidth

**Description**

> Specialization to change the work width by keys

**Functions**

- [actionEventWorkWidthLeft](#actioneventworkwidthleft)
- [actionEventWorkWidthRight](#actioneventworkwidthright)
- [actionEventWorkWidthToggle](#actioneventworkwidthtoggle)
- [getEffectByNode](#geteffectbynode)
- [getIsWorkAreaActive](#getisworkareaactive)
- [getVariableWorkWidth](#getvariableworkwidth)
- [getVariableWorkWidthUsage](#getvariableworkwidthusage)
- [initSpecialization](#initspecialization)
- [loadWorkAreaFromXML](#loadworkareafromxml)
- [onAIFieldWorkerStart](#onaifieldworkerstart)
- [onAIImplementStart](#onaiimplementstart)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSectionPaths](#registersectionpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setSectionNodePercentage](#setsectionnodepercentage)
- [setSectionsActive](#setsectionsactive)
- [setVariableWorkWidthActive](#setvariableworkwidthactive)
- [updateSections](#updatesections)
- [updateSectionStates](#updatesectionstates)

### actionEventWorkWidthLeft

**Description**

**Definition**

> actionEventWorkWidthLeft()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function VariableWorkWidth.actionEventWorkWidthLeft( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_variableWorkWidth
    self:setSectionsActive(spec.leftSide - inputValue, spec.rightSide)
end

```

### actionEventWorkWidthRight

**Description**

**Definition**

> actionEventWorkWidthRight()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function VariableWorkWidth.actionEventWorkWidthRight( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_variableWorkWidth
    self:setSectionsActive(spec.leftSide, spec.rightSide - inputValue)
end

```

### actionEventWorkWidthToggle

**Description**

**Definition**

> actionEventWorkWidthToggle()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function VariableWorkWidth.actionEventWorkWidthToggle( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_variableWorkWidth

    local minValue = math.min(spec.leftSide, spec.rightSide)
    local newState = minValue - 1
    if newState < spec.minSideState then
        newState = math.min(spec.leftSideMax, spec.rightSideMax)
    end

    self:setSectionsActive(newState, newState)
end

```

### getEffectByNode

**Description**

> Returns the effect object with the given node

**Definition**

> getEffectByNode(integer node)

**Arguments**

| integer | node | node |
|---------|------|------|

**Code**

```lua
function VariableWorkWidth:getEffectByNode(node)
    return
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
function VariableWorkWidth:getIsWorkAreaActive(superFunc, workArea)
    if workArea.sectionIndex ~ = nil then
        local section = self.spec_variableWorkWidth.sections[workArea.sectionIndex]
        if section ~ = nil then
            if not section.isActive then
                return false
            end
        end
    end

    return superFunc( self , workArea)
end

```

### getVariableWorkWidth

**Description**

> Returns the current work width for the given side

**Definition**

> getVariableWorkWidth(boolean isLeft)

**Arguments**

| boolean | isLeft | is left effect |
|---------|--------|----------------|

**Return Values**

| boolean | width    | width                                          |
|---------|----------|------------------------------------------------|
| boolean | maxWidth | max width                                      |
| boolean | isValid  | is valid - has variable working width sections |

**Code**

```lua
function VariableWorkWidth:getVariableWorkWidth(isLeft)
    local spec = self.spec_variableWorkWidth
    local sections = isLeft and spec.sectionsLeft or spec.sectionsRight
    if #sections = = 0 then
        return 1 , 1 , false
    end

    local maxWidth
    for i = #sections, 1 , - 1 do
        local section = sections[i]
        maxWidth = maxWidth or section.widthAbs
        if section.isActive then
            return section.widthAbs, maxWidth, true
        end
    end

    return 0 , maxWidth or 1 , true
end

```

### getVariableWorkWidthUsage

**Description**

> Returns the current usage for variable work width (nil if usage should not be displayed)

**Definition**

> getVariableWorkWidthUsage()

**Return Values**

| boolean | usage | usage |
|---------|-------|-------|

**Code**

```lua
function VariableWorkWidth:getVariableWorkWidthUsage()
    return nil
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function VariableWorkWidth.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "variableWorkWidth" , g_i18n:getText( "configuration_workingWidth" ), "variableWorkWidth" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "VariableWorkWidth" )

    VariableWorkWidth.registerSectionPaths(schema, "vehicle.variableWorkWidth" )
    VariableWorkWidth.registerSectionPaths(schema, "vehicle.variableWorkWidth.variableWorkWidthConfigurations.variableWorkWidthConfiguration(?)" )

    schema:register(XMLValueType.INT, "vehicle.variableWorkWidth#widthReferenceWorkAreaIndex" , "Width of this work area is used as reference for the HUD display" , 1 )
        schema:register(XMLValueType.INT, "vehicle.variableWorkWidth#defaultStateLeft" , "Default state on left side" , "Max.possible state" )
        schema:register(XMLValueType.INT, "vehicle.variableWorkWidth#defaultStateRight" , "Default state on right side" , "Max.possible state" )

        schema:register(XMLValueType.BOOL, "vehicle.variableWorkWidth#aiKeepCurrentWidth" , "Defines if the ai should keep the current width or change it" , false )
            schema:register(XMLValueType.INT, "vehicle.variableWorkWidth#aiStateLeft" , "AI state on left side" , "Max.possible state" )
            schema:register(XMLValueType.INT, "vehicle.variableWorkWidth#aiStateRight" , "AI state on right side" , "Max.possible state" )

            schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_KEY .. ".section#index" , "Section index(Section needs to be active to activate workArea)" )
            schema:register(XMLValueType.INT, WorkArea.WORK_AREA_XML_CONFIG_KEY .. ".section#index" , "Section index(Section needs to be active to activate workArea)" )

            schema:setXMLSpecializationType()

            local schemaSavegame = Vehicle.xmlSchemaSavegame
            schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).variableWorkWidth#leftSide" , "Left side section states" , "Max.state" )
            schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).variableWorkWidth#rightSide" , "Right side section states" , "Max.state" )
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
function VariableWorkWidth:loadWorkAreaFromXML(superFunc, workArea, xmlFile, key)
    workArea.sectionIndex = xmlFile:getValue(key .. ".section#index" )

    return superFunc( self , workArea, xmlFile, key)
end

```

### onAIFieldWorkerStart

**Description**

**Definition**

> onAIFieldWorkerStart()

**Code**

```lua
function VariableWorkWidth:onAIFieldWorkerStart()
    if self.isServer then
        local spec = self.spec_variableWorkWidth
        if not spec.aiKeepCurrentWidth then
            self:setSectionsActive(spec.aiStateLeft, spec.aiStateRight)
        end
    end
end

```

### onAIImplementStart

**Description**

**Definition**

> onAIImplementStart()

**Code**

```lua
function VariableWorkWidth:onAIImplementStart()
    if self.isServer then
        local spec = self.spec_variableWorkWidth
        if not spec.aiKeepCurrentWidth then
            self:setSectionsActive(spec.aiStateLeft, spec.aiStateRight)
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
function VariableWorkWidth:onPostLoad(savegame)
    local spec = self.spec_variableWorkWidth

    local configurationId = Utils.getNoNil( self.configurations[ "variableWorkWidth" ], 1 )
    local configKey = string.format( "vehicle.variableWorkWidth.variableWorkWidthConfigurations.variableWorkWidthConfiguration(%d)" , configurationId - 1 )

    if not self.xmlFile:hasProperty(configKey) then
        configKey = "vehicle.variableWorkWidth"
    end

    local deleteListener = function (section, effect)
        for i = #section.effects, 1 , - 1 do
            if section.effects[i] = = effect then
                section.effects[i] = nil
                break
            end
        end
    end

    local startRestriction = function (section)
        return section.isActive
    end

    spec.hasCenter = false

    spec.sections = { }
    spec.sectionsLeft = { }
    spec.sectionsRight = { }
    self.xmlFile:iterate(configKey .. ".sections.section" , function (index, key)
        local section = { }
        section.isLeft = self.xmlFile:getValue(key .. "#isLeft" , false )
        section.isCenter = self.xmlFile:getValue(key .. "#isCenter" , false )

        section.maxWidthNode = self.xmlFile:getValue(key .. "#maxWidthNode" , nil , self.components, self.i3dMappings)
        section.width = self.xmlFile:getValue(key .. "#width" )

        section.effects = { }
        self.xmlFile:iterate(key .. ".effect" , function (effectIndex, effectKey)
            local effectNode = self.xmlFile:getValue(effectKey .. "#node" , nil , self.components, self.i3dMappings)
            if effectNode ~ = nil then
                local effect = self:getEffectByNode(effectNode)
                if effect ~ = nil then
                    effect:addDeleteListener(deleteListener, section, effect)
                    effect:addStartRestriction(startRestriction, section)
                    table.insert(section.effects, effect)
                end
            end
        end )

        section.isActive = true

        if section.isLeft then
            table.insert(spec.sectionsLeft, section)
        elseif not section.isCenter then
                table.insert(spec.sectionsRight, section)
            else
                    spec.hasCenter = true
                end

                table.insert(spec.sections, section)
                section.index = #spec.sections
            end )

            spec.sectionNodes = { }
            spec.sectionNodesLeft = { }
            spec.sectionNodesRight = { }
            self.xmlFile:iterate(configKey .. ".sectionNodes.sectionNode" , function (index, key)
                local sectionNode = { }
                sectionNode.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                if sectionNode.node ~ = nil then
                    sectionNode.isLeft = self.xmlFile:getValue(key .. "#isLeft" , false )

                    sectionNode.startTrans = self.xmlFile:getValue(key .. "#minTrans" , nil , true )
                    sectionNode.startTransX = self.xmlFile:getValue(key .. "#minTransX" )
                    sectionNode.endTrans = self.xmlFile:getValue(key .. "#maxTrans" , nil , true )
                    sectionNode.endTransX = self.xmlFile:getValue(key .. "#maxTransX" )
                    sectionNode.startRot = self.xmlFile:getValue(key .. "#minRot" , nil , true )
                    sectionNode.endRot = self.xmlFile:getValue(key .. "#endRot" , nil , true )

                    if sectionNode.startTrans = = nil and sectionNode.startTransX = = nil then
                        Logging.xmlWarning( self.xmlFile, "sectionNode '%s' needs either 'minTrans' or 'minTransX' set" , key)
                        return
                    end
                    if sectionNode.endTrans = = nil and sectionNode.endTransX = = nil then
                        Logging.xmlWarning( self.xmlFile, "sectionNode '%s' needs either 'maxTrans' or 'maxTransX' set" , key)
                        return
                    end

                    sectionNode.workAreaIndex = self.xmlFile:getValue(key .. "#workAreaIndex" , 1 )

                    if sectionNode.isLeft then
                        table.insert(spec.sectionNodesLeft, sectionNode)
                    else
                            table.insert(spec.sectionNodesRight, sectionNode)
                        end

                        table.insert(spec.sectionNodes, sectionNode)
                    end
                end )

                for i = 1 , #spec.sections do
                    local section = spec.sections[i]
                    if section.maxWidthNode ~ = nil then
                        if not section.isCenter then
                            for j = 1 , #spec.sectionNodes do
                                local sectionNode = spec.sectionNodes[j]
                                if sectionNode.isLeft = = section.isLeft then
                                    local x, _, _ = localToLocal(section.maxWidthNode, getParent(sectionNode.node), 0 , 0 , 0 )

                                    local minX, maxX = sectionNode.startTransX or sectionNode.startTrans[ 1 ], sectionNode.endTransX or sectionNode.endTrans[ 1 ]
                                    section.width = math.clamp( math.abs((x - minX) / (maxX - minX)), 0 , 1 )
                                    section.widthAbs = x
                                    break
                                end
                            end
                        end
                    else
                            section.width = 0
                        end

                        if section.width = = nil then
                            Logging.xmlWarning( self.xmlFile, "Unable to get width for section 'vehicle.variableWorkWidth.sections.section(%d)'" , i)
                                section.width = 0
                            end
                        end

                        local function sort(a, b)
                            return a.width < b.width
                        end
                        table.sort(spec.sectionsLeft, sort )
                        table.sort(spec.sectionsRight, sort )

                        spec.widthReferenceWorkArea = self.xmlFile:getValue( "vehicle.variableWorkWidth#widthReferenceWorkAreaIndex" , 1 )

                        spec.leftSideMax = #spec.sectionsLeft
                        spec.leftSide = self.xmlFile:getValue( "vehicle.variableWorkWidth#defaultStateLeft" , spec.leftSideMax)
                        spec.rightSideMax = #spec.sectionsRight
                        spec.rightSide = self.xmlFile:getValue( "vehicle.variableWorkWidth#defaultStateRight" , spec.rightSideMax)

                        spec.aiKeepCurrentWidth = self.xmlFile:getValue( "vehicle.variableWorkWidth#aiKeepCurrentWidth" , false )
                        spec.aiStateLeft = self.xmlFile:getValue( "vehicle.variableWorkWidth#aiStateLeft" , spec.leftSideMax)
                        spec.aiStateRight = self.xmlFile:getValue( "vehicle.variableWorkWidth#aiStateRight" , spec.rightSideMax)

                        spec.minSideState = spec.hasCenter and 0 or 1

                        if savegame ~ = nil and not savegame.resetVehicles then
                            spec.leftSide = math.min(savegame.xmlFile:getValue(savegame.key .. ".variableWorkWidth#leftSide" , spec.leftSide), spec.leftSideMax)
                            spec.rightSide = math.min(savegame.xmlFile:getValue(savegame.key .. ".variableWorkWidth#rightSide" , spec.rightSide), spec.rightSideMax)
                        end

                        self:updateSections()

                        spec.drawInputHelp = false
                        spec.hasSections = #spec.sections > 0
                        spec.isActive = spec.hasSections

                        if spec.hasSections then
                            spec.hudExtension = VariableWorkWidthHUDExtension.new( self )
                        else
                                SpecializationUtil.removeEventListener( self , "onReadStream" , VariableWorkWidth )
                                SpecializationUtil.removeEventListener( self , "onWriteStream" , VariableWorkWidth )
                            end

                            if not self.isClient or not spec.hasSections then
                                SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , VariableWorkWidth )
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
function VariableWorkWidth:onReadStream(streamId, connection)
    local leftSide = streamReadUIntN(streamId, VariableWorkWidth.SEND_NUM_BITS)
    local rightSide = streamReadUIntN(streamId, VariableWorkWidth.SEND_NUM_BITS)
    self:setSectionsActive(leftSide, rightSide, true )
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
function VariableWorkWidth:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    local spec = self.spec_variableWorkWidth
    self:clearActionEventsTable(spec.actionEvents)

    if isActiveForInputIgnoreSelection then
        if spec.isActive then
            local _, actionEventIdLeft = self:addActionEvent(spec.actionEvents, InputAction.VARIABLE_WORK_WIDTH_LEFT, self , VariableWorkWidth.actionEventWorkWidthLeft, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventIdLeft, GS_PRIO_HIGH)

            local _, actionEventIdRight = self:addActionEvent(spec.actionEvents, InputAction.VARIABLE_WORK_WIDTH_RIGHT, self , VariableWorkWidth.actionEventWorkWidthRight, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventIdRight, GS_PRIO_HIGH)

            local _, actionEventIdToggle = self:addActionEvent(spec.actionEvents, InputAction.VARIABLE_WORK_WIDTH_TOGGLE, self , VariableWorkWidth.actionEventWorkWidthToggle, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventIdToggle, GS_PRIO_HIGH)

            spec.drawInputHelp = g_inputBinding:getActionEventsHasBinding(actionEventIdLeft) or g_inputBinding:getActionEventsHasBinding(actionEventIdRight) or g_inputBinding:getActionEventsHasBinding(actionEventIdToggle)
        else
                spec.drawInputHelp = false
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
function VariableWorkWidth:onWriteStream(streamId, connection)
    local spec = self.spec_variableWorkWidth
    streamWriteUIntN(streamId, spec.leftSide, VariableWorkWidth.SEND_NUM_BITS)
    streamWriteUIntN(streamId, spec.rightSide, VariableWorkWidth.SEND_NUM_BITS)
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
function VariableWorkWidth.prerequisitesPresent(specializations)
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
function VariableWorkWidth.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onAIFieldWorkerStart" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onAIImplementStart" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , VariableWorkWidth )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , VariableWorkWidth )
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
function VariableWorkWidth.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onVariableWorkWidthSectionChanged" )
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
function VariableWorkWidth.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "setVariableWorkWidthActive" , VariableWorkWidth.setVariableWorkWidthActive)
    SpecializationUtil.registerFunction(vehicleType, "setSectionsActive" , VariableWorkWidth.setSectionsActive)
    SpecializationUtil.registerFunction(vehicleType, "setSectionNodePercentage" , VariableWorkWidth.setSectionNodePercentage)
    SpecializationUtil.registerFunction(vehicleType, "updateSections" , VariableWorkWidth.updateSections)
    SpecializationUtil.registerFunction(vehicleType, "updateSectionStates" , VariableWorkWidth.updateSectionStates)
    SpecializationUtil.registerFunction(vehicleType, "getEffectByNode" , VariableWorkWidth.getEffectByNode)
    SpecializationUtil.registerFunction(vehicleType, "getVariableWorkWidth" , VariableWorkWidth.getVariableWorkWidth)
    SpecializationUtil.registerFunction(vehicleType, "getVariableWorkWidthUsage" , VariableWorkWidth.getVariableWorkWidthUsage)
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
function VariableWorkWidth.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWorkAreaFromXML" , VariableWorkWidth.loadWorkAreaFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsWorkAreaActive" , VariableWorkWidth.getIsWorkAreaActive)
end

```

### registerSectionPaths

**Description**

**Definition**

> registerSectionPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function VariableWorkWidth.registerSectionPaths(schema, basePath)
    schema:register(XMLValueType.BOOL, basePath .. ".sections.section(?)#isLeft" , "Section side" , false )
    schema:register(XMLValueType.BOOL, basePath .. ".sections.section(?)#isCenter" , "Is center section" , false )
    schema:register(XMLValueType.FLOAT, basePath .. ".sections.section(?)#width" , "Section max.width as percentage [0 .. 1]" , "Automatically calculated" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".sections.section(?)#maxWidthNode" , "Position of this node defines max.width of this section" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".sections.section(?).effect(?)#node" , "Effect to deactivate/activate" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".sectionNodes.sectionNode(?)#node" , "Section node" )
    schema:register(XMLValueType.BOOL, basePath .. ".sectionNodes.sectionNode(?)#isLeft" , "Section node" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".sectionNodes.sectionNode(?)#minTrans" , "Min.translation" )
    schema:register(XMLValueType.FLOAT, basePath .. ".sectionNodes.sectionNode(?)#minTransX" , "Min.X translation" )
    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".sectionNodes.sectionNode(?)#maxTrans" , "Max.translation" )
    schema:register(XMLValueType.FLOAT, basePath .. ".sectionNodes.sectionNode(?)#maxTransX" , "Max.X translation" )
    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".sectionNodes.sectionNode(?)#minRot" , "Min.rotation" )
    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".sectionNodes.sectionNode(?)#endRot" , "Max.rotation" )
    schema:register(XMLValueType.INT, basePath .. ".sectionNodes.sectionNode(?)#workAreaIndex" , "Work area index" , 1 )
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
function VariableWorkWidth:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_variableWorkWidth
    if spec.hasSections then
        xmlFile:setValue(key .. "#leftSide" , spec.leftSide)
        xmlFile:setValue(key .. "#rightSide" , spec.rightSide)
    end
end

```

### setSectionNodePercentage

**Description**

**Definition**

> setSectionNodePercentage()

**Arguments**

| any | sectionNodes |
|-----|--------------|
| any | percentage   |

**Code**

```lua
function VariableWorkWidth:setSectionNodePercentage(sectionNodes, percentage)
    percentage = math.max( math.min(percentage, 1 ), 0 )
    for i = 1 , #sectionNodes do
        local sectionNode = sectionNodes[i]

        if sectionNode.startTrans ~ = nil and sectionNode.endTrans ~ = nil then
            setTranslation(sectionNode.node, MathUtil.vector3ArrayLerp(sectionNode.startTrans, sectionNode.endTrans, percentage))
        end

        if sectionNode.startTransX ~ = nil and sectionNode.endTransX ~ = nil then
            local _, y, z = getTranslation(sectionNode.node)
            local x = MathUtil.lerp(sectionNode.startTransX, sectionNode.endTransX, percentage)
            setTranslation(sectionNode.node, x, y, z)
        end

        if sectionNode.startRot ~ = nil and sectionNode.endRot ~ = nil then
            setRotation(sectionNode.node, MathUtil.vector3ArrayLerp(sectionNode.startRot, sectionNode.endRot, percentage))
        end

        if sectionNode.workAreaIndex ~ = nil then
            self:updateWorkAreaWidth(sectionNode.workAreaIndex)
        end
    end
end

```

### setSectionsActive

**Description**

**Definition**

> setSectionsActive()

**Arguments**

| any | leftSide    |
|-----|-------------|
| any | rightSide   |
| any | noEventSend |

**Code**

```lua
function VariableWorkWidth:setSectionsActive(leftSide, rightSide, noEventSend)
    local spec = self.spec_variableWorkWidth
    leftSide = math.clamp(leftSide, 0 , spec.leftSideMax)
    rightSide = math.clamp(rightSide, 0 , spec.rightSideMax)

    if spec.leftSide ~ = leftSide or spec.rightSide ~ = rightSide then
        spec.leftSide = leftSide
        spec.rightSide = rightSide

        self:updateSections()

        VariableWorkWidthStateEvent.sendEvent( self , spec.leftSide, spec.rightSide, noEventSend)
    end
end

```

### setVariableWorkWidthActive

**Description**

**Definition**

> setVariableWorkWidthActive()

**Arguments**

| any | isActive |
|-----|----------|

**Code**

```lua
function VariableWorkWidth:setVariableWorkWidthActive(isActive)
    local spec = self.spec_variableWorkWidth
    spec.isActive = isActive

    if self.isServer then
        if not isActive then
            self:setSectionsActive(spec.leftSideMax, spec.rightSideMax)
        end
    end

    self:requestActionEventUpdate()
end

```

### updateSections

**Description**

**Definition**

> updateSections()

**Code**

```lua
function VariableWorkWidth:updateSections()
    local spec = self.spec_variableWorkWidth

    self:updateSectionStates(spec.sectionsLeft, spec.leftSide)
    self:updateSectionStates(spec.sectionsRight, spec.rightSide)

    local leftSectionWidth = spec.leftSide = = 0 and 0 or spec.sectionsLeft[spec.leftSide].width
    self:setSectionNodePercentage(spec.sectionNodesLeft, leftSectionWidth)

    local rightSectionWidth = spec.rightSide = = 0 and 0 or spec.sectionsRight[spec.rightSide].width
    self:setSectionNodePercentage(spec.sectionNodesRight, rightSectionWidth)

    SpecializationUtil.raiseEvent( self , "onVariableWorkWidthSectionChanged" )
end

```

### updateSectionStates

**Description**

**Definition**

> updateSectionStates()

**Arguments**

| any | sections |
|-----|----------|
| any | state    |

**Code**

```lua
function VariableWorkWidth:updateSectionStates(sections, state)
    for i = 1 , #sections do
        local section = sections[i]
        section.isActive = i < = state

        for j = 1 , #section.effects do
            local effect = section.effects[j]

            if not section.isActive then
                if effect:isRunning() then
                    effect:stop()
                end
            end
        end
    end
end

```