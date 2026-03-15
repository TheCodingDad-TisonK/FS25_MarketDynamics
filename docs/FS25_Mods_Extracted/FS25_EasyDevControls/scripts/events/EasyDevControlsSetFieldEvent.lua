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

EasyDevControlsSetFieldEvent = {}

EasyDevControlsSetFieldEvent.NONE = 0
EasyDevControlsSetFieldEvent.FRUIT = 1
EasyDevControlsSetFieldEvent.GROUND = 2
EasyDevControlsSetFieldEvent.RICE = 3

EasyDevControlsSetFieldEvent.SEND_NUM_BITS = 2

local EasyDevControlsSetFieldEvent_mt = Class(EasyDevControlsSetFieldEvent, Event)
InitEventClass(EasyDevControlsSetFieldEvent, "EasyDevControlsSetFieldEvent")

function EasyDevControlsSetFieldEvent.emptyNew()
    return Event.new(EasyDevControlsSetFieldEvent_mt)
end

function EasyDevControlsSetFieldEvent.new(typeId, ...)
    local instance

    if typeId == EasyDevControlsSetFieldEvent.FRUIT then
        instance = EasyDevControlsSetFieldEvent.newSetFruit(...)
    elseif typeId == EasyDevControlsSetFieldEvent.GROUND then
        instance = EasyDevControlsSetFieldEvent.newSetGround(...)
    elseif typeId == EasyDevControlsSetFieldEvent.RICE then
        instance = EasyDevControlsSetFieldEvent.newSetRice(...)
    else
        instance = EasyDevControlsSetFieldEvent.emptyNew()
        instance.typeId = EasyDevControlsSetFieldEvent.NONE
    end

    return instance
end

function EasyDevControlsSetFieldEvent.newSetFruit(fieldId, fruitTypeIndex, growthState, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland)
    local self = EasyDevControlsSetFieldEvent.emptyNew()

    self.typeId = EasyDevControlsSetFieldEvent.FRUIT
    self.fieldId = fieldId

    self.fruitTypeIndex = fruitTypeIndex
    self.growthState = growthState

    self.groundType = groundType
    self.sprayType = sprayType
    self.plowLevel = plowLevel
    self.sprayLevel = sprayLevel
    self.limeLevel = limeLevel
    self.weedState = weedState
    self.stoneLevel = stoneLevel
    self.rollerLevel = rollerLevel
    self.stubbleShredLevel = stubbleShredLevel

    self.clearHeightTypes = clearHeightTypes
    self.buyFarmland = buyFarmland

    return self
end

function EasyDevControlsSetFieldEvent.newSetGround(fieldId, groundAngle, removeFoliage, groundType, sprayType, plowLevel, sprayLevel, limeLevel, weedState, stoneLevel, rollerLevel, stubbleShredLevel, clearHeightTypes, buyFarmland)
    local self = EasyDevControlsSetFieldEvent.emptyNew()

    self.typeId = EasyDevControlsSetFieldEvent.GROUND
    self.fieldId = fieldId

    self.groundAngle = groundAngle
    self.removeFoliage = removeFoliage

    self.groundType = groundType
    self.sprayType = sprayType
    self.plowLevel = plowLevel
    self.sprayLevel = sprayLevel
    self.limeLevel = limeLevel
    self.weedState = weedState
    self.stoneLevel = stoneLevel
    self.rollerLevel = rollerLevel
    self.stubbleShredLevel = stubbleShredLevel

    self.clearHeightTypes = clearHeightTypes
    self.buyFarmland = buyFarmland

    return self
end

function EasyDevControlsSetFieldEvent.newSetRice(placeable, fieldIndex, fruitTypeIndex, growthState, groundAngle, waterLevel)
    local self = EasyDevControlsSetFieldEvent.emptyNew()

    self.typeId = EasyDevControlsSetFieldEvent.RICE

    self.placeable = placeable
    self.fieldIndex = fieldIndex

    self.fruitTypeIndex = fruitTypeIndex
    self.growthState = growthState

    self.groundAngle = groundAngle
    self.waterLevel = waterLevel

    return self
