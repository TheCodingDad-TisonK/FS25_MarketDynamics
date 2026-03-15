## ContextActionDisplay

**Description**

> Minimum display duration in milliseconds.

**Parent**

> [HUDDisplay](?version=script&category=&class=)

**Functions**

- [draw](#draw)
- [new](#new)
- [resetContext](#resetcontext)
- [setContext](#setcontext)
- [storeScaledValues](#storescaledvalues)
- [update](#update)

### draw

**Description**

> Draw the context action display.

**Definition**

> draw()

**Code**

```lua
function ContextActionDisplay:draw()
    if g_currentMission.hud.ingameMessage:getVisible() then
        return
    end

    local controls = self.controls
    if controls ~ = nil then
        local buttons = controls.buttons
        local keys = controls.keys
        local isComboButtonMapping = controls.isComboButtonMapping
        local width = self.iconOverlay.width + self.iconOffsetX + self.textOffsetX
        local title = self.actionText
        local text = self.text
        local totalButtonWidth = 0
        if #buttons > 0 then
            totalButtonWidth = self.glyphButtonOverlay:getButtonWidth(buttons, isComboButtonMapping, false , self.buttonHeight)
            width = width + totalButtonWidth

        elseif #keys > 0 then
                for i = #keys, 1 , - 1 do
                    local key = keys[i]
                    local keyWidth = self.keyButtonOverlay:getButtonWidth(key, self.buttonHeight)
                    local totalWidth = keyWidth + g_pixelSizeX
                    width = width + totalWidth
                    totalButtonWidth = totalButtonWidth + totalWidth
                end
            end

            setTextWrapWidth( self.textMaxWidth)
            width = width + getTextWidth( self.textSize, text)
            local textHeight = getTextHeight( self.textSize, text)

            local totalHeight = textHeight + self.titleTextOffsetY + self.titleTextSize

            local posX, posY = self:getPosition()

            local currentPosX = posX - width * 0.5

            local buttonPosY = posY + (totalHeight - self.buttonHeight) * 0.5
            if #buttons > 0 then
                self.glyphButtonOverlay:renderButton(buttons, isComboButtonMapping, false , currentPosX, buttonPosY, self.buttonHeight)
            else
                    for i = #keys, 1 , - 1 do
                        local key = keys[i]
                        self.keyButtonOverlay:renderButton(key, currentPosX, buttonPosY, self.buttonHeight, true )
                    end
                end

                currentPosX = currentPosX + totalButtonWidth

                local iconPosY = posY + (totalHeight - self.iconOverlay.height) * 0.5
                self.iconOverlay:setPosition(currentPosX + self.iconOffsetX, iconPosY)
                self.iconOverlay:render()

                currentPosX = self.iconOverlay.x + self.iconOverlay.width

                local activeColor = HUD.COLOR.ACTIVE
                setTextColor(activeColor[ 1 ], activeColor[ 2 ], activeColor[ 3 ], activeColor[ 4 ])
                setTextBold( true )
                setTextAlignment(RenderText.ALIGN_LEFT)

                renderText(currentPosX + self.textOffsetX, posY + textHeight + self.titleTextOffsetY, self.titleTextSize, title)

                setTextColor( 1 , 1 , 1 , 1 )
                setTextBold( false )
                setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BOTTOM)
                renderText(currentPosX + self.textOffsetX, posY + self.textOffsetY, self.textSize, text)
                setTextWrapWidth( 0 )
                setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
            end
        end

```

### new

**Description**

> Create a new ContextActionDisplay.

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
function ContextActionDisplay.new(customMt)
    local self = ContextActionDisplay:superClass().new( ContextActionDisplay _mt)

    self.slicesIds = { }
    self.slicesIds[ ContextActionDisplay.CONTEXT_ICON.ATTACH] = "gui.contextAction_icon_connect"
    self.slicesIds[ ContextActionDisplay.CONTEXT_ICON.FUEL] = "gui.contextAction_icon_fuel"
    self.slicesIds[ ContextActionDisplay.CONTEXT_ICON.TIP] = "gui.contextAction_icon_dump"
    self.slicesIds[ ContextActionDisplay.CONTEXT_ICON.FILL_BOWL] = "gui.contextAction_icon_animalFood"

    self.glyphButtonOverlay = GlyphButtonOverlay.new()
    self.glyphButtonOverlay:setColor( nil , nil , nil , nil , 0 , 0 , 0 , 0.80 )

    self.keyButtonOverlay = ButtonOverlay.new()
    self.keyButtonOverlay:setColor( nil , nil , nil , nil , 0 , 0 , 0 , 0.80 )

    local r, g, b, a = unpack(HUD.COLOR.ACTIVE)
    self.lastSliceId = self.slicesIds[ ContextActionDisplay.CONTEXT_ICON.ATTACH]
    self.iconOverlay = g_overlayManager:createOverlay( self.lastSliceId, 0 , 0 , 0 , 0 )
    self.iconOverlay:setColor(r, g, b, a)

    self.controls = nil
    self.contextPriority = - math.huge
    self.text = nil
    self.displayTime = 0

    return self
end

```

### resetContext

**Description**

> Reset context state after drawing.
> The context must be set a new on each frame.

**Definition**

> resetContext()

**Code**

```lua
function ContextActionDisplay:resetContext()
    self.controls = nil
    self.contextPriority = - math.huge
    self.text = nil
end

```

### setContext

**Description**

> Sets the current action context.
> This must be called each frame when a given context is active. The highest priority context is displayed or the one
> which was set the latest if two or more contexts have the same priority.

**Definition**

> setContext(string contextAction, string contextIconName, string text, integer? priority, string? actionText)

**Arguments**

| string   | contextAction   | Input action name of the context action                                                          |
|----------|-----------------|--------------------------------------------------------------------------------------------------|
| string   | contextIconName | Name of the icon to display for the action context, use one of ContextActionDisplay.CONTEXT_ICON |
| string   | text            | Display text which describes the context action target                                           |
| integer? | priority        | [optional, default=0] Context priority, a higher number has higher priority.                     |
| string?  | actionText      | [optional] Context action description, if different from context action description              |

**Code**

```lua
function ContextActionDisplay:setContext(contextAction, contextIconName, text, priority, actionText)
    if priority = = nil then
        priority = 0
    end

    local newSliceId = self.slicesIds[contextIconName]
    if priority > = self.contextPriority and newSliceId ~ = nil then
        self.contextAction = contextAction
        self.text = utf8ToUpper(text)
        self.actionText = utf8ToUpper(actionText)
        self.contextPriority = priority

        if newSliceId ~ = self.lastSliceId then
            self.iconOverlay:setSliceId(newSliceId)
            self.lastSliceId = newSliceId
        end

        self:updateControls()
        self:setVisible( true )

        self.displayTime = ContextActionDisplay.MIN_DISPLAY_DURATION
    elseif contextAction = = self.contextAction then
            self.displayTime = ContextActionDisplay.MIN_DISPLAY_DURATION
        end
    end

```

### storeScaledValues

**Description**

> Store scaled positioning, size and offset values.

**Definition**

> storeScaledValues()

**Code**

```lua
function ContextActionDisplay:storeScaledValues()
    local offsetX, offsetY = self:scalePixelValuesToScreenVector( 0 , 0 )
    local posX = 0.5 + offsetX
    local posY = g_hudAnchorBottom + offsetY
    self:setPosition(posX, posY)

    local iconWidth, iconHeight = self:scalePixelValuesToScreenVector( 64 , 48 )
    self.iconOverlay:setDimension(iconWidth, iconHeight)
    self.iconOffsetX, self.iconOffsetY = self:scalePixelValuesToScreenVector( 5 , - 4 )

    self.titleTextSize = self:scalePixelToScreenHeight( 15 )
    self.titleTextOffsetY = self:scalePixelToScreenHeight( 5 )

    self.textSize = self:scalePixelToScreenHeight( 26 )
    self.textOffsetX, self.textOffsetY = self:scalePixelValuesToScreenVector( 10 , 1 )
    self.textMaxWidth = self:scalePixelToScreenWidth( 500 )

    self.buttonOffsetY = self:scalePixelToScreenHeight( 8 )
    self.buttonHeight = self:scalePixelToScreenHeight( 25 )
    self.keyButtonOverlay:setMinWidth( self:scalePixelToScreenWidth( 35 ))
    self.glyphButtonOverlay:setMinWidth( self:scalePixelToScreenWidth( 35 ))
end

```

### update

**Description**

> Update the context action display state.

**Definition**

> update()

**Arguments**

| any | dt |
|-----|----|

**Code**

```lua
function ContextActionDisplay:update(dt)
    ContextActionDisplay:superClass().update( self , dt)

    local isVisible = self:getVisible()
    if isVisible then
        self.displayTime = self.displayTime - dt

        if self.displayTime < 0 then
            self:setVisible( false )
            self:resetContext()
        end
    end
end

```