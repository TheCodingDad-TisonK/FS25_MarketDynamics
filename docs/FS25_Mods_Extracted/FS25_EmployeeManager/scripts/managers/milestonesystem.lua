---@class MilestoneSystem
--- Subscribes to EMPLOYEE_SKILL_LEVELUP and triggers milestone effects.
--- Milestones at levels 3 (Apprentice), 5 (Companion), 7 (Expert), 10 (Master).
MilestoneSystem = {}

MilestoneSystem.MILESTONES = {
    [3]  = { titleKey = "em_milestone_apprentice",  notify = true },
    [5]  = { titleKey = "em_milestone_companion",   notify = true, wageBump = 0.05 },
    [7]  = { titleKey = "em_milestone_expert",      notify = true },
    [10] = { titleKey = "em_milestone_master",      notify = true, wageBump = 0.05 },
}

---Returns the highest milestone title key for a given skill level
---@param level number
---@return string|nil titleKey
function MilestoneSystem.getMilestoneTitle(level)
    local best = nil
    for mlevel, data in pairs(MilestoneSystem.MILESTONES) do
        if level >= mlevel then
            if best == nil or mlevel > best then
                best = mlevel
            end
        end
    end
    if best then
        return MilestoneSystem.MILESTONES[best].titleKey
    end
    return nil
end

---Returns the highest milestone level reached by any skill
---@param employee table
---@return number Best milestone level across all skills
function MilestoneSystem.getBestMilestoneLevel(employee)
    local best = 0
    for _, skillName in ipairs(SkillSystem.SKILL_NAMES) do
        local level = employee.skills[skillName] or 1
        if level > best then
            best = level
        end
    end
    return best
end

---Called when an employee levels up a skill
---@param employee table
---@param skillName string
---@param newLevel number
function MilestoneSystem.onSkillLevelUp(employee, skillName, newLevel)
    local milestone = MilestoneSystem.MILESTONES[newLevel]
    if milestone == nil then return end

    local skillDisplayName = g_i18n:getText("em_skill_" .. skillName)
    local milestoneTitle = g_i18n:getText(milestone.titleKey)

    if milestone.wageBump then
        employee.milestoneWageMult = (employee.milestoneWageMult or 1.0) + milestone.wageBump
        CustomUtils:info("[MilestoneSystem] %s reached %s in %s! Wage multiplier now %.2f",
            employee.name, milestoneTitle, skillDisplayName, employee.milestoneWageMult)
    end

    if milestone.notify and g_currentMission and g_currentMission.hud then
        local msg = string.format(g_i18n:getText("em_milestone_reached"),
            employee.name, skillDisplayName, newLevel, milestoneTitle)
        g_currentMission:showBlinkingWarning(msg, 6000)
    end

    g_messageCenter:publish(MessageType.EMPLOYEE_ADDED)
end

function MilestoneSystem.init()
    g_messageCenter:subscribe(MessageType.EMPLOYEE_SKILL_LEVELUP, MilestoneSystem.onSkillLevelUp, MilestoneSystem)
    CustomUtils:info("[MilestoneSystem] Initialized and subscribed to EMPLOYEE_SKILL_LEVELUP")
end
