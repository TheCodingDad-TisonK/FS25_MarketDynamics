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

EasyDevControlsSetFillUnitFillLevel = {}

local EasyDevControlsSetFillUnitFillLevel_mt = Class(EasyDevControlsSetFillUnitFillLevel, Event)
InitEventClass(EasyDevControlsSetFillUnitFillLevel, "EasyDevControlsSetFillUnitFillLevel")

function EasyDevControlsSetFillUnitFillLevel.emptyNew()
    local self = Event.new(EasyDevControlsSetFillUnitFillLevel_mt)

    return self
end

function EasyDevControlsSetFillUnitFillLevel.new(vehicle, fillUnitIndex, fillTypeIndex, amount, ignoreRemoveIfEmpty)
    local self = EasyDevControlsSetFillUnitFillLevel.emptyNew()

    self.vehicle = vehicle

    self.fillUnitIndex = fillUnitIndex
    self.fillTypeIndex = fillTypeIndex

    self.amount = amount
    self.ignoreRemoveIfEmpty = ignoreRemoveIfEmpty

    return self
end

function EasyDevControlsSetFillUnitFillLevel.newServerToClient(errorCode)
    local self = EasyDevControlsSetFillUnitFillLevel.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsSetFillUnitFillLevel:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.vehicle = NetworkUtil.readNodeObject(streamId)

        self.fillUnitIndex = streamReadUInt8(streamId)
        self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)

        self.amount = streamReadFloat32(streamId)
        self.ignoreRemoveIfEmpty = streamReadBool(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsSetFillUnitFillLevel:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.vehicle)

        streamWriteUInt8(streamId, self.fillUnitIndex)
        streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)

        streamWriteFloat32(streamId, self.amount)
        streamWriteBool(streamId, self.ignoreRemoveIfEmpty)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    end
end

function EasyDevControlsSetFillUnitFillLevel:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode = g_easyDevControls:setFillUnitFillLevel(self.vehicle, self.fillUnitIndex, self.fillTypeIndex, self.amount, self.ignoreRemoveIfEmpty)

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsSetFillUnitFillLevel - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsSetFillUnitFillLevel.newServerToClient(errorCode))
    else
        local infoText = EasyDevControlsUtils.getText("easyDevControls_success") -- TO_DO: Add detailed reply
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsSetFillUnitFillLevel, self.errorCode, infoText)
    end
end
