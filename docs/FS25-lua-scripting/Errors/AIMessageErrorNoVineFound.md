## AIMessageErrorNoVineFound

**Parent**

> [AIMessage](?version=script&category=29&class=235)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorNoVineFound:getI18NText()
    return g_i18n:getText( "ai_messageErrorNoVineFound" )
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
function AIMessageErrorNoVineFound.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorNoVineFound _mt)
    return self
end

```