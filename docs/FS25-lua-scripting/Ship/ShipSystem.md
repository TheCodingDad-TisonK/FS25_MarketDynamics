## ShipSystem

**Functions**

- [new](#new)

### new

**Description**

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Code**

```lua
function ShipSystem.new(customMt)
    local self = setmetatable( { } , customMt or ShipSystem _mt)

    self.splines = { }
    self.crossingNodes = { }

    return self
end

```