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

EasyDevControlsAddRemoveDeltaEvent = {}

local EasyDevControlsAddRemoveDeltaEvent_mt = Class(EasyDevControlsAddRemoveDeltaEvent, Event)
InitEventClass(EasyDevControlsAddRemoveDeltaEvent, "EasyDevControlsAddRemoveDeltaEvent")

function EasyDevControlsAddRemoveDeltaEvent.emptyNew()
    return Event.new(EasyDevControlsAddRemoveDeltaEvent_mt)
end

function EasyDevControlsAddRemoveDeltaEvent.new(isWeedSystem, fieldIndex, delta)
    local self = EasyDevControlsAddRemoveDeltaEvent.emptyNew()

    self.isWeedSystem = isWeedSystem

    self.fieldIndex = fieldIndex
    self.delta = delta

    return self
end

function EasyDevControlsAddRemoveDeltaEvent.newServerToClient(errorCode, isWeedSystem, fieldIndex, delta)
    local self = EasyDevControlsAddRemoveDeltaEvent.new(isWeedSystem, fieldIndex, delta)

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsAddRemoveDeltaEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.isWeedSystem = streamReadBool(streamId)

        self.fieldIndex = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
        self.delta = streamReadInt8(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)

        self.isWeedSystem = streamReadBool(streamId)

        self.fieldIndex = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)
        self.delta = streamReadInt8(streamId)
    end

    self:run(connection)
end

function EasyDevControlsAddRemoveDeltaEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteBool(streamId, self.isWeedSystem)

        streamWriteUIntN(streamId, self.fieldIndex, g_farmlandManager.numberOfBits)
        streamWriteInt8(streamId, self.delta)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)

        streamWriteBool(streamId, self.isWeedSystem)

        streamWriteUIntN(streamId, self.fieldIndex, g_farmlandManager.numberOfBits)
        streamWriteInt8(streamId, self.delta)
    end
end

function EasyDevControlsAddRemoveDeltaEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            if self.isWeedSystem then
                message, errorCode = g_easyDevControls:addRemoveWeedsDelta(self.fieldIndex, self.delta)
            else
                message, errorCode = g_easyDevControls:addRemoveStonesDelta(self.fieldIndex, self.delta)
            end

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsAddRemoveDeltaEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsAddRemoveDeltaEvent.newServerToClient(errorCode, self.isWeedSystem, self.fieldIndex, self.delta))
    else
        local infoText = EasyDevControlsAddRemoveDeltaEvent.getInfoText(self.isWeedSystem, self.fieldIndex, self.delta)

        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsAddRemoveDeltaEvent, self.errorCode, infoText)
    end
end

function EasyDevControlsAddRemoveDeltaEvent.getInfoText(isWeedSystem, fieldIndex, delta)
    local typeText = g_i18n:getText(isWeedSystem and "setting_weedsEnabled" or "setting_stonesEnabled")
    local fieldText = string.format("  ( %s %d )", g_i18n:getText("ui_fieldNo"), fieldIndex)

    if delta < 0 then
        return EasyDevControlsUtils.formatText("easyDevControls_removeWeedOrStoneDelta", typeText, tostring(math.abs(delta))) .. fieldText
    end

    return EasyDevControlsUtils.formatText("easyDevControls_addWeedOrStoneDelta", typeText, tostring(math.abs(delta))) .. fieldText
end



