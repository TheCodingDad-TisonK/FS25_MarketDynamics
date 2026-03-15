## CrabSteering

**Description**

> Class for vehicles with variable steering modes (e.g. all wheel steering, crab steering, back wheel steering)

**Functions**

- [actionEventSetCrabSteeringMode](#actioneventsetcrabsteeringmode)
- [actionEventToggleCrabSteeringModes](#actioneventtogglecrabsteeringmodes)
- [getAIAutomaticSteeringLookAheadDistance](#getaiautomaticsteeringlookaheaddistance)
- [getCanBeSelected](#getcanbeselected)
- [getCanToggleCrabSteering](#getcantogglecrabsteering)
- [initSpecialization](#initspecialization)
- [loadCrabSteeringModeFromXML](#loadcrabsteeringmodefromxml)
- [loadWheelFromXML](#loadwheelfromxml)
- [loadWheelsFromXML](#loadwheelsfromxml)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRegisterDashboardValueTypes](#onregisterdashboardvaluetypes)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerSteeringModeXMLPaths](#registersteeringmodexmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setCrabSteering](#setcrabsteering)
- [startFieldWorker](#startfieldworker)
- [updateArticulatedAxisRotation](#updatearticulatedaxisrotation)
- [updateSteeringAngle](#updatesteeringangle)
- [updateSteeringWheel](#updatesteeringwheel)

### actionEventSetCrabSteeringMode

**Description**

**Definition**

> actionEventSetCrabSteeringMode()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function CrabSteering.actionEventSetCrabSteeringMode( self , actionName, inputValue, callbackState, isAnalog)
    local isAllowed, warning = self:getCanToggleCrabSteering()
    if isAllowed then
        local spec = self.spec_crabSteering
        local state = spec.state

        for i, mode in pairs(spec.steeringModes) do
            if mode.inputAction = = InputAction[actionName] then
                state = i
                break
            end
        end

        if state ~ = spec.state then
            if self:getCrabSteeringModeAvailable(spec.steeringModes[state]) then
                self:setCrabSteering(state)
            end
        end
    elseif warning ~ = nil then
            g_currentMission:showBlinkingWarning(warning, 2000 )
        end
    end

```

### actionEventToggleCrabSteeringModes

**Description**

**Definition**

> actionEventToggleCrabSteeringModes()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function CrabSteering.actionEventToggleCrabSteeringModes( self , actionName, inputValue, callbackState, isAnalog)
    local isAllowed, warning = self:getCanToggleCrabSteering()
    if isAllowed then
        self:setNextCrabSteeringMode(callbackState)
    elseif warning ~ = nil then
            g_currentMission:showBlinkingWarning(warning, 2000 )
        end
    end

```

### getAIAutomaticSteeringLookAheadDistance

**Description**

**Definition**

> getAIAutomaticSteeringLookAheadDistance()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function CrabSteering:getAIAutomaticSteeringLookAheadDistance(superFunc)
    if self.spec_crabSteering.hasSteeringModes then
        local spec = self.spec_crabSteering
        local currentMode = spec.steeringModes[spec.state]
        if currentMode.automaticSteeringLookAheadDistance ~ = nil then
            return currentMode.automaticSteeringLookAheadDistance
        end
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
function CrabSteering:getCanBeSelected(superFunc)
    return self.spec_crabSteering.hasSteeringModes or superFunc( self )
end

```

### getCanToggleCrabSteering

**Description**

> Returns if it's allowed to toggle crab steering

**Definition**

> getCanToggleCrabSteering()

**Return Values**

| any | isAllowed | is allowed              |
|-----|-----------|-------------------------|
| any | warning   | warning to be displayed |

**Code**

```lua
function CrabSteering:getCanToggleCrabSteering()
    return true , nil
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function CrabSteering.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "CrabSteering" )

    schema:register(XMLValueType.FLOAT, "vehicle.crabSteering#distFromCompJointToCenterOfBackWheels" , "Distance from component joint to center of back wheels" )
    schema:register(XMLValueType.FLOAT, "vehicle.crabSteering#aiSteeringModeIndex" , "AI steering mode index" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.crabSteering#toggleSpeedFactor" , "Toggle speed factor" , 1 )

    CrabSteering.registerSteeringModeXMLPaths(schema, "vehicle.crabSteering.steeringMode(?)" )
    CrabSteering.registerSteeringModeXMLPaths(schema, "vehicle.crabSteering.crabSteeringConfiguration(?).steeringMode(?)" )

    Dashboard.registerDashboardXMLPaths(schema, "vehicle.crabSteering.dashboards" , { "state" } )

    Dashboard.addDelayedRegistrationFunc(schema, function (cSchema, cKey)
        cSchema:register(XMLValueType.VECTOR_N, cKey .. "#states" , "Crab steering states which activate the dashboard" )
    end )

    schema:register(XMLValueType.INT, "vehicle.wheels.wheelConfigurations.wheelConfiguration(?).wheels#crabSteeringIndex" , "Crab steering configuration index" )

    schema:setXMLSpecializationType()

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?).crabSteering#state" , "Current steering mode" , 1 )
end

```

### loadCrabSteeringModeFromXML

**Description**

**Definition**

> loadCrabSteeringModeFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | mode    |

**Code**

```lua
function CrabSteering:loadCrabSteeringModeFromXML(xmlFile, key, mode)
    mode.name = self.xmlFile:getValue(key .. "#name" , "" , self.customEnvironment, false )

    local inputBindingName = self.xmlFile:getValue(key .. "#inputBindingName" )
    if inputBindingName ~ = nil then
        if InputAction[inputBindingName] ~ = nil then
            mode.inputAction = InputAction[inputBindingName]
        else
                Logging.xmlWarning( self.xmlFile, "Invalid inputBindingname '%s' for '%s'" , tostring(inputBindingName), key)
                end
            end

            mode.steeringCenterNode = self.xmlFile:getValue(key .. ".steeringCenter#node" , nil , self.components, self.i3dMappings)
            mode.turningRadius = self.xmlFile:getValue(key .. ".steeringCenter#turningRadius" )

            mode.automaticSteeringLookAheadDistance = self.xmlFile:getValue(key .. ".aiAutomaticSteering#lookAheadDistance" )

            mode.wheels = { }
            for _, wheelKey in self.xmlFile:iterator(key .. ".wheel" ) do
                local wheelEntry = { }
                wheelEntry.wheelIndex = self.xmlFile:getValue(wheelKey .. "#index" )
                wheelEntry.wheelNode = self.xmlFile:getValue(wheelKey .. "#node" , nil , self.components, self.i3dMappings)
                if wheelEntry.wheelNode ~ = nil then
                    local wheel = self:getWheelByWheelNode(wheelEntry.wheelNode)
                    if wheel ~ = nil then
                        if wheel.physics.rotSpeed ~ = 0 then
                            wheelEntry.wheelIndex = wheel.wheelIndex
                            wheelEntry.wheel = wheel
                        else
                                Logging.xmlError( self.xmlFile, "Invalid wheel node '%s' for '%s'.Wheel needs to have a rotSpeed defined!" , self.xmlFile:getString(wheelKey .. "#node" ), wheelKey)
                                    continue
                                end
                            else
                                    Logging.xmlError( self.xmlFile, "Invalid wheel node '%s' for '%s'" , self.xmlFile:getString(wheelKey .. "#node" ), wheelKey)
                                        continue
                                    end
                                end

                                wheelEntry.offset = self.xmlFile:getValue(wheelKey .. "#offset" , 0 )
                                wheelEntry.locked = self.xmlFile:getValue(wheelKey .. "#locked" , false )

                                if wheelEntry.wheelIndex ~ = nil then
                                    wheelEntry.wheel = self:getWheelFromWheelIndex(wheelEntry.wheelIndex)

                                    if wheelEntry.wheel = = nil then
                                        Logging.xmlError( self.xmlFile, "Invalid wheel '%s' for '%s'" , tostring(wheelEntry.wheelIndex), wheelKey)
                                            continue
                                        end
                                    end

                                    table.insert(mode.wheels, wheelEntry)
                                end

                                mode.steeringNodes = { }
                                for _, steeringNodeKey in self.xmlFile:iterator(key .. ".steeringNode" ) do
                                    local steeringNodeEntry = { }
                                    steeringNodeEntry.node = self.xmlFile:getValue(steeringNodeKey .. "#node" , nil , self.components, self.i3dMappings)
                                    if steeringNodeEntry.node ~ = nil then
                                        local steeringNode = self:getSteeringNodeByNode(steeringNodeEntry.node)
                                        if steeringNode ~ = nil then
                                            steeringNodeEntry.steeringNode = steeringNode

                                            steeringNodeEntry.offset = self.xmlFile:getValue(steeringNodeKey .. "#offset" , 0 )
                                            steeringNodeEntry.locked = self.xmlFile:getValue(steeringNodeKey .. "#locked" , false )
                                            steeringNodeEntry.rotScale = self.xmlFile:getValue(steeringNodeKey .. "#rotScale" )

                                            table.insert(mode.steeringNodes, steeringNodeEntry)
                                        else
                                                Logging.xmlError( self.xmlFile, "Invalid steering node '%s' for '%s'" , getName(steeringNodeEntry.node), steeringNodeKey)
                                                end
                                            end
                                        end

                                        mode.nodes = { }
                                        for _, nodeKey in self.xmlFile:iterator(key .. ".node" ) do
                                            local nodeEntry = { }
                                            nodeEntry.node = self.xmlFile:getValue(nodeKey .. "#node" , nil , self.components, self.i3dMappings)
                                            if nodeEntry.node ~ = nil then
                                                nodeEntry.rotation = self.xmlFile:getValue(nodeKey .. "#rotation" , nil , true )
                                                nodeEntry.translation = self.xmlFile:getValue(nodeKey .. "#translation" , nil , true )

                                                table.insert(mode.nodes, nodeEntry)
                                            end
                                        end

                                        local specArticulatedAxis = self.spec_articulatedAxis
                                        if specArticulatedAxis ~ = nil and specArticulatedAxis.componentJoint ~ = nil then
                                            mode.articulatedAxis = { }
                                            mode.articulatedAxis.rotSpeedBackUp = specArticulatedAxis.rotSpeed
                                            mode.articulatedAxis.offset = self.xmlFile:getValue(key .. ".articulatedAxis#offset" , 0 )
                                            mode.articulatedAxis.locked = self.xmlFile:getValue(key .. ".articulatedAxis#locked" , false )
                                            mode.articulatedAxis.wheelIndices = self.xmlFile:getValue(key .. ".articulatedAxis#wheelIndices" , nil , true )
                                        end

                                        mode.animations = { }
                                        for _, animKey in self.xmlFile:iterator(key .. ".animation" ) do
                                            local animation = { }
                                            animation.animName = self.xmlFile:getValue(animKey .. "#name" )
                                            animation.animSpeed = self.xmlFile:getValue(animKey .. "#speed" , 1.0 )
                                            animation.stopTime = self.xmlFile:getValue(animKey .. "#stopTime" )

                                            if animation.animName ~ = nil and self:getAnimationExists(animation.animName) then
                                                table.insert(mode.animations, animation)
                                            else
                                                    Logging.xmlWarning( self.xmlFile, "Invalid animation '%s' for '%s'" , tostring(animation.animName), animKey)
                                                    end
                                                end

                                                local node = self.xmlFile:getValue(key .. ".steeringWheel#node" , nil , self.components, self.i3dMappings)
                                                if node ~ = nil then
                                                    mode.steeringWheel = { }
                                                    mode.steeringWheel.node = node
                                                    local _,ry,_ = getRotation(mode.steeringWheel.node)
                                                    mode.steeringWheel.lastRotation = ry
                                                    mode.steeringWheel.indoorRotation = self.xmlFile:getValue(key .. ".steeringWheel#indoorRotation" , 0 )
                                                    mode.steeringWheel.outdoorRotation = self.xmlFile:getValue(key .. ".steeringWheel#outdoorRotation" , 0 )
                                                end

                                                return true
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
function CrabSteering:loadWheelFromXML(superFunc, wheel)
    if not superFunc( self , wheel) then
        return false
    end

    wheel.steeringOffset = 0
    wheel.forceSteeringAngleUpdate = true

    return true
end

```

### loadWheelsFromXML

**Description**

**Definition**

> loadWheelsFromXML()

**Arguments**

| any | superFunc           |
|-----|---------------------|
| any | xmlFile             |
| any | key                 |
| any | wheelConfigurationI |

**Code**

```lua
function CrabSteering:loadWheelsFromXML(superFunc, xmlFile, key, wheelConfigurationI)
    superFunc( self , xmlFile, key, wheelConfigurationI)

    self.spec_crabSteering.configurationIndex = WheelXMLObject.getValueStatic( self.spec_wheels.wheelConfigurationId, self.spec_wheels.configurationIndexToParentConfigIndex, self.xmlFile, Wheels.CONFIG_XML_PATH, ".wheels" , "#crabSteeringIndex" )
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
function CrabSteering:onLoad(savegame)
    local spec = self.spec_crabSteering

    spec.state = 1
    spec.stateMax = - 1

    spec.configurationIndex = spec.configurationIndex or 1

    spec.distFromCompJointToCenterOfBackWheels = self.xmlFile:getValue( "vehicle.crabSteering#distFromCompJointToCenterOfBackWheels" )
    spec.aiSteeringModeIndex = self.xmlFile:getValue( "vehicle.crabSteering#aiSteeringModeIndex" , 1 )
    spec.toggleSpeedFactor = self.xmlFile:getValue( "vehicle.crabSteering#toggleSpeedFactor" , 1 )

    spec.currentArticulatedAxisOffset = 0
    spec.articulatedAxisOffsetChanged = false
    spec.articulatedAxisLastAngle = 0
    spec.articulatedAxisChangingTime = 0

    local baseKey = "vehicle.crabSteering"
    local configKey = string.format( "vehicle.crabSteering.crabSteeringConfiguration(%d)" , spec.configurationIndex - 1 )
    if self.xmlFile:hasProperty(configKey) then
        baseKey = configKey
    end

    spec.steeringModes = { }
    for _, key in self.xmlFile:iterator(baseKey .. ".steeringMode" ) do
        local mode = { }
        if self:loadCrabSteeringModeFromXML( self.xmlFile, key, mode) then
            table.insert(spec.steeringModes, mode)
            mode.index = #spec.steeringModes
        end
    end

    spec.stateMax = #spec.steeringModes
    if spec.stateMax > (( 2 ^ CrabSteering.STEERING_SEND_NUM_BITS) - 1 ) then
        Logging.xmlError( self.xmlFile, "CrabSteering only supports %d steering modes!" , ( 2 ^ CrabSteering.STEERING_SEND_NUM_BITS) - 1 )
    end

    spec.hasSteeringModes = spec.stateMax > 0

    if spec.hasSteeringModes then
        self.customSteeringAngleFunction = true

        spec.hudExtension = CrabSteeringHUDExtension.new( self )

        self:setCrabSteering( 1 , true )
    else
            SpecializationUtil.removeEventListener( self , "onReadStream" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onWriteStream" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onReadUpdateStream" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onWriteUpdateStream" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onUpdateTick" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onDraw" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onAIImplementStart" , CrabSteering )
            SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , CrabSteering )
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
function CrabSteering:onPostLoad(savegame)
    if savegame ~ = nil and not savegame.resetVehicles then
        local spec = self.spec_crabSteering
        if spec.hasSteeringModes then
            if savegame.xmlFile:hasProperty(savegame.key .. ".crabSteering" ) then
                local state = savegame.xmlFile:getValue(savegame.key .. ".crabSteering#state" , 1 )
                state = math.clamp(state, 1 , spec.stateMax)

                self:setCrabSteering(state, true )
                AnimatedVehicle.updateAnimations( self , 99999999 , true )
                self:forceUpdateWheelPhysics( 99999999 )
            end
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
function CrabSteering:onReadStream(streamId, connection)
    local state = streamReadUIntN(streamId, CrabSteering.STEERING_SEND_NUM_BITS)

    self:setCrabSteering(state, true )
    AnimatedVehicle.updateAnimations( self , 99999999 , true )
    self:forceUpdateWheelPhysics( 99999999 )
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
function CrabSteering:onReadUpdateStream(streamId, timestamp, connection)
    local specArticulatedAxis = self.spec_articulatedAxis
    if specArticulatedAxis ~ = nil and specArticulatedAxis.componentJoint ~ = nil then
        specArticulatedAxis.curRot = streamReadFloat32(streamId)
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
function CrabSteering:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_crabSteering
        if spec.hasSteeringModes then
            self:clearActionEventsTable(spec.actionEvents)

            if isActiveForInputIgnoreSelection then
                local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.TOGGLE_CRABSTEERING, self , CrabSteering.actionEventToggleCrabSteeringModes, false , true , false , true , 1 )
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)

                for _, mode in pairs(spec.steeringModes) do
                    if mode.inputAction ~ = nil then
                        _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, mode.inputAction, self , CrabSteering.actionEventSetCrabSteeringMode, false , true , false , true , nil )
                        g_inputBinding:setActionEventTextVisibility(actionEventId, false )
                        g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
                    end
                end

                _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.TOGGLE_CRABSTEERING_BACK, self , CrabSteering.actionEventToggleCrabSteeringModes, false , true , false , true , - 1 )
                g_inputBinding:setActionEventTextVisibility(actionEventId, false )
            end
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
function CrabSteering:onRegisterDashboardValueTypes()
    local spec = self.spec_crabSteering

    local state = DashboardValueType.new( "crabSteering" , "state" )
    state:setValue(spec, function (_, dashboard)
        if dashboard.crabSteeringStates ~ = nil then
            local isStateActive = false
            for _, state in pairs(dashboard.crabSteeringStates) do
                if spec.state = = state then
                    isStateActive = true
                end
            end

            return isStateActive
        else
                return spec.state
            end
        end )
        state:setAdditionalFunctions( function ( self , xmlFile, key, dashboard, isActive)
            dashboard.crabSteeringStates = xmlFile:getValue(key .. "#states" , nil , true )

            return true
        end )
        state:setPollUpdate( false )
        self:registerDashboardValueType(state)
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
function CrabSteering:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self.spec_crabSteering
        if not self:getCrabSteeringModeAvailable(spec.steeringModes[spec.state]) then
            self:setNextCrabSteeringMode( 1 )
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
function CrabSteering:onWriteStream(streamId, connection)
    local spec = self.spec_crabSteering
    streamWriteUIntN(streamId, spec.state, CrabSteering.STEERING_SEND_NUM_BITS)
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
function CrabSteering:onWriteUpdateStream(streamId, connection, dirtyMask)
    local specArticulatedAxis = self.spec_articulatedAxis
    if specArticulatedAxis ~ = nil and specArticulatedAxis.componentJoint ~ = nil then
        streamWriteFloat32(streamId, specArticulatedAxis.curRot)
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
function CrabSteering.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Drivable , specializations)
    and SpecializationUtil.hasSpecialization( Wheels , specializations)
    and SpecializationUtil.hasSpecialization( AnimatedVehicle , specializations)
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
function CrabSteering.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterDashboardValueTypes" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , CrabSteering )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , CrabSteering )
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
function CrabSteering.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadCrabSteeringModeFromXML" , CrabSteering.loadCrabSteeringModeFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getCanToggleCrabSteering" , CrabSteering.getCanToggleCrabSteering)
    SpecializationUtil.registerFunction(vehicleType, "getCrabSteeringModeAvailable" , CrabSteering.getCrabSteeringModeAvailable)
    SpecializationUtil.registerFunction(vehicleType, "getNumCrabSteeringModesAvailable" , CrabSteering.getNumCrabSteeringModesAvailable)
    SpecializationUtil.registerFunction(vehicleType, "setCrabSteering" , CrabSteering.setCrabSteering)
    SpecializationUtil.registerFunction(vehicleType, "getCrabSteeringMode" , CrabSteering.getCrabSteeringMode)
    SpecializationUtil.registerFunction(vehicleType, "setNextCrabSteeringMode" , CrabSteering.setNextCrabSteeringMode)
    SpecializationUtil.registerFunction(vehicleType, "updateArticulatedAxisRotation" , CrabSteering.updateArticulatedAxisRotation)
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
function CrabSteering.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWheelFromXML" , CrabSteering.loadWheelFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateSteeringAngle" , CrabSteering.updateSteeringAngle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , CrabSteering.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadWheelsFromXML" , CrabSteering.loadWheelsFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateSteeringWheel" , CrabSteering.updateSteeringWheel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "startFieldWorker" , CrabSteering.startFieldWorker)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIAutomaticSteeringLookAheadDistance" , CrabSteering.getAIAutomaticSteeringLookAheadDistance)
end

```

### registerSteeringModeXMLPaths

**Description**

**Definition**

> registerSteeringModeXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function CrabSteering.registerSteeringModeXMLPaths(schema, basePath)
    schema:addDelayedRegistrationPath(basePath, "CrabSteering:steeringMode" )

    schema:register(XMLValueType.L10N_STRING, basePath .. "#name" , "Steering mode name" )
    schema:register(XMLValueType.STRING, basePath .. "#inputBindingName" , "Input action name" )
    schema:register(XMLValueType.INT, basePath .. ".wheel(?)#index" , "Wheel Index" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".wheel(?)#node" , "Wheel Node" )
    schema:register(XMLValueType.ANGLE, basePath .. ".wheel(?)#offset" , "Rotation offset" , 0 )
    schema:register(XMLValueType.BOOL, basePath .. ".wheel(?)#locked" , "Steering is locked" , false )

    schema:register(XMLValueType.NODE_INDEX, basePath .. ".steeringCenter#node" , "Custom steering center node" )
    schema:register(XMLValueType.FLOAT, basePath .. ".steeringCenter#turningRadius" , "Turning radius to use with custom steering node" )

    schema:register(XMLValueType.FLOAT, basePath .. ".aiAutomaticSteering#lookAheadDistance" , "Distance for aiming onto the wayline when this steering mode is active" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".steeringNode(?)#node" , "Steering node" )
        schema:register(XMLValueType.ANGLE, basePath .. ".steeringNode(?)#offset" , "Rotation offset" , 0 )
        schema:register(XMLValueType.BOOL, basePath .. ".steeringNode(?)#locked" , "Steering is locked" , false )
        schema:register(XMLValueType.FLOAT, basePath .. ".steeringNode(?)#rotScale" , "Scale of rotation" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".node(?)#node" , "Node to adjust when the steering mode is active" )
        schema:register(XMLValueType.VECTOR_ROT, basePath .. ".node(?)#rotation" , "Rotation when steering mode is active" )
        schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".node(?)#translation" , "Translation when steering mode is active" )

        schema:register(XMLValueType.ANGLE, basePath .. ".articulatedAxis#offset" , "Articulated axis offset angle" , 0 )
        schema:register(XMLValueType.BOOL, basePath .. ".articulatedAxis#locked" , "Articulated axis is locked" , false )
        schema:register(XMLValueType.VECTOR_N, basePath .. ".articulatedAxis#wheelIndices" , "Wheel indices" )

        schema:register(XMLValueType.STRING, basePath .. ".animation(?)#name" , "Change animation name" )
        schema:register(XMLValueType.FLOAT, basePath .. ".animation(?)#speed" , "Animation speed" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. ".animation(?)#stopTime" , "Animation stop time" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".steeringWheel#node" , "Steering wheel node" )
        schema:register(XMLValueType.ANGLE, basePath .. ".steeringWheel#indoorRotation" , "Steering wheel indoor rotation" , 0 )
        schema:register(XMLValueType.ANGLE, basePath .. ".steeringWheel#outdoorRotation" , "Steering wheel outdoor rotation" , 0 )
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
function CrabSteering:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_crabSteering
    if spec.hasSteeringModes then
        xmlFile:setValue(key .. "#state" , spec.state)
    end
end

```

### setCrabSteering

**Description**

> Change crap steering mode

**Definition**

> setCrabSteering(integer state, boolean noEventSend)

**Arguments**

| integer | state       | new state     |
|---------|-------------|---------------|
| boolean | noEventSend | no event send |

**Code**

```lua
function CrabSteering:setCrabSteering(state, noEventSend)
    local spec = self.spec_crabSteering

    if noEventSend = = nil or noEventSend = = false then
        if g_server ~ = nil then
            g_server:broadcastEvent( SetCrabSteeringEvent.new( self , state), nil , nil , self )
        else
                g_client:getServerConnection():sendEvent( SetCrabSteeringEvent.new( self , state))
            end
        end

        if state ~ = spec.state then
            local currentMode = spec.steeringModes[spec.state]
            if currentMode.animations ~ = nil then
                for _,anim in pairs(currentMode.animations) do
                    local curTime = self:getAnimationTime(anim.animName)
                    if anim.stopTime = = nil then
                        self:playAnimation(anim.animName, - anim.animSpeed, curTime, noEventSend)
                    end
                end
            end
            local newMode = spec.steeringModes[state]
            if newMode.animations ~ = nil then
                for _,anim in pairs(newMode.animations) do
                    local curTime = self:getAnimationTime(anim.animName)
                    if anim.stopTime ~ = nil then
                        self:setAnimationStopTime(anim.animName, anim.stopTime)
                        local speed = 1.0
                        if curTime > anim.stopTime then
                            speed = - 1.0
                        end
                        self:playAnimation(anim.animName, speed, curTime, noEventSend)
                    else
                            self:playAnimation(anim.animName, anim.animSpeed, curTime, noEventSend)
                        end
                    end
                end

                for _, steeringNodeData in pairs(newMode.steeringNodes) do
                    local steeringNode = steeringNodeData.steeringNode

                    steeringNode.offsetTarget = steeringNodeData.offset
                    steeringNode.offsetTargetSpeed = math.abs(steeringNode.offsetTarget - steeringNode.offset) / (( 1 / spec.toggleSpeedFactor) * 1000 )

                    if steeringNodeData.locked then
                        steeringNode.rotScaleTarget = 0
                    else
                            steeringNode.rotScaleTarget = steeringNodeData.rotScale or steeringNode.rotScaleOrig
                        end

                        if newMode.steeringCenterNode ~ = nil then
                            self.spec_wheels.steeringCenterNode = newMode.steeringCenterNode
                            self:setAIRootNodeDirty()

                            local rotMin, rotMax, inverted = Wheels.getAckermannSteeringAngles(steeringNode.node, newMode.steeringCenterNode, newMode.turningRadius or self.spec_wheels.maxTurningRadius)

                            steeringNode.rotMin, steeringNode.rotMax = rotMin, rotMax
                            steeringNode.rotSpeed, steeringNode.rotSpeedNeg = rotMax / self.wheelSteeringDuration, - rotMin / self.wheelSteeringDuration
                            if inverted then
                                steeringNode.rotSpeed, steeringNode.rotSpeedNeg = - steeringNode.rotSpeedNeg, - steeringNode.rotSpeed
                            end
                        else
                                steeringNode.rotMin, steeringNode.rotMax = steeringNode.rotMinOrig, steeringNode.rotMaxOrig
                                steeringNode.rotSpeed, steeringNode.rotSpeedNeg = steeringNode.rotSpeedOrig, steeringNode.rotSpeedNegOrig
                            end

                            steeringNode.rotScaleTargetSpeed = math.abs(steeringNode.rotScaleTarget - steeringNode.rotScale) / (( 1 / spec.toggleSpeedFactor) * 1000 )
                        end

                        for _, wheelProperties in pairs(newMode.wheels) do
                            wheelProperties.wheel.steeringOffset = wheelProperties.wheel.steeringOffset or 0
                            wheelProperties.wheel.steeringOffsetSpeed = math.abs(wheelProperties.offset - wheelProperties.wheel.steeringOffset) / (( 1 / spec.toggleSpeedFactor) * 1000 )
                        end

                        for _, node in ipairs(newMode.nodes) do
                            if node.rotation ~ = nil then
                                setRotation(node.node, node.rotation[ 1 ], node.rotation[ 2 ], node.rotation[ 3 ])
                            end
                            if node.translation ~ = nil then
                                setTranslation(node.node, node.translation[ 1 ], node.translation[ 2 ], node.translation[ 3 ])
                            end

                            if self.setMovingToolDirty ~ = nil then
                                self:setMovingToolDirty(node.node)
                            end
                        end
                    end

                    spec.state = state

                    if self.isClient then
                        if self.updateDashboardValueType ~ = nil then
                            self:updateDashboardValueType( "crabSteering.state" )
                        end
                    end
                end

```

### startFieldWorker

**Description**

**Definition**

> startFieldWorker()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function CrabSteering:startFieldWorker(superFunc)
    local spec = self.spec_crabSteering
    self:setCrabSteering(spec.aiSteeringModeIndex)

    return superFunc( self )
end

```

### updateArticulatedAxisRotation

**Description**

> Update articulated axis rotation

**Definition**

> updateArticulatedAxisRotation(float steeringAngle, float dt)

**Arguments**

| float | steeringAngle | steering angle             |
|-------|---------------|----------------------------|
| float | dt            | time since last call in ms |

**Return Values**

| float | steeringAngle | adjusted steering angle |
|-------|---------------|-------------------------|

**Code**

```lua
function CrabSteering:updateArticulatedAxisRotation(steeringAngle, dt)
    local spec = self.spec_crabSteering
    local specArticulatedAxis = self.spec_articulatedAxis
    local specDriveable = self.spec_drivable

    if spec.stateMax = = 0 then
        return steeringAngle
    end

    if not self.isServer then
        return specArticulatedAxis.curRot
    end

    local currentMode = spec.steeringModes[spec.state]
    if currentMode.articulatedAxis = = nil then
        return steeringAngle
    end

    --
    local rotScale = math.min( 1.0 / ( self.lastSpeed * specDriveable.speedRotScale + specDriveable.speedRotScaleOffset), 1 )
    local delta = dt * 0.001 * self.autoRotateBackSpeed * rotScale * spec.toggleSpeedFactor

    if spec.currentArticulatedAxisOffset < currentMode.articulatedAxis.offset then
        spec.currentArticulatedAxisOffset = math.min(currentMode.articulatedAxis.offset, spec.currentArticulatedAxisOffset + delta)
    elseif spec.currentArticulatedAxisOffset > currentMode.articulatedAxis.offset then
            spec.currentArticulatedAxisOffset = math.max(currentMode.articulatedAxis.offset, spec.currentArticulatedAxisOffset - delta)
        end

        -- adjust rotSpeed
        if currentMode.articulatedAxis.locked then
            if specArticulatedAxis.rotSpeed > 0 then
                specArticulatedAxis.rotSpeed = math.max( 0 , specArticulatedAxis.rotSpeed - delta)
            elseif specArticulatedAxis.rotSpeed < 0 then
                    specArticulatedAxis.rotSpeed = math.min( 0 , specArticulatedAxis.rotSpeed + delta)
                end
            else
                    if specArticulatedAxis.rotSpeed > currentMode.articulatedAxis.rotSpeedBackUp then
                        specArticulatedAxis.rotSpeed = math.max(currentMode.articulatedAxis.rotSpeedBackUp, specArticulatedAxis.rotSpeed - delta)
                    elseif specArticulatedAxis.rotSpeed < currentMode.articulatedAxis.rotSpeedBackUp then
                            specArticulatedAxis.rotSpeed = math.min(currentMode.articulatedAxis.rotSpeedBackUp, specArticulatedAxis.rotSpeed + delta)
                        end
                    end

                    local rotSpeed
                    if ( self.rotatedTime) * (currentMode.articulatedAxis.rotSpeedBackUp) > 0 then
                        rotSpeed = (specArticulatedAxis.rotMax - spec.currentArticulatedAxisOffset) / self.wheelSteeringDuration
                    else
                            rotSpeed = (specArticulatedAxis.rotMin - spec.currentArticulatedAxisOffset) / self.wheelSteeringDuration
                        end

                        local f = math.abs(specArticulatedAxis.rotSpeed) / math.abs(currentMode.articulatedAxis.rotSpeedBackUp)
                        rotSpeed = rotSpeed * f

                        steeringAngle = spec.currentArticulatedAxisOffset + ( math.abs( self.rotatedTime) * rotSpeed)

                        -- change rotation just if wheels are moving(so you don't have to steer in the opposite direction while turning on crab steering)
                            if currentMode.articulatedAxis.wheelIndices ~ = nil and spec.distFromCompJointToCenterOfBackWheels ~ = nil and self.movingDirection > = 0 then
                                local wheels = self:getWheels()

                                local curRot = math.sign(currentMode.articulatedAxis.rotSpeedBackUp) * specArticulatedAxis.curRot

                                local alpha = 0
                                local count = 0
                                for _,wheelIndex in pairs(currentMode.articulatedAxis.wheelIndices) do
                                    alpha = alpha + wheels[wheelIndex].physics.steeringAngle
                                    count = count + 1
                                end
                                if count > 0 then
                                    alpha = alpha / count
                                end
                                alpha = alpha - curRot

                                local v = 0
                                count = 0
                                for _,wheelIndex in pairs(currentMode.articulatedAxis.wheelIndices) do
                                    local wheel = wheels[wheelIndex]
                                    local axleSpeed = getWheelShapeAxleSpeed(wheel.node, wheel.physics.wheelShape) -- rad/sec
                                    if wheel.physics.hasGroundContact then
                                        local longSlip, _ = getWheelShapeSlip(wheel.node, wheel.physics.wheelShape)
                                        local fac = 1.0 - math.min( 1.0 , longSlip)
                                        v = v + fac * axleSpeed * wheel.physics.radius
                                        count = count + 1
                                    end
                                end
                                if count > 0 then
                                    v = v / count
                                end
                                local h = v * 0.001 * dt
                                local g = math.sin(alpha) * h
                                local a = math.cos(alpha) * h
                                local ls = spec.distFromCompJointToCenterOfBackWheels
                                local beta = math.atan2(g, ls - a)

                                steeringAngle = math.sign(currentMode.articulatedAxis.rotSpeedBackUp) * (curRot + beta)

                                spec.articulatedAxisOffsetChanged = true
                                spec.articulatedAxisLastAngle = steeringAngle
                            else
                                    local changingTime = spec.articulatedAxisChangingTime
                                    if spec.articulatedAxisOffsetChanged then
                                        changingTime = 2500
                                        spec.articulatedAxisOffsetChanged = false
                                    end

                                    --smooth blending if steering change is from crab to normal
                                        if changingTime > 0 then
                                            local pos = changingTime / 2500
                                            steeringAngle = steeringAngle * ( 1 - pos) + spec.articulatedAxisLastAngle * pos
                                            spec.articulatedAxisChangingTime = changingTime - dt
                                        end
                                    end

                                    steeringAngle = math.max(specArticulatedAxis.rotMin, math.min(specArticulatedAxis.rotMax, steeringAngle))

                                    return steeringAngle
                                end

```

### updateSteeringAngle

**Description**

> Update steering angle depending of the selected steering mode

**Definition**

> updateSteeringAngle(table wheel, float dt, float steeringAngle, )

**Arguments**

| table | wheel         | wheel                      |
|-------|---------------|----------------------------|
| float | dt            | time since last call in ms |
| float | steeringAngle | steering angle             |
| any   | steeringAngle |                            |

**Return Values**

| any | steeringAngle | adjusted steering angle |
|-----|---------------|-------------------------|

**Code**

```lua
function CrabSteering:updateSteeringAngle(superFunc, wheel, dt, steeringAngle)
    local spec = self.spec_crabSteering
    local specDriveable = self.spec_drivable

    if spec.stateMax = = 0 then
        return superFunc( self , wheel, dt, steeringAngle)
    end

    local currentMode = spec.steeringModes[spec.state]
    for i = 1 , #currentMode.wheels do
        local wheelProperties = currentMode.wheels[i]
        if wheelProperties.wheelIndex = = wheel.wheelIndex then
            if wheel.rotSpeedBackUp = = nil then
                wheel.rotSpeedBackUp = wheel.physics.rotSpeed
            end

            if wheel.rotSpeedBackUp ~ = 0 then
                local rotScale = 0
                if self.lastSpeed ~ = 0 then
                    rotScale = math.min( 1.0 / ( self.lastSpeed * specDriveable.speedRotScale + specDriveable.speedRotScaleOffset), 1 )
                end

                local delta = dt * 0.001 * self.autoRotateBackSpeed * rotScale * spec.toggleSpeedFactor

                if wheel.steeringOffset ~ = wheelProperties.offset then
                    local direction = math.sign(wheelProperties.offset - wheel.steeringOffset)
                    local change = dt * wheelProperties.wheel.steeringOffsetSpeed * direction
                    local limit = direction > 0 and math.min or math.max
                    wheel.steeringOffset = limit(wheel.steeringOffset + change, wheelProperties.offset)
                end

                if not wheelProperties.locked then
                    local rotSpeed
                    if self.rotatedTime > 0 then
                        rotSpeed = (wheel.physics.rotMax - wheel.steeringOffset) / self.wheelSteeringDuration
                        if wheel.rotSpeedBackUp < 0 then
                            rotSpeed = (wheel.physics.rotMin - wheel.steeringOffset) / self.wheelSteeringDuration
                        end
                    else
                            rotSpeed = - (wheel.physics.rotMin - wheel.steeringOffset) / self.wheelSteeringDuration
                            if wheel.rotSpeedBackUp < 0 then
                                rotSpeed = - (wheel.physics.rotMax - wheel.steeringOffset) / self.wheelSteeringDuration
                            end
                        end

                        if wheel.physics.rotSpeed < wheel.rotSpeedBackUp then
                            wheel.physics.rotSpeed = math.min(wheel.rotSpeedBackUp, wheel.physics.rotSpeed + delta)
                        elseif wheel.physics.rotSpeed > wheel.rotSpeedBackUp then
                                wheel.physics.rotSpeed = math.max(wheel.rotSpeedBackUp, wheel.physics.rotSpeed - delta)
                            end
                            local f = wheel.physics.rotSpeed / wheel.rotSpeedBackUp

                            steeringAngle = wheel.steeringOffset + ( self.rotatedTime * f * rotSpeed)
                        else
                                if wheel.physics.steeringAngle > wheel.steeringOffset or steeringAngle > wheel.steeringOffset then
                                    steeringAngle = math.max(wheel.steeringOffset, math.min(wheel.physics.steeringAngle, steeringAngle) - delta)
                                elseif wheel.physics.steeringAngle < wheel.steeringOffset or steeringAngle < wheel.steeringOffset then
                                        steeringAngle = math.min(wheel.steeringOffset, math.max(wheel.physics.steeringAngle, steeringAngle) + delta)
                                    end

                                    if steeringAngle = = wheel.steeringOffset then
                                        wheel.physics.rotSpeed = 0
                                    else
                                            if wheel.physics.rotSpeed < 0 then
                                                wheel.physics.rotSpeed = math.min( 0 , wheel.physics.rotSpeed + delta)
                                            elseif wheel.physics.rotSpeed > 0 then
                                                    wheel.physics.rotSpeed = math.max( 0 , wheel.physics.rotSpeed - delta)
                                                end
                                            end
                                        end

                                        steeringAngle = math.clamp(steeringAngle, wheel.physics.rotMin, wheel.physics.rotMax)
                                    end

                                    break
                                end
                            end

                            return steeringAngle
                        end

```

### updateSteeringWheel

**Description**

**Definition**

> updateSteeringWheel()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | steeringWheel |
| any | dt            |
| any | direction     |

**Code**

```lua
function CrabSteering:updateSteeringWheel(superFunc, steeringWheel, dt, direction)
    if self.spec_crabSteering.hasSteeringModes then
        local spec = self.spec_crabSteering
        local currentMode = spec.steeringModes[spec.state]
        if currentMode.steeringWheel ~ = nil then
            steeringWheel = currentMode.steeringWheel
        end
    end

    superFunc( self , steeringWheel, dt, direction)
end

```