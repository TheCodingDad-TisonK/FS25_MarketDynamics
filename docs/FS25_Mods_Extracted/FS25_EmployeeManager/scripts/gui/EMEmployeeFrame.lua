EMEmployeeFrame = {}

local EMEmployeeFrame_mt = Class(EMEmployeeFrame, TabbedMenuFrameElement)

EMEmployeeFrame.LIST_TYPE = {
    AVAILABLE = 1,
    HIRED     = 2,
}

EMEmployeeFrame.MENU_ICON_SLICE_ID = 'EM_IconEmployee'

function EMEmployeeFrame:new()
    local self = TabbedMenuFrameElement.new(nil, EMEmployeeFrame_mt)
    self.employees       = {}
    self.currentListType = EMEmployeeFrame.LIST_TYPE.AVAILABLE
    self.menuButtonInfo  = {}
    return self
end

function EMEmployeeFrame:copyAttributes(src)
    EMEmployeeFrame:superClass().copyAttributes(self, src)
end

function EMEmployeeFrame:initialize()
    self.backButtonInfo = { inputAction = InputAction.MENU_BACK }
    self.hireButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACTIVATE,
        text        = g_i18n:getText("em_btn_hire"),
        callback    = function() self:onHireEmployee() end,
    }
    self.fireButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_2,
        text        = g_i18n:getText("em_btn_fire"),
        callback    = function() self:onFireEmployee() end,
    }
    self.editWorkflowButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_1,
        text        = g_i18n:getText("em_btn_workflow_editor"),
        callback    = function() self:onEditWorkflow() end,
    }
    self.trainButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_3,
        text        = g_i18n:getText("em_btn_train"),
        callback    = function() self:onTrainEmployee() end,
    }

    local switcherTexts = {
        g_i18n:getText("em_list_new"),
        g_i18n:getText("em_list_owned"),
    }
    self.listSwitcher:setTexts(switcherTexts)
end

function EMEmployeeFrame:onGuiSetupFinished()
    EMEmployeeFrame:superClass().onGuiSetupFinished(self)
    self.employeeList:setDataSource(self)
    self.employeeList:setDelegate(self)
end

function EMEmployeeFrame:onFrameOpen()
    EMEmployeeFrame:superClass().onFrameOpen(self)
    self:rebuildTable()

    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.employeeList)
    self:setSoundSuppressed(false)
end

function EMEmployeeFrame:onFrameClose()
    EMEmployeeFrame:superClass().onFrameClose(self)
    self.employees = {}
end

function EMEmployeeFrame:refresh()
    -- Called by EMGui:onOpen() to pre-load data
end

function EMEmployeeFrame:getNumberOfSections()
    return 1
end

function EMEmployeeFrame:getNumberOfItemsInSection(list, section)
    return #self.employees
end

function EMEmployeeFrame:getTitleForSectionHeader(list, section)
    return ""
end

function EMEmployeeFrame:populateCellForItemInSection(list, section, index, cell)
    local emp = self.employees[index]
    if emp == nil then return end

    local titleEl    = cell:getAttribute("title")
    local subtitleEl = cell:getAttribute("subtitle")
    local avatarEl   = cell:getAttribute("avatar")
    local iconEl     = cell:getAttribute("icon")

    if avatarEl then
        avatarEl:setImageFilename(g_modDirectory .. "textures/assets/profil_male_1.png")
        avatarEl:setVisible(true)
    end
    if iconEl then
        iconEl:setVisible(false)
    end

    if titleEl then
        titleEl:setText(emp.name or "???")
    end

    if subtitleEl then
        local hourly = emp.getHourlyWage and emp:getHourlyWage() or 0
        local traitName = emp.getTraitName and emp:getTraitName() or ""
        if emp.isHired then
            local statusText
            if emp.isUnpaid then
                statusText = g_i18n:getText("em_status_unpaid")
            elseif emp.isOnBreak then
                statusText = g_i18n:getText("em_status_on_break")
            elseif emp.currentJob then
                local jobType = emp.currentJob.type
                if jobType == "RETURN_TO_PARKING" then
                    statusText = g_i18n:getText("em_status_returning")
                elseif jobType == "DRIVING_TO_TOOL" then
                    statusText = g_i18n:getText("em_status_driving_to_tool")
                elseif jobType == "APPROACHING_TOOL" or jobType == "ATTACHING_TOOL" then
                    statusText = g_i18n:getText("em_status_attaching_tool")
                elseif jobType == "RETURNING_TOOL" then
                    statusText = g_i18n:getText("em_status_returning_tool")
                else
                    statusText = emp.currentJob.workType or "Working"
                end
            else
                statusText = "Idle"
            end
            subtitleEl:setText(string.format("%s | %s | %s/h", statusText, traitName, g_i18n:formatMoney(hourly, 0, true, false)))
        else
            subtitleEl:setText(string.format("%s | %s/h", traitName, g_i18n:formatMoney(hourly, 0, true, false)))
        end
    end
