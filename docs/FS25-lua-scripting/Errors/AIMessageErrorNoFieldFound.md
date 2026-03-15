## AIMessageErrorNoFieldFound

**Parent**

> [AIMessage](?version=script&category=29&class=231)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorNoFieldFound:getI18NText()
    return g_i18n:getText( "ai_messageErrorNoFieldFound" )
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
function AIMessageErrorNoFieldFound.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorNoFieldFound _mt)
    return self
end

```