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

EasyDevControlsVineSystemSetStateEvent = {}

local EasyDevControlsVineSystemSetStateEvent_mt = Class(EasyDevControlsVineSystemSetStateEvent, Event)
InitEventClass(EasyDevControlsVineSystemSetStateEvent, "EasyDevControlsVineSystemSetStateEvent")

function EasyDevControlsVineSystemSetStateEvent.emptyNew()
    return Event.new(EasyDevControlsVineSystemSetStateEvent_mt)
end

function EasyDevControlsVineSystemSetStateEvent.new(placeableVine, fruitTypeIndex, growthState)
    local self = EasyDevControlsVineSystemSetStateEvent.emptyNew()

    self.placeableVine = placeableVine
    self.fruitTypeIndex = fruitTypeIndex
    self.growthState = growthState

    return self
end

function EasyDevControlsVineSystemSetStateEvent.newServerToClient(errorCode)
    local self = EasyDevControlsVineSystemSetStateEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsVineSystemSetStateEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        if streamReadBool(streamId) then
            self.placeableVine = NetworkUtil.readNodeObject(streamId)
        end

        self.fruitTypeIndex = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)
        self.growthState = streamReadUInt8(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsVineSystemSetStateEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        if streamWriteBool(streamId, self.placeableVine ~= nil) then
            NetworkUtil.writeNodeObject(streamId, self.placeableVine)
        end

        streamWriteUIntN(streamId, self.fruitTypeIndex, FruitTypeManager.SEND_NUM_BITS)
        streamWriteUInt8(streamId, self.growthState)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    end
end

function EasyDevControlsVineSystemSetStateEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            local farmId = g_currentMission:getFarmId(connection)

            if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID then
                message, errorCode = g_easyDevControls:vineSystemSetState(self.placeableVine, self.fruitTypeIndex, self.growthState, farmId)

                EasyDevControlsLogging.dedicatedServerInfo(message)
            else
                errorCode = EasyDevControlsErrorCodes.INVALID_FARM
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsVineSystemSetStateEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsVineSystemSetStateEvent.newServerToClient(errorCode))
    else
        local infoText = string.format("%s: %s", EasyDevControlsUtils.getText("easyDevControls_vineSetStateTitle"), EasyDevControlsUtils.getText("easyDevControls_success"))
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsVineSystemSetStateEvent, self.errorCode, infoText)
    end
end
