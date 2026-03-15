## DebugPath

**Parent**

> [DebugElement](?version=script&category=21&class=206)

**Functions**

- [clear](#clear)
- [draw](#draw)
- [getShouldBeDrawn](#getshouldbedrawn)
- [new](#new)
- [setForcedY](#setforcedy)

### clear

**Description**

> Remove all points of the path

**Definition**

> clear()

**Return Values**

| any | self |
|-----|------|

**Code**

```lua
function DebugPath:clear()
    self.points = { }

    return self
end

```

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugPath:draw()
    DebugPath.renderPath( self.points, self.color, self.alignToGround, self.forcedY, self.solid, self.clipDistance, self.text)
end

```

### getShouldBeDrawn

**Description**

> dedicated function used by DebugManger to determine if draw() should be called or not

**Definition**

> getShouldBeDrawn()

**Return Values**

| any | shouldBeDrawn |
|-----|---------------|

**Code**

```lua
function DebugPath:getShouldBeDrawn()
    -- implements custom clipping itself
    return true
end

```

### new

**Description**

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function DebugPath.new(customMt)
    local self = DebugPath:superClass().new(customMt or DebugPath _mt)

    self.points = { }
    self.alignToGround = false
    self.minimumDistanceBetweenPoints = nil
    self.solid = true

    -- TODO:add option to reduce number of rendered points(after addition/without removing points) e.g.only render every other one

    return self
end

```

### setForcedY

**Description**

**Definition**

> setForcedY(float forcedY)

**Arguments**

| float | forcedY | set a fix world y height for drawing the path, use nil to unset |
|-------|---------|-----------------------------------------------------------------|

**Return Values**

| float | self |
|-------|------|

**Code**

```lua
function DebugPath:setForcedY(forcedY)

    --#debug Assert.isType(forcedY, "number")

    self.forcedY = forcedY

    return self
end

```