ADRoutesManagerGui = {}
ADRoutesManagerGui.debug = false

local ADRoutesManagerGui_mt = Class(ADRoutesManagerGui, DialogElement)

function ADRoutesManagerGui.new(target)
    local self = DialogElement.new(target, ADRoutesManagerGui_mt)
    self:include(ADGuiDebugMixin)
    self.routes = {}
    return self
end

function ADRoutesManagerGui:onOpen()
    self:debugMsg("ADRoutesManagerGui:onOpen")
    ADRoutesManagerGui:superClass().onOpen(self)
    self.routeList:setDataSource(self)
    self:refreshItems()
end

function ADRoutesManagerGui:getNumberOfItemsInSection(list, section)
    self:debugMsg("ADRoutesManagerGui:getNumberOfItemsInSection")
    if list == self.routeList then
        return #self.routes
    end
end

function ADRoutesManagerGui:populateCellForItemInSection(list, section, index, cell)
    self:debugMsg("ADRoutesManagerGui:populateCellForItemInSection")
    if list == self.routeList then
        cell.attributes.listItemText:setText(self.routes[index].name)
        cell.attributes.listItemDate:setText(self.routes[index].date)
        cell.target = self
    end
end

function ADRoutesManagerGui:refreshItems()
    self:debugMsg("ADRoutesManagerGui:refreshItems")
    self.routes = ADRoutesManager:getRoutes(AutoDrive.loadedMap)
    self.routeList:reloadData()
end

function ADRoutesManagerGui:onDoubleClick(list, section, index, cell)
    -- Copy route name to textInputElement
    self:debugMsg("ADRoutesManagerGui:onDoubleClick")
    self.textInputElement:setText(self.routes[index].name)
end

function ADRoutesManagerGui:onClickSave()
    self:debugMsg("ADRoutesManagerGui:onClickSave")
    local newName = self.textInputElement.text
    if table.f_contains(
            self.routes,
            function(v)
                return v.name == newName
            end
        )
    then
        AutoDrive.showYesNoDialog(
            g_i18n:getText("gui_ad_routeExportWarn_title"),
            g_i18n:getText("gui_ad_routeExportWarn_text"),
            self.onExportDialogCallback,
            self
        )
    else
        self:onExportDialogCallback(true)
    end
end

function ADRoutesManagerGui:onExportDialogCallback(yes)
    self:debugMsg("ADRoutesManagerGui:onExportDialogCallback")
    if yes then
        ADRoutesManager:export(self.textInputElement.text)
        self:refreshItems()
    end
end

function ADRoutesManagerGui:onClickLoad()
    self:debugMsg("ADRoutesManagerGui:onClickLoad")
    if #self.routes > 0 then
        ADRoutesManager:import(self.routes[self.routeList:getSelectedIndexInSection()].name)
        self:onClickBack()
    end
end

function ADRoutesManagerGui:onClickDelete()
    self:debugMsg("ADRoutesManagerGui:onClickDelete")
    if #self.routes > 0 then
        local idx = self.routeList:getSelectedIndexInSection()
        AutoDrive.showYesNoDialog(
            g_i18n:getText("gui_ad_routeDeleteWarn_title"),
            g_i18n:getText("gui_ad_routeDeleteWarn_text"):format(self.routes[idx].name),
            self.onDeleteDialogCallback,
            self,
            idx
        )
    end
end

function ADRoutesManagerGui:onDeleteDialogCallback(yes, idx)
    self:debugMsg("ADRoutesManagerGui:onDeleteDialogCallback")
    if yes then
        ADRoutesManager:remove(self.routes[idx].name)
        self:refreshItems()
    end
end

function ADRoutesManagerGui:onEscPressed()
    -- ESC pressed in textInputElement, close dialog
    self:debugMsg("ADRoutesManagerGui:onEscPressed")
    self:onClickBack()
end
