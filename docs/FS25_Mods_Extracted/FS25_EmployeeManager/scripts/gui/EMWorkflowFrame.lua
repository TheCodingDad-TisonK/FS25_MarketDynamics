EMWorkflowFrame = {}

local EMWorkflowFrame_mt = Class(EMWorkflowFrame, TabbedMenuFrameElement)

EMWorkflowFrame.TASK_REQUIREMENTS = {
    ROLL       = { skill = "driving",    level = 1 },
    MULCH      = { skill = "driving",    level = 1 },
    SOW        = { skill = "driving",    level = 2 },
    CULTIVATE  = { skill = "driving",    level = 3 },
    RIDGING    = { skill = "driving",    level = 3 },
    PLOW       = { skill = "driving",    level = 4 },
    LIME       = { skill = "technical",  level = 1 },
    WEED       = { skill = "technical",  level = 2 },
    STONES     = { skill = "technical",  level = 2 },
    FERTILIZE  = { skill = "technical",  level = 3 },
    TEDDER     = { skill = "harvesting", level = 1 },
    MOW        = { skill = "harvesting", level = 2 },
    WINDROWER  = { skill = "harvesting", level = 3 },
    HARVEST    = { skill = "harvesting", level = 4 },
    MULCH_LEAVES = { skill = "driving",  level = 1 },
}

EMWorkflowFrame.MENU_ICON_SLICE_ID = 'EM_IconWorkflow'

function EMWorkflowFrame:new()
    local self = TabbedMenuFrameElement.new(nil, EMWorkflowFrame_mt)

    self.availableTasksRenderer = TaskListItemRenderer.new(self)
    self.queueTasksRenderer     = TaskListItemRenderer.new(self)

    self.hiredEmployees = {}
    self.ownedFields    = {}
    self.ownedVehicles  = {}
    self.menuButtonInfo = {}

    return self
end

function EMWorkflowFrame:copyAttributes(src)
    EMWorkflowFrame:superClass().copyAttributes(self, src)
end

function EMWorkflowFrame:initialize()
    self.backButtonInfo = { inputAction = InputAction.MENU_BACK }
    self.saveButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_ACTIVATE,
        text        = g_i18n:getText("em_btn_save"),
        callback    = function() self:onSave() end,
    }
    self.saveStartButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_1,
        text        = g_i18n:getText("em_btn_save_start"),
        callback    = function() self:onSaveAndStart() end,
    }
    self.stopButtonInfo = {
        profile     = "buttonActivate",
        inputAction = InputAction.MENU_EXTRA_2,
        text        = g_i18n:getText("em_btn_stop"),
        callback    = function() self:onStop() end,
    }

    local hourTexts = {}
    for h = 0, 23 do
        table.insert(hourTexts, string.format("%02d:00", h))
    end
    if self.shiftStartSelector then
        self.shiftStartSelector:setTexts(hourTexts)
    end
    if self.shiftEndSelector then
        self.shiftEndSelector:setTexts(hourTexts)
    end
end

function EMWorkflowFrame:onGuiSetupFinished()
    EMWorkflowFrame:superClass().onGuiSetupFinished(self)

    self.employeeList:setDataSource(self)
    self.employeeList:setDelegate(self)

    if self.availableTasksList then
        self.availableTasksList:setDataSource(self.availableTasksRenderer)
        self.availableTasksList:setDelegate(self.availableTasksRenderer)
    end
    if self.queueList then
        self.queueList:setDataSource(self.queueTasksRenderer)
        self.queueList:setDelegate(self.queueTasksRenderer)
    end
end

function EMWorkflowFrame:onFrameOpen()
    EMWorkflowFrame:superClass().onFrameOpen(self)

    self:debugDumpElements()

    self:refreshData()

    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.employeeList)
    self:setSoundSuppressed(false)
end

function EMWorkflowFrame:debugDumpElements()
    CustomUtils:info("=== [EMWorkflowFrame] DEBUG DUMP ===")

    local ids = {
        "mainBox", "employeeList", "employeesContainer", "fieldSelector", "vehicleSelector",
        "shiftStartSelector", "shiftEndSelector", "barSkillDriving", "barSkillHarvesting",
        "barSkillTechnical", "txtSkillDrivingLevel", "txtSkillHarvestingLevel",
        "txtSkillTechnicalLevel", "availableTasksList", "queueList", "txtStatusMessage", "emptyText",
    }
    for _, id in ipairs(ids) do
        local el = self[id]
        if el ~= nil then
            local typeName = el.typeName or el.name or "?"
            local visible = "?"
            if el.getIsVisible then visible = tostring(el:getIsVisible()) end
            CustomUtils:info("  [OK] self.%-25s => type=%-20s visible=%s", id, typeName, visible)
        else
            CustomUtils:info("  [MISSING] self.%s => nil", id)
        end
    end

    CustomUtils:info("--- Child element tree ---")
    self:debugDumpTree(self, 0, 3)

    CustomUtils:info("=== END DEBUG DUMP ===")
