--
-- AdvancedFarmManager - HotKey Vehicle System
--

HotKeyVehicleSystem = {}

local HotKeyVehicleSystem_mt = Class(HotKeyVehicleSystem)


function HotKeyVehicleSystem:new(modName, modDir, inputManager, debug)
    local self = {}

    setmetatable(self, HotKeyVehicleSystem_mt)

    self.modName      = modName
    self.modDir       = modDir
    self.debug        = debug
    self.inputManager = inputManager

    self.instances    = {}
    self.counter      = 0
    self.localUniqueUserId = nil

    return self
end


function HotKeyVehicleSystem:installSpecialization(typeManager, specManager)
    
    -- register spec
    specManager:addSpecialization("hotKeyVehicle", "HotKeyVehicle", Utils.getFilename("scripts/HotKeyVehicle.lua", self.modDir), nil)

    -- add spec to vehicle types
    local totalCount = 0
    local modified   = 0
    for typeName, typeEntry in pairs(typeManager:getTypes()) do
        totalCount = totalCount + 1
        if SpecializationUtil.hasSpecialization(Enterable, typeEntry.specializations) and
            not SpecializationUtil.hasSpecialization(Rideable, typeEntry.specializations) and
            not SpecializationUtil.hasSpecialization(HotKeyVehicle, typeEntry.specializations) then
            typeManager:addSpecialization(typeName, self.modName .. ".hotKeyVehicle")
            modified = modified + 1
            if (self.debug) then
                print("~~ AdvancedFarmManager Debug ...Adding hotkey vehicle to " .. typeName)
            end
        else
            if (self.debug) then
                print("~~ AdvancedFarmManager Debug ... Not adding hotkey vehicle to " .. typeName)
            end
        end
    end
    if (self.debug) then
        print(string.format("~~ AdvancedFarmManager Debug ... inserted hotKey into %i of %i vehicle types", modified, totalCount))
    end
end


function HotKeyVehicleSystem:registerInstance(instance)
    local key           = self.counter
    self.instances[key] = instance
    self.counter        = self.counter + 1

    return key
end


function HotKeyVehicleSystem:unregisterInstance(key)
    self.instances[key] = nil
end


function HotKeyVehicleSystem:setLocalUniqueUserId(uniqueUserId)
    if uniqueUserId ~= nil and uniqueUserId ~= "" then
        self.localUniqueUserId = uniqueUserId
    end
end


function HotKeyVehicleSystem:getLocalUniqueUserId()
    if self.localUniqueUserId ~= nil then
        return self.localUniqueUserId
    end

    if g_localPlayer ~= nil then
        local uniqueUserId = g_currentMission.userManager:getUniqueUserIdByUserId(g_localPlayer.userId)
        self.localUniqueUserId = uniqueUserId
        return uniqueUserId
    end

    return nil
end
