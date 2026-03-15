
-- @doc Will call dedicated save method
SavegameController.onSaveComplete = Utils.prependedFunction(SavegameController.onSaveComplete, function(self)
  if ContractorMod.debug then print("cmSavegameController:pre_onSaveComplete") end
  if ContractorMod.workers ~= nil then
    local xmlFile
    if fileExists(ContractorMod.ContractorModXmlFilePath) then
      xmlFile = XMLFile.load('ContractorMod', ContractorMod.ContractorModXmlFilePath, ContractorMod.xmlSchema)
    else
      xmlFile = XMLFile.create('ContractorMod', ContractorMod.ContractorModXmlFilePath, 'ContractorMod', ContractorMod.xmlSchema)
      xmlFile:save()
    end

    if xmlFile ~= nil then
      local rootXmlKey = "ContractorMod"      
      local workerKey = rootXmlKey .. ".workers"
      xmlFile:setInt(workerKey.."#numWorkers", ContractorMod.numWorkers)
      xmlFile:setBool(workerKey.."#enablePassenger", ContractorMod.enablePassenger)
      for i = 1, ContractorMod.numWorkers do
        local worker = ContractorMod.workers[i]
        local key = string.format(rootXmlKey .. ".workers.worker(%d)", i - 1)
        xmlFile:setString(key.."#name", worker.name)
        worker.playerStyle:saveToXMLFile(xmlFile, key .. ".style")
        local x, y, z = ContractorMod:getWorkerPosition(worker)
        local pos = Utils.getNoNil(x, "0.")..' '..Utils.getNoNil(y, "0.")..' '..Utils.getNoNil(z, "0.")
        xmlFile:setString(key.."#position", pos)
        local yaw = tostring(Utils.getNoNil(ContractorMod:getWorkerYaw(worker), "0.0"))
        xmlFile:setString(key.."#yaw", yaw)
        local vehicleID = "0"
        local currentVehicle = ContractorMod:getWorkerVehicle(worker)
        if currentVehicle ~= nil then
          vehicleID = worker.saveId
        end
        xmlFile:setString(key.."#vehicleID", Utils.getNoNil(vehicleID, "0"))
      end
      local xmlKey = rootXmlKey .. ".displaySettings.characterName"
      xmlFile:setFloat(xmlKey .. "#x", ContractorMod.displaySettings.characterName.x)
      xmlFile:setFloat(xmlKey .. "#y", ContractorMod.displaySettings.characterName.y)
      xmlFile:setFloat(xmlKey .. "#size", ContractorMod.displaySettings.characterName.size)
      xmlKey = rootXmlKey .. ".displaySettings.playerName"
      xmlFile:setBool(xmlKey .. "#displayPlayerNames", ContractorMod.displayPlayerNames)
      xmlFile:save()
      xmlFile:delete()
    end
  end
end)
