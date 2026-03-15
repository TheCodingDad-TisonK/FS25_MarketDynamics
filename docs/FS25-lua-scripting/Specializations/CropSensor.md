## CropSensor

**Description**

> Specialization for crop sensors

**Functions**

- [actionControllerToggleEvent](#actioncontrollertoggleevent)
- [actionEventToggle](#actioneventtoggle)
- [doCheckSpeedLimit](#docheckspeedlimit)
- [getMaxWorkingWidth](#getmaxworkingwidth)
- [getUseTurnedOnSchema](#getuseturnedonschema)
- [initSpecialization](#initspecialization)
- [linkCropSensor](#linkcropsensor)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRootVehicleChanged](#onrootvehiclechanged)
- [onUpdate](#onupdate)
- [prerequisitesPresent](#prerequisitespresent)
- [setCropSensorActive](#setcropsensoractive)
- [updateActionEventTexts](#updateactioneventtexts)
- [updateCropSensorWorkingWidth](#updatecropsensorworkingwidth)
- [updateSensorNode](#updatesensornode)
- [updateSensorRadius](#updatesensorradius)

### actionControllerToggleEvent

**Description**

**Definition**

> actionControllerToggleEvent()

**Arguments**

| any | self      |
|-----|-----------|
| any | direction |

**Code**

```lua
function CropSensor.actionControllerToggleEvent( self , direction)
    self:setCropSensorActive(direction > = 0 )

    return true
end

```

### actionEventToggle

**Description**

**Definition**

> actionEventToggle()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function CropSensor.actionEventToggle( self , actionName, inputValue, callbackState, isAnalog)
    self:setCropSensorActive()
end

```

### doCheckSpeedLimit

**Description**

> Returns if speed limit should be checked

**Definition**

> doCheckSpeedLimit()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | checkSpeedlimit | check speed limit |
|-----|-----------------|-------------------|

**Code**

```lua
function CropSensor:doCheckSpeedLimit(superFunc)
    local spec = self [ CropSensor.SPEC_TABLE_NAME]
    return superFunc( self ) or(spec ~ = nil and spec.isStandaloneSensor and spec.isActive)
end

```

### getMaxWorkingWidth

**Description**

**Definition**

> getMaxWorkingWidth()

**Arguments**

| any | sensorVehicle |
|-----|---------------|

**Code**

```lua
function CropSensor.getMaxWorkingWidth(sensorVehicle)
    local childVehicles = sensorVehicle.rootVehicle.childVehicles

    local maxWidth = 0

    for i = 1 , #childVehicles do
        local childVehicle = childVehicles[i]
        if SpecializationUtil.hasSpecialization( ExtendedSprayer , childVehicle.specializations) then
            if childVehicle.getWorkAreaByIndex ~ = nil then
                local workAreas = childVehicle.spec_workArea.workAreas
                for j = 1 , #workAreas do
                    local workArea = workAreas[j]
                    if workArea.start ~ = nil and workArea.width ~ = nil then
                        local width = calcDistanceFrom(workArea.start, workArea.width)
                        maxWidth = math.max(maxWidth, width)

                        local x1, _, _ = localToLocal(workArea.start, sensorVehicle.rootNode, 0 , 0 , 0 )
                        local x2, _, _ = localToLocal(workArea.width, sensorVehicle.rootNode, 0 , 0 , 0 )
                        maxWidth = math.max(maxWidth, math.abs(x1) * 2 , math.abs(x2) * 2 )
                    end
                end
            end

            if childVehicle.getAIMarkers ~ = nil then
                local leftMarker, rightMarker, _, _ = childVehicle:getAIMarkers()
                if leftMarker ~ = nil and rightMarker ~ = nil then
                    local width = calcDistanceFrom(leftMarker, rightMarker)
                    maxWidth = math.max(maxWidth, width)

                    local x1, _, _ = localToLocal(leftMarker, sensorVehicle.rootNode, 0 , 0 , 0 )
                    local x2, _, _ = localToLocal(rightMarker, sensorVehicle.rootNode, 0 , 0 , 0 )
                    maxWidth = math.max(maxWidth, math.abs(x1) * 2 , math.abs(x2) * 2 )
                end
            end
        end
    end

    return maxWidth
end

```

### getUseTurnedOnSchema

**Description**

**Definition**

> getUseTurnedOnSchema()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function CropSensor:getUseTurnedOnSchema(superFunc)
    local spec = self [ CropSensor.SPEC_TABLE_NAME]
    return superFunc( self ) or(spec ~ = nil and spec.isStandaloneSensor and spec.isActive)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function CropSensor.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "cropSensor" , g_i18n:getText( "configuration_cropSensor" ), "cropSensor" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "CropSensor" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.cropSensor.sensorNode(?)#node" , "Sensor Node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.cropSensor.sensorNode(?)#lightNode" , "Real light source node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.cropSensor.sensorNode(?)#staticLight" , "Static light shape" )
    schema:register(XMLValueType.FLOAT, "vehicle.cropSensor.sensorNode(?)#radius" , "Sensor radius" , 18 )
    schema:register(XMLValueType.BOOL, "vehicle.cropSensor.sensorNode(?)#requiresDaylight" , "Sensor requires daylight to work" , false )
    schema:register(XMLValueType.STRING, "vehicle.cropSensor.sensorNode(?)#shape" , "Sensor shape(CIRCLE | HALF_CIRCLE_LEFT | HALF_CIRCLE_RIGHT)" , "CIRCLE" )

    CropSensor.registerSensorLinkNodePaths(schema, "vehicle.cropSensor.cropSensorConfigurations.cropSensorConfiguration(?).sensorLinkNode(?)" )

    schema:setXMLSpecializationType()
end

```

### linkCropSensor

**Description**

**Definition**

> linkCropSensor()

**Arguments**

| any | linkData |
|-----|----------|

**Code**

```lua
function CropSensor:linkCropSensor(linkData)
    for i = 1 , #linkData.linkNodes do
        local linkNodeData = linkData.linkNodes[i]

        local linkNode = linkNodeData.node
        if linkNode = = nil and linkNodeData.nodeName ~ = nil then
            if self.i3dMappings[linkNodeData.nodeName] ~ = nil then
                linkNode = self.i3dMappings[linkNodeData.nodeName].nodeId
            end
        end

        if linkNode ~ = nil then
            local sensorData = g_precisionFarming:getClonedCropSensorNode(linkNodeData.typeName)
            if sensorData ~ = nil then
                link(linkNode, sensorData.node)

                setTranslation(sensorData.node, linkNodeData.translation[ 1 ], linkNodeData.translation[ 2 ], linkNodeData.translation[ 3 ])
                setRotation(sensorData.node, linkNodeData.rotation[ 1 ], linkNodeData.rotation[ 2 ], linkNodeData.rotation[ 3 ])

                for j = 1 , #sensorData.rotationNodes do
                    local rotationNode = sensorData.rotationNodes[j]

                    local autoRotate = false
                    if linkNodeData.rotationNodes[j] ~ = nil then
                        local vRotationNode = linkNodeData.rotationNodes[j]
                        if rotationNode.autoRotate and vRotationNode.autoRotate ~ = false and vRotationNode.rotation = = nil then
                            autoRotate = true
                        elseif vRotationNode.rotation ~ = nil then
                                setRotation(rotationNode.node, vRotationNode.rotation[ 1 ], vRotationNode.rotation[ 2 ], vRotationNode.rotation[ 3 ])
                            end
                        else
                                autoRotate = rotationNode.autoRotate
                            end

                            if autoRotate then
                                local rx, ry, rz = localRotationToLocal( self:getParentComponent(sensorData.node), getParent(rotationNode.node), 0 , 0 , 0 )
                                setRotation(rotationNode.node, rx, ry, rz)
                            end
                        end

                        if sensorData.measurementNode ~ = nil then
                            local sensorNode = { }
                            sensorNode.node = sensorData.measurementNode
                            sensorNode.radius = 10
                            sensorNode.origRadius = sensorNode.radius

                            if linkNodeData.typeName = = "SENSOR_LEFT" then
                                sensorNode.shape = DensityMapPolygon.new()
                                sensorNode.shape:addPolygonPoint( 0 , 0 )
                                for i = math.rad( 110 ), math.rad( - 30 ), math.rad( - 30 ) do
                                    sensorNode.shape:addPolygonPoint( math.cos(i), math.sin(i))
                                end
                            elseif linkNodeData.typeName = = "SENSOR_RIGHT" then
                                    sensorNode.shape = DensityMapPolygon.new()
                                    sensorNode.shape:addPolygonPoint( 0 , 0 )
                                    for i = math.rad( 60 ), math.rad( 200 ), math.rad( 30 ) do
                                        sensorNode.shape:addPolygonPoint( math.cos(i), math.sin(i))
                                    end
                                end

                                sensorNode.requiresDaylight = sensorData.requiresDaylight
                                sensorNode.index = 1

                                table.insert( self [ CropSensor.SPEC_TABLE_NAME].sensorNodes, sensorNode)
                            end
                        end
                    end
                end
            end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function CropSensor:onDraw()
    if self.isClient then
        if not self:getIsAIActive() then
            local spec = self [ CropSensor.SPEC_TABLE_NAME]
            if spec.isAvailable and spec.isActive then
                for i = 1 , #spec.sensorNodes do
                    local sensorNode = spec.sensorNodes[i]
                    if sensorNode.requiresDaylight then
                        if not g_currentMission.environment.isSunOn then
                            g_currentMission:showBlinkingWarning(spec.texts.warningSensorDaylight, 1000 )
                        end
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
function CropSensor:onLoad(savegame)
    local spec = self [ CropSensor.SPEC_TABLE_NAME]

    local baseName = "vehicle.cropSensor"

    spec.sensorNodes = { }
    self.xmlFile:iterate(baseName .. ".sensorNode" , function (index, key)
        local sensorNode = { }
        sensorNode.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
        if sensorNode.node ~ = nil then
            sensorNode.radius = self.xmlFile:getValue(key .. "#radius" , 20 )
            sensorNode.origRadius = sensorNode.radius
            sensorNode.requiresDaylight = self.xmlFile:getValue(key .. "#requiresDaylight" , false )

            local shapeStr = string.upper( self.xmlFile:getValue(key .. "#shape" , "CIRCLE" ))
            if shapeStr = = "CIRCLE" then
                sensorNode.shape = DensityMapCircle.createCircle( 0 , 0 , sensorNode.radius, 8 )
            elseif shapeStr = = "HALF_CIRCLE_LEFT" then
                    sensorNode.shape = DensityMapPolygon.new()

                    for i = math.rad( - 30 ), math.rad( 110 ), math.rad( 30 ) do
                        sensorNode.shape:addPolygonPoint( math.cos(i), math.sin(i))
                    end
                elseif shapeStr = = "HALF_CIRCLE_RIGHT" then
                        sensorNode.shape = DensityMapPolygon.new()
                        for i = math.rad( 30 ), math.rad( - 110 ), math.rad( - 30 ) do
                            sensorNode.shape:addPolygonPoint( math.cos(i), math.sin(i))
                        end
                    end

                    if sensorNode.shape ~ = nil then
                        sensorNode.lightNode = self.xmlFile:getValue(key .. "#lightNode" , nil , self.components, self.i3dMappings)
                        if sensorNode.lightNode ~ = nil then
                            setVisibility(sensorNode.lightNode, false )
                        end

                        sensorNode.staticLight = self.xmlFile:getValue(key .. "#staticLight" , nil , self.components, self.i3dMappings)
                        if sensorNode.staticLight ~ = nil then
                            setShaderParameter(sensorNode.staticLight, "lightIds0" , 0 , 0 , 0 , 0 , false )
                        end

                        sensorNode.index = 1

                        table.insert(spec.sensorNodes, sensorNode)
                    else
                            Logging.xmlWarning( self.xmlFile, "Invalid sensor shape '%s' in '%s'" , shapeStr, key)
                        end
                    end
                end )

                spec.isStandaloneSensor = #spec.sensorNodes > 0
                spec.inputActionToggle = InputAction.PRECISIONFARMING_TOGGLE_CROP_SENSOR

                local configIndex = self.configurations[ "cropSensor" ]
                if configIndex ~ = nil then
                    local configKey = string.format( "vehicle.cropSensor.cropSensorConfigurations.cropSensorConfiguration(%d)" , configIndex - 1 )

                    spec.sensorLinkNodeData = { }
                    spec.sensorLinkNodeData.linkNodes = { }
                    self.xmlFile:iterate(configKey .. ".sensorLinkNode" , function (index, key)
                        local linkNode = { }
                        linkNode.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
                        if linkNode.node ~ = nil then
                            linkNode.typeName = string.upper( self.xmlFile:getValue(key .. "#type" , "SENSOR_LEFT" ))
                            linkNode.translation = self.xmlFile:getValue(key .. "#translation" , "0 0 0" , true )
                            linkNode.rotation = self.xmlFile:getValue(key .. "#rotation" , "0 0 0" , true )

                            linkNode.rotationNodes = { }
                            self.xmlFile:iterate(key .. ".rotationNode" , function (_, rotationNodeKey)
                                local rotatioNode = { }
                                rotatioNode.autoRotate = self.xmlFile:getValue(rotationNodeKey .. "#autoRotate" )
                                rotatioNode.rotation = self.xmlFile:getValue(rotationNodeKey .. "#rotation" , nil , true )

                                table.insert(linkNode.rotationNodes, rotatioNode)
                            end )

                            table.insert(spec.sensorLinkNodeData.linkNodes, linkNode)
                        end
                    end )

                    if #spec.sensorLinkNodeData.linkNodes > 0 then
                        self:linkCropSensor(spec.sensorLinkNodeData)
                    end

                    if configIndex > 1 then
                        if g_precisionFarming ~ = nil then
                            local linkData = g_precisionFarming:getCropSensorLinkageData( self.configFileName)
                            if linkData ~ = nil then
                                self:linkCropSensor(linkData)
                            end
                        end
                    end
                end

                spec.isAvailable = #spec.sensorNodes > 0
                spec.isActive = false

                spec.workingWidth = 0

                if spec.isAvailable then
                    spec.texts = { }
                    spec.texts.toggleCropSensorPos = g_i18n:getText( "action_toggleCropSensorPos" , self.customEnvironment)
                    spec.texts.toggleCropSensorNeg = g_i18n:getText( "action_toggleCropSensorNeg" , self.customEnvironment)
                    spec.texts.warningSensorDaylight = g_i18n:getText( "warning_sensorRequiresDaylight" , self.customEnvironment)

                    if g_precisionFarming ~ = nil then
                        spec.soilMap = g_precisionFarming.soilMap
                        spec.coverMap = g_precisionFarming.coverMap
                        spec.nitrogenMap = g_precisionFarming.nitrogenMap
                        spec.farmlandStatistics = g_precisionFarming.farmlandStatistics
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
function CropSensor:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self [ CropSensor.SPEC_TABLE_NAME]
        if spec.isAvailable then
            self:clearActionEventsTable(spec.actionEvents)
            if isActiveForInputIgnoreSelection then
                local _, actionEventId = self:addActionEvent(spec.actionEvents, spec.inputActionToggle, self , CropSensor.actionEventToggle, false , true , false , true , nil )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
                CropSensor.updateActionEventTexts( self )
            end
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
function CropSensor:onRootVehicleChanged(rootVehicle)
    if self.isServer then
        local spec = self [ CropSensor.SPEC_TABLE_NAME]
        if spec.isAvailable then
            local actionController = rootVehicle.actionController
            if actionController ~ = nil then
                if spec.controlledAction ~ = nil then
                    spec.controlledAction:updateParent(actionController)
                    return
                end

                spec.controlledAction = actionController:registerAction( "cropSensorTurnOn" , nil , 1 )
                spec.controlledAction:setCallback( self , CropSensor.actionControllerToggleEvent)
                spec.controlledAction:setFinishedFunctions( self , function () return spec.isActive end , true , false )
                spec.controlledAction:setIsSaved( true )

                spec.controlledAction:addAIEventListener( self , "onAIFieldWorkerStart" , 1 )
                spec.controlledAction:addAIEventListener( self , "onAIFieldWorkerEnd" , - 1 )

                spec.controlledAction:addAIEventListener( self , "onAIImplementStart" , 1 )
                spec.controlledAction:addAIEventListener( self , "onAIImplementEnd" , - 1 )
            else
                    if spec.controlledAction ~ = nil then
                        spec.controlledAction:remove()
                    end
                end
            end
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
function CropSensor:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self [ CropSensor.SPEC_TABLE_NAME]
        if spec.isAvailable and spec.isActive then
            for i = 1 , #spec.sensorNodes do
                local sensorNode = spec.sensorNodes[i]
                if not sensorNode.requiresDaylight or g_currentMission.environment.isSunOn then
                    self:updateSensorNode(sensorNode)
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
function CropSensor.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( PrecisionFarmingStatistic , specializations)
end

```

### setCropSensorActive

**Description**

**Definition**

> setCropSensorActive()

**Arguments**

| any | state       |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function CropSensor:setCropSensorActive(state, noEventSend)
    local spec = self [ CropSensor.SPEC_TABLE_NAME]
    if state = = nil then
        state = not spec.isActive
    end

    if state ~ = spec.isActive then
        if self.isClient then
            for i = 1 , #spec.sensorNodes do
                local sensorNode = spec.sensorNodes[i]
                if sensorNode.lightNode ~ = nil then
                    setVisibility(sensorNode.lightNode, state)
                end
                if sensorNode.staticLight ~ = nil then
                    setShaderParameter(sensorNode.staticLight, "lightIds0" , state and 0.2 or 0 , 0 , 0 , 0 , false )
                end
            end
        end

        if state then
            self:updateCropSensorWorkingWidth()
        end

        spec.isActive = state

        CropSensor.updateActionEventTexts( self )
        CropSensorStateEvent.sendEvent( self , state, noEventSend)
    end
end

```

### updateActionEventTexts

**Description**

**Definition**

> updateActionEventTexts()

**Arguments**

| any | self |
|-----|------|

**Code**

```lua
function CropSensor.updateActionEventTexts( self )
    local spec = self [ CropSensor.SPEC_TABLE_NAME]
    local actionEvent = spec.actionEvents[spec.inputActionToggle]
    if actionEvent ~ = nil then
        g_inputBinding:setActionEventText(actionEvent.actionEventId, spec.isActive and spec.texts.toggleCropSensorNeg or spec.texts.toggleCropSensorPos)
    end
end

```

### updateCropSensorWorkingWidth

**Description**

**Definition**

> updateCropSensorWorkingWidth()

**Code**

```lua
function CropSensor:updateCropSensorWorkingWidth()
    local spec = self [ CropSensor.SPEC_TABLE_NAME]
    spec.workingWidth = CropSensor.getMaxWorkingWidth( self )

    for i = 1 , #spec.sensorNodes do
        local sensorNode = spec.sensorNodes[i]
        self:updateSensorRadius(sensorNode, spec.workingWidth)
    end
end

```

### updateSensorNode

**Description**

**Definition**

> updateSensorNode()

**Arguments**

| any | sensorNode |
|-----|------------|

**Code**

```lua
function CropSensor:updateSensorNode(sensorNode)
    local spec = self [ CropSensor.SPEC_TABLE_NAME]

    if sensorNode.shape:isa(DensityMapCircle) then
        local x, _, z = getWorldTranslation(sensorNode.node)
        sensorNode.shape:updateFromWorldPosition(x, z, sensorNode.radius, 8 )
    elseif sensorNode.shape:isa(DensityMapPolygon) then
            local x, _, z = getWorldTranslation(sensorNode.node)
            local dirX, _, dirZ = localDirectionToWorld(sensorNode.node, 0 , 0 , 1 )
            dirX, dirZ = MathUtil.vector2Normalize(dirX, dirZ)
            sensorNode.shape:updateOrigin(x, z, dirX, dirZ)
            sensorNode.shape:updateScale(sensorNode.radius, sensorNode.radius)
        end

        spec.nitrogenMap:updateCropSensorArea(sensorNode.shape)
    end

```

### updateSensorRadius

**Description**

**Definition**

> updateSensorRadius()

**Arguments**

| any | sensorNode   |
|-----|--------------|
| any | workingWidth |

**Code**

```lua
function CropSensor:updateSensorRadius(sensorNode, workingWidth)
    if workingWidth > 0 then
        local xOffset, _, _ = localToLocal(sensorNode.node, self.rootNode, 0 , 0 , 0 )

        -- 10% wider as the working width
        workingWidth = workingWidth * 1.1

        sensorNode.radius = math.max(workingWidth / 2 - math.abs(xOffset), CropSensor.MIN_SENSOR_RADIUS)
    else
            sensorNode.radius = sensorNode.origRadius
        end
    end

```