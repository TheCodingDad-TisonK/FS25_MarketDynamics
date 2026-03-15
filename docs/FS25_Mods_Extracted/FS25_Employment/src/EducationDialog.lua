EducationDialog = {}
EducationDialog.INSTANCE = nil

local educationDialog_mt = Class(EducationDialog, MessageDialog)
local modDirectory = g_currentModDirectory

function EducationDialog.register(employmentSystem)
    local dialog = EducationDialog.new()
    dialog.employmentSystem = employmentSystem
    g_gui:loadGui(modDirectory .. "gui/EducationDialog.xml", "EducationDialog", dialog)
    EducationDialog.INSTANCE = dialog
end


function EducationDialog.new(target, customMt)
    local dialog = MessageDialog.new(target, customMt or educationDialog_mt)

    dialog.player = nil
    dialog.examSuccess = nil

    return dialog
end


function EducationDialog:onGuiSetupFinished()
    EducationDialog:superClass().onGuiSetupFinished(self)
end


function EducationDialog.createFromExistingGui(gui)

    EducationDialog.register()
    EducationDialog.show()

end


function EducationDialog.show(player)

    if EducationDialog.INSTANCE == nil then EducationDialog.register() end

    if player == nil then return end

    local dialog = EducationDialog.INSTANCE

    dialog.player = player
    dialog:setDialogType(DialogElement.TYPE_INFO)
    dialog:updateScreen()

    g_gui:showDialog("EducationDialog")

end


function EducationDialog:onOpen()
    EducationDialog:superClass().onOpen(self)
end


function EducationDialog:onClose()
    EducationDialog:superClass().onClose(self)
end


function EducationDialog:onCreate()
    EducationDialog:superClass().onCreate(self)
    self:setDialogType(DialogElement.Type_INFO)
end


function EducationDialog:onClickBack()
    self:close()
end


