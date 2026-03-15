## ShopItemsFrame

**Description**

> Shop items frame for the in-game menu shop.
> Displays purchasable items of a common category in a horizontal list layout.

**Parent**

> [TabbedMenuFrameElement](?version=script&category=43&class=494)

**Functions**

- [buildCellDatabase](#buildcelldatabase)
- [dequeueDetailsCell](#dequeuedetailscell)
- [queueDetailsCell](#queuedetailscell)

### buildCellDatabase

**Description**

> Creates a table that contains all different list items. Section headers are excluded and saved separately.
> These cells are later cloned to form the completed list

**Definition**

> buildCellDatabase()

**Code**

```lua
function ShopItemsFrame:buildCellDatabase()
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
function ShopItemsFrame:dequeueDetailsCell(name)
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
function ShopItemsFrame:queueDetailsCell(cell)
    local cache = self.detailsCache[cell.name]
    cache[#cache + 1 ] = cell

    self.attributesLayout:removeElement(cell)

    cell:unlinkElement()
end

```