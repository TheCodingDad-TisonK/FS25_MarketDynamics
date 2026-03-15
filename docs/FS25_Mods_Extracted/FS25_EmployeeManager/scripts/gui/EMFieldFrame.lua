EMFieldFrame = {}

local EMFieldFrame_mt = Class(EMFieldFrame, TabbedMenuFrameElement)

function EMFieldFrame:new()
    local self = TabbedMenuFrameElement.new(nil, EMFieldFrame_mt)
    self.fields             = {}
    self.menuButtonInfo     = {}
    self.pendingTargetCrop  = nil
    return self
end

EMFieldFrame.MENU_ICON_SLICE_ID = 'EM_IconField'

function EMFieldFrame:copyAttributes(src)
    EMFieldFrame:superClass().copyAttributes(self, src)
end

function EMFieldFrame:initialize()
    self.backButtonInfo = { inputAction = InputAction.MENU_BACK }
    self.menuButtonInfo = { self.backButtonInfo }

    self.cropNames = {}
    if g_employeeManager and g_employeeManager.cropManager then
        for name, _ in pairs(g_employeeManager.cropManager.crops) do
            table.insert(self.cropNames, name)
        end
        table.sort(self.cropNames)
    end

    if self.targetCropSelector then
        self.targetCropSelector:setTexts(self.cropNames)
    end
end

function EMFieldFrame:onGuiSetupFinished()
    EMFieldFrame:superClass().onGuiSetupFinished(self)
    self.fieldList:setDataSource(self)
    self.fieldList:setDelegate(self)
end

function EMFieldFrame:onFrameOpen()
    EMFieldFrame:superClass().onFrameOpen(self)
    self:rebuildTable()
    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.fieldList)
    self:setSoundSuppressed(false)
end

function EMFieldFrame:onFrameClose()
    EMFieldFrame:superClass().onFrameClose(self)
    self.fields = {}
end

function EMFieldFrame:refresh()
    -- Called by EMGui:onOpen() to pre-load data
end

function EMFieldFrame:getNumberOfSections()
    return 1
end

function EMFieldFrame:getNumberOfItemsInSection(list, section)
    return #self.fields
end

function EMFieldFrame:getTitleForSectionHeader(list, section)
    return ""
end

function EMFieldFrame:populateCellForItemInSection(list, section, index, cell)
    local fieldData = self.fields[index]
    if fieldData == nil then return end

    local titleEl    = cell:getAttribute("title")
    local subtitleEl = cell:getAttribute("subtitle")
    local iconEl     = cell:getAttribute("icon")

    if titleEl then
        titleEl:setText(string.format("Field %d", fieldData.fieldId))
    end
    if subtitleEl then
        subtitleEl:setText(string.format("%.1f ha", fieldData.area))
    end
    if iconEl then
        iconEl:setImageSlice(g_gui.sharedGuiAtlas, "ingameMenu/tab_map")
    end
end

function EMFieldFrame:onListSelectionChanged(list, section, index)
    self:displayFieldDetails(index)
    self:updateMenuButtons()
end

function EMFieldFrame:rebuildTable()
    self.fields = self:buildOwnedFieldsList()

    self.fieldList:reloadData()

    local hasItems = #self.fields > 0
    if self.mainBox   then self.mainBox:setVisible(hasItems) end
    if self.emptyText then self.emptyText:setVisible(not hasItems) end

    if hasItems then
        self.fieldList:setSelectedIndex(1, true, 0)
        self:displayFieldDetails(1)
    else
        self:clearDetails()
    end

    self:updateMenuButtons()
end

function EMFieldFrame:buildOwnedFieldsList()
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
                        fieldId  = fieldId,
                        area     = area,
                        fieldRef = field,
                    })
                end
            end
        end
    end

    table.sort(fields, function(a, b) return a.fieldId < b.fieldId end)
    return fields
end

