## AIParameterPositionAngle

**Parent**

> [AIParameterPosition](?version=script&category=65&class=593)

**Functions**

- [getAngle](#getangle)
- [getDirection](#getdirection)
- [getSnappingAngle](#getsnappingangle)
- [getString](#getstring)
- [loadFromXMLFile](#loadfromxmlfile)
- [new](#new)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setAngle](#setangle)
- [setSnappingAngle](#setsnappingangle)
- [validate](#validate)
- [writeStream](#writestream)

### getAngle

**Description**

**Definition**

> getAngle()

**Code**

```lua
function AIParameterPositionAngle:getAngle()
    return self.angle
end

```

### getDirection

**Description**

**Definition**

> getDirection()

**Code**

```lua
function AIParameterPositionAngle:getDirection()
    if self.angle = = nil then
        return nil , nil
    end

    local xDir, zDir = MathUtil.getDirectionFromYRotation( self.angle)

    return xDir, zDir
end

```

### getSnappingAngle

**Description**

**Definition**

> getSnappingAngle()

**Code**

```lua
function AIParameterPositionAngle:getSnappingAngle()
    return self.snappingAngle
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterPositionAngle:getString()
    return string.format( "< %.1f , %.1f | %d° >" , self.x, self.z, math.deg( self.angle))
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
function AIParameterPositionAngle:loadFromXMLFile(xmlFile, key)
    AIParameterPositionAngle:superClass().loadFromXMLFile( self , xmlFile, key)

    self.angle = xmlFile:getFloat(key .. "#angle" , self.angle)
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | snappingAngle |
|-----|---------------|
| any | customMt      |

**Code**

```lua
function AIParameterPositionAngle.new(snappingAngle, customMt)
    local self = AIParameterPosition.new(customMt or AIParameterPositionAngle _mt)

    self.type = AIParameterType.POSITION_ANGLE

    self.angle = nil
    self.snappingAngle = math.abs(snappingAngle or math.rad( 5 ))

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
function AIParameterPositionAngle:readStream(streamId, connection)
    AIParameterPositionAngle:superClass().readStream( self , streamId, connection)

    if streamReadBool(streamId) then
        local angle = streamReadUIntN(streamId, 9 )
        self:setAngle( math.rad(angle))
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
function AIParameterPositionAngle:saveToXMLFile(xmlFile, key, usedModNames)
    AIParameterPositionAngle:superClass().saveToXMLFile( self , xmlFile, key, usedModNames)
    if self.angle ~ = nil then
        xmlFile:setFloat(key .. "#angle" , self.angle)
    end
end

```

### setAngle

**Description**

**Definition**

> setAngle()

**Arguments**

| any | angleRad |
|-----|----------|

**Code**

```lua
function AIParameterPositionAngle:setAngle(angleRad)
    angleRad = angleRad % ( 2 * math.pi)

    if angleRad < 0 then
        angleRad = angleRad + 2 * math.pi
    end

    if self.snappingAngle > 0 then
        local numSteps = MathUtil.round(angleRad / self.snappingAngle, 0 )
        angleRad = numSteps * self.snappingAngle
    end

    self.angle = angleRad
end

```

### setSnappingAngle

**Description**

**Definition**

> setSnappingAngle()

**Arguments**

| any | angle |
|-----|-------|

**Code**

```lua
function AIParameterPositionAngle:setSnappingAngle(angle)
    self.snappingAngle = math.abs(angle)
end

```

### validate

**Description**

**Definition**

> validate()

**Arguments**

| any | fillTypeIndex |
|-----|---------------|
| any | farmId        |

**Code**

```lua
function AIParameterPositionAngle:validate(fillTypeIndex, farmId)
    local isValid, errorMessage = AIParameterPositionAngle:superClass().validate( self , fillTypeIndex, farmId)
    if not isValid then
        return false , errorMessage
    end

    if self.angle = = nil then
        return false , g_i18n:getText( "ai_validationErrorNoAngle" )
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
function AIParameterPositionAngle:writeStream(streamId, connection)
    AIParameterPositionAngle:superClass().writeStream( self , streamId, connection)

    if streamWriteBool(streamId, self.angle ~ = nil ) then
        local angle = math.deg( self.angle)
        streamWriteUIntN(streamId, angle, 9 )
    end
end

```