---@class HarvestExtension
--- Hooks Combine:addCutterArea to apply yield multiplier based on employee harvesting skill.
HarvestExtension = {}

---Overwrites Combine:addCutterArea to multiply yield based on employee skill
---@param vehicle table The combine harvester
---@param superFunc function The original addCutterArea function
---@param ... any Original parameters
---@return any Results from the original function
function HarvestExtension.overwrittenAddCutterArea(vehicle, superFunc, ...)
    if g_employeeManager == nil then
        return superFunc(vehicle, ...)
    end

    local employee = g_employeeManager:getEmployeeByVehicle(vehicle)
    if employee == nil or not employee.isHired or employee.currentJob == nil then
        return superFunc(vehicle, ...)
    end

    local yieldMult = SkillEffects.getYieldMultiplier(employee)
    if math.abs(yieldMult - 1.0) < 0.001 then
        return superFunc(vehicle, ...)
    end

    local spec = vehicle.spec_combine
    if spec == nil then
        return superFunc(vehicle, ...)
    end

    local fillUnitIndex = spec.fillUnitIndex
    local beforeLevel = 0
    if fillUnitIndex and vehicle.getFillUnitFillLevel then
        beforeLevel = vehicle:getFillUnitFillLevel(fillUnitIndex)
    end

    local result = superFunc(vehicle, ...)

    if fillUnitIndex and vehicle.getFillUnitFillLevel and vehicle.addFillUnitFillLevel then
        local afterLevel = vehicle:getFillUnitFillLevel(fillUnitIndex)
        local delta = afterLevel - beforeLevel
        if delta > 0 then
            local bonusDelta = delta * (yieldMult - 1.0)
            vehicle:addFillUnitFillLevel(vehicle:getOwnerFarmId(), fillUnitIndex, bonusDelta, vehicle:getFillUnitFillType(fillUnitIndex), ToolType.UNDEFINED)
        end
    end

    return result
end

function HarvestExtension.init()
    if Combine ~= nil and Combine.addCutterArea ~= nil then
        Combine.addCutterArea = Utils.overwrittenFunction(Combine.addCutterArea, HarvestExtension.overwrittenAddCutterArea)
        CustomUtils:info("[HarvestExtension] Successfully hooked into Combine:addCutterArea")
    else
        CustomUtils:warning("[HarvestExtension] Combine:addCutterArea not found, yield multiplier disabled")
    end
end
