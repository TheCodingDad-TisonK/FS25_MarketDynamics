--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-01

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

EasyDevControlsFarmlandsFrame = {}
EasyDevControlsFarmlandsFrame.NAME = "FARMLANDS"

local EasyDevControlsFarmlandsFrame_mt = Class(EasyDevControlsFarmlandsFrame, EasyDevControlsBaseFrame)

function EasyDevControlsFarmlandsFrame.register()
    local controller = EasyDevControlsFarmlandsFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsFarmlandsFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsFarmlandsFrame", controller, true)

    return controller
end

function EasyDevControlsFarmlandsFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsFarmlandsFrame_mt)

    self.pageName = EasyDevControlsFarmlandsFrame.NAME

    self.fieldRefreshingTimer = -1
    self.setFarmlandOwner = {}

    return self
end

function EasyDevControlsFarmlandsFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsFarmlandsFrame.register()
end

function EasyDevControlsFarmlandsFrame:initialize()
    self.lastGrowthStates = {}

    self.vineFruitTypeData = {}
    self.vineNone = {g_i18n:getText("ui_none")}

    self.vineFruitTypeTexts = {}
    self.vineFruitTypes = {}

    self.vineGrowthStateTexts = {}

    self.formattedSecondsText = EasyDevControlsUtils.getText("easyDevControls_formattedSeconds")
    self.refreshingText = EasyDevControlsUtils.getText("easyDevControls_refreshing")
    self.disabledText = EasyDevControlsUtils.getText("easyDevControls_disabled")
end

function EasyDevControlsFarmlandsFrame:onMissionFinishedLoading(currentMission)
    local farmlandText = EasyDevControlsUtils.getText("easyDevControls_farmlandTitle")

    self.setFarmlandOwner = {
        farmlandTexts = {
            EasyDevControlsUtils.getText("easyDevControls_all")
        },
        farmlandIds = {
            0
        },
        farmTexts = {
            "NPC"
        },
        farmIds = {
            FarmlandManager.NO_OWNER_FARM_ID
        }
    }

    for _, farmland in pairs (g_farmlandManager:getFarmlands()) do
        table.insert(self.setFarmlandOwner.farmlandIds, farmland.id)
    end

    table.sort(self.setFarmlandOwner.farmlandIds)

    for i = 2, #self.setFarmlandOwner.farmlandIds do
        table.insert(self.setFarmlandOwner.farmlandTexts, string.format("%s %d", farmlandText, self.setFarmlandOwner.farmlandIds[i]))
    end

    self.multiSetFarmlandOwnerIndex:setTexts(self.setFarmlandOwner.farmlandTexts)
end

function EasyDevControlsFarmlandsFrame:onUpdateCommands(resetToDefault)
    local currentMission = g_currentMission
    local missionInfo = currentMission.missionInfo
    local farmId = currentMission:getFarmId()

    local posX, posY, posZ = EasyDevControlsUtils.getPlayerWorldLocation(2)
    local farmland = g_farmlandManager:getFarmlandAtWorldPosition(posX, posZ)
    local currentFarmlandId, currentFieldId, currentFieldText = 0, 0, nil

    if farmland ~= nil then
        currentFarmlandId = farmland:getId()

        if farmland.field ~= nil then
            -- currentFieldId = farmland.field:getId()
            currentFieldId = currentFarmlandId -- For some reason you can only have one field per farmland so no point getting the ID as it is the same.
        end
    end

    self.currentFarmlandId = currentFarmlandId
    self.currentFieldId = currentFieldId

    if self.currentFieldId > 0 then
        currentFieldText = string.format("%s %d", EasyDevControlsUtils.getText("easyDevControls_fieldIndexTitle"), currentFieldId)
    else
        currentFieldText = EasyDevControlsUtils.getText("easyDevControls_noField")
    end

    -- Set Field Fruit
    self.buttonFieldSetFruit:setDisabled(not self:getHasPermission("fieldSetFruit"))

    -- Set Field Ground
    self.buttonFieldSetGround:setDisabled(not self:getHasPermission("fieldSetGround"))

    -- Set Rice Field
    self.setRiceFieldDisabled = not self:getHasPermission("riceFieldSet")
    self.currentPlaceableRiceField = nil
    self.currentRiceField = nil

    local message, placeable, _, field = PlaceableRiceField.getRiceFieldAtPosition(posX, posY, posZ)

    if message == nil then
        self.currentPlaceableRiceField = placeable
        self.currentRiceField = field
    end

    self.buttonRiceFieldSet:setDisabled(field == nil or self.setRiceFieldDisabled)

    -- Vine System Set State
    local vineSetStateDisabled = true
    local numFarmVines = 0

    local fruitTypeTexts = self.vineNone
    local growthStateTexts = self.vineNone

    local accessHandler = currentMission.accessHandler

    for placeable, _ in pairs(EasyDevControlsUtils.getVinePlaceables()) do
        if accessHandler:canFarmAccessOtherId(farmId, placeable:getOwnerFarmId()) then
            self:updateVineGrowthAndFruitData(placeable:getVineFruitType())

            numFarmVines += 1
        end
    end

    if next(self.vineFruitTypeData) ~= nil then
        if numFarmVines > 0 then
            vineSetStateDisabled = not self:getHasPermission("vineSetState")

            fruitTypeTexts = self.vineFruitTypeTexts
            growthStateTexts = self.vineGrowthStateTexts[1]
        else
            self.vineFruitTypeData = {}
        end
    end

    self.multiVineSetStateFruitType:setTexts(fruitTypeTexts)
    self.multiVineSetStateGrowthState:setTexts(growthStateTexts)

    self.multiVineSetStateFruitType:setState(1)
    self.multiVineSetStateGrowthState:setState(1)

    self.multiVineSetStateFruitType:setDisabled(vineSetStateDisabled)
    self.multiVineSetStateGrowthState:setDisabled(vineSetStateDisabled)
    self.buttonConfirmVineSetState:setDisabled(vineSetStateDisabled)

    self.vineSetStateDisabled = vineSetStateDisabled

    -- Add / Remove Weeds | Stones
    local addRemoveDisabled = not self:getHasPermission("setWeedsStones")

    local weedsDisplayText = self.disabledText
    local weedsDisabled = true

    local stonesDisplayText = self.disabledText
    local stonesDisabled = true

    self.weedsEnabled = missionInfo.weedsEnabled and currentMission.weedSystem:getMapHasWeed()
    self.stonesEnabled = missionInfo.stonesEnabled and currentMission.stoneSystem:getMapHasStones()

    if not addRemoveDisabled then
        if self.weedsEnabled then
            weedsDisplayText = currentFieldText
            weedsDisabled = currentFieldId <= 0
        end

        if self.stonesEnabled then
            stonesDisplayText = currentFieldText
            stonesDisabled = currentFieldId <= 0
        end
    end

    self.textDisplayWeeds:setText(weedsDisplayText)
    self.textDisplayStones:setText(stonesDisplayText)

    self.buttonRemoveWeeds:setDisabled(addRemoveDisabled or weedsDisabled)
    self.buttonAddWeeds:setDisabled(addRemoveDisabled or weedsDisabled)

    self.buttonRemoveStones:setDisabled(addRemoveDisabled or stonesDisabled)
    self.buttonAddStones:setDisabled(addRemoveDisabled or stonesDisabled)

    -- Advance Growth
    self.advanceGrowthDisabled = not self:getHasPermission("advanceGrowth")
    self.buttonConfirmAdvanceGrowth:setDisabled(self.advanceGrowthDisabled)

    -- Set Seasonal Growth Period
    self.setGrowthPeriodDisabled = not self:getHasPermission("setGrowth")
    self.multiGrowthPeriod:setState(EasyDevControlsUtils.getMonthFromPeriod())

    self.multiGrowthPeriod:setDisabled(self.setGrowthPeriodDisabled)
    self.buttonConfirmGrowthPeriod:setDisabled(self.setGrowthPeriodDisabled)

    -- Set Farmland Owner (Future: Add all farms to allow admin to set this in MP, for now it is easy enough to swap farms.)
    local setFarmlandOwnerDisabled = not self:getHasPermission("setFarmlandOwner")
    local farm = g_farmManager:getFarmById(farmId)

    if farm ~= nil and farm.farmId ~= FarmManager.SPECTATOR_FARM_ID then
        self.setFarmlandOwner.farmTexts[2] = farm.name
        self.setFarmlandOwner.farmIds[2] = farm.farmId
    else
        self.setFarmlandOwner.farmTexts[2] = nil
        self.setFarmlandOwner.farmIds[2] = nil
    end

    for state, farmlandId in ipairs (self.setFarmlandOwner.farmlandIds) do
        if farmlandId == self.currentFarmlandId then
            self.multiSetFarmlandOwnerIndex:setState(state)

            break
        end
    end

    self.multiSetFarmlandFarmId:setTexts(self.setFarmlandOwner.farmTexts)
    self.multiSetFarmlandFarmId:setDisabled(setFarmlandOwnerDisabled)

    self.multiSetFarmlandOwnerIndex:setDisabled(setFarmlandOwnerDisabled)
    self.buttonConfirmSetFarmlandOwner:setDisabled(setFarmlandOwnerDisabled)

    self.setFarmlandOwnerDisabled = setFarmlandOwnerDisabled
    self:updateFarmlandOwnerElements()

    -- Refresh Field Overlay
    if g_currentMission.mapOverlayGenerator == nil then
        self.textRefreshFieldOverlay:setText("...")
    end

    self.buttonRefreshFieldOverlay:setDisabled(g_server == nil)

    if not resetToDefault then
        -- Field Status Debug
        self.binaryDebugFieldStatus:setIsChecked(FieldManager.DEBUG_SHOW_FIELDSTATUS)

        -- Vine System Debug
        self.binaryDebugVineSystem:setIsChecked(currentMission.vineSystem.isDebugAreaActive)

        -- Stone System Debug
        self.binaryDebugStoneSystem:setIsChecked((self.stonesEnabled and currentMission.stoneSystem.isDebugAreaActive) or false)
        self.binaryDebugStoneSystem:setDisabled(not self.stonesEnabled)
    else
        self.binaryDebugFieldStatus:setIsChecked(false, true, true)
        self.binaryDebugVineSystem:setIsChecked(false, true, true)
        self.binaryDebugStoneSystem:setIsChecked(false, true, true)
    end

    -- TO_DO: Field State List (Include PF)
    -- Will need to use 'FSDensityMapUtil.getStoneArea' for stones or just exclude.
