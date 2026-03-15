CropManager = {}

local CropManager_mt = Class(CropManager)

function CropManager:new(mission)
    local self = setmetatable({}, CropManager_mt)
    self.mission = mission
    
    self.crops = {
        WHEAT = { category = "Céréales", fruitType = "WHEAT", steps = {"MULCH", "LIME", "PLOW", "STONES", "FERTILIZE", "SOW", "ROLL", "WEED", "FERTILIZE", "HARVEST"} },
        BARLEY = { category = "Céréales", fruitType = "BARLEY", steps = {"MULCH", "LIME", "PLOW", "STONES", "FERTILIZE", "SOW", "ROLL", "WEED", "FERTILIZE", "HARVEST"} },
        OAT = { category = "Céréales", fruitType = "OAT", steps = {"MULCH", "LIME", "PLOW", "STONES", "FERTILIZE", "SOW", "ROLL", "WEED", "FERTILIZE", "HARVEST"} },
        CANOLA = { category = "Céréales", fruitType = "CANOLA", steps = {"MULCH", "LIME", "PLOW", "STONES", "FERTILIZE", "SOW", "ROLL", "WEED", "FERTILIZE", "HARVEST"} },
        SORGHUM = { category = "Céréales", fruitType = "SORGHUM", steps = {"MULCH", "LIME", "PLOW", "STONES", "FERTILIZE", "SOW", "ROLL", "WEED", "FERTILIZE", "HARVEST"} },
        SOYBEAN = { category = "Céréales", fruitType = "SOYBEAN", steps = {"MULCH", "LIME", "PLOW", "STONES", "FERTILIZE", "SOW", "ROLL", "WEED", "FERTILIZE", "HARVEST"} },
        
        POTATO = { category = "Racines", fruitType = "POTATO", steps = {"MULCH", "LIME", "PLOW", "FERTILIZE", "SOW", "ROLL", "RIDGING", "WEED", "MULCH_LEAVES", "HARVEST"} },
        SUGARBEET = { category = "Racines", fruitType = "SUGARBEET", steps = {"MULCH", "LIME", "PLOW", "FERTILIZE", "SOW", "ROLL", "WEED", "MULCH_LEAVES", "HARVEST"} },
        
        MAIZE = { category = "Spécial", fruitType = "MAIZE", steps = {"PLOW", "SOW", "ROLL", "HARVEST"} },
        SUNFLOWER = { category = "Spécial", fruitType = "SUNFLOWER", steps = {"PLOW", "SOW", "ROLL", "HARVEST"} },
        
        GRASS = { category = "Herbe", fruitType = "GRASS", steps = {"SOW", "ROLL", "FERTILIZE", "MOW", "TEDDER", "WINDROWER"} },
        
        WET_RICE = { category = "Riz", fruitType = "WET_RICE", steps = {"PLOW", "FERTILIZE", "SOW", "HARVEST"} },
        DRY_RICE = { category = "Riz", fruitType = "DRY_RICE", steps = {"PLOW", "FERTILIZE", "SOW", "HARVEST"} }
    }

    CustomUtils:debug("[CropManager] Initialized")
    return self
end

