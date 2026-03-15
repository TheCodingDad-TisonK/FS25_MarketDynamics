## HandToolChainsaw

**Description**

> The hand tool specialisation for chainsaws.

**Functions**

- [beginCutting](#begincutting)
- [beginDelimbing](#begindelimbing)
- [calculateCutPlane](#calculatecutplane)
- [getChainSpeedFactor](#getchainspeedfactor)
- [onCutAction](#oncutaction)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onHeldEnd](#onheldend)
- [onHeldStart](#onheldstart)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onRingLoadFinished](#onringloadfinished)
- [onRollAction](#onrollaction)
- [onUpdate](#onupdate)
- [onWriteUpdateStream](#onwriteupdatestream)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [setCurrentCutState](#setcurrentcutstate)
- [stopCutting](#stopcutting)
- [stopDelimbing](#stopdelimbing)
- [testIfCutAllowed](#testifcutallowed)
- [testIfCutValid](#testifcutvalid)
- [testIfTooLow](#testiftoolow)
- [updateCutting](#updatecutting)
- [updateCuttingAnimation](#updatecuttinganimation)
- [updateRingSelector](#updateringselector)
- [updateSplitPlane](#updatesplitplane)

### beginCutting

**Description**

**Definition**

> beginCutting()

**Code**

```lua
function HandToolChainsaw:beginCutting()
    local spec = self.spec_chainsaw

    if spec.ringNode ~ = nil then
        setVisibility(spec.ringNode, false )
    end

    local player = self:getCarryingPlayer()
    if player = = nil or not player.isOwner then
        return
    end

    if spec.possibleTreeNode = = nil then
        return
    end

    local cutX, _, cutZ = getWorldTranslation(spec.cameraRotationNode)
    if not self:testIfCutAllowed(spec.possibleTreeNode, cutX, cutZ) then
        local mission = g_currentMission
        mission:showBlinkingWarning(g_i18n:getText( "warning_youAreNotAllowedToCutThisTree" ), 2000 )

        return
    end

    local _, _, rotZ = getRotation(spec.cameraRotationNode)
    self:setCurrentCutState(ChainsawCutState.CUTTING, rotZ < 0.7 )

    -- Set the tree that is being cut.
    spec.cuttingTreeNode = spec.possibleTreeNode

    -- Reset the load and set the target RPM based on it.This will kick the chainsaw into max RPM.
    self:setCurrentLoad( 0 )

    -- Set the state.
    spec.currentCutTime = 0

    -- Calculate the amount of time the chainsaw will need to spin up to speed.
    spec.currentTargetStartupTime = math.max( math.floor( self:getTimeToReachRPM( self:getMaxRPM()) * 1000 ), 0.00001 )

    -- Calculate the oval-shaped area of the cut.
    local cutArea = (spec.cutMaximumZ - spec.cutMinimumZ) * (spec.cutMaximumY - spec.cutMinimumY) * math.pi

    -- Set the target cut time based on the area and startup time.
    spec.currentTargetCutTime = (cutArea * spec.cutTimePerSquareMeter) + spec.currentTargetStartupTime

    -- Calculate the very start of the cutting position, where the chainsaw is given some space to rev up.
    spec.cutRevPositionX, spec.cutRevPositionY, spec.cutRevPositionZ = localToWorld(spec.splitPlaneNode, spec.cutMinimumY - ( 0.05 ), 0 , spec.cutMinimumZ)

    -- Calculate the start and end position for the cut.
    spec.cutStartPositionX, spec.cutStartPositionY, spec.cutStartPositionZ = localToWorld(spec.splitPlaneNode, spec.cutMinimumY, 0 , spec.cutMinimumZ)
    spec.cutEndPositionX, spec.cutEndPositionY, spec.cutEndPositionZ = localToWorld(spec.splitPlaneNode, spec.cutMaximumY, 0 , spec.cutMinimumZ)

    -- Attach the graphical node of the chainsaw to the cut guide node.
    HandToolUtil.linkAndTransformRelativeToParent( self.graphicalNode, spec.cutNode, spec.cutGuideNode)

    -- Lock the player's input so they cannot move or look around.
    if player.inputComponent ~ = nil then
        player.inputComponent:lock()
    end
end

```

### beginDelimbing

**Description**

**Definition**

> beginDelimbing()

**Code**

```lua
function HandToolChainsaw:beginDelimbing()
    local spec = self.spec_chainsaw

    local player = self:getCarryingPlayer()
    if player = = nil or not player.isOwner then
        return
    end

    self:setCurrentCutState(ChainsawCutState.DELIMBING, true )

    -- Reset the load and set the target RPM based on it.This will kick the chainsaw into max RPM.
    self:setCurrentLoad( 0 )
    self:setTargetRPMToMax()

    g_inputBinding:setActionEventTextVisibility(spec.activateActionId, false )
end

```

### calculateCutPlane

**Description**

**Definition**

> calculateCutPlane()

**Code**

```lua
function HandToolChainsaw:calculateCutPlane()
    local spec = self.spec_chainsaw
    local x, y, z = getWorldTranslation(spec.splitPlaneNode)
    local downX, downY, downZ = localDirectionToWorld(spec.splitPlaneNode, 0 , - 1 , 0 )
    local leftX, leftY, leftZ = localDirectionToWorld(spec.splitPlaneNode, 1 , 0 , 0 )
    local planeWidth = spec.maximumCutDiameter
    local planeDepth = spec.maximumCutDiameter + HandToolChainsaw.SPLIT_PLANE_OFFSET_Z

    return x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth
end

```

### getChainSpeedFactor

**Description**

**Definition**

> getChainSpeedFactor()

**Code**

```lua
function HandToolChainsaw:getChainSpeedFactor()
    local motorizedSpec = self.spec_motorized
    return MathUtil.inverseLerp( 0.3 , 1 , MathUtil.lerp(motorizedSpec.minRPM, motorizedSpec.maxRPM, motorizedSpec.currentRPM))
end

```

### onCutAction

**Description**

**Definition**

> onCutAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolChainsaw:onCutAction(_, inputValue)
    -- Find if the input is being engaged or released.
        local isInputDown = inputValue > 0

        local spec = self.spec_chainsaw

        spec.isCutting = isInputDown

        -- If the input is released, handle cancelling the current action.
        if not isInputDown then
            if spec.currentCutState = = ChainsawCutState.CUTTING then
                self:stopCutting( false )
            elseif spec.currentCutState = = ChainsawCutState.DELIMBING then
                    self:stopDelimbing()
                else
                        spec.currentCutState = ChainsawCutState.IDLE
                    end

                    return
                end

                -- Get the targeted tree.If there is no tree, start the delimbing state.
                if spec.targetedTree = = nil then
                    self:beginDelimbing()
                    -- Otherwise; begin cutting.
                else
                        self:beginCutting()

                        -- If cutting failed, start delimbing instead.This has the effect of revving up the chainsaw even if the cut was invalid.
                            if spec.currentCutState ~ = ChainsawCutState.CUTTING then
                                self:beginDelimbing()
                            end
                        end
                    end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolChainsaw:onDelete()
    local spec = self.spec_chainsaw

    -- Release the shared i3d file for the ring indicator.
        if spec.ringSharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile(spec.ringSharedLoadRequestId)
            spec.ringSharedLoadRequestId = nil
        end

        -- Delete the animations and effects.
        if spec.chainsAnimation ~ = nil then
            g_animationManager:deleteAnimations(spec.chainsAnimation)
        end
        g_effectManager:deleteEffects(spec.effects)

        g_soundManager:deleteSamples(spec.cutSamples)

        -- Delete the cut guide node.
        if spec.cutGuideNode ~ = nil then
            delete(spec.cutGuideNode)
            spec.cutGuideNode = nil
        end

        -- Delete the camera rotation node and set all its children to nil.
        if spec.cameraRotationNode ~ = nil then
            delete(spec.cameraRotationNode)
            spec.cameraRotationNode = nil
            spec.splitPlaneNode = nil
            spec.ringNode = nil
        end

        -- Tell the player to remove trees from their targeter.
        if self:getCarryingPlayer() ~ = nil then
            self:getCarryingPlayer().targeter:removeTargetType( HandToolChainsaw )
        end

        if spec.crosshair ~ = nil then
            spec.crosshair:delete()
            spec.crosshair = nil
        end
    end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function HandToolChainsaw:onDraw()
    -- Only draw the crosshair as long as the player is not cutting.
    local spec = self.spec_chainsaw
    if spec.crosshair ~ = nil and spec.currentCutState = = ChainsawCutState.IDLE then
        spec.crosshair:render()
    end
end

```

### onHeldEnd

**Description**

**Definition**

> onHeldEnd()

**Code**

```lua
function HandToolChainsaw:onHeldEnd()
    local spec = self.spec_chainsaw
    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer ~ = nil then
        if carryingPlayer.isOwner then
            carryingPlayer.targeter:removeTargetType( HandToolChainsaw )
        end

        if spec.playerWorkStylePreset ~ = nil then
            carryingPlayer:applyCustomWorkStyle( nil )
            carryingPlayer:setIsHoldingChainsaw( false )
        end
    end

    -- Stop whatever the player is doing.
    if spec.currentCutState = = ChainsawCutState.DELIMBING then
        self:stopDelimbing()
    elseif spec.currentCutState = = ChainsawCutState.CUTTING then
            self:stopCutting( false )
        end

        g_animationManager:stopAnimations(spec.chainsAnimation)
        spec.isPlayingChainAnimation = false

        if spec.ringNode ~ = nil then
            setVisibility(spec.ringNode, false )
        end

        spec.rollInput = 0
    end

```

### onHeldStart

**Description**

**Definition**

> onHeldStart()

**Code**

```lua
function HandToolChainsaw:onHeldStart()
    local carryingPlayer = self:getCarryingPlayer()

    if carryingPlayer ~ = nil then
        -- Ensure trees are targeted.
        if carryingPlayer.isOwner then
            local targeter = carryingPlayer.targeter
            targeter:addTargetType( HandToolChainsaw , HandToolChainsaw.TARGET_MASK, HandToolChainsaw.MINIMUM_CUT_DISTANCE, HandToolChainsaw.MAXIMUM_CUT_DISTANCE)
            targeter:addFilterToTargetType( HandToolChainsaw , function (hitNode, x, y, z)
                return hitNode ~ = nil and hitNode ~ = 0 and getHasClassId(hitNode, ClassIds.MESH_SPLIT_SHAPE)
            end )
        else
                setTranslation( self.graphicalNode, 0 , 0 , 0 )
                setRotation( self.graphicalNode, 0 , 0 , 0 )
            end

            local spec = self.spec_chainsaw
            if spec.playerWorkStylePreset ~ = nil then
                carryingPlayer:applyCustomWorkStyle(spec.playerWorkStylePreset)
                carryingPlayer:setIsHoldingChainsaw( true )
            end
        end
    end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | baseDirectory |

**Code**

```lua
function HandToolChainsaw:onLoad(xmlFile, baseDirectory)

    local spec = self.spec_chainsaw

    if HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_XZ = = nil then
        -- Accurate to 1cm with a 10m overlap.
        local mission = g_currentMission
        HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_XZ = NetworkUtil.createWorldPositionCompressionParams(mission.terrainSize + 10 , 0.5 * (mission.terrainSize + 10 ), 0.01 )
        HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_Y = NetworkUtil.createWorldPositionCompressionParams( 1500 , 0 , 0.01 )
    end

    spec.dirtyFlag = self:getNextDirtyFlag()

    spec.revText = g_i18n:getText( "action_revHandToolMotor" )
    spec.cutText = g_i18n:getText( "action_startCuttingChainsaw" )
    spec.rollText = g_i18n:getText( "action_rollChainsaw" )

    -- Start the chainsaw in idle mode.
    spec.currentCutState = ChainsawCutState.IDLE
    spec.currentCutStateSent = spec.currentCutState
    spec.isVerticalCut = true
    spec.removedAttachmentsSent = false

    spec.targetedTree = nil
    spec.cuttingTreeNode = nil

    spec.currentCutRoll = 0
    spec.rollInput = 0

    spec.isCutting = false

    spec.cutMinimumY, spec.cutMaximumY, spec.cutMinimumZ, spec.cutMaximumZ = nil , nil , nil , nil
    spec.cutStartPositionX, spec.cutStartPositionY, spec.cutStartPositionZ = 0 , 0 , 0
    spec.cutEndPositionX, spec.cutEndPositionY, spec.cutEndPositionZ = 0 , 0 , 0

    -- The curve used to animate the cutting animation, to appear as if the thickest part of the log takes longer to cut.
        spec.smoothingCurve = BezierCurve.new( 0.11 , 0.54 , 0.91 , 0.5 )

        spec.playerWorkStylePreset = xmlFile:getValue( "handTool.chainsaw.playerWorkStylePreset" )

        spec.maximumDelimbDiameter = xmlFile:getValue( "handTool.chainsaw#maximumDelimbDiameter" , 1 )
        spec.maximumCutDiameter = xmlFile:getValue( "handTool.chainsaw#maximumCutDiameter" , 1 )
        spec.cutTimePerSquareMeter = xmlFile:getValue( "handTool.chainsaw#cutTimePerSquareMeter" , 1 ) * 1000
        spec.currentCutTime = 0
        spec.currentTargetCutTime = 0
        spec.currentTargetStartupTime = 0
        spec.startupTime = 1000

        spec.cutNode = xmlFile:getValue( "handTool.chainsaw.cutNode#node" , nil , self.components, self.i3dMappings)
        if spec.cutNode = = nil then
            Logging.xmlWarning(xmlFile, "Chainsaw is missing cut node, root node will be used instead!" )
            spec.cutNode = self.rootNode
        end

        spec.handNodeCutting = xmlFile:getValue( "handTool.chainsaw.handNode#cutting" , nil , self.components, self.i3dMappings)
        spec.handNodeWalking = xmlFile:getValue( "handTool.chainsaw.handNode#walking" , nil , self.components, self.i3dMappings)

        -- Get the filename for the target ring.
            local ringI3DFilename = xmlFile:getValue( "handTool.chainsaw.ringSelector#filename" , nil )
            if ringI3DFilename ~ = nil then
                -- Begin loading the target ring.
                ringI3DFilename = Utils.getFilename(ringI3DFilename, self.baseDirectory)
                spec.ringSharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(ringI3DFilename, true , false , HandToolChainsaw.onRingLoadFinished, self , nil )
                spec.ringLoadingTask = self:createLoadingTask(spec)

                -- Get the ring's scale offset.
                spec.ringScaleOffset = xmlFile:getValue( "handTool.chainsaw.ringSelector#scaleOffset" , 0 )
            end

            -- Create the cut guide node.This interpolates between the start and end of a cut so that the chainsaw can position onto it.
            spec.cutGuideNode = createTransformGroup( "chainsawCutGuideNode" )
            link(getRootNode(), spec.cutGuideNode)

            -- Create the rotation node.This follows the rotation of the player's camera so that the ring indicator is always relative to it.
            spec.cameraRotationNode = createTransformGroup( "chainsawCameraRotationNode" )
            link(getRootNode(), spec.cameraRotationNode)

            -- Create the split plane node.This is attached to the rotation node and specifies the start of the split plane.
            spec.splitPlaneNode = createTransformGroup( "chainsawSplitPlaneNode" )
            link(spec.cameraRotationNode, spec.splitPlaneNode)
            setRotation(spec.splitPlaneNode, 0 , 0 , - math.pi * 0.5 )
            setTranslation(spec.splitPlaneNode, - 0.1 , spec.maximumCutDiameter / 2 , HandToolChainsaw.SPLIT_PLANE_OFFSET_Z)

            if self.isClient then
                spec.effectEndTime = 0
                spec.isPlayingEffects = false
                spec.effects = g_effectManager:loadEffect(xmlFile, "handTool.chainsaw.effects" , self.components, self , self.i3dMappings)
                g_effectManager:setEffectTypeInfo(spec.effects, FillType.WOOD)

                spec.isPlayingChainAnimation = false
                spec.chainsAnimation = g_animationManager:loadAnimations(xmlFile, "handTool.chainsaw.chain" , self.components, spec, self.i3dMappings)

                for i,animation in ipairs(spec.chainsAnimation) do
                    spec.startupTime = math.max(spec.startupTime, animation.turnOnFadeTime)
                end

                spec.cutSamples = g_soundManager:loadSamplesFromXML(xmlFile, "handTool.chainsaw.sounds" , "cut" , baseDirectory, self.components, 0 , AudioGroup.VEHICLE, self.i3dMappings, self )
            end

            spec.delimbEffectDuration = 100

            spec.lastDelimbPosX = 0
            spec.lastDelimbPosY = 0
            spec.lastDelimbPosZ = 0
            spec.lastDelimbNormalX = 1
            spec.lastDelimbNormalY = 0
            spec.lastDelimbNormalZ = 0
            spec.lastDelimbUpX = 0
            spec.lastDelimbUpY = 1
            spec.lastDelimbUpZ = 0

            if self.isClient then
                spec.crosshair = self:createCrosshairOverlay( "gui.crosshairDefault" )
            end

            -- force walk speed to 0.5 to match chainsaw walk animation
            self.walkMultiplier = 0.5
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
function HandToolChainsaw:onPostLoad(savegame)

    local spec = self.spec_chainsaw
    local motorizedSpec = self.spec_motorized

    -- Set the RPM stats based on the motor.
    self:setRPMGainPerSecond((motorizedSpec.maxRPM - motorizedSpec.minRPM) / (spec.startupTime * 0.001 ))
    self:setRPMLossPerSecond(((motorizedSpec.maxRPM - motorizedSpec.minRPM) / (spec.startupTime * 0.001 )) * 1.2 )
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
function HandToolChainsaw:onReadUpdateStream(streamId, timestamp, connection)
    local spec = self.spec_chainsaw
    local carryingPlayer = self:getCarryingPlayer()

    if streamReadBool(streamId) then
        local receivedState = ChainsawCutState.readStream(streamId)
        local isVerticalCut = true
        if receivedState = = ChainsawCutState.CUTTING then
            isVerticalCut = streamReadBool(streamId)
        end
        -- only change the cut state on other players
        if carryingPlayer = = nil or not carryingPlayer.isOwner then
            self:setCurrentCutState(receivedState, isVerticalCut)
        end

        if not connection:getIsServer() then
            if receivedState = = ChainsawCutState.DELIMBING then
                spec.lastDelimbPosX = NetworkUtil.readCompressedWorldPosition(streamId, HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_XZ)
                spec.lastDelimbPosY = NetworkUtil.readCompressedWorldPosition(streamId, HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_Y)
                spec.lastDelimbPosZ = NetworkUtil.readCompressedWorldPosition(streamId, HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_XZ)
                spec.lastDelimbNormalX = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , 12 )
                spec.lastDelimbNormalY = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , 12 )
                spec.lastDelimbNormalZ = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , 12 )
                spec.lastDelimbUpX = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , 12 )
                spec.lastDelimbUpY = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , 12 )
                spec.lastDelimbUpZ = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , 12 )
            end
        else
                local removedAttachment = streamReadBool(streamId)
                if removedAttachment then
                    if carryingPlayer ~ = nil and carryingPlayer.isOwner then
                        spec.effectEndTime = g_ time + spec.delimbEffectDuration
                    end
                end
            end
        end
    end

```

### onRegisterActionEvents

**Description**

**Definition**

> onRegisterActionEvents()

**Code**

```lua
function HandToolChainsaw:onRegisterActionEvents()
    local spec = self.spec_chainsaw

    if not self:getIsActiveForInput( true ) then
        return
    end

    local _, actionEventId = self:addActionEvent(InputAction.AXIS_ROTATE_HANDTOOL, self , HandToolChainsaw.onRollAction, false , false , true , true , nil )
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
    g_inputBinding:setActionEventText(actionEventId, string.format(spec.rollText, self.typeDesc))

    _, actionEventId = self:addActionEvent(InputAction.ACTIVATE_HANDTOOL, self , HandToolChainsaw.onCutAction, true , true , false , true , nil )
    spec.activateActionId = actionEventId
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
    g_inputBinding:setActionEventText(actionEventId, string.format(spec.revText, self.typeDesc))
end

```

### onRingLoadFinished

**Description**

**Definition**

> onRingLoadFinished()

**Arguments**

| any | ringNode     |
|-----|--------------|
| any | failedReason |

**Code**

```lua
function HandToolChainsaw:onRingLoadFinished(ringNode, failedReason)
    local spec = self.spec_chainsaw
    -- Finish the loading.
    self:finishLoadingTask(spec.ringLoadingTask)
    spec.ringLoadingTask = nil

    if ringNode = = nil or ringNode = = 0 then
        Logging.error( "Chainsaw could not load ring indicator i3d!" )
        return
    end

    spec.ringNode = getChildAt(ringNode, 0 )
    setVisibility(spec.ringNode, false )
    link(spec.cameraRotationNode, spec.ringNode)

    delete(ringNode)
end

```

### onRollAction

**Description**

**Definition**

> onRollAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputDelta |

**Code**

```lua
function HandToolChainsaw:onRollAction(_, inputDelta)
    local spec = self.spec_chainsaw
    spec.rollInput = spec.rollInput + inputDelta
end

```

### onUpdate

**Description**

**Definition**

> onUpdate()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HandToolChainsaw:onUpdate(dt)
    local spec = self.spec_chainsaw

    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer = = nil then
        return
    end

    -- If the carrying player is the owner, update the chainsaw as the owner player and do nothing more.
        if carryingPlayer.isOwner then
            if self:getIsHeld() then
                -- Get the tree being aimed at and update the split plane accordingly.
                spec.targetedTree = self:getCarryingPlayer().targeter.closestTargetsByKey[ HandToolChainsaw ]
                spec.possibleTreeNode = nil

                self:updateSplitPlane()

                -- Handle roll input, as long as the player is not currently cutting.
                if spec.currentCutState ~ = ChainsawCutState.CUTTING then
                    if spec.rollInput ~ = 0 then
                        spec.currentCutRoll = math.clamp(spec.currentCutRoll + ( HandToolChainsaw.ROTATION_SPEED * spec.rollInput * dt), - math.pi * 0.5 , math.pi * 0.5 )
                        spec.rollInput = 0
                    end

                    -- Update the graphical rotation.
                    if self.graphicalNode ~ = nil then
                        local upX, upY, upZ = localDirectionToLocal(spec.cameraRotationNode, getParent( self.graphicalNode), 0 , 1 , 0 )
                        local cameraNode = g_cameraManager:getActiveCamera()
                        local dirX, dirY, dirZ = localDirectionToLocal(cameraNode, getParent( self.graphicalNode), 0 , 0 , - 1 )
                        setDirection( self.graphicalNode, dirX, dirY, dirZ, upX, upY, upZ)
                    end
                end

                local isCutPossible = false
                if spec.currentCutState = = ChainsawCutState.IDLE or spec.currentCutState = = ChainsawCutState.CUTTING then
                    local treeNode = spec.cuttingTreeNode
                    if treeNode = = nil and spec.targetedTree ~ = nil then
                        treeNode = spec.targetedTree.node
                    end

                    if treeNode ~ = nil then
                        local cutX, _, cutZ = getWorldTranslation(spec.cameraRotationNode)
                        if not self:testIfCutValid(treeNode, cutX, cutZ, spec.cutMinimumY, spec.cutMaximumY, spec.cutMinimumZ, spec.cutMaximumZ) then
                            if spec.cuttingTreeNode ~ = nil then
                                self:stopCutting( false )
                            end
                        else
                                if spec.cuttingTreeNode = = nil then
                                    spec.possibleTreeNode = treeNode
                                end
                                isCutPossible = true
                            end
                        end
                    end

                    -- If the player is not actively using the chainsaw, update the ring selector.
                    if spec.currentCutState = = ChainsawCutState.IDLE then
                        if isCutPossible then
                            g_inputBinding:setActionEventText(spec.activateActionId, spec.cutText)
                        else
                                g_inputBinding:setActionEventText(spec.activateActionId, string.format(spec.revText, self.typeDesc))
                            end
                            g_inputBinding:setActionEventTextVisibility(spec.activateActionId, true )

                            self:updateRingSelector(spec.targetedTree, isCutPossible, spec.cutMinimumY, spec.cutMaximumY, spec.cutMinimumZ, spec.cutMaximumZ)

                        elseif spec.currentCutState = = ChainsawCutState.CUTTING then
                                g_inputBinding:setActionEventTextVisibility(spec.activateActionId, false )
                                self:updateCutting(dt)
                            end
                        end
                    end

                    if spec.currentCutState = = ChainsawCutState.DELIMBING then
                        if carryingPlayer.isOwner then
                            local x, y, z, normalX, normalY, normalZ, upX, upY, upZ = self:calculateCutPlane()

                            spec.lastDelimbPosX = x
                            spec.lastDelimbPosY = y
                            spec.lastDelimbPosZ = z
                            spec.lastDelimbNormalX = normalX
                            spec.lastDelimbNormalY = normalY
                            spec.lastDelimbNormalZ = normalZ
                            spec.lastDelimbUpX = upX
                            spec.lastDelimbUpY = upY
                            spec.lastDelimbUpZ = upZ

                            self:raiseDirtyFlags(spec.dirtyFlag)
                        end

                        if self.isServer then
                            local x = spec.lastDelimbPosX
                            local y = spec.lastDelimbPosY
                            local z = spec.lastDelimbPosZ
                            local normalX = spec.lastDelimbNormalX
                            local normalY = spec.lastDelimbNormalY
                            local normalZ = spec.lastDelimbNormalZ
                            local upX = spec.lastDelimbUpX
                            local upY = spec.lastDelimbUpY
                            local upZ = spec.lastDelimbUpZ

                            local planeWidth = spec.maximumDelimbDiameter
                            local planeDepth = spec.maximumDelimbDiameter + HandToolChainsaw.SPLIT_PLANE_OFFSET_Z
                            local removedAttachment = findAndRemoveSplitShapeAttachments(x, y, z, normalX, normalY, normalZ, upX, upY, upZ, 0.7 , planeWidth, planeDepth)

                            if spec.removedAttachmentsSent ~ = removedAttachment then
                                spec.removedAttachmentsSent = removedAttachment
                                self:raiseDirtyFlags(spec.dirtyFlag)
                            end

                            if removedAttachment then
                                spec.effectEndTime = g_ time + spec.delimbEffectDuration
                            end
                        end
                    end

                    if self.isClient then
                        if spec.effectEndTime > g_ time then
                            if not spec.isPlayingEffects then
                                g_effectManager:startEffects(spec.effects)
                                g_soundManager:playSamples(spec.cutSamples)
                                spec.isPlayingEffects = true
                            end
                        else
                                if spec.isPlayingEffects then
                                    g_effectManager:stopEffects(spec.effects)
                                    g_soundManager:stopSamples(spec.cutSamples)
                                    spec.isPlayingEffects = false
                                end
                            end

                            if self:getCurrentRPM() > self:getMinRPM() then
                                if not spec.isPlayingChainAnimation then
                                    g_animationManager:startAnimations(spec.chainsAnimation)
                                    spec.isPlayingChainAnimation = true
                                end
                            else
                                    if spec.isPlayingChainAnimation then
                                        g_animationManager:stopAnimations(spec.chainsAnimation)
                                        spec.isPlayingChainAnimation = false
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
function HandToolChainsaw:onWriteUpdateStream(streamId, connection, dirtyMask)
    local spec = self.spec_chainsaw

    if streamWriteBool(streamId, bit32.band(dirtyMask, spec.dirtyFlag) ~ = 0 ) then
        ChainsawCutState.writeStream(streamId, spec.currentCutStateSent)
        if spec.currentCutStateSent = = ChainsawCutState.CUTTING then
            streamWriteBool(streamId, spec.isVerticalCut)
        end

        if connection:getIsServer() then
            if spec.currentCutStateSent = = ChainsawCutState.DELIMBING then
                NetworkUtil.writeCompressedWorldPosition(streamId, spec.lastDelimbPosX, HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_XZ)
                NetworkUtil.writeCompressedWorldPosition(streamId, spec.lastDelimbPosY, HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_Y)
                NetworkUtil.writeCompressedWorldPosition(streamId, spec.lastDelimbPosZ, HandToolChainsaw.WORLD_POSITION_COMPRESSION_PARAMS_XZ)

                NetworkUtil.writeCompressedRange(streamId, spec.lastDelimbNormalX, - 1 , 1 , 12 )
                NetworkUtil.writeCompressedRange(streamId, spec.lastDelimbNormalY, - 1 , 1 , 12 )
                NetworkUtil.writeCompressedRange(streamId, spec.lastDelimbNormalZ, - 1 , 1 , 12 )
                NetworkUtil.writeCompressedRange(streamId, spec.lastDelimbUpX, - 1 , 1 , 12 )
                NetworkUtil.writeCompressedRange(streamId, spec.lastDelimbUpY, - 1 , 1 , 12 )
                NetworkUtil.writeCompressedRange(streamId, spec.lastDelimbUpZ, - 1 , 1 , 12 )
            end
        else
                streamWriteBool(streamId, spec.removedAttachmentsSent)
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
function HandToolChainsaw.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization( HandToolMotorized , specializations)
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolChainsaw.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onDelete" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onPostLoad" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onUpdate" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onDraw" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onWriteUpdateStream" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onReadUpdateStream" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onHeldStart" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onHeldEnd" , HandToolChainsaw )
    SpecializationUtil.registerEventListener(handToolType, "onRegisterActionEvents" , HandToolChainsaw )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | handToolType |
|-----|--------------|

**Code**

```lua
function HandToolChainsaw.registerFunctions(handToolType)
    SpecializationUtil.registerFunction(handToolType, "calculateCutPlane" , HandToolChainsaw.calculateCutPlane)
    SpecializationUtil.registerFunction(handToolType, "getChainSpeedFactor" , HandToolChainsaw.getChainSpeedFactor)
    SpecializationUtil.registerFunction(handToolType, "testIfTooLow" , HandToolChainsaw.testIfTooLow)
    SpecializationUtil.registerFunction(handToolType, "testIfCutAllowed" , HandToolChainsaw.testIfCutAllowed)
    SpecializationUtil.registerFunction(handToolType, "testIfCutValid" , HandToolChainsaw.testIfCutValid)
    SpecializationUtil.registerFunction(handToolType, "beginCutting" , HandToolChainsaw.beginCutting)
    SpecializationUtil.registerFunction(handToolType, "stopCutting" , HandToolChainsaw.stopCutting)
    SpecializationUtil.registerFunction(handToolType, "beginDelimbing" , HandToolChainsaw.beginDelimbing)
    SpecializationUtil.registerFunction(handToolType, "stopDelimbing" , HandToolChainsaw.stopDelimbing)
    SpecializationUtil.registerFunction(handToolType, "setCurrentCutState" , HandToolChainsaw.setCurrentCutState)
    SpecializationUtil.registerFunction(handToolType, "updateCutting" , HandToolChainsaw.updateCutting)
    SpecializationUtil.registerFunction(handToolType, "updateCuttingAnimation" , HandToolChainsaw.updateCuttingAnimation)
    SpecializationUtil.registerFunction(handToolType, "updateSplitPlane" , HandToolChainsaw.updateSplitPlane)
    SpecializationUtil.registerFunction(handToolType, "updateRingSelector" , HandToolChainsaw.updateRingSelector)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | xmlSchema |
|-----|-----------|

**Code**

```lua
function HandToolChainsaw.registerXMLPaths(xmlSchema)
    xmlSchema:setXMLSpecializationType( "HandToolChainsaw" )
    xmlSchema:register(XMLValueType.STRING, "handTool.chainsaw.playerWorkStylePreset" , "Name of the style preset" , nil , false )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.chainsaw#maximumCutDiameter" , "The maximum diameter in metres that can be cut" , 1 , false )
    xmlSchema:register(XMLValueType.FLOAT, "handTool.chainsaw#maximumDelimbDiameter" , "The maximum diameter range in metres that is used for delimb" , 1 , false )
        xmlSchema:register(XMLValueType.FLOAT, "handTool.chainsaw#cutTimePerSquareMeter" , "The time in seconds per square metre that the chainsaw takes to cut" , 1 , false )
        xmlSchema:register(XMLValueType.STRING, "handTool.chainsaw.ringSelector#filename" , "The path of the ring selector i3d file" , nil , true )
        xmlSchema:register(XMLValueType.FLOAT, "handTool.chainsaw.ringSelector#scaleOffset" , "The size in metres added onto the ring indicator's scale" , 0 , false )
        xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.chainsaw.cutNode#node" , "The name of the node used to position the chainsaw while cutting" , nil , false )
            xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.chainsaw.handNode#cutting" , "The name of the node used to position the chainsaw while cutting" , nil , false )
                xmlSchema:register(XMLValueType.NODE_INDEX, "handTool.chainsaw.handNode#walking" , "The name of the node used to position the chainsaw while walking" , nil , false )
                    AnimationManager.registerAnimationNodesXMLPaths(xmlSchema, "handTool.chainsaw.chain" )
                    EffectManager.registerEffectXMLPaths(xmlSchema, "handTool.chainsaw.effects" )
                    SoundManager.registerSampleXMLPaths(xmlSchema, "handTool.chainsaw.sounds" , "cut(?)" )
                end

```

### setCurrentCutState

**Description**

**Definition**

> setCurrentCutState()

**Arguments**

| any | cutState      |
|-----|---------------|
| any | isVerticalCut |

**Code**

```lua
function HandToolChainsaw:setCurrentCutState(cutState, isVerticalCut)
    local spec = self.spec_chainsaw

    spec.currentCutState = cutState
    spec.isVerticalCut = isVerticalCut

    local carryingPlayer = self:getCarryingPlayer()

    if self.isServer or(carryingPlayer ~ = nil and carryingPlayer.isOwner) then
        spec.currentCutStateSent = spec.currentCutState
        self:raiseDirtyFlags(spec.dirtyFlag)
    end

    if carryingPlayer ~ = nil then
        carryingPlayer:setChainsawState(cutState = = ChainsawCutState.CUTTING, isVerticalCut)
    end
end

```

### stopCutting

**Description**

**Definition**

> stopCutting()

**Arguments**

| any | sliceTree |
|-----|-----------|

**Code**

```lua
function HandToolChainsaw:stopCutting(sliceTree)
    local spec = self.spec_chainsaw
    local player = self:getCarryingPlayer()

    if player = = nil or not player.isOwner then
        return
    end

    -- Reset the tree that is being cut.
    local cuttingTreeNode = spec.cuttingTreeNode
    spec.cuttingTreeNode = nil

    self:setCurrentCutState(ChainsawCutState.IDLE, true )

    spec.currentCutTime = 0

    -- Reset the load and RPM.
    self:setCurrentLoad( 0 )
    self:setTargetRPMToIdle()

    if player.isOwner then
        -- Reset the graphical node.
        link( self.graphicalNodeParent, self.graphicalNode)
        setTranslation( self.graphicalNode, 0 , 0 , 0 )

        -- Unlock the player's input so they can move and look around.
        player.inputComponent:unlock()
    end

    spec.effectEndTime = 0

    -- If the tree should be sliced and there is a tree, slice it.
    if sliceTree and cuttingTreeNode ~ = nil then
        local x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth = self:calculateCutPlane()

        if self.isServer then
            ChainsawUtil.cutSplitShape(cuttingTreeNode, x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth, self:getOwnerFarmId())
        else
                g_client:getServerConnection():sendEvent( ChainsawCutEvent.new(cuttingTreeNode, x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth, self:getOwnerFarmId()))
            end
        end
    end

```

### stopDelimbing

**Description**

**Definition**

> stopDelimbing()

**Code**

```lua
function HandToolChainsaw:stopDelimbing()
    local spec = self.spec_chainsaw

    self:setCurrentCutState(ChainsawCutState.IDLE, true )

    spec.effectEndTime = 0

    -- Reset the load and RPM.
    self:setCurrentLoad( 0 )
    self:setTargetRPMToIdle()
end

```

### testIfCutAllowed

**Description**

**Definition**

> testIfCutAllowed()

**Arguments**

| any | treeNode |
|-----|----------|
| any | cutX     |
| any | cutZ     |

**Code**

```lua
function HandToolChainsaw:testIfCutAllowed(treeNode, cutX, cutZ)
    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer = = nil then
        return false
    end

    local mission = g_currentMission
    if not mission:getHasPlayerPermission( Farm.PERMISSION.CUT_TREES) then
        return false
    end

    if not g_splitShapeManager:getIsShapeCutAllowed(cutX, cutZ, treeNode, carryingPlayer:getFarmId()) then
        return false
    end

    return true
end

```

### testIfCutValid

**Description**

**Definition**

> testIfCutValid()

**Arguments**

| any | treeNode |
|-----|----------|
| any | cutX     |
| any | cutZ     |
| any | minY     |
| any | maxY     |
| any | minZ     |
| any | maxZ     |

**Code**

```lua
function HandToolChainsaw:testIfCutValid(treeNode, cutX, cutZ, minY, maxY, minZ, maxZ)
    local spec = self.spec_chainsaw

    if not self:testIfTooLow(treeNode, minY, maxY, minZ, maxZ) then
        return false
    end

    -- Test if the given cut is too big.
        if maxY - minY > = spec.maximumCutDiameter or maxZ - minZ > = spec.maximumCutDiameter then
            return false
        end

        return true
    end

```

### testIfTooLow

**Description**

> Using the given tree and given outputs from testSplitShape, determine if the split plane has any corners that are too
> close to the roots of the tree or the terrain.

**Definition**

> testIfTooLow(integer treeNode, float minY, float maxY, float minZ, float maxZ)

**Arguments**

| integer | treeNode |                                                                                             |
|---------|----------|---------------------------------------------------------------------------------------------|
| float   | minY     | The minimum y position of the split plane, relative to the split plane. (x in world space). |
| float   | maxY     | The maximum y position of the split plane, relative to the split plane. (x in world space). |
| float   | minZ     | The minimum z position of the split plane, relative to the split plane. (z in world space). |
| float   | maxZ     | The maximum z position of the split plane, relative to the split plane. (z in world space). |

**Return Values**

| float | isValid | True if all corners of the split plane are above the roots and terrain thresholds; otherwise false. |
|-------|---------|-----------------------------------------------------------------------------------------------------|

**Code**

```lua
function HandToolChainsaw:testIfTooLow(treeNode, minY, maxY, minZ, maxZ)

    -- Return false if there is no tree.
        if treeNode = = nil or treeNode = = 0 or not entityExists(treeNode) then
            return false
        end

        -- Return false if the bounds are nil.
            if minY = = nil or maxY = = nil or minZ = = nil or maxZ = = nil then
                return false
            end

            -- If the tree has already been felled and is just being cut up, return true as the height check only applies to rooted trees.
            if getRigidBodyType(treeNode) ~ = RigidBodyType.STATIC then
                return true
            end

            local spec = self.spec_chainsaw

            -- Calculate the position of each corner of the split plane bounds around the tree.
            local x1, y1, z1 = localToWorld(spec.splitPlaneNode, minY, 0 , minZ)
            local x2, y2, z2 = localToWorld(spec.splitPlaneNode, minY, 0 , maxZ)
            local x3, y3, z3 = localToWorld(spec.splitPlaneNode, maxY, 0 , minZ)
            local x4, y4, z4 = localToWorld(spec.splitPlaneNode, maxY, 0 , maxZ)

            -- Calculate the vertical distance of each corner from the roots of the tree.
            local _, distanceFromRootsY1 = worldToLocal(treeNode, x1, y1, z1)
            local _, distanceFromRootsY2 = worldToLocal(treeNode, x2, y2, z2)
            local _, distanceFromRootsY3 = worldToLocal(treeNode, x3, y3, z3)
            local _, distanceFromRootsY4 = worldToLocal(treeNode, x4, y4, z4)

            -- Calculate the validity of each root distance.
            local rootDistanceValid1 = distanceFromRootsY1 > = HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD
            local rootDistanceValid2 = distanceFromRootsY2 > = HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD
            local rootDistanceValid3 = distanceFromRootsY3 > = HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD
            local rootDistanceValid4 = distanceFromRootsY4 > = HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD

            -- Calculate the vertical distance of each corner from the terrain.
            local distanceFromTerrainY1 = y1 - getTerrainHeightAtWorldPos(g_terrainNode, x1, y1, z1)
            local distanceFromTerrainY2 = y2 - getTerrainHeightAtWorldPos(g_terrainNode, x2, y2, z2)
            local distanceFromTerrainY3 = y3 - getTerrainHeightAtWorldPos(g_terrainNode, x3, y3, z3)
            local distanceFromTerrainY4 = y4 - getTerrainHeightAtWorldPos(g_terrainNode, x4, y4, z4)

            -- Calculate the validity of each terrain distance.
            local terrainDistanceValid1 = distanceFromTerrainY1 > = HandToolChainsaw.GROUND_DISTANCE_THRESHOLD
            local terrainDistanceValid2 = distanceFromTerrainY2 > = HandToolChainsaw.GROUND_DISTANCE_THRESHOLD
            local terrainDistanceValid3 = distanceFromTerrainY3 > = HandToolChainsaw.GROUND_DISTANCE_THRESHOLD
            local terrainDistanceValid4 = distanceFromTerrainY4 > = HandToolChainsaw.GROUND_DISTANCE_THRESHOLD

            -- If debug info is enabled, draw it.
            if bit32.band( Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, Player.currentDebugFlag) ~ = 0 then

                -- Draw each corner around the split plane.
                drawDebugPoint(x1, y1, z1, rootDistanceValid1 and 0 or 1 , rootDistanceValid1 and 1 or 0 , 0 , 1 , true )
                drawDebugPoint(x2, y2, z2, rootDistanceValid2 and 0 or 1 , rootDistanceValid2 and 1 or 0 , 0 , 1 , true )
                drawDebugPoint(x3, y3, z3, rootDistanceValid3 and 0 or 1 , rootDistanceValid3 and 1 or 0 , 0 , 1 , true )
                drawDebugPoint(x4, y4, z4, rootDistanceValid4 and 0 or 1 , rootDistanceValid4 and 1 or 0 , 0 , 1 , true )

                -- Draw lines going from each corner to the root height.
                drawDebugLine(x1, y1, z1, rootDistanceValid1 and 0 or 1 , rootDistanceValid1 and 1 or 0 , 0 , x1, y1 - (distanceFromRootsY1 + HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD), z1, 1 , 0 , 0 , true )
                drawDebugLine(x2, y2, z2, rootDistanceValid2 and 0 or 1 , rootDistanceValid2 and 1 or 0 , 0 , x2, y2 - (distanceFromRootsY2 + HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD), z2, 1 , 0 , 0 , true )
                drawDebugLine(x3, y3, z3, rootDistanceValid3 and 0 or 1 , rootDistanceValid3 and 1 or 0 , 0 , x3, y3 - (distanceFromRootsY3 + HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD), z3, 1 , 0 , 0 , true )
                drawDebugLine(x4, y4, z4, rootDistanceValid4 and 0 or 1 , rootDistanceValid4 and 1 or 0 , 0 , x4, y4 - (distanceFromRootsY4 + HandToolChainsaw.ROOTS_HEIGHT_THRESHOLD), z4, 1 , 0 , 0 , true )

                -- Draw lines going from each corner to the terrain height.
                drawDebugLine(x1, y1, z1, terrainDistanceValid1 and 0 or 1 , terrainDistanceValid1 and 1 or 0 , 0 , x1, y1 - (distanceFromTerrainY1 + HandToolChainsaw.GROUND_DISTANCE_THRESHOLD), z1, 1 , 0 , 0 , true )
                drawDebugLine(x2, y2, z2, terrainDistanceValid2 and 0 or 1 , terrainDistanceValid2 and 1 or 0 , 0 , x2, y2 - (distanceFromTerrainY2 + HandToolChainsaw.GROUND_DISTANCE_THRESHOLD), z2, 1 , 0 , 0 , true )
                drawDebugLine(x3, y3, z3, terrainDistanceValid3 and 0 or 1 , terrainDistanceValid3 and 1 or 0 , 0 , x3, y3 - (distanceFromTerrainY3 + HandToolChainsaw.GROUND_DISTANCE_THRESHOLD), z3, 1 , 0 , 0 , true )
                drawDebugLine(x4, y4, z4, terrainDistanceValid4 and 0 or 1 , terrainDistanceValid4 and 1 or 0 , 0 , x4, y4 - (distanceFromTerrainY4 + HandToolChainsaw.GROUND_DISTANCE_THRESHOLD), z4, 1 , 0 , 0 , true )
            end

            -- The cut is valid if every corner is far enough away from the roots and the terrain.
                return rootDistanceValid1 and rootDistanceValid2 and rootDistanceValid3 and rootDistanceValid4
                and terrainDistanceValid1 and terrainDistanceValid2 and terrainDistanceValid3 and terrainDistanceValid4
            end

```

### updateCutting

**Description**

**Definition**

> updateCutting()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HandToolChainsaw:updateCutting(dt)
    local spec = self.spec_chainsaw

    local cutPositionX, cutPositionY, cutPositionZ = getWorldTranslation(spec.cameraRotationNode)

    -- Handle getting the player's look position.On the server, this has to be assumed to be at the head, as the player has no targeter.
    local player = self:getCarryingPlayer()

    local playerTargeter = player.targeter
    local playerLookX, playerLookY, playerLookZ = playerTargeter.lastRayX, playerTargeter.lastRayY, playerTargeter.lastRayZ

    -- Update the cutting animation, RPM, and cut time.
    self:updateCuttingAnimation(dt)
    self:setTargetRPMToMax()
    spec.currentCutTime = spec.currentCutTime + dt

    -- Calculate the distance of the cut from the player.If it is too far, stop cutting.
    local cutDistanceFromPlayer = MathUtil.vector3Length(playerLookX - cutPositionX, playerLookY - cutPositionY, playerLookZ - cutPositionZ)
    if cutDistanceFromPlayer > = HandToolChainsaw.MAXIMUM_CUT_DISTANCE then
        self:stopCutting( false )
        return
    end

    -- If the cut time is past the target time, the cut is done, so stop cutting and slice the tree.
    if spec.currentCutTime > = spec.currentTargetCutTime then
        self:stopCutting( true )
    end
end

```

### updateCuttingAnimation

**Description**

**Definition**

> updateCuttingAnimation()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HandToolChainsaw:updateCuttingAnimation(dt)
    local spec = self.spec_chainsaw

    -- If the animation is still waiting for the chain to speed up, slowly move along the line which doesn't intersect the tree geometry.
        local cutCurrentPositionX, cutCurrentPositionY, cutCurrentPositionZ
        if spec.currentCutTime < = spec.currentTargetStartupTime then

            -- Calculate the linear progress of the startup time, moving towards the cut start at a fixed rate.
            local cutCurrentProgress = math.clamp(spec.currentCutTime / spec.currentTargetStartupTime, 0 , 1 )

            -- Set the position of the cut guide.
            cutCurrentPositionX, cutCurrentPositionY, cutCurrentPositionZ = MathUtil.vector3Lerp(spec.cutRevPositionX, spec.cutRevPositionY, spec.cutRevPositionZ,
            spec.cutStartPositionX, spec.cutStartPositionY, spec.cutStartPositionZ, cutCurrentProgress)

            -- There is no load on the chainsaw just yet, so set the load to 0.
            self:setCurrentLoad( 0 )

            -- Otherwise; if the animation is cutting through the tree, move along the main line.
            else
                    spec.effectEndTime = g_ time + 200

                    -- Get the linear progress of the cut along the line, then apply the smoothing curve to it.
                    local cutCurrentProgress = math.clamp((spec.currentCutTime - spec.currentTargetStartupTime) / (spec.currentTargetCutTime - spec.currentTargetStartupTime), 0 , 1 )
                    cutCurrentProgress = spec.smoothingCurve:solve(cutCurrentProgress)

                    -- Get the linear progress of the cut along the line of the previous frame, then apply the smoothing curve to it.
                    local cutLastProgress = math.clamp(((spec.currentCutTime - spec.currentTargetStartupTime) - dt) / (spec.currentTargetCutTime - spec.currentTargetStartupTime), 0 , 1 )
                    cutLastProgress = spec.smoothingCurve:solve(cutLastProgress)

                    -- Calculate the linear speed of the cut with no smoothing applied, and the speed with smoothing applied.
                    local linearSpeed = dt / (spec.currentTargetCutTime - spec.currentTargetStartupTime)
                    local currentCutSpeed = math.max(cutCurrentProgress - cutLastProgress, 0.00001 )

                    -- Calculate the current cut load.This is based on the smoothed speed of the cut compared to a linear cut.
                    self:setCurrentLoad( math.clamp(linearSpeed / currentCutSpeed, 0 , 1 ))

                    -- Set the position of the cut guide.
                    cutCurrentPositionX, cutCurrentPositionY, cutCurrentPositionZ = MathUtil.vector3Lerp(spec.cutStartPositionX, spec.cutStartPositionY, spec.cutStartPositionZ,
                    spec.cutEndPositionX, spec.cutEndPositionY, spec.cutEndPositionZ, cutCurrentProgress)
                end

                -- Position and orient the cut guide node.
                setWorldTranslation(spec.cutGuideNode, cutCurrentPositionX, cutCurrentPositionY, cutCurrentPositionZ)
                setWorldQuaternion(spec.cutGuideNode, getWorldQuaternion(spec.splitPlaneNode))
            end

```

### updateRingSelector

**Description**

**Definition**

> updateRingSelector()

**Arguments**

| any | targetedTree  |
|-----|---------------|
| any | isCutPossible |
| any | cutMinimumY   |
| any | cutMaximumY   |
| any | cutMinimumZ   |
| any | cutMaximumZ   |

**Code**

```lua
function HandToolChainsaw:updateRingSelector(targetedTree, isCutPossible, cutMinimumY, cutMaximumY, cutMinimumZ, cutMaximumZ)
    local spec = self.spec_chainsaw
    if spec.ringNode = = nil then
        return
    end

    -- If there is no tree being aimed at, hide the ring indicator and do nothing more.
        setVisibility(spec.ringNode, targetedTree ~ = nil )

        if targetedTree = = nil then
            return
        end

        -- Color the indicator ring based on the validity of the cut.
        if isCutPossible then
            setShaderParameter(spec.ringNode, "colorScale" , HandToolChainsaw.VALID_CUT_COLOR.r, HandToolChainsaw.VALID_CUT_COLOR.g, HandToolChainsaw.VALID_CUT_COLOR.b, 1 , false )
        else
                setShaderParameter(spec.ringNode, "colorScale" , HandToolChainsaw.INVALID_CUT_COLOR.r, HandToolChainsaw.INVALID_CUT_COLOR.g, HandToolChainsaw.INVALID_CUT_COLOR.b, 1 , false )
            end

            -- If no cut would be possible, do nothing more.
                if cutMinimumY = = nil then
                    return
                end

                -- Scale the ring indicator so that it covers the entire trunk/branch.
                local ringScale = math.max(cutMaximumZ - cutMinimumZ, cutMaximumY - cutMinimumY) + spec.ringScaleOffset
                setScale(spec.ringNode, 1 , ringScale, ringScale)

                -- Centre the ring indictor in the middle of the trunk/branch.
                local worldTreeCentreX, worldTreeCentreY, worldTreeCentreZ = localToWorld(spec.splitPlaneNode, (cutMinimumY + cutMaximumY) * 0.5 , 0 , (cutMinimumZ + cutMaximumZ) * 0.5 )
                local localTreeCentreX, localTreeCentreY, localTreeCentreZ = worldToLocal(getParent(spec.ringNode), worldTreeCentreX, worldTreeCentreY, worldTreeCentreZ)
                setTranslation(spec.ringNode, localTreeCentreX, localTreeCentreY, localTreeCentreZ)
            end

```

### updateSplitPlane

**Description**

**Definition**

> updateSplitPlane()

**Code**

```lua
function HandToolChainsaw:updateSplitPlane()
    local spec = self.spec_chainsaw

    if spec.currentCutState = = ChainsawCutState.DELIMBING then
        local x, y, z = localToWorld( self.graphicalNode, 0 , - spec.maximumDelimbDiameter * 0.5 , 0 )
        setWorldTranslation(spec.cameraRotationNode, x, y, z)

        local cameraNode = g_cameraManager:getActiveCamera()
        local upX, upY, upZ = localDirectionToWorld(cameraNode, 0 , 1 , 0 )
        local dirX, dirY, dirZ = localDirectionToWorld(cameraNode, 0 , 0 , - 1 )
        setDirection(spec.cameraRotationNode, dirX, dirY, dirZ, upX, upY, upZ)
    else
            local _, playerYaw = self:getCarryingPlayer().camera:getRotation()
            setWorldRotation(spec.cameraRotationNode, 0 , playerYaw, 0 )
        end

        rotateAboutLocalAxis(spec.cameraRotationNode, spec.currentCutRoll, 0 , 0 , 1 )

        spec.cutMinimumY, spec.cutMaximumY, spec.cutMinimumZ, spec.cutMaximumZ = nil , nil , nil , nil

        -- If the cutting data should be kept, test against the currently cut tree.
        if spec.currentCutState = = ChainsawCutState.CUTTING then
            -- If there is no tree being cut, do nothing more.
                if spec.cuttingTreeNode = = nil or not entityExists(spec.cuttingTreeNode) then
                    return
                end

                -- Calculate the plane.
                local x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth = self:calculateCutPlane()

                -- Test against the currently cut tree.
                spec.cutMinimumY, spec.cutMaximumY, spec.cutMinimumZ, spec.cutMaximumZ = testSplitShape(spec.cuttingTreeNode, x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth)

            elseif spec.currentCutState = = ChainsawCutState.IDLE then
                    -- If there is no tree being aimed at, do nothing more.
                        if spec.targetedTree = = nil or not entityExists(spec.targetedTree.node) then
                            return
                        end

                        -- Set the position of the rotation node to be at the ray hit position.
                        setWorldTranslation(spec.cameraRotationNode, spec.targetedTree.x, spec.targetedTree.y, spec.targetedTree.z)

                        -- Calculate the plane.
                        local x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth = self:calculateCutPlane()

                        -- Test against the currently targeted tree.
                        spec.cutMinimumY, spec.cutMaximumY, spec.cutMinimumZ, spec.cutMaximumZ = testSplitShape(spec.targetedTree.node, x, y, z, downX, downY, downZ, leftX, leftY, leftZ, planeWidth, planeDepth)
                    end
                end

```