end

function EasyDevControlsFarmlandsFrame:update(dt)
    EasyDevControlsFarmlandsFrame:superClass().update(self, dt)

    local mapOverlayGenerator = g_currentMission.mapOverlayGenerator

    if mapOverlayGenerator ~= nil and mapOverlayGenerator.fieldsRefreshTimer ~= nil then
        if not mapOverlayGenerator.fieldsOverlayUpdating then
            local remainingTime = (mapOverlayGenerator.fieldsRefreshTimer - g_time) / 1000

            if remainingTime > 1 then
                self.textRefreshFieldOverlay:setText(self.formattedSecondsText:format(math.floor(remainingTime) + 0.5))
            else
                self.textRefreshFieldOverlay:setText(self.refreshingText)
            end
        else
            self.textRefreshFieldOverlay:setText(self.refreshingText)
        end
    else
        self.textRefreshFieldOverlay:setText("...")
    end
end

-- Field Set Fruit / Ground
function EasyDevControlsFarmlandsFrame:onClickFieldSet(element)
    local setFieldDialogData = self:initializeSetFieldDialogData()

    local dialogData = setFieldDialogData[element.name]
    local setFieldData = self.setFieldData[element.name]

    if dialogData ~= nil and setFieldData ~= nil then
        local weedsDisabled = not g_currentMission.missionInfo.weedsEnabled
        local stonesDisabled = not g_currentMission.missionInfo.stonesEnabled
        local disabledTexts = EMPTY_TABLE

        if weedsDisabled or stonesDisabled then
            disabledTexts = {
                g_i18n:getText("toolTip_disabled")
            }
        end

        local states = setFieldData.states
        local lastState = setFieldData.lastState
        local fieldIndexState = 0

        local fieldId = self.currentFieldId or 0
        local field = nil

        if fieldId > 0 then
            for i, fieldIndex in ipairs (states.fieldIndex) do
                if fieldIndex == fieldId then
                    field = g_fieldManager:getFieldById(fieldIndex)
                    fieldIndexState = i

                    break
                end
            end
        end

        if fieldIndexState > 0 then
            if fieldId > 0 then
                local field = g_fieldManager:getFieldById(fieldId)

                if field ~= nil then
                    local fieldState = field:getFieldState()
                    local posX, posZ = field:getIndicatorPosition()

                    fieldState:update(posX, posZ)

                    if lastState.fruitType ~= nil then
                        local fruitType = 1

                        for i, fruitTypeIndex in ipairs(states.fruitType) do
                            if fruitTypeIndex == fieldState.fruitTypeIndex then
                                fruitType = i

                                break
                            end
                        end

                        lastState.fruitType = fruitType

                        if lastState.growthState ~= nil then
                            lastState.growthState[fruitType] = fieldState.growthState or 1
                        end
                    end

                    if lastState.groundType ~= nil then
                        lastState.groundType = fieldState.groundType
                    end

                    if lastState.groundAngle ~= nil then
                        local angle = field:getAngle()
                        local maxAngle = g_currentMission.fieldGroundSystem:getGroundAngleMaxValue()

                        for i, groundAngle in ipairs(states.groundAngle) do
                            if FSDensityMapUtil.convertToDensityMapAngle(groundAngle, maxAngle) == angle then
                                lastState.groundAngle = i

                                break
                            end
                        end
                    end

                    if lastState.sprayType ~= nil then
                        lastState.sprayType = fieldState.sprayType
                    end

                    if lastState.plowLevel ~= nil then
                        lastState.plowLevel = fieldState.plowLevel + 1
                    end

                    if lastState.sprayLevel ~= nil then
                        lastState.sprayLevel = fieldState.sprayLevel + 1
                    end

                    if lastState.limeLevel ~= nil then
                        lastState.limeLevel = fieldState.limeLevel + 1
                    end

                    if lastState.rollerLevel ~= nil then
                        lastState.rollerLevel = fieldState.rollerLevel + 1
                    end

                    if lastState.stubbleShredLevel ~= nil then
                        lastState.stubbleShredLevel = fieldState.stubbleShredLevel + 1
                    end

                    if lastState.weedState ~= nil then
                        lastState.weedState = fieldState.weedState or 1
                    end

                    if lastState.stoneLevel ~= nil then
                        lastState.stoneLevel = (fieldState.stoneLevel or 0) + 1
                    end
                end
            end
        else
            fieldIndexState = #states.fieldIndex

            if lastState.groundType ~= nil then
                lastState.groundType = FieldGroundType.SOWN
            end
        end

        setFieldData.lastState.fieldIndex = fieldIndexState

        for _, property in ipairs (dialogData.properties) do
            local name = property.name

            if name == "growthState" then
                property.lastIndex = setFieldData.lastState.growthState[setFieldData.lastState.fruitType] or 1
            elseif name == "clearHeightTypes" then
                if fieldId == 0 or fieldId ~= property.fieldId then
                    property.lastIndex = 1
                else
                    property.lastIndex = setFieldData.lastState[name] or 1
                end

                property.fieldId = fieldId
            elseif name == "buyFarmland" then
                if self:getHasPermission("setFarmlandOwner") then
                    if fieldId == 0 or fieldId ~= property.fieldId then
                        property.lastIndex = 1
                    else
                        property.lastIndex = setFieldData.lastState[name] or 1
                    end

                    property.disabled = false
                else
                    property.lastIndex = 1
                    property.disabled = true
                end

                property.fieldId = fieldId
            elseif name == "weedState" then
                property.disabled = weedsDisabled
                property.texts = not weedsDisabled and setFieldData.texts.weedState or disabledTexts
                property.lastIndex = not weedsDisabled and setFieldData.lastState.weedState or 1
            elseif name == "stoneLevel" then
                property.disabled = stonesDisabled
                property.texts = not stonesDisabled and setFieldData.texts.stoneLevel or disabledTexts
                property.lastIndex = not stonesDisabled and setFieldData.lastState.stoneLevel or 1
            else
                property.lastIndex = setFieldData.lastState[name] or 1
            end
        end

        local confirmText = EasyDevControlsUtils.getText("easyDevControls_buttonConfirmAndClose")
        local applyText = g_i18n:getText("button_confirm")

        g_gui:showGui("")
        self.dynamicSelectionDialog = EasyDevControlsDynamicSelectionDialog.show(dialogData.headerText, dialogData.properties, dialogData.callback, self, dialogData.numRows, dialogData.flowDirection, dialogData.anchorPosition, true, self, nil, false, nil, confirmText, false, nil, applyText)
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsFarmlandsFrame:initializeSetFieldDialogData()
    if self.setFieldDialogData == nil then
        local setFieldData = self.setFieldData

        if setFieldData == nil then
            setFieldData = self:initializeSetFieldData()
        end

        local function updateButtonOnConfirm(dialog)
            if dialog.applyButton:getIsDisabled() then
                dialog.applyButton:setDisabled(false)
            end

            if dialog.confirmButton:getIsDisabled() then
                dialog.confirmButton:setDisabled(false)
            end
        end

        local setFieldFruitData = setFieldData.setFruit

        local function sharedFieldFruitCallback(dialog, state, element)
            setFieldFruitData.lastState[element.name] = state

            updateButtonOnConfirm(dialog)
        end

        local setFieldGroundData = setFieldData.setGround

        local function sharedFieldGroundCallback(dialog, state, element)
            setFieldGroundData.lastState[element.name] = state

            updateButtonOnConfirm(dialog)
        end

        local setFruitProperties = {
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_fieldIndexTitle"),
                name = "fieldIndex",
                texts = setFieldFruitData.texts.fieldIndex,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_fruitTypeTitle"),
                dynamicId = "multiFruitType",
                name = "fruitType",
                forceState = true,
                texts = setFieldFruitData.texts.fruitType,
                onClickCallback = function(dialog, state, element)
                    setFieldFruitData.lastState.fruitType = state

                    dialog.multiGrowthState:setTexts(setFieldFruitData.texts.growthState[state])
                    dialog.multiGrowthState:setState(setFieldFruitData.lastState.growthState[state] or 1)

                    updateButtonOnConfirm(dialog)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_growthStateTitle"),
                dynamicId = "multiGrowthState",
                name = "growthState",
                onClickCallback = function(dialog, state, element)
                    setFieldFruitData.lastState.growthState[dialog.multiFruitType:getState()] = state

                    updateButtonOnConfirm(dialog)
                end
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_groundTypeTitle"),
                name = "groundType",
                texts = setFieldFruitData.texts.groundType,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_groundLayerTitle"),
                name = "sprayType",
                texts = setFieldFruitData.texts.sprayType,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_plowingStateTitle"),
                name = "plowLevel",
                useYesNoTexts = true,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_fertilizerStateTitle"),
                name = "sprayLevel",
                texts = setFieldFruitData.texts.sprayLevel,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_limeStateTitle"),
                name = "limeLevel",
                texts = setFieldFruitData.texts.limeLevel,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_stubbleStateTitle"),
                name = "stubbleShredLevel",
                useYesNoTexts = true,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_weedStateTitle"),
                name = "weedState",
                texts = setFieldFruitData.texts.weedState,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_stonesStateTitle"),
                name = "stoneLevel",
                texts = setFieldFruitData.texts.stoneLevel,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_rollerStateTitle"),
                name = "rollerLevel",
                useYesNoTexts = true,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_clearHeightTypesTitle"),
                name = "clearHeightTypes",
                useYesNoTexts = true,
                onClickCallback = sharedFieldFruitCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_buyFarmlandTitle"),
                name = "buyFarmland",
                useYesNoTexts = true,
                onClickCallback = sharedFieldFruitCallback
            }
        }

        local setGroundProperties = {
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_fieldIndexTitle"),
                name = "fieldIndex",
                texts = setFieldGroundData.texts.fieldIndex,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_groundTypeTitle"),
                name = "groundType",
                texts = setFieldGroundData.texts.groundType,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_angleTitle"),
                name = "groundAngle",
                texts = setFieldGroundData.texts.groundAngle,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_groundLayerTitle"),
                name = "sprayType",
                texts = setFieldGroundData.texts.sprayType,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_plowingStateTitle"),
                name = "plowLevel",
                useYesNoTexts = true,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_removeFoliageTitle"),
                name = "removeFoliage",
                useYesNoTexts = true,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_fertilizerStateTitle"),
                name = "sprayLevel",
                texts = setFieldGroundData.texts.sprayLevel,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_limeStateTitle"),
                name = "limeLevel",
                texts = setFieldGroundData.texts.limeLevel,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_stubbleStateTitle"),
                name = "stubbleShredLevel",
                useYesNoTexts = true,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_weedStateTitle"),
                name = "weedState",
                disabled = weedsDisabled,
                texts = not weedsDisabled and setFieldGroundData.texts.weedState or disabledTexts,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_stonesStateTitle"),
                name = "stoneLevel",
                disabled = stonesDisabled,
                texts = not stonesDisabled and setFieldGroundData.texts.stoneLevel or disabledTexts,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_rollerStateTitle"),
                name = "rollerLevel",
                useYesNoTexts = true,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_clearHeightTypesTitle"),
                name = "clearHeightTypes",
                useYesNoTexts = true,
                onClickCallback = sharedFieldGroundCallback
            },
            {
                typeId = EasyDevControlsDynamicSelectionDialog.TYPE_BINARY_OPTION,
                title = EasyDevControlsUtils.getText("easyDevControls_buyFarmlandTitle"),
                name = "buyFarmland",
                useYesNoTexts = true,
                onClickCallback = sharedFieldGroundCallback
            }
        }

        self.setFieldDialogData = {
            setFruit = {
                headerText = EasyDevControlsUtils.getText("easyDevControls_fieldSetFruitTitle"),
                properties = setFruitProperties,
                numRows = 5,
                flowDirection = BoxLayoutElement.FLOW_VERTICAL,
                anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_BOTTOM,
                callback = self.onClickFieldSetFruit
            },
            setGround = {
                headerText = EasyDevControlsUtils.getText("easyDevControls_fieldSetGroundTitle"),
                properties = setGroundProperties,
                numRows = 5,
                flowDirection = BoxLayoutElement.FLOW_VERTICAL,
                anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_BOTTOM,
                callback = self.onClickFieldSetGround
            }
        }
    end

    return self.setFieldDialogData
