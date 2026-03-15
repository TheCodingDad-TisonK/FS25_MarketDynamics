## ValueInterpolator

**Description**

> Class to interpolate between values

**Functions**

- [delete](#delete)
- [getTarget](#gettarget)
- [hasInterpolator](#hasinterpolator)
- [new](#new)
- [onDeleteParent](#ondeleteparent)
- [removeInterpolator](#removeinterpolator)
- [setDeleteListenerObject](#setdeletelistenerobject)
- [setFinishedFunc](#setfinishedfunc)
- [setUpdateFunc](#setupdatefunc)
- [update](#update)
- [updateSpeed](#updatespeed)

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function ValueInterpolator:delete()
end

```

### getTarget

**Description**

**Definition**

> getTarget()

**Code**

```lua
function ValueInterpolator:getTarget()
    return self.target
end

```

### hasInterpolator

**Description**

**Definition**

> hasInterpolator()

**Arguments**

| any | key |
|-----|-----|

**Code**

```lua
function ValueInterpolator.hasInterpolator(key)
    return g_currentMission:getHasUpdateable(key)
end

```

### new

**Description**

**Definition**

> new(any customKey, function get, function set, array target, float? duration, float? speed, table? customMt)

**Arguments**

| any      | customKey | custom key used for the updateable added to the mission |
|----------|-----------|---------------------------------------------------------|
| function | get       |                                                         |
| function | set       |                                                         |
| array    | target    | list of values to interpolate                           |
| float?   | duration  |                                                         |
| float?   | speed     | default: 1                                              |
| table?   | customMt  |                                                         |

**Return Values**

| table? | ValueInterpolator | can be nil if validation check fails |
|--------|-------------------|--------------------------------------|

**Code**

```lua
function ValueInterpolator.new(customKey, get, set, target, duration, speed, customMt)
    local self = setmetatable( { } , customMt or ValueInterpolator _mt)

    self.customKey = customKey

    self.get = get
    self.set = set

    self.target = target
    self.duration = duration

    self.cur = { get() }

    if self.duration ~ = nil then
        self:updateSpeed()
    else
            speed = (speed or 1 ) / 1000
            self.speed = { }
            for i = 1 , # self.target do
                self.speed[i] = speed
            end
        end

        local isValid = false
        for i = 1 , # self.speed do
            if math.abs( self.speed[i]) > 0.000000001 then
                isValid = true
                break
            end
        end

        if not isValid then
            return nil
        end

        g_currentMission:addUpdateable( self , customKey)

        return self
    end

```

### onDeleteParent

**Description**

**Definition**

> onDeleteParent()

**Code**

```lua
function ValueInterpolator:onDeleteParent()
    g_currentMission:removeUpdateable( self.customKey)
end

```

### removeInterpolator

**Description**

**Definition**

> removeInterpolator()

**Arguments**

| any | key |
|-----|-----|

**Code**

```lua
function ValueInterpolator.removeInterpolator(key)
    if g_currentMission:getHasUpdateable(key) then
        g_currentMission:removeUpdateable(key)
    end
end

```

### setDeleteListenerObject

**Description**

**Definition**

> setDeleteListenerObject()

**Arguments**

| any | object |
|-----|--------|

**Code**

```lua
function ValueInterpolator:setDeleteListenerObject(object)
    if object ~ = nil and object:isa(Object) then
        object:addDeleteListener( self , "onDeleteParent" )
        self.deleteListenerObject = object
    end
end

```

### setFinishedFunc

**Description**

**Definition**

> setFinishedFunc()

**Arguments**

| any | finishedFunc   |
|-----|----------------|
| any | finishedTarget |
| any | ...            |

**Code**

```lua
function ValueInterpolator:setFinishedFunc(finishedFunc, finishedTarget, .. .)
    self.finishedFunc = finishedFunc
    self.finishedTarget = finishedTarget
    self.finishedArgs = { .. . }
end

```

### setUpdateFunc

**Description**

**Definition**

> setUpdateFunc()

**Arguments**

| any | updateFunc   |
|-----|--------------|
| any | updateTarget |
| any | ...          |

**Code**

```lua
function ValueInterpolator:setUpdateFunc(updateFunc, updateTarget, .. .)
    self.updateFunc = updateFunc
    self.updateTarget = updateTarget
    self.updateArgs = { .. . }
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function ValueInterpolator:update(dt)
    local finished = true
    for i = 1 , # self.cur do
        local direction = math.sign( self.target[i] - self.cur[i])
        local limitFunc = math.min
        if direction < 0 then
            limitFunc = math.max
        end
        self.cur[i] = limitFunc( self.cur[i] + self.speed[i] * dt * direction, self.target[i])

        finished = finished and self.cur[i] = = self.target[i]
    end

    self.set( unpack( self.cur))

    if self.updateFunc ~ = nil then
        self.updateFunc( self.updateTarget, unpack( self.updateArgs))
    end

    if self.duration ~ = nil then
        self.duration = math.max( self.duration - dt, 1 )
    end

    if finished then
        g_currentMission:removeUpdateable( self.customKey)

        if self.deleteListenerObject ~ = nil then
            self.deleteListenerObject:removeDeleteListener( "onDeleteParent" )
        end

        if self.finishedFunc ~ = nil then
            self.finishedFunc( self.finishedTarget, unpack( self.finishedArgs))
        end
    end
end

```

### updateSpeed

**Description**

**Definition**

> updateSpeed()

**Code**

```lua
function ValueInterpolator:updateSpeed()
    if type( self.duration) = = "number" then
        self.speed = { }
        for i = 1 , # self.target do
            self.speed[i] = math.abs( self.target[i] - self.cur[i]) / self.duration
        end
    else
            self.speed = self.duration
        end
    end

```