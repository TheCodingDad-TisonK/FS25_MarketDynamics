-- MDMContractDialog.lua
-- Futures contract creation dialog — MessageDialog subclass.
-- Opened via MDMDialogLoader.show("MDMContractDialog", "setData", params).
--
-- params = {
--   commodities  = table of commodity data (from MarketScreen.commodities),
--   onConfirmed  = function(crop, qty, delivDays)  called on confirm,
--   selectedIdx  = pre-selected crop index,
-- }
--
-- NOTE: No SmoothList is used — SmoothList inside fs25_dialogContentContainer
-- causes a layout stack overflow during showDialog. Crop selection happens in
-- the main MarketScreen price list; the dialog operates on the selected crop.

MDMContractDialog = {}
local MDMContractDialog_mt = Class(MDMContractDialog, MessageDialog)

-- -----------------------------------------------------------------------
-- Constructor
-- -----------------------------------------------------------------------

function MDMContractDialog.new(target, custom_mt)
    local self = MessageDialog.new(target, custom_mt or MDMContractDialog_mt)

    self.commodities       = {}
    self.selectedCropIdx   = 1
    self.selectedQty       = 5000
    self.selectedDelivDays = 30
    self._onConfirmed      = nil

    -- isOpen is checked by MarketScreen.mouseEvent to block click-through
    self.isOpen = false

    -- Left column: selected crop display
    self.cropNameEl   = nil
    self.cropPriceEl  = nil
    self.cropChangeEl = nil
    self.noCropsText  = nil

    -- Right column
    self.signalText   = nil
    self.confirmBtn   = nil
    self.confirmText  = nil
    self.sumCrop      = nil
    self.sumQty       = nil
    self.sumLocked    = nil
    self.sumTotal     = nil
    self.sumDeadline  = nil
    self.sumPenalty   = nil

    -- Hit-area buttons (for click identity comparison)
    self.qtyBtns = {}
    self.delBtns = {}

    -- Text elements (for setTextColor on selection change)
    self.qtyBtnTexts = {}
    self.delBtnTexts = {}

    return self
end

-- -----------------------------------------------------------------------
-- Data setter — called by DialogLoader before showDialog()
-- -----------------------------------------------------------------------

function MDMContractDialog:setData(params)
    self.commodities       = params.commodities  or {}
    self._onConfirmed      = params.onConfirmed
    self.selectedCropIdx   = params.selectedIdx  or 1
    self.selectedQty       = 5000
    self.selectedDelivDays = 30
end

-- -----------------------------------------------------------------------
-- GUI lifecycle
-- -----------------------------------------------------------------------

function MDMContractDialog:onCreate()
    local ok, err = pcall(function() MDMContractDialog:superClass().onCreate(self) end)
    if not ok then MDMLog.warn("MDMContractDialog:onCreate superClass error: " .. tostring(err)) end
end