end

function EasyDevControlsFarmlandsFrame:initializeSetFieldData()
    local fieldGroundSystem = g_currentMission.fieldGroundSystem

    -- Fields
    local fields = g_fieldManager:getFields()
    local numFields = #fields
    local sortedFields = table.create(numFields)

    for _, field in ipairs (fields) do
        table.insert(sortedFields, field)
    end

    table.sort(sortedFields, function(a, b)
        a = tostring(a:getName()):gsub("%s+", ""):upper()
        b = tostring(b:getName()):gsub("%s+", ""):upper()

        local _, _, capA1, capA2 = a:find("^(.-)%s*(%d+)$")
        local _, _, capB1, capB2 = b:find("^(.-)%s*(%d+)$")

        if (capA1 and capB1) and (capA1 == capB1) then
            return tonumber(capA2) < tonumber(capB2)
        end

        return a < b
    end)

    local fieldTexts = table.create(numFields + 1)
    local fieldIds = table.create(numFields + 1)

    for _, field in ipairs (sortedFields) do
        table.insert(fieldTexts, field:getName())
        table.insert(fieldIds, field:getId())
    end

    table.insert(fieldTexts, EasyDevControlsUtils.getText("easyDevControls_all"))
    table.insert(fieldIds, 0)

    -- Fruit Types | Growth States
    local fruitTypes = g_fruitTypeManager:getFruitTypes()
    local numValidFruitTypes = 0

    for _, fruitType in ipairs(fruitTypes) do
        if fruitType.allowsSeeding then
            numValidFruitTypes += 1
        end
    end

    local fruitTypesTexts = table.create(numValidFruitTypes)
    local fruitTypesIndexs = table.create(numValidFruitTypes)

    local growthStatesTexts = table.create(numValidFruitTypes)
    local growthStates = table.create(numValidFruitTypes)

    local growthStateNameToTitle = {}

    for index, fruitType in ipairs(fruitTypes) do
        if fruitType.allowsSeeding then
            local fillType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(index)

            table.insert(fruitTypesTexts, fillType ~= nil and fillType.title or fruitType.name)
            table.insert(fruitTypesIndexs, index)

            local statesTexts = table.create(fruitType.numFoliageStates)
            local states = table.create(fruitType.numFoliageStates)

            for i, name in ipairs(fruitType.growthStateToName) do
                local titleText = growthStateNameToTitle[name]

                if titleText == nil then
                    titleText = EasyDevControlsUtils.removeUnderscores(EasyDevControlsUtils.splitCamelCase(name, false, false), true, true)

                    if titleText == "Invisible" then
                        titleText = EasyDevControlsUtils.capitalise(g_i18n:getText("ui_growthMapSown"), false)
                    end

                    growthStateNameToTitle[name] = titleText
                end

                table.insert(statesTexts, titleText)
                table.insert(states, i)
            end

            table.insert(growthStatesTexts, statesTexts)
            table.insert(growthStates, states)
        end
    end

    -- Ground Types
    local groundTypes = FieldGroundType.getAllOrdered()
    local groundTypesTexts = table.create(#groundTypes)

    for _, groundType in ipairs (groundTypes) do
        local name = FieldGroundType.getName(groundType)
        table.insert(groundTypesTexts, EasyDevControlsUtils.getFieldGroundTypeTitle(name, name))
    end

    -- Ground Angle
    local groundAngleMaxValue = fieldGroundSystem:getMaxValue(FieldDensityMap.GROUND_ANGLE) + 1
    local groundAngleStep = math.pi / groundAngleMaxValue

    local groundAnglesTexts = table.create(groundAngleMaxValue)
    local groundAngles = table.create(groundAngleMaxValue)

    for i = 1, groundAngleMaxValue do
        table.insert(groundAnglesTexts, string.format("%.1f °", math.deg((i - 1) * groundAngleStep)))
        table.insert(groundAngles, (i - 1) * groundAngleStep)
    end

    -- Spray Types (Future: Add 'FieldChopperType' also as I did in FS17, FS19, FS22 when there is time)
    local sprayTypes = FieldSprayType.getAllOrdered()
    local sprayTypesTexts = table.create(#sprayTypes)

    for i, sprayType in ipairs(sprayTypes) do
        local name = FieldSprayType.getName(sprayType)
        table.insert(sprayTypesTexts, EasyDevControlsUtils.getFieldSprayTypeTitle(name, name))
    end

    -- Spray Level (Fertiliser)
    local sprayLevelMaxValue = fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL) or 0
    local sprayLevelStep = sprayLevelMaxValue > 0 and (100 / sprayLevelMaxValue) or 1
    local sprayLevelsTexts = table.create(sprayLevelMaxValue)

    for i = 0, sprayLevelMaxValue do
        table.insert(sprayLevelsTexts, string.format("%.1f %%", i * sprayLevelStep))
    end

    -- Lime Level
    local limeLevelMaxValue = fieldGroundSystem:getMaxValue(FieldDensityMap.LIME_LEVEL) or 0
    local limeLevelStep = limeLevelMaxValue > 0 and (100 / limeLevelMaxValue) or 1
    local limeLevelsTexts = table.create(limeLevelMaxValue)

    for i = 0, limeLevelMaxValue do
        table.insert(limeLevelsTexts, string.format("%.1f %%", i * limeLevelStep))
    end

    -- Stone Levels (Only supporting base game defaults for now.)
    local stoneSystem = g_currentMission.stoneSystem
    local stoneLevelsTexts = nil

    if stoneSystem ~= nil and stoneSystem:getMapHasStones() then
        local pickedText = EasyDevControlsUtils.getText("easyDevControls_picked")

        stoneLevelsTexts = {
            g_i18n:getText("ui_none"), -- "Invisible"
            EasyDevControlsUtils.getText("easyDevControls_small"),
            EasyDevControlsUtils.getText("easyDevControls_medium"),
            EasyDevControlsUtils.getText("easyDevControls_large"),
            pickedText,
            string.format("%s (%s)", pickedText, EasyDevControlsUtils.getText("easyDevControls_blocked")) -- "Blocked after picked"
        }
    else
        stoneLevelsTexts = table.create(1, g_i18n:getText("toolTip_disabled"))
    end

    -- Weed Levels (Only supporting base game defaults for now.)
    local weedSystem = g_currentMission.weedSystem
    local weedStatesTexts = nil

    if weedSystem ~= nil and weedSystem:getMapHasWeed() then
        local growingText = EasyDevControlsUtils.getText("easyDevControls_growing")
        local denseText = EasyDevControlsUtils.getText("easyDevControls_dense")
        local smallText = EasyDevControlsUtils.getText("easyDevControls_small")
        local largeText = EasyDevControlsUtils.getText("easyDevControls_large")
        local witheredText = EasyDevControlsUtils.getText("easyDevControls_withered")

        weedStatesTexts = {
            growingText,
            string.format("%s %s", growingText, denseText),
            smallText,
            string.format("%s %s", smallText, denseText),
            largeText,
            EasyDevControlsUtils.getText("easyDevControls_partial"),
            string.format("%s (%s)", smallText, witheredText),
            string.format("%s %s (%s)", smallText, denseText, witheredText),
            string.format("%s (%s)", largeText, witheredText)
        }
    else
        weedStatesTexts = table.create(1, g_i18n:getText("toolTip_disabled"))
    end

    -- Herbicide Level
    local herbicideLevelsTexts = {
        "0.0 %",
        "100.0 %"
    }

    self.setFieldData = {
        setFruit = {
            states = {
                fieldIndex = fieldIds,
                fruitType = fruitTypesIndexs,
                growthState = growthStates
            },
            texts = {
                fieldIndex = fieldTexts,
                fruitType = fruitTypesTexts,
                growthState = growthStatesTexts,
                groundType = groundTypesTexts,
                sprayType = sprayTypesTexts,
                sprayLevel = sprayLevelsTexts,
                limeLevel = limeLevelsTexts,
                stoneLevel = stoneLevelsTexts,
                weedState = weedStatesTexts
            },
            lastState = {
                fieldIndex = #fieldIds,
                fruitType = 1,
                growthState = table.create(#fruitTypesIndexs, 1),
                groundType = 1,
                sprayType = 1,
                sprayLevel = #sprayLevelsTexts,
                limeLevel = #limeLevelsTexts,
                stoneLevel = 1,
                weedState = 1,
                plowLevel = 2,
                rollerLevel = 2,
                stubbleShredLevel = 2,
                clearHeightTypes = 1,
                buyFarmland = 1
            }
        },
        setGround = {
            states = {
                fieldIndex = fieldIds,
                groundAngle = groundAngles
            },
            texts = {
                fieldIndex = fieldTexts,
                groundType = groundTypesTexts,
                groundAngle = groundAnglesTexts,
                sprayType = sprayTypesTexts,
                sprayLevel = sprayLevelsTexts,
                limeLevel = limeLevelsTexts,
                stoneLevel = stoneLevelsTexts,
                weedState = weedStatesTexts
            },
            lastState = {
                fieldIndex = #fieldIds,
                groundType = 1,
                groundAngle = 1,
                sprayType = 1,
                sprayLevel = #sprayLevelsTexts,
                limeLevel = #limeLevelsTexts,
                stoneLevel = 1,
                weedState = 1,
                plowLevel = 2,
                rollerLevel = 2,
                stubbleShredLevel = 2,
                removeFoliage = 1,
                clearHeightTypes = 1,
                buyFarmland = 1
            }
        }
    }

    return self.setFieldData
end

function EasyDevControlsFarmlandsFrame:onClickFieldSetFruit(confirmed)
    if confirmed then
        local setFruit = self.setFieldData.setFruit

        if setFruit == nil or setFruit.states == nil or setFruit.lastState == nil then
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED)

            if not self.isOpen and self.dynamicSelectionDialog ~= nil then
                self.dynamicSelectionDialog:close()
            end

            return
        end

        local states = setFruit.states
        local lastState = setFruit.lastState

        local fieldIndex = states.fieldIndex[lastState.fieldIndex]
        local fruitType = states.fruitType[lastState.fruitType]
        local growthState = states.growthState[lastState.fruitType][lastState.growthState[lastState.fruitType] or 1] or 1
        local groundType = lastState.groundType
        local sprayType = lastState.sprayType
        local plowLevel = lastState.plowLevel - 1
        local sprayLevel = lastState.sprayLevel - 1
        local limeLevel = lastState.limeLevel - 1
        local weedState = lastState.weedState
        local stoneLevel = lastState.stoneLevel - 1
        local rollerLevel = lastState.rollerLevel - 1
        local stubbleShredLevel = lastState.stubbleShredLevel - 1
        local clearHeightTypes = EasyDevControlsUtils.getIsCheckedState(lastState.clearHeightTypes)
        local buyFarmland = EasyDevControlsUtils.getIsCheckedState(lastState.buyFarmland)

        local message, errorCode = g_easyDevControls:setFieldFruit(fieldIndex, fruitType, growthState, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, g_localPlayer.farmId)

        self:setInfoText(message, errorCode)

        if not self.isOpen and errorCode ~= EasyDevControlsErrorCodes.SUCCESS and self.dynamicSelectionDialog ~= nil then
            self.dynamicSelectionDialog:close()
        end
    end
end

function EasyDevControlsFarmlandsFrame:onClickFieldSetGround(confirmed)
    if confirmed then
        local setGround = self.setFieldData.setGround

        if setGround == nil or setGround.states == nil or setGround.lastState == nil then
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED)

            if not self.isOpen and self.dynamicSelectionDialog ~= nil then
                self.dynamicSelectionDialog:close()
            end

            return
        end

        local states = setGround.states
        local lastState = setGround.lastState

        local fieldIndex = states.fieldIndex[lastState.fieldIndex]
        local groundType = lastState.groundType
        local groundAngle = states.groundAngle[lastState.groundAngle]
        local sprayType = lastState.sprayType
        local plowLevel = lastState.plowLevel - 1
        local removeFoliage = EasyDevControlsUtils.getIsCheckedState(lastState.removeFoliage)
        local sprayLevel = lastState.sprayLevel - 1
        local limeLevel = lastState.limeLevel - 1
        local weedState = lastState.weedState
        local stoneLevel = lastState.stoneLevel - 1
        local rollerLevel = lastState.rollerLevel - 1
        local stubbleShredLevel = lastState.stubbleShredLevel - 1
        local clearHeightTypes = EasyDevControlsUtils.getIsCheckedState(lastState.clearHeightTypes)
        local buyFarmland = EasyDevControlsUtils.getIsCheckedState(lastState.buyFarmland)

        local message, errorCode = g_easyDevControls:setFieldGround(fieldIndex, groundAngle, removeFoliage, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland, g_localPlayer.farmId)

        self:setInfoText(message, errorCode)

        if not self.isOpen and errorCode ~= EasyDevControlsErrorCodes.SUCCESS and self.dynamicSelectionDialog ~= nil then
            self.dynamicSelectionDialog:close()
        end
    end
