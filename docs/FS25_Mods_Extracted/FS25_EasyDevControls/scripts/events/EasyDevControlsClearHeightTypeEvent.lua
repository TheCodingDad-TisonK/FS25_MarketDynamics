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

EasyDevControlsClearHeightTypeEvent = {}

EasyDevControlsClearHeightTypeEvent.TYPE_NONE = 0
EasyDevControlsClearHeightTypeEvent.TYPE_AREA = 1
EasyDevControlsClearHeightTypeEvent.TYPE_FARMLAND = 2
EasyDevControlsClearHeightTypeEvent.TYPE_MAP = 3
-- EasyDevControlsClearHeightTypeEvent.TYPE_FIELD = 4

EasyDevControlsClearHeightTypeEvent.SEND_NUM_BITS = 3

local EasyDevControlsClearHeightTypeEvent_mt = Class(EasyDevControlsClearHeightTypeEvent, Event)
InitEventClass(EasyDevControlsClearHeightTypeEvent, "EasyDevControlsClearHeightTypeEvent")

function EasyDevControlsClearHeightTypeEvent.emptyNew()
    local self = Event.new(EasyDevControlsClearHeightTypeEvent_mt)

    return self
end

function EasyDevControlsClearHeightTypeEvent.new(typeId, fillTypeIndex, x, z, radius)
    local self = EasyDevControlsClearHeightTypeEvent.emptyNew()

    self.typeId = typeId or EasyDevControlsClearHeightTypeEvent.TYPE_NONE

    self.fillTypeIndex = fillTypeIndex

    self.x = x
    self.z = z

    self.radius = radius

    return self
end

function EasyDevControlsClearHeightTypeEvent.newServerToClient(errorCode)
    local self = EasyDevControlsClearHeightTypeEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsClearHeightTypeEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.typeId = streamReadUIntN(streamId, EasyDevControlsClearHeightTypeEvent.SEND_NUM_BITS)

        if streamReadBool(streamId) then
            self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
        end

        if self.typeId == EasyDevControlsClearHeightTypeEvent.TYPE_AREA then
            self.x = streamReadFloat32(streamId)
            self.z = streamReadFloat32(streamId)

            self.radius = streamReadUInt8(streamId)
        elseif self.typeId == EasyDevControlsClearHeightTypeEvent.TYPE_FARMLAND then
            self.x = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
        end
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsClearHeightTypeEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteUIntN(streamId, self.typeId, EasyDevControlsClearHeightTypeEvent.SEND_NUM_BITS)

        if streamWriteBool(streamId, self.fillTypeIndex ~= nil and self.fillTypeIndex ~= FillType.UNKNOWN) then
            streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)
        end

        if self.typeId == EasyDevControlsClearHeightTypeEvent.TYPE_AREA then
            streamWriteFloat32(streamId, self.x)
            streamWriteFloat32(streamId, self.z)

            streamWriteUInt8(streamId, self.radius)
        elseif self.typeId == EasyDevControlsClearHeightTypeEvent.TYPE_FARMLAND then
            streamWriteUIntN(streamId, self.x, g_farmlandManager.numberOfBits)
        end
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)
    end
end

function EasyDevControlsClearHeightTypeEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            local player = g_currentMission:getPlayerByConnection(connection)

            if player ~= nil then
                local farmId = player.farmId

                if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID then
                    message, errorCode = g_easyDevControls:clearHeightType(self.typeId, self.fillTypeIndex, self.x, self.z, self.radius, farmId, connection)

                    EasyDevControlsLogging.dedicatedServerInfo(message)
                else
                    errorCode = EasyDevControlsErrorCodes.INVALID_FARM
                end
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsClearHeightTypeEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsClearHeightTypeEvent.newServerToClient(errorCode))
    else
        local infoText = string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_clearTipAreaTitle"), EasyDevControlsUtils.getText("easyDevControls_success"))
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsClearHeightTypeEvent, self.errorCode, infoText)
    end
end

function EasyDevControlsClearHeightTypeEvent.getIsValidTypeId(typeId)
    return typeId == EasyDevControlsClearHeightTypeEvent.TYPE_AREA or
           typeId == EasyDevControlsClearHeightTypeEvent.TYPE_FARMLAND or
           typeId == EasyDevControlsClearHeightTypeEvent.TYPE_MAP
end
