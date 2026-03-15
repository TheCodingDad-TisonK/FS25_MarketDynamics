-- Name: RS_inGameMenuInvoices
-- Author: DonQuacko

local modDirectory = RS_MOD_DIR or g_currentModDirectory or ""

RS_inGameMenuInvoices = {}
local RS_inGameMenuInvoices_mt = Class(RS_inGameMenuInvoices, TabbedMenuFrameElement)

local function getCurrentFarmId()
    if g_currentMission ~= nil and g_currentMission.getFarmId ~= nil then
        local fid = g_currentMission:getFarmId()
        if fid ~= nil then
            return fid
        end
    end

    if g_farmManager ~= nil and g_currentMission ~= nil then
        local userId = g_currentMission.playerUserId
        if userId ~= nil then
            local farm = g_farmManager:getFarmByUserId(userId)
            if farm ~= nil then
                return farm.farmId
            end
        end
    end

    return 0
end



local function rsParseDate(dateString)
    -- expects dd.mm.yyyy, returns yyyymmdd as number for sorting
    if dateString == nil then
        return 0
    end
    local d, m, y = string.match(dateString, "(%d%d)%.(%d%d)%.(%d%d%d%d)")
    if d == nil then
        return 0
    end
    return (tonumber(y) or 0) * 10000 + (tonumber(m) or 0) * 100 + (tonumber(d) or 0)
end

local function rsGetCounterpartyName(inv, myFarmId)
    local issuer = g_farmManager ~= nil and g_farmManager:getFarmById(inv.issuerFarmId or 0) or nil
    local recipient = g_farmManager ~= nil and g_farmManager:getFarmById(inv.recipientFarmId or 0) or nil

    if myFarmId ~= 0 and (inv.issuerFarmId or 0) == myFarmId then
        return (recipient ~= nil and recipient.name) or ""
    end
    if myFarmId ~= 0 and (inv.recipientFarmId or 0) == myFarmId then
        return (issuer ~= nil and issuer.name) or ""
    end
    return (recipient ~= nil and recipient.name) or ((issuer ~= nil and issuer.name) or "")
end

local function rsComputeCurrentInterest(inv)
    if inv == nil or inv.creationTotalTimeMs == nil then
        return 0
    end

    if inv.isPaid == true then
        return tonumber(inv.interestAmount) or 0
    end

    if g_rs_invoiceSettings == nil then
        return 0
    end

    local rate = g_rs_invoiceSettings:getInterestRate() or 0
    local intervalDays = g_rs_invoiceSettings:getInterestIntervalDays() or 1

    if rate <= 0 or intervalDays <= 0 then
        return 0
    end

    local env = g_currentMission ~= nil and g_currentMission.environment or nil
    local dayIndex = (env ~= nil and (env.currentDay or env.currentDayInPeriod) or 0)
    local dayTime = (env ~= nil and env.dayTime or 0)
    local nowTotal = (dayIndex * 24 * 60 * 60 * 1000) + dayTime

    local hoursPassed = (nowTotal - (inv.creationTotalTimeMs or nowTotal)) / (60 * 60 * 1000)
    local daysPassed = hoursPassed / 24

    local grossBase = math.abs(inv.grossAmount or inv.amount or 0)
    local steps = math.max(0, math.floor(daysPassed / intervalDays))

    return math.floor((grossBase * rate * steps) + 0.5)
end

function RS_inGameMenuInvoices.new(i18n, messageCenter)
    local self = RS_inGameMenuInvoices:superClass().new(nil, RS_inGameMenuInvoices_mt)

    self.hasCustomMenuButtons = true
    self.messageCenter = messageCenter
    self.i18n = i18n

    self.showPaid = false
    self.invoices = {}
    self.selectedIndex = 0

    return self
end

