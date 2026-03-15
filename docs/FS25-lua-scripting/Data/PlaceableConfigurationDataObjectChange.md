## PlaceableConfigurationDataObjectChange

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
function PlaceableConfigurationDataObjectChange.loadConfigItem(configItem, xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    configItem.postLoadObjectChange = xmlFile:getValue(baseKey .. "#postLoadObjectChange" , false )
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | placeable  |
|-----|------------|
| any | configItem |
| any | configId   |

**Code**

```lua
function PlaceableConfigurationDataObjectChange.onLoad(placeable, configItem, configId)
    if not configItem.postLoadObjectChange then
        local configurationDesc = g_placeableConfigurationManager:getConfigurationDescByName(configItem.configName)
        ObjectChangeUtil.updateObjectChanges(placeable.xmlFile, configurationDesc.configurationKey, configId, placeable.components, placeable)
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | placeable  |
|-----|------------|
| any | configItem |
| any | configId   |

**Code**

```lua
function PlaceableConfigurationDataObjectChange.onPostLoad(placeable, configItem, configId)
    if configItem.postLoadObjectChange then
        local configurationDesc = g_placeableConfigurationManager:getConfigurationDescByName(configItem.configName)
        ObjectChangeUtil.updateObjectChanges(placeable.xmlFile, configurationDesc.configurationKey, configId, placeable.components, placeable)
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
function PlaceableConfigurationDataObjectChange.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.BOOL, rootPath .. "#postLoadObjectChange" , "Defines if the object changes are applied before or after post load" , false )
        ObjectChangeUtil.registerObjectChangeXMLPaths(schema, configPath)
    end

```