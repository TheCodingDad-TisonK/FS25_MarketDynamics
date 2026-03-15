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

EasyDevControlsGeneralFrame = {}
EasyDevControlsGeneralFrame.NAME = "GENERAL"

EasyDevControlsGeneralFrame.USER_QUALITY_INDEX = 4
EasyDevControlsGeneralFrame.NUM_QUALITY_OPTIONS = 7

local EasyDevControlsGeneralFrame_mt = Class(EasyDevControlsGeneralFrame, EasyDevControlsBaseFrame)

function EasyDevControlsGeneralFrame.register()
    local controller = EasyDevControlsGeneralFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsGeneralFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsGeneralFrame", controller, true)

    return controller
end

function EasyDevControlsGeneralFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsGeneralFrame_mt)

    self.pageName = EasyDevControlsGeneralFrame.NAME

    self:setCommandChangedCallback("extraTimeScales", EasyDevControlsGeneralFrame.onExtraTimeScalesCommandStateChanged)
    self:setCommandChangedCallback("showObjectLocations", EasyDevControlsGeneralFrame.onShowObjectLocationsCommandStateChanged) -- Shared: showBaleLocations/showPalletLocations
    self:setCommandChangedCallback("setFOVAngle", EasyDevControlsGeneralFrame.onSetFOVAngleCommandStateChanged)

    return self
end

function EasyDevControlsGeneralFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsGeneralFrame.register()
end

