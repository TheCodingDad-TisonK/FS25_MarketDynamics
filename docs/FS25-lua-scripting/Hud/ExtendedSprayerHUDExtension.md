## ExtendedSprayerHUDExtension

**Description**

> Custom HUD drawing extension for precision farming sprayers
> Displays the pH / Nitrogen actual and target values

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
function ExtendedSprayerHUDExtension:delete()
    self.backgroundTop:delete()
    self.backgroundMiddle:delete()
    self.backgroundBottom:delete()

    self.gradient:delete()
    self.gradientInactive:delete()
    self.actualBar:delete()
    self.targetBar:delete()
    self.targetFlag:delete()
    self.setValueBar:delete()
    self.footerSeparationBar:delete()

    g_messageCenter:unsubscribeAll( self )

    self.vehicle = nil
    self.extendedSprayer = nil
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
function ExtendedSprayerHUDExtension:draw(inputHelpDisplay, posX, posY)
    local vehicle = self.vehicle
    local spec = self.extendedSprayer

    if spec = = nil then
        return posY
    end

    local headline = self.texts.headline_ph_lime

    local applicationRate = 0
    local applicationRateReal = 0
    local applicationRateStr = "%.2f t/ha"

    local changeBarText = ""

    local minValue = 0
    local maxValue = 0

    self.hasValidValues = false

    local soilTypeName = ""

    if spec.lastTouchedSoilType ~ = 0 and self.soilMap ~ = nil then
        local soilType = self.soilMap:getSoilTypeByIndex(spec.lastTouchedSoilType)
        if soilType ~ = nil then
            soilTypeName = soilType.name
        end
    end

    local hasLimeLoaded = false
    local fillTypeDesc
    local sourceVehicle, fillUnitIndex = ExtendedSprayer.getFillTypeSourceVehicle(vehicle)
    local sprayFillType = sourceVehicle:getFillUnitFillType(fillUnitIndex)
    fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(sprayFillType)
    local massPerLiter = (fillTypeDesc.massPerLiter / FillTypeManager.MASS_SCALE)
    if sprayFillType = = FillType.LIME then
        hasLimeLoaded = true
    end

    local descriptionText = ""
    local stepResolution

    local enableZeroTargetFlag = false

    if hasLimeLoaded then
        self.gradient:setSliceId( self.isColorBlindMode and ExtendedSprayerHUDExtension.SLICES.COLOR_BLIND_GRADIENT or ExtendedSprayerHUDExtension.SLICES.PH_GRADIENT)
        self.gradientInactive:setSliceId( self.isColorBlindMode and ExtendedSprayerHUDExtension.SLICES.COLOR_BLIND_GRADIENT or ExtendedSprayerHUDExtension.SLICES.PH_GRADIENT)

        local pHChanged = 0
        applicationRate = spec.lastLitersPerHectar * massPerLiter
        if not spec.sprayAmountAutoMode then
            local requiredLitersPerHa = self.pHMap:getLimeUsageByStateChange(spec.sprayAmountManual)
            pHChanged = self.pHMap:getPhValueFromChangedStates(spec.sprayAmountManual)
            applicationRate = requiredLitersPerHa * massPerLiter

            if pHChanged > 0 then
                changeBarText = string.format( "pH +%s" , formatDecimalNumber(pHChanged))
            end
        end

        if spec.phActualValue ~ = 0 and spec.phTargetValue ~ = 0 and self.vehicle.isOnField then
            local pHActual = self.pHMap:getPhValueFromInternalValue(spec.phActualValue)
            local pHTarget = self.pHMap:getPhValueFromInternalValue(spec.phTargetValue)

            self.actualValue = pHActual
            self.setValue = pHActual + pHChanged
            self.targetValue = pHTarget

            if spec.sprayAmountAutoMode then
                pHChanged = self.targetValue - self.actualValue
                if pHChanged > 0 then
                    changeBarText = string.format( "pH +%s" , formatDecimalNumber(pHChanged))
                end

                self.setValue = self.targetValue
            end

            self.actualValueStr = "pH %.3f"
            if soilTypeName ~ = "" then
                if spec.sprayAmountAutoMode then
                    descriptionText = string.format( self.texts.description_limeAuto, soilTypeName, formatDecimalNumber(pHTarget))
                else
                        descriptionText = string.format( self.texts.description_limeManual, soilTypeName, formatDecimalNumber(pHTarget))
                    end
                end

                self.hasValidValues = true
            end

            if self.pHMap ~ = nil then
                minValue, maxValue = self.pHMap:getMinMaxValue()
            end

            stepResolution = spec.pHMap:getPhValueFromChangedStates( 1 )
        else
                self.gradient:setSliceId( self.isColorBlindMode and ExtendedSprayerHUDExtension.SLICES.COLOR_BLIND_GRADIENT or ExtendedSprayerHUDExtension.SLICES.N_GRADIENT)
                self.gradientInactive:setSliceId( self.isColorBlindMode and ExtendedSprayerHUDExtension.SLICES.COLOR_BLIND_GRADIENT or ExtendedSprayerHUDExtension.SLICES.N_GRADIENT)

                local litersPerHectar = spec.lastLitersPerHectar
                local nitrogenChanged = 0
                if not spec.sprayAmountAutoMode then
                    litersPerHectar = self.nitrogenMap:getFertilizerUsageByStateChange(spec.sprayAmountManual, sprayFillType)
                    nitrogenChanged = self.nitrogenMap:getNitrogenFromChangedStates(spec.sprayAmountManual)

                    if nitrogenChanged > 0 then
                        changeBarText = string.format( "+%dkg N/ha" , nitrogenChanged)
                    end
                end

                if spec.isSolidFertilizerSprayer then
                    headline = self.texts.headline_n_solidFertilizer
                    applicationRateStr = "%d kg/ha"
                    applicationRate = litersPerHectar * massPerLiter * 1000
                elseif spec.isLiquidFertilizerSprayer then
                        headline = self.texts.headline_n_liquidFertilizer
                        applicationRateStr = "%d l/ha"
                        applicationRate = litersPerHectar
                    elseif spec.isSlurryTanker then
                            headline = self.texts.headline_n_slurryTanker
                            applicationRateStr = "%.1f m³/ha"
                            applicationRate = litersPerHectar / 1000

                            if spec.sprayAmountAutoMode and soilTypeName ~ = "" then
                                descriptionText = string.format( self.texts.description_slurryAuto, soilTypeName)
                            end
                        elseif spec.isManureSpreader then
                                headline = self.texts.headline_n_manureSpreader
                                applicationRateStr = "%.1f t/ha"
                                applicationRate = litersPerHectar * massPerLiter

                                if spec.sprayAmountAutoMode and soilTypeName ~ = "" then
                                    descriptionText = string.format( self.texts.description_manureAuto, soilTypeName)
                                end
                            end

                            if spec.nActualValue > 0 and spec.nTargetValue > 0 and self.vehicle.isOnField and not spec.isDoingMissionWork then
                                local nActual = self.nitrogenMap:getNitrogenValueFromInternalValue( math.clamp(spec.nActualValue, 0 , self.nitrogenMap.maxValue))
                                local nTarget = self.nitrogenMap:getNitrogenValueFromInternalValue( math.clamp(spec.nTargetValue, 0 , self.nitrogenMap.maxValue))

                                self.actualValue = nActual
                                self.setValue = nActual + nitrogenChanged
                                self.targetValue = nTarget

                                if spec.sprayAmountAutoMode then
                                    nitrogenChanged = self.targetValue - self.actualValue
                                    if nitrogenChanged > 0 then
                                        changeBarText = string.format( "+%dkg N/ha" , nitrogenChanged)
                                    end

                                    self.setValue = self.targetValue
                                end

                                self.actualValueStr = "%dkg N/ha"

                                local forcedFruitType
                                if vehicle.spec_sowingMachine ~ = nil then
                                    forcedFruitType = vehicle.spec_sowingMachine.workAreaParameters.seedsFruitType
                                end

                                local fruitTypeIndex = forcedFruitType or spec.nApplyAutoModeFruitType
                                if fruitTypeIndex ~ = nil then
                                    local fillType = g_fillTypeManager:getFillTypeByIndex(g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex))
                                    if fillType ~ = nil then
                                        if fillType ~ = FillType.UNKNOWN and soilTypeName ~ = "" then
                                            if nTarget > 0 then
                                                if spec.sprayAmountAutoMode then
                                                    descriptionText = string.format( self.texts.description_fertilizerAutoFruit, fillType.title, soilTypeName)
                                                else
                                                        descriptionText = string.format( self.texts.description_fertilizerManualFruit, fillType.title, soilTypeName)
                                                    end
                                                else
                                                        descriptionText = self.texts.description_noFertilizerRequired
                                                        enableZeroTargetFlag = true
                                                    end
                                                end
                                            end
                                        end

                                        if descriptionText = = "" and soilTypeName ~ = "" then
                                            if spec.sprayAmountAutoMode then
                                                descriptionText = string.format( self.texts.description_fertilizerAutoNoFruit, soilTypeName)

                                                if self.nitrogenMap ~ = nil then
                                                    local fruitTypeIndex = self.nitrogenMap:getFruitTypeIndexByFruitRequirementIndex(spec.nApplyAutoModeFruitRequirementDefaultIndex)
                                                    if fruitTypeIndex ~ = nil then
                                                        local fillType = g_fillTypeManager:getFillTypeByIndex(g_fruitTypeManager:getFillTypeIndexByFruitTypeIndex(fruitTypeIndex))
                                                        if fillType ~ = nil then
                                                            descriptionText = string.format( self.texts.description_fertilizerAutoNoFruitDefault, fillType.title, soilTypeName)
                                                        end
                                                    end
                                                end
                                            else
                                                    descriptionText = string.format( self.texts.description_fertilizerManualNoFruit, soilTypeName)
                                                end
                                            end

                                            self.hasValidValues = true
                                        end

                                        if self.nitrogenMap ~ = nil then
                                            minValue, maxValue = self.nitrogenMap:getMinMaxValue()

                                            local nAmount = spec.lastNitrogenProportion
                                            if nAmount = = 0 then
                                                nAmount = self.nitrogenMap:getNitrogenAmountFromFillType(sprayFillType)
                                            end

                                            if spec.isSlurryTanker then
                                                local str = " (~%skgN/m³)"
                                                if sourceVehicle.getIsUsingExactNitrogenAmount ~ = nil and sourceVehicle:getIsUsingExactNitrogenAmount() then
                                                    str = " (%skgN/m³)"
                                                end

                                                applicationRateStr = applicationRateStr .. string.format(str, MathUtil.round(nAmount * 1000 , 1 ))
                                            else
                                                    applicationRateStr = applicationRateStr .. string.format( " (%s%%%%N)" , MathUtil.round(nAmount * 100 , 1 ))
                                                end

                                                stepResolution = self.nitrogenMap:getNitrogenFromChangedStates( 1 )
                                            end
                                        end

                                        if spec.sprayAmountAutoMode then
                                            applicationRateStr = applicationRateStr .. string.format( " (%s)" , self.texts.automaticShort)
                                            soilTypeName = ""
                                        end

                                        self.actualPos = math.min(( self.actualValue - minValue) / (maxValue - minValue), 1 )
                                        self.setValuePos = math.min(( self.setValue - minValue) / (maxValue - minValue), 1 )
                                        self.targetPos = math.min(( self.targetValue - minValue) / (maxValue - minValue), 1 )

                                        local totalHeight = self:getHeight()
                                        local middleHeight = totalHeight - self.backgroundTop.height - self.backgroundBottom.height

                                        self.backgroundTop:setPosition(posX, posY - self.backgroundTop.height)
                                        self.backgroundMiddle:setPosition(posX, posY - self.backgroundTop.height - middleHeight)
                                        self.backgroundBottom:setPosition(posX, posY - self.backgroundTop.height - middleHeight - self.backgroundBottom.height)
                                        self.backgroundMiddle:setDimension( nil , middleHeight)
                                        self.backgroundTop:render()
                                        self.backgroundMiddle:render()
                                        self.backgroundBottom:render()

                                        local centerX = posX + self.backgroundTop.width * 0.5

                                        setTextColor( 1 , 1 , 1 , 1 )
                                        setTextBold( true )
                                        setTextAlignment(RenderText.ALIGN_CENTER)
                                        renderLimitedText(centerX, posY - self.textHeightHeadline * 1.1 , self.textHeightHeadline, headline, self.contentMaxWidth)
                                        setTextBold( false )

                                        -- gradient
                                        local gradientPosX = centerX - self.gradientInactive.width * 0.5 + self.gradientPosX
                                        local gradientPosY = posY + self.gradientPosY
                                        if not self.hasValidValues then
                                            gradientPosY = gradientPosY + ( self.actualBar.height - self.gradientInactive.height) + self.textHeight
                                        end

                                        self.gradientInactive:setPosition(gradientPosX, gradientPosY)
                                        self.gradientInactive:render()

                                        local gradientVisibilePos = 0
                                        if self.hasValidValues then
                                            gradientVisibilePos = self.actualPos
                                        end

                                        self.gradient:setPosition(gradientPosX, gradientPosY)
                                        self.gradient:setDimension(gradientVisibilePos * self.gradientInactive.width)

                                        local uvs = self.gradient.uvs
                                        local uv5 = uvs[ 1 ] + (uvs[ 5 ] - uvs[ 1 ]) * gradientVisibilePos
                                        local uv7 = uvs[ 3 ] + (uvs[ 7 ] - uvs[ 3 ]) * gradientVisibilePos
                                        setOverlayUVs( self.gradient.overlayId, uvs[ 1 ], uvs[ 2 ], uvs[ 3 ], uvs[ 4 ], uv5, uvs[ 6 ], uv7, uvs[ 8 ])
                                        self.gradient:render()

                                        local labelMin
                                        local labelMax
                                        if hasLimeLoaded then
                                            labelMin = string.format( "pH\n%s" , minValue)
                                            labelMax = string.format( "pH\n%s" , maxValue)
                                        else
                                                labelMin = string.format( "%s\nkg/ha" , minValue)
                                                labelMax = string.format( "%s\nkg/ha" , maxValue)
                                            end

                                            local widthDiff = ( self.backgroundTop.width - self.gradientInactive.width) * 0.25
                                            renderLimitedText(posX + widthDiff, gradientPosY + self.gradientInactive.height * 0.85 , self.gradientInactive.height * 1.3 , labelMin)
                                            renderLimitedText(posX + self.backgroundTop.width - widthDiff, gradientPosY + self.gradientInactive.height * 0.85 , self.gradientInactive.height * 1.3 , labelMax)

                                            local additionalChangeLineHeight = 0

                                            -- actual
                                            local changeBarRendered = false
                                            if self.hasValidValues then
                                                -- target
                                                local targetBarX, targetBarY
                                                local showFlag = self.targetPos ~ = 0 or enableZeroTargetFlag
                                                if showFlag then
                                                    targetBarX = gradientPosX + self.gradientInactive.width * self.targetPos - self.targetBar.width * 0.5
                                                    targetBarY = gradientPosY
                                                    self.targetBar:setPosition(targetBarX, targetBarY)
                                                    self.targetBar:render()

                                                    self.targetFlag:setPosition(targetBarX, targetBarY + self.targetBar.height)
                                                    self.targetFlag:render()
                                                end

                                                local actualBarText
                                                local actualBarTextOffset = self.actualBar.height + self.textHeight * 1.1
                                                local actualBarSkipFlagCollisionCheck = false
                                                if self.actualPos ~ = self.targetPos then
                                                    actualBarText = string.format( self.texts.actualValue, string.format( self.actualValueStr, self.actualValue))
                                                elseif spec.sprayAmountAutoMode or self.targetPos = = self.setValuePos then
                                                        if self.targetPos ~ = 0 then
                                                            actualBarText = string.format( self.texts.targetReached, string.format( self.actualValueStr, self.actualValue))
                                                            actualBarTextOffset = - self.textHeight * 0.7
                                                            actualBarSkipFlagCollisionCheck = true
                                                            changeBarRendered = true
                                                        end
                                                    end

                                                    if actualBarText ~ = nil then
                                                        local actualBarX = gradientPosX + self.gradientInactive.width * self.actualPos - self.actualBar.width * 0.5
                                                        local actualBarY = gradientPosY + ( self.gradientInactive.height - self.actualBar.height) * 0.5

                                                        self.actualBar:setPosition(actualBarX, actualBarY)
                                                        self.actualBar:render()

                                                        local actualTextWidth = getTextWidth( self.textHeight * 0.7 , actualBarText)
                                                        actualBarX = math.max( math.min(actualBarX, (posX + self.backgroundTop.width) - actualTextWidth * 0.5 ), posX + actualTextWidth * 0.5 )

                                                        if not actualBarSkipFlagCollisionCheck and showFlag then
                                                            local rightTextBorder = actualBarX + actualTextWidth * 0.5
                                                            if rightTextBorder > targetBarX and rightTextBorder < targetBarX + self.targetFlag.width * 0.5 then
                                                                actualBarX = targetBarX - actualTextWidth * 0.5 - self.pixelSizeX
                                                            end

                                                            local leftTextBorder = actualBarX - actualTextWidth * 0.5
                                                            if (leftTextBorder > targetBarX and leftTextBorder < targetBarX + self.targetFlag.width * 0.5 )
                                                                or(targetBarX > leftTextBorder and targetBarX < rightTextBorder) then
                                                                actualBarX = targetBarX + self.targetFlag.width + self.pixelSizeX + actualTextWidth * 0.5
                                                            end
                                                        end

                                                        renderLimitedText(actualBarX, actualBarY + actualBarTextOffset, self.textHeight * 0.7 , actualBarText)
                                                    end

                                                    if self.setValuePos > self.actualPos then
                                                        local goodColor = ExtendedSprayerHUDExtension.COLOR.SET_VALUE_BAR_GOOD
                                                        local badColor = ExtendedSprayerHUDExtension.COLOR.SET_VALUE_BAR_BAD
                                                        local difference = math.min(( math.abs( self.setValue - self.targetValue) / stepResolution) / 3 , 1 )
                                                        local differenceInv = 1 - difference
                                                        local r, g, b, a = difference * badColor[ 1 ] + differenceInv * goodColor[ 1 ],
                                                        difference * badColor[ 2 ] + differenceInv * goodColor[ 2 ],
                                                        difference * badColor[ 3 ] + differenceInv * goodColor[ 3 ],
                                                        1
                                                        local setValueBarX = gradientPosX + self.gradientInactive.width * self.actualPos
                                                        local setValueBarY = gradientPosY - self.gradientInactive.height - self.setValueBar.height
                                                        self.setValueBar:setPosition(setValueBarX, setValueBarY)
                                                        self.setValueBar:setDimension( self.gradientInactive.width * ( math.min( self.setValuePos, 1 ) - self.actualPos))
                                                        self.setValueBar:setColor(r, g, b, a)
                                                        self.setValueBar:render()

                                                        local setBarTextX = setValueBarX + self.setValueBar.width * 0.5
                                                        local setBarTextY = setValueBarY + self.setValueBar.height * 0.2
                                                        local setTextWidth = getTextWidth( self.setValueBar.height * 0.9 , changeBarText)
                                                        if setTextWidth > self.setValueBar.width * 0.95 then
                                                            setBarTextY = setValueBarY - self.setValueBar.height
                                                            additionalChangeLineHeight = self.setValueBar.height
                                                        end
                                                        renderLimitedText(setBarTextX, setBarTextY, self.setValueBar.height * 0.9 , changeBarText)

                                                        changeBarRendered = true
                                                    end
                                                else
                                                        descriptionText = self.texts.invalidValues
                                                    end

                                                    local bottomPosY = posY - self:getHeight()

                                                    if descriptionText ~ = "" and self.additionalDisplayHeight ~ = 0 then
                                                        setTextAlignment(RenderText.ALIGN_CENTER)
                                                        renderLimitedText(centerX, bottomPosY + self.footerOffset + self.textHeight * 1.85 , self.textHeight, descriptionText, self.contentMaxWidth)
                                                    end

                                                    self.footerSeparationBar:setPosition(centerX - self.footerSeparationBar.width * 0.5 , bottomPosY + self.footerOffset + self.textHeight * 1.3 )
                                                    self.footerSeparationBar:render()

                                                    -- footer
                                                    setTextAlignment(RenderText.ALIGN_LEFT)
                                                    local sideOffset = ( self.backgroundTop.width - self.contentMaxWidth) * 0.5
                                                    local rateText = self.texts.applicationRate .. " " .. string.format(applicationRateStr, applicationRate, applicationRateReal)
                                                    local rateWidth = renderLimitedText(posX + sideOffset, bottomPosY + self.footerOffset, self.textHeight, rateText, self.contentMaxWidth)

                                                    if soilTypeName ~ = "" then
                                                        local maxWidth = self.contentMaxWidth - rateWidth - self.footerTextSpacing
                                                        setTextAlignment(RenderText.ALIGN_RIGHT)
                                                        renderLimitedText(posX + self.backgroundTop.width - sideOffset, bottomPosY + self.footerOffset, self.textHeight, string.format( self.texts.soilType, soilTypeName), maxWidth)
                                                    end

                                                    -- do that at the end so we give the ui some time to increase the window height and then render the text above
                                                    self.additionalDisplayHeight = additionalChangeLineHeight
                                                    if descriptionText ~ = "" then
                                                        self.additionalDisplayHeight = self.additionalDisplayHeight + self.additionalTextHeightOffset
                                                    end
                                                    if not self.hasValidValues then
                                                        self.additionalDisplayHeight = self.additionalDisplayHeight - self.invalidHeightOffset
                                                    elseif not changeBarRendered then
                                                            self.additionalDisplayHeight = self.additionalDisplayHeight - self.noSetBarHeightOffset
                                                        end

                                                        return bottomPosY
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
function ExtendedSprayerHUDExtension:getHeight()
    return( self.displayHeight or 0 ) + ( self.additionalDisplayHeight or 0 )
