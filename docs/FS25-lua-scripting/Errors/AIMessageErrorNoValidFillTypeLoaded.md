## AIMessageErrorNoValidFillTypeLoaded

**Parent**

> [AIMessage](?version=script&category=29&class=234)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorNoValidFillTypeLoaded:getI18NText()
    return g_i18n:getText( "ai_messageErrorNoValidFillTypeLoaded" )
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
function AIMessageErrorNoValidFillTypeLoaded.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorNoValidFillTypeLoaded _mt)
    return self
end

```