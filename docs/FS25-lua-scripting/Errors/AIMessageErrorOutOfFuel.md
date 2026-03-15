## AIMessageErrorOutOfFuel

**Parent**

> [AIMessage](?version=script&category=29&class=237)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorOutOfFuel:getI18NText()
    return g_i18n:getText( "ai_messageErrorOutOfFuel" )
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
function AIMessageErrorOutOfFuel.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorOutOfFuel _mt)
    return self
end

```