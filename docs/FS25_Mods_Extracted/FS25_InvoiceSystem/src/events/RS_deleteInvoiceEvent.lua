-- Name: RS_deleteInvoiceEvent
-- Author: DonQuacko)

RS_deleteInvoiceEvent = {}

local RS_deleteInvoiceEvent_mt = Class(RS_deleteInvoiceEvent, Event)
InitEventClass(RS_deleteInvoiceEvent, "RS_deleteInvoiceEvent")

function RS_deleteInvoiceEvent.emptyNew()
    local self = Event.new(RS_deleteInvoiceEvent_mt)
    self.uid = ""
    return self
end

function RS_deleteInvoiceEvent.new(uid)
    local self = RS_deleteInvoiceEvent.emptyNew()
    self.uid = uid or ""
    return self
end

function RS_deleteInvoiceEvent:readStream(streamId, connection)
    self.uid = streamReadString(streamId) or ""
    self:run(connection)
end

function RS_deleteInvoiceEvent:writeStream(streamId, connection)
    streamWriteString(streamId, self.uid or "")
end

function RS_deleteInvoiceEvent:run(connection)
    -- Server only
    if not connection:getIsServer() then
        if g_rs_invoiceManager ~= nil then
            local inv = g_rs_invoiceManager:findInvoiceByUid(self.uid)
            if inv ~= nil then
                g_rs_invoiceManager:deleteInvoice(inv)
            end
        end
    end
end
