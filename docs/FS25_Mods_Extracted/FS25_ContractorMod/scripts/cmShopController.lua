cmShopController = {}

function cmShopController:app_sellVehicle(vehicle, isDirectSell)
    if ContractorMod.debug then print("cmShopController:sellVehicle()") end
    ContractorMod:manageSellConfigVehicle(vehicle)
end
ShopController.sellVehicle = Utils.appendedFunction(ShopController.sellVehicle, cmShopController.app_sellVehicle)
