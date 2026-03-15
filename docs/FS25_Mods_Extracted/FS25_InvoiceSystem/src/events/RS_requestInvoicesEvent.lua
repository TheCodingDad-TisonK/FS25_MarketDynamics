-- Name: RS_requestInvoicesEvent
-- Author: DonQuacko

RS_requestInvoicesEvent = {}

local RS_requestInvoicesEvent_mt = Class(RS_requestInvoicesEvent, Event)
InitEventClass(RS_requestInvoicesEvent, "RS_requestInvoicesEvent")

function RS_requestInvoicesEvent.emptyNew()
    local self = Event.new(RS_requestInvoicesEvent_mt)
    return self
end

function RS_requestInvoicesEvent.new()
    local self = RS_requestInvoicesEvent.emptyNew()
    return self
end

function RS_requestInvoicesEvent:readStream(streamId, connection)
    self:run(connection)
end

function RS_requestInvoicesEvent:writeStream(streamId, connection)
end

function RS_requestInvoicesEvent:run(connection)
    -- Runs on server when received from client
    if not connection:getIsServer() then
        if g_rs_invoiceManager ~= nil then
            g_rs_invoiceManager:sendInvoicesTo(connection)
        end
    end
end
