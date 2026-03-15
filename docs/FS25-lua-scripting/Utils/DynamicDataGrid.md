## DynamicDataGrid

**Functions**

- [delete](#delete)
- [getCellFromWorldPosition](#getcellfromworldposition)
- [getGridIndicesByWorldPosition](#getgridindicesbyworldposition)
- [getGridSnappedPosition](#getgridsnappedposition)
- [getLocalIndicesByWorldPosition](#getlocalindicesbyworldposition)
- [getWorldPositionByLocalIndices](#getworldpositionbylocalindices)
- [new](#new)

### delete

**Description**

> Calls the delete function on every cell, then cleans up.

**Definition**

> delete()

**Code**

```lua
function DynamicDataGrid:delete()

    -- Go over each cell in the data.
    for columnIndex = self.localStartIndex, self.localEndIndex do
        for rowIndex = self.localStartIndex, self.localEndIndex do

            -- Get the cell.
            local cell = self:getCellFromLocalIndices(columnIndex, rowIndex)

            -- If the cell has a delete function, call it.
                if cell and cell.delete then
                    cell:delete()
                end
            end
        end

        -- Unset the grid.
        self.grid = nil
    end

```

### getCellFromWorldPosition

**Description**

> Gets and returns the cell that exists at the given world position.

**Definition**

> getCellFromWorldPosition(float worldX, float worldZ, boolean clamp)

**Arguments**

| float   | worldX | The x position in the world.                                               |
|---------|--------|----------------------------------------------------------------------------|
| float   | worldZ | The z position in the world.                                               |
| boolean | clamp  | True if the position should be clamped within the grid; defaults to false. |

**Return Values**

| boolean | cell | The cell at the given position, or nil if none was found. |
|---------|------|-----------------------------------------------------------|

**Code**

```lua
function DynamicDataGrid:getCellFromWorldPosition(worldX, worldZ, clamp)

    -- Calculate the indices.
    local xIndex, zIndex = self:getLocalIndicesByWorldPosition(worldX, worldZ)

    -- If the indices should be clamped, do so.
        if clamp then
            xIndex = math.clamp(xIndex, self.localStartIndex, self.localEndIndex)
            zIndex = math.clamp(zIndex, self.localStartIndex, self.localEndIndex)
        end

        -- Get the row.
        local xrows = self.grid[ self.centreIndex + xIndex]

        -- If the row exists, return the cell at the column on the row.
        if xrows ~ = nil then
            return xrows[ self.centreIndex + zIndex]
        end

        -- Return nil if nothing was found.
            return nil
        end

```

### getGridIndicesByWorldPosition

**Description**

> Gets the grid indices of the given position. The grid index is from 1 - rowColumnCount, essentially allowing the
> underlying 2D array to be indexed.

**Definition**

> getGridIndicesByWorldPosition(float worldX, float worldZ)

**Arguments**

| float | worldX | The x position in the world. |
|-------|--------|------------------------------|
| float | worldZ | The z position in the world. |

**Return Values**

| float | indexX | The x index of the position. |
|-------|--------|------------------------------|
| float | indexZ | The z index of the position. |

**Code**

```lua
function DynamicDataGrid:getGridIndicesByWorldPosition(worldX, worldZ)

    local worldIndexX, worldIndexZ = self:getWorldIndicesByWorldPosition(worldX, worldZ)
    local currentIndexX, currentIndexZ = self:getWorldIndicesByWorldPosition( self.lastPosition.x, self.lastPosition.z)

    -- Convert the position to an index, then offset it by the centre index to map it to 1 - rowColumnCount.
    worldIndexX = (worldIndexX - currentIndexX) + self.centreIndex
    worldIndexZ = (worldIndexZ - currentIndexZ) + self.centreIndex

    return worldIndexX, worldIndexZ
end

```

### getGridSnappedPosition

**Description**

> Calculates and returns the given position snapped to the grid.

**Definition**

> getGridSnappedPosition(float x, float z)

**Arguments**

| float | x | The x position. |
|-------|---|-----------------|
| float | z | The z position. |

**Return Values**

| float | snappedX | The snapped x position. |
|-------|----------|-------------------------|
| float | snappedZ | The snapped z position. |

**Code**

```lua
function DynamicDataGrid:getGridSnappedPosition(x, z)

    local snappedX = math.floor(x / self.tileSize) * self.tileSize
    local snappedZ = math.floor(z / self.tileSize) * self.tileSize

    -- Apply the half cell offset to the position.
    snappedX = snappedX + ( self.tileSize / 2.0 )
    snappedZ = snappedZ + ( self.tileSize / 2.0 )

    return snappedX, snappedZ
end

```

### getLocalIndicesByWorldPosition

**Description**

> Calculates and returns the index relative to the position of the grid, so that the index 0, 0 is the centre of the
> grid.

**Definition**

> getLocalIndicesByWorldPosition(float worldX, float worldZ)

**Arguments**

| float | worldX | The x position in the world. |
|-------|--------|------------------------------|
| float | worldZ | The z position in the world. |

**Return Values**

| float | indexX | The local x index of the position. |
|-------|--------|------------------------------------|
| float | indexZ | The local z index of the position. |

**Code**

```lua
function DynamicDataGrid:getLocalIndicesByWorldPosition(worldX, worldZ)

    local currentIndexX, currentIndexZ = self:getWorldIndicesByWorldPosition( self.lastPosition.x, self.lastPosition.z)
    local worldIndexX, worldIndexZ = self:getWorldIndicesByWorldPosition(worldX, worldZ)

    -- Convert the position to an index.
    local localIndexX = (worldIndexX - currentIndexX)
    local localIndexZ = (worldIndexZ - currentIndexZ)

    return localIndexX, localIndexZ
end

```

### getWorldPositionByLocalIndices

**Description**

> Calculates the world position of the centre of the cell at the position defined by the current position and given cell
> offset.

**Definition**

> getWorldPositionByLocalIndices(float localIndexX, float localIndexZ)

**Arguments**

| float | localIndexX | The x index of the cell relative to the centre cell. |
|-------|-------------|------------------------------------------------------|
| float | localIndexZ | The z index of the cell relative to the centre cell. |

**Return Values**

| float | worldX | The world x position of the centre of the cell. |
|-------|--------|-------------------------------------------------|
| float | worldZ | The world z position of the centre of the cell. |

**Code**

```lua
function DynamicDataGrid:getWorldPositionByLocalIndices(localIndexX, localIndexZ)

    local currentIndexX, currentIndexZ = self:getWorldIndicesByWorldPosition( self.lastPosition.x, self.lastPosition.z)

    -- Return the world position.
    return self:getGridSnappedPositionByLocalIndices(currentIndexX + localIndexX, currentIndexZ + localIndexZ)
end

```

### new

**Description**

> Creating dynamic data grid

**Definition**

> new()

**Arguments**

| any | size            |
|-----|-----------------|
| any | tileSize        |
| any | startX          |
| any | startZ          |
| any | cellConstructor |
| any | customMt        |

**Code**

```lua
function DynamicDataGrid.new(size, tileSize, startX, startZ, cellConstructor, customMt)

    -- Ensure the arguments are valid.
    --#debug assert(size ~ = nil, "Grid size was missing")
    --#debug assert(type(size) = = "number", "Grid size was not number")
    --#debug assert(size > 0, "Grid size was 0 or lower")

    --#debug assert(tileSize ~ = nil, "Tile size was missing")
    --#debug assert(type(tileSize) = = "number", "Tile size was not number")
    --#debug assert(tileSize > 0, "Tile size was 0 or lower")

    --#debug if startX ~ = nil then
        --#debug assert(type(startX) = = "number", "Starting x position was not a number")
        --#debug assert(startZ ~ = nil, "Starting x position was given, but not z position")
        --#debug assert(type(startZ) = = "number", "Starting z position was not a number")
        --#debug end
        --#debug if startZ ~ = nil then
            --#debug assert(startX ~ = nil, "Starting z position was given, but not x position")
            --#debug assert(type(startZ) = = "number", "Starting z position was not a number")
            --#debug end

            --#debug if cellConstructor ~ = nil then
                --#debug assert(type(cellConstructor) = = "function", "Given cell constructor was not a function")
                    --#debug end

                    -- Create the instance.
                    local self = setmetatable( { } , customMt or DynamicDataGrid _mt)

                    -- The size variables.
                    self.tileSize = tileSize or 1
                    self.size = size or 20
                    self.rowColumnCount = math.ceil( self.size / self.tileSize)

                    -- Calculate the centre index.
                    self.centreIndex = math.floor( self.rowColumnCount * 0.5 ) + 1
                    self.localStartIndex = 1 - self.centreIndex
                    self.localEndIndex = ( self.localStartIndex + self.rowColumnCount) - 1

                    -- The last set position and its related indices.
                    self.lastPosition = { x = 0 , z = 0 }

                    -- Set the positional data if a position was given.
                        if startX and startZ then
                            self.lastPosition.x = startX
                            self.lastPosition.z = startZ
                        end

                        -- Keep track of any cells that get moved.
                        self.movedCells = { }

                        -- Create the grid.
                        self.grid = { }
                        for columnIndex = self.localStartIndex, self.localEndIndex do

                            -- Create the column.
                            local column = { }

                            -- Add each cell to the column.If a constructor was given, use that; otherwise just create an empty table.
                            for rowIndex = self.localStartIndex, self.localEndIndex do
                                local cell
                                if cellConstructor then
                                    local cellWorldX, cellWorldZ = self:getWorldPositionByLocalIndices(columnIndex, rowIndex)
                                    cell = cellConstructor(cellWorldX, cellWorldZ)
                                else
                                        cell = { }
                                    end
                                    table.insert(column, cell)
                                end

                                -- Insert the column into the grid.
                                table.insert( self.grid, column)
                            end

                            -- The y offset.
                            self.yOffset = 0.05

                            -- Return the created instance.
                            return self
                        end

```