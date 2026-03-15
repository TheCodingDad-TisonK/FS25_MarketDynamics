## HandToolHands

**Description**

> The hand tool specialisation for "no tool", which is still technically a tool that cannot be dropped or stored.

**Functions**

- [calculateItemMass](#calculateitemmass)
- [consoleCommandToggleSuperStrength](#consolecommandtogglesuperstrength)
- [createItemJoint](#createitemjoint)
- [dropHeldItem](#drophelditem)
- [findFootballCallback](#findfootballcallback)
- [getCanBeDropped](#getcanbedropped)
- [getCanPickUpNode](#getcanpickupnode)
- [getHasJoint](#gethasjoint)
- [getIsAwaitingJointCreation](#getisawaitingjointcreation)
- [getIsHoldingItem](#getisholdingitem)
- [getIsThrowingItem](#getisthrowingitem)
- [getKinematicNode](#getkinematicnode)
- [levelHeldItem](#levelhelditem)
- [onCarryingPlayerChanged](#oncarryingplayerchanged)
- [onDebugDraw](#ondebugdraw)
- [onDelete](#ondelete)
- [onDraw](#ondraw)
- [onHeldEnd](#onheldend)
- [onHeldItemJointBroken](#onhelditemjointbroken)
- [onHeldStart](#onheldstart)
- [onKinematicHelperLoaded](#onkinematichelperloaded)
- [onLevelAction](#onlevelaction)
- [onLoad](#onload)
- [onPickUpAction](#onpickupaction)
- [onPitchAction](#onpitchaction)
- [onReadUpdateStream](#onreadupdatestream)
- [onRegisterActionEvents](#onregisteractionevents)
- [onThrowAction](#onthrowaction)
- [onUpdate](#onupdate)
- [onWriteUpdateStream](#onwriteupdatestream)
- [onYawAction](#onyawaction)
- [orientRotationNodeToItem](#orientrotationnodetoitem)
- [pickupFailed](#pickupfailed)
- [pickUpTarget](#pickuptarget)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)
- [rotateHeldItem](#rotatehelditem)
- [shootBall](#shootball)
- [throwHeldItemWithForceScalar](#throwhelditemwithforcescalar)
- [updateKinematicNode](#updatekinematicnode)

### calculateItemMass

**Description**

**Definition**

> calculateItemMass()

**Arguments**

| any | itemNode |
|-----|----------|

**Code**

```lua
function HandToolHands.calculateItemMass(itemNode)

    -- Ensure the given node exists.
    if itemNode = = nil or not entityExists(itemNode) then
        return nil
    end

    -- If the node has an object associated with it, check to see if it can calculate its own mass.
        local mission = g_currentMission
        local object = mission:getNodeObject(itemNode)
        local mass
        if object ~ = nil and object.getTotalMass ~ = nil then
            mass = object:getTotalMass()
        end

        -- Return the object's mass; or the node's mass if it's nil.
            return mass or getMass(itemNode)
        end

```

### consoleCommandToggleSuperStrength

**Description**

**Definition**

> consoleCommandToggleSuperStrength()

**Code**

```lua
function HandToolHands:consoleCommandToggleSuperStrength()
    local spec = self.spec_hands
    spec.hasSuperStrength = not spec.hasSuperStrength
    local text = "Disabled super strength"

    if spec.hasSuperStrength then
        spec.currentMaximumMass = HandToolHands.SUPER_STRENGTH_PICKUP_MASS
        spec.pickupDistance = 10
        text = "Enabled super strength"
    else
            spec.currentMaximumMass = HandToolHands.MAXIMUM_PICKUP_MASS
            spec.pickupDistance = HandToolHands.PICKUP_DISTANCE
        end

        local carryingPlayer = self:getCarryingPlayer()
        if carryingPlayer = = nil or not carryingPlayer.isOwner then
            return text
        end

        -- Remove the target type from the player's targeter.
        carryingPlayer.targeter:removeTargetType( HandToolHands )
        carryingPlayer.targeter:addTargetType( HandToolHands , HandToolHands.TARGET_MASK, 0.5 , spec.pickupDistance)

        return text
    end

```

### createItemJoint

**Description**

> Creates a joint between the currently held item and the kinematic node.

**Definition**

> createItemJoint()

**Code**

```lua
function HandToolHands:createItemJoint()

    -- Reset the phyics index.
    local spec = self.spec_hands
    spec.pickupPhysicsIndex = nil

    if not self.isServer then
        --#debug Player.debugLog(self:getCarryingPlayer(), Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "createItemJoint can only be used on the server!")
        return
    end
    --#debug Player.debugLog(self:getCarryingPlayer(), Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "Creating item joint")

    -- Ensure an item is being held, and a joint creation is being awaited.
    if not self:getIsHoldingItem() then
        Logging.error( "Cannot create joint for held item when no item is being held!" )
            return
        end

        -- Create the joint between the kinematic node and target object.
        local joint = JointConstructor.new()
        joint:setActors(spec.kinematicNode, spec.heldItemNode)

        -- Get the centre of mass of the target, and set the position of the joint to it.
        local targetCentreX, targetCentreY, targetCentreZ = getCenterOfMass(spec.heldItemNode)
        local targetWorldX, targetWorldY, targetWorldZ = localToWorld(spec.heldItemNode, targetCentreX, targetCentreY, targetCentreZ)
        joint:setJointWorldPositions(targetWorldX, targetWorldY, targetWorldZ, targetWorldX, targetWorldY, targetWorldZ)

        -- Set the limits.
        joint:setTranslationLimit( 0 , true , 0 , 0 )
        joint:setTranslationLimit( 1 , true , 0 , 0 )
        joint:setTranslationLimit( 2 , true , 0 , 0 )
        joint:setRotationLimit( 0 , 0 , 0 )
        joint:setRotationLimit( 1 , 0 , 0 )
        joint:setRotationLimit( 2 , 0 , 0 )

        -- Set the axes and normals.
        local targetLeftX, targetLeftY, targetLeftZ = localDirectionToWorld(spec.heldItemNode, 1 , 0 , 0 )
        joint:setJointWorldAxes(targetLeftX, targetLeftY, targetLeftZ, targetLeftX, targetLeftY, targetLeftZ)

        local targetUpX, targetUpY, targetUpZ = localDirectionToWorld(spec.heldItemNode, 0 , 1 , 0 )
        joint:setJointWorldNormals(targetUpX, targetUpY, targetUpZ, targetUpX, targetUpY, targetUpZ)

        -- Disable collisions between the kinematic node and the item.
        joint:setEnableCollision( false )

        -- Position and orient the rotation node so that it matches the target item.
        self:orientRotationNodeToItem(spec.heldItemNode)

        -- set spring/damper ?!
        local dampingRatio = 1.0
        local mass = HandToolHands.calculateItemMass(spec.heldItemNode)

        local rotationLimitSpring = { }
        local rotationLimitDamper = { }
        for i = 1 , 3 do
            rotationLimitSpring[i] = mass * 60
            rotationLimitDamper[i] = dampingRatio * 2 * math.sqrt(mass * rotationLimitSpring[i])
        end
        joint:setRotationLimitSpring(rotationLimitSpring[ 1 ], rotationLimitDamper[ 1 ], rotationLimitSpring[ 2 ], rotationLimitDamper[ 2 ], rotationLimitSpring[ 3 ], rotationLimitDamper[ 3 ])

        local translationLimitSpring = { }
        local translationLimitDamper = { }
        for i = 1 , 3 do
            translationLimitSpring[i] = mass * 60
            translationLimitDamper[i] = dampingRatio * 2 * math.sqrt(mass * translationLimitSpring[i])
        end
        joint:setTranslationLimitSpring(translationLimitSpring[ 1 ], translationLimitDamper[ 1 ], translationLimitSpring[ 2 ], translationLimitDamper[ 2 ], translationLimitSpring[ 3 ], translationLimitDamper[ 3 ])

        if not spec.hasSuperStrength then
            local forceAcceleration = 4
            local forceLimit = forceAcceleration * mass * 40.0
            joint:setBreakable(forceLimit, forceLimit)
        end

        -- Create the joint.
        spec.heldItemJointId = joint:finalize()

        -- Listen for the joint being broken due to excess force.
            addJointBreakReport(spec.heldItemJointId, "onHeldItemJointBroken" , self )

            --#debug Player.debugLog(self:getCarryingPlayer(), Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "Attached to %s", getName(spec.heldItemNode))
        end

```

### dropHeldItem

**Description**

> Drops the currently held item.

**Definition**

> dropHeldItem(boolean? noEventSend)

**Arguments**

| boolean? | noEventSend |
|----------|-------------|

**Code**

```lua
function HandToolHands:dropHeldItem(noEventSend)

    if not self:getIsHoldingItem() then
        return
    end

    HandsThrowObjectEvent.sendEvent( self , 0 , 0 , 0 , 0 , noEventSend)
    self:onHeldItemJointBroken( nil , nil , true )
end

```

### findFootballCallback

**Description**

**Definition**

> findFootballCallback()

**Arguments**

| any | transformId |
|-----|-------------|

**Code**

```lua
function HandToolHands:findFootballCallback(transformId)
    if transformId ~ = 0 and getHasClassId(transformId, ClassIds.SHAPE) then
        local mission = g_currentMission
        local object = mission:getNodeObject(transformId)
        if object ~ = nil and object:isa( Football ) then
            local spec = self.spec_hands
            spec.football = object

            return false
        end
    end

    return true
end

```

### getCanBeDropped

**Description**

**Definition**

> getCanBeDropped()

**Arguments**

| any | superFunc |
|-----|-----------|

**Code**

```lua
function HandToolHands:getCanBeDropped(superFunc)
    return false
end

```

### getCanPickUpNode

**Description**

> Finds if these hands can pick up the given target object.

**Definition**

> getCanPickUpNode(entityId node)

**Arguments**

| entityId | node | The target from the player's targeter. |
|----------|------|----------------------------------------|

**Return Values**

| entityId | canPickUp | True if the hands can pick up the given target; otherwise false. |
|----------|-----------|------------------------------------------------------------------|

**Code**

```lua
function HandToolHands:getCanPickUpNode(node)

    -- If there is no target, return false.
    if node = = nil or node = = 0 or not entityExists(node) then
        return false
    end

    if self.isServer and getRigidBodyType(node) ~ = RigidBodyType.DYNAMIC then -- all dynamic objects are kinematic on clients, so only do this check on the server
        return false
    end

    -- If the hands are holding something, they cannot pick something else up, so return false.
        if self:getIsHoldingItem() then
            return false
        end

        -- If the node has no mass, or the object is too heavy for the player, return false.
            local spec = self.spec_hands
            local mass = HandToolHands.calculateItemMass(node)
            if self.isServer and(mass = = nil or mass > spec.currentMaximumMass) then
                return false
            end

            -- If the node has an object associated with it, check to ensure the object is valid.
            local mission = g_currentMission
            local object = mission:getNodeObject(node)
            if object ~ = nil then
                -- If the object is a mount object, return false.
                if object.dynamicMountObject ~ = nil or object.tensionMountObject ~ = nil then
                    return false
                end

                -- If the object specifically says that the player cannot pick it up, return false.
                if not spec.hasSuperStrength then
                    if object.getCanBePickedUp ~ = nil and not object:getCanBePickedUp( self:getCarryingPlayer()) then
                        return false
                    end
                end
            end

            -- Return true, as all previous checks have passed.
            return true
        end

```

### getHasJoint

**Description**

> Finds if the hands have a joint between the kinematic node and the held item.

**Definition**

> getHasJoint()

**Return Values**

| entityId | hasJoint | True if there is a joint between the kinematic node and the held item; otherwise false. |
|----------|----------|-----------------------------------------------------------------------------------------|

**Code**

```lua
function HandToolHands:getHasJoint()
    return self.spec_hands.heldItemJointId ~ = nil
end

```

### getIsAwaitingJointCreation

**Description**

> Finds if an item has been picked up, but not yet attached to the kinematic node.

**Definition**

> getIsAwaitingJointCreation()

**Return Values**

| entityId | isAwaitingJointCreation | True if the hands are awaiting a physics update before creating the joint. |
|----------|-------------------------|----------------------------------------------------------------------------|

**Code**

```lua
function HandToolHands:getIsAwaitingJointCreation()
    return self.spec_hands.pickupPhysicsIndex ~ = nil
end

```

### getIsHoldingItem

**Description**

> Finds if the hands are currently holding something. Note that this does not mean there is a joint.

**Definition**

> getIsHoldingItem()

**Return Values**

| entityId | isHoldingItem | True if the hands are holding something; otherwise false. |
|----------|---------------|-----------------------------------------------------------|

**Code**

```lua
function HandToolHands:getIsHoldingItem()
    return self.spec_hands.heldItemNode ~ = nil
end

```

### getIsThrowingItem

**Description**

> Finds if the player is currently charging up a throw.

**Definition**

> getIsThrowingItem()

**Return Values**

| entityId | isThrowing | True if the player is charging a throw; otherwise false. |
|----------|------------|----------------------------------------------------------|

**Code**

```lua
function HandToolHands:getIsThrowingItem()
    return self.spec_hands.currentThrowTime ~ = nil
end

```

### getKinematicNode

**Description**

> Gets the kinematic helper of the hands. This will be nil until it is loaded.

**Definition**

> getKinematicNode()

**Return Values**

| entityId | kinematicNode         | The kinematic node of the hands, or nil if it is not yet loaded. |
|----------|-----------------------|------------------------------------------------------------------|
| entityId | kinematicRotationNode | The rotation node of the hands, or nil if it is not yet loaded.  |

**Code**

```lua
function HandToolHands:getKinematicNode()
    return self.spec_hands.kinematicNode, self.spec_hands.kinematicRotationNode
end

```

### levelHeldItem

**Description**

> Levels the held item so that it is flat to the floor, preserving its yaw. Should only be uesd for square bales and
> pallets.

**Definition**

> levelHeldItem()

**Code**

```lua
function HandToolHands:levelHeldItem()

    -- If no item is being held, do nothing.
        if not self:getIsHoldingItem() then
            return
        end

        -- Get the direction of the held item relative to the kinematic node.
        local spec = self.spec_hands
        local kinematicNode, rotationNode = self:getKinematicNode()
        local itemDirectionX, _, itemDirectionZ = localDirectionToLocal(spec.heldItemNode, kinematicNode, 0 , 0 , 1 )

        -- Set the local yaw of the rotation node to preserve the held item's yaw.Zero out the pitch and roll.
        local preservedYaw = MathUtil.getYRotationFromDirection(itemDirectionX, itemDirectionZ)
        setRotation(rotationNode, 0 , preservedYaw, 0 )

        -- Set the joint frame for the joint, so that it updates.
            if self.isServer then
                setJointFrame(spec.heldItemJointId, 0 , rotationNode)
            end
        end

```

### onCarryingPlayerChanged

**Description**

**Definition**

> onCarryingPlayerChanged()

**Arguments**

| any | player     |
|-----|------------|
| any | lastPlayer |

**Code**

```lua
function HandToolHands:onCarryingPlayerChanged(player, lastPlayer)
    -- This function should only ever be called once, as the player's hands cannot be put down or picked up.
        -- Add the super strength command.
        if player ~ = nil and player.isOwner then
            addConsoleCommand( "gsPlayerSuperStrengthToggle" , "Toggles the super strength mode for the player" , "consoleCommandToggleSuperStrength" , self )
            elseif lastPlayer ~ = nil and lastPlayer.isOwner then
                    removeConsoleCommand( "gsPlayerSuperStrengthToggle" )
                end
            end

```

### onDebugDraw

**Description**

**Definition**

> onDebugDraw()

**Code**

```lua
function HandToolHands:onDebugDraw()

    local kinematicNode, rotationNode = self:getKinematicNode()
    if kinematicNode ~ = nil then
        DebugUtil.drawDebugNode(kinematicNode, "kinematic" )
        DebugUtil.drawDebugNode(rotationNode, "rotation" )
    end

    if self:getIsHoldingItem() then
        local heldItemNode = self:getHeldItem()
        DebugUtil.drawDebugNode(heldItemNode, "heldItem" )

        local heldItemPositionX, heldItemPositionY, heldItemPositionZ = getWorldTranslation(heldItemNode)
        local kinematicPositionX, kinematicPositionY, kinematicPositionZ = getWorldTranslation(kinematicNode)

        local distance = MathUtil.vector3Length(heldItemPositionX - kinematicPositionX, heldItemPositionY - kinematicPositionY, heldItemPositionZ - kinematicPositionZ)

        DebugLine.renderBetweenNodes(kinematicNode, heldItemNode, Color.PRESETS.WHITE, true , string.format( "%.3fm" , distance), 0.03 , Color.PRESETS.GREEN, Color.PRESETS.RED)
    end
end

```

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function HandToolHands:onDelete()
    local spec = self.spec_hands

    self:dropHeldItem( true )

    -- Release the shared i3d file for the kinematic node.
        if spec.kinematicSharedLoadRequestId ~ = nil then
            g_i3DManager:releaseSharedI3DFile(spec.kinematicSharedLoadRequestId)
            spec.kinematicSharedLoadRequestId = nil
        end

        if spec.kinematicNode ~ = nil then
            delete(spec.kinematicNode)
            spec.kinematicNode = nil
        end

        local player = self:getCarryingPlayer()
        if player ~ = nil and player.isOwner then
            removeConsoleCommand( "gsPlayerSuperStrengthToggle" )
        end

        if spec.crosshair ~ = nil then
            spec.crosshair:delete()
            spec.crosshair = nil
        end

        if spec.pickUpCrosshair ~ = nil then
            spec.pickUpCrosshair:delete()
            spec.pickUpCrosshair = nil
        end

        if spec.throwCrosshair ~ = nil then
            spec.throwCrosshair:delete()
            spec.throwCrosshair = nil
        end
    end

```

### onDraw

**Description**

**Definition**

> onDraw()

**Code**

```lua
function HandToolHands:onDraw()
    local spec = self.spec_hands

    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer ~ = nil and carryingPlayer.isOwner then
        if carryingPlayer.camera.isFirstPerson then
            local player = self:getCarryingPlayer()
            local target = player.targeter.closestTargetsByKey[ HandToolHands ]
            local node = target and target.node or nil
            if self:getIsThrowingItem() then
                -- Scale the throw crosshair based on how powerful the player's throw is.
                local throwForceScalar = math.clamp(spec.currentThrowTime / HandToolHands.MAXIMUM_THROW_TIME, 0 , 1 )
                spec.throwCrosshair:setScale(throwForceScalar, throwForceScalar)

                spec.throwCrosshair:render()
            elseif spec.heldItemNode ~ = nil or self:getCanPickUpNode(node) then
                    spec.pickUpCrosshair:render()
                else
                        spec.crosshair:render()
                    end
                end
            end
        end

```

### onHeldEnd

**Description**

**Definition**

> onHeldEnd()

**Code**

```lua
function HandToolHands:onHeldEnd()
    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer = = nil or not carryingPlayer.isOwner then
        return
    end

    -- Remove the target type from the player's targeter.
    carryingPlayer.targeter:removeTargetType( HandToolHands )

    -- Drop any held item.
    self:dropHeldItem()
end

```

### onHeldItemJointBroken

**Description**

> Fired when the item joint is broken, or from dropHeldItem, and handles removing the joint and state.

**Definition**

> onHeldItemJointBroken(entityId jointIndex, float breakingImpulse, boolean noEventSend)

**Arguments**

| entityId | jointIndex      |                                                 |
|----------|-----------------|-------------------------------------------------|
| float    | breakingImpulse |                                                 |
| boolean  | noEventSend     | If this is true, no network event will be sent. |

**Code**

```lua
function HandToolHands:onHeldItemJointBroken(jointIndex, breakingImpulse, noEventSend)

    local spec = self.spec_hands

    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer ~ = nil then

        --#debug if entityExists(spec.heldItemNode) then
            --#debug carryingPlayer:debugLog(Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "Detached from %s", getName(spec.heldItemNode))
            --#debug end

            if carryingPlayer.isOwner then
                -- Disable any actions that should only be available while an item is held.
                    g_inputBinding:setActionEventActive(spec.throwActionEventId, false )
                    g_inputBinding:setActionEventActive(spec.pitchActionEventId, false )
                    g_inputBinding:setActionEventActive(spec.yawActionEventId, false )
                    g_inputBinding:setActionEventActive(spec.levelActionEventId, false )

                    -- Disable the action and set its text to "pick up" again.
                    g_inputBinding:setActionEventActive(spec.pickUpActionEventId, false )
                    g_inputBinding:setActionEventText(spec.pickUpActionEventId, g_i18n:getText( "action_pickUpObject" ))
                end
            end

            -- Reset the collision mask of the node.
            if entityExists(spec.heldItemNode) and self:getIsHoldingItem() then
                -- Enable collision against cct
                local player = self:getCarryingPlayer()
                if player ~ = nil and player.capsuleController ~ = nil then
                    local cctIndex = player.capsuleController.capsuleId
                    if cctIndex ~ = nil then
                        setCCTPairCollision(cctIndex, spec.heldItemNode, true )
                    end
                end
            end

            -- Reset the held item state.
            local itemExists = entityExists(spec.heldItemNode)
            spec.heldItemNode = nil

            if not self.isServer then
                return
            end

            -- The server tells the clients about the broken joint by telling them that they threw the object.
            HandsThrowObjectEvent.sendEvent( self , 0 , 0 , 0 , 0 , noEventSend)

            -- Remove the joint and unset the id.
            if self:getHasJoint() then
                if itemExists then
                    removeJoint(spec.heldItemJointId)
                end
                spec.heldItemJointId = nil
                -- If there's no joint, and one is being awaited, cancel it.
            elseif self:getIsAwaitingJointCreation() then
                    spec.pickupPhysicsIndex = nil
                end
            end

```

### onHeldStart

**Description**

**Definition**

> onHeldStart()

**Code**

```lua
function HandToolHands:onHeldStart()
    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer = = nil or not carryingPlayer.isOwner then
        return
    end

    -- Ensure objects are targeted.
    local spec = self.spec_hands
    local targeter = self:getCarryingPlayer().targeter
    targeter:addTargetType( HandToolHands , HandToolHands.TARGET_MASK, 0.5 , spec.pickupDistance)
end

```

### onKinematicHelperLoaded

**Description**

**Definition**

> onKinematicHelperLoaded()

**Arguments**

| any | kinematicNode |
|-----|---------------|
| any | failedReason  |

**Code**

```lua
function HandToolHands:onKinematicHelperLoaded(kinematicNode, failedReason)
    local spec = self.spec_hands
    self:finishLoadingTask(spec.kinematicLoadingTask)
    spec.kinematicLoadingTask = nil

    -- Ensure the node loaded correctly.
    if kinematicNode = = nil or kinematicNode = = 0 then
        Logging.error( "Hands could not load kinematic helper i3d!" )
        return
    end

    spec.kinematicNode = getChildAt(kinematicNode, 0 )
    link(getRootNode(), spec.kinematicNode)
    addToPhysics(spec.kinematicNode)

    -- Create the rotation helper node.
    spec.kinematicRotationNode = createTransformGroup( "kinematicRotationHelper" )
    link(spec.kinematicNode, spec.kinematicRotationNode)

    delete(kinematicNode)
end

```

### onLevelAction

**Description**

**Definition**

> onLevelAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolHands:onLevelAction(_, inputValue)
    self:levelHeldItem()
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
function HandToolHands:onLoad(xmlFile, baseDirectory)

    local spec = self.spec_hands

    spec.hasSuperStrength = false

    -- The current maximum mass that the player can pick up.
    spec.currentMaximumMass = HandToolHands.MAXIMUM_PICKUP_MASS
    spec.pickupDistance = HandToolHands.PICKUP_DISTANCE

    -- The current amount of throw time charged up by the player.Is nil unless the player is charging a throw.
    spec.currentThrowTime = nil

    -- The action event ids.
    spec.pickUpActionEventId = nil
    spec.throwActionEventId = nil
    spec.pitchActionEventId = nil
    spec.yawActionEventId = nil

    -- The held item data.
    spec.heldItemJointId = nil
    spec.heldItemNode = nil

    -- The distance away from the camera that the object is held.This starts at the max distance, but is calculated whenever the player picks something up.
    spec.currentHoldDistance = HandToolHands.PICKUP_DISTANCE

    -- The kinematic nodes, used for attaching the item to the hands.
        spec.kinematicNode = nil
        spec.kinematicRotationNode = nil

        -- Workaround for the weird input system.Keeps track of the last update loop index where the throw button was held.If it does not match with the current update loop index, the item is thrown.
            spec.lastThrowUpdateIndex = nil

            -- The physics index of the pickup of an object.The joint is created once this physics frame has been simulated.
            spec.pickupPhysicsIndex = nil

            spec.dirtyFlag = self:getNextDirtyFlag()

            -- Begin loading the kinematic helper.
            spec.kinematicLoadingTask = self:createLoadingTask(spec)
            spec.kinematicSharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync( "dataS/character/shared/kinematicHelper.i3d" , true , false , HandToolHands.onKinematicHelperLoaded, self , nil )

            spec.lastShootTime = g_ time
            spec.canShoot = false
            spec.football = nil

            spec.actionPassText = g_i18n:getText( "action_passFootball" )
            spec.actionShootText = g_i18n:getText( "action_shootFootball" )
            spec.pickupText = g_i18n:getText( "action_pickUpObject" )
            spec.throwText = g_i18n:getText( "input_THROW_OBJECT" )

            if self.isClient then
                spec.crosshair = self:createCrosshairOverlay( "gui.crosshairDefault" , HandTool.DEFAULT_CROSSHAIR_SIZE_PIXELS * 0.5 )
                spec.crosshair:setColor( nil , nil , nil , 0.25 )
                spec.pickUpCrosshair = self:createCrosshairOverlay( "gui.grab" )
                spec.throwCrosshair = self:createCrosshairOverlay( "gui.crosshairThrow" )
            end
        end

```

### onPickUpAction

**Description**

**Definition**

> onPickUpAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolHands:onPickUpAction(_, inputValue)

    -- Only allow picking up for the owning player.
        local player = self:getCarryingPlayer()
        if not player.isOwner then
            return
        end

        local spec = self.spec_hands
        if spec.football ~ = nil then
            local camera = g_cameraManager:getActiveCamera()
            local dirX, _, dirZ = localDirectionToWorld(camera, 0 , 0 , - 1 )
            dirX, _, dirZ = MathUtil.vector3Normalize(dirX, 0 , dirZ)

            self:shootBall(spec.football, dirX, dirZ, 0 , HandToolHands.FOOTBALL_PASS_VELOCITY, Football.TYPE_PASS)
            return
        end

        -- If the player is currently holding an item, drop it.
        if self:getIsHoldingItem() then
            self:dropHeldItem()
            -- Otherwise; pick up the targeted item.
        else
                local target = player.targeter.closestTargetsByKey[ HandToolHands ]
                self:pickUpTarget(target)
            end
        end

```

### onPitchAction

**Description**

**Definition**

> onPitchAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputDelta |

**Code**

```lua
function HandToolHands:onPitchAction(_, inputDelta)

    -- The pitching should always be relative to the player, so no matter which way the held object is facing, it's tilted towards/away from the player.
    -- Otherwise; the item will be tilted relative to its own axis, which doesn't really make sense if they have no idea what part of the item is the "front".
        local kinematicNode, rotationNode = self:getKinematicNode()
        local directionX, directionY, directionZ = localDirectionToLocal(kinematicNode, rotationNode, 1 , 0 , 0 )

        self:rotateHeldItem(inputDelta, directionX, directionY, directionZ)
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
function HandToolHands:onReadUpdateStream(streamId, timestamp, connection)
    if not connection:getIsServer() then
        if streamReadBool(streamId) then
            local kinematicNode, kinematicRotationNode = self:getKinematicNode()

            local paramsXZ = g_currentMission.vehicleXZPosCompressionParams
            local paramsY = g_currentMission.vehicleYPosCompressionParams

            local kinematicNodePositionX = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)
            local kinematicNodePositionY = NetworkUtil.readCompressedWorldPosition(streamId, paramsY)
            local kinematicNodePositionZ = NetworkUtil.readCompressedWorldPosition(streamId, paramsXZ)

            local kinematicNodeDirectionX = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , HandToolHands.KINEMATIC_NODE_DIRECTION_NUM_BITS)
            local kinematicNodeDirectionZ = NetworkUtil.readCompressedRange(streamId, - 1 , 1 , HandToolHands.KINEMATIC_NODE_DIRECTION_NUM_BITS)

            local kinematicNodePitch = NetworkUtil.readCompressedAngle(streamId)
            local kinematicNodeYaw = NetworkUtil.readCompressedAngle(streamId)
            local kinematicNodeRoll = NetworkUtil.readCompressedAngle(streamId)

            setWorldTranslation(kinematicNode, kinematicNodePositionX, kinematicNodePositionY, kinematicNodePositionZ)
            setWorldDirection(kinematicNode, kinematicNodeDirectionX, 0 , kinematicNodeDirectionZ, 0 , 1 , 0 )
            setWorldRotation(kinematicRotationNode, kinematicNodePitch, kinematicNodeYaw, kinematicNodeRoll)

            if self:getHasJoint() then
                local spec = self.spec_hands
                setJointFrame(spec.heldItemJointId, 0 , kinematicRotationNode)
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
function HandToolHands:onRegisterActionEvents()
    if not self:getIsActiveForInput( true ) then
        return
    end

    local spec = self.spec_hands

    -- The pick up/drop action.
    local _, actionEventId = self:addActionEvent(InputAction.ACTIVATE_HANDTOOL, self , HandToolHands.onPickUpAction, true , false , false , false , nil )
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
    g_inputBinding:setActionEventText(actionEventId, spec.pickupText)
    spec.pickUpActionEventId = actionEventId

    -- The throw action.
    _, actionEventId = self:addActionEvent(InputAction.ACTIVATE_HANDTOOL_SECONDARY, self , HandToolHands.onThrowAction, false , true , true , false , nil )
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_VERY_HIGH)
    g_inputBinding:setActionEventText(actionEventId, spec.throwText)
    spec.throwActionEventId = actionEventId

    -- The pitch/yaw actions.
    _, actionEventId = self:addActionEvent(InputAction.ROTATE_OBJECT_UP_DOWN, self , HandToolHands.onPitchAction, false , false , true , false , nil )
    g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_rotateObjectVertically" ))
    spec.pitchActionEventId = actionEventId

    _, actionEventId = self:addActionEvent(InputAction.ROTATE_OBJECT_LEFT_RIGHT, self , HandToolHands.onYawAction, false , false , true , false , nil )
    g_inputBinding:setActionEventText(actionEventId, g_i18n:getText( "action_rotateObjectHorizontally" ))
    spec.yawActionEventId = actionEventId

    -- The level action for pallets and square bales.
        _, actionEventId = self:addActionEvent(InputAction.HANDS_LEVEL_ITEM, self , HandToolHands.onLevelAction, true , false , false , false , nil )
        spec.levelActionEventId = actionEventId
    end

```

### onThrowAction

**Description**

**Definition**

> onThrowAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HandToolHands:onThrowAction(_, inputValue)

    -- Do nothing if the player is not the owner.
        local player = self:getCarryingPlayer()
        if not player.isOwner then
            return
        end

        local spec = self.spec_hands
        if spec.football ~ = nil then
            local camera = g_cameraManager:getActiveCamera()
            local dirX, _, dirZ = localDirectionToWorld(camera, 0 , 0 , - 1 )
            dirX, _, dirZ = MathUtil.vector3Normalize(dirX, 0 , dirZ)

            self:shootBall(spec.football, dirX, dirZ, 30 , HandToolHands.FOOTBALL_SHOT_VELOCITY, Football.TYPE_SHOT)
        end

        -- Do nothing if no item is held.
            if not self:getIsHoldingItem() then
                return
            end

            -- Keep track of the update loop index that this input was held down for.
                spec.lastThrowUpdateIndex = g_updateLoopIndex

                -- If there is no throw time, set it to 0.Otherwise; increment it by the dt.
                if spec.currentThrowTime = = nil then
                    spec.currentThrowTime = 0
                else
                        spec.currentThrowTime + = g_currentDt
                    end
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
function HandToolHands:onUpdate(dt)
    local carryingPlayer = self:getCarryingPlayer()
    if carryingPlayer = = nil then
        return
    end

    if not self:getIsHeld() then
        return
    end

    -- If a joint creation is being awaited, and the physics frame has been simulated, create the joint.This naturally only triggers on the server.
    local spec = self.spec_hands
    if self:getIsAwaitingJointCreation() and getIsPhysicsUpdateIndexSimulated(spec.pickupPhysicsIndex) then
        self:createItemJoint()
    end

    -- Update the kinematic node.
    self:updateKinematicNode()

    if not carryingPlayer.isOwner then
        return
    end

    spec.canShoot = (spec.lastShootTime + HandToolHands.FOOTBALL_SHOOT_THRESHOLD) < g_ time
    spec.football = nil

    if self:getIsHoldingItem() then
        if self.isServer and spec.heldItemNode ~ = nil and not entityExists(spec.heldItemNode) then
            self:dropHeldItem()
        end
    end

    -- If the player is not holding anything, check to see if they're looking at something that can be picked up.
        if not self:getIsHoldingItem() then

            -- Determine if the moused over object can be picked up.
                local targetNode = carryingPlayer.targeter:getClosestTargetedNodeFromType( HandToolHands )
                local canPickUpTarget = self:getCanPickUpNode(targetNode)

                if not canPickUpTarget then
                    local mission = g_currentMission
                    local object = mission:getNodeObject(targetNode)
                    if object ~ = nil and object:isa( Football ) then
                        spec.football = object
                    end

                    if spec.football = = nil then
                        local x, y, z = getWorldTranslation(carryingPlayer.graphicsComponent.graphicsRootNode)
                        overlapSphere(x, y, z, HandToolHands.FOOTBALL_DETECTION_RADIUS, "findFootballCallback" , self , CollisionFlag.DYNAMIC_OBJECT, true , false , false )
                    end
                end

                local canShoot = (spec.football ~ = nil and spec.canShoot)

                -- Activate or deactivate the input binding based on if the target object can be picked up or not.
                    g_inputBinding:setActionEventActive(spec.pickUpActionEventId, canPickUpTarget or canShoot)
                    g_inputBinding:setActionEventActive(spec.throwActionEventId, spec.heldItemNode or canShoot)

                    if canShoot then
                        g_inputBinding:setActionEventText(spec.pickUpActionEventId, spec.actionPassText)
                        g_inputBinding:setActionEventText(spec.throwActionEventId, spec.actionShootText)
                    else
                            g_inputBinding:setActionEventText(spec.pickUpActionEventId, spec.pickupText)
                            g_inputBinding:setActionEventText(spec.throwActionEventId, spec.throwText)
                        end

                        -- Otherwise; if the player is holding something and has finished throwing it, throw it.
                        elseif self:getIsThrowingItem() and spec.lastThrowUpdateIndex ~ = nil and spec.lastThrowUpdateIndex ~ = g_updateLoopIndex then
                                local throwForceScalar = math.clamp(spec.currentThrowTime / HandToolHands.MAXIMUM_THROW_TIME, 0 , 1 )
                                self:throwHeldItemWithForceScalar(throwForceScalar)
                            end

                            if spec.football ~ = nil then
                                if spec.canShoot then
                                    local footballNode = spec.football.nodeId
                                    local px, py, pz = getWorldTranslation(carryingPlayer.graphicsComponent.graphicsRootNode)
                                    local bx, by, bz = getWorldTranslation(footballNode)
                                    local distance = MathUtil.vector3Length(px - bx, py - by, pz - bz)

                                    if distance > HandToolHands.FOOTBALL_DRIBBLE_MIN_DISTANCE and distance < HandToolHands.FOOTBALL_DRIBBLE_MAX_DISTANCE then
                                        local camera = g_cameraManager:getActiveCamera()
                                        local dirX, _, dirZ = localDirectionToWorld(camera, 0 , 0 , - 1 )
                                        dirX, _, dirZ = MathUtil.vector3Normalize(dirX, 0 , dirZ)

                                        self:shootBall(spec.football, dirX, dirZ, 0 , HandToolHands.FOOTBALL_DRIBBLE_VELOCITY, Football.TYPE_DRIBBLE)
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
function HandToolHands:onWriteUpdateStream(streamId, connection, dirtyMask)
    if connection:getIsServer() then
        local spec = self.spec_hands
        if streamWriteBool(streamId, bit32.btest(dirtyMask, spec.dirtyFlag)) then
            local kinematicNode, kinematicRotationNode = self:getKinematicNode()

            local kinematicNodePitch, kinematicNodeYaw, kinematicNodeRoll = getWorldRotation(kinematicRotationNode)
            local kinematicNodePositionX, kinematicNodePositionY, kinematicNodePositionZ = getWorldTranslation(kinematicNode)
            local kinematicNodeDirectionX, _, kinematicNodeDirectionZ = localDirectionToWorld(kinematicNode, 0 , 0 , 1 )
            kinematicNodeDirectionX, kinematicNodeDirectionZ = MathUtil.vector2Normalize(kinematicNodeDirectionX, kinematicNodeDirectionZ)

            local paramsXZ = g_currentMission.vehicleXZPosCompressionParams
            local paramsY = g_currentMission.vehicleYPosCompressionParams

            NetworkUtil.writeCompressedWorldPosition(streamId, kinematicNodePositionX, paramsXZ)
            NetworkUtil.writeCompressedWorldPosition(streamId, kinematicNodePositionY, paramsY)
            NetworkUtil.writeCompressedWorldPosition(streamId, kinematicNodePositionZ, paramsXZ)

            NetworkUtil.writeCompressedRange(streamId, kinematicNodeDirectionX, - 1 , 1 , HandToolHands.KINEMATIC_NODE_DIRECTION_NUM_BITS)
            NetworkUtil.writeCompressedRange(streamId, kinematicNodeDirectionZ, - 1 , 1 , HandToolHands.KINEMATIC_NODE_DIRECTION_NUM_BITS)

            NetworkUtil.writeCompressedAngle(streamId, kinematicNodePitch)
            NetworkUtil.writeCompressedAngle(streamId, kinematicNodeYaw)
            NetworkUtil.writeCompressedAngle(streamId, kinematicNodeRoll)
        end
    end
end

```

### onYawAction

**Description**

**Definition**

> onYawAction()

**Arguments**

| any | _          |
|-----|------------|
| any | inputDelta |

**Code**

```lua
function HandToolHands:onYawAction(_, inputDelta)

    -- The yaw should always be absolute, so that it spins as if on a pole.
        local kinematicNode, rotationNode = self:getKinematicNode()
        local directionX, directionY, directionZ = localDirectionToLocal(kinematicNode, rotationNode, 0 , 1 , 0 )

        self:rotateHeldItem(inputDelta, directionX, directionY, directionZ)
    end

```

### orientRotationNodeToItem

**Description**

**Definition**

> orientRotationNodeToItem()

**Arguments**

| any | targetItemNode |
|-----|----------------|

**Code**

```lua
function HandToolHands:orientRotationNodeToItem(targetItemNode)

    local targetCentreX, targetCentreY, targetCentreZ = getCenterOfMass(targetItemNode)
    local targetWorldX, targetWorldY, targetWorldZ = localToWorld(targetItemNode, targetCentreX, targetCentreY, targetCentreZ)

    -- Position and orient the rotation node so that it matches the target item.
    local _, kinematicRotationNode = self:getKinematicNode()
    setWorldTranslation(kinematicRotationNode, targetWorldX, targetWorldY, targetWorldZ)
    setWorldRotation(kinematicRotationNode, getWorldRotation(targetItemNode))
end

```

### pickupFailed

**Description**

**Definition**

> pickupFailed()

**Code**

```lua
function HandToolHands:pickupFailed()
    Logging.devInfo( "HandToolHands.pickupFailed" )

    local spec = self.spec_hands
    --#debug if spec.heldItemNode ~ = nil and entityExists(spec.heldItemNode) then
        --#debug Player.debugLog(self:getCarryingPlayer(), Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "Detached from %s", getName(spec.heldItemNode))
        --#debug end

        local carryingPlayer = self:getCarryingPlayer()
        if carryingPlayer ~ = nil and carryingPlayer.isOwner then

            -- Disable any actions that should only be available while an item is held.
                g_inputBinding:setActionEventActive(spec.throwActionEventId, false )
                g_inputBinding:setActionEventActive(spec.pitchActionEventId, false )
                g_inputBinding:setActionEventActive(spec.yawActionEventId, false )
                g_inputBinding:setActionEventActive(spec.levelActionEventId, false )

                -- Disable the action and set its text to "pick up" again.
                g_inputBinding:setActionEventActive(spec.pickUpActionEventId, false )
                g_inputBinding:setActionEventText(spec.pickUpActionEventId, g_i18n:getText( "action_pickUpObject" ))
            end

            if spec.heldItemNode ~ = nil and entityExists(spec.heldItemNode) and self:getIsHoldingItem() then
                -- Enable collision against cct
                local player = self:getCarryingPlayer()
                if player ~ = nil and player.capsuleController ~ = nil then
                    local cctIndex = player.capsuleController.capsuleId
                    if cctIndex ~ = nil then
                        setCCTPairCollision(cctIndex, spec.heldItemNode, true )
                    end
                end
            end

            -- Reset the held item state.
            spec.heldItemNode = nil
        end

```

### pickUpTarget

**Description**

> Picks up the given target.

**Definition**

> pickUpTarget(table target, boolean noEventSend)

**Arguments**

| table   | target      | The target from the player's targeter.          |
|---------|-------------|-------------------------------------------------|
| boolean | noEventSend | If this is true, no network event will be sent. |

**Return Values**

| boolean | success | True if the target was picked up; otherwise false. |
|---------|---------|----------------------------------------------------|

**Code**

```lua
function HandToolHands:pickUpTarget(target, noEventSend)

    -- If the item cannot be picked up, do nothing.
        if target = = nil or not self:getCanPickUpNode(target.node) then
            --#debug Player.debugLog(self:getCarryingPlayer(), Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "Failed to pick up object")
            return false
        end

        HandsPickUpObjectEvent.sendEvent( self , target, noEventSend)

        local mission = g_currentMission
        local heldObject = mission:getNodeObject(target.node)
        local heldItemNode = (heldObject ~ = nil and heldObject.rootNode ~ = nil ) and heldObject.rootNode or target.node

        -- Set the held item to the given item, and save its collision mask.
        local spec = self.spec_hands
        spec.heldItemNode = heldItemNode

        -- Disable collision against cct
        local player = self:getCarryingPlayer()
        if player ~ = nil and player.capsuleController ~ = nil then
            local cctIndex = player.capsuleController.capsuleId
            if cctIndex ~ = nil then
                setCCTPairCollision(cctIndex, spec.heldItemNode, false )
            end
        end

        -- Set the current hold distance to the distance from the player's camera to the hit position, then update the kinematic helper to ensure it's 100% in the correct position.
        spec.currentHoldDistance = target.distance
        self:updateKinematicNode()

        -- Enable the actions that are available while holding an item.
            g_inputBinding:setActionEventActive(spec.throwActionEventId, true )
            g_inputBinding:setActionEventActive(spec.pitchActionEventId, true )
            g_inputBinding:setActionEventActive(spec.yawActionEventId, true )

            -- Activate the throw option.
            g_inputBinding:setActionEventActive(spec.pickUpActionEventId, true )
            g_inputBinding:setActionEventText(spec.pickUpActionEventId, g_i18n:getText( "action_dropObject" ))

            -- Get the object that represents the node.If the node is a square bale or a pallet, enable the level action.
            if heldObject ~ = nil and(heldObject.isPallet or(heldObject:isa( Bale ) and not heldObject.isRoundbale)) then
                g_inputBinding:setActionEventActive(spec.levelActionEventId, true )

                -- Work out the object name for the levelling action, defaulting to "object".
                    local objectName = "object"
                    if heldObject.isPallet then
                        objectName = g_i18n:getText( "typeDesc_pallet" )
                    elseif heldObject:isa( Bale ) then
                            objectName = g_i18n:getText( "fillType_squareBale" )
                        end
                        g_inputBinding:setActionEventText(spec.levelActionEventId, string.namedFormat(g_i18n:getText( "action_levelObject" ), "objectName" , objectName))
                    end

                    if self.isServer then
                        -- The kinematic node is a physics object, so moving it around has a 2 frame delay.If the joint were to be created now, it would fling off once the physics system has finished moving the kinematic node.
                        -- Due to this, the current physics index is saved, and the joint is created when it has been simulated.
                        spec.pickupPhysicsIndex = getPhysicsUpdateIndex()
                        --#debug Player.debugLog(self:getCarryingPlayer(), Player.DEBUG_DISPLAY_FLAG.HANDTOOLS, "Awaiting physics index %d for attachment to %s", spec.pickupPhysicsIndex, getName(spec.heldItemNode))
                        else
                                self:orientRotationNodeToItem(heldItemNode)
                            end

                            return true
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
function HandToolHands.prerequisitesPresent(specializations)
    return true
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
function HandToolHands.registerEventListeners(handToolType)
    SpecializationUtil.registerEventListener(handToolType, "onLoad" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onDelete" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onUpdate" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onDraw" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onWriteUpdateStream" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onReadUpdateStream" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onRegisterActionEvents" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onCarryingPlayerChanged" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onHeldStart" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onHeldEnd" , HandToolHands )
    SpecializationUtil.registerEventListener(handToolType, "onDebugDraw" , HandToolHands )
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
function HandToolHands.registerFunctions(handToolType)
    SpecializationUtil.registerFunction(handToolType, "updateKinematicNode" , HandToolHands.updateKinematicNode)

    SpecializationUtil.registerFunction(handToolType, "getKinematicNode" , HandToolHands.getKinematicNode)
    SpecializationUtil.registerFunction(handToolType, "getIsHoldingItem" , HandToolHands.getIsHoldingItem)
    SpecializationUtil.registerFunction(handToolType, "getIsThrowingItem" , HandToolHands.getIsThrowingItem)
    SpecializationUtil.registerFunction(handToolType, "getIsAwaitingJointCreation" , HandToolHands.getIsAwaitingJointCreation)
    SpecializationUtil.registerFunction(handToolType, "getHasJoint" , HandToolHands.getHasJoint)
    SpecializationUtil.registerFunction(handToolType, "getHeldItem" , HandToolHands.getHeldItem)
    SpecializationUtil.registerFunction(handToolType, "getCanPickUpNode" , HandToolHands.getCanPickUpNode)

    SpecializationUtil.registerFunction(handToolType, "orientRotationNodeToItem" , HandToolHands.orientRotationNodeToItem)
    SpecializationUtil.registerFunction(handToolType, "createItemJoint" , HandToolHands.createItemJoint)

    SpecializationUtil.registerFunction(handToolType, "pickUpTarget" , HandToolHands.pickUpTarget)
    SpecializationUtil.registerFunction(handToolType, "pickupFailed" , HandToolHands.pickupFailed)
    SpecializationUtil.registerFunction(handToolType, "dropHeldItem" , HandToolHands.dropHeldItem)
    SpecializationUtil.registerFunction(handToolType, "throwHeldItemWithForceScalar" , HandToolHands.throwHeldItemWithForceScalar)
    SpecializationUtil.registerFunction(handToolType, "throwHeldItemWithForceVector" , HandToolHands.throwHeldItemWithForceVector)

    SpecializationUtil.registerFunction(handToolType, "rotateHeldItem" , HandToolHands.rotateHeldItem)
    SpecializationUtil.registerFunction(handToolType, "levelHeldItem" , HandToolHands.levelHeldItem)

    SpecializationUtil.registerFunction(handToolType, "onHeldItemJointBroken" , HandToolHands.onHeldItemJointBroken)

    SpecializationUtil.registerFunction(handToolType, "findFootballCallback" , HandToolHands.findFootballCallback)
    SpecializationUtil.registerFunction(handToolType, "shootBall" , HandToolHands.shootBall)

    SpecializationUtil.registerFunction(handToolType, "consoleCommandToggleSuperStrength" , HandToolHands.consoleCommandToggleSuperStrength)
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
function HandToolHands.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanBeDropped" , HandToolHands.getCanBeDropped)
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
function HandToolHands.registerXMLPaths(xmlSchema)
    xmlSchema:setXMLSpecializationType( "HandToolHands" )
    xmlSchema:setXMLSpecializationType()
end

```

### rotateHeldItem

**Description**

> Rotates the rotation node locally about the given direction axis.

**Definition**

> rotateHeldItem(float inputDelta, float directionX, float directionY, float directionZ)

**Arguments**

| float | inputDelta | The rotation about the axis to make, in radians. |
|-------|------------|--------------------------------------------------|
| float | directionX | The x direction of the axis.                     |
| float | directionY | The y direction of the axis.                     |
| float | directionZ | The z direction of the axis.                     |

**Code**

```lua
function HandToolHands:rotateHeldItem(inputDelta, directionX, directionY, directionZ)

    -- Calculate the rotation to make.
    local rotation = ( math.pi * 0.5 ) * (g_physicsDt * 0.001 ) * inputDelta

    -- Rotate the rotation node about the given local axis.
    local spec = self.spec_hands
    local _, rotationNode = self:getKinematicNode()
    rotateAboutLocalAxis(rotationNode, rotation, directionX, directionY, directionZ)

    -- Set the joint frame for the joint, so that it updates.
        if self.isServer and spec.heldItemJointId ~ = nil then
            setJointFrame(spec.heldItemJointId, 0 , rotationNode)
        end
    end

```

### shootBall

**Description**

**Definition**

> shootBall()

**Arguments**

| any | football |
|-----|----------|
| any | dirX     |
| any | dirZ     |
| any | angleDeg |
| any | velocity |
| any | shotType |

**Code**

```lua
function HandToolHands:shootBall(football, dirX, dirZ, angleDeg, velocity, shotType)
    local spec = self.spec_hands
    spec.lastShootTime = g_ time
    spec.canShoot = false
    football:shoot(dirX, dirZ, angleDeg, velocity, shotType)
end

```

### throwHeldItemWithForceScalar

**Description**

> Throws the currently held item with the given force scalar (from 0 to 1, where 1 is a fully powered throw) in the
> direction of the player's camera.

**Definition**

> throwHeldItemWithForceScalar(float throwForceScalar, boolean noEventSend)

**Arguments**

| float   | throwForceScalar | The throw power from 0 to 1, where 1 is a fully powered throw. |
|---------|------------------|----------------------------------------------------------------|
| boolean | noEventSend      | If this is true, no network event will be sent.                |

**Code**

```lua
function HandToolHands:throwHeldItemWithForceScalar(throwForceScalar, noEventSend)

    -- Do nothing if no item is being held.
        if not self:getIsHoldingItem() then
            return
        end

        local player = self:getCarryingPlayer()
        if player = = nil or player.targeter = = nil then
            Logging.error( "HandToolHands:throwHeldItemWithForceScalar can only be used on the owning player, as it uses their camera direction!" )
            return
        end

        local _, _, _, cameraDirectionX, cameraDirectionY, cameraDirectionZ = player.targeter:getLastLookRay()
        self:throwHeldItemWithForceVector(cameraDirectionX, cameraDirectionY, cameraDirectionZ, throwForceScalar, noEventSend)
    end

```

### updateKinematicNode

**Description**

> Updates the position of the kinematic node so that it is always in front of the player.

**Definition**

> updateKinematicNode()

**Code**

```lua
function HandToolHands:updateKinematicNode()

    -- If there is no kinematic node yet, do nothing.
        local spec = self.spec_hands
        if spec.kinematicNode = = nil then
            return
        end

        -- If the hands are not active, do nothing.
            if not self:getIsHeld() then
                return
            end

            -- If the player is not the owner, do nothing.
                if not self:getCarryingPlayer().isOwner then
                    return
                end

                -- Get the player's last targeter ray.If it is nil, do nothing.
                    local x, y, z, dx, dy, dz = self:getCarryingPlayer().targeter:getLastLookRay()
                    if x = = nil then
                        return
                    end

                    self:raiseDirtyFlags(spec.dirtyFlag)

                    -- Calculate the position of the kinematic helper along the ray.
                    x, y, z = x + (dx * spec.currentHoldDistance), y + (dy * spec.currentHoldDistance), z + (dz * spec.currentHoldDistance)

                    -- Set the position and rotation of the kinematic node.Keep the kinematic node level to the world.
                    setWorldTranslation(spec.kinematicNode, x, y, z)
                    dx, dz = MathUtil.vector2Normalize(dx, dz)
                    setWorldDirection(spec.kinematicNode, dx, 0 , dz, 0 , 1 , 0 )
                end

```