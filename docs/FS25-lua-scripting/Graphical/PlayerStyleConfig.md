## PlayerStyleConfig

**Description**

> Represents a single config for a player style (face, beard, top, etc.).

**Functions**

- [BEARD\_FACE\_GETTER\_FILTER](#beard_face_getter_filter)
- [ENABLED\_GETTER\_FILTER](#enabled_getter_filter)
- [getItemIndex](#getitemindex)
- [getItemNameIndex](#getitemnameindex)
- [getSelectedItem](#getselecteditem)
- [NO\_ONEPIECE\_GETTER\_FILTER](#no_onepiece_getter_filter)
- [NOT\_FOR\_HAT\_GETTER\_FILTER](#not_for_hat_getter_filter)
- [NOT\_HIDDEN\_GETTER\_FILTER](#not_hidden_getter_filter)
- [SELECTED\_GETTER\_FILTER](#selected_getter_filter)

### BEARD\_FACE\_GETTER\_FILTER

**Description**

> Includes any beards that fit with the current face.

**Definition**

> BEARD\_FACE\_GETTER\_FILTER(integer index, PlayerStyleItem beard)

**Arguments**

| integer         | index | The index of the item.     |
|-----------------|-------|----------------------------|
| PlayerStyleItem | beard | The beard to compare with. |

**Return Values**

| PlayerStyleItem | include | True if the item should be included; otherwise false. |
|-----------------|---------|-------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:BEARD_FACE_GETTER_FILTER(index, beard)
    return beard.faceName = = nil or( self.playerStyle.configs.face:getSelectedItem() ~ = nil and beard.faceName = = self.playerStyle.configs.face:getSelectedItem().name)
end

```

### ENABLED\_GETTER\_FILTER

**Description**

> Includes any items enabled for the current selection.

**Definition**

> ENABLED\_GETTER\_FILTER(integer index)

**Arguments**

| integer | index | The index of the item. |
|---------|-------|------------------------|

**Return Values**

| integer | include | True if the item should be included; otherwise false. |
|---------|---------|-------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:ENABLED_GETTER_FILTER(index)
    return not self.playerStyle.disabledOptionsForSelection[ self.name]
end

```

### getItemIndex

**Description**

> Gets the index of the given item.

**Definition**

> getItemIndex(PlayerStyleItem item)

**Arguments**

| PlayerStyleItem | item | The item whose index should be found. |
|-----------------|------|---------------------------------------|

**Return Values**

| PlayerStyleItem | index | The index of the found item, or nil if the item is nil or does not exist in this config. |
|-----------------|-------|------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:getItemIndex(item)

    -- If the item is nil, return nil as it has no index.
    if item = = nil then
        return nil
    end

    --#debug Assert.isClass(item, PlayerStyleItem, "Cannot get non-item from list of items!")

    -- Special case for item at index 0(empty item), as it does not get picked up by ipairs() and pairs() does not guarentee order.
        if item = = self.items[ 0 ] then
            return 0
        end

        -- Return the index of the item in the collection.This will be nil if the item is not found.
            return table.find( self.items, item)
        end

```

### getItemNameIndex

**Description**

> Gets the index of the item with the given name.

**Definition**

> getItemNameIndex(string itemName)

**Arguments**

| string | itemName | The name of the item whose index should be found. |
|--------|----------|---------------------------------------------------|

**Return Values**

| string | index | The index of the found item, or nil if the item is nil or does not exist in this config. |
|--------|-------|------------------------------------------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:getItemNameIndex(itemName)

    --#debug Assert.isNilOrType(itemName, "string", "Item name should be a string or nil!")

    -- If the name is nil or whitespace, do nothing as it has no associated index.
        if string.isNilOrWhitespace(itemName) then
            return nil
        end

        -- Get the item from its name.If it is nil then return nil.
        local item = self.itemsByName[itemName]
        if item = = nil then
            return nil
        end

        -- Get the index from the item.
        return self:getItemIndex(item)
    end

```

### getSelectedItem

**Description**

> Gets the currently selected item.

**Definition**

> getSelectedItem()

**Return Values**

| string | item | The currently selected item. |
|--------|------|------------------------------|

**Code**

```lua
function PlayerStyleConfig:getSelectedItem()
    return self.items[ self.selectedItemIndex]
end

```

### NO\_ONEPIECE\_GETTER\_FILTER

**Description**

> Includes any item when a onepiece is not selected.

**Definition**

> NO\_ONEPIECE\_GETTER\_FILTER(integer index)

**Arguments**

| integer | index | The index of the item. |
|---------|-------|------------------------|

**Return Values**

| integer | include | True if the item should be included; otherwise false. |
|---------|---------|-------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:NO_ONEPIECE_GETTER_FILTER(index)
    return self.playerStyle.configs.onepiece.selectedItemIndex = = 0
end

```

### NOT\_FOR\_HAT\_GETTER\_FILTER

**Description**

> Includes any non-hat hair styles.

**Definition**

> NOT\_FOR\_HAT\_GETTER\_FILTER(integer index, PlayerStyleItem hair)

**Arguments**

| integer         | index | The index of the item.    |
|-----------------|-------|---------------------------|
| PlayerStyleItem | hair  | The item to compare with. |

**Return Values**

| PlayerStyleItem | include | True if the item should be included; otherwise false. |
|-----------------|---------|-------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:NOT_FOR_HAT_GETTER_FILTER(index, hair)
    return not hair.forHat
end

```

### NOT\_HIDDEN\_GETTER\_FILTER

**Description**

> Includes any non-hidden items.

**Definition**

> NOT\_HIDDEN\_GETTER\_FILTER(integer index, PlayerStyleItem gear)

**Arguments**

| integer         | index | The index of the item.    |
|-----------------|-------|---------------------------|
| PlayerStyleItem | gear  | The item to compare with. |

**Return Values**

| PlayerStyleItem | include | True if the item should be included; otherwise false. |
|-----------------|---------|-------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:NOT_HIDDEN_GETTER_FILTER(index, gear)
    return not gear.hidden
end

```

### SELECTED\_GETTER\_FILTER

**Description**

> Includes any selected items.

**Definition**

> SELECTED\_GETTER\_FILTER(integer index)

**Arguments**

| integer | index | The index of the item. |
|---------|-------|------------------------|

**Return Values**

| integer | include | True if the item should be included; otherwise false. |
|---------|---------|-------------------------------------------------------|

**Code**

```lua
function PlayerStyleConfig:SELECTED_GETTER_FILTER(index)
    return self.selectedItemIndex = = index
end

```