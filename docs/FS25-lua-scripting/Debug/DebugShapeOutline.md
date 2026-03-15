## DebugShapeOutline

**Parent**

> [DebugElement](?version=script&category=21&class=210)

**Functions**

- [draw](#draw)

### draw

**Description**

> draw

**Definition**

> draw()

**Code**

```lua
function DebugShapeOutline:draw()
    DebugShapeOutline.render(
    self.node,
    self.recursive
    )
end

```