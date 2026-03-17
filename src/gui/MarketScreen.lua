-- MarketScreen.lua
-- Full-screen market overview: commodity list, price detail, events, contracts.
-- Extends ScreenElement — loaded via g_gui:loadGui() with XML layout.
--
-- Layout:
--   Left panel:  SmoothList of all tracked commodities (click to select)
--   Right panel:  3 tabs — Prices / Events / Contracts
--     Prices:    Detail card + bar chart (MDMMarketScreenGraph)
--     Events:    SmoothList of active world events
--     Contracts: SmoothList of futures contracts for current farm
--
-- Author: LeGrizzly (dev-2)

MDMMarketScreen = {}

MDMMarketScreen.CLASS_NAME = "MDMMarketScreen"
MDMMarketScreen.MENU_PAGE_NAME = "menuMarketDynamics"
MDMMarketScreen.XML_FILENAME = "xml/gui/MarketScreen.xml"

MDMMarketScreen.MENU_ICON_PATH = "images/MenuIcon.dds"

-- Debugging dump support (one-shot, opt-in)
MDMMarketScreen.MDM_DEBUG_DUMP = true
MDMMarketScreen._debugDumpDone = false

local MDMDebug = {}

local function _truncateString(s, max)
    if type(s) ~= "string" then return tostring(s) end
    max = max or 200
    if #s > max then return string.sub(s, 1, max) .. "...(truncated)" end
    return s
end

