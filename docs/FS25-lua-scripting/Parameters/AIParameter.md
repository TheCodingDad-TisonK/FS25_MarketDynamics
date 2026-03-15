## AIParameter

**Functions**

- [getCanBeChanged](#getcanbechanged)
- [getIsValid](#getisvalid)
- [getString](#getstring)
- [getType](#gettype)
- [new](#new)
- [readStream](#readstream)
- [setIsValid](#setisvalid)
- [writeStream](#writestream)

### getCanBeChanged

**Description**

**Definition**

> getCanBeChanged()

**Code**

```lua
function AIParameter:getCanBeChanged()
    return true
end

```

### getIsValid

**Description**

**Definition**

> getIsValid()

**Code**

```lua
function AIParameter:getIsValid()
    return self.isValid
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameter:getString()
    return ""
end

```

### getType

**Description**

**Definition**

> getType()

**Code**

```lua
function AIParameter:getType()
    return self.type
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
function AIParameter.new(customMt)
    local self = setmetatable( { } , customMt or AIParameter _mt)

    self.type = AIParameterType.TEXT
    self.isValid = true

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
function AIParameter:readStream(streamId, connection)
end

```

### setIsValid

**Description**

**Definition**

> setIsValid()

**Arguments**

| any | isValid |
|-----|---------|

**Code**

```lua
function AIParameter:setIsValid(isValid)
    self.isValid = isValid
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
function AIParameter:writeStream(streamId, connection)
end

```