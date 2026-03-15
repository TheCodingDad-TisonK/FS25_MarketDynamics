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

EasyDevControlsPermissionsEvent = {}

EasyDevControlsPermissionsEvent.SEND_NUM_BITS = 6
EasyDevControlsPermissionsEvent.EMPTY_TABLE = {}

local EasyDevControlsPermissionsEvent_mt = Class(EasyDevControlsPermissionsEvent, Event)
InitEventClass(EasyDevControlsPermissionsEvent, "EasyDevControlsPermissionsEvent")

function EasyDevControlsPermissionsEvent.emptyNew()
    return Event.new(EasyDevControlsPermissionsEvent_mt)
end

function EasyDevControlsPermissionsEvent.new(permissions, suppressInfo)
    local self = EasyDevControlsPermissionsEvent.emptyNew()

    self.permissions = permissions
    self.suppressInfo = suppressInfo

    return self
end

function EasyDevControlsPermissionsEvent:readStream(streamId, connection)
    local guiManager = g_easyDevControlsGuiManager
    local permissionName, accessLevel = "unknown", EasyDevControlsAccessLevel.EDC_ADMIN

    local suppressInfo = streamReadBool(streamId)
    local numPermissions = streamReadUIntN(streamId, EasyDevControlsPermissionsEvent.SEND_NUM_BITS)

    self.permissions = table.create(numPermissions)

    for i = 1, numPermissions do
        permissionName = streamReadString(streamId)
        accessLevel = EasyDevControlsAccessLevel.readStream(streamId)

        table.insert(self.permissions, {
            name = permissionName,
            accessLevel = accessLevel
        })

        guiManager:setPermissionAccessLevel(permissionName, accessLevel, suppressInfo)
    end

    g_messageCenter:publishDelayedAfterFrames(MessageType.EDC_PERMISSIONS_CHANGED, 2)

    if not connection:getIsServer() then
        self.suppressInfo = suppressInfo
        g_server:broadcastEvent(self, false, connection)
    elseif not guiManager.gameStarted then
        EasyDevControlsLogging.devInfo("Synced %d permissions with server.", numPermissions)
    end
end

function EasyDevControlsPermissionsEvent:writeStream(streamId, connection)
    local permission = nil
    local numPermissions = #self.permissions

    streamWriteBool(streamId, self.suppressInfo)
    streamWriteUIntN(streamId, numPermissions, EasyDevControlsPermissionsEvent.SEND_NUM_BITS)

    for i = 1, numPermissions do
        permission = self.permissions[i]

        streamWriteString(streamId, permission.name)
        EasyDevControlsAccessLevel.writeStream(streamId, permission.accessLevel)
    end
end

function EasyDevControlsPermissionsEvent:run(connection)
    print("Error: EasyDevControlsPermissionsEvent is not allowed to be executed on a local client")
end

function EasyDevControlsPermissionsEvent.sendEvent(permissions, suppressInfo, noEventSend)
    if noEventSend == nil or noEventSend == false then
        permissions = Utils.getNoNil(permissions, EasyDevControlsPermissionsEvent.EMPTY_TABLE)
        suppressInfo = Utils.getNoNil(suppressInfo, true)

        if g_server ~= nil then
            g_server:broadcastEvent(EasyDevControlsPermissionsEvent.new(permissions, suppressInfo), false)
        else
            g_client:getServerConnection():sendEvent(EasyDevControlsPermissionsEvent.new(permissions, suppressInfo))
        end
    end
end
