MenuEmployeeManager = {}

MenuEmployeeManager.CLASS_NAME = 'MenuEmployeeManager'
MenuEmployeeManager.MENU_PAGE_NAME = 'menuEmployeeManager'
MenuEmployeeManager.XML_FILENAME = g_modDirectory .. 'xml/gui/MenuEmployeeManager.xml'

MenuEmployeeManager.MENU_ICON_SLICE_ID = 'EM_IconMenu'

MenuEmployeeManager._mt = Class(MenuEmployeeManager, TabbedMenuFrameElement)

MenuEmployeeManager.LIST_TYPE = {
    NEW   = 1,
    OWNED = 2,
}

MenuEmployeeManager.LIST_STATE_TEXTS = {
    "em_list_new",
    "em_list_owned",
}

MenuEmployeeManager.HEADER_TITLE = "em_header_employees"

function MenuEmployeeManager.new()
    CustomUtils:debug("[MenuEmployeeManager] new()")
    local self = MenuEmployeeManager:superClass().new(nil, MenuEmployeeManager._mt)
    self.name      = "MenuEmployeeManager"
    self.className = "MenuEmployeeManager"

    self.menuButtonInfo = {}

    self.leftListRenderer = EmployeeRenderer.new(self)

    self.currentListType = MenuEmployeeManager.LIST_TYPE.NEW

    return self
end

function MenuEmployeeManager:onGuiSetupFinished()
    CustomUtils:debug("[MenuEmployeeManager] onGuiSetupFinished()")
    MenuEmployeeManager:superClass().onGuiSetupFinished(self)

    self.leftListTable:setDataSource(self.leftListRenderer)
    self.leftListTable:setDelegate(self.leftListRenderer)

    self.leftListRenderer.indexChangedCallback = function(index)
        self:onLeftListSelectionChanged(index)
    end
end

function MenuEmployeeManager:initialize()
    CustomUtils:debug("[MenuEmployeeManager] initialize()")
    MenuEmployeeManager:superClass().initialize(self)

    local switcherTexts = {}
    for _, textKey in ipairs(MenuEmployeeManager.LIST_STATE_TEXTS) do
        table.insert(switcherTexts, g_i18n:getText(textKey))
    end
    self.pageSwitcher:setTexts(switcherTexts)

    self.btnBack          = { inputAction = InputAction.MENU_BACK }
    self.btnHire          = { inputAction = InputAction.MENU_ACCEPT,  text = g_i18n:getText("em_btn_hire"),            callback = function() self:onHireEmployee() end }
    self.btnFire          = { inputAction = InputAction.MENU_EXTRA_2, text = g_i18n:getText("em_btn_fire"),            callback = function() self:onFireEmployee() end }
    self.btnOpenWorkflow  = { inputAction = InputAction.MENU_EXTRA_1, text = g_i18n:getText("em_btn_workflow_editor"), callback = function() self:onOpenWorkflowEditor() end }

    self.buttonSets = {
        [MenuEmployeeManager.LIST_TYPE.NEW]   = { self.btnBack, self.btnHire, self.btnOpenWorkflow },
        [MenuEmployeeManager.LIST_TYPE.OWNED] = { self.btnBack, self.btnFire, self.btnOpenWorkflow },
    }

    self.currentListType = self.pageSwitcher:getState() or MenuEmployeeManager.LIST_TYPE.NEW
    self:updateMenuButtons()
end

function MenuEmployeeManager:onFrameOpen()
    CustomUtils:debug("[MenuEmployeeManager] onFrameOpen()")
    MenuEmployeeManager:superClass().onFrameOpen(self)

    self:onMoneyChange()
    g_messageCenter:subscribe(MessageType.MONEY_CHANGED,    self.onMoneyChange,   self)
    g_messageCenter:subscribe(MessageType.EMPLOYEE_ADDED,   self.updateContent,   self)
    g_messageCenter:subscribe(MessageType.EMPLOYEE_REMOVED, self.updateContent,   self)

    self:updateContent()
end

function MenuEmployeeManager:onFrameClose()
    CustomUtils:debug("[MenuEmployeeManager] onFrameClose()")
    MenuEmployeeManager:superClass().onFrameClose(self)
    g_messageCenter:unsubscribeAll(self)
end

function MenuEmployeeManager:onSwitchPage()
    CustomUtils:debug("[MenuEmployeeManager] onSwitchPage()")
    self.currentListType = self.pageSwitcher:getState()
    self:updateContent()
