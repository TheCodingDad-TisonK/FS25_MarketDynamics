## PowerTakeOffs

**Description**

> Specialization for vehicles with power takeoffs (PTOs), both output (e.g. tractor) and input (e.g. tool) ones

**Functions**

- [attachPowerTakeOff](#attachpowertakeoff)
- [attachTypedPowerTakeOff](#attachtypedpowertakeoff)
- [checkPowerTakeOffCollision](#checkpowertakeoffcollision)
- [consoleCommandDebug](#consolecommanddebug)
- [consoleCommandTestConnection](#consolecommandtestconnection)
- [detachPowerTakeOff](#detachpowertakeoff)
- [detachTypedPowerTakeOff](#detachtypedpowertakeoff)
- [getInputPowerTakeOffs](#getinputpowertakeoffs)
- [getInputPowerTakeOffsByJointDescIndexAndName](#getinputpowertakeoffsbyjointdescindexandname)
- [getIsPowerTakeOffActive](#getispowertakeoffactive)
- [getOutputPowerTakeOffs](#getoutputpowertakeoffs)
- [getOutputPowerTakeOffsByJointDescIndex](#getoutputpowertakeoffsbyjointdescindex)
- [getPowerTakeOffConfigIndex](#getpowertakeoffconfigindex)
- [initSpecialization](#initspecialization)
- [loadBasicPowerTakeOff](#loadbasicpowertakeoff)
- [loadDoubleJointPowerTakeOff](#loaddoublejointpowertakeoff)
- [loadExtraDependentParts](#loadextradependentparts)
- [loadInputPowerTakeOff](#loadinputpowertakeoff)
- [loadLocalPowerTakeOff](#loadlocalpowertakeoff)
- [loadOutputPowerTakeOff](#loadoutputpowertakeoff)
- [loadPowerTakeOffFromConfigFile](#loadpowertakeofffromconfigfile)
- [loadPowerTakeOffsFromXML](#loadpowertakeoffsfromxml)
- [loadSingleJointPowerTakeOff](#loadsinglejointpowertakeoff)
- [onDelete](#ondelete)
- [onLoad](#onload)
- [onPostAttachImplement](#onpostattachimplement)
- [onPostLoad](#onpostload)
- [onPowerTakeOffI3DLoaded](#onpowertakeoffi3dloaded)
- [onPreAttachImplement](#onpreattachimplement)
- [onPreDetachImplement](#onpredetachimplement)
- [onPreLoad](#onpreload)
- [onUpdateEnd](#onupdateend)
- [onUpdateInterpolation](#onupdateinterpolation)
- [parkPowerTakeOff](#parkpowertakeoff)
- [placeLocalPowerTakeOff](#placelocalpowertakeoff)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerInputXMLPaths](#registerinputxmlpaths)
- [registerOutputXMLPaths](#registeroutputxmlpaths)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [updateAttachedPowerTakeOffs](#updateattachedpowertakeoffs)
- [updateDistanceOfTypedPowerTakeOff](#updatedistanceoftypedpowertakeoff)
- [updateDoubleJointPowerTakeOff](#updatedoublejointpowertakeoff)
- [updateExtraDependentParts](#updateextradependentparts)
- [updatePowerTakeOff](#updatepowertakeoff)
- [updatePowerTakeOffLength](#updatepowertakeofflength)
- [updateSingleJointPowerTakeOff](#updatesinglejointpowertakeoff)
- [validatePowerTakeOffAttachment](#validatepowertakeoffattachment)

### attachPowerTakeOff

**Description**

**Definition**

> attachPowerTakeOff()

**Arguments**

| any | attachableObject    |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |

**Code**

```lua
function PowerTakeOffs:attachPowerTakeOff(attachableObject, inputJointDescIndex, jointDescIndex)
    local spec = self.spec_powerTakeOffs
    local outputs = self:getOutputPowerTakeOffsByJointDescIndex(jointDescIndex)

    for _, output in ipairs(outputs) do
        if attachableObject.getInputPowerTakeOffsByJointDescIndexAndName ~ = nil then
            local inputs = attachableObject:getInputPowerTakeOffsByJointDescIndexAndName(inputJointDescIndex, output.ptoName)
            for _, input in ipairs(inputs) do
                output.connectedInput = input
                output.connectedVehicle = attachableObject
                input.connectedVehicle = self
                input.connectedOutput = output

                table.insert(spec.delayedPowerTakeOffsMountings, { jointDescIndex = jointDescIndex, input = input , output = output } )
            end
        end
    end

    return true
end

```

### attachTypedPowerTakeOff

**Description**

**Definition**

> attachTypedPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | output       |

**Code**

```lua
function PowerTakeOffs:attachTypedPowerTakeOff(powerTakeOff, output )
    if self:validatePowerTakeOffAttachment(powerTakeOff, output ) then
        link( output.outputNode, powerTakeOff.linkNode)
        link(powerTakeOff.inputNode, powerTakeOff.startNode)

        setTranslation(powerTakeOff.linkNode, 0 , 0 , powerTakeOff.zOffset)
        setTranslation(powerTakeOff.startNode, 0 , 0 , - powerTakeOff.zOffset)

        self:updatePowerTakeOff(powerTakeOff, 0 )
        self:updatePowerTakeOffLength(powerTakeOff)

        setVisibility(powerTakeOff.linkNode, true )
        setVisibility(powerTakeOff.startNode, true )

        powerTakeOff.isLinked = true
    end
end

```

### checkPowerTakeOffCollision

**Description**

> Check if the power take off colliding with the attacher joint if no trans node is defined -> detach if collision has
> been detected

**Definition**

> checkPowerTakeOffCollision()

**Arguments**

| any | attacherJointNode |
|-----|-------------------|
| any | jointDescIndex    |
| any | isTrailerAttacher |

**Code**

```lua
function PowerTakeOffs:checkPowerTakeOffCollision(attacherJointNode, jointDescIndex, isTrailerAttacher)
    -- we assume that the pto is only able to collide with the drawbar on trailer attacher joints, not on implement joints etc
    if isTrailerAttacher then
        local ptoOutputs = self:getOutputPowerTakeOffsByJointDescIndex(jointDescIndex)
        if ptoOutputs ~ = nil and #ptoOutputs > 0 then
            local ptoOutput = ptoOutputs[ 1 ]
            local ptoInput = ptoOutput.connectedInput
            if ptoInput ~ = nil then
                local _, y, _ = localToLocal(ptoOutput.outputNode, attacherJointNode, 0 , 0 , 0 )
                if (ptoInput.aboveAttacher and y < 0 ) or( not ptoInput.aboveAttacher and y > 0 ) then
                    self:detachPowerTakeOff( self , nil , jointDescIndex)
                end
            end
        end
    end
end

```

### consoleCommandDebug

**Description**

**Definition**

> consoleCommandDebug()

**Arguments**

| any | _ |
|-----|---|

**Code**

```lua
function PowerTakeOffs.consoleCommandDebug(_)
    if PowerTakeOffs.debugRootNode = = nil then
        PowerTakeOffs.debugRootNode = createTransformGroup( "powerTakeOffsDebugRoot" )
        link(getRootNode(), PowerTakeOffs.debugRootNode)

        local x, y, z = g_localPlayer:getPosition()
        local dirX, dirZ = g_localPlayer:getCurrentFacingDirection()

        x, z = x + dirX * 4 , z + dirZ * 4
        local ry = MathUtil.getYRotationFromDirection(dirX, dirZ)

        setWorldTranslation( PowerTakeOffs.debugRootNode, x, y, z)
        setWorldRotation( PowerTakeOffs.debugRootNode, 0 , ry, 0 )
    end

    if PowerTakeOffs.debugPowerTakeOffs ~ = nil then
        for _, powerTakeOff in ipairs( PowerTakeOffs.debugPowerTakeOffs) do
            g_currentMission:removeUpdateable(powerTakeOff)

            if powerTakeOff.xmlFile ~ = nil then
                powerTakeOff.xmlFile:delete()
            end
            if powerTakeOff.sharedLoadRequestId ~ = nil then
                g_i3DManager:releaseSharedI3DFile(powerTakeOff.sharedLoadRequestId)
                powerTakeOff.sharedLoadRequestId = nil
            end

            g_animationManager:deleteAnimations(powerTakeOff.animationNodes)
            g_animationManager:deleteAnimations(powerTakeOff.localAnimationNodes)

            delete(powerTakeOff.inputNode)
        end
    end
    PowerTakeOffs.debugPowerTakeOffs = { }

    local files = Files.getFilesRecursive(getAppBasePath() .. "data/shared/assets/powerTakeOffs" )
    table.sort(files, function (a, b)
        return a.path < b.path
    end )

    local rowIndex = 0
    local rowPosition = 0
    local lastBasePath = nil
    local lastName = nil
    for _, file in ipairs(files) do
        if not file.isDirectory then
            if file.filename:contains( ".xml" ) then
                local linkNode = createTransformGroup( "linkNode" )
                link( PowerTakeOffs.debugRootNode, linkNode)

                local name = file.filename
                name = string.gsub(name, ".xml" , "" )

                local basePath = file.path:split(file.filename)[ 1 ]
                if basePath ~ = lastBasePath or name ~ = lastName then
                    rowIndex = rowIndex + 1
                    rowPosition = 0
                    lastBasePath = basePath
                    lastName = name

                    local wx, wy, wz = localToWorld( PowerTakeOffs.debugRootNode, rowIndex * 2 , 1 , - 1 )
                    local rx, ry, rz = localRotationToWorld( PowerTakeOffs.debugRootNode, - math.pi * 0.5 , math.pi, 0 )
                    g_debugManager:addElement( DebugText3D.new():createWithWorldPos(wx, wy, wz, rx, ry, rz, name, 0.15 ), nil , nil , math.huge)
                end

                local x = rowIndex * 2
                local y = 1
                local z = rowPosition

                rowPosition = rowPosition + 1

                setTranslation(linkNode, x, y, z)
                setRotation(linkNode, 0 , 0 , 0 )

                for typeIndex = 1 , 3 do
                    local dummyVehicle = { }
                    dummyVehicle.baseDirectory = ""

                    for k, v in pairs( PowerTakeOffs ) do
                        dummyVehicle[k] = v
                    end

                    dummyVehicle.onPowerTakeOffI3DLoaded = function (_, i3dNode, failedReason, args)
                        local nameMain = args.xmlFile:getValue( "powerTakeOff#colorMaterialName" , "powerTakeOff_main_mat" )
                        local nameDecal = args.xmlFile:getValue( "powerTakeOff#decalColorMaterialName" , "powerTakeOff_decal_mat" )

                        PowerTakeOffs.onPowerTakeOffI3DLoaded(_, i3dNode, failedReason, args)
                        if i3dNode ~ = 0 then
                            local powerTakeOff = args.powerTakeOff

                            if typeIndex = = 2 then
                                powerTakeOff.material = VehicleMaterial.new()
                                powerTakeOff.material.colorScale = { 0 , 1 , 1 , 1 }
                                powerTakeOff.material:apply(powerTakeOff.inputNode, nameMain)

                                powerTakeOff.decalMaterial = VehicleMaterial.new()
                                powerTakeOff.decalMaterial.colorScale = { 1 , 0 , 1 , 1 }
                                powerTakeOff.decalMaterial:apply(powerTakeOff.inputNode, nameDecal)
                            elseif typeIndex = = 3 then
                                    g_animationManager:startAnimations(powerTakeOff.animationNodes)

                                    dummyVehicle.dynamicPowerTakeOff = powerTakeOff
                                    dummyVehicle.time = 0
                                    dummyVehicle.update = function (v, dt)
                                        v.time = (v.time + dt) % 2500
                                        local alpha = v.time / 2500
                                        setTranslation(v.dynamicPowerTakeOff.detachNode, alpha * 0.5 , alpha, - 1.5 )

                                        if v.dynamicPowerTakeOff.updateFunc ~ = nil then
                                            v.dynamicPowerTakeOff.updateFunc( self , v.dynamicPowerTakeOff, dt)
                                        end
                                    end
                                    g_currentMission:addUpdateable(dummyVehicle, powerTakeOff)
                                end

                                table.insert( PowerTakeOffs.debugPowerTakeOffs, powerTakeOff)
                            end
                        end
                        dummyVehicle.loadSubSharedI3DFile = function (_, filename, callOnCreate, addToPhysics, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
                            return g_i3DManager:loadSharedI3DFileAsync(filename, callOnCreate, addToPhysics, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
                        end

                        local powerTakeOff = { }
                        powerTakeOff.inputNode = createTransformGroup( "inputNode" )
                        link(linkNode, powerTakeOff.inputNode)
                        setTranslation(powerTakeOff.inputNode, 0 , 0 , typeIndex * 3 )
                        setRotation(powerTakeOff.inputNode, 0 , math.pi, 0 )

                        powerTakeOff.detachNode = createTransformGroup( "detachNode" )
                        link(powerTakeOff.inputNode, powerTakeOff.detachNode)
                        setTranslation(powerTakeOff.detachNode, 0 , 0 , - 1.5 )
                        setRotation(powerTakeOff.detachNode, 0 , 0 , 0 )

                        local filename = string.gsub(file.path, getAppBasePath(), "" )
                        PowerTakeOffs.loadPowerTakeOffFromConfigFile(dummyVehicle, powerTakeOff, filename)

                        g_debugManager:addElement( DebugGizmo.new():createWithNode(powerTakeOff.inputNode, "start" , nil , nil , 0.25 ), nil , nil , math.huge)
                        g_debugManager:addElement( DebugGizmo.new():createWithNode(powerTakeOff.detachNode, "end" , nil , nil , 0.25 ), nil , nil , math.huge)
                    end
                end
            end
        end
    end

```

### consoleCommandTestConnection

**Description**

**Definition**

> consoleCommandTestConnection()

**Arguments**

| any | vehicle            |
|-----|--------------------|
| any | attacherJointIndex |

**Code**

```lua
function PowerTakeOffs.consoleCommandTestConnection(vehicle, attacherJointIndex)
    local spec = vehicle.spec_powerTakeOffs
    if spec ~ = nil then
        local lineColor = Color.new( 0 , 0.5 , 1 )

        for _, output in pairs(spec.outputPowerTakeOffs) do
            if output.debugLine ~ = nil then
                g_debugManager:removeElement( output.debugLine)
                output.debugLine = nil
            end

            if output.debugText ~ = nil then
                g_debugManager:removeElement( output.debugText)
                output.debugText = nil
            end

            for i = getNumOfChildren( output.outputNode), 1 , - 1 do
                delete(getChildAt( output.outputNode, i - 1 ))
            end

            if output.attacherJointIndices[attacherJointIndex] ~ = nil then
                local node = g_i3DManager:loadI3DFile( "data/shared/assets/powerTakeOffs/walterscheidW.i3d" , false , false )
                if node ~ = 0 then
                    link( output.outputNode, node)
                    setTranslation(node, 0 , 0 , 0.045 )
                    setRotation(node, 0 , math.pi, 0 )

                    setVisibility(getChildAt(getChildAt(node, 0 ), 0 ), false )

                    local material = VehicleMaterial.new()
                    material.colorScale = { 1 , 0 , 1 , 1 }
                    material:apply(node)
                end
                ObjectChangeUtil.setObjectChanges( output.objectChanges, true , vehicle, vehicle.setMovingToolDirty)

                local attacherJointDesc = vehicle:getAttacherJointByJointDescIndex(attacherJointIndex)
                if attacherJointDesc ~ = nil then
                    output.debugLine = DebugLine.new():createWithStartAndEndNode(attacherJointDesc.jointTransform, output.outputNode, false , true , 100 , true )
                    output.debugLine:setColors(lineColor, lineColor)
                    g_debugManager:addElement( output.debugLine, nil , nil , math.huge)

                    output.debugText = DebugText.new():createWithNode( output.outputNode, getName( output.outputNode), 0.01 , true )
                    g_debugManager:addElement( output.debugText, nil , nil , math.huge)
                end
            else
                    ObjectChangeUtil.setObjectChanges( output.objectChanges, false , vehicle, vehicle.setMovingToolDirty)
                end
            end
        end
    end

```

### detachPowerTakeOff

**Description**

**Definition**

> detachPowerTakeOff()

**Arguments**

| any | detachingVehicle |
|-----|------------------|
| any | implement        |
| any | jointDescIndex   |

**Code**

```lua
function PowerTakeOffs:detachPowerTakeOff(detachingVehicle, implement, jointDescIndex)
    local spec = self.spec_powerTakeOffs
    -- clear delayed mountings
    spec.delayedPowerTakeOffsMountings = { }

    local outputs = detachingVehicle:getOutputPowerTakeOffsByJointDescIndex(jointDescIndex or implement.jointDescIndex)

    for _, output in ipairs(outputs) do
        if output.connectedInput ~ = nil then
            local input = output.connectedInput

            if input.detachFunc ~ = nil then
                input.detachFunc( self , input , output )
            end

            if input.connectedOutput ~ = nil then
                g_animationManager:stopAnimations( input.connectedOutput.localAnimationNodes)
                input.connectedOutput.isActive = false

                if input.connectedVehicle.updateDashboardValueType ~ = nil then
                    input.connectedVehicle:updateDashboardValueType( "powerTakeOffs.state" )
                end
            end

            input.connectedVehicle = nil
            input.connectedOutput = nil
            output.connectedVehicle = nil
            output.connectedInput = nil

            ObjectChangeUtil.setObjectChanges( input.objectChanges, false , self , self.setMovingToolDirty)
            ObjectChangeUtil.setObjectChanges( output.objectChanges, false , self , self.setMovingToolDirty)
        end
    end

    return true
end

```

### detachTypedPowerTakeOff

**Description**

**Definition**

> detachTypedPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | output       |

**Code**

```lua
function PowerTakeOffs:detachTypedPowerTakeOff(powerTakeOff, output )
    self:parkPowerTakeOff(powerTakeOff)
end

```

### getInputPowerTakeOffs

**Description**

**Definition**

> getInputPowerTakeOffs()

**Code**

```lua
function PowerTakeOffs:getInputPowerTakeOffs()
    return self.spec_powerTakeOffs.inputPowerTakeOffs
end

```

### getInputPowerTakeOffsByJointDescIndexAndName

**Description**

**Definition**

> getInputPowerTakeOffsByJointDescIndexAndName()

**Arguments**

| any | jointDescIndex |
|-----|----------------|
| any | ptoName        |

**Code**

```lua
function PowerTakeOffs:getInputPowerTakeOffsByJointDescIndexAndName(jointDescIndex, ptoName)
    local retInputs = { }

    local spec = self.spec_powerTakeOffs
    for _, input in pairs(spec.inputPowerTakeOffs) do
        if input.inputAttacherJointIndices[jointDescIndex] ~ = nil then
            if input.ptoName = = ptoName then
                table.insert(retInputs, input )
            end
        end
    end

    if #retInputs = = 0 then
        for _, output in pairs(spec.outputPowerTakeOffs) do
            if output.skipToInputAttacherIndex = = jointDescIndex then
                for index, _ in pairs( output.attacherJointIndices) do
                    local implement = self:getImplementFromAttacherJointIndex(index)
                    if implement ~ = nil then
                        retInputs = implement.object:getInputPowerTakeOffsByJointDescIndexAndName(implement.inputJointDescIndex, ptoName)
                    end
                end
            end
        end
    end

    return retInputs
end

```

### getIsPowerTakeOffActive

**Description**

**Definition**

> getIsPowerTakeOffActive()

**Code**

```lua
function PowerTakeOffs:getIsPowerTakeOffActive()
    return false
end

```

### getOutputPowerTakeOffs

**Description**

**Definition**

> getOutputPowerTakeOffs()

**Code**

```lua
function PowerTakeOffs:getOutputPowerTakeOffs()
    return self.spec_powerTakeOffs.outputPowerTakeOffs
end

```

### getOutputPowerTakeOffsByJointDescIndex

**Description**

**Definition**

> getOutputPowerTakeOffsByJointDescIndex()

**Arguments**

| any | jointDescIndex |
|-----|----------------|

**Code**

```lua
function PowerTakeOffs:getOutputPowerTakeOffsByJointDescIndex(jointDescIndex)
    local retOutputs = { }

    local spec = self.spec_powerTakeOffs
    for _, output in pairs(spec.outputPowerTakeOffs) do
        if output.attacherJointIndices[jointDescIndex] ~ = nil then
            table.insert(retOutputs, output )
        end
    end

    if #retOutputs > 0 then
        for _, output in ipairs(retOutputs) do
            if output.skipToInputAttacherIndex ~ = nil then
                local secondAttacherVehicle = self:getAttacherVehicle()
                if secondAttacherVehicle ~ = nil then
                    local ownImplement = secondAttacherVehicle:getImplementByObject( self )
                    retOutputs = secondAttacherVehicle:getOutputPowerTakeOffsByJointDescIndex(ownImplement.jointDescIndex)
                    break
                end
            end
        end
    end

    return retOutputs
end

```

### getPowerTakeOffConfigIndex

**Description**

**Definition**

> getPowerTakeOffConfigIndex()

**Code**

```lua
function PowerTakeOffs:getPowerTakeOffConfigIndex()
    return 1
end

```

### initSpecialization

**Description**

**Definition**

> initSpecialization()

**Code**

```lua
function PowerTakeOffs.initSpecialization()
    local schema = Vehicle.xmlSchema
    schema:setXMLSpecializationType( "PowerTakeOffs" )

    PowerTakeOffs.registerXMLPaths(schema, "vehicle.powerTakeOffs.powerTakeOffConfigurations.powerTakeOffConfiguration(?)" )
    PowerTakeOffs.registerXMLPaths(schema, "vehicle.powerTakeOffs" )

    schema:addDelayedRegistrationFunc( "Cylindered:movingTool" , function (cSchema, cKey)
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".powerTakeOffs#indices" , "PTOs to update" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".powerTakeOffs#localIndices" , "Local PTOs to update" )
    end )

    schema:addDelayedRegistrationFunc( "Cylindered:movingPart" , function (cSchema, cKey)
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".powerTakeOffs#indices" , "PTOs to update" )
        cSchema:register(XMLValueType.VECTOR_N, cKey .. ".powerTakeOffs#localIndices" , "Local PTOs to update" )
    end )

    schema:register(XMLValueType.BOOL, "vehicle.powerTakeOffs#ignoreInvalidJointIndices" , "Do not display warning if attacher joint index could not be found.Can be useful if attacher joints change due to configurations" , false )
        schema:register(XMLValueType.FLOAT, "vehicle.powerTakeOffs#maxUpdateDistance" , "Max.distance to vehicle root to update power take offs" , PowerTakeOffs.DEFAULT_MAX_UPDATE_DISTANCE)

        Dashboard.addDelayedRegistrationFunc(schema, function (cSchema, cKey)
            cSchema:register(XMLValueType.INT, cKey .. "#powerTakeOffIndex" , "Index of power take off in xml to use" )
        end )

        SoundManager.registerSampleXMLPaths(schema, "vehicle.powerTakeOffs.sounds" , "turnedOn(?)" )

        schema:setXMLSpecializationType()

        local powerTakeOffXMLSchema = XMLSchema.new( "powerTakeOff" )
        PowerTakeOffs.xmlSchema = powerTakeOffXMLSchema

        powerTakeOffXMLSchema:register(XMLValueType.STRING, "powerTakeOff#filename" , "Path to i3d file" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.startNode#node" , "Start node" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.linkNode#node" , "Link node" )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff#size" , "Height of pto" , 0.19 )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff#minLength" , "Minimum length of pto" , 0.6 )
        powerTakeOffXMLSchema:register(XMLValueType.ANGLE, "powerTakeOff#maxAngle" , "Max.angle between start and end" , 45 )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff#zOffset" , "Z axis offset of end node" , 0 )
        powerTakeOffXMLSchema:register(XMLValueType.STRING, "powerTakeOff#colorMaterialName" , "Color material name" , "powerTakeOff_main_mat" )
        powerTakeOffXMLSchema:register(XMLValueType.STRING, "powerTakeOff#decalColorMaterialName" , "Decal color material name" , "powerTakeOff_decal_mat" )

        AnimationManager.registerAnimationNodesXMLPaths(powerTakeOffXMLSchema, "powerTakeOff.animationNodes" )

        powerTakeOffXMLSchema:register(XMLValueType.BOOL, "powerTakeOff#isSingleJoint" , "Is single joint PTO" , false )
        powerTakeOffXMLSchema:register(XMLValueType.BOOL, "powerTakeOff#isDoubleJoint" , "Is double joint PTO" , false )

        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.startJoint#node" , "(Single Joint) Start joint node" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.endJoint#node" , "(Single Joint) End joint node" )

        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.scalePart#node" , "(Single|Double Joint) Scale part node" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.scalePart#referenceNode" , "(Single|Double Joint) Scale part reference node" )

        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.translationPart#node" , "(Single|Double Joint) translation part node" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.translationPart#referenceNode" , "(Single|Double Joint) translation part reference node" )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff.translationPart#length" , "(Single|Double Joint) translation part length" , 0.4 )

        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.translationPart.decal#node" , "(Single|Double Joint) translation part decal node" )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff.translationPart.decal#size" , "(Single|Double Joint) translation part decal size" , 0.1 )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff.translationPart.decal#offset" , "(Single|Double Joint) translation part decal offset" , 0.05 )
        powerTakeOffXMLSchema:register(XMLValueType.FLOAT, "powerTakeOff.translationPart.decal#minOffset" , "(Single|Double Joint) translation part decal minOffset" , 0.01 )

        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.startJoint1#node" , "(Double Joint) Start joint 1" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.startJoint2#node" , "(Double Joint) Start joint 2" )

        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.endJoint1#node" , "(Double Joint) End joint 1" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.endJoint1#referenceNode" , "(Double Joint) End joint 1 reference node" )
        powerTakeOffXMLSchema:register(XMLValueType.NODE_INDEX, "powerTakeOff.endJoint2#node" , "(Double Joint) End joint 2" )

        I3DUtil.registerI3dMappingXMLPaths(powerTakeOffXMLSchema, "powerTakeOff" )
    end

```

### loadBasicPowerTakeOff

**Description**

**Definition**

> loadBasicPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | xmlFile      |
| any | components   |
| any | i3dMappings  |

**Code**

```lua
function PowerTakeOffs:loadBasicPowerTakeOff(powerTakeOff, xmlFile, components, i3dMappings)
    powerTakeOff.startNode = xmlFile:getValue( "powerTakeOff.startNode#node" , nil , components, i3dMappings)
    powerTakeOff.linkNode = xmlFile:getValue( "powerTakeOff.linkNode#node" , nil , components, i3dMappings)

    powerTakeOff.attachFunc = PowerTakeOffs.attachTypedPowerTakeOff
    powerTakeOff.detachFunc = PowerTakeOffs.detachTypedPowerTakeOff
end

```

### loadDoubleJointPowerTakeOff

**Description**

**Definition**

> loadDoubleJointPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | xmlFile      |
| any | components   |
| any | i3dMappings  |

**Code**

```lua
function PowerTakeOffs:loadDoubleJointPowerTakeOff(powerTakeOff, xmlFile, components, i3dMappings)
    powerTakeOff.startJoint1 = xmlFile:getValue( "powerTakeOff.startJoint1#node" , nil , components, i3dMappings)
    powerTakeOff.startJoint2 = xmlFile:getValue( "powerTakeOff.startJoint2#node" , nil , components, i3dMappings)

    powerTakeOff.scalePart = xmlFile:getValue( "powerTakeOff.scalePart#node" , nil , components, i3dMappings)
    powerTakeOff.scalePartRef = xmlFile:getValue( "powerTakeOff.scalePart#referenceNode" , nil , components, i3dMappings)
    local _, _, dis = localToLocal(powerTakeOff.scalePartRef, powerTakeOff.scalePart, 0 , 0 , 0 )
    powerTakeOff.scalePartBaseDistance = dis

    powerTakeOff.translationPart = xmlFile:getValue( "powerTakeOff.translationPart#node" , nil , components, i3dMappings)
    powerTakeOff.translationPartRef = xmlFile:getValue( "powerTakeOff.translationPart#referenceNode" , nil , components, i3dMappings)
    powerTakeOff.translationPartLength = xmlFile:getValue( "powerTakeOff.translationPart#length" , 0.4 )

    powerTakeOff.decal = xmlFile:getValue( "powerTakeOff.translationPart.decal#node" , nil , components, i3dMappings)
    powerTakeOff.decalSize = xmlFile:getValue( "powerTakeOff.translationPart.decal#size" , 0.1 )
    powerTakeOff.decalOffset = xmlFile:getValue( "powerTakeOff.translationPart.decal#offset" , 0.05 )
    powerTakeOff.decalMinOffset = xmlFile:getValue( "powerTakeOff.translationPart.decal#minOffset" , 0.01 )

    powerTakeOff.endJoint1 = xmlFile:getValue( "powerTakeOff.endJoint1#node" , nil , components, i3dMappings)
    powerTakeOff.endJoint1Ref = xmlFile:getValue( "powerTakeOff.endJoint1#referenceNode" , nil , components, i3dMappings)

    powerTakeOff.endJoint2 = xmlFile:getValue( "powerTakeOff.endJoint2#node" , nil , components, i3dMappings)
    powerTakeOff.linkNode = xmlFile:getValue( "powerTakeOff.linkNode#node" , nil , components, i3dMappings)

    local _, _, betweenLength = localToLocal(powerTakeOff.translationPart, powerTakeOff.translationPartRef, 0 , 0 , 0 )
    local _, _, ptoLength = localToLocal(powerTakeOff.startNode, powerTakeOff.linkNode, 0 , 0 , 0 )
    powerTakeOff.betweenLength = math.abs(betweenLength)
    powerTakeOff.connectorLength = math.abs(ptoLength) - math.abs(betweenLength)

    setTranslation(powerTakeOff.linkNode, 0 , 0 , 0 )
    setRotation(powerTakeOff.linkNode, 0 , 0 , 0 )

    powerTakeOff.updateFunc = PowerTakeOffs.updateDoubleJointPowerTakeOff
    powerTakeOff.updateDistanceFunc = PowerTakeOffs.updateDistanceOfTypedPowerTakeOff
    powerTakeOff.attachFunc = PowerTakeOffs.attachTypedPowerTakeOff
    powerTakeOff.detachFunc = PowerTakeOffs.detachTypedPowerTakeOff
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
function PowerTakeOffs:loadExtraDependentParts(superFunc, xmlFile, baseName, entry)
    if not superFunc( self , xmlFile, baseName, entry) then
        return false
    end

    local indices = xmlFile:getValue(baseName .. ".powerTakeOffs#indices" , nil , true )
    if indices ~ = nil then
        entry.powerTakeOffs = { }

        for i = 1 , #indices do
            table.insert(entry.powerTakeOffs, indices[i])
        end
    end

    local localIndices = xmlFile:getValue(baseName .. ".powerTakeOffs#localIndices" , nil , true )
    if localIndices ~ = nil then
        entry.localPowerTakeOffs = { }

        for i = 1 , #localIndices do
            table.insert(entry.localPowerTakeOffs, localIndices[i])
        end
    end

    return true
end

```

### loadInputPowerTakeOff

**Description**

**Definition**

> loadInputPowerTakeOff()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | baseName          |
| any | powerTakeOffInput |

**Code**

```lua
function PowerTakeOffs:loadInputPowerTakeOff(xmlFile, baseName, powerTakeOffInput)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#color" , baseName .. "#materialTemplateName" ) -- FS22 to FS25
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#decalColor" , baseName .. "#decalMaterialTemplateName" ) -- FS22 to FS25

    local inputNode = xmlFile:getValue(baseName .. "#inputNode" , nil , self.components, self.i3dMappings)
    if inputNode = = nil then
        Logging.xmlWarning(xmlFile, "Pto input needs to have a valid 'inputNode' in '%s'" , baseName)
        return false
    end

    local inputAttacherJointIndices = { }
    local inputAttacherJointIndicesRaw = xmlFile:getValue(baseName .. "#inputAttacherJointIndices" , nil , true )
    if inputAttacherJointIndicesRaw ~ = nil then
        for _, inputAttacherJointIndex in ipairs(inputAttacherJointIndicesRaw) do

            if self:getInputAttacherJointByJointDescIndex(inputAttacherJointIndex) ~ = nil then
                inputAttacherJointIndices[inputAttacherJointIndex] = true
            else
                    if not self.spec_powerTakeOffs.ignoreInvalidJointIndices then
                        Logging.xmlWarning( self.xmlFile, "The given inputAttacherJointIndex '%d' for powerTakeOff can't be resolved into a valid attacherJoint in %s" , inputAttacherJointIndex, baseName)
                        end
                    end
                end
            end

            local inputAttacherJointNodesRaw = xmlFile:getValue(baseName .. "#inputAttacherJointNodes" , nil , self.components, self.i3dMappings, true )
            if inputAttacherJointNodesRaw ~ = nil then
                for _, node in ipairs(inputAttacherJointNodesRaw) do
                    local inputAttacherJointIndex = self:getInputAttacherJointIndexByNode(node)
                    if inputAttacherJointIndex ~ = nil then
                        inputAttacherJointIndices[inputAttacherJointIndex] = true
                    end
                end
            end

            if next(inputAttacherJointIndices) = = nil then
                Logging.xmlWarning(xmlFile, "Pto output needs to have valid 'inputAttacherJointIndices' or 'inputAttacherJointNodes' in '%s'" , baseName)
                return false
            end

            powerTakeOffInput.inputNode = inputNode
            if Platform.gameplay.hasDetachedPowerTakeOffs then
                powerTakeOffInput.detachNode = xmlFile:getValue(baseName .. "#detachNode" , nil , self.components, self.i3dMappings)
            end

            powerTakeOffInput.inputAttacherJointIndices = inputAttacherJointIndices

            powerTakeOffInput.aboveAttacher = xmlFile:getValue(baseName .. "#aboveAttacher" , true )

            powerTakeOffInput.material = xmlFile:getValue(baseName .. "#materialTemplateName" , nil , self.customEnvironment)
            powerTakeOffInput.decalMaterial = xmlFile:getValue(baseName .. "#decalMaterialTemplateName" , nil , self.customEnvironment)

            powerTakeOffInput.ptoName = xmlFile:getValue(baseName .. "#ptoName" , "DEFAULT_PTO" )

            powerTakeOffInput.localAnimationNodes = g_animationManager:loadAnimations(xmlFile, baseName .. ".animationNodes" , self.components, self , self.i3dMappings)

            powerTakeOffInput.objectChanges = { }
            ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, baseName, powerTakeOffInput.objectChanges, self.components, self )
            ObjectChangeUtil.setObjectChanges(powerTakeOffInput.objectChanges, false , self , self.setMovingToolDirty)

            local filename = xmlFile:getValue(baseName .. "#filename" , "$data/shared/assets/powerTakeOffs/walterscheidW.xml" )
            if filename ~ = nil then
                self:loadPowerTakeOffFromConfigFile(powerTakeOffInput, filename)
            end

            return true
        end

```

### loadLocalPowerTakeOff

**Description**

**Definition**

> loadLocalPowerTakeOff()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | baseName          |
| any | powerTakeOffLocal |

**Code**

```lua
function PowerTakeOffs:loadLocalPowerTakeOff(xmlFile, baseName, powerTakeOffLocal)
    powerTakeOffLocal.isLocal = true

    powerTakeOffLocal.inputNode = xmlFile:getValue(baseName .. "#startNode" , nil , self.components, self.i3dMappings)
    if powerTakeOffLocal.inputNode = = nil then
        Logging.xmlWarning(xmlFile, "Missing startNode for local power take off '%s'" , baseName)
            return false
        end

        powerTakeOffLocal.endNode = xmlFile:getValue(baseName .. "#endNode" , nil , self.components, self.i3dMappings)
        if powerTakeOffLocal.endNode = = nil then
            Logging.xmlWarning(xmlFile, "Missing endNode for local power take off '%s'" , baseName)
                return false
            end

            powerTakeOffLocal.material = xmlFile:getValue(baseName .. "#materialTemplateName" , nil , self.customEnvironment)
            powerTakeOffLocal.decalMaterial = xmlFile:getValue(baseName .. "#decalMaterialTemplateName" , nil , self.customEnvironment)

            powerTakeOffLocal.predefinedLength = xmlFile:getValue(baseName .. "#length" )

            local filename = xmlFile:getValue(baseName .. "#filename" , "$data/shared/assets/powerTakeOffs/walterscheidW.xml" )
            if filename ~ = nil then
                self:loadPowerTakeOffFromConfigFile(powerTakeOffLocal, filename)
            end

            return true
        end

```

### loadOutputPowerTakeOff

**Description**

**Definition**

> loadOutputPowerTakeOff()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | baseName           |
| any | powerTakeOffOutput |

**Code**

```lua
function PowerTakeOffs:loadOutputPowerTakeOff(xmlFile, baseName, powerTakeOffOutput)
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#linkNode" , baseName .. "#outputNode" ) -- FS19 to FS19
    XMLUtil.checkDeprecatedXMLElements(xmlFile, baseName .. "#filename" , "pto file is now defined in the pto input node" ) -- FS19 to FS19

    powerTakeOffOutput.skipToInputAttacherIndex = xmlFile:getValue(baseName .. "#skipToInputAttacherIndex" )

    local outputNode = xmlFile:getValue(baseName .. "#outputNode" , nil , self.components, self.i3dMappings)
    if outputNode = = nil and powerTakeOffOutput.skipToInputAttacherIndex = = nil then
        Logging.xmlWarning(xmlFile, "Pto output needs to have either a valid 'outputNode' or a 'skipToInputAttacherIndex' in '%s'" , baseName)
        return false
    end

    local attacherJointIndices = { }
    local attacherJointIndicesRaw = xmlFile:getValue(baseName .. "#attacherJointIndices" , nil , true )
    if attacherJointIndicesRaw ~ = nil then
        for _, attacherJointIndex in ipairs(attacherJointIndicesRaw) do
            if self:getAttacherJointByJointDescIndex(attacherJointIndex) ~ = nil then
                attacherJointIndices[attacherJointIndex] = true
            else
                    if not self.spec_powerTakeOffs.ignoreInvalidJointIndices then
                        Logging.xmlWarning( self.xmlFile, "The given attacherJointIndex '%d' for powerTakeOff can't be resolved into a valid attacherJoint in %s" , attacherJointIndex, baseName)
                        end
                    end
                end
            end

            local attacherJointNodesRaw = xmlFile:getValue(baseName .. "#attacherJointNodes" , nil , self.components, self.i3dMappings, true )
            if attacherJointNodesRaw ~ = nil then
                for _, node in ipairs(attacherJointNodesRaw) do
                    local attacherJointIndex = self:getAttacherJointIndexByNode(node)
                    if attacherJointIndex ~ = nil then
                        attacherJointIndices[attacherJointIndex] = true
                    end
                end
            end

            if next(attacherJointIndices) = = nil then
                return false
            end

            powerTakeOffOutput.outputNode = outputNode
            powerTakeOffOutput.attacherJointIndices = attacherJointIndices
            powerTakeOffOutput.connectedInput = nil

            powerTakeOffOutput.ptoName = xmlFile:getValue(baseName .. "#ptoName" , "DEFAULT_PTO" )

            powerTakeOffOutput.localAnimationNodes = g_animationManager:loadAnimations(xmlFile, baseName .. ".animationNodes" , self.components, self , self.i3dMappings)

            powerTakeOffOutput.objectChanges = { }
            ObjectChangeUtil.loadObjectChangeFromXML(xmlFile, baseName, powerTakeOffOutput.objectChanges, self.components, self )
            ObjectChangeUtil.setObjectChanges(powerTakeOffOutput.objectChanges, false , self , self.setMovingToolDirty)

            powerTakeOffOutput.isActive = false

            if self.registerDashboardValueType ~ = nil then
                local powerTakeOffLoadFunc = function ( self , xmlFile, key, dashboard, isActive)
                    local powerTakeOffIndex = xmlFile:getValue(key .. "#powerTakeOffIndex" )
                    if powerTakeOffIndex ~ = nil then
                        dashboard.powerTakeOffOutput = self.spec_powerTakeOffs.outputPowerTakeOffs[powerTakeOffIndex]
                    end

                    return true
                end

                local state = DashboardValueType.new( "powerTakeOffs" , "state" )
                state:setXMLKey(baseName)
                state:setValue(powerTakeOffOutput, function (_powerTakeOffOutput, dashboard)
                    return(dashboard.powerTakeOffOutput or _powerTakeOffOutput).isActive
                end )
                state:setAdditionalFunctions(powerTakeOffLoadFunc, nil )
                state:setPollUpdate( false )
                self:registerDashboardValueType(state)
            end

            return true
        end

```

### loadPowerTakeOffFromConfigFile

**Description**

**Definition**

> loadPowerTakeOffFromConfigFile()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | xmlFilename  |

**Code**

```lua
function PowerTakeOffs:loadPowerTakeOffFromConfigFile(powerTakeOff, xmlFilename)
    xmlFilename = Utils.getFilename(xmlFilename, self.baseDirectory)
    local xmlFile = XMLFile.load( "PtoConfig" , xmlFilename, PowerTakeOffs.xmlSchema)
    if xmlFile ~ = nil then
        local i3dFilename = xmlFile:getValue( "powerTakeOff#filename" )
        if i3dFilename ~ = nil then
            i3dFilename = Utils.getFilename(i3dFilename, self.baseDirectory)
            powerTakeOff.xmlFile = xmlFile
            local arguments = {
            xmlFile = xmlFile,
            powerTakeOff = powerTakeOff
            }
            powerTakeOff.sharedLoadRequestId = self:loadSubSharedI3DFile(i3dFilename, false , false , self.onPowerTakeOffI3DLoaded, self , arguments)
        else
                Logging.xmlWarning( self.xmlFile, "Failed to open powerTakeOff i3d file '%s' in '%s'" , i3dFilename, xmlFilename)
                xmlFile:delete()
            end
        else
                Logging.warning( "Failed to open powerTakeOff config file '%s'" , xmlFilename)
            end
        end

```

### loadPowerTakeOffsFromXML

**Description**

**Definition**

> loadPowerTakeOffsFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function PowerTakeOffs:loadPowerTakeOffsFromXML(xmlFile, key)
    local spec = self.spec_powerTakeOffs

    if SpecializationUtil.hasSpecialization( AttacherJoints , self.specializations) then
        xmlFile:iterate(key .. ".output" , function (_, outputKey)
            local powerTakeOffOutput = { }
            if self:loadOutputPowerTakeOff(xmlFile, outputKey, powerTakeOffOutput) then
                table.insert(spec.outputPowerTakeOffs, powerTakeOffOutput)
            end
        end )
    end

    if SpecializationUtil.hasSpecialization( Attachable , self.specializations) then
        xmlFile:iterate(key .. ".input" , function (_, inputKey)
            local powerTakeOffInput = { }
            if self:loadInputPowerTakeOff(xmlFile, inputKey, powerTakeOffInput) then
                table.insert(spec.inputPowerTakeOffs, powerTakeOffInput)
            end
        end )
    end

    xmlFile:iterate(key .. ".local" , function (_, localKey)
        local powerTakeOffLocal = { }
        if self:loadLocalPowerTakeOff(xmlFile, localKey, powerTakeOffLocal) then
            table.insert(spec.localPowerTakeOffs, powerTakeOffLocal)
        end
    end )
end

```

### loadSingleJointPowerTakeOff

**Description**

**Definition**

> loadSingleJointPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | xmlFile      |
| any | components   |
| any | i3dMappings  |

**Code**

```lua
function PowerTakeOffs:loadSingleJointPowerTakeOff(powerTakeOff, xmlFile, components, i3dMappings)
    powerTakeOff.startJoint = xmlFile:getValue( "powerTakeOff.startJoint#node" , nil , components, i3dMappings)

    powerTakeOff.scalePart = xmlFile:getValue( "powerTakeOff.scalePart#node" , nil , components, i3dMappings)
    powerTakeOff.scalePartRef = xmlFile:getValue( "powerTakeOff.scalePart#referenceNode" , nil , components, i3dMappings)
    local _, _, dis = localToLocal(powerTakeOff.scalePartRef, powerTakeOff.scalePart, 0 , 0 , 0 )
    powerTakeOff.scalePartBaseDistance = dis

    powerTakeOff.translationPart = xmlFile:getValue( "powerTakeOff.translationPart#node" , nil , components, i3dMappings)
    powerTakeOff.translationPartRef = xmlFile:getValue( "powerTakeOff.translationPart#referenceNode" , nil , components, i3dMappings)
    powerTakeOff.translationPartLength = xmlFile:getValue( "powerTakeOff.translationPart#length" , 0.4 )

    powerTakeOff.decal = xmlFile:getValue( "powerTakeOff.translationPart.decal#node" , nil , components, i3dMappings)
    powerTakeOff.decalSize = xmlFile:getValue( "powerTakeOff.translationPart.decal#size" , 0.1 )
    powerTakeOff.decalOffset = xmlFile:getValue( "powerTakeOff.translationPart.decal#offset" , 0.05 )
    powerTakeOff.decalMinOffset = xmlFile:getValue( "powerTakeOff.translationPart.decal#minOffset" , 0.01 )

    powerTakeOff.endJoint = xmlFile:getValue( "powerTakeOff.endJoint#node" , nil , components, i3dMappings)
    powerTakeOff.linkNode = xmlFile:getValue( "powerTakeOff.linkNode#node" , nil , components, i3dMappings)

    local _, _, betweenLength = localToLocal(powerTakeOff.translationPart, powerTakeOff.translationPartRef, 0 , 0 , 0 )
    local _, _, ptoLength = localToLocal(powerTakeOff.startNode, powerTakeOff.linkNode, 0 , 0 , 0 )
    powerTakeOff.betweenLength = math.abs(betweenLength)
    powerTakeOff.connectorLength = math.abs(ptoLength) - math.abs(betweenLength)

    setTranslation(powerTakeOff.linkNode, 0 , 0 , 0 )
    setRotation(powerTakeOff.linkNode, 0 , 0 , 0 )

    powerTakeOff.updateFunc = PowerTakeOffs.updateSingleJointPowerTakeOff
    powerTakeOff.updateDistanceFunc = PowerTakeOffs.updateDistanceOfTypedPowerTakeOff
    powerTakeOff.attachFunc = PowerTakeOffs.attachTypedPowerTakeOff
    powerTakeOff.detachFunc = PowerTakeOffs.detachTypedPowerTakeOff
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function PowerTakeOffs:onDelete()
    local spec = self.spec_powerTakeOffs
    if spec.outputPowerTakeOffs ~ = nil then
        for _, output in pairs(spec.outputPowerTakeOffs) do
            if output.xmlFile ~ = nil then
                output.xmlFile:delete()
                output.xmlFile = nil
            end
            if output.sharedLoadRequestId ~ = nil then
                g_i3DManager:releaseSharedI3DFile( output.sharedLoadRequestId)
                output.sharedLoadRequestId = nil
            end

            g_animationManager:deleteAnimations( output.localAnimationNodes)

            if output.rootNode ~ = nil then
                delete( output.rootNode)
                delete( output.attachNode)
            end
        end
    end

    if spec.inputPowerTakeOffs ~ = nil then
        for _, input in pairs(spec.inputPowerTakeOffs) do
            if input.xmlFile ~ = nil then
                input.xmlFile:delete()
                input.xmlFile = nil
            end
            if input.sharedLoadRequestId ~ = nil then
                g_i3DManager:releaseSharedI3DFile( input.sharedLoadRequestId)
                input.sharedLoadRequestId = nil
            end

            g_animationManager:deleteAnimations( input.animationNodes)
            g_animationManager:deleteAnimations( input.localAnimationNodes)

            if input.rootNode ~ = nil then
                delete( input.rootNode)
                delete( input.attachNode)
            end
        end
    end

    if spec.localPowerTakeOffs ~ = nil then
        for _,localPto in pairs(spec.localPowerTakeOffs) do
            if localPto.xmlFile ~ = nil then
                localPto.xmlFile:delete()
                localPto.xmlFile = nil
            end
            if localPto.sharedLoadRequestId ~ = nil then
                g_i3DManager:releaseSharedI3DFile(localPto.sharedLoadRequestId)
                localPto.sharedLoadRequestId = nil
            end
            g_animationManager:deleteAnimations(localPto.animationNodes)
        end
    end

    if spec.samples ~ = nil then
        g_soundManager:deleteSamples(spec.samples.turnedOn)
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
function PowerTakeOffs:onLoad(savegame)
    local spec = self.spec_powerTakeOffs

    spec.outputPowerTakeOffs = { }
    spec.inputPowerTakeOffs = { }
    spec.localPowerTakeOffs = { }

    spec.ignoreInvalidJointIndices = self.xmlFile:getValue( "vehicle.powerTakeOffs#ignoreInvalidJointIndices" , false )
    spec.maxUpdateDistance = self.xmlFile:getValue( "vehicle.powerTakeOffs#maxUpdateDistance" , PowerTakeOffs.DEFAULT_MAX_UPDATE_DISTANCE)
    spec.delayedPowerTakeOffsMountings = { }

    if not self.isClient then
        SpecializationUtil.removeEventListener( self , "onUpdateInterpolation" , PowerTakeOffs )
    else
            spec.samples = { }
            spec.samples.turnedOn = g_soundManager:loadSamplesFromXML( self.xmlFile, "vehicle.powerTakeOffs.sounds" , "turnedOn" , self.baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
        end
    end

```

### onPostAttachImplement

**Description**

**Definition**

> onPostAttachImplement()

**Arguments**

| any | attachableObject    |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |
| any | loadFromSavegame    |

**Code**

```lua
function PowerTakeOffs:onPostAttachImplement(attachableObject, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    local spec = self.spec_powerTakeOffs
    for i = #spec.delayedPowerTakeOffsMountings, 1 , - 1 do
        local delayedMounting = spec.delayedPowerTakeOffsMountings[i]
        if delayedMounting.jointDescIndex = = jointDescIndex then
            local input = delayedMounting.input
            local output = delayedMounting.output

            if input.attachFunc ~ = nil then
                input.attachFunc( self , input , output )
            end

            ObjectChangeUtil.setObjectChanges( input.objectChanges, true , self , self.setMovingToolDirty)
            ObjectChangeUtil.setObjectChanges( output.objectChanges, true , self , self.setMovingToolDirty)

            table.remove(spec.delayedPowerTakeOffsMountings, i)
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
function PowerTakeOffs:onPostLoad(savegame)
    local spec = self.spec_powerTakeOffs

    -- load the power take offs after all attacher joints have been loaded
    self:loadPowerTakeOffsFromXML( self.xmlFile, "vehicle.powerTakeOffs" )

    local configKey = string.format( "vehicle.powerTakeOffs.powerTakeOffConfigurations.powerTakeOffConfiguration(%d)" , spec.configIndex - 1 )
    if self.xmlFile:hasProperty(configKey) then
        self:loadPowerTakeOffsFromXML( self.xmlFile, configKey)
    end
end

```

### onPowerTakeOffI3DLoaded

**Description**

**Definition**

> onPowerTakeOffI3DLoaded()

**Arguments**

| any | i3dNode      |
|-----|--------------|
| any | failedReason |
| any | args         |

**Code**

```lua
function PowerTakeOffs:onPowerTakeOffI3DLoaded(i3dNode, failedReason, args)
    local xmlFile = args.xmlFile
    local powerTakeOff = args.powerTakeOff

    if i3dNode ~ = 0 then
        powerTakeOff.components = { }
        powerTakeOff.i3dMappings = { }
        I3DUtil.loadI3DComponents(i3dNode, powerTakeOff.components)
        I3DUtil.loadI3DMapping(xmlFile, "powerTakeOff" , powerTakeOff.components, powerTakeOff.i3dMappings)

        powerTakeOff.startNode = xmlFile:getValue( "powerTakeOff.startNode#node" , nil , powerTakeOff.components, powerTakeOff.i3dMappings)
        if powerTakeOff.startNode ~ = nil then
            powerTakeOff.size = xmlFile:getValue( "powerTakeOff#size" , 0.19 )
            powerTakeOff.minLength = xmlFile:getValue( "powerTakeOff#minLength" , 0.6 )
            powerTakeOff.maxAngle = xmlFile:getValue( "powerTakeOff#maxAngle" , 45 )
            powerTakeOff.zOffset = xmlFile:getValue( "powerTakeOff#zOffset" , 0 )

            powerTakeOff.animationNodes = g_animationManager:loadAnimations(xmlFile, "powerTakeOff.animationNodes" , powerTakeOff.components, self , powerTakeOff.i3dMappings)

            if powerTakeOff.material ~ = nil then
                local materialName = xmlFile:getValue( "powerTakeOff#colorMaterialName" , "powerTakeOff_main_mat" )
                powerTakeOff.material:apply(powerTakeOff.startNode, materialName, true )
            end

            if powerTakeOff.decalMaterial ~ = nil then
                local materialName = xmlFile:getValue( "powerTakeOff#decalColorMaterialName" , "powerTakeOff_decal_mat" )
                powerTakeOff.decalMaterial:apply(powerTakeOff.startNode, materialName, true )
            end

            if xmlFile:getValue( "powerTakeOff#isSingleJoint" ) then
                self:loadSingleJointPowerTakeOff(powerTakeOff, xmlFile, powerTakeOff.components, powerTakeOff.i3dMappings)
            elseif xmlFile:getValue( "powerTakeOff#isDoubleJoint" ) then
                    self:loadDoubleJointPowerTakeOff(powerTakeOff, xmlFile, powerTakeOff.components, powerTakeOff.i3dMappings)
                else
                        self:loadBasicPowerTakeOff(powerTakeOff, xmlFile, powerTakeOff.components, powerTakeOff.i3dMappings)
                    end

                    link(powerTakeOff.inputNode, powerTakeOff.startNode)

                    powerTakeOff.i3dLoaded = true

                    if powerTakeOff.isLocal then
                        self:placeLocalPowerTakeOff(powerTakeOff)
                    else
                            self:parkPowerTakeOff(powerTakeOff)
                        end

                        self:updatePowerTakeOff(powerTakeOff, 0 )
                    else
                            Logging.xmlWarning(xmlFile, "Failed to find startNode in powerTakeOff file '%s'" , xmlFile.filename)
                        end

                        delete(i3dNode)
                    else
                            if not( self.isDeleted or self.isDeleting) then
                                Logging.xmlWarning( self.xmlFile, "Failed to find powerTakeOff in file '%s'" , xmlFile.filename)
                            end
                        end

                        xmlFile:delete()
                        powerTakeOff.xmlFile = nil
                    end

```

### onPreAttachImplement

**Description**

**Definition**

> onPreAttachImplement()

**Arguments**

| any | attachableObject    |
|-----|---------------------|
| any | inputJointDescIndex |
| any | jointDescIndex      |
| any | loadFromSavegame    |

**Code**

```lua
function PowerTakeOffs:onPreAttachImplement(attachableObject, inputJointDescIndex, jointDescIndex, loadFromSavegame)
    self:attachPowerTakeOff(attachableObject, inputJointDescIndex, jointDescIndex)
end

```

### onPreDetachImplement

**Description**

**Definition**

> onPreDetachImplement()

**Arguments**

| any | implement |
|-----|-----------|

**Code**

```lua
function PowerTakeOffs:onPreDetachImplement(implement)
    self:detachPowerTakeOff( self , implement)

    if self.isClient then
        local spec = self.spec_powerTakeOffs
        g_soundManager:stopSamples(spec.samples.turnedOn)
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
function PowerTakeOffs:onPreLoad(savegame)
    local spec = self.spec_powerTakeOffs
    spec.configIndex = self:getPowerTakeOffConfigIndex()
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
function PowerTakeOffs:onUpdateEnd(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    -- final update before the physics sleeps(self.currentUpdateDistance is 0 here)
    PowerTakeOffs.onUpdateInterpolation( self , dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
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
function PowerTakeOffs:onUpdateInterpolation(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if self.isClient then
        local spec = self.spec_powerTakeOffs
        if self.currentUpdateDistance < spec.maxUpdateDistance then
            for i = 1 , #spec.inputPowerTakeOffs do
                local input = spec.inputPowerTakeOffs[i]
                if input.connectedVehicle ~ = nil then
                    if self.updateLoopIndex = = input.connectedVehicle.updateLoopIndex then
                        self:updatePowerTakeOff( input , dt)
                    end
                end
            end

            if self.getAttachedImplements ~ = nil then
                local impements = self:getAttachedImplements()
                for i = 1 , #impements do
                    local object = impements[i].object
                    if object.updateAttachedPowerTakeOffs ~ = nil then
                        object:updateAttachedPowerTakeOffs(dt, self )
                    end
                end
            end

            local isPowerTakeOffActive = self.isActive and self:getIsPowerTakeOffActive()
            if spec.lastIsPowerTakeOffActive ~ = isPowerTakeOffActive then
                for i = 1 , #spec.inputPowerTakeOffs do
                    local input = spec.inputPowerTakeOffs[i]
                    if isPowerTakeOffActive and input.connectedVehicle ~ = nil then
                        g_animationManager:startAnimations( input.animationNodes)
                        g_animationManager:startAnimations( input.localAnimationNodes)
                        g_animationManager:startAnimations( input.connectedOutput.localAnimationNodes)
                        input.connectedOutput.isActive = true

                        if input.connectedVehicle.updateDashboardValueType ~ = nil then
                            input.connectedVehicle:updateDashboardValueType( "powerTakeOffs.state" )
                        end
                    else
                            g_animationManager:stopAnimations( input.animationNodes)
                            g_animationManager:stopAnimations( input.localAnimationNodes)
                            if input.connectedOutput ~ = nil then
                                g_animationManager:stopAnimations( input.connectedOutput.localAnimationNodes)
                                input.connectedOutput.isActive = false

                                if input.connectedVehicle.updateDashboardValueType ~ = nil then
                                    input.connectedVehicle:updateDashboardValueType( "powerTakeOffs.state" )
                                end
                            end
                        end
                    end

                    for i = 1 , #spec.localPowerTakeOffs do
                        local localPto = spec.localPowerTakeOffs[i]
                        if isPowerTakeOffActive then
                            g_animationManager:startAnimations(localPto.animationNodes)
                        else
                                g_animationManager:stopAnimations(localPto.animationNodes)
                            end
                        end

                        if isPowerTakeOffActive then
                            g_soundManager:playSamples(spec.samples.turnedOn)
                        else
                                g_soundManager:stopSamples(spec.samples.turnedOn)
                            end

                            spec.lastIsPowerTakeOffActive = isPowerTakeOffActive
                        end
                    end
                end
            end

```

### parkPowerTakeOff

**Description**

**Definition**

> parkPowerTakeOff()

**Arguments**

| any | input |
|-----|-------|

**Code**

```lua
function PowerTakeOffs:parkPowerTakeOff( input )
    if input.detachNode ~ = nil then
        link( input.detachNode, input.linkNode)
        link( input.inputNode, input.startNode)
        self:updatePowerTakeOff( input , 0 )
        self:updatePowerTakeOffLength( input )

        input.isLinked = true
    else
            -- keep both inside of the vehicle
            -- so other specializations can still keep track of them(e.g.washable)
            link( input.inputNode, input.linkNode)
            link( input.inputNode, input.startNode)

            setVisibility( input.linkNode, false )
            setVisibility( input.startNode, false )

            input.isLinked = false
        end

        setTranslation( input.linkNode, 0 , 0 , input.zOffset)
        setTranslation( input.startNode, 0 , 0 , - input.zOffset)
    end

```

### placeLocalPowerTakeOff

**Description**

**Definition**

> placeLocalPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|

**Code**

```lua
function PowerTakeOffs:placeLocalPowerTakeOff(powerTakeOff)
    if powerTakeOff.i3dLoaded then
        if not powerTakeOff.isPlaced then
            link(powerTakeOff.endNode, powerTakeOff.linkNode)

            setTranslation(powerTakeOff.linkNode, 0 , 0 , powerTakeOff.zOffset)
            setTranslation(powerTakeOff.startNode, 0 , 0 , - powerTakeOff.zOffset)

            self:updatePowerTakeOffLength(powerTakeOff)
            powerTakeOff.isPlaced = true
        end

        self:updatePowerTakeOff(powerTakeOff, 0 )
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
function PowerTakeOffs.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( AttacherJoints , specializations)
    or SpecializationUtil.hasSpecialization( Attachable , specializations)
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
function PowerTakeOffs.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onLoad" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onDelete" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateInterpolation" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onUpdateEnd" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onPreAttachImplement" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onPostAttachImplement" , PowerTakeOffs )
    SpecializationUtil.registerEventListener(vehicleType, "onPreDetachImplement" , PowerTakeOffs )
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
function PowerTakeOffs.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getPowerTakeOffConfigIndex" , PowerTakeOffs.getPowerTakeOffConfigIndex)
    SpecializationUtil.registerFunction(vehicleType, "loadPowerTakeOffsFromXML" , PowerTakeOffs.loadPowerTakeOffsFromXML)
    SpecializationUtil.registerFunction(vehicleType, "loadOutputPowerTakeOff" , PowerTakeOffs.loadOutputPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "loadInputPowerTakeOff" , PowerTakeOffs.loadInputPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "loadLocalPowerTakeOff" , PowerTakeOffs.loadLocalPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "placeLocalPowerTakeOff" , PowerTakeOffs.placeLocalPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "updatePowerTakeOff" , PowerTakeOffs.updatePowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "updateAttachedPowerTakeOffs" , PowerTakeOffs.updateAttachedPowerTakeOffs)
    SpecializationUtil.registerFunction(vehicleType, "updatePowerTakeOffLength" , PowerTakeOffs.updatePowerTakeOffLength)
    SpecializationUtil.registerFunction(vehicleType, "getOutputPowerTakeOffsByJointDescIndex" , PowerTakeOffs.getOutputPowerTakeOffsByJointDescIndex)
    SpecializationUtil.registerFunction(vehicleType, "getOutputPowerTakeOffs" , PowerTakeOffs.getOutputPowerTakeOffs)
    SpecializationUtil.registerFunction(vehicleType, "getInputPowerTakeOffs" , PowerTakeOffs.getInputPowerTakeOffs)
    SpecializationUtil.registerFunction(vehicleType, "getInputPowerTakeOffsByJointDescIndexAndName" , PowerTakeOffs.getInputPowerTakeOffsByJointDescIndexAndName)
    SpecializationUtil.registerFunction(vehicleType, "getIsPowerTakeOffActive" , PowerTakeOffs.getIsPowerTakeOffActive)
    SpecializationUtil.registerFunction(vehicleType, "attachPowerTakeOff" , PowerTakeOffs.attachPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "detachPowerTakeOff" , PowerTakeOffs.detachPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "checkPowerTakeOffCollision" , PowerTakeOffs.checkPowerTakeOffCollision)
    SpecializationUtil.registerFunction(vehicleType, "parkPowerTakeOff" , PowerTakeOffs.parkPowerTakeOff)

    SpecializationUtil.registerFunction(vehicleType, "loadPowerTakeOffFromConfigFile" , PowerTakeOffs.loadPowerTakeOffFromConfigFile)
    SpecializationUtil.registerFunction(vehicleType, "onPowerTakeOffI3DLoaded" , PowerTakeOffs.onPowerTakeOffI3DLoaded)

    SpecializationUtil.registerFunction(vehicleType, "loadSingleJointPowerTakeOff" , PowerTakeOffs.loadSingleJointPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "updateSingleJointPowerTakeOff" , PowerTakeOffs.updateSingleJointPowerTakeOff)

    SpecializationUtil.registerFunction(vehicleType, "loadDoubleJointPowerTakeOff" , PowerTakeOffs.loadDoubleJointPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "updateDoubleJointPowerTakeOff" , PowerTakeOffs.updateDoubleJointPowerTakeOff)

    SpecializationUtil.registerFunction(vehicleType, "loadBasicPowerTakeOff" , PowerTakeOffs.loadBasicPowerTakeOff)

    SpecializationUtil.registerFunction(vehicleType, "attachTypedPowerTakeOff" , PowerTakeOffs.attachTypedPowerTakeOff)
    SpecializationUtil.registerFunction(vehicleType, "detachTypedPowerTakeOff" , PowerTakeOffs.detachTypedPowerTakeOff)

    SpecializationUtil.registerFunction(vehicleType, "validatePowerTakeOffAttachment" , PowerTakeOffs.validatePowerTakeOffAttachment)
end

```

### registerInputXMLPaths

**Description**

**Definition**

> registerInputXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PowerTakeOffs.registerInputXMLPaths(schema, basePath)
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#inputNode" , "Input node" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#inputAttacherJointIndices" , "Corresponding Input attacher joint(s) (List of indices)" )
    schema:register(XMLValueType.NODE_INDICES, basePath .. "#inputAttacherJointNodes" , "Corresponding Input attacher joint(s) (List of attacherJoint nodes)" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#detachNode" , "Detach node" )
    schema:register(XMLValueType.BOOL, basePath .. "#aboveAttacher" , "Above attacher" , true )
    schema:register(XMLValueType.VEHICLE_MATERIAL, basePath .. "#materialTemplateName" , "Name of shared material to apply to the main pto" )
    schema:registerAutoCompletionDataSource(basePath .. "#materialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
    schema:register(XMLValueType.VEHICLE_MATERIAL, basePath .. "#decalMaterialTemplateName" , "Name of shared material to apply to the decals" )
    schema:registerAutoCompletionDataSource(basePath .. "#decalMaterialTemplateName" , "$data/shared/brandMaterialTemplates.xml" , "templates.template#name" )
    schema:register(XMLValueType.FLOAT, basePath .. "#length" , "Predefined length of the PTO(Otherwise calculated from the distance between startNode and endNode, while loading.Can be useful if the tool is loaded in different states to always get the same length.)" )
        schema:register(XMLValueType.STRING, basePath .. "#filename" , "Path to pto xml file" , "$data/shared/assets/powerTakeOffs/walterscheidW.xml" )
        schema:register(XMLValueType.STRING, basePath .. "#ptoName" , "Pto name" , "DEFAULT_PTO" )

        AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".animationNodes" )
        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
    end

```

### registerOutputXMLPaths

**Description**

**Definition**

> registerOutputXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PowerTakeOffs.registerOutputXMLPaths(schema, basePath)
    schema:register(XMLValueType.INT, basePath .. "#skipToInputAttacherIndex" , "Skip to input attacher joint index" )
    schema:register(XMLValueType.NODE_INDEX, basePath .. "#outputNode" , "Output node" )
    schema:register(XMLValueType.VECTOR_N, basePath .. "#attacherJointIndices" , "Corresponding attacher joint(s) (List of indices)" )
    schema:register(XMLValueType.NODE_INDICES, basePath .. "#attacherJointNodes" , "Corresponding attacher joint(s) (List of attacherJoint nodes)" )
    schema:register(XMLValueType.STRING, basePath .. "#ptoName" , "Output name" , "DEFAULT_PTO" )

    AnimationManager.registerAnimationNodesXMLPaths(schema, basePath .. ".animationNodes" )
    ObjectChangeUtil.registerObjectChangeXMLPaths(schema, basePath)
    Dashboard.registerDashboardXMLPaths(schema, basePath, { "state" } )
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
function PowerTakeOffs.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadExtraDependentParts" , PowerTakeOffs.loadExtraDependentParts)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "updateExtraDependentParts" , PowerTakeOffs.updateExtraDependentParts)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PowerTakeOffs.registerXMLPaths(schema, basePath)
    PowerTakeOffs.registerOutputXMLPaths(schema, basePath .. ".output(?)" )
    PowerTakeOffs.registerInputXMLPaths(schema, basePath .. ".input(?)" )
    PowerTakeOffs.registerLocalXMLPaths(schema, basePath .. ".local(?)" )
end

```

### updateAttachedPowerTakeOffs

**Description**

**Definition**

> updateAttachedPowerTakeOffs()

**Arguments**

| any | dt              |
|-----|-----------------|
| any | attacherVehicle |

**Code**

```lua
function PowerTakeOffs:updateAttachedPowerTakeOffs(dt, attacherVehicle)
    local spec = self.spec_powerTakeOffs
    for _, input in pairs(spec.inputPowerTakeOffs) do
        if input.connectedVehicle ~ = nil then
            if input.connectedVehicle = = attacherVehicle then
                if self.updateLoopIndex = = input.connectedVehicle.updateLoopIndex then
                    self:updatePowerTakeOff( input , dt)
                end
            end
        end
    end
end

```

### updateDistanceOfTypedPowerTakeOff

**Description**

**Definition**

> updateDistanceOfTypedPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|

**Code**

```lua
function PowerTakeOffs:updateDistanceOfTypedPowerTakeOff(powerTakeOff)
    local attachLength = powerTakeOff.predefinedLength or calcDistanceFrom(powerTakeOff.linkNode, powerTakeOff.startNode)
    local transPartScale = math.max(attachLength - powerTakeOff.connectorLength, 0 ) / powerTakeOff.betweenLength
    setScale(powerTakeOff.translationPart, 1 , 1 , transPartScale)

    if powerTakeOff.decal ~ = nil then
        local transPartLength = transPartScale * powerTakeOff.translationPartLength

        if transPartLength > powerTakeOff.decalMinOffset * 2 + powerTakeOff.decalSize then
            local offset = math.min((transPartLength - powerTakeOff.decalSize) / 2 , powerTakeOff.decalOffset)
            local decalTranslation = offset + powerTakeOff.decalSize * 0.5
            local x, y, _ = getTranslation(powerTakeOff.decal)
            setTranslation(powerTakeOff.decal, x, y, - decalTranslation / transPartScale)
            setScale(powerTakeOff.decal, 1 , 1 , 1 / transPartScale)
        else
                setVisibility(powerTakeOff.decal, false )
            end
        end
    end

```

### updateDoubleJointPowerTakeOff

**Description**

**Definition**

> updateDoubleJointPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | dt           |

**Code**

```lua
function PowerTakeOffs:updateDoubleJointPowerTakeOff(powerTakeOff, dt)
    local x, y, z = getWorldTranslation(powerTakeOff.startNode)
    local dx, dy, dz = worldToLocal(getParent(powerTakeOff.endJoint2), x, y, z)
    dx, dy, dz = MathUtil.vector3Normalize(dx, dy, dz)
    I3DUtil.setDirection(powerTakeOff.endJoint2, dx * 0.5 , dy * 0.5 , (dz + 1 ) * 0.5 , 0 , 1 , 0 )

    x, y, z = getWorldTranslation(powerTakeOff.endJoint1Ref)
    dx, dy, dz = worldToLocal(getParent(powerTakeOff.startJoint1), x, y, z)
    dx, dy, dz = MathUtil.vector3Normalize(dx, dy, dz)
    I3DUtil.setDirection(powerTakeOff.startJoint1, dx * 0.5 , dy * 0.5 , (dz + 1 ) * 0.5 , 0 , 1 , 0 )

    x, y, z = getWorldTranslation(powerTakeOff.endJoint1Ref)
    dx, dy, dz = worldToLocal(getParent(powerTakeOff.startJoint2), x, y, z)
    dx, dy, dz = MathUtil.vector3Normalize(dx, dy, dz)
    I3DUtil.setDirection(powerTakeOff.startJoint2, dx, dy, dz, 0 , 1 , 0 )

    dx, dy, dz = worldToLocal(getParent(powerTakeOff.endJoint1), x, y, z)
    setTranslation(powerTakeOff.endJoint1, 0 , 0 , MathUtil.vector3Length(dx, dy, dz))

    local dist = calcDistanceFrom(powerTakeOff.scalePart, powerTakeOff.scalePartRef)
    setScale(powerTakeOff.scalePart, 1 , 1 , dist / powerTakeOff.scalePartBaseDistance)
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
function PowerTakeOffs:updateExtraDependentParts(superFunc, part, dt)
    superFunc( self , part, dt)

    if part.powerTakeOffs ~ = nil then
        local spec = self.spec_powerTakeOffs
        for i, index in ipairs(part.powerTakeOffs) do
            if spec.inputPowerTakeOffs[index] = = nil then
                if self.finishedLoading then
                    part.powerTakeOffs[i] = nil
                    Logging.xmlWarning( self.xmlFile, "Unable to find powerTakeOff index '%d' for movingPart/movingTool '%s'" , index, getName(part.node))
                    end
                else
                        self:updatePowerTakeOff(spec.inputPowerTakeOffs[index], dt)
                    end
                end
            end

            if part.localPowerTakeOffs ~ = nil then
                local spec = self.spec_powerTakeOffs
                for i, index in ipairs(part.localPowerTakeOffs) do
                    if spec.localPowerTakeOffs[index] = = nil then
                        if self.finishedLoading then
                            part.localPowerTakeOffs[i] = nil
                            Logging.xmlWarning( self.xmlFile, "Unable to find local powerTakeOff index '%d' for movingPart/movingTool '%s'" , index, getName(part.node))
                            end
                        else
                                self:placeLocalPowerTakeOff(spec.localPowerTakeOffs[index], dt)
                            end
                        end
                    end
                end

```

### updatePowerTakeOff

**Description**

**Definition**

> updatePowerTakeOff()

**Arguments**

| any | input |
|-----|-------|
| any | dt    |

**Code**

```lua
function PowerTakeOffs:updatePowerTakeOff( input , dt)
    if input.i3dLoaded and( input.isLinked or input.isPlaced) then
        if input.updateFunc ~ = nil then
            input.updateFunc( self , input , dt)
        end
    end
end

```

### updatePowerTakeOffLength

**Description**

**Definition**

> updatePowerTakeOffLength()

**Arguments**

| any | input |
|-----|-------|

**Code**

```lua
function PowerTakeOffs:updatePowerTakeOffLength( input )
    if input.i3dLoaded then
        if input.updateDistanceFunc ~ = nil then
            input.updateDistanceFunc( self , input )
        end
    end
end

```

### updateSingleJointPowerTakeOff

**Description**

**Definition**

> updateSingleJointPowerTakeOff()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | dt           |

**Code**

```lua
function PowerTakeOffs:updateSingleJointPowerTakeOff(powerTakeOff, dt)
    local x, y, z = getWorldTranslation(powerTakeOff.linkNode)

    local dx, dy, dz = worldToLocal(powerTakeOff.startNode, x, y, z)
    I3DUtil.setDirection(powerTakeOff.startJoint, dx, dy, dz, 0 , 1 , 0 )

    dx, dy, dz = worldToLocal(getParent(powerTakeOff.endJoint), x, y, z)
    setTranslation(powerTakeOff.endJoint, 0 , 0 , MathUtil.vector3Length(dx, dy, dz))

    local dist = calcDistanceFrom(powerTakeOff.scalePart, powerTakeOff.scalePartRef)
    setScale(powerTakeOff.scalePart, 1 , 1 , dist / powerTakeOff.scalePartBaseDistance)
end

```

### validatePowerTakeOffAttachment

**Description**

**Definition**

> validatePowerTakeOffAttachment()

**Arguments**

| any | powerTakeOff |
|-----|--------------|
| any | output       |

**Code**

```lua
function PowerTakeOffs:validatePowerTakeOffAttachment(powerTakeOff, output )
    if output.outputNode = = nil or powerTakeOff.inputNode = = nil then
        return false
    end

    local x1, y1, z1 = getWorldTranslation( output.outputNode)
    local x2, y2, z2 = getWorldTranslation(powerTakeOff.inputNode)

    local length = MathUtil.vector3Length(x1 - x2, y1 - y2, z1 - z2)
    if length < powerTakeOff.minLength then
        return false
    end

    local length2D = MathUtil.vector2Length(x1 - x2, z1 - z2)
    local angle = math.acos(length2D / length)
    if angle > powerTakeOff.maxAngle then
        return false
    end

    return true
end

```