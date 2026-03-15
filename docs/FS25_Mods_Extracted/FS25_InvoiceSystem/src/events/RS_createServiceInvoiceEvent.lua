-- Name: RS_createServiceInvoiceEvent
-- Author: DonQuacko)

RS_createServiceInvoiceEvent = {}

local RS_createServiceInvoiceEvent_mt = Class(RS_createServiceInvoiceEvent, Event)
InitEventClass(RS_createServiceInvoiceEvent, "RS_createServiceInvoiceEvent")

function RS_createServiceInvoiceEvent.emptyNew()
    local self = Event.new(RS_createServiceInvoiceEvent_mt)
    return self
end

function RS_createServiceInvoiceEvent.new(issuerFarmId, recipientFarmId, amount, fieldId, activity, fieldName, titleOverride, quantity, unitType, fillTypeIndex, fillTypeTitle)
    local self = RS_createServiceInvoiceEvent.emptyNew()
    self.issuerFarmId = issuerFarmId or 0
    self.recipientFarmId = recipientFarmId or 0
    self.amount = amount or 0
    self.fieldId = fieldId or 0
    self.activity = activity or ""
    self.fieldName = fieldName or ""
    self.titleOverride = titleOverride or ""
    self.quantity = tonumber(quantity) or 0
    self.unitType = unitType or ""
    self.fillTypeIndex = fillTypeIndex or 0
    self.fillTypeTitle = fillTypeTitle or ""
    return self
end

function RS_createServiceInvoiceEvent:readStream(streamId, connection)
    self.issuerFarmId = streamReadInt32(streamId)
    self.recipientFarmId = streamReadInt32(streamId)
    self.amount = streamReadInt32(streamId)
    self.fieldId = streamReadInt32(streamId)
    self.activity = streamReadString(streamId) or ""
    self.fieldName = streamReadString(streamId) or ""
    self.titleOverride = streamReadString(streamId) or ""
    self.quantity = streamReadFloat32(streamId)
    self.unitType = streamReadString(streamId) or ""
    self.fillTypeIndex = streamReadInt32(streamId)
    self.fillTypeTitle = streamReadString(streamId) or ""
    self:run(connection)
end

function RS_createServiceInvoiceEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.issuerFarmId or 0)
    streamWriteInt32(streamId, self.recipientFarmId or 0)
    streamWriteInt32(streamId, self.amount or 0)
    streamWriteInt32(streamId, self.fieldId or 0)
    streamWriteString(streamId, self.activity or "")
    streamWriteString(streamId, self.fieldName or "")
    streamWriteString(streamId, self.titleOverride or "")
    streamWriteFloat32(streamId, tonumber(self.quantity) or 0)
    streamWriteString(streamId, self.unitType or "")
    streamWriteInt32(streamId, self.fillTypeIndex or 0)
    streamWriteString(streamId, self.fillTypeTitle or "")
end

function RS_createServiceInvoiceEvent:run(connection)
    -- Runs on server when received from client
    if not connection:getIsServer() then
        if g_rs_invoiceManager ~= nil then
            g_rs_invoiceManager:createServiceInvoice(self.issuerFarmId, self.recipientFarmId, self.amount, self.fieldId, self.activity, self.fieldName, self.titleOverride, self.quantity, self.unitType, self.fillTypeIndex, self.fillTypeTitle)
        end
    end
end
