-- MDMContractAdminDialog.lua
-- Contract admin panel — view details and force-complete or cancel an active contract.
-- Opened by clicking any row in the Contracts tab of the Market screen.
--
-- params = {
--   contract   = contract table (from FuturesMarket.contracts),
--   onComplete = function(contractId)  called after admin force-complete,
--   onCancel   = function(contractId)  called after admin cancel/remove,
-- }

MDMContractAdminDialog = {}
local MDMContractAdminDialog_mt = Class(MDMContractAdminDialog, MessageDialog)

-- -----------------------------------------------------------------------
-- Constructor
-- -----------------------------------------------------------------------

function MDMContractAdminDialog.new(target, custom_mt)
    local self = MessageDialog.new(target, custom_mt or MDMContractAdminDialog_mt)

    self.contract     = nil
    self._onComplete  = nil
    self._onCancel    = nil

    self.isOpen       = false

    -- Detail elements
    self.admCropValue      = nil
    self.admQtyValue       = nil
    self.admPriceValue     = nil
    self.admDelivValue     = nil
    self.admDeadlineValue  = nil
    self.admStatusValue    = nil
    self.admSumTotal       = nil
    self.admSumProgress    = nil
    self.admActionHint     = nil
    self.admSettledNotice  = nil

    -- Action buttons (native buttonBox elements)
    self.admCompleteBtn  = nil
    self.admCancelBtn    = nil
    self.admCloseBtn     = nil

    return self
end

-- -----------------------------------------------------------------------
-- Data setter — called by MDMDialogLoader before showDialog()
-- -----------------------------------------------------------------------

function MDMContractAdminDialog:setData(params)
    self.contract    = params.contract
    self._onComplete = params.onComplete
    self._onCancel   = params.onCancel
end

-- -----------------------------------------------------------------------
-- GUI lifecycle
-- -----------------------------------------------------------------------

function MDMContractAdminDialog:onCreate()
    local ok, err = pcall(function() MDMContractAdminDialog:superClass().onCreate(self) end)
    if not ok then MDMLog.warn("MDMContractAdminDialog:onCreate error: " .. tostring(err)) end
end

function MDMContractAdminDialog:onGuiSetupFinished()
    MDMContractAdminDialog:superClass().onGuiSetupFinished(self)

    self.admCropValue     = self:getDescendantById("admCropValue")
    self.admQtyValue      = self:getDescendantById("admQtyValue")
    self.admPriceValue    = self:getDescendantById("admPriceValue")
    self.admDelivValue    = self:getDescendantById("admDelivValue")
    self.admDeadlineValue = self:getDescendantById("admDeadlineValue")
    self.admStatusValue   = self:getDescendantById("admStatusValue")
    self.admSumTotal      = self:getDescendantById("admSumTotal")
    self.admSumProgress   = self:getDescendantById("admSumProgress")
    self.admActionHint    = self:getDescendantById("admActionHint")
    self.admSettledNotice = self:getDescendantById("admSettledNotice")

    self.admCompleteBtn   = self:getDescendantById("admCompleteBtn")
    self.admCancelBtn     = self:getDescendantById("admCancelBtn")
    self.admCloseBtn      = self:getDescendantById("admCloseBtn")

    MDMLog.info("MDMContractAdminDialog:onGuiSetupFinished OK")
end

function MDMContractAdminDialog:onOpen()
    MDMContractAdminDialog:superClass().onOpen(self)
    self.isOpen = true
    self:_populate()
    if self.admCloseBtn then
        FocusManager:setFocus(self.admCloseBtn)
    end
end

function MDMContractAdminDialog:onClose()
    self.isOpen = false
    MDMContractAdminDialog:superClass().onClose(self)
end

-- -----------------------------------------------------------------------
-- Button callbacks
-- -----------------------------------------------------------------------

function MDMContractAdminDialog:onCompleteClick()
    local c = self.contract
    if not c or c.status ~= "active" then self:close(); return end
    if g_MarketDynamics and g_MarketDynamics.futuresMarket then
        g_MarketDynamics.futuresMarket:adminComplete(c.id)
    end
    if self._onComplete then self._onComplete(c.id) end
    self:close()
end

function MDMContractAdminDialog:onCancelContractClick()
    local c = self.contract
    if not c or c.status ~= "active" then self:close(); return end
    if g_MarketDynamics and g_MarketDynamics.futuresMarket then
        g_MarketDynamics.futuresMarket:adminCancel(c.id)
    end
    if self._onCancel then self._onCancel(c.id) end
    self:close()
