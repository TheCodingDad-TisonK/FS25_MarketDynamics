## InGameMenuStatisticsFrame

**Description**

> Game statistics display frame for the in-game menu.

**Parent**

> [TabbedMenuFrameElement](?version=script&category=43&class=470)

**Functions**

- [buildCellDatabase](#buildcelldatabase)
- [dequeueDetailsCell](#dequeuedetailscell)
- [getMenuButtonInfo](#getmenubuttoninfo)
- [queueDetailsCell](#queuedetailscell)

### buildCellDatabase

**Description**

> Creates a table that contains all different list items. Section headers are excluded and saved separately.
> These cells are later cloned to form the completed list

**Definition**

> buildCellDatabase()

**Code**

```lua
function InGameMenuStatisticsFrame:buildCellDatabase()
    for k, clone in pairs( self.detailsTemplates) do
        clone:delete()
        self.detailsTemplates[k] = nil
    end
    self.detailsTemplates = { }

    for i = # self.attributesLayout.elements, 1 , - 1 do
        local element = self.attributesLayout.elements[i]
        local name = element.name

        self.detailsTemplates[name] = element:clone()
        self.detailsCache[name] = { }
    end
end

```

### dequeueDetailsCell

**Description**

> Get a cell with given type name. If there are cells with the correct name in the cellCache, we use those, otherwise a
> new one is created

**Definition**

> dequeueDetailsCell(string name)

**Arguments**

| string | name | Name of the cell |
|--------|------|------------------|

**Return Values**

| string | A | cell instance with the requested name |
|--------|---|---------------------------------------|

**Code**

```lua
function InGameMenuStatisticsFrame:dequeueDetailsCell(name)
    if self.detailsTemplates[name] = = nil then
        return nil
    end

    local cell

    local cache = self.detailsCache[name]
    if #cache > 0 then
        cell = cache[#cache]
        cache[#cache] = nil
    else
            cell = self.detailsTemplates[name]:clone()
        end

        self.attributesLayout:addElement(cell)

        return cell
    end

```

### getMenuButtonInfo

**Description**

> Get custom menu button information.

**Definition**

> getMenuButtonInfo()

**Return Values**

| string | Array | of button info as {i={inputAction=, text=, callback=}} |
|--------|-------|--------------------------------------------------------|

**Code**

```lua
function InGameMenuStatisticsFrame:getMenuButtonInfo()
    return self.menuButtonInfo[ self.subCategoryPaging:getState()]
end

```

### queueDetailsCell

**Description**

> Release a cell to the cache after resetting it

**Definition**

> queueDetailsCell(table cell)

**Arguments**

| table | cell | The cell to be added to the cache |
|-------|------|-----------------------------------|

**Code**

```lua
function InGameMenuStatisticsFrame:queueDetailsCell(cell)
    local cache = self.detailsCache[cell.name]
    cache[#cache + 1 ] = cell

    self.attributesLayout:removeElement(cell)

    cell:unlinkElement()
end

```