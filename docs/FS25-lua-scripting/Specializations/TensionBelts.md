## TensionBelts

**Description**

> Class for vehicle which can dynamically mount objects (e.g. bales and pallets)

**Functions**

- [actionEventToggleTensionBelts](#actioneventtoggletensionbelts)
- [consoleCommandToggleTensionBeltDebugRendering](#consolecommandtoggletensionbeltdebugrendering)
- [createTensionBelt](#createtensionbelt)
- [freeTensionBeltObject](#freetensionbeltobject)
- [getAdditionalComponentMass](#getadditionalcomponentmass)
- [getCanBeSelected](#getcanbeselected)
- [getCanDischargeToGround](#getcandischargetoground)
- [getCanDischargeToObject](#getcandischargetoobject)
- [getFillLevelInformation](#getfilllevelinformation)
- [getHasObjectMounted](#gethasobjectmounted)
- [getIsDynamicallyMountedNode](#getisdynamicallymountednode)
- [getIsFoldAllowed](#getisfoldallowed)
- [getIsMovingToolActive](#getismovingtoolactive)
- [getIsPlayerInTensionBeltsRange](#getisplayerintensionbeltsrange)
- [getIsReadyForAutomatedTrainTravel](#getisreadyforautomatedtraintravel)
- [getObjectsToUnmount](#getobjectstounmount)
- [getObjectToMount](#getobjecttomount)
- [getTensionBeltObjectCanBeMounted](#gettensionbeltobjectcanbemounted)
- [initSpecialization](#initspecialization)
- [loadMovingToolFromXML](#loadmovingtoolfromxml)
- [lockTensionBeltObject](#locktensionbeltobject)
- [objectOverlapCallback](#objectoverlapcallback)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onPreDelete](#onpredelete)
- [onReadStream](#onreadstream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onTensionBeltTreeShapeCut](#ontensionbelttreeshapecut)
- [onUpdate](#onupdate)
- [onUpdateTick](#onupdatetick)
- [onWriteStream](#onwritestream)
- [prerequisitesPresent](#prerequisitespresent)
- [refreshTensionBelts](#refreshtensionbelts)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [removeTensionBelt](#removetensionbelt)
- [saveToXMLFile](#savetoxmlfile)
- [setAllTensionBeltsActive](#setalltensionbeltsactive)
- [setTensionBeltsActive](#settensionbeltsactive)
- [tensionBeltActivationTriggerCallback](#tensionbeltactivationtriggercallback)
- [updateFastenState](#updatefastenstate)

### actionEventToggleTensionBelts

**Description**

**Definition**

> actionEventToggleTensionBelts()

**Arguments**

| any | self          |
|-----|---------------|
| any | actionName    |
| any | inputValue    |
| any | callbackState |
| any | isAnalog      |

**Code**

```lua
function TensionBelts.actionEventToggleTensionBelts( self , actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_tensionBelts

    spec.fastenedAllBeltsIndex = 1
    spec.fastenedAllBeltsState = not spec.areAllBeltsFastened
end

```

### consoleCommandToggleTensionBeltDebugRendering

**Description**

**Definition**

> consoleCommandToggleTensionBeltDebugRendering()

**Arguments**

| any | unusedSelf |
|-----|------------|

**Code**

```lua
function TensionBelts.consoleCommandToggleTensionBeltDebugRendering(unusedSelf)
    TensionBelts.debugRendering = not TensionBelts.debugRendering
    return "TensionBeltsDebugRendering = " .. tostring( TensionBelts.debugRendering)
end

```

### createTensionBelt

**Description**

> Create tension belt

**Definition**

> createTensionBelt(table belt, boolean isDummy, table objects, boolean playSound)

**Arguments**

| table   | belt      | belt to use             |
|---------|-----------|-------------------------|
| boolean | isDummy   | create dummy belt       |
| table   | objects   | objects to fasten       |
| boolean | playSound | play sound (nil = true) |

**Code**

```lua
function TensionBelts:createTensionBelt(belt, isDummy, objects, playSound)
    local spec = self.spec_tensionBelts

    local tensionBelt = TensionBeltGeometryConstructor.new()

    local beltData = spec.beltData
    local width = spec.width or beltData.width

    tensionBelt:setWidth(width)
    tensionBelt:setMaxEdgeLength(spec.maxEdgeLength)
    if isDummy then
        tensionBelt:setMaterial(beltData.dummyMaterial.materialId)
        tensionBelt:setUVscale(beltData.dummyMaterial.uvScale)
    else
            tensionBelt:setMaterial(beltData.material.materialId)
            tensionBelt:setUVscale(beltData.material.uvScale)
        end

        local ratchetStart, ratchetEnd = 0 , 0
        if spec.ratchetPosition ~ = nil and beltData.ratchet ~ = nil then
            ratchetStart, ratchetEnd = spec.ratchetPosition, spec.ratchetPosition + beltData.ratchet.sizeRatio * width
            tensionBelt:addAttachment( 0 , spec.ratchetPosition, beltData.ratchet.sizeRatio * width)

        end

        local hookLength1, hookLength2 = 0 , 0
        if spec.useHooks and beltData.hook ~ = nil then
            hookLength1 = beltData.hook.sizeRatio * width
            tensionBelt:addAttachment( 0 , hookLength1, 0 )

            hookLength2 = (beltData.hook2 or beltData.hook).sizeRatio * width
            tensionBelt:addAttachment( 1 , - hookLength2, 0 )
        end

        tensionBelt:setFixedPoints(belt.startNode, belt.endNode)
        tensionBelt:setGeometryBias(spec.geometryBias)
        tensionBelt:setLinkNode(belt.linkNode or spec.linkNode)

        for _, pointNode in pairs(belt.intersectionNodes) do
            local x,y,z = getWorldTranslation(pointNode)
            local dirX, dirY, dirZ = localDirectionToWorld(pointNode, 1 , 0 , 0 )
            tensionBelt:addIntersectionPoint(x,y,z, dirX, dirY, dirZ)
        end

        for _, object in pairs(objects) do
            for _, node in pairs(object.visuals) do
                if getSplitType(node) ~ = 0 then
                    -- Allow a larger range of uvs for trees
                        tensionBelt:addShape(node, - 100 , 100 , - 100 , 100 )
                    else
                            tensionBelt:addShape(node, 0 , 10 , 0 , 10 )
                        end
                    end
                end

                local beltShape, _, beltLength = tensionBelt:finalize()
                if beltShape ~ = 0 then
                    if isDummy then
                        belt.dummy = beltShape
                    else
                            local currentIndex = 0
                            if spec.ratchetPosition ~ = nil and beltData.ratchet ~ = nil then
                                if getNumOfChildren(beltShape) > currentIndex then
                                    local scale = width
                                    local ratched = clone(beltData.ratchet.node, false , false , false )
                                    link(getChildAt(beltShape, 0 ), ratched)
                                    setTranslation(ratched, 0 , spec.geometryBias, 0 )
                                    setScale(ratched, scale, scale, scale)
                                    currentIndex = currentIndex + 1
                                end
                            end
                            if spec.useHooks then
                                if beltData.hook ~ = nil and getNumOfChildren(beltShape) > currentIndex + 1 then
                                    local scale = width
                                    local hookStart = clone(beltData.hook.node, false , false , false )
                                    link(getChildAt(beltShape, currentIndex), hookStart)

                                    local yOffset = spec.geometryBias * math.min(hookLength1 / spec.maxEdgeLength, 1 )
                                    setTranslation(hookStart, 0 , yOffset, 0 )

                                    local wx1, wy1, wz1 = getWorldTranslation(belt.startNode)
                                    local wx2, wy2, wz2 = getWorldTranslation(hookStart)
                                    local dx, dy, dz = worldDirectionToLocal(getParent(hookStart), wx1 - wx2, wy1 - wy2, wz1 - wz2)
                                    local upX, upY, upZ = localDirectionToLocal(hookStart, getParent(hookStart), 0 , 1 , 0 )
                                    setDirection(hookStart, dx, dy, dz, upX, upY, upZ)

                                    setScale(hookStart, scale, scale, scale)

                                    local hook2 = beltData.hook2 or beltData.hook
                                    local hookEnd = clone(hook2.node, false , false , false )
                                    link(getChildAt(beltShape, currentIndex + 1 ), hookEnd)

                                    yOffset = spec.geometryBias * math.min(hookLength2 / spec.maxEdgeLength, 1 )
                                    setTranslation(hookEnd, 0 , yOffset, 0 )

                                    wx1, wy1, wz1 = getWorldTranslation(belt.endNode)
                                    wx2, wy2, wz2 = getWorldTranslation(hookEnd)
                                    dx, dy, dz = worldDirectionToLocal(getParent(hookEnd), wx1 - wx2, wy1 - wy2, wz1 - wz2)
                                    upX, upY, upZ = localDirectionToLocal(hookEnd, getParent(hookEnd), 0 , 1 , 0 )
                                    setDirection(hookEnd, dx, dy, dz, upX, upY, upZ)

                                    setScale(hookEnd, scale, scale, scale)
                                end
                            end

                            setShaderParameter(beltShape, "beltClipOffsets" , hookLength1, ratchetStart, ratchetEnd, beltLength - hookLength2, false )

                            belt.mesh = beltShape
                            spec.belts[beltShape] = beltShape
                            if belt.dummy ~ = nil then
                                delete(belt.dummy)
                                belt.dummy = nil
                            end

                            if playSound ~ = false and self.isClient then
                                g_soundManager:playSample(spec.samples.toggleBelt)
                                g_soundManager:playSample(spec.samples.addBelt)
                            end
                        end

                        return beltShape
                    end

                    return nil
                end

```

### freeTensionBeltObject

**Description**

**Definition**

> freeTensionBeltObject()

**Arguments**

| any | objectId            |
|-----|---------------------|
| any | objectsToJointTable |
| any | isDynamic           |
| any | object              |

**Code**

```lua
function TensionBelts:freeTensionBeltObject(objectId, objectsToJointTable, isDynamic, object)
    if entityExists(objectId) then
        local jointData = objectsToJointTable[objectId]
        if jointData.jointIndex ~ = nil then
            if self.isServer then
                if jointData ~ = nil then
                    removeJoint(jointData.jointIndex)
                    delete(jointData.jointTransform)

                    if getSplitType(objectId) ~ = 0 then
                        setInertiaScale(objectId, 1 , 1 , 1 )
                    end

                    if jointData.objectMass ~ = nil then
                        setMass(objectId, jointData.objectMass)
                        self:setMassDirty()
                    end

                    if object ~ = nil then
                        if object.setReducedComponentMass ~ = nil then
                            object:setReducedComponentMass( false )
                            self:setMassDirty()
                        end
                        if object.setCanBeSold ~ = nil then
                            object:setCanBeSold( true )
                        end
                        if object.setDynamicMountType ~ = nil then
                            object:setDynamicMountType( MountableObject.MOUNT_TYPE_NONE, nil )
                        end
                    end
                end
            end
        else
                local parentNode
                if jointData ~ = nil then
                    parentNode = jointData.parent
                end
                if parentNode ~ = nil and not entityExists(parentNode) then
                    -- For some reason the original parent node was deleted.Delete the attached node too
                    delete(objectId)
                else
                        if parentNode = = nil then
                            parentNode = getRootNode()
                        end
                        local x, y, z = getWorldTranslation(objectId)
                        local rx, ry, rz = getWorldRotation(objectId)

                        if object ~ = nil and object.unmountKinematic ~ = nil then
                            object:unmountKinematic()
                        else
                                -- only for split shapes on server side
                                    if self.isServer then
                                        link(parentNode, objectId)
                                        setWorldTranslation(objectId, x, y, z)
                                        setWorldRotation(objectId, rx, ry, rz)
                                        setRigidBodyType(objectId, RigidBodyType.DYNAMIC)
                                    end
                                end
                            end
                        end

                        if getSplitType(objectId) ~ = 0 then
                            setUserAttribute(objectId, "isTensionBeltMounted" , UserAttributeType.BOOLEAN, false )
                        end
                    end

                    -- remove objectId from object list
                    objectsToJointTable[objectId] = nil
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
function TensionBelts:getAdditionalComponentMass(superFunc, component)
    local additionalMass = superFunc( self , component)

    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts then
        if spec.jointComponent = = component.node then
            for _, objectData in pairs(spec.objectsToJoint) do
                local object = objectData.object
                if object ~ = nil then
                    if object.getAllowComponentMassReduction ~ = nil and object:getAllowComponentMassReduction() then
                        additionalMass = additionalMass + math.max((object:getDefaultMass() - 0.1 ), 0 )
                    end
                end

                if objectData.objectMass ~ = nil then
                    additionalMass = additionalMass + (objectData.objectMass - 0.01 )
                end
            end
        end
    end

    return additionalMass
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
function TensionBelts:getCanBeSelected(superFunc)
    return true
end

```

### getCanDischargeToGround

**Description**

**Definition**

> getCanDischargeToGround()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function TensionBelts:getCanDischargeToGround(superFunc, dischargeNode)
    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts and not spec.allowDischargeWhileFasten then
        if spec.areAllBeltsFastened then
            return false
        end
    end

    return superFunc( self , dischargeNode)
end

```

### getCanDischargeToObject

**Description**

**Definition**

> getCanDischargeToObject()

**Arguments**

| any | superFunc     |
|-----|---------------|
| any | dischargeNode |

**Code**

```lua
function TensionBelts:getCanDischargeToObject(superFunc, dischargeNode)
    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts and not spec.allowDischargeWhileFasten then
        if spec.areAllBeltsFastened then
            return false
        end
    end

    return superFunc( self , dischargeNode)
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
function TensionBelts:getFillLevelInformation(superFunc, display)
    superFunc( self , display)

    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts then
        for _, objectData in pairs(spec.objectsToJoint) do
            local object = objectData.object
            if object ~ = nil then
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
function TensionBelts:getHasObjectMounted(superFunc, object)
    if superFunc( self , object) then
        return true
    end

    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts then
        for _, objectData in pairs(spec.objectsToJoint) do
            if objectData.object ~ = nil then
                if objectData.object = = object then
                    return true
                end

                if objectData.object.getHasObjectMounted ~ = nil then
                    if objectData.object:getHasObjectMounted(object) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

```

### getIsDynamicallyMountedNode

**Description**

**Definition**

> getIsDynamicallyMountedNode()

**Arguments**

| any | node |
|-----|------|

**Code**

```lua
function TensionBelts:getIsDynamicallyMountedNode(node)
    local spec = self.spec_tensionBelts

    if spec.objectsToJoint ~ = nil then
        for object,_ in pairs(spec.objectsToJoint) do
            if object = = node then
                return true
            end
        end
    end

    return false
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
function TensionBelts:getIsFoldAllowed(superFunc, direction, onAiTurnOn)
    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts and not spec.allowFoldingWhileFasten then
        if not((direction or 1 ) < 0 or not spec.areAllBeltsFastened) then
            return false , spec.texts.warningFoldingTensionBelts
        end
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
function TensionBelts:getIsMovingToolActive(superFunc, movingTool)
    if not movingTool.tensionBeltsAllowedMounted then
        local spec = self.spec_tensionBelts
        if spec.hasTensionBelts and spec.areAllBeltsFastened then
            return false
        end
    end

    return superFunc( self , movingTool)
end

```

### getIsPlayerInTensionBeltsRange

**Description**

> Returns if player is in tension belt range

**Definition**

> getIsPlayerInTensionBeltsRange()

**Return Values**

| any | inRange | player is in range |
|-----|---------|--------------------|
| any | belt    | nearest belt       |

**Code**

```lua
function TensionBelts:getIsPlayerInTensionBeltsRange()

    if g_localPlayer = = nil then
        return false , nil
    end

    if not g_currentMission.accessHandler:canPlayerAccess( self ) then
        return false , nil
    end

    local spec = self.spec_tensionBelts

    if spec.beltData ~ = nil then
        local px, py, pz = getWorldTranslation(g_localPlayer.rootNode)
        local vx, vy, vz = localToWorld(spec.interactionBaseNode, spec.interactionBasePointX, 0 , spec.interactionBasePointZ)
        local currentBelt = nil
        local distance = math.huge

        if MathUtil.vector3Length(px - vx, py - vy, pz - vz) < spec.totalInteractionRadius then
            if spec.tensionBelts ~ = nil then
                for _, belt in pairs(spec.singleBelts) do
                    local sx, _, sz = getWorldTranslation(belt.startNode)
                    local ex, _, ez = getWorldTranslation(belt.endNode)
                    local sDistance = MathUtil.vector2Length(px - sx, pz - sz)
                    local eDistance = MathUtil.vector2Length(px - ex, pz - ez)
                    if (sDistance < distance and sDistance < spec.interactionRadius) or(eDistance < distance and eDistance < spec.interactionRadius) then
                        currentBelt = belt
                        distance = math.min(sDistance, eDistance)
                    end
                end
            end

            if distance < spec.interactionRadius then
                return true , currentBelt
            end
        end
    end

    return false , nil
end

```

### getIsReadyForAutomatedTrainTravel

**Description**

**Definition**

> getIsReadyForAutomatedTrainTravel()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function TensionBelts:getIsReadyForAutomatedTrainTravel(superFunc)
    local spec = self.spec_tensionBelts
    if spec.hasTensionBelts and spec.numObjectsIntensionBeltRange > 0 then
        return false
    end

    return superFunc( self )
end

```

### getObjectsToUnmount

**Description**

> Returns objects to unmount if given belt will be removed

**Definition**

> getObjectsToUnmount(table belt)

**Arguments**

| table | belt | belt to check |
|-------|------|---------------|

**Return Values**

| table | objectIdsToUnmount | table with object ids to unmount |
|-------|--------------------|----------------------------------|
| table | numObjects         | number of objects to unmount     |

**Code**

```lua
function TensionBelts:getObjectsToUnmount(belt)
    local spec = self.spec_tensionBelts

    local objectIdsToUnmount = { }
    local numObjects = 0
    -- copy mounted objects table
    for objectId, data in pairs(spec.objectsToJoint) do
        objectIdsToUnmount[objectId] = { objectId = objectId, object = data.object }
        numObjects = numObjects + 1
    end

    -- remove objects mounted by other active belts
    for _, otherBelt in pairs(spec.singleBelts) do
        if otherBelt.mesh ~ = nil and otherBelt ~ = belt then
            local objectToMount,_ = self:getObjectToMount(otherBelt)
            for _, object in pairs(objectToMount) do
                -- remove objects mounted by other belts
                if objectIdsToUnmount[object.physics] ~ = nil then
                    objectIdsToUnmount[object.physics] = nil
                    numObjects = numObjects - 1
                end
            end
        end
    end

    return objectIdsToUnmount, numObjects
end

```

### getObjectToMount

**Description**

> Returns objects in belt range

**Definition**

> getObjectToMount(table belt)

**Arguments**

| table | belt | belt to check |
|-------|------|---------------|

**Return Values**

| table | objectsInTensionBeltRange    | object in belt range            |
|-------|------------------------------|---------------------------------|
| table | numObjectsIntensionBeltRange | number of objects in belt range |

**Code**

```lua
function TensionBelts:getObjectToMount(belt)
    local spec = self.spec_tensionBelts

    local markerStart = spec.startNode
    local markerEnd = spec.endNode
    local offsetLeft = nil
    local offsetRight = nil
    local offset = nil
    local height = nil
    if belt ~ = nil then
        markerStart = belt.startNode
        markerEnd = belt.endNode

        offsetLeft = belt.offsetLeft
        offsetRight = belt.offsetRight
        offset = belt.offset
        height = belt.height
        if offsetLeft = = nil then
            if spec.sortedBelts[belt.id - 1 ] ~ = nil and spec.sortedBelts[belt.id - 1 ].mesh ~ = nil then
                local x,_,_ = localToLocal(markerStart, spec.sortedBelts[belt.id - 1 ].startNode, 0 , 0 , 0 )
                offsetLeft = math.abs(x)
            end
        end
        if offsetRight = = nil then
            if spec.sortedBelts[belt.id + 1 ] ~ = nil and spec.sortedBelts[belt.id + 1 ].mesh ~ = nil then
                local x,_,_ = localToLocal(markerStart, spec.sortedBelts[belt.id + 1 ].startNode, 0 , 0 , 0 )
                offsetRight = math.abs(x)
            end
        end

    end

    if offsetLeft = = nil then
        offsetLeft = spec.defaultOffsetSide
    end
    if offsetRight = = nil then
        offsetRight = spec.defaultOffsetSide
    end
    if offset = = nil then
        offset = spec.defaultOffset
    end
    if height = = nil then
        height = spec.defaultHeight
    end

    local sizeX = (offsetLeft + offsetRight) * 0.5
    local sizeY = height * 0.5
    local _, _, width = localToLocal(markerEnd, markerStart, 0 , 0 , 0 )
    local sizeZ = width * 0.5 - 2 * offset

    local centerX = (offsetLeft - offsetRight) * 0.5
    local centerY = height * 0.5
    local centerZ = width * 0.5
    local x,y,z = localToWorld(markerStart, centerX, centerY, centerZ)

    if TensionBelts.debugRendering then
        local box = { }
        box.points = { }
        local colorR = math.random( 0 , 1 )
        local colorG = math.random( 0 , 1 )
        local colorB = math.random( 0 , 1 )
        box.color = { colorR,colorG,colorB }

        local blx, bly, blz = localToWorld(markerStart, centerX - sizeX, centerY - sizeY, centerZ - sizeZ)
        local brx, bry, brz = localToWorld(markerStart, centerX + sizeX, centerY - sizeY, centerZ - sizeZ)
        local flx, fly, flz = localToWorld(markerStart, centerX - sizeX, centerY - sizeY, centerZ + sizeZ)
        local frx, fry, frz = localToWorld(markerStart, centerX + sizeX, centerY - sizeY, centerZ + sizeZ)

        local tblx, tbly, tblz = localToWorld(markerStart, centerX - sizeX, centerY + sizeY, centerZ - sizeZ)
        local tbrx, tbry, tbrz = localToWorld(markerStart, centerX + sizeX, centerY + sizeY, centerZ - sizeZ)
        local tflx, tfly, tflz = localToWorld(markerStart, centerX - sizeX, centerY + sizeY, centerZ + sizeZ)
        local tfrx, tfry, tfrz = localToWorld(markerStart, centerX + sizeX, centerY + sizeY, centerZ + sizeZ)

        table.insert(box.points, { blx, bly, blz } ) -- lower:lb
        table.insert(box.points, { brx, bry, brz } ) -- rb
        table.insert(box.points, { frx, fry, frz } ) -- rf
        table.insert(box.points, { flx, fly, flz } ) -- lf

        table.insert(box.points, { tblx, tbly, tblz } ) -- upper:lb
        table.insert(box.points, { tbrx, tbry, tbrz } ) -- rb
        table.insert(box.points, { tfrx, tfry, tfrz } ) -- rf
        table.insert(box.points, { tflx, tfly, tflz } ) -- lf
        table.insert(box.points, { x, y, z } ) -- center

        spec.checkBoxes[markerStart] = box
    end

    local rx,ry,rz = getWorldRotation(markerStart)
    table.clear(spec.objectsInTensionBeltRange)
    spec.numObjectsIntensionBeltRange = 0

    overlapBox(x, y, z, rx, ry, rz, sizeX, sizeY, sizeZ, "objectOverlapCallback" , self , CollisionFlag.DYNAMIC_OBJECT + CollisionFlag.VEHICLE + CollisionFlag.TREE, true , true , false , true )

    return spec.objectsInTensionBeltRange, spec.numObjectsIntensionBeltRange
end

```

### getTensionBeltObjectCanBeMounted

**Description**

> Returns if the given object can be mounted via tension belts

**Definition**

> getTensionBeltObjectCanBeMounted()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function TensionBelts:getTensionBeltObjectCanBeMounted(object)
    if object = = self then
        return false
    end

    if object.rootVehicle = = self.rootVehicle then
        return false
    end

    if object.getSupportsTensionBelts = = nil or not object:getSupportsTensionBelts() then
        return false
    end

    if object.getMeshNodes = = nil then
        return false
    end

    if object.dynamicMountObject ~ = nil then
        return false
    end

    local hasObjectMounted = false
    local spec = self.spec_tensionBelts
    for _, objectData in pairs(spec.objectsToJoint) do
        if objectData.object ~ = nil then
            if objectData.object = = object then
                hasObjectMounted = true
            end
        end
    end

    -- we still return true if we got the object mounted to ourselfs already
        -- this is required when we remount the object while updating the tension belt states
            if not hasObjectMounted then
                -- if we are already somehow mounted to the given object, we block the mounting(otherwise we create a endless loop)
                    if object.rootVehicle ~ = nil then
                        if object.rootVehicle:getHasObjectMounted( self ) then
                            return false
                        end
                    end

                    if self.rootVehicle:getHasObjectMounted(object) then
                        return false
                    end
                end

                return true
            end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function TensionBelts.initSpecialization()
    g_vehicleConfigurationManager:addConfigurationType( "tensionBelts" , g_i18n:getText( "configuration_tensionBelts" ), "tensionBelts" , VehicleConfigurationItem )

    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "TensionBelts" )

    local key = "vehicle.tensionBelts.tensionBeltsConfigurations.tensionBeltsConfiguration(?).tensionBelts"

    schema:register(XMLValueType.FLOAT, key .. "#totalInteractionRadius" , "Total interaction radius" , 6 )
    schema:register(XMLValueType.FLOAT, key .. "#interactionRadius" , "Interaction radius" , 1 )
    schema:register(XMLValueType.NODE_INDEX, key .. "#interactionBaseNode" , "Interaction base node" , "Vehicle root node" )
    schema:register(XMLValueType.NODE_INDEX, key .. "#activationTrigger" , "Activation trigger" )
    schema:register(XMLValueType.STRING, key .. "#tensionBeltType" , "Supports tension belts" , "basic" )

    schema:register(XMLValueType.FLOAT, key .. "#width" , "Belt width" , "Used from belt definitions" )
    schema:register(XMLValueType.FLOAT, key .. "#ratchetPosition" , "Ratchet position" )
    schema:register(XMLValueType.BOOL, key .. "#useHooks" , "Use hooks" , true )
    schema:register(XMLValueType.FLOAT, key .. "#maxEdgeLength" , "Max.edge length" , 0.1 )
    schema:register(XMLValueType.FLOAT, key .. "#geometryBias" , "Geometry bias" , 0.01 )
    schema:register(XMLValueType.FLOAT, key .. "#defaultOffsetSide" , "Default offset side" , 0.1 )
    schema:register(XMLValueType.FLOAT, key .. "#defaultOffset" , "Default offset" , 0 )
    schema:register(XMLValueType.FLOAT, key .. "#defaultHeight" , "Default height" , 5 )

    schema:register(XMLValueType.BOOL, key .. "#allowFoldingWhileFasten" , "Folding is allowed while tension belts are fasten" , true )
        schema:register(XMLValueType.BOOL, key .. "#allowDischargeWhileFasten" , "Discharging is allowed while tension belts are fasten" , true )

            schema:register(XMLValueType.NODE_INDEX, key .. "#linkNode" , "Link node" )
            schema:register(XMLValueType.NODE_INDEX, key .. "#rootNode" , "Root node" , "Root component" )
            schema:register(XMLValueType.NODE_INDEX, key .. "#jointNode" , "Joint node" , "rootNode" )

            schema:register(XMLValueType.NODE_INDEX, key .. ".tensionBelt(?)#startNode" , "Start node" )
            schema:register(XMLValueType.NODE_INDEX, key .. ".tensionBelt(?)#endNode" , "End node" )
            schema:register(XMLValueType.FLOAT, key .. ".tensionBelt(?)#offsetLeft" , "Offset left" )
            schema:register(XMLValueType.FLOAT, key .. ".tensionBelt(?)#offsetRight" , "Offset right" )
            schema:register(XMLValueType.FLOAT, key .. ".tensionBelt(?)#offset" , "Offset" )
            schema:register(XMLValueType.FLOAT, key .. ".tensionBelt(?)#height" , "Height" )
            schema:register(XMLValueType.NODE_INDEX, key .. ".tensionBelt(?)#linkNode" , "Custom link node for visual tension belts" )
                schema:register(XMLValueType.NODE_INDEX, key .. ".tensionBelt(?)#jointNode" , "Custom joint node for to mount the objects to" )
                    schema:register(XMLValueType.NODE_INDEX, key .. ".tensionBelt(?).intersectionNode(?)#node" , "Intersection node" )

                    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, key .. ".tensionBelt(?)" )

                    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "toggleBelt" )
                    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "addBelt" )
                    SoundManager.registerSampleXMLPaths(schema, key .. ".sounds" , "removeBelt" )

                    schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
                        cSchema:register(XMLValueType.BOOL, cKey .. ".tensionBelts#allowedMounted" , "Allow moving tool movement while something is mounted" , true )
                        end )

                        schema:setXMLSpecializationType()

                        local schemaSavegame = Vehicle.xmlSchemaSavegame
                        schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?).tensionBelts.belt(?)#isActive" , "Belt is active" , false )
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
function TensionBelts:loadMovingToolFromXML(superFunc, xmlFile, key, entry)
    if not superFunc( self , xmlFile, key, entry) then
        return false
    end

    entry.tensionBeltsAllowedMounted = xmlFile:getValue(key .. ".tensionBelts#allowedMounted" , true )

    return true
end

```

### lockTensionBeltObject

**Description**

**Definition**

> lockTensionBeltObject()

**Arguments**

| any | objectId            |
|-----|---------------------|
| any | objectsToJointTable |
| any | isDynamic           |
| any | jointNode           |
| any | object              |

**Code**

```lua
function TensionBelts:lockTensionBeltObject(objectId, objectsToJointTable, isDynamic, jointNode, object)
    if objectsToJointTable[objectId] = = nil then
        local useDynamicMount = false
        local useKinematicMount = false
        local useSplitShapeMount = false

        if not isDynamic and getSplitType(objectId) ~ = 0 then
            useSplitShapeMount = true -- mount the trees on the train kinematically
        else
                useDynamicMount = true -- everything else is mounted dynamically(server only)
                end

                if useDynamicMount then
                    if self.isServer then
                        local constr = JointConstructor.new()
                        constr:setActors(jointNode, objectId)

                        -- create joint at center of mass to avoid jittering(e.g.tree trunks pivots are not at center of mass position)
                        -- create a transformGroup at the joint position to move the joint afterwards based on this transformGroup
                        local jointTransform = createTransformGroup( "tensionBeltJoint" )
                        link(jointNode, jointTransform)
                        local x,y,z = localToWorld(objectId, getCenterOfMass(objectId))
                        setWorldTranslation(jointTransform, x,y,z)

                        constr:setJointTransforms(jointTransform, jointTransform)
                        constr:setEnableCollision( true )

                        constr:setRotationLimit( 0 , 0 , 0 )
                        constr:setRotationLimit( 1 , 0 , 0 )
                        constr:setRotationLimit( 2 , 0 , 0 )

                        local springForce = 1000
                        local springDamping = 10
                        constr:setRotationLimitSpring(springForce, springDamping, springForce, springDamping, springForce, springDamping)
                        constr:setTranslationLimitSpring(springForce, springDamping, springForce, springDamping, springForce, springDamping)
                        local jointIndex = constr:finalize()

                        local objectMass
                        if object ~ = nil then
                            if object.setReducedComponentMass ~ = nil then
                                if object:getAllowComponentMassReduction() then
                                    object:setReducedComponentMass( true )
                                    self:setMassDirty()
                                end
                            end
                            if object.setCanBeSold ~ = nil then
                                object:setCanBeSold( false )
                            end
                            if object.setDynamicMountType ~ = nil then
                                object:setDynamicMountType( MountableObject.MOUNT_TYPE_DYNAMIC, self )
                            end
                        else
                                -- reduce mass of split shapes as well
                                objectMass = getMass(objectId)
                                if objectMass > 0.01 then
                                    setMass(objectId, 0.01 )
                                    self:setMassDirty()
                                else
                                        objectMass = nil
                                    end
                                end

                                if getSplitType(objectId) ~ = 0 then
                                    setInertiaScale(objectId, 20 , 20 , 20 )
                                end

                                objectsToJointTable[objectId] = { jointIndex = jointIndex, jointTransform = jointTransform, object = object, objectMass = objectMass }
                            else
                                    objectsToJointTable[objectId] = { jointIndex = 0 , object = object }
                                end
                            elseif useKinematicMount then
                                    local parentNode = getParent(objectId)
                                    local x, y, z = localToLocal(objectId, jointNode, 0 , 0 , 0 )
                                    local rx, ry, rz = localRotationToLocal(objectId, jointNode, 0 , 0 , 0 )

                                    object:mountKinematic( self , jointNode, x, y, z, rx, ry, rz)

                                    objectsToJointTable[objectId] = { parent = parentNode, object = object }
                                elseif useSplitShapeMount then
                                        if self.isServer then
                                            local parentNode = getParent(objectId)
                                            local x, y, z = localToLocal(objectId, jointNode, 0 , 0 , 0 )
                                            local rx, ry, rz = localRotationToLocal(objectId, jointNode, 0 , 0 , 0 )

                                            setRigidBodyType(objectId, RigidBodyType.KINEMATIC)
                                            link(jointNode, objectId)
                                            setTranslation(objectId, x, y, z)
                                            setRotation(objectId, rx, ry, rz)
                                            objectsToJointTable[objectId] = { parent = parentNode, object = object }
                                        end
                                    end

                                    if getSplitType(objectId) ~ = 0 then
                                        setUserAttribute(objectId, "isTensionBeltMounted" , UserAttributeType.BOOLEAN, true )
                                        g_messageCenter:publish(MessageType.TREE_SHAPE_MOUNTED, objectId, self )
                                    end
                                end
                            end

```

### objectOverlapCallback

**Description**

> Overlap callback

**Definition**

> objectOverlapCallback(integer transformId)

**Arguments**

| integer | transformId | id of found transform |
|---------|-------------|-----------------------|

**Code**

```lua
function TensionBelts:objectOverlapCallback(transformId)
    if transformId ~ = 0 and getHasClassId(transformId, ClassIds.SHAPE) then
        local spec = self.spec_tensionBelts

        local object = g_currentMission:getNodeObject(transformId)
        if object ~ = nil then
            if self:getTensionBeltObjectCanBeMounted(object) then
                local nodeId = object:getTensionBeltNodeId()
                if spec.objectsInTensionBeltRange[nodeId] = = nil then
                    local nodes = object:getMeshNodes()
                    if nodes ~ = nil then
                        spec.objectsInTensionBeltRange[nodeId] = { physics = nodeId, visuals = nodes, object = object } -- TODO:avoid table creation
                        spec.numObjectsIntensionBeltRange = spec.numObjectsIntensionBeltRange + 1
                    end
                end
            end
        elseif getSplitType(transformId) ~ = 0 then
                local rigidBodyType = getRigidBodyType(transformId)
                if (rigidBodyType = = RigidBodyType.DYNAMIC or rigidBodyType = = RigidBodyType.KINEMATIC) and spec.objectsInTensionBeltRange[transformId] = = nil then
                    spec.objectsInTensionBeltRange[transformId] = { physics = transformId, visuals = { transformId } }
                    spec.numObjectsIntensionBeltRange = spec.numObjectsIntensionBeltRange + 1
                end
            end
        end

        return true
    end

```

### onDelete

**Description**

> Called on deleting

**Definition**

> onDelete()

**Code**

```lua
function TensionBelts:onDelete()
    local spec = self.spec_tensionBelts

    spec.isPlayerInRange = false
    g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
    self:setTensionBeltsActive( false , nil , true , false )

    if spec.activationTrigger ~ = nil then
        removeTrigger(spec.activationTrigger)
        spec.activationTrigger = nil
    end

    g_soundManager:deleteSamples(spec.samples)
end

```

### onDraw

**Description**

> Called on draw

**Definition**

> onDraw(boolean isActiveForInput, boolean isSelected, )

**Arguments**

| boolean | isActiveForInput | true if vehicle is active for input |
|---------|------------------|-------------------------------------|
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function TensionBelts:onDraw(isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_tensionBelts

    if not spec.hasTensionBelts then
        return
    end

    if isActiveForInputIgnoreSelection and isSelected then
        if spec.areAllBeltsFastened then
            g_inputBinding:setActionEventText( self.toggleTensionBeltActionEvent, g_i18n:getText( "action_unfastenTensionBelts" ))
        else
                g_inputBinding:setActionEventText( self.toggleTensionBeltActionEvent, g_i18n:getText( "action_fastenTensionBelts" ))
            end
        end

        -- for _, d in pairs(spec.objectsToJoint) do
            -- local node = d.jointTransform
            -- DebugGizmo.renderAtNode(node, getName(node))
            -- end
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
function TensionBelts:onLoad(savegame)
    local spec = self.spec_tensionBelts

    local tensionBeltConfigurationId = Utils.getNoNil( self.configurations[ "tensionBelts" ], 1 )
    local configKey = string.format( "vehicle.tensionBelts.tensionBeltsConfigurations.tensionBeltsConfiguration(%d).tensionBelts" , tensionBeltConfigurationId - 1 )

    spec.hasTensionBelts = true
    if not self.xmlFile:hasProperty(configKey) then
        spec.hasTensionBelts = false

        SpecializationUtil.removeEventListener( self , "onPostLoad" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onDelete" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onPreDelete" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onReadStream" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onWriteStream" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onUpdate" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onUpdateTick" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onDraw" , TensionBelts )
        SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , TensionBelts )

        return
    end

    spec.belts = { }
    spec.tensionBelts = { }
    spec.singleBelts = { }
    spec.sortedBelts = { }

    spec.activatable = TensionBeltsActivatable.new( self )

    spec.totalInteractionRadius = self.xmlFile:getValue(configKey .. "#totalInteractionRadius" , 6 )
    spec.interactionRadius = self.xmlFile:getValue(configKey .. "#interactionRadius" , 1 )
    spec.interactionBaseNode = self.xmlFile:getValue(configKey .. "#interactionBaseNode" , self.rootNode, self.components, self.i3dMappings)
    local activationTrigger = self.xmlFile:getValue(configKey .. "#activationTrigger" , nil , self.components, self.i3dMappings)
    if activationTrigger ~ = nil then
        if getCollisionFilterGroup(activationTrigger) = = CollisionFlag.TRIGGER then
            if getCollisionFilterMask(activationTrigger) = = CollisionFlag.PLAYER then
                addTrigger(activationTrigger, "tensionBeltActivationTriggerCallback" , self )
                spec.activationTrigger = activationTrigger
            else
                    Logging.xmlError( self.xmlFile, "Wrong collision filter mask for tension belt activation trigger '%s'.Should only have %s" , getName(activationTrigger), CollisionFlag.getBitAndName(CollisionFlag.PLAYER))
                    end
                else
                        Logging.xmlError( self.xmlFile, "Wrong collision filter group set for tension belt activation trigger '%s'.Should only have %s" , getName(activationTrigger), CollisionFlag.getBitAndName(CollisionFlag.TRIGGER))
                        end
                    end

                    spec.allowFoldingWhileFasten = self.xmlFile:getValue(configKey .. "#allowFoldingWhileFasten" , true )
                    spec.allowDischargeWhileFasten = self.xmlFile:getValue(configKey .. "#allowDischargeWhileFasten" , true )

                    spec.isPlayerInTrigger = false
                    spec.checkSizeOffsets = { 0 * 0.5 , 5 * 0.5 , 3 * 0.5 }
                    spec.objectsInTensionBeltRange = { }
                    spec.numObjectsIntensionBeltRange = 0

                    local tensionBeltType = self.xmlFile:getValue(configKey .. "#tensionBeltType" , "basic" )
                    local beltData = g_tensionBeltManager:getBeltData(tensionBeltType)

                    if beltData ~ = nil then
                        spec.width = self.xmlFile:getValue(configKey .. "#width" )
                        spec.ratchetPosition = self.xmlFile:getValue(configKey .. "#ratchetPosition" )
                        spec.useHooks = self.xmlFile:getValue(configKey .. "#useHooks" , true )
                        spec.maxEdgeLength = self.xmlFile:getValue(configKey .. "#maxEdgeLength" , 0.1 )
                        spec.geometryBias = self.xmlFile:getValue(configKey .. "#geometryBias" , 0.01 )
                        spec.defaultOffsetSide = self.xmlFile:getValue(configKey .. "#defaultOffsetSide" , 0.1 )
                        spec.defaultOffset = self.xmlFile:getValue(configKey .. "#defaultOffset" , 0 )
                        spec.defaultHeight = self.xmlFile:getValue(configKey .. "#defaultHeight" , 5 )
                        spec.beltData = beltData
                        spec.linkNode = self.xmlFile:getValue(configKey .. "#linkNode" , nil , self.components, self.i3dMappings)
                        spec.rootNode = self.xmlFile:getValue(configKey .. "#rootNode" , self.components[ 1 ].node, self.components, self.i3dMappings)
                        spec.jointNode = self.xmlFile:getValue(configKey .. "#jointNode" , spec.rootNode, self.components, self.i3dMappings)
                        spec.checkTimerDuration = 500
                        spec.checkTimer = spec.checkTimerDuration

                        if spec.linkNode = = nil then
                            Logging.xmlError( self.xmlFile, "No tension belts link node given at %s%s" , configKey, "#linkNode" )
                            self:setLoadingState(VehicleLoadingState.ERROR)
                            return
                        end

                        if getRigidBodyType(spec.jointNode) ~ = RigidBodyType.DYNAMIC and getRigidBodyType(spec.jointNode) ~ = RigidBodyType.KINEMATIC then
                            Logging.xmlError( self.xmlFile, "Given jointNode '" .. getName(spec.jointNode) .. "' has invalid rigidBodyType.Have to be 'Dynamic' or 'Kinematic'! Using '" .. getName( self.components[ 1 ].node) .. "' instead!" )
                            spec.jointNode = self.components[ 1 ].node
                        end

                        local rigidBodyType = getRigidBodyType(spec.jointNode)
                        spec.isDynamic = rigidBodyType = = RigidBodyType.DYNAMIC

                        local x,y,z = localToLocal(spec.linkNode, spec.jointNode, 0 , 0 , 0 )
                        local rx,ry,rz = localRotationToLocal(spec.linkNode, spec.jointNode, 0 , 0 , 0 )
                        spec.linkNodePosition = { x, y, z }
                        spec.linkNodeRotation = { rx, ry, rz }

                        spec.jointComponent = self:getParentComponent(spec.jointNode)

                        local i = 0
                        while true do
                            local key = string.format(configKey .. ".tensionBelt(%d)" , i)
                            if not self.xmlFile:hasProperty(key) then
                                break
                            end

                            if #spec.sortedBelts = = 2 ^ TensionBelts.NUM_SEND_BITS then
                                Logging.xmlWarning( self.xmlFile, "Max number of tension belts is " .. 2 ^ TensionBelts.NUM_SEND_BITS .. "!" )
                                break
                            end

                            local startNode = self.xmlFile:getValue(key .. "#startNode" , nil , self.components, self.i3dMappings)
                            local endNode = self.xmlFile:getValue(key .. "#endNode" , nil , self.components, self.i3dMappings)
                            if startNode ~ = nil and endNode ~ = nil then
                                local endX,endY,_ = getTranslation(endNode)
                                if math.abs(endX) < 0.0001 and math.abs(endY) < 0.0001 then
                                    if spec.linkNode = = nil then
                                        spec.linkNode = getParent(startNode)
                                    end
                                    if spec.startNode = = nil then
                                        spec.startNode = startNode
                                    end
                                    spec.endNode = endNode

                                    local offsetLeft = self.xmlFile:getValue(key .. "#offsetLeft" )
                                    local offsetRight = self.xmlFile:getValue(key .. "#offsetRight" )
                                    local offset = self.xmlFile:getValue(key .. "#offset" )
                                    local height = self.xmlFile:getValue(key .. "#height" )

                                    local intersectionNodes = { }
                                    local j = 0
                                    while true do
                                        local intersectionKey = string.format(key .. ".intersectionNode(%d)" , j)
                                        if not self.xmlFile:hasProperty(intersectionKey) then
                                            break
                                        end
                                        local node = self.xmlFile:getValue(intersectionKey .. "#node" , nil , self.components, self.i3dMappings)
                                        if node ~ = nil then
                                            table.insert(intersectionNodes, node)
                                        end
                                        j = j + 1
                                    end

                                    local linkNode = self.xmlFile:getValue(key .. "#linkNode" , nil , self.components, self.i3dMappings)
                                    local jointNode = self.xmlFile:getValue(key .. "#jointNode" , nil , self.components, self.i3dMappings)

                                    local changeObjects = { }
                                    ObjectChangeUtil.loadObjectChangeFromXML( self.xmlFile, key, changeObjects, self.components, self )
                                    ObjectChangeUtil.setObjectChanges(changeObjects, false , self , self.setMovingToolDirty)

                                    local belt = { id = i + 1 , startNode = startNode, endNode = endNode, offsetLeft = offsetLeft, offsetRight = offsetRight, offset = offset, height = height, mesh = nil , intersectionNodes = intersectionNodes, changeObjects = changeObjects, linkNode = linkNode, jointNode = jointNode, dummy = nil , objectsToMount = nil }
                                    spec.singleBelts[belt] = belt
                                    table.insert(spec.sortedBelts, belt)
                                else
                                        Logging.xmlWarning( self.xmlFile, "x and y position of endNode need to be 0 for tension belt '" .. key .. "'" )
                                        end
                                    end

                                    i = i + 1
                                end

                                local minX, minZ = math.huge, math.huge
                                local maxX, maxZ = - math.huge, - math.huge
                                for _, belt in pairs(spec.singleBelts) do
                                    local sx,_,sz = localToLocal(belt.startNode, spec.interactionBaseNode, 0 , 0 , 0 )
                                    local ex,_,ez = localToLocal(belt.endNode, spec.interactionBaseNode, 0 , 0 , 0 )
                                    minX = math.min(minX, sx, ex)
                                    minZ = math.min(minZ, sz, ez)
                                    maxX = math.max(maxX, sx, ex)
                                    maxZ = math.max(maxZ, sz, ez)
                                end

                                spec.interactionBasePointX = (maxX + minX) / 2
                                spec.interactionBasePointZ = (maxZ + minZ) / 2

                                for _, belt in pairs(spec.singleBelts) do
                                    local sx,_,sz = localToLocal(belt.startNode, spec.interactionBaseNode, 0 , 0 , 0 )
                                    local sl = MathUtil.vector2Length(spec.interactionBasePointX - sx, spec.interactionBasePointZ - sz) + 1
                                    local el = MathUtil.vector2Length(spec.interactionBasePointX - sx, spec.interactionBasePointZ - sz) + 1
                                    spec.totalInteractionRadius = math.max(spec.totalInteractionRadius, sl, el)
                                end

                            else
                                    Logging.xmlWarning( self.xmlFile, "No belt data found for tension belt type %s" , tensionBeltType)
                                    end

                                    spec.hasTensionBelts = #spec.sortedBelts > 0

                                    spec.checkBoxes = { }
                                    spec.objectsToJoint = { }
                                    spec.isPlayerInRange = false
                                    spec.currentBelt = nil
                                    spec.areAllBeltsFastened = false
                                    spec.fastenedAllBeltsIndex = - 1
                                    spec.fastenedAllBeltsState = true

                                    if self.isClient then
                                        spec.samples = { }
                                        spec.samples.toggleBelt = g_soundManager:loadSampleFromXML( self.xmlFile, configKey .. ".sounds" , "toggleBelt" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                        spec.samples.addBelt = g_soundManager:loadSampleFromXML( self.xmlFile, configKey .. ".sounds" , "addBelt" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                        spec.samples.removeBelt = g_soundManager:loadSampleFromXML( self.xmlFile, configKey .. ".sounds" , "removeBelt" , self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                                    end

                                    spec.texts = { }
                                    spec.texts.warningFoldingTensionBelts = g_i18n:getText( "warning_foldingNotWhileTensionBeltsFasten" )

                                    if not spec.hasTensionBelts then
                                        SpecializationUtil.removeEventListener( self , "onPostLoad" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onDelete" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onPreDelete" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onReadStream" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onWriteStream" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onUpdate" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onUpdateTick" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onDraw" , TensionBelts )
                                        SpecializationUtil.removeEventListener( self , "onRegisterActionEvents" , TensionBelts )

                                        -- delete activation trigger as onDelete event is removed
                                        if spec.activationTrigger ~ = nil then
                                            removeTrigger(spec.activationTrigger)
                                            spec.activationTrigger = nil
                                        end
                                    else
                                            g_messageCenter:subscribe(MessageType.TREE_SHAPE_CUT, self.onTensionBeltTreeShapeCut, self )
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
function TensionBelts:onPostLoad(savegame)
    if savegame ~ = nil then
        local spec = self.spec_tensionBelts

        spec.beltsToLoad = { }
        local i = 0
        while true do
            local key = string.format( "%s.tensionBelts.belt(%d)" , savegame.key, i)
            if not savegame.xmlFile:hasProperty(key) then
                break
            end
            if savegame.xmlFile:getValue(key .. "#isActive" ) then
                table.insert(spec.beltsToLoad, i + 1 )
            end
            i = i + 1
        end
    end
end

```

### onPreDelete

**Description**

**Definition**

> onPreDelete()

**Code**

```lua
function TensionBelts:onPreDelete()
    if self.spec_tensionBelts.sortedBelts ~ = nil then
        for _, belt in pairs( self.spec_tensionBelts.sortedBelts) do
            local objects, _ = self:getObjectToMount(belt)
            for id, _ in pairs(objects) do
                I3DUtil.wakeUpObject(id)
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
function TensionBelts:onReadStream(streamId, connection)
    local spec = self.spec_tensionBelts

    if spec.tensionBelts ~ = nil then
        spec.beltsToLoad = { }
        for k, _ in ipairs(spec.sortedBelts) do
            local beltActive = streamReadBool(streamId)
            if beltActive then
                table.insert(spec.beltsToLoad, k)
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
function TensionBelts:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    local spec = self.spec_tensionBelts
    if self.isClient and spec.hasTensionBelts then
        self:clearActionEventsTable(spec.actionEvents)

        if isActiveForInputIgnoreSelection then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.TOGGLE_TENSION_BELTS, self , TensionBelts.actionEventToggleTensionBelts, false , true , false , true , nil )
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            self.toggleTensionBeltActionEvent = actionEventId
        end
    end
end

```

### onTensionBeltTreeShapeCut

**Description**

**Definition**

> onTensionBeltTreeShapeCut()

**Arguments**

| any | oldShape |
|-----|----------|
| any | shape    |

**Code**

```lua
function TensionBelts:onTensionBeltTreeShapeCut(oldShape, shape)
    if self.isServer then
        local spec = self.spec_tensionBelts
        for objectId, data in pairs(spec.objectsToJoint) do
            if objectId = = oldShape then
                self:setAllTensionBeltsActive( false )
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
function TensionBelts:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_tensionBelts

    if spec.beltsToLoad ~ = nil then
        if #spec.beltsToLoad > 0 then
            local beltIndex = spec.beltsToLoad[#spec.beltsToLoad]

            local noEventSend = false
            if not self.isServer then
                -- do not resend event to server after sync.Only send event after loading to make sure client have visible tension belts
                    noEventSend = true
                end
                self:setTensionBeltsActive( true , spec.sortedBelts[beltIndex].id, noEventSend, false )

                table.remove(spec.beltsToLoad, #spec.beltsToLoad)
            else
                    spec.beltsToLoad = nil
                end
            end

            if self.isServer and spec.isDynamic then
                local x,y,z = localToLocal(spec.linkNode, spec.jointNode, 0 , 0 , 0 )
                local rx,ry,rz = localRotationToLocal(spec.linkNode, spec.jointNode, 0 , 0 , 0 )

                local isDirty = false
                if math.abs(x - spec.linkNodePosition[ 1 ]) > 0.001 or math.abs(y - spec.linkNodePosition[ 2 ]) > 0.001 or math.abs(z - spec.linkNodePosition[ 3 ]) > 0.001 or
                    math.abs(rx - spec.linkNodeRotation[ 1 ]) > 0.001 or math.abs(ry - spec.linkNodeRotation[ 2 ]) > 0.001 or math.abs(rz - spec.linkNodeRotation[ 3 ]) > 0.001 then
                    isDirty = true
                end
                if isDirty then
                    spec.linkNodePosition[ 1 ], spec.linkNodePosition[ 2 ], spec.linkNodePosition[ 3 ] = x, y, z
                    spec.linkNodeRotation[ 1 ], spec.linkNodeRotation[ 2 ], spec.linkNodeRotation[ 3 ] = rx, ry, rz
                    for _, joint in pairs(spec.objectsToJoint) do
                        setJointFrame(joint.jointIndex, 0 , joint.jointTransform)
                    end
                end
            end

            if self.isClient then
                if spec.fastenedAllBeltsIndex > 0 then
                    local belt = spec.sortedBelts[spec.fastenedAllBeltsIndex]
                    if belt ~ = nil then
                        self:setTensionBeltsActive(spec.fastenedAllBeltsState, belt.id, false )
                    end

                    spec.fastenedAllBeltsIndex = spec.fastenedAllBeltsIndex + 1
                    if spec.fastenedAllBeltsIndex > #spec.sortedBelts then
                        spec.fastenedAllBeltsIndex = - 1
                    end
                end
            end

            if TensionBelts.debugRendering then
                for belt,_ in pairs(spec.belts) do
                    DebugGizmo.renderAtNode(belt, belt.id, false , 0.5 )
                    for i = 0 , getNumOfChildren(belt) - 1 do
                        DebugGizmo.renderAtNode(getChildAt(belt, i), string.format( "%s-%d" , belt.id, i), false , 0.2 )
                    end
                end

                if spec.checkBoxes ~ = nil then
                    for _, box in pairs(spec.checkBoxes) do
                        local p = box.points
                        local c = box.color

                        -- bottom
                        drawDebugLine(p[ 1 ][ 1 ],p[ 1 ][ 2 ],p[ 1 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 2 ][ 1 ],p[ 2 ][ 2 ],p[ 2 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 2 ][ 1 ],p[ 2 ][ 2 ],p[ 2 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 3 ][ 1 ],p[ 3 ][ 2 ],p[ 3 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 3 ][ 1 ],p[ 3 ][ 2 ],p[ 3 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 4 ][ 1 ],p[ 4 ][ 2 ],p[ 4 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 4 ][ 1 ],p[ 4 ][ 2 ],p[ 4 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 1 ][ 1 ],p[ 1 ][ 2 ],p[ 1 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        -- top
                        drawDebugLine(p[ 5 ][ 1 ],p[ 5 ][ 2 ],p[ 5 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 6 ][ 1 ],p[ 6 ][ 2 ],p[ 6 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 6 ][ 1 ],p[ 6 ][ 2 ],p[ 6 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 7 ][ 1 ],p[ 7 ][ 2 ],p[ 7 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 7 ][ 1 ],p[ 7 ][ 2 ],p[ 7 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 8 ][ 1 ],p[ 8 ][ 2 ],p[ 8 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 8 ][ 1 ],p[ 8 ][ 2 ],p[ 8 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 5 ][ 1 ],p[ 5 ][ 2 ],p[ 5 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        -- left
                        drawDebugLine(p[ 1 ][ 1 ],p[ 1 ][ 2 ],p[ 1 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 5 ][ 1 ],p[ 5 ][ 2 ],p[ 5 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 4 ][ 1 ],p[ 4 ][ 2 ],p[ 4 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 8 ][ 1 ],p[ 8 ][ 2 ],p[ 8 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        -- right
                        drawDebugLine(p[ 2 ][ 1 ],p[ 2 ][ 2 ],p[ 2 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 6 ][ 1 ],p[ 6 ][ 2 ],p[ 6 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugLine(p[ 3 ][ 1 ],p[ 3 ][ 2 ],p[ 3 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ], p[ 7 ][ 1 ],p[ 7 ][ 2 ],p[ 7 ][ 3 ], c[ 1 ],c[ 2 ],c[ 3 ])
                        drawDebugPoint(p[ 9 ][ 1 ], p[ 9 ][ 2 ], p[ 9 ][ 3 ], 1 , 1 , 1 , 1 )
                    end
                end

                local wx,wy,wz = localToWorld(spec.interactionBaseNode, spec.interactionBasePointX, 0 , spec.interactionBasePointZ)
                drawDebugPoint(wx,wy,wz, 0 , 0 , 1 , 1 , false )

                for i = 0 , 360 - 10 , 10 do
                    local x,y,z = localToWorld(spec.interactionBaseNode, spec.interactionBasePointX + math.cos( math.rad(i)) * spec.totalInteractionRadius, 0 , spec.interactionBasePointZ + math.sin( math.rad(i)) * spec.totalInteractionRadius)
                    drawDebugPoint(x, y, z, 1 , 1 , 1 , 1 )
                    for _, belt in pairs(spec.singleBelts) do
                        x,y,z = localToWorld(belt.startNode, math.cos( math.rad(i)) * spec.interactionRadius, 0 , math.sin( math.rad(i)) * spec.interactionRadius)
                        drawDebugPoint(x, y, z, 0 , 1 , 0 , 1 )
                        x,y,z = localToWorld(belt.endNode, math.cos( math.rad(i)) * spec.interactionRadius, 0 , math.sin( math.rad(i)) * spec.interactionRadius)
                        drawDebugPoint(x, y, z, 1 , 0 , 0 , 1 )
                    end
                end
            end

            if spec.isPlayerInTrigger or spec.isPlayerInRange then
                self:raiseActive()
            end

            -- create tension belt preview and control activation
            local currentBelt
            local wasInRange = spec.isPlayerInRange
            spec.isPlayerInRange, currentBelt = self:getIsPlayerInTensionBeltsRange()
            if spec.isPlayerInRange then
                if currentBelt ~ = spec.currentBelt then
                    if spec.currentBelt ~ = nil and spec.currentBelt.dummy ~ = nil then
                        delete(spec.currentBelt.dummy)
                        spec.currentBelt.dummy = nil
                    end
                    spec.currentBelt = currentBelt

                    if spec.currentBelt ~ = nil and spec.currentBelt.mesh = = nil then
                        local objects, _ = self:getObjectToMount(spec.currentBelt)
                        self:createTensionBelt(spec.currentBelt, true , objects)
                    end
                end
                g_currentMission.activatableObjectsSystem:addActivatable(spec.activatable)
                spec.activatable:updateActivateText()
            else
                    if wasInRange then
                        g_currentMission.activatableObjectsSystem:removeActivatable(spec.activatable)
                        if spec.currentBelt ~ = nil and spec.currentBelt.dummy ~ = nil then
                            delete(spec.currentBelt.dummy)
                            spec.currentBelt.dummy = nil
                            spec.currentBelt = nil
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
function TensionBelts:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_tensionBelts

    if not spec.hasTensionBelts then
        return
    end

    if self.isServer and spec.tensionBelts ~ = nil then
        spec.checkTimer = spec.checkTimer - dt
        if spec.checkTimer < 0 then
            -- check if entities have been deleted
                local needUpdate = false
                for phyiscObject, _ in pairs(spec.objectsToJoint) do
                    if not entityExists(phyiscObject) then
                        spec.objectsToJoint[phyiscObject] = nil
                        needUpdate = true
                        break
                    end
                end
                if needUpdate then
                    self:refreshTensionBelts()
                end

                spec.checkTimer = spec.checkTimerDuration
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
function TensionBelts:onWriteStream(streamId, connection)
    local spec = self.spec_tensionBelts

    if spec.tensionBelts ~ = nil then
        for _, belt in ipairs(spec.sortedBelts) do
            streamWriteBool(streamId, belt.mesh ~ = nil )
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
function TensionBelts.prerequisitesPresent(specializations)
    return true
end

```

### refreshTensionBelts

**Description**

**Definition**

> refreshTensionBelts()

**Code**

```lua
function TensionBelts:refreshTensionBelts()
    if self.isServer then
        if g_server ~ = nil then
            g_server:broadcastEvent( TensionBeltsRefreshEvent.new( self ), nil , nil , self )
        end
    end
    for _, belt in pairs( self.spec_tensionBelts.sortedBelts) do
        if belt.mesh ~ = nil then
            self:removeTensionBelt(belt)
            local objects, _ = self:getObjectToMount(belt)
            self:createTensionBelt(belt, false , objects)
        end
    end
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
function TensionBelts.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDelete" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateTick" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onDraw" , TensionBelts )
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents" , TensionBelts )
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
function TensionBelts.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "createTensionBelt" , TensionBelts.createTensionBelt)
    SpecializationUtil.registerFunction(vehicleType, "removeTensionBelt" , TensionBelts.removeTensionBelt)
    SpecializationUtil.registerFunction(vehicleType, "setTensionBeltsActive" , TensionBelts.setTensionBeltsActive)
    SpecializationUtil.registerFunction(vehicleType, "setAllTensionBeltsActive" , TensionBelts.setAllTensionBeltsActive)
    SpecializationUtil.registerFunction(vehicleType, "objectOverlapCallback" , TensionBelts.objectOverlapCallback)
    SpecializationUtil.registerFunction(vehicleType, "getTensionBeltObjectCanBeMounted" , TensionBelts.getTensionBeltObjectCanBeMounted)
    SpecializationUtil.registerFunction(vehicleType, "getObjectToMount" , TensionBelts.getObjectToMount)
    SpecializationUtil.registerFunction(vehicleType, "getObjectsToUnmount" , TensionBelts.getObjectsToUnmount)
    SpecializationUtil.registerFunction(vehicleType, "updateFastenState" , TensionBelts.updateFastenState)
    SpecializationUtil.registerFunction(vehicleType, "refreshTensionBelts" , TensionBelts.refreshTensionBelts)
    SpecializationUtil.registerFunction(vehicleType, "freeTensionBeltObject" , TensionBelts.freeTensionBeltObject)
    SpecializationUtil.registerFunction(vehicleType, "lockTensionBeltObject" , TensionBelts.lockTensionBeltObject)
    SpecializationUtil.registerFunction(vehicleType, "getIsPlayerInTensionBeltsRange" , TensionBelts.getIsPlayerInTensionBeltsRange)
    SpecializationUtil.registerFunction(vehicleType, "getIsDynamicallyMountedNode" , TensionBelts.getIsDynamicallyMountedNode)
    SpecializationUtil.registerFunction(vehicleType, "tensionBeltActivationTriggerCallback" , TensionBelts.tensionBeltActivationTriggerCallback)
    SpecializationUtil.registerFunction(vehicleType, "onTensionBeltTreeShapeCut" , TensionBelts.onTensionBeltTreeShapeCut)
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
function TensionBelts.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsReadyForAutomatedTrainTravel" , TensionBelts.getIsReadyForAutomatedTrainTravel)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeSelected" , TensionBelts.getCanBeSelected)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsFoldAllowed" , TensionBelts.getIsFoldAllowed)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadMovingToolFromXML" , TensionBelts.loadMovingToolFromXML)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getIsMovingToolActive" , TensionBelts.getIsMovingToolActive)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanDischargeToGround" , TensionBelts.getCanDischargeToGround)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanDischargeToObject" , TensionBelts.getCanDischargeToObject)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getFillLevelInformation" , TensionBelts.getFillLevelInformation)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getHasObjectMounted" , TensionBelts.getHasObjectMounted)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getAdditionalComponentMass" , TensionBelts.getAdditionalComponentMass)
end

```

### removeTensionBelt

**Description**

> Remove tension belt

**Definition**

> removeTensionBelt(table belt, boolean playSound)

**Arguments**

| table   | belt      | belt to remove          |
|---------|-----------|-------------------------|
| boolean | playSound | play sound (nil = true) |

**Code**

```lua
function TensionBelts:removeTensionBelt(belt, playSound)
    if belt.mesh ~ = nil then
        local spec = self.spec_tensionBelts

        spec.belts[belt.mesh] = nil
        delete(belt.mesh)
        belt.mesh = nil
        if spec.currentBelt = = belt then
            spec.currentBelt = nil
        end

        if belt.dummy = = nil and playSound ~ = false then
            if self.isClient then
                g_soundManager:playSample(spec.samples.toggleBelt)
                g_soundManager:playSample(spec.samples.removeBelt)
            end
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
function TensionBelts:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_tensionBelts

    if spec.hasTensionBelts then
        for i, belt in ipairs(spec.sortedBelts) do
            local beltKey = string.format( "%s.belt(%d)" , key, i - 1 )
            xmlFile:setValue(beltKey .. "#isActive" , belt.mesh ~ = nil )
        end
    end
end

```

### setAllTensionBeltsActive

**Description**

> Set tensionbelts active state

**Definition**

> setAllTensionBeltsActive()

**Arguments**

| any | isActive    |
|-----|-------------|
| any | noEventSend |

**Code**

```lua
function TensionBelts:setAllTensionBeltsActive(isActive, noEventSend)
    local spec = self.spec_tensionBelts

    if spec.hasTensionBelts then
        isActive = Utils.getNoNil(isActive, not spec.areAllBeltsFastened)
        for _, belt in pairs(spec.sortedBelts) do
            self:setTensionBeltsActive(isActive, belt.id, noEventSend)
        end
    end
end

```

### setTensionBeltsActive

**Description**

> Set tensionbelts active state

**Definition**

> setTensionBeltsActive(boolean isActive, integer beltId, boolean playSound, )

**Arguments**

| boolean | isActive  | new active state                                          |
|---------|-----------|-----------------------------------------------------------|
| integer | beltId    | id of belt to set state (if id is nil it uses every belt) |
| boolean | playSound | play sound (nil = true)                                   |
| any     | playSound |                                                           |

**Code**

```lua
function TensionBelts:setTensionBeltsActive(isActive, beltId, noEventSend, playSound)
    local spec = self.spec_tensionBelts

    if spec.tensionBelts ~ = nil then
        TensionBeltsEvent.sendEvent( self , isActive, beltId, noEventSend)

        local belt = nil
        if beltId ~ = nil then
            belt = spec.sortedBelts[beltId]
        end

        if isActive then
            local objects, _ = self:getObjectToMount(belt)
            if belt = = nil then
                for _, singleBelt in pairs(spec.singleBelts) do
                    if singleBelt.mesh = = nil then
                        self:createTensionBelt(singleBelt, false , objects, playSound)
                    end
                end
            else
                    if belt.mesh = = nil then
                        self:createTensionBelt(belt, false , objects, playSound)
                    end
                end

                for _, data in pairs(objects) do
                    self:lockTensionBeltObject(data.physics, spec.objectsToJoint, spec.isDynamic, belt.jointNode or spec.jointNode, data.object)
                    if data.object ~ = nil then
                        data.object.tensionMountObject = self
                    end
                end
            else
                    if belt = = nil then
                        for _, singleBelt in pairs(spec.singleBelts) do
                            self:removeTensionBelt(singleBelt, playSound)
                        end
                    else
                            self:removeTensionBelt(belt, playSound)
                        end

                        -- remove joints
                        local objectIds, _ = self:getObjectsToUnmount(belt)
                        for objectId, objectData in pairs(objectIds) do
                            self:freeTensionBeltObject(objectId, spec.objectsToJoint, spec.isDynamic, objectData.object)

                            if objectData.object ~ = nil then
                                objectData.object.tensionMountObject = nil
                            end
                        end
                    end

                    if belt ~ = nil then
                        ObjectChangeUtil.setObjectChanges(belt.changeObjects, isActive, self , self.setMovingToolDirty)
                    end

                    self:updateFastenState()
                end
            end

```

### tensionBeltActivationTriggerCallback

**Description**

**Definition**

> tensionBeltActivationTriggerCallback()

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
function TensionBelts:tensionBeltActivationTriggerCallback(triggerId, otherActorId, onEnter, onLeave, onStay, otherShapeId)
    local spec = self.spec_tensionBelts
    if self.isClient and spec.hasTensionBelts then
        if onEnter or onLeave then
            if g_localPlayer ~ = nil and otherActorId = = g_localPlayer.rootNode then
                if onEnter then
                    self:raiseActive()
                    spec.isPlayerInTrigger = true
                else
                        spec.isPlayerInTrigger = false
                    end
                end
            end
        end
    end

```

### updateFastenState

**Description**

> Update 'self.areAllBeltsFastened'

**Definition**

> updateFastenState()

**Code**

```lua
function TensionBelts:updateFastenState()
    local spec = self.spec_tensionBelts

    local hasUnfastenedBelts = false
    for _, belt in pairs(spec.singleBelts) do
        if belt.mesh = = nil then
            hasUnfastenedBelts = true
            break
        end
    end

    spec.areAllBeltsFastened = not hasUnfastenedBelts
end

```