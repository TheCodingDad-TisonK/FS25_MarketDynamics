-- Name: RS_main
-- Author: DonQuacko


local modDirectory = g_currentModDirectory
RS_MOD_DIR = modDirectory  -- global for deferred GUI sourcing

source(modDirectory .. "src/RS_invoice.lua")
source(modDirectory .. "src/RS_invoiceManager.lua")
source(modDirectory .. "src/events/RS_settingsEvent.lua")
source(modDirectory .. "src/RS_settings.lua")
source(modDirectory .. "src/events/RS_addRemoveMoneyEvent.lua")
source(modDirectory .. "src/events/RS_syncInvoicesEvent.lua")
source(modDirectory .. "src/events/RS_requestInvoicesEvent.lua")
source(modDirectory .. "src/events/RS_createServiceInvoiceEvent.lua")
source(modDirectory .. "src/events/RS_invoiceCreatedNotifyEvent.lua")
source(modDirectory .. "src/events/RS_payInvoiceEvent.lua")
source(modDirectory .. "src/events/RS_deleteInvoiceEvent.lua")




-- === RedTape compatibility: register separate MoneyTypes for invoice income/expense ===
-- IMPORTANT: Do this in loadMap, because l10n texts might not be loaded yet when this file is sourced.
RS_RedTapeMoneyTypes = {}

local function rsEnsureFinanceStat(name)
    if FinanceStats == nil or FinanceStats.statNames == nil then
        return
    end
    for _, v in ipairs(FinanceStats.statNames) do
        if v == name then
            return
        end
    end
    table.insert(FinanceStats.statNames, name)
    if FinanceStats.statNameToIndex ~= nil then
        FinanceStats.statNameToIndex[name] = #FinanceStats.statNames
    end
end

function RS_RedTapeMoneyTypes:rsTryRegisterFinanceStats()
    if self._didRegisterFinanceStats then
        return
    end

    -- Register finance statistics for RedTape grouping (only works once FinanceStats exists)
    rsEnsureFinanceStat("rsInvoiceIncome")
    rsEnsureFinanceStat("rsInvoiceExpense")

    -- Mark done if FinanceStats is available and both stats are present
    if FinanceStats ~= nil and FinanceStats.statNames ~= nil then
        local hasIncome, hasExpense = false, false
        for _, v in ipairs(FinanceStats.statNames) do
            if v == "rsInvoiceIncome" then
                hasIncome = true
            elseif v == "rsInvoiceExpense" then
                hasExpense = true
            end
        end
        self._didRegisterFinanceStats = hasIncome and hasExpense
    end
end

function RS_RedTapeMoneyTypes:loadMap()
    -- Register MoneyTypes exactly once, but FinanceStats may not be ready yet.
    if self._didRegisterMoneyTypes then
        return
    end
    self._didRegisterMoneyTypes = true

    if MoneyType == nil then
        return
    end

    -- Register MoneyTypes for invoice income/expense (RedTape compatible)
    if MoneyType.RS_INVOICE_INCOME == nil then
        MoneyType.RS_INVOICE_INCOME = MoneyType.register("rsInvoiceIncome", "rs_ui_moneyType_invoice_income")
        if MoneyType.LAST_ID ~= nil then
            MoneyType.LAST_ID = MoneyType.LAST_ID + 1
        end
    end

    if MoneyType.RS_INVOICE_EXPENSE == nil then
        MoneyType.RS_INVOICE_EXPENSE = MoneyType.register("rsInvoiceExpense", "rs_ui_moneyType_invoice_expense")
        if MoneyType.LAST_ID ~= nil then
            MoneyType.LAST_ID = MoneyType.LAST_ID + 1
        end
    end

    -- Try to register finance statistics right away (we'll also retry in update())
    self:rsTryRegisterFinanceStats()
end

function RS_RedTapeMoneyTypes:update(dt)
    -- FinanceStats can be initialized after loadMap; keep retrying until available.
    self:rsTryRegisterFinanceStats()
end

addModEventListener(RS_RedTapeMoneyTypes)
-- Ensure the manager exists even if a file-level initializer was skipped for any reason.
-- This prevents nil access in GUI callbacks, especially in SP host (isClient+isServer).
if g_rs_invoiceManager == nil then
    g_rs_invoiceManager = RS_invoiceManager.new()
end

addModEventListener(g_rs_invoiceManager)

-- Client-side helper: flush queued invoice notifications once the player farmId is known.
RS_invoiceNotifyHelper = {
    timer = 0
}

function RS_invoiceNotifyHelper:update(dt)
    if g_rsInvoiceNotifyQueue == nil or #g_rsInvoiceNotifyQueue == 0 then
        return
    end

    -- Throttle checks to avoid any micro-stutter.
    self.timer = self.timer + (dt or 0)
    if self.timer < 1000 then
        return
    end
    self.timer = 0

    if g_currentMission == nil then
        return
    end

    local myFarmId = 0
    if g_currentMission.getFarmId ~= nil then
        myFarmId = g_currentMission:getFarmId() or 0
    end

    if myFarmId <= 0 then
        return
    end

    -- Flush all queued messages for this farm.
    local remaining = {}
    for _, msg in ipairs(g_rsInvoiceNotifyQueue) do
        if msg.recipientFarmId == myFarmId then
            local amountText = tostring(msg.grossAmount or 0)
            if g_i18n ~= nil and g_i18n.formatMoney ~= nil then
                amountText = g_i18n:formatMoney(msg.grossAmount or 0, 0, true, true)
            end

            local text = ""
            if g_i18n ~= nil and g_i18n.getText ~= nil then
                local tpl = g_i18n:getText("rs_ui_notifyInvoiceReceived") or ""
                if tpl ~= "" then
                    text = string.format(tpl, msg.issuerName or "", msg.title or "", amountText)
                end
            end

            if text == "" then
                text = string.format("New invoice from %s: %s (%s)", msg.issuerName or "?", msg.title or "", amountText)
            end

            if g_currentMission.addIngameNotification ~= nil and FSBaseMission ~= nil then
                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, "", text)
            elseif g_currentMission.showBlinkingWarning ~= nil then
                g_currentMission:showBlinkingWarning(text, 5000)
            end
        else
            table.insert(remaining, msg)
        end
    end

    g_rsInvoiceNotifyQueue = remaining
