## AIMessageErrorUnknown

**Parent**

> [AIMessage](?version=script&category=29&class=241)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorUnknown:getI18NText()
    return g_i18n:getText( "ai_messageErrorUnknown" )
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
function AIMessageErrorUnknown.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorUnknown _mt)
    return self
end

```