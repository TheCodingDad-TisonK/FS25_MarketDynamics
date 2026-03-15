--
-- AutoDrive GUI
-- V1.0.0.0
--
-- @author TyKonKet
-- @date 03/12/2019

ADDebugSettingsPage = {}
ADDebugSettingsPage.debug = false

local ADDebugSettingsPage_mt = Class(ADDebugSettingsPage, TabbedMenuFrameElement)

function ADDebugSettingsPage.new(target)
    local self = TabbedMenuFrameElement.new(target, ADDebugSettingsPage_mt)
    self:include(ADGuiDebugMixin)
    self.debugElements = {}
    self.isEvenRow = false
    self.lastDebugChannelMask = AutoDrive.currentDebugChannelMask
    return self
end

function ADDebugSettingsPage:onFrameOpen()
    self:debugMsg("ADDebugSettingsPage:onFrameOpen")
    ADDebugSettingsPage:superClass().onFrameOpen(self)
    self:updateDebugElements()
	FocusManager:setFocus(self.boxLayout)
end

function ADDebugSettingsPage:onCreateAutoDriveDebugSettingRow(element, channel)
    self:debugMsg("ADDebugSettingsPage:onCreateAutoDriveDebugSettingRow, channel=%d, isEvenRow=%s", channel, tostring(self.isEvenRow))
    element:setImageColor(nil, table.unpack(InGameMenuSettingsFrame.COLOR_ALTERNATING[self.isEvenRow]))
    self.isEvenRow = not self.isEvenRow

    element.toggle = element.elements[1]
    element.toggle.debugChannel = tonumber(channel)
    table.insert(self.debugElements, element)
end

function ADDebugSettingsPage:update(dt)
    ADDebugSettingsPage:superClass().update(self, dt)
    if self.lastDebugChannelMask ~= AutoDrive.currentDebugChannelMask then
        self:updateDebugElements()
        self.lastDebugChannelMask = AutoDrive.currentDebugChannelMask
    end
end

function ADDebugSettingsPage:onClickDebug(value, toggle)
    self:debugMsg("ADDebugSettingsPage:onClickDebug, channel=%d", toggle.debugChannel)
    AutoDrive:setDebugChannel(toggle.debugChannel)
end

function ADDebugSettingsPage:updateDebugElements()
    for _, element in pairs(self.debugElements) do        
        local dbgChannel = element.toggle.debugChannel
        if dbgChannel ~= AutoDrive.DC_ALL then
            element.toggle:setIsChecked(AutoDrive.getDebugChannelIsSet(dbgChannel))
        else
            element.toggle:setIsChecked(AutoDrive.currentDebugChannelMask == AutoDrive.DC_ALL)
        end        
    end
end

function ADDebugSettingsPage:hasChanges()
    return false
end
