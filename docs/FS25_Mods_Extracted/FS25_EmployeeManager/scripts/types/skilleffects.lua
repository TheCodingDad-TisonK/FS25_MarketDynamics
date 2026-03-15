---@class SkillEffects
--- Gameplay multipliers derived from skill levels and traits.
--- Covers wear, yield, fuel, and speed effects.
SkillEffects = {}

---Returns wear multiplier based on technical skill + traits
--- Level 1: 1.0 (no reduction), Level 10: 0.375 (62.5% reduction)
--- Formula: 1.0 - ((skill - 1) * 0.0694)
---@param employee table
---@return number Multiplier (lower = less wear)
function SkillEffects.getWearMultiplier(employee)
    local skill = math.max(1, math.min(SkillSystem.MAX_LEVEL, employee.skills.technical or 1))
    local baseMult = 1.0 - ((skill - 1) * 0.0694)
    local traitWear = TraitSystem.getMultiplier(employee.traits, "wearMult")
    return baseMult * traitWear
end

---Returns yield multiplier based on harvesting skill
--- Level 1-2: 0.95-0.97 (penalty), Level 3-4: 1.0, Level 5-6: 1.03-1.05
--- Level 7-8: 1.08-1.10, Level 9-10: 1.13-1.15
---@param employee table
---@return number Multiplier (higher = more yield)
function SkillEffects.getYieldMultiplier(employee)
    local skill = math.max(1, math.min(SkillSystem.MAX_LEVEL, employee.skills.harvesting or 1))

    local yieldTable = {
        [1]  = 0.95,
        [2]  = 0.97,
        [3]  = 1.00,
        [4]  = 1.00,
        [5]  = 1.03,
        [6]  = 1.05,
        [7]  = 1.08,
        [8]  = 1.10,
        [9]  = 1.13,
        [10] = 1.15,
    }

    return yieldTable[skill] or 1.0
end

---Returns fuel consumption multiplier based on driving skill + traits
--- Level 1-2: 1.0 (no bonus), Level 3-4: 0.95-0.90
--- Level 7-8: 0.85, Level 9-10: 0.80
---@param employee table
---@return number Multiplier (lower = less fuel)
function SkillEffects.getFuelMultiplier(employee)
    local skill = math.max(1, math.min(SkillSystem.MAX_LEVEL, employee.skills.driving or 1))

    local fuelTable = {
        [1]  = 1.00,
        [2]  = 1.00,
        [3]  = 0.95,
        [4]  = 0.90,
        [5]  = 0.90,
        [6]  = 0.90,
        [7]  = 0.85,
        [8]  = 0.85,
        [9]  = 0.80,
        [10] = 0.80,
    }

    local baseMult = fuelTable[skill] or 1.0
    local traitFuel = TraitSystem.getMultiplier(employee.traits, "fuelMult")
    return baseMult * traitFuel
end

---Returns AI work speed multiplier based on driving skill + traits
--- Level 1-4: 1.0 (no bonus), Level 5-6: 1.05-1.10
--- Level 7-8: 1.10, Level 9-10: 1.20
---@param employee table
---@return number Multiplier (higher = faster)
function SkillEffects.getSpeedMultiplier(employee)
    local skill = math.max(1, math.min(SkillSystem.MAX_LEVEL, employee.skills.driving or 1))

    local speedTable = {
        [1]  = 1.00,
        [2]  = 1.00,
        [3]  = 1.00,
        [4]  = 1.00,
        [5]  = 1.05,
        [6]  = 1.10,
        [7]  = 1.10,
        [8]  = 1.10,
        [9]  = 1.20,
        [10] = 1.20,
    }

    local baseMult = speedTable[skill] or 1.0
    local traitSpeed = TraitSystem.getMultiplier(employee.traits, "speedMult")
    return baseMult * traitSpeed
end

---Returns wage multiplier from traits only (skill-based wage is in Employee.getBaseHourlyWage)
---@param employee table
---@return number
function SkillEffects.getWageTraitMultiplier(employee)
    return TraitSystem.getMultiplier(employee.traits, "wageMult")
end

return SkillEffects
