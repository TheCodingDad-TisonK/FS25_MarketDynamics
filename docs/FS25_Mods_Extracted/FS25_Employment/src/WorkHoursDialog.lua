WorkHoursDialog = {}
WorkHoursDialog.INSTANCE = nil

local workHoursDialog_mt = Class(WorkHoursDialog, YesNoDialog)
local modDirectory = g_currentModDirectory


function WorkHoursDialog.register(employmentSystem)
    local dialog = WorkHoursDialog.new()
    dialog.employmentSystem = employmentSystem
    g_gui:loadGui(modDirectory .. "gui/WorkHoursDialog.xml", "WorkHoursDialog", dialog)
    WorkHoursDialog.INSTANCE = dialog
end


function WorkHoursDialog.show(player, callback, action, partTimeSalary, requiredHours)
    if WorkHoursDialog.INSTANCE == nil then WorkHoursDialog.register() end

    local dialog = WorkHoursDialog.INSTANCE
    if player == nil or (action == 1 and player.job == nil) then return end

    dialog.player = player
    dialog.callback = callback
    dialog.action = action or 1
    dialog.partTimeSalary = partTimeSalary or 0
    dialog.requiredHours = requiredHours or 4
    dialog:updateScreen()

    g_gui:showDialog("WorkHoursDialog")
end


function WorkHoursDialog.new(target, customMt)
    local self = YesNoDialog.new(target, customMt or workHoursDialog_mt)
    self.player = nil
    self.callback = nil
    self.selectedTargetTime = nil
    self.targetTimes = {}
    self.action = 1
    self.partTimeSalary = 0
    self.requiredHours = 4
    return self
end


function WorkHoursDialog.createFromExistingGui(gui, _)
    WorkHoursDialog.register()
    WorkHoursDialog.show()
end


function WorkHoursDialog:onOpen()
    WorkHoursDialog:superClass().onOpen(self)
end


function WorkHoursDialog:onClose()
    WorkHoursDialog:superClass().onClose(self)
    self:setDialogType(DialogElement.TYPE_QUESTION)
end


function WorkHoursDialog:onClickTargetTime(index)
    self.selectedTargetTime = index
end


function WorkHoursDialog:updateScreen()

    local environment = g_currentMission.environment
    local currentTime = environment:getMinuteOfDay()

    while currentTime % 30 ~= 0 do currentTime = currentTime + 1 end

    local maxTime = currentTime + 1440
    self.targetTimes = {}

    for time = currentTime + 30, maxTime, 30 do

        table.insert(self.targetTimes, time)

    end

    local defaultTime = currentTime + 180

    if self.action == 1 then

        local job = self.player.job
        local baseJob = EmploymentSystem.JOB_INDEX_TO_JOB[job.index]
        defaultTime = currentTime + (baseJob.hours - job.workedHours) * 60
        self.yesButton:setText(g_i18n:getText("employment_ui_work"))

    elseif self.action == 2 then

        self.yesButton:setText(g_i18n:getText("employment_ui_study"))

    elseif self.action == 3 then

        defaultTime = currentTime + 240
        self.yesButton:setText(g_i18n:getText("employment_ui_work"))

    end

    local counter = 0

    while defaultTime % 30 ~= 0 and counter < 30 do
        defaultTime = defaultTime + 1
        counter = counter + 1
    end

    self.selectedTargetTime = table.find(self.targetTimes, defaultTime) or 8

    local hourString = g_i18n:getText("employment_ui_hour")
    local hoursString = g_i18n:getText("employment_ui_hours")

    for i, targetTime in ipairs(self.targetTimes) do

        self.targetTimes[i] = Utils.formatTime(targetTime >= 1440 and targetTime - 1440 or targetTime) .. string.format(" (%s %s)", (targetTime - currentTime) / 60, i == 2 and hourString or hoursString)

    end

    self.targetTimeElement:setTexts(self.targetTimes)
    self.targetTimeElement:setState(self.selectedTargetTime)

end


function WorkHoursDialog:onClickYes(_)

    self:close()

    if self.action == 1 then
        self.employmentSystem:work(self.player.userId, self.selectedTargetTime / 2, self.callback)
    elseif self.action == 2 then
        self.employmentSystem:study(self.player.userId, self.selectedTargetTime / 2, self.callback)
    elseif self.action == 3 then
        self.employmentSystem:workPartTime(self.player.userId, self.selectedTargetTime / 2, self.callback, self.partTimeSalary or 0, self.requiredHours or 10)
    end

end


function WorkHoursDialog:onClickNo(_)

    self:close()

end