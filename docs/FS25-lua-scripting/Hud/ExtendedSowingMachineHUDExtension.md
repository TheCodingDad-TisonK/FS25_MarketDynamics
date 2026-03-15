## ExtendedSowingMachineHUDExtension

**Description**

> Custom HUD drawing extension for precision farming sowing machines
> Displays the current seed rate

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
function ExtendedSowingMachineHUDExtension:delete()
    for _, dotData in ipairs( self.dots) do
        dotData.dotEmpty:delete()
        dotData.dotFilled:delete()
        dotData.dotFill:delete()
    end

    self.backgroundTop:delete()
    self.backgroundMiddle:delete()
    self.backgroundBottom:delete()

    self.separatorHorizontal:delete()
    self.seedsOverlay:delete()
    self.recommendOverlay:delete()

    g_messageCenter:unsubscribeAll( self )

    self.vehicle = nil
    self.extendedSowingMachine = nil
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
function ExtendedSowingMachineHUDExtension:draw(inputHelpDisplay, posX, posY)
    if self.extendedSowingMachine = = nil then
        return posY
    end

    self.backgroundTop:setPosition(posX, posY - self.backgroundTop.height)
    self.backgroundMiddle:setPosition(posX, posY - self.backgroundTop.height - self.backgroundMiddle.height)
    self.backgroundBottom:setPosition(posX, posY - self.backgroundTop.height - self.backgroundMiddle.height - self.backgroundBottom.height)
    self.backgroundTop:render()
    self.backgroundMiddle:render()
    self.backgroundBottom:render()

    posY = posY - self.seedRateHeight

    local contentOffset = ( self.displayWidth - self.contentWidth) * 0.5

    setTextColor( 1 , 1 , 1 , 1 )
    setTextBold( true )
    setTextAlignment(RenderText.ALIGN_LEFT)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
    renderLimitedText(posX + contentOffset, posY + self.seedRateHeight * 0.55 + self.textOffsetHeadline, self.textHeightHeadline, self.texts.headline, self.textMaxWidthHeadline)
    setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
    setTextBold( false )

    local spec = self.extendedSowingMachine
    local seedsFruitType = self.vehicle.spec_sowingMachine.workAreaParameters.seedsFruitType
    local lastSeedRate = spec.lastSeedRate
    local lastSeedRateIndex = spec.lastSeedRateIndex

    if not spec.seedRateAutoMode then
        lastSeedRateIndex = spec.manualSeedRate
        lastSeedRate = self.seedRateMap:getSeedRateByFruitTypeAndIndex(seedsFruitType, lastSeedRateIndex)
    end

    local isSupported = self.seedRateMap:getIsFruitTypeSupported(seedsFruitType)
    if isSupported then
        setTextAlignment(RenderText.ALIGN_CENTER)
        local currentRatePosX = posX + self.rateTextOffsetX
        local currentRatePosY = posY + self.seedRateHeight * 0.5 - self.rateTextHeight * 0.5 + self.rateTextOffsetY
        renderLimitedText(currentRatePosX, currentRatePosY, self.rateTextHeight, string.format( self.texts.seedRate, lastSeedRate))

        for i = 1 , # self.dots do
            local dotData = self.dots[i]

            local dotPosX = currentRatePosX + (i / 2 - 1 ) * self.dotsFullWidth - dotData.dotEmpty.width * 0.5
            local dotPosY = currentRatePosY - dotData.dotEmpty.height * 1.5

            if i > lastSeedRateIndex then
                dotData.dotEmpty:setPosition(dotPosX, dotPosY)
                dotData.dotEmpty:render()
            else
                    dotData.dotFilled:setPosition(dotPosX, dotPosY)
                    dotData.dotFill:setPosition(dotPosX, dotPosY)

                    dotData.dotFilled:render()

                    local displayValues = self.seedRateMap:getDisplayValues()
                    local displayValue = displayValues[lastSeedRateIndex]
                    local color = displayValue.colors[ self.isColorBlindMode][ 1 ]

                    dotData.dotFill:setColor(color[ 1 ], color[ 2 ], color[ 3 ], 1 )
                    dotData.dotFill:render()
                end

                if not spec.seedRateAutoMode and spec.seedRateRecommendation ~ = nil then
                    if i < = spec.seedRateRecommendation then
                        self.recommendOverlay:setPosition(dotPosX + dotData.dotEmpty.width * 0.5 - self.recommendOverlay.width * 0.5 , dotPosY - self.recommendOverlay.height + self.recommendOverlayOffsetY)
                        self.recommendOverlay:render()
                    end
                end
            end

            if spec.seedRateAutoMode then
                setTextAlignment(RenderText.ALIGN_CENTER)
                setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
                renderLimitedText(posX + self.modeTextOffsetX, posY + self.seedRateHeight * 0.52 , self.modeTextHeight, self.texts.auto)
            end
        else
                setTextAlignment(RenderText.ALIGN_CENTER)
                setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
                renderLimitedText(posX + contentOffset + self.naTextOffsetX, posY + self.seedRateHeight * 0.52 , self.naTextHeight, self.texts.notAvailable, self.naTextMaxX)
            end

            local uvIndex = lastSeedRateIndex
            if uvIndex = = 0 or not isSupported then
                uvIndex = 2
            end
            self.seedsOverlay:setSliceId( ExtendedSowingMachineHUDExtension.SEED_RATE_SLICES[ math.max( math.min(uvIndex, 3 ), 1 )])

            self.seedsOverlay:setPosition(posX + self.backgroundTop.width - self.seedsOverlay.width - contentOffset * 0.5 , posY + self.seedRateHeight * 0.5 - self.seedsOverlay.height * 0.5 )
            self.seedsOverlay:render()

            posY = posY - self.tramlineHeight

            self.separatorHorizontal:renderCustom(posX, posY + self.tramlineHeight)

            local textSize = inputHelpDisplay.textSize

            local tramlineText
            if spec.tramlineWidth ~ = nil then
                tramlineText = string.format( self.texts.tramlineWidth, spec.tramlineWidth)
            else
                    tramlineText = self.texts.tramlineNotAvailable
                end
                tramlineText = utf8ToUpper(tramlineText)

                setTextAlignment(RenderText.ALIGN_LEFT)

                setTextBold( true )
                setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
                renderLimitedText(posX + contentOffset, posY + self.tramlineHeight * 0.6 , textSize, tramlineText)
                setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
                setTextBold( false )

                return posY
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
function ExtendedSowingMachineHUDExtension:getHeight()
    return self.displayHeight or 0
