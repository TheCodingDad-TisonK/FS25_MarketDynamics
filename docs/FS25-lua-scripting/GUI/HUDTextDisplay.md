## HUDTextDisplay

**Description**

> HUD text display.
> Displays a formatted single-line text with optional animations.

**Parent**

> [HUDDisplayElement](?version=script&category=43&class=457)

**Functions**

- [draw](#draw)
- [new](#new)
- [setAlpha](#setalpha)
- [setAnimation](#setanimation)
- [setScale](#setscale)
- [setText](#settext)
- [setTextColorChannels](#settextcolorchannels)
- [setTextShadow](#settextshadow)
- [setVisible](#setvisible)
- [update](#update)

### draw

**Description**

> Draw the text.

**Definition**

> draw()

**Code**

```lua
function HUDTextDisplay:draw()
    if self.text = = "" then
        return
    end

    if not self:getVisible() then
        return
    end

    setTextBold( self.textBold)
    local posX, posY = self:getPosition()
    setTextAlignment( self.textAlignment)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
    setTextWrapWidth( 0.9 )

    if self.hasShadow then
        local offset = self.screenTextSize * HUDTextDisplay.SHADOW_OFFSET_FACTOR
        local r, g, b, a = unpack( self.shadowColor)
        setTextColor(r, g, b, a * self.overlay.a)
        renderText(posX + offset, posY - offset, self.screenTextSize, self.text)
    end

    local r, g, b, a = unpack( self.textColor)
    setTextColor(r, g, b, a * self.overlay.a)
    renderText(posX, posY, self.screenTextSize, self.text)

    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextWrapWidth( 0 )
    setTextBold( false )
    setTextColor( 1 , 1 , 1 , 1 )
end

```

### new

**Description**

> Create a new HUDTextDisplay.

**Definition**

> new(float posX, float posY, float textSize, integer? textAlignment, table? textColor, boolean? textBold)

**Arguments**

| float    | posX          | Screen space X position of the text display                        |              |              |
|----------|---------------|--------------------------------------------------------------------|--------------|--------------|
| float    | posY          | Screen space Y position of the text display                        |              |              |
| float    | textSize      | Text size in reference resolution pixels                           |              |              |
| integer? | textAlignment | Text alignment as one of RenderText.[ALIGN_LEFT                    | ALIGN_CENTER | ALIGN_RIGHT] |
| table?   | textColor     | Text display color as an array {r, g, b, a}, default: {1, 1, 1, 1} |              |              |
| boolean? | textBold      | If true, will render the text in bold                              |              |              |

**Return Values**

| boolean? | HUDTextDisplay | instance |
|----------|----------------|----------|

**Code**

```lua
function HUDTextDisplay.new(posX, posY, textSize, textAlignment, textColor, textBold)
    local backgroundOverlay = Overlay.new( nil , 0 , 0 , 0 , 0 )
    backgroundOverlay:setColor( 1 , 1 , 1 , 1 )
    local self = HUDTextDisplay:superClass().new(backgroundOverlay, nil , HUDTextDisplay _mt)

    self.initialPosX = posX
    self.initialPosY = posY
    self.text = "" -- must be set in a separate call which will correctly set up boundaries and position
    self.textSize = textSize or 0
    self.screenTextSize = self:scalePixelToScreenHeight( self.textSize)
    self.textAlignment = textAlignment or RenderText.ALIGN_LEFT
    self.textColor = textColor or { 1 , 1 , 1 , 1 }
    self.textBold = textBold or false

    self.hasShadow = false
    self.shadowColor = { 0 , 0 , 0 , 1 }

    return self
end

```

### setAlpha

**Description**

> Set the global alpha value for this text display.
> The alpha value will be multiplied with any text color alpha channel value.

**Definition**

> setAlpha(float alpha)

**Arguments**

| float | alpha |
|-------|-------|

**Code**

```lua
function HUDTextDisplay:setAlpha(alpha)
    self:setColor( nil , nil , nil , alpha)
end

```

### setAnimation

**Description**

> Set an animation tween (sequence) for this text display.
> The animation can be played when calling HUDTextDisplay:setVisible() with the "animate" paramter set to true.

**Definition**

> setAnimation(table animationTween)

**Arguments**

| table | animationTween |
|-------|----------------|

**Code**

```lua
function HUDTextDisplay:setAnimation(animationTween)
    self:storeOriginalPosition()
    self.animation = animationTween or TweenSequence.NO_SEQUENCE
end

```

### setScale

**Description**

> Set the text display UI scale.

**Definition**

> setScale(float uiScale)

**Arguments**

| float | uiScale |
|-------|---------|

**Code**

```lua
function HUDTextDisplay:setScale(uiScale)
    HUDTextDisplay:superClass().setScale( self , uiScale)

    self.screenTextSize = self:scalePixelToScreenHeight( self.textSize)
end

```

### setText

**Description**

> Set the text to display.

**Definition**

> setText(string text, float textSize, integer textAlignment, table textColor, boolean textBold)

**Arguments**

| string  | text          | Display text                                    |              |              |
|---------|---------------|-------------------------------------------------|--------------|--------------|
| float   | textSize      | Text size in reference resolution pixels        |              |              |
| integer | textAlignment | Text alignment as one of RenderText.[ALIGN_LEFT | ALIGN_CENTER | ALIGN_RIGHT] |
| table   | textColor     | Text display color as an array {r, g, b, a}     |              |              |
| boolean | textBold      | If true, will render the text in bold           |              |              |

**Code**

```lua
function HUDTextDisplay:setText(text, textSize, textAlignment, textColor, textBold)
    -- assign values with initial values as defaults
    self.text = text or self.text
    self.textSize = textSize or self.textSize
    self.screenTextSize = self:scalePixelToScreenHeight( self.textSize)
    self.textAlignment = textAlignment or self.textAlignment
    self.textColor = textColor or self.textColor
    self.textBold = textBold or self.textBold

    local width, height = getTextWidth( self.screenTextSize, self.text), getTextHeight( self.screenTextSize, self.text)
    self:setDimension(width, height)

    local posX, posY = self.initialPosX, self.initialPosY

    self:setPosition(posX, posY)
end

```

### setTextColorChannels

**Description**

> Set the text color by channels.
> Use for dynamic changes and animation.

**Definition**

> setTextColorChannels(float r, float g, float b, float a)

**Arguments**

| float | r |
|-------|---|
| float | g |
| float | b |
| float | a |

**Code**

```lua
function HUDTextDisplay:setTextColorChannels(r, g, b, a)
    self.textColor[ 1 ] = r
    self.textColor[ 2 ] = g
    self.textColor[ 3 ] = b
    self.textColor[ 4 ] = a
end

```

### setTextShadow

**Description**

> Set the text shadow state.

**Definition**

> setTextShadow(boolean isShadowEnabled, table shadowColor)

**Arguments**

| boolean | isShadowEnabled | If true, will cause a shadow to be rendered under the text |
|---------|-----------------|------------------------------------------------------------|
| table   | shadowColor     | Shadow text color as an array {r, g, b, a}                 |

**Code**

```lua
function HUDTextDisplay:setTextShadow(isShadowEnabled, shadowColor)
    self.hasShadow = isShadowEnabled or self.hasShadow
    self.shadowColor = shadowColor or self.shadowColor
end

```

### setVisible

**Description**

> Set this element's visibility.

**Definition**

> setVisible(boolean isVisible, boolean animate)

**Arguments**

| boolean | isVisible | Visibility state                                                                                   |
|---------|-----------|----------------------------------------------------------------------------------------------------|
| boolean | animate   | If true, will play the currently set animation on becoming visible or and reset it when necessary. |

**Code**

```lua
function HUDTextDisplay:setVisible(isVisible, animate)
    -- shadow parent behavior which includes repositioning
    HUDElement.setVisible( self , isVisible)

    if animate then
        if not isVisible or not self.animation:getFinished() then
            self.animation:reset()
        end

        if isVisible then
            self.animation:start()
        end
    end
end

```

### update

**Description**

> Update this element's state.

**Definition**

> update(float dt)

**Arguments**

| float | dt |
|-------|----|

**Code**

```lua
function HUDTextDisplay:update(dt)
    if self:getVisible() then
        HUDTextDisplay:superClass().update( self , dt)
    end
end

```