end

-- Rice Fields
-- TO_DO: Add other field values, fertiliser, lime etc
function EasyDevControlsFarmlandsFrame:onClickRiceFieldSet(element)
    if self.setRiceFieldDisabled then
        element:setDisabled(true)

        self:setInfoText(g_i18n:getText("shop_messageNoPermissionGeneral"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    if self.currentPlaceableRiceField == nil or self.currentRiceField == nil then
        element:setDisabled(true)

        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_noField"), EasyDevControlsErrorCodes.FAILED)

        return
    end

    local data = self.setRiceFieldData

    if data == nil then
        local noneText = g_i18n:getText("ui_none")

        data = {
            fruitTypeTexts = {
                noneText
            },
            fruitTypeIndexs = {
                FruitType.UNKNOWN
            },
            fruitTypeState = 1,
            growthStateTexts = {
                {noneText}
            },
            growthStates = {
                {0}
            },
            growthStatesState = {
                1
            }
        }

        local growthStateNameToTitle = {}

        for name, fruitType in pairs (g_fruitTypeManager.nameToFruitType) do
            if name:find("RICE") then
                local fillType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(fruitType.index)

                table.insert(data.fruitTypeTexts, fillType ~= nil and fillType.title or name)
                table.insert(data.fruitTypeIndexs, fruitType.index)

                local statesTexts = table.create(fruitType.numFoliageStates)
                local states = table.create(fruitType.numFoliageStates)

                for i, name in ipairs(fruitType.growthStateToName) do
                    local titleText = growthStateNameToTitle[name]

                    if titleText == nil then
                        titleText = EasyDevControlsUtils.removeUnderscores(EasyDevControlsUtils.splitCamelCase(name, false, false), true, true)

                        if titleText == "Invisible" then
                            titleText = EasyDevControlsUtils.capitalise(g_i18n:getText("ui_growthMapSown"), false)
                        end

                        growthStateNameToTitle[name] = titleText
                    end

                    table.insert(statesTexts, titleText)
                    table.insert(states, i)
                end

                table.insert(data.growthStateTexts, statesTexts)
                table.insert(data.growthStates, states)
            end
        end

        local groundAngleMaxValue = g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.GROUND_ANGLE) + 1
        local groundAngleStep = math.pi / groundAngleMaxValue

        data.groundAngleTexts = table.create(groundAngleMaxValue)
        data.groundAngles = table.create(groundAngleMaxValue)
        data.groundAngleState = 1

        for i = 1, groundAngleMaxValue do
            table.insert(data.groundAngleTexts, string.format("%.1f °", math.deg((i - 1) * groundAngleStep)))
            table.insert(data.groundAngles, (i - 1) * groundAngleStep)
        end

        data.waterLevelTexts = table.create(101)
        data.waterLevelState = 1

        for i = 0, 100 do
            table.insert(data.waterLevelTexts, string.format("%d %%", i))
        end

        data.valid = #data.fruitTypeIndexs > 1

        self.setRiceFieldData = data
    end

    if not data.valid then
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED) -- No Rice fill types

        return
    end

    local dialogData = data.dialogData

    if dialogData == nil then
        local function updateDialogButtons(dialog)
            if dialog.applyButton:getIsDisabled() then
                dialog.applyButton:setDisabled(false)
            end

            if dialog.confirmButton:getIsDisabled() then
                dialog.confirmButton:setDisabled(false)
            end
        end

        dialogData = {
            headerText = EasyDevControlsUtils.getText("easyDevControls_setRiceFieldTitle"),
            anchorPosition = EasyDevControlsDynamicSelectionDialog.ANCHOR_BOTTOM,
            flowDirection = BoxLayoutElement.FLOW_VERTICAL,
            callback = self.onClickConfirmRiceFieldSet,
            numRows = 2,
            properties = {
                {
                    typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                    title = EasyDevControlsUtils.getText("easyDevControls_fruitTypeTitle"),
                    dynamicId = "multiFruitType",
                    name = "fruitType",
                    forceState = true,
                    texts = data.fruitTypeTexts,
                    onClickCallback = function(dialog, state, element)
                        data.fruitTypeState = state

                        dialog.multiGrowthState:setTexts(data.growthStateTexts[state])
                        dialog.multiGrowthState:setState(data.growthStatesState[state] or 1)

                        updateDialogButtons(dialog)
                    end
                },
                {
                    typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                    title = EasyDevControlsUtils.getText("easyDevControls_growthStateTitle"),
                    dynamicId = "multiGrowthState",
                    name = "growthState",
                    onClickCallback = function(dialog, state, element)
                        data.growthStatesState[dialog.multiFruitType:getState()] = state

                        updateDialogButtons(dialog)
                    end
                },
                {
                    typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                    title = EasyDevControlsUtils.getText("easyDevControls_angleTitle"),
                    name = "groundAngle",
                    texts = data.groundAngleTexts,
                    onClickCallback = function(dialog, state, element)
                        data.groundAngleState = state

                        updateDialogButtons(dialog)
                    end
                },
                {
                    typeId = EasyDevControlsDynamicSelectionDialog.TYPE_MULTI_TEXT_OPTION,
                    title = EasyDevControlsUtils.capitalise(g_i18n:getText("info_waterFillLevel"), true),
                    name = "waterLevel",
                    texts = data.waterLevelTexts,
                    onClickCallback = function(dialog, state, element)
                        data.waterLevelState = state

                        updateDialogButtons(dialog)
                    end
                }
            }
        }

        data.dialogData = dialogData
    end

    local confirmText = EasyDevControlsUtils.getText("easyDevControls_buttonConfirmAndClose")
    local applyText = g_i18n:getText("button_confirm")

    g_gui:showGui("")
    self.dynamicSelectionDialog = EasyDevControlsDynamicSelectionDialog.show(dialogData.headerText, dialogData.properties, dialogData.callback, self, dialogData.numRows, dialogData.flowDirection, dialogData.anchorPosition, true, self, nil, false, nil, confirmText, false, nil, applyText)
