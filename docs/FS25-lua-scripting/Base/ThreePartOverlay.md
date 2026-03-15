## ThreePartOverlay

**Functions**

- [new](#new)

### new

**Description**

**Definition**

> new()

**Arguments**

| any | custom_mt |
|-----|-----------|

**Code**

```lua
function ThreePartOverlay.new(custom_mt)
    local self = setmetatable( { } , custom_mt or ThreePartOverlay _mt)

    self.dirX = 1
    self.dirY = 0

    return self
end

```