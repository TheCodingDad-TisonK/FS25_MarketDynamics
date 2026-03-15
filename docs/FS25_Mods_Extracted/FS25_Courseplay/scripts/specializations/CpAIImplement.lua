--- This spec is only for overwriting giants function of the AIImplement.
local modName = CpAIImplement and CpAIImplement.MOD_NAME -- for reload

---@class CpAIImplement
CpAIImplement = {}
CpAIImplement.MOD_NAME = g_currentModName or modName
CpAIImplement.NAME = ".cpAIImplement"
CpAIImplement.SPEC_NAME = CpAIImplement.MOD_NAME .. CpAIImplement.NAME
CpAIImplement.KEY = "."..CpAIImplement.MOD_NAME..CpAIImplement.NAME
function CpAIImplement.initSpecialization()
    local schema = Vehicle.xmlSchemaSavegame
    local key = "vehicles.vehicle(?)" .. CpAIImplement.KEY
end

function CpAIImplement.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AIImplement, specializations) 
end

function CpAIImplement.register(typeManager,typeName,specializations)
	if CpAIImplement.prerequisitesPresent(specializations) then
		typeManager:addSpecialization(typeName, CpAIImplement.SPEC_NAME)
	end
end

function CpAIImplement.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, 'onLoad', CpAIImplement)
end

function CpAIImplement.registerFunctions(vehicleType)

end

function CpAIImplement.registerOverwrittenFunctions(vehicleType)
    
end

function CpAIImplement.registerEvents(vehicleType)
  
end

function CpAIImplement:onLoad(savegame)
    self.spec_cpAIImplement = self["spec_" .. CpAIImplement.SPEC_NAME]
    local spec = self.spec_cpAIImplement
end