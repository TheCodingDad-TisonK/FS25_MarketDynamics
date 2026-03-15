## DebugSphere

**Parent**

> [DebugElement](?version=script&category=21&class=211)

**Functions**

- [draw](#draw)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugSphere:draw()
    DebugSphere.renderAtPosition(
    self.x, self.y, self.z,
    self.radius,
    self.color,
    self.numSegments,
    self.solid,
    self.alignToGround,
    self.text,
    self.textSize
    )
end

```