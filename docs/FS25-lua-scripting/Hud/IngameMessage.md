## IngameMessage

**Description**

> Maximum message duration in milliseconds.

**Parent**

> [HUDDisplay](?version=script&category=&class=)

**Functions**

- [draw](#draw)
- [new](#new)
- [storeScaledValues](#storescaledvalues)

### draw

**Description**

> Draw the notifications.

**Definition**

> draw()

**Code**

```lua
function IngameMessage:draw()
    IngameMessage:superClass().draw( self )

    if not self:getVisible() then
        return
    end

    if g_gui:getIsGuiVisible() then
        return
    end

    local message = self.currentMessage
    if message ~ = nil then
        local title = message.title
        local text = message.text
        local controls = message.controls

        local posX, posY = self:getPosition()
        posX = posX - self.width * 0.5
        local height = 2 * self.textOffsetY + self.skipHeight

        setTextColor( 1 , 1 , 1 , 1 )
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
        setTextWrapWidth( self.maxTextWidth)

        local titleHeight = 0
        if title ~ = nil then
            setTextBold( true )
            titleHeight = getTextHeight( self.titleTextSize, title)
            height = height + titleHeight + self.titleToTextOffsetY
        end

        local textHeight = 0
        if text ~ = nil then
            setTextBold( false )
            textHeight = getTextHeight( self.textSize, text)
            height = height + textHeight
        end

        if controls ~ = nil then
            local numControls = #controls
            height = height + self.controlsHeight * numControls + g_pixelSizeY * (numControls - 1 )
        end

        if title ~ = nil or text ~ = nil then
            height = height + self.textControlsOffsetY
        end

        local color = HUD.COLOR.BACKGROUND_DARK
        drawFilledRectRound(posX, posY, self.width, height, 0.5 , color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ])

        local textPosX = posX + self.textOffsetX
        local currentPosY = posY + height - self.textOffsetY
        if title ~ = nil then
            setTextBold( true )
            renderText(textPosX, currentPosY, self.titleTextSize, title)
            currentPosY = currentPosY - self.titleToTextOffsetY - titleHeight
        end

        if text ~ = nil then
            setTextBold( false )
            renderText(textPosX, currentPosY, self.textSize, text)
            currentPosY = currentPosY - textHeight
        end

        setTextWrapWidth( 0 )
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)

        if title ~ = nil or text ~ = nil then
            currentPosY = currentPosY - self.textControlsOffsetY

            local lineStart = posX + self.textOffsetX
            local lineEnd = lineStart + self.maxTextWidth
            drawLine2D(lineStart, currentPosY, lineEnd, currentPosY, g_pixelSizeY, 1 , 1 , 1 , 0.2 )
        end

        if controls ~ = nil then
            local lineStart = posX + self.textOffsetX
            local lineEnd = lineStart + self.maxTextWidth
            local offsetY = ( self.controlsHeight - self.buttonHeight) * 0.5
            for _, control in ipairs(controls) do
                currentPosY = currentPosY - self.controlsHeight

                local width = self:drawControl(control, lineEnd, currentPosY + offsetY)
                local maxWidth = self.maxTextWidth - width - self.controlTextOffsetX

                local controlText = Utils.limitTextToWidth(control.text, self.controlTextSize, maxWidth, false , " .. ." )
                setTextBold( true )
                renderText(textPosX, currentPosY + self.controlTextOffsetY, self.controlTextSize, controlText)

                drawLine2D(lineStart, currentPosY, lineEnd, currentPosY, g_pixelSizeY, 1 , 1 , 1 , 0.2 )
            end

            local numControls = #controls
            height = height + self.controlsHeight * numControls + g_pixelSizeY * (numControls - 1 )
        end

        setTextBold( true )
        setTextAlignment(RenderText.ALIGN_RIGHT)
        local skipTextWidth = getTextWidth( self.skipTextSize, self.skipText)

        local skipTextPosX = posX + self.textOffsetX + self.maxTextWidth * 0.5 + skipTextWidth
        local skipTextPosY = posY + self.skipTextOffsetY
        renderText(skipTextPosX, skipTextPosY, self.skipTextSize, self.skipText)

        local skipPosX = skipTextPosX - self.skipTextOffsetX - skipTextWidth
        local skipPosY = posY + self.skipButtonOffsetY

        self:drawControl( self.skipControl, skipPosX, skipPosY)

        setTextColor( 1 , 1 , 1 , 1 )
        setTextAlignment(RenderText.ALIGN_LEFT)
    end
end

```

### new

**Description**

> Create a new IngameMessage.

**Definition**

> new(any? customMt)

**Arguments**

| any? | customMt |
|------|----------|

**Return Values**

| any? | self |
|------|------|

**Code**

```lua
function IngameMessage.new(customMt)
    local self = IngameMessage:superClass().new( IngameMessage _mt)

    self.pendingMessages = { }
    self.isCustomInputActive = false -- input state flag
    self.lastInputMode = g_inputBinding:getInputHelpMode()

    self.glyphButtonOverlay = GlyphButtonOverlay.new()
    self.glyphButtonOverlay:setColor( 0.22323 , 0.40724 , 0.0036 , 1 , 0 , 0 , 0 , 0.80 )

    self.keyButtonOverlay = ButtonOverlay.new()
    self.keyButtonOverlay:setColor( 0.22323 , 0.40724 , 0.00368 , 1 , 0 , 0 , 0 , 0.80 )

    self.skipText = g_i18n:getText( "button_ok" )
    self.skipControl = nil

    self.isGamePaused = false -- game paused state

    self.nextMessageTimer = - 1

    return self
end

```

### storeScaledValues

**Description**

> Store scaled positioning, size and offset values.

**Definition**

> storeScaledValues()

**Code**

```lua
function IngameMessage:storeScaledValues()
    local offsetX, offsetY = self:scalePixelValuesToScreenVector( 0 , 0 )
    local posX = 0.5 + offsetX
    local posY = g_hudAnchorBottom + offsetY
    self:setPosition(posX, posY)

    self.width = self:scalePixelToScreenWidth( 640 )

    self.skipTextSize = self:scalePixelToScreenHeight( 17 )
    self.skipTextOffsetX, self.skipTextOffsetY = self:scalePixelValuesToScreenVector( 5 , 22 )
    self.skipButtonOffsetY = self:scalePixelToScreenHeight( 12 )
    self.skipHeight = self:scalePixelToScreenHeight( 30 )

    self.titleTextSize = self:scalePixelToScreenHeight( 19 )
    self.titleToTextOffsetY = self:scalePixelToScreenHeight( 10 )
    self.titleOffsetY = self:scalePixelToScreenHeight( 20 )

    self.textSize = self:scalePixelToScreenHeight( 17 )
    self.textOffsetY = self:scalePixelToScreenHeight( 18 )

    self.textOffsetX, self.textOffsetY = self:scalePixelValuesToScreenVector( 20 , 20 )
    self.maxTextWidth = self.width - 2 * self.textOffsetX

    self.controlTextSize = self:scalePixelToScreenHeight( 17 )
    self.controlTextOffsetX, self.controlTextOffsetY = self:scalePixelValuesToScreenVector( 10 , 15 )
    self.textControlsOffsetY = self:scalePixelToScreenHeight( 15 )
    self.controlsHeight = self:scalePixelToScreenHeight( 42 )

    self.keyButtonOverlay:setMinWidth( self:scalePixelToScreenWidth( 35 ))
    self.glyphButtonOverlay:setMinWidth( self:scalePixelToScreenWidth( 35 ))
    self.buttonHeight = self:scalePixelToScreenHeight( 30 )

    self:updateControls()
end

```