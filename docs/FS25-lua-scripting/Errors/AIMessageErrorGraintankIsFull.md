## AIMessageErrorGraintankIsFull

**Parent**

> [AIMessage](?version=script&category=29&class=228)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorGraintankIsFull:getI18NText()
    return g_i18n:getText( "ai_messageErrorTankIsFull" )
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
function AIMessageErrorGraintankIsFull.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorGraintankIsFull _mt)
    return self
end

```