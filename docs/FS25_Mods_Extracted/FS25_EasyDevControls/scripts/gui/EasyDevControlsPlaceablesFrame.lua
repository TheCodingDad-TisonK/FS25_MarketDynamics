--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-03

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

EasyDevControlsPlaceablesFrame = {}
EasyDevControlsPlaceablesFrame.NAME = "PLACEABLES"

EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_NPC = 1
EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_FARM = 2
EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_TRIGGER = 3

local EasyDevControlsPlaceablesFrame_mt = Class(EasyDevControlsPlaceablesFrame, EasyDevControlsBaseFrame)
local EMPTY_TABLE = {}

function EasyDevControlsPlaceablesFrame.register()
    local controller = EasyDevControlsPlaceablesFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsPlaceablesFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsPlaceablesFrame", controller, true)

    return controller
end

function EasyDevControlsPlaceablesFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(target, custom_mt or EasyDevControlsPlaceablesFrame_mt)

    self.pageName = EasyDevControlsPlaceablesFrame.NAME

    self.farmIDs = {}
    self.farmTexts = {}

    self.productionPointData = {}
    self.productionPointIndexTexts = {}
    self.productionPointTexts = {}
    self.productionPoints = {}

    self.availableProductionPoints = 0
    self.productionPointIndex = EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_NPC

    self:setCommandChangedCallback("tipToTrigger", EasyDevControlsPlaceablesFrame.onTipToTriggerCommandStateChanged)
    self:setCommandChangedCallback("productionPointsDebug", EasyDevControlsPlaceablesFrame.onDebugCommandStateChanged)
    self:setCommandChangedCallback("testAreasDebug", EasyDevControlsPlaceablesFrame.onDebugCommandStateChanged)

    return self
end

function EasyDevControlsPlaceablesFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsPlaceablesFrame.register()
end

function EasyDevControlsPlaceablesFrame:copyAttributes(src)
    EasyDevControlsPlaceablesFrame:superClass().copyAttributes(self, src)
end

function EasyDevControlsPlaceablesFrame:initialize()
    self.noneText = g_i18n:getText("character_option_none")
    self.allText = EasyDevControlsUtils.getText("easyDevControls_all")
    self.maximumText = EasyDevControlsUtils.getText("easyDevControls_maximum")
    self.placeholderText = EasyDevControlsUtils.getText("easyDevControls_placeholderEnterAmount")

    self.isServer = g_server ~= nil
    self.isMultiplayer = g_easyDevControls:getIsMultiplayer()

    self.multiTipToTriggerState:setTexts({
        EasyDevControlsUtils.getText("easyDevControls_fill"),
        EasyDevControlsUtils.getText("easyDevControls_add") -- Not possible to Set at this stage.. It is 'Tip To Trigger' not 'Remove from Trigger' so you know...
    })
end

function EasyDevControlsPlaceablesFrame:onFrameOpening()
    -- Maybe for MP but not really needed
    -- g_messageCenter:subscribe(SellPlaceableEvent, self.onSellPlaceable, self)
    -- g_messageCenter:subscribe(BuyPlaceableEvent, self.onBuyPlaceable, self)
    -- g_messageCenter:subscribe(BuyExistingPlaceableEvent, self.onBuyExistingPlaceable, self)

    g_messageCenter:subscribe(MessageType.EDC_PRODUCTIONS_CHANGED, self.onProductionsChanged, self)
    g_messageCenter:subscribe(MessageType.FARM_CREATED, self.onFarmCreated, self)
    g_messageCenter:subscribe(MessageType.FARM_DELETED, self.onFarmDeleted, self)
end

function EasyDevControlsPlaceablesFrame:onUpdateCommands(resetToDefault)
    self:collectFarmsInfo()

    -- Production Point
    local productionPointsDisabled = not self:getHasPermission("productionPoints")

    self.multiSetProductionPoint:setDisabled(productionPointsDisabled)
    self.buttonSetProductionPointOwner:setDisabled(productionPointsDisabled)
    self.buttonSetProductionPointState:setDisabled(productionPointsDisabled)
    self.buttonSetProductionPointOutput:setDisabled(productionPointsDisabled)
    self.buttonSetProductionPointFillLevel:setDisabled(productionPointsDisabled)

    self.productionPointsDisabled = productionPointsDisabled
    self:initProductionPointsInfo() -- TO_DO: (FS22 Note so may be done but check) Need to update this when any production changes owner??

    -- Tip To Trigger
    self:onTipToTriggerCommandStateChanged("tipToTrigger", resetToDefault)

    -- Reload All Placeables
    local closestPlaceable
    local placeableName = ""
    local reloadPlaceableDisabled = true
    local reloadAllPlaceablesDisabled = true

    if not self.isMultiplayer then
        local lastDistance  = math.huge
        local placeableSystem = g_currentMission.placeableSystem
        local rootNode = g_localPlayer ~= nil and g_localPlayer:getCurrentRootNode() or nil

        if rootNode ~= nil and placeableSystem ~= nil then
            for _, placeable in ipairs(placeableSystem.placeables) do
                if not placeable.isPreplaced and (placeable.spec_trainSystem == nil and placeable.spec_riceField == nil) and placeable.rootNode ~= nil then
                    local distance = calcDistanceFrom(placeable.rootNode, rootNode)

                    if distance < 30 and distance < lastDistance then
                        lastDistance = distance
                        closestPlaceable = placeable
                    end
                end
            end

            if closestPlaceable ~= nil then
                reloadPlaceableDisabled = false
                placeableName = closestPlaceable:getName()
            end
        end

        reloadAllPlaceablesDisabled = false
    end

    placeableName = EasyDevControlsUtils.formatText("easyDevControls_reloadPlaceableTitle", not string.isNilOrWhitespace(placeableName) and placeableName or self.noneText)
    self.closestPlaceable = closestPlaceable

    self.buttonConfirmReloadPlaceableTitle:setText(placeableName)
    self.buttonConfirmReloadPlaceable:setDisabled(reloadPlaceableDisabled)
    self.buttonConfirmReloadAllPlaceables:setDisabled(reloadAllPlaceablesDisabled)

    -- Remove All Placeables / Map Placeables
    self.buttonConfirmRemoveAllPlaceables:setDisabled(self.isMultiplayer)
    self.buttonConfirmRemoveAllMapPlaceables:setDisabled(self.isMultiplayer)

    -- Production Point Debug
    self:onDebugCommandStateChanged("productionPointsDebug", resetToDefault)

    -- Show Placeable Test Areas
    self:onDebugCommandStateChanged("testAreasDebug", resetToDefault)

    -- Show Placement Collisions (Server Only)
    local showPlacementCollisions = DensityMapHeightManager.DEBUG_PLACEMENT_COLLISIONS

    if showPlacementCollisions then
        local elementToElementId = g_debugManager.elementToElementId
        local densityMapHeightManager = g_densityMapHeightManager

        -- Maybe handle with EasyDevControlsDebugManager?
        if elementToElementId ~= nil and elementToElementId[densityMapHeightManager.debugBitVectorMapPlacementCollisions] == nil then
            if densityMapHeightManager.debugBitVectorMapPlacementCollisionsId ~= nil then
                g_debugManager:removeElementById(densityMapHeightManager.debugBitVectorMapPlacementCollisionsId)
                densityMapHeightManager.debugBitVectorMapPlacementCollisionsId = nil
            end

            DensityMapHeightManager.DEBUG_PLACEMENT_COLLISIONS = false
            showPlacementCollisions = false
        end
    end

    self.binaryShowPlacementCollisions:setIsChecked(showPlacementCollisions, self.isOpening, false)
    self.binaryShowPlacementCollisions:setDisabled(g_server == nil)