end

function MenuEmployeeManager:updateContent()
    CustomUtils:debug("[MenuEmployeeManager] updateContent()")

    self.categoryHeaderText:setText(g_i18n:getText(MenuEmployeeManager.HEADER_TITLE))

    if g_employeeManager == nil then return end

    local available = g_employeeManager:getAvailableEmployees()
    local hired     = g_employeeManager:getHiredEmployees()

    local renderData = {
        [MenuEmployeeManager.LIST_TYPE.NEW]   = available,
        [MenuEmployeeManager.LIST_TYPE.OWNED] = hired,
    }

    self.leftListRenderer:setData(renderData)
    self.leftListTable:reloadData()

    local hasItem = self.leftListTable:getItemCount() > 0

    -- Toggle visibility of containers
    if self.employeesContainer then
        self.employeesContainer:setVisible(hasItem)
    end
    if self.noEmployeesContainer then
        self.noEmployeesContainer:setVisible(not hasItem)
    end

    self.detailPanelContainer:setVisible(false)
    self.personalPanelContainer:setVisible(false)
    if self.columnSeparator then self.columnSeparator:setVisible(false) end
    self.noSelectedText:setVisible(not hasItem)

    if hasItem then
        self.leftListTable:setSelectedIndex(1, true)
        self:onLeftListSelectionChanged(1)
    end

    self:updateMenuButtons()
end

function MenuEmployeeManager:onLeftListSelectionChanged(index)
    if index == nil or index < 1 then
        self.noSelectedText:setVisible(true)
        self.detailPanelContainer:setVisible(false)
        self.personalPanelContainer:setVisible(false)
        if self.columnSeparator then self.columnSeparator:setVisible(false) end
        return
    end

    local item = self:getSelectedItem()
    if item == nil then return end

    self.noSelectedText:setVisible(false)
    self:displayEmployeeDetails(item)

    self:updateMenuButtons()
end

function MenuEmployeeManager:getSelectedItem()
    local index = self.leftListTable.selectedIndex
    if index == nil or index < 1 then return nil end
    local data = self.leftListRenderer.data
    if data == nil then return nil end
    local list = data[self.currentListType]
    if list == nil then return nil end
    return list[index]
end

function MenuEmployeeManager:displayEmployeeDetails(employee)
    self.detailPanelContainer:setVisible(true)
    self.personalPanelContainer:setVisible(true)
    if self.columnSeparator then self.columnSeparator:setVisible(true) end

    -- Avatar
    if self.detailAvatar ~= nil then
        self.detailAvatar:setImageFilename(g_modDirectory .. "textures/assets/profil_male_1.png")
    end

    -- Identity
    self.employeeName:setText(employee.name)
    self.employeeId:setText(string.format("ID: %d", employee.id))

    -- Trait (subtitle under name)
    if self.employeeTrait ~= nil then
        local traitName = employee.getTraitName and employee:getTraitName() or nil
        self.employeeTrait:setText(traitName or g_i18n:getText("em_none"))
    end

    -- Status
    local statusKey = employee.isHired and "em_status_hired" or "em_status_available"
    self.employeeStatusValue:setText(g_i18n:getText(statusKey))

    -- Skills with progress bars
    self:displaySkills(employee)

    -- Work stats (conditionally visible)
    local isHired = employee.isHired
    if self.workStatsSection then
        self.workStatsSection:setVisible(isHired)
    end
    if isHired then
        self:displayWorkStats(employee)
    end

    -- Traits list
    if self.txtTraitsList then
        local traitName = employee.getTraitName and employee:getTraitName() or nil
        self.txtTraitsList:setText(traitName or g_i18n:getText("em_none"))
    end

    -- Wage
    local wage = employee.getDailyWage and employee:getDailyWage() or 0
    self.employeeWageValue:setText(g_i18n:formatMoney(wage, 0, true, false))

    -- Personal info (right column)
    self:displayPersonalInfo(employee)
end

function MenuEmployeeManager:setStatusBarValue(barElement, value)
    if barElement == nil or barElement.parent == nil then return end
    local fullWidth = barElement.parent.absSize[1] - (barElement.margin[1] or 0) * 2
    local minSize = 0
    if barElement.startSize ~= nil then
        minSize = barElement.startSize[1] + barElement.endSize[1]
    end
    local clampedValue = math.max(0, math.min(1, value))
    barElement:setSize(math.max(minSize, fullWidth * clampedValue), nil)
