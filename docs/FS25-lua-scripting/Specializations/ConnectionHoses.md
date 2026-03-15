## ConnectionHoses

**Description**

> Specialization for connection hoses between vehicles and tools

**Functions**

- [addHoseTargetNodes](#addhosetargetnodes)
- [addHoseToDelayedMountings](#addhosetodelayedmountings)
- [connectCustomHoseNode](#connectcustomhosenode)
- [connectCustomHosesToAttacherVehicle](#connectcustomhosestoattachervehicle)
- [connectHose](#connecthose)
- [connectHosesToAttacherVehicle](#connecthosestoattachervehicle)
- [connectHoseToSkipNode](#connecthosetoskipnode)
- [consoleCommandTestSockets](#consolecommandtestsockets)
- [consoleCommandTestToolConnection](#consolecommandtesttoolconnection)
- [disconnectCustomHoseNode](#disconnectcustomhosenode)
- [disconnectHose](#disconnecthose)
- [getCenterPointAngle](#getcenterpointangle)
- [getCenterPointAngleRegulation](#getcenterpointangleregulation)
- [getClonedSkipHoseNode](#getclonedskiphosenode)
- [getConnectionHoseConfigIndex](#getconnectionhoseconfigindex)
- [getConnectionHosesByInputAttacherJoint](#getconnectionhosesbyinputattacherjoint)
- [getConnectionTarget](#getconnectiontarget)
- [getIsConnectionHoseUsed](#getisconnectionhoseused)
- [getIsConnectionTargetUsed](#getisconnectiontargetused)
- [getIsSkipNodeAvailable](#getisskipnodeavailable)
- [initSpecialization](#initspecialization)
- [iterateConnectionTargets](#iterateconnectiontargets)
- [loadConnectionHosesFromXML](#loadconnectionhosesfromxml)
- [loadCustomHosesFromXML](#loadcustomhosesfromxml)
- [loadExtraDependentParts](#loadextradependentparts)
- [loadHoseNode](#loadhosenode)
- [loadHoseSkipNode](#loadhoseskipnode)
- [loadHoseTargetNode](#loadhosetargetnode)
- [loadToolConnectorHoseNode](#loadtoolconnectorhosenode)
- [onDelete](#ondelete)
- [onLoadFinished](#onloadfinished)
- [onPostAttach](#onpostattach)
- [onPostLoad](#onpostload)
- [onPreDetach](#onpredetach)
- [onPreLoad](#onpreload)
- [onUpdateEnd](#onupdateend)
- [onUpdateInterpolation](#onupdateinterpolation)
- [prerequisitesPresent](#prerequisitespresent)
- [registerConnectionHoseXMLPaths](#registerconnectionhosexmlpaths)
- [registerCustomHoseNodesXMLPaths](#registercustomhosenodesxmlpaths)
- [registerCustomHoseTargetNodesXMLPaths](#registercustomhosetargetnodesxmlpaths)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerHoseNodesXMLPaths](#registerhosenodesxmlpaths)
- [registerHoseTargetNodesXMLPaths](#registerhosetargetnodesxmlpaths)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [retryHoseSkipNodeConnections](#retryhoseskipnodeconnections)
- [setConnectionHosesActive](#setconnectionhosesactive)
- [updateAttachedConnectionHoses](#updateattachedconnectionhoses)
- [updateConnectionHose](#updateconnectionhose)
- [updateCustomHoseNode](#updatecustomhosenode)
- [updateExtraDependentParts](#updateextradependentparts)
- [updateToolConnectionHose](#updatetoolconnectionhose)

### addHoseTargetNodes

**Description**

**Definition**

> addHoseTargetNodes()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function ConnectionHoses:addHoseTargetNodes(xmlFile, key)
    local spec = self.spec_connectionHoses

    local addedTarget = false
    xmlFile:iterate(key, function (_, targetKey)
        local entry = { }
        if self:loadHoseTargetNode(xmlFile, targetKey, entry) then
            table.insert(spec.targetNodes, entry)
            entry.index = #spec.targetNodes

            if spec.targetNodesByType[entry.type ] = = nil then
                spec.targetNodesByType[entry.type ] = { }
            end

            table.insert(spec.targetNodesByType[entry.type ], entry)
            addedTarget = true
        end
    end )

    -- return the index of the last added target
    if addedTarget then
        return #spec.targetNodes
    end

    return nil
end

```

### addHoseToDelayedMountings

**Description**

**Definition**

> addHoseToDelayedMountings()

**Arguments**

| any | sourceObject |
|-----|--------------|
| any | sourceHose   |
| any | targetObject |
| any | targetHose   |

**Code**

```lua
function ConnectionHoses:addHoseToDelayedMountings(sourceObject, sourceHose, targetObject, targetHose)
    local spec = self.spec_connectionHoses

    local toolConnectionHose = spec.targetNodeToToolConnection[targetHose.index]
    if toolConnectionHose ~ = nil and(toolConnectionHose.delayedMounting = = nil or sourceHose.typedIndex = = toolConnectionHose.typedIndex) then
        local retry = toolConnectionHose.delayedMounting = = nil
        toolConnectionHose.delayedMounting = { sourceObject = sourceObject, sourceHose = sourceHose, targetObject = targetObject, targetHose = targetHose }

        if retry then
            self.rootVehicle:retryHoseSkipNodeConnections( true , sourceObject)
        end
    end
end

```

### connectCustomHoseNode

**Description**

**Definition**

> connectCustomHoseNode()

**Arguments**

| any | customHose   |
|-----|--------------|
| any | customTarget |
| any | targetObject |

**Code**

```lua
function ConnectionHoses:connectCustomHoseNode(customHose, customTarget, targetObject)
    self:updateCustomHoseNode(customHose, customTarget)

    customHose.isActive = true
    customTarget.isActive = true

    customHose.connectedTarget = customTarget
    customHose.connectedObject = targetObject
    customTarget.connectedHose = customHose
    customTarget.connectedObject = self

    ObjectChangeUtil.setObjectChanges(customHose.objectChanges, true , customHose.objectChangesTarget, customHose.objectChangesTarget.setMovingToolDirty)
    ObjectChangeUtil.setObjectChanges(customTarget.objectChanges, true , customTarget.objectChangesTarget, customTarget.objectChangesTarget.setMovingToolDirty)

    if self.setMovingToolDirty ~ = nil then
        self:setMovingToolDirty(customHose.node, true )
    end
end

```

### connectCustomHosesToAttacherVehicle

**Description**

**Definition**

> connectCustomHosesToAttacherVehicle()

**Arguments**

| any | attacherVehicle     |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |

**Code**

```lua
function ConnectionHoses:connectCustomHosesToAttacherVehicle(attacherVehicle, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_connectionHoses
    local customHoses = spec.customHosesByInputAttacher[inputJointDescIndex]
    if customHoses ~ = nil then
        for i = 1 , #customHoses do
            local customHose = customHoses[i]
            if not customHose.isActive then
                if attacherVehicle.spec_connectionHoses ~ = nil then
                    local customTargets = attacherVehicle.spec_connectionHoses.customHoseTargetsByAttacher[jointDescIndex]
                    if customTargets ~ = nil then
                        for j = 1 , #customTargets do
                            local customTarget = customTargets[j]
                            if not customTarget.isActive then
                                if customHose.type = = customTarget.type
                                    and customHose.specType = = customTarget.specType then
                                    self:connectCustomHoseNode(customHose, customTarget, attacherVehicle)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local customTargets = spec.customHoseTargetsByInputAttacher[inputJointDescIndex]
    if customTargets ~ = nil then
        for i = 1 , #customTargets do
            local customTarget = customTargets[i]
            if not customTarget.isActive then
                if attacherVehicle.spec_connectionHoses ~ = nil then
                    customHoses = attacherVehicle.spec_connectionHoses.customHosesByAttacher[jointDescIndex]
                    if customHoses ~ = nil then
                        for j = 1 , #customHoses do
                            local customHose = customHoses[j]
                            if not customHose.isActive then
                                if customHose.type = = customTarget.type
                                    and customHose.specType = = customTarget.specType then
                                    self:connectCustomHoseNode(customHose, customTarget, attacherVehicle)
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

### connectHose

**Description**

**Definition**

> connectHose()

**Arguments**

| any | sourceHose            |
|-----|-----------------------|
| any | targetObject          |
| any | targetHose            |
| any | updateToolConnections |

**Code**

```lua
function ConnectionHoses:connectHose(sourceHose, targetObject, targetHose, updateToolConnections)
    local spec = self.spec_connectionHoses

    local doConnect = false
    if updateToolConnections ~ = nil and not updateToolConnections then
        doConnect = true
    else
            if targetObject:updateToolConnectionHose( self , sourceHose, targetObject, targetHose, true ) then
                doConnect = true
            else
                    -- on tool connections we wait until both ends are connected to a tool and then we connect the hoses
                    targetObject:addHoseToDelayedMountings( self , sourceHose, targetObject, targetHose)
                end
            end

            if doConnect then
                targetHose.connectedObject = self
                sourceHose.connectedObject = targetObject

                sourceHose.targetHose = targetHose

                local node, referenceNode
                if sourceHose.adapterName ~ = nil then
                    if sourceHose.adapterName ~ = "NONE" then
                        node, referenceNode = g_connectionHoseManager:getClonedAdapterNode(targetHose.type , sourceHose.adapterName, self.customEnvironment)
                    end
                elseif targetHose.adapterName ~ = "NONE" then
                        node, referenceNode = g_connectionHoseManager:getClonedAdapterNode(targetHose.type , targetHose.adapterName, self.customEnvironment)
                    end

                    if node ~ = nil then
                        if sourceHose.adapterMaterial ~ = nil then
                            sourceHose.adapterMaterial:apply(node, "connector_color_mat" )
                        end

                        link(g_connectionHoseManager:getSocketTarget(targetHose.socket, targetHose.node), node)
                        setTranslation(node, 0 , 0 , 0 )
                        setRotation(node, 0 , 0 , 0 )
                        targetObject:addAllSubWashableNodes(node)

                        targetHose.adapter.node = node
                        targetHose.adapter.refNode = referenceNode
                        targetHose.adapter.isLinked = true
                    end

                    sourceHose.targetNode = targetHose.adapter.refNode

                    setVisibility(sourceHose.visibilityNode, true )
                    setShaderParameter(sourceHose.hoseNode, "cv0" , 0 , 0 , - sourceHose.startStraightening, 1 , false )
                    sourceHose.endStraightening = sourceHose.endStraighteningBase * targetHose.straighteningFactor
                    sourceHose.endStraighteningDirection = targetHose.straighteningDirection or sourceHose.endStraighteningDirectionBase

                    if sourceHose.dynamicLength then
                        local hoseType = g_connectionHoseManager:getHoseTypeByName(sourceHose.type , self.customEnvironment)
                        if hoseType ~ = nil then
                            local material = g_connectionHoseManager:getHoseMaterialByName(hoseType, sourceHose.hoseType, self.customEnvironment)
                            if material ~ = nil then
                                local realLength, _, _, _ = getShaderParameter(sourceHose.hoseNode, "lengthAndDiameter" )
                                local actualLength = calcDistanceFrom(sourceHose.hoseNode, sourceHose.targetNode)

                                setShaderParameter(sourceHose.hoseNode, "uvScale" , (actualLength / realLength) * material.uvLengthScale, nil , nil , nil , false )
                            end
                        end
                    end

                    ObjectChangeUtil.setObjectChanges(targetHose.objectChanges, true , sourceHose.connectedObject, sourceHose.connectedObject.setMovingToolDirty)
                    ObjectChangeUtil.setObjectChanges(sourceHose.objectChanges, true , targetHose.connectedObject, targetHose.connectedObject.setMovingToolDirty)

                    g_connectionHoseManager:openSocket(sourceHose.socket)
                    g_connectionHoseManager:openSocket(targetHose.socket)

                    self:updateConnectionHose(sourceHose, 0 )

                    if self.isClient then
                        local sample = spec.samples.connect[sourceHose.type ]
                        if sample ~ = nil then
                            if not g_soundManager:getIsSamplePlaying(sample) then
                                g_soundManager:playSample(sample)
                            end
                        end
                    end

                    table.insert(spec.updateableHoses, sourceHose)
                    return true
                end

                return false
            end

```

### connectHosesToAttacherVehicle

**Description**

**Definition**

> connectHosesToAttacherVehicle()

**Arguments**

| any | attacherVehicle       |
|-----|-----------------------|
| any | inputJointDescIndex   |
| any | jointDescIndex        |
| any | updateToolConnections |
| any | excludeVehicle        |

**Code**

```lua
function ConnectionHoses:connectHosesToAttacherVehicle(attacherVehicle, inputJointDescIndex, jointDescIndex, updateToolConnections, excludeVehicle)
    if attacherVehicle.getConnectionTarget ~ = nil then
        local hoses = self:getConnectionHosesByInputAttacherJoint(inputJointDescIndex)
        for _, hose in ipairs(hoses) do
            attacherVehicle:iterateConnectionTargets( function (target, isSkipNode)
                if not self:getIsConnectionHoseUsed(hose) then
                    if not isSkipNode then
                        if self:connectHose(hose, attacherVehicle, target, updateToolConnections) then
                            return false
                        end
                    else
                            if self:connectHoseToSkipNode(hose, attacherVehicle, target) then
                                return false
                            end
                        end

                        return true
                    end

                    return false
                end , jointDescIndex, hose.type , hose.specType)
            end

            --try to connect the hoses of attached implements, maybe the connection is now valid since we got another skip node
            self:retryHoseSkipNodeConnections(updateToolConnections, excludeVehicle)
        end
    end

```

### connectHoseToSkipNode

**Description**

**Definition**

> connectHoseToSkipNode()

**Arguments**

| any | sourceHose   |
|-----|--------------|
| any | targetObject |
| any | skipNode     |
| any | childHose    |
| any | childVehicle |

**Code**

```lua
function ConnectionHoses:connectHoseToSkipNode(sourceHose, targetObject, skipNode, childHose, childVehicle)
    local spec = self.spec_connectionHoses

    skipNode.connectedObject = self
    sourceHose.connectedObject = targetObject

    sourceHose.targetHose = skipNode
    sourceHose.targetNode = skipNode.node

    setVisibility(sourceHose.visibilityNode, true )
    setShaderParameter(sourceHose.hoseNode, "cv0" , 0 , 0 , - sourceHose.startStraightening, 1 , false )

    ObjectChangeUtil.setObjectChanges(sourceHose.objectChanges, true , self , self.setMovingToolDirty)

    self:addAllSubWashableNodes(sourceHose.hoseNode)

    sourceHose.childVehicle = childVehicle
    sourceHose.childHose = childHose

    if self.getAttacherVehicle ~ = nil then
        local attacherVehicle1 = self:getAttacherVehicle()
        if attacherVehicle1.getAttacherVehicle ~ = nil then
            local attacherVehicle2 = attacherVehicle1:getAttacherVehicle()
            if attacherVehicle2 ~ = nil then

                local attacherJointIndex = attacherVehicle2:getAttacherJointIndexFromObject(attacherVehicle1)
                local implement = attacherVehicle2:getImplementFromAttacherJointIndex(attacherJointIndex)

                if implement.inputJointDescIndex = = skipNode.inputAttacherJointIndex then
                    local firstValidTarget, isSkipNode = attacherVehicle2:getConnectionTarget(attacherJointIndex, skipNode.type , skipNode.specType)
                    if firstValidTarget ~ = nil then
                        local hose = attacherVehicle1:getClonedSkipHoseNode(sourceHose, skipNode)
                        if not isSkipNode then
                            attacherVehicle1:connectHose(hose, attacherVehicle2, firstValidTarget)
                        else
                                attacherVehicle1:connectHoseToSkipNode(hose, attacherVehicle2, firstValidTarget, sourceHose, attacherVehicle1)
                            end

                            if skipNode.parentHose ~ = nil then
                                skipNode.parentVehicle:removeWashableNode(skipNode.parentHose.hoseNode)
                                delete(skipNode.parentHose.hoseNode)
                                table.removeElement(spec.updateableHoses, skipNode.parentHose.childHose)
                            end
                            skipNode.parentVehicle = attacherVehicle1
                            skipNode.parentHose = hose

                            sourceHose.parentVehicle = attacherVehicle1
                            sourceHose.parentHose = hose

                            hose.childVehicle = self
                            hose.childHose = sourceHose

                            attacherVehicle1:addAllSubWashableNodes(hose.hoseNode)
                        else
                                --same hose is still active, just update the relations
                                if skipNode.parentHose ~ = nil then
                                    sourceHose.parentVehicle = skipNode.parentVehicle
                                    sourceHose.parentHose = skipNode.parentHose

                                    sourceHose.parentHose.childVehicle = self
                                    sourceHose.parentHose.childHose = sourceHose
                                end
                            end
                        end
                    end
                end
            end

            table.insert(spec.updateableHoses, sourceHose)
            return true
        end

```

### consoleCommandTestSockets

**Description**

**Definition**

> consoleCommandTestSockets()

**Arguments**

| any | vehicle            |
|-----|--------------------|
| any | attacherJointIndex |

**Code**

```lua
function ConnectionHoses.consoleCommandTestSockets(vehicle, attacherJointIndex)
    local spec = vehicle.spec_connectionHoses
    if spec ~ = nil then
        local colors = { }
        colors[ "hydraulicIn" ] = Color.new( 0 , 1 , 0 )
        colors[ "hydraulicOut" ] = Color.new( 0 , 0 , 1 )
        colors[ "electric" ] = Color.new( 1 , 0 , 1 )
        colors[ "airDoubleRed" ] = Color.new( 1 , 0 , 0 )
        colors[ "airDoubleYellow" ] = Color.new( 1 , 1 , 0 )
        colors[ "isobus" ] = Color.new( 1 , 1 , 1 )

        local prefix = { }
        prefix[ "hydraulicIn" ] = "in"
        prefix[ "hydraulicOut" ] = "out"
        prefix[ "electric" ] = "e"
        prefix[ "airDoubleRed" ] = "red"
        prefix[ "airDoubleYellow" ] = "yel"
        prefix[ "isobus" ] = "iso"

        local indexByType = { }
        for index, targetHose in ipairs(spec.targetNodes) do
            -- first remove the old debug nodes
            if targetHose.socket ~ = nil then
                g_connectionHoseManager:closeSocket(targetHose.socket)
            end

            if targetHose.debugNode ~ = nil then
                delete(targetHose.debugNode)
                targetHose.debugNode = nil
            end

            if targetHose.debugLine ~ = nil then
                g_debugManager:removeElement(targetHose.debugLine)
                targetHose.debugLine = nil
            end

            if targetHose.debugText ~ = nil then
                g_debugManager:removeElement(targetHose.debugText)
                targetHose.debugText = nil
            end

            if targetHose.objectChanges ~ = nil then
                ObjectChangeUtil.setObjectChanges(targetHose.objectChanges, false , vehicle, vehicle.setMovingToolDirty)
            end

            if targetHose.attacherJointIndices[attacherJointIndex] ~ = nil then
                if indexByType[targetHose.type ] = = nil then
                    indexByType[targetHose.type ] = 0
                end
                indexByType[targetHose.type ] = indexByType[targetHose.type ] + 1

                if targetHose.socket ~ = nil then
                    g_connectionHoseManager:openSocket(targetHose.socket)
                end

                local node, referenceNode = g_connectionHoseManager:getClonedAdapterNode(targetHose.type , "DEFAULT" , vehicle.customEnvironment)
                if node ~ = nil then
                    local material = VehicleMaterial.new()
                    material:setTemplateName( "plasticPainted" )
                    material:setColor( 1 , 1 , 1 )
                    material:apply(node)

                    link(g_connectionHoseManager:getSocketTarget(targetHose.socket, targetHose.node), node)
                    setTranslation(node, 0 , 0 , 0 )
                    setRotation(node, 0 , 0 , 0 )

                    targetHose.debugNode = node

                    local attacherJointDesc = vehicle:getAttacherJointByJointDescIndex(attacherJointIndex)
                    if attacherJointDesc ~ = nil then
                        targetHose.debugLine = DebugLine.new():createWithStartAndEndNode(attacherJointDesc.jointTransform, referenceNode or node, false , true , 100 , true )
                        targetHose.debugLine:setColors(colors[targetHose.type ], colors[targetHose.type ])
                        g_debugManager:addElement(targetHose.debugLine, nil , nil , math.huge)

                        targetHose.debugText = DebugText.new():createWithNode(referenceNode, prefix[targetHose.type ] .. tostring(indexByType[targetHose.type ]), 0.015 , true )
                        targetHose.debugText.color = colors[targetHose.type ]
                        g_debugManager:addElement(targetHose.debugText, nil , nil , math.huge)
                    end
                end

                if targetHose.objectChanges ~ = nil then
                    ObjectChangeUtil.setObjectChanges(targetHose.objectChanges, true , vehicle, vehicle.setMovingToolDirty)
                end
            end
        end
    end
end

```

### consoleCommandTestToolConnection

**Description**

**Definition**

> consoleCommandTestToolConnection()

**Arguments**

| any | vehicle             |
|-----|---------------------|
| any | toolConnectionIndex |

**Code**

```lua
function ConnectionHoses.consoleCommandTestToolConnection(vehicle, toolConnectionIndex)

    local spec = vehicle.spec_connectionHoses
    if spec ~ = nil then
        local startColor = Color.new( 0 , 1 , 0 )
        local betweenColor = Color.new( 0 , 0 , 1 )
        local endColor = Color.new( 1 , 0 , 0 )

        for _, targetHose in ipairs(spec.targetNodes) do
            -- first remove the old debug nodes
            if targetHose.socket ~ = nil then
                g_connectionHoseManager:closeSocket(targetHose.socket)
            end

            if targetHose.debugElements ~ = nil then
                for _, element in pairs(targetHose.debugElements) do
                    g_debugManager:removeElement(element)
                end

                targetHose.debugElements = nil
            end

            if targetHose.debugText ~ = nil then
                g_debugManager:removeElement(targetHose.debugText)
                targetHose.debugText = nil
            end

            if targetHose.objectChanges ~ = nil then
                ObjectChangeUtil.setObjectChanges(targetHose.objectChanges, false , vehicle, vehicle.setMovingToolDirty)
            end
        end

        for i = 1 , #spec.toolConnectorHoses do
            local toolConnectionHose = spec.toolConnectorHoses[i]

            if toolConnectionHose.mountingNode ~ = nil then
                setVisibility(toolConnectionHose.mountingNode, false )
            end

            ObjectChangeUtil.setObjectChanges(toolConnectionHose.objectChanges, false , toolConnectionHose.objectChangesTarget, toolConnectionHose.objectChangesTarget.setMovingToolDirty)

            if toolConnectionHose.parentToolConnectionHose ~ = nil then
                local parentToolConnectionHose = toolConnectionHose.parentToolConnectionHose
                if parentToolConnectionHose.mountingNode ~ = nil then
                    setVisibility(parentToolConnectionHose.mountingNode, false )
                end

                ObjectChangeUtil.setObjectChanges(parentToolConnectionHose.objectChanges, false , parentToolConnectionHose.objectChangesTarget, parentToolConnectionHose.objectChangesTarget.setMovingToolDirty)
            end

            if toolConnectionHose.debugElements ~ = nil then
                for _, element in pairs(toolConnectionHose.debugElements) do
                    g_debugManager:removeElement(element)
                end

                toolConnectionHose.debugElements = nil
            end
        end

        local toolConnectionHose = spec.toolConnectorHoses[toolConnectionIndex]
        if toolConnectionHose ~ = nil then
            local startTarget = spec.targetNodes[toolConnectionHose.startTargetNodeIndex]
            local endTarget = spec.targetNodes[toolConnectionHose.endTargetNodeIndex]

            for _, attacherJointIndex in pairs(startTarget.attacherJointIndices) do
                local attacherJointDesc = vehicle:getAttacherJointByJointDescIndex(attacherJointIndex)
                if attacherJointDesc ~ = nil then
                    local debugLine = DebugLine.new():createWithStartAndEndNode(attacherJointDesc.jointTransform, startTarget.node, false , false , 100 , true )
                    debugLine:setColors(startColor, startColor)
                    g_debugManager:addElement(debugLine, nil , nil , math.huge)

                    local debugText = DebugText.new():createWithNode(attacherJointDesc.jointTransform, getName(attacherJointDesc.jointTransform), 0.01 , true )
                    debugText.color = startColor
                    g_debugManager:addElement(debugText, nil , nil , math.huge)

                    if startTarget.debugElements = = nil then
                        startTarget.debugElements = { }
                    end

                    table.insert(startTarget.debugElements, debugLine)
                    table.insert(startTarget.debugElements, debugText)
                end
            end

            for _, attacherJointIndex in pairs(endTarget.attacherJointIndices) do
                local attacherJointDesc = vehicle:getAttacherJointByJointDescIndex(attacherJointIndex)
                if attacherJointDesc ~ = nil then
                    local debugLine = DebugLine.new():createWithStartAndEndNode(attacherJointDesc.jointTransform, endTarget.node, false , false , 100 , true )
                    debugLine:setColors(endColor, endColor)
                    g_debugManager:addElement(debugLine, nil , nil , math.huge)

                    local debugText = DebugText.new():createWithNode(attacherJointDesc.jointTransform, getName(attacherJointDesc.jointTransform), 0.01 , true )
                    debugText.color = endColor
                    g_debugManager:addElement(debugText, nil , nil , math.huge)

                    if endTarget.debugElements = = nil then
                    endTarget.debugElements = { }
                end

                table.insert(endTarget.debugElements, debugLine)
                table.insert(endTarget.debugElements, debugText)
            end
        end

        local debugLine = DebugLine.new():createWithStartAndEndNode(startTarget.node, endTarget.node, false , true , 100 , true )
        debugLine:setColors(betweenColor, betweenColor)
        g_debugManager:addElement(debugLine, nil , nil , math.huge)

        local debugTextStart = DebugText.new():createWithNode(startTarget.node, getName(startTarget.node), 0.01 , true )
        debugTextStart.color = startColor
        g_debugManager:addElement(debugTextStart, nil , nil , math.huge)

        local debugTextEnd = DebugText.new():createWithNode(endTarget.node, getName(endTarget.node), 0.01 , true )
        debugTextEnd.color = endColor
        g_debugManager:addElement(debugTextEnd, nil , nil , math.huge)

        if toolConnectionHose.debugElements = = nil then
            toolConnectionHose.debugElements = { }
        end

        table.insert(toolConnectionHose.debugElements, debugLine)
        table.insert(toolConnectionHose.debugElements, debugTextStart)
        table.insert(toolConnectionHose.debugElements, debugTextEnd)

        if toolConnectionHose.mountingNode ~ = nil then
            setVisibility(toolConnectionHose.mountingNode, true )
        end

        ObjectChangeUtil.setObjectChanges(toolConnectionHose.objectChanges, true , toolConnectionHose.objectChangesTarget, toolConnectionHose.objectChangesTarget.setMovingToolDirty)

        if toolConnectionHose.parentToolConnectionHose ~ = nil then
            local parentToolConnectionHose = toolConnectionHose.parentToolConnectionHose
            if parentToolConnectionHose.mountingNode ~ = nil then
                setVisibility(parentToolConnectionHose.mountingNode, true )
            end

            ObjectChangeUtil.setObjectChanges(parentToolConnectionHose.objectChanges, true , parentToolConnectionHose.objectChangesTarget, parentToolConnectionHose.objectChangesTarget.setMovingToolDirty)
        end
    end
end
end

```

### disconnectCustomHoseNode

**Description**

**Definition**

> disconnectCustomHoseNode()

**Arguments**

| any | customHose   |
|-----|--------------|
| any | customTarget |

**Code**

```lua
function ConnectionHoses:disconnectCustomHoseNode(customHose, customTarget)
    setTranslation(customHose.node, unpack(customHose.startTranslation))
    setRotation(customHose.node, unpack(customHose.startRotation))

    if self.setMovingToolDirty ~ = nil then
        self:setMovingToolDirty(customHose.node, true )
    end

    customHose.isActive = false
    customTarget.isActive = false

    customHose.connectedTarget = nil
    customHose.connectedObject = nil
    customTarget.connectedHose = nil
    customTarget.connectedObject = nil

    ObjectChangeUtil.setObjectChanges(customHose.objectChanges, false , customHose.objectChangesTarget, customHose.objectChangesTarget.setMovingToolDirty)
    ObjectChangeUtil.setObjectChanges(customTarget.objectChanges, false , customTarget.objectChangesTarget, customTarget.objectChangesTarget.setMovingToolDirty)
end

```

### disconnectHose

**Description**

**Definition**

> disconnectHose()

**Arguments**

| any | hose |
|-----|------|

**Code**

```lua
function ConnectionHoses:disconnectHose(hose)
    local spec = self.spec_connectionHoses
    local target = hose.targetHose
    if target ~ = nil then
        hose.connectedObject:updateToolConnectionHose( self , hose, hose.connectedObject, target, false )

        local hoseHasSkipNodeTarget = target.isSkipNode ~ = nil and target.isSkipNode
        local hoseIsFromSkipNodeTarget = hose.isClonedSkipNodeHose ~ = nil and hose.isClonedSkipNodeHose
        if hoseHasSkipNodeTarget or hoseIsFromSkipNodeTarget then
            --remove all skip node connections recursively in both directions
            if hose.parentVehicle ~ = nil and hose.parentHose ~ = nil then
                hose.parentHose.childVehicle = nil
                hose.parentHose.childHose = nil
                hose.parentVehicle:disconnectHose(hose.parentHose)
            end

            if hose.childVehicle ~ = nil and hose.childHose ~ = nil then
                hose.childHose.parentVehicle = nil
                hose.childHose.parentHose = nil
                hose.childVehicle:disconnectHose(hose.childHose)
            end

            target.parentHose = nil
        end

        if target.adapter ~ = nil and target.adapter.isLinked ~ = nil and target.adapter.isLinked then
            hose.connectedObject:removeAllSubWashableNodes(target.adapter.node)
            delete(target.adapter.node)

            target.adapter.node = target.node
            target.adapter.refNode = target.node
            target.adapter.isLinked = false
        end

        setVisibility(hose.visibilityNode, false )
        ObjectChangeUtil.setObjectChanges(target.objectChanges, false , hose.connectedObject, hose.connectedObject.setMovingToolDirty)
        ObjectChangeUtil.setObjectChanges(hose.objectChanges, false , target.connectedObject, target.connectedObject.setMovingToolDirty)

        g_connectionHoseManager:closeSocket(hose.socket)
        g_connectionHoseManager:closeSocket(target.socket)

        target.connectedObject = nil
        hose.connectedObject = nil
        hose.targetHose = nil

        table.removeElement(spec.updateableHoses, hose)

        if self.isClient then
            local sample = spec.samples.disconnect[hose.type ]
            if sample ~ = nil then
                if not g_soundManager:getIsSamplePlaying(sample) then
                    g_soundManager:playSample(sample)
                end
            end
        end
    end
end

```

### getCenterPointAngle

**Description**

**Definition**

> getCenterPointAngle()

**Arguments**

| any | node          |
|-----|---------------|
| any | cX            |
| any | cY            |
| any | cZ            |
| any | eX            |
| any | eY            |
| any | eZ            |
| any | useWorldSpace |

**Code**

```lua
function ConnectionHoses:getCenterPointAngle(node, cX, cY, cZ, eX, eY, eZ, useWorldSpace)
    local lengthStartToCenter = MathUtil.vector3Length(cX, cY, cZ)
    local lengthCenterToEnd = math.abs( MathUtil.vector3Length(cX - eX, cY - eY, cZ - eZ))

    local _, sY, _ = getWorldTranslation(node)
    if useWorldSpace then
        _, cY, _ = localToWorld(node, cX, cY, cZ)
        _, eY, _ = localToWorld(node, eX, eY, eZ)
    else
            sY = 0
        end

        local lengthStartToCenter2 = sY - cY
        local lengthCenterToEnd2 = eY - cY

        local angle1 = math.acos(lengthStartToCenter2 / lengthStartToCenter)
        local angle2 = math.acos(lengthCenterToEnd2 / lengthCenterToEnd)

        return angle1, angle2
    end

```

### getCenterPointAngleRegulation

**Description**

**Definition**

> getCenterPointAngleRegulation()

**Arguments**

| any | node          |
|-----|---------------|
| any | cX            |
| any | cY            |
| any | cZ            |
| any | eX            |
| any | eY            |
| any | eZ            |
| any | angle1        |
| any | angle2        |
| any | targetAngle   |
| any | useWorldSpace |

**Code**

```lua
function ConnectionHoses:getCenterPointAngleRegulation(node, cX, cY, cZ, eX, eY, eZ, angle1, angle2, targetAngle, useWorldSpace)
    local sX, sY, sZ = getWorldTranslation(node)
    if useWorldSpace then
        local _
        cX, _, cZ = localToWorld(node, cX, cY, cZ)
        eX, _, eZ = localToWorld(node, eX, eY, eZ)
    else
            sX, sY, sZ = 0 , 0 , 0
        end

        local startCenterLength = MathUtil.vector2Length(sX - cX, sZ - cZ)
        local centerEndLength = MathUtil.vector2Length(eX - cX, eZ - cZ)

        local pct = angle1 / (angle1 + angle2)
        local alpha = math.pi * 0.5 - (pct * targetAngle)

        local newY1 = math.tan(alpha) * startCenterLength
        local newY2 = math.tan(alpha) * centerEndLength

        local newY = (newY1 + newY2) / 2

        if useWorldSpace then
            return worldToLocal(node, cX, sY - newY, cZ)
        else
                return cX, sY - newY, cZ
            end
        end

```

### getClonedSkipHoseNode

**Description**

**Definition**

> getClonedSkipHoseNode()

**Arguments**

| any | sourceHose |
|-----|------------|
| any | skipNode   |

**Code**

```lua
function ConnectionHoses:getClonedSkipHoseNode(sourceHose, skipNode)
    local clonedHose = { }

    clonedHose.isClonedSkipNodeHose = true

    clonedHose.type = sourceHose.type
    clonedHose.specType = sourceHose.specType
    clonedHose.hoseType = sourceHose.hoseType
    clonedHose.node = skipNode.node

    clonedHose.component = self:getParentComponent(skipNode.node)
    clonedHose.lastVelY = 0
    clonedHose.lastVelZ = 0
    clonedHose.dampingRange = 0.05
    clonedHose.dampingFactor = 50

    clonedHose.minDeltaYComponent = self:getParentComponent(skipNode.node)
    clonedHose.minDeltaY = math.huge

    clonedHose.length = skipNode.length or sourceHose.length
    clonedHose.diameter = sourceHose.diameter
    clonedHose.isTwoPointHose = skipNode.isTwoPointHose

    clonedHose.material = sourceHose.material

    local hose, startStraightening, endStraightening, minCenterPointAngle = g_connectionHoseManager:getClonedHoseNode(clonedHose.type , clonedHose.hoseType, clonedHose.length, clonedHose.diameter, clonedHose.material, self.customEnvironment)

    if hose ~ = nil then
        link(clonedHose.node, hose)
        setTranslation(hose, 0 , 0 , 0 )
        setRotation(hose, 0 , 0 , 0 )

        clonedHose.hoseNode = hose
        clonedHose.visibilityNode = hose
        clonedHose.startStraightening = startStraightening
        clonedHose.endStraightening = endStraightening
        clonedHose.endStraighteningBase = endStraightening
        clonedHose.endStraighteningDirectionBase = { 0 , 0 , 1 }
        clonedHose.endStraighteningDirection = clonedHose.endStraighteningDirectionBase
        clonedHose.minCenterPointAngle = minCenterPointAngle

        setVisibility(clonedHose.visibilityNode, false )
    else
            Logging.xmlWarning( self.xmlFile, "Unable to find connection hose with length '%.2f' and diameter '%.2f' in '%s'" , clonedHose.length, clonedHose.diameter, "skipHoseClone" )
            return false
        end

        clonedHose.objectChanges = { }

        return clonedHose
    end

```

### getConnectionHoseConfigIndex

**Description**

**Definition**

> getConnectionHoseConfigIndex()

**Code**

```lua
function ConnectionHoses:getConnectionHoseConfigIndex()
    return 1
end

```

### getConnectionHosesByInputAttacherJoint

**Description**

**Definition**

> getConnectionHosesByInputAttacherJoint()

**Arguments**

| any | inputJointDescIndex |
|-----|---------------------|

**Code**

```lua
function ConnectionHoses:getConnectionHosesByInputAttacherJoint(inputJointDescIndex)
    local spec = self.spec_connectionHoses

    if spec.hoseNodesByInputAttacher[inputJointDescIndex] ~ = nil then
        return spec.hoseNodesByInputAttacher[inputJointDescIndex]
    end

    return { }
end

```

### getConnectionTarget

**Description**

**Definition**

> getConnectionTarget()

**Arguments**

| any | attacherJointIndex     |
|-----|------------------------|
| any | type                   |
| any | specType               |
| any | excludeToolConnections |

**Code**

```lua
function ConnectionHoses:getConnectionTarget(attacherJointIndex, type , specType, excludeToolConnections)
    local spec = self.spec_connectionHoses
    if #spec.targetNodes = = 0 and #spec.hoseSkipNodes = = 0 then
        return nil
    end

    local nodes = spec.targetNodesByType[ type ]
    if nodes ~ = nil then
        for _, node in ipairs(nodes) do
            if node.attacherJointIndices[attacherJointIndex] ~ = nil then
                if node.specType = = specType then
                    if not self:getIsConnectionTargetUsed(node) then
                        local toolConnectionHose = spec.targetNodeToToolConnection[node.index]
                        if toolConnectionHose ~ = nil and excludeToolConnections ~ = nil and excludeToolConnections then
                            if toolConnectionHose.delayedMounting = = nil then
                                return nil
                            end
                        end

                        return node, false
                    end
                end
            end
        end
    end

    nodes = spec.hoseSkipNodeByType[ type ]
    if nodes ~ = nil then
        for _, node in ipairs(nodes) do
            if node.specType = = specType then
                if self:getIsSkipNodeAvailable(node) then
                    return node, true
                end
            end
        end
    end

    return nil
end

```

### getIsConnectionHoseUsed

**Description**

**Definition**

> getIsConnectionHoseUsed()

**Arguments**

| any | desc |
|-----|------|

**Code**

```lua
function ConnectionHoses:getIsConnectionHoseUsed(desc)
    return desc.connectedObject ~ = nil
end

```

### getIsConnectionTargetUsed

**Description**

**Definition**

> getIsConnectionTargetUsed()

**Arguments**

| any | desc |
|-----|------|

**Code**

```lua
function ConnectionHoses:getIsConnectionTargetUsed(desc)
    return desc.connectedObject ~ = nil
end

```

### getIsSkipNodeAvailable

**Description**

**Definition**

> getIsSkipNodeAvailable()

**Arguments**

| any | skipNode |
|-----|----------|

**Code**

```lua
function ConnectionHoses:getIsSkipNodeAvailable(skipNode)
    if self.getAttacherVehicle = = nil then
        return false
    end

    local attacherVehicle = self:getAttacherVehicle()
    if attacherVehicle ~ = nil then
        local attacherJointIndex = attacherVehicle:getAttacherJointIndexFromObject( self )
        local implement = attacherVehicle:getImplementFromAttacherJointIndex(attacherJointIndex)

        if implement.inputJointDescIndex = = skipNode.inputAttacherJointIndex then
            return attacherVehicle:getConnectionTarget(attacherJointIndex, skipNode.type , skipNode.specType, true ) ~ = nil and skipNode.parentHose = = nil
        end
    end

    return false
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function ConnectionHoses.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "ConnectionHoses" )

    schema:register(XMLValueType.FLOAT, "vehicle.connectionHoses#maxUpdateDistance" , "Max.distance to vehicle root to update connection hoses" , ConnectionHoses.DEFAULT_MAX_UPDATE_DISTANCE)

    ConnectionHoses.registerConnectionHoseXMLPaths(schema, "vehicle.connectionHoses" )
    ConnectionHoses.registerConnectionHoseXMLPaths(schema, "vehicle.connectionHoses.connectionHoseConfigurations.connectionHoseConfiguration(?)" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.connectionHoses.sounds" , "connect(?)" )
    schema:register(XMLValueType.STRING, "vehicle.connectionHoses.sounds.connect(?)#type" , "Connection hose type" )

    SoundManager.registerSampleXMLPaths(schema, "vehicle.connectionHoses.sounds" , "disconnect(?)" )
    schema:register(XMLValueType.STRING, "vehicle.connectionHoses.sounds.disconnect(?)#type" , "Connection hose type" )

    schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".connectionHoses#customHoseIndices" , "Custom hoses to update" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".connectionHoses#customTargetIndices" , "Custom hose targets to update" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".connectionHoses#localHoseIndices" , "Local hoses to update" )
    end )

    schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".connectionHoses#customHoseIndices" , "Custom hoses to update" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".connectionHoses#customTargetIndices" , "Custom hose targets to update" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".connectionHoses#localHoseIndices" , "Local hoses to update" )
    end )

    schema:setXMLSpecializationType()
end

```

### iterateConnectionTargets

**Description**

**Definition**

> iterateConnectionTargets()

**Arguments**

| any | func                   |
|-----|------------------------|
| any | attacherJointIndex     |
| any | type                   |
| any | specType               |
| any | excludeToolConnections |

**Code**

```lua
function ConnectionHoses:iterateConnectionTargets(func, attacherJointIndex, type , specType, excludeToolConnections)
    local spec = self.spec_connectionHoses
    if #spec.targetNodes = = 0 and #spec.hoseSkipNodes = = 0 then
        return nil
    end

    local nodes = spec.targetNodesByType[ type ]
    if nodes ~ = nil then
        for _, node in ipairs(nodes) do
            if node.attacherJointIndices[attacherJointIndex] ~ = nil then
                if node.specType = = specType then
                    if not self:getIsConnectionTargetUsed(node) then
                        local toolConnectionHose = spec.targetNodeToToolConnection[node.index]
                        if toolConnectionHose ~ = nil and excludeToolConnections ~ = nil and excludeToolConnections then
                            if toolConnectionHose.delayedMounting = = nil then
                                return nil
                            end
                        end

                        if not func(node, false ) then
                            break
                        end
                    end
                end
            end
        end
    end

    nodes = spec.hoseSkipNodeByType[ type ]
    if nodes ~ = nil then
        for _, node in ipairs(nodes) do
            if node.specType = = specType then
                if self:getIsSkipNodeAvailable(node) then
                    if not func(node, true ) then
                        break
                    end
                end
            end
        end
    end

    return nil
end

```

### loadConnectionHosesFromXML

**Description**

**Definition**

> loadConnectionHosesFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function ConnectionHoses:loadConnectionHosesFromXML(xmlFile, key)
    local spec = self.spec_connectionHoses

    xmlFile:iterate(key .. ".skipNode" , function (_, hoseKey)
        local entry = { }
        if self:loadHoseSkipNode(xmlFile, hoseKey, entry) then
            table.insert(spec.hoseSkipNodes, entry)

            if spec.hoseSkipNodeByType[entry.type ] = = nil then
                spec.hoseSkipNodeByType[entry.type ] = { }
            end

            table.insert(spec.hoseSkipNodeByType[entry.type ], entry)
        end
    end )

    self:addHoseTargetNodes(xmlFile, key .. ".target" )

    xmlFile:iterate(key .. ".toolConnectorHose" , function (_, hoseKey)
        local entry = { }
        if self:loadToolConnectorHoseNode(xmlFile, hoseKey, entry) then
            table.insert(spec.toolConnectorHoses, entry)

            spec.targetNodeToToolConnection[entry.startTargetNodeIndex] = entry
            spec.targetNodeToToolConnection[entry.endTargetNodeIndex] = entry
        end
    end )

    xmlFile:iterate(key .. ".hose" , function (_, hoseKey)
        local entry = { }
        if self:loadHoseNode(xmlFile, hoseKey, entry, true ) then
            table.insert(spec.hoseNodes, entry)
            entry.index = #spec.hoseNodes

            for _, index in pairs(entry.inputAttacherJointIndices) do
                if spec.hoseNodesByInputAttacher[index] = = nil then
                    spec.hoseNodesByInputAttacher[index] = { }
                end

                table.insert(spec.hoseNodesByInputAttacher[index], entry)
            end
        end
    end )

    xmlFile:iterate(key .. ".localHose" , function (_, hoseKey)
        local hose = { }
        if self:loadHoseNode(xmlFile, hoseKey .. ".hose" , hose, false ) then

            local target = { }
            if self:loadHoseTargetNode(xmlFile, hoseKey .. ".target" , target) then
                table.insert(spec.localHoseNodes, { hose = hose, target = target } )
            end
        end
    end )

    self:loadCustomHosesFromXML( true , spec.customHoses, spec.customHosesByAttacher, spec.customHosesByInputAttacher, xmlFile, key .. ".customHose" )

    self:loadCustomHosesFromXML( false , spec.customHoseTargets, spec.customHoseTargetsByAttacher, spec.customHoseTargetsByInputAttacher, xmlFile, key .. ".customTarget" )
end

```

### loadCustomHosesFromXML

**Description**

**Definition**

> loadCustomHosesFromXML()

**Arguments**

| any | isHose                    |
|-----|---------------------------|
| any | targetTable               |
| any | attacherJointMapping      |
| any | inputAttacherJointMapping |
| any | xmlFile                   |
| any | key                       |

**Code**

```lua
function ConnectionHoses:loadCustomHosesFromXML(isHose, targetTable, attacherJointMapping, inputAttacherJointMapping, xmlFile, key)
    xmlFile:iterate(key, function (_, customKey)
        local entry = { }
        entry.node = xmlFile:getValue(customKey .. "#node" , nil , self.components, self.i3dMappings)
        if entry.node ~ = nil then
            entry.type = xmlFile:getValue(customKey .. "#type" )
            if entry.type ~ = nil then
                entry.type = string.upper(entry.type )

                entry.inputAttacherJointIndices = { }
                local inputAttacherJointIndices = xmlFile:getValue(customKey .. "#inputAttacherJointIndices" , nil , true )
                if inputAttacherJointIndices ~ = nil then
                    for _, v in ipairs(inputAttacherJointIndices) do
                        entry.inputAttacherJointIndices[v] = v

                        if inputAttacherJointMapping[v] = = nil then
                            inputAttacherJointMapping[v] = { }
                        end

                        table.insert(inputAttacherJointMapping[v], entry)
                    end
                end

                entry.attacherJointIndices = { }
                local attacherJointIndices = xmlFile:getValue(customKey .. "#attacherJointIndices" , nil , true )
                if attacherJointIndices ~ = nil then
                    for _, v in ipairs(attacherJointIndices) do
                        entry.attacherJointIndices[v] = v

                        if attacherJointMapping[v] = = nil then
                            attacherJointMapping[v] = { }
                        end

                        table.insert(attacherJointMapping[v], entry)
                    end
                end

                if isHose then
                    entry.isActiveDirty = xmlFile:getValue(customKey .. "#isActiveDirty" , false )
                    if entry.isActiveDirty then
                        table.insert( self.spec_connectionHoses.customHosesActiveDirty, entry)
                    end

                    entry.startTranslation = { getTranslation(entry.node) }
                    entry.startRotation = { getRotation(entry.node) }
                end

                if next(entry.inputAttacherJointIndices) = = nil and next(entry.attacherJointIndices) = = nil then
                    Logging.xmlWarning(xmlFile, "Missing inputAttacherJointIndices for custom hose '%s'" , customKey)
                        return false
                    end

                    entry.objectChanges = { }
                    ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, customKey, entry.objectChanges, self.components, self )
                    ObjectChangeUtil.setObjectChanges(entry.objectChanges, false , self , self.setMovingToolDirty, true )
                    entry.objectChangesTarget = self

                    entry.isActive = false

                    table.insert(targetTable, entry)
                else
                        Logging.xmlWarning(xmlFile, "Missing type for custom hose '%s'" , customKey)
                        end
                    else
                            Logging.xmlWarning(xmlFile, "Missing node for custom hose '%s'" , customKey)
                            end
                        end )
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
function ConnectionHoses:loadExtraDependentParts(superFunc, xmlFile, baseName, entry)
    if not superFunc( self , xmlFile, baseName, entry) then
        return false
    end

    local customHoseIndices = xmlFile:getValue(baseName .. ".connectionHoses#customHoseIndices" , nil , true )
    if customHoseIndices ~ = nil and #customHoseIndices > 0 then
        entry.customHoseIndices = customHoseIndices
    end

    local customTargetIndices = xmlFile:getValue(baseName .. ".connectionHoses#customTargetIndices" , nil , true )
    if customTargetIndices ~ = nil and #customTargetIndices > 0 then
        entry.customTargetIndices = customTargetIndices
    end

    local localHoseIndices = xmlFile:getValue(baseName .. ".connectionHoses#localHoseIndices" , nil , true )
    if localHoseIndices ~ = nil and #localHoseIndices > 0 then
        entry.localHoseIndices = localHoseIndices
    end

    return true
end

```

### loadHoseNode

**Description**

**Definition**

> loadHoseNode()

**Arguments**

| any | xmlFile    |
|-----|------------|
| any | hoseKey    |
| any | entry      |
| any | isBaseHose |

**Code**

```lua
function ConnectionHoses:loadHoseNode(xmlFile, hoseKey, entry, isBaseHose)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, hoseKey .. "#color" , hoseKey .. "#materialTemplateName" ) -- FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, hoseKey .. "#socketColor" , hoseKey .. "#socketMaterialTemplateName" ) -- FS22 to FS25

    entry.inputAttacherJointIndices = { }

    local inputAttacherJointIndices = xmlFile:getValue(hoseKey .. "#inputAttacherJointIndices" , nil , true )
    if inputAttacherJointIndices ~ = nil then
        for _, inputAttacherJointIndex in ipairs(inputAttacherJointIndices) do
            entry.inputAttacherJointIndices[inputAttacherJointIndex] = inputAttacherJointIndex
        end
    end

    local inputAttacherJointNodes = xmlFile:getValue(hoseKey .. "#inputAttacherJointNodes" , nil , self.components, self.i3dMappings, true )
    if inputAttacherJointNodes ~ = nil then
        for _, node in ipairs(inputAttacherJointNodes) do
            local inputAttacherJointIndex = self:getInputAttacherJointIndexByNode(node)
            if inputAttacherJointIndex ~ = nil then
                entry.inputAttacherJointIndices[inputAttacherJointIndex] = inputAttacherJointIndex
            end
        end
    end

    entry.type = xmlFile:getValue(hoseKey .. "#type" )
    entry.specType = xmlFile:getValue(hoseKey .. "#specType" )
    if entry.type = = nil then
        Logging.xmlWarning(xmlFile, "Missing type attribute in '%s'" , hoseKey)
        return false
    end

    entry.hoseType = xmlFile:getValue(hoseKey .. "#hoseType" , "DEFAULT" )
    entry.node = xmlFile:getValue(hoseKey .. "#node" , nil , self.components, self.i3dMappings)
    if entry.node = = nil then
        Logging.xmlWarning(xmlFile, "Missing node for connection hose '%s'" , hoseKey)
            return false
        end

        if isBaseHose then
            local spec = self.spec_connectionHoses
            local type = entry.type .. (entry.specType or "" )
            if spec.numHosesByType[ type ] = = nil then
                spec.numHosesByType[ type ] = 0
            end
            spec.numHosesByType[ type ] = spec.numHosesByType[ type ] + 1
            entry.typedIndex = spec.numHosesByType[ type ]
        end

        entry.isTwoPointHose = xmlFile:getValue(hoseKey .. "#isTwoPointHose" , false )
        entry.isWorldSpaceHose = xmlFile:getValue(hoseKey .. "#isWorldSpaceHose" , true )

        entry.component = self:getParentComponent(entry.node)
        entry.lastVelY = 0
        entry.lastVelZ = 0
        entry.dampingRange = xmlFile:getValue(hoseKey .. "#dampingRange" , 0.05 )
        entry.dampingFactor = xmlFile:getValue(hoseKey .. "#dampingFactor" , 50 )

        entry.length = xmlFile:getValue(hoseKey .. "#length" , 3 )
        entry.dynamicLength = xmlFile:getValue(hoseKey .. "#dynamicLength" , false )
        entry.diameter = xmlFile:getValue(hoseKey .. "#diameter" , 0.02 )
        entry.straighteningFactor = xmlFile:getValue(hoseKey .. "#straighteningFactor" , 1 )
        entry.centerPointDropFactor = xmlFile:getValue(hoseKey .. "#centerPointDropFactor" , 1 )
        entry.centerPointTension = xmlFile:getValue(hoseKey .. "#centerPointTension" , 0 )
        entry.minCenterPointAngle = xmlFile:getValue(hoseKey .. "#minCenterPointAngle" )

        entry.minCenterPointOffset = xmlFile:getValue(hoseKey .. "#minCenterPointOffset" , nil , true )
        entry.maxCenterPointOffset = xmlFile:getValue(hoseKey .. "#maxCenterPointOffset" , nil , true )

        if entry.minCenterPointOffset ~ = nil and entry.maxCenterPointOffset ~ = nil then
            for i = 1 , 3 do
                if entry.minCenterPointOffset[i] = = 0 then
                    entry.minCenterPointOffset[i] = - math.huge
                end

                if entry.maxCenterPointOffset[i] = = 0 then
                    entry.maxCenterPointOffset[i] = math.huge
                end
            end

            for i = 1 , 3 do
                if entry.maxCenterPointOffset[i] < entry.minCenterPointOffset[i] or entry.minCenterPointOffset[i] > entry.maxCenterPointOffset[i] then
                    entry.minCenterPointOffset = nil
                    entry.maxCenterPointOffset = nil
                    Logging.xmlWarning(xmlFile, "Invalid centerPointOffset in '%s'.Max is smaller than min or min is greater than max." , hoseKey)
                    break
                end
            end
        end

        entry.minDeltaY = xmlFile:getValue(hoseKey .. "#minDeltaY" , math.huge)
        entry.minDeltaYComponent = xmlFile:getValue(hoseKey .. "#minDeltaYComponent" , entry.component, self.components, self.i3dMappings)

        entry.material = xmlFile:getValue(hoseKey .. "#materialTemplateName" , nil , self.customEnvironment)
        entry.adapterMaterial = xmlFile:getValue(hoseKey .. "#adapterMaterialTemplateName" , nil , self.customEnvironment)

        entry.adapterName = xmlFile:getValue(hoseKey .. "#adapterType" )
        entry.outgoingAdapter = xmlFile:getValue(hoseKey .. "#outgoingAdapter" )

        entry.adapterNode = xmlFile:getValue(hoseKey .. "#adapterNode" , nil , self.components, self.i3dMappings)
        if entry.adapterNode ~ = nil then
            local node = g_connectionHoseManager:getClonedAdapterNode(entry.type , entry.adapterName or "DEFAULT" , self.customEnvironment, true )
            if node ~ = nil then
                if entry.adapterMaterial ~ = nil then
                    entry.adapterMaterial:apply(node, "connector_color_mat" )
                end

                link(entry.adapterNode, node)
            else
                    Logging.xmlWarning(xmlFile, "Unable to find detached adapter for type '%s' in '%s'" , entry.adapterName or "DEFAULT" , hoseKey)
                    end
                end

                local socketName = xmlFile:getValue(hoseKey .. "#socket" )
                if socketName ~ = nil then
                    local socketMaterial = xmlFile:getValue(hoseKey .. "#socketMaterialTemplateName" , nil , self.customEnvironment)
                    entry.socket = g_connectionHoseManager:linkSocketToNode(socketName, entry.node, self.customEnvironment, socketMaterial)
                    if entry.socket ~ = nil then
                        setRotation(entry.socket.node, 0 , math.pi, 0 )
                    end
                end

                local hose, startStraightening, endStraightening, minCenterPointAngle = g_connectionHoseManager:getClonedHoseNode(entry.type , entry.hoseType, entry.length, entry.diameter, entry.material, self.customEnvironment)

                if hose ~ = nil then
                    local outgoingNode, visibilityNode = g_connectionHoseManager:getSocketTarget(entry.socket, entry.node), hose
                    local rx, ry, rz = 0 , 0 , 0
                    if entry.outgoingAdapter ~ = nil then
                        local node, referenceNode = g_connectionHoseManager:getClonedAdapterNode(entry.type , entry.outgoingAdapter, self.customEnvironment)
                        if node ~ = nil then
                            if entry.adapterMaterial ~ = nil then
                                entry.adapterMaterial:apply(node, "connector_color_mat" )
                            end

                            link(outgoingNode, node)
                            outgoingNode = referenceNode
                            visibilityNode = node
                            ry = math.pi

                            if entry.socket = = nil then
                                setRotation(node, 0 , ry, 0 )
                            end
                        else
                                Logging.xmlWarning(xmlFile, "Unable to find adapter type '%s' in '%s'" , entry.outgoingAdapter, hoseKey)
                            end
                        end

                        link(outgoingNode, hose)
                        setTranslation(hose, 0 , 0 , 0 )
                        setRotation(hose, rx, ry, rz)

                        entry.hoseNode = hose
                        entry.visibilityNode = visibilityNode
                        entry.startStraightening = startStraightening * entry.straighteningFactor
                        entry.endStraightening = endStraightening
                        entry.endStraighteningBase = endStraightening
                        entry.endStraighteningDirectionBase = { 0 , 0 , 1 }
                        entry.endStraighteningDirection = entry.endStraighteningDirectionBase
                        entry.minCenterPointAngle = entry.minCenterPointAngle or minCenterPointAngle

                        setVisibility(entry.visibilityNode, false )
                    else
                            Logging.xmlWarning(xmlFile, "Unable to find connection hose with length '%.2f' and diameter '%.2f' in '%s'" , entry.length, entry.diameter, hoseKey)
                            return false
                        end

                        entry.objectChanges = { }
                        ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, hoseKey, entry.objectChanges, self.components, self )
                        ObjectChangeUtil.setObjectChanges(entry.objectChanges, false , self , self.setMovingToolDirty, true )

                        return true
                    end

```

### loadHoseSkipNode

**Description**

**Definition**

> loadHoseSkipNode()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | targetKey |
| any | entry     |

**Code**

```lua
function ConnectionHoses:loadHoseSkipNode(xmlFile, targetKey, entry)
    entry.node = xmlFile:getValue(targetKey .. "#node" , nil , self.components, self.i3dMappings)

    if entry.node = = nil then
        Logging.xmlWarning(xmlFile, "Missing node for hose skip node '%s'" , targetKey)
            return false
        end

        entry.inputAttacherJointIndex = xmlFile:getValue(targetKey .. "#inputAttacherJointIndex" , 1 )
        entry.attacherJointIndex = xmlFile:getValue(targetKey .. "#attacherJointIndex" , 1 )

        entry.type = xmlFile:getValue(targetKey .. "#type" )
        entry.specType = xmlFile:getValue(targetKey .. "#specType" )

        if entry.type = = nil then
            Logging.xmlWarning(xmlFile, "Missing type for hose skip node '%s'" , targetKey)
                return false
            end

            entry.length = xmlFile:getValue(targetKey .. "#length" )
            entry.isTwoPointHose = xmlFile:getValue(targetKey .. "#isTwoPointHose" , false )

            entry.isSkipNode = true

            return true
        end

```

### loadHoseTargetNode

**Description**

**Definition**

> loadHoseTargetNode()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | targetKey |
| any | entry     |

**Code**

```lua
function ConnectionHoses:loadHoseTargetNode(xmlFile, targetKey, entry)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, targetKey .. "#socketColor" , targetKey .. "#socketMaterialTemplateName" ) -- FS22 to FS25

    entry.node = xmlFile:getValue(targetKey .. "#node" , nil , self.components, self.i3dMappings)

    if entry.node = = nil then
        Logging.xmlWarning(xmlFile, "Missing node for connection hose target '%s'" , targetKey)
            return false
        end

        entry.attacherJointIndices = { }

        local attacherJointIndices = xmlFile:getValue(targetKey .. "#attacherJointIndices" , nil , true )
        if attacherJointIndices ~ = nil then
            for _, attacherJointIndex in ipairs(attacherJointIndices) do
                entry.attacherJointIndices[attacherJointIndex] = attacherJointIndex
            end
        end

        local attacherJointNodes = xmlFile:getValue(targetKey .. "#attacherJointNodes" , nil , self.components, self.i3dMappings, true )
        if attacherJointNodes ~ = nil then
            for _, node in ipairs(attacherJointNodes) do
                local attacherJointIndex = self:getAttacherJointIndexByNode(node)
                if attacherJointIndex ~ = nil then
                    entry.attacherJointIndices[attacherJointIndex] = attacherJointIndex
                end
            end
        end

        entry.type = xmlFile:getValue(targetKey .. "#type" )
        entry.specType = xmlFile:getValue(targetKey .. "#specType" )
        entry.straighteningFactor = xmlFile:getValue(targetKey .. "#straighteningFactor" , 1 )
        entry.straighteningDirection = xmlFile:getValue(targetKey .. "#straighteningDirection" , nil , true )

        local socketName = xmlFile:getValue(targetKey .. "#socket" )
        if socketName ~ = nil then
            local socketMaterial = xmlFile:getValue(targetKey .. "#socketMaterialTemplateName" , nil , self.customEnvironment)
            entry.socket = g_connectionHoseManager:linkSocketToNode(socketName, entry.node, self.customEnvironment, socketMaterial)
        end

        if entry.type ~ = nil then
            entry.adapterName = xmlFile:getValue(targetKey .. "#adapterType" , "DEFAULT" )

            -- empty adapter with target node as reference
            -- will be replaced with the real adapter on connecting
            if entry.adapter = = nil then
                entry.adapter = { }
                entry.adapter.node = entry.node
                entry.adapter.refNode = entry.node
            end

            entry.objectChanges = { }
            ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, targetKey, entry.objectChanges, self.components, self )
            ObjectChangeUtil.setObjectChanges(entry.objectChanges, false , self , self.setMovingToolDirty, true )
        else
                Logging.xmlWarning(xmlFile, "Missing type for '%s'" , targetKey)
                    return false
                end

                return true
            end

```

### loadToolConnectorHoseNode

**Description**

**Definition**

> loadToolConnectorHoseNode()

**Arguments**

| any | xmlFile   |
|-----|-----------|
| any | targetKey |
| any | entry     |

**Code**

```lua
function ConnectionHoses:loadToolConnectorHoseNode(xmlFile, targetKey, entry)
    local spec = self.spec_connectionHoses

    local key = string.format( "%s.startTarget" , targetKey)
    entry.startTargetNodeIndex = self:addHoseTargetNodes(xmlFile, key)

    if entry.startTargetNodeIndex = = nil then
        Logging.xmlWarning(xmlFile, "startTarget is missing for tool connection hose '%s'" , targetKey)
            return false
        end

        key = string.format( "%s.endTarget" , targetKey)
        entry.endTargetNodeIndex = self:addHoseTargetNodes(xmlFile, key)

        if entry.endTargetNodeIndex = = nil then
            Logging.xmlWarning(xmlFile, "endTarget is missing for tool connection hose '%s'" , targetKey)
                return false
            end

            local startTarget = spec.targetNodes[entry.startTargetNodeIndex]
            local endTarget = spec.targetNodes[entry.endTargetNodeIndex]

            for index, _ in pairs(startTarget.attacherJointIndices) do
                if endTarget.attacherJointIndices[index] ~ = nil then
                    Logging.xmlWarning(xmlFile, "Double usage of attacher joint index '%d' in '%s'" , index, targetKey)
                end
            end

            entry.moveNodes = xmlFile:getValue(targetKey .. "#moveNodes" , true )
            entry.additionalHose = xmlFile:getValue(targetKey .. "#additionalHose" , true )

            -- make sure the two nodes are pointing towards each other
            if entry.moveNodes then
                local x1, y1, z1 = getTranslation(startTarget.node)
                local x2, y2, z2 = getTranslation(endTarget.node)
                local dirX, dirY, dirZ = MathUtil.vector3Normalize(x1 - x2, y1 - y2, z1 - z2)
                local upX, upY, upZ = localDirectionToLocal(endTarget.node, getParent(endTarget.node), 0 , 1 , 0 )
                if (dirX ~ = 0 or dirY ~ = 0 or dirZ ~ = 0 )
                    and not MathUtil.isNan(dirX) and not MathUtil.isNan(dirY) and not MathUtil.isNan(dirZ) then
                    setDirection(startTarget.node, - dirX, - dirY, - dirZ, upX, upY, upZ)
                    setDirection(endTarget.node, dirX, dirY, dirZ, upX, upY, upZ)
                end
            end

            entry.mountingNode = xmlFile:getValue(targetKey .. "#mountingNode" , nil , self.components, self.i3dMappings)

            if entry.mountingNode ~ = nil then
                setVisibility(entry.mountingNode, false )
            end

            entry.objectChanges = { }
            ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, targetKey, entry.objectChanges, self.components, self )
            ObjectChangeUtil.setObjectChanges(entry.objectChanges, false , self , self.setMovingToolDirty, true )
            entry.objectChangesTarget = self

            local type = spec.targetNodes[entry.startTargetNodeIndex].type .. (spec.targetNodes[entry.startTargetNodeIndex].specType or "" )
            if spec.numToolConnectionsByType[ type ] = = nil then
                spec.numToolConnectionsByType[ type ] = 0
            end
            spec.numToolConnectionsByType[ type ] = spec.numToolConnectionsByType[ type ] + 1
            entry.typedIndex = spec.numToolConnectionsByType[ type ]

            entry.connected = false

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
function ConnectionHoses:onDelete()
    local spec = self.spec_connectionHoses
    if spec.additionalSharedLoadRequestIds ~ = nil then
        for i = 1 , #spec.additionalSharedLoadRequestIds do
            g_i3DManager:releaseSharedI3DFile(spec.additionalSharedLoadRequestIds[i])
        end

        spec.additionalSharedLoadRequestIds = nil
    end

    if spec.toolConnectionHoseMounts ~ = nil then
        for _, toolConnectionHoseMount in pairs(spec.toolConnectionHoseMounts) do
            toolConnectionHoseMount:delete()
        end
        spec.toolConnectionHoseMounts = nil
    end

    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.connect)
        g_soundManager:deleteSamples(spec.samples.disconnect)
    end
end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function ConnectionHoses:onLoadFinished(savegame)
    local spec = self.spec_connectionHoses

    -- connection local hoses
    for _, localHoseNode in ipairs(spec.localHoseNodes) do
        self:connectHose(localHoseNode.hose, self , localHoseNode.target, false )
    end
end

```

### onPostAttach

**Description**

**Definition**

> onPostAttach()

**Arguments**

| any | attacherVehicle     |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |

**Code**

```lua
function ConnectionHoses:onPostAttach(attacherVehicle, inputJointDescIndex, jointDescIndex)
    if self.spec_connectionHoses.connectionHosesActive then
        self:connectHosesToAttacherVehicle(attacherVehicle, inputJointDescIndex, jointDescIndex)
        self:connectCustomHosesToAttacherVehicle(attacherVehicle, inputJointDescIndex, jointDescIndex)
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
function ConnectionHoses:onPostLoad(savegame)
    local spec = self.spec_connectionHoses

    local configKey = string.format( "vehicle.connectionHoses.connectionHoseConfigurations.connectionHoseConfiguration(%d)" , spec.configIndex - 1 )

    self:loadConnectionHosesFromXML( self.xmlFile, "vehicle.connectionHoses" )

    if self.xmlFile:hasProperty(configKey) then
        self:loadConnectionHosesFromXML( self.xmlFile, configKey)
    end

    ConnectionHoses.registerAdditionalToolConnectionHoses( self )

    spec.targetNodesAvailable = #spec.targetNodes > 0
    spec.hoseNodesAvailable = #spec.hoseNodes > 0
    spec.localHosesAvailable = #spec.localHoseNodes > 0
    spec.skipNodesAvailable = #spec.hoseSkipNodes > 0
    spec.activeDirtyCustomHosesAvailable = #spec.customHosesActiveDirty > 0

    spec.updateableHoses = { }

    if self.isClient then
        local function loadSamplesFromKey(key)
            local samples = { }
            local i = 0
            while true do
                local actionKey = string.format( "%s(%d)" , key, i)
                local baseKey = "vehicle.connectionHoses.sounds." .. actionKey
                if not self.xmlFile:hasProperty(baseKey) then
                    break
                end

                local sample = g_soundManager:loadSampleFromXML( self.xmlFile, "vehicle.connectionHoses.sounds" , actionKey, self.baseDirectory, self.components, 1 , AudioGroup.VEHICLE, self.i3dMappings, self )
                if sample ~ = nil then
                    local type = self.xmlFile:getValue(baseKey .. "#type" )

                    local isValid = false
                    for i, hose in ipairs(spec.hoseNodes) do
                        if hose.type = = type then
                            isValid = true
                            break
                        end
                    end

                    if isValid then
                        samples[ type ] = sample
                    else
                            Logging.xmlWarning( self.xmlFile, "Failed load %s-sound with type %s.No hose with that type available." , key, type )
                        end
                    end

                    i = i + 1
                end

                return samples
            end

            spec.samples = { }
            spec.samples.connect = loadSamplesFromKey( "connect" )
            spec.samples.disconnect = loadSamplesFromKey( "disconnect" )
        end

        if not self.isClient or( not spec.targetNodesAvailable and not spec.hoseNodesAvailable and not spec.localHosesAvailable and not spec.skipNodesAvailable and not spec.activeDirtyCustomHosesAvailable) then
            SpecializationUtil.removeEventListener( self , "onUpdateInterpolation" , ConnectionHoses )
        end
    end

```

### onPreDetach

**Description**

**Definition**

> onPreDetach()

**Arguments**

| any | attacherVehicle |
|-----|-----------------|
| any | implement       |

**Code**

```lua
function ConnectionHoses:onPreDetach(attacherVehicle, implement)
    local spec = self.spec_connectionHoses

    local inputJointDescIndex = self:getActiveInputAttacherJointDescIndex()

    local hoses = self:getConnectionHosesByInputAttacherJoint(inputJointDescIndex)
    for _, hose in ipairs(hoses) do
        self:disconnectHose(hose)
    end

    for i = #spec.updateableHoses, 1 , - 1 do
        local hose = spec.updateableHoses[i]
        if hose.connectedObject = = attacherVehicle then
            self:disconnectHose(hose)
        end
    end

    -- remove delayed mounting if we detach the implement
        local attacherVehicleSpec = attacherVehicle.spec_connectionHoses
        if attacherVehicleSpec ~ = nil then
            for _, toolConnector in pairs(attacherVehicleSpec.toolConnectorHoses) do
                if toolConnector.delayedMounting ~ = nil then
                    if toolConnector.delayedMounting.sourceObject = = self then
                        toolConnector.delayedMounting = nil
                    end
                end
            end
        end

        local customHoses = spec.customHosesByInputAttacher[inputJointDescIndex]
        if customHoses ~ = nil then
            for i = 1 , #customHoses do
                local customHose = customHoses[i]
                if customHose.isActive then
                    self:disconnectCustomHoseNode(customHose, customHose.connectedTarget)
                end
            end
        end

        local customTargets = spec.customHoseTargetsByInputAttacher[inputJointDescIndex]
        if customTargets ~ = nil then
            for i = 1 , #customTargets do
                local customTarget = customTargets[i]
                if customTarget.isActive then
                    self:disconnectCustomHoseNode(customTarget.connectedHose, customTarget)
                end
            end
        end
    end

```

### onPreLoad

**Description**

**Definition**

> onPreLoad()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function ConnectionHoses:onPreLoad(savegame)
    local spec = self.spec_connectionHoses
    spec.configIndex = self:getConnectionHoseConfigIndex()

    spec.connectionHosesActive = true

    spec.numHosesByType = { }
    spec.numToolConnectionsByType = { }

    spec.hoseSkipNodes = { }
    spec.hoseSkipNodeByType = { }

    spec.targetNodes = { }
    spec.targetNodesByType = { }

    spec.toolConnectorHoses = { }
    spec.targetNodeToToolConnection = { }

    spec.hoseNodes = { }
    spec.hoseNodesByInputAttacher = { }

    spec.localHoseNodes = { }

    spec.customHoses = { }
    spec.customHosesByAttacher = { }
    spec.customHosesByInputAttacher = { }
    spec.customHosesActiveDirty = { }

    spec.customHoseTargets = { }
    spec.customHoseTargetsByAttacher = { }
    spec.customHoseTargetsByInputAttacher = { }

    spec.additionalSharedLoadRequestIds = { }
    spec.toolConnectionHoseMounts = { }

    spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.connectionHoses#maxUpdateDistance" , ConnectionHoses.DEFAULT_MAX_UPDATE_DISTANCE)
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
function ConnectionHoses:onUpdateEnd(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    -- final update before the physics sleeps(self.currentUpdateDistance is 0 here)
    ConnectionHoses.onUpdateInterpolation( self , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
end

```

### onUpdateInterpolation

**Description**

> Called after position interpolation update

**Definition**

> onUpdateInterpolation(float dt, boolean isActiveForInput, boolean isSelected, )

**Arguments**

| float   | dt               | time since last call in ms          |
|---------|------------------|-------------------------------------|
| boolean | isActiveForInput | true if vehicle is active for input |
| boolean | isSelected       | true if vehicle is selected         |
| any     | isSelected       |                                     |

**Code**

```lua
function ConnectionHoses:onUpdateInterpolation(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_connectionHoses
    if self.currentUpdateDistance < spec.maxUpdateDistance then
        for i = 1 , #spec.updateableHoses do
            local hose = spec.updateableHoses[i]
            if self.updateLoopIndex = = hose.connectedObject.updateLoopIndex then
                self:updateConnectionHose(hose, i)
            end
        end

        for i, customHose in ipairs(spec.customHosesActiveDirty) do
            if customHose.isActive and customHose.connectedTarget ~ = nil then
                if self.updateLoopIndex = = customHose.connectedObject.updateLoopIndex then
                    self:updateCustomHoseNode(customHose, customHose.connectedTarget)
                end
            end
        end

        if self.getAttachedImplements ~ = nil then
            local impements = self:getAttachedImplements()
            for i = 1 , #impements do
                local object = impements[i].object
                if object.updateAttachedConnectionHoses ~ = nil then
                    object:updateAttachedConnectionHoses( self )
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
function ConnectionHoses.prerequisitesPresent(specializations)
    return true
end

```

### registerConnectionHoseXMLPaths

**Description**

**Definition**

> registerConnectionHoseXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function ConnectionHoses.registerConnectionHoseXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. ".skipNode(?)#node" , "Skip node" )
    schema:register(XMLValueType.INT, basePath .. ".skipNode(?)#inputAttacherJointIndex" , "Input attacher joint index" , 1 )
    schema:register(XMLValueType.INT, basePath .. ".skipNode(?)#attacherJointIndex" , "Attacher joint index" , 1 )
    schema:register(XMLValueType.STRING, basePath .. ".skipNode(?)#type" , "Connection hose type" )
    schema:register(XMLValueType.STRING, basePath .. ".skipNode(?)#specType" , "Connection hose specialization type(if defined it needs to match the type of the other tool)" )
        schema:register(XMLValueType.FLOAT, basePath .. ".skipNode(?)#length" , "Hose length" )
        schema:register(XMLValueType.BOOL, basePath .. ".skipNode(?)#isTwoPointHose" , "Is two point hose without sagging" , false )

        ConnectionHoses.registerHoseTargetNodesXMLPaths(schema, basePath .. ".target(?)" )

        schema:register(XMLValueType.NODE_INDEX, basePath .. ".toolConnectorHose(?)#mountingNode" , "Mounting node to toggle visibility" )
        schema:register(XMLValueType.BOOL, basePath .. ".toolConnectorHose(?)#moveNodes" , "Defines if the start and end nodes are moved up depending on hose diameter" , true )
        schema:register(XMLValueType.BOOL, basePath .. ".toolConnectorHose(?)#additionalHose" , "Defines if between start and end node a additional hose is created" , true )
        ConnectionHoses.registerHoseTargetNodesXMLPaths(schema, basePath .. ".toolConnectorHose(?).startTarget(?)" )
        ConnectionHoses.registerHoseTargetNodesXMLPaths(schema, basePath .. ".toolConnectorHose(?).endTarget(?)" )

        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath .. ".toolConnectorHose(?)" )

        ConnectionHoses.registerHoseNodesXMLPaths(schema, basePath .. ".hose(?)" )

        ConnectionHoses.registerHoseNodesXMLPaths(schema, basePath .. ".localHose(?).hose" )
        ConnectionHoses.registerHoseTargetNodesXMLPaths(schema, basePath .. ".localHose(?).target" )

        ConnectionHoses.registerCustomHoseNodesXMLPaths(schema, basePath .. ".customHose(?)" )
        ConnectionHoses.registerCustomHoseTargetNodesXMLPaths(schema, basePath .. ".customTarget(?)" )
    end

```

### registerCustomHoseNodesXMLPaths

**Description**

**Definition**

> registerCustomHoseNodesXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function ConnectionHoses.registerCustomHoseNodesXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Target or source node" )
    schema:register(XMLValueType.STRING, basePath .. "#type" , "Hose type which can be any string that needs to match between hose and target node" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#inputAttacherJointIndices" , "Input attacher joint indices" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#attacherJointIndices" , "Attacher joint indices" )
    schema:register(XMLValueType.BOOL, basePath .. "#isActiveDirty" , "Custom hose is permanently updated" , false )

    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
end

```

### registerCustomHoseTargetNodesXMLPaths

**Description**

**Definition**

> registerCustomHoseTargetNodesXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function ConnectionHoses.registerCustomHoseTargetNodesXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Target or source node" )
    schema:register(XMLValueType.STRING, basePath .. "#type" , "Hose type which can be any string that needs to match between hose and target node" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#inputAttacherJointIndices" , "Input attacher joint indices" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#attacherJointIndices" , "Attacher joint indices" )

    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
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
function ConnectionHoses.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onLoadFinished" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateInterpolation" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateEnd" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttach" , ConnectionHoses )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetach" , ConnectionHoses )
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
function ConnectionHoses.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getConnectionHoseConfigIndex" , ConnectionHoses.getConnectionHoseConfigIndex)
    SpecializationUtil.registerFunction(vehicleType, "updateAttachedConnectionHoses" , ConnectionHoses.updateAttachedConnectionHoses)
    SpecializationUtil.registerFunction(vehicleType, "updateConnectionHose" , ConnectionHoses.updateConnectionHose)
    SpecializationUtil.registerFunction(vehicleType, "getCenterPointAngle" , ConnectionHoses.getCenterPointAngle)
    SpecializationUtil.registerFunction(vehicleType, "getCenterPointAngleRegulation" , ConnectionHoses.getCenterPointAngleRegulation)
    SpecializationUtil.registerFunction(vehicleType, "loadConnectionHosesFromXML" , ConnectionHoses.loadConnectionHosesFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadHoseSkipNode" , ConnectionHoses.loadHoseSkipNode)
    SpecializationUtil.registerFunction(vehicleType, "loadToolConnectorHoseNode" , ConnectionHoses.loadToolConnectorHoseNode)
    SpecializationUtil.registerFunction(vehicleType, "addHoseTargetNodes" , ConnectionHoses.addHoseTargetNodes)
    SpecializationUtil.registerFunction(vehicleType, "loadCustomHosesFromXML" , ConnectionHoses.loadCustomHosesFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadHoseTargetNode" , ConnectionHoses.loadHoseTargetNode)
    SpecializationUtil.registerFunction(vehicleType, "loadHoseNode" , ConnectionHoses.loadHoseNode)
    SpecializationUtil.registerFunction(vehicleType, "getClonedSkipHoseNode" , ConnectionHoses.getClonedSkipHoseNode)
    SpecializationUtil.registerFunction(vehicleType, "getConnectionTarget" , ConnectionHoses.getConnectionTarget)
    SpecializationUtil.registerFunction(vehicleType, "iterateConnectionTargets" , ConnectionHoses.iterateConnectionTargets)
    SpecializationUtil.registerFunction(vehicleType, "getIsConnectionTargetUsed" , ConnectionHoses.getIsConnectionTargetUsed)
    SpecializationUtil.registerFunction(vehicleType, "getIsConnectionHoseUsed" , ConnectionHoses.getIsConnectionHoseUsed)
    SpecializationUtil.registerFunction(vehicleType, "getIsSkipNodeAvailable" , ConnectionHoses.getIsSkipNodeAvailable)
    SpecializationUtil.registerFunction(vehicleType, "getConnectionHosesByInputAttacherJoint" , ConnectionHoses.getConnectionHosesByInputAttacherJoint)
    SpecializationUtil.registerFunction(vehicleType, "connectHose" , ConnectionHoses.connectHose)
    SpecializationUtil.registerFunction(vehicleType, "disconnectHose" , ConnectionHoses.disconnectHose)
    SpecializationUtil.registerFunction(vehicleType, "updateToolConnectionHose" , ConnectionHoses.updateToolConnectionHose)
    SpecializationUtil.registerFunction(vehicleType, "addHoseToDelayedMountings" , ConnectionHoses.addHoseToDelayedMountings)
    SpecializationUtil.registerFunction(vehicleType, "connectHoseToSkipNode" , ConnectionHoses.connectHoseToSkipNode)
    SpecializationUtil.registerFunction(vehicleType, "connectHosesToAttacherVehicle" , ConnectionHoses.connectHosesToAttacherVehicle)
    SpecializationUtil.registerFunction(vehicleType, "retryHoseSkipNodeConnections" , ConnectionHoses.retryHoseSkipNodeConnections)
    SpecializationUtil.registerFunction(vehicleType, "connectCustomHosesToAttacherVehicle" , ConnectionHoses.connectCustomHosesToAttacherVehicle)
    SpecializationUtil.registerFunction(vehicleType, "connectCustomHoseNode" , ConnectionHoses.connectCustomHoseNode)
    SpecializationUtil.registerFunction(vehicleType, "updateCustomHoseNode" , ConnectionHoses.updateCustomHoseNode)
    SpecializationUtil.registerFunction(vehicleType, "disconnectCustomHoseNode" , ConnectionHoses.disconnectCustomHoseNode)
    SpecializationUtil.registerFunction(vehicleType, "setConnectionHosesActive" , ConnectionHoses.setConnectionHosesActive)
end

```

### registerHoseNodesXMLPaths

**Description**

**Definition**

> registerHoseNodesXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function ConnectionHoses.registerHoseNodesXMLPaths(schema, basePath)
    schema:register(XMLValueType.VECTOR_N, basePath .. "#inputAttacherJointIndices" , "List of corresponding input attacher joint indices" )
    schema:register(XMLValueType.NODE_INDICES, basePath .. "#inputAttacherJointNodes" , "List of corresponding input attacher joint nodes(i3dIdentifiers or paths separated by space)" )
    schema:register(XMLValueType.STRING, basePath .. "#type" , "Hose type" )
    schema:register(XMLValueType.STRING, basePath .. "#specType" , "Connection hose specialization type(if defined it needs to match the type of the other tool)" )
        schema:register(XMLValueType.STRING, basePath .. "#hoseType" , "Hose material type" , "DEFAULT" )
        schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Hose output node" )
        schema:register(XMLValueType.BOOL, basePath .. "#isTwoPointHose" , "Is two point hose without sagging" , false )
        schema:register(XMLValueType.BOOL, basePath .. "#isWorldSpaceHose" , "Sagging is calculated in world space or local space of hose node" , true )
        schema:register(XMLValueType.STRING, basePath .. "#dampingRange" , "Damping range in meters" , 0.05 )
        schema:register(XMLValueType.FLOAT, basePath .. "#dampingFactor" , "Damping factor" , 50 )
        schema:register(XMLValueType.FLOAT, basePath .. "#length" , "Hose length" , 3 )
        schema:register(XMLValueType.BOOL, basePath .. "#dynamicLength" , "Use will calculate the length on attach" , false )
        schema:register(XMLValueType.FLOAT, basePath .. "#diameter" , "Hose diameter" , 0.02 )
        schema:register(XMLValueType.FLOAT, basePath .. "#straighteningFactor" , "Straightening Factor" , 1 )
        schema:register(XMLValueType.FLOAT, basePath .. "#centerPointDropFactor" , "Can be used to manipulate how much the hose will drop while it's getting shorter then set" , 1 )
            schema:register(XMLValueType.FLOAT, basePath .. "#centerPointTension" , "Defines the tension on the center control point(0:default behavior)" , 0 )
            schema:register(XMLValueType.ANGLE, basePath .. "#minCenterPointAngle" , "Min.angle of sagged curve" , "Defined on connectionHose xml, default 90 degree" )
            schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#minCenterPointOffset" , "Min.center point offset from hose node" , "unlimited" )
            schema:register(XMLValueType.VECTOR_TRANS, basePath .. "#maxCenterPointOffset" , "Max.center point offset from hose node" , "unlimited" )
            schema:register(XMLValueType.FLOAT, basePath .. "#minDeltaY" , "Min.delta Y from center point" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. "#minDeltaYComponent" , "Min.delta Y reference node" )
            schema:register(XMLValueType.VEHICLE_MATERIAL, basePath .. "#materialTemplateName" , "Hose material" )
            schema:registerAutoCompletionDataSource(basePath .. "#materialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
            schema:register(XMLValueType.VEHICLE_MATERIAL, basePath .. "#adapterMaterialTemplateName" , "Material of colorable part of adapter" )
            schema:registerAutoCompletionDataSource(basePath .. "#adapterMaterialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
            schema:register(XMLValueType.STRING, basePath .. "#adapterType" , "Adapter type name" )
            schema:register(XMLValueType.NODE_INDEX, basePath .. "#adapterNode" , "Link node for detached adapter" )
                schema:register(XMLValueType.STRING, basePath .. "#outgoingAdapter" , "Adapter type that is used for outgoing connection hose" )
                    schema:register(XMLValueType.STRING, basePath .. "#socket" , "Outgoing socket name to load" )
                    schema:register(XMLValueType.VEHICLE_MATERIAL, basePath .. "#socketMaterialTemplateName" , "Socket custom material" )
                    schema:registerAutoCompletionDataSource(basePath .. "#socketMaterialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )

                    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
                end

```

### registerHoseTargetNodesXMLPaths

**Description**

**Definition**

> registerHoseTargetNodesXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function ConnectionHoses.registerHoseTargetNodesXMLPaths(schema, basePath)
    schema:addDelayedRegistrationPath(basePath, "ConnectionHoses:targetNode" )

    schema:register(XMLValueType.NODE_INDEX, basePath .. "#node" , "Target node" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#attacherJointIndices" , "List of corresponding attacher joint indices" )
    schema:register(XMLValueType.NODE_INDICES, basePath .. "#attacherJointNodes" , "List of corresponding attacher joint nodes(i3dIdentifiers or paths separated by space)" )
    schema:register(XMLValueType.STRING, basePath .. "#type" , "Hose type" )
    schema:registerAutoCompletionDataSource(basePath .. "#type" , "data/shared/connectionHoses/connectionHoses.xml" , "connectionHoses.connectionHoseTypes.connectionHoseType#name" )
    schema:register(XMLValueType.STRING, basePath .. "#specType" , "Connection hose specialization type(if defined it needs to match the type of the other tool)" )
        schema:register(XMLValueType.FLOAT, basePath .. "#straighteningFactor" , "Straightening Factor" , 1 )
        schema:register(XMLValueType.VECTOR_ 3 , basePath .. "#straighteningDirection" , "Straightening direction" , "0 0 1" )
        schema:register(XMLValueType.STRING, basePath .. "#socket" , "Socket name to load" )
        schema:register(XMLValueType.VEHICLE_MATERIAL, basePath .. "#socketMaterialTemplateName" , "Socket custom material" )
        schema:registerAutoCompletionDataSource(basePath .. "#socketMaterialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
        schema:register(XMLValueType.STRING, basePath .. "#adapterType" , "Adapter type to use" , "DEFAULT" )

        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
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
function ConnectionHoses.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadExtraDependentParts" , ConnectionHoses.loadExtraDependentParts)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateExtraDependentParts" , ConnectionHoses.updateExtraDependentParts)
end

```

### retryHoseSkipNodeConnections

**Description**

**Definition**

> retryHoseSkipNodeConnections()

**Arguments**

| any | updateToolConnections |
|-----|-----------------------|
| any | excludeVehicle        |

**Code**

```lua
function ConnectionHoses:retryHoseSkipNodeConnections(updateToolConnections, excludeVehicle)
    if self.getAttachedImplements ~ = nil then
        local attachedImplements = self:getAttachedImplements()
        for _, implement in ipairs(attachedImplements) do
            local object = implement.object
            if object ~ = excludeVehicle then
                if object.connectHosesToAttacherVehicle ~ = nil then
                    object:connectHosesToAttacherVehicle( self , implement.inputJointDescIndex, implement.jointDescIndex, updateToolConnections, excludeVehicle)
                end
            end
        end
    end
end

```

### setConnectionHosesActive

**Description**

**Definition**

> setConnectionHosesActive()

**Arguments**

| any | connectionHosesActive |
|-----|-----------------------|

**Code**

```lua
function ConnectionHoses:setConnectionHosesActive(connectionHosesActive)
    local spec = self.spec_connectionHoses

    if connectionHosesActive ~ = spec.connectionHosesActive then
        spec.connectionHosesActive = connectionHosesActive

        local attacherVehicle = self:getAttacherVehicle()
        if attacherVehicle ~ = nil then
            local implement = attacherVehicle:getImplementByObject( self )
            if implement ~ = nil then
                if connectionHosesActive then
                    self:connectHosesToAttacherVehicle(attacherVehicle, implement.inputJointDescIndex, implement.jointDescIndex)
                    self:connectCustomHosesToAttacherVehicle(attacherVehicle, implement.inputJointDescIndex, implement.jointDescIndex)
                else
                        ConnectionHoses.onPreDetach( self , attacherVehicle, implement)
                    end
                end
            end
        end
    end

```

### updateAttachedConnectionHoses

**Description**

**Definition**

> updateAttachedConnectionHoses()

**Arguments**

| any | attacherVehicle |
|-----|-----------------|

**Code**

```lua
function ConnectionHoses:updateAttachedConnectionHoses(attacherVehicle)
    local spec = self.spec_connectionHoses
    for i = 1 , #spec.updateableHoses do
        local hose = spec.updateableHoses[i]
        if hose.connectedObject = = attacherVehicle then
            if self.updateLoopIndex = = hose.connectedObject.updateLoopIndex then
                self:updateConnectionHose(hose, i)
            end
        end
    end

    for i, customHose in ipairs(spec.customHosesActiveDirty) do
        if customHose.isActive and customHose.connectedTarget ~ = nil then
            if customHose.connectedObject = = attacherVehicle then
                if self.updateLoopIndex = = customHose.connectedObject.updateLoopIndex then
                    self:updateCustomHoseNode(customHose, customHose.connectedTarget)
                end
            end
        end
    end
end

```

### updateConnectionHose

**Description**

**Definition**

> updateConnectionHose()

**Arguments**

| any | hose  |
|-----|-------|
| any | index |

**Code**

```lua
function ConnectionHoses:updateConnectionHose(hose, index)
    -- determine control points for spline
        local p0x, p0y, p0z = 0 , 0 , - hose.startStraightening
        local p3x, p3y, p3z = localToLocal(hose.targetNode, hose.hoseNode, 0 , 0 , 0 )
        local p4x, p4y, p4z = localToLocal(hose.targetNode, hose.hoseNode, hose.endStraighteningDirection[ 1 ] * hose.endStraightening, hose.endStraighteningDirection[ 2 ] * hose.endStraightening, hose.endStraighteningDirection[ 3 ] * hose.endStraightening)

        -- default position of middle node
        local p2x, p2y, p2z

        if hose.isWorldSpaceHose then
            local w1x, w1y, w1z = getWorldTranslation(hose.hoseNode)
            local w2x, w2y, w2z = getWorldTranslation(hose.targetNode)

            p2x = (w1x + w2x) / 2
            p2y = (w1y + w2y) / 2
            p2z = (w1z + w2z) / 2
        else
                p2x = p3x / 2
                p2y = p3y / 2
                p2z = p3z / 2
            end

            -- real distance between nodes
            local d = MathUtil.vector3Length(p3x, p3y, p3z)

            -- simple calculation of the center point -> low precision, high performance
            local lengthDifference = math.max(hose.length - d, 0 ) * (hose.centerPointDropFactor or 1 )
            local p2yStart = p2y
            if not hose.isWorldSpaceHose then
                local _
                _, p2yStart, _ = localToWorld(hose.hoseNode, p2x, p2y, p2z)
            end

            p2y = p2y - math.max(lengthDifference, 0.04 * d)

            if hose.isWorldSpaceHose then
                if hose.minDeltaY ~ = math.huge then
                    local x, y, z = worldToLocal(hose.minDeltaYComponent, p2x, p2y, p2z)
                    local _, yTarget, _ = localToLocal(hose.hoseNode, hose.minDeltaYComponent, 0 , 0 , 0 )
                    p2x, p2y, p2z = localToWorld(hose.minDeltaYComponent, x, math.max(y, yTarget + hose.minDeltaY), z)
                end

                p2x, p2y, p2z = worldToLocal(hose.hoseNode, p2x, p2y, p2z)
            end

            local angle1, angle2 = self:getCenterPointAngle(hose.hoseNode, p2x, p2y, p2z, p3x, p3y, p3z, hose.isWorldSpaceHose)
            local centerPointAngle = angle1 + angle2
            if centerPointAngle < hose.minCenterPointAngle then
                p2x, p2y, p2z = self:getCenterPointAngleRegulation(hose.hoseNode, p2x, p2y, p2z, p3x, p3y, p3z, angle1, angle2, hose.minCenterPointAngle, hose.isWorldSpaceHose)
            end

            if hose.minCenterPointOffset ~ = nil and hose.maxCenterPointOffset ~ = nil then
                p2x = math.clamp(p2x, hose.minCenterPointOffset[ 1 ], hose.maxCenterPointOffset[ 1 ])
                p2y = math.clamp(p2y, hose.minCenterPointOffset[ 2 ], hose.maxCenterPointOffset[ 2 ])
                p2z = math.clamp(p2z, hose.minCenterPointOffset[ 3 ], hose.maxCenterPointOffset[ 3 ])
            end

            -- manipulate by parent component Y and Z velocity
            local newX, newY, newZ = getWorldTranslation(hose.component)
            if hose.lastComponentPosition = = nil or hose.lastComponentVelocity = = nil then
                hose.lastComponentPosition = { newX, newY, newZ }
                hose.lastComponentVelocity = { newX, newY, newZ }
            end

            local newVelX, newVelY, newVelZ = newX - hose.lastComponentPosition[ 1 ], newY - hose.lastComponentPosition[ 2 ], newZ - hose.lastComponentPosition[ 3 ]
            hose.lastComponentPosition[ 1 ], hose.lastComponentPosition[ 2 ], hose.lastComponentPosition[ 3 ] = newX, newY, newZ

            local velX, velY, velZ = newVelX - hose.lastComponentVelocity[ 1 ], newVelY - hose.lastComponentVelocity[ 2 ], newVelZ - hose.lastComponentVelocity[ 3 ]
            hose.lastComponentVelocity[ 1 ], hose.lastComponentVelocity[ 2 ], hose.lastComponentVelocity[ 3 ] = newVelX, newVelY, newVelZ

            local worldX, worldY, worldZ = getWorldTranslation(hose.hoseNode)
            local _
            _, velY, velZ = worldToLocal(hose.hoseNode, worldX + velX, worldY + velY, worldZ + velZ)

            local _, wp2y, _ = localToWorld(hose.hoseNode, p2x, p2y, p2z)
            local realLengthDifference = p2yStart - wp2y
            velY = math.clamp(velY * - hose.dampingFactor, - hose.dampingRange, hose.dampingRange) * realLengthDifference
            velZ = math.clamp(velZ * - hose.dampingFactor, - hose.dampingRange, hose.dampingRange) * realLengthDifference

            velY = velY * 0.1 + hose.lastVelY * 0.9
            velZ = velZ * 0.1 + hose.lastVelZ * 0.9

            hose.lastVelY = velY
            hose.lastVelZ = velZ

            p2x, p2y, p2z = p2x, p2y + velY, p2z + velZ

            -- on two point hoses we set the center point to 0 and the shader creates a two point catmull rom
            if hose.isTwoPointHose then
                p2x, p2y, p2z = 0 , 0 , 0
            end

            -- apply to shader
            setShaderParameter(hose.hoseNode, "cv2" , p2x, p2y, p2z, hose.centerPointTension or 0 , false ) -- center point
            setShaderParameter(hose.hoseNode, "cv3" , p3x, p3y, p3z, 0 , false ) -- target point
            setShaderParameter(hose.hoseNode, "cv4" , p4x, p4y, p4z, 1 , false ) -- straighter point

            if VehicleDebug.state = = VehicleDebug.DEBUG_ATTACHER_JOINTS then
                if self:getIsActiveForInput() then
                    local realLength = MathUtil.vector3Length(p2x, p2y, p2z)
                    realLength = realLength + MathUtil.vector3Length(p2x - p3x, p2y - p3y, p2z - p3z)
                    renderText( 0.5 , 0.9 - index * 0.02 , 0.0175 , string.format( "hose %s:" , getName(hose.node)))
                    renderText( 0.62 , 0.9 - index * 0.02 , 0.0175 , string.format( "directLength: %.2f configLength: %.2f realLength: %.2f angle: %.2f minAngle: %.2f" , d, hose.length, realLength, math.deg(centerPointAngle), math.deg(hose.minCenterPointAngle)))

                    local x1,y1,z1 = localToWorld(hose.hoseNode, p0x, p0y, p0z)
                    local x2,y2,z2 = localToWorld(hose.hoseNode, 0 , 0 , 0 )
                    drawDebugLine(x1,y1,z1, 1 , 0 , 0 , x2,y2,z2, 0 , 1 , 0 )

                    x1,y1,z1 = localToWorld(hose.hoseNode, 0 , 0 , 0 )
                    x2,y2,z2 = localToWorld(hose.hoseNode, p2x, p2y, p2z)
                    drawDebugLine(x1,y1,z1, 1 , 0 , 0 , x2,y2,z2, 0 , 1 , 0 )

                    x1,y1,z1 = localToWorld(hose.hoseNode, p2x, p2y, p2z)
                    x2,y2,z2 = localToWorld(hose.hoseNode, p3x, p3y, p3z)
                    drawDebugLine(x1,y1,z1, 1 , 0 , 0 , x2,y2,z2, 0 , 1 , 0 )

                    x1,y1,z1 = localToWorld(hose.hoseNode, p3x, p3y, p3z)
                    x2,y2,z2 = localToWorld(hose.hoseNode, p4x, p4y, p4z)
                    drawDebugLine(x1,y1,z1, 1 , 0 , 0 , x2,y2,z2, 0 , 1 , 0 )

                    local x0,y0,z0 = localToWorld(hose.hoseNode, p0x, p0y, p0z)
                    x1,y1,z1 = localToWorld(hose.hoseNode, 0 , 0 , 0 )
                    x2,y2,z2 = localToWorld(hose.hoseNode, p2x, p2y, p2z)
                    local x3,y3,z3 = localToWorld(hose.hoseNode, p3x, p3y, p3z)
                    local x4,y4,z4 = localToWorld(hose.hoseNode, p4x, p4y, p4z)
                    drawDebugPoint(x0,y0,z0, 1 , 0 , 0 , 1 )
                    drawDebugPoint(x1,y1,z1, 1 , 0 , 0 , 1 )
                    drawDebugPoint(x2,y2,z2, 1 , 0 , 0 , 1 )
                    drawDebugPoint(x3,y3,z3, 1 , 0 , 0 , 1 )
                    drawDebugPoint(x4,y4,z4, 1 , 0 , 0 , 1 )

                    DebugGizmo.renderAtNode(hose.hoseNode, "hn" )
                    DebugGizmo.renderAtNode(hose.targetNode, "tn" )

                    if hose.minCenterPointOffset ~ = nil and hose.maxCenterPointOffset ~ = nil then
                        local x, y, z = localToWorld(hose.hoseNode, 0 , 0 , 0 )
                        local upX, upY, upZ = localDirectionToWorld(hose.hoseNode, 0 , 1 , 0 )
                        local dirX, dirY, dirZ = localDirectionToWorld(hose.hoseNode, 0 , 0 , 1 )
                        local sideDirX, sideDirY, sideDirZ = localDirectionToWorld(hose.hoseNode, 1 , 0 , 0 )

                        local minX, maxX = math.clamp(hose.minCenterPointOffset[ 1 ], - 1 , 1 ), math.clamp(hose.maxCenterPointOffset[ 1 ], - 1 , 1 )
                        local minY, maxY = math.clamp(hose.minCenterPointOffset[ 2 ], - 1 , 1 ), math.clamp(hose.maxCenterPointOffset[ 2 ], - 1 , 1 )
                        local minZ, maxZ = math.clamp(hose.minCenterPointOffset[ 3 ], - 1 , 1 ), math.clamp(hose.maxCenterPointOffset[ 3 ], - 1 , 1 )

                        if hose.minCenterPointOffset[ 3 ] ~ = - math.huge or hose.maxCenterPointOffset[ 3 ] ~ = math.huge then
                            local cx, cy, cz = x + upX * (minY + maxY) * 0.5 , y + upY * (minY + maxY) * 0.5 , z + upZ * (minY + maxY) * 0.5
                            cx, cy, cz = cx + sideDirX * (minX + maxX) * 0.5 , cy + sideDirY * (minX + maxX) * 0.5 , cz + sideDirZ * (minX + maxX) * 0.5

                            local blue = Color.new( 0 , 0 , 1 , 0.1 )
                            DebugPlane.newSimple( true , true , blue, false ):createFromPosAndDir(cx + dirX * minZ, cy + dirY * minZ, cz + dirZ * minZ, upX, upY, upZ, dirX, dirY, dirZ, maxX - minX, maxY - minY):draw()
                            DebugPlane.newSimple( true , true , blue, false ):createFromPosAndDir(cx + dirX * maxZ, cy + dirY * maxZ, cz + dirZ * maxZ, upX, upY, upZ, dirX, dirY, dirZ, maxX - minX, maxY - minY):draw()
                        end

                        if hose.minCenterPointOffset[ 2 ] ~ = - math.huge or hose.maxCenterPointOffset[ 2 ] ~ = math.huge then
                            local cx, cy, cz = x + dirX * (minZ + maxZ) * 0.5 , y + dirY * (minZ + maxZ) * 0.5 , z + dirZ * (minZ + maxZ) * 0.5
                            cx, cy, cz = cx + sideDirX * (minX + maxX) * 0.5 , cy + sideDirY * (minX + maxX) * 0.5 , cz + sideDirZ * (minX + maxX) * 0.5

                            local green = Color.new( 0 , 1 , 0 , 0.1 )
                            DebugPlane.newSimple( true , true , green, false ):createFromPosAndDir(cx + upX * minY, cy + upY * minY, cz + upZ * minY, dirX, dirY, dirZ, upX, upY, upZ, maxX - minX, maxZ - minZ):draw()
                            DebugPlane.newSimple( true , true , green, false ):createFromPosAndDir(cx + upX * maxY, cy + upY * maxY, cz + upZ * maxY, dirX, dirY, dirZ, upX, upY, upZ, maxX - minX, maxZ - minZ):draw()
                        end

                        if hose.minCenterPointOffset[ 1 ] ~ = - math.huge or hose.maxCenterPointOffset[ 1 ] ~ = math.huge then
                            local cx, cy, cz = x + dirX * (minZ + maxZ) * 0.5 , y + dirY * (minZ + maxZ) * 0.5 , z + dirZ * (minZ + maxZ) * 0.5

                            local red = Color.new( 1 , 0 , 0 , 0.1 )
                            DebugPlane.newSimple( true , true , red, false ):createFromPosAndDir(cx + sideDirX * minX, cy + sideDirY * minX, cz + sideDirZ * minX, dirX, dirY, dirZ, sideDirX, sideDirY, sideDirZ, maxY - minY, maxZ - minZ):draw()
                            DebugPlane.newSimple( true , true , red, false ):createFromPosAndDir(cx + sideDirX * maxX, cy + sideDirY * maxX, cz + sideDirZ * maxX, dirX, dirY, dirZ, sideDirX, sideDirY, sideDirZ, maxY - minY, maxZ - minZ):draw()
                        end
                    end

                    if hose.minDeltaY ~ = math.huge and hose.minDeltaYComponent ~ = nil then
                        local lx, _, lz = localToLocal(hose.hoseNode, hose.minDeltaYComponent, p2x, p2y, p2z)
                        local _, ly, _ = localToLocal(hose.hoseNode, hose.minDeltaYComponent, 0 , 0 , 0 )
                        local x, y, z = localToWorld(hose.minDeltaYComponent, lx, ly + hose.minDeltaY, lz)
                        local upX, upY, upZ = localDirectionToWorld(hose.minDeltaYComponent, 0 , 1 , 0 )
                        local dirX, dirY, dirZ = localDirectionToWorld(hose.minDeltaYComponent, 0 , 0 , 1 )

                        DebugPlane.newSimple( true , true , Color.new( 0 , 1 , 0 , 0.1 ), false ):createFromPosAndDir(x, y, z, dirX, dirY, dirZ, upX, upY, upZ, 1 , 1 ):draw()
                    end
                end
            end
        end

```

### updateCustomHoseNode

**Description**

**Definition**

> updateCustomHoseNode()

**Arguments**

| any | customHose   |
|-----|--------------|
| any | customTarget |

**Code**

```lua
function ConnectionHoses:updateCustomHoseNode(customHose, customTarget)
    setTranslation(customHose.node, localToLocal(customTarget.node, getParent(customHose.node), 0 , 0 , 0 ))
    setRotation(customHose.node, localRotationToLocal(customTarget.node, getParent(customHose.node), 0 , 0 , 0 ))

    if self.setMovingToolDirty ~ = nil then
        self:setMovingToolDirty(customHose.node)
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
function ConnectionHoses:updateExtraDependentParts(superFunc, part, dt)
    superFunc( self , part, dt)

    if part.customHoseIndices ~ = nil then
        local spec = self.spec_connectionHoses
        for i = 1 , #part.customHoseIndices do
            local customHoseIndex = part.customHoseIndices[i]
            local customHose = spec.customHoses[customHoseIndex]
            if customHose ~ = nil and customHose.isActive then
                self:updateCustomHoseNode(customHose, customHose.connectedTarget)
            end
        end
    end

    if part.customTargetIndices ~ = nil then
        local spec = self.spec_connectionHoses
        for i = 1 , #part.customTargetIndices do
            local customTargetIndex = part.customTargetIndices[i]
            local customTarget = spec.customHoseTargets[customTargetIndex]
            if customTarget ~ = nil and customTarget.isActive then
                self:updateCustomHoseNode(customTarget.connectedHose, customTarget)
            end
        end
    end

    if part.localHoseIndices ~ = nil then
        local spec = self.spec_connectionHoses
        for i = 1 , #part.localHoseIndices do
            local localHoseIndex = part.localHoseIndices[i]
            local localHose = spec.localHoseNodes[localHoseIndex]
            if localHose ~ = nil and localHose.hose.connectedObject ~ = nil then
                self:updateConnectionHose(localHose.hose, localHoseIndex)
            end
        end
    end
end

```

### updateToolConnectionHose

**Description**

**Definition**

> updateToolConnectionHose()

**Arguments**

| any | sourceObject |
|-----|--------------|
| any | sourceHose   |
| any | targetObject |
| any | targetHose   |
| any | visibility   |

**Code**

```lua
function ConnectionHoses:updateToolConnectionHose(sourceObject, sourceHose, targetObject, targetHose, visibility)
    local spec = self.spec_connectionHoses

    local function setTargetNodeTranslation(hose)
        if hose.originalNodeTranslation = = nil then
            hose.originalNodeTranslation = { getTranslation(hose.node) }
        else
                setTranslation(hose.node, unpack(hose.originalNodeTranslation))
            end
            local wx, wy, wz = localToWorld(hose.node, 0 , sourceHose.diameter * 0.5 , 0 )
            local lx, ly, lz = worldToLocal(getParent(hose.node), wx, wy, wz)
            setTranslation(hose.node, lx, ly, lz)
        end

        local toolConnectionHose = spec.targetNodeToToolConnection[targetHose.index]
        if toolConnectionHose ~ = nil then
            local opositTargetIndex = toolConnectionHose.startTargetNodeIndex
            if opositTargetIndex = = targetHose.index then
                opositTargetIndex = toolConnectionHose.endTargetNodeIndex
            end
            local opositTarget = spec.targetNodes[opositTargetIndex]

            if opositTarget ~ = nil then
                if visibility and toolConnectionHose.delayedMounting ~ = nil and toolConnectionHose.delayedMounting.sourceHose.connectedObject = = nil then
                    local differentSource = toolConnectionHose.delayedMounting.sourceObject ~ = sourceObject -- with the retryHoseSkipNodeConnections functionallity it can happen that the object is the same
                    local sameType = toolConnectionHose.delayedMounting.sourceHose.type = = sourceHose.type
                    and toolConnectionHose.delayedMounting.sourceHose.specType = = sourceHose.specType
                    if differentSource and sameType then
                        local x, y, z = localToLocal(targetHose.node, opositTarget.node, 0 , 0 , 0 )
                        local length = MathUtil.vector3Length(x, y, z) - (toolConnectionHose.additionalHoseOffset or 0 ) * 2

                        if toolConnectionHose.additionalHose then
                            local hose, _, _, _ = g_connectionHoseManager:getClonedHoseNode(sourceHose.type , sourceHose.hoseType, length, sourceHose.diameter, sourceHose.material, self.customEnvironment)

                            if hose ~ = nil then
                                link(targetHose.node, hose)
                                setTranslation(hose, 0 , 0 , toolConnectionHose.additionalHoseOffset or 0 )

                                local dirX, dirY, dirZ = localToLocal(hose, opositTarget.node, 0 , 0 , 0 )
                                if dirX ~ = 0 or dirY ~ = 0 or dirZ ~ = 0 then
                                    setDirection(hose, dirX, dirY, dirZ, 0 , 0 , 1 )
                                end

                                local meshLength, diameterScale, _, _ = getShaderParameter(hose, "lengthAndDiameter" , 0 )
                                setScale(hose, diameterScale, diameterScale, length / meshLength)

                                -- catmull rom got issues with perfectly straight hoses, so we remove the shader variation from the mesh
                                local materialId = getMaterial(hose, 0 )
                                materialId = setMaterialCustomShaderVariation(materialId, "uvTransform" , false )
                                setMaterial(hose, materialId, 0 )

                                if toolConnectionHose.moveNodes then
                                    setTargetNodeTranslation(targetHose)
                                    setTargetNodeTranslation(opositTarget)
                                end

                                sourceObject:addAllSubWashableNodes(hose)

                                toolConnectionHose.hoseNode = hose
                                toolConnectionHose.hoseNodeObject = sourceObject
                            else
                                    return false
                                end
                            end

                            if toolConnectionHose.additionalHoses ~ = nil then
                                for _, additionalHoseNode in ipairs(toolConnectionHose.additionalHoses) do
                                    local additionalLength = calcDistanceFrom(additionalHoseNode.startNode, additionalHoseNode.endNode)

                                    local hose, _, _, _ = g_connectionHoseManager:getClonedHoseNode(sourceHose.type , sourceHose.hoseType, additionalLength, sourceHose.diameter, sourceHose.material, self.customEnvironment)
                                    if hose ~ = nil then
                                        link(additionalHoseNode.startNode, hose)
                                        setTranslation(hose, 0 , 0 , 0 )

                                        local dirX, dirY, dirZ = localToLocal(additionalHoseNode.endNode, additionalHoseNode.startNode, 0 , 0 , 0 )
                                        if dirX ~ = 0 or dirY ~ = 0 or dirZ ~ = 0 then
                                            setDirection(hose, dirX, dirY, dirZ, 0 , 0 , 1 )
                                        end

                                        local meshLength, diameterScale, _, _ = getShaderParameter(hose, "lengthAndDiameter" , 0 )
                                        setScale(hose, diameterScale, diameterScale, additionalLength / meshLength)

                                        -- catmull rom got issues with perfectly straight hoses, so we remove the shader variation from the mesh
                                        local materialId = getMaterial(hose, 0 )
                                        materialId = setMaterialCustomShaderVariation(materialId, "uvTransform" , false )
                                        setMaterial(hose, materialId, 0 )

                                        sourceObject:addAllSubWashableNodes(hose)

                                        additionalHoseNode.hoseNode = hose
                                        additionalHoseNode.hoseNodeObject = sourceObject
                                    end
                                end
                            end

                            toolConnectionHose.connected = true

                            if toolConnectionHose.mountingNode ~ = nil then
                                setVisibility(toolConnectionHose.mountingNode, true )
                            end

                            ObjectChangeUtil.setObjectChanges(toolConnectionHose.objectChanges, true , toolConnectionHose.objectChangesTarget, toolConnectionHose.objectChangesTarget.setMovingToolDirty)

                            if toolConnectionHose.parentToolConnectionHose ~ = nil then
                                local parentToolConnectionHose = toolConnectionHose.parentToolConnectionHose
                                if parentToolConnectionHose.mountingNode ~ = nil then
                                    setVisibility(parentToolConnectionHose.mountingNode, true )
                                end

                                ObjectChangeUtil.setObjectChanges(parentToolConnectionHose.objectChanges, true , parentToolConnectionHose.objectChangesTarget, parentToolConnectionHose.objectChangesTarget.setMovingToolDirty)
                            end

                            -- connect the first attached hose to the tool connection
                            if toolConnectionHose.delayedMounting ~ = nil then
                                toolConnectionHose.delayedUnmounting = { }
                                table.insert(toolConnectionHose.delayedUnmounting, toolConnectionHose.delayedMounting)
                                table.insert(toolConnectionHose.delayedUnmounting, { sourceObject = sourceObject, sourceHose = sourceHose, targetObject = targetObject, targetHose = targetHose } )

                                local delayedHose = toolConnectionHose.delayedMounting
                                toolConnectionHose.delayedMounting = nil
                                delayedHose.sourceObject:connectHose(delayedHose.sourceHose, delayedHose.targetObject, delayedHose.targetHose, false )
                                delayedHose.sourceObject:retryHoseSkipNodeConnections( false )
                            end

                            return true
                        end
                    else
                            if toolConnectionHose.connected then
                                toolConnectionHose.connected = false

                                if toolConnectionHose.hoseNode ~ = nil then
                                    toolConnectionHose.hoseNodeObject:removeAllSubWashableNodes(toolConnectionHose.hoseNode)

                                    delete(toolConnectionHose.hoseNode)
                                    toolConnectionHose.hoseNode = nil
                                    toolConnectionHose.hoseNodeObject = nil
                                end

                                if toolConnectionHose.additionalHoses ~ = nil then
                                    for _, additionalHoseNode in ipairs(toolConnectionHose.additionalHoses) do
                                        if additionalHoseNode.hoseNode ~ = nil then
                                            additionalHoseNode.hoseNodeObject:removeAllSubWashableNodes(additionalHoseNode.hoseNode)

                                            delete(additionalHoseNode.hoseNode)
                                            additionalHoseNode.hoseNode = nil
                                            additionalHoseNode.hoseNodeObject = nil
                                        end
                                    end
                                end

                                if toolConnectionHose.mountingNode ~ = nil then
                                    setVisibility(toolConnectionHose.mountingNode, false )
                                end

                                ObjectChangeUtil.setObjectChanges(toolConnectionHose.objectChanges, false , toolConnectionHose.objectChangesTarget, toolConnectionHose.objectChangesTarget.setMovingToolDirty)

                                if toolConnectionHose.parentToolConnectionHose ~ = nil then
                                    local parentToolConnectionHose = toolConnectionHose.parentToolConnectionHose
                                    if not parentToolConnectionHose.connected then
                                        if parentToolConnectionHose.mountingNode ~ = nil then
                                            setVisibility(parentToolConnectionHose.mountingNode, false )
                                        end

                                        ObjectChangeUtil.setObjectChanges(parentToolConnectionHose.objectChanges, false , parentToolConnectionHose.objectChangesTarget, parentToolConnectionHose.objectChangesTarget.setMovingToolDirty)
                                    end
                                end

                                -- remove the second hose connection from the tool connection
                                -- but keep it as delayed mounting
                                -- if is hose from skip node, completly remove it(will be recreated depending on sub attached tool)
                                    if toolConnectionHose.delayedUnmounting ~ = nil then
                                        for _, hose in ipairs(toolConnectionHose.delayedUnmounting) do
                                            if sourceHose ~ = hose.sourceHose then
                                                hose.sourceObject:disconnectHose(hose.sourceHose)
                                                if hose.sourceHose.isClonedSkipNodeHose = = nil or not hose.sourceHose.isClonedSkipNodeHose then
                                                    toolConnectionHose.delayedMounting = hose
                                                end
                                            end
                                        end

                                        toolConnectionHose.delayedUnmounting = nil
                                    end
                                end
                            end
                        end
                    else
                            return true
                        end

                        return false
                    end

```