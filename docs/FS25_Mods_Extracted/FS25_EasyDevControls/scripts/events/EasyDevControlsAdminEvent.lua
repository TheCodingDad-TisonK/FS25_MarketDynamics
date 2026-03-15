--[[
Copyright (C) GtX (Andy), 2024

Author: GtX | Andy
Date: 04.12.2024
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

EasyDevControlsAdminEvent = {}

EasyDevControlsAdminEvent.NOT_SUPPORTED = 0
EasyDevControlsAdminEvent.ACCESS_GRANTED = 1
EasyDevControlsAdminEvent.ACCESS_DENIED = 2
EasyDevControlsAdminEvent.CHANGED_PASSWORD = 3

EasyDevControlsAdminEvent.sendNumBits = 2

local EasyDevControlsAdminEvent_mt = Class(EasyDevControlsAdminEvent, Event)
InitEventClass(EasyDevControlsAdminEvent, "EasyDevControlsAdminEvent")

function EasyDevControlsAdminEvent.emptyNew()
    return Event.new(EasyDevControlsAdminEvent_mt)
end

function EasyDevControlsAdminEvent.new(loggingOut, adminPassword, changingPassword)
    local self = EasyDevControlsAdminEvent.emptyNew()

    self.loggingOut = loggingOut
    self.adminPassword = adminPassword or ""
    self.changingPassword = changingPassword

    return self
end

function EasyDevControlsAdminEvent.newServerToClient(accessState)
    local self = EasyDevControlsAdminEvent.emptyNew()

    self.accessState = accessState

    return self
end

function EasyDevControlsAdminEvent:readStream(streamId, connection)
    if not connection:getIsServer() then
        self.loggingOut = streamReadBool(streamId)

        if not self.loggingOut then
            self.adminPassword = streamReadString(streamId)
            self.changingPassword = streamReadBool(streamId)
        end

        if g_currentMission:getIsServer() then
            local accessState = EasyDevControlsAdminEvent.NOT_SUPPORTED

            if g_dedicatedServer ~= nil then
                local guiManager = g_easyDevControlsGuiManager
                local user, nickname = g_currentMission.userManager:getUserByConnection(connection), "Unknown"

                if user ~= nil then
                    nickname = user:getNickname() or ""
                end

                if self.loggingOut then
                    guiManager.connectionToMasterUser[connection] = nil

                    EasyDevControlsLogging.info("User %s has been logged out as master user.", nickname)

                    return
                end

                local adminPassword = guiManager.adminPassword

                if string.isNilOrWhitespace(adminPassword) then
                    adminPassword = g_dedicatedServer.adminPassword or ""
                end

                if not self.changingPassword then
                    if adminPassword == self.adminPassword then
                        guiManager.connectionToMasterUser[connection] = user

                        accessState = EasyDevControlsAdminEvent.ACCESS_GRANTED

                        EasyDevControlsLogging.info("User %s has logged in as master user.", nickname)
                    else
                        accessState = EasyDevControlsAdminEvent.ACCESS_DENIED
                    end
                else
                    accessState = EasyDevControlsAdminEvent.CHANGED_PASSWORD
                    guiManager.adminPassword = self.adminPassword

                    EasyDevControlsLogging.info("EDC admin password has been changed by %s.  Note: Game must be saved for new password to be active on next load.", nickname)
                end
            end

            connection:sendEvent(EasyDevControlsAdminEvent.newServerToClient(accessState))
        end
    else
        self.accessState = streamReadUIntN(streamId, EasyDevControlsAdminEvent.sendNumBits)
        g_messageCenter:publish(EasyDevControlsAdminEvent, self.accessState)
    end
end

function EasyDevControlsAdminEvent:writeStream(streamId, connection)
    if connection:getIsServer() then
        if not streamWriteBool(streamId, self.loggingOut) then
            streamWriteString(streamId, self.adminPassword)
            streamWriteBool(streamId, self.changingPassword)
        end
    else
        streamWriteUIntN(streamId, self.accessState, EasyDevControlsAdminEvent.sendNumBits)
    end
end

function EasyDevControlsAdminEvent:run(connection)
end
