## AIParameterFillType

**Parent**

> [AIParameter](?version=script&category=65&class=588)

**Functions**

- [getFillTypeIndex](#getfilltypeindex)
- [getString](#getstring)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setFillTypeByIndex](#setfilltypebyindex)
- [setFillTypeIndex](#setfilltypeindex)
- [setNextItem](#setnextitem)
- [setPreviousItem](#setpreviousitem)
- [setValidFillTypes](#setvalidfilltypes)
- [validate](#validate)
- [writeStream](#writestream)

### getFillTypeIndex

**Description**

**Definition**

> getFillTypeIndex()

**Code**

```lua
function AIParameterFillType:getFillTypeIndex()
    return self.fillTypeIndex
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterFillType:getString()
    for _, data in ipairs( self.fillTypes) do
        if data.fillTypeIndex = = self.fillTypeIndex then
            return data.title
        end
    end

    return ""
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
function AIParameterFillType:loadFromXMLFile(xmlFile, key)
    local fillTypeName = xmlFile:getString(key .. "#fillType" )
    if fillTypeName ~ = nil then
        self.fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
    end
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
function AIParameterFillType.new(customMt)
    local self = AIParameter.new(customMt or AIParameterFillType _mt)

    self.type = AIParameterType.FILLTYPE

    self.fillTypes = { }
    self.fillTypeIndex = nil

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
function AIParameterFillType:readStream(streamId, connection)
    if streamReadBool(streamId) then
        local fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
        self:setFillTypeIndex(fillTypeIndex)
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
function AIParameterFillType:saveToXMLFile(xmlFile, key, usedModNames)
    if self.fillTypeIndex ~ = nil then
        local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex( self.fillTypeIndex)
        xmlFile:setString(key .. "#fillType" , fillTypeName)
    end
end

```

### setFillTypeByIndex

**Description**

**Definition**

> setFillTypeByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function AIParameterFillType:setFillTypeByIndex(index)
    local data = self.fillTypes[index]
    if data ~ = nil then
        self.fillTypeIndex = data.fillTypeIndex
    else
            self.fillTypeIndex = nil
        end
    end

```

### setFillTypeIndex

**Description**

**Definition**

> setFillTypeIndex()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|

**Code**

```lua
function AIParameterFillType:setFillTypeIndex(fillTypeIndex)
    self.fillTypeIndex = fillTypeIndex
end

```

### setNextItem

**Description**

**Definition**

> setNextItem()

**Code**

```lua
function AIParameterFillType:setNextItem()
    local nextIndex = 0
    for k, data in ipairs( self.fillTypes) do
        if self.fillTypeIndex = = data.fillTypeIndex then
            nextIndex = k + 1
        end
    end

    if nextIndex > # self.fillTypes then
        nextIndex = 1
    end

    self:setFillTypeByIndex(nextIndex)
end

```

### setPreviousItem

**Description**

**Definition**

> setPreviousItem()

**Code**

```lua
function AIParameterFillType:setPreviousItem()
    local previousIndex = 0
    for k, data in ipairs( self.fillTypes) do
        if self.fillTypeIndex = = data.fillTypeIndex then
            previousIndex = k - 1
        end
    end

    if previousIndex < 1 then
        previousIndex = # self.fillTypes
    end

    self:setFillTypeByIndex(previousIndex)
end

```

### setValidFillTypes

**Description**

**Definition**

> setValidFillTypes()

**Arguments**

| any | fillTypes |
|-----|-----------|

**Code**

```lua
function AIParameterFillType:setValidFillTypes(fillTypes)
    self.fillTypes = { }
    local maxFillLevel = 0
    local maxFillLevelFillTypeIndex
    local isCurrentFillTypeIndexAvailable = false
    for fillTypeIndex, fillLevel in pairs(fillTypes) do
        if fillLevel > maxFillLevel then
            maxFillLevelFillTypeIndex = fillTypeIndex
        end

        if self.fillTypeIndex = = fillTypeIndex then
            isCurrentFillTypeIndexAvailable = true
        end

        local title = g_fillTypeManager:getFillTypeTitleByIndex(fillTypeIndex)
        title = string.format( "%s(%d l)" , title, fillLevel)
        table.insert( self.fillTypes, { index = # self.fillTypes + 1 , fillTypeIndex = fillTypeIndex, title = title, fillLevel = fillLevel } )
    end

    table.sort( self.fillTypes, function (a, b)
        return a.title < b.title
    end )

    if self.fillTypeIndex = = nil or not isCurrentFillTypeIndexAvailable then
        if maxFillLevelFillTypeIndex ~ = nil then
            self.fillTypeIndex = maxFillLevelFillTypeIndex
        else
                self:setFillTypeByIndex( 1 )
            end
        end
    end

```

### validate

**Description**

**Definition**

> validate()

**Code**

```lua
function AIParameterFillType:validate()
    if self.fillTypeIndex = = nil then
        return false , g_i18n:getText( "ai_validationErrorNoFillType" )
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
function AIParameterFillType:writeStream(streamId, connection)
    if streamWriteBool(streamId, self.fillTypeIndex ~ = nil ) then
        streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)
    end
end

```