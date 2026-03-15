## OptionSliderElement

**Description**

> MultiTextOptionElement with a slider to adjust values

**Parent**

> [MultiTextOptionElement](?version=script&category=43&class=479)

**Functions**

- [addDefaultElements](#adddefaultelements)
- [copyAttributes](#copyattributes)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [mouseEvent](#mouseevent)
- [new](#new)
- [onOpen](#onopen)
- [setElementsByName](#setelementsbyname)
- [touchEvent](#touchevent)
- [updateAbsolutePosition](#updateabsoluteposition)
- [updateContentElement](#updatecontentelement)
- [updateSlider](#updateslider)

### addDefaultElements

**Description**

> Adds the default slider element, if autoAddDefaultElements = true

**Definition**

> addDefaultElements()

**Code**

```lua
function OptionSliderElement:addDefaultElements()
    OptionSliderElement:superClass().addDefaultElements( self )

    if self.autoAddDefaultElements then
        if self:getDescendantByName( "fillingBar" ) = = nil then
            if self.defaultProfileFillingBar ~ = nil then
                local baseElement = BitmapElement.new( self )
                baseElement.name = "fillingBar"
                self:addElement(baseElement)
                baseElement:applyProfile( self.defaultProfileFillingBar)
            elseif self.defaultProfileFillingBarThreePart ~ = nil then
                    local baseElement = ThreePartBitmapElement.new( self )
                    baseElement.name = "fillingBar"
                    self:addElement(baseElement)
                    baseElement:applyProfile( self.defaultProfileFillingBarThreePart)
                end
            end

            if self:getDescendantByName( "slider" ) = = nil then
                if self.defaultProfileSliderRound ~ = nil then
                    local baseElement = RoundCornerElement.new( self )
                    baseElement.name = "slider"
                    self:addElement(baseElement)
                    baseElement:applyProfile( self.defaultProfileSliderRound)
                elseif self.defaultProfileSlider ~ = nil then
                        local baseElement = BitmapElement.new( self )
                        baseElement.name = "slider"
                        self:addElement(baseElement)
                        baseElement:applyProfile( self.defaultProfileSlider)
                    end
                end
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
function OptionSliderElement:copyAttributes(src)
    OptionSliderElement:superClass().copyAttributes( self , src)

    self.sliderOffset = src.sliderOffset
    self.useFillingBar = src.useFillingBar
    self.updateTextPosition = src.updateTextPosition

    self.defaultProfileSlider = src.defaultProfileSlider
    self.defaultProfileSliderRound = src.defaultProfileSliderRound

    self.defaultProfileFillingBar = src.defaultProfileFillingBar
    self.defaultProfileFillingBarThreePart = src.defaultProfileFillingBarThreePart
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
function OptionSliderElement:loadFromXML(xmlFile, key)
    OptionSliderElement:superClass().loadFromXML( self , xmlFile, key)

    self.sliderOffset = GuiUtils.getNormalizedXValue(getXMLInt(xmlFile, key .. "#sliderOffset" ), self.sliderOffset)
    self.useFillingBar = getXMLBool(xmlFile, key .. "#useFillingBar" ) or self.useFillingBar
    self.updateTextPosition = getXMLBool(xmlFile, key .. "#updateTextPosition" ) or self.updateTextPosition
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
function OptionSliderElement:loadProfile(profile, applyProfile)
    OptionSliderElement:superClass().loadProfile( self , profile, applyProfile)

    self.sliderOffset = GuiUtils.getNormalizedXValue(profile:getValue( "sliderOffset" ), self.sliderOffset)
    self.useFillingBar = profile:getBool( "useFillingBar" , self.useFillingBar)
    self.updateTextPosition = profile:getBool( "updateTextPosition" , self.updateTextPosition)

    self.defaultProfileSlider = profile:getValue( "defaultProfileSlider" , self.defaultProfileSlider)
    self.defaultProfileSliderRound = profile:getValue( "defaultProfileSliderRound" , self.defaultProfileSliderRound)

    self.defaultProfileFillingBar = profile:getValue( "defaultProfileFillingBar" , self.defaultProfileFillingBar)
    self.defaultProfileFillingBarThreePart = profile:getValue( "defaultProfileFillingBarThreePart" , self.defaultProfileFillingBarThreePart)
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
function OptionSliderElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if self:getIsActive() then
        if not( self.wasContinuousTrigger and isUp) then
            --we want to skip the MTO mouse event, so the MTO super class function is called
                if MultiTextOptionElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, button, eventUsed) then
                    eventUsed = true
                end
            else
                    eventUsed = true
                end

                if isDown then
                    local leftButton = self.leftButtonElement
                    self.isLeftButtonPressed = not self.hideLeftRightButtons and
                    GuiUtils.checkOverlayOverlap(posX, posY, leftButton.absPosition[ 1 ], leftButton.absPosition[ 2 ], leftButton.absSize[ 1 ], leftButton.absSize[ 2 ], leftButton.hotspot)

                    local rightButton = self.rightButtonElement
                    self.isRightButtonPressed = not self.hideLeftRightButtons and
                    GuiUtils.checkOverlayOverlap(posX, posY, rightButton.absPosition[ 1 ], rightButton.absPosition[ 2 ], rightButton.absSize[ 1 ], rightButton.absSize[ 2 ], rightButton.hotspot)

                    local slider = self.sliderElement
                    self.isSliderPressed = slider ~ = nil and GuiUtils.checkOverlayOverlap(posX, posY, slider.absPosition[ 1 ], slider.absPosition[ 2 ], slider.absSize[ 1 ], slider.absSize[ 2 ], slider.hotspot)
                    self.isSliderAreaPressed = GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ] + self.sliderOffset, self.absPosition[ 2 ], self.absSize[ 1 ] - 2 * self.sliderOffset, self.absSize[ 2 ])

                    if self.sliderMousePosX = = nil then
                        self.sliderMousePosX = posX
                    end

                    self.delayTime = g_ time
                elseif isUp then
                        self.delayTime = math.huge
                        self.scrollDelayDuration = MultiTextOptionElement.FIRST_INPUT_DELAY

                        self.wasContinuousTrigger = false
                        self.continuousTriggerTime = 0

                        self.isLeftButtonPressed = false
                        self.leftDelayTime = 0
                        self.isRightButtonPressed = false
                        self.rightDelayTime = 0
                        self.isSliderPressed = false
                        self.isSliderAreaPressed = false
                        self.sliderMousePosX = nil
                        self.hasWrapped = false
                    end

                    if not eventUsed and GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ], self.absPosition[ 2 ], self.absSize[ 1 ], self.absSize[ 2 ], nil ) then
                        if not self.inputEntered and not self:getIsFocused() then
                            FocusManager:setHighlight( self )
                            self.inputEntered = true
                        end

                        --lets players drag MTO sliders, sets slider position and state according to movement
                        if # self.texts > 1 and self.isSliderAreaPressed then
                            if not self:getIsFocused() then
                                FocusManager:setFocus( self )
                            end

                            local slider = self.sliderElement
                            local sliderWidth = slider.absSize[ 1 ]
                            local stepSize = ( self.absSize[ 1 ] - 2 * self.sliderOffset - sliderWidth) / (# self.texts - 1 )

                            local mouseMoveDistance = posX - self.sliderMousePosX
                            local sliderLocalPosX = posX - self.absPosition[ 1 ] - self.sliderOffset - slider.absSize[ 1 ] * 0.5

                            if self.isSliderPressed then
                                sliderLocalPosX = slider.absPosition[ 1 ] - self.absPosition[ 1 ] - self.sliderOffset
                            end

                            local sliderPosX = MathUtil.snapValue(sliderLocalPosX + mouseMoveDistance, stepSize)
                            sliderPosX = math.clamp(sliderPosX, 0 , self.absSize[ 1 ] - sliderWidth - 2 * self.sliderOffset)
                            local state = MathUtil.round(sliderPosX / stepSize) + 1

                            if state ~ = self.state then
                                if self.isSliderPressed then
                                    self.sliderMousePosX = self.sliderMousePosX + stepSize * (state - self.state)
                                end

                                self.isSliderPressed = true
                                self:setState(state, true )
                            end

                            slider:setAbsolutePosition( self.absPosition[ 1 ] + sliderPosX + self.sliderOffset, slider.absPosition[ 2 ])

                            if self.updateTextPosition then
                                self.textElement:setAbsolutePosition(slider.absPosition[ 1 ] - ( self.textElement.absSize[ 1 ] - slider.absSize[ 1 ]) * 0.5 , self.textElement.absPosition[ 2 ])
                            end

                            if self.useFillingBar then
                                self.fillingBarElement:setSize(( self.state - 1 ) / (# self.texts - 1 ) * ( self.absSize[ 1 ] - self.sliderOffset * 2 ) + self.sliderOffset, nil )
                            end
                        end
                    else
                            if self.inputEntered and not self.focusActive then
                                FocusManager:unsetHighlight( self )
                                self.inputEntered = false
                            end
                        end
                    end

                    return eventUsed
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
function OptionSliderElement.new(target, custom_mt)
    local self = MultiTextOptionElement.new(target, custom_mt or OptionSliderElement _mt)

    self.sliderElement = nil
    self.sliderOffset = nil
    self.defaultProfileSlider = nil
    self.defaultProfileSliderRound = nil

    self.useFillingBar = false
    self.fillingBarElement = nil
    self.defaultProfileFillingBar = nil
    self.defaultProfileFillingBarThreePart = nil

    self.updateTextPosition = true

    return self
end

```

### onOpen

**Description**

**Definition**

> onOpen()

**Code**

```lua
function OptionSliderElement:onOpen()
    OptionSliderElement:superClass().onOpen( self )

    self:updateSlider()
end

```

### setElementsByName

**Description**

> We need to re-add all current elements, because they might not have had their name when they were first added

**Definition**

> setElementsByName()

**Code**

```lua
function OptionSliderElement:setElementsByName()
    OptionSliderElement:superClass().setElementsByName( self )

    for _, element in pairs( self.elements) do
        if element.name = = "slider" then
            self.sliderElement = element
            element.target = self
        end

        if element.name = = "fillingBar" then
            self.fillingBarElement = element
            element.target = self
        end
    end

    if self.fillingBarElement = = nil then
        self.useFillingBar = false
    end

    if self.sliderElement = = nil then
        Logging.warning( "OptionSliderElement:could not find a slider element for element with profile " .. self.profile)
        elseif self.leftButtonElement ~ = nil and self.sliderElement.absSize[ 1 ] + self.leftButtonElement.absSize[ 1 ] * 2 > = self.absSize[ 1 ] then
                self.sliderOffset = self.absSize[ 1 ] / 2
                Logging.warning( "OptionSliderElement:not enough space for slider movement with current settings in profile " .. self.profile)
                end
            end

```

### touchEvent

**Description**

**Definition**

> touchEvent()

**Arguments**

| any | posX      |
|-----|-----------|
| any | posY      |
| any | isDown    |
| any | isUp      |
| any | touchId   |
| any | eventUsed |

**Code**

```lua
function OptionSliderElement:touchEvent(posX, posY, isDown, isUp, touchId, eventUsed)
    if self:getIsActive() then
        if not( self.wasContinuousTrigger and isUp) then
            --we want to skip the MTO mouse event, so the MTO super class function is called
                if MultiTextOptionElement:superClass().touchEvent( self , posX, posY, isDown, isUp, touchId, eventUsed) then
                    eventUsed = true
                end
            else
                    eventUsed = true
                end

                if isDown then
                    local leftButton = self.leftButtonElement
                    self.isLeftButtonPressed = not self.hideLeftRightButtons and GuiUtils.checkOverlayOverlap(posX, posY, leftButton.absPosition[ 1 ], leftButton.absPosition[ 2 ], leftButton.absSize[ 1 ], leftButton.absSize[ 2 ], leftButton.hotspot)

                    local rightButton = self.rightButtonElement
                    self.isRightButtonPressed = not self.hideLeftRightButtons and GuiUtils.checkOverlayOverlap(posX, posY, rightButton.absPosition[ 1 ], rightButton.absPosition[ 2 ], rightButton.absSize[ 1 ], rightButton.absSize[ 2 ], rightButton.hotspot)

                    local slider = self.sliderElement
                    self.isSliderPressed = slider ~ = nil and GuiUtils.checkOverlayOverlap(posX, posY, slider.absPosition[ 1 ], slider.absPosition[ 2 ], slider.absSize[ 1 ], slider.absSize[ 2 ], slider.hotspot)

                    if self.sliderMousePosX = = nil then
                        self.sliderMousePosX = posX
                    end

                    self.delayTime = g_ time
                elseif isUp then
                        self.delayTime = math.huge
                        self.scrollDelayDuration = MultiTextOptionElement.FIRST_INPUT_DELAY

                        self.wasContinuousTrigger = false
                        self.continuousTriggerTime = 0

                        self.isLeftButtonPressed = false
                        self.leftDelayTime = 0
                        self.isRightButtonPressed = false
                        self.rightDelayTime = 0
                        self.isSliderPressed = false
                        self.sliderMousePosX = nil
                        self.hasWrapped = false
                    end

                    if not eventUsed and GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ], self.absPosition[ 2 ], self.absSize[ 1 ], self.absSize[ 2 ], nil ) then
                        if not self.inputEntered and not self:getIsFocused() then
                            FocusManager:setHighlight( self )
                            self.inputEntered = true
                        end

                        --lets players drag MTO sliders, sets slider position and state according to movement
                        if self.isSliderPressed and # self.texts > 1 then
                            if not self:getIsFocused() then
                                FocusManager:setFocus( self )
                            end

                            local slider = self.sliderElement
                            local sliderWidth = slider.absSize[ 1 ]
                            local stepSize = ( self.absSize[ 1 ] - 2 * self.sliderOffset - sliderWidth) / (# self.texts - 1 )

                            local mouseMoveDistance = posX - self.sliderMousePosX
                            local sliderLocalPosX = slider.absPosition[ 1 ] - self.absPosition[ 1 ] - self.sliderOffset

                            local sliderPosX = MathUtil.snapValue(sliderLocalPosX + mouseMoveDistance, stepSize)
                            sliderPosX = math.clamp(sliderPosX, 0 , self.absSize[ 1 ] - sliderWidth - 2 * self.sliderOffset)
                            local state = MathUtil.round(sliderPosX / stepSize) + 1

                            if state ~ = self.state then
                                self.sliderMousePosX = self.sliderMousePosX + stepSize * (state - self.state)
                                self:setState(state, true )
                            end

                            slider:setAbsolutePosition( self.absPosition[ 1 ] + sliderPosX + self.sliderOffset, slider.absPosition[ 2 ])

                            if self.updateTextPosition then
                                self.textElement:setAbsolutePosition(slider.absPosition[ 1 ] - ( self.textElement.absSize[ 1 ] - slider.absSize[ 1 ]) * 0.5 , self.textElement.absPosition[ 2 ])
                            end

                            if self.useFillingBar then
                                self.fillingBarElement:setSize(( self.state - 1 ) / (# self.texts - 1 ) * ( self.absSize[ 1 ] - self.sliderOffset * 2 ) + self.sliderOffset, nil )
                            end
                        end
                    else
                            if self.inputEntered and not self:getIsFocused() then
                                FocusManager:unsetHighlight( self )
                                self.inputEntered = false
                            end
                        end
                    end

                    return eventUsed
                end

```

### updateAbsolutePosition

**Description**

**Definition**

> updateAbsolutePosition()

**Code**

```lua
function OptionSliderElement:updateAbsolutePosition()
    OptionSliderElement:superClass().updateAbsolutePosition( self )

    self:updateSlider()
end

```

### updateContentElement

**Description**

**Definition**

> updateContentElement()

**Code**

```lua
function OptionSliderElement:updateContentElement()
    OptionSliderElement:superClass().updateContentElement( self )

    self:updateSlider()
end

```

### updateSlider

**Description**

**Definition**

> updateSlider()

**Code**

```lua
function OptionSliderElement:updateSlider()
    if self.sliderElement ~ = nil then
        --by default, the slider offset is width of the left button
        if self.sliderOffset = = nil then
            self.sliderOffset = self.leftButtonElement.absSize[ 1 ]
        end

        local text = self.textElement
        local slider = self.sliderElement

        local minVal = self.absPosition[ 1 ] + self.sliderOffset
        local maxVal = self.absPosition[ 1 ] + self.absSize[ 1 ] - slider.absSize[ 1 ] - self.sliderOffset
        local pos = maxVal
        if # self.texts > 1 then
            pos = minVal + ( self.state - 1 ) / (# self.texts - 1 ) * (maxVal - minVal)
        end

        slider:setAbsolutePosition(pos, slider.absPosition[ 2 ])

        if self.updateTextPosition then
            text:setAbsolutePosition(pos - (text.absSize[ 1 ] - slider.absSize[ 1 ]) * 0.5 , text.absPosition[ 2 ])
        end

        if self.useFillingBar then
            local fillingBarSize = self.absSize[ 1 ] - self.sliderOffset
            if # self.texts > 1 then
                fillingBarSize = ( self.state - 1 ) / (# self.texts - 1 ) * ( self.absSize[ 1 ] - self.sliderOffset * 2 ) + self.sliderOffset
            end

            self.fillingBarElement:setSize(fillingBarSize, nil )
        end
    end
end

```