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

EasyDevControlsSpawnObjectEvent = {}

local EasyDevControlsSpawnObjectEvent_mt = Class(EasyDevControlsSpawnObjectEvent, Event)
InitEventClass(EasyDevControlsSpawnObjectEvent, "EasyDevControlsSpawnObjectEvent")

function EasyDevControlsSpawnObjectEvent.emptyNew()
    return Event.new(EasyDevControlsSpawnObjectEvent_mt)
end

function EasyDevControlsSpawnObjectEvent.new(typeId, params)
    local self = EasyDevControlsSpawnObjectEvent.emptyNew()

    self.typeId = typeId or EasyDevControlsObjectTypes.UNKNOWN

    if self.typeId == EasyDevControlsObjectTypes.BALE then
        self.baleIndex = params.baleIndex
        self.fillTypeIndex = params.fillTypeIndex
        self.wrappingState = params.wrappingState

        self.ry = params.ry
        self.wrappingColor = params.wrappingColor
    elseif self.typeId == EasyDevControlsObjectTypes.PALLET then
        self.xmlFilename = params.xmlFilename
        self.fillTypeIndex = params.fillTypeIndex

        self.amountToAdd = params.amountToAdd
        self.ry = params.ry
    elseif self.typeId == EasyDevControlsObjectTypes.LOG then
        self.treeType = params.treeType

        self.length = params.length
        self.growthStateI = params.growthStateI

        self.rx = params.rx
        self.ry = params.ry
        self.rz = params.rz
    end

    self.x = params.x
    self.y = params.y
    self.z = params.z

    return self
end

function EasyDevControlsSpawnObjectEvent.newServerToClient(errorCode, typeId)
    local self = EasyDevControlsSpawnObjectEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)
    self.typeId = typeId or EasyDevControlsObjectTypes.UNKNOWN

    return self
end

function EasyDevControlsSpawnObjectEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.typeId = EasyDevControlsObjectTypes.readStream(streamId)

        if self.typeId == EasyDevControlsObjectTypes.BALE then
            self.baleIndex = streamReadUInt8(streamId)

            self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)
            self.wrappingState = streamReadUInt8(streamId) / 255

            self.ry = streamReadFloat32(streamId)

            if streamReadBool(streamId) then
                self.wrappingColor = {1, 1, 1, 1}

                self.wrappingColor[1] = streamReadFloat32(streamId)
                self.wrappingColor[2] = streamReadFloat32(streamId)
                self.wrappingColor[3] = streamReadFloat32(streamId)
            end
        elseif self.typeId == EasyDevControlsObjectTypes.PALLET then
            self.xmlFilename = NetworkUtil.convertFromNetworkFilename(streamReadString(streamId))
            self.fillTypeIndex = streamReadUIntN(streamId, FillTypeManager.SEND_NUM_BITS)

            if streamReadBool(streamId) then
                self.amountToAdd = streamReadFloat32(streamId)
            end

            self.ry = streamReadFloat32(streamId)
        elseif self.typeId == EasyDevControlsObjectTypes.LOG then
            self.treeType = streamReadInt32(streamId)

            self.length = streamReadInt8(streamId)
            self.growthStateI = streamReadInt8(streamId)

            self.rx = streamReadFloat32(streamId)
            self.ry = streamReadFloat32(streamId)
            self.rz = streamReadFloat32(streamId)
        end

        self.x = streamReadFloat32(streamId)
        self.y = streamReadFloat32(streamId)
        self.z = streamReadFloat32(streamId)
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)
        self.typeId = EasyDevControlsObjectTypes.readStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsSpawnObjectEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        EasyDevControlsObjectTypes.writeStream(streamId, self.typeId)

        if self.typeId == EasyDevControlsObjectTypes.BALE then
            streamWriteUInt8(streamId, self.baleIndex)

            streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)
            streamWriteUInt8(streamId, EasyDevControlsUtils.getNoNilClamp(self.wrappingState * 255, 0, 255, 0))

            streamWriteFloat32(streamId, self.ry)

            if streamWriteBool(streamId, self.wrappingColor ~= nil and #self.wrappingColor >= 3) then
                streamWriteFloat32(streamId, self.wrappingColor[1])
                streamWriteFloat32(streamId, self.wrappingColor[2])
                streamWriteFloat32(streamId, self.wrappingColor[3])
            end
        elseif self.typeId == EasyDevControlsObjectTypes.PALLET then
            streamWriteString(streamId, NetworkUtil.convertToNetworkFilename(self.xmlFilename))
            streamWriteUIntN(streamId, self.fillTypeIndex, FillTypeManager.SEND_NUM_BITS)

            if streamWriteBool(streamId, self.amountToAdd ~= nil) then
                streamWriteFloat32(streamId, self.amountToAdd)
            end

            streamWriteFloat32(streamId, self.ry)
        elseif self.typeId == EasyDevControlsObjectTypes.LOG then
            streamWriteInt32(streamId, self.treeType)

            streamWriteInt8(streamId, self.length)
            streamWriteInt8(streamId, self.growthStateI)

            streamWriteFloat32(streamId, self.rx)
            streamWriteFloat32(streamId, self.ry)
            streamWriteFloat32(streamId, self.rz)
        end

        streamWriteFloat32(streamId, self.x)
        streamWriteFloat32(streamId, self.y)
        streamWriteFloat32(streamId, self.z)
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)
        EasyDevControlsObjectTypes.writeStream(streamId, self.typeId)
    end
