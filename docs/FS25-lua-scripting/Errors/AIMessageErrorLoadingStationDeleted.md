## AIMessageErrorLoadingStationDeleted

**Parent**

> [AIMessage](?version=script&category=29&class=230)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorLoadingStationDeleted:getI18NText()
    return g_i18n:getText( "ai_messageErrorLoadingStationDeleted" )
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
function AIMessageErrorLoadingStationDeleted.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorLoadingStationDeleted _mt)
    return self
end

```