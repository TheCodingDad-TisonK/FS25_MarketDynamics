## PlaceableConfigurationItem

**Description**

> Stores the data of a single configuration

**Functions**

- [getNeedsRenaming](#getneedsrenaming)
- [loadFromSavegameXMLFile](#loadfromsavegamexmlfile)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onLoad](#onload)
- [onLoadFinished](#onloadfinished)
- [onPostLoad](#onpostload)
- [onPreLoad](#onpreload)
- [onSizeLoad](#onsizeload)
- [postLoad](#postload)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [setIndex](#setindex)

### getNeedsRenaming

**Description**

**Definition**

> getNeedsRenaming()

**Arguments**

| any | otherItem |
|-----|-----------|

**Code**

```lua
function PlaceableConfigurationItem:getNeedsRenaming(otherItem)
    return self.name = = otherItem.name
end

```

### loadFromSavegameXMLFile

**Description**

**Definition**

> loadFromSavegameXMLFile()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | configurationData |

**Code**

```lua
function PlaceableConfigurationItem:loadFromSavegameXMLFile(xmlFile, key, configurationData)
end

```

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
function PlaceableConfigurationItem:loadFromXML(xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    self.name = xmlFile:getValue(configKey .. "#name" , nil , customEnvironment, false )
    local params = xmlFile:getValue(configKey .. "#params" )
    if params ~ = nil then
        self.name = g_i18n:insertTextParams( self.name, params, customEnvironment, xmlFile)
    end

    if self.name = = "" then
        self.name = configKey
    end

    self.configKey = configKey

    self.desc = xmlFile:getValue(configKey .. "#desc" , self.desc, customEnvironment, false )
    self.price = xmlFile:getValue(configKey .. "#price" , self.price)
    self.dailyUpkeep = xmlFile:getValue(configKey .. "#dailyUpkeep" , self.dailyUpkeep)
    self.isDefault = xmlFile:getValue(configKey .. "#isDefault" , self.isDefault)
    self.isSelectable = xmlFile:getValue(configKey .. "#isSelectable" , self.isSelectable)
    self.saveId = xmlFile:getValue(configKey .. "#saveId" , self.saveId)

    self.overwrittenTitle = xmlFile:getValue(baseKey .. "#title" , nil , customEnvironment, false )

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
function PlaceableConfigurationItem.new(configName, customMt)
    local self = setmetatable( { } , customMt or PlaceableConfigurationItem _mt)

    self.configName = configName

    self.name = ""
    self.index = - 1
    self.configKey = ""

    self.desc = nil
    self.price = 0
    self.dailyUpkeep = 0
    self.isDefault = false
    self.isSelectable = true
    self.saveId = nil

    return self
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | placeable |
|-----|-----------|
| any | configId  |

**Code**

```lua
function PlaceableConfigurationItem:onLoad(placeable, configId)
    for _, data in ipairs( PlaceableConfigurationItem.GLOBAL_DATA) do
        if data.onLoad ~ = nil then
            data.onLoad(placeable, self , configId)
        end
    end
end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | placeable |
|-----|-----------|
| any | configId  |

**Code**

```lua
function PlaceableConfigurationItem:onLoadFinished(placeable, configId)
    for _, data in ipairs( PlaceableConfigurationItem.GLOBAL_DATA) do
        if data.onLoadFinished ~ = nil then
            data.onLoadFinished(placeable, self , configId)
        end
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | placeable |
|-----|-----------|
| any | configId  |

**Code**

```lua
function PlaceableConfigurationItem:onPostLoad(placeable, configId)
    for _, data in ipairs( PlaceableConfigurationItem.GLOBAL_DATA) do
        if data.onPostLoad ~ = nil then
            data.onPostLoad(placeable, self , configId)
        end
    end
end

```

### onPreLoad

**Description**

**Definition**

> onPreLoad()

**Arguments**

| any | placeable |
|-----|-----------|
| any | configId  |

**Code**

```lua
function PlaceableConfigurationItem:onPreLoad(placeable, configId)
    for _, data in ipairs( PlaceableConfigurationItem.GLOBAL_DATA) do
        if data.onPreLoad ~ = nil then
            data.onPreLoad(placeable, self , configId)
        end
    end
end

```

### onSizeLoad

**Description**

**Definition**

> onSizeLoad()

**Arguments**

| any | xmlFile  |
|-----|----------|
| any | sizeData |

**Code**

```lua
function PlaceableConfigurationItem:onSizeLoad(xmlFile, sizeData)
    for _, data in ipairs( PlaceableConfigurationItem.GLOBAL_DATA) do
        if data.onSizeLoad ~ = nil then
            data.onSizeLoad( self , xmlFile, sizeData)
        end
    end
end

```

### postLoad

**Description**

**Definition**

> postLoad()

**Arguments**

| any | xmlFile            |
|-----|--------------------|
| any | baseKey            |
| any | baseDir            |
| any | customEnvironment  |
| any | isMod              |
| any | configurationItems |
| any | storeItem          |

**Code**

```lua
function PlaceableConfigurationItem.postLoad(xmlFile, baseKey, baseDir, customEnvironment, isMod, configurationItems, storeItem)
    for i = 1 , #configurationItems do
        local renameIndex = 0
        for j = 1 , #configurationItems do
            if configurationItems[i] ~ = configurationItems[j] then
                if configurationItems[i]:getNeedsRenaming(configurationItems[j]) then
                    configurationItems[i].renameIndex = (configurationItems[j].renameIndex or renameIndex) + 1
                end

                if configurationItems[i].saveId ~ = nil and configurationItems[i].saveId = = configurationItems[j].saveId then
                    Logging.xmlWarning(xmlFile, "Duplicated saveId '%s' in '%s' configurations" , configurationItems[i].saveId, configurationItems[i].configName)
                end
            end
        end
    end

    for i = 1 , #configurationItems do
        if configurationItems[i].renameIndex ~ = nil and configurationItems[i].renameIndex > 1 then
            configurationItems[i].name = string.format( "%s(%d)" , configurationItems[i].name, configurationItems[i].renameIndex)
            configurationItems[i].renameIndex = nil
        end
    end
end

```

### registerSavegameXMLPaths

**Description**

**Definition**

> registerSavegameXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function PlaceableConfigurationItem.registerSavegameXMLPaths(schema, basePath)
    schema:register(XMLValueType.STRING, basePath .. "#name" , "Name of configuration" )
    schema:register(XMLValueType.STRING, basePath .. "#id" , "Save id" )
    schema:register(XMLValueType.BOOL, basePath .. "#isActive" , "Configuration is currently active" )
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
function PlaceableConfigurationItem.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.L10N_STRING, rootPath .. "#title" , "configuration title to display in shop" )

    schema:register(XMLValueType.L10N_STRING, configPath .. "#name" , "Configuration name" )
    schema:register(XMLValueType.STRING, configPath .. "#params" , "Extra parameters to insert in #name text" )
    schema:register(XMLValueType.L10N_STRING, configPath .. "#desc" , "Configuration description" )
    schema:register(XMLValueType.FLOAT, configPath .. "#price" , "Price of configuration" , 0 )
    schema:register(XMLValueType.FLOAT, configPath .. "#dailyUpkeep" , "Daily up keep with this configuration" , 0 )
    schema:register(XMLValueType.BOOL, configPath .. "#isDefault" , "Is selected by default in shop config screen" , false )
    schema:register(XMLValueType.BOOL, configPath .. "#isSelectable" , "Configuration can be selected in the shop" , true )
    schema:register(XMLValueType.STRING, configPath .. "#saveId" , "Custom save id" , "Number of configuration" )

    for _, data in ipairs( PlaceableConfigurationItem.GLOBAL_DATA) do
        if data.registerXMLPaths ~ = nil then
            data.registerXMLPaths(schema, rootPath, configPath)
        end
    end
end

```

### saveToXMLFile

**Description**

**Definition**

> saveToXMLFile()

**Arguments**

| any | xmlFile           |
|-----|-------------------|
| any | key               |
| any | isActive          |
| any | configurationData |

**Code**

```lua
function PlaceableConfigurationItem:saveToXMLFile(xmlFile, key, isActive, configurationData)
    xmlFile:setValue(key .. "#name" , self.configName)
    xmlFile:setValue(key .. "#id" , self.saveId)
    xmlFile:setValue(key .. "#isActive" , Utils.getNoNil(isActive, false ))
end

```

### setIndex

**Description**

**Definition**

> setIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function PlaceableConfigurationItem:setIndex(index)
    self.index = index

    if self.saveId = = nil then
        self.saveId = tostring(index)
    end
end

```