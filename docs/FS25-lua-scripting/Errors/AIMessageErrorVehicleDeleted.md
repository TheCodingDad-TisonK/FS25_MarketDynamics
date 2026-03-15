## AIMessageErrorVehicleDeleted

**Parent**

> [AIMessage](?version=script&category=29&class=245)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorVehicleDeleted:getI18NText()
    return g_i18n:getText( "ai_messageErrorVehicleDeleted" )
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
function AIMessageErrorVehicleDeleted.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorVehicleDeleted _mt)
    return self
end

```