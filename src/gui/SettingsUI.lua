-- SettingsUI.lua
-- Adds a dedicated "Market Dynamics" tab to ESC > Settings.
-- All GUI elements are created programmatically (no g_gui:loadGui / XML needed).
-- g_gui:loadGui requires a proper frame subclass as controller — plain tables
-- and even bare GuiElement instances cause "missing method" crashes in Gui.lua.
--
-- Lifecycle:
--   1. initHooks()       — at source time: appends to InGameMenuSettingsFrame.onFrameOpen
--   2. MDMSettingsUI.initGui(modDir) — called from MarketDynamics:onMissionLoaded (marks ready)
--   3. onFrameOpen (first call) — builds all elements, inserts tab, hooks paging
--   4. onFrameOpen (subsequent) — refreshes element states from current settings
--
-- HOW TO ADD A NEW SETTING:
--   1. Add a default value to MarketDynamics.settings in MarketDynamics.lua
--   2. Add save/load in MarketSerializer.lua
--   3. Call _addBinary() or _addMulti() in _addSettingsElements()
--   4. Add a refresh line in _updateSettingsUI()
--   5. Add a callback handler in the Callback Handlers section below
--
-- Author: tison (dev-1)

MDMSettingsUI = {}

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------

local _modDir      = g_currentModDirectory  -- captured at source time
local _guiLoaded   = false  -- g_gui:loadGui completed
local _tabInserted = false  -- tab injected into settings frame

-- Stored element references (set in addSettingsElements, read in updateSettingsUI)
local _elem = {}

-- Option values for dropdowns (parallel to display strings)
local VOLATILITY_VALUES      = { 0.5, 1.0, 1.5, 2.0 }
local EVENT_FREQUENCY_VALUES = { 0.4, 1.0, 2.0 }
local FUTURES_PENALTY_VALUES = { 0.08, 0.15, 0.25 }

-- ---------------------------------------------------------------------------
-- XML controller callbacks (called by the game from XML onClick="...")
-- ---------------------------------------------------------------------------

-- Called when the player clicks our tab button in the settings navigation bar.
function MDMSettingsUI:onClickMDM()
    local ps = g_inGameMenu and g_inGameMenu.pageSettings
    if not ps or not MDMSettingsUI.modPageNr then return end
    ps.subCategoryPaging:setState(MDMSettingsUI.modPageNr, true)
    -- Set header text directly after setState — vanilla updateSubCategoryPages
    -- runs inside setState and may show a missing-key error; this overrides it.
    if ps.categoryHeaderText then
        ps.categoryHeaderText:setText(g_i18n:getText("mdm_screen_title") or "Market Dynamics")
    end
end

-- ---------------------------------------------------------------------------
-- Initialisation — called from MarketDynamics:onMissionLoaded
-- ---------------------------------------------------------------------------

function MDMSettingsUI.initGui(modDir)
    if _guiLoaded then return end
    -- All elements are built programmatically in _insertTab — nothing to load here.
    _guiLoaded = true
    MDMLog.info("SettingsUI: ready — tab will be built on first settings open")
end

-- ---------------------------------------------------------------------------
-- Hook: InGameMenuSettingsFrame.onFrameOpen
-- 'self' is the InGameMenuSettingsFrame instance
-- ---------------------------------------------------------------------------

function MDMSettingsUI.onFrameOpen(self)
    if not _guiLoaded then return end

    -- Re-validate on every open: if the frame was rebuilt, or SERVER SETTINGS
    -- (MP) or another mod displaced our tab, detect it and allow re-insertion.
    if _tabInserted and MDMSettingsUI.mdmTab then
        local ps = g_inGameMenu and g_inGameMenu.pageSettings
        local found = false
        if ps then
            for i, tab in ipairs(ps.subCategoryTabs) do
                if tab == MDMSettingsUI.mdmTab then
                    MDMSettingsUI.modPageNr = i  -- sync if position shifted
                    found = true
                    break
                end
            end
        end
        if not found then
            _tabInserted = false
            MDMSettingsUI.mdmTab         = nil
            MDMSettingsUI.mdmPage        = nil
            MDMSettingsUI.settingsLayout = nil
        end
    end

    if not _tabInserted then
        if MDMSettingsUI._insertTab() then
            _tabInserted = true
        else
            return  -- not ready yet — try again next open
        end
    end

    MDMSettingsUI._updateSettingsUI()
