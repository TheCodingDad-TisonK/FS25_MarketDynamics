## AIMessageErrorUnloadingStationDeleted

**Parent**

> [AIMessage](?version=script&category=29&class=242)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorUnloadingStationDeleted:getI18NText()
    return g_i18n:getText( "ai_messageErrorUnloadingStationDeleted" )
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
function AIMessageErrorUnloadingStationDeleted.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorUnloadingStationDeleted _mt)
    return self
end

```