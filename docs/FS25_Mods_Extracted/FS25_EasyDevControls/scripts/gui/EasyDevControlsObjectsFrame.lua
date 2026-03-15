--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-02

Contact:
https://forum.giants-software.com
https://github.com/GtX-Andy/FS25_EasyDevelopmentControls

Important:
Not to be added to any mods / maps or modified from its current release form.
No modifications may be made to this script, including conversion to other game versions without written permission from GtX | Andy
Copying or removing any part of this code for external use without written permission from GtX | Andy is prohibited.

Darf nicht zu Mods / Maps hinzugefügt oder von der aktuellen Release-Form geändert werden.
Ohne schriftliche Genehmigung von GtX | Andy dürfen keine Änderungen an diesem Skript vorgenommen werden, einschließlich der Konvertierung in andere Spielversionen
Das Kopieren oder Entfernen irgendeines Teils dieses Codes zur externen Verwendung ohne schriftliche Genehmigung von GtX | Andy ist verboten.
]]

EasyDevControlsObjectsFrame = {}
EasyDevControlsObjectsFrame.NAME = "OBJECTS"

EasyDevControlsObjectsFrame.BALE_TYPE_SQUARE = 1
EasyDevControlsObjectsFrame.BALE_TYPE_ROUND = 2

EasyDevControlsObjectsFrame.BALE_UNWRAPPED = 1
EasyDevControlsObjectsFrame.BALE_WRAPPED = 2

EasyDevControlsObjectsFrame.PALLETS_FARM = 1
EasyDevControlsObjectsFrame.PALLETS_GENERAL = 2
EasyDevControlsObjectsFrame.PALLETS_CROPS = 3
EasyDevControlsObjectsFrame.PALLETS_BIG_BAG = 4
EasyDevControlsObjectsFrame.PALLETS_MODS = 5
EasyDevControlsObjectsFrame.PALLETS_ALL = 6

EasyDevControlsObjectsFrame.SPLIT_SHAPE_TYPE_IDS = {
    EasyDevControlsObjectTypes.LOG,
    EasyDevControlsObjectTypes.STUMP
}

EasyDevControlsObjectsFrame.TIP_LENGTHS = EasyDevControlsUtils.getDefaultRangeTable()
EasyDevControlsObjectsFrame.MAX_TIP_LENGTH = #EasyDevControlsObjectsFrame.TIP_LENGTHS

EasyDevControlsObjectsFrame.CLEAR_RADIUS = EasyDevControlsUtils.getDefaultRangeTable()
EasyDevControlsObjectsFrame.MAX_CLEAR_RADIUS = #EasyDevControlsObjectsFrame.CLEAR_RADIUS

local EasyDevControlsObjectsFrame_mt = Class(EasyDevControlsObjectsFrame, EasyDevControlsBaseFrame)

local platformId = getPlatformId()
local EMPTY_TABLE = {}

function EasyDevControlsObjectsFrame.register()
    local controller = EasyDevControlsObjectsFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsObjectsFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsObjectsFrame", controller, true)

    return controller
end

function EasyDevControlsObjectsFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsObjectsFrame_mt)

    self.pageName = EasyDevControlsObjectsFrame.NAME

    self.intervalTimeRemaining = 5000

    return self
end

function EasyDevControlsObjectsFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsObjectsFrame.register()
end

function EasyDevControlsObjectsFrame:copyAttributes(src)
    EasyDevControlsObjectsFrame:superClass().copyAttributes(self, src)
end

function EasyDevControlsObjectsFrame:initialize()
    self.multiBaleType:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_square"),
        EasyDevControlsUtils.getText("easyDevControls_round")
    })

    self.multiBaleWrapState:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_unwrapped"),
        EasyDevControlsUtils.getText("easyDevControls_wrapped")
    })

    self.multiRemoveSplitShapesTypes:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_typeLogs"),
        EasyDevControlsUtils.getText("easyDevControls_typeStumps")
    })

    self.disableRemoveAllSplitShapes = {
        false,
        false,
        false
    }

    self.multiPalletAmount:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_fill"),
        EasyDevControlsUtils.getText("easyDevControls_empty"),
        EasyDevControlsUtils.getText("easyDevControls_set")
    })

    local colours, colourIndex = EasyDevControlsUtils.getBaleWrapColours()
    local selectedColour = colours[colourIndex].color

    if selectedColour ~= nil then
        self.bitmapBaleWrapColour:setImageColor(nil, selectedColour[1], selectedColour[2], selectedColour[3])
        self.selectedBaleWrapColour = selectedColour
        self.selectedBaleWrapCustomColour = nil
        self.selectedBaleWrapColourIndex = colourIndex
    end

    self:collectBaleTypeData(true)
    self:collectPalletTypeData(true)
    self:collectLogTypeData(true)
    self:collectTreeTypeData(true)
end

function EasyDevControlsObjectsFrame:onMissionFinishedLoading(currentMission)
    local densityMapHeightTypes = g_densityMapHeightManager:getDensityMapHeightTypes()
    local numDensityMapHeightTypes = #densityMapHeightTypes

    local tipAnywhereFillTypeTexts = table.create(numDensityMapHeightTypes)
    self.tipAnywhereFillTypes = table.create(numDensityMapHeightTypes)

    local clearTipAnywhereFillTypeTexts = table.create(numDensityMapHeightTypes)
    self.clearTipAnywhereFillTypes = table.create(numDensityMapHeightTypes)

    table.insert(clearTipAnywhereFillTypeTexts, EasyDevControlsUtils.getText("easyDevControls_all"))
    table.insert(self.clearTipAnywhereFillTypes, FillType.UNKNOWN)

    for i, heightType in ipairs (g_densityMapHeightManager:getDensityMapHeightTypes()) do
        if heightType.fillTypeIndex ~= FillType.TARP then
            local fillTypeTitle = EasyDevControlsUtils.getFillTypeTitle(heightType.fillTypeIndex)

            table.insert(tipAnywhereFillTypeTexts, fillTypeTitle)
            table.insert(self.tipAnywhereFillTypes, heightType.fillTypeIndex)

            table.insert(clearTipAnywhereFillTypeTexts, fillTypeTitle)
            table.insert(self.clearTipAnywhereFillTypes, heightType.fillTypeIndex)
        end
    end

    self.multiTipAnywhereFillType:setTexts(tipAnywhereFillTypeTexts)

    local tipAnywhereLengthTexts = EasyDevControlsUtils.getFormatedRangeTexts(EasyDevControlsObjectsFrame.TIP_LENGTHS, false, false)
    self.optionSliderTipAnywhereLength:setTexts(tipAnywhereLengthTexts)

    local numFarmlands = #g_farmlandManager.sortedFarmlandIds
    local clearTipAnywhereFarmlandTexts = table.create(numFarmlands)

    for _, farmlandId in ipairs (g_farmlandManager.sortedFarmlandIds) do
        table.insert(clearTipAnywhereFarmlandTexts, tostring(farmlandId))
    end

    local clearTipAnywhereRadiusTexts = EasyDevControlsUtils.getFormatedRangeTexts(EasyDevControlsObjectsFrame.CLEAR_RADIUS, false, true)

    self.clearTipAnywhereMaxState = 3

    -- TO_DO: Add fields
    self.clearTipAnywhereStates = {
        {texts = clearTipAnywhereRadiusTexts, lastState = 1, disabled = false},
        {texts = clearTipAnywhereFarmlandTexts, lastState = 1, disabled = numFarmlands == 1},
        {texts = {"...", "..."}, lastState = 1, disabled = true},
    }

    self.multiClearTipAnywhereFillType:setTexts(clearTipAnywhereFillTypeTexts)

    self.multiClearTipAnywhereState:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_radius"),
        g_i18n:getText("ui_ingameMenuMapFarmlands"),
        g_i18n:getText("ui_map")
    })

    self.optionSliderClearTipAnywhereArea:setTexts(clearTipAnywhereRadiusTexts)
