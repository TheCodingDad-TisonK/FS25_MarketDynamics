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

EasyDevControlsPlayerFrame = {}
EasyDevControlsPlayerFrame.NAME = "PLAYER"

EasyDevControlsPlayerFrame.JUMP_DELAY_DEFAULT_INDEX = 3
EasyDevControlsPlayerFrame.JUMP_DELAY_THRESHOLDS = {0, 0.5, 1, 1.5, 2}

EasyDevControlsPlayerFrame.JUMP_HEIGHT_DEFAULT_INDEX = 1
EasyDevControlsPlayerFrame.JUMP_UPFORCE = 5.5
EasyDevControlsPlayerFrame.JUMP_UPFORCE_MULTIPLIERS = {1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2}

EasyDevControlsPlayerFrame.RUN_SPEED_DEFAULT_INDEX = 3
EasyDevControlsPlayerFrame.RUN_SPEED_MULTIPLIERS = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}

local EasyDevControlsPlayerFrame_mt = Class(EasyDevControlsPlayerFrame, EasyDevControlsBaseFrame)

function EasyDevControlsPlayerFrame.register()
    local controller = EasyDevControlsPlayerFrame.new()
    local filename = EasyDevControlsUtils.getLocalFilename("gui/EasyDevControlsPlayerFrame.xml")

    g_gui:loadGui(filename, "EasyDevControlsPlayerFrame", controller, true)

    return controller
end

function EasyDevControlsPlayerFrame.new(target, custom_mt)
    local self = EasyDevControlsBaseFrame.new(nil, custom_mt or EasyDevControlsPlayerFrame_mt)

    self.pageName = EasyDevControlsPlayerFrame.NAME

    self:setCommandChangedCallback("superStrength", EasyDevControlsPlayerFrame.onCommandChangedSuperStrength)
    self:setCommandChangedCallback("flightMode", EasyDevControlsPlayerFrame.onCommandChangedFlightMode)
    self:setCommandChangedCallback("runSpeedState", EasyDevControlsPlayerFrame.onCommandChangedRunSpeed)
    self:setCommandChangedCallback("playerNoClip", EasyDevControlsPlayerFrame.onCommandChangedNoClip)

    return self
end

function EasyDevControlsPlayerFrame.createFromExistingGui(gui, guiName)
    EasyDevControlsPlayerFrame.register()
end

