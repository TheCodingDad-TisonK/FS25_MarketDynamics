## ReverseDriving

**Description**

> Specialization for vehicles with reverse driving functionality

**Functions**

- [actionEventToggleReverseDriving](#actioneventtogglereversedriving)
- [getAIDirectionNode](#getaidirectionnode)
- [getAIImplementCollisionTrigger](#getaiimplementcollisiontrigger)
- [getAIRootNode](#getairootnode)
- [getAllowCharacterVisibilityUpdate](#getallowcharactervisibilityupdate)
- [getCanBeSelected](#getcanbeselected)
- [getCanStartAIVehicle](#getcanstartaivehicle)
- [getIsDashboardGroupActive](#getisdashboardgroupactive)
- [getIsLightActive](#getislightactive)
- [getIsReverseDrivingAllowed](#getisreversedrivingallowed)
- [getSteeringDirection](#getsteeringdirection)
- [initSpecialization](#initspecialization)
- [loadAdditionalLightAttributesFromXML](#loadadditionallightattributesfromxml)
- [loadDashboardGroupFromXML](#loaddashboardgroupfromxml)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onUpdate](#onupdate)
- [onVehicleCharacterChanged](#onvehiclecharacterchanged)
- [onWriteStream](#onwritestream)
- [postInitSpecialization](#postinitspecialization)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [reverseDirectionChanged](#reversedirectionchanged)
- [saveToXMLFile](#savetoxmlfile)
- [setIsReverseDriving](#setisreversedriving)
- [updateSteeringWheel](#updatesteeringwheel)

### actionEventToggleReverseDriving

**Description**

**Definition**

> actionEventToggleReverseDriving()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function ReverseDriving.actionEventToggleReverseDriving( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_reverseDriving
    if self:getIsReverseDrivingAllowed( not spec.isReverseDriving) then
        self:setIsReverseDriving( not spec.isReverseDriving)
    end
end

```

### getAIDirectionNode

**Description**

**Definition**

> getAIDirectionNode()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ReverseDriving:getAIDirectionNode(superFunc)
    local spec = self.spec_reverseDriving
    if spec.isReverseDriving then
        return spec.aiSteeringNode or superFunc( self )
    end

    return superFunc( self )
end

```

### getAIImplementCollisionTrigger

**Description**

**Definition**

> getAIImplementCollisionTrigger()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ReverseDriving:getAIImplementCollisionTrigger(superFunc)
    local spec = self.spec_reverseDriving
    if spec.isReverseDriving then
        return spec.aiCollisionTrigger or superFunc( self )
    end

    return superFunc( self )
end

```

### getAIRootNode

**Description**

**Definition**

> getAIRootNode()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ReverseDriving:getAIRootNode(superFunc)
    local spec = self.spec_reverseDriving
    if spec.isReverseDriving then
        return spec.aiSteeringNode or superFunc( self )
    end

    return superFunc( self )
end

```

### getAllowCharacterVisibilityUpdate

**Description**

**Definition**

> getAllowCharacterVisibilityUpdate()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ReverseDriving:getAllowCharacterVisibilityUpdate(superFunc)
    local spec = self.spec_reverseDriving
    return superFunc( self ) and( not spec.hideCharacterOnChange or not spec.isChangingDirection)
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
function ReverseDriving:getCanBeSelected(superFunc)
    return true
end

```

### getCanStartAIVehicle

**Description**

**Definition**

> getCanStartAIVehicle()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | jobClass  |

**Code**

```lua
function ReverseDriving:getCanStartAIVehicle(superFunc, jobClass)
    local spec = self.spec_reverseDriving

    if not spec.supportsAI then
        if spec.hasReverseDriving then
            if spec.isReverseDriving then
                return false
            end

            if spec.isChangingDirection then
                return false
            end
        end
    end

    return superFunc( self , jobClass)
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
function ReverseDriving:getIsDashboardGroupActive(superFunc, group)
    if group.isReverseDriving ~ = nil then
        if self.spec_reverseDriving.isReverseDriving ~ = group.isReverseDriving then
            return false
        end
    end

    return superFunc( self , group)
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
function ReverseDriving:getIsLightActive(superFunc, light)
    if light.enableDirection ~ = nil then
        if light.enableDirection ~ = self:getReverserDirection() then
            return false
        end
    end

    return superFunc( self , light)
end

```

### getIsReverseDrivingAllowed

**Description**

**Definition**

> getIsReverseDrivingAllowed()

**Arguments**

| any | newState |
|-----|----------|

**Code**

```lua
function ReverseDriving:getIsReverseDrivingAllowed(newState)
    local spec = self.spec_reverseDriving
    if newState then
        if spec.disablingAttacherJointIndices ~ = nil then
            for i = 1 , #spec.disablingAttacherJointIndices do
                if self:getImplementFromAttacherJointIndex(spec.disablingAttacherJointIndices[i]) ~ = nil then
                    return false
                end
            end
        end
    end

    return true
end

```

### getSteeringDirection

**Description**

**Definition**

> getSteeringDirection()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function ReverseDriving:getSteeringDirection(superFunc)
    local spec = self.spec_reverseDriving
    if spec.hasReverseDriving then
        return spec.smoothReverserDirection
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
function ReverseDriving.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ReverseDriving" )

    IKUtil.registerIKChainTargetsXMLPaths(schema, "vehicle.reverseDriving" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.reverseDriving.steeringWheel#node" , "Spawn place node" )
    schema:register(XMLValueType.ANGLE, "vehicle.reverseDriving.steeringWheel#indoorRotation" , "Indoor rotation" , "vehicle.drivable.steeringWheel#indoorRotation" )
    schema:register(XMLValueType.ANGLE, "vehicle.reverseDriving.steeringWheel#outdoorRotation" , "Outdoor rotation" , "vehicle.drivable.steeringWheel#outdoorRotation" )
    schema:register(XMLValueType.STRING, "vehicle.reverseDriving#animationName" , "Animation name" , "reverseDriving" )

    schema:register(XMLValueType.BOOL, "vehicle.reverseDriving#hideCharacterOnChange" , "Hide the character while changing the direction" , true )
        schema:register(XMLValueType.BOOL, "vehicle.reverseDriving#inverseTransmission" , "Inverse the transmission gear ratio when direction has changed" , false )
        schema:register(XMLValueType.BOOL, "vehicle.reverseDriving#initialInversed" , "Vehicle is in reverse driving state directly after loading" , false )

        schema:register(XMLValueType.VECTOR_N, "vehicle.reverseDriving#disablingAttacherJointIndices" , "Attacher joint indices which are disabling the reverse driving" )

        schema:register(XMLValueType.NODE_INDEX, "vehicle.reverseDriving.ai#steeringNode" , "Steering Node while in reverse driving mode" )

            AIImplement.registerAICollisionTriggerXMLPaths(schema, "vehicle.reverseDriving.ai" )

            schema:register(XMLValueType.BOOL, Dashboard.GROUP_XML_KEY .. "#isReverseDriving" , "Is Reverse driving" )

            for i = 1 , # Lights.ADDITIONAL_LIGHT_ATTRIBUTES_KEYS do
                local key = Lights.ADDITIONAL_LIGHT_ATTRIBUTES_KEYS[i]
                schema:register(XMLValueType.INT, key .. "#enableDirection" , "Light is enabled when driving into this direction [-1, 1]" )
            end

            schema:setXMLSpecializationType()

            local schemaSavegame = Vehicle.xmlSchemaSavegame
            schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).reverseDriving#isActive" , "Reverse driving is active" )
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
function ReverseDriving:loadAdditionalLightAttributesFromXML(superFunc, xmlFile, key, light)
    if not superFunc( self , xmlFile, key, light) then
        return false
    end

    light.enableDirection = xmlFile:getValue(key .. "#enableDirection" )

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
function ReverseDriving:loadDashboardGroupFromXML(superFunc, xmlFile, key, group)
    if not superFunc( self , xmlFile, key, group) then
        return false
    end

    group.isReverseDriving = xmlFile:getValue(key .. "#isReverseDriving" )

    return true
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
function ReverseDriving:onLoad(savegame)
    local spec = self.spec_reverseDriving

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.reverseDriving.steering#reversedIndex" , "vehicle.reverseDriving.steeringWheel#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.reverseDriving.steering#reversedNode" , "vehicle.reverseDriving.steeringWheel#node" ) --FS17 to FS19

    spec.reversedCharacterTargets = { }
    IKUtil.loadIKChainTargets( self.xmlFile, "vehicle.reverseDriving" , self.components, spec.reversedCharacterTargets, self.i3dMappings)

    local node = self.xmlFile:getValue( "vehicle.reverseDriving.steeringWheel#node" , nil , self.components, self.i3dMappings)
    if node ~ = nil then
        spec.steeringWheel = { }
        spec.steeringWheel.node = node
        local _,ry,_ = getRotation(spec.steeringWheel.node)
        spec.steeringWheel.lastRotation = ry
        spec.steeringWheel.indoorRotation = self.xmlFile:getValue( "vehicle.reverseDriving.steeringWheel#indoorRotation" , self.xmlFile:getValue( "vehicle.drivable.steeringWheel#indoorRotation" , 0 ))
        spec.steeringWheel.outdoorRotation = self.xmlFile:getValue( "vehicle.reverseDriving.steeringWheel#outdoorRotation" , self.xmlFile:getValue( "vehicle.drivable.steeringWheel#outdoorRotation" , 0 ))
    end

    spec.reverseDrivingAnimation = self.xmlFile:getValue( "vehicle.reverseDriving#animationName" , "reverseDriving" )

    spec.hideCharacterOnChange = self.xmlFile:getValue( "vehicle.reverseDriving#hideCharacterOnChange" , true )
    spec.inverseTransmission = self.xmlFile:getValue( "vehicle.reverseDriving#inverseTransmission" , false )

    spec.disablingAttacherJointIndices = self.xmlFile:getValue( "vehicle.reverseDriving#disablingAttacherJointIndices" , nil , true )

    spec.aiSteeringNode = self.xmlFile:getValue( "vehicle.reverseDriving.ai#steeringNode" , nil , self.components, self.i3dMappings)
    spec.supportsAI = spec.aiSteeringNode ~ = nil

    if self.loadAICollisionTriggerFromXML ~ = nil then
        spec.aiCollisionTrigger = self:loadAICollisionTriggerFromXML( self.xmlFile, "vehicle.reverseDriving.ai" )
    end

    spec.hasReverseDriving = self:getAnimationExists(spec.reverseDrivingAnimation)

    for name, id in pairs( self.configurations) do
        local configDesc = g_vehicleConfigurationManager:getConfigurationDescByName(name)
        local key = string.format( "%s(%d).reverseDriving" , configDesc.configurationKey, id - 1 )
        if not self.xmlFile:getValue(key .. "#isAllowed" , true ) then
            spec.hasReverseDriving = false
        end
    end

    spec.isChangingDirection = false
    spec.isReverseDriving = self.xmlFile:getValue( "vehicle.reverseDriving#initialInversed" , false )

    spec.smoothReverserDirection = 1

    if not spec.hasReverseDriving then
        SpecializationUtil.removeEventListener( self , "onPostLoad" , ReverseDriving )
        SpecializationUtil.removeEventListener( self , "onReadStream" , ReverseDriving )
        SpecializationUtil.removeEventListener( self , "onWriteStream" , ReverseDriving )
        SpecializationUtil.removeEventListener( self , "onUpdate" , ReverseDriving )
        SpecializationUtil.removeEventListener( self , "onVehicleCharacterChanged" , ReverseDriving )
        SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , ReverseDriving )
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
function ReverseDriving:onPostLoad(savegame)
    local spec = self.spec_reverseDriving

    local character = self:getVehicleCharacter()
    if character ~ = nil then
        spec.defaultCharacterTargets = character:getIKChainTargets()
    end

    local isReverseDriving = spec.isReverseDriving
    if savegame ~ = nil then
        isReverseDriving = savegame.xmlFile:getValue(savegame.key .. ".reverseDriving#isActive" , isReverseDriving)
    end

    self:setIsReverseDriving(isReverseDriving, true , true )
    spec.updateAnimationOnEnter = isReverseDriving
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
function ReverseDriving:onReadStream(streamId, connection)
    self:setIsReverseDriving(streamReadBool(streamId), true , true )

    local spec = self.spec_reverseDriving
    spec.updateAnimationOnEnter = spec.isReverseDriving
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
function ReverseDriving:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_reverseDriving
        self:clearActionEventsTable(spec.actionEvents)
        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addPoweredActionEvent(spec.actionEvents, InputAction.CHANGE_DRIVING_DIRECTION, self , ReverseDriving.actionEventToggleReverseDriving, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "input_CHANGE_DRIVING_DIRECTION" ))
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
function ReverseDriving:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_reverseDriving

    if spec.isChangingDirection then
        if spec.hideCharacterOnChange then
            local character = self:getVehicleCharacter()
            if character ~ = nil then
                character:setCharacterVisibility( false )
            end
        end

        if not self:getIsEntered() then
            if spec.updateAnimationOnEnter then
                AnimatedVehicle.updateAnimations( self , 99999999 , true )
                spec.updateAnimationOnEnter = false
            end
        end

        if not self:getIsAnimationPlaying(spec.reverseDrivingAnimation) then
            self:reverseDirectionChanged(spec.reverserDirection)
        end

        local direction = (spec.isReverseDriving and 1 ) or - 1
        spec.smoothReverserDirection = math.clamp(spec.smoothReverserDirection - 0.001 * dt * direction, - 1 , 1 )
    end
end

```

### onVehicleCharacterChanged

**Description**

**Definition**

> onVehicleCharacterChanged()

**Arguments**

| any | character |
|-----|-----------|

**Code**

```lua
function ReverseDriving:onVehicleCharacterChanged(character)
    local spec = self.spec_reverseDriving

    if character ~ = nil then
        if spec.updateAnimationOnEnter then
            AnimatedVehicle.updateAnimations( self , 99999999 , true )
            spec.updateAnimationOnEnter = false
        end

        if spec.isReverseDriving and next(spec.reversedCharacterTargets) ~ = nil then
            character:setIKChainTargets(spec.reversedCharacterTargets, true )
        else
                character:setIKChainTargets(spec.defaultCharacterTargets, true )
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
function ReverseDriving:onWriteStream(streamId, connection)
    streamWriteBool(streamId, self.spec_reverseDriving.isReverseDriving)
end

```

### postInitSpecialization

**Description**

**Definition**

> postInitSpecialization()

**Code**

```lua
function ReverseDriving.postInitSpecialization()
    local schema = Vehicle.xmlSchema

    for name, configDesc in pairs(g_vehicleConfigurationManager:getConfigurations()) do
        local configurationKey = configDesc.configurationKey .. "(?)"
        schema:setXMLSharedRegistration( "configReverseDriving" , configurationKey)
        schema:register(XMLValueType.BOOL, configurationKey .. ".reverseDriving#isAllowed" , "Reverse driving is allowed while this configuration is equipped" , true )
            schema:resetXMLSharedRegistration( "configReverseDriving" , configurationKey)
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
function ReverseDriving.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( Drivable , specializations)
    and SpecializationUtil.hasSpecialization( Enterable , specializations)
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
function ReverseDriving.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , ReverseDriving )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , ReverseDriving )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , ReverseDriving )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , ReverseDriving )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , ReverseDriving )
    SpecializationUtil.registerEventListener(vehicleType, "onVehicleCharacterChanged" , ReverseDriving )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , ReverseDriving )
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
function ReverseDriving.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onStartReverseDirectionChange" )
    SpecializationUtil.registerEvent(vehicleType, "onReverseDirectionChanged" )
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
function ReverseDriving.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "reverseDirectionChanged" , ReverseDriving.reverseDirectionChanged)
    SpecializationUtil.registerFunction(vehicleType, "setIsReverseDriving" , ReverseDriving.setIsReverseDriving)
    SpecializationUtil.registerFunction(vehicleType, "getIsReverseDrivingAllowed" , ReverseDriving.getIsReverseDrivingAllowed)
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
function ReverseDriving.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateSteeringWheel" , ReverseDriving.updateSteeringWheel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getSteeringDirection" , ReverseDriving.getSteeringDirection)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAllowCharacterVisibilityUpdate" , ReverseDriving.getAllowCharacterVisibilityUpdate)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanStartAIVehicle" , ReverseDriving.getCanStartAIVehicle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadDashboardGroupFromXML" , ReverseDriving.loadDashboardGroupFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsDashboardGroupActive" , ReverseDriving.getIsDashboardGroupActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , ReverseDriving.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadAdditionalLightAttributesFromXML" , ReverseDriving.loadAdditionalLightAttributesFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsLightActive" , ReverseDriving.getIsLightActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIDirectionNode" , ReverseDriving.getAIDirectionNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIRootNode" , ReverseDriving.getAIRootNode)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAIImplementCollisionTrigger" , ReverseDriving.getAIImplementCollisionTrigger)
end

```

### reverseDirectionChanged

**Description**

> Called after reverse drive change

**Definition**

> reverseDirectionChanged(float direction)

**Arguments**

| float | direction | new direction |
|-------|-----------|---------------|

**Code**

```lua
function ReverseDriving:reverseDirectionChanged(direction)
    local spec = self.spec_reverseDriving

    spec.isChangingDirection = false
    if spec.isReverseDriving then
        self:setReverserDirection( - 1 )
        spec.smoothReverserDirection = - 1
    else
            self:setReverserDirection( 1 )
            spec.smoothReverserDirection = 1
        end

        local character = self:getVehicleCharacter()
        if character ~ = nil then
            if spec.isReverseDriving and next(spec.reversedCharacterTargets) ~ = nil then
                character:setIKChainTargets(spec.reversedCharacterTargets)
            else
                    character:setIKChainTargets(spec.defaultCharacterTargets)
                end

                if character.meshThirdPerson ~ = nil and not self:getIsEntered() then
                    character:updateVisibility()
                end

                character:setAllowCharacterUpdate( true )
            end

            if self.setLightsTypesMask ~ = nil then
                self:setLightsTypesMask( self.spec_lights.lightsTypesMask, true , true )
            end

            SpecializationUtil.raiseEvent( self , "onReverseDirectionChanged" , direction)
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
function ReverseDriving:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_reverseDriving
    if spec.hasReverseDriving then
        xmlFile:setValue(key .. "#isActive" , spec.isReverseDriving)
    end
end

```

### setIsReverseDriving

**Description**

> Toggle reverse driving

**Definition**

> setIsReverseDriving(boolean isReverseDriving, boolean noEventSend, )

**Arguments**

| boolean | isReverseDriving |               |
|---------|------------------|---------------|
| boolean | noEventSend      | no event send |
| any     | forceUpdate      |               |

**Code**

```lua
function ReverseDriving:setIsReverseDriving(isReverseDriving, noEventSend, forceUpdate)
    local spec = self.spec_reverseDriving
    if isReverseDriving ~ = spec.isReverseDriving or forceUpdate then
        spec.isChangingDirection = true
        spec.isReverseDriving = isReverseDriving

        local dir = (isReverseDriving and 1 ) or - 1
        self:playAnimation(spec.reverseDrivingAnimation, dir, self:getAnimationTime(spec.reverseDrivingAnimation), true )

        -- deactivate update of character ik chains to prevent strange states after changing
        local character = self:getVehicleCharacter()
        if character ~ = nil then
            character:setAllowCharacterUpdate( false )
        end

        if spec.inverseTransmission then
            if self.setTransmissionDirection ~ = nil then
                self:setTransmissionDirection( - dir)
            end
        end

        self:setReverserDirection( 0 )
        SpecializationUtil.raiseEvent( self , "onStartReverseDirectionChange" )
        ReverseDrivingSetStateEvent.sendEvent( self , isReverseDriving, noEventSend)

        if forceUpdate then
            AnimatedVehicle.updateAnimationByName( self , spec.reverseDrivingAnimation, 9999999 , true )
        end

        self:setAIRootNodeDirty()
    end
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
function ReverseDriving:updateSteeringWheel(superFunc, steeringWheel, dt, direction)
    local spec = self.spec_reverseDriving

    if spec.isReverseDriving then
        if spec.steeringWheel ~ = nil then
            steeringWheel = spec.steeringWheel
        end

        direction = - direction
    end

    superFunc( self , steeringWheel, dt, direction)
end

```