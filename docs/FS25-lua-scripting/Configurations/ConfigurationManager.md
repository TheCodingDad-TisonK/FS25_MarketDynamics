## ConfigurationManager

**Description**

> This class handles all configuration types

**Parent**

> [AbstractManager](?version=script&category=16&class=175)

**Functions**

- [configurationKeyIterator](#configurationkeyiterator)
- [getConfigurationAttribute](#getconfigurationattribute)
- [getConfigurationDescByName](#getconfigurationdescbyname)
- [getConfigurationIndexByName](#getconfigurationindexbyname)
- [getConfigurationKeys](#getconfigurationkeys)
- [getConfigurationNameByIndex](#getconfigurationnamebyindex)
- [getConfigurations](#getconfigurations)
- [getConfigurationSelectorType](#getconfigurationselectortype)
- [getConfigurationTypes](#getconfigurationtypes)
- [getNumOfConfigurationTypes](#getnumofconfigurationtypes)
- [getSortedConfigurationTypes](#getsortedconfigurationtypes)
- [initDataStructures](#initdatastructures)
- [new](#new)

### configurationKeyIterator

**Description**

**Definition**

> configurationKeyIterator()

**Code**

```lua
function ConfigurationManager:configurationKeyIterator()
    local currentIndex = 0
    local numElements = # self.intToConfigurationName

    return function ()
        if currentIndex > = numElements then
            return nil
        end

        currentIndex = currentIndex + 1

        local name = self.intToConfigurationName[currentIndex]

        local configurationsKey, configurationKey = self:getConfigurationKeys(name)
        return configurationsKey, configurationKey .. "(?)"
    end
end

```

### getConfigurationAttribute

**Description**

> Returns configuration attribute by given name and attribute

**Definition**

> getConfigurationAttribute(string configurationName, string attribute)

**Arguments**

| string | configurationName | name of config    |
|--------|-------------------|-------------------|
| string | attribute         | name of attribute |

**Return Values**

| string | value | value of attribute |
|--------|-------|--------------------|

**Code**

```lua
function ConfigurationManager:getConfigurationAttribute(configurationName, attribute)
    local config = self:getConfigurationDescByName(configurationName)
    return config[attribute]
end

```

### getConfigurationDescByName

**Description**

> Returns configuration desc by name

**Definition**

> getConfigurationDescByName(string name)

**Arguments**

| string | name | name of config |
|--------|------|----------------|

**Return Values**

| string | configuration | configuration |
|--------|---------------|---------------|

**Code**

```lua
function ConfigurationManager:getConfigurationDescByName(name)
    return self.configurations[name]
end

```

### getConfigurationIndexByName

**Description**

> Returns configuration index by given name

**Definition**

> getConfigurationIndexByName(string name)

**Arguments**

| string | name | name of config |
|--------|------|----------------|

**Return Values**

| string | index | index of config |
|--------|-------|-----------------|

**Code**

```lua
function ConfigurationManager:getConfigurationIndexByName(name)
    return self.configurationNameToInt[name]
end

```

### getConfigurationKeys

**Description**

> Returns the xml keys for a given configuration name

**Definition**

> getConfigurationKeys(string configurationsKey, string configurationKey)

**Arguments**

| string | configurationsKey | Path to the main configuration element       |
|--------|-------------------|----------------------------------------------|
| string | configurationKey  | Path to the individual configuration element |

**Code**

```lua
function ConfigurationManager:getConfigurationKeys(configurationName)
    local config = self:getConfigurationDescByName(configurationName)
    if config ~ = nil then
        return config.configurationsKey, config.configurationKey
    end

    return nil , nil
end

```

### getConfigurationNameByIndex

**Description**

> Returns configuration name by given index

**Definition**

> getConfigurationNameByIndex(integer index)

**Arguments**

| integer | index | index of config |
|---------|-------|-----------------|

**Return Values**

| integer | name | name of config |
|---------|------|----------------|

**Code**

```lua
function ConfigurationManager:getConfigurationNameByIndex(index)
    return self.intToConfigurationName[index]
end

```

### getConfigurations

**Description**

> Returns table with all available configurations

**Definition**

> getConfigurations()

**Return Values**

| integer | configurations | configurations |
|---------|----------------|----------------|

**Code**

```lua
function ConfigurationManager:getConfigurations()
    return self.configurations
end

```

### getConfigurationSelectorType

**Description**

> Returns the selector type for a given configuration name

**Definition**

> getConfigurationSelectorType(string configurationName)

**Arguments**

| string | configurationName | name of config |
|--------|-------------------|----------------|

**Return Values**

| string | selectorType | Selector type |
|--------|--------------|---------------|

**Code**

```lua
function ConfigurationManager:getConfigurationSelectorType(configurationName)
    local config = self:getConfigurationDescByName(configurationName)
    if config ~ = nil then
        return config.itemClass.SELECTOR
    end

    return ConfigurationUtil.SELECTOR_MULTIOPTION
end

```

### getConfigurationTypes

**Description**

> Returns a table of the available configuration types

**Definition**

> getConfigurationTypes()

**Return Values**

| string | List | of configuration types (names) |
|--------|------|--------------------------------|

**Code**

```lua
function ConfigurationManager:getConfigurationTypes()
    return self.intToConfigurationName
end

```

### getNumOfConfigurationTypes

**Description**

> Returns number of configuration types

**Definition**

> getNumOfConfigurationTypes()

**Return Values**

| string | numOfConfigurationTypes | number of configuration types |
|--------|-------------------------|-------------------------------|

**Code**

```lua
function ConfigurationManager:getNumOfConfigurationTypes()
    return # self.intToConfigurationName
end

```

### getSortedConfigurationTypes

**Description**

> Returns a table of the available configuration types sorted by priority

**Definition**

> getSortedConfigurationTypes()

**Return Values**

| string | List | of configuration types (names) |
|--------|------|--------------------------------|

**Code**

```lua
function ConfigurationManager:getSortedConfigurationTypes()
    return self.sortedConfigurationNames
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function ConfigurationManager:initDataStructures()
    self.configurations = { }
    self.intToConfigurationName = { }
    self.configurationNameToInt = { }
    self.sortedConfigurationNames = { }
end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | typeName        |
|-----|-----------------|
| any | rootElementName |
| any | customMt        |

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function ConfigurationManager.new(typeName, rootElementName, customMt)
    local self = AbstractManager.new(customMt or ConfigurationManager _mt)

    self.typeName = typeName
    self.rootElementName = rootElementName
    self:initDataStructures()

    return self
end

```