## WheelXMLObject

**Description**

> Handles loading and inheritance of wheel xml attributes

**Functions**

- [cacheWheelMass](#cachewheelmass)
- [checkDeprecatedXMLElements](#checkdeprecatedxmlelements)
- [getLocalValue](#getlocalvalue)
- [getValue](#getvalue)
- [getValueAlternative](#getvaluealternative)
- [loadExternalXMLFile](#loadexternalxmlfile)
- [new](#new)
- [setExternalFilename](#setexternalfilename)
- [setXMLLoadKey](#setxmlloadkey)
- [xmlWarning](#xmlwarning)

### cacheWheelMass

**Description**

**Definition**

> cacheWheelMass()

**Code**

```lua
function WheelXMLObject:cacheWheelMass()
    local vehicleXMLMass = self:getLocalValue( ".physics#mass" , nil )
    if vehicleXMLMass ~ = nil then
        return vehicleXMLMass
    end

    if self.externalFilename ~ = nil then
        if WheelXMLObject.wheelMassCache[ self.externalFilename] = = nil then
            WheelXMLObject.wheelMassCache[ self.externalFilename] = { }
        end

        local mass = WheelXMLObject.wheelMassCache[ self.externalFilename][ self.externalConfigId]
        if mass ~ = nil then
            return mass
        end
    else
            return 0.1
        end

        local mass = self:getValue( ".physics#mass" , 0.1 )

        for name, _ in pairs( WheelVisual.PARTS) do
            local i = 0
            while true do
                local keyAdditional = string.format( ".%s(%d)" , name, i)
                local xmlFile, _ = self:getXMLFileAndPropertyKey(keyAdditional)
                if xmlFile = = nil then
                    break
                end

                mass = mass + self:getValue(keyAdditional .. "#mass" , 0 )

                i = i + 1
            end
        end

        if self.externalFilename = = nil or self.externalConfigId = = nil then
            return 0
        end

        WheelXMLObject.wheelMassCache[ self.externalFilename][ self.externalConfigId] = mass
        return mass
    end

```

### checkDeprecatedXMLElements

**Description**

**Definition**

> checkDeprecatedXMLElements()

**Arguments**

| any | oldAttributeKey |
|-----|-----------------|
| any | newAttribute    |

**Code**

```lua
function WheelXMLObject:checkDeprecatedXMLElements(oldAttributeKey, newAttribute)
    local baseKey = self.baseKey .. "(" .. tostring( self.configIndex - 1 ) .. ")" .. self.wheelKey
    XMLUtil.checkDeprecatedXMLElements( self.xmlFile, baseKey .. oldAttributeKey, baseKey .. newAttribute)
end

```

### getLocalValue

**Description**

**Definition**

> getLocalValue()

**Arguments**

| any | attributeKey |
|-----|--------------|
| any | ...          |

**Code**

```lua
function WheelXMLObject:getLocalValue(attributeKey, .. .)
    local xmlFile, key = self:getXMLFileAndKey( self.configIndex, attributeKey, nil , true )
    if xmlFile ~ = nil then
        if xmlFile:getString(key) = = "-" then
            return nil
        end

        return xmlFile:getValue(key, .. .)
    else
            -- use getValue on default xml with default key even if we know that there is no value
                -- like this we get the proper default value by the XMLValueType
                local defaultKey = self.baseKey .. "(" .. tostring( self.configIndex - 1 ) .. ")" .. self.wheelKey .. attributeKey
                return self.xmlFile:getValue(defaultKey, .. .)
            end
        end

```

### getValue

**Description**

**Definition**

> getValue()

**Arguments**

| any | attributeKey |
|-----|--------------|
| any | ...          |

**Code**

```lua
function WheelXMLObject:getValue(attributeKey, .. .)
    local xmlFile, key = self:getXMLFileAndKey( self.configIndex, attributeKey)
    if xmlFile ~ = nil then
        if xmlFile:getString(key) = = "-" then
            return nil
        end

        return xmlFile:getValue(key, .. .)
    else
            -- use getValue on default xml with default key even if we know that there is no value
                -- like this we get the proper default value by the XMLValueType
                local defaultKey = self.baseKey .. "(" .. tostring( self.configIndex - 1 ) .. ")" .. self.wheelKey .. attributeKey
                return self.xmlFile:getValue(defaultKey, .. .)
            end
        end

```

### getValueAlternative

**Description**

**Definition**

> getValueAlternative()

**Arguments**

| any | attributeKey    |
|-----|-----------------|
| any | altAttributeKey |
| any | ...             |

**Code**

```lua
function WheelXMLObject:getValueAlternative(attributeKey, altAttributeKey, .. .)
    local xmlFile, key = self:getXMLFileAndKey( self.configIndex, attributeKey, altAttributeKey)
    if xmlFile ~ = nil then
        if xmlFile:getString(key) = = "-" then
            return nil
        end

        return xmlFile:getValue(key, .. .)
    else
            -- use getValue on default xml with default key even if we know that there is no value
                -- like this we get the proper default value by the XMLValueType
                local defaultKey = self.baseKey .. "(" .. tostring( self.configIndex - 1 ) .. ")" .. self.wheelKey .. attributeKey
                return self.xmlFile:getValue(defaultKey, .. .)
            end
        end

```

### loadExternalXMLFile

**Description**

**Definition**

> loadExternalXMLFile()

**Code**

```lua
function WheelXMLObject:loadExternalXMLFile()
    if self.externalXMLFile ~ = nil then
        self.externalXMLFile:delete()
        self.externalXMLFile = nil
    end

    local xmlFile = XMLFile.load( "wheelXML" , self.externalFilename, Wheels.xmlSchema)
    if xmlFile ~ = nil then
        self.externalXMLFile = xmlFile

        self.externalWheelName = self.externalXMLFile:getValue( "wheel.metadata#name" )

        xmlFile:iterate( "wheel.configurations.configuration" , function (index, key)
            if xmlFile:getValue(key .. "#id" ) = = self.externalConfigId then
                self.externalConfigKey = key
            end
        end )

        return true
    end

    self.externalFilename = nil
    self.externalXMLFile = nil
    self.externalConfigId = nil

    return false
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | baseKey            |
| any | configIndex        |
| any | wheelKey           |
| any | indexToParentIndex |

**Code**

```lua
function WheelXMLObject.new(xmlFile, baseKey, configIndex, wheelKey, indexToParentIndex)
    local self = setmetatable( { } , WheelXMLObject _mt)

    self.xmlFile = xmlFile
    self.baseKey = baseKey
    self.configIndex = configIndex
    self.baseWheelKey = wheelKey
    self.wheelKey = wheelKey
    self.indexToParentIndex = indexToParentIndex

    local _
    _, self.baseDirectory = Utils.getModNameAndBaseDirectory( self.xmlFile.filename)

    self:setXMLLoadKey( "" )

    return self
end

```

### setExternalFilename

**Description**

**Definition**

> setExternalFilename()

**Arguments**

| any | externalFilename |
|-----|------------------|
| any | configId         |

**Code**

```lua
function WheelXMLObject:setExternalFilename(externalFilename, configId)
    externalFilename = Utils.getFilename(externalFilename, self.baseDirectory)
    if externalFilename ~ = self.externalFilename or configId ~ = self.externalConfigId then
        self.externalFilename = externalFilename
        self.externalConfigId = configId

        if self.externalXMLFile ~ = nil then
            self.externalXMLFile:delete()
            self.externalXMLFile = nil
        end
        self.externalWheelName = nil
    end
end

```

### setXMLLoadKey

**Description**

**Definition**

> setXMLLoadKey()

**Arguments**

| any | key                 |
|-----|---------------------|
| any | alternativeFilename |

**Code**

```lua
function WheelXMLObject:setXMLLoadKey(key, alternativeFilename)
    self.wheelKey = self.baseWheelKey .. key

    local filename = self:getLocalValue( "#filename" , alternativeFilename)
    if filename ~ = nil and filename ~ = "" then
        local configId = self:getLocalValue( "#configId" , "default" )
        self:setExternalFilename(filename, configId)
    else
            if self.externalXMLFile ~ = nil then
                self.externalXMLFile:delete()
                self.externalXMLFile = nil
            end

            self.externalFilename = nil
            self.externalConfigId = nil
        end
    end

```

### xmlWarning

**Description**

**Definition**

> xmlWarning()

**Arguments**

| any | attributeKey |
|-----|--------------|
| any | text         |
| any | ...          |

**Code**

```lua
function WheelXMLObject:xmlWarning(attributeKey, text, .. .)
    Logging.xmlWarning( self.xmlFile, text .. " (" .. self.baseKey .. "(" .. tostring( self.configIndex - 1 ) .. ")" .. self.wheelKey .. attributeKey .. ")" , .. .)
end

```