## VehicleConfigurationDataDependentConfig

**Description**

> Adds the possibility to set other configs as dependent configurations to a configuration.

**Functions**

- [loadConfigItem](#loadconfigitem)
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
function VehicleConfigurationDataDependentConfig.loadConfigItem(configItem, xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    configItem.dependentConfigurations = { }

    for _, key in xmlFile:iterator(configKey .. ".dependentConfiguration" ) do
        local dependentConfiguration = { }
        dependentConfiguration.name = xmlFile:getValue(key .. "#name" )
        dependentConfiguration.index = xmlFile:getValue(key .. "#index" )
        if dependentConfiguration.name ~ = nil and dependentConfiguration.index ~ = nil then
            table.insert(configItem.dependentConfigurations, dependentConfiguration)
        end
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
function VehicleConfigurationDataDependentConfig.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.STRING, configPath .. ".dependentConfiguration(?)#name" , "Name of the other configuration to set" )
    schema:register(XMLValueType.INT, configPath .. ".dependentConfiguration(?)#index" , "Index of the configuration to use" )
end

```