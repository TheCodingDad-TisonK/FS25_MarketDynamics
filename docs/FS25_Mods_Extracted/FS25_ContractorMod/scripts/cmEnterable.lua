cmEnterable = {}

-- @doc Set mapping between savegame vehicle id and vehicle network id when vehicle is loaded
cmEnterable.app_OnLoad = function(self, savegame)
  if ContractorMod.debug then print("cmEnterable.app_OnLoad") end
  if savegame ~= nil then
    -- When loading savegame
    if ContractorMod.mapVehicleLoad == nil then
      ContractorMod.mapVehicleLoad = {}
    end
    local key = savegame.key
    -- key is something like vehicles.vehicle(saveId)
    local saveId = 1 + tonumber(string.sub(key, string.find(key, '(', 1, true) + 1, string.find(key, ')', 1, true) - 1))
    local vehicleID = self.id
    -- Set mapping between savegame vehicle id and vehicle network id once loaded
    ContractorMod.mapVehicleLoad[tostring(saveId)] = vehicleID
    -- DebugUtil.printTableRecursively(ContractorMod.mapVehicleLoad, " ", 1, 2)
  end
end
Enterable.onLoad = Utils.appendedFunction(Enterable.onLoad, cmEnterable.app_OnLoad)

-- @doc Prevent from removing driver character when leaving vehicle if switching between workers
function cmEnterable:getDisableVehicleCharacterOnLeave(superfunc)
  if ContractorMod.debug then print("cmEnterable:getDisableVehicleCharacterOnLeave", ContractorMod.workers[ContractorMod.currentID].currentSeat) end
  if ContractorMod.switching then
    -- ContractorMod.switching = false
    if ContractorMod.debug then print("switching return false") end
    return false
  end
  return true
end
Enterable.getDisableVehicleCharacterOnLeave = Utils.overwrittenFunction(Enterable.getDisableVehicleCharacterOnLeave, cmEnterable.getDisableVehicleCharacterOnLeave)

-- Prevent delete or put default character when AI stops
function cmEnterable:restoreVehicleCharacter(superfunc)
  if ContractorMod.debug then print("cmEnterable:restoreVehicleCharacter") end
	if self.spec_enterable.vehicleCharacter ~= nil then
    for _, worker in pairs(ContractorMod.workers) do
      local currentVehicle = ContractorMod:getWorkerVehicle(worker)
      if currentVehicle ~= nil and currentVehicle == self then
        -- print("Worker "..worker.name.." controlling vehicle")
        self:setVehicleCharacter(worker.playerStyle)
      end
    end
  end
end
Enterable.restoreVehicleCharacter = Utils.overwrittenFunction(Enterable.restoreVehicleCharacter, cmEnterable.restoreVehicleCharacter)

-- Keep current worker character when activating AIJob helper, prevent to set random character
function cmEnterable:setRandomVehicleCharacter(superfunc, helper)
  if ContractorMod.debug then print("cmEnterable:setRandomVehicleCharacter") end
  return
end
Enterable.setRandomVehicleCharacter = Utils.overwrittenFunction(Enterable.setRandomVehicleCharacter, cmEnterable.setRandomVehicleCharacter)

-- Update correctly characters in vehicles
function cmEnterable:onPlayerStyleChanged(superfunc,style, userId)
  if ContractorMod.debug then print("cmEnterable:onPlayerStyleChanged") end
  for _, worker in pairs(ContractorMod.workers) do
    local currentVehicle = ContractorMod:getWorkerVehicle(worker)
    if currentVehicle ~= nil and currentVehicle == self then
      -- print("Worker "..worker.name.." style changed, update seat character")
      -- printCallstack()
      superfunc(self, worker.playerStyle, userId)
    end
  end
end
Enterable.onPlayerStyleChanged = Utils.overwrittenFunction(Enterable.onPlayerStyleChanged, cmEnterable.onPlayerStyleChanged)

-- Lead to vehicle always controlled, running by themselves
function cmEnterable:getIsControlled()
	return self.spec_enterable.isControlled or ContractorMod:isControlledByWorker(self)
end
-- Enterable.getIsControlled = Utils.overwrittenFunction(Enterable.getIsControlled, cmEnterable.getIsControlled)
-- Lead to vehicle always controlled, running by themselves

-- 
function cmEnterable:getIsInteractive(superfunc, superFunc)
  -- if ContractorMod.debug then print("cmEnterable:getIsInteractive") end
  -- Prevent to allow entering as driver
  if ContractorMod:isControlledByWorker(self) then
    return false
  end
  return superfunc(self, superFunc)
end
Enterable.getIsInteractive = Utils.overwrittenFunction(Enterable.getIsInteractive, cmEnterable.getIsInteractive)
