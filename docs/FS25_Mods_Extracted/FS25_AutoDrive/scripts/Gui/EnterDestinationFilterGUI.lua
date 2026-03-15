--
-- AutoDrive Enter filter for destinations shown in drop down menus GUI
-- V1.1.0.0
--
-- @author Stephan Schlosser
-- @date 09/06/2019

ADEnterDestinationFilterGui = {}
ADEnterDestinationFilterGui.debug = false

local ADEnterDestinationFilterGui_mt = Class(ADEnterDestinationFilterGui, DialogElement)

function ADEnterDestinationFilterGui.new(target)
    local self = DialogElement.new(target, ADEnterDestinationFilterGui_mt)
    self:include(ADGuiDebugMixin)
    return self
end

function ADEnterDestinationFilterGui:onOpen()
    self:debugMsg("ADEnterDestinationFilterGui:onOpen")
    ADEnterDestinationFilterGui:superClass().onOpen(self)
    local controlledVehicle = AutoDrive.getControlledVehicle()
    self.textInputElement.blockTime = 0
    self.textInputElement:onFocusActivate()
    if controlledVehicle ~= nil and controlledVehicle.ad ~= nil then
        self.textInputElement:setText(controlledVehicle.ad.destinationFilterText)
    end
end

function ADEnterDestinationFilterGui:onClickOk()
    self:debugMsg("ADEnterDestinationFilterGui:onClickOk")
    ADEnterDestinationFilterGui:superClass().onClickOk(self)
    local controlledVehicle = AutoDrive.getControlledVehicle()
    if controlledVehicle ~= nil and controlledVehicle.ad ~= nil then
        controlledVehicle.ad.destinationFilterText = self.textInputElement.text
    end
    self:onClickBack()
end

function ADEnterDestinationFilterGui:onClickReset()
    self:debugMsg("ADEnterDestinationFilterGui:onClickReset")
    self.textInputElement:setText("")
end

function ADEnterDestinationFilterGui:onEnterPressed(_, isClick)
    self:debugMsg("ADEnterDestinationFilterGui:onEnterPressed")
    if not isClick then
        self:onClickOk()
    end
end

function ADEnterDestinationFilterGui:onEscPressed()
    self:debugMsg("ADEnterDestinationFilterGui:onEscPressed")
    self:onClickBack()
end