function EasyDevControlsGeneralFrame:onMissionFinishedLoading(currentMission)
    -- Teleport Player or Vehicle
    local farmlandText = g_i18n:getText("contract_farmland")
    local sortedFarmlandIds = g_farmlandManager.sortedFarmlandIds
    local numberOfFarmlands = #sortedFarmlandIds
    local teleportFarmlandTexts = table.create(numberOfFarmlands + 2)

    for i = 1, numberOfFarmlands do
        table.insert(teleportFarmlandTexts, string.format(farmlandText, sortedFarmlandIds[i]))
    end

    self.numTeleportFarmland = #teleportFarmlandTexts

    table.insert(teleportFarmlandTexts, EasyDevControlsUtils.getText("easyDevControls_teleportMapSelect"))
    self.mapSelectTeleportIndex = #teleportFarmlandTexts

    table.insert(teleportFarmlandTexts, "X / Z")
    self.locationTeleportIndex = #teleportFarmlandTexts

    table.insert(teleportFarmlandTexts, "X / Z  (3D/World)")
    self.locationTeleportWorldIndex = #teleportFarmlandTexts

    self.multiTeleport:setTexts(teleportFarmlandTexts)

    -- Set Quality
    self.qualitySettings = {
        [SettingsModel.SETTING.OBJECT_DRAW_DISTANCE] = {
            defualtValue = 0,
            setFunc = function(coeff) setViewDistanceCoeff(coeff) end,
            getFunc = function() return getViewDistanceCoeff() end
        },
        [SettingsModel.SETTING.LOD_DISTANCE] = {
            defualtValue = 0,
            setFunc = function(coeff) setLODDistanceCoeff(coeff) end,
            getFunc = function() return getLODDistanceCoeff() end
        },
        [SettingsModel.SETTING.TERRAIN_LOD_DISTANCE] = {
            defualtValue = 0,
            setFunc = function(coeff) setTerrainLODDistanceCoeff(coeff) end,
            getFunc = function() return getTerrainLODDistanceCoeff() end
        },
        [SettingsModel.SETTING.FOLIAGE_DRAW_DISTANCE] = {
            defualtValue = 0,
            setFunc = function(coeff) setFoliageViewDistanceCoeff(coeff) end,
            getFunc = function() return getFoliageViewDistanceCoeff() end
        },
        [SettingsModel.SETTING.FOLIAGE_LOD_DISTANCE] = {
            defualtValue = 0,
            setFunc = function(coeff) setFoliageLODDistanceCoeff(coeff) end,
            getFunc = function() return getFoliageLODDistanceCoeff() end
        },
        [SettingsModel.SETTING.VOLUME_MESH_TESSELLATION] = {
            defualtValue = 0,
            setFunc = function(coeff) SettingsModel.setVolumeMeshTessellationCoeff(coeff) end,
            getFunc = function() return SettingsModel.getVolumeMeshTessellationCoeff() end
        }
    }

    if g_settingsModel ~= nil then
        local settings = g_settingsModel.settings
        local percentValues = g_settingsModel.percentValues or EMPTY_TABLE

        self.qualityTexts = {
            g_i18n:getText("setting_veryLow"),
            g_i18n:getText("setting_low"),
            g_i18n:getText("setting_medium"),
            EasyDevControlsUtils.getText("easyDevControls_userSetting"),
            g_i18n:getText("setting_high"),
            g_i18n:getText("setting_veryHigh"),
            g_i18n:getText("setting_ultra")
        }

        self.qualityValues = {
            0.1,
            0.25,
            1,
            1,
            5,
            10,
            25
        }

        self.qualityUserSettingIndex = 4

        for key, qualitySetting in pairs (self.qualitySettings) do
            local setting = settings[key]

            if setting ~= nil then
                local defualtValue = percentValues[setting.saved] or qualitySetting.getFunc()

                qualitySetting.defualtValue = defualtValue

                if key == SettingsModel.SETTING.OBJECT_DRAW_DISTANCE then
                    self.qualityValues[EasyDevControlsGeneralFrame.USER_QUALITY_INDEX] = defualtValue
                end
            end
        end
    else
        self.qualityTexts = {EasyDevControlsUtils.getText("easyDevControls_userSetting")}
        self.qualityValues = {}
        self.qualityUserSettingIndex = 1
    end

    self.multiSetQuality:setTexts(self.qualityTexts)

    -- Collectables (SP ONLY)
    self.collectiblesThreshold = {}
    self.collectiblesDisabled = true
    self.collectiblesCompleted = false

    local thresholdTexts, currentMission = nil, g_currentMission
    local collectiblesSystem = currentMission ~= nil and currentMission.collectiblesSystem or nil

    if collectiblesSystem ~= nil and not g_easyDevControls:getIsMultiplayer() then
        local numCollectibles = #collectiblesSystem.collectibleIndexToName

        if numCollectibles > 0 then
            local hotspotThreshold = collectiblesSystem.hotspotThreshold
            local foundText = EasyDevControlsUtils.getText("easyDevControls_found")

            if hotspotThreshold == nil or hotspotThreshold <= 0 then
                hotspotThreshold = numCollectibles / 4
                collectiblesSystem.hotspotThreshold = hotspotThreshold
            end

            thresholdTexts = table.create(10)

            for i = 10, 0, -1 do
                if i < 10 or numCollectibles ~= hotspotThreshold then
                    table.insert(thresholdTexts, string.format("%d%% %s", i * 10, foundText))
                    table.insert(self.collectiblesThreshold, numCollectibles * (i * 0.1))
                end
            end

            for i = 1, #self.collectiblesThreshold do
                if hotspotThreshold >= self.collectiblesThreshold[i] then
                    thresholdTexts[i] = g_i18n:getText("configuration_valueDefault")

                    break
                end
            end

            self.collectiblesDisabled = false
        end
    end

    if self.collectiblesDisabled then
        thresholdTexts = {
            EasyDevControlsUtils.getText("easyDevControls_unsupported"),
        }
    end

    self.multiShowCollectables:setTexts(thresholdTexts)

    -- Refresh Vehicle Sale System
    -- local vehiclesText = g_i18n:getText("ui_vehicles")
    -- local vehicleText = g_i18n:getText("ui_vehicle")

    -- local numSales = (VehicleSaleSystem.MAX_GENERATED_ITEMS or 5) + 1
    -- local saleSystemTexts = table.create(numSales)

    -- for i = 1, numSales do
        -- table.insert(saleSystemTexts, string.format("%d  %s", i - 1, i == 2 and vehicleText or vehiclesText))
    -- end

    -- self.multiRefreshSaleSystem:setTexts(saleSystemTexts)
    -- self.multiRefreshSaleSystem:setState(numSales)
end

function EasyDevControlsGeneralFrame:delete()
    -- Restore the quality settings to 'User Default' to avoid issues if they do not quit the application.
    if self.qualitySettings ~= nil and self.multiSetQuality ~= nil then
        local index = self.multiSetQuality:getState()

        if index ~= EasyDevControlsGeneralFrame.USER_QUALITY_INDEX then
            for key, setting in pairs (self.qualitySettings) do
                if setting.defualtValue ~= 0 then
                    setting.setFunc(setting.defualtValue)
                end
             end
        end
    end

    EasyDevControlsGeneralFrame:superClass().delete(self)
end

