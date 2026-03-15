ContractorMod = {}
ContractorMod.debug = false --true --

-- KO: Driver exists with passenger
local modDirectory = g_currentModDirectory
local modSettingsDir = g_modSettingsDirectory
local ContractorMod_mt = Class(ContractorMod)

function ContractorMod:new(mission, i18n, inputBinding, gui, soundManager, modDirectory, modName)
    --print("ContractorMod:new")
    local self = setmetatable({}, ContractorMod_mt)

    self.isServer = mission:getIsServer()
    self.isClient = mission:getIsClient()
    self.modDirectory = modDirectory
    self.modName = modName

    return self
end

function ContractorMod:delete()
    --print("ContractorMod:delete")

end
-- Create multiple players and add them to the PlayerSystem
--local player1 = Player.new(...)
--local player2 = Player.new(...)
--g_playerSystem:addPlayer(player1)
--g_playerSystem:addPlayer(player2)


-- Switch control
-- g_playerSystem:setLocalPlayer(player2) -- Now you control player2

---Called when the player clicks the Start button
function ContractorMod:onMissionStart(mission)
    print("ContractorMod:onMissionStart")

    self:init()
end

function ContractorMod:init()
  if ContractorMod.debug then print("ContractorMod:init()") end
    ContractorMod.currentID = 1
    ContractorMod.numWorkers = 2
    ContractorMod.workers = {}
    ContractorMod.shouldStopWorker = true
    ContractorMod.switching = false 
    ContractorMod.displayPlayerNames = true
    ContractorMod.enablePassenger = false

    self:registerXmlSchema()

    local savegameDir
    if g_currentMission.missionInfo.savegameDirectory then
      savegameDir = g_currentMission.missionInfo.savegameDirectory
    end
    if not savegameDir and g_careerScreen.currentSavegame and g_careerScreen.currentSavegame.savegameIndex then
      savegameDir = ('%ssavegame%d'):format(getUserProfileAppPath(), g_careerScreen.currentSavegame.savegameIndex)
    end
    if not savegameDir and g_currentMission.missionInfo.savegameIndex ~= nil then
      savegameDir = ('%ssavegame%d'):format(getUserProfileAppPath(), g_careerScreen.missionInfo.savegameIndex)
    end
    ContractorMod.savegameFolderPath = savegameDir
    ContractorMod.ContractorModXmlFilePath = ContractorMod.savegameFolderPath .. '/ContractorMod.xml'

    -- Try to load from savegame, else create default workers
    if not self:initFromSave() then
      if not self:initFromParameters() then
        table.insert(ContractorMod.workers, ContractorModWorker:new("Alex", 1, g_localPlayer.graphicsComponent:getStyle()))
        local brendaStyle = g_helperManager:getRandomHelperStyle()
        while brendaStyle:getIsMale() do
            brendaStyle = g_helperManager:getRandomHelperStyle()
        end
        table.insert(ContractorMod.workers, ContractorModWorker:new("Brenda", 2, brendaStyle))
        table.insert(ContractorMod.workers, ContractorModWorker:new("Chris", 3, g_helperManager:getRandomHelperStyle()))
        local davidStyle = g_helperManager:getRandomHelperStyle()
        while davidStyle:getIsMale() == false do
            davidStyle = g_helperManager:getRandomHelperStyle()
        end
        table.insert(ContractorMod.workers, ContractorModWorker:new("David", 4, davidStyle))
        local edStyle = g_helperManager:getRandomHelperStyle()
        while edStyle:getIsMale() == false do
            edStyle = g_helperManager:getRandomHelperStyle()
        end
        table.insert(ContractorMod.workers, ContractorModWorker:new("Ed", 5, edStyle))
        local franckStyle = g_helperManager:getRandomHelperStyle()
        while franckStyle:getIsMale() == false do
            franckStyle = g_helperManager:getRandomHelperStyle()
        end
        table.insert(ContractorMod.workers, ContractorModWorker:new("Franck", 6, franckStyle))
        local garyStyle = g_helperManager:getRandomHelperStyle()
        while garyStyle:getIsMale() == false do
            garyStyle = g_helperManager:getRandomHelperStyle()
        end
        table.insert(ContractorMod.workers, ContractorModWorker:new("Gary", 7, garyStyle))
        local henryStyle = g_helperManager:getRandomHelperStyle()
        while henryStyle:getIsMale() == false do
            henryStyle = g_helperManager:getRandomHelperStyle()
        end
        table.insert(ContractorMod.workers, ContractorModWorker:new("Henry", 8, henryStyle))
        ContractorMod.numWorkers = #ContractorMod.workers
        ContractorMod.displaySettings = {
            characterName = {
                x = 0.9828,
                y = 0.90,
                size = 0.024
            }
        }
      end
    end
    g_currentMission.nickname = ContractorMod.workers[ContractorMod.currentID].name