end

function EMEmployeeFrame:onListSelectionChanged(list, section, index)
    self:displayEmployeeDetails(index)
    self:updateMenuButtons()
end

function EMEmployeeFrame:onSwitchList()
    self.currentListType = self.listSwitcher:getState()
    self:rebuildTable()
end

function EMEmployeeFrame:rebuildTable()
    if g_employeeManager == nil then
        self.employees = {}
    elseif self.currentListType == EMEmployeeFrame.LIST_TYPE.AVAILABLE then
        self.employees = g_employeeManager:getAvailableEmployees()
    else
        self.employees = g_employeeManager:getHiredEmployees()
    end

    self.employeeList:reloadData()

    local hasItems = #self.employees > 0

    if self.employeesContainer then
        self.employeesContainer:setVisible(hasItems)
    end
    if self.noEmployeesContainer then
        self.noEmployeesContainer:setVisible(not hasItems)
    end

    -- Hide detail panels when rebuilding
    if self.detailPanel then self.detailPanel:setVisible(false) end
    if self.rightPanel then self.rightPanel:setVisible(false) end
    if self.columnSeparator then self.columnSeparator:setVisible(false) end
    if self.noSelectedText then self.noSelectedText:setVisible(not hasItems) end

    if hasItems then
        self.employeeList:setSelectedIndex(1, true, 0)
        self:displayEmployeeDetails(1)
    else
        self:clearDetails()
    end

    if self.txtPoolRefresh then
        if self.currentListType == EMEmployeeFrame.LIST_TYPE.AVAILABLE and g_employeeManager then
            local days = g_employeeManager:getDaysUntilPoolRefresh()
            self.txtPoolRefresh:setVisible(true)
            self.txtPoolRefresh:setText(string.format(g_i18n:getText("em_pool_refresh_in"), days))
        else
            self.txtPoolRefresh:setVisible(false)
        end
    end

    self:updateMenuButtons()
end

function EMEmployeeFrame:setStatusBarValue(barElement, value)
    if barElement == nil or barElement.parent == nil then return end
    local fullWidth = barElement.parent.absSize[1] - (barElement.margin[1] or 0) * 2
    local minSize = 0
    if barElement.startSize ~= nil then
        minSize = barElement.startSize[1] + barElement.endSize[1]
    end
    local clampedValue = math.max(0, math.min(1, value))
    barElement:setSize(math.max(minSize, fullWidth * clampedValue), nil)
end

