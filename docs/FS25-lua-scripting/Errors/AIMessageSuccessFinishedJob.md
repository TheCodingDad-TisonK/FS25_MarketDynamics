## AIMessageSuccessFinishedJob

**Description**

> AISuccessFinishedJob

**Parent**

> [AIMessage](?version=script&category=29&class=249)

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
function AIMessageSuccessFinishedJob:getI18NText()
    return g_i18n:getText( "ai_messageSuccessFinishedJob" )
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIMessageSuccessFinishedJob:getType()
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
function AIMessageSuccessFinishedJob.new(customMt)
    local self = AIMessage.new(customMt or AIMessageSuccessFinishedJob _mt)
    return self
end

```