end

function EasyDevControlsFarmlandsFrame:onClickConfirmRiceFieldSet(confirmed)
    if confirmed then
        local data = self.setRiceFieldData

        if data == nil or self.currentPlaceableRiceField == nil or self.currentPlaceableRiceField.spec_riceField == nil then
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo"), EasyDevControlsErrorCodes.FAILED)

            if not self.isOpen and self.dynamicSelectionDialog ~= nil then
                self.dynamicSelectionDialog:close()
            end

            return
        end

        local fieldIndex = 0

        for i, field in ipairs(self.currentPlaceableRiceField.spec_riceField.fields) do
            if field == self.currentRiceField then
                fieldIndex = i

                break
            end
        end

        local fruitTypeIndex = data.fruitTypeIndexs[data.fruitTypeState] or FruitType.UNKNOWN
        local growthState = data.growthStates[data.fruitTypeState][data.growthStatesState[data.fruitTypeState] or 1] or 1
        local groundAngle = data.groundAngles[data.groundAngleState] or 0
        local waterLevel = (data.waterLevelState or 1) - 1

        local message, errorCode = g_easyDevControls:setRiceField(self.currentPlaceableRiceField, fieldIndex, fruitTypeIndex, growthState, groundAngle, waterLevel)

        self:setInfoText(message, errorCode)

        if not self.isOpen and errorCode ~= EasyDevControlsErrorCodes.SUCCESS and self.dynamicSelectionDialog ~= nil then
            self.dynamicSelectionDialog:close()
        end
    end