end

-- ---------------------------------------------------------------------------
-- Tab insertion — runs once, on the first settings frame open after initGui
-- ---------------------------------------------------------------------------

function MDMSettingsUI._insertTab()
    local ps = g_inGameMenu and g_inGameMenu.pageSettings
    if not ps then
        MDMLog.warn("SettingsUI: pageSettings not available yet")
        return false
    end

    -- ── Position: always last tab ──────────────────────────────────────────
    -- Use the larger of subCategoryTabs and subCategoryPages so we land after
    -- any tab (e.g. the MP SERVER SETTINGS tab) that may be registered in one
    -- array but not yet the other at the time of insertion.
    local tabCount  = #ps.subCategoryTabs
    local pageCount = ps.subCategoryPages and #ps.subCategoryPages or tabCount
    local pos = math.max(tabCount, pageCount) + 1
    MDMSettingsUI.modPageNr = pos

    -- Helper: reparent element and insert at exact position (same as BC's addElementAtPosition)
    local function addAt(element, target, insertPos)
        if element.parent then element.parent:removeElement(element) end
        table.insert(target.elements, insertPos, element)
        element.parent = target
    end

    -- ── Tab button ─────────────────────────────────────────────────────────
    local mdmTab = ButtonElement.new()
    mdmTab:loadProfile(g_gui:getProfile("fs25_subCategorySelectorTabbedTab"), true)
    mdmTab.textUpperCase = false
    mdmTab:setText(g_i18n:getText("mdm_screen_title") or "Market Dynamics")
    mdmTab.target = MDMSettingsUI
    mdmTab:setCallback("onClickCallback", "onClickMDM")
    -- onGuiSetupFinished called AFTER adding to parent (needs parent context)
    addAt(mdmTab, ps.subCategoryBox, pos)
    mdmTab:onGuiSetupFinished()

    -- ── Page container ─────────────────────────────────────────────────────
    local mdmPage = GuiElement.new()
    mdmPage:loadProfile(g_gui:getProfile("fs25_subCategorySelectorTabbedContainer"), true)

    -- ── Scrolling layout (holds all settings rows) ─────────────────────────
    local settingsLayout = ScrollingLayoutElement.new()
    settingsLayout:loadProfile(g_gui:getProfile("fs25_settingsLayout"), true)
    mdmPage:addElement(settingsLayout)
    settingsLayout:onGuiSetupFinished()

    -- ── Bottom separator (matches vanilla style) ───────────────────────────
    local sep = BitmapElement.new()
    sep:loadProfile(g_gui:getProfile("fs25_settingsTooltipSeparator"), true)
    mdmPage:addElement(sep)
    sep:onGuiSetupFinished()

    -- onGuiSetupFinished on page AFTER children and AFTER adding to frame
    addAt(mdmPage, ps.subCategoryPages[1].parent, pos)
    mdmPage:onGuiSetupFinished()
    mdmPage:setVisible(false)  -- hidden by default; shown only when our tab is active

    -- Store references used by _addSettingsElements and _updateSettingsUI
    MDMSettingsUI.mdmTab         = mdmTab
    MDMSettingsUI.mdmPage        = mdmPage
    MDMSettingsUI.settingsLayout = settingsLayout

    ps:updateAbsolutePosition()

    -- Wire page target for focus/navigation system
    mdmPage:setTarget(ps, mdmPage.target)
    -- Note: do NOT call setTarget on mdmTab — it would overwrite our MDMSettingsUI callback target

    -- Register in the official arrays (the frame iterates these)
    ps.subCategoryPages[pos] = mdmPage
    ps.subCategoryTabs[pos]  = mdmTab

    -- CRITICAL: add our page index as a new state in the paging MultiTextOption.
    -- Without this, the nav arrows only cycle through vanilla states and never reach us.
    if ps.subCategoryPaging then
        ps.subCategoryPaging:addText(pos)
    end

    -- Re-layout the tab button row so our new button appears
    ps.subCategoryBox:invalidateLayout()

    -- Build settings content
    MDMSettingsUI._addSettingsElements()

    -- Register header icon/title.
    -- onClickMDM (above) also calls categoryHeaderText:setText() directly after
    -- setState, which is the reliable override for l10n lookup failures.
    InGameMenuSettingsFrame.SUB_CATEGORY = InGameMenuSettingsFrame.SUB_CATEGORY or {}
    InGameMenuSettingsFrame.SUB_CATEGORY.MARKET_DYNAMICS = pos
    if InGameMenuSettingsFrame.HEADER_TITLES then
        InGameMenuSettingsFrame.HEADER_TITLES[pos] = "mdm_settings_mdm_general"
    end
    if InGameMenuSettingsFrame.HEADER_SLICES then
        -- Borrow the Game Settings icon (index 1) — a safe, guaranteed-valid slice
        InGameMenuSettingsFrame.HEADER_SLICES[pos] = InGameMenuSettingsFrame.HEADER_SLICES[1]
    end

    -- Patch InGameMenuSettingsFrame.updateSubCategoryPages (the class method) so that
    -- Q/E keyboard navigation (which calls this method directly, bypassing the paging
    -- instance callback) also gets the correct header text for our tab.
    -- Patch InGameMenuSettingsFrame.updateSubCategoryPages (the class method) so that
    -- Q/E keyboard navigation (which calls this method directly, bypassing the paging
    -- instance callback) also gets the correct header text for our tab.
    -- Visibility is handled by vanilla (mdmPage is registered in subCategoryPages)
    -- and by the setVisible(false) init above — do NOT touch visibility here or it
    -- conflicts with BC and other mods that also append this function.
    InGameMenuSettingsFrame.updateSubCategoryPages = Utils.appendedFunction(
        InGameMenuSettingsFrame.updateSubCategoryPages,
        function(self, state)
            if state == MDMSettingsUI.modPageNr and self.categoryHeaderText then
                self.categoryHeaderText:setText(g_i18n:getText("mdm_screen_title") or "Market Dynamics")
            end
        end
    )

    -- Update FocusManager so keyboard/controller navigation finds our elements
    local currentGui = FocusManager.currentGui
    FocusManager:setGui(ps.name)
    FocusManager:removeElement(mdmPage)
    FocusManager:removeElement(mdmTab)
    FocusManager:loadElementFromCustomValues(mdmPage)
    FocusManager:loadElementFromCustomValues(mdmTab)
    FocusManager:setGui(currentGui)

    settingsLayout:invalidateLayout()

    MDMLog.info("SettingsUI: 'Market Dynamics' tab inserted at position " .. pos)
    return true
end

-- ---------------------------------------------------------------------------
-- Build settings elements into the ScrollingLayout
-- Called once from _insertTab(). Add new settings here (see HOW TO above).
-- ---------------------------------------------------------------------------

function MDMSettingsUI._addSettingsElements()
    local layout = MDMSettingsUI.settingsLayout
    if not layout then return end

    -- ── Prices ────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, g_i18n:getText("mdm_header_prices") or "Prices")

    _elem.pricesEnabled = MDMSettingsUI._addBinary(
        layout, "onMDMPricesEnabledChanged",
        g_i18n:getText("mdm_prices_enabled") or "Dynamic Prices",
        g_i18n:getText("mdm_prices_enabled_tooltip") or "Enable MDM price fluctuations. Off reverts to vanilla sell prices."
    )

    _elem.volatility = MDMSettingsUI._addMulti(
        layout, "onMDMVolatilityChanged",
        { 
            g_i18n:getText("mdm_label_low") or "Low",
            g_i18n:getText("mdm_label_normal") or "Normal",
            g_i18n:getText("mdm_label_high") or "High",
            g_i18n:getText("mdm_label_extreme") or "Extreme"
        },
        g_i18n:getText("mdm_price_volatility") or "Price Volatility",
        g_i18n:getText("mdm_price_volatility_tooltip") or "How wildly prices swing intraday and day-to-day. Low=0.5x, Normal=1x, High=1.5x, Extreme=2x."
    )

    -- ── World Events ──────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, g_i18n:getText("mdm_header_world_events") or "World Events")

    _elem.eventsEnabled = MDMSettingsUI._addBinary(
        layout, "onMDMEventsEnabledChanged",
        g_i18n:getText("mdm_events_enabled") or "World Events",
        g_i18n:getText("mdm_events_enabled_tooltip") or "Enable or disable world events. Prices still fluctuate when events are off."
    )

    _elem.eventFrequency = MDMSettingsUI._addMulti(
        layout, "onMDMEventFrequencyChanged",
        { 
            g_i18n:getText("mdm_label_rare") or "Rare",
            g_i18n:getText("mdm_label_normal") or "Normal",
            g_i18n:getText("mdm_label_frequent") or "Frequent"
        },
        g_i18n:getText("mdm_event_frequency") or "Event Frequency",
        g_i18n:getText("mdm_event_frequency_tooltip") or "How often events occur. Rare=0.4x, Normal=1x, Frequent=2x the base probability per check."
    )

    -- ── Futures Contracts ─────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, g_i18n:getText("mdm_header_futures") or "Futures Contracts")

    _elem.futuresPenalty = MDMSettingsUI._addMulti(
        layout, "onMDMFuturesPenaltyChanged",
        {
            g_i18n:getText("mdm_penalty_low") or "Low (8%)",
            g_i18n:getText("mdm_penalty_normal") or "Normal (15%)",
            g_i18n:getText("mdm_penalty_high") or "High (25%)"
        },
        g_i18n:getText("mdm_default_penalty") or "Default Penalty",
        g_i18n:getText("mdm_default_penalty_tooltip") or "Penalty on the undelivered contract value when a deadline is missed."
    )

    _elem.useRealDays = MDMSettingsUI._addBinary(
        layout, "onMDMUseRealDaysChanged",
        g_i18n:getText("mdm_use_real_days") or "Delivery Time Unit",
        g_i18n:getText("mdm_use_real_days_tooltip") or "Off = In-Game Days. On = Real Days (best-effort, tied to time scale at contract creation)."
    )

    -- ── Interface ─────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, g_i18n:getText("mdm_header_interface") or "Interface")

    _elem.showEventNotifications = MDMSettingsUI._addBinary(
        layout, "onMDMShowEventNotificationsChanged",
        g_i18n:getText("mdm_show_event_notifications") or "Event Notifications",
        g_i18n:getText("mdm_show_event_notifications_tooltip") or "Show a confirmation dialog when a new world event begins."
    )

    _elem.showContractHUD = MDMSettingsUI._addBinary(
        layout, "onMDMShowContractHUDChanged",
        g_i18n:getText("mdm_show_contract_hud") or "Contract HUD",
        g_i18n:getText("mdm_show_contract_hud_tooltip") or "Show an on-screen progress tracker for your active futures contract."
    )

    -- ── Status ────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, g_i18n:getText("mdm_header_status") or "Status")

    _elem.statusVersion   = MDMSettingsUI._addStatusRow(layout, g_i18n:getText("mdm_status_version") or "Version:             —")
    _elem.statusEvents    = MDMSettingsUI._addStatusRow(layout, g_i18n:getText("mdm_status_events") or "Active Events:       —")
    _elem.statusBC        = MDMSettingsUI._addStatusRow(layout, g_i18n:getText("mdm_status_bc") or "FuturesMission:      —")
    _elem.statusUP        = MDMSettingsUI._addStatusRow(layout, g_i18n:getText("mdm_status_up") or "UsedPlus:            —")

    -- ── Debug ─────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, g_i18n:getText("mdm_header_debug") or "Debug")

    _elem.debugMode = MDMSettingsUI._addBinary(
        layout, "onMDMDebugModeChanged",
        g_i18n:getText("mdm_debug_logging") or "Debug Logging",
        g_i18n:getText("mdm_debug_logging_tooltip") or "Write verbose [MDM] DEBUG entries to log.txt. For developers only."
    )
