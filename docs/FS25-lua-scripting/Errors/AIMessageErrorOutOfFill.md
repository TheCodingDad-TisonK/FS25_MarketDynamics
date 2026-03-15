## AIMessageErrorOutOfFill

**Parent**

> [AIMessage](?version=script&category=29&class=236)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorOutOfFill:getI18NText()
    return g_i18n:getText( "ai_messageErrorOutOfFill" )
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
function AIMessageErrorOutOfFill.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorOutOfFill _mt)
    return self
end

```