## GuiDataSource

**Description**

> Data source for UI elements.
> Holds dynamic data and allows configuration of accessors.

**Functions**

- [addChangeListener](#addchangelistener)
- [getCount](#getcount)
- [getItem](#getitem)
- [iterateRange](#iteraterange)
- [new](#new)
- [notifyChange](#notifychange)
- [removeChangeListener](#removechangelistener)
- [setData](#setdata)
- [setItem](#setitem)

### addChangeListener

**Description**

> Add a listener with a member function which is called when this data source changes.

**Definition**

> addChangeListener()

**Arguments**

| any | target   |
|-----|----------|
| any | callback |

**Code**

```lua
function GuiDataSource:addChangeListener(target, callback)
    self.changeListeners[target] = callback or NO_CALLBACK
end

```

### getCount

**Description**

> Get the number of data items.

**Definition**

> getCount()

**Code**

```lua
function GuiDataSource:getCount()
    return # self.data
end

```

### getItem

**Description**

> Get a data item at a given index.

**Definition**

> getItem()

**Arguments**

| any | index |
|-----|-------|

**Code**

```lua
function GuiDataSource:getItem(index)
    return self.data[index]
end

```

### iterateRange

**Description**

> Iterate a data range within the given indices.
> This is an iterator factory compatible with the default Lua for loop. E.g. "for \_, item in source:iterateRange(1, 10)
> do"
> will loop over data items 1 to 10.

**Definition**

> iterateRange()

**Arguments**

| any | startIndex |
|-----|------------|
| any | endIndex   |

**Code**

```lua
function GuiDataSource:iterateRange(startIndex, endIndex)
    local iterator = function (data, iter)
        local item = data[iter]
        if iter < = endIndex and item ~ = nil then
            return iter + 1 , item
        else
                return nil , nil
            end
        end

        return iterator, self.data, startIndex
    end

```

### new

**Description**

> Create a new GuiDataSource instance.

**Definition**

> new()

**Arguments**

| any | subclass_mt |
|-----|-------------|

**Code**

```lua
function GuiDataSource.new(subclass_mt)
    local self = setmetatable( { } , subclass_mt or GuiDataSource _mt)

    self.data = NO_DATA
    self.changeListeners = { } -- {<listener table> = <listener function>}

        return self
    end

```

### notifyChange

**Description**

> Notify this data source that its data has been changed externally.
> This will call the change callback if it has been set.

**Definition**

> notifyChange()

**Code**

```lua
function GuiDataSource:notifyChange()
    for target, callback in pairs( self.changeListeners) do
        callback(target)
    end
end

```

### removeChangeListener

**Description**

> Remove a previously added change listener from the notification table.

**Definition**

> removeChangeListener()

**Arguments**

| any | target |
|-----|--------|

**Code**

```lua
function GuiDataSource:removeChangeListener(target)
    self.changeListeners[target] = nil
end

```

### setData

**Description**

> Set the data source data array.

**Definition**

> setData()

**Arguments**

| any | data |
|-----|------|

**Code**

```lua
function GuiDataSource:setData(data)
    self.data = data or NO_DATA
    self:notifyChange()
end

```

### setItem

**Description**

> Set a data item at a given index.
> If the index is out bounds of the data, this will have no effect.

**Definition**

> setItem()

**Arguments**

| any | index             |
|-----|-------------------|
| any | value             |
| any | needsNotification |

**Code**

```lua
function GuiDataSource:setItem(index, value, needsNotification)
    if index > 0 and index < = # self.data then
        self.data[index] = value
        if needsNotification then
            self:notifyChange()
        end
    end
end

```