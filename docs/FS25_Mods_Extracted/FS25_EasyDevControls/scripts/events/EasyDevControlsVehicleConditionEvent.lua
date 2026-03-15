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

EasyDevControlsVehicleConditionEvent = {}

EasyDevControlsVehicleConditionEvent.TYPE_NONE = 0
EasyDevControlsVehicleConditionEvent.TYPE_DIRT = 1
EasyDevControlsVehicleConditionEvent.TYPE_WET = 2
EasyDevControlsVehicleConditionEvent.TYPE_WEAR = 3
EasyDevControlsVehicleConditionEvent.TYPE_DAMAGE = 4
EasyDevControlsVehicleConditionEvent.TYPE_ALL = 5

EasyDevControlsVehicleConditionEvent.SEND_NUM_BITS = 3

local EasyDevControlsVehicleConditionEvent_mt = Class(EasyDevControlsVehicleConditionEvent, Event)
InitEventClass(EasyDevControlsVehicleConditionEvent, "EasyDevControlsVehicleConditionEvent")

function EasyDevControlsVehicleConditionEvent.emptyNew()
    return Event.new(EasyDevControlsVehicleConditionEvent_mt)
end

function EasyDevControlsVehicleConditionEvent.new(vehicle, isEntered, typeId, setToAmount, amount)
    local self = EasyDevControlsVehicleConditionEvent.emptyNew()

    self.vehicle = vehicle

    self.isEntered = isEntered
    self.typeId = typeId

    self.setToAmount = setToAmount
    self.amount = amount

    return self
end

function EasyDevControlsVehicleConditionEvent.newServerToClient(errorCode)
    local self = EasyDevControlsVehicleConditionEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsVehicleConditionEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.vehicle = NetworkUtil.readNodeObject(streamId)

        self.isEntered = streamReadBool(streamId)
        self.typeId = streamReadUIntN(streamId, EasyDevControlsVehicleConditionEvent.SEND_NUM_BITS)

        self.setToAmount = streamReadBool(streamId)
        self.amount = streamReadInt8(streamId) / 100
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsVehicleConditionEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.vehicle)

        streamWriteBool(streamId, self.isEntered)
        streamWriteUIntN(streamId, self.typeId, EasyDevControlsVehicleConditionEvent.SEND_NUM_BITS)

        streamWriteBool(streamId, self.setToAmount)
        streamWriteInt8(streamId, self.amount * 100)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode or EasyDevControlsErrorCodes.NONE)
    end
end

function EasyDevControlsVehicleConditionEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            message, errorCode = g_easyDevControls:setVehicleCondition(self.vehicle, self.isEntered, self.typeId, self.setToAmount, self.amount)

            if self.setToAmount then
                EasyDevControlsLogging.dedicatedServerInfo(message) -- Only for 'setToAmount' so the log is no full of prints
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsVehicleConditionEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsVehicleConditionEvent.newServerToClient(errorCode))
    else
        local infoText = EasyDevControlsUtils.getText("easyDevControls_success") -- TO_DO: Add detailed reply
        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsVehicleConditionEvent, self.errorCode, infoText)
    end
end

function EasyDevControlsVehicleConditionEvent.getTypeTexts()
    return {
        EasyDevControlsUtils.getText("easyDevControls_vehicleDirt"),
        EasyDevControlsUtils.getText("easyDevControls_vehicleWetness"),
        EasyDevControlsUtils.getText("easyDevControls_vehicleWear"),
        EasyDevControlsUtils.getText("easyDevControls_vehicleDamage"),
        EasyDevControlsUtils.getText("easyDevControls_all")
    }
end
