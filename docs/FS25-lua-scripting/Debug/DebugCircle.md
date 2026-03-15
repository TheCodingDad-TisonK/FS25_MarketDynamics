## DebugCircle

**Parent**

> [DebugElement](?version=script&category=21&class=197)

**Functions**

- [draw](#draw)

### draw

**Description**

> draw

**Definition**

> draw()

**Code**

```lua
function DebugCircle:draw()
    DebugCircle.renderAtPosition(
    self.x, not self.alignToGround and self.y or nil , self.z,
    self.radius,
    self.color,
    self.numSegments,
    self.solid,
    self.filled,
    self.drawSectors,
    self.text
    )
end

```