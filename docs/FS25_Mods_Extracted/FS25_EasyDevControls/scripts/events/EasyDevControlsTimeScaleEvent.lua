--[[
Copyright (C) GtX (Andy), 2019

Author: GtX | Andy
Date: 07.04.2019
Revision: FS25-02

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

EasyDevControlsTimeScaleEvent = {}

local EasyDevControlsTimeScaleEvent_mt = Class(EasyDevControlsTimeScaleEvent, Event)
InitEventClass(EasyDevControlsTimeScaleEvent, "EasyDevControlsTimeScaleEvent")

function EasyDevControlsTimeScaleEvent.emptyNew()
    local self = Event.new(EasyDevControlsTimeScaleEvent_mt)

    return self
end

function EasyDevControlsTimeScaleEvent.new(active, stopTime)
    local self = EasyDevControlsTimeScaleEvent.emptyNew()

    self.active = active
    self.stopTime = Utils.getNoNil(stopTime, false)

    return self
end

function EasyDevControlsTimeScaleEvent:readStream(streamId, connection)
    self.active = streamReadBool(streamId)
    self.stopTime = streamReadBool(streamId)

    self:run(connection)
end

function EasyDevControlsTimeScaleEvent:writeStream(streamId, connection)
    streamWriteBool(streamId, self.active)
    streamWriteBool(streamId, self.stopTime)
end

function EasyDevControlsTimeScaleEvent:run(connection)
    if g_easyDevControls ~= nil then
        if not self.stopTime then
            g_easyDevControls:setCustomTimeScaleState(self.active)

            -- Just send to everyone, will only display in GUI if the client has an outstanding request ;-)
            if connection:getIsServer() and g_easyDevControls.gameStarted then
                local infoText = EasyDevControlsUtils.formatText("easyDevControls_extraTimescalesInfo", EasyDevControlsUtils.getStateText(self.active))
                g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsTimeScaleEvent, EasyDevControlsErrorCodes.SUCCESS, infoText)
            end
        elseif not connection:getIsServer() then
            g_currentMission:setTimeScale(g_currentMission.missionInfo.timeScale > 0 and 0 or 1)
        end
    else
        EasyDevControlsLogging.devError("EasyDevControlsTimeScaleEvent - g_easyDevControls is nil!")
    end
end