end

-- Production Point
function EasyDevControlsPlaceablesFrame:onClickSetProductionPoint(state, multiTextOptionElement)
    local productionPoints = self.productionPoints[state] or EMPTY_TABLE
    local disabled = self.productionPointsDisabled or #productionPoints == 0

    self.currentProductionPoints = productionPoints
    self.productionPointIndex = state

    self.buttonSetProductionPointOwner:setDisabled(disabled)
    self.buttonSetProductionPointState:setDisabled(disabled)
    self.buttonSetProductionPointOutput:setDisabled(disabled)
    self.buttonSetProductionPointFillLevel:setDisabled(disabled)
end

function EasyDevControlsPlaceablesFrame:onClickSetProductionPointData(buttonElement)
    if buttonElement.name ~= nil then
        local dialogData = self:updateProductionPointsData(buttonElement.name)

        if dialogData ~= nil then
            self.productionPointDialog = EasyDevControlsDynamicSelectionDialog.show(dialogData.headerText, dialogData.properties, dialogData.callback, dialogData.target, dialogData.numRows, dialogData.flowDirection, nil, false, self, nil, dialogData.confirmButtonDisabled)

            return
        end
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
end

function EasyDevControlsPlaceablesFrame:initProductionPointsInfo(setProductionPoint)
    local activatableObjectsSystem = g_currentMission.activatableObjectsSystem

    local productionChainManager = g_currentMission.productionChainManager
    local numberOfProductionPoints = productionChainManager:getNumOfProductionPoints()

    local playerFarmId = g_currentMission:getFarmId()
    local availableProductionPoints = 0

    self.productionPointIndexTexts = {}
    self.productionPointTexts = {}
    self.productionPoints = {}

    -- ToDo: Add support for farmland productions (ID 15 / buyWithFarmland)
    if playerFarmId ~= FarmManager.SPECTATOR_FARM_ID and numberOfProductionPoints > 0 then
        self.productionPoints[1] = {}
        self.productionPoints[2] = {}
        self.productionPoints[3] = EMPTY_TABLE

        self.productionPointTexts[1] = EasyDevControlsUtils.getText("easyDevControls_npcOwned")
        self.productionPointTexts[2] = EasyDevControlsUtils.getText("easyDevControls_farmOwned")
        self.productionPointTexts[3] = EasyDevControlsUtils.getText("easyDevControls_currentTrigger")

        for i = 1, numberOfProductionPoints do
            local productionPoint = productionChainManager.productionPoints[i]

            if productionPoint ~= nil then
                local farmId = productionPoint:getOwnerFarmId()

                local npcOwned = farmId == FarmManager.SPECTATOR_FARM_ID
                local playerOwned = farmId == playerFarmId
                local indexText = string.format("PP %i", i)

                if npcOwned or playerOwned then
                    if npcOwned then
                        table.insert(self.productionPoints[1], productionPoint)
                    end

                    if playerOwned then
                        table.insert(self.productionPoints[2], productionPoint)
                    end

                    if activatableObjectsSystem.currentActivatableObject == productionPoint.activatable then
                        self.productionPoints[3] = {productionPoint}
                    end

                    table.insert(self.productionPoints, {productionPoint})
                    table.insert(self.productionPointTexts, indexText)

                    if productionPoint == setProductionPoint then
                        self.productionPointIndex = #self.productionPoints
                    end

                    availableProductionPoints = availableProductionPoints + 1
                end

                self.productionPointIndexTexts[productionPoint] = indexText
            end
        end
    end

    if availableProductionPoints == 0 then
        self.productionPointTexts[1] = self.noneText
    end

    self.multiSetProductionPoint:setTexts(self.productionPointTexts)

    if availableProductionPoints ~= self.availableProductionPoints then
        self.productionPointIndex = 1
    end

    self.multiSetProductionPoint:setState(self.productionPointIndex, true)
    self.availableProductionPoints = availableProductionPoints
end

