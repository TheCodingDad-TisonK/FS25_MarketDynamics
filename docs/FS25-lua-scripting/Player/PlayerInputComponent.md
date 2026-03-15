## PlayerInputComponent

**Description**

> The input component used to control a character.

**Functions**

- [addPauseListeners](#addpauselisteners)
- [calculateNormalisedMovementDirection](#calculatenormalisedmovementdirection)
- [calculateNormalisedWorldMovementDirection](#calculatenormalisedworldmovementdirection)
- [debugDraw](#debugdraw)
- [lock](#lock)
- [new](#new)
- [onGamePaused](#ongamepaused)
- [onInputChangeAltitude](#oninputchangealtitude)
- [onInputCrouch](#oninputcrouch)
- [onInputEnter](#oninputenter)
- [onInputJump](#oninputjump)
- [onInputLookLeftRight](#oninputlookleftright)
- [onInputLookUpDown](#oninputlookupdown)
- [onInputMoveForward](#oninputmoveforward)
- [onInputMoveSide](#oninputmoveside)
- [onInputRun](#oninputrun)
- [onInputSwitchCamera](#oninputswitchcamera)
- [registerActionEvents](#registeractionevents)
- [resetState](#resetstate)
- [touchEventLookLeftRight](#toucheventlookleftright)
- [touchEventLookUpDown](#toucheventlookupdown)
- [touchEventZoomInOut](#toucheventzoominout)
- [unlock](#unlock)
- [unregisterActionEvents](#unregisteractionevents)

### addPauseListeners

**Description**

> Sets up specific bindings when the player enters a mission.

**Definition**

> addPauseListeners(boolean isControlling)

**Arguments**

| boolean | isControlling | Is true if the player is controlled; otherwise false. |
|---------|---------------|-------------------------------------------------------|

**Code**

```lua
function PlayerInputComponent:addPauseListeners(isControlling)

    -- If the player is not controlled, do nothing.
        if not isControlling then
            return
        end

        -- If there is a mission, listen for the player pausing.
            local mission = g_currentMission
            if mission ~ = nil then
                mission:addPauseListeners( self , self.onGamePaused)
            end
        end

```

### calculateNormalisedMovementDirection

**Description**

> Calculates and returns the normalised movement direction vector in object-space. (2D only, no height).

**Definition**

> calculateNormalisedMovementDirection()

**Return Values**

| boolean | x | The normalised x. |
|---------|---|-------------------|
| boolean | y | The normalised y. |

**Code**

```lua
function PlayerInputComponent:calculateNormalisedMovementDirection()

    -- If there are movement inputs, normalise and return the direction.
    if self.moveRight ~ = 0 or self.moveForward ~ = 0 then
        return MathUtil.vector2Normalize( self.moveRight, self.moveForward)
        -- Otherwise; return 0, 0, as there is no valid direction.
    else
            return 0 , 0
        end
    end

```

### calculateNormalisedWorldMovementDirection

**Description**

> Calculates and returns the normalised movement direction vector in world-space. (2D only, no height).

**Definition**

> calculateNormalisedWorldMovementDirection()

**Return Values**

| boolean | x | The normalised x. |
|---------|---|-------------------|
| boolean | y | The normalised y. |

**Code**

```lua
function PlayerInputComponent:calculateNormalisedWorldMovementDirection()

    --#debug Assert.isTrue(self.player.isOwner, "Non-controlled player cannot calculate their world movement direction, as they have no camera!")

    -- Calculate the normalised local direction first.
    local localDirectionX, localDirectionZ = self:calculateNormalisedMovementDirection()

    -- If there is some form of direction, return it translated to the world.
    if (localDirectionX ~ = 0 or localDirectionZ ~ = 0 ) and self.player.camera.yawNode ~ = nil then
        local worldDirectionX, _, worldDirectionZ = localDirectionToWorld( self.player.camera.yawNode, - localDirectionX, 0 , localDirectionZ)
        return worldDirectionX, worldDirectionZ
        -- Otherwise; return 0, 0 as there is no valid direction.
    else
            return 0 , 0
        end
    end

```

### debugDraw

**Description**

> Displays the debug information.

**Definition**

> debugDraw(float x, float y, float textSize)

**Arguments**

| float | x        | The x position on the screen to begin drawing the values. |
|-------|----------|-----------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values. |
| float | textSize | The height of the text.                                   |

**Return Values**

| float | y | The y position on the screen after the entire debug info was drawn. |
|-------|---|---------------------------------------------------------------------|

**Code**

```lua
function PlayerInputComponent:debugDraw(x, y, textSize)

    -- Render the header.
    y = DebugUtil.renderTextLine(x, y, textSize * 1.5 , "Input" , nil , true )

    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Jump power: %.2f" , self.lastJumpPower))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Crouch: %.2f" , self.lastCrouchValue))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Has movement: %s" , self.lastHasMovementInputs))

    y = self:debugDrawMovementGraphs(x, y, textSize)

    return y
end

```

### lock

**Description**

> Locks the input.

**Definition**

> lock()

**Code**

```lua
function PlayerInputComponent:lock()
    self.lockedCrouchValue = self.crouchValue
    self.locked = true
end

```

### new

**Description**

> Creates an input component for the given player.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player to gather input for. |
|--------|--------|---------------------------------|

**Return Values**

| Player | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function PlayerInputComponent.new(player)

    -- Create the instance.
    local self = setmetatable( { } , PlayerInputComponent _mt)

    -- The player who owns this control component.
    self.player = player

    -- This will be true if the input should be ignored, for example when the player is paused.
        self.locked = false

        -- The action id for entering vehicles.
            self.enterActionId = nil

            self.radioActionId = nil

            self.toggleFlightActionId = nil
            self.upDownFlightActionId = nil

            -- The inputs for the x and z, not normalised.
                self.moveRight = 0.0
                self.moveForward = 0.0

                self.lastMoveRight = 0.0
                self.lastMoveForward = 0.0

                -- The inputs for the x and z in world space, based on the camera's yaw axis node.
                    self.worldDirectionX = 0.0
                    self.worldDirectionZ = 0.0

                    self.lastWorldDirectionX = 0.0
                    self.lastWorldDirectionZ = 0.0

                    -- The forward/right movement input length, giving the amount of walk power depending on how far the analogue stick is pushed.
                    self.walkAxis = 0.0

                    -- The analogue amount of run power.
                    self.runAxis = 0.0

                    -- The up/down input, where 1 is up and -1 is down.
                    self.flightAxis = 0.0

                    -- The jump input, may be analogue for differing jump heights.
                        self.jumpPower = 0.0

                        -- The crouch input.
                        self.crouchValue = 0.0
                        self.lockedCrouchValue = 0.0

                        self.lastWalkAxis = 0.0
                        self.lastRunAxis = 0.0
                        self.lastFlightAxis = 0.0
                        self.lastJumpPower = 0.0
                        self.lastCrouchValue = 0.0

                        -- The rotation inputs for the camera.
                            self.cameraRotationX = 0.0
                            self.cameraRotationY = 0.0

                            -- This will be true if the player is trying to move in a direction.
                                self.hasMovementInputs = false
                                self.lastHasMovementInputs = false

                                local flashlightName = g_i18n:getText( "storeItem_flashlight" )
                                self.turnOnFlashlightText = string.format(g_i18n:getText( "action_turnOnOBJECT" ), flashlightName)
                                self.turnOffFlashlightText = string.format(g_i18n:getText( "action_turnOffOBJECT" ), flashlightName)

                                -- Return the created instance.
                                return self
                            end

```

### onGamePaused

**Description**

> Event function for player pausing, locks and unlocks the input.

**Definition**

> onGamePaused(boolean isPaused)

**Arguments**

| boolean | isPaused | True if the game is paused; otherwise false. |
|---------|----------|----------------------------------------------|

**Code**

```lua
function PlayerInputComponent:onGamePaused(isPaused)

    -- Handle locking or unlocking the input.
    if isPaused then
        self:lock()
    else
            self:unlock()
        end
    end

```

### onInputChangeAltitude

**Description**

> Event function for player changing flight altitude.

**Definition**

> onInputChangeAltitude(nil, float inputValue)

**Arguments**

| Type  | Parameter | Description |
|-------|-----------|-------------|
| float |           |             |

**Code**

```lua
function PlayerInputComponent:onInputChangeAltitude(_, inputValue)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- Clamp the input value between -1 and 1.
        inputValue = math.clamp(inputValue, - 1 , 1 )

        -- Set the run axis to the input value.
        self.flightAxis = inputValue
    end

```

### onInputCrouch

**Description**

> Event function for player crouching.

**Definition**

> onInputCrouch(nil, float inputValue)

**Arguments**

| Type  | Parameter | Description |
|-------|-----------|-------------|
| float |           |             |

**Code**

```lua
function PlayerInputComponent:onInputCrouch(_, inputValue)

    -- Clamp the input value between 0 and 1.
    inputValue = math.clamp(inputValue, 0 , 1 )

    -- Set the crouch value to the input value.
    if self.locked then
        self.lockedCrouchValue = inputValue
    else
            self.crouchValue = inputValue
        end
    end

```

### onInputEnter

**Description**

> Event function for player entering closest vehicle.

**Definition**

> onInputEnter()

**Code**

```lua
function PlayerInputComponent:onInputEnter()
    local mission = g_currentMission
    -- If it has not been long enough since the last interaction, do nothing.
        if g_ time < = mission.lastInteractionTime + 200 then
            return
        end

        if mission.interactiveVehicleInRange ~ = nil then
            -- Try enter the vehicle.
            mission.interactiveVehicleInRange:interact( self.player)
            return
        end

        if self.rideablePlaceable ~ = nil then
            if self.rideablePlaceable:getAnimalCanBeRidden( self.rideableCluster.id) then
                g_inputBinding:setContext( PlayerInputComponent.INPUT_CONTEXT_NAME_ANIMAL_RIDING, true , false )
                mission:fadeScreen( 1 , 250 , self.onFinishedRideBlending, self , { self.rideablePlaceable, self.rideableCluster, self.player } )
            else
                    mission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, g_i18n:getText( "shop_messageAnimalRideableLimitReached" ))
                end
            end
        end

```

### onInputJump

**Description**

> Event function for player jumping.

**Definition**

> onInputJump(nil, float inputValue)

**Arguments**

| Type  | Parameter | Description |
|-------|-----------|-------------|
| float |           |             |

**Code**

```lua
function PlayerInputComponent:onInputJump(_, inputValue)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- Clamp the input value between 0 and 1.
        inputValue = math.clamp(inputValue, 0 , 1 )

        -- Set the jump power to the input value.
        self.jumpPower = inputValue
    end

```

### onInputLookLeftRight

**Description**

> Event function for player look left/right movement.

**Definition**

> onInputLookLeftRight(nil, float inputValue, nil, nil, boolean isMouse)

**Arguments**

| Type  | Parameter  |  |     |  |  |         |         |
|-------|------------|--|-----|--|--|---------|---------|
| float | inputValue |  |     |  |  |         |         |
| nil   |            |  | nil |  |  | boolean | isMouse |

**Code**

```lua
function PlayerInputComponent:onInputLookLeftRight(_, inputValue, _, _, isMouse)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- If the value is within the deadzone, do nothing.
            if math.abs(inputValue) < = g_gameSettings:getValue(GameSettings.SETTING.JOYSTICK_DEADZONE) then
                return
            end

            -- Apply dt to the input based on if it's a mouse input or not.
                if isMouse then
                    inputValue = inputValue * 0.001 * 16.666
                else
                        inputValue = inputValue * 0.001 * g_currentDt
                    end

                    -- Add the input to the left/right input rotation axis.
                    self.cameraRotationY = self.cameraRotationY + inputValue

                    -- If the rotation is a mouse rotation, set it as such.
                    self.isMouseRotation = isMouse
                end

```

### onInputLookUpDown

**Description**

> Event function for player look up/down movement.

**Definition**

> onInputLookUpDown(nil, float inputValue, nil, nil, boolean isMouse)

**Arguments**

| Type  | Parameter  |  |     |  |  |         |         |
|-------|------------|--|-----|--|--|---------|---------|
| float | inputValue |  |     |  |  |         |         |
| nil   |            |  | nil |  |  | boolean | isMouse |

**Code**

```lua
function PlayerInputComponent:onInputLookUpDown(_, inputValue, _, _, isMouse)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- If the value is within the deadzone, do nothing.
            if math.abs(inputValue) < = g_gameSettings:getValue(GameSettings.SETTING.JOYSTICK_DEADZONE) then
                return
            end

            -- Invert the up/down if the setting is enabled.
                if g_gameSettings:getValue(GameSettings.SETTING.INVERT_Y_LOOK) then
                    inputValue * = - 1
                end

                -- Apply dt to the input based on if it's a mouse input or not.
                    if isMouse then
                        inputValue = inputValue * 0.001 * 16.666
                    else
                            inputValue = inputValue * 0.001 * g_currentDt
                        end

                        -- Add the input to the up/down input rotation axis.
                        self.cameraRotationX = self.cameraRotationX + inputValue

                        -- If the rotation is a mouse rotation, set it as such.
                        self.isMouseRotation = isMouse
                    end

```

### onInputMoveForward

**Description**

> Event function for player forward/backward movement.

**Definition**

> onInputMoveForward(nil, float inputValue)

**Arguments**

| Type  | Parameter | Description |
|-------|-----------|-------------|
| float |           |             |

**Code**

```lua
function PlayerInputComponent:onInputMoveForward(_, inputValue)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- If the value is within the deadzone, do nothing.
            if math.abs(inputValue) < = g_gameSettings:getValue(GameSettings.SETTING.JOYSTICK_DEADZONE) then
                return
            end

            -- Clamp the input value between -1 and 1.
            inputValue = math.clamp(inputValue, - 1 , 1 )

            -- Subtract the input from the forwards/backwards input axis.
            self.moveForward = self.moveForward - inputValue

            -- Recalculate the walk axis.
            self.walkAxis = math.min( MathUtil.vector2Length( self.moveRight, self.moveForward), 1 )

            -- Recalulate the world axis.
            local worldDirectionX, worldDirectionZ = self:calculateNormalisedWorldMovementDirection()
            self:setMovementDirection(worldDirectionX, worldDirectionZ)
        end

```

### onInputMoveSide

**Description**

> Event function for player strafe movement.

**Definition**

> onInputMoveSide(nil, float inputValue)

**Arguments**

| Type  | Parameter | Description |
|-------|-----------|-------------|
| float |           |             |

**Code**

```lua
function PlayerInputComponent:onInputMoveSide(_, inputValue)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- If the value is within the deadzone, do nothing.
            if math.abs(inputValue) < = g_gameSettings:getValue(GameSettings.SETTING.JOYSTICK_DEADZONE) then
                return
            end

            -- Clamp the input value between -1 and 1.
            inputValue = math.clamp(inputValue, - 1 , 1 )

            -- Add the input to the left/right input axis.
            self.moveRight = self.moveRight + inputValue

            -- Recalculate the walk axis.
            self.walkAxis = math.min( MathUtil.vector2Length( self.moveRight, self.moveForward), 1 )

            -- Recalulate the world axis.
            local worldDirectionX, worldDirectionZ = self:calculateNormalisedWorldMovementDirection()
            self:setMovementDirection(worldDirectionX, worldDirectionZ)
        end

```

### onInputRun

**Description**

> Event function for player running.

**Definition**

> onInputRun(nil, float inputValue)

**Arguments**

| Type  | Parameter | Description |
|-------|-----------|-------------|
| float |           |             |

**Code**

```lua
function PlayerInputComponent:onInputRun(_, inputValue)

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        -- Clamp the input value between 0 and 1.
        inputValue = math.clamp(inputValue, 0 , 1 )

        -- Set the run axis to the input value.
        self.runAxis = inputValue
    end

```

### onInputSwitchCamera

**Description**

> Event function for player switching camera.

**Definition**

> onInputSwitchCamera()

**Code**

```lua
function PlayerInputComponent:onInputSwitchCamera()

    -- Do nothing if the input is locked.
        if self.locked then
            return
        end

        if self.player:getCurrentVehicle() ~ = nil then
            return
        end

        -- Toggle third person mode on the player's camera.
        self.player.camera:toggleThirdPersonMode()
    end

```

### registerActionEvents

**Description**

> Binds action events to internal functions.

**Definition**

> registerActionEvents()

**Code**

```lua
function PlayerInputComponent:registerActionEvents()

    -- Only bind for the owning player.
        if not self.player.isOwner then
            return
        end

        -- Register action events for the player context without switching(important when this is called from within the UI context).
            g_inputBinding:beginActionEventsModification( PlayerInputComponent.INPUT_CONTEXT_NAME)

            self:registerGlobalPlayerActionEvents()

            local _, eventId

            -- Move left/right.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.AXIS_MOVE_SIDE_PLAYER, self , self.onInputMoveSide, false , false , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Move forward/back.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.AXIS_MOVE_FORWARD_PLAYER, self , self.onInputMoveForward, false , false , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Look left/right.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.AXIS_LOOK_LEFTRIGHT_PLAYER, self , self.onInputLookLeftRight, false , false , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Look up/down.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.AXIS_LOOK_UPDOWN_PLAYER, self , self.onInputLookUpDown, false , false , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Zoom in/out.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.CAMERA_ZOOM_IN_OUT, self , self.onInputZoomInOut, false , true , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Run.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.AXIS_RUN, self , self.onInputRun, false , false , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Fly up/down.
            _, self.upDownFlightActionId = g_inputBinding:registerActionEvent(InputAction.DEBUG_PLAYER_UP_DOWN, self , self.onInputChangeAltitude, false , false , true , false , nil , true )
            g_inputBinding:setActionEventTextVisibility( self.upDownFlightActionId, false )

            -- Toggle flying.
            _, self.toggleFlightActionId = g_inputBinding:registerActionEvent(InputAction.DEBUG_PLAYER_ENABLE, self , self.onInputToggleFlightMode, true , false , false , false , nil , true )
            g_inputBinding:setActionEventTextVisibility( self.toggleFlightActionId, false )

            -- Jump.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.JUMP, self , self.onInputJump, false , true , false , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Crouch.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.CROUCH, self , self.onInputCrouch, false , false , true , true , nil , true )
            g_inputBinding:setActionEventTextVisibility(eventId, false )

            -- Switch perspective.
            _, self.toggleCameraId = g_inputBinding:registerActionEvent(InputAction.CAMERA_SWITCH, self , self.onInputSwitchCamera, false , true , false , true , nil , true )
            g_inputBinding:setActionEventActive( self.toggleCameraId, self:getCanToggleCamera())

            -- Switch hand tool.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.TOGGLE_HANDTOOL, self , self.onInputToggleHandTool, false , true , false , true , nil , true )

            -- Cycle hand tool.
            _, eventId = g_inputBinding:registerActionEvent(InputAction.CYCLE_HANDTOOL, self , self.onInputCycleHandTool, false , true , false , true , nil , true )

            -- Enter vehicle.
            _, self.enterActionId = g_inputBinding:registerActionEvent(InputAction.ENTER, self , self.onInputEnter, false , true , false , false , nil , true )

            _, self.toggleFlashlightId = g_inputBinding:registerActionEvent(InputAction.TOGGLE_LIGHTS_FPS, self , self.onInputToggleFlashlight, false , true , false , true , nil , true )
            g_inputBinding:setActionEventText( self.toggleFlashlightId, g_i18n:getText( "input_TOGGLE_LIGHTS_FPS" ))

            -- Reset registration context, update event data in input system.
            g_inputBinding:endActionEventsModification()

            if g_touchHandler ~ = nil then
                self.touchListenerPinch = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_PINCH, PlayerInputComponent.touchEventZoomInOut, self )
                self.touchListenerY = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_AXIS_Y, PlayerInputComponent.touchEventLookUpDown, self )
                self.touchListenerX = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_AXIS_X, PlayerInputComponent.touchEventLookLeftRight, self )
                self.touchListenerDoubleTab = g_touchHandler:registerGestureListener(TouchHandler.GESTURE_DOUBLE_TAP, PlayerInputComponent.touchEventCameraSwitch, self )
            end

            self:registerPauseActionEvents()

            -- Ensure objects are targeted.
            local targeter = self.player.targeter
            targeter:addTargetType( PlayerInputComponent , CollisionFlag.ANIMAL + CollisionFlag.VEHICLE + CollisionFlag.TREE + CollisionFlag.DYNAMIC_OBJECT, 0.5 , 3 )
        end

```

### resetState

**Description**

> Resets all input values to 0.

**Definition**

> resetState()

**Code**

```lua
function PlayerInputComponent:resetState()

    self.lastMoveForward = self.moveForward
    self.lastMoveRight = self.moveRight

    self.lastWorldDirectionX = self.worldDirectionX
    self.lastWorldDirectionZ = self.worldDirectionZ

    self.lastHasMovementInputs = self.hasMovementInputs

    self.lastWalkAxis = self.walkAxis
    self.lastRunAxis = self.runAxis
    self.lastFlightAxis = self.flightAxis
    self.lastJumpPower = self.jumpPower
    self.lastCrouchValue = self.crouchValue

    -- Reset the movement variables.
    self.moveForward = 0.0
    self.moveRight = 0.0
    self.worldDirectionX = 0.0
    self.worldDirectionZ = 0.0
    self.jumpPower = 0.0
    self.runAxis = 0.0
    self.walkAxis = 0.0
    self.flightAxis = 0.0

    if not self.locked then
        self.crouchValue = 0.0
    end

    -- Reset the camera variables.
    self.cameraRotationX = 0
    self.cameraRotationY = 0

    -- Reset any flags.
    self.hasMovementInputs = false
end

```

### touchEventLookLeftRight

**Description**

**Definition**

> touchEventLookLeftRight()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function PlayerInputComponent:touchEventLookLeftRight(value)
    if g_inputBinding.currentContextName ~ = PlayerInputComponent.INPUT_CONTEXT_NAME then
        return
    end

    local factor = (g_screenAspectRatio) * 75
    self:onInputLookLeftRight( nil , value * factor, nil , nil , false )
end

```

### touchEventLookUpDown

**Description**

**Definition**

> touchEventLookUpDown()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function PlayerInputComponent:touchEventLookUpDown(value)
    if g_inputBinding.currentContextName ~ = PlayerInputComponent.INPUT_CONTEXT_NAME then
        return
    end

    local factor = (g_screenHeight * g_pixelSizeX) * - 75
    self:onInputLookUpDown( nil , value * factor, nil , nil , false )
end

```

### touchEventZoomInOut

**Description**

**Definition**

> touchEventZoomInOut()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function PlayerInputComponent:touchEventZoomInOut(value)
    if g_inputBinding.currentContextName ~ = PlayerInputComponent.INPUT_CONTEXT_NAME then
        return
    end

    self:onInputZoomInOut( nil , - value * 75 , nil , nil , false , nil , nil )
end

```

### unlock

**Description**

> Unlocks the input.

**Definition**

> unlock()

**Code**

```lua
function PlayerInputComponent:unlock()

    self.locked = false

    if self.lockedCrouchValue ~ = self.crouchValue then
        self:onInputCrouch( nil , self.lockedCrouchValue)
    end
end

```

### unregisterActionEvents

**Description**

> Unbinds all action events.

**Definition**

> unregisterActionEvents()

**Code**

```lua
function PlayerInputComponent:unregisterActionEvents()

    -- Only unbind for the owning player.
        if not self.player.isOwner then
            return
        end

        g_inputBinding:beginActionEventsModification( PlayerInputComponent.INPUT_CONTEXT_NAME)
        g_inputBinding:removeActionEventsByTarget( self )
        g_inputBinding:endActionEventsModification()

        if g_touchHandler ~ = nil then
            g_touchHandler:removeGestureListener( self.touchListenerPinch)
            g_touchHandler:removeGestureListener( self.touchListenerY)
            g_touchHandler:removeGestureListener( self.touchListenerX)
        end

        self.player.targeter:removeTargetType( PlayerInputComponent )

        self.toggleFlightActionId = nil
        self.upDownFlightActionId = nil
        self.enterActionId = nil
    end

```