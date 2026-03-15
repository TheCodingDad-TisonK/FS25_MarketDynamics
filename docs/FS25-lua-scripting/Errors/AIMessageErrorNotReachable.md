## AIMessageErrorNotReachable

**Parent**

> [AIMessage](?version=script&category=29&class=233)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorNotReachable:getI18NText()
    return g_i18n:getText( "ai_messageErrorNotReachable" )
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
function AIMessageErrorNotReachable.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorNotReachable _mt)
    return self
end

```