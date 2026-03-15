## Tween

**Description**

> Tween class which linearly interpolates a quantity from a start value to an end value over a given duration.

**Functions**

- [applyValue](#applyvalue)
- [getDuration](#getduration)
- [getFinished](#getfinished)
- [new](#new)
- [reset](#reset)
- [setCurve](#setcurve)
- [setTarget](#settarget)
- [tweenValue](#tweenvalue)
- [update](#update)

### applyValue

**Description**

> Apply a value via the setter function.

**Definition**

> applyValue()

**Arguments**

| any | newValue |
|-----|----------|

**Code**

```lua
function Tween:applyValue(newValue)
    if self.functionTarget ~ = nil then
        self.setter( self.functionTarget, newValue)
    else
            self.setter(newValue)
        end
    end

```

### getDuration

**Description**

> Get this tween's duration in milliseconds.

**Definition**

> getDuration()

**Code**

```lua
function Tween:getDuration()
    return self.duration
end

```

### getFinished

**Description**

> Check if this tween has finished.

**Definition**

> getFinished()

**Code**

```lua
function Tween:getFinished()
    return self.isFinished
end

```

### new

**Description**

> Create a new Tween.

**Definition**

> new(function setterFunction, float startValue, float endValue, float duration, table? customMt)

**Arguments**

| function | setterFunction | Value setter function. Signature: callback(value) or callback(target, value). |
|----------|----------------|-------------------------------------------------------------------------------|
| float    | startValue     | Original value                                                                |
| float    | endValue       | Target value                                                                  |
| float    | duration       | Duration of tween in milliseconds                                             |
| table?   | customMt       | Subclass metatable for inheritance                                            |

**Code**

```lua
function Tween.new(setterFunction, startValue, endValue, duration, customMt)
    local self = setmetatable( { } , customMt or Tween _mt)

    self.setter = setterFunction
    self.startValue = startValue
    self.endValue = endValue
    self.duration = duration
    self.elapsedTime = 0

    self.isFinished = duration = = 0
    self.functionTarget = nil

    self.curveFunc = Tween.CURVE.LINEAR

    return self
end

```

### reset

**Description**

> Reset this tween to play it again.

**Definition**

> reset()

**Code**

```lua
function Tween:reset()
    self.elapsedTime = 0
    self.isFinished = self.duration = = 0
end

```

### setCurve

**Description**

> Set the curve function. Defaults to Tween.CURVE.LINEAR

**Definition**

> setCurve()

**Arguments**

| any | func |
|-----|------|

**Code**

```lua
function Tween:setCurve(func)
    self.curveFunc = func or Tween.CURVE.LINEAR
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
function Tween:setTarget(target)
    self.functionTarget = target
end

```

### tweenValue

**Description**

> Get the current tween value.

**Definition**

> tweenValue()

**Arguments**

| any | t |
|-----|---|

**Code**

```lua
function Tween:tweenValue(t)
    return MathUtil.lerp( self.startValue, self.endValue, self.curveFunc(t))
end

```

### update

**Description**

> Update the tween's state.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function Tween:update(dt)
    if self.isFinished then
        return
    end

    self.elapsedTime = self.elapsedTime + dt

    local newValue
    if self.elapsedTime > = self.duration then
        self.isFinished = true
        newValue = self:tweenValue( 1 )
    else
            local t = self.elapsedTime / self.duration
            newValue = self:tweenValue(t)
        end

        self:applyValue(newValue)
    end

```