end

function MDMContractAdminDialog:onCloseClick()
    self:close()
end

-- -----------------------------------------------------------------------
-- Internal: populate elements from contract data
-- -----------------------------------------------------------------------

function MDMContractAdminDialog:_populate()
    local c = self.contract
    if not c then
        if self.admCropValue then self.admCropValue:setText("—") end
        return
    end

    local isActive = (c.status == "active")

    -- Left column details
    if self.admCropValue     then self.admCropValue:setText(c.fillTypeName or "?") end
    if self.admQtyValue      then self.admQtyValue:setText(self:_fmt(c.quantity) .. " L") end
    if self.admPriceValue    then self.admPriceValue:setText(string.format("$%.2f / L", c.lockedPrice or 0)) end

    local delivPct = 0
    if c.quantity and c.quantity > 0 then
        delivPct = math.min(100, math.floor(((c.delivered or 0) / c.quantity) * 100))
    end
    if self.admDelivValue then
        self.admDelivValue:setText(string.format("%s / %s L  (%d%%)",
            self:_fmt(c.delivered or 0), self:_fmt(c.quantity), delivPct))
    end

    -- Deadline (convert ms to in-game days remaining)
    if self.admDeadlineValue then
        local now = g_currentMission and g_currentMission.time or 0
        local remaining = math.max(0, (c.deliveryTime or 0) - now)
        local daysLeft  = math.floor(remaining / (24 * 60 * 60000))
        if isActive then
            self.admDeadlineValue:setText(string.format("%d day(s) remaining", daysLeft))
            if daysLeft <= 5 then
                self.admDeadlineValue:setTextColor(0.85, 0.22, 0.22, 1.0)
            elseif daysLeft <= 14 then
                self.admDeadlineValue:setTextColor(0.95, 0.75, 0.10, 1.0)
            else
                self.admDeadlineValue:setTextColor(0.80, 0.80, 0.80, 1.0)
            end
        else
            self.admDeadlineValue:setText("Settled")
            self.admDeadlineValue:setTextColor(0.65, 0.65, 0.65, 1.0)
        end
    end

    -- Status with colour
    if self.admStatusValue then
        local statusStr = c.status or "unknown"
        self.admStatusValue:setText(statusStr:upper())
        if statusStr == "active" then
            self.admStatusValue:setTextColor(0.20, 0.72, 0.35, 1.0)
        elseif statusStr == "fulfilled" then
            self.admStatusValue:setTextColor(0.40, 0.60, 1.00, 1.0)
        else
            self.admStatusValue:setTextColor(0.85, 0.30, 0.22, 1.0)
        end
    end

    -- Right column summary
    local totalValue = math.floor((c.lockedPrice or 0) * (c.quantity or 0))
    if self.admSumTotal then
        self.admSumTotal:setText("Total value:  $" .. self:_fmt(totalValue))
    end
    if self.admSumProgress then
        local delivValue = math.floor((c.lockedPrice or 0) * (c.delivered or 0))
        self.admSumProgress:setText(string.format("Delivered value:  $%s  (%d%%)",
            self:_fmt(delivValue), delivPct))
    end

    -- Show/hide action buttons based on status (native buttonBox buttons)
    local showActions = isActive
    if self.admCompleteBtn then
        self.admCompleteBtn:setVisible(showActions)
        self.admCompleteBtn:setDisabled(not showActions)
    end
    if self.admCancelBtn then
        self.admCancelBtn:setVisible(showActions)
        self.admCancelBtn:setDisabled(not showActions)
    end

    -- Hint / settled notice
    if self.admActionHint then
        self.admActionHint:setVisible(showActions)
        if showActions then
            self.admActionHint:setText(
                "Complete: force full payout now at locked price.\n\n" ..
                "Cancel: remove contract — no payout, no penalty.")
        end
    end
    if self.admSettledNotice then
        self.admSettledNotice:setVisible(not showActions)
    end
end

-- -----------------------------------------------------------------------
-- Utility
-- -----------------------------------------------------------------------

function MDMContractAdminDialog:_fmt(n)
    local s      = tostring(math.floor(n or 0))
    local result = ""
    local count  = 0
    for i = #s, 1, -1 do
        if count > 0 and count % 3 == 0 then result = "," .. result end
        result = s:sub(i, i) .. result
        count  = count + 1
    end
    return result
end
