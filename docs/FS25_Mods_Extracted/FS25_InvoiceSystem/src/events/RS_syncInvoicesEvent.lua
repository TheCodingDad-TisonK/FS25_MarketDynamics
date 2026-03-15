-- Name: RS_syncInvoicesEvent
-- Author: DonQuacko

RS_syncInvoicesEvent = {}

local RS_syncInvoicesEvent_mt = Class(RS_syncInvoicesEvent, Event)
InitEventClass(RS_syncInvoicesEvent, "RS_syncInvoicesEvent")

function RS_syncInvoicesEvent.emptyNew()
    local self = Event.new(RS_syncInvoicesEvent_mt)
    self.invoices = {}
    return self
end

function RS_syncInvoicesEvent.new(invoices)
    local self = RS_syncInvoicesEvent.emptyNew()
    self.invoices = invoices or {}
    return self
end

function RS_syncInvoicesEvent:readStream(streamId, connection)
    local count = streamReadUInt16(streamId)
    self.invoices = {}

    for i = 1, count do
        local inv = RS_invoice.new(false, true)
        inv:readStream(streamId, connection)
        inv:register()
        table.insert(self.invoices, inv)
    end

    self:run(connection)
end

function RS_syncInvoicesEvent:writeStream(streamId, connection)
    local invoices = self.invoices or {}
    streamWriteUInt16(streamId, #invoices)

    for i = 1, #invoices do
        local inv = invoices[i]
        inv:writeStream(streamId, connection)
    end
end

function RS_syncInvoicesEvent:run(connection)
    -- Runs on client when received from server
    if connection ~= nil and connection:getIsServer() then
        if g_rs_invoiceManager ~= nil then
            g_rs_invoiceManager.invoices = self.invoices or {}
            g_rs_invoiceManager:markDirty()
        end
    end
end
