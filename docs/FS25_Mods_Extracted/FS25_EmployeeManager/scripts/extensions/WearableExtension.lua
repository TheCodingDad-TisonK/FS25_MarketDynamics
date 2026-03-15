---@class WearableExtension
WearableExtension = {}

---Overwrites Wearable:updateDamageAmount to reduce damage based on employee technical skill
---@param vehicle table The vehicle instance
---@param superFunc function The original updateDamageAmount function
---@param dt number Delta time in ms
---@return number The change in damage amount
function WearableExtension.overwrittenUpdateDamageAmount(vehicle, superFunc, dt)
    local changeAmount = superFunc(vehicle, dt)
    
    if changeAmount > 0 and g_employeeManager ~= nil then
        local employee = g_employeeManager:getEmployeeByVehicle(vehicle)
        if employee and employee.isHired and employee.currentJob ~= nil then
            local multiplier = SkillEffects.getWearMultiplier(employee)
            changeAmount = changeAmount * multiplier
        end
    end

    return changeAmount
end

---Overwrites Wearable:updateWearAmount to reduce wear based on employee technical skill
---@param vehicle table The vehicle instance
---@param superFunc function The original updateWearAmount function
---@param nodeData table The wearable node data
---@param dt number Delta time in ms
---@return number The change in wear amount
function WearableExtension.overwrittenUpdateWearAmount(vehicle, superFunc, nodeData, dt)
    local changeAmount = superFunc(vehicle, nodeData, dt)

    if changeAmount > 0 and g_employeeManager ~= nil then
        local employee = g_employeeManager:getEmployeeByVehicle(vehicle)
        if employee and employee.isHired and employee.currentJob ~= nil then
            local multiplier = SkillEffects.getWearMultiplier(employee)
            changeAmount = changeAmount * multiplier
        end
    end
    
    return changeAmount
end

function WearableExtension.init()
    if Wearable ~= nil then
        Wearable.updateDamageAmount = Utils.overwrittenFunction(Wearable.updateDamageAmount, WearableExtension.overwrittenUpdateDamageAmount)
        Wearable.updateWearAmount = Utils.overwrittenFunction(Wearable.updateWearAmount, WearableExtension.overwrittenUpdateWearAmount)
        CustomUtils:info("[WearableExtension] Successfully hooked into Wearable specialization")
    else
        CustomUtils:error("[WearableExtension] Failed to hook: Wearable specialization not found")
    end
end
