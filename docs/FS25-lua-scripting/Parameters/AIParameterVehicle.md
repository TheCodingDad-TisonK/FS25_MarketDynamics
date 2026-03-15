## AIParameterVehicle

**Parent**

> [AIParameter](?version=script&category=65&class=595)

**Functions**

- [getCanBeChanged](#getcanbechanged)
- [getString](#getstring)
- [getVehicle](#getvehicle)
- [new](#new)
- [readStream](#readstream)
- [saveToXMLFile](#savetoxmlfile)
- [setVehicle](#setvehicle)
- [validate](#validate)
- [writeStream](#writestream)

### getCanBeChanged

**Description**

**Definition**

> getCanBeChanged()

**Code**

```lua
function AIParameterVehicle:getCanBeChanged()
    return false
end

```

### getString

**Description**

**Definition**

> getString()

**Code**

```lua
function AIParameterVehicle:getString()
    local vehicle = NetworkUtil.getObject( self.vehicleId)
    if vehicle ~ = nil then
        return vehicle:getName()
    end

    return ""
end

```

### getVehicle

**Description**

**Definition**

> getVehicle()

**Code**

```lua
function AIParameterVehicle:getVehicle()
    local vehicle = NetworkUtil.getObject( self.vehicleId)
    if vehicle ~ = nil and vehicle:getIsSynchronized() then
        return vehicle
    end

    return nil
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
function AIParameterVehicle.new(customMt)
    local self = AIParameter.new(customMt or AIParameterVehicle _mt)

    self.type = AIParameterType.TEXT
    self.vehicleId = nil

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
function AIParameterVehicle:readStream(streamId, connection)
    if streamReadBool(streamId) then
        self.vehicleId = NetworkUtil.readNodeObjectId(streamId)
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
function AIParameterVehicle:saveToXMLFile(xmlFile, key, usedModNames)
    local vehicle = self:getVehicle()
    if vehicle ~ = nil then
        xmlFile:setString(key .. "#vehicleUniqueId" , vehicle:getUniqueId())
    end
end

```

### setVehicle

**Description**

**Definition**

> setVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function AIParameterVehicle:setVehicle(vehicle)
    self.vehicleId = NetworkUtil.getObjectId(vehicle)
end

```

### validate

**Description**

**Definition**

> validate()

**Arguments**

| any | needsAITarget |
|-----|---------------|

**Code**

```lua
function AIParameterVehicle:validate(needsAITarget)
    if self.vehicleId = = nil then
        return false , g_i18n:getText( "ai_validationErrorNoVehicle" )
    end

    local vehicle = self:getVehicle()
    if vehicle = = nil then
        return false , g_i18n:getText( "ai_validationErrorVehicleDoesNotExistAnymore" )
    elseif vehicle.setAITarget = = nil and(needsAITarget = = nil or needsAITarget = = true ) then
            return false , g_i18n:getText( "ai_validationErrorVehicleDoesNotSupportAI" )
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
function AIParameterVehicle:writeStream(streamId, connection)
    if streamWriteBool(streamId, self.vehicleId ~ = nil ) then
        NetworkUtil.writeNodeObjectId(streamId, self.vehicleId)
    end
end

```