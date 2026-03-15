## RTKStation

**Description**

> Specialization for placeable RTK stations

**Functions**

- [onDelete](#ondelete)
- [onFinalizePlacement](#onfinalizeplacement)
- [prerequisitesPresent](#prerequisitespresent)
- [registerEventListeners](#registereventlisteners)
- [registerFunctions](#registerfunctions)
- [registerOverwrittenFunctions](#registeroverwrittenfunctions)
- [registerXMLPaths](#registerxmlpaths)

### onDelete

**Description**

**Definition**

> onDelete()

**Code**

```lua
function RTKStation:onDelete()
    if g_precisionFarming ~ = nil then
        g_precisionFarming.aiExtension:unregisterRTKStation( self )
    end
end

```

### onFinalizePlacement

**Description**

**Definition**

> onFinalizePlacement()

**Arguments**

| any | savegame |
|-----|----------|

**Code**

```lua
function RTKStation:onFinalizePlacement(savegame)
    if g_precisionFarming ~ = nil then
        g_precisionFarming.aiExtension:registerRTKStation( self )
    end
end

```

### prerequisitesPresent

**Description**

> Checks if all prerequisite specializations are loaded

**Definition**

> prerequisitesPresent(table specializations)

**Arguments**

| table | specializations | specializations |
|-------|-----------------|-----------------|

**Return Values**

| table | hasPrerequisite | true if all prerequisite specializations are loaded |
|-------|-----------------|-----------------------------------------------------|

**Code**

```lua
function RTKStation.prerequisitesPresent(specializations)
    return true
end

```

### registerEventListeners

**Description**

**Definition**

> registerEventListeners()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function RTKStation.registerEventListeners(placeableType)
    SpecializationUtil.registerEventListener(placeableType, "onFinalizePlacement" , RTKStation )
    SpecializationUtil.registerEventListener(placeableType, "onDelete" , RTKStation )
end

```

### registerFunctions

**Description**

**Definition**

> registerFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function RTKStation.registerFunctions(placeableType)
end

```

### registerOverwrittenFunctions

**Description**

**Definition**

> registerOverwrittenFunctions()

**Arguments**

| any | placeableType |
|-----|---------------|

**Code**

```lua
function RTKStation.registerOverwrittenFunctions(placeableType)
end

```

### registerXMLPaths

**Description**

**Definition**

> registerXMLPaths()

**Arguments**

| any | schema   |
|-----|----------|
| any | basePath |

**Code**

```lua
function RTKStation.registerXMLPaths(schema, basePath)
end

```