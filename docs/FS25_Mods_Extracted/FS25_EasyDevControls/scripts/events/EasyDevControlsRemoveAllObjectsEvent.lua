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

EasyDevControlsRemoveAllObjectsEvent = {}

local EasyDevControlsRemoveAllObjectsEvent_mt = Class(EasyDevControlsRemoveAllObjectsEvent, Event)
InitEventClass(EasyDevControlsRemoveAllObjectsEvent, "EasyDevControlsRemoveAllObjectsEvent")

function EasyDevControlsRemoveAllObjectsEvent.emptyNew()
    return Event.new(EasyDevControlsRemoveAllObjectsEvent_mt, NetworkNode.CHANNEL_MAIN)
end

function EasyDevControlsRemoveAllObjectsEvent.new(typeId)
    local self = EasyDevControlsRemoveAllObjectsEvent.emptyNew()

    self.typeId = typeId

    return self
end

function EasyDevControlsRemoveAllObjectsEvent.newServerToClient(errorCode, typeId, numRemoved)
    local self = EasyDevControlsRemoveAllObjectsEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    self.typeId = typeId
    self.numRemoved = numRemoved

    return self
end

function EasyDevControlsRemoveAllObjectsEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.typeId = EasyDevControlsObjectTypes.readStream(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
        self.typeId = EasyDevControlsObjectTypes.readStream(streamId)
        self.numRemoved = streamReadInt32(streamId)
    end

    self:run(connection)
end

function EasyDevControlsRemoveAllObjectsEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        EasyDevControlsObjectTypes.writeStream(streamId, self.typeId)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)
        EasyDevControlsObjectTypes.writeStream(streamId, self.typeId)
        streamWriteInt32(streamId, self.numRemoved)
    end
end

function EasyDevControlsRemoveAllObjectsEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode, numRemoved = nil, nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode, numRemoved = g_easyDevControls:removeAllObjects(self.typeId)

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsRemoveAllObjectsEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsRemoveAllObjectsEvent.newServerToClient(errorCode, self.typeId, numRemoved or 0))
    else
        local infoText = EasyDevControlsUtils.formatText("easyDevControls_removeAllObjectsInfo", tostring(self.numRemoved), EasyDevControlsObjectTypes.getText(self.typeId, self.numRemoved, false))
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsRemoveAllObjectsEvent, self.errorCode, infoText)
    end
end

function EasyDevControlsRemoveAllObjectsEvent.getIsValidTypeId(typeId)
    return typeId == EasyDevControlsObjectTypes.VEHICLE or
           typeId == EasyDevControlsObjectTypes.PALLET or
           typeId == EasyDevControlsObjectTypes.BALE or
           typeId == EasyDevControlsObjectTypes.LOG or
           typeId == EasyDevControlsObjectTypes.STUMP or
           typeId == EasyDevControlsObjectTypes.PLACEABLE or
           typeId == EasyDevControlsObjectTypes.MAP_PLACEABLE
end
