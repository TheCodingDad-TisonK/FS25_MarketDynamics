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

EasyDevControlsUpdateSnowAndSaltEvent = {}

EasyDevControlsUpdateSnowAndSaltEvent.SEND_NUM_BITS = 2

EasyDevControlsUpdateSnowAndSaltEvent.SET_SNOW = 0
EasyDevControlsUpdateSnowAndSaltEvent.ADD_SNOW = 1
EasyDevControlsUpdateSnowAndSaltEvent.REMOVE_SNOW = 2
EasyDevControlsUpdateSnowAndSaltEvent.ADD_SALT = 3

local EasyDevControlsUpdateSnowAndSaltEvent_mt = Class(EasyDevControlsUpdateSnowAndSaltEvent, Event)
InitEventClass(EasyDevControlsUpdateSnowAndSaltEvent, "EasyDevControlsUpdateSnowAndSaltEvent")

function EasyDevControlsUpdateSnowAndSaltEvent.emptyNew()
    return Event.new(EasyDevControlsUpdateSnowAndSaltEvent_mt)
end

function EasyDevControlsUpdateSnowAndSaltEvent.new(typeId, value)
    local self = EasyDevControlsUpdateSnowAndSaltEvent.emptyNew()

    self.typeId = typeId
    self.value = value

    return self
end

function EasyDevControlsUpdateSnowAndSaltEvent.newServerToClient(errorCode)
    local self = EasyDevControlsUpdateSnowAndSaltEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsUpdateSnowAndSaltEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.typeId = streamReadUIntN(streamId, EasyDevControlsUpdateSnowAndSaltEvent.SEND_NUM_BITS)

        if streamReadBool(streamId) then
            self.value = streamReadFloat32(streamId)
        end
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsUpdateSnowAndSaltEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteUIntN(streamId, self.typeId, EasyDevControlsUpdateSnowAndSaltEvent.SEND_NUM_BITS)

        if streamWriteBool(streamId, EasyDevControlsUpdateSnowAndSaltEvent.requiresValue(self.typeId) and self.value ~= nil) then
            streamWriteFloat32(streamId, self.value)
        end
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)
    end
end

function EasyDevControlsUpdateSnowAndSaltEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode = g_easyDevControls:updateSnowAndSalt(self.typeId, self.value, g_currentMission:getPlayerByConnection(connection))

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsUpdateSnowAndSaltEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsUpdateSnowAndSaltEvent.newServerToClient(errorCode))
    else
        local infoText = EasyDevControlsUtils.getText("easyDevControls_success") -- TO_DO: Add detailed reply
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsUpdateSnowAndSaltEvent, self.errorCode, infoText)
    end
end

function EasyDevControlsUpdateSnowAndSaltEvent.requiresValue(typeId)
    return typeId == EasyDevControlsUpdateSnowAndSaltEvent.SET_SNOW or typeId == EasyDevControlsUpdateSnowAndSaltEvent.ADD_SALT
end
