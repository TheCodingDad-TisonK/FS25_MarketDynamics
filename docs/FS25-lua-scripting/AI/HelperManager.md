## HelperManager

**Description**

> This class handles all helpers

**Parent**

> [AbstractManager](?version=script&category=4&class=154)

**Functions**

- [addHelper](#addhelper)
- [getHelperByIndex](#gethelperbyindex)
- [getHelperByName](#gethelperbyname)
- [getNumOfHelpers](#getnumofhelpers)
- [getRandomHelper](#getrandomhelper)
- [getRandomHelperStyle](#getrandomhelperstyle)
- [getRandomIndex](#getrandomindex)
- [initDataStructures](#initdatastructures)
- [loadDefaultTypes](#loaddefaulttypes)
- [loadHelpers](#loadhelpers)
- [loadMapData](#loadmapdata)
- [new](#new)
- [releaseHelper](#releasehelper)
- [useHelper](#usehelper)

### addHelper

**Description**

> Adds a new helper

**Definition**

> addHelper(string name, string modelFilename, string baseDir, , , )

**Arguments**

| string | name          | helper index name     |
|--------|---------------|-----------------------|
| string | modelFilename | helper model filename |
| string | baseDir       | the base directory    |
| any    | playerStyle   |                       |
| any    | baseDir       |                       |
| any    | isBaseType    |                       |

**Return Values**

| any | true | if added successful else false |
|-----|------|--------------------------------|

**Code**

```lua
function HelperManager:addHelper(name, title, color, playerStyle, baseDir, isBaseType)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a helper.Ignoring helper!" )
            return nil
        end

        name = string.upper(name)

        if isBaseType and self.nameToIndex[name] ~ = nil then
            printWarning( "Warning:Helper '" .. tostring(name) .. "' already exists.Ignoring helper!" )
            return nil
        end

        local helper = self.helpers[name]
        if helper = = nil then
            self.numHelpers = self.numHelpers + 1

            helper = { }
            helper.name = name
            helper.index = self.numHelpers
            helper.color = color
            helper.title = name
            if title ~ = nil then
                helper.title = title
            end
            helper.playerStyle = playerStyle

            self.helpers[name] = helper
            self.nameToIndex[name] = self.numHelpers
            self.indexToHelper[ self.numHelpers] = helper
            table.insert( self.availableHelpers, helper)
        else
                if title ~ = nil then
                    helper.title = g_i18n:convertText(title)
                end
                if playerStyle ~ = nil then
                    helper.playerStyle = playerStyle
                end
            end

            return helper
        end

```

### getHelperByIndex

**Description**

> Gets a helper by index

**Definition**

> getHelperByIndex(integer index)

**Arguments**

| integer | index | the helper index |
|---------|-------|------------------|

**Return Values**

| integer | helper | the helper object |
|---------|--------|-------------------|

**Code**

```lua
function HelperManager:getHelperByIndex(index)
    if index ~ = nil then
        return self.indexToHelper[index]
    end
    return nil
end

```

### getHelperByName

**Description**

> Gets a helper by index name

**Definition**

> getHelperByName(string name)

**Arguments**

| string | name | the helper index name |
|--------|------|-----------------------|

**Return Values**

| string | helper | the helper object |
|--------|--------|-------------------|

**Code**

```lua
function HelperManager:getHelperByName(name)
    if name ~ = nil then
        name = string.upper(name)
        return self.helpers[name]
    end
    return nil
end

```

### getNumOfHelpers

**Description**

> Gets number of helpers

**Definition**

> getNumOfHelpers()

**Return Values**

| string | numOfHelpers | total number of helpers |
|--------|--------------|-------------------------|

**Code**

```lua
function HelperManager:getNumOfHelpers()
    return self.numHelpers
end

```

### getRandomHelper

**Description**

> Gets a random helper

**Definition**

> getRandomHelper()

**Return Values**

| string | helper | a random helper object |
|--------|--------|------------------------|

**Code**

```lua
function HelperManager:getRandomHelper()
    return self.availableHelpers[ math.random( 1 , # self.availableHelpers)]
end

```

### getRandomHelperStyle

**Description**

> Gets a random helper

**Definition**

> getRandomHelperStyle()

**Return Values**

| string | helper | a random helper style |
|--------|--------|-----------------------|

**Code**

```lua
function HelperManager:getRandomHelperStyle()
    return self.indexToHelper[ math.random( 1 , self.numHelpers)].playerStyle
end

```

### getRandomIndex

**Description**

> Gets a random helper index

**Definition**

> getRandomIndex()

**Return Values**

| string | helperIndex | a random helper index |
|--------|-------------|-----------------------|

**Code**

```lua
function HelperManager:getRandomIndex()
    return math.random( 1 , self.numHelpers)
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function HelperManager:initDataStructures()
    self.numHelpers = 0
    self.helpers = { }
    self.nameToIndex = { }
    self.indexToHelper = { }
    self.availableHelpers = { }
end

```

### loadDefaultTypes

**Description**

**Definition**

> loadDefaultTypes()

**Arguments**

| any | missionInfo   |
|-----|---------------|
| any | baseDirectory |

**Code**

```lua
function HelperManager:loadDefaultTypes(missionInfo, baseDirectory)
    local xmlFile = loadXMLFile( "helpers" , "data/maps/maps_helpers.xml" )
    self:loadHelpers(xmlFile, missionInfo, baseDirectory, true , nil )
    delete(xmlFile)
end

```

### loadHelpers

**Description**

> Load data on map load

**Definition**

> loadHelpers()

**Arguments**

| any | xmlFileHandle     |
|-----|-------------------|
| any | missionInfo       |
| any | baseDirectory     |
| any | isBaseType        |
| any | customEnvironment |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function HelperManager:loadHelpers(xmlFileHandle, missionInfo, baseDirectory, isBaseType, customEnvironment)
    local xmlFile = XMLFile.wrap(xmlFileHandle, HelperManager.xmlSchema)
    if xmlFile = = nil then
        return false
    end

    for _, key in xmlFile:iterator( "map.helpers.helper" ) do
        local name = xmlFile:getValue(key .. "#name" )
        local title = xmlFile:getValue(key .. "#title" , nil , customEnvironment, false )
        local color = xmlFile:getValue(key .. "#color" , { 1 , 1 , 1 } )
        local playerStyle = PlayerStyle.new()
        playerStyle:loadFromXMLFile(xmlFile, key .. ".playerStyle" )

        self:addHelper(name, title, color, playerStyle, baseDirectory, isBaseType)
    end

    xmlFile:delete()

    return true
end

```

### loadMapData

**Description**

> Load data on map load

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
function HelperManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    HelperManager:superClass().loadMapData( self )

    self:loadDefaultTypes()
    return XMLUtil.loadDataFromMapXML(xmlFile, "helpers" , baseDirectory, self , self.loadHelpers, missionInfo, baseDirectory, false , missionInfo.customEnvironment)
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
function HelperManager.new(customMt)
    local self = AbstractManager.new(customMt or HelperManager _mt)
    return self
end

```

### releaseHelper

**Description**

> Marks a helper as 'not in use'

**Definition**

> releaseHelper(table helper)

**Arguments**

| table | helper | the helper object |
|-------|--------|-------------------|

**Code**

```lua
function HelperManager:releaseHelper(helper)
    table.insert( self.availableHelpers, helper)
end

```

### useHelper

**Description**

> Marks a helper as 'in use'

**Definition**

> useHelper(table helper)

**Arguments**

| table | helper | the helper object |
|-------|--------|-------------------|

**Return Values**

| table | success | true if helper is marked else false |
|-------|---------|-------------------------------------|

**Code**

```lua
function HelperManager:useHelper(helper)
    for k, h in pairs( self.availableHelpers) do
        if h = = helper then
            table.remove( self.availableHelpers, k)
            return true
        end
    end
    return false
end

```