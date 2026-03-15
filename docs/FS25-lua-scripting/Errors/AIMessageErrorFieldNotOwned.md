## AIMessageErrorFieldNotOwned

**Parent**

> [AIMessage](?version=script&category=29&class=226)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorFieldNotOwned:getI18NText()
    return g_i18n:getText( "ai_messageErrorFieldNotOwned" )
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Code**

```lua
function AIMessageErrorFieldNotOwned.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorFieldNotOwned _mt)
    return self
end

```