end

-- ===== ACCESSOR FUNCTIONS =====
-- These return live state for the active worker and stored state for others

-- Get current vehicle for a worker (live for active, stored for inactive)
function ContractorMod:getWorkerVehicle(worker)
  if worker.index == ContractorMod.currentID and g_localPlayer ~= nil then
    return g_localPlayer:getCurrentVehicle()
  end
  return worker.currentVehicle
end

-- Get position of a worker (live for active, stored for inactive)
function ContractorMod:getWorkerPosition(worker)
  if worker.index == ContractorMod.currentID and g_localPlayer ~= nil then
    return g_localPlayer:getPosition()
  end
  return worker.x, worker.y, worker.z
end

-- Get yaw (rotation) of a worker (live for active, stored for inactive)
function ContractorMod:getWorkerYaw(worker)
  if worker.index == ContractorMod.currentID and g_localPlayer ~= nil then
    return g_localPlayer:getGraphicalYaw()
  end
  return worker.yaw
end

-- Get seat in vehicle for a worker (live for active, stored for inactive)
function ContractorMod:getWorkerSeat(worker)
  if worker.index == ContractorMod.currentID and g_localPlayer ~= nil then
    local vehicle = g_localPlayer:getCurrentVehicle()
    if vehicle and vehicle.spec_enterable then
      return vehicle.spec_enterable.playerSeat or worker.currentSeat
    end
  end
  return worker.currentSeat
end

function ContractorMod:getWorkerFromNPC(npc)
  if ContractorMod.debug then print("ContractorMod:getWorkerFromNPC()") end
  if npc ~= nil then
    if string.sub(npc.name, 1, 6) == "HELPER" and string.len(npc.name) > 6 then
      local workerId = tonumber(string.sub(npc.name, 7))
      if workerId ~= nil then
        local worker = ContractorMod.workers[workerId]
        if worker ~= nil then
            return worker
        else
            print("Worker not found for id "..tostring(workerId))
        end
      else
        print("Invalid worker id in npc name "..npc.name)
      end
    else
      print("Not a worker npc "..npc.name)
    end
  end
end
-- ===== END ACCESSORS =====

