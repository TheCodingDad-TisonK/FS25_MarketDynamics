## FrameReferenceElement

**Description**

> Reference to a named frame to be displayed.
> The reference will be resolved on loading and this element will be removed if the resolution succeeds.

**Parent**

> [GuiElement](?version=script&category=43&class=440)

**Functions**

- [copyAttributes](#copyattributes)
- [loadFromXML](#loadfromxml)
- [new](#new)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function FrameReferenceElement:copyAttributes(src)
    FrameReferenceElement:superClass().copyAttributes( self , src)
    self.referencedFrameName = src.referencedFrameName
end

```

### loadFromXML

**Description**

**Definition**

> loadFromXML()

**Arguments**

| any | xmlFile |
|-----|---------|
| any | key     |

**Code**

```lua
function FrameReferenceElement:loadFromXML(xmlFile, key)
    FrameReferenceElement:superClass().loadFromXML( self , xmlFile, key)

    self.referencedFrameName = getXMLString(xmlFile, key .. "#ref" ) or ""
end

```

### new

**Description**

**Definition**

> new()

**Arguments**

| any | target    |
|-----|-----------|
| any | custom_mt |

**Code**

```lua
function FrameReferenceElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or FrameReferenceElement _mt)

    self.referencedFrameName = ""

    return self
end

```