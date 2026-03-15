## TextElement

**Description**

> Text display element

**Parent**

> [GuiElement](?version=script&category=43&class=503)

**Functions**

- [copyAttributes](#copyattributes)
- [delete](#delete)
- [draw](#draw)
- [getDoRenderText](#getdorendertext)
- [getIsScrollingAllowed](#getisscrollingallowed)
- [getText](#gettext)
- [getText2Color](#gettext2color)
- [getText2Offset](#gettext2offset)
- [getTextColor](#gettextcolor)
- [getTextHeight](#gettextheight)
- [getTextLayoutMode](#gettextlayoutmode)
- [getTextOffset](#gettextoffset)
- [getTextPositionX](#gettextpositionx)
- [getTextPositionY](#gettextpositiony)
- [getTextWidth](#gettextwidth)
- [getValue](#getvalue)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [new](#new)
- [setAbsolutePosition](#setabsoluteposition)
- [setDisabled](#setdisabled)
- [setFormat](#setformat)
- [setLocaKey](#setlocakey)
- [setText](#settext)
- [setText2Color](#settext2color)
- [setText2FocusedColor](#settext2focusedcolor)
- [setText2HighlightedColor](#settext2highlightedcolor)
- [setText2SelectedColor](#settext2selectedcolor)
- [setTextColor](#settextcolor)
- [setTextFocusedColor](#settextfocusedcolor)
- [setTextFocusedSelectedColor](#settextfocusedselectedcolor)
- [setTextHighlightedColor](#settexthighlightedcolor)
- [setTextHighlightedSelectedColor](#settexthighlightedselectedcolor)
- [setTextInternal](#settextinternal)
- [setTextSelectedColor](#settextselectedcolor)
- [setTextSize](#settextsize)
- [setValue](#setvalue)
- [update](#update)
- [updateAbsolutePosition](#updateabsoluteposition)
- [updateFormattedText](#updateformattedtext)
- [updateScaledWidth](#updatescaledwidth)
- [updateScrollingLayoutMode](#updatescrollinglayoutmode)
- [updateScrollingParameters](#updatescrollingparameters)
- [updateSize](#updatesize)

### copyAttributes

**Description**

**Definition**

> copyAttributes()

**Arguments**

| any | src |
|-----|-----|

**Code**

```lua
function TextElement:copyAttributes(src)
    TextElement:superClass().copyAttributes( self , src)
    self.text = src.text
    self.format = src.format
    self.locaKey = src.locaKey
    self.value = src.value
    self.formatDecimalPlaces = src.formatDecimalPlaces
    self.sourceText = src.sourceText

    self.textColor = table.clone(src.textColor)
    if src.textSelectedColor ~ = nil then
        self.textSelectedColor = table.clone(src.textSelectedColor)
    end
    if src.textFocusedColor ~ = nil then
        self.textFocusedColor = table.clone(src.textFocusedColor)
    end
    if src.textFocusedSelectedColor ~ = nil then
        self.textFocusedSelectedColor = table.clone(src.textFocusedSelectedColor)
    end
    if src.textHighlightedColor ~ = nil then
        self.textHighlightedColor = table.clone(src.textHighlightedColor)
    end
    if src.textHighlightedSelectedColor ~ = nil then
        self.textHighlightedSelectedColor = table.clone(src.textHighlightedSelectedColor)
    end
    if src.textDisabledColor ~ = nil then
        self.textDisabledColor = table.clone(src.textDisabledColor)
    end

    self.text2Color = table.clone(src.text2Color)
    if src.text2SelectedColor ~ = nil then
        self.text2SelectedColor = table.clone(src.text2SelectedColor)
    end
    if src.text2FocusedColor ~ = nil then
        self.text2FocusedColor = table.clone(src.text2FocusedColor)
    end
    if src.text2HighlightedColor ~ = nil then
        self.text2HighlightedColor = table.clone(src.text2HighlightedColor)
    end
    if src.text2DisabledColor ~ = nil then
        self.text2DisabledColor = table.clone(src.text2DisabledColor)
    end

    self.textSize = src.textSize
    self.textOffset = table.clone(src.textOffset)
    if src.textFocusedOffset ~ = nil then
        self.textFocusedOffset = table.clone(src.textFocusedOffset)
    end
    if src.textSelectedOffset ~ = nil then
        self.textSelectedOffset = table.clone(src.textSelectedOffset)
    end
    if src.textHighlightedOffset ~ = nil then
        self.textHighlightedOffset = table.clone(src.textHighlightedOffset)
    end
    if src.textPressedOffset ~ = nil then
        self.textPressedOffset = table.clone(src.textPressedOffset)
    end
    self.text2Size = src.text2Size
    self.text2Offset = table.clone(src.text2Offset)
    self.text2FocusedOffset = table.clone(src.text2FocusedOffset)
    self.ignoreDisabled = src.ignoreDisabled

    self.textMaxWidth = src.textMaxWidth
    self.textMinWidth = src.textMinWidth
    self.textMaxNumLines = src.textMaxNumLines
    self.textAutoWidth = src.textAutoWidth
    self.textAutoHeight = src.textAutoHeight
    self.textLayoutMode = src.textLayoutMode
    self.textScrollOnFocusOnly = src.textScrollOnFocusOnly
    self.textMinSize = src.textMinSize

    self.textBold = src.textBold
    self.textSelectedBold = src.textSelectedBold
    self.textFocusedBold = src.textFocusedBold
    self.textHighlightedBold = src.textHighlightedBold
    self.text2Bold = src.text2Bold
    self.text2SelectedBold = src.text2SelectedBold
    self.text2HighlightedBold = src.text2HighlightedBold
    self.textUpperCase = src.textUpperCase
    self.textLinesPerPage = src.textLinesPerPage
    self.textAlignment = src.textAlignment
    self.textOriginalAlignment = src.textOriginalAlignment
    self.currentPage = src.currentPage
    self.defaultTextSize = src.defaultTextSize
    self.defaultText2Size = src.defaultText2Size
    self.textLineHeightScale = src.textLineHeightScale
    self.textVerticalAlignment = src.textVerticalAlignment

    self.onTextChangedCallback = src.onTextChangedCallback
end

```

### delete

**Description**

**Definition**

> delete()

**Code**

```lua
function TextElement:delete()
    g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.USE_FAHRENHEIT], self )
    g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.MONEY_UNIT], self )

    TextElement:superClass().delete( self )
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
function TextElement:draw(clipX1, clipY1, clipX2, clipY2)
    if self:getDoRenderText() then
        if self.text ~ = nil and self.text ~ = "" then
            local xOffset, yOffset = self:getTextOffset()

            if self:getTextLayoutMode() = = TextElement.LAYOUT_MODE.SCROLLING and self.scrollingMaxOffset > 0 then
                clipX1 = math.max( self.scrollingClipArea[ 1 ] + xOffset, clipX1 or 0 )
                clipY1 = math.max( self.scrollingClipArea[ 2 ] + yOffset, clipY1 or 0 )
                clipX2 = math.min( self.scrollingClipArea[ 3 ] + xOffset, clipX2 or math.huge)
                clipY2 = math.min( self.scrollingClipArea[ 4 ] + yOffset, clipY2 or math.huge)
            end

            if clipX1 ~ = nil then
                setTextClipArea(clipX1, clipY1, clipX2, clipY2)
            end

            setTextAlignment( self.textAlignment)

            local maxWidth = self.absSize[ 1 ]
            if self.textMaxWidth ~ = nil then
                maxWidth = self.textMaxWidth
            elseif self.textAutoWidth then
                    maxWidth = 1
                end

                if self.textMaxNumLines > 1 then
                    setTextWrapWidth(maxWidth)
                end

                setTextFirstLineIndentation( self.firstLineIndentation or 0 )
                setTextLineBounds(( self.currentPage - 1 ) * self.textLinesPerPage, self.textLinesPerPage)
                setTextLineHeightScale( self.textLineHeightScale)

                local text = self.text

                local bold = self.textBold or self.textSelectedBold and self:getIsSelected() or self.textHighlightedBold and self:getIsHighlighted() or
                self.textFocusedBold and self:getIsFocused()
                setTextBold(bold)

                local xPos, yPos = self:getTextPosition(text)

                -- The rendering engine works as follows:
                -- The text size is from baseline to above the umlaut of a capital.This causes
                -- very weird vertical alignment.We are going to adjust this by drawing our text
                -- vertically based on xheight+ascending.The engine does not provide this info,
                -- because we are drawing simple bitmap fonts.
                -- and there is only 1 font, so instead these values are using pixel counting.
                -- For fonts of size 20, we offset on Y for 2px.It is proportional so we scale it.
                    local baselineOffset = self.textSize * 0.1
                    yPos = yPos + baselineOffset

                    if self.text2Size > 0 then
                        local x2Offset, y2Offset = self:getText2Offset()
                        bold = self.text2Bold or( self.text2SelectedBold and self:getIsSelected()) or( self.text2HighlightedBold and self:getIsHighlighted())
                        setTextBold(bold)
                        local r,g,b,a = unpack( self:getText2Color())
                        setTextColor(r,g,b,a * self.alpha)
                        renderText(xPos + x2Offset, yPos + y2Offset, self.text2Size, text)
                    end

                    local r,g,b,a = unpack( self:getTextColor())
                    setTextColor(r,g,b,a * self.alpha)

                    renderText(xPos + xOffset, yPos + yOffset, self.textSize, text)

                    -- TODO:apply engine vertical text alignment as soon as it's exposed to script
                    setTextBold( false )
                    setTextAlignment(RenderText.ALIGN_LEFT)
                    setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE)
                    setTextColor( 1 , 1 , 1 , 1 )
                    setTextLineBounds( 0 , 0 )
                    setTextWrapWidth( 0 )
                    setTextFirstLineIndentation( 0 )

                    if clipX1 ~ = nil then
                        setTextClipArea( 0 , 0 , 1 , 1 )
                    end

                    if self.debugEnabled or g_uiDebugEnabled then
                        setOverlayColor( GuiElement.debugOverlay, 0 , 0 , 0 , 1 )

                        local x = xPos + xOffset
                        if self.textAlignment = = RenderText.ALIGN_RIGHT then
                            x = x - maxWidth
                        elseif self.textAlignment = = RenderText.ALIGN_CENTER then
                                x = x - maxWidth / 2
                            end

                            renderOverlay( GuiElement.debugOverlay, x, yPos + yOffset, maxWidth, g_pixelSizeY * 2 )

                            local width = self:getTextWidth()
                            x = xPos + xOffset
                            if self.textAlignment = = RenderText.ALIGN_RIGHT then
                                x = x - width
                            elseif self.textAlignment = = RenderText.ALIGN_CENTER then
                                    x = x - width * 0.5
                                end

                                -- Baseline
                                setOverlayColor( GuiElement.debugOverlay, 0 , 1 , 0 , 1 )
                                renderOverlay( GuiElement.debugOverlay, x, yPos + yOffset, width, 1 * g_pixelSizeY)
                                -- xHeight
                                setOverlayColor( GuiElement.debugOverlay, 1 , 0.5 , 0 , 1 )
                                renderOverlay( GuiElement.debugOverlay, x, yPos + yOffset + getTextHeight( self.textSize, text) * 0.5 , width, 1 * g_pixelSizeY)
                                -- Ascending
                                setOverlayColor( GuiElement.debugOverlay, 0 , 0 , 1 , 1 )
                                renderOverlay( GuiElement.debugOverlay, x, yPos + yOffset + getTextHeight( self.textSize, text) * 0.75 , width, 1 * g_pixelSizeY)

                                if self:getTextLayoutMode() = = TextElement.LAYOUT_MODE.SCROLLING and self.scrollingMaxOffset > 0 then
                                    local debugWidth = self.scrollingClipArea[ 3 ] - self.scrollingClipArea[ 1 ]
                                    local debugHeight = self.scrollingClipArea[ 4 ] - self.scrollingClipArea[ 2 ]

                                    drawOutlineRect( self.scrollingClipArea[ 1 ], self.scrollingClipArea[ 2 ], debugWidth, debugHeight, 2 * g_pixelSizeX, 2 * g_pixelSizeY, 0 , 0 , 1 , 1 )
                                end
                            end
                        end
                    end
                    TextElement:superClass().draw( self , clipX1, clipY1, clipX2, clipY2)
                end

```

### getDoRenderText

**Description**

**Definition**

> getDoRenderText()

**Code**

```lua
function TextElement:getDoRenderText()
    return true
end

```

### getIsScrollingAllowed

**Description**

**Definition**

> getIsScrollingAllowed()

**Code**

```lua
function TextElement:getIsScrollingAllowed()
    return not self.textScrollOnFocusOnly or self:getIsFocused() or self:getIsHighlighted() or self:getIsSelected()
end

```

### getText

**Description**

> Get text

**Definition**

> getText()

**Code**

```lua
function TextElement:getText()
    return self.sourceText
end

```

### getText2Color

**Description**

> Get text 2 color

**Definition**

> getText2Color()

**Code**

```lua
function TextElement:getText2Color()
    if self.disabled and not self.ignoreDisabled then
        return self.text2DisabledColor
    elseif self:getIsSelected() then
            return self.text2SelectedColor
        elseif self:getIsFocused() then
                return self.text2FocusedColor
            elseif self:getIsHighlighted() then
                    return self.text2HighlightedColor
                else
                        return self.text2Color
                    end
                end

```

### getText2Offset

**Description**

> Get text 2 offset

**Definition**

> getText2Offset()

**Code**

```lua
function TextElement:getText2Offset()
    local xOffset, yOffset = self.text2Offset[ 1 ], self.text2Offset[ 2 ]
    local state = self:getOverlayState()
    if state = = GuiOverlay.STATE_FOCUSED or state = = GuiOverlay.STATE_PRESSED or state = = GuiOverlay.STATE_SELECTED or state = = GuiOverlay.STATE_HIGHLIGHTED then
        xOffset = self.text2FocusedOffset[ 1 ]
        yOffset = self.text2FocusedOffset[ 2 ]
    end
    return xOffset, yOffset
end

```

### getTextColor

**Description**

> Get text color

**Definition**

> getTextColor()

**Code**

```lua
function TextElement:getTextColor()
    local retColor = self.textColor

    if self.disabled and not self.ignoreDisabled then
        retColor = self.textDisabledColor
    elseif self:getIsSelected() then
            if self:getIsFocused() then
                retColor = self.textFocusedSelectedColor or self.textSelectedColor
            elseif self:getIsHighlighted() then
                    retColor = self.textHighlightedSelectedColor or self.textSelectedColor
                else
                        retColor = self.textSelectedColor
                    end
                elseif self:getIsFocused() then
                        retColor = self.textFocusedColor
                    elseif self:getIsHighlighted() then
                            retColor = self.textHighlightedColor
                        end

                        if retColor = = nil then
                            retColor = self.textColor
                        end

                        return retColor
                    end

```

### getTextHeight

**Description**

> Get text height

**Definition**

> getTextHeight()

**Arguments**

| any | includeNegativeSpacing |
|-----|------------------------|

**Code**

```lua
function TextElement:getTextHeight(includeNegativeSpacing)
    -- Only wrap when having more than 1 line available
    if self.textMaxNumLines > 1 then
        if self.textMaxWidth ~ = nil then
            setTextWrapWidth( self.textMaxWidth)
        else
                setTextWrapWidth( self.absSize[ 1 ])
            end
        end
        setTextBold( self.textBold)
        setTextFirstLineIndentation( self.firstLineIndentation or 0 )
        setTextLineHeightScale( self.textLineHeightScale)

        local height, numLines = getTextHeight( self.textSize, self.text)

        -- inlcude negative height for letters like 'g', 'y' or 'j'
            if includeNegativeSpacing = = true and numLines > 0 then
                height = height + (height / numLines) * 0.1
            end

            setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE)
            setTextFirstLineIndentation( 0 )
            setTextBold( false )
            setTextWrapWidth( 0 )
            return height, numLines
        end

```

### getTextLayoutMode

**Description**

**Definition**

> getTextLayoutMode()

**Code**

```lua
function TextElement:getTextLayoutMode()
    if self.textLayoutMode = = TextElement.LAYOUT_MODE.SCROLLING and not self:getIsScrollingAllowed() then
        return TextElement.LAYOUT_MODE.TRUNCATE
    end

    return self.textLayoutMode
end

```

### getTextOffset

**Description**

> Get text offset

**Definition**

> getTextOffset()

**Code**

```lua
function TextElement:getTextOffset()
    local state = self:getOverlayState()
    local xOffset, yOffset = self.textOffset[ 1 ], self.textOffset[ 2 ]

    if state = = GuiOverlay.STATE_FOCUSED and self.textFocusedOffset ~ = nil then
        xOffset = self.textFocusedOffset[ 1 ]
        yOffset = self.textFocusedOffset[ 2 ]
    elseif state = = GuiOverlay.STATE_SELECTED and self.textSelectedOffset ~ = nil then
            xOffset = self.textSelectedOffset[ 1 ]
            yOffset = self.textSelectedOffset[ 2 ]
        elseif state = = GuiOverlay.STATE_HIGHLIGHTED and self.textHighlightedOffset ~ = nil then
                xOffset = self.textHighlightedOffset[ 1 ]
                yOffset = self.textHighlightedOffset[ 2 ]
            elseif state = = GuiOverlay.STATE_PRESSED and self.textPressedOffset ~ = nil then
                    xOffset = self.textPressedOffset[ 1 ]
                    yOffset = self.textPressedOffset[ 2 ]
                end

                return xOffset, yOffset
            end

```

### getTextPositionX

**Description**

> Get text position x

**Definition**

> getTextPositionX()

**Code**

```lua
function TextElement:getTextPositionX()
    local xPos = self.absPosition[ 1 ]
    if self.textAlignment = = RenderText.ALIGN_CENTER then
        xPos = xPos + ( self.absSize[ 1 ] * 0.5 )
    elseif self.textAlignment = = RenderText.ALIGN_RIGHT then
            xPos = xPos + self.absSize[ 1 ]
        end
        return xPos
    end

```

### getTextPositionY

**Description**

**Definition**

> getTextPositionY()

**Arguments**

| any | lineHeight  |
|-----|-------------|
| any | totalHeight |

**Code**

```lua
function TextElement:getTextPositionY(lineHeight, totalHeight)
    local yPos = self.absPosition[ 2 ]

    if self.textVerticalAlignment = = TextElement.VERTICAL_ALIGNMENT.TOP then
        yPos = yPos + self.absSize[ 2 ] - lineHeight
    elseif self.textVerticalAlignment = = TextElement.VERTICAL_ALIGNMENT.MIDDLE then
            yPos = yPos + ( self.absSize[ 2 ] + totalHeight) * 0.5 - lineHeight
        else
                yPos = yPos + totalHeight - lineHeight
            end

            return yPos
        end

```

### getTextWidth

**Description**

> Get text width

**Definition**

> getTextWidth()

**Arguments**

| any | useSourceText |
|-----|---------------|

**Code**

```lua
function TextElement:getTextWidth(useSourceText)
    setTextBold( self.textBold)
    local width = getTextWidth( self.textSize, self.text)
    if useSourceText then
        width = getTextWidth( self.textSize, self.sourceText)
    end
    setTextBold( false )

    -- When not overflowing, limit size to element
    if self:getTextLayoutMode() ~ = TextElement.LAYOUT_MODE.OVERFLOW and self.textLayoutMode ~ = TextElement.LAYOUT_MODE.SCROLLING and not self.textAutoWidth then
        width = math.min(width, self.absSize[ 1 ])
    end

    return width
end

```

### getValue

**Description**

> Get the value

**Definition**

> getValue()

**Code**

```lua
function TextElement:getValue()
    return self.value
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
function TextElement:loadFromXML(xmlFile, key)
    -- set custom env before super call to allow loading of tooltip text in GuiElement
    local xmlFilename = getXMLFilename(xmlFile)
    local modName, _ = Utils.getModNameAndBaseDirectory(xmlFilename)
    if modName ~ = nil then
        self.customEnvironment = modName
    end

    TextElement:superClass().loadFromXML( self , xmlFile, key)

    self.textColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textColor" ), self.textColor)
    self.textSelectedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textSelectedColor" ), self.textSelectedColor)
    self.text2SelectedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#text2SelectedColor" ), self.text2SelectedColor)
    self.textFocusedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textFocusedColor" ), self.textFocusedColor)
    self.text2FocusedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#text2FocusedColor" ), self.text2FocusedColor)
    self.textFocusedSelectedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textFocusedSelectedColor" ), self.textFocusedSelectedColor)
    self.textHighlightedSelectedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textHighlightedSelectedColor" ), self.textHighlightedSelectedColor)
    self.textHighlightedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textHighlightedColor" ), self.textHighlightedColor)
    self.text2HighlightedColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#text2HighlightedColor" ), self.text2HighlightedColor)
    self.textDisabledColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#textDisabledColor" ), self.textDisabledColor)
    self.text2DisabledColor = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#text2DisabledColor" ), self.text2DisabledColor)
    self.text2Color = GuiUtils.getColorArray(getXMLString(xmlFile, key .. "#text2Color" ), self.text2Color)

    self.textOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#textOffset" ), self.textOffset)
    self.textFocusedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#textFocusedOffset" ), self.textFocusedOffset)
    self.textSelectedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#textSelectedOffset" ), self.textSelectedOffset)
    self.textHighlightedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#textHighlightedOffset" ), self.textHighlightedOffset)
    self.textPressedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#textPressedOffset" ), self.textPressedOffset)
    self.text2Offset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#text2Offset" ), self.text2Offset)
    self.text2FocusedOffset = GuiUtils.getNormalizedScreenValues(getXMLString(xmlFile, key .. "#text2FocusedOffset" ), self.text2FocusedOffset)
    self.textSize = GuiUtils.getNormalizedYValue(getXMLString(xmlFile, key .. "#textSize" ), self.textSize)
    self.text2Size = GuiUtils.getNormalizedYValue(getXMLString(xmlFile, key .. "#text2Size" ), self.text2Size)

    self.textBold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textBold" ), self.textBold)
    self.textSelectedBold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textSelectedBold" ), self.textSelectedBold)
    self.textFocusedBold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textFocusedBold" ), self.textFocusedBold)
    self.textHighlightedBold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textHighlightedBold" ), self.textHighlightedBold)
    self.textUpperCase = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textUpperCase" ), self.textUpperCase)
    self.text2Bold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#text2Bold" ), self.text2Bold)
    self.text2SelectedBold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#text2SelectedBold" ), self.text2SelectedBold)
    self.text2HighlightedBold = Utils.getNoNil(getXMLBool(xmlFile, key .. "#text2HighlightedBold" ), self.text2HighlightedBold)
    self.textLinesPerPage = getXMLInt(xmlFile, key .. "#textLinesPerPage" ) or self.textLinesPerPage
    self.textLineHeightScale = getXMLFloat(xmlFile, key .. "#textLineHeightScale" ) or self.textLineHeightScale

    self.defaultTextSize = self.textSize
    self.defaultText2Size = self.text2Size

    self.textMaxWidth = GuiUtils.getNormalizedXValue(getXMLString(xmlFile, key .. "#textMaxWidth" ), self.textMaxWidth)
    self.textMinWidth = GuiUtils.getNormalizedXValue(getXMLString(xmlFile, key .. "#textMinWidth" ), self.textMinWidth)
    self.textMaxNumLines = getXMLInt(xmlFile, key .. "#textMaxNumLines" ) or self.textMaxNumLines
    self.textAutoWidth = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textAutoWidth" ), self.textAutoWidth)
    self.textAutoHeight = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textAutoHeight" ), self.textAutoHeight)
    self.textMinSize = GuiUtils.getNormalizedYValue(getXMLString(xmlFile, key .. "#textMinSize" ), self.textMinSize)

    local textAlignment = getXMLString(xmlFile, key .. "#textAlignment" )
    if textAlignment ~ = nil then
        textAlignment = string.lower(textAlignment)
        if textAlignment = = "right" then
            self.textAlignment = RenderText.ALIGN_RIGHT
        elseif textAlignment = = "center" then
                self.textAlignment = RenderText.ALIGN_CENTER
            else
                    self.textAlignment = RenderText.ALIGN_LEFT
                end

                self.textOriginalAlignment = self.textAlignment
            end

            local wrapModeKey = getXMLString(xmlFile, key .. "#textLayoutMode" )
            if wrapModeKey ~ = nil then
                wrapModeKey = string.lower(wrapModeKey)
                if wrapModeKey = = "truncate" then
                    self.textLayoutMode = TextElement.LAYOUT_MODE.TRUNCATE
                elseif wrapModeKey = = "resize" then
                        self.textLayoutMode = TextElement.LAYOUT_MODE.RESIZE
                    elseif wrapModeKey = = "overflow" then
                            self.textLayoutMode = TextElement.LAYOUT_MODE.OVERFLOW
                        elseif wrapModeKey = = "scrolling" then
                                self.textLayoutMode = TextElement.LAYOUT_MODE.SCROLLING
                                self.textMaxNumLines = 1
                            elseif wrapModeKey = = "fill" then
                                    self.textLayoutMode = TextElement.LAYOUT_MODE.FILL
                                end
                            end

                            self.textScrollOnFocusOnly = Utils.getNoNil(getXMLBool(xmlFile, key .. "#textScrollOnFocusOnly" ), self.textScrollOnFocusOnly)

                            local textVerticalAlignment = getXMLString(xmlFile, key .. "#textVerticalAlignment" ) or ""
                            local verticalAlignKey = string.upper(textVerticalAlignment)
                            self.textVerticalAlignment = TextElement.VERTICAL_ALIGNMENT[verticalAlignKey] or self.textVerticalAlignment

                            self.ignoreDisabled = Utils.getNoNil(getXMLBool(xmlFile, key .. "#ignoreDisabled" ), self.ignoreDisabled)

                            local text = getXMLString(xmlFile, key .. "#text" )
                            if text ~ = nil then
                                if text ~ = "" and string.startsWith(text, "$l10n_" ) then
                                    local hasColon = string.endsWith(text, ":" )
                                    if hasColon then
                                        text = utf8Substr(text, 0 , utf8Strlen(text) - 1 ) -- remove trailing:from loca key
                                    end

                                    text = g_i18n:getText(text:sub( 7 ), self.customEnvironment) -- translate key

                                    if hasColon then
                                        text = text .. ":" -- add back:after translation
                                    end
                                end

                                self.sourceText = text

                                -- Otherwise this overrides the formatting as XML is loaded after profiles
                                if self.format = = TextElement.FORMAT.NONE then
                                    self:setText(text, false , true )
                                end
                            end

                            self.formatDecimalPlaces = math.max(getXMLInt(xmlFile, key .. "#formatDecimalPlaces" ) or self.formatDecimalPlaces, 0 )
                            local format = getXMLString(xmlFile, key .. "#format" )
                            if format ~ = nil then
                                format = string.lower( format )
                                local f = TextElement.FORMAT.NONE
                                if format = = "currency" then
                                    f = TextElement.FORMAT.CURRENCY
                                elseif format = = "accounting" then
                                        f = TextElement.FORMAT.ACCOUNTING
                                    elseif format = = "temperature" then
                                            f = TextElement.FORMAT.TEMPERATURE
                                        elseif format = = "number" then
                                                f = TextElement.FORMAT.NUMBER
                                            elseif format = = "percentage" then
                                                    f = TextElement.FORMAT.PERCENTAGE
                                                elseif format = = "none" then
                                                        f = TextElement.FORMAT.NONE
                                                    end
                                                    self:setFormat(f)
                                                end

                                                self:addCallback(xmlFile, key .. "#onTextChanged" , "onTextChangedCallback" )
                                                self:updateSize()
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
function TextElement:loadProfile(profile, applyProfile)
    TextElement:superClass().loadProfile( self , profile, applyProfile)

    self.textColor = GuiUtils.getColorArray(profile:getValue( "textColor" ), self.textColor)
    self.textSelectedColor = GuiUtils.getColorArray(profile:getValue( "textSelectedColor" ), self.textSelectedColor)
    self.textFocusedColor = GuiUtils.getColorArray(profile:getValue( "textFocusedColor" ), self.textFocusedColor)
    self.textFocusedSelectedColor = GuiUtils.getColorArray(profile:getValue( "textFocusedSelectedColor" ), self.textFocusedSelectedColor)
    self.textHighlightedSelectedColor = GuiUtils.getColorArray(profile:getValue( "textHighlightedSelectedColor" ), self.textHighlightedSelectedColor )
    self.textHighlightedColor = GuiUtils.getColorArray(profile:getValue( "textHighlightedColor" ), self.textHighlightedColor)
    self.textDisabledColor = GuiUtils.getColorArray(profile:getValue( "textDisabledColor" ), self.textDisabledColor)
    self.text2Color = GuiUtils.getColorArray(profile:getValue( "text2Color" ), self.text2Color)
    self.text2SelectedColor = GuiUtils.getColorArray(profile:getValue( "text2SelectedColor" ), self.text2SelectedColor)
    self.text2FocusedColor = GuiUtils.getColorArray(profile:getValue( "text2FocusedColor" ), self.text2FocusedColor)
    self.text2HighlightedColor = GuiUtils.getColorArray(profile:getValue( "text2HighlightedColor" ), self.text2HighlightedColor)
    self.text2DisabledColor = GuiUtils.getColorArray(profile:getValue( "text2DisabledColor" ), self.text2DisabledColor)

    self.textSize = GuiUtils.getNormalizedYValue(profile:getValue( "textSize" ), self.textSize)
    self.textOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "textOffset" ), self.textOffset)
    self.textFocusedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "textFocusedOffset" ), self.textFocusedOffset)
    self.textSelectedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "textSelectedOffset" ), self.textSelectedOffset)
    self.textHighlightedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "textHighlightedOffset" ), self.textHighlightedOffset)
    self.textPressedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "textPressedOffset" ), self.textPressedOffset)
    self.text2Size = GuiUtils.getNormalizedYValue(profile:getValue( "text2Size" ), self.text2Size)
    self.text2Offset = GuiUtils.getNormalizedScreenValues(profile:getValue( "text2Offset" ), self.text2Offset)
    self.text2FocusedOffset = GuiUtils.getNormalizedScreenValues(profile:getValue( "text2FocusedOffset" ), self.text2FocusedOffset)

    self.textBold = profile:getBool( "textBold" , self.textBold)
    self.textSelectedBold = profile:getBool( "textSelectedBold" , self.textSelectedBold)
    self.textFocusedBold = profile:getBool( "textFocusedBold" , self.textFocusedBold)
    self.textHighlightedBold = profile:getBool( "textHighlightedBold" , self.textHighlightedBold)
    self.text2Bold = profile:getBool( "text2Bold" , self.text2Bold)
    self.text2SelectedBold = profile:getBool( "text2SelectedBold" , self.text2SelectedBold)
    self.text2HighlightedBold = profile:getBool( "text2HighlightedBold" , self.text2HighlightedBold)
    self.textUpperCase = profile:getBool( "textUpperCase" , self.textUpperCase)
    self.textLinesPerPage = profile:getNumber( "textLinesPerPage" , self.textLinesPerPage)

    self.textLineHeightScale = profile:getNumber( "textLineHeightScale" , self.textLineHeightScale)

    self.textMaxWidth = GuiUtils.getNormalizedXValue(profile:getValue( "textMaxWidth" ), self.textMaxWidth)
    self.textMinWidth = GuiUtils.getNormalizedXValue(profile:getValue( "textMinWidth" ), self.textMinWidth)
    self.textMaxNumLines = profile:getNumber( "textMaxNumLines" , self.textMaxNumLines)
    self.textAutoWidth = profile:getBool( "textAutoWidth" , self.textAutoWidth)
    self.textAutoHeight = profile:getBool( "textAutoHeight" , self.textAutoHeight)
    self.textMinSize = GuiUtils.getNormalizedYValue(profile:getValue( "textMinSize" ), self.textMinSize)

    self.defaultTextSize = self.textSize
    self.defaultText2Size = self.text2Size

    self.ignoreDisabled = profile:getBool( "ignoreDisabled" , self.ignoreDisabled)

    local textAlignment = profile:getValue( "textAlignment" )
    if textAlignment ~ = nil then
        textAlignment = string.lower(textAlignment)
        if textAlignment = = "right" then
            self.textAlignment = RenderText.ALIGN_RIGHT
        elseif textAlignment = = "center" then
                self.textAlignment = RenderText.ALIGN_CENTER
            else
                    self.textAlignment = RenderText.ALIGN_LEFT
                end

                self.textOriginalAlignment = self.textAlignment
            end

            local wrapModeKey = profile:getValue( "textLayoutMode" )
            if wrapModeKey ~ = nil then
                wrapModeKey = string.lower(wrapModeKey)
                if wrapModeKey = = "truncate" then
                    self.textLayoutMode = TextElement.LAYOUT_MODE.TRUNCATE
                elseif wrapModeKey = = "resize" then
                        self.textLayoutMode = TextElement.LAYOUT_MODE.RESIZE
                    elseif wrapModeKey = = "overflow" then
                            self.textLayoutMode = TextElement.LAYOUT_MODE.OVERFLOW
                        elseif wrapModeKey = = "scrolling" then
                                self.textLayoutMode = TextElement.LAYOUT_MODE.SCROLLING
                                self.textMaxNumLines = 1
                            elseif wrapModeKey = = "fill" then
                                    self.textLayoutMode = TextElement.LAYOUT_MODE.FILL
                                end
                            end

                            self.textScrollOnFocusOnly = profile:getBool( "textScrollOnFocusOnly" , self.textScrollOnFocusOnly)

                            local textVerticalAlignment = profile:getValue( "textVerticalAlignment" , "" )
                            local verticalAlignKey = string.upper(textVerticalAlignment)
                            self.textVerticalAlignment = TextElement.VERTICAL_ALIGNMENT[verticalAlignKey] or self.textVerticalAlignment

                            self.formatDecimalPlaces = math.max(profile:getNumber( "formatDecimalPlaces" , self.formatDecimalPlaces), 0 )
                            local format = profile:getValue( "format" )

                            if format ~ = nil then
                                format = string.lower( format )
                                local f = TextElement.FORMAT.NONE
                                if format = = "currency" then
                                    f = TextElement.FORMAT.CURRENCY
                                elseif format = = "accounting" then
                                        f = TextElement.FORMAT.ACCOUNTING
                                    elseif format = = "temperature" then
                                            f = TextElement.FORMAT.TEMPERATURE
                                        elseif format = = "number" then
                                                f = TextElement.FORMAT.NUMBER
                                            elseif format = = "percentage" then
                                                    f = TextElement.FORMAT.PERCENTAGE
                                                elseif format = = "none" then
                                                        f = TextElement.FORMAT.NONE
                                                    end
                                                    self:setFormat(f)
                                                end

                                                if applyProfile then
                                                    self:updateSize()
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
function TextElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or TextElement _mt)

    self.textColor = { 1 , 1 , 1 , 1 }
    self.textDisabledColor = nil
    self.textSelectedColor = nil
    self.textFocusedColor = nil
    self.textHighlightedColor = nil
    self.textFocusedSelectedColor = nil
    self.textHighlightedSelectedColor = nil
    self.textOffset = { 0 , 0 }
    self.textSize = 0.03
    self.textBold = false
    self.textSelectedBold = false
    self.textFocusedBold = false
    self.textHighlightedBold = false
    self.text2Color = { 1 , 1 , 1 , 1 }
    self.text2DisabledColor = nil
    self.text2SelectedColor = nil
    self.text2FocusedColor = nil
    self.text2HighlightedColor = nil
    self.text2Offset = { 0 , 0 }
    self.text2FocusedOffset = { 0 , 0 }
    self.text2Size = 0
    self.text2Bold = false
    self.text2SelectedBold = false
    self.text2HighlightedBold = false
    self.textUpperCase = false
    self.textLinesPerPage = 0
    self.currentPage = 1
    self.defaultTextSize = self.textSize
    self.defaultText2Size = self.text2Size
    self.textLineHeightScale = RenderText.DEFAULT_LINE_HEIGHT_SCALE
    self.text = ""
    self.textAlignment = RenderText.ALIGN_CENTER
    self.textOriginalAlignment = RenderText.ALIGN_CENTER
    self.textVerticalAlignment = TextElement.VERTICAL_ALIGNMENT.MIDDLE
    self.ignoreDisabled = false
    self.firstLineIndentation = nil

    self.format = TextElement.FORMAT.NONE
    self.locaKey = nil
    self.value = nil
    self.formatDecimalPlaces = 0

    self.textMaxWidth = nil -- no limit, thus size limited
    self.textMinWidth = 0
    self.textMaxNumLines = 1 -- just one line by default
    self.textAutoWidth = false -- no auto sizing of the element
    self.textAutoHeight = false -- no auto sizing of the element
    self.textLayoutMode = TextElement.LAYOUT_MODE.TRUNCATE -- hide any overflow
    self.textScrollOnFocusOnly = true
    self.textMinSize = 0.01

    self.sourceText = ""

    self.scrollingStartPos = 0
    self.scrollingOffset = 0
    self.scrollingMaxOffset = 0
    self.scrollingClipArea = nil
    self.scrollTime = 0
    self.updatedTextLayoutMode = false

    return self
end

```

### setAbsolutePosition

**Description**

> Directly set the absolute screen position of this TextElement.
> Also updates children accordingly.

**Definition**

> setAbsolutePosition()

**Arguments**

| any | x |
|-----|---|
| any | y |

**Code**

```lua
function TextElement:setAbsolutePosition(x, y)
    TextElement:superClass().setAbsolutePosition( self , x, y)

    if not self.ignoreStartPositionUpdate then
        self.scrollingStartPos = self.absPosition[ 1 ]
    end
end

```

### setDisabled

**Description**

> Overwrite the default setDisabled function, we need to update the scrolling layout mode for scrolling elements if they
> get disabled while scrolling

**Definition**

> setDisabled()

**Arguments**

| any | isDisabled |
|-----|------------|

**Code**

```lua
function TextElement:setDisabled(isDisabled)
    TextElement:superClass().setDisabled( self , isDisabled)

    self:updateScrollingLayoutMode()
end

```

### setFormat

**Description**

> Set a new formatter

**Definition**

> setFormat()

**Arguments**

| any | format |
|-----|--------|

**Code**

```lua
function TextElement:setFormat( format )
    if format = = nil then
        format = TextElement.FORMAT.NONE
    end

    if self.format ~ = format then
        -- Unsubscribe for previous format
            if self.format = = TextElement.FORMAT.TEMPERATURE then
                g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.USE_FAHRENHEIT], self )
            elseif format = = TextElement.FORMAT.CURRENCY or format = = TextElement.FORMAT.ACCOUNTING then
                    g_messageCenter:unsubscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.MONEY_UNIT], self )
                end

                self.format = format
                self:updateFormattedText()

                -- Subscribe to setting changes for the new format
                    if format = = TextElement.FORMAT.TEMPERATURE then
                        g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.USE_FAHRENHEIT], self.onFormatUnitChanged, self )
                    elseif format = = TextElement.FORMAT.CURRENCY or format = = TextElement.FORMAT.ACCOUNTING then
                            g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.MONEY_UNIT], self.onFormatUnitChanged, self )
                        end
                    end
                end

```

### setLocaKey

**Description**

> Set a loca key to show the text of

**Definition**

> setLocaKey()

**Arguments**

| any | key |
|-----|-----|

**Code**

```lua
function TextElement:setLocaKey(key)
    self.locaKey = key
    self.format = TextElement.FORMAT.NONE
    self.value = nil
    self:updateFormattedText()
end

```

### setText

**Description**

> Set text

**Definition**

> setText()

**Arguments**

| any | text                          |
|-----|-------------------------------|
| any | forceTextSize                 |
| any | isInitializing                |
| any | forceScrollingParameterUpdate |

**Return Values**

| any | leftover | part of the string if textMaxNumLines is set |
|-----|----------|----------------------------------------------|

**Code**

```lua
function TextElement:setText(text, forceTextSize, isInitializing, forceScrollingParameterUpdate)
    -- Reset so it is not overwritten
    self.locaKey = nil
    self.value = nil
    self.format = TextElement.FORMAT.NONE

    if self:setTextInternal(text, forceTextSize, isInitializing) or forceScrollingParameterUpdate then --only update scrolling params if text has changed
        self.scrollTime = 0
        self:updateScrollingParameters()
    end
end

```

### setText2Color

**Description**

> Set text 2 color

**Definition**

> setText2Color()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setText2Color(r,g,b,a)
    self.text2Color = { r,g,b,a }
end

```

### setText2FocusedColor

**Description**

> Set text 2 focused color

**Definition**

> setText2FocusedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setText2FocusedColor(r,g,b,a)
    self.text2FocusedColor = { r,g,b,a }
end

```

### setText2HighlightedColor

**Description**

> Set text 2 highlighted color

**Definition**

> setText2HighlightedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setText2HighlightedColor(r,g,b,a)
    self.text2HighlightedColor = { r,g,b,a }
end

```

### setText2SelectedColor

**Description**

> Set text 2 selected color

**Definition**

> setText2SelectedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setText2SelectedColor(r,g,b,a)
    self.text2SelectedColor = { r,g,b,a }
end

```

### setTextColor

**Description**

> Set text color

**Definition**

> setTextColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setTextColor(r,g,b,a)
    self.textColor = { r,g,b,a }
end

```

### setTextFocusedColor

**Description**

> Set text focused color

**Definition**

> setTextFocusedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setTextFocusedColor(r, g, b, a)
    self.textFocusedColor = { r, g, b, a }
end

```

### setTextFocusedSelectedColor

**Description**

> Set text focused selected color, active when the element is both focused AND selected

**Definition**

> setTextFocusedSelectedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setTextFocusedSelectedColor(r,g,b,a)
    self.textFocusedSelectedColor = { r,g,b,a }
end

```

### setTextHighlightedColor

**Description**

> Set text highlighted color

**Definition**

> setTextHighlightedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setTextHighlightedColor(r, g, b, a)
    self.textHighlightedColor = { r, g, b, a }
end

```

### setTextHighlightedSelectedColor

**Description**

> Set text focused selected color, active when the element is both focused AND selected

**Definition**

> setTextHighlightedSelectedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setTextHighlightedSelectedColor(r,g,b,a)
    self.textHighlightedSelectedColor = { r,g,b,a }
end

```

### setTextInternal

**Description**

> Internal call for setting text

**Definition**

> setTextInternal()

**Arguments**

| any | text            |
|-----|-----------------|
| any | forceTextSize   |
| any | skipCallback    |
| any | doNotUpdateSize |

**Code**

```lua
function TextElement:setTextInternal(text, forceTextSize, skipCallback, doNotUpdateSize)
    if text = = nil then
        text = ""
    end

    setTextWidthScale(g_textWidthScale)

    text = tostring(text)
    if self.textUpperCase then
        text = utf8ToUpper(text)
    end

    -- Save the original text in case any text properties change
    local textHasChanged = self.sourceText ~ = text

    self.sourceText = text

    -- Reset to original size before resizing again
    self.textSize = self.defaultTextSize
    self.text2Size = self.defaultText2Size

    self:updateSize()

    local maxWidth = self.absSize[ 1 ]
    if self.textMaxWidth ~ = nil then
        maxWidth = self.textMaxWidth
    elseif self.textAutoWidth then
            maxWidth = 1
        end

        local limitVerticalLines = false
        local textLayoutMode = self:getTextLayoutMode()

        setTextBold( self.textBold)

        if textLayoutMode = = TextElement.LAYOUT_MODE.RESIZE then
            local textMaxNumLines = self.textMaxNumLines
            -- Breaking is not possible on spaces
            if text:find( "[ -]" ) = = nil then
                textMaxNumLines = 1
            end

            if textMaxNumLines > 1 then
                -- Wrap at max length
                setTextWrapWidth(maxWidth, false )

                -- Then find how long the max line would be
                local lengthWithNoLineLimit = getTextLength( self.textSize, text, 99999 )

                -- We want to fully fit inside, so our final length must be < = our max length
                while getTextLength( self.textSize, text, textMaxNumLines) < lengthWithNoLineLimit do
                    self.textSize = self.textSize - self.defaultTextSize * 0.05
                    self.text2Size = self.text2Size - self.defaultText2Size * 0.05

                    -- Limit size.Cut off any extra text
                    if self.textSize < = self.textMinSize then
                        -- Undo
                        self.textSize = self.textSize + self.defaultTextSize * 0.05
                        self.text2Size = self.text2Size + self.defaultText2Size * 0.05

                        if textMaxNumLines = = 1 then
                            text = Utils.limitTextToWidth(text, self.textSize, maxWidth, false , " .. ." )
                        else
                                limitVerticalLines = true
                            end

                            break
                        end
                    end
                else
                        while getTextWidth( self.textSize, text) > maxWidth do
                            self.textSize = self.textSize - self.defaultTextSize * 0.05
                            self.text2Size = self.text2Size - self.defaultText2Size * 0.05

                            -- Limit size.Cut off any extra text
                            if self.textSize < = self.textMinSize then
                                -- Undo
                                self.textSize = self.textSize + self.defaultTextSize * 0.05
                                self.text2Size = self.text2Size + self.defaultText2Size * 0.05

                                text = Utils.limitTextToWidth(text, self.textSize, maxWidth, false , " .. ." )

                                break
                            end
                        end
                    end

                    setTextWrapWidth( 0 )
                elseif textLayoutMode = = TextElement.LAYOUT_MODE.OVERFLOW or textLayoutMode = = TextElement.LAYOUT_MODE.SCROLLING then -- luacheck:ignore
                        -- Note:with textMaxNumLines set, it overflows vertically instead of horizontally
                    elseif textLayoutMode = = TextElement.LAYOUT_MODE.TRUNCATE or textLayoutMode = = TextElement.LAYOUT_MODE.FILL then
                            -- We need to find a fitting amount of text for the width and max num lines
                                -- Engine tools don't provide max num lines so we do it by hand

                                    -- Fast case:use engine
                                    if self.textMaxNumLines = = 1 and textLayoutMode = = TextElement.LAYOUT_MODE.TRUNCATE then
                                        text = Utils.limitTextToWidth(text, self.textSize, maxWidth, false , " .. ." )
                                    else
                                            limitVerticalLines = true
                                        end
                                    end

                                    if limitVerticalLines then
                                        -- Check for too-many first
                                            setTextWrapWidth(maxWidth)
                                            local _, numLines = getTextHeight( self.textSize, text)

                                            if numLines > self.textMaxNumLines then
                                                local lastCharAllowsBreak = false

                                                while true do
                                                    _, numLines = getTextHeight( self.textSize, text)
                                                    if numLines > self.textMaxNumLines then
                                                        lastCharAllowsBreak = string.match(text, "[%p%s]$" )
                                                        text = utf8Substr(text, 0 , utf8Strlen(text) - 1 )
                                                    else
                                                            break
                                                        end
                                                    end

                                                    if textLayoutMode = = TextElement.LAYOUT_MODE.TRUNCATE then
                                                        -- Add ellipsis
                                                        text = utf8Substr(text, 0 , math.max(utf8Strlen(text) - 3 , 0 )) .. " .. ."
                                                    elseif self.textLayoutMode = = TextElement.LAYOUT_MODE.FILL and not lastCharAllowsBreak then
                                                            --TextElement.LAYOUT_MODE.FILL:we dont want to cut off a word in the middle, so we delete characters from the back until we hit a whitespace
                                                            while utf8Strlen(text) > 0 do
                                                                local needsBreak = string.match(text, "[%p%s]$" )
                                                                text = utf8Substr(text, 0 , utf8Strlen(text) - 1 )

                                                                if needsBreak then
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end

                                                    setTextWrapWidth( 0 )
                                                end

                                                setTextBold( false )

                                                self.text = text

                                                if textHasChanged and not skipCallback then
                                                    self:raiseCallback( "onTextChangedCallback" , self , self.text)
                                                    self:updateScaledWidth( 1 , 1 )
                                                end

                                                self:updateSize(forceTextSize)

                                                return textHasChanged
                                            end

```

### setTextSelectedColor

**Description**

> Set text selected color

**Definition**

> setTextSelectedColor()

**Arguments**

| any | r |
|-----|---|
| any | g |
| any | b |
| any | a |

**Code**

```lua
function TextElement:setTextSelectedColor(r,g,b,a)
    self.textSelectedColor = { r,g,b,a }
end

```

### setTextSize

**Description**

**Definition**

> setTextSize()

**Arguments**

| any | size |
|-----|------|

**Code**

```lua
function TextElement:setTextSize(size)
    self.textSize = size
    self:updateSize()
end

```

### setValue

**Description**

> Set value to format. Overrides text

**Definition**

> setValue()

**Arguments**

| any | value |
|-----|-------|

**Code**

```lua
function TextElement:setValue(value)
    self.value = value
    self:updateFormattedText()
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
function TextElement:update(dt)
    TextElement:superClass().update( self , dt)

    if self.textLayoutMode = = TextElement.LAYOUT_MODE.SCROLLING then
        local currentTextLayoutMode = self:getTextLayoutMode()
        self:updateScrollingLayoutMode()

        if currentTextLayoutMode = = TextElement.LAYOUT_MODE.SCROLLING then
            if self.scrollingMaxOffset > 0 then
                local scrollLengthFactor = self.scrollingMaxOffset / self.absSize[ 1 ]
                local scrollDuration = 9000 * ((scrollLengthFactor - 1 ) * 0.5 + 1 )

                self.scrollTime = self.scrollTime + dt
                if self.scrollTime > = scrollDuration then
                    self.scrollTime = - scrollDuration
                end

                local alpha = MathUtil.smoothstep( 0.2 , 0.8 , math.abs( self.scrollTime) / scrollDuration)
                self.scrollingOffset = self.scrollingMaxOffset * alpha
            end

            if self.absPosition[ 1 ] ~ = self.scrollingStartPos - self.scrollingOffset then
                self.ignoreStartPositionUpdate = true
                self:setAbsolutePosition( self.scrollingStartPos - self.scrollingOffset, nil )
                self.ignoreStartPositionUpdate = false
            end
        end
    end
end

```

### updateAbsolutePosition

**Description**

> Update text after size changes

**Definition**

> updateAbsolutePosition()

**Code**

```lua
function TextElement:updateAbsolutePosition()
    TextElement:superClass().updateAbsolutePosition( self )

    local textLayoutMode = self:getTextLayoutMode()

    if ( self.textMaxNumLines ~ = 1 or(textLayoutMode ~ = TextElement.LAYOUT_MODE.OVERFLOW and textLayoutMode ~ = TextElement.LAYOUT_MODE.SCROLLING))
        and not self.textAutoWidth and not self.textAutoHeight then

        self:setTextInternal( self.sourceText, nil , true )
    end

    if not self.ignoreStartPositionUpdate then
        self.scrollingStartPos = self.absPosition[ 1 ]

        self:updateScrollingParameters()
    end
end

```

### updateFormattedText

**Description**

> Update the formatted text after value or formatter changed

**Definition**

> updateFormattedText()

**Code**

```lua
function TextElement:updateFormattedText()
    local text = ""

    local value = self.value
    if value ~ = nil then
        local format = self.format

        local decimalPlaces = self.formatDecimalPlaces

        if format = = TextElement.FORMAT.NONE then
            text = tostring(value)
        elseif format = = TextElement.FORMAT.NUMBER then
                text = g_i18n:formatNumber(value, decimalPlaces)
            elseif format = = TextElement.FORMAT.CURRENCY then
                    text = g_i18n:formatMoney(value, decimalPlaces, true , true )
                elseif format = = TextElement.FORMAT.ACCOUNTING then
                        text = g_i18n:formatMoney(value, decimalPlaces, true , false )
                    elseif format = = TextElement.FORMAT.TEMPERATURE then
                            text = g_i18n:formatTemperature(value, decimalPlaces)
                        elseif format = = TextElement.FORMAT.PERCENTAGE then
                                text = g_i18n:formatNumber(value * 100 , decimalPlaces) .. "%"
                            end
                        elseif self.locaKey ~ = nil then
                                local length = self.locaKey:len()

                                if self.locaKey:sub(length, length + 1 ) = = ":" then
                                    text = g_i18n:getText( self.locaKey:sub( 1 , length - 1 ), self.customEnvironment) .. ":"
                                else
                                        text = g_i18n:getText( self.locaKey, self.customEnvironment)
                                    end
                                end

                                self:setTextInternal(text)
                            end

```

### updateScaledWidth

**Description**

> Update a zero-size text element width to its text width.

**Definition**

> updateScaledWidth(float xScale)

**Arguments**

| float | xScale | Aspect ratio x scale |
|-------|--------|----------------------|

**Code**

```lua
function TextElement:updateScaledWidth(xScale)
    if self.text ~ = nil and self.text ~ = "" and self.absSize[ 1 ] = = 0 and self.absSize[ 2 ] = = 0 then
        local width = self:getTextWidth()
        -- TODO
        -- if self.textWrapWidth > 0 then
            -- width = math.min(width, self.textWrapWidth)
            -- end

            -- compensate pre-scaled width with xScale
            self:setSize(width / xScale, self.textSize)
        end
    end

```

### updateScrollingLayoutMode

**Description**

> Updates the scrolling layout mode according to current focus and selection state, needed for scrolling texts

**Definition**

> updateScrollingLayoutMode()

**Code**

```lua
function TextElement:updateScrollingLayoutMode()
    local currentTextLayoutMode = self:getTextLayoutMode()
    if self.lastTextLayoutMode ~ = currentTextLayoutMode then
        self:setText( self.sourceText, nil , nil , true )
        self.lastTextLayoutMode = currentTextLayoutMode
    end
end

```

### updateScrollingParameters

**Description**

**Definition**

> updateScrollingParameters()

**Code**

```lua
function TextElement:updateScrollingParameters()
    if self.textLayoutMode = = TextElement.LAYOUT_MODE.SCROLLING then
        self:setAbsolutePosition( self.scrollingStartPos)

        self.scrollingOffset = 0
        self.scrollingMaxOffset = math.max( 0 , self:getTextWidth( true ) - self.absSize[ 1 ])
        self.scrollingClipArea = self.scrollingClipArea or { }
        self.scrollingClipArea[ 1 ] = self.scrollingStartPos
        self.scrollingClipArea[ 2 ] = self.absPosition[ 2 ]
        self.scrollingClipArea[ 3 ] = self.scrollingStartPos + self.absSize[ 1 ]
        self.scrollingClipArea[ 4 ] = self.absPosition[ 2 ] + self.absSize[ 2 ]

        if self.scrollingMaxOffset > 0 then
            self.textAlignment = RenderText.ALIGN_LEFT
        else
                self.textAlignment = self.textOriginalAlignment
            end
        end
    end

```

### updateSize

**Description**

> Update the size of the element depending on the contents

**Definition**

> updateSize()

**Arguments**

| any | forceTextSize |
|-----|---------------|

**Code**

```lua
function TextElement:updateSize(forceTextSize)
    -- Only update when auto width is enabled and max lines is 1, or auto height is enabled and there are at least 2 lines

    local width, height
    local textHeight, numLines = self:getTextHeight()

    if self.textAutoWidth and forceTextSize ~ = true then
        local offset = self:getTextOffset()

        -- We need to manually apply aspect scaling because element size is not updated
        -- This is a bit of a hack .. .the aspect scaling at all is quite a hack.
        local textSize = self.textSize

        -- Get width using the source text, as the element is supposed to fit all text(as textAutoWidth is enabled and max lines is 1)
        setTextBold( self.textBold)
        local textWidth = getTextWidth(textSize, self.sourceText)
        setTextBold( false )

        -- Limit element to max width
        if self.textMaxWidth ~ = nil then
            textWidth = math.min( self.textMaxWidth, textWidth)
        end
        if self.textMinWidth ~ = nil then
            textWidth = math.max( self.textMinWidth, textWidth)
        end

        width = offset + textWidth
        if width ~ = self.size[ 1 ] then
            if self.size[ 2 ] = = 0 then
                height = self.textSize
            end
        end
    end

    if self.textAutoHeight and forceTextSize ~ = true then
        height = textHeight
    end

    if width ~ = nil or height ~ = nil then
        self:setSize(width, height)

        if self.parent ~ = nil and self.parent.invalidateLayout ~ = nil and self.parent.autoValidateLayout then
            self.parent:invalidateLayout()
        end
    end

    if self.textLayoutMode = = TextElement.LAYOUT_MODE.FILL then
        self.textMaxNumLines = math.floor( self.absSize[ 2 ] / ( self.textSize * self.textLineHeightScale))
    end
end

```