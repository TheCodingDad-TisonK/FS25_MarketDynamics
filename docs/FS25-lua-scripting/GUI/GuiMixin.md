## GuiMixin

**Description**

> GuiElement mixin base class.
> Implements base functionality for GUI element mixins. All other GUI mixins should be descendants of this class.

**Functions**

- [addTo](#addto)
- [clone](#clone)
- [cloneMixin](#clonemixin)
- [hasIncluded](#hasincluded)
- [new](#new)

### addTo

**Description**

> Add a mixin to a GuiElement.
> Adds mixin methods to the element which can then be used. A mixin's state is located in "element[mixinType]".

**Definition**

> addTo()

**Arguments**

| any | guiElement |
|-----|------------|

**Code**

```lua
function GuiMixin:addTo(guiElement)
    if not guiElement[ self.mixinType] then
        guiElement[ self.mixinType] = self
        guiElement.hasIncluded = self.hasIncluded

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
function GuiMixin:clone(srcGuiElement, dstGuiElement)
    -- implement in subclasses to copy mixin state between decorated GuiElement instances
end

```

### cloneMixin

**Description**

> Clone mixin states for a mixin type from a source to a destination GuiElement instance.

**Definition**

> cloneMixin()

**Arguments**

| any | mixinType     |
|-----|---------------|
| any | srcGuiElement |
| any | dstGuiElement |

**Code**

```lua
function GuiMixin.cloneMixin(mixinType, srcGuiElement, dstGuiElement)
    mixinType:clone(srcGuiElement, dstGuiElement)
end

```

### hasIncluded

**Description**

> Determine if a GuiElement has a mixin type included.

**Definition**

> hasIncluded(guiElement GuiElement, mixinType GuiMixin)

**Arguments**

| guiElement | GuiElement | instance        |
|------------|------------|-----------------|
| mixinType  | GuiMixin   | class reference |

**Code**

```lua
function GuiMixin.hasIncluded(guiElement, mixinType)
    return guiElement[mixinType] ~ = nil
end

```

### new

**Description**

> Create a new GuiMixin instance.
> Subclasses need to provide their class type table for identification.

**Definition**

> new(class Class, mixinType Class)

**Arguments**

| class     | Class | metatable  |
|-----------|-------|------------|
| mixinType | Class | type table |

**Return Values**

| mixinType | instance |
|-----------|----------|

**Code**

```lua
function GuiMixin.new(class, mixinType)
    if class = = nil then
        class = GuiMixin _mt
    end

    if mixinType = = nil then
        mixinType = GuiMixin
    end

    local self = setmetatable( { } , class)
    self.mixinType = mixinType

    return self
end

```