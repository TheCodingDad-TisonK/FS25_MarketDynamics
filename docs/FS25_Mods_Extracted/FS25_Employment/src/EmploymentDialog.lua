EmploymentDialog = {}
EmploymentDialog.INSTANCE = nil

local employmentDialog_mt = Class(EmploymentDialog, MessageDialog)
local modDirectory = g_currentModDirectory

function EmploymentDialog.register(employmentSystem)
    local dialog = EmploymentDialog.new()
    dialog.employmentSystem = employmentSystem
    g_gui:loadGui(modDirectory .. "gui/EmploymentDialog.xml", "EmploymentDialog", dialog)
    EmploymentDialog.INSTANCE = dialog
end


function EmploymentDialog.new(target, customMt)
    local dialog = MessageDialog.new(target, customMt or employmentDialog_mt)

    dialog.currentlySelectedJob = nil
    dialog.placeable = nil
    dialog.player = nil
    dialog.jobs = nil

    return dialog
end


function EmploymentDialog:onGuiSetupFinished()
    EmploymentDialog:superClass().onGuiSetupFinished(self)

    FocusManager:linkElements(self.jobList, FocusManager.TOP, nil)
    FocusManager:linkElements(self.jobList, FocusManager.BOTTOM, nil)
end


function EmploymentDialog.createFromExistingGui(gui)

    EmploymentDialog.register()
    EmploymentDialog.show()

end


function EmploymentDialog.show(placeable, player)

    if EmploymentDialog.INSTANCE == nil then EmploymentDialog.register() end

    if placeable == nil or placeable.spec_employer == nil then return end

    local dialog = EmploymentDialog.INSTANCE

    dialog.placeable = placeable
    dialog.player = player
    dialog.jobs = {}
    dialog:setDialogType(DialogElement.TYPE_INFO)
    dialog:updateScreen()

    g_gui:showDialog("EmploymentDialog")

end


function EmploymentDialog:onOpen()
    EmploymentDialog:superClass().onOpen(self)
end


function EmploymentDialog:onClose()
    EmploymentDialog:superClass().onClose(self)
end


function EmploymentDialog:onCreate()
    EmploymentDialog:superClass().onCreate(self)
    self:setDialogType(DialogElement.Type_INFO)
end


function EmploymentDialog:onClickBack()
    self:close()
end


