## AIParameterPosition

**Parent**

> [AIParameter](?version=script&category=65&class=592)

**Functions**

- [getPosition](#getposition)
- [getString](#getstring)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setPosition](#setposition)
- [validate](#validate)
- [writeStream](#writestream)

### getPosition

**Description**

**Definition**

> getPosition()

**Code**

```lua
function AIParameterPosition:getPosition()
    return self.x, self.z
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterPosition:getString()
    return string.format( "< %.1f , %.1f >" , self.x, self.z)
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
function AIParameterPosition:loadFromXMLFile(xmlFile, key)
    self.x = xmlFile:getFloat(key .. "#x" , self.x)
    self.z = xmlFile:getFloat(key .. "#z" , self.z)
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
function AIParameterPosition.new(customMt)
    local self = AIParameter.new(customMt or AIParameterPosition _mt)

    self.type = AIParameterType.POSITION

    self.x = nil
    self.z = nil

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
function AIParameterPosition:readStream(streamId, connection)
    if streamReadBool(streamId) then
        local x = streamReadFloat32(streamId)
        local z = streamReadFloat32(streamId)
        self:setPosition(x, z)
    end
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
function AIParameterPosition:saveToXMLFile(xmlFile, key, usedModNames)
    if self.x ~ = nil then
        xmlFile:setFloat(key .. "#x" , self.x)
        xmlFile:setFloat(key .. "#z" , self.z)
    end
end

```

### setPosition

**Description**

**Definition**

> setPosition()

**Arguments**

| any | x |
|-----|---|
| any | z |

**Code**

```lua
function AIParameterPosition:setPosition(x, z)
    self.x = x
    self.z = z
end

```

### validate

**Description**

**Definition**

> validate()

**Code**

```lua
function AIParameterPosition:validate()
    if self.x = = nil or self.z = = nil then
        return false , g_i18n:getText( "ai_validationErrorNoPosition" )
    end

    if not g_currentMission.aiSystem:getIsPositionReachable( self.x, 0 , self.z) then
        return false , g_i18n:getText( "ai_validationErrorBlockedPosition" )
    end

    return true , nil
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
function AIParameterPosition:writeStream(streamId, connection)
    if streamWriteBool(streamId, self.x ~ = nil ) then
        streamWriteFloat32(streamId, self.x)
        streamWriteFloat32(streamId, self.z)
    end
end

```