function EasyDevControlsGeneralFrame:onUpdateCommands(resetToDefault)
    local easyDevControls = g_easyDevControls
    local easyDevControlsSettings = g_easyDevControlsSettings

    local vehicle, isEntered = easyDevControls:getVehicle()
    local isMultiplayer = easyDevControls:getIsMultiplayer()

    local binarySkipAnimation = self.isOpening

    -- Cheat Money (Add | Remove | Set)
    local disabled = not self:getHasPermission("cheatMoney")

    self.textInputAddMoney.lastValidText = ""
    self.textInputAddMoney:setText("")
    self.textInputAddMoney:setDisabled(disabled)

    self.textInputRemoveMoney.lastValidText = ""
    self.textInputRemoveMoney:setText("")
    self.textInputRemoveMoney:setDisabled(disabled)

    self.textInputSetMoney.lastValidText = ""
    self.textInputSetMoney:setText("")
    self.textInputSetMoney:setDisabled(disabled)

    -- Extra Time Scales
    self:onExtraTimeScalesCommandStateChanged("extraTimeScales", resetToDefault)

    -- Stop Time
    self:onTimeScaleChanged()

    -- Hud (Visibility | Key)
    if not resetToDefault then
        self.binaryHudVisibility:setIsChecked(not g_noHudModeEnabled, binarySkipAnimation, false)
        self.binaryToggleHudInput:setIsChecked(easyDevControls.hudVisibilityKeyEnabled, binarySkipAnimation, false)
    else
        self.binaryHudVisibility:setIsChecked(true, true, true)
        self.binaryToggleHudInput:setIsChecked(easyDevControlsSettings:getDefaultValue("hudVisibilityKey", false), binarySkipAnimation, true)
    end

    -- Delete Objects Key
    local hasPermission = self:getHasPermission("deleteObjectsKey")

    if not resetToDefault then
        self.binaryDeleteObjectsKey:setIsChecked(easyDevControls.deleteObjectsKeyEnabled, binarySkipAnimation, false)
    elseif hasPermission then
        self.binaryDeleteObjectsKey:setIsChecked(easyDevControlsSettings:getDefaultValue("deleteObjectsKey", false), true, true)
    end

    self.binaryDeleteObjectsKey:setDisabled(not hasPermission)

    -- Show Locations
    self:onShowObjectLocationsCommandStateChanged("showObjectLocations", resetToDefault)

    -- Teleport Player or Vehicle
    disabled = not self:getHasPermission("teleport")

    if vehicle ~= nil then
        local singleVehicle = false

        if not isEntered then
            singleVehicle = vehicle.getAttachedImplements == nil or #vehicle:getAttachedImplements() == 0

            if singleVehicle and vehicle.getAttacherVehicle ~= nil then
                local attacherVehicle = vehicle:getAttacherVehicle()

                singleVehicle = attacherVehicle == nil or attacherVehicle == vehicle
            end
        end

        if singleVehicle then
            self.titleTeleport:setText(EasyDevControlsUtils.formatText("easyDevControls_teleportFormatedTitle", vehicle:getName()))
            -- self.titleTeleport:setText(EasyDevControlsUtils.namedFormatText("easyDevControls_teleportFormatedTitle", "objectName", vehicle:getName()))
        else
            self.titleTeleport:setText(EasyDevControlsUtils.formatText("easyDevControls_teleportFormatedTitle", g_i18n:getText("ui_vehicles")))
            -- self.titleTeleport:setText(EasyDevControlsUtils.namedFormatText("easyDevControls_teleportFormatedTitle", "objectName", g_i18n:getText("ui_vehicles")))
        end
    else
        self.titleTeleport:setText(EasyDevControlsUtils.formatText("easyDevControls_teleportFormatedTitle", g_i18n:getText("ui_playerCharacter")))
        -- self.titleTeleport:setText(EasyDevControlsUtils.namedFormatText("easyDevControls_teleportFormatedTitle", "objectName", g_i18n:getText("ui_playerCharacter")))
    end

    local teleportIndex = self.mapSelectTeleportIndex
    local disabledTextInput = teleportIndex ~= self.locationTeleportIndex and teleportIndex ~= self.locationTeleportWorldIndex

    self.teleportIndex = teleportIndex
    self.multiTeleport:setState(teleportIndex)
    self.multiTeleport:setDisabled(disabled)
    self.textInputTeleportXZ.lastValidText = ""
    self.textInputTeleportXZ:setText("")
    self.textInputTeleportXZ:setDisabled(disabled or disabledTextInput)
    self.buttonTeleportConfirm:setDisabled(disabled)

    -- Flip Vehicles
    disabled = not self:getHasPermission("flipVehicles")
    self.buttonFlipVehicles:setDisabled(vehicle == nil or disabled)

    -- Set FOV Angle
    self:onSetFOVAngleCommandStateChanged("setFOVAngle", resetToDefault)

    -- Set Quality
    disabled = #self.qualityValues ~= EasyDevControlsGeneralFrame.NUM_QUALITY_OPTIONS

    if not disabled then
        if not resetToDefault then
            self.multiSetQuality:setState(Utils.getValueIndex(getViewDistanceCoeff(), self.qualityValues))
        else
            self.multiSetQuality:setState(self.qualityUserSettingIndex, true)
        end
    end

    self.multiSetQuality:setDisabled(disabled)

    -- Collectables (SP ONLY)
    local collectablesState, collectiblesDisabled = 1, true

    if not isMultiplayer and not self.collectiblesDisabled and not self.collectiblesCompleted then
        local collectiblesSystem = g_currentMission ~= nil and g_currentMission.collectiblesSystem or nil

        if collectiblesSystem ~= nil then
            if not collectiblesSystem:isCompleted() then
                if not resetToDefault then
                    local hotspotThreshold = collectiblesSystem.hotspotThreshold

                    for i = 1, #self.collectiblesThreshold do
                        if hotspotThreshold >= self.collectiblesThreshold[i] then
                            collectablesState = i

                            break
                        end
                    end
                end

                collectiblesDisabled = false
            else
                self.collectiblesCompleted = true
            end
        end
    end

    self.multiShowCollectables:setState(collectablesState, resetToDefault)
    self.multiShowCollectables:setDisabled(collectiblesDisabled)

    -- Clear I3D Cache
    if resetToDefault then
        self.multiClearI3DCacheVerbose:setState(1)
    end

    self.buttonClearI3DCache:setDisabled(getNumOfSharedI3DFiles() == 0)

    -- Reload Store Items (SP ONLY)
    self.buttonReloadStoreItems:setDisabled(isMultiplayer)

    -- Refresh Sale System (SP ONLY)
    -- self.multiRefreshSaleSystem:setDisabled(isMultiplayer)
    -- self.buttonRefreshSaleSystem:setDisabled(isMultiplayer)