end

function EasyDevControlsObjectsFrame:onUpdateCommands(resetToDefault)
    -- TO_DO: Improve, that said these operate different when using the Mixins. for the dual menu types
    if resetToDefault then
        local colours, colourIndex = EasyDevControlsUtils.getBaleWrapColours()
        local selectedColour = colours[colourIndex].color

        if selectedColour ~= nil then
            self.bitmapBaleWrapColour:setImageColor(nil, selectedColour[1], selectedColour[2], selectedColour[3])
            self.selectedBaleWrapColour = selectedColour
            self.selectedBaleWrapCustomColour = nil
            self.selectedBaleWrapColourIndex = colourIndex
        end

        self:collectBaleTypeData(true)
        self:collectPalletTypeData(true)
        self:collectLogTypeData(true)
        self:collectTreeTypeData(true)

        self:onMissionFinishedLoading(g_currentMission)
    end

    local isMasterUser = g_easyDevControls:getIsMasterUser()
    local disableRemoveAllObjects = not isMasterUser

    -- Add Bale
    local addBaleDisabled = not self:getHasPermission("addBale")
    local baleTypeIndex = self.baleTypeIndex or 1
    local baleSizeIndex = self.baleSizeIndex or 1
    local baleFillTypeIndex = self.baleFillTypeIndex or 1

    self.addBaleDisabled = addBaleDisabled
    self:collectBaleTypeData(false)

    self.multiBaleType:setState(baleTypeIndex)
    self.multiBaleType:setDisabled(addBaleDisabled)

    self.optionSliderBaleSize:setTexts(self.baleSizeTexts[baleTypeIndex])
    self.optionSliderBaleSize:setState(baleSizeIndex)
    self.optionSliderBaleSize:setDisabled(addBaleDisabled)

    self.multiBaleFillType:setTexts(self.baleFillTypesTexts[baleTypeIndex][baleSizeIndex])
    self.multiBaleFillType:setState(baleFillTypeIndex, true)
    self.multiBaleFillType:setDisabled(addBaleDisabled)

    self.buttonConfirmBale:setDisabled(addBaleDisabled)

    -- Remove All Bales
    self.buttonConfirmRemoveAllBales:setDisabled(disableRemoveAllObjects)

    -- Add Pallet
    local addPalletDisabled = not self:getHasPermission("addPallet")

    self.addPalletDisabled = addPalletDisabled
    self:collectPalletTypeData(false)

    self.multiPalletCategory:setTexts(self.palletCategoryTexts)
    self.multiPalletCategory:setState(self.palletCategoryIndex or 1, true)
    self.multiPalletAmount:setState(1, true)

    self.multiPalletCategory:setDisabled(addPalletDisabled)
    self.multiPalletFillType:setDisabled(addPalletDisabled)
    self.multiPalletAmount:setDisabled(addPalletDisabled)
    self.buttonConfirmPallet:setDisabled(addPalletDisabled)

    -- Remove All Pallets
    self.buttonConfirmRemoveAllPallets:setDisabled(disableRemoveAllObjects)

    -- Add Log
    local addLogDisabled = not self:getHasPermission("addLog")

    self.addLogDisabled = addLogDisabled
    self:collectLogTypeData(false)

    self.multiLogType:setTexts(self.logTypeTexts)
    self.multiLogType:setState(self.logTypeState or 1, true)

    self.multiLogType:setDisabled(addLogDisabled)
    self.optionSliderLogLength:setDisabled(addLogDisabled)
    self.buttonConfirmLog:setDisabled(addLogDisabled)

    -- Plant Tree
    local plantTreeDisabled = not self:getHasPermission("plantTree")

    self.plantTreeDisabled = plantTreeDisabled
    self:collectTreeTypeData(false)

    self.multiTreeType:setOptions(self.treeTypesInfo)
    self.multiTreeType:setState(self.lastTreeTypeState or 1, true)

    self.multiTreeType:setDisabled(plantTreeDisabled)
    self.multiTreeGrowthState:setDisabled(plantTreeDisabled)
    self.multiTreeVariation:setDisabled(plantTreeDisabled)
    self.multiTreeIsGrowing:setDisabled(plantTreeDisabled)
    self.buttonConfirmPlantTree:setDisabled(plantTreeDisabled)

    -- Remove All Split Shapes
    self.multiRemoveSplitShapesTypes:setDisabled(disableRemoveAllObjects)
    self.buttonConfirmRemoveSplitShapes:setDisabled(disableRemoveAllObjects)

    for i = 1, #self.disableRemoveAllSplitShapes do
        self.disableRemoveAllSplitShapes[i] = disableRemoveAllObjects
    end

    self.disableRemoveAllObjects = disableRemoveAllObjects

    -- Tip Anywhere
    local tipAnywhereDisabled = not self:getHasPermission("tipAnywhere")

    if not tipAnywhereDisabled then
        local x, y, z, dirX, dirZ, player, controlledVehicle = EasyDevControlsUtils.getPlayerWorldLocation()

        if player ~= nil then
            tipAnywhereDisabled = not EasyDevControlsUtils.getCanTipToGround(nil, nil, x, y, z, dirX, dirZ, 1, controlledVehicle, player.farmId)
        else
            tipAnywhereDisabled = true
        end
    end

    self.multiTipAnywhereFillType:setDisabled(tipAnywhereDisabled)
    self.optionSliderTipAnywhereLength:setDisabled(tipAnywhereDisabled)
    self.textInputTipAnywhereAmount:setDisabled(tipAnywhereDisabled)
    self.buttonConfirmTipAnywhere:setDisabled(tipAnywhereDisabled)

    self.tipAnywhereDisabled = tipAnywhereDisabled
    self.tipAnywhereAmount = 0

    -- Clear Tip Anywhere
    local clearTipAnywhereDisabled = not self:getHasPermission("clearTipArea")

    self.clearTipAnywhereDisabled = clearTipAnywhereDisabled
    self.clearTipAnywhereMaxState = isMasterUser and 3 or 2

    local tipAnywhereState = self.multiClearTipAnywhereState:getState()

    if tipAnywhereState > self.clearTipAnywhereMaxState then
        tipAnywhereState = 1
    end

    self.multiClearTipAnywhereState:setState(tipAnywhereState, true)
    self.multiClearTipAnywhereFillType:setDisabled(clearTipAnywhereDisabled)
    self.multiClearTipAnywhereState:setDisabled(clearTipAnywhereDisabled)
    self.buttonConfirmClearTipAnywhere:setDisabled(clearTipAnywhereDisabled)

    -- Show Tip Collisions (Server Only)
    local debugTipCollisions = DensityMapHeightManager.DEBUG_TIP_COLLISIONS

    if debugTipCollisions then
        local elementToElementId = g_debugManager.elementToElementId
        local densityMapHeightManager = g_densityMapHeightManager

        -- TO_DO: Handle with EasyDevControlsDebugManager?
        if elementToElementId ~= nil and elementToElementId[densityMapHeightManager.debugBitVectorMapTipCollisions] == nil then
            if densityMapHeightManager.debugBitVectorMapTipCollisionsId ~= nil then
                g_debugManager:removeElementById(densityMapHeightManager.debugBitVectorMapTipCollisionsId)
                densityMapHeightManager.debugBitVectorMapTipCollisionsId = nil
            end

            DensityMapHeightManager.DEBUG_TIP_COLLISIONS = false
            debugTipCollisions = false
        end
    end

    self.binaryShowTipCollisions:setIsChecked(debugTipCollisions, self.isOpening, false)
    self.binaryShowTipCollisions:setDisabled(g_server == nil)

    -- Bale, Pallet and Split Shape count
    self.intervalTimeRemaining = 0

    -- TO_DO: (Future) Draw marker where bales, pallets, logs and trees will appear when spawned with EDC.

    -- TO_DO: (Future) Update Tip Collisions
