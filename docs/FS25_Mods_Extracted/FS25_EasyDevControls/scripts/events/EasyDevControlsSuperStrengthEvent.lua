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

EasyDevControlsSuperStrengthEvent = {}

local EasyDevControlsSuperStrengthEvent_mt = Class(EasyDevControlsSuperStrengthEvent, Event)
InitEventClass(EasyDevControlsSuperStrengthEvent, "EasyDevControlsSuperStrengthEvent")

function EasyDevControlsSuperStrengthEvent.emptyNew()
    local self = Event.new(EasyDevControlsSuperStrengthEvent_mt)

    return self
end

function EasyDevControlsSuperStrengthEvent.new(active, userId, isSync)
    local self = EasyDevControlsSuperStrengthEvent.emptyNew()

    self.active = active
    self.userId = userId
    self.isSync = isSync

    return self
end

function EasyDevControlsSuperStrengthEvent.newServerToClient(errorCode, active, userId, isSync)
    local self = EasyDevControlsSuperStrengthEvent.new(active, userId, isSync)

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsSuperStrengthEvent:readStream(streamId, connection)
    if connection:getIsServer() then
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self.active = streamReadBool(streamId)

    if streamReadBool(streamId) then
        self.userId = streamReadInt32(streamId)
    end

    self.isSync = streamReadBool(streamId)

    self:run(connection)
end

function EasyDevControlsSuperStrengthEvent:writeStream(streamId, connection)
    if not connection:getIsServer() then
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    end

    streamWriteBool(streamId, self.active)

    if streamWriteBool(streamId, self.userId ~= nil) then
        streamWriteInt32(streamId, self.userId)
    end

    streamWriteBool(streamId, self.isSync)
end

function EasyDevControlsSuperStrengthEvent:run(connection)
    if g_easyDevControls ~= nil then
        if not self.isSync then
            if not connection:getIsServer() then
                self.userId = g_currentMission.userManager:getUserIdByConnection(connection)

                local message, errorCode = g_easyDevControls:setSuperStrengthEnabled(self.active, self.userId)

                g_server:broadcastEvent(EasyDevControlsSuperStrengthEvent.newServerToClient(EasyDevControlsErrorCodes.NONE, self.active, self.userId, false), false, connection)

                EasyDevControlsLogging.dedicatedServerInfo(message)

                connection:sendEvent(EasyDevControlsSuperStrengthEvent.newServerToClient(errorCode, self.active, self.userId, false))
            else
                local message = g_easyDevControls:setSuperStrengthEnabled(self.active, self.userId)

                if self.errorCode ~= EasyDevControlsErrorCodes.NONE and self.userId == g_localPlayer.userId then
                    g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsSuperStrengthEvent, self.errorCode, message)
                end
            end
        elseif not g_easyDevControls.gameStarted then
            g_easyDevControls.superStrengthEnabled = self.active

            if g_easyDevControlsSettings ~= nil then
                g_easyDevControlsSettings:setValue("superStrength", self.active)
            end
        end
    else
        EasyDevControlsLogging.devError("EasyDevControlsSuperStrengthEvent - g_easyDevControls is nil!")
    end
end

