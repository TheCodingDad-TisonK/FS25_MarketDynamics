## DebugText3D

**Parent**

> [DebugElement](?version=script&category=21&class=214)

**Functions**

- [draw](#draw)
- [new](#new)
- [renderAtNode](#renderatnode)
- [renderAtPosition](#renderatposition)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugText3D:draw()
    DebugText3D.renderAtPosition( self.x, self.y, self.z, self.rx, self.ry, self.rz, self.text, self.color, self.size, self.alignment, self.verticalAlignment)
end

```

### new

**Description**

> Create new instance of a DebugText3D

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | self | instance |
|--------|------|----------|

**Code**

```lua
function DebugText3D.new(customMt)
    local self = DebugText3D:superClass().new(customMt or DebugText3D _mt)

    self.alignment = RenderText.ALIGN_CENTER
    self.verticalAlignment = RenderText.VERTICAL_ALIGN_MIDDLE
    self.size = 0.1

    return self
end

```

### renderAtNode

**Description**

> renderAtNode

**Definition**

> renderAtNode(entityId node, string text, table? color, float? size, integer? alignment, integer? verticalAlignment)

**Arguments**

| entityId | node              |                                        |
|----------|-------------------|----------------------------------------|
| string   | text              |                                        |
| table?   | color             | Color instance                         |
| float?   | size              | (optional)                             |
| integer? | alignment         | (optional) RenderText.ALIGN_*          |
| integer? | verticalAlignment | (optional) RenderText.VERTICAL_ALIGN_* |

**Code**

```lua
function DebugText3D.renderAtNode(node, text, color, size, alignment, verticalAlignment)
    local x, y, z = getWorldTranslation(node)
    local rx, ry, rz = getWorldRotation(node)
    DebugText3D.renderAtPosition(x, y, z, rx, ry, rz, text, color, size, alignment, verticalAlignment)
end

```

### renderAtPosition

**Description**

> renderAtPosition, use nil for y to enable terrain alignment

**Definition**

> renderAtPosition(float x, float y, float z, float rx, float ry, float rz, string text, table? color, float? size,
> integer? alignment, integer? verticalAlignment)

**Arguments**

| float    | x                 |                                        |
|----------|-------------------|----------------------------------------|
| float    | y                 |                                        |
| float    | z                 |                                        |
| float    | rx                |                                        |
| float    | ry                |                                        |
| float    | rz                |                                        |
| string   | text              |                                        |
| table?   | color             | Color instance                         |
| float?   | size              | (optional)                             |
| integer? | alignment         | (optional) RenderText.ALIGN_*          |
| integer? | verticalAlignment | (optional) RenderText.VERTICAL_ALIGN_* |

**Code**

```lua
function DebugText3D.renderAtPosition(x, y, z, rx, ry, rz, text, color, size, alignment, verticalAlignment)
    setTextAlignment(alignment or RenderText.ALIGN_CENTER)
    setTextVerticalAlignment(verticalAlignment or RenderText.VERTICAL_ALIGN_BASELINE)
    setTextBold( false )

    setTextColor((color or Color.PRESETS.WHITE):unpack())
    renderText3D(x, y, z, rx, ry, rz, size, text)

    -- reset
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextColor( 1 , 1 , 1 , 1 )
end

```