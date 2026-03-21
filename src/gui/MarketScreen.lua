MDMMarketScreen = {}

MDMMarketScreen.CLASS_NAME = "MDMMarketScreen"
MDMMarketScreen.MENU_PAGE_NAME = "menuMarketDynamics"
MDMMarketScreen.XML_FILENAME = "xml/gui/MarketScreen.xml"

MDMMarketScreen.MENU_ICON_PATH = "images/menuIcon.dds"

MDMMarketScreen._mt = Class(MDMMarketScreen, TabbedMenuFrameElement)

local TAB_PRICES    = 1
local TAB_EVENTS    = 2
local TAB_CONTRACTS = 3

local REFRESH_INTERVAL = 1000

-- ---------------------------------------------------------------------------
-- Constructor
-- ---------------------------------------------------------------------------

function MDMMarketScreen.new()
    local self = MDMMarketScreen:superClass().new(nil, MDMMarketScreen._mt)

    self.name       = "MDMMarketScreen"
    self.className  = "MDMMarketScreen"

    self.activeTab         = TAB_PRICES
    self.commodities       = {}
    self.selectedCropIndex = 1
    self.eventData         = {}
    self.contractData      = {}
    self.refreshTimer      = 0
    self.returnScreenName  = ""
    self.menuButtonInfo    = {}

    return self
end

function MDMMarketScreen:initialize()
    MDMLog.info("MarketScreen: initializing")

    MDMMarketScreen:superClass().initialize(self)
end

-- ---------------------------------------------------------------------------
-- Static methods
-- ---------------------------------------------------------------------------

function MDMMarketScreen.register(modDir)
    if MDMMarketScreen._performRegistration(modDir) then
        return
    end

    _pendingRegistration = true
    _pendingModDir = modDir
    MDMLog.info("MarketScreen: deferred registration until GUI/InGameMenu ready")
end

function MDMMarketScreen.show()
    local inGameMenu = g_gui.screenControllers[InGameMenu] or g_inGameMenu
    if inGameMenu == nil then
        MDMLog.info("MarketScreen.show: inGameMenu is nil — cannot open")
        return
    end
    local page = inGameMenu[MDMMarketScreen.MENU_PAGE_NAME]
    if page == nil then
        MDMLog.info("MarketScreen.show: page '" .. MDMMarketScreen.MENU_PAGE_NAME .. "' not registered — cannot open")
        return
    end
    MDMLog.info("MarketScreen.show: opening screen")
    g_gui:showGui("InGameMenu")
    inGameMenu:goToPage(page)
end