function ContractorMod:initFromSave()
  if ContractorMod.debug then print("ContractorMod:initFromSave()") end
  -- Copy ContractorMod.xml from zip to modSettings dir
  ContractorMod:CopyContractorModXML()
  -- Minimal: load worker name, position, style from XML
  if ContractorMod.savegameFolderPath and ContractorMod.ContractorModXmlFilePath then
    createFolder(ContractorMod.savegameFolderPath)
    local xml
    if fileExists(ContractorMod.ContractorModXmlFilePath) then
      xml = XMLFile.load('ContractorMod', ContractorMod.ContractorModXmlFilePath, ContractorMod.xmlSchema)
    else
      xml = XMLFile.create('ContractorMod', ContractorMod.ContractorModXmlFilePath, 'ContractorMod', ContractorMod.xmlSchema)
      xml:save()
      xml:delete()
      return false
    end
    local num = xml:getInt("ContractorMod.workers#numWorkers") or 0
    for i = 1, num do
        local key = string.format("ContractorMod.workers.worker(%d)", i-1)
        local name = xml:getString(key.."#name")
        local pos = xml:getString(key.."#position")
        local yaw = xml:getString(key.."#yaw")
        local style = PlayerStyle.new()
        style:loadFromXMLFile(xml, key..".style")
        local worker = ContractorModWorker:new(name, i, style)
        if ContractorMod.debug then print(pos) end
      local posVector = string.getVector(pos)
      if ContractorMod.debug then print("posVector "..tostring(posVector)) end
      local rotVector = string.getVector(rot)
      worker.x = posVector[1]
      worker.y = posVector[2]
      worker.z = posVector[3]
      worker.yaw = tonumber(yaw) or 0.0
      local vehicleID = xml:getString(key.."#vehicleID")
      if vehicleID ~= "0" then
        if ContractorMod.mapVehicleLoad ~= nil then
          -- map savegame vehicle id and network id
          local saveId = ContractorMod.mapVehicleLoad[vehicleID]
          local vehicle = NetworkUtil.getObject(tonumber(saveId))
          if vehicle ~= nil then
            if ContractorMod.debug then print("ContractorMod: vehicle not nil") end
            worker.currentVehicle = vehicle
            local currentSeat = xml:getInt(key.."#currentSeat")
            if currentSeat ~= nil then
              worker.currentSeat = currentSeat
            end
          end
        end
      end
      table.insert(ContractorMod.workers, worker)
  end
    xmlKey = "ContractorMod.displaySettings.characterName"
    ContractorMod.displaySettings = {}
    ContractorMod.displaySettings.characterName = {}
    local x = xml:getFloat(xmlKey .. string.format("#x"))
    if x == nil then
      x = 0.9828
    end
    ContractorMod.displaySettings.characterName.x = x
    local y = xml:getFloat(xmlKey .. string.format("#y"))
    if y == nil then
      y = 0.90
    end
    ContractorMod.displaySettings.characterName.y = y
    local size = xml:getFloat(xmlKey .. string.format("#size"))
    if size == nil then
      size = 0.024
    end
    ContractorMod.displaySettings.characterName.size = size
    xmlKey = "ContractorMod.displaySettings.playerName"
    ContractorMod.displayPlayerNames = Utils.getNoNil(xml:getBool(xmlKey .. string.format("#displayPlayerNames")), true)
    ContractorMod.enablePassenger = Utils.getNoNil(xml:getBool("ContractorMod.workers#enablePassenger"), false)
    ContractorMod.numWorkers = #ContractorMod.workers
    xml:delete()
    return ContractorMod.numWorkers > 0
  end
end

