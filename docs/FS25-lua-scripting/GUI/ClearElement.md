## ClearElement

**Description**

> Display element for images.
> Used layers: "image" for the display image.

**Parent**

> [GuiElement](?version=script&category=43&class=433)

**Functions**

- [canReceiveFocus](#canreceivefocus)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [getFocusTarget](#getfocustarget)
- [getOffset](#getoffset)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setImageRotation](#setimagerotation)

### canReceiveFocus

**Description**

**Definition**

> canReceiveFocus()

**Code**

```lua
function ClearElement:canReceiveFocus()
    if not self.visible or # self.elements < 1 then
        return false
    end
    -- element can only receive focus if all sub elements are ready to receive focus
        for _, v in ipairs( self.elements) do
            if ( not v:canReceiveFocus()) then
                return false
            end
        end
        return true
    end

```

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function ClearElement:copyAttributes(src)
    ClearElement:superClass().copyAttributes( self , src)

    GuiOverlay.copyOverlay( self.overlay, src.overlay)
    self.offset = table.clone(src.offset)
    self.focusedOffset = table.clone(src.focusedOffset)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function ClearElement:delete()
    GuiOverlay.deleteOverlay( self.overlay)

    ClearElement:superClass().delete( self )
end

```

### draw

**Description**

**Definition**

> draw()

**Arguments**

| any | clipX1 |
|-----|--------|
| any | clipY1 |
| any | clipX2 |
| any | clipY2 |

**Code**

```lua
function ClearElement:draw(clipX1, clipY1, clipX2, clipY2)
    local xOffset, yOffset = self:getOffset()

    clearOverlayArea( self.absPosition[ 1 ] + xOffset, self.absPosition[ 2 ] + yOffset, self.size[ 1 ], self.size[ 2 ], self.overlay.rotation, self.size[ 1 ] / 2 , self.size[ 2 ] / 2 )

    ClearElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
end

```

### getFocusTarget

**Description**

**Definition**

> getFocusTarget()

**Code**

```lua
function ClearElement:getFocusTarget()
    local _, firstElement = next( self.elements)
    if firstElement then
        return firstElement
    end
    return self
end

```

### getOffset

**Description**

**Definition**

> getOffset()

**Code**

```lua
function ClearElement:getOffset()
    local xOffset, yOffset = self.offset[ 1 ], self.offset[ 2 ]
    local state = self:getOverlayState()
    if state = = GuiOverlay.STATE_FOCUSED or state = = GuiOverlay.STATE_PRESSED or state = = GuiOverlay.STATE_SELECTED or GuiOverlay.STATE_HIGHLIGHTED then
        xOffset = self.focusedOffset[ 1 ]
        yOffset = self.focusedOffset[ 2 ]
    end
    return xOffset, yOffset
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
function ClearElement:loadFromXML(xmlFile, key)
    ClearElement:superClass().loadFromXML( self , xmlFile, key)

    GuiOverlay.loadOverlay( self , self.overlay, "clear" , self.imageSize, nil , xmlFile, key)
    self.offset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#offset" ), self.offset)
    self.focusedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#focusedOffset" ), self.focusedOffset)
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
function ClearElement:loadProfile(profile, applyProfile)
    ClearElement:superClass().loadProfile( self , profile, applyProfile)

    GuiOverlay.loadOverlay( self , self.overlay, "clear" , self.imageSize, profile, nil , nil )
    self.offset = GuiUtils.getNormalizedScreenValues(profile:getValue( "offset" ), self.offset)
    self.focusedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "focusedOffset" ), { self.offset[ 1 ], self.offset[ 2 ] } )
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
function ClearElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or BitmapElement _mt)

    self.offset = { 0 , 0 }
    self.focusedOffset = { 0 , 0 }
    self.overlay = { }
    return self
end

```

### setImageRotation

**Description**

> Set this element's image overlay's rotation.

**Definition**

> setImageRotation(float rotation)

**Arguments**

| float | rotation | Rotation in radians |
|-------|----------|---------------------|

**Code**

```lua
function ClearElement:setImageRotation(rotation)
    self.overlay.rotation = rotation
end

```