function MDMMarketScreen.toggle()
    MDMLog.info("MarketScreen.toggle: called")
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

    self.commodityList   = self:getDescendantById("commodityList")
    self.eventList       = self:getDescendantById("eventList")
    self.contractList    = self:getDescendantById("contractList")

    self.pricesContent   = self:getDescendantById("pricesContent")
    self.eventsContent   = self:getDescendantById("eventsContent")
    self.contractsContent = self:getDescendantById("contractsContent")

    self.categoryHeaderText = self:getDescendantById("categoryHeaderText")

    self.commoditiesHeader = self:getDescendantById("commoditiesHeader")
    self.colHeaderCrop = self:getDescendantById("colHeaderCrop")
    self.colHeaderPrice = self:getDescendantById("colHeaderPrice")
    self.colHeaderChange = self:getDescendantById("colHeaderChange")

    self.detailCropName    = self:getDescendantById("detailCropName")
    self.detailCurrentPrice = self:getDescendantById("detailCurrentPrice")
    self.detailBasePrice   = self:getDescendantById("detailBasePrice")
    self.detailChange      = self:getDescendantById("detailChange")
    self.detailVolatility  = self:getDescendantById("detailVolatility")
    self.detailModifiers   = self:getDescendantById("detailModifiers")

    self.currentBalanceText = self:getDescendantById("currentBalanceText")
    self.shopMoneyBox   = self:getDescendantById("shopMoneyBox")
    self.shopMoneyBoxBg = self:getDescendantById("shopMoneyBoxBg")

    self.graphArea = self:getDescendantById("graphArea")
    self.graphTitle = self:getDescendantById("graphTitle")
    self.graphHint = self:getDescendantById("graphHint")

    self.eventsHeader = self:getDescendantById("eventsHeader")
    self.noEventsText = self:getDescendantById("noEventsText")

    self.tabLabelPrices    = self:getDescendantById("tabLabelPrices")
    self.tabLabelEvents    = self:getDescendantById("tabLabelEvents")
    self.tabLabelContracts = self:getDescendantById("tabLabelContracts")

    self.tabUnderlinePrices    = self:getDescendantById("tabUnderlinePrices")
    self.tabUnderlineEvents    = self:getDescendantById("tabUnderlineEvents")
    self.tabUnderlineContracts = self:getDescendantById("tabUnderlineContracts")

    self.contractsHeader = self:getDescendantById("contractsHeader")
    self.contractsColCrop = self:getDescendantById("contractsColCrop")
    self.noContractsText = self:getDescendantById("noContractsText")
    self.newContractHint = self:getDescendantById("newContractHint")

    -- Contract dialog elements
    self.contractDialog    = self:getDescendantById("contractDialog")
    self.dialogCropList    = self:getDescendantById("dialogCropList")
    self.dialogNoCropsText = self:getDescendantById("dialogNoCropsText")
    self.dialogBcBlocked   = self:getDescendantById("dialogBcBlocked")
    self.dialogSignal      = self:getDescendantById("dialogSignal")
    self.dialogConfirmBtn  = self:getDescendantById("dialogConfirmBtn")
    self.qtyBtn500         = self:getDescendantById("qtyBtn500")
    self.qtyBtn1000        = self:getDescendantById("qtyBtn1000")
    self.qtyBtn5000        = self:getDescendantById("qtyBtn5000")
    self.qtyBtn10000       = self:getDescendantById("qtyBtn10000")
    self.qtyBtn25000       = self:getDescendantById("qtyBtn25000")
    self.qtyBtn50000       = self:getDescendantById("qtyBtn50000")
    self.delBtn30          = self:getDescendantById("delBtn30")
    self.delBtn60          = self:getDescendantById("delBtn60")
    self.delBtn90          = self:getDescendantById("delBtn90")
    self.delBtn120         = self:getDescendantById("delBtn120")
    self.sumCrop           = self:getDescendantById("sumCrop")
    self.sumQty            = self:getDescendantById("sumQty")
    self.sumLocked         = self:getDescendantById("sumLocked")
    self.sumTotal          = self:getDescendantById("sumTotal")
    self.sumDeadline       = self:getDescendantById("sumDeadline")
    self.sumPenalty        = self:getDescendantById("sumPenalty")

    -- Dialog state
    self.dialogOpen            = false
    self.dialogSelectedCropIdx = 1
    self.dialogQty             = 5000
    self.dialogDeliveryDays    = 30
    self._contractActionEventId = nil

    if self.dialogCropList then
        self.dialogCropList.dataSource = self
        self.dialogCropList.delegate   = self
    end

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
    _setTextSafe(self.currentBalanceText, nil, "")
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
    _setTextSafe(self.newContractHint, "mdm_screen_new_contract_btn", "New Contract [N]")
end

function MDMMarketScreen:onOpen()
    MDMMarketScreen:superClass().onOpen(self)

    self:onMoneyChange()
    self:rebuildAllData()
    self:setActiveTab(TAB_PRICES)
    self:reloadAllLists()

    if self.selectedCropIndex > 0 and #self.commodities > 0 then
        self:refreshPricesDetail()
    end

    -- Register contract dialog keyboard shortcut while screen is open
    MDMLog.info("MarketScreen.onOpen: registering MDM_CREATE_CONTRACT action (InputAction=" .. tostring(InputAction.MDM_CREATE_CONTRACT) .. ")")
    if InputAction.MDM_CREATE_CONTRACT then
        local _, evId = g_inputBinding:registerActionEvent(
            InputAction.MDM_CREATE_CONTRACT, self, MDMMarketScreen.onContractActionEvent,
            false, true, false, true)
        if evId then
            self._contractActionEventId = evId
            g_inputBinding:setActionEventTextVisibility(evId, false)
            MDMLog.info("MarketScreen.onOpen: MDM_CREATE_CONTRACT registered (evId=" .. tostring(evId) .. ")")
        else
            MDMLog.info("MarketScreen.onOpen: MDM_CREATE_CONTRACT registerActionEvent returned nil evId")
        end
    else
        MDMLog.info("MarketScreen.onOpen: InputAction.MDM_CREATE_CONTRACT is nil — N key will not work")
    end
