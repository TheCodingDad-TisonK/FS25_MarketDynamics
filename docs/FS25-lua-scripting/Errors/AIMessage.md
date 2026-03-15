## AIMessage

**Functions**

- [getMessage](#getmessage)
- [getType](#gettype)
- [new](#new)
- [readStream](#readstream)
- [writeStream](#writestream)

### getMessage

**Description**

**Definition**

> getMessage()

**Arguments**

| any | job |
|-----|-----|

**Code**

```lua
function AIMessage:getMessage(job)
    local i18nText = self:getI18NText()
    if i18nText ~ = nil then
        if job = = nil then
            --#debug Logging.warning("AIMessage:getMessage() job was nil")
            --#debug printCallstack()
            return string.format(i18nText, "Unknown" )
        end
        return string.format(i18nText, job:getHelperName() or "Unknown" )
    end

    return ""
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIMessage:getType()
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
function AIMessage.new(customMt)
    local self = setmetatable( { } , customMt or AIMessage _mt)
    return self
end

```

### readStream

**Description**

**Definition**

> readStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AIMessage:readStream(streamId, connection)
end

```

### writeStream

**Description**

**Definition**

> writeStream()

**Arguments**

| any | streamId   |
|-----|------------|
| any | connection |

**Code**

```lua
function AIMessage:writeStream(streamId, connection)
end

```