function ContractorMod:initFromParameters()
  if ContractorMod.debug then print("ContractorMod:initFromParameters()") end
  -- Copy ContractorMod.xml from zip to modSettings dir
  ContractorMod:CopyContractorModXML()
  if modSettingsDir then
    local xmlFilePath = modSettingsDir .. "/ContractorMod.xml"
    local xmlFile;
    if fileExists(xmlFilePath) then
      xml = XMLFile.load('ContractorMod', xmlFilePath, ContractorMod.xmlSchema)
    else
      return false
    end
    print("file exists")
    local num = xml:getInt("ContractorMod.workers#numWorkers") or 0
    for i = 1, num do
      local key = string.format("ContractorMod.workers.worker(%d)", i-1)
      local name = xml:getString(key.."#name")
      -- local pos = xml:getString(key.."#position")
      -- local yaw = xml:getString(key.."#yaw")
      local style = PlayerStyle.new()
      style:loadFromXMLFile(xml, key..".style")
      local worker = ContractorModWorker:new(name, i, style)
      if ContractorMod.debug then print(pos) end
      -- local posVector = string.getVector(pos)
      -- if ContractorMod.debug then print("posVector "..tostring(posVector)) end
      -- local rotVector = string.getVector(rot)
      -- worker.x = posVector[1]
      -- worker.y = posVector[2]
      -- worker.z = posVector[3]
      -- worker.yaw = tonumber(yaw) or 0.0
      table.insert(ContractorMod.workers, worker)
    end
    xmlKey = "ContractorMod.displaySettings.characterName"
    ContractorMod.displaySettings = {}
    ContractorMod.displaySettings.characterName = {}
    local x = xml:getFloat(xmlKey .. string.format("#x"))
    if x == nil then
      x = 0.9828
    end
    ContractorMod.displaySettings.characterName.x = x
    local y = xml:getFloat(xmlKey .. string.format("#y"))
    if y == nil then
      y = 0.90
    end
    ContractorMod.displaySettings.characterName.y = y
    local size = xml:getFloat(xmlKey .. string.format("#size"))
    if size == nil then
      size = 0.024
    end
    ContractorMod.displaySettings.characterName.size = size
    xmlKey = "ContractorMod.displaySettings.playerName"
    ContractorMod.displayPlayerNames = Utils.getNoNil(xml:getBool(xmlKey .. string.format("#displayPlayerNames")), true)
    ContractorMod.enablePassenger = Utils.getNoNil(xml:getBool("ContractorMod.workers#enablePassenger"), false)
    ContractorMod.numWorkers = #ContractorMod.workers
    xml:delete()
    return ContractorMod.numWorkers > 0
  end
  return false
end

-- @doc Copy default parameters from mod mod zip file to mods directory so end-user can edit it
function ContractorMod:CopyContractorModXML()
  if ContractorMod.debug then print("ContractorMod:CopyContractorModXML") end
  if g_currentMission ~= nil and g_currentMission:getIsServer() then
    if modSettingsDir then
      local xmlFilePath = modSettingsDir.."/ContractorMod.xml"
      if ContractorMod.debug then print("ContractorMod:CopyContractorModXML_1") end
      local xmlFile
      if not fileExists(xmlFilePath) and modDirectory then
        if ContractorMod.debug then print("ContractorMod:CopyContractorModXML_2") end
        local xmlSourceFilePath = modDirectory .. "/ContractorMod.xml"
        local xmlSourceFile
        if fileExists(xmlSourceFilePath) then
          if ContractorMod.debug then print("ContractorMod:CopyContractorModXML_3") end
          xmlSourceFile = loadXMLFile('ContractorMod', xmlSourceFilePath)
          createFolder(modSettingsDir)
          saveXMLFileTo(xmlSourceFile, xmlFilePath)
          if ContractorMod.debug then print("ContractorMod:CopyContractorModXML_4") end
        end
      end
    end
  end
end

function ContractorMod:registerXmlSchema()
  if ContractorMod.debug then print("ContractorMod:registerXMLPaths ") end
  ContractorMod.xmlSchema = XMLSchema.new("ContractorMod")
  ContractorMod.xmlSchema:register(XMLValueType.STRING, "ContractorMod.workers#numWorkers", "Number of workers", nil, true)
  ContractorMod.xmlSchema:register(XMLValueType.STRING, "ContractorMod.workers#enablePassenger", "Ability to enter vehicles as passenger", nil, false)
  ContractorMod.xmlSchema:register(XMLValueType.STRING, "ContractorMod.workers.worker(?)#name", "Name of worker", nil, true)
  ContractorMod.xmlSchema:register(XMLValueType.STRING, "ContractorMod.workers.worker(?)#yaw", "Rotation (yaw) of worker", nil, true)
  ContractorMod.xmlSchema:register(XMLValueType.STRING, "ContractorMod.workers.worker(?)#vehicleID", "ID of vehicle if any", nil, true)
  PlayerStyle.registerSavegameXMLPaths(ContractorMod.xmlSchema, "ContractorMod.workers.worker(?).style")
