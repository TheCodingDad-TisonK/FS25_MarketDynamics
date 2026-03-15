## MapDataGrid

**Description**

> A map data grid that splits a map into multiple sections

**Parent**

> [DataGrid](?version=script&category=90&class=871)

**Functions**

- [createFromBlockSize](#createfromblocksize)
- [getRowColumnFromWorldPos](#getrowcolumnfromworldpos)
- [getValueAtWorldPos](#getvalueatworldpos)
- [isWorldPositionInRange](#isworldpositioninrange)
- [new](#new)
- [setValueAtWorldPos](#setvalueatworldpos)

### createFromBlockSize

**Description**

> Creates a new data grid from the given map size and block size.

**Definition**

> createFromBlockSize(integer mapSize, integer blockSize, table? customMt)

**Arguments**

| integer | mapSize   | The size of the map in metres.       |
|---------|-----------|--------------------------------------|
| integer | blockSize | The size of one cell in metres.      |
| table?  | customMt  | The custom metatable to use, if any. |

**Return Values**

| table? | instance | The created instance. |
|--------|----------|-----------------------|

**Code**

```lua
function MapDataGrid.createFromBlockSize(mapSize, blockSize, customMt)

    -- Calculate the blocks per row, then return the result of the constructor with this value.
    local blocksPerRowColumn = math.ceil(mapSize / blockSize)
    return MapDataGrid.new(mapSize, blocksPerRowColumn, customMt)
end

```

### getRowColumnFromWorldPos

**Description**

> Gets clamped row and column at given world position

**Definition**

> getRowColumnFromWorldPos(float worldX, float worldZ)

**Arguments**

| float | worldX | world position x |
|-------|--------|------------------|
| float | worldZ | world position z |

**Return Values**

| float | row    | row    |
|-------|--------|--------|
| float | column | column |

**Code**

```lua
function MapDataGrid:getRowColumnFromWorldPos(worldX, worldZ)
    local mapSize = self.mapSize
    local blocksPerRowColumn = self.blocksPerRowColumn

    local x = (worldX + mapSize * 0.5 ) / mapSize
    local z = (worldZ + mapSize * 0.5 ) / mapSize

    local row = math.clamp( math.ceil(blocksPerRowColumn * z), 1 , blocksPerRowColumn)
    local column = math.clamp( math.ceil(blocksPerRowColumn * x), 1 , blocksPerRowColumn)

    -- log(worldX, worldZ, " -> ", (worldX + self.mapSize*0.5), (worldZ + self.mapSize*0.5), z, x, row, column)

    return row, column
end

```

### getValueAtWorldPos

**Description**

> Get value at world position

**Definition**

> getValueAtWorldPos(float worldX, float worldZ)

**Arguments**

| float | worldX | world position x |
|-------|--------|------------------|
| float | worldZ | world position z |

**Return Values**

| float | value | value at the given position |
|-------|-------|-----------------------------|

**Code**

```lua
function MapDataGrid:getValueAtWorldPos(worldX, worldZ)
    local rowIndex, colIndex = self:getRowColumnFromWorldPos(worldX, worldZ)
    return self:getValue(rowIndex, colIndex), rowIndex, colIndex
end

```

### isWorldPositionInRange

**Description**

> Calculates if the given world position is in range of the data.

**Definition**

> isWorldPositionInRange(float worldX, float worldZ)

**Arguments**

| float | worldX | The x world position. |
|-------|--------|-----------------------|
| float | worldZ | The z world position. |

**Return Values**

| float | isInRange | True if the position is in range of the data; otherwise false. |
|-------|-----------|----------------------------------------------------------------|

**Code**

```lua
function MapDataGrid:isWorldPositionInRange(worldX, worldZ)
    return worldX > self.mapSize * - 0.5 and worldX < = self.mapSize * 0.5 and worldZ > self.mapSize * - 0.5 and worldZ < = self.mapSize * 0.5
end

```

### new

**Description**

> Creates a map grid instance with the given map size, cells per row/column, and optional custom metatable.

**Definition**

> new(integer mapSize, integer blocksPerRowColumn, table? customMt)

**Arguments**

| integer | mapSize            | map size                  |
|---------|--------------------|---------------------------|
| integer | blocksPerRowColumn | blocks per row and column |
| table?  | customMt           | custom metatable          |

**Return Values**

| table? | instance | instance of object |
|--------|----------|--------------------|

**Code**

```lua
function MapDataGrid.new(mapSize, blocksPerRowColumn, customMt)
    local self = DataGrid.new(blocksPerRowColumn, blocksPerRowColumn, customMt or MapDataGrid _mt)

    self.blocksPerRowColumn = blocksPerRowColumn
    self.mapSize = mapSize
    self.blockSize = self.mapSize / self.blocksPerRowColumn

    return self
end

```

### setValueAtWorldPos

**Description**

> Set value at world position

**Definition**

> setValueAtWorldPos(float worldX, float worldZ, table value)

**Arguments**

| float | worldX | world position x            |
|-------|--------|-----------------------------|
| float | worldZ | world position z            |
| table | value  | value at the given position |

**Code**

```lua
function MapDataGrid:setValueAtWorldPos(worldX, worldZ, value)
    local rowIndex, colIndex = self:getRowColumnFromWorldPos(worldX, worldZ)
    self:setValue(rowIndex, colIndex, value)
end

```