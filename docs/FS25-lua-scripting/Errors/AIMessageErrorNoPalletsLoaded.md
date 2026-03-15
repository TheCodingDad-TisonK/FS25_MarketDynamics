## AIMessageErrorNoPalletsLoaded

**Parent**

> [AIMessage](?version=script&category=29&class=232)

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
function AIMessageErrorNoPalletsLoaded:getI18NText()
    return g_i18n:getText( "ai_messageErrorNoPalletsLoaded" )
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIMessageErrorNoPalletsLoaded:getType()
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
function AIMessageErrorNoPalletsLoaded.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorNoPalletsLoaded _mt)
    return self
end

```