end

-- Vine System Set State
function EasyDevControlsFarmlandsFrame:updateVineGrowthAndFruitData(fruitTypeIndex)
    if fruitTypeIndex == nil or self.vineFruitTypeData[fruitTypeIndex] ~= nil then
        return false
    end

    local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)

    if fruitType ~= nil and fruitType.numGrowthStates > 0 then
        local growthStateToName = fruitType.growthStateToName
        local numGrowthStates = #fruitType.growthStateToName

        if fruitTypeIndex == FruitType.OLIVE then
            numGrowthStates -= 1 -- dead has no foliageShape so not added for now.
        end

        local growthStateTexts = table.create(numGrowthStates)

        for i = 1, numGrowthStates do
            -- TO_DO: Using split state names, may translate in the future...
            table.insert(growthStateTexts, EasyDevControlsUtils.splitCamelCase(growthStateToName[i], false, false))
        end

        if #growthStateTexts > 0 then
            local fillType = g_fruitTypeManager:getFillTypeByFruitTypeIndex(fruitTypeIndex)

            self.vineFruitTypeData[fruitTypeIndex] = {
                growthStateTexts = growthStateTexts,
                fruitTypeIndex = fruitTypeIndex,
                title = fillType.title
            }

            EasyDevControlsUtils.clearTable(self.vineFruitTypeTexts)
            EasyDevControlsUtils.clearTable(self.vineFruitTypes)

            EasyDevControlsUtils.clearTable(self.vineGrowthStateTexts)


            for _, data in pairs (self.vineFruitTypeData) do
                table.insert(self.vineFruitTypeTexts, data.title)
                table.insert(self.vineFruitTypes, data.fruitTypeIndex)

                table.insert(self.vineGrowthStateTexts, data.growthStateTexts)
            end

            return true
        end
    end

    return false
