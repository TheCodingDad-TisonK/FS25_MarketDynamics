## Overlay

**Description**

> Image display overlay.
> This class is used to display textures or usually parts thereof as rectangular panels in the UI or on the HUD.
> Example usages include button icons, showing images in the main menu or drawing the in-game map.

**Functions**

- [delete](#delete)
- [getIsVisible](#getisvisible)
- [getPosition](#getposition)
- [getScale](#getscale)
- [new](#new)
- [render](#render)
- [resetDimensions](#resetdimensions)
- [setAlignment](#setalignment)
- [setColor](#setcolor)
- [setDimension](#setdimension)
- [setImage](#setimage)
- [setInvertX](#setinvertx)
- [setIsVisible](#setisvisible)
- [setPosition](#setposition)
- [setRotation](#setrotation)
- [setScale](#setscale)
- [setSliceId](#setsliceid)
- [setUVs](#setuvs)

### delete

**Description**

> Delete this overlay.
> Releases the texture file handle.

**Definition**

> delete()

**Code**

```lua
function Overlay:delete()
    if self.overlayId ~ = 0 then
        delete( self.overlayId)
    end
end

```

### getIsVisible

**Description**

> Get this overlay's visibility.

**Definition**

> getIsVisible()

**Return Values**

| any | isVisible |
|-----|-----------|

**Code**

```lua
function Overlay:getIsVisible()
    return self.visible
end

```

### getPosition

**Description**

> Get this overlay's position.

**Definition**

> getPosition()

**Return Values**

| any | X | position in screen space |
|-----|---|--------------------------|
| any | Y | position in screen space |

**Code**

```lua
function Overlay:getPosition()
    return self.x, self.y
end

```

### getScale

**Description**

> Get this overlay's scale values.

**Definition**

> getScale()

**Return Values**

| any | Width  | scale factor |
|-----|--------|--------------|
| any | Height | scale factor |

**Code**

```lua
function Overlay:getScale()
    return self.scaleWidth, self.scaleHeight
end

```

### new

**Description**

> Create a new Overlay.

**Definition**

> new(string? overlayFilename, float x, float y, float width, float height, table? customMt)

**Arguments**

| string? | overlayFilename | File path of the source texture |
|---------|-----------------|---------------------------------|
| float   | x               | Screen position x               |
| float   | y               | Screen position y               |
| float   | width           | Display width                   |
| float   | height          | Display height                  |
| table?  | customMt        |                                 |

**Return Values**

| table? | self |
|--------|------|

**Code**

```lua
function Overlay.new(overlayFilename, x, y, width, height, customMt)
    local overlayId = 0
    if overlayFilename ~ = nil then
        overlayId = createImageOverlay(overlayFilename)
    end

    local self = setmetatable( { } , customMt or Overlay _mt)

    self.overlayId = overlayId
    self.filename = overlayFilename
    self.uvs = table.clone( Overlay.DEFAULT_UVS)

    self.x = x
    self.y = y
    self.offsetX = 0
    self.offsetY = 0

    self.defaultWidth = width
    self.width = width
    self.defaultHeight = height
    self.height = height

    self.scaleWidth = 1.0
    self.scaleHeight = 1.0

    self.visible = true

    self.alignmentVertical = Overlay.ALIGN_VERTICAL_BOTTOM
    self.alignmentHorizontal = Overlay.ALIGN_HORIZONTAL_LEFT

    self.invertX = false
    self.rotation = 0
    self.rotationCenterX = 0
    self.rotationCenterY = 0

    self.r = 1.0
    self.g = 1.0
    self.b = 1.0
    self.a = 1.0

    self.debugEnabled = nil

    return self
end

```

### render

**Description**

> Render this overlay.

**Definition**

> render(float? clipX1, float? clipY1, float? clipX2, float? clipY2)

**Arguments**

| float? | clipX1 |
|--------|--------|
| float? | clipY1 |
| float? | clipX2 |
| float? | clipY2 |

**Code**

```lua
function Overlay:render(clipX1, clipY1, clipX2, clipY2)
    if self.visible then
        if self.overlayId ~ = 0 and self.a > 0 then
            local posX, posY = self.x + self.offsetX, self.y + self.offsetY
            local sizeX, sizeY = self.width, self.height

            -- Apply clipping
            if clipX1 ~ = nil then
                local u1, v1, u2, v2, u3, v3, u4, v4
                posX, posY, sizeX, sizeY, u1, v1, u2, v2, u3, v3, u4, v4 = Overlay.getClippingUVs( self.uvs, posX, posY, sizeX, sizeY, clipX1, clipY1, clipX2, clipY2)

                if sizeX = = 0 or sizeX = = nil or sizeY = = 0 or sizeY = = nil then
                    -- Cancel, no visible pixels
                    return
                end

                setOverlayUVs( self.overlayId, u1, v1, u2, v2, u3, v3, u4, v4)
            end

            renderOverlay( self.overlayId, posX, posY, sizeX, sizeY)

            if clipX1 ~ = nil then
                -- Reset to original to not affect other draw calls
                setOverlayUVs( self.overlayId, unpack( self.uvs))
            end
        end

        --#debug if self.debugEnabled or g_uiDebugEnabled then
            --#debug setOverlayColor(GuiElement.debugOverlay, 0, 0, 1, 1)

            --#debug renderOverlay(GuiElement.debugOverlay, self.x + self.offsetX - g_pixelSizeX, self.y + self.offsetY - g_pixelSizeY, self.width + 2 * g_pixelSizeX, g_pixelSizeY)
            --#debug renderOverlay(GuiElement.debugOverlay, self.x + self.offsetX - g_pixelSizeX, self.y + self.offsetY + self.height, self.width + 2 * g_pixelSizeX, g_pixelSizeY)
            --#debug renderOverlay(GuiElement.debugOverlay, self.x + self.offsetX - g_pixelSizeX, self.y + self.offsetY, g_pixelSizeX, self.height)
            --#debug renderOverlay(GuiElement.debugOverlay, self.x + self.offsetX + self.width, self.y + self.offsetY, g_pixelSizeX, self.height)

            --render Center
            --#debug setOverlayColor(GuiElement.debugOverlay, 1, 0, 0, 1)
            --#debug renderOverlay(GuiElement.debugOverlay, self.x + self.offsetX, self.y + self.offsetY, g_pixelSizeX, g_pixelSizeY)
            --#debug end
        end
    end

```

### resetDimensions

**Description**

> Reset width, height and scale to initial values set in the constructor.

**Definition**

> resetDimensions()

**Code**

```lua
function Overlay:resetDimensions()
    self.scaleWidth = 1.0
    self.scaleHeight = 1.0
    self:setDimension( self.defaultWidth, self.defaultHeight)
end

```

### setAlignment

**Description**

> Set this overlay's alignment.

**Definition**

> setAlignment(integer? vertical, integer? horizontal)

**Arguments**

| integer? | vertical   | Vertical alignment value, one of Overlay.ALIGN_VERTICAL_[...]     |
|----------|------------|-------------------------------------------------------------------|
| integer? | horizontal | Horizontal alignment value, one of Overlay.ALIGN_HORIZONTAL_[...] |

**Code**

```lua
function Overlay:setAlignment(vertical, horizontal)
    if vertical = = Overlay.ALIGN_VERTICAL_TOP then
        self.offsetY = - self.height
    elseif vertical = = Overlay.ALIGN_VERTICAL_MIDDLE then
            self.offsetY = - self.height * 0.5
        else
                self.offsetY = 0
            end
            self.alignmentVertical = vertical or Overlay.ALIGN_VERTICAL_BOTTOM

            if horizontal = = Overlay.ALIGN_HORIZONTAL_RIGHT then
                self.offsetX = - self.width
            elseif horizontal = = Overlay.ALIGN_HORIZONTAL_CENTER then
                    self.offsetX = - self.width * 0.5
                else
                        self.offsetX = 0
                    end
                    self.alignmentHorizontal = horizontal or Overlay.ALIGN_HORIZONTAL_LEFT
                end

```

### setColor

**Description**

> Set this overlay's color.
> The color is multiplied with the texture color. For no modification of the texture color, use full opaque white,
> i.e. {1, 1, 1, 1}.

**Definition**

> setColor(float? r, float? g, float? b, float? a)

**Arguments**

| float? | r | Red channel   |
|--------|---|---------------|
| float? | g | Green channel |
| float? | b | Blue channel  |
| float? | a | Alpha channel |

**Code**

```lua
function Overlay:setColor(r, g, b, a)
    r = r or self.r
    g = g or self.g
    b = b or self.b
    a = a or self.a
    if r ~ = self.r or g ~ = self.g or b ~ = self.b or a ~ = self.a then
        self.r, self.g, self.b, self.a = r, g, b, a
        if self.overlayId ~ = 0 then
            setOverlayColor( self.overlayId, self.r, self.g, self.b, self.a)
        end
    end
end

```

### setDimension

**Description**

> Set this overlay's width and height.
> Either value can be omitted (== nil) for no change.

**Definition**

> setDimension(float? width, float? height)

**Arguments**

| float? | width  | screenspace width [0..1] |
|--------|--------|--------------------------|
| float? | height | screenspace width [0..1] |

**Code**

```lua
function Overlay:setDimension(width, height)
    self.width = width or self.width
    self.height = height or self.height
    self:setAlignment( self.alignmentVertical, self.alignmentHorizontal)
end

```

### setImage

**Description**

> Set a different image for this overlay.
> The previously targeted image's handle will be released.

**Definition**

> setImage(string overlayFilename)

**Arguments**

| string | overlayFilename | File path to new target image |
|--------|-----------------|-------------------------------|

**Code**

```lua
function Overlay:setImage(overlayFilename)
    if self.filename ~ = overlayFilename then
        if self.overlayId ~ = 0 then
            delete( self.overlayId)
        end
        self.filename = overlayFilename
        self.overlayId = createImageOverlay(overlayFilename)
    end
end

```

### setInvertX

**Description**

> Set horizontal flipping state.

**Definition**

> setInvertX(boolean invertX)

**Arguments**

| boolean | invertX | If true, will set the overlay to display its image flipped horizontally |
|---------|---------|-------------------------------------------------------------------------|

**Code**

```lua
function Overlay:setInvertX(invertX)
    if self.invertX ~ = invertX then
        self.invertX = invertX
        if self.overlayId ~ = 0 then
            if invertX then
                setOverlayUVs( self.overlayId, self.uvs[ 5 ], self.uvs[ 6 ], self.uvs[ 7 ], self.uvs[ 8 ], self.uvs[ 1 ], self.uvs[ 2 ], self.uvs[ 3 ], self.uvs[ 4 ])
            else
                    setOverlayUVs( self.overlayId, unpack( self.uvs))
                end
            end
        end
    end

```

### setIsVisible

**Description**

> Set this overlay's visibility.

**Definition**

> setIsVisible(boolean? visible)

**Arguments**

| boolean? | visible |
|----------|---------|

**Code**

```lua
function Overlay:setIsVisible(visible)
    self.visible = visible
end

```

### setPosition

**Description**

> Set this overlay's position.

**Definition**

> setPosition(float? x, float? y)

**Arguments**

| float? | x | screenspace x [0..1] |
|--------|---|----------------------|
| float? | y | screenspace y [0..1] |

**Code**

```lua
function Overlay:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

```

### setRotation

**Description**

> Set this overlay's rotation.

**Definition**

> setRotation(float rotation, float centerX, float centerY)

**Arguments**

| float | rotation | Rotation in radians                                                    |
|-------|----------|------------------------------------------------------------------------|
| float | centerX  | Rotation pivot X position offset from overlay position in screen space |
| float | centerY  | Rotation pivot Y position offset from overlay position in screen space |

**Code**

```lua
function Overlay:setRotation(rotation, centerX, centerY)
    if self.rotation ~ = rotation or self.rotationCenterX ~ = centerX or self.rotationCenterY ~ = centerY then
        self.rotation = rotation
        self.rotationCenterX = centerX
        self.rotationCenterY = centerY
        if self.overlayId ~ = 0 then
            setOverlayRotation( self.overlayId, rotation, centerX, centerY)
        end
    end
end

```

### setScale

**Description**

> Set this overlay's scale.
> Multiplies the scale values with the initial dimensions and sets those as the current dimensions.

**Definition**

> setScale(float scaleWidth, float scaleHeight)

**Arguments**

| float | scaleWidth  | Width scale factor  |
|-------|-------------|---------------------|
| float | scaleHeight | Height scale factor |

**Code**

```lua
function Overlay:setScale(scaleWidth, scaleHeight)
    self.width = self.defaultWidth * scaleWidth
    self.height = self.defaultHeight * scaleHeight
    self.scaleWidth = scaleWidth
    self.scaleHeight = scaleHeight
    -- update alignment offsets
    self:setAlignment( self.alignmentVertical, self.alignmentHorizontal)
end

```

### setSliceId

**Description**

> Set this overlay's UVs which define the area to be displayed within the target texture.

**Definition**

> setSliceId(string sliceId)

**Arguments**

| string | sliceId |
|--------|---------|

**Code**

```lua
function Overlay:setSliceId(sliceId)
    if self.overlayId ~ = 0 then
        local slice = g_overlayManager:getSliceInfoById(sliceId)

        if slice ~ = nil then
            self.uvs = slice.uvs
            setOverlayUVs( self.overlayId, unpack(slice.uvs))
        end
    end
end

```

### setUVs

**Description**

> Set this overlay's UVs which define the area to be displayed within the target texture.

**Definition**

> setUVs(array uvs)

**Arguments**

| array | uvs | UV coordinates in the form of {u1, v1, u2, v2, u3, v3, u4, v4} |
|-------|-----|----------------------------------------------------------------|

**Code**

```lua
function Overlay:setUVs(uvs)
    if self.overlayId ~ = 0 then
        self.uvs = uvs
        setOverlayUVs( self.overlayId, unpack(uvs))
    end
end

```