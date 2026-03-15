## ColorPickButtonElement

**Description**

> Clickable button element with one or two colors inside and a special selection design

**Parent**

> [ButtonElement](?version=script&category=43&class=434)

**Functions**

- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [onGuiSetupFinished](#onguisetupfinished)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function ColorPickButtonElement:copyAttributes(src)
    ColorPickButtonElement:superClass().copyAttributes( self , src)

    self.selectionFrameThickness = table.clone(src.selectionFrameThickness)
    self.selectionFrameColor = table.clone(src.selectionFrameColor)

    self.material = src.material
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function ColorPickButtonElement:delete()
    self.glossyIcon:delete()
    self.metallicIcon:delete()
    self.matteIcon:delete()

    ColorPickButtonElement:superClass().delete( self )
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
function ColorPickButtonElement:draw(clipX1, clipY1, clipX2, clipY2)
    local posX1 = GuiUtils.alignValueToScreenPixels( self.absPosition[ 1 ], true )
    local posY1 = GuiUtils.alignValueToScreenPixels( self.absPosition[ 2 ], true )

    local width = GuiUtils.alignValueToScreenPixels( self.absSize[ 1 ], true )
    local height = GuiUtils.alignValueToScreenPixels( self.absSize[ 2 ], false )

    if self:getIsSelected() or self:getIsFocused() then
        local selectedX = posX1 + 7 * g_pixelSizeScaledX
        local selectedY = posY1 + 7 * g_pixelSizeScaledY
        GuiOverlay.renderOverlay( self.overlay, selectedX, selectedY, width - 14 * g_pixelSizeScaledX, height - 14 * g_pixelSizeScaledY, self:getOverlayState(), clipX1, clipY1, clipX2, clipY2)

        local r, g, b, a = unpack( self.selectionFrameColor)
        drawFilledRect(posX1, posY1, width, self.selectionFrameThickness[ 2 ], r, g, b, a, clipX1, clipY1, clipX2, clipY2)
        drawFilledRect(posX1, posY1 + height - self.selectionFrameThickness[ 2 ], width, self.selectionFrameThickness[ 2 ], r, g, b, a, clipX1, clipY1, clipX2, clipY2)

        drawFilledRect(posX1, posY1, self.selectionFrameThickness[ 1 ], height, r, g, b, a, clipX1, clipY1, clipX2, clipY2)
        drawFilledRect(posX1 + width - self.selectionFrameThickness[ 1 ], posY1, self.selectionFrameThickness[ 1 ], height, r, g, b, a, clipX1, clipY1, clipX2, clipY2)
    else
            GuiOverlay.renderOverlay( self.overlay, posX1, posY1, width, height, self:getOverlayState(), clipX1, clipY1, clipX2, clipY2)
        end

        if self.debugEnabled or g_uiDebugEnabled then
            local posX2 = GuiUtils.alignValueToScreenPixels( self.absPosition[ 1 ] + self.absSize[ 1 ] - g_pixelSizeX, false )
            local posY2 = GuiUtils.alignValueToScreenPixels( self.absPosition[ 2 ] + self.absSize[ 2 ] - g_pixelSizeY, false )

            drawFilledRect(posX1, posY1, posX2 - posX1, g_pixelSizeY, 0 , 1 , 0 , 0.7 )
            drawFilledRect(posX1, posY2, posX2 - posX1, g_pixelSizeY, 0 , 1 , 0 , 0.7 )
            drawFilledRect(posX1, posY1, g_pixelSizeX, posY2 - posY1, 0 , 1 , 0 , 0.7 )
            drawFilledRect(posX1 + posX2 - posX1, posY1, g_pixelSizeX, posY2 - posY1, 0 , 1 , 0 , 0.7 )
        end

        if self.material = = ColorPickerDialog.MATERIAL_GLOSSY then
            self.glossyIcon:render(clipX1, clipY1, clipX2, clipY2, 1 )
        elseif self.material = = ColorPickerDialog.MATERIAL_METALLIC then
                self.metallicIcon:render(clipX1, clipY1, clipX2, clipY2)
            elseif self.material = = ColorPickerDialog.MATERIAL_MATTE then
                    self.matteIcon:render(clipX1, clipY1, clipX2, clipY2)
                end
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
function ColorPickButtonElement:loadFromXML(xmlFile, key)
    ColorPickButtonElement:superClass().loadFromXML( self , xmlFile, key)

    -- create second overlay for the second color.
        self.selectionFrameThickness = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#selectionFrameThickness" ), self.selectionFrameThickness)
        self.selectionFrameColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#selectionFrameColor" ), self.selectionFrameColor)
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
function ColorPickButtonElement:loadProfile(profile, applyProfile)
    ColorPickButtonElement:superClass().loadProfile( self , profile, applyProfile)

    self.selectionFrameThickness = GuiUtils.getNormalizedScreenValues(profile:getValue( "selectionFrameThickness" ), self.selectionFrameThickness)
    self.selectionFrameColor = GuiUtils.getColorArray(profile:getValue( "selectionFrameColor" ), self.selectionFrameColor)
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
function ColorPickButtonElement.new(target, custom_mt)
    local self = ColorPickButtonElement:superClass().new(target, custom_mt or ColorPickButtonElement _mt)

    self.selectionFrameThickness = { 0 , 0 }
    self.selectionFrameColor = { 1 , 1 , 1 , 1 }

    self.material = ColorPickerDialog.MATERIAL_GLOSSY

    self.glossyIcon = g_overlayManager:createOverlay( "gui.glossyBig" )
    self.glossyIcon:setScale( ColorPickButtonElement.ICON_SCALE, ColorPickButtonElement.ICON_SCALE)

    self.metallicIcon = g_overlayManager:createOverlay( "gui.metallicBig" )
    self.metallicIcon:setScale( ColorPickButtonElement.ICON_SCALE, ColorPickButtonElement.ICON_SCALE)

    self.matteIcon = g_overlayManager:createOverlay( "gui.matteBig" )
    self.matteIcon:setScale( ColorPickButtonElement.ICON_SCALE, ColorPickButtonElement.ICON_SCALE)

    return self
end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function ColorPickButtonElement:onGuiSetupFinished()
    ColorPickButtonElement:superClass().onGuiSetupFinished( self )

    local color = GuiOverlay.getOverlayColor( self.overlay, GuiOverlay.STATE_NORMAL)
    color[ 1 ] = 1
    color[ 2 ] = 1
    color[ 3 ] = 1
    color[ 4 ] = 1

    color = GuiOverlay.getOverlayColor( self.overlay, GuiOverlay.STATE_HIGHLIGHTED)
    color[ 1 ] = 1
    color[ 2 ] = 1
    color[ 3 ] = 1
    color[ 4 ] = 0.5

    color = GuiOverlay.getOverlayColor( self.overlay, GuiOverlay.STATE_SELECTED)
    color[ 1 ] = 1
    color[ 2 ] = 1
    color[ 3 ] = 1
    color[ 4 ] = 1

    color = GuiOverlay.getOverlayColor( self.overlay, GuiOverlay.STATE_FOCUSED)
    color[ 1 ] = 1
    color[ 2 ] = 1
    color[ 3 ] = 1
    color[ 4 ] = 1

    color = GuiOverlay.getOverlayColor( self.overlay, GuiOverlay.STATE_DISABLED)
    color[ 1 ] = 1
    color[ 2 ] = 1
    color[ 3 ] = 1
    color[ 4 ] = 1
end

```