---Determines the next required step for a field based on target crop
---@param field table
---@param targetCropName string
---@return string|nil nextStep, string|nil reason
function CropManager:getNextStep(field, targetCropName)
    local cropData = self.crops[targetCropName]
    if not cropData then return nil, "Unknown crop" end

    if field.fieldState == nil then
        field.fieldState = FieldState.new()
    end
    
    local x, z = field:getCenterOfFieldWorldPosition()
    field.fieldState:update(x, z)
    
    local state = field.fieldState
    if not state or not state.isValid then 
        if state and state.groundType == 0 then
            return nil, "Field state invalid or ground not detected"
        end
    end

    CustomUtils:debug("[CropManager] Field %d Analysis for %s:", field.fieldId, targetCropName)
    CustomUtils:debug("  - Fruit: %d (Target: %d)", state.fruitTypeIndex, self:getFruitTypeIndex(targetCropName))
    CustomUtils:debug("  - Growth: %d", state.growthState)
    CustomUtils:debug("  - GroundType: %d (%s)", state.groundType, FieldGroundType.getName(state.groundType) or "UNKNOWN")
    CustomUtils:debug("  - SprayType: %d | SprayLevel: %d", state.sprayType or 0, state.sprayLevel)
    CustomUtils:debug("  - Plow: %d | Lime: %d | Stones: %d", state.plowLevel, state.limeLevel, state.stoneLevel)
    CustomUtils:debug("  - Stubble: %d | Weed: %d | Roller: %d", state.stubbleShredLevel, state.weedState, state.rollerLevel)

    local targetFruitIndex = self:getFruitTypeIndex(targetCropName)
    
    if state.fruitTypeIndex == targetFruitIndex and state.growthState > 0 then
        local fruitType = g_fruitTypeManager:getFruitTypeByIndex(state.fruitTypeIndex)
        if fruitType and state.growthState >= fruitType.minHarvestingGrowthState then
            return "HARVEST", "Target crop is ready for harvest"
        elseif state.growthState < fruitType.minHarvestingGrowthState then
            return "WAIT", string.format("Waiting for crop to grow (State: %d/%d)", state.growthState, fruitType.minHarvestingGrowthState)
        end
    end

    if state.fruitTypeIndex ~= FruitType.UNKNOWN and state.fruitTypeIndex ~= targetFruitIndex then
        local fruitType = g_fruitTypeManager:getFruitTypeByIndex(state.fruitTypeIndex)
        local fruitName = fruitType and fruitType.name or "UNKNOWN"

        if fruitType and state.growthState >= fruitType.minHarvestingGrowthState then
            return "HARVEST", string.format("Harvesting existing %s before planting %s", fruitName, targetCropName)
        else
            return "PLOW", string.format("Destroying existing %s to plant %s", fruitName, targetCropName)
        end
    end

    for index, step in ipairs(cropData.steps) do
        local needed, reason = self:checkStepRequirement(step, state, targetCropName)
        if needed then
            CustomUtils:info("[CropManager] Next Step Decided: %s (Reason: %s)", step, reason)
            return step, reason
        end
    end

    return "WAIT", "No workflow steps currently required"
end

---Checks if a specific workflow step is required based on field state
---@param step string
---@param state table
---@param targetCropName string
---@return boolean needed, string reason
function CropManager:checkStepRequirement(step, state, targetCropName)
    if step == "MULCH" then
        if state.stubbleShredLevel == 0 and state.fruitTypeIndex == FruitType.UNKNOWN and state.plowLevel == 0 then
            return true, "Stubble detected (No plowing needed)"
        end
    
    elseif step == "PLOW" then
        if state.plowLevel > 0 then return true, "Field requires plowing" end

    elseif step == "LIME" then
        if state.limeLevel > 0 then return true, "Lime level critical" end

    elseif step == "STONES" then
        if state.stoneLevel > 0 then return true, "Stones detected" end

    elseif step == "FERTILIZE" then
        if state.sprayLevel < 1 then return true, "Fertilizer required" end

    elseif step == "SOW" then
        if state.fruitTypeIndex == FruitType.UNKNOWN then
            local canPlant, reason = self:canPlant(targetCropName)
            if canPlant then return true, "Ready to sow" end
        end

    elseif step == "ROLL" then
        if state.rollerLevel == 0 and state.growthState == 1 then return true, "Soil needs rolling" end

    elseif step == "WEED" then
        if state.weedState > 0 then return true, "Weeds detected" end
    
    elseif step == "RIDGING" then
        return false, "Not implemented yet"

    elseif step == "MULCH_LEAVES" then
        if state.growthState >= 6 then return true, "Ready for haulm topping" end
    end

    return false, nil
end

function CropManager:canPlant(cropName)
    local cropData = self.crops[cropName]
    if not cropData then return false, "Unknown crop" end

    local fruitType = g_fruitTypeManager:getFruitTypeByName(cropData.fruitType)
    if not fruitType then return false, "Fruit type not found" end

    local currentMonth = g_currentMission.environment.currentMonth

    if fruitType.periodData and fruitType.periodData.plantingPeriods then
        for _, month in ipairs(fruitType.periodData.plantingPeriods) do
            if month == currentMonth then
                return true, "OK"
            end
        end
        return false, "Outside planting window"
    end

    return true, "No period data available"
end

function CropManager:getFruitTypeIndex(cropName)
    local cropData = self.crops[cropName]
    if cropData then
        local ft = g_fruitTypeManager:getFruitTypeByName(cropData.fruitType)
        return ft and ft.index or FruitType.UNKNOWN
    end
    return FruitType.UNKNOWN
end
