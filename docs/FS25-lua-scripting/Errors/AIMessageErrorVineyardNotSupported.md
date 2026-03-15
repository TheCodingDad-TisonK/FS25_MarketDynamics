## AIMessageErrorVineyardNotSupported

**Parent**

> [AIMessage](?version=script&category=29&class=246)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorVineyardNotSupported:getI18NText()
    return g_i18n:getText( "ai_messageErrorVineyardNotSupported" )
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
function AIMessageErrorVineyardNotSupported.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorVineyardNotSupported _mt)
    return self
end

```