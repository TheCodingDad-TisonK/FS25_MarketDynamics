-- SettingsUI.lua
-- Adds a dedicated "Market Dynamics" tab to ESC > Settings.
-- Follows the FS25_BetterContracts pattern: load an XML page layout, then
-- inject the tab button and page container into InGameMenuSettingsFrame's
-- subCategoryTabs / subCategoryPages arrays.
--
-- Lifecycle:
--   1. initHooks()       — at source time: appends to InGameMenuSettingsFrame.onFrameOpen
--   2. MDMSettingsUI.initGui(modDir) — called from MarketDynamics:onMissionLoaded
--                           loads gui/settingsPage.xml via g_gui:loadGui()
--   3. onFrameOpen (first call) — inserts tab, builds settings elements, hooks paging
--   4. onFrameOpen (subsequent) — refreshes element states from current settings
--
-- HOW TO ADD A NEW SETTING:
--   1. Add a default value to MarketDynamics.settings in MarketDynamics.lua
--   2. Add save/load in MarketSerializer.lua
--   3. Call _addBinaryOption() or _addMultiTextOption() in addSettingsElements()
--   4. Add a refresh line in updateSettingsUI()
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

-- Option values for the volatility dropdown (parallel to display strings)
local VOLATILITY_VALUES = { 0.5, 1.0, 1.5, 2.0 }

-- ---------------------------------------------------------------------------
-- XML controller callbacks (called by the game from XML onClick="...")
-- ---------------------------------------------------------------------------

-- Called when the player clicks our tab button in the settings navigation bar.
function MDMSettingsUI:onClickMDM()
    local ps = g_inGameMenu and g_inGameMenu.pageSettings
    if not ps or not MDMSettingsUI.modPageNr then return end
    ps.subCategoryPaging:setState(MDMSettingsUI.modPageNr, true)
end

-- ---------------------------------------------------------------------------
-- Initialisation — called from MarketDynamics:onMissionLoaded
-- ---------------------------------------------------------------------------

