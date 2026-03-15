--
-- AutoDrive Enter Group Name GUI
-- V1.1.0.0
--
-- @author Stephan Schlosser
-- @date 09/06/2019

ADEnterGroupNameGui = {}
ADEnterGroupNameGui.debug = false

local ADEnterGroupNameGui_mt = Class(ADEnterGroupNameGui, DialogElement)

function ADEnterGroupNameGui.new(target)
    local self = DialogElement.new(target, ADEnterGroupNameGui_mt)
    self:include(ADGuiDebugMixin)
    return self
end

function ADEnterGroupNameGui:onOpen()
    self:debugMsg("ADEnterGroupNameGui:onOpen")
    ADEnterGroupNameGui:superClass().onOpen(self)
    self.textInputElement.blockTime = 0
    self.textInputElement:onFocusActivate()
    self.textInputElement:setText("")
end

function ADEnterGroupNameGui:onClickOk()
    self:debugMsg("ADEnterGroupNameGui:onClickOk")
    if  self.textInputElement.text ~= ADGraphManager.debugGroupName then
        -- do not allow user to create debug group
        local groupName = self.textInputElement.text
        groupName = string.gsub(groupName, ",", "_") -- remove separation characters
        groupName = string.gsub(groupName, ";", "_")
        ADGraphManager:addGroup(groupName)
    end
    
    self:onClickBack()
end

function ADEnterGroupNameGui:onEnterPressed(_, isClick)
    self:debugMsg("ADEnterGroupNameGui:onEnterPressed")
    if not isClick then
        self:onClickOk()
    end
end

function ADEnterGroupNameGui:onEscPressed()
    self:debugMsg("ADEnterGroupNameGui:onEscPressed")
    self:onClickBack()
end