end

function MDMMarketScreen:onClose()
    self:closeContractDialog()

    if self._contractActionEventId then
        g_inputBinding:removeActionEvent(self._contractActionEventId)
        self._contractActionEventId = nil
    end

    MDMMarketScreen:superClass().onClose(self)
end

-- Called by registered action event (key N)
function MDMMarketScreen:onContractActionEvent()
    MDMLog.info("MarketScreen: N key fired — dialogOpen=" .. tostring(self.dialogOpen))
    if self.dialogOpen then
        self:closeContractDialog()
    else
        self:openContractDialog()
    end
end

-- Called by the "New Contract [N]" button in the contracts tab
function MDMMarketScreen:onNewContractClick()
    MDMLog.info("MarketScreen: New Contract button clicked")
    self:openContractDialog()
end

function MDMMarketScreen:onMoneyChange()
    if g_localPlayer == nil or g_farmManager == nil then return end
    local farm = g_farmManager:getFarmById(g_localPlayer.farmId)
    if farm == nil then return end

    local isNegative = farm.money <= -1
    local profileName = "fs25_shopMoney"

    if ShopMenu and ShopMenu.GUI_PROFILE then
        profileName = isNegative
            and ShopMenu.GUI_PROFILE.SHOP_MONEY_NEGATIVE
            or  ShopMenu.GUI_PROFILE.SHOP_MONEY
    elseif isNegative then
        profileName = "fs25_shopMoneyNegative"
    end

    if self.currentBalanceText then
        self.currentBalanceText:applyProfile(profileName, nil, true)
        self.currentBalanceText:setText(g_i18n:formatMoney(farm.money, 0, true, false))
    end

    if self.shopMoneyBox ~= nil and self.shopMoneyBoxBg ~= nil then
        self.shopMoneyBox:invalidateLayout()
        self.shopMoneyBoxBg:setSize(self.shopMoneyBox.flowSizes[1] + 60 * g_pixelSizeScaledX)
    end
end

function MDMMarketScreen:update(dt)
    MDMMarketScreen:superClass().update(self, dt)

    self.refreshTimer = self.refreshTimer + dt
    if self.refreshTimer >= REFRESH_INTERVAL then
        self.refreshTimer = 0
        self:rebuildAllData()
        self:reloadAllLists()
        self:onMoneyChange()

        if self.activeTab == TAB_PRICES then
            self:refreshPricesDetail()
        end
    end
end

MDMMarketScreen._graphAreaLogDone = false

function MDMMarketScreen:draw()
    MDMMarketScreen:superClass().draw(self)

    if self.activeTab == TAB_PRICES and self.graphArea then
        local pos = self.graphArea.absPosition
        local sz  = self.graphArea.absSize

        if not pos or not sz or not pos[1] or not pos[2] or not sz[1] or not sz[2] then
            return
        end

        if not MDMMarketScreen._graphAreaLogDone then
            MDMLog.info("MarketScreen: graphArea pos=(" .. tostring(pos[1]) .. ", " .. tostring(pos[2]) .. ") size=(" .. tostring(sz[1]) .. ", " .. tostring(sz[2]) .. ")")
            MDMMarketScreen._graphAreaLogDone = true
        end

        local crop = self.commodities[self.selectedCropIndex]
        local fillIdx = crop and crop.idx or nil

        local sampleCount = 0
        if fillIdx then
            sampleCount = MDMMarketScreenGraph.getSampleCount(fillIdx)
        end
        if sampleCount < 2 then
            sampleCount = MDMMarketScreenGraph.getGlobalSampleCount()
        end

        if sampleCount >= 2 then
            if self.graphHint then
                self.graphHint:setVisible(false)
            end

            if fillIdx and MDMMarketScreenGraph.getSampleCount(fillIdx) >= 2 then
                MDMMarketScreenGraph.draw(fillIdx, pos[1], pos[2], sz[1], sz[2])
            else
                MDMMarketScreenGraph.drawAggregatedMedian(pos[1], pos[2], sz[1], sz[2])
            end
        elseif fillIdx and g_MarketDynamics and g_MarketDynamics.marketEngine then
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

