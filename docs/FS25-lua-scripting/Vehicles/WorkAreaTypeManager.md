## WorkAreaTypeManager

**Description**

> This class handles all workArea types

**Parent**

> [AbstractManager](?version=script&category=91&class=898)

**Functions**

- [addWorkAreaType](#addworkareatype)
- [getConfigurationDescByName](#getconfigurationdescbyname)
- [getWorkAreaTypeByIndex](#getworkareatypebyindex)
- [getWorkAreaTypeIndexByName](#getworkareatypeindexbyname)
- [getWorkAreaTypeIsAIArea](#getworkareatypeisaiarea)
- [getWorkAreaTypeIsSteeringAssistArea](#getworkareatypeissteeringassistarea)
- [getWorkAreaTypeNameByIndex](#getworkareatypenamebyindex)
- [initDataStructures](#initdatastructures)
- [new](#new)

### addWorkAreaType

**Description**

**Definition**

> addWorkAreaType()

**Arguments**

| any | name                 |
|-----|----------------------|
| any | attractWildlife      |
| any | isAIArea             |
| any | isSteeringAssistArea |

**Code**

```lua
function WorkAreaTypeManager:addWorkAreaType(name, attractWildlife, isAIArea, isSteeringAssistArea)
    if name = = nil then
        Logging.error( "WorkArea name missing!" )
        return
    end
    if self.workAreaTypeNameToInt[name] ~ = nil then
        Logging.error( "WorkArea name '%s' is already in use!" , name)
        return
    end

    name = string.upper(name)

    local entry = { }
    entry.name = name
    entry.index = # self.workAreaTypes + 1
    entry.attractWildlife = Utils.getNoNil(attractWildlife, false )
    entry.isAIArea = Utils.getNoNil(isAIArea, false )
    entry.isSteeringAssistArea = Utils.getNoNil(isSteeringAssistArea, false )

    self.workAreaTypeNameToInt[name] = entry.index
    self.workAreaTypeNameToDesc[name] = entry
    table.insert( self.workAreaTypes, entry)

    print( " Register workAreaType '" .. name .. "'" )
end

```

### getConfigurationDescByName

**Description**

**Definition**

> getConfigurationDescByName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function WorkAreaTypeManager:getConfigurationDescByName(name)
    if name ~ = nil then
        return self.workAreaTypeNameToDesc[ string.upper(name)]
    end
    return nil
end

```

### getWorkAreaTypeByIndex

**Description**

**Definition**

> getWorkAreaTypeByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function WorkAreaTypeManager:getWorkAreaTypeByIndex(index)
    return self.workAreaTypes[index]
end

```

### getWorkAreaTypeIndexByName

**Description**

**Definition**

> getWorkAreaTypeIndexByName()

**Arguments**

| any | name |
|-----|------|

**Code**

```lua
function WorkAreaTypeManager:getWorkAreaTypeIndexByName(name)
    if name ~ = nil then
        return self.workAreaTypeNameToInt[ string.upper(name)]
    end
    return nil
end

```

### getWorkAreaTypeIsAIArea

**Description**

**Definition**

> getWorkAreaTypeIsAIArea()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function WorkAreaTypeManager:getWorkAreaTypeIsAIArea(index)
    if self.workAreaTypes[index] ~ = nil then
        return self.workAreaTypes[index].isAIArea
    end

    return false
end

```

### getWorkAreaTypeIsSteeringAssistArea

**Description**

**Definition**

> getWorkAreaTypeIsSteeringAssistArea()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function WorkAreaTypeManager:getWorkAreaTypeIsSteeringAssistArea(index)
    if self.workAreaTypes[index] ~ = nil then
        return self.workAreaTypes[index].isSteeringAssistArea
    end

    return false
end

```

### getWorkAreaTypeNameByIndex

**Description**

**Definition**

> getWorkAreaTypeNameByIndex()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function WorkAreaTypeManager:getWorkAreaTypeNameByIndex(index)
    local workAreaType = self.workAreaTypes[index]
    if workAreaType then
        return workAreaType.name
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
function WorkAreaTypeManager:initDataStructures()
    self.workAreaTypes = { }
    self.workAreaTypeNameToInt = { }
    self.workAreaTypeNameToDesc = { }
    WorkAreaType = self.workAreaTypeNameToInt
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
function WorkAreaTypeManager.new(customMt)
    local self = AbstractManager.new(customMt or WorkAreaTypeManager _mt)

    return self
end

```