-- SettingsUI.lua
-- Injects Market Dynamics settings into ESC > Settings > General Settings.
-- Follows the proven RWE/NPCFavor pattern (Utils.appendedFunction at file-load time).
--
-- HOW TO ADD A NEW SETTING:
--   1. Add a field to MarketDynamics.settings in MarketDynamics.lua
--   2. Add save/load to MarketSerializer.lua
--   3. Add a frame element below in addSettingsElements()
--   4. Add a refresh line in updateSettingsUI()
--   5. Add a callback handler in the Callback Handlers section
--
-- Author: tison (dev-1)

MDMSettingsUI = {}

-- ---------------------------------------------------------------------------
-- Option tables for MultiTextOption dropdowns
-- (display strings and corresponding internal values)
-- ---------------------------------------------------------------------------

MDMSettingsUI.volatilityOptions = { "Low", "Normal", "High", "Extreme" }
MDMSettingsUI.volatilityValues  = { 0.5,   1.0,     1.5,   2.0 }

-- ---------------------------------------------------------------------------
-- Hook: called when ESC > Settings frame opens
-- 'self' is the InGameMenuSettingsFrame instance
-- ---------------------------------------------------------------------------

function MDMSettingsUI:onFrameOpen()
    if not self.mdm_initDone then
        MDMSettingsUI:addSettingsElements(self)

        self.gameSettingsLayout:invalidateLayout()

        if self.updateAlternatingElements then
            self:updateAlternatingElements(self.gameSettingsLayout)
        end
        if self.updateGeneralSettings then
            self:updateGeneralSettings(self.gameSettingsLayout)
        end

        self.mdm_initDone = true
        MDMLog.info("SettingsUI: controls added to InGameMenuSettingsFrame")
    end

    MDMSettingsUI:updateSettingsUI(self)
end

-- ---------------------------------------------------------------------------
-- Add all settings elements to the game settings layout
-- To add a section, call addSectionHeader(). For a toggle, addBinaryOption().
-- For a multi-value dropdown, addMultiTextOption().
-- ---------------------------------------------------------------------------

function MDMSettingsUI:addSettingsElements(frame)

    -- ── Section: Market Dynamics ──────────────────────────────────────────
    MDMSettingsUI:addSectionHeader(frame, "Market Dynamics")

    -- Toggle: enable/disable MDM price overrides entirely.
    -- When off, vanilla prices are used; all other systems keep running.
    frame.mdm_pricesEnabled = MDMSettingsUI:addBinaryOption(
        frame,
        "onMDMPricesEnabledChanged",
        "Dynamic Prices",
        "Enable market-driven price fluctuations. Off = vanilla prices."
    )

    -- Dropdown: scale the intensity of intraday + daily price movements.
    -- Low = gentle drift, Extreme = wild swings.
    frame.mdm_volatility = MDMSettingsUI:addMultiTextOption(
        frame,
        "onMDMVolatilityChanged",
        MDMSettingsUI.volatilityOptions,
        "Price Volatility",
        "How strongly prices fluctuate each day. Low=±1%, Normal=±2%, High=±3%, Extreme=±4%"
    )

    -- ── Section: BetterContracts Integration ─────────────────────────────
    -- Only useful when FS25_BetterContracts is installed.
    -- The toggle is always shown so players know the feature exists.
    MDMSettingsUI:addSectionHeader(frame, "BetterContracts Integration")

    -- Toggle: when on, supply spikes fire on BC harvest completions and
    -- the MDM futures UI is suppressed in favour of BC's contract system.
    frame.mdm_bcMode = MDMSettingsUI:addBinaryOption(
        frame,
        "onMDMBCModeChanged",
        "Use BetterContracts",
        "Requires FS25_BetterContracts. Enables supply reactions and suppresses MDM futures UI."
    )

    -- ── Section: Developer / Debug ────────────────────────────────────────
    MDMSettingsUI:addSectionHeader(frame, "Market Dynamics — Debug")

    -- Toggle: verbose [MDM] DEBUG lines in log.txt. Off in normal play.
    frame.mdm_debugMode = MDMSettingsUI:addBinaryOption(
        frame,
        "onMDMDebugModeChanged",
        "Debug Logging",
        "Write verbose [MDM] DEBUG lines to log.txt. For developers only."
    )

    -- ── ADD NEW SETTINGS ABOVE THIS LINE ─────────────────────────────────