end

-- ---------------------------------------------------------------------------
-- Refresh element states from current settings values.
-- Called every time the settings frame opens (values may change via console).
-- ---------------------------------------------------------------------------

function MDMSettingsUI._updateSettingsUI()
    local mdm = g_MarketDynamics
    if not mdm or not mdm.settings then return end

    -- Apply alternating row backgrounds (same as BC's onSettingsFrameOpen).
    -- Without this, row text colors render incorrectly against the page background.
    local ps = g_inGameMenu and g_inGameMenu.pageSettings
    if ps and MDMSettingsUI.settingsLayout then
        ps:updateAlternatingElements(MDMSettingsUI.settingsLayout)
    end

    -- Fix header title if the MDM tab is already active when the frame opens.
    if ps and ps.categoryHeaderText and ps.subCategoryPaging then
        if ps.subCategoryPaging:getState() == MDMSettingsUI.modPageNr then
            ps.categoryHeaderText:setText(g_i18n:getText("mdm_screen_title") or "Market Dynamics")
        end
    end

    local isAdmin = g_currentMission:getIsServer() or g_currentMission.isAdmin

    if _elem.pricesEnabled then
        _elem.pricesEnabled:setIsChecked(mdm.settings.pricesEnabled ~= false, false, false)
        _elem.pricesEnabled:setDisabled(not isAdmin)
    end

    if _elem.volatility then
        local scale = (mdm.marketEngine and mdm.marketEngine.volatilityScale) or 1.0
        _elem.volatility:setState(MDMSettingsUI._findValueIndex(VOLATILITY_VALUES, scale))
        _elem.volatility:setDisabled(not isAdmin)
    end

    if _elem.eventsEnabled then
        _elem.eventsEnabled:setIsChecked(mdm.settings.eventsEnabled ~= false, false, false)
        _elem.eventsEnabled:setDisabled(not isAdmin)
    end

    if _elem.eventFrequency then
        _elem.eventFrequency:setState(MDMSettingsUI._findValueIndex(
            EVENT_FREQUENCY_VALUES, mdm.settings.eventFrequency or 1.0))
        _elem.eventFrequency:setDisabled(not isAdmin)
    end

    if _elem.futuresPenalty then
        _elem.futuresPenalty:setState(MDMSettingsUI._findValueIndex(
            FUTURES_PENALTY_VALUES, mdm.settings.futuresPenalty or 0.15))
        _elem.futuresPenalty:setDisabled(not isAdmin)
    end

    if _elem.showEventNotifications then
        _elem.showEventNotifications:setIsChecked(mdm.settings.showEventNotifications ~= false, false, false)
        -- Interface settings are personal, no admin check needed
    end

    if _elem.showContractHUD then
        _elem.showContractHUD:setIsChecked(mdm.settings.showContractHUD ~= false, false, false)
        -- Interface settings are personal, no admin check needed
    end

    if _elem.useRealDays then
        _elem.useRealDays:setIsChecked(mdm.settings.useRealDays == true, false, false)
        _elem.useRealDays:setDisabled(not isAdmin)
    end

    if _elem.debugMode then
        _elem.debugMode:setIsChecked(MDMLog.debugEnabled == true, false, false)
        _elem.debugMode:setDisabled(not isAdmin)
    end

    -- Status rows (live, updated on every open)
    if _elem.statusVersion then
        local modInfo = g_modManager and g_modManager:getModByName(mdm.modName)
        local fmt = g_i18n:getText("mdm_status_version_fmt") or "Version:             %s"
        _elem.statusVersion:setText(string.format(fmt, ((modInfo and modInfo.version) or "?")))
    end

    if _elem.statusEvents then
        local count = 0
        if mdm.worldEvents then
            for _ in pairs(mdm.worldEvents.active) do count = count + 1 end
        end
        local val = count == 0 and (g_i18n:getText("mdm_status_none") or "None") or string.format(g_i18n:getText("mdm_status_active_fmt") or "%d active", count)
        local fmt = g_i18n:getText("mdm_status_events_fmt") or "Active Events:       %s"
        _elem.statusEvents:setText(string.format(fmt, val))
    end

    if _elem.statusBC then
        local val = BCIntegration.isAvailable() and (g_i18n:getText("mdm_status_detected") or "Detected") or (g_i18n:getText("mdm_status_not_installed") or "Not installed")
        local fmt = g_i18n:getText("mdm_status_bc_fmt") or "FuturesMission:      %s"
        _elem.statusBC:setText(string.format(fmt, val))
    end

    if _elem.statusUP then
        local val = UPIntegration.isAvailable() and (g_i18n:getText("mdm_status_detected") or "Detected") or (g_i18n:getText("mdm_status_not_installed") or "Not installed")
        local fmt = g_i18n:getText("mdm_status_up_fmt") or "UsedPlus:            %s"
        _elem.statusUP:setText(string.format(fmt, val))
    end
end

-- ---------------------------------------------------------------------------
-- Callback Handlers
-- state = BinaryOptionElement.STATE_RIGHT (1) / STATE_LEFT (0) for toggles
-- state = 1-based index for multi-option dropdowns
-- ---------------------------------------------------------------------------

function MDMSettingsUI:onMDMPricesEnabledChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    local enabled = (state == BinaryOptionElement.STATE_RIGHT)
    g_MarketDynamics.settings.pricesEnabled = enabled
    MDMLog.info("SettingsUI: pricesEnabled = " .. tostring(enabled))

    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMVolatilityChanged(state)
    local scale = VOLATILITY_VALUES[state] or 1.0
    if g_MarketDynamics and g_MarketDynamics.marketEngine then
        g_MarketDynamics.marketEngine.volatilityScale = scale
    end
    MDMLog.info("SettingsUI: volatilityScale = " .. tostring(scale))

    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMEventsEnabledChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.eventsEnabled = (state == BinaryOptionElement.STATE_RIGHT)
    MDMLog.info("SettingsUI: eventsEnabled = " .. tostring(g_MarketDynamics.settings.eventsEnabled))

    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMEventFrequencyChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.eventFrequency = EVENT_FREQUENCY_VALUES[state] or 1.0
    MDMLog.info("SettingsUI: eventFrequency = " .. tostring(g_MarketDynamics.settings.eventFrequency))

    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMFuturesPenaltyChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.futuresPenalty = FUTURES_PENALTY_VALUES[state] or 0.15
    MDMLog.info("SettingsUI: futuresPenalty = " .. tostring(g_MarketDynamics.settings.futuresPenalty))

    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMShowEventNotificationsChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.showEventNotifications = (state == BinaryOptionElement.STATE_RIGHT)
    MDMLog.info("SettingsUI: showEventNotifications = " .. tostring(g_MarketDynamics.settings.showEventNotifications))
    -- Personal setting, no network sync needed (except to persist to server save if hosted)
    -- Actually, we sync all settings for simplicity in MDMSettingsSyncEvent.
    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMShowContractHUDChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.showContractHUD = (state == BinaryOptionElement.STATE_RIGHT)
    MDMLog.info("SettingsUI: showContractHUD = " .. tostring(g_MarketDynamics.settings.showContractHUD))
    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMUseRealDaysChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.useRealDays = (state == BinaryOptionElement.STATE_RIGHT)
    MDMLog.info("SettingsUI: useRealDays = " .. tostring(g_MarketDynamics.settings.useRealDays))
    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

function MDMSettingsUI:onMDMDebugModeChanged(state)
    MDMLog.debugEnabled = (state == BinaryOptionElement.STATE_RIGHT)
    if g_MarketDynamics and g_MarketDynamics.settings then
        g_MarketDynamics.settings.debugMode = MDMLog.debugEnabled
    end
    MDMLog.info("SettingsUI: debugMode = " .. tostring(MDMLog.debugEnabled))

    if g_server ~= nil then
        MDMSettingsSyncEvent.sendToClients()
    else
        MDMSettingsSyncEvent.sendToServer()
    end
end

-- ---------------------------------------------------------------------------
-- GUI Element Builders
-- (FS25 profile-based — always loadProfile, never clone)
-- ---------------------------------------------------------------------------

function MDMSettingsUI._addSection(layout, text)
    local el = TextElement.new()
    el.name = "sectionHeader"
    el:loadProfile(g_gui:getProfile("fs25_settingsSectionHeader"), true)
    el:setText(text)
    layout:addElement(el)
    el:onGuiSetupFinished()
end

function MDMSettingsUI._addBinary(layout, callbackName, title, tooltip)
    local bitMap = BitmapElement.new()
    bitMap:loadProfile(g_gui:getProfile("fs25_multiTextOptionContainer"), true)

    local option = BinaryOptionElement.new()
    option.useYesNoTexts = true
    option:loadProfile(g_gui:getProfile("fs25_settingsBinaryOption"), true)
    option.target = MDMSettingsUI
    option:setCallback("onClickCallback", callbackName)

    local titleEl = TextElement.new()
    titleEl:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOptionTitle"), true)
    titleEl:setText(title)

    local tooltipEl = TextElement.new()
    tooltipEl.name = "ignore"
    tooltipEl:loadProfile(g_gui:getProfile("fs25_multiTextOptionTooltip"), true)
    tooltipEl:setText(tooltip)

    option:addElement(tooltipEl)
    bitMap:addElement(option)
    bitMap:addElement(titleEl)

    option:onGuiSetupFinished()
    titleEl:onGuiSetupFinished()
    tooltipEl:onGuiSetupFinished()
    layout:addElement(bitMap)
    bitMap:onGuiSetupFinished()

    return option
end

function MDMSettingsUI._addMulti(layout, callbackName, texts, title, tooltip)
    local bitMap = BitmapElement.new()
    bitMap:loadProfile(g_gui:getProfile("fs25_multiTextOptionContainer"), true)

    local option = MultiTextOptionElement.new()
    option:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOption"), true)
    option.target = MDMSettingsUI
    option:setCallback("onClickCallback", callbackName)
    option:setTexts(texts)

    local titleEl = TextElement.new()
    titleEl:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOptionTitle"), true)
    titleEl:setText(title)

    local tooltipEl = TextElement.new()
    tooltipEl.name = "ignore"
    tooltipEl:loadProfile(g_gui:getProfile("fs25_multiTextOptionTooltip"), true)
    tooltipEl:setText(tooltip)

    option:addElement(tooltipEl)
    bitMap:addElement(option)
    bitMap:addElement(titleEl)

    option:onGuiSetupFinished()
    titleEl:onGuiSetupFinished()
    tooltipEl:onGuiSetupFinished()
    layout:addElement(bitMap)
    bitMap:onGuiSetupFinished()

    return option
end

-- Read-only status row — label and value in one string.
-- Uses the same container profile as regular settings rows so text is visible
-- and alternating row backgrounds apply correctly.
-- Returns the inner TextElement so _updateSettingsUI can call setText() on it.
function MDMSettingsUI._addStatusRow(layout, initialText)
    local bitMap = BitmapElement.new()
    bitMap:loadProfile(g_gui:getProfile("fs25_multiTextOptionContainer"), true)

    local titleEl = TextElement.new()
    titleEl:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOptionTitle"), true)
    titleEl.textUpperCase = false
    titleEl:setText(initialText or "—")

    bitMap:addElement(titleEl)
    titleEl:onGuiSetupFinished()
    layout:addElement(bitMap)
    bitMap:onGuiSetupFinished()

    return titleEl
end

-- Returns the index in `values` whose entry is closest to `target`.
function MDMSettingsUI._findValueIndex(values, target)
    local bestIdx, bestDiff = 1, math.huge
    for i, v in ipairs(values) do
        local d = math.abs(v - target)
        if d < bestDiff then bestDiff = d; bestIdx = i end
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

    MDMLog.info("SettingsUI: onFrameOpen hook installed")
end

initHooks()
