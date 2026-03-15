## BitmapElement

**Description**

> Display element for images.
> Used layers: "image" for the display image.

**Parent**

> [GuiElement](?version=script&category=43&class=427)

**Functions**

- [canReceiveFocus](#canreceivefocus)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [getFocusTarget](#getfocustarget)
- [getOffset](#getoffset)
- [getOverlayMaskData](#getoverlaymaskdata)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setAlpha](#setalpha)
- [setImageColor](#setimagecolor)
- [setImageFilename](#setimagefilename)
- [setImageRotation](#setimagerotation)
- [setImageSlice](#setimageslice)
- [setImageUVs](#setimageuvs)
- [setIsWebOverlay](#setisweboverlay)

### canReceiveFocus

**Description**

**Definition**

> canReceiveFocus()

**Code**

```lua
function BitmapElement:canReceiveFocus()
    -- if not visible, or no focusable elements:cannot receive focus
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
function BitmapElement:copyAttributes(src)
    BitmapElement:superClass().copyAttributes( self , src)

    self.imageSize = table.clone(src.imageSize)
    GuiOverlay.copyOverlay( self.overlay, src.overlay)
    self.offset = table.clone(src.offset)

    if src.focusedOffset ~ = nil then
        self.focusedOffset = table.clone(src.focusedOffset)
    end
    if src.selectedOffset ~ = nil then
        self.selectedOffset = table.clone(src.selectedOffset)
    end
    if src.highlightedOffset ~ = nil then
        self.highlightedOffset = table.clone(src.highlightedOffset)
    end
    if src.pressedOffset ~ = nil then
        self.pressedOffset = table.clone(src.pressedOffset)
    end

    self.overlayMaskPos = src.overlayMaskPos
    self.overlayMaskSize = src.overlayMaskSize

    self.invertX = src.invertX
    self.invertY = src.invertY
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function BitmapElement:delete()
    GuiOverlay.deleteOverlay( self.overlay)

    BitmapElement:superClass().delete( self )
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
function BitmapElement:draw(clipX1, clipY1, clipX2, clipY2)
    local xOffset, yOffset = self:getOffset()
    local overlayMaskPosX, overlayMaskPosY, overlayMaskSizeX, overlayMaskSizeY = self:getOverlayMaskData(xOffset, yOffset)

    GuiOverlay.renderOverlay( self.overlay, self.absPosition[ 1 ] + xOffset, self.absPosition[ 2 ] + yOffset, self.absSize[ 1 ], self.absSize[ 2 ], self:getOverlayState(),
    clipX1, clipY1, clipX2, clipY2, overlayMaskPosX, overlayMaskPosY, overlayMaskSizeX, overlayMaskSizeY)

    BitmapElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
end

```

### getFocusTarget

**Description**

**Definition**

> getFocusTarget()

**Code**

```lua
function BitmapElement:getFocusTarget()
    if # self.elements > 0 then
        local _, firstElement = next( self.elements)
        if firstElement then
            return firstElement
        end
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
function BitmapElement:getOffset()
    local state = self:getOverlayState()
    local xOffset, yOffset = self.offset[ 1 ], self.offset[ 2 ]

    if state = = GuiOverlay.STATE_FOCUSED and self.focusedOffset ~ = nil then
        xOffset = self.focusedOffset[ 1 ]
        yOffset = self.focusedOffset[ 2 ]
    elseif state = = GuiOverlay.STATE_SELECTED and self.selectedOffset ~ = nil then
            xOffset = self.selectedOffset[ 1 ]
            yOffset = self.selectedOffset[ 2 ]
        elseif state = = GuiOverlay.STATE_HIGHLIGHTED and self.highlightedOffset ~ = nil then
                xOffset = self.highlightedOffset[ 1 ]
                yOffset = self.highlightedOffset[ 2 ]
            elseif state = = GuiOverlay.STATE_PRESSED and self.pressedOffset ~ = nil then
                    xOffset = self.pressedOffset[ 1 ]
                    yOffset = self.pressedOffset[ 2 ]
                end

                return xOffset, yOffset
            end

```

### getOverlayMaskData

**Description**

**Definition**

> getOverlayMaskData()

**Arguments**

| any | xOffset |
|-----|---------|
| any | yOffset |

**Code**

```lua
function BitmapElement:getOverlayMaskData(xOffset, yOffset)
    local overlayMaskPosX = self.overlayMaskPos ~ = nil and self.overlayMaskPos[ 1 ] or nil
    local overlayMaskPosY = self.overlayMaskPos ~ = nil and self.overlayMaskPos[ 2 ] or nil
    local overlayMaskSizeX = self.overlayMaskSize ~ = nil and self.overlayMaskSize[ 1 ] or nil
    local overlayMaskSizeY = self.overlayMaskSize ~ = nil and self.overlayMaskSize[ 2 ] or nil

    return overlayMaskPosX, overlayMaskPosY, overlayMaskSizeX, overlayMaskSizeY
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
function BitmapElement:loadFromXML(xmlFile, key)
    BitmapElement:superClass().loadFromXML( self , xmlFile, key)

    self.imageSize = string.getVector(getXMLString(xmlFile, key .. "#imageSize" ), 2 ) or self.imageSize

    GuiOverlay.loadOverlay( self , self.overlay, "image" , self.imageSize, nil , xmlFile, key)
    self.offset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#offset" ), self.offset)
    self.focusedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#focusedOffset" ), self.focusedOffset)
    self.selectedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#selectedOffset" ), self.selectedOffset)
    self.highlightedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#highlightedOffset" ), self.highlightedOffset)
    self.pressedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#pressedOffset" ), self.pressedOffset)

    self.invertX = Utils.getNoNil(getXMLBool(xmlFile, key .. "#invertX" ), self.invertX)
    self.invertY = Utils.getNoNil(getXMLBool(xmlFile, key .. "#invert>" ), self.invertY)

    self.overlayMaskPos = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#overlayMaskPos" )) or self.overlayMaskPos
    self.overlayMaskSize = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#overlayMaskSize" )) or self.overlayMaskSize

    GuiOverlay.createOverlay( self.overlay)
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
function BitmapElement:loadProfile(profile, applyProfile)
    BitmapElement:superClass().loadProfile( self , profile, applyProfile)

    self.imageSize = string.getVector(profile:getValue( "imageSize" ), 2 ) or self.imageSize

    local oldFilename = self.overlay.filename
    local oldPreviewFilename = self.overlay.previewFilename
    GuiOverlay.loadOverlay( self , self.overlay, "image" , self.imageSize, profile, nil , nil )
    self.offset = GuiUtils.getNormalizedScreenValues(profile:getValue( "offset" ), self.offset)
    self.focusedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "focusedOffset" ), self.focusedOffset)
    self.selectedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "selectedOffset" ), self.selectedOffset)
    self.highlightedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "highlightedOffset" ), self.highlightedOffset)
    self.pressedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "pressedOffset" ), self.pressedOffset)

    self.invertX = profile:getBool( "invertX" , self.invertX)
    self.invertY = profile:getBool( "invertY" , self.invertY)

    self.overlayMaskPos = GuiUtils.getNormalizedScreenValues(profile:getValue( "overlayMaskPos" )) or self.overlayMaskPos
    self.overlayMaskSize = GuiUtils.getNormalizedScreenValues(profile:getValue( "overlayMaskSize" )) or self.overlayMaskSize

    if oldFilename ~ = self.overlay.filename or oldPreviewFilename ~ = self.overlay.previewFilename then
        GuiOverlay.deleteOverlay( self.overlay)
        GuiOverlay.createOverlay( self.overlay)
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
function BitmapElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or BitmapElement _mt)

    self.imageSize = { 2048 , 2048 }
    self.offset = { 0 , 0 }
    self.overlay = { }

    self.overlayMaskSize = nil
    self.overlayMaskPos = nil

    return self
end

```

### setAlpha

**Description**

> Set image alpha

**Definition**

> setAlpha()

**Arguments**

| any | alpha |
|-----|-------|

**Code**

```lua
function BitmapElement:setAlpha(alpha)
    BitmapElement:superClass().setAlpha( self , alpha)
    if self.overlay ~ = nil then
        self.overlay.alpha = self.alpha
    end
end

```

### setImageColor

**Description**

> Set this element's image color.
> Omitted (nil value) color values have no effect and the previously set value for that channel is used.

**Definition**

> setImageColor(state GuiOverlay, float r, float g, float b, float a)

**Arguments**

| state | GuiOverlay | state for which the color is changed, use nil to set the default color |
|-------|------------|------------------------------------------------------------------------|
| float | r          | Red color value                                                        |
| float | g          | Green color value                                                      |
| float | b          | Blue color value                                                       |
| float | a          | Alpha value (transparency)                                             |

**Code**

```lua
function BitmapElement:setImageColor(state, r, g, b, a)
    local color = GuiOverlay.getOverlayColor( self.overlay, state)
    color[ 1 ] = r or color[ 1 ]
    color[ 2 ] = g or color[ 2 ]
    color[ 3 ] = b or color[ 3 ]
    color[ 4 ] = a or color[ 4 ]
end

```

### setImageFilename

**Description**

> Set the image filename

**Definition**

> setImageFilename()

**Arguments**

| any | filename |
|-----|----------|

**Code**

```lua
function BitmapElement:setImageFilename(filename)
    self.overlay = GuiOverlay.createOverlay( self.overlay, filename)
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
function BitmapElement:setImageRotation(rotation)
    self.overlay.rotation = rotation
end

```

### setImageSlice

**Description**

> Set this element's image UVs via a given slice id

**Definition**

> setImageSlice(string sliceId, )

**Arguments**

| string | sliceId | id of the slice to be used |
|--------|---------|----------------------------|
| any    | sliceId |                            |

**Code**

```lua
function BitmapElement:setImageSlice(state, sliceId)
    local slice = g_overlayManager:getSliceInfoById(sliceId)

    if slice = = nil then
        return
    end

    self:setImageUVs(state, unpack(slice.uvs))
    self:setImageFilename(slice.filename)

    self.overlay.sliceId = sliceId
end

```

### setImageUVs

**Description**

> Set image UVs (normalized)

**Definition**

> setImageUVs()

**Arguments**

| any | state |
|-----|-------|
| any | v0    |
| any | u0    |
| any | v1    |
| any | u1    |
| any | v2    |
| any | u2    |
| any | v3    |
| any | u3    |

**Code**

```lua
function BitmapElement:setImageUVs(state, v0, u0, v1, u1, v2, u2, v3, u3)
    state = Utils.getNoNil(state, self:getOverlayState())
    local uvs = GuiOverlay.getOverlayUVs( self.overlay, state)

    uvs[ 1 ] = v0 or uvs[ 1 ]
    uvs[ 2 ] = u0 or uvs[ 2 ]
    uvs[ 3 ] = v1 or uvs[ 3 ]
    uvs[ 4 ] = u1 or uvs[ 4 ]
    uvs[ 5 ] = v2 or uvs[ 5 ]
    uvs[ 6 ] = u2 or uvs[ 6 ]
    uvs[ 7 ] = v3 or uvs[ 7 ]
    uvs[ 8 ] = u3 or uvs[ 8 ]

    if self.invertX then
        GuiUtils.invertUVs(uvs, true )
    end
    if self.invertY then
        GuiUtils.invertUVs(uvs, false )
    end
end

```

### setIsWebOverlay

**Description**

**Definition**

> setIsWebOverlay()

**Arguments**

| any | isWebOverlay |
|-----|--------------|

**Code**

```lua
function BitmapElement:setIsWebOverlay(isWebOverlay)
    self.overlay.isWebOverlay = isWebOverlay
end

```