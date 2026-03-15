## SafeFrameElement

**Description**

> Fully opaque black element in the background of certain screens, to prevent showing the game if UI is moved because of
> defined safe frames

**Parent**

> [GuiElement](?version=script&category=43&class=489)

**Functions**

- [draw](#draw)
- [new](#new)

### draw

**Description**

**Definition**

> draw()

**Code**

```lua
function SafeFrameElement:draw()
    drawFilledRect( 0 , 0 , 1 , 1 , 0 , 0 , 0 , 1 )
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function SafeFrameElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or SafeFrameElement _mt)

    self.name = "safeFrame"

    return self
end

```