end

```

### new

**Description**

> Create a new instance of ExtendedSowingMachineHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function ExtendedSowingMachineHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or ExtendedSowingMachineHUDExtension _mt)

    self.priority = GS_PRIO_NORMAL

    self.vehicle = vehicle
    self.extendedSowingMachine = vehicle[ ExtendedSowingMachine.SPEC_TABLE_NAME]

    self.backgroundTop = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_top" , 0 , 0 , 0 , 0 )
    self.backgroundMiddle = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_middle" , 0 , 0 , 0 , 0 )
    self.backgroundBottom = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_bottom" , 0 , 0 , 0 , 0 )

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.backgroundTop:setColor(r, g, b, a)
    self.backgroundMiddle:setColor(r, g, b, a)
    self.backgroundBottom:setColor(r, g, b, a)

    self.separatorHorizontal = g_overlayManager:createOverlay(g_plainColorSliceId, 0 , 0 , 0 , 0 )
    self.separatorHorizontal:setColor( 1 , 1 , 1 , 0.25 )

    self.dots = { }
    for i = 1 , 3 do
        local dotData = { }
        dotData.dotEmpty = g_overlayManager:createOverlay( "precisionFarming.seeds_dot_empty" , 0 , 0 , 0 , 0 )
        dotData.dotFilled = g_overlayManager:createOverlay( "precisionFarming.seeds_dot_filled" , 0 , 0 , 0 , 0 )
        dotData.dotFill = g_overlayManager:createOverlay( "precisionFarming.seeds_dot_fill" , 0 , 0 , 0 , 0 )

        table.insert( self.dots, dotData)
    end

    self.seedsOverlay = g_overlayManager:createOverlay( ExtendedSowingMachineHUDExtension.SEED_RATE_SLICES[ 1 ], 0 , 0 , 0 , 0 )

    self.recommendOverlay = g_overlayManager:createOverlay( "precisionFarming.seeds_recommendationBar" , 0 , 0 , 0 , 0 )
    self.recommendOverlay:setColor( 0.5 , 0.5 , 0.5 , 1 )

    self.texts = { }
    self.texts.headline = g_i18n:getText( "hudExtensionSowingMachine_headline" , ExtendedSowingMachineHUDExtension.MOD_NAME)
    self.texts.seedRate = g_i18n:getText( "hudExtensionSowingMachine_seedRate" , ExtendedSowingMachineHUDExtension.MOD_NAME)
    self.texts.auto = g_i18n:getText( "hudExtensionSowingMachine_auto" , ExtendedSowingMachineHUDExtension.MOD_NAME)
    self.texts.notAvailable = g_i18n:getText( "hudExtensionSowingMachine_notAvailable" , ExtendedSowingMachineHUDExtension.MOD_NAME)
    self.texts.tramlineWidth = g_i18n:getText( "hudExtensionSowingMachine_tramlineWidth" , ExtendedSowingMachineHUDExtension.MOD_NAME)
    self.texts.tramlineNotAvailable = g_i18n:getText( "hudExtensionSowingMachine_tramlineNotAvailable" , ExtendedSowingMachineHUDExtension.MOD_NAME)

    self.seedRateMap = g_precisionFarming.seedRateMap

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
function ExtendedSowingMachineHUDExtension:setColorBlindMode(isActive)
    if isActive ~ = self.isColorBlindMode then
        self.isColorBlindMode = isActive
    end
end

```