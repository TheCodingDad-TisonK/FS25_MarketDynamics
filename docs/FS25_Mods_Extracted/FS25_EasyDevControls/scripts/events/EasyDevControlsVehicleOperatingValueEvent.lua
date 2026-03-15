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

EasyDevControlsVehicleOperatingValueEvent = {}

EasyDevControlsVehicleOperatingValueEvent.FUEL = 0
EasyDevControlsVehicleOperatingValueEvent.MOTOR_TEMP = 1
EasyDevControlsVehicleOperatingValueEvent.OPERATING_TIME = 2

local EasyDevControlsVehicleOperatingValueEvent_mt = Class(EasyDevControlsVehicleOperatingValueEvent, Event)
InitEventClass(EasyDevControlsVehicleOperatingValueEvent, "EasyDevControlsVehicleOperatingValueEvent")

function EasyDevControlsVehicleOperatingValueEvent.emptyNew()
    local self = Event.new(EasyDevControlsVehicleOperatingValueEvent_mt)

    return self
end

function EasyDevControlsVehicleOperatingValueEvent.new(vehicle, typeId, value)
    local self = EasyDevControlsVehicleOperatingValueEvent.emptyNew()

    self.vehicle = vehicle
    self.typeId = typeId
    self.value = value

    return self
end

function EasyDevControlsVehicleOperatingValueEvent.newServerToClient(errorCode, vehicle, typeId, value)
    local self = EasyDevControlsVehicleOperatingValueEvent.new(vehicle, typeId, value)

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    return self
end

function EasyDevControlsVehicleOperatingValueEvent:readStream(streamId, connection)
    if connection:getIsServer() then
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
    end

    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.typeId = streamReadUIntN(streamId, 2)
    self.value = streamReadFloat32(streamId)

    self:run(connection)
end

function EasyDevControlsVehicleOperatingValueEvent:writeStream(streamId, connection)
    if not connection:getIsServer() then
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)
    end

    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    streamWriteUIntN(streamId, self.typeId, 2)
    streamWriteFloat32(streamId, self.value)
end

function EasyDevControlsVehicleOperatingValueEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            if self.typeId == EasyDevControlsVehicleOperatingValueEvent.FUEL then
                message, errorCode = g_easyDevControls:setVehicleFuel(self.vehicle, self.value)
            elseif self.typeId == EasyDevControlsVehicleOperatingValueEvent.MOTOR_TEMP then
                message, errorCode = g_easyDevControls:setVehicleMotorTemperature(self.vehicle, self.value)
            elseif self.typeId == EasyDevControlsVehicleOperatingValueEvent.OPERATING_TIME then
                message, errorCode = g_easyDevControls:setVehicleOperatingTime(self.vehicle, self.value)

                g_server:broadcastEvent(EasyDevControlsVehicleOperatingValueEvent.newServerToClient(EasyDevControlsErrorCodes.NONE, self.vehicle, EasyDevControlsVehicleOperatingValueEvent.OPERATING_TIME, self.value), false, connection)
            end

            EasyDevControlsLogging.dedicatedServerInfo(message)
        else
            EasyDevControlsLogging.devError("EasyDevControlsVehicleOperatingValueEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsVehicleOperatingValueEvent.newServerToClient(errorCode, self.vehicle, self.typeId, self.value))
    else
        if self.typeId == EasyDevControlsVehicleOperatingValueEvent.OPERATING_TIME then
            if (self.vehicle ~= nil and self.vehicle.setOperatingTime ~= nil) and self.value ~= nil then
                self.vehicle:setOperatingTime(self.value * 1000 * 60 * 60)
            end
        end

        if self.errorCode ~= EasyDevControlsErrorCodes.NONE then
            g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsVehicleOperatingValueEvent, self.errorCode, EasyDevControlsVehicleOperatingValueEvent.getInfoText(self.vehicle, self.typeId, self.value, self.errorCode))
        end
    end
end

function EasyDevControlsVehicleOperatingValueEvent.getInfoText(vehicle, typeId, value, errorCode)
    if errorCode ~= EasyDevControlsErrorCodes.SUCCESS then
        return ""
    end

    if vehicle ~= nil and typeId ~= nil and value ~= nil then
        if typeId == EasyDevControlsVehicleOperatingValueEvent.MOTOR_TEMP then
            return EasyDevControlsUtils.formatText("easyDevControls_vehicleMotorTempInfo", vehicle:getFullName(), value)
        elseif typeId == EasyDevControlsVehicleOperatingValueEvent.OPERATING_TIME then
            return EasyDevControlsUtils.formatText("easyDevControls_vehicleOperatingTimeInfo", vehicle:getFullName(), Enterable.getFormattedOperatingTime(vehicle))
        end
    end

    return EasyDevControlsUtils.getText("easyDevControls_success")
end
