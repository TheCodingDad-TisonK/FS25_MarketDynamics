## AIMessageSuccessStoppedByUser

**Parent**

> [AIMessage](?version=script&category=29&class=251)

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
function AIMessageSuccessStoppedByUser:getI18NText()
    return g_i18n:getText( "ai_messageSuccessStoppedByUser" )
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIMessageSuccessStoppedByUser:getType()
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
function AIMessageSuccessStoppedByUser.new(customMt)
    local self = AIMessage.new(customMt or AIMessageSuccessStoppedByUser _mt)
    return self
end

```