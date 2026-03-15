## PlayerStateIdle

**Description**

> The state used for the player standing still and doing nothing.

**Parent**

> [BaseStateMachineState](?version=script&category=80&class=844)

**Functions**

- [calculateIfIdle](#calculateifidle)
- [calculateIfValidEntryState](#calculateifvalidentrystate)
- [createTransitions](#createtransitions)
- [new](#new)

### calculateIfIdle

**Description**

> Calculates if the player has no movement inputs and is not crouching.

**Definition**

> calculateIfIdle()

**Return Values**

| any | isIdle | True if player.inputComponent.hasMovementInputs and stateMachine.states.crouching:calculateIfCrouching() are false; otherwise false. |
|-----|--------|--------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateIdle:calculateIfIdle()
    if self.player.isOwner then
        return self.player.mover:getSpeed() < = 0.01 and not self.player.inputComponent.hasMovementInputs and not self.stateMachine.states.crouching:calculateIfCrouching()
    else
            return self.player.mover:getSpeed() < = 0.01 and not self.stateMachine.states.crouching:calculateIfCrouching()
        end
    end

```

### calculateIfValidEntryState

**Description**

> Calculates if this state is a valid state to enter back in on after a forced state.

**Definition**

> calculateIfValidEntryState()

**Return Values**

| any | isValid | True if calculateIfIdle() and player.mover.isGrounded are true; otherwise false. |
|-----|---------|----------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStateIdle:calculateIfValidEntryState()
    return self:calculateIfIdle() and self.player.mover.isGrounded
end

```

### createTransitions

**Description**

> Called just after the creation of all states, so that other states can be used to create transitions.

**Definition**

> createTransitions()

**Code**

```lua
function PlayerStateIdle:createTransitions()

    self:addTransition( self.stateMachine.states.walking.calculateIfMoving, self.stateMachine.states.walking)
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
function PlayerStateIdle.new(player, stateMachine)

    -- Create the instance, set the player, then return the instance.
    local self = BaseStateMachineState.new(stateMachine, PlayerStateIdle _mt)
    self.player = player
    return self
end

```