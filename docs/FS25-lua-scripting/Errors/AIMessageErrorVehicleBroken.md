## AIMessageErrorVehicleBroken

**Parent**

> [AIMessage](?version=script&category=29&class=244)

**Functions**

- [getI18NText](#geti18ntext)
- [new](#new)

### getI18NText

**Description**

**Definition**

> getI18NText()

**Code**

```lua
function AIMessageErrorVehicleBroken:getI18NText()
    return g_i18n:getText( "ai_messageErrorVehicleBroken" )
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
function AIMessageErrorVehicleBroken.new(customMt)
    local self = AIMessage.new(customMt or AIMessageErrorVehicleBroken _mt)
    return self
end

```