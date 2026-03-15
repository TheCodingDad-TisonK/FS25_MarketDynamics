## PlayerLocalNetworkComponent

**Description**

> A wrapped collection of historical inputs, positions, and states. Used to keep a history of the local gamestate for
> reconcilation purposes.
> This only exists on clients, and only for the controlling player. It mainly non-instrusively gathers data from the
> player and network, and only makes changes to reconcile.

**Parent**

> [PlayerNetworkComponent](?version=script&category=61&class=568)

**Functions**

- [new](#new)
- [readUpdateStream](#readupdatestream)
- [update](#update)
- [updateTick](#updatetick)
- [writeUpdateStream](#writeupdatestream)

### new

**Description**

> Creates a new network history for the given player.

**Definition**

> new(Player player)

**Arguments**

| Player | player | The player who owns this history. |
|--------|--------|-----------------------------------|

**Return Values**

| Player | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function PlayerLocalNetworkComponent.new(player)
    local self = PlayerNetworkComponent.new(player, PlayerLocalNetworkComponent _mt)

    self.player = player

    self.tickHistory = { }
    self.currentTickIndex = 0

    self.movementX = 0
    self.movementY = 0
    self.movementZ = 0
    self.movementYaw = 0

    return self
end

```

### readUpdateStream

**Description**

> Reads the positional data from the incoming network stream and reconciles any desync.

**Definition**

> readUpdateStream(integer streamId, Connection connection, integer timestamp)

**Arguments**

| integer    | streamId   | The id of the stream from which to read.            |
|------------|------------|-----------------------------------------------------|
| Connection | connection | The connection between the server and the client.   |
| integer    | timestamp  | The current timestamp for synchronisation purposes. |

**Code**

```lua
function PlayerLocalNetworkComponent:readUpdateStream(streamId, connection, timestamp)
    PlayerLocalNetworkComponent:superClass().readUpdateStream( self , streamId, connection, timestamp)

    -- read the data that the PlayerServerNetworkComponent sends to target players
    local tickIndex = streamReadUInt32(streamId)

    local isControlled = streamReadBool(streamId)
    local skipModel = streamReadBool(streamId)
    local skipMover = streamReadBool(streamId)
    self.player:updateControlledState(isControlled, skipModel, skipMover)

    local receivedPositionX = streamReadFloat32(streamId)
    local receivedPositionY = streamReadFloat32(streamId)
    local receivedPositionZ = streamReadFloat32(streamId)

    -- Set the position of the player.
    self.player.mover:setPosition(receivedPositionX, receivedPositionY, receivedPositionZ)

    local historyToDelete = self.tickHistory[ 1 ]
    while historyToDelete ~ = nil and historyToDelete.tickIndex < = tickIndex do
        table.remove( self.tickHistory, 1 )
        historyToDelete = self.tickHistory[ 1 ]
    end

    local numHistoryEntries = # self.tickHistory
    local numAggregationTicks = math.ceil(numHistoryEntries / 5 )

    local totalMovementX, totalMovementY, totalMovementZ = nil , nil , nil
    local numSteps = 0
    for _, history in ipairs( self.tickHistory) do

        if totalMovementX = = nil then
            totalMovementX, totalMovementY, totalMovementZ = 0 , 0 , 0
        end
        totalMovementX = totalMovementX + history.movementX
        totalMovementY = totalMovementY + history.movementY
        totalMovementZ = totalMovementZ + history.movementZ

        numSteps = numSteps + 1

        if numSteps > = numAggregationTicks then
            self.player.capsuleController:move(totalMovementX, totalMovementY, totalMovementZ)
            totalMovementX = nil
            numSteps = 0
        end
    end

    if numSteps > 0 then
        self.player.capsuleController:move(totalMovementX, totalMovementY, totalMovementZ)
    end
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
function PlayerLocalNetworkComponent:update(dt)
    if self.needNewTick then
        self.currentTickIndex = self.currentTickIndex + 1

        while # self.tickHistory > PlayerLocalNetworkComponent.NETWORK_HISTORY_MAX_LENGTH do
            table.remove( self.tickHistory, 1 )
        end

        local history = {
        tickIndex = self.currentTickIndex,
        movementX = 0 ,
        movementY = 0 ,
        movementZ = 0
        }

        table.insert( self.tickHistory, history)
        self.needNewTick = false
    end

    self.movementX = self.movementX + self.player.mover.positionDeltaX
    self.movementY = self.movementY + self.player.mover.positionDeltaY
    self.movementZ = self.movementZ + self.player.mover.positionDeltaZ
    self.movementYaw = self.player.mover:getMovementYaw()

    local currentTickHistory = self.tickHistory[# self.tickHistory]
    if currentTickHistory ~ = nil then
        currentTickHistory.movementX = currentTickHistory.movementX + self.player.mover.positionDeltaX
        currentTickHistory.movementY = currentTickHistory.movementY + self.player.mover.positionDeltaY
        currentTickHistory.movementZ = currentTickHistory.movementZ + self.player.mover.positionDeltaZ
    end
end

```

### updateTick

**Description**

> Runs every tick and handles preparing the state.

**Definition**

> updateTick(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerLocalNetworkComponent:updateTick(dt)
    -- update tick index in next frame
    self.needNewTick = true
end

```

### writeUpdateStream

**Description**

> Writes the state into the outgoing network stream.

**Definition**

> writeUpdateStream(integer streamId, Connection connection, integer dirtyMask)

**Arguments**

| integer    | streamId   | The id of the stream into which to write.         |
|------------|------------|---------------------------------------------------|
| Connection | connection | The connection between the server and the client. |
| integer    | dirtyMask  | The current dirty mask.                           |

**Code**

```lua
function PlayerLocalNetworkComponent:writeUpdateStream(streamId, connection, dirtyMask)

    --#debug Assert.isTrue(self.player.isOwner, "PlayerLocalNetworkComponent only works with the owner player!")

    PlayerLocalNetworkComponent:superClass().writeUpdateStream( self , streamId, connection, dirtyMask)

    streamWriteUInt32(streamId, self.currentTickIndex)
    streamWriteFloat32(streamId, self.movementX)
    streamWriteFloat32(streamId, self.movementY)
    streamWriteFloat32(streamId, self.movementZ)
    NetworkUtil.writeCompressedAngle(streamId, self.movementYaw)
    streamWriteBool(streamId, self.player.camera.isFirstPerson)
    streamWriteBool(streamId, self.player.mover.isCrouching)

    self.movementX = 0
    self.movementY = 0
    self.movementZ = 0
    self.movementYaw = 0
end

```