end

function ContractorMod:onSwitchWorker(action)
  if ContractorMod.debug then print("ContractorMod:onSwitchWorker()") end
  ContractorMod.switching = true
  local canSwitch = false
  local currentID = ContractorMod.currentID
  if action == "SWITCH_VEHICLE" then
    if ContractorMod.debug then print('ContractorMod_NEXTWORKER pressed') end
    local nextID = 0
    if ContractorMod.debug then print("ContractorMod: ContractorMod.currentID " .. tostring(ContractorMod.currentID)) end
    repeat
      if currentID < ContractorMod.numWorkers then
        nextID = currentID + 1
      else
        nextID = 1
      end
      if ContractorMod.debug then print("ContractorMod: nextID " .. tostring(nextID)) end
      canSwitch = self:setCurrentContractorModWorker(nextID)
      if canSwitch == false then
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, g_i18n:getText("ContractorMod_WORKER_INACTIVE") .. " (" .. ContractorMod.workers[nextID].name .. ")")
      end
      currentID = nextID
    until canSwitch or nextID == ContractorMod.currentID
  elseif action == "SWITCH_VEHICLE_BACK" then
    if ContractorMod.debug then print('ContractorMod_PREVWORKER pressed') end
    local prevID = 0
    repeat
      if currentID > 1 then
        prevID = currentID - 1
      else
        prevID = ContractorMod.numWorkers
      end    
      canSwitch = self:setCurrentContractorModWorker(prevID)
      if canSwitch == false then
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, g_i18n:getText("ContractorMod_WORKER_INACTIVE") .. " (" .. ContractorMod.workers[prevID].name .. ")")
      end
      currentID = prevID
    until canSwitch or prevID == ContractorMod.currentID
  end
end

-- @doc Switch directly to another worker
function ContractorMod:activateWorker(actionName, keyStatus)
	if ContractorMod.debug then print("ContractorMod:activateWorker") end
  if ContractorMod.debug then print("actionName "..tostring(actionName)) end
  if string.sub(actionName, 1, 20) == "ContractorMod_WORKER" then
    local workerIndex = tonumber(string.sub(actionName, -1))
    if ContractorMod.numWorkers >= workerIndex and workerIndex ~= ContractorMod.currentID then
      if self:setCurrentContractorModWorker(workerIndex) == false then
        g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, g_i18n:getText("ContractorMod_WORKER_INACTIVE") .. " (" .. ContractorMod.workers[workerIndex].name .. ")")
      end
    end
  end
end

-- @doc Change active worker
function ContractorMod:setCurrentContractorModWorker(setID)
  if ContractorMod.debug then print("ContractorMod:setCurrentContractorModWorker(setID) " .. tostring(setID) .. " - " .. tostring(ContractorMod.currentID)) end
  if ContractorMod.workers[setID].active == false then
    return false
  end
  local currentWorker = ContractorMod.workers[ContractorMod.currentID]
  if currentWorker ~= nil then
    ContractorMod.shouldStopWorker = false
    ContractorMod.switching = true
    currentWorker:beforeSwitch()
  end
  ContractorMod.currentID = setID
  currentWorker = ContractorMod.workers[ContractorMod.currentID]
  if currentWorker ~= nil then
    currentWorker:afterSwitch()
    ContractorMod.shouldStopWorker = true
    ContractorMod.switching = false
  end
  return true
  --DebugUtil.printTableRecursively(ContractorMod.workers, " ", 1, 3)
end

