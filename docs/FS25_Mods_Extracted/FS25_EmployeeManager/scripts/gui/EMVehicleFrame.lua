EMVehicleFrame = {}

local EMVehicleFrame_mt = Class(EMVehicleFrame, TabbedMenuFrameElement)

function EMVehicleFrame:new()
    local self = TabbedMenuFrameElement.new(nil, EMVehicleFrame_mt)
    self.vehicles       = {}
    self.menuButtonInfo = {}
    return self
end

EMVehicleFrame.MENU_ICON_SLICE_ID = 'EM_IconVehicle'

function EMVehicleFrame:copyAttributes(src)
    EMVehicleFrame:superClass().copyAttributes(self, src)
end

function EMVehicleFrame:initialize()
    self.backButtonInfo = { inputAction = InputAction.MENU_BACK }
    self.menuButtonInfo = { self.backButtonInfo }
end

function EMVehicleFrame:onGuiSetupFinished()
    EMVehicleFrame:superClass().onGuiSetupFinished(self)
    self.vehicleList:setDataSource(self)
    self.vehicleList:setDelegate(self)
end

function EMVehicleFrame:onFrameOpen()
    EMVehicleFrame:superClass().onFrameOpen(self)
    self:rebuildTable()
    self:setSoundSuppressed(true)
    FocusManager:setFocus(self.vehicleList)
    self:setSoundSuppressed(false)
end

function EMVehicleFrame:onFrameClose()
    EMVehicleFrame:superClass().onFrameClose(self)
    self.vehicles = {}
end

function EMVehicleFrame:refresh()
    -- Called by EMGui:onOpen() to pre-load data
end

function EMVehicleFrame:getNumberOfSections()
    return 1
end

function EMVehicleFrame:getNumberOfItemsInSection(list, section)
    return #self.vehicles
end

function EMVehicleFrame:getTitleForSectionHeader(list, section)
    return ""
end

function EMVehicleFrame:populateCellForItemInSection(list, section, index, cell)
    local vehData = self.vehicles[index]
    if vehData == nil then return end

    local titleEl    = cell:getAttribute("title")
    local subtitleEl = cell:getAttribute("subtitle")
    local iconEl     = cell:getAttribute("icon")

    if titleEl then
        titleEl:setText(vehData.name)
    end
    if subtitleEl then
        local status = vehData.isAIActive and g_i18n:getText("em_status_working") or g_i18n:getText("em_idle")
        subtitleEl:setText(status)
    end
    if iconEl then
        iconEl:setImageSlice(g_gui.sharedGuiAtlas, "ingameMenu/tab_vehicles")
    end
end

function EMVehicleFrame:onListSelectionChanged(list, section, index)
    self:displayVehicleDetails(index)
    self:updateMenuButtons()
end

function EMVehicleFrame:rebuildTable()
    self.vehicles = self:buildOwnedVehiclesList()

    self.vehicleList:reloadData()

    local hasItems = #self.vehicles > 0
    if self.mainBox   then self.mainBox:setVisible(hasItems) end
    if self.emptyText then self.emptyText:setVisible(not hasItems) end

    if hasItems then
        self.vehicleList:setSelectedIndex(1, true, 0)
        self:displayVehicleDetails(1)
    else
        self:clearDetails()
    end

    self:updateMenuButtons()
end

function EMVehicleFrame:buildOwnedVehiclesList()
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
                local isAI = vehicle.getIsAIActive and vehicle:getIsAIActive() or false
                table.insert(vehicles, {
                    id          = vehicle.id,
                    name        = name,
                    vehicleRef  = vehicle,
                    isAIActive  = isAI,
                })
            end
        end
    end

    table.sort(vehicles, function(a, b) return a.name < b.name end)
    return vehicles
end

function EMVehicleFrame:displayVehicleDetails(index)
    local vehData = self.vehicles[index]
    if vehData == nil then
        self:clearDetails()
        return
    end

    if self.detailPanel then self.detailPanel:setVisible(true) end

    local vehicle = vehData.vehicleRef

    if self.txtVehicleName then
        self.txtVehicleName:setText(vehData.name)
    end

    if self.txtAIStatus then
        local statusText = vehData.isAIActive and g_i18n:getText("em_status_working") or g_i18n:getText("em_idle")
        self.txtAIStatus:setText(statusText)
    end

    if self.txtImplements then
        local implText = self:getImplementsText(vehicle)
        self.txtImplements:setText(implText)
    end

    if self.txtAssignedEmployee then
        local empText = self:getAssignedEmployeeText(vehData.id)
        self.txtAssignedEmployee:setText(empText)
    end

    if self.txtSpeed then
        local speed = 0
        if vehicle and vehicle.getLastSpeed then
            speed = vehicle:getLastSpeed()
        end
        self.txtSpeed:setText(string.format("%.0f km/h", speed))
    end
end

function EMVehicleFrame:getImplementsText(vehicle)
    if vehicle == nil then return g_i18n:getText("em_none") end

    local implements = {}
    if vehicle.getAttachedImplements then
        local attached = vehicle:getAttachedImplements()
        if attached then
            for _, impl in pairs(attached) do
                if impl.object and impl.object.getName then
                    table.insert(implements, impl.object:getName())
                end
            end
        end
    end

    if #implements == 0 then
        return g_i18n:getText("em_none")
    end
    return table.concat(implements, ", ")
end

function EMVehicleFrame:getAssignedEmployeeText(vehicleId)
    if g_employeeManager == nil then return g_i18n:getText("em_none") end

    local hiredList = g_employeeManager:getHiredEmployees()
    for _, emp in ipairs(hiredList) do
        if emp.assignedVehicleId == vehicleId then
            return emp.name
        end
    end
    return g_i18n:getText("em_none")
end

function EMVehicleFrame:clearDetails()
    if self.detailPanel then self.detailPanel:setVisible(false) end
end

function EMVehicleFrame:updateMenuButtons()
    self.menuButtonInfo = { self.backButtonInfo }
    self:setMenuButtonInfoDirty()
end

function EMVehicleFrame:getMenuButtonInfo()
    return self.menuButtonInfo
end
