## TextBackdropElement

**Description**

> Element that sizes depending on the size of its child text element

**Parent**

> [BitmapElement](?version=script&category=43&class=502)

**Functions**

- [copyAttributes](#copyattributes)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
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
function TextBackdropElement:copyAttributes(src)
    TextBackdropElement:superClass().copyAttributes( self , src)

    self.padding = table.clone(src.padding)
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
function TextBackdropElement:loadFromXML(xmlFile, key)
    TextBackdropElement:superClass().loadFromXML( self , xmlFile, key)

    self.padding = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#padding" ), self.padding)
end

```

### loadProfile

**Description**

**Definition**

> loadProfile()

**Arguments**

| any | profile      |
|-----|--------------|
| any | applyProfile |

**Code**

```lua
function TextBackdropElement:loadProfile(profile, applyProfile)
    TextBackdropElement:superClass().loadProfile( self , profile, applyProfile)

    self.padding = GuiUtils.getNormalizedScreenValues(profile:getValue( "padding" ), self.padding)
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
function TextBackdropElement.new(target, custom_mt)
    local self = BitmapElement.new(target, custom_mt or TextBackdropElement _mt)

    self.padding = { 0 , 0 , 0 , 0 } -- left, top, right, bottom

    return self
end

```