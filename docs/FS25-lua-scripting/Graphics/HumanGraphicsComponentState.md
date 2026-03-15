## HumanGraphicsComponentState

**Functions**

- [new](#new)

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function HumanGraphicsComponentState.new(customMt)
    local self = setmetatable( { } , customMt or HumanGraphicsComponentState _mt)

    self:setDefault()

    return self
end

```