end

-- ---------------------------------------------------------------------------
-- Refresh UI element states from current settings values.
-- Called every time the settings frame opens (values may have changed via console).
-- ---------------------------------------------------------------------------

function MDMSettingsUI:updateSettingsUI(frame)
    if not frame.mdm_initDone then return end

    local settings = g_MarketDynamics and g_MarketDynamics.settings
    if not settings then return end

    if frame.mdm_pricesEnabled then
        frame.mdm_pricesEnabled:setIsChecked(settings.pricesEnabled == true, false, false)
    end

    if frame.mdm_volatility then
        frame.mdm_volatility:setState(MDMSettingsUI:findValueIndex(
            MDMSettingsUI.volatilityValues,
            g_MarketDynamics.marketEngine and g_MarketDynamics.marketEngine.volatilityScale or 1.0
        ))
    end

    if frame.mdm_bcMode then
        if not BCIntegration.isAvailable() then
            -- Grey it out visually by forcing off and leaving the tooltip to explain
            frame.mdm_bcMode:setIsChecked(false, false, false)
        else
            frame.mdm_bcMode:setIsChecked(BCIntegration.isEnabled(), false, false)
        end
    end

    if frame.mdm_debugMode then
        frame.mdm_debugMode:setIsChecked(MDMLog.debugEnabled == true, false, false)
    end
end

function MDMSettingsUI:updateGameSettings()
    -- 'self' is InGameMenuSettingsFrame
    MDMSettingsUI:updateSettingsUI(self)
end

-- ---------------------------------------------------------------------------
-- Callback Handlers
-- Each handler is called with (self=MDMSettingsUI, state) when the player
-- clicks a setting. state is BinaryOptionElement.STATE_RIGHT (1) for "Yes",
-- or a 1-based index for MultiTextOption dropdowns.
-- ---------------------------------------------------------------------------

function MDMSettingsUI:onMDMPricesEnabledChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    local enabled = (state == BinaryOptionElement.STATE_RIGHT)
    g_MarketDynamics.settings.pricesEnabled = enabled
    MDMLog.info("SettingsUI: pricesEnabled = " .. tostring(enabled))
end

function MDMSettingsUI:onMDMVolatilityChanged(state)
    local scale = MDMSettingsUI.volatilityValues[state] or 1.0
    if g_MarketDynamics and g_MarketDynamics.marketEngine then
        g_MarketDynamics.marketEngine.volatilityScale = scale
    end
    MDMLog.info("SettingsUI: volatilityScale = " .. tostring(scale))
end

function MDMSettingsUI:onMDMBCModeChanged(state)
    local enabled = (state == BinaryOptionElement.STATE_RIGHT)
    if not BCIntegration.isAvailable() and enabled then
        MDMLog.warn("SettingsUI: BetterContracts not installed — BC mode cannot be enabled")
        return
    end
    BCIntegration.setEnabled(enabled)
end

function MDMSettingsUI:onMDMDebugModeChanged(state)
    MDMLog.debugEnabled = (state == BinaryOptionElement.STATE_RIGHT)
    MDMLog.info("SettingsUI: debugMode = " .. tostring(MDMLog.debugEnabled))
end

-- ---------------------------------------------------------------------------
-- GUI Element Builders (FS25 profile-based — do not clone, always loadProfile)
-- ---------------------------------------------------------------------------

