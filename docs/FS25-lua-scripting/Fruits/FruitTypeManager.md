## FruitTypeManager

**Description**

> This class handles all fruitTypes and fruitTypeCategories

**Parent**

> [AbstractManager](?version=script&category=38&class=417)

**Functions**

- [addFruitTypeCategory](#addfruittypecategory)
- [addFruitTypeConversion](#addfruittypeconversion)
- [addFruitTypeConverter](#addfruittypeconverter)
- [addFruitTypeToCategory](#addfruittypetocategory)
- [addModFoliageType](#addmodfoliagetype)
- [getConverterDataByName](#getconverterdatabyname)
- [getCutHeightByFruitTypeIndex](#getcutheightbyfruittypeindex)
- [getFillTypeByFruitTypeIndex](#getfilltypebyfruittypeindex)
- [getFillTypeIndexByFruitTypeIndex](#getfilltypeindexbyfruittypeindex)
- [getFillTypeIndicesByFruitTypeCategoryName](#getfilltypeindicesbyfruittypecategoryname)
- [getFillTypeIndicesByFruitTypeNames](#getfilltypeindicesbyfruittypenames)
- [getFillTypeLiterPerSqm](#getfilltypeliterpersqm)
- [getFillTypeNameByFruitTypeIndex](#getfilltypenamebyfruittypeindex)
- [getFillTypesByFruitTypeCategoryNames](#getfilltypesbyfruittypecategorynames)
- [getFillTypesByFruitTypeNames](#getfilltypesbyfruittypenames)
- [getFruitTypeByFillTypeIndex](#getfruittypebyfilltypeindex)
- [getFruitTypeByIndex](#getfruittypebyindex)
- [getFruitTypeByName](#getfruittypebyname)
- [getFruitTypeIndexByFillTypeIndex](#getfruittypeindexbyfilltypeindex)
- [getFruitTypeIndicesByCategoryNames](#getfruittypeindicesbycategorynames)
- [getFruitTypeIndicesByNames](#getfruittypeindicesbynames)
- [getFruitTypeNameByIndex](#getfruittypenamebyindex)
- [getFruitTypes](#getfruittypes)
- [getFruitTypesByCategoryNames](#getfruittypesbycategorynames)
- [getFruitTypesByNames](#getfruittypesbynames)
- [getWindrowFillTypeIndexByFruitTypeIndex](#getwindrowfilltypeindexbyfruittypeindex)
- [initDataStructures](#initdatastructures)
- [isFillTypeWindrow](#isfilltypewindrow)
- [loadDefaultTypes](#loaddefaulttypes)
- [loadFruitTypes](#loadfruittypes)
- [loadMapData](#loadmapdata)
- [new](#new)

### addFruitTypeCategory

**Description**

> Adds a new fruitType category

**Definition**

> addFruitTypeCategory(string name, boolean isBaseType)

**Arguments**

| string  | name       | fruit category index name                                                 |
|---------|------------|---------------------------------------------------------------------------|
| boolean | isBaseType | if true overwriting of existing category with the same name is prohibited |

**Return Values**

| boolean | categoryIndex | index of the added category |
|---------|---------------|-----------------------------|

**Code**

```lua
function FruitTypeManager:addFruitTypeCategory(name, isBaseType)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a fruitTypeCategory.Ignoring fruitTypeCategory!" )
            return nil
        end

        name = string.upper(name)

        if isBaseType and self.categories[name] ~ = nil then
            printWarning( "Warning:FruitTypeCategory '" .. tostring(name) .. "' already exists.Ignoring fruitTypeCategory!" )
            return nil
        end

        local index = self.categories[name]

        if index = = nil then
            self.numCategories = self.numCategories + 1
            self.categories[name] = self.numCategories
            self.indexToCategory[ self.numCategories] = name
            self.categoryIndexToFruitTypeIndex[ self.numCategories] = { }
            index = self.numCategories
        end

        return index
    end

```

### addFruitTypeConversion

**Description**

> Add fruit type to fill type conversion

**Definition**

> addFruitTypeConversion(integer converter, integer fruitTypeIndex, integer fillTypeIndex, float conversionFactor)

**Arguments**

| integer | converter        | index of converter   |
|---------|------------------|----------------------|
| integer | fruitTypeIndex   | fruit type index     |
| integer | fillTypeIndex    | fill type index      |
| float   | conversionFactor | factor of conversion |

**Code**

```lua
function FruitTypeManager:addFruitTypeConversion(converter, fruitTypeName, fillTypeName, conversionFactor)
    if converter ~ = nil then
        if self.fruitTypeConverterLoadData[converter] = = nil then
            self.fruitTypeConverterLoadData[converter] = { }
        end

        table.insert( self.fruitTypeConverterLoadData[converter], { fruitTypeName = fruitTypeName, fillTypeName = fillTypeName, conversionFactor = conversionFactor } )
    end
end

```

### addFruitTypeConverter

**Description**

> Adds a new ruit type converter

**Definition**

> addFruitTypeConverter(string name, boolean isBaseType)

**Arguments**

| string  | name       | name                                                                    |
|---------|------------|-------------------------------------------------------------------------|
| boolean | isBaseType | if true overwriting existing converter with the same name is prohibited |

**Return Values**

| boolean | converterIndex | index of converterIndex |
|---------|----------------|-------------------------|

**Code**

```lua
function FruitTypeManager:addFruitTypeConverter(name, isBaseType)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a fruitTypeConverter.Ignoring fruitTypeConverter!" )
            return nil
        end

        name = string.upper(name)

        if isBaseType and self.converterNameToIndex[name] ~ = nil then
            printWarning( "Warning:FruitTypeConverter '" .. tostring(name) .. "' already exists.Ignoring fruitTypeConverter!" )
            return nil
        end

        local index = self.converterNameToIndex[name]
        if index = = nil then
            local converter = { }
            table.insert( self.fruitTypeConverters, converter)
            self.converterNameToIndex[name] = # self.fruitTypeConverters
            self.nameToConverter[name] = converter
            index = # self.fruitTypeConverters
        end

        return index
    end

```

### addFruitTypeToCategory

**Description**

> Add fruitType to category

**Definition**

> addFruitTypeToCategory(integer fruitTypeIndex, integer categoryIndex)

**Arguments**

| integer | fruitTypeIndex | index of fruit type |
|---------|----------------|---------------------|
| integer | categoryIndex  | index of category   |

**Return Values**

| integer | success | true if added else false |
|---------|---------|--------------------------|

**Code**

```lua
function FruitTypeManager:addFruitTypeToCategory(fruitTypeIndex, categoryIndex)
    if categoryIndex ~ = nil and fruitTypeIndex ~ = nil then
        table.insert( self.categoryIndexToFruitTypeIndex[categoryIndex], fruitTypeIndex)
        return true
    end
    return false
end

```

### addModFoliageType

**Description**

> Add additional foliage types that should be added

**Definition**

> addModFoliageType(string name, string filename)

**Arguments**

| string | name     | name of foliage type             |
|--------|----------|----------------------------------|
| string | filename | absolute path to the foliage xml |

**Code**

```lua
function FruitTypeManager:addModFoliageType(name, filename)
    table.insert( self.modFoliageTypesToLoad, { name = name, filename = filename } )
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
function FruitTypeManager:getConverterDataByName(converterName)
    return self.nameToConverter[converterName and string.upper(converterName)]
end

```

### getCutHeightByFruitTypeIndex

**Description**

**Definition**

> getCutHeightByFruitTypeIndex(integer index, boolean? isForageCutter)

**Arguments**

| integer  | index          |
|----------|----------------|
| boolean? | isForageCutter |

**Return Values**

| boolean? | cutHeight | in m |
|----------|-----------|------|

**Code**

```lua
function FruitTypeManager:getCutHeightByFruitTypeIndex(index, isForageCutter)
    --#debug Assert.isInteger(index)
    local fruitType = self.indexToFruitType[index]
    if isForageCutter then
        return(fruitType and(fruitType.forageCutHeight or fruitType.cutHeight)) or 0.15
    end

    return(fruitType and fruitType.cutHeight) or 0.15
end

```

### getFillTypeByFruitTypeIndex

**Description**

**Definition**

> getFillTypeByFruitTypeIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | fillType |
|---------|----------|

**Code**

```lua
function FruitTypeManager:getFillTypeByFruitTypeIndex(index)
    --#debug Assert.isInteger(index)
    return self.fruitTypeIndexToFillType[index]
end

```

### getFillTypeIndexByFruitTypeIndex

**Description**

**Definition**

> getFillTypeIndexByFruitTypeIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | fillTypeIndex |
|---------|---------------|

**Code**

```lua
function FruitTypeManager:getFillTypeIndexByFruitTypeIndex(index)
    --#debug Assert.isInteger(index)
    local fillType = self.fruitTypeIndexToFillType[index]
    if fillType ~ = nil then
        return fillType.index
    end
    return nil
end

```

### getFillTypeIndicesByFruitTypeCategoryName

**Description**

> Gets a list of fillType indices from string of space separated fruit type category names

**Definition**

> getFillTypeIndicesByFruitTypeCategoryName(string fruitTypeCategoryNames, string? warning)

**Arguments**

| string  | fruitTypeCategoryNames | fruit type categories         |
|---------|------------------------|-------------------------------|
| string? | warning                | warning if category not found |

**Return Values**

| string? | fillTypes | fill type indices |
|---------|-----------|-------------------|

**Code**

```lua
function FruitTypeManager:getFillTypeIndicesByFruitTypeCategoryName(fruitTypeCategoryNames, warning)
    local fillTypes = self:getFillTypesByFruitTypeCategoryNames(fruitTypeCategoryNames, warning)

    -- convert to list of indices
    for index, fillType in ipairs(fillTypes) do
        fillTypes[index] = fillType.index
    end

    return fillTypes -- indices
end

```

### getFillTypeIndicesByFruitTypeNames

**Description**

> Gets a list of fillType indices from string of space separated fruit type names

**Definition**

> getFillTypeIndicesByFruitTypeNames(string names, string? warning)

**Arguments**

| string  | names   | fruit type names               |
|---------|---------|--------------------------------|
| string? | warning | warning if fill type not found |

**Return Values**

| string? | fillTypes | fill types |
|---------|-----------|------------|

**Code**

```lua
function FruitTypeManager:getFillTypeIndicesByFruitTypeNames(names, warning)
    local fillTypes = self:getFillTypesByFruitTypeNames(names, warning)

    -- convert to list of indices
    for index, fillType in ipairs(fillTypes) do
        fillTypes[index] = fillType.index
    end

    return fillTypes -- indices
end

```

### getFillTypeLiterPerSqm

**Description**

> Get fill type liter per sqm

**Definition**

> getFillTypeLiterPerSqm(integer fillTypeIndex, float defaultValue)

**Arguments**

| integer | fillTypeIndex | fill type index                      |
|---------|---------------|--------------------------------------|
| float   | defaultValue  | default value if fill type not found |

**Return Values**

| float | literPerSqm | liter per sqm |
|-------|-------------|---------------|

**Code**

```lua
function FruitTypeManager:getFillTypeLiterPerSqm(fillTypeIndex, defaultValue)
    --#debug Assert.isInteger(fillTypeIndex)
    local fruitType = self.fruitTypes[ self:getFruitTypeIndexByFillTypeIndex(fillTypeIndex)]
    if fruitType ~ = nil then
        if fruitType.hasWindrow then
            return fruitType.windrowLiterPerSqm
        else
                return fruitType.literPerSqm
            end
        end
        return defaultValue
    end

```

### getFillTypeNameByFruitTypeIndex

**Description**

**Definition**

> getFillTypeNameByFruitTypeIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | fillTypeName |
|---------|--------------|

**Code**

```lua
function FruitTypeManager:getFillTypeNameByFruitTypeIndex(index)
    --#debug Assert.isInteger(index)
    local fillTypeIndex = self.fruitTypeIndexToFillType[index]
    return fillTypeIndex and fillTypeIndex.name or nil
end

```

### getFillTypesByFruitTypeCategoryNames

**Description**

> Gets a list of fillTypes from string of space separated fruit type category names

**Definition**

> getFillTypesByFruitTypeCategoryNames(string fruitTypeCategoryNames, string? warning)

**Arguments**

| string  | fruitTypeCategoryNames | fruit type categories         |
|---------|------------------------|-------------------------------|
| string? | warning                | warning if category not found |

**Return Values**

| string? | fillTypes | fill types |
|---------|-----------|------------|

**Code**

```lua
function FruitTypeManager:getFillTypesByFruitTypeCategoryNames(fruitTypeCategoryNames, warning)
    local fillTypes = { }
    local alreadyAdded = { }
    local categories = string.split(fruitTypeCategoryNames, " " )
    for _, categoryName in pairs(categories) do
        categoryName = string.upper(categoryName)
        local category = self.categories[categoryName]
        if category ~ = nil then
            for _, fruitTypeIndex in ipairs( self.categoryIndexToFruitTypeIndex[category]) do
                local fillType = self:getFillTypeByFruitTypeIndex(fruitTypeIndex)
                if fillType ~ = nil then
                    if alreadyAdded[fillType] = = nil then
                        table.insert(fillTypes, fillType)
                        alreadyAdded[fillType] = true
                    end
                end
            end
        else
                if warning ~ = nil then
                    printWarning( string.format(warning, categoryName))
                end
            end
        end
        return fillTypes
    end

```

### getFillTypesByFruitTypeNames

**Description**

> Gets a list of fillType from string with fruit type names

**Definition**

> getFillTypesByFruitTypeNames(string names, string? warning)

**Arguments**

| string  | names   | fruit type names               |
|---------|---------|--------------------------------|
| string? | warning | warning if fill type not found |

**Return Values**

| string? | fillTypes | fill types |
|---------|-----------|------------|

**Code**

```lua
function FruitTypeManager:getFillTypesByFruitTypeNames(names, warning)
    local fillTypes = { }
    local alreadyAdded = { }
    local fruitTypeNames = string.split(names, " " )
    for _, name in pairs(fruitTypeNames) do
        local fillType = nil
        local fruitType = self:getFruitTypeByName(name)
        if fruitType ~ = nil then
            fillType = self:getFillTypeByFruitTypeIndex(fruitType.index)
        end
        if fillType ~ = nil then
            if alreadyAdded[fillType] = = nil then
                table.insert(fillTypes, fillType)
                alreadyAdded[fillType] = true
            end
        else
                if warning ~ = nil then
                    printWarning( string.format(warning, name))
                end
            end
        end

        return fillTypes
    end

```

### getFruitTypeByFillTypeIndex

**Description**

**Definition**

> getFruitTypeByFillTypeIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | fruitType |
|---------|-----------|

**Code**

```lua
function FruitTypeManager:getFruitTypeByFillTypeIndex(index)
    --#debug Assert.isInteger(index)
    return self.fruitTypes[ self.fillTypeIndexToFruitTypeIndex[index]]
end

```

### getFruitTypeByIndex

**Description**

> Gets a fruitType by index

**Definition**

> getFruitTypeByIndex(integer index)

**Arguments**

| integer | index | the fruit index |
|---------|-------|-----------------|

**Return Values**

| integer | fruit | the fruit object |
|---------|-------|------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypeByIndex(index)
    return self.indexToFruitType[index]
end

```

### getFruitTypeByName

**Description**

> Gets a fruitType by index name

**Definition**

> getFruitTypeByName(string name)

**Arguments**

| string | name | the fruit index name |
|--------|------|----------------------|

**Return Values**

| string | fruitType | the fruit object |
|--------|-----------|------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypeByName(name)
    if name = = nil then
        return nil
    end

    return self.nameToFruitType[ string.upper(name)]
end

```

### getFruitTypeIndexByFillTypeIndex

**Description**

**Definition**

> getFruitTypeIndexByFillTypeIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | fruitTypeIndex |
|---------|----------------|

**Code**

```lua
function FruitTypeManager:getFruitTypeIndexByFillTypeIndex(index)
    --#debug Assert.isInteger(index)
    return self.fillTypeIndexToFruitTypeIndex[index]
end

```

### getFruitTypeIndicesByCategoryNames

**Description**

> Gets a list of fruitTypesIndices of the given category names

**Definition**

> getFruitTypeIndicesByCategoryNames(string names, string warning)

**Arguments**

| string | names   | string of space separated fruitType category index names |
|--------|---------|----------------------------------------------------------|
| string | warning | a warning text shown if a category is not found          |

**Return Values**

| string | fruitTypesIndices | list of fruitTypeIndices |
|--------|-------------------|--------------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypeIndicesByCategoryNames(names, warning)
    local fruitTypes = self:getFruitTypesByCategoryNames(names, warning)

    -- convert to list of indices
    for index, fruitType in ipairs(fruitTypes) do
        fruitTypes[index] = fruitType.index
    end

    return fruitTypes -- indices
end

```

### getFruitTypeIndicesByNames

**Description**

> Gets list of fruitType indices from string with space separated fruit type names

**Definition**

> getFruitTypeIndicesByNames(string names, string? warning)

**Arguments**

| string  | names   | string of space separated fruit type names |
|---------|---------|--------------------------------------------|
| string? | warning | warning if fruit type not found            |

**Return Values**

| string? | fruitTypeIndices | array of fruit type indices |
|---------|------------------|-----------------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypeIndicesByNames(names, warning)
    local fruitTypes = self:getFruitTypesByNames(names, warning)

    -- convert to list of indices
    for index, fruitType in ipairs(fruitTypes) do
        fruitTypes[index] = fruitType.index
    end

    return fruitTypes -- indices
end

```

### getFruitTypeNameByIndex

**Description**

**Definition**

> getFruitTypeNameByIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | fruitTypeName |
|---------|---------------|

**Code**

```lua
function FruitTypeManager:getFruitTypeNameByIndex(index)
    local fruitType = self.indexToFruitType[index]
    if fruitType ~ = nil then
        return fruitType.name
    end

    if index = = FruitType.UNKNOWN then
        return "UNKNOWN"
    end

    return nil
end

```

### getFruitTypes

**Description**

> Gets a list of fruitTypes

**Definition**

> getFruitTypes()

**Return Values**

| integer | fruitTypes | a list of fruitTypes |
|---------|------------|----------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypes()
    return self.fruitTypes
end

```

### getFruitTypesByCategoryNames

**Description**

> Gets an array of fruitTypes (tables/objects) of the given category names

**Definition**

> getFruitTypesByCategoryNames(string names, string warning)

**Arguments**

| string | names   | string of space separated fruitType category index names |
|--------|---------|----------------------------------------------------------|
| string | warning | a warning text shown if a category is not found          |

**Return Values**

| string | fruitTypes | array of fruitTypes (tables/objects) |
|--------|------------|--------------------------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypesByCategoryNames(names, warning)
    local fruitTypes = { }
    local alreadyAdded = { }
    local categories = string.split(names, " " )
    for _, categoryName in pairs(categories) do
        categoryName = string.upper(categoryName)
        local categoryIndex = self.categories[categoryName]
        local categoryFruitTypeIndices = self.categoryIndexToFruitTypeIndex[categoryIndex]
        if categoryFruitTypeIndices ~ = nil then
            for _, fruitTypeIndex in ipairs(categoryFruitTypeIndices) do
                local fruitType = self.indexToFruitType[fruitTypeIndex]
                if alreadyAdded[fruitType] = = nil then
                    table.insert(fruitTypes, fruitType)
                    alreadyAdded[fruitType] = true
                end
            end
        else
                if warning ~ = nil then
                    printWarning( string.format(warning, categoryName))
                end
            end
        end
        return fruitTypes
    end

```

### getFruitTypesByNames

**Description**

> Gets list of fruitTypes (tables/objects) from string with fruit type names

**Definition**

> getFruitTypesByNames(string names, string? warning)

**Arguments**

| string  | names   | string of space separated fruit type names |
|---------|---------|--------------------------------------------|
| string? | warning | warning if fruit type not found            |

**Return Values**

| string? | fruitTypes | array of fruit types (tables/objects) |
|---------|------------|---------------------------------------|

**Code**

```lua
function FruitTypeManager:getFruitTypesByNames(names, warning)
    local fruitTypes = { }
    local alreadyAdded = { }
    local fruitTypeNames = string.split(names, " " )
    for _, name in pairs(fruitTypeNames) do
        name = string.upper(name)
        local fruitType = self.nameToFruitType[name]
        if fruitType ~ = nil then
            if alreadyAdded[fruitType] = = nil then
                table.insert(fruitTypes, fruitType)
                alreadyAdded[fruitType] = true
            end
        else
                if warning ~ = nil then
                    printWarning( string.format(warning, name))
                end
            end
        end

        return fruitTypes
    end

```

### getWindrowFillTypeIndexByFruitTypeIndex

**Description**

**Definition**

> getWindrowFillTypeIndexByFruitTypeIndex(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | windrowFillTypeIndex |
|---------|----------------------|

**Code**

```lua
function FruitTypeManager:getWindrowFillTypeIndexByFruitTypeIndex(index)
    --#debug Assert.isInteger(index)
    return self.fruitTypeIndexToWindrowFillTypeIndex[index]
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function FruitTypeManager:initDataStructures()
    self.fruitTypes = { }
    self.indexToFruitType = { }
    self.nameToIndex = { }
    self.nameToFruitType = { }
    self.fruitTypeIndexToFillType = { }
    self.fillTypeIndexToFruitTypeIndex = { }
    self.densityTypeIndexToFruitType = { }
    self.filenameToFruitType = { }

    self.fruitTypeConverters = { }
    self.fruitTypeConverterLoadData = { }
    self.converterNameToIndex = { }
    self.nameToConverter = { }

    self.windrowFillTypes = { }
    self.fruitTypeIndexToWindrowFillTypeIndex = { }
    self.windrowCutFillTypeIndexToFruitTypeIndex = { }

    self.modFoliageTypesToLoad = { }

    self.numCategories = 0
    self.categories = { }
    self.indexToCategory = { }
    self.categoryIndexToFruitTypeIndex = { }

    FruitType = self.nameToIndex
    FruitType.UNKNOWN = 0
    FruitTypeCategory = self.categories
    FruitTypeConverter = self.converterNameToIndex

    self.defaultDataPlaneId = nil
end

```

### isFillTypeWindrow

**Description**

**Definition**

> isFillTypeWindrow(integer index)

**Arguments**

| integer | index |
|---------|-------|

**Return Values**

| integer | isFillTypeWindrow |
|---------|-------------------|

**Code**

```lua
function FruitTypeManager:isFillTypeWindrow(index)
    if index ~ = nil then
        --#debug Assert.isInteger(index)
        return self.windrowFillTypes[index] = = true
    end
    return false
end

```

### loadDefaultTypes

**Description**

**Definition**

> loadDefaultTypes()

**Code**

```lua
function FruitTypeManager:loadDefaultTypes()
    local xmlFile = loadXMLFile( "fuitTypes" , "data/maps/maps_fruitTypes.xml" )
    self:loadFruitTypes(xmlFile, nil , "" , true )
    delete(xmlFile)
end

```

### loadFruitTypes

**Description**

> Loads fruitTypes

**Definition**

> loadFruitTypes(entityId xmlFileHandle, table missionInfo, string? baseDirectory, boolean? isBaseType)

**Arguments**

| entityId | xmlFileHandle |
|----------|---------------|
| table    | missionInfo   |
| string?  | baseDirectory |
| boolean? | isBaseType    |

**Return Values**

| boolean? | success | success |
|----------|---------|---------|

**Code**

```lua
function FruitTypeManager:loadFruitTypes(xmlFileHandle, missionInfo, baseDirectory, isBaseType)
    local xmlFile = XMLFile.wrap(xmlFileHandle)
    local rootName = xmlFile:getRootName()

    local maxNumFruitTypes = 2 ^ FruitTypeManager.SEND_NUM_BITS - 1

    for _, key in xmlFile:iterator(rootName .. ".fruitTypes.fruitType" ) do
        if # self.fruitTypes > = maxNumFruitTypes then
            Logging.xmlError(xmlFile, "FruitTypeManager.loadFruitTypes:too many fruit types.Only %d fruit types are supported" , maxNumFruitTypes)
            break
        end

        local filename = xmlFile:getString(key .. "#filename" )
        if filename ~ = nil then
            filename = Utils.getFilename(filename, baseDirectory)

            local fruitTypeDesc = FruitTypeDesc.new()
            if fruitTypeDesc:loadFromFoliageXMLFile(filename) then
                if self.modFruitTypes ~ = nil then
                    for k, modFruitTypeDesc in ipairs( self.modFruitTypes) do
                        if modFruitTypeDesc.name = = fruitTypeDesc.name then
                            -- delete default fruitType
                            fruitTypeDesc:delete()

                            -- use mod fruitType
                            fruitTypeDesc = modFruitTypeDesc

                            table.remove( self.modFruitTypes, k)
                            break
                        end
                    end
                end

                self:addFruitType(fruitTypeDesc)
            end
        else
                Logging.xmlWarning(xmlFile, "FruitTypeManager.loadFruitTypes:Missing fruit type filename for '%s'" , key)
                end
            end

            if self.modFruitTypes ~ = nil then
                for _, modFruitTypeDesc in ipairs( self.modFruitTypes) do
                    self:addFruitType(modFruitTypeDesc)
                end
            end
            self.modFruitTypes = nil

            self:loadCategoriesFromXML(xmlFile, rootName, isBaseType)
            self:loadConvertersFromXML(xmlFile, rootName, isBaseType)

            xmlFile:delete()
        end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData(entityId xmlFileHandle, table missionInfo, string? baseDirectory)

**Arguments**

| entityId | xmlFileHandle |
|----------|---------------|
| table    | missionInfo   |
| string?  | baseDirectory |

**Return Values**

| string? | true | if loading was successful else false |
|---------|------|--------------------------------------|

**Code**

```lua
function FruitTypeManager:loadMapData(xmlFileHandle, missionInfo, baseDirectory)
    FruitTypeManager:superClass().loadMapData( self )

    self.modFruitTypes = { }
    XMLUtil.loadDataFromMapXML(xmlFileHandle, "fruitTypes" , baseDirectory, self , self.loadMapFruitTypes, missionInfo, baseDirectory)

    self:loadDefaultTypes()

    XMLUtil.loadDataFromMapXML(xmlFileHandle, "fruitTypes" , baseDirectory, self , self.loadMapCategoriesAndConverters, missionInfo, baseDirectory)

    -- initialize the fruit type converters after all fruit types have been loaded
    self:initializeFruitTypeConverters()

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

| table? | self |
|--------|------|

**Code**

```lua
function FruitTypeManager.new(customMt)
    local self = AbstractManager.new(customMt or FruitTypeManager _mt)

    addConsoleCommand( "gsFruitTypesExportStats" , "Exports the fruit type stats into a text file" , "consoleCommandExportStats" , self )

    return self
end

```