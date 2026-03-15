-- Name: RS_invoiceManager
-- Author: DonQuacko

RS_invoiceManager = {}

RS_invoiceManager.MAX_OPEN_SERVICE = 10
RS_invoiceManager.MAX_TOTAL_SERVICE = 10
RS_invoiceManager.MAX_PAID_SERVICE = 10
RS_invoiceManager.MAX_BOOKINGS = 20

-- Reason code used when invoice creation is blocked due to too many open invoices
RS_invoiceManager.CREATE_BLOCKED_MAX_OPEN = "MAX_OPEN"

-- Counts open (unpaid) service invoices issued by a given farm.
function RS_invoiceManager:getOpenIssuedServiceCount(issuerFarmId)
    local count = 0
    local issuerId = issuerFarmId or 0

    if self.invoices == nil then
        return 0
    end

    for _, inv in ipairs(self.invoices) do
        if inv.kind == "service" and inv.isPaid ~= true then
            local issuer = inv.issuerFarmId or inv.farmId or 0
            if issuer == issuerId then
                count = count + 1
            end
        end
    end

    return count
end


-- Counts all service invoices (paid or unpaid) issued by a given farm.
function RS_invoiceManager:getIssuedServiceCount(issuerFarmId)
    local count = 0
    local issuerId = issuerFarmId or 0

    if self.invoices == nil then
        return 0
    end

    for _, inv in ipairs(self.invoices) do
        if inv.kind == "service" then
            local issuer = inv.issuerFarmId or inv.farmId or 0
            if issuer == issuerId then
                count = count + 1
            end
        end
    end

    return count
end

local RS_invoiceManager_mt = Class(RS_invoiceManager, AbstractManager)

function RS_invoiceManager.new(customMt)
    local self = RS_invoiceManager:superClass().new(customMt or RS_invoiceManager_mt)

    self.invoices = {} -- array of RS_invoice
    self.revision = 0 -- increments when invoices change (MP sync)

    return self
end

-- Add/remove money with MP support
function RS_invoiceManager:addRemoveMoney(amount, farmId, moneyType)
    if g_currentMission == nil then
        return
    end

    local mType = moneyType or MoneyType.OTHER

    if g_currentMission:getIsServer() then
        -- addMoney expects signed amount
        g_currentMission:addMoney(amount, farmId, mType, true, true)
    else
        g_client:getServerConnection():sendEvent(RS_addRemoveMoneyEvent.new(amount, farmId, mType))
    end
end

function RS_invoiceManager:loadMap()
    -- nothing yet
end


function RS_invoiceManager:markDirty()
    self.revision = (self.revision or 0) + 1
end

