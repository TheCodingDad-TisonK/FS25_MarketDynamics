## ToolTypeManager

**Description**

> This class handles all toolTypes

**Parent**

> [AbstractManager](?version=script&category=58&class=564)

**Functions**

- [addToolType](#addtooltype)
- [getNumberOfToolTypes](#getnumberoftooltypes)
- [getToolTypeIndexByName](#gettooltypeindexbyname)
- [getToolTypeNameByIndex](#gettooltypenamebyindex)
- [initDataStructures](#initdatastructures)
- [loadMapData](#loadmapdata)
- [new](#new)

### addToolType

**Description**

> Adds a new baleType

**Definition**

> addToolType(string name, float litersPerSecond)

**Arguments**

| string | name            | baleType index name |
|--------|-----------------|---------------------|
| float  | litersPerSecond | liter per second    |

**Return Values**

| float | baleType | baleType object |
|-------|----------|-----------------|

**Code**

```lua
function ToolTypeManager:addToolType(name)
    name = string.upper(name)
    if not ClassUtil.getIsValidIndexName(name) then
        printWarning( "Warning: '" .. tostring(name) .. "' is not a valid name for a toolType.Ignoring toolType!" )
            return nil
        end

        if ToolType[name] = = nil then
            table.insert( self.indexToName, name)
            self.nameToInt[name] = # self.indexToName
        end
        return ToolType[name]
    end

```

### getNumberOfToolTypes

**Description**

> Returns number of tool types

**Definition**

> getNumberOfToolTypes()

**Return Values**

| float | numToolTypes | number of tool types |
|-------|--------------|----------------------|

**Code**

```lua
function ToolTypeManager:getNumberOfToolTypes()
    return # self.indexToName
end

```

### getToolTypeIndexByName

**Description**

> Returns tool type index by given name

**Definition**

> getToolTypeIndexByName(string toolTypeName)

**Arguments**

| string | toolTypeName | tool type name |
|--------|--------------|----------------|

**Return Values**

| string | toolTypeIndex | tool type index |
|--------|---------------|-----------------|

**Code**

```lua
function ToolTypeManager:getToolTypeIndexByName(name)
    name = string.upper(name)
    if self.nameToInt[name] ~ = nil then
        return self.nameToInt[name]
    end

    return ToolType.UNDEFINED
end

```

### getToolTypeNameByIndex

**Description**

> Returns tool type name by given index

**Definition**

> getToolTypeNameByIndex(integer toolTypeIndex)

**Arguments**

| integer | toolTypeIndex | tool type index |
|---------|---------------|-----------------|

**Return Values**

| integer | toolTypeName | tool type name |
|---------|--------------|----------------|

**Code**

```lua
function ToolTypeManager:getToolTypeNameByIndex(index)
    if self.indexToName[index] ~ = nil then
        return self.indexToName[index]
    end

    return "UNDEFINED"
end

```

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function ToolTypeManager:initDataStructures()
    self.indexToName = { }
    self.nameToInt = { }

    ToolType = self.nameToInt
end

```

### loadMapData

**Description**

> Loads initial manager

**Definition**

> loadMapData()

**Return Values**

| integer | true | if loading was successful else false |
|---------|------|--------------------------------------|

**Code**

```lua
function ToolTypeManager:loadMapData()
    ToolTypeManager:superClass().loadMapData( self )

    self:addToolType( "undefined" )
    self:addToolType( "dischargeable" )
    self:addToolType( "pallet" )
    self:addToolType( "trigger" )
    self:addToolType( "bale" )

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
function ToolTypeManager.new(customMt)
    local self = AbstractManager.new(customMt or ToolTypeManager _mt)

    return self
end

```