end

function EasyDevControlsSetFieldEvent.newServerToClient(errorCode, typeId, multipleFields, value)
    local self = EasyDevControlsSetFieldEvent.emptyNew()

    self.errorCode = EasyDevControlsErrorCodes.getValidErrorCode(errorCode, EasyDevControlsErrorCodes.UNKNOWN_FAIL)
    self.typeId = typeId or EasyDevControlsSetFieldEvent.NONE

    self.multipleFields = multipleFields == true
    self.value = value or 0

    return self
end

function EasyDevControlsSetFieldEvent:readStream(streamId, connection)
    self.typeId = streamReadUIntN(streamId, EasyDevControlsSetFieldEvent.SEND_NUM_BITS)

    if not connection:getIsServer() then
        if self.typeId ~= EasyDevControlsSetFieldEvent.NONE then
            if self.typeId ~= EasyDevControlsSetFieldEvent.RICE then
                self.fieldId = streamReadUIntN(streamId, g_farmlandManager.numberOfBits)

                if self.typeId == EasyDevControlsSetFieldEvent.FRUIT then
                    self.fruitTypeIndex = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)
                    self.growthState = streamReadUInt8(streamId)
                else
                    self.groundAngle = NetworkUtil.readCompressedAngle(streamId)
                    self.removeFoliage = streamReadBool(streamId)
                end

                self.groundType = streamReadUInt8(streamId)
                self.sprayType = streamReadUInt8(streamId)
                self.plowLevel = streamReadUInt8(streamId)
                self.sprayLevel = streamReadUInt8(streamId)
                self.limeLevel = streamReadUInt8(streamId)
                self.weedState = streamReadUInt8(streamId)
                self.stoneLevel = streamReadUInt8(streamId)
                self.rollerLevel = streamReadUInt8(streamId)
                self.stubbleShredLevel = streamReadUInt8(streamId)

                self.clearHeightTypes = streamReadBool(streamId)
                self.buyFarmland = streamReadBool(streamId)
            else
                self.placeable = NetworkUtil.readNodeObject(streamId)
                self.fieldIndex = streamReadUInt8(streamId)

                self.fruitTypeIndex = streamReadUIntN(streamId, FruitTypeManager.SEND_NUM_BITS)
                self.growthState = streamReadUInt8(streamId)

                self.groundAngle = NetworkUtil.readCompressedAngle(streamId)
                self.waterLevel = streamReadUInt8(streamId)
            end
        end
    else
        self.errorCode = EasyDevControlsErrorCodes.readStream(streamId)

        self.multipleFields = streamReadBool(streamId)
        self.value = streamReadInt32(streamId)
    end

    self:run(connection)
end

function EasyDevControlsSetFieldEvent:writeStream(streamId, connection)
    streamWriteUIntN(streamId, self.typeId, EasyDevControlsSetFieldEvent.SEND_NUM_BITS)

    if connection:getIsServer() then
        if self.typeId ~= EasyDevControlsSetFieldEvent.NONE then
            if self.typeId ~= EasyDevControlsSetFieldEvent.RICE then
                streamWriteUIntN(streamId, self.fieldId, g_farmlandManager.numberOfBits)

                if self.typeId == EasyDevControlsSetFieldEvent.FRUIT then
                    streamWriteUIntN(streamId, self.fruitTypeIndex, FruitTypeManager.SEND_NUM_BITS)
                    streamWriteUInt8(streamId, self.growthState)
                else
                    NetworkUtil.writeCompressedAngle(streamId, self.groundAngle)
                    streamWriteBool(streamId, self.removeFoliage)
                end

                streamWriteUInt8(streamId, self.groundType)
                streamWriteUInt8(streamId, self.sprayType)
                streamWriteUInt8(streamId, self.plowLevel)
                streamWriteUInt8(streamId, self.sprayLevel)
                streamWriteUInt8(streamId, self.limeLevel)
                streamWriteUInt8(streamId, self.weedState)
                streamWriteUInt8(streamId, self.stoneLevel)
                streamWriteUInt8(streamId, self.rollerLevel)
                streamWriteUInt8(streamId, self.stubbleShredLevel)

                streamWriteBool(streamId, self.clearHeightTypes)
                streamWriteBool(streamId, self.buyFarmland)
            else
                NetworkUtil.writeNodeObject(streamId, self.placeable)
                streamWriteUInt8(streamId, self.fieldIndex)

                streamWriteUIntN(streamId, self.fruitTypeIndex, FruitTypeManager.SEND_NUM_BITS)
                streamWriteUInt8(streamId, self.growthState)

                NetworkUtil.writeCompressedAngle(streamId, self.groundAngle)
                streamWriteUInt8(streamId, self.waterLevel)
            end
        end
    else
        EasyDevControlsErrorCodes.writeStream(streamId, self.errorCode)

        streamWriteBool(streamId, self.multipleFields)
        streamWriteInt32(streamId, self.value)
    end
