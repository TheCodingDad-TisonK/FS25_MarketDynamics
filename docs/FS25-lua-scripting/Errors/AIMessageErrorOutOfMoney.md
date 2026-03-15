## AIMessageErrorOutOfMoney

**Parent**

> [AIMessage](?version=script&category=29&class=238)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorOutOfMoney:getI18NText()
    return g_i18n:getText( "ai_messageErrorOutOfMoney" )
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
function AIMessageErrorOutOfMoney.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorOutOfMoney _mt)
    return self
end

```