--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-01

Contact:
https://forum.giants-software.com
https://github.com/GtX-Andy/FS25_EasyDevelopmentControls

Important:
Not to be added to any mods / maps or modified from its current release form.
No modifications may be made to this script, including conversion to other game versions without written permission from GtX | Andy
Copying or removing any part of this code for external use without written permission from GtX | Andy is prohibited.

Darf nicht zu Mods / Maps hinzugefügt oder von der aktuellen Release-Form geändert werden.
Ohne schriftliche Genehmigung von GtX | Andy dürfen keine Änderungen an diesem Skript vorgenommen werden, einschließlich der Konvertierung in andere Spielversionen
Das Kopieren oder Entfernen irgendeines Teils dieses Codes zur externen Verwendung ohne schriftliche Genehmigung von GtX | Andy ist verboten.
]]

EasyDevControlsUpdateSetGrowthPeriodEvent = {}
EasyDevControlsUpdateSetGrowthPeriodEvent.PERIOD_SEND_NUM_BITS = 4

local EasyDevControlsUpdateSetGrowthPeriodEvent_mt = Class(EasyDevControlsUpdateSetGrowthPeriodEvent, Event)
InitEventClass(EasyDevControlsUpdateSetGrowthPeriodEvent, "EasyDevControlsUpdateSetGrowthPeriodEvent")

function EasyDevControlsUpdateSetGrowthPeriodEvent.emptyNew()
    return Event.new(EasyDevControlsUpdateSetGrowthPeriodEvent_mt)
end

function EasyDevControlsUpdateSetGrowthPeriodEvent.new(seasonal, period)
    local self = EasyDevControlsUpdateSetGrowthPeriodEvent.emptyNew()

    self.seasonal = seasonal
    self.period = period

    return self
end

-- function EasyDevControlsUpdateSetGrowthPeriodEvent.newServerToClient(errorCode)
    -- local self = EasyDevControlsUpdateSetGrowthPeriodEvent.emptyNew()

    -- self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    -- return self
-- end

function EasyDevControlsUpdateSetGrowthPeriodEvent:readStream(streamId, connection)
    -- if not connection:getIsServer() then
        self.seasonal = streamReadBool(streamId)

        if self.seasonal then
            self.period = streamReadUIntN(streamId, EasyDevControlsUpdateSetGrowthPeriodEvent.PERIOD_SEND_NUM_BITS)
        end
    -- else
        -- self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    -- end

    self:run(connection)
end

function EasyDevControlsUpdateSetGrowthPeriodEvent:writeStream(streamId, connection)
    -- if connection:getIsServer() then
        if streamWriteBool(streamId, self.seasonal) then
            streamWriteUIntN(streamId, self.period, EasyDevControlsUpdateSetGrowthPeriodEvent.PERIOD_SEND_NUM_BITS)
        end
    -- else
        -- EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    -- end
end

function EasyDevControlsUpdateSetGrowthPeriodEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode = g_easyDevControls:setGrowthPeriod(self.seasonal, self.period)

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsUpdateSetGrowthPeriodEvent - g_easyDevControls is nil!")
        end

        -- if errorCode ~= EasyDevControlsErrorCodes.SUCCESS then
            -- connection:sendEvent(EasyDevControlsUpdateSetGrowthPeriodEvent.newServerToClient(errorCode))
        -- end
    else
        -- g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsUpdateSetGrowthPeriodEvent, self.errorCode)
    end
end
