-- Name: RS_settingsEvent
-- Author: DonQuacko)

RS_settingsEvent = {}

local RS_settingsEvent_mt = Class(RS_settingsEvent, Event)
InitEventClass(RS_settingsEvent, "RS_settingsEvent")

function RS_settingsEvent.emptyNew()
    local self = Event.new(RS_settingsEvent_mt)
    self.settings = {}
    return self
end

function RS_settingsEvent.new(settings)
    local self = RS_settingsEvent.emptyNew()
    self.settings = settings or {}
    return self
end

function RS_settingsEvent:readStream(streamId, connection)
    local s = {}
    s.rsVatPercent = streamReadUInt8(streamId)
    s.rsMaxOpenInvoices = streamReadUInt8(streamId)
    s.rsInterestPercent = streamReadUInt8(streamId)
    s.rsInterestIntervalDays = streamReadUInt8(streamId)
    self.settings = s

    self:run(connection)
end

function RS_settingsEvent:writeStream(streamId, connection)
    local s = self.settings or {}
    streamWriteUInt8(streamId, tonumber(s.rsVatPercent) or 19)
    streamWriteUInt8(streamId, tonumber(s.rsMaxOpenInvoices) or 10)
    streamWriteUInt8(streamId, tonumber(s.rsInterestPercent) or 0)
    streamWriteUInt8(streamId, tonumber(s.rsInterestIntervalDays) or 3)
end

function RS_settingsEvent:run(connection)
    if g_rs_invoiceSettings == nil then
        return
    end

    -- Client -> Server: apply and rebroadcast authoritative settings
    if connection ~= nil and not connection:getIsServer() then
        if g_currentMission ~= nil and g_currentMission:getIsServer() then
            g_rs_invoiceSettings:applySettings(self.settings, true)
        end
        return
    end

    -- Server -> Client: apply received settings
    if connection ~= nil and connection:getIsServer() then
        g_rs_invoiceSettings:applySettings(self.settings, false)
    end
end
