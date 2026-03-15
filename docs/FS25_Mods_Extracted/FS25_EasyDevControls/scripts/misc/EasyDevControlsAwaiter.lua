--[[
Copyright (C) GtX (Andy), 2020

Author: GtX | Andy
Date: 03.09.2020
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

EasyDevControlsAwaiter = {}
EasyDevControlsAwaiter_mt = Class(EasyDevControlsAwaiter)

local NO_CALLBACK = function() end

function EasyDevControlsAwaiter.new(awaiter, callback, maxRunTime)
    local self = setmetatable({}, EasyDevControlsAwaiter_mt)
    local awaiterType = type(awaiter)

    if awaiterType == "function" then
        self.awaiter = awaiter
    else
        self.targetUpdateLoopIndex = g_updateLoopIndex + (awaiterType == "number" and awaiter or 1)
        self.awaiter = EasyDevControlsAwaiter.loopIndexAwaiter
    end

    self.maxRunTime = maxRunTime or 60000
    self.runTime = 0

    self.callback = callback or NO_CALLBACK
    self.enabled = true

    g_currentMission:addUpdateable(self)

    return self
end

function EasyDevControlsAwaiter:delete()
    self:cancel()
end

function EasyDevControlsAwaiter:update(dt)
    if self.enabled then
        if self.maxRunTime > 0 then
            self.runTime += dt

            if self.runTime >= self.maxRunTime then
                self.callback(EasyDevControlsErrorCodes.FAILED)
                self:cancel()

                return
            end
        end

        if self.awaiter() then
            self.callback(EasyDevControlsErrorCodes.SUCCESS)
            self:cancel()
        end
    end
end

function EasyDevControlsAwaiter:cancel()
    self.enabled = false
    self.runTime = 0

    if g_currentMission ~= nil then
        g_currentMission:removeUpdateable(self)
    end
end

function EasyDevControlsAwaiter:hasReachedTarget()
    return self.awaiter()
end

function EasyDevControlsAwaiter.loopIndexAwaiter(self)
    return g_updateLoopIndex >= (self.targetUpdateLoopIndex or 0)
end
