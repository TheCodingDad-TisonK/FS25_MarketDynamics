## AIParameterLooping

**Parent**

> [AIParameter](?version=script&category=65&class=591)

**Functions**

- [getIsLooping](#getislooping)
- [getString](#getstring)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setIsLooping](#setislooping)
- [setNextItem](#setnextitem)
- [setPreviousItem](#setpreviousitem)
- [writeStream](#writestream)

### getIsLooping

**Description**

**Definition**

> getIsLooping()

**Code**

```lua
function AIParameterLooping:getIsLooping()
    return self.isLooping
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterLooping:getString()
    if self.isLooping then
        return g_i18n:getText( "ai_parameterValueLooping" )
    else
            return g_i18n:getText( "ai_parameterValueNoLooping" )
        end
    end

```

### loadFromXMLFile

**Description**

**Definition**

> loadFromXMLFile()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function AIParameterLooping:loadFromXMLFile(xmlFile, key)
    self.isLooping = xmlFile:getBool(key .. "#isLooping" , self.isLooping)
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
function AIParameterLooping.new(customMt)
    local self = AIParameter.new(customMt or AIParameterLooping _mt)

    self.type = AIParameterType.SELECTOR

    self.isLooping = false

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
function AIParameterLooping:readStream(streamId, connection)
    self:setIsLooping(streamReadBool(streamId))
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile      |
|-----|--------------|
| any | key          |
| any | usedModNames |

**Code**

```lua
function AIParameterLooping:saveToXMLFile(xmlFile, key, usedModNames)
    xmlFile:setBool(key .. "#isLooping" , self.isLooping)
end

```

### setIsLooping

**Description**

**Definition**

> setIsLooping()

**Arguments**

| any | isLooping |
|-----|-----------|

**Code**

```lua
function AIParameterLooping:setIsLooping(isLooping)
    self.isLooping = isLooping
end

```

### setNextItem

**Description**

**Definition**

> setNextItem()

**Code**

```lua
function AIParameterLooping:setNextItem()
    self.isLooping = not self.isLooping
end

```

### setPreviousItem

**Description**

**Definition**

> setPreviousItem()

**Code**

```lua
function AIParameterLooping:setPreviousItem()
    self.isLooping = not self.isLooping
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
function AIParameterLooping:writeStream(streamId, connection)
    streamWriteBool(streamId, self.isLooping)
end

```