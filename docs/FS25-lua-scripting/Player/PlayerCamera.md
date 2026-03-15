## PlayerCamera

**Description**

> The interface representing the camera of a player in either third or first person mode.

**Functions**

- [calculateLocalDirection](#calculatelocaldirection)
- [calculateWorldDirection](#calculateworlddirection)
- [focusOnPlayer](#focusonplayer)
- [focusOnPosition](#focusonposition)
- [getCameraPosition](#getcameraposition)
- [getCurrentZoomDistance](#getcurrentzoomdistance)
- [getDesiredZoomDistance](#getdesiredzoomdistance)
- [getFocusPosition](#getfocusposition)
- [getIsCollisionEnabled](#getiscollisionenabled)
- [getOffsetY](#getoffsety)
- [getRotation](#getrotation)
- [initialise](#initialise)
- [makeCurrent](#makecurrent)
- [new](#new)
- [setCurrentZoomDistance](#setcurrentzoomdistance)
- [setFocusPosition](#setfocusposition)
- [setIsCollisionEnabled](#setiscollisionenabled)
- [setOffsetY](#setoffsety)
- [setRotation](#setrotation)
- [toggleThirdPersonMode](#togglethirdpersonmode)
- [tryApplyViewBobbing](#tryapplyviewbobbing)
- [updatePosition](#updateposition)
- [updateRotation](#updaterotation)

### calculateLocalDirection

**Description**

> Takes the given world x and z direction and transforms it into local-space around the yaw node.

**Definition**

> calculateLocalDirection(float directionX, float directionZ)

**Arguments**

| float | directionX | The x direction. |
|-------|------------|------------------|
| float | directionZ | The z direction. |

**Return Values**

| float | localDirectionX | The transformed x direction. |
|-------|-----------------|------------------------------|
| float | localDirectionZ | The transformed z direction. |

**Code**

```lua
function PlayerCamera:calculateLocalDirection(directionX, directionZ)
    local localDirectionX, _, localDirectionZ = worldDirectionToLocal( self.yawNode, directionX, 0 , directionZ)
    return localDirectionX, localDirectionZ
end

```

### calculateWorldDirection

**Description**

> Takes the given local x and z direction and transforms it into world-space around the yaw node.

**Definition**

> calculateWorldDirection(float directionX, float directionZ)

**Arguments**

| float | directionX | The x direction. |
|-------|------------|------------------|
| float | directionZ | The z direction. |

**Return Values**

| float | worldDirectionX | The transformed x direction. |
|-------|-----------------|------------------------------|
| float | worldDirectionZ | The transformed z direction. |

**Code**

```lua
function PlayerCamera:calculateWorldDirection(directionX, directionZ)
    local worldDirectionX, _, worldDirectionZ = localDirectionToWorld( self.yawNode, directionX, 0 , directionZ)
    return worldDirectionX, worldDirectionZ
end

```

### focusOnPlayer

**Description**

> Focuses the camera on the player, handling the positioning based on if the player is in first person mode or not.

**Definition**

> focusOnPlayer()

**Code**

```lua
function PlayerCamera:focusOnPlayer()

    -- Get the player's current position.
    local currentX, currentY, currentZ = self.player:getGraphicalPosition()
    self:focusOnPosition(currentX, currentY, currentZ)
end

```

### focusOnPosition

**Description**

> Positions the camera's yaw node to the given position, using the current offsetY.

**Definition**

> focusOnPosition(float x, float y, float z)

**Arguments**

| float | x | The x position. |
|-------|---|-----------------|
| float | y | The y position. |
| float | z | The z position. |

**Code**

```lua
function PlayerCamera:focusOnPosition(x, y, z)
    local baseOffsetY = self:getBaseOffsetY()
    self:setFocusPosition(x, y + self.offsetY + baseOffsetY, z)
end

```

### getCameraPosition

**Description**

> Gets the position of the camera node itself (not the yaw node).

**Definition**

> getCameraPosition()

**Return Values**

| float | x | The x position. |
|-------|---|-----------------|
| float | y | The y position. |
| float | z | The z position. |

**Code**

```lua
function PlayerCamera:getCameraPosition()
    return getWorldTranslation( self.cameraRootNode)
end

```

### getCurrentZoomDistance

**Description**

> Gets the current zoom distance of the camera.

**Definition**

> getCurrentZoomDistance()

**Return Values**

| float | zoomDistance | The current zoom distance of the camera. |
|-------|--------------|------------------------------------------|

**Code**

```lua
function PlayerCamera:getCurrentZoomDistance()
    return self.currentZoomDistance
end

```

### getDesiredZoomDistance

**Description**

> Gets the current zoom level of the camera. This is 0 if the player is in first person mode.

**Definition**

> getDesiredZoomDistance()

**Return Values**

| float | desiredZoomDistance | The current zoom distance of the camera. |
|-------|---------------------|------------------------------------------|

**Code**

```lua
function PlayerCamera:getDesiredZoomDistance()
    return self.isFirstPerson and 0 or self.desiredZoomDistance
end

```

### getFocusPosition

**Description**

> Gets the current position of the camera's yaw node, which is the position the camera is looking at.

**Definition**

> getFocusPosition()

**Return Values**

| float | x | The x position. |
|-------|---|-----------------|
| float | y | The y position. |
| float | z | The z position. |

**Code**

```lua
function PlayerCamera:getFocusPosition()
    return getWorldTranslation( self.yawNode)
end

```

### getIsCollisionEnabled

**Description**

> Gets if collision is enabled for this camera. This will be false if the player is in first person mode, even if the
> variable itself is true.

**Definition**

> getIsCollisionEnabled()

**Return Values**

| float | isCollisionEnabled | True if the camera is in third person and collision is enabled; otherwise false. |
|-------|--------------------|----------------------------------------------------------------------------------|

**Code**

```lua
function PlayerCamera:getIsCollisionEnabled()
    return self.isCollisionEnabled
end

```

### getOffsetY

**Description**

> Returns the current y offset of the camera. This is applied alongside the offset from the ground, to fine-adjust for
> things like swimming.

**Definition**

> getOffsetY()

**Return Values**

| float | offsetY | The current y offset of the camera. |
|-------|---------|-------------------------------------|

**Code**

```lua
function PlayerCamera:getOffsetY()
    return self.offsetY
end

```

### getRotation

**Description**

> Gets the rotation of the camera. This function avoids the flipping issue of the engine.

**Definition**

> getRotation()

**Return Values**

| float | pitch | The pitch of the camera. |
|-------|-------|--------------------------|
| float | yaw   | The yaw of the camera.   |
| float | roll  | The roll of the camera.  |

**Code**

```lua
function PlayerCamera:getRotation()

    -- Calculate and return the pitch, yaw, and roll from the camera.
    local cameraLookX, cameraLookY, cameraLookZ = localDirectionToWorld( self.cameraRootNode, 0 , 0 , - 1 )
    local pitch, yaw = MathUtil.directionToPitchYaw(cameraLookX, cameraLookY, cameraLookZ)
    local _, _, roll = getRotation( self.cameraRootNode)
    return pitch, yaw, roll
end

```

### initialise

**Description**

> Fired when the player loads for the first time. Creates and sets up the required nodes in the scene.

**Definition**

> initialise()

**Code**

```lua
function PlayerCamera:initialise()

    -- Create the camera nodes.
    self:initialiseCameraNodes()
end

```

### makeCurrent

**Description**

> Sets this camera as the scene's main camera.

**Definition**

> makeCurrent()

**Code**

```lua
function PlayerCamera:makeCurrent()
    if self.isFirstPerson then
        g_cameraManager:setActiveCamera( self.firstPersonCamera)
    elseif self.isInConversation then
            g_cameraManager:setActiveCamera( self.thirdPersonConversationCamera)
        else
                g_cameraManager:setActiveCamera( self.thirdPersonCamera)
            end
        end

```

### new

**Description**

> Creates a new camera for the given player.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player who owns this camera. |
|--------|--------|----------------------------------|

**Return Values**

| Player | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function PlayerCamera.new(player)

    -- Create the instance.
    local self = setmetatable( { } , PlayerCamera _mt)

    -- The player who owns this camera.
    self.player = player

    -- The current mode of the camera.
    self.isFirstPerson = true

    -- Is true if the player cannot switch between third and first, and can only use the current perspective.
        self.isSwitchingLocked = false

        -- The collision enabled flag, determining if the camera should be able to clip through objects.
            self.isCollisionEnabled = true

            -- The collision mask used when the player is in no-clip mode.
            self.noClipCollisionMask = PlayerCamera.COLLISION_MASK

            -- The distance between the camera and the object behind it, from the raycast.Nil if no object is behind the camera in range.
                self.lastCollisionDistance = nil

                -- The distance from the collided object that the camera should be.
                self.lastDistanceOffset = nil

                -- The nodes used for yaw and pitch for the camera.
                    self.yawNode = nil
                    self.pitchNode = nil

                    -- The actual camera object.
                    self.cameraRootNode = nil

                    -- The y offset.
                    self.offsetY = 0.0

                    -- The transform of the camera when a target override transition is started.
                    self.startPositionX, self.startPositionY, self.startPositionZ = nil , nil , nil
                    self.startRotationX, self.startRotationY, self.startRotationZ, self.startRotationW = nil , nil , nil , nil

                    -- The target transform of the override transition.
                    self.targetPositionX, self.targetPositionY, self.targetPositionZ = nil , nil , nil
                    self.targetRotationX, self.targetRotationY, self.targetRotationZ, self.targetRotationW = nil , nil , nil , nil

                    -- The start time and duration of the override transition.
                    self.overrideTransitionStartTime = nil
                    self.overrideTransitionDuration = nil

                    -- The last bob offsets.
                    self.lastBobOffsetX = 0.0
                    self.lastBobOffsetY = 0.0

                    -- The maximum zoom distance that the player would like to have.
                    self.desiredZoomDistance = PlayerCamera.DEFAULT_ZOOM

                    -- The zoom distance of the camera currently.
                    self.currentZoomDistance = self.desiredZoomDistance

                    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.FOV_Y_PLAYER_FIRST_PERSON], self.onFovySettingChanged, self )
                    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.FOV_Y_PLAYER_THIRD_PERSON], self.onFovySettingChanged, self )

                    -- Create and return the instance.
                    return self
                end

```

### setCurrentZoomDistance

**Description**

> Sets the current zoom distance, ensuring it does not go further than the desired distance and positioning the camera.

**Definition**

> setCurrentZoomDistance(float zoomDistance, boolean? isForced)

**Arguments**

| float    | zoomDistance | The new zoomDistance to use.             |
|----------|--------------|------------------------------------------|
| boolean? | isForced     | If true, will not clamp the given value. |

**Code**

```lua
function PlayerCamera:setCurrentZoomDistance(zoomDistance, isForced)
    self.currentZoomDistance = zoomDistance
    setTranslation( self.cameraRootNode, 0 , 0 , - self.currentZoomDistance)
end

```

### setFocusPosition

**Description**

> Sets the position of the yaw node to the given position.

**Definition**

> setFocusPosition(float x, float y, float z)

**Arguments**

| float | x | The x position. |
|-------|---|-----------------|
| float | y | The y position. |
| float | z | The z position. |

**Code**

```lua
function PlayerCamera:setFocusPosition(x, y, z)
    setWorldTranslation( self.yawNode, x, y, z)
end

```

### setIsCollisionEnabled

**Description**

> Sets the collision enabled value to the given value.

**Definition**

> setIsCollisionEnabled(boolean isCollisionEnabled)

**Arguments**

| boolean | isCollisionEnabled | The new value to use. |
|---------|--------------------|-----------------------|

**Code**

```lua
function PlayerCamera:setIsCollisionEnabled(isCollisionEnabled)
    self.isCollisionEnabled = isCollisionEnabled
end

```

### setOffsetY

**Description**

> Sets the current y offset to the given value. Defaults to 0.

**Definition**

> setOffsetY(float offsetY)

**Arguments**

| float | offsetY | The new y offset to use. If this is nil, uses 0 instead. |
|-------|---------|----------------------------------------------------------|

**Code**

```lua
function PlayerCamera:setOffsetY(offsetY)
    self.offsetY = offsetY or 0
end

```

### setRotation

**Description**

> Sets the rotation of the camera to the given rotation.

**Definition**

> setRotation(float pitch, float yaw, float roll)

**Arguments**

| float | pitch | The pitch of the camera. |
|-------|-------|--------------------------|
| float | yaw   | The yaw of the camera.   |
| float | roll  | The roll of the camera.  |

**Code**

```lua
function PlayerCamera:setRotation(pitch, yaw, roll)
    setRotation( self.pitchNode, pitch or 0 , 0 , 0 )
    setRotation( self.yawNode, 0 , yaw or 0 , 0 )
    setRotation( self.cameraRootNode, 0 , math.pi, roll or 0 )
end

```

### toggleThirdPersonMode

**Description**

> Handles toggling between first person and third person modes, including setting the camera position.

**Definition**

> toggleThirdPersonMode()

**Code**

```lua
function PlayerCamera:toggleThirdPersonMode()
    self:switchToPerspective( not self.isFirstPerson)
end

```

### tryApplyViewBobbing

**Description**

> Applies the view bobbing to the camera position, as long as the player is in first person and their CAMERA\_BOBBING
> setting is on.

**Definition**

> tryApplyViewBobbing(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerCamera:tryApplyViewBobbing(dt)

    -- If the player is in third person or their setting for view bobbing is off, reset the camera position.
        if not self.isFirstPerson then
            setTranslation( self.cameraRootNode, 0.0 , 0.0 , - self.currentZoomDistance)
            return
        end

        local doCameraBobbing = g_gameSettings:getValue(GameSettings.SETTING.CAMERA_BOBBING)
        if not doCameraBobbing then
            setTranslation( self.cameraRootNode, 0.0 , 0.0 , 0.0 )
            return
        end

        -- Avoid view bobbing when the player can move very fast.
        if self.player.mover.currentSpeed > 10 then
            return
        end

        -- Set the target bob offset, defaulting to 0.
        local targetBobOffsetX = 0.0
        local targetBobOffsetY = 0.0

        -- Set the roll, defaulting to 0.
        local bobRoll = 0

        -- If the player is moving and is on the ground, calculate the oscillating bob offset.
        local isMoving = math.abs( self.player.mover.currentSpeed) > = PlayerMover.SMALL_SPEED_THRESHOLD
        if isMoving and self.player.mover.isGrounded then

            -- Round the speed so it does not cause jitter.
            local roundedSpeed = MathUtil.round( self.player.mover.currentSpeed)

            -- Create a random number to shift the x oscillation by when calculating the y oscillation.This makes the up/down bobbing a bit more bumpy and natural.
            local randomOffsetX = math.random( - self.BOBBING_OSCILLATION_RANDOMNESS, self.BOBBING_OSCILLATION_RANDOMNESS)

            -- The x oscillation is simply the sine of the time(in seconds) multiplied by the random speed.
            local oscillationX = math.sin((g_ time * 0.001 ) * roundedSpeed)

            -- The y oscillation is calculated from the x oscillation, with a 90 degree lead so the bobbing makes an 'n' shape.A random offset is added to make it more natural.
            local oscillationY = math.sin((oscillationX + randomOffsetX + 0.5 ) * math.pi)

            -- Set the roll based on the x oscillation.
            bobRoll = oscillationX * PlayerCamera.ROLL_BOBBING

            -- Set the target bob offset.
            targetBobOffsetX = oscillationX * self.HORIZONTAL_BOBBING
            targetBobOffsetY = oscillationY * self.VERTICAL_BOBBING
        end

        -- Create the bob offset for each axis.
            local bobOffsetX, bobOffsetY

            -- Calculate the maximum possible movements on each axis.
            local maxBobMovementX = ( self.HORIZONTAL_BOBBING * self.MAXIMUM_BOBBING_OSCILLATION)
            local maxBobMovementY = ( self.VERTICAL_BOBBING * self.MAXIMUM_BOBBING_OSCILLATION)

            -- Calculate the most amount of bobbing the camera should make in this frame, on the x axis.
            if self.lastBobOffsetX < targetBobOffsetX then
                bobOffsetX = math.min( self.lastBobOffsetX + maxBobMovementX, targetBobOffsetX)
            else
                    bobOffsetX = math.max( self.lastBobOffsetX - maxBobMovementX, targetBobOffsetX)
                end

                -- Do the same for the y axis.
                    if self.lastBobOffsetY < targetBobOffsetY then
                        bobOffsetY = math.min( self.lastBobOffsetY + maxBobMovementY, targetBobOffsetY)
                    else
                            bobOffsetY = math.max( self.lastBobOffsetY - maxBobMovementY, targetBobOffsetY)
                        end

                        -- Apply the view bobbing to the camera.
                        setTranslation( self.cameraRootNode, bobOffsetX, bobOffsetY, 0.0 )
                        local currentPitch, currentYaw = self:getRotation()
                        self:setRotation(currentPitch, currentYaw, bobRoll)

                        -- Save the old bob offset.
                        self.lastBobOffsetX = bobOffsetX
                        self.lastBobOffsetY = bobOffsetY
                    end

```

### updatePosition

**Description**

> Updates the camera's position so that it follows the player, also applying view bobbing if needed.

**Definition**

> updatePosition(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerCamera:updatePosition(dt)

    -- If there's a target override, update for that and do nothing else.
        if self:getHasOverriddenTarget() then
            self:updatePositionFromTarget()
            return
        end

        -- Move the camera to the player's position.
        self:focusOnPlayer()

        -- Try apply the view bobbing.
        self:tryApplyViewBobbing(dt)

        -- Try apply the zoom logic, which includes raycasting to find the best distance.
        self:applyZoom(dt)
    end

```

### updateRotation

**Description**

> Updates the rotation of the camera based on player input.

**Definition**

> updateRotation(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerCamera:updateRotation(dt)

    -- If there's a target override, update for that and do nothing else.
        if self:getHasOverriddenTarget() then
            self:updateRotationFromTarget()
            return
        end

        -- Calculate how much of a rotation to make this frame based on the player's input and the camera sensitivity.
        local cameraSensitivity = g_gameSettings:getValue(GameSettings.SETTING.CAMERA_SENSITIVITY)
        local rotationDeltaX = self.player.inputComponent.cameraRotationX * cameraSensitivity
        local rotationDeltaY = - self.player.inputComponent.cameraRotationY * cameraSensitivity

        -- Get the current rotation of the camera.
        local cameraPitch, cameraYaw, cameraRoll = self:getRotation()

        -- Add the deltas, ensuring the pitch is limited.
        cameraPitch = math.clamp(cameraPitch + rotationDeltaX, PlayerCamera.LOWEST_PITCH, PlayerCamera.HIGHEST_PITCH)
        cameraYaw = MathUtil.getValidLimit(cameraYaw + rotationDeltaY)

        -- Set the rotation of the camera.
        self:setRotation(cameraPitch, cameraYaw, cameraRoll)
    end

```