function MDMSettingsUI.initGui(modDir)
    if _guiLoaded then return end

    local xmlPath = modDir .. "gui/settingsPage.xml"
    if not fileExists(xmlPath) then
        MDMLog.error("SettingsUI: settingsPage.xml not found at " .. xmlPath)
        return
    end

    -- g_gui:loadGui populates MDMSettingsUI with fields matching the XML ids:
    --   MDMSettingsUI.mdmTab, MDMSettingsUI.mdmPage, MDMSettingsUI.settingsLayout
    local result = g_gui:loadGui(xmlPath, "MDMSettingsFrame", MDMSettingsUI)
    if result == nil then
        MDMLog.error("SettingsUI: g_gui:loadGui failed for " .. xmlPath)
        return
    end

    _guiLoaded = true
    MDMLog.info("SettingsUI: GUI loaded — tab will be inserted on first settings open")
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

    local mdmPage = MDMSettingsUI.mdmPage
    local mdmTab  = MDMSettingsUI.mdmTab

    if not mdmPage or not mdmTab then
        MDMLog.warn("SettingsUI: mdmPage or mdmTab not loaded from XML")
        return false
    end

    -- Position: always last tab
    local pos = #ps.subCategoryTabs + 1
    MDMSettingsUI.modPageNr = pos

    -- Helper: reparent element and insert at position
    local function addAt(element, target, insertPos)
        if element.parent then element.parent:removeElement(element) end
        table.insert(target.elements, insertPos, element)
        element.parent = target
    end

    -- Insert page container and tab button into the frame's structure
    addAt(mdmPage, ps.subCategoryPages[1].parent, pos)
    addAt(mdmTab,  ps.subCategoryBox, pos)
    ps:updateAbsolutePosition()

    -- Wire targets so the frame can call back into them
    mdmPage:setTarget(ps, mdmPage.target)
    mdmTab:setTarget(ps, mdmTab.target)

    -- Register in the official arrays (the frame iterates these)
    ps.subCategoryPages[pos] = mdmPage
    ps.subCategoryTabs[pos]  = mdmTab

    -- Build the settings content into settingsLayout
    MDMSettingsUI._addSettingsElements()

    -- Hook the paging MultiTextOption so our page hides/shows correctly
    -- when the player clicks between tabs (including vanilla ones)
    if ps.subCategoryPaging then
        ps.subCategoryPaging.onClickCallback = Utils.appendedFunction(
            ps.subCategoryPaging.onClickCallback,
            function(_, state)
                if mdmPage then
                    mdmPage:setVisible(state == MDMSettingsUI.modPageNr)
                end
            end
        )
    end

    -- Register header icon/title (used by the frame to render the section banner)
    InGameMenuSettingsFrame.SUB_CATEGORY = InGameMenuSettingsFrame.SUB_CATEGORY or {}
    InGameMenuSettingsFrame.SUB_CATEGORY.MARKET_DYNAMICS = pos
    if InGameMenuSettingsFrame.HEADER_TITLES then
        InGameMenuSettingsFrame.HEADER_TITLES[pos] = "Market Dynamics"
    end
    if InGameMenuSettingsFrame.HEADER_SLICES then
        -- Reuse the contracts icon — swap once we have a custom icon asset
        InGameMenuSettingsFrame.HEADER_SLICES[pos] = "gui.icon_ingameMenu_contracts"
    end

    -- Update FocusManager so keyboard/controller navigation finds our elements
    local currentGui = FocusManager.currentGui
    FocusManager:setGui(ps.name)
    FocusManager:removeElement(mdmPage)
    FocusManager:removeElement(mdmTab)
    FocusManager:loadElementFromCustomValues(mdmPage)
    FocusManager:loadElementFromCustomValues(mdmTab)
    FocusManager:setGui(currentGui)

    if MDMSettingsUI.settingsLayout then
        MDMSettingsUI.settingsLayout:invalidateLayout()
    end

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

    -- ── Market Dynamics ───────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "Market Dynamics")

    -- Toggle the MDM price engine on/off. Off = vanilla prices pass through.
    _elem.pricesEnabled = MDMSettingsUI._addBinary(
        layout, "onMDMPricesEnabledChanged",
        "Dynamic Prices",
        "Enable MDM price fluctuations. Off reverts to vanilla sell prices."
    )

    -- Scale the strength of intraday + daily price movements.
    _elem.volatility = MDMSettingsUI._addMulti(
        layout, "onMDMVolatilityChanged",
        { "Low", "Normal", "High", "Extreme" },
        "Price Volatility",
        "How wildly prices swing. Low=0.5x, Normal=1x, High=1.5x, Extreme=2x"
    )

    -- ── BetterContracts Integration ───────────────────────────────────────

    MDMSettingsUI._addSection(layout, "BetterContracts Integration")

    -- Only functional when FS25_BetterContracts is installed.
    -- Enables supply-spike reactions and suppresses the MDM futures UI.
    _elem.bcMode = MDMSettingsUI._addBinary(
        layout, "onMDMBCModeChanged",
        "Use BetterContracts",
        "Requires FS25_BetterContracts. Links market reactions to BC contract completions."
    )

    -- ── Debug ─────────────────────────────────────────────────────────────

    MDMSettingsUI._addSection(layout, "Debug")

    -- Enables verbose [MDM] DEBUG lines in log.txt.
    _elem.debugMode = MDMSettingsUI._addBinary(
        layout, "onMDMDebugModeChanged",
        "Debug Logging",
        "Write verbose [MDM] DEBUG entries to log.txt. For developers only."
    )

    -- ── ADD NEW SETTINGS ABOVE THIS LINE ─────────────────────────────────
end

-- ---------------------------------------------------------------------------
-- Refresh element states from current settings values.
-- Called every time the settings frame opens (values may change via console).
-- ---------------------------------------------------------------------------

function MDMSettingsUI._updateSettingsUI()
    local mdm = g_MarketDynamics
    if not mdm or not mdm.settings then return end

    if _elem.pricesEnabled then
        _elem.pricesEnabled:setIsChecked(mdm.settings.pricesEnabled ~= false, false, false)
    end

    if _elem.volatility then
        local scale = (mdm.marketEngine and mdm.marketEngine.volatilityScale) or 1.0
        _elem.volatility:setState(MDMSettingsUI._findValueIndex(VOLATILITY_VALUES, scale))
    end

    if _elem.bcMode then
        _elem.bcMode:setIsChecked(BCIntegration.isEnabled(), false, false)
    end

    if _elem.debugMode then
        _elem.debugMode:setIsChecked(MDMLog.debugEnabled == true, false, false)
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

function MDMSettingsUI:onMDMBCModeChanged(state)
    local enabled = (state == BinaryOptionElement.STATE_RIGHT)
    if not BCIntegration.isAvailable() and enabled then
        MDMLog.warn("SettingsUI: BetterContracts not installed — forcing off")
        if _elem.bcMode then _elem.bcMode:setIsChecked(false, false, false) end
        return
    end
    BCIntegration.setEnabled(enabled)
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