function EasyDevControlsPlayerFrame:initialize()
    -- Jump Delay
    local groundTimeThresholdTexts = table.create(#EasyDevControlsPlayerFrame.JUMP_DELAY_THRESHOLDS)
    local formattedSecondsText = EasyDevControlsUtils.getText("easyDevControls_formattedSeconds"):gsub("%%d", "%%.1f")

    for i, threshold in ipairs (EasyDevControlsPlayerFrame.JUMP_DELAY_THRESHOLDS) do
        if i == 1 then
            table.insert(groundTimeThresholdTexts, g_i18n:getText("ui_none"))
        elseif i == EasyDevControlsPlayerFrame.JUMP_DELAY_DEFAULT_INDEX then
            table.insert(groundTimeThresholdTexts, g_i18n:getText("configuration_valueDefault"))
        else
            table.insert(groundTimeThresholdTexts, string.format(formattedSecondsText, threshold))
        end
    end

    self.multiJumpDelay:setTexts(groundTimeThresholdTexts)

    -- Jump Multiplier
    local jumpMultiplierTexts = table.create(#EasyDevControlsPlayerFrame.JUMP_UPFORCE_MULTIPLIERS)

    for i, multiplier in ipairs (EasyDevControlsPlayerFrame.JUMP_UPFORCE_MULTIPLIERS) do
        if i > 1 then
            table.insert(jumpMultiplierTexts, string.format("%.1fx", multiplier))
        else
            table.insert(jumpMultiplierTexts, g_i18n:getText("ui_off"))
        end
    end

    self.multiJumpMultiplier:setTexts(jumpMultiplierTexts)

    -- Run Speed
    local runSpeedMultiplierTexts = table.create(#EasyDevControlsPlayerFrame.RUN_SPEED_MULTIPLIERS)

    for _, multiplier in ipairs (EasyDevControlsPlayerFrame.RUN_SPEED_MULTIPLIERS) do
        table.insert(runSpeedMultiplierTexts, string.format("%dx", multiplier))
    end

    self.multiRunSpeedMultiplier:setTexts(runSpeedMultiplierTexts)

    -- Set Farm (TO_DO: FS25)
    self.multiSetFarmObject:setDisabled(true)
    self.multiSetFarm:setDisabled(true)
    self.buttonConfirmSetFarm:setDisabled(true)
end

function EasyDevControlsPlayerFrame:onUpdateCommands(resetToDefault)
    local binarySkipAnimation = self.isOpening
    local easyDevControlsSettings = g_easyDevControlsSettings

    -- Super Strength
    self:onCommandChangedSuperStrength("superStrength", resetToDefault)

    -- Flight Mode / State
    self:onCommandChangedFlightMode("flightMode", resetToDefault)

    -- No Clip
    self:onCommandChangedNoClip("playerNoClip", resetToDefault)

    if not resetToDefault then
        -- Super Strength Key
        self.binarySuperStrengthKey:setIsChecked(g_easyDevControls.superStrengthKeyEnabled, binarySkipAnimation, false)

        -- Jump Delay
        self.multiJumpDelay:setState(Utils.getValueIndex(PlayerStateJump.MINIMUM_GROUND_TIME_THRESHOLD, EasyDevControlsPlayerFrame.JUMP_DELAY_THRESHOLDS))

        -- Jump Multiplier
        local defaultJumpUpForce = EasyDevControlsPlayerFrame.JUMP_UPFORCE
        local currentJumpUpForce = PlayerStateJump.JUMP_UPFORCE
        local multiState = 1

        for i, multiplier in ipairs (EasyDevControlsPlayerFrame.JUMP_UPFORCE_MULTIPLIERS) do
            multiState = i

            if defaultJumpUpForce * multiplier >= currentJumpUpForce then
                break
            end
        end

        self.multiJumpMultiplier:setState(multiState)

        -- Run Speed
        self.multiRunSpeedMultiplier:setState(easyDevControlsSettings:getValue("runSpeedIndex", EasyDevControlsPlayerFrame.RUN_SPEED_DEFAULT_INDEX))
        self:onCommandChangedRunSpeed("runSpeedState", false)

        -- Run Speed Key
        self.binaryRunSpeedKey:setIsChecked(easyDevControlsSettings:getValue("runSpeedKey", false), binarySkipAnimation, false)

        -- Wood Cutting Marker
        self.binaryWoodCuttingMarker:setIsChecked(g_woodCuttingMarkerEnabled == true, binarySkipAnimation, false)

        -- Aim Overlay / Marker
        local isVisible = true
        local player = g_localPlayer

        if player ~= nil and player.hands ~= nil then
            local spec = player.hands.spec_hands

            if spec.crosshair ~= nil then
                isVisible = spec.crosshair:getIsVisible()
            end
        end

        self.binaryAimOverlay:setIsChecked(isVisible, binarySkipAnimation, false)
    else
        -- Super Strength Key
        self.binarySuperStrengthKey:setIsChecked(easyDevControlsSettings:getDefaultValue("superStrengthKey", false), binarySkipAnimation, true)

        -- Jump Delay
        self.multiJumpDelay:setState(easyDevControlsSettings:getDefaultValue("jumpDelayIndex", EasyDevControlsPlayerFrame.JUMP_DELAY_DEFAULT_INDEX), true)

        -- Jump Multiplier
        self.multiJumpMultiplier:setState(easyDevControlsSettings:getDefaultValue("jumpHeightIndex", 1), true)

        -- Run Speed
        self.multiRunSpeedMultiplier:setState(easyDevControlsSettings:getDefaultValue("runSpeedIndex", EasyDevControlsPlayerFrame.RUN_SPEED_DEFAULT_INDEX), true)
        self:onCommandChangedRunSpeed("runSpeedState", true)

        -- Run Speed Key
        self.binaryRunSpeedKey:setIsChecked(easyDevControlsSettings:getDefaultValue("runSpeedKey", false), binarySkipAnimation, true)

        -- Wood Cutting Marker
        self.binaryWoodCuttingMarker:setIsChecked(easyDevControlsSettings:getDefaultValue("woodCuttingMarker", true), binarySkipAnimation, true)

        -- Aim Overlay / Marker
        self.binaryAimOverlay:setIsChecked(easyDevControlsSettings:getDefaultValue("aimOverlay", true), binarySkipAnimation, true)
    end

    -- Player Debug Display
    for _, element in ipairs (self.binaryDebugDisplay) do
        local flag

        if not resetToDefault then
            flag = Player.DEBUG_DISPLAY_FLAG[element.name]
        end

        element:setIsChecked(flag ~= nil and bit32.band(flag, Player.currentDebugFlag) ~= 0, binarySkipAnimation, resetToDefault)
    end
end

-- Super Strength
function EasyDevControlsPlayerFrame:onCommandChangedSuperStrength(name, resetToDefault)
    local hasPermission = self:getHasPermission(name)

    if g_localPlayer ~= nil and g_localPlayer.hands ~= nil then
        if not resetToDefault then
            local hasSuperStrength = g_localPlayer.hands.spec_hands.hasSuperStrength == true

            self.binarySuperStrength:setIsChecked(hasSuperStrength and g_easyDevControlsSettings:getValue(name), self.isOpening, false)
        elseif hasPermission then
            self.binarySuperStrength:setIsChecked(g_easyDevControlsSettings:getDefaultValue(name, false), true, true)
        end
    else
        hasPermission = false
    end

    self.binarySuperStrength:setDisabled(not hasPermission)
end

function EasyDevControlsPlayerFrame:onClickSuperStrength(state, binaryOptionElement)
    if self:getHasPermission("superStrength") then
        self:setInfoText(g_easyDevControls:setSuperStrengthState(state == BinaryOptionElement.STATE_RIGHT))
    end
end

-- Super Strength Key
function EasyDevControlsPlayerFrame:onClickSuperStrengthKey(state, binaryOptionElement)
    local isEnabled = g_easyDevControls:setSuperStrengthInputEnabled(state == BinaryOptionElement.STATE_RIGHT)
    local controlName = EasyDevControlsUtils.getText("input_EDC_SUPER_STRENGTH")
    local stateText = binaryOptionElement.texts[isEnabled and 2 or 1]

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_superStrengthKeyInfo", controlName, stateText))
end

-- Flight Mode / State
function EasyDevControlsPlayerFrame:onCommandChangedFlightMode(name, resetToDefault)
    local flightModeAvailable = false
    local flightModeActive = false

    if g_localPlayer ~= nil and g_localPlayer.toggleFlightModeCommand ~= nil then
        flightModeAvailable = true

        if not resetToDefault then
            flightModeActive = g_localPlayer.toggleFlightModeCommand.value == true

            self.binaryFlightModeToggle:setIsChecked(flightModeActive, self.isOpening, false)
            self.binaryFlightModeState:setIsChecked(g_localPlayer.mover.isFlightActive == true, self.isOpening, false)
        else
            self.binaryFlightModeToggle:setIsChecked(false, true, true)
            self.binaryFlightModeState:setIsChecked(false, true, true)
        end
    else
        self.binaryFlightModeToggle:setIsChecked(false, true, false)
        self.binaryFlightModeState:setIsChecked(false, true, false)
    end

    self.binaryFlightModeToggle:setDisabled(not flightModeAvailable)
    self.binaryFlightModeState:setDisabled(not flightModeActive)
end

function EasyDevControlsPlayerFrame:onClickFlightMode(state, binaryOptionElement)
    local player = g_localPlayer

    if player ~= nil and player.toggleFlightModeCommand ~= nil then
        local isEnabled = binaryOptionElement:getIsChecked()

        g_easyDevControls.updatingFlightMode = true

        if binaryOptionElement.id == "binaryFlightModeToggle" then
            if isEnabled then
                player.toggleFlightModeCommand:enableValue()
            else
                player.toggleFlightModeCommand:disableValue()
            end

            self.binaryFlightModeState:setIsChecked(player.mover.isFlightActive, self.isOpening)
            self.binaryFlightModeState:setDisabled(not player.toggleFlightModeCommand.value)

            self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_flightModeToggleInfo", binaryOptionElement.texts[state]))
        elseif binaryOptionElement.id == "binaryFlightModeState" then
            if player.toggleFlightModeCommand.value then
                player.mover:setFlightActive(isEnabled, true)

                -- g_inputBinding:setActionEventActive(player.upDownFlightActionId, isEnabled) -- In the wrong context for this to update so use my method :-)
                EasyDevControlsUtils.setEventActiveInContext(PlayerInputComponent.INPUT_CONTEXT_NAME, InputAction.DEBUG_PLAYER_UP_DOWN, isEnabled, true)

                local text = player.mover.isFlightActive and "easyDevControls_flightModeStateOnInfo" or "easyDevControls_flightModeStateOffInfo"
                self:setInfoText(EasyDevControlsUtils.formatText(text, binaryOptionElement.texts[state]))
            else
                binaryOptionElement:setIsChecked(false, self.isOpening)
                binaryOptionElement:setDisabled(true)
            end
        end

        g_easyDevControls.updatingFlightMode = nil
    end
end

-- Jump Delay
function EasyDevControlsPlayerFrame:onClickJumpDelay(state, multiTextOptionElement)
    g_easyDevControls:setPlayerJumpDelay(state)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_jumpDelayInfo", multiTextOptionElement.texts[state]))
end

function EasyDevControlsPlayerFrame.getMinimumGroundTimeThreshold(state)
    return EasyDevControlsPlayerFrame.JUMP_DELAY_THRESHOLDS[state] or 1
end

-- Jump Multiplier
function EasyDevControlsPlayerFrame:onClickJumpMultiplier(state, multiTextOptionElement)
    g_easyDevControls:setPlayerJumpMultiplier(state)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_jumpMultiplierInfo", multiTextOptionElement.texts[state]))
end

function EasyDevControlsPlayerFrame.getJumpUpForce(state)
    return EasyDevControlsPlayerFrame.JUMP_UPFORCE * (EasyDevControlsPlayerFrame.JUMP_UPFORCE_MULTIPLIERS[state] or 1)
end

-- Run Speed
function EasyDevControlsPlayerFrame:onCommandChangedRunSpeed(name, resetToDefault)
    if not resetToDefault then
        self.binaryRunSpeedState:setIsChecked(g_easyDevControlsSettings:getValue(name, false), self.isOpening, false)
    else
        self.binaryRunSpeedState:setIsChecked(g_easyDevControlsSettings:getDefaultValue(name, false), true, true)
    end
end

function EasyDevControlsPlayerFrame:onClickRunSpeed(state, multiTextOptionElement)
    g_easyDevControls:setRunSpeedMultiplier(state)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_runSpeedInfo", multiTextOptionElement.texts[state]))
end

function EasyDevControlsPlayerFrame:onClickRunSpeedState(state, binaryOptionElement)
    g_easyDevControls:setRunSpeedState(state == BinaryOptionElement.STATE_RIGHT)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_runSpeedStateInfo", binaryOptionElement.texts[state]))
end

-- Run Speed Key
function EasyDevControlsPlayerFrame:onClickRunSpeedKey(state, binaryOptionElement)
    g_easyDevControls:setRunSpeedInputEnabled(state == BinaryOptionElement.STATE_RIGHT)
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_runSpeedKeyInfo", EasyDevControlsUtils.getText("input_EDC_PLAYER_RUN_SPEED"), binaryOptionElement.texts[state]))
end

function EasyDevControlsPlayerFrame.getRunSpeedMultiplier(state)
    return EasyDevControlsPlayerFrame.RUN_SPEED_MULTIPLIERS[state] or 1
end

-- No Clip
function EasyDevControlsPlayerFrame:onCommandChangedNoClip(name, resetToDefault)
    if not resetToDefault then
        self.binaryNoClip:setIsChecked(g_easyDevControls.playerNoClipEnabled, self.isOpening, false)
    else
        self.binaryNoClip:setIsChecked(false, true, true)
    end

    self.binaryNoClip:setDisabled(not self:getHasPermission(name))
end

function EasyDevControlsPlayerFrame:onClickNoClip(state, binaryOptionElement)
    g_easyDevControls.updatingPlayerNoClip = true

    if g_localPlayer ~= nil and g_localPlayer.toggleNoClipCommand ~= nil then
        if state == BinaryOptionElement.STATE_RIGHT then
            g_localPlayer.toggleNoClipCommand:disableValue()
            g_localPlayer.toggleNoClipCommand:enableValue("false") -- No need to clip terrain for most users, they can use the console command if they need this.

            self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_noClipTitle"), EasyDevControlsUtils.getText("easyDevControls_enabled")))
        else
            g_localPlayer.toggleNoClipCommand:disableValue()
            self:setInfoText(string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_noClipTitle"), EasyDevControlsUtils.getText("easyDevControls_disabled")))
        end
    end

    g_easyDevControls.updatingPlayerNoClip = nil
end

-- Wood Cutting Marker
function EasyDevControlsPlayerFrame:onClickWoodCuttingMarker(state, binaryOptionElement)
    g_woodCuttingMarkerEnabled = state == BinaryOptionElement.STATE_RIGHT
    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_woodCuttingMarkerInfo", binaryOptionElement.texts[g_woodCuttingMarkerEnabled and 2 or 1]))
end

-- Aim Overlay / Marker
function EasyDevControlsPlayerFrame:onClickAimOverlay(state, binaryOptionElement)
    if g_localPlayer ~= nil and g_localPlayer.hands ~= nil then
        local spec = g_localPlayer.hands.spec_hands

        if spec.crosshair ~= nil then
            spec.crosshair:setIsVisible(state == BinaryOptionElement.STATE_RIGHT)
        end
    end

    self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_aimOverlayInfo", binaryOptionElement.texts[state]))
end

-- Player Debug
function EasyDevControlsPlayerFrame:onClickPlayerDebugDisplay(state, binaryOptionElement)
    if g_localPlayer ~= nil then
        local name = binaryOptionElement.name
        local flag = Player.DEBUG_DISPLAY_FLAG[name]

        if flag ~= nil then
            local stateText = ""

            if bit32.band(flag, Player.currentDebugFlag) == 0 then
                if state == BinaryOptionElement.STATE_RIGHT then
                    stateText = EasyDevControlsUtils.getText("easyDevControls_enabled"):lower()
                end
            else
                if state == BinaryOptionElement.STATE_LEFT then
                    stateText = EasyDevControlsUtils.getText("easyDevControls_disabled"):lower()
                end
            end

            if stateText ~= "" then
                g_localPlayer:consoleCommandToggleDebugFlag(name)
                self:setInfoText(EasyDevControlsUtils.formatText("easyDevControls_playerDebugDisplayInfo", name, stateText))
            end
        end
    end
end