function EasyDevControlsPlaceablesFrame:initProductionPointData()
    self.productionPointData.productionPointOwner = {
        headerText = "",
        numRows = 1,
        flowDirection = BoxLayoutElement.FLOW_VERTICAL,
        properties = {
            {
                title = EasyDevControlsUtils.getText("easyDevControls_setOwnerTitle"),
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                name = "productionPointOwner",
                dynamicId = "multiOwnerElement",
                texts = self.farmTexts
            }
        },
        callback = function(confirm, callbackValues)
            if confirm and callbackValues ~= nil then
                local farmName = "NPC"
                local numUpdated = 0
                local setProductionPoint = nil

                local pushLastChange = self.productionPointIndex > EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_TRIGGER
                local farmId = self.farmIDs[callbackValues["productionPointOwner"]]

                if farmId ~= nil then
                    local farm = g_farmManager.farmIdToFarm[farmId]

                    if farm ~= nil then
                        for _, productionPoint in ipairs(self.currentProductionPoints) do
                            if productionPoint.owningPlaceable ~= nil then
                                if self.isServer then
                                    productionPoint.owningPlaceable:setOwnerFarmId(farmId)
                                else
                                    productionPoint.owningPlaceable:setOwnerFarmId(farmId, true)

                                    -- Request server update for all clients
                                    g_client:getServerConnection():sendEvent(EasyDevControlsObjectFarmChangeEvent.new(productionPoint.owningPlaceable, farmId))
                                end

                                if pushLastChange then
                                    setProductionPoint = productionPoint
                                end

                                if productionPoint.activatable ~= nil and productionPoint.activatable.updateText ~= nil then
                                    productionPoint.activatable:updateText() -- update buy / manage text
                                end

                                numUpdated = numUpdated + 1
                            end
                        end

                        if farmId ~= FarmManager.SPECTATOR_FARM_ID then
                            farmName = farm.name
                        end
                    end
                end

                if numUpdated > 0 then
                    local typeText = EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.PRODUCTION_POINT, numUpdated)

                    self:initProductionPointsInfo(setProductionPoint)
                    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_productionPointOwnerInfo", tostring(numUpdated), typeText, farmName, tostring(farmId)))
                else
                    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
                end
            end
        end
    }

    self.productionPointData.productionPointState = {
        headerText = "",
        numRows = 1,
        flowDirection = BoxLayoutElement.FLOW_VERTICAL,
        confirmButtonDisabled = true,
        variableIDs = {},
        lastSetIndexs = {},
        disabledIndexs = {},
        properties = {
            {
                title = EasyDevControlsUtils.getText("easyDevControls_setStateTitle"),
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                name = "productionPointMultiInputType",
                dynamicId = "multiInputTypeElement",
                disabled = false,
                forceState = true,
                lastIndex = 1,
                onClickCallback = function(dialog, index, element, isLeft, property)
                    local data = self.productionPointData.productionPointState
                    local indexToSet = data.lastSetIndexs[index] or 1

                    if indexToSet ~= BinaryOptionElement.STATE_LEFT and indexToSet ~= BinaryOptionElement.STATE_RIGHT then
                        indexToSet = BinaryOptionElement.STATE_LEFT
                    end

                    dialog.binaryStateElement:setState(indexToSet, true)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                profile = "edc_dynamicSelectionBinaryOptionClose",
                name = "productionPointMultiState",
                dynamicId = "binaryStateElement",
                disabled = false,
                lastIndex = 1,
                onClickCallback = function(dialog, index, element, isLeft, property)
                    local multiTypeLastIndex = dialog.multiInputTypeElement.lastIndex

                    if multiTypeLastIndex > 1 then
                        local data = self.productionPointData.productionPointState
                        local disabledIndex = data.disabledIndexs[multiTypeLastIndex] or 0

                        data.lastSetIndexs[multiTypeLastIndex] = index
                        dialog.buttonConfirmStateElement:setDisabled(disabledIndex == index)
                    else
                        local elementDisabled = false
                        local numEnabled, numDisabled = 0, 0

                        if self.currentProductionPoints ~= nil then
                            for _, productionPoint in ipairs(self.currentProductionPoints) do
                                for _, production in pairs(productionPoint.productions) do
                                    if productionPoint:getIsProductionEnabled(production.id) then
                                        numEnabled += 1
                                    else
                                        numDisabled += 1
                                    end
                                end
                            end

                            if numEnabled > 0 and numDisabled == 0 then
                                elementDisabled = index == BinaryOptionElement.STATE_RIGHT
                            elseif numDisabled > 0 and numEnabled == 0 then
                                elementDisabled = index == BinaryOptionElement.STATE_LEFT
                            end
                        end

                        dialog.buttonConfirmStateElement:setDisabled(elementDisabled)
                    end
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BUTTON,
                profile = "edc_dynamicSelectionButtonClose",
                name = "productionPointButtonConfirmState",
                dynamicId = "buttonConfirmStateElement",
                disabled = false,
                onClickCallback = function(dialog, element, property)
                    local numUpdated = 0

                    local multiTypeIndex = dialog.multiInputTypeElement:getState()
                    local multiStateIndex = dialog.binaryStateElement:getState()

                    local data = self.productionPointData.productionPointState
                    local state = multiStateIndex == BinaryOptionElement.STATE_RIGHT

                    if multiTypeIndex > 1 then
                        local productionId = data.variableIDs[multiTypeIndex]

                        if productionId ~= nil then
                            for _, productionPoint in pairs(self.currentProductionPoints) do
                                productionPoint:setProductionState(productionId, state, false)
                            end

                            numUpdated = numUpdated + 1
                        end
                    else
                        for _, productionPoint in ipairs(self.currentProductionPoints) do
                            for _, production in pairs(productionPoint.productions) do
                                productionPoint:setProductionState(production.id, state, false)

                                numUpdated = numUpdated + 1
                            end
                        end
                    end

                    if numUpdated > 0 then
                        local stateText = EasyDevControlsUtils.getStateText(state, false) or ""
                        local typeText = EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.PRODUCTION, numUpdated)

                        if multiTypeIndex > 1 then
                            local synced = true

                            data.disabledIndexs[multiTypeIndex] = multiStateIndex

                            for index, stateIndex in pairs (data.disabledIndexs) do
                                if index > 1 and stateIndex ~= multiStateIndex then
                                    data.disabledIndexs[1] = 0
                                    synced = false

                                    break
                                end
                            end

                            if synced then
                                data.disabledIndexs[1] = multiStateIndex
                            end
                        else
                            for index, _ in pairs (data.disabledIndexs) do
                                data.disabledIndexs[index] = multiStateIndex
                            end
                        end

                        element:setDisabled(true)

                        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_productionPointStateInfo", tostring(numUpdated), typeText, stateText:upper()))
                    else
                        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
                    end
                end
            }
        }
    }

    self.productionPointData.productionPointOutputMode = {
        headerText = "",
        numRows = 1,
        flowDirection = BoxLayoutElement.FLOW_VERTICAL,
        confirmButtonDisabled = true,
        variableIDs = {},
        lastSetIndexs = {},
        disabledIndexs = {},
        properties = {
            {
                title = EasyDevControlsUtils.getText("easyDevControls_outputModeTitle"),
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                name = "productionPointMultiOutputType",
                dynamicId = "multiOutputTypeElement",
                disabled = false,
                forceState = true,
                lastIndex = 1,
                onClickCallback = function(dialog, index, element, isLeft, property)
                    local data = self.productionPointData.productionPointOutputMode
                    local indexToSet = data.lastSetIndexs[index] or 1

                    dialog.multiOutputModeElement:setState(indexToSet, true)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                texts = {
                    g_i18n:getText("ui_production_output_storing"),
                    g_i18n:getText("ui_production_output_selling"),
                    g_i18n:getText("ui_production_output_distributing")
                },
                profile = "edc_dynamicSelectionMultiTextOptionClose",
                name = "productionPointMultiOutputMode",
                dynamicId = "multiOutputModeElement",
                lastIndex = 1,
                onClickCallback = function(dialog, index, element, isLeft, property)
                    local data = self.productionPointData.productionPointOutputMode
                    local multiTypeLastIndex = dialog.multiOutputTypeElement.lastIndex
                    local disabledIndex = data.disabledIndexs[multiTypeLastIndex] or 0

                    data.lastSetIndexs[multiTypeLastIndex] = index
                    dialog.buttonConfirmOutputElement:setDisabled(disabledIndex == index)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BUTTON,
                profile = "edc_dynamicSelectionButtonClose",
                name = "productionPointButtonConfirmOutput",
                dynamicId = "buttonConfirmOutputElement",
                disabled = false,
                onClickCallback = function(dialog, element, property)
                    local numUpdated = 0

                    local multiTypeIndex = dialog.multiOutputTypeElement:getState()
                    local multiModeIndex = dialog.multiOutputModeElement:getState()

                    local data = self.productionPointData.productionPointOutputMode
                    local distributionMode = multiModeIndex - 1

                    if multiTypeIndex > 1 then
                        local outputFillTypeId = data.variableIDs[multiTypeIndex]

                        if outputFillTypeId ~= nil then
                            for _, productionPoint in pairs(self.currentProductionPoints) do
                                if productionPoint.outputFillTypeIds[outputFillTypeId] ~= nil then
                                    productionPoint:setOutputDistributionMode(outputFillTypeId, distributionMode)

                                    numUpdated = numUpdated + 1
                                end
                            end
                        end
                    else
                        for _, productionPoint in ipairs(self.currentProductionPoints) do
                            for outputFillTypeId in pairs(productionPoint.outputFillTypeIds) do
                                productionPoint:setOutputDistributionMode(outputFillTypeId, distributionMode)

                                numUpdated = numUpdated + 1
                            end
                        end
                    end

                    if numUpdated > 0 then
                    local typeText = EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.PRODUCTION, numUpdated)
                        local l10n = "ui_production_output_storing"

                        if distributionMode == ProductionPoint.OUTPUT_MODE.DIRECT_SELL then
                            l10n = "ui_production_output_selling"
                        elseif distributionMode == ProductionPoint.OUTPUT_MODE.AUTO_DELIVER then
                            l10n = "ui_production_output_distributing"
                        end

                        if multiTypeIndex > 1 then
                            local synced = true

                            data.disabledIndexs[multiTypeIndex] = multiModeIndex

                            for index, stateIndex in pairs (data.disabledIndexs) do
                                if index > 1 and stateIndex ~= multiModeIndex then
                                    data.disabledIndexs[1] = 0
                                    synced = false

                                    break
                                end
                            end

                            if synced then
                                data.disabledIndexs[1] = multiModeIndex
                            end
                        else
                            for index, _ in pairs (data.disabledIndexs) do
                                data.disabledIndexs[index] = multiModeIndex
                            end
                        end

                        element:setDisabled(true)

                        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_productionPointDistributionInfo", tostring(numUpdated), typeText, g_i18n:getText(l10n)))
                    else
                        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
                    end
                end
            }
        }
    }

    self.productionPointData.productionPointFillLevel = {
        headerText = "",
        confirmButtonDisabled = true,
        flowDirection = BoxLayoutElement.FLOW_VERTICAL,
        numRows = 1,
        types = {
            "inputFillTypeIds",
            "outputFillTypeIds"
        },
        fillTypes = {},
        fillTypeTexts = {},
        lastSetIndexs = {},
        inputTypeIndex = 1,
        maxFillLevels = {},
        maxFillLevelTexts = {},
        properties = {
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_fillLevelTitle"),
                name = "productionPointMultiFillLevelMode",
                dynamicId = "multiFillLevelModeElement",
                forceState = true,
                texts = {
                    EasyDevControlsUtils.getText("easyDevControls_input"),
                    EasyDevControlsUtils.getText("easyDevControls_output")
                },
                onClickCallback = function(dialog, index, element, isLeft, property)
                    local data = self.productionPointData.productionPointFillLevel
                    local indexToSet = data.lastSetIndexs[index] or 1

                    dialog.multiFillLevelFillTypeElement:setTexts(data.fillTypeTexts[index])
                    dialog.multiFillLevelFillTypeElement:setState(1)

                    dialog.multiFillLevelStateElement:setState(indexToSet, true)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                profile = "edc_dynamicSelectionMultiTextOptionClose",
                name = "productionPointMultiFillLevelFillType",
                dynamicId = "multiFillLevelFillTypeElement",
                disabled = false,
                onClickCallback = function(dialog, index, element, isLeft, property)
                    dialog.multiFillLevelStateElement:setState(dialog.multiFillLevelStateElement:getState(), true)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                profile = "edc_dynamicSelectionMultiTextOptionClose",
                name = "productionPointMultiFillLevelState",
                dynamicId = "multiFillLevelStateElement",
                texts = {
                    EasyDevControlsUtils.getText("easyDevControls_fill"),
                    EasyDevControlsUtils.getText("easyDevControls_empty"),
                    EasyDevControlsUtils.getText("easyDevControls_set"),

                },
                onClickCallback = function(dialog, index, element, isLeft, property)
                    local data = self.productionPointData.productionPointFillLevel
                    local textInputElement = dialog.textInputAmountElement

                    if index == 1 then
                        local placeholderText = "100 %"

                        if data.inputTypeIndex == 1 then
                            local modeState = dialog.multiFillLevelModeElement:getState()
                            local fillTypeState = dialog.multiFillLevelFillTypeElement:getState()

                            placeholderText = data.maxFillLevelTexts[modeState][fillTypeState]

                            if placeholderText == nil then
                                placeholderText = "Maximum"
                            end

                            placeholderText = tostring(placeholderText)
                        end

                        textInputElement.maxCharacters = 10
                        textInputElement:setPlaceholderText(placeholderText)

                        textInputElement.lastValidText = ""
                        textInputElement:setText("")
                    elseif index == 2 then
                        textInputElement.maxCharacters = 10
                        textInputElement:setPlaceholderText(data.inputTypeIndex == 1 and "0" or "0 %")

                        textInputElement.lastValidText = ""
                        textInputElement:setText("")
                    else
                        if dialog.multiFillLevelFillTypeElement:getState() > 1 then
                            if data.inputTypeIndex == 1 then
                                textInputElement.maxCharacters = 10
                            else
                                textInputElement.maxCharacters = 3
                            end

                            textInputElement:setPlaceholderText(self.placeholderText)

                            textInputElement.lastValidText = ""
                            textInputElement:setText("")
                        else
                            element:setState(isLeft and 2 or 1, true)

                            return
                        end
                    end

                    textInputElement:setDisabled(index < 3)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                profile = "edc_dynamicSelectionMultiTextOptionClose",
                name = "productionPointMultiInputType",
                dynamicId = "multiFillInputTypeElement",
                texts = {
                    EasyDevControlsUtils.getText("easyDevControls_unitLitres"),
                    EasyDevControlsUtils.getText("easyDevControls_unitPercent")
                },
                onClickCallback = function(dialog, index, element, isLeft, property)
                    self.productionPointData.productionPointFillLevel.inputTypeIndex = index
                    dialog.multiFillLevelStateElement:setState(dialog.multiFillLevelStateElement:getState(), true)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_TEXT_INPUT,
                profile = "edc_dynamicSelectionTextInputClose",
                name = "productionPointTextInputAmount",
                dynamicId = "textInputAmountElement",
                placeholderVisibleOnDisable = true,
                placeholderVisible = true,
                maxCharacters = 10
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BUTTON,
                profile = "edc_dynamicSelectionButtonClose",
                name = "productionPointButtonConfirmFillLevel",
                dynamicId = "buttonConfirmFillLevelElement",
                onClickCallback = function(dialog, element, property)
                    local stateIndex = dialog.multiFillLevelStateElement:getState()
                    local modeIndex = dialog.multiFillLevelModeElement:getState()
                    local isOutput = modeIndex == 2
                    local fillLevel

                    if stateIndex == 1 then
                        fillLevel = 1e+7
                    elseif stateIndex == 2 then
                        fillLevel = 0
                    else
                        fillLevel = tonumber(dialog.textInputAmountElement.text or "")

                        if fillLevel == nil then
                            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidValueWarning"), EasyDevControlsErrorCodes.FAILED)
                        end

                        dialog.textInputAmountElement:setText("")
                        dialog.textInputAmountElement.lastValidText = ""
                    end

                    if fillLevel ~= nil then
                        local fillTypeStateIndex = dialog.multiFillLevelFillTypeElement:getState()
                        local data = self.productionPointData.productionPointFillLevel
                        local variableName = data.types[modeIndex]

                        if fillTypeStateIndex > 1 then
                            local productionPoint = self.currentProductionPoints[1]
                            local fillTypeIndex = data.fillTypes[modeIndex][fillTypeStateIndex]

                            if productionPoint ~= nil and (productionPoint[variableName] ~= nil and productionPoint[variableName][fillTypeIndex] ~= nil) then
                                local capacity = productionPoint:getCapacity(fillTypeIndex)

                                if data.inputTypeIndex == 1 then
                                    fillLevel = math.max(math.min(fillLevel, capacity), 0)
                                else
                                    fillLevel = capacity * (fillLevel / 100)
                                end

                                if fillLevel == capacity then
                                    fillLevel = fillLevel + 1
                                end

                                self:setInfoText(g_easyDevControls:setProductionPointFillLevels(productionPoint, fillLevel, fillTypeIndex, isOutput, false))
                            else
                                self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
                            end
                        else
                            local numUpdated = 0

                            for _, productionPoint in ipairs(self.currentProductionPoints) do
                                if g_easyDevControls:setProductionPointFillLevels(productionPoint, fillLevel, nil, isOutput, true) then
                                    numUpdated = numUpdated + 1
                                end
                            end

                            if self.isServer then
                                local modeL10N = isOutput and "easyDevControls_output" or "easyDevControls_input"
                                local typeText = EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.PRODUCTION_POINT, numUpdated)

                                self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_productionPointFillLevelAllInfo", EasyDevControlsUtils.getText(modeL10N):lower(), tostring(numUpdated), typeText))
                            else
                                self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_serverRequestMessage"), EasyDevControlsErrorCodes.FAILED)
                            end
                        end
                    end
                end
            }
        }
    }
