## DebugCylinder

**Parent**

> [DebugElement](?version=script&category=21&class=198)

**Functions**

- [draw](#draw)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugCylinder:draw()
    DebugCylinder.renderAtPosition(
    self.x, self.y, self.z,
    self.radius,
    self.height,
    self.axis,
    self.color,
    self.numSegments,
    self.solid,
    self.alignToGround,
    self.text
    )
end

```