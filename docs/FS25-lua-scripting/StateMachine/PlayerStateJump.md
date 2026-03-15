## PlayerStateJump

**Description**

> The state used for the player being in the air after jumping, not long enough to be considered falling.

**Parent**

> [BaseStateMachineState](?version=script&category=80&class=845)

**Functions**

- [calculateDesiredHorizontalVelocity](#calculatedesiredhorizontalvelocity)
- [calculateIfFalling](#calculateiffalling)
- [calculateIfJumping](#calculateifjumping)
- [calculateIfLanding](#calculateiflanding)
- [calculateIfTakingOff](#calculateiftakingoff)
- [createTransitions](#createtransitions)
- [new](#new)
- [onStateEntered](#onstateentered)
- [onStateExited](#onstateexited)
- [resetTimers](#resettimers)
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
function PlayerStateJump:calculateDesiredHorizontalVelocity(directionX, directionZ)

    -- Calculate the direction, then the desired speed.
    local maximumMovepeed = self.player.toggleSuperSpeedCommand.value and PlayerStateJump.MAXIMUM_MOVE_SPEED * 8 or PlayerStateJump.MAXIMUM_MOVE_SPEED
    local speed = self.player.mover:calculateSmoothSpeed( self.player.inputComponent.walkAxis, false , 0 , maximumMovepeed)
    return directionX * speed, directionZ * speed
end

```

### calculateIfFalling

**Description**

> Calculates if the player has been falling for long enough to transition into the falling state. This is different than
> the regular time to start falling, to prevent the player from entering the falling state during a jump.

**Definition**

> calculateIfFalling()

**Return Values**

| float | isFalling | True if timeSpentFallingDown is greater than or equal to FALL_TIME_THRESHOLD; otherwise false. |
|-------|-----------|------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateJump:calculateIfFalling()
    return self.timeSpentFallingDown > = self.FALL_TIME_THRESHOLD
end

```

### calculateIfJumping

**Description**

> Calculates if the player is pressing the jump button.

**Definition**

> calculateIfJumping()

**Return Values**

| float | isJumping | True if player.inputComponent.jumpPower is over 0.0; otherwise false. |
|-------|-----------|-----------------------------------------------------------------------|

**Code**

```lua
function PlayerStateJump:calculateIfJumping()
    if self.player.isOwner then
        return( self.player.inputComponent.jumpPower * self.player:getJumpMultiplier()) > 0.0 and self.player.mover.currentGroundTime > = PlayerStateJump.MINIMUM_GROUND_TIME_THRESHOLD
    else
            return self.player.mover.currentVelocityY > 0.0 and self.player.mover.currentGroundTime > = PlayerStateJump.MINIMUM_GROUND_TIME_THRESHOLD
        end
    end

```

### calculateIfLanding

**Description**

> Calculates if the player is about to land on the ground after a jump.

**Definition**

> calculateIfLanding()

**Return Values**

| float | isLanding | True if player.mover.currentGroundDistance is less than or equal to GROUND_LANDING_DISTANCE and calculateIfTakingOff() is false; otherwise false. |
|-------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateJump:calculateIfLanding()
    return self.player.mover.currentGroundDistance < = self.GROUND_LANDING_DISTANCE and not self:calculateIfTakingOff()
end

```

### calculateIfTakingOff

**Description**

> Calculates if the player is still in the early part of the jump.

**Definition**

> calculateIfTakingOff()

**Return Values**

| float | isTakingOff | True if timeSpentJumping is less than or equal to JUMP_TIME_THRESHOLD and player.mover.currentLocalVelocity is less than or equal to 0; otherwise false. |
|-------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateJump:calculateIfTakingOff()
    return self.timeSpentJumping < = self.JUMP_TIME_THRESHOLD and self.player.mover.currentVelocityY > 0.0
end

```

### createTransitions

**Description**

> Called just after the creation of all states, so that other states can be used to create transitions.

**Definition**

> createTransitions()

**Code**

```lua
function PlayerStateJump:createTransitions()

    self:addTransition( self.calculateIfFalling, self.stateMachine.states.falling, self )
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
function PlayerStateJump.new(player, stateMachine)

    -- Create the instance and set the player.
    local self = BaseStateMachineState.new(stateMachine, PlayerStateJump _mt)
    self.player = player

    -- The timer for how long the player has been falling after reaching the top of their jump.
        self.timeSpentFallingDown = 0.0

        -- The timer for how long the player has been jumping
            self.timeSpentJumping = 0.0

            -- Return the created instance.
            return self
        end

```

### onStateEntered

**Description**

> Fired when this state is entered.

**Definition**

> onStateEntered(PlayerStateBase previousState)

**Arguments**

| PlayerStateBase | previousState | The previous state the machine was in before entering this one. |
|-----------------|---------------|-----------------------------------------------------------------|

**Code**

```lua
function PlayerStateJump:onStateEntered(previousState)

    -- Set the up force and velocity.
    self.player.mover.currentVelocityY = PlayerStateJump.JUMP_UPFORCE * self.player:getJumpMultiplier()

    -- Reset the timers.
    self:resetTimers()
end

```

### onStateExited

**Description**

> Fired when this state is exited.

**Definition**

> onStateExited(BaseStateMachineState previousState)

**Arguments**

| BaseStateMachineState | previousState | The state the machine will be in after exiting this one. |
|-----------------------|---------------|----------------------------------------------------------|

**Code**

```lua
function PlayerStateJump:onStateExited(previousState)

    -- Reset the up force.
    self.player.mover.currentUpForce = 0.0

    -- Reset the timers.
    self:resetTimers()
end

```

### resetTimers

**Description**

> Resets all jumping related timers.

**Definition**

> resetTimers()

**Code**

```lua
function PlayerStateJump:resetTimers()

    -- Reset the timers.
    self.timeSpentFallingDown = 0.0
    self.timeSpentJumping = 0.0
end

```

### updateAsCurrent

**Description**

> Updates this state when it is currently the state machine's current state.

**Definition**

> updateAsCurrent(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function PlayerStateJump:updateAsCurrent(dt)

    -- If the player is falling downwards, increment the downwards falling counter.This means that the jump upwards does not count as falling.
    if self.player.mover.currentVelocityY < 0 then
        self.timeSpentFallingDown = self.timeSpentFallingDown + (dt * 0.001 )
    end

    -- Update the jump timer.
    self.timeSpentJumping = self.timeSpentJumping + (dt * 0.001 )

    -- If the player is grounded again, determine the new state.
    if self.player.mover.isGrounded and not self:calculateIfTakingOff() then
        self.stateMachine:determineState()
        return
    end

    -- Go through the transitions and see if any are valid.
        self:trySwitchToValidTransition()
    end

```