end

function EMWorkflowFrame:debugDumpTree(element, depth, maxDepth)
    if depth > maxDepth then return end
    if element == nil then return end

    local indent = string.rep("  ", depth)
    local id = element.id or "(no id)"
    local profile = element.profile or "(no profile)"
    local typeName = element.typeName or "(unknown)"
    local visible = "?"
    if element.getIsVisible then visible = tostring(element:getIsVisible()) end

    CustomUtils:info("%s[%s] id=%s profile=%s visible=%s", indent, typeName, id, profile, visible)

    if element.elements then
        for _, child in ipairs(element.elements) do
            self:debugDumpTree(child, depth + 1, maxDepth)
        end
    end
end

function EMWorkflowFrame:onFrameClose()
    EMWorkflowFrame:superClass().onFrameClose(self)
    self.hiredEmployees = {}
    self.ownedFields    = {}
    self.ownedVehicles  = {}
end

function EMWorkflowFrame:refresh()
    -- Called by EMGui:onOpen() to pre-load data
end

function EMWorkflowFrame:getNumberOfSections()
    return 1
end

function EMWorkflowFrame:getNumberOfItemsInSection(list, section)
    return #self.hiredEmployees
end

function EMWorkflowFrame:getTitleForSectionHeader(list, section)
    return ""
end

function EMWorkflowFrame:populateCellForItemInSection(list, section, index, cell)
    local emp = self.hiredEmployees[index]
    if emp == nil then return end

    local titleEl    = cell:getAttribute("title")
    local subtitleEl = cell:getAttribute("subtitle")
    local avatarEl   = cell:getAttribute("avatar")
    local iconEl     = cell:getAttribute("icon")

    -- Show avatar, hide atlas icon
    if avatarEl then
        avatarEl:setImageFilename(g_modDirectory .. "textures/assets/profil_male_1.png")
        avatarEl:setVisible(true)
    end
    if iconEl then
        iconEl:setVisible(false)
    end

    if titleEl then
        titleEl:setText(string.format("%s (ID:%d)", emp.name, emp.id))
    end
    if subtitleEl then
        local skills = emp.skills or {}
        subtitleEl:setText(string.format("D:%d H:%d T:%d",
            skills.driving or 1, skills.harvesting or 1, skills.technical or 1))
    end
end

function EMWorkflowFrame:onListSelectionChanged(list, section, index)
    local emp = self.hiredEmployees[index]
    if emp then
        if self.mainBox then self.mainBox:setVisible(true) end
        self:loadEmployeeData(emp)
    else
        if self.mainBox then self.mainBox:setVisible(false) end
    end
    self:updateMenuButtons()
end

