--- Global instance of park vehicle.
---@class ParkVehicleSystem
---@field modName string
---@field modDir string
---@field inputManager InputBinding
---@field debug boolean
---@field instances table<integer, ParkVehicle>
---@field counter integer Increased if an instance is registered, used as key within the table
ParkVehicleSystem = {}

local ParkVehicleSystem_mt = Class(ParkVehicleSystem)

---
---@param modName string
---@param modDir string
---@param inputManager InputBinding
---@param debug boolean
---@return ParkVehicleSystem
function ParkVehicleSystem:new(modName, modDir, inputManager, debug)
    local self = {}

    setmetatable(self, ParkVehicleSystem_mt)

    self.modName = modName
    self.modDir = modDir
    self.debug = debug
    self.inputManager = inputManager

    self.instances = {}
    self.counter = 0
    self.controlledVehicle = nil

    return self
end

function ParkVehicleSystem:onMissionLoaded(mission)
    -- hook into function, which is called only if the HUD is really visible for a vehicle
    mission.hud.drawControlledEntityHUD = Utils.appendedFunction(mission.hud.drawControlledEntityHUD,
        function(self)
            if self.isVisible then
                ParkVehicleSystem:renderHud()
            end
        end)
    -- hook into function, which sets the vehicle for HUD display
    mission.hud.setControlledVehicle = Utils.appendedFunction(mission.hud.setControlledVehicle,
        function(self, vehicle)
            ParkVehicleSystem:setVehicle(vehicle)
        end)
end

---@param typeManager TypeManager
---@param specManager SpecializationManager
function ParkVehicleSystem:installSpecialization(typeManager, specManager)
    -- register spec
    specManager:addSpecialization("parkVehicle", "ParkVehicle", Utils.getFilename("ParkVehicle.lua", self.modDir), nil)

    -- add spec to vehicle types
    local totalCount = 0
    local modified = 0
    for typeName, typeEntry in pairs(typeManager:getTypes()) do
        totalCount = totalCount + 1
        if SpecializationUtil.hasSpecialization(Enterable, typeEntry.specializations) and
            not SpecializationUtil.hasSpecialization(Rideable, typeEntry.specializations) and
            not SpecializationUtil.hasSpecialization(ParkVehicle, typeEntry.specializations) then
            typeManager:addSpecialization(typeName, self.modName .. ".parkVehicle")
            modified = modified + 1
            if (self.debug) then
                print("Adding park vehicle to " .. typeName)
            end
        else
            if (self.debug) then
                print("Not adding park vehicle to " .. typeName)
            end
        end
    end

    print(string.format("Inserted Park Vehicle into %i of %i vehicle types", modified, totalCount))
end

function ParkVehicleSystem:registerActionEvents()
    local _, eventId = self.inputManager:registerActionEvent(InputAction.PARKVEHICLE_UNPARK_ALL, self, self.unparkAll, false, true, false, true)
    self.inputManager:setActionEventTextPriority(eventId, GS_PRIO_VERY_HIGH)
  end
  
  function ParkVehicleSystem:unregisterActionEvents()
    self.inputManager:removeActionEventsByTarget(self)
  end

---@param instance ParkVehicle
---@return integer the key to unregister this instance
function ParkVehicleSystem:registerInstance(instance)
    local key = self.counter
    self.instances[key] = instance

    self.counter = self.counter + 1

    return key
end

---@param key integer
function ParkVehicleSystem:unregisterInstance(key)
    self.instances[key] = nil
end

function ParkVehicleSystem:unparkAll()
    for _, value in pairs(self.instances) do
        value:setParkVehicleState(false)
    end
end

function ParkVehicleSystem:setVehicle(vehicle)
    self.controlledVehicle = vehicle
end

function ParkVehicleSystem:renderHud()
    if self.controlledVehicle ~= nil and self.controlledVehicle.parkVehicleRender ~= nil then
        self.controlledVehicle:parkVehicleRender()
    end
end