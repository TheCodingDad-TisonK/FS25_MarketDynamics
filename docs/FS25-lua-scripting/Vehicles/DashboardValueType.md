## DashboardValueType

**Description**

> Animation value with one or multiple floats for AnimatedVehicle

**Functions**

- [getDefaultValue](#getdefaultvalue)
- [getValue](#getvalue)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [setAdditionalFunctions](#setadditionalfunctions)
- [setCenter](#setcenter)
- [setFunction](#setfunction)
- [setIdleValue](#setidlevalue)
- [setInterpolationSpeed](#setinterpolationspeed)
- [setPollUpdate](#setpollupdate)
- [setRange](#setrange)
- [setValue](#setvalue)
- [setValueCompare](#setvaluecompare)
- [setValueFactor](#setvaluefactor)
- [setXMLKey](#setxmlkey)

### getDefaultValue

**Description**

**Definition**

> getDefaultValue()

**Code**

```lua
function DashboardValueType:getDefaultValue()
    return nil
end

```

### getValue

**Description**

**Definition**

> getValue()

**Arguments**

| any | dashboard |
|-----|-----------|

**Code**

```lua
function DashboardValueType:getValue(dashboard)
    local value = self:getSourceValue(dashboard)

    if self.valueCompare ~ = nil then
        value = self.valueCompare[value] = = true
    end

    local isNumber = type(value) = = "number"

    local min , max , center
    if isNumber then
        if self.valueFactor ~ = nil then
            value = value * self.valueFactor
        end

        min = self:getMinValue(dashboard)
        max = self:getMaxValue(dashboard)

        center = self:getCenterValue(dashboard)
    end

    return value, min , max , center, isNumber
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | vehicle |

**Code**

```lua
function DashboardValueType:loadFromXML(xmlFile, vehicle)
    if self.xmlKey ~ = nil then
        vehicle:loadDashboardsFromXML(xmlFile, self.xmlKey, self )
    else
            local rootName = xmlFile:getRootName()
            vehicle:loadDashboardsFromXML(xmlFile, rootName .. "." .. self.specName .. ".dashboards" , self )
        end
    end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | specName |
|-----|----------|
| any | name     |
| any | customMt |

**Code**

```lua
function DashboardValueType.new(specName, name, customMt)
    local self = setmetatable( { } , customMt or DashboardValueType _mt)

    self.specName = specName
    self.name = name
    self.fullName = specName .. "." .. name

    self.pollUpdate = true

    self.valueObject = nil

    self.loadFunction = nil
    self.stateFunction = nil

    self.valueFactor = 1
    self.valueCompare = nil
    self.idleValue = nil

    self.getSourceValue = self.getDefaultValue
    self.getMinValue = self.getDefaultValue
    self.getMaxValue = self.getDefaultValue
    self.getCenterValue = self.getDefaultValue
    self.getInterpolationSpeed = self.getDefaultValue

    return self
end

```

### setAdditionalFunctions

**Description**

**Definition**

> setAdditionalFunctions()

**Arguments**

| any | loadFunction  |
|-----|---------------|
| any | stateFunction |

**Code**

```lua
function DashboardValueType:setAdditionalFunctions(loadFunction, stateFunction)
    self.loadFunction = loadFunction
    self.stateFunction = stateFunction
end

```

### setCenter

**Description**

**Definition**

> setCenter()

**Arguments**

| any | centerFunc |
|-----|------------|

**Code**

```lua
function DashboardValueType:setCenter(centerFunc)
    self:setFunction( "getCenterValue" , self.valueObject, centerFunc)
end

```

### setFunction

**Description**

**Definition**

> setFunction()

**Arguments**

| any | funcName |
|-----|----------|
| any | object   |
| any | value    |

**Code**

```lua
function DashboardValueType:setFunction(funcName, object, value)
    local func = nil

    if type(value) = = "number" or type(value) = = "boolean" then
        func = function (_ self )
            return value
        end
    elseif type(value) = = "function" then
            func = function (_ self , dashboard)
                return value(object, dashboard)
            end
        elseif type(value) = = "string" then
                if type(object[value]) = = "number" or type(object[value]) = = "boolean" then
                    func = function (_ self )
                        return object[value]
                    end
                elseif type(object[value]) = = "function" then
                        func = function (_ self , dashboard)
                            return object[value](object, dashboard)
                        end
                    end
                end

                if func ~ = nil then
                    self [funcName] = func
                end
            end

```

### setIdleValue

**Description**

**Definition**

> setIdleValue()

**Arguments**

| any | idleValue |
|-----|-----------|

**Code**

```lua
function DashboardValueType:setIdleValue(idleValue)
    self.idleValue = idleValue
end

```

### setInterpolationSpeed

**Description**

**Definition**

> setInterpolationSpeed()

**Arguments**

| any | interpolationSpeed |
|-----|--------------------|

**Code**

```lua
function DashboardValueType:setInterpolationSpeed(interpolationSpeed)
    self:setFunction( "getInterpolationSpeed" , self.valueObject, interpolationSpeed)
end

```

### setPollUpdate

**Description**

**Definition**

> setPollUpdate()

**Arguments**

| any | pollUpdate |
|-----|------------|

**Code**

```lua
function DashboardValueType:setPollUpdate(pollUpdate)
    self.pollUpdate = pollUpdate
end

```

### setRange

**Description**

**Definition**

> setRange()

**Arguments**

| any | min |
|-----|-----|
| any | max |

**Code**

```lua
function DashboardValueType:setRange( min , max )
    self:setFunction( "getMinValue" , self.valueObject, min )
    self:setFunction( "getMaxValue" , self.valueObject, max )
end

```

### setValue

**Description**

**Definition**

> setValue()

**Arguments**

| any | object |
|-----|--------|
| any | func   |

**Code**

```lua
function DashboardValueType:setValue(object, func)
    self.valueObject = object
    self:setFunction( "getSourceValue" , object, func)
end

```

### setValueCompare

**Description**

**Definition**

> setValueCompare()

**Arguments**

| any | ... |
|-----|-----|

**Code**

```lua
function DashboardValueType:setValueCompare( .. .)
    self.valueCompare = { }

    for i = 1 , select( "#" , .. .) do
        self.valueCompare[select(i, .. .)] = true
    end
end

```

### setValueFactor

**Description**

**Definition**

> setValueFactor()

**Arguments**

| any | valueFactor |
|-----|-------------|

**Code**

```lua
function DashboardValueType:setValueFactor(valueFactor)
    self.valueFactor = valueFactor
end

```

### setXMLKey

**Description**

**Definition**

> setXMLKey()

**Arguments**

| any | xmlKey |
|-----|--------|

**Code**

```lua
function DashboardValueType:setXMLKey(xmlKey)
    self.xmlKey = xmlKey
end

```