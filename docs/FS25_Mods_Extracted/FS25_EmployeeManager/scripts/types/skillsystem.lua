---@class SkillSystem
--- Centralized skill progression system with exponential XP curve.
--- MAX_LEVEL = 10, XP = 100 * 1.5^(level-1)
SkillSystem = {}

SkillSystem.MAX_LEVEL = 10
SkillSystem.XP_BASE = 100
SkillSystem.XP_EXPONENT = 1.5

SkillSystem.SKILL_NAMES = { "driving", "harvesting", "technical" }

SkillSystem.XP_RATES = {
    HARVEST   = { driving = 10, harvesting = 15, technical = 5 },
    SOW       = { driving = 10, harvesting = 8,  technical = 5 },
    PLOW      = { driving = 12, harvesting = 0,  technical = 8 },
    CULTIVATE = { driving = 12, harvesting = 0,  technical = 8 },
    FERTILIZE = { driving = 8,  harvesting = 0,  technical = 10 },
    LIME      = { driving = 8,  harvesting = 0,  technical = 10 },
    MOW       = { driving = 8,  harvesting = 10, technical = 5 },
    TEDDER    = { driving = 8,  harvesting = 10, technical = 5 },
    WINDROWER = { driving = 8,  harvesting = 10, technical = 5 },
    MULCH     = { driving = 10, harvesting = 0,  technical = 6 },
    STONES    = { driving = 8,  harvesting = 0,  technical = 10 },
    ROLL      = { driving = 10, harvesting = 0,  technical = 4 },
    WEED      = { driving = 8,  harvesting = 0,  technical = 8 },
    RIDGING   = { driving = 10, harvesting = 5,  technical = 5 },
    MULCH_LEAVES = { driving = 8, harvesting = 0, technical = 6 },
    DEFAULT   = { driving = 10, harvesting = 0,  technical = 5 },
}

---Returns XP needed to go from `level` to `level+1`
---@param level number Current level (1-9)
---@return number XP required for next level
function SkillSystem.getXPNeeded(level)
    if level >= SkillSystem.MAX_LEVEL then
        return 0
    end
    return math.floor(SkillSystem.XP_BASE * SkillSystem.XP_EXPONENT ^ (level - 1))
end

---Returns cumulative XP needed to reach a given level from level 1
---@param targetLevel number
---@return number
function SkillSystem.getCumulativeXP(targetLevel)
    local total = 0
    for lvl = 1, targetLevel - 1 do
        total = total + SkillSystem.getXPNeeded(lvl)
    end
    return total
end

---Adds experience to a skill, handles level-ups, returns true if leveled up
---@param employee table Employee instance
---@param skillName string "driving", "harvesting", or "technical"
---@param amount number Raw XP to add (before trait multipliers)
---@return boolean leveledUp
function SkillSystem.addExperience(employee, skillName, amount)
    if employee.skills[skillName] == nil then return false end
    if employee.skills[skillName] >= SkillSystem.MAX_LEVEL then return false end

    local xpMult = TraitSystem.getMultiplier(employee.traits, "xpMult")
    employee.skillXP[skillName] = (employee.skillXP[skillName] or 0) + (amount * xpMult)

    local leveledUp = false
    local xpNeeded = SkillSystem.getXPNeeded(employee.skills[skillName])

    while employee.skillXP[skillName] >= xpNeeded and employee.skills[skillName] < SkillSystem.MAX_LEVEL do
        employee.skillXP[skillName] = employee.skillXP[skillName] - xpNeeded
        employee.skills[skillName] = employee.skills[skillName] + 1
        leveledUp = true

        CustomUtils:info("[SkillSystem] %s leveled up %s to level %d!", employee.name, skillName, employee.skills[skillName])
        g_messageCenter:publish(MessageType.EMPLOYEE_SKILL_LEVELUP, employee, skillName, employee.skills[skillName])

        if employee.skills[skillName] >= SkillSystem.MAX_LEVEL then
            employee.skillXP[skillName] = 0
            break
        end
        xpNeeded = SkillSystem.getXPNeeded(employee.skills[skillName])
    end

    return leveledUp
end

---Returns XP rates for a given work type
---@param workType string
---@return table {driving=N, harvesting=N, technical=N}
function SkillSystem.getXPRates(workType)
    return SkillSystem.XP_RATES[workType] or SkillSystem.XP_RATES.DEFAULT
end

return SkillSystem
