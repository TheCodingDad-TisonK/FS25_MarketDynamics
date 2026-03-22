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
        ps.categoryHeaderText:setText("Market Dynamics")
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
    local pos = #ps.subCategoryTabs + 1
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
    mdmTab:setText("Market Dynamics")
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
    InGameMenuSettingsFrame.updateSubCategoryPages = Utils.appendedFunction(
        InGameMenuSettingsFrame.updateSubCategoryPages,
        function(self, state)
            if state == MDMSettingsUI.modPageNr and self.categoryHeaderText then
                self.categoryHeaderText:setText("Market Dynamics")
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

    -- ── About ─────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "About")
    MDMSettingsUI._addInfo(layout, "Replaces static sell prices with a live market that drifts daily.")
    MDMSettingsUI._addInfo(layout, "World events shift prices for affected crops temporarily.")
    MDMSettingsUI._addInfo(layout, "Lock in a good price early using the futures contracts system.")

    -- ── Prices ────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "Prices")

    _elem.pricesEnabled = MDMSettingsUI._addBinary(
        layout, "onMDMPricesEnabledChanged",
        "Dynamic Prices",
        "Enable MDM price fluctuations. Off reverts to vanilla sell prices."
    )

    _elem.volatility = MDMSettingsUI._addMulti(
        layout, "onMDMVolatilityChanged",
        { "Low", "Normal", "High", "Extreme" },
        "Price Volatility",
        "How wildly prices swing intraday and day-to-day. Low=0.5x, Normal=1x, High=1.5x, Extreme=2x."
    )

    -- ── World Events ──────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "World Events")
    MDMSettingsUI._addInfo(layout, "Events fire randomly and shift prices for affected crops.")
    MDMSettingsUI._addInfo(layout, "Example: drought raises grain, bumper harvest pushes it down.")

    _elem.eventsEnabled = MDMSettingsUI._addBinary(
        layout, "onMDMEventsEnabledChanged",
        "World Events",
        "Enable or disable world events entirely. Prices will still fluctuate when off."
    )

    _elem.eventFrequency = MDMSettingsUI._addMulti(
        layout, "onMDMEventFrequencyChanged",
        { "Rare", "Normal", "Frequent" },
        "Event Frequency",
        "How often events occur. Rare=0.4x, Normal=1x, Frequent=2x the base probability per check."
    )

    -- ── Futures Contracts ─────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "Futures Contracts")
    MDMSettingsUI._addInfo(layout, "Lock in a price today, deliver by the deadline, collect at that rate.")
    MDMSettingsUI._addInfo(layout, "Miss the deadline and a penalty applies to the undelivered portion.")
    MDMSettingsUI._addInfo(layout, "UsedPlus credit score (if installed) can reduce or increase the rate.")

    _elem.futuresPenalty = MDMSettingsUI._addMulti(
        layout, "onMDMFuturesPenaltyChanged",
        { "Low (8%)", "Normal (15%)", "High (25%)" },
        "Default Penalty",
        "Penalty on the undelivered contract value when a deadline is missed."
    )

    -- ── Status ────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "Status")

    _elem.statusVersion   = MDMSettingsUI._addStatusRow(layout, "Version:             —")
    _elem.statusEvents    = MDMSettingsUI._addStatusRow(layout, "Active Events:       —")
    _elem.statusBC        = MDMSettingsUI._addStatusRow(layout, "BetterContracts:     —")
    _elem.statusUP        = MDMSettingsUI._addStatusRow(layout, "UsedPlus:            —")

    -- ── Debug ─────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "Debug")

    _elem.debugMode = MDMSettingsUI._addBinary(
        layout, "onMDMDebugModeChanged",
        "Debug Logging",
        "Write verbose [MDM] DEBUG entries to log.txt. For developers only."
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
            ps.categoryHeaderText:setText("Market Dynamics")
        end
    end

    if _elem.pricesEnabled then
        _elem.pricesEnabled:setIsChecked(mdm.settings.pricesEnabled ~= false, false, false)
    end

    if _elem.volatility then
        local scale = (mdm.marketEngine and mdm.marketEngine.volatilityScale) or 1.0
        _elem.volatility:setState(MDMSettingsUI._findValueIndex(VOLATILITY_VALUES, scale))
    end

    if _elem.eventsEnabled then
        _elem.eventsEnabled:setIsChecked(mdm.settings.eventsEnabled ~= false, false, false)
    end

    if _elem.eventFrequency then
        _elem.eventFrequency:setState(MDMSettingsUI._findValueIndex(
            EVENT_FREQUENCY_VALUES, mdm.settings.eventFrequency or 1.0))
    end

    if _elem.futuresPenalty then
        _elem.futuresPenalty:setState(MDMSettingsUI._findValueIndex(
            FUTURES_PENALTY_VALUES, mdm.settings.futuresPenalty or 0.15))
    end

    if _elem.debugMode then
        _elem.debugMode:setIsChecked(MDMLog.debugEnabled == true, false, false)
    end

    -- Status rows (live, updated on every open)
    if _elem.statusVersion then
        local modInfo = g_modManager and g_modManager:getModByName(mdm.modName)
        _elem.statusVersion:setText("Version:             " .. ((modInfo and modInfo.version) or "?"))
    end

    if _elem.statusEvents then
        local count = 0
        if mdm.worldEvents then
            for _ in pairs(mdm.worldEvents.active) do count = count + 1 end
        end
        local val = count == 0 and "None" or (count .. " active")
        _elem.statusEvents:setText("Active Events:       " .. val)
    end

    if _elem.statusBC then
        local val = BCIntegration.isAvailable() and "Detected" or "Not installed"
        _elem.statusBC:setText("BetterContracts:     " .. val)
    end

    if _elem.statusUP then
        local val = UPIntegration.isAvailable() and "Detected" or "Not installed"
        _elem.statusUP:setText("UsedPlus:            " .. val)
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
end

function MDMSettingsUI:onMDMVolatilityChanged(state)
    local scale = VOLATILITY_VALUES[state] or 1.0
    if g_MarketDynamics and g_MarketDynamics.marketEngine then
        g_MarketDynamics.marketEngine.volatilityScale = scale
    end
    MDMLog.info("SettingsUI: volatilityScale = " .. tostring(scale))
end

function MDMSettingsUI:onMDMEventsEnabledChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.eventsEnabled = (state == BinaryOptionElement.STATE_RIGHT)
    MDMLog.info("SettingsUI: eventsEnabled = " .. tostring(g_MarketDynamics.settings.eventsEnabled))
end

function MDMSettingsUI:onMDMEventFrequencyChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.eventFrequency = EVENT_FREQUENCY_VALUES[state] or 1.0
    MDMLog.info("SettingsUI: eventFrequency = " .. tostring(g_MarketDynamics.settings.eventFrequency))
end

function MDMSettingsUI:onMDMFuturesPenaltyChanged(state)
    if not g_MarketDynamics or not g_MarketDynamics.settings then return end
    g_MarketDynamics.settings.futuresPenalty = FUTURES_PENALTY_VALUES[state] or 0.15
    MDMLog.info("SettingsUI: futuresPenalty = " .. tostring(g_MarketDynamics.settings.futuresPenalty))
end

function MDMSettingsUI:onMDMDebugModeChanged(state)
    MDMLog.debugEnabled = (state == BinaryOptionElement.STATE_RIGHT)
    if g_MarketDynamics and g_MarketDynamics.settings then
        g_MarketDynamics.settings.debugMode = MDMLog.debugEnabled
    end
    MDMLog.info("SettingsUI: debugMode = " .. tostring(MDMLog.debugEnabled))
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

-- Static info/description line — same as _addSection but plain (not bold/uppercase).
-- Uses fs25_settingsSectionHeader directly in the layout, which is guaranteed to render.
-- Keep text short enough to fit one line — no wrapping support.
function MDMSettingsUI._addInfo(layout, text)
    local el = TextElement.new()
    el:loadProfile(g_gui:getProfile("fs25_settingsSectionHeader"), true)
    el.textUpperCase = false
    el.textBold      = false
    el:setText(text)
    layout:addElement(el)
    el:onGuiSetupFinished()
end

-- Read-only status row — same profile as _addInfo, label and value in one string.
-- Returns the TextElement so _updateSettingsUI can call setText("Label:  Value") on it.
function MDMSettingsUI._addStatusRow(layout, initialText)
    local el = TextElement.new()
    el:loadProfile(g_gui:getProfile("fs25_settingsSectionHeader"), true)
    el.textUpperCase = false
    el:setText(initialText or "—")
    layout:addElement(el)
    el:onGuiSetupFinished()
    return el
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
