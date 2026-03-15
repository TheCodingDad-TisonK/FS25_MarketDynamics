--
-- AutoDrive GUI
-- V1.0.0.0
--
-- @author Stephan Schlosser
-- @date 08/04/2019

ADSettingsPage = {}
ADSettingsPage.debug = false

local ADSettingsPage_mt = Class(ADSettingsPage, TabbedMenuFrameElement)

function ADSettingsPage.new(target)
    local self = TabbedMenuFrameElement.new(target, ADSettingsPage_mt)
    self:include(ADGuiDebugMixin)
    self.settingElements = {}
    self.isEvenRow = false
    return self
end

function ADSettingsPage:onFrameOpen()
    self:debugMsg("ADSettingsPage[%s]:onOpen", self.name)
    ADSettingsPage:superClass().onFrameOpen(self)
    if not self:hasChanges() then
        self:loadGUISettings()
    end
    FocusManager:setFocus(self.boxLayout)
end

function ADSettingsPage:onGuiSetupFinished()
    self:debugMsg("ADSettingsPage[%s]:onGuiSetupFinished", self.name)
    ADSettingsPage:superClass().onGuiSetupFinished(self)

    -- set up element text options, BinaryOption does not allow doing this in onCreate.
    for _, element in pairs(self.settingElements) do
        local setting = AutoDrive.settings[element.name]
        local labels = {}
        for i = 1, #setting.texts, 1 do
            if setting.translate == true then
                local text = g_i18n:getText(setting.texts[i])
                local missingText = "Missing"
                if text:sub(1, string.len(missingText)) == missingText then
                    labels[i] = setting.texts[i]
                else
                    labels[i] = text
                end
            else
                labels[i] = setting.texts[i]
            end
        end
        element:setTexts(labels)
    end
end

function ADSettingsPage:onCreateAutoDriveSettingRow(element)
    self:debugMsg("ADSettingsPage[%s]:onCreateAutoDriveSettingRow, isEvenRow=%s", self.name, tostring(self.isEvenRow))
    element:setImageColor(nil, table.unpack(InGameMenuSettingsFrame.COLOR_ALTERNATING[self.isEvenRow]))
    self.isEvenRow = not self.isEvenRow
end

function ADSettingsPage:onCreateAutoDriveSetting(element)
    self:debugMsg("ADSettingsPage[%s]:onCreateAutoDriveSetting name=%s", self.name, element.name)
    self.settingElements[element.name] = element
end

function ADSettingsPage:onOptionChange(state, element)
    self:debugMsg("ADSettingsPage[%s]:onOptionChange, name=%s, state=%s", self.name, element.name, tostring(state))
    local setting = AutoDrive.settings[element.name]
    local controlledVehicle = AutoDrive.getControlledVehicle()
    if setting.isVehicleSpecific and controlledVehicle ~= nil and controlledVehicle.ad ~= nil and controlledVehicle.ad.settings[element.name] ~= nil then
        setting = controlledVehicle.ad.settings[element.name]
    end
    setting.new = state
end

function ADSettingsPage:hasChanges()
    local controlledVehicle = AutoDrive.getControlledVehicle()
    for settingName, _ in pairs(self.settingElements) do
        if AutoDrive.settings[settingName] ~= nil then
            local setting = AutoDrive.settings[settingName]
            if setting.isVehicleSpecific and controlledVehicle ~= nil and controlledVehicle.ad ~= nil and controlledVehicle.ad.settings[settingName] ~= nil then
                setting = controlledVehicle.ad.settings[settingName]
            end
            if setting.new ~= nil and setting.new ~= setting.current then
                self:debugMsg("ADSettingsPage[%s]:hasChanges = true (%s)", self.name, settingName)
                return true
            end
        end
    end
    self:debugMsg("ADSettingsPage[%s]:hasChanges = false", self.name)
    return false
end

function ADSettingsPage:loadGUISettings()
    self:debugMsg("ADSettingsPage[%s]:loadGUISettings", self.name)
    local controlledVehicle = AutoDrive.getControlledVehicle()
    for settingName, _ in pairs(self.settingElements) do
        if AutoDrive.settings[settingName] ~= nil then
            local setting = AutoDrive.settings[settingName]
            if setting.isVehicleSpecific and controlledVehicle ~= nil and controlledVehicle.ad ~= nil and controlledVehicle.ad.settings[settingName] ~= nil then
                setting = controlledVehicle.ad.settings[settingName]
            end
            self:loadGUISetting(settingName, setting.current)
        end
    end
end

function ADSettingsPage:loadGUISetting(settingName, state)
    local element = self.settingElements[settingName]
    element:setState(state, false)
    self:onOptionChange(state, element)
end