function EmploymentDialog:updateScreen()

    local baseJobs = self.placeable:getJobs()
    local jobs = {}

    for _, jobIndex in ipairs(baseJobs) do table.insert(jobs, EmploymentSystem.JOB_INDEX_TO_JOB[jobIndex]) end

    self.jobs = jobs

    self.jobList:reloadData()
    self:setSelectionState(1)

    local player = self.employmentSystem:getPlayer(self.player)

    if player ~= nil and player.job ~= nil and player.job.placeableId == self.placeable.uniqueId then

        local job = player.job
        local baseJob = EmploymentSystem.JOB_INDEX_TO_JOB[job.index]

        self.currentJobJobTitle:setText(job.seniority == 0 and baseJob.title or (EmploymentSystem.SUB_PROMOTION_INDEX_TO_SUB_PROMOTIONS[baseJob.subPromotionIndex][job.seniority].title .. " " .. baseJob.title))
        self.currentJobHours:setText(string.format("%s %s", baseJob.hours, g_i18n:getText("employment_ui_" .. (baseJob.hours == 1 and "hour" or "hours"))))
        self.currentJobSalary:setText(g_i18n:formatMoney(job.salary, 0, true, true))

        local expectedPay = 0
        if job.workedHours > 0 then expectedPay = (job.salary / 12) * (job.workedHours / baseJob.hours) end

        self.currentJobExpectedPay:setText(g_i18n:formatMoney(expectedPay, 0, true, true))
        self.currentJobWorkedHours:setText(string.format("%.1f %s", job.workedHours, g_i18n:getText("employment_ui_" .. (job.workedHours == 1 and "hour" or "hours"))))

        local startYear, startMonth, currentYear, currentMonth = job.startYear, job.startMonth, self.employmentSystem:getCurrentYear(), self.employmentSystem:getCurrentMonth()

        local years, months = 0, (currentYear * 12 + currentMonth) - (startYear * 12 + startMonth)

        local experience

        while months >= 12 do
            months = months - 12
            years = years + 1
        end

        if years == 0 then
            experience = g_i18n:formatNumMonth(months)
        elseif months == 0 then
            experience = string.format("%s %s", years, g_i18n:getText("employment_ui_" .. (years == 1 and "year" or "years")))
        else
            experience = string.format("%s %s, %s", years, g_i18n:getText("employment_ui_" .. (years == 1 and "year" or "years")), g_i18n:formatNumMonth(months))
        end

        self.currentJobExperience:setText(experience)

    end

    local placeable = self.placeable

    if placeable.spec_employer ~= nil then

        local spec = placeable.spec_employer
        local factor = spec.satisfaction

        local textFactor = "extremelyLow"
        local textColor = { 1, 0, 0, 1 }

        if factor >= 0.95 then
            textFactor = "extremelyHigh"
            textColor = { 0, 1, 0, 1 }
        elseif factor >= 0.8 then
            textFactor = "veryHigh"
            textColor = { 0.12, 0.88, 0, 1 }
        elseif factor >= 0.6 then
            textFactor = "high"
            textColor = { 0.3, 0.7, 0, 1 }
        elseif factor >= 0.4 then
            textFactor = "average"
            textColor = { 0.5, 0.5, 0, 1 }
        elseif factor >= 0.2 then
            textFactor = "low"
            textColor = { 0.7, 0.3, 0, 1 }
        elseif factor >= 0.05 then
            textFactor = "veryLow"
            textColor = { 0.88, 0.12, 0, 1 }
        end

        self.currentJobSatisfaction:setText(g_i18n:getText("employment_ui_factor_" .. textFactor))
        self.currentJobSatisfaction:setTextColor(textColor[1], textColor[2], textColor[3], textColor[4])



        factor = spec.tolerance
        textFactor = "extremelyLow"
        textColor = { 1, 0, 0, 1 }

        if factor >= 1.65 then
            textFactor = "extremelyHigh"
            textColor = { 0, 1, 0, 1 }
        elseif factor >= 1.5 then
            textFactor = "veryHigh"
            textColor = { 0.12, 0.88, 0, 1 }
        elseif factor >= 1.25 then
            textFactor = "high"
            textColor = { 0.3, 0.7, 0, 1 }
        elseif factor >= 0.75 then
            textFactor = "average"
            textColor = { 0.5, 0.5, 0, 1 }
        elseif factor >= 0.5 then
            textFactor = "low"
            textColor = { 0.7, 0.3, 0, 1 }
        elseif factor >= 0.35 then
            textFactor = "veryLow"
            textColor = { 0.88, 0.12, 0, 1 }
        end

        self.businessInfoTitle:setText(EmploymentSystem.BUSINESS_TYPE_TO_BUSINESS[spec.type].title)
        self.businessInfoTolerance:setText(g_i18n:getText("employment_ui_factor_" .. textFactor))
        self.businessInfoTolerance:setTextColor(textColor[1], textColor[2], textColor[3], textColor[4])

        factor = spec.prosperity
        textFactor = "extremelyLow"
        textColor = { 1, 0, 0, 1 }

        if factor >= 1.65 then
            textFactor = "extremelyHigh"
            textColor = { 0, 1, 0, 1 }
        elseif factor >= 1.5 then
            textFactor = "veryHigh"
            textColor = { 0.12, 0.88, 0, 1 }
        elseif factor >= 1.25 then
            textFactor = "high"
            textColor = { 0.3, 0.7, 0, 1 }
        elseif factor >= 0.75 then
            textFactor = "average"
            textColor = { 0.5, 0.5, 0, 1 }
        elseif factor >= 0.5 then
            textFactor = "low"
            textColor = { 0.7, 0.3, 0, 1 }
        elseif factor >= 0.35 then
            textFactor = "veryLow"
            textColor = { 0.88, 0.12, 0, 1 }
        end

        self.businessInfoProsperity:setText(g_i18n:getText("employment_ui_factor_" .. textFactor))
        self.businessInfoProsperity:setTextColor(textColor[1], textColor[2], textColor[3], textColor[4])

        local isFired = not placeable:getCanApplyAtBusiness(player)
        self.businessInfoFired:setText(g_i18n:getText("employment_ui_" .. (isFired and "yes" or "no")))
        self.businessInfoFired:setTextColor(unpack(isFired and { 1, 0, 0, 1 } or { 0, 1, 0, 1 }))

    end

    self.currentJobInfoContainer:setVisible(player ~= nil and player.job ~= nil and player.job.placeableId == placeable.uniqueId)
    self.currentJobInfoContainerNoJob:setVisible(player == nil or player.job == nil or player.job.placeableId ~= placeable.uniqueId)


