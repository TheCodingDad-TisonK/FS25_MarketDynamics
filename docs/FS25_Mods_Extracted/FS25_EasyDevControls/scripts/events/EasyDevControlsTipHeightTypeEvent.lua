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

EasyDevControlsTipHeightTypeEvent = {}

local EasyDevControlsTipHeightTypeEvent_mt = Class(EasyDevControlsTipHeightTypeEvent, Event)
InitEventClass(EasyDevControlsTipHeightTypeEvent, "EasyDevControlsTipHeightTypeEvent")

function EasyDevControlsTipHeightTypeEvent.emptyNew()
    local self = Event.new(EasyDevControlsTipHeightTypeEvent_mt)

    return self
end

function EasyDevControlsTipHeightTypeEvent.new(amount, fillTypeIndex, x, y, z, dirX, dirZ, length, vehicle)
    local self = EasyDevControlsTipHeightTypeEvent.emptyNew()

    self.amount = amount
    self.fillTypeIndex = fillTypeIndex

    self.x = x
    self.y = y
    self.z = z

    self.dirX = dirX
    self.dirZ = dirZ
    self.length = length

    self.vehicle = vehicle

    return self
end

function EasyDevControlsTipHeightTypeEvent.newServerToClient(errorCode)
    local self = EasyDevControlsTipHeightTypeEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsTipHeightTypeEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.amount = streamReadFloat32(streamId)
        self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)

        self.x = streamReadFloat32(streamId)
        self.y = streamReadFloat32(streamId)
        self.z = streamReadFloat32(streamId)

        self.dirX = streamReadFloat32(streamId)
        self.dirZ = streamReadFloat32(streamId)
        self.length = streamReadUInt8(streamId)

        if streamReadBool(streamId) then
            self.vehicle = NetworkUtil.readNodeObject(streamId)
        end
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsTipHeightTypeEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteFloat32(streamId, self.amount)
        streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)

        streamWriteFloat32(streamId, self.x)
        streamWriteFloat32(streamId, self.y)
        streamWriteFloat32(streamId, self.z)

        streamWriteFloat32(streamId, self.dirX)
        streamWriteFloat32(streamId, self.dirZ)
        streamWriteUInt8(streamId, self.length)

        if streamWriteBool(streamId, self.vehicle ~= nil) then
            NetworkUtil.writeNodeObject(streamId, self.vehicle)
        end
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    end
end

function EasyDevControlsTipHeightTypeEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            local player = g_currentMission:getPlayerByConnection(connection)

            if player ~= nil then
                local farmId = player.farmId

                if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID then
                    message, errorCode = g_easyDevControls:tipHeightType(self.amount, self.fillTypeIndex, self.x, self.y, self.z, self.dirX, self.dirZ, self.length, self.vehicle, player, connection)

                    EasyDevControlsLogging.dedicatedServerInfo(message)
                else
                    errorCode = EasyDevControlsErrorCodes.INVALID_FARM
                end
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsTipHeightTypeEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsTipHeightTypeEvent.newServerToClient(errorCode))
    else
        local infoText = string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_tipToGroundTitle"), EasyDevControlsUtils.getText("easyDevControls_success"))
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsTipHeightTypeEvent, self.errorCode, infoText)
    end
end
