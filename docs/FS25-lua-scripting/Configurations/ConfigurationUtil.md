## ConfigurationUtil

**Description**

> Configuration util class

**Functions**

- [addBoughtConfiguration](#addboughtconfiguration)
- [getClosestConfigurationSet](#getclosestconfigurationset)
- [getColorByConfigId](#getcolorbyconfigid)
- [getConfigIdBySaveId](#getconfigidbysaveid)
- [getConfigItemByConfigId](#getconfigitembyconfigid)
- [getConfigurationDataHasChanged](#getconfigurationdatahaschanged)
- [getConfigurationSetsFromXML](#getconfigurationsetsfromxml)
- [getConfigurationsFromXML](#getconfigurationsfromxml)
- [getConfigurationsMatchConfigSets](#getconfigurationsmatchconfigsets)
- [getConfigurationValue](#getconfigurationvalue)
- [getDefaultConfigIdFromItems](#getdefaultconfigidfromitems)
- [getSaveIdByConfigId](#getsaveidbyconfigid)
- [getSubConfigurationsFromConfigurations](#getsubconfigurationsfromconfigurations)
- [getXMLConfigurationKey](#getxmlconfigurationkey)
- [hasBoughtConfiguration](#hasboughtconfiguration)
- [isColorMetallic](#iscolormetallic)
- [loadConfigurationsFromXMLFile](#loadconfigurationsfromxmlfile)
- [raiseConfigurationItemEvent](#raiseconfigurationitemevent)
- [readConfigurationsFromStream](#readconfigurationsfromstream)
- [saveConfigurationsToXMLFile](#saveconfigurationstoxmlfile)
- [saveConfigurationToXMLFile](#saveconfigurationtoxmlfile)
- [setConfiguration](#setconfiguration)
- [writeConfigurationsToStream](#writeconfigurationstostream)

### addBoughtConfiguration

**Description**

> Add bought configuration

**Definition**

> addBoughtConfiguration(string name, integer id, , )

**Arguments**

| string  | name | of bought configuration type |
|---------|------|------------------------------|
| integer | id   | id of bought configuration   |
| any     | name |                              |
| any     | id   |                              |

**Code**

```lua
function ConfigurationUtil.addBoughtConfiguration(manager, object, name, id)
    if manager:getConfigurationIndexByName(name) ~ = nil then
        if object.boughtConfigurations[name] = = nil then
            object.boughtConfigurations[name] = { }
        end
        object.boughtConfigurations[name][id] = true
    end
end

```

### getClosestConfigurationSet

**Description**

**Definition**

> getClosestConfigurationSet()

**Arguments**

| any | configurations |
|-----|----------------|
| any | configSets     |

**Code**

```lua
function ConfigurationUtil.getClosestConfigurationSet(configurations, configSets)
    local closestSet = nil
    local closestSetMatches = 0
    for _, configSet in pairs(configSets) do
        local numMatches = 0
        for configName, index in pairs(configSet.configurations) do
            if configurations[configName] = = index then
                numMatches = numMatches + 1
            end
        end
        if numMatches > closestSetMatches then
            closestSet = configSet
            closestSetMatches = numMatches
        end
    end

    return closestSet, closestSetMatches
end

```

### getColorByConfigId

**Description**

> Returns color of config id

**Definition**

> getColorByConfigId(string configName, integer configId, )

**Arguments**

| string  | configName | name if config            |
|---------|------------|---------------------------|
| integer | configId   | id of config to get color |
| any     | configId   |                           |

**Return Values**

| any | color | color and material(r, g, b, mat) |
|-----|-------|----------------------------------|

**Code**

```lua
function ConfigurationUtil.getColorByConfigId(object, configName, configId)
    if configId ~ = nil then
        local item = g_storeManager:getItemByXMLFilename(object.configFileName)
        if item.configurations ~ = nil then
            local config = item.configurations[configName][configId]
            if config ~ = nil and config:isa( VehicleConfigurationItemColor ) then
                return config:getColor()
            end
        end
    end

    return nil
end

```

### getConfigIdBySaveId

**Description**

> Returns config id from given save identifier

**Definition**

> getConfigIdBySaveId(table object, string configName, string saveId)

**Arguments**

| table  | object     | object          |
|--------|------------|-----------------|
| string | configName | name if config  |
| string | saveId     | save identifier |

**Return Values**

| string | configId | config id |
|--------|----------|-----------|

**Code**

```lua
function ConfigurationUtil.getConfigIdBySaveId(configFileName, configName, configId)
    local item = g_storeManager:getItemByXMLFilename(configFileName)
    if item.configurations ~ = nil then
        local configs = item.configurations[configName]
        if configs ~ = nil then
            for j = 1 , #configs do
                if configs[j].saveId = = configId then
                    return configs[j].index
                end
            end

            local configItemClass = ClassUtil.getClassObjectByObject(configs[ 1 ])
            if configItemClass ~ = nil and configItemClass.getFallbackConfigId ~ = nil then
                local fallbackIndex, fallbackSaveId = configItemClass.getFallbackConfigId(configs, configId, configName, configFileName)
                if fallbackIndex ~ = nil then
                    Logging.info( "Unable to find %s configuration '%s' for object '%s'.Using config '%s' as closest match instead." , configName, configId, configFileName, fallbackSaveId)
                        return fallbackIndex
                    end
                end

                -- return first selectable config as fallback
                for j = 1 , #configs do
                    if configs[j].isSelectable ~ = false then
                        Logging.info( "Unable to find %s configuration '%s' for object '%s'.Using config '%s' instead." , configName, configId, configFileName, configs[j].saveId)
                            return configs[j].index
                        end
                    end
                end
            end

            return 1
        end

```

### getConfigItemByConfigId

**Description**

> Returns config item object of config id

**Definition**

> getConfigItemByConfigId(string configFileName, string configName, integer configId)

**Arguments**

| string  | configFileName | path to xml file of store item |
|---------|----------------|--------------------------------|
| string  | configName     | name if config                 |
| integer | configId       | id of config                   |

**Code**

```lua
function ConfigurationUtil.getConfigItemByConfigId(configFileName, configName, configId)
    if configId ~ = nil then
        local item = g_storeManager:getItemByXMLFilename(configFileName)
        if item.configurations ~ = nil then
            local configItems = item.configurations[configName]
            if configItems ~ = nil and configItems[configId] ~ = nil then
                return configItems[configId]
            end
        end
    end

    return nil
end

```

### getConfigurationDataHasChanged

**Description**

> Returns true if configuration data has changed

**Definition**

> getConfigurationDataHasChanged(string configFileName, table configurationData1, table configurationData2)

**Arguments**

| string | configFileName     | path to xml file of store item |
|--------|--------------------|--------------------------------|
| table  | configurationData1 | configuration data 1           |
| table  | configurationData2 | configuration data 2           |

**Return Values**

| table | hasChanged | configuration data has changed |
|-------|------------|--------------------------------|

**Code**

```lua
function ConfigurationUtil.getConfigurationDataHasChanged(configFileName, configurationData1, configurationData2)
    if configurationData1 = = nil and configurationData2 = = nil then
        return false
    end

    if configurationData1 = = nil or configurationData2 = = nil then
        return true
    end

    for configName, data in pairs(configurationData1) do
        if configurationData2[configName] = = nil then
            return true
        end

        for configId, configData in pairs(data) do
            if configurationData2[configName][configId] = = nil then
                return true
            end

            local configItem = ConfigurationUtil.getConfigItemByConfigId(configFileName, configName, configId)
            if configItem.hasDataChanged ~ = nil and configItem:hasDataChanged(configData, configurationData2[configName][configId]) then
                return true
            end
        end
    end

    return false
end

```

### getConfigurationSetsFromXML

**Description**

> Gets predefined configuration sets

**Definition**

> getConfigurationSetsFromXML(table storeItem, XMLFile xmlFile, string key, string baseDir, string customEnvironment,
> boolean isMod)

**Arguments**

| table   | storeItem         | a storeItem                                |
|---------|-------------------|--------------------------------------------|
| XMLFile | xmlFile           | XMLFile instance                           |
| string  | key               | the key of the base xml element            |
| string  | baseDir           | the base directory                         |
| string  | customEnvironment | a custom environment                       |
| boolean | isMod             | true if the storeitem is a mod, else false |

**Return Values**

| boolean | configuration | sets |
|---------|---------------|------|

**Code**

```lua
function ConfigurationUtil.getConfigurationSetsFromXML(storeItem, xmlFile, key, baseDir, customEnvironment, isMod)
    local configurationSetsKey = string.format( "%s.configurationSets" , key)
    local overwrittenTitle = xmlFile:getValue(configurationSetsKey .. "#title" , nil , customEnvironment, false )
    local isYesNoOption = xmlFile:getValue(configurationSetsKey .. "#isYesNoOption" , false )

    local configurationsSets = { }
    local i = 0
    while true do
        local configSetKey = string.format( "%s.configurationSet(%d)" , configurationSetsKey, i)
        if not xmlFile:hasProperty(configSetKey) then
            break
        end

        local configSet = { }
        configSet.name = xmlFile:getValue(configSetKey .. "#name" , nil , customEnvironment, false )

        local params = xmlFile:getValue(configSetKey .. "#params" )
        if params ~ = nil then
            configSet.name = g_i18n:insertTextParams(configSet.name, params, customEnvironment, xmlFile)
        end

        configSet.isDefault = xmlFile:getValue(configSetKey .. "#isDefault" , false )

        configSet.overwrittenTitle = overwrittenTitle
        configSet.isYesNoOption = isYesNoOption
        configSet.configurations = { }

        local j = 0
        while true do
            local configKey = string.format( "%s.configuration(%d)" , configSetKey, j)
            if not xmlFile:hasProperty(configKey) then
                break
            end

            local name = xmlFile:getValue(configKey .. "#name" )
            if name ~ = nil then
                if storeItem.configurations[name] ~ = nil then
                    local index = xmlFile:getValue(configKey .. "#index" )
                    if index ~ = nil then
                        if storeItem.configurations[name][index] ~ = nil then
                            configSet.configurations[name] = index
                        else
                                Logging.xmlWarning(xmlFile, "Index '%d' not defined for configuration '%s'!" , index, name)
                                end
                            end
                        elseif xmlFile:getValue(configKey .. "#showWarning" , true ) then
                                Logging.xmlWarning(xmlFile, "Configuration name '%s' is not defined!" , name)
                            end
                        else
                                Logging.xmlWarning(xmlFile, "Missing name for configuration set item '%s'!" , configSetKey)
                                end

                                j = j + 1
                            end

                            table.insert(configurationsSets, configSet)
                            configSet.index = #configurationsSets

                            i = i + 1
                        end

                        return configurationsSets
                    end

```

### getConfigurationsFromXML

**Description**

> Gets the storeitem configurations from xml

**Definition**

> getConfigurationsFromXML(XMLFile xmlFile, string key, string baseDir, string customEnvironment, boolean isMod, , )

**Arguments**

| XMLFile | xmlFile           | XMLFile instance                           |
|---------|-------------------|--------------------------------------------|
| string  | key               | the name of the base xml element           |
| string  | baseDir           | the base directory                         |
| string  | customEnvironment | a custom environment                       |
| boolean | isMod             | true if the storeitem is a mod, else false |
| any     | isMod             |                                            |
| any     | storeItem         |                                            |

**Return Values**

| any | configurations | a list of configurations |
|-----|----------------|--------------------------|

**Code**

```lua
function ConfigurationUtil.getConfigurationsFromXML(manager, xmlFile, key, baseDir, customEnvironment, isMod, storeItem)
    local configurations = { }
    local defaultConfigurationIds = { }
    local numConfigs = 0
    -- try to load default configuration values(title(shown in shop), name, desc, price) - additional parameters can be loaded with loadFunc

    local configurationDescs = manager:getConfigurations()
    for _, configurationDesc in pairs(configurationDescs) do
        local configurationItems = { }

        if configurationDesc.itemClass.preLoad ~ = nil then
            configurationDesc.itemClass.preLoad(xmlFile, configurationDesc.configurationsKey, baseDir, customEnvironment, isMod, configurationItems)
        end

        local i = 0
        while true do
            if i > 2 ^ ConfigurationUtil.SEND_NUM_BITS then
                Logging.xmlWarning(xmlFile, "Maximum number of configurations are reached for %s.Only %d configurations per type are allowed!" , configurationDesc.name, 2 ^ ConfigurationUtil.SEND_NUM_BITS)
                end
                local configKey = string.format(configurationDesc.configurationKey .. "(%d)" , i)
                if not xmlFile:hasProperty(configKey) then
                    break
                end

                local configItem = configurationDesc.itemClass.new(configurationDesc.name)
                configItem:setIndex(#configurationItems + 1 )
                if configItem:loadFromXML(xmlFile, configurationDesc.configurationsKey, configKey, baseDir, customEnvironment) then
                    table.insert(configurationItems, configItem)
                end

                i = i + 1
            end

            if configurationDesc.itemClass.postLoad ~ = nil then
                configurationDesc.itemClass.postLoad(xmlFile, configurationDesc.configurationsKey, baseDir, customEnvironment, isMod, configurationItems, storeItem, configurationDesc.name)
            end

            if #configurationItems > 0 then
                defaultConfigurationIds[configurationDesc.name] = ConfigurationUtil.getDefaultConfigIdFromItems(configurationItems)

                configurations[configurationDesc.name] = configurationItems
                numConfigs = numConfigs + 1
            end
        end
        if numConfigs = = 0 then
            return nil , nil
        end

        return configurations, defaultConfigurationIds
    end

```

### getConfigurationsMatchConfigSets

**Description**

**Definition**

> getConfigurationsMatchConfigSets()

**Arguments**

| any | configurations |
|-----|----------------|
| any | configSets     |

**Code**

```lua
function ConfigurationUtil.getConfigurationsMatchConfigSets(configurations, configSets)
    for _, configSet in pairs(configSets) do
        local isMatch = true
        for configName, index in pairs(configSet.configurations) do
            if configurations[configName] ~ = index then
                isMatch = false
                break
            end
        end

        if isMatch then
            return true
        end
    end

    return false
end

```

### getConfigurationValue

**Description**

> Get value of configuration

**Definition**

> getConfigurationValue(XMLFile xmlFile, string key, string subKey, string param, any defaultValue, string?
> fallbackConfigKey, string? fallbackOldgKey)

**Arguments**

| XMLFile | xmlFile           | XMLFile instance    |
|---------|-------------------|---------------------|
| string  | key               | key                 |
| string  | subKey            | sub key             |
| string  | param             | parameter           |
| any     | defaultValue      | default value       |
| string? | fallbackConfigKey | fallback config key |
| string? | fallbackOldgKey   | fallback old key    |

**Return Values**

| string? | value | value of config |
|---------|-------|-----------------|

**Code**

```lua
function ConfigurationUtil.getConfigurationValue(xmlFile, key, subKey, param, defaultValue, fallbackConfigKey, fallbackOldKey)
    if type(subKey) = = "table" then
        printCallstack()
    end
    local value = nil
    if key ~ = nil then
        value = xmlFile:getValue(key .. subKey .. param)
    end

    if value = = nil and fallbackConfigKey ~ = nil then
        value = xmlFile:getValue(fallbackConfigKey .. subKey .. param) -- Check for default configuration(xml index 0)
        end
        if value = = nil and fallbackOldKey ~ = nil then
            value = xmlFile:getValue(fallbackOldKey .. subKey .. param) -- Fallback to old xml setup
        end
        return Utils.getNoNil(value, defaultValue) -- using default value
    end

```

### getDefaultConfigIdFromItems

**Description**

> Get the default config id

**Definition**

> getDefaultConfigIdFromItems(table storeItem, string configurationName)

**Arguments**

| table  | storeItem         | a storeitem object        |
|--------|-------------------|---------------------------|
| string | configurationName | name of the configuration |

**Return Values**

| string | configId | the default config id |
|--------|----------|-----------------------|

**Code**

```lua
function ConfigurationUtil.getDefaultConfigIdFromItems(configItems)
    if configItems ~ = nil then
        for k, item in pairs(configItems) do
            if item.isDefault then
                if item.isSelectable ~ = false then
                    return k
                end
            end
        end

        for k, item in pairs(configItems) do
            if item.isSelectable ~ = false then
                return k
            end
        end
    end

    return 1
end

```

### getSaveIdByConfigId

**Description**

> Returns save identifier from given config id

**Definition**

> getSaveIdByConfigId(table object, string configName, integer configId)

**Arguments**

| table   | object     | object                    |
|---------|------------|---------------------------|
| string  | configName | name if config            |
| integer | configId   | id of config to get color |

**Return Values**

| integer | saveId | save identifier |
|---------|--------|-----------------|

**Code**

```lua
function ConfigurationUtil.getSaveIdByConfigId(configFileName, configName, configId)
    local item = g_storeManager:getItemByXMLFilename(configFileName)
    if item.configurations ~ = nil then
        local configs = item.configurations[configName]
        if configs ~ = nil then
            local config = configs[configId]
            if config ~ = nil then
                return config.saveId
            end
        end
    end

    return nil
end

```

### getSubConfigurationsFromConfigurations

**Description**

**Definition**

> getSubConfigurationsFromConfigurations()

**Arguments**

| any | manager        |
|-----|----------------|
| any | configurations |

**Code**

```lua
function ConfigurationUtil.getSubConfigurationsFromConfigurations(manager, configurations)
    local subConfigurations = nil

    if configurations ~ = nil then
        subConfigurations = { }

        for name, items in pairs(configurations) do
            local config = manager:getConfigurationDescByName(name)
            if config.hasSubselection then
                local subConfigValues = config.getSubConfigurationValuesFunc(items)
                if #subConfigValues > 1 then
                    local subConfigItemMapping = { }
                    subConfigurations[name] = { subConfigValues = subConfigValues, subConfigItemMapping = subConfigItemMapping }

                    for k, value in ipairs(subConfigValues) do
                        subConfigItemMapping[value] = config.getItemsBySubConfigurationIdentifierFunc(items, value)
                    end
                end
            end
        end
    end

    return subConfigurations
end

```

### getXMLConfigurationKey

**Description**

> Get xml configuration key

**Definition**

> getXMLConfigurationKey(XMLFile xmlFile, integer index, string key, string? defaultKey, string configurationKey)

**Arguments**

| XMLFile | xmlFile          | XMLFile instance  |
|---------|------------------|-------------------|
| integer | index            | index             |
| string  | key              | key               |
| string? | defaultKey       | default key       |
| string  | configurationKey | configuration key |

**Return Values**

| string | configKey   | key of configuration   |
|--------|-------------|------------------------|
| string | configIndex | index of configuration |

**Code**

```lua
function ConfigurationUtil.getXMLConfigurationKey(xmlFile, index, key, defaultKey, configurationKey)
    local configIndex = Utils.getNoNil(index, 1 )
    local configKey = string.format(key .. "(%d)" , configIndex - 1 )
    if index ~ = nil and not xmlFile:hasProperty(configKey) then
        printWarning( "Warning:Invalid " .. configurationKey .. " index '" .. tostring(index) .. "' in '" .. key .. "'.Using default " .. configurationKey .. " settings instead!" )
    end

    if not xmlFile:hasProperty(configKey) then
        configKey = key .. "(0)"
    end
    if not xmlFile:hasProperty(configKey) then
        configKey = defaultKey
    end

    return configKey, configIndex
end

```

### hasBoughtConfiguration

**Description**

> Returns true if configuration has been bought

**Definition**

> hasBoughtConfiguration(string name, integer id, )

**Arguments**

| string  | name | of bought configuration type |
|---------|------|------------------------------|
| integer | id   | id of bought configuration   |
| any     | id   |                              |

**Return Values**

| any | configurationHasBeenBought | configuration has been bought |
|-----|----------------------------|-------------------------------|

**Code**

```lua
function ConfigurationUtil.hasBoughtConfiguration(object, name, id)
    if object.boughtConfigurations[name] ~ = nil and object.boughtConfigurations[name][id] then
        return true
    end
    return false
end

```

### isColorMetallic

**Description**

> Get whether a material is visualized as metallic in UI

**Definition**

> isColorMetallic()

**Arguments**

| any | materialId |
|-----|------------|

**Code**

```lua
function ConfigurationUtil.isColorMetallic(materialId)
    return materialId = = 2
    or materialId = = 3
    or materialId = = 19
    or materialId = = 30
    or materialId = = 31
    or materialId = = 35
end

```

### loadConfigurationsFromXMLFile

**Description**

> Load all configurations from the given xml key

**Definition**

> loadConfigurationsFromXMLFile(string configFileName, table xmlFile, string key)

**Arguments**

| string | configFileName | path to xml file of store item |
|--------|----------------|--------------------------------|
| table  | xmlFile        | xml file object                |
| string | key            | key                            |

**Return Values**

| string | configurations       | configurations        |
|--------|----------------------|-----------------------|
| string | boughtConfigurations | bought configurations |
| string | configurationData    | configuration data    |

**Code**

```lua
function ConfigurationUtil.loadConfigurationsFromXMLFile(configFileName, xmlFile, key)
    local configurations = { }
    local boughtConfigurations = { }
    local configurationData = { }

    local item = g_storeManager:getItemByXMLFilename(configFileName)
    if item.configurations ~ = nil then
        for _, configKey in xmlFile:iterator(key) do
            local configName = xmlFile:getValue(configKey .. "#name" )
            local configId = xmlFile:getValue(configKey .. "#id" )
            local isActive = xmlFile:getValue(configKey .. "#isActive" , true )

            local configurationItems = item.configurations[configName]
            if configurationItems ~ = nil then
                local configurationItem = nil
                for j = 1 , #configurationItems do
                    if configurationItems[j].saveId = = configId then
                        configurationItem = configurationItems[j]
                    end
                end

                if configurationItem = = nil then
                    local configItemClass = ClassUtil.getClassObjectByObject(configurationItems[ 1 ])
                    if configItemClass ~ = nil and configItemClass.getFallbackConfigId ~ = nil then
                        local fallbackIndex, fallbackSaveId = configItemClass.getFallbackConfigId(configurationItems, configId, configName, configFileName)
                        if fallbackIndex ~ = nil then
                            Logging.info( "Unable to find %s configuration '%s' for object '%s'.Using config '%s' as closest match instead." , configName, configId, configFileName, fallbackSaveId)
                                configurationItem = configurationItems[fallbackIndex]
                            end
                        end
                    end

                    if configurationItem = = nil then
                        -- return first selectable config as fallback
                        for j = 1 , #configurationItems do
                            if configurationItems[j].isSelectable ~ = false then
                                Logging.info( "Unable to find %s configuration '%s' for object '%s'.Using config '%s' instead." , configName, configId, configFileName, configurationItems[j].saveId)
                                    configurationItem = configurationItems[j]
                                    break
                                end
                            end
                        end

                        if configurationItem ~ = nil then
                            if boughtConfigurations[configName] = = nil then
                                boughtConfigurations[configName] = { }
                            end
                            boughtConfigurations[configName][configurationItem.index] = true

                            if isActive then
                                configurations[configName] = configurationItem.index
                            end

                            if configurationData[configName] = = nil then
                                configurationData[configName] = { }
                            end

                            if configurationData[configName][configurationItem.index] = = nil then
                                configurationData[configName][configurationItem.index] = { }
                            end

                            configurationItem:loadFromSavegameXMLFile(xmlFile, configKey, configurationData[configName][configurationItem.index])
                        end
                    end
                end
            end

            return configurations, boughtConfigurations, configurationData
        end

```

### raiseConfigurationItemEvent

**Description**

> Calls the given eventName function on all configItem objects

**Definition**

> raiseConfigurationItemEvent(table object, string eventName)

**Arguments**

| table  | object    | vehicle/placeable object |
|--------|-----------|--------------------------|
| string | eventName | name of function to call |

**Code**

```lua
function ConfigurationUtil.raiseConfigurationItemEvent(object, eventName)
    local item = g_storeManager:getItemByXMLFilename(object.configFileName)
    if item.configurations ~ = nil and object.sortedConfigurationNames ~ = nil then
        for _, configName in ipairs(object.sortedConfigurationNames) do
            local configItems = item.configurations[configName]
            if configItems ~ = nil then
                local configId = object.configurations[configName]
                local configItem = configItems[configId]
                if configItem ~ = nil and configItem[eventName] ~ = nil then
                    configItem[eventName](configItem, object, configId)
                end
            end
        end
    end
end

```

### readConfigurationsFromStream

**Description**

> Reads all configurations from network stream

**Definition**

> readConfigurationsFromStream(table manager, integer streamId, table connection, string configFileName)

**Arguments**

| table   | manager        | configuration manager          |
|---------|----------------|--------------------------------|
| integer | streamId       | stream id                      |
| table   | connection     | connection                     |
| string  | configFileName | path to xml file of store item |

**Return Values**

| string | configurations       | configurations        |
|--------|----------------------|-----------------------|
| string | boughtConfigurations | bought configurations |
| string | configurationData    | configuration data    |

**Code**

```lua
function ConfigurationUtil.readConfigurationsFromStream(manager, streamId, connection, configFileName)
    local configurations = { }
    local boughtConfigurations = { }
    local configurationData = { }

    local numConfigs = streamReadUIntN(streamId, ConfigurationUtil.SEND_NUM_BITS)
    for _ = 1 , numConfigs do
        local configNameId = streamReadUIntN(streamId, ConfigurationUtil.SEND_NUM_BITS)
        local configName = manager:getConfigurationNameByIndex(configNameId + 1 )
        boughtConfigurations[configName] = { }

        local numConfigIds = streamReadUInt16(streamId)
        for _ = 1 , numConfigIds do
            local configId = streamReadUInt16(streamId) + 1
            boughtConfigurations[configName][configId] = true

            if streamReadBool(streamId) then
                configurations[configName] = configId
            end

            if streamReadBool(streamId) then
                local configItem = ConfigurationUtil.getConfigItemByConfigId(configFileName, configName, configId)
                if configItem ~ = nil then
                    if configurationData[configName] = = nil then
                        configurationData[configName] = { }
                    end

                    if configurationData[configName][configId] = = nil then
                        configurationData[configName][configId] = { }
                    end

                    configItem:readFromStream(streamId, connection, configurationData[configName][configId])
                else
                        Logging.error( "Unable to find configuration item for %s configuration '%s' with id %d on client side!" , configFileName, configName, configId)
                        end
                    end
                end
            end

            return configurations, boughtConfigurations, configurationData
        end

```

### saveConfigurationsToXMLFile

**Description**

> Saves the given configurations to the given xml file

**Definition**

> saveConfigurationsToXMLFile(string configFileName, table xmlFile, string key, table configurations, table
> configurationData, )

**Arguments**

| string | configFileName    | path to xml file of store item |
|--------|-------------------|--------------------------------|
| table  | xmlFile           | xml file object                |
| string | key               | key                            |
| table  | configurations    | configurations                 |
| table  | configurationData | configuration data             |
| any    | configurationData |                                |

**Code**

```lua
function ConfigurationUtil.saveConfigurationsToXMLFile(configFileName, xmlFile, key, configurations, boughtConfigurations, configurationData)
    local item = g_storeManager:getItemByXMLFilename(configFileName)
    if item.configurations ~ = nil then
        local xmlIndex = 0
        for configName, configsToSave in pairs(boughtConfigurations) do
            for index, _ in pairs(configsToSave) do
                local isActive = configurations[configName] = = index
                xmlIndex = ConfigurationUtil.saveConfigurationToXMLFile(item.configurations, configName, index, xmlFile, key, isActive, configurationData, xmlIndex)
            end
        end
    end
end

```

### saveConfigurationToXMLFile

**Description**

> Save the given single configuration to the given xml file

**Definition**

> saveConfigurationToXMLFile(table itemConfigurations, string configName, integer configId, table xmlFile, string key,
> boolean isActive, table configurationData, integer xmlIndex)

**Arguments**

| table   | itemConfigurations | item configurations             |
|---------|--------------------|---------------------------------|
| string  | configName         | name of configuration           |
| integer | configId           | id of configuration             |
| table   | xmlFile            | xml file object                 |
| string  | key                | key                             |
| boolean | isActive           | true if configuration is active |
| table   | configurationData  | configuration data              |
| integer | xmlIndex           | index of xml entry              |

**Return Values**

| integer | xmlIndex | new index of xml entry |
|---------|----------|------------------------|

**Code**

```lua
function ConfigurationUtil.saveConfigurationToXMLFile(itemConfigurations, configName, configId, xmlFile, key, isActive, configurationData, xmlIndex)
    local configKey = string.format( "%s(%d)" , key, xmlIndex)

    local configurationItems = itemConfigurations[configName]
    if configurationItems ~ = nil then
        local configurationItem = configurationItems[configId]
        if configurationItem ~ = nil then
            local data = configurationData[configName]
            if data ~ = nil then
                configurationItem:saveToXMLFile(xmlFile, configKey, isActive, data[configId])
                xmlIndex = xmlIndex + 1
            else
                    configurationItem:saveToXMLFile(xmlFile, configKey, isActive)
                    xmlIndex = xmlIndex + 1
                end
            end
        end

        return xmlIndex
    end

```

### setConfiguration

**Description**

> Set configuration value

**Definition**

> setConfiguration(string name, integer id, )

**Arguments**

| string  | name | name of configuration type |
|---------|------|----------------------------|
| integer | id   | id of configuration value  |
| any     | id   |                            |

**Code**

```lua
function ConfigurationUtil.setConfiguration(object, name, id)
    object.configurations[name] = id
end

```

### writeConfigurationsToStream

**Description**

> Writes all configurations to network stream

**Definition**

> writeConfigurationsToStream(table manager, integer streamId, table connection, string configFileName, table
> configurations, table boughtConfigurations, table configurationData)

**Arguments**

| table   | manager              | configuration manager          |
|---------|----------------------|--------------------------------|
| integer | streamId             | stream id                      |
| table   | connection           | connection                     |
| string  | configFileName       | path to xml file of store item |
| table   | configurations       | configurations                 |
| table   | boughtConfigurations | bought configurations          |
| table   | configurationData    | configuration data             |

**Code**

```lua
function ConfigurationUtil.writeConfigurationsToStream(manager, streamId, connection, configFileName, configurations, boughtConfigurations, configurationData)
    streamWriteUIntN(streamId, table.size(boughtConfigurations), ConfigurationUtil.SEND_NUM_BITS)
    for configName, configIds in pairs(boughtConfigurations) do
        local configNameId = manager:getConfigurationIndexByName(configName)
        streamWriteUIntN(streamId, configNameId - 1 , ConfigurationUtil.SEND_NUM_BITS)

        streamWriteUInt16(streamId, table.size(configIds))
        for configId, _ in pairs(configIds) do
            streamWriteUInt16(streamId, configId - 1 )
            streamWriteBool(streamId, configurations[configName] = = configId)

            local configItem = ConfigurationUtil.getConfigItemByConfigId(configFileName, configName, configId)
            if streamWriteBool(streamId, configItem ~ = nil and configItem.writeToStream ~ = nil ) then
                local data = configurationData[configName]
                if data ~ = nil then
                    configItem:writeToStream(streamId, connection, data[configId])
                else
                        configItem:writeToStream(streamId, connection)
                    end
                end
            end
        end
    end

```