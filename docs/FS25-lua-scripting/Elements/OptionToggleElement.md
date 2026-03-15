## OptionToggleElement

**Parent**

> [MultiTextOptionElement](?version=script&category=27&class=222)

**Functions**

- [new](#new)

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
function OptionToggleElement.new(target, custom_mt)
    local self = MultiTextOptionElement.new(target, custom_mt or OptionToggleElement _mt)

    self.dataSouce = nil

    return self
end

```