end

function EasyDevControlsSpawnObjectEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode = nil, nil

        if g_easyDevControls ~= nil then
            local player = g_currentMission:getPlayerByConnection(connection)

            if player ~= nil then
                local farmId = player.farmId

                if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID then
                    if self.typeId == EasyDevControlsObjectTypes.BALE then
                        message, errorCode = g_easyDevControls:spawnBale(self.baleIndex, self.fillTypeIndex, self.wrappingState, farmId, self.x, self.y, self.z, self.ry, nil, nil, self.wrappingColor)
                    elseif self.typeId == EasyDevControlsObjectTypes.PALLET then
                        message, errorCode = g_easyDevControls:spawnPallet(self.fillTypeIndex, self.xmlFilename, farmId, self.x, self.y, self.z, self.ry, self.amountToAdd, nil, connection)
                    elseif self.typeId == EasyDevControlsObjectTypes.LOG then
                        message, errorCode = g_easyDevControls:spawnLog(self.treeType, self.length, self.growthStateI, self.x, self.y, self.z, self.rx, self.ry, self.rz)
                    end

                    EasyDevControlsLogging.dedicatedServerInfo(message)
                else
                    errorCode = EasyDevControlsErrorCodes.INVALID_FARM
                end
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsSpawnObjectEvent - g_easyDevControls is nil!")
        end

        -- Pallets are loaded async so reply is handled directly
        if self.typeId ~= EasyDevControlsObjectTypes.PALLET or errorCode == EasyDevControlsErrorCodes.INVALID_FARM then
            connection:sendEvent(EasyDevControlsSpawnObjectEvent.newServerToClient(errorCode, self.typeId))
        end
    else
        local infoText = ""
        local resultL10n = self.errorCode == EasyDevControlsErrorCodes.SUCCESS and "easyDevControls_spawnObjectsInfo" or "easyDevControls_failedToSpawnObjectWarning"

        if self.typeId == EasyDevControlsObjectTypes.BALE then
            infoText = EasyDevControlsUtils.formatText(resultL10n, EasyDevControlsUtils.getText("easyDevControls_typeBale"))
        elseif self.typeId == EasyDevControlsObjectTypes.PALLET then
            infoText = EasyDevControlsUtils.formatText(resultL10n, EasyDevControlsUtils.getText("easyDevControls_typePallet"))
        elseif self.typeId == EasyDevControlsObjectTypes.LOG then
            infoText = EasyDevControlsUtils.formatText(resultL10n, EasyDevControlsUtils.getText("easyDevControls_typeLog"))
        end

        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsSpawnObjectEvent, self.errorCode, infoText, true)
    end
end
