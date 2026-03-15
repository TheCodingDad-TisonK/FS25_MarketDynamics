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

EasyDevControlsSetProductionPointFillLevelsEvent = {}

local EasyDevControlsSetProductionPointFillLevelsEvent_mt = Class(EasyDevControlsSetProductionPointFillLevelsEvent, Event)
InitEventClass(EasyDevControlsSetProductionPointFillLevelsEvent, "EasyDevControlsSetProductionPointFillLevelsEvent")

function EasyDevControlsSetProductionPointFillLevelsEvent.emptyNew()
    return Event.new(EasyDevControlsSetProductionPointFillLevelsEvent_mt)
end

function EasyDevControlsSetProductionPointFillLevelsEvent.new(productionPoint, fillLevel, fillTypeIndex, isOutput)
    local self = EasyDevControlsSetProductionPointFillLevelsEvent.emptyNew()

    self.productionPoint = productionPoint
    self.fillLevel = fillLevel

    self.fillTypeIndex = fillTypeIndex
    self.isOutput = isOutput

    return self
end

function EasyDevControlsSetProductionPointFillLevelsEvent.newServerToClient(errorCode)
    local self = EasyDevControlsSetProductionPointFillLevelsEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsSetProductionPointFillLevelsEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.productionPoint = NetworkUtil.readNodeObject(streamId)

        self.fillLevel = streamReadFloat32(streamId)
        self.fillTypeIndex = nil

        if streamReadBool(streamId) then
            self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
        end

        self.isOutput = streamReadBool(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsSetProductionPointFillLevelsEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.productionPoint)

        streamWriteFloat32(streamId, self.fillLevel)

        if streamWriteBool(streamId, self.fillTypeIndex ~= nil) then
            streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)
        end

        streamWriteBool(streamId, self.isOutput)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    end
end

function EasyDevControlsSetProductionPointFillLevelsEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode = g_easyDevControls:setProductionPointFillLevels(self.productionPoint, self.fillLevel, self.fillTypeIndex, self.isOutput, false)

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsSetProductionPointFillLevelsEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsSetProductionPointFillLevelsEvent.newServerToClient(errorCode))
    else
        local infoText = EasyDevControlsUtils.getText("easyDevControls_success") -- TO_DO: Add detailed reply
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsSetProductionPointFillLevelsEvent, self.errorCode, infoText)
    end
end