## ThreePartBitmapElement

**Description**

> Bitmap drawing with a start-image on the left, a repeating image, and an end-image on the right.

**Parent**

> [BitmapElement](?version=script&category=43&class=505)

**Functions**

- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setImageColor](#setimagecolor)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function ThreePartBitmapElement:copyAttributes(src)
    ThreePartBitmapElement:superClass().copyAttributes( self , src)

    self.startSize = table.clone(src.startSize)
    self.endSize = table.clone(src.endSize)
    self.isHorizontal = src.isHorizontal

    GuiOverlay.copyOverlay( self.startOverlay, src.startOverlay)
    GuiOverlay.copyOverlay( self.endOverlay, src.endOverlay)
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function ThreePartBitmapElement:delete()
    GuiOverlay.deleteOverlay( self.startOverlay)
    GuiOverlay.deleteOverlay( self.endOverlay)

    ThreePartBitmapElement:superClass().delete( self )
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
function ThreePartBitmapElement:draw(clipX1, clipY1, clipX2, clipY2)
    local xOffset, yOffset = self:getOffset()

    local x = self.absPosition[ 1 ] + xOffset
    local y = self.absPosition[ 2 ] + yOffset

    local state = self:getOverlayState()
    if self.isHorizontal then
        GuiOverlay.renderOverlay( self.startOverlay, x, y, self.startSize[ 1 ], self.absSize[ 2 ], state, clipX1, clipY1, clipX2, clipY2)
        GuiOverlay.renderOverlay( self.overlay, x + self.startSize[ 1 ], y, self.absSize[ 1 ] - self.startSize[ 1 ] - self.endSize[ 1 ], self.absSize[ 2 ], state, clipX1, clipY1, clipX2, clipY2)
        GuiOverlay.renderOverlay( self.endOverlay, x + self.absSize[ 1 ] - self.endSize[ 1 ], y, self.endSize[ 1 ], self.absSize[ 2 ], state, clipX1, clipY1, clipX2, clipY2)
    else
            GuiOverlay.renderOverlay( self.startOverlay, x, y + self.absSize[ 2 ] - self.startSize[ 2 ], self.absSize[ 1 ], self.startSize[ 2 ], state, clipX1, clipY1, clipX2, clipY2)
            GuiOverlay.renderOverlay( self.overlay, x, y + self.endSize[ 2 ], self.absSize[ 1 ], self.absSize[ 2 ] - self.startSize[ 2 ] - self.endSize[ 2 ], state, clipX1, clipY1, clipX2, clipY2)
            GuiOverlay.renderOverlay( self.endOverlay, x, y, self.absSize[ 1 ], self.endSize[ 2 ], state, clipX1, clipY1, clipX2, clipY2)
        end

        -- Skip bitmap itself
        BitmapElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
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
function ThreePartBitmapElement:loadFromXML(xmlFile, key)
    ThreePartBitmapElement:superClass().loadFromXML( self , xmlFile, key)

    GuiOverlay.loadOverlay( self , self.startOverlay, "startImage" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.loadOverlay( self , self.endOverlay, "endImage" , self.imageSize, nil , xmlFile, key)

    self.startSize = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#startImageSize" ), self.startSize)
    self.endSize = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#endImageSize" ), self.endSize)

    self.isHorizontal = Utils.getNoNil(getXMLBool(xmlFile, key .. "#isHorizontal" ), self.isHorizontal)

    GuiOverlay.createOverlay( self.startOverlay)
    GuiOverlay.createOverlay( self.endOverlay)

    self:setImageColor( nil , unpack( GuiOverlay.getOverlayColor( self.overlay, GuiOverlay.STATE_NORMAL)))
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
function ThreePartBitmapElement:loadProfile(profile, applyProfile)
    ThreePartBitmapElement:superClass().loadProfile( self , profile, applyProfile)

    local startOld = self.startOverlay.filename
    local endOld = self.endOverlay.filename
    GuiOverlay.loadOverlay( self , self.startOverlay, "startImage" , self.imageSize, profile, nil , nil )
    GuiOverlay.loadOverlay( self , self.endOverlay, "endImage" , self.imageSize, profile, nil , nil )

    self.startSize = GuiUtils.getNormalizedScreenValues(profile:getValue( "startImageSize" ), self.startSize)
    self.endSize = GuiUtils.getNormalizedScreenValues(profile:getValue( "endImageSize" ), self.endSize)
    self.isHorizontal = profile:getBool( "isHorizontal" , self.isHorizontal)

    if startOld ~ = self.startOverlay.filename then
        GuiOverlay.createOverlay( self.startOverlay)
    end
    if endOld ~ = self.endOverlay.filename then
        GuiOverlay.createOverlay( self.endOverlay)
    end
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
function ThreePartBitmapElement.new(target, custom_mt)
    local self = BitmapElement.new(target, custom_mt or ThreePartBitmapElement _mt)

    self.startOverlay = { }
    self.endOverlay = { }

    self.startSize = { 0 , 0 }
    self.endSize = { 0 , 0 }
    self.isHorizontal = true

    return self
end

```

### setImageColor

**Description**

> Set this element's image color.
> Omitted (nil value) color values have no effect and the previously set value for that channel is used.

**Definition**

> setImageColor(integer state, float r, float g, float b, float a)

**Arguments**

| integer | state | GuiOverlay state for which the color is changed, use nil to set the default color |
|---------|-------|-----------------------------------------------------------------------------------|
| float   | r     | Red color value                                                                   |
| float   | g     | Green color value                                                                 |
| float   | b     | Blue color value                                                                  |
| float   | a     | Alpha value (transparency)                                                        |

**Code**

```lua
function ThreePartBitmapElement:setImageColor(state, r, g, b, a)
    ThreePartBitmapElement:superClass().setImageColor( self , state, r, g, b, a)

    local color = GuiOverlay.getOverlayColor( self.startOverlay, state)
    color[ 1 ] = r or color[ 1 ]
    color[ 2 ] = g or color[ 2 ]
    color[ 3 ] = b or color[ 3 ]
    color[ 4 ] = a or color[ 4 ]

    color = GuiOverlay.getOverlayColor( self.endOverlay, state)
    color[ 1 ] = r or color[ 1 ]
    color[ 2 ] = g or color[ 2 ]
    color[ 3 ] = b or color[ 3 ]
    color[ 4 ] = a or color[ 4 ]
end

```