end

function MenuEmployeeManager:displaySkills(employee)
    local skills = employee.skills or { driving = 1, harvesting = 1, technical = 1 }
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

function MenuEmployeeManager:displayWorkStats(employee)
    if self.statHoursWorked then
        local hours = employee.workTime or 0
        self.statHoursWorked:setText(string.format("%.1f h", hours))
    end

    if self.statCurrentJob then
        if employee.currentJob then
            local jobType = employee.currentJob.workType or employee.currentJob.type or "Unknown"
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

    -- Assigned field
    if self.txtAssignedField then
        if employee.targetFieldId then
            self.txtAssignedField:setText(string.format("Field %d", employee.targetFieldId))
        else
            self.txtAssignedField:setText(g_i18n:getText("em_none"))
        end
    end

    -- Fatigue
    if self.statFatigue then
        local fatigue = employee.fatigueLevel or 0
        if employee.isOnBreak then
            self.statFatigue:setText(g_i18n:getText("em_status_on_break"))
        elseif fatigue >= 80 then
            self.statFatigue:setText(string.format("%.0f%% - %s", fatigue, g_i18n:getText("em_status_exhausted")))
        elseif fatigue >= 50 then
            self.statFatigue:setText(string.format("%.0f%% - %s", fatigue, g_i18n:getText("em_status_tired")))
        else
            self.statFatigue:setText(string.format("%.0f%%", fatigue))
        end
    end
end

function MenuEmployeeManager:displayPersonalInfo(employee)
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

function MenuEmployeeManager:onHireEmployee()
    local employee = self:getSelectedItem()
    if employee == nil then return end
    YesNoDialog.show(
        function(_, yes)
            if yes then
                g_employeeManager:hireEmployee(employee.id)
                self:updateContent()
            end
        end,
        self,
        string.format(g_i18n:getText("em_dialog_hire_yes_no"), employee.name),
        g_i18n:getText("em_dialog_hire_yes_no_btn")
    )
end

function MenuEmployeeManager:onOpenWorkflowEditor()
    if g_emGui ~= nil then
        g_gui:showGui("EMGui")
    elseif g_workflowEditor then
        g_workflowEditor:show()
    end
end

function MenuEmployeeManager:onFireEmployee()
    local employee = self:getSelectedItem()
    if employee == nil then return end
    YesNoDialog.show(
        function(_, yes)
            if yes then
                g_employeeManager:fireEmployee(employee.id)
                self:updateContent()
            end
        end,
        self,
        string.format(g_i18n:getText("em_dialog_fire_yes_no"), employee.name),
        g_i18n:getText("em_dialog_fire_yes_no_btn")
    )
end

function MenuEmployeeManager:updateMenuButtons()
    if self.buttonSets == nil or self.menuButtonInfo == nil then return end

    local listType   = self.currentListType or MenuEmployeeManager.LIST_TYPE.NEW
    local baseButtons = self.buttonSets[listType] or { self.btnBack }
    local item        = self:getSelectedItem()

    local filtered = {}
    for _, btn in ipairs(baseButtons) do
        if self:shouldShowButton(btn, listType, item) then
            table.insert(filtered, btn)
        end
    end
    self.menuButtonInfo.employees = filtered
    self:setMenuButtonInfoDirty()
end

function MenuEmployeeManager:shouldShowButton(button, listType, item)
    if button == self.btnBack then return true end
    return item ~= nil
end

function MenuEmployeeManager:getMenuButtonInfo()
    return self.menuButtonInfo.employees or { self.btnBack }
end

function MenuEmployeeManager:onMoneyChange()
    if g_localPlayer == nil or g_farmManager == nil then return end
    local farm = g_farmManager:getFarmById(g_localPlayer.farmId)
    if farm == nil then return end

    local isNegative = farm.money <= -1
    local profileName = "fs25_shopMoney"

    if ShopMenu and ShopMenu.GUI_PROFILE then
        profileName = isNegative
            and ShopMenu.GUI_PROFILE.SHOP_MONEY_NEGATIVE
            or  ShopMenu.GUI_PROFILE.SHOP_MONEY
    elseif isNegative then
        profileName = "fs25_shopMoneyNegative"
    end

    if self.currentBalanceText then
        self.currentBalanceText:applyProfile(profileName, nil, true)
        self.currentBalanceText:setText(g_i18n:formatMoney(farm.money, 0, true, false))
    end
end