end

function EasyDevControlsPlaceablesFrame:updateProductionPointsData(dataName)
    local ppData = self.productionPointData

    if ppData.productionPointOwner == nil or ppData.productionPointState == nil or ppData.productionPointOutputMode == nil or ppData.productionPointFillLevel == nil then
        self:initProductionPointData()
    end

    if dataName ~= nil then
        local data = self.productionPointData[dataName]

        if data ~= nil and self.currentProductionPoints ~= nil then
            local headerText = ""
            local productionPoint
            local currentIndex = self.productionPointIndex

            if currentIndex == EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_NPC then
                headerText = string.format("%s %s", EasyDevControlsUtils.getText("easyDevControls_all"), EasyDevControlsUtils.getText("easyDevControls_npcOwned"))
            elseif currentIndex == EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_FARM then
                headerText = string.format("%s %s", EasyDevControlsUtils.getText("easyDevControls_all"), EasyDevControlsUtils.getText("easyDevControls_farmOwned"))
            else
                productionPoint = self.currentProductionPoints[1]

                if productionPoint == nil then
                    return nil
                end

                headerText = productionPoint:getName() or g_fillTypeManager:getFillTypeTitleByIndex(productionPoint.primaryProductFillType)
            end

            data.headerText = headerText

            if dataName == "productionPointOwner" then
                local numFarms = #g_farmManager.farms
                local lastIndex = 1

                if #self.farmIDs ~= numFarms or #self.farmTexts ~= numFarms then
                    self:collectFarmsInfo()
                end

                if currentIndex > EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_NPC then
                    local farmId = FarmManager.SPECTATOR_FARM_ID

                    if currentIndex == EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_FARM then
                        farmId = g_currentMission:getFarmId() or farmId
                    else
                        farmId = productionPoint:getOwnerFarmId() or farmId
                    end

                    for index, id in ipairs (self.farmIDs) do
                        if id == farmId then
                            lastIndex = index

                            break
                        end
                    end
                end

                data.properties[1].texts = self.farmTexts
                data.properties[1].lastIndex = lastIndex
            elseif (dataName == "productionPointState") or (dataName == "productionPointOutputMode") then
                local isOuputMode = dataName == "productionPointOutputMode"

                local firstIndex
                local synced = true

                local variableIDs = {
                    EMPTY_TABLE
                }

                local texts = {
                    EasyDevControlsUtils.getText("easyDevControls_all")
                }

                local lastSetIndexs = {
                    0
                }

                local disabledIndexs = {
                    0
                }

                for _, pp in ipairs(self.currentProductionPoints) do
                    if isOuputMode then
                        for outputFillTypeIndex in pairs(pp.outputFillTypeIds) do
                            local distributionMode = pp:getOutputDistributionMode(outputFillTypeIndex) + 1

                            if firstIndex == nil then
                                firstIndex = distributionMode
                            else
                                if firstIndex ~= distributionMode then
                                    synced = false
                                end
                            end

                            if currentIndex > EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_FARM then
                                local fillType = g_fillTypeManager:getFillTypeByIndex(outputFillTypeIndex)

                                table.insert(variableIDs, outputFillTypeIndex)
                                table.insert(texts, fillType.title)

                                table.insert(lastSetIndexs, distributionMode)
                                table.insert(disabledIndexs, distributionMode)
                            end
                        end
                    else
                        for _, production in pairs(pp.productions) do
                            local statusIndex = pp:getIsProductionEnabled(production.id) and 2 or 1

                            if firstIndex == nil then
                                firstIndex = statusIndex
                            else
                                if firstIndex ~= statusIndex then
                                    synced = false
                                end
                            end

                            if currentIndex > EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_FARM then
                                table.insert(variableIDs, production.id)
                                table.insert(texts, production.name or "Unknown Name")

                                table.insert(lastSetIndexs, statusIndex)
                                table.insert(disabledIndexs, statusIndex)
                            end
                        end
                    end
                end

                if synced and firstIndex ~= nil then
                    lastSetIndexs[1] = firstIndex
                    disabledIndexs[1] = firstIndex
                end

                data.properties[1].texts = texts
                data.properties[1].disabled = currentIndex < EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_TRIGGER

                data.variableIDs = variableIDs
                data.lastSetIndexs = lastSetIndexs
                data.disabledIndexs = disabledIndexs
            elseif dataName == "productionPointFillLevel" then
                local disabled = true

                local fillTypes = {
                    {
                        EMPTY_TABLE
                    },
                    {
                        EMPTY_TABLE
                    }
                }

                local fillTypeTexts = {
                    {
                        self.allText
                    },
                    {
                        self.allText
                    }
                }

                local maxFillLevels = {
                    {
                        1e+7
                    },
                    {
                        1e+7
                    }
                }

                local maxFillLevelTexts = {
                    {
                        self.maximumText
                    },
                    {
                        self.maximumText
                    }
                }

                if currentIndex > EasyDevControlsPlaceablesFrame.PRODUCTION_POINT_ALL_FARM then
                    for _, pp in ipairs(self.currentProductionPoints) do
                        for i, typeName in ipairs (data.types) do
                            local variable = pp[typeName]

                            if variable ~= nil then
                                for fillTypeIndex in pairs(variable) do
                                    local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
                                    local capacity, capacityText = 0, ""

                                    if i == 1 then
                                        for _, targetStorage in pairs(pp.unloadingStation.targetStorages) do
                                            if targetStorage:getIsFillTypeSupported(fillTypeIndex) then
                                                local storageCapacity = targetStorage:getCapacity(fillTypeIndex)

                                                if storageCapacity ~= nil then
                                                    capacity = capacity + storageCapacity
                                                end
                                            end
                                        end
                                    else
                                        capacity = pp.storage:getCapacity(fillTypeIndex) or 0
                                    end

                                    if capacity == 0 then
                                        capacity = 1e+7
                                        capacityText = self.maximumText
                                    else
                                        capacityText = g_i18n:formatFluid(capacity)
                                    end

                                    table.insert(fillTypes[i], fillTypeIndex)
                                    table.insert(fillTypeTexts[i], fillType.title)

                                    table.insert(maxFillLevels[i], capacity)
                                    table.insert(maxFillLevelTexts[i], capacityText)

                                    disabled = false
                                end
                            end
                        end
                    end
                end

                data.properties[2].disabled = disabled

                for i = 1, #data.properties do
                    data.properties[i].lastIndex = 1
                end

                data.fillTypes = fillTypes
                data.fillTypeTexts = fillTypeTexts

                data.lastSetIndexs = {}
                data.inputTypeIndex = 1

                data.maxFillLevels = maxFillLevels
                data.maxFillLevelTexts = maxFillLevelTexts
            end

            return data
        end
    end

    return nil
