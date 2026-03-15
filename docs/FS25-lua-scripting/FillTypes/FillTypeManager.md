## FillTypeManager

**Description**

> This class handles all fillTypes and fillTypeCategories

**Parent**

> [AbstractManager](?version=script&category=36&class=415)

**Functions**

- [addFillType](#addfilltype)
- [addFillTypeCategory](#addfilltypecategory)
- [addFillTypeConversion](#addfilltypeconversion)
- [addFillTypeConverter](#addfilltypeconverter)
- [addFillTypeToCategory](#addfilltypetocategory)
- [assignCustomFillTypeTextureArraysFromTerrain](#assigncustomfilltypetexturearraysfromterrain)
- [assignFillTypeTextureArraysFromTerrain](#assignfilltypetexturearraysfromterrain)
- [constructFillTypeDistanceTextureArray](#constructfilltypedistancetexturearray)
- [constructTerrainFillLayers](#constructterrainfilllayers)
- [getConverterDataByName](#getconverterdatabyname)
- [getFillTypeByIndex](#getfilltypebyindex)
- [getFillTypeByName](#getfilltypebyname)
- [getFillTypeIndexByName](#getfilltypeindexbyname)
- [getFillTypeNameByIndex](#getfilltypenamebyindex)
- [getFillTypeNamesByIndices](#getfilltypenamesbyindices)
- [getFillTypes](#getfilltypes)
- [getFillTypesByCategoryNames](#getfilltypesbycategorynames)
- [getFillTypesByNames](#getfilltypesbynames)
- [getFillTypesFromXML](#getfilltypesfromxml)
- [getFillTypeTitleByIndex](#getfilltypetitlebyindex)
- [getIsFillTypeInCategory](#getisfilltypeincategory)
- [getPrioritizedEffectTypeByFillTypeIndex](#getprioritizedeffecttypebyfilltypeindex)
- [getSampleByFillType](#getsamplebyfilltype)
- [getSmokeColorByFillTypeIndex](#getsmokecolorbyfilltypeindex)
- [getTextureArrayIndexByFillTypeIndex](#gettexturearrayindexbyfilltypeindex)
- [initDataStructures](#initdatastructures)
- [loadDefaultTypes](#loaddefaulttypes)
- [loadFillTypes](#loadfilltypes)
- [loadMapData](#loadmapdata)
- [loadModFillTypes](#loadmodfilltypes)
- [new](#new)
- [unloadMapData](#unloadmapdata)

### addFillType

**Description**

> Adds a new fillType

**Definition**

> addFillType(table fillTypeDesc)

**Arguments**

| table | fillTypeDesc | Fill type description object |
|-------|--------------|------------------------------|

**Return Values**

| table | success |
|-------|---------|

**Code**

```lua
function FillTypeManager:addFillType(fillTypeDesc)
    local maxNumFillTypes = 2 ^ FillTypeManager.SEND_NUM_BITS - 1
    if # self.fillTypes > = maxNumFillTypes then
        Logging.error( "FillTypeManager.addFillType too many fill types.Only %d fill types are supported.Ignoring '%s'." , maxNumFillTypes, fillTypeDesc.name)
        return false
    end

    fillTypeDesc.index = # self.fillTypes + 1

    self.nameToFillType[fillTypeDesc.name] = fillTypeDesc
    self.nameToIndex[fillTypeDesc.name] = fillTypeDesc.index
    self.indexToName[fillTypeDesc.index] = fillTypeDesc.name
    self.indexToTitle[fillTypeDesc.index] = fillTypeDesc.title
    self.indexToFillType[fillTypeDesc.index] = fillTypeDesc
    table.insert( self.fillTypes, fillTypeDesc)

    return true
end

```

### addFillTypeCategory

**Description**

> Adds a new fillType category

**Definition**

> addFillTypeCategory(string name, boolean isBaseType)

**Arguments**

| string  | name       | fillType category index name                          |
|---------|------------|-------------------------------------------------------|
| boolean | isBaseType | if true overriding existing categories is not allowed |

**Return Values**

| boolean | fillTypeCategoryIndex |
|---------|-----------------------|

**Code**

```lua
function FillTypeManager:addFillTypeCategory(name, isBaseType)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a fillTypeCategory.Ignoring fillTypeCategory!" )
            return nil
        end

        name = string.upper(name)

        if isBaseType and self.nameToCategoryIndex[name] ~ = nil then
            printWarning( "Warning:FillTypeCategory '" .. tostring(name) .. "' already exists.Ignoring fillTypeCategory!" )
            return nil
        end

        local index = self.nameToCategoryIndex[name]
        if index = = nil then
            local categoryFillTypes = { }
            index = # self.categories + 1
            table.insert( self.categories, name)
            self.categoryNameToFillTypes[name] = categoryFillTypes
            self.categoryIndexToFillTypes[index] = categoryFillTypes
            self.nameToCategoryIndex[name] = index
        end

        return index
    end

```

### addFillTypeConversion

**Description**

> Add fill type to fill type conversion

**Definition**

> addFillTypeConversion(integer converter, integer sourceFillTypeIndex, integer targetFillTypeIndex, float
> conversionFactor)

**Arguments**

| integer | converter           | index of converter     |
|---------|---------------------|------------------------|
| integer | sourceFillTypeIndex | source fill type index |
| integer | targetFillTypeIndex | target fill type index |
| float   | conversionFactor    | factor of conversion   |

**Code**

```lua
function FillTypeManager:addFillTypeConversion(converter, sourceFillTypeIndex, targetFillTypeIndex, conversionFactor)
    if converter ~ = nil and self.fillTypeConverters[converter] ~ = nil and sourceFillTypeIndex ~ = nil and targetFillTypeIndex ~ = nil then
        self.fillTypeConverters[converter][sourceFillTypeIndex] = { targetFillTypeIndex = targetFillTypeIndex, conversionFactor = conversionFactor }
    end
end

```

### addFillTypeConverter

**Description**

> Adds a new fill type converter

**Definition**

> addFillTypeConverter(string name, boolean isBaseType)

**Arguments**

| string  | name       | name                                                  |
|---------|------------|-------------------------------------------------------|
| boolean | isBaseType | if true overriding existing converters is not allowed |

**Return Values**

| boolean | index |
|---------|-------|

**Code**

```lua
function FillTypeManager:addFillTypeConverter(name, isBaseType)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a fillTypeConverter.Ignoring fillTypeConverter!" )
            return nil
        end

        name = string.upper(name)

        if isBaseType and self.nameToConverter[name] ~ = nil then
            printWarning( "Warning:FillTypeConverter '" .. tostring(name) .. "' already exists.Ignoring FillTypeConverter!" )
            return nil
        end

        local index = self.converterNameToIndex[name]
        if index = = nil then
            local converter = { }
            table.insert( self.fillTypeConverters, converter)
            self.converterNameToIndex[name] = # self.fillTypeConverters
            self.nameToConverter[name] = converter
            index = # self.fillTypeConverters
        end

        return index
    end

```

### addFillTypeToCategory

**Description**

> Add fillType to category

**Definition**

> addFillTypeToCategory(integer fillTypeIndex, integer categoryIndex)

**Arguments**

| integer | fillTypeIndex | index of fillType |
|---------|---------------|-------------------|
| integer | categoryIndex | index of category |

**Return Values**

| integer | success | true if added else false |
|---------|---------|--------------------------|

**Code**

```lua
function FillTypeManager:addFillTypeToCategory(fillTypeIndex, categoryIndex)
    if categoryIndex ~ = nil and fillTypeIndex ~ = nil then
        if self.categoryIndexToFillTypes[categoryIndex] ~ = nil then
            -- category -> fillType
            self.categoryIndexToFillTypes[categoryIndex][fillTypeIndex] = true

            -- fillType -> categories
            if self.fillTypeIndexToCategories[fillTypeIndex] = = nil then
                self.fillTypeIndexToCategories[fillTypeIndex] = { }
            end
            self.fillTypeIndexToCategories[fillTypeIndex][categoryIndex] = true

            return true
        end
    end
    return false
end

```

### assignCustomFillTypeTextureArraysFromTerrain

**Description**

> Assigns fill type array textures to given node id using custom texture names

**Definition**

> assignCustomFillTypeTextureArraysFromTerrain(integer nodeId, integer terrainRootNodeId, string diffuse, string normal,
> string height)

**Arguments**

| integer | nodeId            | node id                                |
|---------|-------------------|----------------------------------------|
| integer | terrainRootNodeId | terrain root node id                   |
| string  | diffuse           | diffuse map custom texture name, or "" |
| string  | normal            | normal map custom texture name, or ""  |
| string  | height            | height map custom texture name, or ""  |

**Code**

```lua
function FillTypeManager:assignCustomFillTypeTextureArraysFromTerrain(nodeId, terrainRootNodeId, diffuse, normal, height)
    local material = getMaterial(nodeId, 0 )

    material = setTerrainFillPlanesToMaterialCustom(terrainRootNodeId, material, diffuse, normal, height)

    if material ~ = nil then
        setMaterial(nodeId, material, 0 )
    end
end

```

### assignFillTypeTextureArraysFromTerrain

**Description**

> Assigns fill type array textures to given node id

**Definition**

> assignFillTypeTextureArraysFromTerrain(integer nodeId, integer terrainRootNodeId, boolean diffuse, boolean normal,
> boolean height)

**Arguments**

| integer | nodeId            | node id                             |
|---------|-------------------|-------------------------------------|
| integer | terrainRootNodeId | terrain root node id                |
| boolean | diffuse           | apply diffuse map (default is true) |
| boolean | normal            | apply normal map (default is true)  |
| boolean | height            | apply height map (default is true)  |

**Code**

```lua
function FillTypeManager:assignFillTypeTextureArraysFromTerrain(nodeId, terrainRootNodeId, diffuse, normal, height)
    local material = getMaterial(nodeId, 0 )

    material = setTerrainFillPlanesToMaterial(terrainRootNodeId, material, diffuse, normal, height)

    if material ~ = nil then
        setMaterial(nodeId, material, 0 )
    end
end

```

### constructFillTypeDistanceTextureArray

**Description**

> Constructs fill types texture distance array

**Definition**

> constructFillTypeDistanceTextureArray(integer terrainDetailHeightId, integer typeFirstChannel, integer
> typeNumChannels, table heightTypes)

**Arguments**

| integer | terrainDetailHeightId | id of terrain detail height node |
|---------|-----------------------|----------------------------------|
| integer | typeFirstChannel      | first type channel               |
| integer | typeNumChannels       | num type channels                |
| table   | heightTypes           | list of heightTypes              |

**Return Values**

| table | success |
|-------|---------|

**Code**

```lua
function FillTypeManager:constructFillTypeDistanceTextureArray(terrainDetailHeightId, typeFirstChannel, typeNumChannels, heightTypes)
    local distanceConstr = TerrainDetailDistanceConstructor.new(typeFirstChannel, typeNumChannels)

    for i = 1 , #heightTypes do
        local heightType = heightTypes[i]

        local fillType = self.fillTypes[heightType.fillTypeIndex]
        if fillType ~ = nil then
            fillType:addDistanceTexture(distanceConstr, i - 1 )
        end
    end

    return distanceConstr:finalize(terrainDetailHeightId)
end

```

### constructTerrainFillLayers

**Description**

> Constructs density map height type array textures to given node id

**Definition**

> constructTerrainFillLayers(table heightTypes, entityId terrainRootNodeId)

**Arguments**

| table    | heightTypes       | table of density height map types |
|----------|-------------------|-----------------------------------|
| entityId | terrainRootNodeId |                                   |

**Return Values**

| entityId | success |
|----------|---------|

**Code**

```lua
function FillTypeManager:constructTerrainFillLayers(heightTypes, terrainRootNodeId)

    clearTerrainFillLayers(terrainRootNodeId)

    local curIndex = 1
    for i = 1 , #heightTypes do
        local heightType = heightTypes[i]

        local fillType = self.fillTypes[heightType.fillTypeIndex]
        if fillType ~ = nil then
            if fillType:addTerrainFillLayer(terrainRootNodeId, curIndex) then
                curIndex = curIndex + 1

                if heightType.visualHeightMapping ~ = nil then
                    for i = 1 , #heightType.visualHeightMapping do
                        local mapping, nextMapping = heightType.visualHeightMapping[i], heightType.visualHeightMapping[i + 1 ]
                        if nextMapping ~ = nil then
                            setTerrainFillVisualHeight(g_currentMission.terrainDetailHeightId, fillType.textureArrayIndex, mapping.realValue, mapping.visualValue, nextMapping.realValue, nextMapping.visualValue)
                        else
                                setTerrainFillVisualHeight(g_currentMission.terrainDetailHeightId, fillType.textureArrayIndex, mapping.realValue, mapping.visualValue, nil , nil )
                            end
                        end
                    end
                end
            end
        end

        finalizeTerrainFillLayers(terrainRootNodeId)

        return true
    end

```

### getConverterDataByName

**Description**

> Returns converter data by given name

**Definition**

> getConverterDataByName(string converterName)

**Arguments**

| string | converterName | name of converter |
|--------|---------------|-------------------|

**Return Values**

| string | converterData | converter data |
|--------|---------------|----------------|

**Code**

```lua
function FillTypeManager:getConverterDataByName(converterName)
    return self.nameToConverter[converterName and string.upper(converterName)]
end

```

### getFillTypeByIndex

**Description**

> Gets a fillType by index

**Definition**

> getFillTypeByIndex(integer index)

**Arguments**

| integer | index | the fillType index |
|---------|-------|--------------------|

**Return Values**

| integer | fillType | the fillType object |
|---------|----------|---------------------|

**Code**

```lua
function FillTypeManager:getFillTypeByIndex(index)
    return self.fillTypes[index]
end

```

### getFillTypeByName

**Description**

> Gets a fillType by index name

**Definition**

> getFillTypeByName(string name)

**Arguments**

| string | name | the fillType index name |
|--------|------|-------------------------|

**Return Values**

| string | fillType | the fillType object |
|--------|----------|---------------------|

**Code**

```lua
function FillTypeManager:getFillTypeByName(name)
    if ClassUtil.getIsValidIndexName(name) then
        return self.nameToFillType[ string.upper(name)]
    end
    return nil
end

```

### getFillTypeIndexByName

**Description**

> Gets a fillType index by name

**Definition**

> getFillTypeIndexByName(string name)

**Arguments**

| string | name | the fillType index name |
|--------|------|-------------------------|

**Return Values**

| string | fillTypeIndex | the fillType index |
|--------|---------------|--------------------|

**Code**

```lua
function FillTypeManager:getFillTypeIndexByName(name)
    return self.nameToIndex[name and string.upper(name)]
end

```

### getFillTypeNameByIndex

**Description**

> Gets a fillTypeName by index

**Definition**

> getFillTypeNameByIndex(integer index)

**Arguments**

| integer | index | the fillType index |
|---------|-------|--------------------|

**Return Values**

| integer | fillTypeName | the fillType name |
|---------|--------------|-------------------|

**Code**

```lua
function FillTypeManager:getFillTypeNameByIndex(index)
    return self.indexToName[index]
end

```

### getFillTypeNamesByIndices

**Description**

> Gets an array of fillType names from an array of fillType indices

**Definition**

> getFillTypeNamesByIndices(table indices)

**Arguments**

| table | indices | set of fillType indices (keys are the fillType indices) |
|-------|---------|---------------------------------------------------------|

**Return Values**

| table | array | of fillType names |
|-------|-------|-------------------|

**Code**

```lua
function FillTypeManager:getFillTypeNamesByIndices(indices)
    local names = { }
    for fillTypeIndex in pairs(indices) do
        table.insert(names, self.indexToName[fillTypeIndex])
    end
    return names
end

```

### getFillTypes

**Description**

> Gets a list of fillTypes

**Definition**

> getFillTypes()

**Return Values**

| table | fillTypes | list of fillTypes |
|-------|-----------|-------------------|

**Code**

```lua
function FillTypeManager:getFillTypes()
    return self.fillTypes
end

```

### getFillTypesByCategoryNames

**Description**

> Gets a list of fillTypes of the given category names

**Definition**

> getFillTypesByCategoryNames(string names, string? warning, table? fillTypes)

**Arguments**

| string  | names     | string of space separated fillType category names                       |
|---------|-----------|-------------------------------------------------------------------------|
| string? | warning   | a warning text shown if a category is not found                         |
| table?  | fillTypes | list of fillTypes to insert results to, if omitted new table is created |

**Return Values**

| table? | fillTypes | list of fillTypes |
|--------|-----------|-------------------|

**Code**

```lua
function FillTypeManager:getFillTypesByCategoryNames(names, warning, fillTypes)
    fillTypes = fillTypes or { }

    if names ~ = nil then
        return self:getFillTypesByCategoryNamesList( string.split(names, " " ), warning, fillTypes)
    end

    return fillTypes
end

```

### getFillTypesByNames

**Description**

> Gets list of fillType indices from string of space separated fill type names

**Definition**

> getFillTypesByNames(string names, string? warning, table? fillTypes)

**Arguments**

| string  | names     | string of space separatated fill type names                             |
|---------|-----------|-------------------------------------------------------------------------|
| string? | warning   | warning if fill type not found                                          |
| table?  | fillTypes | list of fillTypes to insert results to, if omitted new table is created |

**Return Values**

| table? | fillTypes | list of fillTypes |
|--------|-----------|-------------------|

**Code**

```lua
function FillTypeManager:getFillTypesByNames(names, warning, fillTypes)
    fillTypes = fillTypes or { }

    if names ~ = nil then
        local fillTypeNames = string.split(names, " " )
        for _, name in pairs(fillTypeNames) do
            name = string.upper(name)
            local fillTypeIndex = self.nameToIndex[name]
            if fillTypeIndex ~ = nil then
                if fillTypeIndex ~ = FillType.UNKNOWN then
                    if not table.hasElement(fillTypes, fillTypeIndex) then
                        table.insert(fillTypes, fillTypeIndex)
                    end
                end
            else
                    if warning ~ = nil then
                        printWarning( string.format(warning, name))
                    end
                end
            end
        end

        return fillTypes
    end

```

### getFillTypesFromXML

**Description**

**Definition**

> getFillTypesFromXML(XMLFile xmlFile, string categoryKey, string namesKey, boolean? requiresFillTypes)

**Arguments**

| XMLFile  | xmlFile           |
|----------|-------------------|
| string   | categoryKey       |
| string   | namesKey          |
| boolean? | requiresFillTypes |

**Return Values**

| boolean? | fillTypes |
|----------|-----------|

**Code**

```lua
function FillTypeManager:getFillTypesFromXML(xmlFile, categoryKey, namesKey, requiresFillTypes)
    local fillTypes = { }
    local fillTypeCategories = xmlFile:getValue(categoryKey)
    local fillTypeNames = xmlFile:getValue(namesKey)
    if fillTypeCategories ~ = nil and fillTypeNames = = nil then
        fillTypes = g_fillTypeManager:getFillTypesByCategoryNames(fillTypeCategories, "Warning: '" .. xmlFile:getFilename() .. "' has invalid fillTypeCategory '%s'." )
    elseif fillTypeCategories = = nil and fillTypeNames ~ = nil then
            fillTypes = g_fillTypeManager:getFillTypesByNames(fillTypeNames, "Warning: '" .. xmlFile:getFilename() .. "' has invalid fillType '%s'." )
        elseif fillTypeCategories ~ = nil and fillTypeNames ~ = nil then
                Logging.xmlWarning(xmlFile, "fillTypeCategories and fillTypeNames are both set, only one of the two allowed" )
            elseif requiresFillTypes ~ = nil and requiresFillTypes then
                    Logging.xmlWarning(xmlFile, "either the '%s' or '%s' attribute has to be set" , categoryKey, namesKey)
                end
                return fillTypes
            end

```

### getFillTypeTitleByIndex

**Description**

> Gets a fillType title by index

**Definition**

> getFillTypeTitleByIndex(integer index)

**Arguments**

| integer | index | the fillType index |
|---------|-------|--------------------|

**Return Values**

| integer | fillTypeTitle | the localized fillType title |
|---------|---------------|------------------------------|

**Code**

```lua
function FillTypeManager:getFillTypeTitleByIndex(index)
    return self.indexToTitle[index]
end

```

### getIsFillTypeInCategory

**Description**

> Gets if filltype is part of a category

**Definition**

> getIsFillTypeInCategory(string fillTypeIndex, string categoryName)

**Arguments**

| string | fillTypeIndex | fillType index |
|--------|---------------|----------------|
| string | categoryName  |                |

**Return Values**

| string | true | if fillType is part of category |
|--------|------|---------------------------------|

**Code**

```lua
function FillTypeManager:getIsFillTypeInCategory(fillTypeIndex, categoryName)
    local catgegoy = self.nameToCategoryIndex[categoryName]
    if catgegoy ~ = nil and self.fillTypeIndexToCategories[fillTypeIndex] then
        return self.fillTypeIndexToCategories[fillTypeIndex][catgegoy] ~ = nil
    end
    return false
end

```

### getPrioritizedEffectTypeByFillTypeIndex

**Description**

> Returns the prioritized effect type by given fill type index

**Definition**

> getPrioritizedEffectTypeByFillTypeIndex(integer index)

**Arguments**

| integer | index | the fillType index |
|---------|-------|--------------------|

**Return Values**

| integer | class | name of effect type |
|---------|-------|---------------------|

**Code**

```lua
function FillTypeManager:getPrioritizedEffectTypeByFillTypeIndex(index)
    local fillType = self.fillTypes[index]
    return fillType and fillType.prioritizedEffectType
end

```

### getSampleByFillType

**Description**

> Returns sound sample of fill type

**Definition**

> getSampleByFillType(integer fillType)

**Arguments**

| integer | fillType | fill type index |
|---------|----------|-----------------|

**Return Values**

| integer | sample | sample |
|---------|--------|--------|

**Code**

```lua
function FillTypeManager:getSampleByFillType(fillType)
    return self.fillTypeToSample[fillType]
end

```

### getSmokeColorByFillTypeIndex

**Description**

> Returns the smoke color by fill type index

**Definition**

> getSmokeColorByFillTypeIndex(integer index, boolean fruitColor)

**Arguments**

| integer | index      | the fillType index         |
|---------|------------|----------------------------|
| boolean | fruitColor | use fruit color of defined |

**Return Values**

| boolean | color | smoke color |
|---------|-------|-------------|

**Code**

```lua
function FillTypeManager:getSmokeColorByFillTypeIndex(index, fruitColor)
    local fillType = self.fillTypes[index]
    if fillType ~ = nil then
        if not fruitColor then
            return fillType.fillSmokeColor
        else
                return fillType.fruitSmokeColor or fillType.fillSmokeColor
            end
        end

        return nil
    end

```

### getTextureArrayIndexByFillTypeIndex

**Description**

> Returns texture array by fill type index (returns nil if not in texture array)

**Definition**

> getTextureArrayIndexByFillTypeIndex(integer index)

**Arguments**

| integer | index | the fillType index |
|---------|-------|--------------------|

**Return Values**

| integer | textureArrayIndex | index in texture array |
|---------|-------------------|------------------------|

**Code**

```lua
function FillTypeManager:getTextureArrayIndexByFillTypeIndex(index)
    local fillType = self.fillTypes[index]
    return fillType and fillType.textureArrayIndex
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function FillTypeManager:initDataStructures()
    self.fillTypes = { }
    self.nameToFillType = { }
    self.indexToFillType = { }
    self.nameToIndex = { }
    self.indexToName = { }
    self.indexToTitle = { }

    self.fillTypeConverters = { }
    self.converterNameToIndex = { }
    self.nameToConverter = { }

    self.categories = { }
    self.nameToCategoryIndex = { }
    self.categoryIndexToFillTypes = { }
    self.categoryNameToFillTypes = { }
    self.fillTypeIndexToCategories = { }

    self.fillTypeSamples = { }
    self.fillTypeToSample = { }

    self.modsToLoad = { }

    FillType = self.nameToIndex
    FillTypeCategory = self.categories
end

```

### loadDefaultTypes

**Description**

**Definition**

> loadDefaultTypes()

**Code**

```lua
function FillTypeManager:loadDefaultTypes()
    local xmlFile = loadXMLFile( "fillTypes" , "data/maps/maps_fillTypes.xml" )
    self:loadFillTypes(xmlFile, nil , true , nil , false )
    delete(xmlFile)
end

```

### loadFillTypes

**Description**

> Loads fillTypes

**Definition**

> loadFillTypes(table|integer xmlFile, string baseDirectory, boolean isBaseType, string? customEnv, )

**Arguments**

| table   | integer       | xmlFile                          | XMLFile instance or xml handle |
|---------|---------------|----------------------------------|--------------------------------|
| string  | baseDirectory | For sourcing textures and sounds |                                |
| boolean | isBaseType    | Is basegame type                 |                                |
| string? | customEnv     | Custom environment               |                                |
| any     | finalizeType  |                                  |                                |

**Return Values**

| any | success | success |
|-----|---------|---------|

**Code**

```lua
function FillTypeManager:loadFillTypes(xmlFile, baseDirectory, isBaseType, customEnv, finalizeType)
    if xmlFile = = nil or xmlFile = = 0 then
        return false
    end

    if type(xmlFile) ~ = "table" then
        xmlFile = XMLFile.wrap(xmlFile, FillTypeManager.xmlSchema)
    end

    local rootName = xmlFile:getRootName()

    if isBaseType then
        local unknownFillType = FillTypeDesc.new() -- FillType.UNKNOWN
        unknownFillType.economy.sychronizeData = false
        self:addFillType(unknownFillType)
    end

    for _, ftKey in xmlFile:iterator(rootName .. ".fillTypes.fillType" ) do
        local name = xmlFile:getValue(ftKey .. "#name" )
        if name ~ = nil then
            name = string.upper(name)
            if isBaseType and self.nameToFillType[name] ~ = nil then
                Logging.warning( "FillType '%s' already exists.Ignoring fillType!" , name)
                continue
            end

            local fillTypeDesc = self.nameToFillType[name]
            if fillTypeDesc = = nil then
                fillTypeDesc = FillTypeDesc.new()
            end

            if fillTypeDesc:loadFromXMLFile(xmlFile, ftKey, baseDirectory, customEnv) then
                if self.nameToFillType[name] = = nil then
                    self:addFillType(fillTypeDesc)
                end

                if finalizeType = = true then
                    fillTypeDesc:finalize()
                end
            end
        end
    end

    for _, ftCategoryKey in xmlFile:iterator(rootName .. ".fillTypeCategories.fillTypeCategory" ) do
        local name = xmlFile:getValue(ftCategoryKey .. "#name" )
        local fillTypesList = xmlFile:getValue(ftCategoryKey)
        local fillTypeCategoryIndex = self:addFillTypeCategory(name, isBaseType)
        if fillTypesList ~ = nil and fillTypeCategoryIndex ~ = nil then
            for _, fillTypeName in ipairs(fillTypesList) do
                local fillType = self:getFillTypeByName(fillTypeName)
                if fillType ~ = nil then
                    if not self:addFillTypeToCategory(fillType.index, fillTypeCategoryIndex) then
                        Logging.warning( "Could not add fillType '" .. tostring(fillTypeName) .. "' to fillTypeCategory '" .. tostring(name) .. "'!" )
                    end
                else
                        Logging.warning( "Unknown FillType '" .. tostring(fillTypeName) .. "' in fillTypeCategory '" .. tostring(name) .. "'!" )
                    end
                end
            end
        end

        for _, ftConverterKey in xmlFile:iterator(rootName .. ".fillTypeConverters.fillTypeConverter" ) do
            local name = xmlFile:getValue(ftConverterKey .. "#name" )
            local converter = self:addFillTypeConverter(name, isBaseType)
            if converter ~ = nil then
                for _, converterRuleKey in xmlFile:iterator(ftConverterKey .. ".converter" ) do
                    local from = xmlFile:getValue(converterRuleKey .. "#from" )
                    local to = xmlFile:getValue(converterRuleKey .. "#to" )
                    local factor = xmlFile:getValue(converterRuleKey .. "#factor" )

                    local sourceFillType = g_fillTypeManager:getFillTypeByName(from)
                    local targetFillType = g_fillTypeManager:getFillTypeByName(to)

                    if sourceFillType ~ = nil and targetFillType ~ = nil and factor ~ = nil then
                        self:addFillTypeConversion(converter, sourceFillType.index, targetFillType.index, factor)
                    end
                end
            end
        end

        for _, fillTypeSoundKey in xmlFile:iterator(rootName .. ".fillTypeSounds.fillTypeSound" ) do
            local sample = g_soundManager:loadSampleFromXML(xmlFile, fillTypeSoundKey, "sound" , baseDirectory, getRootNode(), 0 , AudioGroup.VEHICLE, nil , nil )
            if sample = = nil then
                continue
            end

            local entry = {
            sample = sample,
            fillTypes = { } ,
            }

            local fillTypes = xmlFile:getValue(fillTypeSoundKey .. "#fillTypes" )
            if fillTypes ~ = nil then

                for _, fillTypeName in ipairs(fillTypes) do
                    local fillType = self:getFillTypeIndexByName(fillTypeName)
                    if fillType ~ = nil then
                        table.insert(entry.fillTypes, fillType)
                        self.fillTypeToSample[fillType] = sample
                    else
                            Logging.xmlWarning(xmlFile, "Unable to load fill type '%s' for fillTypeSound '%s'" , fillTypeName, fillTypeSoundKey)
                            end
                        end
                    end

                    if xmlFile:getValue(fillTypeSoundKey .. "#isDefault" ) then
                        for fillType, _ in ipairs( self.fillTypes) do
                            if self.fillTypeToSample[fillType] = = nil then
                                self.fillTypeToSample[fillType] = sample
                            end
                        end
                    end

                    table.insert( self.fillTypeSamples, entry)
                end

                return true
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
function FillTypeManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    FillTypeManager:superClass().loadMapData( self )

    self:loadDefaultTypes()

    if XMLUtil.loadDataFromMapXML(xmlFile, "fillTypes" , baseDirectory, self , self.loadFillTypes, baseDirectory, false , missionInfo.customEnvironment, false ) then
        for _, fillType in ipairs( self.fillTypes) do
            fillType:finalize()
        end

        return true
    end

    return false
end

```

### loadModFillTypes

**Description**

**Definition**

> loadModFillTypes()

**Code**

```lua
function FillTypeManager:loadModFillTypes()
    if # self.modsToLoad > 0 then
        -- Load additional fill types from mods
        for _, data in ipairs( self.modsToLoad) do
            local xmlFilename, baseDirectoryMod, customEnvironment = unpack(data)
            local fillTypesXMLFile = XMLFile.load( "fillTypes" , xmlFilename, FillTypeManager.xmlSchema)
            if fillTypesXMLFile ~ = nil then
                local numFillTypes = # self.fillTypes
                g_fillTypeManager:loadFillTypes(fillTypesXMLFile, baseDirectoryMod, false , customEnvironment, false )
                fillTypesXMLFile:delete()

                local numLoadedFillTypes = # self.fillTypes - numFillTypes
                if numLoadedFillTypes > 0 then
                    Logging.info( "Loaded %d fill types from mod: %s" , numLoadedFillTypes, customEnvironment)
                end
            end
        end

        for _, fillType in ipairs( self.fillTypes) do
            fillType:finalize()
        end
    end
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
function FillTypeManager.new(customMt)
    local self = AbstractManager.new(customMt or FillTypeManager _mt)
    return self
end

```

### unloadMapData

**Description**

**Definition**

> unloadMapData()

**Code**

```lua
function FillTypeManager:unloadMapData()
    for _, sample in pairs( self.fillTypeSamples) do
        g_soundManager:deleteSample(sample.sample)
    end

    for _, fillTypeDesc in pairs( self.fillTypes) do
        fillTypeDesc:delete()
    end

    FillTypeManager:superClass().unloadMapData( self )
end

```