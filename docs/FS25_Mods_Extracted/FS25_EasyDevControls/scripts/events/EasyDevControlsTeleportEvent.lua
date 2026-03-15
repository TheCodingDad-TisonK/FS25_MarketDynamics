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

EasyDevControlsTeleportEvent = {}

local EasyDevControlsTeleportEvent_mt = Class(EasyDevControlsTeleportEvent, Event)
InitEventClass(EasyDevControlsTeleportEvent, "EasyDevControlsTeleportEvent")

function EasyDevControlsTeleportEvent.emptyNew()
    return Event.new(EasyDevControlsTeleportEvent_mt, NetworkNode.CHANNEL_MAIN)
end

function EasyDevControlsTeleportEvent.new(object, positionX, positionZ, rotationY, useWorldCoords)
    local self = EasyDevControlsTeleportEvent.emptyNew()

    self.object = object

    self.positionX = positionX
    self.positionZ = positionZ

    self.rotationY = rotationY
    self.useWorldCoords = useWorldCoords

    return self
end

function EasyDevControlsTeleportEvent.newServerToClient(errorCode, isField, positionX, positionZ, rotationY, useWorldCoords, isVehicle, numVehicles)
    local self = EasyDevControlsTeleportEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)

    self.isField = isField
    self.positionX = positionX
    self.positionZ = positionZ
    self.rotationY = rotationY
    self.useWorldCoords = useWorldCoords

    self.isVehicle = isVehicle
    self.numVehicles = numVehicles

    return self
end

function EasyDevControlsTeleportEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.object = NetworkUtil.readNodeObject(streamId)

        self.positionX = streamReadFloat32(streamId)

        if streamReadBool(streamId) then
            self.positionZ = streamReadFloat32(streamId)
            self.useWorldCoords = streamReadBool(streamId)
        end

        if streamReadBool(streamId) then
            self.rotationY = streamReadFloat32(streamId)
        end
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)

        if streamReadBool(streamId) then
            self.isField = streamReadBool(streamId)
            self.positionX = streamReadFloat32(streamId)

            if not self.isField then
                self.positionZ = streamReadFloat32(streamId)
                self.useWorldCoords = streamReadBool(streamId)
            end

            if streamReadBool(streamId) then
                self.rotationY = streamReadFloat32(streamId)
            end

            self.isVehicle = streamReadBool(streamId)

            if self.isVehicle then
                self.numVehicles = streamReadUInt8(streamId)
            end
        end
    end

    self:run(connection)
end

function EasyDevControlsTeleportEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        NetworkUtil.writeNodeObject(streamId, self.object)

        streamWriteFloat32(streamId, self.positionX)

        if streamWriteBool(streamId, self.positionZ ~= nil) then
            streamWriteFloat32(streamId, self.positionZ)
            streamWriteBool(streamId, self.useWorldCoords)
        end

        if streamWriteBool(streamId, self.rotationY ~= nil) then
            streamWriteFloat32(streamId, self.rotationY)
        end
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)

        if streamWriteBool(streamId, self.errorCode == EasyDevControlsErrorCodes.SUCCESS) then
            streamWriteBool(streamId, self.isField)
            streamWriteFloat32(streamId, self.positionX)

            if not self.isField then
                streamWriteFloat32(streamId, self.positionZ)
                streamWriteBool(streamId, self.useWorldCoords)
            end

            if streamWriteBool(streamId, self.rotationY ~= nil) then
                streamWriteFloat32(streamId, self.rotationY)
            end

            streamWriteBool(streamId, self.isVehicle)

            if self.isVehicle then
                streamWriteUInt8(streamId, self.numVehicles)
            end
        end
    end
end

function EasyDevControlsTeleportEvent:run(connection)
    if g_easyDevControls ~= nil then
        if not connection:getIsServer() then
            local message, errorCode, isVehicle, numVehicles, rotationY = g_easyDevControls:teleport(self.object, self.positionX, self.positionZ, self.rotationY, self.useWorldCoords)

            EasyDevControlsLogging.dedicatedServerInfo(message)
            connection:sendEvent(EasyDevControlsTeleportEvent.newServerToClient(errorCode, self.positionZ == nil, self.positionX, self.positionZ, rotationY, self.useWorldCoords, isVehicle, numVehicles))
        else
            local infoText = ""

            if self.errorCode == EasyDevControlsErrorCodes.SUCCESS then
                infoText = EasyDevControlsTeleportEvent.getInfoText(self.isField, self.positionX, self.positionZ, self.isVehicle, self.numVehicles, self.useWorldCoords)
            end

            if self.rotationY ~= nil and g_localPlayer ~= nil then
                g_localPlayer:setMovementYaw(self.rotationY) -- Correct the player rotation
            end

            g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsTeleportEvent, self.errorCode, infoText)
        end
    else
        EasyDevControlsLogging.devError("EasyDevControlsTeleportEvent - g_easyDevControls is nil!")
    end
end

function EasyDevControlsTeleportEvent.getInfoText(isField, positionX, positionZ, isVehicle, numVehicles, useWorldCoords)
    if isField then
        if isVehicle then
            return EasyDevControlsUtils.formatText("easyDevControls_teleportVehiclesFieldInfo", tostring(numVehicles), tostring(positionX))
        end

        return EasyDevControlsUtils.formatText("easyDevControls_teleportPlayerFieldInfo", tostring(positionX))
    end

    positionX = tostring(math.floor(positionX + 0.5))
    positionZ = tostring(math.floor(positionZ + 0.5))

    if useWorldCoords then
        positionZ = positionZ .. " (3D / World)"
    end

    if isVehicle then
        return EasyDevControlsUtils.formatText("easyDevControls_teleportVehiclesInfo", tostring(numVehicles), positionX, positionZ)
    end

    return EasyDevControlsUtils.formatText("easyDevControls_teleportPlayerInfo", positionX, positionZ)
end
