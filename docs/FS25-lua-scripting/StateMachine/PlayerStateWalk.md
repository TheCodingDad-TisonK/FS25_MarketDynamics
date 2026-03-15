## PlayerStateWalk

**Description**

> The state used for the player moving on foot.

**Parent**

> [BaseStateMachineState](?version=script&category=80&class=848)

**Functions**

- [calculateDesiredHorizontalVelocity](#calculatedesiredhorizontalvelocity)
- [calculateIfRunning](#calculateifrunning)
- [calculateIfValidEntryState](#calculateifvalidentrystate)
- [calculateIfWalking](#calculateifwalking)
- [createTransitions](#createtransitions)
- [new](#new)

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
function PlayerStateWalk:calculateDesiredHorizontalVelocity(directionX, directionZ)

    -- Calculate the speed to use then return it as a velocity vector.
    local speed = self:calculateDesiredSpeed()
    return directionX * speed, directionZ * speed
end

```

### calculateIfRunning

**Description**

> Calculates if the player's inputs allow them to run.

**Definition**

> calculateIfRunning()

**Return Values**

| float | isRunning | True if the player has movement inputs, is holding the run button, and is not holding the crouch button; otherwise false. |
|-------|-----------|---------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateWalk:calculateIfRunning()
    local runMultiplier = self.player:getRunMultiplier()
    return self:calculateIfMoving() and self.runAxis > 0.0 and runMultiplier > 0
end

```

### calculateIfValidEntryState

**Description**

> Calculates if this state is a valid state to enter back in on after a forced state.

**Definition**

> calculateIfValidEntryState()

**Return Values**

| float | isValid | True if calculateIfWalking is true, the player is grounded, and stateMachine.states.swimming:calculateIfSubmerged() is true; otherwise false. |
|-------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateWalk:calculateIfValidEntryState()
    return self:calculateIfMoving() and self.player.mover.isGrounded and not self.stateMachine.states.swimming:calculateIfSubmerged()
end

```

### calculateIfWalking

**Description**

> Calculates if the player's inputs allow them to walk.

**Definition**

> calculateIfWalking()

**Return Values**

| float | isRunning | True if the player has movement inputs, is not holding the run button, and is not holding the crouch button; otherwise false. |
|-------|-----------|-------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateWalk:calculateIfWalking()
    return self:calculateIfMoving() and self.runAxis = = 0.0
end

```

### createTransitions

**Description**

> Called just after the creation of all states, so that other states can be used to create transitions.

**Definition**

> createTransitions()

**Code**

```lua
function PlayerStateWalk:createTransitions()

    self:addTransition( self.stateMachine.states.idle.calculateIfIdle, self.stateMachine.states.idle)
    self:addTransition( self.stateMachine.states.jumping.calculateIfJumping, self.stateMachine.states.jumping)
    self:addTransition( self.stateMachine.states.crouching.calculateIfCrouching, self.stateMachine.states.crouching)
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
function PlayerStateWalk.new(player, stateMachine)

    -- Create the instance, set the player, then return the instance.
    local self = BaseStateMachineState.new(stateMachine, PlayerStateWalk _mt)

    self.player = player

    self.walkAxis = 0
    self.runAxis = 0

    return self
end

```