function EMWorkflowFrame:refreshData()
    if g_employeeManager == nil then
        self.hiredEmployees = {}
    else
        self.hiredEmployees = g_employeeManager:getHiredEmployees()
    end

    self.employeeList:reloadData()

    local hasEmployees = #self.hiredEmployees > 0

    if self.employeesContainer then self.employeesContainer:setVisible(hasEmployees) end
    if self.mainBox then self.mainBox:setVisible(false) end
    if self.emptyText then self.emptyText:setVisible(not hasEmployees) end

    if not hasEmployees then
        self:updateMenuButtons()
        return
    end

    self.ownedFields  = self:buildOwnedFieldsList()
    self.ownedVehicles = self:buildOwnedVehiclesList()

    local fieldTexts = { g_i18n:getText("em_none") }
    for _, f in ipairs(self.ownedFields) do
        table.insert(fieldTexts, f.label)
    end
    if self.fieldSelector then
        self.fieldSelector:setTexts(fieldTexts)
        CustomUtils:info("[EMWorkflowFrame] fieldSelector set with %d entries", #fieldTexts)
    else
        CustomUtils:warning("[EMWorkflowFrame] fieldSelector is nil! Check XML id binding")
    end

    local vehicleTexts = { g_i18n:getText("em_none") }
    for _, v in ipairs(self.ownedVehicles) do
        table.insert(vehicleTexts, v.label)
    end
    if self.vehicleSelector then
        self.vehicleSelector:setTexts(vehicleTexts)
        CustomUtils:info("[EMWorkflowFrame] vehicleSelector set with %d entries", #vehicleTexts)
    else
        CustomUtils:warning("[EMWorkflowFrame] vehicleSelector is nil! Check XML id binding")
    end

    self.employeeList:setSelectedIndex(1, true, 0)
    if self.mainBox then self.mainBox:setVisible(true) end
    self:loadEmployeeData(self.hiredEmployees[1])
    self:updateMenuButtons()
end

function EMWorkflowFrame:loadEmployeeData(employee)
    if not employee then return end

    local fieldState = 1
    if employee.targetFieldId then
        for i, f in ipairs(self.ownedFields) do
            if f.id == employee.targetFieldId then
                fieldState = i + 1
                break
            end
        end
    end
    if self.fieldSelector then
        self.fieldSelector:setState(fieldState, false)
    end

    local vehicleState = 1
    if employee.assignedVehicleId then
        for i, v in ipairs(self.ownedVehicles) do
            if v.id == employee.assignedVehicleId then
                vehicleState = i + 1
                break
            end
        end
    end
    if self.vehicleSelector then
        self.vehicleSelector:setState(vehicleState, false)
    end

    if self.shiftStartSelector then
        self.shiftStartSelector:setState((employee.shiftStart or 6) + 1, false)
    end
    if self.shiftEndSelector then
        self.shiftEndSelector:setState((employee.shiftEnd or 18) + 1, false)
    end

    self:displaySkills(employee)

    self:refreshAvailableTasks(employee)
    self:refreshQueueList(employee)

    if self.txtStatusMessage then
        self.txtStatusMessage:setText("")
    end
end

function EMWorkflowFrame:refreshAvailableTasks(employee)
    local tasks = {}
    if JobManager and JobManager.WORK_TYPE_TO_CATEGORY then
        for taskName, _ in pairs(JobManager.WORK_TYPE_TO_CATEGORY) do
            if self:canEmployeeDoTask(employee, taskName) then
                table.insert(tasks, { label = taskName, value = taskName })
            end
        end
        table.sort(tasks, function(a, b) return a.label < b.label end)
    end
    self.availableTasksRenderer:setData(tasks)
    if self.availableTasksList then
        self.availableTasksList:reloadData()
    end
end

function EMWorkflowFrame:canEmployeeDoTask(employee, taskName)
    local req = EMWorkflowFrame.TASK_REQUIREMENTS[taskName]
    if not req then return true end
    local skills = employee.skills or {}
    local level = skills[req.skill] or 1
    return level >= req.level
end

function EMWorkflowFrame:refreshQueueList(employee)
    local queue = employee.taskQueue or {}
    local items = {}
    for i, taskName in ipairs(queue) do
        table.insert(items, { label = string.format("%d. %s", i, taskName), value = taskName })
    end
    self.queueTasksRenderer:setData(items)
    if self.queueList then
        self.queueList:reloadData()
    end
end

function EMWorkflowFrame:setStatusBarValue(barElement, value)
    if barElement == nil or barElement.parent == nil then return end
    local fullWidth = barElement.parent.absSize[1] - (barElement.margin[1] or 0) * 2
    local minSize = 0
    if barElement.startSize ~= nil then
        minSize = barElement.startSize[1] + barElement.endSize[1]
    end
    local clampedValue = math.max(0, math.min(1, value))
    barElement:setSize(math.max(minSize, fullWidth * clampedValue), nil)
end

function EMWorkflowFrame:displaySkills(employee)
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

function EMWorkflowFrame:getSelectedEmployee()
    local idx = self.employeeList.selectedIndex
    if idx == nil or idx < 1 or idx > #self.hiredEmployees then return nil end
    return self.hiredEmployees[idx]
end

function EMWorkflowFrame:onFieldChanged()
    local employee = self:getSelectedEmployee()
    if not employee then return end
    local state = self.fieldSelector:getState()
    if state == 1 then
        employee.targetFieldId = nil
    else
        local fieldEntry = self.ownedFields[state - 1]
        if fieldEntry then
            employee.targetFieldId = fieldEntry.id
        end
    end
end

function EMWorkflowFrame:onVehicleChanged()
    local employee = self:getSelectedEmployee()
    if not employee then return end
    local state = self.vehicleSelector:getState()
    if state == 1 then
        employee:unassignVehicle()
    else
        local vehicleEntry = self.ownedVehicles[state - 1]
        if vehicleEntry then
            local vehicle = g_employeeManager:getVehicleById(vehicleEntry.id)
            if vehicle then
                employee:assignVehicle(vehicle)
            end
        end
    end
end

function EMWorkflowFrame:onShiftStartChanged()
    local employee = self:getSelectedEmployee()
    if not employee then return end
    employee.shiftStart = self.shiftStartSelector:getState() - 1
end

function EMWorkflowFrame:onShiftEndChanged()
    local employee = self:getSelectedEmployee()
    if not employee then return end
    employee.shiftEnd = self.shiftEndSelector:getState() - 1
end

function EMWorkflowFrame:onTaskAdd()
    local employee = self:getSelectedEmployee()
    if not employee then return end
    if not self.availableTasksList then return end

    local idx = self.availableTasksList.selectedIndex
    local item = self.availableTasksRenderer.list[idx]
    if item then
        if not employee.taskQueue then employee.taskQueue = {} end
        table.insert(employee.taskQueue, item.value)
        self:refreshQueueList(employee)
    end
end

function EMWorkflowFrame:onTaskRemove()
    local employee = self:getSelectedEmployee()
    if not employee then return end
    if not self.queueList then return end

    local idx = self.queueList.selectedIndex
    if idx > 0 and employee.taskQueue and #employee.taskQueue >= idx then
        table.remove(employee.taskQueue, idx)
        self:refreshQueueList(employee)
    end
end

function EMWorkflowFrame:onTaskUp()
    local employee = self:getSelectedEmployee()
    if not employee or not employee.taskQueue then return end
    if not self.queueList then return end

    local idx = self.queueList.selectedIndex
    if idx > 1 then
        local tmp = employee.taskQueue[idx]
        employee.taskQueue[idx] = employee.taskQueue[idx - 1]
        employee.taskQueue[idx - 1] = tmp
        self:refreshQueueList(employee)
        self.queueList:setSelectedIndex(idx - 1)
    end
end

function EMWorkflowFrame:onTaskDown()
    local employee = self:getSelectedEmployee()
    if not employee or not employee.taskQueue then return end
    if not self.queueList then return end

    local idx = self.queueList.selectedIndex
    if idx < #employee.taskQueue then
        local tmp = employee.taskQueue[idx]
        employee.taskQueue[idx] = employee.taskQueue[idx + 1]
        employee.taskQueue[idx + 1] = tmp
        self:refreshQueueList(employee)
        self.queueList:setSelectedIndex(idx + 1)
    end
end

function EMWorkflowFrame:onSave()
    local employee = self:getSelectedEmployee()
    if not employee then return end

    local hasFullConfig = employee.targetFieldId and employee.assignedVehicleId and #(employee.taskQueue or {}) > 0

    if hasFullConfig then
        employee.isAutonomous = true
        employee.currentTaskIndex = employee.currentTaskIndex or 1
    end

    if self.txtStatusMessage then
        if hasFullConfig then
            self.txtStatusMessage:setText(string.format(g_i18n:getText("em_workflow_saved_hint"), employee.name))
        else
            self.txtStatusMessage:setText(string.format(g_i18n:getText("em_workflow_saved"), employee.name))
        end
    end
    CustomUtils:info("[EMWorkflowFrame] Saved workflow for %s: %d tasks, field=%s, vehicle=%s, shift=%d-%d, autonomous=%s",
        employee.name, #(employee.taskQueue or {}),
        tostring(employee.targetFieldId), tostring(employee.assignedVehicleId),
        employee.shiftStart or 6, employee.shiftEnd or 18, tostring(employee.isAutonomous)
    )
    self:updateMenuButtons()
end

function EMWorkflowFrame:onSaveAndStart()
    local employee = self:getSelectedEmployee()
    if not employee then return end

    if not employee.targetFieldId then
        if self.txtStatusMessage then
            self.txtStatusMessage:setText(g_i18n:getText("em_error_no_field"))
        end
        return
    end
    if not employee.assignedVehicleId then
        if self.txtStatusMessage then
            self.txtStatusMessage:setText(g_i18n:getText("em_error_no_vehicle"))
        end
        return
    end
    local queue = employee.taskQueue or {}
    if #queue == 0 then
        if self.txtStatusMessage then
            self.txtStatusMessage:setText(g_i18n:getText("em_error_no_tasks"))
        end
        return
    end

    self:onSave()

    local firstTask = queue[1]
    employee.currentTaskIndex = 1
    employee.isAutonomous = true

    local currentHour = 0
    if g_currentMission and g_currentMission.environment then
        currentHour = g_currentMission.environment.currentHour or 0
    end

    if employee:isWithinShift(currentHour) then
        if g_employeeManager.jobManager:startFieldWork(employee, employee.targetFieldId, firstTask) then
            if self.txtStatusMessage then
                self.txtStatusMessage:setText(string.format(g_i18n:getText("em_workflow_started"),
                    employee.name, employee.targetFieldId, firstTask))
            end
        else
            if self.txtStatusMessage then
                self.txtStatusMessage:setText(string.format(g_i18n:getText("em_workflow_start_failed"), employee.name))
            end
        end
    else
        if self.txtStatusMessage then
            self.txtStatusMessage:setText(string.format(
                g_i18n:getText("em_workflow_scheduled"), employee.name, employee.shiftStart or 6))
        end
        CustomUtils:info("[EMWorkflowFrame] %s scheduled: outside shift hours (%d:00, shift starts at %d:00)",
            employee.name, currentHour, employee.shiftStart or 6)
    end
end

function EMWorkflowFrame:onStop()
    local employee = self:getSelectedEmployee()
    if not employee then return end

    employee.isAutonomous = false

    if employee.currentJob then
        if g_employeeManager and g_employeeManager.jobManager then
            g_employeeManager.jobManager:stopJob(employee)
        end
    end

    if self.txtStatusMessage then
        self.txtStatusMessage:setText(string.format(g_i18n:getText("em_workflow_stopped"), employee.name))
    end
    CustomUtils:info("[EMWorkflowFrame] Stopped autonomous mode for %s", employee.name)
    self:updateMenuButtons()
end

function EMWorkflowFrame:buildOwnedFieldsList()
    local fields = {}
    local farmId = g_currentMission:getFarmId()

    if g_fieldManager ~= nil then
        local allFields = {}
        if g_fieldManager.getFields then
            allFields = g_fieldManager:getFields()
        elseif g_fieldManager.fields then
            allFields = g_fieldManager.fields
        end

        for _, field in pairs(allFields) do
            if field ~= nil then
                local owner = nil
                if field.getOwner then
                    owner = field:getOwner()
                elseif field.getFarmland then
                    local farmland = field:getFarmland()
                    if farmland then
                        owner = g_farmlandManager:getFarmlandOwner(farmland.id)
                    end
                end

                if owner == farmId then
                    local fieldId = field.getId and field:getId() or field.fieldId or 0
                    local area = field.getAreaHa and field:getAreaHa() or field.fieldArea or 0
                    table.insert(fields, {
                        id    = fieldId,
                        label = string.format("Field %d (%.1f ha)", fieldId, area),
                    })
                end
            end
        end
    end

    table.sort(fields, function(a, b) return a.id < b.id end)
    CustomUtils:info("[EMWorkflowFrame] Found %d owned fields", #fields)
    return fields
end

function EMWorkflowFrame:buildOwnedVehiclesList()
    local vehicles = {}
    local farmId = g_currentMission:getFarmId()

    if g_currentMission.vehicleSystem ~= nil and g_currentMission.vehicleSystem.vehicles ~= nil then
        for _, vehicle in ipairs(g_currentMission.vehicleSystem.vehicles) do
            local ownerFarmId = nil
            if vehicle.getOwnerFarmId then
                ownerFarmId = vehicle:getOwnerFarmId()
            else
                ownerFarmId = vehicle.ownerFarmId
            end

            local isEnterable = false
            if vehicle.getIsEnterable then
                isEnterable = vehicle:getIsEnterable()
            elseif vehicle.getIsDrivable then
                isEnterable = vehicle:getIsDrivable()
            end

            if ownerFarmId == farmId and isEnterable then
                local name = "Vehicle"
                if vehicle.getFullName then
                    name = vehicle:getFullName()
                elseif vehicle.getName then
                    name = vehicle:getName()
                end
                table.insert(vehicles, {
                    id    = vehicle.id,
                    label = name,
                })
            end
        end
    end

    table.sort(vehicles, function(a, b) return a.label < b.label end)
    CustomUtils:info("[EMWorkflowFrame] Found %d owned vehicles", #vehicles)
    return vehicles
end

function EMWorkflowFrame:updateMenuButtons()
    local employee = self:getSelectedEmployee()
    local hasSelection = employee ~= nil

    self.menuButtonInfo = { self.backButtonInfo }
    if hasSelection then
        table.insert(self.menuButtonInfo, self.saveButtonInfo)
        if employee.isAutonomous then
            table.insert(self.menuButtonInfo, self.stopButtonInfo)
        else
            table.insert(self.menuButtonInfo, self.saveStartButtonInfo)
        end
    end

    self:setMenuButtonInfoDirty()
end

function EMWorkflowFrame:getMenuButtonInfo()
    return self.menuButtonInfo
end
