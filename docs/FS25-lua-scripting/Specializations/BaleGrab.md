## BaleGrab

**Description**

> Specialization for a balegrab tool adding soft attaching of bales

**Functions**

- [addDynamicMountedObject](#adddynamicmountedobject)
- [baleGrabTriggerCallback](#balegrabtriggercallback)
- [getIsBaleGrabClosed](#getisbalegrabclosed)
- [getMovingToolMoveValue](#getmovingtoolmovevalue)
- [getSpecValueMaxSize](#getspecvaluemaxsize)
- [getSpecValueMaxSizeRound](#getspecvaluemaxsizeround)
- [getSpecValueMaxSizeSquare](#getspecvaluemaxsizesquare)
- [initSpecialization](#initspecialization)
- [loadSpecValueMaxSize](#loadspecvaluemaxsize)
- [loadSpecValueMaxSizeRound](#loadspecvaluemaxsizeround)
- [loadSpecValueMaxSizeSquare](#loadspecvaluemaxsizesquare)
- [mountBaleGrabObject](#mountbalegrabobject)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPendingObjectDelete](#onpendingobjectdelete)
- [onPendingObjectMountStateChanged](#onpendingobjectmountstatechanged)
- [onPostLoad](#onpostload)
- [onUpdateTick](#onupdatetick)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeDynamicMountedObject](#removedynamicmountedobject)
- [unmountBaleGrabObject](#unmountbalegrabobject)
- [updateDebugValues](#updatedebugvalues)

### addDynamicMountedObject

**Description**

> Add dynamic mount object

**Definition**

> addDynamicMountedObject(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Code**

```lua
function BaleGrab:addDynamicMountedObject(object)
    local spec = self.spec_baleGrab
    spec.dynamicMountedObjects[object] = object
end

```

### baleGrabTriggerCallback

**Description**

> Trigger callback

**Definition**

> baleGrabTriggerCallback(integer triggerId, integer otherActorId, boolean onEnter, boolean onLeave, boolean onStay,
> integer otherShapeId)

**Arguments**

| integer | triggerId    | id of trigger     |
|---------|--------------|-------------------|
| integer | otherActorId | id of other actor |
| boolean | onEnter      | on enter          |
| boolean | onLeave      | on leave          |
| boolean | onStay       | on stay           |
| integer | otherShapeId | id of other shape |

**Code**

```lua
function BaleGrab:baleGrabTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_baleGrab
    if onEnter then
        local object = g_currentMission:getNodeObject(otherActorId)
        if object ~ = nil and object ~ = self and object.getSupportsMountDynamic ~ = nil and object:getSupportsMountDynamic() and object.addMountStateChangeListener ~ = nil and(object.nodeId ~ = nil or object.rootNode ~ = 0 ) then
            spec.pendingDynamicMountObjects[object] = (spec.pendingDynamicMountObjects[object] or 0 ) + 1
            if spec.pendingDynamicMountObjects[object] = = 1 then
                object:addDeleteListener( self , BaleGrab.onPendingObjectDelete)
                object:addMountStateChangeListener( self , BaleGrab.onPendingObjectMountStateChanged)
            end
        end
    elseif onLeave then
            local object = g_currentMission:getNodeObject(otherActorId)
            if object ~ = nil then
                if spec.pendingDynamicMountObjects[object] ~ = nil then
                    spec.pendingDynamicMountObjects[object] = spec.pendingDynamicMountObjects[object] - 1
                    if spec.pendingDynamicMountObjects[object] < = 0 then
                        self:removeDynamicMountedObject(object, true )
                        object:removeDeleteListener( self , BaleGrab.onPendingObjectDelete)
                        object:removeMountStateChangeListener( self , BaleGrab.onPendingObjectMountStateChanged)
                    end
                end
            end
        end
    end

```

### getIsBaleGrabClosed

**Description**

> Returns if the bale grab is closed or not

**Definition**

> getIsBaleGrabClosed()

**Arguments**

| any | grab |
|-----|------|

**Code**

```lua
function BaleGrab:getIsBaleGrabClosed(grab)
    -- while the moving tools are fully opened the grab can never be closed, even if the joint is over the limit
        for toolIndex = 1 , #grab.movingTools do
            local movingToolData = grab.movingTools[toolIndex]

            local state = Cylindered.getMovingToolState( self , movingToolData.movingTool)
            if movingToolData.closingDirection > 0 then
                if state < 0.01 then
                    return false
                end
            else
                    if state > 0.99 then
                        return false
                    end
                end
            end

            if grab.rotationAxis ~ = nil then
                grab.lastValues[ 1 ], grab.lastValues[ 2 ], grab.lastValues[ 3 ] = localRotationToLocal(grab.componentJointActor1, grab.componentJointActor0, 0 , 0 , 0 )
                if grab.rotationThreshold > 0 then
                    if grab.lastValues[grab.rotationAxis] > grab.rotationThreshold then
                        return true
                    end
                else
                        if grab.lastValues[grab.rotationAxis] < grab.rotationThreshold then
                            return true
                        end
                    end
                elseif grab.translationAxis ~ = nil then
                        grab.lastValues[ 1 ], grab.lastValues[ 2 ], grab.lastValues[ 3 ] = localToLocal(grab.componentJointActor1, grab.componentJointActor0, 0 , 0 , 0 )

                        if grab.translationThreshold > 0 then
                            if grab.lastValues[grab.translationAxis] > grab.translationThreshold then
                                return true
                            end
                        else
                                if grab.lastValues[grab.translationAxis] < grab.translationThreshold then
                                    return true
                                end
                            end
                        end

                        return false
                    end

```

### getMovingToolMoveValue

**Description**

**Definition**

> getMovingToolMoveValue()

**Arguments**

| any | superFunc  |
|-----|------------|
| any | movingTool |

**Code**

```lua
function BaleGrab:getMovingToolMoveValue(superFunc, movingTool)
    local move = superFunc( self , movingTool)

    local spec = self.spec_baleGrab
    for i = 1 , #spec.grabs do
        local grab = spec.grabs[i]
        for toolIndex = 1 , #grab.movingTools do
            local movingToolData = grab.movingTools[toolIndex]
            if movingToolData.movingTool = = movingTool then
                movingToolData.lastMoveValue = move
                if grab.closeTimer < BaleGrab.CLOSE_TIMER and next(spec.pendingDynamicMountObjects) ~ = nil then
                    if math.sign(move) = = movingToolData.closingDirection then
                        move = 0
                    end
                end
            end
        end
    end

    return move
end

```

### getSpecValueMaxSize

**Description**

**Definition**

> getSpecValueMaxSize()

**Arguments**

| any | specName       |
|-----|----------------|
| any | storeItem      |
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function BaleGrab.getSpecValueMaxSize(specName, storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    local spec = storeItem.specs[specName]
    if spec ~ = nil then
        local minValue = spec.minSize or spec.maxSize
        local maxValue = spec.maxSize or spec.minSize

        if returnValues = = nil or not returnValues then
            local unit = g_i18n:getText( "unit_cmShort" )
            local size
            if maxValue ~ = minValue and minValue ~ = 0 and maxValue ~ = 0 then
                size = string.format( "%d%s-%d%s" , minValue * 100 , unit, maxValue * 100 , unit)
            else
                    size = string.format( "%d%s" , math.max(minValue, maxValue) * 100 , unit)
                end

                return size
            else
                    if returnRange = = true and maxValue ~ = minValue and minValue ~ = 0 and maxValue ~ = 0 then
                        return minValue * 100 , maxValue * 100 , g_i18n:getText( "unit_cmShort" )
                    else
                            return math.max(minValue, maxValue) * 100 , g_i18n:getText( "unit_cmShort" )
                        end
                    end
                end
            end

```

### getSpecValueMaxSizeRound

**Description**

**Definition**

> getSpecValueMaxSizeRound()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function BaleGrab.getSpecValueMaxSizeRound(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    return BaleGrab.getSpecValueMaxSize( "baleGrabMaxSizeRound" , storeItem, realItem, configurations, saleItem, returnValues, returnRange)
end

```

### getSpecValueMaxSizeSquare

**Description**

**Definition**

> getSpecValueMaxSizeSquare()

**Arguments**

| any | storeItem      |
|-----|----------------|
| any | realItem       |
| any | configurations |
| any | saleItem       |
| any | returnValues   |
| any | returnRange    |

**Code**

```lua
function BaleGrab.getSpecValueMaxSizeSquare(storeItem, realItem, configurations, saleItem, returnValues, returnRange)
    return BaleGrab.getSpecValueMaxSize( "baleGrabMaxSizeSquare" , storeItem, realItem, configurations, saleItem, returnValues, returnRange)
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function BaleGrab.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "BaleGrab" )

    schema:register(XMLValueType.FLOAT, "vehicle.baleGrab#minSizeRound" , "Min.size of round bales(for shop display only)" )
        schema:register(XMLValueType.FLOAT, "vehicle.baleGrab#maxSizeRound" , "Max.size of round bales(for shop display only)" )

            schema:register(XMLValueType.FLOAT, "vehicle.baleGrab#minSizeSquare" , "Min.size of square bales(for shop display only)" )
                schema:register(XMLValueType.FLOAT, "vehicle.baleGrab#maxSizeSquare" , "Max.size of square bales(for shop display only)" )

                    schema:register(XMLValueType.NODE_INDEX, "vehicle.baleGrab#triggerNode" , "Trigger node" )
                    schema:register(XMLValueType.NODE_INDEX, "vehicle.baleGrab#rootNode" , "Root node" , "Main component" )
                    schema:register(XMLValueType.STRING, "vehicle.baleGrab#dynamicMountType" , "Dynamic mount type" , "TYPE_FIX_ATTACH" )
                    schema:register(XMLValueType.FLOAT, "vehicle.baleGrab#forceAcceleration" , "Force acceleration" , 20 )

                    schema:register(XMLValueType.INT, "vehicle.baleGrab.grab(?)#componentJointIndex" , "Component joint index of grab" )
                    schema:register(XMLValueType.FLOAT, "vehicle.baleGrab.grab(?)#dampingFactor" , "Factor that is applied to the component joint rot/trans damping as soon as a bale is mounted" , 20 )

                    schema:register(XMLValueType.INT, "vehicle.baleGrab.grab(?)#rotationAxis" , "Rotation axis of component joint to detect if the grab is rotating out of the limits(only rotation or translation axis can be used)" )
                        schema:register(XMLValueType.ANGLE, "vehicle.baleGrab.grab(?)#rotationThreshold" , "Threshold to mount the bale if the component is this angle off the component joint rotation" , 5 )

                            schema:register(XMLValueType.INT, "vehicle.baleGrab.grab(?)#translationAxis" , "Translation axis of component joint to detect if the grab is translating out of the limits(only rotation or translation axis can be used)" )
                                schema:register(XMLValueType.FLOAT, "vehicle.baleGrab.grab(?)#translationThreshold" , "Threshold to mount the bale if the component is this translation off the component joint translation" , 0.05 )

                                    schema:register(XMLValueType.NODE_INDEX, "vehicle.baleGrab.grab(?).movingTool(?)#node" , "Node of moving tool to block while limit is exceeded" )
                                        schema:register(XMLValueType.INT, "vehicle.baleGrab.grab(?).movingTool(?)#closingDirection" , "Direction to block the moving tool" , 1 )

                                        schema:setXMLSpecializationType()

                                        g_storeManager:addSpecType( "baleGrabMaxSizeRound" , "shopListAttributeIconBaleSizeRound" , BaleGrab.loadSpecValueMaxSizeRound, BaleGrab.getSpecValueMaxSizeRound, StoreSpecies.VEHICLE)
                                        g_storeManager:addSpecType( "baleGrabMaxSizeSquare" , "shopListAttributeIconBaleSizeSquare" , BaleGrab.loadSpecValueMaxSizeSquare, BaleGrab.getSpecValueMaxSizeSquare, StoreSpecies.VEHICLE)
                                    end

```

### loadSpecValueMaxSize

**Description**

**Definition**

> loadSpecValueMaxSize()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | minKey  |
| any | maxKey  |

**Code**

```lua
function BaleGrab.loadSpecValueMaxSize(xmlFile, minKey, maxKey)
    local sizeData = { }

    sizeData.minSize = MathUtil.round(xmlFile:getValue(minKey) or 0 , 2 )
    sizeData.maxSize = MathUtil.round(xmlFile:getValue(maxKey) or 0 , 2 )

    if sizeData.minSize ~ = 0 or sizeData.maxSize ~ = 0 then
        return sizeData
    end
end

```

### loadSpecValueMaxSizeRound

**Description**

**Definition**

> loadSpecValueMaxSizeRound()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function BaleGrab.loadSpecValueMaxSizeRound(xmlFile, customEnvironment, baseDir)
    return BaleGrab.loadSpecValueMaxSize(xmlFile, "vehicle.baleGrab#minSizeRound" , "vehicle.baleGrab#maxSizeRound" )
end

```

### loadSpecValueMaxSizeSquare

**Description**

**Definition**

> loadSpecValueMaxSizeSquare()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | customEnvironment |
| any | baseDir           |

**Code**

```lua
function BaleGrab.loadSpecValueMaxSizeSquare(xmlFile, customEnvironment, baseDir)
    return BaleGrab.loadSpecValueMaxSize(xmlFile, "vehicle.baleGrab#minSizeSquare" , "vehicle.baleGrab#maxSizeSquare" )
end

```

### mountBaleGrabObject

**Description**

> Mounts a dynamic object to the bale grab

**Definition**

> mountBaleGrabObject(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Return Values**

| table | success | success |
|-------|---------|---------|

**Code**

```lua
function BaleGrab:mountBaleGrabObject(object)
    local spec = self.spec_baleGrab

    local rootNode = object.nodeId or object.rootNode

    local x, y, z = localToWorld(rootNode, getCenterOfMass(rootNode))
    setWorldTranslation(spec.jointNode, x, y, z)

    if object:mountDynamic( self , spec.rootNode, spec.jointNode, spec.dynamicMountType, spec.forceAcceleration) then
        for i = 1 , 3 do
            setJointRotationLimitSpring(object.dynamicMountJointIndex, i - 1 , 10000 , 10 )
            setJointTranslationLimitSpring(object.dynamicMountJointIndex, i - 1 , 10000 , 10 )
        end

        self:addDynamicMountedObject(object)
        return true
    end

    return false
end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function BaleGrab:onDelete()
    local spec = self.spec_baleGrab

    if spec.pendingDynamicMountObjects ~ = nil then
        for object, _ in pairs(spec.pendingDynamicMountObjects) do
            if object.removeDeleteListener ~ = nil then
                object:removeDeleteListener( self , BaleGrab.onPendingObjectDelete)
            end
            if object.removeMountStateChangeListener ~ = nil then
                object:removeMountStateChangeListener( self , BaleGrab.onPendingObjectMountStateChanged)
            end
        end
        table.clear(spec.pendingDynamicMountObjects)
    end

    if spec.dynamicMountedObjects ~ = nil then
        for object,_ in pairs(spec.dynamicMountedObjects) do
            self:unmountBaleGrabObject(object)
        end
        table.clear(spec.dynamicMountedObjects)
    end

    if spec.triggerNode ~ = nil then
        removeTrigger(spec.triggerNode)
        spec.triggerNode = nil
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
function BaleGrab:onLoad(savegame)
    local spec = self.spec_baleGrab

    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baleGrab#jointType" , "vehicle.baleGrab#dynamicMountType" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baleGrab#grabRefComponentJointIndex1" , "vehicle.baleGrab.grab#componentJointIndex" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baleGrab#grabRefComponentJointIndex2" , "vehicle.baleGrab.grab#componentJointIndex" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baleGrab#rotDiffThreshold1" , "vehicle.baleGrab.grab#rotationThreshold" )
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, "vehicle.baleGrab#rotDiffThreshold2" , "vehicle.baleGrab.grab#rotationThreshold" )

    if self.isServer then
        spec.rootNode = self.xmlFile:getValue( "vehicle.baleGrab#rootNode" , self.rootNode, self.components, self.i3dMappings)

        spec.triggerNode = self.xmlFile:getValue( "vehicle.baleGrab#triggerNode" , nil , self.components, self.i3dMappings)
        if spec.triggerNode ~ = nil then
            if CollisionFlag.getHasMaskFlagSet(spec.triggerNode, CollisionFlag.DYNAMIC_OBJECT) then
                addTrigger(spec.triggerNode, "baleGrabTriggerCallback" , self )
            else
                    Logging.xmlWarning( self.xmlFile, "BaleGrab trigger has no 'TRIGGER_DYNAMIC_OBJECT' collision bit set!" )
                end

                spec.jointNode = createTransformGroup( "balegrabJointNode" )
                link(spec.rootNode, spec.jointNode)

                spec.forceAcceleration = self.xmlFile:getValue( "vehicle.baleGrab#forceAcceleration" , 20 )

                local dynamicMountTypeString = self.xmlFile:getValue( "vehicle.baleGrab#dynamicMountType" , "TYPE_FIX_ATTACH" )
                spec.dynamicMountType = DynamicMountUtil[dynamicMountTypeString] or DynamicMountUtil.TYPE_FIX_ATTACH

                spec.grabs = { }

                self.xmlFile:iterate( "vehicle.baleGrab.grab" , function (_, key)
                    local grab = { }
                    grab.componentJointIndex = self.xmlFile:getValue(key .. "#componentJointIndex" )
                    if grab.componentJointIndex ~ = nil then
                        grab.dampingFactor = self.xmlFile:getValue(key .. "#dampingFactor" , 20 )

                        grab.rotationAxis = self.xmlFile:getValue(key .. "#rotationAxis" )
                        if grab.rotationAxis ~ = nil then
                            grab.rotationThreshold = self.xmlFile:getValue(key .. "#rotationThreshold" , 5 )
                        else
                                grab.translationAxis = self.xmlFile:getValue(key .. "#translationAxis" )
                                if grab.translationAxis ~ = nil then
                                    grab.translationThreshold = self.xmlFile:getValue(key .. "#translationThreshold" , 0.05 )
                                else
                                        Logging.xmlWarning( self.xmlFile, "Missing rotation or translation axis in '%s" , key)
                                    end
                                end

                                if grab.rotationAxis ~ = nil or grab.translationAxis then
                                    grab.componentJoint = self.componentJoints[grab.componentJointIndex]
                                    if grab.componentJoint ~ = nil then
                                        grab.componentJointActor0 = grab.componentJoint.jointNode
                                        grab.componentJointActor1 = grab.componentJoint.jointNodeActor1
                                        if grab.componentJointActor0 = = grab.componentJointActor1 then
                                            grab.componentJointActor1 = createTransformGroup( "componentJointActor1" )

                                            if self:getParentComponent(grab.componentJointActor0) = = self.components[grab.componentJoint.componentIndices[ 1 ]].node then
                                                link( self.components[grab.componentJoint.componentIndices[ 2 ]].node, grab.componentJointActor1)
                                            else
                                                    link( self.components[grab.componentJoint.componentIndices[ 1 ]].node, grab.componentJointActor1)
                                                end
                                                setWorldTranslation(grab.componentJointActor1, getWorldTranslation(grab.componentJointActor0))
                                                setWorldRotation(grab.componentJointActor1, getWorldRotation(grab.componentJointActor0))
                                            end

                                            grab.movingTools = { }
                                            self.xmlFile:iterate(key .. ".movingTool" , function (_, movingToolKey)
                                                local movingToolData = { }
                                                movingToolData.node = self.xmlFile:getValue(movingToolKey .. "#node" , nil , self.components, self.i3dMappings)
                                                if movingToolData.node ~ = nil then
                                                    movingToolData.closingDirection = self.xmlFile:getValue(movingToolKey .. "#closingDirection" )
                                                    table.insert(grab.movingTools, movingToolData)
                                                end
                                            end )

                                            grab.lastValues = { 0 , 0 , 0 }
                                            grab.isClosed = false
                                            grab.closeTimer = 0
                                            grab.jointChecksum = 0

                                            table.insert(spec.grabs, grab)
                                        else
                                                Logging.xmlWarning( self.xmlFile, "Invalid component joint index %s in '%s" , grab.componentJointIndex, key)
                                            end
                                        end
                                    else
                                            Logging.xmlWarning( self.xmlFile, "Missing component joint in '%s" , key)
                                        end
                                    end )
                                end

                                spec.lastAllGrabsClosed = false
                                spec.dynamicMountedObjects = { }
                                spec.pendingDynamicMountObjects = { }
                            end

                            if spec.triggerNode = = nil then
                                SpecializationUtil.removeEventListener( self , "onPostLoad" , BaleGrab )
                                SpecializationUtil.removeEventListener( self , "onDelete" , BaleGrab )
                                SpecializationUtil.removeEventListener( self , "onUpdateTick" , BaleGrab )
                            end
                        end

```

### onPendingObjectDelete

**Description**

**Definition**

> onPendingObjectDelete()

**Arguments**

| any | self   |
|-----|--------|
| any | object |

**Code**

```lua
function BaleGrab.onPendingObjectDelete( self , object)
    local spec = self.spec_baleGrab
    if spec.pendingDynamicMountObjects[object] ~ = nil or spec.dynamicMountedObjects[object] ~ = nil then
        self:removeDynamicMountedObject(object, true )
    end
end

```

### onPendingObjectMountStateChanged

**Description**

**Definition**

> onPendingObjectMountStateChanged()

**Arguments**

| any | self        |
|-----|-------------|
| any | object      |
| any | mountState  |
| any | mountObject |

**Code**

```lua
function BaleGrab.onPendingObjectMountStateChanged( self , object, mountState, mountObject)
    if mountState ~ = MountableObject.MOUNT_TYPE_NONE and mountObject ~ = self then
        local spec = self.spec_baleGrab
        if spec.pendingDynamicMountObjects[object] ~ = nil or spec.dynamicMountedObjects[object] ~ = nil then
            self:removeDynamicMountedObject(object, true )
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
function BaleGrab:onPostLoad(savegame)
    local spec = self.spec_baleGrab
    for i = 1 , #spec.grabs do
        local grab = spec.grabs[i]
        for toolIndex = #grab.movingTools, 1 , - 1 do
            local movingToolData = grab.movingTools[toolIndex]
            movingToolData.movingTool = self:getMovingToolByNode(movingToolData.node)
            if movingToolData.movingTool = = nil then
                table.remove(grab.movingTools, toolIndex)
            end
        end
    end
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
function BaleGrab:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isServer then
        local spec = self.spec_baleGrab

        local allGrabsClosed = next(spec.pendingDynamicMountObjects) ~ = nil
        for i = 1 , #spec.grabs do
            local grab = spec.grabs[i]

            local isClosed = self:getIsBaleGrabClosed(grab)
            if isClosed then
                grab.closeTimer = math.max(grab.closeTimer - dt, 0 )
            else
                    grab.closeTimer = BaleGrab.CLOSE_TIMER
                end

                -- update checksum while grab is open and after the close timer is down to 0
                    -- like this we check if the grab joint has been changed while the grab is closing(while the timer is running)
                        -- if the joint was not moved or rotated by the player we don't allow any update of the grab state
                            -- otherwise small impacts on the component could cause a unmounting of the bale, especially with a high joint damping
                            if (grab.closeTimer = = 0 ) ~ = grab.isClosed then
                                local x, y, z = getTranslation(grab.componentJointActor0)
                                local rx, ry, rz = getRotation(grab.componentJointActor0)
                                local jointChecksum = x + y + z + rx + ry + rz
                                if grab.jointChecksum ~ = jointChecksum then
                                    grab.jointChecksum = jointChecksum
                                    grab.isClosed = grab.closeTimer = = 0
                                elseif next(spec.pendingDynamicMountObjects) ~ = nil and grab.closeTimer = = 0 then
                                        grab.isClosed = grab.closeTimer = = 0
                                    elseif next(spec.pendingDynamicMountObjects) = = nil and grab.closeTimer = = BaleGrab.CLOSE_TIMER then
                                            -- update the grab state if nothing is in the trigger and the new state would be open
                                                -- otherwise it can happen that a bale that enters the trigger newly will be mounted directly
                                                grab.isClosed = grab.closeTimer = = 0
                                            end
                                        elseif grab.closeTimer = = BaleGrab.CLOSE_TIMER then
                                                local x, y, z = getTranslation(grab.componentJointActor0)
                                                local rx, ry, rz = getRotation(grab.componentJointActor0)
                                                grab.jointChecksum = x + y + z + rx + ry + rz
                                            end

                                            if not grab.isClosed then
                                                allGrabsClosed = false
                                            end
                                        end

                                        if allGrabsClosed ~ = spec.lastAllGrabsClosed then
                                            spec.lastAllGrabsClosed = allGrabsClosed

                                            if allGrabsClosed then
                                                for object, _ in pairs(spec.pendingDynamicMountObjects) do
                                                    if spec.dynamicMountedObjects[object] = = nil and object.dynamicMountType = = MountableObject.MOUNT_TYPE_NONE then
                                                        self:unmountBaleGrabObject(object)
                                                        self:mountBaleGrabObject(object)
                                                    end
                                                end

                                                for i = 1 , #spec.grabs do
                                                    local grab = spec.grabs[i]
                                                    for axis = 1 , 3 do
                                                        if grab.rotationAxis ~ = nil then
                                                            setJointRotationLimitSpring(grab.componentJoint.jointIndex, axis - 1 , grab.componentJoint.rotLimitSpring[axis], grab.componentJoint.rotLimitDamping[axis] * grab.dampingFactor)
                                                        else
                                                                setJointTranslationLimitSpring(grab.componentJoint.jointIndex, axis - 1 , grab.componentJoint.transLimitSpring[axis], grab.componentJoint.transLimitDamping[axis] * grab.dampingFactor)
                                                            end
                                                        end
                                                    end
                                                else
                                                        for object,_ in pairs(spec.dynamicMountedObjects) do
                                                            self:unmountBaleGrabObject(object)
                                                        end

                                                        for i = 1 , #spec.grabs do
                                                            local grab = spec.grabs[i]
                                                            for axis = 1 , 3 do
                                                                if grab.rotationAxis ~ = nil then
                                                                    setJointRotationLimitSpring(grab.componentJoint.jointIndex, axis - 1 , grab.componentJoint.rotLimitSpring[axis], grab.componentJoint.rotLimitDamping[axis])
                                                                else
                                                                        setJointTranslationLimitSpring(grab.componentJoint.jointIndex, axis - 1 , grab.componentJoint.transLimitSpring[axis], grab.componentJoint.transLimitDamping[axis])
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

**Definition**

> prerequisitesPresent()

**Arguments**

| any | specializations |
|-----|-----------------|

**Code**

```lua
function BaleGrab.prerequisitesPresent(specializations)
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
function BaleGrab.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , BaleGrab )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , BaleGrab )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , BaleGrab )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , BaleGrab )
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
function BaleGrab.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "baleGrabTriggerCallback" , BaleGrab.baleGrabTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "addDynamicMountedObject" , BaleGrab.addDynamicMountedObject)
    SpecializationUtil.registerFunction(vehicleType, "removeDynamicMountedObject" , BaleGrab.removeDynamicMountedObject)
    SpecializationUtil.registerFunction(vehicleType, "getIsBaleGrabClosed" , BaleGrab.getIsBaleGrabClosed)
    SpecializationUtil.registerFunction(vehicleType, "mountBaleGrabObject" , BaleGrab.mountBaleGrabObject)
    SpecializationUtil.registerFunction(vehicleType, "unmountBaleGrabObject" , BaleGrab.unmountBaleGrabObject)
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
function BaleGrab.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getMovingToolMoveValue" , BaleGrab.getMovingToolMoveValue)
end

```

### removeDynamicMountedObject

**Description**

> Remove dynamic mount object

**Definition**

> removeDynamicMountedObject(table object, boolean isDeleting)

**Arguments**

| table   | object     | object      |
|---------|------------|-------------|
| boolean | isDeleting | is deleting |

**Code**

```lua
function BaleGrab:removeDynamicMountedObject(object, isDeleting)
    local spec = self.spec_baleGrab

    if object.dynamicMountType = = MountableObject.MOUNT_TYPE_DYNAMIC then
        object:unmountDynamic()
    end

    spec.dynamicMountedObjects[object] = nil
    if isDeleting then
        spec.pendingDynamicMountObjects[object] = nil
    end
end

```

### unmountBaleGrabObject

**Description**

> Unmounts a dynamic object from the bale grab

**Definition**

> unmountBaleGrabObject(table object)

**Arguments**

| table | object | object |
|-------|--------|--------|

**Return Values**

| table | success | success |
|-------|---------|---------|

**Code**

```lua
function BaleGrab:unmountBaleGrabObject(object)
    self:removeDynamicMountedObject(object, false )

    return true
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
function BaleGrab:updateDebugValues(values)
    if self.isServer then
        local spec = self.spec_baleGrab
        for i = 1 , #spec.grabs do
            local grab = spec.grabs[i]

            if grab.rotationAxis ~ = nil then
                local isClosed = false
                grab.lastValues[ 1 ], grab.lastValues[ 2 ], grab.lastValues[ 3 ] = localRotationToLocal(grab.componentJointActor1, grab.componentJointActor0, 0 , 0 , 0 )

                if grab.rotationThreshold > 0 then
                    if grab.lastValues[grab.rotationAxis] > grab.rotationThreshold then
                        isClosed = true
                    end
                else
                        if grab.lastValues[grab.rotationAxis] < grab.rotationThreshold then
                            isClosed = true
                        end
                    end

                    table.insert(values, { name = string.format( "grab(rot - %s):" , getName(grab.componentJointActor0)), value = string.format( "offset: %.1fdeg / %.1fdeg | state: %s(t %d)" , math.deg(grab.lastValues[grab.rotationAxis]), math.deg(grab.rotationThreshold), isClosed and "closed" or "open" , grab.closeTimer) } )
                elseif grab.translationAxis ~ = nil then
                        local isClosed = false
                        grab.lastValues[ 1 ], grab.lastValues[ 2 ], grab.lastValues[ 3 ] = localToLocal(grab.componentJointActor1, grab.componentJointActor0, 0 , 0 , 0 )

                        if grab.translationThreshold > 0 then
                            if grab.lastValues[grab.translationAxis] > grab.translationThreshold then
                                isClosed = true
                            end
                        else
                                if grab.lastValues[grab.translationAxis] < grab.translationThreshold then
                                    isClosed = true
                                end
                            end

                            table.insert(values, { name = string.format( "grab(trans - %s):" , getName(grab.componentJointActor0)), value = string.format( "offset: %.3f / %.3f | state: %s(t %d)" , grab.lastValues[grab.translationAxis], grab.translationThreshold, isClosed and "closed" or "open" , grab.closeTimer) } )
                        end

                        for toolIndex = 1 , #grab.movingTools do
                            local movingToolData = grab.movingTools[toolIndex]

                            local lastMovingDirection = math.sign(movingToolData.lastMoveValue)
                            local directionStr = lastMovingDirection = = movingToolData.closingDirection and "closing" or(lastMovingDirection = = 0 and "none" or "opening" )
                            local blockStr = (lastMovingDirection = = movingToolData.closingDirection and grab.closeTimer < BaleGrab.CLOSE_TIMER and next(spec.pendingDynamicMountObjects) ~ = nil ) and " BLOCKED" or ""

                            table.insert(values, { name = "movingTool:" , value = string.format( "%s | direction: %s%s" , getName(movingToolData.movingTool.node), directionStr, blockStr) } )
                        end
                    end

                    table.insert(values, { name = "--" , value = "--" } )

                    for object, numShapes in pairs(spec.pendingDynamicMountObjects) do
                        local rootNode = object.nodeId or object.rootNode
                        local state = spec.dynamicMountedObjects[object] = = nil and "<> Pending " or ">< Mounted "
                        table.insert(values, { name = state, value = string.format( "%s(id %d, numShapes %d)" , getName(rootNode), rootNode, numShapes) } )
                    end
                end
            end

```