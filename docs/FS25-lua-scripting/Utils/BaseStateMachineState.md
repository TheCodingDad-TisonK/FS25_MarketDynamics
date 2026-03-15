## BaseStateMachineState

**Description**

> A base, abstract state to be used with an implementation of the StateMachine class.

**Functions**

- [addTransition](#addtransition)
- [caclulateDebugScreenBounds](#caclulatedebugscreenbounds)
- [calculateIfShouldBeForced](#calculateifshouldbeforced)
- [calculateIfValidEntryState](#calculateifvalidentrystate)
- [createTransitions](#createtransitions)
- [debugDraw](#debugdraw)
- [new](#new)
- [onStateEntered](#onstateentered)
- [onStateExited](#onstateexited)
- [trySwitchToValidTransition](#tryswitchtovalidtransition)
- [updateAsCurrent](#updateascurrent)
- [updateAsInactive](#updateasinactive)

### addTransition

**Description**

> Adds a transition to the given targetState whenever the given condition is true.

**Definition**

> addTransition(function conditionFunction, BaseStateMachineState targetState, table contextObject)

**Arguments**

| function              | conditionFunction | The condition function that must return true for the target state to be switched to.                              |
|-----------------------|-------------------|-------------------------------------------------------------------------------------------------------------------|
| BaseStateMachineState | targetState       | The state that will be transitioned to if the condition is true.                                                  |
| table                 | contextObject     | The object used as the context to fire the condition function, if this is nil then the given targetState is used. |

**Code**

```lua
function BaseStateMachineState:addTransition(conditionFunction, targetState, contextObject)

    --#debug Assert.isType(conditionFunction, "function", "Transition must have a valid condition function!")
        --#debug Assert.isClass(targetState, BaseStateMachineState, "Transition's target state must inherit from BaseStateMachineState!")

        -- Add the transition object to the transitions table.
        self.transitions[targetState] = { context = contextObject or targetState, conditionFunction = conditionFunction }
        return self.transitions[targetState]
    end

```

### caclulateDebugScreenBounds

**Description**

> Calculates the bounds in screen-space of the debug draw.

**Definition**

> caclulateDebugScreenBounds(float x, float y, float width, float height)

**Arguments**

| float | x      | The x position on the screen to begin drawing the values.  |
|-------|--------|------------------------------------------------------------|
| float | y      | The y position on the screen to begin drawing the values.  |
| float | width  | The total width of the whole state machine on the screen.  |
| float | height | The total height of the whole state machine on the screen. |

**Code**

```lua
function BaseStateMachineState:caclulateDebugScreenBounds(x, y, width, height)

    -- No drawing can happen if there are no debug bound properties.
        if self.debugPositionX = = nil or self.debugPositionY = = nil or self.debugWidth = = nil or self.debugHeight = = nil then
            return nil , nil , nil , nil
        end

        return x + ( self.debugPositionX * width), y + ( self.debugPositionY * height), self.debugWidth * width, self.debugHeight * height
    end

```

### calculateIfShouldBeForced

**Description**

> Calculates if this state should be forced as the current state.

**Definition**

> calculateIfShouldBeForced()

**Return Values**

| float | isValid | True if this state is valid and can be forced to be made current; otherwise false. False by default. |
|-------|---------|------------------------------------------------------------------------------------------------------|

**Code**

```lua
function BaseStateMachineState:calculateIfShouldBeForced()
    return false
end

```

### calculateIfValidEntryState

**Description**

> Calculates if this state is a valid state to enter back in on after a forced state.

**Definition**

> calculateIfValidEntryState()

**Return Values**

| float | isValid | True if this state is valid and can be made current; otherwise false. False by default. |
|-------|---------|-----------------------------------------------------------------------------------------|

**Code**

```lua
function BaseStateMachineState:calculateIfValidEntryState()
    return false
end

```

### createTransitions

**Description**

> Called just after the creation of all states, so that other states can be used to create transitions.

**Definition**

> createTransitions()

**Code**

```lua
function BaseStateMachineState:createTransitions()

end

```

### debugDraw

**Description**

> Draws debug information for this state.

**Definition**

> debugDraw(float x, float y, float width, float height, float textSize, )

**Arguments**

| float | x        | The x position on the screen to begin drawing the values.  |
|-------|----------|------------------------------------------------------------|
| float | y        | The y position on the screen to begin drawing the values.  |
| float | width    | The total width of the whole state machine on the screen.  |
| float | height   | The total height of the whole state machine on the screen. |
| float | textSize | The height of the text.                                    |
| any   | color    |                                                            |

**Code**

```lua
function BaseStateMachineState:debugDraw(x, y, width, height, textSize, color)

    local frameX, frameY, frameWidth, frameHeight = self:caclulateDebugScreenBounds(x, y, width, height)
    if frameX = = nil then
        return nil , nil , nil , nil
    end

    if color = = nil then
        color = self.stateMachine.currentState = = self and Color.PRESETS.GREEN or Color.PRESETS.GRAY
    end

    drawFilledRect(frameX, frameY, frameWidth, frameHeight, color:unpack())

    return frameX, frameY, frameWidth, frameHeight
end

```

### new

**Description**

> Creates a base state machine state. This should only be done within a derived class, as this is an abstract class.

**Definition**

> new(StateMachine stateMachine, table custom\_mt)

**Arguments**

| StateMachine | stateMachine | The state machine that manages this state. |
|--------------|--------------|--------------------------------------------|
| table        | custom_mt    | The derived metatable to use.              |

**Return Values**

| table | instance | The created instance. |
|-------|----------|-----------------------|

**Code**

```lua
function BaseStateMachineState.new(stateMachine, custom_mt)

    -- Create the instance.
    local self = setmetatable( { } , custom_mt or BaseStateMachineState _mt)

    -- Set the state machine.
    self.stateMachine = stateMachine

    -- Create the transitions table.
    self.transitions = { }

    -- The bounds of the state when debug-drawn to the screen.
    self.debugPositionX = nil
    self.debugPositionY = nil
    self.debugWidth = nil
    self.debugHeight = nil

    -- Return the created instance.
    return self
end

```

### onStateEntered

**Description**

> Fired when this state is entered.

**Definition**

> onStateEntered(BaseStateMachineState previousState)

**Arguments**

| BaseStateMachineState | previousState | The previous state the machine was in before entering this one. |
|-----------------------|---------------|-----------------------------------------------------------------|

**Code**

```lua
function BaseStateMachineState:onStateEntered(previousState)

end

```

### onStateExited

**Description**

> Fired when this state is exited.

**Definition**

> onStateExited(BaseStateMachineState nextState)

**Arguments**

| BaseStateMachineState | nextState | The state the machine will be in after exiting this one. |
|-----------------------|-----------|----------------------------------------------------------|

**Code**

```lua
function BaseStateMachineState:onStateExited(nextState)

end

```

### trySwitchToValidTransition

**Description**

> Goes through each transition and runs the condition function. The first function that returns true will cause the
> state machine to switch to the associated state, and the state will be returned.

**Definition**

> trySwitchToValidTransition()

**Return Values**

| BaseStateMachineState | newState | The state whose associated condition function returned true, and was successfully switched to in the state machine; otherwise nil. |
|-----------------------|----------|------------------------------------------------------------------------------------------------------------------------------------|

**Code**

```lua
function BaseStateMachineState:trySwitchToValidTransition()

    -- Go over each transition pair and check for validity.
        for state, binding in pairs( self.transitions) do

            -- If the condition passes, switch the state machine's current state to the state, if it successfully changes then return the state.
                if binding.conditionFunction(binding.context) then
                    self.stateMachine:changeState(state)
                    return state
                end
            end

            -- If no state was switched to, return nil.
            return nil
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
function BaseStateMachineState:updateAsCurrent(dt)

    -- Do nothing if the state machine is passive.
        if self.stateMachine:getIsPassive() then
            return
        end

        -- Go through the transitions and see if any are valid.
            self:trySwitchToValidTransition()
        end

```

### updateAsInactive

**Description**

> Updates this state when it is currently NOT the state machine's current state.

**Definition**

> updateAsInactive(float dt)

**Arguments**

| float | dt | Delta time in ms. |
|-------|----|-------------------|

**Code**

```lua
function BaseStateMachineState:updateAsInactive(dt)

end

```