end


function EmploymentDialog:setSelectionState(index)

    local placeable = self.placeable
    local employmentSystem = self.employmentSystem
    local player = employmentSystem:getPlayer(self.player)

    if index == 0 or self.jobs[index] == nil then
        self.currentlySelectedJob = 0
        self.applyButton:setDisabled(true)
        self.workPartTimeButton:setDisabled(true)
        self.workButton:setDisabled(player == nil or player.job == nil or player.job.placeableId ~= placeable.uniqueId)
        self.quitButton:setDisabled(player == nil or player.job == nil or player.job.placeableId ~= placeable.uniqueId)
        return
    end

    local job = self.jobs[index]

    self.applyButton:setDisabled((player == nil and (job.education > 0 or job.experience > 0)) or (player ~= nil and ((placeable.spec_employer ~= nil and not placeable:getCanApplyAtBusiness(player)) or (player.education == nil and job.education >= 1) or (player.experience == nil and job.experience >= 1) or (player.education ~= nil and player.education < job.education) or (player.experience ~= nil and player.experience < job.experience) or (player.job ~= nil and player.job.index == job.index and player.job.placeableId == placeable.uniqueId))))

    self.workButton:setDisabled(player == nil or player.job == nil or player.job.placeableId ~= placeable.uniqueId)

    self.workPartTimeButton:setDisabled(self.applyButton.disabled or not job.partTimeAvailable)

    self.quitButton:setDisabled(player == nil or player.job == nil or player.job.placeableId ~= placeable.uniqueId)

    self.currentlySelectedJob = index
    if self.jobList.selectedIndex ~= index then self.jobList:setSelectedItem(1, index) end

end


function EmploymentDialog:populateCellForItemInSection(_, _, index, cell)

    local job = self.jobs[index]
    if job == nil then return end

    if cell.name == "sectionCell" then cell:getAttribute("title"):setText("Jobs") end

    local salaryCell = cell:getAttribute("salary")
    local educationCell = cell:getAttribute("education")
    local hoursCell = cell:getAttribute("hours")
    local experienceCell = cell:getAttribute("experience")

    local prosperity = 1
    if self.placeable.spec_employer ~= nil then prosperity = self.placeable.spec_employer.prosperity or 1 end

    local salary = job.baseSalary * 0.6 + job.baseSalary * 0.4 * prosperity

    cell:getAttribute("name"):setText((job.baseSeniority == nil and "" or (EmploymentSystem.SUB_PROMOTION_INDEX_TO_SUB_PROMOTIONS[job.subPromotionIndex][job.baseSeniority].title .. " ")) .. job.title)
    salaryCell:setValue(salary)
    salaryCell:setText(g_i18n:formatMoney(salary, 0, true, true))
    educationCell:setText(EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION[job.education].title)
    hoursCell:setText(string.format("%s", job.hours))
    experienceCell:setText(string.format("%s", job.experience) .. " " .. (job.experience == 1 and g_i18n:getText("employment_ui_year") or g_i18n:getText("employment_ui_years")))

    salaryCell:setSize(salaryCell:getTextWidth() + cell:getAttribute("salaryTitle"):getTextWidth())
    educationCell:setSize(educationCell:getTextWidth() + cell:getAttribute("educationTitle"):getTextWidth())
    hoursCell:setSize(hoursCell:getTextWidth() + cell:getAttribute("hoursTitle"):getTextWidth())
    experienceCell:setSize(experienceCell:getTextWidth() + cell:getAttribute("experienceTitle"):getTextWidth())

    local player = self.employmentSystem:getPlayer(self.player)
    local playerEducation = player == nil and 0 or player.education or 0
    local playerExperience = player == nil and 0 or player.experience or 0

    cell:setDisabled(playerEducation < job.education or playerExperience < job.experience or not self.placeable:getCanApplyAtBusiness(player))

