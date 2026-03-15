## HUDElement

**Description**

> Lightweight HUD UI element.
> Wraps an Overlay instance to display and provides a transform hierarchy of child HUDElement instances.

**Functions**

- [addChild](#addchild)
- [delete](#delete)
- [draw](#draw)
- [getAlpha](#getalpha)
- [getColor](#getcolor)
- [getDimension](#getdimension)
- [getHeight](#getheight)
- [getPosition](#getposition)
- [getRotationPivot](#getrotationpivot)
- [getScale](#getscale)
- [getVisible](#getvisible)
- [getWidth](#getwidth)
- [new](#new)
- [normalizeUVPivot](#normalizeuvpivot)
- [removeChild](#removechild)
- [resetDimensions](#resetdimensions)
- [scalePixelToScreenHeight](#scalepixeltoscreenheight)
- [scalePixelToScreenVector](#scalepixeltoscreenvector)
- [scalePixelToScreenWidth](#scalepixeltoscreenwidth)
- [setAlignment](#setalignment)
- [setAlpha](#setalpha)
- [setColor](#setcolor)
- [setDimension](#setdimension)
- [setImage](#setimage)
- [setPosition](#setposition)
- [setRotation](#setrotation)
- [setRotationPivot](#setrotationpivot)
- [setScale](#setscale)
- [setSliceId](#setsliceid)
- [setUVs](#setuvs)
- [setVisible](#setvisible)
- [update](#update)

### addChild

**Description**

> Add a child HUD element to this element.

**Definition**

> addChild(table childHudElement)

**Arguments**

| table | childHudElement | HUDElement instance which is added as a child. |
|-------|-----------------|------------------------------------------------|

**Code**

```lua
function HUDElement:addChild(childHudElement)
    --#debug if childHudElement.isa = = nil or not childHudElement:isa(HUDElement) then
        --#debug Logging.error("Trying to add a child to %s which is not of type 'HUDElement' but '%s'", ClassUtil.getClassNameByObject(self), ClassUtil.getClassNameByObject(childHudElement) or type(childHudElement))
        --#debug printCallstack()
        --#debug return
        --#debug end

        if childHudElement.parent = = self then
            return
        end

        if childHudElement.parent ~ = nil then
            childHudElement.parent:removeChild(childHudElement)
        end

        table.insert( self.children, childHudElement)
        childHudElement.parent = self
    end

```

### delete

**Description**

> Delete this HUD element and all its children.
> This will also delete the overlay and thus release its engine handle.

**Definition**

> delete()

**Code**

```lua
function HUDElement:delete()
    if self.overlay ~ = nil then
        self.overlay:delete()
        self.overlay = nil
    end

    if self.parent ~ = nil then
        self.parent:removeChild( self )
    end

    self.parent = nil

    for k, v in pairs( self.children) do
        v.parent = nil -- saves the call to removeChild() on delete(), see above
        v:delete()
        self.children[k] = nil
    end
end

```

### draw

**Description**

> Draw this HUD element and all of its children in order of addition.

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
function HUDElement:draw(clipX1, clipY1, clipX2, clipY2)
    if self.overlay.visible then
        self.overlay:render(clipX1, clipY1, clipX2, clipY2)

        for _, child in ipairs( self.children) do
            child:draw(clipX1, clipY1, clipX2, clipY2)
        end
    end
end

```

### getAlpha

**Description**

> Get this HUD element's color alpha value.

**Definition**

> getAlpha()

**Return Values**

| any | Alpha | value |
|-----|-------|-------|

**Code**

```lua
function HUDElement:getAlpha()
    return self.overlay.a
end

```

### getColor

**Description**

> Get this HUD element's color.

**Definition**

> getColor()

**Return Values**

| any | Red   | value |
|-----|-------|-------|
| any | Green | value |
| any | Blue  | value |
| any | Alpha | value |

**Code**

```lua
function HUDElement:getColor()
    return self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a
end

```

### getDimension

**Description**

> Get this HUD element's width and height.

**Definition**

> getDimension()

**Return Values**

| any | width  |
|-----|--------|
| any | height |

**Code**

```lua
function HUDElement:getDimension()
    return self.overlay.width, self.overlay.height
end

```

### getHeight

**Description**

> Get this HUD element's height in screen space.

**Definition**

> getHeight()

**Code**

```lua
function HUDElement:getHeight()
    return self.overlay.height
end

```

### getPosition

**Description**

> Get this HUD element's position.

**Definition**

> getPosition()

**Return Values**

| any | X | position in screen space |
|-----|---|--------------------------|
| any | Y | position in screen space |

**Code**

```lua
function HUDElement:getPosition()
    return self.overlay:getPosition()
end

```

### getRotationPivot

**Description**

> Get this HUD element's rotation pivot point.

**Definition**

> getRotationPivot()

**Return Values**

| any | Pivot | x position offset from element position in screen space |
|-----|-------|---------------------------------------------------------|
| any | Pivot | y position offset from element position in screen space |

**Code**

```lua
function HUDElement:getRotationPivot()
    return self.pivotX, self.pivotY
end

```

### getScale

**Description**

> Get this HUD element's scale.

**Definition**

> getScale()

**Return Values**

| any | scale | factor |
|-----|-------|--------|
| any | scale | factor |

**Code**

```lua
function HUDElement:getScale()
    return self.overlay:getScale()
end

```

### getVisible

**Description**

> Get this HUD element's visibility.

**Definition**

> getVisible()

**Code**

```lua
function HUDElement:getVisible()
    return self.overlay.visible
end

```

### getWidth

**Description**

> Get this HUD element's width in screen space.

**Definition**

> getWidth()

**Code**

```lua
function HUDElement:getWidth()
    return self.overlay.width
end

```

### new

**Description**

> Create a new HUD element.

**Definition**

> new(table subClass, table overlay, table? parentHudElement)

**Arguments**

| table  | subClass         | Subclass metatable for inheritance                             |
|--------|------------------|----------------------------------------------------------------|
| table  | overlay          | Wrapped Overlay instance                                       |
| table? | parentHudElement | [optional] Parent HUD element of the newly created HUD element |

**Return Values**

| table? | HUDElement | instance |
|--------|------------|----------|

**Code**

```lua
function HUDElement.new(overlay, parentHudElement, customMt)
    local self = setmetatable( { } , customMt or HUDElement _mt)

    self.overlay = overlay
    self.children = { }

    self.pivotX = 0
    self.pivotY = 0
    self.defaultPivotX = 0
    self.defaultPivotY = 0

    -- animation
    self.animation = TweenSequence.NO_SEQUENCE

    self.parent = nil
    if parentHudElement then
        parentHudElement:addChild( self )
    end

    return self
end

```

### normalizeUVPivot

**Description**

> Convert a texture space pivot to an element-local pivot.

**Definition**

> normalizeUVPivot(table uvPivot, table uvs, )

**Arguments**

| table | uvPivot | Array of two pixel pivot coordinates in texture space |
|-------|---------|-------------------------------------------------------|
| table | uvs     | Array of UV coordinates as {x, y, width, height}      |
| any   | uvs     |                                                       |

**Code**

```lua
function HUDElement:normalizeUVPivot(uvPivot, size, uvs)
    return self:scalePixelToScreenWidth(uvPivot[ 1 ] * size[ 1 ] / uvs[ 3 ]),
    self:scalePixelToScreenHeight(uvPivot[ 2 ] * size[ 2 ] / uvs[ 4 ])
end

```

### removeChild

**Description**

> Remove a child HUD element from this element.

**Definition**

> removeChild(table childHudElement)

**Arguments**

| table | childHudElement | HUDElement instance which is removed as a child. |
|-------|-----------------|--------------------------------------------------|

**Code**

```lua
function HUDElement:removeChild(childHudElement)
    if childHudElement.parent = = self then
        for i, child in ipairs( self.children) do
            if child = = childHudElement then
                child.parent = nil
                table.remove( self.children, i)
                return
            end
        end
    end
end

```

### resetDimensions

**Description**

> Reset this HUD element's dimensions to their default values.
> Resets width, height, scale and pivot.

**Definition**

> resetDimensions()

**Code**

```lua
function HUDElement:resetDimensions()
    self.overlay:resetDimensions()
    self.pivotX = self.defaultPivotX
    self.pivotY = self.defaultPivotY
end

```

### scalePixelToScreenHeight

**Description**

> Convert a vertical pixel value into scaled screen space value.

**Definition**

> scalePixelToScreenHeight(float height)

**Arguments**

| float | height | Vertical pixel value |
|-------|--------|----------------------|

**Code**

```lua
function HUDElement:scalePixelToScreenHeight(height)
    return height * self.overlay.scaleHeight * g_aspectScaleY / g_referenceScreenHeight
end

```

### scalePixelToScreenVector

**Description**

> Convert a vector from pixel values into scaled screen space values.

**Definition**

> scalePixelToScreenVector(table vector2D)

**Arguments**

| table | vector2D | Array of two pixel values |
|-------|----------|---------------------------|

**Code**

```lua
function HUDElement:scalePixelToScreenVector(vector2D)
    --#debug assertWithCallstack(vector2D ~ = nil)
    return vector2D[ 1 ] * self.overlay.scaleWidth * g_aspectScaleX / g_referenceScreenWidth,
    vector2D[ 2 ] * self.overlay.scaleHeight * g_aspectScaleY / g_referenceScreenHeight
end

```

### scalePixelToScreenWidth

**Description**

> Convert a horizontal pixel value into scaled screen space value.

**Definition**

> scalePixelToScreenWidth(float width)

**Arguments**

| float | width | Horizontal pixel value |
|-------|-------|------------------------|

**Code**

```lua
function HUDElement:scalePixelToScreenWidth(width)
    return width * self.overlay.scaleWidth * g_aspectScaleX / g_referenceScreenWidth
end

```

### setAlignment

**Description**

> Set this HUD element's positional alignment.
> See Overlay:setAlignment for positioning logic.

**Definition**

> setAlignment(integer vertical, integer horizontal)

**Arguments**

| integer | vertical   | Vertical alignment value [Overlay.ALIGN_VERTICAL_BOTTOM   | Overlay.ALIGN_VERTICAL_MIDDLE   | Overlay.ALIGN_VERTICAL_TOP]     |
|---------|------------|-----------------------------------------------------------|---------------------------------|---------------------------------|
| integer | horizontal | Horizontal alignment value [Overlay.ALIGN_HORIZONTAL_LEFT | Overlay.ALIGN_HORIZONTAL_CENTER | Overlay.ALIGN_HORIZONTAL_RIGHT] |

**Code**

```lua
function HUDElement:setAlignment(vertical, horizontal)
    self.overlay:setAlignment(vertical, horizontal)
end

```

### setAlpha

**Description**

> Set this HUD element overlay's color alpha value only.

**Definition**

> setAlpha()

**Arguments**

| any | alpha |
|-----|-------|

**Code**

```lua
function HUDElement:setAlpha(alpha)
    self.overlay:setColor( nil , nil , nil , alpha)
end

```

### setColor

**Description**

> Set this HUD element overlay's color.
> Children are unaffected.

**Definition**

> setColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function HUDElement:setColor(r, g, b, a)
    self.overlay:setColor(r, g, b, a)
end

```

### setDimension

**Description**

> Set this HUD element's width and height.
> Either value can be omitted (== nil) for no change.

**Definition**

> setDimension()

**Arguments**

| any | width  |
|-----|--------|
| any | height |

**Code**

```lua
function HUDElement:setDimension(width, height)
    self.overlay:setDimension(width, height)
end

```

### setImage

**Description**

> Set this HUD element overlay's image file.

**Definition**

> setImage()

**Arguments**

| any | imageFilename |
|-----|---------------|

**Code**

```lua
function HUDElement:setImage(imageFilename)
    self.overlay:setImage(imageFilename)
end

```

### setPosition

**Description**

> Set a HUD element's absolute screen space position.
> If the element has any children, they will be moved with this element.

**Definition**

> setPosition()

**Arguments**

| any | x |
|-----|---|
| any | y |

**Code**

```lua
function HUDElement:setPosition(x, y)
    local prevX, prevY = self:getPosition()

    -- substitute omitted parameters with current values to mirror Overlay behavior:
    x = x or prevX
    y = y or prevY

    self.overlay:setPosition(x, y)

    if # self.children > 0 then -- move children with self
        local moveX, moveY = x - prevX, y - prevY

        for _, child in pairs( self.children) do
            local childX, childY = child:getPosition()

            child:setPosition(childX + moveX, childY + moveY)
        end
    end
end

```

### setRotation

**Description**

> Set this HUD element's rotation.
> Does not affect children. If no center position is given, the element's pivot values are used (default to 0)

**Definition**

> setRotation(float rotation, float? centerX, float? centerY)

**Arguments**

| float  | rotation | Rotation in radians                                                               |
|--------|----------|-----------------------------------------------------------------------------------|
| float? | centerX  | [optional] Rotation pivot X position offset from overlay position in screen space |
| float? | centerY  | [optional] Rotation pivot Y position offset from overlay position in screen space |

**Code**

```lua
function HUDElement:setRotation(rotation, centerX, centerY)
    self.overlay:setRotation(rotation, centerX or self.pivotX, centerY or self.pivotY)
end

```

### setRotationPivot

**Description**

> Set this HUD element's rotation pivot point.

**Definition**

> setRotationPivot(float pivotX, float pivotY)

**Arguments**

| float | pivotX | Pivot x position offset from element position in screen space |
|-------|--------|---------------------------------------------------------------|
| float | pivotY | Pivot y position offset from element position in screen space |

**Code**

```lua
function HUDElement:setRotationPivot(pivotX, pivotY)
    self.pivotX, self.pivotY = pivotX or self.defaultPivotX, pivotY or self.defaultPivotY
    self.defaultPivotX, self.defaultPivotY = pivotX or self.defaultPivotX, pivotY or self.defaultPivotY
end

```

### setScale

**Description**

> Set this HUD element's scale.
> This will move and scale children proportionally.

**Definition**

> setScale(float scaleWidth, float scaleHeight)

**Arguments**

| float | scaleWidth  | Width scale factor  |
|-------|-------------|---------------------|
| float | scaleHeight | Height scale factor |

**Code**

```lua
function HUDElement:setScale(scaleWidth, scaleHeight)
    local prevSelfX, prevSelfY = self:getPosition()
    local prevScaleWidth, prevScaleHeight = self:getScale()
    self.overlay:setScale(scaleWidth, scaleHeight)
    local selfX, selfY = self:getPosition()

    if # self.children > 0 then
        local changeFactorX, changeFactorY = scaleWidth / prevScaleWidth, scaleHeight / prevScaleHeight

        for _, child in pairs( self.children) do
            local childScaleWidth, childScaleHeight = child:getScale()

            local childPrevX, childPrevY = child:getPosition()
            local offX = childPrevX - prevSelfX
            local offY = childPrevY - prevSelfY
            local posX = selfX + offX * changeFactorX
            local posY = selfY + offY * changeFactorY

            child:setPosition(posX, posY)
            child:setScale(childScaleWidth * changeFactorX, childScaleHeight * changeFactorY)
        end
    end

    self.pivotX = self.defaultPivotX * scaleWidth
    self.pivotY = self.defaultPivotY * scaleHeight
end

```

### setSliceId

**Description**

> Set this HUD element overlay's slice id.

**Definition**

> setSliceId()

**Arguments**

| any | sliceId |
|-----|---------|

**Code**

```lua
function HUDElement:setSliceId(sliceId)
    self.overlay:setSliceId(sliceId)
end

```

### setUVs

**Description**

> Set this HUD element overlay's UV coordinates.

**Definition**

> setUVs()

**Arguments**

| any | uvs |
|-----|-----|

**Code**

```lua
function HUDElement:setUVs(uvs)
    self.overlay:setUVs(uvs)
end

```

### setVisible

**Description**

> Set this HUD element's visibility.

**Definition**

> setVisible()

**Arguments**

| any | isVisible |
|-----|-----------|

**Code**

```lua
function HUDElement:setVisible(isVisible)
    if self.overlay ~ = nil then
        self.overlay.visible = isVisible
    end
end

```

### update

**Description**

> Update this HUD element's state.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HUDElement:update(dt)
    if not self.animation:getFinished() then
        self.animation:update(dt)
    end
end

```