function RS_inGameMenuInvoices:initialize()
    -- Safety: ensure manager exists (SP host / MP client edge cases)
    if g_rs_invoiceManager == nil and RS_invoiceManager ~= nil then
        g_rs_invoiceManager = RS_invoiceManager.new()
    end

    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
    }

    self.createButton = {
        inputAction = InputAction.MENU_ACTIVATE,
        text = self.i18n:getText("rs_ui_createInvoice"),
        callback = function ()
            self:onCreateInvoice()
        end
    }

    self.payButtonInfo = {
        inputAction = InputAction.MENU_EXTRA_1,
        text = self.i18n:getText("rs_ui_payInvoice"),
        callback = function ()
            self:onPayInvoice()
        end
    }
    self.togglePaidButton = {
        inputAction = InputAction.MENU_EXTRA_2,
        text = self.i18n:getText("rs_ui_paidInvoicesTab"),
        callback = function ()
            self:onTogglePaid()
        end
    }

    self.menuButtons = {
        self.backButtonInfo,
        self.createButton,
        self.payButtonInfo,
        self.togglePaidButton
    }

    self:setMenuButtonInfo(self.menuButtons)
end

function RS_inGameMenuInvoices:onGuiSetupFinished()
    RS_inGameMenuInvoices:superClass().onGuiSetupFinished(self)

    if self.invoiceTable ~= nil then
        self.invoiceTable:setDataSource(self)
        self.invoiceTable:setDelegate(self)
    end

    self.createInvoiceDialog = RS_createInvoiceDialog.new(self, nil, self.i18n)
    g_gui:loadGui(modDirectory .. "gui/RS_createInvoiceDialog.xml", "RS_createInvoiceDialog", self.createInvoiceDialog)
    self.createInvoiceDialog.target = self
end


function RS_inGameMenuInvoices:onFrameOpen(element)
    RS_inGameMenuInvoices:superClass().onFrameOpen(self)
    self.selectedIndex = 0
    self:reloadInvoices()
    self:updateModeText()
    self:updateButtons()

    -- MP: request latest invoices from server when opening the page
    if g_rs_invoiceManager ~= nil then
        g_rs_invoiceManager:requestInvoicesFromServer()
        self._lastInvoiceRevision = g_rs_invoiceManager.revision or 0
    end

    if self.invoiceTable ~= nil then
        FocusManager:setFocus(self.invoiceTable)
    end
end


function RS_inGameMenuInvoices:update(dt)
    RS_inGameMenuInvoices:superClass().update(self, dt)

    -- MP: refresh list when server sync arrives
    if g_rs_invoiceManager ~= nil then
        local rev = g_rs_invoiceManager.revision or 0
        if self._lastInvoiceRevision ~= rev then
            self._lastInvoiceRevision = rev
            self.selectedIndex = 0
            self:reloadInvoices()
            self:updateButtons()
        end
    end


end

function RS_inGameMenuInvoices:updateModeText()
    if self.modeText ~= nil then
        if self.showPaid then
            self.modeText:setText(string.format("%s", self.i18n:getText("rs_ui_paidInvoicesHeader")))
        else
            self.modeText:setText(string.format("%s", self.i18n:getText("rs_ui_openInvoicesHeader")))
        end
    end

    if self.togglePaidButton ~= nil then
        if self.showPaid then
            self.togglePaidButton.text = self.i18n:getText("rs_ui_openInvoicesTab")
        else
            self.togglePaidButton.text = self.i18n:getText("rs_ui_paidInvoicesTab")
        end
    end
end

function RS_inGameMenuInvoices:reloadInvoices()
    local farmId = getCurrentFarmId()
    if farmId == 0 then
        self.invoices = {}
    else
        self.invoices = g_rs_invoiceManager:getInvoicesForFarm(farmId, self.showPaid)

        -- Sort invoices (hard-set to date: newest first)
        table.sort(self.invoices, function(a, b)
            local da
            local db
            if self.showPaid then
                da = rsParseDate(a.paidDateString or a.dateString)
                db = rsParseDate(b.paidDateString or b.dateString)
            else
                da = rsParseDate(a.dateString)
                db = rsParseDate(b.dateString)
            end
            return da > db
        end)
    end

    if self.invoiceTable ~= nil then
        self.invoiceTable:reloadData()
    end
