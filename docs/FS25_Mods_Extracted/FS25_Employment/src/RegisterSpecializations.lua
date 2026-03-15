local RegisterSpecializations = {}
local modDirectory = g_currentModDirectory

g_specializationManager:addSpecialization("employer", "PlaceableEmployer", modDirectory .. "src/PlaceableEmployer.lua", nil)


RegisterSpecializations.SUPPORTED_SPECS = {
    PlaceableProductionPoint,
    PlaceableSellingStation,
    PlaceableFactory,
    PlaceableBuyingStation
}


RegisterSpecializations.UNSUPPORTED_TYPES = {
    "greenhouse",
    "productionPointWardrobe"
}


for placeableName, placeableType in pairs(g_placeableTypeManager.types) do

    local hasSupportedSpec = false

    for _, spec in pairs(RegisterSpecializations.SUPPORTED_SPECS) do
        if SpecializationUtil.hasSpecialization(spec,  placeableType.specializations) then
            hasSupportedSpec = true
            break
        end
    end

    if not hasSupportedSpec then continue end

    local hasUnsupportedType = false

    for _, name in pairs(RegisterSpecializations.UNSUPPORTED_TYPES) do
        if placeableName == name then
            hasUnsupportedType = true
            break
        end
    end

    if hasUnsupportedType then continue end

    local specializationObject = g_specializationManager:getSpecializationObjectByName("employer")
    placeableType.specializationsByName["employer"] = specializationObject;
    table.insert(placeableType.specializationNames, "employer")
    table.insert(placeableType.specializations, specializationObject)

end