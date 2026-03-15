## AIMessageErrorCouldNotPrepare

**Parent**

> [AIMessage](?version=script&category=29&class=225)

**Functions**

- [getMessage](#getmessage)
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
function AIMessageErrorCouldNotPrepare:getMessage(job)
    local i18nText = self:getI18NText()
    local vehicleName = ""
    if self.vehicle ~ = nil then
        vehicleName = self.vehicle:getName()
    end

    local helperName = "Unknown"
    if job ~ = nil then
        helperName = job:getHelperName() or helperName
    else
            --#debug Logging.warning("AIMessageErrorCouldNotPrepare:getMessage() job was nil")
            --#debug printCallstack()
        end

        return string.format(i18nText, helperName, vehicleName)
    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | vehicle  |
|-----|----------|
| any | customMt |

**Code**

```lua
function AIMessageErrorCouldNotPrepare.new(vehicle, customMt)
    local self = AIMessage.new(customMt or AIMessageErrorCouldNotPrepare _mt)

    self.vehicle = vehicle

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
function AIMessageErrorCouldNotPrepare:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
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
function AIMessageErrorCouldNotPrepare:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

```