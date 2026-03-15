## VehicleConfigurationDataObjectChange

**Description**

> Adds object change functionality to all configurations

**Functions**

- [loadConfigItem](#loadconfigitem)
- [onLoad](#onload)
- [onPostLoad](#onpostload)
- [registerXMLPaths](#registerxmlpaths)

### loadConfigItem

**Description**

**Definition**

> loadConfigItem()

**Arguments**

| any | configItem        |
|-----|-------------------|
| any | xmlFile           |
| any | baseKey           |
| any | configKey         |
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function VehicleConfigurationDataObjectChange.loadConfigItem(configItem, xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    configItem.postLoadObjectChange = xmlFile:getValue(baseKey .. "#postLoadObjectChange" , false )
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | vehicle    |
|-----|------------|
| any | configItem |
| any | configId   |

**Code**

```lua
function VehicleConfigurationDataObjectChange.onLoad(vehicle, configItem, configId)
    if not configItem.postLoadObjectChange then
        local configurationDesc = g_vehicleConfigurationManager:getConfigurationDescByName(configItem.configName)
        ObjectChangeUtil.updateObjectChanges(vehicle.xmlFile, configurationDesc.configurationKey, configId, vehicle.components, vehicle)
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | vehicle    |
|-----|------------|
| any | configItem |
| any | configId   |

**Code**

```lua
function VehicleConfigurationDataObjectChange.onPostLoad(vehicle, configItem, configId)
    if configItem.postLoadObjectChange then
        local configurationDesc = g_vehicleConfigurationManager:getConfigurationDescByName(configItem.configName)
        ObjectChangeUtil.updateObjectChanges(vehicle.xmlFile, configurationDesc.configurationKey, configId, vehicle.components, vehicle)
    end
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
function VehicleConfigurationDataObjectChange.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.BOOL, rootPath .. "#postLoadObjectChange" , "Defines if the object changes are applied before or after post load(can be helpful if you manipulate wheel nodes, which is only possible before postLoad)" , false )
        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, configPath)
    end

```