end

function EasyDevControlsGeneralFrame:onFrameOpening()
    g_messageCenter:subscribe(MessageType.TIMESCALE_CHANGED, self.onTimeScaleChanged, self)
end

-- Cheat Money (Add | Remove | Set)
function EasyDevControlsGeneralFrame:onEnterPressedCheatMoney(textInputElement, mouseClickedOutside)
    self:setInfoText(g_easyDevControls:cheatMoney(tonumber(textInputElement.text), EasyDevControlsMoneyEvent.getTypeByName(textInputElement.name), g_currentMission:getFarmId()))

    textInputElement:setText("")
    textInputElement.lastValidText = ""
end

function EasyDevControlsGeneralFrame:onTextChangedCheatMoney(textInputElement, text)
    -- Required because 'onIsUnicodeAllowedCallback' will not handle copy & paste feature that was added mid FS22 and there is no way to disable copy & paste.
    -- Not perfect but good enough to stop negative values when not required
    if not string.isNilOrWhitespace(text) then
        local numericValue = tonumber(text)

        if (textInputElement.name == "setMoney" and (text == "-" or numericValue ~= nil)) or ((numericValue or -1) > 0) then
            textInputElement.lastValidText = text
        else
            textInputElement:setText(textInputElement.lastValidText or "")
        end
    else
        textInputElement.lastValidText = ""
    end
end

-- Extra Time Scales
function EasyDevControlsGeneralFrame:onExtraTimeScalesCommandStateChanged(name, resetToDefault)
    local hasPermission = self:getHasPermission(name)

    if not resetToDefault then
        self.binaryTimeScale:setIsChecked(g_easyDevControlsSettings:getValue(name, false), self.isOpening, false) -- g_easyDevControls.customTimeScalesEnabled
    elseif hasPermission then
        self.binaryTimeScale:setIsChecked(g_easyDevControlsSettings:getDefaultValue(name, false), true, true)
    end

    self.binaryTimeScale:setDisabled(not hasPermission)
end