function EMFieldFrame:displayFieldDetails(index)
    local fieldData = self.fields[index]
    if fieldData == nil then
        self:clearDetails()
        return
    end

    if self.detailPanel then self.detailPanel:setVisible(true) end

    if self.txtFieldId then
        self.txtFieldId:setText(string.format("Field %d", fieldData.fieldId))
    end
    if self.txtFieldArea then
        self.txtFieldArea:setText(string.format("%.2f ha", fieldData.area))
    end

    local cropName, growthText = self:getFieldCropInfo(fieldData.fieldRef)
    if self.txtCurrentCrop then
        self.txtCurrentCrop:setText(cropName)
    end
    if self.txtGrowthState then
        self.txtGrowthState:setText(growthText)
    end

    if self.targetCropSelector then
        local targetCrop = g_employeeManager:getFieldTargetCrop(fieldData.fieldId)
        local state = 1
        if targetCrop then
            for i, name in ipairs(self.cropNames) do
                if name == targetCrop then
                    state = i
                    break
                end
            end
        end
        self.targetCropSelector:setState(state, false)
    end

    self.pendingTargetCrop = nil

    local conditionText = self:getFieldCondition(fieldData.fieldRef)
    if self.txtFieldCondition then
        self.txtFieldCondition:setText(conditionText)
    end

    local employee = self:getAssignedEmployee(fieldData.fieldId)
    if employee then
        if self.assignedEmployeeSection then self.assignedEmployeeSection:setVisible(true) end
        if self.txtNoEmployee then self.txtNoEmployee:setVisible(false) end
        self:displayAssignedEmployee(employee)
    else
        if self.assignedEmployeeSection then self.assignedEmployeeSection:setVisible(false) end
        if self.txtNoEmployee then
            self.txtNoEmployee:setVisible(true)
            self.txtNoEmployee:setText(g_i18n:getText("em_none"))
        end
    end
end

function EMFieldFrame:getFieldCropInfo(field)
    if field == nil then return g_i18n:getText("em_none"), "" end

    local fruitTypeIndex = nil
    local growthState = nil

    if field.getFieldStatusAtWorldPosition then
        local x, _, z = field:getCenterOfFieldWorldPosition()
        local data = field:getFieldStatusAtWorldPosition(x, z)
        if data then
            fruitTypeIndex = data.fruitTypeIndex
            growthState = data.growthState
        end
    end

    if fruitTypeIndex == nil and FSDensityMapUtil and FSDensityMapUtil.getFieldCropAtWorldPosition then
        local x, _, z = field:getCenterOfFieldWorldPosition()
        fruitTypeIndex, growthState = FSDensityMapUtil.getFieldCropAtWorldPosition(x, z)
    end

    if fruitTypeIndex == nil or fruitTypeIndex == 0 then
        return g_i18n:getText("em_none"), ""
    end

    if FruitType and FruitType.UNKNOWN and fruitTypeIndex == FruitType.UNKNOWN then
        return g_i18n:getText("em_none"), ""
    end

    local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
    if fruitType == nil then
        return g_i18n:getText("em_unknown"), ""
    end

    local cropName = fruitType.name or g_i18n:getText("em_unknown")
    local minHarvest = fruitType.minHarvestingGrowthState or 0
    local growthText = string.format("%d / %d", growthState or 0, minHarvest)

    return cropName, growthText
end

function EMFieldFrame:getFieldCondition(field)
    if field == nil then return g_i18n:getText("em_none") end

    if g_employeeManager and g_employeeManager.cropManager then
        local nextStep, reason = g_employeeManager.cropManager:getNextStep(field, nil)
        if nextStep and nextStep ~= "WAIT" then
            return string.format("%s: %s", nextStep, reason or "")
        elseif nextStep == "WAIT" then
            return g_i18n:getText("em_idle")
        end
    end

    return g_i18n:getText("em_none")
end

function EMFieldFrame:getAssignedEmployee(fieldId)
    if g_employeeManager == nil then return nil end

    local hiredList = g_employeeManager:getHiredEmployees()
    for _, emp in ipairs(hiredList) do
        if emp.targetFieldId == fieldId then
            return emp
        end
    end
    return nil
end

