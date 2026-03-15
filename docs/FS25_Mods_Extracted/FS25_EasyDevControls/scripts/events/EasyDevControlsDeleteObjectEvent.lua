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

EasyDevControlsDeleteObjectEvent = {}
EasyDevControlsDeleteObjectEvent.NO_REPLY = true -- This event does not require an errorCode reply

local EasyDevControlsDeleteObjectEvent_mt = Class(EasyDevControlsDeleteObjectEvent, Event)
InitEventClass(EasyDevControlsDeleteObjectEvent, "EasyDevControlsDeleteObjectEvent")

function EasyDevControlsDeleteObjectEvent.emptyNew()
    return Event.new(EasyDevControlsDeleteObjectEvent_mt, NetworkNode.CHANNEL_MAIN)
end

function EasyDevControlsDeleteObjectEvent.new(typeId, object)
    local self = EasyDevControlsDeleteObjectEvent.emptyNew()

    self.typeId = typeId or EasyDevControlsObjectTypes.UNKNOWN
    self.object = object

    return self
end

function EasyDevControlsDeleteObjectEvent:readStream(streamId, connection)
    self.typeId = EasyDevControlsObjectTypes.readStream(streamId)

    if EasyDevControlsDeleteObjectEvent.getIsNodeObject(self.typeId) then
        self.object = NetworkUtil.readNodeObject(streamId)
    else
        self.object = readSplitShapeIdFromStream(streamId)
    end

    self:run(connection)
end

function EasyDevControlsDeleteObjectEvent:writeStream(streamId, connection)
    EasyDevControlsObjectTypes.writeStream(streamId, self.typeId)

    if EasyDevControlsDeleteObjectEvent.getIsNodeObject(self.typeId) then
        NetworkUtil.writeNodeObject(streamId, self.object)
    else
        writeSplitShapeIdToStream(streamId, self.object)
    end
end

function EasyDevControlsDeleteObjectEvent:run(connection)
    if g_easyDevControls ~= nil then
        if self.object ~= nil and self.typeId ~= EasyDevControlsObjectTypes.UNKNOWN then
            if not connection:getIsServer() then
                if self.typeId == EasyDevControlsObjectTypes.VEHICLE or self.typeId == EasyDevControlsObjectTypes.PALLET then
                    if self.object.rootNode ~= nil and entityExists(self.object.rootNode) then
                        self.object:delete()
                    end
                elseif self.typeId == EasyDevControlsObjectTypes.BALE then
                    if self.object.nodeId ~= nil and entityExists(self.object.nodeId) then
                        self.object:delete()
                    end
                else
                    local isLog = self.typeId == EasyDevControlsObjectTypes.LOG
                    local isTree = self.typeId == EasyDevControlsObjectTypes.TREE
                    local isStump = self.typeId == EasyDevControlsObjectTypes.STUMP

                    if (isLog or isTree or isStump) and self.object ~= 0 then
                        EasyDevControlsUtils.deleteTree(self.object, isTree, not isLog)
                    end
                end
            else
                EasyDevControlsLogging.error("EasyDevControlsDeleteObjectEvent is a client to server only event!")
            end
        end
    else
        EasyDevControlsLogging.devError("EasyDevControlsDeleteObjectEvent - g_easyDevControls is nil!")
    end
end

function EasyDevControlsDeleteObjectEvent.getIsNodeObject(typeId)
    return typeId == EasyDevControlsObjectTypes.VEHICLE or
           typeId == EasyDevControlsObjectTypes.PALLET or
           typeId == EasyDevControlsObjectTypes.BALE
end
