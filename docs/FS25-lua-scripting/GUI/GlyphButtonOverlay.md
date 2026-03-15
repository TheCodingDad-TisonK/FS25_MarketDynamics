## GlyphButtonOverlay

**Description**

> Gamepad button display overlay.

**Parent**

> [ButtonOverlay](?version=script&category=43&class=441)

**Functions**

- [new](#new)

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
function GlyphButtonOverlay.new(customMt)
    local self = ButtonOverlay.new( GlyphButtonOverlay _mt)

    return self
end

```