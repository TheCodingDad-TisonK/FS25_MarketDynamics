## IndexChangeSubjectMixin

**Description**

> Add this mixin to a GuiElement to implement an observer pattern for index changes (e.g. paging, options, lists).

**Parent**

> [GuiMixin](?version=script&category=43&class=458)

**Functions**

- [addIndexChangeObserver](#addindexchangeobserver)
- [addTo](#addto)
- [clone](#clone)
- [new](#new)
- [notifyIndexChange](#notifyindexchange)

### addIndexChangeObserver

**Description**

> Add an index change observer with a callback.

**Definition**

> addIndexChangeObserver(guiElement Decorated, observer Observer, indexChangeCallback Function(observer,)

**Arguments**

| guiElement          | Decorated          | GuiElement instance which has received this method                                          |
|---------------------|--------------------|---------------------------------------------------------------------------------------------|
| observer            | Observer           | object instance                                                                             |
| indexChangeCallback | Function(observer, | index, count), where index is the new index and count the current number of indexable items |

**Code**

```lua
function IndexChangeSubjectMixin.addIndexChangeObserver(guiElement, observer, indexChangeCallback)
    guiElement[ IndexChangeSubjectMixin ].callbacks[observer] = indexChangeCallback
end

```

### addTo

**Description**

> See GuiMixin:addTo()

**Definition**

> addTo()

**Arguments**

| any | guiElement |
|-----|------------|

**Code**

```lua
function IndexChangeSubjectMixin:addTo(guiElement)
    if IndexChangeSubjectMixin:superClass().addTo( self , guiElement) then
        guiElement.addIndexChangeObserver = IndexChangeSubjectMixin.addIndexChangeObserver
        guiElement.notifyIndexChange = IndexChangeSubjectMixin.notifyIndexChange

        return true
    else
            return false
        end
    end

```

### clone

**Description**

> Clone this mixin's state from a source to a destination GuiElement instance.

**Definition**

> clone()

**Arguments**

| any | srcGuiElement |
|-----|---------------|
| any | dstGuiElement |

**Code**

```lua
function IndexChangeSubjectMixin:clone(srcGuiElement, dstGuiElement)
    if srcGuiElement[ IndexChangeSubjectMixin ].callbacks ~ = nil then
        dstGuiElement[ IndexChangeSubjectMixin ].callbacks = table.clone(srcGuiElement[ IndexChangeSubjectMixin ].callbacks)
    end
end

```

### new

**Description**

**Definition**

> new()

**Code**

```lua
function IndexChangeSubjectMixin.new()
    local self = GuiMixin.new(IndexableElementMixin_mt, IndexChangeSubjectMixin )
    self.callbacks = { } -- {observer = callback}

    return self
end

```

### notifyIndexChange

**Description**

> Notify observers of an index change.

**Definition**

> notifyIndexChange(guiElement Decorated, index New, count Indexable)

**Arguments**

| guiElement | Decorated | GuiElement instance which has received this method |
|------------|-----------|----------------------------------------------------|
| index      | New       | index                                              |
| count      | Indexable | item count                                         |

**Code**

```lua
function IndexChangeSubjectMixin.notifyIndexChange(guiElement, index, count)
    local callbacks = guiElement[ IndexChangeSubjectMixin ].callbacks

    for observer, callback in pairs(callbacks) do
        callback(observer, index, count)
    end
end

```