function RS_invoiceManager:pruneInvoices()
    -- Keep invoice arrays bounded for DS performance and stable MP sync size.
    -- self.invoices is stored newest-first (table.insert(..., 1, invoice)).
    local openService = {}
    local paidService = {}
    local bookings = {}

    for _, inv in ipairs(self.invoices or {}) do
        if inv.kind == "service" then
            if inv.isPaid == true then
                table.insert(paidService, inv)
            else
                table.insert(openService, inv)
            end
        else
            table.insert(bookings, inv)
        end
    end

    local function limit(list, maxCount)
        while #list > maxCount do
            table.remove(list, #list) -- remove oldest (end), keep newest
        end
    end

    limit(openService, RS_invoiceManager.MAX_OPEN_SERVICE)
    limit(paidService, RS_invoiceManager.MAX_PAID_SERVICE)
    limit(bookings, RS_invoiceManager.MAX_BOOKINGS)

    -- Rebuild list (still newest-first within each category)
    self.invoices = {}
    for _, inv in ipairs(openService) do table.insert(self.invoices, inv) end
    for _, inv in ipairs(paidService) do table.insert(self.invoices, inv) end
    for _, inv in ipairs(bookings) do table.insert(self.invoices, inv) end
end


function RS_invoiceManager:findInvoiceByUid(uid)
    if uid == nil or uid == "" then
        return nil
    end
    for _, inv in pairs(self.invoices or {}) do
        if inv.uid == uid then
            return inv
        end
    end
    return nil
end

-- Server: send full invoice list to one client connection or broadcast to all clients
function RS_invoiceManager:sendInvoicesTo(connection)
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end

    local toSend = {}

    -- DS final optimize: only sync service invoices to clients
    for _, inv in ipairs(self.invoices or {}) do
        if inv.kind == "service" then
            table.insert(toSend, inv)
        end
    end

    local event = RS_syncInvoicesEvent.new(toSend)

    if connection ~= nil then
        connection:sendEvent(event)
    elseif g_server ~= nil then
        g_server:broadcastEvent(event, false)
    end
end

function RS_invoiceManager:broadcastInvoices()
    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        self:markDirty()
        self:sendInvoicesTo(nil)
    end
end

-- Client: request invoice list from server (called when opening the menu)
function RS_invoiceManager:requestInvoicesFromServer()
    if g_currentMission ~= nil and g_currentMission:getIsClient() and not g_currentMission:getIsServer() and g_client ~= nil then
        g_client:getServerConnection():sendEvent(RS_requestInvoicesEvent.new())
    end
end


-- Legacy bookkeeping entry (used by loan system)
function RS_invoiceManager:addInvoice(farmId, amount, moneyType, title, isCredit)
    local invoice = RS_invoice.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
    invoice.kind = "booking"
    invoice.issuerFarmId = farmId
    invoice.recipientFarmId = farmId
    invoice.isPaid = true
    invoice.paidDateString = self:getCurrentDateString()
    invoice:init(farmId, amount, moneyType, title, self:getCurrentDateString(), isCredit)

    invoice:register()
    table.insert(self.invoices, 1, invoice) -- newest first

    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        self:pruneInvoices()
    end
end


-- Service invoice: issuer bills recipient (recipient can pay later)
function RS_invoiceManager:createServiceInvoice(issuerFarmId, recipientFarmId, amount, fieldId, activity, fieldName, titleOverride, quantity, unitType, fillTypeIndex, fillTypeTitle)
    if g_currentMission ~= nil and g_currentMission:getIsClient() and not g_currentMission:getIsServer() then
        -- Client: request server to create, server will sync back
        g_client:getServerConnection():sendEvent(RS_createServiceInvoiceEvent.new(issuerFarmId, recipientFarmId, amount, fieldId, activity, fieldName, titleOverride, quantity, unitType, fillTypeIndex, fillTypeTitle))
        return nil
    end

    -- Server/host: enforce max open invoices for the issuer
    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        local issued = self:getIssuedServiceCount(issuerFarmId or 0)
        local maxAllowed = RS_invoiceManager.MAX_TOTAL_SERVICE or 10
        if g_currentMission.rsInvoiceSettings ~= nil and g_currentMission.rsInvoiceSettings.rsMaxOpenInvoices ~= nil then
            maxAllowed = tonumber(g_currentMission.rsInvoiceSettings.rsMaxOpenInvoices) or maxAllowed
        end

        if issued >= maxAllowed then
            return nil, RS_invoiceManager.CREATE_BLOCKED_MAX_OPEN
        end
    end

    local invoice = RS_invoice.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
    invoice.kind = "service"
    invoice.issuerFarmId = issuerFarmId or 0
    invoice.recipientFarmId = recipientFarmId or 0
    invoice.fieldId = fieldId or 0
    invoice.fieldName = fieldName or ""
    invoice.activity = activity or ""
    invoice.fillTypeIndex = fillTypeIndex or 0
    invoice.fillTypeTitle = fillTypeTitle or ""
    invoice.quantity = tonumber(quantity) or 0
    invoice.unitType = unitType or ""
    invoice.isPaid = false

    local title = titleOverride
    if title == nil or title == "" then
        title = self:buildServiceTitle(invoice)
    end

    -- Netto + MwSt (configurable) -> Brutto
    local netAmount = amount or 0
    local vatRate = 0.19
    if g_rs_invoiceSettings ~= nil and g_rs_invoiceSettings.getVatRate ~= nil then
        vatRate = g_rs_invoiceSettings:getVatRate()
    elseif g_currentMission ~= nil and g_currentMission.rsInvoiceSettings ~= nil then
        local pct = tonumber(g_currentMission.rsInvoiceSettings.rsVatPercent)
        if pct ~= nil then
            vatRate = pct / 100
        end
    end
    local vatAmount = netAmount * vatRate
    local grossAmount = math.floor(netAmount + vatAmount + 0.5)

    invoice.netAmount = netAmount
    invoice.vatAmount = vatAmount
    invoice.grossAmount = grossAmount

    -- Für Verzugszinsen: Spielzeit als absolute Millisekunden speichern
    local env = g_currentMission ~= nil and g_currentMission.environment or nil
    local dayIndex = (env ~= nil and (env.currentDay or env.currentDayInPeriod) or 0)
    local dayTime = (env ~= nil and env.dayTime or 0)
    invoice.creationTotalTimeMs = (dayIndex * 24 * 60 * 60 * 1000) + dayTime

    invoice:init(issuerFarmId, grossAmount, MoneyType.OTHER, title, self:getCurrentDateString(), true)

    invoice:register()
    table.insert(self.invoices, 1, invoice)

    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        -- Notify recipient farm (clients) that a new invoice was created for them
        if g_server ~= nil and RS_invoiceCreatedNotifyEvent ~= nil then
            local issuerName = ""
            if g_farmManager ~= nil then
                local issuerFarm = g_farmManager:getFarmById(issuerFarmId or 0)
                if issuerFarm ~= nil and issuerFarm.name ~= nil then
                    issuerName = issuerFarm.name
                end
            end
            g_server:broadcastEvent(RS_invoiceCreatedNotifyEvent.new(recipientFarmId or 0, issuerName, title or "", grossAmount or 0), false)
        end

        self:pruneInvoices()
        self:broadcastInvoices()
    end

    return invoice
end

function RS_invoiceManager:buildServiceTitle(invoice)
    local parts = {}

    local activity = invoice.activity or ""
    if activity ~= "" then
        table.insert(parts, activity)
    else
        table.insert(parts, g_i18n:getText("rs_ui_activityOther") or "Service")
    end

    if invoice.fieldId ~= nil and invoice.fieldId > 0 then
        local fname = invoice.fieldName or ""
        if fname ~= "" then
            table.insert(parts, fname)
        else
            table.insert(parts, string.format("%s %d", g_i18n:getText("rs_ui_field") or "Field", invoice.fieldId))
        end
    end

    -- If delivering, append product
    if (invoice.unitType == "1000L" or invoice.activity == (g_i18n:getText("rs_ui_activityDelivering") or "")) then
        local p = invoice.fillTypeTitle or ""
        if p ~= "" then
            table.insert(parts, p)
        end
    end

    
    local qty = tonumber(invoice.quantity) or 0
    if qty > 0 then
        local u = invoice.unitType or ""
        if u == "1000L" then
            table.insert(parts, string.format("%.2f", qty))
        elseif u == "ha" then
            table.insert(parts, string.format("%s ha", string.format("%.2f", qty)))
        elseif u == "stems" then
            table.insert(parts, string.format("%s %s", tostring(math.floor(qty + 0.5)), (g_i18n:getText("rs_ui_unitStems") or "Stems")))
        end
    end

local recipient = g_farmManager:getFarmById(invoice.recipientFarmId or 0)
    if recipient ~= nil and recipient.name ~= nil then
        table.insert(parts, string.format("%s: %s", g_i18n:getText("rs_ui_recipient") or "To", recipient.name))
    end

    return table.concat(parts, " - ")
end

function RS_invoiceManager:getInvoicesForFarm(farmId, onlyPaid)
    local result = {}
    for _, inv in pairs(self.invoices) do
        if inv.kind == "service" then
            local issuer = inv.issuerFarmId or inv.farmId or 0
            local recipient = inv.recipientFarmId or 0

            local isRelevant = (issuer == farmId) or (recipient == farmId) or (inv.farmId == farmId)
            if isRelevant then
                if onlyPaid == true then
                    if inv.isPaid == true then
                        table.insert(result, inv)
                    end
                else
                    if inv.isPaid ~= true then
                        table.insert(result, inv)
                    end
                end
            end
        end
    end
    return result
end

function RS_invoiceManager:canFarmPayInvoice(farmId, invoice)
    if invoice == nil then
        return false
    end
    if invoice.kind ~= "service" then
        return false
    end
    if invoice.isPaid == true then
        return false
    end
    return (invoice.recipientFarmId or 0) == (farmId or 0)
end


function RS_invoiceManager:payInvoice(invoice, payerFarmId)
    if invoice == nil then
        return false
    end

    if g_currentMission ~= nil and g_currentMission:getIsClient() and not g_currentMission:getIsServer() then
        -- Client: request server to pay by uid
        g_client:getServerConnection():sendEvent(RS_payInvoiceEvent.new(invoice.uid or "", g_currentMission:getFarmId() or 0))
        return true
    end

    -- Server: validate and execute
    local resolvedPayerFarmId = payerFarmId or 0
    if resolvedPayerFarmId == 0 then
        if g_currentMission ~= nil and g_currentMission.getFarmId ~= nil then
            resolvedPayerFarmId = g_currentMission:getFarmId() or 0
        end
    end
    if resolvedPayerFarmId == 0 and g_currentMission ~= nil then
        local userId = g_currentMission.playerUserId
        if userId ~= nil and g_farmManager ~= nil and g_farmManager.getFarmByUserId ~= nil then
            local farm = g_farmManager:getFarmByUserId(userId)
            resolvedPayerFarmId = farm ~= nil and farm.farmId or 0
        end
    end
    if not self:canFarmPayInvoice(resolvedPayerFarmId, invoice) then
        return false
    end

    local issuerFarmId = invoice.issuerFarmId or 0

    -- Brutto-Grundbetrag (ohne Zinsen)
    local grossBase = invoice.grossAmount or invoice.amount or 0
    grossBase = math.abs(grossBase)

    -- Verzugszinsen: pro Intervall wird ein prozentualer Zins auf den Brutto-Grundbetrag aufgeschlagen
    local interest = 0
    if invoice.creationTotalTimeMs ~= nil and invoice.isPaid ~= true then
        local env = g_currentMission ~= nil and g_currentMission.environment or nil
        local dayIndex = (env ~= nil and (env.currentDay or env.currentDayInPeriod) or 0)
        local dayTime = (env ~= nil and env.dayTime or 0)
        local nowTotal = (dayIndex * 24 * 60 * 60 * 1000) + dayTime
        local hoursPassed = (nowTotal - (invoice.creationTotalTimeMs or nowTotal)) / (60 * 60 * 1000)
        local daysPassed = hoursPassed / 24

        local rate = 0
        local intervalDays = 3
        if g_rs_invoiceSettings ~= nil and g_rs_invoiceSettings.getInterestRate ~= nil then
            rate = g_rs_invoiceSettings:getInterestRate() or 0
        end
        if g_rs_invoiceSettings ~= nil and g_rs_invoiceSettings.getInterestIntervalDays ~= nil then
            intervalDays = g_rs_invoiceSettings:getInterestIntervalDays() or 3
        end

        if rate > 0 and intervalDays > 0 then
            local steps = math.max(0, math.floor(daysPassed / intervalDays))
            interest = math.floor((grossBase * rate * steps) + 0.5)
        end
    end

    local amount = grossBase + interest
    if amount <= 0 then
        return false
    end

    -- transfer money
    local mExpense = MoneyType.RS_INVOICE_EXPENSE or MoneyType.OTHER
    local mIncome  = MoneyType.RS_INVOICE_INCOME  or MoneyType.OTHER

    self:addRemoveMoney(-amount, resolvedPayerFarmId, mExpense)
    self:addRemoveMoney(amount, issuerFarmId, mIncome)

    -- Für Historie/Anzeige merken wir die tatsächlich gezahlten Werte
    invoice.interestAmount = interest
    invoice.amount = amount
    invoice.isPaid = true
    invoice.paidDateString = self:getCurrentDateString()

    -- also create a bookkeeping entry for both farms
    self:addInvoice(resolvedPayerFarmId, -amount, mExpense, string.format("%s (%s)", invoice.title or "", g_i18n:getText("rs_ui_paid") or "paid"), false)
    self:addInvoice(issuerFarmId, amount, mIncome, string.format("%s (%s)", invoice.title or "", g_i18n:getText("rs_ui_paid") or "paid"), true)

    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        self:pruneInvoices()
        self:broadcastInvoices()
    end

    return true
end



function RS_invoiceManager:deleteInvoice(invoice)
    if invoice == nil or invoice.isPaid then
        return false
    end

    if g_currentMission ~= nil and g_currentMission:getIsClient() and not g_currentMission:getIsServer() then
        -- Client: request server to delete by uid
        g_client:getServerConnection():sendEvent(RS_deleteInvoiceEvent.new(invoice.uid or ""))
        return true
    end

    -- Server: remove
    for i = #self.invoices, 1, -1 do
        if self.invoices[i] == invoice then
            table.remove(self.invoices, i)
            break
        end
    end

    if invoice.delete ~= nil then
        invoice:delete()
    end

    if g_currentMission ~= nil and g_currentMission:getIsServer() then
        self:pruneInvoices()
    end
    self:saveToXMLFile(g_currentMission ~= nil and g_currentMission.missionInfo or nil)
    self:broadcastInvoices()

    return true
end


function RS_invoiceManager:getCurrentDateString()
    -- Prefer real-world current date (system date) if available
    if getDate ~= nil then
        return getDate("%d.%m.%Y")
    end

    -- Fallback to in-game environment date
    local env = g_currentMission.environment
    local day = env.currentDay or env.currentDayInPeriod or 1
    local month = env.currentMonth or 1
    local year = env.currentYear or 1
    return string.format("%02d.%02d.%04d", day, month, year)
end

function RS_invoiceManager:saveToXMLFile(missionInfo)
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end
    -- In multiplayer, clients do not have a writable savegame directory.
    -- Prevent "Could not save xml file" errors by saving only on the server.
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end

    local savegameDirectory = g_currentMission.missionInfo.savegameDirectory

    if savegameDirectory ~= nil then
        local saveGamePath = savegameDirectory .. "/rs_invoices.xml"
        local key = "invoices"
        local xmlFile = XMLFile.create("rs_invoices", saveGamePath, key)

        if xmlFile ~= nil then
            local invIndex = 0

            for _, invoice in pairs(self.invoices) do
                local invKey = string.format(key .. ".invoice(%d)", invIndex)
                invoice:saveToXMLFile(xmlFile, invKey)
                invIndex = invIndex + 1
            end

            xmlFile:save()
            xmlFile:delete()
        end
    end
end

function RS_invoiceManager:loadFromXMLFile()
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end
    -- Only the server should load persistent invoice data (and then sync via events if needed).
    if g_currentMission == nil or not g_currentMission:getIsServer() then
        return
    end

    local savegameDirectory = g_currentMission.missionInfo.savegameDirectory

    if savegameDirectory ~= nil then
        local filename = savegameDirectory .. "/rs_invoices.xml"
        local key = "invoices"
        local xmlFile = XMLFile.loadIfExists("rs_invoices", filename, key)

        if xmlFile ~= nil then
            self.invoices = {}

            -- New format: invoices.invoice(i)
            local invIndex = 0
            while true do
                local invKey = string.format(key .. ".invoice(%d)", invIndex)
                if not xmlFile:hasProperty(invKey) then
                    break
                end

                local invoice = RS_invoice.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
                invoice:loadFromXMLFile(xmlFile, invKey)
                invoice:register()
                table.insert(self.invoices, invoice)

                invIndex = invIndex + 1
            end

            -- Backwards compatibility: old format invoices.farmId(x).invoice(y)
            if #self.invoices == 0 then
                local farmIndex = 0
                while true do
                    local farmKey = string.format(key .. ".farmId(%d)", farmIndex)
                    if not xmlFile:hasProperty(farmKey) then
                        break
                    end

                    local farmId = xmlFile:getInt(farmKey .. "#farmId") or 0
                    local oldInvIndex = 0

                    while true do
                        local oldInvKey = string.format(farmKey .. ".invoice(%d)", oldInvIndex)
                        if not xmlFile:hasProperty(oldInvKey) then
                            break
                        end

                        local invoice = RS_invoice.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
                        invoice:loadFromXMLFile(xmlFile, oldInvKey)
                        invoice.kind = "booking"
                        invoice.issuerFarmId = farmId
                        invoice.recipientFarmId = farmId
                        invoice.isPaid = true
                        invoice.paidDateString = invoice.dateString or self:getCurrentDateString()
                        invoice:register()

                        table.insert(self.invoices, invoice)
                        oldInvIndex = oldInvIndex + 1
                    end

                    farmIndex = farmIndex + 1
                end
            end

            xmlFile:delete()
            self:broadcastInvoices()

        end
    end
end

g_rs_invoiceManager = RS_invoiceManager.new()