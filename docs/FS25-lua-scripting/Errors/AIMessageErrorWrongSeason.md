## AIMessageErrorWrongSeason

**Parent**

> [AIMessage](?version=script&category=29&class=247)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorWrongSeason:getI18NText()
    return g_i18n:getText( "ai_messageErrorWrongSeason" )
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
function AIMessageErrorWrongSeason.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorWrongSeason _mt)
    return self
end

```