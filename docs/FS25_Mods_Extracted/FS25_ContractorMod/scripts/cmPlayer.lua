cmPlayer = {}

function cmPlayer:onLeaveVehicle(superfunc, vehicle, noEventSend)
    if ContractorMod.debug then print("cmPlayer.onLeaveVehicle") end
    local currentVehicle = g_localPlayer:getCurrentVehicle()
    if currentVehicle then
        cmPlayer:ManageLeaveVehicle(currentVehicle)
    end
    superfunc(self, vehicle, noEventSend)
end
Player.leaveVehicle = Utils.overwrittenFunction(Player.leaveVehicle, cmPlayer.onLeaveVehicle)

-- @doc Make some checks before leaving a vehicle to manage passengers and hired worker
function cmPlayer:ManageLeaveVehicle(controlledVehicle)
    if ContractorMod.debug then print("cmPlayer:ManageLeaveVehicle") end
    
    if controlledVehicle ~= nil then
        if ContractorMod.shouldStopWorker then
            if controlledVehicle:getIsAIActive() then
                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, g_i18n:getText("ContractorMod_WORKER_STOP"))
                controlledVehicle:stopCurrentAIJob(AIMessageSuccessStoppedByUser.new())
            end
        end
    end

end

function cmPlayer:teleportToExitPoint(superfunc, vehicle, noEventSend)
    if ContractorMod.debug then print("cmPlayer:teleportToExitPoint") end
    -- printCallstack()
    -- Prevent to teleport to exit point when switching between workers
    if not ContractorMod.switching then
        superfunc(self, vehicle, noEventSend)
    end
end
Player.teleportToExitPoint = Utils.overwrittenFunction(Player.teleportToExitPoint, cmPlayer.teleportToExitPoint)

function cmPlayer:drawUIInfo(superfunc)
	if (ContractorMod.displayPlayerNames and not g_gui:getIsGuiVisible() and (not g_noHudModeEnabled and (g_gameSettings:getValue(GameSettings.SETTING.SHOW_MULTIPLAYER_NAMES) ))) then
        local x1, y1, z1 = getWorldTranslation(g_cameraManager:getActiveCamera())
        for i, worker in pairs(ContractorMod.workers) do
            if ContractorMod:getWorkerVehicle(worker) == nil and worker.index ~= ContractorMod.currentID and worker.npc ~= nil then
                local x, y, z = getTranslation(worker.npc.playerGraphics.graphicsRootNode)
                local diffX = x - x1
                local diffY = y - y1
                local diffZ = z - z1
                if MathUtil.vector3LengthSq(diffX, diffY, diffZ) <= 10000 then
                    local y = y + worker.npc.playerGraphics.nameTagOffsetY
                    Utils.renderTextAtWorldPosition(x, y, z, worker.name, getCorrectTextSize(0.02), 0)
                end
            end
        end
	end
end
Player.drawUIInfo = Utils.appendedFunction(Player.drawUIInfo, cmPlayer.drawUIInfo)
