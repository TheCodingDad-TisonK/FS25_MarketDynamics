## BrandManager

**Description**

> This class handles all registered brands

**Parent**

> [AbstractManager](?version=script&category=75&class=611)

**Functions**

- [addBrand](#addbrand)
- [getBrandByIndex](#getbrandbyindex)
- [getBrandByName](#getbrandbyname)
- [getBrandIconByIndex](#getbrandiconbyindex)
- [getBrandIndexByName](#getbrandindexbyname)
- [initDataStructures](#initdatastructures)
- [loadMapData](#loadmapdata)
- [new](#new)

### addBrand

**Description**

> Adds a new band

**Definition**

> addBrand(string name, string title, string imageFilename, string baseDir, boolean isMod, string? imageShopOverview,
> float? imageOffset)

**Arguments**

| string  | name              | the mapping name .e.g "HORSCH" for accessing a brand using the Brand.HORSCH enumeration        |
|---------|-------------------|------------------------------------------------------------------------------------------------|
| string  | title             | the displayed name of the brand in ui                                                          |
| string  | imageFilename     | the brand icon                                                                                 |
| string  | baseDir           | the image filename base directory                                                              |
| boolean | isMod             | is a mod brand                                                                                 |
| string? | imageShopOverview | the brand icon for shop overview                                                               |
| float?  | imageOffset       | percentage [0..1] of the transparent pixels on the side of the icon used for aligning it in UI |

**Return Values**

| float? | brand |
|--------|-------|

**Code**

```lua
function BrandManager:addBrand(name, title, imageFilename, baseDir, isMod, imageShopOverview, imageOffset)
    if name = = nil or name = = "" then
        Logging.warning( "Could not register brand.Name is missing or empty!" )
        return false
    end
    if title = = nil or title = = "" then
        Logging.warning( "Could not register brand '%s'.Title is missing or empty!" , name)
        return false
    end
    if imageFilename = = nil or imageFilename = = "" then
        Logging.warning( "Could not register brand '%s'.Image is missing or empty!" , name)
        return false
        --#debug else
            --#debug local fullFilename = Utils.getFilename(imageFilename, baseDir)
            --#debug if not textureFileExists(fullFilename) then
                --#debug Logging.devWarning("Defined image file for brand '%s' not found! (%s)", name, fullFilename)
                    --#debug end
                end
                if baseDir = = nil then
                    Logging.warning( "Could not register brand '%s'.Base directory not defined!" , name)
                    return false
                end
                if imageShopOverview = = nil then
                    -- use default image if no specific shop overview icon is available
                        imageShopOverview = imageFilename
                        --#debug else
                            --#debug local fullFilename = Utils.getFilename(imageShopOverview, baseDir)
                            --#debug if not textureFileExists(fullFilename) then
                                --#debug Logging.devWarning("Defined shop overview image file for brand '%s' not found! (%s)", name, fullFilename)
                                    --#debug end
                                end

                                name = string.upper(name)

                                if ClassUtil.getIsValidIndexName(name) then
                                    if self.nameToIndex[name] = = nil then
                                        self.numOfBrands = self.numOfBrands + 1
                                        self.nameToIndex[name] = self.numOfBrands

                                        local brand = { }
                                        brand.index = self.numOfBrands
                                        brand.name = name
                                        brand.image = Utils.getFilename(imageFilename, baseDir)
                                        brand.imageShopOverview = Utils.getFilename(imageShopOverview, baseDir)
                                        brand.title = title
                                        brand.isMod = isMod
                                        brand.imageOffset = imageOffset or 0

                                        self.nameToBrand[name] = brand
                                        self.indexToBrand[ self.numOfBrands] = brand

                                        return brand
                                    end

                                    return nil -- brand already present
                                else
                                        Logging.warning( "Invalid brand name '" .. tostring(name) .. "'! Only capital letters allowed!" )
                                        return nil
                                    end
                                end

```

### getBrandByIndex

**Description**

> Gets brand by index

**Definition**

> getBrandByIndex(integer brandIndex)

**Arguments**

| integer | brandIndex | brand index |
|---------|------------|-------------|

**Return Values**

| integer | brand | the brand object |
|---------|-------|------------------|

**Code**

```lua
function BrandManager:getBrandByIndex(brandIndex)
    if brandIndex ~ = nil then
        return self.indexToBrand[brandIndex]
    end
    return nil
end

```

### getBrandByName

**Description**

> Gets brand by name

**Definition**

> getBrandByName(string brandName)

**Arguments**

| string | brandName | brand name |
|--------|-----------|------------|

**Return Values**

| string | brand | the brand object |
|--------|-------|------------------|

**Code**

```lua
function BrandManager:getBrandByName(brandName)
    if brandName ~ = nil then
        return self.nameToBrand[ string.upper(brandName)]
    end
    return nil
end

```

### getBrandIconByIndex

**Description**

> Gets brand icon by index

**Definition**

> getBrandIconByIndex(integer brandIndex)

**Arguments**

| integer | brandIndex | brand index |
|---------|------------|-------------|

**Return Values**

| integer | path | path to brand icon |
|---------|------|--------------------|

**Code**

```lua
function BrandManager:getBrandIconByIndex(brandIndex)
    if brandIndex ~ = nil and self.indexToBrand[brandIndex] ~ = nil then
        return self.indexToBrand[brandIndex].image
    end
    return nil
end

```

### getBrandIndexByName

**Description**

> Gets brand index by name

**Definition**

> getBrandIndexByName(string brandName)

**Arguments**

| string | brandName | brand name |
|--------|-----------|------------|

**Return Values**

| string | brandIndex | the brand index |
|--------|------------|-----------------|

**Code**

```lua
function BrandManager:getBrandIndexByName(brandName)
    if brandName ~ = nil then
        if ClassUtil.getIsValidIndexName(brandName) then
            local brandIndex = self.nameToIndex[ string.upper(brandName)]
            if brandIndex = = nil then
                local bestMatch = Utils.getClosestMatchingString(brandName, table.toList( self.nameToBrand), 3 )
                local suggestions = bestMatch and string.format( " Did you mean '%s'?" , bestMatch) or ""
                Logging.warning( "'%s' is an unknown brand!%s Using 'LIZARD' instead!" , brandName, suggestions)
                return Brand.LIZARD
            end

            return brandIndex
        else
                Logging.warning( "Invalid brand name '" .. brandName .. "'! Only capital letters and underscores allowed.Using Lizard instead." )
                return Brand.LIZARD
            end
        end

        return nil
    end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function BrandManager:initDataStructures()
    self.numOfBrands = 0
    self.nameToIndex = { }
    self.nameToBrand = { }
    self.indexToBrand = { }

    Brand = self.nameToIndex
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Arguments**

| any | missionInfo |
|-----|-------------|

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function BrandManager:loadMapData(missionInfo)
    BrandManager:superClass().loadMapData( self )

    local xmlFile = XMLFile.load( "brandsXML" , "dataS/brands.xml" )

    for _, brandKey in xmlFile:iterator( "brands.brand" ) do
        local name = xmlFile:getString(brandKey .. "#name" )
        local title = xmlFile:getString(brandKey .. "#title" )
        local image = xmlFile:getString(brandKey .. "#image" )
        local imageShopOverview = xmlFile:getString(brandKey .. "#imageShopOverview" )
        local imageOffset = xmlFile:getFloat(brandKey .. "#imageOffset" )

        if title ~ = nil and string.startsWith(title, "$l10n_" ) then
            title = g_i18n:getText(title:sub( 7 ))
        end

        self:addBrand(name, title, image, "" , false , imageShopOverview, imageOffset)
    end

    xmlFile:delete()

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
function BrandManager.new(customMt)
    local self = AbstractManager.new(customMt or BrandManager _mt)

    addConsoleCommand( "gsBrandUsageList" , "Prints a list of all used brands" , "consoleCommandBrandUsageList" , self )

    return self
end

```