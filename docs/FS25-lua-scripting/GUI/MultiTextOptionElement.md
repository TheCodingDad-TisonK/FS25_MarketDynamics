## MultiTextOptionElement

**Description**

> Multiple choice text element.
> This element requires a specific configuration setup to be properly used: In the configuration, it must contain the
> following child elements in this order: 1. ButtonElement, 2. ButtonElement, 3. TextElement, 4. TextElement. The first
> three elements are mandatory, as they are the buttons to change this element's value and the label which displays the
> value. The fourth (text) element is optional and used as a header label for this element if defined.

**Parent**

> [GuiElement](?version=script&category=43&class=476)

**Functions**

- [addDefaultElements](#adddefaultelements)
- [addText](#addtext)
- [canReceiveFocus](#canreceivefocus)
- [clone](#clone)
- [copyAttributes](#copyattributes)
- [disableButtonSounds](#disablebuttonsounds)
- [getCanChangeState](#getcanchangestate)
- [getState](#getstate)
- [inputEvent](#inputevent)
- [loadFromXML](#loadfromxml)
- [loadProfile](#loadprofile)
- [mouseEvent](#mouseevent)
- [new](#new)
- [onFocusEnter](#onfocusenter)
- [onFocusLeave](#onfocusleave)
- [onGuiSetupFinished](#onguisetupfinished)
- [onLeftButtonClicked](#onleftbuttonclicked)
- [onRightButtonClicked](#onrightbuttonclicked)
- [setCanChangeState](#setcanchangestate)
- [setElementsByName](#setelementsbyname)
- [setIcons](#seticons)
- [setLabel](#setlabel)
- [setState](#setstate)
- [setTexts](#settexts)
- [touchEvent](#touchevent)
- [update](#update)
- [updateContentElement](#updatecontentelement)

### addDefaultElements

**Description**

> Adds all default elements of this element. there is a default element for left and right button, text, and the
> background

**Definition**

> addDefaultElements()

**Code**

```lua
function MultiTextOptionElement:addDefaultElements()
    if self.autoAddDefaultElements then
        if self:getDescendantByName( "background" ) = = nil then
            if self.defaultProfileBgRound ~ = nil and self.defaultProfileBgRound ~ = "" then
                local baseElement = RoundCornerElement.new( self )
                baseElement.name = "background"
                self:addElement(baseElement)
                baseElement:applyProfile( self.defaultProfileBgRound)
            elseif self.defaultProfileBgThreePart ~ = nil and self.defaultProfileBgThreePart ~ = "" then
                    local baseElement = ThreePartBitmapElement.new( self )
                    baseElement.name = "background"
                    self:addElement(baseElement)
                    baseElement:applyProfile( self.defaultProfileBgThreePart)
                elseif self.defaultProfileBg ~ = nil then
                        local baseElement = BitmapElement.new( self )
                        baseElement.name = "background"
                        self:addElement(baseElement)
                        baseElement:applyProfile( self.defaultProfileBg)
                    end
                end

                if self:getDescendantByName( "left" ) = = nil then
                    local baseElement = ButtonElement.new( self )
                    baseElement.name = "left"
                    self:addElement(baseElement)
                    baseElement:applyProfile( self.defaultProfileButtonLeft)
                end

                if self:getDescendantByName( "right" ) = = nil then
                    local baseElement = ButtonElement.new( self )
                    baseElement.name = "right"
                    self:addElement(baseElement)
                    baseElement:applyProfile( self.defaultProfileButtonRight)
                end

                if self:getDescendantByName( "text" ) = = nil then
                    local baseElement = TextElement.new( self )
                    baseElement.name = "text"
                    self:addElement(baseElement)
                    baseElement:applyProfile( self.defaultProfileText)
                end
            end
        end

```

### addText

**Description**

**Definition**

> addText()

**Arguments**

| any | text |
|-----|------|
| any | i    |

**Code**

```lua
function MultiTextOptionElement:addText(text, i)
    if i = = nil then
        table.insert( self.texts, text)
    else
            table.insert( self.texts, i, text)
        end
        self:updateContentElement()

        if self.useDynamicInputSteps ~ = false then
            self.dynamicInputStep = math.min( math.floor(# self.texts / 5 ), 10 )
        end

        self:notifyIndexChange( self.state, # self.texts)
    end

```

### canReceiveFocus

**Description**

**Definition**

> canReceiveFocus()

**Arguments**

| any | element   |
|-----|-----------|
| any | direction |

**Code**

```lua
function MultiTextOptionElement:canReceiveFocus(element, direction)
    return not self.disabled and self:getIsVisible() and self.handleFocus and( not self.disableButtonsOnSingleText or # self.texts > 1 )
end

```

### clone

**Description**

**Definition**

> clone()

**Arguments**

| any | parent                   |
|-----|--------------------------|
| any | includeId                |
| any | suppressOnCreate         |
| any | blockFocusHandlingReload |

**Code**

```lua
function MultiTextOptionElement:clone(parent, includeId, suppressOnCreate, blockFocusHandlingReload)
    local ret = MultiTextOptionElement:superClass().clone( self , parent, includeId, suppressOnCreate, blockFocusHandlingReload)

    ret:addDefaultElements()
    ret:setElementsByName()

    return ret
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
function MultiTextOptionElement:copyAttributes(src)
    MultiTextOptionElement:superClass().copyAttributes( self , src)

    self.isChecked = src.isChecked
    self.buttonLRChange = src.buttonLRChange
    self.state = src.state
    self.wrap = src.wrap
    self.hideLeftRightButtons = src.hideLeftRightButtons
    self.hideButtonOnLimitReached = src.hideButtonOnLimitReached
    self.disableButtonsOnSingleText = src.disableButtonsOnSingleText
    self.baseScrollDelayDuration = src.baseScrollDelayDuration
    self.continuousInputStep = src.continuousInputStep
    self.useDynamicInputSteps = src.useDynamicInputSteps
    self.registerContinuousInput = src.registerContinuousInput
    self.canChangeState = src.canChangeState

    self.defaultProfileButtonLeft = src.defaultProfileButtonLeft
    self.defaultProfileButtonRight = src.defaultProfileButtonRight
    self.defaultProfileText = src.defaultProfileText
    self.defaultProfileBg = src.defaultProfileBg
    self.defaultProfileBgRound = src.defaultProfileBgRound
    self.defaultProfileBgThreePart = src.defaultProfileBgThreePart
    self.autoAddDefaultElements = src.autoAddDefaultElements

    self.onClickCallback = src.onClickCallback
    self.onLeaveCallback = src.onLeaveCallback
    self.onFocusCallback = src.onFocusCallback

    for _, text in pairs(src.texts) do
        self:addText(text)
    end

    GuiMixin.cloneMixin( IndexChangeSubjectMixin , src, self )
    GuiMixin.cloneMixin( PlaySampleMixin , src, self )
end

```

### disableButtonSounds

**Description**

> Disable automatic playing of sound samples in child buttons.

**Definition**

> disableButtonSounds()

**Code**

```lua
function MultiTextOptionElement:disableButtonSounds()
    if self.leftButtonElement ~ = nil then
        self.leftButtonElement:disablePlaySample()
    end

    if self.rightButtonElement ~ = nil then
        self.rightButtonElement:disablePlaySample()
    end
end

```

### getCanChangeState

**Description**

**Definition**

> getCanChangeState()

**Code**

```lua
function MultiTextOptionElement:getCanChangeState()
    return self.canChangeState
end

```

### getState

**Description**

**Definition**

> getState()

**Code**

```lua
function MultiTextOptionElement:getState()
    return self.state
end

```

### inputEvent

**Description**

**Definition**

> inputEvent()

**Arguments**

| any | action    |
|-----|-----------|
| any | value     |
| any | eventUsed |

**Code**

```lua
function MultiTextOptionElement:inputEvent(action, value, eventUsed)
    eventUsed = MultiTextOptionElement:superClass().inputEvent( self , action, value, eventUsed)

    if not eventUsed then
        self.registeredInputEventThisFrame = true

        if action = = InputAction.MENU_AXIS_LEFT_RIGHT then
            if value < - g_analogStickHTolerance then
                eventUsed = true
                self:inputLeft( false )
                self.leftButtonElement:setPressed( true )
            elseif value > g_analogStickHTolerance then
                    eventUsed = true
                    self:inputRight( false )
                    self.rightButtonElement:setPressed( true )
                end
            elseif action = = InputAction.MENU_PAGE_PREV then
                    eventUsed = true
                    self:inputLeft( true )
                    self.leftButtonElement:setPressed( true )
                elseif action = = InputAction.MENU_PAGE_NEXT then
                        eventUsed = true
                        self:inputRight( true )
                        self.rightButtonElement:setPressed( true )
                    end
                end

                return eventUsed
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
function MultiTextOptionElement:loadFromXML(xmlFile, key)
    -- set custom env before super call to allow loading of tooltip text in GuiElement
    local xmlFilename = getXMLFilename(xmlFile)
    local modName, _ = Utils.getModNameAndBaseDirectory(xmlFilename)
    if modName ~ = nil then
        self.customEnvironment = modName
    end

    MultiTextOptionElement:superClass().loadFromXML( self , xmlFile, key)

    self:addCallback(xmlFile, key .. "#onClick" , "onClickCallback" )
    self:addCallback(xmlFile, key .. "#onFocus" , "onFocusCallback" )
    self:addCallback(xmlFile, key .. "#onLeave" , "onLeaveCallback" )

    self.wrap = Utils.getNoNil(getXMLBool(xmlFile, key .. "#wrap" ), self.wrap )
    self.hideLeftRightButtons = Utils.getNoNil(getXMLBool(xmlFile, key .. "#hideLeftRightButtons" ), self.hideLeftRightButtons)
    self.hideButtonOnLimitReached = Utils.getNoNil(getXMLBool(xmlFile, key .. "#hideButtonOnLimitReached" ), self.hideButtonOnLimitReached)
    self.disableButtonsOnSingleText = Utils.getNoNil(getXMLBool(xmlFile, key .. "#disableButtonsOnSingleText" ), self.disableButtonsOnSingleText)
    self.buttonLRChange = Utils.getNoNil(getXMLBool(xmlFile, key .. "#buttonLRChange" ), self.buttonLRChange)
    self.baseScrollDelayDuration = getXMLInt(xmlFile, key .. "#scrollDelayDuration" ) or self.baseScrollDelayDuration
    self.continuousInputStep = getXMLInt(xmlFile, key .. "#continuousInputStep" ) or self.continuousInputStep
    self.useDynamicInputSteps = Utils.getNoNil(getXMLBool(xmlFile, key .. "#useDynamicInputSteps" ), self.useDynamicInputSteps)
    self.registerContinuousInput = Utils.getNoNil(getXMLBool(xmlFile, key .. "#registerContinuousInput" ), self.registerContinuousInput)

    local text = getXMLString(xmlFile, key .. "#texts" )
    if text ~ = nil then
        local texts = text:split( "|" )
        for _, textPart in pairs(texts) do
            if textPart:sub( 1 , 6 ) = = "$l10n_" then
                textPart = g_i18n:getText(textPart:sub( 7 ), self.customEnvironment)
            end
            table.insert( self.texts, textPart)
        end
    end

    self.xmlFile = xmlFile
    self.xmlKey = key
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
function MultiTextOptionElement:loadProfile(profile, applyProfile)
    MultiTextOptionElement:superClass().loadProfile( self , profile, applyProfile)

    self.wrap = profile:getBool( "wrap" , self.wrap )
    self.hideLeftRightButtons = profile:getBool( "hideLeftRightButtons" , self.hideLeftRightButtons)
    self.hideButtonOnLimitReached = profile:getBool( "hideButtonOnLimitReached" , self.hideButtonOnLimitReached)
    self.disableButtonsOnSingleText = profile:getBool( "disableButtonsOnSingleText" , self.disableButtonsOnSingleText)
    self.buttonLRChange = profile:getBool( "buttonLRChange" , self.buttonLRChange)
    self.baseScrollDelayDuration = profile:getNumber( "scrollDelayDuration" , self.baseScrollDelayDuration)
    self.continuousInputStep = profile:getNumber( "continuousInputStep" , self.continuousInputStep)
    self.useDynamicInputSteps = profile:getBool( "useDynamicInputSteps" , self.useDynamicInputSteps)
    self.registerContinuousInput = profile:getBool( "registerContinuousInput" , self.registerContinuousInput)

    self.defaultProfileButtonLeft = profile:getValue( "defaultProfileButtonLeft" , self.defaultProfileButtonLeft)
    self.defaultProfileButtonRight = profile:getValue( "defaultProfileButtonRight" , self.defaultProfileButtonRight)
    self.defaultProfileText = profile:getValue( "defaultProfileText" , self.defaultProfileText)
    self.defaultProfileBg = profile:getValue( "defaultProfileBg" , self.defaultProfileBg)
    self.defaultProfileBgRound = profile:getValue( "defaultProfileBgRound" , self.defaultProfileBgRound)
    self.defaultProfileBgThreePart = profile:getValue( "defaultProfileBgThreePart" , self.defaultProfileBgThreePart)
    self.autoAddDefaultElements = profile:getBool( "autoAddDefaultElements" , self.autoAddDefaultElements)

    local text = profile:getValue( "texts" )
    if text ~ = nil then
        local texts = text:split( "|" )
        for _, textPart in pairs(texts) do
            if textPart:sub( 1 , 6 ) = = "$l10n_" then
                textPart = g_i18n:getText(textPart:sub( 7 ))
            end
            table.insert( self.texts, textPart)
        end
    end
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
function MultiTextOptionElement:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if self:getIsActive() then
        if MultiTextOptionElement:superClass().mouseEvent( self , posX, posY, isDown, isUp, button, eventUsed or self.wasContinuousTrigger and isUp) or self.wasContinuousTrigger and isUp then
            eventUsed = true
        end

        local isInElement = GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ], self.absPosition[ 2 ], self.absSize[ 1 ], self.absSize[ 2 ], nil )

        if isInElement and isDown then
            local leftButton = self.leftButtonElement
            self.isLeftButtonPressed = not self.hideLeftRightButtons and GuiUtils.checkOverlayOverlap(posX, posY, leftButton.absPosition[ 1 ], leftButton.absPosition[ 2 ], leftButton.size[ 1 ], leftButton.size[ 2 ], leftButton.hotspot)

            local rightButton = self.rightButtonElement
            self.isRightButtonPressed = not self.hideLeftRightButtons and GuiUtils.checkOverlayOverlap(posX, posY, rightButton.absPosition[ 1 ], rightButton.absPosition[ 2 ], rightButton.size[ 1 ], rightButton.size[ 2 ], rightButton.hotspot)

            self.delayTime = g_ time
        elseif not( self.leftButtonElement ~ = nil and self.leftButtonElement:getIsPressed() or
                self.rightButtonElement ~ = nil and self.rightButtonElement:getIsPressed()) then

                self.delayTime = math.huge

                self.isLeftButtonPressed = false
                self.isRightButtonPressed = false

                self:releaseInput()
            end

            if not eventUsed and isInElement then
                if not self.inputEntered and not self:getIsFocused() then
                    FocusManager:setHighlight( self )
                    self.inputEntered = true
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
function MultiTextOptionElement.new(target, custom_mt)
    local self = GuiElement.new(target, custom_mt or MultiTextOptionElement _mt)
    self:include( IndexChangeSubjectMixin ) -- add index change subject mixin for observers
        self:include( PlaySampleMixin ) -- add sound playing

        self.isChecked = false
        self.inputEntered = false
        self.buttonLRChange = false
        self.canChangeState = true

        self.state = 1
        self.wrap = true
        self.hideLeftRightButtons = false
        self.hideButtonOnLimitReached = false
        self.disableButtonsOnSingleText = false
        self.texts = { }

        self.registerContinuousInput = true
        self.continuousInputStep = nil --if continuous input is pressed for a certain amount of time, we use this step size instead to speed up scrolling
            self.useDynamicInputSteps = nil --if continuousInputStep is not set but this value is true, we calculate a step size based on the amount of texts, defaults to true
                self.dynamicInputStep = nil
                self.continuousTriggerTime = 0
                self.isLeftButtonPressed = false
                self.isRightButtonPressed = false
                self.wasContinuousTrigger = false
                self.scrollDelayDuration = MultiTextOptionElement.FIRST_INPUT_DELAY
                self.baseScrollDelayDuration = MultiTextOptionElement.INPUT_DELAY
                self.leftDelayTime = 0
                self.rightDelayTime = 0
                self.delayTime = 0

                self.leftButtonElement = nil
                self.rightButtonElement = nil
                self.textElement = nil
                self.labelElement = nil
                self.iconElement = nil
                self.bgElement = nil

                self.defaultProfileButtonLeft = nil
                self.defaultProfileButtonRight = nil
                self.defaultProfileText = nil
                self.defaultProfileBg = nil
                self.defaultProfileBgRound = nil
                self.defaultProfileBgThreePart = nil
                self.autoAddDefaultElements = false

                self.gradientElements = { }

                return self
            end

```

### onFocusEnter

**Description**

**Definition**

> onFocusEnter()

**Code**

```lua
function MultiTextOptionElement:onFocusEnter()
    MultiTextOptionElement:superClass().onFocusEnter( self )

    self:raiseCallback( "onFocusCallback" , self )
end

```

### onFocusLeave

**Description**

**Definition**

> onFocusLeave()

**Code**

```lua
function MultiTextOptionElement:onFocusLeave()
    MultiTextOptionElement:superClass().onFocusLeave( self )

    self:raiseCallback( "onLeaveCallback" , self )
end

```

### onGuiSetupFinished

**Description**

**Definition**

> onGuiSetupFinished()

**Code**

```lua
function MultiTextOptionElement:onGuiSetupFinished()
    self:addDefaultElements()
    self:setElementsByName()
    self:updateAbsolutePosition()

    if self.leftButtonElement ~ = nil then
        self.leftButtonElement.soundDisabled = true
    end
    if self.rightButtonElement ~ = nil then
        self.rightButtonElement.soundDisabled = true
    end
end

```

### onLeftButtonClicked

**Description**

**Definition**

> onLeftButtonClicked()

**Arguments**

| any | steps   |
|-----|---------|
| any | noFocus |

**Code**

```lua
function MultiTextOptionElement:onLeftButtonClicked(steps, noFocus)
    if self:getCanChangeState() then
        local defaultSteps = 1
        if self.continuousTriggerTime > = MultiTextOptionElement.FAST_SCROLL_DELAY then
            defaultSteps = self.continuousInputStep or self.dynamicInputStep or defaultSteps
        end
        steps = steps or defaultSteps
        if steps ~ = nil and type(steps) ~ = "number" then steps = 1 end

        local oldState = self.state
        for _ = 1 , steps do
            if self.wrap then
                self.state = self.state - 1
                if self.state < 1 then
                    if self.wasContinuousTrigger then
                        self.hasWrapped = true
                        self.state = self.state + 1
                    else
                            self.state = # self.texts
                        end
                    end
                else
                        self.state = math.max( self.state - 1 , 1 )
                    end
                end

                if not self.hasWrapped and self.state ~ = oldState then
                    self:playSample( GuiSoundPlayer.SOUND_SAMPLES.CLICK)
                end

                if (noFocus = = nil or not noFocus) then
                    self:setSoundSuppressed( true )
                    FocusManager:setFocus( self )
                    self:setSoundSuppressed( false )

                    if self.leftButtonElement ~ = nil then
                        self.leftButtonElement:onFocusEnter()
                    end
                    if self.rightButtonElement ~ = nil then
                        self.rightButtonElement:onFocusEnter()
                    end
                end

                self:updateContentElement()
                self:raiseClickCallback( true )
                self:notifyIndexChange( self.state, # self.texts)
            end
        end

```

### onRightButtonClicked

**Description**

**Definition**

> onRightButtonClicked()

**Arguments**

| any | steps   |
|-----|---------|
| any | noFocus |

**Code**

```lua
function MultiTextOptionElement:onRightButtonClicked(steps, noFocus)
    if self:getCanChangeState() then
        local defaultSteps = 1
        if self.continuousTriggerTime > = MultiTextOptionElement.FAST_SCROLL_DELAY then
            defaultSteps = self.continuousInputStep or self.dynamicInputStep or defaultSteps
        end
        steps = steps or defaultSteps
        if steps ~ = nil and type(steps) ~ = "number" then steps = 1 end

        local oldState = self.state
        for _ = 1 , steps do
            if self.wrap then
                self.state = self.state + 1
                if self.state > # self.texts then
                    if self.wasContinuousTrigger then
                        self.hasWrapped = true
                        self.state = self.state - 1
                    else
                            self.state = 1
                        end
                    end
                else
                        self.state = math.min( self.state + 1 , # self.texts)
                    end
                end

                if not self.hasWrapped and self.state ~ = oldState then
                    self:playSample( GuiSoundPlayer.SOUND_SAMPLES.CLICK)
                end

                if (noFocus = = nil or not noFocus) then
                    self:setSoundSuppressed( true )
                    FocusManager:setFocus( self )
                    self:setSoundSuppressed( false )

                    if self.leftButtonElement ~ = nil then
                        self.leftButtonElement:onFocusEnter()
                    end
                    if self.rightButtonElement ~ = nil then
                        self.rightButtonElement:onFocusEnter()
                    end
                end

                self:updateContentElement()
                self:raiseClickCallback( false )
                self:notifyIndexChange( self.state, # self.texts)
            end
        end

```

### setCanChangeState

**Description**

**Definition**

> setCanChangeState()

**Arguments**

| any | canChangeState |
|-----|----------------|

**Code**

```lua
function MultiTextOptionElement:setCanChangeState(canChangeState)
    self.canChangeState = canChangeState
end

```

### setElementsByName

**Description**

> We need to re-add all current elements, because they might not have had their name when they were first added

**Definition**

> setElementsByName()

**Code**

```lua
function MultiTextOptionElement:setElementsByName()
    for _, element in pairs( self.elements) do
        if element.name = = nil then
            -- do nothing with this element
                Logging.warning( "MultiTextOptionElement:Could not find a name for element with profile name '%s', using default element" , element.profile)
                    break
                end

                if element.name = = "left" then
                    -- left button
                    if self.leftButtonElement ~ = nil and self.leftButtonElement ~ = element then
                        self.leftButtonElement:delete()
                    end
                    self.leftButtonElement = element
                    element.target = self
                    element:setHandleFocus( false )
                    element:setCallback( "onClickCallback" , "onLeftButtonClicked" )
                    element:setDisabled( self.disabled)
                    element:setVisible( not self.hideLeftRightButtons)
                elseif element.name = = "right" then
                        -- right button
                        if self.rightButtonElement ~ = nil and self.rightButtonElement ~ = element then
                            self.rightButtonElement:delete()
                        end
                        self.rightButtonElement = element
                        element.target = self
                        element:setHandleFocus( false )
                        element:setCallback( "onClickCallback" , "onRightButtonClicked" )
                        element:setDisabled( self.disabled)
                        element:setVisible( not self.hideLeftRightButtons)
                    elseif element.name = = "label" then
                            self.labelElement = element
                        elseif element.name = = "text" then
                                if element:isa( TextElement ) then
                                    if self.textElement ~ = nil and self.textElement ~ = element then
                                        self.textElement:delete()
                                    end
                                    self.textElement = element
                                    self:updateContentElement()
                                end
                            elseif element.name = = "icon" then
                                    self.iconElement = element
                                    self:updateContentElement()
                                elseif element.name = = "gradient" then
                                        if element:isa( BitmapElement ) then
                                            table.insert( self.gradientElements, element)
                                        end
                                    elseif element.name = = "background" then
                                            if self.bgElement ~ = nil and self.bgElement ~ = element then
                                                self.bgElement:delete()
                                            end
                                            self.bgElement = element
                                            element:setSize( self.size[ 1 ])
                                        end
                                    end
                                end

```

### setIcons

**Description**

**Definition**

> setIcons()

**Arguments**

| any | icons |
|-----|-------|

**Code**

```lua
function MultiTextOptionElement:setIcons(icons)
    if icons = = nil then
        self.texts = { }
    else
            self.texts = icons
        end

        -- enables the mode that also allows the element to draw overlays instead of text
        self.isImageMode = true

        self.state = math.min( self.state, # self.texts)
        self:updateContentElement()

        self:notifyIndexChange( self.state, # self.texts)
    end

```

### setLabel

**Description**

**Definition**

> setLabel()

**Arguments**

| any | labelString |
|-----|-------------|

**Code**

```lua
function MultiTextOptionElement:setLabel(labelString)
    if self.labelElement ~ = nil then
        self.labelElement:setText(labelString)
    end
end

```

### setState

**Description**

**Definition**

> setState()

**Arguments**

| any | state      |
|-----|------------|
| any | forceEvent |

**Code**

```lua
function MultiTextOptionElement:setState(state, forceEvent)
    local numTexts = # self.texts
    self.state = math.max( math.min(state, numTexts), 1 )
    self:updateContentElement()

    if forceEvent then
        self:raiseClickCallback( true )
    end

    self:notifyIndexChange( self.state, numTexts)
end

```

### setTexts

**Description**

**Definition**

> setTexts()

**Arguments**

| any | texts |
|-----|-------|

**Code**

```lua
function MultiTextOptionElement:setTexts(texts)
    if texts = = nil then
        self.texts = { }
    else
            self.texts = texts
        end

        self.isImageMode = nil

        self.state = math.min( self.state, # self.texts)
        self:updateContentElement()

        if self.useDynamicInputSteps ~ = false then
            self.dynamicInputStep = math.min( math.floor(# self.texts / 5 ), 10 )
        end

        self:notifyIndexChange( self.state, # self.texts)
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
function MultiTextOptionElement:touchEvent(posX, posY, isDown, isUp, touchId, eventUsed)
    if self:getIsActive() then
        if MultiTextOptionElement:superClass().touchEvent( self , posX, posY, isDown, isUp, touchId, eventUsed or self.wasContinuousTrigger and isUp) or self.wasContinuousTrigger and isUp then
            eventUsed = true
        end

        local isInElement = GuiUtils.checkOverlayOverlap(posX, posY, self.absPosition[ 1 ], self.absPosition[ 2 ], self.absSize[ 1 ], self.absSize[ 2 ], self.hotspot)

        if isInElement and isDown then
            local leftButton = self.leftButtonElement
            self.isLeftButtonPressed = not self.hideLeftRightButtons and GuiUtils.checkOverlayOverlap(posX, posY, leftButton.absPosition[ 1 ], leftButton.absPosition[ 2 ], leftButton.size[ 1 ], leftButton.size[ 2 ], leftButton.hotspot)

            local rightButton = self.rightButtonElement
            self.isRightButtonPressed = not self.hideLeftRightButtons and GuiUtils.checkOverlayOverlap(posX, posY, rightButton.absPosition[ 1 ], rightButton.absPosition[ 2 ], rightButton.size[ 1 ], rightButton.size[ 2 ], rightButton.hotspot)

            self.delayTime = g_ time
        elseif not( self.leftButtonElement ~ = nil and self.leftButtonElement:getIsPressed() or self.rightButtonElement ~ = nil and self.rightButtonElement:getIsPressed()) then
                self.delayTime = math.huge

                self.isLeftButtonPressed = false
                self.isRightButtonPressed = false

                self:releaseInput()
            end

            if not eventUsed and isInElement then
                if not self.inputEntered and not self:getIsFocused() then
                    FocusManager:setHighlight( self )
                    self.inputEntered = true
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

### update

**Description**

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function MultiTextOptionElement:update(dt)
    MultiTextOptionElement:superClass().update( self , dt)

    if self.registerContinuousInput and( self.isLeftButtonPressed or self.isRightButtonPressed) and self.delayTime < = g_ time then
        if self.isLeftButtonPressed then
            self:inputLeft( false )
            self.leftButtonElement:setPressed( true )
        else
                self.leftButtonElement:setPressed( false )
            end

            if self.isRightButtonPressed then
                self:inputRight( false )
                self.rightButtonElement:setPressed( true )
            else
                    self.rightButtonElement:setPressed( false )
                end

                self.wasContinuousTrigger = true
                self.delayTime = g_ time + self.scrollDelayDuration
            end

            if self.registerContinuousInput and self.wasContinuousTrigger then
                self.continuousTriggerTime = self.continuousTriggerTime + dt
            end

            if self.registeredInputEventThisFrame then
                self.registeredInputEventLastFrame = true
                self.registeredInputEventThisFrame = false
            elseif self.registeredInputEventLastFrame then
                    self.registeredInputEventLastFrame = false
                    self.leftButtonElement:setPressed( false )
                    self.rightButtonElement:setPressed( false )

                    self:releaseInput()
                end
            end

```

### updateContentElement

**Description**

**Definition**

> updateContentElement()

**Code**

```lua
function MultiTextOptionElement:updateContentElement()
    local value = self.texts[ self.state]
    local isFilename = false
    if self.isImageMode and value ~ = nil and string.find(value, "." , nil , true ) ~ = nil then
        isFilename = textureFileExists(value)
    end

    local useIcon = false
    if self.iconElement ~ = nil then
        if value ~ = nil then
            if isFilename then
                self.iconElement:setImageFilename(value)
                self.iconElement:setVisible( true )
                for i = 1 , # self.gradientElements do
                    self.gradientElements[i]:setVisible( false )
                end
                useIcon = true
            end
        end

        if not useIcon then
            self.iconElement:setVisible( false )
            for i = 1 , # self.gradientElements do
                self.gradientElements[i]:setVisible( true )
            end
        end
    end

    if self.textElement ~ = nil then
        if not useIcon and value ~ = nil and not isFilename then
            self.textElement:setText(value)
        else
                self.textElement:setText( "" )
            end
        end

        if self.disableButtonsOnSingleText then
            self:setDisabled(# self.texts < = 1 )
        end

        if self.hideButtonOnLimitReached and not self.wrap then
            if self.leftButtonElement ~ = nil then
                self.leftButtonElement:setVisible( self.state ~ = 1 )
            end
            if self.rightButtonElement ~ = nil then
                self.rightButtonElement:setVisible( self.state ~ = # self.texts)
            end
        end
    end

```