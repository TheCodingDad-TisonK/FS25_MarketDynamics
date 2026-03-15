## VehicleConfigurationItemMotor

**Description**

> Stores the data for motor configurations

**Parent**

> [VehicleConfigurationItem](?version=script&category=16&class=182)

**Functions**

- [loadFromXML](#loadfromxml)
- [new](#new)
- [registerXMLPaths](#registerxmlpaths)

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | baseKey           |
| any | configKey         |
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function VehicleConfigurationItemMotor:loadFromXML(xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    if not VehicleConfigurationItemMotor:superClass().loadFromXML( self , xmlFile, baseKey, configKey, baseDirectory, customEnvironment) then
        return false
    end

    self.power = xmlFile:getValue(configKey .. "#hp" )
    self.maxSpeed = xmlFile:getValue(configKey .. "#maxSpeed" )
    self.consumerConfigurationIndex = xmlFile:getValue(configKey .. "#consumerConfigurationIndex" )

    return true
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | configName |
|-----|------------|
| any | customMt   |

**Code**

```lua
function VehicleConfigurationItemMotor.new(configName, customMt)
    local self = VehicleConfigurationItemMotor:superClass().new(configName, VehicleConfigurationItemMotor _mt)

    return self
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema     |
|-----|------------|
| any | rootPath   |
| any | configPath |

**Code**

```lua
function VehicleConfigurationItemMotor.registerXMLPaths(schema, rootPath, configPath)
    VehicleConfigurationItemMotor:superClass().registerXMLPaths(schema, rootPath, configPath)

    schema:register(XMLValueType.FLOAT, configPath .. "#hp" , "Horse power to be shown in the shop" )
    schema:register(XMLValueType.FLOAT, configPath .. "#maxSpeed" , "Max.speed to be shown in the shop" )
    schema:register(XMLValueType.INT, configPath .. "#consumerConfigurationIndex" , "Index of consumer configuration to be used" )
end

```