end

addModEventListener(RS_invoiceNotifyHelper)

function loadedMission()
    -- GUI scripts are sourced here to ensure GUI base classes are available
    if RS_createInvoiceDialog == nil then
        source(modDirectory .. "src/gui/RS_createInvoiceDialog.lua")
    end
    if RS_inGameMenuInvoices == nil then
        source(modDirectory .. "src/gui/RS_inGameMenuInvoices.lua")
    end

    if RS_inGameMenuInvoices == nil or RS_inGameMenuInvoices.new == nil then
        Logging.error("[RS] GUI class RS_inGameMenuInvoices could not be loaded. Check log for earlier errors.")
        return
    end
    local guiInvoices = RS_inGameMenuInvoices.new(g_i18n, g_messageCenter)
    g_gui:loadGui(modDirectory .. "gui/RS_inGameMenuInvoices.xml", "InGameMenuInvoices", guiInvoices, true)

    -- Insert as tab 3 (like the original mod)
    fixInGameMenu(guiInvoices, "InGameMenuInvoices", {0,0,1024,1024}, 3, nil)

    guiInvoices:initialize()

    -- MP: request current invoices from server when joining as client
    if g_currentMission ~= nil and g_currentMission:getIsClient() and not g_currentMission:getIsServer() then
        if g_client ~= nil and g_client.getServerConnection ~= nil then
            local conn = g_client:getServerConnection()
            if conn ~= nil then
                conn:sendEvent(RS_requestInvoicesEvent.new())
            end
        end
    end
end

function fixInGameMenu(frame, pageName, uvs, position, predicateFunc)
    local inGameMenu = g_gui.screenControllers[InGameMenu]

    -- remove all to avoid warnings
    inGameMenu.controlIDs[pageName] = nil

    inGameMenu[pageName] = frame
    inGameMenu.pagingElement:addElement(inGameMenu[pageName])

    inGameMenu:exposeControlsAsFields(pageName)

    for i = 1, #inGameMenu.pagingElement.elements do
        local child = inGameMenu.pagingElement.elements[i]
        if child == inGameMenu[pageName] then
            table.remove(inGameMenu.pagingElement.elements, i)
            table.insert(inGameMenu.pagingElement.elements, position, child)
            break
        end
    end

    for i = 1, #inGameMenu.pagingElement.pages do
        local child = inGameMenu.pagingElement.pages[i]
        if child.element == inGameMenu[pageName] then
            table.remove(inGameMenu.pagingElement.pages, i)
            table.insert(inGameMenu.pagingElement.pages, position, child)
            break
        end
    end

    inGameMenu.pagingElement:updateAbsolutePosition()
    inGameMenu.pagingElement:updatePageMapping()

    inGameMenu:registerPage(inGameMenu[pageName], position, predicateFunc)
    local iconFileName = Utils.getFilename('images/menuIcon.dds', modDirectory)
    inGameMenu:addPageTab(inGameMenu[pageName], iconFileName, GuiUtils.getUVs(uvs))

    for i = 1, #inGameMenu.pageFrames do
        local child = inGameMenu.pageFrames[i]
        if child == inGameMenu[pageName] then
            table.remove(inGameMenu.pageFrames, i)
            table.insert(inGameMenu.pageFrames, position, child)
            break
        end
    end

    inGameMenu:rebuildTabList()
end

function init()
    Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished, loadedMission)
    Mission00.loadItemsFinished = Utils.appendedFunction(Mission00.loadItemsFinished, function(...)
        -- In multiplayer, only the server has a writable savegame directory.
        -- Clients must not read/write custom savegame XML.
        if g_rs_invoiceManager ~= nil and g_currentMission ~= nil and g_currentMission:getIsServer() then
            g_rs_invoiceManager:loadFromXMLFile()
        end
    end)
    FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, function(missionInfo, ...)
        -- Only the server can persist data to the savegame folder in MP.
        if g_rs_invoiceManager ~= nil and g_currentMission ~= nil and g_currentMission:getIsServer() then
            g_rs_invoiceManager:saveToXMLFile(missionInfo)
        end
    end)
end

init()