end

function EasyDevControlsSetFieldEvent:run(connection)
    if not connection:getIsServer() then
        local message, errorCode, value = nil, nil, nil

        if g_easyDevControls ~= nil then
            local typeId = self.typeId

            if typeId ~= EasyDevControlsSetFieldEvent.NONE then
                local farmId = g_currentMission:getFarmId(connection)

                if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID then
                    if typeId == EasyDevControlsSetFieldEvent.FRUIT then
                        message, errorCode, value = g_easyDevControls:setFieldFruit(self.fieldId, self.fruitTypeIndex, self.growthState, self.groundType, self.sprayType, self.plowLevel, self.sprayLevel, self.limeLevel, self.weedState, self.stoneLevel, self.rollerLevel, self.stubbleShredLevel, self.clearHeightTypes, self.buyFarmland, farmId)
                    elseif typeId == EasyDevControlsSetFieldEvent.GROUND then
                        message, errorCode, value = g_easyDevControls:setFieldGround(self.fieldId, self.groundAngle, self.removeFoliage, self.groundType, self.sprayType, self.plowLevel, self.sprayLevel, self.limeLevel, self.weedState, self.stoneLevel, self.rollerLevel, self.stubbleShredLevel, self.clearHeightTypes, self.buyFarmland, farmId)
                    elseif typeId == EasyDevControlsSetFieldEvent.RICE then
                        message, errorCode, value = g_easyDevControls:setRiceField(self.placeable, self.fieldIndex, self.fruitTypeIndex, self.growthState, self.groundAngle, self.waterLevel)
                    end

                    if g_dedicatedServer ~= nil and message ~= nil then
                        print(string.format("  Info: %s (%s) (%d)", message, farmId, typeId))
                    end
                else
                    errorCode = EasyDevControlsErrorCodes.INVALID_FARM
                end
            end
        else
            EasyDevControlsLogging.devError("EasyDevControlsSetFieldEvent - g_easyDevControls is nil!")
        end

        connection:sendEvent(EasyDevControlsSetFieldEvent.newServerToClient(errorCode, self.typeId, self.fieldId == 0, value))
    else
        local infoText = ""

        if self.errorCode ~= EasyDevControlsErrorCodes.FAILED then
            if self.typeId ~= EasyDevControlsSetFieldEvent.RICE then
                infoText = EasyDevControlsUtils.formatText(multipleFields and "easyDevControls_setAllFieldSuccessInfo" or "easyDevControls_setFieldSuccessInfo", tostring(self.value))
            else
                infoText = EasyDevControlsUtils.formatText("easyDevControls_setFieldSuccessInfo", "(" .. g_i18n:getText("fillType_rice") .. ")")
            end
        else
            infoText = EasyDevControlsUtils.getText("easyDevControls_setFieldFailedInfo")
        end

        g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_SERVER_REQUEST_COMPLETED, 2, EasyDevControlsSetFieldEvent, self.errorCode, infoText, true) -- Force the field failed text
    end
end
