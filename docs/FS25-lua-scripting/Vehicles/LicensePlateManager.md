## LicensePlateManager

**Description**

> This class manages the license plates for each map

**Parent**

> [AbstractManager](?version=script&category=91&class=885)

**Functions**

- [createLicensePlateXMLSchema](#createlicenseplatexmlschema)
- [getAreLicensePlatesAvailable](#getarelicenseplatesavailable)
- [getAvailableColors](#getavailablecolors)
- [getDefaultPlacementIndex](#getdefaultplacementindex)
- [getFont](#getfont)
- [getLicensePlate](#getlicenseplate)
- [getLicensePlateValues](#getlicenseplatevalues)
- [getRandomLicensePlateData](#getrandomlicenseplatedata)
- [initDataStructures](#initdatastructures)
- [licensePlateI3DFileLoaded](#licenseplatei3dfileloaded)
- [loadLicensePlateDataFromXML](#loadlicenseplatedatafromxml)
- [loadLicensePlatesFromXML](#loadlicenseplatesfromxml)
- [loadMapData](#loadmapdata)
- [new](#new)
- [readLicensePlateData](#readlicenseplatedata)
- [saveLicensePlateDataToXML](#savelicenseplatedatatoxml)
- [unloadMapData](#unloadmapdata)
- [writeLicensePlateData](#writelicenseplatedata)

### createLicensePlateXMLSchema

**Description**

> Create license plate xml schema

**Definition**

> createLicensePlateXMLSchema()

**Code**

```lua
function LicensePlateManager.createLicensePlateXMLSchema()
    if LicensePlateManager.xmlSchema = = nil then
        local schema = XMLSchema.new( "mapLicensePlates" )

        LicensePlate.registerXMLPaths(schema, "licensePlates.licensePlate(?)" )

        schema:register(XMLValueType.STRING, "licensePlates.font#name" , "License plate font name" , "GENERIC" )

        schema:register(XMLValueType.STRING, "licensePlates.colorConfigurations#materialName" , "Name of colored license plate material" , "licensePlateColored_mat" )
        schema:register(XMLValueType.STRING, "licensePlates.colorConfigurations#shaderParameterCharacters" , "Color shader parameter of characters" , "colorSale" )
        schema:register(XMLValueType.BOOL, "licensePlates.colorConfigurations#useDefaultColors" , "License plate can be colored with all available default colors" , false )
        schema:register(XMLValueType.INT, "licensePlates.colorConfigurations#defaultColorIndex" , "Default selected color" )
        schema:register(XMLValueType.FLOAT, "licensePlates.colorConfigurations#defaultColorMaxBrightness" , "Default colors with higher brightness will be skipped" , 0.55 )
        schema:register(XMLValueType.L10N_STRING, "licensePlates.colorConfigurations.colorConfiguration(?)#name" , "Name of color to display" )
        schema:register(XMLValueType.COLOR, "licensePlates.colorConfigurations.colorConfiguration(?)#color" , "Color values" )
        schema:register(XMLValueType.BOOL, "licensePlates.colorConfigurations.colorConfiguration(?)#isDefault" , "Color is default selected" )

        schema:register(XMLValueType.STRING, "licensePlates.placement#defaultType" , "Default type of placement(none/both/back_only)" , "both" )

        LicensePlateManager.xmlSchema = schema
    end
end

```

### getAreLicensePlatesAvailable

**Description**

> Returns of license plates are available for placement

**Definition**

> getAreLicensePlatesAvailable()

**Return Values**

| any | available | available |
|-----|-----------|-----------|

**Code**

```lua
function LicensePlateManager:getAreLicensePlatesAvailable()
    return self.licensePlatesAvailable and g_materialManager:getFontMaterial( self.fontName, self.customEnvironment)
end

```

### getAvailableColors

**Description**

> Returns the available colors and the default color index

**Definition**

> getAvailableColors()

**Return Values**

| any | colors            | colors                 |
|-----|-------------------|------------------------|
| any | defaultColorIndex | index of default color |

**Code**

```lua
function LicensePlateManager:getAvailableColors()
    return self.colors, self.defaultColorIndex
end

```

### getDefaultPlacementIndex

**Description**

> Returns default placement option index

**Definition**

> getDefaultPlacementIndex()

**Return Values**

| any | defaultIndex | default placement index |
|-----|--------------|-------------------------|

**Code**

```lua
function LicensePlateManager:getDefaultPlacementIndex()
    return self.defaultPlacementIndex
end

```

### getFont

**Description**

> Returns license plate font

**Definition**

> getFont()

**Return Values**

| any | font | font data |
|-----|------|-----------|

**Code**

```lua
function LicensePlateManager:getFont()
    return g_materialManager:getFontMaterial( self.fontName, self.customEnvironment)
end

```

### getLicensePlate

**Description**

> Returns a license plate from given type

**Definition**

> getLicensePlate(integer preferedType, boolean? includeFrame)

**Arguments**

| integer  | preferedType | prefered type to use            |
|----------|--------------|---------------------------------|
| boolean? | includeFrame | include a frame, default: false |

**Return Values**

| boolean? | licensePlate | copy of license plate |
|----------|--------------|-----------------------|

**Code**

```lua
function LicensePlateManager:getLicensePlate(preferedType, includeFrame)
    local licensePlate = self.licensePlates[ 1 ]
    for i = 1 , # self.licensePlates do
        if self.licensePlates[i].type = = preferedType then
            licensePlate = self.licensePlates[i]
        end
    end

    if licensePlate ~ = nil then
        return licensePlate:clone(includeFrame)
    end

    return nil
end

```

### getLicensePlateValues

**Description**

> Returns license plate values from given variation index

**Definition**

> getLicensePlateValues(table licensePlate, integer variationIndex)

**Arguments**

| table   | licensePlate   | license plate data |
|---------|----------------|--------------------|
| integer | variationIndex | variation index    |

**Return Values**

| integer | values | values |
|---------|--------|--------|

**Code**

```lua
function LicensePlateManager:getLicensePlateValues(licensePlate, variationIndex)
    local variation = licensePlate.variations[variationIndex]
    if variation ~ = nil then
        return variation.values
    end

    return nil
end

```

### getRandomLicensePlateData

**Description**

> Returns random license plate data (variation, characters, colorIndex, placementIndex)

**Definition**

> getRandomLicensePlateData()

**Return Values**

| integer | data | random license plate data |
|---------|------|---------------------------|

**Code**

```lua
function LicensePlateManager:getRandomLicensePlateData()
    local licensePlate = self.licensePlates[ 1 ]
    if licensePlate ~ = nil then
        local variationIndex = 1
        local characters = licensePlate:getRandomCharacters(variationIndex)
        local colorIndex = self.defaultColorIndex

        return { variation = variationIndex, characters = characters, colorIndex = colorIndex, placementIndex = self:getDefaultPlacementIndex() }
    end

    return { variation = 1 , characters = nil , colorIndex = nil , placementIndex = self:getDefaultPlacementIndex() }
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function LicensePlateManager:initDataStructures()
    self.licensePlates = { }
    self.colorConfigurations = { }
    self.licensePlatesAvailable = false
    self.sharedLoadRequestIds = { }
end

```

### licensePlateI3DFileLoaded

**Description**

> License plate i3d file loaded

**Definition**

> licensePlateI3DFileLoaded(entityId i3dNode, integer failedReason, table? args)

**Arguments**

| entityId | i3dNode      | i3d node  |
|----------|--------------|-----------|
| integer  | failedReason | i3d node  |
| table?   | args         | arguments |

**Code**

```lua
function LicensePlateManager:licensePlateI3DFileLoaded(i3dNode, failedReason, args)
    local filename = args.filename
    local xmlFile = args.xmlFile
    local plateKey = args.plateKey
    local customEnvironment = args.customEnvironment

    if i3dNode ~ = nil and i3dNode ~ = 0 then
        local node = xmlFile:getValue(plateKey .. "#node" , nil , i3dNode)
        if node ~ = nil then
            unlink(node)

            local licensePlate = LicensePlate.new()
            if licensePlate:loadFromXML(node, filename, customEnvironment, xmlFile, plateKey) then
                table.insert( self.licensePlates, licensePlate)
            end
        end

        delete(i3dNode)
    end

    self.xmlReferences = self.xmlReferences - 1
    if self.xmlReferences = = 0 then
        xmlFile:delete()
        self.licensePlatesAvailable = # self.licensePlates > 0
        if xmlFile = = self.licensePlateXML then
            self.licensePlateXML = nil
        end
    end
end

```

### loadLicensePlateDataFromXML

**Description**

**Definition**

> loadLicensePlateDataFromXML(XMLFile xmlFile, string key, boolean useAbsolutePaths)

**Arguments**

| XMLFile | xmlFile          |
|---------|------------------|
| string  | key              |
| boolean | useAbsolutePaths |

**Return Values**

| boolean | licensePlateData |
|---------|------------------|

**Code**

```lua
function LicensePlateManager.loadLicensePlateDataFromXML(xmlFile, key, useAbsolutePaths)
    local valid = xmlFile:hasProperty(key .. "#variation" )
    if valid then
        local licensePlateData = { }
        if useAbsolutePaths then
            licensePlateData.xmlFilename = xmlFile:getString(key .. "#configuration" )
        else
                licensePlateData.xmlFilename = NetworkUtil.convertFromNetworkFilename(xmlFile:getString(key .. "#configuration" ))
            end
            licensePlateData.variation = xmlFile:getInt(key .. "#variation" )
            licensePlateData.colorIndex = xmlFile:getInt(key .. "#color" )
            licensePlateData.placementIndex = xmlFile:getInt(key .. "#placement" )

            -- local font = g_licensePlateManager:getFont()

            licensePlateData.characters = { }
            local characters = xmlFile:getString(key .. "#characters" )
            local characterLength = characters:len() -- TODO:not utf8 compatible
            for i = 1 , characterLength do
                table.insert(licensePlateData.characters, characters:sub(i, i)) -- TODO:not utf8 compatible
            end

            return licensePlateData
        else
                return nil
            end
        end

```

### loadLicensePlatesFromXML

**Description**

> Load license plates from xml

**Definition**

> loadLicensePlatesFromXML(table xmlFile, string baseDirectory)

**Arguments**

| table  | xmlFile       | xml file object |
|--------|---------------|-----------------|
| string | baseDirectory | base directory  |

**Code**

```lua
function LicensePlateManager:loadLicensePlatesFromXML(xmlFile, baseDirectory)
    local customEnvironment, _ = Utils.getModNameAndBaseDirectory(baseDirectory)

    self.fontName = xmlFile:getValue( "licensePlates.font#name" , "GENERIC" )
    self.customEnvironment = customEnvironment

    xmlFile:iterate( "licensePlates.licensePlate" , function (_, plateKey)
        local filename = xmlFile:getValue(plateKey .. "#filename" )
        if filename ~ = nil then
            self.xmlReferences = self.xmlReferences + 1
            filename = Utils.getFilename(filename, baseDirectory)
            local arguments = {
            filename = filename,
            xmlFile = xmlFile,
            plateKey = plateKey,
            customEnvironment = customEnvironment
            }
            local sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(filename, false , false , self.licensePlateI3DFileLoaded, self , arguments)
            table.insert( self.sharedLoadRequestIds, sharedLoadRequestId)
        else
                Logging.xmlError(xmlFile, "Missing filename for license plate '%s'" , plateKey)
                end
            end )

            self.materialNamePlate = xmlFile:getValue( "licensePlates.colorConfigurations#materialName" , "licensePlateColored_mat" )
            self.shaderParameterCharacters = xmlFile:getValue( "licensePlates.colorConfigurations#shaderParameterCharacters" , "colorScale" )
            self.useDefaultColors = xmlFile:getValue( "licensePlates.colorConfigurations#useDefaultColors" , false )
            self.defaultColorIndex = xmlFile:getValue( "licensePlates.colorConfigurations#defaultColorIndex" )
            self.defaultColorMaxBrightness = xmlFile:getValue( "licensePlates.colorConfigurations#defaultColorMaxBrightness" , 0.55 )

            local defaultConfiguration = 1
            xmlFile:iterate( "licensePlates.colorConfigurations.colorConfiguration" , function (index, baseKey)
                local name = xmlFile:getValue(baseKey .. "#name" , "" , self.customEnvironment, false )
                local color = xmlFile:getValue(baseKey .. "#color" , nil , true )
                local isDefault = xmlFile:getValue(baseKey .. "#isDefault" , false )
                if color ~ = nil then
                    if isDefault then
                        defaultConfiguration = index
                    end

                    table.insert( self.colorConfigurations, { name = name, color = color, isDefault = isDefault } )
                end
            end )

            if self.defaultColorIndex ~ = nil then
                self.defaultColorIndex = self.defaultColorIndex + # self.colorConfigurations
            else
                    self.defaultColorIndex = defaultConfiguration
                end

                self.colors = { }
                for j = 1 , # self.colorConfigurations do
                    table.insert( self.colors, self.colorConfigurations[j])
                end

                if self.useDefaultColors then
                    for j = 1 , # VehicleConfigurationItemColor.DEFAULT_COLORS do
                        local brandMaterialName = VehicleConfigurationItemColor.DEFAULT_COLORS[j]
                        local color, title = g_vehicleMaterialManager:getMaterialTemplateColorAndTitleByName(brandMaterialName, customEnvironment)

                        if color ~ = nil then
                            local colorData = { name = title or "" , color = color }

                            local brightness = MathUtil.getBrightnessFromColor(color[ 1 ], color[ 2 ], color[ 3 ])
                            if brightness < self.defaultColorMaxBrightness then
                                table.insert( self.colors, colorData)
                            end
                        end
                    end
                end

                self.defaultPlacementIndex = LicensePlateManager.PLACEMENT_OPTION.BOTH
                local placementStr = xmlFile:getValue( "licensePlates.placement#defaultType" )
                if placementStr ~ = nil then
                    self.defaultPlacementIndex = LicensePlateManager.PLACEMENT_OPTION[ string.upper(placementStr)] or self.defaultPlacementIndex
                end
            end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData(integer xmlFile, table missionInfo, string baseDirectory)

**Arguments**

| integer | xmlFile       |
|---------|---------------|
| table   | missionInfo   |
| string  | baseDirectory |

**Return Values**

| string | true | if loading was successful else false |
|--------|------|--------------------------------------|

**Code**

```lua
function LicensePlateManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    LicensePlateManager:superClass().loadMapData( self )
    self.baseDirectory = baseDirectory

    local filename = getXMLString(xmlFile, "map.licensePlates#filename" )
    if filename ~ = nil then
        self.xmlFilename = Utils.getFilename(filename, baseDirectory)
        self.licensePlateXML = XMLFile.load( "mapLicensePlates" , self.xmlFilename, LicensePlateManager.xmlSchema)
        if self.licensePlateXML ~ = nil then
            self.xmlReferences = 0
            self:loadLicensePlatesFromXML( self.licensePlateXML, baseDirectory)

            if self.licensePlateXML ~ = nil and self.xmlReferences = = 0 then
                self.licensePlateXML:delete()
                self.licensePlateXML = nil
            end
        end
    end

    return true
end

```

### new

**Description**

> Creating manager

**Definition**

> new(table? customMt)

**Arguments**

| table? | customMt |
|--------|----------|

**Return Values**

| table? | instance | instance of object |
|--------|----------|--------------------|

**Code**

```lua
function LicensePlateManager.new(customMt)
    return AbstractManager.new(customMt or LicensePlateManager _mt)
end

```

### readLicensePlateData

**Description**

> Read license plate data from stream

**Definition**

> readLicensePlateData(integer streamId, integer connection)

**Arguments**

| integer | streamId   |
|---------|------------|
| integer | connection |

**Return Values**

| integer | licensePlateData |
|---------|------------------|

**Code**

```lua
function LicensePlateManager.readLicensePlateData(streamId, connection)
    local licensePlateData = { variation = 1 , characters = nil , colorIndex = nil , placementIndex = 1 }

    local valid = streamReadBool(streamId)
    if valid then
        licensePlateData.variation = streamReadUIntN(streamId, LicensePlateManager.SEND_NUM_BITS_VARIATION)
        licensePlateData.colorIndex = streamReadUIntN(streamId, LicensePlateManager.SEND_NUM_BITS_COLOR)
        licensePlateData.placementIndex = streamReadUIntN(streamId, LicensePlateManager.SEND_NUM_BITS_PLACEMENT)

        local font = g_licensePlateManager:getFont()

        licensePlateData.characters = { }
        local numCharacters = streamReadUIntN(streamId, LicensePlateManager.SEND_NUM_BITS_CHARACTER)
        for i = 1 , numCharacters do
            local index = streamReadUIntN(streamId, LicensePlateManager.SEND_NUM_BITS_CHARACTER)
            local character = font:getCharacterByCharacterIndex(index) or "_"
            table.insert(licensePlateData.characters, character)
        end
    end

    return licensePlateData
end

```

### saveLicensePlateDataToXML

**Description**

**Definition**

> saveLicensePlateDataToXML(XMLFile xmlFile, string key, table licensePlateData, boolean useAbsolutePaths)

**Arguments**

| XMLFile | xmlFile          |
|---------|------------------|
| string  | key              |
| table   | licensePlateData |
| boolean | useAbsolutePaths |

**Code**

```lua
function LicensePlateManager.saveLicensePlateDataToXML(xmlFile, key, licensePlateData, useAbsolutePaths)
    local valid = licensePlateData ~ = nil and licensePlateData.variation ~ = nil and licensePlateData.characters ~ = nil and licensePlateData.colorIndex ~ = nil and licensePlateData.placementIndex ~ = nil
    if valid then
        xmlFile:setInt(key .. "#variation" , licensePlateData.variation)
        xmlFile:setInt(key .. "#color" , licensePlateData.colorIndex)
        xmlFile:setInt(key .. "#placement" , licensePlateData.placementIndex)
        xmlFile:setString(key .. "#characters" , table.concat(licensePlateData.characters, "" ))

        if useAbsolutePaths then
            xmlFile:setString(key .. "#configuration" , licensePlateData.xmlFilename)
        else
                xmlFile:setString(key .. "#configuration" , NetworkUtil.convertToNetworkFilename(licensePlateData.xmlFilename))
            end
        end
    end

```

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

**Code**

```lua
function LicensePlateManager:unloadMapData()
    for i = 1 , # self.licensePlates do
        self.licensePlates[i]:delete()
    end

    if self.sharedLoadRequestIds ~ = nil then
        for _, sharedLoadRequestId in ipairs( self.sharedLoadRequestIds) do
            g_i3DManager:releaseSharedI3DFile(sharedLoadRequestId)
        end
        self.sharedLoadRequestIds = nil
    end

    if self.licensePlateXML ~ = nil then
        self.licensePlateXML:delete()
        self.licensePlateXML = nil
    end

    LicensePlateManager:superClass().unloadMapData( self )
end

```

### writeLicensePlateData

**Description**

> Write license plate data to stream

**Definition**

> writeLicensePlateData(integer streamId, integer connection, table licensePlateData)

**Arguments**

| integer | streamId         |
|---------|------------------|
| integer | connection       |
| table   | licensePlateData |

**Code**

```lua
function LicensePlateManager.writeLicensePlateData(streamId, connection, licensePlateData)
    if streamWriteBool(streamId, licensePlateData ~ = nil and licensePlateData.variation ~ = nil and licensePlateData.characters ~ = nil and licensePlateData.colorIndex ~ = nil and licensePlateData.placementIndex ~ = nil ) then
        streamWriteUIntN(streamId, licensePlateData.variation, LicensePlateManager.SEND_NUM_BITS_VARIATION)
        streamWriteUIntN(streamId, licensePlateData.colorIndex, LicensePlateManager.SEND_NUM_BITS_COLOR)
        streamWriteUIntN(streamId, licensePlateData.placementIndex, LicensePlateManager.SEND_NUM_BITS_PLACEMENT)

        local font = g_licensePlateManager:getFont()

        streamWriteUIntN(streamId, #licensePlateData.characters, LicensePlateManager.SEND_NUM_BITS_CHARACTER)
        for i = 1 , #licensePlateData.characters do
            local index = font:getCharacterIndexByCharacter(licensePlateData.characters[i])
            streamWriteUIntN(streamId, index, LicensePlateManager.SEND_NUM_BITS_CHARACTER)
        end
    end
end

```