end

-- Production Points List
function EasyDevControlsPlaceablesFrame:onClickProductionPointsList(buttonElement)
    local headerText = EasyDevControlsUtils.getText("easyDevControls_productionPointListTitle")
    local list = {}

    if #self.productionPoints > 3 then
        local infoText = "  - %s:  %i / %i\n  - %s:  %s (%i)\n  - %s:  %s\n  - %s:  %s\n  - %s:  %s"

        local activeText = EasyDevControlsUtils.getText("easyDevControls_activeProductions")
        local ownerText = EasyDevControlsUtils.getText("easyDevControls_owner")
        local priceText = EasyDevControlsUtils.getText("easyDevControls_price")
        local locationText = EasyDevControlsUtils.getText("easyDevControls_location")
        local tableIdText = EasyDevControlsUtils.getText("easyDevControls_tableId")

        local farm = g_farmManager.farmIdToFarm[g_currentMission:getFarmId()]

        for i = 4, #self.productionPoints do
            local pp = self.productionPoints[i][1]

            if pp ~= nil then
                local owningPlaceable = pp.owningPlaceable
                local location = EasyDevControlsUtils.getObjectLocationString(owningPlaceable.rootNode, owningPlaceable)
                local idString = self.productionPointIndexTexts[pp] or "PP xx"
                local ownerName = "NPC"
                local price = 0

                if pp.ownerFarmId ~= FarmManager.SPECTATOR_FARM_ID then
                    ownerName = farm ~= nil and farm.name or "N/A"

                    price = owningPlaceable:getSellPrice()
                else
                    local storeItem = g_storeManager:getItemByXMLFilename(owningPlaceable.configFileName)

                    price = g_currentMission.economyManager:getBuyPrice(storeItem) or owningPlaceable:getPrice()

                    if owningPlaceable.buysFarmland and owningPlaceable.farmlandId ~= nil then
                        local farmland = g_farmlandManager:getFarmlandById(owningPlaceable.farmlandId)

                        if farmland ~= nil and g_farmlandManager:getFarmlandOwner(owningPlaceable.farmlandId) ~= g_currentMission:getFarmId() then
                            price = price + farmland.price
                        end
                    end
                end

                price = g_i18n:formatMoney(price, 0, true, true)

                table.insert(list, {
                    overlayColour = EasyDevControlsGuiManager.OVERLAY_COLOUR,
                    title = string.format("%s  | %s", idString, pp:getName()),
                    text = string.format(infoText, activeText, #pp.activeProductions, #pp.productions, ownerText, ownerName, pp.ownerFarmId, priceText, price, locationText, location, tableIdText, pp:tableId())
                })
            end
        end
    end

    EasyDevControlsDynamicListDialog.show(headerText, list)
end

-- Delivery Mapping
function EasyDevControlsPlaceablesFrame:onClickAutoDeliverMapping(buttonElement)
    local headerText = EasyDevControlsUtils.getText("easyDevControls_deliveryMappingTitle")
    local list = {}

    local farmId = g_currentMission:getFarmId()
    local farmProductionChains = g_currentMission.productionChainManager.farmIds[farmId]

    if farmProductionChains ~= nil and farmProductionChains.inputTypeToProductionPoints ~= nil then
        local transferCostText = EasyDevControlsUtils.getText("easyDevControls_transferCost")
        local tableIdText = EasyDevControlsUtils.getText("easyDevControls_tableId")
        local receivingText = "%s\n        - %s  |  %s\n            - %s / 1000 l:  %s\n            - %s:  %s"

        for i = 4, #self.productionPoints do
            local productionPoint = self.productionPoints[i][1]

            if productionPoint and productionPoint.ownerFarmId == farmId then
                local text = ""

                for fillTypeIndex in pairs (productionPoint.outputFillTypeIds) do
                    if productionPoint:getOutputDistributionMode(fillTypeIndex) == ProductionPoint.OUTPUT_MODE.AUTO_DELIVER then
                        local receivingProductionPoints = farmProductionChains.inputTypeToProductionPoints[fillTypeIndex]
                        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)

                        if text == "" then
                            text = "    "
                        else
                            text = text .. "\n\n    "
                        end

                        text = text .. EasyDevControlsUtils.formatText("easyDevControls_productionPointDistributingInfo", fillType.title)

                        if receivingProductionPoints ~= nil then
                            for _, receivingProductionPoint in pairs(receivingProductionPoints) do
                                local index = self:getProductionPointIndex(receivingProductionPoint)

                                if index > 0 then
                                    local idString = self.productionPointIndexTexts[receivingProductionPoint] or "PP xx"
                                    local distance = calcDistanceFrom(productionPoint.owningPlaceable.rootNode, receivingProductionPoint.owningPlaceable.rootNode)
                                    local transferCost = g_i18n:formatMoney(1000 * distance * ProductionPoint.DIRECT_DELIVERY_PRICE, 2, true, true)

                                    text = string.format(receivingText, text, idString, receivingProductionPoint:getName(), transferCostText, transferCost, tableIdText, receivingProductionPoint:tableId())
                                end
                            end
                        else
                            text = string.format("%s\n        - %s", text, self.noneText)
                        end
                    end
                end

                if text ~= "" then
                    local idString = self.productionPointIndexTexts[productionPoint] or "PP xx"

                    table.insert(list, {
                        overlayColour = EasyDevControlsGuiManager.OVERLAY_COLOUR,
                        title = string.format("%s  | %s", idString, productionPoint:getName()),
                        text = text
                    })
                end
            end
        end
    end

    EasyDevControlsDynamicListDialog.show(headerText, list)