function EMEmployeeFrame:displayEmployeeDetails(index)
    local emp = self.employees[index]
    if emp == nil then
        self:clearDetails()
        return
    end

    -- Show detail panels
    if self.detailPanel then self.detailPanel:setVisible(true) end
    if self.rightPanel then self.rightPanel:setVisible(true) end
    if self.columnSeparator then self.columnSeparator:setVisible(true) end
    if self.noSelectedText then self.noSelectedText:setVisible(false) end

    -- Portrait
    if self.detailAvatar then
        self.detailAvatar:setImageFilename(g_modDirectory .. "textures/assets/profil_male_1.png")
    end

    -- Identity
    if self.txtName then self.txtName:setText(emp.name) end
    if self.txtId then self.txtId:setText(string.format("ID: %d", emp.id)) end

    -- Status
    if self.txtStatus then
        local statusKey = emp.isHired and "em_status_hired" or "em_status_available"
        self.txtStatus:setText(g_i18n:getText(statusKey))
    end

    -- Skills with progress bars
    self:displaySkills(emp)

    -- Traits
    if self.txtTraitsList then
        local traitName = emp.getTraitName and emp:getTraitName() or nil
        self.txtTraitsList:setText(traitName or g_i18n:getText("em_none"))
    end

    -- Wage
    if self.txtWage then
        local hourly = emp.getHourlyWage and emp:getHourlyWage() or 0
        local marketMult = 1.0
        if g_employeeManager then
            marketMult = g_employeeManager:getMarketMultiplier()
        end
        local finalWage = hourly * marketMult
        self.txtWage:setText(string.format("%s/h", g_i18n:formatMoney(finalWage, 0, true, false)))
    end

    if self.txtWageBreakdown then
        local base = emp.getBaseHourlyWage and emp:getBaseHourlyWage() or 0
        local traitMult = emp.getTraitMultiplier and emp:getTraitMultiplier("wageMult") or 1.0
        local expMult = math.min(1.25, 1.0 + ((emp.workTime or 0) / 500))
        local marketMult = g_employeeManager and g_employeeManager:getMarketMultiplier() or 1.0
        local milestoneMult = emp.milestoneWageMult or 1.0
        local parts = string.format(
            "%s: $%d | %s: x%.2f | %s: x%.2f | %s: x%.2f",
            g_i18n:getText("em_wage_base"), base,
            g_i18n:getText("em_wage_trait"), traitMult,
            g_i18n:getText("em_wage_exp"), expMult,
            g_i18n:getText("em_wage_market"), marketMult
        )
        if milestoneMult > 1.0 then
            parts = parts .. string.format(" | %s: x%.2f", g_i18n:getText("em_wage_milestone"), milestoneMult)
        end
        self.txtWageBreakdown:setText(parts)
    end

    -- Toggle Column 3 content based on hired/available
    local isHired = emp.isHired
    if self.hiredInfoSection then self.hiredInfoSection:setVisible(isHired) end
    if self.availableInfoSection then self.availableInfoSection:setVisible(not isHired) end

    if isHired then
        self:displayWorkStats(emp)
        self:displayPerformanceStats(emp)

        -- Workflow summary
        if self.txtWorkflowSummary then
            local queue = emp.taskQueue or {}
            if #queue > 0 then
                local queueParts = {}
                for i, taskName in ipairs(queue) do
                    table.insert(queueParts, string.format("%d. %s", i, taskName))
                end
                self.txtWorkflowSummary:setText(table.concat(queueParts, " > "))
            else
                self.txtWorkflowSummary:setText(g_i18n:getText("em_none"))
            end
        end
    else
        self:displayPersonalInfo(emp)
    end
end

function EMEmployeeFrame:displaySkills(employee)
    local skills  = employee.skills   or { driving = 1, harvesting = 1, technical = 1 }
    local maxLevel = SkillSystem.MAX_LEVEL

    local skillDefs = {
        { key = "driving",    barId = "barSkillDriving",    levelId = "txtSkillDrivingLevel" },
        { key = "harvesting", barId = "barSkillHarvesting", levelId = "txtSkillHarvestingLevel" },
        { key = "technical",  barId = "barSkillTechnical",  levelId = "txtSkillTechnicalLevel" },
    }

    for _, def in ipairs(skillDefs) do
        local level = math.min(maxLevel, math.max(1, skills[def.key] or 1))
        local ratio = level / maxLevel

        local barElement = self[def.barId]
        if barElement then
            self:setStatusBarValue(barElement, ratio)
        end

        local levelElement = self[def.levelId]
        if levelElement then
            if level >= maxLevel then
                levelElement:setText("MAX")
            else
                levelElement:setText(string.format("%d/%d", level, maxLevel))
            end
        end
    end
end

function EMEmployeeFrame:displayPersonalInfo(employee)
    -- Age
    if self.txtPersonalAge then
        local age = employee.age or 30
        self.txtPersonalAge:setText(tostring(age))
    end

    -- Nationality
    if self.txtPersonalNationality then
        local natKey = "em_nationality_" .. (employee.nationality or "FR")
        local natText = g_i18n:getText(natKey)
        if natText == natKey then
            natText = employee.nationality or "FR"
        end
        self.txtPersonalNationality:setText(natText)
    end

    -- Biography
    if self.txtPersonalBio then
        local bioKey = employee.bioKey or "em_bio_default"
        local bioText = g_i18n:getText(bioKey)
        if bioText == bioKey then bioText = g_i18n:getText("em_bio_default") end
        self.txtPersonalBio:setText(bioText)
    end

    -- Quote
    if self.txtPersonalQuote then
        local quoteKey = employee.quoteKey or "em_quote_default"
        local quoteText = g_i18n:getText(quoteKey)
        if quoteText == quoteKey then quoteText = g_i18n:getText("em_quote_default") end
        self.txtPersonalQuote:setText("\"" .. quoteText .. "\"")
    end
