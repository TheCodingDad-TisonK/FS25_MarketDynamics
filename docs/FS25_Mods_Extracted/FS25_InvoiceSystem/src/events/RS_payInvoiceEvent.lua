-- Name: RS_payInvoiceEvent
-- Author: DonQuacko

RS_payInvoiceEvent = {}

local RS_payInvoiceEvent_mt = Class(RS_payInvoiceEvent, Event)
InitEventClass(RS_payInvoiceEvent, "RS_payInvoiceEvent")

function RS_payInvoiceEvent.emptyNew()
    local self = Event.new(RS_payInvoiceEvent_mt)
    self.uid = ""
    self.farmId = 0
    return self
end

function RS_payInvoiceEvent.new(uid, farmId)
    local self = RS_payInvoiceEvent.emptyNew()
    self.uid = uid or ""
    self.farmId = farmId or 0
    return self
end

function RS_payInvoiceEvent:readStream(streamId, connection)
    self.uid = streamReadString(streamId) or ""
    self.farmId = streamReadInt32(streamId) or 0
    self:run(connection)
end

function RS_payInvoiceEvent:writeStream(streamId, connection)
    streamWriteString(streamId, self.uid or "")
    streamWriteInt32(streamId, self.farmId or 0)
end

function RS_payInvoiceEvent:run(connection)
    -- Runs on server when received from a client connection
    if not connection:getIsServer() then
        if g_rs_invoiceManager ~= nil then
            local inv = g_rs_invoiceManager:findInvoiceByUid(self.uid)
            if inv ~= nil then
                -- Determine payer farm from connection (preferred), fall back to transmitted farmId
                local payerFarmId = 0
                local userId = nil

                if connection.getUserId ~= nil then
                    userId = connection:getUserId()
                end
                if userId == nil and connection.playerUserId ~= nil then
                    userId = connection.playerUserId
                end
                if userId == nil and connection.userId ~= nil then
                    userId = connection.userId
                end

                if userId ~= nil and g_farmManager ~= nil and g_farmManager.getFarmByUserId ~= nil then
                    local farm = g_farmManager:getFarmByUserId(userId)
                    payerFarmId = farm ~= nil and farm.farmId or 0
                end

                if payerFarmId == 0 then
                    payerFarmId = self.farmId or 0
                end

                g_rs_invoiceManager:payInvoice(inv, payerFarmId)
            end
        end
    end
end
