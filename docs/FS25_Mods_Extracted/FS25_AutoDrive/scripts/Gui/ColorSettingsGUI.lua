ADColorSettingsGui = {}
ADColorSettingsGui.debug = false

local ADColorSettingsGui_mt = Class(ADColorSettingsGui, DialogElement)

function ADColorSettingsGui.new(target)
    local self = DialogElement.new(target, ADColorSettingsGui_mt)
    self:include(ADGuiDebugMixin)
    self.listItems = {}
    return self
end

function ADColorSettingsGui:onOpen()
    self:debugMsg("ADColorSettingsGui:onOpen")
    ADColorSettingsGui:superClass().onOpen(self)
    self.colorList:setDataSource(self)
    self:refreshItems()
end

function ADColorSettingsGui:getNumberOfItemsInSection(list, section)
    self:debugMsg("ADColorSettingsGui:getNumberOfItemsInSection")
    if list == self.colorList then
        return #self.listItems
    end
end

function ADColorSettingsGui:populateCellForItemInSection(list, section, index, cell)
    self:debugMsg("ADColorSettingsGui:populateCellForItemInSection")
    if list == self.colorList then
        local item = self.listItems[index]
        cell.attributes.listItemText:setText(item.listItemText)
        cell.target = self
    end
end

function ADColorSettingsGui:refreshItems()
    self:debugMsg("ADColorSettingsGui:refreshItems")
    self.listItems = {}
    local colorKeys = AutoDrive:getColorKeyNames()
    for _ , v in pairs(colorKeys) do
        table.insert(self.listItems, {key = v, listItemText = g_i18n:getText(v)})
    end
    table.sort(
        self.listItems,
        function(a, b)
            return a.listItemText < b.listItemText
        end
    )
    self.colorList:reloadData()
end

function ADColorSettingsGui:assignColor(index)
    self:debugMsg("ADColorSettingsGui:assignColor index %d", index)
    local controlledVehicle = AutoDrive.getControlledVehicle()
    if controlledVehicle == nil or controlledVehicle.ad == nil or controlledVehicle.ad.selectedColorNodeId == nil then
        self:debugMsg("ADColorSettingsGui:assignColor no color node id")
        return
    end

    local colorPoint = ADGraphManager:getWayPointById(controlledVehicle.ad.selectedColorNodeId)
    if colorPoint == nil or colorPoint.colors == nil then
        self:debugMsg("ADColorSettingsGui:assignColor no colors")
        return
    end

    local colorKeyName = self.listItems[index].key
    self:debugMsg("ADColorSettingsGui:assignColor colorKeyName %s ", tostring(colorKeyName))
    AutoDrive:setColorAssignment(colorKeyName, colorPoint.colors[1], colorPoint.colors[2], colorPoint.colors[3])
    AutoDrive.writeLocalSettingsToXML()
end

function ADColorSettingsGui:onDoubleClick(list, section, index, cell)
    self:debugMsg("ADColorSettingsGui:onDoubleClick")
    if index > 0 and index <= #self.listItems then
        self:assignColor(index)
    end
end

function ADColorSettingsGui:onClickSave()
    self:debugMsg("ADColorSettingsGui:onClickSave")
    if #self.listItems > 0 then
        local index = self.colorList:getSelectedIndexInSection()
        self:assignColor(index)
    end
    self:onClickBack()
end

function ADColorSettingsGui:onClickResetSelected()
    self:debugMsg("ADColorSettingsGui:onClickResetSelected")
    if #self.listItems > 0 then
        local index = self.colorList:getSelectedIndexInSection()
        local colorKeyName = self.listItems[index].key
        AutoDrive:resetColorAssignment(colorKeyName)
        AutoDrive.writeLocalSettingsToXML()
    end
    self:onClickBack()
end
