## PlayerOnFootStateMachine

**Description**

> A sub-state of the PlayerStateMachine, also being a state machine itself. This is used when the player is walking
> around on foot.

**Parent**

> [StateMachine](?version=script&category=80&class=841)

**Functions**

- [new](#new)
- [onStateEntered](#onstateentered)
- [onStateExited](#onstateexited)
- [updateAsCurrent](#updateascurrent)

### new

**Description**

> Creates the on-foot state machine for the given player.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player who owns the state machine. |
|--------|--------|----------------------------------------|

**Return Values**

| Player | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function PlayerOnFootStateMachine.new(player)

    -- Create the instance.
    local self = StateMachine.new( PlayerOnFootStateMachine _mt)

    -- The player.
    self.player = player

    self.stateMachine = player.stateMachine

    -- Create the states.
    self.states =
    {
    idle = PlayerStateIdle.new(player, self ),
    walking = PlayerStateWalk.new(player, self ),
    swimming = PlayerStateSwim.new(player, self ),
    falling = PlayerStateFall.new(player, self ),
    jumping = PlayerStateJump.new(player, self ),
    crouching = PlayerStateCrouch.new(player, self )
    }

    -- Create the state transitions now that the list of states is ready.
    self:initialiseStateTransitions()

    -- Start on the idle state, and set it as the default.
    self.currentState = self.states.idle
    self.defaultState = self.states.idle

    -- Used to determine if this state allows the player to use hand tools.
        self.canUseHandTools = true

        self.player:addStateEvent( PlayerOnFootStateMachine.onLeaveVehicle, self , "onLeaveVehicle" )
        self.player:addStateEvent( PlayerOnFootStateMachine.onLeaveVehicle, self , "onLeaveVehicleAsPassenger" )
        self.player:addStateEvent( PlayerOnFootStateMachine.onLeaveVehicle, self , "onLeaveRollercoaster" )

        -- Return the created instance.
        return self
    end

```

### onStateEntered

**Description**

> Fired when this state machine becomes the current state of the PlayerStateMachine. This usually happens once the
> player leaves a vehicle.

**Definition**

> onStateEntered(BaseStateMachineState previousState)

**Arguments**

| BaseStateMachineState | previousState | The previous state the machine was in before entering this one. |
|-----------------------|---------------|-----------------------------------------------------------------|

**Code**

```lua
function PlayerOnFootStateMachine:onStateEntered(previousState)
    self.player.networkComponent:reset()
    self.player.graphicsState:setDefault()
    self.player.graphicsComponent:applyState( self.player.graphicsState)
    self.player.mover:setSpeed( 0 )
    self.player.mover:resetHorizontalVelocity()

    --#debug self.player:debugLog(Player.DEBUG_DISPLAY_FLAG.STATE, "Entered on foot state")

    -- Show the player on the server, which will sync with the clients.
    if self.player.isServer then
        self.player:show()
    end

    if self.player.isOwner then
        local oldContext = g_inputBinding:getContextName()
        if oldContext ~ = Vehicle.INPUT_CONTEXT_NAME then
            g_inputBinding:replaceContextInStack( Vehicle.INPUT_CONTEXT_NAME, PlayerInputComponent.INPUT_CONTEXT_NAME)
        end

        if oldContext = = InputBinding.ROOT_CONTEXT_NAME or oldContext = = Vehicle.INPUT_CONTEXT_NAME or oldContext = = PlaceableRollercoaster.INPUT_CONTEXT_ROLLERCOASTER then
            -- Make the input current.
            self.player.inputComponent:makeCurrent()
        end

        -- Activate the activatable objects.
        local mission = g_currentMission
        mission.activatableObjectsSystem:activate( PlayerInputComponent.INPUT_CONTEXT_NAME)
        mission.hud:setIsControllingPlayer( true )

        -- When the state is entered, it can mean a few things; like the player exiting from a vehicle.
        -- In any case, there is no way to be certain of what state the player should have, so immediately determine it.
        -- Only the owner can determine their own state, as non-owners simply follow what the server says.
        self:determineState()
    end
end

```

### onStateExited

**Description**

> Fired when this state is exited.

**Definition**

> onStateExited(BaseStateMachineState nextState)

**Arguments**

| BaseStateMachineState | nextState | The state the machine will be in after exiting this one. |
|-----------------------|-----------|----------------------------------------------------------|

**Code**

```lua
function PlayerOnFootStateMachine:onStateExited(nextState)
    self.player.networkComponent:reset()
    self.player.graphicsState:setDefault()
    self.player.graphicsComponent:applyState( self.player.graphicsState)
    self.player.graphicsComponent:setModelPosition( self.player:getGraphicalPosition())

    if self.player.isOwner then
        self.player.mover:setSpeed( 0 )
        self.player.mover:resetHorizontalVelocity()

        self.player:setCurrentHandTool( nil , true )

        -- Deactivate the activatable objects.
        local mission = g_currentMission
        mission.activatableObjectsSystem:deactivate( PlayerInputComponent.INPUT_CONTEXT_NAME)
    end
end

```

### updateAsCurrent

**Description**

> The update function for when this state machine is the current state in the main player state machine. Updates the
> on-foot movement and on-foot state.

**Definition**

> updateAsCurrent(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerOnFootStateMachine:updateAsCurrent(dt)
    local mission = g_currentMission

    --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateInput")
    -- Update the player's input component.
    if self.player.inputComponent ~ = nil then
        self.player.inputComponent:update(dt)
    end
    --#profile RemoteProfiler.zoneEnd()

    --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateTargeter")
    -- Update the player's targeter.
    if self.player.targeter ~ = nil then
        self.player.targeter:update(dt)
    end
    --#profile RemoteProfiler.zoneEnd()

    --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-preUpdateNetworkComponent")
    -- Pre-update the network component, if one exists.
        if self.player.networkComponent ~ = nil then
            self.player.networkComponent:preUpdate(dt)
        end
        --#profile RemoteProfiler.zoneEnd()

        --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateCamera")
        -- Update the camera's rotation.This should be done before any movement, as the movement direction relies on the direction of the camera.
        if self.player.camera ~ = nil then
            self.player.camera:updateRotation(dt)
        end
        --#profile RemoteProfiler.zoneEnd()

        --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateCCT")
        -- Update the CCT so the height can be correct for the state.
            self.player.capsuleController:update(dt)
            --#profile RemoteProfiler.zoneEnd()

            --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-update")
            -- Call the base update function so that the states can be updated.
                self:update(dt)
                --#profile RemoteProfiler.zoneEnd()

                --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-move")
                -- If the current state has a horizontal movement function, use it.
                    if self.player.inputComponent ~ = nil and self.currentState.calculateDesiredHorizontalVelocity then

                        -- Calculate the movement from the current state using the current inputs.
                        local movementX, movementZ = self.currentState:calculateDesiredHorizontalVelocity( self.player.inputComponent.worldDirectionX, self.player.inputComponent.worldDirectionZ)

                        -- Tell the mover to move horizontally.
                        self.player.mover:moveHorizontally(movementX, movementZ)
                    end
                    --#profile RemoteProfiler.zoneEnd()

                    --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateMover")
                    -- Update the mover.
                    self.player.mover:update(dt)
                    --#profile RemoteProfiler.zoneEnd()

                    --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-setCameraOffset")
                    -- If the current state has a camera offset, apply it to the camera.
                    if self.player.camera ~ = nil then
                        self.player.camera:setOffsetY( self.currentState.cameraOffsetY)
                    end
                    --#profile RemoteProfiler.zoneEnd()

                    --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updatePositionInterpolator")
                    -- Update the positional interpolator, if one exists.
                        if self.player.positionalInterpolator ~ = nil then
                            self.player.positionalInterpolator:update(dt)
                        end
                        --#profile RemoteProfiler.zoneEnd()

                        --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateAnimatior")
                        -- Update the graphics component.
                        if self.player.isOwner then
                            self.player.graphicsState:updateLocal( self.player)
                        else
                                self.player.graphicsState:updateRemote( self.player)
                            end
                            self.player.graphicsComponent:applyState( self.player.graphicsState)
                            self.player.graphicsComponent:setModelYaw( self.player:getGraphicalYaw())
                            self.player.graphicsComponent:setModelPosition( self.player:getGraphicalPosition())
                            --#profile RemoteProfiler.zoneEnd()

                            --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateGraphics")
                            self.player.graphicsComponent:update(dt)
                            --#profile RemoteProfiler.zoneEnd()

                            --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateCameraPosition")
                            -- Update the camera's position.
                            if self.player.camera ~ = nil then
                                self.player.camera:updatePosition(dt)
                            end

                            if self.player.isOwner then
                                local x, y, z = self.player:getPosition()
                                local dirX, dirZ = self.player:getCurrentFacingDirection()
                                local activatableObjectsSystem = mission.activatableObjectsSystem
                                activatableObjectsSystem:setPosition(x, y, z)
                                activatableObjectsSystem:setDirection(dirX, 0 , dirZ)
                            end
                            --#profile RemoteProfiler.zoneEnd()

                            --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-resetInput")
                            -- Reset the state of the input component.
                            if self.player.inputComponent ~ = nil then
                                self.player.inputComponent:resetState()
                            end
                            --#profile RemoteProfiler.zoneEnd()

                            --#profile RemoteProfiler.zoneBeginN("PlayerOnFootStateMachine-updateNetwork")
                            -- Update the network component, if one exists.
                                if self.player.networkComponent ~ = nil then
                                    self.player.networkComponent:update(dt)
                                end
                                --#profile RemoteProfiler.zoneEnd()
                            end

```