## PlayerStateSwim

**Description**

> The state used for the player moving or being still on foot while deep enough in water.

**Parent**

> [BaseStateMachineState](?version=script&category=80&class=847)

**Functions**

- [calculateDesiredHorizontalVelocity](#calculatedesiredhorizontalvelocity)
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
function PlayerStateSwim:calculateDesiredHorizontalVelocity(directionX, directionZ)

    -- Calculate the speed to use then return it as a velocity vector.
    local speed = self:calculateDesiredSpeed()
    return directionX * speed, directionZ * speed
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
function PlayerStateSwim.new(player, stateMachine)

    -- Create the instance, set the player, then return the instance.
    local self = BaseStateMachineState.new(stateMachine, PlayerStateSwim _mt)
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
function PlayerStateSwim:updateAsCurrent(dt)
    if not self:calculateIfShouldBeForced() then
        self.stateMachine:determineState()
    end
end

```