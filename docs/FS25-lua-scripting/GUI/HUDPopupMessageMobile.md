## HUDPopupMessageMobile

**Description**

> HUD popup message.
> Displays a modal popup message which requires a player input to be accepted / dismissed or expires after a given
> time. based on the HUDPopupMessage, but repurposed for mobile devices.

**Parent**

> [HUDDisplayElement](?version=script&category=43&class=455)

**Functions**

- [animateHide](#animatehide)
- [assignCurrentMessage](#assigncurrentmessage)
- [createBackground](#createbackground)
- [createComponents](#createcomponents)
- [createInputRow](#createinputrow)
- [draw](#draw)
- [finishMessage](#finishmessage)
- [getBackgroundPosition](#getbackgroundposition)
- [getHidingTranslation](#gethidingtranslation)
- [getInputRowsHeight](#getinputrowsheight)
- [getTextHeight](#gettextheight)
- [getTitleHeight](#gettitleheight)
- [getVisible](#getvisible)
- [new](#new)
- [onConfirmMessage](#onconfirmmessage)
- [setCurrentMessageHeight](#setcurrentmessageheight)
- [setDimension](#setdimension)
- [setInputActive](#setinputactive)
- [setScale](#setscale)
- [showMessage](#showmessage)
- [startMessage](#startmessage)
- [storeScaledValues](#storescaledvalues)
- [update](#update)
- [updateButtonGlyphs](#updatebuttonglyphs)
- [updateCurrentMessage](#updatecurrentmessage)

### animateHide

**Description**

> Animate this element on showing.

**Definition**

> animateHide()

**Code**

```lua
function HUDPopupMessageMobile:animateHide()
    HUDPopupMessageMobile:superClass().animateHide( self )

    g_depthOfFieldManager:popArea()
    self.blurAreaActive = false
    self.animation:addCallback( self.finishMessage) -- call finishMessage when animation has completed
end

```

### assignCurrentMessage

**Description**

> Assign a new current message and adjust display state accordingly.
> This also resizes the message box according to the required space.

**Definition**

> assignCurrentMessage()

**Arguments**

| any | message |
|-----|---------|

**Code**

```lua
function HUDPopupMessageMobile:assignCurrentMessage(message)
    self.time = 0
    self.currentMessage = message

    if g_touchHandler ~ = nil then
        g_touchHandler:setCustomContext( "guidedTour" , true )
        g_touchHandler:registerTouchArea( 0 , 0 , 1 , 1 , 0 , 0 , TouchHandler.TRIGGER_UP, self.onConfirmMessage, self )
    end

    local isTouch = g_inputBinding:getInputHelpMode() = = GS_INPUT_HELP_MODE_TOUCH
    self.continueGlyph:setVisible( not isTouch)

    self:setCurrentMessageHeight()
    self:updateButtonGlyphs()
end

```

### createBackground

**Description**

> Create the background overlay.

**Definition**

> createBackground()

**Arguments**

| any | hudAtlasPath |
|-----|--------------|

**Code**

```lua
function HUDPopupMessageMobile.createBackground(hudAtlasPath)
    local posX, posY = HUDPopupMessageMobile.getBackgroundPosition( 1 )
    local width, height = getNormalizedScreenValues( unpack( HUDPopupMessageMobile.SIZE.SELF))

    local overlay = Overlay.new(hudAtlasPath, posX - width * 0.5 , posY, width, height)
    overlay:setUVs( GuiUtils.getUVs( HUDPopupMessageMobile.UV.BACKGROUND))
    overlay:setColor( unpack( HUDPopupMessageMobile.COLOR.BACKGROUND))
    return overlay
end

```

### createComponents

**Description**

> Create required display components.

**Definition**

> createComponents()

**Arguments**

| any | hudAtlasPath |
|-----|--------------|

**Code**

```lua
function HUDPopupMessageMobile:createComponents(hudAtlasPath)
    local basePosX, basePosY = self:getPosition()
    local baseWidth = self:getWidth()

    local _, inputRowHeight = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.INPUT_ROW)

    local posY = basePosY + inputRowHeight -- add one row's height as spacing for the continue button
        for i = 1 , HUDPopupMessageMobile.MAX_INPUT_ROW_COUNT do
            local buttonRow, inputGlyph

            buttonRow, inputGlyph, posY = self:createInputRow(hudAtlasPath, basePosX, posY)
            local rowIndex = HUDPopupMessageMobile.MAX_INPUT_ROW_COUNT - i + 1
            self.inputRows[rowIndex] = buttonRow
            self.inputGlyphs[rowIndex] = inputGlyph
            self:addChild(buttonRow)
        end

        local offX, offY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.CONTINUE_BUTTON)
        local glyphWidth, glyphHeight = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.INPUT_GLYPH)
        local continueGlyph = InputGlyphElement.new(g_inputDisplayManager, glyphWidth, glyphHeight)
        continueGlyph:setPosition(basePosX + (baseWidth - glyphWidth) * 0.5 + offX, basePosY - offY)
        continueGlyph:setAction(InputAction.SKIP_MESSAGE_BOX, g_i18n:getText( HUDPopupMessageMobile.L10N_SYMBOL.BUTTON_OK), self.continueTextSize, true , false )

        self.continueGlyph = continueGlyph
        self:addChild(continueGlyph)
    end

```

### createInputRow

**Description**

> Create components for an input button row.

**Definition**

> createInputRow()

**Arguments**

| any | hudAtlasPath |
|-----|--------------|
| any | posX         |
| any | posY         |

**Code**

```lua
function HUDPopupMessageMobile:createInputRow(hudAtlasPath, posX, posY)
    local overlay = Overlay.new(hudAtlasPath, posX, posY, self.inputRowWidth, self.inputRowHeight)
    overlay:setUVs( GuiUtils.getUVs( HUDPopupMessageMobile.UV.BACKGROUND))
    overlay:setColor( unpack( HUDPopupMessageMobile.COLOR.INPUT_ROW))
    local buttonPanel = HUDElement.new(overlay)

    local rowHeight = buttonPanel:getHeight()

    local glyphWidth, glyphHeight = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.INPUT_GLYPH)
    local inputGlyph = InputGlyphElement.new(g_inputDisplayManager, glyphWidth, glyphHeight)
    local offX, offY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.INPUT_GLYPH)
    local glyphX, glyphY = posX + self.borderPaddingX + offX, posY + (rowHeight - glyphHeight) * 0.5 + offY
    inputGlyph:setPosition(glyphX, glyphY)
    buttonPanel:addChild(inputGlyph)

    local width, height = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.SEPARATOR)
    height = math.max(height, HUDPopupMessageMobile.SIZE.SEPARATOR[ 2 ] / g_screenHeight)
    offX, offY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.SEPARATOR)
    overlay = Overlay.new(hudAtlasPath, posX + offX, posY + offY, width, height)
    overlay:setUVs( GuiUtils.getUVs( GameInfoDisplay.UV.SEPARATOR))
    overlay:setColor( unpack( GameInfoDisplay.COLOR.SEPARATOR))
    local separator = HUDElement.new(overlay)
    buttonPanel:addChild(separator)

    return buttonPanel, inputGlyph, posY + rowHeight
end

```

### draw

**Description**

> Draw the message.

**Definition**

> draw()

**Code**

```lua
function HUDPopupMessageMobile:draw()
    if not g_gui:getIsMenuVisible() and self:getVisible() and self.currentMessage ~ = nil then
        HUDPopupMessageMobile:superClass().draw( self )

        local baseX, baseY = self:getPosition()
        local width, height = self:getWidth(), self:getHeight()

        -- title
        setTextColor( unpack( HUDPopupMessageMobile.COLOR.TITLE))
        setTextBold( true )
        setTextAlignment(RenderText.ALIGN_CENTER)
        setTextWrapWidth(width - 2 * self.borderPaddingX)
        local textPosY = baseY + height - self.borderPaddingY

        if self.currentMessage.title ~ = "" then
            local title = utf8ToUpper( self.currentMessage.title)
            textPosY = textPosY - self.titleTextSize
            renderText(baseX + width * 0.5 , textPosY, self.titleTextSize, title)
        end

        -- message
        setTextBold( false )
        setTextColor( unpack( HUDPopupMessageMobile.COLOR.TEXT))
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextLineHeightScale( HUDPopupMessageMobile.TEXT_LINE_HEIGHT_SCALE)
        textPosY = textPosY - self.textSize + self.textOffsetY
        renderText(baseX + self.borderPaddingX, textPosY, self.textSize, self.currentMessage.message)
        textPosY = textPosY - getTextHeight( self.textSize, self.currentMessage.message)

        -- input rows
        setTextColor( unpack( HUDPopupMessageMobile.COLOR.CONTINUE_TEXT))
        setTextAlignment(RenderText.ALIGN_RIGHT)
        local posX = baseX + width - self.borderPaddingX
        local posY = textPosY + self.inputRowsOffsetY - self.inputRowHeight - self.textSize
        for i = 1 , # self.currentMessage.controls do
            local inputText = self.currentMessage.controls[i].text
            renderText(posX + self.inputRowTextX, posY + self.inputRowTextY, self.textSize, inputText)

            posY = posY - self.inputRowHeight
        end

        setTextAlignment(RenderText.ALIGN_CENTER)

        if g_inputBinding:getInputHelpMode() = = GS_INPUT_HELP_MODE_TOUCH then
            local continueX, continueY = self.continueGlyph:getPosition()
            continueX = continueX + self.continueGlyph.baseWidth / 2
            continueY = continueY + self.continueTextSize / 2
            renderText(continueX, continueY, self.continueTextSize, self.continueText)
        end

        setTextAlignment(RenderText.ALIGN_LEFT)

        -- reset uncommon text settings:
        setTextWrapWidth( 0 )
        setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE)
    end
end

```

### finishMessage

**Description**

> Finish displaying a message after it has either elapsed or been acknowledged by the player.
> Resets display and input state and triggers any provided message callback.

**Definition**

> finishMessage()

**Code**

```lua
function HUDPopupMessageMobile:finishMessage()
    self.ingameMap:setAllowToggle( true ) -- (re-)enable toggle input on map

    if self.currentMessage ~ = nil and self.currentMessage.callback ~ = nil then
        if self.currentMessage.target ~ = nil then
            self.currentMessage.callback( self.currentMessage.target)
        else
                self.currentMessage.callback( self )
            end
        end

        self.currentMessage = nil
    end

```

### getBackgroundPosition

**Description**

> Get this element's base background position.

**Definition**

> getBackgroundPosition(float uiScale)

**Arguments**

| float | uiScale | Current UI scale factor |
|-------|---------|-------------------------|

**Code**

```lua
function HUDPopupMessageMobile.getBackgroundPosition(uiScale)
    local offX, offY = getNormalizedScreenValues( unpack( HUDPopupMessageMobile.POSITION.SELF))
    return 0.5 + offX * uiScale, g_safeFrameOffsetY + offY * uiScale -- bottom center plus offset
end

```

### getHidingTranslation

**Description**

> Get the screen space translation for hiding.
> Override in sub-classes if a different translation is required.

**Definition**

> getHidingTranslation()

**Return Values**

| float | Screen | space X translation |
|-------|--------|---------------------|
| float | Screen | space Y translation |

**Code**

```lua
function HUDPopupMessageMobile:getHidingTranslation()
    return 0 , - self:getHeight() - g_safeFrameOffsetY - 0.01
end

```

### getInputRowsHeight

**Description**

> Get the display height of the current message's input rows.

**Definition**

> getInputRowsHeight()

**Code**

```lua
function HUDPopupMessageMobile:getInputRowsHeight()
    local height = 0
    if self.currentMessage ~ = nil then
        -- add one to row count for the continue button
            height = (# self.currentMessage.controls + 1 ) * self.inputRowHeight
        end

        return height
    end

```

### getTextHeight

**Description**

> Get the display height of the current message's text.

**Definition**

> getTextHeight()

**Code**

```lua
function HUDPopupMessageMobile:getTextHeight()
    local height = 0
    if self.currentMessage ~ = nil then
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextBold( false )
        setTextWrapWidth( self:getWidth() - 2 * self.borderPaddingX)
        setTextLineHeightScale( HUDPopupMessageMobile.TEXT_LINE_HEIGHT_SCALE)
        height = getTextHeight( self.textSize, self.currentMessage.message)

        setTextWrapWidth( 0 )
        setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE)
    end

    return height
end

```

### getTitleHeight

**Description**

> Get the display height of the current message's title.

**Definition**

> getTitleHeight()

**Code**

```lua
function HUDPopupMessageMobile:getTitleHeight()
    local height = 0
    if self.currentMessage ~ = nil then
        setTextAlignment(RenderText.ALIGN_CENTER)
        setTextBold( false )
        setTextWrapWidth( self:getWidth() - 2 * self.borderPaddingX)
        local title = utf8ToUpper( self.currentMessage.title)
        local lineHeight, numTitleRows = getTextHeight( self.titleTextSize, title)

        height = numTitleRows * lineHeight

        setTextWrapWidth( 0 )
        setTextAlignment(RenderText.ALIGN_LEFT)
    end

    return height
end

```

### getVisible

**Description**

> Get this HUD element's visibility.

**Definition**

> getVisible()

**Code**

```lua
function HUDPopupMessageMobile:getVisible()
    return HUDPopupMessageMobile:superClass().getVisible( self ) and self.currentMessage ~ = nil
end

```

### new

**Description**

> Create a new instance of HUDPopupMessageMobile.

**Definition**

> new(string hudAtlasPath, ingameMap IngameMap)

**Arguments**

| string    | hudAtlasPath | Path to the HUD texture atlas                            |
|-----------|--------------|----------------------------------------------------------|
| ingameMap | IngameMap    | reference used to notify the map when a message is shown |

**Return Values**

| ingameMap | HUDPopupMessageMobile | instance |
|-----------|-----------------------|----------|

**Code**

```lua
function HUDPopupMessageMobile.new(hudAtlasPath, ingameMap)
    local backgroundOverlay = HUDPopupMessageMobile.createBackground(hudAtlasPath)
    local self = HUDPopupMessageMobile:superClass().new(backgroundOverlay, nil , HUDPopupMessageMobile _mt)

    self.ingameMap = ingameMap -- in game map reference required to hide the map when showing a message

    self.pendingMessages = { } -- {i = {<message as defined in showMessage()>}}, ordered as a queue
    self.isCustomInputActive = false -- input state flag
    self.lastInputMode = g_inputBinding:getInputHelpMode()

    self.inputRows = { } -- {i = HUDElement}
    self.inputGlyphs = { } -- {i = InputGlyphElement}, synchronous with self.inputRows
    self.continueGlyph = nil -- InputGlyphElement

    self.time = 0 -- accumulated message display time
    self.isGamePaused = false -- game paused state

    self.continueText = g_i18n:getText( "introduction_continueTextTouch" )

    self:storeScaledValues()
    self:createComponents(hudAtlasPath)

    return self
end

```

### onConfirmMessage

**Description**

> Event function for either InputAction.SKIP\_MESSAGE\_BOX or InputAction.MENU\_ACCEPT.

**Definition**

> onConfirmMessage()

**Arguments**

| any | actionName |
|-----|------------|
| any | inputValue |

**Code**

```lua
function HUDPopupMessageMobile:onConfirmMessage(actionName, inputValue)
    if self.animation:getFinished() then -- callbacks are tied to animation, make sure animation is not active
        if g_touchHandler ~ = nil then
            g_touchHandler:revertCustomContext()
        end

        self:setVisible( false , true )
    end
end

```

### setCurrentMessageHeight

**Description**

> Calculates the total display height of the current message, then sets it via setDimensions()

**Definition**

> setCurrentMessageHeight()

**Code**

```lua
function HUDPopupMessageMobile:setCurrentMessageHeight()
    local reqHeight = self:getTitleHeight() + self:getTextHeight() + self:getInputRowsHeight()
    reqHeight = reqHeight + self.borderPaddingY * 2 + self.textOffsetY + self.titleTextSize + self.textSize
    if # self.currentMessage.controls > 0 then
        reqHeight = reqHeight + self.inputRowsOffsetY
    end

    reqHeight = reqHeight + self.continueButtonHeight

    self:setDimension( self:getWidth(), math.max( self.minHeight, reqHeight))
end

```

### setDimension

**Description**

> Set this HUD element's width and height.

**Definition**

> setDimension()

**Arguments**

| any | width  |
|-----|--------|
| any | height |

**Code**

```lua
function HUDPopupMessageMobile:setDimension(width, height)
    HUDPopupMessageMobile:superClass().setDimension( self , width, height)
end

```

### setInputActive

**Description**

> Enable / disable input events for message confirmation / continuing.

**Definition**

> setInputActive()

**Arguments**

| any | isActive |
|-----|----------|

**Code**

```lua
function HUDPopupMessageMobile:setInputActive(isActive)
    local inputBinding = g_inputBinding

    if not self.isCustomInputActive and isActive then
        inputBinding:setContext( HUDPopupMessageMobile.INPUT_CONTEXT_NAME, true , false )

        local _, eventId = inputBinding:registerActionEvent(InputAction.MENU_ACCEPT, self , self.onConfirmMessage, false , true , false , true )
        inputBinding:setActionEventTextVisibility(eventId, false )

        _, eventId = inputBinding:registerActionEvent(InputAction.SKIP_MESSAGE_BOX, self , self.onConfirmMessage, false , true , false , true )
        inputBinding:setActionEventTextVisibility(eventId, false )

        self.isCustomInputActive = true
    elseif self.isCustomInputActive and not isActive then
            inputBinding:removeActionEventsByTarget( self )
            inputBinding:revertContext( true ) -- revert and clear message context
            self.isCustomInputActive = false
        end
    end

```

### setScale

**Description**

> Set uniform UI scale.

**Definition**

> setScale()

**Arguments**

| any | uiScale |
|-----|---------|

**Code**

```lua
function HUDPopupMessageMobile:setScale(uiScale)
    HUDPopupMessageMobile:superClass().setScale( self , uiScale)
    self:storeScaledValues()

    -- reposition to middle of the screen, because the scale affects the position from bottom left corner
    local posX, posY = HUDPopupMessageMobile.getBackgroundPosition(uiScale)
    local width = self:getWidth()
    self:setPosition(posX - width * 0.5 , posY)
end

```

### showMessage

**Description**

> Show a new message.

**Definition**

> showMessage(string title, string message, integer duration, table? controls, function? callback, table? target)

**Arguments**

| string  | title    | Title text                                                                          |
|---------|----------|-------------------------------------------------------------------------------------|
| string  | message  | Main message text                                                                   |
| integer | duration | Message display duration in milliseconds. If set to 0, will cause the message to be |

displayed for a duration derived from the message length. If set to <0, will cause the message to be displayed
for a very long time. |
| table? | controls | [optional] Array of InputHelpElement instance for input hint row display |
| function? | callback | [optional] Function to be called when the message is acknowledged or expires |
| table? | target | [optional] Callback target which is passed as the first argument to the given callback function |

**Code**

```lua
function HUDPopupMessageMobile:showMessage(title, text, duration, controls, callback, target)
    if duration = = 0 then -- if no duration indicated, adjust duration according to message length
        duration = HUDPopupMessageMobile.MIN_DURATION + string.len(text) * HUDPopupMessageMobile.DURATION_PER_CHARACTER
    elseif duration < 0 then -- a negative duration is adjusted to five minutes("almost" indefinite)
            duration = HUDPopupMessageMobile.MAX_DURATION
        end

        while # self.pendingMessages > HUDPopupMessageMobile.MAX_PENDING_MESSAGE_COUNT do
            table.remove( self.pendingMessages, 1 )
        end

        local message = {
        isDialog = false ,
        title = title,
        message = text,
        duration = duration,
        controls = Utils.getNoNil(controls, { } ),
        callback = callback,
        target = target
        }

        if #message.controls > HUDPopupMessageMobile.MAX_INPUT_ROW_COUNT then -- truncate
            for i = #message.controls, HUDPopupMessageMobile.MAX_INPUT_ROW_COUNT + 1 , - 1 do
                table.remove(message.controls, i)
            end
        end

        table.insert( self.pendingMessages, message)
    end

```

### startMessage

**Description**

> Start displaying a message dequeued from the currently pending messages.
> Sets all required display and input state.

**Definition**

> startMessage()

**Code**

```lua
function HUDPopupMessageMobile:startMessage()
    self.ingameMap:setAllowToggle( false ) -- disable toggle input on map
    self.ingameMap:turnSmall() -- force map size to minimap state

    self:assignCurrentMessage( self.pendingMessages[ 1 ])
    table.remove( self.pendingMessages, 1 )
end

```

### storeScaledValues

**Description**

> Store scaled positioning, size and offset values.

**Definition**

> storeScaledValues()

**Code**

```lua
function HUDPopupMessageMobile:storeScaledValues()
    self.minWidth, self.minHeight = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.SELF)

    self.textOffsetX, self.textOffsetY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.MESSAGE_TEXT)
    self.inputRowsOffsetX, self.inputRowsOffsetY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.INPUT_ROWS)
    self.continueButtonOffsetX, self.continueButtonOffsetY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.CONTINUE_BUTTON)
    self.continueButtonWidth, self.continueButtonHeight = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.CONTINUE_BUTTON)

    self.inputRowWidth, self.inputRowHeight = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.INPUT_ROW)
    self.borderPaddingX, self.borderPaddingY = self:scalePixelToScreenVector( HUDPopupMessageMobile.SIZE.BORDER_PADDING)

    self.inputRowTextX, self.inputRowTextY = self:scalePixelToScreenVector( HUDPopupMessageMobile.POSITION.INPUT_TEXT)

    self.titleTextSize = self:scalePixelToScreenHeight( HUDPopupMessageMobile.TEXT_SIZE.TITLE)
    self.textSize = self:scalePixelToScreenHeight( HUDPopupMessageMobile.TEXT_SIZE.TEXT)
    self.continueTextSize = self:scalePixelToScreenHeight( HUDPopupMessageMobile.TEXT_SIZE.CONTINUE_TEXT)
end

```

### update

**Description**

> Update this element's state.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function HUDPopupMessageMobile:update(dt)
    if not g_gui:getIsMenuVisible() then
        HUDPopupMessageMobile:superClass().update( self , dt)

        if not self.isGamePaused and not g_sleepManager:getIsSleeping() then
            self.time = self.time + dt
            self:updateCurrentMessage()
        end

        if self:getVisible() then
            local inputMode = g_inputBinding:getInputHelpMode()
            if inputMode ~ = self.lastInputMode then
                self.lastInputMode = inputMode
                self:updateButtonGlyphs()

                local isTouch = inputMode = = GS_INPUT_HELP_MODE_TOUCH
                self.continueGlyph:setVisible( not isTouch)
            end
        end
    end
end

```

### updateButtonGlyphs

**Description**

> Update button glyphs when the player input mode has changed.

**Definition**

> updateButtonGlyphs()

**Code**

```lua
function HUDPopupMessageMobile:updateButtonGlyphs()
    if self.continueGlyph ~ = nil then
        self.continueGlyph:setAction(InputAction.SKIP_MESSAGE_BOX, g_i18n:getText( HUDPopupMessageMobile.L10N_SYMBOL.BUTTON_OK), self.continueTextSize, true , false )
    end

    if self.currentMessage ~ = nil then
        local controlIndex = 1
        for i = 1 , HUDPopupMessageMobile.MAX_INPUT_ROW_COUNT do
            local rowIndex = HUDPopupMessageMobile.MAX_INPUT_ROW_COUNT - i + 1
            local inputRowVisible = rowIndex < = # self.currentMessage.controls
            self.inputRows[i]:setVisible(inputRowVisible)

            if inputRowVisible then
                local control = self.currentMessage.controls[controlIndex]
                self.inputGlyphs[i]:setActions(control:getActionNames(), "" , self.textSize, false , false )
                self.inputGlyphs[i]:setKeyboardGlyphColor( HUDPopupMessageMobile.COLOR.INPUT_GLYPH)
                controlIndex = controlIndex + 1
            end
        end
    end
end

```

### updateCurrentMessage

**Description**

> Update the current message.
> Disables this popup when time runs out and dequeues a pending messages for displaying.

**Definition**

> updateCurrentMessage()

**Code**

```lua
function HUDPopupMessageMobile:updateCurrentMessage()
    if self.currentMessage ~ = nil then
        if self.time > self.currentMessage.duration then
            self.time = - math.huge -- clear time to avoid double triggers
            self:setVisible( false , true ) -- animate out
        end
    elseif # self.pendingMessages > 0 then
            self:startMessage()
            self:setVisible( true , true ) -- animate in

            self.animation:addCallback( function ()
                local x, y = self:getPosition()
                g_depthOfFieldManager:pushArea(x, y, self:getWidth(), self:getHeight())
                self.blurAreaActive = true
            end )
        end
    end

```