end

-- Tip To Trigger
function EasyDevControlsPlaceablesFrame:onTipToTriggerCommandStateChanged(name, resetToDefault)
    local tipToTriggerDisabled = true
    local tipToTriggerFillTypeState = self.multiOptionTipToTriggerFillType:getState()
    local tipToTriggerLastObject = self.triggerObjectData ~= nil and self.triggerObjectData.object or nil

    self.triggerObjectData = nil
    self.tipToTriggerOptions = {}

    local player = g_localPlayer

    if player ~= nil and player.isControlled and player.rootNode ~= nil then
        tipToTriggerDisabled = not self:getHasPermission("tipToTrigger")

        if not tipToTriggerDisabled then
            local x, y, z = getWorldTranslation(player.rootNode)

            raycastAll(x, y + 5, z, 0, -1, 0, 10, "tipToTriggerRaycastCallback", self, CollisionFlag.FILLABLE)

            if self.triggerObjectData ~= nil then
                if tipToTriggerLastObject ~= self.triggerObjectData.object then
                    tipToTriggerFillTypeState = 1
                end
            else
                tipToTriggerDisabled = true
                tipToTriggerFillTypeState = 1
            end
        end
    end

    local tipToTriggerNumOptions = #self.tipToTriggerOptions

    if tipToTriggerNumOptions == 0 then
        table.insert(self.tipToTriggerOptions, {
            title = EasyDevControlsUtils.getText("easyDevControls_noTrigger"), -- g_i18n:getText("ui_modUnavailable")
            fillTypeIndex = FillType.UNKNOWN,
            capacity = 0,
            amounts = {1e+7, 0},
            texts = {self.maximumText, self.placeholderText}
        })

        tipToTriggerNumOptions = 1
    end

    self.tipToTriggerDisabled = tipToTriggerDisabled

    self.multiOptionTipToTriggerFillType:setOptions(self.tipToTriggerOptions)
    self.multiOptionTipToTriggerFillType:setState(tipToTriggerFillTypeState, true)

    self.multiOptionTipToTriggerFillType:setDisabled(tipToTriggerDisabled or tipToTriggerNumOptions <= 1)
    self.multiTipToTriggerState:setDisabled(tipToTriggerDisabled)
    self.buttonConfirmTipToTrigger:setDisabled(tipToTriggerDisabled)
end