function MDMMarketScreen:inputEvent(action, value, eventUsed)
    -- Handle our keys BEFORE super so TabbedMenuFrameElement doesn't consume them
    if not eventUsed and value > 0 and not self.dialogOpen then
        if action == InputAction.MENU_PAGE_PREV then
            local newTab = self.activeTab - 1
            if newTab < TAB_PRICES then newTab = TAB_CONTRACTS end
            self:setActiveTab(newTab)
            return true
        end
        if action == InputAction.MENU_PAGE_NEXT then
            local newTab = self.activeTab + 1
            if newTab > TAB_CONTRACTS then newTab = TAB_PRICES end
            self:setActiveTab(newTab)
            return true
        end
        -- N key: open contract dialog (inputEvent is the reliable path inside InGameMenu)
        if action == InputAction.MDM_CREATE_CONTRACT then
            MDMLog.info("MarketScreen: N key via inputEvent — opening contract dialog")
            self:openContractDialog()
            return true
        end
    end

    eventUsed = MDMMarketScreen:superClass().inputEvent(self, action, value, eventUsed)
    if eventUsed then return true end

    -- While the dialog is open: Escape closes, Enter confirms, everything else blocked
    if self.dialogOpen then
        if value > 0 then
            if action == InputAction.MENU_CANCEL then
                self:closeContractDialog()
                return true
            end
            if action == InputAction.MENU_ACCEPT then
                self:onDialogConfirm()
                return true
            end
        end
        return true  -- absorb tab-switch, back, etc.
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
    elseif list == self.dialogCropList then
        return #self.commodities
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
    elseif list == self.dialogCropList then
        self:_populateDialogCropCell(index, cell)
    end
end

-- ---------------------------------------------------------------------------
-- SmoothList Delegate — selection & click
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onListSelectionChanged(list, section, index)
    if list == self.commodityList and index > 0 then
        self.selectedCropIndex = index
        self:refreshPricesDetail()
    elseif list == self.dialogCropList and index > 0 then
        self.dialogSelectedCropIdx = index
        self:_updateDialogSummary()
        if self.dialogCropList then self.dialogCropList:reloadData() end
    end
end

function MDMMarketScreen:onClickCommodity(element)
    -- onListSelectionChanged handles selection; nothing extra needed
end

-- ---------------------------------------------------------------------------
-- Tab Switching
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onClickTabPrices()
    MDMLog.info("MarketScreen: tab click -> PRICES")
    self:setActiveTab(TAB_PRICES)
end

function MDMMarketScreen:onClickTabEvents()
    MDMLog.info("MarketScreen: tab click -> EVENTS")
    self:setActiveTab(TAB_EVENTS)
end

function MDMMarketScreen:onClickTabContracts()
    MDMLog.info("MarketScreen: tab click -> CONTRACTS")
    self:setActiveTab(TAB_CONTRACTS)
end