end

```

### new

**Description**

> Create a new instance of ExtendedSprayerHUDExtension.

**Definition**

> new(table vehicle, )

**Arguments**

| table | vehicle  | Vehicle which has the specialization required by a sub-class |
|-------|----------|--------------------------------------------------------------|
| any   | customMt |                                                              |

**Code**

```lua
function ExtendedSprayerHUDExtension.new(vehicle, customMt)
    local self = setmetatable( { } , customMt or ExtendedSprayerHUDExtension _mt)

    self.priority = GS_PRIO_LOW

    self.vehicle = vehicle
    self.extendedSprayer = vehicle[ ExtendedSprayer.SPEC_TABLE_NAME]

    self.backgroundTop = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_top" , 0 , 0 , 0 , 0 )
    self.backgroundMiddle = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_middle" , 0 , 0 , 0 , 0 )
    self.backgroundBottom = g_overlayManager:createOverlay( "precisionFarming.shortcutBox_bottom" , 0 , 0 , 0 , 0 )

    local r, g, b, a = unpack(HUD.COLOR.BACKGROUND)
    self.backgroundTop:setColor(r, g, b, a)
    self.backgroundMiddle:setColor(r, g, b, a)
    self.backgroundBottom:setColor(r, g, b, a)

    self.gradient = g_overlayManager:createOverlay( ExtendedSprayerHUDExtension.SLICES.PH_GRADIENT, 0 , 0 , 0 , 0 )

    self.gradientInactive = g_overlayManager:createOverlay( ExtendedSprayerHUDExtension.SLICES.PH_GRADIENT, 0 , 0 , 0 , 0 )
    self.gradientInactive:setColor( 0.4 , 0.4 , 0.4 , 1 )

    self.actualBar = g_overlayManager:createOverlay( "precisionFarming.filled" , 0 , 0 , 0 , 0 )
    self.actualBar:setColor( unpack( ExtendedSprayerHUDExtension.COLOR.ACTUAL_BAR))

    self.targetBar = g_overlayManager:createOverlay( "precisionFarming.target_bar" , 0 , 0 , 0 , 0 )

    self.targetFlag = g_overlayManager:createOverlay( "precisionFarming.target_flag" , 0 , 0 , 0 , 0 )

    self.setValueBar = g_overlayManager:createOverlay( "precisionFarming.filled" , 0 , 0 , 0 , 0 )
    self.setValueBar:setColor( unpack( ExtendedSprayerHUDExtension.COLOR.SET_VALUE_BAR_GOOD))

    self.footerSeparationBar = g_overlayManager:createOverlay( "precisionFarming.filled" , 0 , 0 , 0 , 0 )
    self.footerSeparationBar:setColor( unpack( ExtendedSprayerHUDExtension.COLOR.SEPARATOR_BAR))

    self.actualPos = 0.34
    self.targetPos = 0.8

    self.actualValue = 0
    self.actualValueStr = "%.3f"

    self.setValue = 0
    self.targetValue = 0

    self.hasValidValues = false

    self.soilMap = g_precisionFarming.soilMap
    self.pHMap = g_precisionFarming.pHMap
    self.nitrogenMap = g_precisionFarming.nitrogenMap

    self.texts = { }
    self.texts.headline_ph_lime = g_i18n:getText( "hudExtensionSprayer_headline_ph_lime" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.headline_n_solidFertilizer = g_i18n:getText( "hudExtensionSprayer_headline_n_solidFertilizer" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.headline_n_liquidFertilizer = g_i18n:getText( "hudExtensionSprayer_headline_n_liquidFertilizer" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.headline_n_slurryTanker = g_i18n:getText( "hudExtensionSprayer_headline_n_slurryTanker" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.headline_n_manureSpreader = g_i18n:getText( "hudExtensionSprayer_headline_n_manureSpreader" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.actualValue = g_i18n:getText( "hudExtensionSprayer_actualValue" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.newValue = g_i18n:getText( "hudExtensionSprayer_newValue" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.targetReached = g_i18n:getText( "hudExtensionSprayer_targetReached" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.applicationRate = g_i18n:getText( "hudExtensionSprayer_applicationRate" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.soilType = g_i18n:getText( "hudExtensionSprayer_soilType" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.unknown = g_i18n:getText( "hudExtensionSprayer_unknown" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.automaticShort = g_i18n:getText( "hudExtensionSprayer_automaticShort" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_limeAuto = g_i18n:getText( "hudExtensionSprayer_description_limeAuto" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_limeManual = g_i18n:getText( "hudExtensionSprayer_description_limeManual" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_slurryAuto = g_i18n:getText( "hudExtensionSprayer_description_slurryAuto" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_manureAuto = g_i18n:getText( "hudExtensionSprayer_description_manureAuto" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_fertilizerAutoFruit = g_i18n:getText( "hudExtensionSprayer_description_fertilizerAutoFruit" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_fertilizerAutoNoFruit = g_i18n:getText( "hudExtensionSprayer_description_fertilizerAutoNoFruit" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_fertilizerAutoNoFruitDefault = g_i18n:getText( "hudExtensionSprayer_description_fertilizerAutoNoFruitDefault" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_fertilizerManualFruit = g_i18n:getText( "hudExtensionSprayer_description_fertilizerManualFruit" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_fertilizerManualNoFruit = g_i18n:getText( "hudExtensionSprayer_description_fertilizerManualNoFruit" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.description_noFertilizerRequired = g_i18n:getText( "hudExtensionSprayer_description_noFertilizerRequired" , ExtendedSprayerHUDExtension.MOD_NAME)
    self.texts.invalidValues = g_i18n:getText( "hudExtensionSprayer_invalidValues" , ExtendedSprayerHUDExtension.MOD_NAME)

    self.actualValueStr = self.texts.unknown

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
function ExtendedSprayerHUDExtension:setColorBlindMode(isActive)
    if isActive ~ = self.isColorBlindMode then
        self.isColorBlindMode = isActive

        self.pHMap:setMinimapRequiresUpdate( true )
        self.nitrogenMap:setMinimapRequiresUpdate( true )
    end
end

```