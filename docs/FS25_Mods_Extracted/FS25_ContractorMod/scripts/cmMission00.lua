-- Manage first worker when loading savegame
Mission00.onStartMission = Utils.appendedFunction(Mission00.onStartMission, function()
    ContractorMod:init()
    -- DebugUtil.printTableRecursively(ContractorMod.workers, " ", 1, 3) 
    local firstWorker = ContractorMod.workers[1]
    if g_localPlayer and g_localPlayer ~= nil then
      g_localPlayer:teleportTo(firstWorker.x, firstWorker.y, firstWorker.z)
      if firstWorker.currentVehicle ~= nil then
        g_localPlayer:setSpawnVehicle(firstWorker.currentVehicle)
      end
    end
    for i, worker in pairs(ContractorMod.workers) do
      if i ~= 1 then
        if worker.currentVehicle == nil then
          local spot = NPCSpot.create(tostring(g_time), worker.npc, worker.x, worker.y, worker.z, 0, 0, 0, false) --g_npcManager:getAvailableSpot(npc)
          spot:activate()
          spot.isAvailable = true
          -- spot.needsSaving = true
          g_npcManager:addSpot(spot)
          worker.npc:setSpot(spot)
        else
          local currentVehicle = ContractorMod:getWorkerVehicle(worker)
          if currentVehicle ~= nil then
            print("Worker "..worker.name.." controlling vehicle")
            currentVehicle:setVehicleCharacter(worker.playerStyle)
          end
        end
      end
    end
end)

-- Display a warning message in the log when loading savegame
Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished, function()
    print("This is a development version of ContractorMod for FS25, which may and will contain errors, bugs.")
end)