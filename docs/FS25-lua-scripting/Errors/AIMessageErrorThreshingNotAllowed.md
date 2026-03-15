## AIMessageErrorThreshingNotAllowed

**Parent**

> [AIMessage](?version=script&category=29&class=240)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorThreshingNotAllowed:getI18NText()
    return g_i18n:getText( "ai_messageErrorThreshingNotAllowed" )
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
function AIMessageErrorThreshingNotAllowed.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorThreshingNotAllowed _mt)
    return self
end

```