## PlayerMover

**Description**

> Converts inputs into actual player movement, calculating and storing things like velocity.

**Functions**

- [calculateSmoothSpeed](#calculatesmoothspeed)
- [debugDraw](#debugdraw)
- [getMovementYaw](#getmovementyaw)
- [getSpeed](#getspeed)
- [initialise](#initialise)
- [moveHorizontally](#movehorizontally)
- [moveVertically](#movevertically)
- [new](#new)
- [onGroundRaycastCallback](#ongroundraycastcallback)
- [onWaterRaycastCallback](#onwaterraycastcallback)
- [setFlightActive](#setflightactive)
- [setPosition](#setposition)
- [teleportTo](#teleportto)
- [toggleFlightActive](#toggleflightactive)
- [update](#update)
- [updateFloorDistance](#updatefloordistance)
- [updateWaterSubmergeDistance](#updatewatersubmergedistance)

### calculateSmoothSpeed

**Description**

> Uses the given parameters to calculate a smooth speed, interpolated between various values depending on the state of
> the mover.

**Definition**

> calculateSmoothSpeed(float moveScalar, boolean doWading, float minimumSpeed, float maximumSpeed)

**Arguments**

| float   | moveScalar   | The value from 0 to 1 of how much the player is moving, this is usually the input. e.g. if the player is holding the movement analogue stick 50% of the way, this will be 0.5. |
|---------|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| boolean | doWading     | If this is true then the current water submerge distance is used, interpolating the speed between PlayerStateSwim.MAXIMUM_MOVE_SPEED and the maximumSpeed parameter.           |
| float   | minimumSpeed | The slowest speed of the player, this will only be used if doWading is false or the player is not submerged in water.                                                          |
| float   | maximumSpeed | The fastest speed that the player can move.                                                                                                                                    |

**Return Values**

| float | smoothSpeed | The interpolated speed. |
|-------|-------------|-------------------------|

**Code**

```lua
function PlayerMover:calculateSmoothSpeed(moveScalar, doWading, minimumSpeed, maximumSpeed)

    -- If water is to be taken into account, adjust the minimum speed and move scalar.
    if doWading then

        -- fix to stop movement if moveScalar is 0 as it does not work with adjusted lower bound otherwise
            if moveScalar = = 0 then
                return 0
            end

            -- Adjust the minimum movement speed possible if the player is in the water, so they smoothly go from running/walking to swimming.
                if self.currentWaterSubmergeDistance > PlayerMover.SLOW_SUBMERGE_THRESHOLD then
                    minimumSpeed = PlayerStateSwim.MAXIMUM_MOVE_SPEED
                end

                -- Apply the wade scalar to the movement so they become slower the more submerged they are.
                moveScalar = moveScalar * PlayerMover.calculateWadeScalar( self.currentWaterSubmergeDistance)
            end

            -- Smoothly interpolate the speed between the minimum and maximum.
            return MathUtil.lerp(minimumSpeed, maximumSpeed, moveScalar)
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
function PlayerMover:debugDraw(x, y, textSize)

    -- Draw the movement direction node.
    DebugUtil.drawDebugNode( self.movementDirectionNode, "MDIR" , false , 0 )

    -- Render the header.
    y = DebugUtil.renderTextLine(x, y, textSize * 1.5 , "Mover" , nil , true )

    -- Render the values.
    y = DebugUtil.renderTextLine(x, y, textSize, "Movement" , nil , true )
    local positionX, positionY, positionZ = self:getPosition()
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Position: %.2f, %.2f, %.2f" , positionX, positionY, positionZ))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Velocity: %.2f, %.2f, %.2f" , self.currentVelocityX, self.currentVelocityY , self.currentVelocityZ))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Movement yaw: %.4f" , self:getMovementYaw()))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Rotation: %.4f" , self.movementDirectionYaw))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Rotation velocity: %.4f" , self.currentRotationVelocity))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Speed: %.4f" , self.currentSpeed))
    y = DebugUtil.renderNewLine(y, textSize)
    y = DebugUtil.renderTextLine(x, y, textSize, "Ground/water" , nil , true )
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Water level: %.4f" , self.waterUnderfootY or 0.0 ))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Submerge distance: %.4f" , self.currentWaterSubmergeDistance))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Swimming/in water: %s/%s" , self.isSwimming, self.isInWater))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Ground level: %.4f" , self.groundUnderfootY or 0.0 ))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Ground distance: %.4f" , self.currentGroundDistance))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Grounded: %s" , self.isGrounded))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Close to ground: %s" , self.isCloseToGround))
    y = DebugUtil.renderTextLine(x, y, textSize, string.format( "Fall/air/ground time: %.4f/%.4f/%.4f" , self.currentFallTime, self.currentAirTime, self.currentGroundTime))

    -- Return the final y value.
    return y
end

```

### getMovementYaw

**Description**

> Gets the yaw (y rotation) of the player's movement direction. This is more or less the actual yaw that the player has,
> and the graphical node's yaw smoothly follows it.

**Definition**

> getMovementYaw()

**Return Values**

| float | currentForceYaw | The movement yaw of the player. |
|-------|-----------------|---------------------------------|

**Code**

```lua
function PlayerMover:getMovementYaw()
    return self.movementDirectionYaw
end

```

### getSpeed

**Description**

> Returns the player's current horizontal speed in metres per second.

**Definition**

> getSpeed()

**Return Values**

| float | currentSpeed | The player's current speed in metres per second. |
|-------|--------------|--------------------------------------------------|

**Code**

```lua
function PlayerMover:getSpeed()
    return self.currentSpeed
end

```

### initialise

**Description**

> Is called when the player first loads into the world, used to create and set up the movement node into the scene.

**Definition**

> initialise()

**Code**

```lua
function PlayerMover:initialise()

    -- Create the node used to show the direction of movement relative to the player.
    self.movementDirectionNode = createTransformGroup( "movementDirectionNode" )
    link(getRootNode(), self.movementDirectionNode)
end

```

### moveHorizontally

**Description**

> Adds the given movement to the player's movement this frame. Does not immediately change the player's position.

**Definition**

> moveHorizontally(float currentForceX, float currentForceZ)

**Arguments**

| float | currentForceX | The movement to make on the x axis in world space. |
|-------|---------------|----------------------------------------------------|
| float | currentForceZ | The movement to make on the z axis in world space. |

**Code**

```lua
function PlayerMover:moveHorizontally(currentForceX, currentForceZ)

    -- Add the movement to the movement this frame.
    self.currentForceX = self.currentForceX + currentForceX
    self.currentForceZ = self.currentForceZ + currentForceZ

    -- Raise the dirty flag, as a change has been made.
    self.player:raiseDefaultDirtyFlag()
end

```

### moveVertically

**Description**

> Adds the given movement to the player's movement this frame. Does not immediately change the player's position.

**Definition**

> moveVertically(float currentForceY)

**Arguments**

| float | currentForceY | The movement to make on the y axis in world space. |
|-------|---------------|----------------------------------------------------|

**Code**

```lua
function PlayerMover:moveVertically(currentForceY)

    -- Add the movement to the movement this frame.
    self.currentForceY = self.currentForceY + currentForceY

    -- Raise the dirty flag, as a change has been made.
    self.player:raiseDefaultDirtyFlag()
end

```

### new

**Description**

> Creates a new instance of the player mover class.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player who owns this mover and is moved. |
|--------|--------|----------------------------------------------|

**Return Values**

| Player | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function PlayerMover.new(player)

    -- TODO:Set up the dirty flag for the mover.

        -- Create the instance.
        local self = setmetatable( { } , PlayerMover _mt)

        -- The player.
        self.player = player

        -- If this is true, update functions will run as normal and the player will be able to move and be affected by gravity.
        self.isPhysicsEnabled = true

        -- The movement to make this frame.
        self.currentForceX = 0.0
        self.currentForceY = 0.0
        self.currentForceZ = 0.0

        -- The rotation on the Y axis in world space in which the player is currently moving.
        self.movementDirectionYaw = 0.0

        -- The node used to show the direction of movement.
        self.movementDirectionNode = nil

        -- The velocity of the player.
        self.currentSpeed = 0.0
        self.currentVelocityX = 0.0
        self.currentVelocityY = 0.0
        self.currentVelocityZ = 0.0

        self.positionDeltaX = 0.0
        self.positionDeltaY = 0.0
        self.positionDeltaZ = 0.0

        self.currentRotationVelocity = 0.0

        -- The water level under the player's feet, and the distance from the player to the water level.
        self.waterUnderfootY = 0.0
        self.currentWaterSubmergeDistance = 0.0

        -- The floor level under the player's feet, and the distance from the player to the floor level.
        self.groundUnderfootY = 0.0
        self.currentGroundDistance = 0.0

        -- Is true if the player is currently grounded(not falling or jumping); otherwise false.
            self.isGrounded = true

            -- Is true if the player is currently close to the ground; otherwise false.
                self.isCloseToGround = true

                self.isInWater = false

                -- Is true if the player is submerged in water enough to start swimming; otherwise false.
                    self.isSwimming = false
                    self.needSwimming = false

                    self.isCrouching = false

                    self.isOnLadder = false

                    -- How many seconds the player has been in the air.
                    self.currentAirTime = 0.0

                    -- How many seconds the player has been falling.
                    self.currentFallTime = 0.0

                    -- How many seconds the player has been on the ground.
                    self.currentGroundTime = 0.0

                    self.isFlightActive = false

                    -- The dirty flag.
                    self.dirtyFlag = self.player:getNextDirtyFlag()

                    -- The event for when the position is changed via PlayerMover.teleportXXX.
                        self.onPositionTeleport = ListenerList.new()

                        -- Return the created instance.
                        return self
                    end

```

### onGroundRaycastCallback

**Description**

> Raycast callback for the ground checking ray. Simply sets self.groundUnderfootY to the y parameter if the hitObjectId
> exists.

**Definition**

> onGroundRaycastCallback(float hitObjectId, float x, float y, float z)

**Arguments**

| float | hitObjectId | The id of the object hit by the ray. |
|-------|-------------|--------------------------------------|
| float | x           | The x position of the ray hit.       |
| float | y           | The y position of the ray hit.       |
| float | z           | The z position of the ray hit.       |

**Code**

```lua
function PlayerMover:onGroundRaycastCallback(hitObjectId, x, y, z)
    if hitObjectId ~ = 0 then
        self.groundUnderfootY = y
    end
end

```

### onWaterRaycastCallback

**Description**

> Raycast callback for the water checking ray
> Sets self.waterUnderfootY to the y parameter if the hitObjectId exists and updates isInWater, needSwimming and
> isSwimming variables

**Definition**

> onWaterRaycastCallback(float hitObjectId, float x, float y, float z)

**Arguments**

| float | hitObjectId | The id of the object hit by the ray. |
|-------|-------------|--------------------------------------|
| float | x           | The x position of the ray hit.       |
| float | y           | The y position of the ray hit.       |
| float | z           | The z position of the ray hit.       |

**Code**

```lua
function PlayerMover:onWaterRaycastCallback(hitObjectId, x, y, z)
    if hitObjectId ~ = 0 then
        self.waterUnderfootY = y
    end

    -- Start with a distance of 0
    self.currentWaterSubmergeDistance = 0.0

    -- If the ray hit water save the result.
    if self.waterUnderfootY ~ = nil then
        self.currentWaterSubmergeDistance = math.max( 0 , self.waterUnderfootY - self.updateWaterSubmergeDistanceCurrentY)
    end

    self.isInWater = self.currentWaterSubmergeDistance > 0

    self.needSwimming = self.currentWaterSubmergeDistance > = PlayerMover.SWIM_SUBMERGE_THRESHOLD

    self.isSwimming = self.currentWaterSubmergeDistance > = PlayerMover.SWIM_SUBMERGE_THRESHOLD - 0.2
end

```

### setFlightActive

**Description**

> Sets the flight active mode to the given value. Does nothing if the player's flight mode is not toggled on.

**Definition**

> setFlightActive(boolean isFlightActive, boolean? isForced)

**Arguments**

| boolean  | isFlightActive | True if flight mode should be activated; otherwise false. |
|----------|----------------|-----------------------------------------------------------|
| boolean? | isForced       | If this is true, the check for the command is skipped.    |

**Code**

```lua
function PlayerMover:setFlightActive(isFlightActive, isForced)

    -- Disallow flight if the command is not toggled on.
        if not isForced and( self.player.toggleFlightModeCommand = = nil or self.player.toggleFlightModeCommand.value = = false ) then
            return
        end

        -- Set the flight toggle.
        self.isFlightActive = isFlightActive = = true
    end

```

### setPosition

**Description**

> Moves the player to the given position.

**Definition**

> setPosition(float x, float y, float z, boolean? setNodeTranslation)

**Arguments**

| float    | x                  | The x position.                                                                                      |
|----------|--------------------|------------------------------------------------------------------------------------------------------|
| float    | y                  | The y position.                                                                                      |
| float    | z                  | The z position.                                                                                      |
| boolean? | setNodeTranslation | If this is true, the player's root node will also be moved to the given position. Defaults to false. |

**Code**

```lua
function PlayerMover:setPosition(x, y, z, setNodeTranslation)

    -- Move the player via their CCT.
    self.player.capsuleController:setPosition(x, y, z, setNodeTranslation)

    -- Raise the dirty flag, as a change has been made.
    self.player:raiseDefaultDirtyFlag()
end

```

### teleportTo

**Description**

> Teleports the player to the given position, sending a network event.

**Definition**

> teleportTo(float x, float y, float z, boolean? setNodeTranslation, boolean? noEventSend)

**Arguments**

| float    | x                  | The x position.                                                                                      |
|----------|--------------------|------------------------------------------------------------------------------------------------------|
| float    | y                  | The y position.                                                                                      |
| float    | z                  | The z position.                                                                                      |
| boolean? | setNodeTranslation | If this is true, the player's root node will also be moved to the given position. Defaults to false. |
| boolean? | noEventSend        | If this is true, no event will be sent to the server/client.                                         |

**Code**

```lua
function PlayerMover:teleportTo(x, y, z, setNodeTranslation, noEventSend)

    g_messageCenter:publish(MessageType.PLAYER_PRE_TELEPORT, self.player)

    -- If the player is not the server and is the controlling player, then fire the teleport event so that the teleport is reflected on the server.
    if not noEventSend and not self.player.isServer and self.player.isOwner then
        g_client:getServerConnection():sendEvent( PlayerTeleportEvent.new(x, y, z, true , false ))
    end

    -- Set the last position.
    self.lastPositionX, self.lastPositionY, self.lastPositionZ = self:getPosition()

    -- Call the base move function.
        self:setPosition(x, y, z, setNodeTranslation)

        self.onPositionTeleport:invoke(x, y, z)

        --#debug self.player:debugLog(Player.DEBUG_DISPLAY_FLAG.MOVEMENT, "Teleported to %.4f, %.4f, %.4f", x, y, z)
    end

```

### toggleFlightActive

**Description**

> Toggles the flight active mode on/off. Does nothing if the player's flight mode is not toggled on.

**Definition**

> toggleFlightActive()

**Code**

```lua
function PlayerMover:toggleFlightActive()
    self:setFlightActive( not self.isFlightActive)
end

```

### update

**Description**

> Applies gravity and movement every frame.

**Definition**

> update(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerMover:update(dt)

    local nextPositionX, nextPositionY, nextPositionZ
    if self:getIsPhysicsEnabled() then
        -- Update and calculate the deltas.
        self.positionDeltaX, self.positionDeltaY, self.positionDeltaZ = self:updateDeltas(dt)

        -- Calculate where the player should be after the move, if there are no collisions.
            local currentPositionX, currentPositionY, currentPositionZ = self:getPosition()
            nextPositionX, nextPositionY, nextPositionZ = currentPositionX + self.positionDeltaX, currentPositionY + self.positionDeltaY, currentPositionZ + self.positionDeltaZ

            setWorldTranslation( self.movementDirectionNode, nextPositionX, nextPositionY, nextPositionZ)

            -- Apply the velocity to the player CCT.
            self.player.capsuleController:move( self.positionDeltaX, self.positionDeltaY, self.positionDeltaZ)
        end

        -- If no next position was calculated, use the current position.
        if nextPositionX = = nil then
            nextPositionX, nextPositionY, nextPositionZ = self:getPosition()
        end

        -- Get the collision of the player's collider, if the bottom is touching something then they are grounded.This can only be done on the server.
            local isGrounded = nil
            if self.player.isServer or self:getIsPhysicsEnabled() then
                isGrounded = self.player.capsuleController:calculateIfBottomTouchesGround()
            end

            -- Update the current distance from the water level and floor using the current position.
            self:updateWaterSubmergeDistance(nextPositionX, nextPositionY, nextPositionZ)
            self:updateFloorDistance(dt, isGrounded, nextPositionX, nextPositionY, nextPositionZ)

            -- If physics are disabled, don't bother updating anything else.
                if not self:getIsPhysicsEnabled() then
                    return
                end

                local movementYaw
                if self.player.isStrafeWalkMode then
                    local _, yaw = self.player.camera:getRotation()
                    movementYaw = yaw
                else
                        local currentSpeed = self:getSpeed()
                        movementYaw = currentSpeed < = 0 and self.movementDirectionYaw or MathUtil.getYRotationFromDirection( self.currentVelocityX / currentSpeed, self.currentVelocityZ / currentSpeed)
                    end

                    -- Update the movement node's rotation.
                    local oldDirectionYaw = self.movementDirectionYaw
                    self:updateRotation(dt, movementYaw)
                    self.currentRotationVelocity = MathUtil.getValidLimit( self.movementDirectionYaw - oldDirectionYaw) / (dt * 0.001 )
                end

```

### updateFloorDistance

**Description**

> Updates the distance from the player to the ground level to determine how far in the air they are.

**Definition**

> updateFloorDistance(float dt, , , , )

**Arguments**

| float | dt         | The current delta time, used to update the self.currentFallTime timer. |
|-------|------------|------------------------------------------------------------------------|
| any   | isGrounded |                                                                        |
| any   | currentX   |                                                                        |
| any   | currentY   |                                                                        |
| any   | currentZ   |                                                                        |

**Code**

```lua
function PlayerMover:updateFloorDistance(dt, isGrounded, currentX, currentY, currentZ)

    -- If a grounded value was given, use it.
    if isGrounded ~ = nil then
        self.isGrounded = isGrounded
    end

    -- If the bottom of the player's collider is touching the ground, set the ground distance to 0 and the ground level to the given y.This avoids raycasting.
    if self.isGrounded then
        self.currentGroundDistance = 0.0
        self.groundUnderfootY = currentY
        -- Otherwise; calculate the distance from the ground using a raycast.
    else

            -- Reset the ground level distance and fire a ray downwards.
            self.groundUnderfootY = nil
            raycastClosest(currentX, currentY + 10 , currentZ, 0 , - 1 , 0 , 200 , "onGroundRaycastCallback" , self , CollisionFlag.TERRAIN + CollisionFlag.STATIC_OBJECT + CollisionFlag.ROAD)

            -- If the ray hit the ground, then calculate the distance.
            if self.groundUnderfootY ~ = nil then
                self.currentGroundDistance = math.max( 0 , currentY - self.groundUnderfootY)
                -- Otherwise; treat y0 as the floor.
            else
                    self.groundUnderfootY = 0.0
                    self.currentGroundDistance = currentY
                end
            end

            -- The player is close to ground if they are either grounded or they're close enough to the ground.
                self.isCloseToGround = self.isGrounded or self.currentGroundDistance < = self.CLOSE_TO_GROUND_THRESHOLD

                -- Increment the fall timer.If the player is grounded or swimming then set it to 0.
                self.currentGroundTime = self.isGrounded and self.currentGroundTime + dt * 0.001 or 0
                self.currentAirTime = ( self.isGrounded or self.isInWater) and 0 or self.currentAirTime + dt * 0.001
                self.currentFallTime = ( self.currentAirTime = = 0 or self.currentVelocityY > = 0 ) and 0 or self.currentFallTime + dt * 0.001
            end

```

### updateWaterSubmergeDistance

**Description**

> Updates the distance from the player to the water level to determine how submerged they are.

**Definition**

> updateWaterSubmergeDistance()

**Arguments**

| any | currentX |
|-----|----------|
| any | currentY |
| any | currentZ |

**Code**

```lua
function PlayerMover:updateWaterSubmergeDistance(currentX, currentY, currentZ)

    -- Reset the water level distance and fire a ray downwards.
    self.waterUnderfootY = nil
    self.updateWaterSubmergeDistanceCurrentY = currentY
    raycastClosestAsync(currentX, currentY + 3 , currentZ, 0 , - 1 , 0 , 6 , "onWaterRaycastCallback" , self , CollisionFlag.WATER)
end

```