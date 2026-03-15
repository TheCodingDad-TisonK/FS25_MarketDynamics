## VehicleConfigurationItemColor

**Description**

> Stores the data of a single color configuration

**Parent**

> [VehicleConfigurationItem](?version=script&category=16&class=181)

**Functions**

- [getColor](#getcolor)
- [getColorAndMaterialFromVehicle](#getcolorandmaterialfromvehicle)
- [getFallbackConfigId](#getfallbackconfigid)
- [getMaterial](#getmaterial)
- [getMaterialByColorConfiguration](#getmaterialbycolorconfiguration)
- [hasDataChanged](#hasdatachanged)
- [loadFromSavegameXMLFile](#loadfromsavegamexmlfile)
- [loadFromXML](#loadfromxml)
- [new](#new)
- [onPostLoad](#onpostload)
- [onSizeLoad](#onsizeload)
- [postLoad](#postload)
- [readFromStream](#readfromstream)
- [registerSavegameXMLPaths](#registersavegamexmlpaths)
- [registerXMLPaths](#registerxmlpaths)
- [saveToXMLFile](#savetoxmlfile)
- [updateMaterial](#updatematerial)
- [writeToStream](#writetostream)

### getColor

**Description**

**Definition**

> getColor()

**Code**

```lua
function VehicleConfigurationItemColor:getColor()
    return { self.color[ 1 ], self.color[ 2 ], self.color[ 3 ] }
end

```

### getColorAndMaterialFromVehicle

**Description**

**Definition**

> getColorAndMaterialFromVehicle()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleConfigurationItemColor:getColorAndMaterialFromVehicle(vehicle)
    local color, materialTemplateName = self.color, self.materialTemplateName

    local data = vehicle.configurationData[ self.configName]
    if data ~ = nil then
        local configurationData = data[ self.index]
        if configurationData ~ = nil then
            if configurationData.color ~ = nil then
                color = configurationData.color
            end

            if configurationData.materialTemplateName ~ = nil then
                materialTemplateName = configurationData.materialTemplateName
            end
        end
    end

    return color, materialTemplateName
end

```

### getFallbackConfigId

**Description**

**Definition**

> getFallbackConfigId()

**Arguments**

| any | configs        |
|-----|----------------|
| any | configId       |
| any | configName     |
| any | configFileName |

**Code**

```lua
function VehicleConfigurationItemColor.getFallbackConfigId(configs, configId, configName, configFileName)
    local numManualConfigs = 0
    for _, config in pairs(configs) do
        if config.isManualConfig then
            numManualConfigs = numManualConfigs + 1
        end
    end

    -- prior to patch 3, we used the color index as saveId, now we use the brand material name
    local configIndex = tonumber(configId)
    if configIndex ~ = nil then
        if configIndex > numManualConfigs then
            local brandMaterialName = VehicleConfigurationItemColor.DEFAULT_COLORS_PATCH_ 1 _ 2 [configIndex - numManualConfigs]
            for _, config in pairs(configs) do
                if config.saveId = = brandMaterialName then
                    return config.index, config.saveId
                end
            end
        end

        return nil , nil
    end

    return nil , nil
end

```

### getMaterial

**Description**

**Definition**

> getMaterial()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleConfigurationItemColor:getMaterial(vehicle)
    self:updateMaterial(vehicle)

    return self.material
end

```

### getMaterialByColorConfiguration

**Description**

**Definition**

> getMaterialByColorConfiguration()

**Arguments**

| any | vehicle    |
|-----|------------|
| any | configName |

**Code**

```lua
function VehicleConfigurationItemColor.getMaterialByColorConfiguration(vehicle, configName)
    local configId = vehicle.configurations[configName]
    if configId ~ = nil then
        local item = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
        if item.configurations ~ = nil then
            local configItems = item.configurations[configName]
            if configItems ~ = nil then
                local config = configItems[configId]
                if config ~ = nil and config:isa( VehicleConfigurationItemColor ) then
                    return config:getMaterial(vehicle)
                end
            end
        end
    end

    return nil
end

```

### hasDataChanged

**Description**

**Definition**

> hasDataChanged()

**Arguments**

| any | configurationData1 |
|-----|--------------------|
| any | configurationData2 |

**Code**

```lua
function VehicleConfigurationItemColor:hasDataChanged(configurationData1, configurationData2)
    if self.isCustomColor then
        if configurationData1.color ~ = nil and configurationData2.color ~ = nil then
            if math.abs(configurationData1.color[ 1 ] - configurationData2.color[ 1 ]) > 0.00001
                or math.abs(configurationData1.color[ 2 ] - configurationData2.color[ 2 ]) > 0.00001
                or math.abs(configurationData1.color[ 3 ] - configurationData2.color[ 3 ]) > 0.00001 then
                return true
            end
        elseif configurationData1.color ~ = nil or configurationData2.color ~ = nil then
                return true
            end

            if configurationData1.materialTemplateName ~ = configurationData2.materialTemplateName then
                return true
            end
        end

        return false
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
function VehicleConfigurationItemColor:loadFromSavegameXMLFile(xmlFile, key, configurationData)
    VehicleConfigurationItemColor:superClass().loadFromSavegameXMLFile( self , xmlFile, key, configurationData)

    if self.isCustomColor then
        configurationData.color = xmlFile:getValue(key .. "#color" , nil , true )
        configurationData.materialTemplateName = xmlFile:getValue(key .. "#materialTemplateName" )
    end
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
function VehicleConfigurationItemColor:loadFromXML(xmlFile, baseKey, configKey, baseDirectory, customEnvironment)
    if not VehicleConfigurationItemColor:superClass().loadFromXML( self , xmlFile, baseKey, configKey, baseDirectory, customEnvironment) then
        return false
    end

    local colorStr = xmlFile:getValue(configKey .. "#color" , nil , true )
    local color, title = g_vehicleMaterialManager:getMaterialTemplateColorAndTitleByName(colorStr, customEnvironment)
    if color ~ = nil then
        if self.hasDefaultName then
            self.name = title or self.name
        end
        self.color = color
    else
            self.color = string.getVector(colorStr)
            if self.color ~ = nil and # self.color ~ = 3 then
                Logging.xmlWarning(xmlFile, "Invalid rgb color '%s' in '%s'" , colorStr, configKey)
                self.color = nil
            end
        end

        self.uiColor = xmlFile:getValue(configKey .. "#uiColor" , nil , true )

        self.customEnvironment = customEnvironment

        self.materialTemplateName = xmlFile:getValue(configKey .. "#materialTemplateName" )

        self.isMetallic = xmlFile:getValue(configKey .. "#isMetallic" , false )
        self.isMat = xmlFile:getValue(configKey .. "#isMat" , false )

        if self.materialTemplateName ~ = nil then
            local color, title = g_vehicleMaterialManager:getMaterialTemplateColorAndTitleByName( self.materialTemplateName, customEnvironment)
            if color ~ = nil then
                self.color = self.color or color

                if self.hasDefaultName then
                    self.name = title or self.name
                end

                if string.contains( string.lower( self.materialTemplateName), "chrome" ) then
                    self.isMetallic = true
                    self.uiColor = { 0.3 , 0.3 , 0.3 }
                elseif string.contains( string.lower( self.materialTemplateName), "silver" ) then
                        self.uiColor = { 0.4 , 0.4 , 0.4 }
                    end
                else
                        Logging.xmlWarning(xmlFile, "Material template '%s' not defined for '%s'" , self.materialTemplateName, configKey)
                        end
                    end

                    if self.color = = nil then
                        self.color = { 1 , 1 , 1 }
                    end

                    self.uiColor = self.uiColor or self.color
                    self.isManualConfig = true

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
function VehicleConfigurationItemColor.new(configName, customMt)
    local self = VehicleConfigurationItemColor:superClass().new(configName, VehicleConfigurationItemColor _mt)

    self.isCustomColor = false
    self.isManualConfig = false

    return self
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
function VehicleConfigurationItemColor:onPostLoad(object, configId)
    VehicleConfigurationItemColor:superClass().onPostLoad( self , object, configId)

    local configurationDesc = g_vehicleConfigurationManager:getConfigurationDescByName( self.configName)
    object.xmlFile:iterate(configurationDesc.configurationsKey .. ".material" , function (index, materialKey)
        local material = VehicleMaterial.new(object.baseDirectory)

        local color, materialTemplateName = self:getColorAndMaterialFromVehicle(object)

        if object.xmlFile:getValue(materialKey .. "#useContrastColor" , false ) then
            local threshold = object.xmlFile:getValue(materialKey .. "#contrastThreshold" , 0.5 )
            local brightness = MathUtil.getBrightnessFromColor(color[ 1 ], color[ 2 ], color[ 3 ])
            if brightness > threshold then
                color = object.xmlFile:getValue(materialKey .. "#contrastColorDark" , "0 0 0" , true )
            else
                    color = object.xmlFile:getValue(materialKey .. "#contrastColorBright" , "0.9 0.9 0.9" , true )
                end
            end

            if object.xmlFile:getValue(materialKey .. "#materialTemplateName" , nil ) = = nil then
                if not object.xmlFile:getValue(materialKey .. "#materialTemplateUseColorOnly" , false ) then
                    material:setTemplateName(materialTemplateName, nil , object.customEnvironment)
                end

                material:setColor(color)
            end

            material:loadFromXML(object.xmlFile, materialKey, object.customEnvironment)
            if material.targetMaterialSlotName ~ = nil then
                if not material:applyToVehicle(object) then
                    Logging.xmlWarning(object.xmlFile, "Failed to find material by material slot name '%s' in '%s'" , material.targetMaterialSlotName, materialKey)
                end
            else
                    Logging.xmlWarning(object.xmlFile, "Missing material slot name in '%s'" , materialKey)
                end
            end )
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
function VehicleConfigurationItemColor:onSizeLoad(xmlFile, sizeData)
    -- exclude dynamic color configurations without xml definition
    if self.configKey ~ = "" then
        VehicleConfigurationItemColor:superClass().onSizeLoad( self , xmlFile, sizeData)
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
| any | configName         |

**Code**

```lua
function VehicleConfigurationItemColor.postLoad(xmlFile, baseKey, baseDir, customEnvironment, isMod, configurationItems, storeItem, configName)
    VehicleConfigurationItemColor:superClass().postLoad(xmlFile, baseKey, baseDir, customEnvironment, isMod, configurationItems, storeItem, configName)

    local defaultColorIndex = xmlFile:getValue(baseKey .. "#defaultColorIndex" )

    if xmlFile:getValue(baseKey .. "#useDefaultColors" , false ) or(g_modIsLoaded[ "FS25_unlimitedColorConfigurations" ] and #configurationItems > 0 ) then
        local price = xmlFile:getValue(baseKey .. "#price" , 0 )

        local defaultColorMaterialTemplateName = xmlFile:getValue(baseKey .. "#defaultColorMaterialTemplateName" , "calibratedPaint" )
        for _, configItem in ipairs(configurationItems) do
            if configItem.materialTemplateName = = nil then
                configItem.materialTemplateName = defaultColorMaterialTemplateName
            end
        end

        for i, brandMaterialName in pairs( VehicleConfigurationItemColor.DEFAULT_COLORS) do
            local color, title = g_vehicleMaterialManager:getMaterialTemplateColorAndTitleByName(brandMaterialName, customEnvironment)
            if color ~ = nil then
                local configItem = VehicleConfigurationItemColor.new(configName)

                configItem.name = title or configItem.name

                if i = = defaultColorIndex then
                    configItem.isDefault = true
                    configItem.price = 0
                else
                        configItem.price = price
                    end

                    configItem.color = color
                    configItem.uiColor = color
                    configItem.materialTemplateName = defaultColorMaterialTemplateName
                    configItem.isMetallic = false
                    configItem.isMat = false
                    configItem.saveId = brandMaterialName

                    table.insert(configurationItems, configItem)
                    configItem:setIndex(#configurationItems)
                end
            end

            local configItem = VehicleConfigurationItemColor.new(configName)

            configItem.name = g_i18n:getText( "ui_colorPicker_custom" )

            configItem.price = price

            configItem.color = { 1 , 1 , 1 , 1 }
            configItem.uiColor = { 1 , 1 , 1 , 1 }
            configItem.materialTemplateName = "calibratedPaint"
            configItem.isCustomColor = true
            configItem.isSelectable = false
            configItem.isMetallic = false
            configItem.isMat = false
            configItem.saveId = "CUSTOM_COLOR"

            table.insert(configurationItems, configItem)
            configItem:setIndex(#configurationItems)
        end

        if defaultColorIndex = = nil then
            local defaultIsDefined = false
            for _, configItem in ipairs(configurationItems) do
                if configItem.isDefault ~ = nil and configItem.isDefault then
                    defaultIsDefined = true
                end
            end

            if not defaultIsDefined then
                if #configurationItems > 0 then
                    configurationItems[ 1 ].isDefault = true
                    configurationItems[ 1 ].price = 0
                end
            end
        end
    end

```

### readFromStream

**Description**

**Definition**

> readFromStream()

**Arguments**

| any | streamId          |
|-----|-------------------|
| any | connection        |
| any | configurationData |

**Code**

```lua
function VehicleConfigurationItemColor:readFromStream(streamId, connection, configurationData)
    if self.isCustomColor then
        local r, g, b = NetworkUtil.readCompressedColor(streamId)
        configurationData.color = { r, g, b }

        local templateIndex = streamReadUIntN(streamId, VehicleMaterialManager.NUM_BITS_TEMPLATE)
        configurationData.materialTemplateName = g_vehicleMaterialManager:getMaterialTemplateNameByIndex(templateIndex)
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
function VehicleConfigurationItemColor.registerSavegameXMLPaths(schema, basePath)
    VehicleConfigurationItemColor:superClass().registerSavegameXMLPaths(schema, basePath)

    schema:register(XMLValueType.VECTOR_ 3 , basePath .. "#color" , "Configuration color" , "1 1 1" )
    schema:register(XMLValueType.STRING, basePath .. "#materialTemplateName" , "Name of material template to use" )
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
function VehicleConfigurationItemColor.registerXMLPaths(schema, rootPath, configPath)
    VehicleConfigurationItemColor:superClass().registerXMLPaths(schema, rootPath, configPath)

    schema:register(XMLValueType.INT, rootPath .. "#defaultColorIndex" , "Default color index on start" )
    schema:register(XMLValueType.BOOL, rootPath .. "#useDefaultColors" , "Use default colors" , false )
    schema:register(XMLValueType.INT, rootPath .. "#price" , "Price of the default colors" , 0 )
    schema:register(XMLValueType.STRING, rootPath .. "#defaultColorMaterialTemplateName" , "Base template for all default colors and for configs that have just a 'color' attribute defined" , "calibratedPaint" )

        VehicleMaterial.registerXMLPaths(schema, rootPath .. ".material(?)" )

        schema:register(XMLValueType.BOOL, rootPath .. ".material(?)#useContrastColor" , "Use contrast color" , false )
        schema:register(XMLValueType.FLOAT, rootPath .. ".material(?)#contrastThreshold" , "Color brightness threshold to switch to contrast color" , 0.5 )
        schema:register(XMLValueType.COLOR, rootPath .. ".material(?)#contrastColorDark" , "Color to be used when the brightness is below the threshold" , "0 0 0" )
        schema:register(XMLValueType.COLOR, rootPath .. ".material(?)#contrastColorBright" , "Color to be used when the brightness is above the threshold" , "0.9 0.9 0.9" )

        schema:register(XMLValueType.STRING, configPath .. "#color" , "Configuration color" , "1 1 1 1" )
        schema:register(XMLValueType.COLOR, configPath .. "#uiColor" , "Configuration UI color" , "1 1 1 1" )
        schema:register(XMLValueType.BOOL, configPath .. "#isMetallic" , "Color is metallic color(Only for UI)" , false )
            schema:register(XMLValueType.BOOL, configPath .. "#isMat" , "Color is mat color(Only for UI)" , false )
                schema:register(XMLValueType.STRING, configPath .. "#materialTemplateName" , "Name of material template to use" )
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
function VehicleConfigurationItemColor:saveToXMLFile(xmlFile, key, isActive, configurationData)
    VehicleConfigurationItemColor:superClass().saveToXMLFile( self , xmlFile, key, isActive, configurationData)

    if self.isCustomColor then
        if configurationData.color ~ = nil then
            xmlFile:setValue(key .. "#color" , configurationData.color[ 1 ], configurationData.color[ 2 ], configurationData.color[ 3 ])
        end

        if configurationData.materialTemplateName ~ = nil then
            xmlFile:setValue(key .. "#materialTemplateName" , configurationData.materialTemplateName)
        end
    end
end

```

### updateMaterial

**Description**

**Definition**

> updateMaterial()

**Arguments**

| any | vehicle |
|-----|---------|

**Code**

```lua
function VehicleConfigurationItemColor:updateMaterial(vehicle)
    -- custom colors always need to be recreated as the color values might have changed
    if self.material = = nil or self.isCustomColor then
        self.material = VehicleMaterial.new()

        local color, materialTemplateName = self:getColorAndMaterialFromVehicle(vehicle)

        if materialTemplateName ~ = nil then
            self.material:setTemplateName(materialTemplateName, nil , self.customEnvironment)
        end

        self.material:setColor(color)
    end
end

```

### writeToStream

**Description**

**Definition**

> writeToStream()

**Arguments**

| any | streamId          |
|-----|-------------------|
| any | connection        |
| any | configurationData |

**Code**

```lua
function VehicleConfigurationItemColor:writeToStream(streamId, connection, configurationData)
    if self.isCustomColor then
        local r, g, b = 1 , 1 , 1
        if configurationData.color ~ = nil then
            r, g, b = configurationData.color[ 1 ], configurationData.color[ 2 ], configurationData.color[ 3 ]
        end

        NetworkUtil.writeCompressedColor(streamId, r, g, b)

        local templateIndex = g_vehicleMaterialManager:getMaterialTemplateIndexByName(configurationData.materialTemplateName)
        streamWriteUIntN(streamId, math.clamp(templateIndex, 0 , VehicleMaterialManager.MAX_TEMPLATE_INDEX), VehicleMaterialManager.NUM_BITS_TEMPLATE)
    end
end

```