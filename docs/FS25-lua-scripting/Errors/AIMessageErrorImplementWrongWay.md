## AIMessageErrorImplementWrongWay

**Parent**

> [AIMessage](?version=script&category=29&class=229)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorImplementWrongWay:getI18NText()
    return g_i18n:getText( "ai_messageErrorImplementWrongWay" )
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
function AIMessageErrorImplementWrongWay.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorImplementWrongWay _mt)
    return self
end

```