end

function EasyDevControlsObjectsFrame:update(dt)
    EasyDevControlsObjectsFrame:superClass().update(self, dt)

    self.intervalTimeRemaining -= dt

    if self.intervalTimeRemaining <= 0 then
        self.intervalTimeRemaining = 5000

        if self.textBaleCount ~= nil then
            self.textBaleCount:setText(EasyDevControlsObjectsFrame.getNumObjectsAndLimitString(SlotSystem.LIMITED_OBJECT_BALE))
        end

        if self.textPalletCount ~= nil then
            self.textPalletCount:setText(EasyDevControlsObjectsFrame.getNumObjectsAndLimitString(SlotSystem.LIMITED_OBJECT_PALLET))
        end

        if self.textTreeCount ~= nil then
            local totalNumSplit, _ = getNumOfSplitShapes()
            self.textTreeCount:setText(string.format("%s / %s", g_i18n:formatNumber(totalNumSplit or 0, 0), g_i18n:formatNumber(g_treePlantManager.maxNumTrees or 0, 0)))
        end
    end
end

-- Add Bale
function EasyDevControlsObjectsFrame:onClickBaleType(state, multiTextOptionElement)
    self.baleTypeIndex = state

    self.optionSliderBaleSize:setTexts(self.baleSizeTexts[state])
    self.optionSliderBaleSize:setState(1, true)
end

function EasyDevControlsObjectsFrame:onClickBaleSize(state, optionSliderElement)
    self.baleSizeIndex = state

    local fillTypesTexts = self.baleFillTypesTexts[self.baleTypeIndex]

    if fillTypesTexts ~= nil and fillTypesTexts[state] ~= nil then
        self.multiBaleFillType:setTexts(fillTypesTexts[state])
        self.multiBaleFillType:setState(1, true)
        self.multiBaleFillType:setDisabled(self.addBaleDisabled or #fillTypesTexts[state] < 2)
    end
end

function EasyDevControlsObjectsFrame:onClickBaleFillType(state, multiTextOptionElement)
    local baleSizeIndex = self.baleSizeIndex
    local baleTypeIndex = self.baleTypeIndex

    local typeSizeData = self.baleSizes[baleTypeIndex]
    local wrapStateDisabled = true

    self.baleFillTypeIndex = state

    if typeSizeData ~= nil and typeSizeData[baleSizeIndex] ~= nil then
        local sizeData = typeSizeData[baleSizeIndex]

        if sizeData.supportsWrapping and self.baleFillTypes[baleTypeIndex] then
            local fillTypesByType = self.baleFillTypes[baleTypeIndex]

            if fillTypesByType[baleSizeIndex] ~= nil and fillTypesByType[baleSizeIndex][state] then
                local fillTypeIndex = fillTypesByType[baleSizeIndex][state]

                if fillTypeIndex == FillType.GRASS_WINDROW or fillTypeIndex == FillType.CHAFF or fillTypeIndex == FillType.SILAGE then
                    wrapStateDisabled = false
                end
            end
        end
    end

    if wrapStateDisabled then
        self.multiBaleWrapState:setState(EasyDevControlsObjectsFrame.BALE_UNWRAPPED, true)
    else
        self.multiBaleWrapState:setState(self.multiBaleWrapState:getState(), true)
    end

    self.multiBaleWrapState:setDisabled(self.addBaleDisabled or wrapStateDisabled)
end

function EasyDevControlsObjectsFrame:onClickBaleWrapState(state, multiTextOptionElement)
    self.baleWrapStateIndex = state
    self.buttonBaleWrapColour:setDisabled(self.addBaleDisabled or state == EasyDevControlsObjectsFrame.BALE_UNWRAPPED)
end

function EasyDevControlsObjectsFrame:onClickSelectColour(buttonElement)
    local colours, colourIndex = EasyDevControlsUtils.getBaleWrapColours(self.selectedBaleWrapColourIndex)
    local customColor = self.selectedBaleWrapCustomColour -- If the last selected was custom then open dialog to correct tab

    local args = {
        buttonElement = buttonElement,
        colours = colours
    }

    ColorPickerDialog.show(self.onPickBaleWrapColour, self, args, colours, colourIndex, nil, customColor, true, true, true)
end

function EasyDevControlsObjectsFrame:onPickBaleWrapColour(colourIndex, args, colourInfo)
    local selectedColour = nil

    if colourIndex ~= nil then
        selectedColour = args.colours[colourIndex].color
        self.selectedBaleWrapColourIndex = colourIndex
        self.selectedBaleWrapCustomColour = nil
    elseif colourInfo ~= nil then
        selectedColour = colourInfo.customColor
        self.selectedBaleWrapColourIndex = nil
        self.selectedBaleWrapCustomColour = selectedColour
    end

    if selectedColour ~= nil then
        self.bitmapBaleWrapColour:setImageColor(nil, selectedColour[1], selectedColour[2], selectedColour[3])
        self.selectedBaleWrapColour = selectedColour
    end
end

function EasyDevControlsObjectsFrame:onClickConfirmBale(buttonElement)
    local x, y, z, _, _, _, ry = EasyDevControlsUtils.getObjectSpawnLocation(5.5)

    local fillTypeIndex = self.baleFillTypes[self.baleTypeIndex][self.baleSizeIndex][self.baleFillTypeIndex]
    local isRoundbale = self.baleTypeIndex == EasyDevControlsObjectsFrame.BALE_TYPE_ROUND
    local baleSizes = self.baleSizes[self.baleTypeIndex][self.baleSizeIndex]
    local width, height, length, diameter = baleSizes.width, baleSizes.height, baleSizes.length, baleSizes.diameter

    local _, baleIndex = g_baleManager:getBaleXMLFilename(fillTypeIndex, isRoundbale, width, height, length, diameter, nil)

    if baleIndex ~= nil then
        self.intervalTimeRemaining = 1500
        self:setInfoText(g_easyDevControls:spawnBale(baleIndex, fillTypeIndex, self.baleWrapStateIndex - 1, g_currentMission:getFarmId(), x, y, z, ry, nil, nil, self.selectedBaleWrapColour))
    end
end

function EasyDevControlsObjectsFrame:collectBaleTypeData(force)
    if not force and self.baleSizes ~= nil and self.baleSizeTexts ~= nil and self.baleFillTypes ~= nil and self.baleFillTypesTexts ~= nil then
        return
    end

    local numSquareBaleSizes = 0
    local numRoundBaleSizes = 0

    local squareBaleSizes = {}
    local roundBaleSizes = {}

    local squareBales = {}
    local roundBales = {}

    self.baleSizes = {{}, {}}
    self.baleSizeTexts = {{}, {}}

    self.baleFillTypes = {{}, {}}
    self.baleFillTypesTexts = {{}, {}}

    self.baleTypeIndex = 1
    self.baleSizeIndex = 1
    self.baleFillTypeIndex = 1
    self.baleWrapStateIndex = 1

    for _, bale in ipairs(g_baleManager.bales) do
        if bale.isAvailable and (bale.customEnvironment == nil or bale.customEnvironment == "") then
            if bale.isRoundbale then
                if roundBaleSizes[bale.diameter] == nil then
                    roundBaleSizes[bale.diameter] = {}

                    numRoundBaleSizes = numRoundBaleSizes + 1
                end

                table.insert(roundBaleSizes[bale.diameter], bale)
            else
                if squareBaleSizes[bale.length] == nil then
                    squareBaleSizes[bale.length] = {}

                    numSquareBaleSizes = numSquareBaleSizes + 1
                end

                table.insert(squareBaleSizes[bale.length], bale)
            end
        end
    end

    if numSquareBaleSizes > 0 then
        for _, bales in pairs(squareBaleSizes) do
            table.insert(squareBales, bales)
        end

        table.sort(squareBales, function (a, b)
            return a[1].length < b[1].length
        end)
    end

    if numRoundBaleSizes > 0 then
        for _, bales in pairs(roundBaleSizes) do
            table.insert(roundBales, bales)
        end

        table.sort(roundBales, function (a, b)
            return a[1].diameter < b[1].diameter
        end)
    end

    for typeIndex, baleTypes in ipairs({squareBales, roundBales}) do
        for i, bales in ipairs (baleTypes) do
            local refBale = bales[1]

            local baleSize = {}
            local baleSizeText = nil

            local baleFillTypes = {}
            local baleFillTypesTexts = {}

            local fillTypesAdded = {}

            for _, bale in pairs(bales) do
                for _, fillTypeData in ipairs(bale.fillTypes) do
                    if not fillTypesAdded[fillTypeData.fillTypeIndex] then
                        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeData.fillTypeIndex)

                        table.insert(baleFillTypes, fillType.index)
                        table.insert(baleFillTypesTexts, fillType.title)

                        fillTypesAdded[fillTypeData.fillTypeIndex] = true
                    end
                end
            end

            if typeIndex == EasyDevControlsObjectsFrame.BALE_TYPE_ROUND then
                baleSize.width = refBale.width
                baleSize.diameter = refBale.diameter

                baleSizeText = EasyDevControlsUtils.formatLength(refBale.diameter, true)
            else
                baleSize.width = refBale.width
                baleSize.height = refBale.height
                baleSize.length = refBale.length

                baleSizeText = EasyDevControlsUtils.formatLength(refBale.length, true)
            end

            baleSize.supportsWrapping = fillTypesAdded[FillType.SILAGE]

            self.baleSizes[typeIndex][i] = baleSize
            self.baleSizeTexts[typeIndex][i] = baleSizeText

            self.baleFillTypes[typeIndex][i] = baleFillTypes
            self.baleFillTypesTexts[typeIndex][i] = baleFillTypesTexts
        end
    end