function MDMDebug.dumpTable(obj, opts)
    opts = opts or {}
    local maxDepth = opts.maxDepth or 3
    local maxString = opts.maxString or 200
    local visited = {}
    local parts = {}

    local function _dump(o, depth)
        if type(o) == "table" then
            if visited[o] then
                parts[#parts+1] = "<cycle>"
                return
            end
            if depth > maxDepth then
                parts[#parts+1] = "<maxDepth>"
                return
            end
            visited[o] = true
            parts[#parts+1] = "{"
            local first = true
            for k, v in pairs(o) do
                if not first then parts[#parts+1] = "," end
                first = false
                parts[#parts+1] = "[" .. tostring(k) .. "]="
                _dump(v, depth + 1)
            end
            parts[#parts+1] = "}"
        elseif type(o) == "string" then
            parts[#parts+1] = '"' .. _truncateString(o, maxString) .. '"'
        else
            parts[#parts+1] = tostring(o)
        end
    end

    _dump(obj, 1)
    return table.concat(parts)
end

function MDMDebug.logMarketScreenState(screen)
    if screen == nil then return end
    MDMLog.info("MDM DEBUG: MarketScreen state dump start")

    local function safeLog(label, val, opts)
        if type(val) == "table" then
            local cnt = 0
            for _ in pairs(val) do cnt = cnt + 1 end
            MDMLog.info(string.format("MDM DEBUG: %s count=%d", label, cnt))
            local sample = nil
            for _, v in pairs(val) do sample = v break end
            if sample ~= nil then
                MDMLog.info("MDM DEBUG: " .. label .. " sample: " .. MDMDebug.dumpTable(sample, opts or {maxDepth=2}))
            end
        else
            MDMLog.info("MDM DEBUG: " .. label .. " = " .. tostring(val))
        end
    end

    safeLog("commodities", screen.commodities, {maxDepth=2})
    safeLog("eventData", screen.eventData, {maxDepth=2})
    safeLog("contractData", screen.contractData, {maxDepth=2})

    if g_inGameMenu then
        local pe = g_inGameMenu.pagingElement
        if pe and type(pe.elements) == "table" then
            MDMLog.info("MDM DEBUG: inGameMenu.pagingElement.elementsCount=" .. tostring(#pe.elements))
        else
            MDMLog.info("MDM DEBUG: inGameMenu.pagingElement=" .. tostring(pe))
        end
        if g_inGameMenu.pageFrames and type(g_inGameMenu.pageFrames) == "table" then
            local cnt = 0
            for _ in pairs(g_inGameMenu.pageFrames) do cnt = cnt + 1 end
            MDMLog.info("MDM DEBUG: g_inGameMenu.pageFrames count=" .. cnt)
        end
    else
        MDMLog.info("MDM DEBUG: g_inGameMenu is nil")
    end

    MDMLog.info("MDM DEBUG: _pendingRegistration=" .. tostring(_pendingRegistration) .. ", _pendingModDir=" .. tostring(_pendingModDir))
    MDMLog.info("MDM DEBUG: MarketScreen state dump end")
end

MDMMarketScreen._mt = Class(MDMMarketScreen, TabbedMenuFrameElement)

-- Tab indices
local TAB_PRICES    = 1
local TAB_EVENTS    = 2
local TAB_CONTRACTS = 3

-- Data refresh throttle (ms)
local REFRESH_INTERVAL = 1000

-- ---------------------------------------------------------------------------
-- Constructor
-- ---------------------------------------------------------------------------

function MDMMarketScreen.new()
    local self = MDMMarketScreen:superClass().new(nil, MDMMarketScreen._mt)

    self.name       = "MDMMarketScreen"
    self.className  = "MDMMarketScreen"

    self.activeTab         = TAB_PRICES
    self.commodities       = {}   -- { {idx, name, title, current, base, changePct}, ... }
    self.selectedCropIndex = 1
    self.eventData         = {}   -- { {id, name, intensity, endsAt}, ... }
    self.contractData      = {}   -- { contract table from FuturesMarket, ... }
    self.refreshTimer      = 0
    self.returnScreenName  = ""
    self.menuButtonInfo    = {}

    return self
end

function MDMMarketScreen:initialize()
    MDMLog.info("MarketScreen: initializing")

    -- Call superclass initialize (will trigger onGuiSetupFinished)
    MDMMarketScreen:superClass().initialize(self)
end

-- ---------------------------------------------------------------------------
-- Static methods
-- ---------------------------------------------------------------------------

function MDMMarketScreen.register(modDir)
    -- Attempt a one-shot registration using the robust flow; if systems aren't ready, defer.
    if MDMMarketScreen._performRegistration(modDir) then
        -- Registered synchronously
        return
    end

    -- Defer registration until g_gui and g_inGameMenu are available
    _pendingRegistration = true
    _pendingModDir = modDir
    MDMLog.info("MarketScreen: deferred registration until GUI/InGameMenu ready")
end

function MDMMarketScreen.show()
    local inGameMenu = g_gui.screenControllers[InGameMenu] or g_inGameMenu
    if inGameMenu == nil then return end
    local page = inGameMenu[MDMMarketScreen.MENU_PAGE_NAME]
    if page == nil then return end
    g_gui:showGui("InGameMenu")
    inGameMenu:goToPage(page)
end

function MDMMarketScreen.toggle()
    if g_gui.currentGuiName == "InGameMenu" then
        local inGameMenu = g_gui.screenControllers[InGameMenu] or g_inGameMenu
        if inGameMenu and inGameMenu.currentPage == inGameMenu[MDMMarketScreen.MENU_PAGE_NAME] then
            g_gui:changeScreen(nil)
            return
        end
    end
    MDMMarketScreen.show()
end

-- ---------------------------------------------------------------------------
-- Lifecycle
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onGuiSetupFinished()
    MDMMarketScreen:superClass().onGuiSetupFinished(self)

    print("MarketScreen: onGuiSetupFinished called")

    -- Resolve XML elements by id
    self.commodityList   = self:getDescendantById("commodityList")
    self.eventList       = self:getDescendantById("eventList")
    self.contractList    = self:getDescendantById("contractList")

    self.pricesContent   = self:getDescendantById("pricesContent")
    self.eventsContent   = self:getDescendantById("eventsContent")
    self.contractsContent = self:getDescendantById("contractsContent")

    -- Header text
    self.categoryHeaderText = self:getDescendantById("categoryHeaderText")

    -- Commodity list headers
    self.commoditiesHeader = self:getDescendantById("commoditiesHeader")
    self.colHeaderCrop = self:getDescendantById("colHeaderCrop")
    self.colHeaderPrice = self:getDescendantById("colHeaderPrice")
    self.colHeaderChange = self:getDescendantById("colHeaderChange")

    -- Price detail elements
    self.detailCropName    = self:getDescendantById("detailCropName")
    self.detailCurrentPrice = self:getDescendantById("detailCurrentPrice")
    self.detailBasePrice   = self:getDescendantById("detailBasePrice")
    self.detailChange      = self:getDescendantById("detailChange")
    self.detailVolatility  = self:getDescendantById("detailVolatility")
    self.detailModifiers   = self:getDescendantById("detailModifiers")

    -- Graph
    self.graphArea = self:getDescendantById("graphArea")
    self.graphTitle = self:getDescendantById("graphTitle")
    self.graphHint = self:getDescendantById("graphHint")

    -- Events content
    self.eventsHeader = self:getDescendantById("eventsHeader")
    self.noEventsText = self:getDescendantById("noEventsText")

    -- Contracts content
    self.contractsHeader = self:getDescendantById("contractsHeader")
    self.contractsColCrop = self:getDescendantById("contractsColCrop")
    self.noContractsText = self:getDescendantById("noContractsText")
    self.newContractHint = self:getDescendantById("newContractHint")

    -- Wire SmoothList data source callbacks
    if self.commodityList then
        self.commodityList.dataSource = self
        self.commodityList.delegate   = self
    end
    if self.eventList then
        self.eventList.dataSource = self
        self.eventList.delegate   = self
    end
    if self.contractList then
        self.contractList.dataSource = self
        self.contractList.delegate   = self
    end

    -- Ensure critical text elements have a fallback to avoid "Missing 'key'" displays
    local function _setTextSafe(el, key, fallback)
        if el == nil then return end
        local ok, txt = pcall(function() return g_i18n and g_i18n:getText(key) end)
        if ok and txt and txt ~= "" then
            el:setText(txt)
        else
            el:setText(fallback or tostring(key))
        end

        print(string.format("MarketScreen: set text for key '%s' to '%s'", key, el:getText()))
    end

    _setTextSafe(self.categoryHeaderText, "mdm_screen_title", "Market Dynamics")
    _setTextSafe(self.commoditiesHeader, "mdm_screen_commodities", "COMMODITIES")
    _setTextSafe(self.colHeaderCrop, "mdm_screen_col_crop", "Crop")
    _setTextSafe(self.colHeaderPrice, "mdm_screen_col_price", "Price")
    _setTextSafe(self.colHeaderChange, "mdm_screen_col_change", "Change")
    _setTextSafe(self.graphTitle, "mdm_screen_session_trend", "Session Price Trend")
    _setTextSafe(self.graphHint, "mdm_screen_collecting", "Collecting data...")
    _setTextSafe(self.eventsHeader, "mdm_screen_events_hdr", "ACTIVE EVENTS")
    _setTextSafe(self.noEventsText, "mdm_screen_no_events", "No events")
    _setTextSafe(self.contractsHeader, "mdm_screen_contracts_hdr", "FUTURES CONTRACTS")
    _setTextSafe(self.contractsColCrop, "mdm_screen_col_crop", "Crop")
    _setTextSafe(self.noContractsText, "mdm_screen_no_contracts", "No contracts")
    _setTextSafe(self.newContractHint, "mdm_screen_new_contract", "Alt+F: New Contract")
end

function MDMMarketScreen:onOpen()
    MDMMarketScreen:superClass().onOpen(self)

    -- One-shot debug dump of in-memory data and paging state
    if MDMMarketScreen.MDM_DEBUG_DUMP and not MDMMarketScreen._debugDumpDone then
        if MDMDebug and type(MDMDebug.logMarketScreenState) == "function" then
            MDMDebug.logMarketScreenState(self)
        end
        MDMMarketScreen._debugDumpDone = true
    end

    self:rebuildAllData()
    self:setActiveTab(TAB_PRICES)
    self:reloadAllLists()

    if self.selectedCropIndex > 0 and #self.commodities > 0 then
        self:refreshPricesDetail()
    end
end

function MDMMarketScreen:onClose()
    MDMMarketScreen:superClass().onClose(self)
end

function MDMMarketScreen:update(dt)
    MDMMarketScreen:superClass().update(self, dt)

    self.refreshTimer = self.refreshTimer + dt
    if self.refreshTimer >= REFRESH_INTERVAL then
        self.refreshTimer = 0
        self:rebuildAllData()
        self:reloadAllLists()

        if self.activeTab == TAB_PRICES then
            self:refreshPricesDetail()
        end
    end
end

-- One-shot debug flag for graph area dimensions
MDMMarketScreen._graphAreaLogDone = false

function MDMMarketScreen:draw()
    MDMMarketScreen:superClass().draw(self)

    -- Render line chart overlay in prices tab
    if self.activeTab == TAB_PRICES and self.graphArea then
        local pos = self.graphArea.absPosition
        local sz  = self.graphArea.absSize

        -- Guard: need valid position and size arrays with numeric entries
        if not pos or not sz or not pos[1] or not pos[2] or not sz[1] or not sz[2] then
            return
        end

        -- One-shot log of graphArea dimensions (use concat, not format — Logging.info double-formats %)
        if not MDMMarketScreen._graphAreaLogDone then
            MDMLog.info("MarketScreen: graphArea pos=(" .. tostring(pos[1]) .. ", " .. tostring(pos[2]) .. ") size=(" .. tostring(sz[1]) .. ", " .. tostring(sz[2]) .. ")")
            MDMMarketScreen._graphAreaLogDone = true
        end

        local crop = self.commodities[self.selectedCropIndex]
        local fillIdx = crop and crop.idx or nil

        -- Per-commodity chart if selected and has data, else aggregated fallback
        local sampleCount = 0
        if fillIdx then
            sampleCount = MDMMarketScreenGraph.getSampleCount(fillIdx)
        end
        if sampleCount < 2 then
            sampleCount = MDMMarketScreenGraph.getGlobalSampleCount()
        end

        if sampleCount >= 2 then
            -- Ring buffer has enough data — draw live chart
            if self.graphHint then
                self.graphHint:setVisible(false)
            end

            if fillIdx and MDMMarketScreenGraph.getSampleCount(fillIdx) >= 2 then
                MDMMarketScreenGraph.draw(fillIdx, pos[1], pos[2], sz[1], sz[2])
            else
                MDMMarketScreenGraph.drawAggregatedMedian(pos[1], pos[2], sz[1], sz[2])
            end
        elseif fillIdx and g_MarketDynamics and g_MarketDynamics.marketEngine then
            -- Fallback: use daily history from MarketEngine
            local history = g_MarketDynamics.marketEngine:getPriceHistory(fillIdx)
            if history and #history >= 2 then
                if self.graphHint then
                    self.graphHint:setVisible(false)
                end
                local series = {}
                for _, h in ipairs(history) do
                    series[#series + 1] = h.price
                end
                MDMMarketScreenGraph._drawLineChart(series, pos[1], pos[2], sz[1], sz[2])
            else
                if self.graphHint then
                    self.graphHint:setVisible(true)
                end
            end
        else
            if self.graphHint then
                self.graphHint:setVisible(true)
            end
        end
    end
end

function MDMMarketScreen:delete()
    MDMMarketScreen:superClass().delete(self)
end

-- ---------------------------------------------------------------------------
-- Input
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onClickBack()
    self:changeScreen(nil)
end

-- Keyboard: Q/E to switch tabs
function MDMMarketScreen:inputEvent(action, value, eventUsed)
    eventUsed = MDMMarketScreen:superClass().inputEvent(self, action, value, eventUsed)
    if eventUsed then return true end

    if action == InputAction.MENU_PAGE_PREV and value > 0 then
        local newTab = self.activeTab - 1
        if newTab < TAB_PRICES then newTab = TAB_CONTRACTS end
        self:setActiveTab(newTab)
        return true
    end
    if action == InputAction.MENU_PAGE_NEXT and value > 0 then
        local newTab = self.activeTab + 1
        if newTab > TAB_CONTRACTS then newTab = TAB_PRICES end
        self:setActiveTab(newTab)
        return true
    end

    return false
end

-- ---------------------------------------------------------------------------
-- SmoothList Data Source
-- ---------------------------------------------------------------------------

function MDMMarketScreen:getNumberOfItemsInSection(list, section)
    if list == self.commodityList then
        return #self.commodities
    elseif list == self.eventList then
        return #self.eventData
    elseif list == self.contractList then
        return #self.contractData
    end
    return 0
end

function MDMMarketScreen:populateCellForItemInSection(list, section, index, cell)
    if list == self.commodityList then
        self:_populateCommodityCell(index, cell)
    elseif list == self.eventList then
        self:_populateEventCell(index, cell)
    elseif list == self.contractList then
        self:_populateContractCell(index, cell)
    end
end

-- ---------------------------------------------------------------------------
-- SmoothList Delegate — selection & click
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onListSelectionChanged(list, section, index)
    if list == self.commodityList and index > 0 then
        self.selectedCropIndex = index
        self:refreshPricesDetail()
    end
end

function MDMMarketScreen:onClickCommodity(element)
    -- onListSelectionChanged handles selection; nothing extra needed
end

-- ---------------------------------------------------------------------------
-- Tab Switching
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onClickTabPrices()
    self:setActiveTab(TAB_PRICES)
end

function MDMMarketScreen:onClickTabEvents()
    self:setActiveTab(TAB_EVENTS)
end

function MDMMarketScreen:onClickTabContracts()
    self:setActiveTab(TAB_CONTRACTS)
end

function MDMMarketScreen:setActiveTab(tab)
    self.activeTab = tab

    if self.pricesContent then
        self.pricesContent:setVisible(tab == TAB_PRICES)
    end
    if self.eventsContent then
        self.eventsContent:setVisible(tab == TAB_EVENTS)
    end
    if self.contractsContent then
        self.contractsContent:setVisible(tab == TAB_CONTRACTS)
    end

end

-- ---------------------------------------------------------------------------
-- Data Gathering
-- ---------------------------------------------------------------------------

function MDMMarketScreen:rebuildAllData()
    self:_buildCommodityData()
    self:_buildEventData()
    self:_buildContractData()
end

function MDMMarketScreen:_buildCommodityData()
    self.commodities = {}

    if not g_MarketDynamics or not g_MarketDynamics.marketEngine then return end
    local engine = g_MarketDynamics.marketEngine

    for fillTypeIndex, entry in pairs(engine.prices) do
        local fillType = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        if fillType then
            local changePct = engine:getPriceChangePercent(fillTypeIndex)
            table.insert(self.commodities, {
                idx       = fillTypeIndex,
                name      = fillType.name,
                title     = fillType.title or fillType.name,
                current   = entry.current,
                base      = entry.base,
                changePct = changePct,
                volatility = entry.volatilityFactor,
                modifiers = entry.modifiers,
            })
        end
    end

    -- Sort alphabetically by title
    table.sort(self.commodities, function(a, b) return a.title < b.title end)

    -- Clamp selected index
    if self.selectedCropIndex > #self.commodities then
        self.selectedCropIndex = math.max(1, #self.commodities)
    end
end

function MDMMarketScreen:_buildEventData()
    self.eventData = {}

    if not g_MarketDynamics or not g_MarketDynamics.worldEvents then return end

    local events = g_MarketDynamics.worldEvents:getActiveEvents()
    for _, ev in ipairs(events) do
        table.insert(self.eventData, ev)
    end

    -- Show/hide empty state hint
    if self.noEventsText then
        self.noEventsText:setVisible(#self.eventData == 0)
    end
end

function MDMMarketScreen:_buildContractData()
    self.contractData = {}

    if not g_MarketDynamics or not g_MarketDynamics.futuresMarket then return end
    if not g_currentMission or not g_currentMission.player then return end

    local farmId = g_currentMission.player.farmId
    if not farmId then return end

    local contracts = g_MarketDynamics.futuresMarket:getContractsForFarm(farmId)
    for _, c in ipairs(contracts) do
        table.insert(self.contractData, c)
    end

    -- Show/hide empty state hint
    if self.noContractsText then
        self.noContractsText:setVisible(#self.contractData == 0)
    end
end

-- ---------------------------------------------------------------------------
-- List Reload
-- ---------------------------------------------------------------------------

function MDMMarketScreen:reloadAllLists()
    if self.commodityList then
        self.commodityList:reloadData()
    end
    if self.eventList then
        self.eventList:reloadData()
    end
    if self.contractList then
        self.contractList:reloadData()
    end
end

-- ---------------------------------------------------------------------------
-- Cell Population
-- ---------------------------------------------------------------------------

function MDMMarketScreen:_populateCommodityCell(index, cell)
    local data = self.commodities[index]
    if not data then return end

    local nameEl   = cell:getDescendantByName("cropName")
    local priceEl  = cell:getDescendantByName("cropPrice")
    local changeEl = cell:getDescendantByName("cropChange")

    if nameEl then
        nameEl:setText(data.title)
    end
    if priceEl then
        priceEl:setText(string.format("$%.0f", data.current))
    end
    if changeEl then
        local sign = data.changePct >= 0 and "+" or ""
        changeEl:setText(string.format("%s%.1f%%", sign, data.changePct))

        -- Color: green for positive, red for negative
        if data.changePct > 0.5 then
            changeEl:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif data.changePct < -0.5 then
            changeEl:setTextColor(0.85, 0.22, 0.22, 1.0)
        else
            changeEl:setTextColor(0.80, 0.80, 0.80, 1.0)
        end
    end
end

function MDMMarketScreen:_populateEventCell(index, cell)
    local data = self.eventData[index]
    if not data then return end

    local nameEl      = cell:getDescendantByName("eventName")
    local intensityEl = cell:getDescendantByName("eventIntensity")
    local timeEl      = cell:getDescendantByName("eventTimeLeft")

    if nameEl then
        nameEl:setText(data.name)
    end

    if intensityEl then
        local label
        if data.intensity >= 0.7 then
            label = g_i18n:getText("mdm_hud_event_severe")
        elseif data.intensity >= 0.4 then
            label = g_i18n:getText("mdm_hud_event_moderate")
        else
            label = g_i18n:getText("mdm_hud_event_mild")
        end
        intensityEl:setText(label)

        -- Color intensity text
        if data.intensity >= 0.7 then
            intensityEl:setTextColor(0.85, 0.22, 0.22, 1.0)
        elseif data.intensity >= 0.4 then
            intensityEl:setTextColor(0.95, 0.75, 0.10, 1.0)
        else
            intensityEl:setTextColor(0.60, 0.80, 0.60, 1.0)
        end
    end

    if timeEl then
        local now = g_currentMission and g_currentMission.time or 0
        local remaining = math.max(0, data.endsAt - now)
        local mins = math.floor(remaining / 60000)
        if mins > 60 then
            local hrs = math.floor(mins / 60)
            timeEl:setText(string.format("%dh %dm", hrs, mins % 60))
        else
            timeEl:setText(string.format("%d min", mins))
        end
    end
end

function MDMMarketScreen:_populateContractCell(index, cell)
    local data = self.contractData[index]
    if not data then return end

    local cropEl     = cell:getDescendantByName("contractCrop")
    local qtyEl      = cell:getDescendantByName("contractQty")
    local priceEl    = cell:getDescendantByName("contractPrice")
    local progressEl = cell:getDescendantByName("contractProgress")
    local deadlineEl = cell:getDescendantByName("contractDeadline")
    local statusEl   = cell:getDescendantByName("contractStatus")

    if cropEl then
        cropEl:setText(data.fillTypeName or "?")
    end
    if qtyEl then
        qtyEl:setText(string.format("%.0fL", data.quantity))
    end
    if priceEl then
        priceEl:setText(string.format("$%.0f", data.lockedPrice))
    end
    if progressEl then
        local pct = 0
        if data.quantity > 0 then
            pct = (data.delivered / data.quantity) * 100
        end
        progressEl:setText(string.format("%.0f%%", pct))
    end
    if deadlineEl then
        local now = g_currentMission and g_currentMission.time or 0
        local remaining = math.max(0, data.deliveryTime - now)
        local days = math.floor(remaining / (24 * 60 * 60000))
        if days > 0 then
            deadlineEl:setText(string.format("%d days", days))
        else
            local hrs = math.floor(remaining / (60 * 60000))
            deadlineEl:setText(string.format("%d hrs", hrs))
        end
    end
    if statusEl then
        local status = data.status or "active"
        if status == "active" then
            -- Check if at risk (< 25% time left, < 50% delivered)
            local now = g_currentMission and g_currentMission.time or 0
            local totalDuration = data.deliveryTime - (data.deliveryTime - 86400000) -- approximate
            local remaining = math.max(0, data.deliveryTime - now)
            local pctDelivered = data.quantity > 0 and (data.delivered / data.quantity) or 0

            if remaining < 86400000 and pctDelivered < 0.5 then
                statusEl:setText(g_i18n:getText("mdm_screen_at_risk"))
                statusEl:setTextColor(0.85, 0.22, 0.22, 1.0)
            else
                statusEl:setText(g_i18n:getText("mdm_futures_active"))
                statusEl:setTextColor(0.20, 0.72, 0.35, 1.0)
            end
        elseif status == "fulfilled" then
            statusEl:setText(g_i18n:getText("mdm_futures_fulfill"))
            statusEl:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif status == "defaulted" then
            statusEl:setText(g_i18n:getText("mdm_futures_defaulted"))
            statusEl:setTextColor(0.85, 0.22, 0.22, 1.0)
        end
    end
end

-- ---------------------------------------------------------------------------
-- Price Detail (right panel, Prices tab)
-- ---------------------------------------------------------------------------

function MDMMarketScreen:refreshPricesDetail()
    local crop = self.commodities[self.selectedCropIndex]
    if not crop then
        if self.detailCropName then
            self.detailCropName:setText(g_i18n:getText("mdm_screen_select_crop"))
        end
        return
    end

    if self.detailCropName then
        self.detailCropName:setText(crop.title)
    end
    if self.detailCurrentPrice then
        self.detailCurrentPrice:setText(
            g_i18n:getText("mdm_screen_current_price") .. ": " ..
            string.format("$%.2f / L", crop.current)
        )
    end
    if self.detailBasePrice then
        self.detailBasePrice:setText(
            g_i18n:getText("mdm_screen_base_price") .. ": " ..
            string.format("$%.2f / L", crop.base)
        )
    end
    if self.detailChange then
        local sign = crop.changePct >= 0 and "+" or ""
        self.detailChange:setText(
            g_i18n:getText("mdm_screen_change") .. ": " ..
            string.format("%s%.1f%%", sign, crop.changePct)
        )
        -- Color the change text
        if crop.changePct > 0.5 then
            self.detailChange:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif crop.changePct < -0.5 then
            self.detailChange:setTextColor(0.85, 0.22, 0.22, 1.0)
        else
            self.detailChange:setTextColor(0.80, 0.80, 0.80, 1.0)
        end
    end
    if self.detailVolatility then
        self.detailVolatility:setText(
            g_i18n:getText("mdm_screen_volatility") .. ": " ..
            string.format("%.3f", crop.volatility)
        )
    end
    if self.detailModifiers then
        local modCount = crop.modifiers and #crop.modifiers or 0
        self.detailModifiers:setText(
            g_i18n:getText("mdm_screen_modifiers") .. ": " .. modCount
        )
    end

    -- Update graph title with selected commodity name
    local graphTitle = self:getDescendantById("graphTitle")
    if graphTitle then
        graphTitle:setText(crop.title .. " — " .. g_i18n:getText("mdm_screen_session_trend"))
    end
end

-- ---------------------------------------------------------------------------
-- Module-level lifecycle hooks
-- Wired at source() time. MarketScreen manages its own registration.
-- ---------------------------------------------------------------------------

-- Pending registration state (one-shot deferred registration when GUI/menu ready)
local _modDir = g_currentModDirectory
local _pendingRegistration = false
local _pendingModDir = nil

local function _onMissionLoaded(mission)
    -- Try immediate registration; if systems aren't ready, mark pending
    MDMMarketScreen.register(_modDir)
end

function MDMMarketScreen._performRegistration(modDir)
    if g_gui == nil or g_inGameMenu == nil then
        return false
    end

    -- Prevent duplicate registration: if page already present, do nothing
    if g_inGameMenu[MDMMarketScreen.MENU_PAGE_NAME] ~= nil then
        MDMLog.info("MarketScreen: page already registered, skipping")
        return true
    end

    local screen = MDMMarketScreen.new()
    -- Load GUI and expose as an InGameMenu page
    MDMLog.info("MarketScreen: loading GUI '" .. tostring(modDir .. MDMMarketScreen.XML_FILENAME) .. "'")
    g_gui:loadGui(modDir .. MDMMarketScreen.XML_FILENAME, MDMMarketScreen.CLASS_NAME, screen, true)

    -- Apply robust fallback localization to ensure GUI texts are visible even if XML tokens didn't expand
    local function _applyGuiLocalization(scr)
        if scr == nil then return end
        local function _setById(id, key, fallback)
            local ok, el = pcall(function() return scr:getDescendantById(id) end)
            if not ok or el == nil then
                MDMLog.info("MarketScreen: applyGuiLocalization - control '" .. tostring(id) .. "' not found")
                return
            end
            local okTxt, txt = false, nil
            if key ~= nil then
                okTxt, txt = pcall(function() return g_i18n and g_i18n:getText(key) end)
            end
            if okTxt and txt and txt ~= "" then
                pcall(function() el:setText(txt) end)
            else
                pcall(function() el:setText(fallback or (key and tostring(key) or "")) end)
            end
        end

        _setById("categoryHeaderText", "mdm_screen_title", "Market Dynamics")
        _setById("commoditiesHeader", "mdm_screen_commodities", "COMMODITIES")
        _setById("colHeaderCrop", "mdm_screen_col_crop", "Crop")
        _setById("colHeaderPrice", "mdm_screen_col_price", "Price")
        _setById("colHeaderChange", "mdm_screen_col_change", "Change")

        _setById("graphHint", "mdm_screen_collecting", "Collecting data...")
        _setById("noEventsText", "mdm_screen_no_events", "No events")
        _setById("noContractsText", "mdm_screen_no_contracts", "No contracts")
        _setById("graphTitle", "mdm_screen_session_trend", "Session Timeline")
        -- Events/Contracts headers
        _setById("eventsHeader", "mdm_screen_events_hdr", "ACTIVE EVENTS")
        _setById("contractsHeader", "mdm_screen_contracts_hdr", "FUTURES CONTRACTS")
        -- Contracts column headers (fallback literals if no localization)
        _setById("contractsColCrop", "mdm_screen_col_crop", "Crop")
        _setById("contractsColQty", nil, "Qty")
        _setById("contractsColLocked", nil, "Locked")
        _setById("contractsColDelivered", nil, "Delivered")
        _setById("contractsColDeadline", nil, "Deadline")
        _setById("contractsColStatus", nil, "Status")

        -- Detail fields
        _setById("detailCropName", "mdm_screen_select_crop", "Select a commodity")
        _setById("detailCurrentPrice", nil, "")
        _setById("detailBasePrice", nil, "")
        _setById("detailChange", nil, "")
        _setById("detailVolatility", nil, "")
        _setById("detailModifiers", nil, "")
        return
    end

    -- Execute localization fallback now that GUI has been loaded
    local okLoc, errLoc = pcall(_applyGuiLocalization, screen)
    if not okLoc then
        MDMLog.error("MarketScreen: applyGuiLocalization failed: " .. tostring(errLoc))
    end

    -- Try to attach into inGameMenu similarly to EmployeeManager:addIngameMenuPage
    local inGameMenu = g_gui.screenControllers[InGameMenu] or g_inGameMenu
    if inGameMenu ~= nil and inGameMenu.pagingElement ~= nil and inGameMenu.pagingElement.elements ~= nil then
        -- Ensure controlIDs cleared for this page name (prevents conflicts)
        if g_inGameMenu ~= nil and g_inGameMenu.controlIDs ~= nil then
            for _, v in pairs({ MDMMarketScreen.MENU_PAGE_NAME }) do
                g_inGameMenu.controlIDs[v] = nil
            end
        end

        inGameMenu[MDMMarketScreen.MENU_PAGE_NAME] = screen

        -- Avoid adding the same element multiple times into pagingElement
        local alreadyAdded = false
        for _, el in ipairs(inGameMenu.pagingElement.elements) do
            if el == inGameMenu[MDMMarketScreen.MENU_PAGE_NAME] then
                alreadyAdded = true
                break
            end
        end
        if not alreadyAdded then
            inGameMenu.pagingElement:addElement(inGameMenu[MDMMarketScreen.MENU_PAGE_NAME])
        else
            MDMLog.info("MarketScreen: pagingElement already contains the page, not adding")
        end

        -- Expose controls safely
        if type(inGameMenu.exposeControlsAsFields) == "function" then
            local ok, err = pcall(inGameMenu.exposeControlsAsFields, inGameMenu, MDMMarketScreen.MENU_PAGE_NAME)
            if not ok then
                MDMLog.error("MarketScreen: exposeControlsAsFields failed: " .. tostring(err))
            else
                MDMLog.info("MarketScreen: exposeControlsAsFields OK")
            end
        else
            MDMLog.info("MarketScreen: exposeControlsAsFields not present")
        end

        -- Update layout mapping so the new page is placed correctly (safe)
        if type(inGameMenu.pagingElement.updateAbsolutePosition) == "function" then
            pcall(inGameMenu.pagingElement.updateAbsolutePosition, inGameMenu.pagingElement)
        end
        if type(inGameMenu.pagingElement.updatePageMapping) == "function" then
            pcall(inGameMenu.pagingElement.updatePageMapping, inGameMenu.pagingElement)
        end

        if type(inGameMenu.registerPage) == "function" then
            local ok, err = pcall(inGameMenu.registerPage, inGameMenu, inGameMenu[MDMMarketScreen.MENU_PAGE_NAME], nil, function() return true end)
            if not ok then
                MDMLog.error("MarketScreen: registerPage failed: " .. tostring(err))
            else
                MDMLog.info("MarketScreen: registerPage OK")
            end
        else
            MDMLog.info("MarketScreen: registerPage not present")
        end

        local iconFile = Utils.getFilename(MDMMarketScreen.MENU_ICON_PATH, modDir)
        local uvs = {0, 0, 1024, 1024}
        if iconFile ~= nil and type(inGameMenu.addPageTab) == "function" and GuiUtils ~= nil then
            local ok, err = pcall(inGameMenu.addPageTab, inGameMenu, inGameMenu[MDMMarketScreen.MENU_PAGE_NAME], iconFile, GuiUtils.getUVs(uvs))
            if not ok then
                MDMLog.error("MarketScreen: addPageTab failed: " .. tostring(err))
            else
                MDMLog.info("MarketScreen: addPageTab OK (iconFile=" .. tostring(iconFile) .. ")")
            end
        else
            MDMLog.info("MarketScreen: addPageTab skipped (iconFile=" .. tostring(iconFile) .. ")")
        end

        if type(inGameMenu.rebuildTabList) == "function" then
            pcall(inGameMenu.rebuildTabList, inGameMenu)
        end

        -- Call initialize AFTER full registration (matches EmployeeManager flow)
        if type(screen.initialize) == "function" then
            local ok, err = pcall(screen.initialize, screen)
            if not ok then
                MDMLog.error("MarketScreen: screen.initialize failed: " .. tostring(err))
            else
                MDMLog.info("MarketScreen: screen.initialize OK")
            end
        end
    end

    MDMLog.info("MarketScreen: GUI loaded and registered")
    return true
end

function MDMMarketScreen._attemptDeferredRegister(dt)
    if not _pendingRegistration then return end
    if MDMMarketScreen._performRegistration(_pendingModDir or _modDir) then
        _pendingRegistration = false
        _pendingModDir = nil
    end
end

local function _registerToggleAction(mission)
    local _, eventId = g_inputBinding:registerActionEvent(
        InputAction.MDM_MARKET_SCREEN, nil, MDMMarketScreen.toggle,
        false, true, false, true
    )
    if eventId then
        g_inputBinding:setActionEventTextVisibility(eventId, false)
    end
end

local function _onUpdate(mission, dt)
    MDMMarketScreenGraph.update(dt)
    -- One-shot deferred registration attempt (if register was deferred)
    MDMMarketScreen._attemptDeferredRegister(dt)
end

local function _onDelete(mission)
    MDMMarketScreenGraph.reset()
end

Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished, _onMissionLoaded)
Mission00.onStartMission        = Utils.appendedFunction(Mission00.onStartMission, _registerToggleAction)
FSBaseMission.update            = Utils.appendedFunction(FSBaseMission.update, _onUpdate)
FSBaseMission.delete            = Utils.appendedFunction(FSBaseMission.delete, _onDelete)

MDMLog.info("MarketScreen: lifecycle hooks installed")
