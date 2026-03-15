cmVehicle = {}

-- @doc Set mapping between savegame vehicle id and vehicle network id when vehicle is saved
function cmVehicle:pre_saveToXMLFile(xmlFile, key, usedModNames)
  if ContractorMod.debug then print("cmVehicle:pre_saveToXMLFile") end
  -- key is something like vehicles.vehicle(saveId)
  local saveId = 1 + tonumber(string.sub(key, string.find(key, '(', 1, true) + 1, string.find(key, ')', 1, true) - 1))
  if SpecializationUtil.hasSpecialization(Enterable, self.specializations) then
    cmVehicle:mapVehicleSave(self, tostring(saveId))
  end
end
Vehicle.saveToXMLFile = Utils.prependedFunction(Vehicle.saveToXMLFile, cmVehicle.pre_saveToXMLFile)

-- @doc store savegame vehicle id if worker is in this vehicle
function cmVehicle:mapVehicleSave(vehicle, saveId)
  if ContractorMod.debug then print("cmVehicle:mapVehicleSave") end
  if ContractorMod.workers ~= nil then
    if #ContractorMod.workers > 0 then
      for i = 1, ContractorMod.numWorkers do
        local worker = ContractorMod.workers[i]
        if worker ~= nil then
          local currentVehicle = ContractorMod:getWorkerVehicle(worker)
          if currentVehicle ~= nil and vehicle == currentVehicle then
            -- store savegame vehicle id 
            worker.saveId = saveId
          end
        end
      end
    end
  end
end