function EasyDevControlsGeneralFrame:onClickSetTimeScale(index, binaryOptionElement)
    if self:getHasPermission("extraTimeScales") then
        if index == BinaryOptionElement.STATE_RIGHT then
            if self:getCanShowDialogs() then
                local text = EasyDevControlsUtils.getText("easyDevControls_extraTimescalesWarning")

                InfoDialog.show(text, self.setExtraTimeScaleState, self, DialogElement.TYPE_WARNING, nil, nil, true, true)
            else
                self:setExtraTimeScaleState(true)
            end
        else
            self:setExtraTimeScaleState(false)
        end
    end
end

function EasyDevControlsGeneralFrame:setExtraTimeScaleState(enabled)
    if g_server ~= nil then
        g_easyDevControls:setCustomTimeScaleState(enabled, true)
        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_extraTimescalesInfo", EasyDevControlsUtils.getStateText(enabled)))
    else
        self:setInfoText(g_easyDevControls:clientSendEvent(EasyDevControlsTimeScaleEvent, enabled, false))
    end
end

-- Stop Time
function EasyDevControlsGeneralFrame:onClickStopTime(buttonElement)
    if self:getHasPermission("stopTime") then
        local timeScale = g_currentMission.missionInfo.timeScale > 0 and 0 or 1

        if g_server ~= nil then
            g_currentMission:setTimeScale(timeScale) -- Event handled by 'setTimeScale'

            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_stopTimeInfo", string.format("%.1fx", timeScale)))
        else
            g_easyDevControls:clientSendEvent(EasyDevControlsTimeScaleEvent, timeScale == 1, true)
        end
    else
        buttonElement:setDisabled(true)
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

function EasyDevControlsGeneralFrame:onTimeScaleChanged()
    self.buttonStopTime:applyProfile(g_currentMission.missionInfo.timeScale <= 0 and "edc_buttonStartTime" or "edc_buttonStopTime")
    self.buttonStopTime:setDisabled(not self:getHasPermission("stopTime"))
end

-- Hud (Visibility | Key)
function EasyDevControlsGeneralFrame:onClickHudVisibility(index, binaryOptionElement)
    if g_currentMission.hud ~= nil then
        if binaryOptionElement.id == "binaryHudVisibility" then
            local isChecked = binaryOptionElement:getIsChecked()

            if (not isChecked and not g_noHudModeEnabled) or (isChecked and g_noHudModeEnabled) then
                g_currentMission.hud:consoleCommandToggleVisibility()

                self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_hudVisibilityInfo", binaryOptionElement.texts[index]))
            end
        elseif binaryOptionElement.id == "binaryToggleHudInput" then
            if g_easyDevControls:setToggleHudInputEnabled(index == BinaryOptionElement.STATE_RIGHT) then
                self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_hudInputOnInfo", EasyDevControlsUtils.getText("input_EDC_TOGGLE_HUD")))
            else
                self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_hudInputOffInfo"))
            end
        end
    end
end

-- Delete Objects Key
function EasyDevControlsGeneralFrame:onClickDeleteObjectsKey(index, binaryOptionElement)
    local enabled = g_easyDevControls:setDeleteObjectsInputEnabled(index == BinaryOptionElement.STATE_RIGHT)
    local controlName = EasyDevControlsUtils.getText("input_EDC_OBJECT_DELETE")
    local stateText = binaryOptionElement.texts[enabled and 2 or 1]

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_deleteObjectsKeyInfo", controlName, stateText))
end

-- Show Bales / Pallets Locations
function EasyDevControlsGeneralFrame:onShowObjectLocationsCommandStateChanged(_, resetToDefault)
    local hotspotsManager = g_easyDevControlsHotspotsManager

    if hotspotsManager ~= nil then
        if not resetToDefault then
            self.binaryShowBaleLocations:setIsChecked(hotspotsManager.updateBales, self.isOpening, false)
            self.binaryShowPalletLocations:setIsChecked(hotspotsManager.updatePallets, self.isOpening, false)
        else
            self.binaryShowBaleLocations:setIsChecked(g_easyDevControlsSettings:getDefaultValue("showBaleLocations", false), true, true)
            self.binaryShowPalletLocations:setIsChecked(g_easyDevControlsSettings:getDefaultValue("showPalletLocations", false), true, true)
        end
    end
end