function EasyDevControlsPlaceablesFrame:updateTipToTriggerInfo(option, state)
    local updateCapacity = state < 2

    if updateCapacity and (self.triggerObjectData ~= nil and self.triggerObjectData.updateCapacity) then
        local object = self.triggerObjectData.object
        local options = self.tipToTriggerOptions

        if object ~= nil and options ~= nil then
            local fillUnitIndex = self.triggerObjectData.fillUnitIndex
            local farmId = g_localPlayer.farmId


            for i, fillTypeIndex in ipairs (self.triggerObjectData.fillTypes) do
                local capacity = 0

                if object.getFillUnitFreeCapacity ~= nil then
                    capacity = object:getFillUnitFreeCapacity(fillUnitIndex, fillTypeIndex, farmId) or capacity
                elseif object.target.getFreeCapacity ~= nil then
                    capacity = object.target:getFreeCapacity(fillTypeIndex, farmId) or capacity
                end

                if capacity > 0 then
                    options[i].texts[1] = g_i18n:formatFluid(capacity)
                end
            end
        end

        self.triggerObjectData.updateCapacity = false
    end

    local textInputElement = self.textInputTipToTriggerAmount

    if textInputElement.setPlaceholderText ~= nil then
        textInputElement:setPlaceholderText(updateCapacity and (option.texts[1] or self.maximumText) or self.placeholderText)
    end

    textInputElement.lastValidText = ""
    textInputElement:setText("")

    textInputElement:setDisabled(self.tipToTriggerDisabled or updateCapacity)
end

function EasyDevControlsPlaceablesFrame:tipToTriggerRaycastCallback(hitActorId, x, y, z, distance, nx, ny, nz, subShapeIndex, hitShapeId)
    local object = g_currentMission.nodeToObject[hitActorId]

    if (object ~= nil and object.target ~= nil) and (object ~= g_localPlayer and object.getFillUnitIndexFromNode ~= nil and object.getFillUnitAllowsFillType ~= nil) then
        local farmId = g_localPlayer.farmId

        if object.getIsFillAllowedFromFarm == nil or not object:getIsFillAllowedFromFarm(farmId) then
            local name = object.target.owningPlaceable ~= nil and object.target.owningPlaceable:getName() or "Unknown Name"

            EasyDevControlsLogging.devInfo("Target '%s' does not accept fill types from farm id %d", name, farmId or 0)

            return true
        end

        -- Solution to allow Husbandry Food Unload Triggers
        local fillTypes = {}
        local fillUnitIndex = object:getFillUnitIndexFromNode(hitShapeId) or 1

        for _, fillType in ipairs(g_fillTypeManager:getFillTypes()) do
            if object:getFillUnitAllowsFillType(fillUnitIndex, fillType.index) then
                table.insert(fillTypes, fillType.index)
            end
        end

        if #fillTypes == 0 then
            local name = object.target.owningPlaceable ~= nil and object.target.owningPlaceable:getName() or "Unknown Name"

            EasyDevControlsLogging.devInfo("Target '%s' does not have any valid fill types!", name)

            return true
        end

        local capacity = 0
        local maximumText = self.maximumText
        local placeholderText = self.placeholderText

        for _, fillTypeIndex in pairs (fillTypes) do
            capacity = 0

            if object.getFillUnitFreeCapacity ~= nil then
                capacity = object:getFillUnitFreeCapacity(fillUnitIndex, fillTypeIndex, farmId) or 0
            elseif object.target.getFreeCapacity ~= nil then
                capacity = object.target:getFreeCapacity(fillTypeIndex, farmId) or 0
            end

            if capacity == math.huge then
                capacity = 0 -- Allow tipping to sell points
            end

            table.insert(self.tipToTriggerOptions, {
                title = EasyDevControlsUtils.getFillTypeTitle(fillTypeIndex),
                fillTypeIndex = fillTypeIndex,
                amounts = {1e+7, 0},
                texts = {capacity > 0 and g_i18n:formatFluid(capacity) or maximumText, placeholderText}
            })
        end

        -- TO_DO: Raycast all nodes to try and support overlapped triggers. not real important though.
        if #self.tipToTriggerOptions > 0 then
            self.triggerObjectData = {
                object = object,
                fillUnitIndex = fillUnitIndex,
                fillTypes = fillTypes,
                hitActorId = hitActorId
            }

            return false
        end
    end

    return true
end

function EasyDevControlsPlaceablesFrame:onClickTipToTriggerFillType(option, multiOptionElement, isLeftButtonEvent)
    self:updateTipToTriggerInfo(option, self.multiTipToTriggerState:getState())
end

function EasyDevControlsPlaceablesFrame:onClickTipToTriggerState(state, multiTextOptionElement)
    self:updateTipToTriggerInfo(self.tipToTriggerOptions[self.multiOptionTipToTriggerFillType:getState()], state)
end

function EasyDevControlsPlaceablesFrame:onTipToTriggerAmountEnterPressed(textInputElement, mouseClickedOutside)
    local option = self.tipToTriggerOptions[self.multiOptionTipToTriggerFillType:getState()]
    local amount = textInputElement.text ~= "" and tonumber(textInputElement.text) or nil

    if amount == nil then
        textInputElement.lastValidText = ""
        textInputElement:setText("")
    end

    option.texts[2] = textInputElement.lastValidText
    option.amounts[2] = amount

    if not mouseClickedOutside then
        self.buttonConfirmTipToTrigger.raisedByTextInput = true
        self:onClickConfirmTipToTrigger(self.buttonConfirmTipToTrigger)
    end
end

function EasyDevControlsPlaceablesFrame:onClickConfirmTipToTrigger(buttonElement)
    local option = self.tipToTriggerOptions[self.multiOptionTipToTriggerFillType:getState()]

    if option ~= nil then
        local triggerObjectData = self.triggerObjectData

        if triggerObjectData ~= nil and triggerObjectData.object ~= nil then
            if triggerObjectData.object == g_currentMission.nodeToObject[triggerObjectData.hitActorId] then
                local state = self.multiTipToTriggerState:getState()

                if state == 2 and not buttonElement.raisedByTextInput then
                    self:onTipToTriggerAmountEnterPressed(self.textInputTipToTriggerAmount, true) -- Make sure value is correct
                end

                buttonElement.raisedByTextInput = nil
                triggerObjectData.updateCapacity = true

                self:setInfoText(g_easyDevControls:tipFillTypeToTrigger(triggerObjectData.object, triggerObjectData.fillUnitIndex, option.fillTypeIndex, option.amounts[state] or 0, g_localPlayer.farmId))

                return
            end
        end
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
end

-- Reload All Placeables
function EasyDevControlsPlaceablesFrame:onClickReloadPlaceables(buttonElement)
    local closestPlaceable = nil

    if buttonElement.name == "reloadPlaceable" then
        closestPlaceable = self.closestPlaceable
    end

    local resultFunction = function(numReloaded, failedToReload)
        local typeText = EasyDevControlsObjectTypes.getText(EasyDevControlsObjectTypes.PLACEABLE, numReloaded)

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_reloadPlaceablesInfo", tostring(numReloaded), typeText), EasyDevControlsErrorCodes.SUCCESS)

        buttonElement:setDisabled(true)

        if closestPlaceable == nil then
            self.buttonConfirmReloadPlaceable:setDisabled(true)
        end

        local numFailedToReload = failedToReload ~= nil and #failedToReload or 0

        if numFailedToReload > 0 then
            local list = table.create(numFailedToReload + 1)
            local listItemText = "%i:  %s"

            table.insert(list, {title = EasyDevControlsUtils.formatText("easyDevControls_reloadFailedMessage", EasyDevControlsUtils.getText("easyDevControls_typePlaceables"))})

            for i, placeable in ipairs (failedToReload) do
                local name = placeable.configFileName

                if string.isNilOrWhitespace(name) then
                    name = string.format("unknownXML ( uniqueId = %s )", placeable:getUniqueId() or "...")
                end

                table.insert(list, {text = listItemText:format(i, name)})
            end

            EasyDevControlsDynamicListDialog.show(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), list)
        end
    end

    self:setInfoText(g_easyDevControls:reloadPlaceables(closestPlaceable, resultFunction))
