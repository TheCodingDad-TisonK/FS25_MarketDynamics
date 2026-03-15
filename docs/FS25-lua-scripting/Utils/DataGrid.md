## DataGrid

**Description**

> A datagrid datastructure

**Functions**

- [delete](#delete)
- [getValue](#getvalue)
- [new](#new)
- [setValue](#setvalue)

### delete

**Description**

> Deletes data grid

**Definition**

> delete()

**Code**

```lua
function DataGrid:delete()
    self.grid = nil
end

```

### getValue

**Description**

> Gets value at given row and column

**Definition**

> getValue(integer rowIndex, integer colIndex)

**Arguments**

| integer | rowIndex | index of row    |
|---------|----------|-----------------|
| integer | colIndex | index of column |

**Return Values**

| integer | value | value at the given position |
|---------|-------|-----------------------------|

**Code**

```lua
function DataGrid:getValue(rowIndex, colIndex)
    if rowIndex < 1 or rowIndex > self.numRows then
        Logging.error( "rowIndex out of bounds!" )
        printCallstack()
        return nil
    end
    if colIndex < 1 or colIndex > self.numColumns then
        Logging.error( "colIndex out of bounds!" )
        printCallstack()
        return nil
    end

    return self.grid[rowIndex][colIndex]
end

```

### new

**Description**

> Creating data grid

**Definition**

> new(integer numRows, integer numColumns, table? customMt)

**Arguments**

| integer | numRows    | number of rows    |
|---------|------------|-------------------|
| integer | numColumns | number of columns |
| table?  | customMt   | custom metatable  |

**Return Values**

| table? | instance | instance of object |
|--------|----------|--------------------|

**Code**

```lua
function DataGrid.new(numRows, numColumns, customMt)
    local self = setmetatable( { } , customMt or DataGrid _mt)

    self.grid = { }
    self.numRows = numRows
    self.numColumns = numColumns
    for _ = 1 , numRows do
        table.insert( self.grid, { } )
    end

    return self
end

```

### setValue

**Description**

> Set value at given row and column

**Definition**

> setValue(integer rowIndex, integer colIndex, table value)

**Arguments**

| integer | rowIndex | index of row                |
|---------|----------|-----------------------------|
| integer | colIndex | index of column             |
| table   | value    | value at the given position |

**Code**

```lua
function DataGrid:setValue(rowIndex, colIndex, value)
    if rowIndex < 1 or rowIndex > self.numRows then
        Logging.error( "rowIndex out of bounds!" )
        printCallstack()
        return false
    end
    if colIndex < 1 or colIndex > self.numColumns then
        Logging.error( "colIndex out of bounds!" )
        printCallstack()
        return false
    end

    self.grid[rowIndex][colIndex] = value
    return true
end

```