-- @doc Draw worker name and hotspots on map
function ContractorMod:draw()
  --if ContractorModWorker.debug then print("ContractorMod:draw()") end
  --Display current worker name
  if ContractorMod.workers ~= nil then
    if #ContractorMod.workers > 0 and g_currentMission.hud.isVisible then
      local currentWorker = ContractorMod.workers[ContractorMod.currentID]
      if currentWorker ~= nil then
        --Display current worker name
        currentWorker:displayName(self)
      end
    end
  end
end

function ContractorMod:update(dt)
  if ContractorMod.workers ~= nil then
    if #ContractorMod.workers > 0 then
      local currentWorker = ContractorMod.workers[ContractorMod.currentID]
      if currentWorker ~= nil then
        currentWorker.display_x, currentWorker.display_y, currentWorker.display_z = g_localPlayer:getPosition()
      end
    end
  end
end

function ContractorMod:isControlledByWorker(vehicle)
  -- if ContractorMod.debug then print("ContractorMod:isControlledByWorker()") end
  if ContractorMod.workers ~= nil then
    for _, worker in pairs(ContractorMod.workers) do
      local currentVehicle = ContractorMod:getWorkerVehicle(worker)
      local seat = ContractorMod:getWorkerSeat(worker)
      -- local name = nil
      -- if currentVehicle ~= nil then
      --   name = currentVehicle.getName and currentVehicle:getName() or tostring(currentVehicle)
      -- else
      --   name = "nil"    
      -- end
      -- print("Worker "..worker.name.." currentVehicle "..name.." seat "..tostring(seat))
      if currentVehicle ~= nil and vehicle ~= nil and currentVehicle == vehicle and seat == nil then
        return true
      end
    end
  end
  return false
end

function ContractorMod:manageSellConfigVehicle(vehicle)
    if ContractorMod.debug then print("ContractorMod:manageSellConfigVehicle()") end
    for _, worker in pairs(ContractorMod.workers) do
        local currentVehicle = ContractorMod:getWorkerVehicle(worker)
        if currentVehicle ~= nil and vehicle ~= nil and currentVehicle == vehicle then
            worker.currentVehicle = nil
            worker.currentSeat = nil
            if vehicle ~= nil then
                if vehicle.getExitNode == nil then
                    return
                else
                    local exitPoint = vehicle:getExitNode(g_localPlayer)
                    local x, y, z = getWorldTranslation(exitPoint)
                    local terrainHeight = getTerrainHeightAtWorldPos(g_terrainNode, x, 0, z)
                    local raycastLength = 2
                    local _, _, colY, _ = RaycastUtil.raycastClosest(x, terrainHeight + 2, z, 0, -1, 0, 2, CollisionFlag.STATIC_OBJECT + CollisionFlag.ROAD)
                    colY = colY or terrainHeight
                    y = math.max(colY + 0.1, y)
                    y = math.max(y, vehicle.waterY)
                    worker.x = x
                    worker.y = y
                    worker.z = z
                    local exitDirectionX, _, exitDirectionZ = localDirectionToWorld(exitPoint, 0, 0, 1)
                    local exitYaw = MathUtil.getYRotationFromDirection(exitDirectionX, exitDirectionZ)
                    worker.yaw = exitYaw
                    if worker.index ~= ContractorMod.currentID then
                        local spot = NPCSpot.create(tostring(g_time), worker.npc, worker.x, worker.y, worker.z, 0, 0, 0, false)
                        spot:activate()
                        spot.isAvailable = true
                        g_npcManager:addSpot(spot)
                        worker.npc:setSpot(spot)
                        worker:setYawInstant(exitYaw)
                    end
                end
            end
        end
    end
end


function ContractorMod:dumpWorkers()
  if ContractorMod.debug then print("ContractorMod:dumpWorkers()") end
  if ContractorMod.workers ~= nil then
    DebugUtil.printTableRecursively(ContractorMod.workers, "  ", 1, 2)
  end
end
addConsoleCommand("cmDumpWorkers", "Dump ContractorMod workers for debug", "dumpWorkers", ContractorMod)

    