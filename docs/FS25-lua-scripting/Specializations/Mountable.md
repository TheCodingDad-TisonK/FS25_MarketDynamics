## Mountable

**Description**

> Specialization for vehicles/tools to be dynamically mounted (e.g. cutters)

**Functions**

- [additionalMountingMassRaycastCallback](#additionalmountingmassraycastcallback)
- [addMountStateChangeListener](#addmountstatechangelistener)
- [findRootVehicle](#findrootvehicle)
- [getAdditionalComponentMass](#getadditionalcomponentmass)
- [getAdditionalMountingDistance](#getadditionalmountingdistance)
- [getAdditionalMountingMass](#getadditionalmountingmass)
- [getAllowComponentMassReduction](#getallowcomponentmassreduction)
- [getDefaultAllowComponentMassReduction](#getdefaultallowcomponentmassreduction)
- [getDynamicMountObject](#getdynamicmountobject)
- [getIsActive](#getisactive)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsMapHotspotVisible](#getismaphotspotvisible)
- [getMountableLockPositions](#getmountablelockpositions)
- [getMountObject](#getmountobject)
- [getOwnerConnection](#getownerconnection)
- [getSupportsMountDynamic](#getsupportsmountdynamic)
- [getSupportsMountKinematic](#getsupportsmountkinematic)
- [initSpecialization](#initspecialization)
- [mount](#mount)
- [mountableTriggerCallback](#mountabletriggercallback)
- [mountDynamic](#mountdynamic)
- [mountKinematic](#mountkinematic)
- [onDelete](#ondelete)
- [onDynamicMountJointBreak](#ondynamicmountjointbreak)
- [onLoad](#onload)
- [onPreAttach](#onpreattach)
- [onReadStream](#onreadstream)
- [onUpdate](#onupdate)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerEvents](#registerevents)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeMountStateChangeListener](#removemountstatechangelistener)
- [setDynamicMountType](#setdynamicmounttype)
- [setReducedComponentMass](#setreducedcomponentmass)
- [setWorldPositionQuaternion](#setworldpositionquaternion)
- [unmount](#unmount)
- [unmountDynamic](#unmountdynamic)
- [unmountKinematic](#unmountkinematic)
- [updateDynamicMountJointForceLimit](#updatedynamicmountjointforcelimit)

### additionalMountingMassRaycastCallback

**Description**

> Callback used when raycast hits an object.

**Definition**

> additionalMountingMassRaycastCallback(integer hitObjectId, float x, float y, float z, float distance, float nx, float
> ny, float nz, integer subShapeIndex, integer shapeId, boolean isLast)

**Arguments**

| integer | hitObjectId   | scenegraph object id                      |
|---------|---------------|-------------------------------------------|
| float   | x             | world x hit position                      |
| float   | y             | world y hit position                      |
| float   | z             | world z hit position                      |
| float   | distance      | distance at which the cast hit the object |
| float   | nx            | normal x direction                        |
| float   | ny            | normal y direction                        |
| float   | nz            | normal z direction                        |
| integer | subShapeIndex | sub shape index                           |
| integer | shapeId       | id of shape                               |
| boolean | isLast        | is last hit                               |

**Return Values**

| boolean | return | false to stop raycast |
|---------|--------|-----------------------|

**Code**

```lua
function Mountable:additionalMountingMassRaycastCallback(hitObjectId, x, y, z, distance, nx, ny, nz, subShapeIndex, shapeId, isLast)
    if g_currentMission = = nil or self.isDeleted or self.isDeleting then
        return
    end

    local spec = self.spec_mountable
    spec.forceLimitUpdate.raycastActive = false

    local vehicle = g_currentMission.nodeToObject[hitObjectId]
    if vehicle ~ = self and vehicle ~ = nil and vehicle:isa( Vehicle ) and self.getAdditionalMountingDistance ~ = nil then
        if vehicle ~ = spec.forceLimitUpdate.lastObject then
            local offset = distance - spec.forceLimitUpdate.lastDistance
            if math.abs(offset - spec.forceLimitUpdate.nextMountingDistance) < 0.25 then
                spec.forceLimitUpdate.lastDistance = distance
                spec.forceLimitUpdate.nextMountingDistance = self:getAdditionalMountingDistance()
                spec.forceLimitUpdate.additionalMass = spec.forceLimitUpdate.additionalMass + vehicle:getTotalMass()
                spec.forceLimitUpdate.lastObject = vehicle
            end
        end
    end

    if isLast then
        if self.dynamicMountJointIndex ~ = nil then
            local massFactor = (spec.forceLimitUpdate.additionalMass + spec.mountBaseMass) / spec.mountBaseMass
            local forceAcceleration = spec.mountBaseForceAcceleration * massFactor
            local forceLimit = spec.mountBaseMass * forceAcceleration
            setJointLinearDrive( self.dynamicMountJointIndex, 2 , false , true , 0 , 0 , forceLimit, 0 , 0 )
        end
    end

    return true
end

```

### addMountStateChangeListener

**Description**

**Definition**

> addMountStateChangeListener()

**Arguments**

| any | object       |
|-----|--------------|
| any | callbackFunc |

**Code**

```lua
function Mountable:addMountStateChangeListener(object, callbackFunc)
    local spec = self.spec_mountable
    if callbackFunc = = nil then
        callbackFunc = "onObjectMountStateChanged"
    end

    for _, listener in ipairs(spec.mountStateChangeListeners) do
        if listener.object = = object and listener.callbackFunc = = callbackFunc then
            return
        end
    end

    table.insert(spec.mountStateChangeListeners, { object = object, callbackFunc = callbackFunc } )
end

```

### findRootVehicle

**Description**

**Definition**

> findRootVehicle()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Mountable:findRootVehicle(superFunc)
    local spec = self.spec_mountable

    local rootAttacherVehicle = superFunc( self )
    if rootAttacherVehicle = = nil or rootAttacherVehicle = = self then
        local dynamicMountObject = self:getMountObject()
        if dynamicMountObject ~ = nil and dynamicMountObject.findRootVehicle ~ = nil then
            rootAttacherVehicle = dynamicMountObject:findRootVehicle()
        end
    end
    if rootAttacherVehicle = = nil then
        rootAttacherVehicle = self
    end
    return rootAttacherVehicle
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
function Mountable:getAdditionalComponentMass(superFunc, component)
    local additionalMass = superFunc( self , component)
    local spec = self.spec_mountable

    if spec.reducedComponentMass then
        additionalMass = - component.defaultMass + 0.1
    end

    return additionalMass
end

```

### getAdditionalMountingDistance

**Description**

**Definition**

> getAdditionalMountingDistance()

**Code**

```lua
function Mountable:getAdditionalMountingDistance()
    return self.spec_mountable.additionalMountDistance
end

```

### getAdditionalMountingMass

**Description**

> Empty function to no break compatibility

**Definition**

> getAdditionalMountingMass()

**Code**

```lua
function Mountable:getAdditionalMountingMass()
    return 0
end

```

### getAllowComponentMassReduction

**Description**

**Definition**

> getAllowComponentMassReduction()

**Code**

```lua
function Mountable:getAllowComponentMassReduction()
    return self.spec_mountable.allowMassReduction
end

```

### getDefaultAllowComponentMassReduction

**Description**

**Definition**

> getDefaultAllowComponentMassReduction()

**Code**

```lua
function Mountable:getDefaultAllowComponentMassReduction()
    return false
end

```

### getDynamicMountObject

**Description**

**Definition**

> getDynamicMountObject()

**Code**

```lua
function Mountable:getDynamicMountObject()
    if self.dynamicMountObjectId ~ = nil then
        return NetworkUtil.getObject( self.dynamicMountObjectId)
    end

    return nil
end

```

### getIsActive

**Description**

**Definition**

> getIsActive()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Mountable:getIsActive(superFunc)
    local isActive = false

    local dynamicMountObject = self:getDynamicMountObject()
    if dynamicMountObject ~ = nil and dynamicMountObject.getIsActive ~ = nil then
        isActive = dynamicMountObject:getIsActive()
    end

    return superFunc( self ) or isActive
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
function Mountable:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    if self.dynamicMountType ~ = MountableObject.MOUNT_TYPE_NONE and not self.spec_mountable.dynamicMountAllowFoldingWhileMounted then
        return false , g_i18n:getText( "warning_foldingNotWhileAttached" )
    end

    return superFunc( self , direction, onAiTurnOn)
end

```

### getIsMapHotspotVisible

**Description**

**Definition**

> getIsMapHotspotVisible()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Mountable:getIsMapHotspotVisible(superFunc)
    if not superFunc( self ) then
        return false
    end

    if self:getDynamicMountObject() ~ = nil then
        return false
    end

    return true
end

```

### getMountableLockPositions

**Description**

**Definition**

> getMountableLockPositions()

**Code**

```lua
function Mountable:getMountableLockPositions()
    return self.spec_mountable.lockPositions
end

```

### getMountObject

**Description**

**Definition**

> getMountObject()

**Code**

```lua
function Mountable:getMountObject()
    if self.dynamicMountType ~ = MountableObject.MOUNT_TYPE_DYNAMIC then
        return self:getDynamicMountObject()
    end

    return nil
end

```

### getOwnerConnection

**Description**

**Definition**

> getOwnerConnection()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function Mountable:getOwnerConnection(superFunc)
    local spec = self.spec_mountable

    local dynamicMountObject = self:getMountObject()
    if dynamicMountObject ~ = nil and dynamicMountObject.getOwnerConnection ~ = nil then
        return dynamicMountObject:getOwnerConnection()
    end

    return superFunc( self )
end

```

### getSupportsMountDynamic

**Description**

**Definition**

> getSupportsMountDynamic()

**Code**

```lua
function Mountable:getSupportsMountDynamic()
    local spec = self.spec_mountable
    return spec.dynamicMountForceLimitScale ~ = nil
end

```

### getSupportsMountKinematic

**Description**

**Definition**

> getSupportsMountKinematic()

**Code**

```lua
function Mountable:getSupportsMountKinematic()
    return # self.components = = 1
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function Mountable.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "Mountable" )

    schema:register(XMLValueType.FLOAT, "vehicle.dynamicMount#forceLimitScale" , "Force limit scale" , 1 )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMount#triggerNode" , "Trigger node" )
    schema:register(XMLValueType.NODE_INDEX, "vehicle.dynamicMount#jointNode" , "Joint node" )
    schema:register(XMLValueType.FLOAT, "vehicle.dynamicMount#triggerForceAcceleration" , "Trigger force acceleration" , 4 )
    schema:register(XMLValueType.BOOL, "vehicle.dynamicMount#singleAxisFreeY" , "Single axis free Y" )
    schema:register(XMLValueType.BOOL, "vehicle.dynamicMount#singleAxisFreeX" , "Single axis free X" )

    schema:register(XMLValueType.BOOL, "vehicle.dynamicMount#allowFoldingWhileMounted" , "Allow folding while vehicle is mounted" , false )

        schema:register(XMLValueType.FLOAT, "vehicle.dynamicMount#jointTransY" , "Fixed Y translation of local placed joint" , "not defined" )
        schema:register(XMLValueType.BOOL, "vehicle.dynamicMount#jointLimitToRotY" , "Local placed joint will only be adjusted on Y axis to the target mounter object.X and Z will be 0." , false )

        schema:register(XMLValueType.FLOAT, "vehicle.dynamicMount#additionalMountDistance" , "Distance from root node to the object laying on top(normally height of object).If defined the mass of this object has influence in mounting." , 0 )

        schema:register(XMLValueType.BOOL, "vehicle.dynamicMount#allowMassReduction" , "Defines if mass can be reduced by the mount vehicle" , true )

            schema:register(XMLValueType.STRING, "vehicle.dynamicMount.lockPosition(?)#xmlFilename" , "XML filename of vehicle to lock on(needs to match only the end of the filename)" )
            schema:register(XMLValueType.STRING, "vehicle.dynamicMount.lockPosition(?)#jointNode" , "Joint node of other vehicle(path or i3dMapping name)" , "vehicle root node" )
            schema:register(XMLValueType.VECTOR_TRANS, "vehicle.dynamicMount.lockPosition(?)#transOffset" , "Translation offset from joint node" , "0 0 0" )
            schema:register(XMLValueType.VECTOR_ROT, "vehicle.dynamicMount.lockPosition(?)#rotOffset" , "Rotation offset from joint node" , "0 0 0" )

            schema:setXMLSpecializationType()
        end

```

### mount

**Description**

**Definition**

> mount()

**Arguments**

| any | object |
|-----|--------|
| any | node   |
| any | x      |
| any | y      |
| any | z      |
| any | rx     |
| any | ry     |
| any | rz     |

**Code**

```lua
function Mountable:mount(object, node, x,y,z, rx,ry,rz)
    local spec = self.spec_mountable

    -- set isDelete = true to remove Mountable from pendingDynamicMountObjects(no delete leave callback)
    self:unmountDynamic( true )

    if self.dynamicMountType = = MountableObject.MOUNT_TYPE_NONE then
        removeFromPhysics(spec.componentNode)
    end

    link(node, spec.componentNode)

    local wx,wy,wz = localToWorld(node, x,y,z)
    local wqx,wqy,wqz,wqw = mathEulerToQuaternion( localRotationToWorld(node, rx,ry,rz) )
    self:setWorldPositionQuaternion(wx,wy,wz, wqx,wqy,wqz,wqw, 1 , true )

    self:setDynamicMountType( MountableObject.MOUNT_TYPE_DEFAULT, object)
end

```

### mountableTriggerCallback

**Description**

**Definition**

> mountableTriggerCallback()

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
function Mountable:mountableTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_mountable

    if onEnter then
        local vehicle = g_currentMission.nodeToObject[otherActorId]

        if vehicle ~ = nil and vehicle.spec_dynamicMountAttacher ~ = nil then
            local dynamicMountAttacher = vehicle.spec_dynamicMountAttacher

            if dynamicMountAttacher ~ = nil and dynamicMountAttacher.dynamicMountAttacherNode ~ = nil then
                if self.dynamicMountObjectActorId = = nil then
                    self:mountDynamic(vehicle, otherActorId, dynamicMountAttacher.dynamicMountAttacherNode, DynamicMountUtil.TYPE_FORK, spec.dynamicMountTriggerForceAcceleration * dynamicMountAttacher.dynamicMountAttacherForceLimitScale)
                    spec.dynamicMountObjectTriggerCount = 1
                elseif otherActorId ~ = self.dynamicMountObjectActorId and spec.dynamicMountObjectTriggerCount = = nil then
                        -- we are already attached to another actor, but not from our mount trigger(e.g.a bale trailer)
                        self:unmountDynamic()
                        self:mountDynamic(vehicle, otherActorId, dynamicMountAttacher.dynamicMountAttacherNode, DynamicMountUtil.TYPE_FORK, spec.dynamicMountTriggerForceAcceleration * dynamicMountAttacher.dynamicMountAttacherForceLimitScale)
                        spec.dynamicMountObjectTriggerCount = 1
                    elseif otherActorId = = self.dynamicMountObjectActorId then
                            if spec.dynamicMountObjectTriggerCount ~ = nil then
                                spec.dynamicMountObjectTriggerCount = spec.dynamicMountObjectTriggerCount + 1
                            end
                        end
                    end
                end
            elseif onLeave then
                    if otherActorId = = self.dynamicMountObjectActorId and spec.dynamicMountObjectTriggerCount ~ = nil then
                        spec.dynamicMountObjectTriggerCount = spec.dynamicMountObjectTriggerCount - 1
                        if spec.dynamicMountJointNodeDynamic = = nil then
                            if spec.dynamicMountObjectTriggerCount = = 0 then
                                self:unmountDynamic()
                                spec.dynamicMountObjectTriggerCount = nil
                            end
                        end
                    end
                end
            end

```

### mountDynamic

**Description**

**Definition**

> mountDynamic()

**Arguments**

| any | object            |
|-----|-------------------|
| any | objectActorId     |
| any | jointNode         |
| any | mountType         |
| any | forceAcceleration |

**Code**

```lua
function Mountable:mountDynamic(object, objectActorId, jointNode, mountType, forceAcceleration)
    local spec = self.spec_mountable

    if not self:getSupportsMountDynamic() or self:getDynamicMountObject() ~ = nil or self.dynamicMountType ~ = MountableObject.MOUNT_TYPE_NONE then
        return false
    end

    -- do not allow to mount myself to an object that has the same root vehicle as an object that i got already mounted
        local dynamicMountSpec = self.spec_dynamicMountAttacher
        if dynamicMountSpec ~ = nil then
            for _, mountedObject in pairs(dynamicMountSpec.dynamicMountedObjects) do
                if mountedObject:isa( Vehicle ) then
                    if mountedObject.rootVehicle = = object.rootVehicle then
                        return false
                    end
                end
            end
        end

        -- do not allow mounting of vehicles that already have a connection to the vehicle 'chain'
            -- otherwise we could get endless loops
            if object.rootVehicle = = self.rootVehicle then
                return false
            end

            jointNode = spec.jointNode or jointNode

            if spec.dynamicMountTriggerId ~ = nil then
                -- while we use mount type fork we put our local joint to our center of mass
                    -- like this we have one joint in the center of the fork and one in the center of the loaded object
                    -- this results in a optimal physics behaviour with joints close to the center of mass
                    local x, y, z
                    if mountType = = DynamicMountUtil.TYPE_FORK then
                        local _, _, zOffset = worldToLocal(jointNode, localToWorld(spec.componentNode, getCenterOfMass(spec.componentNode)))
                        x, y, z = localToLocal(jointNode, getParent(spec.dynamicMountJointNodeDynamic), 0 , 0 , zOffset)
                    else
                            x, y, z = localToLocal(jointNode, getParent(spec.dynamicMountJointNodeDynamic), 0 , 0 , 0 )
                        end

                        y = spec.dynamicMountJointTransY or y
                        setTranslation(spec.dynamicMountJointNodeDynamic, x, y, z)

                        if spec.dynamicMountJointLimitToRotY then
                            local dx, dy, dz = localDirectionToLocal(jointNode, getParent(spec.dynamicMountJointNodeDynamic), 0 , 0 , 1 )
                            -- we block the mounting completely if the angle to the object is too high
                                -- this would lead in most of the cases to the object flying away
                                -- e.g.when a pallet is laying on the side and the player touches the bottom of the pallet with the fork
                                if math.abs(dy) > 0.2 then
                                    return false
                                end

                                dx, dz = MathUtil.vector2Normalize(dx, dz)
                                local rx, ry, rz = 0 , MathUtil.getYRotationFromDirection(dx, dz), 0
                                setRotation(spec.dynamicMountJointNodeDynamic, rx, ry, rz)

                                local _, upY, _ = localDirectionToLocal(jointNode, getParent(spec.dynamicMountJointNodeDynamic), 0 , 1 , 0 )
                                if upY < 0 then
                                    rotateAboutLocalAxis(spec.dynamicMountJointNodeDynamic, math.pi, 0 , 0 , 1 )
                                end
                            else
                                    local rx, ry, rz = localRotationToLocal(jointNode, getParent(spec.dynamicMountJointNodeDynamic), 0 , 0 , 0 )
                                    setRotation(spec.dynamicMountJointNodeDynamic, rx, ry, rz)
                                end

                                local _
                                _, _, spec.dynamicMountJointNodeDynamicMountOffset = localToLocal(spec.dynamicMountJointNodeDynamic, jointNode, 0 , 0 , 0 )
                                spec.dynamicMountJointNodeDynamicRefNode = jointNode
                            end

                            spec.mountBaseForceAcceleration = forceAcceleration
                            spec.mountBaseMass = self:getTotalMass()
                            spec.forceLimitUpdate.isAllowed = mountType = = DynamicMountUtil.TYPE_FORK

                            if DynamicMountUtil.mountDynamic( self , spec.componentNode, object, objectActorId, jointNode, mountType, forceAcceleration * spec.dynamicMountForceLimitScale, spec.dynamicMountJointNodeDynamic) then
                                self:setDynamicMountType( MountableObject.MOUNT_TYPE_DYNAMIC, object)
                                return true
                            end

                            return false
                        end

```

### mountKinematic

**Description**

**Definition**

> mountKinematic()

**Arguments**

| any | object |
|-----|--------|
| any | node   |
| any | x      |
| any | y      |
| any | z      |
| any | rx     |
| any | ry     |
| any | rz     |

**Code**

```lua
function Mountable:mountKinematic(object, node, x,y,z, rx,ry,rz)
    local spec = self.spec_mountable

    -- set isDelete = true to remove Mountable from pendingDynamicMountObjects(no delete leave callback)
    self:unmountDynamic( true )

    removeFromPhysics(spec.componentNode)

    -- on clients we are kinematic all the time
    if self.isServer then
        setRigidBodyType(spec.componentNode, RigidBodyType.KINEMATIC)

        self.components[ 1 ].isKinematic = true
        self.components[ 1 ].isDynamic = false
    end

    link(node, spec.componentNode)

    local wx, wy, wz = localToWorld(node, x,y,z)
    local wqx, wqy, wqz, wqw = mathEulerToQuaternion(localRotationToWorld(node, rx, ry, rz))
    self:setWorldPositionQuaternion(wx, wy, wz, wqx, wqy, wqz, wqw, 1 , true )

    addToPhysics(spec.componentNode)

    if object.getParentComponent ~ = nil then
        local componentNode = object:getParentComponent(node)
        if getRigidBodyType(componentNode) = = RigidBodyType.DYNAMIC then
            setPairCollision(componentNode, spec.componentNode, false )
        end
    end

    spec.mountJointNode = node
    self:setDynamicMountType( MountableObject.MOUNT_TYPE_KINEMATIC, object)
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function Mountable:onDelete()
    local spec = self.spec_mountable

    local mountObject = self:getDynamicMountObject()
    if mountObject ~ = nil and mountObject.onUnmountObject ~ = nil then
        mountObject:onUnmountObject( self )
    end

    if spec.dynamicMountJointIndex ~ = nil then
        removeJointBreakReport(spec.dynamicMountJointIndex)
        removeJoint(spec.dynamicMountJointIndex)
    end
    if spec.dynamicMountObject ~ = nil then
        spec.dynamicMountObject:removeDynamicMountedObject( self , true )
    end
    if spec.dynamicMountTriggerId ~ = nil then
        removeTrigger(spec.dynamicMountTriggerId)
    end
end

```

### onDynamicMountJointBreak

**Description**

**Definition**

> onDynamicMountJointBreak()

**Arguments**

| any | jointIndex      |
|-----|-----------------|
| any | breakingImpulse |

**Code**

```lua
function Mountable:onDynamicMountJointBreak(jointIndex, breakingImpulse)
    local spec = self.spec_mountable

    if jointIndex = = spec.dynamicMountJointIndex then
        self:unmountDynamic()
    end
    -- Do not delete the joint internally, we already deleted it with unmountDynamic
    return false
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
function Mountable:onLoad(savegame)
    local spec = self.spec_mountable

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.dynamicMount#triggerIndex" , "vehicle.dynamicMount#triggerNode" ) --FS17 to FS19

    spec.dynamicMountJointIndex = nil
    spec.dynamicMountObject = nil
    self.dynamicMountObjectActorId = nil -- vehicle variable since it is used in DynamicMountUtil
    spec.dynamicMountForceLimitScale = self.xmlFile:getValue( "vehicle.dynamicMount#forceLimitScale" , 1 )

    spec.componentNode = self.rootNode
    spec.dynamicMountTriggerId = self.xmlFile:getValue( "vehicle.dynamicMount#triggerNode" , nil , self.components, self.i3dMappings)
    if spec.dynamicMountTriggerId ~ = nil then
        if self.isServer then
            addTrigger(spec.dynamicMountTriggerId, "mountableTriggerCallback" , self )
        end

        spec.componentNode = self:getParentComponent(spec.dynamicMountTriggerId)

        if spec.dynamicMountJointNodeDynamic = = nil then
            spec.dynamicMountJointNodeDynamic = createTransformGroup( "dynamicMountJointNodeDynamic" )
            link(spec.componentNode, spec.dynamicMountJointNodeDynamic)
        end

        spec.dynamicMountJointTransY = self.xmlFile:getValue( "vehicle.dynamicMount#jointTransY" )
        spec.dynamicMountJointLimitToRotY = self.xmlFile:getValue( "vehicle.dynamicMount#jointLimitToRotY" , false )
    end

    spec.jointNode = self.xmlFile:getValue( "vehicle.dynamicMount#jointNode" , nil , self.components, self.i3dMappings)

    spec.dynamicMountTriggerForceAcceleration = self.xmlFile:getValue( "vehicle.dynamicMount#triggerForceAcceleration" , 4 )
    spec.dynamicMountSingleAxisFreeY = self.xmlFile:getValue( "vehicle.dynamicMount#singleAxisFreeY" )
    spec.dynamicMountSingleAxisFreeX = self.xmlFile:getValue( "vehicle.dynamicMount#singleAxisFreeX" )

    spec.dynamicMountAllowFoldingWhileMounted = self.xmlFile:getValue( "vehicle.dynamicMount#allowFoldingWhileMounted" , false )

    spec.additionalMountDistance = self.xmlFile:getValue( "vehicle.dynamicMount#additionalMountDistance" , 0 )

    spec.forceLimitUpdate = { }
    spec.forceLimitUpdate.raycastActive = false
    spec.forceLimitUpdate.timer = 0
    spec.forceLimitUpdate.lastDistance = 0
    spec.forceLimitUpdate.nextMountingDistance = 0
    spec.forceLimitUpdate.additionalMass = 0
    spec.forceLimitUpdate.isAllowed = false

    spec.allowMassReduction = self.xmlFile:getValue( "vehicle.dynamicMount#allowMassReduction" , self:getDefaultAllowComponentMassReduction())
    spec.reducedComponentMass = false

    spec.lockPositions = { }
    self.xmlFile:iterate( "vehicle.dynamicMount.lockPosition" , function (index, key)
        local entry = { }

        entry.xmlFilename = self.xmlFile:getValue(key .. "#xmlFilename" )
        entry.jointNode = self.xmlFile:getValue(key .. "#jointNode" , "0>" )
        if entry.xmlFilename ~ = nil and entry.jointNode ~ = nil then
            entry.xmlFilename = entry.xmlFilename:gsub( "$data" , "data" )

            entry.transOffset = self.xmlFile:getValue(key .. "#transOffset" , "0 0 0" , true )
            entry.rotOffset = self.xmlFile:getValue(key .. "#rotOffset" , "0 0 0" , true )

            table.insert(spec.lockPositions, entry)
        else
                Logging.xmlWarning( self.xmlFile, "Invalid lock position '%s'.Missing xmlFilename or jointNode!" , key)
            end
        end )

        self.dynamicMountType = MountableObject.MOUNT_TYPE_NONE
        self.dynamicMountObjectId = nil

        spec.mountStateChangeListeners = { }
    end

```

### onPreAttach

**Description**

> Called if vehicle gets attached

**Definition**

> onPreAttach(table attacherVehicle, integer inputJointDescIndex, integer jointDescIndex)

**Arguments**

| table   | attacherVehicle     | attacher vehicle                            |
|---------|---------------------|---------------------------------------------|
| integer | inputJointDescIndex | index of input attacher joint               |
| integer | jointDescIndex      | index of attacher joint it gets attached to |

**Code**

```lua
function Mountable:onPreAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    self:unmountDynamic()
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
function Mountable:onReadStream(streamId, connection)
    self:setDynamicMountType(streamReadUIntN(streamId, MountableObject.MOUNT_TYPE_SEND_NUM_BITS), nil , true )
end

```

### onUpdate

**Description**

> Called on update

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
function Mountable:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self.spec_mountable
        if spec.dynamicMountObjectTriggerCount ~ = nil and spec.dynamicMountObjectTriggerCount < = 0 then
            if spec.dynamicMountJointNodeDynamicRefNode ~ = nil then
                local _, _, zOffset = localToLocal(spec.dynamicMountJointNodeDynamic, spec.dynamicMountJointNodeDynamicRefNode, 0 , 0 , 0 )
                if zOffset > spec.dynamicMountJointNodeDynamicMountOffset then
                    spec.dynamicMountJointNodeDynamicMountOffset = nil
                    spec.dynamicMountJointNodeDynamicRefNode = nil

                    self:unmountDynamic()
                    spec.dynamicMountObjectTriggerCount = nil
                else
                        self:raiseActive()
                    end
                else
                        self:unmountDynamic()
                        spec.dynamicMountObjectTriggerCount = nil
                    end
                end

                if self.dynamicMountJointIndex ~ = nil and spec.forceLimitUpdate.isAllowed then
                    self:updateDynamicMountJointForceLimit(dt)
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
function Mountable:onWriteStream(streamId, connection)
    streamWriteUIntN(streamId, self.spec_mountable.dynamicMountType, MountableObject.MOUNT_TYPE_SEND_NUM_BITS)
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
function Mountable.prerequisitesPresent(specializations)
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
function Mountable.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , Mountable )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , Mountable )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , Mountable )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , Mountable )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , Mountable )
    SpecializationUtil.registerEventListener(vehicleType, "onPreAttach" , Mountable )
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
function Mountable.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onDynamicMountTypeChanged" )
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
function Mountable.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getSupportsMountDynamic" , Mountable.getSupportsMountDynamic)
    SpecializationUtil.registerFunction(vehicleType, "getSupportsMountKinematic" , Mountable.getSupportsMountKinematic)
    SpecializationUtil.registerFunction(vehicleType, "onDynamicMountJointBreak" , Mountable.onDynamicMountJointBreak)
    SpecializationUtil.registerFunction(vehicleType, "mountableTriggerCallback" , Mountable.mountableTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "mount" , Mountable.mount)
    SpecializationUtil.registerFunction(vehicleType, "unmount" , Mountable.unmount)
    SpecializationUtil.registerFunction(vehicleType, "mountKinematic" , Mountable.mountKinematic)
    SpecializationUtil.registerFunction(vehicleType, "unmountKinematic" , Mountable.unmountKinematic)
    SpecializationUtil.registerFunction(vehicleType, "mountDynamic" , Mountable.mountDynamic)
    SpecializationUtil.registerFunction(vehicleType, "unmountDynamic" , Mountable.unmountDynamic)
    SpecializationUtil.registerFunction(vehicleType, "getAdditionalMountingDistance" , Mountable.getAdditionalMountingDistance)
    SpecializationUtil.registerFunction(vehicleType, "getAdditionalMountingMass" , Mountable.getAdditionalMountingMass)
    SpecializationUtil.registerFunction(vehicleType, "updateDynamicMountJointForceLimit" , Mountable.updateDynamicMountJointForceLimit)
    SpecializationUtil.registerFunction(vehicleType, "additionalMountingMassRaycastCallback" , Mountable.additionalMountingMassRaycastCallback)
    SpecializationUtil.registerFunction(vehicleType, "getMountObject" , Mountable.getMountObject)
    SpecializationUtil.registerFunction(vehicleType, "getDynamicMountObject" , Mountable.getDynamicMountObject)
    SpecializationUtil.registerFunction(vehicleType, "setReducedComponentMass" , Mountable.setReducedComponentMass)
    SpecializationUtil.registerFunction(vehicleType, "getAllowComponentMassReduction" , Mountable.getAllowComponentMassReduction)
    SpecializationUtil.registerFunction(vehicleType, "getDefaultAllowComponentMassReduction" , Mountable.getDefaultAllowComponentMassReduction)
    SpecializationUtil.registerFunction(vehicleType, "getMountableLockPositions" , Mountable.getMountableLockPositions)
    SpecializationUtil.registerFunction(vehicleType, "setDynamicMountType" , Mountable.setDynamicMountType)
    SpecializationUtil.registerFunction(vehicleType, "addMountStateChangeListener" , Mountable.addMountStateChangeListener)
    SpecializationUtil.registerFunction(vehicleType, "removeMountStateChangeListener" , Mountable.removeMountStateChangeListener)
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
function Mountable.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsActive" , Mountable.getIsActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getOwnerConnection" , Mountable.getOwnerConnection)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "findRootVehicle" , Mountable.findRootVehicle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMapHotspotVisible" , Mountable.getIsMapHotspotVisible)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAdditionalComponentMass" , Mountable.getAdditionalComponentMass)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "setWorldPositionQuaternion" , Mountable.setWorldPositionQuaternion)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addToPhysics" , Mountable.addToPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "removeFromPhysics" , Mountable.removeFromPhysics)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , Mountable.getIsFoldAllowed)
end

```

### removeMountStateChangeListener

**Description**

**Definition**

> removeMountStateChangeListener()

**Arguments**

| any | object       |
|-----|--------------|
| any | callbackFunc |

**Code**

```lua
function Mountable:removeMountStateChangeListener(object, callbackFunc)
    local spec = self.spec_mountable
    if callbackFunc = = nil then
        callbackFunc = "onObjectMountStateChanged"
    end

    local indexToRemove = - 1
    for i, listener in ipairs(spec.mountStateChangeListeners) do
        if listener.object = = object and listener.callbackFunc = = callbackFunc then
            indexToRemove = i
        end
    end

    if indexToRemove > 0 then
        table.remove(spec.mountStateChangeListeners, indexToRemove)
    end
end

```

### setDynamicMountType

**Description**

**Definition**

> setDynamicMountType()

**Arguments**

| any | mountType   |
|-----|-------------|
| any | mountObject |
| any | noEventSend |

**Code**

```lua
function Mountable:setDynamicMountType(mountType, mountObject, noEventSend)
    local spec = self.spec_mountable
    if mountType ~ = self.dynamicMountType then
        self.dynamicMountType = mountType

        if mountObject ~ = nil then
            self.dynamicMountObjectId = NetworkUtil.getObjectId(mountObject)
        else
                self.dynamicMountObjectId = nil
            end

            if mountType = = MountableObject.MOUNT_TYPE_NONE then
                self:setReducedComponentMass( false )
            end

            for _, listener in ipairs(spec.mountStateChangeListeners) do
                if type(listener.callbackFunc) = = "string" then
                    listener.object[listener.callbackFunc](listener.object, self , mountType, mountObject)
                elseif type(listener.callbackFunc) = = "function" then
                        listener.callbackFunc(listener.object, self , mountType, mountObject)
                    end
                end

                SpecializationUtil.raiseEvent( self , "onDynamicMountTypeChanged" , self.dynamicMountType, mountObject)

                MountableSetMountTypeEvent.sendEvent( self , self.dynamicMountType, mountObject, noEventSend)
            end
        end

```

### setReducedComponentMass

**Description**

**Definition**

> setReducedComponentMass()

**Arguments**

| any | state |
|-----|-------|

**Code**

```lua
function Mountable:setReducedComponentMass(state)
    local spec = self.spec_mountable
    if self:getAllowComponentMassReduction() then
        if spec.reducedComponentMass ~ = state then
            spec.reducedComponentMass = state
            self:setMassDirty()
        end

        return true
    end

    return false
end

```

### setWorldPositionQuaternion

**Description**

> Set world position and quaternion rotation of component

**Definition**

> setWorldPositionQuaternion(float x, float y, float z, float qx, float qy, float qz, float qw, integer i, boolean
> changeInterp, )

**Arguments**

| float   | x            | x position           |
|---------|--------------|----------------------|
| float   | y            | y position           |
| float   | z            | z position           |
| float   | qx           | x rotation           |
| float   | qy           | y rotation           |
| float   | qz           | z rotation           |
| float   | qw           | w rotation           |
| integer | i            | index if component   |
| boolean | changeInterp | change interpolation |
| any     | changeInterp |                      |

**Code**

```lua
function Mountable:setWorldPositionQuaternion(superFunc, x, y, z, qx, qy, qz, qw, i, changeInterp)
    if not self.isServer then
        -- while the object is mounted on client side kinematically or default
            -- received positions are not applied since the position is dependent on the mount object
            -- only the first component is kinematically linked, so still receive the others translation
            if self:getMountObject() ~ = nil then
                return
            end
        end

        return superFunc( self , x, y, z, qx, qy, qz, qw, i, changeInterp)
    end

```

### unmount

**Description**

**Definition**

> unmount()

**Arguments**

| any | noEventSend |
|-----|-------------|

**Code**

```lua
function Mountable:unmount(noEventSend)
    local spec = self.spec_mountable

    if self.dynamicMountType = = MountableObject.MOUNT_TYPE_DEFAULT then
        local mountObject = self:getDynamicMountObject()
        if mountObject ~ = nil and mountObject.onUnmountObject ~ = nil then
            mountObject:onUnmountObject( self )
        end

        local x,y,z = getWorldTranslation(spec.componentNode)
        local qx,qy,qz,qw = getWorldQuaternion(spec.componentNode)

        link(getRootNode(), spec.componentNode)
        self:setWorldPositionQuaternion(x,y,z, qx,qy,qz,qw, 1 , true )

        addToPhysics(spec.componentNode)

        self:setDynamicMountType( MountableObject.MOUNT_TYPE_NONE, nil , noEventSend)

        return true
    end

    return false
end

```

### unmountDynamic

**Description**

**Definition**

> unmountDynamic()

**Arguments**

| any | isDelete |
|-----|----------|

**Code**

```lua
function Mountable:unmountDynamic(isDelete)
    self:setDynamicMountType( MountableObject.MOUNT_TYPE_NONE)

    local mountObject = self:getDynamicMountObject()
    if mountObject ~ = nil and mountObject.onUnmountObject ~ = nil then
        mountObject:onUnmountObject( self )
    end

    self:setDynamicMountType( MountableObject.MOUNT_TYPE_NONE)

    DynamicMountUtil.unmountDynamic( self , isDelete)
end

```

### unmountKinematic

**Description**

**Definition**

> unmountKinematic()

**Code**

```lua
function Mountable:unmountKinematic()
    local spec = self.spec_mountable

    if self.dynamicMountType = = MountableObject.MOUNT_TYPE_KINEMATIC then
        local mountObject = self:getDynamicMountObject()
        if mountObject ~ = nil then
            if mountObject.getParentComponent ~ = nil then
                local componentNode = mountObject:getParentComponent(spec.mountJointNode)
                if getRigidBodyType(componentNode) = = RigidBodyType.DYNAMIC then
                    setPairCollision(componentNode, spec.componentNode, true )
                end
            end

            if mountObject.onUnmountObject ~ = nil then
                mountObject:onUnmountObject( self )
            end
        end

        spec.mountJointNode = nil
        local x,y,z = getWorldTranslation(spec.componentNode)
        local qx,qy,qz,qw = getWorldQuaternion(spec.componentNode)

        removeFromPhysics(spec.componentNode)
        link(getRootNode(), spec.componentNode)
        self:setWorldPositionQuaternion(x,y,z, qx,qy,qz,qw, 1 , true )
        addToPhysics(spec.componentNode)

        if self.isServer then
            setRigidBodyType(spec.componentNode, RigidBodyType.DYNAMIC)

            self.components[ 1 ].isKinematic = false
            self.components[ 1 ].isDynamic = true
        end

        self:setDynamicMountType( MountableObject.MOUNT_TYPE_NONE)

        return true
    end

    return false
end

```

### updateDynamicMountJointForceLimit

**Description**

> Updates the dynamic mount joint force limit dynamically based on how many objects are stacked on top of each

**Definition**

> updateDynamicMountJointForceLimit()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Mountable:updateDynamicMountJointForceLimit(dt)
    local spec = self.spec_mountable

    if not spec.forceLimitUpdate.raycastActive then
        spec.forceLimitUpdate.timer = spec.forceLimitUpdate.timer - dt
        if spec.forceLimitUpdate.timer < = 0 then
            spec.forceLimitUpdate.raycastActive = true
            spec.forceLimitUpdate.timer = Mountable.FORCE_LIMIT_UPDATE_TIME
            spec.forceLimitUpdate.lastDistance = 0
            spec.forceLimitUpdate.lastObject = nil
            spec.forceLimitUpdate.nextMountingDistance = self:getAdditionalMountingDistance()
            spec.forceLimitUpdate.additionalMass = 0

            local x, y, z = getWorldTranslation( self.rootNode)
            raycastAllAsync(x, y, z, 0 , 1 , 0 , Mountable.FORCE_LIMIT_RAYCAST_DISTANCE, "additionalMountingMassRaycastCallback" , self , CollisionFlag.DYNAMIC_OBJECT)
        end
    end
end

```