end


function EmploymentDialog:getTitleForSectionHeader(_, _)
    return "Jobs"
end


function EmploymentDialog:getNumberOfItemsInSection(_, _)
    if self.placeable == nil or self.placeable.spec_employer == nil then return 0 end

    local spec = self.placeable.spec_employer

    return #spec.jobs or 0
end


function EmploymentDialog:onListSelectionChanged(item, _, index)

    self:setSelectionState(item:getIsDisabled() and 0 or index)

end


function EmploymentDialog:onClickJobItem(item)
    self:setSelectionState(item:getIsDisabled() and 0 or item.indexInSection)
end


function EmploymentDialog:onClickApply(_)

    local job = self.jobs[self.currentlySelectedJob]
    if job == nil then return end

    YesNoDialog.show(EmploymentDialog.callback, nil, string.format(g_i18n:getText("employment_ui_confirmApply"), job.title), g_i18n:getText("employment_ui_confirm"), nil, nil, nil, nil, nil, { 1, job })

end


function EmploymentDialog:onClickWorkPartTime(_)

    local job = self.jobs[self.currentlySelectedJob]
    local spec = self.placeable.spec_employer

    if job == nil or spec == nil then return end

    self:close()

    self.employmentSystem:openWorkHoursDialog(self.player, EmploymentDialog.callback, 3, job.baseSalary * 0.6 + job.baseSalary * 0.4 * spec.prosperity, job.hours)

end


function EmploymentDialog:onClickWork(_)

    self:close()
    self.employmentSystem:openWorkHoursDialog(self.player, EmploymentDialog.callback, 1)

end


function EmploymentDialog:onClickQuit(_)

    YesNoDialog.show(EmploymentDialog.callback, nil, g_i18n:getText("employment_ui_confirmQuit"), g_i18n:getText("employment_ui_confirm"), nil, nil, nil, nil, nil, { 2 })

end


function EmploymentDialog.callback(clickYes, args)

    local employmentSystem = g_currentMission.employmentSystem
    local placeable, player = employmentSystem:getCallbackPlaceable(), employmentSystem:getCallbackPlayer()

    if clickYes and args ~= nil and args[1] == 1 then

        local playerFull = employmentSystem:getPlayer(player)
        local job = args[2]

        local prosperity = 1

        if placeable.spec_employer ~= nil then prosperity = placeable.spec_employer.prosperity or 1 end

        job.salary = job.baseSalary * 0.6 + job.baseSalary * 0.4 * prosperity
        job.placeableId = placeable.uniqueId
        job.workedHours = 0
        job.seniority = (job.baseSeniority or 0) * 1
        job.startMonth = employmentSystem:getCurrentMonth()
        job.startYear = employmentSystem:getCurrentYear()
        playerFull.job = job

        employmentSystem:addPlayerJob(player, job)

    elseif clickYes and args ~= nil and args[1] == 2 then
        employmentSystem:quitJob(player)
    end

    EmploymentDialog.show(placeable, player)
end