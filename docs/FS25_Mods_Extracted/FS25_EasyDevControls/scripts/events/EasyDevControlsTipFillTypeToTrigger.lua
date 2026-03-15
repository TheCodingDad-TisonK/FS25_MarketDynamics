--[[
Copyright (C) GtX (Andy), 2024

Author: GtX | Andy
Date: 22.11.2024
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

EasyDevControlsTipFillTypeToTrigger = {}

local EasyDevControlsTipFillTypeToTrigger_mt = Class(EasyDevControlsTipFillTypeToTrigger, Event)
InitEventClass(EasyDevControlsTipFillTypeToTrigger, "EasyDevControlsTipFillTypeToTrigger")

function EasyDevControlsTipFillTypeToTrigger.emptyNew()
    return Event.new(EasyDevControlsTipFillTypeToTrigger_mt)
end

function EasyDevControlsTipFillTypeToTrigger.new(object, fillUnitIndex, fillTypeIndex, deltaFillLevel)
    local self = EasyDevControlsTipFillTypeToTrigger.emptyNew()

    self.object = object

    self.fillUnitIndex = fillUnitIndex
    self.fillTypeIndex = fillTypeIndex

    self.deltaFillLevel = deltaFillLevel

    return self
end

function EasyDevControlsTipFillTypeToTrigger.newServerToClient(errorCode, appliedFillLevel)
    local self = EasyDevControlsTipFillTypeToTrigger.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)
    self.appliedFillLevel = appliedFillLevel

    return self
end

function EasyDevControlsTipFillTypeToTrigger:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.object = NetworkUtil.readNodeObject(streamId)

        self.fillUnitIndex = streamReadUInt8(streamId)
        self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)

        self.deltaFillLevel = streamReadFloat32(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
        self.appliedFillLevel = streamReadFloat32(streamId)
    end

    self:run(connection)
end

function EasyDevControlsTipFillTypeToTrigger:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.object)

        streamWriteUInt8(streamId, self.fillUnitIndex)
        streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)

        streamWriteFloat32(streamId, self.deltaFillLevel)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
        streamWriteFloat32(streamId, self.appliedFillLevel)
    end
end

function EasyDevControlsTipFillTypeToTrigger:run(connection)
    if not connection:getIsServer() then
        if g_easyDevControls ~= nil then
            local farmId = g_currentMission:getFarmId(connection)
            local message, errorCode, appliedFillLevel = g_easyDevControls:tipFillTypeToTrigger(self.object, self.fillUnitIndex, self.fillTypeIndex, self.deltaFillLevel, farmId)

            EasyDevControlsLogging.dedicatedServerInfo(message)

            connection:sendEvent(EasyDevControlsTipFillTypeToTrigger.newServerToClient(errorCode, appliedFillLevel or 0))
        else
            EasyDevControlsLogging.devError("EasyDevControlsTipFillTypeToTrigger - g_easyDevControls is nil!")

            connection:sendEvent(EasyDevControlsTipFillTypeToTrigger.newServerToClient(EasyDevControlsErrorCodes.UNKNOWN_FAIL, 0))
        end
    else
        local infoText = nil

        if self.errorCode == EasyDevControlsErrorCodes.SUCCESS then
            infoText = EasyDevControlsUtils.formatText("easyDevControls_tipToTriggerSuccess", string.format("%s %s", g_i18n:formatNumber(self.appliedFillLevel or 0), g_i18n:getText("unit_liter")))
        end

        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsTipFillTypeToTrigger, self.errorCode, infoText)
    end
end
