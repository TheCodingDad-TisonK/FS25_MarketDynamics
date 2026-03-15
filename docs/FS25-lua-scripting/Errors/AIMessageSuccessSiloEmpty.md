## AIMessageSuccessSiloEmpty

**Parent**

> [AIMessage](?version=script&category=29&class=250)

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
function AIMessageSuccessSiloEmpty:getI18NText()
    return g_i18n:getText( "ai_messageSuccessSiloEmpty" )
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIMessageSuccessSiloEmpty:getType()
    return AIMessageType.OK
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
function AIMessageSuccessSiloEmpty.new(customMt)
    local self = AIMessage.new(customMt or AIMessageSuccessSiloEmpty _mt)
    return self
end

```