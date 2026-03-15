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

EasyDevControlsMoneyEvent = {}

EasyDevControlsMoneyEvent.TYPES = {
    ADDMONEY = 0,
    REMOVEMONEY = 1,
    SETMONEY = 2
}

local EasyDevControlsMoneyEvent_mt = Class(EasyDevControlsMoneyEvent, Event)
InitEventClass(EasyDevControlsMoneyEvent, "EasyDevControlsMoneyEvent")

function EasyDevControlsMoneyEvent.emptyNew()
    local self = Event.new(EasyDevControlsMoneyEvent_mt)

    return self
end

function EasyDevControlsMoneyEvent.new(amount, typeId)
    local self = EasyDevControlsMoneyEvent.emptyNew()

    self.amount = amount
    self.typeId = typeId

    return self
end

function EasyDevControlsMoneyEvent.newServerToClient(errorCode, amount, typeId)
    local self = EasyDevControlsMoneyEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    self.amount = amount
    self.typeId = typeId

    return self
end

function EasyDevControlsMoneyEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.amount = streamReadInt32(streamId)
        self.typeId = streamReadUIntN(streamId, 2)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
        self.amount = streamReadInt32(streamId)
        self.typeId = streamReadUIntN(streamId, 2)
    end

    self:run(connection)
end

function EasyDevControlsMoneyEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        streamWriteInt32(streamId, self.amount)
        streamWriteUIntN(streamId, self.typeId, 2)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)
        streamWriteInt32(streamId, self.amount)
        streamWriteUIntN(streamId, self.typeId, 2)
    end
end

function EasyDevControlsMoneyEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            local player = g_currentMission:getPlayerByConnection(connection)

            if player ~= nil then
                local farmId = player.farmId

                if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID then
                    message, errorCode = g_easyDevControls:cheatMoney(self.amount, self.typeId, farmId)

                    if g_dedicatedServer ~= nil and message ~= nil then
                        print(string.format("  Info: %s (%s)", message, farmId))
                    end
                end
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsMoneyEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsMoneyEvent.newServerToClient(errorCode, self.amount, self.typeId))
    else
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsMoneyEvent, self.errorCode, EasyDevControlsMoneyEvent.getInfoText(self.typeId, self.amount))
    end
end

function EasyDevControlsMoneyEvent.getTypeByName(name)
    return EasyDevControlsMoneyEvent.TYPES[name ~= nil and name:upper()]
end

function EasyDevControlsMoneyEvent.getInfoText(typeId, amount)
    local amount = g_i18n:formatMoney(amount or 0, 0, true, true)

    if typeId == EasyDevControlsMoneyEvent.TYPES.REMOVEMONEY then
        return EasyDevControlsUtils.formatText("easyDevControls_removeMoneyInfo", amount)
    elseif typeId == EasyDevControlsMoneyEvent.TYPES.SETMONEY then
        return EasyDevControlsUtils.formatText("easyDevControls_setMoneyInfo", amount)
    end

    return EasyDevControlsUtils.formatText("easyDevControls_addMoneyInfo", amount)
end
