## DebugPoint

**Parent**

> [DebugElement](?version=script&category=21&class=208)

**Functions**

- [draw](#draw)
- [new](#new)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugPoint:draw()
    DebugPoint.renderAtPosition( self.x, self.y, self.z, self.color, self.solid, self.text, self.textSize, self.clipDistance, self.textClipDistance)
end

```

### new

**Description**

> new

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
function DebugPoint.new(customMt)
    local self = DebugPoint:superClass().new(customMt or DebugPoint _mt)

    self.solid = false

    self.alignToGround = false

    self.text = nil

    return self
end

```