function EasyDevControlsGeneralFrame:onClickShowObjectLocations(state, binaryOptionElement)
    if binaryOptionElement == self.binaryShowBaleLocations then
        self:setInfoText(g_easyDevControls:showBaleLocations(state == BinaryOptionElement.STATE_RIGHT))
    elseif binaryOptionElement == self.binaryShowPalletLocations then
        self:setInfoText(g_easyDevControls:showPalletLocations(state == BinaryOptionElement.STATE_RIGHT))
    else
        self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
    end
end

-- Teleport Player or Vehicle
function EasyDevControlsGeneralFrame:onClickTeleport(index, multiTextOptionElement)
    local disabledTextInput = index ~= self.locationTeleportIndex and index ~= self.locationTeleportWorldIndex

    self.teleportIndex = index
    self.textInputTeleportXZ:setDisabled(not self:getHasPermission("teleport") or disabledTextInput)

    if self.textInputTeleportXZ.text ~= "" then
        self:onTextInputEscPressed(self.textInputTeleportXZ)
    end
end

function EasyDevControlsGeneralFrame:onTeleportEnterPressed(textInputElement, mouseClickedOutside)
    self:onClickTeleportConfirm(self.buttonTeleportConfirm)
end

function EasyDevControlsGeneralFrame:onTeleportTextChanged(textInputElement, text)
    if text ~= "" then
        local lastChar = text:sub(-1)
        local newText, numSpaces = text:gsub(" +"," ")

        if (lastChar == " " and numSpaces <= 1 and (textInputElement.lastValidText == nil or textInputElement.lastValidText ~= "")) or tonumber(lastChar) then
            textInputElement.lastValidText = newText

            if newText ~= text then
                textInputElement:setText(newText)
            end
        else
            textInputElement:setText(textInputElement.lastValidText)
        end
    else
        textInputElement.lastValidText = ""
    end
end

function EasyDevControlsGeneralFrame:onClickTeleportConfirm(buttonElement)
    local teleportIndex = self.teleportIndex
    local numFieldsEntries = self.numFieldsEntries
    local vehicle, isEntered = g_easyDevControls:getVehicle(true)

    if vehicle ~= nil and not isEntered then
        if vehicle:getOwnerFarmId() ~= g_currentMission:getFarmId() then
            self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidFarmVehicleWarning"), EasyDevControlsErrorCodes.INVALID_FARM)

            return
        end
    end

    local object = vehicle or g_localPlayer

    if teleportIndex <= self.numTeleportFarmland then
        self:onSelectTeleportLocation(object, teleportIndex, nil, nil)
    elseif teleportIndex == self.mapSelectTeleportIndex then
        g_gui:changeScreen(nil, EasyDevControlsTeleportScreen)
        g_easyDevControlsTeleportScreen:setReturnScreenClass(EasyDevControlsMenu)
        g_easyDevControlsTeleportScreen:setCallback(self.onSelectTeleportLocation, self, object)
    else
        local teleportToLocation = teleportIndex == self.locationTeleportIndex
        local teleportToWorldLocation = teleportIndex == self.locationTeleportWorldIndex

        if teleportToLocation or teleportToWorldLocation then
            local infoText, infoErrorCode = nil, nil

            if self.textInputTeleportXZ.text ~= "" then
                local mapPosition = self.textInputTeleportXZ.text:split(" ")
                local x = tonumber(mapPosition[1]) or -1
                local z = tonumber(mapPosition[2]) or -1

                if x > -1 and z > -1 then
                    infoText = g_easyDevControls:teleport(object, x, z, nil, teleportToWorldLocation)
                    self:onTextInputEscPressed(self.textInputTeleportXZ)
                else
                    infoText = EasyDevControlsUtils.getText("easyDevControls_invalidTeleportWarning")
                    infoErrorCode = EasyDevControlsErrorCodes.FAILED
                end
            else
                infoText = EasyDevControlsUtils.getText("easyDevControls_emptyTeleportWarning")
                infoErrorCode = EasyDevControlsErrorCodes.FAILED
            end

            self:setInfoText(infoText, infoErrorCode)
        end
    end
end

function EasyDevControlsGeneralFrame:onSelectTeleportLocation(object, posX, posZ, yRot)
    local infoText, infoErrorCode = g_easyDevControls:teleport(object, posX, posZ, yRot)

    self:setInfoText(infoText, infoErrorCode)
    -- TO_DO: Add Info text reply when using map selection in Multiplayer
end