end

function RS_inGameMenuInvoices:updateButtons()
    -- pay is only possible on open invoices where player is recipient
    local canPay = false
    if not self.showPaid and self.selectedIndex ~= nil and self.selectedIndex > 0 then
        local inv = self.invoices[self.selectedIndex]
        if inv ~= nil then
            local myFarmId = getCurrentFarmId()
            canPay = (inv.recipientFarmId == myFarmId) and (not inv.isPaid)
        end
    end

    if self.payButtonInfo ~= nil then
        self.payButtonInfo.disabled = not canPay
    end

    self:setMenuButtonInfoDirty()
end

function RS_inGameMenuInvoices:onCreateInvoice()
    g_gui:showDialog("RS_createInvoiceDialog")
end

function RS_inGameMenuInvoices:onPayInvoice()
    if self.showPaid then
        return
    end

    local inv = self.invoices[self.selectedIndex]
    if inv == nil then
        return
    end

    g_rs_invoiceManager:payInvoice(inv)
    self.selectedIndex = 0
    self:reloadInvoices()
    self:updateButtons()
end


function RS_inGameMenuInvoices:onDeleteInvoice()
    if self.showPaid then
        return
    end

    local inv = self.invoices[self.selectedIndex]
    if inv == nil then
        return
    end

    local myFarmId = getCurrentFarmId()
    -- Only the issuer (creator) may delete an open invoice
    if myFarmId ~= 0 and (inv.issuerFarmId or 0) ~= myFarmId then
        return
    end

    g_rs_invoiceManager:deleteInvoice(inv)
    self.selectedIndex = 0
    self:reloadInvoices()
    self:updateButtons()
end


function RS_inGameMenuInvoices:onTogglePaid()
    self.showPaid = not self.showPaid
    self.selectedIndex = 0
    self:reloadInvoices()
    self:updateModeText()
    self:updateButtons()
end

function RS_inGameMenuInvoices:onInvoiceCreated()
    self:reloadInvoices()
end

-- SmoothList DataSource
function RS_inGameMenuInvoices:getNumberOfSections()
    return 1
end

function RS_inGameMenuInvoices:getNumberOfItemsInSection(list, section)
    return #self.invoices
end

function RS_inGameMenuInvoices:getTitleForSectionHeader(list, section)
    if self.showPaid then
        return self.i18n:getText("rs_ui_paidInvoicesHeader")
    end
    return self.i18n:getText("rs_ui_openInvoicesHeader")
end