function EMFieldFrame:displayAssignedEmployee(emp)
    -- Name
    if self.txtAssignedEmployee then
        self.txtAssignedEmployee:setText(emp.name or "???")
    end

    -- Status
    if self.txtEmpStatus then
        local statusText
        if emp.isUnpaid then
            statusText = g_i18n:getText("em_status_unpaid")
            self.txtEmpStatus:setTextColor(1, 0.2, 0.2, 1)
        elseif emp.isOnBreak then
            statusText = g_i18n:getText("em_status_on_break")
            self.txtEmpStatus:setTextColor(1, 1, 0, 1)
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
                statusText = emp.currentJob.workType or g_i18n:getText("em_status_working")
            end
            self.txtEmpStatus:setTextColor(0.2, 1, 0.2, 1)
        else
            statusText = g_i18n:getText("em_idle")
            self.txtEmpStatus:setTextColor(1, 1, 1, 0.6)
        end
        self.txtEmpStatus:setText(statusText)
    end

    -- Vehicle
    if self.txtEmpVehicle then
        local vehicleName = g_i18n:getText("em_none")
        if emp.assignedVehicleId and g_employeeManager then
            local vehicle = g_employeeManager:getVehicleById(emp.assignedVehicleId)
            if vehicle then
                local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
                if storeItem then
                    vehicleName = storeItem.name
                else
                    vehicleName = vehicle.typeName or tostring(emp.assignedVehicleId)
                end
            end
        end
        self.txtEmpVehicle:setText(vehicleName)
    end

    -- Shift
    if self.txtEmpShift then
        self.txtEmpShift:setText(string.format("%02d:00 %s %02d:00",
            emp.shiftStart or 6,
            g_i18n:getText("em_shift_to"),
            emp.shiftEnd or 18))
    end

    -- Fatigue
    if self.txtEmpFatigue then
        local fatigue = emp.fatigueLevel or 0
        self.txtEmpFatigue:setText(string.format("%.0f%%", fatigue))
        if fatigue >= 80 then
            self.txtEmpFatigue:setTextColor(1, 0.2, 0.2, 1)
        elseif fatigue >= 60 then
            self.txtEmpFatigue:setTextColor(1, 0.5, 0, 1)
        elseif fatigue >= 40 then
            self.txtEmpFatigue:setTextColor(1, 1, 0, 1)
        else
            self.txtEmpFatigue:setTextColor(0.2, 1, 0.2, 1)
        end
    end

    -- Skills
    self:displaySkills(emp)

    -- Workflow queue
    if self.txtEmpWorkflow then
        local queue = emp.taskQueue or {}
        if #queue > 0 then
            local parts = {}
            for i, taskName in ipairs(queue) do
                table.insert(parts, string.format("%d. %s", i, taskName))
            end
            self.txtEmpWorkflow:setText(table.concat(parts, " > "))
        else
            self.txtEmpWorkflow:setText(g_i18n:getText("em_none"))
        end
    end

    -- Current task
    if self.txtEmpCurrentTask then
        if emp.currentJob then
            local jobType = emp.currentJob.workType or emp.currentJob.type or "Unknown"
            local jt = emp.currentJob.type
            if jt == "RETURN_TO_PARKING" then
                jobType = g_i18n:getText("em_status_returning")
            elseif jt == "DRIVING_TO_TOOL" then
                jobType = g_i18n:getText("em_status_driving_to_tool")
            elseif jt == "APPROACHING_TOOL" or jt == "ATTACHING_TOOL" then
                jobType = g_i18n:getText("em_status_attaching_tool")
            elseif jt == "RETURNING_TOOL" then
                jobType = g_i18n:getText("em_status_returning_tool")
            end
            local fieldId = emp.currentJob.fieldId
            if fieldId then
                self.txtEmpCurrentTask:setText(string.format("%s (Field %d)", jobType, fieldId))
            else
                self.txtEmpCurrentTask:setText(jobType)
            end
        else
            self.txtEmpCurrentTask:setText(g_i18n:getText("em_idle"))
        end
    end
end

function EMFieldFrame:setStatusBarValue(barElement, value)
    if barElement == nil or barElement.parent == nil then return end
    local fullWidth = barElement.parent.absSize[1] - (barElement.margin[1] or 0) * 2
    local minSize = 0
    if barElement.startSize ~= nil then
        minSize = barElement.startSize[1] + barElement.endSize[1]
    end
    local clampedValue = math.max(0, math.min(1, value))
    barElement:setSize(math.max(minSize, fullWidth * clampedValue), nil)
end

function EMFieldFrame:displaySkills(employee)
    local skills = employee.skills or { driving = 1, harvesting = 1, technical = 1 }
    local maxLevel = SkillSystem.MAX_LEVEL

    local skillDefs = {
        { key = "driving",    barId = "barEmpDriving",    levelId = "txtEmpDrivingLevel" },
        { key = "harvesting", barId = "barEmpHarvesting", levelId = "txtEmpHarvestingLevel" },
        { key = "technical",  barId = "barEmpTechnical",  levelId = "txtEmpTechnicalLevel" },
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

function EMFieldFrame:clearDetails()
    if self.detailPanel then self.detailPanel:setVisible(false) end
    if self.assignedEmployeeSection then self.assignedEmployeeSection:setVisible(false) end
end

function EMFieldFrame:updateMenuButtons()
    self.menuButtonInfo = { self.backButtonInfo }
    self:setMenuButtonInfoDirty()
end

function EMFieldFrame:getMenuButtonInfo()
    return self.menuButtonInfo
end

function EMFieldFrame:onTargetCropChanged(state)
    if self.cropNames[state] then
        self.pendingTargetCrop = self.cropNames[state]
    end
end

function EMFieldFrame:onSaveFieldConfig()
    local index = self.fieldList:getSelectedIndex()
    local fieldData = self.fields[index]
    if fieldData == nil then return end

    if self.pendingTargetCrop then
        g_employeeManager:setFieldTargetCrop(fieldData.fieldId, self.pendingTargetCrop)
        self.pendingTargetCrop = nil
    end
end