end

-- Bale List
function EasyDevControlsObjectsFrame:onClickShowBaleList(buttonElement)
    local bales = g_baleManager.bales
    local list = table.create(#bales)

    local widthText = EasyDevControlsUtils.getText("easyDevControls_width")
    local heightText = EasyDevControlsUtils.getText("easyDevControls_height")
    local lengthText = EasyDevControlsUtils.getText("easyDevControls_length")
    local diameterText = EasyDevControlsUtils.getText("easyDevControls_diameter")

    local sizeText = EasyDevControlsUtils.getText("easyDevControls_size") .. ":"
    local fillTypesText = "\n\n  " .. EasyDevControlsUtils.getText("easyDevControls_fillTypes") .. ":"

    for i, bale in ipairs(bales) do
        local text = sizeText

        if bale.width ~= nil and bale.width ~= 0 then
            text = string.format("%s\n    %s: %s", text, widthText, bale.width)
        end

        if bale.height ~= nil and bale.height ~= 0 then
            text = string.format("%s\n    %s: %s", text, heightText, bale.height)
        end

        if bale.length ~= nil and bale.length ~= 0 then
            text = string.format("%s\n    %s: %s", text, lengthText, bale.length)
        end

        if bale.diameter ~= nil and bale.diameter ~= 0 then
            text = string.format("%s\n    %s: %s", text, diameterText, bale.diameter)
        end

        text = text .. fillTypesText

        for _, fillTypeData in ipairs(bale.fillTypes) do
            local fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(fillTypeData.fillTypeIndex)

            text = string.format("%s\n    %s (%s)", text, fillTypeDesc.name, fillTypeDesc.title)
        end

        table.insert(list, {
            bale = bale,
            overlayColour = EasyDevControlsGuiManager.OVERLAY_COLOUR,
            title = NetworkUtil.convertToNetworkFilename(bale.xmlFilename or ""),
            text = text
        })
    end

    if #list > 0 then
        table.sort(list, EasyDevControlsObjectsFrame.baleListSorter)
    end

    EasyDevControlsDynamicListDialog.show(EasyDevControlsUtils.getText("easyDevControls_availableBaleTypesTitle"), list)
end

-- Bales Fermenting
function EasyDevControlsObjectsFrame:onClickShowBalesFermenting(buttonElement)
    local list = {}

    local baleText = g_i18n:getText("infohud_bale")
    local fermentingText = g_i18n:getText("info_fermenting")
    local sizeText = EasyDevControlsUtils.getText("easyDevControls_size")
    local locationText = EasyDevControlsUtils.getText("easyDevControls_location")
    local storageText = EasyDevControlsUtils.getText("statistic_storage")
    local yesText = g_i18n:getText("ui_yes")
    local noText = g_i18n:getText("ui_no")

    local farmId = g_currentMission:getFarmId()
    local infoString = "  %s: %d%%\n  %s: %s\n  %s\n  %s: %s\n  %s: %s"
    local baleObjects = EasyDevControlsUtils.getBaleObjectsFromObjectStorages()

    for _, item in pairs (g_currentMission.itemSystem.itemsToSave) do
        local object = item.item

        if object.isa ~= nil and object:isa(Bale) and g_currentMission.accessHandler:canFarmAccessOtherId(farmId, object:getOwnerFarmId()) then
            if object.getIsFermenting ~= nil and object:getIsFermenting() then
                local percentage = object.fermentingPercentage or 0
                local location = EasyDevControlsUtils.getObjectLocationString(object.nodeId)

                local baleSizeText, baleSize = "", 0
                local fillLevel = object:getFillLevel()
                local fillTypeTitle = EasyDevControlsUtils.getFillTypeTitle(object:getFillType())

                if object.isRoundbale then
                    baleSizeText = string.format("%s: %s", sizeText, EasyDevControlsUtils.formatLength(object.diameter, true))
                    baleSize = object.diameter
                else
                    baleSizeText = string.format("%s: %s", sizeText, EasyDevControlsUtils.formatLength(object.length, true))
                    baleSize = object.length
                end

                local isStoredText = baleObjects[object] ~= nil and yesText or noText

                table.insert(list, {
                    bale = object,
                    overlayColour = EasyDevControlsGuiManager.OVERLAY_COLOUR,
                    title = "...",
                    text = string.format(infoString, fermentingText, percentage * 100, fillTypeTitle, g_i18n:formatVolume(fillLevel, 0), baleSizeText, locationText, location, storageText, isStoredText)
                })
            end
        end
    end

    if #list > 0 then
        table.sort(list, EasyDevControlsObjectsFrame.baleListSorter)

        for i, item in ipairs (list) do
            item.title = string.format("%s %i", baleText, i)
        end
    end

    EasyDevControlsDynamicListDialog.show(EasyDevControlsUtils.getText("easyDevControls_fermentingBalesTitle"), list)
end

function EasyDevControlsObjectsFrame.baleListSorter(a, b)
    local bale1 = a.bale
    local bale2 = b.bale

    if bale1.isRoundbale == bale2.isRoundbale then
        if bale1.isRoundbale then
            if bale1.diameter == bale2.diameter then
                return bale1.width < bale2.width
            end

            return bale1.diameter < bale2.diameter
        end

        return bale1.length < bale2.length
    end

    if bale1.isRoundbale then
        return true
    end

    return false
end

-- Add Pallet
function EasyDevControlsObjectsFrame:onClickPalletCategory(state, multiTextOptionElement)
    local category = self.palletCategories[state]

    if category ~= nil then
        local disabled = #category.fillTypeTexts == 0

        if not disabled then
            self.multiPalletFillType:setTexts(category.fillTypeTexts)
        else
            self.multiPalletFillType:setTexts({g_i18n:getText("ui_none")})
        end

        self.multiPalletFillType:setState(category.lastState)

        self.multiPalletFillType:setDisabled(disabled)
        self.multiPalletAmount:setDisabled(disabled)
        self.textInputPalletAmount:setDisabled(disabled)
        self.buttonConfirmPallet:setDisabled(disabled)
    else
        state = 1
        multiTextOptionElement:setState(state)
    end

    self.palletCategoryIndex = state
end

function EasyDevControlsObjectsFrame:onClickPalletFillType(state, multiTextOptionElement)
    local category = self.palletCategories[self.palletCategoryIndex]

    if category ~= nil then
        category.lastState = state
    else
        self.multiPalletCategory:setState(1, true)
    end
end

function EasyDevControlsObjectsFrame:onClickPalletAmount(state, multiTextOptionElement)
    local textInputElement = self.textInputPalletAmount

    if textInputElement.setPlaceholderText ~= nil then
        local placeholderText = "0"

        if state == 1 then
            placeholderText = EasyDevControlsUtils.getText("easyDevControls_maximum")
        elseif state == 3 then
            placeholderText = "Enter Amount"
        end

        textInputElement:setPlaceholderText(placeholderText)
    end

    textInputElement:setDisabled(state < 3 or self.addPalletDisabled)
end

function EasyDevControlsObjectsFrame:onEnterPressedPalletAmount(textInputElement, mouseClickedOutside)
    local amountToAdd = textInputElement.text ~= "" and tonumber(textInputElement.text) or nil

    if amountToAdd ~= nil then
        self:requestPalletSpawn(amountToAdd)
    else
        textInputElement.lastValidText = ""
        textInputElement:setText("")

        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsObjectsFrame:onClickConfirmPallet(buttonElement)
    local state = self.multiPalletAmount:getState()

    if state < 3 then
        self:requestPalletSpawn(state == 2 and 0 or nil)
    else
        self:onEnterPressedPalletAmount(self.textInputPalletAmount, false)
    end
end

function EasyDevControlsObjectsFrame:requestPalletSpawn(amountToAdd)
    local category = self.palletCategories[self.palletCategoryIndex]

    if category ~= nil then
        local x, y, z, _, _, _, ry = EasyDevControlsUtils.getObjectSpawnLocation(0) -- 1.6

        local fillTypeIndex = category.fillTypes[category.lastState]
        local xmlFilename = category.xmlFilenames[category.lastState]

        if category.customPallets ~= nil and category.customPallets[fillTypeIndex] ~= nil then
            xmlFilename = category.customPallets[fillTypeIndex]
        end

        self.intervalTimeRemaining = 1500
        g_easyDevControls:spawnPallet(fillTypeIndex, xmlFilename, g_currentMission:getFarmId(), x, y, z, ry, amountToAdd, self, nil) -- Info text is set from the 'spawnPallet' function after async success.
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsObjectsFrame:collectPalletTypeData(force)
    if not force and self.palletCategoryTexts ~= nil and (self.palletCategories ~= nil and #self.palletCategories == 6) then
        return
    end

    local pallets = {}
    local customPallets = {}

    local farmFillTypes = {}
    local nextFarmFillTypeId = 1

    local invalidPalletFillTypes = {
        [FillType.OILSEEDRADISH] = true,
        [FillType.COTTON] = true,
        [FillType.TARP] = true
    }

    local bigBagFillTypes = {
        FillType.SEEDS,
        FillType.FERTILIZER,
        FillType.LIME,
        FillType.ROADSALT,
        FillType.WHEAT,
        FillType.OAT,
        FillType.PIGFOOD
    }

    local bigBagFilenames = {
        [FillType.SEEDS] = "data/objects/bigBag/seeds/bigBag_seeds.xml",
        [FillType.FERTILIZER] = "data/objects/bigBag/fertilizer/bigBag_fertilizer.xml",
        [FillType.LIME] = "data/objects/bigBag/lime/bigBag_lime.xml",
        [FillType.ROADSALT] = "data/objects/bigBag/roadSalt/bigBag_roadSalt.xml",
        [FillType.WHEAT] = "data/objects/bigBag/chickenFood/bigBag_chickenFood.xml",
        [FillType.OAT] = "data/objects/bigBag/horseFood/bigBag_horseFood.xml",
        [FillType.PIGFOOD] = "data/objects/bigBag/pigFood/bigBag_pigFood.xml"
    }

    local xmlFilename = ""
    local baseFillablePalletXML = "data/objects/pallets/fillablePallet/fillablePallet.xml"
    local fillablePalletXML = EasyDevControlsUtils.getLocalFilename("shared/fillablePallet.xml")
    local hasCustomFillablePallet = g_storeManager:getItemByXMLFilename(fillablePalletXML) ~= nil
	
	local customEnvironment = EasyDevControlsUtils.getCustomEnvironment()

    local function palletSorter(a, b)
        local fillTypeA = g_fillTypeManager.fillTypes[a]
        local fillTypeB = g_fillTypeManager.fillTypes[b]

        if fillTypeA ~= nil and fillTypeB ~= nil then
            return fillTypeA.title < fillTypeB.title
        end

        return false
    end

    local function addPalletCategory(title, hasCustomPallets)
        local category = {
            title = title,
            lastState = 1,
            fillTypes = {},
        }

        if hasCustomPallets then
            category.customPallets = {}
        end

        table.insert(self.palletCategories, category)
        table.insert(self.palletCategoryTexts, category.title)
    end

    local function addFarmFillType(fillTypeIndex)
        if fillTypeIndex ~= nil and farmFillTypes[fillTypeIndex] == nil then
            farmFillTypes[fillTypeIndex] = nextFarmFillTypeId
            nextFarmFillTypeId += 1
        end
    end

    local function addPalletFilename(fillTypeName, palletFilename, baseDirectory)
        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)

        if fillTypeIndex ~= nil then
            if palletFilename == nil then
                customPallets[fillTypeIndex] = fillablePalletXML

                return true
            end

            palletFilename = Utils.getFilename(palletFilename, baseDirectory)

            if g_storeManager:getItemByXMLFilename(palletFilename) ~= nil then
                customPallets[fillTypeIndex] = palletFilename

                return true
            end
        end

        return false
    end

    addFarmFillType(FillType.SEEDS)
    addFarmFillType(FillType.FERTILIZER)
    addFarmFillType(FillType.LIME)
    addFarmFillType(FillType.LIQUIDFERTILIZER)
    addFarmFillType(FillType.HERBICIDE)
    addFarmFillType(FillType.MANURE)
    addFarmFillType(FillType.MINERAL_FEED)
    addFarmFillType(FillType.SILAGE_ADDITIVE)
    addFarmFillType(FillType.TREESAPLINGS)
    addFarmFillType(FillType.SUGARCANE)
    addFarmFillType(FillType.POPLAR)
    addFarmFillType(FillType.POTATO)
    addFarmFillType(FillType.PIGFOOD)
    addFarmFillType(FillType.FORAGE)
    addFarmFillType(FillType.WHEAT)
    addFarmFillType(FillType.OAT)
    addFarmFillType(FillType.ROADSALT)

    -- Missing pallets in the base game
    if hasCustomFillablePallet then
        addPalletFilename("SUGARBEET")
        addPalletFilename("SUGARBEET_CUT")
        addPalletFilename("FORAGE")
        addPalletFilename("CHAFF")
        addPalletFilename("WOODCHIPS")
        addPalletFilename("SILAGE")
        addPalletFilename("SNOW")
        addPalletFilename("ROADSALT")
        addPalletFilename("MANURE")
        addPalletFilename("STONE")
    end

    -- addPalletFilename("TREESAPLINGS", "$data/objects/pallets/treeSaplingPallet02/treeSaplingPallet02.xml")
    addPalletFilename("POPLAR", "$data/objects/pallets/palletPoplar/palletPoplar.xml")
    addPalletFilename("PIGFOOD", "$data/objects/bigBagPallet/pigFood/bigBagPallet_pigFood.xml")

    -- GtX Production
    if FillType.MAPLESYRUP ~= nil then
        local mapleSyrupProductionDirectory = g_modNameToDirectory["FS25_MapleSyrupProduction"]

        if mapleSyrupProductionDirectory ~= nil then
            addPalletFilename("MAPLESYRUP", "pallets/mapleSyrupPallet.xml", mapleSyrupProductionDirectory)
        end
    end

    -- GtX Seed Cleaner
    -- addFarmFillType(FillType.LUMIGEN)

    for _, fillType in ipairs(g_fillTypeManager:getFillTypes()) do
        if invalidPalletFillTypes[fillType.index] == nil then
            if customPallets[fillType.index] ~= nil then
                pallets[fillType.index] = customPallets[fillType.index]
            elseif fillType.palletFilename ~= nil then
                if hasCustomFillablePallet and fillType.palletFilename == baseFillablePalletXML then
                    pallets[fillType.index] = fillablePalletXML -- Replace with custom version that includes discharge node
                else
                    pallets[fillType.index] = fillType.palletFilename
                end
            end
        end
    end

    self.palletCategoryIndex = 1
    self.numPalletCategories = 6

    self.palletCategories = table.create(self.numPalletCategories)
    self.palletCategoryTexts = table.create(self.numPalletCategories)

    addPalletCategory(EasyDevControlsUtils.getText("easyDevControls_farmProducts"), true)
    addPalletCategory(EasyDevControlsUtils.getText("easyDevControls_generalHeader"), false)
    addPalletCategory(g_i18n:getText("ui_map_crops"), false)
    addPalletCategory(g_i18n:getText("category_bigbags"), false)
    addPalletCategory(g_i18n:getText("ui_modsAndDlcs"), false)
    addPalletCategory(EasyDevControlsUtils.getText("easyDevControls_all"), false)

    for fillTypeIndex, _ in pairs (pallets) do
        local index = farmFillTypes[fillTypeIndex]

        if index ~= nil then
            self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_FARM].fillTypes[index] = fillTypeIndex

            if fillTypeIndex == FillType.WHEAT then
                xmlFilename = "data/objects/bigBagPallet/chickenFood/bigBagPallet_chickenFood.xml"

                if g_storeManager:getItemByXMLFilename(xmlFilename) ~= nil then
                    self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_FARM].customPallets[fillTypeIndex] = xmlFilename
                end

                table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_CROPS].fillTypes, fillTypeIndex)
            elseif fillTypeIndex == FillType.OAT then
                xmlFilename = "data/objects/bigBagPallet/horseFood/bigBagPallet_horseFood.xml"

                if g_storeManager:getItemByXMLFilename(xmlFilename) ~= nil then
                    self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_FARM].customPallets[fillTypeIndex] = xmlFilename
                end

                table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_CROPS].fillTypes, fillTypeIndex)
            elseif fillTypeIndex == FillType.ROADSALT then
                xmlFilename = "data/objects/bigBagPallet/roadSalt/bigBagPallet_roadSalt.xml"

                if g_storeManager:getItemByXMLFilename(xmlFilename) ~= nil then
                    self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_FARM].customPallets[fillTypeIndex] = xmlFilename
                end

                table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_GENERAL].fillTypes, fillTypeIndex)
            end
        elseif g_fruitTypeManager.fillTypeIndexToFruitTypeIndex[fillTypeIndex] ~= nil or g_fruitTypeManager.windrowFillTypes[fillTypeIndex] == true or fillTypeIndex == FillType.SUGARBEET_CUT then
            table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_CROPS].fillTypes, fillTypeIndex)
        else
            table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_GENERAL].fillTypes, fillTypeIndex)
        end

        local palletFillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

        if palletFillType and (palletFillType.palletFilename or customPallets[fillTypeIndex]) then
            local modName, _ = Utils.getModNameAndBaseDirectory(palletFillType.palletFilename or customPallets[fillTypeIndex])

            if modName ~= nil and modName ~= customEnvironment then
                table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_MODS].fillTypes, fillTypeIndex)
            end
        end

        table.insert(self.palletCategories[EasyDevControlsObjectsFrame.PALLETS_ALL].fillTypes, fillTypeIndex)
    end

    for i, category in ipairs (self.palletCategories) do
        if i ~= EasyDevControlsObjectsFrame.PALLETS_BIG_BAG then
            if i ~= EasyDevControlsObjectsFrame.PALLETS_FARM then
                table.sort(category.fillTypes, palletSorter)
            end

            category.xmlFilenames = table.create(#category.fillTypes)
            category.fillTypeTexts = table.create(#category.fillTypes)

            for _, fillTypeIndex in ipairs (category.fillTypes) do
                table.insert(category.xmlFilenames, pallets[fillTypeIndex])
                table.insert(category.fillTypeTexts, EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex))
            end
        else
            local numBigBagFillTypes = #bigBagFillTypes

            category.fillTypes = table.create(numBigBagFillTypes)
            category.xmlFilenames = table.create(numBigBagFillTypes)
            category.fillTypeTexts = table.create(numBigBagFillTypes)

            for _, fillTypeIndex in ipairs (bigBagFillTypes) do
                local bigBagFilename = bigBagFilenames[fillTypeIndex]

                if bigBagFilename == nil or g_storeManager:getItemByXMLFilename(bigBagFilename) == nil then
                    bigBagFilename = "data/objects/bigBag/bigBag.xml"
                end

                table.insert(category.xmlFilenames, bigBagFilename)
                table.insert(category.fillTypes, fillTypeIndex)
                table.insert(category.fillTypeTexts, EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex))
            end
        end
    end
