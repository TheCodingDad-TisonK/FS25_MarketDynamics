## PlayerStateFall

**Description**

> The state used for the player being in the air after a set amount of time.

**Parent**

> [BaseStateMachineState](?version=script&category=80&class=843)

**Functions**

- [calculateDesiredHorizontalVelocity](#calculatedesiredhorizontalvelocity)
- [calculateIfFalling](#calculateiffalling)
- [calculateIfLanding](#calculateiflanding)
- [new](#new)
- [updateAsCurrent](#updateascurrent)

### calculateDesiredHorizontalVelocity

**Description**

> Calculates the desired horizontal velocity in metres per second.

**Definition**

> calculateDesiredHorizontalVelocity(float directionX, float directionZ)

**Arguments**

| float | directionX | The direction on the x axis to use. |
|-------|------------|-------------------------------------|
| float | directionZ | The direction on the z axis to use. |

**Return Values**

| float | x | The desired x. |
|-------|---|----------------|
| float | z | The desired z. |

**Code**

```lua
function PlayerStateFall:calculateDesiredHorizontalVelocity(directionX, directionZ)

    -- Calculate the direction, then the desired speed.
    local maximumMoveSpeed = self.player.toggleSuperSpeedCommand.value and PlayerStateFall.MAXIMUM_MOVE_SPEED * 8 or PlayerStateFall.MAXIMUM_MOVE_SPEED
    return directionX * maximumMoveSpeed, directionZ * maximumMoveSpeed
end

```

### calculateIfFalling

**Description**

> Calculates if the player has been falling for long enough to count as falling and is not submerged in water.

**Definition**

> calculateIfFalling()

**Return Values**

| float | isFalling | True if stateMachine.states.swimming:calculateIfSubmerged() is false and player.mover.currentFallTime is greater than or equal to FALL_TIME_THRESHOLD; otherwise false. |
|-------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateFall:calculateIfFalling()
    return not self.stateMachine.states.swimming:calculateIfSubmerged()
    and self.player.mover.currentFallTime > = PlayerStateFall.FALL_TIME_THRESHOLD
end

```

### calculateIfLanding

**Description**

> Calculates if the player is close enough to the ground to count as landing.

**Definition**

> calculateIfLanding()

**Return Values**

| float | isLanding | True if player.mover.currentGroundDistance is less than or equal to GROUND_LANDING_DISTANCE; otherwise false. |
|-------|-----------|---------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateFall:calculateIfLanding()
    return self.player.mover.currentGroundDistance < = PlayerStateFall.GROUND_LANDING_DISTANCE
end

```

### new

**Description**

> Creates a state with the given player and managing state machine.

**Definition**

> new(Player player, StateMachine stateMachine)

**Arguments**

| Player       | player       | The player who owns this state.        |
|--------------|--------------|----------------------------------------|
| StateMachine | stateMachine | The state machine managing this state. |

**Return Values**

| StateMachine | instance | The created instance. |
|--------------|----------|-----------------------|

**Code**

```lua
function PlayerStateFall.new(player, stateMachine)

    -- Create the instance, set the player, then return the instance.
    local self = BaseStateMachineState.new(stateMachine, PlayerStateFall _mt)
    self.player = player
    return self
end

```

### updateAsCurrent

**Description**

> Updates this state when it is currently the state machine's current state. Calls stateMachine:determineState() when
> calculateIfShouldBeForced() returns false.

**Definition**

> updateAsCurrent(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerStateFall:updateAsCurrent(dt)
    if not self:calculateIfShouldBeForced() then
        self.stateMachine:determineState()
    end
end

```