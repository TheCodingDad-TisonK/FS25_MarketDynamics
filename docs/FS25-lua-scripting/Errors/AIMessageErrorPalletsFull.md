## AIMessageErrorPalletsFull

**Parent**

> [AIMessage](?version=script&category=29&class=239)

**Functions**

- [getI18NText](#geti18ntext)
- [getType](#gettype)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorPalletsFull:getI18NText()
    return g_i18n:getText( "ai_messageErrorPalletsFull" )
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIMessageErrorPalletsFull:getType()
    return AIMessageType.ERROR
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
function AIMessageErrorPalletsFull.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorPalletsFull _mt)
    return self
end

```