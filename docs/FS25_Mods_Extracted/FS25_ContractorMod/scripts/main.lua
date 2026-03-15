source(Utils.getFilename("scripts/cmAIHotspot.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmEnterable.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmEnterablePassenger.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmFSBaseMission.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmInGameMenuMapFrame.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmMission00.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmNPCManager.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmPlayer.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmPlayerInputComponent.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmSavegameController.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmShopController.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmShopOthersFrame.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmVehicle.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmWardrobeScreen.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/cmWorkshopScreen.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/ContractorMod.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/ContractorModWorker.lua", g_currentModDirectory))
-- source(Utils.getFilename("scripts/ContractorModTestRunner.lua", g_currentModDirectory))
-- TODO:
-- Using first person camera when driving can lead to activate passenger camera if any, then crash
-- Test sell/repair vehicle with worker in it

local contractormod

local function isEnabled()
    -- Normally this code never runs if ContractorMod was not active. However, in development mode
    -- this might not always hold true.
    return contractormod ~= nil
end

local function load(mission)
    --print("load(mission)")
    assert(contractormod == nil)

    contractormod = ContractorMod:new(mission, g_i18n, g_inputBinding, g_gui, g_soundManager, modDirectory, modName)

    getfenv(0)["g_contractormod"] = contractormod
    addModEventListener(contractormod)

end

local function unload()
    if not isEnabled() then return end

    removeModEventListener(contractormod)

    if contractormod ~= nil then
        contractormod:delete()
        contractormod = nil -- Allows garbage collecting
        getfenv(0)["g_contractormod"] = nil
    end
end

local function init()
    FSBaseMission.delete = Utils.appendedFunction(FSBaseMission.delete, unload)
    Mission00.load = Utils.prependedFunction(Mission00.load, load)
end

init()
