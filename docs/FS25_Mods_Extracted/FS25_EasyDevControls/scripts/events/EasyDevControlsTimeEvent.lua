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

EasyDevControlsTimeEvent = {}

local EasyDevControlsTimeEvent_mt = Class(EasyDevControlsTimeEvent, Event)
InitEventClass(EasyDevControlsTimeEvent, "EasyDevControlsTimeEvent")

function EasyDevControlsTimeEvent.emptyNew()
    return Event.new(EasyDevControlsTimeEvent_mt)
end

function EasyDevControlsTimeEvent.new(hourToSet, daysToAdvance)
    local self = EasyDevControlsTimeEvent.emptyNew()

    self.hourToSet = hourToSet
    self.daysToAdvance = daysToAdvance

    return self
end

function EasyDevControlsTimeEvent.newServerToClient(errorCode, requestedChange)
    local self = EasyDevControlsTimeEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)
    self.requestedChange = requestedChange

    return self
end

function EasyDevControlsTimeEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.hourToSet = streamReadUIntN(streamId, 5)
        self.daysToAdvance = streamReadUIntN(streamId, 9)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
        self.requestedChange = streamReadBool(streamId)
    end

    self:run(connection)
end

function EasyDevControlsTimeEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteUIntN(streamId, self.hourToSet, 5)
        streamWriteUIntN(streamId, self.daysToAdvance, 9)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
        streamWriteBool(streamId, self.requestedChange)
    end
end

function EasyDevControlsTimeEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode = g_easyDevControls:setCurrentTime(self.hourToSet, self.daysToAdvance)

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsTimeEvent - g_easyDevControls is nil!")
        end

        g_server:broadcastEvent(EasyDevControlsTimeEvent.newServerToClient(errorCode, false), false, connection)
        connection:sendEvent(EasyDevControlsTimeEvent.newServerToClient(errorCode, true))
    else
        if self.requestedChange then
            local infoText = nil

            if self.errorCode == EasyDevControlsErrorCodes.SUCCESS then
                local environment = g_currentMission.environment

                if environment ~= nil then
                    local periodFormat = g_i18n:formatDayInPeriod(environment.currentDayInPeriod, environment.currentPeriod, false)
                    local hourFormat = string.format("%02.f:00", environment.currentHour)

                    infoText = EasyDevControlsUtils.formatText("easyDevControls_setTimeInfo", periodFormat, hourFormat)
                else
                    infoText = EasyDevControlsUtils.getText("easyDevControls_success")
                end
            end

            g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsTimeEvent, self.errorCode, infoText)
        end

        g_messageCenter:publish(MessageType.EDC_COMMAND_STATE_CHANGED, "setTime", EasyDevControlsEnvironmentFrame.NAME)
    end
end