end

function EMEmployeeFrame:displayWorkStats(employee)
    if self.statHoursWorked then
        local hours = employee.workTime or 0
        self.statHoursWorked:setText(string.format("%.1f h", hours))
    end

    if self.statKmDriven then
        self.statKmDriven:setText(string.format("%.1f km", employee.kmDriven or 0))
    end

    if self.statCurrentJob then
        if employee.currentJob then
            local jobType = employee.currentJob.workType or employee.currentJob.type or "Unknown"
            local jt = employee.currentJob.type
            if jt == "RETURN_TO_PARKING" then
                jobType = g_i18n:getText("em_status_returning")
            elseif jt == "DRIVING_TO_TOOL" then
                jobType = g_i18n:getText("em_status_driving_to_tool")
            elseif jt == "APPROACHING_TOOL" or jt == "ATTACHING_TOOL" then
                jobType = g_i18n:getText("em_status_attaching_tool")
            elseif jt == "RETURNING_TOOL" then
                jobType = g_i18n:getText("em_status_returning_tool")
            end
            local fieldId = employee.currentJob.fieldId
            if fieldId then
                self.statCurrentJob:setText(string.format("%s (Field %d)", jobType, fieldId))
            else
                self.statCurrentJob:setText(jobType)
            end
        else
            self.statCurrentJob:setText(g_i18n:getText("em_idle") or "Idle")
        end
    end

    if self.statFatigue then
        local fatigue = employee.fatigueLevel or 0
        self.statFatigue:setText(string.format("%.0f%%", fatigue))
        if fatigue >= 80 then
            self.statFatigue:setTextColor(1, 0.2, 0.2, 1)
        elseif fatigue >= 60 then
            self.statFatigue:setTextColor(1, 0.5, 0, 1)
        elseif fatigue >= 40 then
            self.statFatigue:setTextColor(1, 1, 0, 1)
        else
            self.statFatigue:setTextColor(0.2, 1, 0.2, 1)
        end
    end

    if self.statShift then
        self.statShift:setText(string.format("%d:00 - %d:00", employee.shiftStart or 6, employee.shiftEnd or 18))
    end

    if self.statFatigueStatus then
        if employee.isOnBreak then
            self.statFatigueStatus:setText(g_i18n:getText("em_status_on_break"))
            self.statFatigueStatus:setTextColor(1, 1, 0, 1)
            self.statFatigueStatus:setVisible(true)
        elseif (employee.dailyHoursWorked or 0) >= 8 then
            self.statFatigueStatus:setText(g_i18n:getText("em_status_exhausted"))
            self.statFatigueStatus:setTextColor(1, 0.2, 0.2, 1)
            self.statFatigueStatus:setVisible(true)
        elseif (employee.fatigueLevel or 0) >= 50 then
            self.statFatigueStatus:setText(g_i18n:getText("em_status_tired"))
            self.statFatigueStatus:setTextColor(1, 0.7, 0, 1)
            self.statFatigueStatus:setVisible(true)
        else
            self.statFatigueStatus:setVisible(false)
        end
    end

    if self.statParking then
        if g_parkingManager and employee.assignedVehicleId then
            local spot = g_parkingManager:getSpotForVehicle(employee.assignedVehicleId)
            if spot then
                self.statParking:setText(spot.name)
            else
                self.statParking:setText(g_i18n:getText("em_no_parking"))
            end
        else
            self.statParking:setText(g_i18n:getText("em_no_parking"))
        end
    end

    if self.statPendingWages then
        local pending = employee.pendingWages or 0
        self.statPendingWages:setText(g_i18n:formatMoney(pending, 0, true, false))
        if employee.isUnpaid then
            self.statPendingWages:setTextColor(1, 0.2, 0.2, 1)
        else
            self.statPendingWages:setTextColor(1, 1, 1, 1)
        end
    end

    if self.txtUnpaidWarning then
        if employee.isUnpaid then
            self.txtUnpaidWarning:setVisible(true)
            self.txtUnpaidWarning:setText(g_i18n:getText("em_unpaid_warning"))
            self.txtUnpaidWarning:setTextColor(1, 0.2, 0.2, 1)
        else
            self.txtUnpaidWarning:setVisible(false)
        end
    end