function MDMContractDialog:onGuiSetupFinished()
    MDMContractDialog:superClass().onGuiSetupFinished(self)

    -- Left column
    self.cropNameEl   = self:getDescendantById("dlgCropName")
    self.cropPriceEl  = self:getDescendantById("dlgCropPrice")
    self.cropChangeEl = self:getDescendantById("dlgCropChange")
    self.noCropsText  = self:getDescendantById("dlgNoCrops")

    -- Right column
    self.signalText   = self:getDescendantById("dlgSignal")
    self.confirmBtn   = self:getDescendantById("dlgConfirmBtn")
    self.confirmText  = self:getDescendantById("dlgConfirmText")
    self.sumCrop      = self:getDescendantById("dlgSumCrop")
    self.sumQty       = self:getDescendantById("dlgSumQty")
    self.sumLocked    = self:getDescendantById("dlgSumLocked")
    self.sumTotal     = self:getDescendantById("dlgSumTotal")
    self.sumDeadline  = self:getDescendantById("dlgSumDeadline")
    self.sumPenalty   = self:getDescendantById("dlgSumPenalty")

    -- Qty hit buttons and text labels
    self.qtyBtns = {
        [500]   = self:getDescendantById("dlgQty500"),
        [1000]  = self:getDescendantById("dlgQty1000"),
        [5000]  = self:getDescendantById("dlgQty5000"),
        [10000] = self:getDescendantById("dlgQty10000"),
        [25000] = self:getDescendantById("dlgQty25000"),
        [50000] = self:getDescendantById("dlgQty50000"),
    }
    self.delBtns = {
        [30]  = self:getDescendantById("dlgDel30"),
        [60]  = self:getDescendantById("dlgDel60"),
        [90]  = self:getDescendantById("dlgDel90"),
        [120] = self:getDescendantById("dlgDel120"),
    }
    self.qtyBtnTexts = {
        [500]   = self:getDescendantById("dlgQty500Text"),
        [1000]  = self:getDescendantById("dlgQty1000Text"),
        [5000]  = self:getDescendantById("dlgQty5000Text"),
        [10000] = self:getDescendantById("dlgQty10000Text"),
        [25000] = self:getDescendantById("dlgQty25000Text"),
        [50000] = self:getDescendantById("dlgQty50000Text"),
    }
    self.delBtnTexts = {
        [30]  = self:getDescendantById("dlgDel30Text"),
        [60]  = self:getDescendantById("dlgDel60Text"),
        [90]  = self:getDescendantById("dlgDel90Text"),
        [120] = self:getDescendantById("dlgDel120Text"),
    }

    local qtyCount = 0; for _ in pairs(self.qtyBtns) do qtyCount = qtyCount + 1 end
    MDMLog.info("MDMContractDialog:onGuiSetupFinished — confirmBtn=" .. tostring(self.confirmBtn ~= nil)
        .. " cropNameEl=" .. tostring(self.cropNameEl ~= nil)
        .. " qtyBtns=" .. qtyCount)
end

function MDMContractDialog:onOpen()
    MDMContractDialog:superClass().onOpen(self)

    self.isOpen = true

    local hasCrops = #self.commodities > 0

    if self.noCropsText then self.noCropsText:setVisible(not hasCrops) end
    if self.signalText  then self.signalText:setVisible(hasCrops) end
    if self.confirmBtn  then self.confirmBtn:setDisabled(not hasCrops) end

    self:_updateSummary()
    self:_updateButtonStates()

    -- Explicit focus prevents FS25 from auto-traversing all focusable elements
    if self.confirmBtn then
        FocusManager:setFocus(self.confirmBtn)
    end
end

function MDMContractDialog:onClose()
    self.isOpen = false
    MDMContractDialog:superClass().onClose(self)
end

-- -----------------------------------------------------------------------
-- Button callbacks (bound via XML onClick)
-- -----------------------------------------------------------------------

function MDMContractDialog:onQtyClick(element)
    for qty, btn in pairs(self.qtyBtns) do
        if btn == element then
            self.selectedQty = qty
            self:_updateSummary()
            self:_updateButtonStates()
            return
        end
    end
end

function MDMContractDialog:onDelivClick(element)
    for days, btn in pairs(self.delBtns) do
        if btn == element then
            self.selectedDelivDays = days
            self:_updateSummary()
            self:_updateButtonStates()
            return
        end
    end
end

function MDMContractDialog:onConfirmClick()
    local crop = self.commodities[self.selectedCropIdx]
    if not crop then return end
    if self._onConfirmed then
        self._onConfirmed(crop, self.selectedQty, self.selectedDelivDays)
    end
    self:close()
end

function MDMContractDialog:onCancelClick()
    self:close()
end

-- -----------------------------------------------------------------------
-- Internal helpers
-- -----------------------------------------------------------------------

