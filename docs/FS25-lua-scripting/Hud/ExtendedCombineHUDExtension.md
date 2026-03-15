## ExtendedCombineHUDExtension

**Description**

> Custom HUD drawing extension for combine data
> Displays the current yield and worked area

**Functions**

- [delete](#delete)
- [draw](#draw)
- [getHeight](#getheight)
- [new](#new)
- [setColorBlindMode](#setcolorblindmode)

### delete

**Description**

> Delete this instance and clean up resources.

**Definition**

> delete()

**Code**

```lua
function ExtendedCombineHUDExtension:delete()
    self.backgroundTop:delete()
    self.backgroundMiddle:delete()
    self.backgroundBottom:delete()

    self.separatorVertical:delete()
    self.yieldPercentageBar:delete()
    self.currentYieldOverlay:delete()
    self.workAreaOverlay:delete()
    self.workAreaOverlayTotal:delete()

    g_messageCenter:unsubscribeAll( self )

    self.vehicle = nil
    self.combine = nil
    self.extendedCombine = nil
end

```

### draw

**Description**

> Draw mixing ratio information for a mixing wagon when it is active.

**Definition**

> draw()

**Arguments**

| any | inputHelpDisplay |
|-----|------------------|
| any | posX             |
| any | posY             |

**Code**

```lua
function ExtendedCombineHUDExtension:draw(inputHelpDisplay, posX, posY)
    if self.extendedCombine = = nil then
        return posY
    end

    local yield = self.extendedCombine.lastYieldWeight
    local yieldPct = self.extendedCombine.lastYieldPercentage
    local yieldPotential = self.extendedCombine.lastYieldPotential
    local yieldRatingPct = (yieldPct - 50 ) / (yieldPotential - 50 )
    local workedHectars = self.combine.workedHectars - self.combine.workedHectarsInitial
    local workedHectarsTotal = self.combine.workedHectars

    local areaUnit = g_i18n:getText( "unit_haShort" )
    local yieldUnit = g_i18n:getText( "unit_tonsShort" ) .. " / " .. areaUnit

    self.backgroundTop:setPosition(posX, posY - self.backgroundTop.height)
    self.backgroundMiddle:setPosition(posX, posY - self.backgroundTop.height - self.backgroundMiddle.height)
    self.backgroundBottom:setPosition(posX, posY - self.backgroundTop.height - self.backgroundMiddle.height - self.backgroundBottom.height)
    self.backgroundTop:render()
    self.backgroundMiddle:render()
    self.backgroundBottom:render()

    setTextAlignment(RenderText.ALIGN_CENTER)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)

    local contentOffset = ( self.displayWidth - self.contentWidth) * 0.5

    posX = posX + contentOffset

    self.currentYieldOverlay:setPosition(posX, posY - self.displayHeight * 0.5 - self.currentYieldOverlay.height * 0.5 )
    self.currentYieldOverlay:render()

    posX = posX + self.iconX + self.spacingX

    setTextBold( true )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.3 , inputHelpDisplay.textSize * 1.25 , string.format( "%.1f" , yield ), self.textWidth)

    setTextBold( false )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.7 , inputHelpDisplay.textSize, yieldUnit, self.textWidth)

    posX = posX + self.textWidth + self.spacingX

    self.separatorVertical:setPosition(posX, posY - self.displayHeight * 0.5 - self.separatorVertical.height * 0.5 )
    self.separatorVertical:render()

    posX = posX + self.spacingX

    setTextBold( true )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.3 , inputHelpDisplay.textSize * 1.25 , string.format( "%d" , yieldPct), self.textWidth)

    setTextBold( false )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.65 , inputHelpDisplay.textSize, "%" , self.textWidth)

    self.yieldPercentageBar:setPosition(posX + self.textWidth * 0.5 - self.yieldPercentageBar.width * 0.5 , posY - self.displayHeight * 0.92 )

    local gradient = ExtendedCombineHUDExtension.GRADIENT[ self.isColorBlindMode]
    local r, g, b = gradient:get(yieldRatingPct)
    self.yieldPercentageBar:setColor(r, g, b, 1 )
    self.yieldPercentageBar:render()

    posX = posX + self.textWidth + self.spacingX

    self.separatorVertical:setPosition(posX, posY - self.displayHeight * 0.5 - self.separatorVertical.height * 0.5 )
    self.separatorVertical:render()

    posX = posX + self.spacingX

    self.workAreaOverlay:setPosition(posX, posY - self.displayHeight * 0.5 - self.workAreaOverlay.height * 0.5 )
    self.workAreaOverlay:render()

    posX = posX + self.iconX + self.spacingX

    setTextBold( true )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.3 , inputHelpDisplay.textSize * 1.25 , string.format( "%.1f" , workedHectars), self.textWidth)

    setTextBold( false )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.7 , inputHelpDisplay.textSize, areaUnit, self.textWidth)

    posX = posX + self.textWidth + self.spacingX

    self.separatorVertical:setPosition(posX, posY - self.displayHeight * 0.5 - self.separatorVertical.height * 0.5 )
    self.separatorVertical:render()

    posX = posX + self.spacingX

    self.workAreaOverlayTotal:setPosition(posX, posY - self.displayHeight * 0.5 - self.workAreaOverlayTotal.height * 0.5 )
    self.workAreaOverlayTotal:render()

    posX = posX + self.iconX + self.spacingX

    setTextBold( true )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.3 , inputHelpDisplay.textSize * 1.25 , string.format( "%.1f" , workedHectarsTotal), self.textWidth)

    setTextBold( false )
    renderLimitedText(posX + self.textWidth * 0.5 , posY - self.displayHeight * 0.7 , inputHelpDisplay.textSize, areaUnit, self.textWidth)

    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
    setTextAlignment(RenderText.ALIGN_LEFT)

    return posY - self.displayHeight
end

```

### getHeight

**Description**

> Get this HUD extension's display height.

**Definition**

> getHeight()

**Return Values**

| any | Display | height in screen space |
|-----|---------|------------------------|

**Code**

```lua
function ExtendedCombineHUDExtension:getHeight()
    return self.displayHeight or 0
end

```

### new

**Description**

> Create a new instance of ExtendedCombineHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function ExtendedCombineHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or ExtendedCombineHUDExtension _mt)

    self.priority = GS_PRIO_LOW

    self.vehicle = vehicle
    self.combine = vehicle.spec_combine
    self.extendedCombine = vehicle[ ExtendedCombine.SPEC_TABLE_NAME]

    self.backgroundTop = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_top" , 0 , 0 , 0 , 0 )
    self.backgroundMiddle = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_middle" , 0 , 0 , 0 , 0 )
    self.backgroundBottom = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_bottom" , 0 , 0 , 0 , 0 )

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.backgroundTop:setColor(r, g, b, a)
    self.backgroundMiddle:setColor(r, g, b, a)
    self.backgroundBottom:setColor(r, g, b, a)

    self.separatorVertical = g_overlayManager:createOverlay(g_plainColorSliceId, 0 , 0 , 0 , 0 )
    self.separatorVertical:setColor( 1 , 1 , 1 , 0.25 )

    self.yieldPercentageBar = g_overlayManager:createOverlay(g_plainColorSliceId, 0 , 0 , 0 , 0 )
    self.yieldPercentageBar:setColor( 1 , 1 , 1 , 1 )

    self.currentYieldOverlay = g_overlayManager:createOverlay( "precisionFarming.currentYield" , 0 , 0 , 0 , 0 )
    self.currentYieldOverlay:setColor( 1 , 1 , 1 , 1 )

    self.workAreaOverlay = g_overlayManager:createOverlay( "precisionFarming.workedArea" , 0 , 0 , 0 , 0 )
    self.workAreaOverlay:setColor( 1 , 1 , 1 , 1 )

    self.workAreaOverlayTotal = g_overlayManager:createOverlay( "precisionFarming.workedAreaTotal" , 0 , 0 , 0 , 0 )
    self.workAreaOverlayTotal:setColor( 1 , 1 , 1 , 1 )

    self.isColorBlindMode = g_gameSettings:getValue(GameSettings.SETTING.USE_COLORBLIND_MODE) or false

    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.USE_COLORBLIND_MODE], self.setColorBlindMode, self )
    g_messageCenter:subscribe(MessageType.SETTING_CHANGED[GameSettings.SETTING.UI_SCALE], self.storeScaledValues, self )

    self:storeScaledValues()

    return self
end

```

### setColorBlindMode

**Description**

> Determine if the HUD extension should be drawn.

**Definition**

> setColorBlindMode()

**Arguments**

| any | isActive |
|-----|----------|

**Code**

```lua
function ExtendedCombineHUDExtension:setColorBlindMode(isActive)
    if isActive ~ = self.isColorBlindMode then
        self.isColorBlindMode = isActive
    end
end

```