end

-- Remove All Pallets / Bales
function EasyDevControlsObjectsFrame:onClickConfirmRemoveAll(buttonElement)
    self:onConfirmRemoveAll(EasyDevControlsObjectTypes.getByName(buttonElement.name), buttonElement)
end

-- Add Log
function EasyDevControlsObjectsFrame:onClickLogType(state, multiTextOptionElement)
    local logTypesInfo = self.logTypesInfo[state]

    if logTypesInfo ~= nil then
        self.optionSliderLogLength:setTexts(logTypesInfo.lengthTexts)
        self.optionSliderLogLength:setState(logTypesInfo.lastLengthState)

        self.logTypeState = state
    else
        multiTextOptionElement:setState(1)
        self.logTypeState = 1
    end
end

function EasyDevControlsObjectsFrame:onClickLogLength(state, optionSliderElement)
    local logTypesInfo = self.logTypesInfo[self.logTypeState]

    if logTypesInfo ~= nil then
        logTypesInfo.lastLengthState = state
    else
        self.multiLogType:setState(1, true)
    end
end

function EasyDevControlsObjectsFrame:onClickConfirmLog(buttonElement)
    local logTypesInfo = self.logTypesInfo[self.logTypeState]

    if logTypesInfo ~= nil then
        local x, y, z, dirX, dirY, dirZ, _ = EasyDevControlsUtils.getObjectSpawnLocation(1.1)

        self:setInfoText(g_easyDevControls:spawnLog(logTypesInfo.index, logTypesInfo.lastLengthState, logTypesInfo.growthState, x, y, z, dirX, dirY, dirZ))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsObjectsFrame:collectLogTypeData(force)
    if force or (self.logTypesInfo == nil or #self.logTypesInfo == 0) or self.logTypeTexts == nil then
        self.logTypesInfo = {}
        self.logTypeState = 1

        for name, maxLength in pairs (EasyDevControlsUtils.TREE_NAME_TO_LOG_LENGTH or EMPTY_TABLE) do
            local treeType = g_treePlantManager:getTreeTypeDescFromName(name)

            if treeType ~= nil then
                local logTypeInfo = {
                    title = treeType.title,
                    growthState = #treeType.stages,
                    index = treeType.index,
                    maxLength = maxLength,
                    lastLengthState = 1
                }

                local metersShort = g_i18n:getText("unit_mShort")
                logTypeInfo.lengthTexts = table.create(maxLength)

                for i = 1, maxLength do
                    table.insert(logTypeInfo.lengthTexts, string.format("%d %s", i, metersShort))
                end

                table.insert(self.logTypesInfo, logTypeInfo)
            end
        end

        table.sort(self.logTypesInfo, function (a, b)
            return a.maxLength > b.maxLength
        end)

        self.logTypeTexts = table.create(#self.logTypesInfo)

        for _, info in ipairs (self.logTypesInfo) do
            table.insert(self.logTypeTexts, info.title)
        end
    end
end

-- Plant Tree
function EasyDevControlsObjectsFrame:onClickTreeType(treeTypeInfo, multiOptionElement, isLeftButtonEvent)
    self.lastTreeTypeState = self.multiTreeType:getState()

    self.multiTreeGrowthState:setTexts(treeTypeInfo.growthStageTexts)
    self.multiTreeGrowthState:setState(treeTypeInfo.lastGrowthStateState, true)
    self.multiTreeGrowthState:setDisabled(self.plantTreeDisabled or #treeTypeInfo.growthStageTexts < 2)
end

function EasyDevControlsObjectsFrame:onClickTreeGrowthState(state, multiTextOptionElement)
    local treeTypeInfo = self.treeTypesInfo[self.lastTreeTypeState]

    if treeTypeInfo ~= nil then
        treeTypeInfo.lastGrowthStateState = state

        self.multiTreeVariation:setTexts(treeTypeInfo.growthStageVariationTexts[state])
        self.multiTreeVariation:setState(treeTypeInfo.growthStageLastVariationState[state])
        self.multiTreeVariation:setDisabled(self.plantTreeDisabled or #treeTypeInfo.growthStageVariationTexts[state] < 2)

        local disableIsGrowing = state == #treeTypeInfo.growthStageTexts

        if disableIsGrowing then
            treeTypeInfo.lastIsGrowingState = 2
        end

        self.multiTreeIsGrowing:setState(treeTypeInfo.lastIsGrowingState)
        self.multiTreeIsGrowing:setDisabled(self.plantTreeDisabled or disableIsGrowing)
    end
end

function EasyDevControlsObjectsFrame:onClickTreeVariation(state, multiTextOptionElement)
    local treeTypeInfo = self.treeTypesInfo[self.lastTreeTypeState]

    if treeTypeInfo ~= nil then
        treeTypeInfo.growthStageLastVariationState[self.multiTreeGrowthState:getState()] = state
    end
end

function EasyDevControlsObjectsFrame:onClickTreeIsGrowing(state, multiTextOptionElement)
    local treeTypeInfo = self.treeTypesInfo[self.lastTreeTypeState]

    if treeTypeInfo ~= nil then
        treeTypeInfo.lastIsGrowingState = state
    end
end

function EasyDevControlsObjectsFrame:onClickConfirmPlantTree(buttonElement)
    local x, y, z = EasyDevControlsUtils.getObjectSpawnLocation(0, true)
    local treeTypeInfo = self.treeTypesInfo[self.multiTreeType:getState()]

    if treeTypeInfo ~= nil then
        local growthStateI = self.multiTreeGrowthState:getState()
        local variationIndex = treeTypeInfo.growthStageLastVariationState[growthStateI]
        local isGrowing = self.multiTreeIsGrowing:getState() == 1

        self.intervalTimeRemaining = 1500
        self:setInfoText(g_easyDevControls:plantTree(treeTypeInfo.index, growthStateI, variationIndex, isGrowing, x, y, z, nil))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsObjectsFrame:collectTreeTypeData(force)
    if force or (self.treeTypesInfo == nil or #self.treeTypesInfo == 0) then
        local treeTypeInfo = nil
        local numTreeTypeStages = nil
        local variationTexts = nil
        local variationTextsIndex = nil

        local growthStageText = EasyDevControlsUtils.getText("easyDevControls_growthStage")
        local defaultText = EasyDevControlsUtils.getText("easyDevControls_default")
        local variationText = EasyDevControlsUtils.getText("easyDevControls_variation")
        local variationDefault = "DEFAULT"

        local treeTypes = g_treePlantManager.treeTypes
        local numTreeTypes = #treeTypes

        self.treeTypesInfo = table.create(numTreeTypes)
        self.lastTreeTypeState = 1

        for index, treeType in ipairs(treeTypes) do
            if treeType.name ~= "TRANSPORT" then
                treeTypeInfo = {
                    title = treeType.title,
                    index = index,
                    name = treeType.name,
                    lastGrowthStateState = 1,
                    lastIsGrowingState = 1
                }

                numTreeTypeStages = #treeType.stages

                treeTypeInfo.growthStageTexts = table.create(numTreeTypeStages)
                treeTypeInfo.growthStageLastVariationState = table.create(numTreeTypeStages)
                treeTypeInfo.growthStageVariationTexts = table.create(numTreeTypeStages)

                for stageIndex, stageVariations in ipairs(treeType.stages) do
                    table.insert(treeTypeInfo.growthStageTexts, string.format(growthStageText, stageIndex))

                    variationTextsIndex = 0
                    variationTexts = table.create(#stageVariations)

                    for variationIndex, variation in ipairs(stageVariations) do
                        if variation.name == nil then
                            variationTextsIndex += 1
                            table.insert(variationTexts, string.format("%s  %d", variationText, variationTextsIndex))
                        elseif variation.name == variationDefault then
                            table.insert(variationTexts, defaultText)
                        else
                            table.insert(variationTexts, variation.name)
                        end
                    end

                    table.insert(treeTypeInfo.growthStageVariationTexts, variationTexts)
                    table.insert(treeTypeInfo.growthStageLastVariationState, 1)
                end

                table.insert(self.treeTypesInfo, treeTypeInfo)
            end
        end

        table.sort(self.treeTypesInfo, function (a, b)
            return a.title < b.title
        end)
    end
end

-- Remove Split Shapes
function EasyDevControlsObjectsFrame:onClickRemoveSplitShapesTypes(state, multiTextOptionElement)
    self.buttonConfirmRemoveSplitShapes:setDisabled(self.disableRemoveAllObjects or self.disableRemoveAllSplitShapes[state])
end

function EasyDevControlsObjectsFrame:onClickConfirmRemoveSplitShapes(buttonElement)
    local state = self.multiRemoveSplitShapesTypes:getState()
    self:onConfirmRemoveAll(EasyDevControlsObjectsFrame.SPLIT_SHAPE_TYPE_IDS[state], buttonElement)
end

function EasyDevControlsObjectsFrame.getRemoveAllSplitShapesParams()
    return string.format("%s:  %s\n%s:  %s",
        EasyDevControlsUtils.capitalise(EasyDevControlsUtils.getText("easyDevControls_typeLogs"), false),
        EasyDevControlsUtils.getText("easyDevControls_removeAllLogsHelp"),
        EasyDevControlsUtils.capitalise(EasyDevControlsUtils.getText("easyDevControls_typeStumps"), false),
        EasyDevControlsUtils.getText("easyDevControls_removeAllStumpsHelp")
    )
end

-- Tip Anywhere
function EasyDevControlsObjectsFrame:onTipAnywhereAmountEnterPressed(textInputElement, mouseClickedOutside)
    local amount = textInputElement.text ~= "" and tonumber(textInputElement.text) or 0

    if amount == 0 then
        textInputElement.lastValidText = ""
        textInputElement:setText("")
    end

    self.tipAnywhereAmount = amount
end

function EasyDevControlsObjectsFrame:onClickConfirmTipAnywhere(buttonElement)
    self:onTipAnywhereAmountEnterPressed(self.textInputTipAnywhereAmount, false) -- Make sure there is a value

    if self.tipAnywhereAmount > 0 then
        local x, y, z, dirX, dirZ, player, controlledVehicle = EasyDevControlsUtils.getPlayerWorldLocation()

        local fillTypeIndex = self.tipAnywhereFillTypes[self.multiTipAnywhereFillType:getState()]
        local length = EasyDevControlsObjectsFrame.TIP_LENGTHS[self.optionSliderTipAnywhereLength:getState()]

        self:setInfoText(g_easyDevControls:tipHeightType(self.tipAnywhereAmount, fillTypeIndex, x, y, z, dirX, dirZ, length, controlledVehicle, player))
        self:onTextInputEscPressed(self.textInputTipAnywhereAmount)
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Clear Tip Anywhere
function EasyDevControlsObjectsFrame:onClickClearTipAnywhereState(state, multiTextOptionElement)
    if state > self.clearTipAnywhereMaxState then
        multiTextOptionElement:setState(1)
        state = 1
    end

    local stateData = self.clearTipAnywhereStates[state]
    local areaElement = self.optionSliderClearTipAnywhereArea

    if stateData ~= nil then
        areaElement:setTexts(stateData.texts)
        areaElement:setState(stateData.lastState or 1)
        areaElement:setDisabled(self.clearTipAnywhereDisabled or stateData.disabled)
    end
end

function EasyDevControlsObjectsFrame:onClickClearTipAnywhereArea(state, optionSliderElement)
    self.clearTipAnywhereStates[self.multiClearTipAnywhereState.state].lastState = state
end

function EasyDevControlsObjectsFrame:onClickConfirmClearTipAnywhere(buttonElement)
    local fillTypeIndex = self.clearTipAnywhereFillTypes[self.multiClearTipAnywhereFillType.state]

    local stateIndex = self.multiClearTipAnywhereState:getState()
    local stateData = self.clearTipAnywhereStates[stateIndex]

    if fillTypeIndex ~= nil and stateData ~= nil then
        if stateIndex == EasyDevControlsClearHeightTypeEvent.TYPE_AREA then
            local radius = EasyDevControlsObjectsFrame.CLEAR_RADIUS[stateData.lastState] or 1
            local x, _, z, _, _, player = EasyDevControlsUtils.getPlayerWorldLocation()

            self:setInfoText(g_easyDevControls:clearHeightType(stateIndex, fillTypeIndex, x, z, radius, player.farmId))
        elseif stateIndex == EasyDevControlsClearHeightTypeEvent.TYPE_FARMLAND then
            -- To_Do: MessageDialog to give it time
            self:setInfoText(g_easyDevControls:clearHeightType(stateIndex, fillTypeIndex, stateData.lastState, 0, 1, g_localPlayer.farmId))
        elseif stateIndex == EasyDevControlsClearHeightTypeEvent.TYPE_MAP then
            -- To_Do: Popup warning message and MessageDialog to give it time
            self:setInfoText(g_easyDevControls:clearHeightType(stateIndex, fillTypeIndex, 0, 0, 1, g_localPlayer.farmId))
        end
    end
end

-- Show Tip Collisions
function EasyDevControlsObjectsFrame:onClickShowTipCollisions(state, binaryOptionElement)
    if g_server == nil then
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    DensityMapHeightManager.DEBUG_TIP_COLLISIONS = EasyDevControlsUtils.getIsCheckedState(state)

    local densityMapHeightManager = g_densityMapHeightManager

    if densityMapHeightManager.debugBitVectorMapTipCollisionsId ~= nil then
        g_debugManager:removeElementById(densityMapHeightManager.debugBitVectorMapTipCollisionsId)
        densityMapHeightManager.debugBitVectorMapTipCollisionsId = nil
    end

    local title = EasyDevControlsUtils.getText("easyDevControls_showTipCollisionsTitle")

    if DensityMapHeightManager.DEBUG_TIP_COLLISIONS then
        -- Disable 'DEBUG_PLACEMENT_COLLISIONS' so they do not conflict
        DensityMapHeightManager.DEBUG_PLACEMENT_COLLISIONS = true

        if densityMapHeightManager.debugBitVectorMapPlacementCollisionsId ~= nil then
            g_debugManager:removeElementById(densityMapHeightManager.debugBitVectorMapPlacementCollisionsId)
            densityMapHeightManager.debugBitVectorMapPlacementCollisionsId = nil
        end

        local debugBitVectorMapTipCollisions = g_densityMapHeightManager.debugBitVectorMapTipCollisions

        if debugBitVectorMapTipCollisions ~= nil then
            densityMapHeightManager.debugBitVectorMapTipCollisionsId = g_debugManager:addElement(debugBitVectorMapTipCollisions)

            self:setInfoText(string.format("%s: %s - %s", title, g_i18n:getText("ui_on"), EasyDevControlsUtils.getText("easyDevControls_showCollisionsInfo")))
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
            binaryOptionElement:setIsChecked(false, true, false)
        end
    else
        self:setInfoText(string.format("%s: %s", title, g_i18n:getText("ui_off")))
    end
end

-- Shared
function EasyDevControlsObjectsFrame:onConfirmRemoveAll(objectTypeId, buttonElement)
    if objectTypeId ~= nil then
        local function removeAllObjects(yes)
            if yes then
                if buttonElement ~= nil then
                    if buttonElement == self.buttonConfirmRemoveSplitShapes then
                        self.disableRemoveAllSplitShapes[self.multiRemoveSplitShapesTypes:getState()] = true
                    end

                    buttonElement:setDisabled(true)
                end

                self.intervalTimeRemaining = 1500
                self:setInfoText(g_easyDevControls:removeAllObjects(objectTypeId))
            else
                self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.CANCELLED)
            end
        end

        local text = EasyDevControlsUtils.formatText("easyDevControls_removeAllObjectsWarning", EasyDevControlsObjectTypes.getText(objectTypeId, 0, false))

        YesNoDialog.show(removeAllObjects, nil, text, "", g_i18n:getText("button_continue"), g_i18n:getText("button_cancel"))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsObjectsFrame.getNumObjectsAndLimitString(objectType)
    if g_currentMission == nil or objectType == nil then
        return EasyDevControlsUtils.getText("easyDevControls_unsupported")
    end

    if g_server and g_currentMission.slotSystem ~= nil then
        local objectLimits = g_currentMission.slotSystem.objectLimits[objectType]

        if objectLimits ~= nil then
            local numObjects = #objectLimits.objects or 0

            if objectLimits.limit == math.huge then
                if objectType == SlotSystem.LIMITED_OBJECT_BALE then
                    local _, numBaleObjects = EasyDevControlsUtils.getBaleObjectsFromObjectStorages()

                    numObjects = math.max(numObjects - numBaleObjects, 0) -- Remove the object storage objects from the count
                end

                return g_i18n:formatNumber(numObjects, 0)
            end

            return string.format("%s / %s", g_i18n:formatNumber(numObjects, 0), g_i18n:formatNumber(objectLimits.limit or 0, 0))
        end
    end

    local limitedObject = SlotSystem.NUM_OBJECT_LIMITS[objectType]
    local numObjects, limit = 0, limitedObject ~= nil and limitedObject[platformId] or math.huge

    if objectType == SlotSystem.LIMITED_OBJECT_BALE then
        local baleObjects = EasyDevControlsUtils.getBaleObjectsFromObjectStorages()

        for _, item in pairs(g_currentMission.itemSystem.itemsToSave) do
            local object = item.item

            if baleObjects[object] == nil and object.isa ~= nil and object:isa(Bale) then
                numObjects += 1
            end
        end
    elseif objectType == SlotSystem.LIMITED_OBJECT_PALLET then
        for _, vehicle in ipairs (g_currentMission.vehicleSystem.vehicles) do
            if vehicle.isa ~= nil and vehicle:isa(Vehicle) and vehicle.trainSystem == nil and vehicle.isPallet then
                numObjects += 1
            end
        end
    end

    if limit == math.huge then
        return g_i18n:formatNumber(numObjects, 0)
    end

    return string.format("%s / %s", g_i18n:formatNumber(numObjects, 0), g_i18n:formatNumber(limit, 0))
end
