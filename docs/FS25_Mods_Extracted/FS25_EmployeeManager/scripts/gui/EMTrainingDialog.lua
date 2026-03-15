---@class EMTrainingDialog
EMTrainingDialog = {}

local EMTrainingDialog_mt = Class(EMTrainingDialog, MessageDialog)

function EMTrainingDialog.new(target, custom_mt)
    local self = MessageDialog.new(target, custom_mt or EMTrainingDialog_mt)
    self.employee = nil
    return self
end

function EMTrainingDialog:onCreate()
    EMTrainingDialog:superClass().onCreate(self)
end

function EMTrainingDialog:setEmployee(employee)
    self.employee = employee
end

function EMTrainingDialog:onDialogOpen()
    self:updateDisplay()
end

function EMTrainingDialog:onDialogClose()
end

function EMTrainingDialog:updateDisplay()
    local emp = self.employee
    if emp == nil then return end

    if self.txtEmployeeName then
        self.txtEmployeeName:setText(emp.name)
    end

    local currentDay = 0
    if g_currentMission and g_currentMission.environment then
        currentDay = g_currentMission.environment.currentDay or 0
    end

    local maxLevel = SkillSystem.MAX_LEVEL

    local skillDefs = {
        { key = "driving",    levelId = "txtDrivingLevel",    costId = "txtDrivingCost",    statusId = "txtDrivingStatus" },
        { key = "harvesting", levelId = "txtHarvestingLevel", costId = "txtHarvestingCost", statusId = "txtHarvestingStatus" },
        { key = "technical",  levelId = "txtTechnicalLevel",  costId = "txtTechnicalCost",  statusId = "txtTechnicalStatus" },
    }

    for _, def in ipairs(skillDefs) do
        local level = emp.skills[def.key] or 1
        local filled = math.min(level, maxLevel)
        local bar = string.rep("#", filled) .. string.rep("-", maxLevel - filled)

        if self[def.levelId] then
            self[def.levelId]:setText(string.format("[%s] %d/%d", bar, level, maxLevel))
        end

        if self[def.costId] then
            if level >= maxLevel then
                self[def.costId]:setText("--")
            else
                local cost = emp:getTrainingCost(def.key)
                self[def.costId]:setText(g_i18n:formatMoney(cost, 0, true, false))
            end
        end

        if self[def.statusId] then
            local canDo, reason = emp:canTrain(def.key, currentDay)
            if canDo then
                self[def.statusId]:setText(g_i18n:getText("em_training_available"))
            elseif reason == "max_level" then
                self[def.statusId]:setText(g_i18n:getText("em_training_max"))
            elseif reason == "cooldown" then
                local cooldown = emp:getTrainingCooldown()
                local daysLeft = cooldown - (currentDay - emp.lastTrainingDay)
                self[def.statusId]:setText(string.format(g_i18n:getText("em_training_cooldown"), daysLeft))
            end
        end
    end

    if self.txtCooldownInfo then
        local cooldown = emp:getTrainingCooldown()
        local daysSince = currentDay - (emp.lastTrainingDay or 0)
        if emp.lastTrainingDay > 0 and daysSince < cooldown then
            self.txtCooldownInfo:setText(string.format(g_i18n:getText("em_training_wait"), cooldown - daysSince))
        else
            self.txtCooldownInfo:setText(g_i18n:getText("em_training_ready"))
        end
    end
end

function EMTrainingDialog:trainSkill(skillName)
    if self.employee == nil or g_employeeManager == nil then return end

    local ok, reason = g_employeeManager:trainEmployee(self.employee.id, skillName)
    if ok then
        g_gui:showInfoDialog({
            text = string.format(g_i18n:getText("em_training_success"),
                self.employee.name, g_i18n:getText("em_skill_" .. skillName), self.employee.skills[skillName])
        })
        self:updateDisplay()
    else
        local msg = g_i18n:getText("em_training_fail_" .. tostring(reason)) or reason
        g_gui:showInfoDialog({ text = msg })
    end
end

function EMTrainingDialog:onTrainDriving()
    self:trainSkill("driving")
end

function EMTrainingDialog:onTrainHarvesting()
    self:trainSkill("harvesting")
end

function EMTrainingDialog:onTrainTechnical()
    self:trainSkill("technical")
end

function EMTrainingDialog:onClickBack()
    g_gui:closeDialog()
end
