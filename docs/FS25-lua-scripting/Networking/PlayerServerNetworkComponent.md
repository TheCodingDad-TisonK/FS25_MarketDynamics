## PlayerServerNetworkComponent

**Description**

> The class which handles player positions and states on the server side.

**Parent**

> [PlayerNetworkComponent](?version=script&category=61&class=572)

**Functions**

- [new](#new)
- [readUpdateStream](#readupdatestream)
- [update](#update)
- [updateTick](#updatetick)
- [writeUpdateStream](#writeupdatestream)

### new

**Description**

> Creates a new network component for the given player.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player whose position and state is being managed by this component. |
|--------|--------|-------------------------------------------------------------------------|

**Return Values**

| Player | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function PlayerServerNetworkComponent.new(player)
    local self = PlayerNetworkComponent.new(player, PlayerServerNetworkComponent _mt)

    self.player = player

    -- The owner player has extra debug information drawn.
    if not player.isOwner then
        self.tickHistory = { }

        -- The next tick to send to the client.
        self.nextSendTick = 0
    end

    self.skipModel = false
    self.skipMover = false
    self.isFirstPerson = false

    return self
end

```

### readUpdateStream

**Description**

> Reads the data from the incoming network stream and handles the state.

**Definition**

> readUpdateStream(integer streamId, Connection connection, integer timestamp)

**Arguments**

| integer    | streamId   | The id of the stream from which to read.                 |
|------------|------------|----------------------------------------------------------|
| Connection | connection | The connection between the server and the target client. |
| integer    | timestamp  | The current timestamp for synchronisation purposes.      |

**Code**

```lua
function PlayerServerNetworkComponent:readUpdateStream(streamId, connection, timestamp)

    PlayerServerNetworkComponent:superClass().readUpdateStream( self , streamId, connection, timestamp)

    -- If the player is locally hosting the server, don't bother reading the update stream for them.
        if self.player.isOwner then
            return
        end

        local tickIndex = streamReadUInt32(streamId)

        -- Read the movement.
        local movementX = streamReadFloat32(streamId)
        local movementY = streamReadFloat32(streamId)
        local movementZ = streamReadFloat32(streamId)
        local movementYaw = NetworkUtil.readCompressedAngle(streamId)
        self.isFirstPerson = streamReadBool(streamId)
        local isCrouching = streamReadBool(streamId)

        -- Enqueue the movement within the blessed physics system.
        self.player.capsuleController:move(movementX, movementY, movementZ)
        self.player.mover:setMovementYaw(movementYaw)
        self.player.mover:setIsCrouching(isCrouching)

        local interpolator = self.player.positionalInterpolator
        interpolator:startNetworkNewPhase()
        interpolator:setTargetYaw(movementYaw)

        local physicsIndex = getPhysicsUpdateIndex()
        table.insert( self.tickHistory, { index = tickIndex, physicsIndex = physicsIndex } )

        interpolator:setTargetPhysicsIndex(physicsIndex)
        --
        -- local maximumSpeed = self.player.stateMachine.states.onFoot:getMaximumSpeed()
        -- local speedPercentage = NetworkUtil.readCompressedPercentages(streamId, 12)
        -- local verticalSpeed = NetworkUtil.readCompressedRange(streamId, PlayerMover.MAXIMUM_DOWNWARD_SPEED, PlayerMover.MAXIMUM_UPWARD_SPEED, 12)

        -- local movementDirectionX, movementDirectionZ = 0, 0
        -- if movementX ~ = 0 or movementZ ~ = 0 then
            -- movementDirectionX, movementDirectionZ = MathUtil.vector2Normalize(movementX, movementZ)
            -- end

            -- local currentPositionX, currentPositionY, currentPositionZ = self.player:getPosition()
            -- self.player.positionalInterpolator:startNetworkPhaseWithTarget(currentPositionX, currentPositionY, currentPositionZ, qx, qy, qz, qw)

            -- self.player.positionalInterpolator:setDirection(movementDirectionX, movementDirectionZ)

            -- self.player.mover:setMovementYaw(movementYaw)
            -- self.player.mover:setVelocity(movementDirectionX * maximumSpeed * speedPercentage, verticalSpeed, movementDirectionZ * maximumSpeed * speedPercentage)
            -- self.player.mover:setSpeed(maximumSpeed * speedPercentage)

        end

```

### update

**Description**

> Updates the player based on the network state every frame.

**Definition**

> update(float dt)

**Arguments**

| float | dt | delta time in ms |
|-------|----|------------------|

**Code**

```lua
function PlayerServerNetworkComponent:update(dt)

end

```

### updateTick

**Description**

> Runs every tick (around 30 times a second) and handles preparing the state.

**Definition**

> updateTick(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerServerNetworkComponent:updateTick(dt)

    -- Pump through the simulating ticks to remove any that have been simulated, and set the index of the tick to send.
    if not self.player.isOwner then

        -- find the latest index, which is already simulated now
        local latestSimulatedIndex = - 1
        local history = self.tickHistory[ 1 ]
        while history ~ = nil and getIsPhysicsUpdateIndexSimulated(history.physicsIndex) do
            latestSimulatedIndex = history.index
            table.remove( self.tickHistory, 1 )
            history = self.tickHistory[ 1 ]
        end

        if latestSimulatedIndex > = 0 then
            self.nextSendTick = latestSimulatedIndex
            self.player:raiseDefaultDirtyFlag()
        end
    end

    self.doNextDebugDrawTick = true
end

```

### writeUpdateStream

**Description**

> Writes the state into the outgoing network stream.

**Definition**

> writeUpdateStream(integer streamId, Connection connection, integer dirtyMask)

**Arguments**

| integer    | streamId   | The id of the stream into which to write.                |
|------------|------------|----------------------------------------------------------|
| Connection | connection | The connection between the server and the target client. |
| integer    | dirtyMask  | The current dirty mask.                                  |

**Code**

```lua
function PlayerServerNetworkComponent:writeUpdateStream(streamId, connection, dirtyMask)

    PlayerServerNetworkComponent:superClass().writeUpdateStream( self , streamId, connection, dirtyMask)

    -- The client who is controlling this player needs special tick data.
    local isTargetPlayer = connection = = self.player.connection
    if isTargetPlayer then
        -- Write the tick.
        streamWriteUInt32(streamId, self.nextSendTick)
    end

    streamWriteBool(streamId, self.player.isControlled)
    streamWriteBool(streamId, self.skipModel)
    streamWriteBool(streamId, self.skipMover)

    -- Get the position of the player from the last physics update.
    local positionX, positionY, positionZ = self.player.mover:getPosition()
    streamWriteFloat32(streamId, positionX)
    streamWriteFloat32(streamId, positionY)
    streamWriteFloat32(streamId, positionZ)

    if not isTargetPlayer then
        -- The target player's client tells the server what yaw they have, the server then tells all other clients.The target player does not need to know its own yaw.
        local yaw = self.player.mover:getMovementYaw()
        NetworkUtil.writeCompressedAngle(streamId, yaw)

        -- Get the collision of the player's collider, if the bottom is touching something then they are grounded.
            local isGrounded = self.player.capsuleController:calculateIfBottomTouchesGround()
            streamWriteBool(streamId, isGrounded)

            if self.player.isOwner then
                streamWriteBool(streamId, self.player.camera.isFirstPerson)
            else
                    streamWriteBool(streamId, self.isFirstPerson)
                end
                streamWriteBool(streamId, self.player.mover.isCrouching)
                streamWriteBool(streamId, self.player.graphicsComponent.isGraphicsRootNodeVisible)
            end
        end

```