end

function EasyDevControlsFarmlandsFrame:onClickVineSetStateFruitType(state, multiTextOptionElement)
    self.multiVineSetStateGrowthState:setTexts(self.vineGrowthStateTexts[state] or EMPTY_TABLE)
    self.multiVineSetStateGrowthState:setState(1)
end

function EasyDevControlsFarmlandsFrame:onClickConfirmVineSetState(buttonElement)
    local fruitTypeState = self.multiVineSetStateFruitType:getState()
    local growthState = self.multiVineSetStateGrowthState:getState()
    local placeableVine = nil -- Future, targeted vine updating

    self:setInfoText(g_easyDevControls:vineSystemSetState(placeableVine, self.vineFruitTypes[fruitTypeState], growthState, g_currentMission:getFarmId()))
end

-- Vine System Update Visuals
function EasyDevControlsFarmlandsFrame:onClickVineUpdateVisuals(buttonElement)
    g_currentMission.vineSystem:consoleCommandUpdateVisuals()

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_vineUpdateVisualsInfo"))
end

-- Add / Remove Stones & Weeds
function EasyDevControlsFarmlandsFrame:onClickRemove(buttonElement)
    if self.currentFieldId > 0 then
        if buttonElement.name == "removeWeeds" then
            self:setInfoText(g_easyDevControls:addRemoveWeedsDelta(self.currentFieldId, -1))
        elseif buttonElement.name == "removeStones" then
            self:setInfoText(g_easyDevControls:addRemoveStonesDelta(self.currentFieldId, -1))
        end
    end
end

function EasyDevControlsFarmlandsFrame:onClickAdd(buttonElement)
    if self.currentFieldId > 0 then
        if buttonElement.name == "addWeeds" then
            self:setInfoText(g_easyDevControls:addRemoveWeedsDelta(self.currentFieldId, 1))
        elseif buttonElement.name == "addStones" then
            self:setInfoText(g_easyDevControls:addRemoveStonesDelta(self.currentFieldId, 1))
        end
    end
end

-- Advance Growth
function EasyDevControlsFarmlandsFrame:onClickConfirmAdvanceGrowth(buttonElement)
    if not self.advanceGrowthDisabled then
        local growthMode = g_currentMission.growthSystem:getGrowthMode()

        local args = {
            updateGrowthMode = growthMode ~= GrowthMode.DAILY,
            successText = EasyDevControlsUtils.getText("easyDevControls_advanceGrowthInfo"),
            setGrowth = false
        }

        if growthMode == GrowthMode.DAILY then
            self:setGrowthPeriod(true, args)
        else
            local currentSetting = growthMode == GrowthMode.SEASONAL and "ui_gameMode_seasonal" or "ui_paused"
            local text = EasyDevControlsUtils.formatText("easyDevControls_advanceGrowthWarning", g_i18n:getText("setting_seasonalGrowth"), g_i18n:getText(currentSetting))

            YesNoDialog.show(self.setGrowthPeriod, self, text, "", nil, nil, nil, nil, nil, args)
        end
    else
        buttonElement:setDisabled(true)

        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Set Seasonal Growth Period
function EasyDevControlsFarmlandsFrame:onClickConfirmGrowthPeriod(buttonElement)
    if not self.setGrowthPeriodDisabled then
        local period = EasyDevControlsUtils.getPeriodFromMonth(self.multiGrowthPeriod:getState())
        local growthMode = g_currentMission.growthSystem:getGrowthMode()
        local args = {
            updateGrowthMode = growthMode == GrowthMode.DISABLED,
            successText = EasyDevControlsUtils.formatText("easyDevControls_setGrowthPeriodInfo", g_i18n:formatPeriod(period, false), tostring(period)),
            setGrowth = true,
            period = period
        }

        if growthMode ~= GrowthMode.DISABLED then
            self:setGrowthPeriod(true, args)
        else
            local text = EasyDevControlsUtils.formatText("easyDevControls_setGrowthPeriodWarning", g_i18n:getText("setting_seasonalGrowth"), g_i18n:getText("ui_paused"))
            YesNoDialog.show(self.setGrowthPeriod, self, text, "", nil, nil, nil, nil, nil, args)
        end
    else
        buttonElement:setDisabled(true)
        self.multiGrowthPeriod:setDisabled(true)

        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsFarmlandsFrame:setGrowthPeriod(yes, args)
    if yes then
        if args.updateGrowthMode then
            g_currentMission.growthSystem:setGrowthMode(GrowthMode.DAILY, false)
        end

        local message = EasyDevControlsUtils.getText("easyDevControls_updatingAllFieldsMessage")

        MessageDialog.show(message, EasyDevControlsFarmlandsFrame.setGrowthPeriodMessageDialogUpdate, self, DialogElement.TYPE_LOADING, false, getTimeSec() + 8)
        g_messageCenter:subscribeOneshot(MessageType.FINISHED_GROWTH_PERIOD, EasyDevControlsFarmlandsFrame.onFinishedGrowthPeriod, self)

        self:setInfoText(g_easyDevControls:setGrowthPeriod(args.setGrowth, args.period))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestCancelledMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsFarmlandsFrame.setGrowthPeriodMessageDialogUpdate(frame, dt, endTimeSec)
    if endTimeSec ~= nil and endTimeSec <= getTimeSec() then
        MessageDialog.hide()

        if frame.setInfoText ~= nil then
            frame:setInfoText(EasyDevControlsUtils.getText("easyDevControls_success"), EasyDevControlsErrorCodes.SUCCESS)
        end
    end