-- Flip Vehicles
function EasyDevControlsGeneralFrame:onClickFlipVehicles(buttonElement)
    if self:getHasPermission("flipVehicles") then
        local vehicle, isEntered = g_easyDevControls:getVehicle(true, true)

        if (vehicle ~= nil and vehicle.rootNode ~= nil) and g_currentMission.hud ~= nil then
            local ingameMap = g_currentMission.hud:getIngameMap()

            if ingameMap ~= nil then
                if not isEntered and vehicle:getOwnerFarmId() ~= g_currentMission:getFarmId() then
                    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_invalidFarmVehicleWarning"), EasyDevControlsErrorCodes.INVALID_FARM)

                    return
                end

                local x, _, z = getTranslation(vehicle.rootNode)
                local dx, _, dz = localDirectionToWorld(vehicle.rootNode, 0, 0, 1)
                local yRot = MathUtil.getYRotationFromDirection(dx, dz)

                local normalizedPosX = EasyDevControlsUtils.getNoNilClamp((x + ingameMap.worldCenterOffsetX) / ingameMap.worldSizeX, 0, 1, x)
                local normalizedPosZ = EasyDevControlsUtils.getNoNilClamp((z + ingameMap.worldCenterOffsetZ) / ingameMap.worldSizeZ, 0, 1, z)

                g_easyDevControls:teleport(vehicle, normalizedPosX * ingameMap.worldSizeX, normalizedPosZ * ingameMap.worldSizeZ, yRot)
                self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_flipVehiclesInfo"))

                return
            end
        end
    else
        buttonElement:setDisabled(true)
    end

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_requestFailedMessage"), EasyDevControlsErrorCodes.FAILED)
end

-- Set FOV Angle
function EasyDevControlsGeneralFrame:onSetFOVAngleCommandStateChanged(name, resetToDefault)
    local fovY, isCustom = EasyDevControlsGeneralFrame.getCurrentFOVAngle()

    if self.textInputSetFOVAngle.setPlaceholderText ~= nil then
        self.textInputSetFOVAngle:setPlaceholderText(EasyDevControlsUtils.formatText("easyDevControls_setFovCurrentAngleInfo", fovY))
    end

    self.textInputSetFOVAngle.lastValidText = ""
    self.textInputSetFOVAngle:setText("")

    self.buttonResetFOVAngle:setDisabled(not isCustom)
end

function EasyDevControlsGeneralFrame:onSetFOVAngleEnterPressed(textInputElement, mouseClickedOutside)
    if textInputElement.text ~= "" then
        local fovY = tonumber(textInputElement.text)

        if fovY ~= nil then
            if fovY >= 0 then
                g_cameraManager:consoleCommandSetFOV(textInputElement.text)
                self:onSetFOVAngleCommandStateChanged("setFOVAngle", false)

                self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_setFovAngleInfo", fovY))
            else
                self:onClickResetFOVAngle(self.buttonResetFOVAngle)
            end

            return
        else
            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_setFOVAngleWarning", textInputElement.text), EasyDevControlsErrorCodes.FAILED)
        end

        textInputElement:setText("")
    end

    textInputElement.lastValidText = ""
end

function EasyDevControlsGeneralFrame:onClickResetFOVAngle(buttonElement)
    g_cameraManager:consoleCommandSetFOV("-1")
    self:onSetFOVAngleCommandStateChanged("setFOVAngle", false)

    local fovY = EasyDevControlsGeneralFrame.getCurrentFOVAngle()
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_resetFovAngleInfo", fovY))
end

function EasyDevControlsGeneralFrame:onSetFOVAngleTextChanged(textInputElement, text)
    if text ~= "" then
        local num = tonumber(text)

        if text == "-" or (num ~= nil and num >= -1) then
            textInputElement.lastValidText = text
        else
            textInputElement:setText(textInputElement.lastValidText)
        end
    else
        textInputElement.lastValidText = ""
    end
end

function EasyDevControlsGeneralFrame.getCurrentFOVAngle()
    local cameraManager = g_cameraManager
    local cameraNode = cameraManager.activeCameraNode

    if cameraNode ~= nil then
        local cameraInfo = cameraManager.cameraInfo[cameraNode]

        return math.round(math.deg(getFovY(cameraNode) or 0), 0), cameraInfo and cameraInfo.fovBackup ~= nil
    end

    return 0, false
end

