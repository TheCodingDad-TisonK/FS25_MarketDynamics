## AIMessageErrorUnloadingStationFull

**Parent**

> [AIMessage](?version=script&category=29&class=243)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorUnloadingStationFull:getI18NText()
    return g_i18n:getText( "ai_messageErrorUnloadingStationFull" )
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
function AIMessageErrorUnloadingStationFull.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorUnloadingStationFull _mt)
    return self
end

```