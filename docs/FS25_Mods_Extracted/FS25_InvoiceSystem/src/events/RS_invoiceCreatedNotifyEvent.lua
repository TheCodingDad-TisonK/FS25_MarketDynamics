-- Name: RS_invoiceCreatedNotifyEvent
-- Author: DonQuacko

RS_invoiceCreatedNotifyEvent = {}

local RS_invoiceCreatedNotifyEvent_mt = Class(RS_invoiceCreatedNotifyEvent, Event)
InitEventClass(RS_invoiceCreatedNotifyEvent, "RS_invoiceCreatedNotifyEvent")

function RS_invoiceCreatedNotifyEvent.emptyNew()
    local self = Event.new(RS_invoiceCreatedNotifyEvent_mt)
    return self
end

function RS_invoiceCreatedNotifyEvent.new(recipientFarmId, issuerName, title, grossAmount)
    local self = RS_invoiceCreatedNotifyEvent.emptyNew()
    self.recipientFarmId = recipientFarmId or 0
    self.issuerName = issuerName or ""
    self.title = title or ""
    self.grossAmount = grossAmount or 0
    return self
end

function RS_invoiceCreatedNotifyEvent:readStream(streamId, connection)
    self.recipientFarmId = streamReadInt32(streamId)
    self.issuerName = streamReadString(streamId) or ""
    self.title = streamReadString(streamId) or ""
    self.grossAmount = streamReadInt32(streamId)
    self:run(connection)
end

function RS_invoiceCreatedNotifyEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.recipientFarmId or 0)
    streamWriteString(streamId, self.issuerName or "")
    streamWriteString(streamId, self.title or "")
    streamWriteInt32(streamId, self.grossAmount or 0)
end

function RS_invoiceCreatedNotifyEvent:run(connection)
    -- Runs on client when received from server
    if connection ~= nil and connection:getIsServer() then
        if g_currentMission ~= nil then
            -- Determine local player's current farm.
            local myFarmId = 0
            if g_currentMission.player ~= nil and g_currentMission.player.farmId ~= nil and g_currentMission.player.farmId > 0 then
                myFarmId = g_currentMission.player.farmId
            elseif g_currentMission.getFarmId ~= nil then
                -- Fallback (can be unreliable in some MP situations, but better than nothing)
                myFarmId = g_currentMission:getFarmId() or 0
            end

            -- If farmId is not known yet (e.g. early join), queue the message and show it once the player exists.
            if myFarmId <= 0 then
                g_rsInvoiceNotifyQueue = g_rsInvoiceNotifyQueue or {}
                table.insert(g_rsInvoiceNotifyQueue, {
                    recipientFarmId = self.recipientFarmId,
                    issuerName = self.issuerName,
                    title = self.title,
                    grossAmount = self.grossAmount
                })
                return
            end

            if myFarmId == (self.recipientFarmId or -1) then
                local amountText = tostring(self.grossAmount or 0)
                if g_i18n ~= nil and g_i18n.formatMoney ~= nil then
                    amountText = g_i18n:formatMoney(self.grossAmount or 0, 0, true, true)
                end

                local text = ""
                if g_i18n ~= nil and g_i18n.getText ~= nil then
                    local tpl = g_i18n:getText("rs_ui_notifyInvoiceReceived") or ""
                    if tpl ~= "" then
                        text = string.format(tpl, self.issuerName or "", self.title or "", amountText)
                    end
                end

                if text == "" then
                    text = string.format("New invoice from %s: %s (%s)", self.issuerName or "?", self.title or "", amountText)
                end

                -- Prefer the standard HUD notification.
                if g_currentMission.addIngameNotification ~= nil and FSBaseMission ~= nil then
                    g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, "", text)
                elseif g_currentMission.showBlinkingWarning ~= nil then
                    g_currentMission:showBlinkingWarning(text, 5000)
                end
            end
        end
    end
end