end

function EMEmployeeFrame:displayPerformanceStats(employee)
    if self.statTotalWages then
        local total = employee.totalWagesPaid or 0
        self.statTotalWages:setText(g_i18n:formatMoney(total, 0, true, false))
    end

    if self.statTasksCompleted then
        self.statTasksCompleted:setText(tostring(employee.tasksCompleted or 0))
    end

    if self.statAvgWage then
        local hours = employee.workTime or 0
        local total = employee.totalWagesPaid or 0
        if hours > 0 then
            self.statAvgWage:setText(string.format("%s/h", g_i18n:formatMoney(total / hours, 0, true, false)))
        else
            self.statAvgWage:setText("--")
        end
    end

    if self.statEfficiency then
        local hours = employee.workTime or 0
        local tasks = employee.tasksCompleted or 0
        if hours > 0 then
            self.statEfficiency:setText(string.format("%.2f", tasks / hours))
        else
            self.statEfficiency:setText("--")
        end
    end
end

function EMEmployeeFrame:clearDetails()
    if self.detailPanel then self.detailPanel:setVisible(false) end
    if self.rightPanel then self.rightPanel:setVisible(false) end
    if self.columnSeparator then self.columnSeparator:setVisible(false) end
end

function EMEmployeeFrame:updateMenuButtons()
    local hasSelection = #self.employees > 0 and self.employeeList.selectedIndex > 0

    self.menuButtonInfo = { self.backButtonInfo }

    if self.currentListType == EMEmployeeFrame.LIST_TYPE.AVAILABLE and hasSelection then
        table.insert(self.menuButtonInfo, self.hireButtonInfo)
    elseif self.currentListType == EMEmployeeFrame.LIST_TYPE.HIRED and hasSelection then
        table.insert(self.menuButtonInfo, self.fireButtonInfo)
        table.insert(self.menuButtonInfo, self.editWorkflowButtonInfo)
        table.insert(self.menuButtonInfo, self.trainButtonInfo)
    end

    self:setMenuButtonInfoDirty()
end

function EMEmployeeFrame:getMenuButtonInfo()
    return self.menuButtonInfo
end

function EMEmployeeFrame:getSelectedEmployee()
    local idx = self.employeeList.selectedIndex
    if idx == nil or idx < 1 then return nil end
    return self.employees[idx]
end

function EMEmployeeFrame:onHireEmployee()
    local emp = self:getSelectedEmployee()
    if emp == nil then return end
    YesNoDialog.show(
        function(_, yes)
            if yes then
                g_employeeManager:hireEmployee(emp.id)
                self:rebuildTable()
            end
        end,
        self,
        string.format(g_i18n:getText("em_dialog_hire_yes_no"), emp.name),
        g_i18n:getText("em_dialog_hire_yes_no_btn")
    )
end

function EMEmployeeFrame:onFireEmployee()
    local emp = self:getSelectedEmployee()
    if emp == nil then return end
    YesNoDialog.show(
        function(_, yes)
            if yes then
                g_employeeManager:fireEmployee(emp.id)
                self:rebuildTable()
            end
        end,
        self,
        string.format(g_i18n:getText("em_dialog_fire_yes_no"), emp.name),
        g_i18n:getText("em_dialog_fire_yes_no_btn")
    )
end

function EMEmployeeFrame:onEditWorkflow()
    local emp = self:getSelectedEmployee()
    if emp == nil then return end

    local parentGui = self:getParent()
    while parentGui ~= nil and parentGui.pagingElement == nil do
        parentGui = parentGui:getParent()
    end

    if parentGui and parentGui.pagingElement then
        parentGui.pagingElement:setPage(2)
    end
end

function EMEmployeeFrame:onTrainEmployee()
    local emp = self:getSelectedEmployee()
    if emp == nil then return end

    if g_emTrainingDialog then
        g_emTrainingDialog:setEmployee(emp)
        g_gui:showDialog("EMTrainingDialog")
    end
end