end

function EasyDevControlsFarmlandsFrame.onFinishedGrowthPeriod(frame, period, hasQueued)
    if not hasQueued then
        MessageDialog.hide()

        if frame.setInfoText ~= nil then
            frame:setInfoText(EasyDevControlsUtils.getText("easyDevControls_success"), EasyDevControlsErrorCodes.SUCCESS)
        end
    end
end

-- Set Farmland Owner
function EasyDevControlsFarmlandsFrame:updateFarmlandOwnerElements()
    local isButtonDisabled = self.setFarmlandOwnerDisabled

    if not isButtonDisabled then
        local farmlandIdState = self.multiSetFarmlandOwnerIndex:getState()
        local farmlandId = self.setFarmlandOwner.farmlandIds[farmlandIdState]

        if farmlandId > 0 then
            local farmlandOwner = g_farmlandManager:getFarmlandOwner(farmlandId)
            local farmId = g_currentMission:getFarmId()

            local farmIdState = self.multiSetFarmlandFarmId:getState()
            local ownerFarmId = self.setFarmlandOwner.farmIds[farmIdState]

            if farmlandOwner == farmId then
                isButtonDisabled = ownerFarmId == farmId
            elseif farmlandOwner == FarmlandManager.NO_OWNER_FARM_ID then
                isButtonDisabled = ownerFarmId == FarmlandManager.NO_OWNER_FARM_ID
            end
        end
    end

    self.buttonConfirmSetFarmlandOwner:setDisabled(isButtonDisabled)
end

function EasyDevControlsFarmlandsFrame:onClickSetFarmlandFarmId(state, multiTextOptionElement)
    self:updateFarmlandOwnerElements()
end

function EasyDevControlsFarmlandsFrame:onClickSetFarmlandOwnerIndex(state, multiTextOptionElement)
    self:updateFarmlandOwnerElements()
end

function EasyDevControlsFarmlandsFrame:onClickConfrimSetFarmlandOwner(buttonElement)
    local farmlandIdState = self.multiSetFarmlandOwnerIndex:getState()
    local farmlandId = self.setFarmlandOwner.farmlandIds[farmlandIdState]

    local farmIdState = self.multiSetFarmlandFarmId:getState()
    local ownerFarmId = self.setFarmlandOwner.farmIds[farmIdState]

    local farmId = g_currentMission:getFarmId()
    local farmName = "NPC"

    if ownerFarmId ~= FarmManager.SPECTATOR_FARM_ID then
        local farm = g_farmManager:getFarmById(farmId)

        if farm ~= nil then
            farmName = farm.name
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM)

            buttonElement:setDisabled(true)

            return
        end
    end

    if farmlandId == 0 then
        local numUpdated = 0

        for _, farmland in pairs(g_farmlandManager:getFarmlands()) do
            local currentOwner = g_farmlandManager:getFarmlandOwner(farmland.id)

            if currentOwner == farmId or currentOwner == FarmlandManager.NO_OWNER_FARM_ID then
                g_client:getServerConnection():sendEvent(FarmlandStateEvent.new(farmland.id, ownerFarmId, 0))

                numUpdated += 1
            end
        end

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_setFarmlandOwnerAllInfo", tostring(numUpdated), farmName))
    elseif g_farmlandManager:getIsValidFarmlandId(farmlandId) then
        local currentOwner = g_farmlandManager:getFarmlandOwner(farmlandId)

        if currentOwner == farmId or currentOwner == FarmlandManager.NO_OWNER_FARM_ID then
            g_client:getServerConnection():sendEvent(FarmlandStateEvent.new(farmlandId, ownerFarmId, 0))

            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_setFarmlandOwnerInfo", tostring(farmlandId), farmName))
        else
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidFarmWarning"), EasyDevControlsErrorCodes.INVALID_FARM)
        end

        self:updateFarmlandOwnerElements()
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Refresh Field Overlay
function EasyDevControlsFarmlandsFrame:onClickRefreshFieldOverlay(buttonElement)
    g_currentMission.mapOverlayGenerator.fieldsRefreshTimer = g_time + 999
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_refreshFieldOverlayInfo", (MapOverlayGenerator.FIELD_REFRESH_INTERVAL or 0) / 1000))
end

-- Field Status Debug
function EasyDevControlsFarmlandsFrame:onClickDebugFieldStatus(state, binaryOptionElement)
    FieldManager.DEBUG_SHOW_FIELDSTATUS = EasyDevControlsUtils.getIsCheckedState(state)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_debugFieldStatusInfo", EasyDevControlsUtils.getStateText(FieldManager.DEBUG_SHOW_FIELDSTATUS, false):lower()))
end

-- Vine System Debug
function EasyDevControlsFarmlandsFrame:onClickDebugVineSystem(state, binaryOptionElement)
    local isDebugAreaActive = EasyDevControlsUtils.getIsCheckedState(state)
    local vineSystem = g_currentMission.vineSystem

    if isDebugAreaActive and not vineSystem.isDebugAreaActive or not isDebugAreaActive and vineSystem.isDebugAreaActive then
        vineSystem:consoleCommandToggleDebug()
    else
        binaryOptionElement:setIsChecked(vineSystem.isDebugAreaActive)
    end

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_vineSystemDebugInfo", EasyDevControlsUtils.getStateText(vineSystem.isDebugAreaActive, false):lower()))
end

-- Stone System Debug
function EasyDevControlsFarmlandsFrame:onClickDebugStoneSystem(state, binaryOptionElement)
    local isDebugAreaActive = EasyDevControlsUtils.getIsCheckedState(state)
    local stoneSystem = g_currentMission.stoneSystem

    if isDebugAreaActive and not stoneSystem.isDebugAreaActive or not isDebugAreaActive and stoneSystem.isDebugAreaActive then
        stoneSystem:consoleCommandToggleDebug()
    else
        binaryOptionElement:setIsChecked(stoneSystem.isDebugAreaActive)
    end

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_stoneSystemDebugInfo", EasyDevControlsUtils.getStateText(stoneSystem.isDebugAreaActive, false):lower()))
end

-- Shared
function EasyDevControlsFarmlandsFrame:onDynamicSelectionDialogClosed()
    g_gui:showGui("EasyDevControlsMenu")
    self.dynamicSelectionDialog = nil
end
