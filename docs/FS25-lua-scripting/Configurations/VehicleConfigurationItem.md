## VehicleConfigurationItem

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
- [onPrePostLoad](#onprepostload)
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
function VehicleConfigurationItem:getNeedsRenaming(otherItem)
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
function VehicleConfigurationItem:loadFromSavegameXMLFile(xmlFile, key, configurationData)
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
function VehicleConfigurationItem:loadFromXML(xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    self.name = xmlFile:getValue(configKey .. "#name" , self.name, customEnvironment, false )
    local params = xmlFile:getValue(configKey .. "#params" )
    if params ~ = nil then
        self.name = g_i18n:insertTextParams( self.name, params, customEnvironment, xmlFile)
    end

    if self.name = = "" then
        self.name = tostring( self.index)
        self.hasDefaultName = true
    end

    self.configKey = configKey

    self.desc = xmlFile:getValue(configKey .. "#desc" , self.desc, customEnvironment, false )
    self.price = xmlFile:getValue(configKey .. "#price" , self.price)
    self.dailyUpkeep = xmlFile:getValue(configKey .. "#dailyUpkeep" , self.dailyUpkeep)
    self.isDefault = xmlFile:getValue(configKey .. "#isDefault" , self.isDefault)
    self.isSelectable = xmlFile:getValue(configKey .. "#isSelectable" , self.isSelectable)
    self.saveId = xmlFile:getValue(configKey .. "#saveId" , self.saveId)

    self.overwrittenTitle = xmlFile:getValue(baseKey .. "#title" , nil , customEnvironment, false )
    self.isYesNoOption = xmlFile:getValue(baseKey .. "#isYesNoOption" , self.isYesNoOption)

    local vehicleBrandName = xmlFile:getValue(configKey .. "#vehicleBrand" )
    self.vehicleBrand = g_brandManager:getBrandIndexByName(vehicleBrandName)

    self.vehicleName = xmlFile:getValue(configKey .. "#vehicleName" , nil , customEnvironment, false )
    local vehicleIcon = xmlFile:getValue(configKey .. "#vehicleIcon" )
    if vehicleIcon ~ = nil then
        self.vehicleIcon = Utils.getFilename(vehicleIcon, baseDirectory)

        if not textureFileExists( self.vehicleIcon) then
            Logging.xmlWarning(xmlFile, "Custom configuration vehicle icon '%s' not found." , self.vehicleIcon)
            self.vehicleIcon = nil
        end
    end

    local brandName = xmlFile:getValue(configKey .. "#displayBrand" )
    self.brandIndex = g_brandManager:getBrandIndexByName(brandName)

    self.shopTranslationOffset = xmlFile:getValue(configKey .. ".shopOffset#translation" , nil , true )
    self.shopRotationOffset = xmlFile:getValue(configKey .. ".shopOffset#rotation" , nil , true )

    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
        if data.loadConfigItem ~ = nil then
            data.loadConfigItem( self , xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
        end
    end

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
function VehicleConfigurationItem.new(configName, customMt)
    local self = setmetatable( { } , customMt or VehicleConfigurationItem _mt)

    self.configName = configName

    self.name = ""
    self.index = - 1
    self.hasDefaultName = false

    self.configKey = ""

    self.desc = nil
    self.price = 0
    self.dailyUpkeep = 0
    self.isDefault = false
    self.isSelectable = true
    self.saveId = nil
    self.isYesNoOption = false

    return self
end

```

### onLoad

**Description**

**Definition**

> onLoad()

**Arguments**

| any | object   |
|-----|----------|
| any | configId |

**Code**

```lua
function VehicleConfigurationItem:onLoad(object, configId)
    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
        if data.onLoad ~ = nil then
            data.onLoad(object, self , configId)
        end
    end
end

```

### onLoadFinished

**Description**

**Definition**

> onLoadFinished()

**Arguments**

| any | object   |
|-----|----------|
| any | configId |

**Code**

```lua
function VehicleConfigurationItem:onLoadFinished(object, configId)
    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
        if data.onLoadFinished ~ = nil then
            data.onLoadFinished(object, self , configId)
        end
    end
end

```

### onPostLoad

**Description**

**Definition**

> onPostLoad()

**Arguments**

| any | object   |
|-----|----------|
| any | configId |

**Code**

```lua
function VehicleConfigurationItem:onPostLoad(object, configId)
    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
        if data.onPostLoad ~ = nil then
            data.onPostLoad(object, self , configId)
        end
    end
end

```

### onPreLoad

**Description**

**Definition**

> onPreLoad()

**Arguments**

| any | object   |
|-----|----------|
| any | configId |

**Code**

```lua
function VehicleConfigurationItem:onPreLoad(object, configId)
    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
        if data.onPreLoad ~ = nil then
            data.onPreLoad(object, self , configId)
        end
    end
end

```

### onPrePostLoad

**Description**

**Definition**

> onPrePostLoad()

**Arguments**

| any | object   |
|-----|----------|
| any | configId |

**Code**

```lua
function VehicleConfigurationItem:onPrePostLoad(object, configId)
    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
        if data.onPrePostLoad ~ = nil then
            data.onPrePostLoad(object, self , configId)
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
function VehicleConfigurationItem:onSizeLoad(xmlFile, sizeData)
    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
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
function VehicleConfigurationItem.postLoad(xmlFile, baseKey, baseDir, customEnvironment, isMod, configurationItems, storeItem)
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
function VehicleConfigurationItem.registerSavegameXMLPaths(schema, basePath)
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
function VehicleConfigurationItem.registerXMLPaths(schema, rootPath, configPath)
    schema:register(XMLValueType.L10N_STRING, rootPath .. "#title" , "configuration title to display in shop" )
    schema:register(XMLValueType.BOOL, rootPath .. "#isYesNoOption" , "UI in the shop will just show a yes/no slider element" , false )

    schema:register(XMLValueType.L10N_STRING, configPath .. "#name" , "Configuration name" )
    schema:register(XMLValueType.STRING, configPath .. "#params" , "Extra parameters to insert in #name text" )
    schema:register(XMLValueType.L10N_STRING, configPath .. "#desc" , "Configuration description" )
    schema:register(XMLValueType.FLOAT, configPath .. "#price" , "Price of configuration" , 0 )
    schema:register(XMLValueType.FLOAT, configPath .. "#dailyUpkeep" , "Daily up keep with this configuration" , 0 )
    schema:register(XMLValueType.BOOL, configPath .. "#isDefault" , "Is selected by default in shop config screen" , false )
    schema:register(XMLValueType.BOOL, configPath .. "#isSelectable" , "Configuration can be selected in the shop" , true )
    schema:register(XMLValueType.STRING, configPath .. "#saveId" , "Custom save id" , "Number of configuration" )

    schema:register(XMLValueType.STRING, configPath .. "#displayBrand" , "If defined a brand icon is displayed in the shop config screen" )

    schema:register(XMLValueType.STRING, configPath .. "#vehicleBrand" , "Custom brand to display after bought with this configuration" )
    schema:register(XMLValueType.L10N_STRING, configPath .. "#vehicleName" , "Custom vehicle name to display after bought with this configuration" )
    schema:register(XMLValueType.STRING, configPath .. "#vehicleIcon" , "Custom icon to display after bought with this configuration" )

    schema:register(XMLValueType.VECTOR_TRANS, configPath .. ".shopOffset#translation" , "Shop translation offset when this config is used" )
    schema:register(XMLValueType.VECTOR_ROT, configPath .. ".shopOffset#rotation" , "Shop rotation offset when this config is used" )

    for _, data in ipairs( VehicleConfigurationItem.GLOBAL_DATA) do
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
function VehicleConfigurationItem:saveToXMLFile(xmlFile, key, isActive, configurationData)
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
function VehicleConfigurationItem:setIndex(index)
    self.index = index

    if self.saveId = = nil then
        self.saveId = tostring(index)
    end
end

```