-- Manual mouse-click detection for tab labels.
-- FS25 doesn't always route Button onClick through TabbedMenuFrameElement custom pages,
-- so we hit-test the confirmed-visible label elements directly.
function MDMMarketScreen:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
    if isDown and button == Input.MOUSE_BUTTON_LEFT and not self.dialogOpen then
        local tabs = {
            { el = self.tabLabelPrices,    cb = MDMMarketScreen.onClickTabPrices    },
            { el = self.tabLabelEvents,    cb = MDMMarketScreen.onClickTabEvents    },
            { el = self.tabLabelContracts, cb = MDMMarketScreen.onClickTabContracts },
        }
        for _, t in ipairs(tabs) do
            if t.el then
                local ap = t.el.absPosition
                local as = t.el.absSize
                if ap and as and
                   posX >= ap[1] and posX <= ap[1] + as[1] and
                   posY >= ap[2] and posY <= ap[2] + as[2] then
                    t.cb(self)
                    return true
                end
            end
        end
    end
    return MDMMarketScreen:superClass().mouseEvent(self, posX, posY, isDown, isUp, button, eventUsed)
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

    -- Color tab indicator labels: active = MDM green, inactive = dim white
    local function _tabColor(el, isActive)
        if not el then return end
        if isActive then
            el:setTextColor(0.0, 0.82, 0.48, 1.0)
        else
            el:setTextColor(1.0, 1.0, 1.0, 0.40)
        end
    end
    _tabColor(self.tabLabelPrices,    tab == TAB_PRICES)
    _tabColor(self.tabLabelEvents,    tab == TAB_EVENTS)
    _tabColor(self.tabLabelContracts, tab == TAB_CONTRACTS)

    -- Show underline only under the active tab
    if self.tabUnderlinePrices    then self.tabUnderlinePrices:setVisible(tab == TAB_PRICES) end
    if self.tabUnderlineEvents    then self.tabUnderlineEvents:setVisible(tab == TAB_EVENTS) end
    if self.tabUnderlineContracts then self.tabUnderlineContracts:setVisible(tab == TAB_CONTRACTS) end
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
            -- Only show harvestable field crops (not livestock, packaging, byproducts)
            local isCrop = g_fruitTypeManager ~= nil
                and g_fruitTypeManager.getFruitTypeByFillTypeIndex ~= nil
                and g_fruitTypeManager:getFruitTypeByFillTypeIndex(fillTypeIndex) ~= nil
            if isCrop then
                local changePct = engine:getPriceChangePercent(fillTypeIndex)
                table.insert(self.commodities, {
                    idx        = fillTypeIndex,
                    name       = fillType.name,
                    title      = fillType.title or fillType.name,
                    current    = entry.current,
                    base       = entry.base,
                    changePct  = changePct,
                    volatility = entry.volatilityFactor,
                    modifiers  = entry.modifiers,
                    hudOverlay = fillType.hudOverlayFilename,
                })
            end
        end
    end

    table.sort(self.commodities, function(a, b) return a.title < b.title end)

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

    if self.noEventsText then
        self.noEventsText:setVisible(#self.eventData == 0)
    end
end

function MDMMarketScreen:_buildContractData()
    self.contractData = {}

    if not g_MarketDynamics or not g_MarketDynamics.futuresMarket then return end
    if not g_localPlayer then return end

    local farmId = g_localPlayer.farmId
    if not farmId then return end

    local contracts = g_MarketDynamics.futuresMarket:getContractsForFarm(farmId)
    for _, c in ipairs(contracts) do
        table.insert(self.contractData, c)
    end

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
-- Contract Dialog — Open / Close / Update
-- ---------------------------------------------------------------------------

function MDMMarketScreen:openContractDialog()
    MDMLog.info("MarketScreen.openContractDialog: called — contractDialog=" .. tostring(self.contractDialog) .. " activeTab=" .. tostring(self.activeTab))
    -- BetterContracts mode: futures UI is suppressed
    local bcBlocked = BCIntegration and BCIntegration.isEnabled()

    if self.contractDialog then
        self.contractDialog:setVisible(true)
    end

    -- Show BC-blocked message and hide everything else
    if self.dialogBcBlocked then
        self.dialogBcBlocked:setVisible(bcBlocked)
    end
    if self.dialogSignal then
        self.dialogSignal:setVisible(not bcBlocked)
    end
    if self.dialogConfirmBtn then
        self.dialogConfirmBtn:setDisabled(bcBlocked)
    end

    if bcBlocked then
        self.dialogOpen = true
        return
    end

    -- Pre-select the crop highlighted in the prices list
    self.dialogSelectedCropIdx = math.max(1, self.selectedCropIndex)
    self.dialogQty             = 5000
    self.dialogDeliveryDays    = 30
    self.dialogOpen            = true
    self:_updateDialogButtonStates()  -- highlight default qty/delivery buttons immediately

    -- Show/hide empty hint
    local hasCrops = #self.commodities > 0
    if self.dialogNoCropsText then
        self.dialogNoCropsText:setVisible(not hasCrops)
    end

    if self.dialogCropList then
        self.dialogCropList:reloadData()
        if hasCrops then
            self.dialogCropList:setSelectedIndex(self.dialogSelectedCropIdx)
        end
    end

    self:_updateDialogSummary()
    self:_updateDialogButtonStates()
end

function MDMMarketScreen:closeContractDialog()
    self.dialogOpen = false
    if self.contractDialog then
        self.contractDialog:setVisible(false)
    end
end

-- Highlight active qty/delivery buttons with green text; unselected stays light grey
function MDMMarketScreen:_updateDialogButtonStates()
    local SEL   = {0.0, 0.83, 0.49, 1.0}   -- MDM green
    local UNSEL = {0.75, 0.75, 0.75, 1.0}  -- muted grey

    local qtyMap = {
        [500] = self.qtyBtn500,   [1000]  = self.qtyBtn1000,
        [5000] = self.qtyBtn5000, [10000] = self.qtyBtn10000,
        [25000] = self.qtyBtn25000, [50000] = self.qtyBtn50000,
    }
    for qty, btn in pairs(qtyMap) do
        if btn then
            local c = (qty == self.dialogQty) and SEL or UNSEL
            btn:setTextColor(c[1], c[2], c[3], c[4])
        end
    end

    local delMap = {
        [30] = self.delBtn30, [60]  = self.delBtn60,
        [90] = self.delBtn90, [120] = self.delBtn120,
    }
    for days, btn in pairs(delMap) do
        if btn then
            local c = (days == self.dialogDeliveryDays) and SEL or UNSEL
            btn:setTextColor(c[1], c[2], c[3], c[4])
        end
    end
end

-- Live-update the summary panel as selections change
function MDMMarketScreen:_updateDialogSummary()
    local crop = self.commodities[self.dialogSelectedCropIdx]

    if not crop then
        local blank = "—"
        if self.sumCrop     then self.sumCrop:setText(blank) end
        if self.sumQty      then self.sumQty:setText(blank) end
        if self.sumLocked   then self.sumLocked:setText(blank) end
        if self.sumTotal    then self.sumTotal:setText(blank) end
        if self.sumDeadline then self.sumDeadline:setText(blank) end
        if self.sumPenalty  then self.sumPenalty:setText("") end
        if self.dialogSignal then self.dialogSignal:setText("") end
        return
    end

    local lockedPrice = crop.current
    local totalValue  = math.floor(lockedPrice * self.dialogQty)

    if self.sumCrop then
        self.sumCrop:setText("Crop:         " .. crop.title)
    end
    if self.sumQty then
        self.sumQty:setText("Quantity:     " .. self:_fmtNum(self.dialogQty) .. " L")
    end
    if self.sumLocked then
        self.sumLocked:setText(string.format("Locked price: $%.2f / L", lockedPrice))
    end
    if self.sumTotal then
        self.sumTotal:setText("Total:  $" .. self:_fmtNum(totalValue))
    end
    if self.sumDeadline then
        self.sumDeadline:setText("Deliver in:   " .. self.dialogDeliveryDays .. " days")
    end
    if self.sumPenalty then
        self.sumPenalty:setText("Default penalty: 15% on unfulfilled qty")
    end

    -- Price signal: compare current price to base
    if self.dialogSignal and crop.base and crop.base > 0 then
        local pct = ((lockedPrice - crop.base) / crop.base) * 100
        if pct > 5 then
            self.dialogSignal:setText(string.format(
                "▲  %.1f%% above base — good time to lock in", pct))
            self.dialogSignal:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif pct < -5 then
            self.dialogSignal:setText(string.format(
                "▼  %.1f%% below base — consider waiting", math.abs(pct)))
            self.dialogSignal:setTextColor(0.85, 0.30, 0.22, 1.0)
        else
            self.dialogSignal:setText(string.format(
                "◆  Near baseline (%.1f%%) — neutral", pct))
            self.dialogSignal:setTextColor(0.90, 0.72, 0.15, 1.0)
        end
    end
end

-- Format a number with comma thousands separator  e.g. 25000 → "25,000"
function MDMMarketScreen:_fmtNum(n)
    local s = tostring(math.floor(n))
    local result, count = "", 0
    for i = #s, 1, -1 do
        if count > 0 and count % 3 == 0 then result = "," .. result end
        result = s:sub(i, i) .. result
        count  = count + 1
    end
    return result
end

-- ---------------------------------------------------------------------------
-- Contract Dialog — Button Callbacks
-- ---------------------------------------------------------------------------

function MDMMarketScreen:onDialogCropClick()
    -- selection is handled by onListSelectionChanged
end

function MDMMarketScreen:onDialogQtyClick(element)
    local map = {
        [self.qtyBtn500]   = 500,   [self.qtyBtn1000]  = 1000,
        [self.qtyBtn5000]  = 5000,  [self.qtyBtn10000] = 10000,
        [self.qtyBtn25000] = 25000, [self.qtyBtn50000] = 50000,
    }
    local qty = map[element]
    if qty then
        self.dialogQty = qty
        self:_updateDialogSummary()
        self:_updateDialogButtonStates()
    end
end

function MDMMarketScreen:onDialogDeliveryClick(element)
    local map = {
        [self.delBtn30] = 30, [self.delBtn60]  = 60,
        [self.delBtn90] = 90, [self.delBtn120] = 120,
    }
    local days = map[element]
    if days then
        self.dialogDeliveryDays = days
        self:_updateDialogSummary()
        self:_updateDialogButtonStates()
    end
end

function MDMMarketScreen:onDialogCancel()
    self:closeContractDialog()
end

function MDMMarketScreen:onDialogConfirm()
    if BCIntegration and BCIntegration.isEnabled() then
        self:closeContractDialog()
        return
    end

    local crop = self.commodities[self.dialogSelectedCropIdx]
    if not crop then
        MDMLog.warn("MarketScreen: contract confirm — no crop selected")
        return
    end
    if not g_MarketDynamics or not g_MarketDynamics.futuresMarket then
        MDMLog.warn("MarketScreen: contract confirm — futures market unavailable")
        return
    end
    if not g_localPlayer then return end
    local farmId = g_localPlayer.farmId
    if not farmId then return end

    local now            = g_currentMission and g_currentMission.time or 0
    local deliveryTimeMs = now + (self.dialogDeliveryDays * 24 * 60 * 60000)

    g_MarketDynamics.futuresMarket:createContract({
        farmId         = farmId,
        fillTypeIndex  = crop.idx,
        fillTypeName   = crop.title,
        quantity       = self.dialogQty,
        lockedPrice    = crop.current,
        deliveryTimeMs = deliveryTimeMs,
    })

    MDMLog.info(string.format(
        "MarketScreen: contract — %s  %sL @ $%.2f  delivery in %dd",
        crop.title, self:_fmtNum(self.dialogQty), crop.current, self.dialogDeliveryDays))

    self:closeContractDialog()
    self:setActiveTab(TAB_CONTRACTS)
    self:_buildContractData()
    self:reloadAllLists()
end

-- ---------------------------------------------------------------------------
-- Cell Population
-- ---------------------------------------------------------------------------

function MDMMarketScreen:_populateDialogCropCell(index, cell)
    local data = self.commodities[index]
    if not data then return end

    local isSelected = (index == self.dialogSelectedCropIdx)

    local nameEl  = cell:getDescendantByName("dlgName")
    local priceEl = cell:getDescendantByName("dlgPrice")
    local chgEl   = cell:getDescendantByName("dlgChg")

    if nameEl then
        nameEl:setText((isSelected and "• " or "  ") .. data.title)
        if isSelected then
            nameEl:setTextColor(0.0, 0.83, 0.49, 1.0)
        else
            nameEl:setTextColor(0.85, 0.85, 0.85, 1.0)
        end
    end
    if priceEl then
        priceEl:setText(string.format("$%.2f", data.current))
    end
    if chgEl then
        local sign = data.changePct >= 0 and "+" or ""
        chgEl:setText(string.format("%s%.1f%%", sign, data.changePct))
        if data.changePct > 0.5 then
            chgEl:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif data.changePct < -0.5 then
            chgEl:setTextColor(0.85, 0.22, 0.22, 1.0)
        else
            chgEl:setTextColor(0.65, 0.65, 0.65, 1.0)
        end
    end
end

function MDMMarketScreen:_populateCommodityCell(index, cell)
    local data = self.commodities[index]
    if not data then return end

    local iconEl   = cell:getDescendantByName("cropIcon")
    local nameEl   = cell:getDescendantByName("cropName")
    local priceEl  = cell:getDescendantByName("cropPrice")
    local changeEl = cell:getDescendantByName("cropChange")

    if iconEl then
        if data.hudOverlay and data.hudOverlay ~= "" then
            iconEl:setImageFilename(data.hudOverlay)
            iconEl:setVisible(true)
        else
            iconEl:setVisible(false)
        end
    end

    if nameEl then
        nameEl:setText(data.title)
    end
    if priceEl then
        priceEl:setText(string.format("$%.0f", data.current))
    end
    if changeEl then
        local sign = data.changePct >= 0 and "+" or ""
        changeEl:setText(string.format("%s%.1f%%", sign, data.changePct))

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
        priceEl:setText(string.format("$%.2f", data.lockedPrice))
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
            local now = g_currentMission and g_currentMission.time or 0
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

    if self.graphTitle then
        self.graphTitle:setText(crop.title .. " — " .. g_i18n:getText("mdm_screen_session_trend"))
    end
end

-- ---------------------------------------------------------------------------
-- Module-level lifecycle hooks
-- Wired at source() time. MarketScreen manages its own registration.
-- ---------------------------------------------------------------------------

local _modDir = g_currentModDirectory
local _pendingRegistration = false
local _pendingModDir = nil

local function _onMissionLoaded(mission)
    MDMMarketScreen.register(_modDir)
end

function MDMMarketScreen._performRegistration(modDir)
    if g_gui == nil or g_inGameMenu == nil then
        return false
    end

    if g_inGameMenu[MDMMarketScreen.MENU_PAGE_NAME] ~= nil then
        MDMLog.info("MarketScreen: page already registered, skipping")
        return true
    end

    local screen = MDMMarketScreen.new()

    MDMLog.info("MarketScreen: loading GUI '" .. tostring(modDir .. MDMMarketScreen.XML_FILENAME) .. "'")
    g_gui:loadGui(modDir .. MDMMarketScreen.XML_FILENAME, MDMMarketScreen.CLASS_NAME, screen, true)

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

        _setById("eventsHeader", "mdm_screen_events_hdr", "ACTIVE EVENTS")
        _setById("contractsHeader", "mdm_screen_contracts_hdr", "FUTURES CONTRACTS")

        _setById("contractsColCrop",      "mdm_screen_col_crop",      "Crop")
        _setById("contractsColQty",       "mdm_screen_col_qty",       "Qty")
        _setById("contractsColLocked",    "mdm_screen_col_locked",    "Locked")
        _setById("contractsColDelivered", "mdm_screen_col_delivered", "Delivered")
        _setById("contractsColDeadline",  "mdm_screen_col_deadline",  "Deadline")
        _setById("contractsColStatus",    "mdm_screen_col_status",    "Status")
        _setById("newContractHint",       "mdm_screen_new_contract_btn", "New Contract  [N]")
        _setById("dialogTitleText",       "mdm_futures_new_title",    "New Futures Contract")
        _setById("dialogBcBlocked",       "mdm_dialog_bc_blocked",    "Futures disabled")
        _setById("dialogNoCropsText",     "mdm_dialog_no_crops",      "No market data available yet.")

        _setById("detailCropName", "mdm_screen_select_crop", "Select a commodity")
        _setById("detailCurrentPrice", nil, "")
        _setById("detailBasePrice", nil, "")
        _setById("detailChange", nil, "")
        _setById("detailVolatility", nil, "")
        _setById("detailModifiers", nil, "")
        return
    end

    local okLoc, errLoc = pcall(_applyGuiLocalization, screen)
    if not okLoc then
        MDMLog.error("MarketScreen: applyGuiLocalization failed: " .. tostring(errLoc))
    end

    local inGameMenu = g_gui.screenControllers[InGameMenu] or g_inGameMenu
    if inGameMenu ~= nil and inGameMenu.pagingElement ~= nil and inGameMenu.pagingElement.elements ~= nil then
        -- Ensure controlIDs cleared for this page name (prevents conflicts)
        if g_inGameMenu ~= nil and g_inGameMenu.controlIDs ~= nil then
            for _, v in pairs({ MDMMarketScreen.MENU_PAGE_NAME }) do
                g_inGameMenu.controlIDs[v] = nil
            end
        end

        inGameMenu[MDMMarketScreen.MENU_PAGE_NAME] = screen

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
    MDMLog.info("MarketScreen: registering MDM_MARKET_SCREEN toggle (InputAction=" .. tostring(InputAction.MDM_MARKET_SCREEN) .. ")")
    local _, eventId = g_inputBinding:registerActionEvent(
        InputAction.MDM_MARKET_SCREEN, nil, MDMMarketScreen.toggle,
        false, true, false, true
    )
    if eventId then
        g_inputBinding:setActionEventTextVisibility(eventId, false)
        MDMLog.info("MarketScreen: F10 toggle registered (evId=" .. tostring(eventId) .. ")")
    else
        MDMLog.info("MarketScreen: F10 toggle registerActionEvent returned nil — F10 will not work")
    end
end

local function _onUpdate(mission, dt)
    MDMMarketScreenGraph.update(dt)
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
