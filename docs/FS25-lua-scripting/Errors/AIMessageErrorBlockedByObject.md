## AIMessageErrorBlockedByObject

**Parent**

> [AIMessage](?version=script&category=29&class=224)

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
function AIMessageErrorBlockedByObject.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorBlockedByObject _mt)
    return self
end

```