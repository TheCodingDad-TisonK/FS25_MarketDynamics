## DebugText

**Parent**

> [DebugElement](?version=script&category=21&class=213)

**Functions**

- [draw](#draw)
- [new](#new)
- [renderAtNode](#renderatnode)
- [renderAtPosition](#renderatposition)
- [renderAtScreenPosition](#renderatscreenposition)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function DebugText:draw()
    if self.node ~ = nil and entityExists( self.node) then
        self.x, self.y, self.z = getWorldTranslation( self.node)
    end

    DebugText.renderAtPosition( self.x, self.y, self.z, self.text, self.color, self.size, self.screenSpaceOffset, self.alignment, self.verticalAlignment)
end

```

### new

**Description**

> Create new instance of a DebugText

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
function DebugText.new(customMt)
    local self = DebugText:superClass().new(customMt or DebugText _mt)

    self.alignment = RenderText.ALIGN_CENTER
    self.verticalAlignment = RenderText.VERTICAL_ALIGN_MIDDLE
    self.size = 0.1
    self.screenSpaceOffset = nil

    self.node = nil

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
function DebugText.renderAtNode(node, text, color, size, alignment, verticalAlignment)
    local x, y, z = getWorldTranslation(node)
    DebugText.renderAtPosition(x,y,z, text, color, size, 0 , alignment, verticalAlignment)
end

```

### renderAtPosition

**Description**

> renderAtPosition, use nil for y to enable terrain alignment

**Definition**

> renderAtPosition(float x, float y, float z, string text, table? color, float? size, float? screenSpaceYOffset,
> integer? alignment, integer? verticalAlignment)

**Arguments**

| float    | x                  |                                        |
|----------|--------------------|----------------------------------------|
| float    | y                  | use nil to align to terrain            |
| float    | z                  |                                        |
| string   | text               |                                        |
| table?   | color              | Color instance                         |
| float?   | size               | (optional)                             |
| float?   | screenSpaceYOffset | (optional)                             |
| integer? | alignment          | (optional) RenderText.ALIGN_*          |
| integer? | verticalAlignment  | (optional) RenderText.VERTICAL_ALIGN_* |

**Code**

```lua
function DebugText.renderAtPosition(x,y,z, text, color, size, screenSpaceYOffset, alignment, verticalAlignment)

    if y = = nil then
        if g_terrainNode = = nil then
            return -- no way to recover this in a meaningful way
        end
        y = getTerrainHeightAtWorldPos(g_terrainNode, x, 0 , z) + 0.01
    end

    local sx,sy,sz = project(x,y,z)

    if sz > 1 then
        return
    end

    DebugText.renderAtScreenPosition(sx, sy, text, color, size, screenSpaceYOffset, alignment, verticalAlignment)
end

```

### renderAtScreenPosition

**Description**

> renderAtScreenPosition

**Definition**

> renderAtScreenPosition(float x, float y, string text, table? color, float? size, float? yOffset, integer? alignment,
> integer? verticalAlignment)

**Arguments**

| float    | x                 | screenspace x [0..1]                   |
|----------|-------------------|----------------------------------------|
| float    | y                 | screenspace y [0..1]                   |
| string   | text              |                                        |
| table?   | color             | Color instance                         |
| float?   | size              | (optional)                             |
| float?   | yOffset           | (optional)                             |
| integer? | alignment         | (optional) RenderText.ALIGN_*          |
| integer? | verticalAlignment | (optional) RenderText.VERTICAL_ALIGN_* |

**Code**

```lua
function DebugText.renderAtScreenPosition(x, y, text, color, size, yOffset, alignment, verticalAlignment)

    if x < = - 1 or x > = 2 or y < = - 1 or y > = 2 then
        return
    end

    size = size or 0.02
    yOffset = yOffset or 0

    -- more exact out of bounds check
    local textWidth, textHeight = getTextWidth(size, text), getTextHeight(size, text)
    if x + textWidth < 0 or x - textWidth > 1 or y + textHeight < 0 or y - textHeight > 1 then
        return
    end

    y = y + textHeight - size -- offset text so it is rendered above the given point for multi line texts

        setTextAlignment(alignment or RenderText.ALIGN_CENTER)
        setTextVerticalAlignment(verticalAlignment or RenderText.VERTICAL_ALIGN_BASELINE)
        setTextBold( false )

        -- render text with black shadow
        setTextColor( 0.0 , 0.0 , 0.0 , 0.75 )
        renderText(x, y - 0.0015 + yOffset, size, text) -- TODO:make shadow offset textSize dependent? offset in x as well?
        -- render text in actual color
        setTextColor((color or Color.PRESETS.WHITE):unpack())
        renderText(x, y + yOffset, size, text)

        -- reset
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextColor( 1 , 1 , 1 , 1 )

        return y - size
    end

```