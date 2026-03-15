## VehicleConfigurationItemVehicleType

**Description**

> Stores the data of a single vehicle type configuration

**Parent**

> [VehicleConfigurationItem](?version=script&category=16&class=184)

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
function VehicleConfigurationItemVehicleType:loadFromXML(xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    if not VehicleConfigurationItemVehicleType:superClass().loadFromXML( self , xmlFile, baseKey, configKey, baseDirectory, customEnvironment) then
        return false
    end

    self.vehicleType = xmlFile:getValue(configKey .. "#vehicleType" )

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
function VehicleConfigurationItemVehicleType.new(configName, customMt)
    local self = VehicleConfigurationItemVehicleType:superClass().new(configName, VehicleConfigurationItemVehicleType _mt)

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
function VehicleConfigurationItemVehicleType.registerXMLPaths(schema, rootPath, configPath)
    VehicleConfigurationItemVehicleType:superClass().registerXMLPaths(schema, rootPath, configPath)

    schema:register(XMLValueType.STRING, configPath .. "#vehicleType" , "Vehicle type to be used" )
end

```