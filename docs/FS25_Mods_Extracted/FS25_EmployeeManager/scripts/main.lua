print("Loading main.lua")

g_modName = g_currentModName
g_modDirectory = g_currentModDirectory

MessageType.EMPLOYEE_ADDED = nextMessageTypeId()
MessageType.EMPLOYEE_REMOVED = nextMessageTypeId()
MessageType.EMPLOYEE_SKILL_LEVELUP = nextMessageTypeId()

-- Icon globals (resolved by GuiOverlay.resolveFilename hook)
g_EMIconMenu     = Utils.getFilename("images/MenuIcon.dds", g_modDirectory)
g_EMIconEmployee = Utils.getFilename("images/EMEmployeeIcon.dds", g_modDirectory)
g_EMIconWorkflow = Utils.getFilename("images/EMWorkflowIcon.dds", g_modDirectory)
g_EMIconField    = Utils.getFilename("images/EMFieldIcon.dds", g_modDirectory)
g_EMIconVehicle  = Utils.getFilename("images/EMVehicleIcon.dds", g_modDirectory)

local EM_ICON_GLOBALS = {
    g_EMIconMenu     = true,
    g_EMIconEmployee = true,
    g_EMIconWorkflow = true,
    g_EMIconField    = true,
    g_EMIconVehicle  = true,
}

local function emResolveFilename(self, superFunc)
    local filename = superFunc(self)
    if EM_ICON_GLOBALS[filename] then
        return _G[filename]
    end
    return filename
end

GuiOverlay.resolveFilename = Utils.overwrittenFunction(GuiOverlay.resolveFilename, emResolveFilename)

source(g_modDirectory .. "scripts/utils/Utils.lua")

source(g_modDirectory .. "scripts/types/traitsystem.lua")
source(g_modDirectory .. "scripts/types/skillsystem.lua")
source(g_modDirectory .. "scripts/types/skilleffects.lua")
source(g_modDirectory .. "scripts/types/employee.lua")
source(g_modDirectory .. "scripts/events/HireEmployeeEvent.lua")
source(g_modDirectory .. "scripts/events/FireEmployeeEvent.lua")

source(g_modDirectory .. "scripts/gui/EmployeeRenderer.lua")
source(g_modDirectory .. "scripts/gui/TaskListItemRenderer.lua")
source(g_modDirectory .. "scripts/gui/MenuEmployeeManager.lua")

source(g_modDirectory .. "scripts/gui/EMEmployeeFrame.lua")
source(g_modDirectory .. "scripts/gui/EMWorkflowFrame.lua")
source(g_modDirectory .. "scripts/gui/EMFieldFrame.lua")
source(g_modDirectory .. "scripts/gui/EMVehicleFrame.lua")
source(g_modDirectory .. "scripts/gui/EMTrainingDialog.lua")
source(g_modDirectory .. "scripts/gui/EMGui.lua")

source(g_modDirectory .. "scripts/managers/commandmanager.lua")
source(g_modDirectory .. "scripts/managers/coursemanager.lua")
source(g_modDirectory .. "scripts/managers/cropmanager.lua")
source(g_modDirectory .. "scripts/managers/employeemanager.lua")
source(g_modDirectory .. "scripts/managers/jobmanager.lua")
source(g_modDirectory .. "scripts/managers/parkingmanager.lua")
source(g_modDirectory .. "scripts/managers/VehicleSnapshotManager.lua")
source(g_modDirectory .. "scripts/managers/milestonesystem.lua")
source(g_modDirectory .. "scripts/persistence/PersistenceStrategy.lua")
source(g_modDirectory .. "scripts/persistence/XMLPersistence.lua")
source(g_modDirectory .. "scripts/persistence/DBAPIPersistence.lua")
source(g_modDirectory .. "scripts/persistence/PersistenceManager.lua")
source(g_modDirectory .. "scripts/extensions/WearableExtension.lua")
source(g_modDirectory .. "scripts/extensions/HarvestExtension.lua")
source(g_modDirectory .. "scripts/extensions/AIOverrideExtension.lua")
source(g_modDirectory .. "scripts/extensions/HelperNameExtension.lua")
source(g_modDirectory .. "scripts/gui/SimpleStatusHUD.lua")
source(g_modDirectory .. "scripts/ModGui.lua")

source(g_modDirectory .. "scripts/modcontroller.lua")

WearableExtension.init()
HarvestExtension.init()
AIOverrideExtension.init()
HelperNameExtension.init()
MilestoneSystem.init()
