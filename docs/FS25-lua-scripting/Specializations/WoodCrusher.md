## WoodCrusher

**Description**

> Specialization for wood crusher allowing to cut and convert tree trunks into wood chips

**Functions**

- [crushSplitShape](#crushsplitshape)
- [deleteWoodCrusher](#deletewoodcrusher)
- [getCanBeTurnedOn](#getcanbeturnedon)
- [getConsumingLoad](#getconsumingload)
- [getDirtMultiplier](#getdirtmultiplier)
- [getRequiresPower](#getrequirespower)
- [getWearMultiplier](#getwearmultiplier)
- [initSpecialization](#initspecialization)
- [loadWoodCrusher](#loadwoodcrusher)
- [onCrushedSplitShape](#oncrushedsplitshape)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onReadUpdateStream](#onreadupdatestream)
- [onTurnedOff](#onturnedoff)
- [onTurnedOn](#onturnedon)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerWoodCrusherXMLPaths](#registerwoodcrusherxmlpaths)
- [turnOffWoodCrusher](#turnoffwoodcrusher)
- [turnOnWoodCrusher](#turnonwoodcrusher)
- [updateTickWoodCrusher](#updatetickwoodcrusher)
- [updateWoodCrusher](#updatewoodcrusher)
- [woodCrusherDownForceTriggerCallback](#woodcrusherdownforcetriggercallback)
- [woodCrusherMoveTriggerCallback](#woodcrushermovetriggercallback)
- [woodCrusherSplitShapeCallback](#woodcrushersplitshapecallback)

### crushSplitShape

**Description**

> Crush split shape

**Definition**

> crushSplitShape(integer shape, , )

**Arguments**

| integer | shape       | id of shape |
|---------|-------------|-------------|
| any     | woodCrusher |             |
| any     | shape       |             |

**Code**

```lua
function WoodCrusher.crushSplitShape( self , woodCrusher, shape)
    local splitType = g_splitShapeManager:getSplitTypeByIndex(getSplitType(shape))
    if splitType ~ = nil and splitType.woodChipsPerLiter > 0 then
        local volume = getVolume(shape)
        delete(shape)
        woodCrusher.crushingTime = 1000
        self:onCrushedSplitShape(splitType, volume)
    end
end

```

### deleteWoodCrusher

**Description**

> Delete wood crusher

**Definition**

> deleteWoodCrusher()

**Arguments**

| any | self        |
|-----|-------------|
| any | woodCrusher |

**Code**

```lua
function WoodCrusher.deleteWoodCrusher( self , woodCrusher)
    if woodCrusher.moveTriggers ~ = nil then
        for _,node in pairs(woodCrusher.moveTriggers) do
            removeTrigger(node)
        end
    end

    if woodCrusher.downForceTriggers ~ = nil then
        for trigger, _ in pairs(woodCrusher.downForceTriggers) do
            removeTrigger(trigger)
        end
    end

    g_effectManager:deleteEffects(woodCrusher.crushEffects)
    g_soundManager:deleteSamples(woodCrusher.samples)
    g_animationManager:deleteAnimations(woodCrusher.animationNodes)
end

```

### getCanBeTurnedOn

**Description**

> Returns if user is allowed to turn on the vehicle

**Definition**

> getCanBeTurnedOn()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | allow | allow turn on |
|-----|-------|---------------|

**Code**

```lua
function WoodCrusher:getCanBeTurnedOn(superFunc)
    local spec = self.spec_woodCrusher
    if spec.turnOnAutomatically then
        return false
    end

    return superFunc( self )
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
function WoodCrusher:getConsumingLoad(superFunc)
    local value, count = superFunc( self )

    local spec = self.spec_woodCrusher
    if spec.crushingTime > 0 then
        value = value + 1
    end

    return value, count + 1
end

```

### getDirtMultiplier

**Description**

> Returns current dirt multiplier

**Definition**

> getDirtMultiplier()

**Arguments**

| any | superFunc |
|-----|-----------|

**Return Values**

| any | dirtMultiplier | current dirt multiplier |
|-----|----------------|-------------------------|

**Code**

```lua
function WoodCrusher:getDirtMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_woodCrusher
    if spec.crushingTime > 0 then
        multiplier = multiplier + self:getWorkDirtMultiplier()
    end

    return multiplier
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
function WoodCrusher:getRequiresPower(superFunc)
    if self:getIsTurnedOn() then
        return true
    end

    return superFunc( self )
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
function WoodCrusher:getWearMultiplier(superFunc)
    local multiplier = superFunc( self )

    local spec = self.spec_woodCrusher
    if spec.crushingTime > 0 then
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
function WoodCrusher.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "WoodCrusher" )

    WoodCrusher.registerWoodCrusherXMLPaths(schema, "vehicle.woodCrusher" )

    schema:register(XMLValueType.BOOL, "vehicle.woodCrusher#moveColDisableCollisionPairs" , "Activate collision between move collisions and components" , true )
    schema:register(XMLValueType.INT, "vehicle.woodCrusher#fillUnitIndex" , "Fill unit index" , 1 )

    schema:setXMLSpecializationType()
end

```

### loadWoodCrusher

**Description**

> Load wood crusher from xml file

**Definition**

> loadWoodCrusher(table woodCrusher, XMLFile xmlFile, integer rootNode, table i3dMappings, )

**Arguments**

| table   | woodCrusher | target wood crusher table             |
|---------|-------------|---------------------------------------|
| XMLFile | xmlFile     | XMLFile instance                      |
| integer | rootNode    | id of root node or list of components |
| table   | i3dMappings | i3d mappings                          |
| any     | i3dMappings |                                       |

**Code**

```lua
function WoodCrusher.loadWoodCrusher( self , woodCrusher, xmlFile, rootNode, i3dMappings)
    woodCrusher.vehicle = self

    woodCrusher.woodCrusherSplitShapeCallback = WoodCrusher.woodCrusherSplitShapeCallback
    woodCrusher.woodCrusherMoveTriggerCallback = WoodCrusher.woodCrusherMoveTriggerCallback
    woodCrusher.woodCrusherDownForceTriggerCallback = WoodCrusher.woodCrusherDownForceTriggerCallback

    local xmlRoot = xmlFile:getRootName()
    local baseKey = xmlRoot .. ".woodCrusher"

    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusher.moveTrigger(0)#index" , xmlRoot .. ".woodCrusher.moveTriggers.trigger#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusher.moveCollision(0)#index" , xmlRoot .. ".woodCrusher.moveCollisions.collision#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusher.emitterShape(0)" , xmlRoot .. ".woodCrusher.crushEffects with effectClass 'ParticleEffect'" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusherStartSound" , xmlRoot .. ".woodCrusher.sounds.start" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusherIdleSound" , xmlRoot .. ".woodCrusher.sounds.idle" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusherWorkSound" , xmlRoot .. ".woodCrusher.sounds.work" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".woodCrusherStopSound" , xmlRoot .. ".woodCrusher.sounds.stop" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".turnedOnRotationNodes.turnedOnRotationNode#type" , xmlRoot .. ".woodCrusher.animationNodes.animationNode" , "woodCrusher" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, xmlRoot .. ".turnedOnScrollers.turnedOnScroller" , xmlRoot .. ".woodCrusher.animationNodes.animationNode" ) --FS17 to FS19

    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseKey .. "#downForceNode" , baseKey .. ".downForceNodes.downForceNode#node" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseKey .. "#downForce" , baseKey .. ".downForceNodes.downForceNode#force" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseKey .. "#downForceSizeY" , baseKey .. ".downForceNodes.downForceNode#sizeY" ) --FS19 to FS22
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseKey .. "#downForceSizeZ" , baseKey .. ".downForceNodes.downForceNode#sizeZ" ) --FS19 to FS22

    woodCrusher.cutNode = xmlFile:getValue(baseKey .. "#cutNode" , nil , rootNode, i3dMappings)
    woodCrusher.mainDrumRefNode = xmlFile:getValue(baseKey .. "#mainDrumRefNode" , nil , rootNode, i3dMappings)
    woodCrusher.mainDrumRefNodeMaxY = xmlFile:getValue(baseKey .. "#mainDrumRefNodeMaxY" , math.huge)

    if woodCrusher.mainDrumRefNode ~ = nil then
        local mainDrumRefNodeParent = createTransformGroup( "mainDrumRefNodeParent" )
        link(getParent(woodCrusher.mainDrumRefNode), mainDrumRefNodeParent, getChildIndex(woodCrusher.mainDrumRefNode))
        setTranslation(mainDrumRefNodeParent, getTranslation(woodCrusher.mainDrumRefNode))
        setRotation(mainDrumRefNodeParent, getRotation(woodCrusher.mainDrumRefNode))
        link(mainDrumRefNodeParent, woodCrusher.mainDrumRefNode)
        setTranslation(woodCrusher.mainDrumRefNode, 0 , 0 , 0 )
        setRotation(woodCrusher.mainDrumRefNode, 0 , 0 , 0 )
    end

    woodCrusher.moveTriggers = { }
    local i = 0
    while true do
        local key = string.format( "%s.moveTriggers.trigger(%d)" , baseKey, i)
        if not xmlFile:hasProperty(key) then
            break
        end

        local node = xmlFile:getValue(key .. "#node" , nil , rootNode, i3dMappings)
        if node ~ = nil then
            if not CollisionFlag.getHasMaskFlagSet(node, CollisionFlag.TREE) then
                Logging.xmlWarning( self.xmlFile, "Missing collision filter mask %s.Please add this bit to move trigger node '%s' in '%s'" , CollisionFlag.getBitAndName(CollisionFlag.TREE), getName(node), key)
                break
            end
            table.insert(woodCrusher.moveTriggers, node)
        end
        i = i + 1
    end

    woodCrusher.moveColNodes = { }
    i = 0
    while true do
        local key = string.format( "%s.moveCollisions.collision(%d)" , baseKey, i)
        if not xmlFile:hasProperty(key) then
            break
        end

        local moveColNode = { }
        moveColNode.node = xmlFile:getValue(key .. "#node" , nil , rootNode, i3dMappings)
        if moveColNode.node ~ = nil then
            moveColNode.transX, moveColNode.transY, moveColNode.transZ = getTranslation(moveColNode.node)
            table.insert(woodCrusher.moveColNodes, moveColNode)
        end
        i = i + 1
    end

    woodCrusher.moveVelocityZ = xmlFile:getValue(baseKey .. "#moveVelocityZ" , 0.8 ) -- m/s
    woodCrusher.moveMaxForce = xmlFile:getValue(baseKey .. "#moveMaxForce" , 7 ) -- input is kN
    woodCrusher.shapeSizeDetectionNode = xmlFile:getValue(baseKey .. "#shapeSizeDetectionNode" , nil , rootNode, i3dMappings)
    woodCrusher.cutSizeY = xmlFile:getValue(baseKey .. "#cutSizeY" , 1 )
    woodCrusher.cutSizeZ = xmlFile:getValue(baseKey .. "#cutSizeZ" , 1 )

    woodCrusher.downForceNodes = { }
    woodCrusher.downForceTriggers = { }
    xmlFile:iterate(baseKey .. ".downForceNodes.downForceNode" , function (_, key)
        local downForceNode = { }
        downForceNode.node = xmlFile:getValue(key .. "#node" , nil , rootNode, i3dMappings)
        if downForceNode.node ~ = nil then
            downForceNode.force = xmlFile:getValue(key .. "#force" , 2 )
            downForceNode.trigger = xmlFile:getValue(key .. "#trigger" , nil , rootNode, i3dMappings)

            downForceNode.sizeY = xmlFile:getValue(key .. "#sizeY" , woodCrusher.cutSizeY)
            downForceNode.sizeZ = xmlFile:getValue(key .. "#sizeZ" , woodCrusher.cutSizeZ)

            downForceNode.woodCrusher = woodCrusher
            downForceNode.triggerNodes = { }

            if downForceNode.trigger ~ = nil and woodCrusher.downForceTriggers[downForceNode.trigger] = = nil then
                if self.isServer then
                    woodCrusher.downForceTriggers[downForceNode.trigger] = true
                    addTrigger(downForceNode.trigger, "woodCrusherDownForceTriggerCallback" , woodCrusher)
                end
            end

            table.insert(woodCrusher.downForceNodes, downForceNode)
        end
    end )

    woodCrusher.moveTriggerNodes = { }
    if self.isServer and woodCrusher.moveTriggers ~ = nil then
        for _,node in pairs(woodCrusher.moveTriggers) do
            addTrigger(node, "woodCrusherMoveTriggerCallback" , woodCrusher)
        end
    end

    woodCrusher.crushNodes = { }
    woodCrusher.crushingTime = 0
    woodCrusher.turnOnAutomatically = xmlFile:getValue(baseKey .. "#automaticallyTurnOn" , false )

    if self.isClient then
        woodCrusher.crushEffects = g_effectManager:loadEffect(xmlFile, baseKey .. ".crushEffects" , rootNode, self , i3dMappings)

        woodCrusher.animationNodes = g_animationManager:loadAnimations(xmlFile, baseKey .. ".animationNodes" , rootNode, self , i3dMappings)

        woodCrusher.isWorkSamplePlaying = false
        woodCrusher.samples = { }
        woodCrusher.samples.start = g_soundManager:loadSampleFromXML(xmlFile, baseKey .. ".sounds" , "start" , self.baseDirectory, rootNode, 1 , AudioGroup.VEHICLE, i3dMappings, self )
        woodCrusher.samples.stop = g_soundManager:loadSampleFromXML(xmlFile, baseKey .. ".sounds" , "stop" , self.baseDirectory, rootNode, 1 , AudioGroup.VEHICLE, i3dMappings, self )
        woodCrusher.samples.work = g_soundManager:loadSampleFromXML(xmlFile, baseKey .. ".sounds" , "work" , self.baseDirectory, rootNode, 0 , AudioGroup.VEHICLE, i3dMappings, self )
        woodCrusher.samples.idle = g_soundManager:loadSampleFromXML(xmlFile, baseKey .. ".sounds" , "idle" , self.baseDirectory, rootNode, 0 , AudioGroup.VEHICLE, i3dMappings, self )
    end
end

```

### onCrushedSplitShape

**Description**

> Called on crush split shape

**Definition**

> onCrushedSplitShape(table splitType, float volume)

**Arguments**

| table | splitType | split type |
|-------|-----------|------------|
| float | volume    | volume     |

**Code**

```lua
function WoodCrusher:onCrushedSplitShape(splitType, volume)
    local spec = self.spec_woodCrusher

    local damage = self:getVehicleDamage()
    if damage > 0 then
        volume = volume * ( 1 - damage * WoodCrusher.DAMAGED_YIELD_DECREASE)
    end

    self:addFillUnitFillLevel( self:getOwnerFarmId(), spec.fillUnitIndex, volume * splitType.volumeToLiter * splitType.woodChipsPerLiter, FillType.WOODCHIPS, ToolType.UNDEFINED)
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function WoodCrusher:onDelete()
    WoodCrusher.deleteWoodCrusher( self , self.spec_woodCrusher)
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
function WoodCrusher:onLoad(savegame)
    local spec = self.spec_woodCrusher

    WoodCrusher.loadWoodCrusher( self , spec, self.xmlFile, self.components, self.i3dMappings)

    local moveColDisableCollisionPairs = self.xmlFile:getValue( "vehicle.woodCrusher#moveColDisableCollisionPairs" , true )
    if moveColDisableCollisionPairs then
        for _, component in pairs( self.components) do
            for _, moveColNodes in pairs(spec.moveColNodes) do
                setPairCollision(component.node, moveColNodes.node, false )
            end
        end
    end

    spec.fillUnitIndex = self.xmlFile:getValue( "vehicle.woodCrusher#fillUnitIndex" , 1 )
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
function WoodCrusher:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_woodCrusher
        if streamReadBool(streamId) then
            spec.crushingTime = 1000
        else
                spec.crushingTime = 0
            end
        end
    end

```

### onTurnedOff

**Description**

> Called on turn off

**Definition**

> onTurnedOff(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function WoodCrusher:onTurnedOff()
    WoodCrusher.turnOffWoodCrusher( self , self.spec_woodCrusher)
end

```

### onTurnedOn

**Description**

> Called on turn on

**Definition**

> onTurnedOn(boolean noEventSend)

**Arguments**

| boolean | noEventSend | no event send |
|---------|-------------|---------------|

**Code**

```lua
function WoodCrusher:onTurnedOn()
    WoodCrusher.turnOnWoodCrusher( self , self.spec_woodCrusher)
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
function WoodCrusher:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    WoodCrusher.updateWoodCrusher( self , self.spec_woodCrusher, dt, self:getIsTurnedOn())
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
function WoodCrusher:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    WoodCrusher.updateTickWoodCrusher( self , self.spec_woodCrusher, dt, self:getIsTurnedOn())

    local spec = self.spec_woodCrusher
    -- turn on/off automatically if tree node is in trigger
        if self.isServer then
            if g_currentMission.missionInfo.automaticMotorStartEnabled then
                if spec.turnOnAutomatically and self.setIsTurnedOn ~ = nil then
                    if next(spec.moveTriggerNodes) ~ = nil then
                        if self.getIsMotorStarted ~ = nil then
                            if not self:getIsMotorStarted() then
                                self:startMotor()
                            end
                        else
                                if self.attacherVehicle ~ = nil then
                                    if self.attacherVehicle.getIsMotorStarted ~ = nil then
                                        if not self.attacherVehicle:getIsMotorStarted() then
                                            self.attacherVehicle:startMotor()
                                        end
                                    end
                                end
                            end

                            if ( self.getIsControlled = = nil or not self:getIsControlled()) and not self:getIsTurnedOn() and self:getCanBeTurnedOn() then
                                self:setIsTurnedOn( true )
                            end
                            spec.turnOffTimer = 3000
                        else
                                if self:getIsTurnedOn() then
                                    if spec.turnOffTimer = = nil then
                                        spec.turnOffTimer = 3000
                                    end
                                    spec.turnOffTimer = spec.turnOffTimer - dt

                                    if spec.turnOffTimer < 0 then
                                        local rootAttacherVehicle = self:getRootVehicle()

                                        if not rootAttacherVehicle.isControlled then
                                            if self.getIsMotorStarted ~ = nil then
                                                if self:getIsMotorStarted() then
                                                    self:stopMotor()
                                                end
                                            end

                                            self:setIsTurnedOn( false )
                                        end
                                    end
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
function WoodCrusher:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_woodCrusher
        streamWriteBool(streamId, spec.crushingTime > 0 )
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
function WoodCrusher.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( TurnOnVehicle , specializations) and SpecializationUtil.hasSpecialization( FillUnit , specializations)
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
function WoodCrusher.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOn" , WoodCrusher )
    SpecializationUtil.registerEventListener(vehicleType, "onTurnedOff" , WoodCrusher )
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
function WoodCrusher.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "onCrushedSplitShape" , WoodCrusher.onCrushedSplitShape)
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
function WoodCrusher.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getDirtMultiplier" , WoodCrusher.getDirtMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getWearMultiplier" , WoodCrusher.getWearMultiplier)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeTurnedOn" , WoodCrusher.getCanBeTurnedOn)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getConsumingLoad" , WoodCrusher.getConsumingLoad)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRequiresPower" , WoodCrusher.getRequiresPower)
end

```

### registerWoodCrusherXMLPaths

**Description**

**Definition**

> registerWoodCrusherXMLPaths()

**Arguments**

| any | schema |
|-----|--------|
| any | key    |

**Code**

```lua
function WoodCrusher.registerWoodCrusherXMLPaths(schema, key)
    schema:register(XMLValueType.NODE_INDEX, key .. "#cutNode" , "Cut node" )
    schema:register(XMLValueType.NODE_INDEX, key .. "#mainDrumRefNode" , "Main drum reference node" )
    schema:register(XMLValueType.FLOAT, key .. "#mainDrumRefNodeMaxY" , "Max tree size the main drum can handle" )

    schema:register(XMLValueType.NODE_INDEX, key .. ".moveTriggers.trigger(?)#node" , "Move trigger" )
    schema:register(XMLValueType.NODE_INDEX, key .. ".moveCollisions.collision(?)#node" , "Move collision" )

    schema:register(XMLValueType.FLOAT, key .. "#moveVelocityZ" , "Move velocity Z(m/s)" , 0.8 )
    schema:register(XMLValueType.FLOAT, key .. "#moveMaxForce" , "Move max.force(kN)" , 7 )
    schema:register(XMLValueType.NODE_INDEX, key .. "#shapeSizeDetectionNode" , "At this node the tree shape size will be detected to set the #mainDrumRefNode" )
    schema:register(XMLValueType.FLOAT, key .. "#cutSizeY" , "Cut size Y" , 1 )
    schema:register(XMLValueType.FLOAT, key .. "#cutSizeZ" , "Cut size Z" , 1 )

    schema:register(XMLValueType.NODE_INDEX, key .. ".downForceNodes.downForceNode(?)#node" , "Down force node" )
    schema:register(XMLValueType.NODE_INDEX, key .. ".downForceNodes.downForceNode(?)#trigger" , "Additional trigger(If defined the tree needs to be present in the mover trigger and inside this trigger)" )
    schema:register(XMLValueType.FLOAT, key .. ".downForceNodes.downForceNode(?)#force" , "Down force(kN)" , 2 )
    schema:register(XMLValueType.FLOAT, key .. ".downForceNodes.downForceNode(?)#sizeY" , "Size Y in which the down force node detects trees" , "Cut size Y" )
    schema:register(XMLValueType.FLOAT, key .. ".downForceNodes.downForceNode(?)#sizeZ" , "Size Z in which the down force node detects trees" , "Cut size Z" )

    schema:register(XMLValueType.BOOL, key .. "#automaticallyTurnOn" , "Automatically turned on" , false )

    EffectManager.registerEffectXMLPaths(schema, key .. ".crushEffects" )
    AnimationManager.registerAnimationNodesXMLPaths(schema, key .. ".animationNodes" )

    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "start" )
    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "stop" )
    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "work" )
    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "idle" )
end

```

### turnOffWoodCrusher

**Description**

> Turn off wood crusher

**Definition**

> turnOffWoodCrusher()

**Arguments**

| any | self        |
|-----|-------------|
| any | woodCrusher |

**Code**

```lua
function WoodCrusher.turnOffWoodCrusher( self , woodCrusher)
    if self.isServer then
        for node in pairs(woodCrusher.crushNodes) do
            WoodCrusher.crushSplitShape( self , woodCrusher, node)
            woodCrusher.crushNodes[node] = nil
        end
        if woodCrusher.moveColNodes ~ = nil then
            for _, moveColNode in pairs(woodCrusher.moveColNodes) do
                setFrictionVelocity(moveColNode.node, 0.0 )
            end
        end
    end

    if self.isClient then
        g_effectManager:stopEffects(woodCrusher.crushEffects)
        g_soundManager:stopSamples(woodCrusher.samples)
        g_soundManager:playSample(woodCrusher.samples.stop)
        woodCrusher.isWorkSamplePlaying = false

        if self.isClient then
            g_animationManager:stopAnimations(woodCrusher.animationNodes)
        end
    end
end

```

### turnOnWoodCrusher

**Description**

> Turn on wood crusher

**Definition**

> turnOnWoodCrusher()

**Arguments**

| any | self        |
|-----|-------------|
| any | woodCrusher |

**Code**

```lua
function WoodCrusher.turnOnWoodCrusher( self , woodCrusher)
    if self.isServer and woodCrusher.moveColNodes ~ = nil then
        for _, moveColNode in pairs(woodCrusher.moveColNodes) do
            setFrictionVelocity(moveColNode.node, woodCrusher.moveVelocityZ)
        end
    end

    if self.isClient then
        g_soundManager:stopSamples(woodCrusher.samples)
        woodCrusher.isWorkSamplePlaying = false
        g_soundManager:playSample(woodCrusher.samples.start)
        g_soundManager:playSample(woodCrusher.samples.idle, 0 , woodCrusher.samples.start)

        if self.isClient then
            g_animationManager:startAnimations(woodCrusher.animationNodes)
        end
    end
end

```

### updateTickWoodCrusher

**Description**

> Update tick wood crusher

**Definition**

> updateTickWoodCrusher(float dt, , , )

**Arguments**

| float | dt          | time since last call in ms |
|-------|-------------|----------------------------|
| any   | woodCrusher |                            |
| any   | dt          |                            |
| any   | isTurnedOn  |                            |

**Code**

```lua
function WoodCrusher.updateTickWoodCrusher( self , woodCrusher, dt, isTurnedOn)
    if isTurnedOn then
        if self.isServer then
            if woodCrusher.cutNode ~ = nil and next(woodCrusher.moveTriggerNodes) ~ = nil then
                local x,y,z = getWorldTranslation(woodCrusher.cutNode)
                local nx,ny,nz = localDirectionToWorld(woodCrusher.cutNode, 1 , 0 , 0 )
                local yx,yy,yz = localDirectionToWorld(woodCrusher.cutNode, 0 , 1 , 0 )
                for id in pairs(woodCrusher.moveTriggerNodes) do
                    if entityExists(id) then
                        local lenBelow, lenAbove = getSplitShapePlaneExtents(id, x,y,z, nx,ny,nz)
                        if lenAbove ~ = nil and lenBelow ~ = nil then
                            if lenBelow < = 0.4 then
                                woodCrusher.moveTriggerNodes[id] = nil
                                WoodCrusher.crushSplitShape( self , woodCrusher, id)
                            elseif lenAbove > = 0.2 then
                                    self.shapeBeingCut = id
                                    local minY = splitShape(id, x,y,z, nx,ny,nz, yx,yy,yz, woodCrusher.cutSizeY, woodCrusher.cutSizeZ, "woodCrusherSplitShapeCallback" , woodCrusher)
                                    g_treePlantManager:removingSplitShape(id)
                                    if minY ~ = nil then
                                        woodCrusher.moveTriggerNodes[id] = nil
                                    end
                                end
                            end
                        else
                                woodCrusher.moveTriggerNodes[id] = nil
                            end
                        end
                    end

                    if self.isServer and woodCrusher.moveColNodes ~ = nil then
                        for _, moveColNode in pairs(woodCrusher.moveColNodes) do
                            setTranslation(moveColNode.node, moveColNode.transX, moveColNode.transY + math.random() * 0.005 , moveColNode.transZ)
                        end
                    end
                end
            end

            if woodCrusher.crushingTime > 0 then
                woodCrusher.crushingTime = math.max(woodCrusher.crushingTime - dt, 0 )
            end

            local isCrushing = woodCrusher.crushingTime > 0

            if self.isClient then
                if isCrushing then
                    g_effectManager:setEffectTypeInfo(woodCrusher.crushEffects, FillType.WOODCHIPS)
                    g_effectManager:startEffects(woodCrusher.crushEffects)
                else
                        g_effectManager:stopEffects(woodCrusher.crushEffects)
                    end

                    if isTurnedOn and isCrushing then
                        if not woodCrusher.isWorkSamplePlaying then
                            g_soundManager:playSample(woodCrusher.samples.work)
                            woodCrusher.isWorkSamplePlaying = true
                        end
                    else
                            if woodCrusher.isWorkSamplePlaying then
                                g_soundManager:stopSample(woodCrusher.samples.work)
                                woodCrusher.isWorkSamplePlaying = false
                            end
                        end
                    end
                end

```

### updateWoodCrusher

**Description**

> Update wood crusher

**Definition**

> updateWoodCrusher(float dt, , , )

**Arguments**

| float | dt          | time since last call in ms |
|-------|-------------|----------------------------|
| any   | woodCrusher |                            |
| any   | dt          |                            |
| any   | isTurnedOn  |                            |

**Code**

```lua
function WoodCrusher.updateWoodCrusher( self , woodCrusher, dt, isTurnedOn)
    if isTurnedOn then
        if self.isServer then
            for node in pairs(woodCrusher.crushNodes) do
                WoodCrusher.crushSplitShape( self , woodCrusher, node)
                woodCrusher.crushNodes[node] = nil
                woodCrusher.moveTriggerNodes[node] = nil
            end

            local maxTreeSizeY = 0
            for id in pairs(woodCrusher.moveTriggerNodes) do
                if not entityExists(id) then
                    woodCrusher.moveTriggerNodes[id] = nil
                else
                        for i = 1 , #woodCrusher.downForceNodes do
                            local downForceNode = woodCrusher.downForceNodes[i]
                            if downForceNode.triggerNodes[id] ~ = nil or downForceNode.trigger = = nil then
                                local x, y, z = getWorldTranslation(downForceNode.node)
                                local nx, ny, nz = localDirectionToWorld(downForceNode.node, 1 , 0 , 0 )
                                local yx, yy, yz = localDirectionToWorld(downForceNode.node, 0 , 1 , 0 )

                                local minY,maxY, minZ,maxZ = testSplitShape(id, x,y,z, nx,ny,nz, yx,yy,yz, downForceNode.sizeY, downForceNode.sizeZ)
                                if minY ~ = nil then
                                    local cx,cy,cz = localToWorld(downForceNode.node, 0 , (minY + maxY) * 0.5 , (minZ + maxZ) * 0.5 )
                                    local downX,downY,downZ = localDirectionToWorld(downForceNode.node, 0 , - downForceNode.force, 0 )
                                    addForce(id, downX, downY, downZ, cx,cy,cz, false )
                                    --#debug drawDebugLine(cx, cy, cz, 1, 0, 0, cx+downX, cy+downY, cz+downZ, 0, 1, 0, true)
                                end
                            end
                        end

                        if woodCrusher.shapeSizeDetectionNode ~ = nil then
                            local x, y, z = getWorldTranslation(woodCrusher.shapeSizeDetectionNode)
                            local nx, ny, nz = localDirectionToWorld(woodCrusher.shapeSizeDetectionNode, 1 , 0 , 0 )
                            local yx, yy, yz = localDirectionToWorld(woodCrusher.shapeSizeDetectionNode, 0 , 1 , 0 )

                            local minY, maxY, _, _ = testSplitShape(id, x, y, z, nx, ny, nz, yx, yy, yz, woodCrusher.cutSizeY, woodCrusher.cutSizeZ)
                            if minY ~ = nil then
                                if woodCrusher.mainDrumRefNode ~ = nil then
                                    maxTreeSizeY = math.max(maxTreeSizeY, maxY)
                                end
                            end
                        end
                    end
                end
                if woodCrusher.mainDrumRefNode ~ = nil then
                    local x, y, z = getTranslation(woodCrusher.mainDrumRefNode)
                    local ty = math.min(maxTreeSizeY, woodCrusher.mainDrumRefNodeMaxY)
                    if ty > y then
                        y = math.min(y + 0.0003 * dt, ty)
                    else
                            y = math.max(y - 0.0003 * dt, ty)
                        end

                        setTranslation(woodCrusher.mainDrumRefNode, x, y, z)
                    end

                    if next(woodCrusher.moveTriggerNodes) ~ = nil or woodCrusher.crushingTime > 0 then
                        self:raiseActive()
                    end
                end
            end
        end

```

### woodCrusherDownForceTriggerCallback

**Description**

> Trigger callback

**Definition**

> woodCrusherDownForceTriggerCallback(integer triggerId, integer otherActorId, boolean onEnter, boolean onLeave, boolean
> onStay, integer otherShapeId, )

**Arguments**

| integer | triggerId    | id of trigger     |
|---------|--------------|-------------------|
| integer | otherActorId | id of other actor |
| boolean | onEnter      | on enter          |
| boolean | onLeave      | on leave          |
| boolean | onStay       | on stay           |
| integer | otherShapeId | id of other shape |
| any     | otherShapeId |                   |

**Code**

```lua
function WoodCrusher.woodCrusherDownForceTriggerCallback( self , triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local vehicle = g_currentMission.nodeToObject[otherActorId]
    if vehicle = = nil and getRigidBodyType(otherActorId) = = RigidBodyType.DYNAMIC then
        local splitType = g_splitShapeManager:getSplitTypeByIndex(getSplitType(otherActorId))
        if splitType ~ = nil and splitType.woodChipsPerLiter > 0 then
            for i = 1 , # self.downForceNodes do
                local downForceNode = self.downForceNodes[i]
                if downForceNode.trigger = = triggerId then
                    if onEnter then
                        downForceNode.triggerNodes[otherActorId] = Utils.getNoNil(downForceNode.triggerNodes[otherActorId], 0 ) + 1
                        self.vehicle:raiseActive()
                    elseif onLeave then
                            local c = downForceNode.triggerNodes[otherActorId]
                            if c ~ = nil then
                                c = c - 1
                                if c = = 0 then
                                    downForceNode.triggerNodes[otherActorId] = nil
                                else
                                        downForceNode.triggerNodes[otherActorId] = c
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

```

### woodCrusherMoveTriggerCallback

**Description**

> Trigger callback

**Definition**

> woodCrusherMoveTriggerCallback(integer triggerId, integer otherActorId, boolean onEnter, boolean onLeave, boolean
> onStay, integer otherShapeId, )

**Arguments**

| integer | triggerId    | id of trigger     |
|---------|--------------|-------------------|
| integer | otherActorId | id of other actor |
| boolean | onEnter      | on enter          |
| boolean | onLeave      | on leave          |
| boolean | onStay       | on stay           |
| integer | otherShapeId | id of other shape |
| any     | otherShapeId |                   |

**Code**

```lua
function WoodCrusher.woodCrusherMoveTriggerCallback( self , triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local vehicle = g_currentMission.nodeToObject[otherActorId]
    if vehicle = = nil and getRigidBodyType(otherActorId) = = RigidBodyType.DYNAMIC then
        local splitType = g_splitShapeManager:getSplitTypeByIndex(getSplitType(otherActorId))
        if splitType ~ = nil and splitType.woodChipsPerLiter > 0 then
            if onEnter then
                self.moveTriggerNodes[otherActorId] = Utils.getNoNil( self.moveTriggerNodes[otherActorId], 0 ) + 1
                self.vehicle:raiseActive()
            elseif onLeave then
                    local c = self.moveTriggerNodes[otherActorId]
                    if c ~ = nil then
                        c = c - 1
                        if c = = 0 then
                            self.moveTriggerNodes[otherActorId] = nil
                        else
                                self.moveTriggerNodes[otherActorId] = c
                            end
                        end
                    end
                end
            end
        end

```

### woodCrusherSplitShapeCallback

**Description**

> Split shape callback

**Definition**

> woodCrusherSplitShapeCallback(integer shape, boolean isBelow, boolean isAbove, float minY, float maxY, float minZ,
> float maxZ, )

**Arguments**

| integer | shape   | shape                |
|---------|---------|----------------------|
| boolean | isBelow | is below             |
| boolean | isAbove | is above             |
| float   | minY    | min y split position |
| float   | maxY    | max y split position |
| float   | minZ    | min z split position |
| float   | maxZ    | max z split position |
| any     | maxZ    |                      |

**Code**

```lua
function WoodCrusher.woodCrusherSplitShapeCallback( self , shape, isBelow, isAbove, minY, maxY, minZ, maxZ)
    if not isBelow then
        self.crushNodes[shape] = shape
        g_treePlantManager:addingSplitShape(shape, self.shapeBeingCut)
    end
end

```