-- Set Quality
function EasyDevControlsGeneralFrame:onClickSetQuality(index, multiTextOptionElement)
    local qualityValue = self.qualityValues[index]

    if qualityValue ~= nil then
        for key, setting in pairs (self.qualitySettings) do
             if index == EasyDevControlsGeneralFrame.USER_QUALITY_INDEX and setting.defualtValue ~= 0 then
                 setting.setFunc(setting.defualtValue)
             else
                 setting.setFunc(qualityValue)
             end
        end

        self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_setQualityInfo", self.qualityTexts[index] or EasyDevControlsUtils.getText("easyDevControls_userSetting")))
    end
end

function EasyDevControlsGeneralFrame.getSetQualityParams()
    return string.format("\n\n-    %s\n-    %s\n-    %s\n-    %s\n-    %s\n-    %s",
        g_i18n:getText("setting_objectDrawDistance"),
        g_i18n:getText("setting_LODDistance"),
        g_i18n:getText("setting_terrainLODDistance"),
        g_i18n:getText("setting_foliageDrawDistance"),
        g_i18n:getText("setting_foliageLODDistance"),
        g_i18n:getText("setting_volumeMeshTessellation")
    )
end

-- Collectables (SP ONLY)
function EasyDevControlsGeneralFrame:onClickShowCollectables(index, multiTextOptionElement)
    if not self.collectiblesDisabled and self:getHasPermission("showCollectables") then
        local collectiblesSystem = g_currentMission.collectiblesSystem

        if collectiblesSystem ~= nil then
            collectiblesSystem.hotspotThreshold = self.collectiblesThreshold[index]
            collectiblesSystem:updateHotspotState()

            self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_showCollectablesTitle"), multiTextOptionElement.texts[index]))
        end
    else
        multiTextOptionElement:setDisabled(true)
    end
end

-- Clear I3D Cache
function EasyDevControlsGeneralFrame:onClickClearI3DCache(buttonElement)
    local verbose = self.multiClearI3DCacheVerbose:getState() > 1
    local numOfSharedI3DFiles = getNumOfSharedI3DFiles()

    local resultText = string.format("Deleting %s shared i3d files", numOfSharedI3DFiles)

    if verbose then
        for i = 0, numOfSharedI3DFiles - 1 do
            local filename, references = getSharedI3DFilesData(i)
            resultText = string.format("%s\n    - File: %s  |  References: %d", resultText, filename, references)
        end
    end

    setFileLogPrefixTimestamp(not verbose)

    Logging.info(resultText)
    clearEntireSharedI3DFileCache()
    Logging.info("Deleted all shared i3d files")

    setFileLogPrefixTimestamp(g_logFilePrefixTimestamp)

    buttonElement:setDisabled(true)

    self:setInfoText(EasyDevControlsUtils.getText("easyDevControls_clearI3DCacheInfo"))
end

-- Reload Store Items
function EasyDevControlsGeneralFrame:onClickReloadStoreItems(buttonElement)
    -- Use oneShot message to cleanup store packs as they are duplicated when using console command, also should avoid clearing any items added by custom code.
    g_messageCenter:subscribeOneshot(MessageType.STORE_ITEMS_RELOADED, self.onStoreItemsReloaded, self)
    g_storeManager:consoleCommandReloadStoreItems()

    buttonElement:setDisabled(true)
end

function EasyDevControlsGeneralFrame:onStoreItemsReloaded()
    local storeManager = g_storeManager
    local numPacks = 0

    if storeManager.packs ~= nil then
        for name, pack in pairs (storeManager.packs) do
            local addedItems = {}
            local items = {}

            for _, itemFilename in ipairs (pack.items) do
                if not addedItems[itemFilename] then
                    addedItems[itemFilename] = true

                    table.insert(items, itemFilename)
                end
            end

            pack.items = items
            numPacks += 1
        end
    end

    local infoText = EasyDevControlsUtils.formatText("easyDevControls_reloadStoreItemsInfo", tostring(#storeManager.items))

    if numPacks > 0 then
        infoText = string.format("%s (%s: %d)", infoText, g_i18n:getText("ui_storePacks"), numPacks)
    end

    self:setInfoText(infoText)
end

-- Refresh Sale System
-- function EasyDevControlsGeneralFrame:onClickRefreshSaleSystem(buttonElement)
    -- VehicleSaleSystem:consoleCommandRefresh(self.multiRefreshSaleSystem:getState() - 1)
    -- self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_refreshSaleSystemInfo", tostring(g_currentMission.vehicleSaleSystem.numGeneratedItems or "??")))
-- end