function EducationDialog:updateScreen()

    local player = self.employmentSystem:getPlayer(self.player)
    local currentEducation = EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION[player.education]
    local nextEducation = EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION[player.education + 1]
    local progress = 0

    local startDiffText = "extremelyEasy"
    local startDiffColour = { 0, 1, 0, 1 }
    local endDiffText = "extremelyEasy"
    local endDiffColour = { 0, 1, 0, 1 }
    local startDiff
    local endDiff

    if nextEducation == nil then

        progress = 1
        self.progressStartText:setText(EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION[player.education - 1].title or "")
        self.progressEndText:setText(currentEducation.title)

        startDiff = EmploymentSystem.EDUCATION_INDEX_TO_EDUCATION[player.education - 1].difficulty
        endDiff = currentEducation.difficulty

    else


        if nextEducation.hours == 0 then
            progress = 1
        else
            progress = player.educationProgress / nextEducation.hours
        end

        startDiff = currentEducation.difficulty
        endDiff = nextEducation.difficulty

        self.progressStartText:setText(currentEducation.title)
        self.progressEndText:setText(nextEducation.title)

    end

    if startDiff >= 0.975 then
        startDiffText = "almostImpossible"
        startDiffColour = { 1, 0, 0, 1 }
    elseif startDiff >= 0.9 then
        startDiffText = "extremelyHard"
        startDiffColour = { 0.9, 0.1, 0, 1 }
    elseif startDiff >= 0.75 then
        startDiffText = "veryHard"
        startDiffColour = { 0.8, 0.2, 0, 1 }
    elseif startDiff >= 0.6 then
        startDiffText = "hard"
        startDiffColour = { 0.65, 0.35, 0, 1 }
    elseif startDiff >= 0.4 then
        startDiffText = "average"
        startDiffColour = { 0.5, 0.5, 0, 1 }
    elseif startDiff >= 0.25 then
        startDiffText = "easy"
        startDiffColour = { 0.35, 0.65, 0, 1 }
    elseif startDiff >= 0.1 then
        startDiffText = "veryEasy"
        startDiffColour = { 0.2, 0.8, 0, 1 }
    elseif startDiff > 0 then
        startDiffText = "extremelyEasy"
        startDiffColour = { 0.1, 0.9, 0, 1 }
    else
        startDiffText = ""
        startDiffColour = { 0, 1, 0, 1 }
    end

    if endDiff >= 0.975 then
        endDiffText = "almostImpossible"
        endDiffColour = { 1, 0, 0, 1 }
    elseif endDiff >= 0.9 then
        endDiffText = "extremelyHard"
        endDiffColour = { 0.9, 0.1, 0, 1 }
    elseif endDiff >= 0.75 then
        endDiffText = "veryHard"
        endDiffColour = { 0.8, 0.2, 0, 1 }
    elseif endDiff >= 0.6 then
        endDiffText = "hard"
        endDiffColour = { 0.65, 0.35, 0, 1 }
    elseif endDiff >= 0.4 then
        endDiffText = "average"
        endDiffColour = { 0.5, 0.5, 0, 1 }
    elseif endDiff >= 0.25 then
        endDiffText = "easy"
        endDiffColour = { 0.35, 0.65, 0, 1 }
    elseif endDiff >= 0.1 then
        endDiffText = "veryEasy"
        endDiffColour = { 0.2, 0.8, 0, 1 }
    elseif endDiff > 0 then
        endDiffText = "extremelyEasy"
        endDiffColour = { 0.1, 0.9, 0, 1 }
    else
        endDiffText = ""
        endDiffColour = { 0, 1, 0, 1 }
    end

    if startDiff ~= 0 then self.progressStartText:setText(string.format("%s (%s)", self.progressStartText.text, g_i18n:getText("employment_ui_difficulty_" .. startDiffText))) end
    if endDiff ~= 0 then self.progressEndText:setText(string.format("%s (%s)", self.progressEndText.text, g_i18n:getText("employment_ui_difficulty_" .. endDiffText))) end


    self.progressStartText:setTextColor(unpack(startDiffColour))
    self.progressEndText:setTextColor(unpack(endDiffColour))

    local scale = self.progressBarBg.size[1] - self.progressBar.margin[1] * 2
    self.progressBar:setSize(scale * math.min(progress, 1), nil)
    self.examButton:setText(g_i18n:getText("employment_ui_test"))

    if player.nextExamDay ~= nil then
        local currentDay = g_currentMission.environment.currentMonotonicDay
        local currentTime = g_currentMission.environment:getMinuteOfDay()

        if currentDay > player.nextExamDay or (currentDay == player.nextExamDay and currentTime >= player.nextExamTime) then
            player.nextExamDay = nil
            player.nextExamTime = nil
        else
            local timeLeft

            if player.nextExamDay == currentDay then
                timeLeft = player.nextExamTime - currentTime
            else
                timeLeft = 1440 - currentTime + player.nextExamTime
            end

            self.examButton:setText(g_i18n:getText("employment_ui_test") .. string.format(" (%.0fh)", timeLeft / 60))
        end
    end

    self.studyButton:setDisabled(progress >= 1)
    self.examButton:setDisabled(progress < 1 or nextEducation == nil or player.nextExamTime ~= nil or player.nextExamDay ~= nil)

    self.examResultText:setVisible(self.examSuccess ~= nil)

    if self.examSuccess ~= nil then
        self.examResultText:setText(g_i18n:getText("employment_ui_exam_" .. (self.examSuccess and "pass" or "fail")))
        self.examSuccess = nil
    end

end


function EducationDialog:onClickStudy(_)

    self:close()
    self.employmentSystem:openWorkHoursDialog(self.player, EducationDialog.callback, 2)

end


function EducationDialog:onClickExam(_)

    self.employmentSystem:startExam(self.player, EducationDialog.callback)

end


function EducationDialog.callback(success)

    local player = g_currentMission.employmentSystem:getCallbackPlayer()
    if success ~= nil then EducationDialog.INSTANCE.examSuccess = success end
    EducationDialog.show(player)

end