function RS_inGameMenuInvoices:populateCellForItemInSection(list, section, index, cell)
    local inv = self.invoices[index]
    if inv == nil then
        return
    end

    local myFarmId = getCurrentFarmId()

    local dateText = (inv.dateString ~= nil and inv.dateString ~= "" and inv.dateString) or (getDate ~= nil and getDate("%d.%m.%Y") or "")
    if self.showPaid then
        dateText = (inv.paidDateString ~= nil and inv.paidDateString ~= "" and inv.paidDateString) or (inv.dateString ~= nil and inv.dateString ~= "" and inv.dateString) or (getDate ~= nil and getDate("%d.%m.%Y") or "")
    end

    -- Who is involved (similar to the style of the original mod: short, readable)
    local issuer = g_farmManager ~= nil and g_farmManager:getFarmById(inv.issuerFarmId or 0) or nil
    local recipient = g_farmManager ~= nil and g_farmManager:getFarmById(inv.recipientFarmId or 0) or nil

    local partyText = ""
    if inv.kind == "service" then
        if myFarmId ~= 0 and (inv.issuerFarmId or 0) == myFarmId then
            partyText = string.format("%s: %s", self.i18n:getText("rs_ui_recipient") or "To", (recipient ~= nil and recipient.name) or "-")
        elseif myFarmId ~= 0 and (inv.recipientFarmId or 0) == myFarmId then
            partyText = string.format("%s: %s", self.i18n:getText("rs_ui_issuer") or "From", (issuer ~= nil and issuer.name) or "-")
        else
            partyText = string.format("%s → %s", (issuer ~= nil and issuer.name) or "-", (recipient ~= nil and recipient.name) or "-")
        end
    else
        -- fallback
        partyText = inv.title or ""
    end

    -- What for (activity + optional field)
    local whatParts = {}
    local activity = inv.activity or ""
    if activity == "" then
        activity = self.i18n:getText("rs_ui_activityOther") or "Service"
    end
    table.insert(whatParts, activity)
    if inv.fieldId ~= nil and inv.fieldId > 0 then
        local fname = inv.fieldName or ""
        if fname ~= "" then
            table.insert(whatParts, fname)
        else
            table.insert(whatParts, string.format("%s %d", self.i18n:getText("rs_ui_field") or "Field", inv.fieldId))
        end
    end

    -- Product for delivering invoices
    if (inv.unitType == "1000L") then
        local p = inv.fillTypeTitle or ""
        if p ~= "" then
            table.insert(whatParts, p)
        end
    end

    -- Quantity info (ha or 1000L)
    local qty = tonumber(inv.quantity) or 0
    if qty > 0 then
        local u = inv.unitType or ""
        if u == "1000L" then
            table.insert(whatParts, string.format("%.2f", qty))
        elseif u == "ha" then
            table.insert(whatParts, string.format("%s ha", string.format("%.2f", qty)))
        end
    end

    local whatText = table.concat(whatParts, " - ")

    -- Beträge: Netto / MwSt / Zinsen / Brutto in separaten Spalten
    local interest = rsComputeCurrentInterest(inv)

    local gross = inv.grossAmount
    if gross == nil then
        local a = math.abs(tonumber(inv.amount) or 0)
        gross = math.max(0, a - (interest or 0))
    end

    local net = inv.netAmount
    if net == nil and gross ~= nil then
        net = gross / 1.19
    end
    net = tonumber(net) or 0

    local vatAmount = inv.vatAmount
    if vatAmount == nil then
        local vatRate = 0.19
        if g_rs_invoiceSettings ~= nil and g_rs_invoiceSettings.getVatRate ~= nil then
            vatRate = g_rs_invoiceSettings:getVatRate()
        elseif g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil then
            local pct = tonumber(g_currentMission.rsInvoiceSettings.rsVatPercent)
            if pct ~= nil then
                vatRate = pct / 100
            end
        end
        vatAmount = net * vatRate
    end
    vatAmount = tonumber(vatAmount) or 0

    local netText = g_i18n:formatMoney(net, 0, true, true)
    local vatText = g_i18n:formatMoney(vatAmount, 0, true, true)
    local interestText = g_i18n:formatMoney(interest or 0, 0, true, true)
    local grossText = g_i18n:formatMoney(gross or 0, 0, true, true)

    local colDate = cell:getAttribute("colDate")
    local colText = cell:getAttribute("colText")
    local colWhat = cell:getAttribute("colWhat")
    local colNet = cell:getAttribute("colNet")
    local colVat = cell:getAttribute("colVat")
    local colInterest = cell:getAttribute("colInterest")
    local colGross = cell:getAttribute("colGross")

    if colDate ~= nil then colDate:setText(dateText) end
    if colText ~= nil then colText:setText(partyText) end
    if colWhat ~= nil then colWhat:setText(whatText) end
    if colNet ~= nil then colNet:setText(netText) end
    if colVat ~= nil then colVat:setText(vatText) end
    if colInterest ~= nil then colInterest:setText(interestText) end
    if colGross ~= nil then colGross:setText(grossText) end
end

function RS_inGameMenuInvoices:onListSelectionChanged(list, section, index)
    self.selectedIndex = index or 0
    self:updateButtons()
end
