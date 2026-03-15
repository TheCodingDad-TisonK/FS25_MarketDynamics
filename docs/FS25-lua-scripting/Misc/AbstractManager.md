## AbstractManager

**Description**

> This class is an abstract template to be implemented by all map-bound manager classes

**Functions**

- [initDataStructures](#initdatastructures)
- [load](#load)
- [loadMapData](#loadmapdata)
- [new](#new)
- [unloadMapData](#unloadmapdata)

### initDataStructures

**Description**

> Initialize data structures

**Definition**

> initDataStructures()

**Code**

```lua
function AbstractManager:initDataStructures()
end

```

### load

**Description**

> Loads initial manager

**Definition**

> load()

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function AbstractManager:load()
    return true
end

```

### loadMapData

**Description**

> Load data on map load

**Definition**

> loadMapData()

**Return Values**

| any | true | if loading was successful else false |
|-----|------|--------------------------------------|

**Code**

```lua
function AbstractManager:loadMapData()
    if g_isDevelopmentVersion and self.loadedMapData then
        Logging.error( "Manager map-data already loaded or not deleted after last game load!" )
        printCallstack()
    end
    self.loadedMapData = true
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
function AbstractManager.new(customMt)
    if customMt ~ = nil and type(customMt) ~ = "table" then
        printCallstack()
    end
    local self = setmetatable( { } , customMt or AbstractManager _mt)

    self:initDataStructures()
    self.loadedMapData = false

    return self
end

```

### unloadMapData

**Description**

> Unload data on mission delete

**Definition**

> unloadMapData()

**Code**

```lua
function AbstractManager:unloadMapData()
    self.loadedMapData = false
    self:initDataStructures()
end

```