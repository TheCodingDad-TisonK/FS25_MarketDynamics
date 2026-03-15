## SprayTypeManager

**Description**

> This class handles all sprayTypes

**Parent**

> [AbstractManager](?version=script&category=58&class=562)

**Functions**

- [addSprayType](#addspraytype)
- [getFillTypeByName](#getfilltypebyname)
- [getFillTypeIndexByName](#getfilltypeindexbyname)
- [getFillTypeNameByIndex](#getfilltypenamebyindex)
- [getSprayTypeByFillTypeIndex](#getspraytypebyfilltypeindex)
- [getSprayTypeByIndex](#getspraytypebyindex)
- [getSprayTypeByName](#getspraytypebyname)
- [getSprayTypeIndexByFillTypeIndex](#getspraytypeindexbyfilltypeindex)
- [getSprayTypes](#getspraytypes)
- [initDataStructures](#initdatastructures)
- [loadDefaultTypes](#loaddefaulttypes)
- [loadMapData](#loadmapdata)
- [loadSprayTypes](#loadspraytypes)
- [new](#new)

### addSprayType

**Description**

> Adds a new sprayType

**Definition**

> addSprayType(string name, float litersPerSecond, , , )

**Arguments**

| string | name            | sprayType index name |
|--------|-----------------|----------------------|
| float  | litersPerSecond | liter per second     |
| any    | typeName        |                      |
| any    | sprayGroundType |                      |
| any    | isBaseType      |                      |

**Return Values**

| any | sprayType | sprayType object |
|-----|-----------|------------------|

**Code**

```lua
function SprayTypeManager:addSprayType(name, litersPerSecond, typeName, sprayGroundType, isBaseType)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a sprayType.Ignoring sprayType!" )
            return nil
        end

        name = string.upper(name)

        local fillType = g_fillTypeManager:getFillTypeByName(name)
        if fillType = = nil then
            printWarning( "Warning:Missing fillType '" .. tostring(name) .. "' for sprayType definition.Ignoring sprayType!" )
                return
            end

            if isBaseType and self.nameToSprayType[name] ~ = nil then
                printWarning( "Warning:SprayType '" .. tostring(name) .. "' already exists.Ignoring sprayType!" )
                return nil
            end

            local sprayType = self.nameToSprayType[name]
            if sprayType = = nil then
                self.numSprayTypes = self.numSprayTypes + 1

                sprayType = { }
                sprayType.name = name
                sprayType.index = self.numSprayTypes
                sprayType.fillType = fillType
                sprayType.litersPerSecond = Utils.getNoNil(litersPerSecond, 0 )
                typeName = string.upper(typeName)
                sprayType.isFertilizer = typeName = = "FERTILIZER"
                sprayType.isLime = typeName = = "LIME"
                sprayType.isHerbicide = typeName = = "HERBICIDE"

                if not sprayType.isFertilizer and not sprayType.isLime and not sprayType.isHerbicide then
                    printWarning( "Warning:SprayType '" .. tostring(name) .. "' type '" .. tostring(typeName) .. "' is invalid.Possible values are 'FERTILIZER', 'HERBICIDE' or 'LIME'.Ignoring sprayType!" )
                    return nil
                end

                table.insert( self.sprayTypes, sprayType)
                self.nameToSprayType[name] = sprayType
                self.nameToIndex[name] = self.numSprayTypes
                self.indexToName[ self.numSprayTypes] = name
                self.fillTypeIndexToSprayType[fillType.index] = sprayType
            end

            sprayType.litersPerSecond = litersPerSecond or sprayType.litersPerSecond or 0
            sprayType.sprayGroundType = sprayGroundType or sprayType.sprayGroundType or 1

            return sprayType
        end

```

### getFillTypeByName

**Description**

> Gets a sprayType by index name

**Definition**

> getFillTypeByName(string name)

**Arguments**

| string | name | the sprayType index name |
|--------|------|--------------------------|

**Return Values**

| string | sprayType | the sprayType object |
|--------|-----------|----------------------|

**Code**

```lua
function SprayTypeManager:getFillTypeByName(name)
    if name ~ = nil then
        name = string.upper(name)
        return self.nameToSprayType[name]
    end
    return nil
end

```

### getFillTypeIndexByName

**Description**

> Gets a sprayType index by name

**Definition**

> getFillTypeIndexByName(string name)

**Arguments**

| string | name | the sprayType index name |
|--------|------|--------------------------|

**Return Values**

| string | fillTypeIndex | the sprayType index |
|--------|---------------|---------------------|

**Code**

```lua
function SprayTypeManager:getFillTypeIndexByName(name)
    if name ~ = nil then
        name = string.upper(name)
        return self.nameToIndex[name]
    end
    return nil
end

```

### getFillTypeNameByIndex

**Description**

> Gets a fillTypeName by index

**Definition**

> getFillTypeNameByIndex(integer index)

**Arguments**

| integer | index | the sprayType index |
|---------|-------|---------------------|

**Return Values**

| integer | fillTypeName | the sprayType name |
|---------|--------------|--------------------|

**Code**

```lua
function SprayTypeManager:getFillTypeNameByIndex(index)
    if index ~ = nil then
        return self.indexToName[index]
    end
    return nil
end

```

### getSprayTypeByFillTypeIndex

**Description**

**Definition**

> getSprayTypeByFillTypeIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function SprayTypeManager:getSprayTypeByFillTypeIndex(index)
    if index ~ = nil then
        return self.fillTypeIndexToSprayType[index]
    end
    return nil
end

```

### getSprayTypeByIndex

**Description**

> Gets a sprayType by index

**Definition**

> getSprayTypeByIndex(integer index)

**Arguments**

| integer | index | the sprayType index |
|---------|-------|---------------------|

**Return Values**

| integer | sprayType | the sprayType object |
|---------|-----------|----------------------|

**Code**

```lua
function SprayTypeManager:getSprayTypeByIndex(index)
    if index ~ = nil then
        return self.sprayTypes[index]
    end
    return nil
end

```

### getSprayTypeByName

**Description**

> Gets a sprayType by name

**Definition**

> getSprayTypeByName(string name)

**Arguments**

| string | name | the sprayType name |
|--------|------|--------------------|

**Return Values**

| string | sprayType | the sprayType object |
|--------|-----------|----------------------|

**Code**

```lua
function SprayTypeManager:getSprayTypeByName(name)
    if name ~ = nil then
        name = string.upper(name)
        return self.nameToSprayType[name]
    end
    return nil
end

```

### getSprayTypeIndexByFillTypeIndex

**Description**

> Gets a sprayTypeIndex by fillType index

**Definition**

> getSprayTypeIndexByFillTypeIndex(integer index)

**Arguments**

| integer | index | the fillType index |
|---------|-------|--------------------|

**Return Values**

| integer | sprayTypeIndex | the sprayType index |
|---------|----------------|---------------------|

**Code**

```lua
function SprayTypeManager:getSprayTypeIndexByFillTypeIndex(index)
    if index ~ = nil then
        local sprayType = self.fillTypeIndexToSprayType[index]
        if sprayType ~ = nil then
            return sprayType.index
        end
    end
    return nil
end

```

### getSprayTypes

**Description**

> Gets a list of sprayTypes

**Definition**

> getSprayTypes()

**Return Values**

| integer | sprayTypes | list of sprayTypes |
|---------|------------|--------------------|

**Code**

```lua
function SprayTypeManager:getSprayTypes()
    return self.sprayTypes
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function SprayTypeManager:initDataStructures()
    self.numSprayTypes = 0
    self.sprayTypes = { }
    self.nameToSprayType = { }
    self.nameToIndex = { }
    self.indexToName = { }
    self.fillTypeIndexToSprayType = { }

    SprayType = self.nameToIndex
end

```

### loadDefaultTypes

**Description**

**Definition**

> loadDefaultTypes()

**Code**

```lua
function SprayTypeManager:loadDefaultTypes()
    local xmlFile = loadXMLFile( "sprayTypes" , "data/maps/maps_sprayTypes.xml" )
    self:loadSprayTypes(xmlFile, nil , true )
    delete(xmlFile)
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
function SprayTypeManager:loadMapData(xmlFile, missionInfo, baseDirectory)
    SprayTypeManager:superClass().loadMapData( self )
    self:loadDefaultTypes()
    return XMLUtil.loadDataFromMapXML(xmlFile, "sprayTypes" , baseDirectory, self , self.loadSprayTypes, missionInfo)
end

```

### loadSprayTypes

**Description**

> Load data on map load

**Definition**

> loadSprayTypes()

**Arguments**

| any | xmlFile     |
|-----|-------------|
| any | missionInfo |
| any | isBaseType  |

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function SprayTypeManager:loadSprayTypes(xmlFile, missionInfo, isBaseType)
    local i = 0
    while true do
        local key = string.format( "map.sprayTypes.sprayType(%d)" , i)
        if not hasXMLProperty(xmlFile, key) then
            break
        end

        local name = getXMLString(xmlFile, key .. "#name" )
        local litersPerSecond = getXMLFloat(xmlFile, key .. "#litersPerSecond" )
        local typeName = getXMLString(xmlFile, key .. "#type" )
        local sprayGroundType = FieldSprayType.getValueByName(getXMLString(xmlFile, key .. "#sprayGroundType" ))
        self:addSprayType(name, litersPerSecond, typeName, sprayGroundType, isBaseType)

        i = i + 1
    end

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
function SprayTypeManager.new(customMt)
    local self = AbstractManager.new(customMt or SprayTypeManager _mt)
    return self
end

```