function MDMSettingsUI:addSectionHeader(frame, text)
    local textElement = TextElement.new()
    local profile = g_gui:getProfile("fs25_settingsSectionHeader")
    textElement.name = "sectionHeader"
    textElement:loadProfile(profile, true)
    textElement:setText(text)
    frame.gameSettingsLayout:addElement(textElement)
    textElement:onGuiSetupFinished()
end

function MDMSettingsUI:addBinaryOption(frame, callbackName, title, tooltip)
    local bitMap = BitmapElement.new()
    bitMap:loadProfile(g_gui:getProfile("fs25_multiTextOptionContainer"), true)

    local binaryOption = BinaryOptionElement.new()
    binaryOption.useYesNoTexts = true
    binaryOption:loadProfile(g_gui:getProfile("fs25_settingsBinaryOption"), true)
    binaryOption.target = MDMSettingsUI
    binaryOption:setCallback("onClickCallback", callbackName)

    local titleElement = TextElement.new()
    titleElement:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOptionTitle"), true)
    titleElement:setText(title)

    local tooltipElement = TextElement.new()
    tooltipElement.name = "ignore"
    tooltipElement:loadProfile(g_gui:getProfile("fs25_multiTextOptionTooltip"), true)
    tooltipElement:setText(tooltip)

    binaryOption:addElement(tooltipElement)
    bitMap:addElement(binaryOption)
    bitMap:addElement(titleElement)

    binaryOption:onGuiSetupFinished()
    titleElement:onGuiSetupFinished()
    tooltipElement:onGuiSetupFinished()
    frame.gameSettingsLayout:addElement(bitMap)
    bitMap:onGuiSetupFinished()

    return binaryOption
end

function MDMSettingsUI:addMultiTextOption(frame, callbackName, texts, title, tooltip)
    local bitMap = BitmapElement.new()
    bitMap:loadProfile(g_gui:getProfile("fs25_multiTextOptionContainer"), true)

    local multiTextOption = MultiTextOptionElement.new()
    multiTextOption:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOption"), true)
    multiTextOption.target = MDMSettingsUI
    multiTextOption:setCallback("onClickCallback", callbackName)
    multiTextOption:setTexts(texts)

    local titleElement = TextElement.new()
    titleElement:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOptionTitle"), true)
    titleElement:setText(title)

    local tooltipElement = TextElement.new()
    tooltipElement.name = "ignore"
    tooltipElement:loadProfile(g_gui:getProfile("fs25_multiTextOptionTooltip"), true)
    tooltipElement:setText(tooltip)

    multiTextOption:addElement(tooltipElement)
    bitMap:addElement(multiTextOption)
    bitMap:addElement(titleElement)

    multiTextOption:onGuiSetupFinished()
    titleElement:onGuiSetupFinished()
    tooltipElement:onGuiSetupFinished()
    frame.gameSettingsLayout:addElement(bitMap)
    bitMap:onGuiSetupFinished()

    return multiTextOption
end

-- Returns the index in `values` whose entry is closest to `target`.
function MDMSettingsUI:findValueIndex(values, target)
    local bestIdx  = 1
    local bestDiff = math.huge
    for i, v in ipairs(values) do
        local diff = math.abs(v - target)
        if diff < bestDiff then
            bestDiff = diff
            bestIdx  = i
        end
    end
    return bestIdx
end

-- ---------------------------------------------------------------------------
-- Hook installation — runs once at file-load time
-- ---------------------------------------------------------------------------

local function initHooks()
    if not InGameMenuSettingsFrame then return end

    InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(
        InGameMenuSettingsFrame.onFrameOpen,
        MDMSettingsUI.onFrameOpen
    )

    if InGameMenuSettingsFrame.updateGameSettings then
        InGameMenuSettingsFrame.updateGameSettings = Utils.appendedFunction(
            InGameMenuSettingsFrame.updateGameSettings,
            MDMSettingsUI.updateGameSettings
        )
    end

    MDMLog.info("SettingsUI: hooks installed on InGameMenuSettingsFrame")
end

initHooks()