end

-- Remove All Placeables / Map Placeables
function EasyDevControlsPlaceablesFrame:onClickRemovePlaceables(buttonElement)
    local typeIndex = EasyDevControlsObjectTypes.getByName(buttonElement.name)

    if typeIndex ~= nil then
        local text = "easyDevControls_typePlaceables"

        if typeIndex == EasyDevControlsObjectTypes.MAP_PLACEABLE then
            text = "easyDevControls_typePrePlacedPlaceables"
        end

        local function removeAllPlaceables(yes)
            if yes then
                buttonElement:setDisabled(true)
                self:setInfoText(g_easyDevControls:removeAllObjects(typeIndex))
            end
        end

        text = EasyDevControlsUtils.formatText("easyDevControls_removeAllObjectsWarning", EasyDevControlsUtils.getText(text))
        YesNoDialog.show(removeAllPlaceables, nil, text, "", g_i18n:getText("button_continue"), g_i18n:getText("button_cancel"))
    end
end

-- Production Points Debug
function EasyDevControlsPlaceablesFrame:onClickProductionPointsDebug(state, binaryOptionElement)
    if g_easyDevControlsDebugManager == nil then
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    if g_easyDevControlsDebugManager:setProductionPointsDebugEnabled(state == BinaryOptionElement.STATE_RIGHT) then
        self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_productionPointDebugTitle"), g_i18n:getText("ui_on")))
    else
        self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_productionPointDebugTitle"), g_i18n:getText("ui_off")))
    end
end

-- Show Placeable Test Areas
function EasyDevControlsPlaceablesFrame:onClickShowPlaceableTestAreas(state, binaryOptionElement)
    if g_easyDevControlsDebugManager == nil then
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    if g_easyDevControlsDebugManager:setTestAreasDebugEnabled(state == BinaryOptionElement.STATE_RIGHT) then
        self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_showTestAreasTitle"), g_i18n:getText("ui_on")))
    else
        self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_showTestAreasTitle"), g_i18n:getText("ui_off")))
    end
end

-- Show Placement Collisions
function EasyDevControlsPlaceablesFrame:onClickShowPlacementCollisions(state, binaryOptionElement)
    if g_server == nil then
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    DensityMapHeightManager.DEBUG_PLACEMENT_COLLISIONS = EasyDevControlsUtils.getIsCheckedState(state)

    local densityMapHeightManager = g_densityMapHeightManager

    if densityMapHeightManager.debugBitVectorMapPlacementCollisionsId ~= nil then
        g_debugManager:removeElementById(densityMapHeightManager.debugBitVectorMapPlacementCollisionsId)
        densityMapHeightManager.debugBitVectorMapPlacementCollisionsId = nil
    end

    local title = EasyDevControlsUtils.getText("easyDevControls_showPlacementCollisionsTitle")

    if DensityMapHeightManager.DEBUG_PLACEMENT_COLLISIONS then
        -- Disable 'DEBUG_TIP_COLLISIONS' so they do not conflict
        DensityMapHeightManager.DEBUG_TIP_COLLISIONS = false

        if densityMapHeightManager.debugBitVectorMapTipCollisionsId ~= nil then
            g_debugManager:removeElementById(densityMapHeightManager.debugBitVectorMapTipCollisionsId)
            densityMapHeightManager.debugBitVectorMapTipCollisionsId = nil
        end

        local debugBitVectorMapPlacementCollisions = g_densityMapHeightManager.debugBitVectorMapPlacementCollisions

        if debugBitVectorMapPlacementCollisions ~= nil then
            densityMapHeightManager.debugBitVectorMapPlacementCollisionsId = g_debugManager:addElement(debugBitVectorMapPlacementCollisions)

            self:setInfoText(string.format("%s: %s - %s", title, g_i18n:getText("ui_on"), EasyDevControlsUtils.getText("easyDevControls_showCollisionsInfo")))
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
            binaryOptionElement:setIsChecked(false, true, false)
        end
    else
        self:setInfoText(string.format("%s: %s", title, g_i18n:getText("ui_off")))
    end
end

--

function EasyDevControlsPlaceablesFrame:collectFarmsInfo()
    local farmIDs = {
        FarmManager.SPECTATOR_FARM_ID
    }

    local farmTexts = {
        "NPC"
    }

    for _, farm in ipairs(g_farmManager.farms) do
        if EasyDevControlsUtils.getIsValidFarmId(farm.farmId) then
            table.insert(farmIDs, farm.farmId)
            table.insert(farmTexts, farm.name)
        end
    end

    self.farmIDs = farmIDs
    self.farmTexts = farmTexts
end

function EasyDevControlsPlaceablesFrame:getProductionPointIndex(productionPoint)
    if productionPoint ~= nil then
        for i = 4, #self.productionPoints do
            if self.productionPoints[i][1] == productionPoint then
                return i - 3
            end
        end
    end

    return 0
end

function EasyDevControlsPlaceablesFrame:onSellPlaceable(state, sellPrice, showSoldPopup)
    if state == SellPlaceableEvent.STATE_SUCCESS then
        self:initProductionPointsInfo()
    end
end

function EasyDevControlsPlaceablesFrame:onBuyPlaceable(errorCode, price, objectId)
    if errorCode == BuyPlaceableEvent.STATE_SUCCESS then
        self:initProductionPointsInfo()
    end
end

function EasyDevControlsPlaceablesFrame:onBuyExistingPlaceable(statusCode, price)
    if statusCode == BuyExistingPlaceableEvent.STATE_SUCCESS then
        self:initProductionPointsInfo()
    end
end

function EasyDevControlsPlaceablesFrame:onProductionsChanged(reloaded)
    self:initProductionPointsInfo()
end

function EasyDevControlsPlaceablesFrame:onDynamicSelectionDialogClosed(args)
    self.productionPointDialog = nil
end

function EasyDevControlsPlaceablesFrame:onFarmCreated(farmId)
    if self.productionPointDialog ~= nil then
        self.productionPointDialog:close()

        self:collectFarmsInfo()
        self:initProductionPointsInfo()

        self:setInfoText(string.format("Info: ID - 1 (%s)", g_i18n:getText("button_mp_createFarm")))
    end
end

function EasyDevControlsPlaceablesFrame:onFarmDeleted(farmId)
    if self.productionPointDialog ~= nil then
        self.productionPointDialog:close()

        self:collectFarmsInfo()
        self:initProductionPointsInfo()

        self:setInfoText(string.format("Info: ID - 2 (%s)", g_i18n:getText("button_mp_deleteFarm")))
    end
end

function EasyDevControlsPlaceablesFrame:onDebugCommandStateChanged(name, resetToDefault)
    local binaryOptionElement

    if name == "productionPointsDebug" then
        binaryOptionElement = self.binaryProductionPointsDebug
    elseif name == "testAreasDebug" then
        binaryOptionElement = self.binaryShowPlaceableTestAreas
    end

    if binaryOptionElement == nil then
        return
    end

    if g_easyDevControlsDebugManager ~= nil then
        if not resetToDefault then
            binaryOptionElement:setIsChecked(g_easyDevControlsDebugManager:getDebugIsEnabledByName(name), self.isOpening, false)
        else
            binaryOptionElement:setIsChecked(false, true, true)
        end

        return
    else
        binaryOptionElement:setIsChecked(false, true, false)
        binaryOptionElement:setDisabled(disabled)
    end
end
