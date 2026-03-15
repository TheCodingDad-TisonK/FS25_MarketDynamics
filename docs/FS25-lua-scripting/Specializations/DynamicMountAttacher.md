## DynamicMountAttacher

**Description**

> Specialization for automatically attaching objects to vehicles (e.g. cutters to cutter trailers, bales to
> baleforks, ...)

**Functions**

- [addDynamicMountedObject](#adddynamicmountedobject)
- [dynamicMountLockPositionOverlapCallback](#dynamicmountlockpositionoverlapcallback)
- [dynamicMountTriggerCallback](#dynamicmounttriggercallback)
- [forceDynamicMountPendingObjects](#forcedynamicmountpendingobjects)
- [forceUnmountDynamicMountedObjects](#forceunmountdynamicmountedobjects)
- [getAdditionalComponentMass](#getadditionalcomponentmass)
- [getAllowDynamicMountFillLevelInfo](#getallowdynamicmountfilllevelinfo)
- [getAllowDynamicMountObjects](#getallowdynamicmountobjects)
- [getDynamicMountAttacherSettingsByNode](#getdynamicmountattachersettingsbynode)
- [getDynamicMountTimeToMount](#getdynamicmounttimetomount)
- [getFillLevelInformation](#getfilllevelinformation)
- [getHasDynamicMountedObjects](#gethasdynamicmountedobjects)
- [getHasObjectMounted](#gethasobjectmounted)
- [getIsAttachedTo](#getisattachedto)
- [getIsDynamicLockPositionActive](#getisdynamiclockpositionactive)
- [getIsDynamicMountGrabOpened](#getisdynamicmountgrabopened)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsMovingToolActive](#getismovingtoolactive)
- [initSpecialization](#initspecialization)
- [loadDynamicLockPositionFromXML](#loaddynamiclockpositionfromxml)
- [loadDynamicMountGrabFromXML](#loaddynamicmountgrabfromxml)
- [loadExtraDependentParts](#loadextradependentparts)
- [loadMovingToolFromXML](#loadmovingtoolfromxml)
- [lockDynamicMountedObject](#lockdynamicmountedobject)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPreAttachImplement](#onpreattachimplement)
- [onReadUpdateStream](#onreadupdatestream)
- [onUnmountObject](#onunmountobject)
- [onUpdateTick](#onupdatetick)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [readDynamicMountObjectsFromStream](#readdynamicmountobjectsfromstream)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeDynamicMountedObject](#removedynamicmountedobject)
- [setDynamicMountAnimationState](#setdynamicmountanimationstate)
- [updateDebugValues](#updatedebugvalues)
- [updateExtraDependentParts](#updateextradependentparts)
- [writeDynamicMountObjectsToStream](#writedynamicmountobjectstostream)

### addDynamicMountedObject

**Description**

**Definition**

> addDynamicMountedObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function DynamicMountAttacher:addDynamicMountedObject(object)
    local spec = self.spec_dynamicMountAttacher

    if spec.dynamicMountedObjects[object] = = nil then
        spec.dynamicMountedObjects[object] = object

        local lockedToPosition = false
        if object.getMountableLockPositions ~ = nil then
            local lockPositions = object:getMountableLockPositions()
            for i = 1 , #lockPositions do
                local position = lockPositions[i]
                if string.endsWith( self.configFileName, position.xmlFilename) then
                    local jointNode = I3DUtil.indexToObject( self.components, position.jointNode, self.i3dMappings)
                    if jointNode ~ = nil then
                        local x, y, z = localToWorld(jointNode, position.transOffset[ 1 ], position.transOffset[ 2 ], position.transOffset[ 3 ])
                        local rx, ry, rz = localRotationToWorld(jointNode, position.rotOffset[ 1 ], position.rotOffset[ 2 ], position.rotOffset[ 3 ])
                        if self:lockDynamicMountedObject(object, x, y, z, rx, ry, rz) then
                            lockedToPosition = true
                            break
                        end
                    end
                end
            end
        end

        if not lockedToPosition and object:isa( Vehicle ) then
            local minDistancePosition
            local minDistance = math.huge
            for _, lockPosition in ipairs(spec.lockPositions) do
                if self:getIsDynamicLockPositionActive(lockPosition) then
                    if object.configFileName ~ = nil and string.endsWith(object.configFileName, lockPosition.xmlFilename) then
                        local foundVehicle = true
                        if next(lockPosition.configurations) ~ = nil then
                            for configName, configIndex in pairs(lockPosition.configurations) do
                                foundVehicle = foundVehicle and(object.configurations = = nil or object.configurations[configName] = = configIndex)
                            end
                        end

                        if foundVehicle then
                            local distance = calcDistanceFrom(lockPosition.jointNode, object.rootNode)
                            if distance < minDistance then
                                minDistance = distance
                                minDistancePosition = lockPosition
                            end
                        end
                    end
                end
            end

            if minDistancePosition ~ = nil then
                if minDistancePosition.width ~ = nil and minDistancePosition.length ~ = nil and minDistancePosition.height ~ = nil then
                    local x, y, z = localToWorld(minDistancePosition.jointNode, 0 , minDistancePosition.height * 0.5 , 0 )
                    local rx, ry, rz = getWorldRotation(minDistancePosition.jointNode)

                    spec.overlapBoxHasCollision = false
                    spec.overlapBoxIgnoreVehicle = object
                    overlapBox(x, y, z, rx, ry, rz, minDistancePosition.width * 0.5 , minDistancePosition.height * 0.5 , minDistancePosition.length * 0.5 , "dynamicMountLockPositionOverlapCallback" , self , CollisionFlag.VEHICLE, true , false , false , true )
                    if spec.overlapBoxHasCollision then
                        minDistancePosition = nil
                    end
                    spec.overlapBoxIgnoreVehicle = nil
                end
            end

            if minDistancePosition ~ = nil then
                local x, y, z = getWorldTranslation(minDistancePosition.jointNode)
                local rx, ry, rz = getWorldRotation(minDistancePosition.jointNode)
                if self:lockDynamicMountedObject(object, x, y, z, rx, ry, rz) then
                    ObjectChangeUtil.setObjectChanges(minDistancePosition.objectChanges, true , self , self.setMovingToolDirty)

                    minDistancePosition.state = true
                    minDistancePosition.object = object
                end
            end
        end

        if spec.transferMass then
            if object.setReducedComponentMass ~ = nil then
                if object:getAllowComponentMassReduction() then
                    object:setReducedComponentMass( true )
                    self:setMassDirty()
                end
            end
        end

        if not spec.collisionBetweenObjects then
            for otherObject,_ in pairs(spec.dynamicMountedObjects) do
                if otherObject ~ = object then
                    local node1 = object.nodeId or object.rootNode
                    local node2 = otherObject.nodeId or otherObject.rootNode
                    if node1 ~ = nil and node2 ~ = nil then
                        setPairCollision(node1, node2, false )
                    end
                end
            end
        end

        self:setDynamicMountAnimationState( true )

        self:raiseDirtyFlags(spec.dynamicMountedObjectsDirtyFlag)
    end
end

```

### dynamicMountLockPositionOverlapCallback

**Description**

**Definition**

> dynamicMountLockPositionOverlapCallback()

**Arguments**

| any | transformId |
|-----|-------------|

**Code**

```lua
function DynamicMountAttacher:dynamicMountLockPositionOverlapCallback(transformId)
    if g_currentMission.nodeToObject[transformId] ~ = nil or g_currentMission.players[transformId] ~ = nil then
        local spec = self.spec_dynamicMountAttacher
        if g_currentMission.nodeToObject[transformId] ~ = self and g_currentMission.nodeToObject[transformId] ~ = spec.overlapBoxIgnoreVehicle then
            spec.overlapBoxHasCollision = true
        end
    end
end

```

### dynamicMountTriggerCallback

**Description**

**Definition**

> dynamicMountTriggerCallback()

**Arguments**

| any | triggerId    |
|-----|--------------|
| any | otherActorId |
| any | onEnter      |
| any | onLeave      |
| any | onStay       |
| any | otherShapeId |

**Code**

```lua
function DynamicMountAttacher:dynamicMountTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_dynamicMountAttacher

    if spec.limitToKnownObjects then
        local object = g_currentMission:getNodeObject(otherActorId)
        if object ~ = nil then
            local foundVehicle = false
            for i = 1 , #spec.lockPositions do
                local position = spec.lockPositions[i]
                if not position.state then
                    if object.configFileName ~ = nil and string.endsWith(object.configFileName, position.xmlFilename) then
                        foundVehicle = true
                        if next(position.configurations) ~ = nil then
                            for configName, configIndex in pairs(position.configurations) do
                                foundVehicle = foundVehicle and(object.configurations = = nil or object.configurations[configName] = = configIndex)
                            end
                        end

                        if foundVehicle then
                            break
                        end
                    end
                end
            end

            if not foundVehicle then
                return
            end
        end
    end

    if getRigidBodyType(otherActorId) = = RigidBodyType.DYNAMIC
        and not getHasTrigger(otherActorId) then
        if onEnter then
            local object = g_currentMission:getNodeObject(otherActorId)
            if object = = nil then
                object = g_currentMission.nodeToObject[otherActorId]
            end
            if object = = self.rootVehicle or( self.spec_attachable ~ = nil and self.spec_attachable.attacherVehicle = = object) then
                object = nil
            end
            if object ~ = nil and object ~ = self then
                -- is a mountable object(e.g.bales)
                local isObject = object.getSupportsMountDynamic ~ = nil and object:getSupportsMountDynamic() and object.lastMoveTime ~ = nil

                -- is a mountable vehicle(e.g.pallets)
                local isVehicle = object.getSupportsTensionBelts ~ = nil and object:getSupportsTensionBelts() and object.lastMoveTime ~ = nil

                if isObject or isVehicle then
                    spec.pendingDynamicMountObjects[object] = Utils.getNoNil(spec.pendingDynamicMountObjects[object], 0 ) + 1

                    if spec.pendingDynamicMountObjects[object] = = 1 then
                        self:raiseDirtyFlags(spec.dynamicMountedObjectsDirtyFlag)
                    end
                end
            end
        elseif onLeave then
                local object = g_currentMission:getNodeObject(otherActorId)
                if object = = nil then
                    object = g_currentMission.nodeToObject[otherActorId]
                end
                if object ~ = nil then
                    if spec.pendingDynamicMountObjects[object] ~ = nil then
                        local count = spec.pendingDynamicMountObjects[object] - 1
                        if count = = 0 then
                            spec.pendingDynamicMountObjects[object] = nil

                            if spec.dynamicMountedObjects[object] ~ = nil then
                                self:removeDynamicMountedObject(object, false )
                                object:unmountDynamic()

                                if object.additionalDynamicMountJointNode ~ = nil then
                                    delete(object.additionalDynamicMountJointNode)
                                    object.additionalDynamicMountJointNode = nil
                                end
                            end

                            self:raiseDirtyFlags(spec.dynamicMountedObjectsDirtyFlag)
                        else
                                spec.pendingDynamicMountObjects[object] = count
                            end
                        end
                    end
                end
            end
        end

```

### forceDynamicMountPendingObjects

**Description**

**Definition**

> forceDynamicMountPendingObjects()

**Arguments**

| any | onlyBales |
|-----|-----------|

**Code**

```lua
function DynamicMountAttacher:forceDynamicMountPendingObjects(onlyBales)
    if self:getAllowDynamicMountObjects() then
        local spec = self.spec_dynamicMountAttacher
        for object,_ in pairs(spec.pendingDynamicMountObjects) do
            if spec.dynamicMountedObjects[object] = = nil then
                if not onlyBales or object:isa( Bale ) then
                    local trigger = spec.dynamicMountAttacherTrigger
                    local couldMount = object:mountDynamic( self , trigger.rootNode, trigger.jointNode, trigger.mountType, trigger.forceAcceleration)
                    if couldMount then
                        self:addDynamicMountedObject(object)
                    end
                end
            end
        end
    end
end

```

### forceUnmountDynamicMountedObjects

**Description**

**Definition**

> forceUnmountDynamicMountedObjects()

**Code**

```lua
function DynamicMountAttacher:forceUnmountDynamicMountedObjects()
    local spec = self.spec_dynamicMountAttacher
    for object, _ in pairs(spec.dynamicMountedObjects) do
        self:removeDynamicMountedObject(object, false )
        object:unmountDynamic()

        if object.additionalDynamicMountJointNode ~ = nil then
            delete(object.additionalDynamicMountJointNode)
            object.additionalDynamicMountJointNode = nil
        end
    end
end

```

### getAdditionalComponentMass

**Description**

**Definition**

> getAdditionalComponentMass()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | component |

**Code**

```lua
function DynamicMountAttacher:getAdditionalComponentMass(superFunc, component)
    local additionalMass = superFunc( self , component)
    local spec = self.spec_dynamicMountAttacher

    if spec.dynamicMountAttacherTrigger ~ = nil and spec.transferMass then
        if spec.dynamicMountAttacherTrigger.component = = component.node then
            for object, _ in pairs(spec.dynamicMountedObjects) do
                if object.getAllowComponentMassReduction ~ = nil and object:getAllowComponentMassReduction() then
                    additionalMass = additionalMass + (object:getDefaultMass() - 0.1 )
                end
            end
        end
    end

    return additionalMass
end

```

### getAllowDynamicMountFillLevelInfo

**Description**

**Definition**

> getAllowDynamicMountFillLevelInfo()

**Code**

```lua
function DynamicMountAttacher:getAllowDynamicMountFillLevelInfo()
    return true
end

```

### getAllowDynamicMountObjects

**Description**

**Definition**

> getAllowDynamicMountObjects()

**Code**

```lua
function DynamicMountAttacher:getAllowDynamicMountObjects()
    return true
end

```

### getDynamicMountAttacherSettingsByNode

**Description**

**Definition**

> getDynamicMountAttacherSettingsByNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function DynamicMountAttacher:getDynamicMountAttacherSettingsByNode(node)
    local spec = self.spec_dynamicMountAttacher
    for _, fork in pairs(spec.forks) do
        if fork.node = = node then
            return fork.mountType, fork.forceLimitScale
        end
    end

    return DynamicMountUtil.TYPE_FORK, 1
end

```

### getDynamicMountTimeToMount

**Description**

**Definition**

> getDynamicMountTimeToMount()

**Code**

```lua
function DynamicMountAttacher:getDynamicMountTimeToMount()
    return self.spec_dynamicMountAttacher.dynamicMountAttacherTimeToMount
end

```

### getFillLevelInformation

**Description**

**Definition**

> getFillLevelInformation()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | display   |

**Code**

```lua
function DynamicMountAttacher:getFillLevelInformation(superFunc, display)
    superFunc( self , display)

    if self:getAllowDynamicMountFillLevelInfo() then
        local spec = self.spec_dynamicMountAttacher
        for object,_ in pairs(spec.dynamicMountedObjects) do
            if object.getFillLevelInformation ~ = nil then
                object:getFillLevelInformation(display)
            else
                    if object.getFillLevel ~ = nil and object.getFillType ~ = nil then
                        local fillType = object:getFillType()
                        local fillLevel = object:getFillLevel()
                        local capacity = fillLevel
                        if object.getCapacity ~ = nil then
                            capacity = object:getCapacity()
                        end

                        display:addFillLevel(fillType, fillLevel, capacity)
                    end
                end
            end
        end
    end

```

### getHasDynamicMountedObjects

**Description**

**Definition**

> getHasDynamicMountedObjects()

**Code**

```lua
function DynamicMountAttacher:getHasDynamicMountedObjects()
    return next( self.spec_dynamicMountAttacher.dynamicMountedObjects) ~ = nil
end

```

### getHasObjectMounted

**Description**

> Returns if the vehicle (or any child) has the given object mounted

**Definition**

> getHasObjectMounted(table object, )

**Arguments**

| table | object | object |
|-------|--------|--------|
| any   | object |        |

**Return Values**

| any | hasObjectMounted | has object mounted |
|-----|------------------|--------------------|

**Code**

```lua
function DynamicMountAttacher:getHasObjectMounted(superFunc, object)
    if superFunc( self , object) then
        return true
    end

    local spec = self.spec_dynamicMountAttacher
    for dynamicMountedObject, _ in pairs(spec.dynamicMountedObjects) do
        if dynamicMountedObject = = object then
            return true
        end

        if dynamicMountedObject.getHasObjectMounted ~ = nil then
            if dynamicMountedObject:getHasObjectMounted(object) then
                return true
            end
        end
    end

    return false
end

```

### getIsAttachedTo

**Description**

**Definition**

> getIsAttachedTo()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | vehicle   |

**Code**

```lua
function DynamicMountAttacher:getIsAttachedTo(superFunc, vehicle)
    if superFunc( self , vehicle) then
        return true
    end

    local spec = self.spec_dynamicMountAttacher

    for object, _ in pairs(spec.dynamicMountedObjects) do
        if object = = vehicle then
            return true
        end
    end

    for object, _ in pairs(spec.pendingDynamicMountObjects) do
        if object = = vehicle then
            return true
        end
    end

    return false
end

```

### getIsDynamicLockPositionActive

**Description**

**Definition**

> getIsDynamicLockPositionActive()

**Arguments**

| any | lockPosition |
|-----|--------------|

**Code**

```lua
function DynamicMountAttacher:getIsDynamicLockPositionActive(lockPosition)
    return not lockPosition.state
end

```

### getIsDynamicMountGrabOpened

**Description**

**Definition**

> getIsDynamicMountGrabOpened()

**Arguments**

| any | grab |
|-----|------|

**Code**

```lua
function DynamicMountAttacher:getIsDynamicMountGrabOpened(grab)
    return true
end

```

### getIsFoldAllowed

**Description**

> Returns if fold is allowed

**Definition**

> getIsFoldAllowed()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | direction  |
| any | onAiTurnOn |

**Return Values**

| any | allowsFold | allows folding |
|-----|------------|----------------|

**Code**

```lua
function DynamicMountAttacher:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_dynamicMountAttacher

    if not spec.allowFoldingWhileMounted and self:getHasDynamicMountedObjects() then
        return false , g_i18n:getText( "warning_toolIsFull" )
    end

    return superFunc( self , direction, onAiTurnOn)
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
function DynamicMountAttacher:getIsMovingToolActive(superFunc, movingTool)
    if not movingTool.dynamicMountAttacherAllowedMounted then
        if next( self.spec_dynamicMountAttacher.dynamicMountedObjects) ~ = nil then
            return false
        end
    end

    return superFunc( self , movingTool)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function DynamicMountAttacher.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "DynamicMountAttacher" )

    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMountAttacher#node" , "Attacher node" )
    schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher#forceLimitScale" , "Force limit" , 1 )
    schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher#timeToMount" , "No movement time until mounting" , 1000 )
    schema:register(XMLValueType.BOOL, "vehicle.dynamicMountAttacher#stateChangeMount" , "Mount / unmount the object while the allowed state changes(e.g.due to foldable limits)" , false )
        schema:register(XMLValueType.INT, "vehicle.dynamicMountAttacher#numObjectBits" , "Number of object bits to sync" , 5 )

        schema:register(XMLValueType.BOOL, "vehicle.dynamicMountAttacher#limitToKnownObjects" , "Only mount objects that are defined with a lockPosition" , false )
        schema:register(XMLValueType.BOOL, "vehicle.dynamicMountAttacher#collisionBetweenObjects" , "Collision between mounted objects is enabled" , true )

        schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher.grab#openMountType" , "Open mount type" , "TYPE_FORK" )
        schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher.grab#closedMountType" , "Closed mount type" , "TYPE_AUTO_ATTACH_XYZ" )

        schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMountAttacher.fork(?)#node" , "Fork collision node(starting from FS25 one combined node for front and back part)" )
            schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher.fork(?)#mountType" , "Mount type that is used if object is mounted via this fork node" , "FORK" )
                schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher.fork(?)#forceLimitScale" , "Force limit that is used if object is mounted via this fork node" , 1 )

                    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMountAttacher#triggerNode" , "Trigger node" )
                    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMountAttacher#rootNode" , "Root node" )
                    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMountAttacher#jointNode" , "Joint node" )
                    schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher#forceAcceleration" , "Force acceleration" , 30 )
                    schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher#mountType" , "Mount type" , "TYPE_AUTO_ATTACH_XZ" )

                    schema:register(XMLValueType.BOOL, "vehicle.dynamicMountAttacher#transferMass" , "If this is set to 'true' the mass of the object to mount is transferred to our own component.This improves physics stability" , false )

                    schema:addDelayedRegistrationPath( "vehicle.dynamicMountAttacher.lockPosition(?)" , "DynamicMountAttacher:lockPosition" )
                    schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher.lockPosition(?)#xmlFilename" , "XML filename of vehicle to lock(needs to match only the end of the filename)" )
                    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMountAttacher.lockPosition(?)#jointNode" , "Joint node(Represents the position of the other vehicles root node)" )
                    schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher.lockPosition(?).configuration(?)#name" , "Name of configuration" )
                    schema:register(XMLValueType.INT, "vehicle.dynamicMountAttacher.lockPosition(?).configuration(?)#index" , "Configuration index that needs to match to use the lock position" )
                    schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher.lockPosition(?)#width" , "Width of lock position(if defined, collision to other vehicles is checked during locking)" )
                        schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher.lockPosition(?)#length" , "Length of lock position(if defined, collision to other vehicles is checked during locking)" )
                            schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher.lockPosition(?)#height" , "Height of lock position(if defined, collision to other vehicles is checked during locking)" )

                                ObjectChangeUtil.registerObjectChangeXMLPaths(schema, "vehicle.dynamicMountAttacher.lockPosition(?)" )

                                schema:register(XMLValueType.STRING, "vehicle.dynamicMountAttacher.animation#name" , "Animation name" )
                                schema:register(XMLValueType.FLOAT, "vehicle.dynamicMountAttacher.animation#speed" , "Animation speed" , 1 )

                                schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
                                    cSchema:register(XMLValueType.BOOL, cKey .. ".dynamicMountAttacher#value" , "Update dynamic mount attacher joints" )
                                    cSchema:register(XMLValueType.BOOL, cKey .. ".dynamicMountAttacher#allowedMounted" , "Allow moving tool movement while something is mounted" , true )
                                    end )

                                    schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
                                        cSchema:register(XMLValueType.BOOL, cKey .. ".dynamicMountAttacher#value" , "Update dynamic mount attacher joints" )
                                    end )

                                    schema:register(XMLValueType.BOOL, "vehicle.dynamicMountAttacher#allowFoldingWhileMounted" , "Folding is allowed while a object is mounted" , true )

                                        schema:setXMLSpecializationType()
                                    end

```

### loadDynamicLockPositionFromXML

**Description**

**Definition**

> loadDynamicLockPositionFromXML()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | lockPosition |

**Code**

```lua
function DynamicMountAttacher:loadDynamicLockPositionFromXML(xmlFile, key, lockPosition)
    lockPosition.xmlFilename = xmlFile:getValue(key .. "#xmlFilename" )
    if lockPosition.xmlFilename = = nil then
        Logging.xmlWarning(xmlFile, "Missing xmlFilename for lock position '%s'" , key)
            return false
        else
                lockPosition.xmlFilename = lockPosition.xmlFilename:gsub( "$data" , "data" )
            end

            lockPosition.jointNode = xmlFile:getValue(key .. "#jointNode" , nil , self.components, self.i3dMappings)
            if lockPosition.jointNode = = nil then
                Logging.xmlWarning(xmlFile, "Missing jointNode for lock position '%s'" , key)
                    return false
                end

                lockPosition.configurations = { }
                xmlFile:iterate(key .. ".configuration" , function (_, configKey)
                    local name = self.xmlFile:getValue(configKey .. "#name" )
                    local index = self.xmlFile:getValue(configKey .. "#index" )
                    if name ~ = nil and index ~ = nil then
                        lockPosition.configurations[name] = index
                    end
                end )

                lockPosition.width = xmlFile:getValue(key .. "#width" )
                lockPosition.length = xmlFile:getValue(key .. "#length" )
                lockPosition.height = xmlFile:getValue(key .. "#height" )

                lockPosition.objectChanges = { }
                ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, key, lockPosition.objectChanges, self.components, self )

                lockPosition.state = false

                return true
            end

```

### loadDynamicMountGrabFromXML

**Description**

**Definition**

> loadDynamicMountGrabFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |
| any | entry   |

**Code**

```lua
function DynamicMountAttacher:loadDynamicMountGrabFromXML(xmlFile, key, entry)
    local openMountType = self.xmlFile:getValue(key .. "#openMountType" )
    entry.openMountType = Utils.getNoNil(DynamicMountUtil[openMountType], DynamicMountUtil.TYPE_FORK)

    local closedMountType = self.xmlFile:getValue(key .. "#closedMountType" )
    entry.closedMountType = Utils.getNoNil(DynamicMountUtil[closedMountType], DynamicMountUtil.TYPE_AUTO_ATTACH_XYZ)

    entry.currentMountType = entry.openMountType

    return true
end

```

### loadExtraDependentParts

**Description**

**Definition**

> loadExtraDependentParts()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | xmlFile   |
| any | baseName  |
| any | entry     |

**Code**

```lua
function DynamicMountAttacher:loadExtraDependentParts(superFunc, xmlFile, baseName, entry)
    if not superFunc( self , xmlFile, baseName, entry) then
        return false
    end

    entry.updateDynamicMountAttacher = xmlFile:getValue(baseName .. ".dynamicMountAttacher#value" )

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
function DynamicMountAttacher:loadMovingToolFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.dynamicMountAttacherAllowedMounted = xmlFile:getValue(key .. ".dynamicMountAttacher#allowedMounted" , true )

    return true
end

```

### lockDynamicMountedObject

**Description**

**Definition**

> lockDynamicMountedObject()

**Arguments**

| any | object |
|-----|--------|
| any | x      |
| any | y      |
| any | z      |
| any | rx     |
| any | ry     |
| any | rz     |

**Code**

```lua
function DynamicMountAttacher:lockDynamicMountedObject(object, x, y, z, rx, ry, rz)
    local spec = self.spec_dynamicMountAttacher

    DynamicMountUtil.unmountDynamic(object, false )

    object:removeFromPhysics()
    spec.pendingDynamicMountObjects[object] = nil -- will be readded on addToPhysics

    object:setAbsolutePosition(x, y, z, rx, ry, rz, nil )
    object:addToPhysics()

    local trigger = spec.dynamicMountAttacherTrigger

    local couldMount = object:mountDynamic( self , trigger.rootNode, trigger.jointNode, trigger.mountType, trigger.forceAcceleration)
    if not couldMount then
        self:removeDynamicMountedObject(object, false )
        return false
    end

    return true
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function DynamicMountAttacher:onDelete()
    local spec = self.spec_dynamicMountAttacher

    if self.isServer and spec.dynamicMountedObjects ~ = nil then
        for object,_ in pairs(spec.dynamicMountedObjects) do
            object:unmountDynamic()
        end
    end
    if spec.dynamicMountAttacherTrigger ~ = nil then
        removeTrigger(spec.dynamicMountAttacherTrigger.triggerNode)

        g_currentMission:removeNodeObject(spec.dynamicMountAttacherTrigger.triggerNode)
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
function DynamicMountAttacher:onLoad(savegame)
    local spec = self.spec_dynamicMountAttacher

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.dynamicMountAttacher#index" , "vehicle.dynamicMountAttacher#node" ) --FS17 to FS19
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.dynamicMountAttacher.mountCollisionMask" , "vehicle.dynamicMountAttacher.fork" ) --FS22 to FS25

    -- Allow mountable object to attach them selfs to us
    spec.dynamicMountAttacherNode = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#node" , nil , self.components, self.i3dMappings)
    spec.dynamicMountAttacherForceLimitScale = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#forceLimitScale" , 1 )
    spec.dynamicMountAttacherTimeToMount = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#timeToMount" , 1000 )
    spec.dynamicMountAttacherStateChangeMount = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#stateChangeMount" , false )
    spec.numObjectBits = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#numObjectBits" , 5 )
    spec.maxNumObjectsToSend = 2 ^ spec.numObjectBits - 1
    spec.limitToKnownObjects = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#limitToKnownObjects" , false )
    spec.collisionBetweenObjects = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#collisionBetweenObjects" , true )

    local grabKey = "vehicle.dynamicMountAttacher.grab"
    if self.xmlFile:hasProperty(grabKey) then
        spec.dynamicMountAttacherGrab = { }
        self:loadDynamicMountGrabFromXML( self.xmlFile, grabKey, spec.dynamicMountAttacherGrab)
    end

    spec.pendingDynamicMountObjects = { }
    spec.lockPositions = { }

    if self.isServer then
        spec.forks = { }

        for _, key in self.xmlFile:iterator( "vehicle.dynamicMountAttacher.fork" ) do
            local fork = { }
            fork.node = self.xmlFile:getValue(key .. "#node" , nil , self.components, self.i3dMappings)
            if fork.node ~ = nil then
                if getCollisionFilterGroup(fork.node) ~ = CollisionFlag.VEHICLE_FORK then
                    Logging.xmlWarning( self.xmlFile, "Fork node '%s' has invalid collision filter group, should have %s!" , getName(fork.node), CollisionFlag.getBitAndName(CollisionFlag.VEHICLE_FORK))
                    continue
                end

                local mountTypeStr = self.xmlFile:getValue(key .. "#mountType" , "FORK" )
                fork.mountType = DynamicMountUtil[ "TYPE_" .. mountTypeStr] or DynamicMountUtil.TYPE_FORK
                fork.forceLimitScale = self.xmlFile:getValue(key .. "#forceLimitScale" , spec.dynamicMountAttacherForceLimitScale)

                table.insert(spec.forks, fork)
            else
                    Logging.xmlWarning( self.xmlFile, "Missing node or fork in '%s'" , key)
                end
            end

            local dynamicMountTrigger = { }
            dynamicMountTrigger.triggerNode = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#triggerNode" , nil , self.components, self.i3dMappings)
            dynamicMountTrigger.rootNode = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#rootNode" , nil , self.components, self.i3dMappings)
            dynamicMountTrigger.jointNode = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#jointNode" , nil , self.components, self.i3dMappings)
            if dynamicMountTrigger.triggerNode ~ = nil and dynamicMountTrigger.rootNode ~ = nil and dynamicMountTrigger.jointNode ~ = nil then
                local collisionMask = getCollisionFilterMask(dynamicMountTrigger.triggerNode)
                if bit32.band(collisionMask, CollisionFlag.DYNAMIC_OBJECT + CollisionFlag.VEHICLE) > 0 then
                    addTrigger(dynamicMountTrigger.triggerNode, "dynamicMountTriggerCallback" , self )

                    dynamicMountTrigger.forceAcceleration = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#forceAcceleration" , 30 )
                    local mountTypeString = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#mountType" , "TYPE_AUTO_ATTACH_XZ" )
                    dynamicMountTrigger.mountType = Utils.getNoNil(DynamicMountUtil[mountTypeString], DynamicMountUtil.TYPE_AUTO_ATTACH_XZ)
                    dynamicMountTrigger.currentMountType = dynamicMountTrigger.mountType
                    dynamicMountTrigger.component = self:getParentComponent(dynamicMountTrigger.triggerNode)

                    spec.dynamicMountAttacherTrigger = dynamicMountTrigger
                else
                        Logging.xmlWarning( self.xmlFile, "Dynamic Mount trigger has invalid collision filter mask, should have %s or %s!" , CollisionFlag.getBitAndName(CollisionFlag.DYNAMIC_OBJECT), CollisionFlag.getBitAndName(CollisionFlag.VEHICLE))
                    end

                    if string.contains( string.lower(getName(dynamicMountTrigger.jointNode)), "cutter" ) then
                        if bit32.band(collisionMask,CollisionFlag.VEHICLE) = = 0 then
                            Logging.xmlWarning( self.xmlFile, "Dynamic Mount trigger has invalid collision filter mask, should have %s for cutter trailers!" , CollisionFlag.getBitAndName(CollisionFlag.VEHICLE))
                            end
                        end

                        g_currentMission:addNodeObject(dynamicMountTrigger.triggerNode, self )
                    end

                    spec.transferMass = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#transferMass" , false )

                    self.xmlFile:iterate( "vehicle.dynamicMountAttacher.lockPosition" , function (_, key)
                        local lockPosition = { }
                        if self:loadDynamicLockPositionFromXML( self.xmlFile, key, lockPosition) then
                            table.insert(spec.lockPositions, lockPosition)
                        end
                    end )
                end

                spec.animationName = self.xmlFile:getValue( "vehicle.dynamicMountAttacher.animation#name" )
                spec.animationSpeed = self.xmlFile:getValue( "vehicle.dynamicMountAttacher.animation#speed" , 1 )
                if spec.animationName ~ = nil then
                    self:playAnimation(spec.animationName, spec.animationSpeed, self:getAnimationTime(spec.animationName), true )
                end

                spec.allowFoldingWhileMounted = self.xmlFile:getValue( "vehicle.dynamicMountAttacher#allowFoldingWhileMounted" , true )

                spec.lastMountingIsAllowed = false

                spec.overlapBoxHasCollision = false
                spec.overlapBoxIgnoreVehicle = nil

                spec.dynamicMountedObjects = { }
                spec.dynamicMountedObjectsDirtyFlag = self:getNextDirtyFlag()
            end

```

### onPreAttachImplement

**Description**

**Definition**

> onPreAttachImplement()

**Arguments**

| any | object              |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |
| any | loadFromSavegame    |

**Code**

```lua
function DynamicMountAttacher:onPreAttachImplement(object, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local objSpec = object.spec_dynamicMountAttacher
    if objSpec ~ = nil and self.isServer then
        objSpec.pendingDynamicMountObjects[ self ] = nil
        if objSpec.dynamicMountedObjects[ self ] ~ = nil then
            object:removeDynamicMountedObject( self , false )
            self:unmountDynamic()

            if object.additionalDynamicMountJointNode ~ = nil then
                delete(object.additionalDynamicMountJointNode)
                object.additionalDynamicMountJointNode = nil
            end
        end
    end
end

```

### onReadUpdateStream

**Description**

**Definition**

> onReadUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | timestamp  |
| any | connection |

**Code**

```lua
function DynamicMountAttacher:onReadUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        local spec = self.spec_dynamicMountAttacher

        if streamReadBool(streamId) then
            local sum = self:readDynamicMountObjectsFromStream(streamId, spec.dynamicMountedObjects)
            self:setDynamicMountAnimationState(sum > 0 )

            self:readDynamicMountObjectsFromStream(streamId, spec.pendingDynamicMountObjects)
        end
    end
end

```

### onUnmountObject

**Description**

**Definition**

> onUnmountObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function DynamicMountAttacher:onUnmountObject(object)
    local spec = self.spec_dynamicMountAttacher
    if spec.dynamicMountedObjects[object] ~ = nil then
        self:removeDynamicMountedObject(object, false )
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
function DynamicMountAttacher:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self.spec_dynamicMountAttacher
        local mountingIsAllowed = self:getAllowDynamicMountObjects()
        if mountingIsAllowed ~ = spec.lastMountingIsAllowed or not spec.dynamicMountAttacherStateChangeMount then
            spec.lastMountingIsAllowed = mountingIsAllowed

            if mountingIsAllowed then
                for object,_ in pairs(spec.pendingDynamicMountObjects) do
                    -- raise active as long as we got pending objects to give the objects a chance to be mounted if they are not moving
                        self:raiseActive()

                        if spec.dynamicMountedObjects[object] = = nil then
                            if object.lastMoveTime + self:getDynamicMountTimeToMount() < g_currentMission.time then
                                local doAttach = false
                                local objectRoot
                                if object.components ~ = nil then
                                    if object.getCanBeMounted ~ = nil then
                                        doAttach = object:getCanBeMounted()
                                    elseif entityExists(object.components[ 1 ].node) then
                                            doAttach = true
                                        end

                                        objectRoot = object.components[ 1 ].node
                                    end
                                    if object.nodeId ~ = nil then
                                        if object.getCanBeMounted ~ = nil then
                                            doAttach = object:getCanBeMounted()
                                        elseif entityExists(object.nodeId) then
                                                doAttach = true
                                            end
                                            objectRoot = object.nodeId
                                        end
                                        if doAttach then
                                            local trigger = spec.dynamicMountAttacherTrigger
                                            local objectJoint = createTransformGroup( "dynamicMountObjectJoint" )
                                            link(trigger.jointNode, objectJoint)
                                            setWorldTranslation(objectJoint, getWorldTranslation(objectRoot))

                                            local couldMount = object:mountDynamic( self , trigger.rootNode, objectJoint, trigger.mountType, trigger.forceAcceleration)
                                            if couldMount then
                                                object.additionalDynamicMountJointNode = objectJoint
                                                self:addDynamicMountedObject(object)
                                            else
                                                    delete(objectJoint)
                                                end
                                            else
                                                    spec.pendingDynamicMountObjects[object] = nil

                                                    self:raiseDirtyFlags(spec.dynamicMountedObjectsDirtyFlag)
                                                end
                                            end
                                        else
                                                spec.pendingDynamicMountObjects[object] = nil
                                            end
                                        end
                                    else
                                            for object,_ in pairs(spec.dynamicMountedObjects) do
                                                self:removeDynamicMountedObject(object, false )
                                                object:unmountDynamic()

                                                if object.additionalDynamicMountJointNode ~ = nil then
                                                    delete(object.additionalDynamicMountJointNode)
                                                    object.additionalDynamicMountJointNode = nil
                                                end
                                            end
                                        end
                                    end

                                    if spec.dynamicMountAttacherGrab ~ = nil then
                                        for object,_ in pairs(spec.dynamicMountedObjects) do
                                            local usedMountType = spec.dynamicMountAttacherGrab.closedMountType

                                            if self:getIsDynamicMountGrabOpened(spec.dynamicMountAttacherGrab) then
                                                usedMountType = spec.dynamicMountAttacherGrab.openMountType
                                            end

                                            if spec.dynamicMountAttacherGrab.currentMountType ~ = usedMountType then
                                                spec.dynamicMountAttacherGrab.currentMountType = usedMountType

                                                local x, y, z = getWorldTranslation(spec.dynamicMountAttacherNode)
                                                setJointPosition(object.dynamicMountJointIndex, 1 , x,y,z)
                                                if usedMountType = = DynamicMountUtil.TYPE_FORK then

                                                    setJointRotationLimit(object.dynamicMountJointIndex, 0 , true , 0 , 0 )
                                                    setJointRotationLimit(object.dynamicMountJointIndex, 1 , true , 0 , 0 )
                                                    setJointRotationLimit(object.dynamicMountJointIndex, 2 , true , 0 , 0 )

                                                    if object.dynamicMountSingleAxisFreeX then
                                                        setJointTranslationLimit(object.dynamicMountJointIndex, 0 , false , 0 , 0 )
                                                    else
                                                            setJointTranslationLimit(object.dynamicMountJointIndex, 0 , true , - 0.01 , 0.01 )
                                                        end
                                                        if object.dynamicMountSingleAxisFreeY then
                                                            setJointTranslationLimit(object.dynamicMountJointIndex, 1 , false , 0 , 0 )
                                                        else
                                                                setJointTranslationLimit(object.dynamicMountJointIndex, 1 , true , - 0.01 , 0.01 )
                                                            end
                                                            setJointTranslationLimit(object.dynamicMountJointIndex, 2 , false , 0 , 0 )
                                                        else
                                                                setJointRotationLimit(object.dynamicMountJointIndex, 0 , true , 0 , 0 )
                                                                setJointRotationLimit(object.dynamicMountJointIndex, 1 , true , 0 , 0 )
                                                                setJointRotationLimit(object.dynamicMountJointIndex, 2 , true , 0 , 0 )

                                                                if usedMountType = = DynamicMountUtil.TYPE_AUTO_ATTACH_XYZ or usedMountType = = DynamicMountUtil.TYPE_FIX_ATTACH then
                                                                    setJointTranslationLimit(object.dynamicMountJointIndex, 0 , true , - 0.01 , 0.01 )
                                                                    setJointTranslationLimit(object.dynamicMountJointIndex, 1 , true , - 0.01 , 0.01 )
                                                                    setJointTranslationLimit(object.dynamicMountJointIndex, 2 , true , - 0.01 , 0.01 )
                                                                elseif usedMountType = = DynamicMountUtil.TYPE_AUTO_ATTACH_XZ then
                                                                        setJointTranslationLimit(object.dynamicMountJointIndex, 0 , true , - 0.01 , 0.01 )
                                                                        setJointTranslationLimit(object.dynamicMountJointIndex, 1 , false , 0 , 0 )
                                                                        setJointTranslationLimit(object.dynamicMountJointIndex, 2 , true , - 0.01 , 0.01 )
                                                                    elseif usedMountType = = DynamicMountUtil.TYPE_AUTO_ATTACH_Y then
                                                                            setJointTranslationLimit(object.dynamicMountJointIndex, 0 , false , 0 , 0 )
                                                                            setJointTranslationLimit(object.dynamicMountJointIndex, 1 , true , - 0.01 , 0.01 )
                                                                            setJointTranslationLimit(object.dynamicMountJointIndex, 2 , false , 0 , 0 )
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

**Definition**

> onWriteUpdateStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |
| any | dirtyMask  |

**Code**

```lua
function DynamicMountAttacher:onWriteUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        local spec = self.spec_dynamicMountAttacher

        if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dynamicMountedObjectsDirtyFlag) ~ = 0 ) then
            self:writeDynamicMountObjectsToStream(streamId, spec.dynamicMountedObjects)
            self:writeDynamicMountObjectsToStream(streamId, spec.pendingDynamicMountObjects)
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
function DynamicMountAttacher.prerequisitesPresent(specializations)
    return true
end

```

### readDynamicMountObjectsFromStream

**Description**

**Definition**

> readDynamicMountObjectsFromStream()

**Arguments**

| any | streamId |
|-----|----------|
| any | objects  |

**Code**

```lua
function DynamicMountAttacher:readDynamicMountObjectsFromStream(streamId, objects)
    local spec = self.spec_dynamicMountAttacher
    local sum = streamReadUIntN(streamId, spec.numObjectBits)

    for k, _ in pairs(objects) do
        objects[k] = nil
    end

    for _ = 1 , sum do
        local object = NetworkUtil.readNodeObject(streamId)
        if object ~ = nil then
            objects[object] = object
        end
    end

    return sum
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
function DynamicMountAttacher.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , DynamicMountAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , DynamicMountAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream" , DynamicMountAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream" , DynamicMountAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , DynamicMountAttacher )
    SpecializationUtil.registerEventListener(vehicleType, "onPreAttachImplement" , DynamicMountAttacher )
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
function DynamicMountAttacher.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "loadDynamicLockPositionFromXML" , DynamicMountAttacher.loadDynamicLockPositionFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsDynamicLockPositionActive" , DynamicMountAttacher.getIsDynamicLockPositionActive)
    SpecializationUtil.registerFunction(vehicleType, "writeDynamicMountObjectsToStream" , DynamicMountAttacher.writeDynamicMountObjectsToStream)
    SpecializationUtil.registerFunction(vehicleType, "readDynamicMountObjectsFromStream" , DynamicMountAttacher.readDynamicMountObjectsFromStream)
    SpecializationUtil.registerFunction(vehicleType, "getAllowDynamicMountObjects" , DynamicMountAttacher.getAllowDynamicMountObjects)
    SpecializationUtil.registerFunction(vehicleType, "dynamicMountTriggerCallback" , DynamicMountAttacher.dynamicMountTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "lockDynamicMountedObject" , DynamicMountAttacher.lockDynamicMountedObject)
    SpecializationUtil.registerFunction(vehicleType, "addDynamicMountedObject" , DynamicMountAttacher.addDynamicMountedObject)
    SpecializationUtil.registerFunction(vehicleType, "removeDynamicMountedObject" , DynamicMountAttacher.removeDynamicMountedObject)
    SpecializationUtil.registerFunction(vehicleType, "onUnmountObject" , DynamicMountAttacher.onUnmountObject)
    SpecializationUtil.registerFunction(vehicleType, "setDynamicMountAnimationState" , DynamicMountAttacher.setDynamicMountAnimationState)
    SpecializationUtil.registerFunction(vehicleType, "getAllowDynamicMountFillLevelInfo" , DynamicMountAttacher.getAllowDynamicMountFillLevelInfo)
    SpecializationUtil.registerFunction(vehicleType, "loadDynamicMountGrabFromXML" , DynamicMountAttacher.loadDynamicMountGrabFromXML)
    SpecializationUtil.registerFunction(vehicleType, "getIsDynamicMountGrabOpened" , DynamicMountAttacher.getIsDynamicMountGrabOpened)
    SpecializationUtil.registerFunction(vehicleType, "getDynamicMountTimeToMount" , DynamicMountAttacher.getDynamicMountTimeToMount)
    SpecializationUtil.registerFunction(vehicleType, "getHasDynamicMountedObjects" , DynamicMountAttacher.getHasDynamicMountedObjects)
    SpecializationUtil.registerFunction(vehicleType, "forceDynamicMountPendingObjects" , DynamicMountAttacher.forceDynamicMountPendingObjects)
    SpecializationUtil.registerFunction(vehicleType, "forceUnmountDynamicMountedObjects" , DynamicMountAttacher.forceUnmountDynamicMountedObjects)
    SpecializationUtil.registerFunction(vehicleType, "getDynamicMountAttacherSettingsByNode" , DynamicMountAttacher.getDynamicMountAttacherSettingsByNode)
    SpecializationUtil.registerFunction(vehicleType, "dynamicMountLockPositionOverlapCallback" , DynamicMountAttacher.dynamicMountLockPositionOverlapCallback)
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
function DynamicMountAttacher.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillLevelInformation" , DynamicMountAttacher.getFillLevelInformation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadExtraDependentParts" , DynamicMountAttacher.loadExtraDependentParts)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateExtraDependentParts" , DynamicMountAttacher.updateExtraDependentParts)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsAttachedTo" , DynamicMountAttacher.getIsAttachedTo)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAdditionalComponentMass" , DynamicMountAttacher.getAdditionalComponentMass)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , DynamicMountAttacher.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingToolFromXML" , DynamicMountAttacher.loadMovingToolFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingToolActive" , DynamicMountAttacher.getIsMovingToolActive)
end

```

### removeDynamicMountedObject

**Description**

**Definition**

> removeDynamicMountedObject()

**Arguments**

| any | object     |
|-----|------------|
| any | isDeleting |

**Code**

```lua
function DynamicMountAttacher:removeDynamicMountedObject(object, isDeleting)
    local spec = self.spec_dynamicMountAttacher

    spec.dynamicMountedObjects[object] = nil
    if isDeleting then
        spec.pendingDynamicMountObjects[object] = nil
    end

    for i = 1 , #spec.lockPositions do
        local position = spec.lockPositions[i]
        if position.state and position.object = = object then
            ObjectChangeUtil.setObjectChanges(spec.lockPositions[i].objectChanges, false , self , self.setMovingToolDirty)

            position.state = false
            position.object = nil
        end
    end

    if spec.transferMass then
        self:setMassDirty()
    end

    if not spec.collisionBetweenObjects then
        for otherObject,_ in pairs(spec.dynamicMountedObjects) do
            if otherObject ~ = object then
                local node1 = object.nodeId or object.rootNode
                local node2 = otherObject.nodeId or otherObject.rootNode
                if node1 ~ = nil and node2 ~ = nil then
                    setPairCollision(node1, node2, true )
                end
            end
        end
    end

    self:setDynamicMountAnimationState( false )

    self:raiseDirtyFlags(spec.dynamicMountedObjectsDirtyFlag)
end

```

### setDynamicMountAnimationState

**Description**

**Definition**

> setDynamicMountAnimationState()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function DynamicMountAttacher:setDynamicMountAnimationState(state)
    local spec = self.spec_dynamicMountAttacher

    if state then
        self:playAnimation(spec.animationName, spec.animationSpeed, self:getAnimationTime(spec.animationName), true )
    else
            self:playAnimation(spec.animationName, - spec.animationSpeed, self:getAnimationTime(spec.animationName), true )
        end
    end

```

### updateDebugValues

**Description**

**Definition**

> updateDebugValues()

**Arguments**

| any | values |
|-----|--------|

**Code**

```lua
function DynamicMountAttacher:updateDebugValues(values)
    local spec = self.spec_dynamicMountAttacher

    if self.isServer then
        local timeToMount = self.lastMoveTime + spec.dynamicMountAttacherTimeToMount - g_currentMission.time
        table.insert(values, { name = "timeToMount:" , value = string.format( "%d" , timeToMount) } )

        for object, _ in pairs(spec.pendingDynamicMountObjects) do
            table.insert(values, { name = "pendingDynamicMountObject:" , value = string.format( "%s timeToMount: %d" , object.configFileNameClean or object, math.max(object.lastMoveTime + spec.dynamicMountAttacherTimeToMount - g_currentMission.time , 0 )) } )
        end

        for object, _ in pairs(spec.dynamicMountedObjects) do
            local objectName = object.configFileNameClean or(object.xmlFilename and Utils.getFilenameFromPath(object.xmlFilename)) or object
            local objectColor = DebugUtil.tableToColor(object)
            table.insert(values, {
            name = "dynamicMountedObjects:" ,
            value = string.format( "%s jointIndex:%s mountOffset:%.3f triggerCount:%s" , objectName, object.dynamicMountJointIndex, object.dynamicMountJointNodeDynamicMountOffset or - 1 , object.dynamicMountObjectTriggerCount),
            color = objectColor
            } )
            local objectNode = object.nodeId or object.rootNode
            if objectNode ~ = nil then
                local x,y,z = getWorldTranslation(objectNode)
                drawDebugPoint(x,y,z, objectColor[ 1 ], objectColor[ 2 ], objectColor[ 3 ], objectColor[ 4 ], false )
            end
        end
    end

    table.insert(values, { name = "allowMountObjects:" , value = string.format( "%s" , self:getAllowDynamicMountObjects()) } )

    if spec.dynamicMountAttacherGrab ~ = nil then
        table.insert(values, { name = "grabOpened:" , value = string.format( "%s" , self:getIsDynamicMountGrabOpened(spec.dynamicMountAttacherGrab)) } )
    end
end

```

### updateExtraDependentParts

**Description**

**Definition**

> updateExtraDependentParts()

**Arguments**

| any | superFunc |
|-----|-----------|
| any | part      |
| any | dt        |

**Code**

```lua
function DynamicMountAttacher:updateExtraDependentParts(superFunc, part, dt)
    superFunc( self , part, dt)

    if self.isServer then
        if part.updateDynamicMountAttacher ~ = nil and part.updateDynamicMountAttacher then
            local spec = self.spec_dynamicMountAttacher
            for object,_ in pairs(spec.dynamicMountedObjects) do
                setJointFrame(object.dynamicMountJointIndex, 0 , object.dynamicMountJointNode)
            end
        end
    end
end

```

### writeDynamicMountObjectsToStream

**Description**

**Definition**

> writeDynamicMountObjectsToStream()

**Arguments**

| any | streamId |
|-----|----------|
| any | objects  |

**Code**

```lua
function DynamicMountAttacher:writeDynamicMountObjectsToStream(streamId, objects)
    local spec = self.spec_dynamicMountAttacher
    local num = math.min( table.size(objects), spec.maxNumObjectsToSend)
    streamWriteUIntN(streamId, num, spec.numObjectBits)

    local objectIndex = 0
    for object,_ in pairs(objects) do
        objectIndex = objectIndex + 1
        if objectIndex < = num then
            NetworkUtil.writeNodeObject(streamId, object)
        else
                Logging.xmlWarning( self.xmlFile, "Not enough bits to send all mounted objects.Please increase '%s'" , "vehicle.dynamicMountAttacher#numObjectBits" )
            end
        end
    end

```