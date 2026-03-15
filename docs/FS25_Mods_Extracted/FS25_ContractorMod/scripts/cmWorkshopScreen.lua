cmWorkshopScreen = {}

function cmWorkshopScreen:app_setConfigurations(vehicleBuyData, vehicleId)
    if ContractorMod.debug then print("cmWorkshopScreen:app_setConfigurations()") end
    local vehicle = NetworkUtil.getObject(vehicleId)
    if vehicle ~= nil then
        ContractorMod:manageSellConfigVehicle(vehicle)
    end
end
WorkshopScreen.setConfigurations = Utils.appendedFunction(WorkshopScreen.setConfigurations, cmWorkshopScreen.app_setConfigurations)