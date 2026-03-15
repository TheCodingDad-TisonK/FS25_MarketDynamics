--
-- AutoDrive Enter Target Name GUI
-- V1.1.0.0
--
-- @author Stephan Schlosser
-- @date 08/08/2019

ADEnterTargetNameGui = {}
ADEnterTargetNameGui.debug = false

local ADEnterTargetNameGui_mt = Class(ADEnterTargetNameGui, DialogElement)

function ADEnterTargetNameGui.new(target)
    local self = DialogElement.new(target, ADEnterTargetNameGui_mt)
    self:include(ADGuiDebugMixin)
    self.editName = nil
    self.editId = nil
    self.edit = false
    return self
end

function ADEnterTargetNameGui:onOpen()
    self:debugMsg("ADEnterTargetNameGui:onOpen")
    ADEnterTargetNameGui:superClass().onOpen(self)
    self.textInputElement.blockTime = 0
    self.textInputElement:onFocusActivate()
    self.editName = nil
    self.editId = nil
    self.edit = false
    local controlledVehicle = AutoDrive.getControlledVehicle()
    -- If editSelectedMapMarker is true, we have to edit the map marker selected on the pull down list otherwise we can go for closest waypoint
    if controlledVehicle then
        if AutoDrive.editSelectedMapMarker ~= nil and AutoDrive.editSelectedMapMarker == true then
            self.editId = controlledVehicle.ad.stateModule:getFirstMarkerId()
            self.editName = ADGraphManager:getMapMarkerById(self.editId).name
        else
            local closest, _ = controlledVehicle:getClosestWayPoint()
            if closest ~= nil and closest ~= -1 and ADGraphManager:getWayPointById(closest) ~= nil then
                local cId = closest
                for i, mapMarker in pairs(ADGraphManager:getMapMarkers()) do
                    -- If we have already a map marker on this waypoint, we edit it otherwise we create a new one
                    if mapMarker.id == cId then
                        self.editId = i
                        self.editName = mapMarker.name
                        break
                    end
                end
            end
        end
    end

    if self.editId ~= nil and self.editName ~= nil then
        self.edit = true
    end

    if self.edit then
        self.titleElement:setText(g_i18n:getText("gui_ad_enterTargetNameTitle_edit"))
        self.textInputElement:setText(self.editName)
    else
        self.titleElement:setText(g_i18n:getText("gui_ad_enterTargetNameTitle_add"))
        self.textInputElement:setText("")
    end

    self.buttonsCreateElement:setVisible(not self.edit)
    self.buttonsEditElement:setVisible(self.edit)
end

function ADEnterTargetNameGui:onClickOk()
    self:debugMsg("ADEnterTargetNameGui:onClickOk")
    if self.edit then
        ADGraphManager:renameMapMarker(self.textInputElement.text, self.editId)
    else
        ADGraphManager:createMapMarkerOnClosest(AutoDrive.getControlledVehicle(), self.textInputElement.text)
    end
    self:onClickBack()
end

function ADEnterTargetNameGui:onClickDelete()
    self:debugMsg("ADEnterTargetNameGui:onClickDelete")
    ADGraphManager:removeMapMarker(self.editId)
    self:onClickBack()
end

function ADEnterTargetNameGui:onClickReset()
    self:debugMsg("ADEnterTargetNameGui:onClickReset")
    self.textInputElement:setText(self.editName)
end

function ADEnterTargetNameGui:onEnterPressed(_, isClick)
    self:debugMsg("ADEnterTargetNameGui:onEnterPressed")
    if not isClick then
        self:onClickOk()
    end
end

function ADEnterTargetNameGui:onEscPressed()
    self:debugMsg("ADEnterTargetNameGui:onEscPressed")
    self:onClickBack()
end