function MDMContractDialog:_updateButtonStates()
    local SEL   = {0.0,  0.83, 0.49, 1.0}
    local UNSEL = {0.75, 0.75, 0.75, 1.0}

    for qty, txt in pairs(self.qtyBtnTexts) do
        if txt then
            local c = (qty == self.selectedQty) and SEL or UNSEL
            txt:setTextColor(c[1], c[2], c[3], c[4])
        end
    end
    for days, txt in pairs(self.delBtnTexts) do
        if txt then
            local c = (days == self.selectedDelivDays) and SEL or UNSEL
            txt:setTextColor(c[1], c[2], c[3], c[4])
        end
    end
end

function MDMContractDialog:_updateSummary()
    local crop = self.commodities[self.selectedCropIdx]

    if not crop then
        -- Left column
        if self.cropNameEl   then self.cropNameEl:setText("—") end
        if self.cropPriceEl  then self.cropPriceEl:setText("") end
        if self.cropChangeEl then self.cropChangeEl:setText("") end
        -- Right column
        local blank = "—"
        if self.sumCrop     then self.sumCrop:setText(blank) end
        if self.sumQty      then self.sumQty:setText(blank) end
        if self.sumLocked   then self.sumLocked:setText(blank) end
        if self.sumTotal    then self.sumTotal:setText(blank) end
        if self.sumDeadline then self.sumDeadline:setText(blank) end
        if self.sumPenalty  then self.sumPenalty:setText("") end
        if self.signalText  then self.signalText:setText("") end
        return
    end

    -- Left column: selected crop info
    if self.cropNameEl then
        self.cropNameEl:setText(crop.title)
    end
    if self.cropPriceEl then
        self.cropPriceEl:setText(string.format("Current price:  $%.2f / L", crop.current))
    end
    if self.cropChangeEl and crop.base and crop.base > 0 then
        local pct  = ((crop.current - crop.base) / crop.base) * 100
        local sign = pct >= 0 and "+" or ""
        self.cropChangeEl:setText(string.format("Change from base:  %s%.1f%%", sign, pct))
        if pct > 0.5 then
            self.cropChangeEl:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif pct < -0.5 then
            self.cropChangeEl:setTextColor(0.85, 0.22, 0.22, 1.0)
        else
            self.cropChangeEl:setTextColor(0.65, 0.65, 0.65, 1.0)
        end
    end

    -- Right column: contract summary
    local lockedPrice = crop.current
    local totalValue  = math.floor(lockedPrice * self.selectedQty)

    if self.sumCrop    then self.sumCrop:setText("Crop:         " .. crop.title) end
    if self.sumQty     then self.sumQty:setText("Quantity:     " .. self:_fmtNum(self.selectedQty) .. " L") end
    if self.sumLocked  then self.sumLocked:setText(string.format("Locked price: $%.2f / L", lockedPrice)) end
    if self.sumTotal   then self.sumTotal:setText("Total:  $" .. self:_fmtNum(totalValue)) end
    if self.sumDeadline then self.sumDeadline:setText("Deliver in:   " .. self.selectedDelivDays .. " days") end
    if self.sumPenalty  then self.sumPenalty:setText("Default penalty: 15% on unfulfilled qty") end

    if self.signalText and crop.base and crop.base > 0 then
        local pct = ((lockedPrice - crop.base) / crop.base) * 100
        if pct > 5 then
            self.signalText:setText(string.format("[+] %.1f%% above base - good time to lock in", pct))
            self.signalText:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif pct < -5 then
            self.signalText:setText(string.format("[-] %.1f%% below base - consider waiting", math.abs(pct)))
            self.signalText:setTextColor(0.85, 0.30, 0.22, 1.0)
        else
            self.signalText:setText(string.format("[~] Near baseline (%.1f%%) - neutral", pct))
            self.signalText:setTextColor(0.90, 0.72, 0.15, 1.0)
        end
    end
end

function MDMContractDialog:_fmtNum(n)
    local s      = tostring(math.floor(n))
    local result = ""
    local count  = 0
    for i = #s, 1, -1 do
        if count > 0 and count % 3 == 0 then result = "," .. result end
        result = s:sub(i, i) .. result
        count  = count + 1
    end
    return result
end
