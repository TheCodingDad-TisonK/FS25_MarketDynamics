## DynamicFadedBitmapElement

**Description**

> Bitmap that has a list of images it fades between over time

**Parent**

> [PictureElement](?version=script&category=43&class=437)

**Functions**

- [canReceiveFocus](#canreceivefocus)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [getFocusTarget](#getfocustarget)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setAlpha](#setalpha)
- [setImageFilenames](#setimagefilenames)
- [setImagesUVs](#setimagesuvs)

### canReceiveFocus

**Description**

**Definition**

> canReceiveFocus()

**Code**

```lua
function DynamicFadedBitmapElement:canReceiveFocus()
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
function DynamicFadedBitmapElement:copyAttributes(src)
    DynamicFadedBitmapElement:superClass().copyAttributes( self , src)

    GuiOverlay.copyOverlay( self.templateOverlay, src.templateOverlay)
    self.filenames = table.clone(src.filenames)

    self.fadeTime = src.fadeTime
    self.fadeInterval = src.fadeInterval

    self:buildOverlays()
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function DynamicFadedBitmapElement:delete()
    for _, overlay in ipairs( self.overlays) do
        GuiOverlay.deleteOverlay(overlay)
    end
    GuiOverlay.deleteOverlay( self.templateOverlay)

    DynamicFadedBitmapElement:superClass().delete( self )
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
function DynamicFadedBitmapElement:draw(clipX1, clipY1, clipX2, clipY2)
    local x, y, w, h = self:getAdjustedPosition()
    local state = self:getOverlayState()

    local primaryIndex = self.currentImageIndex
    local secondaryIndex = (primaryIndex % # self.filenames) + 1

    local alpha = MathUtil.smoothstep( 1 - ( self.fadeTime / self.fadeInterval), 1 , self.fadeAlpha)
    local primaryFade = 1
    local secondaryFade = alpha -- crossfade

    self.overlays[primaryIndex].color[ 4 ] = primaryFade * self.alpha
    GuiOverlay.renderOverlay( self.overlays[primaryIndex], x, y, w, h, state, clipX1, clipY1, clipX2, clipY2)

    if alpha > 0 then
        self.overlays[secondaryIndex].color[ 4 ] = secondaryFade * self.alpha
        GuiOverlay.renderOverlay( self.overlays[secondaryIndex], x, y, w, h, state, clipX1, clipY1, clipX2, clipY2)
    end
end

```

### getFocusTarget

**Description**

**Definition**

> getFocusTarget()

**Code**

```lua
function DynamicFadedBitmapElement:getFocusTarget()
    if # self.elements > 0 then
        local _, firstElement = next( self.elements)
        if firstElement then
            return firstElement
        end
    end
    return self
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
function DynamicFadedBitmapElement:loadFromXML(xmlFile, key)
    DynamicFadedBitmapElement:superClass().loadFromXML( self , xmlFile, key)

    self.fadeTime = getXMLInt(xmlFile, key .. "#fadeTime" ) or self.fadeTime
    self.fadeInterval = getXMLInt(xmlFile, key .. "#fadeInterval" ) or self.fadeInterval

    GuiOverlay.loadOverlay( self , self.templateOverlay, "image" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.createOverlay( self.templateOverlay)
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
function DynamicFadedBitmapElement:loadProfile(profile, applyProfile)
    DynamicFadedBitmapElement:superClass().loadProfile( self , profile, applyProfile)

    self.fadeTime = profile:getNumber( "fadeTime" , self.fadeTime)
    self.fadeInterval = profile:getNumber( "fadeInterval" , self.fadeInterval)

    local oldFilename = self.templateOverlay.filename
    local oldPreviewFilename = self.templateOverlay.previewFilename
    GuiOverlay.loadOverlay( self , self.templateOverlay, "image" , self.imageSize, profile, nil , nil )
    if oldFilename ~ = self.templateOverlay.filename or oldPreviewFilename ~ = self.templateOverlay.previewFilename then
        GuiOverlay.createOverlay( self.templateOverlay)
    end

    local filenameList = profile:getValue( "imageFilenames" )
    if filenameList ~ = nil then
        self.filenames = filenameList:split( ";" )
        self:buildOverlays()
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
function DynamicFadedBitmapElement.new(target, custom_mt)
    local self = DynamicFadedBitmapElement:superClass().new(target, custom_mt or DynamicFadedBitmapElement _mt)

    self.templateOverlay = { }
    self.fadeTime = 2500
    self.fadeInterval = 10000

    self.alpha = 1
    self.filenames = { }
    self.overlays = { }

    self.currentImageIndex = 1
    self.fadeAlpha = 0

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
function DynamicFadedBitmapElement:setAlpha(alpha)
    DynamicFadedBitmapElement:superClass().setAlpha( self , alpha)
    self.alpha = alpha
end

```

### setImageFilenames

**Description**

> Set the image filename

**Definition**

> setImageFilenames()

**Arguments**

| any | filenames |
|-----|-----------|

**Code**

```lua
function DynamicFadedBitmapElement:setImageFilenames(filenames)
    self.filenames = filenames
    self:buildOverlays()
end

```

### setImagesUVs

**Description**

> Set the image uvs

**Definition**

> setImagesUVs()

**Arguments**

| any | uvs |
|-----|-----|

**Code**

```lua
function DynamicFadedBitmapElement:setImagesUVs(uvs)
    self.uvs = uvs
    self:buildOverlays()
end

```