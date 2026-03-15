## TweenSequence

**Description**

> Allows setting up more complex tweening by defining sequences of tweens, intervals and callbacks. A sequence is
> itself a Tween, so you may even define and add sub-sequences.
> Before a sequence reacts to update() calls, it must be started with start(). This also applies after resetting.
> Adding tweens, callbacks and intervals will append them to the current sequence. Insertion of tweens and callbacks
> will insert them at the given relative instants, allowing for overlapping tweens and arbitrary callback times.
> Inserting an interval will push pack all later instants by the given time.

**Parent**

> [Tween](?version=script&category=43&class=510)

**Functions**

- [addCallback](#addcallback)
- [addInterval](#addinterval)
- [addTween](#addtween)
- [getDuration](#getduration)
- [insertCallback](#insertcallback)
- [insertInterval](#insertinterval)
- [insertTween](#inserttween)
- [new](#new)
- [reset](#reset)
- [setLooping](#setlooping)
- [setTarget](#settarget)
- [start](#start)
- [stop](#stop)
- [update](#update)
- [updateCallbacks](#updatecallbacks)
- [updateTweens](#updatetweens)

### addCallback

**Description**

> Add a callback at the end of the sequence.

**Definition**

> addCallback(function callback, table callbackState)

**Arguments**

| function | callback      | Callback function with signature of either callback(target, value) or callback(value)               |
|----------|---------------|-----------------------------------------------------------------------------------------------------|
| table    | callbackState | Any value which is passed to the callback as its first (no target) or second (with target) argument |

**Code**

```lua
function TweenSequence:addCallback(callback, callbackState)
    self:insertCallback(callback, callbackState, self.totalDuration)
end

```

### addInterval

**Description**

> Add an interval at the end of the sequence.
> Use this to add a pause to the sequence.

**Definition**

> addInterval()

**Arguments**

| any | interval |
|-----|----------|

**Code**

```lua
function TweenSequence:addInterval(interval)
    self:insertInterval(interval, self.totalDuration)
end

```

### addTween

**Description**

> Add a tween to the end of the sequence.

**Definition**

> addTween(table tween)

**Arguments**

| table | tween | Tween instance |
|-------|-------|----------------|

**Code**

```lua
function TweenSequence:addTween(tween)
    self:insertTween(tween, self.totalDuration)
end

```

### getDuration

**Description**

> Get this tween's duration in milliseconds.

**Definition**

> getDuration()

**Code**

```lua
function TweenSequence:getDuration()
    return self.totalDuration
end

```

### insertCallback

**Description**

> Insert a callback at the given instant.

**Definition**

> insertCallback(function callback, table callbackState, float instant)

**Arguments**

| function | callback      | Callback function with signature of either callback(target, value) or callback(value)               |
|----------|---------------|-----------------------------------------------------------------------------------------------------|
| table    | callbackState | Any value which is passed to the callback as its first (no target) or second (with target) argument |
| float    | instant       | Time in milliseconds after sequence start                                                           |

**Code**

```lua
function TweenSequence:insertCallback(callback, callbackState, instant)
    self.callbackInstants[callback] = instant
    self.callbackStates[callback] = callbackState
    self.callbacksCalled[callback] = false
end

```

### insertInterval

**Description**

> Insert an interval at the given instant.
> This will push back all later instants by the interval. Use this to insert pauses into the sequence.

**Definition**

> insertInterval(float interval, float instant)

**Arguments**

| float | interval | Interval time in milliseconds             |
|-------|----------|-------------------------------------------|
| float | instant  | Time in milliseconds after sequence start |

**Code**

```lua
function TweenSequence:insertInterval(interval, instant)
    for tween, range in pairs( self.tweenUpdateRanges) do
        local tweenStartInstant, tweenEndInstant = range[ 1 ], range[ 2 ]
        if tweenStartInstant > = instant then
            self.tweenUpdateRanges[tween][ 1 ] = tweenStartInstant + interval
            self.tweenUpdateRanges[tween][ 2 ] = tweenEndInstant + interval
        end
    end

    for callback, callbackInstant in pairs( self.callbackInstants) do
        if callbackInstant > = instant then
            self.callbackInstants[callback] = callbackInstant + interval
        end
    end

    self.totalDuration = self.totalDuration + interval
end

```

### insertTween

**Description**

> Insert a tween at a given instant.

**Definition**

> insertTween(table tween, float instant)

**Arguments**

| table | tween   | Tween instance                            |
|-------|---------|-------------------------------------------|
| float | instant | Time in milliseconds after sequence start |

**Code**

```lua
function TweenSequence:insertTween(tween, instant)
    self.tweenUpdateRanges[tween] = { instant, instant + tween:getDuration() }

    self.totalDuration = math.max(instant + tween:getDuration(), self.totalDuration)

    if self.functionTarget ~ = nil then
        tween:setTarget( self.functionTarget)
    end
end

```

### new

**Description**

> Create a new TweenSequence.

**Definition**

> new(table? functionTarget)

**Arguments**

| table? | functionTarget | [optional] Target table which is supplied by default to all tween setter functions and
callbacks as the first argument. If not specified, the setters and callbacks will be called with one value only. |
| Type | Parameter |
| |

**Code**

```lua
function TweenSequence.new(functionTarget)
    local self = Tween.new( nil , nil , nil , nil , TweenSequence _mt)

    self.functionTarget = functionTarget
    self.callbackStates = { } -- callback -> callback state
    self.callbacksCalled = { } -- callback -> bool

    self.tweenUpdateRanges = { } -- tween -> {startInstant, endInstant}
    self.callbackInstants = { } -- callback -> instant

    self.isLooping = false
    self.totalDuration = 0
    self.isFinished = true

    return self
end

```

### reset

**Description**

> Reset the sequence to its initial state.

**Definition**

> reset()

**Code**

```lua
function TweenSequence:reset()
    self.elapsedTime = 0
    self.isFinished = true

    for tween in pairs( self.tweenUpdateRanges) do
        tween:reset()
    end

    for callback in pairs( self.callbacksCalled) do
        self.callbacksCalled[callback] = false
    end
end

```

### setLooping

**Description**

> Set the looping state for this sequence.

**Definition**

> setLooping(boolean isLooping)

**Arguments**

| boolean | isLooping | If true, will restart the sequence when finished, including callbacks! |
|---------|-----------|------------------------------------------------------------------------|

**Code**

```lua
function TweenSequence:setLooping(isLooping)
    self.isLooping = isLooping
end

```

### setTarget

**Description**

> Set a callback target for this tween.
> If a target has been set, the setter function must support receiving the target as its first argument.

**Definition**

> setTarget()

**Arguments**

| any | target |
|-----|--------|

**Code**

```lua
function TweenSequence:setTarget(target)
    self.functionTarget = target
end

```

### start

**Description**

> Start the sequence.
> A sequence will only update its state when it has been started.

**Definition**

> start()

**Code**

```lua
function TweenSequence:start()
    self.isFinished = false
end

```

### stop

**Description**

> Stop the sequence.

**Definition**

> stop()

**Code**

```lua
function TweenSequence:stop()
    self.isFinished = true
end

```

### update

**Description**

> Update the sequence state over time.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function TweenSequence:update(dt)
    if not self.isFinished then
        local lastUpdateInstant = self.elapsedTime
        self.elapsedTime = self.elapsedTime + dt

        local allFinished = self:updateTweens(lastUpdateInstant, dt)
        self:updateCallbacks()

        if self.elapsedTime > = self.totalDuration and allFinished then
            if self.isLooping then
                self:reset()
                self:start()
            else
                    self.isFinished = true
                end
            end
        end
    end

```

### updateCallbacks

**Description**

> Update callback states.

**Definition**

> updateCallbacks()

**Code**

```lua
function TweenSequence:updateCallbacks()
    for callback, instant in pairs( self.callbackInstants) do
        if not self.callbacksCalled[callback] and instant < = self.elapsedTime then
            if self.functionTarget ~ = nil then
                callback( self.functionTarget, self.callbackStates[callback])
            else
                    callback( self.callbackStates[callback])
                end

                self.callbacksCalled[callback] = true
            end
        end
    end

```

### updateTweens

**Description**

> Update active sequence tweens.

**Definition**

> updateTweens(float lastInstant, float dt)

**Arguments**

| float | lastInstant | Last instant which received an update |
|-------|-------------|---------------------------------------|
| float | dt          | Delta time                            |

**Code**

```lua
function TweenSequence:updateTweens(lastInstant, dt)
    local allFinished = true

    for tween, range in pairs( self.tweenUpdateRanges) do
        local tweenStart = range[ 1 ]
        if not tween:getFinished() and self.elapsedTime > = tweenStart then
            local maxDt = math.min( self.elapsedTime - tweenStart, dt)
            tween:update(maxDt)
            allFinished = allFinished and tween:getFinished()
        end
    end

    return allFinished
end

```