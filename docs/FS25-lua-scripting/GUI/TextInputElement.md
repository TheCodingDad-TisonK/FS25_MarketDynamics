## TextInputElement

**Description**

> Text input element which captures strings from player input.
> Used layers: "cursor" for a text input cursor icon.
> TODO: IME property docs

**Parent**

> [ButtonElement](?version=script&category=43&class=504)

**Functions**

- [abortIme](#abortime)
- [copyAttributes](#copyattributes)
- [delete](#delete)
- [deleteText](#deletetext)
- [draw](#draw)
- [drawCursor](#drawcursor)
- [drawTextPart](#drawtextpart)
- [finalize](#finalize)
- [getAvailableTextWidth](#getavailabletextwidth)
- [getDoRenderText](#getdorendertext)
- [getIsActive](#getisactive)
- [getIsUnicodeAllowed](#getisunicodeallowed)
- [getNeededTextWidth](#getneededtextwidth)
- [getText](#gettext)
- [inputEvent](#inputevent)
- [keyEvent](#keyevent)
- [limitTextToAvailableWidth](#limittexttoavailablewidth)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [mouseEvent](#mouseevent)
- [moveCursorLeft](#movecursorleft)
- [moveCursorRight](#movecursorright)
- [new](#new)
- [onClose](#onclose)
- [onFocusActivate](#onfocusactivate)
- [onFocusLeave](#onfocusleave)
- [openIme](#openime)
- [reset](#reset)
- [setAlpha](#setalpha)
- [setCaptureInput](#setcaptureinput)
- [setCursorPosition](#setcursorposition)
- [setForcePressed](#setforcepressed)
- [setText](#settext)
- [shouldFocusChange](#shouldfocuschange)
- [stopSpecialKeyRepeating](#stopspecialkeyrepeating)
- [translate](#translate)
- [update](#update)
- [updateVisibleTextElements](#updatevisibletextelements)

### abortIme

**Description**

**Definition**

> abortIme()

**Code**

```lua
function TextInputElement:abortIme()
    if self.useIme and self.imeActive then
        self.imeActive = false
        self.preImeText = ""
        imeAbort()

        g_messageCenter:unsubscribe(MessageType.PAUSE, self )
    end
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
function TextInputElement:copyAttributes(src)
    TextInputElement:superClass().copyAttributes( self , src)

    self.imeKeyboardType = src.imeKeyboardType
    self.imeTitle = src.imeTitle
    self.imeDescription = src.imeDescription
    self.imePlaceholder = src.imePlaceholder

    self.maxCharacters = src.maxCharacters
    self.maxInputTextWidth = src.maxInputTextWidth

    GuiOverlay.copyOverlay( self.cursor, src.cursor)
    self.cursorOffset = table.clone(src.cursorOffset)
    self.cursorSize = table.clone(src.cursorSize)
    self.isPassword = src.isPassword

    self.onEnterCallback = src.onEnterCallback
    self.onTextChangedCallback = src.onTextChangedCallback
    self.onEnterPressedCallback = src.onEnterPressedCallback
    self.onEscPressedCallback = src.onEscPressedCallback
    self.onIsUnicodeAllowedCallback = src.onIsUnicodeAllowedCallback

    self.enterWhenClickOutside = src.enterWhenClickOutside
    self.applyProfanityFilter = src.applyProfanityFilter

    self:finalize()
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function TextInputElement:delete()
    self:abortIme()
    GuiOverlay.deleteOverlay( self.cursor)
    TextInputElement:superClass().delete( self )
end

```

### deleteText

**Description**

**Definition**

> deleteText()

**Arguments**

| any | deleteRightCharacterFromCursor |
|-----|--------------------------------|

**Code**

```lua
function TextInputElement:deleteText(deleteRightCharacterFromCursor)
    local textLength = utf8Strlen( self.text)

    if textLength > 0 then
        local canDelete = false
        local deleteOffset

        if deleteRightCharacterFromCursor then
            if self.cursorPosition < = textLength then
                canDelete = true
                deleteOffset = 0
            end
        else
                if self.cursorPosition > 1 then
                    canDelete = true
                    deleteOffset = - 1
                end
            end

            if canDelete then
                self.text =
                ((( self.cursorPosition + deleteOffset) > 1 ) and utf8Substr( self.text, 0 , self.cursorPosition + deleteOffset - 1 ) or "" ) ..
                ((( self.cursorPosition + deleteOffset) < textLength) and utf8Substr( self.text, self.cursorPosition + deleteOffset, - 1 ) or "" )

                self.cursorPosition = self.cursorPosition + deleteOffset

                self:raiseCallback( "onTextChangedCallback" , self , self.text)
            end
        end
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
function TextInputElement:draw(clipX1, clipY1, clipX2, clipY2)
    -- call ancestor drawing functions with empty text:
    local text = self.text
    self.text = ""
    TextInputElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
    self.text = text

    setTextAlignment( self.textAlignment)
    local neededWidth = self:getNeededTextWidth()

    local textXPos = self.absPosition[ 1 ] + self.textOffset[ 1 ]
    if self.textAlignment = = RenderText.ALIGN_CENTER then
        textXPos = textXPos + ( self.maxInputTextWidth * 0.5 ) - (neededWidth * 0.5 )
    elseif self.textAlignment = = RenderText.ALIGN_RIGHT then
            textXPos = textXPos + self.maxInputTextWidth - neededWidth
        end
        textXPos = textXPos + ( self.size[ 1 ] - self.maxInputTextWidth) / 2

        local _, yOffset = self:getTextOffset()
        local _, yPos = self:getTextPosition( self.text)
        local textYPos = yPos + yOffset

        if clipX1 ~ = nil then
            setTextClipArea(clipX1, clipY1, clipX2, clipY2)
        end

        local displacementX = 0
        if self.areFrontDotsVisible then
            local additionalDisplacement = self:drawTextPart( self.frontDotsText, textXPos, displacementX, textYPos)
            displacementX = displacementX + additionalDisplacement
        end
        if self.isVisibleTextPart1Visible then
            local additionalDisplacement = self:drawTextPart( self.visibleTextPart1, textXPos, displacementX, textYPos)
            displacementX = displacementX + additionalDisplacement
        end
        if self.isCursorVisible then
            local additionalDisplacement = self:drawCursor(textXPos, displacementX, textYPos)
            displacementX = displacementX + additionalDisplacement
        end
        if self.isVisibleTextPart2Visible then
            local additionalDisplacement = self:drawTextPart( self.visibleTextPart2, textXPos, displacementX, textYPos)
            displacementX = displacementX + additionalDisplacement
        end

        if self.areBackDotsVisible then
            self:drawTextPart( self.backDotsText, textXPos, displacementX, textYPos)
        end

        setTextBold( false )
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextColor( 1 , 1 , 1 , 1 )

        if clipX1 ~ = nil then
            setTextClipArea( 0 , 0 , 1 , 1 )
        end
    end

```

### drawCursor

**Description**

**Definition**

> drawCursor()

**Arguments**

| any | textXPos      |
|-----|---------------|
| any | displacementX |
| any | textYPos      |

**Code**

```lua
function TextInputElement:drawCursor(textXPos, displacementX, textYPos)
    if self.cursorBlinkTime < self.cursorBlinkInterval then
        local x = textXPos + displacementX + self.cursorOffset[ 1 ]
        x = math.floor(x / g_pixelSizeX) * (g_pixelSizeX)
        GuiOverlay.renderOverlay( self.cursor, x, textYPos + self.cursorOffset[ 2 ], self.cursorSize[ 1 ], self.cursorSize[ 2 ])
    end

    return self.cursorNeededSize[ 1 ]
end

```

### drawTextPart

**Description**

**Definition**

> drawTextPart()

**Arguments**

| any | text          |
|-----|---------------|
| any | textXPos      |
| any | displacementX |
| any | textYPos      |

**Code**

```lua
function TextInputElement:drawTextPart(text, textXPos, displacementX, textYPos)
    local textWidth = 0
    if text ~ = "" then
        setTextBold( self.textBold)
        textWidth = getTextWidth( self.textSize, text)
        local alignmentDisplacement = 0
        if self.textAlignment = = RenderText.ALIGN_CENTER then
            alignmentDisplacement = textWidth * 0.5
        elseif self.textAlignment = = RenderText.ALIGN_RIGHT then
                alignmentDisplacement = textWidth
            end

            if self.text2Size > 0 then
                setTextBold( self.text2Bold)
                setTextColor( unpack( self:getText2Color()))
                renderText(textXPos + alignmentDisplacement + displacementX + ( self.text2Offset[ 1 ] - self.textOffset[ 1 ]), textYPos + ( self.text2Offset[ 2 ] - self.textOffset[ 2 ]), self.text2Size, text)
            end

            setTextBold( self.textBold)
            setTextColor( unpack( self:getTextColor()))
            renderText(textXPos + alignmentDisplacement + displacementX, textYPos, self.textSize, text)
        end
        return textWidth
    end

```

### finalize

**Description**

**Definition**

> finalize()

**Code**

```lua
function TextInputElement:finalize()
    self.cursorNeededSize = {
    self.cursorOffset[ 1 ] + self.cursorSize[ 1 ],
    self.cursorOffset[ 2 ] + self.cursorSize[ 2 ]
    }

    if not self.maxInputTextWidth and( self.textAlignment = = RenderText.ALIGN_CENTER or self.textAlignment = = RenderText.ALIGN_RIGHT) then
        Logging.error(' TextInputElement loading using "center" or "right" alignment requires specification of "maxInputTextWidth" ')
    end

    if self.maxInputTextWidth and self.maxInputTextWidth < = (getTextWidth( self.textSize, self.frontDotsText) + self.cursorNeededSize[ 1 ] + getTextWidth( self.textSize, self.backDotsText)) then
        Logging.warning(' TextInputElement loading specified "maxInputTextWidth" is too small( % .4f) to display needed data', self.maxInputTextWidth)
    end
end

```

### getAvailableTextWidth

**Description**

**Definition**

> getAvailableTextWidth()

**Code**

```lua
function TextInputElement:getAvailableTextWidth()
    if not self.maxInputTextWidth then
        return nil
    end

    local availableTextWidth = self.maxInputTextWidth

    if self.areFrontDotsVisible then
        availableTextWidth = availableTextWidth - getTextWidth( self.textSize, self.frontDotsText)
    end

    if self.isCursorVisible then
        availableTextWidth = availableTextWidth - self.cursorNeededSize[ 1 ]
    end

    if self.areBackDotsVisible then
        availableTextWidth = availableTextWidth - getTextWidth( self.textSize, self.backDotsText)
    end

    return availableTextWidth
end

```

### getDoRenderText

**Description**

**Definition**

> getDoRenderText()

**Code**

```lua
function TextInputElement:getDoRenderText()
    return false
end

```

### getIsActive

**Description**

**Definition**

> getIsActive()

**Code**

```lua
function TextInputElement:getIsActive()
    return GuiElement.getIsActive( self ) -- parent type ButtonElement behaves incompatibly, use the base method
end

```

### getIsUnicodeAllowed

**Description**

**Definition**

> getIsUnicodeAllowed()

**Arguments**

| any | unicode |
|-----|---------|

**Code**

```lua
function TextInputElement:getIsUnicodeAllowed(unicode)
    if unicode = = 13 or unicode = = 10 then
        return false
    end
    if not getCanRenderUnicode(unicode) then
        return false
    end

    return Utils.getNoNil( self:raiseCallback( "onIsUnicodeAllowedCallback" , unicode), true )
end

```

### getNeededTextWidth

**Description**

**Definition**

> getNeededTextWidth()

**Code**

```lua
function TextInputElement:getNeededTextWidth()
    local neededWidth = 0
    if self.areFrontDotsVisible then
        neededWidth = neededWidth + getTextWidth( self.textSize, self.frontDotsText)
    end

    if self.isVisibleTextPart1Visible then
        neededWidth = neededWidth + getTextWidth( self.textSize, self.visibleTextPart1)
    end

    if self.isCursorVisible then
        neededWidth = neededWidth + self.cursorNeededSize[ 1 ]
    end

    if self.isVisibleTextPart2Visible then
        neededWidth = neededWidth + getTextWidth( self.textSize, self.visibleTextPart2)
    end

    if self.areBackDotsVisible then
        neededWidth = neededWidth + getTextWidth( self.textSize, self.backDotsText)
    end

    return neededWidth
end

```

### getText

**Description**

> Get text

**Definition**

> getText()

**Code**

```lua
function TextInputElement:getText()
    return self.text
end

```

### inputEvent

**Description**

> Handle GUI input events.
> Reacts to confirmation and cancel actions. Also see GuiElement.inputEvent().

**Definition**

> inputEvent()

**Arguments**

| any | action    |
|-----|-----------|
| any | value     |
| any | eventUsed |

**Code**

```lua
function TextInputElement:inputEvent(action, value, eventUsed)
    -- break inheritance from ButtonElement, text input needs custom logic
    if self.blockTime < = 0 then
        if not self.imeActive and self:getIsActive() and self.forcePressed then
            if action = = InputAction.MENU_ACCEPT then
                if self.forcePressed then
                    self:setForcePressed( false )
                else
                        self:setForcePressed( true )
                    end
                    self:raiseCallback( "onEnterPressedCallback" , self )
                    eventUsed = true
                elseif action = = InputAction.MENU_CANCEL or action = = InputAction.MENU_BACK then
                        if self.forcePressed then
                            self:setForcePressed( false )
                        else
                                self:setForcePressed( true )
                            end
                            self:raiseCallback( "onEscPressedCallback" , self )
                            eventUsed = true
                        end
                    end
                end

                return eventUsed
            end

```

### keyEvent

**Description**

**Definition**

> keyEvent()

**Arguments**

| any | unicode   |
|-----|-----------|
| any | sym       |
| any | modifier  |
| any | isDown    |
| any | eventUsed |

**Code**

```lua
function TextInputElement:keyEvent(unicode, sym, modifier, isDown, eventUsed)
    if TextInputElement:superClass().keyEvent( self , unicode, sym, modifier, isDown, eventUsed) then
        eventUsed = true
    end

    if self.isRepeatingSpecialKeyDown and not isDown and self.repeatingSpecialKeySym = = sym then
        self:stopSpecialKeyRepeating()
    end

    if self.blockTime < = 0 and self:getIsActive() and self.forcePressed then
        local wasSpecialKey = false

        if not isDown then
            -- react to input state-changing keys on key "up" to avoid double inputs in the menu
            if (sym = = Input.KEY_ return or sym = = Input.KEY_KP_enter) and self.isReturnDown then
                self.isReturnDown = false
                self:setForcePressed( not self.forcePressed)
                self:raiseCallback( "onEnterPressedCallback" , self )
            elseif sym = = Input.KEY_esc then
                    self.isEscDown = false
                    self:setForcePressed( not self.forcePressed)
                    self:raiseCallback( "onEscPressedCallback" , self )
                end
            else
                    local lctrlModifier = Input.MOD_LCTRL
                    if GS_PLATFORM_ID = = PlatformId.MAC then
                        lctrlModifier = Input.MOD_LMETA
                    end

                    local startSpecialKeyRepeating = false
                    if sym = = Input.KEY_left then
                        -- is now handled by Focus system
                        self:moveCursorLeft(bit32.band(modifier, lctrlModifier) > 0 )
                        startSpecialKeyRepeating = true
                        wasSpecialKey = true
                    elseif sym = = Input.KEY_right then
                            -- is now handled by focus system
                            self:moveCursorRight(bit32.band(modifier, lctrlModifier) > 0 )
                            startSpecialKeyRepeating = true
                            wasSpecialKey = true
                        elseif sym = = Input.KEY_home then
                                self.cursorPosition = 1
                                wasSpecialKey = true
                            elseif sym = = Input.KEY_ end then
                                self.cursorPosition = utf8Strlen( self.text) + 1
                                wasSpecialKey = true
                            elseif sym = = Input.KEY_delete then
                                    self:deleteText( true )
                                    startSpecialKeyRepeating = true
                                    wasSpecialKey = true
                                elseif sym = = Input.KEY_backspace then
                                        -- if ctrl + backspace is pressed, we delete characters from the back until we reach a whitespace
                                            if bit32.band(modifier, lctrlModifier) > 0 then
                                                if self.isPassword then
                                                    --if password always delete whole text
                                                        self:setText( "" )
                                                    else
                                                            -- delete characters from the back until we reach a whitespace, if no whitespace is present remove everything
                                                                local textLeftOfCursor = utf8Substr( self:getText(), 0 , self.cursorPosition - 1 ) or ""
                                                                local textRightOfCursor = utf8Substr( self:getText(), self.cursorPosition - 1 ) or ""

                                                                local text = string.rtrim(textLeftOfCursor)
                                                                local lastSpacePos = string.findLast(text, " " )

                                                                local newText = utf8Substr(text, 0 , lastSpacePos)
                                                                local cursorPosition = self.cursorPosition
                                                                self:setText(newText .. textRightOfCursor)
                                                                self.cursorPosition = cursorPosition - (utf8Strlen(textLeftOfCursor) - utf8Strlen(newText))

                                                                --onTextChanged callback is usually called by deleteText(), since we dont use that function in this case we need to call it here
                                                                    self:raiseCallback( "onTextChangedCallback" , self , self.text)
                                                                end
                                                            else
                                                                    self:deleteText( false )
                                                                end

                                                                startSpecialKeyRepeating = true
                                                                wasSpecialKey = true
                                                            elseif sym = = Input.KEY_esc then
                                                                    self.isEscDown = true
                                                                    wasSpecialKey = true
                                                                elseif sym = = Input.KEY_ return or sym = = Input.KEY_KP_enter then
                                                                        self.isReturnDown = true
                                                                        wasSpecialKey = true
                                                                    elseif sym = = Input.KEY_v and bit32.band(modifier, lctrlModifier) > 0 then
                                                                            local clipboardText = localGetClipboard()
                                                                            self:setText( self:getText() .. clipboardText)
                                                                            wasSpecialKey = true
                                                                        end

                                                                        if startSpecialKeyRepeating then
                                                                            self.isRepeatingSpecialKeyDown = true
                                                                            self.repeatingSpecialKeySym = sym
                                                                            self.repeatingSpecialKeyDelayTime = TextInputElement.INITIAL_REPEAT_DELAY
                                                                            self.repeatingSpecialKeyRemainingDelayTime = self.repeatingSpecialKeyDelayTime
                                                                        end

                                                                        if not wasSpecialKey then
                                                                            if self:getIsUnicodeAllowed(unicode) then
                                                                                local textLength = utf8Strlen( self.text)
                                                                                if self.maxCharacters = = nil or textLength < self.maxCharacters then
                                                                                    self.text =
                                                                                    (( self.cursorPosition > 1 ) and utf8Substr( self.text, 0 , self.cursorPosition - 1 ) or "" ) ..
                                                                                    unicodeToUtf8(unicode) ..
                                                                                    (( self.cursorPosition < = textLength) and utf8Substr( self.text, self.cursorPosition - 1 ) or "" )

                                                                                    self.cursorPosition = self.cursorPosition + 1

                                                                                    self:raiseCallback( "onTextChangedCallback" , self , self.text)
                                                                                end
                                                                            end
                                                                        end

                                                                        self:updateVisibleTextElements()

                                                                        eventUsed = true
                                                                    end
                                                                end

                                                                return eventUsed
                                                            end

```

### limitTextToAvailableWidth

**Description**

**Definition**

> limitTextToAvailableWidth()

**Arguments**

| any | text           |
|-----|----------------|
| any | textSize       |
| any | availableWidth |
| any | trimFront      |

**Code**

```lua
function TextInputElement.limitTextToAvailableWidth(text, textSize, availableWidth, trimFront)
    local resultingText = text
    local indexOfFirstCharacter = 0
    local indexOfLastCharacter = utf8Strlen(text)

    if availableWidth then
        if trimFront then
            while getTextWidth(textSize, resultingText) > availableWidth do
                --print("1a limiting text: " .. resultingText)
                resultingText = utf8Substr(resultingText, 1 )
                indexOfFirstCharacter = indexOfFirstCharacter + 1
                --print("1b limiting text: " .. resultingText)
            end
        else
                local textLength = utf8Strlen(resultingText)
                while getTextWidth(textSize, resultingText) > availableWidth do
                    --print("2a limiting text: " .. resultingText)
                    textLength = textLength - 1
                    resultingText = utf8Substr(resultingText, 0 , textLength)
                    indexOfLastCharacter = indexOfLastCharacter - 1
                    --print("2b limiting text: " .. resultingText)
                end
            end
        end

        return resultingText, indexOfFirstCharacter, indexOfLastCharacter
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
function TextInputElement:loadFromXML(xmlFile, key)
    TextInputElement:superClass().loadFromXML( self , xmlFile, key)

    self:addCallback(xmlFile, key .. "#onEnter" , "onEnterCallback" )
    self:addCallback(xmlFile, key .. "#onTextChanged" , "onTextChangedCallback" )
    self:addCallback(xmlFile, key .. "#onEnterPressed" , "onEnterPressedCallback" )
    self:addCallback(xmlFile, key .. "#onEscPressed" , "onEscPressedCallback" )
    self:addCallback(xmlFile, key .. "#onIsUnicodeAllowed" , "onIsUnicodeAllowedCallback" )

    self.imeKeyboardType = getXMLString(xmlFile, key .. "#imeKeyboardType" ) or self.imeKeyboardType
    self.imeTitle = self:translate(getXMLString(xmlFile, key .. "#imeTitle" ))
    self.imeDescription = self:translate(getXMLString(xmlFile, key .. "#imeDescription" ))
    self.imePlaceholder = self:translate(getXMLString(xmlFile, key .. "#imePlaceholder" ))

    self.maxCharacters = getXMLInt(xmlFile, key .. "#maxCharacters" ) or self.maxCharacters
    self.maxInputTextWidth = GuiUtils.getNormalizedXValue(getXMLString(xmlFile, key .. "#maxInputTextWidth" ), self.maxInputTextWidth)
    self.cursorOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#cursorOffset" ), self.cursorOffset)
    self.cursorSize = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#cursorSize" ), self.cursorSize)

    if g_screenWidth > 1 then
        self.cursorSize[ 1 ] = math.max( self.cursorSize[ 1 ], g_pixelSizeX)
    end

    self.enterWhenClickOutside = Utils.getNoNil(getXMLBool(xmlFile, key .. "#enterWhenClickOutside" ), self.enterWhenClickOutside)
    self.applyProfanityFilter = Utils.getNoNil(getXMLBool(xmlFile, key .. "#applyProfanityFilter" ), self.applyProfanityFilter)

    GuiOverlay.loadOverlay( self , self.cursor, "cursor" , self.imageSize, nil , xmlFile, key)
    GuiOverlay.createOverlay( self.cursor)

    self.isPassword = Utils.getNoNil(getXMLBool(xmlFile, key .. "#isPassword" ), self.isPassword)

    self:finalize()
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
function TextInputElement:loadProfile(profile, applyProfile)
    TextInputElement:superClass().loadProfile( self , profile, applyProfile)

    self.maxCharacters = profile:getNumber( "maxCharacters" , self.maxCharacters)
    self.maxInputTextWidth = GuiUtils.getNormalizedXValue(profile:getValue( "maxInputTextWidth" ), self.maxInputTextWidth)
    self.cursorOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "cursorOffset" ), self.cursorOffset)
    self.cursorSize = GuiUtils.getNormalizedScreenValues(profile:getValue( "cursorSize" ), self.cursorSize)
    self.isPassword = profile:getBool( "isPassword" , self.isPassword)
    self.cursorImageSize = GuiUtils.getNormalizedValues(profile:getValue( "cursorImageSize" ), self.outputSize, self.imageSize)

    self.applyProfanityFilter = profile:getBool( "applyProfanityFilter" , self.applyProfanityFilter)

    GuiOverlay.loadOverlay( self , self.cursor, "cursor" , self.cursorImageSize, profile, nil , nil )

    if g_screenWidth > 1 then
        self.cursorSize[ 1 ] = math.max( self.cursorSize[ 1 ], g_pixelSizeX)
    end

    self:finalize()
end

```

### mouseEvent

**Description**

**Definition**

> mouseEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | button    |
| any | eventUsed |

**Code**

```lua
function TextInputElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if self:getIsActive() then
        local isCursorInside = GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ], self.absPosition[ 2 ], self.size[ 1 ], self.size[ 2 ])

        if not self.forcePressed then
            if not eventUsed and isCursorInside and not FocusManager:isLocked() then
                FocusManager:setHighlight( self )

                eventUsed = true

                if isDown and button = = Input.MOUSE_BUTTON_LEFT then
                    self.textInputMouseDown = true

                    if not self.useIme then
                        self:setForcePressed( true )
                    end
                end

                if isUp and button = = Input.MOUSE_BUTTON_LEFT and self.textInputMouseDown then
                    self.textInputMouseDown = false

                    self:setForcePressed( true )
                    if self.useIme then
                        self:openIme()
                    end
                end
            else
                    if (isDown and button = = Input.MOUSE_BUTTON_LEFT) or self.textInputMouseDown or not self.forcePressed then
                        FocusManager:unsetHighlight( self )
                    end

                    self.textInputMouseDown = false
                end
            else
                    if not isCursorInside and isUp and button = = Input.MOUSE_BUTTON_LEFT then
                        self:setForcePressed( false )

                        if self.enterWhenClickOutside then
                            -- Dismiss when clicking outside of the box
                            self:abortIme()
                            self:raiseCallback( "onEnterPressedCallback" , self , true )
                        end
                    end
                end

                if not eventUsed then
                    eventUsed = TextInputElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, button, eventUsed)
                end
            end

            return eventUsed
        end

```

### moveCursorLeft

**Description**

**Definition**

> moveCursorLeft()

**Arguments**

| any | isLeftCtrlPressed |
|-----|-------------------|

**Code**

```lua
function TextInputElement:moveCursorLeft(isLeftCtrlPressed)
    if isLeftCtrlPressed then
        local textBeforeCursor = utf8Substr( self:getText(), 0 , self.cursorPosition - 1 )
        textBeforeCursor = string.rtrim(textBeforeCursor)
        local lastSpacePos = string.findLast(textBeforeCursor, " " )

        if lastSpacePos ~ = nil then
            self:setCursorPosition(lastSpacePos + 1 )
        else
                self:setCursorPosition( 1 )
            end

            return
        end

        self:setCursorPosition( self.cursorPosition - 1 )
    end

```

### moveCursorRight

**Description**

**Definition**

> moveCursorRight()

**Arguments**

| any | isLeftCtrlPressed |
|-----|-------------------|

**Code**

```lua
function TextInputElement:moveCursorRight(isLeftCtrlPressed)
    if isLeftCtrlPressed then
        local nextSpacePos = string.find( self:getText(), " " , self.cursorPosition)
        local nextNonSpacePos = nextSpacePos ~ = nil and string.find( self:getText(), "%w" , nextSpacePos) or math.huge

        if nextNonSpacePos ~ = nil then
            self:setCursorPosition(nextNonSpacePos)
            return
        end
    end

    self:setCursorPosition( self.cursorPosition + 1 )
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
function TextInputElement.new(target, custom_mt)
    local self = ButtonElement.new(target, custom_mt or TextInputElement _mt)

    self.textInputMouseDown = false
    self.forcePressed = false
    self.isPassword = false
    self.displayText = "" -- actually displayed text, masked if this is a password input field
        self.cursor = { }
        self.cursorBlinkTime = 0
        self.cursorBlinkInterval = 400
        self.cursorOffset = { 0 , 0 }
        self.cursorSize = { 0.0016 , 0.018 }
        self.cursorNeededSize = {
        self.cursorOffset[ 1 ] + self.cursorSize[ 1 ],
        self.cursorOffset[ 2 ] + self.cursorSize[ 2 ]
        }
        self.cursorPosition = 1
        self.firstVisibleCharacterPosition = 1
        self.lastVisibleCharacterPosition = 1
        self.maxCharacters = nil
        self.maxInputTextWidth = nil
        self.frontDotsText = " .. ."
        self.backDotsText = " .. ."
        self.text = ""
        self.useIme = imeIsSupported()
        self.preImeText = ""
        self.imeActive = false
        self.blockTime = 0

        self.isReturnDown = false
        self.isEscDown = false
        self.isCapturingInput = false
        self.hadFocusOnCapture = false
        self.enterWhenClickOutside = true
        self.applyProfanityFilter = nil --default:true

        -- Handle hightlight on focused elements differently:if highlight is removed,
            -- do not change focus.
                self.disallowFocusedHighlight = true

                self.imeKeyboardType = "normal"

                self.forceFocus = true

                self.customFocusSample = GuiSoundPlayer.SOUND_SAMPLES.TEXTBOX

                return self
            end

```

### onClose

**Description**

**Definition**

> onClose()

**Code**

```lua
function TextInputElement:onClose()
    TextInputElement:superClass().onClose( self )
    -- makes sure that the input mode is disabled when clicking directly on a "back" button while text input is active
        self:abortIme()
        self:setForcePressed( false )
    end

```

### onFocusActivate

**Description**

**Definition**

> onFocusActivate()

**Code**

```lua
function TextInputElement:onFocusActivate()
    if self.blockTime < = 0 then
        TextInputElement:superClass().onFocusActivate( self )
        self:raiseCallback( "onEnterCallback" , self )

        if self.forcePressed then
            self:abortIme()
            -- deactivate input
            self:setForcePressed( false )
            self:raiseCallback( "onEnterPressedCallback" , self )
        else
                self:openIme()
                self:setForcePressed( true )
            end
        end
    end

```

### onFocusLeave

**Description**

**Definition**

> onFocusLeave()

**Code**

```lua
function TextInputElement:onFocusLeave()
    self:abortIme()
    self:setForcePressed( false )
    TextInputElement:superClass().onFocusLeave( self )
end

```

### openIme

**Description**

**Definition**

> openIme()

**Code**

```lua
function TextInputElement:openIme()
    if self.useIme and imeOpen( self.text, self.imeTitle or "" , self.imeDescription or "" , self.imePlaceholder or "" , self.imeKeyboardType or "normal" , Utils.getNoNil( self.maxCharacters, 512 ), self.absPosition[ 1 ], self.absPosition[ 2 ], self.size[ 1 ], self.size[ 2 ]) then
        self.imeActive = true
        self.preImeText = self.text
        g_messageCenter:subscribe(MessageType.PAUSE, self.onPauseChanged, self )

        return true
    end

    return false
end

```

### reset

**Description**

**Definition**

> reset()

**Code**

```lua
function TextInputElement:reset()
    TextInputElement:superClass().reset( self )

    if self.isRepeatingSpecialKeyDown then
        self:stopSpecialKeyRepeating()
    end
end

```

### setAlpha

**Description**

**Definition**

> setAlpha()

**Arguments**

| any | alpha |
|-----|-------|

**Code**

```lua
function TextInputElement:setAlpha(alpha)
    TextInputElement:superClass().setAlpha( self , alpha)
    if self.cursor ~ = nil then
        self.cursor.alpha = self.alpha
    end
end

```

### setCaptureInput

**Description**

> Set input capturing state.
> When capturing, the standard input bindings are disabled (input context switch).

**Definition**

> setCaptureInput()

**Arguments**

| any | isCapturing |
|-----|-------------|

**Code**

```lua
function TextInputElement:setCaptureInput(isCapturing)
    self.blockTime = 200
    if not self.isCapturingInput and isCapturing then
        -- reset control key flags to avoid immediately returning out of edit mode:
        self.isReturnDown = false
        self.isEscDown = false

        self.target:disableInputForDuration( 0 )

        if TextInputElement.inputContextActive then
            -- Special case handling for mouse click activation of text input elements.Because of the call order,
                -- another text element may previously have been active when this one has been activated by click.Avoid
                -- corrupting the input context by reverting here first.
                g_inputBinding:revertContext( true )
            end

            g_inputBinding:setContext( TextInputElement.INPUT_CONTEXT_NAME, true , false )
            TextInputElement.inputContextActive = true

            if not GS_IS_CONSOLE_VERSION then
                -- Special case handling for gaming stations which do not have keyboards available for players:
                    -- Register menu back and accept actions so players can exit text boxes with gamepads using either input,
                    -- by default bound to buttons "A" for accept and "B" for back.
                        g_inputBinding:registerActionEvent(InputAction.MENU_BACK, self , self.inputEvent, false , true , false , true )
                        g_inputBinding:registerActionEvent(InputAction.MENU_ACCEPT, self , self.inputEvent, false , true , false , true )
                    end

                    self.isCapturingInput = true
                elseif self.isCapturingInput and not isCapturing then
                        if TextInputElement.inputContextActive then
                            -- Special case handling for mouse click activation of text input elements.Ensure to avoid double reverts
                                -- when switching from one text input to another.
                                g_inputBinding:revertContext( true ) -- revert and clear text input context
                                TextInputElement.inputContextActive = false
                            end

                            self.target:disableInputForDuration( 200 )
                            self.isCapturingInput = false

                            if not self.isPassword and self.applyProfanityFilter ~ = false then
                                local baseText = self.text
                                local filteredText = filterText(baseText, true , true )

                                if baseText ~ = "" and baseText ~ = filteredText then
                                    self:setText(filteredText)
                                end
                            end
                        end
                    end

```

### setCursorPosition

**Description**

**Definition**

> setCursorPosition()

**Arguments**

| any | position |
|-----|----------|

**Code**

```lua
function TextInputElement:setCursorPosition(position)
    self.cursorPosition = math.max( 1 , math.min(utf8Strlen( self.text) + 1 , position))
end

```

### setForcePressed

**Description**

**Definition**

> setForcePressed()

**Arguments**

| any | force |
|-----|-------|

**Code**

```lua
function TextInputElement:setForcePressed(force)
    if force then
        self.hadFocusOnCapture = self:getIsFocused()
        self:setCaptureInput( true )
    else
            self:setCaptureInput( false )
        end

        self.forcePressed = force
        if self.forcePressed then
            FocusManager:setFocus( self )
        else
                --focusEnter/Leave functions are called directly instead of via the FocusManager and of the super class to avoid an infinite loop
                if self.hadFocusOnCapture then
                    FocusManager:setFocus( self )
                    TextInputElement:superClass().onFocusEnter( self )
                else
                        self:setFocused( false )
                        TextInputElement:superClass().onFocusLeave( self )
                    end
                    self.hadFocusOnCapture = false
                end

                if self.isRepeatingSpecialKeyDown then
                    self:stopSpecialKeyRepeating()
                end

                self:updateVisibleTextElements()
            end

```

### setText

**Description**

**Definition**

> setText()

**Arguments**

| any | text |
|-----|------|

**Code**

```lua
function TextInputElement:setText(text)
    local textLength = utf8Strlen(text)
    if self.maxCharacters and textLength > self.maxCharacters then
        text = utf8Substr(text, 0 , self.maxCharacters)
        textLength = utf8Strlen(text)
    end

    TextInputElement:superClass().setText( self , text)

    self.cursorPosition = textLength + 1
    self:updateVisibleTextElements()
end

```

### shouldFocusChange

**Description**

> Focus methods

**Definition**

> shouldFocusChange()

**Arguments**

| any | direction |
|-----|-----------|

**Code**

```lua
function TextInputElement:shouldFocusChange(direction)
    return not self.forcePressed
end

```

### stopSpecialKeyRepeating

**Description**

**Definition**

> stopSpecialKeyRepeating()

**Code**

```lua
function TextInputElement:stopSpecialKeyRepeating()
    self.isRepeatingSpecialKeyDown = false
    self.repeatingSpecialKeySym = nil
    self.repeatingSpecialKeyDelayTime = nil
    self.repeatingSpecialKeyRemainingDelayTime = nil
end

```

### translate

**Description**

**Definition**

> translate()

**Arguments**

| any | str |
|-----|-----|

**Code**

```lua
function TextInputElement:translate(str)
    if str then
        str = g_i18n:convertText(str)
    end
    return str
end

```

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function TextInputElement:update(dt)
    TextInputElement:superClass().update( self , dt)

    self.cursorBlinkTime = self.cursorBlinkTime + dt
    while self.cursorBlinkTime > 2 * self.cursorBlinkInterval do
        self.cursorBlinkTime = self.cursorBlinkTime - 2 * self.cursorBlinkInterval
    end

    if self.isRepeatingSpecialKeyDown then
        self.repeatingSpecialKeyRemainingDelayTime = self.repeatingSpecialKeyRemainingDelayTime - dt
        if self.repeatingSpecialKeyRemainingDelayTime < = 0 then
            if self.repeatingSpecialKeySym = = Input.KEY_left then
                self:moveCursorLeft()
            elseif self.repeatingSpecialKeySym = = Input.KEY_right then
                    self:moveCursorRight()
                elseif self.repeatingSpecialKeySym = = Input.KEY_delete then
                        self:deleteText( true )
                    elseif self.repeatingSpecialKeySym = = Input.KEY_backspace then
                            self:deleteText( false )
                        end
                        self:updateVisibleTextElements()

                        -- reduce key delay each frame down to the minimum to accelerate input when holding control keys
                        self.repeatingSpecialKeyDelayTime = math.max( TextInputElement.MIN_REPEAT_DELAY, ( self.repeatingSpecialKeyDelayTime or TextInputElement.INITIAL_REPEAT_DELAY) * ( 0.1 ^ (dt / 100 )))
                        self.repeatingSpecialKeyRemainingDelayTime = self.repeatingSpecialKeyDelayTime
                    end
                end
                if self.useIme and self.imeActive then
                    local done,cancel = imeIsComplete()
                    if done then
                        self.imeActive = false

                        self:setForcePressed( false )
                        if not cancel then
                            self:setText(imeGetLastString())
                            self:raiseCallback( "onEnterPressedCallback" , self )
                        else
                                self:setText( self.preImeText)
                                self.preImeText = ""
                                self:raiseCallback( "onEscPressedCallback" , self )
                            end
                        else
                                self:setText(imeGetLastString())
                                self:setCursorPosition(imeGetCursorPos() + 1 )
                                self:updateVisibleTextElements()
                            end
                        end

                        if self.blockTime > 0 then
                            self.blockTime = self.blockTime - dt
                        end
                    end

```

### updateVisibleTextElements

**Description**

**Definition**

> updateVisibleTextElements()

**Code**

```lua
function TextInputElement:updateVisibleTextElements()
    self.isCursorVisible = false
    self.isVisibleTextPart1Visible = false
    self.visibleTextPart1 = ""
    self.isVisibleTextPart2Visible = false
    self.visibleTextPart2 = ""

    self.areFrontDotsVisible = false
    self.areBackDotsVisible = false

    self.firstVisibleCharacterPosition = 1

    setTextBold( self.textBold)

    local displayText = self.text
    if self.isPassword then
        displayText = string.rep( "*" , utf8Strlen( self.text))
    end

    local textLength = utf8Strlen(displayText)
    local availableTextWidth = self:getAvailableTextWidth()

    if self:getIsActive() and self.forcePressed then
        -- input is gathered, cursor is shown,
        -- text is displayed at an arbitrary position, both additonal text markers may be displayed

        self.isCursorVisible = true

        if self.cursorPosition < self.firstVisibleCharacterPosition then
            -- cursor was moved to the left to display additional text
            self.firstVisibleCharacterPosition = self.cursorPosition
        end

        if self.firstVisibleCharacterPosition > 1 then
            self.areFrontDotsVisible = true
        end

        local textInvisibleFrontTrimmed = utf8Substr(displayText, self.firstVisibleCharacterPosition - 1 )
        local textWidthInvisibleFrontTrimmed = getTextWidth( self.textSize, textInvisibleFrontTrimmed)
        availableTextWidth = self:getAvailableTextWidth()

        if availableTextWidth and textWidthInvisibleFrontTrimmed > availableTextWidth then
            -- not all text fits into the visible area
            if self.cursorPosition < = textLength then
                -- the cursor is not at the last position of the text
                --self.isBackAdditionalTextMarkerVisible = true
                self.areBackDotsVisible = true
                availableTextWidth = self:getAvailableTextWidth()
            end
        end

        local visibleText = TextInputElement.limitTextToAvailableWidth(textInvisibleFrontTrimmed, self.textSize, availableTextWidth)
        local visibleTextWidth = getTextWidth( self.textSize, visibleText)
        local visibleTextLength = utf8Strlen(visibleText)

        if availableTextWidth and self.cursorPosition > self.firstVisibleCharacterPosition + visibleTextLength then
            -- the cursor is on the right side and not visible anymore
            -- text has to be shifted for the cursor to become visible again
                --self.isFrontAdditionalTextMarkerVisible = true
                self.areFrontDotsVisible = true
                availableTextWidth = self:getAvailableTextWidth()

                local textTrimmedAtCursor = utf8Substr(textInvisibleFrontTrimmed, 0 , self.cursorPosition - self.firstVisibleCharacterPosition)
                visibleText = TextInputElement.limitTextToAvailableWidth(textTrimmedAtCursor, self.textSize, availableTextWidth, true )
                visibleTextWidth = getTextWidth( self.textSize, visibleText)
                visibleTextLength = utf8Strlen(visibleText)
                self.firstVisibleCharacterPosition = self.cursorPosition - visibleTextLength
            end

            if availableTextWidth and not self.areBackDotsVisible and self.firstVisibleCharacterPosition > 1 then
                -- check if there is still room for additonal characters(can happen if text gets deleted)
                    local lastCharacterPosition = visibleTextLength + self.firstVisibleCharacterPosition
                    local nextCharacter = utf8Substr(displayText, self.firstVisibleCharacterPosition - 1 , 1 ) or ""
                    local additionalCharacterWidth = getTextWidth( self.textSize, nextCharacter)
                    if visibleTextWidth + additionalCharacterWidth < = availableTextWidth and self.firstVisibleCharacterPosition > 1 then
                        while visibleTextWidth + additionalCharacterWidth < = availableTextWidth and self.firstVisibleCharacterPosition > 1 do
                            -- there is still room for additonal characters
                                self.firstVisibleCharacterPosition = self.firstVisibleCharacterPosition - 1
                                visibleTextWidth = visibleTextWidth + additionalCharacterWidth
                                nextCharacter = utf8Substr(displayText, self.firstVisibleCharacterPosition - 1 , 1 ) or ""
                                additionalCharacterWidth = getTextWidth( self.textSize, nextCharacter)
                            end

                            if self.firstVisibleCharacterPosition > 1 then
                                self.areFrontDotsVisible = false
                                local availableWidthWithoutFrontDots = self:getAvailableTextWidth()
                                self.areFrontDotsVisible = true
                                local neededWidthForCompleteText = getTextWidth( self.textSize, displayText)
                                if neededWidthForCompleteText < = availableWidthWithoutFrontDots then
                                    self.areFrontDotsVisible = false
                                    self.firstVisibleCharacterPosition = 1
                                end
                            else
                                    -- all characters are visible
                                    self.areFrontDotsVisible = false
                                end

                                visibleText = utf8Substr(displayText, self.firstVisibleCharacterPosition - 1 , lastCharacterPosition)
                            end
                        end

                        self.isVisibleTextPart1Visible = true
                        self.visibleTextPart1 = utf8Substr(visibleText, 0 , self.cursorPosition - self.firstVisibleCharacterPosition)
                        if visibleTextLength > self.cursorPosition - self.firstVisibleCharacterPosition then
                            self.isVisibleTextPart2Visible = true
                            self.visibleTextPart2 = utf8Substr(visibleText, self.cursorPosition - self.firstVisibleCharacterPosition)
                        end

                    else
                            -- input is not gathered, cursor is not shown,
                            -- text is displayed from its beginning, only back additonal text marker may be displayed if text is too long
                                local textWidth = getTextWidth( self.textSize, displayText)
                                -- check if additional text marker has to be displayed
                                    if availableTextWidth and textWidth > availableTextWidth then
                                        --self.isBackAdditionalTextMarkerVisible = true
                                        self.areBackDotsVisible = true
                                        availableTextWidth = self:getAvailableTextWidth()
                                    end

                                    -- set visible text
                                    if availableTextWidth and textWidth > availableTextWidth then
                                        -- not all text fits into the visible area
                                        self.visibleTextPart1 = TextInputElement.limitTextToAvailableWidth(displayText, self.textSize, availableTextWidth)
                                        self.isVisibleTextPart1Visible = true
                                    else
                                            -- all text fits into the visible area
                                            self.visibleTextPart1 = displayText
                                            self.isVisibleTextPart1Visible = true
                                        end
                                    end
                                    setTextBold( false )

                                    -- print(string.format("updateVisibleTextElements finished:"))
                                    -- print(string.format(
                                    -- "text: %s - cursorPosition: %d - firstVisibleCharacterPosition: %d - areFrontDotsVisible: %s - isVisibleTextPart1Visible: %s - visibleTextPart1: %s - isCursorVisible: %s - isVisibleTextPart2Visible: %s - visibleTextPart2: %s - areBackDotsVisible: %s",
                                    -- self.text, self.cursorPosition, self.firstVisibleCharacterPosition, tostring(self.areFrontDotsVisible), tostring(self.isVisibleTextPart1Visible), self.visibleTextPart1, tostring(self.isCursorVisible), tostring(self.isVisibleTextPart2Visible), self.visibleTextPart2, tostring(self.areBackDotsVisible)))
                                end

```