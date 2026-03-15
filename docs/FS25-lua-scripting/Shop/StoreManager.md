## StoreManager

**Description**

> This class handles all store categories and items

**Parent**

> [AbstractManager](?version=script&category=75&class=615)

**Functions**

- [addCategory](#addcategory)
- [addConstructionCategory](#addconstructioncategory)
- [addConstructionTab](#addconstructiontab)
- [addItem](#additem)
- [addModStoreItem](#addmodstoreitem)
- [addModStorePack](#addmodstorepack)
- [addPack](#addpack)
- [addPackItem](#addpackitem)
- [addSpecType](#addspectype)
- [consoleCommandReloadStoreItems](#consolecommandreloadstoreitems)
- [getCategoryByName](#getcategorybyname)
- [getConstructionCategories](#getconstructioncategories)
- [getConstructionCategoryByName](#getconstructioncategorybyname)
- [getConstructionTabByName](#getconstructiontabbyname)
- [getIsItemUnlocked](#getisitemunlocked)
- [getItemByCustomEnvironment](#getitembycustomenvironment)
- [getItemByIndex](#getitembyindex)
- [getItemByXMLFilename](#getitembyxmlfilename)
- [getItems](#getitems)
- [getItemsByCombinationData](#getitemsbycombinationdata)
- [getPackItems](#getpackitems)
- [getPacks](#getpacks)
- [getSpecTypeByName](#getspectypebyname)
- [getSpecTypeByProfile](#getspectypebyprofile)
- [getSpecTypes](#getspectypes)
- [initDataStructures](#initdatastructures)
- [loadCategoryFromXML](#loadcategoryfromxml)
- [loadItem](#loaditem)
- [loadItemsFromXML](#loaditemsfromxml)
- [loadMapData](#loadmapdata)
- [new](#new)
- [registerStoreDataXMLPaths](#registerstoredataxmlpaths)
- [removeItemByIndex](#removeitembyindex)
- [unloadMapData](#unloadmapdata)

### addCategory

**Description**

> Adds a new store category

**Definition**

> addCategory(string name, string title, string imageFilename, string categoryTypeName, string baseDir, string
> insertAfter)

**Arguments**

| string | name             | category index name                          |
|--------|------------------|----------------------------------------------|
| string | title            | category title                               |
| string | imageFilename    | image                                        |
| string | categoryTypeName | name of the category type                    |
| string | baseDir          | base directory                               |
| string | insertAfter      | insert the category after this category name |

**Return Values**

| string | true | if adding was successful else false |
|--------|------|-------------------------------------|

**Code**

```lua
function StoreManager:addCategory(name, title, imageFilename, categoryTypeName, baseDir, insertAfter)
    if string.isNilOrWhitespace(name) then
        Logging.warning( "Could not register store category.Name is missing or empty!" )
        return false
    end
    if not ClassUtil.getIsValidIndexName(name) then
        Logging.warning( "Could not register store category '%s'.Invalid name for a category!" , name)
            return false
        end
        if string.isNilOrWhitespace(title) then
            Logging.warning( "Could not register store category '%s'.Title is missing or empty!" , name)
            return false
        end
        if string.isNilOrWhitespace(imageFilename) then
            Logging.warning( "Could not register store category '%s'.Image is missing or empty!" , name)
            return false
        end
        if baseDir = = nil then
            Logging.warning( "Could not register store category '%s'.Basedirectory not defined!" , name)
            return false
        end
        if string.isNilOrWhitespace(categoryTypeName) then
            Logging.warning( "Could not register store category '%s'.CategoryType is missing or empty!" , name)
            return false
        end
        local categoryTypeNameUpper = string.upper(categoryTypeName)
        local categoryType = self.categoryTypesByName[categoryTypeNameUpper]
        if categoryType = = nil then
            Logging.warning( "Could not register store category '%s'.CategoryType '%s' is not defined!" , name, categoryTypeName)
            return false
        end

        local nameUpper = string.upper(name)
        if GS_PLATFORM_SWITCH and name = = "COINS" then
            return false
        end

        if self.categoryByName[nameUpper] ~ = nil then
            Logging.warning( "Could not register store category '%s'.Already exists!" , name)
            return false
        end

        local category = {
        name = nameUpper,
        title = title,
        image = Utils.getFilename(imageFilename, baseDir),
        type = categoryTypeNameUpper,
        orderId = # self.categories
        }

        local needsInsert = true
        if insertAfter ~ = nil then
            local insertAfterUpper = string.upper(insertAfter)
            for k, existingCategory in ipairs( self.categories) do
                if existingCategory.name = = insertAfterUpper then
                    table.insert( self.categories, k + 1 , category)
                    needsInsert = false

                    for index, _category in ipairs( self.categories) do
                        _category.orderId = index
                    end

                    break
                end
            end
        end

        if needsInsert then
            table.insert( self.categories, category)
        end

        self.categoryByName[nameUpper] = category

        return true
    end

```

### addConstructionCategory

**Description**

> Add a new construction category.

**Definition**

> addConstructionCategory()

**Arguments**

| any | name         |
|-----|--------------|
| any | title        |
| any | iconFilename |
| any | iconUVs      |
| any | baseDir      |
| any | iconSliceId  |

**Code**

```lua
function StoreManager:addConstructionCategory(name, title, iconFilename, iconUVs, baseDir, iconSliceId)
    name = string.upper(name)

    if self.constructionCategoriesByName[name] ~ = nil then
        Logging.warning( "Construction category '%s' already exists." , name)
        return
    end

    local category = {
    name = name,
    title = title,
    iconFilename = Utils.getFilename(iconFilename, baseDir),
    iconUVs = iconUVs,
    iconSliceId = iconSliceId,
    tabs = { } ,
    index = # self.constructionCategories + 1
    }

    table.insert( self.constructionCategories, category)
    self.constructionCategoriesByName[name] = category
end

```

### addConstructionTab

**Description**

> Add a new construction tab

**Definition**

> addConstructionTab()

**Arguments**

| any | categoryName |
|-----|--------------|
| any | name         |
| any | title        |
| any | iconFilename |
| any | iconUVs      |
| any | baseDir      |
| any | iconSliceId  |

**Code**

```lua
function StoreManager:addConstructionTab(categoryName, name, title, iconFilename, iconUVs, baseDir, iconSliceId)
    local category = self:getConstructionCategoryByName(categoryName)
    if category = = nil then
        return
    end

    table.insert(category.tabs, {
    name = string.upper(name),
    title = title,
    iconFilename = Utils.getFilename(iconFilename, baseDir),
    iconUVs = iconUVs,
    iconSliceId = iconSliceId,
    index = #category.tabs + 1
    } )
end

```

### addItem

**Description**

> Adds a new store item

**Definition**

> addItem(table storeItem)

**Arguments**

| table | storeItem | the storeitem object |
|-------|-----------|----------------------|

**Return Values**

| table | wasSuccessfull | true if added else false |
|-------|----------------|--------------------------|

**Code**

```lua
function StoreManager:addItem(storeItem)
    local otherItem = self.xmlFilenameToItem[storeItem.xmlFilenameLower]
    if otherItem ~ = nil then
        -- in case we have added a item already as bundle item, but then afterwards want to add it as regular item as well
        -- so we copy isBundleItem and showInStore from the regular item
        if otherItem.isBundleItem and not storeItem.isBundleItem then
            otherItem.isBundleItem = storeItem.isBundleItem
            otherItem.showInStore = storeItem.showInStore
        end

        return false
    end

    table.insert( self.items, storeItem)
    storeItem.id = # self.items
    self.xmlFilenameToItem[storeItem.xmlFilenameLower] = storeItem

    local isUnlocked = storeItem.extraContentId = = nil or g_extraContentSystem = = nil or g_extraContentSystem:getIsItemIdUnlocked(storeItem.extraContentId)
    if not storeItem.isBundleItem and isUnlocked and storeItem.showInStore and(storeItem.species = = StoreSpecies.VEHICLE or storeItem.species = = StoreSpecies.HANDTOOL) then
        local author = ""
        local customEnvironment = storeItem.customEnvironment
        if storeItem.isMod then
            local mod = g_modManager.nameToMod[customEnvironment]
            if mod ~ = nil and mod.author ~ = nil then
                author = mod.author
            end
        end

        local brand = g_brandManager:getBrandByIndex(storeItem.brandIndex)
        local brandName = storeItem.brandNameRaw or ""
        if brand ~ = nil and brand.name ~ = "NONE" then
            brandName = brand.title
        end

        self.indexedSearch:addDocument(
        {
        title = storeItem.name,
        brand = brandName,
        author = author,
        dlcTitle = storeItem.dlcTitle
        } ,
        storeItem
        )
    end

    return true
end

```

### addModStoreItem

**Description**

**Definition**

> addModStoreItem()

**Arguments**

| any | xmlFilename       |
|-----|-------------------|
| any | baseDir           |
| any | customEnvironment |
| any | isMod             |
| any | isBundleItem      |
| any | dlcTitle          |

**Code**

```lua
function StoreManager:addModStoreItem(xmlFilename, baseDir, customEnvironment, isMod, isBundleItem, dlcTitle)
    table.insert( self.modStoreItems, { xmlFilename = xmlFilename, baseDir = baseDir, customEnvironment = customEnvironment, isMod = isMod, isBundleItem = isBundleItem, dlcTitle = dlcTitle } )
end

```

### addModStorePack

**Description**

**Definition**

> addModStorePack()

**Arguments**

| any | name          |
|-----|---------------|
| any | title         |
| any | imageFilename |
| any | baseDir       |
| any | storeItems    |

**Code**

```lua
function StoreManager:addModStorePack(name, title, imageFilename, baseDir, storeItems)
    table.insert( self.modStorePacks,
    {
    name = name,
    title = title,
    imageFilename = imageFilename,
    baseDir = baseDir,
    storeItems = storeItems or { }
    }
    )
end

```

### addPack

**Description**

> Adds a new store pack

**Definition**

> addPack(string name, string title, string imageFilename, string baseDir)

**Arguments**

| string | name          | pack name      |
|--------|---------------|----------------|
| string | title         | pack title     |
| string | imageFilename | image          |
| string | baseDir       | base directory |

**Return Values**

| string | true | if adding was successful else false |
|--------|------|-------------------------------------|

**Code**

```lua
function StoreManager:addPack(name, title, imageFilename, baseDir)
    if name = = nil or name = = "" then
        printWarning( "Warning:Could not register store pack.Name is missing or empty!" )
        return false
    end
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is no valid name for a store pack!" )
            return false
        end
        if title = = nil or title = = "" then
            printWarning( "Warning:Could not register store pack.Title is missing or empty!" )
            return false
        end
        if imageFilename = = nil or imageFilename = = "" then
            printWarning( "Warning:Could not register store pack.Image is missing or empty!" )
            return false
        end
        if baseDir = = nil then
            printWarning( "Warning:Could not register store pack.Basedirectory not defined!" )
            return false
        end

        name = string.upper(name)

        if self.packs[name] = = nil then
            self.numOfPacks = self.numOfPacks + 1

            self.packs[name] = {
            name = name,
            title = title,
            image = Utils.getFilename(imageFilename, baseDir),
            baseDir = baseDir,
            orderId = self.numOfPacks,
            items = { }
            }

            return true
        end

        return false
    end

```

### addPackItem

**Description**

> Add a new pack item.

**Definition**

> addPackItem(string name, string itemFilename)

**Arguments**

| string | name         | Name of the pack                        |
|--------|--------------|-----------------------------------------|
| string | itemFilename | XML filename of the vehicle in the pack |

**Code**

```lua
function StoreManager:addPackItem(name, itemFilename)
    if name = = nil or name = = "" then
        Logging.warning( "Could not add pack item.Name is missing or empty." )
        return
    end
    if self.packs[name] = = nil then
        Logging.warning( "Could not add pack item.Pack '%s' does not exist." , name)
        return
    end
    if itemFilename = = nil or itemFilename = = "" then
        Logging.warning( "Could not add pack item to '%s'.Item filename is missing." , name)
        return
    end

    table.insert( self.packs[name].items, itemFilename)
end

```

### addSpecType

**Description**

> Adds a new spec type

**Definition**

> addSpecType(string name, string? profile, function? loadFunc, function getValueFunc, int species, table?
> relatedConfigurations, function? configDataFunc)

**Arguments**

| string    | name                  | spec type index name           |
|-----------|-----------------------|--------------------------------|
| string?   | profile               | spec type gui profile          |
| function? | loadFunc              | the loading function pointer   |
| function  | getValueFunc          | the get value function pointer |
| int       | species               | the species identifier         |
| table?    | relatedConfigurations |                                |
| function? | configDataFunc        |                                |

**Code**

```lua
function StoreManager:addSpecType(name, profile, loadFunc, getValueFunc, species, relatedConfigurations, configDataFunc)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is no valid name for a spec type!" )
            return
        end

        --#debug Assert.isNilOrType(relatedConfigurations, "table")
        --#debug Assert.isNilOrType(configDataFunc, "function")

            name = name

            if self.nameToSpecType = = nil then
                printCallstack()
            end

            if self.nameToSpecType[name] ~ = nil then
                printError( "Error:spec type name '" .. name .. "' is already in use!" )
                return
            end

            local specType = { }
            specType.name = name
            specType.profile = profile
            specType.loadFunc = loadFunc
            specType.getValueFunc = getValueFunc
            specType.species = species or StoreSpecies.VEHICLE
            specType.relatedConfigurations = relatedConfigurations
            specType.configDataFunc = configDataFunc

            self.nameToSpecType[name] = specType
            table.insert( self.specTypes, specType)
        end

```

### consoleCommandReloadStoreItems

**Description**

**Definition**

> consoleCommandReloadStoreItems()

**Code**

```lua
function StoreManager:consoleCommandReloadStoreItems()
    for i, item in ipairs( self.items) do
        self.items[i] = self:loadItem(item.rawXMLFilename, item.baseDir, item.customEnvironment, item.isMod, item.isBundleItem, item.dlcTitle, item.extraContentId, true )
        if self.items[i] ~ = nil then
            self.xmlFilenameToItem[ self.items[i].xmlFilenameLower] = self.items[i]
        end
    end

    g_messageCenter:publish(MessageType.STORE_ITEMS_RELOADED)
end

```

### getCategoryByName

**Description**

> Gets a store category by name

**Definition**

> getCategoryByName(string name)

**Arguments**

| string | name | category index name |
|--------|------|---------------------|

**Return Values**

| string | category | the category object |
|--------|----------|---------------------|

**Code**

```lua
function StoreManager:getCategoryByName(name)
    if name ~ = nil then
        return self.categoryByName[ string.upper(name)]
    end
    return nil
end

```

### getConstructionCategories

**Description**

> Get categories for construction screen

**Definition**

> getConstructionCategories()

**Code**

```lua
function StoreManager:getConstructionCategories()
    return self.constructionCategories
end

```

### getConstructionCategoryByName

**Description**

> Get construction category by name

**Definition**

> getConstructionCategoryByName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function StoreManager:getConstructionCategoryByName(name)
    if name ~ = nil then
        return self.constructionCategoriesByName[ string.upper(name)]
    end
    return nil
end

```

### getConstructionTabByName

**Description**

> Get a construction tab using its name and category name

**Definition**

> getConstructionTabByName()

**Arguments**

| any | name         |
|-----|--------------|
| any | categoryName |

**Code**

```lua
function StoreManager:getConstructionTabByName(name, categoryName)
    local category = self:getConstructionCategoryByName(categoryName)
    if category = = nil or name = = nil then
        return nil
    end

    name = string.upper(name)

    for i, tab in ipairs(category.tabs) do
        if tab.name = = name then
            return tab
        end
    end

    return nil
end

```

### getIsItemUnlocked

**Description**

> Returns if store item is unlocked

**Definition**

> getIsItemUnlocked(table storeItem)

**Arguments**

| table | storeItem | the storeitem oject |
|-------|-----------|---------------------|

**Return Values**

| table | isUnlocked | is unlocked |
|-------|------------|-------------|

**Code**

```lua
function StoreManager:getIsItemUnlocked(storeItem)
    if storeItem ~ = nil and(storeItem.extraContentId = = nil or g_extraContentSystem:getIsItemIdUnlocked(storeItem.extraContentId)) then
        return true
    end

    return false
end

```

### getItemByCustomEnvironment

**Description**

> Gets a store item xml filename

**Definition**

> getItemByCustomEnvironment(string xmlFilename)

**Arguments**

| string | xmlFilename | storeitem xml filename |
|--------|-------------|------------------------|

**Return Values**

| string | storeItem | the storeitem object |
|--------|-----------|----------------------|

**Code**

```lua
function StoreManager:getItemByCustomEnvironment(customEnvironment)
    local items = { }
    for _, item in ipairs( self.items) do
        if item.customEnvironment = = customEnvironment then
            table.insert(items, item)
        end
    end

    return items
end

```

### getItemByIndex

**Description**

> Gets a store item by index

**Definition**

> getItemByIndex(integer index)

**Arguments**

| integer | index | store item index |
|---------|-------|------------------|

**Return Values**

| integer | storeItem | the storeitem oject |
|---------|-----------|---------------------|

**Code**

```lua
function StoreManager:getItemByIndex(index)
    if index ~ = nil then
        return self.items[index]
    end
    return nil
end

```

### getItemByXMLFilename

**Description**

> Gets a store item xml filename

**Definition**

> getItemByXMLFilename(string xmlFilename)

**Arguments**

| string | xmlFilename | storeitem xml filename |
|--------|-------------|------------------------|

**Return Values**

| string | storeItem | the storeitem object |
|--------|-----------|----------------------|

**Code**

```lua
function StoreManager:getItemByXMLFilename(xmlFilename)
    if xmlFilename ~ = nil then
        return self.xmlFilenameToItem[ string.lower(xmlFilename)]
    end

    return nil
end

```

### getItems

**Description**

> Gets all storeitems

**Definition**

> getItems()

**Return Values**

| string | items | a list of all store items |
|--------|-------|---------------------------|

**Code**

```lua
function StoreManager:getItems()
    return self.items
end

```

### getItemsByCombinationData

**Description**

> Returns store items that match the given combination data

**Definition**

> getItemsByCombinationData(table combinationData)

**Arguments**

| table | combinationData | combination data |
|-------|-----------------|------------------|

**Return Values**

| table | storeItems | table with store items |
|-------|------------|------------------------|

**Code**

```lua
function StoreManager:getItemsByCombinationData(combinationData)
    local items = { }

    if combinationData.xmlFilename ~ = nil then
        -- case 1:combination is direct xml reference
        local storeItem = self.xmlFilenameToItem[ string.lower(combinationData.customXMLFilename)]
        if storeItem = = nil then
            storeItem = self.xmlFilenameToItem[ string.lower(combinationData.xmlFilename)]
            if storeItem = = nil then
                Logging.warning( "Could not find combination vehicle '%s'" , combinationData.xmlFilename)
            end
        end

        if self:getIsItemUnlocked(storeItem) then
            table.insert(items, { storeItem = storeItem } )
        end
    else
            -- case 2:combination is a filter category
            for _, storeItem in ipairs( self.items) do
                if not self:getIsItemUnlocked(storeItem) then
                    continue
                end

                local categoryAllowed = true
                if combinationData.filterCategories ~ = nil then
                    categoryAllowed = false
                    if storeItem.categoryNames ~ = nil then
                        for _, filterCategoryName in ipairs(combinationData.filterCategories) do
                            for _, storeItemCategoryName in ipairs(storeItem.categoryNames) do
                                if string.upper(filterCategoryName) = = storeItemCategoryName then
                                    categoryAllowed = true
                                    break
                                end
                            end
                        end
                    end
                end

                if not categoryAllowed then
                    continue
                end

                if combinationData.filterSpec = = nil then
                    -- basic category filter, no further limitations
                    table.insert(items, { storeItem = storeItem } )
                else
                        local desc = self:getSpecTypeByName(combinationData.filterSpec)
                        if desc = = nil then
                            continue
                        end

                        if desc.species ~ = storeItem.species then
                            continue
                        end

                        StoreItemUtil.loadSpecsFromXML(storeItem)

                        local value, _maxValue = desc.getValueFunc(storeItem, nil , nil , nil , true , true )
                        if value = = nil then
                            continue
                        end

                        local specMin = combinationData.filterSpecMin
                        local specMax = combinationData.filterSpecMax
                        -- special case weight -> in the xml we defined it as kg, but in code we handle it always as tons
                        if combinationData.filterSpec = = "weight" then
                            specMin = specMin / 1000
                            specMax = specMax / 1000
                        end

                        if value > = specMin and value < = specMax then
                            -- filter with extra spec limit matches
                            table.insert(items, { storeItem = storeItem } )
                        else
                                if desc.configDataFunc ~ = nil then
                                    local configDatas = desc.configDataFunc(storeItem)
                                    if configDatas ~ = nil then
                                        for _, configData in ipairs(configDatas) do
                                            if configData.value > = specMin and configData.value < = specMax then
                                                table.insert(items, { storeItem = storeItem, configData = { [configData.name] = configData.index } } )
                                            end
                                        end
                                    end
                                else
                                        if desc.relatedConfigurations ~ = nil and storeItem.configurations ~ = nil then
                                            for _, configurationName in ipairs(desc.relatedConfigurations) do
                                                if storeItem.configurations[configurationName] ~ = nil then
                                                    local configItems = storeItem.configurations[configurationName]
                                                    for configIndex = 1 , #configItems do
                                                        local configData = { [configurationName] = configIndex }
                                                        value = desc.getValueFunc(storeItem, nil , configData, nil , true , true )
                                                        if value > = specMin and value < = specMax then
                                                            table.insert(items, { storeItem = storeItem, configData = configData } )
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    return items
                end

```

### getPackItems

**Description**

> Get the items in the pack.

**Definition**

> getPackItems(string name)

**Arguments**

| string | name | name of the pack. |
|--------|------|-------------------|

**Code**

```lua
function StoreManager:getPackItems(name)
    local pack = self.packs[name]
    if pack = = nil then
        return nil
    else
            return pack.items
        end
    end

```

### getPacks

**Description**

> Get a list of all packs

**Definition**

> getPacks()

**Code**

```lua
function StoreManager:getPacks()
    return self.packs
end

```

### getSpecTypeByName

**Description**

> Gets a spec type by name

**Definition**

> getSpecTypeByName(string name)

**Arguments**

| string | name | spec type index name |
|--------|------|----------------------|

**Return Values**

| string | specType | the corresponding spectype |
|--------|----------|----------------------------|

**Code**

```lua
function StoreManager:getSpecTypeByName(name)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is no valid name for a spec type!" )
            return
        end

        return self.nameToSpecType[name]
    end

```

### getSpecTypeByProfile

**Description**

> Gets a spec type by name

**Definition**

> getSpecTypeByProfile(string profile)

**Arguments**

| string | profile | spec type profile name |
|--------|---------|------------------------|

**Return Values**

| string | specType | the corresponding spectype |
|--------|----------|----------------------------|

**Code**

```lua
function StoreManager:getSpecTypeByProfile(profile)
    for i = 1 , # self.specTypes do
        if self.specTypes[i].profile = = profile then
            return self.specTypes[i]
        end
    end

    return nil
end

```

### getSpecTypes

**Description**

> Gets all spec types

**Definition**

> getSpecTypes()

**Return Values**

| string | specTypes | a list of spec types |
|--------|-----------|----------------------|

**Code**

```lua
function StoreManager:getSpecTypes()
    return self.specTypes
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function StoreManager:initDataStructures()
    self.numOfCategories = 0
    self.numOfPacks = 0
    self.categories = { }
    self.categoryByName = { }
    self.categoryTypes = { }
    self.categoryTypesByName = { }
    self.packs = { }
    self.items = { }
    self.xmlFilenameToItem = { }
    self.modStoreItems = { }
    self.modStorePacks = { }
    self.modConstructionTabs = { }

    self.modCategoryTypes = { }

    self.specTypes = { }
    self.nameToSpecType = { }

    self.vramUsageFunctions = { }

    self.constructionCategoriesByName = { }
    self.constructionCategories = { }

    if self.indexedSearch ~ = nil then
        self.indexedSearch:clear()
    end
end

```

### loadCategoryFromXML

**Description**

> Load shop category from XML file

**Definition**

> loadCategoryFromXML(table xmlFile, string key, string baseDir, , )

**Arguments**

| table  | xmlFile   | xml file object |
|--------|-----------|-----------------|
| string | key       | key             |
| string | baseDir   | base directory  |
| any    | customEnv |                 |
| any    | isMod     |                 |

**Code**

```lua
function StoreManager:loadCategoryFromXML(xmlFile, key, baseDir, customEnv, isMod)
    local name = xmlFile:getString(key .. "#name" )
    local title = xmlFile:getString(key .. "#title" )
    local imageFilename = xmlFile:getString(key .. "#image" )
    local categoryType = xmlFile:getString(key .. "#type" )
    local insertAfter = xmlFile:getString(key .. "#insertAfter" )

    if title ~ = nil then
        title = g_i18n:convertText(title, customEnv)
    end

    if isMod then
        local categoryData = { }
        categoryData.name = name
        categoryData.title = title
        categoryData.imageFilename = imageFilename
        categoryData.categoryType = categoryType
        categoryData.baseDir = baseDir
        categoryData.insertAfter = insertAfter
        table.insert( self.modCategoryTypes, categoryData)
    else
            self:addCategory(name, title, imageFilename, categoryType, baseDir, insertAfter)
        end
    end

```

### loadItem

**Description**

> Loads a storeitem from xml file

**Definition**

> loadItem(string xmlFilename, string baseDir, string customEnvironment, boolean isMod, boolean isBundleItem, string?
> dlcTitle, , )

**Arguments**

| string  | xmlFilename       | the storeitem xml filename             |
|---------|-------------------|----------------------------------------|
| string  | baseDir           | the base directory                     |
| string  | customEnvironment | a custom environment                   |
| boolean | isMod             | true if item is a mod, else false      |
| boolean | isBundleItem      | true if item is bundleItem, else false |
| string? | dlcTitle          | optional dlc title                     |
| any     | extraContentId    |                                        |
| any     | ignoreAdd         |                                        |

**Return Values**

| any | storeItem | the storeitem object |
|-----|-----------|----------------------|

**Code**

```lua
function StoreManager:loadItem(rawXMLFilename, baseDir, customEnvironment, isMod, isBundleItem, dlcTitle, extraContentId, ignoreAdd)
    local xmlFilename = Utils.getFilename(rawXMLFilename, baseDir)
    local xmlFile = loadXMLFile( "storeItemXML" , xmlFilename)
    if xmlFile = = 0 then
        return nil
    end

    local baseXMLName = getXMLRootName(xmlFile)
    local storeDataXMLKey = baseXMLName .. ".storeData"

    -- just load the species the old way to categorize the file
    local speciesStr = getXMLString(xmlFile, storeDataXMLKey .. ".species" )
    local species = StoreSpecies.getByName(speciesStr) or StoreSpecies.VEHICLE

    local xmlSchema = self.speciesToSchema[species]
    if xmlSchema ~ = nil then
        delete(xmlFile)
        xmlFile = XMLFile.load( "storeManagerLoadItemXml" , xmlFilename, xmlSchema)
    else
            Logging.xmlError(xmlFile, "Unable to get xml schema for species '%s' in '%s'" , species, xmlFilename)
                return nil
            end

            -- check if file name matches naming convention
                local xmlName = Utils.getFilenameInfo(xmlFilename, true )
                local firstLetter = string.sub(xmlName, 1 , 1 )
                if firstLetter ~ = string.lower(firstLetter) then
                    Logging.xmlDevWarning(xmlFile, "Filename is starting with upper case character.Please follow the lower camel case naming convention." )
                end
                if tonumber(firstLetter) ~ = nil then
                    Logging.xmlDevWarning(xmlFile, "Filename is starting with a number.Please start always with a character." )
                end
                local xmlPathPaths = xmlFilename:split( "/" )
                local numParts = #xmlPathPaths
                if numParts > = 4 then
                    if xmlPathPaths[numParts - 3 ] = = "vehicles" then
                        if string.startsWith( string.lower(xmlPathPaths[numParts]), string.lower(xmlPathPaths[numParts - 2 ])) then
                            Logging.xmlDevWarning(xmlFile, "Vehicle filename '%s' starts with brand name '%s'." , xmlName, xmlPathPaths[numParts - 2 ])
                        end
                    end
                end

                if not xmlFile:hasProperty(storeDataXMLKey) then
                    Logging.xmlError(xmlFile, "No storeData found.StoreItem will be ignored!" )
                    xmlFile:delete()
                    return nil
                end

                local isValid = true
                local name = xmlFile:getValue(storeDataXMLKey .. ".name" , nil , customEnvironment, true )
                if name = = nil then
                    Logging.xmlWarning(xmlFile, "Name missing for storeitem.Ignoring store item!" )
                        isValid = false
                    end

                    if name ~ = nil then
                        local params = xmlFile:getValue(storeDataXMLKey .. ".name#params" )
                        if params ~ = nil then
                            name = g_i18n:insertTextParams(name, params, customEnvironment, xmlFile)
                        end
                    end

                    local imageFilename = xmlFile:getValue(storeDataXMLKey .. ".image" , "" )
                    if imageFilename = = "" then
                        imageFilename = nil
                    end
                    if imageFilename = = nil and xmlFile:getValue(storeDataXMLKey .. ".showInStore" , true ) then
                        Logging.xmlWarning(xmlFile, "Image icon is missing for storeitem.Ignoring store item!" )
                            isValid = false
                        end

                        if not isValid then
                            xmlFile:delete()
                            return nil
                        end

                        local storeItem = { }
                        storeItem.name = name
                        storeItem.extraContentId = extraContentId
                        storeItem.rawXMLFilename = rawXMLFilename
                        storeItem.baseDir = baseDir
                        storeItem.xmlSchema = xmlSchema
                        storeItem.xmlFilename = xmlFilename
                        storeItem.xmlFilenameLower = string.lower(xmlFilename)
                        storeItem.imageFilename = imageFilename and Utils.getFilename(imageFilename, baseDir)
                        storeItem.species = species
                        storeItem.functions = StoreItemUtil.getFunctionsFromXML(xmlFile, storeDataXMLKey, customEnvironment)
                        storeItem.specs = nil
                        storeItem.brandIndex = StoreItemUtil.getBrandIndexFromXML(xmlFile, storeDataXMLKey)
                        storeItem.brandNameRaw = xmlFile:getValue(storeDataXMLKey .. ".brand" , "" )
                        storeItem.customBrandIcon = xmlFile:getValue(storeDataXMLKey .. ".brand#customIcon" )
                        storeItem.customBrandIconOffset = xmlFile:getValue(storeDataXMLKey .. ".brand#imageOffset" )
                        if storeItem.customBrandIcon ~ = nil then
                            storeItem.customBrandIcon = Utils.getFilename(storeItem.customBrandIcon, baseDir)
                        end
                        storeItem.canBeSold = xmlFile:getValue(storeDataXMLKey .. ".canBeSold" , true )
                        storeItem.showInStore = xmlFile:getValue(storeDataXMLKey .. ".showInStore" , not isBundleItem)
                        storeItem.isBundleItem = isBundleItem
                        storeItem.allowLeasing = xmlFile:getValue(storeDataXMLKey .. ".allowLeasing" , true )
                        storeItem.maxItemCount = xmlFile:getValue(storeDataXMLKey .. ".maxItemCount" )
                        storeItem.rotation = xmlFile:getValue(storeDataXMLKey .. ".rotation" , 0 )
                        storeItem.spawnRotationOffset = xmlFile:getValue(storeDataXMLKey .. ".spawnRotationOffset" , nil , true )
                        storeItem.spawnSizeOffset = xmlFile:getValue(storeDataXMLKey .. ".spawnSizeOffset" , nil , true )
                        storeItem.shopDynamicTitle = xmlFile:getValue(storeDataXMLKey .. ".shopDynamicTitle" , false )
                        storeItem.shopTranslationOffset = xmlFile:getValue(storeDataXMLKey .. ".shopTranslationOffset" , nil , true )
                        storeItem.shopRotationOffset = xmlFile:getValue(storeDataXMLKey .. ".shopRotationOffset" , nil , true )
                        storeItem.shopIgnoreLastComponentPositions = xmlFile:getValue(storeDataXMLKey .. ".shopIgnoreLastComponentPositions" , false )
                        storeItem.shopInitialLoadingDelay = xmlFile:getValue(storeDataXMLKey .. ".shopLoadingDelay#initial" )
                        storeItem.shopConfigLoadingDelay = xmlFile:getValue(storeDataXMLKey .. ".shopLoadingDelay#config" )
                        storeItem.shopHeight = xmlFile:getValue(storeDataXMLKey .. ".shopHeight" , 0 )
                        storeItem.financeCategory = xmlFile:getValue(storeDataXMLKey .. ".financeCategory" )
                        storeItem.shopFoldingState = xmlFile:getValue(storeDataXMLKey .. ".shopFoldingState" , 0 )
                        storeItem.shopFoldingTime = xmlFile:getValue(storeDataXMLKey .. ".shopFoldingTime" )

                        --#debug if storeItem.shopTranslationOffset ~ = nil then
                            --#debug if storeItem.shopTranslationOffset[1] ~ = 0 or storeItem.shopTranslationOffset[3] ~ = 0 then
                                --#debug Logging.xmlDevWarning(xmlFile, "Shop translation offset on X and Z axis must be 0! Vehicle will automatically be center based on width and length offset.")
                                --#debug end
                                --#debug end

                                local sharedVramUsage, perInstanceVramUsage, ignoreVramUsage = StoreItemUtil.getVRamUsageFromXML(xmlFile, storeDataXMLKey)
                                for _, func in ipairs( self.vramUsageFunctions) do
                                    local customSharedVramUsage, customPerInstanceVramUsage = func(xmlFile)

                                    sharedVramUsage = sharedVramUsage + customSharedVramUsage
                                    perInstanceVramUsage = perInstanceVramUsage + customPerInstanceVramUsage
                                end

                                storeItem.sharedVramUsage, storeItem.perInstanceVramUsage, storeItem.ignoreVramUsage = sharedVramUsage, perInstanceVramUsage, ignoreVramUsage

                                storeItem.dlcTitle = dlcTitle
                                storeItem.isMod = isMod
                                storeItem.customEnvironment = customEnvironment

                                storeItem.categoryNames = { }
                                local categoryNames = xmlFile:getValue(storeDataXMLKey .. ".category" )
                                if categoryNames ~ = nil then
                                    for i = 1 , #categoryNames do
                                        local category = self:getCategoryByName(categoryNames[i])
                                        if category ~ = nil then
                                            table.insert(storeItem.categoryNames, category.name)
                                        else
                                                Logging.xmlWarning(xmlFile, "Invalid category '%s' in store data!" , tostring(categoryNames[i]))
                                            end
                                        end
                                    end

                                    -- ensure some category is always set
                                    if #storeItem.categoryNames = = 0 then
                                        if storeItem.showInStore then
                                            -- only show warning for actually displayed items
                                                Logging.xmlWarning(xmlFile, "No categories defined in store data! Using 'misc' instead!" )
                                            end
                                            table.insert(storeItem.categoryNames, "MISC" )
                                        end

                                        -- .categoryName still as reference to the 'root' shop category, so we are also backwards compatible
                                        storeItem.categoryName = storeItem.categoryNames[ 1 ]

                                        if species = = StoreSpecies.VEHICLE then
                                            --#profile RemoteProfiler.zoneBeginN("Load configurations")
                                            storeItem.configurations, storeItem.defaultConfigurationIds = ConfigurationUtil.getConfigurationsFromXML(g_vehicleConfigurationManager, xmlFile, baseXMLName, baseDir, customEnvironment, isMod, storeItem)
                                            storeItem.subConfigurations = ConfigurationUtil.getSubConfigurationsFromConfigurations(g_vehicleConfigurationManager, storeItem.configurations)
                                            storeItem.configurationSets = ConfigurationUtil.getConfigurationSetsFromXML(storeItem, xmlFile, baseXMLName, baseDir, customEnvironment, isMod)

                                            storeItem.hasLicensePlates = xmlFile:hasProperty( "vehicle.licensePlates.licensePlate(0)" )
                                            --#profile RemoteProfiler.zoneEnd()
                                        elseif species = = StoreSpecies.PLACEABLE then
                                                storeItem.configurations, storeItem.defaultConfigurationIds = ConfigurationUtil.getConfigurationsFromXML(g_placeableConfigurationManager, xmlFile, baseXMLName, baseDir, customEnvironment, isMod, storeItem)
                                            end

                                            storeItem.price = xmlFile:getValue(storeDataXMLKey .. ".price" , 0 )
                                            if storeItem.price < 0 then
                                                Logging.xmlWarning(xmlFile, "Price has to be greater than 0.Using default 10.000 instead!" )
                                                storeItem.price = 10000
                                            end
                                            storeItem.dailyUpkeep = xmlFile:getValue(storeDataXMLKey .. ".dailyUpkeep" , 0 )
                                            storeItem.runningLeasingFactor = xmlFile:getValue(storeDataXMLKey .. ".runningLeasingFactor" , EconomyManager.DEFAULT_RUNNING_LEASING_FACTOR)
                                            storeItem.lifetime = xmlFile:getValue(storeDataXMLKey .. ".lifetime" , 600 )
                                            if storeItem.lifetime < = 0 then
                                                Logging.xmlWarning(xmlFile, "Lifetime has to be greater than 0.Using default 600 instead!" )
                                                storeItem.lifetime = 600
                                            end

                                            xmlFile:iterate( "handTool.storeData.storePacks.storePack" , function (_, key)
                                                local packName = xmlFile:getValue(key)
                                                self:addPackItem(packName, xmlFilename)
                                            end )

                                            xmlFile:iterate( "vehicle.storeData.storePacks.storePack" , function (_, key)
                                                local packName = xmlFile:getValue(key)
                                                self:addPackItem(packName, xmlFilename)
                                            end )

                                            local bundleItemsToAdd = { }
                                            if xmlFile:hasProperty(storeDataXMLKey .. ".bundleElements" ) then
                                                local bundleInfo = { bundleItems = { } , attacherInfo = { } }
                                                local price = 0
                                                local lifetime = math.huge
                                                local dailyUpkeep = 0
                                                local runningLeasingFactor = 0

                                                for bundleIndex, bundleKey in xmlFile:iterator(storeDataXMLKey .. ".bundleElements.bundleElement" ) do
                                                    local bundleXmlFile = xmlFile:getValue(bundleKey .. ".xmlFilename" )
                                                    local offset = xmlFile:getValue(bundleKey .. ".offset" , "0 0 0" , true )
                                                    local rotationOffset = xmlFile:getValue(bundleKey .. ".rotationOffset" , "0 0 0" , true )
                                                    local rotation = xmlFile:getValue(bundleKey .. ".yRotation" , 0 )
                                                    rotationOffset[ 2 ] = rotationOffset[ 2 ] + rotation
                                                    if bundleXmlFile ~ = nil then
                                                        local completePath = Utils.getFilename(bundleXmlFile, baseDir)
                                                        local item = self:getItemByXMLFilename(completePath)
                                                        if item = = nil then
                                                            item = self:loadItem(bundleXmlFile, baseDir, customEnvironment, isMod, true , dlcTitle, nil , true )
                                                            table.insert(bundleItemsToAdd, item)
                                                        end
                                                        if item ~ = nil then
                                                            price = price + item.price
                                                            dailyUpkeep = dailyUpkeep + item.dailyUpkeep
                                                            runningLeasingFactor = runningLeasingFactor + item.runningLeasingFactor
                                                            lifetime = math.min(lifetime, item.lifetime)

                                                            if item.configurations ~ = nil then
                                                                storeItem.configurations = storeItem.configurations or { }

                                                                for configName, configOptions in pairs(item.configurations) do
                                                                    if storeItem.configurations[configName] ~ = nil then
                                                                        -- sum the prices of the configurations on multiple items
                                                                        local itemConfigOptions = storeItem.configurations[configName]
                                                                        for j = 1 , #configOptions do
                                                                            if itemConfigOptions[j] = = nil then
                                                                                itemConfigOptions[j] = configOptions[j]
                                                                            else
                                                                                    itemConfigOptions[j].price = itemConfigOptions[j].price + configOptions[j].price
                                                                                end
                                                                            end
                                                                        else
                                                                                storeItem.configurations[configName] = table.clone(configOptions, 5 )
                                                                            end
                                                                        end
                                                                    end

                                                                    if item.defaultConfigurationIds ~ = nil then
                                                                        storeItem.defaultConfigurationIds = storeItem.defaultConfigurationIds or { }
                                                                    end

                                                                    if item.subConfigurations ~ = nil then
                                                                        storeItem.subConfigurations = storeItem.subConfigurations or { }
                                                                        for configName, configOptions in pairs(item.subConfigurations) do
                                                                            storeItem.subConfigurations[configName] = configOptions
                                                                        end
                                                                    end

                                                                    if item.configurationSets ~ = nil then
                                                                        storeItem.configurationSets = storeItem.configurationSets or { }
                                                                        for configName, configOptions in pairs(item.configurationSets) do
                                                                            storeItem.configurationSets[configName] = configOptions
                                                                        end
                                                                    end

                                                                    local preSelectedConfigurations = { }
                                                                    xmlFile:iterate(bundleKey .. ".configurations.configuration" , function (_, configKey)
                                                                        local configName = xmlFile:getValue(configKey .. "#name" )
                                                                        local configValue = xmlFile:getValue(configKey .. "#value" )
                                                                        if configValue = = nil then
                                                                            local configSaveId = xmlFile:getValue(configKey .. "#saveId" )
                                                                            if item.configurations ~ = nil then
                                                                                local configs = item.configurations[configName]
                                                                                if configs ~ = nil then
                                                                                    for j = 1 , #configs do
                                                                                        if configs[j].saveId = = configSaveId then
                                                                                            configValue = configs[j].index
                                                                                            break
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if configName ~ = nil and configValue ~ = nil then
                                                                            local allowChange = xmlFile:getValue(configKey .. "#allowChange" , false )
                                                                            local hideOption = xmlFile:getValue(configKey .. "#hideOption" , false )
                                                                            local disableOption = xmlFile:getValue(configKey .. "#disableOption" , false )
                                                                            if not disableOption then
                                                                                preSelectedConfigurations[configName] = { configValue = configValue, allowChange = allowChange, hideOption = hideOption }
                                                                            else
                                                                                    local configElements = storeItem.configurations[configName]
                                                                                    if configElements ~ = nil then
                                                                                        for j = 1 , #configElements do
                                                                                            if j = = configValue then
                                                                                                configElements[j].isSelectable = not configElements[j].isSelectable
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end )

                                                                        storeItem.hasLicensePlates = storeItem.hasLicensePlates or item.hasLicensePlates

                                                                        table.insert(bundleInfo.bundleItems, { item = item, xmlFilename = item.xmlFilename, offset = offset, rotationOffset = rotationOffset, rotation = 0 , price = item.price, preSelectedConfigurations = preSelectedConfigurations } )
                                                                    end
                                                                end
                                                            end

                                                            for attachIndex, attachKey in xmlFile:iterator(storeDataXMLKey .. ".attacherInfo.attach" ) do
                                                                local bundleElement0 = xmlFile:getValue(attachKey .. "#bundleElement0" )
                                                                local bundleElement1 = xmlFile:getValue(attachKey .. "#bundleElement1" )
                                                                local attacherJointIndex = xmlFile:getValue(attachKey .. "#attacherJointIndex" )
                                                                local inputAttacherJointIndex = xmlFile:getValue(attachKey .. "#inputAttacherJointIndex" )
                                                                if bundleElement0 ~ = nil and bundleElement1 ~ = nil and attacherJointIndex ~ = nil and inputAttacherJointIndex ~ = nil then
                                                                    table.insert(bundleInfo.attacherInfo, { bundleElement0 = bundleElement0, bundleElement1 = bundleElement1, attacherJointIndex = attacherJointIndex, inputAttacherJointIndex = inputAttacherJointIndex } )
                                                                end
                                                            end

                                                            storeItem.price = price
                                                            storeItem.dailyUpkeep = dailyUpkeep
                                                            storeItem.runningLeasingFactor = runningLeasingFactor
                                                            storeItem.lifetime = lifetime
                                                            storeItem.bundleInfo = bundleInfo
                                                        end

                                                        -- Construction brush
                                                        if Platform.hasContruction then
                                                            if xmlFile:hasProperty(storeDataXMLKey .. ".brush" ) and storeItem.showInStore then
                                                                local brushType = xmlFile:getValue(storeDataXMLKey .. ".brush.type" )

                                                                if brushType ~ = nil and brushType ~ = "none" then
                                                                    if g_constructionBrushTypeManager:getClassObjectByTypeName(brushType) = = nil then
                                                                        Logging.xmlError(xmlFile, "Unknown brush type %q" , brushType)
                                                                        printf( "Available brush types: %s" , table.concat( table.toList(g_constructionBrushTypeManager:getBrushTypes()), ", " ))
                                                                    end

                                                                    local parameters = { }
                                                                    xmlFile:iterate(storeDataXMLKey .. ".brush.parameters.parameter" , function (index, key)
                                                                        local value = xmlFile:getValue(key)
                                                                        if xmlFile:getValue(key .. "#isFilename" , false ) then
                                                                            value = Utils.getFilename(value, baseDir)
                                                                        end

                                                                        parameters[index] = value
                                                                    end )

                                                                    local brushCategoryString = xmlFile:getValue(storeDataXMLKey .. ".brush.category" )
                                                                    if brushCategoryString ~ = nil then
                                                                        local brushCategory = self:getConstructionCategoryByName(brushCategoryString)
                                                                        if brushCategory ~ = nil then
                                                                            local tab = self:getConstructionTabByName(xmlFile:getValue(storeDataXMLKey .. ".brush.tab" ), brushCategory.name)
                                                                            if tab ~ = nil then
                                                                                storeItem.brush = {
                                                                                type = brushType,
                                                                                parameters = parameters,
                                                                                category = brushCategory,
                                                                                tab = tab,
                                                                                }
                                                                            else
                                                                                    Logging.xmlWarning(xmlFile, "Missing brush tab" )
                                                                                end
                                                                            else
                                                                                    Logging.xmlWarning(xmlFile, "Missing brush category: %s" , storeDataXMLKey .. ".brush.category" )
                                                                                end
                                                                            else
                                                                                    Logging.xmlWarning(xmlFile, "Unknown brush category '%s'" , brushCategoryString)
                                                                                end
                                                                            end

                                                                            -- Placeables without brush just get the default placeable brush
                                                                        elseif storeItem.species = = StoreSpecies.PLACEABLE and storeItem.showInStore then
                                                                                local constructionCategory = self.constructionCategories[ 1 ]
                                                                                if constructionCategory ~ = nil then
                                                                                    storeItem.brush = {
                                                                                    type = "placeable" ,
                                                                                    parameters = { } ,
                                                                                    category = constructionCategory,
                                                                                    tab = constructionCategory.tabs[ 1 ],
                                                                                    }
                                                                                else
                                                                                        Logging.xmlDevWarning(xmlFile, "Construction category not found for '%s'" , storeDataXMLKey)
                                                                                        end
                                                                                    end
                                                                                end

                                                                                if not ignoreAdd then
                                                                                    self:addItem(storeItem)

                                                                                    for i = 1 , #bundleItemsToAdd do
                                                                                        self:addItem(bundleItemsToAdd[i])
                                                                                    end
                                                                                end

                                                                                xmlFile:delete()

                                                                                return storeItem
                                                                            end

```

### loadItemsFromXML

**Description**

**Definition**

> loadItemsFromXML()

**Arguments**

| any | filename          |
|-----|-------------------|
| any | baseDirectory     |
| any | customEnvironment |

**Code**

```lua
function StoreManager:loadItemsFromXML(filename, baseDirectory, customEnvironment)
    local xmlFile = XMLFile.load( "storeItemsXML" , filename)

    if xmlFile = = nil then
        return
    end

    xmlFile:iterate( "storeItems.storeItem" , function (_, key)
        local xmlFilename = xmlFile:getString(key .. "#xmlFilename" )
        local extraContentId = xmlFile:getString(key .. "#extraContentId" )
        g_asyncTaskManager:addSubtask( function ()
            local isMod = false
            local dlcTitle = ""

            local absFilename = Utils.getFilename(xmlFilename, baseDirectory)
            local modName, _ = Utils.getModNameAndBaseDirectory(absFilename)
            if modName ~ = nil then
                local modItem = g_modManager:getModByName(modName)
                if modItem ~ = nil then
                    dlcTitle = modItem.title
                end
                isMod = not modItem.isDLC
            end

            --#profile RemoteProfiler.zoneBeginN("StoreManager:loadItem_" .. xmlFilename)
            self:loadItem(xmlFilename, baseDirectory, customEnvironment, isMod, false , dlcTitle, extraContentId)
            --#profile RemoteProfiler.zoneEnd()
        end , string.format( "StoreManager-loadItemsFromXML '%s'" , xmlFilename))
    end )

    xmlFile:delete()
end

```

### loadMapData

**Description**

> Load manager data on map load

**Definition**

> loadMapData()

**Arguments**

| any | xmlFile       |
|-----|---------------|
| any | missionInfo   |
| any | baseDirectory |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function StoreManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    StoreManager:superClass().loadMapData( self )

    -- local all store categories
    local categoryXMLFile = XMLFile.load( "storeCategoriesXML" , "dataS/storeCategories.xml" )

    for _, key in categoryXMLFile:iterator( "categories.types.type" ) do
        self:loadCategoryType(categoryXMLFile, key, nil )
    end

    for _, key in categoryXMLFile:iterator( "categories.category" ) do
        self:loadCategoryFromXML(categoryXMLFile, key, "" , false )
    end

    categoryXMLFile:delete()

    for _, categoryData in ipairs( self.modCategoryTypes) do
        self:addCategory(categoryData.name, categoryData.title, categoryData.imageFilename, categoryData.categoryType, categoryData.baseDir, categoryData.insertAfter)
    end

    -- load store pack definitions
    local packsXMLFile = XMLFile.load( "storePacksXML" , "dataS/storePacks.xml" )
    for _, key in packsXMLFile:iterator( "storePacks.storePack" ) do
        local name = packsXMLFile:getString(key .. "#name" )
        local title = packsXMLFile:getString(key .. "#title" )
        local imageFilename = packsXMLFile:getString(key .. "#image" )

        if title ~ = nil and title:sub( 1 , 6 ) = = "$l10n_" then
            title = g_i18n:getText(title:sub( 7 ))
        end

        self:addPack(name, title, imageFilename, "" )

        packsXMLFile:iterate(key .. ".storeItem" , function (_, storeItemKey)
            local xmlFilename = packsXMLFile:getString(storeItemKey)
            self:addPackItem(name, Utils.getFilename(xmlFilename, baseDirectory))
        end )
    end
    packsXMLFile:delete()

    -- also for mods
        for _, item in ipairs( self.modStorePacks) do
            self:addPack(item.name, item.title, item.imageFilename, item.baseDir)
            for _, storeItem in ipairs(item.storeItems) do
                self:addPackItem(item.name, storeItem)
            end
        end

        -- Load categories for the construction system
            if Platform.hasContruction then
                local constructionXMLFile = XMLFile.load( "constructionXML" , "dataS/constructionCategories.xml" )
                if constructionXMLFile ~ = nil then
                    local defaultIconFilename = constructionXMLFile:getString( "constructionCategories#defaultIconFilename" )
                    local defaultRefSize = constructionXMLFile:getVector( "constructionCategories#refSize" , nil , 2 ) or { 1024 , 1024 }

                    for _, key in constructionXMLFile:iterator( "constructionCategories.category" ) do
                        local categoryName = constructionXMLFile:getString(key .. "#name" )
                        local title = g_i18n:convertText(constructionXMLFile:getString(key .. "#title" ))
                        local iconFilename = constructionXMLFile:getString(key .. "#iconFilename" ) or defaultIconFilename
                        local refSize = constructionXMLFile:getVector(key .. "#refSize" , defaultRefSize, 2 )
                        local iconUVs = GuiUtils.getUVs(constructionXMLFile:getString(key .. "#iconUVs" , "0 0 1 1" ), refSize)
                        local iconSliceId = constructionXMLFile:getString(key .. "#iconSliceId" )

                        self:addConstructionCategory(categoryName, title, iconFilename, iconUVs, "" , iconSliceId)

                        for _, tKey in constructionXMLFile:iterator(key .. ".tab" ) do
                            local tabName = constructionXMLFile:getString(tKey .. "#name" )
                            local tabTitle = g_i18n:convertText(constructionXMLFile:getString(tKey .. "#title" ))
                            local tabIconFilename = constructionXMLFile:getString(tKey .. "#iconFilename" ) or defaultIconFilename
                            local tabRefSize = constructionXMLFile:getVector(tKey .. "#refSize" , defaultRefSize, 2 )
                            local tabIconUVs = GuiUtils.getUVs(constructionXMLFile:getString(tKey .. "#iconUVs" , "0 0 1 1" ), tabRefSize)
                            local tabIconSliceId = constructionXMLFile:getString(tKey .. "#iconSliceId" )

                            self:addConstructionTab(categoryName, tabName, tabTitle, tabIconFilename, tabIconUVs, "" , tabIconSliceId)
                        end
                    end

                    constructionXMLFile:delete()
                end

                for _, item in ipairs( self.modConstructionTabs) do
                    self:addConstructionTab(item.categoryName, item.tabName, item.tabTitle, item.tabIconFilename, item.tabIconUVs, "" , item.tabIconSliceId)
                end
            end

            -- now load all storeitems

            local storeItemsFilename = self:getDefaultStoreItemsFilename()
            self:loadItemsFromXML(storeItemsFilename, "" , nil )

            if xmlFile ~ = nil then
                local mapStoreItemsFilename = getXMLString(xmlFile, "map.storeItems#filename" )
                if mapStoreItemsFilename ~ = nil then
                    mapStoreItemsFilename = Utils.getFilename(mapStoreItemsFilename, baseDirectory)
                    self:loadItemsFromXML(mapStoreItemsFilename, baseDirectory, missionInfo.customEnvironment)
                end
            end

            for _, item in ipairs( self.modStoreItems) do
                g_asyncTaskManager:addSubtask( function ()
                    self:loadItem(item.xmlFilename, item.baseDir, item.customEnvironment, item.isMod, item.isBundleItem, item.dlcTitle, item.extraContentId)
                end )
            end

            g_asyncTaskManager:addSubtask( function ()
                self.indexedSearch:build()
            end )

            addConsoleCommand( "gsStoreItemsReload" , "Reloads storeItem data" , "consoleCommandReloadStoreItems" , self )

            return true
        end

```

### new

**Description**

> Creating manager

**Definition**

> new()

**Arguments**

| any | customMt |
|-----|----------|

**Return Values**

| any | instance | instance of object |
|-----|----------|--------------------|

**Code**

```lua
function StoreManager.new(customMt)
    local self = AbstractManager.new(customMt or StoreManager _mt)

    self.speciesToSchema = { }

    self.indexedSearch = IndexedSearch.new( { title = 10 , brand = 5 , author = 3 , dlcTitle = 3 } )

    return self
end

```

### registerStoreDataXMLPaths

**Description**

**Definition**

> registerStoreDataXMLPaths(XMLSchema schema, string basePath)

**Arguments**

| XMLSchema | schema   |
|-----------|----------|
| string    | basePath |

**Code**

```lua
function StoreManager.registerStoreDataXMLPaths(schema, basePath)
    schema:register(XMLValueType.L10N_STRING, basePath .. ".storeData.name" , "Name of store item" , nil , true )
    schema:register(XMLValueType.STRING, basePath .. ".storeData.name#params" , "Parameters to add to name" )

    local speciesDefaultValue = StoreSpecies.getName(StoreSpecies.VEHICLE)
    local speciesDefaultValues = StoreSpecies.getAllOrderedByName()
    schema:register(XMLValueType.STRING, basePath .. ".storeData.species" , "Store species" , speciesDefaultValue, false , speciesDefaultValues)
    schema:register(XMLValueType.STRING, basePath .. ".storeData.image" , "Path to store icon" , nil , true )
    schema:register(XMLValueType.STRING, basePath .. ".storeData.brand" , "Brand identifier" , "LIZARD" )
    schema:registerAutoCompletionDataSource(basePath .. ".storeData.brand" , "$dataS/brands.xml" , "brands.brand#name" )
    schema:register(XMLValueType.STRING, basePath .. ".storeData.brand#customIcon" , "Custom brand icon to display in the shop config screen" )
    schema:register(XMLValueType.STRING, basePath .. ".storeData.brand#imageOffset" , "Offset of custom brand icon" )

    schema:register(XMLValueType.BOOL, basePath .. ".storeData.canBeSold" , "Defines of the vehicle can be sold" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".storeData.showInStore" , "Defines of the vehicle is shown in shop" , true )
    schema:register(XMLValueType.BOOL, basePath .. ".storeData.allowLeasing" , "Defines of the vehicle can be leased" , true )
    schema:register(XMLValueType.INT, basePath .. ".storeData.maxItemCount" , "Defines the max.amount vehicle of this type" )
    schema:register(XMLValueType.ANGLE, basePath .. ".storeData.rotation" , "Y rotation of the vehicle" , 0 )

    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".storeData.spawnRotationOffset" , "Y rotation of the vehicle when spawned at the shop loading places" )
    schema:register(XMLValueType.VECTOR_ 3 , basePath .. ".storeData.spawnSizeOffset" , "Additional size that is reserved for the tool when spawned at the shop loading places(width, height, length)" )

        schema:register(XMLValueType.STRING_LIST, basePath .. ".storeData.category" , "Store category name or names(space separated)" , "misc" )
        schema:registerAutoCompletionDataSource(basePath .. ".storeData.category" , "$dataS/storeCategories.xml" , "categories.category#name" )
        schema:register(XMLValueType.STRING, basePath .. ".storeData.storePacks.storePack(?)" , "Store pack" )
        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.price" , "Store price" , 10000 )
        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.dailyUpkeep" , "Daily up keep" , 0 )
        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.runningLeasingFactor" , "Running leasing factor" , EconomyManager.DEFAULT_RUNNING_LEASING_FACTOR)
        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.lifetime" , "Lifetime of vehicle used to calculate price drop, in months" , 600 )

        schema:register(XMLValueType.BOOL, basePath .. ".storeData.shopDynamicTitle" , "Vehicle brand icon and vehicle name is dynamically updated based on the selected configuration in the shop" , false )
        schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".storeData.shopTranslationOffset" , "Translation offset for shop spawning and store icon" , "0 0 0" )
            schema:register(XMLValueType.VECTOR_ROT, basePath .. ".storeData.shopRotationOffset" , "Rotation offset for shop spawning and store icon" , "0 0 0" )
                schema:register(XMLValueType.BOOL, basePath .. ".storeData.shopIgnoreLastComponentPositions" , "If set to true the component positions from last spawning are now reused" , false )
                schema:register(XMLValueType.TIME, basePath .. ".storeData.shopLoadingDelay#initial" , "Delay of initial shop loading until the vehicle is displayed. (Used e.g.to hide vehicle while components still moving)" )
                    schema:register(XMLValueType.TIME, basePath .. ".storeData.shopLoadingDelay#config" , "Delay of shop loading after config change until the vehicle is displayed. (Used e.g.to hide vehicle while components still moving)" )

                        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.shopHeight" , "Height of vehicle for shop placement" , 0 )
                            schema:register(XMLValueType.STRING, basePath .. ".storeData.financeCategory" , "Finance category name" )
                            schema:register(XMLValueType.INT, basePath .. ".storeData.shopFoldingState" , "Inverts the shop folding state if set to '1'" , 0 )
                                schema:register(XMLValueType.FLOAT, basePath .. ".storeData.shopFoldingTime" , "Defines a custom folding time for the shop" )

                                    schema:register(XMLValueType.INT, basePath .. ".storeData.vertexBufferMemoryUsage" , "Vertex buffer memory usage" , 0 )
                                    schema:register(XMLValueType.INT, basePath .. ".storeData.indexBufferMemoryUsage" , "Index buffer memory usage" , 0 )
                                    schema:register(XMLValueType.INT, basePath .. ".storeData.textureMemoryUsage" , "Texture memory usage" , 0 )
                                    schema:register(XMLValueType.INT, basePath .. ".storeData.instanceVertexBufferMemoryUsage" , "Instance vertex buffer memory usage" , 0 )
                                    schema:register(XMLValueType.INT, basePath .. ".storeData.instanceIndexBufferMemoryUsage" , "Instance index buffer memory usage" , 0 )
                                    schema:register(XMLValueType.BOOL, basePath .. ".storeData.ignoreVramUsage" , "Ignore VRAM usage" , false )
                                    schema:register(XMLValueType.INT, basePath .. ".storeData.audioMemoryUsage" , "Audio memory usage" , 0 )

                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.bundleElements.bundleElement(?).xmlFilename" , "XML filename" )
                                    schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".storeData.bundleElements.bundleElement(?).offset" , "Translation offset of vehicle" )
                                    schema:register(XMLValueType.VECTOR_ROT, basePath .. ".storeData.bundleElements.bundleElement(?).rotationOffset" , "Rotation offset of vehicle" )
                                    schema:register(XMLValueType.ANGLE, basePath .. ".storeData.bundleElements.bundleElement(?).yRotation" , "Y rotation of vehicle" )

                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.bundleElements.bundleElement(?).configurations.configuration(?)#name" , "Name of configuration" )
                                    schema:register(XMLValueType.INT, basePath .. ".storeData.bundleElements.bundleElement(?).configurations.configuration(?)#value" , "Configuration index that is forced for this config" )
                                        schema:register(XMLValueType.STRING, basePath .. ".storeData.bundleElements.bundleElement(?).configurations.configuration(?)#saveId" , "Configuration save id that is forced for this config" )
                                            schema:register(XMLValueType.BOOL, basePath .. ".storeData.bundleElements.bundleElement(?).configurations.configuration(?)#allowChange" , "Allow change of option" , false )
                                            schema:register(XMLValueType.BOOL, basePath .. ".storeData.bundleElements.bundleElement(?).configurations.configuration(?)#hideOption" , "Hide the option completely" , false )
                                            schema:register(XMLValueType.BOOL, basePath .. ".storeData.bundleElements.bundleElement(?).configurations.configuration(?)#disableOption" , "Disabled this particular config option" , false )

                                            schema:register(XMLValueType.INT, basePath .. ".storeData.attacherInfo.attach(?)#bundleElement0" , "First bundle element" )
                                            schema:register(XMLValueType.INT, basePath .. ".storeData.attacherInfo.attach(?)#bundleElement1" , "Second bundle element" )
                                            schema:register(XMLValueType.INT, basePath .. ".storeData.attacherInfo.attach(?)#attacherJointIndex" , "Attacher joint index" )
                                            schema:register(XMLValueType.INT, basePath .. ".storeData.attacherInfo.attach(?)#inputAttacherJointIndex" , "Input attacher joint index" )

                                            schema:register(XMLValueType.L10N_STRING, basePath .. ".storeData.functions.function (?)" , "Function description text" )
                                                schema:registerAutoCompletionDataSource(basePath .. ".storeData.functions.function (?)" , "dataS/l10n/l10n_en.xml" , "l10n.elements.e#k" , "$l10n_" )

                                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.brush.type" , "Brush type" )
                                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.brush.category" , "Brush category" )
                                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.brush.tab" , "Brush tab" )
                                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.brush.parameters.parameter(?)" , "Brush parameter value" )
                                                    schema:register(XMLValueType.STRING, basePath .. ".storeData.brush.parameters.parameter(?)#isFilename" , "Whether the parameter is a filename" )

                                                    -- Store Icon Generator - Not used in the game
                                                    schema:register(XMLValueType.ANGLE, basePath .. ".storeData.storeIconRendering.settings#cameraYRot" , "Y Rot of camera" , "Setting from Icon Generator" )
                                                    schema:register(XMLValueType.ANGLE, basePath .. ".storeData.storeIconRendering.settings#cameraXRot" , "X Rot of camera" , "Setting from Icon Generator" )
                                                    schema:register(XMLValueType.BOOL, basePath .. ".storeData.storeIconRendering.settings#advancedBoundingBox" , "Advanced BB is used for icon placement" , "Setting from Icon Generator" )
                                                        schema:register(XMLValueType.BOOL, basePath .. ".storeData.storeIconRendering.settings#centerIcon" , "Center item on icon" , "Setting from Icon Generator" )
                                                        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.storeIconRendering.settings#zoomFactor" , "Camera zoom factor" )
                                                        schema:register(XMLValueType.FLOAT, basePath .. ".storeData.storeIconRendering.settings#lightIntensity" , "Intensity of light sources" , "Setting from Icon Generator" )
                                                        schema:register(XMLValueType.BOOL, basePath .. ".storeData.storeIconRendering.settings#showTriggerMarkers" , "Show trigger markers on icon(for placeables)" , false )

                                                            schema:register(XMLValueType.BOOL, basePath .. ".storeData.storeIconRendering.objectBundle#useClipPlane" , "Clip plane is used" )
                                                            schema:register(XMLValueType.STRING, basePath .. ".storeData.storeIconRendering.objectBundle.object(?)#filename" , "Path to i3d file" )
                                                            schema:register(XMLValueType.NODE_INDEX, basePath .. ".storeData.storeIconRendering.objectBundle.object(?).node(?)#node" , "Index Path of node to load" )
                                                            schema:register(XMLValueType.VECTOR_TRANS, basePath .. ".storeData.storeIconRendering.objectBundle.object(?).node(?)#translation" , "Translation" , "0 0 0" )
                                                            schema:register(XMLValueType.VECTOR_ROT, basePath .. ".storeData.storeIconRendering.objectBundle.object(?).node(?)#rotation" , "Rotation" , "0 0 0" )
                                                            schema:register(XMLValueType.VECTOR_SCALE, basePath .. ".storeData.storeIconRendering.objectBundle.object(?).node(?)#scale" , "Scale" , "1 1 1" )

                                                            schema:register(XMLValueType.STRING, basePath .. ".storeData.storeIconRendering.shaderParameter(?)#name" , "Name if shader parameter" )
                                                                schema:register(XMLValueType.STRING, basePath .. ".storeData.storeIconRendering.shaderParameter(?)#values" , "Values of shader parameter" )
                                                            end

```

### removeItemByIndex

**Description**

> Removes a storeitem by index

**Definition**

> removeItemByIndex(integer index)

**Arguments**

| integer | index | storeitem index |
|---------|-------|-----------------|

**Code**

```lua
function StoreManager:removeItemByIndex(index)
    local item = self.items[index]
    if item ~ = nil then
        self.xmlFilenameToItem[item.xmlFilenameLower] = nil

        -- item.id must always match the index in the arry, thus swap the last to the removed position and reduce size
        local numItems = # self.items
        if index < numItems then
            self.items[index] = self.items[numItems]
            self.items[index].id = index
        end
        table.remove( self.items, numItems)
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
function StoreManager:unloadMapData()
    StoreManager:superClass().unloadMapData( self )

    removeConsoleCommand( "gsStoreItemsReload" )
end

```